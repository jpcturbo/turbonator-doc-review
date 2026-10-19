# 68HC11 Architecture

## Overview

The Motorola 68HC11 is an 8-bit microcontroller used in Chrysler SMEC, SBEC, and FCC engine controllers from 1988-1995. Understanding its architecture helps with debugging, tuning, and developing custom calibrations.

## CPU Specifications

| Feature | Value |
|---------|-------|
| Data width | 8-bit |
| Address bus | 16-bit (64KB addressable) |
| Clock speed | 2 MHz (typical) |
| Endianness | Big-endian (Motorola) |
| Registers | A, B, D (16-bit), X, Y, SP, PC |

## Register Set

### Accumulators

**A Register (8-bit)**
- General-purpose accumulator
- Used for math operations

**B Register (8-bit)**
- General-purpose accumulator
- Used for math operations

**D Register (16-bit)**
- Concatenation of A (high byte) and B (low byte)
- Used for 16-bit operations

### Index Registers

**X Register (16-bit)**
- Index register for addressing
- Used heavily for table lookups

**Y Register (16-bit)**
- Second index register
- Less frequently used than X

### Stack and Program Pointers

**SP (Stack Pointer, 16-bit)**
- Points to current stack location
- Grows downward in memory

**PC (Program Counter, 16-bit)**
- Points to next instruction
- Modified by jumps, calls, interrupts

### Condition Code Register

8-bit register containing flags:

| Bit | Flag | Purpose |
|-----|------|---------|
| 7 | S | Stop disable |
| 6 | X | XIRQ mask |
| 5 | H | Half-carry |
| 4 | I | IRQ mask |
| 3 | N | Negative |
| 2 | Z | Zero |
| 1 | V | Overflow |
| 0 | C | Carry |

## Addressing Modes

### Immediate
Value is part of the instruction:
```assembly
LDAA #$55      ; Load A with 0x55
LDX  #$8000    ; Load X with 0x8000
```

### Direct (Zero Page)
First 256 bytes (0x00-0xFF) accessed with 8-bit address:
```assembly
LDAA $50       ; Load A from address 0x0050
STAB $73       ; Store B to address 0x0073
```

### Extended
Full 16-bit address:
```assembly
LDAA $81BA     ; Load A from address 0x81BA
JSR  $A805     ; Jump to subroutine at 0xA805
```

### Indexed
Base address in X or Y plus offset:
```assembly
LDAA 0,X       ; Load A from address in X
LDAB 5,Y       ; Load B from (Y + 5)
```

### Relative
For branch instructions, offset from PC:
```assembly
BEQ  $10       ; Branch if equal, +16 bytes
BNE  $F0       ; Branch if not equal, -16 bytes
```

## Common Instructions

### Data Movement
```assembly
LDAA addr     ; Load A from memory
LDAB addr     ; Load B from memory
LDD  addr     ; Load D (16-bit) from memory
LDX  addr     ; Load X from memory
STAA addr     ; Store A to memory
STAB addr     ; Store B to memory
STD  addr     ; Store D (16-bit) to memory
STX  addr     ; Store X to memory
TAB           ; Transfer A to B
TBA           ; Transfer B to A
```

### Arithmetic
```assembly
ADDA #val     ; Add to A
ADDB #val     ; Add to B
ADDD #val     ; Add to D (16-bit)
SUBA #val     ; Subtract from A
SUBB #val     ; Subtract from B
SUBD #val     ; Subtract from D (16-bit)
MUL           ; Multiply A * B, result in D
IDIV          ; Integer divide D / X, result in X
INCA          ; Increment A
INCB          ; Increment B
INX           ; Increment X
DECA          ; Decrement A
DECB          ; Decrement B
DEX           ; Decrement X
```

### Logic
```assembly
ANDA #val     ; AND A with value
ANDB #val     ; AND B with value
ORAA #val     ; OR A with value
ORAB #val     ; OR B with value
EORA #val     ; XOR A with value
EORB #val     ; XOR B with value
COMA          ; Complement A (one's complement)
COMB          ; Complement B
NEG  addr     ; Negate (two's complement)
```

