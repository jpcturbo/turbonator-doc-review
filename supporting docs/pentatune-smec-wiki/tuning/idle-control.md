# Idle and AIS Control

The Chrysler SMEC idle system combines target idle speed selection, AIS stepper control, decel airflow handling, special idle enrichment, and a low-level AIS drive routine. In the main loop, the idle cluster runs immediately after the cruise routines and before the adaptive and O2 processing block.

## Overview

The idle and AIS flow is split across a small set of foreground routines plus one low-level output driver:

| Routine | ASM line | Purpose |
|---------|----------|---------|
| `KickUpAisBy2DuringDecel_MM` | 1981 | Seeds a small two-step AIS opening when the engine is decelerating toward idle with the AIS fully shut. |
| `CalculateTargetIdleSpeedAndAisPosition_MM` | 1997 | Selects the target idle speed, manages decel fuel cut entry logic, applies baro and A/C related idle offsets, and updates `DesiredNewAisPosition`. |
| `CalculateAisPosition_MM` | 1837 | Applies MAP based decel AIS logic, rolling DACAL logic, and final closed throttle versus off-idle AIS position selection. |
| `DealWithSpecialIdle_SetBasicTiming_MM` | 5750 | Handles special idle open-loop enrichment and the DRB minimum-throttle/basic-timing service path. |
| `AisDriveRoutine` | 1361 | Pulses the AIS coils and advances `CurrentAisPosition` toward `DesiredNewAisPosition`. |
| `StoreAndLimitDesiredAisPosition` | 2500 | Shared helper that clamps positive and negative AIS deltas to the valid 0 to `AISHLM` range. |
| `DIN_ACLRDBOUT_CALCULATE_BASEDON_IDLE_ERROR_ROUTINE` | 5915 | Shared idle-error helper that scales delta RPM down and looks up `IDLADD_FuelStabilization_FromDeltaRPM`. |

The main loop calls the `_MM` routines in this order: `KickUpAisBy2DuringDecel_MM` at line 7460, `CalculateTargetIdleSpeedAndAisPosition_MM` at line 7461, `CalculateAisPosition_MM` at line 7462, and `DealWithSpecialIdle_SetBasicTiming_MM` at line 7469. See [Main Program Loop](../ecu-fundamentals/main-loop.md) for the larger foreground schedule.

### Enable conditions

The idle routines do not all use the same entry gates, but the foreground control path repeatedly checks these conditions before it will actively reposition the AIS:

| Condition | Evidence in source | Effect |
|-----------|--------------------|--------|
| Engine running | `BitFlags_54` tests in `CalculateAisPosition_MM` and `CalculateTargetIdleSpeedAndAisPosition_MM` | Idle control returns early or switches to startup defaults if the engine is not running. |
| Closed throttle / not off-idle | `b4f_OffIdle` tests in `CalculateAisPosition_MM`, `CalculateTargetIdleSpeedAndAisPosition_MM`, and `DealWithSpecialIdle_SetBasicTiming_MM` | Off-idle operation moves the code into fallback or off-idle airflow paths instead of idle feedback. |
| MAP signal valid | `b45_MapStuck` and `b45_MapBadSignal` checks in `CalculateAisPosition_MM` and `KickUpAisBy2DuringDecel_MM` | Invalid MAP prevents normal idle feedback and forces conservative behavior. |
| AIS feedback countdown expired | `Timer_CountdownFromStartRunForAisFeedback` checks in `CalculateAisPosition_MM` and decel-fuel-cut logic in `CalculateTargetIdleSpeedAndAisPosition_MM` | Startup feedback inhibit must clear before the full idle feedback path runs. |
| No special DRB mode blocking idle updates | `ATMOffset` and `DRBPointer1/2` checks at 1998 through 2003 and 2052 through 2060 | Certain service modes hold the routine in a diagnostic idle target instead of normal control. |

### State logic

At a high level, the idle cluster behaves like this:

