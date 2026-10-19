# Memory Map Reference

## Overview

The 68HC11 CPU in SMEC/SBEC/FCC can address 64KB of memory. The lower 32KB contains system memory (RAM, I/O ports), while the upper 32KB contains the ROM with calibration data and executable code.

## Complete Memory Map

```
Address Range     Size    Description
─────────────────────────────────────────────────────
0x0000-0x00FF     256B    Internal RAM
                          - Variables, counters, flags
                          - Bootloader loads here

0x0100-0x0FFF            Unused/Reserved

0x1000-0x103F     64B     CPU Internal Registers
                          - Timer, serial, port config

0x1040-0x3FFF            Unused/Reserved

0x4000-0x40FF     256B    PIA1 (Peripheral Interface Adapter 1)
                          - Output controls
                          - Injector drivers
                          - Ignition output

0x5000-0x50FF     256B    PIA2 (Peripheral Interface Adapter 2)
                          - Additional I/O
                          - Idle air control

0x6000-0x60FF     256B    Switch Port
                          - Input sensing
                          - A/C request
                          - Brake switch

0x7000-0x7FFF            Switch Access Register area

0x8000 ─────────────────────────────────────────────
│                                                   │
│              EXTERNAL ROM (32KB)                  │
│                                                   │
│  0x8000: DataOrg - Calibration data starts        │
│         - Lookup tables                           │
│         - Constants                               │
│         - Thresholds                              │
│                                                   │
│  0x9000: CodeOrg - Executable code starts         │
│         - Main loop                               │
│         - Fuel calculations                       │
│         - Timing calculations                     │
│         - Boost control                           │
│         - Idle control                            │
│         - Diagnostics                             │
│                                                   │
│  0xB600-0xB7FF: EEPROM (512 bytes)                │
│         *** SKIP DURING FLASH ***                 │
│         - Adaptive fuel memory                    │
│         - Knock adaptation                        │
│         - Learned idle position                   │
│                                                   │
│  0xB800-0xFFD5: More ROM code                     │
│                                                   │
│  0xFFD6-0xFFFF: Interrupt Vectors (42 bytes)      │
│         *** MUST BE AT END ***                    │
│                                                   │
0xFFFF ─────────────────────────────────────────────
```

## Critical Memory Regions

### Internal RAM (0x0000-0x00FF)

This 256-byte region stores runtime variables:

| Address | Purpose |
|---------|---------|
| 0x0050 | Status flags register |
| 0x004F | Throttle/WOT flags |
| 0x005A | Fuel modifier result |
| 0x005B | Injector pulsewidth |
| 0x0073 | Enrichment countdown |
| 0x0076 | Starting fuel time reduction |
| 0x0077 | Increase fuel mix variable |
| 0x0078 | Fuel leaning MAP decay |
| 0x0079 | Fuel leaning throttle decay |
| 0x007B | Accelerator pump pulsewidth |
| 0x007D | O2 sensor feedback counter |
| 0x008B | Adaptive memory value |
| 0x008F | Idle error pulsewidth |
| 0x0091 | Fuel enrich no-throttle variable |
| 0x00B1 | O2 feedback direction flag |
| 0x00C4 | Temp variable 5 (running PW) |
| 0x00D9 | Base fuel modifier |

### EEPROM (0xB600-0xB7FF)

**CRITICAL: Never overwrite this region during flash programming!**

The 512-byte EEPROM stores adaptive learning data:
- Fuel trim values (short-term and long-term)
- Knock adaptation values
- Idle air control learned position
- Barometric offset
- Other learned parameters

Overwriting this region will:
1. Cause poor running until values are relearned
2. Trigger check engine light
3. Require extended relearning period

### Interrupt Vectors (0xFFD6-0xFFFF)

The CPU relies on these vectors to handle hardware events:

| Address | Vector | Purpose |
|---------|--------|---------|
| 0xFFD6 | SCI | Serial Communication Interrupt |
| 0xFFD8 | SPI | Serial Peripheral Interrupt |
| 0xFFDA | PAIE | Pulse Accumulator Input Edge |
| 0xFFDC | PAO | Pulse Accumulator Overflow |
| 0xFFDE | TOF | Timer Overflow |
| 0xFFE0 | TOC5 | Timer Output Compare 5 |
| 0xFFE2 | TOC4 | Timer Output Compare 4 |
| 0xFFE4 | TOC3 | Timer Output Compare 3 |
| 0xFFE6 | TOC2 | Timer Output Compare 2 |
| 0xFFE8 | TOC1 | Timer Output Compare 1 |
| 0xFFEA | TIC3 | Timer Input Capture 3 |
| 0xFFEC | TIC2 | Timer Input Capture 2 |
| 0xFFEE | TIC1 | Timer Input Capture 1 (Distributor pickup) |
| 0xFFF0 | RTI | Real Time Interrupt |
| 0xFFF2 | IRQ | External Interrupt |
| 0xFFF4 | XIRQ | Non-Maskable Interrupt |
| 0xFFF6 | SWI | Software Interrupt |
| 0xFFF8 | ILLOP | Illegal Opcode Trap |
| 0xFFFA | COP | Watchdog (Computer Operating Properly) |
| 0xFFFC | CMF | Clock Monitor Fail |
| 0xFFFE | RESET | Reset Vector (execution starts here) |

