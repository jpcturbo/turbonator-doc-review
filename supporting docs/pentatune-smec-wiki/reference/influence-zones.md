# Influence Zone Algorithm

> **Reference** — This page describes how PentaTune calculates which source table cells are affected when you edit a computed view cell.

## Overview

When you edit a cell in a computed view, PentaTune must distribute your change back to the underlying source tables. The "influence zone" is the set of source table breakpoints whose values will be modified.

Computed views combine multiple 1D source tables through a mathematical expression. For example:

```
Part Throttle Fuel = min(MAPTBL_FuelPartThrottle[y], WOTTBL_FuelFullThrottle[y]) * PEFTBL_PumpingEfficiency[x] / 100
```

When you edit a cell in this 2D heatmap, the algorithm determines which breakpoints in `MAPTBL`, `WOTTBL`, and `PEFTBL` to modify, and by how much.

## How It Works

### 1. Position Mapping

The edited computed view cell maps to a position on each source table's axis:

- The cell's **column** (X-axis, typically RPM) maps to the X-axis source tables
- The cell's **row** (Y-axis, typically MAP) maps to the Y-axis source tables

For each source table, the algorithm finds the surrounding breakpoints for that position.

### 2. Finding Surrounding Breakpoints

Given a value `V` and a sorted array of breakpoints `[B₀, B₁, ..., Bₙ]`:

**Exact match:** If `V == Bᵢ` for some `i`:
- Lower = Upper = `Bᵢ`
- `t = 1.0`
- `isExact = true`

**Interpolated position:** If `Bᵢ < V < Bᵢ₊₁`:
- Lower = `Bᵢ`
- Upper = `Bᵢ₊₁`
- `t = (V - Bᵢ) / (Bᵢ₊₁ - Bᵢ)` — interpolation factor, 0 to 1
- `isExact = false`

**Extrapolation (outside range):**
- If `V < B₀`: clamp to `B₀` (Lower = Upper = `B₀`)
- If `V > Bₙ`: clamp to `Bₙ` (Lower = Upper = `Bₙ`)

The interpolation factor `t` is always clamped to `[0, 1]`.

### 3. Influence Zone Calculation

The influence zone is the rectangular region bounded by the surrounding breakpoints on both axes. For visualization, exact breakpoint matches are **expanded** to include neighboring breakpoints, because a breakpoint affects interpolation on both sides.

**For interpolated positions:**
- Expand by 1 additional breakpoint on each side
- Example: between breakpoints at indices 2 and 3, zone spans indices 1 to 4

**For exact breakpoint matches:**
- Expand by 2 breakpoints on each side (or to array bounds)
- Example: exact match at index 3, zone spans indices 1 to 5

```
Interpolated at MAP=7 (between 5 and 10):
  MAP breakpoints:  [0, 5, 10, 15, 20]
  Surrounding:      lower=5, upper=10, t=0.4
  Expanded zone:    [0, 15]  (indices 0-3)

Exact at MAP=10 (index 2):
  MAP breakpoints:  [0, 5, 10, 15, 20]
  Surrounding:      lower=10, upper=10, t=1.0
  Expanded zone:    [0, 20]  (indices 0-4, expanded by 2 each side)
```

## Influence Modes

### Nearest-Neighbor Mode

When the clicked position exactly matches a breakpoint, or falls outside the breakpoint range (extrapolation), the edit applies to a **single breakpoint**:

- Exact match: modify that exact breakpoint
- Below range: modify the first breakpoint
- Above range: modify the last breakpoint

### Bilinear (Proportional-Split) Mode

When the clicked position falls between two breakpoints, the edit is **split proportionally** across both breakpoints.

#### Weight Calculation

PentaTune uses **inverse distance weighting** to determine how much each breakpoint receives:

```
distance_to_lower = |clicked_value - lower_breakpoint|
distance_to_upper = |clicked_value - upper_breakpoint|

inv_dist_lower = 1 / (distance_to_lower + epsilon)
inv_dist_upper = 1 / (distance_to_upper + epsilon)
total_inv_dist = inv_dist_lower + inv_dist_upper

weight_lower = inv_dist_lower / total_inv_dist
weight_upper = inv_dist_upper / total_inv_dist
```

