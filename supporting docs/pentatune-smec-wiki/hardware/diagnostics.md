# DRB-II Diagnostics

Reference for the DRB-II scan tool protocol as implemented in SMEC/SBEC/Turbonator firmware. Covers actuator test mode (ATM), sensor data readout, fault code display, and the high-speed serial datalog mode added by Turbonator.

---

## Connection and Setup

The DRB-II connects to the 6-pin diagnostic connector. The ECU recognizes a serial connection and switches baud rate to match `BAUDLO_DRBBaudRateLo` (default 0x22, standard DRB baud). Firmware checks for valid DRB initialization on each main loop.

**DRB command handling:** The normal serial receive path accepts commands `0x13–0x1C`. The documented `DRBFunctionTable` itself spans `0x10–0x1C`, so `0x10–0x12` still appear in the dispatch table even though this receive path rejects them.

## ASM Implementation

The firmware entry points are `DRBIISerialCommunications_MM` and `DRBIIOuput_MM` in `T-SMEC_v19.asm`. Routines ending with `_MM` are called from the MainProgramLoop.

### Serial entry logic

`DRBIISerialCommunications_MM` starts by calling `BYTE_MODE_SERIAL_CODE_DOWNLOAD_ROUTINE`, then checks `DRBSerialMode` for `bbe_FastSerial` (`0x80`) and `bbe_ByteMode` (`0x40`). If either bit is set, it returns immediately and skips normal DRB processing.

If normal DRB mode is active, the routine masks `CPU_SerialBaudRate` with `0x37` and compares the result to `BAUDLO_DRBBaudRateLo` (`0x22`). If the baud byte does not match, it loads `0x22` into `CPU_SerialBaudRate` and returns. This is the exact point where the ECU forces the DRB baud rate.

The receive path then checks `CPU_SerialStatus`. If any of bits `0x0E` are set, framing, overrun, or noise error, the routine reads `CPU_SerialData` and returns immediately without updating DRB state.

When there is no receive error, bit `0x20` in `CPU_SerialStatus` determines whether a character was received. If no byte is ready, the routine uses `bbe_bottom` in `DRBSerialMode` as a timeout counter. The code increments the mode byte until `bbe_bottom` is set. On timeout, if either test mode bit is active, it clears `bbe_TestType3 | bbe_TestType2` and clears `DRBPointer1`, which aborts the current DRB transaction.

### Command dispatch

When a byte arrives, the routine stores it in `DRBPointer1` if no test type bits are active yet. This receive path only accepts command bytes `0x13` through `0x1C`. Values above `0x1C` return immediately. Values below `0x13` also return immediately, even though `DRBFunctionTable` still contains entries for `0x10–0x12`.

`DRBIIOuput_MM` later dispatches through `DRBFunctionTable` by subtracting `0x10` from `DRBPointer1`, doubling the result to form a word index, and jumping to the selected handler.

| Command | `DRBFunctionTable` target |
|---------|---------------------------|
| 0x10 | `OutputErrorCodes` |
| 0x11 | `OutputErrorBits` |
| 0x12 | `SetupHiSpeedDataTransfer` |
| 0x13 | `SetupATM` |
| 0x14 | `SendDiagnosticDataToSCI` |
| 0x15 | `DRB_Return` |
| 0x16 | `SendECUIDToSCI` |
| 0x17 | `ClearErrorCodes` |
| 0x18 | `DRB_Return` |
| 0x19 | `DRB_Return` |
| 0x1A | `SwitchTest` |
| 0x1B | `InitByteModeDownload` |
| 0x1C | `DRB_Return` |

### `DRBSerialToggles` byte count table

`DRBSerialToggles` supplies the bits that get ORed into `DRBSerialMode` after a valid command is received. The comments in the ASM are explicit, bits 4 and 5 indicate how many bytes the command uses.

| Command | Toggle byte | Bytes expected | Meaning |
|---------|-------------|----------------|---------|
| 0x13 | `0x20` | 2 | Command + sub-command |
| 0x14 | `0x20` | 2 | Command + sub-command |
| 0x15 | `0x30` | 3 | Command + sub-command/address byte |
| 0x16 | `0x20` | 2 | Command + sub-command |
| 0x17 | `0x00` | 1 | Command only |
| 0x18 | `0x20` | 2 | Command + sub-command |
| 0x19 | `0x20` | 2 | Command + sub-command |
| 0x1A | `0x20` | 2 | Command + sub-command |
| 0x1B | `0x00` | 1 | Command only |
| 0x1C | `0x30` | 3 | Command + offset low + offset high |

