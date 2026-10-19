# Adaptive Systems

## Overview

Chrysler turbo ECUs include several adaptive systems that learn and adjust over time. These systems compensate for injector variability, sensor aging, fuel pressure drift, and long-term engine wear. Understanding how they work is essential for tuning, because they can mask or compensate for calibration issues if left enabled during base-tune development.

---

## O2 Sensor Feedback

### Signal Validation — Three Bands

The ECU does not simply read the O2 sensor as a binary rich/lean signal. It validates the signal through three ranges before enabling closed-loop feedback.

**Threshold constants:**

| Constant | Value | Meaning |
|----------|-------|---------|
| `O2HIGH` | 0x26 (38) | Above this → immediately valid (rich) |
| `O2LOW` | 0x0F (15) | Below this → immediately valid (lean) |
| `O2TLMH` | 0x1F (31) | Upper edge of delayed-entry band |
| `O2TLML` | 0x0F (15) | Lower edge of delayed-entry band |
| `O2MIDH` | 0x1C (28) | Upper edge of stuck-in-middle detection |
| `O2MIDL` | 0x12 (18) | Lower edge of stuck-in-middle detection |
| `O2HSWP` | 0x19 (25) | Rich/lean toggle threshold (above = rich) |
| `O2LSWP` | 0x18 (24) | Rich/lean toggle threshold (below = lean) |

**Validation flow:**

```
Read O2SensorValue
        │
        ▼
O2 > O2HIGH (0x26) or O2 < O2LOW (0x0F)?
        │
   ┌────┴────┐
   │YES      │NO
   ▼         ▼
Immediately   O2 in 0x0F–0x1F range?
valid         │
              ├─YES─► Start O2TIME (0x07) countdown
              │        If timer expires → valid
              │        Timer resets each main loop if not expired
              │
              └─NO──► O2 in 0x12–0x1C (middle band)
                       │
                       ▼
                  Increment stuck timer
                  If overflows → erase adaptive memory,
                                 clear O2Valid flag
                                 (leads to code 21)
```

Once `b4f_O2Valid` is set, the ECU enters closed-loop operation. The flag is cleared if the signal enters the middle band and the sensor appears stuck.

### Rich/Lean Toggle

When in closed-loop, the O2 signal is compared to toggle thresholds `O2HSWP` (0x19) and `O2LSWP` (0x18):
- Signal ≥ 0x19 → `b4f_O2Rich` set (mixture is rich → reduce fuel)
- Signal ≤ 0x18 → `b4f_O2Rich` clear (mixture is lean → add fuel)
- Signal between 0x18 and 0x19 → no state change (hysteresis prevents chatter)

### Inhibited Conditions

Closed-loop is blocked when any of the following is true:
- MAP ≤ `MAPDEC` (0x0D) — engine near vacuum (decel)
- Full throttle flag set
- `Timer_O2InhibitSwitchingRichIdleToClosedLoop` nonzero
- `Timer_OpenLoopFraction` nonzero
- Cold engine (CoolantTemp < `CLTEMP`, 0x92)
- `BOOSTP` threshold exceeded (defaults to 0xFF = disabled)

---

## Primary and Secondary Ramps

The ECU does not apply O2 feedback as a fixed step — it uses a ramp system to limit how aggressively the feedback counter moves.

### Counter Variables

| Variable | Address | Purpose |
|----------|---------|---------|
| `Counter_PrimaryAndSecondaryRamp` | 0x007D | Main O2 feedback accumulator, fed into fuel calculation |
| `Counter_PrimaryRamp` | 0x0093 | Holds the current ramp limit |
| `Timer_O2ToggleDuration` | 0x0094 | Tracks time since last O2 toggle, drives secondary ramp timeout |

### Primary Ramp

After each O2 toggle, the primary ramp routine (`WorkWithPrimaryRamp`) looks up a limit value from the `PRIRMP_PrimaryRamp` table using the current MAP/RPM cell. The counter `Counter_PrimaryAndSecondaryRamp` is incremented or decremented by this ramp step toward the calibrated limit. This prevents the fuel trim counter from slamming to extremes on every O2 toggle.

### Secondary Ramp

When the O2 signal has not toggled for a while, `WorkWithSecondaryRamp` runs instead. It compares `Timer_O2ToggleDuration` against the `SECRMP_SecondaryRamp` table limit for the current MAP/RPM cell. If the timer exceeds the limit, the ramp counter is updated to push the mixture toward the appropriate direction. This handles situations where the O2 is stuck on one side longer than expected.

