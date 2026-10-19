# SMEC Interrupt Handlers

## Overview

This page covers the fast interrupt-driven paths in `T-SMEC_v19.asm` that sit beside the recurring foreground work described in [Main Program Loop](main-loop.md).

The foreground loop prepares state about every 11 ms. The interrupt handlers react on hardware edges and timer events, capture distributor and speedometer timing, schedule coil dwell and spark output, update per-cylinder knock retard, transfer the engine between start and run state, and track ignition-feed shutdown state.

This page is the canonical owner for the interrupt-handler cluster and the distributor-interrupt helper routines that actually execute the immediate fuel and spark path. Detailed fueling, ignition, boost, and launch-control algorithms still belong to their subsystem owner pages.

Related pages:

- [Main Program Loop](main-loop.md)
- [Startup and Initialization](startup-initialization.md)
- [Fuel System](../tuning/fuel-system.md)
- [Ignition Timing](../tuning/ignition-timing.md)
- [Boost Control](../tuning/boost-control.md)
- [Launch Control](../tuning/launch-control.md)

## Foreground and Interrupt Ownership

The main loop and the interrupt path divide the work rather than duplicating it.

| Path | Main owner routines | Timing role | What it feeds |
|------|---------------------|-------------|---------------|
| Foreground, about every 11 ms | `MainProgramLoop` and its `_MM` calls at lines 7407-7529 | Prepares slower-changing state such as fuel modifiers, spark targets, knock thresholds, boost goals, and diagnostics state | Distributor and speedometer interrupts consume this prepared state on the next edge or timer event. |
| Distributor interrupt, every distributor edge | `InterruptVector_DistributorSignal` at 6502, then `Interrupt_HandleDistributorRisingEdge` at 6558 or `Interrupt_HandleDistributorFallingEdge` at 6867 | Timing-critical capture path for sync, dwell, spark, knock, injector output, and start-run transfer | [Fuel System](../tuning/fuel-system.md), [Ignition Timing](../tuning/ignition-timing.md), [Boost Control](../tuning/boost-control.md), and [Launch Control](../tuning/launch-control.md). |
| Speedometer interrupt, every speed sensor edge | `InterruptVector_SpeedometerSignal` at 8204 | Captures vehicle-speed pulse timing and speed-sensor plausibility state | Cruise, rolling-idle, PTU, and speed-based boost logic in the foreground pages. |
| Real-time and PIA interrupts | `Interrupt_RealTime` at 7145 and `InterruptVector_PIA_Signal` at 9189 | System bring-up, periodic recovery, and ignition-feed feedback tracking | Startup handoff, shutdown detection, and output-state validation. |

The startup page already documents `Setup11msLoop` as the handoff into the foreground loop. This page owns what happens after interrupts are enabled and the hardware begins driving these asynchronous entry points.

## Interrupt Handler Map

| Routine name | ASM line | Interrupt family | Role |
|--------------|----------|------------------|------|
| `InterruptVector_DistributorSignal` | 6502 | Distributor IC1 | Top-level distributor ISR. Validates the expected edge, updates sync-related state, and dispatches to the rising or falling edge handler. |
| `Interrupt_HandleDistributorRisingEdge` | 6558 | Distributor IC1 | Sync, dwell, MAP sampling, knock-retard update, injector decision, and run-fuel path entry. |
| `Interrupt_HandleDistributorFallingEdge` | 6867 | Distributor IC1 | Pulsewidth capture, engine start-run transfer, anti-dwell calculation, MAP plausibility update, and final spark-position scheduling. |
| `Interrupt_RealTime` | 7145 | RTI | Reinitializes core hardware state, clears and seeds RAM, rebuilds early serial and PIA state, and re-establishes initial MAP and baro context. |
| `InterruptVector_SpeedometerSignal` | 8204 | Speedometer IC2 | Validates speed-sensor activity, updates pulse timing and vehicle-speed state, and sets speedo fault bits when the pulse stream looks implausible. |
| `InterruptVector_PIA_Signal` | 9189 | PIA | Very short ISR that calls `IgnitionFeedOnOffTracking`, then returns. |

## Distributor Interrupt Path