### `SetupHiSpeedDataTransfer`

`SetupHiSpeedDataTransfer` (`T-SMEC_v19.asm:3659`) sets the `bbe_FastSerial` bit in `DRBSerialMode`, clears `DRBPointer1`, then spins on `CPU_SerialStatus` bit 6 (`0x40`) waiting for the transmit buffer to empty. Once ready, it loads `BAUDHI_DRBBaudRateHi` into `CPU_SerialBaudRate` and returns via `DRB_Return`. This is the entry point for the Turbonator high-speed serial datalog mode.

### `SetupATM`

`SetupATM` (`T-SMEC_v19.asm:3670`) first checks if the engine is running (`TimerOverflowsBetweenDistPulses > 0x28`) and whether `b55_O2Enable` is set. If the engine is running **or** O2 is enabled, the routine aborts: it clears `b55_O2Enable`, zeros `DRBPointer1`, and returns via `SerialOutput1`. If the conditions pass, the sub-command from `DRBPointer2` is stored in `ATMOffset` (capped at `0x19`), the `ATMFunctionTable` is indexed, and the selected handler is jumped to. If the handler points to `ATM_Return`, the routine outputs via `SerialOutput1` instead.

### `SendDiagnosticDataToSCI`

`SendDiagnosticDataToSCI` (`T-SMEC_v19.asm:3693`) uses `DRBPointer2` as the sub-command. A value of zero returns zero immediately. Values `0x40` and above branch to `SendRealTImeDatatoSCI`. Values above `0x1A` also return zero. Sub-command `0x10` is explicitly blocked when `b4f_OffIdle` is set. All other valid sub-commands fall through to `SendMemoryLocToSCI`.

### `SendMemoryLocToSCI`

`SendMemoryLocToSCI` (`T-SMEC_v19.asm:3707`) indexes `DRBMemoryTable-1` using `DRBPointer2` as the byte offset. It reads the one-byte RAM address stored in the table entry. If the table byte is zero, it returns zero. Otherwise it reads the byte at the resolved RAM address and outputs it via `SerialOutput1a`.

### `SendRealTImeDatatoSCI`

`SendRealTImeDatatoSCI` (`T-SMEC_v19.asm:3717`) subtracts `0x40` from `DRBPointer2`, bounds-checks the result against `0x03`, indexes `RealTimeDataTable`, and performs an indexed jump to the selected handler. Values outside the `0x40–0x43` range return zero.

### `SendECUIDToSCI`

`SendECUIDToSCI` (`T-SMEC_v19.asm:3770`) loads `ENDIT1_PNPrefix` into X and reads `DRBPointer2`. If the high bit of `DRBPointer2` is set, the value is left-shifted twice before indexing. The routine reads the byte at the computed address, increments `DRBPointer2`, and checks whether the lower two bits are clear. If they are not, it outputs the byte via `SerialOutput1a` and returns. If the lower two bits are clear, it continues to a checksum calculation: it adds `0x16` to the byte, then adds the three preceding bytes from memory. It then computes a status byte from `DRBPointer2`, ORs it with `0x80`, adds it to the checksum, clears `DRBPointer1`, and outputs the final result via `SerialOutput1a`.

### `InitByteModeDownload`

`InitByteModeDownload` (`T-SMEC_v19.asm:3855`) sets the `bbe_ByteMode` bit in `DRBSerialMode`, clears `DRBPointer1`, and returns. This command bypasses normal DRB parsing and activates the byte-mode serial download path used by the Turbonator bootloader.

### `DRBMemoryTable` mapping

`SendDiagnosticDataToSCI` uses `DRBPointer2` as the sub-command. For values `0x01` through `0x1A`, it indexes `DRBMemoryTable`, reads the one-byte RAM address stored there, then returns the byte from that RAM location. Sub-command `0x10` is explicitly blocked when `b4f_OffIdle` is set.

