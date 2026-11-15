;mpver 2.00
;mpassmfile t-t3_iiv1.asm
.org DataOrg
;mpfuelparms 6000,60,55,3.793,.740_Regular,2.2
;mpfuelnone1 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpfuelnone2 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpfuelpart1 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpfuelpart2 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpfuelfull1 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpfuelfull2 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpinjsize 34.9
;mpbar 2.0

;
;mprevisionstart
; ***********************************************************************
;
; Revision History
;
; Version 1.0
; 06/22/11 - 1st release and test of T-T3 (SBECII).
;
; ***********************************************************************
;mprevisionend
;

        .msg "Assembling Data Structures..." ; these are just messages to display during assemble to let you know what's going on...

RomBegin:

	;.org	0x8000
IDENT1_IDCode_1:
    ;mpgrp Setup\Cal_ID\
    ;mptbladdr 0x0021
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PNPrefix
    ;mptblcname IDCODE_1
    ;mpxaxis X 0 255 scale
    ;mpyaxis Y 0 255 out
    ;mptbldesc Desc
    .byte 0x11                       ;Point 1

	;.org	0x8001
IDENT2_IDCode_2:
    ;mpgrp Setup\Cal_ID\
    ;mptbladdr 0x002E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PNPrefix
    ;mptblcname IDCODE_2
    ;mpxaxis X 0 255 scale
    ;mpyaxis Y 0 255 out
    ;mptbldesc Desc
    .byte 0x00                       ;Point 1

	;.org	0x8002
ENDIT1_PNPrefix:
    ;mpgrp Setup\Cal_ID\
    ;mptbladdr 0x003B
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname PNPrefix
    ;mptblcname ENDIT1
    ;mpxaxis X 0 255 scale
    ;mpyaxis Y 0 255 out
    ;mptbldesc Part_Number_prefix._The_1st_4_digits_of_the_Mopar_PN_for_this_ECU.
    .word 0x0471                     ;Point 1

	;.org	0x8004
ENDITM_ECUID:
    ;mpgrp Setup\Cal_ID\
    ;mptbladdr 0x0048
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ECU_ID
    ;mptblcname ENDITM
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc ECU_ID._This_portion_of_the_PN_is_used_by_scan_tools_to_automatically_ID_the_ECU._This_number_is_different_for_every_computer/cal._The_1st_digit_is_possibly_a_revision_code_of_some_type._Or,_it_may_have_no_meaning_at_all.
    .word 0x4342                     ;Point 1


	;.org	0x8006
PARTREV_RevisionLevel:
    ;mpgrp Setup\Cal_ID\
    ;mptbladdr 0x0056
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Revision_Level
    ;mptblcname PARTREV
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Description
    .byte 0xA0                       ;Point 1

	;.org	0x8007
RFINO3_:
    ;mpgrp Setup\Cal_ID\
    ;mptbladdr 0x0063
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RFINO3
    ;mptblcname RFINO3
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Description
    .byte 0x04                       ;Point 1

	;.org	0x8008
RFINO2_:
    ;mpgrp Setup\Cal_ID\
    ;mptbladdr 0x0070
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RFINO2
    ;mptblcname RFINO2
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Description
    .byte 0x71                       ;Point 1

	;.org	0x8009
RFINO1:
    ;mpgrp Setup\Cal_ID\
    ;mptbladdr 0x007D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RFINO1
    ;mptblcname RFINO1
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Description
    .byte 0x43                       ;Point 1

	;.org	0x800a
RFINO0_:
    ;mpgrp Setup\Cal_ID\
    ;mptbladdr 0x008A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RFINO0
    ;mptblcname RFINO0
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Description
    .byte 0x43                       ;Point 1

	;.org	0x800b
RFIREV_RFIRevision:
    ;mpgrp Setup\Cal_ID\
    ;mptbladdr 0x0097
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RFIRevision
    ;mptblcname RFIREV
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Description
    .byte 0xA0                       ;Point 1

	;.org	0x800c
BITSUM_ChecksumValue:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0x00A4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ChecksumValue
    ;mptblcname BITSUM
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Description
    .byte 0x98                       ;Point 1

	;.org	0x800d
CODE13_:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0x00B1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CODE13
    ;mptblcname CODE13
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Description
    .byte 0x44                       ;Point 1

	;.org	0x800e
CODE12_:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0x00BE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CODE12
    ;mptblcname CODE12
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Description
    .byte 0x78                       ;Point 1

	;.org	0x800f
MDLCDE_ModelTypeCode:
    ;mpgrp Setup\Cal_ID\
    ;mptbladdr 0x00CB
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ModelTypeCode
    ;mptblcname MDLCDE
    ;mpxaxis X 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc The_1st_2_digits_are_the_model_year,_2nd_2_digits_are_the_engine_and_trans_type.
    .word 0x0399                     ;Point 1
    ;mp******************************
    ;mpmodelyr 99 1989
    ;mpmodelyr 00 1990
    ;mpmodelyr 01 1991
    ;mpmodelyr 02 1992
    ;mpmodelyr 03 1993
    ;mpmodelyr 11 1991_MP
    ;mpmodelyr 50 1990_Shadow
    ;mpmodelyr 40 1989_Daytona_VNT
    ;mpmodelyr 79 1989_3.0_Van
    ;mpmodelyr 70 1990_3.0_Van
    ;mpmodelyr 21 1991_3.0_Van
    ;mpengtran 10 2.2_TIV
    ;mpengtran 40 2.2_VNT_Manual
    ;mpengtran 01 2.5_T1
    ;mpengtran 11 2.5_Turbo
    ;mpengtran 21 2.5_T1_Van_Auto
    ;mpengtran 41 2.5_T1/T3_Manual
    ;mpengtran 12 3.0_MFI
    ;mpengtran 22 3.0_Auto
    ;mpengtran 13 3.3_MFI
    ;mpengtran 14 3.9_Truck
    ;mpengtran 15 5.2/5.9_TBI_VIN_Y
    ;mpengtran 16 5.2/5.9_TBI_VIN_X
    ;mpengtran 51 3.0_Van_A604
    ;mpengtran 99 2.2
    ;mp******************************

; $8006 controls the year.
; 99=1989
; 00=1990
; 01=1991
; 02=1992
; 03=1993

; 11=1991 MP
; 50=1990 (Shadow)
; 40=1989 (Daytona VNT)
; 79=1989 (on 3.0 Minivan)
; 70=1990 (on 3.0 Minivan)
; 21=1991 (on 3.0 Minivan)


; $8007 controls engine type.
; 10=2.2 turbo IV
; 40=2.2 VNT Manual

; 01=2.5 T1
; 11=2.5 turbo
; 21=2.5 T1 (Minivan) Auto Trans
; 41=2.5 T1 Manual Trans

; 41=2.2 T3 Manual Trans (Also?)

; 12=3.0 MFI
; 22=3.0 Auto

; 13=3.3 MFI
; 14=3.9 truck
; 15=5.2/5.9 TBI VIN Y
; 16=5.2/5.9 TBI VIN X

; 51=? 3.0 Minivan A604?

	;.org	0x8011
CONFIG_ConfigurationFlags:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0x0117
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname ConfigurationFlags
    ;mptblcname CONFIG
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc These_are_the_factory_configuration_options.
    ;mpchoices Bit0  Bit1  CCD  AC  Bit3  Bit4  ATX  EGR
    .byte 0x91                       ;Point 1

	;.org	0x8012
CONFIG2_ConfigurationFlags2:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0x0125
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname ConfigurationFlags2
    ;mptblcname CONFIG2
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc These_are_the_factory_configuration_options.
    ;mpchoices Bit0  Bit1  Bit2  Bit3  TransFuel  Bit5  O2  Bit7
    .byte 0x01                       ;Point 1

	;.org	0x8013
CCDCFG_CCDConfigConstant:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0x0133
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname CCDConfigConstant
    ;mptblcname CCDCFG
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc CCD_Bus_configuration_constant._Not_sure_of_usage.
    ;mpchoices Bit0  Bit1  Bit2  Bit3  Bit4  Bit5  Bit6  Bit7
    .byte 0x40                       ;Point 1
    
CCDCF2_CCDConfigConstant2:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0x0140
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname CCDConfigConstant2
    ;mptblcname CCDCF2
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc CCD_Bus_configuration_constant._Not_sure_of_usage.
    ;mpchoices Bit0  Bit1  Bit2  Bit3  Bit4  Bit5  Bit6  Bit7
    .byte 0x30                       ;Point 1
    
CCDCF3_CCDConfigConstant3:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0x014D
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname CCDConfigConstant3
    ;mptblcname CCDCF3
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc CCD_Bus_configuration_constant._Not_sure_of_usage.
    ;mpchoices Bit0  Bit1  Bit2  Bit3  Bit4  Bit5  Bit6  Bit7
    .byte 0x24                       ;Point 1

	;.org	0x8016
FLTMSK1_ErrorBitsMask1:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0x015B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask1
    ;mptblcname FLTMSK1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1

FLTMSK2_ErrorBitsMask2:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0x0167
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask2
    ;mptblcname FLTMSK2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1

FLTMSK3_ErrorBitsMask3:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0x0173
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask3
    ;mptblcname FLTMSK3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1

FLTMSK4_ErrorBitsMask4:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0x017F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask4
    ;mptblcname FLTMSK4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1

FLTMSK5_ErrorBitsMask5:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0x018B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask5
    ;mptblcname FLTMSK5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1

FLTMSK6_ErrorBitsMask6:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0x0197
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask6
    ;mptblcname FLTMSK6
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1

FLTMSK7_ErrorBitsMask7:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0x01A3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask7
    ;mptblcname FLTMSK7
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1

FLTMSKX_ErrorBitsMaskTerminator:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0x01AF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMaskTerminator
    ;mptblcname FLTMSKX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Must_be_0x00,_and_must_be_at_the_end_of_the_error_code_list.
    .byte 0x00                       ;Point 1

	;.org	0x801e
IPLMSK_PowerLossLightMask:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0x01BC
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PowerLossLightMask
    ;mptblcname IPLMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Illuminate_PowerLoss_Light_Mask1._These_errors_alert_the_driver.
    ;mpchoices ChargeTemp_Sensor  CoolantTemp_Sensor  Charging  bit3  BatVolts  Map_Signal  Tps_Signal  Map_Pneumatic
    .byte 0xF7                       ;Point 1

	;.org	0x801f
IPLMSK2_PowerLossLightMask2:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0x01CA
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PowerLossLightMask2
    ;mptblcname IPLMSK2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Illuminate_PowerLoss_Light_Mask2._These_errors_alert_the_driver.
    ;mpchoices bit0  bit1  bit2  Wastegate  InjectorFault  bit5  MajorFault  bit7
    .byte 0x35                       ;Point 1

	;.org	0x8020
PIAMSK_PIA1ADDRMask:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0x01D8
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PIAMSK_PIA1ADDRMask
    ;mptblcname PIAMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc These_flags_enable_error_reporting_on_specific_output_bits.
    ;mpchoices Cruise_Vacuum  Purge_Solenoid  Part_Throt_Unlock  AC_Clutch_Relay  Fan_Relay  ASD_Relay  CE_Light  Cruise_Vent
    .byte 0x35                       ;Point 1

	;.org	0x8021
PIBMSK_PIA1BDDRMask:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0x01E6
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PIBMSK_PIA1BDDRMask
    ;mptblcname PIBMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc These_flags_enable_error_reporting_on_specific_output_bits.
    ;mpchoices bit0  bit1  bit2  bit3  Emission_Light  Baro_Read_Solenoid  Wastegate_Solenoid  EGR_Solenoid
    .byte 0x94                       ;Point 1

	;.org	0x8022
IDLADV_IdleAdvanceFromCoolantTemp:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0x01F4
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname IdleAdvanceFromCoolantTemp
    ;mptblcname IDLADV
    ;mpxaxis Coolant -200 260 F
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc Desc
    .byte 0x03                       ;Number of points in table
    .byte 0x80, 0x32, 0xFF, 0x2B     ;Point 1
    .byte 0x92, 0x23, 0xFF, 0xC9     ;Point 2
    .byte 0xBC, 0x1A                 ;Point 3

	;.org	0x8031
HOTMPL_PartThrottleLowMAPTiming:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0x0204
    ;mptbltype 7
    ;mpsubtype n
    ;mptbllname PartThrottleLowMAPTiming
    ;mptblcname HOTMPL
    ;mpxaxis RPMLO:RPMHI 800 6112 rpm
    ;mpyaxis MAPLO 0 127.5 deg
    ;mptbldesc Part_Throttle,_low_MAP_timing_table.
    ;mp3dxtable RPMLO RPMHI
    ;mp3dytable MAPLO 
    .byte 0x09                       ;Number of rows in table
    .byte 0x11                       ;Number of cols in table
    .byte 0x00                       ;00 = unsigned, 80/FF = signed
    .byte 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C ;Row 1
    .byte 0x26, 0x26, 0x26, 0x26, 0x26, 0x26, 0x26, 0x29, 0x2A, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C ;Row 2
    .byte 0x26, 0x26, 0x26, 0x26, 0x26, 0x26, 0x26, 0x29, 0x2A, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C ;Row 3
    .byte 0x22, 0x22, 0x26, 0x26, 0x26, 0x26, 0x26, 0x29, 0x2A, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C ;Row 4
    .byte 0x22, 0x22, 0x26, 0x26, 0x26, 0x26, 0x26, 0x29, 0x2A, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C ;Row 5
    .byte 0x22, 0x22, 0x26, 0x26, 0x26, 0x26, 0x26, 0x29, 0x2A, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C ;Row 6
    .byte 0x22, 0x22, 0x26, 0x26, 0x2B, 0x2F, 0x2F, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C, 0x2C ;Row 7
    .byte 0x22, 0x22, 0x26, 0x28, 0x2C, 0x2F, 0x2F, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30 ;Row 8
    .byte 0x23, 0x23, 0x28, 0x2A, 0x2D, 0x31, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33 ;Row 9

	;.org	0x80cd
HOTMPH_PartThrottleHiMAPTiming:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0x021E
    ;mptbltype 7
    ;mpsubtype n
    ;mptbllname PartThrottleHiMAPTiming
    ;mptblcname HOTMPH
    ;mpxaxis RPMLO:RPMHI 800 6112 rpm
    ;mpyaxis MAPHI 0 127.5 deg
    ;mptbldesc Part_Throttle,_high_MAP_timing_table.
    ;mp3dxtable RPMLO RPMHI
    ;mp3dytable MAPHI 
    .byte 0x11                       ;Number of rows in table
    .byte 0x11                       ;Number of cols in table
    .byte 0x00                       ;00 = unsigned, 80/FF = signed
    .byte 0x23, 0x23, 0x28, 0x2A, 0x2D, 0x31, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33 ;Row 1
    .byte 0x26, 0x26, 0x2B, 0x2C, 0x2E, 0x31, 0x33, 0x35, 0x37, 0x37, 0x37, 0x3A, 0x3A, 0x3A, 0x3B, 0x3B, 0x3B ;Row 2
    .byte 0x29, 0x29, 0x2E, 0x2E, 0x2F, 0x31, 0x32, 0x35, 0x37, 0x37, 0x37, 0x3E, 0x40, 0x41, 0x42, 0x42, 0x42 ;Row 3
    .byte 0x2C, 0x2C, 0x2E, 0x30, 0x30, 0x31, 0x31, 0x34, 0x36, 0x37, 0x37, 0x3B, 0x3E, 0x3F, 0x42, 0x42, 0x42 ;Row 4
    .byte 0x2F, 0x2F, 0x30, 0x31, 0x31, 0x31, 0x31, 0x33, 0x36, 0x37, 0x37, 0x39, 0x3D, 0x3D, 0x42, 0x42, 0x42 ;Row 5
    .byte 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x32, 0x34, 0x35, 0x35, 0x38, 0x3A, 0x3C, 0x41, 0x42, 0x42 ;Row 6
    .byte 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x32, 0x33, 0x33, 0x34, 0x37, 0x38, 0x3C, 0x41, 0x41, 0x41 ;Row 7
    .byte 0x30, 0x30, 0x30, 0x30, 0x30, 0x31, 0x31, 0x32, 0x34, 0x34, 0x34, 0x37, 0x37, 0x3B, 0x3D, 0x3D, 0x3E ;Row 8
    .byte 0x2F, 0x2F, 0x2F, 0x2F, 0x30, 0x31, 0x31, 0x33, 0x35, 0x35, 0x35, 0x37, 0x37, 0x3B, 0x39, 0x39, 0x39 ;Row 9
    .byte 0x2A, 0x2A, 0x2A, 0x2A, 0x2B, 0x2B, 0x2B, 0x2F, 0x33, 0x35, 0x35, 0x36, 0x36, 0x38, 0x38, 0x38, 0x38 ;Row 10
    .byte 0x26, 0x26, 0x26, 0x26, 0x26, 0x26, 0x26, 0x2B, 0x31, 0x36, 0x36, 0x36, 0x36, 0x36, 0x38, 0x37, 0x37 ;Row 11
    .byte 0x23, 0x23, 0x23, 0x23, 0x23, 0x23, 0x23, 0x23, 0x23, 0x26, 0x28, 0x2C, 0x2F, 0x33, 0x34, 0x36, 0x37 ;Row 12
    .byte 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1E, 0x1E, 0x20, 0x23, 0x24, 0x26, 0x2A, 0x2C, 0x31, 0x32, 0x34, 0x34 ;Row 13
    .byte 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x1B, 0x1E, 0x27, 0x26, 0x28, 0x26, 0x2B, 0x30, 0x31, 0x31 ;Row 14
    .byte 0x19, 0x1A, 0x1A, 0x1B, 0x1C, 0x1E, 0x1F, 0x1F, 0x20, 0x20, 0x22, 0x24, 0x24, 0x2A, 0x2B, 0x2C, 0x2E ;Row 15
    .byte 0x19, 0x1A, 0x1A, 0x1A, 0x1B, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x24, 0x24, 0x2A, 0x2B, 0x2C, 0x2C ;Row 16
    .byte 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1E, 0x21, 0x24, 0x2A, 0x2A, 0x2A ;Row 17

	;.org	0x81f1
WOTMPH_FullThrottleTimingFromHiMAP:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0x0240
    ;mptbltype 7
    ;mpsubtype n
    ;mptbllname FullThrottleTimingFromHiMAP
    ;mptblcname WOTMPH
    ;mpxaxis RPMLO:RPMHI 800 6112 rpm
    ;mpyaxis MAPHI 0 127.5 deg
    ;mptbldesc Description
    ;mp3dxtable RPMLO RPMHI
    ;mp3dytable MAPHI 
    .byte 0x11                       ;Number of rows in table
    .byte 0x11                       ;Number of cols in table
    .byte 0x00                       ;00 = unsigned, 80/FF = signed
    .byte 0x23, 0x23, 0x28, 0x2A, 0x2D, 0x31, 0x37, 0x3A, 0x3B, 0x3D, 0x3D, 0x41, 0x42, 0x43, 0x44, 0x44, 0x44 ;Row 1
    .byte 0x26, 0x26, 0x2B, 0x2C, 0x2E, 0x31, 0x37, 0x3A, 0x3B, 0x3D, 0x3D, 0x41, 0x42, 0x43, 0x44, 0x44, 0x44 ;Row 2
    .byte 0x29, 0x29, 0x2E, 0x2E, 0x2F, 0x31, 0x32, 0x35, 0x37, 0x37, 0x37, 0x3E, 0x40, 0x41, 0x42, 0x42, 0x42 ;Row 3
    .byte 0x2C, 0x2C, 0x2E, 0x30, 0x30, 0x31, 0x31, 0x34, 0x36, 0x37, 0x37, 0x3B, 0x3E, 0x3F, 0x42, 0x42, 0x42 ;Row 4
    .byte 0x2F, 0x2F, 0x30, 0x31, 0x31, 0x31, 0x31, 0x33, 0x36, 0x37, 0x37, 0x39, 0x3D, 0x3D, 0x42, 0x42, 0x42 ;Row 5
    .byte 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x32, 0x34, 0x35, 0x35, 0x38, 0x3A, 0x3C, 0x41, 0x42, 0x42 ;Row 6
    .byte 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x32, 0x33, 0x33, 0x34, 0x37, 0x38, 0x3C, 0x41, 0x41, 0x41 ;Row 7
    .byte 0x30, 0x30, 0x30, 0x30, 0x30, 0x31, 0x31, 0x32, 0x34, 0x34, 0x34, 0x37, 0x37, 0x3B, 0x3D, 0x3D, 0x3E ;Row 8
    .byte 0x2F, 0x2F, 0x2F, 0x2F, 0x30, 0x31, 0x31, 0x33, 0x35, 0x35, 0x35, 0x37, 0x37, 0x3B, 0x39, 0x39, 0x39 ;Row 9
    .byte 0x2A, 0x2A, 0x2A, 0x2A, 0x2B, 0x2B, 0x2B, 0x2F, 0x33, 0x35, 0x35, 0x36, 0x36, 0x38, 0x38, 0x38, 0x38 ;Row 10
    .byte 0x26, 0x26, 0x26, 0x26, 0x32, 0x33, 0x32, 0x2E, 0x31, 0x36, 0x36, 0x36, 0x36, 0x36, 0x38, 0x37, 0x37 ;Row 11
    .byte 0x23, 0x23, 0x23, 0x23, 0x23, 0x23, 0x23, 0x23, 0x30, 0x30, 0x37, 0x39, 0x3C, 0x3D, 0x3E, 0x41, 0x44 ;Row 12
    .byte 0x1C, 0x1C, 0x1C, 0x1C, 0x1C, 0x1E, 0x1E, 0x20, 0x32, 0x34, 0x37, 0x48, 0x42, 0x45, 0x45, 0x48, 0x4C ;Row 13
    .byte 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x1B, 0x2C, 0x34, 0x38, 0x3B, 0x3F, 0x40, 0x40, 0x41, 0x40 ;Row 14
    .byte 0x19, 0x1A, 0x1A, 0x1B, 0x1C, 0x1E, 0x1F, 0x1F, 0x22, 0x26, 0x2A, 0x32, 0x37, 0x3A, 0x37, 0x37, 0x36 ;Row 15
    .byte 0x19, 0x1A, 0x1A, 0x1A, 0x1B, 0x1C, 0x1C, 0x1C, 0x22, 0x23, 0x27, 0x2C, 0x30, 0x31, 0x2B, 0x2B, 0x2B ;Row 16
    .byte 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x19, 0x22, 0x22, 0x26, 0x2B, 0x2F, 0x30, 0x2A, 0x2A, 0x2A ;Row 17

	;.org	0x8315
IDLMOD_AdvanceModifier3DIdle:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0x0262
    ;mptbltype 7
    ;mpsubtype n
    ;mptbllname AdvanceModifier3DIdle
    ;mptblcname IDLMOD
    ;mpxaxis RPMLO:RPMHI 800 6112 rpm
    ;mpyaxis MAPLO 0 199 percent
    ;mptbldesc Description
    ;mp3dxtable RPMLO RPMHI
    ;mp3dytable MAPLO 
    .byte 0x09                       ;Number of rows in table
    .byte 0x11                       ;Number of cols in table
    .byte 0xFF                       ;00 = unsigned, 80/FF = signed
    .byte 0x06, 0x00, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 1
    .byte 0x06, 0x00, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 2
    .byte 0x06, 0x00, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 3
    .byte 0x06, 0x00, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 4
    .byte 0x06, 0x00, 0xFC, 0xFC, 0xFC, 0xFC, 0xF9, 0xF9, 0xF9, 0xFB, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 5
    .byte 0x06, 0x00, 0xFC, 0xFC, 0xFC, 0xFC, 0xF6, 0xF6, 0xF6, 0xFA, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 6
    .byte 0x09, 0x03, 0xFF, 0xFF, 0xFF, 0xF9, 0xF6, 0xF6, 0xF6, 0xFA, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 7
    .byte 0x0F, 0x0A, 0x06, 0x00, 0xFC, 0xF6, 0xF6, 0xF6, 0xF6, 0xFA, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 8
    .byte 0x10, 0x0B, 0x06, 0xFC, 0xFA, 0xF6, 0xF6, 0xF6, 0xF6, 0xFA, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 9

	;.org	0x83b1
THRMOD_AdvanceModifier3DNormal:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0x027C
    ;mptbltype 7
    ;mpsubtype n
    ;mptbllname AdvanceModifier3DNormal
    ;mptblcname THRMOD
    ;mpxaxis RPMLO:RPMHI 800 6112 rpm
    ;mpyaxis MAPHI 0 199 percent
    ;mptbldesc Description
    ;mp3dxtable RPMLO RPMHI
    ;mp3dytable MAPHI 
    .byte 0x11                       ;Number of rows in table
    .byte 0x11                       ;Number of cols in table
    .byte 0xFF                       ;00 = unsigned, 80/FF = signed
    .byte 0x10, 0x0B, 0x06, 0xFC, 0xFA, 0xF6, 0xF6, 0xF6, 0xF6, 0xFA, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 1
    .byte 0x0A, 0x04, 0xFC, 0xFA, 0xFA, 0xFA, 0xFA, 0xFA, 0xFA, 0xFC, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 2
    .byte 0x06, 0x00, 0x00, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0xFC, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 3
    .byte 0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 4
    .byte 0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 5
    .byte 0x06, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 6
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 7
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 8
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 9
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 10
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 11
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 12
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 13
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 14
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 15
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 16
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 17

	;.org	0x84d5
TMPSWP_EngTempSwitchPointForSparkAdvance:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0x029E
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname EngTempSwitchPointForSparkAdvance
    ;mptblcname TMPSWP
    ;mpxaxis Coolant_Temp -200 260 F
    ;mpyaxis Factor 0 100 %
    ;mptbldesc Multiplier_for_THRMOD_3D_table.
    .byte 0x02                       ;Number of points in table
    .byte 0xAB, 0xFF, 0xD5, 0x80     ;Point 1
    .byte 0xB1, 0x00                 ;Point 2

	;.org	0x84e4
SPKLMT_TotalAdvanceAllowed:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0x02AD
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname TotalAdvanceAllowed
    ;mptblcname SPKLMT
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc Description
    .byte 0x02                       ;Number of points in table
    .byte 0x7D, 0x6A, 0xFF, 0xB9     ;Point 1
    .byte 0xDB, 0x50                 ;Point 2

	;.org	0x84ef
ADO2CL_AdvanceAddedFromO2FeedbackCounterLimitLow:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0x02BC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdvanceAddedFromO2FeedbackCounterLimitLow
    ;mptblcname ADO2CL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x1A                       ;Point 1

	;.org	0x84f0
ADO2CH_AdvanceAddedFromO2FeedbackCounterLimitHi:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0x02C9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdvanceAddedFromO2FeedbackCounterLimitHi
    ;mptblcname ADO2CH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xE6                       ;Point 1

	;.org	0x84f1
ADO2C1_AdvanceAddedFromO2FeedbackCounter1:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0x02D6
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AdvanceAddedFromO2FeedbackCounter1
    ;mptblcname ADO2C1
    ;mpxaxis Counter 0 255 count
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc Description
    .byte 0x03                       ;Number of points in table
    .byte 0x70, 0x04, 0xFF, 0xC0     ;Point 1
    .byte 0x80, 0x00, 0xFF, 0xC0     ;Point 2
    .byte 0x90, 0xFC                 ;Point 3

	;.org	0x8504
ADO2C2_AdvanceAddedFromO2FeedbackCounter2:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0x02E6
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AdvanceFromRpmMAX
    ;mptblcname ADO2C2
    ;mpxaxis Counter2 0 255 count
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc Description
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0x850f
KNKRPM_MinRpmforKnockRetard:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0x02F4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinRpmforKnockRetard
    ;mptblcname KNKRPM
    ;mpxaxis X 0 255 in
    ;mpyaxis RPM 0 8160 RPM
    ;mptbldesc Minimum_RPM_for_Knock_Retard
    .byte 0x20                       ;Point 1

	;.org	0x8510
KNKOFS_DeltaAboveBaroFor_RTRDRT_and_KNKCNT_and_KNKCOR_incremented:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0x0301
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaAboveBaroFor_RTRDRT_and_KNKCNT_and_KNKCOR_incremented
    ;mptblcname KNKOFS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc Delta_above_Baro_up_to_which_RTRDRT_(Retard_Rate)_is_used_and_KNKCNT_and_KNKCOR_are_incremented._Stock_is_5.4_psi.
    ;mpmapaxis y
    .byte 0x2F                       ;Point 1

	;.org	0x8511
RTRDRT_KnockRetardRateNoBoost:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0x030F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardRateNoBoost
    ;mptblcname RTRDRT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Deg 0 127.5 Degrees
    ;mptbldesc Retard_rate_from_Knock,_no_boost._In_half_degreesn
    .byte 0x09                       ;Point 1

	;.org	0x8512
RTRDRT2_KnockRetardRateInBoost:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0x031C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardRateInBoost
    ;mptblcname RTRDRT2
    ;mpxaxis IN 0 255 X
    ;mpyaxis Retard 0 127.5 deg
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1

	;.org	0x8513
INCSRT_KnockRetardIncreaseRate:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0x0329
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardIncreaseRate
    ;mptblcname INCSRT
    ;mpxaxis in_desc 0 255 retard
    ;mpyaxis Y 0 127.5 deg
    ;mptbldesc Increase_Rate._Recovery_from_Knock_Retard._Rate_is_1/2_engine_degree_every_INCSRT+1_*_11ms._Use_ONLY_0,1,3,7,f,1f,3f,7f_or_ff
    .byte 0x0F                       ;Point 1

	;.org	0x8514
