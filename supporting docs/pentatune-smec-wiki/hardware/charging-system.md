# Charging System

## Overview

This page documents the SMEC charging-system control path that drives the alternator field output, computes a target battery-voltage value, and raises charging-related diagnostic flags. The documented owner routines are `ControlAlternator` at `T-SMEC_v19.asm:1277`, `TurnAlternatorOn` at `T-SMEC_v19.asm:1326`, `TurnAlternatorOff` at `T-SMEC_v19.asm:1339`, `DetermineTargetBatteryVoltage_MM` at `T-SMEC_v19.asm:1637`, `VerifyOperationOfBatteryVoltage_MM` at `T-SMEC_v19.asm:4528`, and `DetectAlternatorFault_MM` at `T-SMEC_v19.asm:4638`.

The ASM shows a simple closed-loop scheme. `DetermineTargetBatteryVoltage_MM` updates `TargetBatteryVolts`, `ControlAlternator` compares the live `BatteryVolts` reading against that target, and the two later diagnostic routines decide whether to log low-voltage or charging-fault conditions. Generic sensor scaling stays with [Sensors and Inputs](../ecu-fundamentals/sensors.md).

## Electrical Overview

The hardware-facing output bit is `pia2b_AlternatorField` in `PIA2_PortB_DataDirection`. `TurnAlternatorOn` sets that bit, and `TurnAlternatorOff` clears it. In this firmware, alternator control is not a separate PWM peripheral. The main-loop code gates the field by looking at RPM, battery-voltage error, a duty-cycle timer, and a small fault-history byte.

Two details in the source matter for bench work:

- `ControlAlternator` exits through `TurnAlternatorOff` whenever `b54_FuelEngineNotRunning` is set, so the field is disabled with the engine stopped.
- The routine also refuses to drive the field below an RPM threshold chosen from two literals, `0x11` or `0x15`, depending on the temporary `b56_BadASD` state at `T-SMEC_v19.asm:1285-1291`.

## Field Control

### `ControlAlternator`, `TurnAlternatorOn`, and `TurnAlternatorOff`

`ControlAlternator` starts by checking `ATMOffset`. If the DRB actuator-test selection is `0x0d` or `0x14`, it jumps straight to the field-on exit path at `TurnAlternatorOn`, which makes the alternator driver available to the diagnostic harness without running the normal control math.

Outside actuator test mode, the routine does this work:

1. Select an RPM cutoff, `0x11` or `0x15`, then turn the field off if `EngineRpm_HB` is still below that threshold.
2. Read `CPU_A2DResults2` and copy it into `BatteryVolts` only when the new sample is greater than or equal to the stored value.
3. If the reading is below `0x41`, use `Counter_MainLoop` bits `0x06` to blank some field-on attempts.
4. Compare the measured voltage against `TargetBatteryVolts`.
5. Use `Timer_AlternatorDutyCycle` with masks `0x0e` and `0x06` to decide whether this pass should set or clear `pia2b_AlternatorField`.

The control law is narrow-band rather than fully proportional. When `BatteryVolts` equals `TargetBatteryVolts`, the routine toggles toward the opposite state of the current field bit. When the error is more than two counts away from target, it commits hard to either `TurnAlternatorOn` or `TurnAlternatorOff`. When the error is one or two counts, it uses `Timer_AlternatorDutyCycle` as a coarse duty gate.

### Field-driver fault history

Lines `1330-1338` watch `BitFlags_56 & b56_AlternatorBits` when `pia2b_AlternatorField` and `pia2b_bit2` are both set. Once both alternator-history bits are set, the routine clears those bits, sets `b47_Alternator`, and then forces the field off. If the two-bit pattern has not saturated yet, the code increments `BitFlags_56` instead.

The source proves that this is a field-driver fault history path. It does not name the external electrical failure with certainty, so the safest wording is that repeated bad alternator state transitions can set the `b47_Alternator` fault bit and shut the field off.

