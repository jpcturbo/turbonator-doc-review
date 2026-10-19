# Engine State and Emissions Control

## Overview

This page documents four main-loop routines that manage transmission state, relay enablement, and two emissions outputs in the frozen `T-SMEC_v19.asm` source:

| Routine | Main-loop call site | Routine body |
|---------|---------------------|--------------|
| `DetectParkNeutral_MM` | `T-SMEC_v19.asm:7453` | `T-SMEC_v19.asm:8959-8976` |
| `ControlAsdRelay_MM` | `T-SMEC_v19.asm:7455` | `T-SMEC_v19.asm:1535-1609` |
| `ControlPurgeSolenoid_MM` | `T-SMEC_v19.asm:7474` | `T-SMEC_v19.asm:1785-1835` |
| `ExhGasRecirc_MM` | `T-SMEC_v19.asm:7502` | `T-SMEC_v19.asm:5320-5481` |

Within the [main loop](../ecu-fundamentals/main-loop.md), these routines do not calculate fuel or spark directly. They establish operating state and switch outputs that later routines depend on. `DetectParkNeutral_MM` updates automatic transmission state bits. `ControlAsdRelay_MM` updates the ASD relay output in `PIA1_A_Buffer`. `ControlPurgeSolenoid_MM` decides when the purge solenoid output may be on. `ExhGasRecirc_MM` runs later and uses a wider set of state, O2, purge, and fault inputs before setting or clearing the EGR state bit.

## Main-Loop Control Model

The call order matters:

1. `DetectParkNeutral_MM` runs before RPM and vehicle speed finalization, and before ASD control.
2. `ControlAsdRelay_MM` runs early, while the loop is still building core engine-running and hardware-enable state.
3. `ControlPurgeSolenoid_MM` runs after fuel modifier and adaptive work, so it can use open-loop, O2-valid, and ramp state.
4. `ExhGasRecirc_MM` runs near the end of the loop, after purge, diagnostics, and other state bits have already been updated for the current pass.

That sequencing fits the foreground control model described in [SMEC Main Program Loop](../ecu-fundamentals/main-loop.md). Early routines establish whether the engine is in gear and whether a major relay should be driven. Mid-loop routines switch emissions outputs when the engine is stable enough. The late EGR routine acts more like a supervised state machine, because it checks enable conditions, hysteresis state, and error paths before it changes `b2d_EGR`.

## `DetectParkNeutral_MM` (`8959`)

### Control conditions

`DetectParkNeutral_MM` only applies its park/neutral logic when `cfg_ATX` is set in `CONFIG_ConfigurationFlags` (`T-SMEC_v19.asm:8960-8962`). If the calibration is not marked as automatic-transmission, the routine clears both `b0c_ATXInGear` and `b0c_ATXChngGear` and returns (`T-SMEC_v19.asm:8975-8976`).

For ATX configurations, the routine reads `sw2_PNswitch` from `StartupSwitchMirror2`:

| Condition | ASM evidence | Result |
|-----------|--------------|--------|
| `sw2_PNswitch` clear | `T-SMEC_v19.asm:8963-8966` | Clears `b0c_ATXInGear` if it was set |
| `sw2_PNswitch` set | `T-SMEC_v19.asm:8968-8969` | Sets `b0c_ATXInGear` if it was clear |
| State changed while engine running | `T-SMEC_v19.asm:8970-8972` | Clears `b50_FallToIdle`, sets `b0c_ATXChngGear` |
| Engine not running | `T-SMEC_v19.asm:8971-8973` | Returns without setting the gear-change bit |

The source supports a narrow claim here: this routine keeps the ATX in-gear bit synchronized with the park/neutral switch, and when the engine is already running it marks a gear-change event for other foreground logic to use.

### Calibration constants

No named calibration constants are used in the visible `DetectParkNeutral_MM` body. The routine is driven by configuration and switch state.

