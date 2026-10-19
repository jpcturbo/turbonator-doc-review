# Computed View YAML Reference

> **Reference** — Complete schema documentation for defining computed views in PentaTune.

## Overview

Computed views are defined in YAML and live in the project's computed views configuration directory. Each view specifies which source tables to combine, how axes are built, and how edits are distributed back to source tables.

YAML files are stored in the app data directory under `computed-views/` and loaded at runtime. The bundled `defaults.yaml` provides common views for fuel, timing, and boost control.

---

## File Structure

A computed view definition file contains two top-level keys:

```yaml
metadata:
  # Optional global metadata for display mode calculations

views:
  # List of computed view definitions
```

---

## Top-Level Fields

### `metadata` (object, optional)

Global metadata used by display mode transforms. Can be overridden per-view.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `injectorSize` | number | `42` | Injector flow rate in lb/hr |
| `displacement` | number | `2.2` | Engine displacement in liters |
| `referenceTemp` | number | `20` | Reference air temperature in °C |

### `views` (array, required)

List of `ComputedViewDefinition` objects. Each view appears as an item in the Computed Views group in the parameter tree.

---

## View Definition Schema

### Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `id` | string | Unique identifier for the view (used internally, no spaces) |
| `name` | string | Human-readable display name |
| `xAxis` | `AxisDefinition` | X-axis breakpoint definition |
| `sources` | `SourceDefinition[]` | List of source table references |
| `expression` | string | Mathematical expression combining sources |

### Optional Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `group` | string | `"Computed Views"` | Parameter tree group name |
| `yAxis` | `AxisDefinition` | *(none)* | Y-axis breakpoint definition (omit for 1D views) |
| `output` | `OutputConfig` | *(none)* | Default display formatting for the view |
| `notes` | string | *(none)* | Descriptive text shown in the sidebar |
| `placeholder` | string | *(none)* | Placeholder message when view cannot be computed |
| `displayModes` | `DisplayMode[]` | *(none)* | Alternative display transforms (AFR, Lambda, VE%, etc.) |
| `metadata` | `ViewMetadata` | *(inherits file-level)* | Per-view override of global metadata |

---

## Axis Definition (`AxisDefinition`)

Defines the breakpoints for one axis of the computed grid.

```yaml
xAxis:
  label: RPM
  min: 500
  max: 8000
  interval: 500
  unit: rpm
  invert: false
```

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `label` | string | Yes | — | Axis label shown in headers and 3D view |
| `min` | number | Yes | — | Minimum axis value |
| `max` | number | Yes | — | Maximum axis value |
| `interval` | number | Yes | — | Step size between breakpoints |
| `unit` | string | No | — | Unit suffix (e.g., `rpm`, `psi`, `°F`) |
| `invert` | boolean | No | `false` | If `true`, display high values at top (Y-axis only) |

**Breakpoint generation:** Values are generated from `min` to `max` inclusive, stepping by `interval`. The resulting grid size is limited to **50 cells per axis** (validated at load time).

**1D views:** Omit `yAxis` entirely for single-axis lookup curves (e.g., AIS position vs coolant temp).

---

## Source Definition (`SourceDefinition`)

References a calibration table that feeds into the expression. Two formats are supported:

### Simple Format (string)

```yaml
sources:
  - GOVNER_AdvanceFromRPM
  - HOTMAP_AdvanceFromMAPWarmPart
```

Sources listed as plain strings are **editable by default**.

### Object Format

```yaml
sources:
  - name: MAPTBL_FuelPartThrottle
    editable: true
  - name: PEFTBL_PumpingEfficiency
    editable: false
    note: "VE% - only modify when engine breathing changes"
```

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `name` | string | Yes | — | Exact parameter name from the TPL file |
| `editable` | boolean | No | `true` | If `false`, the source is read-only in this view |
| `note` | string | No | — | Tooltip/note shown in the source list |

**Important:** Non-editable sources are excluded when distributing edits back to source tables. They still contribute to the computed value.

---

## Expression Syntax

The `expression` field defines how source tables are combined. It is a mathematical expression evaluated for each cell in the computed grid.

### Variable References

| Variable | Meaning |
|----------|---------|
| `x` | Current X-axis value (from `xAxis` breakpoints) |
| `y` | Current Y-axis value (from `yAxis` breakpoints, `0` for 1D views) |

