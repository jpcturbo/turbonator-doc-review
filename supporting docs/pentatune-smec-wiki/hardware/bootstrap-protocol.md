# Bootstrap Protocol

## Overview

The 68HC11 microcontroller has a built-in bootstrap mode that allows loading code into RAM via serial port. This is the foundation for all ECU programming operations.

## Bootstrap Mode Entry

### Hardware Requirements

The 68HC11 enters bootstrap mode based on pin states at power-on:

| Pin | State | Function |
|-----|-------|----------|
| MODA | Low | Mode select A |
| MODB | High | Mode select B |

In the ECU, this is achieved by applying voltage to the bootstrap pin while powering on.

### SMEC Bootstrap

**Pin 11 of 60-way connector**

| Application | Voltage | Notes |
|-------------|---------|-------|
| BoostButton module | 12V | Use toggle switch |
| Stock SMEC (read only) | 21V+ | 9V battery + 12V |

**Sequence:**
1. Apply voltage to pin 11
2. Turn key to RUN
3. ECU enters bootstrap mode
4. Fuel pump does NOT prime (normal)

### SBEC Bootstrap

**Boot wire on SCI cable**

| Application | Voltage | Notes |
|-------------|---------|-------|
| BoostButton/Stock | 12V | Momentary application |

**Sequence:**
1. Press boot button (apply 12V)
2. Turn key to RUN
3. Release button within ~1 second
4. ECU enters bootstrap mode

## Serial Communication

### Initial Parameters

| Parameter | Current PentaTune/MPTune bootstrap behavior |
|-----------|---------------------------------------------|
| Baud rate | Tool-dependent (1200 default; optional USB boot-baud override in parity workflows) |
| Data bits | 8 |
| Parity | None (8N1 in current implementation) |
| Stop bits | 1 |
| Flow control | None |

Accuracy boundary:
- Historical tooling discussions may reference alternate serial/parity experiments, but current bootstrap implementation is documented as 8N1.
- The 68HC11 bootstrap ROM can be initialized with multiple baud strategies; host tool behavior determines which startup rate is used.

### Handshake Sequence

```
Host → ECU: 0xFF (break character)
ECU → Host: Echo of 0xFF (confirms bootstrap mode)
Host → ECU: 256 bytes (bootloader code)
ECU: Jumps to 0x0000 and executes bootloader
```

### Bootstrap Baud Rate Negotiation

After bootloader is loaded, communication can switch to higher speeds:

| Rate | Use Case |
|------|----------|
| 977 | Very slow operations |
| 1200 | Default bootstrap (MPTune) |
| 7812 | Common high-speed target |
| 9600 | Alternate high-speed target |
| 62500 | High-speed target |
| 125000 | Recommended FTDI high-speed target |

### Ostrich Baud (Separate from Bootstrap)

Ostrich communication is a different protocol path from 68HC11 bootstrap and can use higher transport rates (for example, 921600 in some detection paths).

Do not treat Ostrich baud settings as bootstrap-mode requirements.

## Bootloader Operation

### Memory Layout

```
0x0000  ┌─────────────────────────────┐
        │ BootMainAll.lst (256 bytes) │
        │ Main bootloader             │
        │ Stays resident              │
0x0080  ├─────────────────────────────┤
        │ Command routines            │
        │ Loaded as needed            │
        │ ChipID, Flash, Read, etc.   │
0x00FF  └─────────────────────────────┘
```

### Programming Sequence