### Limits

| Constant | Value | Meaning |
|----------|-------|---------|
| `O2LIMH` | 0x7F (+127) | Maximum ramp counter value (max fuel add) |
| `O2LIML` | 0xB3 (−77 signed) | Minimum ramp counter value (max fuel removal) |
| `CALTHR` | 0x09 | Deadband — counter must change by this much before a cell update |

The ramp counter `Counter_PrimaryAndSecondaryRamp` is passed directly into `CalculateSumOfAllFuelModifiers_MM` as the O2 feedback contribution.

---

## Adaptive (Long-Term) Fuel Memory

### Cell Structure

Adaptive memory consists of **15 independent cells** stored in EEPROM (`AutoCalCell0` through `AutoCalCell0+0x0E`). Each cell corresponds to a MAP/RPM operating zone. The active cell is selected by `DetermineRampCellFromRPMandMAP`.

Cell updates follow the same ±1 bit logic as the ramp counter — they accumulate slowly over many O2 toggles. Values are read from `ValueFromAdaptiveMemory` and applied in the fuel modifier chain.

### Cell Update Conditions

A cell update is **blocked** when any of these is true:

| Condition | Variable/Constant |
|-----------|------------------|
| MAP above no-update threshold | `MAPLIM` (0x66) |
| MAP below low threshold | `MAPDEC` (0x0D) |
| RPM above no-update threshold | `RPMLIM` (0x56) |
| Off-throttle enrichment active | `Timer_OffThrottleFuelEnrich` |
| Open-loop fraction timer active | `Timer_OpenLoopFraction` |
| Decel leanout active | `Factor_DecelLeanoutWhenMAPDecreasing` |
| Boost above boost threshold | `BOOSTP` (default 0xFF = disabled) |
| ATX in gear (ATX builds only) | `b0c_ATXInGear` |

### ASM Implementation

The firmware details live in `AdaptiveMemory_DetermineWhichCellApplies_MM` (line 3326) and `AdaptiveMemory_UpdateCellIfRequired_MM` (line 3269) in `T-SMEC_v19.asm`.

> **_MM note:** Routines ending in `_MM` are called from the `MainProgramLoop` (`T-SMEC_v19.asm`, line 319).

#### Cell selection, `AdaptiveMemory_DetermineWhichCellApplies_MM`

The active adaptive cell index is stored in `PointerIntoAdaptiveMemory` (RAM `0x008A`). The routine can select indices `0x00` through `0x0C`:

- `0x00` through `0x0B` are the 12 MAP/RPM cells
- `0x0C` is the closed-throttle idle cell
- `0x0D` and `0x0E` still exist in EEPROM because adaptive memory allocates 15 cells total, but this selector does not choose them

The backing EEPROM storage starts at `AutoCalCell0` (`0x000F`), so the current cell lives at `AutoCalCell0 + PointerIntoAdaptiveMemory`.

**RAM variables used by the selector:**

| Variable | Address | Purpose |
|----------|---------|---------|
| `BitFlags_4f` | `0x004F` | Idle/off-idle state source for the initial idle-cell branch |
| `TargetIdleSpeed_HB` | `0x0057` | Base idle target used for idle-cell entry |
| `EngineRpm_HB` | `0x005D` | Current RPM, scaled as RPM/32 |
| `MapValue` | `0x0063` | Current MAP value |
| `AdaptiveCellUpdateTimer_IncrementedEveryDistRisingEdge` | `0x0089` | Reset to zero whenever the active cell changes |
| `PointerIntoAdaptiveMemory` | `0x008A` | Current adaptive cell index |

**Calibration constants used by the selector:**

| Constant | Address | Default | Purpose |
|----------|---------|---------|---------|
| `MP1_AutoCalMapCellBoundary1` | `0x0BD1` | `0x28` | MAP cell boundary 1 |
| `MP2_AutoCalMapCellBoundary2` | `0x0BDE` | `0x37` | MAP cell boundary 2 |
| `MP3_AutoCalMapCellBoundary3` | `0x0BEB` | `0x4B` | MAP cell boundary 3 |
| `MP4_AutoCalMapCellBoundary4` | `0x0BF8` | `0x61` | MAP cell boundary 4 |
| `MP5_AutoCalMapCellBoundary5` | `0x0C05` | `0x78` | MAP cell boundary 5 |
| `DLTMAP_MapHysteresisAtMapCellBoundaries` | `0x0C17` | `0x01` | MAP hysteresis added when moving into a higher MAP cell |
| `R1_RPMCellBoundaryInRPMover32` | `0x0C25` | `0x32` | RPM split between the two rows, 1600 RPM |
| `DLTRPM_DeltaRPMAtRPMBoundariesInRPMOver32` | `0x0C32` | `0x02` | RPM hysteresis, 64 RPM |
| `IDLOFS_DeltaForIdleRPMForClosedThrottleCell` | `0x0C3F` | `0x04` | Idle-cell entry offset above target idle speed |
| `HYTRPM_HysteresisFor_IDLOFS` | `0x0C4C` | `0x02` | Extra idle hysteresis when the current cell is already `0x0C` |