1. `KickUpAisBy2DuringDecel_MM` adds a small opening if the engine is falling toward idle and both AIS position bytes are still zero.
2. `CalculateTargetIdleSpeedAndAisPosition_MM` computes the current idle speed target from coolant temperature, gear state, baro compensation, and A/C related branches. The same routine also owns the decel fuel cut gate and several A/C kick or restriction timers.
3. `CalculateAisPosition_MM` applies the slower MAP based idle-air logic, including DACAL style learning and decel AIS control through `StoreAndLimitDesiredAisPosition`.
4. `AisDriveRoutine` compares `DesiredNewAisPosition` to `CurrentAisPosition`, selects the next AIS step pattern, toggles the PIA outputs, and records the motor movement.
5. `DealWithSpecialIdle_SetBasicTiming_MM` updates the special idle fuel-enrichment timer. When spark scatter is active, the helper at line 5915 supplies the idle-error based fuel stabilization term, but the spark scatter timing behavior itself belongs to [Ignition Timing](ignition-timing.md).

## Calibration Constants

The routines in this page touch many calibration items. The table below focuses on the constants and tables directly visible in the documented idle and AIS control flow.

| Constant / table | Used by | Description |
|------------------|---------|-------------|
| `AISTEP_BitPatternForAisControl` | `AisDriveRoutine` | Coil drive bit-pattern table used to sequence the AIS stepper outputs. |
| `DANOM_Base_nominalCal` | `CalculateAisPosition_MM` | Base nominal term for the DACAL style MAP control value. |
| `TIMEDC_AISDecelBaseAirflowCurveOffset` | `CalculateAisPosition_MM` | Time based decel airflow offset added while `b50_FallToIdle` is set. |
| `TEMPDC_AISDecel_FromTemp` | `CalculateAisPosition_MM` | Coolant based decel airflow correction. |
| `DAACF_ACFactorDeltaFromBase` | `CalculateAisPosition_MM` | Extra decel airflow allowance tied to A/C clutch state. |
| `MAPFLR_AISAdditionToControlMap_FromRpm` | `CalculateAisPosition_MM` | RPM based control-MAP term used by decel AIS logic. |
| `MPTEMP_TempTermForMapOffset_FromTemp` | `CalculateAisPosition_MM` | Coolant multiplier applied to the control-MAP term. |
| `BARFLR_OffsetCorrectionTo_MAPFLR_FromBaro` | `CalculateAisPosition_MM` | Baro correction for the control-MAP threshold. |
| `DCLRFQ_TimeBetweenAisPulsesForDecelAis` | `CalculateAisPosition_MM` | Minimum decel AIS interval before another pulse is allowed. |
| `DCLMIN_MinLimitOnDecelAisControlledMap` | `CalculateAisPosition_MM` | Lower clamp for the decel control-MAP value. |
| `DCLMN2_NoAisControlIfMapAndControlMapBelowThis` | `CalculateAisPosition_MM`, `CalculateTargetIdleSpeedAndAisPosition_MM` | Shared threshold that suppresses AIS action at very low MAP. |
| `DAISOP_DecelAisOpenStepsFromNeg_FromDeltaMap` | `CalculateAisPosition_MM` | Lookup table for opening AIS steps from negative delta MAP. |
| `DAISCL_DecelAisOpenStepsFromPos_FromDeltaMap` | `CalculateAisPosition_MM` | Lookup table for closing AIS steps from positive delta MAP. |
| `DCALTM_DacalInhibitTimeAfterStartup` | `CalculateAisPosition_MM` | Startup delay before DACAL learning can begin. |
| `DATHOT_EngineTempToStartCalibratingDacal` | `CalculateAisPosition_MM` | Coolant threshold before DACAL updates are allowed. |
| `DCALRT_DacalUpdateRate01_03_07_0f_1f_3f_7f_ff` | `CalculateAisPosition_MM` | Loop mask that paces DACAL updates. |
| `DADRPM_DeltaRpmFromIdleSpeedForDacalUpdate` | `CalculateAisPosition_MM` | RPM error window required for DACAL countdown updates. |
| `CALRAT_AisAdjustRate` | `CalculateAisPosition_MM` | Loop mask that limits direct AIS position adjustments. |
| `CALPOS_PositionAisMotorIsAtIdle` | `CalculateAisPosition_MM` | Calibrated closed-throttle idle AIS position. |
| `DCLMER_MinTimeEngineRunningForDecelFuelShutoff` | `CalculateTargetIdleSpeedAndAisPosition_MM` | Minimum run time before decel fuel cut can engage. |
| `DCLMCT_MinCoolantTempForDecelFuelShutoff` | `CalculateTargetIdleSpeedAndAisPosition_MM` | Minimum coolant temperature for decel fuel cut. |
| `MPHREF_SwitchPointForDecelIdleAisControl` | `CalculateTargetIdleSpeedAndAisPosition_MM` | Vehicle-speed switch point used in the decel idle path. |
| `DCLRPL_EngineRPMLimitForDecelFuelShutoffLow` | `CalculateTargetIdleSpeedAndAisPosition_MM` | Low RPM limit for enabling decel fuel shutoff. |
| `DCLRPH_EngineRPMLimitForDecelFuelShutoffHigh` | `CalculateTargetIdleSpeedAndAisPosition_MM` | High RPM limit for clearing decel fuel shutoff. |
| `DCAISI_AISIncrementWhenUsingDecelFuelShut` | `CalculateTargetIdleSpeedAndAisPosition_MM` | AIS increment applied when the decel-fuel-cut path uses `ClearAisTimer`. |
| `BARAIS_AISBaroCompensation` | `CalculateTargetIdleSpeedAndAisPosition_MM` | Barometric compensation term stored in `Temp1` for later idle/A/C math. |
| `AISCLD_IdleSpeedDrive_FromTemp` | `CalculateTargetIdleSpeedAndAisPosition_MM` | Drive idle-speed table used when the ATX is in gear. |
| `AISPN_IdleSpeedParkNeutral_FromTemp` | `CalculateTargetIdleSpeedAndAisPosition_MM` | Park/neutral idle-speed table used when not in gear. |
| `TIMED2_AISDecelBaseAirflowCurveOffset2` | `CalculateTargetIdleSpeedAndAisPosition_MM` | Time based add-on used while constructing target idle speed. |
| `IDLDEF_TargetIdleSpeed_HBDefault` | `CalculateTargetIdleSpeedAndAisPosition_MM` | Default idle target when coolant is invalid. |
| `DECAIS_RollingAisUpdateRate_01_03_07_0f_1f_3f_7f_ff` | `CalculateTargetIdleSpeedAndAisPosition_MM` | Rolling AIS update mask in idle-speed mode. |
| `ISPDCY_RollingAisDecay` | `CalculateTargetIdleSpeedAndAisPosition_MM` | Decay applied to the rolling idle-speed term. |
| `RPMTHS_RPMThresholdForIdleControl` | `CalculateTargetIdleSpeedAndAisPosition_MM` | Threshold that decides whether to force the RPM default on startup. |
| `RPMDEF_RPMDefaultForIdleControl` | `CalculateTargetIdleSpeedAndAisPosition_MM` | Startup idle-control default RPM. |
| `AISTRT_AisStartupPosition_FromTemp` | `CalculateTargetIdleSpeedAndAisPosition_MM` | Startup AIS position lookup table. |
| `ACCTIM_AcDelayFromStartRunTransfer` and related `AC*` constants | `CalculateTargetIdleSpeedAndAisPosition_MM` | A/C delay, kick, speed, and clutch restriction constants that shape idle airflow during clutch transitions. |
| `FWDAIS_ForwardAisSteps_NoSlope` | `CalculateTargetIdleSpeedAndAisPosition_MM` | No-slope step table for opening AIS from RPM error. |
| `REVAIS_ReverseAisSteps_NoSlope` | `CalculateTargetIdleSpeedAndAisPosition_MM` | No-slope step table for closing AIS from RPM error. |
| `AISFRQ_AisPeriodForRpmFeedback11ms` | `CalculateTargetIdleSpeedAndAisPosition_MM` | RPM feedback period between AIS corrections. |
| `CLDPOS_AisColdPosition_FromTemp` | `CalculateTargetIdleSpeedAndAisPosition_MM` | Coolant based cold AIS position floor. |
| `AISLMH_RollingAisHighLimit` and `AISLML_RollingAisLowLimit` | `CalculateTargetIdleSpeedAndAisPosition_MM` | Rolling idle window that bounds `DesiredNewAisPosition`. |
| `AISHLM_AisHighLimitMaxOpenSteps` | `StoreAndLimitDesiredAisPosition`, `CalculateTargetIdleSpeedAndAisPosition_MM` | Global upper clamp for the desired AIS position. |
| `RIDLST_OpenLoopEnrichFactorWhenSettingMinThrottleOpening` | `DealWithSpecialIdle_SetBasicTiming_MM` | Open-loop enrichment used during DRB minimum-throttle setup. |
| `RICHSA_OpenLoopEnrichFactorWhenSettingBasicTiming` | `DealWithSpecialIdle_SetBasicTiming_MM` | Open-loop enrichment used for the basic timing path. |
| `O2ITIM_TimeO2InhibitedSwitchingRichIdleToClosedLoop` | `DealWithSpecialIdle_SetBasicTiming_MM` | Reloaded when the off-throttle enrichment timer expires. |
| `IDLADD_FuelStabilization_FromDeltaRPM` | helper at 5915 | Fuel stabilization lookup indexed from scaled idle RPM error. |

