#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
tools/build_ecm_web.py

Generic Static Website Generator for Chrysler Turbo Engine Control Modules (ECM).
Supports:
- LM-87   (Chrysler Logic Module)
- SMEC    (Single Module Engine Controller)
- SBEC    (Single Board Engine Controller)
- SBECII  (Single Board Engine Controller II)
- T3-I    (Turbo III Gen 1 16V Lotus)
- T3-II   (Turbo III Gen 2 16V Lotus)

Features:
1. Auto-detects or accepts ECM family from descriptor JSON or CLI arguments.
2. Dynamically discovers and generates standalone encapsulated HTML viewers for ALL
   referenced .asm assembly files and .tpl template files with line numbers, #L123 highlighting,
   auto-centering scroll, jump-to-line, and Back buttons.
3. Enforces standardized 6-section H2 layout on all calibration pages:
   - Metadata
   - 1. Overview & Purpose
   - 2. Operating Conditions (When Does This Take Effect?)
   - 3. Tuner's Guide & Real-World Calibration
   - 4. Technical / Assembly Mechanics (Reference)
   - 5. Calibration Notes & System Dependencies
4. Generates MPTune Hierarchical TreeView index.html with instant substring search and
   MPTune naming convention (underscores in identifier long names displayed as spaces).
5. Seamlessly inherits and synchronizes the user's selected Dark/Light theme with the main
   Portal (output/index.html), including theme toggle buttons on every page.
6. Validates 100% of internal links across all generated HTML pages.
"""

import os
import sys
import re
import json
import html
import shutil
import argparse
import markdown


# Registry of known ECM families with formal titles and default directory/file mappings
ECM_REGISTRY = {
    'LM': {
        'code': 'LM-87',
        'title': 'Chrysler Logic Module (T-LM)',
        'subtitle': '1985–1987 Dual-Board Controller (Motorola 6803 MCU)',
        'default_json': 'output/t_lm_descriptors.json',
        'default_out': 'output/T-LM-web',
        'hardware_desc': 'Motorola 6803 MCU &bull; 1985–1987 dual-board architecture',
    },
    'LM-87': {
        'code': 'LM-87',
        'title': 'Chrysler Logic Module (T-LM)',
        'subtitle': '1985–1987 Dual-Board Controller (Motorola 6803 MCU)',
        'default_json': 'output/t_lm_descriptors.json',
        'default_out': 'output/T-LM-web',
        'hardware_desc': 'Motorola 6803 MCU &bull; 1985–1987 dual-board architecture',
    },
    'SMEC': {
        'code': 'SMEC',
        'title': 'Single Module Engine Controller (T-SMEC)',
        'subtitle': '1988–1989 Single Module (Motorola 68HC11 MCU)',
        'default_json': 'output/t_smec_descriptors.json',
        'default_out': 'output/T-SMEC-web',
        'hardware_desc': 'Motorola 68HC11 MCU &bull; 1988–1989 single module architecture',
    },
    'SBEC': {
        'code': 'SBEC',
        'title': 'Single Board Engine Controller (T-SBEC)',
        'subtitle': '1990–1991 Consolidated Controller (Motorola 68HC11 MCU)',
        'default_json': 'output/t_sbec_descriptors.json',
        'default_out': 'output/T-SBEC-web',
        'hardware_desc': 'Motorola 68HC11 MCU &bull; 1990–1991 consolidated single-board architecture',
    },
    'SBECII': {
        'code': 'SBECII',
        'title': 'Single Board Engine Controller II (T-SBECII)',
        'subtitle': '1992–1993 Sequential EFI Controller (Motorola 68HC11 MCU)',
        'default_json': 'output/t_sbecii_descriptors.json',
        'default_out': 'output/T-SBECII-web',
        'hardware_desc': 'Motorola 68HC11 MCU &bull; 1992–1993 sequential injection & CCD bus',
    },
    'T3-I': {
        'code': 'T3-I',
        'title': 'Turbo III (Gen 1) 16-Valve (T-T3v1)',
        'subtitle': '1991–1992 Lotus DOHC 16V DDIS Platform',
        'default_json': 'output/t_t3_i_descriptors.json',
        'default_out': 'output/T3-I-web',
        'hardware_desc': '2.2L 16V Lotus DOHC &bull; 1991–1992 distributorless direct ignition',
    },
    'T3-II': {
        'code': 'T3-II',
        'title': 'Turbo III (Gen 2) 16-Valve (T-T3_II)',
        'subtitle': '1993 Lotus DOHC 16V Sequential Platform',
        'default_json': 'output/t_t3_ii_descriptors.json',
        'default_out': 'output/T3-II-web',
        'hardware_desc': '2.2L 16V Lotus DOHC &bull; 1993 sequential EFI platform',
    },
}


def read_text_with_fallback(path: str) -> str:
    raw = open(path, 'rb').read()
    try:
        return raw.decode('utf-8-sig')
    except UnicodeDecodeError:
        return raw.decode('cp1252', errors='replace')


THEME_HEAD_SCRIPT = """    <script>
        (function() {
            function syncTheme() {
                try {
                    var params = new URLSearchParams(window.location.search);
                    var t = params.get('theme') || localStorage.getItem('mptune_theme');
                    if (!t && window.name && window.name.indexOf('mptune_theme=') === 0) {
                        t = window.name.split('=')[1];
                    }
                    if (t !== 'light' && t !== 'dark') {
                        t = 'dark';
                    }
                    document.documentElement.setAttribute('data-theme', t);
                    localStorage.setItem('mptune_theme', t);
                    window.name = 'mptune_theme=' + t;
                    var btn = document.getElementById('themeToggle');
                    if (btn) btn.textContent = t === 'dark' ? 'Light Theme' : 'Dark Theme';
                } catch (e) {
                    document.documentElement.setAttribute('data-theme', 'dark');
                }
            }
            syncTheme();
            window.toggleMptuneTheme = function() {
                var cur = document.documentElement.getAttribute('data-theme') || 'dark';
                var next = cur === 'dark' ? 'light' : 'dark';
                document.documentElement.setAttribute('data-theme', next);
                try {
                    localStorage.setItem('mptune_theme', next);
                    window.name = 'mptune_theme=' + next;
                } catch (e) {}
                var btn = document.getElementById('themeToggle');
                if (btn) btn.textContent = next === 'dark' ? 'Light Theme' : 'Dark Theme';
            };
            window.addEventListener('DOMContentLoaded', syncTheme);
            window.addEventListener('pageshow', syncTheme);
            window.addEventListener('storage', syncTheme);
        })();
    </script>"""


def generate_style_css(ecm_title: str) -> str:
    """
    Generates style.css matching the Chrysler & Dodge Automotive Heritage
    Dark Theme (Dodge Dark Blue & Billet Silver) and Light Theme (Billet Silver & Dodge Dark Blue)
    defined in output/portal.css.
    """
    return f"""/* ==========================================================================
   Chrysler & Dodge Automotive Heritage Stylesheet ({ecm_title})
   Matches user-selected theme from the main Calibration Portal (output/index.html):
   - Dark Theme (Dodge Midnight Blue #07152b & Deep Mopar Blue #0f274a)
   - Light Theme (Polished Billet Silver #d8e1ec & Crisp Light Silver #edf2f8)
   ========================================================================== */

:root, [data-theme="dark"] {{
  --bg-color: #07152b;          /* Dodge Midnight Blue */
  --bg-header: #0b1f3d;         /* Deep Mopar Blue Header */
  --card-bg: #0f274a;           /* Deep Mopar Blue Panel */
  --card-hover: #143360;        /* Lifted Blue Hover */
  --text-main: #f8fafc;         /* Platinum White */
  --text-secondary: #c2d0e0;    /* Crisp Billet Silver */
  --text-muted: #839bb8;        /* Steel Silver */
  --border-color: #274874;      /* Polished Billet Silver / Blue Border */
  --border-focus: #4b8fe2;      /* Vibrant Focus Border */
  --primary: #38bdf8;           /* Electric Sky Blue */
  --primary-hover: #7dd3fc;
  --primary-light: #143360;
  --accent: #38bdf8;
  --code-bg: #040d1a;
  --code-text: #f1f5f9;
  --table-stripe: #0b1f3d;
  --badge-bg: #143360;
  --badge-text: #7dd3fc;
  --shadow-sm: 0 1px 3px rgba(0, 0, 0, 0.4);
  --shadow-md: 0 6px 12px -2px rgba(0, 0, 0, 0.45), 0 3px 6px -3px rgba(0, 0, 0, 0.35);
  --radius: 8px;
}}