**Exact selection flow:**

1. `Temp0` starts at `0x00`.
2. If `BitFlags_4f` is negative, the routine skips the idle-cell test and goes straight to the MAP/RPM grid.
3. Otherwise it starts with candidate cell pointer `0x0C`.
4. It loads `TargetIdleSpeed_HB`, adds `IDLOFS` (`0x04`), and if `PointerIntoAdaptiveMemory` is already `0x0C`, it adds `HYTRPM` (`0x02`) for hysteresis.
5. If `EngineRpm_HB` is less than or equal to that threshold, cell `0x0C` stays active.
6. If the idle-cell test fails, the routine scans `MP1` through `MP5`. Each time MAP is above the current boundary, it advances to the next boundary and increments `Temp0` by 2. That produces MAP column bases `0x02`, `0x04`, `0x06`, `0x08`, `0x0A`, and `0x0C`.
7. MAP hysteresis is directional. When the previous pointer is below the candidate MAP column base, the routine adds `DLTMAP` (`0x01`) to the boundary before comparing against `MapValue`.
8. After the MAP column is chosen, the routine applies the RPM split using `R1` (`0x32`, 1600 RPM). If the previous pointer is even, it adds `DLTRPM` (`0x02`, 64 RPM) before the compare.
9. RPM above the threshold selects the upper cell in that MAP column. RPM at or below the threshold subtracts one extra step, which selects the lower cell.
10. The final pointer is written back to `PointerIntoAdaptiveMemory` (`0x008A`). If it changed, the routine clears `AdaptiveCellUpdateTimer_IncrementedEveryDistRisingEdge` (`0x0089`) before storing the new pointer.

#### Cell update, `AdaptiveMemory_UpdateCellIfRequired_MM`

The update routine uses `PointerIntoAdaptiveMemory` (`0x008A`) to index the EEPROM cell array at `AutoCalCell0` (`0x000F`), then decides whether to change that cell and by how much.

**RAM variables used by the updater:**

| Variable | Address | Purpose |
|----------|---------|---------|
| `BitFlags_4f` | `0x004F` | Supplies the `b4f_OffIdle` branch for timer selection |
| `BitFlags_50` | `0x0050` | Supplies the `b50_OpenLoop` lockout |
| `InjectorPulsewidth_HB` | `0x005B` | Base injector pulsewidth term |
| `Pulsewidth_PartThrottleEnrichment_HB` | `0x007B` | Added before the pulsewidth threshold compare |
| `Counter_PrimaryAndSecondaryRamp` | `0x007D` | Signed short-term trim, its sign sets update direction |
| `AdaptiveCellUpdateTimer_IncrementedEveryDistRisingEdge` | `0x0089` | EPP countdown source and remainder store |
| `PointerIntoAdaptiveMemory` | `0x008A` | Current cell pointer |
| `ValueFromAdaptiveMemory` | `0x008B` | Copy of the selected EEPROM cell after every call |

**Calibration constants used by the updater:**

| Constant | Address | Default | Purpose |
|----------|---------|---------|---------|
| `AMUPDT_EPPsBetweenCalChangeUpdateOpenThrottle` | `0x0C66` | `0x1A` | Update interval when `b4f_OffIdle` is set |
| `AMUPDI_EPPsBetweenCalChangeUpdateClosedThrottle` | `0x0C73` | `0x1A` | Update interval when `b4f_OffIdle` is clear |
| `PWMIN_NoCellUpdateBelow_PWMIN_Pulsewidth` | `0x0CD1` | `0x0113` | Minimum `(InjectorPulsewidth + PartThrottleEnrichment)` required for updates |
| `CELCHG_BitsChangePerUpdateWithinACell` | `0x0C59` | `0x01` | Per-update cell step size |
| `AMLIMH_MaxMultiplierCannotBeAbove7F` | `0x0CB6` | `0x7F` | Positive saturation limit |
| `AMLIML_MinMultiplierCannotBeBelow80` | `0x0CC3` | `0xB3` | Negative saturation limit, signed `-77` |

