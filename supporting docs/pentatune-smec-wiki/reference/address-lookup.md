# Address Lookup

Common calibration addresses for 1989 Turbo I SMEC. Other calibrations may vary.

## Important Notes

1. **Addresses shown are CPU addresses** (0x8000-0xFFFF range)
2. **To get file offset:** Subtract 0x8000 from address
3. **Different firmware versions may have different addresses**
4. **Always verify with your specific .tpl or .mpt file**

---

## Fuel Tables

### Main Fuel Tables

| Address | Name | Description |
|---------|------|-------------|
| 0x81BA | N/T Fuel | No-throttle (idle/coast) fuel table |
| 0x81E8 | P/T Fuel | Part-throttle fuel table |
| 0x8220 | F/T Fuel | Full-throttle (WOT) fuel table |

### Pumping Efficiency

| Address | Name | Description |
|---------|------|-------------|
| 0x8322 | PumpEff | Volumetric efficiency vs RPM |

### Fuel Enrichment

| Address | Name | Description |
|---------|------|-------------|
| 0x8248 | FuelEnrichA | Enrichment A vs coolant temp |
| 0x8263 | FuelEnrichB | Enrichment B vs coolant temp |
| 0x8286 | FuelEnrichC | Enrichment C vs coolant temp |
| 0x8290 | RPM Compensation | RPM-based compensation |

### Cold Load Factors

| Address | Name | Description |
|---------|------|-------------|
| 0x82B7 | ColdLoad N/T CTS | No-throttle vs coolant temp |
| 0x82CA | ColdLoad N/T MAP | No-throttle vs MAP |
| 0x82E1 | ColdLoad P/T CTS | Part-throttle vs coolant temp |
| 0x82F4 | ColdLoad P/T MAP | Part-throttle vs MAP |

### Phase-Out Constants

| Address | Name | Description |
|---------|------|-------------|
| 0x82B0 | Phase-out 0 | Enrichment phase-out constant |
| 0x82B1 | Phase-out 1 | Enrichment phase-out constant |
| 0x82B2 | Phase-out 2 | Enrichment phase-out constant |
| 0x82B3 | Phase-out 3 | Enrichment phase-out constant |
| 0x82B5 | Phase-out 5 | Enrichment phase-out constant |
| 0x82B6 | Phase-out 6 | Enrichment phase-out constant |

### Temperature Compensation

| Address | Name | Description |
|---------|------|-------------|
| 0x830B | Baro Compensation | Barometric pressure compensation |
| 0x8349 | Charge Temp Comp | Intake air temp compensation |

---

## Timing Tables

### Advance Tables

| Address | Name | Description |
|---------|------|-------------|
| 0x8010 | Cold MAP Advance | MAP advance when cold |
| 0x8024 | P/T Warm Advance | Part-throttle warm advance |
| 0x805B | WOT Warm Advance | WOT warm MAP advance |
| 0x8085 | Advance Comparison | Comparison/minimum table |
| 0x8090 | CTS Advance | Advance from coolant temp |
| 0x8098 | RPM Advance | Advance from RPM |

### Timing Limits

| Address | Name | Description |
|---------|------|-------------|
| 0x80B3 | Max Advance | Maximum advance by RPM |
| 0x8023 | Cold Advance Limit | Max 15° cold advance constant |
| 0x8097 | RPM Threshold | 4016 RPM threshold constant |
| 0x811F | MAP Threshold | 0.8 psi vacuum threshold |
| 0x80BE | Min Advance | Minimum 10° advance constant |

### Knock Control

| Address | Name | Description |
|---------|------|-------------|
| 0x806E | WOT Multiplier | MultiplierOnMAPAdvanceWhenRetarding |
| 0x80E9 | Knock Retard RPM | Long-term knock retard vs RPM |
| 0x8104 | Knock Retard MAP | Long-term knock retard vs MAP |

### Timing Constants

| Address | Name | Description |
|---------|------|-------------|
| 0x8043 | Warm Temp Threshold | 122°F threshold constant |
| 0x8429 | Limp Mode Timing | Fixed 6° limp-in timing |

---

## Starting Fuel

| Address | Name | Description |
|---------|------|-------------|
| 0x8157 | Start Fuel CTS | Starting fuel vs coolant temp |
| 0x817E | Start Fuel Const | No-throttle constant |
| 0x817F | Start Fuel EPP | Starting fuel vs EPP |
| 0x818A | Start Fuel Mod | CTS modifier for starting |
| 0x8191 | Start Fuel Baro | Baro compensation for starting |
| 0x819C | Start PW Reducer | PW reducer vs coolant temp |

