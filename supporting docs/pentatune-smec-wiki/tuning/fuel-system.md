# Fuel System

## Overview

Chrysler turbo ECUs use a Speed-Density fuel injection system. Unlike Mass Air Flow (MAF) systems, Speed-Density estimates airflow based on manifold pressure (MAP), engine speed (RPM), and air temperature.

## Speed-Density Theory

### Basic Principle

The ECU calculates how much air enters the engine based on:
1. **Manifold Absolute Pressure (MAP)** - Higher pressure = more air
2. **Air Temperature** - Cooler air = denser = more air
3. **Engine Displacement** - Fixed value
4. **Volumetric Efficiency** - How well the engine breathes at given RPM

### The Fuel Equation

Base pulsewidth is calculated using:

```
         (MAP × (6894.8 / (287.05 × (273.15 + TEMP)))) × DISPL / 1000) × 3600
PW = ─────────────────────────────────────────────────────────────────────────
                            4 × AFR × INJFLOWRATE × 2.2

Where:
  MAP = Manifold pressure in PSI
  TEMP = Air temperature in °C
  DISPL = Engine displacement in liters
  AFR = Target air-fuel ratio
  INJFLOWRATE = Injector flow rate in lb/hr
```

## Fuel Tables

### Three Main Fuel Tables

The ECU uses three separate fuel tables based on throttle position:

| Table | Condition | Purpose |
|-------|-----------|---------|
| N/T (No-Throttle) | Throttle closed | Idle, decel, coast |
| P/T (Part-Throttle) | Throttle partially open | Cruising, light load |
| F/T (Full-Throttle) | WOT detected | Maximum power demand |

### Table Selection Logic

```
                    ┌─────────────┐
                    │   Throttle  │
                    │   Pressed?  │
                    └──────┬──────┘
                           │
              ┌────────────┴────────────┐
              │ NO                      │ YES
              ▼                         ▼
        ┌───────────┐           ┌───────────────┐
        │  N/T Table│           │ Full Throttle?│
        │  ($81BA)  │           └───────┬───────┘
        └───────────┘                   │
                               ┌────────┴────────┐
                               │ NO              │ YES
                               ▼                 ▼
                         ┌───────────┐    ┌───────────┐
                         │  P/T Table│    │  F/T Table│
                         │  ($81E8)  │    │  ($8220)  │
                         └───────────┘    └───────────┘
```

### Table Format

Each fuel table is indexed by MAP pressure:
- X-axis: MAP sensor reading (0-255)
- Y-axis: Pulsewidth (16-bit value)

### MPTune AFR Metadata vs. Actual ECU Tables

**Important distinction:** MPTune template files contain AFR metadata that is separate from the actual fuel pulsewidth data the ECU uses.

| Metadata Type | Purpose | ECU Uses It? |
|---------------|---------|--------------|
| `;mpfuelfull1` / `;mpfuelfull2` | WOT AFR targets across RPM (MPTune display) | **No** - visualization only |
| `;mpfuelpart1` / `;mpfuelpart2` | Part-throttle AFR targets (MPTune display) | **No** - visualization only |
| `;mpfuelnone1` / `;mpfuelnone2` | No-throttle AFR targets (MPTune display) | **No** - visualization only |
| `WOTTBL_FuelFullThrottle` | Actual MAP vs. Pulsewidth table | **Yes** - real fuel data |
| `MAPTBL_FuelPartThrottle` | Actual MAP vs. Pulsewidth table | **Yes** - real fuel data |

**How MPTune's "Target AFR" Works:**
1. You enter AFR targets in MPTune's Fueling Setup (stored as `;mpfuel*` metadata)
2. MPTune calculates what pulsewidth would achieve that AFR
3. A yellow "phantom line" is drawn on the fuel table for comparison
4. If the yellow line is higher than actual values = running leaner than target
5. If the yellow line is lower than actual values = running richer than target

**The ECU does NOT use AFR targets** - it uses pulsewidth values directly. The `;mpfuel*` metadata is purely for MPTune's visualization and editing assistance.

When you edit a value in `mpfuelfull1` from 11.5 to 20:
- **MPTune**: Updates the yellow phantom line display (targeting 20:1 AFR at that RPM)
- **ECU**: No change - still uses the pulsewidth values in `WOTTBL_FuelFullThrottle`

## Fuel Modifiers

After looking up the base pulsewidth from the table (N/T, P/T, or F/T), the ECU applies modifiers in `CalculateSumOfAllFuelModifiers_MM`. The sequence below is the **exact application order** from the firmware.

### Modifier Application Order

