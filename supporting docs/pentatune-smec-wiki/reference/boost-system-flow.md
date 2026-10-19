# Boost System Flow

Complete boost control flow for T-SMEC 22 MTX S-II (Turbo II) calibration.

---

## Overview

The boost control system uses wastegate duty cycle (WGDC) to control boost pressure. The system has multiple layers:
1. **Base lookup** - Target boost vs RPM/temperature/speed
2. **WGDC calculation** - Convert target boost to wastegate duty cycle
3. **Adaptive learning** - Adjusts WGDC based on actual vs target boost
4. **Knock interaction** - Reduces WGDC when knock detected
5. **Boost creep prevention** - Limits part-throttle boost buildup

---

## High-Level Flow Diagram

```mermaid
flowchart TD
    Start([Boost Control]) --> GetInputs[Read Inputs]
    GetInputs --> Targets[TARGET BOOST<br/>Minimum of Tables]

    Targets --> BaseWGDC[BASE WGDC<br/>T2DCWOT Lookup]
    BaseWGDC --> RPMAdj[RPM Adjustment<br/>T2DCWADJ]
    RPMAdj --> BoostAdj[Boost Error Adjustment<br/>T2DCWBST]
    BoostAdj --> CheckKnock{Knock Detected?}

    CheckKnock -->|Yes| KnockReduce[Reduce WGDC<br/>T2KDCMIN/INC]
    CheckKnock -->|No| CheckAdaptive{Adaptive Active?}

    CheckAdaptive -->|Yes| AdaptiveAdj[Apply Adaptive<br/>MPCORR]
    CheckAdaptive -->|No| CheckCreep{Boost Creep?}

    AdaptiveAdj --> CheckCreep
    KnockReduce --> CheckCreep

    CheckCreep -->|Yes| CreepLimit[Limit to T2PRTMAX]
    CheckCreep -->|No| FinalWGDC[FINAL WGDC]

    FinalWGDC --> Wastegate[WASTEGATE SOLENOID]
    Wastegate --> Boost[ACTUAL BOOST]
```

---

## Detailed Boost Control Flow

