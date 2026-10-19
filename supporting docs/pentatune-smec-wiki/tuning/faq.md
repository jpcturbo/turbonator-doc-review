# Tuning FAQ

Frequently asked questions about tuning Chrysler turbo ECUs.

---

## General Questions

### Q: What offset do I use to burn my chip?

**A:** The offset ensures the end of your .bin file aligns with the end of the chip. Use this table:

| BIN Size | Chip Size | Chip Type | Offset (Hex) |
|----------|-----------|-----------|--------------|
| 16KB | 16KB | 27C128 | 0x0000 |
| 16KB | 32KB | 27C256 | 0x4000 |
| 16KB | 64KB | 27SF512 | 0xC000 |
| 32KB | 32KB | 27C256 | 0x0000 |
| 32KB | 64KB | 27SF512 | 0x8000 |

The interrupt vectors must be at the end of memory space (0xFFFF).

---

### Q: What are all these file types (.bin, .tpl, .mpt, .calx)?

**A:**
- **.bin** - The actual ROM image burned to chip. Contains code + calibration.
- **.tpl** - Template file for MPTune. Contains calibration data + metadata. Combined with .asm to create new .bin.
- **.mpt** - Project file for MPTune. Similar to .tpl but used to edit existing .bin directly.
- **.calx** - CHeM2 calibration file. Similar purpose to .tpl but different format.
- **.tbl** - D-Cal table file. Database of addresses, data types, and scaling.
- **.asm** - Assembly source code for ECU firmware (codebase).

---

## Ignition Timing

### Q: How is total timing calculated?

**A:** Total timing = Advance from RPM + Advance from MAP (WOT or P/T table) + modifiers

The MAP advance can be positive or negative. Under boost, it's usually negative (retards timing).

There's also:
- Maximum timing limiter
- WOT multiplier for negative MAP advance
- Cold engine advance
- Knock retard

---

### Q: What is "base timing" and how does it factor in?

**A:** There is no "base timing" in the ECU. The 12° on your emissions sticker is just a synchronization reference for setting the distributor. The ECU doesn't add this to anything.

All timing values in the calibration are absolute degrees BTDC (Before Top Dead Center), relative to 0° (TDC).

If your distributor sync is off by 2°, your actual timing will be off by 2° from what the ECU reports.

---

### Q: What is AdvanceFromRPMMax table for?

**A:** It's the maximum timing cutoff. Any calculated advance above the lookup value gets clamped to the lookup value.

Example: If combined advance is 60° and the max at that RPM is 53°, you get 53°.

---

### Q: What is MultiplierOnMAPAdvanceWhenRetarding?

**A:** When the WOT advance from MAP is negative (retarding timing under boost), this table multiplies that retard based on RPM. Scaled 0-4.

Chrysler used this to remove more timing at higher RPM under boost. This is why T1 WOT MAP advance tables seem to have more timing than P/T tables - the multiplier removes it under boost.

Most T2 calibrations set this to 1.0 (no effect).

---

## Fueling

### Q: Why does full throttle fuel have fewer data points than part throttle?

**A:** The 3 main fuel tables (N/T, P/T, F/T) set target A/F based on injector size, displacement, fuel properties, and assumed intake temp. The A/F doesn't need many changes across the MAP range.

The Pumping Efficiency (PumpEff) table is where RPM-based fuel adjustments happen. It typically has many more data points.

---

### Q: How does pumping efficiency relate to base fuel?

**A:** The 3 main fuel tables give you an "ideal" pulsewidth assuming 100% volumetric efficiency. Since real engines never flow 100%, PumpEff reduces that ideal PW to match actual engine breathing.

PumpEff is a fraction (0-100%+) applied to the base fuel calculation.

**Up on PumpEff = More fuel (richer)**

---

### Q: The S60 cal has weird PumpEff values. What's the deal?

**A:** Chrysler lazily scaled S60 by only adjusting PumpEff. They didn't touch the 3 main fuel tables for injectors or fuel properties. The PumpEff is set to ~40% volumetric efficiency to compensate.

This is wrong - the DC ported heads flowed much better than 40%. The proper approach is to set fuel tables correctly for your injectors and use PumpEff for actual volumetric efficiency.

---

### Q: How do I adjust fuel at idle/coasting?

**A:**
1. **Reduce PumpEff at low RPM** - Stock values are often 60%+ at idle which is unrealistic. Try 5% increments.
2. **Reduce N/T fuel table** near idle vacuum if you have different cam/timing.
3. **Disable spark scatter temporarily** by setting `TempAboveWhichSparkScatterIsActive` very high.
4. **Disable adaptives** to see true effect of changes.

---

### Q: How do I switch between open-loop and closed-loop?