| Step | Modifier | Tables / Variables | Notes |
|------|----------|-------------------|-------|
| 1 | **Cold enrichment curve C** (decay) | `CURVEC_FuelColdEnrichmentCurveC` × `Factor_ACVDCY` | CurveC phased out with ACVDCY decay factor |
| 2 | **Cold enrichment curve A** (decay) | `CURVEA_FuelColdEnrichmentCurveA` × `Factor_ACVDCY` | Same decay factor as CurveC |
| 3 | **Cold enrichment curve B** | `CURVEB_FuelColdEnrichmentCurveB` | Not decay-scaled; at WOT also scaled by `FCRCVB` from RPM |
| 4 | **Cold load factor** | `HIGHMP_ColdLoadFromCoolantTemp` × `HMPMUL_ColdLoadFromMAP` / 32 | MAP × CTS combination; doubled when off-idle |
| 5 | **Baro compensation of warmup** | `BAROCP_BaroCompensationOfWarmupFactor` | Scales the combined cold enrichment sum |
| 6 | **Charge temp compensation** | `AIRTMP_FuelEnrichmentFromChargeTemp` | Indexed by ChargeTemp |
| 7 | **Off-throttle enrichment** | `Timer_OffThrottleFuelEnrich` | Brief enrichment on throttle close |
| 8 | **Decel leanout (throttle)** | `Factor_DecelLeanoutWhenThrottleDecreasing` | Applied when TPS is falling |
| 9 | **Decel leanout (MAP)** | `Factor_DecelLeanoutWhenMAPDecreasing` | Applied when MAP is falling |
| 10 | **Adaptive memory correction** | `ValueFromAdaptiveMemory` | Signed; bidirectional; only active in closed-loop |
| 11 | **O2 ramp feedback** | `Counter_PrimaryAndSecondaryRamp` | Primary/secondary ramp output; also signed |
| 12 | **Pumping efficiency** | `PEFTBL_PumpingEfficiency` (indexed by RPM) | Final multiplier; if table returns 0, skips scale step |

The result is stored in `SumOfFuelModifiers_HB/LB`. This is then used to scale the base pulsewidth.

### Spark Scatter Fuel Addition

When spark scatter is active (`b55_UseSparkScatter` flag set), an additional stabilization pulsewidth is added **after** the normal modifier chain:

```
FinalPW += SparkScatterFuelStabilizationValue_HB
```

This is a separate two-byte accumulator that adds fuel at idle to compensate for the slight combustion reduction caused by timing dithering.

### Modifier Details

#### Cold Enrichment (Curves A, B, C)

Three separate CTS-indexed enrichment curves:
- **CurveA** and **CurveC**: Phased out after engine reaches run mode. The decay factor `ACVDCY` decrements over time and is multiplied into both. Once decayed to zero, CurveA/C contribute nothing.
- **CurveB**: Permanent enrichment curve (not decayed), always active when cold. At WOT, an RPM-based scale factor `FCRCVB` is applied to CurveB.

Phase-out switches at `TMPHLD_TempSwitchPointForCurveAHoldDecay` — above this CTS, CurveA/C decay faster.

#### Cold Load Factor

```
ColdLoad = HIGHMP[CoolantTemp] × HMPMUL[MapValue] / 32
```

Two separate pairs of tables exist: one for off-idle (`HIGHM2`, `HMPMU2`) and one for idle (`HIGHMP`, `HMPMUL`). The off-idle tables are selected when `b4f_OffIdle` is set.

#### Baro Compensation of Warmup

`BAROCP` scales the entire combined cold enrichment result (steps 1–4) by baro pressure. At sea level this is approximately 1.0.

#### Decel Leanout

Two separate leanout factors are applied multiplicatively. They reduce fuel delivery when:
- TPS is actively decreasing (throttle-based)
- MAP is actively decreasing (MAP-based)

Both are initialized at throttle/MAP decrease events and decay to zero over time.

#### Adaptive Memory vs O2 Ramp

`ValueFromAdaptiveMemory` is the long-term EEPROM cell value for the current operating point. `Counter_PrimaryAndSecondaryRamp` is the short-term O2 feedback counter. Both are applied as signed multipliers — positive values add fuel, negative values remove it.

At WOT or during open-loop fraction timers, adaptive memory can still apply a partial correction (see the complex gating logic in `HandleO2Processing_MM`).

#### Pumping Efficiency (PEFTBL)

A final RPM-indexed multiplier representing volumetric efficiency. If the table returns zero at the current RPM, the scale step is skipped and the sum is used directly. Otherwise the sum is multiplied by the PEFTBL value.

**Tuning note:** Stock S60 calibrations use low PEFTBL values as a scaling hack. If the fuel table values seem abnormally high to compensate, PEFTBL is likely the cause.

## Accelerator Pump (Pumpshot)

When the throttle is rapidly opened, extra fuel is added to prevent lean tip-in.

### Two Calculation Methods

**MAP-Based Pumpshot:**
```
DeltaMAP = Current MAP - Average MAP (filtered)

If DeltaMAP > MAPTRG threshold:
  PumpShotPW = AESLOP[CTS] × DeltaMAP
```

