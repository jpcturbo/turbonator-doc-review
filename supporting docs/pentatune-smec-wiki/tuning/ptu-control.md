# Part Throttle Unlock (PTU) Control

The Part Throttle Unlock (PTU) system controls a solenoid/indicator that signals when the torque converter clutch (TCC) should unlock during part-throttle driving conditions. This improves drivability by preventing TCC lockup during light acceleration or cruise where lockup would cause harshness or bogging.

This feature was **adapted from the TBI/V6 SMEC** and introduced in Turbonator v15 using data tables from '90/'91 SBEC T1 cars.

---

## Overview

The PTU system evaluates throttle position, MAP, coolant temperature, vehicle speed, and transmission state to determine when the TCC should remain locked or be allowed to unlock.

**Key behaviors:**
- **Lock** (PTU active / solenoid on): TCC stays locked — prevents unlock
- **Unlock** (PTU inactive / solenoid off): TCC is allowed to unlock
- Uses **hysteresis** with separate thresholds for lock vs unlock decisions
- Includes a **counter-based delay** to prevent rapid cycling
- **Vehicle speed gated** — different counter delays at low vs high speed

---

## Enable Conditions

The PTU routine runs periodically based on `PTUCNI_PTUCounterTimerIntervalForLoop` (default: every 8th main loop). For PTU to function, all entry conditions must be satisfied:

| Condition | Check | Failure Result |
|-----------|-------|----------------|
| TPS above idle | `TpsVolts > MINTHR` | PTU locks (prevents unlock) |
| Coolant temp | `CoolantTemp ≥ PTUMTP_PTUMinLockTemperature` | PTU locks |
| ATX in gear | `b0c_ATXInGear` bit set | PTU locks |
| Brake off | `sw1_Brake` bit clear | PTU locks |

If any condition fails, the system immediately sets the PTU lock state (`pia1abuf_PartThrotUnlock` set) and clears the PTU hysteresis flags.

---

## Lock Decision Logic

### MAP-Based Lock Thresholds

When vehicle speed is below `PTUMSP_PTUMinLockSpeed`:

1. Compute `MapValue - PTU_MapTemp` (stored MAP from previous PTU evaluation)
2. If the delta is ≥ `PTUMP3_PTUMAPThresholdForLock3` → **PTU locks**
3. If the delta is lower, check `PTUMP1_PTUMAPThresholdForLock1` against the stored delta

When vehicle speed is ≥ `PTUMSP_PTUMinLockSpeed`:
- The MAP threshold check is bypassed; the system proceeds directly to the hysteresis unlock checks.

### Delta TPS Check for Lock

```
If DeltaTPS < PTUDTP_PTUDeltaTPSForUnlock:
  Set PTU_A flag (primes lock state)
```

If `PTU_A` is already set, the system checks the next threshold index (`PTUMP1 + 1`).

---

## Unlock Decision Logic

### Hysteresis Tables

The PTU system uses **two pairs of tables** with hysteresis: different tables are used depending on whether the system is currently locked or unlocked.

| State | Upper Limit Table | Lower Limit Table |
|-------|-------------------|-------------------|
| **Currently Unlocked** | `PTUUUL_UpperLimitForPTUUnlock` | `PTUULL_LowerLimitForPTUUnlock` |
| **Currently Locked** | `PTULUL_UpperLimitForPTULock` | `PTULLL_LowerLimitForPTULock` |

### Unlock Sequence

```
1. Lookup upper limit table (vehicle speed indexed)
   If DeltaTPS < upper_limit → PTU locks

2. Lookup lower limit table (vehicle speed indexed)
   If DeltaTPS > lower_limit → PTU locks

3. If DeltaTPS is between upper and lower limits:
   - Decrement Counter_PartThrottleUnlock
   - When counter reaches zero → clear PTU lock bit (allow unlock)
```

This creates a **dead band** where the system holds its current state until the counter expires, preventing rapid lock/unlock oscillation.

### Decision Flow

```asm
PTU_CheckThresholdsForUnlock:
  ldx  #PTUUUL_UpperLimitForPTUUnlock    ; or PTULUL if currently locked
  bsr  PTU_LookupPTUParam               ; lookup upper threshold
  bcc  PTU_SetPTUBits                   ; DeltaTPS < upper → lock

  ldx  #PTUULL_LowerLimitForPTUUnlock    ; or PTULLL if currently locked
  bsr  PTU_LookupPTUParam               ; lookup lower threshold
  bcs  PTU_SetPTUBits                   ; DeltaTPS > lower → lock

  ; DeltaTPS is within dead band
  ldaa Counter_PartThrottleUnlock
  beq  PTU_CheckVehicleSpeed            ; counter expired
  bclr *PIA1_A_Buffer, #pia1abuf_PartThrotUnlock  ; allow unlock
  rts
```

