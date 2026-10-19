# Offset Calculator

## Overview

When burning a .bin file to a memory chip, you need to calculate the correct offset to ensure proper alignment. The interrupt vectors must be at the end of the chip's address space.

## The Rule

**The end of your .bin file must align with the end of the chip.**

```
Offset = Chip Size - BIN Size
```

## Quick Reference Table

| BIN Size | Chip Size | Chip Type | Offset (Hex) | Offset (Decimal) |
|----------|-----------|-----------|--------------|------------------|
| 16KB | 16KB | 27C128 | 0x0000 | 0 |
| 16KB | 32KB | 27C256 | 0x4000 | 16,384 |
| 16KB | 64KB | 27SF512 | 0xC000 | 49,152 |
| 32KB | 32KB | 27C256 | 0x0000 | 0 |
| 32KB | 64KB | 27SF512 | 0x8000 | 32,768 |

## Visual Explanation

### 32KB BIN → 32KB Chip (No Offset)

```
Chip:    [████████████████████████████████]
          0x0000                    0x7FFF

BIN:     [████████████████████████████████]
          0x0000                    0x7FFF
                                         ↑
                              Vectors here (end)

Offset: 0x0000 (none needed)
```

### 32KB BIN → 64KB Chip (Offset = 0x8000)

```
Chip:    [                ████████████████████████████████]
          0x0000          0x8000                    0xFFFF
                          ↑
                     Offset here

BIN:                     [████████████████████████████████]
                                                         ↑
                                              Vectors here

Offset: 0x8000 (32KB = 32,768 bytes)
```

### 16KB BIN → 32KB Chip (Offset = 0x4000)

```
Chip:    [                ████████████████]
          0x0000          0x4000    0x7FFF
                          ↑
                     Offset here

BIN:                     [████████████████]
                                         ↑
                              Vectors here

Offset: 0x4000 (16KB = 16,384 bytes)
```

### 16KB BIN → 64KB Chip (Offset = 0xC000)

```
Chip:    [                                ████████████████]
          0x0000                          0xC000    0xFFFF
                                          ↑
                                     Offset here

BIN:                                     [████████████████]
                                                         ↑
                                              Vectors here

Offset: 0xC000 (48KB = 49,152 bytes)
```

## Why This Matters

### Interrupt Vector Location

The 68HC11 CPU expects interrupt vectors at addresses 0xFFD6-0xFFFF (end of memory space). The hardware maps the end of the physical chip to this location.

If your BIN doesn't align:
- Vectors won't be at expected addresses
- CPU won't find interrupt handlers
- ECU won't function at all

### Example of Misalignment

```
WRONG: 32KB BIN at offset 0 in 64KB chip

Chip:    [████████████████████████████████                ]
          0x0000                    0x7FFF           0xFFFF
                                         ↑                ↑
                              Vectors here       CPU looks here
                                                  (finds garbage)
Result: ECU won't start
```

## D-Cal Offset (Different!)

**Warning:** D-Cal uses a different offset concept!

| Context | Purpose | 32KB BIN Value |
|---------|---------|----------------|
| Chip burner | Align BIN in chip | Varies by chip size |
| D-Cal | CPU memory mapping | 0x8000 |

### D-Cal Explanation

D-Cal offset tells the editor where the chip appears in CPU memory:
- 32KB chips appear at 0x8000-0xFFFF → D-Cal offset = 0x8000
- 16KB chips appear at 0xC000-0xFFFF → D-Cal offset = 0xC000

This is NOT the same as the burner offset!

## Common Mistakes

### Using D-Cal Offset for Burner

**Wrong:** "D-Cal says 0x8000, so I'll burn at 0x8000 offset"
**Right:** Calculate burner offset based on BIN and chip sizes

### Wrong Chip Size Assumption

**Wrong:** Assuming all chips are 32KB
**Right:** Check chip part number (128=16k, 256=32k, 512=64k)

### Offset in Wrong Direction

**Wrong:** Putting BIN at start of larger chip
**Right:** BIN must be at END of chip

## Chip Part Number Decoder

| Part Number Suffix | Size | Example |
|--------------------|------|---------|
| 128 | 16KB | 27C128 |
| 256 | 32KB | 27C256, 87C257 |
| 512 | 64KB | 27SF512, 27C512 |

## Verification

After burning, verify:

1. **Read chip back**
2. **Compare to original BIN**
3. **Check vector area specifically:**
   ```
   Last 2 bytes of chip should match
   last 2 bytes of BIN (RESET vector)
   ```

## Calculator Formula

```
if BIN_size <= Chip_size:
    offset = Chip_size - BIN_size
else:
    ERROR: BIN too large for chip

# Examples:
32KB chip, 32KB BIN: offset = 32768 - 32768 = 0
64KB chip, 32KB BIN: offset = 65536 - 32768 = 32768 (0x8000)
32KB chip, 16KB BIN: offset = 32768 - 16384 = 16384 (0x4000)
64KB chip, 16KB BIN: offset = 65536 - 16384 = 49152 (0xC000)
```
