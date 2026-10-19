# D-Cal

## Overview

D-Cal is a binary editor for Chrysler ECU calibrations. It predates MPTune and is still used by some tuners.

## Features

- Binary file editing
- Table visualization
- Constant editing
- Limited flash support (RS232 only)

## File Types

### BIN Files

The actual ROM image. D-Cal edits these directly.

### TBL Files

Table files containing:
- Memory addresses
- Data types
- Scaling factors
- Parameter names

Without the correct .tbl file, D-Cal can't interpret the binary data.

## D-Cal vs MPTune

| Feature | D-Cal | MPTune |
|---------|-------|--------|
| Binary editing | Yes | Yes |
| Template building | No | Yes |
| USB flash support | No | Yes |
| RS232 flash | Yes | Yes |
| Active development | No | Limited |

## D-Cal Offset

D-Cal uses an offset to map file bytes to CPU addresses:

| Chip/BIN Size | D-Cal Offset |
|---------------|--------------|
| 32KB | 0x8000 |
| 16KB | 0xC000 |

**This is different from chip burner offset!**

The D-Cal offset tells the software where the chip appears in CPU memory space:
- 32KB chip maps to 0x8000-0xFFFF
- 16KB chip maps to 0xC000-0xFFFF

## Basic Usage

### Opening a Calibration

1. Start D-Cal
2. Open .bin file
3. When prompted, enter D-Cal offset (0x8000 for 32KB)
4. Load matching .tbl file
5. Tables appear in tree view

### Editing Values

1. Navigate to table in tree
2. Double-click to open
3. Edit cells as needed
4. Save when done

### Saving

- Save updates the .bin file
- Keep backups!
- Original is overwritten

## Limitations

### No Template Support

D-Cal cannot:
- Create new binaries from templates
- Combine .tpl + .asm files
- Work with .mpt files

For these features, use MPTune.

### RS232 Only for Flash

D-Cal's flash function only works with dedicated RS232 serial ports:
- USB-to-serial adapters don't work
- Most modern computers lack RS232
- Use MPTune for USB flash cables

### Limited Development

D-Cal is no longer actively developed:
- No new features
- No bug fixes
- May have compatibility issues on modern Windows

## When to Use D-Cal

- You have existing .tbl files
- You prefer its interface
- You're doing simple scalar/table edits
- You have native RS232 port for flashing

## When to Use MPTune Instead

- You want USB flash support
- You need to build from templates
- You want more features
- You're starting fresh

## Creating TBL Files

TBL files must be created for each calibration:
- Define addresses, types, scaling
- Most common cals have existing .tbl files
- Repository has community-created files

## CHeM / CHeM2

Alternative to D-Cal with similar function:
- Uses .calx files instead of .tbl
- Different interface
- Also for binary editing only
