# Spark System Flow

Complete spark/ignition calculation flow for T-SMEC 22 MTX S-II calibration.

---

## Overview

The spark system uses a 3D calculation that combines RPM-based advance with MAP-based advance, then applies limits, knock retard, and adaptive corrections. Unlike fuel, spark is calculated as degrees of advance (not pulsewidth).

**Key Concept**: There is no "base timing" added to calculations. The 12° on emissions stickers is only a synchronization reference - the ECU reports total timing relative to TDC (0°).

---

## High-Level Flow Diagram

```mermaid
flowchart TD
    Start([Spark Calculation]) --> CheckTemp{Engine Temp?}
    CheckTemp -->|Cold| ColdPath[COLD ENGINE<br/>temp < TMPSWP]
    CheckTemp -->|Warm| WarmPath[WARM ENGINE<br/>temp >= TMPSWP]

    ColdPath --> CLDMAP[CLDMAP_AdvanceFromMAPCold<br/>0x03D3]
    WarmPath --> CheckThrottle{Throttle?}

    CheckThrottle -->|WOT| WOTMAP[WOTMAP_AdvanceFromMAPWarmFull<br/>0x044C]
    CheckThrottle -->|Part Throttle| HOTMAP[HOTMAP_AdvanceFromMAPWarmPart<br/>0x03F2]

    CLDMAP --> Calc3D[3D CALCULATION<br/>Type 16]
    HOTMAP --> Calc3D
    WOTMAP --> Calc3D

    Calc3D --> ApplyLimits[APPLY LIMITS]
    ApplyLimits --> ApplyModifiers[APPLY MODIFIERS]
    ApplyModifiers --> KnockRetard[KNOCK RETARD?]
    KnockRetard --> FinalTiming[FINAL TIMING<br/>Degrees BTDC]
```

---

## Detailed Spark Calculation Flow