| Sub-command | RAM address | Variable |
|-------------|-------------|----------|
| 0x01 | `0x0071` | `AmbientAirTempVolts` |
| 0x02 | `0x006C` | `O2SensorValue` |
| 0x03 | — | Unused, table byte `0x00` |
| 0x04 | — | Unused, table byte `0x00` |
| 0x05 | `0x006A` | `CoolantTemp` |
| 0x06 | `0x006E` | `RawCoolantTempVolts` |
| 0x07 | `0x0067` | `TpsVolts` |
| 0x08 | `0x0002` | `MINTHR_LowestSessionTPS` |
| 0x09 | `0x0070` | `KnockVolts` |
| 0x0A | `0x006B` | `BatteryVolts` |
| 0x0B | `0x0063` | `MapValue` |
| 0x0C | `0x0095` | `DesiredNewAisPosition` |
| 0x0D | — | Unused, table byte `0x00` |
| 0x0E | `0x008B` | `ValueFromAdaptiveMemory` |
| 0x0F | `0x000E` | `BaroPressure` |
| 0x10 | `0x005D` | `EngineRpm_HB` |
| 0x11 | `0x005D` | `EngineRpm_HB`, duplicate entry |
| 0x12 | — | Unused, table byte `0x00` |
| 0x13 | `0x0026` | `ErrorCodeUpdateKeyOnCount` |
| 0x14 | — | Unused, table byte `0x00` |
| 0x15 | `0x00A0` | `CalculatedSparkAdvance` |
| 0x16 | `0x00A2` | `Cylinder1Retard` |
| 0x17 | `0x00A1` | `Cylinder2Retard` |
| 0x18 | `0x00A3` | `Cylinder3Retard` |
| 0x19 | `0x00A4` | `Cylinder4Retard` |
| 0x1A | `0x00D8` | `BoostTarget` |

### `ATMFunctionTable` mapping

`SetupATM` accepts sub-commands up to `0x19`, stores the selection in `ATMOffset`, then indexes `ATMFunctionTable`.

| Sub-command | Handler |
|-------------|---------|
| 0x00 | `ATM_Return` |
| 0x01 | `ATM_IgnitionCoil` |
| 0x02 | `ATM_Return` |
| 0x03 | `ATM_Return` |
| 0x04 | `ATM_InjBank1` |
| 0x05 | `ATM_InjBank2` |
| 0x06 | `ATM_Return` |
| 0x07 | `ATM_AISMotorOpenClose` |
| 0x08 | `ATM_FanRelay` |
| 0x09 | `ATM_ACClutchRelay` |
| 0x0A | `ATM_ASDRelay` |
| 0x0B | `ATM_PurgeSolenoid` |
| 0x0C | `ATM_SCServoSolenoid` |
| 0x0D | `ATM_AlternatorField` |
| 0x0E | `ATM_Tachometer` |
| 0x0F | `ATM_PTUIndicator` |
| 0x10 | `ATM_EGRSolenoid` |
| 0x11 | `ATM_WGSolenoid` |
| 0x12 | `ATM_BaroSolenoid` |
| 0x13 | `ATM_Return` |
| 0x14 | `ATM_AllSolenoidsRelays` |

### `ActuatorTestMode_MM`

`ActuatorTestMode_MM` (`T-SMEC_v19.asm:3894`) is called from the main program loop. It first checks `ATMOffset`; if zero, it returns immediately via `ATM_Return`. If key-on time has reached `0x96` (150 ticks ≈ 1.65 s), it checks whether `DRBPointer1` equals `0x13`. If so, both `DRBPointer1` and `ATMOffset` are cleared, aborting the active test. Otherwise it loads `PIA1_A_Buffer`, indexes `ATMFunctionTable` via `ATMOffset`, and performs an indexed jump to the selected output handler. The individual handlers manipulate `PIA1_A_Buffer`, `PIA2_PortB_DataDirection`, `BitFlags_2d`, or timer registers to drive the corresponding actuator.

### `SwitchTestTable` mapping

| Sub-command | Handler |
|-------------|---------|
| 0x01 | `SendSwitchStateToSerial` |
| 0x02 | `SendOutputStatusToSerial` |
| 0x03 | `SendOutputStatusToSerial2` |

### `RealTimeDataTable` mapping

