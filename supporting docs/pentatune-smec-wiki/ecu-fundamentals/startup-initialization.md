# Startup and Initialization

## Overview

This page covers the T-SMEC v19 startup path that prepares the 68HC11 hardware state, clears working RAM, primes the first sensor values, services the COP watchdog during long setup stretches, and hands execution to `MainProgramLoop`.

The four owner routines are `SetupSystemRegisters` at line 4914, `ZeroRamFrom0EtoFE` at line 7200, `ResetCopTimer` at line 7289, and `SetupSystemAndGoToMainLoop` at line 7298 in `T-SMEC_v19.asm`. Together they form the documented initialization chain before the recurring 11 ms foreground loop described in [Main Program Loop](main-loop.md).

This page stays focused on startup ordering and hardware bring-up. It mentions interrupt enablement only where the startup code explicitly hands timing ownership to the main loop. Detailed interrupt-handler behavior belongs with the interrupt-handler owner page.

## Reset Path and Startup Ordering

The source does not place all startup work in one contiguous top-level routine, so the ordering below is an evidence-based reconstruction from the frozen call cluster and fall-through path.

| ASM lines | Routine / block | Startup role |
|----------|------------------|--------------|
| 4914-4951 | `SetupSystemRegisters` | Programs core 68HC11 system registers, timer configuration, and early PIA2 state before later initialization continues. |
| 7200-7288 | `ZeroRamFrom0EtoFE` | Clears RAM from `0x000e` through `0x00fe`, seeds the first MAP/baro values, configures PIA, serial, and timer-related state, and branches into the final startup handoff. |
| 7289-7296 | `ResetCopTimer` | Writes the `0x55aa` COP reset sequence and toggles the PIA2 OC1 bit, which lets long startup loops keep the watchdog serviced. |
| 7298-7396 | `SetupSystemAndGoToMainLoop` | Finalizes AIS, ASD, timer, switch, and A2D state, then falls through into `Setup11msLoop`. |
| 7397-7407 | `Setup11msLoop` | Programs the first OC1 compare and the minimum timer target, enables interrupts, and enters `MainProgramLoop`. |

## Register Initialization

### `SetupSystemRegisters` at line 4914

`SetupSystemRegisters` is the early hardware-setup routine for the startup path. The instructions at lines 4915-4929 show the ECU programming the 68HC11 system configuration and timer-related registers before any main-loop work can run.

Key setup work visible in the source:

- `CPU_SysConfigOptionReg` and `CPU_HighPriorityInterruptMask` are loaded from the immediate value `0x9975` at lines 4915-4917.
- `CPU_PulseAccumulatorControl` and `CPU_TimerInterruptMask2` are loaded from `0x0002` at lines 4918-4920, with the source comment noting a timer prescaler of 8 and 4 microseconds per tick.
- `CPU_OutputCompare1Mask` and `BitFlags_2e` are cleared at lines 4921-4923.
- `CPU_BlockProtReg` is masked with `0xf8` at lines 4924-4926.
- `CPU_TimerControlReg1` and `CPU_TimerForceCompare` are loaded from `0xfe78` at lines 4927-4929.
- Lines 4930-4944 read the free-running timer, add `0x09c4` for a 2.5 ms delay target, and probe `PIA2_PortB_DataDirection` until the expected OC1-related state appears or a timeout path sets `b2e_bit3` in `BitFlags_2e`.

This routine matters because the later startup path assumes the basic 68HC11 timer and PIA behavior already exists. The terminology and register names here match the hardware-oriented descriptions in [68HC11 Architecture](68hc11-architecture.md).

## RAM Clearing and Early State Seeding

### `ZeroRamFrom0EtoFE` at line 7200

`ZeroRamFrom0EtoFE` begins with the RAM clear loop that gives this routine its name.

| ASM lines | Operation | Notes |
|----------|-----------|-------|
| 7201-7204 | Store `B` through `X`, increment `X`, repeat until `0x00ff` | Clears RAM from `0x000e` through `0x00fe`. |
| 7205 | Store `A` into `INTERRUPT_COUNTER_VAR` | Reseeds one startup-visible RAM byte immediately after the clear loop. |
| 7206-7215 | Read `CPU_A2DResults1`, arm `CPU_A2DControlReg`, store `MapVolts`, call `SaveBaroPressure`, then copy the returned value into `MapValue` and `AverageMAPValue` | Establishes an initial MAP and baro-derived load state before the main loop begins. |
| 7216-7244 | Program PIA1, PIA2, `CPU_PortD`, and serial control registers | Rebuilds external I/O direction and control state after RAM clear. |
| 7245-7248 | Set Turbonator spark flags and clear `Counter_SparkCut` | Leaves spark allowed by default before engine-running logic takes over. |
| 7249-7252 | Run byte-mode serial download routine, restore `CPU_SerialBaudRate`, then call `ResetCopTimer` | Shows one explicit COP service point during a long setup stretch. |
| 7253-7281 | Check coolant-range hardware state, configure AIS-related outputs and timer flags, zero overflow counters, and branch either to `SetupSystemAndGoToMainLoop` or the short DRB/distributor prelude | Final startup staging before the main-loop handoff. |

The source makes two startup behaviors explicit here.

First, the RAM clear is selective rather than global. The loop starts from the caller-provided `X` value and stops at `0x00ff`, so this documented routine owns the `0x000e` through `0x00fe` region only.

Second, the ECU does more than clear memory. It immediately seeds `MapVolts`, `MapValue`, `AverageMAPValue`, port directions, serial state, AIS-related flags, and the distributor/speedo overflow counters that later timing code uses.

## COP Management During Startup

### `ResetCopTimer` at line 7289

`ResetCopTimer` is the startup helper that services the 68HC11 COP watchdog.

