# ECU Overview

## Introduction

Chrysler turbocharged vehicles from 1985-1995 used a series of increasingly sophisticated engine control units (ECUs). Understanding which ECU your vehicle has is crucial for tuning, as each generation has different capabilities, memory layouts, and programming requirements.

## ECU Generations

### Logic Module (LM) - 1985-1987

The Logic Module was Chrysler's first computer-controlled fuel injection system for turbo applications.

**Characteristics:**
- Motorola 6803 CPU (predecessor to 68HC11)
- 16KB ROM space
- Separate Power Module handles high-current outputs
- Two-piece system (Logic Module + Power Module)

**Vehicles:**
- 1985-1987 Dodge Daytona Turbo
- 1985-1987 Dodge Lancer
- 1985-1987 Chrysler Laser
- 1985-1987 Shelby Charger

**Tuning Options:**
- Socket + chip swap
- Ostrich real-time emulator
- Home-brew flash conversion (rare)

### SMEC - 1988-1989

The Single Module Engine Controller combined the logic and power modules into one unit.

**Characteristics:**
- Motorola 68HC11 CPU
- 16KB or 32KB ROM
  - 1988 Turbo I: 16KB
  - 1988/1989 Turbo II: 16KB
  - 1989 Turbo I: 32KB
- Potting compound encases electronics
- 60-pin connector

**Key Improvements over LM:**
- Single integrated unit
- Faster processing
- More calibration parameters
- Built-in diagnostics

**Tuning Options:**
- Socket + chip swap
- Ostrich real-time emulator
- BoostButton flash module conversion

### SBEC - 1990-1991

The Single Board Engine Controller refined the SMEC design.

**Characteristics:**
- Motorola 68HC11 CPU
- 32KB ROM (uses 87C257 with integrated latch)
- Potting compound encases electronics
- 60-pin connector

**Key Differences from SMEC:**
- Uses 87C257 chip with built-in address latch
- Latch board required for standard EPROM use
- Different bootstrap voltage requirements

**Tuning Options:**
- Socket + chip swap (requires latch board for standard chips)
- Ostrich with latch board
- BoostButton flash module (includes latch)

### SBEC II - 1992-1993

**Characteristics:**
- Motorola 68HC11 CPU
- 32KB ROM
- Some units came factory-flashable (Toshiba chip)
- 60-pin connector

**Tuning Options:**
- Socket + chip swap (requires latch board)
- Ostrich with latch board
- BoostButton flash module
- Factory flash (some units)

### FCC - 1994-1995

The Flexible Chassis Controller was used in Neon applications.

**Characteristics:**
- Motorola 68HC11 CPU
- 64KB flash ROM (M28F512)
- Factory flashable via SCI port
- Requires 20V programming voltage

**Tuning Options:**
- In-circuit flash programming
- Socket + chip swap

## ECU Identification

### Physical Identification

**SMEC:**
- Black plastic case
- 60-pin connector
- Part number on label (e.g., 4287305)

**SBEC:**
- Black plastic case
- 60-pin connector
- Part number on label

### Electronic Identification

The calibration ID is stored in the ROM and can be read via:
- Scan tool (DRB-II or equivalent)
- MPTune software
- Direct ROM read

## Turbonator Firmware

"Turbonator" refers to modified firmware developed by the community that adds features beyond stock Chrysler calibrations:

**Features:**
- Adjustable boost control
- Enhanced knock control
- Expanded calibration tables
- Additional sensor inputs
- Datalogging capabilities

**Naming Convention:**
- T-SMEC: Turbonator firmware for SMEC
- T-SBEC: Turbonator firmware for SBEC
- T-LM: Turbonator firmware for Logic Module

## Calibration vs. Codebase

Understanding the distinction between calibration data and the codebase is fundamental:

**Codebase (ASM file):**
- The executable firmware
- Contains all routines for fuel, spark, boost, idle, etc.
- Written in 68HC11 assembly language
- Rarely modified by end users
- ~6000+ lines of code

**Calibration (TPL file):**
- Tables, constants, and thresholds
- Defines vehicle-specific behavior
- Modified for tuning
- Combined with codebase during assembly

```
Codebase (HOW to calculate)  +  Calibration (WHAT values to use)  =  Complete ROM
```

## Memory Architecture

All Chrysler ECUs of this era share a common memory architecture:

| Region | Purpose |
|--------|---------|
| 0x0000-0x00FF | Internal RAM (256 bytes) |
| 0x1000-0x103F | CPU registers |
| 0x4000-0x60FF | I/O ports (PIA1, PIA2, switches) |
| 0x8000-0xFFFF | External ROM (calibration + code) |

The ROM space (0x8000-0xFFFF) is where the calibration and code reside:
- 0x8000: Data origin (calibration tables start here)
- 0x9000: Code origin (executable code starts here)
- 0xB600-0xB7FF: EEPROM (adaptive memory - do not overwrite!)
- 0xFFD6-0xFFFF: Interrupt vectors (must be at end)

See [Memory Map Reference](memory-map.md) for complete details.
