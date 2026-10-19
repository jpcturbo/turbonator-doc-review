# Ignition Timing

## Overview

Spark timing in Chrysler turbo ECUs is calculated from multiple tables based on MAP, RPM, coolant temperature, and other factors. All timing values in the calibration are **absolute degrees before TDC** — there is no "base timing" concept in the firmware.

## Fundamental Concepts

### "Base Timing" Myth

**There is no such thing as base timing in the ECU calibration.**

The 12° (or other value) on the emissions label is simply a synchronization reference:
- Used to align the distributor with the crankshaft mechanically
- The ECU neither knows nor uses this value
- Setting the distributor 2° off adds a fixed offset to all delivered timing that the ECU cannot detect or report

All timing values in calibration tables are degrees BTDC referenced from TDC (0°).

---

## Timing Calculation Sequence

The ECU calculates spark advance in `CalculateSparkAdvance_MM`. The sequence, in order:

1. **Start at zero** — no "base" added
2. **Select MAP advance table** — WOT (`WOTTBL` at $805B) or part-throttle (`MAPTBL` at $8024) based on throttle flag. If engine is cold, use cold advance (`COLDMP` at $8010) instead.
3. **Apply WOT multiplier** — if MAP advance is negative (retarding under boost) and throttle is pressed, multiply by `MultiplierOnMAPAdvanceWhenRetarding` ($806E). This can be up to 4×, making the retard more aggressive at high RPM. T2 calibrations set this to 1.0.
4. **Part-throttle floor** — if MAP advance is negative but throttle is NOT pressed, floor at +10° (prevents excessive retard at light load).
5. **Add RPM advance** — look up advance from `ADVTBL` ($8098) indexed by RPM.
6. **Add coolant temp advance** — additional advance from `CTADVTBL` ($8090) indexed by CTS.
7. **Limit by maximum advance table** — `MAXTBL` ($80B3) indexed by RPM caps the total.
8. **Subtract knock retard** — per-cylinder retard (see below) reduces final advance.
9. **Subtract adaptive retard** — `AdaptiveRetardIndex` applied if conditions met.
10. **Apply anti-lag retard** — if opt_AntiLag active and Turbonator staging flags set.
11. **Apply NO2 retard** — if opt_NO2Retard active and switch is on.
12. **Apply spark scatter** — if idle conditions met, scatter advance replaces calculated value (see below).
13. **Store final advance** — written to `CalculatedSparkAdvance` for output comparator.

In limp-in mode, all of the above is bypassed and a fixed 6° ($8429) is used.

---

## Timing Tables

### WOT Advance from MAP ($805B)

Timing adjustment at full throttle, indexed by MAP sensor reading:
- Negative values = retard under boost
- In boost, this table typically has negative values to prevent knock

### Part-Throttle Advance from MAP ($8024)

Used when throttle is partially open. Generally has more positive (aggressive) values than the WOT table — this is normal. The WOT multiplier ($806E) is what makes the WOT table effectively more aggressive at high RPM under boost.

### Cold MAP Advance ($8010)

Replaces the normal MAP advance when engine is cold. Typically adds timing for cold combustion characteristics.

### Advance from RPM ($8098)

Primary timing contribution indexed by engine speed. Added to whichever MAP advance is selected.

### Coolant Temp Advance ($8090)

Additional timing based on CTS. Small values, tapers off as engine warms.

### Maximum Advance Table ($80B3)

Hard cap on total advance indexed by RPM. Prevents excessive advance at any operating point.

---

## WOT Multiplier

**`MultiplierOnMAPAdvanceWhenRetarding` ($806E)**

When WOT MAP advance is negative (retarding under boost), this table multiplier scales the retard up to 4×. The multiplier is indexed by RPM — higher RPM can apply more retard.

This is why the WOT MAP advance table often appears to have less timing than the P/T table, even though the engine ends up with appropriate timing at WOT: the multiplier amplifies the negative (retard) values.

**T2 calibrations:** Set to 1.0 across all RPM — no multiplication effect. T2 relies on the raw WOT table values directly.

---

## Knock Control

### Per-Cylinder Retard