```mermaid
flowchart TD
    %% Temperature Check
    CTS[Coolant Temp Sensor] --> TempCheck{Temp < TMPSWP?}
    TempCheck -->|Yes| UseCold[Use CLDMAP<br/>Cold Engine]
    TempCheck -->|No| ThrottleCheck{Throttle Position?}

    %% MAP Tables Selection
    MAP[MAP Sensor] --> CLDMAP_S[CLDMAP_AdvanceFromMAPCold<br/>0x03D3]
    MAP --> HOTMAP_S[HOTMAP_AdvanceFromMAPWarmPart<br/>0x03F2]
    MAP --> WOTMAP_S[WOTMAP_AdvanceFromMAPWarmFull<br/>0x044C]

    ThrottleCheck -->|Closed/WOT| WOTPath[WOT Path]
    ThrottleCheck -->|Part Throttle| PartPath[Part Throttle Path]

    %% Path Selection
    UseCold --> ADVCLS_Check{Closed Throttle<br/>Timer Active?}
    ADVCLS_Check -->|Yes| ADVCLS[ADVCLS_AdvanceAddedForClosedLoop<br/>0x0413]
    ADVCLS_Check -->|No| CLDMAP_Only[CLDMAP Only]

    WOTPath --> WOTMAP_S
    PartPath --> HOTMAP_S

    CLDMAP_Only --> BaseAdvance
    ADVCLS --> BaseAdvance
    WOTMAP_S --> BaseAdvance
    HOTMAP_S --> BaseAdvance

    %% 3D Calculation (Type 16)
    subgraph Three_D["3D Calculation (Type 16)"]
        GOVNER[GOVNER_AdvanceFromRPM2<br/>0x049F<br/>RPM Axis]
        MAP_Source[MAP Advance Table<br/>HOTMAP or WOTMAP]
        MAPMUL[MAPMUL_MultiplierOnMapAdvance<br/>0x046E<br/>For negative timing]

        GOVNER --> Calc3D_A["RPM Advance"]
        MAP_Source --> Calc3D_B["MAP Advance"]
        MAPMUL --> CheckNegative{MAP Advance < 0?}

        CheckNegative -->|Yes| Multiply["× MAPMUL<br/>Multiplier for retard"]
        CheckNegative -->|No| Pass[No multiplier]

        Calc3D_A --> Sum["RPM + MAP Advance"]
        Calc3D_B --> Sum
        Multiply --> Sum
        Pass --> Sum

        Sum --> Result[Base Timing<br/>Before limits]
    end

    BaseAdvance --> Three_D

    %% Limits
    Result --> RPMLMT[RPMLMT_AdvanceMinFromRpm<br/>0x045F<br/>Minimum Limit]
    Result --> SPKLMT[SPKLMT_AdvanceFromRpmMAX<br/>0x04B0<br/>Maximum Limit]

    RPMLMT --> ClampMin[Use Maximum<br/>of Result and RPMLMT]
    SPKLMT --> ClampMax[Use Minimum<br/>of Result and SPKLMT]

    ClampMin --> AfterLimits[Timing After Limits]
    ClampMax --> AfterLimits

    %% Knock Retard
    AfterLimits --> KnockCheck{Knock Detected?}

    KnockCheck -->|Yes| GetRPM{RPM in Range?}
    KnockCheck -->|No| GetAdaptive[Adaptive Retard]

    GetRPM -->|Yes| DLTKNK[DLTKNK_KnockSensorVoltage<br/>0x0549<br/>Voltage Threshold]
    GetRPM -->|No| NoKnock[No Knock Retard]

    DLTKNK --> VoltageCheck{Voltage > Threshold?}
    VoltageCheck -->|Yes| ApplyRate[Apply Knock Rate]

    ApplyRate --> CheckBoost{In Boost?}
    CheckBoost -->|Yes| RTRDRT2[RTRDRT2_KnockRetardRateInBoost<br/>0x04F8<br/>Fast retard rate]
    CheckBoost -->|No| RTRDRT[RTRDRT_KnockRetardRateNoBoost<br/>0x04EB<br/>Normal retard rate]

    RTRDRT2 --> RETMAX[RETMAX_MaxKnockRetardFromMap<br/>0x0512<br/>MAP-based limit]
    RTRDRT --> RETMAX

    RETMAX --> KNKLIM[KNKLIM_MaxKnockRetard<br/>0x0522<br/>Absolute limit]
    KNKLIM --> KnockAmount[Knock Retard Amount]

    VoltageCheck -->|No| NoKnock
    NoKnock --> NoKnock

    %% Adaptive Retard
    GetAdaptive --> FactorCheck{Factor at 0x002B}
    FactorCheck -->|0| NoAdapt[No Adaptive Retard]
    FactorCheck -->|>0| ApplyAdaptive[Apply Factor]

    ApplyAdaptive --> ARRPM[ARRPM_AdaptiveRetardFromRPM<br/>0x055B<br/>RPM-based]
    ApplyAdaptive --> ARMAP[ARMAP_AdaptiveRetardFromMAP<br/>0x056D<br/>MAP-based]

    ARRPM --> AdaptiveAmount[Adaptive Retard]
    ARMAP --> AdaptiveAmount

    NoAdapt --> NoAdaptive[No Adaptive]

    %% Scatter Control (Idle RPM Stabilization)
    AfterLimits --> ScatterCheck{Scatter Active?<br/>temp > SSTEMP}
    ScatterCheck -->|Yes| DeltaRPM[Calculate ΔRPM]
    ScatterCheck -->|No| NoScatter[No Scatter]

    DeltaRPM --> AboveBelow{RPM vs Target?}
    AboveBelow -->|Below| SPKADD[SPKADD_SparkAdvanceAdded<br/>0x068A<br/>Add advance]
    AboveBelow -->|Above| SPKRET[SPKRET_SparkAdvanceRetarded<br/>0x0699<br/>Remove advance]

    SPKADD --> ScatterAdjust[Scatter Adjustment]
    SPKRET --> ScatterAdjust

    ScatterAdjust --> FinalTiming
    NoScatter --> FinalTiming
    KnockAmount --> FinalTiming
    NoKnock --> FinalTiming
    NoAdaptive --> FinalTiming
    AdaptiveAmount --> FinalTiming

    %% Fuel Idle Stabilization
    FinalTiming --> IDLADD_Check{IDLADD Active?<br/>temp > IDLTMP}
    IDLADD_Check -->|Yes| IDLADD[IDLADD_FuelStabilization<br/>0x06A8<br/>Fuel adjustment]
    IDLADD_Check -->|No| Done[Calculation Complete]

    IDLADD --> Done
```

---

## 3D Calculation (Type 16) Detail

```mermaid
flowchart LR
    subgraph Type_16["Type 16: 3D Calculated Tables"]
        direction TB

        Input[Inputs] --> XAxis[GOVNER<br/>RPM Axis Table]
        Input --> YAxis[YAxis Table<br/>HOTMAP or WOTMAP]
        Input --> Multiplier[MAPMUL<br/>MAP Multiplier]

        XAxis --> Lookup1["Lookup RPM Advance"]
        YAxis --> Lookup2["Lookup MAP Advance"]

        Lookup1 --> CheckSign{MAP Advance < 0?}
        Lookup2 --> CheckSign

        CheckSign -->|Yes| ApplyMult["Apply MAPMUL<br/>Multiplier for retard"]
        CheckSign -->|No| Direct[Direct Addition]

        ApplyMult --> Sum["RPM Advance +<br/>Modified MAP Advance"]
        Direct --> Sum["RPM Advance +<br/>MAP Advance"]

        Sum --> Output[Base Timing]
    end

    Output --> MinTable[RPMLMT<br/>Minimum Table]
    Output --> MaxTable[SPKLMT<br/>Maximum Table]

    MinTable --> Clamp[Clamp to Min]
    MaxTable --> Clamp

    Clamp --> Result[Final 3D Result]
```