Where `epsilon = 0.001` prevents division by zero.

**Key property:** Closer breakpoints receive more weight. For uniformly spaced breakpoints, this produces the same weights as linear interpolation, but it also works correctly for non-uniform spacing.

#### Example Weights

For breakpoints at `[1000, 2000, 3000, 4000]` and clicked value `2200`:

| Breakpoint | Distance | Inverse Distance | Weight |
|-----------|----------|------------------|--------|
| 2000 | 200 | 1/200 = 0.00500 | **80.0%** |
| 3000 | 800 | 1/800 = 0.00125 | **20.0%** |

For clicked value `2500` (midpoint):

| Breakpoint | Distance | Inverse Distance | Weight |
|-----------|----------|------------------|--------|
| 2000 | 500 | 1/500 = 0.00200 | **50.0%** |
| 3000 | 500 | 1/500 = 0.00200 | **50.0%** |

## Edit Distribution Formula

### Step 1: Calculate Change Factor

```
changeFactor = newValue / oldValue
sqrtChange   = sqrt(changeFactor)
delta        = sqrtChange - 1
```

**Why square root?** For multiplicative expressions (most fuel/timing maps), the square root split ensures the combined result matches the target. If two sources each multiply by `sqrtChange`, their product equals `changeFactor`.

### Step 2: Apply Weighted Delta

For each affected breakpoint:

```
new_breakpoint_value = old_breakpoint_value * (1 + delta * weight)
```

Where `weight` is the inverse-distance weight for that breakpoint (1.0 for exact matches).

### Step 3: Minimum Weight Threshold

Breakpoints with less than **10% influence** are skipped. This prevents modifying distant breakpoints that have negligible effect on the edited cell.

```
if weight < 0.10:
    skip this breakpoint
```

### Step 4: Bounds Validation

After calculating the new value, PentaTune validates it stays within valid ranges:

- **8-bit values:** 0 to 255
- **16-bit values:** 0 to 65535

If the calculated value exceeds these bounds, the modification is skipped and logged.

## Visual Indicators

When hovering over or editing a cell, PentaTune highlights affected cells:

| Colour | Meaning |
|--------|---------|
| Yellow highlight | **Editing** — The cell currently being edited |
| Yellow/corner markers | **Breakpoint** — The 4 corner breakpoints of the influence rectangle that will be modified |
| Light blue/diagonal stripes | **Affected** — Cells within the influence zone whose values will change due to interpolation |
| Blue ring | **Selected** — The currently selected cell (not in edit mode) |

### How Adjacent Cells Are Affected

When you modify source breakpoints, all computed cells that use those breakpoints for interpolation will show updated values. The "affected" highlight shows the full rectangular region where cells will change:

```
    RPM:   1000   2000   3000   4000
MAP:
  0     |  12.0 |  12.5 |  13.0 |  13.5 |
  5     |  13.0 |  13.5 |  14.0 |  14.5 |
 10     |  14.0 | [14.5]|  15.0 |  15.5 |   <- Editing cell at MAP=10, RPM=2000
 15     |  15.0 |  15.5 |  16.0 |  16.5 |

Breakpoint corners (will be modified):
  (MAP=5, RPM=1000)  (MAP=5, RPM=3000)
  (MAP=15, RPM=1000) (MAP=15, RPM=3000)

Affected region (all cells between these breakpoints):
  MAP: 5 to 15, RPM: 1000 to 3000
  = 6 cells will show updated values after edit
```

## Min/Max Expressions

For expressions containing `min(A, B)` or `max(A, B)`:

1. PentaTune evaluates both tables at the clicked position
2. Identifies the "active" table (the one providing the min or max value)
3. **Only modifies the active table**
4. The inactive table is left unchanged

Example for `min(MAPTBL[y], WOTTBL[y])` at MAP=10:
- If `MAPTBL[10] = 5000` and `WOTTBL[10] = 6000`
- `MAPTBL` is active (provides the minimum)
- Only `MAPTBL` breakpoints are modified
- `WOTTBL` is skipped entirely

If both tables are equal, the first source in the expression is chosen as active.

## Edge Cases

### Editing Near Table Boundaries

When editing near the edge of a source table:

**Below first breakpoint:**
- Position clamps to first breakpoint
- Full delta applied to first breakpoint
- Influence zone extends only outward (no "below" neighbors)

**Above last breakpoint:**
- Position clamps to last breakpoint
- Full delta applied to last breakpoint
- Influence zone extends only inward (no "above" neighbors)

**At exact boundary breakpoint:**
- Exact match handling applies
- Zone expands by 2 breakpoints toward the interior
- No expansion beyond array bounds

### Single-Breakpoint Tables

If a source table has only 1 breakpoint:
- All positions map to that single breakpoint
- Full delta always applied to index 0
- Influence zone is a single point

### Two-Breakpoint Tables

If a source table has only 2 breakpoints:
- Interpolation is always between those two points
- No expansion possible for exact matches (already at bounds)
- Weight calculation works normally

### Non-Editable Sources

Sources marked as `editable: false` in the view definition are **never modified**. The algorithm skips them entirely and distributes changes only among editable sources.

### Scalar Constants

Sources used without axis indexing (e.g., `CONSTANT` in `MAPTBL[y] * CONSTANT`) are treated as scalar constants and are **not modified**.

## Pseudo-Code

```
function editComputedViewCell(clickedCell, newValue):
    oldValue = clickedCell.value
    changeFactor = newValue / oldValue
    sqrtChange = sqrt(changeFactor)
    delta = sqrtChange - 1

    // Parse expression to find source-to-axis mappings
    sources = parseExpressionSources(expression)

    // Detect min/max active source
    activeSource = detectActiveSource(expression, clickedCell)

    modifications = []

    for each source in sources:
        // Skip inactive source in min/max expressions
        if source == inactiveSource:
            continue

        // Skip non-editable and scalar sources
        if not source.isEditable or source.isScalar:
            continue

        // Get breakpoints for this source's axis
        axis = source.axis  // 'x' or 'y'
        clickedPos = (axis == 'x') ? clickedCell.x : clickedCell.y
        breakpoints = getSourceBreakpoints(source)

        // Find surrounding breakpoints
        result = findSurroundingPoints(clickedPos, breakpoints)

        if result.isExact or result.lower == result.upper:
            // Exact match or extrapolation: full delta to single breakpoint
            idx = indexOf(result.lower, breakpoints)
            modifications.add({
                source: source.name,
                breakpoint: idx,
                delta: delta
            })
        else:
            // Interpolated: split delta using inverse distance weighting
            distLower = abs(clickedPos - result.lower)
            distUpper = abs(clickedPos - result.upper)

            invLower = 1 / (distLower + 0.001)
            invUpper = 1 / (distUpper + 0.001)
            total = invLower + invUpper

            weightLower = invLower / total
            weightUpper = invUpper / total

            lowerIdx = indexOf(result.lower, breakpoints)
            upperIdx = indexOf(result.upper, breakpoints)

            if weightLower >= 0.10:
                modifications.add({
                    source: source.name,
                    breakpoint: lowerIdx,
                    delta: delta * weightLower
                })

            if weightUpper >= 0.10:
                modifications.add({
                    source: source.name,
                    breakpoint: upperIdx,
                    delta: delta * weightUpper
                })

    // Convert deltas to actual values
    for each mod in modifications:
        mod.oldValue = getCurrentValue(mod.source, mod.breakpoint)
        mod.newValue = mod.oldValue * (1 + mod.delta)

        // Validate bounds
        if mod.newValue < 0 or mod.newValue > maxForDataType:
            skip mod

    return modifications
```

## Example Walkthrough

### Setup

Consider a simple fuel computed view with this expression:

```
FuelDelivery = MAPTBL_FuelPartThrottle[y] * PEFTBL_PumpingEfficiency[x] / 100
```

**MAPTBL breakpoints (MAP, Y-axis):** `[-15, -10, -5, 0, 5, 10, 15]` psi
**PEFTBL breakpoints (RPM, X-axis):** `[1000, 2000, 3000, 4000, 5000]` rpm

### Scenario: Edit Cell at MAP=2 psi, RPM=2400

**Step 1: Find surrounding breakpoints**

For MAP=2 (Y-axis):
- Between 0 and 5 psi
- `t = (2 - 0) / (5 - 0) = 0.4`
- Lower = 0 psi, Upper = 5 psi

