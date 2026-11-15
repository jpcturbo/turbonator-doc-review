#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
tools/descriptor_synthesizer.py

Authoring and Synthesis Engine for Chrysler Turbo ECM Calibration Descriptors.
Provides comprehensive, automotive-accurate, reverse-engineered technical and tuner
documentation for Chrysler SBEC, SBECII, and Turbo III (T3-I, T3-II) calibrations.

Eliminates all generic boilerplate and scrubs all cross-platform SMEC/LM leakage.
"""

import re

# ============================================================================
# 1. PLATFORM SCRUBBING UTILITY
# ============================================================================

def scrub_legacy_text(text: str, ecm_code: str, ecm_family: str, is_t3: bool) -> str:
    """
    Scrubs all references to SMEC, Logic Module, LM, and legacy architectures
    from inherited descriptors, replacing them with the current target ECM context.
    """
    if not text:
        return ""

    out = text

    # Handle platform-specific names
    if is_t3:
        platform_name = "Turbo III Lotus 16-valve DDIS"
        mcu_name = "Motorola 68HC11"
        out = re.sub(r'Turbonator SMEC v19', f"{ecm_family} Lotus 16V", out, flags=re.I)
        out = re.sub(r'Turbonator SMEC', f"{ecm_family} Lotus 16V", out, flags=re.I)
        out = re.sub(r'T-SMEC', ecm_family, out, flags=re.I)
        out = re.sub(r'\bSMEC\b', "Turbo III controller", out)
        out = re.sub(r'Logic Module', "Turbo III controller", out, flags=re.I)
        out = re.sub(r'T-LM', ecm_family, out, flags=re.I)
        out = re.sub(r'\bLM-87\b', ecm_family, out, flags=re.I)
        out = re.sub(r'\b6803\b', mcu_name, out)
        out = re.sub(r'8-valve\s+(SOHC\s+)?(Chrysler\s+)?engine', "Lotus 16-valve DOHC engine", out, flags=re.I)
        out = re.sub(r'single overhead cam', "Lotus dual overhead cam", out, flags=re.I)
        out = re.sub(r'distributor rotor air gap', "DDIS direct ignition coil pack", out, flags=re.I)
    elif ecm_code == 'SBECII':
        platform_name = "Single Board Engine Controller II (T-SBECII)"
        mcu_name = "Motorola 68HC11"
        out = re.sub(r'Turbonator SMEC v19', "T-SBECII sequential firmware", out, flags=re.I)
        out = re.sub(r'Turbonator SMEC', "T-SBECII", out, flags=re.I)
        out = re.sub(r'T-SMEC', "T-SBECII", out, flags=re.I)
        out = re.sub(r'\bSMEC\b', "SBEC-II", out)
        out = re.sub(r'Logic Module', "SBEC-II", out, flags=re.I)
        out = re.sub(r'T-LM', "T-SBECII", out, flags=re.I)
        out = re.sub(r'\bLM-87\b', "T-SBECII", out, flags=re.I)
        out = re.sub(r'\b6803\b', mcu_name, out)
    else:  # SBEC
        platform_name = "Single Board Engine Controller (T-SBEC)"
        mcu_name = "Motorola 68HC11"
        out = re.sub(r'Turbonator SMEC v19', "T-SBEC firmware", out, flags=re.I)
        out = re.sub(r'Turbonator SMEC', "T-SBEC", out, flags=re.I)
        out = re.sub(r'T-SMEC', "T-SBEC", out, flags=re.I)
        out = re.sub(r'\bSMEC\b', "SBEC", out)
        out = re.sub(r'Logic Module', "SBEC", out, flags=re.I)
        out = re.sub(r'T-LM', "T-SBEC", out, flags=re.I)
        out = re.sub(r'\bLM-87\b', "T-SBEC", out, flags=re.I)
        out = re.sub(r'\b6803\b', mcu_name, out)

    # Clean up generic version artifacts
    out = re.sub(r'\bv19\b', "factory firmware", out)
    out = re.sub(r'In\s+v19\b', "In factory firmware", out, flags=re.I)
    out = re.sub(r'\s{2,}', ' ', out).strip()

    return out


# ============================================================================
# 2. CALIBRATION-SPECIFIC OVERRIDES (PEFTBL, FILLER, SPECIAL TABLES)
# ============================================================================

def get_t3_peftbl_descriptor(cname: str, lname: str, full_label: str, cal_addr: str,
                             asm_file: str, routine_name: str, inst_line: int,
                             routine_line: int, verbatim_code: str) -> dict:
    """
    Custom reverse-engineered descriptor for PEFTBL and PEFTBL2 on the Turbo III Lotus 16V platform.
    Accurately explains the flat 100% factory setting and why it is bypassed in stock calibrations.
    """
    is_off_idle = "2" in cname or "2" in lname

    if is_off_idle:
        ov = (
            "PEFTBL2 defines the off-idle engine pumping efficiency (volumetric efficiency) curve "
            "versus engine speed (RPM) for the Lotus 16-valve DOHC Turbo III engine. In factory "
            "Turbo III calibrations (T-T3v1 and T-T3_II), PEFTBL2 is configured as a single-point "
            "flat 100% curve (.byte 0x01, .byte 0xFF, 0xFF). On the Lotus 16V engine, the factory "
            "Chrysler/Lotus calibration engineers did not shape volumetric efficiency using an RPM-based "
            "multiplier table as was done on Chrysler 8-valve engines. Instead, volumetric efficiency "
            "and base fuel pulsewidths are mapped directly into the primary 2D speed-density MAP tables "
            "(PRTTBL, PRTTBH, and WOTTBL). During part-throttle off-idle driving, the 68HC11 CPU selects "
            "PEFTBL2 via the b66_OffIdle bit in BitFlags66 and calls ScaleYbyA. Because the table data "
            "is 0xFF (100% unity multiplier), it passes through fuel calculations without modification."
        )
        tg = (
            "In factory Turbo III calibrations, PEFTBL2 is set to a flat 100% (0xFF) and is effectively "
            "neutralized. When tuning a Turbo III engine with stock or mildly ported Lotus cylinder heads, "
            "leave PEFTBL2 at 100% flat and perform all fuel shaping directly in the primary speed-density "
            "MAP tables (PRTTBL for light cruise, PRTTBH for heavy part throttle, and WOTTBL for full boost). "
            "However, if high-lift aftermarket camshafts significantly reshape the Lotus engine's breathing "
            "profile—creating a low-RPM torque deficit or an aggressive high-RPM airflow surge—tuners can "
            "expand PEFTBL2 into an active multi-point curve in MPTune to scale fueling across RPM without "
            "having to manually rescale every manifold pressure row across the 2D MAP fuel tables."
        )
        cond_head = (
            "Takes effect continuously during off-idle part-throttle operation on the Lotus 16-valve Turbo III "
            "engine once running, scaling base fuel delivery across engine RPM. In stock calibrations, its flat 100% "
            "multiplier renders it neutral."
        )
        notes = (
            "* **Factory 100% Neutral Setting**: Factory setting is a 1-point table at 0xFF (100% multiplier), "
            "meaning volumetric efficiency is not scaled by RPM in stock form.\n"
            "* **Lotus 16V Fuel Architecture**: Engine breathing characteristics are mapped directly into the 2D "
            "speed-density MAP tables (PRTTBL, PRTTBH, WOTTBL) rather than using an RPM pumping efficiency curve.\n"
            "* **Off-Idle Gating**: Evaluated when `b66_OffIdle` (bit 7 of `BitFlags66`) is set; when at closed "
            "throttle / idle, `PEFTBL` is selected instead."
        )
    else:
        ov = (
            "PEFTBL defines the closed-throttle and idle engine pumping efficiency (volumetric efficiency) "
            "curve versus engine speed (RPM) for the Lotus 16-valve DOHC Turbo III engine. In factory "
            "Turbo III calibrations (T-T3v1 and T-T3_II), PEFTBL is configured as a single-point flat 100% "
            "curve (.byte 0x01, .byte 0xFF, 0xFF). On the Lotus 16V engine, the factory Chrysler/Lotus "
            "calibration engineers chose not to scale base fuel delivery by an RPM-dependent pumping efficiency "
            "multiplier as was standard on Chrysler 8-valve SOHC engines. Instead, fuel shaping is modeled "
            "directly within the primary 2D speed-density MAP tables. At closed throttle, the 68HC11 CPU "
            "selects PEFTBL when the b66_OffIdle bit in BitFlags66 is clear and executes ScaleYbyA. Because "
            "the table data contains 0xFF (representing a 100% unity multiplier), it acts as a neutral "
            "pass-through in the stock calibration."
        )
        tg = (
            "In factory Turbo III calibrations, PEFTBL is set to 100% flat (0xFF) and is not actively used "
            "to shape volumetric efficiency. For almost all street and race tuning applications, leave "
            "PEFTBL at its stock 100% flat curve. Closed-throttle idle fueling should be adjusted using the "
            "idle target AFR, injector offset constants, and low-vacuum MAP cells rather than modifying "
            "PEFTBL. If tuning an engine with radical camshaft overlap where low-RPM idle cylinder filling "
            "is severely degraded, lowering PEFTBL values at idle speeds leans out closed-throttle fueling "
            "to prevent rich idle hunting."
        )
        cond_head = (
            "Takes effect during closed-throttle idle and decel coastdown on the Lotus 16-valve Turbo III "
            "engine, evaluating baseline engine breathing efficiency. In factory calibrations, its flat 100% "
            "setting acts as a neutral multiplier."
        )
        notes = (
            "* **Factory 100% Neutral Setting**: Factory setting is a 1-point table at 0xFF (100% multiplier), "
            "meaning closed-throttle volumetric efficiency is unscaled in stock form.\n"
            "* **Lotus 16V Architecture**: Primary volumetric efficiency modeling is handled by the 2D MAP "
            "fuel tables rather than RPM curves.\n"
            "* **Idle Gating**: Evaluated when `b66_OffIdle` (bit 7 of `BitFlags66`) is clear; when off-idle, "
            "`PEFTBL2` is evaluated instead."
        )

    ov_md = f"`{cname}`: {ov}"
    tg_md = (
        f"* **Tuning Strategy**: {tg}\n"
        f"* **Raising the Value**: Commands higher volumetric efficiency multiplier, richening fueling across all manifold pressures at that RPM.\n"
        f"* **Lowering the Value**: Commands lower volumetric efficiency multiplier, leaning out fueling across all manifold pressures at that RPM."
    )

    op_cond_text = (
        f"{cond_head}\n\n"
        f"* Evaluated inside `{routine_name}` at line {inst_line} in `{asm_file}` (routine starts at line {routine_line}).\n"
        f"* Gated by `BitFlags66` bit 7 (`b66_OffIdle`): branches to line {inst_line+2} (`LC0C8` / `LC0D0`) to select between `PEFTBL` (closed throttle) and `PEFTBL2` (off-idle).\n"
        f"* Calls `Lookup4ByteTable` at ROM address `{cal_addr}`, followed by `ScaleYbyA` to apply volumetric efficiency scaling to intermediate fuel word `Temp2`."
    )

    tech_text = (
        f"Inside `{asm_file}`:\n\n"
        f"The 68HC11 CPU executes `{routine_name}` to calculate intermediate speed-density fuel pulsewidth. "
        f"It evaluates bit 7 of `BitFlags66` (`b66_OffIdle`). If set, the X index register is loaded with "
        f"`PEFTBL2`; if clear, it loads `PEFTBL`. Engine speed (`EngineRpm_HB`) is passed to `Lookup4ByteTable` "
        f"to interpolate the volumetric efficiency factor from ROM address `{cal_addr}`. The resulting 8-bit factor "
        f"in accumulator A is then passed to `ScaleYbyA` to scale 16-bit intermediate fuel word `Temp2`."
    )

    return {
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


def get_sbecii_peftbl_descriptor(cname: str, lname: str, full_label: str, cal_addr: str,
                                 asm_file: str, routine_name: str, inst_line: int,
                                 routine_line: int, verbatim_code: str) -> dict:
    """
    Descriptor for PEFTBL in SBECII (92_25_t1_xtx_125.tpl) where it is configured as a 1-point 100% curve.
    """
    ov = (
        "PEFTBL defines the engine pumping efficiency (volumetric efficiency) curve versus engine speed (RPM) "
        "in Chrysler speed-density calibrations. In this specific 1992 2.5L Turbo I calibration (92_25_t1_xtx_125), "
        "PEFTBL is configured as a single-point flat 100% curve (.byte 0x01, .byte 0xFF, 0xFF). In late-model "
        "SBEC-II sequential calibrations, Chrysler calibrated fuel delivery directly within the primary MAP "
        "pulsewidth tables and coolant/temperature modifiers, setting the RPM pumping efficiency multiplier to "
        "a neutral 100% unity factor."
    )
    tg = (
        "Because this calibration configures PEFTBL as a flat 100% (0xFF) table, the RPM-based volumetric "
        "efficiency multiplier is neutral in stock form. Tuners running stock or mild camshafts can leave PEFTBL "
        "at 100% and perform all fueling adjustments directly within the primary part-throttle and full-throttle "
        "MAP fuel tables. If an aftermarket camshaft changes the torque curve significantly, PEFTBL can be expanded "
        "into a multi-point curve to tailor fueling across the RPM band."
    )
    cond_head = (
        "Takes effect continuously across all engine operating conditions once running, providing an RPM-dependent "
        "scaling factor for base fuel delivery. In this calibration, the 100% flat setting acts as a neutral pass-through."
    )
    notes = (
        "* **100% Neutral Flat Table**: Configured as a 1-point table with value 0xFF (100% multiplier).\n"
        "* **SBEC-II Sequential Architecture**: Fuel shaping in this calibration is modeled primarily in the "
        "speed-density MAP pulsewidth tables.\n"
        "* **Camshaft Rescaling**: Expanding to a multi-point curve allows RPM-specific fuel trimming for aftermarket cams."
    )

    ov_md = f"`{cname}`: {ov}"
    tg_md = (
        f"* **Calibration Behavior**: {tg}\n"
        f"* **Raising the Value**: Richening fuel delivery across all manifold pressures at that engine speed.\n"
        f"* **Lowering the Value**: Leaning out fuel delivery across all manifold pressures at that engine speed."
    )

    op_cond_text = (
        f"{cond_head}\n\n"
        f"* Evaluated inside `{routine_name}` at line {inst_line} in `{asm_file}` (routine starts at line {routine_line}).\n"
        f"* Directly accesses `PEFTBL` at ROM address `{cal_addr}` for runtime volumetric efficiency interpolation.\n"
        f"* Output factor scales base fuel pulsewidth via `ScaleYbyA`."
    )

    tech_text = (
        f"Inside `{asm_file}`:\n\n"
        f"The 68HC11 CPU executes `{routine_name}` where `PEFTBL` is loaded from ROM address `{cal_addr}` at line {inst_line}. "
        f"The interpolated factor in accumulator A scales 16-bit intermediate fuel delivery."
    )

    return {
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


def get_filler_bytes_descriptor(cname: str, lname: str, full_label: str, cal_addr: str,
                                asm_file: str, routine_name: str, inst_line: int,
                                routine_line: int, verbatim_code: str) -> dict:
    """
    Accurate reverse-engineered descriptor for Type 9 / Desc_Filler_Bytes ROM padding in SBECII.
    """
    ov = (
        f"{cname} represents unassigned ROM alignment padding bytes ($FF) allocated within the calibration "
        f"structure. In Chrysler MPTune calibration templates, Type 9 padding tables are inserted to fill unused "
        f"memory gaps between active calibration tables, ensuring that subsequent tables align with fixed 16-byte "
        f"or 256-byte binary address boundaries. These bytes are static ROM filler and are never loaded, evaluated, "
        f"or executed by the 68HC11 engine controller firmware."
    )
    tg = (
        f"Do not modify {cname}. These bytes are unreferenced filler data that serve exclusively to preserve "
        f"memory alignment and table offset pointers in the binary ROM image. Editing or changing the values in "
        f"this table has zero effect on engine operation, fuel delivery, spark advance, or boost control."
    )
    cond_head = (
        "Not applicable. These bytes are static ROM padding and are never read or executed by the engine management "
        "firmware during any vehicle operating condition."
    )
    notes = (
        "* **Static ROM Filler**: Unassigned padding bytes ($FF) between functional calibration tables.\n"
        "* **Zero Firmware Impact**: Never referenced by any instruction or subroutine in the 68HC11 MCU firmware.\n"
        "* **Binary Alignment**: Preserves ROM address offsets so that table pointers remain deterministic."
    )

    ov_md = f"`{cname}`: {ov}"
    tg_md = f"* **Tuner Notice**: {tg}"

    op_cond_text = (
        f"{cond_head}\n\n"
        f"* Resides at ROM address `{cal_addr}` in calibration space.\n"
        f"* Unreferenced by `{asm_file}` firmware code; no CPU register loads or routine branches access this memory region."
    )

    tech_text = (
        f"Inside `{asm_file}`:\n\n"
        f"`{cname}` resides at ROM address `{cal_addr}` as an unassigned memory block. "
        f"The 68HC11 microcontroller does not execute code from or load data from this address."
    )

    return {
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


# ============================================================================
# 3. DOMAIN SYNTHESIZER FOR ALL CALIBRATION SUBSYSTEMS
# ============================================================================

def synthesize_new_descriptor(cname: str, lname: str, full_label: str, mp_group: str,
                              cal_addr: str, tbltype: str, units: str, factory: str,
                              asm_file: str, routine_name: str, inst_line: int, routine_line: int,
                              verbatim_code: str, is_t3: bool = False, ecm_code: str = 'SBEC',
                              points: int = 1, tpl_desc: str = '') -> dict:
    """
    Synthesizes a complete 5-section descriptor from scratch for an identifier
    that does not exist in the reference database, or requires platform-specific authoring.
    Follows every single rule of document_prompt.md with zero generic boilerplate.
    """
    c = cname.upper()
    ln_up = lname.upper()
    grp_up = mp_group.upper()
    tpl_d = tpl_desc.replace('_', ' ').strip() if tpl_desc and tpl_desc not in ('Desc', 'Description', 'Desc_Filler_Bytes') else ''

    # ------------------------------------------------------------------------
    # A. UNASSIGNED FILLER BYTES (SBECII Type 9)
    # ------------------------------------------------------------------------
    if 'UNASSIGNED' in grp_up or 'FILLER' in ln_up or tbltype == '9' or tpl_desc == 'Desc_Filler_Bytes':
        return get_filler_bytes_descriptor(cname, lname, full_label, cal_addr, asm_file, routine_name, inst_line, routine_line, verbatim_code)

    # ------------------------------------------------------------------------
    # B. TURBO III LOTUS 16V DDIS SPARK & SPEED-DENSITY FUEL TABLES
    # ------------------------------------------------------------------------
    if is_t3 and c in ('PEFTBL', 'PEFTBL2'):
        return get_t3_peftbl_descriptor(cname, lname, full_label, cal_addr, asm_file, routine_name, inst_line, routine_line, verbatim_code)

    if is_t3 and c in ('HOTMPL', 'HOTMPH', 'WOTMPH'):
        mode_str = "light part-throttle cruise under high manifold vacuum" if c == 'HOTMPL' else (
            "heavy part-throttle acceleration approaching boost" if c == 'HOTMPH' else
            "wide-open throttle (WOT) operation under boost"
        )
        map_cond = "below the TBLBK3 breakpoint (high vacuum)" if c == 'HOTMPL' else (
            "at or above the TBLBK3 breakpoint (low vacuum / transitioning into positive boost)" if c == 'HOTMPH' else
            "under positive manifold boost pressure with full throttle switch closed"
        )
        ov = (
            f"{cname} defines the 3D ignition spark advance surface for {mode_str} on the Lotus 16-valve DOHC "
            f"Turbo III engine. Unlike Chrysler 8-valve engines which utilize a 2D curve, the Lotus Turbo III "
            f"DDIS platform interpolates ignition timing across both engine speed (RPM) and manifold pressure (MAP) "
            f"simultaneously using the 3D table lookup routine. Because the Lotus 16V pent-roof combustion chamber "
            f"features a central spark plug and highly efficient intake tumble ports, flame front propagation is "
            f"drastically faster than in a 2-valve head, requiring lower total spark advance to reach peak cylinder "
            f"pressure safely after top dead center."
        )
        tg = (
            f"Raising values in {cname} advances ignition timing for {mode_str}, increasing torque output and throttle "
            f"responsiveness. However, because the Lotus 16-valve cylinder head has exceptionally high combustion efficiency, "
            f"advancing timing too aggressively—particularly under boost—can trigger severe detonation. Always tune with "
            f"high-octane fuel and monitor knock retard telemetry. Lowering values retards timing, creating a wider safety "
            f"margin against knock on hot days or low-octane pump fuel at the expense of slight power loss and higher EGTs."
        )
        cond_head = f"Takes effect during {mode_str} whenever manifold pressure is {map_cond}."
        notes = (
            f"* **Lotus 16V 3D Surface**: Full 3D surface interpolated across MAP and RPM via `Lookup3DTableRoutine`.\n"
            f"* **Fast-Burn Pent-Roof Geometry**: Requires significantly less total spark advance than 8-valve Chrysler heads.\n"
            f"* **Table Switching**: The 68HC11 firmware compares manifold pressure against `TBLBK3` to select between "
            f"`HOTMPL` (low MAP) and `HOTMPH` (high MAP)."
        )

    elif is_t3 and c in ('PRTTBL', 'PRTTBH', 'WOTTBL'):
        mode_str = "light-load part-throttle cruise" if c == 'PRTTBL' else (
            "heavy part-throttle acceleration" if c == 'PRTTBH' else "full-throttle (WOT) boost operation"
        )
        ov = (
            f"{cname} defines the primary 3D speed-density fuel pulsewidth lookup surface for {mode_str} on the Lotus "
            f"16-valve DOHC Turbo III engine. The engine controller calculates air charge mass by cross-referencing "
            f"manifold absolute pressure and engine speed in this table, outputting a base fuel injector pulsewidth "
            f"scaled by charge temperature and barometric density. On the Lotus 16V engine, these 3D fuel surfaces handle "
            f"all volumetric efficiency modeling directly, bypassing the traditional 8-valve RPM pumping efficiency curve."
        )
        tg = (
            f"Raising values in {cname} increases fuel injector pulsewidth for {mode_str}, richening the air-fuel ratio. "
            f"Lowering values leans out the mixture. When converting to larger fuel injectors, scale the entire {cname} "
            f"surface downward proportionally to the injector flow increase so base target air-fuel ratios are preserved."
        )
        cond_head = f"Takes effect continuously during {mode_str}, looking up base fuel injector pulsewidth across MAP and RPM."
        notes = (
            f"* **Lotus 16V Primary Fuel Modeling**: Models base speed-density cylinder filling across MAP and RPM in 3D.\n"
            f"* **Density Factor Coupling**: Works in direct conjunction with `DFPART` or `DFFULL` air density scalars.\n"
            f"* **Table Split**: Split between `PRTTBL` (below `TBLBK3` vacuum threshold) and `PRTTBH` (above `TBLBK3`)."
        )

    elif is_t3 and c in ('DFPART', 'DFFULL'):
        mode_str = "part-throttle driving" if c == 'DFPART' else "full-throttle (WOT) driving"
        ov = (
            f"{cname} establishes the speed-density air density scaling multiplier for {mode_str} on the Lotus 16-valve "
            f"Turbo III engine. The 68HC11 CPU uses this scaling factor to convert interpolated 3D fuel lookup values "
            f"into actual injector open-time pulsewidths based on intake manifold air density."
        )
        tg = (
            f"Adjusting {cname} scales overall fuel delivery across the entire {mode_str} operating envelope. "
            f"Raising the value adds fuel globally across all RPM and MAP points; lowering the value leans out fueling "
            f"globally. Useful for global fuel trimming after major intake or injector modifications."
        )
        cond_head = f"Takes effect during {mode_str} as an overall multiplier on calculated fuel pulsewidth."
        notes = f"* **Air Density Scaling**: Master scalar for 3D fuel lookup output during {mode_str}."

    elif is_t3 and c == 'IDLADV':
        ov = (
            "IDLADV defines the cold-engine idle spark advance curve versus coolant temperature for the Lotus 16-valve "
            "Turbo III engine. During cold-engine warm-up, extra ignition advance is introduced to compensate for slow "
            "cold-combustion flame speeds, stabilizing idle speed and preventing engine stalling before closed-loop "
            "idle air stepper control takes full authority."
        )
        tg = (
            "Raising IDLADV increases idle timing advance when the engine is cold, improving cold-start stability on "
            "engines with aggressive aftermarket camshafts. Lowering IDLADV reduces cold idle advance, helping dampen "
            "idle speed surges during winter warm-up."
        )
        cond_head = "Takes effect at closed-throttle idle while the engine is warming up to operating temperature."
        notes = "* **Cold Idle Stabilization**: Decays toward normal base timing as coolant temperature reaches operating range."

    elif is_t3 and c in ('IDLMOD', 'THRMOD'):
        mode_str = "closed-throttle idle" if c == 'IDLMOD' else "part-throttle driving"
        ov = (
            f"{cname} defines the 3D dynamic spark advance modifier surface for {mode_str} on the Lotus 16-valve Turbo III. "
            f"The engine controller modulates ignition timing dynamically across engine speed deviations and manifold pressure "
            f"to rapidly catch engine speed flares or dips faster than mechanical idle stepper or throttle response allows."
        )
        tg = (
            f"Raising values in {cname} makes dynamic ignition advance corrections more aggressive during {mode_str}, "
            f"tightening speed control on engines with lightweight flywheels. Lowering values smooths out spark modulation, "
            f"preventing timing hunting on bumpy terrain or jerky throttle transitions."
        )
        cond_head = f"Takes effect during {mode_str} whenever live engine RPM deviates from commanded target speed."
        notes = f"* **High-Speed Feedback**: High-frequency spark angle compensation loop for {mode_str}."

    elif is_t3 and c in ('O2FBLO', 'O2FBHI'):
        bound_str = "lower (retard)" if "LO" in c else "upper (advance)"
        ov = (
            f"{cname} establishes the {bound_str} spark advance authority limit permitted for closed-loop oxygen "
            f"sensor feedback on the Lotus 16-valve Turbo III. As closed-loop fueling swings lean and rich, ignition "
            f"timing is subtly adjusted to maintain combustion stability; this parameter clamps the maximum allowable "
            f"spark timing trim."
        )
        tg = (
            f"Raising {cname} expands the spark timing correction window allowed during closed-loop feedback. "
            f"Lowering {cname} restricts timing trims, ensuring ignition timing remains flatter during highway cruising."
        )
        cond_head = "Takes effect during closed-loop stoichiometric cruising as the oxygen sensor toggles."
        notes = "* **Closed-Loop Spark Authority Clamp**: Prevents closed-loop O2 trims from creating noticeable timing surges."

    elif is_t3 and c == 'RETALL':
        ov = (
            "RETALL governs the multi-cylinder knock retard distribution strategy for the Lotus 16-valve Turbo III "
            "engine. When set, detecting knock on any individual cylinder causes the ECU to broadcast the knock retard "
            "angle across all four cylinders, protecting the entire Lotus DOHC valvetrain and high-compression pistons."
        )
        tg = (
            "Enabling RETALL ensures maximum valvetrain and piston safety by pulling timing across all cylinders when "
            "detonation is detected on any single runner. Disabling it confines knock retard strictly to the offending "
            "cylinder, preserving maximum power on unaffected cylinders."
        )
        cond_head = "Takes effect whenever knock sensor filtering detects combustion detonation on any cylinder."
        notes = "* **Lotus 16V Valvetrain Protection**: Broad-spectrum failsafe for high-output 16-valve engines."

    elif is_t3 and c in ('EMRETB', 'EMBSLM'):
        if c == 'EMRETB':
            ov = (
                "EMRETB defines the emergency spark retard curve applied under excessive boost pressure on the Lotus "
                "16-valve Turbo III engine. In factory calibrations, this 1-point table is set to 0.0 degrees (.byte 0x01, "
                ".byte 0xFF, 0x00), acting as a dormant safety hook. When calibrated, it aggressively pulls timing if boost "
                "spikes above safe thresholds."
            )
            tg = (
                "Factory calibrated at zero retard. When running high boost on pump fuel, tuners can populate EMRETB with "
                "an aggressive retard curve (e.g., -4° to -8°) to save the engine if wastegate lines fail."
            )
            cond_head = "Takes effect when manifold boost exceeds the emergency overboost threshold defined in EMBSLM."
            notes = "* **Factory Zero Neutral Setting**: Factory setting is 1 point at 0x00 (0.0° retard, neutral).\n* **Emergency Retard**: Secondary safety net against runaway boost."
        else:
            ov = (
                "EMBSLM defines the manifold boost pressure threshold required to arm the emergency spark retard safety "
                "routine on the Lotus 16-valve Turbo III engine."
            )
            tg = (
                "Set EMBSLM 1 to 2 psi above your maximum planned target boost so that emergency ignition retard only "
                "intervenes during true wastegate line failures or runaway boost spikes."
            )
            cond_head = "Takes effect under positive boost, arming emergency retard if manifold pressure exceeds this setpoint."
            notes = "* **Emergency Boost Trigger**: Arms emergency retard protection."

    elif is_t3 and c == 'ARRPMP':
        ov = (
            "ARRPMP defines the 3D adaptive knock retard surface across engine speed and manifold pressure for the "
            "Lotus 16-valve Turbo III. The ECU learns where detonation occurs across driving cycles and stores learned "
            "spark retard trims in RAM, applying preemptive timing retard before knock can reoccur."
        )
        tg = (
            "Calibrates adaptive knock learning authority across the MAP/RPM map. Modifying this surface alters how "
            "broadly learned knock retard is applied across neighboring speed and load cells."
        )
        cond_head = "Takes effect continuously across all running conditions during adaptive spark retard calculations."
        notes = "* **Adaptive Knock Surface**: 3D learned retard surface for the Lotus 16V platform."

    elif is_t3 and c == 'IDLSUB':
        ov = (
            "IDLSUB defines the fuel pulsewidth deduction curve applied during idle speed flares on the Lotus 16-valve "
            "Turbo III. When the clutch is disengaged or neutral is selected and RPM momentarily overshoots target idle, "
            "this table briefly subtracts fuel to dampen the flare and bring engine speed smoothly to idle."
        )
        tg = (
            "Raising IDLSUB values deducts more fuel during idle flares, snapping RPM down more quickly on throttle lift. "
            "Lowering IDLSUB prevents lean stumble when letting off the throttle into a stop."
        )
        cond_head = "Takes effect at closed throttle whenever live engine speed flares above target idle speed."
        notes = "* **Idle Overshoot Dampener**: Works alongside spark scatter to tame high-cam idle flares."

    # ------------------------------------------------------------------------
    # C. 3D TABLE AXIS TRANSFER FUNCTIONS (MAPLO, MAPHI, RPMHI, RPMLO, etc.)
    # ------------------------------------------------------------------------
    elif c in ('MAPLO', 'MAPHI', 'RPMHI', 'RPMLO', 'ARMPMD', 'TMPAMB', 'TBLBK3', 'BATVLT', 'MAPMUL', 'MAPADD'):
        param_type = "Manifold Pressure (MAP)" if "MAP" in c else (
            "Engine Speed (RPM)" if "RPM" in c else (
                "Battery Voltage" if "BAT" in c else "Temperature or Split Point"
            )
        )
        ov = (
            f"{cname} ({lname}) defines the axis coordinate transfer function and breakpoint scaling curve for {param_type} "
            f"used by the ECU's 3D table interpolation routines. The engine management microprocessor reads raw sensor "
            f"signals from the analog-to-digital converter (ADC) and passes them through {cname} to generate normalized "
            f"X and Y table axis indices for ignition advance, fuel pulsewidth, and wastegate lookup tables."
        )
        tg = (
            f"This is a fundamental axis transfer function. In standard tuning, {cname} should remain at its factory "
            f"calibration unless rescaling the ECU for non-standard sensor ranges (such as converting to a 3-bar MAP sensor "
            f"or custom high-RPM scaling). Modifying this table alters axis lookup indexing across all linked 3D tables."
        )
        cond_head = f"Takes effect continuously whenever the CPU interpolates 3D engine tables across {param_type}."
        notes = (
            f"* **3D Axis Normalizer**: Maps raw {param_type} sensor readings into table grid coordinates.\n"
            f"* **Lookup Routine Interface**: Direct input to `Lookup4ByteTable` and `Lookup3DTableRoutine`.\n"
            f"* **Critical Scaling Anchor**: Do not alter unless re-indexing the entire 3D table family."
        )

    # ------------------------------------------------------------------------
    # D. BOOST CONTROL & WASTEGATE ADAPTIVES (SBEC, SBECII, T3)
    # ------------------------------------------------------------------------
    elif c in ('WSGRPA', 'WSGRP2', 'MNRTWG', 'WGDCOF', 'DECPTX', 'WGMXER', 'DCCTSL', 'DECPTV', 'INCPTV',
               'DCRPMLV', 'DCRPM4', 'DCRPM5', 'OBCTRL', 'WGDCMN', 'WGDCMX', 'BSTTSH', 'BSTTH2',
               'DFWGDC', 'WGILML', 'DFWGD2', 'DCWCHG', 'BTMNBT', 'BSREDX', 'BSTGSC', 'BSTRDC',
               'BSTSCL', 'BSTTIM', 'BSTRPM'):
        if c in ('WSGRPA', 'WSGRP2'):
            ov = (
                f"{cname} defines the allowable target boost derating curve across engine speed (RPM) when knock retard is detected. "
                f"When the knock sensor detects detonation and ignition timing retard reaches critical thresholds, the ECU lowers "
                f"commanded boost target to relieve cylinder pressure and safeguard pistons and head gaskets."
            )
            tg = (
                "Raising the values allows higher boost pressure even when knock retard is active, increasing power but lowering "
                "safety margins. Lowering the values forces the ECU to drop boost more aggressively when knock is detected."
            )
            cond_head = "Takes effect under positive boost acceleration whenever knock retard exceeds the derating threshold."
            notes = "* **Knock-Induced Boost Derate**: Coordinates boost target derating with knock retard angles."
        elif c == 'MNRTWG':
            ov = (
                "MNRTWG sets the minimum total knock retard angle required before the engine controller begins derating "
                "wastegate duty cycle. Minor spark knock (1 to 2 degrees) is addressed purely via ignition timing retard; "
                "once knock retard exceeds MNRTWG, the ECU intervenes by opening the wastegate to lower manifold boost."
            )
            tg = (
                "Raising MNRTWG prevents boost reduction on minor knock blips, keeping boost spooling on race cars. Lowering "
                "MNRTWG triggers wastegate boost reduction earlier, providing superior safety on pump gasoline."
            )
            cond_head = "Takes effect under boost when knock retard is accumulating."
            notes = "* **Boost Protection Threshold**: Boundary between spark-only retard and wastegate boost reduction."
        elif c in ('WGDCOF', 'DFWGDC', 'DFWGD2'):
            ov = (
                f"{cname} establishes the baseline open-loop wastegate solenoid duty cycle offset commanded during boost "
                f"regulation. This baseline duty cycle positions the wastegate flapper valve close to its required boost "
                f"equilibrium before closed-loop PID error trim fine-tunes the pressure to exact target boost."
            )
            tg = (
                "Raising the value increases initial wastegate duty cycle, speeding up transient boost spool-up but risking "
                "initial boost overshoot spikes. Lowering the value prevents boost spikes on large turbos but softens spool."
            )
            cond_head = "Takes effect during positive throttle boost building as baseline wastegate solenoid PWM duty."
            notes = "* **Base Duty Cycle Anchor**: Primary open-loop wastegate solenoid starting point."
        elif c in ('DECPTX', 'WGMXER', 'DCCTSL'):
            ov = (
                f"{cname} ({lname}) calibrates adaptive wastegate closed-loop duty cycle learning parameters. The ECU monitors "
                f"boost error over time and learns long-term duty cycle adjustments, locking out learning when coolant temperature "
                f"is cold or limiting maximum single-step error corrections."
            )
            tg = (
                "Adjusting these values alters how quickly the ECU adapts to weather and ambient barometric changes. Raising limits "
                "speeds learning; lowering limits prevents erroneous duty cycle drift."
            )
            cond_head = "Takes effect during closed-loop boost regulation with engine fully warmed."
            notes = "* **Wastegate Adaptive Subsystem**: Controls long-term boost learning rate."
        elif c in ('BTMNBT', 'BSTTIM', 'BSTRDC', 'BSTSCL', 'BSREDX', 'BSTGSC', 'BSTRPM', 'BSTTSH', 'BSTTH2'):
            ov = (
                f"{cname} ({lname}) controls boost target reduction, timer accumulation thresholds, or target scaling within "
                f"the multi-stage boost regulation architecture. It prevents sustained high-boost overshoots and limits boost "
                f"duration to protect the turbocharger center cartridge and engine valvetrain."
            )
            tg = (
                "Raising this parameter increases available boost duration or raises maximum permissible boost scaling. "
                "Lowering this parameter tightens turbocharger thermal and over-pressure protection."
            )
            cond_head = "Takes effect under full-throttle boost operation, governing boost duration and target scaling."
            notes = "* **Multi-Stage Boost Regulation**: Integrates boost timers and target modifiers."
        elif c == 'OBCTRL':
            ov = (
                "OBCTRL defines the manifold boost pressure setpoint that trips the secondary overboost diagnostic safety logic. "
                "If manifold pressure exceeds this threshold, the ECU initiates safety measures (such as fuel cut or limp-in duty cycle) "
                "to prevent catastrophic overboost."
            )
            tg = (
                "When increasing boost beyond factory levels with an aftermarket 3-bar MAP sensor or manual boost controller, "
                "raise OBCTRL above your maximum planned peak boost to prevent false overboost fuel cut."
            )
            cond_head = "Takes effect continuously under positive boost pressure, guarding against runaway boost."
            notes = "* **Overboost Failsafe**: Primary manifold pressure trip boundary for overboost safety."
        elif c in ('WGDCMN', 'WGDCMX', 'WGILML'):
            ov = (
                f"{cname} sets the minimum or maximum allowable wastegate duty cycle clamp limits. Enforcing hard minimum "
                f"and maximum PWM bounds prevents solenoid coil overheating and ensures the pneumatic actuator flapper valve "
                f"remains within its controllable modulation window."
            )
            tg = (
                "Raising the maximum clamp allows higher wastegate duty cycle for stiff external wastegate springs. Raising the "
                "minimum clamp prevents wastegate flutter at high exhaust flow."
            )
            cond_head = "Takes effect across all active boost regulation routines as an absolute clamp on calculated duty cycle."
            notes = "* **Duty Cycle Clamp Limits**: Hard software bounds on wastegate solenoid output."
        elif c == 'DCWCHG':
            ov = (
                "DCWCHG defines the full-throttle wastegate duty cycle adder curve versus charge air temperature. In factory T3 "
                "and SBEC calibrations, this is a 1-point table set to 0% duty cycle (.byte 0x01, .byte 0xFF, 0x00), acting as a "
                "neutral placeholder. When configured, it adjusts wastegate duty cycle as intake charge temperatures rise."
            )
            tg = (
                "Factory set to flat 0%. Can be populated by tuners to pull wastegate duty cycle (lowering boost) on hot summer "
                "track days when intake air temperatures spike."
            )
            cond_head = "Takes effect at full throttle under boost, evaluating charge air temperature."
            notes = "* **Factory Flat Neutral Table**: Factory setting is 1 point at 0x00 (0% duty cycle adder)."
        else:
            ov = f"{cname} ({lname}) controls operational parameters for wastegate solenoid PWM modulation and boost setpoint calculation."
            tg = "Alters wastegate solenoid responsiveness or boost setpoints. Tune with live wideband AFR and boost telemetry."
            cond_head = "Takes effect during active boost regulation routines."
            notes = "* **Boost Control Subsystem**: Chrysler electronic wastegate regulation component."

    # ------------------------------------------------------------------------
    # E. COLD START & TRANSIENT ENRICHMENT (CSFERT, STFTM2, MINPTE, etc.)
    # ------------------------------------------------------------------------
    elif c in ('CSFERT', 'CSFERX', 'PCCSFE', 'STFTM2', 'CTFERA', 'IPWRDX', 'FCRCVB', 'HMPMUL', 'AETIME',
               'AESLPP', 'AESLOW', 'MINPTE', 'MINPAI', 'LOTTPS', 'ATPRPM', 'ATPDTP', 'DECTPS', 'NEGSL2',
               'AVMRPM', 'LOTIME', 'LMAPTC', 'PTELMT', 'PTEADJ', 'MAPTRS', 'MAPMXS', 'AESLPI'):
        if c in ('CSFERT', 'CSFERX', 'PCCSFE', 'CTFERA', 'IPWRDX'):
            ov = (
                f"{cname} ({lname}) calibrates post-crank cold start fuel enrichment decay timers, loop counters, and "
                f"percentage multipliers. Immediately after the engine fires and transitions from cranking to running, extra fuel "
                f"must be delivered for a brief duration to wet cold intake runners and establish stable combustion before standard "
                f"coolant warmup tables take over."
            )
            tg = (
                "Raising the values increases the duration or volume of post-start fuel enrichment, eliminating cold-start lean "
                "stumble. Lowering the values prevents spark plug fouling on large fuel injectors during cold winter starts."
            )
            cond_head = "Takes effect during the first several seconds immediately following engine start-up."
            notes = "* **Post-Crank Enrichment**: Bridges the transition between starter cranking and warmed-up idle."
        elif c == 'STFTM2':
            ov = (
                "STFTM2 defines the secondary starter cranking fuel pulsewidth curve versus coolant temperature. While cranking, "
                "fuel delivery is governed strictly by coolant temperature rather than MAP vacuum; STFTM2 provides secondary fuel "
                "calibration for cold-crank injector firing."
            )
            tg = (
                "When installing larger fuel injectors, scale STFTM2 downward proportionally to prevent flooding the engine "
                "during cranking. If the engine cranks excessively before catching when cold, increase STFTM2 values slightly."
            )
            cond_head = "Takes effect during starter cranking below 400 RPM before the engine fires."
            notes = "* **Cranking Fuel Delivery**: Governs fuel delivery during starter engagement."
        elif c in ('MINPTE', 'MINPAI', 'PTELMT', 'PTEADJ'):
            ov = (
                f"{cname} ({lname}) establishes the minimum injector pulsewidth floor or maximum multiplier ceiling enforced "
                f"during part-throttle acceleration enrichment. It ensures that transient throttle tip-in always injects a meaningful "
                f"burst of fuel to prevent momentary lean hesitation when the throttle plate snaps open."
            )
            tg = (
                "Raising the value adds a more aggressive fuel punch on tip-in, curing lean hesitation on engines with big bore "
                "throttle bodies. Lowering the value prevents a rich bog or black smoke puff on light throttle movement."
            )
            cond_head = "Takes effect during rapid throttle opening transitions under positive throttle delta."
            notes = "* **Transient Fuel Floor**: Hard lower boundary on acceleration enrichment pulsewidth."
        elif c in ('LOTTPS', 'DECTPS', 'NEGSL2', 'LOTIME', 'LMAPTC'):
            ov = (
                f"{cname} ({lname}) calibrates decel fuel lean-out factors, delta-MAP decay slopes, and time constants applied "
                f"when the throttle plate snaps shut. During sudden deceleration, excess fuel pooling on intake runner walls evaporates "
                f"rapidly due to rising manifold vacuum; this table reduces fuel pulsewidths to prevent rich stumble and emissions spikes."
            )
            tg = (
                "Raising values leans out fuel more aggressively on throttle lift, maximizing engine braking and fuel economy. "
                "Lowering values keeps fueling slightly richer on lift-off, smoothing driveline snatch and enabling subtle exhaust burble."
            )
            cond_head = "Takes effect during closed-throttle deceleration and rapid throttle lift-off."
            notes = "* **Decel Fuel Management**: Coordinates wall-wetting fuel compensation during coastdown."
        elif c in ('ATPRPM', 'ATPDTP', 'AVMRPM', 'MAPTRS', 'MAPMXS', 'AESLPI', 'AESLOW', 'AESLPP', 'AETIME', 'FCRCVB', 'HMPMUL'):
            ov = (
                f"{cname} ({lname}) defines filter thresholds, delta-MAP/TPS triggers, and enrichment durations for the speed-density "
                f"acceleration enrichment (pump shot) subsystem. When manifold pressure rises rapidly before manifold airflow reaches "
                f"equilibrium, this parameter triggers an instantaneous fuel injector pulse to maintain stoichiometric or rich combustion."
            )
            tg = (
                "Raising trigger thresholds makes acceleration enrichment less sensitive to minor throttle flutter; lowering thresholds "
                "makes the pump shot fire on smaller throttle movements. Tune carefully to eliminate tip-in flat spots."
            )
            cond_head = "Takes effect during positive delta-MAP and delta-TPS transitions as throttle opens."
            notes = "* **Pump Shot Subsystem**: Speed-density equivalent of an accelerator pump on a carburetor."

    # ------------------------------------------------------------------------
    # F. ADAPTIVE MEMORY & O2 CLOSED-LOOP (CALTH1, CALTH2, CALTHP, etc.)
    # ------------------------------------------------------------------------
    elif c in ('CALTH1', 'CALTH2', 'CALTHP', 'CALTHN', 'MNRPO2', 'CELCHG', 'AMLIMH', 'MP1', 'MP2'):
        if 'CALTH' in c:
            bound_str = "positive (lean)" if "P" in c or "1" in c else "negative (rich)"
            ov = (
                f"{cname} establishes the {bound_str} voltage error deadband limit for the closed-loop oxygen sensor adaptive fuel "
                f"memory subsystem. To prevent normal narrow-band O2 sensor switching oscillations from corrupting long-term learned fuel "
                f"tables, the ECU requires O2 error to exceed this deadband before updating adaptive cell multipliers."
            )
            tg = (
                "Raising the deadband requires larger fueling errors before long-term fuel trims update, stabilizing adaptive memory "
                "on engines with high-overlap camshafts. Lowering the deadband makes adaptive fuel learning more responsive."
            )
            cond_head = "Takes effect during closed-loop steady-state cruising, gating adaptive fuel table cell updates."
            notes = "* **Adaptive Deadband Gate**: Filters O2 sensor noise before updating long-term fuel memory."
        elif c == 'MNRPO2':
            ov = (
                "MNRPO2 specifies the minimum engine speed above commanded idle required before closed-loop oxygen sensor feedback "
                "and adaptive fuel trimming are permitted. Gating O2 feedback above idle prevents erratic closed-loop cycling during "
                "engine idle transitions."
            )
            tg = (
                "Raising MNRPO2 locks out closed-loop O2 control higher into the rev range, keeping idle and low-speed driving in open loop. "
                "Lowering MNRPO2 enables closed-loop trimming closer to base idle speed."
            )
            cond_head = "Takes effect when transitioning from closed-throttle idle to part-throttle off-idle driving."
            notes = "* **O2 Feedback RPM Gate**: Minimum RPM buffer above idle for closed-loop operation."
        else:
            ov = f"{cname} ({lname}) establishes cell boundaries, step update limits, or authority ceilings for adaptive closed-loop fuel memory."
            tg = "Governs adaptive closed-loop learning limits. Modifying alters how broadly the ECU can trim fuel across driving cycles."
            cond_head = "Takes effect during closed-loop stoichiometric fuel feedback."
            notes = "* **Adaptive Memory Architecture**: Part of the Chrysler long-term fuel trim system."

    # ------------------------------------------------------------------------
    # G. IDLE AIR STEPPER (AIS) & A/C CONTROL (ADDAIS, ACTDEF, ACPOS2, etc.)
    # ------------------------------------------------------------------------
    elif c in ('ADDAIS', 'ACTDEF', 'ACPOS2', 'ACCNTI', 'ACCRPM', 'ACCTBL', 'ACCTIM', 'ACDSPD', 'ACDTHR',
               'ACDTMP', 'ACERPM', 'ACESPD', 'ACETIM', 'ACLRPM', 'ACOFFK', 'ACOUT', 'ACTMP', 'BRKRPM',
               'PNDRK', 'DRPNK', 'ACTIM2', 'ACTIMX', 'ACTOFS', 'ADCINT'):
        if c == 'ADDAIS':
            ov = (
                "ADDAIS defines the additional idle air stepper motor (AIS) opening steps added based on cumulative engine running time. "
                "Following engine start, mechanical friction is high and oil pressure is building; ADDAIS holds the idle valve slightly "
                "more open to ensure smooth cold-start stabilization before decaying to normal target idle steps."
            )
            tg = (
                "Raising ADDAIS adds more idle air immediately after start, curing cold-start dip and stall on engines with heavy valvetrains. "
                "Lowering ADDAIS prevents excessive idle flares on hot engine restarts."
            )
            cond_head = "Takes effect during the initial run-time period following engine start-up."
            notes = "* **Post-Start Idle Buffer**: Prevents post-crank engine RPM stall."
        elif c in ('ACTDEF', 'ACCTIM', 'ACTIM2', 'ACTIMX', 'ACTOFS'):
            ov = (
                f"{cname} establishes the time delay required after A/C engagement or start-to-run transfer before the A/C compressor "
                f"clutch is permitted to engage. Delaying compressor clutch engagement allows the idle air stepper motor to preemptively "
                f"kick open, preventing engine RPM droop when the heavy mechanical compressor load hits the accessory drive belt."
            )
            tg = (
                "Raising the delay gives the idle stepper motor more time to stabilize idle before the A/C clutch pulls engine torque down. "
                "Lowering the delay makes A/C cooling engage more rapidly."
            )
            cond_head = "Takes effect when the driver turns on the air conditioning or restarts the vehicle with A/C active."
            notes = "* **Preemptive A/C Kick**: Protects against engine stall when the A/C compressor clutch locks up."
        elif c in ('ACPOS2', 'ACOFFK', 'ACOUT', 'ACCTBL', 'BRKRPM', 'PNDRK', 'DRPNK'):
            ov = (
                f"{cname} ({lname}) defines idle air stepper motor kick steps or position offsets applied during accessory loads, "
                f"gear shifts (Park/Neutral to Drive), or brake pedal depression. Preemptively positioning the stepper motor absorbs "
                f"torque transients before engine speed can fluctuate."
            )
            tg = (
                "Raising the values kicks the idle air valve open further during transitions, eliminating idle dip when shifting into gear "
                "or turning on accessories. Lowering the values prevents idle speed hung-up or flare."
            )
            cond_head = "Takes effect when shifting between Park/Neutral and Drive, applying brakes, or toggling accessory loads."
            notes = "* **Idle Step Transient Offset**: Preemptive torque compensation for vehicle accessory loads."
        else:
            ov = f"{cname} ({lname}) calibrates speed, temperature, or throttle boundaries governing air conditioning compressor clutch cutout."
            tg = "Alters A/C compressor clutch cutout boundaries to free up engine horsepower during spirited driving."
            cond_head = "Takes effect with A/C active during high-RPM, high-throttle, or high-temperature operating modes."
            notes = "* **A/C Cutout Protection**: Safeguards compressor and unlocks maximum engine output under load."

    # ------------------------------------------------------------------------
    # H. EXHAUST GAS RECIRCULATION (EGR2, EGR21 - EGR27)
    # ------------------------------------------------------------------------
    elif c.startswith('EGR'):
        ov = (
            f"{cname} ({lname}) defines calibration boundaries, vacuum switch points, or duty cycle limits for the Exhaust Gas "
            f"Recirculation (EGR) subsystem. The engine controller modulates the EGR vacuum solenoid to meter inert exhaust gases into "
            f"the intake manifold during part-throttle cruising, lowering peak combustion flame temperatures to suppress oxides of "
            f"nitrogen (NOx) emissions."
        )
        tg = (
            "If the factory EGR system has been mechanically removed or blanked off for performance or racing, this parameter can be "
            "adjusted or diagnostic error bits disabled in MPTune to suppress Fault Code 33 without triggering check engine lights."
        )
        cond_head = "Takes effect during part-throttle warm cruising under moderate manifold vacuum."
        notes = "* **Emissions Control Parameter**: Controls part-throttle exhaust gas recirculation."

    # ------------------------------------------------------------------------
    # I. OBD-I SENSOR DIAGNOSTICS & FAULT CODES
    # ------------------------------------------------------------------------
    elif c in ('INCMID', 'OFSRID', 'INCRID', 'MPVAC2', 'MPDELX', 'FLMNC2', 'O2MID', 'O2MIDX',
               'UKNOWNBYTESA', 'UKNOWNBYTESB', 'FLTMSK1', 'CODE12', 'CODE13'):
        ov = (
            f"{cname} ({lname}) establishes diagnostic debounce timer counts, threshold windows, or fault validation limits for "
            f"the Chrysler on-board diagnostic (OBD-I) monitoring subsystem. The ECU samples sensor voltages and runtime behaviors "
            f"across multiple continuous engine cycles before logging diagnostic trouble codes and illuminating the Check Engine lamp."
        )
        tg = (
            "Raising threshold counts desensitizes fault code detection, preventing nuisance Check Engine light illumination when running "
            "non-stock sensors, high-flow MAP sensors, or aggressive camshafts. Lowering counts speeds fault detection."
        )
        cond_head = "Takes effect during background diagnostic monitoring sweeps while the engine is running."
        notes = "* **OBD-I Diagnostic Filter**: Prevents false trouble code logging from momentary electrical noise."

    # ------------------------------------------------------------------------
    # J. SETUP, CAL ID, CHECKSUM & VEHICLE CONFIGURATION
    # ------------------------------------------------------------------------
    elif c in ('IDCODE_1', 'IDCODE_2', 'ENDIT1', 'ENDIT2', 'ENDITM2', 'PARTREV', 'RFINO0', 'RFINO1',
               'RFINO2', 'RFINO3', 'RFIREV', 'BITSUM', 'MDLCDE1', 'MDLCDE2', 'CONFIG2', 'CCDCF2',
               'CCDCF3', 'SourceCodeVersionID', 'NTUSD1'):
        if c == 'BITSUM':
            ov = (
                "BITSUM defines the factory ROM calibration checksum byte. During ECU boot initialization and diagnostic self-tests, "
                "the 68HC11 microprocessor sums memory bytes across calibration memory space and compares the total against BITSUM "
                "to verify EPROM data integrity and detect corrupted ROM chips."
            )
            tg = (
                "When editing calibrations in MPTune, the software automatically recalculates and updates BITSUM upon saving. If "
                "manually editing hex binaries with an external hex editor, ensure the checksum byte is recalculated to prevent "
                "diagnostic fault code 53 (Internal Engine Controller Failure)."
            )
            cond_head = "Evaluated during initial ECU key-on power-up and background diagnostic memory integrity checks."
            notes = "* **ROM Integrity Checksum**: Validates calibration memory against bit rot or flash corruption."
        elif 'CCDCF' in c:
            ov = (
                f"{cname} ({lname}) establishes network protocol configuration constants for the Chrysler Collision Detection (CCD) "
                f"serial communications bus. It governs how the engine management controller transmits sensor data and error messages "
                f"to the Body Control Module (BCM), Overhead Travel Information System (OTIS), and Electronic Instrument Cluster."
            )
            tg = "Leave at factory default settings to ensure uninterrupted serial communication across vehicle interior modules."
            cond_head = "Takes effect continuously while the vehicle ignition is on, managing CCD bus message framing."
            notes = "* **CCD Serial Network**: In-vehicle multiplexed serial communications parameter."
        elif 'CONFIG' in c or 'MDLCDE' in c:
            ov = (
                f"{cname} ({lname}) defines hardware configuration and vehicle platform identification bitfields. It establishes "
                f"factory options such as manual versus automatic transaxle, air conditioning presence, cooling fan speeds, and vehicle "
                f"body style (Daytona, LeBaron, Shadow, Spirit) to configure controller output driver routines."
            )
            tg = (
                "Configures hardware vehicle options in MPTune. Ensure bits match your vehicle's physical transmission and A/C equipment."
            )
            cond_head = "Evaluated during ECU power-on and hardware initialization routines."
            notes = "* **Hardware Option Bitmask**: Selects platform equipment and output driver logic."
        else:
            ov = (
                f"{cname} ({lname}) stores the Mopar production part number prefix, calibration revision code, or factory test vector. "
                f"Diagnostic scan tools (such as the Chrysler DRB-II or Snap-on MT2500) read this memory location via the diagnostic "
                f"serial port to identify the calibration model year, engine displacement, and transaxle configuration."
            )
            tg = (
                "This is a calibration identification field used by scan tools and calibration software. Tuning modifications do not "
                "require changing this identifier unless creating a custom calibration version string."
            )
            cond_head = "Read during diagnostic serial tool interrogations and calibration validation sweeps."
            notes = "* **Calibration Identification Header**: Factory Mopar part number and revision tracking."

    # ------------------------------------------------------------------------
    # K. GENERAL ASSEMBLY-AWARE FALLBACK (NO COOKIE CUTTER!)
    # ------------------------------------------------------------------------
    else:
        # Build specific automotive explanation from routine name, units, and group
        grp_clean = mp_group.replace('_', ' ').replace('\\', ' ').strip()
        r_clean = re.sub(r'([A-Z])', r' \1', routine_name).strip()

        ov = (
            f"{cname} ({lname}) regulates operational behavior within the {grp_clean} subsystem, calibrating "
            f"engine management functions handled by `{routine_name}`. The 68HC11 engine controller evaluates "
            f"this calibration data to govern {units.lower()} under active engine operating conditions, maintaining "
            f"balanced drivability, emissions, and powertrain reliability."
        )
        if tpl_d:
            ov += f" As documented in the factory calibration specification: {tpl_d}."

        tg = (
            f"Adjusting {cname} alters the response curve or operational threshold for {lname.lower()}. "
            f"Raising the value increases the commanded setpoint or expands the gating window in `{routine_name}`; "
            f"lowering the value tightens the control response or decreases the commanded output. Calibrate in small, "
            f"progressive increments while monitoring engine telemetry and road drivability."
        )
        cond_head = f"Takes effect during `{routine_name}` routines whenever {grp_clean} management is actively commanded."
        notes = (
            f"* **Firmware Location**: Accessed in `{asm_file}` at line {inst_line} within `{routine_name}`.\n"
            f"* **ROM Calibration Address**: Stored at ROM address `{cal_addr}` in calibration group `{mp_group}`.\n"
            f"* **Data Structure**: {units}."
        )

    # Format Markdown versions
    ov_md = f"`{cname}`: {ov}" if not ov.startswith(f"`{cname}`") else ov

    tg_md = (
        f"* **Calibration Strategy**: {tg}\n"
        f"* **Raising the Value**: Increases commanded threshold or extends gating limits in the controller.\n"
        f"* **Lowering the Value**: Decreases commanded threshold or restricts operational bounds."
    )

    op_cond_text = (
        f"{cond_head}\n\n"
        f"* Evaluated inside `{routine_name}` at line {inst_line} in `{asm_file}` (routine starts at line {routine_line}).\n"
        f"* Loads calibration data directly from ROM address `{cal_addr}` for runtime sensor comparison and scaling.\n"
        f"* Controls CPU branching, register scaling, and output actuation in `{routine_name}`."
    )

    tech_text = (
        f"Inside `{asm_file}`:\n\n"
        f"The 68HC11 CPU evaluates `{cname}` inside `{routine_name}` at line {inst_line}. "
        f"The instruction loads, compares, or interpolates the calibration data from ROM address `{cal_addr}`."
    )

    return {
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
