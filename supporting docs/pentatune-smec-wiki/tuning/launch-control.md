# Launch Control, Anti-Lag & Spark Cut

Turbonator-specific features for managing launch RPM, turbo spool, and cylinder-by-cylinder spark cut. These features are **not present in stock Chrysler firmware**.

## Overview

The Turbonator launch control system provides:
- **Staging limiter**: Hold RPM in a window using fuel and/or spark cut
- **Spark cut patterns**: Rotating per-cylinder cut for boost building without fuel cut
- **Anti-lag retard**: Apply timing retard during launch to keep exhaust energy high

All features are controlled by option flags in `OPTN1`/`OPTN2` calibration constants and require appropriate PentaTune/MPTune project support.

---

## Launch Control (Staging Limiter)

### Enable Conditions

All of the following must be true for launch control to activate:

1. **Option enabled**: `OPTN2 & opt_StageLim` bit set in calibration
2. **Switch (optional)**: If `STGSWS_StagingLimiterEnableSwitch` ≠ 0, the selected switch input must be active
3. **TPS above threshold**: `TpsVolts ≥ MINTHR + STGTPS_StageLimiterMinTPS` — prevents false triggers at idle
4. **Speed below limit**: `VehicleSpeed < STGSPD_StageLimiterCutoffSpeed` — disables at speed (typically ~80 km/h)

### RPM Window (Hysteresis)

| Event | Threshold | Variable |
|-------|-----------|----------|
| Staging flag activates | RPM ≥ `STGRON` | `Turbonator_Staging` flag set |
| Fuel/spark cut begins | RPM ≥ `STGROF` | `Turbonator_FuelOff` / `Turbonator_SparkCut` |
| Cut clears, staging stays active | RPM drops back to `STGRON` | Re-enables fuel/spark |

The two-threshold design (`STGRON` < `STGROF`) creates hysteresis: RPM oscillates between the two thresholds, holding the engine at the launch RPM window.

### Cut Strategy

Two independent cut methods can be enabled simultaneously:

| Flag | Calibration Option | Effect |
|------|--------------------|--------|
| `Turbonator_FuelOff` | `opt_FuelRevLim` | Cuts fuel injection |
| `Turbonator_SparkCut` | `opt_SprkRevLim` | Cuts spark via rotating pattern |

Spark cut is gentler on the drivetrain and allows turbo boost to build; fuel cut is harder but removes heat from the exhaust. Most setups use spark cut only for launch, fuel cut for rev limiting.

### Boost During Launch

When `Turbonator_Staging` is active, boost target is limited to `STGBST_AllowedBoostDuringStaging`. Set this to the desired launch boost pressure; the WG control will limit boost accordingly.

---

## Spark Cut Patterns

### Rotating Cut Mechanism