**Type 16 Tables**:
- `PTTIME_PartThrottleTotalTiming` (0x0421) - Uses HOTMAP
- `FTTIME_FullThrottleTotalTiming` (0x0436) - Uses WOTMAP

---

## Knock Retard Flow

```mermaid
flowchart TD
    subgraph Knock_Detection["Knock Detection"]
        KnockSensor[Knock Sensor] --> Amp[Amplifier]
        Amp --> DLTKNK[DLTKNK_KnockSensorVoltage<br/>RPM-based Threshold]

        RPM[RPM Sensor] --> InRange{KNKRPM to KLMRPM?}
        InRange -->|No| NoKnock[No Knock Detection]
        InRange -->|Yes| MAP_Check{MAP + BARO > KNKOFS?}

        MAP_Check -->|Yes| Active[Knock Detection Active]
        MAP_Check -->|No| NoKnock

        Active --> TPS_Check{TPS > THRKNK?}
        TPS_Check -->|Yes| Detect[Compare Voltage to Threshold]
        TPS_Check -->|No| NoKnock

        Detect -->|Voltage > DLTKNK| KnockDetected[Knock Detected!]
        Detect -->|Voltage <= DLTKNK| NoKnock
    end

    subgraph Knock_Retard["Knock Retard Application"]
        KnockDetected --> Rate[Select Retard Rate]

        Boost{In Boost?<br/>MAP > BARO} -->|Yes| RTRDRT2[RTRDRT2<br/>Fast Rate]
        Boost -->|No| RTRDRT[RTRDRT<br/>Normal Rate]

        Rate --> Apply[Apply to Counter]
        Apply --> Limit[RETMAX<br/>MAP-based Limit]
        Limit --> Absolute[KNKLIM<br/>Absolute Limit]
        Absolute --> Subtract[Subtract from Timing]
    end

    subgraph Recovery["Knock Recovery"]
        Timer[Timer] --> INCSRT[INCSRT_KnockRetardIncreaseRate<br/>Recovery Rate]
        INCSRT --> Decay["Decay Counter<br/>1/2° per (INCSRT+1) × 11ms"]
        Decay --> Done[No Retard]
    end
```

**Knock Retard Rates**:
- `RTRDRT_KnockRetardRateNoBoost` (0x04EB) - Normal rate
- `RTRDRT2_KnockRetardRateInBoost` (0x04F8) - In-boost rate
- `INCSRT_KnockRetardIncreaseRate` (0x0505) - Recovery rate

**Valid INCSRT Values**: 0, 1, 3, 7, 0x0F, 0x1F, 0x3F, 0x7F, 0xFF

---

## Adaptive Retard Flow

```mermaid
flowchart TD
    subgraph Adaptive_Retard["Adaptive Retard System"]
        Factor[RAM 0x002B<br/>Factor Value] --> Check{Factor > 0?}

        Check -->|0| NoAdapt[No Adaptive Applied]
        Check -->|>0| Apply[Apply Factor]

        Apply --> Both[Apply to Both ARRPM and ARMAP]

        Both --> RPM_Tbl[ARRPM_AdaptiveRetardFromRPM<br/>0x055B]
        Both --> MAP_Tbl[ARMAP_AdaptiveRetardFromMAP<br/>0x056D]

        RPM_Tbl --> Result1["Retard × Factor"]
        MAP_Tbl --> Result2["Retard × Factor"]

        Result1 --> Subtract1[Subtract from Timing]
        Result2 --> Subtract2[Subtract from Timing]
    end

    subgraph Factor_Control["Factor Controlled by Boost Control"]
        BoostCtrl[Boost Control] --> SetFactor[Set Factor Based on<br/>Boost History]

        SetFactor -->|0| None[0 = No retard]
        SetFactor -->|1| Full[1 = Full retard]
        SetFactor -->|2| Half[2 = Half retard]
        SetFactor -->|3| ThreeQ[3 = 3/4 retard]
    end
```

**Factor Values** (RAM 0x002B):
- 0 = No adaptive retard
- 1 = Full retard (100%)
- 2 = Half retard (50%)
- 3 = Three-quarter retard (75%)