RETMAX_MaxKnockRetardFromMap:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0x0336
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname MaxKnockRetardFromMap
    ;mptblcname RETMAX
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Max_Retard 0 127.5 degrees
    ;mptbldesc Maximum_Knock_Retard_from_Map
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x56, 0x06, 0x00, 0xBB     ;Point 1
    .byte 0x70, 0x19                 ;Point 2

	;.org	0x851f
KNKLIM_MaxKnockRetard:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0x0346
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxKnockRetard
    ;mptblcname KNKLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Retard 0 127.5 Degrees
    ;mptbldesc Knock_Limit_in_1/2_degrees._MaxRetard_=_KNKLIM_if_throttle_is_above_THRKNK_and_RPM_is_below_KLMRPM
    .byte 0x06                       ;Point 1

	;.org	0x8520
THRKNK_DeltaAbove_MINTHR:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0x0353
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaAbove_MINTHR
    ;mptblcname THRKNK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis TPS 0 5 Volts
    ;mptbldesc Delta_above_MINTHR_for_knock_detect
    .byte 0x53                       ;Point 1

	;.org	0x8521
KLMRPM_MinKnockDetectRpm:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0x0360
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinKnockDetectRpm
    ;mptblcname KLMRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 RPM
    ;mptbldesc RPMS_for_Knock
    .byte 0x20                       ;Point 1

	;.org	0x8522
DLTKNK_KnockSensorVoltageForKnockFromRpm:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0x036D
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname KnockSensorVoltageForKnock_FromRpm
    ;mptblcname DLTKNK
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis A2D 0 5 volts
    ;mptbldesc Input_from_the_knock_sensor_that_is_above_this_voltage_is_considered_Knock.
    .byte 0x05                       ;Number of points in table
    .byte 0x2E, 0x15, 0x00, 0x80     ;Point 1
    .byte 0x4E, 0x25, 0x00, 0x00     ;Point 2
    .byte 0x6D, 0x25, 0x01, 0x6E     ;Point 3
    .byte 0x90, 0x57, 0x01, 0xC0     ;Point 4
    .byte 0xBC, 0xA4                 ;Point 5

	;.org	0x8539
KNENRC_KnockRetardEnrichment: ;EMRETB_EmergencyRetardInBoostFromRPM:
    ;mpgrp Spark\Adaptive_Retard\
    ;mptbladdr 0x037F
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname EmergencyRetardInBoostFromRPM
    ;mptblcname EMRETB
    ;mpxaxis Retard 0 127.5 deg
    ;mpyaxis factor 0 100 percent
    ;mptbldesc Fuel_added_from_knock_retard_when_in_boost.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0x8544
EMBSLM_KnockEnrichmentBoostSetpoint:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0x038D
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname EmergencyRetardBoostEnableSetpoint
    ;mptblcname EMBSLM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Knock_enrichment_is_active_above_this_boost.
    ;mpmapaxis y
    .byte 0x7A                       ;Point 1

	;.org	0x8545
ARRPMP_AdaptiveRetardAdvanceFromRPMAndMAP3D:
    ;mpgrp Spark\Adaptive_Retard\
    ;mptbladdr 0x039B
    ;mptbltype 7
    ;mpsubtype n
    ;mptbllname AdaptiveRetardAdvanceFromRPMAndMAP3D
    ;mptblcname ARRPMP
    ;mpxaxis RPMLO:RPMHI:-128:*2 2048 6112 rpm
    ;mpyaxis ARMPMD 0 255 index
    ;mptbldesc Description
    ;mp3dxtable RPMLO RPMHI
    ;mp3dxformula -128:*2
    ;mp3dytable ARMPMD 
    .byte 0x09                       ;Number of rows in table
    .byte 0x09                       ;Number of cols in table
    .byte 0x00                       ;00 = unsigned, 80/FF = signed
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 1
    .byte 0x04, 0x04, 0x04, 0x04, 0x08, 0x08, 0x08, 0x08, 0x08 ;Row 2
    .byte 0x04, 0x04, 0x04, 0x04, 0x08, 0x08, 0x08, 0x08, 0x08 ;Row 3
    .byte 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09 ;Row 4
    .byte 0x0B, 0x0B, 0x0B, 0x0F, 0x11, 0x11, 0x11, 0x11, 0x11 ;Row 5
    .byte 0x0B, 0x0B, 0x0B, 0x0F, 0x16, 0x16, 0x16, 0x16, 0x16 ;Row 6
    .byte 0x11, 0x11, 0x11, 0x19, 0x19, 0x19, 0x19, 0x19, 0x19 ;Row 7
    .byte 0x11, 0x11, 0x19, 0x19, 0x19, 0x19, 0x19, 0x19, 0x19 ;Row 8
    .byte 0x11, 0x11, 0x19, 0x19, 0x19, 0x19, 0x19, 0x19, 0x19 ;Row 9

	;.org	0x8599
ARINDX_AdaptiveRetardIndexBase_80:
    ;mpgrp Spark\Adaptive_Retard\
    ;mptbladdr 0x03B6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardIndexBase_80
    ;mptblcname ARINDX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x80                       ;Point 1

	;.org	0x859a
ARSUBC_AdaptiveRetardFactorSubtract:
    ;mpgrp Spark\Adaptive_Retard\
    ;mptbladdr 0x03C3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardFactorSubtract
    ;mptblcname ARSUBC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x40                       ;Point 1

	;.org	0x859b
ARCMSK_AdaptiveRetardCounterMask:
    ;mpgrp Spark\Adaptive_Retard\
    ;mptbladdr 0x03D0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardCounterMask
    ;mptblcname ARCMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x3F                       ;Point 1

	;.org	0x859c
ARTM5P_AdaptiveRetardTimeOver5psiBoost:
    ;mpgrp Spark\Adaptive_Retard\
    ;mptbladdr 0x03DD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardTimeOver5psiBoost
    ;mptblcname ARTM5P
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x09                       ;Point 1

	;.org	0x859d
ARMINT_AdaptiveRetardMinimumTemp:
    ;mpgrp Spark\Adaptive_Retard\
    ;mptbladdr 0x03EA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardMinimumTemp
    ;mptblcname ARMINT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 degrees
    ;mptbldesc Detailed_Description
    .byte 0xB1                       ;Point 1

	;.org	0x859e
ARCMS2_AdaptiveRetardCounterMask2_00:
    ;mpgrp Spark\Adaptive_Retard\
    ;mptbladdr 0x03F7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardCounterMask2_00
    ;mptblcname ARCMS2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x859f
ARCMS3_AdaptiveRetardCounterMask3_FF:
    ;mpgrp Spark\Adaptive_Retard\
    ;mptbladdr 0x0404
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardCounterMask3_FF
    ;mptblcname ARCMS3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x85a0
SSTEMP_TempAboveWhichSparkScatterIsActive:
    ;mpgrp Spark\Scatter_Control\
    ;mptbladdr 0x0411
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TempAboveWhichSparkScatterIsActive
    ;mptblcname SSTEMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Temperature_above_which_spark_scatter_is_active._For_road_racing,_the_MP_cal_has_this_set_to_0xfe._This_keeps_the_revs_higher_during_shifts.
    .byte 0x58                       ;Point 1

	;.org	0x85a1
FTUNPW_FineTuneStepForAis:
    ;mpgrp Spark\Scatter_Control\
    ;mptbladdr 0x041E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FineTuneStepForAis
    ;mptblcname FTUNPW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Fine_Tune_Step_for_AIS_for_spark_scatter
    .byte 0x01                       ;Point 1

	;.org	0x85a2
SSITIM_ScatterInhibitTime:
    ;mpgrp Spark\Scatter_Control\
    ;mptbladdr 0x042B
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ScatterInhibitTime
    ;mptblcname SSITIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Spark_Scatter_Inhibit_Time_in_11ms_per_bit
    .word 0x0088                     ;Point 1

	;.org	0x85a4
SSIPRD_ScatterInhibitBelowThisSpeed:
    ;mpgrp Spark\Scatter_Control\
    ;mptbladdr 0x0438
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ScatterInhibitBelowThisSpeed
    ;mptblcname SSIPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Spark_Scatter_inhibited_below_this_speed._The_MP_MTX_cal_has_this_value_set_to_0xfe33_to_keep_the_revs_high_during_shifts.
    .word 0x0066                     ;Point 1

	;.org	0x85a6
RPMFRT_SparkAdvanceRPMFilterRatio:
    ;mpgrp Spark\Scatter_Control\
    ;mptbladdr 0x0445
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkAdvanceRPMFilterRatio
    ;mptblcname RPMFRT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Factor 0 1 factor
    ;mptbldesc Detailed_Description
    .byte 0x7F                       ;Point 1

	;.org	0x85a7
RPMFPS_SparkAdvanceRPMFilterLimitPos:
    ;mpgrp Spark\Scatter_Control\
    ;mptbladdr 0x0452
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname SparkAdvanceRPMFilterLimitPos
    ;mptblcname RPMFPS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Description
    .word 0x0190                     ;Point 1

	;.org	0x85a9
RPMFNG_SparkAdvanceRPMFilterLimitNeg:
    ;mpgrp Spark\Scatter_Control\
    ;mptbladdr 0x045F
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname SparkAdvanceRPMFilterLimitNeg
    ;mptblcname RPMFNG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Description
    .word 0x0190                     ;Point 1

	;.org	0x85ab
SPKADD_SparkAdvanceAddedWhenRpmBelowControl_FromDeltaRpm:
    ;mpgrp Spark\Scatter_Control\
    ;mptbladdr 0x046C
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname SparkAdvanceAddedWhenRpmBelowControl_FromDeltaRpm
    ;mptblcname SPKADD
    ;mpxaxis DeltaRPM 0 512 RPM
    ;mpyaxis Advance 0 127.5 degrees
    ;mptbldesc This_is_how_much_advance_is_added_to_increase_engine_speed.
    .byte 0x03                       ;Number of points in table
    .byte 0x05, 0x00, 0x00, 0x89     ;Point 1
    .byte 0x14, 0x08, 0x00, 0x66     ;Point 2
    .byte 0x28, 0x10                 ;Point 3

	;.org	0x85b6
SPKAD2_SparkAdvanceAddedWhenRpmBelowControl2_FromDeltaRpm:
    ;mpgrp Spark\Scatter_Control\
    ;mptbladdr 0x047C
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname SparkAdvanceAddedWhenRpmBelowControl2_FromDeltaRpm
    ;mptblcname SPKAD2
    ;mpxaxis DeltaRPM 0 512 RPM
    ;mpyaxis Advance 0 127.5 degrees
    ;mptbldesc This_is_how_much_advance_is_added_to_increase_engine_speed.
    .byte 0x03                       ;Number of points in table
    .byte 0x05, 0x00, 0x00, 0x89     ;Point 1
    .byte 0x14, 0x08, 0x00, 0x66     ;Point 2
    .byte 0x28, 0x10                 ;Point 3

	;.org	0x85c1
SPKRET_SparkAdvanceRetardedWhenRpmAboveControl_FromDeltaRpm:
    ;mpgrp Spark\Scatter_Control\
    ;mptbladdr 0x048C
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname SparkAdvanceRetardedWhenRpmAboveControl_FromDeltaRpm
    ;mptblcname SPKRET
    ;mpxaxis DeltaRPM 0 512 rpm
    ;mpyaxis Advance 0 127.5 degrees
    ;mptbldesc This_is_how_much_advance_is_removed_to_decrease_engine_speed
    .byte 0x02                       ;Number of points in table
    .byte 0x05, 0x00, 0xFF, 0xAE     ;Point 1
    .byte 0x1E, 0xF8                 ;Point 2

	;.org	0x85cc
SPKRT2_SparkAdvanceRetardedWhenRpmAboveControl2_FromDeltaRpm:
    ;mpgrp Spark\Scatter_Control\
    ;mptbladdr 0x049B
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname SparkAdvanceRetardedWhenRpmAboveControl2_FromDeltaRpm
    ;mptblcname SPKRT2
    ;mpxaxis DeltaRPM 0 512 rpm
    ;mpyaxis Advance 0 127.5 degrees
    ;mptbldesc This_is_how_much_advance_is_removed_to_decrease_engine_speed
    .byte 0x02                       ;Number of points in table
    .byte 0x05, 0x00, 0xFF, 0xAE     ;Point 1
    .byte 0x1E, 0xF8                 ;Point 2

	;.org	0x85d7
IDLADD_FuelStabilization_FromDeltaRPM:
    ;mpgrp Spark\Scatter_Control\
    ;mptbladdr 0x04AA
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStabilization_FromDeltaRPM
    ;mptblcname IDLADD
    ;mpxaxis DeltaRPMNeg 0 512 rpm
    ;mpyaxis Pulsewidth 0 0.511 mSec
    ;mptbldesc This_is_how_much_fuel_is_added_or_subtracted_to_increase_or_decrease_speed
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x03, 0x00, 0x03, 0x79     ;Point 1
    .byte 0x16, 0x42, 0x01, 0xD5     ;Point 2
    .byte 0x4B, 0xA3                 ;Point 3

	;.org	0x85e2
IDLSUB_FuelStabilizationSubtract_FromDeltaRPM:
    ;mpgrp Spark\Scatter_Control\
    ;mptbladdr 0x04BB
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStabilizationSubtract_FromDeltaRPM
    ;mptblcname IDLSUB
    ;mpxaxis DeltaRPMPos 0 512 rpm
    ;mpyaxis Pulsewidth 0 0.511 mSec
    ;mptbldesc This_is_how_much_fuel_is_added_or_subtracted_to_increase_or_decrease_speed
    ;mpinjscale scale
    .byte 0x02                       ;Number of points in table
    .byte 0x05, 0x00, 0x02, 0x1E     ;Point 1
    .byte 0x16, 0x24                 ;Point 2

	;.org	0x85ed
IDLTMP_Use_IDLADD_AboveThisTemp:
    ;mpgrp Spark\Scatter_Control\
    ;mptbladdr 0x04CB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Use_IDLADD_AboveThisTemp
    ;mptblcname IDLTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 degF
    ;mptbldesc IDLADD_enabled_when_engine_temp_is_above_IDLTMP
    .byte 0x8A                       ;Point 1

	;.org	0x85ee
STRNTR_SparkStartRunTransferPointRpm:
    ;mpgrp Spark\Start_to_Run_Transfer\
    ;mptbladdr 0x04D8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkStartRunTransferPointRpm
    ;mptblcname STRNTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DistPW 0 2.55 mSec
    ;mptbldesc Start_to_Run_transfer_point
    .byte 0x62                       ;Point 1

	;.org	0x85ef
RNSTTR_SparkRunStartTransferPointRpm:
    ;mpgrp Spark\Start_to_Run_Transfer\
    ;mptbladdr 0x04E5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkRunStartTransferPointRpm
    ;mptblcname RNSTTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DistPW 0 2.55 mSec
    ;mptbldesc Run_to_Start_transfer_point
    .byte 0x82                       ;Point 1

	;.org	0x85f0
RNFPRD_FuelStartRunTransferPointRpm:
    ;mpgrp Spark\Start_to_Run_Transfer\
    ;mptbladdr 0x04F2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FuelStartRunTransferPointRpm
    ;mptblcname RNFPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Start_to_Run_transfer_point_for_fuel
    .byte 0x60                       ;Point 1

	;.org	0x85f1
STFPRD_FuelRunStartTransferPointRpm:
    ;mpgrp Spark\Start_to_Run_Transfer\
    ;mptbladdr 0x04FF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FuelRunStartTransferPointRpm
    ;mptblcname STFPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Run_to_Start_transfer_point_for_spark
    .byte 0x82                       ;Point 1

	;.org	0x85f2
SRTMTP_SparkTempSwitchPointFor_SRTIME:
    ;mpgrp Spark\Start_to_Run_Transfer\
    ;mptbladdr 0x050C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkTempSwitchPointFor_SRTIME
    ;mptblcname SRTMTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Engine_Temperature_switch_point_for_SRTIME
    .byte 0x58                       ;Point 1

	;.org	0x85f3
SRTIME_SparkEPPsNeededToBeAboveSR_Hot:
    ;mpgrp Spark\Start_to_Run_Transfer\
    ;mptbladdr 0x0519
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkEPPsNeededToBeAboveSR_Hot
    ;mptblcname SRTIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_consecutive_EPPs_needed_to_be_above_Start_Run_when_hot
    .byte 0x04                       ;Point 1

	;.org	0x85f4
PCCSFE_PercentForColdStartFuelEnrichment:
    ;mpgrp Spark\Start_to_Run_Transfer\
    ;mptbladdr 0x0526
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname PercentForColdStartFuelEnrichment
    ;mptblcname PCCSFE
    ;mpxaxis Coolant_Temp -200 260 Degrees
    ;mpyaxis Factor 0 1 factor
    ;mptbldesc Description
    .byte 0x02                       ;Number of points in table
    .byte 0x16, 0x01, 0x44, 0x00     ;Point 1
    .byte 0x19, 0xCD                 ;Point 2

	;.org	0x8603
STRTFL_FuelStartFromCoolantTemp:
    ;mpgrp Fuel\Starting\
    ;mptbladdr 0x0535
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname StartFuel_FromTemp
    ;mptblcname STRTFL
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis sqrtPW 0 222 uSec
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4
    ;mpinjscale sqrt
    .byte 0x08                       ;Number of points in table
    .byte 0x5E, 0x6B, 0x00, 0x00     ;Point 1
    .byte 0x63, 0x6B, 0xFF, 0x17     ;Point 2
    .byte 0x6E, 0x61, 0xFE, 0xAF     ;Point 3
    .byte 0x84, 0x44, 0xFE, 0xAB     ;Point 4
    .byte 0x90, 0x34, 0xFF, 0x5D     ;Point 5
    .byte 0x9B, 0x2D, 0xFF, 0xAB     ;Point 6
    .byte 0xC2, 0x20, 0xFF, 0x5D     ;Point 7
    .byte 0xCD, 0x19                 ;Point 8

	;.org	0x862a
STRLMT_ColdestTempAllowedAtClosedThrottle:
    ;mpgrp Fuel\Starting\
    ;mptbladdr 0x054B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ColdestTempAllowedAtClosedThrottle
    ;mptblcname STRLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Coldest_temperature_accepted_as_input_to_STRTFL_table_-_anything_below_this_value_will_be_replaced_with_this_value
    .byte 0x69                       ;Point 1

	;.org	0x862b
STFTMP_FuelStartFuelFromCoolant:
    ;mpgrp Fuel\Starting\
    ;mptbladdr 0x0558
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartFuelFromCoolant
    ;mptblcname STFTMP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Inverse 0 1 factor
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4
    .byte 0x02                       ;Number of points in table
    .byte 0x63, 0xFF, 0xFC, 0xF3     ;Point 1
    .byte 0xA0, 0x45                 ;Point 2

	;.org	0x863a
EPPMUL_FuelStartFuelPerEPP:
    ;mpgrp Fuel\Starting\
    ;mptbladdr 0x0567
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartFuelPerEPP
    ;mptblcname EPPMUL
    ;mpxaxis EPPs 0 255 count
    ;mpyaxis Multiplier 0 1 factor
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4._This_table_decreases_fuel_for_each_engine_rotation_while_starting
    .byte 0x02                       ;Number of points in table
    .byte 0x0B, 0x00, 0x1A, 0xB7     ;Point 1
    .byte 0x12, 0xBB                 ;Point 2

	;.org	0x8645
STFTM2_FuelStartFuelFromCoolant2:
    ;mpgrp Fuel\Starting\
    ;mptbladdr 0x0576
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartFuelFromCoolant2
    ;mptblcname STFTM2
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Inverse 0 1 factor
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4
    .byte 0x02                       ;Number of points in table
    .byte 0x90, 0x4D, 0x01, 0x51     ;Point 1
    .byte 0xA6, 0x6A                 ;Point 2

	;.org	0x864c
STFBAR_FuelStartReductionFromBaro:
    ;mpgrp Fuel\Starting\
    ;mptbladdr 0x0585
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FuelStartReductionFromBaro
    ;mptblcname STFBAR
    ;mpxaxis Baro -14.7 14.7 psi
    ;mpyaxis Inverse 0 1 factor
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4._This_decreases_fuel_slightly_at_higher_altitudes_to_account_for_thinner_air.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x6A, 0xB3, 0xF4, 0xD0     ;Point 1
    .byte 0x7A, 0x00                 ;Point 2

	;.org	0x8657
SFDCAY_FuelStartDecayIntoRun:
    ;mpgrp Fuel\Starting\
    ;mptbladdr 0x0595
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartDecayIntoRun
    ;mptblcname SFDCAY
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Subtracted 0 255 ms/rev
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4._This_allows_fuel_to_decay_gradually_after_the_start-run_transition.
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x63, 0x1B, 0xFF, 0x72     ;Point 1
    .byte 0x90, 0x02, 0xFF, 0xFC     ;Point 2
    .byte 0xCC, 0x01                 ;Point 3

	;.org	0x8666
PRSHOT_KeyOnPrimePW:
    ;mpgrp Fuel\Starting\
    ;mptbladdr 0x05A6
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname KeyOnPrimePW
    ;mptblcname PRSHOT
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Pulsewidth 0 255 mSec
    ;mptbldesc Prime_Fuel_Shot_before_cranking
    ;mpinjscale scale
    .byte 0x04                       ;Number of points in table
    .byte 0x63, 0x41, 0xFE, 0xC2     ;Point 1
    .byte 0x84, 0x18, 0xFF, 0x97     ;Point 2
    .byte 0xA6, 0x0A, 0xFF, 0xE4     ;Point 3
    .byte 0xDD, 0x04                 ;Point 4

	;.org	0x8675
DFPART_DensityFactorPartThrottle:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0x05B8
    ;mptbltype 4
    ;mpsubtype 1
    ;mptbllname DensityFactorPartThrottle
    ;mptblcname DFPART
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Factor 0 255 factor
    ;mptbldesc DensityFactor_for_part_throttle._Multiplied_by_MAP_and_the_3D_table_value.
    ;mpmapaxis -y
    ;mpinjscale scale
    .word 0x2300                     ;Point 1

	;.org	0x8677
DFFULL_DensityFactorFullThrottle:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0x05C7
    ;mptbltype 4
    ;mpsubtype 1
    ;mptbllname DensityFactorFullThrottle
    ;mptblcname DFFULL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Factor 0 255 factor
    ;mptbldesc DensityFactor_for_full_throttle._Multiplied_by_MAP_and_the_3D_table_value.
    ;mpmapaxis -y
    ;mpinjscale scale
    .word 0x2200                     ;Point 1

	;.org	0x8679
PRTTBL_FuelPartThrottleFromLoMap:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0x05D6
    ;mptbltype 7
    ;mpsubtype n
    ;mptbllname FuelPartThrottleFromLoMap
    ;mptblcname PRTTBL
    ;mpxaxis RPMLO:RPMHI 800 6112 rpm
    ;mpyaxis MAPLO 0.8 100 factor
    ;mptbldesc Only_used_when_MAP_is_below_-7.4psi
    ;mp3dxtable RPMLO RPMHI
    ;mp3dytable MAPLO 
    .byte 0x09                       ;Number of rows in table
    .byte 0x11                       ;Number of cols in table
    .byte 0x00                       ;00 = unsigned, 80/FF = signed
    .byte 0x3E, 0x3E, 0x3E, 0x3E, 0x3E, 0x3E, 0x42, 0x44, 0x3E, 0x42, 0x40, 0x3E, 0x42, 0x43, 0x47, 0x47, 0x47 ;Row 1
    .byte 0x3E, 0x3E, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x42, 0x3E, 0x3F, 0x43, 0x42, 0x4A, 0x4F, 0x4F, 0x4F ;Row 2
    .byte 0x45, 0x45, 0x45, 0x45, 0x45, 0x47, 0x46, 0x48, 0x47, 0x47, 0x48, 0x44, 0x4B, 0x4B, 0x56, 0x56, 0x56 ;Row 3
    .byte 0x4A, 0x4A, 0x4A, 0x4B, 0x4B, 0x4D, 0x4B, 0x4E, 0x4A, 0x4D, 0x4D, 0x49, 0x51, 0x57, 0x5B, 0x5B, 0x5B ;Row 4
    .byte 0x50, 0x50, 0x50, 0x54, 0x54, 0x56, 0x52, 0x54, 0x51, 0x54, 0x53, 0x53, 0x57, 0x5D, 0x61, 0x61, 0x61 ;Row 5
    .byte 0x55, 0x57, 0x58, 0x59, 0x59, 0x5B, 0x59, 0x5D, 0x57, 0x59, 0x59, 0x56, 0x5B, 0x62, 0x66, 0x66, 0x66 ;Row 6
    .byte 0x56, 0x58, 0x5A, 0x5B, 0x5B, 0x5D, 0x5C, 0x5E, 0x59, 0x5A, 0x5A, 0x58, 0x5D, 0x64, 0x68, 0x68, 0x68 ;Row 7
    .byte 0x57, 0x59, 0x5A, 0x5B, 0x5B, 0x5D, 0x5D, 0x5F, 0x5B, 0x5B, 0x5C, 0x5A, 0x5F, 0x65, 0x6A, 0x6A, 0x6A ;Row 8
    .byte 0x58, 0x5A, 0x5B, 0x5C, 0x5C, 0x5E, 0x5F, 0x60, 0x5C, 0x5C, 0x5D, 0x5B, 0x60, 0x67, 0x6B, 0x6B, 0x6B ;Row 9

	;.org	0x8715
PRTTBH_FuelPartThrottleFromHiMAP:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0x05F0
    ;mptbltype 7
    ;mpsubtype n
    ;mptbllname FuelPartThrottleFromHiMAP
    ;mptblcname PRTTBH
    ;mpxaxis RPMLO:RPMHI 800 6112 rpm
    ;mpyaxis MAPHI 0.8 100 factor
    ;mptbldesc Description
    ;mp3dxtable RPMLO RPMHI
    ;mp3dytable MAPHI 
    .byte 0x11                       ;Number of rows in table
    .byte 0x11                       ;Number of cols in table
    .byte 0x00                       ;00 = unsigned, 80/FF = signed
    .byte 0x58, 0x5A, 0x5B, 0x5C, 0x5C, 0x5E, 0x5F, 0x60, 0x5C, 0x5C, 0x5D, 0x5B, 0x60, 0x67, 0x6B, 0x6B, 0x6B ;Row 1
    .byte 0x59, 0x5B, 0x5C, 0x5D, 0x5D, 0x5F, 0x5F, 0x61, 0x5D, 0x5D, 0x5E, 0x5C, 0x61, 0x68, 0x6C, 0x6C, 0x6C ;Row 2
    .byte 0x5B, 0x5D, 0x5D, 0x5E, 0x5E, 0x60, 0x60, 0x63, 0x5F, 0x61, 0x60, 0x5D, 0x62, 0x69, 0x6D, 0x6D, 0x6D ;Row 3
    .byte 0x5C, 0x5E, 0x5F, 0x60, 0x5F, 0x61, 0x61, 0x64, 0x61, 0x61, 0x5E, 0x5D, 0x62, 0x69, 0x6E, 0x6E, 0x6E ;Row 4
    .byte 0x5F, 0x60, 0x61, 0x62, 0x62, 0x64, 0x64, 0x65, 0x63, 0x62, 0x60, 0x60, 0x65, 0x6C, 0x70, 0x70, 0x70 ;Row 5
    .byte 0x5F, 0x60, 0x61, 0x62, 0x61, 0x63, 0x63, 0x65, 0x63, 0x62, 0x61, 0x60, 0x65, 0x6C, 0x70, 0x70, 0x70 ;Row 6
    .byte 0x60, 0x61, 0x62, 0x63, 0x63, 0x63, 0x64, 0x66, 0x64, 0x64, 0x65, 0x64, 0x65, 0x6C, 0x70, 0x70, 0x70 ;Row 7
    .byte 0x60, 0x60, 0x61, 0x62, 0x61, 0x63, 0x64, 0x65, 0x64, 0x65, 0x65, 0x65, 0x66, 0x6D, 0x71, 0x71, 0x71 ;Row 8
    .byte 0x61, 0x61, 0x62, 0x62, 0x63, 0x64, 0x64, 0x66, 0x64, 0x65, 0x65, 0x65, 0x66, 0x6D, 0x71, 0x71, 0x71 ;Row 9
    .byte 0x61, 0x61, 0x62, 0x62, 0x63, 0x64, 0x64, 0x66, 0x64, 0x65, 0x65, 0x65, 0x66, 0x6D, 0x71, 0x71, 0x71 ;Row 10
    .byte 0x62, 0x62, 0x63, 0x63, 0x64, 0x66, 0x65, 0x66, 0x64, 0x65, 0x65, 0x66, 0x67, 0x6E, 0x72, 0x73, 0x73 ;Row 11
    .byte 0x72, 0x72, 0x73, 0x73, 0x74, 0x76, 0x75, 0x76, 0x74, 0x75, 0x75, 0x75, 0x77, 0x7E, 0x82, 0x83, 0x83 ;Row 12
    .byte 0x72, 0x72, 0x73, 0x73, 0x74, 0x76, 0x75, 0x76, 0x74, 0x75, 0x71, 0x71, 0x77, 0x7E, 0x82, 0x83, 0x83 ;Row 13
    .byte 0x72, 0x72, 0x73, 0x73, 0x74, 0x76, 0x75, 0x76, 0x74, 0x75, 0x71, 0x71, 0x77, 0x7E, 0x82, 0x83, 0x83 ;Row 14
    .byte 0x72, 0x72, 0x73, 0x73, 0x74, 0x76, 0x75, 0x76, 0x74, 0x75, 0x71, 0x71, 0x77, 0x7E, 0x82, 0x83, 0x83 ;Row 15
    .byte 0x72, 0x72, 0x73, 0x73, 0x74, 0x76, 0x75, 0x76, 0x74, 0x75, 0x71, 0x71, 0x77, 0x7E, 0x82, 0x83, 0x83 ;Row 16
    .byte 0x72, 0x72, 0x73, 0x73, 0x74, 0x76, 0x75, 0x76, 0x74, 0x75, 0x71, 0x71, 0x77, 0x7E, 0x82, 0x83, 0x83 ;Row 17

	;.org	0x8839
