# SMEC Main Program Loop

## Overview

`MainProgramLoop` in `T-SMEC_v19.asm` spans lines 7407 through 7529 and defines the recurring foreground loop that runs about once every 11 ms.

This loop performs sensor sampling, state updates, fuel and spark calculations, idle and boost control, fault handling, DRB-II communications, and end-of-loop timing before jumping back to `MainProgramLoop`.

**_MM convention:** Routines ending with `_MM` are called from the MainProgramLoop (see `T-SMEC_v19.asm` line 319).

Related pages:
- [Sensors and Inputs](sensors.md)
- [Fuel System](../tuning/fuel-system.md)
- [Ignition Timing](../tuning/ignition-timing.md)
- [Adaptive Systems](../tuning/adaptive-systems.md)
- [Boost Control](../tuning/boost-control.md)
- [Launch Control](../tuning/launch-control.md)
- [Cruise Control](../tuning/cruise-control.md)
- [PTU Control](../tuning/ptu-control.md)

## Loop Entry, COP Reset, and A2D Sampling

Before the long `_MM` call chain begins, the loop performs a fixed entry sequence.

| ASM lines | Operation | Notes |
|----------|-----------|-------|
| 7408 | `jsr DealWithConfigurationAndPulseAccumulator_MM` | First routine called each pass. |
| 7409-7416 | COP reset handshake | Interrupts are enabled, `0x55aa` is written to `CPU_ArmResetCopTimerReg`, interrupts are disabled again, and the code loops until `CPU_A2DControlReg` indicates conversion complete. |
| 7417-7421 | Battery voltage sample every 4th loop | `Counter_MainLoop & 0x03` gates this. When zero, `CPU_A2DResults2` is copied into `BatteryVolts`. |
| 7422-7427 | A2D results set 3 read, then WB2NB conversion | `CPU_A2DResults3` is copied to `RawAirFuelSensInput` and `TPSVolts_11msUpdate`, then `ConvertWB2NBSignal_MM` is called. |
| 7428-7435 | Timer snapshot and overflow accounting | `CPU_TimerCounterRegHigh` is saved to `Temp0`, then distributor and speedo overflow counting routines are called. |
| 7436-7441 | A2D results set 1 and 4 read | `CPU_A2DResults1` is stored into `RawCoolantTempVolts` and `RawChargeTempVolts`. `CPU_A2DResults4` is stored into `AmbientAirTempVolts`. |
| 7442-7444 | Next A2D phase armed | `CPU_A2DControlReg` is loaded with `#0x10` before the main call sequence continues. |

### A2D Sequence Called Out by the Source

Within lines 7407 through 7530, the battery, TPS, coolant, charge temperature, and ambient air temperature stores are explicit. The MAP/TPS phase of the schedule is represented by the `CPU_A2DResults3` read, but this block only names `RawAirFuelSensInput` and `TPSVolts_11msUpdate` as destination variables.

| Sample point | ASM lines | Result stored |
|-------------|-----------|---------------|
| Battery voltage, every 4th loop | 7417-7421 | `BatteryVolts` from `CPU_A2DResults2` |
| Raw air/fuel sensor and TPS update | 7422-7427 | `RawAirFuelSensInput`, `TPSVolts_11msUpdate` |
| Coolant and charge temperature | 7438-7439 | `RawCoolantTempVolts`, `RawChargeTempVolts` |
| Ambient air temperature | 7440-7441 | `AmbientAirTempVolts` |

## Complete Main Loop Call Sequence

The table below preserves the exact `jsr` order used by `MainProgramLoop`. Commented-out calls are included in their original position.

