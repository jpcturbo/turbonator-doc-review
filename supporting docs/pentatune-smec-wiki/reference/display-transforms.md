# Display Transforms

> **Complete reference** for display transforms available in PentaTune computed views.

## Overview

Display transforms convert raw calibration values into more intuitive units for display in computed views. The underlying stored values are unchanged; transforms only affect what you see on screen.

PentaTune supports bidirectional transforms — you can view values in one unit and edit them in another. For example, edit fuel tables in microseconds but view them as AFR or Lambda.

## Available Transforms

| Transform | Inverse | Description | Input | Output |
|-----------|---------|-------------|-------|--------|
| `identity` | — | No transform — passes value through unchanged | Any | Same |
| `toAFR` | `fromAFR` | Converts fuel pulsewidth (μs) to Air-Fuel Ratio | μs | AFR (e.g., 14.7:1) |
| `toLambda` | `fromLambda` | Converts fuel pulsewidth (μs) to Lambda | μs | λ (e.g., 1.00) |
| `toVE` | `fromVE` | Converts fuel pulsewidth (μs) to Volumetric Efficiency | μs | VE% (e.g., 85%) |

### Transform Details

#### `identity`
The default transform. No conversion is applied. Values are displayed exactly as stored in the calibration.

**Use case:** Viewing raw fuel pulsewidth in microseconds, ignition timing in degrees, or any parameter where the native unit is already meaningful.

#### `toAFR` / `fromAFR`
Converts between fuel injector pulsewidth (microseconds) and Air-Fuel Ratio using speed-density calculations.

**Formula:**
- Air density = (absolute MAP in Pa) / (287.05 × air temp in Kelvin)
- Air mass per intake stroke = (air density × displacement in L / 1000) / 4
- Fuel mass = (injector size in lb/hr × 0.453592 / 3600) × (pulsewidth in seconds)
- AFR = air mass / fuel mass

**Context required:**
- `mapValue` — Current MAP in PSI (gauge pressure, adds 14.7 for absolute)
- `rpmValue` — Current RPM
- `injectorSize` — Injector flow rate in lb/hr
- `displacement` — Engine displacement in liters
- `airTemp` — Reference air temperature in °C (default 20°C)
- `pumpingEfficiency` — Optional VE% to reverse the ECU's VE adjustment

**Use case:** Viewing fuel tables as AFR for intuitive tuning. A stoichiometric gasoline mixture is ~14.7:1.

**Clamping:** Results outside 8:1 to 25:1 display as "—" (physically implausible).

#### `toLambda` / `fromLambda`
Converts between fuel pulsewidth and Lambda (AFR normalized to stoichiometric).

**Formula:**
- Lambda = AFR / 14.7

**Use case:** Lambda provides a fuel-type-agnostic view. λ = 1.0 is always stoichiometric regardless of fuel type.

**Clamping:** Results outside 0.6 to 1.8 display as "—".

#### `toVE` / `fromVE`
Converts between fuel pulsewidth and Volumetric Efficiency percentage.

**Formula:**
- Calculate fuel mass flow rate from pulsewidth and injector size
- Calculate actual air mass flow from fuel mass × target AFR
- Calculate actual air volume flow using ideal gas law
- Theoretical air flow = (displacement × RPM) / 120
- VE% = (actual air flow / theoretical air flow) × 100

**Context required:**
- All `toAFR` context fields
- `afrTable` — Optional target AFR array indexed by absolute MAP (0-30 psi)
- `pumpingEfficiency` — Optional VE% for reversing ECU adjustments

**Use case:** Evaluating engine breathing efficiency. Stock engines typically achieve 70-90% VE; ported heads and larger cams can exceed 100%.

**Clamping:** Results outside 0-150% display as "—".

## ASM Variable Scaling Reference

The T-SMEC_v19.asm firmware defines RAM variable scaling in this format:

```
VariableName == 0xADDRESS;MPScan;LABEL;TYPE;UNIT;FLAG;DISP_MIN;DISP_MAX;MAJOR;MINOR;SCALE;RAW_MIN;RAW_MAX;GAUGE
```

