# Fuel System Flow

Complete fuel calculation flow for T-SMEC 22 MTX S-II calibration.

---

## Overview

The fuel system uses a multi-stage calculation that starts with base pulsewidth from lookup tables, then applies numerous modifiers in a specific order. The ECU does not use AFR targets directly - it uses pulsewidth values.

**Key Concept**: The MPTune `;mpfuel*` metadata (mpfuelfull1, mpfuelpart1, etc.) is **only for MPTune visualization**. The ECU uses the actual pulsewidth tables (WOTTBL, MAPTBL, etc.).

---

## High-Level Flow Diagram

```mermaid
flowchart TD
    Start([Engine Cranking?]) -->|Yes| StartCalc["STRTFL² × (1-STFBAR-STFTMP) × EPPMUL + BATOFF×4"]
    Start -->|No| BasePW["BASE PULSEWIDTH<br/>WOTTBL[MAP]"]

    StartCalc --> FinalPW[FINAL PULSEWIDTH]

    subgraph Start_Fuel["Start Fuel (Cranking) Components"]
        STRTFL[STRTFL<br/>StartFuel_FromTemp]
        EPPMUL[EPPMUL<br/>FuelStartFuelPerEPP]
        STFBAR[STFBAR<br/>Baro Correction]
        STFTMP[STFTMP<br/>Temp Modifier]
        BATOFF[BATOFF<br/>Battery Offset]
    end

    subgraph Running_Fuel["Running Fuel (Normal Operation) Components"]
        Modifiers["FUEL MODIFIERS<br/>Battery + Baro + PumpEff + ChargeTemp + ColdEnrich"]
        Pumpshot[TRANSIENT ENRICHMENT<br/>Pumpshot]
        Decel[DECEL LEANOUT]
        O2[O2 CLOSED-LOOP<br/>Feedback]
        AutoCal[ADAPTIVE MEMORY<br/>AutoCal]
    end

    BasePW --> Modifiers
    Modifiers --> Pumpshot
    Pumpshot --> Decel
    Decel --> O2
    O2 --> AutoCal
    AutoCal --> FinalPW

    FinalPW --> Injectors[FUEL INJECTORS]
```

---

## Detailed Fuel Calculation Flow