Spark cut uses a **rotating bit pattern** to distribute cuts evenly across cylinders. Each distributor pulse (one cylinder's ignition event), a counter decrements and the pattern rotates. The carry bit determines if this cylinder fires.

**Pattern table** (8 selectable ratios):

| Index | Ratio | Pattern | Base Counter | Effect |
|-------|-------|---------|--------------|--------|
| 0 | 1/3 cut | `0x60` | 3 | Fire 2 of every 3 cylinders |
| 1 | 2/3 cut | `0x20` | 3 | Fire 1 of every 3 cylinders |
| 2 | 3/5 cut | `0x28` | 5 | Fire 2 of every 5 cylinders |
| 3 | 4/5 cut | `0x40` | 5 | Fire 1 of every 5 cylinders |
| 4 | 3/7 cut | `0x36` | 7 | Fire 4 of every 7 cylinders |
| 5 | 4/7 cut | `0x2A` | 7 | Fire 3 of every 7 cylinders |
| 6 | 5/7 cut | `0x22` | 7 | Fire 2 of every 7 cylinders |
| 7 | 6/7 cut | `0x10` | 7 | Fire 1 of every 7 cylinders |

**How rotation works:**
```
Each cylinder event:
  ROL Pattern_SparkCut          ; rotate left through carry
  if carry set → allow spark    ; bit 7 was set = fire this cylinder
  if carry clear → cut spark    ; bit 7 was clear = no fire
  if counter == 0 → reload pattern and counter
```

### Tuning Notes

- **Lower cut ratio** (1/3 cut) = more cylinders fire = more exhaust energy = faster boost build, but RPM limiter is less aggressive
- **Higher cut ratio** (6/7 cut) = fewer cylinders fire = harder RPM cap, less exhaust energy for turbo
- For launch control on a 4-cylinder, 3/5 or 4/5 cut is a common starting point
- The pattern prevents multiple consecutive misfires on the same cylinder, reducing heat buildup

---

## Anti-Lag

### Purpose

Anti-lag applies a **timing retard** to firing cylinders during launch control. Retarded timing causes later, hotter combustion, keeping exhaust energy high to maintain turbo spool even when the engine is not producing full power.

### Enable Conditions

All must be true:
1. `opt_AntiLag` enabled in `OPTN2`
2. `Turbonator_Staging` flag set (launch control active)
3. `Turbonator_SparkCut` flag set (spark cut also active)
4. `EngineRpm ≥ ANLGRP_AntiLagRetardRPM` threshold

### Retard Amount

```
retard = ANTLAG_AntiLagRetardAbs >> 2    ; divide by 4
```

Range: 0 to 15° (from stored constant of 0–63°). Applied **only to firing cylinders** — cut cylinders receive no spark at all.

The retard is **subtracted** from the calculated spark advance before the coil fires. This is separate from knock retard (which is also subtracted); both can be active simultaneously.

### Interaction with Boost

Anti-lag does not directly control the wastegate; it works indirectly:
- Spark cut reduces combustion events → less torque → ECU's boost control sees boost below target → increases WG duty to let boost build
- Anti-lag retard keeps exhaust energy high during this process
- Together: boost builds quickly during launch even at a controlled RPM

---

## CEL Flash on Knock

When `opt_FlashCE` is enabled in `OPTN2`, the check engine light flashes whenever any cylinder has active knock retard:

```
For each cylinder (Cyl1Retard, Cyl2Retard, Cyl3Retard, Cyl4Retard):
  If retard > 0 → clear CEL bit → light ON
If all retards == 0 → set CEL bit → light OFF
```

This provides real-time knock indication without a dedicated knock light or data logger. The CEL flicker rate depends on how quickly retard values change.

Note: This overrides fault code display while active. Fault codes are still stored, but the CEL will indicate knock rather than stored faults.

---

## Wideband-to-Narrowband Conversion (WB2NB)

### Purpose

The ECU's O2 feedback system expects a narrowband (0–1V) O2 sensor signal. The WB2NB feature allows a wideband AFR controller to feed its signal into the O2 input, enabling closed-loop control with accurate AFR data.

### Enable

Set `opt_WB2NB` in `OPTN2` calibration flags.

### Conversion Process

```
1. Read RawAirFuelSensInput (ADC from wideband)
2. Lookup WB2AFR table → AFR value (e.g., 14.7, 12.5)
3. Lookup AFR2NB table → narrowband equivalent voltage
4. Add NBOFFS_NarrowbandOffsetConstant → final O2SensorValue
5. Store in O2SensorValue (used by normal O2 feedback code)
```

The `NBOFFS` constant allows fine-tuning the crossover point where the ECU sees the mixture as "stoichiometric."

### Tuning Notes

- Configure `WB2AFR` table to match your wideband controller's output scale
- Set `NBOFFS` to shift the "stoic" crossover if adaptive memory always runs rich/lean
- WB2NB uses the same closed-loop and adaptive memory system as a stock narrowband sensor

---

## Nitrous Oxide Timing Retard

### Purpose

Automatically retards ignition timing when nitrous oxide is active, protecting the engine from detonation under the increased cylinder pressure.

### Enable

Set `opt_NO2Retard` in `OPTN2`. Configure switch input via `NO2SWS` (optional; retard applies whenever the option is enabled if no switch is configured).

### Operation

```
If opt_NO2Retard:
  Read switch bit (with opt_NO2Pol polarity correction)
  If switch active:
    retard = NO2RET_NO2RetardConstant >> 3    ; divide by 8
    Apply to spark advance
  Else:
    retard = 0
```

Retard range: 0–15° (from 0–127° stored constant).

The retard is applied before the final spark advance is stored, combining with any knock retard already active.

---

## Decel Fuel Cut

### Purpose

Decel fuel cut completely disables fuel injection during deceleration, preventing unburnt fuel from entering the exhaust and improving engine braking. This feature was introduced in **Turbonator v19** as part of the launch control rewrite.

### Enable Conditions

Decel fuel cut activates when:

1. **Option enabled**: `opt_DecelFuelCut` set in `OPTN2` calibration flags
2. **Throttle closed**: TPS at or near idle position (below threshold)
3. **RPM above minimum**: Engine speed above the decel fuel cut threshold
4. **Not staging**: When the staging limiter is active, fuel is forced back on (WOT fuelling) to prevent fuel starvation during launch preparation

### Operation

When active, the ECU sets the fuel injector outputs to "off" regardless of calculated pulse width. This is a hard fuel cut — no fuel is injected until the enable conditions clear.

### Interaction with Staging

A critical interaction exists between decel fuel cut and launch control:

- If decel fuel cut is active **and** the driver hits the staging switch/throttle, fuel must immediately resume
- **v19.2 fix**: Corrected the logic so that staging forces WOT fuelling regardless of decel state
- TPS threshold (`STGTPS`) ensures the transition from decel to staging is smooth

### Version History

| Version | Date | Change |
|---------|------|--------|
| v19 | 01/04/13 | Initial decel fuel cut added |
| v19.2 | 01/07/13 | Fixed decel fuel cut logic that prevented it from running; added WOT fuelling override during staging |

---

## ASM Implementation

- `LaunchControl_MM` — T-SMEC_v19.asm:7471
- `CalculateSparkCutandAntiLagRetard_Routine` — T-SMEC_v19.asm:10132

Routines ending with `_MM` are called from the MainProgramLoop (see T-SMEC_v19.asm line 319).

---

## See Also

- [Boost Control](boost-control.md) — Boost target selection and wastegate control
- [Ignition Timing](ignition-timing.md) — Spark advance calculation, knock retard
- [Adaptive Systems](adaptive-systems.md) — O2 feedback, fuel learning
- [Boost System Flow](../reference/boost-system-flow.md) — Complete boost control diagrams

---

## Appendix: Turbonator Version History

The following table documents the evolution of launch control, anti-lag, and related features across Turbonator firmware versions:

| Version | Date | Launch Control Changes |
|---------|------|------------------------|
| v04 | 06/29/07 | Fixed staging mod switch reference |
| v07 | 08/09/07 | Added anti-lag code |
| v11 | 03/12/08 | Fixed anti-lag conditional branch bug; added polarity switch for staging limiter |
| v13 | 06/04/08 | Added polarity switch for staging limiter; added assembler option for wastegate control |
| v14 | 08/07/08 | Fixed disassembly error in spark scatter idle routine (rough/rich idle fix) |
| v14.5 | 10/02/08 | Moved staging limiter flag location to avoid overlap with cruise control |
| v15 | 02/18/09 | Added 2nd option flags for spark-based rev limiter |
| v15.1 | 02/27/09 | Fixed spark-based rev limiter code |
| v15.2 | 03/30/09 | Corrected jump target for staging limiter |
| v17.1 | 08/11/11 | Updated staging limiter to work when no switch is selected |
| v18 | 04/30/12 | Complete rewrite of anti-lag and staging limiter; anti-lag now uses single preset retard; staging limiter gains spark cut with rotating pattern |
| v19 | 01/04/13 | Complete rewrite of launch control as separate routine; added decel fuel cut |
| v19.1 | 01/06/13 | Fixed rotating spark cut counter |
| v19.2 | 01/07/13 | Fixed decel fuel cut; added WOT fuelling override during staging; added TPS threshold for staging |
| v19.4 | 07/10/14 | Added option to configure staging limiter as "bang-bang" type |
| v19.6 | 12/09/14 | Fixed main rev limiter broken by launch control; added 2nd flag |
