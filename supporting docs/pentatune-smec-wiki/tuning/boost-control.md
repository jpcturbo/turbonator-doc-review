# Boost Control

## Overview

The ECU controls boost pressure by modulating the wastegate solenoid duty cycle, varying how much exhaust bypasses the turbine. Turbonator adds a switchable boost target system and two independent WG control algorithms (T1 and T2).

---

## Boost Target Selection

### Six Independent Limit Tables

The target boost is the **minimum** of six independent table lookups. Each lookup uses `LookupAndKeepSmallerBoostGoal`, which only replaces the running minimum if the new lookup result is smaller. This architecture means any single table can limit boost without knowledge of the others.

| Table | Index | Notes |
|-------|-------|-------|
| `WSGRPM_AllowedBoost_FromRpm` | Engine RPM | Primary boost curve |
| `WSGTIM_AllowedBoost_FromTime` | `Timer_BoostTimer` | Ramp-in timer; prevents instant full boost |
| `WSGCLT_AllowedBoost_FromTemp` | Coolant temp | Limits boost when engine is cold |
| `WSGCHG_AllowedBoost_FromChargeTemp` | Charge air temp | Limits boost with hot intake air |
| `MXSBST_AllowedBoost_FromSpeed` | Vehicle speed | Speed-based boost limit |
| `WSGPRT_AllowedBoostPartThrottle_FromThrottle` | TPS (above MINTHR) | Skipped at WOT; limits boost at cruise |

All six are evaluated every main loop. The minimum result is stored in `Temp4`.

### Additional Limiters (Turbonator)

After the six standard tables, two Turbonator-specific limits are also applied:

| Limiter | Condition | Constant |
|---------|-----------|----------|
| Staging boost limit | When `Turbonator_Staging` flag is set | `STGBST_AllowedBoostDuringStaging` |
| Switchable "Lo" boost | When `opt_SwBoost` enabled and switch is in Lo position | `LOWBST_AllowedBoostLo` |

The boost switch polarity is controlled by `opt_SwBstPol`. With Lo selected, `LOWBST` is applied as a final minimum.

### Final Boost Target

```
BoostTarget = min(all lookups) + BaroPressure
```

`BoostTarget` is an **absolute MAP value**, not a gauge pressure. Adding `BaroPressure` converts the relative boost goal into an absolute MAP target that can be compared directly against `MapValue`.

---

## Wastegate Duty Cycle Control

Two independent WG control algorithms are available. The active algorithm is selected by the `opt_T2BC` bit in `OPTN2`:

- **T1 control**: `opt_T2BC` = 0 (default on T1 hardware)
- **T2 control**: `opt_T2BC` = 1

### T1 Wastegate Control

T1 is the original Turbonator WG control algorithm, adapted from the stock T1 firmware.

**Calculation sequence:**

1. Check if MAP is above the `MAPPT2_WastegateDutyCycleMapSwitchPoint2` + baro threshold. If below, duty cycle is cleared (WG fully open, no boost building).
2. Increment `Timer_BoostTimer` if RPM ≥ `RPMBST_MinimumRpmToTrackBoostCreep` (prevents boost timer from running at low RPM).
3. Look up base DC from `DCWOT_FullThrottleWastegateDutyCycle_C8is100Percent_FromMap` (MAP-indexed).
4. Adjust base DC by RPM via `DCWADJ_FullThrottleWastegateDutyCycleAdjustment_FromRpm`.
5. Adjust DC by delta between boost target and current MAP via `DCWBST_FullThrottleWastegateDutyCycleAdjustment_FromBoostTarget`.
6. Apply adaptive WG cell correction (see below).
7. Subtract `WastegateDutyCycleIncreaseFromKnock` — knocking reduces final DC (see Knock Interaction).
8. Clamp result to 0–0xC8 (0–100%).

**Knock interaction (T1):**
When knock is detected in boost (`b55_BoostOver5psi`), `WastegateDutyCycleIncreaseFromKnock` is incremented by `KDCINC` (step of 0x08). This value is then **subtracted** from the WG duty cycle, reducing solenoid DC, which opens the wastegate more — reducing boost to relieve knock. The value decays back to zero when boost drops below the 5 PSI threshold.

### T2 Wastegate Control

T2 adds boost creep prevention through rate-of-change monitoring.

**Key differences from T1:**

