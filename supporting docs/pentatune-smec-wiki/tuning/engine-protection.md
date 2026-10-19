# Engine Protection

## Overview

`ControlEngineCutout_MM` is the main-loop engine-protection routine for fuel shutoff decisions. In the frozen `T-SMEC_v19.asm` source, it combines decel fuel cut state, overboost checks, rev limiting, speed limiting, and a separate hysteresis path that decides when fuel may turn back on.

`GetControlFeedback_DetermineIfShutdownRequired_MM` runs later in the same main-loop pass and handles a different kind of protection. It checks control-feedback hardware state, counts down to `Shutdown_Routine`, and can fall through to `Stop_Routine` when the sensed state still requests shutdown.

## Overboost Protection

The overboost path starts inside `ControlEngineCutout_MM` after the routine confirms the engine is running and any active decel cut has been handled (`T-SMEC_v19.asm:5551-5574`).

### MAP and baro comparison

At `T-SMEC_v19.asm:5575-5579`, the routine subtracts `BaroPressure` from `MapValue` before any threshold comparison. That means the cutout logic is working from boost-over-baro, not raw absolute MAP.

### Limp and normal overboost branches

Two overboost branches are visible in the source:

| Path | Condition in ASM | Thresholds used | Result |
|------|------------------|-----------------|--------|
| Limp overboost | `b46_WGSolFault` set | `LMPSHF_OverboostFuelShutoffDisablePointFromMap_Limp` | Jumps straight to fuel-off rotation cut when boost is above the limp threshold (`T-SMEC_v19.asm:5579-5586`) |
| Normal overboost | `b46_WGSolFault` clear | `MPSHFT_OverboostFuelShutoffEnablePointFromMap_Timer`, `MPSHFA_OverboostFuelShutoffEnablePointFromMap_Absolute`, `TRNTM_OverboostFuelShutoffDelay` | Uses a timer threshold plus an absolute threshold, then throws the overboost code and shuts fuel off for the current rotation (`T-SMEC_v19.asm:5593-5607`) |

### Timer and absolute threshold behavior

`Cutout_CheckNormalOB` shows two separate normal-mode checks:

1. If boost-over-baro is below `MPSHFT`, the routine reloads `Timer_OverboostCountdown` from `TRNTM` and exits the overboost path (`T-SMEC_v19.asm:5594-5595`, `5588-5591`).
2. If boost-over-baro is above `MPSHFT`, the code compares the same working value against `MPSHFA`.
3. If the value is above `MPSHFA`, or if `Timer_OverboostCountdown` has already reached zero, the routine branches to `Cutout_SetOBCodeAndShutdown` (`T-SMEC_v19.asm:5596-5599`).
4. Otherwise the countdown decrements and the routine continues into rev-limiter logic (`T-SMEC_v19.asm:5598-5602`).

`Cutout_SetOBCodeAndShutdown` loads `0x0708`, calls `ThrowNonCriticalError`, then immediately branches into the one-rotation fuel-off path (`T-SMEC_v19.asm:5604-5607`). The source shows the fault code throw and the shutdown-for-this-rotation branch, but it does not by itself prove how that code is presented to the driver.

## Rev Limiting

After overboost processing, `Cutout_CheckRevLimiters` chooses which rev-limit table to use, then compares the current RPM and vehicle-speed state against that table and the overspeed constants.

### Table selection

The routine loads different rev-limit table addresses based on sensor-fault and throttle-state branches:

| ASM lines | Table selected | When used |
|-----------|----------------|-----------|
| `5610-5615` | `REVLMT2_MapLimpinAndThrAbove25PercentUpper2000` | MAP fault path with throttle above the shutoff threshold |
| `5618-5635` | `REVLMT4_MapAbove75PctAndThrLimpin2000` or `REVLMT6_RPMLimiterNormalOffRPM` | TPS fault, closed-throttle, or normal branches select the next comparison table |

The page can safely say the routine picks among alternate rev-limit thresholds based on MAP fault, TPS fault, throttle state, and a MAP-vs-baro derived load check. The source does not name these as user-facing modes beyond the calibration constant names.

### Rotation cut and overspeed checks

Once a table is selected, the code compares `EngineRpm_HB` against the selected entry. If RPM is at or above the chosen threshold, it branches to `Cutout_ShutOffEngineForThisRotation` (`T-SMEC_v19.asm:5637-5640`).

An additional overspeed branch follows:

- If RPM is at or above `SPDRPM_EngineSpeedHighLimitToEnableOverspeed`, the code compares `Temp1` against `SPDLMH_SpeedLimitFuelShutoff254mph`.
- If speed is also at or above the threshold, it uses the same one-rotation fuel-off branch (`T-SMEC_v19.asm:5641-5645`).

When `b50_FallToIdle` is clear, the routine clears `Turbonator_OverRev` and returns without entering the decel-style overspeed latch (`T-SMEC_v19.asm:5646-5648`).

## Hysteresis

The hysteresis logic lives in `Cutout_UseHysteresisToDetermineWhenToTurnFuelBackOn`. `ControlEngineCutout_MM` enters this path only when `Turbonator_MainFuelOff` is already set (`T-SMEC_v19.asm:5561-5562`).

### Decel fuel cut restore threshold

