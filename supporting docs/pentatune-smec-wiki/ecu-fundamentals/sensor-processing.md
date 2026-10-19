# Sensor Processing and Derived State

## Overview

This page covers the T-SMEC v19 routines that turn raw baro, temperature, throttle, distributor-sync, and pulse-timing inputs into the filtered state used by later fuel, spark, idle, and limp-in logic.

`HandleBaroReadRequirement_MM`, `CheckAndFilterCoolantAndChargeTempSensors_MM`, `DetermineIfWindowedBladeInSyncSensorOnDistributor_MM`, and `CheckThrottleRoutine_MM` are all called from the `MainProgramLoop` sensor/state block described in [Main Program Loop](main-loop.md). The lower-level lookup math, MAP scaling, and MAP/TPS filter helpers stay documented in [Sensors and Inputs](sensors.md).

## Routine Groups

| ASM lines | Routines | Role |
|----------|----------|------|
| 1448-1531 | `HandleBaroReadRequirement_MM`, `ReadBaroIfPossible`, `SaveBaroPressure` | Decide when a baro refresh is allowed, toggle the baro solenoid state, and clamp/store the captured barometric pressure. |
| 7531-7665 | `CheckAndFilterCoolantAndChargeTempSensors_MM` | Validate charge and coolant readings, filter normal changes, and substitute limp-in defaults when either sensor path fails. |
| 7666-7694 | `DetermineIfWindowedBladeInSyncSensorOnDistributor_MM` | Track distributor-window sync state used by later spark and timing paths. |
| 7695-7840 | `CheckThrottleRoutine_MM` | Validate TPS, update throttle-state flags, maintain `MINTHR`, and refresh idle/off-idle/full-throttle state used by fuel, spark, and AIS routines. |
| 8315-8331, 9171-9187 | `DetermineNumberOfOverflowsBetweenSpeedoPulses_MM`, `DetermineNumberOfOverflowsBetweenDistributorPulses_MM` | Extend timer measurements across counter wrap so vehicle-speed and distributor pulsewidth calculations keep working at low frequencies. |
| 4506-4526 | `SimulateMapReadingFromTps` | Build a substitute MAP reading from TPS and RPM when the MAP path is declared bad or stuck. |

## ASM Implementation

### Baro scheduling and capture

#### `HandleBaroReadRequirement_MM`

Routine: `HandleBaroReadRequirement_MM` at line 1448.

This routine decides whether the ECU should request a fresh barometric-pressure sample. Its first split is engine state:

- If `b54_FuelEngineNotRunning` says the engine is stopped, the routine immediately sets `b2d_ReadBaroRequired` and returns.
- If the engine is running, it maintains `Timer_BaroReadInterval`, watches the off-idle flag in `BitFlags_4f`, and clears the baro-read timers and status bits if the throttle is no longer closed.

The important outcome is not the sensor math itself, but the gating state. The routine only marks a baro refresh as needed. The actual decision to open or close the baro path is handed to `ReadBaroIfPossible`, and the actual pressure capture is handed to `SaveBaroPressure`.

#### `ReadBaroIfPossible`

Routine entry label: `ReadBaroIfPossible` at line 1473.

`ReadBaroIfPossible` enforces the conditions around a live baro read:

1. Require throttle-closed state.
2. Require RPM to stay between `BRPMLO_BaroReadLowRPM1800` and `BRPMHI_BaroReadHighRPM6650`.
3. Require `Timer_BaroReadRpmConditionsSatisfied` to exceed `BRDLAY_BaroReadDelayAfterThrottleClosed2sec`.
4. Require `Timer_BaroReadInterval` to exceed `BARTIM_BaroReadMinTimeBetweenReadings179sec`.
5. Toggle `b51_BaroSolEnergized` and `b51_SparkEngineNotRunning` in `BitFlags_51` as the baro solenoid opens or closes.

When the throttle opens, the routine immediately re-requests a baro read, clears the RPM-conditions timer, clears the energized state, and clears `b54_BaroOkEngineStopped`. When the throttle stays closed, it advances the timers until the solenoid-open and solenoid-closed delays are both satisfied.

The baro logic matters because later boost, fueling, and spark code uses stored `BaroPressure` as the ambient reference. This page stays at the scheduling level. The shared MAP-voltage conversion helper used underneath remains documented in [Sensors and Inputs](sensors.md).

#### `SaveBaroPressure`

Routine: `SaveBaroPressure` at line 1519.

`SaveBaroPressure` is the narrow storage wrapper for a completed baro read:

1. Call `ConvertMAPVoltsToValue`.
2. Copy the scaled result into `B`.
3. Reject values above `BAROHI_BaroReadValidHighLimit` or below `BAROLO_BaroReadValidLowLimit`.
4. If the reading is outside the valid window, replace it with `BARDFT_BaroReadDefaultValue`.
5. Store the final byte in `BaroPressure`.

The source comment at lines 1520-1521 also notes that the routine returns with the scaled MAP value left in `A`. That detail helps explain why the stopped-engine MAP sample at `T-SMEC_v19.asm` lines 6710-6714 can reuse this routine without extra conversion work.