WOTTBL_FuelFullThrottleFromHiMAP:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0x0612
    ;mptbltype 7
    ;mpsubtype n
    ;mptbllname FuelFullThrottleFromHiMAP
    ;mptblcname WOTTBL
    ;mpxaxis RPMLO:RPMHI 800 6112 rpm
    ;mpyaxis MAPHI 0.8 100 factor
    ;mptbldesc Description
    ;mp3dxtable RPMLO RPMHI
    ;mp3dytable MAPHI 
    .byte 0x11                       ;Number of rows in table
    .byte 0x11                       ;Number of cols in table
    .byte 0x00                       ;00 = unsigned, 80/FF = signed
    .byte 0x65, 0x65, 0x65, 0x65, 0x65, 0x65, 0x65, 0x65, 0x65, 0x65, 0x65, 0x68, 0x6A, 0x6A, 0x6D, 0x6E, 0x6E ;Row 1
    .byte 0x68, 0x68, 0x68, 0x68, 0x68, 0x68, 0x68, 0x68, 0x68, 0x68, 0x68, 0x6A, 0x6B, 0x6C, 0x6F, 0x72, 0x72 ;Row 2
    .byte 0x69, 0x69, 0x69, 0x69, 0x69, 0x69, 0x69, 0x69, 0x69, 0x69, 0x6B, 0x6C, 0x6C, 0x6C, 0x6D, 0x70, 0x76 ;Row 3
    .byte 0x6A, 0x6A, 0x6A, 0x6A, 0x6A, 0x6A, 0x6A, 0x6A, 0x6A, 0x6A, 0x6C, 0x6D, 0x6E, 0x6F, 0x71, 0x79, 0x79 ;Row 4
    .byte 0x6A, 0x6A, 0x6A, 0x6A, 0x6A, 0x6A, 0x6A, 0x6B, 0x6C, 0x6C, 0x6D, 0x6E, 0x6F, 0x6F, 0x73, 0x7C, 0x7C ;Row 5
    .byte 0x69, 0x6A, 0x6A, 0x6A, 0x6A, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F, 0x6F, 0x71, 0x74, 0x7A, 0x82, 0x82 ;Row 6
    .byte 0x68, 0x69, 0x6A, 0x6C, 0x6F, 0x70, 0x72, 0x74, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x86, 0x85 ;Row 7
    .byte 0x6D, 0x6D, 0x6D, 0x71, 0x73, 0x75, 0x77, 0x79, 0x86, 0x86, 0x86, 0x86, 0x86, 0x86, 0x86, 0x8A, 0x88 ;Row 8
    .byte 0x71, 0x71, 0x71, 0x74, 0x76, 0x79, 0x7C, 0x7F, 0x8E, 0x8E, 0x8E, 0x8E, 0x8E, 0x8E, 0x8E, 0x8E, 0x8C ;Row 9
    .byte 0x71, 0x71, 0x71, 0x77, 0x79, 0x7B, 0x7D, 0x80, 0x8C, 0x8D, 0x8E, 0x8E, 0x8E, 0x8E, 0x8E, 0x90, 0x8F ;Row 10
    .byte 0x71, 0x71, 0x71, 0x77, 0x79, 0x7B, 0x7D, 0x80, 0x8C, 0x8E, 0x8E, 0x8E, 0x8E, 0x8E, 0x90, 0x92, 0x93 ;Row 11
    .byte 0x71, 0x71, 0x71, 0x78, 0x7A, 0x7B, 0x81, 0x81, 0x95, 0x9A, 0x9A, 0x9A, 0x9A, 0x9A, 0x9F, 0xA1, 0xA1 ;Row 12
    .byte 0x74, 0x74, 0x74, 0x78, 0x7A, 0x7B, 0x85, 0x86, 0x9A, 0x9A, 0x9A, 0x9A, 0x9A, 0xA1, 0xAA, 0xAA, 0xAC ;Row 13
    .byte 0x7B, 0x7B, 0x7B, 0x82, 0x82, 0x82, 0x8C, 0x8E, 0x9A, 0x9A, 0x9A, 0x9A, 0x9A, 0xA1, 0xAA, 0xAA, 0xAC ;Row 14
    .byte 0x7B, 0x7B, 0x7B, 0x82, 0x82, 0x82, 0x8C, 0x8E, 0x9A, 0x9A, 0x9A, 0x9A, 0x9F, 0xA1, 0xAA, 0xAA, 0xFF ;Row 15
    .byte 0x71, 0x71, 0x71, 0x7C, 0x7C, 0x7C, 0x99, 0x99, 0x99, 0x99, 0x9B, 0xA0, 0xA2, 0xA9, 0xAC, 0xA9, 0xFF ;Row 16
    .byte 0x7C, 0x7C, 0x7C, 0x7C, 0x7C, 0x7C, 0x7C, 0xA1, 0xA4, 0xA4, 0xA6, 0xAB, 0xAB, 0xAC, 0xB4, 0xB4, 0xFF ;Row 17

	;.org	0x895d
BATOFF_FuelBatteryOffset:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0x0634
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelBatteryOffset
    ;mptblcname BATOFF
    ;mpxaxis Battery 0 16.2 Volts
    ;mpyaxis Pulsewidth 0 4096 uSec
    ;mptbldesc Compensates_for_slower_opening_times_of_injectors_with_lower_voltage.
    .byte 0x04                       ;Number of points in table
    .byte 0x59, 0x6A, 0xFE, 0xDB     ;Point 1
    .byte 0x82, 0x3B, 0xFF, 0x90     ;Point 2
    .byte 0xC2, 0x1F, 0xFF, 0xCA     ;Point 3
    .byte 0xFB, 0x13                 ;Point 4

