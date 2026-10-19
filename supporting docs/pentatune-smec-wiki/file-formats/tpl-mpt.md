# TPL/MPT File Format

## Overview

TPL (Template) and MPT (MP Tuner project) files are plain ASCII text files containing calibration data and metadata. They use assembly-like syntax and are the primary format for MPTune.

## Format Comparison

| Aspect | TPL | MPT |
|--------|-----|-----|
| Purpose | Template for building new .bin | Project for editing existing .bin |
| Contains code | Reference only | Reference only |
| Data values | Editable calibration | Editable calibration |
| Used with | .asm file for assembly | Existing .bin file |
| Creates | New .bin when assembled | Modified .bin |

Both formats use identical syntax. The distinction is in how MPTune uses them.

## File Structure

### Header Section

```assembly
;mpver 2.00                    ; MPTune version
;mpassmfile t-smec_v19.asm     ; Source assembly reference
.org DataOrg                   ; Origin directive (0x8000)
;mpinjsize 34.9                ; Injector size (lb/hr)
;mpbar 2.0                     ; MAP sensor bar rating
```

### Parameter Block

```assembly
LABEL_NAME:
    ;mpgrp 0_-_Setup\B_-_Cal_ID\           ; GUI tree path
    ;mptbladdr 0x01A3                       ; ROM address offset
    ;mptbltype 4                            ; Data type
    ;mptbllname ECU_Calibration_ID          ; Display name
    ;mptblcname ENDITM                      ; Code name
    ;mpxaxis X 0 255 raw                    ; X-axis definition
    ;mpyaxis Output 0 255 units             ; Y-axis definition
    ;mptbldesc Description_text_here        ; Description
    .word 0xA553                            ; Actual data value
```

### Group Markers

```assembly
;mpgroupstart 1_-_Fuel\        ; Begin group (for tree organization)
; ... parameters ...
;mpgroupend                    ; End group
```

## Metadata Prefixes

### Required Prefixes

| Prefix | Purpose | Example |
|--------|---------|---------|
| `;mpgrp` | GUI tree hierarchy | `0_-_Setup\B_-_Cal_ID\` |
| `;mptbladdr` | ROM address offset | `0x01A3` |
| `;mptbltype` | Data type ID | `4` |
| `;mptbllname` | Display name | `ECU_Calibration_ID` |

### Optional Prefixes

| Prefix | Purpose | Example |
|--------|---------|---------|
| `;mptblcname` | Code name (internal) | `ENDITM` |
| `;mpxaxis` | X-axis definition | `RPM 0 8000 rpm` |
| `;mpyaxis` | Y-axis definition | `Timing 0 60 deg` |
| `;mptbldesc` | Parameter description | `Spark_advance_table` |

### Header Prefixes

| Prefix | Purpose | Example |
|--------|---------|---------|
| `;mpver` | MPTune version | `2.00` |
| `;mpassmfile` | ASM file reference | `t-smec_v19.asm` |
| `;mpinjsize` | Injector flow rate | `34.9` |
| `;mpbar` | MAP sensor range | `2.0` |

## Group Path Format

The `;mpgrp` prefix defines where a parameter appears in the GUI tree.

### Syntax

```
Level1_-_Level2\Sublevel_-_Name\
```

### Components

- **`_-_`** (underscore-hyphen-underscore) - Separates hierarchy levels
- **`\`** (backslash) - Terminates each level

### Examples

```assembly
;mpgrp 0_-_Setup\A_-_Basic\
; Appears under: Setup > Basic

;mpgrp 1_-_Fuel\A_-_Injector\C_-_Flow_Rate\
; Appears under: Fuel > Injector > Flow Rate