```mermaid
flowchart TD
    %% Base Tables
    MAP[MAP Sensor<br/>Raw ADC 0-255] --> WOTTBL[WOTTBL_FuelFullThrottle<br/>0x07DD]
    MAP --> MAPTBL[MAPTBL_FuelPartThrottle<br/>0x07E8]

    %% Table Selection
    WOTTBL --> ThrottleCheck{Throttle Position?}
    ThrottleCheck -->|Closed| NT[FuelBaselineFromMap<br/>N/T Table]
    ThrottleCheck -->|Partial| PT[Part Throttle Mode]
    ThrottleCheck -->|WOT| FT[WOT Mode]

    MAPTBL --> PT

    %% Base Pulsewidth Consolidation
    NT --> BasePW[Base Pulsewidth<br/>Selected from MAP Table]
    PT --> BasePW
    FT --> BasePW

    %% Battery Offset
    Battery[Battery Voltage] --> BATOFF[BATOFF_FuelBatteryOffset<br/>0x07F2]
    BATOFF --> Add1["(+) Additive"]

    %% Barometric Compensation
    Baro[Barometer] --> PWADD[PWADD_FuelPWModifierFromBaro<br/>0x095B]
    PWADD --> Add2["(+) Additive"]

    %% Pumping Efficiency
    RPM[RPM Sensor] --> PEFTBL[PEFTBL_PumpingEfficiency<br/>0x0931]
    PEFTBL --> Mult1["(×) Multiplicative<br/>PW × PumpEff%"]

    %% Charge Temp
    ChargeTemp[Charge Temp] --> AIRTMP[AIRTMP_FuelEnrichmentFromChargeTemp<br/>0x0949]
    AIRTMP --> Mult2["(×) Multiplicative"]

    %% Cold Enrichment
    CTS[Coolant Temp] --> CURVEA[CURVEA_FuelColdEnrichmentCurveA<br/>0x0810]
    CTS --> CURVEB[CURVEB_FuelColdEnrichmentCurveB<br/>0x0823]
    CTS --> CURVEC[CURVEC_FuelColdEnrichmentCurveC<br/>0x0838]
    RPM --> FCRCVB[FCRCVB_FuelWOTScaleEnrichBFromRpm<br/>0x084B]
    Baro --> BAROCP[BAROCP_BaroCompensationOfWarmupFactor<br/>0x0905]

    CURVEA --> ColdEnrich["Cold Enrichment Formula"]
    CURVEB --> ColdEnrich
    CURVEC --> ColdEnrich
    FCRCVB --> ColdEnrich
    BAROCP --> ColdEnrich

    ColdEnrich --> Mult3["(×) Multiplicative<br/>1 + formula"]

    %% Transient Enrichment (Pumpshot)
    TPS[TPS Sensor] -->|Calculate ΔTPS| TPSCheck{ΔTPS > POSTRG?}
    TPSCheck -->|Yes| POSSLP[POSSLP_DeltaTPSEnrichment<br/>0x0985]
    POSSLP --> THRTCN[THRTCN_EnrichmentTime_Decay<br/>0x0AA3]
    THRTCN --> Add3["(+) Additive"]

    MAP -->|Calculate ΔMAP| MAPCheck{ΔMAP > MAPTRG?}
    MAPCheck -->|Yes| AESLOP[AESLOP_DeltaMAPEnrichment<br/>0x09B2]
    AESLOP --> AETIME[AETIME_EnrichmentTime_Decay<br/>0x0A95]
    AETIME --> Add4["(+) Additive"]

    %% Decel Leanout
    TPS -->|Calculate ΔTPS| DecelTPS{ΔTPS triggers decel?}
    DecelTPS -->|Yes| LOTHR[LOTHR_DecelLeanoutFactor<br/>0x09D2]
    LOTHR --> LOTIME[LOTIME_DecelLeanoutTime<br/>0x0AB2]
    LOTIME --> Mult4["(×) Multiplicative<br/>Lean factor"]

    MAP -->|Calculate ΔMAP| DecelMAP{ΔMAP triggers decel?}
    DecelMAP -->|Yes| DECEL[DECEL_DecelLeanoutFactorMAP<br/>0x0A0A]
    DECEL --> LMAPTC[LMAPTC_TimeConstant<br/>0x0A86]
    LMAPTC --> Mult5["(×) Multiplicative<br/>Lean factor"]

    %% O2 Closed-Loop
    O2Sensor[O2 Sensor] --> O2CNTR[O2CNTR Controller]
    PRIRMP[PRIRMP_PrimaryRamp<br/>0x0D29] --> O2CNTR
    SECRMP[SECRMP_SecondaryRamp<br/>0x0DF8] --> O2CNTR
    O2CNTR --> O2Mult["(×) Multiplicative<br/>Rich/Lean correction"]

    %% Adaptive Memory
    RPM --> CellBoundary{RPM/MAP Cell?}
    MAP --> CellBoundary
    CellBoundary --> AutoCalCell["AutoCal Cell<br/>12 cells + idle"]
    AutoCalCell --> AMLIML[AMLIML/AMLIMH<br/>Range Limits]
    AMLIML --> AutoMult["(×) Multiplicative<br/>Learned correction"]

    %% Final Output
    BasePW --> F1
    BATOFF --> F1
    Add1 --> F1

    F1 --> F2
    PWADD --> F2
    Add2 --> F2

    F2 --> F3
    PEFTBL --> F3
    Mult1 --> F3

    F3 --> F4
    AIRTMP --> F4
    Mult2 --> F4

    F4 --> F5
    ColdEnrich --> F5
    Mult3 --> F5

    F5 --> F6
    POSSLP --> F6
    Add3 --> F6

    F6 --> F7
    AESLOP --> F7
    Add4 --> F7

    F7 --> F8
    LOTHR --> F8
    Mult4 --> F8

    F8 --> F9
    DECEL --> F9
    Mult5 --> F9

    F9 --> F10
    O2CNTR --> F10
    O2Mult --> F10

    F10 --> F11
    AutoCalCell --> F11
    AutoMult --> F11

    F11 --> FinalPW[FINAL PULSEWIDTH<br/>µSeconds]
    FinalPW -->|Clamp to 24.576ms| Injectors
```