**TPS-Based Pumpshot:**
```
DeltaTPS = Current TPS - Average TPS (filtered)

If DeltaTPS > POSTRG threshold:
  PumpShotPW = POSSLP[CTS] × DeltaTPS
```

### Key Pumpshot Parameters

| Parameter | Purpose |
|-----------|---------|
| AETIME | Time constant for MAP averaging |
| MAPTRG | Threshold for MAP-based pumpshot |
| MAPMAX | Maximum DeltaMAP to use |
| AESLOP | Multiplier table vs coolant temp |
| THRTCN | Time constant for TPS averaging |
| POSTRG | Threshold for TPS-based pumpshot |
| THRMAX | Maximum DeltaTPS to use |
| POSSLP | Multiplier table vs coolant temp |

### Tuning Pumpshot

**For bigger throttle body:**
1. Increase POSSLP values in operating temp range
2. May need to increase THRMAX

**For heavily ported heads:**
1. Increase AESLOP values in operating temp range
2. May need to increase MAPMAX

## Open-Loop vs Closed-Loop

### Open-Loop Conditions

ECU uses calibration values directly:
- Cold engine (below CTS threshold)
- WOT (above MAP threshold)
- High load (above MAP threshold)
- First few minutes after startup

### Closed-Loop Conditions

ECU adjusts fuel based on O2 sensor:
- Warm engine
- Part throttle
- Below specified MAP threshold
- O2 sensor active and valid

### Forcing Open-Loop

For tuning purposes, force open-loop by setting:
- `NoCellUpdateAboveThisMAP` to 0xFF
- `PWMIN_NoCellUpdateBelow_PWMIN_Pulsewidth` high

Remember to restore these after getting base tune!

## Starting Fuel

Separate fuel calculation for cranking:

### Starting Fuel Flowchart

```
Engine Running? ──► YES ──► Return (use normal calc)
       │
       │ NO
       ▼
Full Throttle? ──► YES ──► PW = 0 (flood clear mode)
       │
       │ NO
       ▼
Lookup CTS-based starting fuel ($8157)
       │
       ▼
Square result, scale by EPP ($817F)
       │
       ▼
Apply baro compensation ($8191)
       │
       ▼
Apply CTS modifier ($818A)
       │
       ▼
Store as starting pulsewidth
```

### Transitioning to Running Fuel

Once engine starts:
1. Compare starting PW to running PW
2. Use whichever is larger initially
3. Reduce starting fuel over time based on CTS
4. Eventually switch to running fuel only

## Fuel Calculation Summary

```
Final PW = (Base PW from table)
         × (Pumping Efficiency)
         × (Coolant Temp Enrichment)
         × (Charge Temp Compensation)
         × (Baro Compensation)
         × (O2 Feedback adjustment)
         × (Adaptive Memory correction)
         + (Accelerator Pump addition)
         + (Idle Error PW adjustment)
```

## Common Tuning Adjustments

### Richer at Idle
1. Reduce PumpEff at low RPM (try 5% increments)
2. Reduce N/T fuel table near idle vacuum

### Richer at WOT
1. Increase F/T fuel table values
2. Check PumpEff at target RPM range

### Lean Tip-In
1. Increase POSSLP (TPS-based pumpshot)
2. Increase AESLOP (MAP-based pumpshot)
3. Adjust time constants (THRTCN, AETIME)

### Rich at Cruise
1. Reduce P/T fuel table values
2. Verify O2 feedback is working
3. Check adaptive memory values

---

## ASM Implementation

- `CalculatePartThrottleEnrichmentAndSparkScatterFuel_MM` - T-SMEC_v19.asm:5777

### Part-Throttle Enrichment Internals

`CalculatePartThrottleEnrichmentAndSparkScatterFuel_MM` does two jobs in one main-loop routine:

1. It updates the part-throttle enrichment state byte used to scale the part-throttle fuel table.
2. It calculates the additive fuel stabilization value used when spark scatter is controlling idle.

This routine runs in the `_MM` group, which means it is called from the MainProgramLoop.

#### Calibration inputs and RAM used by the routine

