# Sensors and Inputs

## Overview

The ECU relies on various sensors to measure engine operating conditions. Understanding these sensors is essential for diagnosing problems and tuning effectively.

## Primary Sensors

### Manifold Absolute Pressure (MAP)

**Purpose:** Measures intake manifold pressure to estimate engine load.

**Signal Type:** 0-5V analog

**Sensor Types:**
| Type | Range | Application |
|------|-------|-------------|
| 1-bar | 0-14.7 psia | Naturally aspirated |
| 2-bar | 0-29.4 psia | Low boost turbo |
| 3-bar | 0-44.1 psia | High boost turbo |

**Voltage to Pressure:**
```
2-bar sensor: PSI = (voltage * 14.53) - 14.53
3-bar sensor: PSI = (voltage * 22.06) - 14.53
```

**ECU Usage:**
- Speed-density fuel calculation (primary load input)
- Spark advance selection (WOT vs P/T tables)
- Boost target control
- Overboost protection

**Common Problems:**
- Vacuum leaks cause high readings
- Boost leaks cause low readings
- Aged sensors drift and lose accuracy

### Throttle Position Sensor (TPS)

**Purpose:** Measures throttle blade angle to determine driver intent.

**Signal Type:** 0-5V analog (potentiometer)

**Key Voltage Points:**
| Position | Typical Voltage |
|----------|----------------|
| Closed | 0.5-0.8V |
| Part throttle | Variable |
| WOT | 4.5-5.0V |

**ECU Usage:**
- Determines which fuel table to use (N/T, P/T, F/T)
- Accelerator pump triggering
- WOT detection for boost control
- Idle validation

**Calibration:**
- Minimum TPS voltage stored in calibration
- WOT threshold is configurable
- Must be properly adjusted for accurate operation

### Coolant Temperature Sensor (CTS)

**Purpose:** Measures engine coolant temperature for cold enrichment and other corrections.

**Signal Type:** Thermistor (resistance decreases with temperature)

**Typical Resistance:**
| Temperature | Resistance |
|-------------|------------|
| -40°F | ~100kΩ |
| 70°F | ~3kΩ |
| 200°F | ~200Ω |

**ECU Usage:**
- Cold start enrichment
- Warm-up enrichment decay
- Spark advance (cold vs warm)
- Idle speed adjustment
- Fan control
- Diagnostic enabling

### Charge Temperature Sensor (Intake Air Temperature)

**Purpose:** Measures intake air temperature for density correction.

**Signal Type:** Thermistor (same type as CTS)

**ECU Usage:**
- Air density compensation in fuel calculation
- Knock threshold adjustment
- Timing adjustment for hot intake air

**Location:** Typically in intake manifold or turbo outlet pipe

### Oxygen Sensor (O2)

**Purpose:** Measures exhaust oxygen content to determine air-fuel ratio.

**Signal Type:** 0-1V (narrow-band)

**Voltage Meaning:**
| Voltage | Condition |
|---------|-----------|
| < 0.2V | Lean |
| 0.45V | Stoichiometric (14.7:1) |
| > 0.7V | Rich |

**ECU Usage:**
- Closed-loop fuel trim
- Adaptive memory learning
- Catalyst protection

**Limitations:**
- Only accurate near stoichiometric
- Cannot read actual AFR
- Slow response time
- Not used at WOT (open loop)

### Hall Effect Pickup (Distributor)

**Purpose:** Provides crankshaft position and RPM information.

**Signal Type:** Digital pulse (Hall effect or reluctor)

**ECU Usage:**
- RPM calculation
- Spark timing reference
- Fuel injection timing
- Distributor interrupt (triggers calculations)

## Secondary Inputs

### Battery Voltage

**Purpose:** Compensates for injector response time.

**ECU Usage:**
- Injector deadtime compensation
- Charging system monitoring

**Effect:** Lower voltage = longer injector opening time required

### Speed Sensor (Vehicle Speed)

**Purpose:** Measures vehicle speed.

**Signal Type:** Pulsed output from transmission

**ECU Usage:**
- Speed-based fuel cut (rev limiter enhancement)
- Idle speed adjustment
- Some boost control strategies

### A/C Request

**Purpose:** Signals when A/C compressor is requested.

**Signal Type:** 12V switched input

**ECU Usage:**
- Idle speed increase
- A/C cutout under boost
- Load compensation

### Brake Switch

**Purpose:** Signals brake pedal application.

**Signal Type:** 12V switched input

**ECU Usage:**
- Idle validation
- Deceleration fuel cut

### Park/Neutral Switch

**Purpose:** Indicates automatic transmission gear position.

