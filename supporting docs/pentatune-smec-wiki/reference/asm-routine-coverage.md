# ASM Routine Coverage Matrix

**Firmware**: `T-SMEC_v19.asm` (1989 Turbonator SMEC v19)
**Source freeze**: `_reference/T-SMEC_v19.asm` at commit `c9e5cec960136f25b706a41f5061d8d0e8278c2d`
**Purpose**: Freeze the remaining ASM documentation backlog, define scope boundaries, and assign one canonical owner page per routine family.

---

## Overview

This page is the campaign source of truth for the remaining T-SMEC v19 ASM coverage work. It records the frozen source, the scope taxonomy, and the exact subsystem clusters assigned by the plan.

Routines ending with `_MM` are called from `MainProgramLoop` (`_reference/T-SMEC_v19.asm:319`). This page tracks ownership and backlog control only. Detailed subsystem behavior belongs on the owner pages listed below.

The Wave 3 reconciliation is complete. In-scope rows below now use final coverage language rather than backlog wording. `Covered` means the canonical owner page now contains the family. `Moved` means the family is intentionally owned by another page and remains linked from the earlier page that introduced it.

## Scope Taxonomy

### In Scope

| Type | Rule |
|------|------|
| Callable routines | In scope when they are meaningful owner routines for the remaining backlog. |
| Interrupt vectors and handlers | In scope when they directly drive fuel, spark, boost, idle, diagnostics, or system timing. |
| Critical helpers | In scope when the plan promoted them into a cluster or when an owner page cannot be explained without them. |
| Shared service helpers | In scope only when the plan explicitly assigns them to a page, such as DRB / SCI helpers or AIS / alternator drivers. |

### Out of Scope Unless Promoted

| Type | Rule |
|------|------|
| Local branch labels | Do not treat `Lxxxx`, `Rxxxx`, or similar local labels as owner routines. |
| Tables and data blocks | Do not promote table names or data-only symbols into routine owners by themselves. |
| Macros | Out of scope unless they are the only hardware-facing implementation point. |
| Trivial one-line stubs | Out of scope unless the coverage matrix later promotes them for a hardware-facing page. |

### Ownership Rule

Each routine family gets exactly one canonical owner page. Secondary pages may mention the family, but they should summarize briefly and link to the owner page instead of restating internals.

## Assigned Subsystem Clusters

| Cluster | Canonical owner page | Implemented in task | Routine families | Coverage status |
|--------|----------------------|---------------------|------------------|-----------------|
| Idle / AIS | `docs/wiki/tuning/idle-control.md` | 2 | 7 | Covered |
| Engine protection | `docs/wiki/tuning/engine-protection.md` | 3 | 6 | Covered |
| Diagnostic routines | `docs/wiki/reference/diagnostic-routines.md` | 4 | 11 direct families, plus 2 charging cross-references | Covered |
| Sensor processing | `docs/wiki/ecu-fundamentals/sensor-processing.md` | 5 | 9 | Covered |
| Fuel internals | `docs/wiki/tuning/fuel-system.md` | 6 | 4 direct families, plus 2 interrupt-path cross-references | Covered |
| Boost internals | `docs/wiki/tuning/boost-control.md` | 7 | 10 | Covered |
| Engine-state / emissions | `docs/wiki/tuning/engine-state-and-emissions.md` | 14 | 4 | Covered |
| Charging | `docs/wiki/hardware/charging-system.md` | 8 | 6 | Covered |
| Startup / initialization | `docs/wiki/ecu-fundamentals/startup-initialization.md` | 9 | 4 | Covered |
| Interrupt handlers | `docs/wiki/ecu-fundamentals/interrupt-handlers.md` | 10 | 12 | Covered |
| Hardware diagnostics / DRB helpers | `docs/wiki/hardware/diagnostics.md` | 11 | 10 | Covered |

### Idle / AIS

| Routine family | Frozen source lines | Canonical owner page | Coverage status |
|---------------|---------------------|----------------------|-----------------|
| `AisDriveRoutine` | 1361 | `docs/wiki/tuning/idle-control.md` | Covered in canonical owner page |
| `CalculateAisPosition_MM` | 1837 | `docs/wiki/tuning/idle-control.md` | Covered in canonical owner page |
| `KickUpAisBy2DuringDecel_MM` | 1981 | `docs/wiki/tuning/idle-control.md` | Covered in canonical owner page |
| `CalculateTargetIdleSpeedAndAisPosition_MM` | 1997 | `docs/wiki/tuning/idle-control.md` | Covered in canonical owner page |
| `StoreAndLimitDesiredAisPosition` | 2500 | `docs/wiki/tuning/idle-control.md` | Covered in canonical owner page |
| `DealWithSpecialIdle_SetBasicTiming_MM` | 5750 | `docs/wiki/tuning/idle-control.md` | Covered in canonical owner page |
| `DIN_ACLRDBOUT_CALCULATE_BASEDON_IDLE_ERROR_ROUTINE` | 5915 | `docs/wiki/tuning/idle-control.md` | Covered in canonical owner page |

