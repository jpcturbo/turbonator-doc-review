# MPTune

## Overview

MPTune is the primary tuning software for Chrysler turbo ECUs. It can both create new calibrations from templates and edit existing binary files.

## Features

- Template-based calibration creation
- Binary editing with project files
- Table/constant visualization
- Flash programming support
- Datalogging capability

## Installation

1. Download from community sources
2. Extract to folder
3. No installation required (portable)
4. May need to run as Administrator on modern Windows

## Basic Workflow

### Creating New Calibration

1. Open template file (.tpl)
2. Make calibration changes
3. Select matching .asm file
4. Assemble to create .bin
5. Flash or burn chip

### Editing Existing Calibration

1. Open binary file (.bin)
2. Select matching project file (.mpt)
3. Make calibration changes
4. Save modified .bin
5. Flash or burn chip

## COM Port Setup

### For USB-to-Serial Adapters

1. Open **Setup** > **Com Setup**
2. Select COM port number
3. Check **FTDI USB Port** (for FTDI-based cables)
4. Select baud rate:
   - 125,000 recommended
   - Higher speeds may be unstable

### Determining COM Port

1. Open Windows Device Manager
2. Expand "Ports (COM & LPT)"
3. Note port number for your adapter
4. USB adapters typically COM5 or higher

## Flash Programming

### Flashing BoostButton Module

1. Configure COM port
2. Open **Chip** > **Read/Write**
3. Select bin size (16k or 32k)
4. Check **Slow** flash method
5. Click **Write Bin To Chip**
6. Select .bin file
7. Bootstrap ECU when prompted
8. Wait for completion

### Reading ROM

1. Configure COM port
2. Open **Chip** > **Read/Write**
3. Select bin size
4. Click **Read Bin From Chip**
5. Bootstrap ECU
6. Save resulting file

## Table Editing

### Navigation

- Parameter tree on left
- Double-click to open table/constant
- Multiple tables can be open

### Editing Values

- Click cell to select
- Type new value
- Enter to confirm
- Escape to cancel

### Visualization

- Graph view for tables
- Color coding for values
- Min/max indicators

## Fueling Setup

### Accessing

**Miscellaneous** > **Fueling Setup**

### Features

- Enter target AFR for each MAP point
- View theoretical pulsewidth overlay
- Adjust injector size
- Configure fuel properties

### Target AFR Display

Yellow "phantom line" on fuel tables shows what pulsewidth would achieve target AFR. Compare to actual table values to see if you're running rich or lean.

## Common Tasks

### Changing Injector Size

1. Open **Miscellaneous** > **Fueling Setup**
2. Enter new injector size (lb/hr)
3. Recalculate fuel tables
4. Verify with datalogging

### Adjusting Boost Target

1. Navigate to boost control section
2. Find boost target tables
3. Modify target values
4. Test and verify with boost gauge

### Modifying Timing

1. Navigate to timing section
2. Find relevant advance table
3. Adjust values
4. Verify with timing light and datalog

## File Management

### Template Files (.tpl)

- Source for new calibrations
- Contains metadata and data
- Combined with .asm to create .bin

### Project Files (.mpt)

- For editing existing .bin
- Contains table definitions only
- Must match .bin structure

### Binary Files (.bin)

- Actual ROM image
- What gets burned to chip
- 16KB or 32KB

## Tips

### Backup Everything

- Keep copies of working calibrations
- Save incremental versions
- Document changes made

### Test Incrementally

- Make small changes
- Test each change
- Easier to isolate problems

### Use Datalogging

- Verify changes with real data
- Monitor knock count
- Check AFR with wideband

## Troubleshooting

### Can't Connect to ECU

- Verify COM port selection
- Check FTDI USB Port checkbox
- Verify cable connections
- Try lower baud rate

### Flash Fails

- Use "Slow" flash method
- Reduce baud rate
- Check power stability
- Verify bootstrap sequence

### Tables Don't Match

- Ensure .mpt matches .bin version
- Different firmware = different addresses
- Use correct project file

## Limitations

- Windows only
- Some USB adapters don't work
- D2XX drivers may conflict
- No macOS/Linux support