### `InterruptVector_DistributorSignal` at line 6502

`InterruptVector_DistributorSignal` is the entry point for the distributor reference input. The visible sequence at lines 6503-6557 does four things before it hands off to the edge-specific code:

1. It resets a few transient state bytes such as `ATMOffset` and performs the small `DRBPointer1` / O2-enable housekeeping visible at lines 6503-6514.
2. It captures the current sync switch state from `SwitchPortAccessReg` into `Temp6` at lines 6514-6516.
3. It starts an A2D phase and calls `DetermineNumberOfOverflowsBetweenDistributorPulses_MM` at line 6520 so the interrupt path has an up-to-date overflow count.
4. It verifies whether the currently configured edge polarity matches the actual distributor signal. If not, lines 6538-6543 simply re-arm IC1 for rising-edge capture and return.

When the edge is accepted, lines 6545-6557 update the distributor counter, optionally call `IgnitionFeedOnOffTracking`, then branch to `Interrupt_HandleDistributorRisingEdge` if TCR2 is set for rising-edge capture or jump to `Interrupt_HandleDistributorFallingEdge` otherwise.

This makes the top-level distributor vector mostly a hardware-gating and dispatch routine. The timing-critical fuel and spark behavior is deeper in the rising and falling edge handlers below.

### `Interrupt_HandleDistributorRisingEdge` at line 6558

The rising-edge handler is the busiest interrupt path in this block.

#### Sync and cam-position handling

Lines 6559-6626 are mostly about distributor-sync interpretation. The code compares engine speed against the `0x8e` threshold, decides whether to use the window-blade inference path or the simpler pickup-state path, updates `b55_DistSync`, and keeps the `b55_InjectorAandB` cam-position bits aligned with the observed edge sequence.

This section is timing-critical because the later injector and spark paths depend on the sync bits already being correct when the routine reaches the fuel and dwell logic.

#### Dwell-output and tach preparation

Once sync is valid, lines 6627-6679 control the OC5 dwell output path. The code can force the dwell output active, clear the knock-sensor capacitor, and choose whether the next IC1 edge should be captured as a falling edge. The Turbonator spark-cut gate at line 6657 is also visible here, but the spark-cut and anti-lag policy itself belongs to [Launch Control](../tuning/launch-control.md).

#### MAP update, knock-retard update, and injector decision

The rest of the rising-edge handler, lines 6681-6845, is where the fast fuel and spark helpers actually run:

- It increments edge-based timers at lines 6682-6683.
- It updates `MapValue` from `CPU_A2DResults1` or falls back to `SimulateMapReadingFromTps` at lines 6684-6713.
- It performs per-cylinder knock-retard update at lines 6714-6746.
- It refreshes TPS and MAP transient blocks at lines 6747-6759.
- It decides whether to turn off injectors, use the engine-running pulsewidth path, or use the starting path at lines 6760-6771.

That split is why this page owns the helper cluster below, while [Fuel System](../tuning/fuel-system.md) and [Ignition Timing](../tuning/ignition-timing.md) remain the owner pages for the detailed math and calibration semantics.

### `Interrupt_HandleDistributorFallingEdge` at line 6867

The falling-edge handler captures the pulse timing that the rising-edge path later consumes.

| ASM lines | Operation | Notes |
|----------|-----------|-------|
| 6868-6877 | Halve and store `Counter_TimerPastHalfwayBetweenDistPulses`, capture and store `DistributorFallingEdgePulsewidth_HB`, update `LastDistributorFallingEdgeTime` | Establishes the latest measured distributor pulsewidth and resets the half-overflow counter. |
| 6878-6883 | If sync is not valid, re-arm IC1 for rising-edge capture and return | Prevents the full spark and fuel path from running on an unsynced falling edge. |
| 6885-6905 | Update tach-side counters and check for zero overflow between distributor pulses | Branches into the start-run transfer logic when the pulse stream looks like a running engine. |
| 6906-6962 | `HandleFuelStartRunStartTransfer` | Moves fuel and dwell state between start and run regimes based on RPM-derived pulsewidth thresholds. |
| 6963-6973 | Anti-dwell calculation | Computes `AntiDwellTime_HB` from falling-edge pulsewidth and minimum anti-dwell limits. |
| 6974-6996 | MAP plausibility check | Updates `MapVolts`, checks for a plausible delta, and may set `b47_MapOK`. |
| 6997-7101 | Spark-position and dwell scheduling path | Either forces dwell changes for very low speed / disabled-normal-dwell cases or runs `ReadKnockSensorAndRecalcSparkPosition` for the normal spark-output path. |

