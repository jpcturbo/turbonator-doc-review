# Comprehensive Table Reference

**Calibration**: T-SMEC_22_MTX_S-II (Turbo II Manual Transmission)
**Total Tables**: 521
**Last Updated**: 2025-01-13

---

## Quick Reference by System

| System | Tables | Section |
|--------|--------|---------|
| Fuel System | 100+ | [Fuel Tables](#1-fuel-system) |
| Spark/Ignition | 40+ | [Spark Tables](#2-sparkignition-system) |
| Boost Control | 50+ | [Boost Tables](#3-boost-control-system) |
| Idle Control (AIS) | 60+ | [Idle Tables](#4-idle-control-system) |
| O2 Closed-Loop | 25+ | [O2 Tables](#5-o2-closed-loop-control) |
| Adaptive Memory | 20+ | [Adaptive Tables](#6-adaptive-memory-autocal) |
| Limiters & Safety | 30+ | [Limiter Tables](#7-limiters-and-safety) |
| Diagnostics | 40+ | [Diagnostic Tables](#8-diagnostics-and-limp-in) |
| Support/Other | 150+ | [Support Tables](#9-support-systems) |

---

## Legend

| Field | Description |
|-------|-------------|
| **Address** | ROM address offset from 0x8000 (hex) |
| **Type** | MPTune table type (0-15, 11, 16) |
| **X Axis** | Horizontal input (e.g., MAP, RPM, Temp) |
| **Y Axis** | Vertical output (e.g., Pulsewidth, Degrees, Factor) |
| **Feeds** | What this table outputs to |
| **Modified By** | What tables modify this table's output |

---

## 1. FUEL SYSTEM

### 1.1 Primary Fuel Tables

#### WOTTBL_FuelFullThrottle (0x07DD)
- **Type**: 1 (FUEL Curve)
- **X Axis**: MAP (-14.7 to 14.7 psi)
- **Y Axis**: Pulsewidth (0 to 65535 µSec)
- **Description**: Base fuel at full throttle, also acts as maximum for part throttle
- **Feeds**: Final fuel pulsewidth calculation
- **Modified By**:
  - `BATOFF_FuelBatteryOffset` (battery voltage compensation)
  - `CURVEA/B/C` (cold enrichment curves)
  - `FCRCVB_FuelWOTScaleEnrichBFromRpm` (WOT enrichment factor)
  - `PWADD_FuelPWModifierFromBaro` (barometric compensation)
  - `DECEL_DecelLeanoutFactorMAP_FromTemp` (decel leanout)
  - `POSSLP_DeltaTPSEnrichment_FromTemp` (TPS pumpshot)
  - `AESLOP_DeltaMAPEnrichmentPT` (MAP pumpshot)
  - `PEFTBL_PumpingEfficiency` (volumetric efficiency)
  - `PRIRMP_PrimaryRamp` / `SECRMP_SecondaryRamp` (O2 feedback)
  - AutoCal cells (adaptive memory)

---

### 1.2 Fuel Modifiers

#### BATOFF_FuelBatteryOffset (0x07F2)
- **Type**: 0 (Curve unsigned)
- **X Axis**: Battery Voltage (0 to 16.2V)
- **Y Axis**: Pulsewidth (0 to 4095.94 µSec)
- **Description**: Injector opening time compensation for voltage
- **Feeds**: All fuel calculations (additive)

#### PWADD_FuelPWModifierFromBaro (0x095B)
- **Type**: 0 (Curve unsigned)
- **X Axis**: Baro (-14.7 to 14.7 psi)
- **Y Axis**: Pulsewidth (0 to 12288 µSec)
- **Description**: Altitude fuel compensation (additive)

#### PEFTBL_PumpingEfficiency (0x0931)
- **Type**: 0 (Curve unsigned)
- **X Axis**: RPM (0 to 8160 rpm)
- **Y Axis**: PumpEff (0 to 99.6%)
- **Description**: Volumetric efficiency curve
- **Feeds**: Fuel calculation (multiplicative)
- **Formula**: `FinalFuel = BaseFuel × (PumpEff% / 100)`

#### AIRTMP_FuelEnrichmentFromChargeTemp (0x0949)
- **Type**: 0 (Curve unsigned)
- **X Axis**: Charge Temp (0 to 5 volts)
- **Y Axis**: Factor (1 to 1.996)
- **Description**: Intake air temperature enrichment

---

### 1.3 Cold Enrichment System

**Formula**: `1 + (((CURVEA×ADVDCY + CURVEC×ADVDCY + CURVEB×FCRCVB)/256)/32) × BAROCP/256`

#### CURVEA_FuelColdEnrichmentCurveA (0x0810)
- **Type**: 0 (Curve unsigned)
- **X Axis**: Temp (-200 to 260 degrees)
- **Y Axis**: Factor (1 to 1.996)
- **Description**: Primary cold enrichment curve
- **Weighted By**: ADVDCY (AIS duty cycle)
- **Modified By**: BAROCP (barometric compensation)

#### CURVEB_FuelColdEnrichmentCurveB (0x0823)
- **Type**: 0 (Curve unsigned)
- **X Axis**: Temp (-200 to 260 degrees)
- **Y Axis**: Factor (0 to 1.992)
- **Description**: Secondary cold enrichment curve
- **Weighted By**: FCRCVB (RPM-based factor)
- **Modified By**: BAROCP (barometric compensation)
- **Note**: Does NOT phase out - used for WOT

#### CURVEC_FuelColdEnrichmentCurveC (0x0838)
- **Type**: 0 (Curve unsigned)
- **X Axis**: Temp (-200 to 260 degrees)
- **Y Axis**: Factor (1 to 2.992)
- **Description**: Tertiary cold enrichment curve
- **Weighted By**: ADVDCY (AIS duty cycle)
- **Modified By**: BAROCP (barometric compensation)

#### FCRCVB_FuelWOTScaleEnrichBFromRpm (0x084B)
- **Type**: 0 (Curve unsigned)
- **X Axis**: RPM (0 to 8160 rpm)
- **Y Axis**: Factor (0 to 0.996)
- **Description**: RPM multiplier for CURVEB (WOT only)

#### BAROCP_BaroCompensationOfWarmupFactor_FromBaro (0x0905)
- **Type**: 0 (Curve unsigned)
- **X Axis**: Baro (-14.7 to 14.7 psi)
- **Y Axis**: Factor (0 to 99.6%)
- **Description**: Altitude compensation for cold enrichment

---

### 1.4 Starting Fuel

**Formula**: `[STRTFL² × (1-STFBAR-STFTMP) × EPPMUL + BATOFF×4] × 4`

#### STRTFL_StartFuel_FromTemp (0x072E)
- **Type**: 0 (Curve unsigned, sqrt scale)
- **X Axis**: Temp (-200 to 260 degrees)
- **Y Axis**: sqrtPW (0 to 222 µSec)
- **Description**: Base cranking fuel
- **Modified By**: STFBAR, STFTMP, EPPMUL, BATOFF

#### STRLMT_ColdestTempAllowedAtClosedThrottle (0x0745)
- **Type**: 4 (Word Constant)
- **Description**: Minimum temperature limiter for STRTFL

#### EPPMUL_FuelStartFuelPerEPP (0x0752)
- **Type**: 0 (Curve unsigned)
- **X Axis**: EPPs (0 to 255 count)
- **Y Axis**: Factor (0 to 0.996)
- **Description**: Fuel reduction per engine revolution during cranking

#### STFTMP_FuelStartFuelFromCoolant (0x0761)
- **Type**: 0 (Curve unsigned, inverse scale)
- **X Axis**: Temp (-200 to 260 degrees)
- **Y Axis**: Inverse (0 to 0.996 factor)
- **Description**: Coolant-based starting fuel modifier

---

### 1.5 Transient Enrichment (Pumpshot)

#### TPS-Based Pumpshot

| Table | Address | Type | X Axis | Y Axis | Description |
|-------|---------|------|--------|--------|-------------|
| POSTRG_PositiveTransientTriggerLevel | 0x096B | 4 | - | - | TPS delta threshold to trigger enrichment |
| THRMAX_MaxDeltaTHR | 0x0978 | 4 | - | - | Maximum delta TPS allowed |
| POSSLP_DeltaTPSEnrichment_FromTemp | 0x0985 | 0 | Temp | pw (0-60 ms/volt) | TPS pumpshot enrichment amount |
| THRTCN_EnrichmentTime_FromTemp_TPS | 0x0AA3 | 0 | Temp | Factor (0-0.996) | TPS pumpshot decay time constant |

**Flow**: `ΔTPS > POSTRG → POSSLP[CTS] → Decays via THRTCN`

#### MAP-Based Pumpshot

| Table | Address | Type | X Axis | Y Axis | Description |
|-------|---------|------|--------|--------|-------------|
| MAPTRG_DeltaMapTriggerLevel | 0x0996 | 4 | - | - | MAP delta threshold to trigger |
| MAPMAX_MaxDeltaMapAllowed | 0x09A4 | 4 | - | - | Maximum delta MAP allowed |
| AESLOP_DeltaMAPEnrichmentPT | 0x09B2 | 0 | Temp | pwEnrich (0-255 uS/torr) | MAP pumpshot enrichment |
| AETIME_EnrichmentTime_FromTemp_MAP | 0x0A95 | 0 | Temp | Factor (0-0.996) | MAP pumpshot decay constant |

**Flow**: `ΔMAP > MAPTRG → AESLOP[CTS] → Decays via AETIME`

---

### 1.6 Decel Leanout

#### TPS-Based Decel Leanout

| Table | Address | Description |
|-------|---------|-------------|
| LOTTHR_DecelLeanoutFactor_FromTemp | 0x09D2 | TPS-based leanout factor (Y=0 means factor=1.00) |
| LOTTRG_DeltaTriggerForDecelLeanout | 0x09E3 | Main trigger level (delta TPS) |
| LOTRG2_SecondDecelLeanoutTrigger | 0x09F0 | Secondary trigger level |
| LOTHYS_LeanoutDeltaThrottleHysteresis | 0x09FD | Hysteresis around trigger levels |
| LOTIME_DecelLeanoutTimeConstant_FromTemp | 0x0AB2 | Leanout time constant |

#### MAP-Based Decel Leanout

| Table | Address | Description |
|-------|---------|-------------|
| DECEL_DecelLeanoutFactorMAP_FromTemp | 0x0A0A | MAP-based leanout factor |
| DECTRG_DeltaMapTriggerForNoIncrementalLeanout | 0x0A19 | MAP threshold for no leanout |
| DTRG2_DeltaMapTriggerForMaxLeanout | 0x0A27 | MAP threshold for max leanout |
| DECHYS_DeltaMapHysteresisonTriggerLevels | 0x0A35 | Hysteresis for triggers |
| LOTRPM_MinRpmForMapLeanout | 0x0A50 | No MAP leanout below this RPM |
| LMAPTC_TimeConstant | 0x0A86 | MAP leanout time constant |
| DCELTM_O2CNTRInhibitAfterLeanoutDone | 0x0A5D | O2 inhibit time after leanout |

---

### 1.7 Part Throttle Enrichment

| Table | Address | Type | Description |
|-------|---------|------|-------------|
| PTEADJ_EnrichAdjust_FromMap | 0x0AE7 | 0 | MAP-based multiplier (zero=1.00) |
| PTELMT_MultiplierMaxLimitFromRpm | 0x0AD4 | 0 | Maximum PTE multiplier limit |
| RPMMAP_SwitchPointForDownUp_FromRpm | 0x0AC1 | 0 | EPP control toggle point |
| PTENR_EppPerAmountForIncreasing | 0x0AFB | 4 | EPPs per amount for increasing |
| PTENR2_EppPerAmountForDecreasingMultiplier | 0x0B08 | 4 | EPPs per amount for decreasing |
| PTENRD_AmountForDecreasingMultiplier_Negative | 0x0B15 | 4 | Negative amount for decreasing |
| PTENUM_NumberToReturnToHOTMAP | 0x0B22 | 4 | Number below PTELMT to return to normal spark |

---

### 1.8 O2 Closed-Loop Control

#### O2 Thresholds (Volts)

| Table | Address | Description |
|-------|---------|-------------|
| O2HIGH_HighLimitForImmediateSwitchToClosedLoop | 0x0D76 | High threshold (0x26 = 0.73V) |
| O2TLMH_HighLimitForDelayedSwitchToClosedLoop | 0x0D83 | High threshold for delayed switch |
| O2MIDH_HighLimitForInMiddleDetermination | 0x0D90 | High threshold for "middle" |
| O2HSWP_HighLimitForO2RampSwitching | 0x0D9D | High limit for ramp switching |
| O2LSWP_LowLimitForO2RampSwitching | 0x0DAA | Low limit for ramp switching |
| O2MIDL_LowLimitForInMiddleDetermination | 0x0DB7 | Low threshold for "middle" |
| O2TLML_LowLimitForDelayedSwitchToClosedLoop | 0x0DC4 | Low threshold for delayed switch |
| O2LOW_LowLimitForImmediateSwitchToClosedLoop | 0x0DD1 | Low threshold for immediate switch |

#### O2 Timing

| Table | Address | Description |
|-------|---------|-------------|
| O2TIME_DelayTimeToClosedLoop | 0x0DDE | Delay time when going closed loop (1=2.8sec) |
| O2ITIM_TimeO2InhibitedSwitchingRichIdleToClosedLoop | 0x0B3C | O2 inhibit time from rich idle |
| LTHTIM_IfNoO2SwitchForThisTimeThrowFault51or52 | 0x0DEB | Time limit before fault code |

#### O2 Range of Authority

| Table | Address | Description |
|-------|---------|-------------|
| O2LIMH_O2RangeLimitHigh | 0x0D5C | Max multiplier = 1 + O2LIMH/512 (max 0x7F) |
| O2LIML_O2RangeLimitLow | 0x0D69 | Min multiplier = 0.5 + O2LIML/512 (min 0x80) |

#### O2 Ramps (Type 11 - Special Structure)

| Table | Address | Description |
|-------|---------|-------------|
| PRIRMP_PrimaryRamp | 0x0D29 | Primary O2 ramp - 9 cells + idle |
| SECRMP_SecondaryRamp | 0x0DF8 | Secondary O2 ramp - 9 cells + idle (lean values in 2's complement) |

**Type 11 Structure**:
```
- RPM Low/High Boundary (word)
- MAP Low/High Boundary (word)
- Cell 0-8 Ramp Rich/Lean (9 words)
- Idle Cell Ramp Rich/Lean (1 word)
- Cell 0-8 Limits/Rates Rich/Lean (9 words)
- Idle Limit/Rate Rich/Lean (1 word)
```

---

### 1.9 Adaptive Memory (AutoCal)

#### Cell Boundaries

| Table | Address | Description |
|-------|---------|-------------|
| MP1_AutoCalMapCellBoundary1 | 0x0BD1 | MAP cell boundary 1 (0x28) |
| MP2_AutoCalMapCellBoundary2 | 0x0BDE | MAP cell boundary 2 (0x37) |
| MP3_AutoCalMapCellBoundary3 | 0x0BEB | MAP cell boundary 3 (0x4B) |
| MP4_AutoCalMapCellBoundary4 | 0x0BF8 | MAP cell boundary 4 (0x61) |
| MP5_AutoCalMapCellBoundary5 | 0x0C05 | MAP cell boundary 5 (0x78) |
| DLTMAP_MapHysteresisAtMapCellBoundaries | 0x0C17 | MAP hysteresis at boundaries |
| R1_RPMCellBoundaryInRPMover32 | 0x0C25 | RPM cell boundary (RPM/32) |
| DLTRPM_DeltaRPMAtRPMBoundariesInRPMOver32 | 0x0C32 | Delta RPM at boundaries |
| IDLOFS_DeltaForIdleRPMForClosedThrottleCell | 0x0C3F | RPM delta for idle (cell 12) |
| HYTRPM_HysteresisFor_IDLOFS | 0x0C4C | Hysteresis for IDLOFS |

#### Update Parameters

| Table | Address | Description |
|-------|---------|-------------|
| CELCHG_BitsChangePerUpdateWithinACell | 0x0C59 | Bits changed per update within cell |
| AMUPDT_EPPsBetweenCalChangeUpdateOpenThrottle | 0x0C66 | EPPs between updates (open throttle) |
| AMUPDI_EPPsBetweenCalChangeUpdateClosedThrottle | 0x0C73 | EPPs between updates (closed throttle) |
| CALTHR_O2ControllerDeadbandLimitForUpdatingCells | 0x0C80 | O2 deadband for cell updates |

#### Update Limits

| Table | Address | Description |
|-------|---------|-------------|
| MAPLIM_NoCellUpdateAboveThisMAP | 0x0C8D | No cell updates above this MAP |
| MAPDEC_NoCellUpdateAndO2CNTRHeldBelowThisMap | 0x0C9B | No updates/O2 held below this (0xFF=disable O2) |
| RPMLIM_NoCellUpdateAboveThisRPMInRPMOver32 | 0x0CA9 | No cell updates above this RPM |
| PWMIN_NoCellUpdateBelow_PWMIN_Pulsewidth | 0x0CD1 | No updates below this PW (value × 4 µSec) |

#### Adaptive Memory Range of Authority

| Table | Address | Description |
|-------|---------|-------------|
| AMLIMH_MaxMultiplierCannotBeAbove7F | 0x0CB6 | Max = 1 + AMLIMH/512 (≤0x7F) |
| AMLIML_MinMultiplierCannotBeBelow80 | 0x0CC3 | Min = 0.5 + AMLIML/512 (≥0x80) |

#### Adaptive Memory Timer

| Table | Address | Description |
|-------|---------|-------------|
| AMTEMP_StartTempToSelectHotOrColdAMTimer | 0x0B8A | Temp to select hot/cold timer |
| AMTPSW_TempPointToEnableSelectedAMTimer | 0x0B97 | AM inhibit time from coolant temp |
| CLTIME_ClosedLoopTimeFromEngTempAtStartup_FromTemp | 0x0BA6 | Closed loop time from startup temp |
| CLTEMP_TempToStartCLTIMETimer | 0x0BB4 | Temp to start CLTIME timer (0x94=70°F) |

---

## 2. SPARK/IGNITION SYSTEM

### 2.1 Spark Advance Tables

| Table | Address | Type | X Axis | Y Axis | Description |
|-------|---------|------|--------|--------|-------------|
| CLDMAP_AdvanceFromMAPCold | 0x03D3 | 2 (signed curve) | MAP (-14.7 to 14.7 psi) | Advance (-64 to 63.5°) | Cold engine MAP-based advance |
| HOTMAP_AdvanceFromMAPWarmPart | 0x03F2 | 2 (signed curve) | MAP (-14.7 to 14.7 psi) | Advance (-64 to 63.5°) | Warm part-throttle MAP advance |
| WOTMAP_AdvanceFromMAPWarmFull | 0x044C (data at 0x1105) | 2 (signed curve) | MAP (-14.7 to 14.7 psi) | Advance (-15 to 15°) | Warm WOT MAP advance |
| TMPSWP_EngTempSwitchPointForSparkAdvance | 0x0406 | 4 | - | - | Temp switch between cold/hot |
| CLDLMT_LimitForColdMapAtClosedThrottle | 0x03E5 | 4 | - | - | Coldest input for CLDMAP |
| ADVCLS_AdvanceAddedForClosedLoopFromTimer | 0x0413 | 2 (signed curve) | Timer (0-255 F) | Advance (-64 to 63.5°) | Closed throttle timer advance |

---

### 2.2 Calculated Spark Tables (Type 16 - 3D)

| Table | Address | Type | X Axis | Y Axis | Description |
|-------|---------|------|--------|--------|-------------|
| PTTIME_PartThrottleTotalTiming | 0x0421 | 16 (3D calculated) | GOVNER (0-8160 rpm) | HOTMAP (-15 to 15°) | Part throttle total timing |
| FTTIME_FullThrottleTotalTiming | 0x0436 | 16 (3D calculated) | GOVNER (0-8160 rpm) | WOTMAP (-15 to 15°) | Full throttle total timing |
| RPMLMT_AdvanceMinFromRpm | 0x045F | 2 (signed curve) | RPM (0-8160 rpm) | Advance (-64 to 63.5°) | Minimum limit (3d mintable) |
| SPKLMT_AdvanceFromRpmMAX | 0x04B0 | 2 (signed curve) | RPM (0-8160 rpm) | Advance (-64 to 63.5°) | Maximum limit (3d maxtable) |

**Type 16 Sources**:
- `GOVNER` (RPM axis table)
- `HOTMAP` or `WOTMAP` (MAP axis table)
- `MAPMUL` (MAP multiplier)
- `RPMLMT` (minimum table)
- `SPKLMT` (maximum table)

---

### 2.3 Knock Retard System

#### Knock Detection Parameters

| Table | Address | Description |
|-------|---------|-------------|
| KNKRPM_MinRpmforKnockRetard | 0x04D0 | Minimum RPM for knock retard |
| KNKOFS_DeltaAboveBaroFor_RTRDRT_and_KNKCNT | 0x04DD | Delta above baro for rates/counters |
| THRKNK_DeltaAbove_MINTHR | 0x052F | Delta above MINTHR for knock detect |
| KLMRPM_MinKnockDetectRpm | 0x053C | RPM range for knock detection |

#### Knock Retard Rates

| Table | Address | Description |
|-------|---------|-------------|
| RTRDRT_KnockRetardRateNoBoost | 0x04EB | Retard rate, no boost (half degrees) |
| RTRDRT2_KnockRetardRateInBoost | 0x04F8 | Retard rate, in boost (half degrees) |
| INCSRT_KnockRetardIncreaseRate | 0x0505 | Recovery rate (must use: 0,1,3,7,0x0F,0x1F,0x3F,0x7F,0xFF) |

**Recovery Rate Formula**: `Rate = 1/2° every (INCSRT+1) × 11ms`

#### Knock Limits

| Table | Address | Type | Description |
|-------|---------|------|-------------|
| RETMAX_MaxKnockRetardFromMap | 0x0512 | 2 (signed curve) | MAP-based maximum retard |
| KNKLIM_MaxKnockRetard | 0x0522 | 4 | Knock limit in half degrees |

#### Knock Sensor Threshold

| Table | Address | Type | Description |
|-------|---------|------|-------------|
| DLTKNK_KnockSensorVoltageForKnock_FromRpm | 0x0549 | 0 (unsigned curve) | RPM-based voltage threshold |

---

### 2.4 Adaptive Retard

| Table | Address | Type | X Axis | Y Axis | Description |
|-------|---------|------|--------|--------|-------------|
| ARRPM_AdaptiveRetardFromRPM | 0x055B | 2 (signed curve) | RPM (0-8160) | Retard (0-127.5°) | RPM-based adaptive |
| ARMAP_AdaptiveRetardFromMAP | 0x056D | 2 (signed curve) | MAP (-14.7 to 14.7) | Retard (0-127.5°) | MAP-based adaptive |

**Note**: Modified by factor at RAM 0x002B (0, 1/4, 1/2, 3/4, or 1)

---

### 2.5 Spark Scatter Control

| Table | Address | Description |
|-------|---------|-------------|
| SSTEMP_TempAboveWhichSparkScatterIsActive | 0x0656 | Temperature above which scatter is active |
| FTUNPW_FineTuneStepForAis | 0x0663 | Fine tune step for AIS during scatter |
| SSITIM_ScatterInhibitTime | 0x0670 | Scatter inhibit time (11ms per bit) |
| SSIPRD_ScatterInhibitBelowThisSpeed | 0x067D | Scatter inhibited below this speed |
| SPKADD_SparkAdvanceAddedWhenRpmBelowControl_FromDeltaRpm | 0x068A | 2 (signed curve) | Advance to increase engine speed |
| SPKRET_SparkAdvanceRetardedWhenRpmAboveControl_FromDeltaRpm | 0x0699 | 2 (signed curve) | Advance to decrease engine speed |
| IDLADD_FuelStabilization_FromDeltaRPM | 0x06A8 | 0 (unsigned curve) | Fuel for speed stabilization |
| IDLTMP_Use_IDLADD_AboveThisTemp | 0x06B9 | IDLADD enabled when temp above this |

---

### 2.6 Start-to-Run Transfer (Spark)

| Table | Address | Description |
|-------|---------|-------------|
| STRNTR_SparkStartRunTransferPointRpm | 0x06C6 | Start-to-Run transfer (≈30,000/count RPM) |
| RNSTTR_SparkRunStartTransferPointRpm | 0x06D3 | Run-to-Start transfer (≈30,000/count RPM) |
| SKAPRD_SparkImmediateSwitchToRunAboveThisRpm | 0x06E0 | Immediate switch to RUN above this RPM |
| SRTIME_SparkEPPsNeededToBeAboveSR_Hot | 0x0707 | Consecutive EPPs above SR when hot |
| SRTIME2_SparkEPPsNeededToBeAboveSR_Cold | 0x0714 | Consecutive EPPs above SR when cold |
| SRTMTP_SparkTempSwitchPointFor_SRTIME | 0x0721 | Engine temp switch for SRTIME |

---

## 3. BOOST CONTROL SYSTEM (T2 TURBO)

### 3.1 Wastegate Duty Cycle - Lookup

| Table | Address | Type | X Axis | Y Axis | Description |
|-------|---------|------|--------|--------|-------------|
| T2DCWOT_FullThrottleWastegateDutyCycle_C8is100Percent_FromMap | 0x1464 | 0 (unsigned curve) | TargetBoost (0-29.4 psi) | DC (0-127.5%) | Base WOT WG DC (0xC8=100%) |
| T2DCWADJ_FullThrottleWastegateDutyCycleAdjustment_FromRpm | 0x1476 | 2 (signed curve) | RPM (0-8160 rpm) | DC_Adjust (-64 to 63.5%) | RPM-based WG DC adjustment |
| T2DCWBST_FullThrottleWastegateDutyCycleAdjustment_FromBoostTarget | 0x1488 | 0 (unsigned curve) | DeltaMAP (0-29.4 psi) | DC_Adjust (0-127.5%) | WG DC vs delta to target |

---

### 3.2 Wastegate Duty Cycle - Adaptives

#### Adaptive Update Parameters

| Table | Address | Description |
|-------|---------|-------------|
| INCPT_AdaptiveIncAfterThisTime | 0x1386 | Time before WGDC incremented (boost below target) |
| INCLIM_UpperLimitOnWastegateDutyCycleCorrection | 0x1393 | Upper limit on WGDC correction |
| TPSLIM_UpdateAdaptiveWGTPSUpperLimit | 0x13AD | TPS upper limit for adaptive updates |

#### RPM Boundaries

| Table | Address | Description |
|-------|---------|-------------|
| DCRPML_NoWastegateDutyCycleCorrectionBelowThisRpm | 0x13A0 | No WGDC correction below this RPM |
| DCRPM1_WastegateDutyCycleRpmBoundary1 | 0x13C8 | RPM boundary 1 |
| DCRPM2_WastegateDutyCycleRpmBoundary2 | 0x13D5 | RPM boundary 2 |
| DCRPM3_WastegateDutyCycleRpmBoundary3 | 0x13E2 | RPM boundary 3 |
| DCRPMH_NoWastegateDutyCycleCorrectionAboveThisRpm | 0x1522 | No WGDC correction above this RPM |

#### MAP Switch Points

| Table | Address | Description |
|-------|---------|-------------|
| MAPPT_WastegateDutyCycleMapSwitchPoint | 0x13BA | WG DC boost switch point (T1) |
| T2MAPPT_WastegateDutyCycleMapSwitchPoint | 0x13EE | WG DC boost switch point (T2) |
| T2MAPPT2_WastegateDutyCycleMapSwitchPoint2 | 0x13FB | WG DC switch point 2 (T2) |

---

### 3.3 Wastegate Duty Cycle - Knock Adjustment

| Table | Address | Description |
|-------|---------|-------------|
| T2KNOKMP_MinimumBoostToCountKnockEvents | 0x1408 | Minimum boost to count knock |
| T2WGKNRD_MinimumKnockToReduceWGDC | 0x1415 | Minimum knock retard to reduce WGDC |
| T2KDCINC_WastegateDutyCycleIncreaseStepWhenKnocking | 0x149B | WGDC increase step when knocking |
| T2KDCMAX_WastegateDutyCycleIncreaseMaxWhenKnocking | 0x14A7 | Maximum WGDC increase when knocking |
| T2KDCMIN_WastegateDutyCycleIncreaseMinWhenKnocking | 0x14B3 | Minimum WGDC increase when knocking |
| T2DECTIM_TimeScaleFor_DCDECK | 0x14BF | Time scale for DCDECK |
| T2DCDECK_WastegateDutyCycleDecrementWhenSparkStillDerated | 0x14CB | WGDC decrement when spark derated |

---

### 3.4 Wastegate Duty Cycle - Boost Creep Prevention

| Table | Address | Type | Description |
|-------|---------|------|-------------|
| T2RPMBST_MinimumRpmToTrackBoostCreep | 0x1421 | 4 | Minimum RPM to track boost creep |
| T2RATLIM_OverboostPreventionRateLimit_FromRpm | 0x142D | 0 (unsigned curve) | Delta boost from RPM (rate limit) |
| T2PRTMAX_MaxWastegateDutyCycleforPartThrottleBoostCreep | 0x143C | 4 | Maximum WGDC for PT boost creep |
| T2MPDEL_HysteresisForBoostCreep | 0x1448 | 4 | Hysteresis for boost creep |
| T2RESFAC_MapCorrectionResponseFactor_FromMap | 0x1455 | 0 (unsigned curve) | MAP correction response factor |

---

### 3.5 T2 Adaptives

| Table | Address | Description |
|-------|---------|-------------|
| T2MPDEL1_IncCounterWhenDeltaMapBelowThis | 0x14D7 | Increment counter when ΔMAP below threshold |
| T2INCPT_AdaptiveIncAfterThisTime | 0x14E4 | Timer before WGDC incremented (boost below target) |
| UPRLIM_UpperLimitOnMPCORR | 0x14F0 | Upper limit on MPCORR |
| LWRLIM_LowerLimitOnMPCORR | 0x14FC | Lower limit on MPCORR |
| T2MPROOF_StopAdaptiveWhenMapIsThisCloseToBoostTarget | 0x1508 | Stop adaptive when MAP close to target |
| T2MPFLOR_StopAdaptiveWhenMapIsThisCloseToBoostFloor | 0x1515 | Stop adaptive when MAP close to floor |

---

## 4. IDLE CONTROL SYSTEM (AIS)

### 4.1 AIS Position Tables

| Table | Address | Type | X Axis | Y Axis | Description |
|-------|---------|------|--------|--------|-------------|
| AISTRT_AisStartupPosition_FromTemp | 0x0E27 | 0 (unsigned curve) | Temp (-200 to 260°) | AIS_Open (0-255 steps) | Startup position |
| CLDPOS_AisColdPosition_FromTemp | 0x0E8D | 0 (unsigned curve) | Temp (-200 to 260°) | AIS_Open (0-2048 steps) | Cold off-idle positioning |
| RPMPOS_AisPosition_FromRpm | 0x0E9D | 0 (unsigned curve) | RPM (0-8160 rpm) | Output (0-255 scale) | AIS position from RPM |
| THRPOS_AisPosition_FromThrottle | 0x0EAC | 0 (unsigned curve) | TPS (0-5 Volts) | Output (0-255 scale) | AIS position from throttle |
| ACPOS_ACPositionWhenTempToCold | 0x0EBB | 4 | - | - | AC clutch position when cold |
| CALPOS_PositionAisMotorIsAtIdle | 0x0EC8 | 4 | - | - | Position at idle (heartbeat default) |

---

### 4.2 Idle Speed Targets

| Table | Address | Type | Description |
|-------|---------|------|-------------|
| RPMDEF_RPMDefaultForIdleControl | 0x0E38 | 4 | Default RPM for idle control |
| RPMTHS_RPMThresholdForIdleControl | 0x0E45 | 4 | RPM threshold for idle control |
| AISPN_IdleSpeedParkNeutral_FromTemp | 0x0E6F | 0 (unsigned curve) | Idle speed in park/neutral or manual |
| AISCLD_IdleSpeedDrive_FromTemp | 0x0E7E | 0 (unsigned curve) | Idle speed in drive (auto trans) |
| IDLDEF_TargetIdleSpeed_HBDefault | 0x0B63 | 4 | Target idle speed default |

---

### 4.3 AIS Control Parameters

| Table | Address | Description |
|-------|---------|-------------|
| AISDLY_DelayFromStartRunThatAisFeedbackDisabled | 0x0E62 | Delay from start/run (11ms units) |
| CALRAT_AisAdjustRate | 0x0ED5 | AIS adjustment rate |
| TIMED2_AISDecelBaseAirflowCurveOffset_FromTime2 | 0x0E53 | 0 (unsigned curve) | Decel AIS curve offset from time |

---

### 4.4 Special Setup

| Table | Address | Description |
|-------|---------|-------------|
| RICHSA_OpenLoopEnrichFactorWhenSettingBasicTiming | 0x0B49 | Open loop enrich for timing setting |
| SPKSET_ConstantSparkAdvanceWhenSettingBasicTiming | 0x0B56 | Constant spark (stock=12°) for timing |
| RIDLST_OpenLoopEnrichFactorWhenSettingMinThrottleOpening | 0x0B70 | Open loop enrich for minimum throttle |
| IDLSET_ConstantSparkAdvanceWhenSettingMinThrottleOpening | 0x0B7D | Constant spark for minimum throttle |

---

### 4.5 Decel AIS Control

| Table | Address | Description |
|-------|---------|-------------|
| DCLFQ_TimeBetweenAisPulsesForDecelAis | 0x0F9F | Time between AIS pulses for decel |
| DATHOT_EngineTempToStartCalibratingDacal | 0x0FAC | Temp to start calibrating DACAL |
| DADRPM_DeltaRpmFromIdleSpeedForDacalUpdate | 0x0FB9 | Delta RPM from idle for DACAL |
| DAACF_ACFactorDeltaFromBase | 0x0FC6 | AC factor delta from base |
| DANOM_Base_nominalCal | 0x0FD3 | Base nominal calibration |
| DCALTM_DacalInhibitTimeAfterStartup | 0x0FE0 | DACAL inhibit time after startup |
| DCALRT_DacalUpdateRate | 0x0FED | DACAL update rate (use: 1,3,7,F,1F,3F,7F,FF) |
| DCLMIN_MinLimitOnDecelAisControlledMap | 0x0FFB | Minimum limit on decel AIS MAP |
| DCLMN2_NoAisControlIfMapAndControlMapBelowThis | 0x1008 | No AIS control if MAP below threshold |

#### Decel AIS Delays

| Table | Address | Description |
|-------|---------|-------------|
| DLYTIM_AisDelayAfterThrottleClosesWhenMoving | 0x1016 | AIS delay after throttle closes (moving) |
| DLYTIM2_AisDelayAfterThrottleClosesWhenStopped | 0x1023 | AIS delay after throttle closes (stopped) |
| DLYTM3_AisDelayAfterThrottleClosesWhenRpmAbove_DLYRPM | 0x1030 | AIS delay when MAP below DCLMN2 |
| DLYRPM_RpmTriggerForAisDelay | 0x103D | RPM trigger for third delay |
| MPHREF_SwitchPointForDecelIdleAisControl | 0x104A | Switch between decel/idle (1.5mph hysteresis) |

---

### 4.6 Park/Neutral Kicks

| Table | Address | Type | Description |
|-------|---------|------|-------------|
| PNDLT_DeltaRpmChangeToUse_DRPNK_or_PNDRK_A | 0x1057 | 4 (word) | Delta RPM to use kicks (version A) |
| PNDRK_ParkNeutralToDriveKicks_FromTemp | 0x1064 | 0 (unsigned curve) | P/N to Drive kicks |
| PNDLTP_DeltaRpmChangeToUse_DRPNK_or_PNDRK_B | 0x1078 | 4 (word) | Delta RPM to use kicks (version B) |
| DRPNK_DriveToParkNeutralKicks_FromTemp | 0x1085 | 0 (unsigned curve) | Drive to P/N kicks |

---

### 4.7 AC Compensation

| Table | Address | Type | Description |
|-------|---------|------|-------------|
| ACCTBL_ACOffIdleDelta_FromSpeed | 0x1093 | 0 (unsigned curve) | AC off idle delta from speed |
| ACTMP_Use_ACCTBL_WhenTempAboveThisElseUse_ACPOS | 0x10A4 | 4 | Temp threshold for ACCTBL |
| ACDTMP_PartThrottleAcCutoutDisableTemp | 0x10FF | 4 | PT AC cutout disable temp |
| ACDTHR_PartThrottleAcCutoutDisableThrottle | 0x110C | 4 | PT AC cutout disable throttle |
| ACDSPD_PartThrottleAcCutoutDisableSpeed | 0x1119 | 4 (word) | PT AC cutout disable speed |
| ACETIM_PartThrottleAcCutoutMaxTimeActive | 0x1126 | 4 | PT AC cutout max time |
| ACERPM_AllowAcClutchAboveThisRpm | 0x1133 | 4 | Allow AC clutch above this RPM |
| ACESPD_AllowAcClutchAboveThisSpeed | 0x1140 | 4 (word) | Allow AC clutch above this speed |
| ACAETH_DisallowAcClutchEngageForThisTimeAfterAccelEnrich | 0x114D | 4 | Disallow AC after accel enrich |
| ACOFFK_ClosedThrottleAcOffKick | 0x115A | 4 | Closed throttle AC off kick |
| AC2KCK_AcClutchKickOpenAfterAcEnabled | 0x1167 | 4 | AC clutch kick after enabled |
| ACTIME_TimeBeforeAcEnabledAndFullDeltaUsed | 0x1174 | 4 | Time before full delta used |
| PERKCK_AcClutchAisAdjustmentConstant | 0x1181 | 4 | AC clutch AIS adjustment |
| AC4KCK_AcClutchKickOpenBeforeAcEnabled2 | 0x118E | 4 | AC clutch kick before enabled 2 |

---

### 4.8 Rolling AIS

| Table | Address | Description |
|-------|---------|-------------|
| AISMPH_RollingAisMaxSpeed | 0x10B1 | Rolling AIS max speed |
| RPMDLT_RollingAisMinRpm | 0x10BE | RPM added to target when rolling |
| ISPDCY_RollingAisDecay | 0x10CB | Rolling AIS decay |
| DECAIS_RollingAisUpdateRate | 0x10D8 | Update rate (use: 1,3,7,F,1F,3F,7F,FF) |
| AISLMH_RollingAisHighLimit | 0x10E5 | Rolling AIS high limit |
| AISLML_RollingAisLowLimit | 0x10F2 | Rolling AIS low limit |

---

## 5. LIMITERS AND SAFETY

### 5.1 Rev Limiter

| Table | Address | Description |
|-------|---------|-------------|
| REVLMT_RPMLimiterNormalOnRPM | 0x19A1 | Normal RPM limiter ON |
| REVLMT2_RPMLimiterNormalOffRPM | 0x19AE | Normal RPM limiter OFF |
| REVLMT3_MapAbove75PctAndIdleSwitchClosed2000 | 0x1987 | Fuel cutoff RPM (MAP>75%, idle closed) |
| REVLMT4_MapAbove75PctAndThrLimpin2000 | 0x1994 | Fuel cutoff RPM (MAP>75%, limp-in) |
| REVLMT5_MapLimpinAndThrAbove25PercentLower1850 | 0x196D | Fuel OFF RPM (bad MAP, throttle>25%) |
| REVLMT6_MapLimpinAndThrAbove25PercentUpper2000 | 0x197A | Fuel ON RPM (bad MAP, throttle>25%) |
| THRTHR_25PctThrValueFromShutoff | 0x19BB | 25% throttle value from shutoff |
| RVLSPD_CarSpeedForRevLimitWithTBOff | 0x19C8 | Speed for rev limit (TB off) |

---

### 5.2 Decel Fuel Cutoff

| Table | Address | Description |
|-------|---------|-------------|
| DFRPM1_2050RPM_DecelFuelShutoffTurnonLimit | 0x19D5 | Decel fuel shutoff turn-on limit |
| DFRPM2_2560RPM_DecelFuelShutoffUpperRpmLimit | 0x19E2 | Decel fuel shutoff upper RPM limit |
| DFSMPH_20MPHDecelFuelShutoffSpeedLimit | 0x19EF | Decel fuel shutoff speed limit |
| DFSTMP_60DegCDecelFuelShutoffTempLimit | 0x19FC | Decel fuel shutoff temp limit |
| DFSTMR_3minuteDecelFuelShutoffTimeLimit | 0x1A09 | Decel fuel shutoff time limit |

---

### 5.3 Speed Limiter

| Table | Address | Description |
|-------|---------|-------------|
| SPDLMH_SpeedLimitFuelShutoff254MPH | 0x1A16 | Speed limit fuel shutoff (254 mph) |
| SPDLML_SpeedLimitFuelShutoffRestore253MPH | 0x1A23 | Speed limit fuel shutoff restore (253 mph) |

---

### 5.4 Overspeed Protection

| Table | Address | Description |
|-------|---------|-------------|
| SPDRPM_EngineSpeedHighLimitToEnableOverspeed | 0x1A30 | Engine speed high limit |
| SPDRPM2_EngineSpeedLowLimitToDisableOverspeed | 0x1A3D | Engine speed low limit |

---

### 5.5 Throttle Calibration

| Table | Address | Description |
|-------|---------|-------------|
| MININC_Amount_MINTHR_IsIncreasedAtKeyOnOnly | 0x1A4A | MINTHR increase at key-on only |
| MPTHR_MapSwitchPointForFullThrottleOrIdle | 0x1D24 | MAP switch point for WOT/idle |
| MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected | 0x1A72 | MINTHR value when battery disconnected |
| MAXCNT_ProgramLoopsWithThrottleBelow_MINTHR_ToDecrement | 0x1A7F | Loops below MINTHR to decrement |
| MTHRCL_NumberOfBitsAbove_MINTHR_ToDetermineOnTransition | 0x1A8C | Bits above MINTHR for ON transition |
| MTHROP_NumberOfBitsAbove_MINTHR_ToDetermineOffTransition | 0x1A99 | Bits above MINTHR for OFF transition |

---

## 6. BAROMETRIC READING

| Table | Address | Type | Description |
|-------|---------|------|-------------|
| BRPMLO_BaroReadLowRPM1800 | 0x152F | 4 (word) | Baro read low RPM |
| BRPMHI_BaroReadHighRPM6650 | 0x153C | 4 (word) | Baro read high RPM |
| BRDLAY_BaroReadDelayAfterThrottleClosed2sec | 0x1549 | 4 | Baro read delay after throttle closed |
| BARTIM_BaroReadMinTimeBetweenReadings179sec | 0x1556 | 4 | Min time between baro readings |
| BROPTM_BaroReadDelayAfterSolenoidOpenTenthSec | 0x1563 | 4 | Baro read delay after solenoid open |
| BRCLTM_BaroReadDelayAfterSolenoidClosedTenthSec | 0x1570 | 4 | Baro read delay after solenoid closed |

---

### 6.2 Baro Limits and Defaults

| Table | Address | Description |
|-------|---------|-------------|
| BAROHI_BaroReadValidHighLimit | 0x157D | Baro read valid high limit |
| BAROLO_BaroReadValidLowLimit | 0x158B | Baro read valid low limit |
| BARDFT_BaroReadDefaultValue | 0x1599 | Baro read default value |

---

## 7. FAN CONTROL

| Table | Address | Description |
|-------|---------|-------------|
| FANTMP_FanTurnOnTempAbove45MPH | 0x15AA | Fan turn-on temp above 45 mph |
| FANTMP2_FanTurnOffTempAbove45MPH | 0x15B7 | Fan turn-off temp above 45 mph |
| FANTMP3_FanTurnOnTempBelow35MPH | 0x15C4 | Fan turn-on temp below 35 mph |
| FANTMP4_FanTurnOffTempBelow35MPH | 0x15D1 | Fan turn-off temp below 35 mph |
| FANMAP_FanTurnsOnWhenMapAboveBaroPlusThis | 0x15DE | Fan on when MAP above baro + this |

---

## 8. DIAGNOSTICS AND LIMP-IN

### 8.1 MAP Limp-In

| Table | Address | Type | Description |
|-------|---------|------|-------------|
| LMPINN_LimpinTableForMapFromThrottle | 0x1C25 | 0 (unsigned curve) | Limp-in MAP from throttle |
| MPLMOF_OffsetForCalcMapInMapLimpin | 0x1C38 | 4 | Offset for calculated MAP in limp-in |
| MPLTHR_ThrottleLevelAbove_MINTHR_ToMatureMapLimpin | 0x1D67 | 4 | Throttle level to mature limp-in |
| MPDELT_DeltaMapThatChecksGood | 0x1D74 | 4 | Delta MAP that checks good |
| MPDELA_MatureMapLimpinWhenDeltaAbove | 0x1D81 | 4 | Mature limp-in when delta above |
| MPRPML_DisableMapCheckUnderThisRpm_600 | 0x1D8E | 4 (word) | Disable MAP check below 600 RPM |
| MPRPMH_DisableMapCheckAboveThisRpm_1500 | 0x1D9B | 4 (word) | Disable MAP check above 1500 RPM |
| MPDAGL_DisableMapCheckBelowThisMap | 0x1DA8 | 4 | Disable MAP check below this MAP |

---

### 8.2 Sensor Limits

| Table | Address | Description |
|-------|---------|-------------|
| TMPHIG_OutOfRangeColdTooHighA2D | 0x1C53 | Out of range cold (too high) |
| TMPLOW_OutOfRangeHotTooLowA2D | 0x1C60 | Out of range hot (too low) |
| DEFTMP_DefaultEngineTemp | 0x1C6D | Default engine temp |
| MAPLOW_MapSensorLowerLimit | 0x1D4D | MAP sensor lower limit |
| MAPHIG_MapSensorUpperLimit | 0x1D5A | MAP sensor upper limit |
| THRLOW_ThrottleLowerLimit | 0x1D0A | Throttle lower limit |
| THRHIG_ThrottleUpperLimit | 0x1D17 | Throttle upper limit |
| THROFF_OffsetAddedToCalcThrottle | 0x1C46 | Offset added to calculated throttle |

---

### 8.3 Battery Diagnostics

| Table | Address | Description |
|-------|---------|-------------|
| BTLRPM_LowBatteryVoltageAtThisRpm1500 | 0x1C7A | Low battery voltage at this RPM |
| CTLRPM_LowBatteryVoltageAtThisCoolantTemp | 0x1C87 | Low battery voltage at this coolant temp |
| BTLRPM2_LowBatteryVoltageAtThisRpm1500_2 | 0x1C94 | Low battery voltage at this RPM #2 |
| AMBLOW_BattTempLowWhenHot | 0x1CA1 | Battery temp low when hot |
| AMBHIG_BattTempHighWhenCold | 0x1CAE | Battery temp high when cold |

---

### 8.4 Charge Temp Diagnostics

| Table | Address | Description |
|-------|---------|-------------|
| CHGLOW_ChargeTempOutOfRangeLow | 0x1CBB | Charge temp out of range low |
| CHGHIG_ChargeTempOutOfRangeHigh | 0x1CC8 | Charge temp out of range high |
| DEFCHG_DefaultChargeTemp_Limpin | 0x1CD5 | Default charge temp (limp-in) |

---

### 8.5 Error Code Settings

| Table | Address | Description |
|-------|---------|-------------|
| ERRRPM_RPMLimitforErrorCodeSetting | 0x1CE2 | RPM limit for error code setting |
| ERRMAP_MAPLimitforErrorCodeSetting | 0x1CEF | MAP limit for error code setting |
| ERRTMP_CoolantTempLimitforErrorCodeSetting | 0x1CFD | Coolant temp limit for error code setting |

---

### 8.6 Coil Verification

| Table | Address | Description |
|-------|---------|-------------|
| COILLO_LoLimitBatteryVoltsForCoilVerify | 0x1D32 | Low limit battery volts for coil verify |
| COILHI_HiLimitBatteryVoltsForCoilVerify | 0x1D40 | High limit battery volts for coil verify |

---

## 9. SUPPORT SYSTEMS

### 9.1 MAP Sensor Scaling

| Table | Address | Description |
|-------|---------|-------------|
| MAPMULT_ScaleMAPVoltsToPresMultiplyConst | 0x780D | 0x07 = 2-bar, 0x09 = 3-bar (slope) |
| MAPADD_ScaleMAPVoltsToPresAddConst | 0x7820 | 0x0361 = 2-bar, 0x0700 = 3-bar (offset) |

**Formula**: `PSI = (RAW_MAP × MAPMULT + MAPADD) / 256 - 14.7`

---

### 9.2 RPM Axis Reference

| Table | Address | Description |
|-------|---------|-------------|
| GOVNER_AdvanceFromRPM2 | 0x049F | Primary RPM axis for 3D spark calculations |
| MAPMUL_MultiplierOnMapAdvanceWhenRetarding | 0x046E | MAP multiplier for negative spark advance |

---

## Calculation Flow Summary

### Fuel Calculation Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    FUEL CALCULATION FLOW                        │
└─────────────────────────────────────────────────────────────────┘

1. START FUEL (cranking only)
   STRTFL[temp] × (1-STFBAR-STFTMP) × EPPMUL + BATOFF×4
   └─> Limited by STRLMT

2. RUNNING FUEL (normal operation)
   WOTTBL[MAP]
   └─> BATOFF[battery] (additive)
   └─> PWADD[baro] (additive)
   └─> PEFTBL[RPM] (multiplicative: PW × PumpEff%)
   └─> AIRTMP[charge temp] (multiplicative)
   └─> Cold Enrichment (multiplicative):
       │ 1 + ((CURVEA[temp]×ADVDCY + CURVEC[temp]×ADVDCY + CURVEB[temp]×FCRCVB[RPM])/256/32) × BAROCP[baro]/256
   └─> Decel Leanout (multiplicative factor):
       │ DECEL[temp] or LOTTHR[temp] based on ΔMAP/ΔTPS
   └─> Pumpshot (additive):
       │ POSSLP[temp] × ΔTPS (TPS-based)
       │ AESLOP[temp] × ΔMAP (MAP-based)
       │ POSFUL (AIS-based)
   └─> O2 Feedback (multiplicative):
       │ PRIRMP/SECRMP ramps → O2CNTR controller
   └─> Adaptive Memory (multiplicative):
       │ AutoCal cells based on RPM/MAP boundaries
   └─> Final Pulsewidth
```

### Spark Calculation Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    SPARK CALCULATION FLOW                      │
└─────────────────────────────────────────────────────────────────┘

1. BASE ADVANCE
   IF temp < TMPSWP: CLDMAP[MAP]
   ELSE IF WOT: WOTMAP[MAP]
   ELSE: HOTMAP[MAP]

2. 3D CALCULATION (Type 16)
   GOVNER[RPM] × (HOTMAP[MAP] or WOTMAP[MAP]) × MAPMUL
   └─> PTTIME (part throttle) or FTTIME (full throttle)

3. LIMITS
   PTTIME/FTTIME
   └─> min(RPMLMT[RPM])
   └─> max(SPKLMT[RPM])

4. MODIFIERS
   └─> + ADVCLS[closed loop timer]
   └─> - ARRPM[RPM] × factor (adaptive retard)
   └─> - ARMAP[MAP] × factor (adaptive retard)
   └─> - KnockRetard:
       │ IF knock detected: RETMAX[MAP] limited by KNKLIM
       │ Rate: RTRDRT (no boost) or RTRDRT2 (in boost)
       │ Recovery: INCSRT

5. SCATTER CONTROL (idle stabilization)
   IF temp > SSTEMP:
   └─> IF RPM < target: SPKADD[ΔRPM]
   └─> IF RPM > target: SPKRET[ΔRPM]
   └─> IDLADD[ΔRPM] (fuel adjustment)

6. FINAL TIMING
```

---

## Cross-Reference Index

**By Table Type**:

| Type | Name | Count |
|------|------|-------|
| 0 | Curve (unsigned) | 150+ |
| 1 | FUEL Curve | 15 |
| 2 | Curve (signed) | 40+ |
| 3 | Byte Constant | 80+ |
| 4 | Word Constant | 100+ |
| 5 | Bitfield | 10 |
| 6 | Choice List | 5 |
| 11 | O2 Ramp Structure | 2 |
| 16 | 3D Calculated | 2 |

---

**See Also**:
- [Fuel System Flow](fuel-system-flow.md) - Detailed fuel calculation diagram
- [Spark System Flow](spark-system-flow.md) - Detailed spark calculation diagram
- [Boost System Flow](boost-system-flow.md) - Detailed boost control diagram
- [Glossary](glossary.md) - Term definitions
- [Offset Calculator](offset-calculator.md) - ROM address calculations