;mpgrp 2_-_Timing\B_-_WOT_Tables\
; Appears under: Timing > WOT Tables
```

### Sorting

The leading numbers/letters determine sort order:
- `0_-_Setup` comes before `1_-_Fuel`
- `A_-_Basic` comes before `B_-_Advanced`

## Data Types (mptbltype)

| Type | Name | Size | Description |
|------|------|------|-------------|
| 0 | Table 1D | Variable | One-dimensional lookup table (variable length) |
| 2 | Table 1D | Variable | One-dimensional lookup table (variable length) |
| 3 | Byte | 1 byte | 8-bit unsigned value |
| 4 | Word | 2 bytes | 16-bit unsigned value |
| 5 | Byte | 1 byte | 8-bit unsigned value |
| 6 | Signed Byte | 1 byte | 8-bit signed value |
| 7 | Table 2D | Variable | Two-dimensional lookup table |
| 8 | Bitfield | 1 byte | Individual bit flags |
| 9 | String | Variable | ASCII text string |
| 10 | Byte Array | Variable | Array of bytes |
| 11 | Word Array | Variable | Array of 16-bit words |
| 12 | Signed Word | 2 bytes | 16-bit signed value |

### Common Types

**Type 3/5 (Byte):** Single 8-bit value
```assembly
;mptbltype 3
.byte 0x55
```

**Type 4 (Word):** Single 16-bit value
```assembly
;mptbltype 4
.word 0xA553
```

**Type 0/2 (Table 1D):** Variable-length lookup table
```assembly
;mptbltype 0
.byte 0x00, 0x10, 0x20, 0x30, 0x40
```

## Data Directives

### Byte Directive
```assembly
.byte 0x55           ; Single byte
.byte 0x00, 0x10     ; Multiple bytes
.byte 128            ; Decimal value
```

### Word Directive
```assembly
.word 0xA553         ; Single 16-bit word (big-endian)
.word 0x1234, 0x5678 ; Multiple words
```

### Block Directive
```assembly
.blkb 16             ; Reserve 16 bytes (typically zeros)
.blkw 8              ; Reserve 8 words
```

## Axis Definitions

### X-Axis
```assembly
;mpxaxis Name Min Max Unit
;mpxaxis RPM 0 8000 rpm
;mpxaxis MAP 0 255 kPa
```

### Y-Axis
```assembly
;mpyaxis Name Min Max Unit
;mpyaxis Timing 0 60 degrees
;mpyaxis PW 0 25.6 ms
```

Axis definitions are used for:
- Graph labeling
- Value scaling in display
- Table visualization

## Address Calculation

### Important: mptbladdr is an OFFSET

The `mptbladdr` value is an offset from 0x8000, NOT an absolute address:

```assembly
;mptbladdr 0x01A3    ; This is OFFSET from 0x8000
```

**To get absolute address:**
```
absolute = 0x8000 + mptbladdr
         = 0x8000 + 0x01A3
         = 0x81A3
```

**To get file offset (for .bin file):**
```
file_offset = mptbladdr (same value)
            = 0x01A3 (byte 419 in file)
```

## Complete Example

```assembly
;mpver 2.00
;mpassmfile t-smec_v19.asm
.org DataOrg
;mpinjsize 34.9
;mpbar 2.0

;mpgroupstart 0_-_Setup\
CAL_ID:
    ;mpgrp 0_-_Setup\A_-_Cal_ID\
    ;mptbladdr 0x01A3
    ;mptbltype 4
    ;mptbllname Calibration_ID
    ;mptblcname CALID
    ;mpxaxis X 0 65535 raw
    ;mpyaxis Y 0 65535 raw
    ;mptbldesc Calibration_identifier_word
    .word 0x1234
;mpgroupend

;mpgroupstart 1_-_Fuel\
PUMP_EFF:
    ;mpgrp 1_-_Fuel\B_-_Pump_Efficiency\
    ;mptbladdr 0x0322
    ;mptbltype 0
    ;mptbllname Pumping_Efficiency
    ;mptblcname PMPEFF
    ;mpxaxis RPM 0 8000 rpm
    ;mpyaxis VE 0 100 percent
    ;mptbldesc Volumetric_efficiency_vs_RPM
    .byte 0x50, 0x55, 0x5A, 0x5F, 0x64, 0x69
    .byte 0x6E, 0x73, 0x78, 0x7D, 0x82
;mpgroupend
```

## Parsing Guidelines

### For Software Developers

1. **Read line by line** - Files are text-based, line-oriented
2. **Match `;mp` prefix** - Identifies metadata lines
3. **Extract label** - Lines ending with `:` are labels
4. **Parse data directives** - `.byte`, `.word`, `.blkb`
5. **Build tree from `;mpgrp`** - Use hierarchy for GUI organization
6. **Calculate addresses** - Add 0x8000 to mptbladdr for absolute

### Common Parsing Mistakes

| Mistake | Fix |
|---------|-----|
| Treating mptbladdr as absolute | Add 0x8000 during parsing |
| Parsing `_-_` incorrectly | It's underscore-hyphen-underscore |
| Wrong endianness | 68HC11 is big-endian |
| Missing hierarchy separator | Look for `\` at end of each level |

## File Encoding

- Plain ASCII text
- Line endings: CR+LF (Windows) or LF (Unix)
- No BOM (Byte Order Mark)
- Comments start with `;` (except metadata prefixes)