## ASM Implementation

### `AisDriveRoutine` (`T-SMEC_v19.asm:1361`)

`AisDriveRoutine` is the low-level actuator owner. It exits immediately when the key-on countdown is non-zero, otherwise it compares `CurrentAisPosition` to `DesiredNewAisPosition`, chooses the step direction, indexes `AISTEP_BitPatternForAisControl`, toggles the PIA1 port-B outputs, and updates `CurrentAisPosition`. If the driven output pattern does not match the expected coil state, it sets `b47_AisFail`.

### `CalculateAisPosition_MM` (`T-SMEC_v19.asm:1837`)

This routine is the main idle-air feedback worker. The early gates reject engine-not-running, off-idle, idle-speed mode, bad MAP, and startup-feedback-inhibit states. Once inside the control path, it builds a control-MAP threshold from DACAL state, RPM, coolant, baro, and A/C terms.

Two major subpaths follow:

- **Closed-throttle DACAL path**: when the engine is not in `b50_FallToIdle`, the code updates `Timer_DacalCountdown`, checks the RPM error window around `TargetIdleSpeed_HB`, and can directly move both AIS position bytes around `CALPOS_PositionAisMotorIsAtIdle`.
- **Decel AIS path**: when `b50_FallToIdle` is set, the code waits for `DCLRFQ_TimeBetweenAisPulsesForDecelAis`, compares the control MAP to `MapValue`, looks up either `DAISOP` or `DAISCL`, then calls `StoreAndLimitDesiredAisPosition`.