; *****************************************************************************
; Cold Enrichment Factor Calculation (CNRICH)
;
; 1 + ((CURVEA * ACVDCY/255 + CURVEC * ACVDCY/255 + CURVEB * FCRCVB/255) * 2 +
;     (HMPMUL * HIGHMP)/32) * BAROCP/255
;
; CURVEA, CURVEB, CURVEC Factors:
; X == Engine Temp DegC + 128 ( Engine Temp is scaled between -128C and +128C
;							      -198F and +262F
; Y == (Factor - 1) * 128 where the factor is between 1.00 and 2.99
;
; *****************************************************************************


	;.org	0x8970
CURVEA_FuelColdEnrichmentCurveA:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0x0653
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelColdEnrichmentCurveA
    ;mptblcname CURVEA
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 1 2 factor
    ;mptbldesc Coldenrichment_factor_=_1_+_(_(CurveA_*_ADVDCY/255_+_CurveC_*_ADVDCY/255_+_CurveB_*_FCRCVB/255_)_/_32_)_*_BAROCP/255
    .byte 0x08                       ;Number of points in table
    .byte 0x58, 0xD8, 0xFB, 0xC9     ;Point 1
    .byte 0x74, 0x62, 0xFE, 0x30     ;Point 2
    .byte 0x84, 0x45, 0xFE, 0x21     ;Point 3
    .byte 0x9B, 0x1A, 0x00, 0x00     ;Point 4
    .byte 0xA6, 0x1A, 0xFF, 0x5D     ;Point 5
    .byte 0xB1, 0x13, 0xFF, 0xE4     ;Point 6
    .byte 0xE8, 0x0D, 0x03, 0x2B     ;Point 7
    .byte 0xEE, 0x20                 ;Point 8

	;.org	0x8993
CURVEB_FuelColdEnrichmentCurveB:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0x0668
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelColdEnrichmentCurveB
    ;mptblcname CURVEB
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 2 factor
    ;mptbldesc Coldenrichment_factor_=_1_+_(_(CurveA_*_ADVDCY/255_+_CurveC_*_ADVDCY/255_+_CurveB_*_FCRCVB/255_)_/_32_)_*_BAROCP/255
    .byte 0x05                       ;Number of points in table
    .byte 0x58, 0x70, 0xFE, 0x37     ;Point 1
    .byte 0x74, 0x3E, 0xFE, 0x9A     ;Point 2
    .byte 0x92, 0x14, 0xFE, 0x00     ;Point 3
    .byte 0x95, 0x0E, 0xFF, 0x71     ;Point 4
    .byte 0xAE, 0x00                 ;Point 5

	;.org	0x89b6
CURVEC_FuelColdEnrichmentCurveC:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0x067A
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelColdEnrichmentCurveC
    ;mptblcname CURVEC
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 1 3 factor
    ;mptbldesc Coldenrichment_factor_=_1_+_(_(CurveA_*_ADVDCY/255_+_CurveC_*_ADVDCY/255_+_CurveB_*_FCRCVB/255_)_/_32_)_*_BAROCP/255
    .byte 0x05                       ;Number of points in table
    .byte 0x79, 0x3A, 0xFF, 0xA6     ;Point 1
    .byte 0x8D, 0x33, 0xFC, 0x33     ;Point 2
    .byte 0x92, 0x20, 0xFF, 0x9E     ;Point 3
    .byte 0xBC, 0x10, 0xFF, 0xEF     ;Point 4
    .byte 0xE8, 0x0D                 ;Point 5

	;.org	0x89cd
FCRCVB_FuelWOTScaleEnrichBFromRpm:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0x068C
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelWOTScaleEnrichBFromRpm
    ;mptblcname FCRCVB
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis factor 0 1 scale
    ;mptbldesc B_Curve_Multiplier_is_used_at_Full_Throttle_only
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x33                 ;Point 1

	;.org	0x89e0
TMPHLD_TempSwitchPointForCurveAHoldDecay:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0x069A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TempSwitchPointForCurveAHoldDecay
    ;mptblcname TMPHLD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Temperature_switch_point_for_Curve_A_Hold_and_Decay_times
    .byte 0x84                       ;Point 1

CLDHLD_CurveAColdHoldTime:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0x06A6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAColdHoldTime
    ;mptblcname CLDHLD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 180 out
    ;mptbldesc Curve_A_Cold_Hold_time_-_value_=_this_number_times_.704_sec
    .byte 0x0E                       ;Point 1

HOTHLD_CurveAHotHoldTime:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0x06B2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAHotHoldTime
    ;mptblcname HOTHLD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Curve_A_Hot_Hold_Time_-_value_=_this_number_times_.704_sec
    .byte 0x0E                       ;Point 1

	;.org	0x89e3
DCYTMC_CurveAColdDecayTime:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0x06BF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAColdDecayTime
    ;mptblcname DCYTMC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Curve_A_Cold_Decay_Time_-_value_=_89.76_divided_by_this_number
    .byte 0x02                       ;Point 1

DCYTMH_CurveAHotDecayTime:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0x06CB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAHotDecayTime
    ;mptblcname DCYTMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Curve_A_Hot_Decay_Time_-_value_=_89.76_divided_by_this_number
    .byte 0x05                       ;Point 1

CCURV_HoldTimeForCurveC:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0x06D7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HoldTimeForCurveC
    ;mptblcname CCURV
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 180 out
    ;mptbldesc Hold_Time_for_Curve_C_-_value_=_this_number_times_.704_sec
    .byte 0x07                       ;Point 1

DCYCC_DecayRateForCurveC:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0x06E3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DecayRateForCurveC
    ;mptblcname DCYCC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Decay_Rate_for_Curve_C_-_value_=_89.76_divided_by_this_number
    .byte 0x12                       ;Point 1

; *****************************************************************************
; Load Enrichment:
; Cold Load Factor == HIGHMP * HMPMUL/32
;
; HIGHMP Factors:
; X - Engine Temp
; Y - (% enrichment per Torr/100) * 32 * 5.88 * 255
;
; HMPMUL Factors:
; X - MAP in Torr * 0.17
; Y - MAP in Torr * 0.17
;
; *****************************************************************************

	;.org	0x89e7
HIGHMP_ColdLoadFromCoolantTemp:
    ;mpgrp Fuel\Modifiers\
    ;mptbladdr 0x06FE
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ColdLoadFromCoolantTemp
    ;mptblcname HIGHMP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis enrichment 0 100 Percent
    ;mptbldesc Cold_Load_Enrichment_Factor
    .byte 0x02                       ;Number of points in table
    .byte 0xA0, 0x11, 0xFE, 0xC9     ;Point 1
    .byte 0xAE, 0x00                 ;Point 2

	;.org	0x89f2
HMPMUL_ColdLoadFromMAP:
    ;mpgrp Fuel\Modifiers\
    ;mptbladdr 0x070D
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname ColdLoadFromMAP
    ;mptblcname HMPMUL
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Facto 0 100 percent
    ;mptbldesc Cold_Load_Enrichment_Multiplier
    ;mpmapaxis x
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x11                 ;Point 1

	;.org	0x89fd
PEFTBL_PumpingEfficiency:
    ;mpgrp Fuel\Modifiers\
    ;mptbladdr 0x071C
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname PumpingEfficiency_FromRpm
    ;mptblcname PEFTBL
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis PumpEff 0 100 Percent
    ;mptbldesc Pumping_Efficiency
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0xFF                 ;Point 1

	;.org	0x8a04
HIGHM2_ColdLoadFromCoolantTemp2:
    ;mpgrp Fuel\Modifiers\
    ;mptbladdr 0x072A
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ColdLoadFromCoolantTemp2
    ;mptblcname HIGHM2
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis enrichment 0 100 Percent
    ;mptbldesc Cold_Load_Enrichment_Factor
    .byte 0x02                       ;Number of points in table
    .byte 0xB1, 0x11, 0xFF, 0x00     ;Point 1
    .byte 0xC2, 0x00                 ;Point 2
    
	;.org	0x8a17
HMPMU2_ColdLoadFromMAP2:
    ;mpgrp Fuel\Modifiers\
    ;mptbladdr 0x0739
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname ColdLoadFromMAP2
    ;mptblcname HMPMU2
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Factor 0 100 percent
    ;mptbldesc Cold_Load_Enrichment_Multiplier
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x36, 0x00, 0x03, 0x66     ;Point 1
    .byte 0x3B, 0x11                 ;Point 2
    
	;.org	0x8a26
PEFTBL2_PumpingEfficiency2:
    ;mpgrp Fuel\Modifiers\
    ;mptbladdr 0x0749
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname PumpingEfficiency2_FromRpm
    ;mptblcname PEFTBL2
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis PumpEff 0 100 Percent
    ;mptbldesc Pumping_Efficiency
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0xFF                 ;Point 1

	;.org	0x8a2d
BAROCP_BaroCompensationOfWarmupFactor_FromBaro:
    ;mpgrp Fuel\Modifiers\
    ;mptbladdr 0x0757
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BaroCompensationOfWarmupFactor_FromBaro
    ;mptblcname BAROCP
    ;mpxaxis Baro -14.7 14.7 psi
    ;mpyaxis Factor 0 100 Percent
    ;mptbldesc Baro_compensation_of_Warmup_Factor
    ;mpmapaxis x
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x80                 ;Point 1

	;.org	0x8a38
RUNTMP_ModifierOf_ENGTMP_FromStalltime:
    ;mpgrp Fuel\Modifiers\
    ;mptbladdr 0x0766
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ModifierOf_ENGTMP_FromStalltime
    ;mptblcname RUNTMP
    ;mpxaxis time_after_stall 0 720 sec
    ;mpyaxis delta 0 720 temp
    ;mptbldesc Delta_modifier_added_to_engine_temp_after_a_stall_before_key_on._This_is_to_approximate_heat_soak
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x00, 0x03, 0xAB     ;Point 1
    .byte 0x06, 0x16, 0x09, 0x00     ;Point 2
    .byte 0x0B, 0x43                 ;Point 3

	;.org	0x8a43
RUNLMT_MaxAllowableTempFor_RUNTMP:
    ;mpgrp Fuel\Modifiers\
    ;mptbladdr 0x0776
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxAllowableTempFor_RUNTMP
    ;mptblcname RUNLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Max_allowable_temp_for_RUNTMP_(heat_soak_approximation)
    .byte 0x80                       ;Point 1

	;.org	0x8a44
AIRTMP_FuelEnrichmentFromChargeTemp:
    ;mpgrp Fuel\Modifiers\
    ;mptbladdr 0x0783
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelEnrichmentFromChargeTemp
    ;mptblcname AIRTMP
    ;mpxaxis Charge_Temp -200 260 degrees
    ;mpyaxis Factor 1 2 factor
    ;mptbldesc Charge_Temp_Factor._Note_that_this_is_an_unfiltered_charge_temp_voltage,_so_higher_numbers_are_lower_temps
    .byte 0x05                       ;Number of points in table
    .byte 0x58, 0x40, 0xFF, 0x5C     ;Point 1
    .byte 0x74, 0x2E, 0xFF, 0x6D     ;Point 2
    .byte 0xA1, 0x14, 0xFF, 0x87     ;Point 3
    .byte 0xB6, 0x0A, 0xFF, 0xCB     ;Point 4
    .byte 0xE6, 0x00                 ;Point 5

	;.org	0x8a5b
PWADD_FuelPWModifierFromBaro:
    ;mpgrp Fuel\Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0795
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AdditiveBaroFuelCompensation_FromBaro
    ;mptblcname PWADD
    ;mpxaxis Baro -14.7 14.7 psi
    ;mpyaxis Pulsewidth 0 768 uSec
    ;mptbldesc Additive_Baro_Fuel_Compensation_-_fuel_added_based_on_altitude
    ;mpmapaxis x
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x55, 0x0B, 0xFF, 0xB7     ;Point 1
    .byte 0x6A, 0x05, 0xFF, 0xC6     ;Point 2
    .byte 0x80, 0x00                 ;Point 3

	;.org	0x8a6a
POSTRG_PositiveTransientTriggerLevel:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0x07A7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PositiveTransientTriggerLevel
    ;mptblcname POSTRG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Positive_Transient_Enrich_Trigger_Level_in_volts_times_0.02
    .byte 0x03                       ;Point 1

	;.org	0x8a6b
THRMAX_MaxDeltaTHR:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0x07B4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxDeltaTHR
    ;mptblcname THRMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Max_Delta_THR_(THR-AVTHR-POSTRG)_-_value_of_$26_is_.51_volts
    .byte 0x40                       ;Point 1

	;.org	0x8a6c
POSSLP_DeltaTPSEnrichmentFactor:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0x07C1
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DeltaTPSEnrichmentFactor
    ;mptblcname POSSLP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis pw 0 60 ms/volt
    ;mptbldesc Throttle_Transient_Enrich_PW_Addition
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x74, 0x41, 0xFF, 0x23     ;Point 1
    .byte 0xA0, 0x1B, 0xFF, 0x8B     ;Point 2
    .byte 0xD0, 0x05                 ;Point 3

	;.org	0x8a7b
MAPTRG_DeltaMapTriggerLevel:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x07D2
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapTriggerLevel
    ;mptblcname MAPTRG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc MAP_Delta_required_to_trigger_transient_enrichment
    ;mpmapaxis y
    .byte 0x0A                       ;Point 1

	;.org	0x8a7c
MAPMAX_MaxDeltaMapAllowed:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x07E0
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MaxDeltaMapAllowed
    ;mptblcname MAPMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc Maximum_Delta_MAP_allowed
    ;mpmapaxis y
    .byte 0x1C                       ;Point 1

	;.org	0x8a7d
AESLOP_DeltaMAPEnrichmentPT:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x07EE
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname DeltaMAPEnrichmentPT
    ;mptblcname AESLOP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis pwEnrich 0 255 uS/torr
    ;mptbldesc Transient_Enrichment_PW_Addition
    ;mpmapaxis -y
    ;mpinjscale scale
    .byte 0x04                       ;Number of points in table
    .byte 0x58, 0x40, 0xFF, 0xB2     ;Point 1
    .byte 0x90, 0x2F, 0xFF, 0x1F     ;Point 2
    .byte 0xB1, 0x12, 0xFF, 0x69     ;Point 3
    .byte 0xC2, 0x08                 ;Point 4

	;.org	0x8a8c
MAPTRS_DeltaMapTriggerLevelSpecial:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x0801
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapTriggerLevelSpecial
    ;mptblcname MAPTRS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc MAP_Delta_required_to_trigger_transient_enrichment
    ;mpmapaxis y
    .byte 0x06                       ;Point 1

	;.org	0x8a8d
MAPMXS_MaxDeltaMapAllowedSpecial:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x080F
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MaxDeltaMapAllowedSpecial
    ;mptblcname MAPMXS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc Maximum_Delta_MAP_allowed
    ;mpmapaxis y
    .byte 0x22                       ;Point 1

	;.org	0x8a8e
AESLPI_DeltaMAPEnrichmentIdle:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x081D
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname DeltaMAPEnrichmentIdle
    ;mptblcname AESLPI
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis pwEnrich 0 255 uS/torr
    ;mptbldesc Transient_Enrichment_PW_Addition
    ;mpmapaxis -y
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x90, 0x24, 0xFF, 0x71     ;Point 1
    .byte 0xC2, 0x08, 0xFF, 0xA0     ;Point 2
    .byte 0xD2, 0x02                 ;Point 3

	;.org	0x8a9d
MAPTRP_DeltaMapTriggerLevelPartThrottle:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x082F
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapTriggerLevelPartThrottle
    ;mptblcname MAPTRP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc MAP_Delta_required_to_trigger_transient_enrichment
    ;mpmapaxis y
    .byte 0x0A                       ;Point 1

	;.org	0x8a9e
MAPMXP_MaxDeltaMapAllowedPartThrottle:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x083D
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MaxDeltaMapAllowedPartThrottle
    ;mptblcname MAPMXP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc Maximum_Delta_MAP_allowed
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1

	;.org	0x8a9f
AESLPW_DeltaMAPEnrichmentWOT:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x084B
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname DeltaMAPEnrichmentWOT
    ;mptblcname AESLPW
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis pwEnrich 0 255 uS/torr
    ;mptbldesc Transient_Enrichment_PW_Addition
    ;mpmapaxis -y
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x58, 0x50, 0xFF, 0x37     ;Point 1
    .byte 0x90, 0x24, 0xFF, 0xEC     ;Point 2
    .byte 0xC2, 0x20                 ;Point 3

	;.org	0x8aae
OCTAE_FakeDeltaMapIncrease:
    ;mpgrp Setup\Thorttle_Calibration\
    ;mptbladdr 0x085D
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname FakeDeltaMapIncrease
    ;mptblcname OCTAE
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc Fake_Delta_Map_Increase._AVMAP_is_set_to_(MAP-OCTAE)_any_time_throttle_is_just_opened.
    ;mpmapaxis y
    .byte 0x02                       ;Point 1

	;.org	0x8aaf
MPATHR_MAPThresholdForClearingAverageMAP:
    ;mpgrp Fuel\Transient_Enrichment\Average_MAP&TPS\
    ;mptbladdr 0x086B
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MAPThresholdForClearingAverageMAP
    ;mptblcname MPATHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc Desc
    ;mpmapaxis y
    .byte 0x22                       ;Point 1

	;.org	0x8ab0
WGITHR_WGIncrementThresholdForClearingAverageMAP:
    ;mpgrp Fuel\Transient_Enrichment\Average_MAP&TPS\
    ;mptbladdr 0x0879
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WGIncrementThresholdForClearingAverageMAP
    ;mptblcname WGITHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis wgi 0 127 %
    ;mptbldesc Desc
    .byte 0x30                       ;Point 1

	;.org	0x8ab1
SPDTHR_VehicleSpeedThresholdForClearingAverageMAP:
    ;mpgrp Fuel\Transient_Enrichment\Average_MAP&TPS\
    ;mptbladdr 0x0886
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname VehicleSpeedThresholdForClearingAverageMAP
    ;mptblcname SPDTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 127 mph
    ;mptbldesc Desc
    .byte 0x07                       ;Point 1

	;.org	0x8ab2
REVTHR_EngineRPMThresholdForClearingAverageMAP:
    ;mpgrp Fuel\Transient_Enrichment\Average_MAP&TPS\
    ;mptbladdr 0x0893
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname EngineRPMThresholdForClearingAverageMAP
    ;mptblcname REVTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Desc
    .word 0x0180                     ;Point 1

	;.org	0x8ab4
MLPTPS_MainLoopCountToClearTPSTRansient:
    ;mpgrp Fuel\Transient_Enrichment\Average_MAP&TPS\
    ;mptbladdr 0x08A0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MainLoopCountToClearTPSTRansient
    ;mptblcname MLPTPS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Count 0 255 cnt
    ;mptbldesc Desc
    .byte 0x5D                       ;Point 1

	;.org	0x8ab5
POSTIG_MinAisPulseRequireToTriggerEnrichment:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\AIS_Enrichment\
    ;mptbladdr 0x08AD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinAisPulseRequireToTriggerEnrichment
    ;mptblcname POSTIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Min_AIS_pulse_required_to_trigger_enrichment_(steps)
    .byte 0x07                       ;Point 1

	;.org	0x8ab6
POSFUL_AisEnrichmentFuelPulse:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\AIS_Enrichment\
    ;mptbladdr 0x08BA
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname AisEnrichmentFuelPulse
    ;mptblcname POSFUL
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AIS_enrichment_fuel_pulse_in_uSec
    ;mpinjscale word
    .word 0x00FA                     ;Point 1

	;.org	0x8ab8
MINPAI_MinPWForAISPulseEnrich:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\AIS_Enrichment\
    ;mptbladdr 0x08C8
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname MinPWForAISPulseEnrich
    ;mptblcname MINPAI
    ;mpxaxis X 0 255 scale
    ;mpyaxis Y 0 255 out
    ;mptbldesc MinPWForPartThorttleEnrich
    ;mpinjscale word
    .word 0x0009                     ;Point 1

	;.org	0x8aba
LOTTRG_DeltaTriggerForDecelLeanout:
    ;mpgrp Fuel\Transient_Enrichment\Decel_Lean-out\Decreasing_TPS_LO\
    ;mptbladdr 0x08D6
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname DeltaTriggerForDecelLeanout
    ;mptblcname LOTTRG
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis factor 0 1 factor
    ;mptbldesc Main_trigger_(Delta_trigger_level_for_THR_leanout)_-_Delta_THR
    .byte 0x02                       ;Number of points in table
    .byte 0x77, 0x02, 0x01, 0xDC     ;Point 1
    .byte 0xFF, 0xFF                 ;Point 2

	;.org	0x8ac5
LOTRG2_SecondDecelLeanoutTrigger:
    ;mpgrp Fuel\Transient_Enrichment\Decel_Lean-out\Decreasing_TPS_LO\
    ;mptbladdr 0x08E5
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname SecondDecelLeanoutTrigger
    ;mptblcname LOTRG2
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Second_trigger_-_leanout_inc_toward_1_when_between_triggers
    .byte 0x02                       ;Number of points in table
    .byte 0x77, 0x01, 0x01, 0xDE     ;Point 1
    .byte 0xFF, 0xFF                 ;Point 2

	;.org	0x8ad0
LOTTPS_DecelLeanoutFactor_FromTPS:
    ;mpgrp Fuel\Transient_Enrichment\Decel_Lean-out\Decreasing_TPS_LO\
    ;mptbladdr 0x08F4
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelLeanoutFactor_FromTPS
    ;mptblcname LOTTPS
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 1 scale
    ;mptbldesc Decel_leanout_factor_-_TPS_based.
    .byte 0x02                       ;Number of points in table
    .byte 0x02, 0x20, 0x0A, 0xAB     ;Point 1
    .byte 0x0B, 0x80                 ;Point 2

	;.org	0x8adb
LOTTHR_DecelLeanoutFactor_FromTemp:
    ;mpgrp Fuel\Transient_Enrichment\Decel_Lean-out\Decreasing_TPS_LO\
    ;mptbladdr 0x0903
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelLeanoutFactor_FromTemp
    ;mptblcname LOTTHR
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 1 scale
    ;mptbldesc Decel_leanout_factor_-_THR_based._When_Y_is_zero,_factor_is_1.00
    .byte 0x04                       ;Number of points in table
    .byte 0x90, 0x00, 0x33, 0x00     ;Point 1
    .byte 0x95, 0xFF, 0x00, 0x00     ;Point 2
    .byte 0xBC, 0xFF, 0xF0, 0x17     ;Point 3
    .byte 0xC7, 0x50                 ;Point 4

	;.org	0x8aea
ATPRPM_MinimumRPMtoResetAverageTPS:
    ;mpgrp Fuel\Transient_Enrichment\Average_MAP&TPS\
    ;mptbladdr 0x0914
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumRPMtoResetAverageTPS
    ;mptblcname ATPRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Desc
    .byte 0x64                       ;Point 1

	;.org	0x8aeb
ATPDTP_MinimumDeltaTPStoResetAverageTPS:
    ;mpgrp Fuel\Transient_Enrichment\Average_MAP&TPS\
    ;mptbladdr 0x0921
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumDeltaTPStoResetAverageTPS
    ;mptblcname ATPDTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Desc
    .byte 0x33                       ;Point 1

	;.org	0x8aec
DECTRG_DeltaMapTriggerForNoIncrementalLeanout:
    ;mpgrp Fuel\Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x092E
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname DeltaMapTriggerForNoIncrementalLeanout
    ;mptblcname DECTRG
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis out_desc 0 1 scale
    ;mptbldesc Descr
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x77, 0x06, 0x01, 0xD5     ;Point 1
    .byte 0xFF, 0xFF                 ;Point 2

	;.org	0x8af7
DTRG2_DeltaMapTriggerForMaxLeanout:
    ;mpgrp Fuel\Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x093E
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname DeltaMapTriggerForMaxLeanout
    ;mptblcname DTRG2
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis out_desc 0 1 scale
    ;mptbldesc Descr
    .byte 0x02                       ;Number of points in table
    .byte 0x77, 0x04, 0x01, 0xD8     ;Point 1
    .byte 0xFF, 0xFF                 ;Point 2

	;.org	0x8b02
DECTPS_DeltaMAPLeanout_FromTPS:
    ;mpgrp Fuel\Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x094D
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname DeltaMAPLeanout_FromTPS
    ;mptblcname DECTPS
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis out_desc 0 1 scale
    ;mptbldesc Descr
    .byte 0x02                       ;Number of points in table
    .byte 0x06, 0x1F, 0x03, 0xBB     ;Point 1
    .byte 0x20, 0x80                 ;Point 2

	;.org	0x8b0d
NEGSL2_DeltaMAPLeanout_FromTemp:
    ;mpgrp Fuel\Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x095C
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DeltaMAPLeanout_FromTemp
    ;mptblcname NEGSL2
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 100 percent
    ;mptbldesc Description
    .byte 0x04                       ;Number of points in table
    .byte 0x91, 0x01, 0xFE, 0x00     ;Point 1
    .byte 0x92, 0xFF, 0x00, 0x00     ;Point 2
    .byte 0xC7, 0xFF, 0xF4, 0x74     ;Point 3
    .byte 0xD2, 0x80                 ;Point 4

	;.org	0x8b1c
LOTRPM_MinRpmForMapLeanout:
    ;mpgrp Fuel\Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x096D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinRpmForMapLeanout
    ;mptblcname LOTRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc No_map_leanout_if_below_this_RPM
    .byte 0x27                       ;Point 1

	;.org	0x8b1d
AVMRPM_MinimumRPMToResetAverageMAP:
    ;mpgrp Fuel\Transient_Enrichment\Average_MAP&TPS\
    ;mptbladdr 0x097A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumRPMToResetAverageMAP
    ;mptblcname AVMRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Desc
    .byte 0xD6                       ;Point 1

	;.org	0x8b1e
DCELTM_O2CNTRInhibitAfterLeanoutDone:
    ;mpgrp Fuel\Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x0987
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2CNTRInhibitAfterLeanoutDone
    ;mptblcname DCELTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2CNTR_inhibit_after_MAP/THR_leanout_is_done_(times_11_ms)
    .byte 0x69                       ;Point 1

	;.org	0x8b1f
AESLOW_DeltaMAPEnrichmentWOT_FromTemp:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x0994
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DeltaMAPEnrichmentWOT_FromTemp
    ;mptblcname AESLOW
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis time_const 0 100 percent
    ;mptbldesc MAP_Transient_Enrich_Time_Constant_when_MAP_gt_AVMAP
    .byte 0x02                       ;Number of points in table
    .byte 0x7F, 0x08, 0x00, 0x17     ;Point 1
    .byte 0xA0, 0x0B                 ;Point 2

	;.org	0x8b2a
AETIME_EnrichmentTime_FromTemp:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x09A3
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname EnrichmentTime_FromTemp_MAP
    ;mptblcname AETIME
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis time_const 0 100 percent
    ;mptbldesc MAP_Transient_Enrich_Time_Constant_when_MAP_gt_AVMAP
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x02                 ;Point 1

	;.org	0x8b35
AESLPP_DeltaMAPEnrichmentPT_FromTempPart:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x09B1
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DeltaMAPEnrichmentPT_FromTempPart
    ;mptblcname AESLPP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis time_const 0 100 percent
    ;mptbldesc MAP_Transient_Enrich_Time_Constant_when_MAP_gt_AVMAP
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x0B                 ;Point 1

	;.org	0x8b40
THRTCN_EnrichmentTime_FromTemp:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0x09BF
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname EnrichmentTime_FromTemp_TPS
    ;mptblcname THRTCN
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis time_const 0 100 percent
    ;mptbldesc Throttle_Transient_Enrich_Time_Constant
    .byte 0x02                       ;Number of points in table
    .byte 0xA6, 0x10, 0x00, 0x80     ;Point 1
    .byte 0xAE, 0x14                 ;Point 2

	;.org	0x8b4b
LMAPTC_TimeConstant:
    ;mpgrp Fuel\Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x09CE
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TimeConstant
    ;mptblcname LMAPTC
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis time_const 0 100 percent
    ;mptbldesc lean_out_time_constant_based_on_MAP
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x18                 ;Point 1

	;.org	0x8b56
LOTIME_DecelLeanoutTimeConstant_FromTemp:
    ;mpgrp Fuel\Transient_Enrichment\Decel_Lean-out\Decreasing_TPS_LO\
    ;mptbladdr 0x09DC
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelLeanoutTimeConstant_FromTemp
    ;mptblcname LOTIME
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis time_const 0 100 percent
    ;mptbldesc Leanout_Time_Constant_based_on_Delta_THR_-_uses_average_throttle
    .byte 0x02                       ;Number of points in table
    .byte 0xC0, 0x30, 0x01, 0x9A     ;Point 1
    .byte 0xCA, 0x40                 ;Point 2

	;.org	0x8b61
RPMMAP_SwitchPointForDownUp_FromRpm:
    ;mpgrp Fuel\Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x09EB
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname SwitchPointForDownUp_FromRpm
    ;mptblcname RPMMAP
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc EPP_Control_toggle
    ;mpmapaxis y
    .byte 0x04                       ;Number of points in table
    .byte 0x64, 0xFF, 0xF7, 0x14     ;Point 1
    .byte 0x71, 0x8B, 0xFF, 0x0A     ;Point 2
    .byte 0xA3, 0x5B, 0xFE, 0x2B     ;Point 3
    .byte 0xAF, 0x45                 ;Point 4

	;.org	0x8b78
PTELMT_MultiplierMaxLimitFromRpm:
    ;mpgrp Fuel\Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x09FD
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname MultiplierMaxLimitFromRpm
    ;mptblcname PTELMT
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis factor 0 100 factor
    ;mptbldesc PTE_Multiplier_limit
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0xFF                 ;Point 1

	;.org	0x8b8f
PTEADJ_EnrichAdjust_FromMap:
    ;mpgrp Fuel\Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0A0B
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname EnrichAdjust_FromMap
    ;mptblcname PTEADJ
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis factor 0.5 1.5 factor
    ;mptbldesc Part_Throttle_Enrichment_-_multiplier_from_MAP_-_NOTE:_zero_is_1.00
    ;mpmapaxis x
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0xFF                 ;Point 1

	;.org	0x8baa
PTENR_EppPerAmountForIncreasing:
    ;mpgrp Fuel\Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0A1A
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname EppPerAmountForIncreasing
    ;mptblcname PTENR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EPP_per_amount_for_increasing_multiplier
    .word 0x3D01                     ;Point 1

PTENR2_EppPerAmountForDecreasingMultiplier:
    ;mpgrp Fuel\Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0A26
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EppPerAmountForDecreasingMultiplier
    ;mptblcname PTENR2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EPP_per_amount_for_decreasing_multiplier
    .byte 0x3D                       ;Point 1

	;.org	0x8bad
PTENRD_AmountForDecreasingMultiplier_Negative:
    ;mpgrp Fuel\Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0A33
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AmountForDecreasingMultiplier_Negative
    ;mptblcname PTENRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Amount_for_decreasing_multiplier_(neg_number)
    .byte 0xFD                       ;Point 1

	;.org	0x8bae
PTENUM_NumberToReturnToHOTMAP:
    ;mpgrp Fuel\Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0A40
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NumberToReturnToHOTMAP
    ;mptblcname PTENUM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc No_of_PTENRD_below_PTELMT_that_PT_enrich_must_be_to_return_to_HOTMAP_spark_advance_after_maxed_out
    .byte 0x02                       ;Point 1

	;.org	0x8baf
BOOSTP_AdjustO2ResponseForPTEWhenMapAboveThis:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0x0A4D
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AdjustO2ResponseForPTEWhenMapAboveThis
    ;mptblcname BOOSTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc Zero_percent_limit_on_lean_O2CNTR_if_MAP_gt_BOOSTP_and_no_PTE
    ;mpmapaxis y
    .byte 0x81                       ;Point 1

	;.org	0x8bb0
O2ITIM_TimeO2InhibitedSwitchingRichIdleToClosedLoop:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0x0A5B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeO2InhibitedSwitchingRichIdleToClosedLoop
    ;mptblcname O2ITIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2_is_inhibited_for_this_time_when_switching_from_rich_idle_to_closed_loop_idle
    .byte 0xFF                       ;Point 1

	;.org	0x8bb1
RICHSA_OpenLoopEnrichFactorWhenSettingBasicTiming:
    ;mpgrp Idle\Special_setup\
    ;mptbladdr 0x0A68
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OpenLoopEnrichFactorWhenSettingBasicTiming
    ;mptblcname RICHSA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Open_loop_enrich_factor_when_setting_mechanical_basic_timing
    .byte 0x1A                       ;Point 1

	;.org	0x8bb2
SPKSET_ConstantSparkAdvanceWhenSettingBasicTiming:
    ;mpgrp Idle\Special_setup\
    ;mptbladdr 0x0A75
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ConstantSparkAdvanceWhenSettingBasicTiming
    ;mptblcname SPKSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Advance 0 127.5 degrees
    ;mptbldesc Constant_spark_advance_setting_when_setting_basic_timing_(stock_12_degrees)
    .byte 0x18                       ;Point 1

	;.org	0x8bb3
IDLDEF_TargetIdleSpeedDefault:
    ;mpgrp Idle\Special_setup\
    ;mptbladdr 0x0A82
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TargetIdleSpeedDefault
    ;mptblcname IDLDEF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x7D                       ;Point 1

	;.org	0x8bb4
RIDLST_OpenLoopEnrichFactorWhenSettingMinThrottleOpening:
    ;mpgrp Idle\Special_setup\
    ;mptbladdr 0x0A8F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OpenLoopEnrichFactorWhenSettingMinThrottleOpening
    ;mptblcname RIDLST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Open_loop_enrich_factor_when_setting_min_throttle_blade_opening_(actuator_test_#70)
    .byte 0x1A                       ;Point 1

	;.org	0x8bb5
IDLSET_ConstantSparkAdvanceWhenSettingMinThrottleOpening:
    ;mpgrp Idle\Special_setup\
    ;mptbladdr 0x0A9C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ConstantSparkAdvanceWhenSettingMinThrottleOpening
    ;mptblcname IDLSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Advance 0 127.5 degrees
    ;mptbldesc Constant_spark_advance_setting_when_setting_min_throttle_blade_opening_(actuator_test_#70)
    .byte 0x18                       ;Point 1

	;.org	0x8bb6
AMTEMP_StartTempToSelectHotOrColdAMTimer:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_Memory_Timer\
    ;mptbladdr 0x0AA9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StartTempToSelectHotOrColdAMTimer
    ;mptblcname AMTEMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc Starting_Temp_to_select_hot_or_cold_AM_timer
    .byte 0xCA                       ;Point 1

	;.org	0x8bb7
AMTPSW_TempPointToEnableSelectedAMTimer:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_Memory_Timer\
    ;mptbladdr 0x0AB6
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempPointToEnableSelectedAMTimer
    ;mptblcname AMTPSW
    ;mpxaxis Coolant_Temp -200 260 deg
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AM_temp_inhibit_time_from_coolant_temp
    .byte 0x02                       ;Number of points in table
    .byte 0xBD, 0x0C, 0x00, 0xA0     ;Point 1
    .byte 0xCD, 0x16                 ;Point 2

	;.org	0x8bc6
CLTIME_ClosedLoopTimeFromEngTempAtStartup_FromTemp:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_Memory_Timer\
    ;mptbladdr 0x0AC5
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ClosedLoopTimeFromEngTempAtStartup_FromTemp
    ;mptblcname CLTIME
    ;mpxaxis Coolant_Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Leave_at_one_-_2.8_sec
    .byte 0x02                       ;Number of points in table
    .byte 0x92, 0x04, 0xFF, 0xF7     ;Point 1
    .byte 0xCB, 0x02                 ;Point 2

	;.org	0x8bd5
CLTEMP_TempToStartCLTIMETimer:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_Memory_Timer\
    ;mptbladdr 0x0AD4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TempToStartCLTIMETimer
    ;mptblcname CLTEMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 degrees
    ;mptbldesc Temperature_to_start_CLTIME_Timer_-_$94_=_70degreesF
    .byte 0x92                       ;Point 1

; *****************************************
; Auto Cal Factors Table
; *****************************************
;
;  closed throttle = cell 12, otherwise:
;  $ff
;	 +-----+-----+-----+-----+-----+-----+
;	 |  1  |  3  |	5  |  7  |  9  |  11 |
;    R1  +-----+-----+-----+-----+-----+-----+
;	 |  0  |  2  |	4  |  6  |  8  |  10 |
;  rpm^  +-----+-----+-----+-----+-----+-----+
;  map>       MP1   MP2   MP3	MP4   MP5     $ff
;
; *****************************************
; mp1-mp5 should be scaled for 3-bar

	;.org	0x8bd6
MP1_AutoCalMapCellBoundary1:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0x0AF1
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary1
    ;mptblcname MP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc AutoCalMapCellBoundary1
    ;mpmapaxis y
    .byte 0x2E                       ;Point 1

MP2_AutoCalMapCellBoundary2:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0x0AFE
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary2
    ;mptblcname MP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc AutoCalMapCellBoundary1
    ;mpmapaxis y
    .byte 0x47                       ;Point 1

MP3_AutoCalMapCellBoundary3:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0x0B0B
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary3
    ;mptblcname MP3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc AutoCalMapCellBoundary1
    ;mpmapaxis y
    .byte 0x58                       ;Point 1

MP4_AutoCalMapCellBoundary4:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0x0B18
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary4
    ;mptblcname MP4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc AutoCalMapCellBoundary1
    ;mpmapaxis y
    .byte 0x69                       ;Point 1

	;.org	0x8bda
MP5_AutoCalMapCellBoundary5:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0x0B26
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary5
    ;mptblcname MP5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc AutoCalMapCellBoundary1
    ;mpmapaxis y
    .byte 0x7A                       ;Point 1

	;.org	0x8bdb
DLTMAP_MapHysteresisAtMapCellBoundaries:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0x0B34
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MapHysteresisAtMapCellBoundaries
    ;mptblcname DLTMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc Map_Hysteresis_At_Map_Cell_Boundaries
    ;mpmapaxis y
    .byte 0x04                       ;Point 1

	;.org	0x8bdc
R1_RPMCellBoundaryInRPMover32:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0x0B42
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMCellBoundaryInRPMover32
    ;mptblcname R1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc RPM_Cell_Boundary
    .byte 0x40                       ;Point 1

	;.org	0x8bdd
DLTRPM_DeltaRPMAtRPMBoundariesInRPMOver32:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0x0B4F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaRPMAtRPMBoundariesInRPMOver32
    ;mptblcname DLTRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Delta_RPM_at_RPM_Boundaries
    .byte 0x03                       ;Point 1

	;.org	0x8bde
IDLOFS_DeltaForIdleRPMForClosedThrottleCell:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0x0B5C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaForIdleRPMForClosedThrottleCell
    ;mptblcname IDLOFS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc RPM_Delta_for_Idle_RPM_For_Closed_Throttle_Cell
    .byte 0x03                       ;Point 1

	;.org	0x8bdf
HYTRPM_HysteresisFor_IDLOFS:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0x0B69
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HysteresisFor_IDLOFS
    ;mptblcname HYTRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Hysteresis_for_IDLOFS
    .byte 0x02                       ;Point 1

	;.org	0x8be0
CELCHG_BitsChangePerUpdateWithinACell:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0x0B76
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BitsChangePerUpdateWithinACell
    ;mptblcname CELCHG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_Bits_Change_Per_Update_Within_A_Cell
    .byte 0x01                       ;Point 1

	;.org	0x8be1
AMUPDT_EPPsBetweenCalChangeUpdateOpenThrottle:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0x0B83
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EPPsBetweenCalChangeUpdateOpenThrottle
    ;mptblcname AMUPDT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EPPs_Between_Cal_Change_Update_(Open_Throttle)
    .byte 0x14                       ;Point 1

	;.org	0x8be2
AMUPDI_EPPsBetweenCalChangeUpdateClosedThrottle:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0x0B90
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EPPsBetweenCalChangeUpdateClosedThrottle
    ;mptblcname AMUPDI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EPPs_Between_Cal_Change_Update_(Closed_Throttle)
    .byte 0x1A                       ;Point 1

	;.org	0x8be3
CALTH1_O2ControllerDeadbandLimitForUpdatingCells1:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0x0B9D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2ControllerDeadbandLimitForUpdatingCells1
    ;mptblcname CALTH1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2_Controller_Deadband_Limit_For_Updating_Cells
    .byte 0x09                       ;Point 1

	;.org	0x8be4
CALTH2_O2ControllerDeadbandLimitForUpdatingCells2:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0x0BAA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2ControllerDeadbandLimitForUpdatingCells2
    ;mptblcname CALTH2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2_Controller_Deadband_Limit_For_Updating_Cells
    .byte 0x09                       ;Point 1

	;.org	0x8be5
MAPLIM_NoCellUpdateAboveThisMAP:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0x0BB7
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname NoCellUpdateAboveThisMAP
    ;mptblcname MAPLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc No_Cell_Update_Above_This_MAP
    ;mpmapaxis y
    .byte 0x8A                       ;Point 1

	;.org	0x8be6
MAPDEC_NoCellUpdateAndO2CNTRHeldBelowThisMap:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0x0BC5
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname NoCellUpdateAndO2CNTRHeldBelowThisMap
    ;mptblcname MAPDEC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc No_Cell_Update_And_O2CNTR_Held_Below_This_Map._Set_to_0xff_to_disable_O2_feedback.
    ;mpmapaxis y
    .byte 0x14                       ;Point 1

	;.org	0x8be7
RPMLIM_NoCellUpdateAboveThisRPMInRPMOver32:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0x0BD3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoCellUpdateAboveThisRPMInRPMOver32
    ;mptblcname RPMLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc No_Cell_Update_Above_This_RPM_-_in_rpms/32
    .byte 0x60                       ;Point 1

	;.org	0x8be8
PWMIN_NoCellUpdateBelow_PWMIN_Pulsewidth:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0x0BE0
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname NoCellUpdateBelow_PWMIN_Pulsewidth
    ;mptblcname PWMIN
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc No_Cell_Update_below_PWMIN_-_this_value_times_4_uSec
    ;mpinjscale word
    .word 0x00AF                     ;Point 1

	;.org	0x8bea
AMLIMH_MaxMultiplierCannotBeAbove7F:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0x0BEE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxMultiplierCannotBeAbove7F
    ;mptblcname AMLIMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AutoCal_Range_Of_Authority_where_MaxMultiplier=1+AMLIMH/512_(cannot_exceed_$7f)
    .byte 0x7F                       ;Point 1

	;.org	0x8beb
AMLIML_MinMultiplierCannotBeBelow80:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0x0BFB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinMultiplierCannotBeBelow80
    ;mptblcname AMLIML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AutoCal_Range_Of_Authority_where_MinMultiplier=.5+AMLIML/512_(cannot_be_below_$80)
    .byte 0x80                       ;Point 1

; *****************************************
;      O2 Controller Ramp Calibration
; *****************************************
; How it works:
;   The O2 sensor is monitored but ONLY for "rich/lean". Even though
;   the O2 sensor value is from 0 to 15, the only thing that counts
;   for this system is whether it is "rich" or "lean". A change from one
;   to the other is a "toggle". The system constantly toggles between
;   rich and lean so that the overall average is around stoichiometric.
;
; Background information (from the net:)
;     An "ideal" fuel/air mixture in which both the fuel and the oxygen in the air are
;     completely consumed is called the "stoichiometric" mixture. The stoichiometric mixture
;     is usually specified as the ratio of the mass of air to the mass of a particular fuel.
;     For example, if a fuel required 10 kg of air to precisely burn 1 kg of the fuel (that is,
;     all the fuel burned and there was no oxygen left in the air afterwards) then the
;     stoichiometric ratio for that fuel would be 10:1.
;
;     Chevron give the stoichiometric ratio of air mass to fuel mass for gasoline as 14.7:1,
;     but don't specify the composition of this hypothetical gasoline.
;
;     From http://www.faqs;;;.org/faqs/autos/gasoline-faq/part2/ comes the following table
;     of typical stoichiometric air-fuel ratios:
;
;	     Fuel   | Stoichiometric air-fuel ratio
;	 -----------+------------------------------
;	   methanol | 6.4
;	    ethanol | 9.0
;	       MTBE | 11.7
;	 ETBE, TAME | 12.1
;	   gasoline | 14.6
;
;     An oxygenated gasoline with 89% gasoline and 11% MTBE would then have a stoichiometric
;     ratio of 14.281 (note that this would require a Wide Band O2 sensor to adjust, since the
;     O2 sensor in our cars is designed for gasoline only, and is a very narrow range. In case
;     you were wondering, this is one reason some people are interested in Wide Band O2 sensors.)
;
; *****************************************
; This system divides a range of RPMs and MAP readings into "cells". The number of
; "kicks", or increases/decreases in fuel required to toggle the O2 reading, is different
; for each of these cells. This allows some fairly powerful flexibility in tuning. The
; only time you might want to adjust these values is for different injector flow rates,
; or to speed or slow the adjustment being performed.
; *****************************************
; Note to tuners: DO NOT AIM FOR STOICHIOMETRY! Although it might be fine for idle or
; low speed operation, at higher RPMs and under boost you DEFINITELY want a RICH mixture.
; This is because stoichiometric combustion generates the most heat. No current engine
; would survive very long with the temperatures this would generate, hot enough to melt
; the engine.
; *****************************************
; Each cell has a kick value. This is the amount of change applied to the running fuel
; every eleven millisec until a rich/lean toggle occurs. The net result is the
; familiar rich/lean flashing that your O2 sensor gauge shows you.
; *****************************************
;
; (one kick per 11ms)
; Fudge factor: if an O2 toggle occurs before the primary ramp
; finishes, then the "first" step in the new direction is limited
; to the accumulated steps before the toggle.
;
;		Cells:
;
; HIRPM  +-----+-----+-----+
;	 |  2  |  5  |	8  |
; RPM#2  +-----+-----+-----+
;	 |  1  |  4  |	7  |
; RPM#1  +-----+-----+-----+
;	 |  0  |  3  |	6  |	    Idle Cell: 9
;	 +-----+-----+-----+
;	  Map#1 MAP#2 HIMAP
;
; *****************************************
;  PrimaryO2Ramp:
; *****************************************

	;.org	0x8bec
PRIRMP_PrimaryRamp:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller_Ramps\
    ;mptbladdr 0x0C53
    ;mptbltype 11
    ;mpsubtype 1
    ;mptbllname PrimaryRamp
    ;mptblcname PRIRMP
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Lower_RPM_Boundary_-_RPM/32
    ;mpmapaxis y
    .word 0x2F49                  ;Rpm Low / High Boundary
    .word 0x2D58                  ;Map Low / High Boundary
    .word 0x0804                  ;Cell 0 Ramp Rich/Lean
    .word 0x0804                  ;Cell 1 Ramp Rich/Lean
    .word 0x0804                  ;Cell 2 Ramp Rich/Lean
    .word 0x0F04                  ;Cell 3 Ramp Rich/Lean
    .word 0x1604                  ;Cell 4 Ramp Rich/Lean
    .word 0x1605                  ;Cell 5 Ramp Rich/Lean
    .word 0x1604                  ;Cell 6 Ramp Rich/Lean
    .word 0x1604                  ;Cell 7 Ramp Rich/Lean
    .word 0x1605                  ;Cell 8 Ramp Rich/Lean
    .word 0x0303                  ;Ramp Idle Cell Rich/Lean
    .word 0x0808                  ;Cell 0 Limits/Rates Rich/Lean
    .word 0x0808                  ;Cell 1 Limits/Rates Rich/Lean
    .word 0x0808                  ;Cell 2 Limits/Rates Rich/Lean
    .word 0x0F0F                  ;Cell 3 Limits/Rates Rich/Lean
    .word 0x1614                  ;Cell 4 Limits/Rates Rich/Lean
    .word 0x1614                  ;Cell 5 Limits/Rates Rich/Lean
    .word 0x1614                  ;Cell 6 Limits/Rates Rich/Lean
    .word 0x1614                  ;Cell 7 Limits/Rates Rich/Lean
    .word 0x1613                  ;Cell 8 Limits/Rates Rich/Lean
    .word 0x0303                  ;Limit/Rates Idle Cell Rich/Lean

; *****************************************
; For each cell, the first number is "rich", the second is "lean".
; If the O2 sensor is returning a lean value, "rich" kicks are added.
; If the O2 sensor is returning a rich value, "lean" kicks are added.
;
;     KICK - (factor * 512) - 512  (unsigned number)
; eg: $19  -   1.05  * 512  - 512 - 5%
; *****************************************
; *****************************************
; The Limits are the maximum number of kicks that may be applied to each
; cell. If the O2 sensor fails to toggle after reaching the limit for more
; than a few sec, the AutoCal cell gets changed.
; *****************************************

	;.org	0x8c18
O2LIMH_O2RangeLimitHigh:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0x0C84
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2RangeLimitHigh
    ;mptblcname O2LIMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2_Range_Of_Authority_MaxMultiplier=1+O2LIMH/512_(cannot_be_above_$7f)
    .byte 0x7F                       ;Point 1

	;.org	0x8c19
O2LIML_O2RangeLimitLow:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0x0C91
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2RangeLimitLow
    ;mptblcname O2LIML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2_Range_Of_Authority_MinMultiplier=.5+O2LIML/512_(cannot_be_below_$80)
    .byte 0x80                       ;Point 1

	;.org	0x8c1a
O2HIGH_HighLimitForImmediateSwitchToClosedLoop:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0x0C9E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForImmediateSwitchToClosedLoop
    ;mptblcname O2HIGH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HighLimitForImmediateSwitchToClosedLoop_$26_=_0.73v
    .byte 0x26                       ;Point 1

	;.org	0x8c1b
O2TLMH_HighLimitForDelayedSwitchToClosedLoop:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0x0CAB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForDelayedSwitchToClosedLoop
    ;mptblcname O2TLMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HighLimitForDelayedSwitchToClosedLoop
    .byte 0x1F                       ;Point 1

	;.org	0x8c1c
O2MIDH_HighLimitForInMiddleDetermination:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0x0CB8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForInMiddleDetermination
    ;mptblcname O2MIDH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HighLimitForInMiddleDetermination
    .byte 0x1F                       ;Point 1

	;.org	0x8c1d
O2HSWP_HighLimitForO2RampSwitching:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0x0CC5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForO2RampSwitching
    ;mptblcname O2HSWP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HighLimitForO2RampSwitching
    .byte 0x19                       ;Point 1

	;.org	0x8c1e
O2LSWP_LowLimitForO2RampSwitching:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0x0CD2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForO2RampSwitching
    ;mptblcname O2LSWP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LowLimitForO2RampSwitching
    .byte 0x18                       ;Point 1

	;.org	0x8c1f
O2MIDL_LowLimitForInMiddleDetermination:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0x0CDF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForInMiddleDetermination
    ;mptblcname O2MIDL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LowLimitForInMiddleDetermination._Used_for_Reverting_to_openLoop,_Setting_fault21,_outputting_O2_level_to_miller_tool
    .byte 0x12                       ;Point 1

	;.org	0x8c20
O2TLML_LowLimitForDelayedSwitchToClosedLoop:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0x0CEC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForDelayedSwitchToClosedLoop
    ;mptblcname O2TLML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LowLimitForDelayedSwitchToClosedLoop
    .byte 0x0F                       ;Point 1

	;.org	0x8c21
O2LOW_LowLimitForImmediateSwitchToClosedLoop:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0x0CF9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForImmediateSwitchToClosedLoop
    ;mptblcname O2LOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LowLimitForImmediateSwitchToClosedLoop
    .byte 0x0F                       ;Point 1

	;.org	0x8c22
O2TIME_DelayTimeToClosedLoop:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0x0D06
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DelayTimeToClosedLoop
    ;mptblcname O2TIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Delay_Time 0 720 Sec
    ;mptbldesc DelayTimeWhenGoingClosedLoop._o2_voltage_must_trigger_timer,_ie_must_gt_O2TLMH_or_lt_O2TLML.Each_1_is_2.8_sec,_cannot_exceed_$7f
    .byte 0x07                       ;Point 1

	;.org	0x8c23
LTHTIM_IfNoO2SwitchForThisTimeThrowFault51or52:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0x0D13
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname IfNoO2SwitchForThisTimeThrowFault51or52
    ;mptblcname LTHTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc If_no_O2_sensor_state_change_for_this_time(*2.8sec)_then_fault_51_or_52
    .byte 0x2B                       ;Point 1

	;.org	0x8c24
SECRMP_SecondaryRamp:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller_Ramps\
    ;mptbladdr 0x0D20
    ;mptbltype 11
    ;mpsubtype 1
    ;mptbllname SecondaryRamp
    ;mptblcname SECRMP
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Lower_RPM_Boundary_-_RPM/32
    ;mpmapaxis y
    .word 0x2F49                  ;Rpm Low / High Boundary
    .word 0x2958                  ;Map Low / High Boundary
    .word 0x02FE                  ;Cell 0 Ramp Rich/Lean
    .word 0x02FE                  ;Cell 1 Ramp Rich/Lean
    .word 0x02FE                  ;Cell 2 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 3 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 4 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 5 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 6 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 7 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 8 Ramp Rich/Lean
    .word 0x02FE                  ;Ramp Idle Cell Rich/Lean
    .word 0x0708                  ;Cell 0 Limits/Rates Rich/Lean
    .word 0x0708                  ;Cell 1 Limits/Rates Rich/Lean
    .word 0x0608                  ;Cell 2 Limits/Rates Rich/Lean
    .word 0x0808                  ;Cell 3 Limits/Rates Rich/Lean
    .word 0x0608                  ;Cell 4 Limits/Rates Rich/Lean
    .word 0x0508                  ;Cell 5 Limits/Rates Rich/Lean
    .word 0x0708                  ;Cell 6 Limits/Rates Rich/Lean
    .word 0x0608                  ;Cell 7 Limits/Rates Rich/Lean
    .word 0x0706                  ;Cell 8 Limits/Rates Rich/Lean
    .word 0x0808                  ;Limit/Rates Idle Cell Rich/Lean

; *****************************************
; For each cell, the first number is "rich", the second is "lean".
; If the O2 sensor is returning a lean value, "rich" kicks are added.
; If the O2 sensor is returning a rich value, "lean" kicks are added.
;
;     STEP - (factor * 512) - 512  (signed number)
; eg: %0.4  ->	(1.004	* 512) - 512 = 2.048 (dec) = 0x02
; each bit is ~ 0.2%
; *****************************************

	;.org	0x8c50
MPSHFT_OverboostFuelShutoffEnablePointFromMap_Timer:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Overboost\
    ;mptbladdr 0x0D4D
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostFuelShutoffEnablePointFromMap_Timer
    ;mptblcname MPSHFT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc If_MAP_+_BARO_exceeds_MPSHOF,_wait_SHFDLT,_then_kill_engine_for_TRNTM._Overboost_-_$ff_to_disable
    ;mpmapaxis y
    .byte 0x7B                       ;Point 1

	;.org	0x8c51
MPSHFA_OverboostFuelShutoffEnablePointFromMap_Absolute:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Overboost\
    ;mptbladdr 0x0D5B
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostFuelShutoffEnablePointFromMap_Absolute
    ;mptblcname MPSHFA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc If_MAP_+_BARO_exceeds_MPSHOF,_wait_SHFDLT,_then_kill_engine_for_TRNTM._Overboost_-_$ff_to_disable
    ;mpmapaxis y
    .byte 0x99                       ;Point 1

	;.org	0x8c52
TRNTIM_OverboostFuelShutoffDuration:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Overboost\
    ;mptbladdr 0x0D69
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OverboostFuelShutoffDuration
    ;mptblcname TRNTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 Sec
    ;mptbldesc Overboost_shutoff_duration_-_$ff_to_disable_-_stock_$5a
    .byte 0x8A                       ;Point 1

	;.org	0x8c53
LMPSHF_OverboostFuelShutoffDisablePointFromMap_Limp:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Overboost\
    ;mptbladdr 0x0D76
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostFuelShutoffDisablePointFromMap_Limp
    ;mptblcname LMPSHF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Overboost_Shutoff_when_Wastegate_problem_has_been_detected_(should_not_disable_this)
    ;mpmapaxis y
    .byte 0x73                       ;Point 1

	;.org	0x8c54
REVLMT_MapLimpinAndThrAbove25PercentLower1850:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0x0D84
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapLimpinAndThrAbove25PercentLower1850
    ;mptblcname REVLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Fuel_Off_RPM_for_bad_MAP
    .byte 0x3A                       ;Point 1

	;.org	0x8c55
REVLMT2_MapLimpinAndThrAbove25PercentUpper2000:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0x0D91
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapLimpinAndThrAbove25PercentUpper2000
    ;mptblcname REVLMT2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Fuel_On_RPM_for_bad_MAP
    .byte 0x3E                       ;Point 1

	;.org	0x8c56
REVLMT3_MapAbove75PctAndIdleSwitchClosed2000:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0x0D9E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapAbove75PctAndIdleSwitchClosed2000
    ;mptblcname REVLMT3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x3E                       ;Point 1

	;.org	0x8c57
REVLMT4_MapAbove75PctAndThrLimpin2000:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0x0DAB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapAbove75PctAndThrLimpin2000
    ;mptblcname REVLMT4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x5E                       ;Point 1

	;.org	0x8c58
REVLMT5_RPMLimiterNormalOnRPM:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Rev_Limiter\
    ;mptbladdr 0x0DB8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimiterNormalOnRPM
    ;mptblcname REVLMT5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0xD1                       ;Point 1

	;.org	0x8c59
REVLMT6_RPMLimiterNormalOffRPM:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Rev_Limiter\
    ;mptbladdr 0x0DC5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimiterNormalOffRPM
    ;mptblcname REVLMT6
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0xD2                       ;Point 1

	;.org	0x8c5a
THRTHR_25PctThrValueFromShutoff:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0x0DD2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 25PctThrValueFromShutoff
    ;mptblcname THRTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x21                       ;Point 1

	;.org	0x8c5b
RVLSPD_CarSpeedForRevLimitWithTBOff:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0x0DDF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CarSpeedForRevLimitWithTBOff
    ;mptblcname RVLSPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 127.5 mph
    ;mptbldesc Detailed_Description
    .byte 0x14                       ;Point 1

	;.org	0x8c5c
DFRPM1_2050RPM_DecelFuelShutoffTurnonLimit:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0x0DEC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 2050RPM_DecelFuelShutoffTurnonLimit
    ;mptblcname DFRPM1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x34                       ;Point 1

	;.org	0x8c5d
DFRPM2_2560RPM_DecelFuelShutoffUpperRpmLimit:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0x0DF9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 2550RPM_DecelFuelShutoffUpperRpmLimit
    ;mptblcname DFRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x36                       ;Point 1

	;.org	0x8c5e
DFS20M_20MPHDecelFuelShutoffSpeedLimitOFF:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0x0E06
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 20MPHDecelFuelShutoffSpeedLimitOFF
    ;mptblcname DFS20M
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x14                       ;Point 1

	;.org	0x8c5f
DFS20L_20MPHDecelFuelShutoffSpeedLimitON:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0x0E13
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 20MPHDecelFuelShutoffSpeedLimitON
    ;mptblcname DFS20L
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1

	;.org	0x8c60
DFSTMH_60DegCDecelFuelShutoffTempLimitOff:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0x0E20
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 60DegCDecelFuelShutoffTempLimitOff
    ;mptblcname DFSTMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x92                       ;Point 1

	;.org	0x8c61
DFSTML_60DegCDecelFuelShutoffTempLimitON:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0x0E2D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 60DegCDecelFuelShutoffTempLimitOn
    ;mptblcname DFSTML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x90                       ;Point 1

	;.org	0x8c62
DFSTMRH_3minuteDecelFuelShutoffTimeLimitOFF:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0x0E3A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 3minuteDecelFuelShutoffTimeLimitOFF
    ;mptblcname DFSTMRH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1

	;.org	0x8c63
DFSMPH_MAPDecelFuelShutoffTimeLimitOFF:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0x0E47
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MAPDecelFuelShutoffTimeLimitOFF
    ;mptblcname DFSMPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x24                       ;Point 1

	;.org	0x8c64
DFSMPL_MAPDecelFuelShutoffTimeLimitON:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0x0E55
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MAPDecelFuelShutoffTimeLimitON
    ;mptblcname DFSMPL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x27                       ;Point 1

L8C65_L8C65:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0x0E62
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname L8C36_L8C36
    ;mptblcname L8C36
    ;mpxaxis in_desc 15 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Point 1
    .byte 0x23                       ;Point 2
    .byte 0x01                       ;Point 3
    .byte 0x1F                       ;Point 4
    .byte 0x23                       ;Point 5
    .byte 0x1B                       ;Point 6
    .byte 0x11                       ;Point 7
    .byte 0x16                       ;Point 8
    .byte 0x32                       ;Point 9
    .byte 0x11                       ;Point 10
    .byte 0x21                       ;Point 11
    .byte 0xFF                       ;Point 12
    .byte 0xFF                       ;Point 13
    .byte 0xFF                       ;Point 14
    .byte 0xFF                       ;Point 15

	;.org	0x8c74
SPDLMH_SpeedLimitFuelShutoff254mph:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Speed_Limiter\
    ;mptbladdr 0x0E7D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SpeedLimitFuelShutoff254mph
    ;mptblcname SPDLMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 255 MPH
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x8c75
SPDLML_SpeedLimitFuelShutoffRestore253mph:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Speed_Limiter\
    ;mptbladdr 0x0E8A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SpeedLimitFuelShutoffRestore253mph
    ;mptblcname SPDLML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFD                       ;Point 1

	;.org	0x8c76
SPDRPM_EngineSpeedHighLimitToEnableOverspeed:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0x0E97
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineSpeedHighLimitToEnableOverspeed
    ;mptblcname SPDRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xD5                       ;Point 1

	;.org	0x8c77
SPDRPM2_EngineSpeedLowLimitToDisableOverspeed:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0x0EA4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineSpeedLowLimitToDisableOverspeed
    ;mptblcname SPDRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xD1                       ;Point 1

	;.org	0x8c78
AISTRT_AisStartupPosition_FromTemp:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0x0EB1
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisStartupPosition_FromTemp
    ;mptblcname AISTRT
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis AIS_Open 0 255 steps
    ;mptbldesc AIS_motor_startup_position_from_engine_temp
    .byte 0x06                       ;Number of points in table
    .byte 0x69, 0x86, 0xFC, 0x92     ;Point 1
    .byte 0x77, 0x56, 0xFF, 0xC7     ;Point 2
    .byte 0x92, 0x50, 0xFE, 0x80     ;Point 3
    .byte 0xA6, 0x32, 0xFE, 0xC0     ;Point 4
    .byte 0xB6, 0x1E, 0xFF, 0xC3     ;Point 5
    .byte 0xCF, 0x18                 ;Point 6

	;.org	0x8c8f
RPMDEF_RPMDefaultForIdleControl:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0x0EC4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMDefaultForIdleControl
    ;mptblcname RPMDEF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0xA0                       ;Point 1

	;.org	0x8c90
RPMTHS_RPMThresholdForIdleControl:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0x0ED1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMThresholdForIdleControl
    ;mptblcname RPMTHS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1

	;.org	0x8c91
TIMED2_AISDecelBaseAirflowCurveOffset2:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0x0EDE
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelAisBaseAirflowCurveOffset_FromTime2
    ;mptblcname TIMED2
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis Time 0 720 sec
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x0B, 0x0D, 0xFE, 0xD1     ;Point 1
    .byte 0x16, 0x00                 ;Point 2

	;.org	0x8c9c
AISDLY_DelayFromStartRunThatAisFeedbackDisabled:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0x0EED
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DelayFromStartRunThatAisFeedbackDisabled
    ;mptblcname AISDLY
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 720 sec
    ;mptbldesc Delay_from_Start/Run_transition_that_AIS_feedback_is_disabled_in_11msec_units
    .byte 0x5D                       ;Point 1

	;.org	0x8c9d
AISPN_IdleSpeedParkNeutral_FromTemp:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0x0EFA
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname IdleSpeedParkNeutral_FromTemp
    ;mptblcname AISPN
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis RPM 0 2048 rpm
    ;mptbldesc Idle_Speed_From_Temp_in_park/neutral_or_manual_trans
    .byte 0x03                       ;Number of points in table
    .byte 0x6E, 0xA3, 0xFF, 0x3C     ;Point 1
    .byte 0x7F, 0x96, 0xFF, 0x61     ;Point 2
    .byte 0xBC, 0x70                 ;Point 3

	;.org	0x8ca8
AISCLD_IdleSpeedDrive_FromTemp:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0x0F0A
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname IdleSpeedDrive_FromTemp
    ;mptblcname AISCLD
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis RPM 0 2048 rpm
    ;mptbldesc Idle_Speed_From_temp_in_Drive,_auto_trans_only
    .byte 0x03                       ;Number of points in table
    .byte 0x6E, 0xA3, 0xFF, 0x3C     ;Point 1
    .byte 0x7F, 0x96, 0xFF, 0x61     ;Point 2
    .byte 0xBC, 0x70                 ;Point 3

	;.org	0x8cb3
CLDPOS_AisColdPosition_FromTemp:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0x0F1A
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisColdPosition_FromTemp
    ;mptblcname CLDPOS
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis AIS_Open 0 2048 steps
    ;mptbldesc Cold_OffIdle_AIS_Positioning,_Increases_instantly,_decreases_after_DLYOFI
    .byte 0x06                       ;Number of points in table
    .byte 0x63, 0x80, 0xF4, 0x2B     ;Point 1
    .byte 0x69, 0x39, 0xFE, 0xD1     ;Point 2
    .byte 0x74, 0x2C, 0xFF, 0x80     ;Point 3
    .byte 0x84, 0x24, 0xFF, 0x9A     ;Point 4
    .byte 0xB1, 0x12, 0xFF, 0x46     ;Point 5
    .byte 0xC7, 0x02                 ;Point 6

	;.org	0x8cca
RPMPOS_AisPosition_FromRpm:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0x0F2D
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisPosition_FromRpm
    ;mptblcname RPMPOS
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc AIS_Position_from_RPMs
    .byte 0x04                       ;Number of points in table
    .byte 0x1F, 0x00, 0x00, 0x4F     ;Point 1
    .byte 0x2C, 0x04, 0x00, 0x36     ;Point 2
    .byte 0x3F, 0x08, 0x00, 0x0B     ;Point 3
    .byte 0x9C, 0x0C                 ;Point 4

	;.org	0x8cd9
THRPOS_AisPosition_FromThrottle:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0x0F3E
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisPosition_FromThrottle
    ;mptblcname THRPOS
    ;mpxaxis TPS 0 5 Volts
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc AIS_Position_from_throttle
    .byte 0x02                       ;Number of points in table
    .byte 0x02, 0x00, 0x00, 0x4F     ;Point 1
    .byte 0x0F, 0x04                 ;Point 2

	;.org	0x8ce8
ACCTBL_ACOffIdleDelta_FromSpeed:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x0F4D
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ACOffIdleDelta_FromSpeed
    ;mptblcname ACCTBL
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Number of points in table
    .byte 0x14, 0x10, 0x00, 0x9A     ;Point 1
    .byte 0x28, 0x1C, 0x00, 0x3A     ;Point 2
    .byte 0x50, 0x25, 0x00, 0xA0     ;Point 3
    .byte 0x78, 0x3E                 ;Point 4

	;.org	0x8cfb
ACPOS_ACPositionWhenTempToCold:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0x0F5E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ACPositionWhenTempToCold
    ;mptblcname ACPOS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AIS:_AC_clutch_position_when_temp_to_cold
    .byte 0x16                       ;Point 1

	;.org	0x8cfc
ACPOS2_ACPositionWhenTempToCold2:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0x0F6B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ACPositionWhenTempToCold2
    ;mptblcname ACPOS2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AIS:_AC_clutch_position_when_temp_to_cold
    .byte 0x18                       ;Point 1

	;.org	0x8cfd
ACTMP_Use_ACCTBL_WhenTempAboveThisElseUse_ACPOS:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x0F78
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Use_ACCTBL_WhenTempAboveThisElseUse_ACPOS
    ;mptblcname ACTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xA6                       ;Point 1

	;.org	0x8cfe
DLYOF1_UpdateRateOffIdleWhenAisClosing:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0x0F85
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UpdateRateOffIdleWhenAisClosing
    ;mptblcname DLYOF1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x1F                       ;Point 1

	;.org	0x8cff
ADDAIS_AISAddedFromTimeEngRunning:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0x0F92
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AISAddedFromTimeEngRunning
    ;mptblcname ADDAIS
    ;mpxaxis TimeEngRun 0 2.8 sec
    ;mpyaxis Factor 0 1 scale
    ;mptbldesc Description
    .byte 0x02                       ;Number of points in table
    .byte 0x0B, 0x06, 0xFF, 0x74     ;Point 1
    .byte 0x16, 0x00                 ;Point 2

	;.org	0x8d0e
BARAIS_AISBaroCompensation:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0x0FA1
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BaroCompensation_FromBaro
    ;mptblcname BARAIS
    ;mpxaxis Baro -14.7 14.7 psi
    ;mpyaxis Factor 0 1 scale
    ;mptbldesc Barometric_compensation_factor_for_AIS_control
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x5E, 0x26, 0xFC, 0x8C     ;Point 1
    .byte 0x69, 0x00                 ;Point 2

	;.org	0x8d1d
BRKRPM_BrakeOverrideForAis_FromDeltaThrottle:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0x0FB1
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname BrakeOverrideForAis_FromDeltaThrottle
    ;mptblcname BRKRPM
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0xFF                 ;Point 1

	;.org	0x8d24
FWDAIS_ForwardAisSteps_NoSlope:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0x0FBF
    ;mptbltype 12
    ;mpsubtype n
    ;mptbllname ForwardAisSteps_NoSlope
    ;mptblcname FWDAIS
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x06                       ;Number of points in table
    .byte 0x0F, 0x00                 ;Point 1
    .byte 0x14, 0x01                 ;Point 2
    .byte 0x28, 0x02                 ;Point 3
    .byte 0x3C, 0x04                 ;Point 4
    .byte 0x50, 0x05                 ;Point 5
    .byte 0x64, 0x06                 ;Point 6

	;.org	0x8d33
REVAIS_ReverseAisSteps_NoSlope:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0x0FD2
    ;mptbltype 12
    ;mpsubtype n
    ;mptbllname ReverseAisSteps_NoSlope
    ;mptblcname REVAIS
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Number of points in table
    .byte 0x0F, 0x00                 ;Point 1
    .byte 0x14, 0xFF                 ;Point 2
    .byte 0x28, 0xFE                 ;Point 3
    .byte 0x50, 0xFC                 ;Point 4

	;.org	0x8d42
TIMEDC_AISDecelBaseAirflowCurveOffset:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x0FE3
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelAisBaseAirflowCurveOffset_FromTime
    ;mptblcname TIMEDC
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis Time 0 720 sec
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x0F, 0x04, 0xFF, 0x80     ;Point 1
    .byte 0x13, 0x02, 0xFF, 0x9A     ;Point 2
    .byte 0x18, 0x00                 ;Point 3

	;.org	0x8d51
TEMPDC_AISDecel_FromTemp:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x0FF3
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelAis_FromTemp
    ;mptblcname TEMPDC
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x07                       ;Number of points in table
    .byte 0x63, 0x30, 0xFC, 0xD5     ;Point 1
    .byte 0x69, 0x1D, 0xFF, 0xA3     ;Point 2
    .byte 0x74, 0x19, 0xFF, 0xC9     ;Point 3
    .byte 0x90, 0x13, 0xFF, 0x90     ;Point 4
    .byte 0xA0, 0x0C, 0xFF, 0xDB     ;Point 5
    .byte 0xBC, 0x08, 0xFF, 0x94     ;Point 6
    .byte 0xCF, 0x00                 ;Point 7

	;.org	0x8d6c
DAISOP_DecelAisOpenStepsFromNeg_FromDeltaMap:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1007
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname DecelAisOpenStepsFromNeg_FromDeltaMap
    ;mptblcname DAISOP
    ;mpxaxis DeltaMAP 0 29.4 psi
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Decel_AIS_open_steps_from_-Delta_MAP
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x01, 0x00, 0x00, 0xBA     ;Point 1
    .byte 0x0C, 0x08                 ;Point 2

	;.org	0x8d7b
DAISCL_DecelAisOpenStepsFromPos_FromDeltaMap:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1017
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname DecelAisOpenStepsFromPos_FromDeltaMap
    ;mptblcname DAISCL
    ;mpxaxis DeltaMAP 0 29.4 psi
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Decel_AIS_open_steps_from_+Delta_MAP
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x02, 0x00, 0xFF, 0xAB     ;Point 1
    .byte 0x11, 0xFB                 ;Point 2

	;.org	0x8d8a
MAPFLR_AISAdditionToControlMap:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1027
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AdditionToControlMap
    ;mptblcname MAPFLR
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc AIS_Decel_Addition_to_control_MAP_vs._RPM
    .byte 0x04                       ;Number of points in table
    .byte 0x1F, 0x00, 0x00, 0x25     ;Point 1
    .byte 0x26, 0x01, 0x00, 0x3D     ;Point 2
    .byte 0x3F, 0x07, 0x00, 0x09     ;Point 3
    .byte 0x5D, 0x08                 ;Point 4

	;.org	0x8d9d
MPTEMP_TempTermForMapOffset_FromTemp:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1038
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempTermForMapOffset_FromTemp
    ;mptblcname MPTEMP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 1 Factor
    ;mptbldesc AIS_Decel_Temperature_Term
    .byte 0x02                       ;Number of points in table
    .byte 0x90, 0x00, 0x04, 0xA3     ;Point 1
    .byte 0xC7, 0xFF                 ;Point 2

	;.org	0x8dac
BARFLR_OffsetCorrectionTo_MAPFLR_FromBaro:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1047
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname OffsetCorrectionTo_MAPFLR_FromBaro
    ;mptblcname BARFLR
    ;mpxaxis Baro -14.7 14.7 psi
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc AIS_Decel_Offset_correction_due_to_baro_effect
    ;mpmapaxis x
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0x8dbb
DCLRFQ_TimeBetweenAisPulsesForDecelAis:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1056
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBetweenAisPulsesForDecelAis
    ;mptblcname DCLRFQ
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 Sec
    ;mptbldesc Detailed_Description
    .byte 0x14                       ;Point 1

	;.org	0x8dbc
DATHOT_EngineTempToStartCalibratingDacal:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1063
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineTempToStartCalibratingDacal
    ;mptblcname DATHOT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Deg
    ;mptbldesc Detailed_Description
    .byte 0xCA                       ;Point 1

	;.org	0x8dbd
DADRPM_DeltaRpmFromIdleSpeedForDacalUpdate:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1070
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaRpmFromIdleSpeedForDacalUpdate
    ;mptblcname DADRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1

	;.org	0x8dbe
DAACF_ACFactorDeltaFromBase:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x107D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ACFactorDeltaFromBase
    ;mptblcname DAACF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x12                       ;Point 1

	;.org	0x8dbf
DANOM_Base_nominalCal:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x108A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Base_nominalCal
    ;mptblcname DANOM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Point 1

	;.org	0x8dc0
DCALTM_DacalInhibitTimeAfterStartup:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1097
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DacalInhibitTimeAfterStartup
    ;mptblcname DCALTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x15                       ;Point 1

	;.org	0x8dc1
DCALRT_DacalUpdateRate01_03_07_0f_1f_3f_7f_ff:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x10A4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DacalUpdateRate01_03_07_0f_1f_3f_7f_ff
    ;mptblcname DCALRT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x3F                       ;Point 1

	;.org	0x8dc2
DCLMIN_MinLimitOnDecelAisControlledMap:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x10B1
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MinLimitOnDecelAisControlledMap
    ;mptblcname DCLMIN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

	;.org	0x8dc3
DCLMN2_NoAisControlIfMapAndControlMapBelowThis:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x10BF
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname NoAisControlIfMapAndControlMapBelowThis
    ;mptblcname DCLMN2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x15                       ;Point 1

	;.org	0x8dc4
DLYTIM_AisDelayAfterThrottleClosesWhenMoving:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x10CD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisDelayAfterThrottleClosesWhenMoving
    ;mptblcname DLYTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Decel_AIS_Delay_after_throttle_closes_when_moving
    .byte 0x5D                       ;Point 1

DLYTM2_AisDelayAfterThrottleClosesWhenStopped:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x10D9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisDelayAfterThrottleClosesWhenStopped
    ;mptblcname DLYTIM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Decel_AIS_Delay_after_throttle_closes_when_stopped
    .byte 0x20                       ;Point 1

	;.org	0x8dc6
DLYTM3_AisDelayAfterThrottleClosesWhenRpmAbove_DLYRPM:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x10E6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisDelayAfterThrottleClosesWhenRpmAbove_DLYRPM
    ;mptblcname DLYTM3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Decel_AIS_Delay_after_throttle_closes_when_MAP_is_below_DCLMN2
    .byte 0xD0                       ;Point 1

	;.org	0x8dc7
DLYRPM_RpmTriggerForAisDelay:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x10F3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RpmTriggerForAisDelay
    ;mptblcname DLYRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Decel_AIS_RPM_trigger_(third_AIS_delay)
    .byte 0x3D                       ;Point 1

	;.org	0x8dc8
MPHREF_SwitchPointForDecelIdleAisControl:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1100
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SwitchPointForDecelIdleAisControl
    ;mptblcname MPHREF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 127.5 mph
    ;mptbldesc Switch_point_between_Decel_or_Idle_AIS_control._Note_there_is_also_a_1.5_mph_hysteresis
    .byte 0x07                       ;Point 1

	;.org	0x8dc9
PNDLTN_DeltaRpmChangeToUse_DRPNK_or_PNDRK:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x110D
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DeltaRpmChangeToUse_DRPNK_or_PNDRK_A
    ;mptblcname PNDLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x1F40                     ;Point 1

PNDRK_ParkNeutralToDriveKicks_FromTemp:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1119
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ParkNeutralToDriveKicks_FromTemp
    ;mptblcname PNDRK
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0x8dd2
PNDLTP_DeltaRpmChangeToUse_DRPNK_or_PNDRK:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1127
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DeltaRpmChangeToUse_DRPNK_or_PNDRK_B
    ;mptblcname PNDLTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x00C8                     ;Point 1

DRPNK_DriveToParkNeutralKicks_FromTemp:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1133
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DriveToParkNeutralKicks_FromTemp
    ;mptblcname DRPNK
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0x8ddb
ACOFFK_ClosedThrottleAcOffKick:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1141
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ClosedThrottleAcOffKick
    ;mptblcname ACOFFK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1

	;.org	0x8ddc
AC2KCK_AcClutchKickOpenAfterAcEnabled:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x114E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcClutchKickOpenAfterAcEnabled
    ;mptblcname AC2KCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x8ddd
ACTIME_TimeBeforeAcEnabledAndFullDeltaUsed:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x115B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBeforeAcEnabledAndFullDeltaUsed
    ;mptblcname ACTIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x16                       ;Point 1

	;.org	0x8dde
ACTDEF_TimeBeforeAcEnabledAndFullDeltaUsed_Default:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1168
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBeforeAcEnabledAndFullDeltaUsed_Default
    ;mptblcname ACTDEF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x16                       ;Point 1

	;.org	0x8ddf
PERKCK_AcClutchAisAdjustmentConstant:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1175
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcClutchAisAdjustmentConstant
    ;mptblcname PERKCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x80                       ;Point 1

	;.org	0x8de0
AC4KCK_AcClutchKickOpenBeforeAcEnabled2:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1182
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcClutchKickOpenBeforeAcEnabled2
    ;mptblcname AC4KCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xF2                       ;Point 1

	;.org	0x8de1
AC3KCK_AcClutchKickOpenAfterAcEnabled2:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x118F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcClutchKickOpenAfterAcEnabled2
    ;mptblcname AC3KCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x8de2
ACTIM2_TimeBeforeAcEnabledAndFullDeltaUsed2:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x119C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBeforeAcEnabledAndFullDeltaUsed2
    ;mptblcname ACTIM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x16                       ;Point 1

	;.org	0x8de3
OFFPER_AisInstantlyClosesWhenAcDisengages:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x11A9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisInstantlyClosesWhenAcDisengages
    ;mptblcname OFFPER
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x80                       ;Point 1

	;.org	0x8de4
OFFPER2_AisInstantlyClosesWhenAcDisengages2:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x11B6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisInstantlyClosesWhenAcDisengages2
    ;mptblcname OFFPER2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x80                       ;Point 1

	;.org	0x8de5
AISMPH_RollingAisMaxSpeed:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x11C3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisMaxSpeed
    ;mptblcname AISMPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1

	;.org	0x8de6
RPMDLT_RollingAisMinRpm:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x11D0
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname RollingAisMinRpm
    ;mptblcname RPMDLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x07D0                     ;Point 1

	;.org	0x8de8
ISPDCY_RollingAisDecay:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x11DD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisDecay
    ;mptblcname ISPDCY
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1

	;.org	0x8de9
DECAIS_RollingAisUpdateRate_01_03_07_0f_1f_3f_7f_ff:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x11EA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisUpdateRate_01_03_07_0f_1f_3f_7f_ff
    ;mptblcname DECAIS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x7F                       ;Point 1

	;.org	0x8dea
AISLMH_RollingAisHighLimit:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x11F7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisHighLimit
    ;mptblcname AISLMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x1A                       ;Point 1

	;.org	0x8deb
AISLML_RollingAisLowLimit:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1204
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisLowLimit
    ;mptblcname AISLML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x06                       ;Point 1

	;.org	0x8dec
ACDTMP_PartThrottleAcCutoutDisableTemp:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1211
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PartThrottleAcCutoutDisableTemp
    ;mptblcname ACDTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x8ded
ACDTHR_PartThrottleAcCutoutDisableThrottle:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x121E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PartThrottleAcCutoutDisableThrottle
    ;mptblcname ACDTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x8dee
ACDSPD_PartThrottleAcCutoutDisableSpeed:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x122B
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname PartThrottleAcCutoutDisableSpeed
    ;mptblcname ACDSPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0000                     ;Point 1

	;.org	0x8df0
ACETIM_PartThrottleAcCutoutMaxTimeActive:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1238
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PartThrottleAcCutoutMaxTimeActive
    ;mptblcname ACETIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x08                       ;Point 1

	;.org	0x8df1
ACERPM_AllowAcClutchAboveThisRpm:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1245
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AllowAcClutchAboveThisRpm
    ;mptblcname ACERPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x44                       ;Point 1

	;.org	0x8df2
ACESPD_AllowAcClutchAboveThisSpeed:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1252
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname AllowAcClutchAboveThisSpeed
    ;mptblcname ACESPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0500                     ;Point 1

	;.org	0x8df4
ACAETH_DisallowAcClutchEngageForThisTimeAfterAccelEnrich:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x125F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DisallowAcClutchEngageForThisTimeAfterAccelEnrich
    ;mptblcname ACAETH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xD6                       ;Point 1

	;.org	0x8df5
BTVAIS_MinVoltageForAis:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x126C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinVoltageForAis
    ;mptblcname BTVAIS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x71                       ;Point 1

	;.org	0x8df6
AISFRQ_AisPeriodForRpmFeedback11ms:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1279
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisPeriodForRpmFeedback11ms
    ;mptblcname AISFRQ
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x82                       ;Point 1

	;.org	0x8df7
AISHLM_AisHighLimitMaxOpenSteps:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1286
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisHighLimitMaxOpenSteps
    ;mptblcname AISHLM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xA0                       ;Point 1

	;.org	0x8df8
AISFAN_AisKickWhenFanTurnsOnClosedThrottle:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0x1293
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisKickWhenFanTurnsOnClosedThrottle
    ;mptblcname AISFAN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x08                       ;Point 1

	;.org	0x8df9
CALPOS_PositionAisMotorIsAtIdle:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0x12A0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PositionAisMotorIsAtIdle
    ;mptblcname CALPOS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AIS:_Position_electronics_thinks_motor_is_(at_idle)
    .byte 0x1A                       ;Point 1

	;.org	0x8dfa
CALRAT_AisAdjustRate:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0x12AD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisAdjustRate
    ;mptblcname CALRAT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AIS_update_rate_when_calibrating_-_rate=(CALRAT+1)*11ms_(can_be_0,1,3,7,f,1f,3f,7f,ff)
    .byte 0x07                       ;Point 1

	;.org	0x8dfb
WSGRPM_AllowedBoost_FromRpm:
    ;mpgrp Boost_Control\Target_Lookup\
    ;mptbladdr 0x12BA
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromRpm
    ;mptblcname WSGRPM
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_RPMs._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0xBE, 0x61, 0xFE, 0x33     ;Point 1
    .byte 0xC8, 0x4F                 ;Point 2

	;.org	0x8e0e
WSGRPA_AllowedBoostKnock_FromRpm:
    ;mpgrp Boost_Control\Target_Lookup\
    ;mptbladdr 0x12CA
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoostKnock_FromRpm
    ;mptblcname WSGRPA
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_RPMs_while_knocking._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x7A, 0x45, 0x00, 0x55     ;Point 1
    .byte 0x80, 0x47                 ;Point 2

	;.org	0x8e21
WSGTIM_AllowedBoost_FromTime:
    ;mpgrp Boost_Control\Target_Lookup\
    ;mptbladdr 0x12DA
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromTime
    ;mptblcname WSGTIM
    ;mpxaxis Time 0 0.72 Sec
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_time_in_boost._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x61                 ;Point 1

	;.org	0x8e2c
WSGCLT_AllowedBoost_FromTemp:
    ;mpgrp Boost_Control\Target_Lookup\
    ;mptbladdr 0x12E9
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromTemp
    ;mptblcname WSGCLT
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_Engine_Temp._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x04                       ;Number of points in table
    .byte 0x9B, 0x46, 0x00, 0xB1     ;Point 1
    .byte 0xC2, 0x61, 0x00, 0x00     ;Point 2
    .byte 0xEE, 0x61, 0xFB, 0x80     ;Point 3
    .byte 0xF4, 0x46                 ;Point 4

	;.org	0x8e3f
WSGCHG_AllowedBoost_FromChargeTemp:
    ;mpgrp Boost_Control\Target_Lookup\
    ;mptbladdr 0x12FB
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromChargeTemp
    ;mptblcname WSGCHG
    ;mpxaxis charge_temp -200 260 degrees
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_Charge_Temp._Boost_is_defined_as_MAP_reading_above_Baro._Charge_Temp_numbers_are_approximate_only
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0xF8, 0x61, 0xFB, 0x80     ;Point 1
    .byte 0xFE, 0x46                 ;Point 2

	;.org	0x8e4e
MXSBST_AllowedBoost_FromSpeed:
    ;mpgrp Boost_Control\Target_Lookup\
    ;mptbladdr 0x130B
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoostForAutomatics_FromSpeed
    ;mptblcname MXSBST
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_Speed_to_protect_automatic_transmissions.
    ;mpmapaxis y
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x61                 ;Point 1

	;.org	0x8e61
WSGPRT_AllowedBoostPartThrottle_FromThrottle:
    ;mpgrp Boost_Control\Target_Lookup\
    ;mptbladdr 0x131A
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoostPartThrottle_FromThrottle
    ;mptblcname WSGPRT
    ;mpxaxis TPS 0 5 volts
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_Throttle_at_Part_Throttle._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x60, 0x46, 0x00, 0xD8     ;Point 1
    .byte 0x80, 0x61                 ;Point 2

	;.org	0x8e70
DCWOT_FullThrottleWastegateDutyCycle_C8is100Percent_FromMap:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x132A
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FullThrottleWastegateDutyCycle_C8is100Percent_FromMap
    ;mptblcname DCWOT
    ;mpxaxis TargetBoost 0 29.4 psi
    ;mpyaxis Duty_Cycle 0 127.5 percent
    ;mptbldesc WOT_WG_Duty_Cycle
    ;mpmapaxis x
    .byte 0x05                       ;Number of points in table
    .byte 0x42, 0x43, 0x01, 0x00     ;Point 1
    .byte 0x46, 0x47, 0x02, 0x66     ;Point 2
    .byte 0x50, 0x5F, 0x00, 0xD1     ;Point 3
    .byte 0x5B, 0x68, 0x01, 0x00     ;Point 4
    .byte 0x61, 0x6E                 ;Point 5

	;.org	0x8e8b
DCWADJ_FullThrottleWastegateDutyCycleAdjustment_FromRpm:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x133D
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname FullThrottleWastegateDutyCycleAdjustment_FromRpm
    ;mptblcname DCWADJ
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis DC_Adjust -64 63.5 percent
    ;mptbldesc WOT_Duty_Cycle_Adjustment
    .byte 0x07                       ;Number of points in table
    .byte 0x3E, 0x40, 0xFC, 0x00     ;Point 1
    .byte 0x4E, 0x00, 0x00, 0x00     ;Point 2
    .byte 0x6D, 0x00, 0x00, 0x4A     ;Point 3
    .byte 0x8C, 0x09, 0x00, 0xE0     ;Point 4
    .byte 0x9C, 0x17, 0x00, 0x84     ;Point 5
    .byte 0xBB, 0x27, 0x00, 0x50     ;Point 6
    .byte 0xCB, 0x2C                 ;Point 7

	;.org	0x8eaa
DCWCHG_FullThrottleWastegateDutyCycleAdjustment_FromChargeTemp:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x1351
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname FullThrottleWastegateDutyCycleAdjustment_FromChargeTemp
    ;mptblcname DCWCHG
    ;mpxaxis Charge_Temp -200 260 F
    ;mpyaxis DC_Adjust -64 63.5 percent
    ;mptbldesc WOT_Duty_Cycle_Adjustment
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0x8ebd
BSTTSH_BoostTargetThresholdForDefaultWGDutyCycle:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x135F
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname BoostTargetThresholdForDefaultWGDutyCycle
    ;mptblcname BSTTSH
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Desc
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x5E, 0x28, 0x00, 0x2C     ;Point 1
    .byte 0x8D, 0x30                 ;Point 2

	;.org	0x8ecc
BSTTH2_BoostTargetThresholdForDefaultWGDutyCycle2:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x136F
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BoostTargetThresholdForDefaultWGDutyCycle2
    ;mptblcname BSTTH2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Desc
    ;mpmapaxis y
    .byte 0x50                       ;Point 1

	;.org	0x8ecd
DFWGDC_DefaultWastegateDutyCycle:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x137D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DefaultWastegateDutyCycle
    ;mptblcname DFWGDC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis WGDC 0 127 %
    ;mptbldesc Desc
    .byte 0x6E                       ;Point 1

	;.org	0x8ece
MAPPT2_WastegateDutyCycleMapSwitchPoint2:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x138A
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname WastegateDutyCycleMapSwitchPoint2
    ;mptblcname MAPPT2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Wastegate_Duty_Cycle_Adjustment_Map_Switch_Point
    ;mpmapaxis y
    .byte 0x04                       ;Point 1

	;.org	0x8ecf
RPMBST_MinimumRpmToTrackBoostCreep:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x1398
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumRpmToTrackBoostCreep
    ;mptblcname RPMBST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Min_RPM_to_increment_the_boost_error_timer.
    .byte 0x3B                       ;Point 1

	;.org	0x8ed0
WGILML_WGIncrementLimitLo:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x13A5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WGIncrementLimitLo
    ;mptblcname WGILML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis WGDC 0 127 %
    ;mptbldesc Desc
    .byte 0xA0                       ;Point 1

	;.org	0x8ed1
DFWGD2_DefaultWastegateDutyCycle2:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x13B2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DefaultWastegateDutyCycle2
    ;mptblcname DFWGD2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis WGDC 0 127 %
    ;mptbldesc Desc
    .byte 0x40                       ;Point 1

	;.org	0x8ed2
KDCINC_WastegateDutyCycleIncreaseStepWhenKnocking:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x13BF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseStepWhenKnocking
    ;mptblcname KDCINC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x8ed3
KDCMAX_WastegateDutyCycleIncreaseMaxWhenKnocking:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x13CC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseMaxWhenKnocking
    ;mptblcname KDCMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x27                       ;Point 1

	;.org	0x8ed4
KDCMIN_WastegateDutyCycleIncreaseMinWhenKnocking:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x13D9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseMinWhenKnocking
    ;mptblcname KDCMIN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

	;.org	0x8ed5
DECTIM_TimeScaleFor_DCDECK:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x13E6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeScaleFor_DCDECK
    ;mptblcname DECTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x07                       ;Point 1

	;.org	0x8ed6
DCDECK_WastegateDutyCycleDecrementWhenSparkStillDerated:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x13F3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleDecrementWhenSparkStillDerated
    ;mptblcname DCDECK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

	;.org	0x8ed7
MPDEL1_IncCounterWhenDeltaMapBelowThis:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x1400
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname IncCounterWhenDeltaMapBelowThis
    ;mptblcname MPDEL1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x07                       ;Point 1

	;.org	0x8ed8
MPFLOR_StopAdaptiveWGWhenDeltaMapIsLessThanThis:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x140E
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname StopAdaptiveWhenDeltaMapIsLessThanThis
    ;mptblcname MPFLOR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x02                       ;Point 1

	;.org	0x8ed9
DBCRNG_DeltaBoostLimitNegativeForBoostCreep:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x141C
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaBoostLimitNegativeForBoostCreep
    ;mptblcname DBCRNG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaBoost 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x03                       ;Point 1

	;.org	0x8eda
DECPT_AdaptiveDecAfterThisTime:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x142A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveDecAfterThisTime
    ;mptblcname DECPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_BoostErrTimer_counts_before_WG_Duty_Cycle_is_decremented._Used_when_boost_is_above_target.
    .byte 0x18                       ;Point 1

	;.org	0x8edb
DECLIM_LowerLimitOnWastegateDutyCycleCorrection:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x1437
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowerLimitOnWastegateDutyCycleCorrection
    ;mptblcname DECLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x8edc
WGDCOF_WastegateDutyCycleOffset:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x1444
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleOffset
    ;mptblcname WGDCOF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DutyCycle 0 127.5 Percent
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x8edd
MPROOF_StopAdaptiveWGWhenMapIsThisCloseToBoostTarget:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x1451
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname StopAdaptiveWGWhenMapIsThisCloseToBoostTarget
    ;mptblcname MPROOF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x00                       ;Point 1

	;.org	0x8ede
MPDEL2_IncCounterWhenDeltaMapBelowThis2:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x145F
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname IncCounterWhenDeltaMapBelowThis2
    ;mptblcname MPDEL2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x09                       ;Point 1

	;.org	0x8edf
DECPTX_AdaptiveDecAfterThisTimeX:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x146D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveDecAfterThisTimeX
    ;mptblcname DECPTX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x20                       ;Point 1

	;.org	0x8ee0
WGMXER_MaxWGDCForBoostErrorCorrection:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x147A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxWGDCForBoostErrorCorrection
    ;mptblcname WGMXER
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis WGDC 0 127.5 percent
    ;mptbldesc Detailed_Description
    .byte 0xC6                       ;Point 1

	;.org	0x8ee1
DCRPML_NoWastegateDutyCycleCorrectionBelowThisRpm:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x1487
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoWastegateDutyCycleCorrectionBelowThisRpm
    ;mptblcname DCRPML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x55                       ;Point 1

	;.org	0x8ee2
DCRPMH_NoWastegateDutyCycleCorrectionAboveThisRpm:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x1494
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoWastegateDutyCycleCorrectionAboveThisRpm
    ;mptblcname DCRPMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0xBE                       ;Point 1

	;.org	0x8ee3
TPSLIM_UpdateAdaptiveWGTPSUpperLimit:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x14A1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UpdateAdaptiveWGTPSUpperLimit
    ;mptblcname TPSLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis TPS_Volts 0 5 volts
    ;mptbldesc Detailed_Description
    .byte 0x5B                       ;Point 1

	;.org	0x8ee4
DCCTSL_NoWastegateDutyCycleCorrectionBelowThisCoolantTemp:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x14AE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoWastegateDutyCycleCorrectionBelowThisCoolantTemp
    ;mptblcname DCCTSL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis CoolantTemp -200 260 DegF
    ;mptbldesc Detailed_Description
    .byte 0xB1                       ;Point 1

	;.org	0x8ee5
DECPTV_AdaptiveDecAfterThisTimeBC:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x14BB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveDecAfterThisTimeBC
    ;mptblcname DECPTV
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis BstErrTime 0 2.8 sec
    ;mptbldesc Detailed_Description
    .byte 0x20                       ;Point 1

INCPTV_AdaptiveIncAfterThisTimeBC:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x14C7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveIncAfterThisTimeBC
    ;mptblcname INCPTV
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis BstErrTime 0 2.8 sec
    ;mptbldesc Detailed_Description
    .byte 0x20                       ;Point 1

	;.org	0x8ee7
DCRPMLV_NoWastegateDutyCycleCorrectionBelowThisRpmBC:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x14D4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoWastegateDutyCycleCorrectionBelowThisRpmBC
    ;mptblcname DCRPMLV
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x40                       ;Point 1

	;.org	0x8ee8
MAPPT_WastegateDutyCycleMapSwitchPoint:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x14E1
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname WastegateDutyCycleMapSwitchPoint
    ;mptblcname MAPPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Wastegate_Duty_Cycle_Adjustment_boost_switch_point.
    ;mpmapaxis y
    .byte 0x46                       ;Point 1

	;.org	0x8ee9
DCRPM1_WastegateDutyCycleRpmBoundary1:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x14EF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleRpmBoundary1
    ;mptblcname DCRPM1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x7D                       ;Point 1

	;.org	0x8eea
DCRPM2_WastegateDutyCycleRpmBoundary2:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x14FC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleRpmBoundary2
    ;mptblcname DCRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x96                       ;Point 1

	;.org	0x8eeb
DCRPM3_WastegateDutyCycleRpmBoundary3:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x1509
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleRpmBoundary3
    ;mptblcname DCRPM3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0xAF                       ;Point 1

	;.org	0x8eec
DCRPM4_WastegateDutyCycleRpmBoundary4:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x1516
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleRpmBoundary4
    ;mptblcname DCRPM4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0xFE                       ;Point 1

	;.org	0x8eed
DCRPM5_WastegateDutyCycleRpmBoundary5:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x1523
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleRpmBoundary5
    ;mptblcname DCRPM5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x8eee
BPRMIN_VNTMinimumBoostForIncrRateAdjustment:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x1530
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname VNTMinimumBoostForIncrRateAdjustment
    ;mptblcname BPRMIN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0xEE                       ;Point 1

; this value is not used in the T3 code
NTUSD1:
    ;mpgrp Setup\Cal_ID\
    ;mptbladdr 0x153E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NotUsed1
    ;mptblcname NTUSD1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Description
    .byte 0x40                       ;Point 1

	;.org	0x8ef0
BPRMN2_VNTMinimumDeltaBoostForIncrRateAdjustment:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x154B
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname VNTMinimumDeltaBoostForIncrRateAdjustment
    ;mptblcname BPRMN2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x06                       ;Point 1

	;.org	0x8ef1
DLTBSC_DeltaBoostSampleCounterMax:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x1559
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaBoostSampleCounterMax
    ;mptblcname DLTBSC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaBTimer 0 2.8 sec
    ;mptbldesc Detailed_Description
    .byte 0x07                       ;Point 1

	;.org	0x8ef2
WGDCDB_VNTWGDutyCycleDecreaseFromDeltaBoost:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x1566
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname VNTWGDutyCycleDecreaseFromDeltaBoost
    ;mptblcname WGDCDB
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaBst 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x05, 0x00, 0x02, 0xAB     ;Point 1
    .byte 0x11, 0x20                 ;Point 2

	;.org	0x8f01
OBCTRL_OverboostControlPoint:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x1576
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostControlPoint
    ;mptblcname OBCTRL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x73                       ;Point 1

	;.org	0x8f02
DBCRPS_DeltaBoostLimitPositiveForBoostCreep:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x1584
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaBoostLimitPositiveForBoostCreep
    ;mptblcname DBCRPS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

	;.org	0x8f03
INCPT_AdaptiveIncAfterThisTime:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x1592
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveIncAfterThisTime
    ;mptblcname INCPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaBTimer 0 2.8 sec
    ;mptbldesc Detailed_Description
    .byte 0x06                       ;Point 1

	;.org	0x8f04
WGDCON_WGDCOffsetNegatve:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0x159F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WGDCOffsetNegatve
    ;mptblcname WGDCON
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis WGDC 0 127.5 percent
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

	;.org	0x8f05
BRPMLO_BaroReadLowRPM1800:
    ;mpgrp Utility\Baro_Read\
    ;mptbladdr 0x15AC
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname BaroReadLowRPM1800
    ;mptblcname BRPMLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .word 0x3840                     ;Point 1

	;.org	0x8f07
BRPMHI_BaroReadHighRPM6650:
    ;mpgrp Utility\Baro_Read\
    ;mptbladdr 0x15B9
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname BaroReadHighRPM6650
    ;mptblcname BRPMHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .word 0xCFD0                     ;Point 1

	;.org	0x8f09
BRDLAY_BaroReadDelayAfterThrottleClosed2sec:
    ;mpgrp Utility\Baro_Read\
    ;mptbladdr 0x15C6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadDelayAfterThrottleClosed2sec
    ;mptblcname BRDLAY
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Detailed_Description
    .byte 0xB5                       ;Point 1

	;.org	0x8f0a
BARTIM_BaroReadMinTimeBetweenReadings179sec:
    ;mpgrp Utility\Baro_Read\
    ;mptbladdr 0x15D3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadMinTimeBetweenReadings179sec
    ;mptblcname BARTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 720 sec
    ;mptbldesc Detailed_Description
    .byte 0x40                       ;Point 1

	;.org	0x8f0b
BROPTM_BaroReadDelayAfterSolenoidOpenTenthSec:
    ;mpgrp Utility\Baro_Read\
    ;mptbladdr 0x15E0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadDelayAfterSolenoidOpenTenthSec
    ;mptblcname BROPTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Detailed_Description
    .byte 0x09                       ;Point 1

	;.org	0x8f0c
BRCLTM_BaroReadDelayAfterSolenoidClosedTenthSec:
    ;mpgrp Utility\Baro_Read\
    ;mptbladdr 0x15ED
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadDelayAfterSolenoidClosedTenthSec
    ;mptblcname BRCLTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Detailed_Description
    .byte 0x09                       ;Point 1

	;.org	0x8f0d
BAROHI_BaroReadValidHighLimit:
    ;mpgrp Utility\Baro_Read\
    ;mptbladdr 0x15FA
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BaroReadValidHighLimit
    ;mptblcname BAROHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x85                       ;Point 1

	;.org	0x8f0e
BAROLO_BaroReadValidLowLimit:
    ;mpgrp Utility\Baro_Read\
    ;mptbladdr 0x1608
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BaroReadValidLowLimit
    ;mptblcname BAROLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x45                       ;Point 1

	;.org	0x8f0f
BARDFT_BaroReadDefaultValue:
    ;mpgrp Utility\Baro_Read\
    ;mptbladdr 0x1616
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BaroReadDefaultValue
    ;mptblcname BARDFT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x7F                       ;Point 1

	;.org	0x8f10
FANTMP1_FanTurnOnTempAbove45Mph:
    ;mpgrp Fan_Control\
    ;mptbladdr 0x1624
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOnTempAbove45Mph
    ;mptblcname FANTMP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc Detailed_Description3
    .byte 0xE8                       ;Point 1

FANTMP2_FanTurnOffTempAbove45Mph:
    ;mpgrp Fan_Control\
    ;mptbladdr 0x1630
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOffTempAbove45Mph
    ;mptblcname FANTMP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc Detailed_Description3
    .byte 0xE3                       ;Point 1

FANTMP3_FanTurnOnTempBelow35Mph:
    ;mpgrp Fan_Control\
    ;mptbladdr 0x163C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOnTempBelow35Mph
    ;mptblcname FANTMP3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc Detailed_Description3
    .byte 0xE3                       ;Point 1

FANTMP4_FanTurnOffTempBelow35Mph:
    ;mpgrp Fan_Control\
    ;mptbladdr 0x1648
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOffTempBelow35Mph
    ;mptblcname FANTMP4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc Detailed_Description3
    .byte 0xDD                       ;Point 1

	;.org	0x8f14
FANMAP_FanTurnsOnWhenMapAboveBaroPlusThis:
    ;mpgrp Fan_Control\
    ;mptbladdr 0x1655
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname FanTurnsOnWhenMapAboveBaroPlusThis
    ;mptblcname FANMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1

	;.org	0x8f15
FANBAT_FanTurnsOnWhenBatteryTempAboveThis:
    ;mpgrp Fan_Control\
    ;mptbladdr 0x1663
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnsOnWhenBatteryTempAboveThis
    ;mptblcname FANBAT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Battery_Temp -200 260 Degrees
    ;mptbldesc Detailed_Description
    .byte 0x1B                       ;Point 1

	;.org	0x8f16
PURMAP_CannisterPurgeWhenBelowThisBaro:
    ;mpgrp Utility\Purge_Control\
    ;mptbladdr 0x1670
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname CannisterPurgeWhenBelowThisBaro
    ;mptblcname PURMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x7F                       ;Point 1

	;.org	0x8f17
PURHYS_CannisterPurgeBaroHysteresis:
    ;mpgrp Utility\Purge_Control\
    ;mptbladdr 0x167E
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname CannisterPurgeBaroHysteresis
    ;mptblcname PURHYS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x02                       ;Point 1

	;.org	0x8f18
PURTMP_CanisterPurgeCoolantTemp:
    ;mpgrp Utility\Purge_Control\
    ;mptbladdr 0x168C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CanisterPurgeCoolantTemp
    ;mptblcname PURTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xB6                       ;Point 1

	;.org	0x8f19
CL2PTR_Cyl2AdaptiveMemoryPointer:
    ;mpgrp Fuel\O2_Feedback_Control\Individual_Cylinder_Trim\
    ;mptbladdr 0x1699
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl2AdaptiveMemoryPointer
    ;mptblcname CL2PTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0D                       ;Point 1

	;.org	0x8f1a
CL1PTR_Cyl1AdaptiveMemoryPointer:
    ;mpgrp Fuel\O2_Feedback_Control\Individual_Cylinder_Trim\
    ;mptbladdr 0x16A6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl1AdaptiveMemoryPointer
    ;mptblcname CL1PTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Point 1

	;.org	0x8f1b
CL3PTR_Cyl3AdaptiveMemoryPointer:
    ;mpgrp Fuel\O2_Feedback_Control\Individual_Cylinder_Trim\
    ;mptbladdr 0x16B3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl3AdaptiveMemoryPointer
    ;mptblcname CL3PTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1

	;.org	0x8f1c
CL4PTR_Cyl4AdaptiveMemoryPointer:
    ;mpgrp Fuel\O2_Feedback_Control\Individual_Cylinder_Trim\
    ;mptbladdr 0x16C0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl4AdaptiveMemoryPointer
    ;mptblcname CL4PTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Point 1

	;.org	0x8f1d
CL2LMT_Cyl2TrimLimit:
    ;mpgrp Fuel\O2_Feedback_Control\Individual_Cylinder_Trim\
    ;mptbladdr 0x16CD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl2TrimLimit
    ;mptblcname CL2LMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x33                       ;Point 1

	;.org	0x8f1e
CL1LMT_Cyl1TrimLimit:
    ;mpgrp Fuel\O2_Feedback_Control\Individual_Cylinder_Trim\
    ;mptbladdr 0x16DA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl1TrimLimit
    ;mptblcname CL1LMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x33                       ;Point 1

	;.org	0x8f1f
CL3LMT_Cyl3TrimLimit:
    ;mpgrp Fuel\O2_Feedback_Control\Individual_Cylinder_Trim\
    ;mptbladdr 0x16E7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl3TrimLimit
    ;mptblcname CL3LMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x33                       ;Point 1

	;.org	0x8f20
CL4LMT_Cyl4TrimLimit:
    ;mpgrp Fuel\O2_Feedback_Control\Individual_Cylinder_Trim\
    ;mptbladdr 0x16F4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl4TrimLimit
    ;mptblcname CL4LMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x33                       ;Point 1

	;.org	0x8f21
CL2INC_Cyl2TrimIncrement:
    ;mpgrp Fuel\O2_Feedback_Control\Individual_Cylinder_Trim\
    ;mptbladdr 0x1701
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl2TrimIncrement
    ;mptblcname CL2INC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Point 1

	;.org	0x8f22
CL1INC_Cyl1TrimIncrement:
    ;mpgrp Fuel\O2_Feedback_Control\Individual_Cylinder_Trim\
    ;mptbladdr 0x170E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl1TrimIncrement
    ;mptblcname CL1INC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Point 1

	;.org	0x8f23
CL3INC_Cyl3TrimIncrement:
    ;mpgrp Fuel\O2_Feedback_Control\Individual_Cylinder_Trim\
    ;mptbladdr 0x171B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl3TrimIncrement
    ;mptblcname CL3INC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Point 1

	;.org	0x8f24
CL4INC_Cyl4TrimIncrement:
    ;mpgrp Fuel\O2_Feedback_Control\Individual_Cylinder_Trim\
    ;mptbladdr 0x1728
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl4TrimIncrement
    ;mptblcname CL4INC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Point 1

	;.org	0x8f25
CLTRMN_MinimumCylinderTrim:
    ;mpgrp Fuel\O2_Feedback_Control\Individual_Cylinder_Trim\
    ;mptbladdr 0x1735
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumCylinderTrim
    ;mptblcname CLTRMN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x07                       ;Point 1

	;.org	0x8f26
CLTRP2_Cyl2TrimValueForPurgeVolume:
    ;mpgrp Fuel\O2_Feedback_Control\Individual_Cylinder_Trim\
    ;mptbladdr 0x1742
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl2TrimValueForPurgeVolume
    ;mptblcname CLTRP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x20                       ;Point 1

CLTRP1_Cyl1TrimValueForPurgeVolume:
    ;mpgrp Fuel\O2_Feedback_Control\Individual_Cylinder_Trim\
    ;mptbladdr 0x174E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl1TrimValueForPurgeVolume
    ;mptblcname CLTRP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x12                       ;Point 1

	;.org	0x8f28
CLTRP3_Cyl3TrimValueForPurgeVolume:
    ;mpgrp Fuel\O2_Feedback_Control\Individual_Cylinder_Trim\
    ;mptbladdr 0x175B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl3TrimValueForPurgeVolume
    ;mptblcname CLTRP3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xDB                       ;Point 1

	;.org	0x8f29
CLTRP4_Cyl4TrimValueForPurgeVolume:
    ;mpgrp Fuel\O2_Feedback_Control\Individual_Cylinder_Trim\
    ;mptbladdr 0x1768
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl4TrimValueForPurgeVolume
    ;mptblcname CLTRP4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x84                       ;Point 1

	;.org	0x8f2a
ACLRPM_DisableAcBelowThisRPM_500:
    ;mpgrp Utility\AC_Control\
    ;mptbladdr 0x1775
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DisableAcBelowThisRPM_500
    ;mptblcname ACLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0FA0                     ;Point 1

	;.org	0x8f2c
ACOUT_DeltaAboveMinThrottleToCutOutAc:
    ;mpgrp Utility\AC_Control\
    ;mptbladdr 0x1782
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaAboveMinThrottleToCutOutAc
    ;mptblcname ACOUT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x8A                       ;Point 1

	;.org	0x8f2d
ACCRPM_DoNotAllowAcToEngageAboveThisRPM_4000:
    ;mpgrp Utility\AC_Control\
    ;mptbladdr 0x178F
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DoNotAllowAcToEngageAboveThisRPM_4000
    ;mptblcname ACCRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x7D00                     ;Point 1

	;.org	0x8f2f
ACCTIM_AcDelayFromStartRunTransfer:
    ;mpgrp Utility\AC_Control\
    ;mptbladdr 0x179C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcDelayFromStartRunTransfer
    ;mptblcname ACCTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1

	;.org	0x8f30
ACCNTI_ACCounterInitial:
    ;mpgrp Utility\AC_Control\
    ;mptbladdr 0x17A9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ACCounterInitial
    ;mptblcname ACCNTI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x06                       ;Point 1

	;.org	0x8f31
WOTDLT_DeltaThrottleFrom_MINTHR_ToDetermineFullThrottle:
    ;mpgrp Setup\Thorttle_Calibration\
    ;mptbladdr 0x17B6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaThrottleFrom_MINTHR_ToDetermineFullThrottle
    ;mptblcname WOTDLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x3D                       ;Point 1

	;.org	0x8f32
UNLOAD_DeltaThrottleFrom_MINTHR_ToUnloadCrankingFuel:
    ;mpgrp Setup\Thorttle_Calibration\
    ;mptbladdr 0x17C3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaThrottleFrom_MINTHR_ToUnloadCrankingFuel
    ;mptblcname UNLOAD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x85                       ;Point 1

	;.org	0x8f33
VACREG_CruiseControlVacRegularGainGurve_FromDeltaSpeed:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x17D0
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlVacRegularGainGurve_FromDeltaSpeed
    ;mptblcname VACREG
    ;mpxaxis Delta_Speed 0 127 mph
    ;mpyaxis AccRate 0 5 mph/sec
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Number of points in table
    .byte 0x00, 0x01, 0x00, 0x20     ;Point 1
    .byte 0x08, 0x02, 0x00, 0x0E     ;Point 2
    .byte 0x40, 0x05, 0x00, 0x18     ;Point 3
    .byte 0x80, 0x0B, 0x00, 0x58     ;Point 4
    .byte 0xC0, 0x21                 ;Point 5

	;.org	0x8f4a
VACACC_CruiseControlVacAcceleratedGainCurve_FromDeltaSpeed:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x17E2
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlVacAcceleratedGainCurve_FromDeltaSpeed
    ;mptblcname VACACC
    ;mpxaxis Delta_Speed 0 127 mph
    ;mpyaxis AccRate 0 5 mph/sec
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x00, 0x00, 0x80     ;Point 1
    .byte 0x40, 0x20, 0x00, 0x15     ;Point 2
    .byte 0xFF, 0x30                 ;Point 3

	;.org	0x8f59
VENTRG_CruiseControlVentRegularGainCurve_FromDeltaSpeed:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x17F2
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlVentRegularGainCurve_FromDeltaSpeed
    ;mptblcname VENTRG
    ;mpxaxis Delta_Speed 0 127 mph
    ;mpyaxis AccRate 0 5 mph/sec
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x01, 0xFF, 0xFB     ;Point 1
    .byte 0x33, 0x00, 0xFF, 0xEE     ;Point 2
    .byte 0xFF, 0xF2                 ;Point 3

	;.org	0x8f68
CRUZ1_UknownTableForCruiseControl1:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1802
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname UknownTableForCruiseControl1
    ;mptblcname CRUZ1
    ;mpxaxis in 0 255 in
    ;mpyaxis out 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0xFE, 0xFF, 0x88     ;Point 1
    .byte 0x40, 0xE0, 0xFF, 0xEA     ;Point 2
    .byte 0xFD, 0xD0                 ;Point 3

	;.org	0x8f77
CRUZ2_UknownTableForCruiseControl2:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1812
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname UknownTableForCruiseControl2
    ;mptblcname CRUZ2
    ;mpxaxis in 0 255 in
    ;mpyaxis out 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x98, 0x01, 0x00, 0x30     ;Point 1
    .byte 0xCD, 0x0B                 ;Point 2

	;.org	0x8f82
CRUZ3_UknownTableForCruiseControl3:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1821
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname UknownTableForCruiseControl3
    ;mptblcname CRUZ3
    ;mpxaxis in 0 255 in
    ;mpyaxis out 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x70, 0xC0, 0xF8, 0x00     ;Point 1
    .byte 0x78, 0x80, 0x05, 0x4B     ;Point 2
    .byte 0x90, 0xFF                 ;Point 3

	;.org	0x8f8d
CRUZ4_UknownTableForCruiseControl4:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1831
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname UknownTableForCruiseControl4
    ;mptblcname CRUZ4
    ;mpxaxis in 0 255 in
    ;mpyaxis out 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x33, 0x08, 0xFF, 0xDE     ;Point 1
    .byte 0x68, 0x01                 ;Point 2

	;.org	0x8f98
CRUZ5_UknownTableForCruiseControl5:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1840
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname UknownTableForCruiseControl5
    ;mptblcname CRUZ5
    ;mpxaxis in 0 255 in
    ;mpyaxis out 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x68, 0xFF, 0xFC, 0x08     ;Point 1
    .byte 0x88, 0x80                 ;Point 2
    
	;.org	0x8fa3
SETPW_CruiseControlSetupPulseForSet_FromSpeed:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x184F
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlSetupPulseForSet_FromSpeed
    ;mptblcname SETPW
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis Vacuum 0 2.8 Pulsewidth
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Number of points in table
    .byte 0x46, 0x29, 0x00, 0x11     ;Point 1
    .byte 0x64, 0x2B, 0x00, 0x22     ;Point 2
    .byte 0x82, 0x2F, 0x00, 0x2C     ;Point 3
    .byte 0xC8, 0x3B                 ;Point 4
    
	;.org	0x8fb2
RESTBL_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1860
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference
    ;mptblcname RESTBL
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis Vacuum -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x06                       ;Number of points in table
    .byte 0x1A, 0x77, 0x00, 0x28     ;Point 1
    .byte 0x53, 0x80, 0x00, 0x6E     ;Point 2
    .byte 0x6F, 0x8C, 0x00, 0xEB     ;Point 3
    .byte 0x87, 0xA2, 0x00, 0x00     ;Point 4
    .byte 0x9A, 0xA2, 0xFD, 0x40     ;Point 5
    .byte 0xA2, 0x8C                 ;Point 6

	;.org	0x8fc9
RESTBL2_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference2:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1874
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference2
    ;mptblcname RESTBL2
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis Vacuum 0 2.8 Pulsewidth
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Number of points in table
    .byte 0x70, 0x77, 0x00, 0x90     ;Point 1
    .byte 0x80, 0x80, 0x00, 0x2B     ;Point 2
    .byte 0xBC, 0x8A, 0x00, 0x33     ;Point 3
    .byte 0xEE, 0x94                 ;Point 4

	;.org	0x8fe8
THGAIN_CruiseControlThrottleGainFactor_FromThrottle:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1885
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlThrottleGainFactor_FromThrottle
    ;mptblcname THGAIN
    ;mpxaxis TPS 0 255 tps
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x01, 0x08, 0x06, 0x00     ;Point 1
    .byte 0x03, 0x14                 ;Point 2

	;.org	0x8ff3
SPGAIN_CruiseControlSpeedGainFactor_FromSpeed:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1894
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlSpeedGainFactor_FromSpeed
    ;mptblcname SPGAIN
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x3C, 0x16, 0xFF, 0xEA     ;Point 1
    .byte 0x82, 0x10                 ;Point 2

	;.org	0x8ffe
CRUZ6_UknownTableForCruiseControl6:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x18A3
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname UknownTableForCruiseControl6
    ;mptblcname CRUZ6
    ;mpxaxis in 0 255 in
    ;mpyaxis out 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x00, 0x06, 0x00, 0x33     ;Point 1
    .byte 0x05, 0x07                 ;Point 2


	;.org	0x9009
CRUZ7_UknownTableForCruiseControl7:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x18B3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownTableForCruiseControl7
    ;mptblcname CRUZ7
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x900a
VNTAB1_CruiseControlLimitToAMaxVent:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x18C0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlLimitToAMaxVent
    ;mptblcname VNTAB1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x90                       ;Point 1

	;.org	0x900b
VNTAB2_CruiseControlLimitToHalfMaxVent:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x18CD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlLimitToHalfMaxVent
    ;mptblcname VNTAB2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x60                       ;Point 1

	;.org	0x900c
CRUZ46_UknownConstForCruiseControl46:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x18DA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl46
    ;mptblcname CRUZ46
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x900d
CRUZ47_UknownConstForCruiseControl47:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x18E7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl47
    ;mptblcname CRUZ47
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x2F                       ;Point 1

	;.org	0x900e
ACLRST_CruiseControlDeltaSpeedToResetAccFlag:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x18F4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlDeltaSpeedToResetAccFlag
    ;mptblcname ACLRST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaSpeed 0 127 mph
    ;mptbldesc Detailed_Description
    .byte 0x09                       ;Point 1

	;.org	0x900f
CLOTHR_CruiseControlDontVentIfThrottleBelowThis:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1901
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlDontVentIfThrottleBelowThis
    ;mptblcname CLOTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x9010
MAXTHR_CruiseControlDontVacIfThrottleAboveThis:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x190E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlDontVacIfThrottleAboveThis
    ;mptblcname MAXTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x66                       ;Point 1

	;.org	0x9011
MAXSET_CruiseControlMaxSetSpeedTimesTwo:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x191B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlMaxSetSpeedTimesTwo
    ;mptblcname MAXSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 127.5 MPH
    ;mptbldesc Detailed_Description
    .byte 0xAA                       ;Point 1

	;.org	0x9012
MINSET_CruiseControlMinSetSpeedTimesTwo:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1928
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlMinSetSpeedTimesTwo
    ;mptblcname MINSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 127.5 MPH
    ;mptbldesc Detailed_Description
    .byte 0x46                       ;Point 1

	;.org	0x9013
SCNVHI_CruiseControlForBrakeFlagManualTransmissionClutchDisableHi:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1935
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlForBrakeFlagManualTransmissionClutchDisableHi
    ;mptblcname SCNVHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x9014
SCNVLO_CruiseControlForBrakeFlagManualTransmissionClutchDisableLo:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1942
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlForBrakeFlagManualTransmissionClutchDisableLo
    ;mptblcname SCNVLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x52                       ;Point 1

	;.org	0x9015
CRUZ21_UknownConstForCruiseControl21:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x194F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl21
    ;mptblcname CRUZ21
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x3C                       ;Point 1

	;.org	0x9016
CRUZ22_UknownConstForCruiseControl22:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x195C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl22
    ;mptblcname CRUZ22
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xBC                       ;Point 1

	;.org	0x9017
CRUZ23_UknownConstForCruiseControl23:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1969
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl23
    ;mptblcname CRUZ23
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Point 1

CRUZ2x_UknownConstForCruiseControl2x:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1975
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl2x
    ;mptblcname CRUZ2X
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1

CRUZ2y_UknownConstForCruiseControl2y:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1981
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl2y
    ;mptblcname CRUZ2Y
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xBA                       ;Point 1

	;.org	0x901a
CRUZ24_UknownConstForCruiseControl24:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x198E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl24
    ;mptblcname CRUZ24
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x901b
CRUZ25_UknownConstForCruiseControl25:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x199B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl25
    ;mptblcname CRUZ25
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x30                       ;Point 1

	;.org	0x901c
CRUZ26_UknownConstForCruiseControl26:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x19A8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl26
    ;mptblcname CRUZ26
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

	;.org	0x901d
CRUZ27_UknownConstForCruiseControl27:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x19B5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl27
    ;mptblcname CRUZ27
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x901e
CRUZ28_UknownConstForCruiseControl28:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x19C2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl28
    ;mptblcname CRUZ28
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x901f
CRUZ29_UknownConstForCruiseControl29:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x19CF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl29
    ;mptblcname CRUZ29
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x9020
CRUZ30_UknownConstForCruiseControl30:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x19DC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl30
    ;mptblcname CRUZ30
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x9021
CRUZ31_UknownConstForCruiseControl31:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x19E9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl31
    ;mptblcname CRUZ31
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x34                       ;Point 1

	;.org	0x9022
CRUZ32_UknownConstForCruiseControl32:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x19F6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl32
    ;mptblcname CRUZ32
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x08                       ;Point 1

	;.org	0x9023
CRUZ33_UknownConstForCruiseControl33:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1A03
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl33
    ;mptblcname CRUZ33
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x9024
CRUZ34_UknownConstForCruiseControl34:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1A10
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl34
    ;mptblcname CRUZ34
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x20                       ;Point 1

	;.org	0x9025
CRUZ35_UknownConstForCruiseControl35:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1A1D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl35
    ;mptblcname CRUZ35
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0C                       ;Point 1

	;.org	0x9026
CRUZ36_UknownConstForCruiseControl36:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1A2A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl36
    ;mptblcname CRUZ36
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x8C                       ;Point 1

	;.org	0x9027
SETDLT_CruiseControlSetDeltaControlPointForCableAdaptive:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1A37
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlSetDeltaControlPointForCableAdaptive
    ;mptblcname SETDLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x9028
CRSCN2_CruiseComapreConstant2:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1A44
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseComapreConstant2
    ;mptblcname CRSCN2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x06                       ;Point 1

	;.org	0x9029
CRMSK2_CruiseMask2:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1A51
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask2
    ;mptblcname CRMSK2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x07                       ;Point 1

	;.org	0x902a
CRMSK3_CruiseMask3:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1A5E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask3
    ;mptblcname CRMSK3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xF6                       ;Point 1

	;.org	0x902b
CRMSK7_CruiseMask7:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1A6B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask7
    ;mptblcname CRMSK7
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x902c
CRMSK4_CruiseMask4:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1A78
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask4
    ;mptblcname CRMSK4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

	;.org	0x902d
CRMSK6_CruiseMask6:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1A85
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask6
    ;mptblcname CRMSK6
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x1F                       ;Point 1

	;.org	0x902e
CRMSK5_CruiseMask5:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1A92
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask5
    ;mptblcname CRMSK5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xE1                       ;Point 1

	;.org	0x902f
CRSCN1_CruiseComapreConstant1:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1A9F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseComapreConstant1
    ;mptblcname CRSCN1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x16                       ;Point 1

	;.org	0x9030
CRMASK_CruiseMask:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0x1AAC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask
    ;mptblcname CRMASK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x11                       ;Point 1

	;.org	0x9031
MININC_Amount_MINTHR_IsIncreasedAtKeyOnOnly:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0x1AB9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Amount_MINTHR_IsIncreasedAtKeyOnOnly
    ;mptblcname MININC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Point 1

	;.org	0x9032
MAPTHR_ThrottleSelfCalibrationMapDeltaThreshold:
    ;mpgrp Setup\Thorttle_Calibration\
    ;mptbladdr 0x1AC6
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname ThrottleSelfCalibrationMapDeltaThreshold
    ;mptblcname MAPTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x31                       ;Point 1

	;.org	0x9033
RPMTHR_ThrottleSelfCalibrationRpmThreshold:
    ;mpgrp Setup\Thorttle_Calibration\
    ;mptbladdr 0x1AD4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleSelfCalibrationRpmThreshold
    ;mptblcname RPMTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x30                       ;Point 1

	;.org	0x9034
MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected:
    ;mpgrp Setup\Thorttle_Calibration\
    ;mptbladdr 0x1AE1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ValueOf_MINTHR_WhenBatteryDisconnected
    ;mptblcname MTHRMX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x5C                       ;Point 1

	;.org	0x9035
MAXCNT_ProgramLoopsWithThrottleBelow_MINTHR_ToDecrement_MINTHR:
    ;mpgrp Setup\Thorttle_Calibration\
    ;mptbladdr 0x1AEE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ProgramLoopsWithThrottleBelow_MINTHR_ToDecrement_MINTHR
    ;mptblcname MAXCNT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1

	;.org	0x9036
MTHRCL_NumberOfBitsAbove_MINTHR_ToDetermineOnThrottleTransition:
    ;mpgrp Setup\Thorttle_Calibration\
    ;mptbladdr 0x1AFB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NumberOfBitsAbove_MINTHR_ToDetermineOnThrottleTransition
    ;mptblcname MTHRCL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

	;.org	0x9037
MTHROP_NumberOfBitsAbove_MINTHR_ToDetermineOffThrottleTransition:
    ;mpgrp Setup\Thorttle_Calibration\
    ;mptbladdr 0x1B08
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NumberOfBitsAbove_MINTHR_ToDetermineOffThrottleTransition
    ;mptblcname MTHROP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x9038
LMPINN_LimpinTableForMapFromThrottle:
    ;mpgrp Utility\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0x1B15
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname LimpinTableForMapFromThrottle
    ;mptblcname LMPINN
    ;mpxaxis TPS 0 255 tps
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x05                       ;Number of points in table
    .byte 0x00, 0x00, 0x02, 0x50     ;Point 1
    .byte 0x10, 0x25, 0x01, 0xDB     ;Point 2
    .byte 0x17, 0x32, 0x01, 0x5D     ;Point 3
    .byte 0x22, 0x41, 0x00, 0xF9     ;Point 4
    .byte 0x45, 0x63                 ;Point 5

	;.org	0x904f
MPLMOF_OffsetForCalcMapInMapLimpin:
    ;mpgrp Utility\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0x1B28
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OffsetForCalcMapInMapLimpin
    ;mptblcname MPLMOF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x20                       ;Point 1

	;.org	0x9050
THROFF_OffsetAddedToCalcThrottle:
    ;mpgrp Utility\On-Board_Diagnostics\
    ;mptbladdr 0x1B36
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OffsetAddedToCalcThrottle
    ;mptblcname THROFF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0B                       ;Point 1

	;.org	0x9051
OFSMID_OffsetForMAPOverIdle:
    ;mpgrp Utility\On-Board_Diagnostics\
    ;mptbladdr 0x1B43
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OffsetForMAPOverIdle
    ;mptblcname OFSMID
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0xFE                       ;Point 1

	;.org	0x9052
INCMID_IncrementForMAPOverIdle:
    ;mpgrp Utility\On-Board_Diagnostics\
    ;mptbladdr 0x1B51
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname IncrementForMAPOverIdle
    ;mptblcname INCMID
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

	;.org	0x9053
OFSRID_OffsetForRPMOverIdle:
    ;mpgrp Utility\On-Board_Diagnostics\
    ;mptbladdr 0x1B5E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OffsetForRPMOverIdle
    ;mptblcname OFSRID
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xD0                       ;Point 1

	;.org	0x9054
INCRID_IncrementForRPMOverIdle:
    ;mpgrp Utility\On-Board_Diagnostics\
    ;mptbladdr 0x1B6B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname IncrementForRPMOverIdle
    ;mptblcname INCRID
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x9055
MNRPO2_MinimumRPMOverIdleForO2Feedback:
    ;mpgrp Utility\On-Board_Diagnostics\
    ;mptbladdr 0x1B78
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumRPMOverIdleForO2Feedback
    ;mptblcname MNRPO2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xD0                       ;Point 1

	;.org	0x9056
CTLMC1_CylinderTrimCounter1LimitFromCoolantTemp:
    ;mpgrp Fuel\O2_Feedback_Control\Individual_Cylinder_Trim\
    ;mptbladdr 0x1B85
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CylinderTrimCounter1LimitFromCoolantTemp
    ;mptblcname CTLMC1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x7F                 ;Point 1

	;.org	0x905d
CTLMC2_CylinderTrimCounter2LimitFromCoolantTemp:
    ;mpgrp Fuel\O2_Feedback_Control\Individual_Cylinder_Trim\
    ;mptbladdr 0x1B93
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CylinderTrimCounter2LimitFromCoolantTemp
    ;mptblcname CTLMC2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x7F                 ;Point 1

	;.org	0x9064
DFBFMD_DefaultBaseFuelModifierFromRPMOverIdle:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0x1BA1
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DefaultBaseFuelModifierFromRPMOverIdle
    ;mptblcname DFBFMD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0x906b
TMPLOW_OutOfRangeHotTooLowA2D:
    ;mpgrp Utility\On-Board_Diagnostics\Coolant_Temp_Sensor\
    ;mptbladdr 0x1BAF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OutOfRangeHotTooLowA2D
    ;mptblcname TMPLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x1A                       ;Point 1

	;.org	0x906c
TMPHIG_OutOfRangeColdTooHighA2D:
    ;mpgrp Utility\On-Board_Diagnostics\Coolant_Temp_Sensor\
    ;mptbladdr 0x1BBC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OutOfRangeColdTooHighA2D
    ;mptblcname TMPHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFD                       ;Point 1

	;.org	0x906d
DEFTMP_DefaultEngineTemp:
    ;mpgrp Utility\On-Board_Diagnostics\Coolant_Temp_Sensor\
    ;mptbladdr 0x1BC9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DefaultEngineTemp
    ;mptblcname DEFTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xB2                       ;Point 1

	;.org	0x906e
BTLRPM_LowBatteryVoltageAtThisRpm1500:
    ;mpgrp Utility\On-Board_Diagnostics\Battery_Volts\
    ;mptbladdr 0x1BD6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowBatteryVoltageAtThisRpm1500
    ;mptblcname BTLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x2E                       ;Point 1

	;.org	0x906f
CTLRPM_LowBatteryVoltageAtThisCoolantTemp:
    ;mpgrp Utility\On-Board_Diagnostics\Battery_Volts\
    ;mptbladdr 0x1BE3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowBatteryVoltageAtThisCoolantTemp
    ;mptblcname CTLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xCD                       ;Point 1

BTLRPM2_LowBatteryVoltageAtThisRpm1500:
    ;mpgrp Utility\On-Board_Diagnostics\Battery_Volts\
    ;mptbladdr 0x1BEF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowBatteryVoltageAtThisRpm1500_2
    ;mptblcname BTLRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x2E                       ;Point 1

AMBLOW_BattTempLowWhenHot:
    ;mpgrp Utility\On-Board_Diagnostics\Battery_Temp_Sensor\
    ;mptbladdr 0x1BFB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BattTempLowWhenHot
    ;mptblcname AMBLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Point 1

AMBHIG_BattTempHighWhenCold:
    ;mpgrp Utility\On-Board_Diagnostics\Battery_Temp_Sensor\
    ;mptbladdr 0x1C07
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BattTempHighWhenCold
    ;mptblcname AMBHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFA                       ;Point 1

	;.org	0x9073
CHGLOW_ChargeTempOutOfRangeLow:
    ;mpgrp Utility\On-Board_Diagnostics\Charge_Temp_Sensor\
    ;mptbladdr 0x1C14
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ChargeTempOutOfRangeLow
    ;mptblcname CHGLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x1A                       ;Point 1

	;.org	0x9074
CHGHIG_ChargeTempOutOfRangeHigh:
    ;mpgrp Utility\On-Board_Diagnostics\Charge_Temp_Sensor\
    ;mptbladdr 0x1C21
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ChargeTempOutOfRangeHigh
    ;mptblcname CHGHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFD                       ;Point 1

	;.org	0x9075
DEFCHG_DefaultChargeTemp_Limpin:
    ;mpgrp Utility\On-Board_Diagnostics\Charge_Temp_Sensor\
    ;mptbladdr 0x1C2E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DefaultChargeTemp_Limpin
    ;mptblcname DEFCHG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x95                       ;Point 1

	;.org	0x9076
ERRRPM_RPMLimitforErrorCodeSetting:
    ;mpgrp Utility\On-Board_Diagnostics\Error_Codes\
    ;mptbladdr 0x1C3B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimitforErrorCodeSetting
    ;mptblcname ERRRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x38                       ;Point 1

	;.org	0x9077
ERRMAP_MAPLimitforErrorCodeSetting:
    ;mpgrp Utility\On-Board_Diagnostics\Error_Codes\
    ;mptbladdr 0x1C48
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MAPLimitforErrorCodeSetting
    ;mptblcname ERRMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x2B                       ;Point 1

	;.org	0x9078
ERRTMP_CoolantTempLimitforErrorCodeSetting:
    ;mpgrp Utility\On-Board_Diagnostics\Error_Codes\
    ;mptbladdr 0x1C56
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CoolantTempLimitforErrorCodeSetting
    ;mptblcname ERRTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xA0                       ;Point 1

	;.org	0x9079
THRLOW_ThrottleLowerLimit:
    ;mpgrp Utility\On-Board_Diagnostics\TPS_Sensor\
    ;mptbladdr 0x1C63
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleLowerLimit
    ;mptblcname THRLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x08                       ;Point 1

	;.org	0x907a
THRHIG_ThrottleUpperLimit:
    ;mpgrp Utility\On-Board_Diagnostics\TPS_Sensor\
    ;mptbladdr 0x1C70
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleUpperLimit
    ;mptblcname THRHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xE4                       ;Point 1

	;.org	0x907b
MPTHR_MapSwitchPointForFullThrottleOrIdle:
    ;mpgrp Setup\Transfer_Functions\
    ;mptbladdr 0x1C7D
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MapSwitchPointForFullThrottleOrIdle
    ;mptblcname MPTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x68                       ;Point 1

	;.org	0x907c
COILLO_LoLimitBatteryVoltsForCoilVerify:
    ;mpgrp Utility\On-Board_Diagnostics\Ignition_Coil\
    ;mptbladdr 0x1C8B
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname LoLimitBatteryVoltsForCoilVerify
    ;mptblcname COILLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x05                       ;Point 1

	;.org	0x907d
COILHI_HiLimitBatteryVoltsForCoilVerify:
    ;mpgrp Utility\On-Board_Diagnostics\Ignition_Coil\
    ;mptbladdr 0x1C99
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HiLimitBatteryVoltsForCoilVerify
    ;mptblcname COILHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xBA                       ;Point 1

	;.org	0x907e
MAPLOW_MapSensorLowerLimit:
    ;mpgrp Utility\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0x1CA6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapSensorLowerLimit
    ;mptblcname MAPLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x907f
MAPHIG_MapSensorUpperLimit:
    ;mpgrp Utility\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0x1CB3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapSensorUpperLimit
    ;mptblcname MAPHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xEE                       ;Point 1

	;.org	0x9080
MPLTHR_ThrottleLevelAbove_MINTHR_ToMatureMapLimpin:
    ;mpgrp Utility\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0x1CC0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleLevelAbove_MINTHR_ToMatureMapLimpin
    ;mptblcname MPLTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x42                       ;Point 1

	;.org	0x9081
MPDELT_DeltaMapThatChecksGood:
    ;mpgrp Utility\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0x1CCD
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapThatChecksGood
    ;mptblcname MPDELT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

	;.org	0x9082
MPDELA_MatureMapLimpinWhenDeltaAbove_MPDELT_plus_MPDELA:
    ;mpgrp Utility\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0x1CDB
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MatureMapLimpinWhenDeltaAbove_MPDELT_plus_MPDELA
    ;mptblcname MPDELA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

	;.org	0x9083
MPRPML_DisableMapCheckUnderThisRpm_600:
    ;mpgrp Utility\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0x1CE9
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DisableMapCheckUnderThisRpm_600
    ;mptblcname MPRPML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x12C0                     ;Point 1

	;.org	0x9085
MPRPMH_DisableMapCheckAboveThisRpm_1500:
    ;mpgrp Utility\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0x1CF6
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DisableMapCheckAboveThisRpm_1500
    ;mptblcname MPRPMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x2EE0                     ;Point 1

	;.org	0x9087
MPDAGL_DisableMapCheckBelowThisMap:
    ;mpgrp Utility\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0x1D03
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DisableMapCheckBelowThisMap
    ;mptblcname MPDAGL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x10                       ;Point 1

	;.org	0x9088
MPDAGH_DisableMapCheckAboveThisMap:
    ;mpgrp Utility\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0x1D11
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DisableMapCheckAboveThisMap
    ;mptblcname MPDAGH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x81                       ;Point 1

	;.org	0x9089
MPRMPD_CheckMapAtZeroSpeedAndThisDeltaRpm:
    ;mpgrp Utility\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0x1D1F
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname CheckMapAtZeroSpeedAndThisDeltaRpm
    ;mptblcname MPRMPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0200                     ;Point 1

	;.org	0x908b
BAROSW_CheckMapAtZeroSpeedAndThisBaroSwitch:
    ;mpgrp Utility\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0x1D2C
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname CheckMapAtZeroSpeedAndThisBaroSwitch
    ;mptblcname BAROSW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x62                       ;Point 1

	;.org	0x908c
MPVACD_AllowMapToTestGoodThisNearBaro:
    ;mpgrp Utility\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0x1D3A
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AllowMapToTestGoodThisNearBaro
    ;mptblcname MPVACD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x11                       ;Point 1

MPVAC2_AllowMapToTestGoodThisNearBaro2:
    ;mpgrp Utility\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0x1D47
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AllowMapToTestGoodThisNearBaro2
    ;mptblcname MPVAC2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x08                       ;Point 1

	;.org	0x908e
MPDELX_DeltaMapThatChecksGoodX:
    ;mpgrp Utility\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0x1D55
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaMapThatChecksGoodX
    ;mptblcname MPDELX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

UknownByteA:
    ;mpgrp Utility\On-Board_Diagnostics\
    ;mptbladdr 0x1D61
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownBytesA
    ;mptblcname UKNOWNBYTESA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Point 1

UknownByteB:
    ;mpgrp Utility\On-Board_Diagnostics\
    ;mptbladdr 0x1D6D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownBytesB
    ;mptblcname UKNOWNBYTESB
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xA8                       ;Point 1

	;.org	0x9091
IPWRDX_InjectorPulsewidthReductionColdStart:
    ;mpgrp Fuel\Starting\
    ;mptbladdr 0x1D7A
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname InjectorPulsewidthReductionColdStart
    ;mptblcname IPWRDX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    ;mpinjscale word
    .word 0x0000                     ;Point 1

FLMNC2_FuelMonitorCorrection2:
    ;mpgrp Utility\On-Board_Diagnostics\Fuel_Monitor\
    ;mptbladdr 0x1D87
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FuelMonitorCorrection2
    ;mptblcname FLMNC2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    ;mpinjscale invert
    .byte 0x80                       ;Point 1

	;.org	0x9093
TTEMPL_TstatDiagnosticsMinTempToArmDiagnosticsAtStartup:
    ;mpgrp Utility\On-Board_Diagnostics\T-Stat_Diagnostics\
    ;mptbladdr 0x1D95
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsMinTempToArmDiagnosticsAtStartup
    ;mptblcname TTEMPL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc Detailed_Description
    .byte 0x63                       ;Point 1

	;.org	0x9094
TTEMPH_TstatDiagnosticsMaxTempToArmDiagnosticsAtStartup:
    ;mpgrp Utility\On-Board_Diagnostics\T-Stat_Diagnostics\
    ;mptbladdr 0x1DA2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsMaxTempToArmDiagnosticsAtStartup
    ;mptblcname TTEMPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc Detailed_Description
    .byte 0xE4                       ;Point 1

	;.org	0x9095
TDAGTP_TstatDiagnosticsTemperatureGoalWithin_HOTIME:
    ;mpgrp Utility\On-Board_Diagnostics\T-Stat_Diagnostics\
    ;mptbladdr 0x1DAF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsTemperatureGoalWithin_HOTIME
    ;mptblcname TDAGTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc Detailed_Description
    .byte 0xC7                       ;Point 1

	;.org	0x9096
HOTIME_TstatDiagnosticsTimeToAchieveTemperatureGoal:
    ;mpgrp Utility\On-Board_Diagnostics\T-Stat_Diagnostics\
    ;mptbladdr 0x1DBC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsTimeToAchieveTemperatureGoal
    ;mptblcname HOTIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xAE                       ;Point 1

	;.org	0x9097
BTVHYS_BatteryVoltsHysteresisForAlternatorControl:
    ;mpgrp Utility\On-Board_Diagnostics\Alternator_Diagnostics\
    ;mptbladdr 0x1DC9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BatteryVoltsHysteresisForAlternatorControl
    ;mptblcname BTVHYS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1

	;.org	0x9098
BTVLMT_BatteryVoltsDiagLimitOverTarget:
    ;mpgrp Utility\On-Board_Diagnostics\Alternator_Diagnostics\
    ;mptbladdr 0x1DD6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BatteryVoltsDiagLimitOverTarget
    ;mptblcname BTVLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1

	;.org	0x9099
BTVCNT_BatteryVoltsDiagCounterMax:
    ;mpgrp Utility\On-Board_Diagnostics\Alternator_Diagnostics\
    ;mptbladdr 0x1DE3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BatteryVoltsDiagCounterMax
    ;mptblcname BTVCNT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x8E                       ;Point 1

	;.org	0x909a
BTVCN3_BatteryVoltsDiagCounterMin:
    ;mpgrp Utility\On-Board_Diagnostics\Alternator_Diagnostics\
    ;mptbladdr 0x1DF0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BatteryVoltsDiagCounterMin
    ;mptblcname BTVCN3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x06                       ;Point 1

	;.org	0x909b
BTVCN2_BatteryVoltsDiagCounterMax2:
    ;mpgrp Utility\On-Board_Diagnostics\Alternator_Diagnostics\
    ;mptbladdr 0x1DFD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BatteryVoltsDiagCounterMax2
    ;mptblcname BTVCN2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x7F                       ;Point 1

	;.org	0x909c
O2DIAG_CounterLimitForO2SensorDiag:
    ;mpgrp Utility\On-Board_Diagnostics\O2_Sensor_Diagnostics\
    ;mptbladdr 0x1E0A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CounterLimitForO2SensorDiag
    ;mptblcname O2DIAG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x13                       ;Point 1

	;.org	0x909d
O2MID_LimitForO2SensorBatteryDiag:
    ;mpgrp Utility\On-Board_Diagnostics\O2_Sensor_Diagnostics\
    ;mptbladdr 0x1E17
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LimitForO2SensorBatteryDiag
    ;mptblcname O2MID
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x4D                       ;Point 1

	;.org	0x909e
O2MIDX_HighLimitForInMiddleDeterminationX:
    ;mpgrp Utility\On-Board_Diagnostics\O2_Sensor_Diagnostics\
    ;mptbladdr 0x1E24
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForInMiddleDeterminationX
    ;mptblcname O2MIDX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x3E                       ;Point 1

	;.org	0x909f
DCLMER_MinTimeEngineRunningForDecelFuelShutoff:
    ;mpgrp Fuel\Decel_Fuel_Shutoff\
    ;mptbladdr 0x1E31
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinTimeEngineRunningForDecelFuelShutoff
    ;mptblcname DCLMER
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

	;.org	0x90a0
DCLMCT_MinCoolantTempForDecelFuelShutoff:
    ;mpgrp Fuel\Decel_Fuel_Shutoff\
    ;mptbladdr 0x1E3E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinCoolantTempForDecelFuelShutoff
    ;mptblcname DCLMCT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xD2                       ;Point 1

	;.org	0x90a1
DCLRPH_EngineRPMLimitForDecelFuelShutoffHigh:
    ;mpgrp Fuel\Decel_Fuel_Shutoff\
    ;mptbladdr 0x1E4B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineRPMLimitForDecelFuelShutoffHigh
    ;mptblcname DCLRPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc High_RPM_to_activate_decel_fuel_shutoff._Should_be_lower_than_shutoff_RPM_Off_point.
    .byte 0x11                       ;Point 1

	;.org	0x90a2
DCLRPL_EngineRPMLimitForDecelFuelShutoffLow:
    ;mpgrp Fuel\Decel_Fuel_Shutoff\
    ;mptbladdr 0x1E58
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineRPMLimitForDecelFuelShutoffLow
    ;mptblcname DCLRPL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Low_RPM_to_activate_decel_fuel_shutoff._Should_be_lower_than_shutoff_RPM_On_point.
    .byte 0x0F                       ;Point 1

	;.org	0x90a3
DCAISI_AISIncrementWhenUsingDecelFuelShut:
    ;mpgrp Fuel\Decel_Fuel_Shutoff\
    ;mptbladdr 0x1E65
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AISIncrementWhenUsingDecelFuelShut
    ;mptblcname DCAISI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc AIS_Increment_for_recovery_from_decel_fuel_shutoff.
    .byte 0x00                       ;Point 1

	;.org	0x90a4
DFRPMH_DecelFuelShutoffDeltaRPMOff:
    ;mpgrp Fuel\Decel_Fuel_Shutoff\
    ;mptbladdr 0x1E72
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DecelFuelShutoffDeltaRPMOff
    ;mptblcname DFRPMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPMOverIdle 0 8160 rpm
    ;mptbldesc Decel_fuel_shutoff_RPM_over_Idle_off_point.
    .byte 0x1E                       ;Point 1

	;.org	0x90a5
DFRPML_DecelFuelShutoffDeltaRPMOn:
    ;mpgrp Fuel\Decel_Fuel_Shutoff\
    ;mptbladdr 0x1E7F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DecelFuelShutoffDeltaRPMOn
    ;mptblcname DFRPML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPMOverIdle 0 8160 rpm
    ;mptbldesc Decel_fuel_shutoff_RPM_over_Idle_on_point.
    .byte 0x11                       ;Point 1

	;.org	0x90a6
FastDataOutputCommandByte:
    ;mpgrp Setup\DRB_Datalogging\
    ;mptbladdr 0x1E8C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FastDataOutputCommandByte
    ;mptblcname FASTDT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1

	;.org	0x90a7
FastDataOutputAddressTable:
    ;mpgrp Setup\DRB_Datalogging\
    ;mptbladdr 0x1E99
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname FastDataOutputAddressTable
    ;mptblcname FASTDA
    ;mpxaxis in_desc 72 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x64                       ;Point 1
    .byte 0x9B                       ;Point 2
    .byte 0x64                       ;Point 3
    .byte 0x9C                       ;Point 4
    .byte 0x64                       ;Point 5
    .byte 0x91                       ;Point 6
    .byte 0x64                       ;Point 7
    .byte 0x92                       ;Point 8
    .byte 0x64                       ;Point 9
    .byte 0x9E                       ;Point 10
    .byte 0x64                       ;Point 11
    .byte 0x9F                       ;Point 12
    .byte 0x64                       ;Point 13
    .byte 0x88                       ;Point 14
    .byte 0x64                       ;Point 15
    .byte 0x98                       ;Point 16
    .byte 0x64                       ;Point 17
    .byte 0x99                       ;Point 18
    .byte 0x64                       ;Point 19
    .byte 0x81                       ;Point 20
    .byte 0x64                       ;Point 21
    .byte 0x82                       ;Point 22
    .byte 0x64                       ;Point 23
    .byte 0x83                       ;Point 24
    .byte 0x64                       ;Point 25
    .byte 0x84                       ;Point 26
    .byte 0x64                       ;Point 27
    .byte 0x85                       ;Point 28
    .byte 0x64                       ;Point 29
    .byte 0x86                       ;Point 30
    .byte 0x01                       ;Point 31
    .byte 0x04                       ;Point 32
    .byte 0x67                       ;Point 33
    .byte 0x22                       ;Point 34
    .byte 0x82                       ;Point 35
    .byte 0x00                       ;Point 36
    .byte 0x00                       ;Point 37
    .byte 0x00                       ;Point 38
    .byte 0x00                       ;Point 39
    .byte 0x00                       ;Point 40
    .byte 0x00                       ;Point 41
    .byte 0x00                       ;Point 42
    .byte 0x00                       ;Point 43
    .byte 0x00                       ;Point 44
    .byte 0x00                       ;Point 45
    .byte 0x00                       ;Point 46
    .byte 0x00                       ;Point 47
    .byte 0x00                       ;Point 48
    .byte 0x00                       ;Point 49
    .byte 0x00                       ;Point 50
    .byte 0x00                       ;Point 51
    .byte 0x00                       ;Point 52
    .byte 0x00                       ;Point 53
    .byte 0x00                       ;Point 54
    .byte 0x00                       ;Point 55
    .byte 0x00                       ;Point 56
    .byte 0x00                       ;Point 57
    .byte 0x00                       ;Point 58
    .byte 0x00                       ;Point 59
    .byte 0x00                       ;Point 60
    .byte 0x00                       ;Point 61
    .byte 0x00                       ;Point 62
    .byte 0x00                       ;Point 63
    .byte 0x00                       ;Point 64
    .byte 0x00                       ;Point 65
    .byte 0x00                       ;Point 66
    .byte 0x00                       ;Point 67
    .byte 0x00                       ;Point 68
    .byte 0x00                       ;Point 69
    .byte 0x00                       ;Point 70
    .byte 0x00                       ;Point 71
    .byte 0x08                       ;Point 72

; DWLADB_DwellTime_AdjForBatVolts:
;        chem2 group "Setup - Transfer Functions"
;        .chem 1 n DwellTime_AdjForBatVolts BatVolts 0 16 Volts DwellTime 0 255 uSec DWLADB DwellTime_AdjForBatVolts
;        chem2 table DWLADB simple use "BatVolts" 0 16 "Volts" use "DwellTime" 0 255 "uSec" "DwellTime AdjForBatVolts"
;        .byte   0x82                              ; point 1
;        .word   0xE609,  0x4059
;        .byte   0xAA                              ; point 2
;        .word   0xF017,  0x2908
;        .byte   0xC8                              ; point 3
;        .word   0xF4E6,  0x138C
;        .byte   0xDC                              ; point 4
;        .word   0xF66D,  0x1100
;        .byte   0xF0                              ; point 5
;        .word   0xF7C1,  0x0C55
;        .byte   0xFF

KNKMIN_FlashCEMinTemp:
    ;mpgrp Turbonator_Features\CEL_Knock_Indicator\
    ;mptbladdr 0x1EFC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FlashCEMinTemp
    ;mptblcname KNKMIN
    ;mpxaxis IN 0 255 X
    ;mpyaxis CoolantTemp -200 260 deg
    ;mptbldesc The_min_temp_allowed_before_the_CE_light_is_flashed._To_avoid_false_indication_on_a_cold_engine.
    .byte 0xA8                       ;Point 1

MINAMP_MinimumAverageMAP:
    ;mpgrp Setup\Transfer_Functions\
    ;mptbladdr 0x1F08
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MinimumAverageMAP
    ;mptblcname MINAMP
    ;mpxaxis IN 0 255 X
    ;mpyaxis PSI 0 29.4 psi
    ;mptbldesc Minimum_value_for_the_MAP_averaging_function.
    ;mpmapaxis y
    .byte 0x06                       ;Point 1

MAPMULT_ScaleMAPVoltsToPresMultiplyConst:
    ;mpgrp Setup\Transfer_Functions\
    ;mptbladdr 0x1F15
    ;mptbltype 8
    ;mpsubtype 1
    ;mptbllname ScaleMAPVoltsToPresMultiplyConst
    ;mptblcname MAPMULT
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc Map_Scale_multiplier._This_is_the_slope_constant_for_the_MAP_sensor_transfer_function._#07_is_the_original_Mopar_2-bar_constant._#09_for_the_S60_3-bar_sensor._The_GM_or_MSD_3-Bar_sensors_may_need_these_values_changed_for_accuracy.
    ;mpchoices 1.0_Bar 07 1.5_Bar 07 2.0_Bar 07 2.5_Bar 08 3.0_Bar 09 3.5_Bar 09 4.0_Bar 09 4.5_Bar 09
    ;mpmapaxis b
    .byte 0x07                       ;Point 1

MAPADD_ScaleMAPVoltsToPresAddConst:
    ;mpgrp Setup\Transfer_Functions\
    ;mptbladdr 0x1F23
    ;mptbltype 8
    ;mpsubtype 1
    ;mptbllname ScaleMAPVoltsToPresAddConst
    ;mptblcname MAPADD
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc Scale_MAP_Volts_to_MAP_add_constant:_This_is_the_offset_constant_for_the_MAP_sensor_transfer_function._#0361_is_the_original_Mopar_2-bar_constant._#0700_for_the_S60_3-bar_sensor._The_GM_or_MSD_3-Bar_sensors_may_need_these_values_changed_for_accuracy.
    ;mpchoices 1.0_Bar 0361 1.5_Bar 0361 2.0_Bar 0361 2.5_Bar 0700 3.0_Bar 0700 3.5_Bar 0700 4.0_Bar 0700 4.5_Bar 0700
    ;mpmapaxis w
    .word 0x0361                     ;Point 1

ANTLAG_AntiLagRetardfromBoostGoalDelta:
    ;mpgrp Turbonator_Features\Anti-Lag\
    ;mptbladdr 0x1F31
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AntiLagRetardfromBoostGoalDelta
    ;mptblcname ANTLAG
    ;mpxaxis DeltaMAP 0 29.4 psi
    ;mpyaxis Spark_Retard 0 8 Degrees
    ;mptbldesc Curve_for_retard_based_on_delta_MAP_for_anti-lag_feature._This_will_be_subtracted_from_the_calculated_spark_advance.
    ;mpmapaxis x
    .byte 0x05                       ;Number of points in table
    .byte 0x12, 0x00, 0x02, 0x22     ;Point 1
    .byte 0x30, 0x40, 0x01, 0x11     ;Point 2
    .byte 0x4E, 0x60, 0x00, 0x8E     ;Point 3
    .byte 0x79, 0x78, 0x00, 0x26     ;Point 4
    .byte 0xAE, 0x80                 ;Point 5
       
SLRPM_ShiftLightSetpoint:
    ;mpgrp Turbonator_Features\Shift_Light\
    ;mptbladdr 0x1F43
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ShiftLightSetpoint
    ;mptblcname SLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Shift_light_setpoint.
    .word 0x9B00                     ;Point 1


STGSWS_StagingLimiterEnableSwitch:
    ;mpgrp Turbonator_Features\Staging_Limiter\
    ;mptbladdr 0x1F50
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname StagingLimiterEnableSwitch
    ;mptblcname STGSWS
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc Switch_that_will_activate_the_staging_limiter.
    ;mpchoices B1Voltage_Sense(Do_Not_Use)  Speed_Control_Set_(Momentary)  Speed_Control_On/Off  Speed_Control_Resume_(Momentary)  A/C_Switch  A/C_Clutch_Input(Do_Not_Use)  Brake_Switch  Park/Neutral_Switch
    .byte 0x00                       ;Point 1
    stg_PNswitch		= $%10000000	; Park/Neutral switch
    stg_Brake			= $%01000000	; Brake Switch
    stg_DistSync		= $%00100000	; Distributor Sync
    stg_ACclutch		= $%00010000	; A/C Clutch input
    stg_CruiseResume		= $%00001000	; Cruise Resume
    stg_CruiseOnOff		= $%00000100	; Cruise On/Off
    stg_CruiseSet		= $%00000010	; Cruise Set
    stg_B1Volt			= $%00000001	; B1 Voltage Sense

STGSPD_StageLimiterCutoffSpeed:
    ;mpgrp Turbonator_Features\Staging_Limiter\
    ;mptbladdr 0x1F65
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StageLimiterCutoffSpeed
    ;mptblcname STGSPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 255 mph
    ;mptbldesc Detailed_Description
    .byte 0x0A                       ;Point 1

STGROF_StageLimiterRPMOffSetpoint:
    ;mpgrp Turbonator_Features\Staging_Limiter\
    ;mptbladdr 0x1F71
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StageLimiterRPMOffSetpoint
    ;mptblcname STGROF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x7D                       ;Point 1

STGRON_StageLimiterRPMOnSetpoint:
    ;mpgrp Turbonator_Features\Staging_Limiter\
    ;mptbladdr 0x1F7D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StageLimiterRPMOnSetpoint
    ;mptblcname STGRON
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x77                       ;Point 1
       
WOTBAT_WOTBatteryVoltsTarget:
    ;mpgrp Turbonator_Features\Voltage_Regulator\
    ;mptbladdr 0x1F89
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WOTBatteryVoltsTarget
    ;mptblcname WOTBAT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis BatVolts 0 16.2 V
    ;mptbldesc Battery_volts_target_when_at_WOT.
    .byte 0xEC                       ;Point 1

BSTSWS_HighBoostSwitchSelect:
    ;mpgrp Boost_Control\Target_Lookup\
    ;mptbladdr 0x1F95
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname HighBoostSwitchSelect
    ;mptblcname BSTSWS
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc Switch_that_will_activate_high_boost_mode._If_no_switch_is_selected,_then_theboost_is_not_selectable,_and_the_Low_Boost_curve_needs_to_be_setup_as_the_high_boost_curve.
    ;mpchoices Park/Neutral_Switch  Speed_Control_Resume_(Momentary)  Brake_Switch  Speed_Control_On/Off  Uknown  Speed_Control_Set_(Momentary)  A/C_Clutch_Input(Do_Not_Use)  Uknown
    .byte 0x01                       ;Point 1

LOWBST_AllowedBoostLo:
    ;mpgrp Boost_Control\Target_Lookup\
    ;mptbladdr 0x1FA2
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AllowedBoostLo
    ;mptblcname LOWBST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Low_boost_setting._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x57                       ;Point 1

OPTN1_CalCustomOptionConfigFlags1:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0x1FAF
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname CalCustomOptionConfigFlags1
    ;mptblcname OPTN1
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc These_are_options_available_to_enable_in_this_custom_codebase.
    ;mpchoices Switchable_boost_enable  Boost_switch_polarity  Staging_limiter_Enable  Staging_Limiter_sw_polarity  FlashCE_On_Knock_Enable  Hi-Speed_Logger_Enable  Anti-Lag_Enable  Shift_Light_Enable
    .byte 0x00                       ;Point 1
    opt_ShiftLight		 = $%10000000	 ; Shift light enabled
    opt_AntiLag			 = $%01000000	 ; Use the Anti-Lag retard routine
    opt_HiSpdLog         	 = $%00100000	 ; Use the hi-speed logger interrupt routine
    opt_FlashCE 		 = $%00010000	 ; Flash the CE light when knock is indicated
    opt_StagePol         	 = $%00001000	 ; Staging Limiter switch polarity
    opt_StageLim		 = $%00000100	 ; Staging limiter (2-step) enable
    opt_SwBstPol		 = $%00000010	 ; Switchable boost switch polarity
    opt_SwBoost 		 = $%00000001	 ; Switchable boost enable

OPTN2_CalCustomOptionConfigFlags2:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0x1FC4
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname CalCustomOptionConfigFlags2
    ;mptblcname OPTN2
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc These_are_options_available_to_enable_in_this_custom_codebase.
    ;mpchoices Spark-based_Rev_Limiter(Not_Working)  Fuel-based_Rev_Limiter  Suppress_EMR  Not_Used  Not_Used  Not_Used  Not_Used  Charge_Temp_Sens
    .byte 0x82                       ;Point 1
    opt_CTS  		         = $%10000000	 ; Charge Temp Sens
    opt_Bit6			 = $%01000000	 ;
    opt_Bit5         	         = $%00100000	 ;
    opt_Bit4 		         = $%00010000	 ;
    opt_Bit3         	         = $%00001000	 ;
    opt_SupressEMR		 = $%00000100	 ; Suppress the EMR (Emiss Maint Reminder) Code
    opt_FuelRevLim		 = $%00000010	 ; Use the fuel-based rev limiter
    opt_SprkRevLim 		 = $%00000001	 ; Use the spark-based rev limiter

MAPLO_LoMAP3DInputModifierFromMAP:
    ;mpgrp Setup\Transfer_Functions\
    ;mptbladdr 0x1FD9
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname LoMAP3DInputModifierFromMAP
    ;mptblcname MAPLO
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc Description
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x18, 0x00, 0x06, 0x67     ;Point 1
    .byte 0x3F, 0xFA                 ;Point 2

MAPHI_HiMAP3DInputModifierFromMAP:
    ;mpgrp Setup\Transfer_Functions\
    ;mptbladdr 0x1FE8
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname HiMAP3DInputModifierFromMAP
    ;mptblcname MAPHI
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Description
    ;mpmapaxis xy
    .byte 0x03                       ;Number of points in table
    .byte 0x40, 0x00, 0x02, 0x00     ;Point 1
    .byte 0x90, 0xA0, 0x01, 0x00     ;Point 2
    .byte 0xEF, 0xFF                 ;Point 3


RPMHI_HiRPM3DInputModifierFromRPM:
    ;mpgrp Setup\Transfer_Functions\
    ;mptbladdr 0x1FF9
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname HiRPM3DInputModifierFromRPM
    ;mptblcname RPMHI
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc Output_is_used_as_the_input_to_ALL_of_the_3D_tables_-_for_RPM_above_0x4000_(2048rpm)
    .byte 0x02                       ;Number of points in table
    .byte 0x40, 0x80, 0x01, 0x00     ;Point 1
    .byte 0xBF, 0xFF                 ;Point 2

RPMLO_LoRPM3DInputModifierFromRPM:
    ;mpgrp Setup\Transfer_Functions\
    ;mptbladdr 0x2007
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname LoRPM3DInputModifierFromRPM
    ;mptblcname RPMLO
    ;mpxaxis RPM 0 2048 rpm
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc Output_is_used_as_the_input_to_ALL_of_the_3D_tables_-_for_RPM_below_0x4000_(2048rpm)
    .byte 0x04                       ;Number of points in table
    .byte 0x64, 0x00, 0x01, 0x47     ;Point 1
    .byte 0x96, 0x40, 0x00, 0xA3     ;Point 2
    .byte 0xC8, 0x60, 0x00, 0x92     ;Point 3
    .byte 0xFF, 0x7F                 ;Point 4

ARMPMD_ModifiedMAPForAdaptiveRetard3D:
    ;mpgrp Setup\Transfer_Functions\
    ;mptbladdr 0x2017
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname ModifiedMAPForAdaptiveRetard3D
    ;mptblcname ARMPMD
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc Description
    ;mpmapaxis x
    .byte 0x03                       ;Number of points in table
    .byte 0x80, 0x00, 0x04, 0x00     ;Point 1
    .byte 0x90, 0x40, 0x02, 0x00     ;Point 2
    .byte 0xEF, 0xFF                 ;Point 3

TMPAMB_TempForScaleAmbientA2D:
    ;mpgrp Setup\Transfer_Functions\
    ;mptbladdr 0x2027
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempForScaleAmbientA2D
    ;mptblcname TMPAMB
    ;mpxaxis raw 0 255 scale
    ;mpyaxis Coolant_Temperature -200 260 F
    ;mptbldesc Detailed_Description
    .byte 0x06                       ;Number of points in table
    .byte 0x05, 0xFF, 0xFC, 0xC0     ;Point 1
    .byte 0x15, 0xCB, 0xFE, 0xF8     ;Point 2
    .byte 0x32, 0xAD, 0xFF, 0x83     ;Point 3
    .byte 0x6F, 0x8F, 0xFF, 0x9C     ;Point 4
    .byte 0xC8, 0x6C, 0xFF, 0x60     ;Point 5
    .byte 0xE8, 0x58                 ;Point 6

TMPTL1_TempForColdScaleA2D:
    ;mpgrp Setup\Transfer_Functions\
    ;mptbladdr 0x2039
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempForColdScaleFromA2D
    ;mptblcname TMPTL1
    ;mpxaxis raw 0 255 scale
    ;mpyaxis Coolant_Temperature -200 260 F
    ;mptbldesc Detailed_Description
    .byte 0x07                       ;Number of points in table
    .byte 0x00, 0xD3, 0xFF, 0x85     ;Point 1
    .byte 0x53, 0xAB, 0xFF, 0x9D     ;Point 2
    .byte 0xD7, 0x78, 0xFF, 0x55     ;Point 3
    .byte 0xE6, 0x6E, 0xFF, 0x17     ;Point 4
    .byte 0xF1, 0x64, 0xFE, 0xCD     ;Point 5
    .byte 0xF6, 0x5E, 0xFD, 0xAB     ;Point 6
    .byte 0xFF, 0x49                 ;Point 7

TMPTL2_TempForHotScaleA2D:
    ;mpgrp Setup\Transfer_Functions\
    ;mptbladdr 0x204C
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempForHotScaleA2D
    ;mptblcname TMPTL2
    ;mpxaxis raw 0 255 scale
    ;mpyaxis Coolant_Temperature -200 260 F
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Number of points in table
    .byte 0x42, 0xFF, 0xFF, 0x55     ;Point 1
    .byte 0x57, 0xF1, 0xFF, 0x75     ;Point 2
    .byte 0xC5, 0xB5, 0xFF, 0x4F     ;Point 3
    .byte 0xFF, 0x8D                 ;Point 4
    
TBLBK3_3DTableBreakPointHiLo:
    ;mpgrp Setup\Transfer_Functions\
    ;mptbladdr 0x205C
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname 3DTableBreakPointHiLo
    ;mptblcname TBLBK3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc Breakpoint_between_hi-_and_lo-MAP_3D_input_tables.
    ;mpmapaxis y
    .byte 0x40                       ;Point 1

BATVLT_BatteryVoltsTable:
    ;mpgrp Setup\Transfer_Functions\
    ;mptbladdr 0x2069
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname BatteryVoltsTable
    ;mptblcname BATVLT
    ;mpxaxis AmbientTemp -200 260 F
    ;mpyaxis BatVolts 0 16 V
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x6E, 0xEB, 0xFF, 0xAC     ;Point 1
    .byte 0xAB, 0xD7                 ;Point 2


SRCID_SourceCodeVersionID:
    ;mpgrp Setup\Cal_ID\
    ;mptbladdr 0x2078
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname SourceCodeVersionID
    ;mptblcname SRCID
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Desc
    .word 0x0E01                     ;Point 1
    ;mp******************************
    ;mpcodebase 0A T-LM
    ;mpcodebase 0B T-SMEC
    ;mpcodebase 0C T-SBEC
    ;mpcodebase 0D T-TIII_(91)
    ;mpcodebase 0E T-TIII_(92-93)
    ;mp******************************

; I replaced the hutsville tester codes with the Source code version ID so that I can always see what version of the codebase
; the cal is based on. This may be similar functionality to the original, though I don't know the meaning of the Huntsville codes.
;
; Codes:
;
; The first byte is the codebase type (LM, SMEC, SBEC, etc.)
;
; a = T-LM
; b = T-SMEC
; c = T-SBEC
; d = T-TIII (91)
; e = T-TIII (92-93)
; f = ??
;
; The 2nd byte is the source code version in HEX. For example:
; 0x10 = 16dec = version 16

CHKFIX_ChecksumFixupValue:
    ;mpgrp Setup\Cal_ID\
    ;mptbladdr 0x209C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ChecksumFixupValue
    ;mptblcname CHKFIX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis value 0 255 value
    ;mptbldesc Desc
    .byte 0x4B                       ;Point 1

        .msg "Data Structures Complete..." ; these are just messages to display during assemble to let you know what's going on...