| Seq | ASM line | Routine | Group | Status |
|-----|----------|---------|-------|--------|
| 1 | 7408 | `DealWithConfigurationAndPulseAccumulator_MM` | Configuration | Active |
| 2 | 7426 | `ConvertWB2NBSignal_MM` | Sensor / WB2NB | Active |
| 3 | 7433 | `DetermineNumberOfOverflowsBetweenDistributorPulses_MM` | Timing / RPM input | Active |
| 4 | 7435 | `DetermineNumberOfOverflowsBetweenSpeedoPulses_MM` | Timing / speed input | Active |
| 5 | 7445 | `EmmissionMaintenanceRemider1_MM` | Service reminder | Commented out |
| 6 | 7446 | `EmmissionMaintenanceRemider2_MM` | Service reminder | Commented out |
| 7 | 7447 | `CycleACClutch_MM` | A/C | Active |
| 8 | 7448 | `DetermineIfWindowedBladeInSyncSensorOnDistributor_MM` | Distributor sync | Active |
| 9 | 7449 | `CheckThrottleRoutine_MM` | Throttle input | Active |
| 10 | 7450 | `CheckAndFilterCoolantAndChargeTempSensors_MM` | Temperature input | Active |
| 11 | 7451 | `HandleBaroReadRequirement_MM` | Baro input | Active |
| 12 | 7452 | `CalculateInjectorPulsewidthForStarting_MM` | Fuel | Active |
| 13 | 7453 | `DetectParkNeutral_MM` | Transmission state | Active |
| 14 | 7454 | `CALCULATE_RPM_SPEED_AND` | RPM / vehicle speed | Active |
| 15 | 7455 | `ControlAsdRelay_MM` | Power / ASD | Active |
| 16 | 7456 | `CalculateSparkAdvance_MM` | Spark | Active |
| 17 | 7457 | `ControlCruiseServo0_MM` | Cruise control | Active |
| 18 | 7458 | `ControlCruiseServo1_MM` | Cruise control | Active |
| 19 | 7459 | `PrepareCCDDataForXmit_MM` | CCD communications | Commented out |
| 20 | 7460 | `KickUpAisBy2DuringDecel_MM` | Idle | Active |
| 21 | 7461 | `CalculateTargetIdleSpeedAndAisPosition_MM` | Idle | Active |
| 22 | 7462 | `CalculateAisPosition_MM` | Idle | Active |
| 23 | 7463 | `CalculatePartThrottleEnrichmentAndSparkScatterFuel_MM` | Fuel / idle spark scatter | Active |
| 24 | 7464 | `HandleAmTimer_MM` | Adaptive memory | Active |
| 25 | 7465 | `HandleO2Processing_MM` | O2 feedback | Active |
| 26 | 7466 | `ModifyO2FeedbackCountVarToMaintainStoich_MM` | O2 feedback | Active |
| 27 | 7467 | `AdaptiveMemory_DetermineWhichCellApplies_MM` | Adaptive memory | Active |
| 28 | 7468 | `AdaptiveMemory_UpdateCellIfRequired_MM` | Adaptive memory | Active |
| 29 | 7469 | `DealWithSpecialIdle_SetBasicTiming_MM` | Idle / spark | Active |
| 30 | 7470 | `ControlEngineCutout_MM` | Engine protection | Active |
| 31 | 7471 | `LaunchControl_MM` | Launch control | Active |
| 32 | 7472 | `CalculatePartThrottleTransientFuel_MM` | Fuel | Active |
| 33 | 7473 | `CalculateSumOfAllFuelModifiers_MM` | Fuel | Active |
| 34 | 7474 | `ControlPurgeSolenoid_MM` | Emissions / purge | Active |
| 35 | 7475 | `ControlFan_MM` | Cooling fan | Active |
| 36 | 7476 | `ControlAirConditioning_MM` | A/C | Active |
| 37 | 7477 | `CalculateKnockRetard_MM` | Spark / knock | Active |
| 38 | 7478 | `ControlPTU_MM` | PTU / transmission | Active |
| 39 | 7479 | `UseCELForKnockIndication_MM` | Knock indication | Active |
| 40 | 7480 | `ControlShiftLight_MM` | Shift light | Commented out |
| 41 | 7481 | `CalculateNO2Retard_Routine_MM` | Spark retard | Active |
| 42 | 7482 | `CalcTargetBoost_MM` | Boost | Active |
| 43 | 7483 | `CalcWGDutyCycle_MM` | Boost | Active |
| 44 | 7484 | `GetControlFeedback_DetermineIfShutdownRequired_MM` | Control feedback / shutdown | Active |
| 45 | 7485 | `VerifyOperationOfBatteryVoltage_MM` | Diagnostics | Active |
| 46 | 7486 | `DetectAlternatorFault_MM` | Diagnostics | Active |
| 47 | 7487 | `CheckForErrorsAndSetCodes_MM` | Diagnostics | Active |
| 48 | 7488 | `VerifyOperationOfASDRelayAndO2Sensor_MM` | Diagnostics | Active |
| 49 | 7489 | `VerifyOperationOfIgnitionCoilDriver_MM` | Diagnostics | Active |
| 50 | 7490 | `VerifyOperationOfFuelInjectorDrivers_MM` | Diagnostics | Active |
| 51 | 7491 | `VerifyOperationOfIgnitionCoilDriver2_MM` | Diagnostics | Active |
| 52 | 7492 | `VerifyOperationOfMapSensor_MM` | Diagnostics | Active |
| 53 | 7493 | `VerifyOperationOfThermostat_MM` | Diagnostics | Active |
| 54 | 7501 | `DetermineTargetBatteryVoltage_MM` | Charging control | Active |
| 55 | 7502 | `ExhGasRecirc_MM` | EGR | Active |
| 56 | 7503 | `ThrowMajorErrorIfRequired_MM` | Error handling | Active |
| 57 | 7504 | `ProcessErrorBits_WorkWithData_MM` | Error handling | Active |
| 58 | 7505 | `UpdateErrorTimersAndPossiblyClearErrors_MM` | Error handling | Active |
| 59 | 7506 | `CheckIfCheckEngineLightShouldBeOn_MM` | CEL control | Active |
| 60 | 7507 | `DRBIISerialCommunications_MM` | DRB-II communications | Active |
| 61 | 7508 | `DRBIIOuput_MM` | DRB-II communications | Active |
| 62 | 7509 | `ActuatorTestMode_MM` | DRB-II / service mode | Active |
| 63 | 7510 | `DRB_UpdatePIA1AndCheckOuputs_MM` | DRB-II / outputs | Active |
| 64 | 7511 | `IncrementLoopCounters_MM` | Loop housekeeping | Active |

