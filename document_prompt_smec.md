I need you to reverse engineer every calibration identifier defined in our ECU calibration template (`.tpl`) and implemented in its corresponding assembly source file (`.asm`), write comprehensive technical and tuner-facing documentation from scratch for each identifier, and output a standardized JSON datastore in the exact same schema as `output/t_lm_descriptors.json`.

### Input Files & Project Configuration:
- **ECM Family Name**: `SMEC` (e.g. `T-LM`, `SMEC`, `T-SBEC`)
- **Calibration Template File**: `cals/SMEC` (e.g. `cals/LM-87/T_LM_22_MTX_A171_Stock.tpl`)
- **Firmware Assembly File**: `cals/SMEC/T-SMEC_v19.asm` (e.g. `cals/LM-87/T-LMv13.asm`)
- **Supporting Reference Docs**: `supporting docs/` directory (plus online Motorola 6801/6803/68HC11 manuals and SAE technical references)
- **Target Output JSON File**: `output/t_smec_descriptors.json` (e.g. `output/t_lm_descriptors.json`)
- **Reference Schema File**: `output/t_lm_descriptors.json`

---

### Project Execution Workflow & Phasing:

#### Phase 1: Automated Manifest Extraction & Anomaly Check
1. Write and run a Python script to parse `cals/SMEC` and extract every calibration identifier with its MPTune metadata (`;mpgrp`, `;mptblcname`, `;mptbllname`, `;mptbladdr`, `;mptbltype`, `;mpsubtype`, `;mpxaxis`, `;mpyaxis`, `;mptbldesc`, `;mpchoices`, number of points, `.org` origin, line numbers/ranges, raw `.byte` / `.word` factory data lines, and any surrounding `;` explanatory comment blocks in the `.tpl` file).
2. Cross-reference `cals/SMEC/T-SMEC_v19.asm` and reference materials in `supporting docs/` to locate exact instruction line numbers, symbol occurrences, inline assembly comments, and the enclosing assembly routine name and start line.
3. Identify and log:
   - **Excluded Computed Views (`excluded_computed_views`)**: Synthetic 3D display surfaces calculated by MPTune (Type 8 / Type 16, such as `FTTIME`, `PTTIME`) that do not exist as independent ROM lookup tables in the firmware.
   - **Consolidated Descriptors (`consolidated_descriptors`)**: Any duplicate or renamed template identifiers that share an identical ROM `.org` address and assembly routine, recording `primary`, `consolidated`, and `reason`.
   - **Dynamic Subsystems (`subsystems`)**: Group active ROM identifiers into logical subsystems appropriate for this specific ECU model based on its `;mpgrp` hierarchy and firmware structure.
4. Save this structural metadata (including any existing `;mptbldesc` text and `.tpl` comment notes) to `manifest.json` and report a summary (including any unreferenced symbols, address mismatches, or ECU-specific quirks) before launching Phase 2.

#### Phase 2: Reverse-Engineering & Authoring Descriptors From Scratch (Parallel Subsystem Batches)
After `manifest.json` is approved, fan out parallel subagents by subsystem. **Do NOT use generic boilerplate or script-generated placeholder text.** For every single identifier in its assigned subsystem, each subagent must:
1. Review any existing description in `cals/SMEC` (`;mptbldesc`, `;mpchoices` bit definitions, and surrounding `;` comment blocks in the template) as a valuable baseline for the parameter's intent and tuner context (while verifying it against the actual assembly code and ignoring blank placeholders like `;mptbldesc Desc`).
2. Read the actual surrounding assembly routine(s) in `cals/SMEC/T-SMEC_v19.asm` where the identifier is loaded, compared, interpolated, or multiplied, and cross-reference `supporting docs/`.
3. Trace the exact control flow, register math, sensor scaling, and bitflags to understand what the parameter physically does on the engine.
4. Author all 5 documentation sections (`overview` / `overview_markdown`, `tuners_guide` / `tuners_guide_markdown`, `operating_conditions`, `technical_mechanics`, and `calibration_notes`) **from scratch**—incorporating the insights from any existing `.tpl` descriptions and expanding them into full, accurate documentation according to the Mandatory Field-by-Field Authoring Specification below.
5. Write its completed descriptors to a subsystem batch JSON file (`batches/<Subsystem>.json`). Proceed through all subsystems until 100% of non-excluded identifiers are fully reverse-engineered and authored.

