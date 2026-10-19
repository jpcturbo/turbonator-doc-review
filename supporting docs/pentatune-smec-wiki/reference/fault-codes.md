# Fault Codes Reference

Complete reference for all fault codes stored and displayed by SMEC/SBEC/Turbonator ECUs.

## How Fault Codes Work

### Storage

The ECU stores fault codes as **error bits** in a set of registers in RAM, mirrored to EEPROM for persistence across key cycles. Each bit corresponds to a specific fault. The `ErrorCodesToDash_Table` in the firmware maps 50 internal error bit positions to 2-digit display codes.

### Displaying Codes

**Ignition key method:**
1. Turn key ON–OFF–ON–OFF–ON (within 5 seconds)
2. Count CEL flashes — long pause separates 10s digit from 1s digit
3. Code 55 = no faults stored

**DRB-II scanner:** Connect to diagnostic connector; scanner displays codes directly.

### Clearing Codes

- **Battery disconnect** — clears some volatile codes but not EEPROM-stored ones
- **DRB-II** — use "Erase Fault Data" function (requires engine running)
- **Flash ECU** — write new ROM; EEPROM region (0xB600–0xB7FF) must be erased separately

---

## Complete Fault Code List

| Code | System | Description | Conditions | Notes |
|------|--------|-------------|------------|-------|
| **11** | Distributor | No distributor signal received | Cranking, no signal detected | May also set if battery disconnected recently |
| **12** | Battery | Battery disconnected in last 50 key cycles | Memory lost | Clears after 50 key-on cycles without recurrence |
| **13** | MAP Sensor | MAP sensor vacuum circuit | Signal below 1.5V at idle | Vacuum line leak or sensor failure |
| **14** | MAP Sensor | MAP sensor voltage out of range | Signal too high or stuck | Sensor open/short or vacuum block |
| **15** | Speed Sensor | No vehicle speed signal | Vehicle moving, no pulses | Broken gear, damaged tone ring |
| **17** | Coolant Temp | Engine running too cool | Below 180°F after warmup time | Thermostat stuck open |
| **21** | O2 Sensor | O2 sensor signal circuit | No signal, or stuck in middle band for >1.3s | Check wiring, sensor age |
| **22** | Coolant Temp | Coolant temp sensor signal circuit | ADC outside valid range (0x1A–0xFD) | Sensor open/short |
| **23** | Charge Temp | Charge air temp sensor circuit | ADC < 0x08 or > 0xFD | Sensor open/short |
| **24** | TPS | Throttle position sensor circuit | Signal below minimum or above maximum | Sensor, wiring, or adjustment |
| **25** | AIS | AIS motor driver circuit | Driver output not responding | Motor open circuit or driver failure |
| **27** | Injectors | Injector control circuit | Pulse <0.75ms detected at driver | Open injector or wiring |
| **31** | Purge | Evaporative purge solenoid circuit | — | EVAP solenoid wiring |
| **32** | EGR | EGR solenoid circuit (if equipped) | — | EGR-equipped vehicles only |
| **33** | A/C | A/C clutch relay circuit | — | A/C-equipped vehicles only |
| **34** | Cruise | Speed control servo solenoid circuit | — | Cruise-equipped vehicles only |
| **35** | Fan | Radiator fan relay circuit | Driver sense bit not responding | Fan relay wiring or relay |
| **36** | Boost | Wastegate solenoid circuit | — | Turbo models only |
| **37** | Trans | Torque converter clutch solenoid | — | ATX-equipped vehicles only |
| **41** | Charging | Generator (alternator) field not switching | — | Charging system fault |
| **42** | ASD | Auto Shutdown Relay circuit | — | ASD wiring or relay |
| **43** | Ignition | Ignition coil #1 primary circuit | Driver sense bit not responding | Coil or wiring |
| **44** | Battery Temp | Battery temperature sensor circuit | — | Ambient temp sensor |
| **45** | Boost | MAP sensor exceeds boost limit | MAP > overboost threshold | Overboost condition; check wastegate |
| **46** | Charging | Battery voltage too high | >16V for extended period | Voltage regulator failure |
| **47** | Charging | Battery voltage too low | <6.5V for >21s, engine running | Charging system, battery, or wiring |
| **51** | O2 Sensor | O2 sensor stays lean | No toggle to rich for >LTHTIM (0x2B loops) | Lean fuel, vacuum leak, weak injector, O2 sensor |
| **52** | O2 Sensor | O2 sensor stays rich | No toggle to lean for >LTHTIM loops | Rich fuel, leaking injector, O2 sensor |
| **53** | ECU | Internal controller failure | ROM checksum mismatch or processor fault | ECU failure |
| **54** | Distributor | Distributor sync pickup signal | Sync blade not detected | Distributor or pickup sensor |
| **55** | — | End of codes | Displayed last — no faults stored | Normal condition |

