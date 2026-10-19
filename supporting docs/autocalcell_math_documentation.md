# SMEC Fuel Trim and Adaptive Memory Documentation

This document explains the full fuel trim functionality within the SMEC (Single Module Engine Controller) codebase, specifically detailing how the system reacts to Oxygen (O2) Sensor feedback, handles short-term fuel trim (STFT), determines which adaptive cell to use, and writes long-term fuel trim (LTFT) adjustments into the `AutoCalCell` values.

## 1. Short-Term Fuel Trim (O2 Feedback & Ramps)
The Short-Term Fuel Trim is primarily driven by the Narrowband O2 Sensor. The ECU reads the sensor to determine if the combustion is running rich or lean, setting or clearing the `b4f_O2Rich` flag. 

### Primary and Secondary Ramps
To correct the air/fuel ratio, the ECU applies a dynamic "kick" or ramp to the fuel calculation.
- **Primary Ramp (`PRIRMP_PrimaryRamp`)**: The active STFT adjustment that increments or decrements continuously during normal closed-loop operation.
- **Secondary Ramp (`SECRMP_SecondaryRamp`)**: Used as a rapid fail-safe. If the O2 sensor is stuck on one side (rich or lean) for an extended duration, the ECU triggers the secondary ramp to aggressively force the engine back to stoichiometric.

The size of the fuel "kick" for these ramps is determined dynamically based on the current RPM and MAP readings via the `DetermineRampCellFromRPMandMAP` routine. The running total of these real-time adjustments is stored in `Counter_PrimaryAndSecondaryRamp`, which serves as the active STFT offset.

## 2. Determining the Adaptive Cell (Cell Selection)
The SMEC divides its operating range into 13 unique adaptive memory cells to apply highly specific fuel trims depending on the engine's current state. 
- **AutoCalCell12idle**: Used exclusively when the engine is idling (throttle closed, RPM within idle boundaries).
- **AutoCalCell0 through AutoCalCell11**: A grid of cells divided by MAP (engine load) and RPM regions. 

The `AdaptiveMemory_DetermineWhichCellApplies_MM` routine constantly monitors RPM and MAP. It iterates through the cell boundaries (`MP1_AutoCalMapCellBoundary1`, `R1_RPMCellBoundaryInRPMover32`) and calculates which of the 13 cells the engine is currently operating in. It stores this index in `PointerIntoAdaptiveMemory`. Hysteresis (`DLTMAP`, `DLTRPM`) is used at the boundaries to prevent the system from rapidly bouncing between cells if the engine is hovering directly on a line.

## 3. Long-Term Fuel Trim (Adaptive Memory Updates)
While `Counter_PrimaryAndSecondaryRamp` handles immediate corrections, the ECU must "learn" these corrections over time so it doesn't have to rely entirely on the O2 sensor. This is Long-Term Fuel Trim (LTFT), handled by `AdaptiveMemory_UpdateCellIfRequired_MM`.

1. **Timers**: The ECU will only update an `AutoCalCell` after a specific amount of time has passed in that cell (`AMUPDT` for open throttle, `AMUPDI` for idle) and only if the engine is in Closed Loop.
2. **Transferring Trim**: When the timer triggers, the ECU reads the current STFT offset (`Counter_PrimaryAndSecondaryRamp`).
    - If the STFT is actively adding fuel (running lean), the LTFT cell is stepped upward by `CELCHG_BitsChangePerUpdateWithinACell` (usually 1 bit).
    - If the STFT is actively removing fuel (running rich), the LTFT cell is stepped downward.
3. **Safety Caps**: The new `AutoCalCell` value is checked against two safety limits to prevent runaway trim values:
    - `AMLIML_MinMultiplierCannotBeBelow80` (Lower bound, typically -15% fuel limit).
    - `AMLIMH_MaxMultiplierCannotBeAbove7F` (Upper bound, typically +24.8% fuel limit).

## 4. Applying the Learned Trim to Base Fuel
Once the appropriate `AutoCalCell` is updated, the active cell's value is extracted into `ValueFromAdaptiveMemory`. The routine `INCLUDE_ADAPTIVE_MEMORY` injects this modifier directly into the final fuel pulse width calculation.

### The Mathematics of the Application
The `AutoCalCell` values are stored as signed 8-bit integers (ranging from -128 to +127). The application sequence is:

1. **Shift Right (`asrb`)**: The cell value is shifted right by 1 bit arithmetically, effectively halving the value (`Cell / 2`) while preserving the sign bit. Thus, a change of 2 in the cell is required to change the math multiplier by 1 unit.
2. **Scale Base Fuel (`ScaleXbyB_addingA_intoD` & `ScaleYbyA`)**: This halved value acts as an unsigned 0-255 fractional multiplier (A). The Base Fuel PW (Y) is scaled by this fraction and divided by 256. 
3. **Add/Subtract Logic**: 
   * If the `AutoCalCell` was positive, the original Base PW is added to the scaled fractional result: 
     `New PW = Base PW + [Base PW * (Cell / 2) / 256]`
   * If the `AutoCalCell` was negative, the arithmetic shift creates a high-end fraction (e.g., -2 shifted becomes `0xFF` or `255/256`) and the original Base PW is not explicitly added:
     `New PW = Base PW * [256 + (Cell / 2)] / 256`

Both paths simplify perfectly to the same algebraic formula:
**`Modifier = 1 + (Cell / 512)`**

### Human Understandable Units
Since the formula divides the cell value by `512`:
* **1 Bit/Unit** = `1 / 512` = **0.001953125** or **0.1953%** fuel adjustment (effectively ~0.2%).

**Examples:**
* A cell value of **+10** (0x0A): `10 / 512` = **+1.95%** Enrichment
* A cell value of **+127** (0x7F, the upper limit): `127 / 512` = **+24.8%** Enrichment
* A cell value of **-10** (0xF6): `-10 / 512` = **-1.95%** Leanout
* A cell value of **-77** (0xB3, the hardcoded `AMLIML`): `-77 / 512` = **-15.0%** Leanout

*Note: Because the initial `asrb` bit shift performs integer division by 2, odd numbers effectively round down toward negative infinity. So +1 acts like 0, +3 acts like +2 (+0.39%), -1 acts like -2 (-0.39%), etc.*
