# Parameter Editing Basics

> **Stub** — This page introduces the parameter editors available in PentaTune.

## Overview

PentaTune provides several editor types depending on the parameter's data shape:

| Editor | Used For |
|--------|---------|
| **GridEditor** | 2D tables (MAP × RPM, etc.) |
| **CurveEditor** | 1D tables / curves (single axis) |
| **SliderEditor** | Single scalar constants |
| **BitfieldEditor** | Packed bit flags |
| **DropdownEditor** | Enumerated values |

## Common Operations

### Editing a Cell

1. Click the cell to select it
2. Type the new value
3. Press **Enter** to confirm or **Escape** to cancel

### Selecting a Range

Click and drag (GridEditor/CurveEditor) to select multiple cells. Paste a copied range or type a value to fill all selected cells.

### Undo / Redo

Use **Ctrl+Z** / **Ctrl+Y**. Changes are tracked per-table.

## Computed View Editing

Computed views combine multiple source tables into a single editable surface. Edits are distributed back to source tables via the influence zone algorithm.

See [Computed View Editing](computed-view-editing.md) for details.

## See Also

- [Computed View Editing](computed-view-editing.md)
- [Computed View YAML Reference](../reference/computed-view-yaml.md)
- [Fuel System](fuel-system.md)
- [Ignition Timing](ignition-timing.md)