---

## Turbonator-Specific Behavior

### Code 51/52 — O2 Fault Mechanism

The Turbonator firmware uses a **two-strike system** before setting codes 51/52:

1. **First no-toggle:** Increments `BadO2Read` counter (internal warning, no code set)
2. **Second no-toggle:** Sets fault code 0x0381 (lean) or 0x0382 (rich), clears all 15 adaptive memory cells

The timeout is controlled by `LTHTIM_IfNoO2SwitchForThisTimeThrowFault51or52` (default 0x2B ≈ 480ms at 11ms loop rate).

### CEL Flash on Knock (opt_FlashCE)

When the `opt_FlashCE` option flag is enabled, the ECU flashes the CEL when knock retard is active on any cylinder. This is a **Turbonator addition** — stock firmware only flashes codes on request. The flash pattern is different from a fault code display; it occurs continuously while knock is detected.

### Code 45 — Overboost

Two separate MAP thresholds:
- **Absolute threshold** (`MPSHFA`): Triggers immediately when MAP exceeds this value
- **Timer-based threshold** (`MPSHFT`): Triggers when MAP exceeds a lower threshold for longer than `TRNTM_OverboostFuelShutoffDelay` loops

Both cut fuel immediately. Timer default is 0xFF (disabled by default in Turbonator).

---

## Error Register Structure

Internally, faults are tracked as individual bits across four 8-bit registers in RAM. Each bit corresponds to a specific fault code. The registers are mirrored to EEPROM for persistence across key cycles.

### ErrorBitRegister0 (RAM 0x001E)

| Bit | Mask | Name | Fault Code | Description |
|-----|------|------|------------|-------------|
| 7 | $80 | `b1e_errLostFJ2` | 44 | Loss of FJ2 (Battery Temp Sensor) |
| 6 | $40 | `b1e_errNothing` | 45 | Nothing (Overboost) |
| 5 | $20 | `b1e_errHighVoltage` | 46 | Battery Volts High |
| 4 | $10 | `b1e_errLowVoltage` | 47 | Battery Volts Low |
| 3 | $08 | `b1e_errStuckLean` | 51 | Lean condition |
| 2 | $04 | `b1e_errStuckRich` | 52 | Rich Condition |
| 1 | $02 | `b1e_errChecksum` | 53 | Prom Checksum |
| 0 | $01 | `b1e_errDistSync` | 54 | Distributor Sync |

### ErrorBitRegister1 (RAM 0x001F)

| Bit | Mask | Name | Fault Code | Description |
|-----|------|------|------------|-------------|
| 7 | $80 | `b1f_errAcCutoutRelay` | 33 | AC Cutout Relay |
| 6 | $40 | `b1f_errSpeedCtlSolenoid` | 34 | Speed Ctl Solenoid |
| 5 | $20 | `b1f_errRadFanRelay` | 35 | Radiator Fan Relay |
| 4 | $10 | `b1f_errWastegateSolenoid` | 36 | Wastegate Solenoid |
| 3 | $08 | `b1f_errBaroReadSolenoid` | 37 | Barometric Read Solenoid |
| 2 | $04 | `b1f_errChargingSystem` | 41 | Charging System |
| 1 | $02 | `b1f_errASDRelay` | 42 | Auto Shutdown Relay |
| 0 | $01 | `b1f_errIgnitionCoil` | 43 | Ignition Coil Control |

### ErrorBitRegister2 (RAM 0x0020)