**Exact update flow:**

1. The routine forms the EEPROM pointer as `AutoCalCell0 + PointerIntoAdaptiveMemory`.
2. It selects the update interval: `AMUPDT` (`0x1A`) when `b4f_OffIdle` is set, `AMUPDI` (`0x1A`) when it is clear.
3. If `b50_OpenLoop` is set in `BitFlags_50` (`0x0050`), the cell is not updated.
4. If open loop is clear, the routine computes `InjectorPulsewidth + PartThrottleEnrichment - PWMIN`. If that subtraction goes negative, the cell is not updated.
5. If both checks pass, it subtracts the selected `AMUPDT` or `AMUPDI` value from `AdaptiveCellUpdateTimer_IncrementedEveryDistRisingEdge` (`0x0089`). If the timer is smaller than the interval, the routine exits without changing the cell. If the timer is large enough, it stores the remainder back to `0x0089` and continues.
6. The update magnitude starts at `CELCHG` (`0x01`). If `Counter_PrimaryAndSecondaryRamp` (`0x007D`) is negative, the code negates that step, so the adaptive cell always moves in the same direction as the short-term O2 correction.
7. The routine adds that signed step to the current EEPROM cell value.
8. If the signed add overflows, it saturates immediately. Positive overflow clamps to `AMLIMH` (`0x7F`). Negative overflow clamps to `AMLIML` (`0xB3`, signed `-77`).
9. If the add does not overflow, the result is still checked against the same limits. Values above `AMLIMH` clamp to `0x7F`. Values below `AMLIML` clamp to `0xB3`.
10. The final saturated value is written back to the EEPROM cell, then copied to `ValueFromAdaptiveMemory` (`0x008B`).
11. When an update is blocked by open loop or by the pulsewidth threshold, the routine still copies the current EEPROM cell into `ValueFromAdaptiveMemory`. In that blocked path it also caps `AdaptiveCellUpdateTimer_IncrementedEveryDistRisingEdge` to the selected `AMUPDT` or `AMUPDI` value if the timer has grown larger than the interval.

### Clearing Adaptive Memory

Adaptive memory is cleared when either:
1. The O2 two-strike fault is thrown (see below)
2. The O2 sensor signal is detected as stuck in the middle band for too long

All 15 cells are zeroed simultaneously. The ECU must relearn from scratch after a clear.

---

## O2 Fault Mechanism (Two-Strike System)

The Turbonator firmware uses a two-strike system before setting codes 51 or 52:

**Strike one:** O2 has not toggled for longer than `LTHTIM` (0x2B ≈ 43 main loops ≈ ~480ms at 11ms/loop). The `b2e_BadO2Read` bit is set (internal warning), and adaptive memory is erased as a precaution.

**Strike two:** On the next timeout without a toggle, the ECU sets fault code:
- 0x0381 → display code **51** (O2 stuck lean)
- 0x0382 → display code **52** (O2 stuck rich)

On strike two, adaptive memory is erased again and `b50_BadO2` flag is set, locking out further O2 feedback until the fault is cleared.

This two-strike approach prevents a single momentary stall or decel condition from triggering a fault code, while still catching a genuinely failed sensor.

---

## Adaptive Knock Retard

### Purpose

Learns the engine's knock tendency at different MAP/RPM operating points. Reduces timing in regions that have historically knocked, protecting the engine across key cycles.

### How It Works

1. Knock sensor detects detonation
2. Per-cylinder retard applied immediately (see [Ignition Timing](ignition-timing.md))
3. Long-term adaptive retard index (`AdaptiveRetardIndex`) accumulates while knock is present and MAP is above the minimum threshold
4. Adaptive index is applied as an additional retard via the WG control loop timing integration

### Key Parameters

| Parameter | Default | Effect |
|-----------|---------|--------|
| `ARMINT_AdaptiveRetardMinimumTemp` | 0xA6 | Minimum CTS for adaptive retard to learn |
| `ARTM5P_AdaptiveRetardTimeOver5psiBoost` | 0x0C | Minimum time over 5 PSI before adaptive retard updates |
| `ARINDX_AdaptiveRetardIndexBase` | 0x80 | Base step for index accumulation |
| `AdaptiveRetard_MinMAPForAdjustment` | — | Set to 0xFF to disable |

