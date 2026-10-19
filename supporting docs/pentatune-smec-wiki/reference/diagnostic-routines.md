# Diagnostic Routines Reference

Reference for the main verification and error-handling block in `T-SMEC_v19.asm`. This page covers how the ECU processes pending error bits, decides when the check engine light should be on, escalates major faults, and verifies a small set of hardware circuits. For the user-facing code list, see [Fault Codes](fault-codes.md). For DRB-II procedures and actuator-test context, see [DRB-II Diagnostics](../hardware/diagnostics.md).

Routines ending with `_MM` are called from the MainProgramLoop. Line references below use the frozen local source file, `_reference/T-SMEC_v19.asm`.

## Error Processing

### `ProcessErrorBits_WorkWithData_MM` (lines 4464-4504)

This routine walks the pending bits in `BitFlags_47`, uses `ErrorBitManipulation_Table` to look up the per-bit handling data, clears each processed bit with interrupts briefly disabled, and calls `ThrowNonCriticalError` for the selected entry. The loop then continues until no more pending bits remain.

The table entry can also request an additional IPL flag update in `b45_IPL1`. That makes this routine the bridge between raw pending flags and the latched diagnostic state that later routines use for [Fault Codes](fault-codes.md) and check engine light decisions.

### `VerifyOperationOfBatteryVoltage_MM` (lines 4528-4547)

This page keeps `VerifyOperationOfBatteryVoltage_MM` only as a cross-reference to [Charging System](../hardware/charging-system.md). The routine checks for low battery voltage after the engine is running, waits for a mature key-on timer, throws non-critical error `0x2290`, sets `b45_Bad_BatVolts`, and later clears the fault through `ResetErrorCodeIfTimerExpired` when voltage recovers.

Battery-voltage thresholds, charging behavior, and ownership of codes [46 and 47](fault-codes.md) belong on [Charging System](../hardware/charging-system.md). Use this page only to place the routine in the diagnostic flow.

### `CheckIfCheckEngineLightShouldBeOn_MM` (lines 4549-4590)

This routine decides whether the CEL output bit in `PIA1_A_Buffer` should be set on the current loop. The logic splits into two broad modes.

- **Engine not running:** `DRBPointer1 == 0x0A` jumps to `FlashCodesOutOnCEL`, `DRBPointer1 == 0x18` blinks the lamp from `Counter_MainLoop`, and the first key-on interval also forces the lamp on.
- **Engine running:** the routine checks the stored IPL registers, masks out power-loss-only states, applies a special case when EGR is not configured, and leaves the lamp on when a qualifying fault remains latched.

Read this routine together with [Fault Codes](fault-codes.md), because the lamp logic is driven by the same latched error bits. For service usage, pair it with [DRB-II Diagnostics](../hardware/diagnostics.md), especially the key-flash and scanner sections.

### `UpdateErrorTimersAndPossiblyClearErrors_MM` (lines 4592-4636)

This routine provides the decay and housekeeping side of diagnostics.

- Once per `Counter_MainLoop == 0`, it decrements the two clear timers tied to `ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB/LB` and clears the corresponding byte when its timer expires.
- It counts down `ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR` in `0x10` steps, which is the shared timer used by `ResetErrorCodeIfTimerExpired`.
- When the engine transitions into the running state, it sets `b54_NeedSetup`, updates `ErrorCodeUpdateKeyOnCount`, and erases stored error codes after the 50 key-on limit if EEPROM is idle.

That makes this routine the cleanup path for transient faults, not the detector itself. The actual detectors live below in the component-verification section.

### `DetectAlternatorFault_MM` (lines 4638-4666)

This page keeps `DetectAlternatorFault_MM` only as a cross-reference to [Charging System](../hardware/charging-system.md). The routine runs every 32 main-loop ticks, compares `BatteryVolts` to `TargetBatteryVolts`, uses RPM gating, throws `0x0555` for low-charge behavior and `0x06A0` for high-charge behavior, and latches `b45_BattNotCharging`.

Alternator-field thresholds, regulator behavior, and ownership of charging diagnostics belong on [Charging System](../hardware/charging-system.md). Here it is included only so the diagnostic chain is complete.

## Code Setting and Escalation

### `CheckForErrorsAndSetCodes_MM` (lines 4668-4700)

This routine is the gatekeeper for turning already-detected problems into a major fault state. It refuses to act unless all of these conditions are true:

