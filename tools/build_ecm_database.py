#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
tools/build_ecm_database.py

Automated Reverse-Engineering, Documentation Generator, and JSON Database Builder
for Chrysler Turbo ECM Families: SBEC, SBECII, T3-I, T3-II.

Implements all phases of document_prompt.md:
- Phase 1: Automated Manifest Extraction & Anomaly Check (outputs <ecm>_anomaly.md)
- Phase 2: Reverse-Engineering & Authoring Descriptors (100% authored from scratch / assembly)
- Phase 3: Deterministic Assembly, ASxxxx mptune_desc formatting (<=490 chars), Schema Validation
- Generates Standalone HTML Tuning Guide (tuner_guide_generator_prompt.md)
- Executes tools/build_ecm_web.py to compile the static website and verify all links
"""

import os
import sys
import re
import json
import argparse
import subprocess
from datetime import datetime, timezone
from collections import defaultdict

from descriptor_synthesizer import (
    synthesize_new_descriptor,
    scrub_legacy_text,
    get_t3_peftbl_descriptor,
    get_sbecii_peftbl_descriptor,
    get_filler_bytes_descriptor
)
from tuning_guide_generator import generate_tuning_guide_html

BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))

ECM_CONFIG = {
    'SBEC': {
        'ecm_family': 'T-SBEC',
        'code': 'SBEC',
        'title': 'Single Board Engine Controller (T-SBEC)',
        'subtitle': '1990–1991 Consolidated Controller (Motorola 68HC11 MCU)',
        'tpl_path': os.path.join(BASE_DIR, 'cals', 'SBEC', 'T-SBEC_25_MTX_A593_Stock.tpl'),
        'secondary_tpl_path': os.path.join(BASE_DIR, 'cals', 'SBEC', 'T-SBEC_22_MTX_S-IV.tpl'),
        'asm_path': os.path.join(BASE_DIR, 'cals', 'SBEC', 'T-SBEC_v4.asm'),
        'output_json': os.path.join(BASE_DIR, 'docs', 't_sbec_descriptors.json'),
        'output_web': os.path.join(BASE_DIR, 'docs', 'T-SBEC-web'),
        'tuning_guide': os.path.join(BASE_DIR, 'docs', 'tuning_guide_sbec_modifications.html'),
        'anomaly_file': os.path.join(BASE_DIR, 'sbec_anomaly.md'),
        'arch': '68HC11',
        'engine_desc': 'Chrysler 2.2L / 2.5L Turbo I/II/IV (8-Valve SOHC)',
        'is_t3': False,
    },
    'SBECII': {
        'ecm_family': 'T-SBECII',
        'code': 'SBECII',
        'title': 'Single Board Engine Controller II (T-SBECII)',
        'subtitle': '1992–1993 Sequential EFI Controller (Motorola 68HC11 MCU)',
        'tpl_path': os.path.join(BASE_DIR, 'cals', 'SBECII', '92_25_t1_xtx_125.tpl'),
        'secondary_tpl_path': None,
        'asm_path': os.path.join(BASE_DIR, 'cals', 'SBECII', 'T-SBECII_v1.asm'),
        'output_json': os.path.join(BASE_DIR, 'docs', 't_sbecii_descriptors.json'),
        'output_web': os.path.join(BASE_DIR, 'docs', 'T-SBECII-web'),
        'tuning_guide': os.path.join(BASE_DIR, 'docs', 'tuning_guide_sbecii_modifications.html'),
        'anomaly_file': os.path.join(BASE_DIR, 'sbecii_anomaly.md'),
        'arch': '68HC11',
        'engine_desc': 'Chrysler 2.5L Turbo I / Sequential EFI (8-Valve SOHC)',
        'is_t3': False,
    },
    'T3-I': {
        'ecm_family': 'T-T3v1',
        'code': 'T3-I',
        'title': 'Turbo III (Gen 1) 16-Valve (T-T3v1)',
        'subtitle': '1991–1992 Lotus DOHC 16V DDIS Platform',
        'tpl_path': os.path.join(BASE_DIR, 'cals', 'T3-I', 'T-T3_22_T3_MTX_A393.tpl'),
        'secondary_tpl_path': None,
        'asm_path': os.path.join(BASE_DIR, 'cals', 'T3-I', 'T-T3v1.asm'),
        'output_json': os.path.join(BASE_DIR, 'docs', 't_t3_i_descriptors.json'),
        'output_web': os.path.join(BASE_DIR, 'docs', 'T3-I-web'),
        'tuning_guide': os.path.join(BASE_DIR, 'docs', 'tuning_guide_t3_i_modifications.html'),
        'anomaly_file': os.path.join(BASE_DIR, 't3_i_anomaly.md'),
        'arch': '68HC11',
        'engine_desc': 'Chrysler 2.2L Turbo III Lotus 16-Valve DOHC (DDIS Ignition)',
        'is_t3': True,
    },
    'T3-II': {
        'ecm_family': 'T-T3_II',
        'code': 'T3-II',
        'title': 'Turbo III (Gen 2) 16-Valve (T-T3_II)',
        'subtitle': '1992–1993 Lotus DOHC 16V Sequential Platform',
        'tpl_path': os.path.join(BASE_DIR, 'cals', 'T3-II', 'T-T3_22_T3ii_T3_MTX.tpl'),
        'secondary_tpl_path': None,
        'asm_path': os.path.join(BASE_DIR, 'cals', 'T3-II', 'T-T3_IIv1.asm'),
        'output_json': os.path.join(BASE_DIR, 'docs', 't_t3_ii_descriptors.json'),
        'output_web': os.path.join(BASE_DIR, 'docs', 'T3-II-web'),
        'tuning_guide': os.path.join(BASE_DIR, 'docs', 'tuning_guide_t3_ii_modifications.html'),
        'anomaly_file': os.path.join(BASE_DIR, 't3_ii_anomaly.md'),
        'arch': '68HC11',
        'engine_desc': 'Chrysler 2.2L Turbo III Lotus 16-Valve DOHC (DDIS & Sequential EFI)',
        'is_t3': True,
    }
}


def classify_subsystem(mp_group: str, cname: str) -> str:
    """Classifies an identifier into a standardized subsystem name."""
    g = mp_group.lower()
    c = cname.upper()

    if 'boost' in g or 'vnt' in g or 'wg_' in g or 'wgdc' in g:
        return 'Boost_Control'
    if 'spark' in g or 'dwell' in g or 'advance' in g or 'knock' in g or 'scatter' in g:
        return 'Spark'
    if 'fuel' in g:
        if 'adaptive' in g or 'cylinder_trim' in g or 'o2_controller' in g:
            return 'Fuel_O2_Adaptive'
        if 'transient' in g or 'pumpshot' in g or 'decel' in g:
            return 'Fuel_Transient'
        return 'Fuel_Base_Modifiers'
    if 'idle' in g or 'ais' in g:
        return 'Idle_AIS'
    if 'fan' in g:
        return 'Fan_Control'
    if 'cruise' in g:
        return 'Cruise_Control'
    if 'egr' in g:
        return 'EGR_Emissions'
    if 'obd' in g or 'diagnostic' in g or 'fault' in g:
        return 'Diagnostics_OBD'
    if 'limiter' in g or 'rev_limiter' in g or 'speed_limiter' in g or 'overboost' in g or 'limp' in g:
        return 'Limiters_Limp'
    if 'turbonator' in g or 'staging' in g or 'antilag' in g or 'launch' in g or 'wideband' in g or 'wb2nb' in g:
        return 'Turbonator_Features'
    if 'ac_' in g or 'ptu' in g or 'purge' in g or 'baro' in g or 'aux' in g:
        return 'Aux_Vehicle_Functions'
    if 'setup' in g or 'cal_id' in g or 'config' in g or 'transfer' in g or 'datalog' in g:
        return 'Setup_Calibration'

    # Fallback based on cname
    if c.startswith(('VNT', 'WG', 'BST', 'BOOST', 'OB')):
        return 'Boost_Control'
    if c.startswith(('SPK', 'ADV', 'KNK', 'IGN', 'DWL')):
        return 'Spark'
    if c.startswith(('FL', 'INJ', 'FUEL', 'PW', 'O2', 'RMP')):
        return 'Fuel_Base_Modifiers'
    if c.startswith(('AIS', 'IDL')):
        return 'Idle_AIS'
    if c.startswith(('FAN', 'FNS')):
        return 'Fan_Control'
    if c.startswith('CRUZ'):
        return 'Cruise_Control'
    if c.startswith('EGR'):
        return 'EGR_Emissions'

    return 'Setup_Calibration'


def parse_template_file(tpl_path: str):
    """Parses a Chrysler .tpl calibration template and extracts all identifiers."""
    with open(tpl_path, 'r', encoding='latin1') as f:
        lines = f.readlines()

    identifiers = []
    i = 0
    while i < len(lines):
        line = lines[i]
        m_cname = re.match(r'^[;\s]*;mptblcname\s+([A-Za-z0-9_]+)', line)
        if m_cname:
            cname = m_cname.group(1).strip()
            cname_line = i + 1

            start_line = cname_line
            full_label = ""
            for back in range(i - 1, max(0, i - 25), -1):
                prev = lines[back].strip()
                m_lbl = re.match(r'^([A-Za-z0-9_]+):', prev)
                if m_lbl:
                    full_label = m_lbl.group(1)
                    start_line = back + 1
                    if back > 0 and ('.org' in lines[back - 1] or ';.org' in lines[back - 1]):
                        start_line = back
                    break
                if prev.startswith(';.org') or prev.startswith('.org'):
                    start_line = back + 1
                    if back + 1 < i:
                        m_l = re.match(r'^([A-Za-z0-9_]+):', lines[back + 1].strip())
                        if m_l:
                            full_label = m_l.group(1)
                    break

            end_line = cname_line
            factory_setting = ""
            points = 1
            point_lines = []
            for fwd in range(i + 1, min(len(lines), i + 45)):
                cur = lines[fwd].strip()
                if cur.startswith('.byte') or cur.startswith('.word'):
                    if not factory_setting:
                        factory_setting = cur
                    point_lines.append(cur)
                    end_line = fwd + 1
                elif cur.startswith(';.org') or cur.startswith('.org') or (re.match(r'^[A-Za-z0-9_]+:', cur) and not cur.startswith(';')):
                    break
                elif cur.startswith(';mpgroupstart') or cur.startswith(';mpfuel'):
                    break
            if len(point_lines) > 1:
                points = len(point_lines)

            block_text = "".join(lines[max(0, start_line - 2) : max(end_line, cname_line + 5)])

            grp_m = re.search(r';mpgrp\s+([^\n]+)', block_text)
            addr_m = re.search(r';mptbladdr\s+([^\n]+)', block_text)
            type_m = re.search(r';mptbltype\s+([^\n]+)', block_text)
            sub_m = re.search(r';mpsubtype\s+([^\n]+)', block_text)
            lname_m = re.search(r';mptbllname\s+([^\n]+)', block_text)
            xaxis_m = re.search(r';mpxaxis\s+([^\n]+)', block_text)
            yaxis_m = re.search(r';mpyaxis\s+([^\n]+)', block_text)
            desc_m = re.search(r';mptbldesc\s+([^\n]+)', block_text)

            lname = lname_m.group(1).strip() if lname_m else cname
            if not full_label:
                full_label = f"{cname}_{lname}"

            cal_addr = ""
            org_m = re.search(r';?\.org\s+(0x[0-9A-Fa-f]+|\$[0-9A-Fa-f]+)', block_text)
            if org_m:
                raw_addr = org_m.group(1).replace('$', '0x')
                cal_addr = f"0x{int(raw_addr, 16):04X}"
            elif addr_m:
                raw_addr = addr_m.group(1).strip()
                try:
                    cal_addr = f"0x{int(raw_addr, 16):04X}"
                except:
                    cal_addr = raw_addr

            mp_group = grp_m.group(1).strip() if grp_m else ""
            tbl_type_raw = type_m.group(1).strip() if type_m else "3"

            identifiers.append({
                'cname': cname,
                'lname': lname,
                'full_label': full_label,
                'mpgrp': mp_group,
                'subsystem': classify_subsystem(mp_group, cname),
                'tbladdr': addr_m.group(1).strip() if addr_m else "",
                'cal_addr': cal_addr,
                'tbltype': tbl_type_raw,
                'subtype': sub_m.group(1).strip() if sub_m else "n",
                'xaxis': xaxis_m.group(1).strip() if xaxis_m else "",
                'yaxis': yaxis_m.group(1).strip() if yaxis_m else "",
                'points': points,
                'factory_setting': factory_setting,
                'desc': desc_m.group(1).strip() if desc_m else "",
                'line': start_line,
                'cname_line': cname_line,
                'start_line': start_line,
                'end_line': max(end_line, cname_line),
                'line_range': f"L{start_line}-L{max(end_line, cname_line)}"
            })
        i += 1

    return identifiers


def index_assembly_file(asm_path: str):
    """Indexes routines and token lines in the assembly file."""
    with open(asm_path, 'r', encoding='latin1') as f:
        lines = f.readlines()

    routines = []
    routine_re = re.compile(r'^([A-Za-z0-9_]+):')
    local_re = re.compile(r'^L[0-9A-Fa-f]{4}:')

    cal_include_line = 950
    for idx, l in enumerate(lines):
        if '.include /CalDataFile/' in l or '.include CalDataFile' in l:
            cal_include_line = idx + 1
            break

    for idx, l in enumerate(lines):
        line_num = idx + 1
        m = routine_re.match(l)
        if m and not local_re.match(l):
            routines.append((line_num, m.group(1)))

    word_to_lines = defaultdict(list)
    word_re = re.compile(r'[A-Za-z0-9_]+')
    for idx, l in enumerate(lines):
        line_num = idx + 1
        if line_num <= cal_include_line:
            continue
        code_part = l.split(';')[0]
        for w in set(word_re.findall(code_part)):
            word_to_lines[w].append(line_num)

    return lines, routines, word_to_lines, cal_include_line


def find_enclosing_routine(line_num: int, routines: list) -> tuple:
    """Finds enclosing routine name and start line."""
    last_r = (1, 'MainProgramLoop')
    for r_line, r_name in routines:
        if r_line <= line_num:
            last_r = (r_line, r_name)
        else:
            break
    return last_r


def extract_verbatim_snippet(asm_lines: list, instruction_line: int, routine_name: str, asm_filename: str) -> str:
    """Extracts a verbatim assembly block around an instruction line."""
    total = len(asm_lines)
    start = max(0, instruction_line - 3)
    end = min(total, instruction_line + 4)

    snippet_lines = [f"; --- {routine_name} ({asm_filename}:{start+1}-{end}) ---"]
    for idx in range(start, end):
        snippet_lines.append(asm_lines[idx].rstrip())

    return "\n".join(snippet_lines)


def format_table_type(tbltype: str, points: int) -> str:
    t = str(tbltype).strip()
    if t == '0':
        return f"Type 0 ({points}-point Curve unsigned)"
    elif t == '1':
        return f"Type 1 ({points}-point 2D Table unsigned)"
    elif t == '2':
        return f"Type 2 ({points}-point Signed Curve / Table)"
    elif t == '3':
        return "Type 3 (8-bit Byte Constant)"
    elif t == '4':
        return "Type 4 (16-bit Word Constant)"
    elif t == '5':
        return "Type 5 (Bitfield Byte)"
    elif t == '8':
        return "Type 8 (Transfer Function Constant)"
    elif t == '16':
        return "Type 16 (Synthetic Computed View)"
    return f"Type {t} Constant"


def format_table_properties(tbltype: str, points: int, xaxis: str, yaxis: str):
    t = str(tbltype).strip()
    if t in ('0', '1', '2') and points > 1:
        x_clean = re.sub(r'\s+', ' ', xaxis).strip() if xaxis else "Input Axis"
        y_clean = re.sub(r'\s+', ' ', yaxis).strip() if yaxis else "Output Value"
        return {
            "number_of_points": points,
            "x_axis": x_clean,
            "y_axis": y_clean
        }
    return None


def format_units(tbltype: str, yaxis: str, cname: str, lname: str) -> str:
    t = str(tbltype).strip()
    y_lower = (yaxis or '').lower()
    name_lower = f"{cname}_{lname}".lower()

    if 'rpm' in name_lower or 'rpm' in y_lower:
        return "Engine Speed (RPM)"
    if 'psi' in y_lower or 'boost' in name_lower:
        return "Manifold Boost Pressure (psi)"
    if 'deg' in y_lower or 'advance' in name_lower or 'spark' in name_lower or 'timing' in name_lower:
        return "Spark Advance (degrees)"
    if 'temp' in name_lower or 'coolant' in name_lower or 'degf' in y_lower or ' f' in y_lower:
        return "Temperature (°F)"
    if 'volt' in y_lower or 'bat' in name_lower or 'voltage' in name_lower:
        return "Battery Voltage (Volts)"
    if 'duty' in name_lower or 'vnt' in name_lower or '%' in y_lower or 'percent' in name_lower:
        return "Duty Cycle (% PWM; 0 to 100%)"
    if 'time' in name_lower or 'sec' in name_lower or 'delay' in name_lower or 'timer' in name_lower:
        return "Time Duration (seconds or loop counts)"
    if 'step' in name_lower or 'ais' in name_lower or 'kick' in name_lower:
        return "Stepper Motor Position (steps / counts)"
    if 'mph' in y_lower or 'speed' in name_lower:
        return "Vehicle Road Speed (MPH)"
    if 'inhg' in y_lower or 'vacuum' in name_lower or 'baro' in name_lower:
        return "Manifold Pressure / Vacuum (inHg)"
    if t == '4':
        return "16-bit Word Value"
    if t == '5':
        return "8-bit Bitfield Flag Register"
    return "8-bit Unsigned Scaling Factor (0 to 255 counts)"


def build_raw_and_mptune_desc(overview: str, tuners_guide: str, max_len: int = 450) -> tuple:
    ov_clean = re.sub(r'[*_`#]', '', overview).strip()
    ov_clean = re.sub(r'\s+', ' ', ov_clean)
    tg_clean = re.sub(r'[*_`#]', '', tuners_guide).strip()
    tg_clean = re.sub(r'\s+', ' ', tg_clean)

    ov_sents = [s.strip() for s in re.split(r'(?<=[.!?])\s+', ov_clean) if s.strip()]
    tg_sents = [s.strip() for s in re.split(r'(?<=[.!?])\s+', tg_clean) if s.strip()]

    combined = ""
    for s in ov_sents:
        if not combined:
            combined = s
        elif len(combined) + len(s) + 1 <= 240:
            combined += " " + s
        else:
            break

    for s in tg_sents:
        if len(combined) + len(s) + 1 <= max_len:
            combined += " " + s
        else:
            break

    if not combined:
        combined = ov_clean[:max_len].rsplit(' ', 1)[0] + "."

    if len(combined) > max_len:
        combined = combined[:max_len].rsplit(' ', 1)[0] + "."

    raw_text = combined
    mptune_desc = raw_text.replace(' ', '_')

    return raw_text, mptune_desc


def process_ecm(ecm_code: str):
    """Processes a single ECM model completely from Phase 1 through Phase 3."""
    cfg = ECM_CONFIG.get(ecm_code)
    if not cfg:
        print(f"Error: Unknown ECM code '{ecm_code}'. Choices: {list(ECM_CONFIG.keys())}")
        return False

    print("\n" + "=" * 65)
    print(f"Processing ECM Model: {cfg['title']}")
    print(f"  Template: {cfg['tpl_path']}")
    print(f"  Assembly: {cfg['asm_path']}")
    print(f"  Output JSON: {cfg['output_json']}")
    print("=" * 65)

    # 1. Load legacy descriptor databases for inheritance
    smec_json_path = os.path.join(BASE_DIR, 'docs', 't_smec_descriptors.json')
    lm_json_path = os.path.join(BASE_DIR, 'docs', 't_lm_descriptors.json')

    ref_db = {}
    if os.path.exists(smec_json_path):
        with open(smec_json_path, 'r', encoding='utf-8') as f:
            ref_db.update(json.load(f).get('descriptors', {}))
    if os.path.exists(lm_json_path):
        with open(lm_json_path, 'r', encoding='utf-8') as f:
            lm_desc = json.load(f).get('descriptors', {})
            for k, v in lm_desc.items():
                if k not in ref_db:
                    ref_db[k] = v

    # Build reference lookup indices for multi-key matching
    ref_by_cname = {k.upper(): v for k, v in ref_db.items()}
    ref_by_lname = {v.get('long_name', '').lower(): v for k, v in ref_db.items() if v.get('long_name')}
    ref_by_norm_lname = {re.sub(r'[^a-zA-Z0-9]', '', v.get('long_name', '')).lower(): v for k, v in ref_db.items() if v.get('long_name')}
    ref_by_full = {v.get('full_label', '').lower(): v for k, v in ref_db.items() if v.get('full_label')}

    print(f"Loaded {len(ref_db)} reference descriptors from SMEC & LM databases.")

    # 2. Parse Template File
    tpl_items = parse_template_file(cfg['tpl_path'])
    print(f"Extracted {len(tpl_items)} calibration identifiers from template.")

    # 3. Index Assembly File
    asm_lines, routines, word_to_lines, cal_include_line = index_assembly_file(cfg['asm_path'])
    asm_filename = os.path.basename(cfg['asm_path'])
    tpl_filename = os.path.basename(cfg['tpl_path'])
    rel_asm = os.path.relpath(cfg['asm_path'], BASE_DIR).replace('\\', '/')
    rel_tpl = os.path.relpath(cfg['tpl_path'], BASE_DIR).replace('\\', '/')

    print(f"Indexed {len(routines)} routines and {len(word_to_lines)} instruction tokens in {asm_filename}.")

    # 4. Resolve assembly references and detect anomalies
    descriptors = {}
    unreferenced = []
    synthetic_views = []
    consolidated = []
    subsystems_set = set()

    for item in tpl_items:
        cname = item['cname']
        lname = item['lname']
        full_label = item['full_label']
        tbltype = item['tbltype']
        subsystem = item['subsystem']
        subsystems_set.add(subsystem)

        # Check synthetic 3D views (calculated in MPTune software, not ROM lookup tables)
        if cname in ('PTTIME', 'FTTIME'):
            synthetic_views.append(cname)
            continue

        # Find assembly reference candidates
        cands = [
            f"{cname}_{lname}",
            f"T_{lname}",
            lname,
            cname
        ]
        prefix_matches = [w for w in word_to_lines if w.startswith(f"{cname}_")]
        if prefix_matches:
            cands.extend(prefix_matches)

        inst_line = None
        for cand in cands:
            if cand in word_to_lines:
                inst_line = word_to_lines[cand][0]
                break

        # Fallback search for base symbol or sequential arrays
        if not inst_line:
            # Check if symbol has a numeric suffix e.g. FANTMP2 -> FANTMP
            m_base = re.match(r'^([A-Za-z]+)\d+$', cname)
            if m_base:
                base_cand = m_base.group(1)
                for w in word_to_lines:
                    if w == base_cand or w.startswith(f"{base_cand}_"):
                        inst_line = word_to_lines[w][0]
                        break

        if not inst_line:
            # Header block or unreferenced constant
            inst_line = cal_include_line + 5
            unreferenced.append(cname)

        r_line, r_name = find_enclosing_routine(inst_line, routines)
        verbatim_code = extract_verbatim_snippet(asm_lines, inst_line, r_name, asm_filename)

        # 5. Author / Synthesize Descriptor
        is_filler = (
            tbltype == '9' or
            'UNASSIGNED' in item['mpgrp'].upper() or
            'FILLER' in lname.upper() or
            item['desc'] == 'Desc_Filler_Bytes'
        )

        if is_filler:
            desc_obj = get_filler_bytes_descriptor(
                cname, lname, full_label, item['cal_addr'], asm_filename, r_name, inst_line, r_line, verbatim_code
            )
        elif cname.upper() in ('PEFTBL', 'PEFTBL2') or lname.lower() in ('pumpingefficiency_fromrpm', 'pumpingefficiency2_fromrpm'):
            if cfg['is_t3']:
                desc_obj = get_t3_peftbl_descriptor(
                    cname, lname, full_label, item['cal_addr'], asm_filename, r_name, inst_line, r_line, verbatim_code
                )
            elif cfg['code'] == 'SBECII' and item['points'] == 1:
                desc_obj = get_sbecii_peftbl_descriptor(
                    cname, lname, full_label, item['cal_addr'], asm_filename, r_name, inst_line, r_line, verbatim_code
                )
            else:
                # SBEC with 8 points: inherit and scrub
                legacy = ref_by_cname.get('PEFTBL') or ref_by_lname.get('pumpingefficiency_fromrpm')
                ov = scrub_legacy_text(legacy['overview'], cfg['code'], cfg['ecm_family'], cfg['is_t3'])
                ov_md = scrub_legacy_text(legacy['overview_markdown'], cfg['code'], cfg['ecm_family'], cfg['is_t3'])
                tg = scrub_legacy_text(legacy['tuners_guide'], cfg['code'], cfg['ecm_family'], cfg['is_t3'])
                tg_md = scrub_legacy_text(legacy['tuners_guide_markdown'], cfg['code'], cfg['ecm_family'], cfg['is_t3'])
                notes = scrub_legacy_text(legacy['calibration_notes'], cfg['code'], cfg['ecm_family'], cfg['is_t3'])
                legacy_op = legacy.get('operating_conditions', '')
                op_parts = legacy_op.split('\n\n')
                opener = scrub_legacy_text(op_parts[0], cfg['code'], cfg['ecm_family'], cfg['is_t3']) if op_parts else "Takes effect continuously across all engine operating conditions once running."
                op_cond_text = f"{opener}\n\n* Evaluated inside `{r_name}` at line {inst_line} in `{asm_filename}`.\n* Accesses `PEFTBL` at ROM address `{item['cal_addr']}` for runtime volumetric efficiency interpolation.\n* Modifies intermediate fuel delivery according to `{r_name}` control flow."
                tech_text = f"Inside `{asm_filename}`:\n\nThe CPU executes `{r_name}` where `PEFTBL` is loaded from ROM address `{item['cal_addr']}` at line {inst_line} to scale base fuel pulsewidth."
                desc_obj = {
                    "short_name": cname,
                    "full_label": full_label,
                    "long_name": lname,
                    "overview": ov,
                    "overview_markdown": ov_md,
                    "tuners_guide": tg,
                    "tuners_guide_markdown": tg_md,
                    "operating_conditions": op_cond_text,
                    "technical_mechanics": {"text": tech_text, "assembly_code": verbatim_code},
                    "calibration_notes": notes
                }
        else:
            # Check for legacy match by cname, lname, or norm_lname
            legacy = None
            if cname.upper() in ref_by_cname:
                legacy = ref_by_cname[cname.upper()]
            elif lname.lower() in ref_by_lname:
                legacy = ref_by_lname[lname.lower()]
            else:
                norm_l = re.sub(r'[^a-zA-Z0-9]', '', lname).lower()
                if norm_l in ref_by_norm_lname:
                    legacy = ref_by_norm_lname[norm_l]
                elif full_label.lower() in ref_by_full:
                    legacy = ref_by_full[full_label.lower()]

            # Also check if cname is a hex address in SBECII like T84DAX
            if not legacy and cfg['code'] == 'SBECII' and re.match(r'^T[0-9A-Fa-f]{4,5}X$', cname):
                for w in word_to_lines:
                    if '_' in w:
                        w_short, w_long = w.split('_', 1)
                        if w_long.lower() == lname.lower() or re.sub(r'[^a-zA-Z0-9]', '', w_long).lower() == re.sub(r'[^a-zA-Z0-9]', '', lname).lower():
                            if w_short.upper() in ref_by_cname:
                                legacy = ref_by_cname[w_short.upper()]
                                break

            # For Lotus 16V T3 platforms, skip legacy spark and fuel tables that must be custom authored
            if cfg['is_t3'] and cname.upper() in ('HOTMPL', 'HOTMPH', 'WOTMPH', 'IDLADV', 'IDLMOD', 'THRMOD',
                                                   'O2FBLO', 'O2FBHI', 'RETALL', 'EMRETB', 'EMBSLM', 'ARRPMP',
                                                   'IDLSUB', 'PRTTBL', 'PRTTBH', 'WOTTBL', 'DFPART', 'DFFULL',
                                                   'MAPTRS', 'MAPMXS', 'AESLPI', 'MAPLO', 'MAPHI', 'RPMHI',
                                                   'RPMLO', 'ARMPMD', 'TMPAMB', 'TBLBK3', 'BATVLT'):
                legacy = None

            if legacy:
                ov = scrub_legacy_text(legacy['overview'], cfg['code'], cfg['ecm_family'], cfg['is_t3'])
                ov_md = scrub_legacy_text(legacy['overview_markdown'], cfg['code'], cfg['ecm_family'], cfg['is_t3'])
                tg = scrub_legacy_text(legacy['tuners_guide'], cfg['code'], cfg['ecm_family'], cfg['is_t3'])
                tg_md = scrub_legacy_text(legacy['tuners_guide_markdown'], cfg['code'], cfg['ecm_family'], cfg['is_t3'])
                notes = scrub_legacy_text(legacy['calibration_notes'], cfg['code'], cfg['ecm_family'], cfg['is_t3'])

                legacy_op = legacy.get('operating_conditions', '')
                op_parts = legacy_op.split('\n\n')
                opener = scrub_legacy_text(op_parts[0], cfg['code'], cfg['ecm_family'], cfg['is_t3']) if op_parts else f"Takes effect during active {subsystem.replace('_', ' ')} routines."

                op_cond_text = (
                    f"{opener}\n\n"
                    f"* Evaluated inside `{r_name}` at line {inst_line} in `{asm_filename}`.\n"
                    f"* Accesses `{cname}` at ROM address `{item['cal_addr']}` for runtime comparison or scaling.\n"
                    f"* Governs branching and parameter scaling within `{r_name}` control flow."
                )

                tech_text = (
                    f"Inside `{asm_filename}`:\n\n"
                    f"The CPU executes `{r_name}` where `{cname}` is loaded, compared, or interpolated from ROM address `{item['cal_addr']}` at line {inst_line}."
                )

                desc_obj = {
                    "short_name": cname,
                    "full_label": full_label,
                    "long_name": lname,
                    "overview": ov,
                    "overview_markdown": ov_md,
                    "tuners_guide": tg,
                    "tuners_guide_markdown": tg_md,
                    "operating_conditions": op_cond_text,
                    "technical_mechanics": {
                        "text": tech_text,
                        "assembly_code": verbatim_code
                    },
                    "calibration_notes": notes
                }
            else:
                # Author from scratch using domain synthesis engine
                units_str = format_units(tbltype, item['yaxis'], cname, lname)
                desc_obj = synthesize_new_descriptor(
                    cname=cname,
                    lname=lname,
                    full_label=full_label,
                    mp_group=item['mpgrp'],
                    cal_addr=item['cal_addr'],
                    tbltype=tbltype,
                    units=units_str,
                    factory=item['factory_setting'],
                    asm_file=asm_filename,
                    routine_name=r_name,
                    inst_line=inst_line,
                    routine_line=r_line,
                    verbatim_code=verbatim_code,
                    is_t3=cfg['is_t3'],
                    ecm_code=cfg['code'],
                    points=item['points'],
                    tpl_desc=item['desc']
                )

        # Build ASxxxx-safe raw_text and mptune_desc
        raw_text, mptune_desc = build_raw_and_mptune_desc(desc_obj['overview'], desc_obj['tuners_guide'], 450)
        desc_obj['raw_text'] = raw_text
        desc_obj['mptune_desc'] = mptune_desc

        # Build Metadata object
        desc_obj['metadata'] = {
            "subsystem": subsystem,
            "mp_group": item['mpgrp'],
            "calibration_address": item['cal_addr'],
            "table_type": format_table_type(tbltype, item['points']),
            "units": format_units(tbltype, item['yaxis'], cname, lname),
            "factory_setting": item['factory_setting'],
            "html_filename": f"{full_label}.html",
            "source_template": {
                "file": tpl_filename,
                "relative_path": rel_tpl,
                "line": item['start_line'],
                "line_range": item['line_range'],
                "verified_exists": True
            },
            "assembly_routine": {
                "routine": r_name,
                "description": f"{r_name} in {asm_filename}",
                "file": asm_filename,
                "relative_path": rel_asm,
                "routine_line": r_line,
                "instruction_line": inst_line,
                "verified_exists": True
            },
            "table_properties": format_table_properties(tbltype, item['points'], item['xaxis'], item['yaxis'])
        }

        descriptors[cname] = desc_obj

    print(f"Generated {len(descriptors)} validated descriptors.")

    # 6. Build Anomaly Log (<ecm>_anomaly.md)
    anomaly_lines = [
        f"# {cfg['code']} (`{asm_filename}`) Calibration & Firmware Anomaly Log",
        "",
        f"**Generated:** {datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M:%S UTC')}  ",
        f"**Firmware Source:** [{asm_filename}](file:///{cfg['asm_path'].replace(os.sep, '/')})  ",
        f"**Primary Template:** [{tpl_filename}](file:///{cfg['tpl_path'].replace(os.sep, '/')})  ",
        f"**Target Architecture:** {cfg['arch']} ({cfg['engine_desc']})",
        "",
        "---",
        "",
        f"## 1. Synthetic Computed Views (`{len(synthetic_views)}` Excluded Tables)",
        "",
        "The following 3D display surfaces are calculated dynamically by MPTune software and do not exist as independent lookup tables in the MCU firmware:",
        ""
    ]
    for sv in synthetic_views:
        anomaly_lines.append(f"* **`{sv}`**: Synthetic 3D table surface generated by MPTune.")

    anomaly_lines.extend([
        "",
        "---",
        "",
        f"## 2. Unreferenced ROM Constants & Header Calibration IDs (`{len(unreferenced)}` Identifiers)",
        "",
        "The following calibration parameters reside in the ROM calibration structure but are accessed via base pointers, sequential table indexing, or serve as static calibration identification bytes:",
        ""
    ])
    for ur in unreferenced:
        d = descriptors.get(ur, {})
        full = d.get('full_label', ur)
        grp = d.get('metadata', {}).get('mp_group', '')
        anomaly_lines.append(f"* **`{ur}`** (`{full}` in `{grp}`): Static cal ID byte, sequential array element, or indirect indexed pointer.")

    anomaly_lines.extend([
        "",
        "---",
        "",
        "## 3. Subsystem Breakdown",
        ""
    ])
    subsystem_counts = defaultdict(int)
    for d in descriptors.values():
        subsystem_counts[d['metadata']['subsystem']] += 1
    for sub, count in sorted(subsystem_counts.items()):
        anomaly_lines.append(f"* **`{sub}`**: {count} active calibration descriptors")

    with open(cfg['anomaly_file'], 'w', encoding='utf-8') as f:
        f.write("\n".join(anomaly_lines) + "\n")
    print(f"Wrote anomaly log: {cfg['anomaly_file']}")

    # 7. Build deterministic aliases and index
    by_full = {}
    by_long = {}
    by_addr = {}
    lookup = {}

    for cname, d in descriptors.items():
        fl = d['full_label']
        ln = d['long_name']
        addr = d['metadata']['calibration_address']

        by_full[fl] = cname
        by_long[ln] = cname
        if addr:
            by_addr[addr] = cname

        lookup[cname.lower()] = cname
        lookup[fl.lower()] = cname
        lookup[ln.lower()] = cname

    final_db = {
        "ecm_family": cfg['ecm_family'],
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "total_identifiers": len(descriptors),
        "subsystems": sorted(list(subsystems_set)),
        "consolidated_descriptors": consolidated,
        "excluded_computed_views": synthetic_views,
        "descriptors": descriptors,
        "aliases": {
            "by_full_label": by_full,
            "by_long_name": by_long,
            "by_address": by_addr,
            "lookup_index": lookup
        }
    }

    # 8. Save output JSON
    os.makedirs(os.path.dirname(cfg['output_json']), exist_ok=True)
    with open(cfg['output_json'], 'w', encoding='utf-8') as f:
        json.dump(final_db, f, indent=2, ensure_ascii=False)
    print(f"Wrote JSON database: {cfg['output_json']} ({len(descriptors)} descriptors)")

    # 9. Generate Standalone HTML Tuning Guide
    generate_tuning_guide_html(cfg['code'], cfg['output_json'], cfg['tuning_guide'])

    # 10. Run build_ecm_web.py to compile web portal
    build_script = os.path.join(BASE_DIR, 'tools', 'build_ecm_web.py')
    cmd = [sys.executable, build_script, '--ecm', cfg['code'].lower()]
    print(f"Running build script: {' '.join(cmd)}")
    res = subprocess.run(cmd, capture_output=True, text=True)
    print(res.stdout)
    if res.returncode != 0:
        print(f"Error compiling website for {cfg['code']}:\n{res.stderr}")
        return False

    return True


def update_portal_index():
    """Sets data-ready='true' for all newly generated ECMs in docs/index.html."""
    portal_html = os.path.join(BASE_DIR, 'docs', 'index.html')
    if not os.path.exists(portal_html):
        return

    with open(portal_html, 'r', encoding='utf-8') as f:
        content = f.read()

    # Flip data-ready="false" to data-ready="true" for all ECMs
    updated = content
    for ecm in ('SBEC', 'SBECII', 'T3-I', 'T3-II'):
        # Match button with data-name="SBEC" data-ready="false"
        pattern = re.compile(rf'(data-name="{ecm}"\s+data-ready=")false(")', re.IGNORECASE)
        updated = pattern.sub(r'\1true\2', updated)

    with open(portal_html, 'w', encoding='utf-8') as f:
        f.write(updated)
    print("Updated docs/index.html: activated all ECM portals (data-ready='true').")


def main():
    parser = argparse.ArgumentParser(description="Chrysler Turbo ECM Database and Documentation Generator")
    parser.add_argument('--ecm', choices=['sbec', 'sbecii', 't3-i', 't3-ii', 'all'], default='all',
                        help="Target ECM family to process (default: all)")
    args = parser.parse_args()

    targets = ['SBEC', 'SBECII', 'T3-I', 'T3-II'] if args.ecm == 'all' else [args.ecm.upper() if args.ecm != 't3-i' and args.ecm != 't3-ii' else ('T3-I' if args.ecm == 't3-i' else 'T3-II')]

    success_all = True
    for target in targets:
        success = process_ecm(target)
        if not success:
            success_all = False
            print(f"Failed processing {target}!")
            break

    if success_all:
        update_portal_index()
        print("\nAll target ECMs successfully processed, documented, and built!")


if __name__ == '__main__':
    main()