1. **Rate limiting**: T2 tracks `BoostDelta_Signed` (the difference between current and previous boost-over-baro readings). If boost is rising faster than `T2RATLIM_OverboostPreventionRateLimit_FromRpm` allows, the WG is immediately set to `T2PRTMAX` (max DC) to clamp the creep.

2. **Correction polarity**: T2 negates the `T2DCWBST` lookup result before applying it, making the boost-delta correction work in the opposite direction from T1. This reflects the inverted WG plumbing convention on T2 hardware.

3. **Response factor**: `T2RESFAC_MapCorrectionResponseFactor_FromMap` provides a MAP-indexed gain for the correction calculation, allowing different response rates at different boost levels.

4. **Separate constants**: T2 uses `T2KDCINC`, `T2KDCMAX`, `T2KDCMIN` for knock-based DC modulation.

**Boost creep prevention flow:**
```
Every 32nd main loop at RPM ≥ T2RPMBST:
  BoostDelta = current (MAP-baro) - previous (MAP-baro)
  If delta positive (boost rising):
    Compare rate against T2RATLIM[RPM]
    If rising too fast → set WG DC to T2PRTMAX → return
  If delta negative or within rate limit:
    Continue to normal DC calculation
```

### T1 vs T2 Comparison

| Feature | T1 | T2 |
|---------|----|----|
| WG plumbing polarity | Standard (T1 style) | Inverted (T2 style) |
| Boost creep prevention | None | Rate-of-change limit |
| WG multiplier table | `DCWBST` (positive) | `T2DCWBST` (negated) |
| Knock DC step | `KDCINC` (0x08) | `T2KDCINC` (0x04) |
| Boost tracking RPM threshold | `RPMBST` | `T2RPMBST` |
| Boost timer driven by | `CalcWGDutyCycleT1` | `CalcWGDutyCycleT2` |

---

## Adaptive Wastegate Control (T1)