### `KickUpAisBy2DuringDecel_MM` (`T-SMEC_v19.asm:1981`)

This is a small recovery routine. Every 128th main-loop tick, if the engine is not in `b50_FallToIdle`, the MAP signal is valid, and both AIS position bytes are zero, the routine opens the AIS by two steps and sets `b51_bit6`. In practice it looks like a minimal kick-open seed so the later idle logic does not start from a fully shut motor.

### `CalculateTargetIdleSpeedAndAisPosition_MM` (`T-SMEC_v19.asm:1997`)

This routine owns the highest-level idle target and most of the idle-state branching:

- It returns immediately for service offsets `0x07` and `0x14`.
- It contains the decel-fuel-cut gate that checks engine run time, coolant temperature, throttle state, vehicle speed, and RPM relative to `TargetIdleSpeed_HB`.
- It looks up the baro compensation term `BARAIS_AISBaroCompensation` and then selects an idle-speed target from either `AISCLD_IdleSpeedDrive_FromTemp` or `AISPN_IdleSpeedParkNeutral_FromTemp`.
- It handles A/C clutch transition timers, kick-open or kick-close logic, and the rolling idle-speed/AIS feedback block that uses `FWDAIS`, `REVAIS`, `CLDPOS`, `AISLMH`, and `AISLML`.
- It ends by storing the final `DesiredNewAisPosition`, sometimes with slower off-idle closing behavior.