### Disabling for Tuning

Set `AdaptiveRetard_MinMAPForAdjustment` to 0xFF — this prevents adaptive retard accumulation. Short-term per-cylinder retard still operates. Use this during timing optimization.

---

## Adaptive Wastegate Control

### Purpose

Learns the correct wastegate solenoid duty cycle to hit the boost target consistently, compensating for wastegate wear, spring rate changes, and altitude shifts.

### Cell Structure

The adaptive WG grid uses **5 cells** selected by a combination of MAP and RPM:

| Cell | Conditions |
|------|-----------|
| DCCOR1 | MAP below `MAPPT` threshold |
| DCCOR2 | MAP ≥ `MAPPT`, RPM < `DCRPM1` (~4200 rpm) |
| DCCOR3 | MAP ≥ `MAPPT`, RPM < `DCRPM2` (~4800 rpm) |
| DCCOR4 | MAP ≥ `MAPPT`, RPM < `DCRPM3` (~5400 rpm) |
| DCCOR5 | MAP ≥ `MAPPT`, RPM ≥ `DCRPM3` |

Cell values are centered at 0x80 (±128 steps). The signed offset is added to the base wastegate duty cycle. Cells increment when actual boost is below target (WG needs to close more) and decrement when above target (WG needs to open more).

### Update Conditions

Updates are blocked when:
- Staging/fuel cut/spark cut active (Turbonator flags)
- TPS below `TPSLIM_UpdateAdaptiveWGTPSUpperLimit`
- RPM below `DCRPML_NoWastegateDutyCycleCorrectionBelowThisRpm`
- MAP change is below `MPFLOR` threshold (MAP too stable = not converging)
- Boost is too close to target (within `MPROOF`)
- `WastegateDutyCycleIncreaseFromKnock` is nonzero

### Disabling for Tuning

Set `StopAdaptiveWGWhenMapIsThisCloseToBoostTarget` (`MPROOF`) to 0xFF — this prevents any cell updates.

---

## Idle Air Control (AIS) Learning

The AIS motor stores its learned idle position in EEPROM (`DesiredNewAisPosition`). On startup, the motor moves to this saved position before idle control begins. This compensates for air leaks, valve deposits, and other sources of long-term idle drift.

The spark scatter system (see [Ignition Timing](ignition-timing.md)) adjusts `DesiredNewAisPosition` in small steps when spark alone cannot maintain the target idle speed, creating a slow integral correction to the learned idle position.

---

## Barometric Compensation

Baro pressure is read at key-on with the engine off and stored in `BaroPressure`. This value is used throughout fuel and boost calculations to compensate for altitude. The stored baro reading persists in EEPROM and updates each key cycle.

---

## Clearing Adaptive Memory

### Methods

| Method | Clears AM? | Clears Adaptive Retard? | Clears Adaptive WG? |
|--------|-----------|------------------------|-------------------|
| Battery disconnect | Sometimes (volatile RAM only) | No | No |
| DRB-II "Erase Fault Data" | Yes | Partial | No |
| Flash ECU (EEPROM region erased) | Yes | Yes | Yes |
| O2 fault mechanism (two-strike) | **Yes (all 15 cells)** | No | No |

### When to Clear

- After major fuel table changes
- After injector replacement or resizing
- When fuel trim values are at limits (adaptives fighting the tune)
- To establish a fresh baseline after a complete retune

---

## Tuning Workflow

### Recommended Approach

1. **Disable adaptive memory** for initial base tune: set `NoCellUpdateAboveThisMAP` to 0xFF
2. **Tune fuel tables** using wideband datalogging
3. **Re-enable adaptives** and verify trims are small (< ±5%)
4. **Enable adaptive WG** and verify boost stability
5. If trims are consistently offset, adjust the base fuel table and repeat

### Common Mistakes

- Tuning with adaptives enabled (they hide calibration errors)
- Forgetting to re-enable adaptives after tuning
- Ignoring consistently large trim values — these indicate a base calibration problem
- Flashing without erasing EEPROM when making large fuel changes

---

## See Also

- [Ignition Timing](ignition-timing.md) — Per-cylinder knock retard, spark scatter AIS coupling
- [Fuel System](fuel-system.md) — How the O2 ramp is applied in the modifier chain
- [Fault Codes](../reference/fault-codes.md) — O2 fault code 21, 51, 52 details
- [Boost Control](boost-control.md) — Adaptive wastegate control integration
