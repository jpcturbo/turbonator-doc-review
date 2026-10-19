# ECU Modification

## Overview

To tune Chrysler turbo ECUs, you typically need to modify the computer to accept custom calibrations. This involves removing the factory EPROM and installing a socket for easy chip changes.

## Required Tools

### Basic Tools
- Exacto knife or razor blade
- Small flathead screwdriver
- Small pliers or hemostat
- Safety glasses

### Soldering Equipment
- Soldering iron (25-40W)
- Solder (60/40 or 63/37 rosin core)
- Solder sucker or desoldering braid
- Flux (optional but helpful)

### Optional Tools
- Dremel with cutoff wheel
- Nylon/plastic scraper
- Helping hands or PCB holder
- Magnifying glass or loupe
- Multimeter

## ECU-Specific Procedures

### Logic Module (LM)

**Difficulty:** Easiest

The LM has no potting compound. The EPROM is directly accessible.

1. Open LM case (usually clips or screws)
2. Locate 28-pin EPROM
3. Proceed to chip removal section below

### SMEC

**Difficulty:** Moderate

The SMEC is encased in potting compound.

**Step 1: Access the Chip**
1. Remove SMEC from vehicle
2. Identify EPROM location (28-pin chip)
3. Using exacto knife, cut outline around chip (~1/8" margin)
4. Cut through potting compound on both sides of board
5. Use plastic scraper to carefully remove potting from chip area
6. Clean chip leads of any remaining compound

**Step 2: Remove Chip**
Continue to chip removal section below.

**Tips:**
- Potting compound is relatively soft
- Work slowly to avoid cutting traces
- Remove compound from both sides of PCB

### SBEC

**Difficulty:** Moderate to Hard

Similar to SMEC but uses 87C257 chip with integrated latch.

**Step 1: Access the Chip**
Same as SMEC - cut and remove potting compound.

**Step 2: Remove Chip**
Same as other ECUs.

**Step 3: Latch Consideration**
The 87C257 has a built-in latch. To use standard chips:
- Install a latch board adapter
- Or use BoostButton flash module (includes latch)

### SBEC II

**Difficulty:** Hard

Similar to SBEC. Some units have factory-flashable chips.

**Check first:** If your SBEC II has a 32-pin DIP, it may be factory flashable. Don't modify unnecessarily.

## Chip Removal

### Method 1: Cut and Desolder (Recommended)

1. **Cut the leads:**
   - Use Dremel with cutoff wheel
   - Cut each pin close to chip body
   - Be extremely careful not to damage PCB traces

2. **Remove chip body:**
   - Lift chip away from board
   - Pins remain in through-holes

3. **Remove individual pins:**
   - Heat each pin with soldering iron
   - When solder melts, pull pin out with pliers
   - Work quickly to avoid heat damage

4. **Clear the holes:**
   - Use solder sucker or wick
   - Ensure all holes are clear
   - Verify from both sides

### Method 2: Desolder Whole Chip

More difficult but preserves original chip:

1. Add fresh solder to all pins (helps heat transfer)
2. Heat pins one by one while gently lifting chip
3. Use desoldering braid to remove excess solder
4. Work around chip multiple times
5. Chip should eventually release

**Risks:**
- Easy to overheat and damage board
- May lift pads or damage traces
- Takes longer

## Socket Installation

### Socket Types

**Standard Socket (Radio Shack style)**
- Cheap and available
- May vibrate loose in vehicle
- OK for bench testing

**Machine Pin Socket**
- Tighter grip on chip pins
- Better for vehicle installation
- Available from Mouser, Digi-Key

**ZIF (Zero Insertion Force) Socket**
- Lever locks chip in place
- Unlimited insertions without wear
- Best for frequent chip swaps
- More expensive

### Installation Steps

1. **Verify holes are clear:**
   - Socket pins should drop in easily
   - If not, reheat and clear holes

2. **Orient socket correctly:**
   - Align pin 1 notch with board marking
   - Pin 1 is usually marked on PCB

3. **Seat socket fully:**
   - Press socket flat against PCB
   - All pins should protrude through

4. **Solder pins:**
   - Start with corner pins to hold position
   - Solder remaining pins
   - Inspect each joint

5. **Verify:**
   - Check for solder bridges
   - Ensure no cold joints
   - Test continuity if uncertain

## Post-Modification

### Cleaning

1. Remove flux residue with isopropyl alcohol
2. Remove any remaining potting compound debris
3. Let dry completely before testing

### Testing

1. Insert known-good chip
2. Reinstall ECU in vehicle
3. Turn key to run (don't start)
4. Verify power-up behavior
5. Start engine and verify operation

### Potting (Optional)

If you want to re-seal the ECU:
- Use RTV silicone or similar
- Don't cover the socket (need access)
- Create a barrier around socket area

## Troubleshooting

### ECU Doesn't Power Up

**Check:**
- Chip orientation (notch alignment)
- Solder joints on socket
- Damaged traces from modification
- Chip seated fully in socket

### Intermittent Operation

**Check:**
- Socket grip on chip pins
- Vibration causing disconnection
- Cold solder joints
- Cracked traces

### Engine Runs Poorly

**Check:**
- Correct chip for ECU
- Chip fully seated
- No bent pins
- Correct chip orientation

## Safety Warnings

1. **ESD Protection:**
   - Ground yourself before handling chips
   - Use anti-static mat if available

2. **Heat Damage:**
   - Don't overheat PCB (damages pads/traces)
   - Let iron heat chip, don't force

3. **Fumes:**
   - Work in ventilated area
   - Solder fumes are irritating

4. **Sharp Tools:**
   - Exacto knives and Dremel wheels are dangerous
   - Cut away from yourself
   - Wear safety glasses

## Alternative: Flash Module Conversion

Instead of socketing, you can install a flash module:

**BoostButton Flash Module:**
- Replaces socket + chip
- In-circuit programming via SCI port
- No UV eraser needed
- Faster calibration changes
- Includes latch for SBEC

See [Flash Modules](flash-modules.md) for details.