### Source Lookup

Sources are referenced by name with an axis index:

```yaml
expression: "GOVNER_AdvanceFromRPM[x] + HOTMAP_AdvanceFromMAPWarmPart[y]"
```

| Syntax | Meaning |
|--------|---------|
| `SOURCE[x]` | Look up `SOURCE` at the current X-axis value |
| `SOURCE[y]` | Look up `SOURCE` at the current Y-axis value |
| `SOURCE` | Use `SOURCE` as a scalar constant (no interpolation) |

### Supported Functions

| Function | Description |
|----------|-------------|
| `min(a, b)` | Minimum of two values |
| `max(a, b)` | Maximum of two values |
| `clamp(value, min, max)` | Clamp `value` between `min` and `max` |

### Operators

Standard arithmetic: `+`, `-`, `*`, `/`, parentheses for grouping.

### Examples

```yaml
# Timing: base advance + MAP offset, clamped to limits
expression: "clamp(GOVNER_AdvanceFromRPM[x] + HOTMAP_AdvanceFromMAPWarmPart[y], RPMLMT_LimitForHotMAPAdvance[x], SPKLMT_TotalAdvanceAllowed[x])"

# Fuel: minimum of part-throttle and WOT, scaled by pumping efficiency
expression: "min(MAPTBL_FuelPartThrottle[y], WOTTBL_FuelFullThrottle[y]) * PEFTBL_PumpingEfficiency[x] / 100"

# Cold enrichment: multiplier based on temp and baro
expression: "1 + (CURVEA_FuelColdEnrichmentCurveA[x] / 32) * BAROCP_BaroCompensationOfWarmupFactor_FromBaro[y] / 256"

# 1D curve (no y-axis)
expression: "AISPN_IdleSpeedParkNeutral_FromTemp[x]"
```

---

## Output Configuration (`OutputConfig`)

Controls default display formatting for the computed grid.

```yaml
output:
  unit: degrees
  range: [-10, 40]
  format: "%.1f"
  invertColorScale: false
```

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `unit` | string | No | — | Unit label shown in tooltips and axis |
| `range` | `[number, number]` | No | — | Fixed min/max for color scaling |
| `format` | string | No | — | C-style format string (e.g., `%.1f`, `%.1f:1`, `%.1f%%`) |
| `invertColorScale` | boolean | No | `false` | If `true`, blue=high and red=low |

---

## Display Modes (`DisplayMode[]`)

Optional alternative transforms for viewing the computed data in different units. When display modes are defined, the user can switch between them via a dropdown.

```yaml
displayModes:
  - id: us
    label: "μs"
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
```

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string | Yes | Unique mode identifier |
| `label` | string | Yes | Human-readable label |
| `transform` | string | Yes | Transform function ID (see below) |
| `inverseTransform` | string | No | Inverse transform ID (required for editable modes) |
| `output` | `OutputConfig` | No | Mode-specific formatting |

### Valid Transform IDs

| Transform | Inverse | Description |
|-----------|---------|-------------|
| `identity` | *(none)* | Pass-through, no transformation |
| `toAFR` | `fromAFR` | Convert pulsewidth (μs) to Air-Fuel Ratio |
| `fromAFR` | `toAFR` | Convert AFR back to pulsewidth (for editing) |
| `toLambda` | `fromLambda` | Convert pulsewidth to Lambda (AFR / 14.7) |
| `fromLambda` | `toLambda` | Convert Lambda back to pulsewidth |
| `toVE` | `fromVE` | Convert pulsewidth to Volumetric Efficiency % |
| `fromVE` | `toVE` | Convert VE% back to pulsewidth |

**Transform requirements:**
- `identity` must not have an `inverseTransform`
- Paired transforms (`toAFR`/`fromAFR`, etc.) must specify each other as inverse
- Transforms other than `identity` require engine metadata (injector size, displacement) for accurate calculation

---

## Complete Example

A full computed view definition file for part-throttle fuel mapping with multiple display modes:

```yaml
# PentaTune Computed View Definitions
# File: fuel-views.yaml

metadata:
  injectorSize: 42    # lb/hr
  displacement: 2.2   # Liters
  referenceTemp: 20   # °C

views:
  - id: fuel-map-part-throttle
    name: Fuel Map (Part Throttle)
    group: Computed Views
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
      - name: WOTTBL_FuelFullThrottle
        editable: true
      - name: PEFTBL_PumpingEfficiency
        editable: false
        note: "VE% - only modify when engine breathing changes (ported heads, cam, etc.)"
    expression: "min(MAPTBL_FuelPartThrottle[y], WOTTBL_FuelFullThrottle[y]) * PEFTBL_PumpingEfficiency[x] / 100"
    displayModes:
      - id: us
        label: "μs"
        transform: identity
        output:
          unit: "μs"
          range: [0, 15000]
      - id: ve
        label: VE%
        transform: toVE
        inverseTransform: fromVE
        output:
          unit: "%"
          range: [50, 120]
          format: "%.1f%%"
          invertColorScale: true
      - id: afr
        label: AFR
        transform: toAFR
        inverseTransform: fromAFR
        output:
          unit: AFR
          range: [10, 18]
          format: "%.1f:1"
      - id: lambda
        label: "λ"
        transform: toLambda
        inverseTransform: fromLambda
        output:
          unit: "λ"
          range: [0.7, 1.2]
          format: "%.2f"
    output:
      unit: "μs"
      range: [0, 15000]
    notes: "Base part-throttle fuel capped at WOT, with pumping efficiency applied. Runtime modifiers (cold enrichment, O2 feedback) not included."
```

---

## Validation Rules

PentaTune validates YAML definitions at load time. Invalid views are skipped and reported in the error log.

### Grid Size Limits

- Maximum **50 cells per axis**
- Calculated as: `((max - min) / interval).ceil() + 1`
- Views exceeding this limit are rejected with an error message

### Duplicate IDs

- View `id` must be unique across **all loaded YAML files**
- Duplicate IDs are rejected with a file-level error

### Transform Validation

- `transform` must be one of the valid IDs listed above
- `inverseTransform` must form a valid pair:
  - `toAFR` ↔ `fromAFR`
  - `toLambda` ↔ `fromLambda`
  - `toVE` ↔ `fromVE`
  - `identity` must have no inverse

### Source Availability

- A view is only available when **all** source parameters exist in the loaded TPL file
- Missing sources are logged but do not prevent other views from loading

---

## Common Errors

### "Grid too large for view 'X': NxM (max 50x50)"

**Cause:** The axis range and interval produce more than 50 breakpoints.

**Fix:** Increase `interval` or reduce the `max - min` range.

### "Duplicate view ID: X"

**Cause:** The same `id` appears in multiple YAML files or multiple times in one file.

**Fix:** Ensure all view IDs are unique across all files in the `computed-views/` directory.

### "Invalid transform ID 'X' in display mode 'Y'"

**Cause:** The `transform` field contains an unrecognized ID.

**Fix:** Use one of: `identity`, `toAFR`, `fromAFR`, `toLambda`, `fromLambda`, `toVE`, `fromVE`.

### "Display mode 'X': Transform 'toAFR' expects inverseTransform 'fromAFR', found 'None'"

**Cause:** A paired transform is missing its `inverseTransform`, or the inverse is mismatched.

**Fix:** Add the correct `inverseTransform` to enable editing in that display mode.

### "Some source parameters not found"

**Cause:** The TPL file does not contain one or more source parameters referenced in the view.

**Fix:** Check parameter names for typos, or load a different calibration file that includes the required tables.

---

## File Locations

| Platform | Path |
|----------|------|
| Windows | `%APPDATA%\PentaTune\computed-views\` |
| macOS | `~/Library/Application Support/PentaTune/computed-views/` |
| Linux | `~/.local/share/PentaTune/computed-views/` |

Place custom YAML files in this directory. PentaTune loads all `.yaml` and `.yml` files on startup. The bundled `defaults.yaml` is automatically copied on first run and can be restored via **Reset Defaults** in the app.

---

## See Also

- [Computed View Editing](../tuning/computed-view-editing.md) — User guide for editing computed views
- [Influence Zone Algorithm](influence-zones.md) — How edits distribute to source tables
- [Display Transforms](display-transforms.md) — Transform function reference