This handler is also timing-critical. It owns the latest distributor-period measurement and the final calculation of when OC5 should turn the coil on and off for the next firing event.

## Distributor-Interrupt Fuel and Spark Helpers

The routines below are interrupt-adjacent helpers that actually execute the immediate fuel and spark path. This page owns their place in the interrupt flow. The full subsystem behavior still belongs to the linked owner pages.

| Routine name | ASM line | Called from | Interrupt-path role | Detailed owner page |
|--------------|----------|-------------|---------------------|---------------------|
| `CalculateInjectorPulsewidthForEngineRunning` | 6773 | Rising-edge distributor handler | Chooses idle, part-throttle, or WOT base fuel from MAP tables, applies the already-prepared fuel modifiers, handles start-to-run blending, stores `InjectorPulsewidth_HB`, and loads injector drivers. | [Fuel System](../tuning/fuel-system.md) |
| `HandleFuelStartRunStartTransfer` | 6906 | Falling-edge distributor handler | Uses distributor pulsewidth thresholds to clear or set `b54_FuelEngineNotRunning`, `b54_Starting`, AIS feedback delay, adaptive-retard state, and normal-dwell gating as the engine moves between crank and run speed. | [Fuel System](../tuning/fuel-system.md) and [Ignition Timing](../tuning/ignition-timing.md) |
| `ReadKnockSensorAndRecalcSparkPosition` | 7013 | Falling-edge distributor handler | Samples knock A2D state, subtracts the active cylinder retard from `CalculatedSparkAdvance`, runs spark-scatter handling, stores `KnockVolts`, then recalculates dwell and spark-position timing for OC5. | [Ignition Timing](../tuning/ignition-timing.md) |
| `CALC_SPARK_RETARD_BASED_ON_KNOCK_VOLT` | 6714 | Rising-edge distributor handler | Enters the per-cylinder knock-retard update path after MAP and baro handling. Chooses the active cylinder retard slot from the injector-phase bits and compares `KnockVolts` against `KnockSensorThreshold`. | [Ignition Timing](../tuning/ignition-timing.md) |
| `SUM_ADDITIONAL_RETARD` | 6735 | Knock-retard path | Adds the newly selected retard rate to the current cylinder's retard accumulator. The selected rate comes from `RTRDRT` or `RTRDRT2`, depending on whether the MAP-over-baro threshold indicates more than about 5 psi of boost. | [Ignition Timing](../tuning/ignition-timing.md) and [Boost Control](../tuning/boost-control.md) |
| `MAX_RETARD` | 6740 | Knock-retard path | Caps the updated cylinder retard first against the local `0x3f` ceiling, then against `MaxRetardFromMAP`, and stores the smaller value back into the active cylinder slot. | [Ignition Timing](../tuning/ignition-timing.md) |

### What these helpers actually hand off

The source supports a narrow ownership boundary here:

- `CalculateInjectorPulsewidthForEngineRunning` is the interrupt-time consumer of fuel tables and modifier sums, but the actual table meanings, modifier chain, and transient-fuel logic are documented in [Fuel System](../tuning/fuel-system.md).
- `ReadKnockSensorAndRecalcSparkPosition`, `CALC_SPARK_RETARD_BASED_ON_KNOCK_VOLT`, `SUM_ADDITIONAL_RETARD`, and `MAX_RETARD` are the interrupt-time consumers of knock thresholds, cylinder-retard state, spark-scatter state, and final advance, but the spark and knock models belong to [Ignition Timing](../tuning/ignition-timing.md).
- The boost-side consequence is limited and explicit here. When the knock path crosses the boost threshold, line 6733 sets `b55_BoostOver5psi`. That flag later matters to [Boost Control](../tuning/boost-control.md), but this page does not re-document the wastegate algorithm.
- The spark scheduling path calls `CalculateSparkCutandAntiLagRetard_Routine` at line 7035. That call is the interrupt-time handoff into Turbonator staging and anti-lag behavior documented by [Launch Control](../tuning/launch-control.md).