- the engine is running
- coolant temperature is at least `ERRTMP_CoolantTempLimitforErrorCodeSetting`
- ATX cars are in gear when `cfg_ATX` is set
- key-on or engine-running time has matured to the 11-second threshold
- the brake switch is not active
- the engine is off idle
- RPM is at least `ERRRPM_RPMLimitforErrorCodeSetting`
- MAP indicates a light-load condition below `ERRMAP_MAPLimitforErrorCodeSetting`
- vehicle speed is below `0x002A`

Once those gates pass, it throws critical error `0x2320` and, on success, sets `b46_MajorFault`. The routine reads like a fault-confirmation filter, built to avoid setting a major code during startup, braking, or obviously non-diagnostic operating states.

### `ThrowMajorErrorIfRequired_MM` (lines 4702-4718)

This routine converts a narrow set of already-latched conditions into `b46_MajorFault`.

- If `cfg_EGR` is enabled, stored error register 3 equals `0x19`, and `b47_AisFail` is set, it throws critical error `0x1920`.
- Independently, if `b50_BadO2` is set, it also forces the major-fault path.
- If EGR is not configured, it clears `b46_bit7 | b46_MajorFault` instead.

The evidence in the ASM supports a simple reading: this routine is a late escalation stage, not a general detector. It depends on work done earlier by the sensor and actuator verification routines, especially the O2 path documented under `VerifyOperationOfASDRelayAndO2Sensor_MM` below.

## Component Verification

### `VerifyOperationOfIgnitionCoilDriver_MM` (lines 4720-4742)

This routine verifies the primary ignition-coil driver only after key-on delay has expired and battery voltage is high enough. It compares the commanded ignition-coil output bit with the coil-driver sense bit, requires the mismatch to survive a 4-loop cadence check, and throws non-critical error `0x0910` when the sense path does not follow the command.

