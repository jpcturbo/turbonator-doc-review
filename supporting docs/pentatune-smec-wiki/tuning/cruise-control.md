# Cruise Control System

The Chrysler SMEC cruise control system maintains vehicle speed using a vacuum-operated servo that adjusts throttle position. The ECU controls two solenoids — **vent** and **vacuum** — to modulate servo pressure and hold a target speed.

**Key behaviors:**
- Two-solenoid servo control (vent + vacuum) via `PIA1_A_Buffer`
- Speed setpoint captured from current vehicle speed when engaged
- Brake switch immediately disables cruise
- Manual transmission vehicles require clutch pedal input for proper operation
- ATX vehicles use Park/Neutral (`b27_ParkNeutral`) as an enable gate

---

## Overview

The cruise control logic is split across two main routines called from the main loop:

| Routine | Purpose |
|---------|---------|
| `ControlCruiseServo0_MM` | Handles switch inputs, state machine, speed setpoint, and servo logic |
| `ControlCruiseServo1_MM` | Idle/speed management and vehicle speed validation |

**RAM variables used:**

| Variable | Address | Purpose |
|----------|---------|---------|
| `CruiseControlVar` | 0x0028 | Accumulated servo control value (signed) |
| `CruiseStatus` | 0x002F | State flags (see [State Machine](#state-machine)) |
| `Counter_Cruise` | 0x0030 | Timer/counter for cruise evaluation intervals |
| `Timer_CruiseDecelerate` | 0x0039 | Deceleration timer for resume/set transitions |
| `CruiseSpeedSetpoint` | 0x003A | Target speed to maintain |
| `CruiseControlVar1` | 0x003B | Filtered speed delta (signed) |
| `CruiseControlVar2` | 0x003C | Previous servo accumulator |
| `CruiseControlVar3` | 0x003D | Final servo output value |
| `CruiseControlVar4` | 0x003E | Speedo diagnostic scratch |
| `CruiseControlVar6` | 0x0040 | Cable adaptive delta speed |

---

## Enable Conditions

For cruise control to be available, all of the following must be satisfied:

| Condition | Check | Failure Result |
|-----------|-------|----------------|
| Cruise switch ON | `sw2_CruiseOnOff` bit set | Immediate dropout |
| Vehicle moving | `VehicleSpeed ≥ LOSPCO_CruiseControlLowSpeedCutoutSpeed` | Dropout |
| Not in Park/Neutral | `b27_ParkNeutral` clear (ATX) | Dropout |
| Brake not pressed | `sw2_Brake` bit clear | Dropout |
| Clutch released (MTX) | `SCNVLO ≤ clutch_scan ≤ SCNVHI` | Dropout |
| Engine running | `b54_FuelEngineNotRunning` clear | Servo disabled |

**Additional ATX checks:**
- For automatic transmissions, `sw2_PNswitch` must indicate the transmission is in gear
- Engine RPM is checked against an upper limit (`0xC0BE` threshold) to prevent cruise engagement at excessive RPM

---

## Servo Control Logic (Vent / Vacuum)

The servo is controlled by two PIA1_A_Buffer output bits:

| Output Bit | Solenoid | Effect |
|------------|----------|--------|
| `pia1abuf_CruiseVent` (0x80) | Vent solenoid | Releases vacuum → throttle closes |
| `pia1abuf_CruiseVacuum` (0x01) | Vacuum solenoid | Applies vacuum → throttle opens |

### Control Algorithm

The servo output (`CruiseControlVar3`) is computed each evaluation cycle:

```
1. Calculate speed error: CruiseSpeedSetpoint - VehicleSpeed
2. Select gain curve based on error direction and acceleration state:
   - If accelerating and above threshold → VACACC (accelerated vacuum gain)
   - Otherwise → VACREG (regular vacuum) or VENTRG (regular vent)
3. Lookup throttle gain factor: THGAIN(DeltaTPS)
4. Lookup speed gain factor: SPGAIN(VehicleSpeed)
5. Combine gains to produce final servo output
6. Clamp output and apply throttle position limits
```

### Throttle Position Limits

The servo output is gated by throttle position to prevent unsafe operation:

| Condition | Limit | Effect |
|-----------|-------|--------|
| `DeltaTPS < CLOTHR` | Vent blocked | Cannot release throttle below idle + 1 |
| `DeltaTPS > MAXTHR` | Vacuum blocked | Cannot open throttle above ~50% from idle |

These limits prevent the cruise system from closing the throttle completely (which could stall) or opening it too far (which could cause runaway acceleration).

### Output Mapping

```asm
Final servo output:
  If cruise not enabled → both solenoids OFF (vent + vacuum active = servo vented)
  If output positive → VACUUM solenoid pulsed (open throttle)
  If output negative → VENT solenoid pulsed (close throttle)
  Both solenoids default to ON when cruise is disabled (servo vented to atmosphere)
```

---

## State Machine

`CruiseStatus` (0x002F) contains the cruise state bits:

| Bit | Flag | Meaning |
|-----|------|---------|
| 7 (`b2f_bit7`) | Not Enabled | Set when cruise is active/switched on |
| 6 | — | Resume acceleration active |
| 5 | — | Set switch pressed |
| 4 (`b2f_bit4`) | Engaged | Set when speed setpoint is captured |
| 3 | — | Resume/Set pulse pending |
| 2 | — | Setup pulse in progress |
| 1 | — | Evaluation interval active |
| 0 | — | Counter initialization |

### States

#### 1. Not Enabled (Cruise OFF)
- Cruise switch OFF (`sw2_CruiseOnOff` clear)
- All status bits cleared except retained bits
- Speed setpoint zeroed
- Servo vented (both solenoids active)

#### 2. Enabled but Not Engaged (Cruise ON, waiting)
- Cruise switch ON
- System checks all enable conditions
- Vehicle speed above minimum threshold
- Waiting for SET or RESUME switch press

#### 3. Engaged (Speed Setpoint Captured)
- Triggered by pressing `sw2_CruiseSet` or `sw2_CruiseResume`
- Current vehicle speed is captured into `CruiseSpeedSetpoint`
- `b2f_bit4` (Engaged) is set
- Servo begins closed-loop speed maintenance

#### 4. Resuming
- Pressing `sw2_CruiseResume` while engaged temporarily increases setpoint
- `CruiseBumpUpSpeedBy2Mph`: adds 0x04 (2 MPH equivalent) to setpoint
- Acceleration flag set; accelerated vacuum gain curve used
- System transitions back to engaged once target is reached

### Dropout Conditions

Cruise immediately drops to "not engaged" state when:
- Cruise switch turned OFF
- Brake pedal pressed (`sw2_Brake` set)
- Vehicle speed below `LOSPCO` low-speed cutoff
- ATX vehicle placed in Park/Neutral (`sw2_PNswitch` clear)
- MTX clutch pedal pressed (scan value outside `SCNVLO`–`SCNVHI`)
- Engine RPM exceeds safe threshold
- Speedometer fault detected (`b56_BadSpeedo2` set)

---

## Speed Setpoint and Adjustment

### Capturing Setpoint

When the SET switch is pressed:
```asm
1. Read current vehicle speed
2. Store in CruiseSpeedSetpoint
3. Clear adaptive variables (CruiseControlVar6, Counter_Cruise)
4. Set b2f_bit4 (Engaged)
5. Compute setup pulse from SETPW table
```

### Setpoint Limits

| Limit | Constant | Default | Description |
|-------|----------|---------|-------------|
| Minimum | `MINSET` | 0x46 | Minimum allowed set speed ×2 |
| Maximum | `MAXSET` | 0xAA | Maximum allowed set speed ×2 |

Setpoint is clamped to these bounds after any adjustment.

### Resume Bump

Each RESUME press increases setpoint by approximately 2 MPH:
```asm
CruiseSpeedSetpoint = CruiseSpeedSetpoint + 0x04
```

This allows the driver to incrementally increase cruise speed without re-engaging.

### Cable Adaptive Compensation

The system includes an adaptive mechanism to compensate for throttle cable slack:
```asm
Delta = (CruiseSpeedSetpoint × 4) - VehicleSpeed + SETDLT
If Delta > |CruiseControlVar6|:
  CruiseControlVar6 = Delta
```

This adaptive value feeds into the servo calculation to account for mechanical lag in the throttle linkage.

---

## Brake Override

The brake switch has the **highest priority** in cruise control:

```asm
brclr *StartupSwitchMirror2, #sw2_Brake, ContinueCruise
DropOutOfCruise:
  ; Immediate dropout — clear engaged state
```

When the brake is pressed:
1. Cruise immediately disengages (`b2f_bit4` cleared)
2. Speed setpoint is preserved for resume
3. Servo is vented (both solenoids active)
4. `Timer_CruiseDecelerate` is cleared

The driver can resume the previous setpoint by pressing the RESUME switch after releasing the brake.

---

## Calibration Constants

| Constant | Default | Description |
|----------|---------|-------------|
| `LOSPCO_CruiseControlLowSpeedCutoutSpeed` | 0x0780 | Minimum vehicle speed for cruise operation |
| `SCNVHI_CruiseControlForBrakeFlagManualTransmissionClutchDisable` | 0xFF | MTX clutch scan upper threshold |
| `SCNVLO_CruiseControlForBrakeFlagManualTransmissionClutchDisable` | 0x52 | MTX clutch scan lower threshold |
| `SETIME_CruiseControlNoSetupPulseWhenDecelTimerAboveThis` | 0x37 | Decel timer threshold (upper) |
| `SETIM1_CruiseControlNoSetupPulseWhenDecelTimerBelowThis` | 0x52 | Decel timer threshold (lower) |
| `CRSVAR_CruiseControlVariableAdd` | 0x03 | Resume bump increment |
| `MAXSET_CruiseControlMaxSetSpeedTimesTwo` | 0xAA | Maximum set speed (×2) |
| `MINSET_CruiseControlMinSetSpeedTimesTwo` | 0x46 | Minimum set speed (×2) |
| `CRMASK_CruiseMask` | 0x11 | Counter cruise mask |
| `CRSCN1_CruiseComapreConstant1` | 0x15 | Evaluation delay constant 1 |
| `CRSCN2_CruiseComapreConstant2` | 0x06 | Evaluation delay constant 2 |
| `CRMSK2_CruiseMask2` | 0x07 | Servo accumulation upper limit |
| `CRMSK3_CruiseMask3` | 0xF4 | Servo accumulation lower limit |
| `CRMSK4_CruiseMask4` | 0x02 | BitFlags_27 decrement value |
| `CRMSK5_CruiseMask5` | 0xE2 | BitFlags_27 lower clamp |
| `CRMSK6_CruiseMask6` | 0x1E | BitFlags_27 upper clamp |
| `CRMSK7_CruiseMask7` | 0x01 | BitFlags_27 increment value |
| `SETDLT_CruiseControlSetDeltaControlPointForCableAdaptive` | 0x00 | Cable adaptive offset |
| `VACREG_CruiseControlVacRegularGainGurve_FromDeltaSpeed` | — | Regular vacuum gain curve (table) |
| `VENTRG_CruiseControlVentRegularGainCurve_FromDeltaSpeed` | — | Regular vent gain curve (table) |
| `VACACC_CruiseControlVacAcceleratedGainCurve_FromDeltaSpeed` | — | Accelerated vacuum gain curve (table) |
| `ACLRST_CruiseControlDeltaSpeedToResetAccFlag` | 0x09 | Delta speed to clear acceleration flag |
| `THGAIN_CruiseControlThrottleGainFactor_FromThrottle` | — | Throttle position gain factor (table) |
| `SPGAIN_CruiseControlSpeedGainFactor_FromSpeed` | — | Vehicle speed gain factor (table) |
| `VACTIM_CruiseControlVacuumTime` | 0x01 | Vacuum pulse timing |
| `CLOTHR_CruiseControlDontVentIfThrottleBelowThis` | 0x01 | Minimum TPS delta for vent operation |
| `MAXTHR_CruiseControlDontVacIfThrottleAboveThis` | 0x50 | Maximum TPS delta for vacuum operation |
| `SETPW_CruiseControlSetupPulseForSet_FromSpeed` | — | Setup pulse duration from speed (table) |
| `RESTBL_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference` | — | Resume additional pulse from speed delta (table) |
| `RESTBL2_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference2` | — | Resume pulse secondary table |

### Table Dimensions

The gain tables (`VACREG`, `VENTRG`, `VACACC`, `THGAIN`, `SPGAIN`, `SETPW`, `RESTBL`, `RESTBL2`) are typically 8–16 point lookup tables indexed by:
- Speed delta (for gain curves)
- Throttle position (for `THGAIN`)
- Vehicle speed (for `SPGAIN` and `SETPW`)
- Speed difference (for `RESTBL` and `RESTBL2`)

---

## ATM Test Mode

The cruise control servo solenoids can be tested via the **Actuator Test Mode (ATM)**:

| Test Code | Function |
|-----------|----------|
| `0x0C` | **Speed Control Servo Solenoid** — Cycles both vent and vacuum solenoids on/off in a timed pattern |

**Test pattern:**
```asm
ATM_SCServoSolenoid:
  Both solenoids ON for Counter < 0x55
  Both solenoids OFF for 0x55 ≤ Counter < 0xAA
  Vacuum solenoid ON for Counter ≥ 0xAA
```

Use the DRB-II or compatible scan tool to execute test `0x0C` and verify:
- Solenoid wiring integrity
- Servo response (throttle movement)
- Vacuum system integrity (engine must be running)

---

## See Also

- [PTU Control](ptu-control.md) — Torque converter clutch management
- [Launch Control](launch-control.md) — Staging limiter and spark cut
- [Boost Control](boost-control.md) — Wastegate control and boost target
- [Fuel System](fuel-system.md) — Throttle position and MAP handling
- [Fault Codes](../reference/fault-codes.md) — Diagnostic trouble codes
- [Bootstrap Protocol](../hardware/bootstrap-protocol.md) — Serial communication for ECU programming

## Source

- `T-SMEC_v19.asm` lines 8399–8911 (`ControlCruiseServo0_MM`)
- `T-SMEC_v19.asm` lines 8333–8397 (`ControlCruiseServo1_MM`)
- `T-SMEC_v19.asm` lines 3958–3967 (`ATM_SCServoSolenoid`)
- Version history: Flag overlap fix in v14.5 (moved staging limiter flag to avoid conflict with cruise control routine)
- Version history: Cruise control errors fixed in v11 (03/12/08)