[data-theme="light"] {{
  --bg-color: #d8e1ec;          /* Polished Billet Silver Base */
  --bg-header: #c5d3e3;         /* Brushed Aluminum Silver Header */
  --card-bg: #edf2f8;           /* Crisp Light Silver Card */
  --card-hover: #f5f8fc;
  --text-main: #07152b;         /* Deep Dodge Midnight Blue Text */
  --text-secondary: #0f2a52;    /* Mopar Navy Subtext */
  --text-muted: #415d82;        /* Slate Blue */
  --border-color: #8da4be;      /* Steel-Blue Border */
  --border-focus: #071f3f;
  --primary: #0b2f63;           /* Deep Dodge Blue Accent */
  --primary-hover: #071e40;
  --primary-light: #dbe4ef;
  --accent: #0b2f63;
  --code-bg: #07152b;
  --code-text: #f8fafc;
  --table-stripe: #e2eaf4;
  --badge-bg: #c5d3e3;
  --badge-text: #07152b;
  --shadow-sm: 0 1px 2px rgba(7, 21, 43, 0.08);
  --shadow-md: 0 4px 8px -2px rgba(7, 21, 43, 0.14), 0 2px 4px -2px rgba(7, 21, 43, 0.08);
  --radius: 8px;
}}

* {{
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}}

body {{
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
  background-color: var(--bg-color);
  color: var(--text-main);
  line-height: 1.6;
  font-size: 15px;
  padding: 24px 16px;
  transition: background-color 0.2s ease, color 0.2s ease;
}}

.container {{
  max-width: 1080px;
  margin: 0 auto;
}}

/* Theme Toggle Button */
.theme-toggle-btn {{
  background: var(--card-bg);
  color: var(--text-main);
  border: 1px solid var(--border-color);
  padding: 6px 14px;
  border-radius: 6px;
  font-size: 13px;
  cursor: pointer;
  font-weight: 600;
  transition: all 0.15s ease;
  box-shadow: var(--shadow-sm);
}}

.theme-toggle-btn:hover {{
  border-color: var(--border-focus);
  transform: translateY(-1px);
}}

/* Header & Nav */
header.site-header {{
  margin-bottom: 24px;
  padding-bottom: 16px;
  border-bottom: 1px solid var(--border-color);
}}

.nav-bar {{
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
  gap: 12px;
  flex-wrap: wrap;
}}

.nav-link {{
  display: inline-flex;
  align-items: center;
  gap: 6px;
  color: var(--primary);
  text-decoration: none;
  font-weight: 500;
  font-size: 14px;
}}

.nav-link:hover {{
  text-decoration: underline;
}}

h1 {{
  font-size: 26px;
  font-weight: 700;
  color: var(--text-main);
  margin-bottom: 8px;
  display: flex;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
}}

h2 {{
  font-size: 19px;
  font-weight: 600;
  margin-top: 28px;
  margin-bottom: 12px;
  padding-bottom: 6px;
  border-bottom: 1px solid var(--border-color);
  color: var(--text-main);
}}

h3 {{
  font-size: 16px;
  font-weight: 600;
  margin-top: 18px;
  margin-bottom: 8px;
}}

p {{
  margin-bottom: 14px;
  color: var(--text-main);
}}

ul, ol {{
  margin-bottom: 16px;
  padding-left: 24px;
}}

li {{
  margin-bottom: 6px;
}}

hr {{
  border: 0;
  border-top: 1px solid var(--border-color);
  margin: 28px 0;
}}

a {{
  color: var(--primary);
  text-decoration: none;
}}

a:hover {{
  text-decoration: underline;
}}

/* Badges & Tags */
.badge {{
  display: inline-block;
  padding: 3px 8px;
  border-radius: 9999px;
  font-size: 12px;
  font-weight: 600;
  background-color: var(--badge-bg);
  color: var(--badge-text);
  font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
}}

.badge-addr {{
  background-color: var(--primary-light);
  color: var(--primary);
  border: 1px solid var(--border-color);
}}

/* Tables */
table {{
  width: 100%;
  border-collapse: collapse;
  margin: 16px 0 24px 0;
  background-color: var(--card-bg);
  border-radius: var(--radius);
  overflow: hidden;
  box-shadow: var(--shadow-sm);
  border: 1px solid var(--border-color);
  font-size: 14px;
}}

th, td {{
  padding: 10px 14px;
  text-align: left;
  border-bottom: 1px solid var(--border-color);
  vertical-align: top;
}}

th {{
  background-color: var(--table-stripe);
  font-weight: 600;
  color: var(--text-main);
}}

tr:nth-child(even) td {{
  background-color: var(--table-stripe);
}}

tr:last-child td {{
  border-bottom: none;
}}

/* Code & Pre */
pre {{
  background-color: var(--code-bg);
  color: var(--code-text);
  padding: 14px 16px;
  border-radius: var(--radius);
  overflow-x: auto;
  font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
  font-size: 13.5px;
  line-height: 1.5;
  margin: 14px 0 20px 0;
  box-shadow: var(--shadow-sm);
  border: 1px solid var(--border-color);
}}

code {{
  font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, monospace;
  font-size: 0.9em;
  background-color: var(--table-stripe);
  color: var(--accent);
  padding: 2px 5px;
  border-radius: 4px;
  border: 1px solid var(--border-color);
}}

pre code {{
  background: transparent;
  color: inherit;
  padding: 0;
  border: none;
}}

blockquote {{
  border-left: 4px solid var(--primary);
  padding: 8px 16px;
  background-color: var(--primary-light);
  color: var(--text-main);
  border-radius: 0 var(--radius) var(--radius) 0;
  margin: 16px 0;
}}

/* Search Box Container */
.search-container {{
  background-color: var(--card-bg);
  border: 1px solid var(--border-color);
  border-radius: var(--radius);
  padding: 16px;
  margin-bottom: 24px;
  box-shadow: var(--shadow-sm);
}}

.search-input-wrapper {{
  position: relative;
  display: flex;
  align-items: center;
}}

.search-icon {{
  position: absolute;
  left: 14px;
  color: var(--text-muted);
  pointer-events: none;
}}

.search-box {{
  width: 100%;
  padding: 12px 14px 12px 42px;
  font-size: 15px;
  border: 2px solid var(--border-color);
  border-radius: 6px;
  background-color: var(--bg-color);
  color: var(--text-main);
  outline: none;
  transition: border-color 0.15s ease-in-out;
}}

.search-box:focus {{
  border-color: var(--primary);
}}

.search-clear {{
  position: absolute;
  right: 12px;
  background: none;
  border: none;
  color: var(--text-muted);
  cursor: pointer;
  font-size: 16px;
  display: none;
}}

.search-meta {{
  margin-top: 8px;
  font-size: 13px;
  color: var(--text-muted);
  display: flex;
  justify-content: space-between;
  align-items: center;
}}

/* Tree View */
.tree-controls {{
  display: flex;
  gap: 10px;
}}

.btn-sm {{
  padding: 4px 10px;
  font-size: 12px;
  font-weight: 500;
  border-radius: 4px;
  background-color: var(--card-bg);
  color: var(--text-main);
  border: 1px solid var(--border-color);
  cursor: pointer;
}}

.btn-sm:hover {{
  background-color: var(--table-stripe);
}}

.result-card {{
  background-color: var(--card-bg);
  border: 1px solid var(--border-color);
  border-radius: var(--radius);
  padding: 12px 16px;
  margin-bottom: 10px;
  box-shadow: var(--shadow-sm);
  transition: transform 0.1s, border-color 0.1s;
}}

.result-card:hover {{
  border-color: var(--primary);
  transform: translateY(-1px);
}}

.result-header {{
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 4px;
}}

.result-title {{
  font-weight: 600;
  font-size: 15px;
}}

.result-group {{
  font-size: 12px;
  color: var(--text-muted);
}}

.highlight {{
  background-color: #854d0e;
  color: #fef08a;
  border-radius: 2px;
  padding: 0 2px;
}}