---

## Cold Enrichment Formula Detail

```mermaid
flowchart LR
    subgraph Cold_Enrichment["Cold Enrichment Calculation"]
        CURVEA["CURVEA<br/>(temp-based)"]
        CURVEC["CURVEC<br/>(temp-based)"]
        CURVEB["CURVEB<br/>(temp-based)"]
        FCRCVB["FCRCVB<br/>(RPM-based)"]
        ADVDCY["ADVDCY<br/>(AIS duty cycle)"]
        BAROCP["BAROCP<br/>(barometric)"]

        A1["CURVEA × ADVDCY"]
        B1["CURVEC × ADVDCY"]
        C1["CURVEB × FCRCVB"]

        Sum1["(A + B + C) / 256"]
        Sum2["Sum1 / 32"]
        Sum3["Sum2 × BAROCP"]
        Final["1 + Sum3"]
    end

    CURVEA --> A1
    CURVEC --> B1
    CURVEB --> C1
    ADVDCY --> A1
    ADVDCY --> B1
    FCRCVB --> C1

    A1 --> Sum1
    B1 --> Sum1
    C1 --> Sum1

    Sum1 --> Sum2
    Sum2 --> Sum3
    BAROCP --> Sum3
    Sum3 --> Final
```

**Formula**: `ColdEnrichmentFactor = 1 + (((CURVEA × ADVDCY + CURVEC × ADVDCY + CURVEB × FCRCVB) / 256) / 32) × BAROCP / 256`

---

## Transient Enrichment (Pumpshot) Flow

```mermaid
flowchart TD
    subgraph TPS_Pumpshot["TPS-Based Pumpshot"]
        TPS[TPS Sensor] --> AvgTPS[Filtered TPS<br/>Time Constant: THRTCN]
        AvgTPS --> DeltaTPS["ΔTPS = TPS - AvgTPS"]

        DeltaTPS --> Threshold{ΔTPS > POSTRG?}
        Threshold -->|No| NoPump[No Pumpshot]
        Threshold -->|Yes| CheckMax{ΔTPS > THRMAX?}
        CheckMax -->|Yes| UseMax["Use THRMAX"]
        CheckMax -->|No| GetTemp
        UseMax --> GetTemp[Get Coolant Temp]

        GetTemp --> POSSLP[POSSLP_DeltaTPSEnrichment<br/>0x0985]
        POSSLP --> Calculate["PumpShot = ΔTPS × POSSLP[temp]"]
        Calculate --> DecayTPS[Decay via THRTCN<br/>Time Constant]
    end

    subgraph MAP_Pumpshot["MAP-Based Pumpshot"]
        MAP[MAP Sensor] --> AvgMAP[Filtered MAP<br/>Time Constant: AETIME]
        AvgMAP --> DeltaMAP["ΔMAP = MAP - AvgMAP"]

        DeltaMAP --> Threshold2{ΔMAP > MAPTRG?}
        Threshold2 -->|No| NoPump
        Threshold2 -->|Yes| CheckMax2{ΔMAP > MAPMAX?}
        CheckMax2 -->|Yes| UseMax2["Use MAPMAX"]
        CheckMax2 -->|No| GetTemp2
        UseMax2 --> GetTemp2[Get Coolant Temp]

        GetTemp2 --> AESLOP[AESLOP_DeltaMAPEnrichment<br/>0x09B2]
        AESLOP --> Calculate2["PumpShot = ΔMAP × AESLOP[temp]"]
        Calculate2 --> DecayMAP[Decay via AETIME<br/>Time Constant]
    end
```

---

## O2 Closed-Loop Flow