Each cylinder has its own retard variable (`Cylinder1Retard` through `Cylinder4Retard`). During every distributor interrupt, the knock sensor voltage (`KnockVolts`) is compared to `KnockSensorThreshold`:

- Knock detected → retard rate `RTRDRT` (no boost) or `RTRDRT2` (in boost) is added to the active cylinder's retard
- Maximum retard for any cylinder is capped at 0x3F (63 counts ≈ ~16°)
- `MaxRetardFromMAP` provides a separate MAP-based upper limit

### Retard Decay

When knock stops, retard is removed by the `INCSRT` bit-test logic in the main loop:

```
Each distributor pulse:
  INCSRT bit counter tests specific bits of Counter_MainLoop
  If the pattern matches → decrement that cylinder's retard by 1
```

The decay rate is slower than the add rate — timing is pulled in quickly when knock is detected but recovers gradually. This asymmetry protects the engine.

### Boost vs. Non-Boost Rate

The knock threshold behaves differently in boost:

```
KnockVolts ≥ KnockSensorThreshold?
  NO → retard = 0 (clear)
  YES → check if MAP > BaroPressure + KNKOFS:
    NO (no boost) → add RTRDRT (0x06) to cylinder retard
    YES (in boost) → add RTRDRT2 (0x04) to cylinder retard
                     set b55_BoostOver5psi flag
```

In-boost knock retard also triggers `WastegateDutyCycleIncreaseFromKnock` accumulation in T1 WG control — reducing WG DC (allowing boost to build is the wrong interpretation; the WG DC reduces so the WG is commanded more closed... wait, this is complex — see [Boost Control](boost-control.md)).

### Adaptive Retard

Tables at `$80E9` (knock retard vs RPM) and `$8104` (knock retard vs MAP) store long-term learned retard. `AdaptiveRetardIndex` accumulates while knock is present for more than `ARTM5P` loops at MAP above `ARMINT` temperature. The adaptive retard is applied as an additional subtraction from calculated advance.

### ASM Implementation

The main-loop routine `CalculateKnockRetard_MM` in `T-SMEC_v19.asm` prepares the knock control limits and decay state before the distributor interrupt applies or clears cylinder-specific retard.

The routine starts with an RPM gate using `EngineRpm_HB` (RAM `0x005D`) against `KNKRPM_MinRpmforKnockRetard` (`0x20`). If RPM is below that threshold, accumulator A remains `0x00` and is stored directly into `MaxRetardFromMAP` (RAM `0x00A5`), which effectively disables allowed knock retard at very low RPM.

If RPM is high enough, the code then checks `b45_IPL1` (RAM `0x0045`) for any of these sensor fault bits:

- `b45_MapStuck`
- `b45_TpsBadSignal`
- `b45_MapBadSignal`

When none of those bits are set, the routine performs the throttle gate using `TpsVolts` (RAM `0x0067`). It subtracts `MINTHR_LowestSessionTPS`, then requires the result to be at least `THRKNK_DeltaAbove_MINTHR` (`0x53`). In plain terms, TPS must be above `MINTHR + THRKNK` before the low-RPM fallback logic is allowed.

If that TPS check passes, `EngineRpm_HB` is compared again to `KLMRPM_MinKnockDetectRpm` (`0x20`). Below `KLMRPM`, the routine does **not** use the MAP table. Instead it loads the fixed fallback constant `KNKLIM_MaxKnockRetard` (`0x05`) and stores that into `MaxRetardFromMAP` (`0x00A5`). At or above `KLMRPM`, and also in the earlier fault-gated or low-throttle paths, it uses `MapValue` (RAM `0x0063`) to look up `RETMAX_MaxKnockRetardFromMap` and stores the result in `MaxRetardFromMAP`.

After the allowed-retard limit is established, the routine loads `EngineRpm_HB` again and looks up `DLTKNK_KnockFromRpms`, storing the result in `KnockSensorThreshold` (RAM `0x00A7`). That value is the RPM-dependent knock sensor threshold later used by the distributor-interrupt knock logic.