| Bit | Mask | Name | Fault Code | Description |
|-----|------|------|------------|-------------|
| 7 | $80 | `b20_errCoolantTempSensor` | 22 | Coolant Temp Sensor |
| 6 | $40 | `b20_errChargeTempSensor` | 23 | Charge Temp Sensor |
| 5 | $20 | `b20_errTPS` | 24 | Throttle Position |
| 4 | $10 | `b20_errAIS` | 25 | AIS Motor |
| 3 | $08 | `b20_errInjectorCurrent` | 26 | Injector Current Limit Not Achieved |
| 2 | $04 | `b20_errInjectorDriver` | 27 | Injector Driver interface |
| 1 | $02 | `b20_errPurgeSolenoid` | 31 | Purge Solenoid |
| 0 | $01 | `b20_errEGR` | 32 | Exh Gas Recirc Solenoid |

### ErrorBitRegister3 (RAM 0x0021)

| Bit | Mask | Name | Fault Code | Description |
|-----|------|------|------------|-------------|
| 7 | $80 | `b21_errNotCranked` | 11 | Engine Not Cranked Since Battery Disconnected |
| 6 | $40 | `b21_errMemPowerLost` | 12 | Memory Standby Power Lost |
| 5 | $20 | `b21_errMapPneumatic` | 13 | MAP Pneumatic |
| 4 | $10 | `b21_errMapElectrical` | 14 | MAP Electrical |
| 3 | $08 | `b21_errDistanceSensor` | 15 | Vehicle Distance Sensor |
| 2 | $04 | `b21_errBattVoltageSense` | 16 | Battery Voltage Sense |
| 1 | $02 | `b21_errEngineTooCool` | 17 | Engine Running Too Cool |
| 0 | $01 | `b21_errO2Sensor` | 21 | Oxygen Sensor |

### Stored Error Registers (EEPROM Mirrors)

Four additional registers at RAM addresses `0x0022`–`0x0025` mirror the above registers for persistence across key cycles. These "stored" registers are copied to/from EEPROM and retain fault history even when the battery is disconnected.

| Stored Register | RAM Address | Mirrors |
|-----------------|-------------|---------|
| StoredErrorBitRegister0 | 0x0022 | ErrorBitRegister0 (0x001E) |
| StoredErrorBitRegister1 | 0x0023 | ErrorBitRegister1 (0x001F) |
| StoredErrorBitRegister2 | 0x0024 | ErrorBitRegister2 (0x0020) |
| StoredErrorBitRegister3 | 0x0025 | ErrorBitRegister3 (0x0021) |

The `ErrorCodesToDash_Table` in the firmware maps the 50 bit positions (0–49) to their 2-digit display codes. This is why fault codes are displayed as decimal numbers even though internally they are stored as individual bits.

---

## Sensor-Specific Diagnostic Details

### MAP Sensor (Codes 13, 14, 45)

The ECU validates MAP sensor operation continuously:
- **Stuck sensor detection**: If MAP changes by less than a threshold over time, code 13 or 14 is set. Recovery requires a measurable delta within 1 second after conditions are met.
- **Out-of-range**: Upper and lower ADC limits specific to current baro reading and RPM.
- **Overboost**: MAP − BaroPressure compared to thresholds from calibration constants.

### Coolant Temp Sensor (Code 22)

Valid ADC range: 0x1A to 0xFD (set by `TMPLOW` and `TMPHIG` constants).

If CTS fails, the ECU substitutes:
1. Charge air temperature (if charge temp sensor is valid and `cfg_CTS` flag set)
2. Default limp-in value of `DEFTMP` (≈149°F) if no substitute available

### O2 Sensor (Codes 21, 51, 52)

Three-level signal validation:
- **Immediately valid**: ADC < 0x0F (lean) or ADC > 0x26 (rich) → immediate closed-loop entry
- **Delayed valid**: ADC in 0x0F–0x1F range → enters closed-loop after `O2TIME` (0x07) loops
- **Invalid middle**: ADC in 0x0F–0x1F but timer not expired → open-loop, resets AM timer

Code 21 is set when the O2 signal stays in the middle band (0x12–0x1C) for more than 1.3 seconds continuously, indicating the sensor is stuck at stoichiometric (typically a dead or contaminated sensor).

---

## See Also

- [Sensors and Inputs](../ecu-fundamentals/sensors.md) — Sensor hardware and calibration
- [Adaptive Systems](../tuning/adaptive-systems.md) — How O2 feedback and adaptive memory work
- [DRB-II Diagnostics](../hardware/diagnostics.md) — Scanner protocol and actuator tests
- [Ignition Timing](../tuning/ignition-timing.md) — Knock sensor and retard system