## Target Voltage

### `DetermineTargetBatteryVoltage_MM`

`DetermineTargetBatteryVoltage_MM` uses `AmbientAirTempVolts` as the main input for target selection. Values below `AMBLOW_BattTempLowWhenHot` or above `AMBHIG_BattTempHighWhenCold` are treated as an ambient-temperature sensor fault. In that fault path, the routine periodically throws non-critical error `0x0208` and loads a fixed fallback target byte, `0xe8`, before storing `TargetBatteryVolts`.

When the ambient reading is valid and `CPU_EEPROMControlReg` is clear, the routine multiplies the ambient reading by `0x20`, adds `0xd1`, and clamps the result into the `0xd8` to `0xec` range before storing it in `Temp0`. That temporary value is then adjusted again through `LB7E1` and `CCDBTV_CCDBatteryVoltsOutput`, and the final byte is written to `TargetBatteryVolts` at `T-SMEC_v19.asm:1682`.

The exact engineering-unit conversion is not visible in this source slice, so the evidence-based claim is limited to this: colder or fault-substituted ambient input changes the byte stored in `TargetBatteryVolts`, and the output is clamped before `ControlAlternator` uses it.

## Diagnostics

### `VerifyOperationOfBatteryVoltage_MM`

`VerifyOperationOfBatteryVoltage_MM` checks for a persistently low `BatteryVolts` reading. If battery voltage is at least `0x41`, and the low-voltage flag `b45_Bad_BatVolts` is already set, the routine starts clearing that error through `ResetErrorCodeIfTimerExpired` with timer value `0x05`.

If battery voltage is below `0x41`, the routine only escalates when all of these conditions are true:

- the engine is running, `b54_FuelEngineNotRunning` is clear
- `b45_Bad_BatVolts` is not already set
- `KeyOnOrEngineRunningTime` has reached at least `0x15` in the high byte and has low-byte bits `0x3f` clear

Once those gates pass, the routine throws non-critical error `0x2290`. If the error helper returns carry set, it sets `b45_Bad_BatVolts`. In practice, this page is the canonical owner for the battery-voltage verification path, while [DRB-II Diagnostics](diagnostics.md) remains the owner for scan-tool fault display.

### `DetectAlternatorFault_MM`

`DetectAlternatorFault_MM` runs only every 32 main-loop counts, about every 341 ms according to the source comment at `T-SMEC_v19.asm:4641`. The routine skips all work if the engine is not running.

It then compares `BatteryVolts` against `TargetBatteryVolts`:

- If actual voltage is below target, the routine first clears `b45_BattNotCharging`.
- It then checks that RPM is at or above `BTLRPM_LowBatteryVoltageAtThisRpm1500`.
- If the negative error magnitude reaches `0x10` or more, it jumps to `ThrowNonCriticalError` with code `0x0555`.

If actual voltage is above target by `0x10` or more, the routine treats that as the opposite charging fault. It throws non-critical error `0x06a0`, and if the helper returns carry set, it sets `b45_BattNotCharging`. Smaller positive error clears that flag again at `T-SMEC_v19.asm:4665`.

The flag name suggests an undercharging condition, but the code also uses it in the high-voltage branch. The safe conclusion from the ASM is that `b45_BattNotCharging` marks an alternator-output fault state after a large sustained mismatch between `BatteryVolts` and `TargetBatteryVolts`, not strictly one user-facing failure message.

### Practical checks

- If the field never comes on during a DRB actuator test, start with the owner page for actuator-test setup, [DRB-II Diagnostics](diagnostics.md), then confirm that the field output bit changes state at the alternator driver.
- If `BatteryVolts` stays low with the engine running, this source shows three main gates before a fault sets, engine-running state, elapsed run time, and the `0x41` low-voltage threshold.
- If the system shows charging faults only at low RPM, check the RPM gate first. `ControlAlternator` and `DetectAlternatorFault_MM` both refuse to make a charging judgment until RPM is above their cut points.
- For battery-sensor interpretation, ADC discussion, and generic voltage-input background, use [Sensors and Inputs](../ecu-fundamentals/sensors.md) instead of duplicating that material here.