The last part of `CalculateKnockRetard_MM` handles global retard decay. It reads `Counter_MainLoop` (RAM `0x0080`) and bit-tests it against `INCSRT_KnockRetardIncreaseRate`. When the bit pattern matches, the firmware decrements each non-zero cylinder retard byte by 1. The loop walks contiguous RAM from `0x00A1` through `0x00A4`, which are labeled `Cylinder2Retard` (`0x00A1`), `Cylinder1Retard` (`0x00A2`), `Cylinder3Retard` (`0x00A3`), and `Cylinder4Retard` (`0x00A4`). This is why all four per-cylinder retard values recover gradually in the background instead of snapping back immediately.

In summary, `CalculateKnockRetard_MM` sets two key runtime values every main-loop pass:

- `MaxRetardFromMAP` (`0x00A5`), from either `RETMAX_MaxKnockRetardFromMap`, `KNKLIM_MaxKnockRetard` (`0x05`), or zero below `KNKRPM`
- `KnockSensorThreshold` (`0x00A7`), from the RPM-based `DLTKNK_KnockFromRpms` table

> **ASM Reference:** `CalculateKnockRetard_MM` — T-SMEC_v19.asm:8151. Routines ending with `_MM` are called from the MainProgramLoop, not from the distributor interrupt path.

---

## Spark Scatter (Idle Stability Control)

Spark scatter is an undocumented idle stability system that uses **rapid ±timing modulation** to control idle RPM. Unlike the AIS motor (which acts slowly), spark scatter reacts within a single distributor pulse.

### Enable Conditions

All must be true (firmware routine `HandleSparkScatter`, T-SMEC_v19.asm:8032):

| Condition | Variable |
|-----------|---------|
| Engine at idle (not off-idle, not full throttle) | `b4f_OffIdle` = 0 |
| Engine running | `b54_FuelEngineNotRunning` = 0 |
| Not ATX gear change in progress | `b0c_ATXChngGear` = 0 |
| AIS start/run countdown expired | `Timer_CountdownFromStartRunForAisFeedback` = 0 |
| Not falling to idle | `b50_FallToIdle` = 0 |
| CTS valid | `b45_BadCoolantTemp` = 0 |
| MAP sensor valid (not stuck or bad signal) | `b45_MapStuck` = 0 **and** `b45_MapBadSignal` = 0 |
| CoolantTemp > `SSTEMP` (0x58) | Engine above minimum operating temp |
| Running time ≥ `SSITIM` (0x0088) | ~1.5 seconds after start |
| RPM above minimum speed threshold | `TimerOverflowsBetweenDistPulses` < `SSIPRD` (0x0033) |

If **any** condition fails, the routine returns immediately with scatter disabled (`b55_UseSparkScatter` cleared).

### Delta RPM Calculation and Scaling

```
delta = EngineRpm_HB - TargetIdleSpeed_HB

if delta < 0:
    delta = -delta               (two's complement negate)
    table = SPKADD (add timing)
else:
    table = SPKRET (retard timing)

delta = delta >> 4                (4× logical right shift)
if carry from last shift:
    delta = delta + 1            (round up)

if delta high byte ≠ 0:
    delta = 0xFF                  (saturate to max index)
```

The 4-bit right shift means the table is indexed in **16 RPM increments** (each `lsrd` divides by 2; four shifts = ÷16). The rounding step ensures the index is biased upward when the fractional part is ≥ 0.5. Saturation to 0xFF prevents out-of-bounds table access if the delta exceeds ~4080 RPM.

### SPKRET / SPKADD Table Lookups

Two 4-byte tables provide the scatter response:

| Table | Calibration | Description |
|-------|-------------|-------------|
| `SPKRET` | `SparkAdvanceRetardedWhenRpmAboveControl_FromDeltaRpm` | Used when RPM > target — adds retard |
| `SPKADD` | `SparkAdvanceAddedWhenRpmBelowControl_FromDeltaRpm` | Used when RPM < target — adds advance |

The `jsr Lookup4ByteTable` returns a 16-bit value:
- **B (low byte)** = spark advance adjustment, added directly to `CalculatedSparkAdvance` and stored in `Temp5`
- **A (high byte)** = scatter increment, added to the running `SparkScatter` accumulator