---

## Accelerator Pump (Pumpshot)

| Address | Name | Description |
|---------|------|-------------|
| - | AETIME | MAP averaging time constant |
| - | MAPTRG | MAP pumpshot threshold |
| - | MAPMAX | Maximum DeltaMAP |
| - | AESLOP | MAP pumpshot multiplier vs CTS |
| - | THRTCN | TPS averaging time constant |
| - | POSTRG | TPS pumpshot threshold |
| - | THRMAX | Maximum DeltaTPS |
| - | POSSLP | TPS pumpshot multiplier vs CTS |

---

## Boost Control

| Address | Name | Description |
|---------|------|-------------|
| - | AllowedBoostPartThrottle | Boost target vs TPS |
| - | OverboostFuelShutoff | Overboost protection thresholds |

---

## Adaptive Memory Control

| Address | Name | Description |
|---------|------|-------------|
| - | NoCellUpdateAboveThisMAP | MAP threshold for cell updates |
| - | NoCellUpdateAboveThisRPM | RPM threshold for cell updates |
| - | AdaptiveRetard_MinMAPForAdjustment | Knock adapt MAP threshold |
| - | StopAdaptiveWGWhenMapIsThisCloseToBoostTarget | WG adapt threshold |

---

## RAM Variables (Runtime)

These are runtime variables in RAM, not calibration data:

| Address | Name | Description |
|---------|------|-------------|
| 0x004F | Status Flags | Throttle/WOT flags |
| 0x0050 | Status Flags 2 | Engine running flags |
| 0x005A | Fuel Modifier | Calculated fuel modifier |
| 0x005B | Injector PW | Current injector pulsewidth |
| 0x0073 | Enrichment Countdown | Phase-out countdown |
| 0x0076 | Start Time Reduction | Starting fuel reduction |
| 0x0077 | IncreaseFuelMixVar | Fuel increase variable |
| 0x0078 | FuelLeaningMAPDecVar | MAP decay variable |
| 0x0079 | FuelLeaningThrtDecVar | Throttle decay variable |
| 0x007B | AccelPumpPW | Accelerator pump pulsewidth |
| 0x007D | O2FeedbackCt | O2 feedback counter |
| 0x008B | AdaptiveMemValue | Current adaptive value |
| 0x008F | IdleErrorPW | Idle error pulsewidth |
| 0x0091 | FuelEnrichNoThrotVar | No-throttle enrich variable |
| 0x00B1 | O2FeedbackDir | O2 feedback direction flag |
| 0x00C4 | TempVar5 | Running pulsewidth temp |
| 0x00D9 | BaseFuelModifier | Base fuel modifier |

---

## Code Entry Points

| Address | Name | Description |
|---------|------|-------------|
| 0xA805 | Starting Fuel Calc | Starting fuel calculation routine |
| 0xA870 | Start Time Reduction | Time reduction calculation |
| 0xA9FE | Idle Error Calc | Idle error PW calculation |
| 0xAAF3 | Fuel Modifier Calc | Main fuel modifier routine |
| 0xAB1E | Phase-out Setup A | Phase-out routine entry A |
| 0xAB24 | Phase-out Setup B | Phase-out routine entry B |
| 0xAB33 | Enrichment Lookup | FuelEnrichment A/C lookup |
| 0xAB69 | Enrichment B Lookup | FuelEnrichment B lookup |
| 0xABC1 | Baro/Charge Comp | Baro and charge temp comp |
| 0xAC3D | O2/PumpEff | O2 trim and PumpEff application |
| 0xAC60 | Coolant Temp Calc | Coolant temp with fudging |
| 0xAD3F | Accel Pump Calc | Accelerator pump calculation |
| 0xC44D | Scaling Routine | General scaling subroutine |

---

## Memory Regions

| Address Range | Description |
|---------------|-------------|
| 0x8000-0x8FFF | Calibration data (tables, constants) |
| 0x9000-0xB5FF | Executable code |
| 0xB600-0xB7FF | EEPROM (adaptive memory) - DO NOT FLASH |
| 0xB800-0xFFD5 | More executable code |
| 0xFFD6-0xFFFF | Interrupt vectors |
