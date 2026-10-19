# Flash Modules

## Overview

Flash modules replace the traditional socket + chip approach with in-circuit reprogramming capability. You can update your calibration through the SCI (diagnostic) port without removing anything from the ECU.

## BoostButton Flash Module

### Description

The BoostButton flash module is the primary solution for making SMEC/SBEC ECUs flashable.

**Features:**
- In-circuit programming via SCI port
- Uses 29C256 flash EEPROM
- 5V programming (no special voltages)
- SBEC version includes latch chip
- Sealed installation possible

### Supported ECUs

| ECU | Module Version | Notes |
|-----|----------------|-------|
| SMEC | Standard | Direct installation |
| SBEC | SBEC version | Includes latch |
| SBEC II | SBEC II version | Includes latch |

### Installation

The module replaces the original EPROM:

1. Remove original chip (see [ECU Modification](ecu-modification.md))
2. Clean socket area
3. Install module in socket (or solder in place)
4. Route no additional wires (uses existing SCI connection)

### Flash Timing

| Operation | Time |
|-----------|------|
| Flash 32KB | ~6 seconds at 125kbps |
| Verify | ~6 seconds at 125kbps |
| Total | ~12 seconds |

Higher baud rates are possible but may be less reliable.

## Bootstrap Requirements

### SMEC Bootstrap

**Pin 11 (60-way connector):** Apply 12V for BoostButton module

**Procedure:**
1. Turn boot switch ON (applies 12V to pin 11)
2. Turn key to RUN position
3. ECU is now bootstrapped
4. Flash process begins automatically

**Note:** Fuel pump will NOT prime - this is normal in bootstrap mode.

**Tip:** Wire a toggle switch to pin 11, powered from the cigarette lighter (constant 12V).

### Stock SMEC Bootstrap

For reading stock SMEC (not BoostButton):
- Requires 21V+ on pin 11
- Use 9V battery in series with 12V source
- Read-only operation

### SBEC Bootstrap

**Different from SMEC!** Requires momentary 12V application.

**Procedure:**
1. Press boot pushbutton (applies 12V to boot wire)
2. Turn key to RUN position
3. Release pushbutton within ~1 second
4. ECU is now bootstrapped

**BoostButton cable:** Extra red wire is the boot wire

**Tip:** Use a momentary pushbutton to the cigarette lighter.

## Software Configuration

### MPTune Setup

1. Open MPTune
2. Select **Setup** > **Com Setup**
3. Select your COM port (USB cables typically COM5+)
4. Check **FTDI USB Port** box
5. Select baud rate:
   - 125,000 - Reliable
   - 921,600 - Faster but may be unstable

### Flash Process

1. Configure COM port as above
2. Select **Chip** > **Read/Write**
3. Choose bin size (16k or 32k)
4. Select **Slow** flash method (required for BoostButton)
5. Click **Write Bin To Chip**
6. Select your .bin file
7. Bootstrap ECU when prompted
8. Wait for completion

### Baud Rate Selection

| Rate | Speed | Reliability |
|------|-------|-------------|
| 1,200 | Slow | Very reliable |
| 9,600 | Moderate | Reliable |
| 125,000 | Fast | Good |
| 921,600 | Very fast | May have issues |

Start with 125,000. Only increase if you have reliable communication.

## Troubleshooting

### "No Response from ECU"

**Check:**
- COM port selection
- Boot voltage applied correctly
- Timing of boot sequence
- Cable connections

### "Flash Failed"

**Check:**
- Using "Slow" flash method
- Baud rate not too high
- Power stable during flash
- .bin file correct size

### Partial Flash / Corruption

**Recovery:**
- Re-attempt flash
- Try lower baud rate
- Check power connections
- Verify cable quality

### Fuel Pump Primes (Bootstrap Failed)

If fuel pump primes during bootstrap attempt:
- ECU did not enter bootstrap mode
- Re-try the bootstrap sequence
- Verify boot voltage
- Check timing

## D-Cal Limitations

D-Cal can flash BoostButton modules BUT:
- Only works with dedicated RS232 serial port
- Does NOT work with USB-to-serial adapters
- MPTune is recommended for USB cables

## Advantages vs. Chip Swap

| Aspect | Flash Module | Chip Swap |
|--------|--------------|-----------|
| Change time | ~12 seconds | Minutes (remove, burn, install) |
| UV eraser | Not needed | Needed for EPROMs |
| Convenience | Flash from laptop in car | Remove ECU or chip |
| On-the-fly | No (must be bootstrapped) | No (engine must be off) |
| Cost | Module cost + cable | Socket + chips + burner |
| Reliability | Very good | Depends on socket quality |

## Real-Time Tuning Alternative

Flash modules don't support real-time (engine running) calibration changes. For that, you need:

**Moates Ostrich:**
- Real-time EPROM emulator
- Change values while engine runs
- More expensive
- Requires SBEC latch board

## Factory Flashable ECUs

Some ECUs were flashable from the factory:

### SBEC II (Some)
- 32-pin DIP Toshiba chip
- Protocol not fully documented
- May work with BoostButton adapter

### FCC (1994-1995 Neon)
- M28F512 flash chip
- Requires 20V programming voltage
- In-circuit flash with adapter
- 30-40 second flash time

### Protocol Compatibility

BoostButton voltage adapter may work for:
- SBEC II (some versions)
- FCC
- TCM (transmission controller)

All use 12V bootstrap, 20V program voltage per Chrysler patents.