[data-theme="light"] .highlight {{
  background-color: #fef08a;
  color: #854d0e;
}}
"""


def clean_latex_to_html(text: str) -> str:
    r"""
    Converts inline ($...$) and block ($$...$$) LaTeX math expressions into clean,
    readable HTML/Unicode so no raw LaTeX commands (\text, \frac, \approx, \ge) leak.
    """
    if not text:
        return ''

    def convert_expr(expr: str) -> str:
        s = expr.strip()
        s = re.sub(r'\\text\{([^}]*)\}', r'\1', s)
        while re.search(r'\\frac\{([^}]*)\}\{([^}]*)\}', s):
            s = re.sub(r'\\frac\{([^}]*)\}\{([^}]*)\}', r'(\1 / \2)', s)
        replacements = [
            (r'\\approx', '≈'),
            (r'\\times', '×'),
            (r'\\cdot', '·'),
            (r'\\ge\b', '≥'),
            (r'\\geq\b', '≥'),
            (r'\\le\b', '≤'),
            (r'\\leq\b', '≤'),
            (r'\\ne\b', '≠'),
            (r'\\neq\b', '≠'),
            (r'\\pm\b', '±'),
            (r'\\Delta\b', 'Δ'),
            (r'\\sim\b', '~'),
            (r'\\propto\b', '∝'),
            (r'\^\\circ', '°'),
            (r'\\circ\b', '°'),
            (r'\\%', '%'),
            (r'\\_', '_'),
            (r'\\left\[', '['),
            (r'\\right\]', ']'),
            (r'\\left\(', '('),
            (r'\\right\)', ')'),
            (r'\\bigl\(', '('),
            (r'\\bigr\)', ')'),
            (r'\\bigl\[', '['),
            (r'\\bigr\]', ']'),
            (r'\\;', ' '),
            (r'\\,', ' '),
            (r'\\quad', ' '),
            (r'\{', ''),
            (r'\}', ''),
        ]
        for pat, rep in replacements:
            s = re.sub(pat, rep, s)
        return re.sub(r'[ \t]+', ' ', s).strip()

    def repl_block(m):
        converted = convert_expr(m.group(1))
        return f"\n\n`{converted}`\n\n"

    text = re.sub(r'\$\$(.*?)\$\$', repl_block, text, flags=re.DOTALL)

    def repl_inline(m):
        inner = m.group(1)
        if re.fullmatch(r'0x[0-9A-Fa-f]+|[0-9A-Fa-f]{2,4}|%[01]{8}', inner.strip()):
            return m.group(0)
        if any(tok in inner for tok in ['\\', '^', '_', '=', '<', '>', 'approx', 'times', 'frac', 'ge', 'le', 'pm']):
            return convert_expr(inner)
        return m.group(0)

    text = re.sub(r'\$([^\$\n]+?)\$', repl_inline, text)
    return text


def get_mp_group_parts(mp_group_raw: str) -> list[str]:
    """
    Splits an mp_group string into folder segments.
    """
    cleaned = (mp_group_raw or '').replace('/', '\\').strip('\\').strip()
    if not cleaned:
        return ['Uncategorized']
    return [p for p in cleaned.split('\\') if p]


def format_group_display(mp_group_raw: str) -> str:
    """
    Formats '5_-_Idle\\B_-_AIS_Decel\\' into '5 - Idle ➔ B - AIS Decel'.
    """
    parts = get_mp_group_parts(mp_group_raw)
    return ' ➔ '.join(p.replace('_', ' ') for p in parts)


def get_descriptor_rel_url(desc: dict) -> str:
    """
    Returns the relative URL from ECM site root to this descriptor's HTML page.
    """
    meta = desc['metadata']
    parts = get_mp_group_parts(meta.get('mp_group', ''))
    html_filename = meta.get('html_filename')
    if not html_filename:
        sn = desc['short_name']
        ln = desc.get('long_name', '')
        fl = desc.get('full_label', sn)
        html_filename = f"{sn}_{ln}.html" if ln and not ln.startswith(sn) else f"{fl}.html"
    return '/'.join(parts + [html_filename])


def build_crosslink_map(descriptors: dict) -> dict[str, str]:
    """
    Maps short_name, full_label, and alternate_names to their root-relative HTML URL.
    """
    link_map = {}
    for sname, desc in descriptors.items():
        url = get_descriptor_rel_url(desc)
        link_map[sname] = url
        fl = desc.get('full_label')
        if fl:
            link_map[fl] = url
        for alt in desc.get('alternate_names', []):
            if alt.get('short_name'):
                link_map[alt['short_name']] = url
            if alt.get('full_label'):
                link_map[alt['full_label']] = url
    return link_map


def render_markdown_section(md_text: str, rel_root: str, current_short: str, crosslink_map: dict[str, str], source_files: set[str]) -> str:
    """
    Renders a markdown section into HTML, converting LaTeX math and linking inline `<code>`
    references to source files (.asm, .tpl) and other calibration identifiers.
    """
    if not md_text or not md_text.strip():
        return '<p><em>None specified.</em></p>'

    cleaned = clean_latex_to_html(md_text)
    html_out = markdown.markdown(cleaned, extensions=['fenced_code', 'tables', 'sane_lists'])

    chunks = re.split(r'(<pre>.*?</pre>)', html_out, flags=re.DOTALL)
    for i in range(0, len(chunks), 2):
        def repl_code(m):
            inner = m.group(1).strip()
            # Check if inner matches any registered source file
            if inner in source_files:
                return f'<a href="{rel_root}/{inner}.html"><code>{inner}</code></a>'
            # Check calibration identifiers (avoid self-links)
            if inner in crosslink_map and inner != current_short:
                target_url = crosslink_map[inner]
                target_short = inner.split('_')[0]
                if target_short != current_short:
                    return f'<a href="{rel_root}/{target_url}"><code>{inner}</code></a>'
            return m.group(0)

        chunks[i] = re.sub(r'<code>([^<]+)</code>', repl_code, chunks[i])

    return ''.join(chunks)


def generate_identifier_page(desc: dict, crosslink_map: dict[str, str], ecm_info: dict, source_files: set[str]) -> str:
    short_name = desc['short_name']
    full_label = desc.get('full_label', short_name)
    long_name = desc.get('long_name', '')
    meta = desc['metadata']

    mp_group_raw = meta.get('mp_group', '')
    mp_parts = get_mp_group_parts(mp_group_raw)
    rel_root = '/'.join(['..'] * len(mp_parts))

    mp_display = format_group_display(mp_group_raw)
    subsystem = meta.get('subsystem', 'General')
    cal_addr = meta.get('calibration_address', 'N/A')
    addr_badge = cal_addr.split()[0] if cal_addr else 'N/A'
    table_type = meta.get('table_type', 'N/A')
    units = meta.get('units') or 'Raw Calibration Value'
    factory_setting = meta.get('factory_setting') or 'See Source Template'

    # Title heading: format long_name with spaces instead of underscores to match MPTune
    display_long_name = long_name.replace('_', ' ') if long_name else ''
    if display_long_name and display_long_name != short_name:
        h1_title = f"{short_name}: {display_long_name}"
    else:
        h1_title = short_name

    # Source Template link
    tpl_info = meta.get('source_template', {})
    tpl_file = tpl_info.get('file', '')
    tpl_line_range = tpl_info.get('line_range') or (f"L{tpl_info['line']}" if tpl_info.get('line') else '')
    tpl_hash = f"#{tpl_line_range}" if tpl_line_range else ''
    if tpl_file:
        tpl_link_html = f'<a href="{rel_root}/{tpl_file}.html{tpl_hash}"><code>{html.escape(tpl_file)}</code></a>'
    else:
        tpl_link_html = '<em>None</em>'

    # If alternate_names exist, include alternate template references
    alt_names = desc.get('alternate_names', [])
    alt_label_note = ''
    if alt_names:
        for alt in alt_names:
            alt_sn = alt.get('short_name', '')
            alt_fl = alt.get('full_label', '')
            alt_label_note += f' (Alias: <code>{html.escape(alt_sn)}</code> / <code>{html.escape(alt_fl)}</code>)'
            alt_tpl = alt.get('source_template', {})
            if alt_tpl.get('file') and alt_tpl.get('file') != tpl_file:
                alt_rng = alt_tpl.get('line_range') or (f"L{alt_tpl.get('line', 1)}" if alt_tpl.get('line') else '')
                alt_hash = f"#{alt_rng}" if alt_rng else ''
                tpl_link_html += f' &nbsp;|&nbsp; <a href="{rel_root}/{alt_tpl["file"]}.html{alt_hash}"><code>{html.escape(alt_tpl["file"])}</code></a>'

    # Assembly Routine link
    asm_info = meta.get('assembly_routine', {})
    asm_file = asm_info.get('file', '')
    rtn_name = asm_info.get('routine')
    rtn_line = asm_info.get('routine_line')
    inst_line = asm_info.get('instruction_line') or rtn_line
    rtn_hash = f"#L{rtn_line}" if rtn_line else (f"#L{inst_line}" if inst_line else '')
    inst_hash = f"#L{inst_line}" if inst_line else rtn_hash

    if asm_file:
        if rtn_name:
            asm_link_html = (
                f'<a href="{rel_root}/{asm_file}.html{rtn_hash}"><code>{html.escape(rtn_name)}</code></a> '
                f'in <a href="{rel_root}/{asm_file}.html{inst_hash}"><code>{html.escape(asm_file)}</code></a>'
            )
        else:
            desc_str = asm_info.get('description', 'Direct symbol reference')
            asm_link_html = (
                f'{html.escape(desc_str)} in '
                f'<a href="{rel_root}/{asm_file}.html{inst_hash}"><code>{html.escape(asm_file)}</code></a>'
            )
    else:
        asm_link_html = '<em>Direct ROM constant</em>'

    # Optional table_properties rows (53 on LM, 108 on SMEC)
    tprops = meta.get('table_properties') or {}
    tprops_rows = ''
    if tprops.get('number_of_points') is not None:
        tprops_rows += f"""<tr>