## `ControlAsdRelay_MM` (`1535`)

### Control conditions

`ControlAsdRelay_MM` has two visible layers. The first is a DRB-related branch at the top of the routine (`T-SMEC_v19.asm:1536-1574`). When `DRBPointer1` equals `0x18`, test-type bits are clear, pulse timing is within range, and the nibble check on `DRBPointer2` passes, the routine emits serial data and branches into the ASD toggle path. That shows the ASD output can be exercised from the service path, which lines up with the actuator-test coverage in [DRB-II Diagnostics](../hardware/diagnostics.md).

The normal ASD decision starts at `CONTROL_AUTOSHUTDOWN_RELAY_ROUTINE1` (`T-SMEC_v19.asm:1574`). The routine chooses one of two time limits based on coolant temperature:

| Coolant temperature check | Limit loaded into `X` |
|---------------------------|-----------------------|
| `CoolantTemp < 0x8f` | `0x002d` (`T-SMEC_v19.asm:1575-1579`) |
| `CoolantTemp >= 0x8f` | `0x005b` (`T-SMEC_v19.asm:1577-1580`) |

It then selects a compare threshold in `B` based on battery voltage and whether `b51_Past12secRunning` is already set:

| Condition | Compare value in `B` | ASM evidence |
|-----------|----------------------|--------------|
| Default path | `0x04` | `T-SMEC_v19.asm:1581-1584` |
| Low battery, cold-time path | `0x0b` | `T-SMEC_v19.asm:1585-1589` |
| Battery at or above `0xb2`, after 12-second flag | `0x02` | `T-SMEC_v19.asm:1591-1593` |

The actual output write happens in `ASD_ToggleOnOff`:

- The code first clears `pia1abuf_ASDRelay` from `PIA1_A_Buffer` (`T-SMEC_v19.asm:1595-1596`).
- It compares `Counter_TimerPastHalfwayBetweenDistPulses` against the selected `B` threshold (`T-SMEC_v19.asm:1597-1598`).
- It compares `KeyOnOrEngineRunningTime` against the time limit selected in `X` (`T-SMEC_v19.asm:1599-1600`).
- Only when both comparisons stay within range does it set `pia1abuf_ASDRelay` back into `PIA1_A_Buffer` (`T-SMEC_v19.asm:1601-1603`).

At the end, if the fuel-side engine-not-running bit is clear and `KeyOnOrEngineRunningTime >= 0x04`, the routine sets `b51_Past12secRunning` (`T-SMEC_v19.asm:1604-1608`).

The source proves that ASD relay control is time-windowed and pulse-timing aware. It also proves that coolant temperature, battery voltage, and engine-running history all affect the gating thresholds. The shown block does not name the user-facing ASD policy in plain language beyond those comparisons, so this page stays with the observed control flow.

### Calibration constants

No named calibration constants appear in the visible `ControlAsdRelay_MM` body. The shown logic uses literal thresholds and RAM timers instead.

## `ControlPurgeSolenoid_MM` (`1785`)

### Control conditions

`ControlPurgeSolenoid_MM` first decides whether purge is even eligible:

| Condition | ASM evidence | Result |
|-----------|--------------|--------|
| Engine running and `CoolantTemp >= PURTMP_CanisterPurgeCoolantTemp` | `T-SMEC_v19.asm:1786-1793` | Sets `b50_Purge` |
| Engine not running, or coolant below `PURTMP` | `T-SMEC_v19.asm:1786-1791` | Clears `b50_Purge` |
| `b4f_PTEisMaxed` or `b4f_FullThrottle` set | `T-SMEC_v19.asm:1794-1797` | Clears `pia1abuf_PurgeSolenoid`, returns |

If those early gates pass, the routine compares baro-derived headroom against MAP:

1. Load `BaroPressure` into `B` (`T-SMEC_v19.asm:1799`).
2. If purge is already on, subtract `PURHYS_CannisterPurgeBaroHysteresis` first (`T-SMEC_v19.asm:1800-1801`).
3. Subtract `PURMAP_CannisterPurgeWhenBelowThisBaro` (`T-SMEC_v19.asm:1802`).
4. Compare the result to `MapValue`, and turn purge off if the comparison falls below the current MAP (`T-SMEC_v19.asm:1803-1804`).

After that, the routine uses state bits to keep purge aligned with closed-loop operation:

| Condition | ASM evidence | Result |
|-----------|--------------|--------|
| `b50_Purge` already set | `T-SMEC_v19.asm:1805` | Continue toward output-on path |
| `b50_OpenLoop` set while purge bit is clear | `T-SMEC_v19.asm:1806` | Purge off |
| O2 invalid and `Timer_CLTIME_ClosedLoopTimer != 0` | `T-SMEC_v19.asm:1810-1813` | Purge off |

The final branch is a narrower disturbance check. When both `b2e_BadO2Read` bits are set, and `Counter_AdaptiveMem_Erase` is between `0x15` and `0x1e`, and O2 is rich, and `b53_PurgeSolenoid` is clear, and the engine is at idle, the routine clears the output, zeroes `Counter_PrimaryAndSecondaryRamp`, and exits through the purge-off path (`T-SMEC_v19.asm:1814-1830`). Otherwise it clears `b53_PurgeSolenoid`, sets `pia1abuf_PurgeSolenoid`, and returns (`T-SMEC_v19.asm:1832-1835`).

The safest summary is that purge is allowed only when the engine is warm enough, not at full throttle, within a baro-relative MAP window, and compatible with current O2 and loop state.

### Calibration constants

| Constant | Purpose | ASM evidence |
|----------|---------|--------------|
| `PURTMP_CanisterPurgeCoolantTemp` | Minimum coolant temperature for purge eligibility | `T-SMEC_v19.asm:1787-1789` |
| `PURHYS_CannisterPurgeBaroHysteresis` | Additional hysteresis subtracted from baro when purge is already on | `T-SMEC_v19.asm:1800-1801` |
| `PURMAP_CannisterPurgeWhenBelowThisBaro` | Baro-relative MAP margin required for purge | `T-SMEC_v19.asm:1802-1804` |

## `ExhGasRecirc_MM` (`5320`)

### Control conditions

`ExhGasRecirc_MM` begins with a hard configuration gate. If `cfg_EGR` is not set, the routine jumps to `L1469`, which clears `EGRVar1`, sets internal status bits, clears `b46_bit7`, and then falls into `EGR_SetEGRtoOn` (`T-SMEC_v19.asm:5321-5324`, `5445-5449`, `5479-5481`). That is what the frozen source shows, even though the user-facing meaning of that fallback state is not named in the comments.

When `cfg_EGR` is enabled, the routine uses several staged checks.

#### Entry and inhibit gates

| Condition | ASM evidence | Result |
|-----------|--------------|--------|
| ATX configuration present | `T-SMEC_v19.asm:5326-5328` | Skip the early MTX off-idle RPM and MAP branch |
| MTX, off-idle clear, or RPM and MAP outside compare constants | `T-SMEC_v19.asm:5329-5344` | Set `bit_bit4`, jump to `EGR_SetEGRtoOff` |
| Key-on time below `EGR9_ExhGasRecircConstFromTimeEngRunning` | `T-SMEC_v19.asm:5339-5341` | Skip ahead to the baro-minus-MAP gate |

#### Supervised enable path

To stay in the active EGR path, the routine requires all of the following:

- `b4f_OffIdle` set (`T-SMEC_v19.asm:5342`, `5348`).
- `b4f_O2Valid` set (`T-SMEC_v19.asm:5348`).
- `b50_StayOpenLoop` clear (`T-SMEC_v19.asm:5349`).
- No IPL mask bits active (`T-SMEC_v19.asm:5350-5354`).
- Purge solenoid output on in `PIA1_A_Buffer` (`T-SMEC_v19.asm:5355`).
- `BaroPressure - MapValue >= EGR33_ExhGasRecircConstFromMAPBelowBaro` (`T-SMEC_v19.asm:5356-5360`).