```mermaid
flowchart TD
    subgraph Inputs["Input Sensors"]
        MAP[MAP Sensor<br/>Current Boost]
        RPM[RPM Sensor<br/>Engine RPM]
        CTS[Coolant Temp<br/>Engine Temp]
        Speed[Vehicle Speed<br/>MPH]
        TPS[TPS Sensor<br/>Throttle Position]
        Knock[Knock Sensor<br/>Knock Detection]
    end

    %% Target Boost Calculation
    subgraph Target_Boost["Target Boost Calculation"]
        MAP --> AllowedRPM[AllowedBoost_FromRpm<br/>RPM-based limit]
        CTS --> AllowedTemp[AllowedBoost_FromTemp<br/>Temp-based limit]
        Speed --> AllowedSpeed[AllowedBoost_FromSpeed<br/>Speed-based limit]
        TPS --> AllowedPT[AllowedBoostPartThrottle<br/>PT-based limit]
    end

    %% Find Minimum
    AllowedRPM --> MinBoost[Minimum Target Boost]
    AllowedTemp --> MinBoost
    AllowedSpeed --> MinBoost
    AllowedPT --> MinBoost

    %% Base WGDC Lookup
    MinBoost --> T2DCWOT[T2DCWOT_FullThrottleWGDC<br/>0x1464<br/>Base Duty Cycle]
    T2DCWOT --> T2DCWADJ[T2DCWADJ_WGDC_Adjustment<br/>0x1476<br/>RPM-based adjustment]
    T2DCWADJ --> CalcError[Calculate Boost Error]

    %% Boost Error Adjustment
    MAP --> CalcError
    MinBoost --> CalcError
    CalcError --> DeltaBoost[ΔBoost = Target - Actual]

    DeltaBoost --> CheckRange{ΔBoost in Range?}
    CheckRange -->|Yes| T2DCWBST[T2DCWBST_WGDC_Adjustment<br/>0x1488<br/>Boost error adjustment]
    CheckRange -->|No| Clamp[Clamp to Range]

    T2DCWBST --> BaseDC["Base WGDC + Adjustments"]
    Clamp --> BaseDC

    %% Knock Detection
    Knock --> KnockCheck{Knock Detected?}
    KnockCheck -->|Yes| CheckBoost2{Boost > T2KNOKMP?}
    KnockCheck -->|No| NoKnock[No Knock Reduction]

    CheckBoost2 -->|Yes| CheckRetard{Retard > T2WGKNRD?}
    CheckBoost2 -->|No| NoKnock

    CheckRetard -->|Yes| ApplyKnock[Apply WGDC Reduction]
    CheckRetard -->|No| NoKnock

    ApplyKnock --> T2KDCINC[T2KDCINC<br/>Increase step]
    T2KDCINC --> T2KDCMAX[T2KDCMAX<br/>Maximum increase]
    T2KDCMAX --> T2KDCMIN[T2KDCMIN<br/>Minimum increase]
    T2KDCMIN --> KnockDC[Knock-Reduced WGDC]

    NoKnock --> WGDC1[Current WGDC]
    KnockDC --> WGDC1

    %% Adaptive Correction
    WGDC1 --> Adaptive{RPM in Range?<br/>DCRPML to DCRPMH}
    Adaptive -->|Yes| CheckTime{Time > T2INCPT?}
    Adaptive -->|No| CheckCreep

    CheckTime -->|Yes| CheckClose{Close to Target?<br/>T2MPROOF}
    CheckTime -->|No| CheckCreep

    CheckClose -->|Yes| IncCounter[Increment Counter]
    CheckClose -->|No| CheckFloor{Close to Floor?<br/>T2MPFLOR}
    IncCounter --> CheckFloor

    CheckFloor -->|Yes| DecCounter[Decrement Counter]
    CheckFloor -->|No| CheckCreep

    DecCounter --> CheckRange2{Counter in Range?<br/>-LWRLIM to UPRLIM}
    CheckRange2 -->|Yes| MPCORR[MAP Correction<br/>Learned Value]
    CheckRange2 -->|No| CheckCreep

    MPCORR --> AdaptiveDC[Adaptive-Adjusted WGDC]
    NoAdaptive[No Adaptive] --> CheckCreep
    AdaptiveDC --> CheckCreep

    %% Boost Creep Prevention
    CheckCreep --> CreepCheck{Part Throttle?<br/>and RPM > T2RPMBST}
    CreepCheck -->|Yes| CheckRate{Rate < T2RATLIM?}
    CreepCheck -->|No| FinalDC[Final WGDC]

    CheckRate -->|Yes| T2PRTMAX[Limit to T2PRTMAX<br/>Maximum for creep]
    CheckRate -->|No| FinalDC

    T2PRTMAX --> FinalDC

    FinalDC --> Solenoid[Wastegate Solenoid]
    Solenoid --> ActualBoost[Actual Boost Pressure]
```

---

## Adaptive Learning System

```mermaid
flowchart TD
    subgraph Adaptive_Learning["Adaptive WGDC Learning"]
        direction LR

        Delta[ΔBoost = Target - Actual] --> Check1{ΔMAP < T2MPDEL1?}

        Check1 -->|Yes| Inc[Inc Counter]
        Check1 -->|No| Dec[Dec Counter]

        Inc --> Check2{Counter > 0?}
        Dec --> Check3{Counter < 0?}

        Check2 -->|Yes| Limit1[Check Against UPRLIM]
        Check3 -->|Yes| Limit2[Check Against LWRLIM]

        Limit1 --> MPCORR[MAP Correction Value]
        Limit2 --> MPCORR
    end

    MPCORR --> Apply{Apply to Base WGDC}
    Apply --> StopCheck{Stop Adaptive?}

    StopCheck -->|Close to Target| T2MPROOF[T2MPROOF<br/>Stop when close]
    StopCheck -->|Close to Floor| T2MPFLOR[T2MPFLOR<br/>Stop when near floor]
    StopCheck -->|Continue| Continue[Continue Learning]
```