**A:** Adjust the `NoCellUpdate***` constants:
- `NoCellUpdateAboveThisMAP` - Force open-loop above this MAP
- `NoCellUpdateAboveThisRPM` - Force open-loop above this RPM

For T-LM only: Set `PWMIN_NoCellUpdateBelow_PWMIN_Pulsewidth` high to disable O2 feedback entirely.

---

### Q: How does the target A/F in MPTune work?

**A:** It's just a visualization tool. The ECU doesn't use it directly.

In MPTune's Fueling Setup (Miscellaneous menu), you enter target A/F for each MAP point. MPTune then draws a yellow "phantom line" on the fuel tables showing what pulsewidth would achieve that A/F.

If the yellow line is higher than the actual table, you'll run leaner than target.

---

### Q: How do I adjust Pump Shot for a bigger throttle body?

**A:** There are two pump shot calculations: MAP-based and TPS-based.

**For bigger TB, focus on TPS-based:**
1. Increase POSSLP table in operating temp range
2. If still not enough, increase THRMAX
3. Increasing THRTCN might help (larger value = bigger delta)

**For ported heads, use MAP-based:**
1. Increase AESLOP table in operating temp range
2. If needed, increase MAPMAX
3. Increasing AETIME might help

---

## Boost Control

### Q: How do I raise the overboost cutout point?

**A:** Find the 4 overboost constants (OverboostFuelShutoff***) in the OB/Speed/Rev Limiter section. Set them all to 0xFF to disable.

**Warning:** Only do this with a working boost gauge and properly functioning wastegate!

---

### Q: Why do I only have full boost past 3/4 throttle?

**A:** The `AllowedBoostPartThrottle` table limits boost based on TPS. It's probably set to 5 psi below 3.8V. Adjust this table if you want more boost at part throttle.

---

### Q: How do I disable the adaptives for tuning?

**A:**
- **Fuel:** Set `NoCellUpdateAboveThisMAP` to 0xFF
- **Knock retard:** Set `AdaptiveRetard_MinMAPForAdjustment` to 0xFF
- **Wastegate:** Set `StopAdaptiveWGWhenMapIsThisCloseToBoostTarget` to 0xFF

**Remember to restore these after getting your base tune!**

---

## Hardware

### Q: What chip should I use for my ECU?

**A:**

**LM (Logic Module):**
- 27C128 (16KB) or 27C256 (32KB)
- 29C256 EEPROM works but expensive/rare
- 27SF512 (64KB flash) is cheapest option

**SMEC:**
- Same options as LM
- 27SF512 recommended for ease of use

**SBEC:**
- Requires 87C257 (has built-in latch)
- OR use latch board with standard chips
- Flash module conversion is easiest

---

### Q: What's the difference between a flash module and chip swap?

**A:**
- **Chip swap:** Remove chip, burn new file, reinstall. Requires UV eraser for EPROMs.
- **Flash module:** Reprogram through SCI port using laptop. Takes ~10 seconds. Chip stays installed.

Flash modules use electrically-erasable chips (29C256 or similar) that don't need UV light.

---

### Q: Why does my SBEC need a latch board?

**A:** SBEC uses 87C257 chips which have an integrated address latch. Standard memory chips don't have this latch.

The latch board provides this function externally, allowing you to use standard 27C256 or similar chips.

SMEC doesn't need this because the latch is on the main board.

---

## Software

### Q: Can I use D-Cal with a USB adapter?

**A:** D-Cal requires a dedicated RS232 serial port for flashing. It doesn't work reliably with USB-to-serial adapters.

MPTune works with USB adapters (specifically FTDI-based ones like the BoostButton cable).

---

### Q: What's the difference between D-Cal and MPTune?

**A:**
- **D-Cal:** Binary editor. Edits existing .bin file directly using .tbl file for addresses/scaling.
- **MPTune:** Both binary editor AND template editor. Can create new .bin from .tpl + .asm, or edit existing .bin with .mpt file.

MPTune is more powerful but has a steeper learning curve.

---

### Q: Where can I find complete documentation of all calibration tables?

**A:** The reference section now includes comprehensive documentation:

- **[Table Reference](../reference/table-reference.md)** - Complete reference for all 521 calibration tables with addresses, types, and relationships
- **[Fuel System Flow](../reference/fuel-system-flow.md)** - Detailed fuel calculation flow with Mermaid diagrams
- **[Spark System Flow](../reference/spark-system-flow.md)** - Detailed timing calculation flow with Mermaid diagrams
- **[Boost System Flow](../reference/boost-system-flow.md)** - Detailed boost control flow with Mermaid diagrams

These documents show exactly how all tables interconnect and what affects what in your calibration.