The Turbonator high speed logger is reached inside `SendDiagnosticDataToSCI`. When `DRBPointer2` is `0x40` or above, the code subtracts `0x40`, bounds checks the result against `0x03`, and dispatches through `RealTimeDataTable`.

| Sub-command | Handler |
|-------------|---------|
| 0x40 | `SCI_MAPVolts` |
| 0x41 | `SCI_Speed` |
| 0x42 | `SCI_O2Volts` |
| 0x43 | `EndRealTimeData` |

### Special cases

- **Reset EMR, command `0x1C`:** when the third byte is received, `DRB_SendMemLocToSCI` branches to `DRB_ResetEMR` instead of treating the bytes as a generic address. If `TimerOverflowsBetweenDistPulses` is at least `0x28`, the engine is running. In that case the routine sets `b52_DRBToggle1` if neither DRB toggle bit is already set, stores the received low byte in `DRBOffsetStored_LB`, stores `DRBPointer2` in `DRBOffsetStored_HB`, and returns status byte `0xE2`.
- **Timeout cleanup:** if no character arrives and `bbe_bottom` has counted up, the routine clears `bbe_TestType3 | bbe_TestType2` and clears `DRBPointer1`, which drops the active DRB test state.
- **High speed / byte mode bypass:** once `bbe_FastSerial` or `bbe_ByteMode` is set, normal DRB parsing no longer runs through `DRBIISerialCommunications_MM`.

### `DRB_UpdatePIA1AndCheckOuputs_MM`

`DRB_UpdatePIA1AndCheckOuputs_MM` (`T-SMEC_v19.asm:4253`) is called from the main program loop to update the PIA1 Port A data direction register and validate output states. It first checks whether the A/C clutch relay bit is set in `PIA1_A_Buffer`; if so, it verifies the actual A/C switch state via `StartupSwitchMirror2` and the `cfg_AC` configuration flag. If the fan relay is also active, a delay byte of `0x08` is loaded; otherwise the delay remains zero. If battery voltage (`BatteryVolts`) is below `0xA2`, the delay byte is forced to `0xFF`.

The routine then copies `PIA1_A_Buffer` to `PIA1_PortA_DataDirection`, disables interrupts, sets all data direction bits, waits `36 µs`, writes the delay byte, re-enables interrupts, and waits another `32 µs`. It XORs the result against `PIA1_PortA_DataDirection` to detect changed bits, then masks the delta through `PIA1AManipulation_Table` indexed by `Counter_MainLoop & 0x07`. If the masked delta is non-zero and the table index is `0x03`, additional configuration checks (`cfg_AC`, `b54_DisableNormalDwell`, `KeyOnOrEngineRunningTime`, A/C switch) determine whether the bit change is suppressed.

---

## Fault Code Display

### Ignition Key Method

1. Turn key ON–OFF–ON–OFF–ON within 5 seconds
2. Count CEL flashes — long pause separates the 10s digit from the 1s digit
3. **Code 55** = no faults stored

This method reads `ErrorCodesToDash_Table`, which maps 50 internal error bit positions (across 5 registers) to 2-digit display codes.

### DRB-II Method

Send the Read Fault Codes command. The DRB reads fault data directly from RAM and displays codes as decimal numbers. See [Fault Codes](../reference/fault-codes.md) for the complete code list.

### Clearing Fault Codes

The DRB "Erase Fault Data" function requires the **engine to be running**. This clears the RAM error registers. EEPROM-stored codes require either an ECU flash with the EEPROM region erased, or explicit EEPROM erase via the bootloader.

### `FlashCodesOutOnCEL`

`FlashCodesOutOnCEL` (`T-SMEC_v19.asm:4116`) is called on every main loop to drive the CEL flash pattern. It left-shifts `Counter_MainLoop` twice; if the result is non-zero it returns immediately. On the zero count, it reads `LastDistributorFallingEdgeTime` and toggles the CEL light via `PIA1_A_Buffer` XORed with `pia1abuf_CELight`. The routine uses `DRBPointer2` as a state sequencer: values `0x00–0x07` index the RAM error bit registers (`ErrorBitRegister0` through `ErrorBitRegister7`), values `0x08–0xFE` index the EEPROM error storage at `0xB618`, and `0xFF` triggers a key-on cycle counter display. Each active bit is mapped through `ErrorCodesToDash_Table` to a 2-digit flash code. Timing is encoded in the upper and lower nibbles of `LastDistributorFallingEdgeTime`.