## Speedometer Interrupt Path

### `InterruptVector_SpeedometerSignal` at line 8204

`InterruptVector_SpeedometerSignal` is the hardware-edge path for the speedometer input capture.

The first few instructions, lines 8205-8214, repeatedly call `DetermineIfSpeedoSensorOnOrOff` around `fdiv` operations. The exact filtering math is not fully explained by the labels alone, so the safest evidence-based summary is that this block validates whether the speedo signal looks active before the routine commits to the normal update path.

After that gate, the interrupt does three visible jobs:

1. **Speedo fault tracking** at lines 8215-8249. It increments counters, sets `b56_BadSpeedo1` or `b56_BadSpeedo2` when the pulse stream looks wrong, and biases `VehicleSpeed_HB` upward in one fallback path.
2. **Vehicle-speed pulsewidth update** at lines 8251-8302. It calls `DetermineNumberOfOverflowsBetweenSpeedoPulses_MM`, updates `TimerOverflowsBetweenSpeedoPulses`, filters `SpeedoSensorPulsewidth_HB`, stores `PreviousVehicleSpeed_HB`, and clears the half-overflow counter.
3. **Interrupt cleanup** at lines 8303-8306 by clearing the IC2 flag and returning.

This interrupt is less obviously cycle-critical than the distributor path, but it still feeds subsystems that depend on current vehicle-speed timing rather than slower averaged state. The visible consumers elsewhere in the source include cruise control, rolling idle logic, PTU behavior, and the speed-based boost limiter. Those behaviors are documented in [Cruise Control](../tuning/cruise-control.md), [Idle Control](../tuning/idle-control.md), [PTU Control](../tuning/ptu-control.md), and [Boost Control](../tuning/boost-control.md).

## Real-Time Interrupt Path

### `Interrupt_RealTime` at line 7145

`Interrupt_RealTime` is not part of the normal per-edge fuel or spark path. Instead, the code at lines 7145-7221 behaves like a recovery and re-seeding path for core controller state.

Visible responsibilities in this block:

- Re-enter a known stack and register setup by calling `SetupSystemRegisters` at line 7149.
- Rebuild PIA2 port direction and control state at lines 7153-7158.
- Validate RAM signature state around `L0000` and possibly call `CountRamValuesFrom02to2e` at lines 7159-7168.
- Reinitialize serial control, AIS-related flags, and startup-dependent state at lines 7169-7197.
- Clear RAM from `0x000e` upward via the `ZeroRamFrom0EtoFE` loop beginning at line 7200.
- Seed fresh MAP and baro state through `SaveBaroPressure` at lines 7206-7215.

Because the startup page already owns the initialization chain, the best reading here is that `Interrupt_RealTime` reuses the same low-level initialization building blocks when the controller needs to recover periodic baseline state. For the startup-only narrative and the `Setup11msLoop` handoff into the 11 ms foreground loop, see [Startup and Initialization](startup-initialization.md).

## PIA Interrupt Path

### `InterruptVector_PIA_Signal` at line 9189

`InterruptVector_PIA_Signal` is intentionally tiny. It calls `IgnitionFeedOnOffTracking` at line 9190, then returns at line 9191.

The helper it calls, `IgnitionFeedOnOffTracking` at line 9193, performs the visible work:

- Stores the `0x5a5a` signature into `L0000`.
- Sets `pia2b_bit6` in `PIA2_PortB_DataDirection`.
- Chooses a countdown value of `0x17` or `0x09` from `TimerOverflowsBetweenDistPulses` and stores it into `CountdownTimerFromKeyOn`.
- Clears the injector-driver-sense and PIA1 bit-0 control bits.

This is an interrupt-driven ignition-feed and shutdown-tracking hook. It is adjacent to the foreground routine `GetControlFeedback_DetermineIfShutdownRequired_MM`, which lives just below this ISR at line 9215 and uses the same feedback and countdown state. This page keeps ownership of the interrupt entry point. The broader shutdown and control-feedback behavior belongs with the relevant engine-state, diagnostics, and output-control pages.