If any of those checks fail, the routine resets `EGRVar3`, clears status bits, copies the current ramp counter into `EGRVar5`, and then falls through `EGR_SetEGRtoOn` (`T-SMEC_v19.asm:5407-5414`, `5479-5481`).

#### Window checks and ramp-based state handling

Once the routine stays in the active path, it enforces low and high windows for MAP, TPS above `MINTHR_LowestSessionTPS`, and RPM by calling `EGR_CheckHiLoLimits` with different constant pairs:

| Check | Constant pair | ASM evidence |
|-------|---------------|--------------|
| Initial MAP window | `EGR18_ExhGasRecircConstLoLimit` | `T-SMEC_v19.asm:5365-5367` |
| Initial TPS window | `EGR14_ExhGasRecircConstFromTPSVoltsLoLimit` | `T-SMEC_v19.asm:5368-5372` |
| Initial RPM window | `EGR15_ExhGasRecircConstFromRPMLoLimit` | `T-SMEC_v19.asm:5373-5375` |
| Secondary MAP window | `EGR16_ExhGasRecircConstLoLimit` | `T-SMEC_v19.asm:5426-5428` |
| Secondary TPS window | `EGR19_ExhGasRecircConstLoLimit` | `T-SMEC_v19.asm:5429-5433` |
| Secondary RPM window | `EGR17_ExhGasRecircConstLoLimit` | `T-SMEC_v19.asm:5434-5436` |

The rest of the routine uses `EGRVar1`, `EGRVar2`, `EGRVar3`, `EGRVar5`, `EGRVar6`, and `EGRVar7` as a supervised state machine. The visible behavior includes:

- incrementing `EGRVar3` while conditions stay valid (`T-SMEC_v19.asm:5379-5381`, `5424-5425`),
- blending `EGRVar5` toward the ramp counter with multiplier `EGR8_ExhGasRecircConst` (`T-SMEC_v19.asm:5382-5397`),
- switching into a second state when `EGRVar3` passes `EGR1_ExhGasRecircConst` (`T-SMEC_v19.asm:5361-5364`, `5416-5420`),
- counting a fault or timeout path with `EGRVar1` and `EGR4_ExhGasRecircConst`, then throwing `0x2e01` if the counter reaches the limit (`T-SMEC_v19.asm:5451-5461`),
- and choosing the final `b2d_EGR` state through `EGR_SetEGRtoOff` or `EGR_SetEGRtoOn` (`T-SMEC_v19.asm:5475-5481`).

This is enough evidence to describe `ExhGasRecirc_MM` as a gated EGR state machine with multiple windows, timers, and recovery paths. The source does not justify stronger claims about exact valve duty or external plumbing behavior.

### Calibration constants

