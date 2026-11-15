# T3-II (`T-T3_IIv1.asm`) Calibration & Firmware Anomaly Log

**Generated:** 2026-11-15 19:58:31 UTC  
**Firmware Source:** [T-T3_IIv1.asm](file:///C:/Users/jpctu/Dropbox/ROM/T-Cals AI Review/cals/T3-II/T-T3_IIv1.asm)  
**Primary Template:** [T-T3_22_T3ii_T3_MTX.tpl](file:///C:/Users/jpctu/Dropbox/ROM/T-Cals AI Review/cals/T3-II/T-T3_22_T3ii_T3_MTX.tpl)  
**Target Architecture:** 68HC11 (Chrysler 2.2L Turbo III Lotus 16-Valve DOHC (DDIS & Sequential EFI))

---

## 1. Synthetic Computed Views (`0` Excluded Tables)

The following 3D display surfaces are calculated dynamically by MPTune software and do not exist as independent lookup tables in the MCU firmware:


---

## 2. Unreferenced ROM Constants & Header Calibration IDs (`47` Identifiers)

The following calibration parameters reside in the ROM calibration structure but are accessed via base pointers, sequential table indexing, or serve as static calibration identification bytes:

* **`IDCODE_1`** (`IDENT1_IDCode_1` in `Setup\Cal_ID\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`IDCODE_2`** (`IDENT2_IDCode_2` in `Setup\Cal_ID\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`RFIREV`** (`RFIREV_RFIRevision` in `Setup\Cal_ID\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`BITSUM`** (`BITSUM_ChecksumValue` in `Setup\Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`CCDCF2`** (`CCDCF2_CCDConfigConstant2` in `Setup\Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`CCDCF3`** (`CCDCF3_CCDConfigConstant3` in `Setup\Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`FLTMSK2`** (`FLTMSK2_ErrorBitsMask2` in `Setup\Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`FLTMSK3`** (`FLTMSK3_ErrorBitsMask3` in `Setup\Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`FLTMSK4`** (`FLTMSK4_ErrorBitsMask4` in `Setup\Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`FLTMSK5`** (`FLTMSK5_ErrorBitsMask5` in `Setup\Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`FLTMSK6`** (`FLTMSK6_ErrorBitsMask6` in `Setup\Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`FLTMSK7`** (`FLTMSK7_ErrorBitsMask7` in `Setup\Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`FLTMSKX`** (`FLTMSKX_ErrorBitsMaskTerminator` in `Setup\Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`EMRETB`** (`KNENRC_KnockRetardEnrichment` in `Spark\Adaptive_Retard\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`CLDHLD`** (`CLDHLD_CurveAColdHoldTime` in `Fuel\Running\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`HOTHLD`** (`HOTHLD_CurveAHotHoldTime` in `Fuel\Running\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`DCYTMH`** (`DCYTMH_CurveAHotDecayTime` in `Fuel\Running\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`CCURV`** (`CCURV_HoldTimeForCurveC` in `Fuel\Running\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`DCYCC`** (`DCYCC_DecayRateForCurveC` in `Fuel\Running\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`MP2`** (`MP2_AutoCalMapCellBoundary2` in `Fuel\O2_Feedback_Control\Adaptive_memory\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`MP3`** (`MP3_AutoCalMapCellBoundary3` in `Fuel\O2_Feedback_Control\Adaptive_memory\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`MP4`** (`MP4_AutoCalMapCellBoundary4` in `Fuel\O2_Feedback_Control\Adaptive_memory\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`L8C36`** (`L8C65_L8C65` in `Fuel\Running\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`PNDLT`** (`PNDLTN_DeltaRpmChangeToUse_DRPNK_or_PNDRK` in `Idle\AIS_Decel\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`PNDRK`** (`PNDRK_ParkNeutralToDriveKicks_FromTemp` in `Idle\AIS_Decel\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`DRPNK`** (`DRPNK_DriveToParkNeutralKicks_FromTemp` in `Idle\AIS_Decel\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`INCPTV`** (`INCPTV_AdaptiveIncAfterThisTimeBC` in `Boost_Control\WG_Control\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`NTUSD1`** (`NTUSD1` in `Setup\Cal_ID\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`FANTMP2`** (`FANTMP2_FanTurnOffTempAbove45Mph` in `Fan_Control\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`FANTMP3`** (`FANTMP3_FanTurnOnTempBelow35Mph` in `Fan_Control\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`FANTMP4`** (`FANTMP4_FanTurnOffTempBelow35Mph` in `Fan_Control\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`CLTRP1`** (`CLTRP1_Cyl1TrimValueForPurgeVolume` in `Fuel\O2_Feedback_Control\Individual_Cylinder_Trim\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`CRUZ2X`** (`CRUZ2x_UknownConstForCruiseControl2x` in `Utility\Cruise_Control\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`CRUZ2Y`** (`CRUZ2y_UknownConstForCruiseControl2y` in `Utility\Cruise_Control\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`AMBLOW`** (`AMBLOW_BattTempLowWhenHot` in `Utility\On-Board_Diagnostics\Battery_Temp_Sensor\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`AMBHIG`** (`AMBHIG_BattTempHighWhenCold` in `Utility\On-Board_Diagnostics\Battery_Temp_Sensor\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`MPVAC2`** (`MPVAC2_AllowMapToTestGoodThisNearBaro2` in `Utility\On-Board_Diagnostics\MAP_Sensor\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`UKNOWNBYTESA`** (`UknownByteA` in `Utility\On-Board_Diagnostics\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`UKNOWNBYTESB`** (`UknownByteB` in `Utility\On-Board_Diagnostics\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`FASTDT`** (`FastDataOutputCommandByte` in `Setup\DRB_Datalogging\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`FASTDA`** (`FastDataOutputAddressTable` in `Setup\DRB_Datalogging\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`ANTLAG`** (`ANTLAG_AntiLagRetardfromBoostGoalDelta` in `Turbonator_Features\Anti-Lag\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`SLRPM`** (`SLRPM_ShiftLightSetpoint` in `Turbonator_Features\Shift_Light\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`WOTBAT`** (`WOTBAT_WOTBatteryVoltsTarget` in `Turbonator_Features\Voltage_Regulator\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`OPTN2`** (`OPTN2_CalCustomOptionConfigFlags2` in `Setup\Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`SRCID`** (`SRCID_SourceCodeVersionID` in `Setup\Cal_ID\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`CHKFIX`** (`CHKFIX_ChecksumFixupValue` in `Setup\Cal_ID\`): Static cal ID byte, sequential array element, or indirect indexed pointer.

---

## 3. Subsystem Breakdown

* **`Aux_Vehicle_Functions`**: 17 active calibration descriptors
* **`Boost_Control`**: 59 active calibration descriptors
* **`Cruise_Control`**: 54 active calibration descriptors
* **`Diagnostics_OBD`**: 54 active calibration descriptors
* **`Fan_Control`**: 6 active calibration descriptors
* **`Fuel_Base_Modifiers`**: 39 active calibration descriptors
* **`Fuel_O2_Adaptive`**: 60 active calibration descriptors
* **`Fuel_Transient`**: 54 active calibration descriptors
* **`Idle_AIS`**: 79 active calibration descriptors
* **`Limiters_Limp`**: 26 active calibration descriptors
* **`Setup_Calibration`**: 61 active calibration descriptors
* **`Spark`**: 54 active calibration descriptors
* **`Turbonator_Features`**: 3 active calibration descriptors