## ASM Implementation

| Routine name | ASM line | Key behaviors |
|--------------|----------|---------------|
| `InterruptVector_DistributorSignal` | 6502 | Captures distributor-edge context, updates transient DRB and sync state, verifies expected edge polarity, then dispatches to the rising or falling edge handler. |
| `Interrupt_HandleDistributorRisingEdge` | 6558 | Maintains sync and injector-phase bits, prepares dwell and tach state, updates MAP and per-cylinder knock retard, then decides whether to calculate engine-running injector pulsewidth or keep injectors off. |
| `CalculateInjectorPulsewidthForEngineRunning` | 6773 | Selects idle, part-throttle, or WOT base fuel, applies modifier sums and start-run blending, stores the final pulsewidth, and loads the injector drivers. |
| `Interrupt_HandleDistributorFallingEdge` | 6867 | Captures the latest falling-edge pulsewidth, manages start-run and dwell-transfer state, validates MAP-delta behavior, then schedules spark and dwell output timing. |
| `HandleFuelStartRunStartTransfer` | 6906 | Moves `FuelEngineNotRunning`, `Starting`, AIS delay, adaptive-retard, and normal-dwell state across RPM-based thresholds derived from distributor pulsewidth. |
| `ReadKnockSensorAndRecalcSparkPosition` | 7013 | Samples knock A2D state, applies cylinder-specific retard to the already-calculated advance, runs spark scatter, and recalculates the OC5 spark-position schedule. |
| `Interrupt_RealTime` | 7145 | Rebuilds core setup state, validates RAM signature bytes, clears working RAM, reseeds MAP and baro state, and restores serial and PIA defaults. |
| `InterruptVector_SpeedometerSignal` | 8204 | Validates the speedometer signal, updates speed pulse timing and fault flags, filters stored speed pulsewidth, then clears the IC2 interrupt flag. |
| `InterruptVector_PIA_Signal` | 9189 | Dispatches immediately to `IgnitionFeedOnOffTracking`, which refreshes ignition-feed countdown and related PIA feedback bits. |

## See Also

- [Main Program Loop](main-loop.md) - Foreground owner for the 11 ms `_MM` routines that prepare most of the state consumed here.
- [Startup and Initialization](startup-initialization.md) - Startup-only handoff into interrupt-enabled execution, including `Setup11msLoop`.
- [Fuel System](../tuning/fuel-system.md) - Owner page for the run-fuel tables, modifier chain, transient fuel, and start-run fuel concepts consumed by the distributor interrupt.
- [Ignition Timing](../tuning/ignition-timing.md) - Owner page for spark advance, spark scatter, knock retard, and adaptive-retard behavior that the interrupt path applies in real time.
- [Boost Control](../tuning/boost-control.md) - Owner page for wastegate and knock-related boost consequences signaled by the interrupt path.
- [Launch Control](../tuning/launch-control.md) - Owner page for spark cut and anti-lag behavior called from the interrupt spark-position path.
- [ASM-to-Calibration Mapping Reference](../reference/asm-cal-mapping.md) - Cross-reference for the interrupt families that consume prepared fuel, spark, and service-path state.

## Source

- `T-SMEC_v19.asm` lines 6502-7101 (`InterruptVector_DistributorSignal`, `Interrupt_HandleDistributorRisingEdge`, `CalculateInjectorPulsewidthForEngineRunning`, `Interrupt_HandleDistributorFallingEdge`, `HandleFuelStartRunStartTransfer`, `ReadKnockSensorAndRecalcSparkPosition`, and the documented knock-retard helpers)
- `T-SMEC_v19.asm` lines 7145-7221 (`Interrupt_RealTime`)
- `T-SMEC_v19.asm` lines 8204-8331 (`InterruptVector_SpeedometerSignal` and `DetermineNumberOfOverflowsBetweenSpeedoPulses_MM` context)
- `T-SMEC_v19.asm` lines 9189-9213 (`InterruptVector_PIA_Signal` and `IgnitionFeedOnOffTracking`)