---

## Actuator Test Mode (ATM)

ATM commands activate individual outputs for bench testing. Each command drives the associated output for as long as the test is active.

**DRB ATM Command Table:**

| Sub-command | Label | Output Activated |
|-------------|-------|-----------------|
| 0x00 | ATM_Return | No output (placeholder) |
| 0x01 | ATM_IgnitionCoil | Ignition coil primary driver |
| 0x02–0x03 | ATM_Return | — |
| 0x04 | ATM_InjBank1 | Injector bank A (cylinders 1 & 3) |
| 0x05 | ATM_InjBank2 | Injector bank B (cylinders 2 & 4) |
| 0x06 | ATM_Return | — |
| 0x07 | ATM_AISMotorOpenClose | AIS motor (alternates open/close) |
| 0x08 | ATM_FanRelay | Radiator fan relay |
| 0x09 | ATM_ACClutchRelay | A/C clutch relay |
| 0x0A | ATM_ASDRelay | Auto Shutdown Relay |
| 0x0B | ATM_PurgeSolenoid | EVAP canister purge solenoid |
| 0x0C | ATM_SCServoSolenoid | Speed control servo solenoid |
| 0x0D | ATM_AlternatorField | Alternator field driver |
| 0x0E | ATM_Tachometer | Tachometer output signal |
| 0x0F | ATM_PTUIndicator | Part Throttle Unlock indicator |
| 0x10 | ATM_EGRSolenoid | EGR solenoid (EGR-equipped vehicles only) |
| 0x11 | ATM_WGSolenoid | Wastegate solenoid |
| 0x12 | ATM_BaroSolenoid | Barometric read solenoid |
| 0x13 | ATM_Return | — |
| 0x14 | ATM_AllSolenoidsRelays | All solenoids and relays simultaneously |

**Notes:**
- `ATM_AISMotorOpenClose` (0x07) alternates direction on every 64th main loop counter bit
- `ATM_FanRelay` (0x08) and relay outputs toggle based on `Counter_MainLoop` bit 7 (50% duty at ~0.7 Hz)
- `ATM_ASDRelay` (0x0A) uses the same toggling pattern as the fan relay
- `ATM_WGSolenoid` (0x11) is the most useful test — verifies solenoid operation without running the engine

---

## Sensor Data Readout (DRBMemoryTable)

The DRB "SendDiagnosticDataToSCI" function reads RAM variables directly using the `DRBMemoryTable`. Sub-commands 0x01–0x1A map to specific RAM addresses.

| Sub-command | Variable | Address | DRB Label |
|-------------|---------|---------|-----------|
| 0x01 | `AmbientAirTempVolts` | 0x0071 | Ambient air temp ADC |
| 0x02 | `O2SensorValue` | 0x006C | O2 sensor value |
| 0x03–0x04 | — | — | (unused) |
| 0x05 | `CoolantTemp` | 0x006A | Coolant temp (scaled) |
| 0x06 | `RawCoolantTempVolts` | 0x006E | CTS ADC raw value |
| 0x07 | `TpsVolts` | 0x0067 | TPS voltage (ADC) |
| 0x08 | `MINTHR_LowestSessionTPS` | 0x0002 | Minimum TPS this session |
| 0x09 | `KnockVolts` | 0x0070 | Knock sensor voltage |
| 0x0A | `BatteryVolts` | 0x006B | Battery voltage (ADC scaled) |
| 0x0B | `MapValue` | 0x0063 | Current MAP value |
| 0x0C | `DesiredNewAisPosition` | 0x0095 | AIS desired position |
| 0x0D | — | — | (unused) |
| 0x0E | `ValueFromAdaptiveMemory` | 0x008B | Current adaptive cell value |
| 0x0F | `BaroPressure` | 0x000E | Baro pressure reading |
| 0x10 | `EngineRpm_HB` | 0x005D | RPM (high byte — divide by ~8 for RPM) |
| 0x11 | `EngineRpm_HB` | 0x005D | Same (duplicate entry) |
| 0x12 | — | — | (unused) |
| 0x13 | `ErrorCodeUpdateKeyOnCount` | 0x0026 | Key-on cycles since last fault |
| 0x14 | — | — | (unused) |
| 0x15 | `CalculatedSparkAdvance` | 0x00A0 | Calculated total spark advance |
| 0x16 | `Cylinder1Retard` | 0x00A2 | Cylinder 1 knock retard (active) |
| 0x17 | `Cylinder2Retard` | 0x00A1 | Cylinder 2 knock retard (active) |
| 0x18 | `Cylinder3Retard` | 0x00A3 | Cylinder 3 knock retard (active) |
| 0x19 | `Cylinder4Retard` | 0x00A4 | Cylinder 4 knock retard (active) |
| 0x1A | `BoostTarget` | 0x00D8 | Current MAP boost target (absolute) |