**Signal Type:** Ground when in P or N

**ECU Usage:**
- Different idle targets
- Spark advance adjustment

### Knock Sensor

**Purpose:** Detects engine knock (detonation).

**Signal Type:** Piezoelectric (vibration to voltage)

**ECU Usage:**
- Short-term knock retard
- Long-term knock adaptation
- Engine protection

## Sensor Scaling

### How Sensors Are Read

1. **ADC Conversion:** Analog voltage converted to 8-bit value (0-255)
2. **Lookup Table:** Raw value converted to engineering units via table
3. **Filtering:** Noise filtering applied (averaging, spike rejection)

### Scaling in Calibration

Each sensor has scaling parameters in the calibration:
- Raw ADC value to physical unit conversion
- Minimum and maximum valid ranges
- Fault detection thresholds

## Sensor Failure Handling

### Limp-In Mode

When critical sensors fail, the ECU enters "limp-in" mode:
- Fixed spark advance (typically 6°)
- Fixed fuel enrichment
- No boost control
- Check engine light illuminated

### Sensor Substitution

Some sensors have backup strategies:
- CTS failure: Use fixed value or charge temp
- MAP failure: Use fixed value based on TPS
- TPS failure: Default to part-throttle behavior

## Diagnostic Codes

Common sensor-related fault codes:

| Code | Description |
|------|-------------|
| 13 | MAP sensor circuit |
| 14 | MAP signal out of range |
| 21 | O2 sensor circuit |
| 22 | Coolant temp sensor |
| 23 | Charge temp sensor |
| 24 | Throttle position sensor |
| 25 | Idle switch circuit |
| 52 | O2 sensor stays lean |
| 53 | O2 sensor stays rich |

## Tuning Considerations

### MAP Sensor Upgrade

When upgrading to higher boost:
1. Install appropriate MAP sensor (2-bar or 3-bar)
2. Update calibration scaling constants
3. Verify full range operation with scan tool

### TPS Calibration

After throttle body replacement or TPS adjustment:
1. Set minimum voltage to ~0.6V with throttle closed
2. Verify WOT reaches 4.5V+
3. Adjust calibration min/max if needed

### Charge Temp Location

Charge temp sensor placement affects tuning:
- Before intercooler: Reads turbo outlet temp
- After intercooler: Reads actual intake charge temp
- Calibration should match sensor location

## ASM Implementation

The high level sensor math above is implemented in `T-SMEC_v19.asm` with a small set of shared lookup and scaling helpers. These routines show how the firmware converts ADC bytes into engineering values, interpolates table entries, and filters MAP and TPS inputs.

### MAP voltage scaling, `ConvertMAPVoltsToValue`

Routine: `ConvertMAPVoltsToValue` at line 7842.

Relevant symbols from the ASM:

| Symbol | Meaning |
|--------|---------|
| `Temp5` (`0x00C4`) | Scratch byte used to save the incoming MAP voltage byte |
| `MAPMULT_ScaleMAPVoltsToPresMultiplyConst` | Calibration multiplier constant |
| `MAPADD_ScaleMAPVoltsToPresAddConst` | Calibration add constant |
| `MapValue` (`0x0063`) | Final scaled MAP value in PSI units |

Instruction flow:

1. Save the incoming ADC byte in `Temp5`.
2. Multiply the input by `MAPMULT` with `mul`.
3. Add the saved byte back into `A` as part of the fixed point scaling path.
4. If that add carries, force `A = 0xFF`.
5. Add the calibration offset `MAPADD` as a 16-bit add.
6. If that add carries, force `A = 0xFF`.

Firmware scaling formula:

```text
PSI = (MAPMULT * volts) / 256 + MAPADD
```

The implementation saturates at `0xFF` on either carry path, so an overflowed MAP conversion clamps to the maximum 8-bit value instead of wrapping.

The same converter is also reused by `SaveBaroPressure`, which immediately checks the scaled result against `BAROHI`, `BAROLO`, and `BARDFT` before storing barometric pressure.

### 16-bit fixed point interpolation, `ScaleYbyA`

Routine: `ScaleYbyA` at line 9108.

Inputs from the ASM comments:

| Register | Meaning |
|----------|---------|
| `A` | Delta from the lower table break point, `0..255` |
| `Y` | 16-bit slope |

Output:

| Register | Meaning |
|----------|---------|
| `Y` | Interpolated 16-bit result |

This is the core fixed point helper used by the 5-byte table logic. `A` is treated as a fractional position where `0` means `0.0` and `255` means essentially full scale. The routine multiplies the delta by the slope high byte, then by the slope low byte, folds in the carry for rounding, and returns the combined 16-bit result in `Y`.

