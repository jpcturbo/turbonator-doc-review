# BIN File Format

## Overview

The .bin file is a flat binary ROM image with no header or metadata. It contains both the executable code and calibration data that runs on the ECU.

## Format Specification

| Property | Value |
|----------|-------|
| Size | 16,384 (16KB) or 32,768 (32KB) bytes |
| Header | None |
| Byte order | Big-endian (Motorola) |
| File offset 0 | Maps to CPU address 0x8000 (32KB) or 0xC000 (16KB) |

## File Sizes by ECU

| ECU/Year | Size | Notes |
|----------|------|-------|
| 1988 Turbo I | 16KB | |
| 1988/89 Turbo II | 16KB | S60-based |
| 1989 Turbo I | 32KB | |
| All SBEC | 32KB | |
| T-SMEC (Turbonator) | 32KB | |
| T-SBEC (Turbonator) | 32KB | |

## Memory Mapping

### 32KB BIN File
```
BIN File                    CPU Address Space
─────────────               ─────────────────
Offset 0x0000  ◄────────►   Address 0x8000
Offset 0x0001  ◄────────►   Address 0x8001
...
Offset 0x3600  ◄────────►   Address 0xB600  ┐
...                                         │ EEPROM
Offset 0x37FF  ◄────────►   Address 0xB7FF  ┘
...
Offset 0x7FD6  ◄────────►   Address 0xFFD6  ┐
...                                         │ Vectors
Offset 0x7FFF  ◄────────►   Address 0xFFFF  ┘
```

### Address Conversion

**CPU address to file offset:**
```
file_offset = cpu_address - 0x8000
```

**File offset to CPU address:**
```
cpu_address = file_offset + 0x8000
```

**Examples:**
```
CPU 0x81BA → File offset 0x01BA (byte 442)
CPU 0xB600 → File offset 0x3600 (byte 13,824)
CPU 0xFFFF → File offset 0x7FFF (byte 32,767)
```

## Critical Regions

### Calibration Data (0x0000-0x0FFF in file)

**CPU addresses 0x8000-0x8FFF**

Contains tunable parameters:
- Fuel tables
- Timing tables
- Boost targets
- Sensor scaling
- Thresholds

This is the primary region edited during tuning.

### Executable Code (0x1000+ in file)

**CPU addresses 0x9000+**

Contains:
- Main program loop
- Interrupt handlers
- Calculation routines
- I/O drivers

Generally not modified during tuning (requires source code and assembler).

### EEPROM Gap (0x3600-0x37FF in file)

**CPU addresses 0xB600-0xB7FF**

**CRITICAL: Skip this region during flash programming!**

Contains:
- Adaptive fuel trim
- Knock adaptation
- Learned idle position
- Other learned values

Overwriting this region:
1. Causes poor running
2. Triggers fault codes
3. Requires extended relearn period

### Interrupt Vectors (0x7FD6-0x7FFF in file)

**CPU addresses 0xFFD6-0xFFFF**

Contains 26 interrupt vectors (2 bytes each):
- Each vector is an address pointing to handler code
- RESET vector at 0xFFFE is most critical
- Must be at absolute end of memory space

## Byte Order

The 68HC11 is big-endian (Motorola byte order):

**16-bit value 0x1234 stored at offset 0x0100:**
```
Offset 0x0100: 0x12 (high byte)
Offset 0x0101: 0x34 (low byte)
```

This is the opposite of Intel x86 (little-endian).

### Reading 16-bit Values

**In Python:**
```python
with open('file.bin', 'rb') as f:
    f.seek(offset)
    word = int.from_bytes(f.read(2), 'big')
```

**In Rust:**
```rust
let word = u16::from_be_bytes([data[offset], data[offset+1]]);
```

**In JavaScript:**
```javascript
const word = (data[offset] << 8) | data[offset + 1];
```

## Creating BIN Files

### From Template (Recommended)

1. Open .tpl file in MPTune
2. Make calibration changes
3. Select matching .asm file
4. Assemble to create new .bin

### From Existing BIN

1. Open .bin with matching .mpt file
2. Make calibration changes
3. Save as new .bin

### Manual Editing

Not recommended unless you understand:
- Exact memory layout
- Data type at each address
- Scaling factors
- Checksum requirements (if any)

## Verifying BIN Files

### Size Check
- 16KB = exactly 16,384 bytes
- 32KB = exactly 32,768 bytes

### Vector Check
Verify reset vector points to valid code:
```
Read bytes at offset 0x7FFE-0x7FFF (32KB file)
Value should be in range 0x9000-0xFFA0
```

### Checksum
Some tools/firmwares use checksums. Verify with original known-good file if available.

## Burning to Chip

### Offset Calculation

When burning BIN to chip, calculate offset to align end of file with end of chip:

| BIN Size | Chip Size | Burner Offset |
|----------|-----------|---------------|
| 16KB | 16KB | 0x0000 |
| 16KB | 32KB | 0x4000 |
| 16KB | 64KB | 0xC000 |
| 32KB | 32KB | 0x0000 |
| 32KB | 64KB | 0x8000 |

### Verification

After burning:
1. Read chip back
2. Compare to original file
3. Verify all bytes match

## Common Problems

### Wrong Endianness
**Symptom:** Values appear byte-swapped
**Fix:** Use big-endian byte order

### Wrong Offset
**Symptom:** ECU doesn't start, random behavior
**Fix:** Recalculate and verify offset

### EEPROM Overwrite
**Symptom:** Poor running, adaptation issues
**Fix:** Re-flash skipping 0xB600-0xB7FF, or let ECU relearn

### Truncated File
**Symptom:** Missing data, crash at certain operations
**Fix:** Verify file is exactly 16KB or 32KB

## Binary Diff

To compare two BIN files:

**Linux/Mac:**
```bash
cmp -l file1.bin file2.bin | head -20
xxd file1.bin > file1.hex
xxd file2.bin > file2.hex
diff file1.hex file2.hex
```

**Using hexdump:**
```bash
hexdump -C file1.bin > file1.txt
hexdump -C file2.bin > file2.txt
diff file1.txt file2.txt
```

This helps identify what changed between calibrations.