### Engine Protection

| Routine family | Frozen source lines | Canonical owner page | Coverage status |
|---------------|---------------------|----------------------|-----------------|
| `ControlEngineCutout_MM` | 5544 | `docs/wiki/tuning/engine-protection.md` | Covered in canonical owner page |
| `Cutout_CheckNormalOB` | 5593 | `docs/wiki/tuning/engine-protection.md` | Covered in canonical owner page |
| `Cutout_SetOBCodeAndShutdown` | 5604 | `docs/wiki/tuning/engine-protection.md` | Covered in canonical owner page |
| `Cutout_CheckRevLimiters` | 5609 | `docs/wiki/tuning/engine-protection.md` | Covered in canonical owner page |
| `Cutout_UseHysteresisToDetermineWhenToTurnFuelBackOn` | 5668 | `docs/wiki/tuning/engine-protection.md` | Covered in canonical owner page |
| `GetControlFeedback_DetermineIfShutdownRequired_MM` | 9215 | `docs/wiki/tuning/engine-protection.md` | Covered in canonical owner page |

### Diagnostic Routines

| Routine family | Frozen source lines | Canonical owner page | Coverage status |
|---------------|---------------------|----------------------|-----------------|
| `ProcessErrorBits_WorkWithData_MM` | 4464 | `docs/wiki/reference/diagnostic-routines.md` | Covered in canonical owner page |
| `CheckIfCheckEngineLightShouldBeOn_MM` | 4549 | `docs/wiki/reference/diagnostic-routines.md` | Covered in canonical owner page |
| `UpdateErrorTimersAndPossiblyClearErrors_MM` | 4592 | `docs/wiki/reference/diagnostic-routines.md` | Covered in canonical owner page |
| `CheckForErrorsAndSetCodes_MM` | 4668 | `docs/wiki/reference/diagnostic-routines.md` | Covered in canonical owner page |
| `ThrowMajorErrorIfRequired_MM` | 4702 | `docs/wiki/reference/diagnostic-routines.md` | Covered in canonical owner page |
| `VerifyOperationOfIgnitionCoilDriver_MM` | 4720 | `docs/wiki/reference/diagnostic-routines.md` | Covered in canonical owner page |
| `VerifyOperationOfFuelInjectorDrivers_MM` | 4744 | `docs/wiki/reference/diagnostic-routines.md` | Covered in canonical owner page |
| `VerifyOperationOfMapSensor_MM` | 4830 | `docs/wiki/reference/diagnostic-routines.md` | Covered in canonical owner page |
| `VerifyOperationOfThermostat_MM` | 4965 | `docs/wiki/reference/diagnostic-routines.md` | Covered in canonical owner page |
| `VerifyOperationOfASDRelayAndO2Sensor_MM` | 4992 | `docs/wiki/reference/diagnostic-routines.md` | Covered in canonical owner page |
| `VerifyOperationOfIgnitionCoilDriver2_MM` | 5087 | `docs/wiki/reference/diagnostic-routines.md` | Covered in canonical owner page |
| `VerifyOperationOfBatteryVoltage_MM` | 4528 | `docs/wiki/hardware/charging-system.md` | Moved, canonical owner is `charging-system.md`; linked from `diagnostic-routines.md` |
| `DetectAlternatorFault_MM` | 4638 | `docs/wiki/hardware/charging-system.md` | Moved, canonical owner is `charging-system.md`; linked from `diagnostic-routines.md` |

### Sensor Processing