### Temperature validation, filtering, and limp-in substitution

#### `CheckAndFilterCoolantAndChargeTempSensors_MM`

Routine: `CheckAndFilterCoolantAndChargeTempSensors_MM` at line 7531.

This block runs only once every eight main-loop passes, about every 80 ms according to the source comment at line 7532. Inside that slower cadence it handles both charge temperature and coolant temperature.

For charge temperature, the routine:

- Checks whether the configuration flag enables the charge-temp path.
- Forces `ChargeTemp = 0` when that path is disabled.
- Verifies `RawChargeTempVolts` against `CHGLOW_ChargeTempOutOfRangeLow` and `CHGHIG_ChargeTempOutOfRangeHigh`.
- Filters the stored `ChargeTemp` by only moving it one count when the new reading differs by at least three counts.
- Uses `DEFCHG_DefaultChargeTemp_Limpin` if the bad-charge-temp flag is already set or if the error path latches.

For coolant temperature, the same owner routine:

- Checks `RawCoolantTempVolts` against `TMPHIG_OutOfRangeColdTooHighA2D` and `TMPLOW_OutOfRangeHotTooLowA2D`.
- Selects either `TMPTL1_TempForColdScaleFromA2D` or `TMPTL2_TempForHotScaleA2D` based on the current hardware state and the toggle logic in lines 7601-7618.
- Converts the A/D reading through the selected temperature table, then filters the stored `CoolantTemp` with the same small-step logic used for charge temp.
- Falls back to `DEFTMP_DefaultEngineTemp` if coolant is bad and charge-temp substitution is not available.
- If charge temp is still valid and configured, converts `RawChargeTempVolts` through `CHGTL1_TempForChargeTempA2D` and uses that result as the coolant substitute.

The side effects show why this routine matters to later calculations. When coolant goes bad, lines 7659-7663 clear `b4f_O2Valid`, reset the closed-loop timer, and reset the thermostat diagnostic timer. That means the sensor-processing block directly influences whether O2 feedback and temperature-dependent fuel or spark paths can run normally.

This page intentionally does not restate the shared interpolation helper behind those temperature tables. That implementation detail is already documented in [Sensors and Inputs](sensors.md).

### Distributor sync state and throttle-derived engine state

#### `DetermineIfWindowedBladeInSyncSensorOnDistributor_MM`

Routine: `DetermineIfWindowedBladeInSyncSensorOnDistributor_MM` at line 7666.

This routine updates two sync-related bits in `BitFlags_51`:

- `b51_EndOfBlade_SYCLOW`
- `b51_BladePassedSensor_INSYC3`

The code only tracks the distributor-window state when the engine is running and when `b55_SearchBladeEndRef_INSYNC` is clear. It samples `CPU_PortA_DistRef` and `swp_DistSync`, then records whether the blade-end condition has gone low and whether the blade has passed the sync sensor.

The routine does not calculate spark itself, but it preserves the sync state that later distributor-interrupt and spark-placement logic depends on. That is why `main-loop.md` groups it with the sensor/state inputs even though it is really preparing timing state rather than a fuel sensor value.

#### `CheckThrottleRoutine_MM`

Routine: `CheckThrottleRoutine_MM` at line 7695.

`CheckThrottleRoutine_MM` turns the current TPS sample into the state flags the rest of the ECU uses for idle, off-idle, part-throttle, and full-throttle decisions.

The routine performs four jobs:

1. **Validate TPS input**
   - Check `TPSVolts_11msUpdate` against `THRLOW_ThrottleLowerLimit` and `THRHIG_ThrottleUpperLimit`.
   - Throw and latch the TPS error path when the signal is out of range.
   - In the faulted path, seed `TpsVolts` from a fallback built around `MINTHR_LowestSessionTPS`, with an additional offset when MAP is high enough to imply heavy load.

2. **Set full-throttle state**
   - Compare the current TPS reading against `MINTHR_LowestSessionTPS + WOTDLT_DeltaThrottleFrom_MINTHR_ToDetermineFullThrottle`.
   - Force the full-throttle branch when the Turbonator staging flag is active.
   - Add hysteresis by subtracting three counts if `b4f_FullThrottle` was already set.

3. **Maintain idle and off-idle state**
   - Update `Timer_DelayBeforeUpdating_MINTHR` and slowly walk `MINTHR_LowestSessionTPS` downward after startup.
   - Set `b4f_OffIdle` and refresh `AverageMAPValue` and `AverageTPSVolts` when the throttle leaves idle.
   - Set `b2e_AtIdle` and choose the AIS delay timer path when the throttle returns to idle.

4. **Maintain part-throttle self-calibration state**
   - Under the brake, RPM, and MAP conditions near lines 7820-7833, increment `MINTHR_LowestSessionTPS` and set `b4f_PartThrottle`.

This state feeds many later calculations. The full-throttle flag steers fuel-table and spark-table selection. Off-idle and at-idle state shape AIS behavior. `MINTHR` maintenance also feeds the MAP limp-in path because `SimulateMapReadingFromTps` subtracts the stored minimum-throttle baseline before looking up substitute load.

### Timer-overflow extension for speed and distributor measurements