```mermaid
flowchart TD
    subgraph O2_System["O2 Closed-Loop Control"]
        O2[O2 Sensor] --> O2Status{O2 Switching?}
        O2Status -->|No Toggle Too Long| Fault51[Set Fault 51/52]
        O2Status -->|Yes| O2Ramp{Which Ramp?}

        O2Ramp -->|Primary| PRIRMP["PRIRMP_PrimaryRamp<br/>9 cells + idle"]
        O2Ramp -->|Secondary| SECRMP["SECRMP_SecondaryRamp<br/>9 cells + idle"]

        PRIRMP --> RichRich["Rich Kick<br/>Fuel = Current × (1 + K/512)"]
        PRIRMP --> RichLean["Lean Kick<br/>Fuel = Current × (1 - K/512)"]

        SECRMP --> RichRich2["Rich Kick<br/>Fuel = Current × (1 + K/512)"]
        SECRMP --> RichLean2["Lean Kick<br/>Fuel = Current × (1 - K/512)"]

        RichRich --> O2Limit[O2LIMH/O2LIML<br/>Range Limits]
        RichLean --> O2Limit
        RichRich2 --> O2Limit
        RichLean2 --> O2Limit

        O2Limit --> KickCount{Kick Count > Limit?}
        KickCount -->|Yes| UpdateCell[Update AutoCal Cell<br/>Secondary Ramp Only]
        KickCount -->|No| Continue[Continue Kicking]
    end

    subgraph AutoCal["Adaptive Memory"]
        Cell[Current Cell<br/>Based on RPM/MAP] --> UpdateCell
        UpdateCell --> AMLIM[AMLIMH/AMLIML<br/>±25% Range]
        AMLIM --> LearnFactor[Learned Multiplier]
        LearnFactor --> FinalMult[Applied to Fuel]
    end
```

**AutoCal Cell Layout**:
```
          MAP
    ┌───┬───┬───┬───┬───┬───┐
    │ 1 │ 3 │ 5 │ 7 │ 9 │11 │
R1  ├───┼───┼───┼───┼───┼───┤
    │ 0 │ 2 │ 4 │ 6 │ 8 │10 │
    └───┴───┴───┴───┴───┴───┘
       MP1  MP2  MP3  MP4  MP5

Cell 12 = Idle only (closed throttle)
```

---

## Table Relationships Summary

| Stage | Tables | Effect |
|-------|--------|--------|
| **Base** | WOTTBL, MAPTBL | Primary pulsewidth lookup |
| **Additive** | BATOFF, PWADD | Add fixed µS |
| **Multiplicative** | PEFTBL, AIRTMP | Scale by percentage |
| **Cold Enrich** | CURVEA/B/C, FCRCVB, BAROCP | Temperature/altitude compensation |
| **Pumpshot** | POSSLP, AESLOP, THRTCN, AETIME | Transient enrichment |
| **Decel** | LOTTHR, DECEL, LOTIME, LMAPTC | Leanout during deceleration |
| **O2 Feedback** | PRIRMP, SECRMP, O2CNTR | Closed-loop correction |
| **Adaptive** | AutoCal cells, AMLIMH/L | Long-term learning |

---

## Calculation Order

The ECU applies modifiers in this exact order:

1. **Base pulsewidth** from WOTTBL[MAP]
2. **+ BATOFF[battery]** (additive)
3. **+ PWADD[baro]** (additive)
4. **× PEFTBL[RPM]%** (multiplicative)
5. **× AIRTMP[charge temp]** (multiplicative)
6. **× ColdEnrichment[temp]** (multiplicative)
7. **+ Pumpshot** (additive, if triggered)
8. **× DecelLeanout** (multiplicative, if triggered)
9. **× O2Feedback** (multiplicative, if in closed-loop)
10. **× AutoCal** (multiplicative, if learned)

---

## Related Documents

- [Table Reference](table-reference.md) - Complete table listing
- [Spark System Flow](spark-system-flow.md) - Spark calculation flow
- [Boost System Flow](boost-system-flow.md) - Boost control flow
- [Fuel System](../tuning/fuel-system.md) - Tuning guide