The `b55_UseSparkScatter` flag is set to indicate that `Temp5` contains the scattered advance value (used later in the spark output path).

### Scatter Accumulator and Overflow

The `SparkScatter` accumulator (RAM 0x008C) is a running integral, not a one-shot correction. After each distributor event:

```
SparkScatter = SparkScatter + table_high_byte(A)
```

If this addition **overflows** (`bvc` not taken — the 8-bit signed addition wraps), the firmware interprets this as the engine failing to respond to spark correction alone. The overflow direction tells the code which way to move the AIS:

- **Overflow with positive increment** (RPM too high, scatter increasing) → **decrement** `DesiredNewAisPosition` by `FTUNPW` (close AIS)
- **Overflow with negative increment** (RPM too low, scatter decreasing) → **increment** `DesiredNewAisPosition` by `FTUNPW` (open AIS)

Before moving AIS, the code verifies:
1. `DesiredNewAisPosition == CurrentAisPosition` (AIS motor is stable, not mid-move)
2. `FTUNPW` ≠ 0 (fine-tune step is configured)

The AIS adjustment is clamped:
- Lower bound: 0 (fully closed)
- Upper bound: `AISHLM` (0xA0, maximum open steps)

After AIS adjustment (or if no overflow), `SparkScatter` is stored with the new value (or cleared to 0 if scatter is disabled).

**Practical meaning:** Spark scatter overflow is the primary driver of AIS position learning. A fresh engine that idles slightly off-target converges to the correct idle position through this slow integral loop: spark scatter handles fast transients, AIS handles long-term bias.

### DRB Interaction

When DRB command **0x14** with sub-command **0x10** is active (minimum throttle setting mode), spark scatter is forcibly disabled:

- `b55_UseSparkScatter` is cleared
- A fixed advance constant `IDLSET` (0x0C = 12°) is loaded into `Temp5`
- This overrides all calculated timing

This allows the technician to set the base throttle plate opening without timing modulation interfering with the procedure.

> **ASM Reference:** `HandleSparkScatter` — T-SMEC_v19.asm:8032. Routines ending with `_MM` are called from the MainProgramLoop (see T-SMEC_v19.asm line 319).

---

## Limp-In Mode

If the ECU enters limp-in mode (severe fault):
- Fixed timing of 6° (`$8429`) — all tables and modifiers bypassed
- Very conservative for engine protection
- Normal operation resumes only after fault conditions clear

---

## Tuning Considerations

### WOT Timing Strategy

Under boost, MAP advance goes negative (retards timing). The more negative the WOT MAP table, the less total timing at WOT. The WOT multiplier can amplify this retard at high RPM.

Typical approach:
1. Set the WOT MAP table to desired retard values (negative = less timing)
2. Set the RPM multiplier to 1.0 (T2 style) or use it to taper retard at low RPM

### Knock Management

1. Start conservatively — less timing
2. Add timing in 1° increments
3. Datalog knock count and per-cylinder retard values
4. If any cylinder shows consistent retard, reduce timing at those MAP/RPM points
5. If adaptive retard is accumulating, reduce base timing

### Monitoring Per-Cylinder Retard

DRB sub-commands 0x16–0x19 read per-cylinder retard values directly. Use this to identify which cylinder is knocking and whether retard is persisting between runs.

---

## Safety Notes

1. Always datalog knock and per-cylinder retard when adjusting timing
2. Use quality fuel — timing assumes appropriate octane
3. Verify distributor mechanical sync with a timing light before tuning
4. Watch EGT if equipped — excessive timing raises exhaust temperature
5. Do not disable knock detection except briefly for timing light verification

---

## See Also

- [Spark System Flow](../reference/spark-system-flow.md) — Complete spark timing flow diagrams
- [Table Reference](../reference/table-reference.md) — All calibration table addresses
- [Adaptive Systems](adaptive-systems.md) — Knock learning, adaptive retard
- [Launch Control](launch-control.md) — Anti-lag retard, spark cut patterns
- [Fuel System](fuel-system.md) — Fuel calculation details