### Parameter Fields

| Field | Description | Example |
|-------|-------------|---------|
| `FLAG` | Scaling flag (0.0, 0, or empty) | `0.0` |
| `DISP_MIN` | Minimum displayed value | `0.00` |
| `DISP_MAX` | Maximum displayed value | `30.00` |
| `MAJOR` | Major tick interval on gauges | `5.00` |
| `MINOR` | Minor tick interval on gauges | `1.00` |
| `SCALE` | Scale factor applied to raw value | `1.00` |
| `RAW_MIN` | Minimum raw value | `0.00` |
| `RAW_MAX` | Maximum raw value | `29.00` |

### Unit Conversion Examples from T-SMEC_v19.asm

#### MAP / Barometric Pressure (`psi`)

```
MapValue == 0x0063;MPScan;MAP;byte;psi;0.0;0.00;30.00;5.00;1.00;1.00;0.00;29.00;gauge-d
BaroPressure == 0x000E;MPScan;BARO;byte;psi;0.0;0.00;30.00;5.00;1.00;1.00;0.00;29.00;gauge-d
AverageMAPValue == 0x0061;MPScan;AvMAP;word;psi;0.0;0.00;30.00;5.00;1.00;1.00;0.00;29.00;gauge-a
```

- **Raw range:** 0–29 (byte) or 0–29 (word)
- **Display range:** 0–30 psi
- **Scale:** 1.00 (1:1 mapping)
- **Gauge type:** `gauge-d` (digital) or `gauge-a` (analog)

MAP is stored as gauge pressure (vacuum = 0, atmospheric = ~14.7, boost = higher). The ECU adds barometric pressure for absolute calculations internally.

#### Engine RPM (`rpm`)

```
EngineRpm_HB == 0x005D;MPScan;RPM;word;rpm;0;0.00;8,000.00;1,000.00;250.00;1.00;0.00;8,192.00;gauge-a
```

- **Raw range:** 0–8,192
- **Display range:** 0–8,000 rpm
- **Scale:** 1.00
- **Resolution:** Word (16-bit) value

RPM is a 16-bit counter. The high byte at `0x005D` with low byte at `0x005E` forms the complete value.

#### Coolant Temperature (`degF`)

```
CoolantTemp == 0x006A;MPScan;COOL;byte;degF;0;-20.00;240.00;30.00;10.00;1.00;-200.00;260.00;gauge-a
```

- **Raw range:** -200 to 260
- **Display range:** -20°F to 240°F
- **Scale:** 1.00
- **Note:** Signed byte with extended range for sensor fault detection

The coolant temp sensor uses a thermistor with non-linear voltage response. The ECU looks up temperature from an ADC voltage table.

#### Injector Pulsewidth (`mSec`)

```
InjectorPulsewidth_HB == 0x005B;MPScan;InjPW;word;mSec;0.00;0.00;49,152.00;500.00;250.00;1.00;0.00;49,152.00;gauge-d
```

- **Raw range:** 0–49,152
- **Display range:** 0–49,152 μs
- **Scale:** 1.00
- **Resolution:** Word (16-bit)

Injector pulsewidth is the primary fuel control variable. The ECU calculates this from the fuel tables, then applies modifiers (cold enrichment, O2 feedback, acceleration enrichment, etc.).

#### Battery Voltage (`Volts`)

```
BatteryVolts == 0x006B;MPScan;BATV;byte;Volts;0.0;0.00;16.00;4.00;1.00;1.00;0.00;16.00;gauge-a
```

- **Raw range:** 0–16
- **Display range:** 0–16V
- **Scale:** 1.00

ADC reads battery voltage through a voltage divider. The ECU uses this for alternator control and injector latency compensation.

#### Spark Advance (`deg`)

```
CalculatedSparkAdvance == 0x00A0;MPScan;ADV;byte;deg;0.0;0.00;127.00;255.00;255.00;1.00;0.00;127.00;gauge-d
```

- **Raw range:** 0–127
- **Display range:** 0–127 degrees
- **Scale:** 1.00