Sub-commands 0x16–0x19 (per-cylinder retard) are the primary diagnostic tool for knock detection without a wideband sensor — non-zero values indicate active knock retard on that cylinder.

---

## Switch State and Output Status

Three additional sub-commands read switch and output states:

| Sub-command | Function |
|-------------|---------|
| 0x01 (SwitchTestTable) | `SendSwitchStateToSerial` — switch port bits |
| 0x02 | `SendOutputStatusToSerial` — primary output state word |
| 0x03 | `SendOutputStatusToSerial2` — secondary output state word |

---

## Real-Time High-Speed Data (Turbonator Addition)

Turbonator firmware adds a high-speed serial datalog mode accessible via sub-commands 0x40–0x42. These output data faster than the standard DRB protocol, suitable for logging on a laptop.

| Sub-command | Function | Variable |
|-------------|---------|---------|
| 0x40 | `SCI_MAPVolts` | MAP sensor ADC value |
| 0x41 | `SCI_Speed` | Vehicle speed |
| 0x42 | `SCI_O2Volts` | O2 sensor ADC value |
| 0x43 | `EndRealTimeData` | End-of-data marker |

This fast serial logger path is entered through `SetupHiSpeedDataTransfer`, which sets `bbe_FastSerial` and switches `CPU_SerialBaudRate` to `BAUDHI_DRBBaudRateHi`. `BYTE_MODE_SERIAL_CODE_DOWNLOAD_ROUTINE` and `InitByteModeDownload` own the separate byte-mode bootloader path. A laptop running compatible software can capture this data at higher resolution than the standard DRB protocol supports.

---

## Minimum Throttle Setting Procedure

The DRB command 0x14 with sub-command 0x10 puts the ECU into minimum throttle setting mode:
- Spark scatter is disabled (see [Ignition Timing](../tuning/ignition-timing.md#spark-scatter-idle-stability-control))
- Fixed advance constant `IDLSET` (0x0C) is used
- This prevents the idle stabilizer from interfering while the technician adjusts the idle stop screw

Exit by sending any other command or cycling the key.

---

## Practical Test Procedure

### Verify Wastegate Solenoid

1. Connect DRB-II or compatible scanner
2. Enter ATM mode
3. Send ATM sub-command 0x11 (`ATM_WGSolenoid`)
4. Listen for solenoid click; apply 12V directly and compare
5. Check vacuum routing to wastegate actuator with solenoid energized

### Verify Injectors

1. ATM sub-command 0x04 (`ATM_InjBank1`) — listen for bank A pulse
2. ATM sub-command 0x05 (`ATM_InjBank2`) — listen for bank B pulse
3. Quiet or absent click indicates wiring or injector failure

### Check Knock Retard

1. Use sensor data sub-commands 0x16–0x19
2. Monitor per-cylinder retard while driving under load
3. Persistent non-zero values after deceleration indicate lingering knock retard or a stuck sensor

---

## See Also

- [Fault Codes](../reference/fault-codes.md) — Complete fault code list and clearing procedures
- [Sensors and Inputs](../ecu-fundamentals/sensors.md) — Sensor hardware and ADC ranges
- [Ignition Timing](../tuning/ignition-timing.md) — Per-cylinder knock retard details
- [Adaptive Systems](../tuning/adaptive-systems.md) — Adaptive memory and O2 feedback
- [Charging System](charging-system.md) — Alternator field control and charging-specific verification that stay outside the DRB helper owner page
- [ASM-to-Calibration Mapping Reference](../reference/asm-cal-mapping.md) — Cross-reference for DRB helper routines, dispatch tables, and service-path RAM usage