Because this routine mixes target-idle selection, A/C idle-up handling, and decel-fuel-cut gating, it is the central owner for idle state transitions rather than just a simple target-speed lookup.

### `StoreAndLimitDesiredAisPosition` (`T-SMEC_v19.asm:2500`)

This helper applies signed AIS deltas to `DesiredNewAisPosition`.

- Positive deltas add to the current desired position and clamp at `AISHLM_AisHighLimitMaxOpenSteps`.
- Negative deltas add in two's-complement form and clamp at zero.

Several A/C and decel branches use this helper so they all share the same saturation behavior.

### `DealWithSpecialIdle_SetBasicTiming_MM` (`T-SMEC_v19.asm:5750`)

This routine does not move the AIS directly. Instead it manages special idle enrichment while the throttle is closed and while the DRB minimum-throttle/basic-timing mode is active. If the timer is non-zero, it clears the primary and secondary O2 ramp counter and the adaptive-memory erase counter, which keeps the closed-throttle service mode from fighting the technician with normal closed-loop correction.

### `DIN_ACLRDBOUT_CALCULATE_BASEDON_IDLE_ERROR_ROUTINE` (`T-SMEC_v19.asm:5915`)

This directly required helper takes the signed idle RPM error already prepared in D, shifts it right four times, saturates the index to one byte, and looks up `IDLADD_FuelStabilization_FromDeltaRPM`. The caller in `CalculatePartThrottleEnrichmentAndSparkScatterFuel_MM` then adds or subtracts the returned fuel term depending on whether idle RPM is below or above the target. That is the only idle-error helper in the requested source range, and it is the fuel-side companion to the spark-scatter path.

For the timing-side spark scatter logic that uses the same idle error context, see [Ignition Timing](ignition-timing.md).

## See Also

- [Main Program Loop](../ecu-fundamentals/main-loop.md) - Foreground call order for the idle cluster.
- [Sensor Processing and Derived State](../ecu-fundamentals/sensor-processing.md) - Throttle, MAP, baro, and temperature state feeding the idle routines.
- [Engine State and Emissions Control](engine-state-and-emissions.md) - Park-neutral and relay state that influence idle operating conditions.
- [Ignition Timing](ignition-timing.md) - Spark scatter behavior and the basic-timing service path.
- [Fuel System](fuel-system.md) - Part-throttle enrichment and fuel-side idle stabilization.
- [Adaptive Systems](adaptive-systems.md) - O2 and adaptive counters that are cleared during special idle handling.

## Source

- `T-SMEC_v19.asm` lines 1361-1446 (`AisDriveRoutine`)
- `T-SMEC_v19.asm` lines 1837-2500 (`CalculateAisPosition_MM`, `KickUpAisBy2DuringDecel_MM`, `CalculateTargetIdleSpeedAndAisPosition_MM`, `StoreAndLimitDesiredAisPosition`)
- `T-SMEC_v19.asm` lines 5750-5927 (`DealWithSpecialIdle_SetBasicTiming_MM`, `DIN_ACLRDBOUT_CALCULATE_BASEDON_IDLE_ERROR_ROUTINE`)