**The RESET vector at 0xFFFE-0xFFFF is critical** - it tells the CPU where to begin executing code after power-on. If this is wrong, the ECU will not function.

## BIN File to CPU Address Mapping

### Understanding the Relationship

The physical ROM chip maps directly to the CPU's upper address space:

```
32KB Chip (27C256):           CPU Address Space:
─────────────────────         ─────────────────────
Chip byte 0x0000      ◄────►  CPU address 0x8000
Chip byte 0x0001      ◄────►  CPU address 0x8001
...                           ...
Chip byte 0x7FFF      ◄────►  CPU address 0xFFFF
```

### Address Calculation

**To convert a TPL/MPT address to BIN file offset:**
```
file_offset = mptbladdr value (already an offset from 0x8000)
```

**To convert CPU address to BIN file offset:**
```
file_offset = cpu_address - 0x8000
```

**Example:**
```
CPU address 0x81BA (Part-throttle fuel table)
File offset = 0x81BA - 0x8000 = 0x01BA (byte 442 in .bin file)
```

## Calibration Data Region (0x8000-0x8FFF)

This region contains tunable parameters. Common table locations for 89 T1 SMEC:

| Address | Table |
|---------|-------|
| 0x8010 | Cold MAP advance |
| 0x8024 | Part-throttle warm advance |
| 0x8043 | Cold engine temp threshold |
| 0x805B | WOT warm MAP advance |
| 0x8085 | Advance comparison table |
| 0x8090 | Advance from coolant temp |
| 0x8098 | Advance from RPM |
| 0x80B3 | Max advance by RPM |
| 0x80E9 | Knock retard RPM table |
| 0x8104 | Knock retard MAP table |
| 0x8157 | Starting fuel from CTS |
| 0x817E | Starting fuel no-throttle constant |
| 0x817F | Starting fuel EPP table |
| 0x818A | Starting fuel CTS modifier |
| 0x8191 | Starting fuel baro table |
| 0x819C | Starting fuel PW reducer |
| 0x81BA | No-throttle fuel table |
| 0x81E8 | Part-throttle fuel table |
| 0x8220 | Full-throttle fuel table |
| 0x8248 | Fuel enrichment A table |
| 0x8263 | Fuel enrichment B table |
| 0x8286 | Fuel enrichment C table |
| 0x8290 | RPM compensation table |
| 0x82B0-0x82B6 | Phase-out constants |
| 0x82B7 | Cold load no-throttle vs CTS |
| 0x82CA | Cold load no-throttle vs MAP |
| 0x82E1 | Cold load part-throttle vs CTS |
| 0x82F4 | Cold load part-throttle vs MAP |
| 0x830B | Baro compensation |
| 0x8322 | Pumping efficiency table |
| 0x8349 | Charge temp compensation |

## Memory Chip Mapping

Different chip sizes require different offsets:

```
64KB Chip (27SF512):
┌────────────────────────────────────────────────────┐
│  0x0000-0x7FFF: Lower 32KB (invisible to CPU)      │
│  ─────────────────────────────────────────────     │
│  0x8000-0xFFFF: Upper 32KB (visible to CPU)        │
│                 Maps to CPU 0x8000-0xFFFF          │
└────────────────────────────────────────────────────┘

32KB Chip (27C256):
┌────────────────────────────────────────────────────┐
│  0x0000-0x7FFF: All 32KB visible to CPU            │
│                 Maps to CPU 0x8000-0xFFFF          │
└────────────────────────────────────────────────────┘

16KB Chip (27C128):
┌────────────────────────────────────────────────────┐
│  0x0000-0x3FFF: All 16KB visible to CPU            │
│                 Maps to CPU 0xC000-0xFFFF          │
└────────────────────────────────────────────────────┘
```

See [Offset Calculator](../reference/offset-calculator.md) for chip burning offset calculations.