## Calibration Constants

| Constant | Default in ASM comment | Used by | Purpose |
|----------|------------------------|---------|---------|
| `AMBLOW_BattTempLowWhenHot` | `0x05` | `DetermineTargetBatteryVoltage_MM` | Lower valid limit for `AmbientAirTempVolts` before the routine treats the sensor as faulty. |
| `AMBHIG_BattTempHighWhenCold` | `0xFA` | `DetermineTargetBatteryVoltage_MM` | Upper valid limit for `AmbientAirTempVolts` before the routine treats the sensor as faulty. |
| `CCDBTV_CCDBatteryVoltsOutput` | `0xFF` | `DetermineTargetBatteryVoltage_MM` | Alternate target-voltage adjustment input used late in the target calculation. |
| `BTLRPM_LowBatteryVoltageAtThisRpm1500` | `0x2E` | `DetectAlternatorFault_MM` | Minimum RPM gate before low-target charging-fault logic can set an error. |

### Other observed thresholds

These bytes are hard-coded literals in the owner routines, not named calibration inputs in the visible source slice:

- `0x41`, low battery-voltage threshold used by `ControlAlternator` and `VerifyOperationOfBatteryVoltage_MM`
- `0x02`, narrow error window used by `ControlAlternator` before it stops dithering and commits on/off
- `0x10`, large voltage-error threshold used by `DetectAlternatorFault_MM`
- `0xd8` to `0xec`, clamp range used by `DetermineTargetBatteryVoltage_MM`

## ASM Implementation

| Routine | ASM line | Purpose |
|---------|----------|---------|
| `ControlAlternator` | 1277 | Main alternator field-control routine. Checks actuator-test mode, engine-running state, RPM gates, measured battery voltage, and duty-cycle timing before writing the field output. |
| `TurnAlternatorOn` | 1326 | Sets `pia2b_AlternatorField`, then exits through the common transmit return path. |
| `TurnAlternatorOff` | 1339 | Clears `pia2b_AlternatorField`, then exits through the common transmit return path. |
| `DetermineTargetBatteryVoltage_MM` | 1637 | Computes `TargetBatteryVolts` from ambient input, clamps the result, and substitutes a fallback target when the ambient reading is out of range. |
| `VerifyOperationOfBatteryVoltage_MM` | 4528 | Detects a persistent low `BatteryVolts` condition after run-time gating, raises non-critical error `0x2290`, and manages `b45_Bad_BatVolts`. |
| `DetectAlternatorFault_MM` | 4638 | Periodic charging-fault monitor that compares actual voltage against target and raises non-critical errors `0x0555` or `0x06a0` when the mismatch becomes large enough. |

## See Also

- [DRB-II Diagnostics](diagnostics.md) - Actuator test mode, scan-tool fault display, and the alternator field ATM entry.
- [Sensors and Inputs](../ecu-fundamentals/sensors.md) - Battery-voltage input background and generic ADC context.
- [Diagnostic Routines Reference](../reference/diagnostic-routines.md) - Diagnostic-flow owner page that cross-references the charging-specific verification routines.
- [ASM-to-Calibration Mapping Reference](../reference/asm-cal-mapping.md) - Cross-reference for charging routines, constants, and live RAM state.

## Source

- `T-SMEC_v19.asm` lines 1277-1339 (`ControlAlternator`, `TurnAlternatorOn`, `TurnAlternatorOff`)
- `T-SMEC_v19.asm` lines 1637-1683 (`DetermineTargetBatteryVoltage_MM`)
- `T-SMEC_v19.asm` lines 4528-4547 (`VerifyOperationOfBatteryVoltage_MM`)
- `T-SMEC_v19.asm` lines 4638-4666 (`DetectAlternatorFault_MM`)