<td style="text-align: left;"><strong>Number of Points</strong></td>
<td style="text-align: left;">{html.escape(str(tprops['number_of_points']))} Points</td>
</tr>\n"""
    if tprops.get('x_axis'):
        tprops_rows += f"""<tr>
<td style="text-align: left;"><strong>X-Axis</strong></td>
<td style="text-align: left;">{html.escape(str(tprops['x_axis']))}</td>
</tr>\n"""
    if tprops.get('y_axis'):
        tprops_rows += f"""<tr>
<td style="text-align: left;"><strong>Y-Axis</strong></td>
<td style="text-align: left;">{html.escape(str(tprops['y_axis']))}</td>
</tr>\n"""

    # Render standardized 5 content sections
    sec1_md = desc.get('overview_markdown') or desc.get('overview', '')
    sec2_md = desc.get('operating_conditions', '')
    sec3_md = desc.get('tuners_guide_markdown') or desc.get('tuners_guide', '')
    tech_obj = desc.get('technical_mechanics') or {}
    sec4_text_md = tech_obj.get('text', '')
    sec4_asm = tech_obj.get('assembly_code', '')
    sec5_md = desc.get('calibration_notes', '')

    sec1_html = render_markdown_section(sec1_md, rel_root, short_name, crosslink_map, source_files)
    sec2_html = render_markdown_section(sec2_md, rel_root, short_name, crosslink_map, source_files)
    sec3_html = render_markdown_section(sec3_md, rel_root, short_name, crosslink_map, source_files)
    sec5_html = render_markdown_section(sec5_md, rel_root, short_name, crosslink_map, source_files)

    # Section 4 assembly mechanics
    sec4_parts = []
    if sec4_text_md:
        lines = sec4_text_md.splitlines()
        if lines and lines[0].strip().startswith('Inside '):
            intro_line = lines[0].strip()
            rest_md = '\n'.join(lines[1:]).strip()
            sec4_parts.append(render_markdown_section(intro_line, rel_root, short_name, crosslink_map, source_files))
            if sec4_asm:
                sec4_parts.append(f'<pre><code class="language-motorola6803">{html.escape(sec4_asm)}</code></pre>')
            if rest_md:
                sec4_parts.append(render_markdown_section(rest_md, rel_root, short_name, crosslink_map, source_files))
        else:
            if sec4_asm:
                asm_display = asm_file or "Firmware Assembly"
                sec4_parts.append(f'<p>Inside <a href="{rel_root}/{asm_file}.html{inst_hash}"><code>{html.escape(asm_display)}</code></a>:</p>')
                sec4_parts.append(f'<pre><code class="language-motorola6803">{html.escape(sec4_asm)}</code></pre>')
            sec4_parts.append(render_markdown_section(sec4_text_md, rel_root, short_name, crosslink_map, source_files))
    elif sec4_asm:
        asm_display = asm_file or "Firmware Assembly"
        sec4_parts.append(f'<p>Inside <a href="{rel_root}/{asm_file}.html{inst_hash}"><code>{html.escape(asm_display)}</code></a>:</p>')
        sec4_parts.append(f'<pre><code class="language-motorola6803">{html.escape(sec4_asm)}</code></pre>')
    else:
        sec4_parts.append('<p><em>Direct ROM constant reference.</em></p>')

    sec4_html = '\n'.join(sec4_parts)

    return f"""<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{html.escape(h1_title)} | {html.escape(ecm_info['title'])} Reference</title>
{THEME_HEAD_SCRIPT}
    <link rel="stylesheet" href="{rel_root}/style.css">
</head>
<body>
    <div class="container">
        
        <nav class="nav-bar">
            <a href="{rel_root}/index.html" class="nav-link">← Master Calibration Index</a>
            <div style="display: flex; align-items: center; gap: 10px;">
                <span class="badge badge-addr">{html.escape(addr_badge)}</span>
                <button id="themeToggle" class="theme-toggle-btn" type="button" onclick="toggleMptuneTheme()">Light Theme</button>
            </div>
        </nav>
        <div style="font-size: 13px; color: var(--text-muted); margin-bottom: 12px;">
            MP Group: <strong>{html.escape(mp_display)}</strong> &nbsp;|&nbsp; Subsystem: <strong>{html.escape(subsystem)}</strong>
        </div>
        
        <article class="content">
            <h1>{html.escape(h1_title)}</h1>
<h2>Metadata</h2>
<table>
<thead>
<tr>
<th style="text-align: left;">Attribute</th>
<th style="text-align: left;">Value</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align: left;"><strong>Short / Calibration Name</strong></td>
<td style="text-align: left;"><code>{html.escape(short_name)}</code></td>
</tr>
<tr>
<td style="text-align: left;"><strong>Full Identifier Label</strong></td>
<td style="text-align: left;"><code>{html.escape(full_label)}</code>{alt_label_note}</td>
</tr>
<tr>
<td style="text-align: left;"><strong>Subsystem</strong></td>
<td style="text-align: left;">{html.escape(subsystem)}</td>
</tr>
<tr>
<td style="text-align: left;"><strong>MP Group</strong></td>
<td style="text-align: left;"><code>{html.escape(mp_group_raw)}</code></td>
</tr>
<tr>
<td style="text-align: left;"><strong>Calibration Address</strong></td>
<td style="text-align: left;"><code>{html.escape(cal_addr)}</code></td>
</tr>
<tr>
<td style="text-align: left;"><strong>Table Type</strong></td>
<td style="text-align: left;">{html.escape(table_type)}</td>
</tr>
{tprops_rows}<tr>
<td style="text-align: left;"><strong>Units / Scaling</strong></td>
<td style="text-align: left;">{html.escape(units)}</td>
</tr>
<tr>
<td style="text-align: left;"><strong>Factory Setting / Raw Data</strong></td>
<td style="text-align: left;"><code>{html.escape(factory_setting)}</code></td>
</tr>
<tr>
<td style="text-align: left;"><strong>Source Template</strong></td>
<td style="text-align: left;">{tpl_link_html}</td>
</tr>
<tr>
<td style="text-align: left;"><strong>Assembly Routine</strong></td>
<td style="text-align: left;">{asm_link_html}</td>
</tr>
</tbody>
</table>
<hr />
<h2>1. Overview &amp; Purpose</h2>
{sec1_html}
<hr />
<h2>2. Operating Conditions (When Does This Take Effect?)</h2>
{sec2_html}
<hr />
<h2>3. Tuner's Guide &amp; Real-World Calibration</h2>
{sec3_html}
<hr />
<h2>4. Technical / Assembly Mechanics (Reference)</h2>
{sec4_html}
<hr />
<h2>5. Calibration Notes &amp; System Dependencies</h2>
{sec5_html}
        </article>
        <footer style="margin-top: 40px; padding-top: 20px; border-top: 1px solid var(--border-color); font-size: 13px; color: var(--text-muted); text-align: center;">
            {html.escape(ecm_info['title'])} Calibration Reference &bull; Generated from <code>{html.escape(short_name)}</code>
        </footer>
    </div>