---

## Spark Scatter Control

```mermaid
flowchart TD
    subgraph Scatter_Control["Spark Scatter for Idle Stabilization"]
        Temp[Engine Temp] --> Above{Temp > SSTEMP?}
        Above -->|No| Off[Scatter Off]

        Above -->|Yes| RPM[RPM Sensor]
        RPM --> Speed{Speed > SSIPRD?}
        Speed -->|Yes| Off
        Speed -->|No| Active[Scatter Active]

        Active --> Delta[Calculate ΔRPM]

        Delta --> Below{RPM < Target?}
        Delta --> AboveTarget{RPM > Target?}

        Below --> SPKADD[SPKADD_SparkAdvanceAdded<br/>Increase RPM]
        AboveTarget --> SPKRET[SPKRET_SparkAdvanceRetarded<br/>Decrease RPM]

        SPKADD --> Adjust1[Adjust Timing]
        SPKRET --> Adjust2[Adjust Timing]

        Adjust1 --> Timing[Final Timing]
        Adjust2 --> Timing
    end

    subgraph Idle_Fuel["Idle Fuel Stabilization"]
        Temp2[Engine Temp] --> Above2{Temp > IDLTMP?}
        Above2 -->|Yes| Delta2[Calculate ΔRPM]
        Delta2 --> IDLADD[IDLADD_FuelStabilization<br/>0x06A8<br/>Fuel Adjustment]

        IDLADD --> Fuel[Final Fuel]
    end
```

**Purpose**: Maintains stable idle RPM by making small timing and fuel adjustments.

---

## Start-to-Run Transfer

```mermaid
stateDiagram-v2
    [*] --> Start: Engine Cranking
    Start --> CheckRPM: RPM > SKAPRD?

    CheckRPM --> Run: Immediate to Run
    CheckRPM --> CheckTemp: Wait for Timer

    state CheckTemp {
        [*] --> Hot: Temp > SRTMTP?
        Hot --> [*]: Use SRTIME
        [*] --> Cold: Temp <= SRTMTP?
        Cold --> [*]: Use SRTIME2
    }

    CheckTemp --> Run: Timer Expired?

    state Run {
        [*] --> CheckRPM2: RPM < RNSTTR?
        CheckRPM2 --> Start: RPM < STRNTR
        [*] --> [*]: Normal Run
    }

    Run --> [*]
```

**Transfer Points**:
- `STRNTR_SparkStartRunTransferPointRpm` (0x06C6) - Start→Run transfer
- `RNSTTR_SparkRunStartTransferPointRpm` (0x06D3) - Run→Start transfer
- `SKAPRD_SparkImmediateSwitchToRunAboveThisRpm` (0x06E0) - Immediate switch
- `SRTIME/SRTIME2` - Consecutive EPPs above transfer point (hot/cold)
- `SRTMTP_SparkTempSwitchPointFor_SRTIME` (0x0721) - Temp switch

---

## Table Relationships Summary

| Stage | Tables | Effect |
|-------|--------|--------|
| **Base MAP** | CLDMAP, HOTMAP, WOTMAP | MAP-based advance |
| **RPM Axis** | GOVNER | RPM-based advance |
| **Multiplier** | MAPMUL | For negative MAP advance |
| **3D Calc** | PTTIME, FTTIME | Combined RPM+MAP timing |
| **Limits** | RPMLMT, SPKLMT | Min/max clamp |
| **Knock** | RETMAX, KNKLIM, RTRDRT/2 | Knock retard |
| **Adaptive** | ARRPM, ARMAP | Learned retard |
| **Scatter** | SPKADD, SPKRET, IDLADD | Idle stabilization |

---

## Timing Calculation Summary

```
TOTAL TIMING = BaseMAPAdvance + RPMAdvance
              (limited by RPMLMT/SPKLMT)
              - KnockRetard
              - AdaptiveRetard (ARRPM × factor + ARMAP × factor)
              ± ScatterAdjustment
```

**Key Points**:
1. No "base timing" is added - all values are relative to TDC (0°)
2. MAP advance can be negative (retard) under boost
3. `MAPMUL` multiplies negative MAP advance (more retard at higher RPM)
4. Knock retard is recovered slowly using `INCSRT`
5. Adaptive retard is controlled by boost control system

---

## Related Documents

- [Table Reference](table-reference.md) - Complete table listing
- [Fuel System Flow](fuel-system-flow.md) - Fuel calculation flow
- [Boost System Flow](boost-system-flow.md) - Boost control flow
- [Ignition Timing](../tuning/ignition-timing.md) - Tuning guide