This is the firmware-side basis for [fault code 43](fault-codes.md). For bench confirmation, pair it with the ignition-coil actuator test in [DRB-II Diagnostics](../hardware/diagnostics.md#actuator-test-mode-atm).

### `VerifyOperationOfFuelInjectorDrivers_MM` (lines 4744-4783)

This routine checks the injector driver sense path, but only in a narrow window where voltage is high, the B1 supply switch says the injector feed is present, timer control does not block the check, and exactly one injector bank is being commanded. It then requires an on-time of at least `0x02EE`, about 0.75 ms, and a valid injector-driver sense response.

If the driver sense does not match the commanded bank, the ECU throws non-critical error `0x1790` for one bank or `0x1890` for the other, then latches `b46_InjectorFault`. That supports the injector-driver side of [fault codes 26 and 27](fault-codes.md).

### `VerifyOperationOfMapSensor_MM` (lines 4830-4912)

This routine covers two different MAP checks.

1. **Stuck or implausible pneumatic behavior:** under low-speed, near-idle conditions, it compares baro to MAP and uses `MPVACD_AllowMapToTestGoodThisNearBaro` plus `BAROSW_CheckMapAtZeroSpeedAndThisBaroSwitch` to decide whether the reading is close enough to barometric pressure. If not, it throws non-critical error `0x2794` and sets `b45_MapStuck`.
2. **Electrical range check:** below the RPM and throttle gating thresholds, it compares raw ADC input to `MAPHIG_MapSensorUpperLimit` and `MAPLOW_MapSensorLowerLimit`. Values below range lead to `0x2494`, values above range lead to `0x2594`, and both latch `b45_MapBadSignal`.

When the signal recovers, the routine uses `ResetErrorCodeIfTimerExpired` at lines 4886-4912 to clear the bad-signal path after the shared timer expires. This routine is the key source for [fault codes 13 and 14](fault-codes.md), and it lines up with the practical MAP checks in [DRB-II Diagnostics](../hardware/diagnostics.md).

### `VerifyOperationOfThermostat_MM` (lines 4965-4990)

This routine implements the running-too-cool check. It only runs with the engine operating, a valid coolant sensor, and a non-zero `Timer_ThermostatDiagnostics`. Once per main-loop rollover, it compares coolant temperature to `TDAGTP_TstatDiagnosticsTemperatureGoalWithin_HOTIME`, checks that vehicle speed is at least `0x07`, increments the thermostat timer, and throws non-critical error `0x2101` if the engine still has not reached the target temperature by `HOTIME_TstatDiagnosticsTimeToAchieveTemperatureGoal`.

This is the firmware basis for [fault code 17](fault-codes.md). The routine only supports the high-level claim that the ECU looks for a warmup failure over time. It does not prove any deeper thermostat model than that.

### `VerifyOperationOfASDRelayAndO2Sensor_MM` (lines 4992-5031)

This routine merges two checks.

- **ASD relay path:** every fourth loop after key-on delay, if the distributor-overflow timer is zero and the B1 voltage switch is clear, it throws non-critical error `0x2C14`. That is the ASD-side failure path associated with [fault code 42](fault-codes.md).
- **O2 middle-band path:** every 128 loops, once coolant and RPM are high enough, it watches for an O2 value stuck between `O2MIDL_LowLimitForInMiddleDetermination` and `O2MIDH_HighLimitForInMiddleDetermination`. If the condition persists until `Timer_O2MiddleDiagnostics` reaches `0x56`, it throws critical error `0x2001` and sets `b50_BadO2`.

That O2 flag later feeds `ThrowMajorErrorIfRequired_MM`, so this routine is both a detector and an escalation input. Read it with [Fault Codes](fault-codes.md) for code semantics and with [DRB-II Diagnostics](../hardware/diagnostics.md) for field-test context.

### `VerifyOperationOfIgnitionCoilDriver2_MM` (lines 5087-5122)

This second ignition-coil diagnostic does not reuse the same sense-path logic as `VerifyOperationOfIgnitionCoilDriver_MM`. Instead, once engine speed is present, it tracks distributor-sync transitions in `BitFlags_53`, waits for a 16-loop cadence, applies a battery-voltage window bounded by `0x41` and `COILHI_HiLimitBatteryVoltsForCoilVerify`, and then compares `MapValue` against `MapVolts` with `COILLO_LoLimitBatteryVoltsForCoilVerify` as the minimum delta.

If those conditions hold, it throws non-critical error `0x2814`. The source supports calling this a second, independent ignition-coil verification path, but not a stronger claim about the exact hardware failure mode. Use [DRB-II Diagnostics](../hardware/diagnostics.md) for hands-on coil checks and [Fault Codes](fault-codes.md) for the user-visible code mapping.

## See Also

- [Fault Codes](fault-codes.md): complete code list, error-bit registers, and code-to-system mapping
- [DRB-II Diagnostics](../hardware/diagnostics.md): scanner commands, actuator tests, and practical diagnostic workflows
- [ASM-to-Calibration Mapping Reference](asm-cal-mapping.md): higher-level diagnostics section that links routine families to calibration data
- [Sensor Processing and Derived State](../ecu-fundamentals/sensor-processing.md): owner page for the baro, TPS, and temperature inputs that feed several verification paths
- [Engine State and Emissions Control](../tuning/engine-state-and-emissions.md): ASD relay, purge, and EGR state that intersect with later diagnostic checks
- [Charging System](../hardware/charging-system.md): canonical owner for battery-voltage and alternator-specific internals

## Source

- `_reference/T-SMEC_v19.asm` lines 4464-4504 (`ProcessErrorBits_WorkWithData_MM`)
- `_reference/T-SMEC_v19.asm` lines 4528-4547 (`VerifyOperationOfBatteryVoltage_MM`)
- `_reference/T-SMEC_v19.asm` lines 4549-4590 (`CheckIfCheckEngineLightShouldBeOn_MM`)
- `_reference/T-SMEC_v19.asm` lines 4592-4636 (`UpdateErrorTimersAndPossiblyClearErrors_MM`)
- `_reference/T-SMEC_v19.asm` lines 4638-4666 (`DetectAlternatorFault_MM`)
- `_reference/T-SMEC_v19.asm` lines 4668-4700 (`CheckForErrorsAndSetCodes_MM`)
- `_reference/T-SMEC_v19.asm` lines 4702-4718 (`ThrowMajorErrorIfRequired_MM`)
- `_reference/T-SMEC_v19.asm` lines 4720-4742 (`VerifyOperationOfIgnitionCoilDriver_MM`)
- `_reference/T-SMEC_v19.asm` lines 4744-4783 (`VerifyOperationOfFuelInjectorDrivers_MM`)
- `_reference/T-SMEC_v19.asm` lines 4830-4912 (`VerifyOperationOfMapSensor_MM`, includes `ResetErrorCodeIfTimerExpired`)
- `_reference/T-SMEC_v19.asm` lines 4965-4990 (`VerifyOperationOfThermostat_MM`)
- `_reference/T-SMEC_v19.asm` lines 4992-5031 (`VerifyOperationOfASDRelayAndO2Sensor_MM`)
- `_reference/T-SMEC_v19.asm` lines 5087-5122 (`VerifyOperationOfIgnitionCoilDriver2_MM`)