| Routine family | Frozen source lines | Canonical owner page | Coverage status |
|---------------|---------------------|----------------------|-----------------|
| `HandleBaroReadRequirement_MM` | 1448 | `docs/wiki/ecu-fundamentals/sensor-processing.md` | Covered in canonical owner page |
| `ReadBaroIfPossible` | 1473 | `docs/wiki/ecu-fundamentals/sensor-processing.md` | Covered in canonical owner page |
| `SaveBaroPressure` | 1519 | `docs/wiki/ecu-fundamentals/sensor-processing.md` | Covered in canonical owner page |
| `SimulateMapReadingFromTps` | 4506 | `docs/wiki/ecu-fundamentals/sensor-processing.md` | Covered in canonical owner page |
| `CheckAndFilterCoolantAndChargeTempSensors_MM` | 7531 | `docs/wiki/ecu-fundamentals/sensor-processing.md` | Covered in canonical owner page |
| `DetermineIfWindowedBladeInSyncSensorOnDistributor_MM` | 7666 | `docs/wiki/ecu-fundamentals/sensor-processing.md` | Covered in canonical owner page |
| `CheckThrottleRoutine_MM` | 7695 | `docs/wiki/ecu-fundamentals/sensor-processing.md` | Covered in canonical owner page |
| `DetermineNumberOfOverflowsBetweenSpeedoPulses_MM` | 8315 | `docs/wiki/ecu-fundamentals/sensor-processing.md` | Covered in canonical owner page |
| `DetermineNumberOfOverflowsBetweenDistributorPulses_MM` | 9171 | `docs/wiki/ecu-fundamentals/sensor-processing.md` | Covered in canonical owner page |

### Fuel Internals

| Routine family | Frozen source lines | Canonical owner page | Coverage status |
|---------------|---------------------|----------------------|-----------------|
| `CalculateInjectorPulsewidthForStarting_MM` | 5483 | `docs/wiki/tuning/fuel-system.md` | Covered in canonical owner page |
| `CalculateSumOfAllFuelModifiers_MM` | 5929 | `docs/wiki/tuning/fuel-system.md` | Covered in canonical owner page |
| `CalculatePartThrottleTransientFuel_MM` | 6330 | `docs/wiki/tuning/fuel-system.md` | Covered in canonical owner page |
| `TransFuel_*` helper family | 6354-6498 | `docs/wiki/tuning/fuel-system.md` | Covered in canonical owner page |
| `CalculateInjectorPulsewidthForEngineRunning` | 6773 | `docs/wiki/ecu-fundamentals/interrupt-handlers.md` | Moved, canonical owner is `interrupt-handlers.md`; linked from `fuel-system.md` |
| `HandleFuelStartRunStartTransfer` | 6906 | `docs/wiki/ecu-fundamentals/interrupt-handlers.md` | Moved, canonical owner is `interrupt-handlers.md`; linked from `fuel-system.md` |

### Boost Internals

| Routine family | Frozen source lines | Canonical owner page | Coverage status |
|---------------|---------------------|----------------------|-----------------|
| `LookupAndKeepSmallerBoostGoal` | 9336 | `docs/wiki/tuning/boost-control.md` | Covered in canonical owner page |
| `CalcTargetBoost_MM` | 9347 | `docs/wiki/tuning/boost-control.md` | Covered in canonical owner page |
| `CalcWGDutyCycle_MM` | 9430 | `docs/wiki/tuning/boost-control.md` | Covered in canonical owner page |
| `CalcWGDutyCycleT1` | 9436 | `docs/wiki/tuning/boost-control.md` | Covered in canonical owner page |
| `WGDC_AdjustWGDutyCycle` | 9494 | `docs/wiki/tuning/boost-control.md` | Covered in canonical owner page |
| `WGDC_UpdateAdaptiveWGControlMemory` | 9648 | `docs/wiki/tuning/boost-control.md` | Covered in canonical owner page |
| `CalcWGDutyCycleT2` | 9679 | `docs/wiki/tuning/boost-control.md` | Covered in canonical owner page |
| `InterruptVector_TimerOC2_Wastegate` | 9965 | `docs/wiki/tuning/boost-control.md` | Covered in canonical owner page |
| `WG_SetOutput` | 9978 | `docs/wiki/tuning/boost-control.md` | Covered in canonical owner page |
| `WG_ClearOutput` | 9984 | `docs/wiki/tuning/boost-control.md` | Covered in canonical owner page |

### Engine-State / Emissions

| Routine family | Frozen source lines | Canonical owner page | Coverage status |
|---------------|---------------------|----------------------|-----------------|
| `ControlAsdRelay_MM` | 1535 | `docs/wiki/tuning/engine-state-and-emissions.md` | Covered in canonical owner page |
| `ControlPurgeSolenoid_MM` | 1785 | `docs/wiki/tuning/engine-state-and-emissions.md` | Covered in canonical owner page |
| `ExhGasRecirc_MM` | 5320 | `docs/wiki/tuning/engine-state-and-emissions.md` | Covered in canonical owner page |
| `DetectParkNeutral_MM` | 8959 | `docs/wiki/tuning/engine-state-and-emissions.md` | Covered in canonical owner page |

### Charging