In formula form:

```text
Yout = (A / 256) * slope16
```

That is why the routine comment describes it as "Scale Y by A, where a=0 = 0.0 and a=255 = 1.0".

### Scaling a 16-bit value in memory, `ScaleXbyB_addingA_intoD`

Routine: `ScaleXbyB_addingA_intoD` at line 9126.

Behavior from the code:

1. Save the incoming `A` flag.
2. Copy `B` into `A` so `ScaleYbyA` can use it as the fractional scale.
3. Load the 16-bit value at memory location `X` into `Y`.
4. Call `ScaleYbyA`.
5. If the saved `A` flag was non-zero, add the original 16-bit value at `X` back into `D`.
6. If that addition carries, saturate to `0xFFFF`.

In formula form:

```text
scaled = (B / 256) * word_at_X
if add_one_flag != 0:
    result = scaled + word_at_X
else:
    result = scaled
```

This is a general helper for scaling a 16-bit quantity by an 8-bit fixed point factor, with an optional `+1.0` path implemented by re-adding the original word.

### MAP and TPS filtering blocks, `ProcessMapOrTpsBlockData`

Routine: `ProcessMapOrTpsBlockData` at line 9152.

The ASM comment gives the exact 4-byte block layout:

| Offset | Meaning |
|--------|---------|
| `x+0` | MSB of average value |
| `x+1` | LSB of average value, scratch |
| `x+2` | Actual value, or faked value in limp-in |
| `x+3` | Scaling factor for leanout or enrichment |

Relevant RAM blocks:

| Symbol | Address | Notes |
|--------|---------|-------|
| `Block_MAP` | `0x0061` | Shares storage with `AverageMAPValue` |
| `AverageMAPValue` | `0x0061` | 16-bit average MAP value |
| `MapValue` | `0x0063` | Current actual MAP byte |
| `Block_TPS` | `0x0065` | Shares storage with `AverageTPSVolts` |
| `AverageTPSVolts` | `0x0065` | 16-bit average TPS value |
| `TpsVolts` | `0x0067` | Current actual TPS byte |

If the scaling factor at `x+3` is zero, the routine simply stores the actual value into the average word:

```text
avg16 = actual << 8
```

If the scaling factor is non-zero, the routine does this:

```text
scaled_avg = (factor / 256) * avg16
new_avg = avg16 + (actual * factor) - scaled_avg
```

That is the exact fixed point form produced by the instruction sequence:

- `ScaleYbyA` scales the current 16-bit average by the factor.
- `mul` computes `actual * factor`.
- The code subtracts the scaled average, then adds the original average back in.

The result is a first order filtered average with separate MAP and TPS state blocks.

### 4-byte table interpolation, `Lookup4ByteTable`

Routine: `Lookup4ByteTable` at line 9060.

ASM comment summary:

- Input `A` is the X position to look up.
- Input `X` points to the table.
- Output is returned in both `A` and `B` as the 8-bit Y value.

The routine reads the entry count from the first byte of the table, walks forward in 4-byte steps, then interpolates inside the matching segment.

Per entry format:

| Byte | Meaning |
|------|---------|
| `x+0` | Break point |
| `x+1` | Base value |
| `x+2` | Slope high byte |
| `x+3` | Slope low byte |

Interpolation math:

```text
delta = input - break_point
result = base + delta * slope
```

In instruction terms, the routine multiplies `delta` by both slope bytes, folds the fractional carry into the integer path, adds the interpolated amount to the base value, and returns the final 8-bit result in both `A` and `B`.

This is the helper used by many sensor and transient tables such as TPS enrichment time and decel leanout factors.

### 5-byte table interpolation, `Lookup5ByteTable`

Routine: `Lookup5ByteTable` at line 6850, with `Lookup5ByteTable_FromMAP` at line 6847 loading `A` from `MapValue` (`0x0063`) first.

Unlike the 4-byte helper, this table format has no count byte. The routine advances in 5-byte steps until it finds the first break point greater than or equal to the input.

Per entry format:

| Byte | Meaning |
|------|---------|
| `x+0` | Break point |
| `x+1` | Base value high byte |
| `x+2` | Base value low byte |
| `x+3` | Slope high byte |
| `x+4` | Slope low byte |

Interpolation math:

```text
delta = input - break_point
result16 = base16 + ScaleYbyA(delta, slope16)
```

So the 5-byte helper is the 16-bit version of the same pattern. It uses `ScaleYbyA` for the fractional portion, then adds the 16-bit base value. This is the path used for 16-bit quantities such as dwell and the fuel pulsewidth tables.