## Logical Grouping of the Loop

### Sensors and State Inputs

After COP reset and A2D sampling, the loop establishes current operating state by processing throttle, temperatures, baro needs, park/neutral state, RPM, and vehicle speed.

| ASM lines | Routines |
|----------|----------|
| 7426-7435 | `ConvertWB2NBSignal_MM`, `DetermineNumberOfOverflowsBetweenDistributorPulses_MM`, `DetermineNumberOfOverflowsBetweenSpeedoPulses_MM` |
| 7447-7455 | `CycleACClutch_MM`, `DetermineIfWindowedBladeInSyncSensorOnDistributor_MM`, `CheckThrottleRoutine_MM`, `CheckAndFilterCoolantAndChargeTempSensors_MM`, `HandleBaroReadRequirement_MM`, `CalculateInjectorPulsewidthForStarting_MM`, `DetectParkNeutral_MM`, `CALCULATE_RPM_SPEED_AND`, `ControlAsdRelay_MM` |

### Spark, Idle, and Fuel Processing

This is the densest section of the loop. Spark advance, idle control, O2 feedback, adaptive memory, launch control, transient fuel, and fuel modifier summation all happen here.

| ASM lines | Routines |
|----------|----------|
| 7456-7473 | `CalculateSparkAdvance_MM`, `ControlCruiseServo0_MM`, `ControlCruiseServo1_MM`, `KickUpAisBy2DuringDecel_MM`, `CalculateTargetIdleSpeedAndAisPosition_MM`, `CalculateAisPosition_MM`, `CalculatePartThrottleEnrichmentAndSparkScatterFuel_MM`, `HandleAmTimer_MM`, `HandleO2Processing_MM`, `ModifyO2FeedbackCountVarToMaintainStoich_MM`, `AdaptiveMemory_DetermineWhichCellApplies_MM`, `AdaptiveMemory_UpdateCellIfRequired_MM`, `DealWithSpecialIdle_SetBasicTiming_MM`, `ControlEngineCutout_MM`, `LaunchControl_MM`, `CalculatePartThrottleTransientFuel_MM`, `CalculateSumOfAllFuelModifiers_MM` |

