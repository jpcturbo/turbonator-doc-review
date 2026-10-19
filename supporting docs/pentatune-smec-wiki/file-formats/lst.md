# LST File Format

## Overview

LST (Listing) files contain assembled 68HC11 machine code in human-readable format. They're primarily used for bootloader routines that get uploaded to ECU RAM during flash programming.

## Purpose

LST files provide the machine code needed to:
- Read ROM contents from ECU
- Flash new calibrations to ECU
- Identify chip type
- Erase EEPROM

## File Structure

### Line Format

```
ADDR  BYTES         LABEL     OPCODE  OPERAND    ; COMMENT
0000  CE 00 80               LDX     #$0080     ; Load X with 0x0080
0003  86 FF                  LDAA    #$FF       ; Load A with 0xFF
```

### Components

| Field | Description |
|-------|-------------|
| ADDR | Memory address (hex) |
| BYTES | Machine code bytes |
| LABEL | Optional assembly label |
| OPCODE | Instruction mnemonic |
| OPERAND | Instruction argument |
| COMMENT | Optional description |

## Key LST Files

### BootMainAll.lst

**Purpose:** Main bootloader, loaded first to RAM at 0x0000

**Size:** 256 bytes

**Function:**
- Provides communication framework
- Handles subsequent code uploads
- Stays resident during flash process

### ChipID.lst

**Purpose:** Identify flash chip manufacturer and type

**Load Address:** 0x0080

**Returns:** 2 bytes
- Byte 1: Manufacturer ID
- Byte 2: Device ID

**Common IDs:**
| Manufacturer | ID | Chips |
|--------------|-----|-------|
| ST | 0x20 | M28F256, etc. |
| Toshiba | 0x98 | TC58xxx, etc. |

### ReadAllBytes.lst

**Purpose:** Dump entire ROM contents to serial port

**Load Address:** 0x0080

**Function:**
- Reads ROM from 0x8000-0xFFFF
- Sends bytes over serial
- Used for creating backup .bin files

### SMEC_Flash_BB.lst

**Purpose:** Flash BoostButton SMEC module

**Load Address:** 0x0080

**For:** SMEC with BoostButton flash module

### SBEC_Flash_ST_32k.lst

**Purpose:** Flash SBEC with ST chip

**Load Address:** 0x0080

**For:** SBEC with STMicroelectronics flash chip

**Algorithm:** ST-specific flash protocol

### SBEC_Flash_Tosh_32k.lst

**Purpose:** Flash SBEC with Toshiba chip

**Load Address:** 0x0080

**For:** SBEC with Toshiba flash chip

**Algorithm:** Toshiba-specific flash protocol

### FCC_Flash_ST.lst

**Purpose:** Flash FCC (Neon) with ST chip

**Load Address:** 0x0080

**For:** 1994-1995 Neon FCC

### EraseEEPROM.lst

**Purpose:** Erase internal EEPROM section

**Load Address:** 0x0080

**Function:** Clears adaptive memory at 0xB600-0xB7FF

**Use:** Reset learned values, clear adaptives

## Flash Programming Flow

```
┌─────────────────────────────────────────────┐
│ 1. Bootstrap ECU (apply boot voltage)       │
└─────────────────────┬───────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────┐
│ 2. Upload BootMainAll.lst to 0x0000         │
│    (256 bytes, stays resident)              │
└─────────────────────┬───────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────┐
│ 3. Upload ChipID.lst to 0x0080              │
│    Execute, read response                   │
└─────────────────────┬───────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────┐
│ 4. Select correct flash routine based on ID │
│    ST chip → SBEC_Flash_ST_32k.lst          │
│    Toshiba → SBEC_Flash_Tosh_32k.lst        │
└─────────────────────┬───────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────┐
│ 5. Upload flash routine to 0x0080           │
└─────────────────────┬───────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────┐
│ 6. Send .bin data in 64-byte chunks         │
│    Wait for ACK after each chunk            │
│    Skip EEPROM region (0xB600-0xB7FF)       │
└─────────────────────┬───────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────┐
│ 7. Verify by reading back                   │
└─────────────────────────────────────────────┘
```

## Parsing LST Files

### Extracting Machine Code

To get raw bytes from LST file:

1. Read each line
2. Skip lines without address field
3. Extract hex bytes after address
4. Convert to binary

**Example parsing (Python):**
```python
def parse_lst(filename):
    code = []
    with open(filename, 'r') as f:
        for line in f:
            # Skip empty lines and headers
            if not line.strip() or not line[0].isalnum():
                continue
            # Extract address and bytes
            parts = line.split()
            if len(parts) >= 2:
                try:
                    addr = int(parts[0], 16)
                    # Bytes are between address and mnemonic
                    for i in range(1, len(parts)):
                        if len(parts[i]) == 2:
                            try:
                                byte = int(parts[i], 16)
                                code.append(byte)
                            except ValueError:
                                break
                        else:
                            break
                except ValueError:
                    continue
    return bytes(code)
```

### Load Address

Most LST files specify load address in first line or comments. Common values:
- 0x0000: Main bootloader
- 0x0080: Command routines

## RAM Layout During Flash

```
0x0000  ┌─────────────────────────────┐
        │ BootMainAll (256 bytes)     │
        │ Stays resident              │
0x0080  ├─────────────────────────────┤
        │ Command routine             │
        │ (ChipID, Flash, Read, etc.) │
        │ Replaced for each operation │
0x00FF  └─────────────────────────────┘
```

## Creating Custom LST Files

LST files are output from the 68HC11 assembler. To create:

1. Write 68HC11 assembly source
2. Assemble with listing output enabled
3. Verify load address matches intended use

**Assembly header example:**
```assembly
        .org $0080      ; Load at 0x0080
START:
        LDAA #$FF
        ; ... code ...
        RTS
```

## Common Issues

### Wrong Chip Algorithm
**Symptom:** Flash fails, bricked ECU
**Prevention:** Always ID chip first

### Load Address Mismatch
**Symptom:** Code doesn't execute properly
**Fix:** Verify .org matches upload address

### Corrupt LST File
**Symptom:** Parsing errors, wrong bytes
**Fix:** Re-download from trusted source