#### Phase 3: Deterministic Assembly, Indexing & Schema Validation
Once all subsystem batches are authored, write and run a Python builder script to merge `batches/*.json` with `manifest.json` into `output/t_smec_descriptors.json`:
1. Deterministically generate `raw_text` (`"OVERVIEW: <overview> | TUNER'S GUIDE: <tuners_guide>"`) and `mptune_desc` (exact same string with spaces replaced by underscores `_`) from each descriptor's authored `overview` and `tuners_guide`.
2. Deterministically build the `aliases` object (`by_full_label`, `by_long_name`, `by_address`, and lowercase `lookup_index` including any `alternate_names`).
3. Run an automated validation audit verifying:
   - Every key and nested object matches the exact structure and data types of `output/t_lm_descriptors.json`.
   - `total_identifiers` equals `len(descriptors)`.
   - All `source_template` and `assembly_routine` line numbers exist (`verified_exists: true`).
   - Zero forbidden metric units (`kPa`, `°C`, `degC`, `Torr`) or code/assembly jargon in `overview` and `tuners_guide`.

---

### Mandatory Field-by-Field Authoring Specification (Reverse-Engineering From Scratch):

For every identifier, combine any existing `.tpl` description/comments (`;mptbldesc`, `;mpchoices`, section notes) with your reverse-engineering of `cals/SMEC/T-SMEC_v19.asm` to write the following fields from scratch:

1. **`overview` & `overview_markdown` (Section 1: Overview & Purpose)**
   - **What to write from scratch:** A clear, plain-English automotive explanation of what this calibration parameter controls, why the engine controller needs it, the factory setting converted into real-world units, and the underlying combustion, airflow, or vehicle mechanics. Incorporate any useful context already present in the `.tpl` file's `;mptbldesc` or header comments.
   - **Audience rule:** Write strictly for an automotive tuner or gearhead who knows cars and MPTune, **not** software or assembly code. Do **not** include hex numbers (`0x3E80`), ADC counts, bits, bytes, RAM variable names, registers, memory addresses, or subroutine names.
   - **Format:** `overview` must be a single plain-text paragraph (no backticks, no markdown, no newlines). `overview_markdown` is the multi-paragraph Markdown version with backticks around the parameter's short name.

