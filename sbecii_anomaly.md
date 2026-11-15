# SBECII (`T-SBECII_v1.asm`) Calibration & Firmware Anomaly Log

**Generated:** 2026-11-15 19:58:14 UTC  
**Firmware Source:** [T-SBECII_v1.asm](file:///C:/Users/jpctu/Dropbox/ROM/T-Cals AI Review/cals/SBECII/T-SBECII_v1.asm)  
**Primary Template:** [92_25_t1_xtx_125.tpl](file:///C:/Users/jpctu/Dropbox/ROM/T-Cals AI Review/cals/SBECII/92_25_t1_xtx_125.tpl)  
**Target Architecture:** 68HC11 (Chrysler 2.5L Turbo I / Sequential EFI (8-Valve SOHC))

---

## 1. Synthetic Computed Views (`0` Excluded Tables)

The following 3D display surfaces are calculated dynamically by MPTune software and do not exist as independent lookup tables in the MCU firmware:


---

## 2. Unreferenced ROM Constants & Header Calibration IDs (`182` Identifiers)

The following calibration parameters reside in the ROM calibration structure but are accessed via base pointers, sequential table indexing, or serve as static calibration identification bytes:

* **`IDCODE_1`** (`T_PNPrefix` in `Setup_-_Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`IDCODE_2`** (`T_PNPrefix1` in `Setup_-_Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`ENDIT2`** (`T_PNPrefix3` in `Setup_-_Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`RFIREV`** (`T_RFIRevision` in `Setup_-_Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`BITSUM`** (`T_ChecksumValue` in `Setup_-_Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`CCDCF2`** (`T_CCDConfigConstant2` in `Setup_-_Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`FLTMSK2`** (`T_ErrorBitsMask2` in `Setup_-_Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`FLTMSK3`** (`T_ErrorBitsMask3` in `Setup_-_Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`FLTMSK4`** (`T_ErrorBitsMask4` in `Setup_-_Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`FLTMSK5`** (`T_ErrorBitsMask5` in `Setup_-_Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`FLTMSK6`** (`T_ErrorBitsMask6` in `Setup_-_Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`FLTMSK7`** (`T_ErrorBitsMask7` in `Setup_-_Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`FLTMSKX`** (`T_ErrorBitsMaskTerminator` in `Setup_-_Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8036X`** (`T_t8036x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`MP2`** (`T_AutoCalMapCellBoundary2` in `Fuel_-_Adaptive_memory\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`MP3`** (`T_AutoCalMapCellBoundary3` in `Fuel_-_Adaptive_memory\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`MP4`** (`T_AutoCalMapCellBoundary4` in `Fuel_-_Adaptive_memory\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T80F4X`** (`T_t80F4x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8107X`** (`T_t8107x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T811AX`** (`T_t811Ax` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T812DX`** (`T_t812Dx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8134X`** (`T_t8134x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8159X`** (`T_t8159x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8168X`** (`T_t8168x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T817FX`** (`T_t817Fx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8191X`** (`T_t8191x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T81BBX`** (`T_t81BBx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T81D2X`** (`T_t81D2x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8204X`** (`T_t8204x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8227X`** (`T_t8227x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8239X`** (`T_t8239x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T823DX`** (`T_t823Dx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`WGMX2R`** (`T_MaxWGDCForBoostErrorCorrection2` in `Boost_-_WG_Control\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`DCRPM4`** (`T_WastegateDutyCycleRpmBoundary4` in `Boost_-_WG_Control\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8251X`** (`T_t8251x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8258X`** (`T_t8258x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`FANTMP2`** (`T_FanTurnOffTempAbove45Mph` in `Fan_Control\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`FANTMP3`** (`T_FanTurnOnTempBelow35Mph` in `Fan_Control\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`FANTMP4`** (`T_FanTurnOffTempBelow35Mph` in `Fan_Control\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`CLTRP1`** (`T_Cyl1TrimValueForPurgeVolume` in `Fuel_-_Individual_Cylinder_Trim\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T82C8X`** (`T_t82C8x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T82D7X`** (`T_t82D7x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8300X`** (`T_t8300x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T830BX`** (`T_t830Bx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8316X`** (`T_t8316x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8321X`** (`T_t8321x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8330X`** (`T_t8330x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T835AX`** (`T_t835Ax` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8371X`** (`T_t8371x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T837CX`** (`T_t837Cx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8383X`** (`T_t8383x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`CRUZ2X`** (`T_UnknownConstForCruiseControl2x` in `Cruise_Control\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`CRUZ2Y`** (`T_UnknownConstForCruiseControl2y` in `Cruise_Control\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`DM2CAC`** (`T_DeltaMAPForCruiseTPSAccel2` in `Cruise_Control\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`DMSCNT`** (`T_PTUDeltaMAPSampleCounter` in `PTU_Control\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`PRPTUE`** (`T_PrimaryPTUEngagement` in `PTU_Control\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T83C7X`** (`T_t83C7x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`PRPTUD`** (`T_PrimaryPTUDisengagement` in `PTU_Control\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T83D6X`** (`T_t83D6x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`SRPTUE`** (`T_SecondaryPTUEngagement` in `PTU_Control\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T83E1X`** (`T_t83E1x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`SRPTUD`** (`T_SecondaryPTUDisengagement` in `PTU_Control\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T83F4X`** (`T_t83F4x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`EGRR18A`** (`T_ExhGasRecircConstHiLimit18a` in `EGR\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`EGR16A`** (`T_ExhGasRecircConstHiLimit16a` in `EGR\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`EGR14A`** (`T_ExhGasRecircConstFromTPSVoltsHiLimit14a` in `EGR\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`EGR19A`** (`T_ExhGasRecircConstHiLimit19a` in `EGR\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`EGR17A`** (`T_ExhGasRecircConstHiLimit17a` in `EGR\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T840DX`** (`T_t840Dx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`EGR15A`** (`T_ExhGasRecircConstFromRPMHiLimit15a` in `EGR\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`ADMEMA`** (`T_ValueFromAdaptivememoryAdder1` in `EGR\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`EGR8A`** (`T_ExhGasRecircConst8a` in `EGR\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8433X`** (`T_t8433x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`OFSMID`** (`T_OffsetForMAPOverIdle` in `Setup_-_On-Board_Diagnostics\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T843AX`** (`T_t843Ax` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8462X`** (`T_t8462x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8471X`** (`T_t8471x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8480X`** (`T_t8480x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T848BX`** (`T_t848Bx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`DEFTMP`** (`T_DefaultEngineTemp` in `Setup_-_On-Board_Diagnostics\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`BTLRPMX`** (`T_LowBatteryVoltageAtThisRpm1500_dup` in `Setup_-_On-Board_Diagnostics\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`AMBLOW`** (`T_BattTempLowWhenHot` in `Setup_-_On-Board_Diagnostics\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`DEFCHG`** (`T_DefaultChargeTemp_Limpin` in `Setup_-_On-Board_Diagnostics\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`MPVAC2`** (`T_AllowMapToTestGoodThisNearBaro2` in `Setup_-_On-Board_Diagnostics\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`UNKNOWNBYTESA`** (`T_UnknownBytesA` in `Setup_-_On-Board_Diagnostics\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`UNKNOWNBYTESB`** (`T_UnknownBytesB` in `Setup_-_On-Board_Diagnostics\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`BTVHYSX`** (`T_BatteryVoltsHysteresisForAlternatorControl_dup` in `Setup_-_Alternator_Diagnostics\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`BTVLMTX`** (`T_BatteryVoltsDiagLimitOverTarget_dup` in `Setup_-_Alternator_Diagnostics\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`BTVCNTX`** (`T_BatteryVoltsDiagCounterMax_dup` in `Setup_-_Alternator_Diagnostics\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`BTVCN3X`** (`T_BatteryVoltsDiagCounterMin_dup` in `Setup_-_Alternator_Diagnostics\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`BTVCN2X`** (`T_BatteryVoltsDiagCounterMax2_dup` in `Setup_-_Alternator_Diagnostics\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`DCAISI`** (`T_AISIncrementWhenUsingDecelFuelShut` in `Decel_Fuel_Shutoff\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T84D2X`** (`T_t84D2x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T84DAX`** (`T_t84DAx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T852CX`** (`T_t852Cx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T853BX`** (`T_t853Bx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8565X`** (`T_t8565x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8579X`** (`T_t8579x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8590X`** (`T_t8590x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T85A7X`** (`T_t85A7x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T85B6X`** (`T_t85B6x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T85BDX`** (`T_t85BDx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T85C8X`** (`T_t85C8x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T85CFX`** (`T_t85CFx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`MAPOFS`** (`T_MAPOffsetForFuelCalculation` in `Fuel_-_Running\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8714X`** (`T_t8714x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`PTEADJ`** (`T_EnrichAdjust_FromMap` in `Fuel_-_Running\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8968X`** (`T_t8968x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8975X`** (`T_t8975x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8B2BX`** (`T_t8B2Bx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`WOTMUL`** (`T_MultiplierForWOTENR` in `Fuel_-_Modifiers\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8B43X`** (`T_t8B43x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8B61X`** (`T_t8B61x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8B78X`** (`T_t8B78x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8B8BX`** (`T_t8B8Bx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8B96X`** (`T_t8B96x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8BC8X`** (`T_t8BC8x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`NEGSL2`** (`T_DeltaMAPLeanout_FromTemp` in `Fuel_-_Transient_Enrichment\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8BDAX`** (`T_t8BDAx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8BF2X`** (`T_t8BF2x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8C08X`** (`T_t8C08x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8C0FX`** (`T_t8C0Fx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8C1BX`** (`T_t8C1Bx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8C26X`** (`T_t8C26x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8C3DX`** (`T_t8C3Dx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8C4BX`** (`T_t8C4Bx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8DDAX`** (`T_t8DDAx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8DF4X`** (`T_t8DF4x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8DFBX`** (`T_t8DFBx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8E05X`** (`T_t8E05x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8F48X`** (`T_t8F48x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8F61X`** (`T_t8F61x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8F78X`** (`T_t8F78x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`INNBSK`** (`T_KnockRetardIncrProduct_NoBoostSomeKnock` in `Spark_-_Knock_Retard\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`INIBNK`** (`T_KnockRetardIncrProduct_InBoostNoKnock` in `Spark_-_Knock_Retard\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`INIBSK`** (`T_KnockRetardIncrProduct_InBoostSomeKnock` in `Spark_-_Knock_Retard\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`INBNWN`** (`T_KnockRetardIncrProduct_InBoostNoWGNoKnock` in `Spark_-_Knock_Retard\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`INBNWS`** (`T_KnockRetardIncrProduct_InBoostNoWGSomeKnock` in `Spark_-_Knock_Retard\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8F8FX`** (`T_t8F8Fx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8F9FX`** (`T_t8F9Fx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8FB6X`** (`T_t8FB6x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8FD1X`** (`T_t8FD1x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8FDCX`** (`T_t8FDCx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T8FFBX`** (`T_t8FFBx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T901BX`** (`T_t901Bx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T9032X`** (`T_t9032x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T903DX`** (`T_t903Dx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T904DX`** (`T_t904Dx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T905EX`** (`T_t905Ex` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T906DX`** (`T_t906Dx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T9099X`** (`T_t9099x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T90C6X`** (`T_t90C6x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T90D9X`** (`T_t90D9x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T9103X`** (`T_t9103x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T9112X`** (`T_t9112x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T9134X`** (`T_t9134x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T913FX`** (`T_t913Fx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T914EX`** (`T_t914Ex` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T915DX`** (`T_t915Dx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T9174X`** (`T_t9174x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T9185X`** (`T_t9185x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T91B3X`** (`T_t91B3x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T91C2X`** (`T_t91C2x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T91CDX`** (`T_t91CDx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T91E0X`** (`T_t91E0x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T91F5X`** (`T_t91F5x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T9204X`** (`T_t9204x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T9217X`** (`T_t9217x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T9226X`** (`T_t9226x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T9239X`** (`T_t9239x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T924CX`** (`T_t924Cx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T925BX`** (`T_t925Bx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T926AX`** (`T_t926Ax` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T927DX`** (`T_t927Dx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T9288X`** (`T_t9288x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T92ACX`** (`T_t92ACx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`PNDLT`** (`T_DeltaRpmChangeToUse_DRPNK_or_PNDRK_A` in `Idle_-_AIS_Decel\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T92BBX`** (`T_t92BBx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T92F5X`** (`T_t92F5x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T931FX`** (`T_t931Fx` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`T9355X`** (`T_t9355x` in `Unassigned\`): Static cal ID byte, sequential array element, or indirect indexed pointer.
* **`SRCID`** (`T_SourceCodeVersionID` in `Setup_-_Cal_Configuration\`): Static cal ID byte, sequential array element, or indirect indexed pointer.

---

## 3. Subsystem Breakdown

* **`Aux_Vehicle_Functions`**: 29 active calibration descriptors
* **`Boost_Control`**: 56 active calibration descriptors
* **`Cruise_Control`**: 55 active calibration descriptors
* **`Diagnostics_OBD`**: 64 active calibration descriptors
* **`EGR_Emissions`**: 31 active calibration descriptors
* **`Fan_Control`**: 6 active calibration descriptors
* **`Fuel_Base_Modifiers`**: 38 active calibration descriptors
* **`Fuel_O2_Adaptive`**: 58 active calibration descriptors
* **`Fuel_Transient`**: 37 active calibration descriptors
* **`Idle_AIS`**: 89 active calibration descriptors
* **`Limiters_Limp`**: 26 active calibration descriptors
* **`Setup_Calibration`**: 178 active calibration descriptors
* **`Spark`**: 84 active calibration descriptors