| Item | Address | Stock default | Use in routine |
|------|---------|---------------|----------------|
| `RPMMAP_SwitchPointForDownUp_FromRpm` | ROM `0x83D8`, TPL `0x0ADD` | Raw points `5B:9B`, `64:70`, `71:5F`, `80:4C`, `A3:36` | RPM-indexed MAP switch point lookup |
| `PTELMT_MultiplierMaxLimitFromRpm` | ROM `0x83EF`, TPL `0x0AF0` | Raw points `48:1F`, `58:2C`, `71:32`, `7D:48`, `8A:4E`, `A6:55` | RPM-indexed ceiling for part-throttle enrichment |
| `PTEADJ_EnrichAdjust_FromMap` | ROM `0x8406`, TPL `0x0B03` | Raw points `51:79`, `85:00`, `A4:00`, `BE:CD`, `CF:86`, `EE:33` | MAP-based adjustment applied to the ceiling |
| `PTENR_EppPerAmountForIncreasing` | ROM `0x8421`, TPL `0x0B17` | Raw word `0x3201` | Above-switch rate pair used by the state machine |
| `PTENR2_EppPerAmountForDecreasingMultiplier` | ROM `0x8423`, TPL `0x0B24` | `0x3D` | Below-switch EPP countdown |
| `PTENRD_AmountForDecreasingMultiplier_Negative` | ROM `0x8424`, TPL `0x0B31` | `0xFF` | Below-switch signed step, stock `-1` |
| `PTENUM_NumberToReturnToHOTMAP` | ROM `0x8425`, TPL `0x0B3E` | `0x0F` | Hysteresis distance below `PTELMT` before clearing max state |
| `BOOSTP_AdjustO2ResponseForPTEWhenMapAboveThis` | ROM `0x8426`, TPL `0x0B4B` | `0xFF` | Prevents negative O2 ramp carryover logic from running in normal calibrations |
| `BATOFF_FuelBatteryOffset` | ROM `0x8235`, TPL `0x080E` | Raw points `9E:65`, `AD:50`, `BD:3F`, `CD:31`, `DC:26`, `ED:1E` | Injector latency lookup from battery voltage |
| `PWADD_FuelPWModifierFromBaro` | ROM `0x8358`, TPL `0x0977` | Raw points `55:10`, `6A:0A`, `77:00` | Additive baro fuel compensation |
| `IDLADD_FuelStabilization_FromDeltaRPM` | ROM `0x8143`, TPL `0x06BB` | Raw points `03:00`, `1C:10`, `35:20` | Idle scatter fuel trim from RPM error |
| `IDLTMP_Use_IDLADD_AboveThisTemp` | ROM `0x814E`, TPL `0x06CC` | `0x8A` | Coolant threshold for using `IDLADD` |
| `BitFlags_4f` | 0x004F | `b4f_OffIdle = 0x80`, `b4f_PTEisMaxed = 0x02` | Off-idle and maxed-PTE state bits |
| `BitFlags_50` | 0x0050 | `b50_IdleSpeedMode = 0x08` | Blocks scatter fuel trim when set |
| `BitFlags_55` | 0x0055 | `b55_UseSparkScatter = 0x10` | Enables scatter fuel stabilization path |
| `Counter_FallingEdgeEPP_MaxFF` | 0x0074 | RAM | Stores the bit-7 region flag plus the EPP countdown accumulator |
| `Timer_OpenLoopFraction` | 0x0077 | RAM | Stores the live part-throttle enrichment amount |
| `Counter_PrimaryAndSecondaryRamp` | 0x007D | RAM | Cleared to zero if negative under the post-PTE O2 logic |
| `SparkScatterFuelStabilizationValue_HB` | 0x008F | RAM word | Additive fuel used later in final pulsewidth assembly |
| `InjectorLatency` | 0x0092 | RAM | Battery-offset lookup result |
| `TargetIdleSpeed_HB` | 0x0057 | RAM word | Idle speed target for scatter trim |
| `EngineRpm_HB` | 0x005D | RAM word | Input for `RPMMAP`, `PTELMT`, and idle error |
| `MapValue` | 0x0063 | RAM | Input for switch-point and `PTEADJ` lookups |
| `CoolantTemp` | 0x006A | RAM | Input for `IDLTMP` compare |
| `BatteryVolts` | 0x006B | RAM | Input for `BATOFF` lookup |
| `BaroPressure` | 0x000E | RAM | Input for `PWADD` lookup |
| `Temp0`, `Temp1`, `Temp4` | 0x00BF, 0x00C0, 0x00C3 | RAM scratch | Working storage inside the routine |

#### Bit-7 region detection and the switch-point lookup

The routine starts by looking up `RPMMAP_SwitchPointForDownUp_FromRpm` using `EngineRpm_HB`. The returned MAP threshold is compared to `MapValue`, then `rora` rotates the compare carry into bit 7. After `anda #0x80`, only that one region bit remains.

That bit is stored in `Temp0` and then XORed with `Counter_FallingEdgeEPP_MaxFF`. This is the key bit-7 state check. Despite the `Bit7_IsSet` and `Bit7_IsClear` labels, the code is really checking whether the newly computed region bit matches the previously stored region bit in `Counter_FallingEdgeEPP_MaxFF`.

- If the bit changed, the routine stores the new bit-7 state into `Counter_FallingEdgeEPP_MaxFF`, loads the current `Timer_OpenLoopFraction`, and skips the EPP countdown math for this pass.
- If the bit did not change, the routine continues with the selected EPP rate pair and updates the low 7 bits of `Counter_FallingEdgeEPP_MaxFF` as its countdown accumulator.