2. **`tuners_guide` & `tuners_guide_markdown` (Section 3: Tuner's Guide & Real-World Calibration)**
   - **What to write from scratch:**
     - **Raising vs. Lowering:** The physical and drivability effects of increasing vs. decreasing the value(s) in MPTune (or enabling/disabling specific options for `;mpchoices` bitmasks).
     - **Edge Cases:** Practical effects of zeroing out or maxing out the parameter (translated into real-world behavior rather than hex).
     - **Real-World Tuning Scenarios:** When and why a tuner adjusts this in MPTune (e.g., larger fuel injectors, 3-bar MAP sensor conversions, 160°F/180°F thermostats, bigger turbochargers, aftermarket camshafts, idle stability, or cold-start tuning), incorporating any tuning tips noted by the template author in `cals/SMEC`.
   - **Audience rule:** Strictly real-world tuner/gearhead language—zero hex values, opcodes, register names, or subroutine names.
   - **Format:** `tuners_guide` must be a single plain-text paragraph (no markdown bullets, backticks, or newlines). `tuners_guide_markdown` is the bulleted Markdown version (`* **Topic**: ...`).

3. **`operating_conditions` (Section 2: Operating Conditions — When Does This Take Effect?)**
   - **What to write from scratch:** A bulleted Markdown list specifying the exact firmware criteria required for the ECU to evaluate this calibration:
     - The enclosing assembly subroutine name(s) and exact line number(s) in `cals/SMEC/T-SMEC_v19.asm`.
     - The specific RAM variables, sensor inputs, timers, or status bitflags tested prior to or during evaluation (e.g., open vs. closed throttle flags, coolant temp thresholds, RPM/MAP gates, start-to-run transfer state).
     - The exact comparison polarity and branch condition (`>=`, `<`, `bcs`, `bcc`, `bhi`, `bls`, bitmask test).

4. **`technical_mechanics` (Section 4: Technical / Assembly Mechanics Reference)**
   - **What to write from scratch:** An object containing `"text"` and `"assembly_code"`:
     - `"text"`: Starts with `"Inside \`<ASM_FILENAME>\`:"`, followed (where helpful for complex math/tables) by a step-by-step register trace (`A`, `B`, `D`, `X`), mathematical formulas, interpolation routine details (`Lookup4ByteTable`, `Lookup5ByteTable`, `mul16bit`), scaling offsets, and bit-shift explanations.
     - `"assembly_code"`: The **verbatim** assembly snippet copied directly from `cals/SMEC/T-SMEC_v19.asm` (with routine name and line range header comment) showing the register loads, comparisons, table lookups, math, and branches.

5. **`calibration_notes` (Section 5: Calibration Notes & System Dependencies)**
   - **What to write from scratch:** A bulleted Markdown list covering:
     - Related tables, coupled thresholds, or companion constants (e.g., turn-on vs. turn-off hysteresis pairs, hold vs. decay timers, cold vs. warm switch points).
     - Firmware quirks, naming misnomers in the `.tpl`, shared hardware output drivers, or sensor scaling interactions.

6. **`metadata` (Extracted + Verified Technical Metadata)**
   - Populate from `cals/SMEC` and `cals/SMEC/T-SMEC_v19.asm`, and refine `table_type` and `units` based on how the assembly actually treats the data (e.g., signed vs. unsigned, 8-bit vs. 16-bit, `;mpchoices` bit assignments, and engineering unit conversion of the stock factory setting).

---

### Mandatory Content, Tone & Style Rules:

1. **Strict Units of Measure (UOM):**
   - Always use US automotive units: **Fahrenheit (`°F` or `degF`)**, **psi** (for boost/positive pressure), and **inHg** (for manifold vacuum and barometric pressure).
   - **Never** use metric or scientific pressure/temperature units such as `kPa`, `°C`, `degC`, `Torr`, `mbar`, or `bar` (using "2-bar" or "3-bar" to name the physical MAP sensor hardware is fine).
2. **Matter-of-Fact, Grounded Technical Tone (No Alarmist Language):**
   - Avoid hyperbolic, dramatic, or alarmist language and wild assumptions about engine failure or performance (e.g., do not write phrases like *"catastrophic destruction"*, *"instantly kills the engine"*, *"melted ring lands"*, *"piston-shattering detonation"*, or use exclamation points `!`).
   - State objectively what the parameter does, how raising or lowering it in MPTune affects fueling, spark, idle, or boost behavior, and realistic drivability trade-offs (e.g., rich bog, lean hesitation, spark knock margin, compressor clutch cycling, or idle stability).

---

### Mandatory JSON Schema (Strict Format Reference):

#### 1. Root Object Structure
```json
{
  "ecm_family": "SMEC",
  "generated_at": "<ISO-8601 UTC timestamp>",
  "total_identifiers": 367,
  "subsystems": ["<Dynamic Subsystem 1>", "<Dynamic Subsystem 2>", "..."],
  "consolidated_descriptors": [
    {
      "primary": "<PrimaryShortName>",
      "consolidated": ["<OldOrAliasShortName>"],
      "reason": "Identical ROM .org origin 0xXXXX and identical assembly routine <RoutineName>"
    }
  ],
  "excluded_computed_views": ["FTTIME", "PTTIME"],
  "descriptors": {
    "<SHORT_NAME>": { ... }
  },
  "aliases": {
    "by_full_label": { "<FullLabel>": "<SHORT_NAME>" },
    "by_long_name": { "<LongName>": "<SHORT_NAME>" },
    "by_address": { "0xXXXX": "<SHORT_NAME>" },
    "lookup_index": {
      "<short_name_lower>": "<SHORT_NAME>",
      "<full_label_lower>": "<SHORT_NAME>",
      "<long_name_lower>": "<SHORT_NAME>"
    }
  }
}
```

#### 2. Per-Identifier Descriptor Object Example (`descriptors["<SHORT_NAME>"]`)
Every identifier in `descriptors` MUST contain these exact keys and structure:
```json
{
  "short_name": "ACCRPM",
  "full_label": "ACCRPM_DoNotAllowAcToEngageAboveThisRPM_4000",
  "long_name": "DoNotAllowAcToEngageAboveThisRPM_4000",
  "overview": "ACCRPM sets the upper engine RPM limit (4,000 RPM from the factory) above which the air conditioning compressor clutch is disengaged. Automotive A/C compressors are designed for low-to-moderate engine speeds. Disengaging the compressor clutch at high RPM reduces accessory belt load and prevents over-spinning the compressor during high-RPM operation. Once engine speed drops back below this threshold, the A/C clutch is allowed to re-engage.",
  "overview_markdown": "`ACCRPM` sets the upper engine RPM limit (4,000 RPM from the factory) above which the air conditioning compressor clutch is disengaged.\n\nAutomotive A/C compressors are designed for low-to-moderate engine speeds. Disengaging the compressor clutch at high RPM reduces accessory belt load and prevents over-spinning the compressor during high-RPM operation. Once engine speed drops back below this threshold, the A/C clutch is allowed to re-engage.",
  "tuners_guide": "Raising the Value: Keeps the A/C compressor engaged to a higher engine RPM, which is generally unnecessary and increases wear on the compressor and accessory belt at high engine speeds. Lowering the Value: Disengages the A/C compressor at a lower RPM, freeing up parasitic engine load earlier during acceleration, though setting it too low may cause the A/C to cut out during normal highway cruising with short gearing.",
  "tuners_guide_markdown": "* **Raising the Value**: Keeps the A/C compressor engaged to a higher engine RPM, which is generally unnecessary and increases wear on the compressor and accessory belt at high engine speeds.\n* **Lowering the Value**: Disengages the A/C compressor at a lower RPM, freeing up parasitic engine load earlier during acceleration, though setting it too low may cause the A/C to cut out during normal highway cruising with short gearing.",
  "operating_conditions": "* Evaluated inside `ControlAirConditioning_MM` at line 1781.\n* Compares 16-bit `EngineRpm_HB` register against `ACCRPM`.\n* If `EngineRpm > ACCRPM` (`bhi LCDF2`), de-energizes the A/C clutch relay.",
  "technical_mechanics": {
    "text": "Inside `T-LMv13.asm`:",
    "assembly_code": "; --- ControlAirConditioning_MM (T-LMv13.asm:1780-1782) ---\n        ldx  EngineRpm_HB                        ; Load live 16-bit engine RPM\n        cpx  ACCRPM_DoNotAllowAcToEngageAboveThisRPM_4000 ; Compare with high-RPM ceiling ($1180, data 0x3E80 = 4000 RPM)\n        bhi  LCDF2                               ; If Engine RPM > 4000 RPM, disengage A/C clutch"
  },
  "calibration_notes": "* **Double-Byte Precision**: Evaluated with a 16-bit index register comparison (`cpx`).",
  "metadata": {
    "subsystem": "Aux_Turbonator",
    "mp_group": "AC_Control\\",
    "calibration_address": "0x1180",
    "table_type": "Type 4 (16-bit Word Constant)",
    "units": "Engine RPM (16-bit word; 0x3E80 = 4,000 RPM)",
    "factory_setting": ".word 0x3E80                     ;Point 1",
    "html_filename": "ACCRPM_DoNotAllowAcToEngageAboveThisRPM_4000.html",
    "source_template": {
      "file": "T_LM_22_MTX_A171_Stock.tpl",
      "relative_path": "cals/LM-87/T_LM_22_MTX_A171_Stock.tpl",
      "line": 4510,
      "line_range": "L4510-L4522",
      "verified_exists": true
    },
    "assembly_routine": {
      "routine": "ControlAirConditioning_MM",
      "description": "ControlAirConditioning_MM in T-LMv13.asm",
      "file": "T-LMv13.asm",
      "relative_path": "cals/LM-87/T-LMv13.asm",
      "routine_line": 1756,
      "instruction_line": 1781,
      "verified_exists": true
    },
    "table_properties": null
  },
  "mptune_desc": "OVERVIEW:_<overview_with_spaces_replaced_by_underscores>_|_TUNER'S_GUIDE:_<tuners_guide_with_spaces_replaced_by_underscores>",
  "raw_text": "OVERVIEW: <overview> | TUNER'S GUIDE: <tuners_guide>"
}
```
*Note on `metadata.table_properties`*:
- Must be `null` for 1D constants / bitmasks (Type 3 Byte, Type 4 Word, Type 5 Bitfield).
- Must be an object for 2D curves/tables (Type 0, Type 1, Type 2):
  ```json
  "table_properties": {
    "number_of_points": 5,
    "x_axis": "Coolant Temperature (Temp, -200 to 260 °F)",
    "y_axis": "Enrichment Factor (1 to 2 factor)"
  }
  ```
*Note on `alternate_names`*:
- If an identifier has consolidated aliases (from `consolidated_descriptors`), include an `"alternate_names"` array at the end of the descriptor object with `{ "short_name", "full_label", "long_name", "source_template", "note" }`.

---

### Critical Technical Rules & Lessons Learned:
1. **Never Hallucinate Assembly Code:** `technical_mechanics.assembly_code` must ALWAYS quote verbatim assembly lines directly from `cals/SMEC/T-SMEC_v19.asm`. Never invent instructions or pseudo-code.
2. **Consult `supporting docs/` & Motorola / SAE Specs:** Cross-check hardware registers, timer prescalers, A/D channel assignments, lookup interpolation routines, and instruction behavior against the documents in `supporting docs/`, Motorola MC6801/6803 and MC68HC11 reference manuals, and SAE literature for the specific ECU architecture being analyzed.
3. **Plain Text vs. Markdown Pair Consistency:**
   - `overview` and `tuners_guide` must be clean, single-line plain text (no backticks, no markdown bullets, no newlines, use `degF` / `~` instead of LaTeX) because they directly generate `raw_text` and `mptune_desc`.
   - `overview_markdown` and `tuners_guide_markdown` hold the formatted Markdown equivalents for UI display.
4. **Signed vs. Unsigned Math:** Watch for two's complement sign-extension logic (`tstb; bpl ...; deca; asld ...; addd ...`) or high-bit sign testing (`0x80`–`0xFF` = negative offset, `0x00`–`0x7F` = positive offset). Explicitly note signed tables in `table_type` and `units`.
5. **Timer & Period Logic Across ECU Families:** In Chrysler 6803 and 68HC11 firmware, distributor reference and speed timers frequently measure pulse period (clock counts between sensor pulses) alongside or instead of direct RPM. Shorter period (`smaller hex value`) = higher RPM or vehicle speed. Always verify whether a comparison uses period or converted RPM and check branch polarity (`bcs` vs `bcc`, `bhi` vs `bls`).
6. **Synthetic 3D Tables:** Tables designated as Type 8 / 16 (such as `FTTIME` and `PTTIME`) are calculated by MPTune in software and do not exist as ROM lookup tables in the MCU firmware. Place them in `excluded_computed_views` rather than inventing assembly references.
7. **UTF-8 File Encoding on Windows:** Always read and write all scripts and JSON files using explicit UTF-8 (`encoding='utf-8'`) with `json.dump(..., indent=2, ensure_ascii=False)` to avoid character corruption.

Please start by analyzing `cals/SMEC`, `cals/SMEC/T-SMEC_v19.asm`, and any relevant files in `supporting docs/`, generate `manifest.json`, and present the Phase 1 summary and execution plan for approval before generating the first subsystem batch.