### Shift/Rotate
```assembly
ASLA          ; Arithmetic shift left A
ASLB          ; Arithmetic shift left B
ASRA          ; Arithmetic shift right A
ASRB          ; Arithmetic shift right B
LSRA          ; Logical shift right A
LSRB          ; Logical shift right B
ROLA          ; Rotate left A through carry
ROLB          ; Rotate left B through carry
RORA          ; Rotate right A through carry
RORB          ; Rotate right B through carry
```

### Compare/Test
```assembly
CMPA #val     ; Compare A with value
CMPB #val     ; Compare B with value
CPD  #val     ; Compare D (16-bit)
CPX  #val     ; Compare X
TSTA          ; Test A (sets flags)
TSTB          ; Test B (sets flags)
BITA #val     ; Bit test A (AND without storing)
BITB #val     ; Bit test B
```

### Branch
```assembly
BRA  label    ; Branch always
BEQ  label    ; Branch if equal (Z=1)
BNE  label    ; Branch if not equal (Z=0)
BCC  label    ; Branch if carry clear
BCS  label    ; Branch if carry set
BPL  label    ; Branch if plus (N=0)
BMI  label    ; Branch if minus (N=1)
BHI  label    ; Branch if higher (unsigned)
BLS  label    ; Branch if lower or same
BGE  label    ; Branch if >= (signed)
BLT  label    ; Branch if < (signed)
BGT  label    ; Branch if > (signed)
BLE  label    ; Branch if <= (signed)
```

### Subroutine
```assembly
JSR  addr     ; Jump to subroutine
BSR  offset   ; Branch to subroutine (relative)
RTS           ; Return from subroutine
RTI           ; Return from interrupt
```

## Interrupt System

The 68HC11 supports multiple interrupt sources:

### Interrupt Priority (Highest to Lowest)
1. RESET
2. Clock Monitor Fail (CMF)
3. COP (Watchdog)
4. Illegal Opcode
5. Software Interrupt (SWI)
6. XIRQ (Non-maskable)
7. IRQ (External)
8. Real-Time Interrupt
9. Timer Input Captures
10. Timer Output Compares
11. Timer Overflow
12. Pulse Accumulator
13. Serial (SCI, SPI)

### ECU Usage

**Distributor Pickup (TIC1 - 0xFFEE)**
- Triggers fuel calculation
- Most critical interrupt
- Fires every distributor pulse

**Timer Overflow (TOF - 0xFFDE)**
- Background timing
- Periodic calculations

**Real-Time Interrupt (RTI - 0xFFF0)**
- Main loop timing
- Sensor sampling

## Bootstrap Mode

The 68HC11 has a built-in bootstrap mode for loading code into RAM:

**Entry Conditions:**
1. MODA=0, MODB=1 at reset
2. For SMEC: Apply voltage to pin 11

**Bootstrap Sequence:**
1. CPU waits for 0xFF character at bootstrap baud (host-tool dependent in practice)
2. Receives 256 bytes into RAM at 0x0000
3. Jumps to 0x0000 to execute loaded code

Implementation note:
- Current documented bootstrap serial framing is 8N1 (no parity).
- In MPTune-parity workflows, host bootstrap often starts at 1200 baud (or configured USB boot baud), then switches to a selected high-speed baud after bootloader upload.
- Ostrich high-speed serial paths are separate from 68HC11 bootstrap behavior.

This is how flash programming and ROM reading work.

## Big-Endian Byte Order

The 68HC11 uses Motorola (big-endian) byte ordering:

```
16-bit value 0x1234 stored at address 0x8000:
Address 0x8000: 0x12 (high byte first)
Address 0x8001: 0x34 (low byte second)
```

This is the opposite of Intel (little-endian) CPUs. When reading/writing .bin files or calibration data, ensure proper byte ordering.

## Timing Considerations

At 2 MHz clock:
- 1 cycle = 0.5 microseconds
- Simple instructions: 2-4 cycles
- Complex instructions: up to 41 cycles (IDIV)

The ECU has limited time to calculate fuel and spark between distributor pulses. At high RPM, efficiency is critical.