</body>
</html>
"""


def generate_source_viewer(raw_filepath: str, output_dir: str, subtitle: str, ecm_info: dict):
    """
    Copies raw_filepath into output_dir and generates `<filename>.html` encapsulated viewer.
    """
    filename = os.path.basename(raw_filepath)
    dest_raw = os.path.join(output_dir, filename)
    shutil.copy2(raw_filepath, dest_raw)

    content = read_text_with_fallback(raw_filepath)
    lines = content.splitlines()
    total_lines = len(lines)

    code_rows = []
    for idx, line in enumerate(lines, start=1):
        escaped = html.escape(line) if line else '&nbsp;'
        code_rows.append(
            f'<div class="code-line" id="L{idx}">'
            f'<a href="#L{idx}" class="line-num">{idx}</a>'
            f'<span class="line-text">{escaped}</span>'
            f'</div>'
        )
    code_html = '\n'.join(code_rows)

    viewer_html = f"""<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{html.escape(filename)} ({html.escape(subtitle)}) | {html.escape(ecm_info['title'])} Reference</title>
{THEME_HEAD_SCRIPT}
    <link rel="stylesheet" href="style.css">
    <style>
        body {{
            padding: 0;
            margin: 0;
            background-color: var(--code-bg);
            color: var(--code-text);
        }}

        .viewer-header {{
            position: sticky;
            top: 0;
            z-index: 100;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 10px 20px;
            background-color: var(--card-bg);
            border-bottom: 1px solid var(--border-color);
            color: var(--text-main);
            box-shadow: var(--shadow-sm);
        }}

        .viewer-nav {{
            display: flex;
            align-items: center;
            gap: 14px;
        }}

        .btn-back {{
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            background-color: var(--primary);
            color: #ffffff !important;
            border-radius: 6px;
            font-weight: 600;
            font-size: 13.5px;
            border: none;
            cursor: pointer;
            text-decoration: none;
            transition: background-color 0.15s;
        }}

        .btn-back:hover {{
            background-color: var(--primary-hover);
            text-decoration: none;
        }}

        .file-info {{
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            font-weight: 600;
        }}

        .jump-box {{
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
        }}

        .jump-input {{
            width: 80px;
            padding: 4px 8px;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            background: var(--bg-color);
            color: var(--text-main);
            font-size: 13px;
        }}

        .code-viewer {{
            padding: 10px 0 60px 0;
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", monospace;
            font-size: 13px;
            line-height: 1.5;
            background-color: var(--code-bg);
            color: var(--code-text);
        }}

        .code-line {{
            display: flex;
            min-height: 20px;
            padding: 0 16px;
            transition: background-color 0.15s;
        }}

        .code-line:hover {{
            background-color: rgba(255, 255, 255, 0.04);
        }}

        .line-num {{
            width: 55px;
            min-width: 55px;
            padding-right: 18px;
            text-align: right;
            color: #64748b;
            user-select: none;
            text-decoration: none;
            border-right: 1px solid #334155;
            margin-right: 16px;
        }}

        .line-num:hover {{
            color: #94a3b8;
            text-decoration: underline;
        }}

        .line-text {{
            white-space: pre;
            flex-grow: 1;
        }}

        .highlight-line {{
            background-color: rgba(234, 179, 8, 0.28) !important;
            border-left: 4px solid #eab308;
            padding-left: 12px !important;
        }}

        .highlight-line .line-num {{
            color: #fef08a !important;
            font-weight: bold;
        }}
    </style>