So `Counter_FallingEdgeEPP_MaxFF` is not just a counter. Bit 7 remembers which side of the RPM/MAP switch line the engine is on, and bits 0 through 6 hold the accumulated event count used to decide when to step the enrichment amount.

#### Ramp-rate selection and `Timer_OpenLoopFraction`

The code loads `X` with `PTENR_EppPerAmountForIncreasing`, then advances `X` by two bytes when the MAP is below the RPM-based switch point. In the stock layout that produces these two rate pairs:

- **MAP above switch point**: `PTENR_EppPerAmountForIncreasing = 0x3201`, so the routine uses `0x32` EPP per step and adds `+1` to `Timer_OpenLoopFraction`.
- **MAP below switch point**: the `inx` / `inx` path lands on the adjacent `PTENR2` / `PTENRD` bytes, so the routine uses `0x3D` EPP per step and adds `0xFF`, which is signed `-1`, to `Timer_OpenLoopFraction`.

Inside the matched-bit path, the low 7-bit event count is compared to the selected EPP threshold. When the threshold is reached, the counter is reduced by that threshold and the selected signed step is applied to `Timer_OpenLoopFraction`.

The result is then saturated:

- underflow clamps to `0x00`
- positive overflow clamps to `0x7F`

That proposed value is stored in `Temp0` while the routine decides whether it may actually be written back to `Timer_OpenLoopFraction`.

`Timer_OpenLoopFraction` is the live PTE state byte. Later, when the ECU chooses between `MAPTBL_FuelPartThrottle` and `WOTTBL_FuelFullThrottle`, it loads the part-throttle pulsewidth into `Temp5`, calls `ScaleXbyB_addingA_intoD` with `A = 0x01` and `B = Timer_OpenLoopFraction`, and uses the scaled result as the part-throttle candidate before comparing it to the WOT lookup. The same byte is also checked by `HandleO2Processing_MM`, where a nonzero value keeps the ECU in stay-open-loop when the engine is not off-idle.

#### Ceiling control with `PTELMT`, `PTEADJ`, and `b4f_PTEisMaxed`

After the proposed `Timer_OpenLoopFraction` value is calculated, the routine looks up `PTELMT_MultiplierMaxLimitFromRpm` by RPM and stores that result in `Temp4`. It then looks up `PTEADJ_EnrichAdjust_FromMap` by MAP.

If the `PTEADJ` result is zero, the RPM-based `PTELMT` value is used directly. If the `PTEADJ` result is nonzero, the code multiplies the `PTELMT` value by the `PTEADJ` lookup result and uses that adjusted result as the effective ceiling before comparing it to `Temp0`.

If the effective ceiling is less than or equal to the proposed `Timer_OpenLoopFraction`, the routine sets `b4f_PTEisMaxed` in `BitFlags_4f` and stores the proposed value.

If the proposed value is below the ceiling, the routine checks whether `b4f_PTEisMaxed` was already set:

- If the flag was clear, it simply stores the proposed value.
- If the flag was set, it applies hysteresis before clearing it.

That hysteresis uses `PTENRD_AmountForDecreasingMultiplier_Negative` and `PTENUM_NumberToReturnToHOTMAP` exactly as coded:

1. `Temp1 = ceiling - Timer_OpenLoopFraction`
2. `PTENRD` is loaded, and stock `0xFF` is negated to `0x01`
3. That result is multiplied by `PTENUM` (stock `0x0F`)
4. If the current PTE amount is still within that 15-count window below the ceiling, `b4f_PTEisMaxed` stays set
5. Once it falls farther below the ceiling, `b4f_PTEisMaxed` is cleared

That is why the flag is a sticky state bit instead of a simple one-pass clamp indicator. It stays set until the enrichment amount decays far enough below the limit.

Two later routines use that flag directly:

- `HandleO2Processing_MM` treats `b4f_PTEisMaxed` plus stay-open-loop as a reason to stop using O2 feedback.
- `CalculateSumOfAllFuelModifiers_MM` skips the non-maxed part-throttle cold-load path when `b4f_PTEisMaxed` is set, using the same branch path as full throttle.

#### Post-PTE O2-ramp cleanup

After `Timer_OpenLoopFraction` is stored, the routine checks a small O2-related cleanup path. It jumps into the cleanup block immediately when the engine is off-idle and `Timer_OpenLoopFraction` is nonzero. If that does not happen, it compares MAP to `BOOSTP_AdjustO2ResponseForPTEWhenMapAboveThis`. Only when one of those paths reaches `L1508` does it inspect `Counter_PrimaryAndSecondaryRamp`, and if that byte is negative it clears it to zero.

In the stock calibration `BOOSTP` is `0xFF`, so this MAP-above-threshold branch never becomes true during normal operation. The code path still exists, but the stock threshold disables it.

#### Injector latency, baro compensation, and spark-scatter fuel stabilization

The second half of the routine prepares the additive fuel values used later in final pulsewidth assembly.

First it calculates injector latency:

- If `b45_Bad_BatVolts` is set, it forces the battery input to `0xE2`
- Otherwise it uses live `BatteryVolts`
- That value is looked up in `BATOFF_FuelBatteryOffset`
- The result is stored in `InjectorLatency` at `0x0092`

Next it calculates additive baro fuel compensation:

- `BaroPressure` is looked up in `PWADD_FuelPWModifierFromBaro`
- The byte result is shifted left twice with two `asld` instructions
- The resulting word is stored in `Temp0`

That `Temp0` word becomes the base value for `SparkScatterFuelStabilizationValue_HB` unless all three of these conditions are true:

1. `CoolantTemp` is above `IDLTMP_Use_IDLADD_AboveThisTemp` (stock `0x8A`)
2. `b50_IdleSpeedMode` is clear
3. `b55_UseSparkScatter` is set

If those conditions are not met, the routine just copies the baro-derived word in `Temp0` to `SparkScatterFuelStabilizationValue_HB`.

If all three conditions are met, the routine enters `UsingSparkScatterToControlIdle`:

1. It computes RPM error as `EngineRpm_HB - TargetIdleSpeed_HB`
2. It converts negative errors to absolute value for the table lookup path
3. `DIN_ACLRDBOUT_CALCULATE_BASEDON_IDLE_ERROR_ROUTINE` divides the RPM error by 16 with four `lsrd` instructions
4. That scaled delta-RPM value is looked up in `IDLADD_FuelStabilization_FromDeltaRPM`
5. The looked-up word is then added to or subtracted from the baro-based `Temp0` value, depending on whether RPM is below or above target
6. The signed result is stored in `SparkScatterFuelStabilizationValue_HB`

Later, in the main fuel assembly path, `SparkScatterFuelStabilizationValue_HB` is added directly to the selected base pulsewidth.

Routines ending with `_MM` are called from the MainProgramLoop (see T-SMEC_v19.asm line 319).

### Starting Fuel Internals

`CalculateInjectorPulsewidthForStarting_MM` (`T-SMEC_v19.asm` lines 5483 through 5542) owns the cranking-only pulsewidth path. The routine returns immediately unless `b54_FuelEngineNotRunning` is set, which keeps it out of the normal running-fuel path.

The first thing it does is clear `Pulsewidth_PartThrottleEnrichment_HB`, then inspect throttle angle to decide whether cranking fuel should be suppressed for clear-flood behavior:

- If `TpsVolts` is at or above `0xD0`, it jumps straight to `ThrottleFlooredWhileStarting_UnloadFuel` and forces the starting pulsewidth to zero.
- If throttle is only slightly above `MINTHR_LowestSessionTPS`, it compares that delta to `UNLOAD_DeltaThrottleFrom_MINTHR_ToUnloadCrankingFuel` and also unloads fuel when the threshold is met.

If the clear-flood checks do not trip, the routine builds the cranking pulsewidth in this order:

1. `AllowForHeatSoakAfterStall` adjusts the effective coolant input when the engine was recently hot.
2. Closed-throttle cranking is clamped by `STRLMT_ColdestTempAllowedAtClosedThrottle`, which prevents the lookup from using a colder-than-allowed temperature.
3. `STRTFL_FuelStartFromCoolantTemp` is looked up from the adjusted temperature, then squared with `mul` and stored in `Temp0`.
4. `Counter_EPP_MaxFF` is used to look up `EPPMUL_FuelStartFuelPerEPP`, and `ScaleYbyA` applies that decay factor to the squared starting-fuel value.
5. `BaroPressure` indexes `STFBAR_FuelStartReductionFromBaro`.
6. `CoolantTemp` indexes `STFTMP_FuelStartFuelFromCoolant`.
7. The baro and temperature factors are multiplied together. If the product is nonzero, the routine negates the high byte and uses `ScaleYbyA` to reduce the starting-fuel word in `Temp0`.

That matches the high-level start-fuel description earlier in this page. The ASM makes the order concrete: the squared `STRTFL` result is scaled by EPP first, then reduced by the combined baro and coolant correction, not by separate additive steps.

The finished cranking value is passed through `CallAndReturn1`, stored in `InjectorPulsewidth_HB`, then the routine seeds `Factor_StartFuelDecayIntoRunFuel` from `SFDCAY_FuelStartDecayIntoRun`. That decay factor is not consumed here. It is carried forward for the later start-to-run handoff in the distributor-interrupt path.

### Fuel Modifier Summation Internals

`CalculateSumOfAllFuelModifiers_MM` (`T-SMEC_v19.asm` lines 5929 through 6138) builds the multiplier word later stored in `SumOfFuelModifiers_HB/LB`. This routine does not select a base fuel table. Instead, it assembles the combined enrichment and leanout factor that the interrupt-path running-fuel code applies to the chosen base pulsewidth.

The opening block manages decay state for cold-enrichment curves A and C:

- If `b54_FuelEngineNotRunning` is still set, the routine skips the decay logic and starts with a cleared accumulator.
- Otherwise it compares `CoolantTemp` to `TMPHLD_TempSwitchPointForCurveAHoldDecay`, checks `b50_FuelCurveACToggle`, and uses `KeyOnOrEngineRunningTime` plus `DCYTMC_CurveAColdDecayTime` to decide whether decay should begin.
- Once decay has begun, `Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached` is decremented on the cadence gated by `Counter_MainLoop`.

After that setup, the modifier sum is built in a fixed sequence:

1. **Cold curves C and A, when allowed**. The routine uses `AllowForHeatSoakAfterStall` for the temperature input, looks up `CURVEC_FuelColdEnrichmentCurveC` and `CURVEA_FuelColdEnrichmentCurveA`, and scales them by `Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached` when the decay toggle is active.
2. **Cold curve B, always present in this stage**. `CURVEB_FuelColdEnrichmentCurveB` is looked up from `CoolantTemp`. At full throttle, `FCRCVB_FuelWOTScaleEnrichBFromRpm` scales curve B before it joins the sum.
3. **Cold-load enrichment, only when not full throttle and not PTE-maxed**. The routine switches between `HIGHMP` / `HMPMUL` and `HIGHM2` / `HMPMU2` based on `b4f_OffIdle`, multiplies the coolant and MAP terms together, divides by 32, and adds that result into the same accumulator.
4. **Barometric warmup compensation**. `BAROCP_BaroCompensationOfWarmupFactor_FromBaro` scales the accumulated cold-enrichment word.
5. **Charge-temperature compensation**. `AIRTMP_FuelEnrichmentFromChargeTemp` is applied through `ScaleXbyB_addingA_intoD`, which treats the current sum as a multiplier plus offset form rather than a plain lookup replacement.
6. **Off-throttle enrichment timer**. A nonzero `Timer_OffThrottleFuelEnrich` scales the same accumulator again.
7. **Throttle-based decel leanout** through `Factor_DecelLeanoutWhenThrottleDecreasing`.
8. **MAP-based decel leanout** through `Factor_DecelLeanoutWhenMAPDecreasing`.
9. **Adaptive memory**, but only when not full throttle and when `Timer_OpenLoopFraction` is zero. The routine pulls `ValueFromAdaptiveMemory`, treats it as signed, halves it with `asrb`, and applies it with `ScaleXbyB_addingA_intoD`.
10. **Primary and secondary O2 ramp correction** through `Counter_PrimaryAndSecondaryRamp`, with optional bias from `ADMEMA_ValueFromAdaptivememoryAdder1` when the EGR state bit is set.
11. **Pumping efficiency** through `PEFTBL_PumpingEfficiency`. If the lookup returns zero, the routine stores the pre-PEFTBL word directly. Otherwise it scales the word and stores the result in `SumOfFuelModifiers_HB`.

Two branch choices matter for interpretation:

- `b4f_PTEisMaxed` takes the same branch as full throttle for the cold-load section. In other words, a maxed part-throttle enrichment state stops using the non-WOT cold-load path.
- `Timer_OpenLoopFraction` suppresses adaptive-memory application even when the engine is not at full throttle. That matches the open-loop behavior described elsewhere in the wiki.

The comments in the ASM describe the cold-enrichment formula, but the full routine shows a wider modifier chain than the comment header alone. The charge-temp, off-throttle, decel-leanout, adaptive, O2-ramp, and PEFTBL stages all live in this same `_MM` routine.

### Part-Throttle Transient Fuel Internals

`CalculatePartThrottleTransientFuel_MM` (`T-SMEC_v19.asm` lines 6330 through 6500) calculates two outputs that are consumed later by the running-fuel path:

- `Pulsewidth_PartThrottleEnrichment_HB`, a word-sized additive transient-fuel amount
- the decel and time-constant state bytes that `CalculateSumOfAllFuelModifiers_MM` uses on later passes

The routine starts by clearing `Temp2` and `Temp3`, then decrementing `Timer_O2InhibitSwitchingRichIdleToClosedLoop` when that inhibit timer is active. From there it splits into MAP-based transient handling first, then TPS-based transient handling.

#### `TransFuel_*` helper family

The helper labels from lines 6354 through 6446 show that the firmware treats positive transients and negative transients as separate state machines rather than one blended formula.

**MAP increase path**

- `TransFuel_CalculateIncreasingMAPTransientFuel` subtracts `MAPTRG_DeltaMapTriggerLevel` from `MapValue - AverageMAPValue`.
- If the delta is above threshold, it is capped by `MAPMAX_MaxDeltaMapAllowed`.
- `AESLOP_DeltaMAPEnrichmentPT` is looked up from `CoolantTemp`.
- The capped delta is multiplied by that slope and stored in `Temp2` as the MAP-based additive transient-fuel word.