For the tuning concepts behind these routines, see [Fuel System](../tuning/fuel-system.md), [Ignition Timing](../tuning/ignition-timing.md), [Adaptive Systems](../tuning/adaptive-systems.md), and [Launch Control](../tuning/launch-control.md).

### Outputs, Torque Management, and Boost

This section controls purge, fan, air conditioning, knock indication, PTU behavior, NO2 retard, target boost, and wastegate duty cycle.

| ASM lines | Routines |
|----------|----------|
| 7474-7484 | `ControlPurgeSolenoid_MM`, `ControlFan_MM`, `ControlAirConditioning_MM`, `CalculateKnockRetard_MM`, `ControlPTU_MM`, `UseCELForKnockIndication_MM`, `CalculateNO2Retard_Routine_MM`, `CalcTargetBoost_MM`, `CalcWGDutyCycle_MM`, `GetControlFeedback_DetermineIfShutdownRequired_MM` |

See [Boost Control](../tuning/boost-control.md) and [PTU Control](../tuning/ptu-control.md).

### Diagnostics, Error Processing, and Service Communications

The loop ends with a long diagnostic and service block. It verifies subsystem operation, updates error state, controls the check engine lamp, services DRB-II communications, and increments loop counters.

| ASM lines | Routines |
|----------|----------|
| 7485-7511 | `VerifyOperationOfBatteryVoltage_MM`, `DetectAlternatorFault_MM`, `CheckForErrorsAndSetCodes_MM`, `VerifyOperationOfASDRelayAndO2Sensor_MM`, `VerifyOperationOfIgnitionCoilDriver_MM`, `VerifyOperationOfFuelInjectorDrivers_MM`, `VerifyOperationOfIgnitionCoilDriver2_MM`, `VerifyOperationOfMapSensor_MM`, `VerifyOperationOfThermostat_MM`, `DetermineTargetBatteryVoltage_MM`, `ExhGasRecirc_MM`, `ThrowMajorErrorIfRequired_MM`, `ProcessErrorBits_WorkWithData_MM`, `UpdateErrorTimersAndPossiblyClearErrors_MM`, `CheckIfCheckEngineLightShouldBeOn_MM`, `DRBIISerialCommunications_MM`, `DRBIIOuput_MM`, `ActuatorTestMode_MM`, `DRB_UpdatePIA1AndCheckOuputs_MM`, `IncrementLoopCounters_MM` |

### Commented-Out Calls in the Main Loop

Four call sites are present in the source but disabled with leading semicolons:

| ASM line | Routine | Note |
|----------|---------|------|
| 7445 | `EmmissionMaintenanceRemider1_MM` | Commented out in the source. |
| 7446 | `EmmissionMaintenanceRemider2_MM` | Commented out in the source. The line also includes `RestoreSavedConfiguration2_MM` in the comment text. |
| 7459 | `PrepareCCDDataForXmit_MM` | Commented out in the source. |
| 7480 | `ControlShiftLight_MM` | Commented out in the source. |

## End-of-Loop Timing

At the end of the active call chain, the loop enforces its cadence before jumping back to `MainProgramLoop`.

| ASM lines | Operation | Notes |
|----------|-----------|-------|
| 7512-7513 | Load current minimum timer target | `MinimumTimerCountBeforeMainloopCanContinue` is copied into `Temp0`. |
| 7514-7519 | Read timer and normalize | `CPU_TimerCounterRegHigh` is read with interrupts disabled, then `asld` runs twice. |
| 7520-7523 | Add wait increment | The source comment states `0x2b = 43d/4 = 10.75mSec`. This updated target is written back to `MinimumTimerCountBeforeMainloopCanContinue`. |
| 7524-7528 | Busy-wait until target reached | The timer is repeatedly read and compared until the scheduled count arrives. |
| 7529 | `jmp MainProgramLoop` | Starts the next cycle. |

### Timing Math

| Value | Meaning |
|-------|---------|
| `0x2b` | 43 decimal |
| `43 / 4` | 10.75 ms |
| Result | The loop waits until about 10.75 ms have elapsed, which is the source of the commonly cited ~11 ms main loop period. |

## ASM Implementation

