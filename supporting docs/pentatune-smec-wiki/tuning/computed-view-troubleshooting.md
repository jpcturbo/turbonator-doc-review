# Computed Views Troubleshooting & FAQ

Common issues, questions, and solutions for working with computed views in PentaTune.

## Quick Troubleshooting Index

- [Edits not applying](#edits-not-applying)
- [Values changing unexpectedly](#values-changing-unexpectedly)
- [Display modes not working](#display-modes-not-working)
- [Grid showing error](#grid-showing-error)
- [3D view not available](#3d-view-not-available)
- [Performance issues](#performance-issues)

---

## Edits Not Applying

### "Edit didn't change the value"

**Symptom:** You double-click a cell, enter a new value, press Enter, but the value stays the same.

**Most likely causes:**

1. **The value is already at the target**
   - The algorithm computed the same value was already correct
   - This can happen when source tables are limited

2. **Approximation tolerance reached**
   - You requested 14.2 AFR, nearest achievable is 14.199 AFR
   - The system already had your value
   - Try a more different value to see if editing works

3. **Static source blocking edits**
   - One of the source tables is marked as "static" (not editable)
   - Check the sidebar for "static" labels next to sources

**What to do:**

1. Try editing a **different cell** (far from current location)
2. Try a **larger value change** (20% difference instead of 1%)
3. Check the sidebar **"Source Tables"** section
   - Look for "static" badges
   - Try editing one of the editable sources directly

**Solution:**

If most edits don't work, the view definition may need adjustment. Contact support with:
- The TPL file name
- The view you're editing
- Example cells where edits don't work

---

### "Notification says value was approximated"

**Symptom:** After editing, notification says "Value adjusted to nearest achievable: target was 14.2"

**Why this happens:**

This is **normal and expected**. Computed views combine discrete breakpoints from multiple source tables. Due to interpolation and the limited number of breakpoints, your exact target value might not be achievable.

**Example:**
```
You want: 14.2 AFR
Algorithm found: 14.15 AFR is achievable
Difference: 0.05 AFR = 0.35% error (excellent)
```

**When to worry:**

- Approximation > 2% - try different location
- Approximation > 5% - source tables may be coarse, consider adding breakpoints
- Specific pattern of approximation - may indicate algorithm issue

**How to minimize:**

1. Edit cells in the middle of the map (not edges)
2. Make incremental changes (10% steps instead of 50%)
3. Use views with more source breakpoints
4. Edit cells at existing grid breakpoints when possible

---

### "Edit shows red error box"

**Symptom:** When editing, a red error box appears: "❌ Invalid input: 'abc' is not a number"

**Causes:**

1. **Typo in value** - typed letters instead of numbers
2. **Wrong units** - mixing AFR and Lambda, or decimal formats
3. **Copy-paste error** - copied value with units attached (e.g., "14.2 AFR")

**Solution:**

1. **Clear and retype** - Delete all text in the cell, carefully re-enter value
2. **Check units** - Verify the display mode (bottom of value cell)
3. **Common mistakes:**
   - Entering "14,2" (comma) instead of "14.2" (period)
   - Entering "1.42" in Lambda mode instead of "0.96"
   - Entering "µs 4000" instead of "4000"

---

### "Warning: AFR 5.5 is unusual"

**Symptom:** Yellow notification: "⚠️ AFR 5.5 is unusual (typical: 8-20)"

**What it means:**

The value is outside normal operating ranges. This is a **warning, not an error** - you can proceed if intentional.

**When this appears:**

- AFR < 8 or > 20
- Lambda < 0.5 or > 1.4
- VE% > 150 or < 20
- Spark advance < -20° or > 60°
- Other mode-specific bounds

**Common causes:**

1. **Decimal point error**
   - Meant to enter 15.5 but typed 1.55 or 5.5
   - Check the value carefully

2. **Legitimate extreme tuning**
   - High-boost setup: 11 AFR is normal
   - Cold start enrichment: very rich is expected
   - Race fuel: different stoichiometric ratio

3. **Unit confusion**
   - Entered AFR in Lambda mode (0.96 instead of 14.1)
   - Check the display mode button

**What to do:**

- If accident: **Clear and retype**, verify units
- If intentional: **Proceed normally**, the warning is just informational
- View allows the extreme value

---

## Values Changing Unexpectedly

### "I edited one cell but nearby cells changed"

**Symptom:** You edit cell [2500 RPM, 5 psi], but cells at [2000 RPM, 5 psi] and [3000 RPM, 5 psi] also change.

**This is expected behavior.** Here's why:

**Technical explanation:**

When you edit a cell, your change is distributed to source table breakpoints based on proximity. These breakpoints affect multiple grid cells:

```
Example scenario:
- You edit: [2500 RPM, 5 psi] - between RPM breakpoints 2000 and 3000
- System modifies: RPM breakpoints 2000 and 3000
- Those breakpoints affect: ALL cells from 2000-3000 RPM range
- Result: Cells at 2000, 2250, 2500, 2750, 3000 RPM all shift
```

**This is correct.** It means interpolation is working properly.

**To minimize the effect:**

1. **Edit cells at breakpoint locations**
   - Grid headers show breakpoint values (e.g., 500, 1000, 1500)
   - Edit at these locations to affect only one breakpoint
   - Changes won't spread as much

2. **Make incremental adjustments**
   - Edit 2500 RPM first
   - Let grid update
   - Check surrounding cells
   - Adjust other cells if needed

3. **Edit in sequence from edges**
   - Start at outer edges (low RPM, high MAP)
   - Work toward center
   - Prevents cascading effects

---

### "Entire column changed when I edited one cell"

**Symptom:** Edited cell at [2500 RPM, 5 psi], and the entire 2500 RPM column shifted.

**Cause:**

The source expression uses that RPM value significantly. Some common patterns:

```yaml
expression: "TABLE[y] * RPM_CORRECTION[x]"
```

When you change one cell at RPM=2500, the RPM_CORRECTION table is modified, affecting the entire column.

**Solution:**

This is expected for multiplicative expressions. To reduce the effect:

1. Edit multiple cells in sequence
2. Make smaller value changes
3. Check the sidebar to understand which sources are multiplied vs. added

---

### "Map doesn't look smooth anymore"

**Symptom:** After edits, the heat map has visible "steps" or blocky regions instead of smooth gradient.

**Causes:**

1. **Editing at many different locations** creates peaks/valleys
2. **Large value jumps** between edited cells break smoothness
3. **Coarse source table breakpoints** limit interpolation quality

**How to fix:**

1. **Undo recent edits** (Ctrl+Z) back to smooth state
2. **Re-edit with smaller steps** (5-10% increments instead of 50%)
3. **Smooth the map:**
   - Edit intermediate cells to blend
   - Use 3D view to visualize smoothness
   - Compare to original shape

**Prevention:**

- Work methodically across the map (left to right, or center outward)
- Make gradual changes, not random jumps
- Use undo frequently to verify changes look reasonable

---

## Display Modes Not Working

### "AFR/Lambda mode shows same values as raw mode"

**Symptom:** Switching to AFR display mode, but numbers look the same as raw pulse width (thousands, not 10-20).

**Likely cause:**

Required metadata is missing:
- Injector size not set
- Engine displacement not available
- TPL file doesn't contain fuel metadata

**Check:**

1. Open **File > Properties** (or calibration info)
2. Look for "Injector Size" or "Displacement"
3. If empty, these need to be set first

**Solution:**

1. **Add metadata to TPL file**
   - Use calibration tool to set injector size, displacement
   - Re-load TPL in PentaTune

2. **Or, set metadata in computed view YAML**
   - Edit view definition to include metadata
   - Requires system integration knowledge

---

### "AFR values seem way off"

**Symptom:** At 2000 RPM idle, AFR shows 5.0 (should be ~14.7)

**Common causes:**

1. **Injector size wrong**
   - If too small, AFR calculation inflates
   - If too large, AFR calculation deflates
   - Verify from injector documentation

2. **Display mode unit confusion**
   - Showing Lambda in AFR mode (0.9 != 9.0)
   - Check which mode is selected

3. **Engine displacement wrong**
   - Impacts AFR calculation directly
   - Check engine specs (2.0L, 2.2L, etc.)

4. **Fuel factor from TPL incorrect**
   - ECU-specific scaling factor
   - Verify from ECU documentation

**How to diagnose:**

1. Compare against a known good tune
2. Check raw pulse width values - are they reasonable? (1000-5000 µs typical)
3. If raw values are way off, problem is elsewhere
4. If raw values OK but AFR way off, metadata issue

---

### "Display mode button greyed out"

**Symptom:** AFR or Lambda buttons are disabled (can't click them).

**Why:**

Display mode requires metadata that's unavailable.

**Solution:**

1. **Check TPL file has required fields**
   - Injector size
   - Displacement
   - Fuel factor

2. **View definition has metadata**
   - Edit YAML to add injectorSize, displacement
   - Contact support if unsure how

---

## Grid Showing Error

### "Unable to compute view. Some source parameters may be missing."

**Symptom:** Instead of a grid, see error message and no data.

**Causes:**

1. **TPL file incomplete** - corrupted or partial file
2. **Parameter name mismatch** - view definition uses different names than TPL
3. **Custom calibration format** - old format uses different parameter structure

**Check:**

1. Try **File > Open** with a different TPL file
   - If it works with other files, your current file has an issue

2. Check **sidebar Source Tables** section
   - Look for parameter names
   - Do they match the view definition?

3. Look at **browser console** (F12 Dev Tools)
   - Errors there may explain what parameters are missing

**Solution:**

1. **Use a known good TPL file** - confirm other views work
2. **Contact support** with:
   - Your TPL filename
   - The computed view name
   - Browser console errors

---

### "Grid shows all red/blue (no color variation)"

**Symptom:** The heatmap is a solid color instead of gradient.

**Causes:**

1. **All values identical** - no variation in the computed map
2. **Algorithm issue** - some cells computed as NaN or invalid

**Check:**

1. Hover cells to see individual values
   - Are they all the same number?
   - Are there NaN or undefined values?

2. Try editing a cell
   - Does it affect the display?
   - Are nearby cells updating?

**Solution:**

1. If all cells have valid identical values - this is correct display
2. If NaN values appear - contact support with details
3. Try a different computed view to compare

---

### "Numbers in cells are NaN or undefined"

**Symptom:** Grid cells show "NaN" or "undefined" instead of numbers.

**Causes:**

1. **Expression has invalid syntax** - doesn't parse correctly
2. **Source table missing** - referenced but not found
3. **Division by zero** - expression like `x / 0`
4. **Invalid math** - like `log(-5)` or `sqrt(-1)`

**Solution:**

1. Check **sidebar Formula** section - does expression look correct?
2. Check **sidebar Source Tables** - are all references there?
3. Contact support with screenshot showing the formula

---

## 3D View Not Available

### "2D/3D toggle button is greyed out"

**Symptom:** The toggle switch says "2D" but is disabled (can't click).

**Why:**

3D view requires 2D data (both X and Y axes). 1D views (single lookup curves) have no 3D representation.

**Check:**

- Look at grid structure
- Does it have rows (Y-axis label) or just one row?
- If one row only → 1D view → 3D not available

**Examples:**

- Part Throttle Fuel (both RPM and MAP axes) → 3D available ✓
- RPM Correction (only RPM axis) → 3D not available ✗
- Idle Spark (both RPM and Coolant Temp) → 3D available ✓

---

### "3D view is very slow or jerky"

**Symptom:** Switching to 3D takes several seconds, or interaction is laggy.

**Causes:**

1. **Large grid** - thousands of cells
2. **GPU limited** - 3D rendering uses GPU
3. **Browser performance** - heavy tab/extension activity

**Solutions:**

1. **Reduce quality** - smaller grid with fewer cells
2. **Switch back to 2D** - for editing
3. **Close other tabs** - free up system resources
4. **Use 2D mode primarily** - 3D is visualization only

---

### "3D view distorted or missing geometry"

**Symptom:** 3D surface looks flat, twisted, or has holes.

**Causes:**

1. **Grid has NaN values** - prevents proper mesh
2. **Extreme value ranges** - auto-scaling broken
3. **Browser 3D support issue** - WebGL problems

**Solution:**

1. Switch back to 2D mode
2. Check for invalid values (NaN, undefined, extreme numbers)
3. Try a different browser
4. Contact support if persists

---

## Performance Issues

### "Grid recomputes slowly after edits"

**Symptom:** After confirming an edit, it takes 1-2 seconds for grid to update.

**Expected behavior:**

- Grid recompute: 100-300ms typical
- If slower, something else may be happening

**Possible causes:**

1. **Undo/redo history growing** - lots of edits accumulate
2. **Large grid** - 100+ columns or rows
3. **Complex expression** - many operations per cell
4. **Browser performance** - low resources available

**Solutions:**

1. **Clear history** - start with "New" view (loses edit history)
2. **Use simpler expressions** - fewer operations per cell
3. **Close other tabs** - free up memory and CPU
4. **Restart browser** - clear memory leaks

---

### "Undo/redo buttons stop working"

**Symptom:** After many edits, Ctrl+Z and redo buttons don't respond.

**Cause:**

History stack limit (50 edits) reached. Oldest edits are removed.

**Solution:**

1. This is expected behavior - stack size is limited
2. You can still undo recent edits (last 50)
3. If need more history, make incremental saves to different files

---

### "Browser tab crashes when opening view"

**Symptom:** Tab becomes unresponsive or shows "This page has become unresponsive" dialog.

**Causes:**

1. **Memory exhausted** - huge grid or corrupted data
2. **Infinite loop** in expression parser
3. **Browser bug** - known 3D rendering issue

**Solutions:**

1. **Hard refresh** (Ctrl+Shift+R) to clear cache
2. **Try different browser** - Chrome, Firefox, Edge, Safari
3. **Reduce grid size** - edit view definition to smaller ranges
4. **Update browser** - latest version may have fixes

---

## Common Questions

### Q: Can I edit multiple cells at once?

**A:** No, currently you can only edit one cell at a time. However:
- You can rapidly edit adjacent cells
- Undo works for batch changes
- Use undo/redo to verify effects

Future versions may add multi-cell editing.

---

### Q: Why does my edit affect cells far away?

**A:** See "[Values Changing Unexpectedly](#values-changing-unexpectedly)" section.

TL;DR: It's correct. Your change is distributed to source breakpoints, which can affect distant cells through interpolation.

---

### Q: Can I lock certain cells so they don't change?

**A:** Not directly. However:
- Undo (Ctrl+Z) will revert changes
- Save multiple versions of the file
- Create separate tuning sessions

---

### Q: How do I compare my edits to the original?

**A:**
1. **Side-by-side files** - Open original and edited in two windows
2. **Visual comparison** - 3D view shows overall map shape
3. **Undo to original** - Use history to compare
4. **Export/backup** - Save version before major changes

---

### Q: Why are some source tables marked "static"?

**A:** Static sources are reference-only:
- **Limits** - RPMLMT, SPKLMT (define bounds, shouldn't be edited)
- **Corrections** - temperature factors (for reference, not direct tuning)
- **Special data** - data that shouldn't be modified by user edits

They're shown for transparency about what affects the computed value, but the algorithm skips them during edits.

---

### Q: Can I export the computed view as a table?

**A:** Currently, only viewing and editing in-app. Future features may include:
- Export as CSV
- Comparison tool showing differences
- 3D visualization export

---

### Q: What's the difference between "affected" and "breakpoint" cells?

**A:** During editing, the influence zone shows:

- **Breakpoint cells** (blue striped): Source table breakpoints that are directly modified
- **Affected cells** (light blue): Grid cells that change due to interpolation of modified breakpoints
- **Editing cell** (blue ring): The cell you're currently editing

See [Influence Zones](../reference/influence-zones.md) for details.

---

## Still Having Issues?

If your problem isn't here:

1. **Check debug log**
   - Restart PentaTune with debug enabled
   - Look for error messages in terminal
   - Save the debug output

2. **Create minimal reproduction**
   - Exact steps to reproduce
   - Screenshot showing the issue
   - Your TPL filename (if shareable)

3. **Contact support with:**
   - Your PentaTune version
   - Your OS and browser
   - Debug log output
   - Screenshots showing the issue

---

## See Also

- [Computed View Editing Guide](./computed-view-editing.md)
- [Influence Zones Algorithm](../reference/influence-zones.md)
- [Display Transforms](../reference/display-transforms.md)
- [Parameter Editing Basics](./parameter-editing.md)