Spark advance is stored as degrees Before Top Dead Center (BTDC). The ECU calculates base advance from RPM and MAP, then applies modifiers (knock retard, temperature retard, etc.).

```
FinalAdvanceActual == 0x00D0;MPScan;FINADV;byte;deg;0.0;-64.00;64.00;255.00;255.00;1.00;-64.00;64.00;gauge-d
```

Final advance can be negative (After TDC) for anti-lag and staging limiter operations. Range: -64° to +64°.

#### Vehicle Speed (`mph`)

```
VehicleSpeed_HB == 0x0037;MPScan;VEHSPD;word;mph;0;0.00;200.00;25.00;10.00;1.00;0.00;1,024.00;gauge-a
```

- **Raw range:** 0–1,024
- **Display range:** 0–200 mph
- **Scale:** 1.00

Speed is derived from the vehicle speed sensor pulse count and distributor reference signal timing.

#### AFR Ratio (`ratio`)

```
AFRatio == 0x00CE;MPScan;AFRatio;byte;ratio;0.0;0.00;30.00;255.00;255.00;1.00;0.00;100.00;gauge-a
```

- **Raw range:** 0–100
- **Display range:** 0–30
- **Scale:** 1.00

This is the Turbonator firmware's computed AFR value for display/logging. It differs from the `toAFR` transform which calculates AFR from fuel pulsewidth using physics.

#### Knock Sensor (`Volts`)

```
KnockVolts == 0x0070;MPScan;KNKV;byte;Volts;0.0;0.00;5.00;1.00;1.00;1.00;0.00;5.00;gauge-d
```

- **Raw range:** 0–5
- **Display range:** 0–5V
- **Scale:** 1.00

Knock sensor is read as an ADC voltage. The ECU compares against a threshold and retards timing when knock is detected.

## Complete Transform Parameters Table

| Transform | Input Unit | Output Unit | Min Valid | Max Valid | Default Format | Requires Metadata |
|-----------|-----------|-------------|-----------|-----------|----------------|-------------------|
| `identity` | Any | Same | — | — | `%.0f` or `%.1f` | No |
| `toAFR` | μs | AFR | 8.0 | 25.0 | `%.1f:1` | Yes |
| `fromAFR` | AFR | μs | 8.0 | 25.0 | `%.0f` | Yes |
| `toLambda` | μs | λ | 0.6 | 1.8 | `%.2f` | Yes |
| `fromLambda` | λ | μs | 0.6 | 1.8 | `%.0f` | Yes |
| `toVE` | μs | % | 0 | 150 | `%.1f%%` | Yes |
| `fromVE` | % | μs | 0 | 150 | `%.0f` | Yes |

### Metadata Requirements

Transforms other than `identity` require these metadata fields:

```yaml
metadata:
  injectorSize: 42    # lb/hr — injector flow rate
  displacement: 2.2   # L — engine displacement
  referenceTemp: 20   # °C — reference air temperature
```

Optional context fields populated at runtime:
- `mapValue` — Current MAP in PSI (from live data or cell position)
- `rpmValue` — Current RPM (from live data or cell position)
- `afrTable` — Target AFR array indexed by absolute MAP (0-30 psi)
- `pumpingEfficiency` — Current VE% for reversing ECU adjustments

## Examples

### Basic Identity Transform

```yaml
views:
  - id: part-throttle-timing
    name: Part Throttle Timing
    xAxis:
      label: RPM
      min: 500
      max: 8000
      interval: 500
      unit: rpm
    yAxis:
      label: MAP
      min: -15
      max: 15
      interval: 3
      unit: psi
      invert: true
    sources:
      - GOVNER_AdvanceFromRPM
      - HOTMAP_AdvanceFromMAPWarmPart
    expression: "GOVNER_AdvanceFromRPM[x] + HOTMAP_AdvanceFromMAPWarmPart[y]"
    output:
      unit: degrees
      range: [-10, 40]
```

No `displayModes` specified — uses `identity` by default. Timing values display in degrees BTDC.