#### `DetermineNumberOfOverflowsBetweenSpeedoPulses_MM`

Routine: `DetermineNumberOfOverflowsBetweenSpeedoPulses_MM` at line 8315.

This helper extends speedometer pulse timing across timer wrap. It subtracts `PreviousVehicleSpeed_HB` from the current capture value, keeps the high byte in `Temp7`, right-shifts the pulse delta, and XORs the sign information against `Counter_TimerRegHalfOverflowBetweenSpeedoPulses` to decide whether another half-overflow has elapsed.

If the sign comparison says another half-overflow occurred, the routine increments `Counter_TimerRegHalfOverflowBetweenSpeedoPulses`. It then compares the halved counter against `TimerOverflowsBetweenSpeedoPulses` and stores the larger value.

That overflow count is consumed immediately by the surrounding interrupt code at lines 8274-8302 to stabilize `SpeedoSensorPulsewidth_HB` and `VehicleSpeed_HB`, especially when pulse periods are long enough that the free-running timer wraps between edges.

#### `DetermineNumberOfOverflowsBetweenDistributorPulses_MM`

Routine: `DetermineNumberOfOverflowsBetweenDistributorPulses_MM` at line 9171.

This routine is the distributor-side version of the same idea. It subtracts `LastDistributorFallingEdgeTime`, checks the sign relationship against `Counter_TimerPastHalfwayBetweenDistPulses`, and increments that counter when another half-overflow boundary was crossed. It then compares the halved count against `TimerOverflowsBetweenDistPulses` and stores the larger result.

Later routines use `TimerOverflowsBetweenDistPulses` to decide whether the engine is spinning slowly enough to require longer key-on behavior or faster enough for normal running behavior. One direct example is `IgnitionFeedOnOffTracking` at lines 9193-9204, which selects a different `CountdownTimerFromKeyOn` based on whether the distributor overflow count is below or above two.

### MAP limp-in substitution from throttle position

#### `SimulateMapReadingFromTps`

Routine: `SimulateMapReadingFromTps` at line 4506.

`SimulateMapReadingFromTps` provides a substitute MAP-voltage byte when the live MAP path is no longer trusted. The caller at lines 6685-6707 uses it when either of these conditions is true:

- The engine is below roughly 1472 RPM and the MAP sample is outside `MAPLOW_MapSensorLowerLimit` to `MAPHIG_MapSensorUpperLimit`.
- `b45_MapStuck` or `b45_MapBadSignal` is set.

Inside the routine, the firmware:

1. Uses `EngineRpm_HB` to create an RPM-dependent offset.
2. Mixes that offset with `MINTHR_LowestSessionTPS`.
3. Adds `THROFF_OffsetAddedToCalcThrottle` to `TpsVolts`.
4. Subtracts the RPM and minimum-throttle bias.
5. Uses the result as the X input to `LMPINN_LimpinTableForMapFromThrottle`.
6. Adds `MPLMOF_OffsetForCalcMapInMapLimpin` to the looked-up value and returns it in `A`.

The important handoff is at lines 6703-6707. Whether the source byte came from the real sensor path or from `SimulateMapReadingFromTps`, the interrupt routine still runs it through `ConvertMAPVoltsToValue` and stores the final load in `MapValue`. That means later fuel, spark, boost, and transient calculations can keep using `MapValue` even during MAP limp-in, but they are now operating on a TPS-derived substitute rather than a real manifold-pressure reading.

The helper-table mechanics behind that lookup remain owned by [Sensors and Inputs](sensors.md).

## See Also

- [Sensors and Inputs](sensors.md) - Canonical owner for MAP scaling, lookup helpers, and MAP/TPS filter block math used by this routine family.
- [Main Program Loop](main-loop.md) - Shows where the `_MM` routines in this page execute inside the 11 ms foreground loop.
- [Idle and AIS Control](../tuning/idle-control.md) - Idle airflow and AIS logic that consumes throttle, MAP, baro, and temperature state from this page.
- [Engine Protection](../tuning/engine-protection.md) - Protection routines that compare boost-over-baro, RPM, and sensor-fault state derived here.

## Source

- `T-SMEC_v19.asm` lines 1448-1531 (`HandleBaroReadRequirement_MM`, `ReadBaroIfPossible`, `SaveBaroPressure`)
- `T-SMEC_v19.asm` lines 4506-4526 (`SimulateMapReadingFromTps`)
- `T-SMEC_v19.asm` lines 6685-6714 (MAP limp-in and stopped-engine baro-read call sites)
- `T-SMEC_v19.asm` lines 7531-7665 (`CheckAndFilterCoolantAndChargeTempSensors_MM`)
- `T-SMEC_v19.asm` lines 7666-7840 (`DetermineIfWindowedBladeInSyncSensorOnDistributor_MM`, `CheckThrottleRoutine_MM`)
- `T-SMEC_v19.asm` lines 8204-8331 (`DetermineNumberOfOverflowsBetweenSpeedoPulses_MM` call path and routine)
- `T-SMEC_v19.asm` lines 9171-9187 (`DetermineNumberOfOverflowsBetweenDistributorPulses_MM`)
