# Chip Burning

## Overview

Chip burning is the process of programming a memory chip with your calibration data. This guide covers using Willem-style programmers, the most common choice for DIY tuning.

## Equipment Needed

### Programmer

**Willem Universal Programmer**
- ~$40 from eBay
- Supports most chip types
- Free, open-source software
- Requires parallel port (or adapter)

**Other Options:**
- TL866 (USB, modern, ~$50-60)
- Xeltek SuperPro (professional, expensive)
- Various USB programmers

### UV Eraser (for EPROMs)

**Commercial Eraser (~$50-100)**
- Enclosed chamber
- Timer function
- 10-15 minute erase

**Handheld Germicidal UV (~$20)**
- No enclosure (wear protection!)
- 20-30 minute erase
- Works but less convenient

### Chips

See [Chip Selection](../hardware/chip-selection.md) for chip type recommendations.

## Willem Programmer Setup

### Hardware Installation

1. Connect to parallel port (LPT1)
2. Or use parallel-to-USB adapter
3. Install chip adapter if needed
4. Power programmer via USB or external supply

### Software Installation

1. Download Willem software
2. Extract to folder
3. Run as Administrator
4. Select programmer model
5. Configure parallel port

### Chip Selection in Software

1. Select chip manufacturer
2. Select chip model (e.g., 27C256)
3. Verify pin configuration
4. Check voltage settings

## Basic Burning Process

### Step 1: Prepare Chip

**For EPROMs:**
1. Verify chip is blank (all 0xFF)
2. If not blank, erase with UV
3. After erase, check blank again

**For Flash/EEPROM:**
1. Erase in programmer
2. Verify blank

### Step 2: Load File

1. Open .bin file in programmer software
2. Verify file size matches chip
3. Set offset if needed (see below)

### Step 3: Calculate Offset

| BIN Size | Chip Size | Offset |
|----------|-----------|--------|
| 16KB | 16KB | 0x0000 |
| 16KB | 32KB | 0x4000 |
| 16KB | 64KB | 0xC000 |
| 32KB | 32KB | 0x0000 |
| 32KB | 64KB | 0x8000 |

Enter offset in programmer software BEFORE programming.

### Step 4: Program

1. Insert chip in ZIF socket
2. Verify orientation (notch = pin 1)
3. Click "Program" or "Write"
4. Wait for completion
5. Do not interrupt!

### Step 5: Verify

1. Click "Verify" or "Compare"
2. Compares chip contents to file
3. All bytes must match
4. If errors, erase and retry

## UV Erasing EPROMs

### Preparation

1. Remove any labels covering window
2. Clean window with alcohol if dirty
3. Ensure window is clear (not fogged)

### Erase Process

1. Place chip in eraser tray
2. Window facing UV source
3. Close lid (commercial) or position lamp
4. Set timer:
   - Commercial: 15-20 minutes
   - Handheld: 25-30 minutes
5. Wait for timer

### Verification

1. Remove chip from eraser
2. Insert in programmer
3. Run "Blank Check"
4. All bytes should be 0xFF
5. If not blank, erase longer

### UV Safety

- Never look at UV source
- Don't expose skin unnecessarily
- Use enclosed eraser when possible
- UV-C is harmful to eyes and skin

## TL866 Programmer

Modern USB alternative to Willem:

### Advantages

- USB connection (no parallel port)
- Faster programming
- Better software interface
- Auto-detection of some chips

### Software

- MinProgrammer (included)
- XGecu Pro
- Both free

### Usage

1. Install USB drivers
2. Run software
3. Select chip model
4. Load file
5. Program and verify

## Troubleshooting

### Chip Won't Program

**Check:**
- Correct chip selected in software
- Chip properly seated
- Orientation correct (pin 1)
- Programmer powered
- Chip not write-protected

### Verification Errors

**Causes:**
- Chip not fully erased
- Marginal chip (weak cells)
- Programming voltage too low
- Socket contact issues

**Fixes:**
- Re-erase and retry
- Try different chip
- Check programmer settings
- Clean socket contacts

### All 0xFF After Programming

**Cause:** Programming didn't happen

**Check:**
- Chip is not in write-protect mode
- Correct programming algorithm
- Socket making contact
- Programmer functioning

### Random Errors

**Causes:**
- Bad chip
- Static damage
- Socket issues
- Programmer calibration

**Fixes:**
- Try different chip
- Check ESD procedures
- Clean socket
- Test with known-good chip

## Best Practices

### ESD Protection

- Ground yourself before handling chips
- Use anti-static mat
- Handle chips by edges
- Store in anti-static tubes/foam

### Labeling

- Label chips with calibration name
- Include date
- Note any special info
- Cover EPROM windows after burning

### Testing

- Verify immediately after programming
- Test in ECU before installing in car
- Keep known-good backup chip

### Storage

- Keep chips in anti-static packaging
- Store EPROMs away from UV light
- Label clearly
- Organize by vehicle/calibration

## Batch Programming

If programming multiple chips:

1. Verify first chip thoroughly
2. Test in ECU
3. Then program remaining chips
4. Still verify each one
5. Random sample test if many

## Professional Services

If you don't want to invest in equipment:

- Local electronics shops may offer service
- Online chip burning services exist
- TurboMopar forum members may help
- Cost typically $10-20 per chip
