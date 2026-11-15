#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
tools/update_mptune_desc.py

Regenerates concise, assembler-safe `mptune_desc` and `raw_text` fields across all
ECM descriptor JSON databases (`docs/t_lm_descriptors.json`, `docs/t_smec_descriptors.json`, etc.).

Rules enforced:
1. ASxxxx assembler hard limit is 512 characters per line (`    ;mptbldesc <mptune_desc>`).
   With 15 characters for `    ;mptbldesc `, `mptune_desc` is capped at <= 490 characters
   (total line <= 505 characters, leaving a safe margin under 512).
2. Removes leading underscores (`____`) and section headers (`OVERVIEW:` and `| TUNER'S GUIDE:`)
   to maximize usable description space.
3. Combines core overview sentence(s) and actionable tuner's guide sentence(s) without
   mid-sentence truncation.
"""

import json
import os
import re
import sys

MAX_DESC_LEN = 490

CUSTOM_SUMMARIES = {
    'BSTSWS': (
        "BSTSWS defines the hardware input pin bitmask used to toggle Turbonator Switchable Boost "
        "(High/Low Boost): 0x01=Cruise Set (B9), 0x02=Cruise Resume (B10, default), 0x04=A/C Sense (B11), "
        "0x08=Park/Neutral (B12), 0x10=Brake Switch (B13), 0x40=Cruise Enable (B15). Wire a toggle switch "
        "between the chosen pin and ground or 12V to enable dual-stage boost control."
    ),
    'FUELLEANOUTFACTOROFFTHROTTLE': (
        "FuelLeanoutFactorOffThrottle is a signed RPM-dependent fuel pulsewidth modifier curve applied "
        "during closed-throttle deceleration. Values use signed two's complement math: 0x00 is neutral, "
        "0x01-0x7F (+1 to +127) adds fuel, and 0x80-0xFF (-128 to -1) subtracts fuel. To create overrun "
        "exhaust burble on throttle lift, set the 1500-3000 RPM decel points slightly negative "
        "(e.g. 0xFC = -4 or 0xF8 = -8)."
    ),
    'FUELLEANOUTFACTORONTHROTTLE': (
        "FuelLeanoutFactorOnThrottle defines an RPM-dependent signed fuel pulsewidth modifier curve active "
        "during open-throttle driving. Values use signed two's complement math: 0x00 is neutral (stock), "
        "0x01-0x7F (+1 to +127) adds fuel, and 0x80-0xFF (-128 to -1) subtracts fuel. In turbocharged "
        "applications, leave this table at stock zero (0x00) and tune fueling via the primary MAP and WOT tables."
    ),
    'ERMSK2': (
        "ERMSK2 controls diagnostic fault code detection for powertrain solenoid drivers, including "
        "canister purge (Code 31), wastegate solenoid (Code 32), EGR solenoid (Code 33), and fan relay "
        "(Code 35). If disconnecting the factory wastegate solenoid for a manual or aftermarket boost "
        "controller, clear Bit 1 to suppress Fault Code 32."
    ),
    'FUELTR': (
        "FUELTR (stock 0x0311 = 785) calibrates the fuel consumption signal sent from the ECU to the "
        "dashboard Electronic Navigator / trip computer. When installing larger fuel injectors, scale "
        "FUELTR upward proportionally to your injector flow increase so MPG and distance-to-empty "
        "readings remain accurate."
    ),
    'ARADVR': (
        "ARADVR is a 10-point lookup table that blends ignition timing between the warm part-throttle "
        "advance curve (HOTMAP) and the full-throttle advance curve (WOTMAP) as the throttle opens. "
        "Increasing values pulls timing toward the safer WOT curve sooner during mid-throttle boost "
        "spool-up; decreasing values retains higher part-throttle advance longer for crisper response."
    ),
}


def split_sents(text: str):
    if not text:
        return []
    t = re.sub(r'(\d)\.(\d)', r'\1<DOT>\2', text)
    t = re.sub(r'\b(e\.g|i\.e|vs|approx)\.', r'\1<DOT>', t, flags=re.I)
    parts = re.split(r'(?<=[.!?])\s+', t.strip())
    return [re.sub(r'\s+', ' ', p.replace('<DOT>', '.')).strip() for p in parts if p.strip()]


def clean_sent(s: str, short_name: str, full_label: str, long_name: str) -> str:
    if full_label:
        s = re.sub(r'^' + re.escape(full_label) + r'\b', short_name, s, flags=re.I)
    s = re.sub(r'^(' + re.escape(short_name) + r')\s*\([^)]+\)\s+', r'\1 ', s, flags=re.I)
    return s.strip()


def build_short_desc(k: str, v: dict):
    if k in CUSTOM_SUMMARIES:
        raw = CUSTOM_SUMMARIES[k]
        return raw, raw.replace(' ', '_')

    full_label = v.get('full_label', '')
    long_name = v.get('long_name', '')
    ov_s = [clean_sent(s, k, full_label, long_name) for s in split_sents(v.get('overview', ''))]
    tg_s = [clean_sent(s, k, full_label, long_name) for s in split_sents(v.get('tuners_guide', ''))]

    ov_chosen = [ov_s[0]] if ov_s else []
    tg_chosen = []

    # Prioritize fitting TG sentences first after OV[0] so actionable tuning advice is complete
    for s in tg_s:
        cand_tg = ' '.join(tg_chosen + [s])
        cand_all = ' '.join(ov_chosen + [cand_tg]).strip()
        if len(cand_all) <= MAX_DESC_LEN:
            tg_chosen.append(s)
        else:
            break

    # Add additional OV sentences if space remains
    for s in ov_s[1:]:
        cand_ov = ' '.join(ov_chosen + [s])
        cand_all = ' '.join([cand_ov] + tg_chosen).strip()
        if len(cand_all) <= MAX_DESC_LEN:
            ov_chosen.append(s)
        else:
            break

    raw = re.sub(r'\s+', ' ', ' '.join(ov_chosen + tg_chosen)).strip()
    if len(raw) > MAX_DESC_LEN:
        raw = raw[:MAX_DESC_LEN].rsplit(' ', 1)[0].rstrip('.,;:') + '.'
    return raw, raw.replace(' ', '_')


def update_json_file(path: str):
    if not os.path.exists(path):
        print(f"Skipping missing file: {path}")
        return

    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    descriptors = data.get('descriptors', {})
    lengths = []

    for k, v in descriptors.items():
        raw, mp = build_short_desc(k, v)
        if len(mp) > MAX_DESC_LEN:
            raise ValueError(f"{path}:{k} exceeded MAX_DESC_LEN ({len(mp)} > {MAX_DESC_LEN})")
        v['raw_text'] = raw
        v['mptune_desc'] = mp
        lengths.append(len(mp))

    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

    print(
        f"Updated {path}: {len(lengths)} descriptors | "
        f"mptune_desc min={min(lengths)}, avg={sum(lengths)//len(lengths)}, max={max(lengths)} chars "
        f"(max full ';mptbldesc' line = {max(lengths) + 15} chars <= 512)"
    )


def main():
    targets = sys.argv[1:] if len(sys.argv) > 1 else [
        'docs/t_lm_descriptors.json',
        'docs/t_smec_descriptors.json',
    ]
    for t in targets:
        update_json_file(t)


if __name__ == '__main__':
    main()
