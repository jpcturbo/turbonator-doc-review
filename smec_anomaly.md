# SMEC (`T-SMEC_v19.asm`) Calibration & Firmware Anomaly Log

**Generated:** 2026-10-18  
**Firmware Source:** [T-SMEC_v19.asm](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_v19.asm)  
**Primary Stock Template:** [T-SMEC_25_ATX_A283_Stock.tpl](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_25_ATX_A283_Stock.tpl)  
**Secondary Stage IV Template:** [T-SMEC_22_ATX_S-IV.tpl](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_22_ATX_S-IV.tpl)

---

## 1. Template-to-Firmware Bug: `T2MAPPT2` Unreferenced Due to `MAPPT2` Copy-Paste in `CalcWGDutyCycleT2`

* **Identifier:** `T2MAPPT2` (`T2MAPPT2_WastegateDutyCycleMapSwitchPoint2`, `;mptbladdr 0x133D` in [T-SMEC_25_ATX_A283_Stock.tpl](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_25_ATX_A283_Stock.tpl#L5043-L5054))
* **Routine:** [`CalcWGDutyCycleT2`](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_v19.asm#L9755-L9766)
* **Issue:** When the T2-style wastegate control routine (`CalcWGDutyCycleT2`) was adapted from the T1 routine (`CalcWGDutyCycleT1`), dedicated `T2*` tables/constants were created in the `.tpl` file (`T2MAPPT`, `T2MAPPT2`, `T2KNOKMP`, `T2RPMBST`, `T2RATLIM`, `T2PRTMAX`, `T2MPDEL`, `T2RESFAC`, etc.). While line 9926 was updated to `addb T2MAPPT_WastegateDutyCycleMapSwitchPoint`, **line 9764** still references the T1 symbol `MAPPT2_WastegateDutyCycleMapSwitchPoint2`:
  ```assembly
  ; --- CalcWGDutyCycleT2 (T-SMEC_v19.asm:9755-9765) ---
  CalcWGDutyCycleT2:
  	brset *BitFlags_54, #b54_FuelEngineNotRunning, T2WGDC_ClearWGDutyCycleVars
          ldaa BoostTarget
          staa Temp3

          ldab Counter_MainLoop
          ldaa MapValue
          suba BaroPressure
          bcs  T2WGDC_ClearWGDutyCycleVars
          cmpa MAPPT2_WastegateDutyCycleMapSwitchPoint2    ; <-- BUG: Should be T2MAPPT2_WastegateDutyCycleMapSwitchPoint2
          bcc  L7739
  ```
* **Impact for Tuners:** Editing `T2MAPPT2` in MPTune has no effect unless line 9764 of `T-SMEC_v19.asm` is updated to `cmpa T2MAPPT2_WastegateDutyCycleMapSwitchPoint2`. In stock v19 code, `CalcWGDutyCycleT2` reads `MAPPT2` (`T1_WGDC_Adaptives\`) as its minimum boost activation threshold.
* **Shared T1/T2 Adaptive Constants:** Additionally, `CalcWGDutyCycleT2` ([lines 9936–10003](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_v19.asm#L9936-L10003)) shares `DCRPM1`, `DCRPM2`, `DCRPM3`, `DCRPML`, `DCRPMH`, `INCLIM`, `DECLIM`, `MPDEL2`, and `DECPT` with `CalcWGDutyCycleT1` rather than having separate `T2*` copies.

---

## 2. 16-Bit Split Constant Misnomer: `EGR6` + `EGR15A` (`0x016C`)

* **Identifiers:**
  * `EGR6` (`EGR6_ExhGasRecircConst`, `.byte 0x01` at `;.org 0x882E`, [T-SMEC_25_ATX_A283_Stock.tpl:7241-7251](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_25_ATX_A283_Stock.tpl#L7241-L7251))
  * `EGR15A` (`EGR15a_ExhGasRecircConstFromRPMHiLimit`, `.byte 0x6C` at `;.org 0x8830`, [T-SMEC_25_ATX_A283_Stock.tpl:7253-7263](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_25_ATX_A283_Stock.tpl#L7253-L7263))
* **Routine:** [`ExhGasRecirc_MM`](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_v19.asm#L5485-L5488)
* **Issue:** In the `.tpl` file, `EGR6` and `EGR15A` are defined as two separate 8-bit (`Type 3`) constants, and `EGR15A` is named as if it were an RPM high limit (`ExhGasRecircConstFromRPMHiLimit`). However, in `T-SMEC_v19.asm` at line 5485, the CPU executes a **16-bit index register comparison** (`cpx`) against `EGR6_ExhGasRecircConst`:
  ```assembly
  ; --- ExhGasRecirc_MM (T-SMEC_v19.asm:5485-5488) ---
  L1467:	cpx  EGR6_ExhGasRecircConst	;  (data is 016c)
  	bcc  L1470	    ; branch if greater or equal
  L1468:	inx		    ; increment index (x=x+1)
  	stx  EGRVar3    ; store index into memory
  ```
* **Impact for Tuners:** `EGR6` (`0x01`) is the high byte and `EGR15A` (`0x6C`) is the low byte of the 16-bit diagnostic timer threshold `0x016C` (`364` loop counts) for `EGRVar3`. Meanwhile, the actual RPM window high limit for `EGR15` (`EGR15_ExhGasRecircConstFromRPMLoLimit`) is `EGR15B` (`EGR15b_ExhGasRecircConstFromRPMLoLimit`), which immediately follows `EGR15` and is checked via `cmpa 0x01,x` in `EGR_CheckHiLoLimits`.

---

## 3. Unreferenced ROM Constants (`3` Identifiers)

1. **`SRCID` (`SRCID_SourceCodeVersionID`)** — [T-SMEC_25_ATX_A283_Stock.tpl:541-550](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_25_ATX_A283_Stock.tpl#L541-L550)
   * Stores `.word 0x0019` (Turbonator SMEC v19 version identifier) in the ROM header block immediately after `CHKFIX`. Not read by any executable instruction (except as part of the full-ROM checksum calculation in `CaculateChecksum`).
2. **`EGR8A` (`EGR8a_ExhGasRecircConst`)** — [T-SMEC_25_ATX_A283_Stock.tpl:7311-7321](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_25_ATX_A283_Stock.tpl#L7311-L7321)
   * Stores `.byte 0xF9` at `;.org 0x8835` immediately after `EGR8_ExhGasRecircConst` (`.byte 0x0D` at `;.org 0x8834`). Line 5445 of `T-SMEC_v19.asm` loads only the 8-bit `ldab EGR8_ExhGasRecircConst`, leaving `EGR8A` unreferenced by the EGR routine.
3. **`BAUDMD` (`BAUDMD_HiSpeedSerialBaudRate`)** — [T-SMEC_25_ATX_A283_Stock.tpl:7995-8006](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_25_ATX_A283_Stock.tpl#L7995-L8006)
   * Defined right after `BAUDLO` and `BAUDHI` in `0_-_Setup\F_-_Baud_Rate\`. In `T-SMEC_v19.asm`, both `SetupHiSpeedDataTransfer` ([line 3720](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_v19.asm#L3720)) and `ZeroRamFrom0EtoFE` ([line 7236](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_v19.asm#L7236)) load `BAUDHI_DRBBaudRateHi` rather than `BAUDMD_HiSpeedSerialBaudRate`.

---

## 4. Commented-Out Assembly Subroutines (`8` Identifiers)

In `T-SMEC_v19.asm`, three optional/legacy subsystems have their executable assembly instructions commented out (to save ROM space or loop execution time, as noted in the v17.0 revision log), though their calibration constants remain active in the `.tpl` ROM data block:

1. **`CCDCFG` (`CCDCFG_CCDConfigConstant`)** — Referenced at [T-SMEC_v19.asm:2736](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_v19.asm#L2734-L2737) inside the commented-out `CCD_CONST800F` subroutine (CCD bus code commented out in v17.0).
2. **`FLWMNC` (`FLWMNC_FuelMonitorCorrection`)** — Referenced at [T-SMEC_v19.asm:6310](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_v19.asm#L6309-L6318) inside `CalculateInjectorPulsewidthForEngineRunning` where the CCD fuel flow accumulation block is commented out (whereas `FUELTR_FuelMonitorConversionFactor` at line 1273 in `Interrupt_TimerOutputCapture1` remains active for the hardware fuel flow monitor pin).
3. **`AKPMON`, `AKPMOF`, `AKI1ON`, `AKI1OF`, `AKI2ON`, `AKI2OF` (Alcohol / Water Injection Setpoints)** — Referenced at [T-SMEC_v19.asm:10562-10636](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_v19.asm#L10562-L10636) inside the commented-out `MM_AlkyPump_Control` and `MM_AlkyInjector_Control` routines.

---

## 5. Cross-Template Label Spelling & Case Discrepancies

1. **`DLYTIM2` Label Spelling Between Templates**:
   * In [T-SMEC_25_ATX_A283_Stock.tpl:4137](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_25_ATX_A283_Stock.tpl#L4137), the label is spelled `DLYTM2_AisDelayAfterThrottleClosesWhenStopped:` (missing the `I`), whereas `;mptblcname` is `DLYTIM2`.
   * In [T-SMEC_22_ATX_S-IV.tpl:4042](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_22_ATX_S-IV.tpl#L4042), the label is spelled `DLYTIM2_AisDelayAfterThrottleClosesWhenStopped:`.
   * In `T-SMEC_v19.asm` ([line 7872](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_v19.asm#L7872)), the code loads `ldx #DLYTIM_AisDelayAfterThrottleClosesWhenMoving` and steps to `DLYTIM2` via `inx; ldaa 0x00,x`, so the assembly does not reference the `DLYTM2`/`DLYTIM2` label name directly.
2. **Case-Only Label Differences (`.tpl` vs `.asm`)**:
   * `FANTMP_FanTurnOnTempAbove45MPH` (`.tpl`) vs. `FANTMP_FanTurnOnTempAbove45Mph` ([T-SMEC_v19.asm:1729](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_v19.asm#L1729))
   * `SPDLMH_SpeedLimitFuelShutoff254MPH` (`.tpl`) vs. `SPDLMH_SpeedLimitFuelShutoff254mph` ([T-SMEC_v19.asm:5707](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_v19.asm#L5707))
   * `SPDLML_SpeedLimitFuelShutoffRestore253MPH` (`.tpl`) vs. `SPDLML_SpeedLimitFuelShutoffRestore253mph` ([T-SMEC_v19.asm:5809](file:///c:/Users/jpctu/Dropbox/ROM/T-Cals%20AI%20Review/cals/SMEC/T-SMEC_v19.asm#L5809))

---

## 6. Indexed / Pointer-Offset Calibration Groups (35 Identifiers)

The following identifiers are evaluated by the MCU via indexed offsets (`0x01,x`, `0x02,x`, `inx`, or `abx`) from a preceding base symbol in ROM rather than by direct symbol name in the opcode operand:

| Base Symbol in `T-SMEC_v19.asm` | ASM Line | Enclosing Routine | Indexed Companion Identifiers |
| :--- | :---: | :--- | :--- |
| `ENDIT1_PNPrefix` / `ENDITM_ECUID` | 3830, 4142, 4172 | `SendECUIDToSCI`, `CaculateChecksum` | `HUNTSV`, `MDLCDE`, `SETUP`, `SETUP2`, `CHKFIX` |
| `FLTMSK_ErrorBitsMask1` | 4441 | `UpdateErrorTimersAndPossiblyClearErrors_MM` | `FLTMSK2`, `FLTMSK3`, `FLTMSK4`, `FLTMSK5`, `FLTMSK6`, `FLTMSK7`, `FLTMSKX` |
| `SRTIME_SparkEPPsNeededToBeAboveSR_Hot` | 7015 | `HandleFuelStartRunStartTransfer` | `SRTIME2` (`0x01,x`) |
| `TMPHLD_TempSwitchPointForCurveAHoldDecay` | 6008 | `CalculateSumOfAllFuelModifiers_MM` | `CLDHLD` (`0x01,x`), `HOTHLD` (`0x02,x`) |
| `DCYTMC_CurveAColdDecayTime` | 6022 | `CalculateSumOfAllFuelModifiers_MM` | `DCYTMH` (`0x01,x`), `CCURV` (`0x02,x`), `DCYCC` (`0x03,x`) |
| `PTENR_EppPerAmountForIncreasing` | 5846 | `CalculatePartThrottleEnrichmentAndSparkScatterFuel_MM` | `PTENR2` (`inx; ldab 0x00,x`) |
| `MP1_AutoCalMapCellBoundary1` | 3354 | `AdaptiveMemory_DetermineWhichCellApplies_MM` | `MP2`, `MP3`, `MP4`, `MP5` (`inx` loop) |
| `DLYTIM_AisDelayAfterThrottleClosesWhenMoving` | 7872 | `CheckThrottleRoutine_MM` | `DLYTIM2` (`inx; ldaa 0x00,x`) |
| `PNDLTN_DeltaRpmChangeToUse_DRPNK_or_PNDRK` | 2351 | `CalculateTargetIdleSpeedAndAisPosition_MM` | `PNDRK` (`inx; jsr Lookup4ByteTable`) |
| `PNDLTP_DeltaRpmChangeToUse_DRPNK_or_PNDRK` | 2346 | `CalculateTargetIdleSpeedAndAisPosition_MM` | `DRPNK` (`inx; jsr Lookup4ByteTable`) |
| `FANTMP_FanTurnOnTempAbove45Mph` | 1729 | `ControlFan_MM` | `FANTMP2` (`0x01,x`), `FANTMP3` (`inx; inx; 0x00,x`), `FANTMP4` (`inx; inx; 0x01,x`) |
| `PTUMP1_PTUMAPThresholdForLock1` | 10437 | `ControlPTU_MM` | `PTUMP2` (`inx; cmpa 0x00,x`) |
| `EGR18` / `EGR16` / `EGR14` / `EGR19` / `EGR15` / `EGR17` | 5429–5498 | `ExhGasRecirc_MM` (`EGR_CheckHiLoLimits`) | `EGRR18A`, `EGR16A`, `EGR14A`, `EGR19A`, `EGR15B`, `EGR17A` (`cmpa 0x01,x`) |