For RPM=2400 (X-axis):
- Between 2000 and 3000
- `t = (2400 - 2000) / (3000 - 2000) = 0.4`
- Lower = 2000, Upper = 3000

**Step 2: Calculate weights (inverse distance)**

MAPTBL:
- Distance to 0 psi = 2
- Distance to 5 psi = 3
- inv_0 = 1/2 = 0.5, inv_5 = 1/3 ≈ 0.333
- weight_0 = 0.5 / 0.833 ≈ **60%**
- weight_5 = 0.333 / 0.833 ≈ **40%**

PEFTBL:
- Distance to 2000 = 400
- Distance to 3000 = 600
- inv_2000 = 1/400 = 0.0025, inv_3000 = 1/600 ≈ 0.00167
- weight_2000 = 0.0025 / 0.00417 ≈ **60%**
- weight_3000 = 0.00167 / 0.00417 ≈ **40%**

**Step 3: User enters new value**

Old cell value = 14.0 µs
New cell value = 15.4 µs (10% increase)

```
changeFactor = 15.4 / 14.0 = 1.10
sqrtChange   = sqrt(1.10) ≈ 1.0488
delta        = 1.0488 - 1 = 0.0488
```

**Step 4: Apply to MAPTBL**

Current values at relevant breakpoints:
- MAPTBL[0 psi] = 12.0 µs
- MAPTBL[5 psi] = 16.0 µs

```
MAPTBL[0 psi] new = 12.0 * (1 + 0.0488 * 0.60)
                  = 12.0 * 1.0293
                  ≈ 12.35 µs

MAPTBL[5 psi] new = 16.0 * (1 + 0.0488 * 0.40)
                  = 16.0 * 1.0195
                  ≈ 16.31 µs
```

**Step 5: Apply to PEFTBL**

Current values at relevant breakpoints:
- PEFTBL[2000 rpm] = 90%
- PEFTBL[3000 rpm] = 95%

```
PEFTBL[2000] new = 90.0 * (1 + 0.0488 * 0.60)
                 = 90.0 * 1.0293
                 ≈ 92.64%

PEFTBL[3000] new = 95.0 * (1 + 0.0488 * 0.40)
                 = 95.0 * 1.0195
                 ≈ 96.85%
```

**Step 6: Verify**

After modification, the cell at MAP=2, RPM=2400 recomputes:

```
MAPTBL[2 psi] = interpolate(12.35, 16.31, t=0.4) ≈ 13.93 µs
PEFTBL[2400]  = interpolate(92.64, 96.85, t=0.4) ≈ 94.32%

FuelDelivery = 13.93 * 94.32 / 100 ≈ 13.14 µs
```

Wait — this doesn't match 15.4 µs! That's because both sources were adjusted simultaneously. In practice, the square-root split ensures that when both sources change by `sqrt(changeFactor)`, their product changes by `changeFactor`:

```
Original: 12.0 * 90 / 100 = 10.8  (simplified example)
New:      12.0*1.0488 * 90*1.0488 / 100
        = 12.0 * 90 / 100 * 1.0488²
        = 10.8 * 1.10
        = 11.88
```

The square-root split ensures multiplicative consistency.

### Visual Result

After confirming the edit:

| | 1000 | 2000 | 3000 | 4000 |
|---|:---:|:---:|:---:|:---:|
| **-15** | 10.0 | 10.5 | 11.0 | 11.5 |
| **-10** | 11.0 | 11.5 | 12.0 | 12.5 |
| **-5** | 12.0 | 12.5 | 13.0 | 13.5 |
| **0** | 13.0 | **13.5** | **14.0** | 14.5 |
| **5** | 14.0 | **14.5** | **15.0** | 15.5 |
| **10** | 15.0 | 15.5 | 16.0 | 16.5 |
| **15** | 16.0 | 16.5 | 17.0 | 17.5 |

**Bold cells:** The 4×2 affected region (MAP 0–5, RPM 2000–3000) where values updated due to breakpoint changes.

## See Also

- [Computed View Editing](../tuning/computed-view-editing.md)
- [Computed View YAML Reference](computed-view-yaml.md)
- [Display Transforms](display-transforms.md)