</head>
<body>
    <header class="viewer-header">
        <div class="viewer-nav">
            <button onclick="handleBack()" class="btn-back">← Back</button>
            <a href="index.html" class="nav-link" style="font-size: 13px;">Master Index</a>
            <span style="color: var(--border-color);">|</span>
            <div class="file-info">
                <span>{html.escape(filename)} ({html.escape(subtitle)})</span>
                <span class="badge" style="font-weight: normal;">{total_lines:,} lines</span>
                <span id="activeLineBadge" class="badge badge-addr" style="display: none;"></span>
            </div>
        </div>
        <div class="jump-box">
            <span>Jump to line:</span>
            <input type="number" id="jumpLine" class="jump-input" placeholder="e.g. 1500" min="1" max="{total_lines}" onkeydown="if(event.key==='Enter') jumpToLine()">
            <a href="{html.escape(filename)}" download class="nav-link" style="font-size: 12.5px; margin-left: 10px;">Raw File</a>
            <button id="themeToggle" class="theme-toggle-btn" type="button" onclick="toggleMptuneTheme()" style="margin-left: 8px;">Light Theme</button>
        </div>
    </header>

    <main class="code-viewer">
{code_html}
    </main>

    <script>
        function handleBack() {{
            if (window.history.length > 1) {{
                window.history.back();
            }} else {{
                window.location.href = 'index.html';
            }}
        }}

        function jumpToLine() {{
            const val = document.getElementById('jumpLine').value;
            if (val) {{
                window.location.hash = '#L' + val;
            }}
        }}

        function applyHashHighlight() {{
            document.querySelectorAll('.highlight-line').forEach(el => {{
                el.classList.remove('highlight-line');
            }});

            const hash = window.location.hash;
            const badge = document.getElementById('activeLineBadge');

            if (!hash) {{
                badge.style.display = 'none';
                return;
            }}

            const singleMatch = hash.match(/^#L(\\d+)$/i);
            const rangeMatch = hash.match(/^#L(\\d+)-L(\\d+)$/i);

            let startLine = null;
            let endLine = null;

            if (singleMatch) {{
                startLine = parseInt(singleMatch[1], 10);
                endLine = startLine;
                badge.textContent = 'Line ' + startLine;
                badge.style.display = 'inline-block';
            }} else if (rangeMatch) {{
                startLine = parseInt(rangeMatch[1], 10);
                endLine = parseInt(rangeMatch[2], 10);
                badge.textContent = 'Lines ' + startLine + ' – ' + endLine;
                badge.style.display = 'inline-block';
            }}

            if (startLine !== null) {{
                const targetEl = document.getElementById('L' + startLine);
                if (targetEl) {{
                    targetEl.scrollIntoView({{ behavior: 'auto', block: 'center' }});
                }}

                for (let i = startLine; i <= endLine; i++) {{
                    const lineEl = document.getElementById('L' + i);
                    if (lineEl) {{
                        lineEl.classList.add('highlight-line');
                    }}
                }}
            }}
        }}

        window.addEventListener('DOMContentLoaded', applyHashHighlight);
        window.addEventListener('hashchange', applyHashHighlight);
    </script>
</body>
</html>
"""
    viewer_out = os.path.join(output_dir, f"{filename}.html")
    with open(viewer_out, 'w', encoding='utf-8') as f:
        f.write(viewer_html)


def build_tree_structure(descriptors: dict) -> tuple[dict, list[dict]]:
    """
    Organizes descriptors into a hierarchical nested tree by mp_group parts,
    and builds the flat CALIBRATION_DATA list for instant substring search.
    """
    root_tree = {'_subgroups': {}, '_items': []}
    calibration_data = []

    for sname, desc in descriptors.items():
        meta = desc['metadata']
        mp_group_raw = meta.get('mp_group', '')
        parts = get_mp_group_parts(mp_group_raw)
        url = get_descriptor_rel_url(desc)

        raw_long = desc.get('long_name') or sname
        if ' / ' in raw_long:
            raw_long = raw_long.split(' / ')[0].strip()
        display_long = raw_long.replace('_', ' ')
        full_label = desc.get('full_label', sname)
        group_display = format_group_display(mp_group_raw)

        node = root_tree
        for part in parts:
            if part not in node['_subgroups']:
                node['_subgroups'][part] = {'_subgroups': {}, '_items': []}
            node = node['_subgroups'][part]

        item_entry = {
            'short': sname,
            'long': display_long,
            'raw_long': raw_long,
            'label': full_label,
            'group': group_display,
            'url': url,
        }
        node['_items'].append(item_entry)
        calibration_data.append(item_entry)

        # Include alternate names in search data
        for alt in desc.get('alternate_names', []):
            alt_short = alt.get('short_name')
            alt_long = alt.get('long_name', alt_short)
            alt_label = alt.get('full_label', alt_short)
            if alt_short:
                calibration_data.append({
                    'short': f"{alt_short} ➔ {sname}",
                    'long': f"{alt_long.replace('_', ' ')} (Alias of {sname})",
                    'raw_long': alt_long,
                    'label': alt_label,
                    'group': group_display,
                    'url': url,
                })

    calibration_data.sort(key=lambda x: (x['short'].lower(), x['long'].lower()))
    return root_tree, calibration_data


def count_tree_items(node: dict) -> int:
    total = len(node['_items'])
    for sub in node['_subgroups'].values():
        total += count_tree_items(sub)
    return total


def render_tree_branch_html(node: dict, indent: int = 4) -> str:
    pad = ' ' * indent
    lines = []

    # 1. Child subgroups sorted alphabetically
    for sub_name in sorted(node['_subgroups'].keys(), key=lambda s: s.lower()):
        sub_node = node['_subgroups'][sub_name]
        display_title = sub_name.replace('_', ' ')
        total_cnt = count_tree_items(sub_node)
        children_html = render_tree_branch_html(sub_node, indent + 12)
        lines.append(f"""{pad}<li class="tree-branch-item">
{pad}    <details class="tree-branch" open>
{pad}        <summary class="tree-summary">
{pad}            <span class="tree-toggle"></span>
{pad}            <span class="folder-title">{html.escape(display_title)}</span>
{pad}            <span class="badge badge-count">{total_cnt}</span>
{pad}        </summary>
{pad}        <ul class="tree-children">
{children_html}
{pad}        </ul>
{pad}    </details>
{pad}</li>""")

    # 2. Leaf items sorted alphabetically by display label (using item['long'] w/ spaces)
    sorted_items = sorted(node['_items'], key=lambda x: (x['long'].lower(), x['short'].lower()))
    for item in sorted_items:
        lines.append(f"""{pad}<li class="tree-item">
{pad}    <a href="{html.escape(item['url'])}" class="tree-link">
{pad}        <span class="item-label">{html.escape(item['long'])}</span>
{pad}        <code class="short-badge">{html.escape(item['short'])}</code>
{pad}    </a>
{pad}</li>""")

    return '\n'.join(lines)


def generate_index_html(descriptors: dict, ecm_info: dict, source_viewers: list[tuple[str, str]]) -> str:
    root_tree, calibration_data = build_tree_structure(descriptors)
    total_identifiers = len(descriptors)
    top_group_count = len(root_tree['_subgroups'])
    tree_branches_html = render_tree_branch_html(root_tree, indent=4)
    cal_data_json = json.dumps(calibration_data, ensure_ascii=False)

    source_nav_links = []
    for fname, stype in source_viewers:
        icon = '📄' if fname.endswith('.asm') else '📋'
        source_nav_links.append(
            f'<a href="{fname}.html" style="display: inline-flex; align-items: center; gap: 6px; padding: 7px 14px; background: var(--card-bg); border: 1px solid var(--border-color); color: var(--text-main); border-radius: 6px; text-decoration: none; font-size: 13.5px;">'
            f'{icon} {html.escape(fname)} ({html.escape(stype)})'
            f'</a>'
        )
    source_links_html = '\n                '.join(source_nav_links)

    return f"""<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{html.escape(ecm_info['title'])} Calibration Reference</title>
{THEME_HEAD_SCRIPT}
    <link rel="stylesheet" href="style.css">
    <style>
        /* MPTune-Style TreeView */
        .treeview-container {{
            background-color: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: var(--radius);
            padding: 16px 20px;
            box-shadow: var(--shadow-sm);
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            font-size: 13.5px;
        }}

        .treeview-root, .treeview-root ul {{
            list-style: none;
            margin: 0;
            padding: 0;
            position: relative;
        }}

        .treeview-root ul.tree-children {{
            margin-left: 20px;
            padding-left: 2px;
            border-left: 1px dotted var(--border-color);
        }}

        .tree-branch-item, .tree-item {{
            position: relative;
            margin: 0;
            padding: 2px 0 2px 18px;
        }}

        /* Horizontal dotted connector from vertical line to item */
        .tree-branch-item::before, .tree-item::before {{
            content: '';
            position: absolute;
            top: 13px;
            left: 0;
            width: 14px;
            border-top: 1px dotted var(--border-color);
        }}

        .tree-summary {{
            display: inline-flex;
            align-items: center;
            cursor: pointer;
            user-select: none;
            padding: 3px 6px;
            border-radius: 4px;
            transition: background-color 0.1s;
        }}

        .tree-summary:hover {{
            background-color: var(--table-stripe);
        }}

        .tree-summary::-webkit-details-marker {{
            display: none;
        }}

        /* [+]/[-] Toggle Box */
        .tree-toggle {{
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 12px;
            height: 12px;
            border: 1px solid var(--text-muted);
            background-color: var(--card-bg);
            color: var(--text-main);
            font-family: ui-monospace, Consolas, monospace;
            font-size: 11px;
            line-height: 1;
            margin-right: 6px;
            font-weight: bold;
            border-radius: 1px;
        }}

        details.tree-branch > summary .tree-toggle::before {{
            content: '+';
        }}

        details.tree-branch[open] > summary .tree-toggle::before {{
            content: '−';
        }}

        .folder-title {{
            font-weight: 600;
            color: var(--text-main);
            margin-right: 8px;
        }}

        .badge-count {{
            font-size: 11px;
            padding: 1px 6px;
            opacity: 0.85;
        }}

        .tree-link {{
            display: inline-flex;
            align-items: baseline;
            gap: 8px;
            padding: 2px 6px;
            border-radius: 4px;
            text-decoration: none;
            color: var(--text-main);
            transition: background-color 0.1s;
        }}

        .tree-link:hover {{
            background-color: var(--table-stripe);
            text-decoration: none;
        }}

        .item-label {{
            color: var(--primary);
            font-weight: 500;
        }}

        .tree-link:hover .item-label {{
            text-decoration: underline;
        }}

        .short-badge {{
            font-size: 11.5px;
            padding: 1px 5px;
            background-color: var(--table-stripe);
            border: 1px solid var(--border-color);
            border-radius: 3px;
            color: var(--accent);
        }}
    </style>
</head>
<body>
    <div class="container">
        <nav class="nav-bar">
            <a href="../index.html" class="nav-link">← Main Calibration Portal</a>
            <button id="themeToggle" class="theme-toggle-btn" type="button" onclick="toggleMptuneTheme()">Light Theme</button>
        </nav>

        <header class="site-header">
            <h1>{html.escape(ecm_info['title'])} Calibration Reference</h1>
            <p style="color: var(--text-muted); margin-top: 6px;">
                Complete technical and tuner-facing documentation for all <strong>{total_identifiers} calibration identifiers</strong> defined for {html.escape(ecm_info['subtitle'])}, organized in MPTune functional group hierarchy.
            </p>
            <div style="margin-top: 14px; display: flex; gap: 10px; flex-wrap: wrap;">
                {source_links_html}
            </div>
        </header>

        <!-- Search Bar Area -->
        <div class="search-container">
            <div class="search-input-wrapper">
                <span class="search-icon">🔍</span>
                <input type="text" id="searchInput" class="search-box" placeholder="Search by identifier name (e.g., 'Advance', 'Overboost', 'PumpShot', 'WOT', 'Fan', 'Idle', 'PW')..." oninput="handleSearch()" autofocus>
                <button id="searchClear" class="search-clear" onclick="clearSearch()" title="Clear search">✕</button>
            </div>
            <div class="search-meta">
                <span id="resultsCount">Showing all {total_identifiers} identifiers across {top_group_count} top-level MP Groups</span>
                <div class="tree-controls" id="treeControls">
                    <button class="btn-sm" onclick="expandAll()">Expand All</button>
                    <button class="btn-sm" onclick="collapseAll()">Collapse All</button>
                </div>
            </div>
        </div>

        <!-- Flat List Search Results View -->
        <div id="searchResults" style="display: none;"></div>

        <!-- Hierarchical Tree View by MP Groupings -->
        <div id="treeContainer">
            <div class="treeview-container">
                <ul class="treeview-root">
{tree_branches_html}
                </ul>
            </div>
        </div>

        <footer style="margin-top: 50px; padding-top: 24px; border-top: 1px solid var(--border-color); font-size: 13px; color: var(--text-muted); text-align: center;">
            {html.escape(ecm_info['title'])} Calibration Web Reference &bull; {total_identifiers} Identifiers &bull; MPTune Hierarchical Tree
        </footer>
    </div>

    <script>
        const CALIBRATION_DATA = {cal_data_json};

        function escapeRegExp(string) {{
            return string.replace(/[.*+?^${{}}()|[\\]\\\\]/g, '\\\\$&');
        }}

        function highlightMatch(text, query) {{
            if (!query) return text;
            const regex = new RegExp(`(${{escapeRegExp(query)}})`, 'gi');
            return text.replace(regex, '<mark class="highlight">$1</mark>');
        }}

        function handleSearch() {{
            const input = document.getElementById('searchInput');
            const clearBtn = document.getElementById('searchClear');
            const query = input.value.trim();
            const treeContainer = document.getElementById('treeContainer');
            const searchResults = document.getElementById('searchResults');
            const resultsCount = document.getElementById('resultsCount');
            const treeControls = document.getElementById('treeControls');

            if (!query) {{
                clearBtn.style.display = 'none';
                treeContainer.style.display = 'block';
                searchResults.style.display = 'none';
                treeControls.style.display = 'flex';
                resultsCount.innerHTML = `Showing all {total_identifiers} identifiers across {top_group_count} top-level MP Groups`;
                return;
            }}

            clearBtn.style.display = 'block';
            treeContainer.style.display = 'none';
            searchResults.style.display = 'block';
            treeControls.style.display = 'none';

            const lowerQuery = query.toLowerCase();
            const matches = CALIBRATION_DATA.filter(item => {{
                return item.short.toLowerCase().includes(lowerQuery) ||
                       item.long.toLowerCase().includes(lowerQuery) ||
                       item.raw_long.toLowerCase().includes(lowerQuery) ||
                       item.label.toLowerCase().includes(lowerQuery);
            }});

            resultsCount.innerHTML = `Found <strong>${{matches.length}}</strong> matches for "<em>${{query}}</em>" (<a href="javascript:void(0)" onclick="clearSearch()">reset</a>)`;

            if (matches.length === 0) {{
                searchResults.innerHTML = `
                    <div style="text-align: center; padding: 40px 20px; color: var(--text-muted); background: var(--card-bg); border-radius: var(--radius); border: 1px solid var(--border-color);">
                        <p style="font-size: 16px; margin-bottom: 8px;">No calibration identifiers found matching "<strong>${{query}}</strong>".</p>
                        <p style="font-size: 13px;">Try searching for a short code (e.g. <code>WOTMAP</code>) or a tuning term (e.g. <code>Enrichment</code>, <code>Advance</code>).</p>
                    </div>`;
                return;
            }}

            let html = '';
            matches.forEach(item => {{
                html += `
                    <div class="result-card">
                        <div class="result-header">
                            <div>
                                <a href="${{item.url}}" class="result-title">
                                    <span class="item-label">${{highlightMatch(item.long, query)}}</span>
                                    <code class="short-badge">${{highlightMatch(item.short, query)}}</code>
                                </a>
                            </div>
                        </div>
                        <div class="result-group" style="margin-top: 4px;">
                            MP Group: <strong>${{item.group}}</strong>
                        </div>
                    </div>`;
            }});
            searchResults.innerHTML = html;
        }}

        function clearSearch() {{
            const input = document.getElementById('searchInput');
            input.value = '';
            handleSearch();
            input.focus();
        }}

        function expandAll() {{
            document.querySelectorAll('details.tree-branch').forEach(el => el.open = true);
        }}

        function collapseAll() {{
            document.querySelectorAll('details.tree-branch').forEach(el => el.open = false);
        }}
    </script>
</body>
</html>
"""


def validate_site_links(output_dir: str) -> tuple[int, list[str]]:
    """
    Scans every generated HTML file in output_dir and verifies that 100% of internal
    relative href links resolve to an existing file on disk.
    """
    total_links_checked = 0
    broken_links = []

    for root, _, files in os.walk(output_dir):
        for fname in files:
            if not fname.endswith('.html'):
                continue
            fpath = os.path.join(root, fname)
            with open(fpath, 'r', encoding='utf-8') as f:
                content = f.read()

            for m in re.finditer(r'href="([^"]+)"', content):
                href = m.group(1)
                if href.startswith(('#', 'javascript:', 'http://', 'https://', 'mailto:')):
                    continue
                if '${' in href:
                    continue
                target_rel = href.split('#')[0].split('?')[0]
                if not target_rel:
                    continue
                target_abs = os.path.normpath(os.path.join(root, target_rel))
                total_links_checked += 1
                if not os.path.exists(target_abs):
                    rel_source = os.path.relpath(fpath, output_dir)
                    broken_links.append(f"{rel_source} -> {href} (missing {target_abs})")

    return total_links_checked, broken_links


def build_ecm_site(json_path: str, output_dir: str, ecm_key: str = None, workspace_root: str = None) -> bool:
    """
    Builds a complete static reference site for a single ECM family.
    """
    if workspace_root is None:
        workspace_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))

    json_path = os.path.abspath(json_path)
    if not os.path.exists(json_path):
        print(f"ERROR: Descriptors JSON file not found: {json_path}")
        return False

    with open(json_path, 'r', encoding='utf-8') as f:
        db = json.load(f)

    # Determine ECM family metadata
    raw_ecm = ecm_key or db.get('ecm_family') or ''
    norm_ecm = raw_ecm.upper()
    if norm_ecm.startswith('T-'):
        norm_ecm = norm_ecm[2:]
    if norm_ecm in ECM_REGISTRY:
        ecm_info = ECM_REGISTRY[norm_ecm]
    else:
        # Generic fallback
        ecm_info = {
            'code': norm_ecm or 'ECM',
            'title': f"Chrysler {norm_ecm or 'ECM'}",
            'subtitle': f"Electronic Control Module Calibration Reference",
            'hardware_desc': 'Automotive Turbo Engine Control Module',
        }

    output_dir = os.path.abspath(output_dir)

    print(f"\n========================================================")
    print(f"Building Static Website for {ecm_info['title']}")
    print(f"  Source JSON: {json_path}")
    print(f"  Target Dir:  {output_dir}")
    print(f"========================================================")

    descriptors = db.get('descriptors', {})
    print(f"Loaded {len(descriptors)} calibration descriptors.")

    # Safely clear old generated files in target directory
    if os.path.exists(output_dir):
        for root, _, files in os.walk(output_dir):
            for fname in files:
                try:
                    os.remove(os.path.join(root, fname))
                except OSError:
                    pass
    os.makedirs(output_dir, exist_ok=True)

    # 1. Generate style.css matching user theme
    css_content = generate_style_css(ecm_info['title'])
    with open(os.path.join(output_dir, 'style.css'), 'w', encoding='utf-8') as sf:
        sf.write(css_content)

    # 2. Collect and generate standalone viewers for all referenced source files
    source_files_set = set()
    source_viewers_list = []
    registered_sources = {}  # filename -> (absolute_path, type_label)

    for desc in descriptors.values():
        meta = desc.get('metadata', {})
        # Source template
        st = meta.get('source_template') or {}
        if st.get('file'):
            fname = st['file']
            source_files_set.add(fname)
            if fname not in registered_sources:
                rel_p = st.get('relative_path')
                abs_p = os.path.join(workspace_root, rel_p.replace('/', os.sep)) if rel_p else None
                registered_sources[fname] = (abs_p, 'Calibration Template')

        # Assembly routine
        ar = meta.get('assembly_routine') or {}
        if ar.get('file'):
            fname = ar['file']
            source_files_set.add(fname)
            if fname not in registered_sources:
                rel_p = ar.get('relative_path')
                abs_p = os.path.join(workspace_root, rel_p.replace('/', os.sep)) if rel_p else None
                registered_sources[fname] = (abs_p, 'Firmware Assembly')

        # Alternate names
        for alt in desc.get('alternate_names', []):
            ast = alt.get('source_template') or {}
            if ast.get('file'):
                fname = ast['file']
                source_files_set.add(fname)
                if fname not in registered_sources:
                    rel_p = ast.get('relative_path')
                    abs_p = os.path.join(workspace_root, rel_p.replace('/', os.sep)) if rel_p else None
                    registered_sources[fname] = (abs_p, 'Calibration Template')

    # Copy files and generate viewers
    print("Generating standalone source viewers...")
    for fname, (abs_path, type_label) in registered_sources.items():
        if abs_path and os.path.exists(abs_path):
            generate_source_viewer(abs_path, output_dir, type_label, ecm_info)
            source_viewers_list.append((fname, type_label))
            print(f"  + Generated viewer for {fname} ({type_label})")
        else:
            print(f"  ! Warning: source file not found at {abs_path}")

    # Copy / update engine tuning guide if applicable for LM (or generic)
    old_web_dir = os.path.join(workspace_root, 'output', 'T-LM-web-old')
    guide_src = os.path.join(old_web_dir, 'tuning_guide_modifications.html')
    if os.path.exists(guide_src) and norm_ecm in ['LM', 'LM-87']:
        guide_txt = read_text_with_fallback(guide_src)
        guide_txt = guide_txt.replace(
            'Fuel_-_Transient_Enrichment/FPWUNK_FuelPulsewidthFunctionUnknown.html',
            'Fuel_-_Running/PTPWOF_PartThrottlePulsewidthOffset.html'
        )
        guide_txt = guide_txt.replace('<html lang="en">', '<html lang="en" data-theme="dark">')
        guide_txt = guide_txt.replace(
            '<link rel="stylesheet" href="style.css">',
            f'{THEME_HEAD_SCRIPT}\n    <link rel="stylesheet" href="style.css">'
        )
        guide_txt = guide_txt.replace(':root {', '[data-theme="light"] {', 1)
        guide_txt = guide_txt.replace(
            '@media (prefers-color-scheme: dark) {\n            :root {',
            ':root, [data-theme="dark"] {'
        )
        guide_txt = guide_txt.replace(
            '@media (prefers-color-scheme: dark) {\r\n            :root {',
            ':root, [data-theme="dark"] {'
        )
        guide_txt = re.sub(r'(--alert-text:\s*#fef3c7;\s*\})\s*\}', r'\1', guide_txt)
        guide_txt = guide_txt.replace('background: rgba(255, 255, 255, 0.96);', 'background: var(--bg-header);')
        guide_txt = re.sub(r'@media\s*\(prefers-color-scheme:\s*dark\)\s*\{\s*\.sticky-nav\s*\{[^}]*\}\s*\}', '', guide_txt)
        guide_txt = guide_txt.replace(
            '<li><a href="#matrix" class="nav-pill" style="border-color: var(--primary); color: var(--primary);">Master Matrix</a></li>\n            </ul>',
            '<li><a href="#matrix" class="nav-pill" style="border-color: var(--primary); color: var(--primary);">Master Matrix</a></li>\n            </ul>\n            <button id="themeToggle" class="theme-toggle-btn" type="button" onclick="toggleMptuneTheme()">Light Theme</button>'
        )
        guide_txt = guide_txt.replace(
            '<li><a href="#matrix" class="nav-pill" style="border-color: var(--primary); color: var(--primary);">Master Matrix</a></li>\r\n            </ul>',
            '<li><a href="#matrix" class="nav-pill" style="border-color: var(--primary); color: var(--primary);">Master Matrix</a></li>\r\n            </ul>\r\n            <button id="themeToggle" class="theme-toggle-btn" type="button" onclick="toggleMptuneTheme()">Light Theme</button>'
        )
        with open(os.path.join(output_dir, 'tuning_guide_modifications.html'), 'w', encoding='utf-8') as gf:
            gf.write(guide_txt)
        source_viewers_list.insert(0, ('tuning_guide_modifications', 'Engine Modifications Guide'))

    # 3. Generate all calibration identifier pages organized by mp_group
    crosslink_map = build_crosslink_map(descriptors)
    generated_pages = 0

    for sname, desc in descriptors.items():
        rel_url = get_descriptor_rel_url(desc)
        target_path = os.path.join(output_dir, rel_url.replace('/', os.sep))
        os.makedirs(os.path.dirname(target_path), exist_ok=True)

        page_html = generate_identifier_page(desc, crosslink_map, ecm_info, source_files_set)
        with open(target_path, 'w', encoding='utf-8') as f:
            f.write(page_html)
        generated_pages += 1

    print(f"Generated {generated_pages} standardized calibration HTML pages.")

    # 4. Generate master index.html
    index_html = generate_index_html(descriptors, ecm_info, source_viewers_list)
    index_path = os.path.join(output_dir, 'index.html')
    with open(index_path, 'w', encoding='utf-8') as f:
        f.write(index_html)
    print(f"Generated master index: {index_path}")

    # 5. Validate all internal links and section headings
    total_links, broken_links = validate_site_links(output_dir)
    if broken_links:
        print(f"ERROR: Found {len(broken_links)} broken links:")
        for b in broken_links[:20]:
            print(f"  - {b}")
        return False

    print(f"Link audit PASSED: {total_links:,} internal links verified with 0 broken links.")
    print(f"Build complete for {ecm_info['title']} -> {output_dir}\n")
    return True


def main():
    parser = argparse.ArgumentParser(description="Generic Static Website Generator for Chrysler Turbo ECM Families.")
    parser.add_argument("--ecm", default=None, help="ECM Family code (e.g. 'smec', 'lm', 'sbec', 'sbecii', 't3-i', 't3-ii')")
    parser.add_argument("--json", default=None, help="Path to JSON descriptors file")
    parser.add_argument("--out", default=None, help="Target output web directory")
    parser.add_argument("--all", action="store_true", help="Build all available ECM families found in output/ directory")
    args = parser.parse_args()

    workspace_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))

    if args.all:
        print("=== Building All Available ECM Families ===")
        success_count = 0
        for code, info in ECM_REGISTRY.items():
            if code in ['LM-87']:  # skip duplicate alias key
                continue
            json_file = os.path.join(workspace_root, info['default_json'])
            out_dir = os.path.join(workspace_root, info['default_out'])
            if os.path.exists(json_file):
                ok = build_ecm_site(json_file, out_dir, ecm_key=code, workspace_root=workspace_root)
                if ok:
                    success_count += 1
            else:
                print(f"Skipping {code}: {json_file} does not exist yet.")
        print(f"\nFinished building {success_count} ECM static reference sites.")
        return

    # Determine targeted ECM
    ecm_key = args.ecm.upper() if args.ecm else None
    json_path = args.json
    output_dir = args.out

    if ecm_key and ecm_key in ECM_REGISTRY:
        info = ECM_REGISTRY[ecm_key]
        if not json_path:
            json_path = os.path.join(workspace_root, info['default_json'])
        if not output_dir:
            output_dir = os.path.join(workspace_root, info['default_out'])

    if not json_path:
        # Default fallback to LM if nothing specified
        json_path = os.path.join(workspace_root, 'output', 't_smec_descriptors.json')
        if not os.path.exists(json_path):
            json_path = os.path.join(workspace_root, 'output', 't_lm_descriptors.json')

    if not output_dir:
        # Derive output dir from json filename
        fname = os.path.basename(json_path).lower()
        if 'smec' in fname:
            output_dir = os.path.join(workspace_root, 'output', 'T-SMEC-web')
        elif 'sbecii' in fname:
            output_dir = os.path.join(workspace_root, 'output', 'T-SBECII-web')
        elif 'sbec' in fname:
            output_dir = os.path.join(workspace_root, 'output', 'T-SBEC-web')
        elif 't3_ii' in fname:
            output_dir = os.path.join(workspace_root, 'output', 'T3-II-web')
        elif 't3' in fname:
            output_dir = os.path.join(workspace_root, 'output', 'T3-I-web')
        else:
            output_dir = os.path.join(workspace_root, 'output', 'T-LM-web')

    ok = build_ecm_site(json_path, output_dir, ecm_key=ecm_key, workspace_root=workspace_root)
    if not ok:
        sys.exit(1)


if __name__ == '__main__':
    main()