---

## Vehicle Speed Interaction

Vehicle speed affects PTU behavior in two ways:

### 1. Speed-Based Counter Initialization

When the PTU counter expires (`Counter_PartThrottleUnlock == 0`), a new counter value is loaded based on vehicle speed:

| Condition | Counter Value | Calibration Constant |
|-----------|---------------|---------------------|
| `VehicleSpeed ≥ PTUMSP_PTUMinLockSpeed` | `PTUCNH_PTUCounterHiSpeed` | 0x5B |
| `VehicleSpeed < PTUMSP_PTUMinLockSpeed` | `PTUCNL_PTUCounterLoSpeed` | 0xB5 |

The counter decrements once per PTU evaluation interval (`PTUCNI`), creating a time delay before the next unlock decision.

### 2. Table Lookup Indexing

All PTU hysteresis tables are indexed by **vehicle speed** (shifted left 3 bits to scale):

```asm
PTU_LookupPTUParam:
  ldd  VehicleSpeed_HB
  asld                ; ×2
  asld                ; ×4
  asld                ; ×8
  jsr  Lookup4ByteTable
  ldaa Temp4          ; DeltaTPS
  cba                 ; compare with table value
  rts
```

---

## Calibration Constants

| Constant | Default | Description |
|----------|---------|-------------|
| `PTUCNI_PTUCounterTimerIntervalForLoop` | 0x07 | PTU evaluation interval (AND mask on main loop counter; 0x07 = every 8 loops) |
| `PTUMTP_PTUMinLockTemperature` | 0xC5 | Minimum coolant temp for PTU operation |
| `PTUMSP_PTUMinLockSpeed` | 0x68 | Minimum vehicle speed threshold (km/h) |
| `PTUDTP_PTUDeltaTPSForUnlock` | 0x26 | Delta TPS threshold below which PTU locks |
| `PTUMP1_PTUMAPThresholdForLock1` | — | MAP delta threshold table (low speed) |
| `PTUMP3_PTUMAPThresholdForLock3` | 0x20 | MAP delta threshold for immediate lock |
| `PTUUUL_UpperLimitForPTUUnlock` | — | Upper limit table (unlocked state) |
| `PTULUL_UpperLimitForPTULock` | — | Upper limit table (locked state) |
| `PTUULL_LowerLimitForPTUUnlock` | — | Lower limit table (unlocked state) |
| `PTULLL_LowerLimitForPTULock` | — | Lower limit table (locked state) |
| `PTUCNH_PTUCounterHiSpeed` | 0x5B | Counter reload value at high speed |
| `PTUCNL_PTUCounterLoSpeed` | 0xB5 | Counter reload value at low speed |

### Table Dimensions

All four hysteresis tables are vehicle-speed-indexed lookup tables (typically 8–16 points) with values representing **Delta TPS thresholds**.

---

## Tuning Notes

- **Higher upper limit values** = PTU stays locked longer during light throttle changes (less sensitive)
- **Lower upper limit values** = PTU allows unlock sooner (more sensitive)
- The **gap between upper and lower limits** determines the hysteresis dead band width
- **Counter values** control how long the system waits before changing state:
  - Lower counter = faster response but more potential cycling
  - Higher counter = smoother behavior but slower response
- At low speeds (`< PTUMSP`), the MAP-based lock thresholds provide additional stability

---

## ATM Test Mode

The PTU indicator output can be tested via the **Actuator Test Mode (ATM)**:

| Test Code | Function |
|-----------|----------|
| `0x0F` | **PTU Indicator** — Toggles the PTU solenoid/output on/off for testing |

Use the DRB-II or compatible scan tool to execute test `0x0F` and verify the PTU solenoid/indicator wiring and operation.

---

## ASM Implementation

- `PTU_LookupPTUParam` — T-SMEC_v19.asm:10414

Routines ending with `_MM` are called from the MainProgramLoop (see T-SMEC_v19.asm line 319).

---

## See Also

- [Boost Control](boost-control.md) — Wastegate control and boost target selection
- [Adaptive Systems](adaptive-systems.md) — O2 feedback and adaptive memory
- [Fuel System](fuel-system.md) — TPS and MAP sensor handling
- [Launch Control](launch-control.md) — Staging limiter and spark cut patterns
- [Fault Codes](../reference/fault-codes.md) — Diagnostic trouble codes
- [Bootstrap Protocol](../hardware/bootstrap-protocol.md) — Serial communication for ECU programming

## Source

- `T-SMEC_v19.asm` lines 10320–10423
- Version history: Adapted from TBI/V6 SMEC in Turbonator v15 (02/18/09)