**Adaptive Parameters**:
- `T2MPDEL1` (0x14D7) - Increment threshold
- `T2INCPT` (0x14E4) - Time before increment
- `UPRLIM` (0x14F0) - Upper limit
- `LWRLIM` (0x14FC) - Lower limit
- `T2MPROOF` (0x1508) - Stop when close to target
- `T2MPFLOR` (0x1515) - Stop when close to floor

---

## RPM Boundaries for Adaptive

```mermaid
flowchart TD
    RPM[RPM Sensor] --> RangeCheck{RPM Range?}

    RangeCheck -->|< DCRPML| NoCorrection[No Correction<br/>Below minimum]
    RangeCheck -->|DCRPM1-2| Zone1[Zone 1<br/>First boundary]
    RangeCheck -->|DCRPM2-3| Zone2[Zone 2<br/>Second boundary]
    RangeCheck -->|DCRPM3-H| Zone3[Zone 3<br/>Third boundary]
    RangeCheck -->|> DCRPMH| NoCorrection2[No Correction<br/>Above maximum]

    Zone1 --> Bndry1[Use Boundary 1]
    Zone2 --> Bndry2[Use Boundary 2]
    Zone3 --> Bndry3[Use Boundary 3]

    Bndry1 --> Apply[Apply MPCORR]
    Bndry2 --> Apply
    Bndry3 --> Apply
```

**RPM Boundaries**:
- `DCRPML` (0x13A0) - No correction below
- `DCRPM1` (0x13C8) - Boundary 1
- `DCRPM2` (0x13D5) - Boundary 2
- `DCRPM3` (0x13E2) - Boundary 3
- `DCRPMH` (0x1522) - No correction above

---

## Knock-Boost Interaction

```mermaid
flowchart TD
    subgraph Knock_Interaction["Knock Retard ↔ WGDC Interaction"]
        Knock[Knock Detected] --> BoostLevel{Boost Level?}

        BoostLevel -->|< T2KNOKMP| NoCount[Don't Count Knock]
        BoostLevel -->|>= T2KNOKMP| CountKnock[Count Knock Event]

        CountKnock --> RetardLevel{Retard Amount?}
        RetardLevel -->|>= T2WGKNRD| ReduceWGDC[Reduce WGDC]

        ReduceWGDC --> T2DECTIM[T2DECTIM<br/>Time Scale for Recovery]
        T2DECTIM --> Decay[Decay WGDC Back<br/>T2DCDECK rate]

        NoCount --> NoReduce[No WGDC Reduction]
    end

    subgraph WGDC_Reduction["WGDC Reduction Steps"]
        direction LR

        Base[Base WGDC] --> T2KDCINC["T2KDCINC<br/>Increase Step"]
        T2KDCINC --> Min["T2KDCMIN<br/>Minimum"]
        Min --> Max["T2KDCMAX<br/>Maximum"]
    end

    subgraph Recovery["Recovery When Spark Derated"]
        Derated[Spark Still Derated] --> T2DCDECK["T2DCDECK<br/>Decrement Rate"]
        T2DCDECK --> Normal[Return to Normal]
    end
```

**Knock Parameters**:
- `T2KNOKMP` (0x1408) - Minimum boost to count knock
- `T2WGKNRD` (0x1415) - Minimum retard to reduce WGDC
- `T2KDCINC` (0x149B) - Increase step
- `T2KDCMAX` (0x14A7) - Maximum increase
- `T2KDCMIN` (0x14B3) - Minimum increase
- `T2DECTIM` (0x14BF) - Time scale for recovery
- `T2DCDECK` (0x14CB) - Decrement when still derated

---

## Boost Creep Prevention

```mermaid
flowchart TD
    subgraph Boost_Creep["Part-Throttle Boost Creep Prevention"]
        direction TB

        Inputs[RPM, MAP, TPS] --> Conditions{Conditions Met?}

        Conditions -->|Part Throttle<br/>RPM > T2RPMBST| Active[Creep Prevention Active]
        Conditions -->|Otherwise| Bypass[Bypass Prevention]

        Active --> RateCheck{ΔBoost Rate < T2RATLIM?}

        RateCheck -->|Yes| Calculate[Calculate Correction<br/>T2RESFAC]
        RateCheck -->|No| UseMax[Use T2PRTMAX<br/>Maximum]

        Calculate --> Hysteresis[Apply T2MPDEL<br/>Hysteresis]
        Hysteresis --> Limit1[Limit WGDC]
        UseMax --> Limit1

        Limit1 --> Final[Final WGDC]
        Bypass --> Final
    end
```