```
┌──────────────────────────────────────┐
│ 1. Enter bootstrap mode              │
└──────────────────┬───────────────────┘
                   │
                   ▼
┌──────────────────────────────────────┐
│ 2. Send 0xFF, wait for echo          │
└──────────────────┬───────────────────┘
                   │
                   ▼
┌──────────────────────────────────────┐
│ 3. Upload BootMainAll (256 bytes)    │
│    to RAM at 0x0000                  │
└──────────────────┬───────────────────┘
                   │
                   ▼
┌──────────────────────────────────────┐
│ 4. Upload ChipID routine to 0x0080   │
│    Execute, read chip ID bytes       │
└──────────────────┬───────────────────┘
                   │
                   ▼
┌──────────────────────────────────────┐
│ 5. Select flash routine based on ID  │
│    ST chip → SBEC_Flash_ST_32k.lst   │
│    Toshiba → SBEC_Flash_Tosh_32k.lst │
└──────────────────┬───────────────────┘
                   │
                   ▼
┌──────────────────────────────────────┐
│ 6. Upload flash routine to 0x0080    │
└──────────────────┬───────────────────┘
                   │
                   ▼
┌──────────────────────────────────────┐
│ 7. Send data in 64-byte chunks       │
│    Wait for ACK after each chunk     │
│    Skip EEPROM (0xB600-0xB7FF)       │
└──────────────────┬───────────────────┘
                   │
                   ▼
┌──────────────────────────────────────┐
│ 8. Verify by reading back            │
└──────────────────────────────────────┘
```

## Chip Identification

### ChipID Routine

Returns 2 bytes identifying the flash chip:

| Byte | Content |
|------|---------|
| 1 | Manufacturer ID |
| 2 | Device ID |

### Known IDs

| Manufacturer | ID | Chips |
|--------------|-----|-------|
| ST | 0x20 | M28F256, M28F512, etc. |
| Toshiba | 0x98 | TC58xxx series |
| Intel | 0x89 | 28Fxxx series |
| AMD | 0x01 | 29Fxxx series |

### Why Identification Matters

**Different chips require different flash algorithms!**

Using wrong algorithm can:
- Fail to program
- Corrupt data
- Potentially damage chip
- Brick the ECU

**Always identify chip before flashing.**

## Flash Programming Details

### Page Write

Flash chips typically write in pages:
- Page size: 64 bytes (common)
- Some chips: 128 bytes or more
- Must complete page before starting next

### Timing Requirements

| Operation | Typical Wait |
|-----------|--------------|
| Byte write | 10-50 μs |
| Page write | 200-500 μs |
| Chip erase | 200-500 ms |
| Sector erase | 50-100 ms |

### ACK Protocol

After each data chunk:
```
Host → ECU: 64 bytes of data
ECU → Host: ACK byte (confirms write complete)
Host: Proceeds to next chunk
```

Timeout if no ACK indicates failure.

## EEPROM Handling

### Skip Region

**Always skip 0xB600-0xB7FF during flash!**

This 512-byte region contains:
- Adaptive fuel trim
- Knock adaptation
- Learned idle
- Other adaptive values

### Erasing EEPROM

If you need to clear adaptives:
1. Upload EraseEEPROM.lst
2. Execute routine
3. All adaptive data cleared
4. Car will need to relearn

## Error Handling

### No Echo

**Problem:** 0xFF sent, no echo received

**Causes:**
- ECU not in bootstrap mode
- Wrong COM port
- Wiring issue
- Baud rate mismatch

**Fix:**
- Verify bootstrap voltage
- Check connections
- Retry power sequence

### Write Timeout

**Problem:** ACK not received after data chunk

**Causes:**
- Flash algorithm mismatch
- Chip damaged
- Communication error

**Fix:**
- Verify chip ID
- Select correct flash routine
- Reduce baud rate
- Check chip integrity

### Verification Failure

**Problem:** Read-back doesn't match written data

**Causes:**
- Flash not properly erased
- Marginal chip
- Communication errors during write

**Fix:**
- Erase and retry
- Try different chip
- Reduce baud rate

## USB Serial Adapters

### FTDI-Based (Recommended)

- Best compatibility
- Adjustable latency
- Supported by MPTune

**Configuration:**
- Set latency to 1ms in device properties
- Use FTDI D2XX drivers

### Prolific PL2303

- May work for lower speeds
- Less reliable at high speeds
- Driver issues on modern Windows

### CH340

- Budget option
- Works for basic operations
- May have issues at high speeds

## Timing Considerations

### Latency

USB serial adds latency:
- FTDI default: 16ms
- FTDI optimized: 1ms
- Native RS232: <1ms

Lower latency = faster programming

### Buffer Size

USB serial buffers affect performance:
- Larger buffers = better throughput
- May mask timing issues

### Timeout Settings

Set appropriate timeouts:
- Read timeout: 1000ms minimum
- Write timeout: 1000ms minimum
- Allow extra time for flash operations