| Constant | Purpose in the visible control flow | ASM evidence |
|----------|------------------------------------|--------------|
| `EGR9_ExhGasRecircConstFromTimeEngRunning` | Minimum run-time gate before the off-idle branch can continue | `T-SMEC_v19.asm:5339-5341` |
| `EGR33_ExhGasRecircConstFromMAPBelowBaro` | Minimum `BaroPressure - MapValue` margin | `T-SMEC_v19.asm:5356-5360` |
| `EGR18_ExhGasRecircConstLoLimit` | Initial MAP low and high window | `T-SMEC_v19.asm:5365-5367` |
| `EGR14_ExhGasRecircConstFromTPSVoltsLoLimit` | Initial TPS low and high window | `T-SMEC_v19.asm:5371-5372` |
| `EGR15_ExhGasRecircConstFromRPMLoLimit` | Initial RPM low and high window | `T-SMEC_v19.asm:5373-5375` |
| `EGR3_ExhGasRecircConst` | Upper limit for the primary ramp compare | `T-SMEC_v19.asm:5376-5378` |
| `EGR8_ExhGasRecircConst` | Multiplier used when updating `EGRVar5` | `T-SMEC_v19.asm:5382-5391` |
| `EGR1_ExhGasRecircConst` | Threshold that moves the routine into the second state | `T-SMEC_v19.asm:5363-5364` |
| `EGR6_ExhGasRecircConst` | Upper limit for the second-state counter | `T-SMEC_v19.asm:5422-5423` |
| `EGR16_ExhGasRecircConstLoLimit` | Secondary MAP low and high window | `T-SMEC_v19.asm:5427-5428` |
| `EGR19_ExhGasRecircConstLoLimit` | Secondary TPS low and high window | `T-SMEC_v19.asm:5432-5433` |
| `EGR17_ExhGasRecircConstLoLimit` | Secondary RPM low and high window | `T-SMEC_v19.asm:5435-5436` |
| `EGR7_ExhGasRecircConst` | Secondary delta threshold compared against `EGRVar7` | `T-SMEC_v19.asm:5441-5444` |
| `EGR4_ExhGasRecircConst` | Fault counter limit before `ThrowNonCriticalError` | `T-SMEC_v19.asm:5454-5461` |
| `EGR5_ExhGasRecircConst` | Modulates the `EGRVar2` bit-state update path | `T-SMEC_v19.asm:5468-5472` |

## ASM Implementation

- `DetectParkNeutral_MM` at `T-SMEC_v19.asm:8959-8976`, called from the main loop at `T-SMEC_v19.asm:7453`
- `ControlAsdRelay_MM` at `T-SMEC_v19.asm:1535-1609`, called from the main loop at `T-SMEC_v19.asm:7455`
- `ControlPurgeSolenoid_MM` at `T-SMEC_v19.asm:1785-1835`, called from the main loop at `T-SMEC_v19.asm:7474`
- `ExhGasRecirc_MM` at `T-SMEC_v19.asm:5320-5481`, called from the main loop at `T-SMEC_v19.asm:7502`
- `EGR_CheckHiLoLimits` at `T-SMEC_v19.asm:5399-5404`
- `EGR_ResetEGRVars` at `T-SMEC_v19.asm:5407-5414`
- `EGR_SetEGRtoOff` at `T-SMEC_v19.asm:5475-5477`
- `EGR_SetEGRtoOn` at `T-SMEC_v19.asm:5479-5481`

Routines ending with `_MM` are called from the MainProgramLoop (see `T-SMEC_v19.asm` line 319).

## See Also

- [SMEC Main Program Loop](../ecu-fundamentals/main-loop.md) - Foreground call order and grouping.
- [Engine Protection](engine-protection.md) - Later main-loop shutdown and fuel-cut gating that depend on shared state bits.
- [Diagnostic Routines Reference](../reference/diagnostic-routines.md) - ASD and O2-related diagnostic checks that intersect with relay and emissions state.
- [DRB-II Diagnostics](../hardware/diagnostics.md) - Service and actuator-test context for relay and output control.
- [Cruise Control](cruise-control.md) - Another consumer of park-neutral and engine-running state bits.
- [PTU Control](ptu-control.md) - Another foreground output routine that depends on transmission state.

## Source

- `T-SMEC_v19.asm` lines 1535-1609 (`ControlAsdRelay_MM`)
- `T-SMEC_v19.asm` lines 1785-1835 (`ControlPurgeSolenoid_MM`)
- `T-SMEC_v19.asm` lines 5320-5481 (`ExhGasRecirc_MM`)
- `T-SMEC_v19.asm` lines 8959-8976 (`DetectParkNeutral_MM`)
- `T-SMEC_v19.asm` lines 7407-7529 (`MainProgramLoop` call order)