| Routine family | Frozen source lines | Canonical owner page | Coverage status |
|---------------|---------------------|----------------------|-----------------|
| `ControlAlternator` | 1277 | `docs/wiki/hardware/charging-system.md` | Covered in canonical owner page |
| `TurnAlternatorOn` | 1326 | `docs/wiki/hardware/charging-system.md` | Covered in canonical owner page |
| `TurnAlternatorOff` | 1339 | `docs/wiki/hardware/charging-system.md` | Covered in canonical owner page |
| `DetermineTargetBatteryVoltage_MM` | 1637 | `docs/wiki/hardware/charging-system.md` | Covered in canonical owner page |
| `VerifyOperationOfBatteryVoltage_MM` | 4528 | `docs/wiki/hardware/charging-system.md` | Covered in canonical owner page |
| `DetectAlternatorFault_MM` | 4638 | `docs/wiki/hardware/charging-system.md` | Covered in canonical owner page |

### Startup / Initialization

| Routine family | Frozen source lines | Canonical owner page | Coverage status |
|---------------|---------------------|----------------------|-----------------|
| `SetupSystemRegisters` | 4914 | `docs/wiki/ecu-fundamentals/startup-initialization.md` | Covered in canonical owner page |
| `ZeroRamFrom0EtoFE` | 7200 | `docs/wiki/ecu-fundamentals/startup-initialization.md` | Covered in canonical owner page |
| `ResetCopTimer` | 7289 | `docs/wiki/ecu-fundamentals/startup-initialization.md` | Covered in canonical owner page |
| `SetupSystemAndGoToMainLoop` | 7298 | `docs/wiki/ecu-fundamentals/startup-initialization.md` | Covered in canonical owner page |

### Interrupt Handlers

| Routine family | Frozen source lines | Canonical owner page | Coverage status |
|---------------|---------------------|----------------------|-----------------|
| `InterruptVector_DistributorSignal` | 6502 | `docs/wiki/ecu-fundamentals/interrupt-handlers.md` | Covered in canonical owner page |
| `Interrupt_HandleDistributorRisingEdge` | 6558 | `docs/wiki/ecu-fundamentals/interrupt-handlers.md` | Covered in canonical owner page |
| `CALC_SPARK_RETARD_BASED_ON_KNOCK_VOLT` | 6714 | `docs/wiki/ecu-fundamentals/interrupt-handlers.md` | Covered in canonical owner page |
| `SUM_ADDITIONAL_RETARD` | 6735 | `docs/wiki/ecu-fundamentals/interrupt-handlers.md` | Covered in canonical owner page |
| `MAX_RETARD` | 6740 | `docs/wiki/ecu-fundamentals/interrupt-handlers.md` | Covered in canonical owner page |
| `CalculateInjectorPulsewidthForEngineRunning` | 6773 | `docs/wiki/ecu-fundamentals/interrupt-handlers.md` | Covered in canonical owner page |
| `Interrupt_HandleDistributorFallingEdge` | 6867 | `docs/wiki/ecu-fundamentals/interrupt-handlers.md` | Covered in canonical owner page |
| `HandleFuelStartRunStartTransfer` | 6906 | `docs/wiki/ecu-fundamentals/interrupt-handlers.md` | Covered in canonical owner page |
| `ReadKnockSensorAndRecalcSparkPosition` | 7013 | `docs/wiki/ecu-fundamentals/interrupt-handlers.md` | Covered in canonical owner page |
| `Interrupt_RealTime` | 7145 | `docs/wiki/ecu-fundamentals/interrupt-handlers.md` | Covered in canonical owner page |
| `InterruptVector_SpeedometerSignal` | 8204 | `docs/wiki/ecu-fundamentals/interrupt-handlers.md` | Covered in canonical owner page |
| `InterruptVector_PIA_Signal` | 9189 | `docs/wiki/ecu-fundamentals/interrupt-handlers.md` | Covered in canonical owner page |

### Hardware Diagnostics / DRB Helpers

| Routine family | Frozen source lines | Canonical owner page | Coverage status |
|---------------|---------------------|----------------------|-----------------|
| `SetupHiSpeedDataTransfer` | 3659 | `docs/wiki/hardware/diagnostics.md` | Covered in canonical owner page |
| `SetupATM` | 3670 | `docs/wiki/hardware/diagnostics.md` | Covered in canonical owner page |
| `SendDiagnosticDataToSCI` | 3693 | `docs/wiki/hardware/diagnostics.md` | Covered in canonical owner page |
| `SendMemoryLocToSCI` | 3707 | `docs/wiki/hardware/diagnostics.md` | Covered in canonical owner page |
| `SendRealTImeDatatoSCI` | 3717 | `docs/wiki/hardware/diagnostics.md` | Covered in canonical owner page |
| `SendECUIDToSCI` | 3770 | `docs/wiki/hardware/diagnostics.md` | Covered in canonical owner page |
| `InitByteModeDownload` | 3855 | `docs/wiki/hardware/diagnostics.md` | Covered in canonical owner page |
| `ActuatorTestMode_MM` | 3894 | `docs/wiki/hardware/diagnostics.md` | Covered in canonical owner page |
| `FlashCodesOutOnCEL` | 4116 | `docs/wiki/hardware/diagnostics.md` | Covered in canonical owner page |
| `DRB_UpdatePIA1AndCheckOuputs_MM` | 4253 | `docs/wiki/hardware/diagnostics.md` | Covered in canonical owner page |