| ASM lines | Operation | Notes |
|----------|-----------|-------|
| 7290-7292 | Load `D` with `0x55aa` and write both bytes to `CPU_ArmResetCopTimerReg` | Standard COP reset handshake. |
| 7293-7295 | Read `PIA2_PortB_ControlRegister`, XOR the OC1 toggle bit, and write it back | Hardware-side toggle paired with the watchdog service. |
| 7296 | `rts` | Returns to the caller. |

This helper is called repeatedly inside the startup path, not just once. The visible call sites at lines 7252, 7267, 7320, and 7329 show the firmware servicing the COP timer before or between sensor waits, switch polling, and output setup. The same `0x55aa` handshake then reappears inside the main loop at lines 7410-7413, which keeps the watchdog discipline consistent after startup transitions into the steady 11 ms cycle.

## Final Setup and Handoff to the Main Loop

### `SetupSystemAndGoToMainLoop` at line 7298

`SetupSystemAndGoToMainLoop` performs the last startup-only work before control falls into the 11 ms loop setup.

### Entry state and output defaults

Lines 7299-7319 finalize several output and state bytes:

- Increment and store `BitFlags_AIS`.
- Build the startup value for `PIA1_PortA_DataDirection` and `PIA1_A_Buffer`, with a conditional ASD-relay bit add at lines 7302-7306 when `L0001 == 0xa4`.
- Seed `Timer_DelayBeforeUpdating_MINTHR` with `0x03`.
- Seed `BitFlags_4f` from `0x0c28`, then sample `CPU_PortA_DistRef` to choose the `CPU_TimerControlReg2` value written at line 7316.
- Set `b54_FuelEngineNotRunning`, `b54_Starting`, and `b54_DisableNormalDwell` in `BitFlags_54` at line 7317.
- Force open-loop startup state into `BitFlags_50` at lines 7318-7319.

These writes show the startup code establishing a not-yet-running engine state before the normal foreground calculations begin.

### Switch sampling and A2D priming

After the first `ResetCopTimer` call at line 7320, the routine performs two short polling phases.

| ASM lines | Operation | Notes |
|----------|-----------|-------|
| 7321-7327 | Poll `SwitchPortAccessReg` until `swp_B1Volt` appears or the loop counter expires | Captures the startup switch snapshot without stalling forever. |
| 7327-7328 | Store the result into `StartupSwitchMirror1` and `StartupSwitchMirror2` | Preserves the startup switch state for later code. |
| 7329 | Call `ResetCopTimer` again | Services COP before the A2D wait. |
| 7330-7339 | Arm `CPU_A2DControlReg`, wait for conversion complete, store ambient, coolant, and charge-temperature raw values | Primes the first temperature-related samples before the loop starts. |
| 7340-7396 | Convert coolant, arm thermostat diagnostics if the startup temperature window matches, compute key-on prime injector pulsewidth, sample battery and TPS-related values, maintain `MINTHR`, and choose whether to jump directly to `Setup11msLoop` | Final sensor seeding and startup state conditioning. |

The source then reaches `Setup11msLoop` at line 7397. That block programs the first OC1 compare, computes `MinimumTimerCountBeforeMainloopCanContinue`, executes `cli` at line 7405, and enters `MainProgramLoop` at line 7407.

### Handoff summary

The startup path hands `MainProgramLoop` a controller that already has:

- Timer and PIA register setup from `SetupSystemRegisters`.
- Cleared working RAM in the `0x000e` through `0x00fe` range.
- Initial MAP, baro, battery, TPS, coolant, charge-temp, and ambient-air samples.
- Startup switch mirrors, AIS-related flags, and open-loop starting flags.
- COP service completed around the long polling and conversion waits.
- An 11 ms timer target ready for the recurring foreground loop.

For the recurring loop body that takes ownership after this handoff, see [Main Program Loop](main-loop.md).

## ASM Implementation

| Routine name | ASM line | Key behaviors |
|--------------|----------|---------------|
| `SetupSystemRegisters` | 4914 | Programs system configuration, timer prescaling, block protection, compare-control state, and an early PIA2/OC1 validation loop before later startup code runs. |
| `ZeroRamFrom0EtoFE` | 7200 | Clears RAM from `0x000e` through `0x00fe`, seeds initial MAP/baro state, rebuilds port and serial configuration, and stages the remaining startup work. |
| `ResetCopTimer` | 7289 | Resets the COP watchdog with the `0x55aa` write sequence and toggles the PIA2 OC1 control bit before returning. |
| `SetupSystemAndGoToMainLoop` | 7298 | Finalizes startup flags, switch and A2D snapshots, prime fuel and TPS state, then falls through `Setup11msLoop` into `MainProgramLoop`. |

## See Also

- [Main Program Loop](main-loop.md) - Shows the recurring 11 ms loop that takes over after startup completes.
- [Interrupt Handlers](interrupt-handlers.md) - Owns the distributor, speedometer, RTI, and PIA paths that start running after interrupts are enabled.
- [68HC11 Architecture](68hc11-architecture.md) - Hardware register and CPU context for the system, timer, COP, and PIA names used in this page.
- [ASM-to-Calibration Mapping Reference](../reference/asm-cal-mapping.md) - Cross-reference for startup routines, related constants, and the RAM bytes they seed.

## Source

- `T-SMEC_v19.asm` lines 4914-4951 (`SetupSystemRegisters`)
- `T-SMEC_v19.asm` lines 7200-7288 (`ZeroRamFrom0EtoFE`)
- `T-SMEC_v19.asm` lines 7289-7296 (`ResetCopTimer`)
- `T-SMEC_v19.asm` lines 7298-7407 (`SetupSystemAndGoToMainLoop`, `Setup11msLoop`, and handoff to `MainProgramLoop`)