**Creep Parameters**:
- `T2RPMBST` (0x1421) - Minimum RPM to track creep
- `T2RATLIM` (0x142D) - Rate limit from RPM
- `T2PRTMAX` (0x143C) - Maximum WGDC for creep
- `T2MPDEL` (0x1448) - Hysteresis
- `T2RESFAC` (0x1455) - Response factor from MAP

---

## MAP Switch Points

```mermaid
flowchart LR
    RPM[RPM] --> Zone1{< DCRPM1}
    RPM --> Zone2{DCRPM1-2}
    RPM --> Zone3{DCRPM2-3}
    RPM --> Zone4{DCRPM3-H}

    Zone1 -->|T2 WGDC| Map0[Below MAPPT<br/>No switch]
    Zone2 -->|T1 WGDC| Map1[MAPPT Switch<br/>T1 mode]
    Zone3 -->|T2 WGDC| Map2[T2MAPPT Switch<br/>T2 mode]
    Zone4 -->|T2 WGDC| Map3[T2MAPPT2 Switch<br/>T2 mode 2]
```

**MAP Switch Points**:
- `MAPPT` (0x13BA) - T1 switch point
- `T2MAPPT` (0x13EE) - T2 switch point 1
- `T2MAPPT2` (0x13FB) - T2 switch point 2

---

## Complete WGDC Calculation Formula

```
FINAL_WGDC = T2DCWOT[TargetBoost]              // Base lookup
            + T2DCWADJ[RPM]                      // RPM adjustment
            + T2DCWBST[ΔBoost]                    // Boost error
            - KnockReduction                      // Knock reduction
            + MPCORR                              // Adaptive correction
            (limited by T2PRTMAX if creep)       // Creep limit
```

**Applied to Wastegate** → Actual Boost Pressure

---

## Table Relationships Summary

| Stage | Tables | Effect |
|-------|--------|--------|
| **Target** | AllowedBoost_FromRpm/Temp/Speed/PT | Minimum target boost |
| **Base WGDC** | T2DCWOT, T2DCWADJ, T2DCWBST | Base duty cycle calculation |
| **Knock** | T2KNOKMP, T2WGKNRD, T2KDC* | WGDC reduction when knocking |
| **Adaptive** | T2MPDEL1, T2INCPT, UPRLIM, LWRLIM | Learned MAP correction |
| **Creep** | T2RPMBST, T2RATLIM, T2PRTMAX, T2RESFAC | Part-throttle limit |
| **Boundaries** | DCRPM*, MAPPT*, T2MAPPT* | RPM/MAP zones |

---

## Key Concepts

### Target Boost Selection
The ECU uses the **minimum** of all target boost tables:
- `AllowedBoost_FromRpm` - RPM-based limit
- `AllowedBoost_FromTemp` - Temperature-based limit
- `AllowedBoost_FromSpeed` - Speed-based limit
- `AllowedBoostPartThrottle` - TPS-based limit

### WGDC Meaning
- 0x00 (0) = Wastegate fully closed (maximum boost)
- 0xC8 (200) = 100% duty cycle (wastegate fully open)
- Values above 0xC8 can be used for quick boost reduction

### Adaptive Learning
The system learns a correction value (`MPCORR`) that adjusts the base WGDC:
- Incremented when boost is below target (slowly)
- Decremented when boost is above target (slowly)
- Has upper/lower limits (`UPRLIM`, `LWRLIM`)
- Stops when close to target (`T2MPROOF`) or floor (`T2MPFLOR`)

---

## Related Documents

- [Table Reference](table-reference.md) - Complete table listing
- [Fuel System Flow](fuel-system-flow.md) - Fuel calculation flow
- [Spark System Flow](spark-system-flow.md) - Spark calculation flow
- [Boost Control](../tuning/boost-control.md) - Tuning guide