## Deferred / Explicitly Out of Scope

| Item | Frozen source lines | Reason | Note |
|------|---------------------|--------|------|
| Local labels such as `L1000`, `R1028`, `L1511` | multiple | `local-label-only` | These are control-flow labels, not routine owners. |
| Table-only symbols such as `DRBFunctionTable`, `ATMFunctionTable`, `DRBMemoryTable`, `SwitchTestTable`, `RealTimeDataTable` | 3402-3504 | `table-or-data-only` | These support owner pages but do not become standalone routine owners. |
| `CalculateSparkAdvance_MM`, `CalculateKnockRetard_MM`, `CalculateNO2Retard_Routine_MM`, `HandleSparkScatter` | existing wiki coverage | `covered-by-owner-page` | Owned by `docs/wiki/tuning/ignition-timing.md`. |
| `LaunchControl_MM`, `CalculateSparkCutandAntiLagRetard_Routine` | existing wiki coverage | `covered-by-owner-page` | Owned by `docs/wiki/tuning/launch-control.md`. |
| `ControlCruiseServo0_MM`, `ControlCruiseServo1_MM`, cruise helper families such as `CruiseIsSwitchedOn` and `ContinueCruise` | existing wiki coverage | `covered-by-owner-page` | Owned by `docs/wiki/tuning/cruise-control.md`. |
| `ControlPTU_MM` and PTU helper families | existing wiki coverage | `covered-by-owner-page` | Owned by `docs/wiki/tuning/ptu-control.md`. |
| `HandleO2Processing_MM`, `ModifyO2FeedbackCountVarToMaintainStoich_MM`, `AdaptiveMemory_DetermineWhichCellApplies_MM`, `AdaptiveMemory_UpdateCellIfRequired_MM`, `HandleAmTimer_MM` | existing wiki coverage | `covered-by-owner-page` | Owned by `docs/wiki/tuning/adaptive-systems.md`. |
| `ConvertWB2NBSignal_MM` | existing wiki coverage | `covered-by-owner-page` | Mentioned from the main-loop and sensor references already in place. |
| `DealWithConfigurationAndPulseAccumulator_MM` | 7408 call site only in current wiki | `insufficient-evidence` | The plan keeps this outside the core path unless the matrix is promoted later. |
| `IncrementLoopCounters_MM` | 7511 | `covered-by-owner-page` | Main-loop housekeeping stays with `docs/wiki/ecu-fundamentals/main-loop.md` unless promoted later. |
| `ThrowCriticalError`, `ThrowNonCriticalError`, `CaculateChecksum`, low-level SCI / PIA transmit stubs | multiple | `future-hardware-page` | Candidate follow-on work if Task 11 still leaves service-path gaps. |
| Commented-out EMR, CCD, and shift-light paths such as `EmmissionMaintenanceRemider1_MM`, `EmmissionMaintenanceRemider2_MM`, `PrepareCCDDataForXmit_MM`, `ControlShiftLight_MM` | 7445-7480 call sites | `covered-by-owner-page` | The commented-out registry already lives in `docs/wiki/ecu-fundamentals/main-loop.md`. |

## See Also

- [ASM-to-Calibration Mapping Reference](asm-cal-mapping.md) - Existing routine-to-calibration cross-reference tables.
- [Main Program Loop](../ecu-fundamentals/main-loop.md) - Current `_MM` call-order registry and commented-out call tracking.
- [Wiki README](../README.md) - Top-level wiki index for reference-page placement.

## Source

- `_reference/T-SMEC_v19.asm:319` - `_MM` convention note.
- `_reference/T-SMEC_v19.asm:1277-9984` - Assigned routine families and helper labels captured in this matrix.
- `.sisyphus/plans/remaining-asm-wiki-expansion.md:37-50` - Deliverable list for the owner pages tracked here.
- `.sisyphus/plans/remaining-asm-wiki-expansion.md:306-741` - Task-level routine-family assignments for Tasks 2-11 and 14.