### AFR Display Mode

```yaml
views:
  - id: fuel-map-part-throttle
    name: Fuel Map (Part Throttle)
    xAxis:
      label: RPM
      min: 500
      max: 8000
      interval: 500
      unit: rpm
    yAxis:
      label: MAP
      min: -15
      max: 15
      interval: 3
      unit: psi
      invert: true
    sources:
      - name: MAPTBL_FuelPartThrottle
        editable: true
      - name: PEFTBL_PumpingEfficiency
        editable: false
        note: "VE% - only modify when engine breathing changes"
    expression: "min(MAPTBL_FuelPartThrottle[y], WOTTBL_FuelFullThrottle[y]) * PEFTBL_PumpingEfficiency[x] / 100"
    displayModes:
      - id: us
        label: μs
        transform: identity
        output:
          unit: "μs"
          range: [0, 15000]
      - id: afr
        label: AFR
        transform: toAFR
        inverseTransform: fromAFR
        output:
          unit: AFR
          range: [10, 18]
          format: "%.1f:1"
      - id: lambda
        label: λ
        transform: toLambda
        inverseTransform: fromLambda
        output:
          unit: λ
          range: [0.7, 1.2]
          format: "%.2f"
    notes: "Base part-throttle fuel capped at WOT, with pumping efficiency applied."
```

This view provides three display modes:
1. **Microseconds** (`identity`) — Raw fuel pulsewidth as stored in calibration
2. **AFR** (`toAFR`) — Air-fuel ratio for intuitive tuning
3. **Lambda** (`toLambda`) — Fuel-type-agnostic equivalence ratio

When editing in AFR mode, PentaTune uses `fromAFR` to convert your edited AFR value back to microseconds before writing to the calibration.

### VE Display Mode

```yaml
      - id: ve
        label: VE%
        transform: toVE
        inverseTransform: fromVE
        output:
          unit: "%"
          range: [50, 120]
          format: "%.1f%%"
          invertColorScale: true  # Higher VE% is better
```

The `invertColorScale` option reverses the heatmap so blue = high VE (good) and red = low VE (poor). Without this, the default is red = high, blue = low.

## How Transforms Interact with Computed Views

### Data Flow

```
Calibration Tables → Expression Engine → Raw Grid Values → Display Transform → Screen
                                      ↑                          ↓
                                   Context (MAP, RPM,        User edits
                                   injector size, etc.)       ↓
                                                              Inverse Transform → Calibration Update
```

### Context Resolution

The transform context is built from multiple sources:

1. **YAML metadata** — Static values from the computed view definition file:
   - `injectorSize`
   - `displacement`
   - `referenceTemp`

2. **Cell position** — Dynamic values from the current cell coordinates:
   - `mapValue` — Y-axis MAP value for the current cell
   - `rpmValue` — X-axis RPM value for the current cell

3. **Pumping efficiency** — Looked up from the PEFTBL table at the current RPM

4. **AFR targets** — Optional array from project calibration data

### Editing with Transforms

When a display mode with an `inverseTransform` is active:

1. User sees values in the transformed unit (e.g., AFR 12.5:1)
2. User edits a cell to a new AFR value
3. PentaTune calls `fromAFR(12.5, context)` to get microseconds
4. The resulting microseconds value is written to the underlying calibration table
5. The expression is re-evaluated and the display updates

### Validation and Clamping

Transforms validate inputs and outputs:
- **NaN results** display as "—" (em-dash) to avoid skewing heatmap colors
- **Out-of-range values** are clamped or return NaN
- **Invalid context** (missing injector size, etc.) returns NaN with a console warning

### Formatting

The `format` field controls value display:
- `%.1f:1` → "14.7:1" (AFR format)
- `%.2f` → "1.00" (Lambda format)
- `%.1f%%` → "85.0%" (VE format)
- `%.0f` → "5000" (integer format)

## See Also

- [Computed View Editing](../tuning/computed-view-editing.md)
- [Computed View YAML Reference](computed-view-yaml.md)
- [Influence Zone Algorithm](influence-zones.md)