T1 control includes a 5-cell adaptive wastegate grid (see [Adaptive Systems](adaptive-systems.md#adaptive-wastegate-control) for cell structure and update conditions). The cells provide a ±correction to the base DC from the `DCWOT` table, learning the correct duty cycle over time.

T2 does not include the same adaptive cell system — its rate-limiting approach achieves consistency through a different mechanism.

---

## Overboost Protection

### Fuel Shutoff Thresholds

Code 45 (overboost) has two independent fuel cutoff mechanisms:

| Mechanism | Constant | Behavior |
|-----------|----------|---------|
| Immediate threshold | `MPSHFA_OverboostFuelShutoffMapValue` | Cuts fuel immediately when MAP exceeds this |
| Timer threshold | `MPSHFT` + `TRNTM_OverboostFuelShutoffDelay` | Cuts fuel when MAP exceeds a lower threshold for longer than TRNTM loops |

The timer default is 0xFF (disabled in Turbonator by default). The immediate threshold should always be set.

### Disabling Overboost Protection

Set all four overboost constants to 0xFF to disable. Only appropriate after installing a physical boost gauge and verifying WG operation. **Do not disable on a running vehicle without a gauge.**

---

## Boost Timer System

`Timer_BoostTimer` prevents boost from building instantly on a short WOT event:
- Timer increments while RPM is above `RPMBST` threshold
- `WSGTIM_AllowedBoost_FromTime` table is indexed by this timer
- Timer decrements when MAP is below the switch point threshold (every 32 main loops)
- Creates a "spool-up" effect even for calibrations with aggressive WOT boost targets

---

## Common Boost Problems

### Boost Spike

**Symptom:** Boost overshoots target momentarily

**Causes:** Wastegate actuator too stiff, solenoid duty too aggressive, small fast-spooling turbo

**Solutions:** Softer wastegate spring, adjust DCWOT table, add boost spike timing retard

### Boost Creep

**Symptom:** Boost continues rising past target at high RPM

**Causes:** Wastegate too small for exhaust flow, internal WG limitation

**Solutions:** Larger wastegate, external wastegate, use T2 mode with `T2RATLIM` tuned to match your turbo's creep behavior

### Slow Boost Response

**Symptom:** Boost builds slowly when throttle opened

**Causes:** Large turbo lag (expected), exhaust leak before turbo, boost leak

**Solutions:** Fix leaks, verify solenoid operation, reduce `WSGTIM` ramp rate

---

## Tuning Checklist

1. Verify wastegate actuator function manually
2. Set conservative boost target (stock level) in `WSGRPM` table
3. Verify solenoid operation (DRB ATM sub-command 0x11)
4. Test solenoid duty cycle is reaching expected values at WOT
5. Verify adaptive WG cells are converging (not oscillating)
6. Check for boost creep at high RPM — if present, use T2 mode or tune `DCWADJ`
7. Increase boost target in 2–3 PSI increments, datalogging knock each step

---

## WGDC Algorithm Internals

The complete T1 WGDC calculation is owned by `CalcWGDutyCycleT1`, which calls `WGDC_AdjustWGDutyCycle` as the shared signed saturating helper used to apply bounded duty-cycle adjustments.

### Base WGDC Lookup Chain

The final duty cycle is built from three sequential table lookups:

| Component | Table | Index | Description |
|-----------|-------|-------|-------------|
| Base | `DCWOT_FullThrottleWastegateDutyCycle_C8is100Percent_FromMap` | MAP | Base duty cycle at WOT |
| Adjustment 1 | `DCWADJ_FullThrottleWastegateDutyCycleAdjustment_FromRpm` | RPM | RPM-based offset |
| Adjustment 2 | `DCWBST_FullThrottleWastegateDutyCycleAdjustment_FromBoostTarget` | Boost target delta | Correction based on how far actual boost is from target |

The calculation follows this sequence:

```
BaseDC = DCWOT[MAP]
DC += DCWADJ[RPM]
DC += DCWBST[BoostTarget - CurrentMAP]
DC -= WastegateDutyCycleIncreaseFromKnock
DC = clamp(DC, 0, 0xC8)
```

All values are in the same 0x00–0xC8 (0–100%) scale. The tables are additive — a positive `DCWADJ` entry increases WGDC (closes wastegate, more boost), while a positive `DCWBST` entry adds correction based on boost error.

### Knock Interaction

When knock is detected during boost (`b55_BoostOver5psi` set), the `WastegateDutyCycleIncreaseFromKnock` accumulator is managed:

| Constant | Value | Purpose |
|----------|-------|---------|
| `KDCINC` | 0x08 | Increment step per knock event |
| `KDCMAX` | 0x3C | Maximum accumulated value |
| `KDCMIN` | 0x10 | Minimum nonzero value |
| `DCDECK` | 0x02 | Decay step when spark still derated |

**Behavior:**
- On knock detection, the accumulator increments by `KDCINC` (8 counts ≈ 6.25%)
- The accumulator is **subtracted** from the final WGDC, reducing solenoid duty and opening the wastegate
- Value caps at `KDCMAX` (0x3C = 47%)
- When spark retard persists but no new knock occurs, the value decays by `DCDECK` (2 counts)
- The accumulator clears when boost drops below the 5 PSI threshold

### Adaptive Cells

T1 WGDC uses a 5-cell adaptive correction grid stored in EEPROM:

**Cell selection uses two RPM boundaries and a MAP switch point:**

| Cell | RPM Range | MAP Condition |
|------|-----------|---------------|
| 1 | Below `DCRPM1` | Below `MAPPT` |
| 2 | `DCRPM1` to `DCRPM2` | Below `MAPPT` |
| 3 | `DCRPM2` to `DCRPM3` | Below `MAPPT` |
| 4 | Above `DCRPM3` | Below `MAPPT` |
| 5 | (any RPM above threshold) | Above `MAPPT` |

**Key constants:**

| Constant | Purpose |
|----------|---------|
| `DCRPM1`, `DCRPM2`, `DCRPM3` | RPM cell boundaries |
| `MAPPT` | MAP switch point for cell 5 |
| `DCRPML` | RPM below which adaptive correction is disabled |
| `DCRPMH` | RPM above which adaptive correction is disabled |
| `DECLIM` | Lower limit for adaptive correction |
| `INCLIM` | Upper limit for adaptive correction |

**Update logic:**
- When boost is **above target**, the `b52_WGDC_BumpAdapt` flag is set and the adaptive cell is decremented (reducing WGDC, opening wastegate)
- When boost is **below target**, the flag is cleared and the adaptive cell is incremented (raising WGDC, closing wastegate)
- Cell values are clamped to `DECLIM` (lower) and `INCLIM` (upper)
- Corrections are only applied within the `DCRPML` to `DCRPMH` RPM window

### Boost Error Timer

The routine tracks how long boost has been above or below target via a timer system:

- `WGDC_ClearBoostErrTimer` — resets the timer when conditions change
- `WGDC_StoreBoostErrTimer` — saves the timer state

The timer prevents adaptive cells from updating on transient boost errors. Only sustained deviations (after the timer expires) trigger adaptive corrections. This hysteresis prevents the adaptive system from oscillating during normal boost fluctuations.

### ASM Routine Map

| Label | Line | Purpose |
|-------|------|---------|
| `WGDC_AdjustWGDutyCycle` | 9494 | Shared signed clamp helper |
| `WGDC_LookAtCylRetards` | — | Check knock retard values |
| `WGDC_Clear5psiBoostTimer` | — | Reset 5 PSI timer |
| `WGDC_Store5psiBoostTimer` | — | Save 5 PSI timer state |
| `WGDC_CalculateWGDutyCycleVars` | — | Main calculation sequence |
| `WGDC_LookupWGDutyCycleBase` | — | DCWOT + DCWADJ + DCWBST lookups |
| `WGDC_StoreWGDutyCycleFromKnock` | — | Apply knock correction |
| `WGDC_SelectAdaptiveWGCell` | — | Determine active adaptive cell |
| `WGDC_LoadAdaptiveWGCell` | — | Load cell correction value |
| `WGDC_BoostIsAboveTarget` | — | Decrement cell (boost too high) |
| `WGDC_BoostIsBelowTarget` | — | Increment cell (boost too low) |
| `WGDC_UpdateAdaptiveWGControlMemory` | 9648 | Store the updated T1 adaptive cell before recomputing final WGDC |
| `WGDC_ClearBoostErrTimer` | — | Reset boost error timer |
| `WGDC_StoreBoostErrTimer` | — | Save timer state |

---

## ASM Implementation

- `CalcTargetBoost_MM` — T-SMEC_v19.asm:9347
- `CalcWGDutyCycle_MM` — T-SMEC_v19.asm:9430
- `CalcWGDutyCycleT1` — T-SMEC_v19.asm:9436
- `WGDC_AdjustWGDutyCycle` — T-SMEC_v19.asm:9494
- `WGDC_UpdateAdaptiveWGControlMemory` — T-SMEC_v19.asm:9648
- `CalcWGDutyCycleT2` — T-SMEC_v19.asm:9679
- `InterruptVector_TimerOC2_Wastegate` — T-SMEC_v19.asm:9965
- `WG_SetOutput` — T-SMEC_v19.asm:9978
- `WG_ClearOutput` — T-SMEC_v19.asm:9984

Routines ending with `_MM` are called from the MainProgramLoop (see T-SMEC_v19.asm line 319).

### `CalcTargetBoost_MM`

`CalcTargetBoost_MM` skips its work when `ATMOffset` is `0x11` or `0x14`, then seeds `Temp4` from `WSGRPM_AllowedBoost_FromRpm` and walks the remaining limit sources in order at `_reference/T-SMEC_v19.asm:9351-9427`. The helper `LookupAndKeepSmallerBoostGoal` is the mechanism that turns those independent lookups into a running minimum.

The frozen source evaluates these inputs in sequence:

1. `WSGRPM_AllowedBoost_FromRpm` at line 9359, stored into `Temp4` at line 9362.
2. `WSGTIM_AllowedBoost_FromTime` at lines 9363-9365.
3. `WSGCLT_AllowedBoost_FromTemp` at lines 9366-9368.
4. `WSGCHG_AllowedBoost_FromChargeTemp` at lines 9369-9371.
5. `MXSBST_AllowedBoost_FromSpeed` at lines 9372-9377.
6. `WSGPRT_AllowedBoostPartThrottle_FromThrottle` at lines 9378-9384, but only when `b4f_FullThrottle` is clear.
7. `STGBST_AllowedBoostDuringStaging` at lines 9387-9391 when the `Turbonator_Staging` flag is set.
8. `LOWBST_AllowedBoostLo` at lines 9393-9419 when switchable boost is enabled and the selected switch polarity resolves to the low-boost path.

The routine finishes by adding `BaroPressure` to the selected relative boost goal and saturating the sum at `0xff` before storing `BoostTarget` at lines 9421-9426. That matches the page's earlier claim that the stored target is absolute MAP rather than gauge boost.

### `CalcWGDutyCycle_MM`

`CalcWGDutyCycle_MM` is only a dispatcher. At `_reference/T-SMEC_v19.asm:9430-9434` it reads `OPTN2_CalCustomOptionConfigFlags2`, tests `opt_T2BC`, and falls through to `CalcWGDutyCycleT1` when the bit is clear or jumps to `CalcWGDutyCycleT2` when the bit is set. The main loop therefore shares one entry point for both control strategies while keeping the T1 and T2 internals in separate routines.

### `CalcWGDutyCycleT1`

`CalcWGDutyCycleT1` wraps the T1-specific preconditions around the shared T1 calculation path at `_reference/T-SMEC_v19.asm:9436-9677`.

- Lines 9437-9440 exit early into `WGDC_ClearWGDutyCycleVars` when the engine is not running, otherwise they copy `BoostTarget` into `Temp3` for later delta-to-target work.
- Lines 9440-9475 walk `Cylinder2Retard` through `Cylinder4Retard`, gate the 5 PSI timer against coolant temperature and adaptive-retard timing, then either clear or store `Timer_Over5PsiBoostMaxFF`.
- Lines 9476-9479 compare `MapValue` against `BaroPressure + MAPPT2_WastegateDutyCycleMapSwitchPoint2`. If boost is still below that threshold the routine drops into the clear path instead of calculating duty cycle.
- Lines 9480-9492 clear `WastegateDutyCycleIncreaseFromKnock`, call `CallAndReturn1`, store zero WGDC, and every 32 loops bleed `Timer_BoostTimer` back down by one count when boost control is inactive.
- Lines 9509-9677 perform the real T1 base lookup, adaptive correction, and knock subtraction sequence already summarized in the earlier WGDC internals section.

This split matters because the function owns the enable and decay logic around the algorithm, not just the table chain itself.

### `WGDC_AdjustWGDutyCycle`

`WGDC_AdjustWGDutyCycle` is the signed saturating add helper used by both T1 and T2 base-lookup chains at `_reference/T-SMEC_v19.asm:9494-9507`. It treats the incoming `A` value as a signed adjustment, adds it to the running WGDC in `Temp4`, and clamps the result to `0x00-0xC8`.

- Lines 9495-9501 handle non-negative adjustments and clamp overflow or values above `0xC8` to `0xC8`.
- Lines 9503-9505 handle negative adjustments and clamp underflow to zero.
- Line 9506 writes the bounded result back to `Temp4`.

That narrow helper explains why both T1 and T2 can reuse the same clamp logic even though the T2 boost-error correction is negated before the call.

### `WGDC_UpdateAdaptiveWGControlMemory`

`WGDC_UpdateAdaptiveWGControlMemory` is the T1 adaptive-cell store at `_reference/T-SMEC_v19.asm:9648-9677`. The label itself is only the write at lines 9648-9649, but it falls straight into the timer clear/store and final WGDC assembly code, so the surrounding lines matter when describing what the update actually changes.

After incrementing or decrementing the selected cell in `B`, the routine:

1. Stores the new cell value through `X` at lines 9648-9649.
2. Clears or preserves `Timer_BoostErrTimer` through lines 9650-9653.
3. Converts the adaptive byte from its `0x80`-centered format into a signed offset at lines 9654-9668.
4. Applies that signed correction to the base WGDC from `Temp4`, still with a `0x00-0xC8` clamp.
5. Subtracts `WastegateDutyCycleIncreaseFromKnock` at lines 9669-9672.
6. Calls `CallAndReturn1` and stores `CurrentWastegateDutyCycle` at lines 9674-9676.

So the adaptive store is not a detached EEPROM update. In the frozen source it is the pivot from cell learning back into the final T1 output value for the current loop.

### `CalcWGDutyCycleT2`

`CalcWGDutyCycleT2` owns the T2 branch at `_reference/T-SMEC_v19.asm:9679-9963`. The page's earlier T2 overview is accurate, but the source shows a few concrete implementation details worth calling out.

- Lines 9680-9702 mirror the T1 entry guards: if the engine is not running, or if `MapValue - BaroPressure` is below `MAPPT2_WastegateDutyCycleMapSwitchPoint2`, the routine clears `CurrentWastegateDutyCycle`, `WastegateDutyCycleIncreaseFromKnock`, and `Timer_Over5PsiBoostMaxFF`, then slowly decrements `Timer_BoostTimer` every 32 loops.
- Lines 9704-9712 reset the knock timer whenever boost is below `T2KNOKMP_MinimumBoostToCountKnockEvents`, and line 9708 also clears that timer when the loop counter is zero.
- Lines 9713-9721 increment `Timer_BoostTimer` every 32 loops once RPM reaches `T2RPMBST_MinimumRpmToTrackBoostCreep`.
- Lines 9724-9729 compute `BoostOverBaro`, update `PreviousBoostOverBaro`, and store the signed rate term in `BoostDelta_Signed`.
- Lines 9736-9747 compare a rising boost rate against `T2RATLIM_OverboostPreventionRateLimit_FromRpm`. When the rise exceeds the allowed limit, the routine immediately loads `T2PRTMAX_MaxWastegateDutyCycleforPartThrottleBoostCreep`, stores it as `CurrentWastegateDutyCycle`, and returns.
- Lines 9749-9787 apply the T2 response-factor path. The code uses the absolute boost-rate magnitude, subtracts `T2MPDEL_HysteresisForBoostCreep`, multiplies that result by `T2RESFAC_MapCorrectionResponseFactor_FromMap`, bounds the learned correction between `UPRLIM` and `LWRLIM`, then shifts the temporary target before looking up `T2DCWOT`.
- Lines 9788-9810 run the T2 base chain. At WOT the routine adds `T2DCWADJ`, then looks up `T2DCWBST`, negates that result at line 9809, and feeds it through `WGDC_AdjustWGDutyCycle`.
- Lines 9813-9959 handle T2 knock accumulation, cylinder-retard decay, adaptive-cell selection, and adaptive-cell updates. Unlike T1, the final knock term is added back in at lines 9955-9958, which matches the inverted T2 output convention described earlier on the page.

### Output interrupt and helpers

`InterruptVector_TimerOC2_Wastegate` at `_reference/T-SMEC_v19.asm:9965-10003` is the hardware side of boost control. The main-loop routines only calculate `CurrentWastegateDutyCycle`. This OC2 interrupt turns that byte into an actual pulse train on the wastegate solenoid output.

- Lines 9966-9968 save the current PIA1 port-B direction state into `Temp5` before the pulse work begins.
- Lines 9969-9977 load a fixed `0x64` base period, inspect `CurrentWastegateDutyCycle`, and choose one of three paths: very low values branch straight to `WG_SetOutput`, very high values branch straight to `WG_ClearOutput`, and midrange values toggle between the two paths based on `b55_WastegateDC`.
- `WG_SetOutput` at lines 9978-9981 sets `b55_WastegateDC` and asserts `pia1b_WastegateSolenoid`.
- `WG_ClearOutput` at lines 9984-9986 clears the same state bit and drops the solenoid output.
- Lines 9987-10003 perform the shared tail work after either helper: pulse `pia1b_bit2`, delay 32 microseconds, divide the accumulated period by four, add it into `CPU_Timer_OC2_Wastegate`, optionally clear the solenoid again when battery voltage is above `0xA2`, clear the OC2 interrupt flag, restore the saved direction byte, and return with `rti`.

Because the interrupt owns the real pin toggling, the line references for `WG_SetOutput` and `WG_ClearOutput` are the most precise place to explain how the calculated WGDC byte becomes on-off solenoid drive.

## Source

- `T-SMEC_v19.asm` lines 9347-9984 (`CalcTargetBoost_MM` through `WG_ClearOutput`)

---

## See Also

- [Boost System Flow](../reference/boost-system-flow.md) — Complete boost control flow diagrams
- [Engine Protection](engine-protection.md) — Overboost fuel-cut and restore hysteresis that frame the boost-control limits
- [Sensor Processing and Derived State](../ecu-fundamentals/sensor-processing.md) — Baro, MAP, speed, and charge-temp state consumed by target and WGDC calculations
- [Launch Control](launch-control.md) — Staging boost limit (`STGBST`)
- [Adaptive Systems](adaptive-systems.md) — Adaptive WG cell structure and update conditions
- [Fault Codes](../reference/fault-codes.md) — Code 45 overboost details
- [Ignition Timing](ignition-timing.md) — Knock interaction with WG duty