If `Turbonator_DecelFuelCut` is set, the code subtracts target idle speed from current RPM and compares the delta against `DFRPML_DecelFuelShutoffDeltaRPMOn`. Fuel turns back on only when the delta falls to or below the restore threshold (`T-SMEC_v19.asm:5669-5676`, `5683-5685`).

This is explicit hysteresis because the shutoff threshold earlier in the routine uses `DFRPMH_DecelFuelShutoffDeltaRPMOff`, not the lower `DFRPML` restore constant (`T-SMEC_v19.asm:5566-5573`).

### Overspeed and overboost restore thresholds

If the active fuel-off state is tied to `Turbonator_OverRev`, the restore path uses a different set of checks:

- If `b50_FallToIdle` is clear, fuel is restored immediately (`T-SMEC_v19.asm:5678-5679`, `5683-5685`).
- If boost-over-baro has dropped below the timer threshold, the routine reloads the overboost countdown and continues into the lower restore-RPM path (`T-SMEC_v19.asm:5687-5708`).
- If normal overboost has crossed the absolute fault point again, the code throws the fault and returns through `ThrowNonCriticalError` instead of restoring fuel (`T-SMEC_v19.asm:5700-5711`).
- For the restore decision, the routine selects `REVLMT`, `REVLMT3`, or `REVLMT5`, then turns fuel back on only when RPM is below the selected restore value, or when the lower overspeed constants `SPDRPM2_EngineSpeedLowLimitToDisableOverspeed` or `SPDLML_SpeedLimitFuelShutoffRestore253mph` are satisfied (`T-SMEC_v19.asm:5713-5748`).

Taken together, the source shows separate shutoff and restore constants for both decel cut and overspeed recovery. That keeps fuel from chattering on and off at one threshold.

## Shutdown Gating

`GetControlFeedback_DetermineIfShutdownRequired_MM` is not part of the fuel-cut branch tree above. It is a later main-loop routine that appears to check control-feedback hardware state and decide whether the ECU should keep running, enter `Shutdown_Routine`, or fall through to `Stop_Routine` (`T-SMEC_v19.asm:9215-9334`).

### Countdown-based shutdown decision

The visible logic has two countdown modes:

- At `T-SMEC_v19.asm:9248-9255`, a short countdown reloads to `0x02`. If it reaches zero, the code branches to `Shutdown_Routine`.
- At `T-SMEC_v19.asm:9257-9277`, another path initializes a longer countdown to `0x17` or `0x09` depending on `TimerOverflowsBetweenDistPulses`, toggles `pia2b_bit6`, and waits for the countdown to expire before continuing.

After that longer path, the routine calculates checksum and RAM summaries, waits about 2.5 ms, checks `pia2b_OC1Toggle` again, and either loops back into the sense sequence or proceeds toward `Stop_Routine` (`T-SMEC_v19.asm:9278-9296`).

### What the source proves, and what it does not

The source clearly shows:

- hardware-port setup on both PIAs,
- countdown-based gating,
- a direct branch to `Shutdown_Routine`, and
- a final fallthrough into `Stop_Routine` if the sensed state still demands it.

It does **not** name the exact external subsystem being protected in user-facing terms. So the safest summary is that this routine is a control-feedback shutdown gate, not a documented overboost or rev-limiter entry point.

## ASM Implementation

- `ControlEngineCutout_MM` at `T-SMEC_v19.asm:5544-5685`
- `Cutout_CheckNormalOB` at `T-SMEC_v19.asm:5593-5602`
- `Cutout_SetOBCodeAndShutdown` at `T-SMEC_v19.asm:5604-5607`
- `Cutout_CheckRevLimiters` at `T-SMEC_v19.asm:5609-5666`
- `Cutout_UseHysteresisToDetermineWhenToTurnFuelBackOn` at `T-SMEC_v19.asm:5668-5748`
- `GetControlFeedback_DetermineIfShutdownRequired_MM` at `T-SMEC_v19.asm:9215-9334`

`ControlEngineCutout_MM` is called from the main loop at `T-SMEC_v19.asm:7470`, and `GetControlFeedback_DetermineIfShutdownRequired_MM` is called later in the same loop at `T-SMEC_v19.asm:7484`. Routines ending with `_MM` are called from the MainProgramLoop (see `T-SMEC_v19.asm` line 319).

## See Also

- [Boost Control](boost-control.md) - Boost target selection, wastegate behavior, and overboost thresholds
- [Fuel System](fuel-system.md) - Fuel cut context and fueling state used elsewhere in the main loop
- [Diagnostic Routines Reference](../reference/diagnostic-routines.md) - Fault throwing, CEL behavior, and related verification paths that sit around the protection logic
- [Engine State and Emissions Control](engine-state-and-emissions.md) - ASD relay and park-neutral state that share the same foreground control model
- [Launch Control](launch-control.md) - Staging limiter logic that explicitly bypasses normal rev-limit fuel cut
- [Main Program Loop](../ecu-fundamentals/main-loop.md) - Call order for both engine-protection routines

## Source

- Frozen source: `_reference/T-SMEC_v19.asm`
- `T-SMEC_v19.asm` lines 5544-5748 (`ControlEngineCutout_MM` and local cutout labels)
- `T-SMEC_v19.asm` lines 9215-9334 (`GetControlFeedback_DetermineIfShutdownRequired_MM`)
- `T-SMEC_v19.asm` lines 7470 and 7484 (`MainProgramLoop` call sites)