**MAP decrease path**

- `TransFuel_CalculateDecreasingMAPTransientFuel` loads `LMAPTC_TimeConstant` into `Factor_LeanoutOrEnrichTime_MAP`.
- It only builds decel MAP leanout when several gates are satisfied: not full throttle, above `LOTRPM_MinRpmForMapLeanout`, ATX-in-gear checks when configured, engine-running time nonzero, and vehicle speed at or above `0x0080`.
- The negative MAP delta is compared against `DECTRG_DeltaMapTriggerForNoIncrementalLeanout` and `DTRG2_DeltaMapTriggerForMaxLeanout`.
- Small qualifying drops increment `Factor_DecelLeanoutWhenMAPDecreasing`. Large drops load a full factor from `DECEL_DecelLeanoutFactorMAP` and also seed `Timer_O2InhibitSwitchingRichIdleToClosedLoop` from `DCELTM_O2CNTRInhibitAfterLeanoutDone`.
- Every eighth main-loop pass, the routine refreshes the MAP block data by calling `ProcessMapOrTpsBlockData` on `Block_MAP`.

**TPS increase path**

- If `TpsVolts - AverageTPSVolts` is positive, the routine loads `THRTCN_EnrichmentTime_FromTemp` into `Factor_LeanoutOrEnrichTime_TPS` and clears `Factor_DecelLeanoutWhenThrottleDecreasing`.
- `POSTRG_PositiveTransientTriggerLevel` is subtracted from the TPS delta, then the result is capped by `THRMAX_MaxDeltaTHR`.
- `POSSLP_DeltaTPSEnrichment_FromTemp` is looked up from `CoolantTemp`.
- The product is added into `Temp2`, so TPS enrichment stacks on top of any MAP enrichment already built on this pass.

**TPS decrease path**

- `TransFuel_CalculateDecreasingTPSTransientFuel` loads `LOTIME_DecelLeanoutTimeConstant_FromTemp` into `Factor_LeanoutOrEnrichTime_TPS`.
- It then requires nonzero engine-running time and vehicle speed at or above `0x0080` before any throttle-based leanout is allowed.
- The negative TPS delta uses hysteresis through `LOTHYS_LeanoutDeltaThrottleHysteresis`, then compares against `LOTTRG_DeltaTriggerForDecelLeanout` and `LOTRG2_SecondDecelLeanoutTrigger`.
- Smaller qualifying drops increment `Factor_DecelLeanoutWhenThrottleDecreasing`. Larger drops load the full factor from `LOTTHR_DecelLeanoutFactor_FromTemp`.
- As with the MAP path, every eighth main-loop pass the routine refreshes block data, here through `Block_TPS`.

After both transient families run, the routine chooses which additive word to publish:

- Normally it stores `Temp2` into `Pulsewidth_PartThrottleEnrichment_HB`.
- If the engine is not off-idle, OC1 toggle is active, AIS is opening, and the AIS delta exceeds `POSTIG_MinAisPulseRequireToTriggerEnrichment`, it overrides the normal transient value with the fixed `POSFUL_AisEnrichmentFuelPulse` word.

That last branch is easy to miss in high-level summaries. The additive part-throttle transient pulse is usually the sum of MAP and TPS enrichment, but under the coded AIS condition it becomes a fixed idle-air-step enrichment pulse instead.

### Interrupt-Path Running Fuel Note

`CalculateInjectorPulsewidthForEngineRunning` (`T-SMEC_v19.asm` lines 6773 through 6845) and `HandleFuelStartRunStartTransfer` (`T-SMEC_v19.asm` lines 6906 and onward) are distributor-interrupt routines, not `_MM` foreground routines. They are the point where base table selection, `SumOfFuelModifiers_HB`, `Pulsewidth_PartThrottleEnrichment_HB`, `SparkScatterFuelStabilizationValue_HB`, and the start-to-run decay state are combined into the final running injector pulsewidth.

This page only cross-references them so the main-loop-owned helper routines have a home. Detailed interrupt-path coverage belongs to Task 10 and the [interrupt-handler documentation](../ecu-fundamentals/interrupt-handlers.md), where the running-fuel assembly and start/run transfer logic can be documented in one place.

---

## See Also

- [Fuel System Flow](../reference/fuel-system-flow.md) - Complete fuel calculation flow diagrams with Mermaid charts
- [Table Reference](../reference/table-reference.md) - Complete reference for all calibration tables
- [Idle and AIS Control](idle-control.md) - Idle-error fuel stabilization and special-idle enrichment that feed the running fuel path
- [Sensor Processing and Derived State](../ecu-fundamentals/sensor-processing.md) - TPS, MAP, temperature, and limp-in state used by the transient and modifier routines
- [Ignition Timing](ignition-timing.md) - Spark timing calculations
- [Adaptive Systems](adaptive-systems.md) - O2 feedback and adaptive memory details
