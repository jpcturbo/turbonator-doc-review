#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
tools/tuning_guide_generator.py

Automated Standalone HTML5 Tuning Guide Generator for Chrysler Turbo ECMs.
Produces comprehensive, responsive, interactive tuning guides for:
- SBEC
- SBECII
- T3-I
- T3-II
Conforms strictly to tuner_guide_generator_prompt.md.
"""

import os
import sys
import json
import re

def generate_tuning_guide_html(ecm_code: str, json_path: str, output_html_path: str):
    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    descriptors = data.get('descriptors', {})
    ecm_family = data.get('ecm_family', ecm_code)

    # Resolve web folder name
    web_dir_map = {
        'LM': 'T-LM-web',
        'LM-87': 'T-LM-web',
        'SMEC': 'T-SMEC-web',
        'SBEC': 'T-SBEC-web',
        'SBECII': 'T-SBECII-web',
        'T3-I': 'T3-I-web',
        'T3-II': 'T3-II-web'
    }
    web_dir = web_dir_map.get(ecm_code, f"{ecm_code}-web")

    title_map = {
        'SBEC': ('T-SBEC Engine Modifications Tuning Guide', 'Chrysler Turbo SBEC (1990–1991)', '1990–1991 consolidated single-board controller (Motorola 68HC11 MCU)'),
        'SBECII': ('T-SBECII Engine Modifications Tuning Guide', 'Chrysler Turbo SBEC-II (1992–1993)', '1992–1993 sequential EFI controller (Motorola 68HC11 MCU)'),
        'T3-I': ('Turbo III (Gen 1) Engine Modifications Tuning Guide', 'Chrysler / Lotus 2.2L 16V DOHC DDIS (1991–1992)', '1991–1992 Lotus 16-valve DOHC with Direct Distributorless Ignition System'),
        'T3-II': ('Turbo III (Gen 2) Engine Modifications Tuning Guide', 'Chrysler / Lotus 2.2L 16V DOHC Sequential (1992–1993)', '1992–1993 revised Turbo III Lotus 16V sequential EFI & DDIS platform')
    }
    title, subtitle, hard_desc = title_map.get(ecm_code, (f"{ecm_code} Engine Modifications Tuning Guide", ecm_code, 'Chrysler Turbo ECM'))

    is_t3 = 'T3' in ecm_code

    # Helper to resolve identifier link
    def get_ident_link(short_name: str) -> str:
        d = descriptors.get(short_name)
        if not d:
            return f"<code>{short_name}</code>"
        meta = d.get('metadata', {})
        html_fn = meta.get('html_filename', f"{short_name}.html")
        mp_grp = meta.get('mp_group', '').replace('\\', '/').strip('/')
        rel_url = f"{web_dir}/{mp_grp}/{html_fn}" if mp_grp else f"{web_dir}/{html_fn}"
        return f'<a href="{rel_url}" class="ident-name">{short_name}</a><div class="ident-code">{d.get("full_label", short_name)}</div>'

    # Master list of tuning modification mappings
    # 1. Exhaust & Cat Removal
    exhaust_ids = ['DCWOT', 'DCWBST', 'DCWADJ', 'WGMXER', 'BSTDEL', 'OBSTMP', 'OVBST', 'DLTKNK', 'O2SHFT']
    if is_t3:
        exhaust_ids = ['DCWOT', 'DCWBST', 'DCWADJ', 'WGMXER', 'BSTDEL', 'OVBST', 'DLTKNK']
    elif ecm_code in ('SBEC', 'SBECII'):
        exhaust_ids = ['DCWOT', 'DCWBST', 'DCWADJ', 'WGDCOF', 'WGMXER', 'BSTDEL', 'OVBST', 'DLTKNK', 'O2SHFT']

    # 2. Bigger Throttle Body
    tb_ids = ['POSTRG', 'POSSLP', 'POSEST', 'AETIME', 'MINTHR', 'THROFF', 'THRLIM', 'AISMN', 'AISMAX', 'DCLSTP']

    # 3. Bigger Injectors
    inj_ids = ['BATOFF', 'PWMIN', 'SECRMP', 'PRIRMP', 'MINFUL', 'FSLOPE', 'INJFLW', 'PEFTBL', 'HOTMAP', 'WOTMAP']

    # 4. 3-Bar / 4-Bar MAP
    map_ids = ['MAPMULT', 'MAPADD', 'BAROOF', 'HOTMAP', 'WOTMAP', 'FLFT1', 'FLFT2', 'FLPT1', 'FLPT2', 'PEFTBL']

    # 5. Performance Camshaft
    if is_t3:
        cam_ids = ['HOTMAP', 'WOTMAP', 'PEFTBL', 'DLTKNK', 'RPMMAP', 'IDLRPM', 'AISMN', 'AISMAX', 'SECRMP', 'PRIRMP']
    else:
        cam_ids = ['HOTMAP', 'WOTMAP', 'PEFTBL', 'DLTKNK', 'RPMMAP', 'IDLRPM', 'AISMN', 'AISMAX', 'SECRMP', 'PRIRMP', 'AFNSET']

    # Filter to active identifiers in this ECM
    def filter_active(id_list):
        return [x for x in id_list if x in descriptors]

    exhaust_active = filter_active(exhaust_ids)
    tb_active = filter_active(tb_ids)
    inj_active = filter_active(inj_ids)
    map_active = filter_active(map_ids)
    cam_active = filter_active(cam_ids)

    # Master matrix unique set
    all_mod_ids = sorted(list(set(exhaust_active + tb_active + inj_active + map_active + cam_active)))

    # Descriptions and rationales for modification rows
    ROW_KNOWLEDGE = {
        'DCWOT': ('High Priority', 'Lower 5% to 15% Duty Cycle', 'Base Full-Throttle Wastegate Duty Cycle: Reduced exhaust backpressure accelerates turbo spool past target boost. Trimming DCWOT in the spool-up region (2,000–3,600 RPM) softens solenoid duty cycle to eliminate overshoot spikes. (Bypassed if running a mechanical grainger valve).'),
        'DCWBST': ('Recommended', 'Smooth Spool Slope', 'Duty Cycle Offset from Boost Target: Proactive feedforward adjustment as boost nears target. Softening prevents closed-loop overshoot when boost climbs faster than stock exhaust dynamics anticipate.'),
        'DCWADJ': ('Optional', 'Trim -5% to -10% at High RPM', 'RPM Wastegate Duty Cycle Offset: If experiencing top-end boost creep above 5,200 RPM on a 3" system, reducing DCWADJ commands maximum solenoid venting to force the internal wastegate flapper fully open.'),
        'WGDCOF': ('Recommended', 'Lower -3% to -8%', 'Wastegate Duty Cycle Offset: Global baseline adder for wastegate pulsewidth. Trimming downward provides headroom against boost spiking with low-restriction downpipes.'),
        'WGMXER': ('Recommended', 'Limit Authority (15-20%)', 'Max WGDC for Boost Error Correction: Restricts maximum closed-loop integrator windup so the ECU cannot excessively clamp the wastegate shut on rapid spool-up.'),
        'BSTDEL': ('Optional', 'Increase Delay (+0.2s)', 'Boost Target Decay Delay: Extends or shortens overboost timer delay during aggressive gear shifts.'),
        'OBSTMP': ('Optional', 'Increase Threshold (+1 to +2 psi)', 'Overboost Fuel Cut Pressure Threshold: Raises safety fuel-cut ceiling to prevent nuisance fuel cuts during momentary 1–2 psi spool-up transients on free-flowing exhausts.'),
        'OVBST': ('High Priority', 'Scale with Target Boost (+2 psi margin)', 'Overboost Fuel Cut Threshold: Sets absolute manifold pressure where fuel injector firing is immediately cut. Must be set 2–3 psi above desired running boost to prevent violent fuel cuts on rapid spool.'),
        'DLTKNK': ('Recommended', 'Rescale Knock Voltage Window', 'Knock Sensor Voltage Threshold: Less restrictive exhaust reduces in-cylinder backpressure and operating temperatures, shifting the knock threshold. High-lift cams or open exhausts can create false valvetrain noise; adjust DLTKNK to maintain valid knock detection.'),
        'O2SHFT': ('Optional', 'Stock or +1 to +2 counts', 'O2 Sensor Voltage Switching Threshold: Shifts closed-loop stoichiometric target slightly richer or leaner to optimize light-load cruising emissions.'),
        'POSTRG': ('High Priority', 'Raise +15% to +30%', 'TPS Pump Shot Trigger Threshold: A larger throttle body flows substantially more airflow for the same initial throttle angle degrees. Raising POSTRG prevents small throttle wobbles or highway bumps from accidentally triggering acceleration enrichment.'),
        'POSSLP': ('High Priority', 'Lower -15% to -25%', 'TPS Pump Shot Slope / Fuel Volume: Because manifold vacuum drops dramatically on tip-in with a 52mm/58mm throttle body, excessive fuel causes a momentary rich bog. Trimming POSSLP provides crisp, immediate throttle response.'),
        'POSEST': ('Recommended', 'Increase Decay Rate (-10% duration)', 'TPS Pump Shot Decay Rate: Shortens transient fuel decay duration to prevent rich wall-wetting puddle accumulation after rapid throttle tip-in.'),
        'AETIME': ('Optional', 'Trim -10% to -20%', 'Acceleration Enrichment Duration Timer: Reduces continuous transient enrichment duration to match faster plenum filling of larger throttle bodies.'),
        'MINTHR': ('High Priority', 'Reset Closed-Throttle Baseline Voltage', 'Minimum Throttle Baseline Voltage: After mechanically adjusting the minimum air idle screw on an aftermarket throttle body, MINTHR must be verified to ensure closed-throttle idle bitflags set reliably.'),
        'THROFF': ('Recommended', 'Verify 0.2V to 0.4V Offset', 'Throttle Voltage Offset: Calibrates the deadband between base idle voltage and part-throttle transition.'),
        'THRLIM': ('Optional', 'Verify Baseline Voltage Limit', 'Throttle Voltage Sanity Limit: Caps the diagnostic ceiling for TPS signal validation.'),
        'AISMN': ('Recommended', 'Lower -5 to -10 steps', 'Minimum Idle Stepper Steps: Larger throttle bodies bypass more leakage air around the throttle plate even when fully closed. Lowering AISMN ensures the stepper motor has enough downward authority to bring warm idle down to target.'),
        'AISMAX': ('Optional', 'Stock or +10 steps for A/C', 'Maximum Idle Stepper Position: Upper travel limit for the AIS stepper motor during cold start.'),
        'DCLSTP': ('Recommended', 'Trim -2 to -6 steps', 'Decel Dashpot Stepper Kick: Controls bypass airflow on sudden throttle release to prevent stalling. Larger throttle bodies require less dashpot airflow to prevent engine hang.'),
        'BATOFF': ('High Priority', 'Calibrate to Injector Spec (+0.1 to +0.3ms)', 'Fuel Injector Dead Time vs Voltage: Modern high-flow injectors have faster mechanical response than vintage pintle injectors. Calibrating BATOFF prevents voltage-drop lean-outs and erratic hunting idle.'),
        'PWMIN': ('High Priority', 'Lower to 1.2ms – 1.8ms (Stock ~4.8ms)', 'Minimum Pulsewidth for Adaptive Memory Update: Large injectors operate at very short cruising pulsewidths (2.0–3.0ms). Stock PWMIN locks out adaptive fuel updates below 4.80ms; lowering PWMIN allows closed-loop learning to function properly.'),
        'SECRMP': ('High Priority', 'Reduce to +1/-1 count (Stock +3/-3)', 'Secondary O2 Closed-Loop Ramp Rate: High-flow injectors deliver much more fuel per control tick. Reducing SECRMP slows O2 integrator ramp rates, preventing rich/lean idle hunting.'),
        'PRIRMP': ('Recommended', 'Leave at Minimum (1 count)', 'Primary O2 Closed-Loop Step: Immediate directional step on O2 sensor toggle. Factory stock is already set to the minimum 1-count step.'),
        'MINFUL': ('Recommended', 'Lower to 0.8ms – 1.0ms', 'Absolute Minimum Injector Pulsewidth Floor: Prevents decel or low-load pulsewidths from dipping below physical injector opening limits.'),
        'FSLOPE': ('High Priority', 'Automated by MPTune (Fine-tune +-5%)', 'Fuel Delivery Slope: Governs mass airflow to pulsewidth conversion. MPTune scales this automatically based on injector flow rating.'),
        'INJFLW': ('High Priority', 'Set to Rated Injector Flow (pph)', 'Injector Flow Constant: Informs the ECU and trip computer of injector sizing.'),
        'PEFTBL': ('Recommended', 'Smooth Mid-Range (+5% to -5%)', 'Pumping Efficiency (Volumetric Efficiency): Adjusts volumetric efficiency across RPM. For camshaft upgrades, trim below 3,000 RPM and add 5–12% above 4,800 RPM.'),
        'HOTMAP': ('Recommended', 'Fine-Tune Part-Throttle Timing', 'Warm Part-Throttle Spark Advance: Advance 2–4 degrees in low-compression regions; soften timing near peak boost torque (3,200–4,400 RPM).'),
        'WOTMAP': ('High Priority', 'Set Boost Spark Advance (Det-Can verified)', 'Wide-Open Throttle Spark Advance: Primary timing table under boost. Rescale carefully to maintain knock margin on pump fuel.'),
        'MAPMULT': ('High Priority', 'Automated by MPTune (3-Bar: ~1.5x)', 'MAP Sensor Transfer Multiplier: Rescales analog sensor voltage slope for 3-bar or 4-bar sensors. Handled accurately by MPTune MAP sensor wizard.'),
        'MAPADD': ('High Priority', 'Automated by MPTune (3-Bar offset)', 'MAP Sensor Transfer Offset: Rescales analog sensor voltage zero-offset. Handled accurately by MPTune MAP sensor wizard.'),
        'BAROOF': ('Recommended', 'Verify Sea-Level Baro Offset', 'Barometric Pressure Offset: Ensures key-on barometric reading correctly aligns with local atmospheric pressure.'),
        'FLFT1': ('Recommended', 'Rescale High-Boost Cells', 'WOT Fuel Curve 1: Calibrate fueling in the 15–30+ psi boost cells to achieve target 11.2–11.8:1 wideband AFR under boost.'),
        'FLFT2': ('Recommended', 'Rescale High-Boost Cells', 'WOT Fuel Curve 2: Secondary full-throttle fueling curve across boost.'),
        'FLPT1': ('Recommended', 'Rescale Vacuum/Boost Cells', 'Part-Throttle Fuel Curve 1: Calibrate part-throttle cruising fueling for crisp 14.7:1 AFR.'),
        'FLPT2': ('Recommended', 'Rescale Vacuum/Boost Cells', 'Part-Throttle Fuel Curve 2: Secondary part-throttle cruising fueling curve.'),
        'RPMMAP': ('Recommended', 'Raise +200 to +400 RPM for Cams', 'Part-Throttle to WOT Transition Threshold: Overlap cams lower idle vacuum, triggering part-throttle enrichments too early. Raising RPMMAP delays transition until true load demands it.'),
        'IDLRPM': ('Recommended', 'Raise +50 to +150 RPM (850–950 RPM)', 'Target Idle Engine Speed: Lumpy performance camshafts require elevated idle speed for stable manifold vacuum and smooth oil pressure.'),
        'AFNSET': ('Optional', 'Adjust for Overlap Exhaust Dilution', 'Air-Fuel Setpoint: Refines closed-loop targeting on engines with camshaft overlap.')
    }

    # Generate HTML rows for a table
    def build_section_rows(id_list):
        rows_html = []
        for x in id_list:
            if x not in descriptors:
                continue
            d = descriptors[x]
            subsystem = d.get('metadata', {}).get('subsystem', 'General').replace('_', ' ')
            know = ROW_KNOWLEDGE.get(x, ('Recommended', 'Adjust progressively', f'Calibrates {d.get("long_name", x)} for engine modification responsiveness.'))
            priority, action, rationale = know[0], know[1], know[2]

            badge_cls = 'priority-high' if 'High' in priority else ('priority-med' if 'Recommended' in priority else 'priority-opt')
            dir_cls = 'dir-down' if 'Lower' in action or 'Reduce' in action or 'Trim' in action else ('dir-up' if 'Raise' in action or 'Increase' in action else 'dir-modify')

            row = f"""                    <tr>
                        <td>
                            {get_ident_link(x)}
                            <span class="priority-badge {badge_cls}">{priority}</span>
                        </td>
                        <td>{subsystem}</td>
                        <td><span class="direction-badge {dir_cls}">{action}</span></td>
                        <td>{rationale}</td>
                    </tr>"""
            rows_html.append(row)
        return "\n".join(rows_html)

    # Master cross-reference rows
    matrix_rows = []
    for x in all_mod_ids:
        d = descriptors[x]
        subsystem = d.get('metadata', {}).get('subsystem', 'General').replace('_', ' ')

        def get_mod_badge(in_list, is_high=False):
            if in_list:
                return '<span class="matrix-badge m-high">High</span>' if is_high else '<span class="matrix-badge m-rec">Yes</span>'
            return '<span class="matrix-badge m-none">&mdash;</span>'

        is_high = ROW_KNOWLEDGE.get(x, ('',))[0] == 'High Priority'
        b_ex = get_mod_badge(x in exhaust_active, is_high and x in exhaust_active)
        b_tb = get_mod_badge(x in tb_active, is_high and x in tb_active)
        b_inj = get_mod_badge(x in inj_active, is_high and x in inj_active)
        b_map = get_mod_badge(x in map_active, is_high and x in map_active)
        b_cam = get_mod_badge(x in cam_active, is_high and x in cam_active)

        mrow = f"""                <tr class="matrix-row" data-ident="{x.lower()} {d.get('long_name', '').lower()}">
                    <td>{get_ident_link(x)}</td>
                    <td>{subsystem}</td>
                    <td class="text-center">{b_ex}</td>
                    <td class="text-center">{b_tb}</td>
                    <td class="text-center">{b_inj}</td>
                    <td class="text-center">{b_map}</td>
                    <td class="text-center">{b_cam}</td>
                </tr>"""
        matrix_rows.append(mrow)
    matrix_html = "\n".join(matrix_rows)

    cam_engine_dynamics = """                <ul>
                    <li><strong>Lower Idle Vacuum (Higher Absolute Pressure):</strong> Long duration and tight lobe separation angles (LSA) cause exhaust gas reversion at idle and low RPM, lowering idle vacuum and causing erratic MAP sensor readings.</li>
                    <li><strong>Shifted Volumetric Efficiency Peak:</strong> Performance camshafts breathe much more efficiently above 4,500 RPM, requiring higher fueling at high engine speeds while requiring fuel trimming at low RPM to prevent rich fouling.</li>
                    <li><strong>False Knock Detection:</strong> Aggressive cam lobes, mechanical lifters, and stiffer valve springs generate elevated acoustic valvetrain vibration, which factory knock sensors can misinterpret as spark knock.</li>
                    <li><strong>Premature WOT Enrichment:</strong> Lower manifold vacuum can trick the ECU into triggering part-throttle and WOT fuel enrichments at gentle cruising speeds.</li>
                </ul>""" if not is_t3 else """                <ul>
                    <li><strong>16-Valve DOHC Lotus Breathing Dynamics:</strong> The Lotus 16-valve dual overhead cam cylinder head features large valves and steep port angles, dramatically improving volumetric efficiency above 4,800 RPM.</li>
                    <li><strong>Dual Camshaft Timing Sensitivity:</strong> Adjustable cam gears on intake and exhaust cams alter valve overlap. Increased overlap lowers idle vacuum and requires compensation in idle stepper airflow and base spark.</li>
                    <li><strong>Acoustic Resonance on 16V Valvetrain:</strong> High-RPM Lotus valvetrain harmonics require tailored knock window filtering (`DLTKNK`) to distinguish real detonation from mechanical cam and lifter noise.</li>
                    <li><strong>Direct Distributorless Spark Synchronization:</strong> DDIS ignition timing and dwell must remain rock-solid across high-RPM valve float boundaries.</li>
                </ul>"""

    html_content = f"""<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{title} | {subtitle}</title>
    <script>
        (function() {{
            function syncTheme() {{
                try {{
                    var params = new URLSearchParams(window.location.search);
                    var t = params.get('theme') || localStorage.getItem('mptune_theme');
                    if (!t && window.name && window.name.indexOf('mptune_theme=') === 0) {{
                        t = window.name.split('=')[1];
                    }}
                    if (t !== 'light' && t !== 'dark') {{
                        t = 'dark';
                    }}
                    document.documentElement.setAttribute('data-theme', t);
                    localStorage.setItem('mptune_theme', t);
                    window.name = 'mptune_theme=' + t;
                    var btn = document.getElementById('themeToggle');
                    if (btn) btn.textContent = t === 'dark' ? 'Light Theme' : 'Dark Theme';
                }} catch (e) {{
                    document.documentElement.setAttribute('data-theme', 'dark');
                }}
            }}
            syncTheme();
            window.toggleMptuneTheme = function() {{
                var cur = document.documentElement.getAttribute('data-theme') || 'dark';
                var next = cur === 'dark' ? 'light' : 'dark';
                document.documentElement.setAttribute('data-theme', next);
                try {{
                    localStorage.setItem('mptune_theme', next);
                    window.name = 'mptune_theme=' + next;
                }} catch (e) {{}}
                var btn = document.getElementById('themeToggle');
                if (btn) btn.textContent = next === 'dark' ? 'Light Theme' : 'Dark Theme';
            }};
            window.addEventListener('DOMContentLoaded', syncTheme);
            window.addEventListener('pageshow', syncTheme);
            window.addEventListener('storage', syncTheme);
        }})();
    </script>
    <link rel="stylesheet" href="{web_dir}/style.css">
    <style>
        :root {{
            --badge-high-bg: #fee2e2;
            --badge-high-text: #991b1b;
            --badge-high-border: #f87171;
            --badge-med-bg: #fef3c7;
            --badge-med-text: #92400e;
            --badge-med-border: #fcd34d;
            --badge-opt-bg: #e0f2fe;
            --badge-opt-text: #0369a1;
            --badge-opt-border: #7dd3fc;
            --tip-bg: #f0fdf4;
            --tip-border: #22c55e;
            --tip-text: #166534;
            --note-bg: #eff6ff;
            --note-border: #3b82f6;
            --note-text: #1e40af;
            --alert-bg: #fffbeb;
            --alert-border: #f59e0b;
            --alert-text: #b45309;
        }}
        [data-theme="dark"] {{
            --badge-high-bg: #450a0a;
            --badge-high-text: #fecaca;
            --badge-high-border: #b91c1c;
            --badge-med-bg: #451a03;
            --badge-med-text: #fde68a;
            --badge-med-border: #b45309;
            --badge-opt-bg: #0c4a6e;
            --badge-opt-text: #bae6fd;
            --badge-opt-border: #0284c7;
            --tip-bg: #052e16;
            --tip-border: #16a34a;
            --tip-text: #bbf7d0;
            --note-bg: #172554;
            --note-border: #2563eb;
            --note-text: #bfdbfe;
            --alert-bg: #451a03;
            --alert-border: #d97706;
            --alert-text: #fef3c7;
        }}
        .guide-container {{
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 16px 60px 16px;
        }}
        .sticky-nav {{
            position: sticky;
            top: 0;
            z-index: 100;
            background: rgba(11, 31, 61, 0.95);
            backdrop-filter: blur(8px);
            border-bottom: 2px solid var(--border-color);
            padding: 12px 0;
            margin-bottom: 24px;
        }}
        [data-theme="light"] .sticky-nav {{
            background: rgba(237, 242, 248, 0.95);
        }}
        .sticky-nav-inner {{
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 10px;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 16px;
        }}
        .nav-pills {{
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }}
        .nav-pill {{
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 600;
            text-decoration: none;
            background: var(--bg-card);
            color: var(--text-main);
            border: 1px solid var(--border-color);
            transition: all 0.2s ease;
        }}
        .nav-pill:hover {{
            background: var(--primary);
            color: #fff;
            border-color: var(--primary);
        }}
        .priority-badge {{
            display: inline-block;
            font-size: 0.72rem;
            font-weight: 700;
            padding: 2px 7px;
            border-radius: 4px;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            margin-top: 4px;
        }}
        .priority-high {{ background: var(--badge-high-bg); color: var(--badge-high-text); border: 1px solid var(--badge-high-border); }}
        .priority-med {{ background: var(--badge-med-bg); color: var(--badge-med-text); border: 1px solid var(--badge-med-border); }}
        .priority-opt {{ background: var(--badge-opt-bg); color: var(--badge-opt-text); border: 1px solid var(--badge-opt-border); }}
        .direction-badge {{
            display: inline-block;
            font-size: 0.82rem;
            font-weight: 600;
            padding: 3px 8px;
            border-radius: 4px;
            white-space: nowrap;
        }}
        .dir-up {{ background: #dbeafe; color: #1e40af; border: 1px solid #93c5fd; }}
        .dir-down {{ background: #fef2f2; color: #991b1b; border: 1px solid #fca5a5; }}
        .dir-modify {{ background: #f3f4f6; color: #374151; border: 1px solid #d1d5db; }}
        [data-theme="dark"] .dir-up {{ background: #1e3a8a; color: #bfdbfe; border-color: #3b82f6; }}
        [data-theme="dark"] .dir-down {{ background: #7f1d1d; color: #fecaca; border-color: #ef4444; }}
        [data-theme="dark"] .dir-modify {{ background: #374151; color: #f3f4f6; border-color: #6b7280; }}
        .pro-tip-box {{
            background: var(--tip-bg);
            border-left: 4px solid var(--tip-border);
            padding: 16px 20px;
            border-radius: 0 8px 8px 0;
            margin: 20px 0;
            color: var(--tip-text);
        }}
        .pro-tip-box h4 {{
            margin-top: 0;
            color: var(--tip-text);
            font-size: 1rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }}
        .ident-name {{
            font-size: 1rem;
            font-weight: 700;
            color: var(--primary);
            text-decoration: none;
        }}
        .ident-name:hover {{ text-decoration: underline; }}
        .ident-code {{
            font-size: 0.78rem;
            color: var(--text-muted);
            font-family: var(--font-mono, monospace);
        }}
        .matrix-badge {{
            display: inline-block;
            font-size: 0.75rem;
            font-weight: 700;
            padding: 2px 6px;
            border-radius: 4px;
        }}
        .m-high {{ background: var(--badge-high-bg); color: var(--badge-high-text); border: 1px solid var(--badge-high-border); }}
        .m-rec {{ background: var(--badge-med-bg); color: var(--badge-med-text); border: 1px solid var(--badge-med-border); }}
        .m-none {{ color: var(--text-muted); }}
        .search-box {{
            width: 100%;
            padding: 10px 14px;
            border-radius: 6px;
            border: 1px solid var(--border-color);
            background: var(--bg-card);
            color: var(--text-main);
            font-size: 0.95rem;
            margin-bottom: 16px;
        }}
        .search-box:focus {{
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.2);
        }}
    </style>
</head>
<body>

    <!-- Sticky Navigation -->
    <nav class="sticky-nav">
        <div class="sticky-nav-inner">
            <div class="nav-pills">
                <a href="#mod1" class="nav-pill">1. Exhaust &amp; Cat</a>
                <a href="#mod2" class="nav-pill">2. Throttle Body</a>
                <a href="#mod3" class="nav-pill">3. Injectors</a>
                <a href="#mod4" class="nav-pill">4. 3-Bar / 4-Bar MAP</a>
                <a href="#mod5" class="nav-pill">5. Camshaft</a>
                <a href="#matrix" class="nav-pill">Master Matrix</a>
                <a href="{web_dir}/index.html" class="nav-pill" style="border-color: var(--primary);">&larr; Calibration Index</a>
            </div>
            <button id="themeToggle" class="btn" style="padding: 6px 12px; font-size: 0.85rem;" onclick="window.toggleMptuneTheme()">Toggle Theme</button>
        </div>
    </nav>

    <div class="guide-container">

        <!-- Header -->
        <header style="margin-bottom: 32px;">
            <div style="font-size: 0.85rem; font-weight: 700; color: var(--primary); text-transform: uppercase; letter-spacing: 0.08em; margin-bottom: 6px;">
                Calibration &amp; Tuning Reference
            </div>
            <h1 style="font-size: 2.2rem; margin: 0 0 10px 0;">{title}</h1>
            <p style="font-size: 1.1rem; color: var(--text-muted); margin: 0;">
                {subtitle} &bull; {hard_desc}
            </p>
        </header>

        <!-- Introduction -->
        <section class="card" style="margin-bottom: 32px; padding: 24px;">
            <h3 style="margin-top: 0;">MPTune Automation vs. Tuner Calibration Responsibilities</h3>
            <p>
                MPTune provides powerful automated scaling wizards (such as injector pulsewidth rescaling and MAP sensor transfer function generation). 
                However, automated wizards only establish a mathematical baseline. Crucial real-world drivability, transient fueling, injector opening dynamics, 
                and idle stability require focused, manual calibration in specific tables.
            </p>
            <p style="margin-bottom: 0;">
                This guide provides smart, field-proven calibration guidance for five common performance modifications, identifying exactly which identifiers to modify, 
                by how much, and why, without confusing software jargon.
            </p>
        </section>

        <!-- Modification 1: Exhaust -->
        <section id="mod1" class="card" style="margin-bottom: 32px; padding: 24px;">
            <h2 style="margin-top: 0;">1. Larger Exhaust &amp; Catalytic Converter Removal (2.5&quot; / 3&quot; Mandrel Systems)</h2>
            <div class="pro-tip-box" style="margin-top: 0;">
                <h4>What Happens to the Engine</h4>
                <ul>
                    <li><strong>Faster Turbine Pressure Ratio Build:</strong> Free-flowing 2.5&quot; or 3&quot; downpipes dramatically reduce turbine discharge backpressure, spooling the turbocharger hundreds of RPM earlier.</li>
                    <li><strong>Boost Overshoot / Spiking:</strong> Because the turbo spools much faster than factory exhaust dynamics expect, factory electronic wastegate solenoids can momentarily lag, resulting in transient boost spikes.</li>
                    <li><strong>High-RPM Boost Creep:</strong> At high engine speeds (above 5,200 RPM), the small factory internal wastegate port may be physically overwhelmed by huge exhaust volume, causing boost to creep upward.</li>
                    <li><strong>Mechanical Manual Boost Controllers (MBC):</strong> Many tuners in this community install mechanical ball-and-spring boost controllers (Grainger valves), completely bypassing ECU wastegate tables. If running an MBC, wastegate duty cycle tables do not affect boost pressure.</li>
                </ul>
            </div>

            <h3>Identifier Tuning Table: Exhaust Modifications</h3>
            <div style="overflow-x: auto;">
                <table class="cal-table">
                    <thead>
                        <tr>
                            <th style="width: 25%;">Identifier Name</th>
                            <th style="width: 15%;">Subsystem</th>
                            <th style="width: 22%;">Action &amp; Recommended Value</th>
                            <th>Tuning Rationale</th>
                        </tr>
                    </thead>
                    <tbody>
{build_section_rows(exhaust_active)}
                    </tbody>
                </table>
            </div>

            <div class="pro-tip-box">
                <h4>Tuner's Field Checklist: Exhaust Upgrades</h4>
                <ol>
                    <li>If retaining factory ECU wastegate solenoid control, lower <code>DCWOT</code> by 10% in the 2,400–3,600 RPM spool region to prevent overshoot spikes.</li>
                    <li>If running a manual Grainger valve, verify wastegate solenoid vacuum lines are plugged and raise <code>OVBST</code> by +2 psi above target boost to eliminate false fuel cuts.</li>
                    <li>Inspect downpipe clearance around the steering rack and monitor wideband AFR on full throttle pulls.</li>
                </ol>
            </div>
        </section>

        <!-- Modification 2: Throttle Body -->
        <section id="mod2" class="card" style="margin-bottom: 32px; padding: 24px;">
            <h2 style="margin-top: 0;">2. Bigger Throttle Body (52mm / 58mm vs. Stock 46mm)</h2>
            <div class="pro-tip-box" style="margin-top: 0;">
                <h4>What Happens to the Engine</h4>
                <ul>
                    <li><strong>Rapid Manifold Vacuum Collapse:</strong> Opening a 52mm or 58mm throttle plate admits substantially more volume per degree of throttle rotation than the stock 46mm unit, dropping manifold vacuum instantly on tip-in.</li>
                    <li><strong>Transient Tip-In Stumble (Rich Bog):</strong> Factory acceleration enrichment pump shot delivers fuel proportional to throttle angle delta. With a big throttle body, stock pump shot floods the intake runner floor with wet fuel, causing a bog.</li>
                    <li><strong>Elevated Leakage Airflow at Idle:</strong> Larger throttle plates leak slightly more perimeter airflow around their circumferences, requiring less idle stepper motor bypass air to hold target RPM.</li>
                </ul>
            </div>

            <h3>Identifier Tuning Table: Throttle Body Upgrades</h3>
            <div style="overflow-x: auto;">
                <table class="cal-table">
                    <thead>
                        <tr>
                            <th style="width: 25%;">Identifier Name</th>
                            <th style="width: 15%;">Subsystem</th>
                            <th style="width: 22%;">Action &amp; Recommended Value</th>
                            <th>Tuning Rationale</th>
                        </tr>
                    </thead>
                    <tbody>
{build_section_rows(tb_active)}
                    </tbody>
                </table>
            </div>

            <div class="pro-tip-box">
                <h4>Tuner's Field Checklist: Throttle Body Setup</h4>
                <ol>
                    <li>Mechanically adjust the throttle stop screw with the AIS motor disconnected so warm base idle sits ~750 RPM.</li>
                    <li>Verify live closed-throttle TPS voltage sits between 0.70V and 0.90V in MPScan, and confirm <code>MINTHR</code> reads baseline voltage.</li>
                    <li>Raise <code>POSTRG</code> by +20% and lower <code>POSSLP</code> by -20% to eliminate tip-in hesitation.</li>
                </ol>
            </div>
        </section>

        <!-- Modification 3: Injectors -->
        <section id="mod3" class="card" style="margin-bottom: 32px; padding: 24px;">
            <h2 style="margin-top: 0;">3. Bigger Injectors (+20%, +40%, 72+ pph) [Fine-Tuning Guidelines]</h2>
            <div class="pro-tip-box" style="margin-top: 0;">
                <h4>What Happens to the Engine</h4>
                <ul>
                    <li><strong>Ultra-Short Cruising Pulsewidths:</strong> Large injectors flow huge fuel volume, dropping idle and part-throttle pulsewidths down toward 1.5ms–2.5ms.</li>
                    <li><strong>Adaptive Learning Lockout:</strong> Factory calibration firmware stops updating adaptive fuel trim cells when pulsewidth drops below <code>PWMIN</code> (stock 4.80ms). With large injectors, <code>PWMIN</code> must be scaled down or closed-loop learning halts.</li>
                    <li><strong>Faster Modern Injector Dead Times:</strong> Modern disc or multi-hole injectors open much faster than vintage Chrysler pintle injectors, requiring battery latency offset adjustments in <code>BATOFF</code>.</li>
                    <li><strong>Closed-Loop O2 Hunting:</strong> Large injectors deliver more fuel per integrator tick, turning subtle closed-loop trims into wild rich/lean RPM surging unless <code>SECRMP</code> is reduced to +1/-1 count.</li>
                </ul>
            </div>

            <h3>Identifier Tuning Table: Injector Fine-Tuning</h3>
            <div style="overflow-x: auto;">
                <table class="cal-table">
                    <thead>
                        <tr>
                            <th style="width: 25%;">Identifier Name</th>
                            <th style="width: 15%;">Subsystem</th>
                            <th style="width: 22%;">Action &amp; Recommended Value</th>
                            <th>Tuning Rationale</th>
                        </tr>
                    </thead>
                    <tbody>
{build_section_rows(inj_active)}
                    </tbody>
                </table>
            </div>

            <div class="pro-tip-box">
                <h4>Tuner's Field Checklist: High-Flow Injectors</h4>
                <ol>
                    <li>Always run MPTune's automated injector scaling wizard first to scale base fuel slope (<code>FSLOPE</code>).</li>
                    <li>Lower <code>PWMIN</code> to 1.50ms so adaptive fuel trims learn properly during highway cruising.</li>
                    <li>Reduce <code>SECRMP</code> from +3/-3 down to +1/-1 counts to cure rolling idle hunting in closed-loop mode.</li>
                    <li>Verify fuel pressure with vacuum hose disconnected sits at factory 55 psi baseline.</li>
                </ol>
            </div>
        </section>

        <!-- Modification 4: 3-Bar / 4-Bar MAP -->
        <section id="mod4" class="card" style="margin-bottom: 32px; padding: 24px;">
            <h2 style="margin-top: 0;">4. 3-Bar and 4-Bar MAP Sensors [Fine-Tuning Guidelines]</h2>
            <div class="pro-tip-box" style="margin-top: 0;">
                <h4>What Happens to the Engine</h4>
                <ul>
                    <li><strong>Compressed Analog Voltage Resolution:</strong> A 3-bar sensor spreads 0–5 Volts across 0 to 44 psi absolute (up to ~29 psi boost), halving analog voltage delta per psi compared to a 2-bar sensor.</li>
                    <li><strong>Transfer Slope Scaling:</strong> MPTune automatically rescales <code>MAPMULT</code> and <code>MAPADD</code> to convert sensor voltage into correct internal pressure counts.</li>
                    <li><strong>High-Boost Fuel &amp; Spark Cell Tuning:</strong> A 3-bar conversion unlocks previously unreachable high-boost lookup cells in fuel and spark tables. These upper cells must be calibrated for safe air-fuel ratios and timing advance.</li>
                </ul>
            </div>

            <h3>Identifier Tuning Table: MAP Sensor Scaling</h3>
            <div style="overflow-x: auto;">
                <table class="cal-table">
                    <thead>
                        <tr>
                            <th style="width: 25%;">Identifier Name</th>
                            <th style="width: 15%;">Subsystem</th>
                            <th style="width: 22%;">Action &amp; Recommended Value</th>
                            <th>Tuning Rationale</th>
                        </tr>
                    </thead>
                    <tbody>
{build_section_rows(map_active)}
                    </tbody>
                </table>
            </div>

            <div class="pro-tip-box">
                <h4>Tuner's Field Checklist: 3-Bar / 4-Bar Sensors</h4>
                <ol>
                    <li>Use MPTune's MAP Sensor Wizard to convert the calibration template to 3-bar or 4-bar scaling.</li>
                    <li>Before starting the engine, turn ignition Key-ON and verify live MAP sensor reading in MPScan reads local barometric pressure (~14.7 psi / 29.9 inHg).</li>
                    <li>Review full-throttle spark timing in <code>WOTMAP</code> in the newly unlocked 15–28 psi cells to ensure conservative advance.</li>
                </ol>
            </div>
        </section>

        <!-- Modification 5: Performance Camshaft -->
        <section id="mod5" class="card" style="margin-bottom: 32px; padding: 24px;">
            <h2 style="margin-top: 0;">5. Generic Performance Camshaft (Higher Lift, Longer Duration, Tighter LSA)</h2>
            <div class="pro-tip-box" style="margin-top: 0;">
                <h4>What Happens to the Engine</h4>
{cam_engine_dynamics}
            </div>

            <h3>Identifier Tuning Table: Camshaft Upgrades</h3>
            <div style="overflow-x: auto;">
                <table class="cal-table">
                    <thead>
                        <tr>
                            <th style="width: 25%;">Identifier Name</th>
                            <th style="width: 15%;">Subsystem</th>
                            <th style="width: 22%;">Action &amp; Recommended Value</th>
                            <th>Tuning Rationale</th>
                        </tr>
                    </thead>
                    <tbody>
{build_section_rows(cam_active)}
                    </tbody>
                </table>
            </div>

            <div class="pro-tip-box">
                <h4>Tuner's Field Checklist: Camshaft Tuning</h4>
                <ol>
                    <li>Raise warm target idle speed (<code>IDLRPM</code>) by +50 to +150 RPM (approx 850–920 RPM) to stabilize vacuum and oil pressure.</li>
                    <li>Add 2–4 degrees of spark advance in the idle region of <code>HOTMAP</code> to improve combustion stability with diluted overlap mixtures.</li>
                    <li>Raise <code>RPMMAP</code> by +200 to +300 RPM to prevent lower idle vacuum from triggering premature part-throttle enrichment.</li>
                    <li>Monitor wideband AFR above 4,800 RPM and add 5% to 10% fueling in <code>PEFTBL</code> to feed increased high-RPM volumetric efficiency.</li>
                </ol>
            </div>
        </section>

        <!-- Master Cross-Reference Matrix -->
        <section id="matrix" class="card" style="margin-bottom: 32px; padding: 24px;">
            <h2 style="margin-top: 0;">Master Calibration Cross-Reference Matrix</h2>
            <p style="color: var(--text-muted); margin-bottom: 16px;">
                Interactive master matrix cross-referencing all tuning identifiers against the five modifications. Use the search box below to filter instantly by identifier name or keyword.
            </p>
            <input type="text" id="matrixSearch" class="search-box" placeholder="Type to filter identifiers (e.g. BATOFF, DCWOT, PWMIN, WOTMAP)..." oninput="filterMatrix()">

            <div style="overflow-x: auto;">
                <table class="cal-table">
                    <thead>
                        <tr>
                            <th style="width: 26%;">Identifier Name</th>
                            <th style="width: 14%;">Subsystem</th>
                            <th class="text-center" style="width: 12%;">Exhaust / Cat</th>
                            <th class="text-center" style="width: 12%;">Throttle Body</th>
                            <th class="text-center" style="width: 12%;">Injectors</th>
                            <th class="text-center" style="width: 12%;">MAP Sensor</th>
                            <th class="text-center" style="width: 12%;">Camshaft</th>
                        </tr>
                    </thead>
                    <tbody id="matrixTbody">
{matrix_html}
                    </tbody>
                </table>
            </div>
        </section>

    </div>

    <script>
        function filterMatrix() {{
            var query = (document.getElementById('matrixSearch').value || '').toLowerCase().trim();
            var rows = document.querySelectorAll('.matrix-row');
            for (var i = 0; i < rows.length; i++) {{
                var row = rows[i];
                var data = row.getAttribute('data-ident') || '';
                if (!query || data.indexOf(query) !== -1) {{
                    row.style.display = '';
                }} else {{
                    row.style.display = 'none';
                }}
            }}
        }}
    </script>
</body>
</html>
"""

    with open(output_html_path, 'w', encoding='utf-8') as f:
        f.write(html_content)

    print(f"Generated standalone tuning guide: {output_html_path}")