The table below captures each `jsr` site in the order it appears in `MainProgramLoop`, with a short description based only on the routine name and surrounding instructions.

| Routine name | ASM line | Key behaviors |
|--------------|----------|---------------|
| `DealWithConfigurationAndPulseAccumulator_MM` | 7408 | First call in the loop. Handles configuration and pulse accumulator work before COP reset and sampling. |
| `ConvertWB2NBSignal_MM` | 7426 | Runs immediately after `RawAirFuelSensInput` and `TPSVolts_11msUpdate` are loaded from A2D results. |
| `DetermineNumberOfOverflowsBetweenDistributorPulses_MM` | 7433 | Uses the timer snapshot in `Temp0` to account for distributor pulse interval overflow state. |
| `DetermineNumberOfOverflowsBetweenSpeedoPulses_MM` | 7435 | Uses the same timer snapshot for speedometer pulse interval overflow state. |
| `EmmissionMaintenanceRemider1_MM` | 7445 | Present as a commented-out `jsr`. Not executed. |
| `EmmissionMaintenanceRemider2_MM` | 7446 | Present as a commented-out `jsr`. Not executed. |
| `CycleACClutch_MM` | 7447 | Starts the active `_MM` block after the A2D sampling setup. |
| `DetermineIfWindowedBladeInSyncSensorOnDistributor_MM` | 7448 | Distributor sync state check. |
| `CheckThrottleRoutine_MM` | 7449 | Throttle state handling. |
| `CheckAndFilterCoolantAndChargeTempSensors_MM` | 7450 | Coolant and charge temperature sensor filtering routine. The routine definition starts at line 7531 and notes it only runs every ~80 ms. |
| `HandleBaroReadRequirement_MM` | 7451 | Handles barometric read requirements. |
| `CalculateInjectorPulsewidthForStarting_MM` | 7452 | Starting fuel pulsewidth calculation. |
| `DetectParkNeutral_MM` | 7453 | Park/neutral state detection. |
| `CALCULATE_RPM_SPEED_AND` | 7454 | RPM and vehicle speed calculation routine. |
| `ControlAsdRelay_MM` | 7455 | ASD relay control. |
| `CalculateSparkAdvance_MM` | 7456 | Main spark advance calculation. See [Ignition Timing](../tuning/ignition-timing.md). |
| `ControlCruiseServo0_MM` | 7457 | First cruise servo control step. See [Cruise Control](../tuning/cruise-control.md). |
| `ControlCruiseServo1_MM` | 7458 | Second cruise servo control step. See [Cruise Control](../tuning/cruise-control.md). |
| `PrepareCCDDataForXmit_MM` | 7459 | Present as a commented-out `jsr`. Not executed. |
| `KickUpAisBy2DuringDecel_MM` | 7460 | Idle speed motor adjustment during decel. |
| `CalculateTargetIdleSpeedAndAisPosition_MM` | 7461 | Calculates target idle speed and AIS position. |
| `CalculateAisPosition_MM` | 7462 | Calculates AIS position. |
| `CalculatePartThrottleEnrichmentAndSparkScatterFuel_MM` | 7463 | Part-throttle enrichment and spark scatter fuel handling. See [Fuel System](../tuning/fuel-system.md) and [Ignition Timing](../tuning/ignition-timing.md). |
| `HandleAmTimer_MM` | 7464 | Adaptive memory timer handling. See [Adaptive Systems](../tuning/adaptive-systems.md). |
| `HandleO2Processing_MM` | 7465 | O2 processing step. See [Adaptive Systems](../tuning/adaptive-systems.md). |
| `ModifyO2FeedbackCountVarToMaintainStoich_MM` | 7466 | Updates O2 feedback count toward stoichiometric control. See [Adaptive Systems](../tuning/adaptive-systems.md). |
| `AdaptiveMemory_DetermineWhichCellApplies_MM` | 7467 | Selects the active adaptive memory cell. See [Adaptive Systems](../tuning/adaptive-systems.md). |
| `AdaptiveMemory_UpdateCellIfRequired_MM` | 7468 | Updates the adaptive cell when required. See [Adaptive Systems](../tuning/adaptive-systems.md). |
| `DealWithSpecialIdle_SetBasicTiming_MM` | 7469 | Special idle handling and basic timing setup. |
| `ControlEngineCutout_MM` | 7470 | Engine cutout control. |
| `LaunchControl_MM` | 7471 | Launch control processing. See [Launch Control](../tuning/launch-control.md). |
| `CalculatePartThrottleTransientFuel_MM` | 7472 | Part-throttle transient fuel calculation. See [Fuel System](../tuning/fuel-system.md). |
| `CalculateSumOfAllFuelModifiers_MM` | 7473 | Combines fuel modifiers. See [Fuel System](../tuning/fuel-system.md). |
| `ControlPurgeSolenoid_MM` | 7474 | Purge solenoid control. |
| `ControlFan_MM` | 7475 | Cooling fan control. |
| `ControlAirConditioning_MM` | 7476 | Air conditioning control. |
| `CalculateKnockRetard_MM` | 7477 | Knock retard calculation. See [Ignition Timing](../tuning/ignition-timing.md). |
| `ControlPTU_MM` | 7478 | PTU control step. See [PTU Control](../tuning/ptu-control.md). |
| `UseCELForKnockIndication_MM` | 7479 | Uses the check engine light as a knock indication output. |
| `ControlShiftLight_MM` | 7480 | Present as a commented-out `jsr`. Not executed. |
| `CalculateNO2Retard_Routine_MM` | 7481 | NO2 retard calculation routine. |
| `CalcTargetBoost_MM` | 7482 | Determines target boost. See [Boost Control](../tuning/boost-control.md). |
| `CalcWGDutyCycle_MM` | 7483 | Calculates wastegate duty cycle. See [Boost Control](../tuning/boost-control.md). |
| `GetControlFeedback_DetermineIfShutdownRequired_MM` | 7484 | Control feedback processing, with shutdown determination. |
| `VerifyOperationOfBatteryVoltage_MM` | 7485 | Battery voltage diagnostic verification. |
| `DetectAlternatorFault_MM` | 7486 | Alternator fault detection. |
| `CheckForErrorsAndSetCodes_MM` | 7487 | Error check and code-setting routine. |
| `VerifyOperationOfASDRelayAndO2Sensor_MM` | 7488 | Diagnostic check for ASD relay and O2 sensor. |
| `VerifyOperationOfIgnitionCoilDriver_MM` | 7489 | Ignition coil driver diagnostic verification. |
| `VerifyOperationOfFuelInjectorDrivers_MM` | 7490 | Fuel injector driver diagnostic verification. |
| `VerifyOperationOfIgnitionCoilDriver2_MM` | 7491 | Secondary ignition coil driver diagnostic verification. |
| `VerifyOperationOfMapSensor_MM` | 7492 | MAP sensor diagnostic verification. |
| `VerifyOperationOfThermostat_MM` | 7493 | Thermostat diagnostic verification. |
| `DetermineTargetBatteryVoltage_MM` | 7501 | Runs after the conditional PIA2 bit 6 check and `0xaaa5` RAM write at lines 7494-7500. Determines target battery voltage. |
| `ExhGasRecirc_MM` | 7502 | Exhaust gas recirculation control. |
| `ThrowMajorErrorIfRequired_MM` | 7503 | Raises a major error when required. |
| `ProcessErrorBits_WorkWithData_MM` | 7504 | Processes error bits and associated data. |
| `UpdateErrorTimersAndPossiblyClearErrors_MM` | 7505 | Updates error timers and clears errors when conditions allow. |
| `CheckIfCheckEngineLightShouldBeOn_MM` | 7506 | Decides whether the check engine light should be on. |
| `DRBIISerialCommunications_MM` | 7507 | DRB-II serial communications handler. |
| `DRBIIOuput_MM` | 7508 | DRB-II output routine. |
| `ActuatorTestMode_MM` | 7509 | Actuator test mode handling. |
| `DRB_UpdatePIA1AndCheckOuputs_MM` | 7510 | Updates PIA1 and checks outputs for DRB-related service work. |
| `IncrementLoopCounters_MM` | 7511 | Final routine in the loop. Increments loop counters before the 10.75 ms wait scheduling. |
