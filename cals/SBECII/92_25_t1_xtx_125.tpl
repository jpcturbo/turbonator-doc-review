;mpver 2.00
;mpassmfile 92_25_t1_xtx_125.asm
;mpmodelyr 95 1985
;mpmodelyr 96 1986
;mpmodelyr 97 1987
;mpmodelyr 98 1988
;mpmodelyr 99 1989
;mpmodelyr 00 1990
;mpmodelyr 01 1991
;mpmodelyr 02 1992
;mpmodelyr 03 1993
;mpmodelyr 04 1994
;mpmodelyr 05 1995
;mpmodelyr 11 1991_MP
;mpmodelyr 12 1992
;mpmodelyr 13 1993_Mex
;mpmodelyr 50 1990_Shadow
;mpmodelyr 40 1989_Daytona_VNT
;mpmodelyr 79 1989_3.0_Van
;mpmodelyr 70 1990_3.0_Van
;mpmodelyr 21 1991_3.0_Van
;mpmodelyr 22 1992_3.0
;mpmodelyr FF 1995_Neon
;mpengtran 08 2.2_T1
;mpengtran 09 2.2_TII
;mpengtran 44 2.2_T2_Auto
;mpengtran 10 2.2_TIV
;mpengtran 40 2.2_VNT_Manual
;mpengtran 01 2.5_T1
;mpengtran 02 2.5_T1_Canada
;mpengtran 11 2.5_Turbo
;mpengtran 81 2.5_T1_Sbec2
;mpengtran 21 2.5_T1_Van_Auto
;mpengtran 41 2.5_T1/T3_Manual
;mpengtran 12 3.0_MFI
;mpengtran 22 3.0_Auto
;mpengtran 51 3.0_Van_A604
;mpengtran 91 3.0_Auto
;mpengtran 13 3.3_MFI
;mpengtran 14 3.9_Truck
;mpengtran 17 4.0_Jeep_Manual
;mpengtran 15 5.2/5.9_TBI_VIN_Y
;mpengtran 16 5.2/5.9_TBI_VIN_X
;mpengtran C1 2.5_T2_Manual_Mex
;mpengtran FF Neon_Tran
;mpengtran 99 2.2_TIII
.org DataOrg
 
;************************************************************
;*                                                          *
;* Template created by:                                     *
;* MPDisassemble - Copyright 2009-2018 by Morris Terveen    *
;*                                                          *
;* Use at your own risk.  Author accepts no liability for   *
;* any damage that may result from the use of this program. *
;*                                                          *
;************************************************************
 
 
;mpinjsize 34.9
;mpbar 2.0
 
;mprevisionstart
;*************************************************************
;Initial disassemble
;*************************************************************
;mprevisionend
 
;mpfuelparms 6000,60,55,3.793,.740_Regular,2.5
;mpfuelnone1 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpfuelnone2 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpfuelpart1 14.9,14.9,14.9,14.9,14.9,14.9,14.9,14.9,14.9,14.9,14.9,14.9,14.9,14.7,13.5,12.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5
;mpfuelpart2 11.5,11.5,11.5,11.5,11.5,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11
;mpfuelfull1 13.6,13.6,13.6,13.6,13.6,13.6,13.6,13.6,13.6,13.6,13.6,13.6,13,12.5,12,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5
;mpfuelfull2 11.5,11.5,11.5,11.5,11.5,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11
 
.msg "Assembling Data Structures..." ; these are just messages to display during assemble to let you know what's going on...
RomBegin:
 
.org 0x8000
T_PNPrefix:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x0026
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PNPrefix
    ;mptblcname IDCODE_1
    ;mpxaxis X 0 255 scale
    ;mpyaxis Y 0 255 out
    ;mptbldesc Desc
    .byte 0x21                       ;Point 1
;.org 0x8001
T_PNPrefix1:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x0032
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PNPrefix1
    ;mptblcname IDCODE_2
    ;mpxaxis X 0 255 scale
    ;mpyaxis Y 0 255 out
    ;mptbldesc Desc
    .byte 0x00                       ;Point 1
;.org 0x8002
T_PNPrefix2:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x003E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PNPrefix2
    ;mptblcname ENDIT1
    ;mpxaxis X 0 255 scale
    ;mpyaxis Y 0 255 out
    ;mptbldesc Part_Number_prefix._The_1st_4_digits_of_the_Mopar_PN_for_this_ECU.
    .byte 0x04                       ;Point 1
;.org 0x8003
T_PNPrefix3:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x004A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PNPrefix3
    ;mptblcname ENDIT2
    ;mpxaxis X 0 255 scale
    ;mpyaxis Y 0 255 out
    ;mptbldesc Part_Number_prefix._The_1st_4_digits_of_the_Mopar_PN_for_this_ECU.
    .byte 0x67                       ;Point 1
;.org 0x8004
T_ECU_ID:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x0056
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ECU_ID
    ;mptblcname ENDITM
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc ECU_ID._This_portion_of_the_PN_is_used_by_scan_tools_to_automatically_ID_the_ECU._This_number_is_different_for_every_computer/cal._The_1st_digit_is_possibly_a_revision_code_of_some_type._Or____it_may_have_no_meaning_at_all.
    .byte 0x21                       ;Point 1
;.org 0x8005
T_ECU_ID2:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x0062
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ECU_ID2
    ;mptblcname ENDITM2
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc ECU_ID._This_portion_of_the_PN_is_used_by_scan_tools_to_automatically_ID_the_ECU._This_number_is_different_for_every_computer/cal._The_1st_digit_is_possibly_a_revision_code_of_some_type._Or____it_may_have_no_meaning_at_all.
    .byte 0x25                       ;Point 1
;.org 0x8006
T_Revision_Level:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x006E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Revision_Level
    ;mptblcname PARTREV
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Description
    .byte 0xA0                       ;Point 1
;.org 0x8007
T_RFINO3:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x007A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RFINO3
    ;mptblcname RFINO3
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Description
    .byte 0x04                       ;Point 1
;.org 0x8008
T_RFINO2:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x0086
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RFINO2
    ;mptblcname RFINO2
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Description
    .byte 0x67                       ;Point 1
;.org 0x8009
T_RFINO1:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x0092
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RFINO1
    ;mptblcname RFINO1
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Description
    .byte 0x21                       ;Point 1
;.org 0x800A
T_RFINO0:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x009E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RFINO0
    ;mptblcname RFINO0
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Description
    .byte 0x65                       ;Point 1
;.org 0x800B
T_RFIRevision:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x00AA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RFIRevision
    ;mptblcname RFIREV
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Description
    .byte 0xA0                       ;Point 1
;.org 0x800C
T_ChecksumValue:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x00B6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ChecksumValue
    ;mptblcname BITSUM
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Description
    .byte 0x63                       ;Point 1
;.org 0x800D
T_CODE13:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x00C2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CODE13
    ;mptblcname CODE13
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Description
    .byte 0x40                       ;Point 1
;.org 0x800E
T_CODE12:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x00CE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CODE12
    ;mptblcname CODE12
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Description
    .byte 0x38                       ;Point 1
;.org 0x800F
T_ModelTypeCode:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x00DA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ModelTypeCode
    ;mptblcname MDLCDE1
    ;mpxaxis X 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc The_1st_2_digits_are_the_model_year.
    .byte 0x12                       ;Point 1

;.org 0x8010
T_ModelTypeCode2:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x00FC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ModelTypeCode2
    ;mptblcname MDLCDE2
    ;mpxaxis X 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc The_1st_2_digits_are_the_engine_and_trans_type.
    .byte 0x81                       ;Point 1

;.org 0x8011
T_ConfigurationFlags:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x011F
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname ConfigurationFlags
    ;mptblcname CONFIG
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc These_are_the_factory_configuration_options.
    ;mpchoices Bit0  Bit1  CCD  AC  Bit3  Bit4  ATX  EGR
    .byte 0xB3                       ;Point 1
;.org 0x8012
T_ConfigurationFlags2:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x012C
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname ConfigurationFlags2
    ;mptblcname CONFIG2
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc These_are_the_factory_configuration_options.
    ;mpchoices Bit0  Bit1  Bit2  Bit3  TransFuel  Bit5  O2  Bit7
    .byte 0x00                       ;Point 1
;.org 0x8013
T_CCDConfigConstant:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x0139
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname CCDConfigConstant
    ;mptblcname CCDCFG
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc CCD_Bus_configuration_constant._Not_sure_of_usage.
    ;mpchoices Bit0  Bit1  Bit2  Bit3  Bit4  Bit5  Bit6  Bit7
    .byte 0x11                       ;Point 1
;.org 0x8014
T_CCDConfigConstant2:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x0146
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname CCDConfigConstant2
    ;mptblcname CCDCF2
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc CCD_Bus_configuration_constant._Not_sure_of_usage.
    ;mpchoices Bit0  Bit1  Bit2  Bit3  Bit4  Bit5  Bit6  Bit7
    .byte 0x30                       ;Point 1
;.org 0x8015
T_CCDConfigConstant3:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x0153
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname CCDConfigConstant3
    ;mptblcname CCDCF3
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc CCD_Bus_configuration_constant._Not_sure_of_usage.
    ;mpchoices Bit0  Bit1  Bit2  Bit3  Bit4  Bit5  Bit6  Bit7
    .byte 0x24                       ;Point 1
;.org 0x8016
T_ErrorBitsMask1:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x0160
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask1
    ;mptblcname FLTMSK1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x39                       ;Point 1
;.org 0x8017
T_ErrorBitsMask2:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x016C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask2
    ;mptblcname FLTMSK2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x3A                       ;Point 1
;.org 0x8018
T_ErrorBitsMask3:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x0178
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask3
    ;mptblcname FLTMSK3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1
;.org 0x8019
T_ErrorBitsMask4:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x0184
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask4
    ;mptblcname FLTMSK4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1
;.org 0x801A
T_ErrorBitsMask5:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x0190
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask5
    ;mptblcname FLTMSK5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1
;.org 0x801B
T_ErrorBitsMask6:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x019C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask6
    ;mptblcname FLTMSK6
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1
;.org 0x801C
T_ErrorBitsMask7:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x01A8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask7
    ;mptblcname FLTMSK7
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1
;.org 0x801D
T_ErrorBitsMaskTerminator:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x01B4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMaskTerminator
    ;mptblcname FLTMSKX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Must_be_0x00____and_must_be_at_the_end_of_the_error_code_list.
    .byte 0x00                       ;Point 1
;.org 0x801E
T_ModifierOf_ENGTMP_FromStalltime:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x01C0
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ModifierOf_ENGTMP_FromStalltime
    ;mptblcname RUNTMP
    ;mpxaxis time_after_stall 0 720 sec
    ;mpyaxis delta 0 720 temp
    ;mptbldesc Delta_modifier_added_to_engine_temp_after_a_stall_before_key_on._This_is_to_approximate_heat_soak
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x00, 0x05, 0x80     ;Point 1
    .byte 0x06, 0x21, 0x06, 0xCD     ;Point 2
    .byte 0x0B, 0x43                 ;Point 3
;.org 0x8029
T_MaxAllowableTempFor_RUNTMP:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x01CF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxAllowableTempFor_RUNTMP
    ;mptblcname RUNLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Max_allowable_temp_for_RUNTMP_(heat_soak_approximation)
    .byte 0xA0                       ;Point 1
;.org 0x802A
T_ResetEngRunTimerBelowThisDeltaCoolantTemp:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x01DB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ResetEngRunTimerBelowThisDeltaCoolantTemp
    ;mptblcname ERTDLC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Max_allowable_temp_for_RUNTMP_(heat_soak_approximation)
    .byte 0x05                       ;Point 1
;.org 0x802B
T_AdjustO2ResponseForPTEWhenMapAboveThis:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x01E7
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AdjustO2ResponseForPTEWhenMapAboveThis
    ;mptblcname BOOSTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc Zero_percent_limit_on_lean_O2CNTR_if_MAP_gt_BOOSTP_and_no_PTE
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1
;.org 0x802C
T_TimeO2InhibitedSwitchingRichIdleToClosedLoop:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x01F4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeO2InhibitedSwitchingRichIdleToClosedLoop
    ;mptblcname O2ITIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2_is_inhibited_for_this_time_when_switching_from_rich_idle_to_closed_loop_idle
    .byte 0xFF                       ;Point 1
;.org 0x802D
T_TargetIdleSpeedDefault:
    ;mpgrp Idle_-_Special_setup\
    ;mptbladdr 0x0200
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TargetIdleSpeedDefault
    ;mptblcname IDLDEF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc Detailed_Description
    .byte 0x7D                       ;Point 1
;.org 0x802E
T_StartTempToSelectHotOrColdAMTimer:
    ;mpgrp Fuel_-_Adaptive_Memory_Timer\
    ;mptbladdr 0x020C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StartTempToSelectHotOrColdAMTimer
    ;mptblcname AMTEMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc Starting_Temp_to_select_hot_or_cold_AM_timer
    .byte 0xCD                       ;Point 1
;.org 0x802F
T_TempPointToEnableSelectedAMTimer:
    ;mpgrp Fuel_-_Adaptive_Memory_Timer\
    ;mptbladdr 0x0218
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempPointToEnableSelectedAMTimer
    ;mptblcname AMTPSW
    ;mpxaxis Coolant_Temp -200 260 deg
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AM_temp_inhibit_time_from_coolant_temp
    .byte 0x02                       ;Number of points in table
    .byte 0xA6, 0x0C, 0x00, 0xD2     ;Point 1
    .byte 0xCD, 0x2C                 ;Point 2
;.org 0x8036
T_t8036x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0226
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8036x
    ;mptblcname T8036X
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x803E
T_ClosedLoopTimeFromEngTempAtStartup_FromTemp:
    ;mpgrp Fuel_-_Adaptive_Memory_Timer\
    ;mptbladdr 0x0232
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ClosedLoopTimeFromEngTempAtStartup_FromTemp
    ;mptblcname CLTIME
    ;mpxaxis Coolant_Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Leave_at_one_-_2.8_sec
    .byte 0x02                       ;Number of points in table
    .byte 0x9B, 0x03, 0x00, 0x17     ;Point 1
    .byte 0xB1, 0x05                 ;Point 2
;.org 0x8045
T_TempToStartCLTIMETimer:
    ;mpgrp Fuel_-_Adaptive_Memory_Timer\
    ;mptbladdr 0x0240
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TempToStartCLTIMETimer
    ;mptblcname CLTEMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 degrees
    ;mptbldesc Temperature_to_start_CLTIME_Timer_-_$94_=_70degreesF
    .byte 0x92                       ;Point 1
;.org 0x8046
T_AutoCalMapCellBoundary1:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x024C
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary1
    ;mptblcname MP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc AutoCalMapCellBoundary1
    ;mpmapaxis y
    .byte 0x24                       ;Point 1
;.org 0x8047
T_AutoCalMapCellBoundary2:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x0259
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary2
    ;mptblcname MP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc AutoCalMapCellBoundary1
    ;mpmapaxis y
    .byte 0x37                       ;Point 1
;.org 0x8048
T_AutoCalMapCellBoundary3:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x0266
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary3
    ;mptblcname MP3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc AutoCalMapCellBoundary1
    ;mpmapaxis y
    .byte 0x4B                       ;Point 1
;.org 0x8049
T_AutoCalMapCellBoundary4:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x0273
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary4
    ;mptblcname MP4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc AutoCalMapCellBoundary1
    ;mpmapaxis y
    .byte 0x61                       ;Point 1
;.org 0x804A
T_AutoCalMapCellBoundary5:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x0280
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary5
    ;mptblcname MP5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc AutoCalMapCellBoundary1
    ;mpmapaxis y
    .byte 0x78                       ;Point 1
;.org 0x804B
T_MapHysteresisAtMapCellBoundaries:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x028D
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MapHysteresisAtMapCellBoundaries
    ;mptblcname DLTMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc Map_Hysteresis_At_Map_Cell_Boundaries
    ;mpmapaxis y
    .byte 0x02                       ;Point 1
;.org 0x804C
T_RPMCellBoundaryInRPMover32:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x029A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMCellBoundaryInRPMover32
    ;mptblcname R1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc RPM_Cell_Boundary
    .byte 0x3A                       ;Point 1
;.org 0x804D
T_DeltaRPMAtRPMBoundariesInRPMOver32:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x02A6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaRPMAtRPMBoundariesInRPMOver32
    ;mptblcname DLTRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Delta_RPM_at_RPM_Boundaries
    .byte 0x02                       ;Point 1
;.org 0x804E
T_DeltaForIdleRPMForClosedThrottleCell:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x02B2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaForIdleRPMForClosedThrottleCell
    ;mptblcname IDLOFS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc RPM_Delta_for_Idle_RPM_For_Closed_Throttle_Cell
    .byte 0x04                       ;Point 1
;.org 0x804F
T_HysteresisFor_IDLOFS:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x02BE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HysteresisFor_IDLOFS
    ;mptblcname HYTRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Hysteresis_for_IDLOFS
    .byte 0x02                       ;Point 1
;.org 0x8050
T_BitsChangePerUpdateWithinACell:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x02CA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BitsChangePerUpdateWithinACell
    ;mptblcname CELCHG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_Bits_Change_Per_Update_Within_A_Cell
    .byte 0x01                       ;Point 1
;.org 0x8051
T_EPPsBetweenCalChangeUpdateOpenThrottle:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x02D6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EPPsBetweenCalChangeUpdateOpenThrottle
    ;mptblcname AMUPDT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EPPs_Between_Cal_Change_Update_(Open_Throttle)
    .byte 0x1A                       ;Point 1
;.org 0x8052
T_EPPsBetweenCalChangeUpdateClosedThrottle:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x02E2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EPPsBetweenCalChangeUpdateClosedThrottle
    ;mptblcname AMUPDI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EPPs_Between_Cal_Change_Update_(Closed_Throttle)
    .byte 0x1A                       ;Point 1
;.org 0x8053
T_O2ControllerDeadbandLimitForUpdatingCellsPos:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x02EE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2ControllerDeadbandLimitForUpdatingCellsPos
    ;mptblcname CALTHP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2_Controller_Deadband_Limit_For_Updating_Cells
    .byte 0x09                       ;Point 1
;.org 0x8054
T_O2ControllerDeadbandLimitForUpdatingCellsNeg:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x02FA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2ControllerDeadbandLimitForUpdatingCellsNeg
    ;mptblcname CALTHN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2_Controller_Deadband_Limit_For_Updating_Cells
    .byte 0x09                       ;Point 1
;.org 0x8055
T_NoCellUpdateAboveThisMAP:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x0306
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname NoCellUpdateAboveThisMAP
    ;mptblcname MAPLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc No_Cell_Update_Above_This_MAP
    ;mpmapaxis y
    .byte 0x99                       ;Point 1
;.org 0x8056
T_NoCellUpdateAndO2CNTRHeldBelowThisMap:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x0313
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname NoCellUpdateAndO2CNTRHeldBelowThisMap
    ;mptblcname MAPDEC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc No_Cell_Update_And_O2CNTR_Held_Below_This_Map._Set_to_0xff_to_disable_O2_feedback.
    ;mpmapaxis y
    .byte 0x14                       ;Point 1
;.org 0x8057
T_NoCellUpdateAboveThisRPMInRPMOver32:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x0320
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoCellUpdateAboveThisRPMInRPMOver32
    ;mptblcname RPMLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc No_Cell_Update_Above_This_RPM_-_in_rpms/32
    .byte 0x56                       ;Point 1
;.org 0x8058
T_NoCellUpdateBelow_PWMIN_Pulsewidth:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x032C
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname NoCellUpdateBelow_PWMIN_Pulsewidth
    ;mptblcname PWMIN
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc No_Cell_Update_below_PWMIN_-_this_value_times_4_uSec
    ;mpinjscale word
    .word 0x00AF                     ;Point 1
;.org 0x805A
T_MaxMultiplierCannotBeAbove7F:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x0339
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxMultiplierCannotBeAbove7F
    ;mptblcname AMLIMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AutoCal_Range_Of_Authority_where_MaxMultiplier=1+AMLIMH/512_(cannot_exceed_$7f)
    .byte 0x7F                       ;Point 1
;.org 0x805B
T_MinMultiplierCannotBeBelow80:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x0345
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinMultiplierCannotBeBelow80
    ;mptblcname AMLIML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AutoCal_Range_Of_Authority_where_MinMultiplier=.5+AMLIML/512_(cannot_be_below_$80)
    .byte 0x80                       ;Point 1
;.org 0x805C
T_PrimaryRamp:
    ;mpgrp Fuel_-_O2_Controller_Ramps\
    ;mptbladdr 0x0351
    ;mptbltype 11
    ;mpsubtype 1
    ;mptbllname PrimaryRamp
    ;mptblcname PRIRMP
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Lower_RPM_Boundary_-_RPM/32
    ;mpmapaxis y
    .word 0x293A                  ;Rpm Low / High Boundary
    .word 0x2F5E                  ;Map Low / High Boundary
    .word 0x0A0A                  ;Cell 0 Ramp Rich/Lean
    .word 0x0F0F                  ;Cell 1 Ramp Rich/Lean
    .word 0x0F0F                  ;Cell 2 Ramp Rich/Lean
    .word 0x1717                  ;Cell 3 Ramp Rich/Lean
    .word 0x1C1C                  ;Cell 4 Ramp Rich/Lean
    .word 0x1C1C                  ;Cell 5 Ramp Rich/Lean
    .word 0x1717                  ;Cell 6 Ramp Rich/Lean
    .word 0x1C1C                  ;Cell 7 Ramp Rich/Lean
    .word 0x1C1C                  ;Cell 8 Ramp Rich/Lean
    .word 0x0303                  ;Ramp Idle Cell Rich/Lean
    .word 0x0A0A                  ;Cell 0 Limits/Rates Rich/Lean
    .word 0x0F0F                  ;Cell 1 Limits/Rates Rich/Lean
    .word 0x0F0F                  ;Cell 2 Limits/Rates Rich/Lean
    .word 0x1717                  ;Cell 3 Limits/Rates Rich/Lean
    .word 0x1C1C                  ;Cell 4 Limits/Rates Rich/Lean
    .word 0x1C1C                  ;Cell 5 Limits/Rates Rich/Lean
    .word 0x1717                  ;Cell 6 Limits/Rates Rich/Lean
    .word 0x1C1C                  ;Cell 7 Limits/Rates Rich/Lean
    .word 0x1C1C                  ;Cell 8 Limits/Rates Rich/Lean
    .word 0x0303                  ;Limit/Rates Idle Cell Rich/Lean
;.org 0x8088
T_O2RangeLimitHigh:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x0373
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2RangeLimitHigh
    ;mptblcname O2LIMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2_Range_Of_Authority_MaxMultiplier=1+O2LIMH/512_(cannot_be_above_$7f)
    .byte 0x7F                       ;Point 1
;.org 0x8089
T_O2RangeLimitLow:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x037F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2RangeLimitLow
    ;mptblcname O2LIML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2_Range_Of_Authority_MinMultiplier=.5+O2LIML/512_(cannot_be_below_$80)
    .byte 0x80                       ;Point 1
;.org 0x808A
T_HighLimitForImmediateSwitchToClosedLoop:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x038B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForImmediateSwitchToClosedLoop
    ;mptblcname O2HIGH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HighLimitForImmediateSwitchToClosedLoop_$26_=_0.73v
    .byte 0x26                       ;Point 1
;.org 0x808B
T_HighLimitForDelayedSwitchToClosedLoop:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x0397
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForDelayedSwitchToClosedLoop
    ;mptblcname O2TLMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HighLimitForDelayedSwitchToClosedLoop
    .byte 0x1F                       ;Point 1
;.org 0x808C
T_HighLimitForInMiddleDetermination:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x03A3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForInMiddleDetermination
    ;mptblcname O2MIDH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HighLimitForInMiddleDetermination
    .byte 0x1F                       ;Point 1
;.org 0x808D
T_HighLimitForO2RampSwitching:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x03AF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForO2RampSwitching
    ;mptblcname O2HSWP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HighLimitForO2RampSwitching
    .byte 0x19                       ;Point 1
;.org 0x808E
T_LowLimitForO2RampSwitching:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x03BB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForO2RampSwitching
    ;mptblcname O2LSWP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LowLimitForO2RampSwitching
    .byte 0x18                       ;Point 1
;.org 0x808F
T_LowLimitForInMiddleDetermination:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x03C7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForInMiddleDetermination
    ;mptblcname O2MIDL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LowLimitForInMiddleDetermination._Used_for_Reverting_to_openLoop____Setting_fault21____outputting_O2_level_to_miller_tool
    .byte 0x12                       ;Point 1
;.org 0x8090
T_LowLimitForDelayedSwitchToClosedLoop:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x03D3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForDelayedSwitchToClosedLoop
    ;mptblcname O2TLML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LowLimitForDelayedSwitchToClosedLoop
    .byte 0x0F                       ;Point 1
;.org 0x8091
T_LowLimitForImmediateSwitchToClosedLoop:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x03DF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForImmediateSwitchToClosedLoop
    ;mptblcname O2LOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LowLimitForImmediateSwitchToClosedLoop
    .byte 0x0F                       ;Point 1
;.org 0x8092
T_DelayTimeToClosedLoop:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x03EB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DelayTimeToClosedLoop
    ;mptblcname O2TIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Delay_Time 0 720 Sec
    ;mptbldesc DelayTimeWhenGoingClosedLoop._o2_voltage_must_trigger_timer____ie_must_gt_O2TLMH_or_lt_O2TLML.Each_1_is_2.8_sec____cannot_exceed_$7f
    .byte 0x07                       ;Point 1
;.org 0x8093
T_IfNoO2SwitchForThisTimeThrowFault51or52:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x03F7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname IfNoO2SwitchForThisTimeThrowFault51or52
    ;mptblcname LTHTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc If_no_O2_sensor_state_change_for_this_time(*2.8sec)_then_fault_51_or_52
    .byte 0x2C                       ;Point 1
;.org 0x8094
T_SecondaryRamp:
    ;mpgrp Fuel_-_O2_Controller_Ramps\
    ;mptbladdr 0x0403
    ;mptbltype 11
    ;mpsubtype 1
    ;mptbllname SecondaryRamp
    ;mptblcname SECRMP
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Lower_RPM_Boundary_-_RPM/32
    ;mpmapaxis y
    .word 0x293A                  ;Rpm Low / High Boundary
    .word 0x2F5E                  ;Map Low / High Boundary
    .word 0x03FD                  ;Cell 0 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 1 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 2 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 3 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 4 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 5 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 6 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 7 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 8 Ramp Rich/Lean
    .word 0x01FF                  ;Ramp Idle Cell Rich/Lean
    .word 0x0404                  ;Cell 0 Limits/Rates Rich/Lean
    .word 0x0604                  ;Cell 1 Limits/Rates Rich/Lean
    .word 0x0604                  ;Cell 2 Limits/Rates Rich/Lean
    .word 0x0408                  ;Cell 3 Limits/Rates Rich/Lean
    .word 0x0408                  ;Cell 4 Limits/Rates Rich/Lean
    .word 0x0308                  ;Cell 5 Limits/Rates Rich/Lean
    .word 0x0408                  ;Cell 6 Limits/Rates Rich/Lean
    .word 0x0408                  ;Cell 7 Limits/Rates Rich/Lean
    .word 0x0408                  ;Cell 8 Limits/Rates Rich/Lean
    .word 0x0808                  ;Limit/Rates Idle Cell Rich/Lean
;.org 0x80C0
T_OverboostFuelShutoffEnablePointFromMap_Timer:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x0425
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostFuelShutoffEnablePointFromMap_Timer
    ;mptblcname MPSHFT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc If_MAP_+_BARO_exceeds_MPSHOF____wait_SHFDLT____then_kill_engine_for_TRNTM._Overboost_-_$ff_to_disable
    ;mpmapaxis y
    .byte 0x76                       ;Point 1
;.org 0x80C1
T_OverboostFuelShutoffEnablePointFromMap_Absolute:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x0432
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostFuelShutoffEnablePointFromMap_Absolute
    ;mptblcname MPSHFA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc If_MAP_+_BARO_exceeds_MPSHOF____wait_SHFDLT____then_kill_engine_for_TRNTM._Overboost_-_$ff_to_disable
    ;mpmapaxis y
    .byte 0x99                       ;Point 1
;.org 0x80C2
T_OverboostFuelShutoffDuration:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x043F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OverboostFuelShutoffDuration
    ;mptblcname TRNTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 Sec
    ;mptbldesc Overboost_shutoff_duration_-_$ff_to_disable_-_stock_$5a
    .byte 0x2E                       ;Point 1
;.org 0x80C3
T_OverboostFuelShutoffDisablePointFromMap_Limp:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x044B
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostFuelShutoffDisablePointFromMap_Limp
    ;mptblcname LMPSHF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Overboost_Shutoff_when_Wastegate_problem_has_been_detected_(should_not_disable_this)
    ;mpmapaxis y
    .byte 0x73                       ;Point 1
;.org 0x80C4
T_MapLimpinAndThrAbove25PercentLower1850:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x0458
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapLimpinAndThrAbove25PercentLower1850
    ;mptblcname REVLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc Fuel_Off_RPM_for_bad_MAP
    .byte 0x3A                       ;Point 1
;.org 0x80C5
T_MapLimpinAndThrAbove25PercentUpper2000:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x0464
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapLimpinAndThrAbove25PercentUpper2000
    ;mptblcname REVLMT2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc Fuel_On_RPM_for_bad_MAP
    .byte 0x3E                       ;Point 1
;.org 0x80C6
T_MapAbove75PctAndIdleSwitchClosed2000:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x0470
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapAbove75PctAndIdleSwitchClosed2000
    ;mptblcname REVLMT3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc Detailed_Description
    .byte 0x3E                       ;Point 1
;.org 0x80C7
T_MapAbove75PctAndThrLimpin2000:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x047C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapAbove75PctAndThrLimpin2000
    ;mptblcname REVLMT4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc Detailed_Description
    .byte 0x5E                       ;Point 1
;.org 0x80C8
T_RPMLimiterNormalOnRPM:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x0488
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimiterNormalOnRPM
    ;mptblcname REVLMT5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc Detailed_Description
    .byte 0xB8                       ;Point 1
;.org 0x80C9
T_RPMLimiterNormalOffRPM:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x0494
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimiterNormalOffRPM
    ;mptblcname REVLMT6
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc Detailed_Description
    .byte 0xC2                       ;Point 1
;.org 0x80CA
T_25PctThrValueFromShutoff:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x04A0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 25PctThrValueFromShutoff
    ;mptblcname THRTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x21                       ;Point 1
;.org 0x80CB
T_CarSpeedForRevLimitWithTBOff:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x04AC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CarSpeedForRevLimitWithTBOff
    ;mptblcname RVLSPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 128 mph
    ;mptbldesc Detailed_Description
    .byte 0x14                       ;Point 1
;.org 0x80CC
T_2050RPM_DecelFuelShutoffTurnonLimit:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x04B8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 2050RPM_DecelFuelShutoffTurnonLimit
    ;mptblcname DFRPM1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x26                       ;Point 1
;.org 0x80CD
T_2550RPM_DecelFuelShutoffUpperRpmLimit:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x04C4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 2550RPM_DecelFuelShutoffUpperRpmLimit
    ;mptblcname DFRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x2E                       ;Point 1
;.org 0x80CE
T_20MPHDecelFuelShutoffSpeedLimitOFF:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x04D0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 20MPHDecelFuelShutoffSpeedLimitOFF
    ;mptblcname DFS20M
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x14                       ;Point 1
;.org 0x80CF
T_20MPHDecelFuelShutoffSpeedLimitON:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x04DC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 20MPHDecelFuelShutoffSpeedLimitON
    ;mptblcname DFS20L
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1
;.org 0x80D0
T_60DegCDecelFuelShutoffTempLimitOff:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x04E8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 60DegCDecelFuelShutoffTempLimitOff
    ;mptblcname DFSTMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFE                       ;Point 1
;.org 0x80D1
T_60DegCDecelFuelShutoffTempLimitOn:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x04F4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 60DegCDecelFuelShutoffTempLimitOn
    ;mptblcname DFSTML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1
;.org 0x80D2
T_3minuteDecelFuelShutoffTimeLimitOFF:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x0500
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 3minuteDecelFuelShutoffTimeLimitOFF
    ;mptblcname DFSTMRH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0B                       ;Point 1
;.org 0x80D3
T_MAPDecelFuelShutoffTimeLimitOFF:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x050C
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MAPDecelFuelShutoffTimeLimitOFF
    ;mptblcname DFSMPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x2A                       ;Point 1
;.org 0x80D4
T_MAPDecelFuelShutoffTimeLimitON:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x0519
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MAPDecelFuelShutoffTimeLimitON
    ;mptblcname DFSMPL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x2E                       ;Point 1
;.org 0x80D5
T_CounterFuelEngineRunningInitA:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x0526
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname CounterFuelEngineRunningInitA
    ;mptblcname CTFERA
    ;mpxaxis in_desc 11 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1
    .byte 0x2F                       ;Point 2
    .byte 0x81                       ;Point 3
    .byte 0x1F                       ;Point 4
    .byte 0x23                       ;Point 5
    .byte 0x16                       ;Point 6
    .byte 0x32                       ;Point 7
    .byte 0x11                       ;Point 8
    .byte 0x21                       ;Point 9
    .byte 0x09                       ;Point 10
    .byte 0x41                       ;Point 11
;.org 0x80E0
T_SpeedLimitFuelShutoff254mph:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x0532
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SpeedLimitFuelShutoff254mph
    ;mptblcname SPDLMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 255 MPH
    ;mptbldesc Detailed_Description
    .byte 0x76                       ;Point 1
;.org 0x80E1
T_SpeedLimitFuelShutoffRestore253mph:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x053E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SpeedLimitFuelShutoffRestore253mph
    ;mptblcname SPDLML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x6E                       ;Point 1
;.org 0x80E2
T_EngineSpeedHighLimitToEnableOverspeed:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x054A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineSpeedHighLimitToEnableOverspeed
    ;mptblcname SPDRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x7D                       ;Point 1
;.org 0x80E3
T_EngineSpeedLowLimitToDisableOverspeed:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x0556
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineSpeedLowLimitToDisableOverspeed
    ;mptblcname SPDRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x77                       ;Point 1
;.org 0x80E4
T_PartThrottleAcCutoutDisableTemp:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0562
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PartThrottleAcCutoutDisableTemp
    ;mptblcname ACDTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1
;.org 0x80E5
T_PartThrottleAcCutoutDisableThrottle:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x056E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PartThrottleAcCutoutDisableThrottle
    ;mptblcname ACDTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1
;.org 0x80E6
T_PartThrottleAcCutoutDisableSpeed:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x057A
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname PartThrottleAcCutoutDisableSpeed
    ;mptblcname ACDSPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0000                     ;Point 1
;.org 0x80E8
T_PartThrottleAcCutoutMaxTimeActive:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0586
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PartThrottleAcCutoutMaxTimeActive
    ;mptblcname ACETIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x08                       ;Point 1
;.org 0x80E9
T_AllowAcClutchAboveThisRpm:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0592
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AllowAcClutchAboveThisRpm
    ;mptblcname ACERPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x44                       ;Point 1
;.org 0x80EA
T_AllowAcClutchAboveThisSpeed:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x059E
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname AllowAcClutchAboveThisSpeed
    ;mptblcname ACESPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0500                     ;Point 1
;.org 0x80EC
T_DisallowAcClutchEngageForThisTimeAfterAccelEnrich:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x05AA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DisallowAcClutchEngageForThisTimeAfterAccelEnrich
    ;mptblcname ACAETH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x2E                       ;Point 1
;.org 0x80ED
T_AllowedBoost_FromRpm2:
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x05B6
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromRpm2
    ;mptblcname WSGRP2
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_RPMs._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0xA8, 0x61, 0xFF, 0x00     ;Point 1
    .byte 0xBA, 0x4F                 ;Point 2
;.org 0x80F4
T_t80F4x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x05C5
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t80F4x
    ;mptblcname T80F4X
    ;mpxaxis Xinput 12 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
;.org 0x8100
T_AllowedBoost_FromRpm:
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x05D1
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromRpm
    ;mptblcname WSGRPM
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_RPMs._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0xA8, 0x61, 0xFF, 0x00     ;Point 1
    .byte 0xBA, 0x4F                 ;Point 2
;.org 0x8107
T_t8107x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x05E0
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8107x
    ;mptblcname T8107X
    ;mpxaxis Xinput 12 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
;.org 0x8113
T_AllowedBoost_FromTime:
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x05EC
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromTime
    ;mptblcname WSGTIM
    ;mpxaxis Time 0 0.72 Sec
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_time_in_boost._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x38, 0x61, 0xFF, 0x12     ;Point 1
    .byte 0x55, 0x46                 ;Point 2
;.org 0x811A
T_t811Ax:
    ;mpgrp Unassigned\
    ;mptbladdr 0x05FB
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t811Ax
    ;mptblcname T811AX
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x811E
T_AllowedBoost_FromTemp:
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x0607
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromTemp
    ;mptblcname WSGCLT
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_Engine_Temp._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x04                       ;Number of points in table
    .byte 0x7F, 0x43, 0x00, 0xC5     ;Point 1
    .byte 0xA6, 0x61, 0x00, 0x00     ;Point 2
    .byte 0xEE, 0x61, 0xFB, 0x00     ;Point 3
    .byte 0xF4, 0x43                 ;Point 4
;.org 0x812D
T_t812Dx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0618
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t812Dx
    ;mptblcname T812DX
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x8131
T_AllowedBoost_FromChargeTemp:
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x0624
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromChargeTemp
    ;mptblcname WSGCHG
    ;mpxaxis charge_temp -200 300 degrees
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_Charge_Temp._Boost_is_defined_as_MAP_reading_above_Baro._Charge_Temp_numbers_are_approximate_only
    ;mpmapaxis y
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x61                 ;Point 1
;.org 0x8134
T_t8134x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0632
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8134x
    ;mptblcname T8134X
    ;mpxaxis Xinput 12 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
;.org 0x8140
T_AllowedBoostForAutomatics_FromSpeed2:
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x063E
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoostForAutomatics_FromSpeed2
    ;mptblcname MXSBS2
    ;mpxaxis Speed 0 128 mph
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_Speed_to_protect_automatic_transmissions.
    ;mpmapaxis y
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x35, 0x04, 0x55     ;Point 1
    .byte 0x06, 0x4F, 0x01, 0x80     ;Point 2
    .byte 0x12, 0x61                 ;Point 3
;.org 0x814B
T_AllowedBoostForAutomatics_FromSpeed3:
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x064E
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoostForAutomatics_FromSpeed3
    ;mptblcname MXSBS3
    ;mpxaxis Speed 0 128 mph
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_Speed_to_protect_automatic_transmissions.
    ;mpmapaxis y
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x35, 0x04, 0x55     ;Point 1
    .byte 0x06, 0x4F, 0x01, 0x80     ;Point 2
    .byte 0x12, 0x61                 ;Point 3
;.org 0x8156
T_AllowedBoostForAutomatics_FromSpeed1:
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x065E
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoostForAutomatics_FromSpeed1
    ;mptblcname MXSBS1
    ;mpxaxis Speed 0 128 mph
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_Speed_to_protect_automatic_transmissions.
    ;mpmapaxis y
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x61                 ;Point 1
;.org 0x8159
T_t8159x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x066C
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8159x
    ;mptblcname T8159X
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x8161
T_AllowedBoostPartThrottle_FromThrottle:
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x0678
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoostPartThrottle_FromThrottle
    ;mptblcname WSGPRT
    ;mpxaxis TPS 0 5 volts
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_Throttle_at_Part_Throttle._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x3E, 0x1F, 0x00, 0xDE     ;Point 1
    .byte 0x8A, 0x61                 ;Point 2
;.org 0x8168
T_t8168x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0687
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8168x
    ;mptblcname T8168X
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x8170
T_AllowedBoostKnock_FromRpm:
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x0693
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoostKnock_FromRpm
    ;mptblcname WSGRPA
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_RPMs_while_knocking._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x04                       ;Number of points in table
    .byte 0x6A, 0x24, 0xFF, 0x87     ;Point 1
    .byte 0x7D, 0x1B, 0x00, 0x00     ;Point 2
    .byte 0xA8, 0x1B, 0xFF, 0x0E     ;Point 3
    .byte 0xBA, 0x0A                 ;Point 4
;.org 0x817F
T_t817Fx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x06A4
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t817Fx
    ;mptblcname T817FX
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x8183
T_BoostTargetModifierFromTotalKnockRetard:
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x06B0
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BoostTargetModifierFromTotalKnockRetard
    ;mptblcname BSTMDK
    ;mpxaxis TotalKnockRetard 0 128 deg
    ;mpyaxis BoostReduction 0 29.4 psi
    ;mptbldesc WOT_WG_Duty_Cycle
    ;mpmapaxis y
    .byte 0x03                       ;Number of points in table
    .byte 0x06, 0x00, 0x00, 0x59     ;Point 1
    .byte 0x20, 0x09, 0x00, 0x3A     ;Point 2
    .byte 0x70, 0x1B                 ;Point 3
;.org 0x818E
T_BoostTargetModifierFromBaro2:
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x06C0
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BoostTargetModifierFromBaro2
    ;mptblcname BSTMBR
    ;mpxaxis Baro -14.7 14.7 psi
    ;mpyaxis BoostIncrease 0 29.4 psi
    ;mptbldesc WOT_WG_Duty_Cycle
    ;mpmapaxis x
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1
;.org 0x8191
T_t8191x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x06CE
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8191x
    ;mptblcname T8191X
    ;mpxaxis Xinput 12 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
;.org 0x819D
T_FullThrottleWastegateDutyCycle_C8is100Percent_FromMap:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x06DA
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FullThrottleWastegateDutyCycle_C8is100Percent_FromMap
    ;mptblcname DCWOT
    ;mpxaxis TargetBoost 0 29.4 psi
    ;mpyaxis Duty_Cycle 0 128 percent
    ;mptbldesc WOT_WG_Duty_Cycle
    ;mpmapaxis x
    .byte 0x07                       ;Number of points in table
    .byte 0x11, 0x00, 0x02, 0x89     ;Point 1
    .byte 0x20, 0x26, 0x01, 0x00     ;Point 2
    .byte 0x26, 0x2C, 0x02, 0xB3     ;Point 3
    .byte 0x30, 0x47, 0x01, 0xB2     ;Point 4
    .byte 0x47, 0x6E, 0x01, 0x14     ;Point 5
    .byte 0x61, 0x8A, 0x00, 0xDE     ;Point 6
    .byte 0x70, 0x97                 ;Point 7
;.org 0x81B8
T_FullThrottleWastegateDutyCycleAdjustment_FromRpm:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x06EE
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname FullThrottleWastegateDutyCycleAdjustment_FromRpm
    ;mptblcname DCWADJ
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis DC_Adjust -64 64 percent
    ;mptbldesc WOT_Duty_Cycle_Adjustment
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1
;.org 0x81BB
T_t81BBx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x06FB
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t81BBx
    ;mptblcname T81BBX
    ;mpxaxis Xinput 20 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
    .byte 0xFF                       ;Point 13
    .byte 0xFF                       ;Point 14
    .byte 0xFF                       ;Point 15
    .byte 0xFF                       ;Point 16
    .byte 0xFF                       ;Point 17
    .byte 0xFF                       ;Point 18
    .byte 0xFF                       ;Point 19
    .byte 0xFF                       ;Point 20
;.org 0x81CF
T_PartThrottleWastegateDutyCycleAdjustment_FromRpm:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0708
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname PartThrottleWastegateDutyCycleAdjustment_FromRpm
    ;mptblcname DCPADJ
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis DC_Adjust -64 64 percent
    ;mptbldesc PT_Duty_Cycle_Adjustment
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1
;.org 0x81D2
T_t81D2x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0715
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t81D2x
    ;mptblcname T81D2X
    ;mpxaxis Xinput 20 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
    .byte 0xFF                       ;Point 13
    .byte 0xFF                       ;Point 14
    .byte 0xFF                       ;Point 15
    .byte 0xFF                       ;Point 16
    .byte 0xFF                       ;Point 17
    .byte 0xFF                       ;Point 18
    .byte 0xFF                       ;Point 19
    .byte 0xFF                       ;Point 20
;.org 0x81E6
T_BoostTargetThresholdForDefaultWGDutyCycle:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0722
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BoostTargetThresholdForDefaultWGDutyCycle
    ;mptblcname BSTTSH
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Desc
    ;mpmapaxis y
    .byte 0x03                       ;Number of points in table
    .byte 0x34, 0xFF, 0xFE, 0x00     ;Point 1
    .byte 0x6D, 0x8D, 0xFF, 0x9F     ;Point 2
    .byte 0xBC, 0x6F                 ;Point 3
;.org 0x81F1
T_BoostDeltaThresholdFromBoostTarget:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0732
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BoostDeltaThresholdFromBoostTarget
    ;mptblcname BSDLTH
    ;mpxaxis BoostTarget 0 29.4 psi
    ;mpyaxis MaxBoostDelta 0 29.4 psi
    ;mptbldesc Desc
    ;mpmapaxis x
    .byte 0x05                       ;Number of points in table
    .byte 0x00, 0x33, 0xFF, 0xB5     ;Point 1
    .byte 0x55, 0x1A, 0xFF, 0x59     ;Point 2
    .byte 0x6F, 0x09, 0x00, 0x00     ;Point 3
    .byte 0x80, 0x09, 0xFF, 0x7D     ;Point 4
    .byte 0xB3, 0xEF                 ;Point 5
;.org 0x8204
T_t8204x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0744
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8204x
    ;mptblcname T8204X
    ;mpxaxis Xinput 16 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
    .byte 0xFF                       ;Point 13
    .byte 0xFF                       ;Point 14
    .byte 0xFF                       ;Point 15
    .byte 0xFF                       ;Point 16
;.org 0x8214
T_BoostTargetReductionFromDeltaBoost:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0750
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BoostTargetReductionFromDeltaBoost
    ;mptblcname BSREDX
    ;mpxaxis BoostTargetReduction 0 29.4 psi
    ;mpyaxis BoostDelta 0 29.4 psi
    ;mptbldesc Desc
    ;mpmapaxis x
    .byte 0x05                       ;Number of points in table
    .byte 0x43, 0x33, 0xFE, 0xFB     ;Point 1
    .byte 0x75, 0x00, 0x00, 0x00     ;Point 2
    .byte 0x79, 0x00, 0xFD, 0xB7     ;Point 3
    .byte 0x80, 0xF0, 0xFE, 0x80     ;Point 4
    .byte 0x8C, 0xDE                 ;Point 5
;.org 0x8227
T_t8227x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0762
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8227x
    ;mptblcname T8227X
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x822F
T_BoostTargetScaleFactor:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x076E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BoostTargetScaleFactor
    ;mptblcname BSTGSC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Factor 0 100 percent
    ;mptbldesc Desc
    .byte 0xFF                       ;Point 1
;.org 0x8230
T_BCTestValue3:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x077A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BCTestValue3
    ;mptblcname BCTEST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis our_desc 0 255 out
    ;mptbldesc Desc
    .byte 0xFF                       ;Point 1
;.org 0x8231
T_MaxWGDutyCycle:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0786
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxWGDutyCycle
    ;mptblcname MXWGDC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis WGDC 0 127 percent
    ;mptbldesc Desc
    .byte 0xC8                       ;Point 1
;.org 0x8232
T_BoostThresholdOffsetForWGControl:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0792
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BoostThresholdOffsetForWGControl
    ;mptblcname BSTHOF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Desc
    ;mpmapaxis y
    .byte 0x00                       ;Point 1
;.org 0x8233
T_WasteGateDutyCycleTimer:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x079F
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname WasteGateDutyCycleTimer
    ;mptblcname WGDCDL
    ;mpxaxis X 0 255 scale
    ;mpyaxis Y 0 255 out
    ;mptbldesc Desc
    .word 0x61A8                     ;Point 1
;.org 0x8235
T_WasteGateDutyCycleFactor:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x07AB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WasteGateDutyCycleFactor
    ;mptblcname WGDCSC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis factor 0 255 out
    ;mptbldesc Desc
    .byte 0x7D                       ;Point 1
;.org 0x8236
T_MaximumWGDutyCycleForControl:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x07B7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaximumWGDutyCycleForControl
    ;mptblcname WGDCMX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis WGDC 0 127 percent
    ;mptbldesc Desc
    .byte 0xC8                       ;Point 1
;.org 0x8237
T_BCTestValue1:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x07C3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BCTestValue1
    ;mptblcname BCTEST1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis our_desc 0 255 out
    ;mptbldesc Desc
    .byte 0xFF                       ;Point 1
;.org 0x8238
T_BCTestValue2:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x07CF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BCTestValue2
    ;mptblcname BCTEST2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis our_desc 0 255 out
    ;mptbldesc Desc
    .byte 0x01                       ;Point 1
;.org 0x8239
T_t8239x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x07DB
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8239x
    ;mptblcname T8239X
    ;mpxaxis Xinput 1 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0x03                       ;Point 1
;.org 0x823A
T_MinimumBoostToIncrementBoostTimer:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x07E7
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MinimumBoostToIncrementBoostTimer
    ;mptblcname BTMNBT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x0F                       ;Point 1
;.org 0x823B
T_MinimumRPMToIncrementBoostTimer:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x07F4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumRPMToIncrementBoostTimer
    ;mptblcname BTMNRP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc Detailed_Description
    .byte 0x3F                       ;Point 1
;.org 0x823C
T_StopAdaptiveWhenDeltaMapIsLessThanThis:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0800
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname StopAdaptiveWhenDeltaMapIsLessThanThis
    ;mptblcname MPFLOR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x02                       ;Point 1
;.org 0x823D
T_t823Dx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x080D
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t823Dx
    ;mptblcname T823DX
    ;mpxaxis Xinput 1 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0x02                       ;Point 1
;.org 0x823E
T_AdaptiveDecAfterThisTime:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0819
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveDecAfterThisTime
    ;mptblcname DECPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_BoostErrTimer_counts_before_WG_Duty_Cycle_is_decremented._Used_when_boost_is_above_target.
    .byte 0x18                       ;Point 1
;.org 0x823F
T_MaxWGDCForBoostErrorCorrection:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0825
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxWGDCForBoostErrorCorrection
    ;mptblcname WGMXER
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis WGDC 0 128 percent
    ;mptbldesc Detailed_Description
    .byte 0x44                       ;Point 1
;.org 0x8240
T_WastegateDutyCycleOffset:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0831
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleOffset
    ;mptblcname WGDCOF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DutyCycle 0 128 Percent
    ;mptbldesc Detailed_Description
    .byte 0x0C                       ;Point 1
;.org 0x8241
T_StopAdaptiveWGWhenMapIsThisCloseToBoostTarget:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x083D
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname StopAdaptiveWGWhenMapIsThisCloseToBoostTarget
    ;mptblcname MPROOF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x00                       ;Point 1
;.org 0x8242
T_IncCounterWhenDeltaMapBelowThis2:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x084A
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname IncCounterWhenDeltaMapBelowThis2
    ;mptblcname MPDEL2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x06                       ;Point 1
;.org 0x8243
T_AdaptiveDecAfterThisTimeX:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0857
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveDecAfterThisTimeX
    ;mptblcname DECPTX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x18                       ;Point 1
;.org 0x8244
T_MaxWGDCForBoostErrorCorrection2:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0863
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxWGDCForBoostErrorCorrection2
    ;mptblcname WGMX2R
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis WGDC 0 128 percent
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1
;.org 0x8245
T_NoWastegateDutyCycleCorrectionBelowThisRpm:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x086F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoWastegateDutyCycleCorrectionBelowThisRpm
    ;mptblcname DCRPML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc Detailed_Description
    .byte 0x5E                       ;Point 1
;.org 0x8246
T_NoWastegateDutyCycleCorrectionAboveThisRpm:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x087B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoWastegateDutyCycleCorrectionAboveThisRpm
    ;mptblcname DCRPMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc Detailed_Description
    .byte 0xBC                       ;Point 1
;.org 0x8247
T_UpdateAdaptiveWGTPSUpperLimit:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0887
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UpdateAdaptiveWGTPSUpperLimit
    ;mptblcname TPSLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis TPS_Volts 0 5 volts
    ;mptbldesc Detailed_Description
    .byte 0x66                       ;Point 1
;.org 0x8248
T_NoWastegateDutyCycleCorrectionBelowThisCoolantTemp:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0893
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoWastegateDutyCycleCorrectionBelowThisCoolantTemp
    ;mptblcname DCCTSL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis CoolantTemp -200 260 DegF
    ;mptbldesc Detailed_Description
    .byte 0xB4                       ;Point 1
;.org 0x8249
T_WastegateDutyCycleMapSwitchPoint:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x089F
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname WastegateDutyCycleMapSwitchPoint
    ;mptblcname MAPPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Wastegate_Duty_Cycle_Adjustment_boost_switch_point.
    ;mpmapaxis y
    .byte 0x45                       ;Point 1
;.org 0x824A
T_WastegateDutyCycleRpmBoundary1:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x08AC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleRpmBoundary1
    ;mptblcname DCRPM1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc Detailed_Description
    .byte 0x8A                       ;Point 1
;.org 0x824B
T_WastegateDutyCycleRpmBoundary2:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x08B8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleRpmBoundary2
    ;mptblcname DCRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc Detailed_Description
    .byte 0x9E                       ;Point 1
;.org 0x824C
T_WastegateDutyCycleRpmBoundary3:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x08C4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleRpmBoundary3
    ;mptblcname DCRPM3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1
;.org 0x824D
T_WastegateDutyCycleRpmBoundary4:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x08D0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleRpmBoundary4
    ;mptblcname DCRPM4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1
;.org 0x824E
T_BoostTargetModifierFromBaro:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x08DC
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BoostTargetModifierFromBaro
    ;mptblcname BSTMDB
    ;mpxaxis Baro -14.7 14.7 psi
    ;mpyaxis Factor 0 255 out
    ;mptbldesc Desc
    ;mpmapaxis x
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1
;.org 0x8251
T_t8251x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x08EA
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8251x
    ;mptblcname T8251X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x8255
T_BoostTargetModifierFromRPM:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x08F6
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname BoostTargetModifierFromRPM
    ;mptblcname BSTMDR
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Factor 0 255 out
    ;mptbldesc Desc
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1
;.org 0x8258
T_t8258x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0903
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8258x
    ;mptblcname T8258X
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x8260
T_OverboostControlPoint:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x090F
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostControlPoint
    ;mptblcname OBCTRL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x78                       ;Point 1
;.org 0x8261
T_DeltaBoostLimitNegativeForBoostCreep:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x091C
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaBoostLimitNegativeForBoostCreep
    ;mptblcname DBCRNG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaBoost 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x03                       ;Point 1
;.org 0x8262
T_DeltaBoostSampleCounterMax:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0929
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaBoostSampleCounterMax
    ;mptblcname DLTBSC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaBTimer 0 2.8 sec
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1
;.org 0x8263
T_DeltaBoostLimitPositiveForBoostCreep:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0935
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaBoostLimitPositiveForBoostCreep
    ;mptblcname DBCRPS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x00                       ;Point 1
;.org 0x8264
T_AdaptiveIncAfterThisTime:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0942
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveIncAfterThisTime
    ;mptblcname INCPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaBTimer 0 2.8 sec
    ;mptbldesc Detailed_Description
    .byte 0x08                       ;Point 1
;.org 0x8265
T_WGDCOffsetNegatve:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x094E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WGDCOffsetNegatve
    ;mptblcname WGDCON
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis WGDC 0 128 percent
    ;mptbldesc Detailed_Description
    .byte 0x0C                       ;Point 1
;.org 0x8266
T_WGDCDecayCounterInit:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x095A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WGDCDecayCounterInit
    ;mptblcname WGDCDC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Counter 0 255 count
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1
;.org 0x8267
T_DefaultWastegateDutyCycle:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0966
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DefaultWastegateDutyCycle
    ;mptblcname DFWGDC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis WGDC 0 128 percent
    ;mptbldesc Detailed_Description
    .byte 0x80                       ;Point 1
;.org 0x8268
T_CounterFuelEngineRunningInitD:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x0972
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname CounterFuelEngineRunningInitD
    ;mptblcname CTFERD
    ;mpxaxis in_desc 26 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0x01                       ;Point 12
    .byte 0xFF                       ;Point 13
    .byte 0xFF                       ;Point 14
    .byte 0xFF                       ;Point 15
    .byte 0xFF                       ;Point 16
    .byte 0xFF                       ;Point 17
    .byte 0xFF                       ;Point 18
    .byte 0xFF                       ;Point 19
    .byte 0xFF                       ;Point 20
    .byte 0xFF                       ;Point 21
    .byte 0xFF                       ;Point 22
    .byte 0xFF                       ;Point 23
    .byte 0xFF                       ;Point 24
    .byte 0xFF                       ;Point 25
    .byte 0xFF                       ;Point 26
;.org 0x8282
T_BaroReadLowRPM1800:
    ;mpgrp Baro_Read\
    ;mptbladdr 0x097F
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname BaroReadLowRPM1800
    ;mptblcname BRPMLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc Detailed_Description
    .word 0x3840                     ;Point 1
;.org 0x8284
T_BaroReadHighRPM6650:
    ;mpgrp Baro_Read\
    ;mptbladdr 0x098B
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname BaroReadHighRPM6650
    ;mptblcname BRPMHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc Detailed_Description
    .word 0xBB80                     ;Point 1
;.org 0x8286
T_BaroReadDelayAfterThrottleClosed2sec:
    ;mpgrp Baro_Read\
    ;mptbladdr 0x0997
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadDelayAfterThrottleClosed2sec
    ;mptblcname BRDLAY
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Detailed_Description
    .byte 0xBA                       ;Point 1
;.org 0x8287
T_BaroReadMinTimeBetweenReadings179sec:
    ;mpgrp Baro_Read\
    ;mptbladdr 0x09A3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadMinTimeBetweenReadings179sec
    ;mptblcname BARTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 720 sec
    ;mptbldesc Detailed_Description
    .byte 0x41                       ;Point 1
;.org 0x8288
T_BaroReadDelayAfterSolenoidOpenTenthSec:
    ;mpgrp Baro_Read\
    ;mptbladdr 0x09AF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadDelayAfterSolenoidOpenTenthSec
    ;mptblcname BROPTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Detailed_Description
    .byte 0x09                       ;Point 1
;.org 0x8289
T_BaroReadDelayAfterSolenoidClosedTenthSec:
    ;mpgrp Baro_Read\
    ;mptbladdr 0x09BB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadDelayAfterSolenoidClosedTenthSec
    ;mptblcname BRCLTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Detailed_Description
    .byte 0x09                       ;Point 1
;.org 0x828A
T_BaroReadValidHighLimit:
    ;mpgrp Baro_Read\
    ;mptbladdr 0x09C7
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BaroReadValidHighLimit
    ;mptblcname BAROHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x85                       ;Point 1
;.org 0x828B
T_BaroReadValidLowLimit:
    ;mpgrp Baro_Read\
    ;mptbladdr 0x09D4
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BaroReadValidLowLimit
    ;mptblcname BAROLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x45                       ;Point 1
;.org 0x828C
T_BaroReadDefaultValue:
    ;mpgrp Baro_Read\
    ;mptbladdr 0x09E1
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BaroReadDefaultValue
    ;mptblcname BARDFT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x7F                       ;Point 1
;.org 0x828D
T_MAPAverageTimeConstantForBOV:
    ;mpgrp BOV_Control\
    ;mptbladdr 0x09EE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MAPAverageTimeConstantForBOV
    ;mptblcname BOVTCT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis TimeConst 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1
;.org 0x828E
T_MinMAPForBOV:
    ;mpgrp BOV_Control\
    ;mptbladdr 0x09FA
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MinMAPForBOV
    ;mptblcname BOVMNM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x1A                       ;Point 1
;.org 0x828F
T_MinBaroForBOV2:
    ;mpgrp BOV_Control\
    ;mptbladdr 0x0A07
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MinBaroForBOV2
    ;mptblcname BOVMB2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x7F                       ;Point 1
;.org 0x8290
T_MAPOffsetForBOV:
    ;mpgrp BOV_Control\
    ;mptbladdr 0x0A14
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MAPOffsetForBOV
    ;mptblcname BOVMPO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x04                       ;Point 1
;.org 0x8291
T_MinimumMainLoopCountForBOV:
    ;mpgrp BOV_Control\
    ;mptbladdr 0x0A21
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumMainLoopCountForBOV
    ;mptblcname BOVMLP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Count 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1
;.org 0x8292
T_MinBaroForBOV:
    ;mpgrp BOV_Control\
    ;mptbladdr 0x0A2D
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MinBaroForBOV
    ;mptblcname BOVMNB
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x1A                       ;Point 1
;.org 0x8293
T_FanTurnOnTempAbove45Mph:
    ;mpgrp Fan_Control\
    ;mptbladdr 0x0A3A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOnTempAbove45Mph
    ;mptblcname FANTMP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc Detailed_Description3
    .byte 0xE8                       ;Point 1
;.org 0x8294
T_FanTurnOffTempAbove45Mph:
    ;mpgrp Fan_Control\
    ;mptbladdr 0x0A46
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOffTempAbove45Mph
    ;mptblcname FANTMP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc Detailed_Description3
    .byte 0xE3                       ;Point 1
;.org 0x8295
T_FanTurnOnTempBelow35Mph:
    ;mpgrp Fan_Control\
    ;mptbladdr 0x0A52
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOnTempBelow35Mph
    ;mptblcname FANTMP3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc Detailed_Description3
    .byte 0xE3                       ;Point 1
;.org 0x8296
T_FanTurnOffTempBelow35Mph:
    ;mpgrp Fan_Control\
    ;mptbladdr 0x0A5E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOffTempBelow35Mph
    ;mptblcname FANTMP4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc Detailed_Description3
    .byte 0xDD                       ;Point 1
;.org 0x8297
T_FanTurnsOnWhenMapAboveBaroPlusThis:
    ;mpgrp Fan_Control\
    ;mptbladdr 0x0A6A
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname FanTurnsOnWhenMapAboveBaroPlusThis
    ;mptblcname FANMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1
;.org 0x8298
T_FanTurnsOnWhenBatteryTempAboveThis:
    ;mpgrp Fan_Control\
    ;mptbladdr 0x0A77
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnsOnWhenBatteryTempAboveThis
    ;mptblcname FANBAT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Battery_Temp -200 260 Degrees
    ;mptbldesc Detailed_Description
    .byte 0xE4                       ;Point 1
;.org 0x8299
T_CannisterPurgeWhenBelowThisBaro:
    ;mpgrp Purge_Control\
    ;mptbladdr 0x0A83
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname CannisterPurgeWhenBelowThisBaro
    ;mptblcname PURMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x7F                       ;Point 1
;.org 0x829A
T_CannisterPurgeBaroHysteresis:
    ;mpgrp Purge_Control\
    ;mptbladdr 0x0A90
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname CannisterPurgeBaroHysteresis
    ;mptblcname PURHYS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x02                       ;Point 1
;.org 0x829B
T_CanisterPurgeCoolantTemp:
    ;mpgrp Purge_Control\
    ;mptbladdr 0x0A9D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CanisterPurgeCoolantTemp
    ;mptblcname PURTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x82                       ;Point 1
;.org 0x829C
T_Cyl2AdaptiveMemoryPointer:
    ;mpgrp Fuel_-_Individual_Cylinder_Trim\
    ;mptbladdr 0x0AA9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl2AdaptiveMemoryPointer
    ;mptblcname CL2PTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0C                       ;Point 1
;.org 0x829D
T_Cyl1AdaptiveMemoryPointer:
    ;mpgrp Fuel_-_Individual_Cylinder_Trim\
    ;mptbladdr 0x0AB5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl1AdaptiveMemoryPointer
    ;mptblcname CL1PTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1
;.org 0x829E
T_Cyl3AdaptiveMemoryPointer:
    ;mpgrp Fuel_-_Individual_Cylinder_Trim\
    ;mptbladdr 0x0AC1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl3AdaptiveMemoryPointer
    ;mptblcname CL3PTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1
;.org 0x829F
T_Cyl4AdaptiveMemoryPointer:
    ;mpgrp Fuel_-_Individual_Cylinder_Trim\
    ;mptbladdr 0x0ACD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl4AdaptiveMemoryPointer
    ;mptblcname CL4PTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Point 1
;.org 0x82A0
T_Cyl2TrimLimit:
    ;mpgrp Fuel_-_Individual_Cylinder_Trim\
    ;mptbladdr 0x0AD9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl2TrimLimit
    ;mptblcname CL2LMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x2E                       ;Point 1
;.org 0x82A1
T_Cyl1TrimLimit:
    ;mpgrp Fuel_-_Individual_Cylinder_Trim\
    ;mptbladdr 0x0AE5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl1TrimLimit
    ;mptblcname CL1LMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x3D                       ;Point 1
;.org 0x82A2
T_Cyl3TrimLimit:
    ;mpgrp Fuel_-_Individual_Cylinder_Trim\
    ;mptbladdr 0x0AF1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl3TrimLimit
    ;mptblcname CL3LMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x3D                       ;Point 1
;.org 0x82A3
T_Cyl4TrimLimit:
    ;mpgrp Fuel_-_Individual_Cylinder_Trim\
    ;mptbladdr 0x0AFD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl4TrimLimit
    ;mptblcname CL4LMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x3D                       ;Point 1
;.org 0x82A4
T_Cyl2TrimIncrement:
    ;mpgrp Fuel_-_Individual_Cylinder_Trim\
    ;mptbladdr 0x0B09
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl2TrimIncrement
    ;mptblcname CL2INC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Point 1
;.org 0x82A5
T_Cyl1TrimIncrement:
    ;mpgrp Fuel_-_Individual_Cylinder_Trim\
    ;mptbladdr 0x0B15
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl1TrimIncrement
    ;mptblcname CL1INC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Point 1
;.org 0x82A6
T_Cyl3TrimIncrement:
    ;mpgrp Fuel_-_Individual_Cylinder_Trim\
    ;mptbladdr 0x0B21
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl3TrimIncrement
    ;mptblcname CL3INC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Point 1
;.org 0x82A7
T_Cyl4TrimIncrement:
    ;mpgrp Fuel_-_Individual_Cylinder_Trim\
    ;mptbladdr 0x0B2D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl4TrimIncrement
    ;mptblcname CL4INC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Point 1
;.org 0x82A8
T_MinimumCylinderTrim:
    ;mpgrp Fuel_-_Individual_Cylinder_Trim\
    ;mptbladdr 0x0B39
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumCylinderTrim
    ;mptblcname CLTRMN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x07                       ;Point 1
;.org 0x82A9
T_Cyl2TrimValueForPurgeVolume:
    ;mpgrp Fuel_-_Individual_Cylinder_Trim\
    ;mptbladdr 0x0B45
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl2TrimValueForPurgeVolume
    ;mptblcname CLTRP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x27                       ;Point 1
;.org 0x82AA
T_Cyl1TrimValueForPurgeVolume:
    ;mpgrp Fuel_-_Individual_Cylinder_Trim\
    ;mptbladdr 0x0B51
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl1TrimValueForPurgeVolume
    ;mptblcname CLTRP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x12                       ;Point 1
;.org 0x82AB
T_Cyl3TrimValueForPurgeVolume:
    ;mpgrp Fuel_-_Individual_Cylinder_Trim\
    ;mptbladdr 0x0B5D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl3TrimValueForPurgeVolume
    ;mptblcname CLTRP3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xDB                       ;Point 1
;.org 0x82AC
T_Cyl4TrimValueForPurgeVolume:
    ;mpgrp Fuel_-_Individual_Cylinder_Trim\
    ;mptbladdr 0x0B69
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl4TrimValueForPurgeVolume
    ;mptblcname CLTRP4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x84                       ;Point 1
;.org 0x82AD
T_DisableAcBelowThisRPM_500:
    ;mpgrp AC_Control\
    ;mptbladdr 0x0B75
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DisableAcBelowThisRPM_500
    ;mptblcname ACLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0FA0                     ;Point 1
;.org 0x82AF
T_DeltaAboveMinThrottleToCutOutAc:
    ;mpgrp AC_Control\
    ;mptbladdr 0x0B81
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaAboveMinThrottleToCutOutAc
    ;mptblcname ACOUT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x85                       ;Point 1
;.org 0x82B0
T_DoNotAllowAcToEngageAboveThisRPM_4000:
    ;mpgrp AC_Control\
    ;mptbladdr 0x0B8D
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DoNotAllowAcToEngageAboveThisRPM_4000
    ;mptblcname ACCRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x7D00                     ;Point 1
;.org 0x82B2
T_AcDelayFromStartRunTransfer:
    ;mpgrp AC_Control\
    ;mptbladdr 0x0B99
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcDelayFromStartRunTransfer
    ;mptblcname ACCTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1
;.org 0x82B3
T_ACCounterInitial:
    ;mpgrp AC_Control\
    ;mptbladdr 0x0BA5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ACCounterInitial
    ;mptblcname ACCNTI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x06                       ;Point 1
;.org 0x82B4
T_DeltaThrottleFrom_MINTHR_ToUnloadCrankingFuel:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x0BB1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaThrottleFrom_MINTHR_ToUnloadCrankingFuel
    ;mptblcname UNLOAD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x85                       ;Point 1
;.org 0x82B5
T_CruiseControlVacRegularGainGurve_FromDeltaSpeed:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0BBD
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
;.org 0x82C8
T_t82C8x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0BCE
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t82C8x
    ;mptblcname T82C8X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x82CC
T_CruiseControlVacAcceleratedGainCurve_FromDeltaSpeed:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0BDA
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
;.org 0x82D7
T_t82D7x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0BE9
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t82D7x
    ;mptblcname T82D7X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x82DB
T_CruiseControlVentRegularGainCurve_FromDeltaSpeed:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0BF5
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlVentRegularGainCurve_FromDeltaSpeed
    ;mptblcname VENTRG
    ;mpxaxis Delta_Speed 0 127 mph
    ;mpyaxis AccRate 0 5 mph/sec
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Number of points in table
    .byte 0x00, 0x01, 0xFF, 0xFB     ;Point 1
    .byte 0x33, 0x00, 0x00, 0x00     ;Point 2
    .byte 0x40, 0x00, 0xFF, 0xED     ;Point 3
    .byte 0xFF, 0xF2                 ;Point 4
;.org 0x82EA
T_UnknownTableForCruiseControl1:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0C05
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname UnknownTableForCruiseControl1
    ;mptblcname CRUZ1
    ;mpxaxis in 0 255 in
    ;mpyaxis out 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Number of points in table
    .byte 0x00, 0xFE, 0xFF, 0xF0     ;Point 1
    .byte 0x40, 0xFA, 0xFF, 0xDD     ;Point 2
    .byte 0xA0, 0xED, 0xFF, 0xB0     ;Point 3
    .byte 0xFD, 0xD0                 ;Point 4
;.org 0x82F9
T_UnknownTableForCruiseControl2:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0C15
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname UnknownTableForCruiseControl2
    ;mptblcname CRUZ2
    ;mpxaxis in 0 255 in
    ;mpyaxis out 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x98, 0x01, 0x00, 0x30     ;Point 1
    .byte 0xCD, 0x0B                 ;Point 2
;.org 0x8300
T_t8300x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0C23
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8300x
    ;mptblcname T8300X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x8304
T_UnknownTableForCruiseControl3:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0C2F
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname UnknownTableForCruiseControl3
    ;mptblcname CRUZ3
    ;mpxaxis in 0 255 in
    ;mpyaxis out 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x78, 0x80, 0x03, 0xF8     ;Point 1
    .byte 0x98, 0xFF                 ;Point 2
;.org 0x830B
T_t830Bx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0C3D
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t830Bx
    ;mptblcname T830BX
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x830F
T_UnknownTableForCruiseControl4:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0C49
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname UnknownTableForCruiseControl4
    ;mptblcname CRUZ4
    ;mpxaxis in 0 255 in
    ;mpyaxis out 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x2D, 0x04, 0xFF, 0xF1     ;Point 1
    .byte 0x60, 0x01                 ;Point 2
;.org 0x8316
T_t8316x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0C57
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8316x
    ;mptblcname T8316X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x831A
T_UnknownTableForCruiseControl5:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0C63
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname UnknownTableForCruiseControl5
    ;mptblcname CRUZ5
    ;mpxaxis in 0 255 in
    ;mpyaxis out 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x68, 0xFF, 0xFA, 0x08     ;Point 1
    .byte 0x88, 0x40                 ;Point 2
;.org 0x8321
T_t8321x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0C71
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8321x
    ;mptblcname T8321X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x8325
T_CruiseControlSetupPulseForSet_FromSpeed:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0C7D
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlSetupPulseForSet_FromSpeed
    ;mptblcname SETPW
    ;mpxaxis Speed 0 128 mph
    ;mpyaxis Vacuum 0 2.8 Pulsewidth
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x46, 0x25, 0x00, 0x3C     ;Point 1
    .byte 0x82, 0x33, 0x00, 0x26     ;Point 2
    .byte 0xAA, 0x39                 ;Point 3
;.org 0x8330
T_t8330x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0C8C
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8330x
    ;mptblcname T8330X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x8334
T_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0C98
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference
    ;mptblcname RESTBL
    ;mpxaxis Speed 0 128 mph
    ;mpyaxis Vacuum -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x06                       ;Number of points in table
    .byte 0x13, 0x66, 0x00, 0x68     ;Point 1
    .byte 0x53, 0x80, 0x00, 0x6E     ;Point 2
    .byte 0x6F, 0x8C, 0x02, 0x33     ;Point 3
    .byte 0x79, 0xA2, 0x00, 0x00     ;Point 4
    .byte 0x9A, 0xA2, 0xFD, 0x40     ;Point 5
    .byte 0xA2, 0x8C                 ;Point 6
;.org 0x834B
T_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference2:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0CAB
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference2
    ;mptblcname RESTBL2
    ;mpxaxis Speed 0 128 mph
    ;mpyaxis Vacuum 0 2.8 Pulsewidth
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Number of points in table
    .byte 0x70, 0x77, 0x00, 0x90     ;Point 1
    .byte 0x80, 0x80, 0x00, 0x80     ;Point 2
    .byte 0x94, 0x8A, 0x00, 0x1C     ;Point 3
    .byte 0xEE, 0x94                 ;Point 4
;.org 0x835A
T_t835Ax:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0CBB
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t835Ax
    ;mptblcname T835AX
    ;mpxaxis Xinput 16 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
    .byte 0xFF                       ;Point 13
    .byte 0xFF                       ;Point 14
    .byte 0xFF                       ;Point 15
    .byte 0xFF                       ;Point 16
;.org 0x836A
T_CruiseControlThrottleGainFactor_FromThrottle:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0CC7
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
;.org 0x8371
T_t8371x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0CD5
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8371x
    ;mptblcname T8371X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x8375
T_CruiseControlSpeedGainFactor_FromSpeed:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0CE1
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlSpeedGainFactor_FromSpeed
    ;mptblcname SPGAIN
    ;mpxaxis Speed 0 128 mph
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x3C, 0x16, 0xFF, 0xEA     ;Point 1
    .byte 0x82, 0x10                 ;Point 2
;.org 0x837C
T_t837Cx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0CEF
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t837Cx
    ;mptblcname T837CX
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x8380
T_UnknownTableForCruiseControl6:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0CFB
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname UnknownTableForCruiseControl6
    ;mptblcname CRUZ6
    ;mpxaxis in 0 255 in
    ;mpyaxis out 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x04                 ;Point 1
;.org 0x8383
T_t8383x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0D08
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8383x
    ;mptblcname T8383X
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x838B
T_UnknownTableForCruiseControl7:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0D14
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownTableForCruiseControl7
    ;mptblcname CRUZ7
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1
;.org 0x838C
T_CruiseControlLimitToAMaxVent:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0D20
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlLimitToAMaxVent
    ;mptblcname VNTAB1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x90                       ;Point 1
;.org 0x838D
T_CruiseControlLimitToHalfMaxVent:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0D2C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlLimitToHalfMaxVent
    ;mptblcname VNTAB2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x60                       ;Point 1
;.org 0x838E
T_UnknownConstForCruiseControl46:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0D38
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownConstForCruiseControl46
    ;mptblcname CRUZ46
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1
;.org 0x838F
T_UnknownConstForCruiseControl47:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0D44
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownConstForCruiseControl47
    ;mptblcname CRUZ47
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x2F                       ;Point 1
;.org 0x8390
T_CruiseControlDeltaSpeedToResetAccFlag:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0D50
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlDeltaSpeedToResetAccFlag
    ;mptblcname ACLRST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaSpeed 0 127 mph
    ;mptbldesc Detailed_Description
    .byte 0x09                       ;Point 1
;.org 0x8391
T_CruiseControlDontVentIfThrottleBelowThis:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0D5C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlDontVentIfThrottleBelowThis
    ;mptblcname CLOTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1
;.org 0x8392
T_CruiseControlDontVacIfThrottleAboveThis:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0D68
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlDontVacIfThrottleAboveThis
    ;mptblcname MAXTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x66                       ;Point 1
;.org 0x8393
T_CruiseControlMaxSetSpeedTimesTwo:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0D74
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlMaxSetSpeedTimesTwo
    ;mptblcname MAXSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 128 MPH
    ;mptbldesc Detailed_Description
    .byte 0xAA                       ;Point 1
;.org 0x8394
T_CruiseControlMinSetSpeedTimesTwo:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0D80
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlMinSetSpeedTimesTwo
    ;mptblcname MINSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 128 MPH
    ;mptbldesc Detailed_Description
    .byte 0x46                       ;Point 1
;.org 0x8395
T_CruiseControlForBrakeFlagManualTransmissionClutchDisableHi:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0D8C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlForBrakeFlagManualTransmissionClutchDisableHi
    ;mptblcname SCNVHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xF1                       ;Point 1
;.org 0x8396
T_CruiseControlForBrakeFlagManualTransmissionClutchDisableLo:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0D98
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlForBrakeFlagManualTransmissionClutchDisableLo
    ;mptblcname SCNVLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x52                       ;Point 1
;.org 0x8397
T_UnknownConstForCruiseControl21:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0DA4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownConstForCruiseControl21
    ;mptblcname CRUZ21
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x3C                       ;Point 1
;.org 0x8398
T_UnknownConstForCruiseControl22:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0DB0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownConstForCruiseControl22
    ;mptblcname CRUZ22
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xBC                       ;Point 1
;.org 0x8399
T_UnknownConstForCruiseControl23:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0DBC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownConstForCruiseControl23
    ;mptblcname CRUZ23
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x08                       ;Point 1
;.org 0x839A
T_UnknownConstForCruiseControl2x:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0DC8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownConstForCruiseControl2x
    ;mptblcname CRUZ2X
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1
;.org 0x839B
T_UnknownConstForCruiseControl2y:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0DD4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownConstForCruiseControl2y
    ;mptblcname CRUZ2Y
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xBA                       ;Point 1
;.org 0x839C
T_UnknownConstForCruiseControl24:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0DE0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownConstForCruiseControl24
    ;mptblcname CRUZ24
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1
;.org 0x839D
T_UnknownConstForCruiseControl25:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0DEC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownConstForCruiseControl25
    ;mptblcname CRUZ25
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x30                       ;Point 1
;.org 0x839E
T_UnknownConstForCruiseControl26:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0DF8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownConstForCruiseControl26
    ;mptblcname CRUZ26
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1
;.org 0x839F
T_UnknownConstForCruiseControl27:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0E04
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownConstForCruiseControl27
    ;mptblcname CRUZ27
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1
;.org 0x83A0
T_UnknownConstForCruiseControl28:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0E10
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownConstForCruiseControl28
    ;mptblcname CRUZ28
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1
;.org 0x83A1
T_UnknownConstForCruiseControl29:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0E1C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownConstForCruiseControl29
    ;mptblcname CRUZ29
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1
;.org 0x83A2
T_UnknownConstForCruiseControl30:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0E28
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownConstForCruiseControl30
    ;mptblcname CRUZ30
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1
;.org 0x83A3
T_UnknownConstForCruiseControl31:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0E34
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownConstForCruiseControl31
    ;mptblcname CRUZ31
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x4D                       ;Point 1
;.org 0x83A4
T_UnknownConstForCruiseControl32:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0E40
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownConstForCruiseControl32
    ;mptblcname CRUZ32
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x08                       ;Point 1
;.org 0x83A5
T_UnknownConstForCruiseControl33:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0E4C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownConstForCruiseControl33
    ;mptblcname CRUZ33
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1
;.org 0x83A6
T_UnknownConstForCruiseControl34:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0E58
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownConstForCruiseControl34
    ;mptblcname CRUZ34
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x20                       ;Point 1
;.org 0x83A7
T_UnknownConstForCruiseControl35:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0E64
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownConstForCruiseControl35
    ;mptblcname CRUZ35
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x15                       ;Point 1
;.org 0x83A8
T_UnknownConstForCruiseControl36:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0E70
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownConstForCruiseControl36
    ;mptblcname CRUZ36
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x8C                       ;Point 1
;.org 0x83A9
T_CruiseControlSetDeltaControlPointForCableAdaptive:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0E7C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlSetDeltaControlPointForCableAdaptive
    ;mptblcname SETDLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1
;.org 0x83AA
T_CruiseComapreConstant2:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0E88
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseComapreConstant2
    ;mptblcname CRSCN2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x06                       ;Point 1
;.org 0x83AB
T_CruiseMask2:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0E94
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask2
    ;mptblcname CRMSK2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x07                       ;Point 1
;.org 0x83AC
T_CruiseMask3:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0EA0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask3
    ;mptblcname CRMSK3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xF4                       ;Point 1
;.org 0x83AD
T_CruiseMask7:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0EAC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask7
    ;mptblcname CRMSK7
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1
;.org 0x83AE
T_CruiseMask4:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0EB8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask4
    ;mptblcname CRMSK4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1
;.org 0x83AF
T_CruiseMask6:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0EC4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask6
    ;mptblcname CRMSK6
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x1F                       ;Point 1
;.org 0x83B0
T_CruiseMask5:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0ED0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask5
    ;mptblcname CRMSK5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xE1                       ;Point 1
;.org 0x83B1
T_CruiseComapreConstant1:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0EDC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseComapreConstant1
    ;mptblcname CRSCN1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x16                       ;Point 1
;.org 0x83B2
T_CruiseMask:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0EE8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask
    ;mptblcname CRMASK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x11                       ;Point 1
;.org 0x83B3
T_PTUMinLockTemperature:
    ;mpgrp PTU_Control\
    ;mptbladdr 0x0EF4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUMinLockTemperature
    ;mptblcname PTUMTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc Min_temp_for_PTU_lock
    .byte 0xC1                       ;Point 1
;.org 0x83B4
T_PTUMinLockSpeed:
    ;mpgrp PTU_Control\
    ;mptbladdr 0x0F00
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUMinLockSpeed
    ;mptblcname PTUMSP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 128 MPH
    ;mptbldesc Min_Speed_for_PTU_lock
    .byte 0x5A                       ;Point 1
;.org 0x83B5
T_PTUCounterHiSpeed:
    ;mpgrp PTU_Control\
    ;mptbladdr 0x0F0C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUCounterHiSpeed
    ;mptblcname PTUCNH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x5D                       ;Point 1
;.org 0x83B6
T_PTUCounterLoSpeed:
    ;mpgrp PTU_Control\
    ;mptbladdr 0x0F18
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUCounterLoSpeed
    ;mptblcname PTUCNL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xB9                       ;Point 1
;.org 0x83B7
T_PTUDeltaTPSForUnlock:
    ;mpgrp PTU_Control\
    ;mptbladdr 0x0F24
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUDeltaTPSForUnlock
    ;mptblcname PTUDTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Delta_TPS 0 5 V
    ;mptbldesc Min_TPS_for_PTU_unlock
    .byte 0x29                       ;Point 1
;.org 0x83B8
T_PTUMAPThresholdForLock1:
    ;mpgrp PTU_Control\
    ;mptbladdr 0x0F30
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname PTUMAPThresholdForLock1
    ;mptblcname PTUMP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Delta_MAP 0 29.4 PSI
    ;mptbldesc Delta_MAP_for_PTU_unlock
    ;mpmapaxis y
    .byte 0x20                       ;Point 1
;.org 0x83B9
T_DeltaMAPForCruiseTPSAccel2:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x0F3D
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMAPForCruiseTPSAccel2
    ;mptblcname DM2CAC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis deltaMAP 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x1D                       ;Point 1
;.org 0x83BA
T_PTUMAPThresholdForLock3:
    ;mpgrp PTU_Control\
    ;mptbladdr 0x0F4A
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname PTUMAPThresholdForLock3
    ;mptblcname PTUMP3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Delta_MAP 0 29.4 PSI
    ;mptbldesc Delta_MAP_for_PTU_unlock
    ;mpmapaxis y
    .byte 0x19                       ;Point 1
;.org 0x83BB
T_PTUDeltaMAPSampleCounter:
    ;mpgrp PTU_Control\
    ;mptbladdr 0x0F57
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUDeltaMAPSampleCounter
    ;mptblcname DMSCNT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x07                       ;Point 1
;.org 0x83BC
T_PrimaryPTUEngagement:
    ;mpgrp PTU_Control\
    ;mptbladdr 0x0F63
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname PrimaryPTUEngagement
    ;mptblcname PRPTUE
    ;mpxaxis Speed 0 128 mph
    ;mpyaxis Delta_TPS 0 5 Volts
    ;mptbldesc Primary_engagnement_point_for_PTU
    .byte 0x03                       ;Number of points in table
    .byte 0x4C, 0x12, 0x06, 0x00     ;Point 1
    .byte 0x5A, 0x66, 0x00, 0xAD     ;Point 2
    .byte 0x82, 0x81                 ;Point 3
;.org 0x83C7
T_t83C7x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0F72
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t83C7x
    ;mptblcname T83C7X
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x83CF
T_PrimaryPTUDisengagement:
    ;mpgrp PTU_Control\
    ;mptbladdr 0x0F7E
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname PrimaryPTUDisengagement
    ;mptblcname PRPTUD
    ;mpxaxis Speed 0 128 mph
    ;mpyaxis Delta_TPS 0 5 Volts
    ;mptbldesc Primary_disengagnement_point_for_PTU
    .byte 0x02                       ;Number of points in table
    .byte 0x4C, 0x12, 0xFF, 0x7B     ;Point 1
    .byte 0x67, 0x04                 ;Point 2
;.org 0x83D6
T_t83D6x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0F8C
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t83D6x
    ;mptblcname T83D6X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x83DA
T_SecondaryPTUEngagement:
    ;mpgrp PTU_Control\
    ;mptbladdr 0x0F98
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname SecondaryPTUEngagement
    ;mptblcname SRPTUE
    ;mpxaxis Speed 0 128 mph
    ;mpyaxis Delta_TPS 0 5 Volts
    ;mptbldesc Secondary_engagnement_point_for_PTU
    .byte 0x02                       ;Number of points in table
    .byte 0x50, 0x12, 0x00, 0xD3     ;Point 1
    .byte 0x72, 0x2E                 ;Point 2
;.org 0x83E1
T_t83E1x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0FA6
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t83E1x
    ;mptblcname T83E1X
    ;mpxaxis Xinput 12 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
;.org 0x83ED
T_SecondaryPTUDisengagement:
    ;mpgrp PTU_Control\
    ;mptbladdr 0x0FB2
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname SecondaryPTUDisengagement
    ;mptblcname SRPTUD
    ;mpxaxis Speed 0 128 mph
    ;mpyaxis Delta_TPS 0 5 Volts
    ;mptbldesc Secondary_disengagnement_point_for_PTU
    .byte 0x02                       ;Number of points in table
    .byte 0x50, 0x12, 0xFF, 0x7A     ;Point 1
    .byte 0x67, 0x06                 ;Point 2
;.org 0x83F4
T_t83F4x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x0FC0
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t83F4x
    ;mptblcname T83F4X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x83F8
T_Amount_MINTHR_IsIncreasedAtKeyOnOnly:
    ;mpgrp OB____Speed____and_Rev_Limiter\
    ;mptbladdr 0x0FCC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Amount_MINTHR_IsIncreasedAtKeyOnOnly
    ;mptblcname MININC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Point 1
;.org 0x83F9
T_ThrottleSelfCalibrationMapDeltaThreshold:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x0FD8
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname ThrottleSelfCalibrationMapDeltaThreshold
    ;mptblcname MAPTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x31                       ;Point 1
;.org 0x83FA
T_ThrottleSelfCalibrationRpmThreshold:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x0FE5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleSelfCalibrationRpmThreshold
    ;mptblcname RPMTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x30                       ;Point 1
;.org 0x83FB
T_ValueOf_MINTHR_WhenBatteryDisconnected:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x0FF1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ValueOf_MINTHR_WhenBatteryDisconnected
    ;mptblcname MTHRMX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x5C                       ;Point 1
;.org 0x83FC
T_ProgramLoopsWithThrottleBelow_MINTHR_ToDecrement_MINTHR:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x0FFD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ProgramLoopsWithThrottleBelow_MINTHR_ToDecrement_MINTHR
    ;mptblcname MAXCNT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1
;.org 0x83FD
T_NumberOfBitsAbove_MINTHR_ToDetermineOnThrottleTransition:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x1009
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NumberOfBitsAbove_MINTHR_ToDetermineOnThrottleTransition
    ;mptblcname MTHRCL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1
;.org 0x83FE
T_NumberOfBitsAbove_MINTHR_ToDetermineOffThrottleTransition:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x1015
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NumberOfBitsAbove_MINTHR_ToDetermineOffThrottleTransition
    ;mptblcname MTHROP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1
;.org 0x83FF
T_ExhGasRecircConst1:
    ;mpgrp EGR\
    ;mptbladdr 0x1021
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst1
    ;mptblcname EGR1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x01D1                     ;Point 1
;.org 0x8401
T_ExhGasRecircConst3:
    ;mpgrp EGR\
    ;mptbladdr 0x102D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst3
    ;mptblcname EGR3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x80                       ;Point 1
;.org 0x8402
T_ExhGasRecircConstLoLimit18:
    ;mpgrp EGR\
    ;mptbladdr 0x1039
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstLoLimit18
    ;mptblcname EGR18
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1
;.org 0x8403
T_ExhGasRecircConstHiLimit18a:
    ;mpgrp EGR\
    ;mptbladdr 0x1045
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstHiLimit18a
    ;mptblcname EGRR18A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1
;.org 0x8404
T_ExhGasRecircConstLoLimit16:
    ;mpgrp EGR\
    ;mptbladdr 0x1051
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstLoLimit16
    ;mptblcname EGR16
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1
;.org 0x8405
T_ExhGasRecircConstHiLimit16a:
    ;mpgrp EGR\
    ;mptbladdr 0x105D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstHiLimit16a
    ;mptblcname EGR16A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1
;.org 0x8406
T_ExhGasRecircConstFromTPSVoltsLoLimit14:
    ;mpgrp EGR\
    ;mptbladdr 0x1069
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromTPSVoltsLoLimit14
    ;mptblcname EGR14
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0C                       ;Point 1
;.org 0x8407
T_ExhGasRecircConstFromTPSVoltsHiLimit14a:
    ;mpgrp EGR\
    ;mptbladdr 0x1075
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromTPSVoltsHiLimit14a
    ;mptblcname EGR14A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x18                       ;Point 1
;.org 0x8408
T_ExhGasRecircConstLoLimit19:
    ;mpgrp EGR\
    ;mptbladdr 0x1081
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstLoLimit19
    ;mptblcname EGR19
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0F                       ;Point 1
;.org 0x8409
T_ExhGasRecircConstHiLimit19a:
    ;mpgrp EGR\
    ;mptbladdr 0x108D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstHiLimit19a
    ;mptblcname EGR19A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x15                       ;Point 1
;.org 0x840A
T_ExhGasRecircConstFromRPMLoLimit15:
    ;mpgrp EGR\
    ;mptbladdr 0x1099
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromRPMLoLimit15
    ;mptblcname EGR15
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1
;.org 0x840B
T_ExhGasRecircConstLoLimit17:
    ;mpgrp EGR\
    ;mptbladdr 0x10A5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstLoLimit17
    ;mptblcname EGR17
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1
;.org 0x840C
T_ExhGasRecircConstHiLimit17a:
    ;mpgrp EGR\
    ;mptbladdr 0x10B1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstHiLimit17a
    ;mptblcname EGR17A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1
;.org 0x840D
T_t840Dx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x10BD
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t840Dx
    ;mptblcname T840DX
    ;mpxaxis Xinput 1 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
;.org 0x840E
T_ExhGasRecircConst4:
    ;mpgrp EGR\
    ;mptbladdr 0x10C9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst4
    ;mptblcname EGR4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xEB                       ;Point 1
;.org 0x840F
T_ExhGasRecircConst5:
    ;mpgrp EGR\
    ;mptbladdr 0x10D5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst5
    ;mptblcname EGR5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1
;.org 0x8410
T_ExhGasRecircConst6:
    ;mpgrp EGR\
    ;mptbladdr 0x10E1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst6
    ;mptblcname EGR6
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1
;.org 0x8411
T_ExhGasRecircConstFromRPMHiLimit15a:
    ;mpgrp EGR\
    ;mptbladdr 0x10ED
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromRPMHiLimit15a
    ;mptblcname EGR15A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x74                       ;Point 1
;.org 0x8412
T_ExhGasRecircConst7:
    ;mpgrp EGR\
    ;mptbladdr 0x10F9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst7
    ;mptblcname EGR7
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1
;.org 0x8413
T_SecondaryRampSubtractor1:
    ;mpgrp EGR\
    ;mptbladdr 0x1105
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SecondaryRampSubtractor1
    ;mptblcname SCRMP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1
;.org 0x8414
T_ValueFromAdaptivememoryAdder1:
    ;mpgrp EGR\
    ;mptbladdr 0x1111
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ValueFromAdaptivememoryAdder1
    ;mptblcname ADMEMA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1
;.org 0x8415
T_ExhGasRecircConst8:
    ;mpgrp EGR\
    ;mptbladdr 0x111D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst8
    ;mptblcname EGR8
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x81                       ;Point 1
;.org 0x8416
T_ExhGasRecircConst8a:
    ;mpgrp EGR\
    ;mptbladdr 0x1129
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst8a
    ;mptblcname EGR8A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1
;.org 0x8417
T_ExhGasRecircConstFromMAPBelowBaro2:
    ;mpgrp EGR\
    ;mptbladdr 0x1135
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname ExhGasRecircConstFromMAPBelowBaro2
    ;mptblcname EGR2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x0D                       ;Point 1
;.org 0x8418
T_ExhGasRecircConstFromTimeEngRunning9:
    ;mpgrp EGR\
    ;mptbladdr 0x1142
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromTimeEngRunning9
    ;mptblcname EGR9
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x83                       ;Point 1
;.org 0x8419
T_ExhGasRecircConstFromRPM1:
    ;mpgrp EGR\
    ;mptbladdr 0x114E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromRPM1
    ;mptblcname EGR21
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFE                       ;Point 1
;.org 0x841A
T_ExhGasRecircConstFromRPM2:
    ;mpgrp EGR\
    ;mptbladdr 0x115A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromRPM2
    ;mptblcname EGR22
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1
;.org 0x841B
T_ExhGasRecircConstFromMAP1:
    ;mpgrp EGR\
    ;mptbladdr 0x1166
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname ExhGasRecircConstFromMAP1
    ;mptblcname EGR23
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0xEE                       ;Point 1
;.org 0x841C
T_ExhGasRecircConstFromMAP2:
    ;mpgrp EGR\
    ;mptbladdr 0x1173
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname ExhGasRecircConstFromMAP2
    ;mptblcname EGR24
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x01                       ;Point 1
;.org 0x841D
T_ExhGasRecircConstFromBaro1:
    ;mpgrp EGR\
    ;mptbladdr 0x1180
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname ExhGasRecircConstFromBaro1
    ;mptblcname EGR25
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1
;.org 0x841E
T_ExhGasRecircConstFromBaro2:
    ;mpgrp EGR\
    ;mptbladdr 0x118D
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname ExhGasRecircConstFromBaro2
    ;mptblcname EGR26
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x01                       ;Point 1
;.org 0x841F
T_ExhGasRecircConstFromCoolantTemp:
    ;mpgrp EGR\
    ;mptbladdr 0x119A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromCoolantTemp
    ;mptblcname EGR27
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x82                       ;Point 1
;.org 0x8420
T_LimpinTableForMapFromThrottle:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x11A6
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
;.org 0x8433
T_t8433x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x11B8
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8433x
    ;mptblcname T8433X
    ;mpxaxis Xinput 5 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0x20                       ;Point 5
;.org 0x8438
T_OffsetAddedToCalcThrottle:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x11C4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OffsetAddedToCalcThrottle
    ;mptblcname THROFF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0B                       ;Point 1
;.org 0x8439
T_OffsetForMAPOverIdle:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x11D0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OffsetForMAPOverIdle
    ;mptblcname OFSMID
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1
;.org 0x843A
T_t843Ax:
    ;mpgrp Unassigned\
    ;mptbladdr 0x11DC
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t843Ax
    ;mptblcname T843AX
    ;mpxaxis Xinput 37 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0x02                       ;Point 1
    .byte 0xBC                       ;Point 2
    .byte 0x01                       ;Point 3
    .byte 0xBC                       ;Point 4
    .byte 0x01                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0x7F                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
    .byte 0xFF                       ;Point 13
    .byte 0xFF                       ;Point 14
    .byte 0xFF                       ;Point 15
    .byte 0x01                       ;Point 16
    .byte 0xFF                       ;Point 17
    .byte 0x7F                       ;Point 18
    .byte 0xFF                       ;Point 19
    .byte 0xFF                       ;Point 20
    .byte 0xFF                       ;Point 21
    .byte 0xFF                       ;Point 22
    .byte 0xFF                       ;Point 23
    .byte 0xFF                       ;Point 24
    .byte 0xFF                       ;Point 25
    .byte 0xFF                       ;Point 26
    .byte 0x01                       ;Point 27
    .byte 0xFF                       ;Point 28
    .byte 0x00                       ;Point 29
    .byte 0xFF                       ;Point 30
    .byte 0xFF                       ;Point 31
    .byte 0xFF                       ;Point 32
    .byte 0xFF                       ;Point 33
    .byte 0xFF                       ;Point 34
    .byte 0xFF                       ;Point 35
    .byte 0xFF                       ;Point 36
    .byte 0xFF                       ;Point 37
;.org 0x845F
T_ConvertChargeTempToCoolantTemp:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x11EA
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ConvertChargeTempToCoolantTemp
    ;mptblcname COOLXF
    ;mpxaxis ChargeTemp -200 260 F
    ;mpyaxis CoolantTemp -200 260 F
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x9D                 ;Point 1
;.org 0x8462
T_t8462x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x11F7
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8462x
    ;mptblcname T8462X
    ;mpxaxis Xinput 12 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
;.org 0x846E
T_ConvertCoolantTempToChargeTemp:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1203
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ConvertCoolantTempToChargeTemp
    ;mptblcname CHRGXF
    ;mpxaxis CoolantTemp -200 260 F
    ;mpyaxis ChargeTemp -200 260 F
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x9D                 ;Point 1
;.org 0x8471
T_t8471x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1210
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8471x
    ;mptblcname T8471X
    ;mpxaxis Xinput 12 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
;.org 0x847D
T_OffsetForCalcMapInMapLimpin:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x121C
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname OffsetForCalcMapInMapLimpin
    ;mptblcname MPLMOF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x20                 ;Point 1
;.org 0x8480
T_t8480x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x122A
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8480x
    ;mptblcname T8480X
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x8488
T_OffsetSubtractedFromCalcMAP:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1236
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname OffsetSubtractedFromCalcMAP
    ;mptblcname BAROFF
    ;mpxaxis Baro -14.7 14.7 psi
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis x
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1
;.org 0x848B
T_t848Bx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1244
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t848Bx
    ;mptblcname T848BX
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x8493
T_OutOfRangeHotTooLowA2D:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1250
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OutOfRangeHotTooLowA2D
    ;mptblcname TMPLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x1A                       ;Point 1
;.org 0x8494
T_OutOfRangeColdTooHighA2D:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x125C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OutOfRangeColdTooHighA2D
    ;mptblcname TMPHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFD                       ;Point 1
;.org 0x8495
T_DefaultEngineTemp:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1268
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DefaultEngineTemp
    ;mptblcname DEFTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x95                       ;Point 1
;.org 0x8496
T_LowBatteryVoltageAtThisRpm1500_dup:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1274
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowBatteryVoltageAtThisRpm1500_dup
    ;mptblcname BTLRPMX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x2E                       ;Point 1
;.org 0x8497
T_LowBatteryVoltageAtThisCoolantTemp:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1280
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowBatteryVoltageAtThisCoolantTemp
    ;mptblcname CTLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xCD                       ;Point 1
;.org 0x8498
T_LowBatteryVoltageAtThisRpm1500_2:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x128C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowBatteryVoltageAtThisRpm1500_2
    ;mptblcname BTLRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x2E                       ;Point 1
;.org 0x8499
T_BattTempLowWhenHot:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1298
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BattTempLowWhenHot
    ;mptblcname AMBLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Point 1
;.org 0x849A
T_BattTempHighWhenCold:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x12A4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BattTempHighWhenCold
    ;mptblcname AMBHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xF9                       ;Point 1
;.org 0x849B
T_ChargeTempOutOfRangeLow:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x12B0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ChargeTempOutOfRangeLow
    ;mptblcname CHGLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x1A                       ;Point 1
;.org 0x849C
T_ChargeTempOutOfRangeHigh:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x12BC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ChargeTempOutOfRangeHigh
    ;mptblcname CHGHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFD                       ;Point 1
;.org 0x849D
T_DefaultChargeTemp_Limpin:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x12C8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DefaultChargeTemp_Limpin
    ;mptblcname DEFCHG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x95                       ;Point 1
;.org 0x849E
T_RPMLimitforErrorCodeSetting:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x12D4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimitforErrorCodeSetting
    ;mptblcname ERRRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x38                       ;Point 1
;.org 0x849F
T_MAPLimitforErrorCodeSetting:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x12E0
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MAPLimitforErrorCodeSetting
    ;mptblcname ERRMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x2B                       ;Point 1
;.org 0x84A0
T_CoolantTempLimitforErrorCodeSetting:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x12ED
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CoolantTempLimitforErrorCodeSetting
    ;mptblcname ERRTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xA0                       ;Point 1
;.org 0x84A1
T_ThrottleLowerLimit:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x12F9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleLowerLimit
    ;mptblcname THRLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x08                       ;Point 1
;.org 0x84A2
T_ThrottleUpperLimit:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1305
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleUpperLimit
    ;mptblcname THRHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xE4                       ;Point 1
;.org 0x84A3
T_MapSwitchPointForFullThrottleOrIdle:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1311
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MapSwitchPointForFullThrottleOrIdle
    ;mptblcname MPTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x68                       ;Point 1
;.org 0x84A4
T_LoLimitBatteryVoltsForCoilVerify:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x131E
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname LoLimitBatteryVoltsForCoilVerify
    ;mptblcname COILLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x05                       ;Point 1
;.org 0x84A5
T_HiLimitBatteryVoltsForCoilVerify:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x132B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HiLimitBatteryVoltsForCoilVerify
    ;mptblcname COILHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xBA                       ;Point 1
;.org 0x84A6
T_MapSensorLowerLimit:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1337
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapSensorLowerLimit
    ;mptblcname MAPLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1
;.org 0x84A7
T_MapSensorUpperLimit:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1343
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapSensorUpperLimit
    ;mptblcname MAPHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xEE                       ;Point 1
;.org 0x84A8
T_ThrottleLevelAbove_MINTHR_ToMatureMapLimpin:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x134F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleLevelAbove_MINTHR_ToMatureMapLimpin
    ;mptblcname MPLTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x42                       ;Point 1
;.org 0x84A9
T_DeltaMapThatChecksGood:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x135B
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapThatChecksGood
    ;mptblcname MPDELT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x01                       ;Point 1
;.org 0x84AA
T_MatureMapLimpinWhenDeltaAbove_MPDELT_plus_MPDELA:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1368
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MatureMapLimpinWhenDeltaAbove_MPDELT_plus_MPDELA
    ;mptblcname MPDELA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x01                       ;Point 1
;.org 0x84AB
T_DisableMapCheckUnderThisRpm_600:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1375
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DisableMapCheckUnderThisRpm_600
    ;mptblcname MPRPML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x12C0                     ;Point 1
;.org 0x84AD
T_DisableMapCheckAboveThisRpm_1500:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1381
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DisableMapCheckAboveThisRpm_1500
    ;mptblcname MPRPMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x2EE0                     ;Point 1
;.org 0x84AF
T_DisableMapCheckBelowThisMap:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x138D
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DisableMapCheckBelowThisMap
    ;mptblcname MPDAGL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x10                       ;Point 1
;.org 0x84B0
T_DisableMapCheckAboveThisMap:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x139A
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DisableMapCheckAboveThisMap
    ;mptblcname MPDAGH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x81                       ;Point 1
;.org 0x84B1
T_CheckMapAtZeroSpeedAndThisDeltaRpm:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x13A7
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname CheckMapAtZeroSpeedAndThisDeltaRpm
    ;mptblcname MPRMPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0200                     ;Point 1
;.org 0x84B3
T_CheckMapAtZeroSpeedAndThisBaroSwitch:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x13B3
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname CheckMapAtZeroSpeedAndThisBaroSwitch
    ;mptblcname BAROSW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x61                       ;Point 1
;.org 0x84B4
T_AllowMapToTestGoodThisNearBaro:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x13C0
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AllowMapToTestGoodThisNearBaro
    ;mptblcname MPVACD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x11                       ;Point 1
;.org 0x84B5
T_AllowMapToTestGoodThisNearBaro2:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x13CD
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AllowMapToTestGoodThisNearBaro2
    ;mptblcname MPVAC2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x08                       ;Point 1
;.org 0x84B6
T_DeltaMapThatChecksGoodX:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x13DA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaMapThatChecksGoodX
    ;mptblcname MPDELX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1
;.org 0x84B7
T_UnknownBytesA:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x13E6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownBytesA
    ;mptblcname UNKNOWNBYTESA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Point 1
;.org 0x84B8
T_UnknownBytesB:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x13F2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UnknownBytesB
    ;mptblcname UNKNOWNBYTESB
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xA8                       ;Point 1
;.org 0x84B9
T_InjectorPulsewidthReductionColdStart:
    ;mpgrp Fuel_-_Starting\
    ;mptbladdr 0x13FE
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname InjectorPulsewidthReductionColdStart
    ;mptblcname IPWRDX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    ;mpinjscale word
    .word 0x0000                     ;Point 1
;.org 0x84BB
T_PowerLossLightMask:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x140B
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PowerLossLightMask
    ;mptblcname IPLMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Illuminate_PowerLoss_Light_Mask1._These_errors_alert_the_driver.
    ;mpchoices ChargeTemp_Sensor  CoolantTemp_Sensor  Charging  bit3  BatVolts  Map_Signal  Tps_Signal  Map_Pneumatic
    .byte 0xE6                       ;Point 1
;.org 0x84BC
T_PowerLossLightMask2:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x1418
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PowerLossLightMask2
    ;mptblcname IPLMSK2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Illuminate_PowerLoss_Light_Mask2._These_errors_alert_the_driver.
    ;mpchoices bit0  bit1  bit2  Wastegate  InjectorFault  bit5  MajorFault  bit7
    .byte 0x37                       ;Point 1
;.org 0x84BD
T_PIAMSK_PIA1ADDRMask:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x1425
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PIAMSK_PIA1ADDRMask
    ;mptblcname PIAMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc These_flags_enable_error_reporting_on_specific_output_bits.
    ;mpchoices Cruise_Vacuum  Purge_Solenoid  Part_Throt_Unlock  AC_Clutch_Relay  Fan_Relay  ASD_Relay  CE_Light  Cruise_Vent
    .byte 0x35                       ;Point 1
;.org 0x84BE
T_PIBMSK_PIA1BDDRMask:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x1432
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PIBMSK_PIA1BDDRMask
    ;mptblcname PIBMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc These_flags_enable_error_reporting_on_specific_output_bits.
    ;mpchoices bit0  bit1  bit2  bit3  Emission_Light  Baro_Read_Solenoid  Wastegate_Solenoid  EGR_Solenoid
    .byte 0xB4                       ;Point 1
;.org 0x84BF
T_TstatDiagnosticsMinTempToArmDiagnosticsAtStartup:
    ;mpgrp Setup_-_T-Stat_Diagnostics\
    ;mptbladdr 0x143F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsMinTempToArmDiagnosticsAtStartup
    ;mptblcname TTEMPL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc Detailed_Description
    .byte 0x63                       ;Point 1
;.org 0x84C0
T_TstatDiagnosticsMaxTempToArmDiagnosticsAtStartup:
    ;mpgrp Setup_-_T-Stat_Diagnostics\
    ;mptbladdr 0x144B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsMaxTempToArmDiagnosticsAtStartup
    ;mptblcname TTEMPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc Detailed_Description
    .byte 0xE4                       ;Point 1
;.org 0x84C1
T_TstatDiagnosticsTemperatureGoalWithin_HOTIME:
    ;mpgrp Setup_-_T-Stat_Diagnostics\
    ;mptbladdr 0x1457
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsTemperatureGoalWithin_HOTIME
    ;mptblcname TDAGTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc Detailed_Description
    .byte 0xC7                       ;Point 1
;.org 0x84C2
T_TstatDiagnosticsTimeToAchieveTemperatureGoal:
    ;mpgrp Setup_-_T-Stat_Diagnostics\
    ;mptbladdr 0x1463
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsTimeToAchieveTemperatureGoal
    ;mptblcname HOTIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xAE                       ;Point 1
;.org 0x84C3
T_BatteryVoltsHysteresisForAlternatorControl_dup:
    ;mpgrp Setup_-_Alternator_Diagnostics\
    ;mptbladdr 0x146F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BatteryVoltsHysteresisForAlternatorControl_dup
    ;mptblcname BTVHYSX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1
;.org 0x84C4
T_BatteryVoltsDiagLimitOverTarget_dup:
    ;mpgrp Setup_-_Alternator_Diagnostics\
    ;mptbladdr 0x147B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BatteryVoltsDiagLimitOverTarget_dup
    ;mptblcname BTVLMTX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1
;.org 0x84C5
T_BatteryVoltsDiagCounterMax_dup:
    ;mpgrp Setup_-_Alternator_Diagnostics\
    ;mptbladdr 0x1487
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BatteryVoltsDiagCounterMax_dup
    ;mptblcname BTVCNTX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x8E                       ;Point 1
;.org 0x84C6
T_BatteryVoltsDiagCounterMin_dup:
    ;mpgrp Setup_-_Alternator_Diagnostics\
    ;mptbladdr 0x1493
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BatteryVoltsDiagCounterMin_dup
    ;mptblcname BTVCN3X
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x06                       ;Point 1
;.org 0x84C7
T_BatteryVoltsDiagCounterMax2_dup:
    ;mpgrp Setup_-_Alternator_Diagnostics\
    ;mptbladdr 0x149F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BatteryVoltsDiagCounterMax2_dup
    ;mptblcname BTVCN2X
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x7F                       ;Point 1
;.org 0x84C8
T_CounterLimitForO2SensorDiag:
    ;mpgrp Setup_-_O2_Sensor_Diagnostics\
    ;mptbladdr 0x14AB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CounterLimitForO2SensorDiag
    ;mptblcname O2DIAG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x13                       ;Point 1
;.org 0x84C9
T_LimitForO2SensorBatteryDiag:
    ;mpgrp Setup_-_O2_Sensor_Diagnostics\
    ;mptbladdr 0x14B7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LimitForO2SensorBatteryDiag
    ;mptblcname O2MID
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x4D                       ;Point 1
;.org 0x84CA
T_HighLimitForInMiddleDeterminationX:
    ;mpgrp Setup_-_O2_Sensor_Diagnostics\
    ;mptbladdr 0x14C3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForInMiddleDeterminationX
    ;mptblcname O2MIDX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x3E                       ;Point 1
;.org 0x84CB
T_MinTimeEngineRunningForDecelFuelShutoff:
    ;mpgrp Decel_Fuel_Shutoff\
    ;mptbladdr 0x14CF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinTimeEngineRunningForDecelFuelShutoff
    ;mptblcname DCLMER
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1
;.org 0x84CC
T_MinCoolantTempForDecelFuelShutoff:
    ;mpgrp Decel_Fuel_Shutoff\
    ;mptbladdr 0x14DB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinCoolantTempForDecelFuelShutoff
    ;mptblcname DCLMCT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1
;.org 0x84CD
T_EngineRPMLimitForDecelFuelShutoffHigh:
    ;mpgrp Decel_Fuel_Shutoff\
    ;mptbladdr 0x14E7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineRPMLimitForDecelFuelShutoffHigh
    ;mptblcname DCLRPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc High_RPM_to_activate_decel_fuel_shutoff._Should_be_lower_than_shutoff_RPM_Off_point.
    .byte 0x1E                       ;Point 1
;.org 0x84CE
T_EngineRPMLimitForDecelFuelShutoffLow:
    ;mpgrp Decel_Fuel_Shutoff\
    ;mptbladdr 0x14F3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineRPMLimitForDecelFuelShutoffLow
    ;mptblcname DCLRPL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Low_RPM_to_activate_decel_fuel_shutoff._Should_be_lower_than_shutoff_RPM_On_point.
    .byte 0x0F                       ;Point 1
;.org 0x84CF
T_AISIncrementWhenUsingDecelFuelShut:
    ;mpgrp Decel_Fuel_Shutoff\
    ;mptbladdr 0x14FF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AISIncrementWhenUsingDecelFuelShut
    ;mptblcname DCAISI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc AIS_Increment_for_recovery_from_decel_fuel_shutoff.
    .byte 0x00                       ;Point 1
;.org 0x84D0
T_DecelFuelShutoffDeltaRPMOff:
    ;mpgrp Decel_Fuel_Shutoff\
    ;mptbladdr 0x150B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DecelFuelShutoffDeltaRPMOff
    ;mptblcname DFRPMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPMOverIdle 0 8192 rpm
    ;mptbldesc Decel_fuel_shutoff_RPM_over_Idle_off_point.
    .byte 0x1E                       ;Point 1
;.org 0x84D1
T_DecelFuelShutoffDeltaRPMOn:
    ;mpgrp Decel_Fuel_Shutoff\
    ;mptbladdr 0x1517
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DecelFuelShutoffDeltaRPMOn
    ;mptblcname DFRPML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPMOverIdle 0 8192 rpm
    ;mptbldesc Decel_fuel_shutoff_RPM_over_Idle_on_point.
    .byte 0x11                       ;Point 1
;.org 0x84D2
T_t84D2x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1523
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t84D2x
    ;mptblcname T84D2X
    ;mpxaxis Xinput 7 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xF9                       ;Point 2
    .byte 0x00                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0x00                       ;Point 6
    .byte 0x00                       ;Point 7
;.org 0x84D9
T_StopTrackingBoostErrorBelowThisDeltaTPS:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x152F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StopTrackingBoostErrorBelowThisDeltaTPS
    ;mptblcname TPSTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPMOverIdle 0 8192 rpm
    ;mptbldesc Decel_fuel_shutoff_RPM_over_Idle_on_point.
    .byte 0x00                       ;Point 1
;.org 0x84DA
T_t84DAx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x153B
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t84DAx
    ;mptblcname T84DAX
    ;mpxaxis Xinput 67 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0x00                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0x00                       ;Point 6
    .byte 0x00                       ;Point 7
    .byte 0x00                       ;Point 8
    .byte 0x00                       ;Point 9
    .byte 0x01                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0x80                       ;Point 12
    .byte 0xFF                       ;Point 13
    .byte 0xFF                       ;Point 14
    .byte 0xFF                       ;Point 15
    .byte 0xFF                       ;Point 16
    .byte 0xFF                       ;Point 17
    .byte 0xFF                       ;Point 18
    .byte 0xFF                       ;Point 19
    .byte 0xFF                       ;Point 20
    .byte 0xFF                       ;Point 21
    .byte 0xFF                       ;Point 22
    .byte 0xFF                       ;Point 23
    .byte 0xFF                       ;Point 24
    .byte 0xFF                       ;Point 25
    .byte 0xFF                       ;Point 26
    .byte 0xFF                       ;Point 27
    .byte 0xFF                       ;Point 28
    .byte 0xFF                       ;Point 29
    .byte 0xFF                       ;Point 30
    .byte 0xFF                       ;Point 31
    .byte 0xFF                       ;Point 32
    .byte 0x01                       ;Point 33
    .byte 0xFF                       ;Point 34
    .byte 0x00                       ;Point 35
    .byte 0xFF                       ;Point 36
    .byte 0xFF                       ;Point 37
    .byte 0xFF                       ;Point 38
    .byte 0xFF                       ;Point 39
    .byte 0xFF                       ;Point 40
    .byte 0xFF                       ;Point 41
    .byte 0xFF                       ;Point 42
    .byte 0xFF                       ;Point 43
    .byte 0xFF                       ;Point 44
    .byte 0xFF                       ;Point 45
    .byte 0xFF                       ;Point 46
    .byte 0xFF                       ;Point 47
    .byte 0xFF                       ;Point 48
    .byte 0xFF                       ;Point 49
    .byte 0xFF                       ;Point 50
    .byte 0xFF                       ;Point 51
    .byte 0xFF                       ;Point 52
    .byte 0xFF                       ;Point 53
    .byte 0xFF                       ;Point 54
    .byte 0xFF                       ;Point 55
    .byte 0x01                       ;Point 56
    .byte 0xFF                       ;Point 57
    .byte 0x10                       ;Point 58
    .byte 0xFF                       ;Point 59
    .byte 0x10                       ;Point 60
    .byte 0xFF                       ;Point 61
    .byte 0x10                       ;Point 62
    .byte 0xFF                       ;Point 63
    .byte 0x10                       ;Point 64
    .byte 0xFF                       ;Point 65
    .byte 0x10                       ;Point 66
    .byte 0xFF                       ;Point 67
;.org 0x851D
T_FuelBatteryOffset:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x154B
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelBatteryOffset
    ;mptblcname BATOFF
    ;mpxaxis Battery 0 16.2 Volts
    ;mpyaxis Pulsewidth 0 4096 uSec
    ;mptbldesc Compensates_for_slower_opening_times_of_injectors_with_lower_voltage.
    .byte 0x04                       ;Number of points in table
    .byte 0x59, 0x6A, 0xFE, 0xD3     ;Point 1
    .byte 0x81, 0x3B, 0xFF, 0x92     ;Point 2
    .byte 0xC2, 0x1F, 0xFF, 0xC9     ;Point 3
    .byte 0xFA, 0x13                 ;Point 4
;.org 0x852C
T_t852Cx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x155B
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t852Cx
    ;mptblcname T852CX
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x8530
T_KeyOnPrimePW:
    ;mpgrp Fuel_-_Starting\
    ;mptbladdr 0x1567
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname KeyOnPrimePW
    ;mptblcname PRSHOT
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Pulsewidth 0 255 mSec
    ;mptbldesc Prime_Fuel_Shot_before_cranking
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x63, 0x41, 0xFE, 0xC2     ;Point 1
    .byte 0x84, 0x18, 0xFE, 0x00     ;Point 2
    .byte 0x90, 0x00                 ;Point 3
;.org 0x853B
T_t853Bx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1577
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t853Bx
    ;mptblcname T853BX
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x853F
T_CoolantTempForVeryColdStart:
    ;mpgrp Spark_-_Start_to_Run_Transfer\
    ;mptbladdr 0x1583
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CoolantTempForVeryColdStart
    ;mptblcname CTVCDS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis CoolantTemp -200 260 F
    ;mptbldesc Desc
    .byte 0x58                       ;Point 1
;.org 0x8540
T_FuelStartRunTransferPointRpm:
    ;mpgrp Spark_-_Start_to_Run_Transfer\
    ;mptbladdr 0x158F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FuelStartRunTransferPointRpm
    ;mptblcname RNFPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc Start_to_Run_transfer_point_for_fuel
    .byte 0x5A                       ;Point 1
;.org 0x8541
T_FuelRunStartTransferPointRpm:
    ;mpgrp Spark_-_Start_to_Run_Transfer\
    ;mptbladdr 0x159B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FuelRunStartTransferPointRpm
    ;mptblcname STFPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc Run_to_Start_transfer_point_for_spark
    .byte 0x82                       ;Point 1
;.org 0x8542
T_StartFuel_FromTemp:
    ;mpgrp Fuel_-_Starting\
    ;mptbladdr 0x15A7
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname StartFuel_FromTemp
    ;mptblcname STRTFL
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis sqrtPW 0 222 uSec
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4
    ;mpinjscale sqrt
    .byte 0x09                       ;Number of points in table
    .byte 0x5E, 0x7F, 0xFE, 0x00     ;Point 1
    .byte 0x63, 0x75, 0xFF, 0x00     ;Point 2
    .byte 0x6E, 0x6A, 0xFF, 0x17     ;Point 3
    .byte 0x79, 0x60, 0xFF, 0x00     ;Point 4
    .byte 0x84, 0x55, 0xFF, 0x00     ;Point 5
    .byte 0x90, 0x49, 0xFE, 0xBA     ;Point 6
    .byte 0x9B, 0x3B, 0xFF, 0x90     ;Point 7
    .byte 0xC2, 0x2A, 0xFF, 0x2F     ;Point 8
    .byte 0xCD, 0x21                 ;Point 9
;.org 0x8565
T_t8565x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x15BD
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8565x
    ;mptblcname T8565X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x8569
T_ColdestTempAllowedAtClosedThrottle:
    ;mpgrp Fuel_-_Starting\
    ;mptbladdr 0x15C9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ColdestTempAllowedAtClosedThrottle
    ;mptblcname STRLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Coldest_temperature_accepted_as_input_to_STRTFL_table_-_anything_below_this_value_will_be_replaced_with_this_value
    .byte 0x63                       ;Point 1
;.org 0x856A
T_StartFuelOffIdleFactor_fromRPM:
    ;mpgrp Fuel_-_Starting\
    ;mptbladdr 0x15D5
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname StartFuelOffIdleFactor_fromRPM
    ;mptblcname STFLOI
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Inverse 0 1 factor
    ;mptbldesc desc
    .byte 0x04                       ;Number of points in table
    .byte 0x23, 0xFF, 0xFB, 0x0C     ;Point 1
    .byte 0x38, 0x97, 0xFF, 0xAB     ;Point 2
    .byte 0x7D, 0x80, 0xFF, 0x61     ;Point 3
    .byte 0xAF, 0x61                 ;Point 4
;.org 0x8579
T_t8579x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x15E5
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8579x
    ;mptblcname T8579X
    ;mpxaxis Xinput 12 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
;.org 0x8585
T_StartFuelIdleFactor_fromRPM:
    ;mpgrp Fuel_-_Starting\
    ;mptbladdr 0x15F1
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname StartFuelIdleFactor_fromRPM
    ;mptblcname STFLID
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Inverse 0 1 factor
    ;mptbldesc desc
    .byte 0x03                       ;Number of points in table
    .byte 0x23, 0xFF, 0xFB, 0x0C     ;Point 1
    .byte 0x38, 0x97, 0xFF, 0xAB     ;Point 2
    .byte 0x7D, 0x80                 ;Point 3
;.org 0x8590
T_t8590x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1600
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8590x
    ;mptblcname T8590X
    ;mpxaxis Xinput 16 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
    .byte 0xFF                       ;Point 13
    .byte 0xFF                       ;Point 14
    .byte 0xFF                       ;Point 15
    .byte 0xFF                       ;Point 16
;.org 0x85A0
T_FuelStartFuelFromCoolant:
    ;mpgrp Fuel_-_Starting\
    ;mptbladdr 0x160C
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartFuelFromCoolant
    ;mptblcname STFTMP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Inverse 0 1 factor
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4
    .byte 0x02                       ;Number of points in table
    .byte 0x7F, 0xFF, 0xF8, 0x46     ;Point 1
    .byte 0xA0, 0x00                 ;Point 2
;.org 0x85A7
T_t85A7x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x161A
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t85A7x
    ;mptblcname T85A7X
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x85AF
T_FuelStartFuelPerEPP:
    ;mpgrp Fuel_-_Starting\
    ;mptbladdr 0x1626
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartFuelPerEPP
    ;mptblcname EPPMUL
    ;mpxaxis EPPs 0 255 count
    ;mpyaxis Multiplier 0 1 factor
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4._This_table_decreases_fuel_for_each_engine_rotation_while_starting
    .byte 0x02                       ;Number of points in table
    .byte 0x04, 0x00, 0x15, 0x33     ;Point 1
    .byte 0x09, 0x6A                 ;Point 2
;.org 0x85B6
T_t85B6x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1634
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t85B6x
    ;mptblcname T85B6X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x85BA
T_FuelStartFuelFromCoolant2:
    ;mpgrp Fuel_-_Starting\
    ;mptbladdr 0x1640
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartFuelFromCoolant2
    ;mptblcname STFTM2
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Inverse 0 1 factor
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0xFF                 ;Point 1
;.org 0x85BD
T_t85BDx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x164D
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t85BDx
    ;mptblcname T85BDX
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x85C1
T_FuelStartReductionFromBaro:
    ;mpgrp Fuel_-_Starting\
    ;mptbladdr 0x1659
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FuelStartReductionFromBaro
    ;mptblcname STFBAR
    ;mpxaxis Baro -14.7 14.7 psi
    ;mpyaxis Inverse 0 1 factor
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4._This_decreases_fuel_slightly_at_higher_altitudes_to_account_for_thinner_air.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x60, 0x4D, 0xFD, 0x0A     ;Point 1
    .byte 0x7A, 0x00                 ;Point 2
;.org 0x85C8
T_t85C8x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1668
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t85C8x
    ;mptblcname T85C8X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x85CC
T_FuelStartDecayIntoRun:
    ;mpgrp Fuel_-_Starting\
    ;mptbladdr 0x1674
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartDecayIntoRun
    ;mptblcname SFDCAY
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Subtracted 0 255 ms/rev
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4._This_allows_fuel_to_decay_gradually_after_the_start-run_transition.
    ;mpinjscale scale
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x3E                 ;Point 1
;.org 0x85CF
T_t85CFx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1682
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t85CFx
    ;mptblcname T85CFX
    ;mpxaxis Xinput 12 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
;.org 0x85DB
T_DensityFactorPartThrottle:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x168E
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DensityFactorPartThrottle
    ;mptblcname DFPART
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Factor 0 255 factor
    ;mptbldesc DensityFactor_for_part_throttle._Multiplied_by_MAP_and_the_3D_table_value.
    ;mpmapaxis -y
    .byte 0x10                       ;Point 1
;.org 0x85DC
T_MAPOffsetForFuelCalculation:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x169B
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MAPOffsetForFuelCalculation
    ;mptblcname MAPOFS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc Added_to_MAP_before_DF_calculation.
    ;mpmapaxis y
    .byte 0x09                       ;Point 1
;.org 0x85DD
T_FuelFromRPMAndMAP:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x16A8
    ;mptbltype 7
    ;mpsubtype n
    ;mptbllname FuelFromRPMAndMAP
    ;mptblcname PRTTBL
    ;mpxaxis RPMSCL 608 6496 rpm
    ;mpyaxis MAPHI 0.8 100 factor
    ;mptbldesc desc
    ;mp3dxtable RPMSCL 
    ;mp3dytable MAPHI 
    ;mpinjscale 3d
    .byte 0x11                       ;Number of rows in table
    .byte 0x11                       ;Number of cols in table
    .byte 0x00                       ;00 = unsigned, 80/FF = signed
    .byte 0x6C, 0x6C, 0x6C, 0x70, 0x72, 0x72, 0x72, 0x72, 0x80, 0x95, 0x91, 0x92, 0x92, 0x92, 0x92, 0x92, 0x92 ;Row 1
    .byte 0x6C, 0x6C, 0x6C, 0x70, 0x72, 0x72, 0x72, 0x72, 0x80, 0x95, 0x95, 0x96, 0x96, 0x96, 0x96, 0x96, 0x96 ;Row 2
    .byte 0x6C, 0x6C, 0x6C, 0x70, 0x72, 0x80, 0x80, 0x80, 0x80, 0x8A, 0x9C, 0x8E, 0x88, 0x7E, 0x62, 0x48, 0x40 ;Row 3
    .byte 0x70, 0x70, 0x70, 0x76, 0x76, 0x80, 0x80, 0x80, 0x80, 0x8C, 0xA0, 0x88, 0x84, 0x7A, 0x5E, 0x46, 0x3C ;Row 4
    .byte 0x74, 0x74, 0x74, 0x76, 0x76, 0x80, 0x80, 0x80, 0x80, 0x8D, 0xA0, 0x88, 0x84, 0x7A, 0x5E, 0x46, 0x3C ;Row 5
    .byte 0x7D, 0x7D, 0x7D, 0x7D, 0x7D, 0x88, 0x8E, 0x85, 0x8B, 0x9B, 0xA0, 0x8A, 0x84, 0x7A, 0x5E, 0x46, 0x3C ;Row 6
    .byte 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x82, 0x82, 0x7F, 0x84, 0x92, 0x98, 0x8C, 0x86, 0x7C, 0x62, 0x48, 0x3E ;Row 7
    .byte 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x83, 0x83, 0x84, 0x92, 0x98, 0x8C, 0x88, 0x7E, 0x62, 0x48, 0x40 ;Row 8
    .byte 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7B, 0x82, 0x83, 0x82, 0x8B, 0x92, 0x8C, 0x86, 0x7C, 0x62, 0x48, 0x3E ;Row 9
    .byte 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x7F, 0x86, 0x86, 0x88, 0x90, 0x96, 0x92, 0x8E, 0x84, 0x66, 0x4C, 0x44 ;Row 10
    .byte 0x82, 0x82, 0x82, 0x82, 0x82, 0x82, 0x8A, 0x8A, 0x8B, 0x92, 0x98, 0x9A, 0x94, 0x8A, 0x6C, 0x52, 0x48 ;Row 11
    .byte 0x8A, 0x8A, 0x8A, 0x8A, 0x8A, 0x8A, 0x8A, 0x8A, 0x8B, 0x92, 0xA0, 0xA6, 0xA2, 0x93, 0x7C, 0x66, 0x56 ;Row 12
    .byte 0x91, 0x91, 0x91, 0x91, 0x91, 0x91, 0x91, 0x92, 0x92, 0x97, 0xA6, 0xB0, 0xB0, 0xA4, 0x8C, 0x7A, 0x66 ;Row 13
    .byte 0xA3, 0xA3, 0xA3, 0xA3, 0xA3, 0xA3, 0xA3, 0xA4, 0xA4, 0xA9, 0xB6, 0xC0, 0xC0, 0xBA, 0xA8, 0x8A, 0x74 ;Row 14
    .byte 0xB4, 0xB4, 0xB4, 0xB4, 0xB4, 0xB4, 0xB4, 0xB5, 0xB6, 0xBB, 0xC2, 0xCD, 0xCD, 0xC8, 0xB2, 0x94, 0x7E ;Row 15
    .byte 0xC3, 0xC3, 0xC3, 0xC3, 0xC3, 0xC3, 0xC3, 0xC3, 0xC4, 0xC9, 0xD4, 0xDC, 0xDE, 0xD6, 0xBE, 0xA0, 0x86 ;Row 16
    .byte 0xCF, 0xCF, 0xCF, 0xCF, 0xCF, 0xCF, 0xCF, 0xCF, 0xD0, 0xD6, 0xDE, 0xE2, 0xE2, 0xD8, 0xBE, 0xA0, 0x8A ;Row 17
;.org 0x8701
T_SwitchPointForDownUp_FromRpm:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x16CA
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname SwitchPointForDownUp_FromRpm
    ;mptblcname RPMMAP
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc EPP_Control_toggle
    ;mpmapaxis y
    .byte 0x05                       ;Number of points in table
    .byte 0x5B, 0x9B, 0xFB, 0x39     ;Point 1
    .byte 0x64, 0x70, 0xFE, 0xB1     ;Point 2
    .byte 0x71, 0x5F, 0xFD, 0x80     ;Point 3
    .byte 0x7D, 0x41, 0xFF, 0xB6     ;Point 4
    .byte 0xA3, 0x36                 ;Point 5
;.org 0x8714
T_t8714x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x16DC
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8714x
    ;mptblcname T8714X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x8718
T_EppPerAmountForIncreasing:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x16E8
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname EppPerAmountForIncreasing
    ;mptblcname PTENR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EPP_per_amount_for_increasing_multiplier
    .word 0x1401                     ;Point 1
;.org 0x871A
T_EppPerAmountForDecreasingMultiplier:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x16F4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EppPerAmountForDecreasingMultiplier
    ;mptblcname PTENR2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EPP_per_amount_for_decreasing_multiplier
    .byte 0x20                       ;Point 1
;.org 0x871B
T_AmountForDecreasingMultiplier_Negative:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x1700
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AmountForDecreasingMultiplier_Negative
    ;mptblcname PTENRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Amount_for_decreasing_multiplier_(neg_number)
    .byte 0xFF                       ;Point 1
;.org 0x871C
T_NumberToReturnToHOTMAP:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x170C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NumberToReturnToHOTMAP
    ;mptblcname PTENUM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc No_of_PTENRD_below_PTELMT_that_PT_enrich_must_be_to_return_to_HOTMAP_spark_advance_after_maxed_out
    .byte 0x0F                       ;Point 1
;.org 0x871D
T_EnrichAdjust_FromMap:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x1718
    ;mptbltype 7
    ;mpsubtype n
    ;mptbllname EnrichAdjust_FromMap
    ;mptblcname PTEADJ
    ;mpxaxis RPMSCL 608 6496 rpm
    ;mpyaxis MAPHI 0.8 100 factor
    ;mptbldesc desc
    ;mp3dxtable RPMSCL 
    ;mp3dytable MAPHI 
    .byte 0x11                       ;Number of rows in table
    .byte 0x11                       ;Number of cols in table
    .byte 0x00                       ;00 = unsigned, 80/FF = signed
    .byte 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01 ;Row 1
    .byte 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01 ;Row 2
    .byte 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01 ;Row 3
    .byte 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01 ;Row 4
    .byte 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x0D, 0x0D, 0x0D, 0x0D ;Row 5
    .byte 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x10, 0x10, 0x10, 0x10, 0x12 ;Row 6
    .byte 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x10, 0x10, 0x10, 0x10, 0x12, 0x12 ;Row 7
    .byte 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x0D, 0x19, 0x29, 0x29, 0x26, 0x26, 0x26 ;Row 8
    .byte 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x06, 0x0D, 0x1A, 0x20, 0x3B, 0x40, 0x43, 0x43, 0x43 ;Row 9
    .byte 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x0D, 0x1A, 0x21, 0x26, 0x3B, 0x40, 0x47, 0x47, 0x47 ;Row 10
    .byte 0x01, 0x01, 0x01, 0x01, 0x01, 0x0D, 0x0D, 0x0D, 0x12, 0x24, 0x24, 0x30, 0x40, 0x40, 0x51, 0x51, 0x51 ;Row 11
    .byte 0x01, 0x01, 0x01, 0x01, 0x01, 0x1A, 0x1A, 0x1A, 0x26, 0x2A, 0x2C, 0x36, 0x3E, 0x43, 0x47, 0x47, 0x47 ;Row 12
    .byte 0x01, 0x01, 0x01, 0x01, 0x01, 0x1A, 0x1A, 0x25, 0x25, 0x2C, 0x2C, 0x36, 0x36, 0x36, 0x3A, 0x3A, 0x3A ;Row 13
    .byte 0x01, 0x01, 0x01, 0x01, 0x01, 0x0D, 0x1A, 0x25, 0x21, 0x27, 0x27, 0x29, 0x29, 0x29, 0x26, 0x26, 0x26 ;Row 14
    .byte 0x01, 0x01, 0x01, 0x01, 0x01, 0x0D, 0x0D, 0x0F, 0x1A, 0x1A, 0x1A, 0x20, 0x22, 0x19, 0x19, 0x19, 0x19 ;Row 15
    .byte 0x01, 0x01, 0x01, 0x01, 0x01, 0x0D, 0x0D, 0x0D, 0x19, 0x19, 0x19, 0x19, 0x19, 0x19, 0x14, 0x14, 0x14 ;Row 16
    .byte 0x01, 0x01, 0x01, 0x01, 0x01, 0x0D, 0x0D, 0x0D, 0x14, 0x14, 0x14, 0x14, 0x14, 0x14, 0x14, 0x14, 0x14 ;Row 17
;.org 0x8841
T_WOTEnrichmentFromRPMAndMAP:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x1739
    ;mptbltype 7
    ;mpsubtype n
    ;mptbllname WOTEnrichmentFromRPMAndMAP
    ;mptblcname WOTENR
    ;mpxaxis RPMSCL 608 6496 rpm
    ;mpyaxis MAPHI 0.8 100 factor
    ;mptbldesc desc
    ;mp3dxtable RPMSCL 
    ;mp3dytable MAPHI 
    .byte 0x11                       ;Number of rows in table
    .byte 0x11                       ;Number of cols in table
    .byte 0x00                       ;00 = unsigned, 80/FF = signed
    .byte 0xC5, 0xC5, 0xC5, 0xC1, 0xC1, 0xB0, 0xB0, 0xB0, 0xB1, 0xA3, 0x91, 0xB8, 0xB6, 0xB6, 0xB8, 0xB5, 0xB8 ;Row 1
    .byte 0xC5, 0xC5, 0xC5, 0xC1, 0xC1, 0xB0, 0xB0, 0xB0, 0xB1, 0xA3, 0x91, 0xB8, 0xB6, 0xB6, 0xB8, 0xB5, 0xB8 ;Row 2
    .byte 0xC5, 0xC5, 0xC5, 0xC1, 0xC1, 0xB0, 0xB0, 0xB0, 0xB1, 0xA3, 0x91, 0xB8, 0xB6, 0xB6, 0xB8, 0xB5, 0xB8 ;Row 3
    .byte 0xC5, 0xC5, 0xC5, 0xC1, 0xC1, 0xB0, 0xB0, 0xB0, 0xB1, 0xA3, 0x91, 0xB8, 0xB6, 0xB6, 0xB8, 0xB5, 0xB8 ;Row 4
    .byte 0xC5, 0xC5, 0xC5, 0xC1, 0xC1, 0xB0, 0xB0, 0xB0, 0xB1, 0xA3, 0x91, 0xB8, 0xB6, 0xB6, 0xB8, 0xB5, 0xB8 ;Row 5
    .byte 0xAC, 0xAC, 0xAC, 0xAC, 0xAC, 0x9A, 0x91, 0x9F, 0x97, 0x86, 0x89, 0xAB, 0xAD, 0xAD, 0xAE, 0xAC, 0xAE ;Row 6
    .byte 0x9C, 0x9C, 0x9C, 0x9C, 0x9C, 0x97, 0x97, 0x9C, 0x95, 0x87, 0x88, 0x9B, 0x9D, 0x9D, 0x9A, 0x9B, 0x9D ;Row 7
    .byte 0x8E, 0x8E, 0x8E, 0x8E, 0x8E, 0x8F, 0x89, 0x89, 0x89, 0x7B, 0x7C, 0x8F, 0x8E, 0x8D, 0x8E, 0x8F, 0x8C ;Row 8
    .byte 0x87, 0x87, 0x87, 0x87, 0x87, 0x8E, 0x83, 0x82, 0x84, 0x7D, 0x7D, 0x87, 0x89, 0x89, 0x86, 0x87, 0x89 ;Row 9
    .byte 0x82, 0x82, 0x82, 0x82, 0x82, 0x82, 0x78, 0x79, 0x76, 0x71, 0x72, 0x79, 0x78, 0x77, 0x7A, 0x7A, 0x77 ;Row 10
    .byte 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x7A, 0x6F, 0x6F, 0x6E, 0x6B, 0x6C, 0x6B, 0x6C, 0x6B, 0x6D, 0x78, 0x6D ;Row 11
    .byte 0x6C, 0x6C, 0x6C, 0x6C, 0x6C, 0x6C, 0x6C, 0x6C, 0x6C, 0x68, 0x5F, 0x59, 0x58, 0x5D, 0x53, 0x54, 0x52 ;Row 12
    .byte 0x54, 0x54, 0x54, 0x54, 0x54, 0x54, 0x54, 0x53, 0x56, 0x5D, 0x53, 0x49, 0x44, 0x44, 0x3A, 0x31, 0x36 ;Row 13
    .byte 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x31, 0x36, 0x3B, 0x37, 0x30, 0x29, 0x24, 0x22, 0x24, 0x21 ;Row 14
    .byte 0x25, 0x25, 0x25, 0x25, 0x25, 0x25, 0x25, 0x2E, 0x2E, 0x31, 0x31, 0x2B, 0x24, 0x1A, 0x16, 0x1D, 0x18 ;Row 15
    .byte 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x1F, 0x2C, 0x2C, 0x2C, 0x2C, 0x24, 0x1C, 0x14, 0x0A, 0x0C, 0x0F ;Row 16
    .byte 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x0E, 0x1C, 0x29, 0x29, 0x29, 0x29, 0x21, 0x1A, 0x11, 0x08, 0x0A, 0x0D ;Row 17
;.org 0x8965
T_DeltaTPSFromRPM:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x175A
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DeltaTPSFromRPM
    ;mptblcname DLTPRP
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis DeltaTPS 0 5 volts
    ;mptbldesc Throttle_self_calibration
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x85                 ;Point 1
;.org 0x8968
T_t8968x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1767
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8968x
    ;mptblcname T8968X
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x8970
T_TPSOffset:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1773
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TPSOffset
    ;mptblcname TPSOFS
    ;mpxaxis in 0 255 in
    ;mpyaxis DeltaTPS 0 5 volts
    ;mptbldesc Throttle_self_calibration
    .byte 0x03                       ;Point 1
;.org 0x8971
T_ValueCopiedTo0036:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x177F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ValueCopiedTo0036
    ;mptblcname NAME5
    ;mpxaxis in 0 255 in
    ;mpyaxis out 0 255 out
    ;mptbldesc EMR
    .byte 0x00                       ;Point 1
;.org 0x8972
T_FuelModFromMAPAndSomething0036:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x178B
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FuelModFromMAPAndSomething0036
    ;mptblcname NAME6
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis out 0 255 out
    ;mptbldesc EMR
    ;mpmapaxis x
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x01                 ;Point 1
;.org 0x8975
T_t8975x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1799
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8975x
    ;mptblcname T8975X
    ;mpxaxis Xinput 12 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
;.org 0x8981
T_ColdLoad3DTableOffIdle:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x17A5
    ;mptbltype 17
    ;mpsubtype n
    ;mptbllname ColdLoad3DTableOffIdle
    ;mptblcname CLDLDP
    ;mpxaxis CoolantTemp -200 260 F
    ;mpyaxis MAPHI 0.8 100 factor
    ;mptbldesc desc
    ;mp3dxtable CoolantTemp
    ;mp3dytable MAPHI 
    .byte 0x11                       ;Number of rows in table
    .byte 0x09                       ;Number of cols in table
    .byte 0x00                       ;00 = unsigned, 80/FF = signed
    .byte 0x60, 0x69, 0x76, 0x84, 0x90, 0xA3, 0xB1, 0xCB, 0xD2 ;X-Axis Breakpoints
    .byte 0x3F, 0x3F, 0x26, 0x15, 0x0F, 0x0A, 0x09, 0x00, 0x00 ;Row 1
    .byte 0x3F, 0x3F, 0x26, 0x15, 0x0F, 0x0A, 0x09, 0x00, 0x00 ;Row 2
    .byte 0x3F, 0x3F, 0x26, 0x15, 0x0F, 0x0A, 0x09, 0x00, 0x00 ;Row 3
    .byte 0x3F, 0x3F, 0x26, 0x15, 0x0F, 0x0A, 0x09, 0x00, 0x00 ;Row 4
    .byte 0x3F, 0x3F, 0x26, 0x15, 0x0F, 0x0A, 0x09, 0x00, 0x00 ;Row 5
    .byte 0x3F, 0x3F, 0x26, 0x15, 0x0F, 0x0A, 0x09, 0x00, 0x00 ;Row 6
    .byte 0x3F, 0x3F, 0x26, 0x15, 0x0F, 0x0A, 0x09, 0x00, 0x00 ;Row 7
    .byte 0x3F, 0x3F, 0x26, 0x15, 0x0F, 0x0A, 0x09, 0x00, 0x00 ;Row 8
    .byte 0x4A, 0x40, 0x31, 0x1A, 0x11, 0x0C, 0x0A, 0x00, 0x00 ;Row 9
    .byte 0x4A, 0x40, 0x33, 0x1C, 0x13, 0x0E, 0x0C, 0x00, 0x00 ;Row 10
    .byte 0x4A, 0x40, 0x33, 0x1C, 0x13, 0x0E, 0x0C, 0x00, 0x00 ;Row 11
    .byte 0x4A, 0x40, 0x33, 0x1C, 0x13, 0x0E, 0x0C, 0x00, 0x00 ;Row 12
    .byte 0x4A, 0x40, 0x33, 0x1C, 0x13, 0x0E, 0x0C, 0x00, 0x00 ;Row 13
    .byte 0x26, 0x20, 0x19, 0x0E, 0x09, 0x07, 0x06, 0x00, 0x00 ;Row 14
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 15
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 16
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 17
;.org 0x8A26
T_ColdLoad3DTableIdle:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x17C7
    ;mptbltype 17
    ;mpsubtype n
    ;mptbllname ColdLoad3DTableIdle
    ;mptblcname CLDLDI
    ;mpxaxis CoolantTemp -200 260 F
    ;mpyaxis MAPHI 0.8 100 factor
    ;mptbldesc desc
    ;mp3dxtable CoolantTemp
    ;mp3dytable MAPHI 
    .byte 0x11                       ;Number of rows in table
    .byte 0x09                       ;Number of cols in table
    .byte 0x00                       ;00 = unsigned, 80/FF = signed
    .byte 0x60, 0x69, 0x76, 0x84, 0x90, 0xA3, 0xB1, 0xCB, 0xD2 ;X-Axis Breakpoints
    .byte 0x45, 0x3F, 0x26, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 1
    .byte 0x45, 0x3F, 0x26, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 2
    .byte 0x45, 0x3F, 0x26, 0x18, 0x03, 0x03, 0x03, 0x00, 0x00 ;Row 3
    .byte 0x4E, 0x3F, 0x26, 0x18, 0x0F, 0x0A, 0x09, 0x00, 0x00 ;Row 4
    .byte 0x4E, 0x3F, 0x28, 0x1D, 0x0F, 0x0A, 0x09, 0x00, 0x00 ;Row 5
    .byte 0x4E, 0x3F, 0x2A, 0x1D, 0x13, 0x10, 0x0E, 0x00, 0x00 ;Row 6
    .byte 0x4E, 0x3F, 0x2C, 0x1D, 0x13, 0x10, 0x0E, 0x00, 0x00 ;Row 7
    .byte 0x4E, 0x44, 0x34, 0x28, 0x1F, 0x12, 0x10, 0x00, 0x00 ;Row 8
    .byte 0x4E, 0x44, 0x34, 0x28, 0x1F, 0x12, 0x10, 0x00, 0x00 ;Row 9
    .byte 0x4E, 0x44, 0x34, 0x28, 0x1F, 0x12, 0x10, 0x00, 0x00 ;Row 10
    .byte 0x4E, 0x44, 0x34, 0x28, 0x1F, 0x12, 0x10, 0x00, 0x00 ;Row 11
    .byte 0x4E, 0x44, 0x34, 0x28, 0x1F, 0x12, 0x10, 0x00, 0x00 ;Row 12
    .byte 0x4E, 0x44, 0x34, 0x28, 0x1F, 0x12, 0x10, 0x00, 0x00 ;Row 13
    .byte 0x4E, 0x44, 0x34, 0x28, 0x1F, 0x12, 0x10, 0x00, 0x00 ;Row 14
    .byte 0x4E, 0x44, 0x34, 0x28, 0x1F, 0x12, 0x10, 0x00, 0x00 ;Row 15
    .byte 0x4E, 0x44, 0x34, 0x28, 0x1F, 0x12, 0x10, 0x00, 0x00 ;Row 16
    .byte 0x4E, 0x44, 0x34, 0x28, 0x1F, 0x12, 0x10, 0x00, 0x00 ;Row 17
;.org 0x8ACB
T_CurveABC_3DTable:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x17E9
    ;mptbltype 17
    ;mpsubtype n
    ;mptbllname CurveABC_3DTable
    ;mptblcname CURV3D
    ;mpxaxis CoolantTemp -200 260 F
    ;mpyaxis TIMESC 101 200 factor
    ;mptbldesc desc
    ;mp3dxtable CoolantTemp
    ;mp3dytable TIMESC 
    .byte 0x09                       ;Number of rows in table
    .byte 0x09                       ;Number of cols in table
    .byte 0x00                       ;00 = unsigned, 80/FF = signed
    .byte 0x62, 0x79, 0x84, 0x90, 0x9B, 0xA6, 0xC2, 0xE8, 0xEE ;X-Axis Breakpoints
    .byte 0xF3, 0x9C, 0x89, 0x75, 0x5A, 0x21, 0x21, 0x2D, 0x3A ;Row 1
    .byte 0xF3, 0x9C, 0x89, 0x75, 0x5A, 0x5A, 0x39, 0x2D, 0x3A ;Row 2
    .byte 0xF3, 0x9C, 0x89, 0x75, 0x5A, 0x5A, 0x51, 0x26, 0x2D ;Row 3
    .byte 0xD5, 0x83, 0x78, 0x6C, 0x51, 0x51, 0x48, 0x0F, 0x0F ;Row 4
    .byte 0xA6, 0x6E, 0x5D, 0x4C, 0x31, 0x31, 0x28, 0x0F, 0x0F ;Row 5
    .byte 0x6E, 0x4D, 0x49, 0x38, 0x17, 0x17, 0x11, 0x0D, 0x0D ;Row 6
    .byte 0x3D, 0x2D, 0x2B, 0x21, 0x0C, 0x0C, 0x0D, 0x0D, 0x0D ;Row 7
    .byte 0x10, 0x10, 0x10, 0x0A, 0x03, 0x03, 0x0C, 0x0C, 0x0C ;Row 8
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 ;Row 9
;.org 0x8B28
T_BaroCompensationOfWarmupFactor_FromBaro:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x1803
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
;.org 0x8B2B
T_t8B2Bx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1811
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8B2Bx
    ;mptblcname T8B2BX
    ;mpxaxis Xinput 12 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
;.org 0x8B37
T_MultiplierForWOTENR:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x181D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MultiplierForWOTENR
    ;mptblcname WOTMUL
    ;mpxaxis in 0 255 in
    ;mpyaxis factor 0 1 out
    ;mptbldesc WOT_Factor_multiplier
    .byte 0xFF                       ;Point 1
;.org 0x8B38
T_FuelEnrichmentFromBaro:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x1829
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FuelEnrichmentFromBaro
    ;mptblcname BARENR
    ;mpxaxis Baro -14.7 14.7 psi
    ;mpyaxis Factor 1 2 factor
    ;mptbldesc Baro_enrichment_factor
    ;mpmapaxis x
    .byte 0x03                       ;Number of points in table
    .byte 0x59, 0x33, 0xFE, 0x88     ;Point 1
    .byte 0x6A, 0x1A, 0xFE, 0x78     ;Point 2
    .byte 0x7B, 0x00                 ;Point 3
;.org 0x8B43
T_t8B43x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1839
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8B43x
    ;mptblcname T8B43X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x8B47
T_MAPMultiplierForBARENR:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x1845
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname MAPMultiplierForBARENR
    ;mptblcname BARMAP
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Factor 0 1 factor
    ;mptbldesc Baro_enrichment_factor_multiplier_from_MAP
    ;mpmapaxis x
    .byte 0x04                       ;Number of points in table
    .byte 0x22, 0xFD, 0xED, 0xE4     ;Point 1
    .byte 0x2B, 0x5A, 0xFD, 0xEC     ;Point 2
    .byte 0x44, 0x26, 0xFE, 0xE2     ;Point 3
    .byte 0x66, 0x00                 ;Point 4
;.org 0x8B56
T_RPMMultiplierForBARENR:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x1856
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname RPMMultiplierForBARENR
    ;mptblcname BARRPM
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Factor 0 1 factor
    ;mptbldesc Baro_enrichment_factor_multiplier_from_RPM
    .byte 0x03                       ;Number of points in table
    .byte 0x1F, 0x66, 0x0B, 0x9E     ;Point 1
    .byte 0x2C, 0xFD, 0xFF, 0x51     ;Point 2
    .byte 0x42, 0xEE                 ;Point 3
;.org 0x8B61
T_t8B61x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1865
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8B61x
    ;mptblcname T8B61X
    ;mpxaxis Xinput 20 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
    .byte 0xFF                       ;Point 13
    .byte 0xFF                       ;Point 14
    .byte 0xFF                       ;Point 15
    .byte 0xFF                       ;Point 16
    .byte 0xFF                       ;Point 17
    .byte 0xFF                       ;Point 18
    .byte 0xFF                       ;Point 19
    .byte 0xFF                       ;Point 20
;.org 0x8B75
T_FuelEnrichmentFromChargeTemp:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x1872
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelEnrichmentFromChargeTemp
    ;mptblcname AIRTMP
    ;mpxaxis Charge_Temp -200 260 volts
    ;mpyaxis Factor 1 2 factor
    ;mptbldesc Charge_Temp_Factor._Note_that_this_is_an_unfiltered_charge_temp_voltage____so_higher_numbers_are_lower_temps
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1
;.org 0x8B78
T_t8B78x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x187F
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8B78x
    ;mptblcname T8B78X
    ;mpxaxis Xinput 16 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
    .byte 0xFF                       ;Point 13
    .byte 0xFF                       ;Point 14
    .byte 0xFF                       ;Point 15
    .byte 0xFF                       ;Point 16
;.org 0x8B88
T_MAPMultiplierForAIRTMP:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x188B
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname MAPMultiplierForAIRTMP
    ;mptblcname AIRMAP
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Factor 0 1 factor
    ;mptbldesc Charge_temp_enrichment_factor_multiplier_from_MAP
    ;mpmapaxis x
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0xFF                 ;Point 1
;.org 0x8B8B
T_t8B8Bx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1899
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8B8Bx
    ;mptblcname T8B8BX
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x8B93
T_RPMMultiplierForAIRTMP:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x18A5
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname RPMMultiplierForAIRTMP
    ;mptblcname AIRRPM
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Factor 0 1 factor
    ;mptbldesc Charge_temp_enrichment_factor_multiplier_from_RPM
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0xFF                 ;Point 1
;.org 0x8B96
T_t8B96x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x18B2
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8B96x
    ;mptblcname T8B96X
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x8B9E
T_PositiveTransientTriggerLevel:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x18BE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PositiveTransientTriggerLevel
    ;mptblcname POSTRG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Positive_Transient_Enrich_Trigger_Level_in_volts_times_0.02
    .byte 0x03                       ;Point 1
;.org 0x8B9F
T_MaxDeltaTHR:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x18CA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxDeltaTHR
    ;mptblcname THRMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Max_Delta_THR_(THR-AVTHR-POSTRG)_-_value_of_$26_is_.51_volts
    .byte 0x23                       ;Point 1
;.org 0x8BA0
T_DeltaTPSEnrichmentFactor:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x18D6
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DeltaTPSEnrichmentFactor
    ;mptblcname POSSLP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis pw 0 60 ms/volt
    ;mptbldesc Throttle_Transient_Enrich_PW_Addition
    ;mpinjscale scale
    .byte 0x04                       ;Number of points in table
    .byte 0x5E, 0x88, 0xFE, 0x46     ;Point 1
    .byte 0x74, 0x62, 0xFE, 0x5B     ;Point 2
    .byte 0x90, 0x34, 0xFF, 0x71     ;Point 3
    .byte 0xCD, 0x12                 ;Point 4
;.org 0x8BAF
T_DeltaMapTriggerLevel:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x18E7
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapTriggerLevel
    ;mptblcname MAPTRG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc MAP_Delta_required_to_trigger_transient_enrichment
    ;mpmapaxis y
    .byte 0x0A                       ;Point 1
;.org 0x8BB0
T_MaxDeltaMapAllowed:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x18F4
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MaxDeltaMapAllowed
    ;mptblcname MAPMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc Maximum_Delta_MAP_allowed
    ;mpmapaxis y
    .byte 0x33                       ;Point 1
;.org 0x8BB1
T_FakeDeltaMapIncrease:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x1901
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname FakeDeltaMapIncrease
    ;mptblcname OCTAE
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc Fake_Delta_Map_Increase._AVMAP_is_set_to_(MAP-OCTAE)_any_time_throttle_is_just_opened.
    ;mpmapaxis y
    .byte 0x02                       ;Point 1
;.org 0x8BB2
T_DeltaMAPEnrichment_FromTemp:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x190E
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname DeltaMAPEnrichment_FromTemp
    ;mptblcname AESLOP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis pwEnrich 0 255 uS/torr
    ;mptbldesc Transient_Enrichment_PW_Addition
    ;mpmapaxis -y
    ;mpinjscale scale
    .byte 0x04                       ;Number of points in table
    .byte 0x58, 0x2E, 0xFF, 0x24     ;Point 1
    .byte 0x7C, 0x0F, 0xFF, 0x9A     ;Point 2
    .byte 0x90, 0x07, 0xFF, 0xEF     ;Point 3
    .byte 0xCD, 0x03                 ;Point 4
;.org 0x8BC1
T_DecelLeanoutFactor_FromTemp:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x1920
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelLeanoutFactor_FromTemp
    ;mptblcname LOTTHR
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 1 scale
    ;mptbldesc Decel_leanout_factor_-_THR_based._When_Y_is_zero____factor_is_1.00
    .byte 0x02                       ;Number of points in table
    .byte 0x8A, 0x00, 0xFB, 0xAB     ;Point 1
    .byte 0x90, 0xE6                 ;Point 2
;.org 0x8BC8
T_t8BC8x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x192E
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8BC8x
    ;mptblcname T8BC8X
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x8BD0
T_DeltaTriggerForDecelLeanout:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x193A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaTriggerForDecelLeanout
    ;mptblcname LOTTRG
    ;mpxaxis in_desc -200 260 degrees
    ;mpyaxis factor 0 1 factor
    ;mptbldesc Main_trigger_(Delta_trigger_level_for_THR_leanout)_-_Delta_THR
    .byte 0xFE                       ;Point 1
;.org 0x8BD1
T_SecondDecelLeanoutTrigger:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x1946
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SecondDecelLeanoutTrigger
    ;mptblcname LOTRG2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Second_trigger_-_leanout_inc_toward_1_when_between_triggers
    .byte 0xFF                       ;Point 1
;.org 0x8BD2
T_LeanoutDeltaThrottleHysteresis:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x1952
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LeanoutDeltaThrottleHysteresis
    ;mptblcname LOTHYS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc hysteresis_about_delta_THR_trigger_levels
    .byte 0x03                       ;Point 1
;.org 0x8BD3
T_DeltaMAPLeanout_FromTemp:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x195E
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DeltaMAPLeanout_FromTemp
    ;mptblcname NEGSL2
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 100 percent
    ;mptbldesc Description
    .byte 0x02                       ;Number of points in table
    .byte 0x92, 0xFF, 0xFF, 0xA5     ;Point 1
    .byte 0xA0, 0xFA                 ;Point 2
;.org 0x8BDA
T_t8BDAx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x196C
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8BDAx
    ;mptblcname T8BDAX
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x8BE2
T_DeltaMapTriggerForNoIncrementalLeanout:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x1978
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapTriggerForNoIncrementalLeanout
    ;mptblcname DECTRG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc delta_map_trigger_level_for_no_incremental_leanout
    ;mpmapaxis y
    .byte 0xFE                       ;Point 1
;.org 0x8BE3
T_DeltaMapTriggerForMaxLeanout:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x1985
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapTriggerForMaxLeanout
    ;mptblcname DTRG2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc delta_map_trigger_level_for_max_leanout_on_decel
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1
;.org 0x8BE4
T_DeltaMapHysteresisonTriggerLevels:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x1992
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapHysteresisonTriggerLevels
    ;mptblcname DECHYS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc delta_map_hysteresis_on_trigger_levels
    ;mpmapaxis y
    .byte 0x02                       ;Point 1
;.org 0x8BE5
T_MinDeltaRPMToResetAvgMAP:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x199F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinDeltaRPMToResetAvgMAP
    ;mptblcname DLRPRM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Delta_RPM_at_RPM_Boundaries
    .byte 0xFF                       ;Point 1
;.org 0x8BE6
T_MinRpmForMapLeanout:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x19AB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinRpmForMapLeanout
    ;mptblcname LOTRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc No_map_leanout_if_below_this_RPM
    .byte 0x3E                       ;Point 1
;.org 0x8BE7
T_O2CNTRInhibitAfterLeanoutDone:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x19B7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2CNTRInhibitAfterLeanoutDone
    ;mptblcname DCELTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2CNTR_inhibit_after_MAP/THR_leanout_is_done_(times_11_ms)
    .byte 0x01                       ;Point 1
;.org 0x8BE8
T_MinAisPulseRequireToTriggerEnrichment:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x19C3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinAisPulseRequireToTriggerEnrichment
    ;mptblcname POSTIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Min_AIS_pulse_required_to_trigger_enrichment_(steps)
    .byte 0x07                       ;Point 1
;.org 0x8BE9
T_AisEnrichmentFuelPulse:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x19CF
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname AisEnrichmentFuelPulse
    ;mptblcname POSFUL
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AIS_enrichment_fuel_pulse_in_uSec
    ;mpinjscale word
    .word 0x00FA                     ;Point 1
;.org 0x8BEB
T_MinPWForPartThorttleEnrich:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x19DC
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname MinPWForPartThorttleEnrich
    ;mptblcname MINPTE
    ;mpxaxis X 0 255 scale
    ;mpyaxis Y 0 255 out
    ;mptbldesc MinPWForPartThorttleEnrich
    ;mpinjscale word
    .word 0x0009                     ;Point 1
;.org 0x8BED
T_OpenLoopEnrichFactorWhenSettingBasicTiming:
    ;mpgrp Idle_-_Special_setup\
    ;mptbladdr 0x19E9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OpenLoopEnrichFactorWhenSettingBasicTiming
    ;mptblcname RICHSA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Open_loop_enrich_factor_when_setting_mechanical_basic_timing
    .byte 0x03                       ;Point 1
;.org 0x8BEE
T_OpenLoopEnrichFactorWhenSettingMinThrottleOpening:
    ;mpgrp Idle_-_Special_setup\
    ;mptbladdr 0x19F5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OpenLoopEnrichFactorWhenSettingMinThrottleOpening
    ;mptblcname RIDLST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Open_loop_enrich_factor_when_setting_min_throttle_blade_opening_(actuator_test_#70)
    .byte 0x1A                       ;Point 1
;.org 0x8BEF
T_EnrichmentTime_FromTemp_MAP:
    ;mpgrp Fuel_-_Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x1A01
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname EnrichmentTime_FromTemp_MAP
    ;mptblcname AETIME
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis time_const 0 100 percent
    ;mptbldesc MAP_Transient_Enrich_Time_Constant_when_MAP_gt_AVMAP
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x02                 ;Point 1
;.org 0x8BF2
T_t8BF2x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1A0E
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8BF2x
    ;mptblcname T8BF2X
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x8BFA
T_EnrichmentTime_FromTemp_TPS:
    ;mpgrp Fuel_-_Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0x1A1A
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname EnrichmentTime_FromTemp_TPS
    ;mptblcname THRTCN
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis time_const 0 100 percent
    ;mptbldesc Throttle_Transient_Enrich_Time_Constant
    .byte 0x03                       ;Number of points in table
    .byte 0x74, 0x10, 0x00, 0x3E     ;Point 1
    .byte 0x95, 0x18, 0x00, 0x25     ;Point 2
    .byte 0xCD, 0x20                 ;Point 3
;.org 0x8C05
T_TimeConstant:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x1A29
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TimeConstant
    ;mptblcname LMAPTC
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis time_const 0 100 percent
    ;mptbldesc lean_out_time_constant_based_on_MAP
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x38                 ;Point 1
;.org 0x8C08
T_t8C08x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1A36
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8C08x
    ;mptblcname T8C08X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x8C0C
T_DecelLeanoutTimeConstant_FromTemp:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x1A42
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelLeanoutTimeConstant_FromTemp
    ;mptblcname LOTIME
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis time_const 0 100 percent
    ;mptbldesc Leanout_Time_Constant_based_on_Delta_THR_-_uses_average_throttle
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x1A                 ;Point 1
;.org 0x8C0F
T_t8C0Fx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1A4F
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8C0Fx
    ;mptblcname T8C0FX
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x8C13
T_NumLoopsForColdStartFuelEnrich:
    ;mpgrp Spark_-_Start_to_Run_Transfer\
    ;mptbladdr 0x1A5B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NumLoopsForColdStartFuelEnrich
    ;mptblcname CSFERX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Count 0 255 cnt
    ;mptbldesc Num_Loops_for_cold_start_reduction
    .byte 0x04                       ;Point 1
;.org 0x8C14
T_PercentForColdStartFuelEnrichment:
    ;mpgrp Fuel_-_Starting\
    ;mptbladdr 0x1A67
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname PercentForColdStartFuelEnrichment
    ;mptblcname PCCSFE
    ;mpxaxis Coolant_Temp -200 260 Degrees
    ;mpyaxis Factor 0 1 factor
    ;mptbldesc Description
    .byte 0x02                       ;Number of points in table
    .byte 0x16, 0x00, 0x44, 0x55     ;Point 1
    .byte 0x19, 0xCD                 ;Point 2
;.org 0x8C1B
T_t8C1Bx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1A75
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8C1Bx
    ;mptblcname T8C1BX
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x8C23
T_PumpingEfficiency_FromRpm:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x1A81
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname PumpingEfficiency_FromRpm
    ;mptblcname PEFTBL
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis PumpEff 0 100 Percent
    ;mptbldesc Pumping_Efficiency
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0xFF                 ;Point 1
;.org 0x8C26
T_t8C26x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1A8E
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8C26x
    ;mptblcname T8C26X
    ;mpxaxis Xinput 20 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
    .byte 0xFF                       ;Point 13
    .byte 0xFF                       ;Point 14
    .byte 0xFF                       ;Point 15
    .byte 0xFF                       ;Point 16
    .byte 0xFF                       ;Point 17
    .byte 0xFF                       ;Point 18
    .byte 0xFF                       ;Point 19
    .byte 0xFF                       ;Point 20
;.org 0x8C3A
T_PumpingEfficiency2_FromRpm:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x1A9B
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname PumpingEfficiency2_FromRpm
    ;mptblcname PEFTBL2
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis PumpEff 0 100 Percent
    ;mptbldesc Pumping_Efficiency
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0xFF                 ;Point 1
;.org 0x8C3D
T_t8C3Dx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1AA8
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8C3Dx
    ;mptblcname T8C3DX
    ;mpxaxis Xinput 12 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
;.org 0x8C49
T_EnrichmentFromTotalKnock:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x1AB4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EnrichmentFromTotalKnock
    ;mptblcname KNNRCH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Multiplied_by_total_knock_to_calculate_knock_enrich_factor.
    .byte 0x05                       ;Point 1
;.org 0x8C4A
T_MaximumKnockEnrichment:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x1AC0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaximumKnockEnrichment
    ;mptblcname MAXKNR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis factor 0 1 factor
    ;mptbldesc Maximum_knock_enrich_factor.
    .byte 0x10                       ;Point 1
;.org 0x8C4B
T_t8C4Bx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1ACC
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8C4Bx
    ;mptblcname T8C4BX
    ;mpxaxis Xinput 1 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0x79                       ;Point 1
;.org 0x8C4C
T_SparkStartRunTransferPointRpm:
    ;mpgrp Spark_-_Start_to_Run_Transfer\
    ;mptbladdr 0x1AD8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkStartRunTransferPointRpm
    ;mptblcname STRNTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DistPW 0 2.55 mSec
    ;mptbldesc Start_to_Run_transfer_point
    .byte 0x59                       ;Point 1
;.org 0x8C4D
T_SparkRunStartTransferPointRpm:
    ;mpgrp Spark_-_Start_to_Run_Transfer\
    ;mptbladdr 0x1AE4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkRunStartTransferPointRpm
    ;mptblcname RNSTTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DistPW 0 2.55 mSec
    ;mptbldesc Run_to_Start_transfer_point
    .byte 0x8E                       ;Point 1
;.org 0x8C4E
T_SparkImmediateSwitchToRunAboveThisRpm:
    ;mpgrp Spark_-_Start_to_Run_Transfer\
    ;mptbladdr 0x1AF0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkImmediateSwitchToRunAboveThisRpm
    ;mptblcname SKAPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc Immediate_switch_to_Spark_RUN_mode_when_above_this_RPM
    .byte 0x48                       ;Point 1
;.org 0x8C4F
T_SparkEPPsNeededToBeAboveSR_Hot:
    ;mpgrp Spark_-_Start_to_Run_Transfer\
    ;mptbladdr 0x1AFC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkEPPsNeededToBeAboveSR_Hot
    ;mptblcname SRTIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_consecutive_EPPs_needed_to_be_above_Start_Run_when_hot
    .byte 0x04                       ;Point 1
;.org 0x8C50
T_SparkEPPsNeededToBeAboveSR_Cold:
    ;mpgrp Spark_-_Start_to_Run_Transfer\
    ;mptbladdr 0x1B08
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkEPPsNeededToBeAboveSR_Cold
    ;mptblcname SRTIME2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_consecutive_EPPs_needed_to_be_above_Start_Run_when_cold
    .byte 0x04                       ;Point 1
;.org 0x8C51
T_SparkTempSwitchPointFor_SRTIME:
    ;mpgrp Spark_-_Start_to_Run_Transfer\
    ;mptbladdr 0x1B14
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkTempSwitchPointFor_SRTIME
    ;mptblcname SRTMTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Engine_Temperature_switch_point_for_SRTIME
    .byte 0xB0                       ;Point 1
;.org 0x8C52
T_AdvanceFromMAPAndRPMWarmIdlePart:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x1B20
    ;mptbltype 7
    ;mpsubtype n
    ;mptbllname AdvanceFromMAPAndRPMWarmIdlePart
    ;mptblcname HOTMRP
    ;mpxaxis RPMSCL 608 6496 rpm
    ;mpyaxis MAPHI 0 127.5 deg
    ;mptbldesc desc
    ;mp3dxtable RPMSCL 
    ;mp3dytable MAPHI 
    .byte 0x11                       ;Number of rows in table
    .byte 0x11                       ;Number of cols in table
    .byte 0x80                       ;00 = unsigned, 80/FF = signed
    .byte 0x26, 0x26, 0x26, 0x26, 0x26, 0x26, 0x26, 0x26, 0x26, 0x26, 0x26, 0x26, 0x26, 0x29, 0x31, 0x3C, 0x3C ;Row 1
    .byte 0x26, 0x26, 0x26, 0x26, 0x26, 0x26, 0x26, 0x26, 0x2A, 0x38, 0x3A, 0x3E, 0x41, 0x46, 0x46, 0x46, 0x46 ;Row 2
    .byte 0x26, 0x26, 0x26, 0x26, 0x26, 0x26, 0x24, 0x24, 0x2A, 0x38, 0x3A, 0x3E, 0x41, 0x46, 0x46, 0x46, 0x46 ;Row 3
    .byte 0x26, 0x26, 0x26, 0x26, 0x26, 0x26, 0x27, 0x27, 0x2A, 0x34, 0x39, 0x3E, 0x41, 0x46, 0x46, 0x46, 0x46 ;Row 4
    .byte 0x26, 0x26, 0x26, 0x26, 0x26, 0x26, 0x27, 0x2A, 0x2A, 0x30, 0x38, 0x3D, 0x40, 0x46, 0x46, 0x46, 0x46 ;Row 5
    .byte 0x26, 0x26, 0x26, 0x26, 0x26, 0x24, 0x24, 0x24, 0x26, 0x2B, 0x30, 0x38, 0x3B, 0x41, 0x44, 0x44, 0x44 ;Row 6
    .byte 0x26, 0x26, 0x26, 0x26, 0x24, 0x22, 0x1E, 0x1E, 0x24, 0x26, 0x28, 0x2F, 0x37, 0x3C, 0x44, 0x44, 0x44 ;Row 7
    .byte 0x26, 0x26, 0x24, 0x22, 0x20, 0x1E, 0x1C, 0x1C, 0x20, 0x22, 0x25, 0x2B, 0x34, 0x39, 0x41, 0x3C, 0x3C ;Row 8
    .byte 0x26, 0x24, 0x22, 0x20, 0x1E, 0x1C, 0x1A, 0x1A, 0x1C, 0x1F, 0x22, 0x24, 0x29, 0x35, 0x3B, 0x3C, 0x3C ;Row 9
    .byte 0x26, 0x24, 0x22, 0x20, 0x1E, 0x1C, 0x17, 0x17, 0x18, 0x1B, 0x1E, 0x1F, 0x24, 0x31, 0x35, 0x3C, 0x3C ;Row 10
    .byte 0x26, 0x24, 0x22, 0x20, 0x1E, 0x1C, 0x14, 0x14, 0x14, 0x1A, 0x1A, 0x1A, 0x1E, 0x29, 0x33, 0x37, 0x37 ;Row 11
    .byte 0x08, 0x08, 0x08, 0x08, 0x08, 0x08, 0x09, 0x0D, 0x0D, 0x10, 0x10, 0x13, 0x16, 0x21, 0x27, 0x2E, 0x2E ;Row 12
    .byte 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x03, 0x05, 0x08, 0x08, 0x09, 0x0C, 0x0E, 0x15, 0x1D, 0x25, 0x25 ;Row 13
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x04, 0x07, 0x0A, 0x0C, 0x14, 0x19, 0x22, 0x22 ;Row 14
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x03, 0x08, 0x0A, 0x15, 0x1B, 0x20, 0x20 ;Row 15
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x07, 0x0A, 0x11, 0x1B, 0x1D, 0x1D ;Row 16
    .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x04, 0x0A, 0x11, 0x1B, 0x1B ;Row 17
;.org 0x8D76
T_BaseAdvanceFromMAPandCoolant3D:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x1B41
    ;mptbltype 17
    ;mpsubtype n
    ;mptbllname BaseAdvanceFromMAPandCoolant3D
    ;mptblcname BASADV
    ;mpxaxis Coolant_Temp -200 260 F
    ;mpyaxis MAPHI 0.8 100 factor
    ;mptbldesc desc
    ;mp3dxtable Coolant_Temp
    ;mp3dytable MAPHI 
    .byte 0x09                       ;Number of rows in table
    .byte 0x09                       ;Number of cols in table
    .byte 0x80                       ;00 = unsigned, 80/FF = signed
    .byte 0x60, 0x71, 0x79, 0x82, 0x8A, 0x90, 0x95, 0xB1, 0xB4 ;X-Axis Breakpoints
    .byte 0x06, 0x06, 0x06, 0x06, 0x06, 0x00, 0x00, 0x00, 0x00 ;Row 1
    .byte 0x06, 0x06, 0x06, 0x06, 0x06, 0x00, 0x00, 0x00, 0x00 ;Row 2
    .byte 0x06, 0x06, 0x06, 0x06, 0x06, 0xF6, 0xF6, 0xF6, 0x00 ;Row 3
    .byte 0x06, 0x06, 0x06, 0x06, 0x06, 0xF6, 0xF6, 0xF6, 0x00 ;Row 4
    .byte 0x06, 0x06, 0x06, 0x06, 0x06, 0xF6, 0xF6, 0xF6, 0x00 ;Row 5
    .byte 0x09, 0x09, 0x09, 0x09, 0x09, 0x02, 0x02, 0x02, 0x00 ;Row 6
    .byte 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x00 ;Row 7
    .byte 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x00 ;Row 8
    .byte 0x07, 0x07, 0x07, 0x07, 0x07, 0x04, 0x04, 0x04, 0x00 ;Row 9
;.org 0x8DD3
T_IdleAdvanceFromCoolantTemp2:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x1B5B
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname IdleAdvanceFromCoolantTemp2
    ;mptblcname IDLAD2
    ;mpxaxis Coolant -200 260 F
    ;mpyaxis Spark_Advance -64 64 Degrees
    ;mptbldesc Desc
    .byte 0x02                       ;Number of points in table
    .byte 0x84, 0x10, 0xFF, 0x6C     ;Point 1
    .byte 0xB1, 0xF6                 ;Point 2
;.org 0x8DDA
T_t8DDAx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1B69
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8DDAx
    ;mptblcname T8DDAX
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x8DE2
T_IdleAdvanceFromCoolantTemp:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x1B75
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname IdleAdvanceFromCoolantTemp
    ;mptblcname IDLADV
    ;mpxaxis Coolant -200 260 F
    ;mpyaxis Spark_Advance -64 64 Degrees
    ;mptbldesc Desc
    .byte 0x04                       ;Number of points in table
    .byte 0x6E, 0x10, 0xFF, 0x8C     ;Point 1
    .byte 0x84, 0x06, 0xFF, 0x77     ;Point 2
    .byte 0xB1, 0xEE, 0xFF, 0xBA     ;Point 3
    .byte 0xC7, 0xE8                 ;Point 4
;.org 0x8DF1
T_BaseAdvanceProductFromChargeTemp:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x1B85
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname BaseAdvanceProductFromChargeTemp
    ;mptblcname BASCHG
    ;mpxaxis ChargeTemp -200 260 F
    ;mpyaxis out 0 255 out
    ;mptbldesc Product_is_added_to_the_coolant_temp_base_advance.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1
;.org 0x8DF4
T_t8DF4x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1B92
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8DF4x
    ;mptblcname T8DF4X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x8DF8
T_BaseAdvanceProductFromMAP:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x1B9E
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname BaseAdvanceProductFromMAP
    ;mptblcname BASMAP
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis out 0 255 out
    ;mptbldesc Product_is_added_to_the_coolant_temp_base_advance.
    ;mpmapaxis x
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x01                 ;Point 1
;.org 0x8DFB
T_t8DFBx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1BAC
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8DFBx
    ;mptblcname T8DFBX
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x8DFF
T_RPMBreakPointForIdleAdvanceTable:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x1BB8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMBreakPointForIdleAdvanceTable
    ;mptblcname IDLADR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Engine_RPM 0 8192 rpm
    ;mptbldesc desc
    .byte 0x7D                       ;Point 1
;.org 0x8E00
T_ModifiedDeltaRPMFractionReducing_ThresholdA:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x1BC4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ModifiedDeltaRPMFractionReducing_ThresholdA
    ;mptblcname MDRPMA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x78                       ;Point 1
;.org 0x8E01
T_ModifiedDeltaRPMFractionReducing_ThresholdB:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x1BD0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ModifiedDeltaRPMFractionReducing_ThresholdB
    ;mptblcname MDRPMB
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x88                       ;Point 1
;.org 0x8E02
T_AdvanceAddedFromNegMAP:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x1BDC
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname AdvanceAddedFromNegMAP
    ;mptblcname ADVNGM
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Advance -64 64 deg
    ;mptbldesc Added_to_the_total_advance.
    ;mpmapaxis x
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1
;.org 0x8E05
T_t8E05x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1BEA
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8E05x
    ;mptblcname T8E05X
    ;mpxaxis Xinput 20 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
    .byte 0xFF                       ;Point 13
    .byte 0xFF                       ;Point 14
    .byte 0xFF                       ;Point 15
    .byte 0xFF                       ;Point 16
    .byte 0xFF                       ;Point 17
    .byte 0xFF                       ;Point 18
    .byte 0xFF                       ;Point 19
    .byte 0xFF                       ;Point 20
;.org 0x8E19
T_AdvanceFromMAPAndRPMWarmFull:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x1BF7
    ;mptbltype 7
    ;mpsubtype n
    ;mptbllname AdvanceFromMAPAndRPMWarmFull
    ;mptblcname WOTMRP
    ;mpxaxis RPMSCL 608 6496 rpm
    ;mpyaxis MAPHI 0 127.5 deg
    ;mptbldesc desc
    ;mp3dxtable RPMSCL 
    ;mp3dytable MAPHI 
    .byte 0x11                       ;Number of rows in table
    .byte 0x11                       ;Number of cols in table
    .byte 0x80                       ;00 = unsigned, 80/FF = signed
    .byte 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x34, 0x38, 0x3B, 0x3E, 0x41, 0x47, 0x4F, 0x5A, 0x5A ;Row 1
    .byte 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x34, 0x38, 0x3B, 0x3E, 0x41, 0x47, 0x4F, 0x5A, 0x5A ;Row 2
    .byte 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x34, 0x38, 0x3B, 0x3E, 0x41, 0x47, 0x4F, 0x5A, 0x5A ;Row 3
    .byte 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x34, 0x38, 0x3B, 0x3E, 0x41, 0x47, 0x4F, 0x5A, 0x5A ;Row 4
    .byte 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x34, 0x38, 0x3B, 0x3E, 0x41, 0x47, 0x4F, 0x5A, 0x5A ;Row 5
    .byte 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x34, 0x38, 0x3B, 0x3E, 0x41, 0x47, 0x4F, 0x5A, 0x5A ;Row 6
    .byte 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x34, 0x38, 0x3B, 0x3E, 0x41, 0x47, 0x4F, 0x57, 0x57 ;Row 7
    .byte 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x2C, 0x30, 0x32, 0x35, 0x39, 0x3E, 0x46, 0x4E, 0x4E ;Row 8
    .byte 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x1F, 0x23, 0x27, 0x2A, 0x2D, 0x30, 0x36, 0x3F, 0x48, 0x48 ;Row 9
    .byte 0x17, 0x17, 0x17, 0x17, 0x17, 0x17, 0x17, 0x17, 0x1B, 0x1F, 0x21, 0x24, 0x28, 0x2E, 0x35, 0x3C, 0x3C ;Row 10
    .byte 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, 0x16, 0x19, 0x1C, 0x1F, 0x22, 0x28, 0x2F, 0x36, 0x36 ;Row 11
    .byte 0x0C, 0x0C, 0x0C, 0x0C, 0x0C, 0x0D, 0x0D, 0x0E, 0x12, 0x14, 0x16, 0x19, 0x1C, 0x22, 0x29, 0x30, 0x30 ;Row 12
    .byte 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A, 0x0B, 0x0C, 0x10, 0x11, 0x13, 0x16, 0x19, 0x1E, 0x26, 0x2E, 0x2E ;Row 13
    .byte 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x0A, 0x0A, 0x0C, 0x0E, 0x10, 0x14, 0x17, 0x1C, 0x26, 0x24, 0x24 ;Row 14
    .byte 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x0A, 0x0B, 0x0D, 0x10, 0x12, 0x19, 0x23, 0x23, 0x23 ;Row 15
    .byte 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x06, 0x06, 0x08, 0x0C, 0x0E, 0x16, 0x23, 0x23, 0x23 ;Row 16
    .byte 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x02, 0x02, 0x04, 0x04, 0x06, 0x0A, 0x0C, 0x10, 0x16, 0x18, 0x18 ;Row 17
;.org 0x8F3D
T_AdvanceAddedFromOffThrotFuelEnrichTimer:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x1C18
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AdvanceAddedFromOffThrotFuelEnrichTimer
    ;mptblcname ADOTFN
    ;mpxaxis timer 0 255 count
    ;mpyaxis Advance -64 64 deg
    ;mptbldesc Added_to_the_total_advance.
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x00, 0x00, 0x27     ;Point 1
    .byte 0x0D, 0x02, 0x00, 0x1B     ;Point 2
    .byte 0x33, 0x06                 ;Point 3
;.org 0x8F48
T_t8F48x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1C27
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8F48x
    ;mptblcname T8F48X
    ;mpxaxis Xinput 12 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
;.org 0x8F54
T_AdvanceAddedFromO2FeedbackCounterLimitLow:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x1C33
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdvanceAddedFromO2FeedbackCounterLimitLow
    ;mptblcname ADO2CL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x9A                       ;Point 1
;.org 0x8F55
T_AdvanceAddedFromO2FeedbackCounterLimitHi:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x1C3F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdvanceAddedFromO2FeedbackCounterLimitHi
    ;mptblcname ADO2CH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x66                       ;Point 1
;.org 0x8F56
T_AdvanceAddedFromO2FeedbackCounter1:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x1C4B
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AdvanceAddedFromO2FeedbackCounter1
    ;mptblcname ADO2C1
    ;mpxaxis Counter 0 255 count
    ;mpyaxis Spark_Advance -64 64 Degrees
    ;mptbldesc Description
    .byte 0x03                       ;Number of points in table
    .byte 0x70, 0x04, 0xFF, 0xC0     ;Point 1
    .byte 0x80, 0x00, 0xFF, 0xC0     ;Point 2
    .byte 0x90, 0xFC                 ;Point 3
;.org 0x8F61
T_t8F61x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1C5A
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8F61x
    ;mptblcname T8F61X
    ;mpxaxis Xinput 12 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
;.org 0x8F6D
T_AdvanceAddedFromO2FeedbackCounter2:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x1C66
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AdvanceAddedFromO2FeedbackCounter2
    ;mptblcname ADO2C2
    ;mpxaxis Counter2 0 255 count
    ;mpyaxis Spark_Advance -64 64 Degrees
    ;mptbldesc Description
    .byte 0x03                       ;Number of points in table
    .byte 0x70, 0x06, 0xFF, 0xA0     ;Point 1
    .byte 0x80, 0x00, 0xFF, 0xA0     ;Point 2
    .byte 0x90, 0xFA                 ;Point 3
;.org 0x8F78
T_t8F78x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1C75
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8F78x
    ;mptblcname T8F78X
    ;mpxaxis Xinput 12 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
;.org 0x8F84
T_MinRpmforKnockRetard:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x1C81
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinRpmforKnockRetard
    ;mptblcname KNKRPM
    ;mpxaxis X 0 255 in
    ;mpyaxis RPM 0 8192 RPM
    ;mptbldesc Minimum_RPM_for_Knock_Retard
    .byte 0x20                       ;Point 1
;.org 0x8F85
T_DeltaAboveBaroFor_RTRDRT_and_KNKCNT_and_KNKCOR_incremented:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x1C8D
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaAboveBaroFor_RTRDRT_and_KNKCNT_and_KNKCOR_incremented
    ;mptblcname KNKOFS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc Delta_above_Baro_up_to_which_RTRDRT_(Retard_Rate)_is_used_and_KNKCNT_and_KNKCOR_are_incremented._Stock_is_5.4_psi.
    ;mpmapaxis y
    .byte 0x23                       ;Point 1
;.org 0x8F86
T_KnockRetardIncrProduct_NoBoostNoKnock:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x1C9A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardIncrProduct_NoBoostNoKnock
    ;mptblcname INNBNK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x08                       ;Point 1
;.org 0x8F87
T_KnockRetardIncrProduct_NoBoostSomeKnock:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x1CA6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardIncrProduct_NoBoostSomeKnock
    ;mptblcname INNBSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x07                       ;Point 1
;.org 0x8F88
T_KnockRetardIncrProduct_InBoostNoKnock:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x1CB2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardIncrProduct_InBoostNoKnock
    ;mptblcname INIBNK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x08                       ;Point 1
;.org 0x8F89
T_KnockRetardIncrProduct_InBoostSomeKnock:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x1CBE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardIncrProduct_InBoostSomeKnock
    ;mptblcname INIBSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x07                       ;Point 1
;.org 0x8F8A
T_KnockRetardIncrProduct_InBoostNoWGNoKnock:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x1CCA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardIncrProduct_InBoostNoWGNoKnock
    ;mptblcname INBNWN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x08                       ;Point 1
;.org 0x8F8B
T_KnockRetardIncrProduct_InBoostNoWGSomeKnock:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x1CD6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardIncrProduct_InBoostNoWGSomeKnock
    ;mptblcname INBNWS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x07                       ;Point 1
;.org 0x8F8C
T_KnockRetardIncreaseRate2:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x1CE2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardIncreaseRate2
    ;mptblcname INCSR2
    ;mpxaxis in_desc 0 255 retard
    ;mpyaxis Y 0 128 deg
    ;mptbldesc Increase_Rate._Recovery_from_Knock_Retard._Rate_is_1/2_engine_degree_every_INCSRT+1_*_11ms._Use_ONLY_0___1___3___7___f___1f___3f___7f_or_ff
    .byte 0x0F                       ;Point 1
;.org 0x8F8D
T_KnockRetardIncreaseRate:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x1CEE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardIncreaseRate
    ;mptblcname INCSRT
    ;mpxaxis in_desc 0 255 retard
    ;mpyaxis Y 0 128 deg
    ;mptbldesc Increase_Rate._Recovery_from_Knock_Retard._Rate_is_1/2_engine_degree_every_INCSRT+1_*_11ms._Use_ONLY_0___1___3___7___f___1f___3f___7f_or_ff
    .byte 0x0F                       ;Point 1
;.org 0x8F8E
T_KnockRetardRateNoBoost:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x1CFA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardRateNoBoost
    ;mptblcname RTRDRT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Deg 0 128 Degrees
    ;mptbldesc Retard_rate_from_Knock____no_boost._In_half_degreesn
    .byte 0x02                       ;Point 1
;.org 0x8F8F
T_t8F8Fx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1D06
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8F8Fx
    ;mptblcname T8F8FX
    ;mpxaxis Xinput 6 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0x1C                       ;Point 1
    .byte 0x80                       ;Point 2
    .byte 0x01                       ;Point 3
    .byte 0xDE                       ;Point 4
    .byte 0x60                       ;Point 5
    .byte 0xFF                       ;Point 6
;.org 0x8F95
T_MaxKnockRetard:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x1D12
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxKnockRetard
    ;mptblcname KNKLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Retard 0 128 Degrees
    ;mptbldesc Knock_Limit_in_1/2_degrees._MaxRetard_=_KNKLIM_if_throttle_is_above_THRKNK_and_RPM_is_below_KLMRPM
    .byte 0x05                       ;Point 1
;.org 0x8F96
T_DeltaAbove_MINTHR:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x1D1E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaAbove_MINTHR
    ;mptblcname THRKNK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis TPS 0 5 Volts
    ;mptbldesc Delta_above_MINTHR_for_knock_detect
    .byte 0x53                       ;Point 1
;.org 0x8F97
T_MinKnockDetectRpm:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x1D2A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinKnockDetectRpm
    ;mptblcname KLMRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 RPM
    ;mptbldesc RPMS_for_Knock
    .byte 0x20                       ;Point 1
;.org 0x8F98
T_MaxKnockRetardFromMap:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x1D36
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname MaxKnockRetardFromMap
    ;mptblcname RETMAX
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Max_Retard 0 128 degrees
    ;mptbldesc Maximum_Knock_Retard_from_Map
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x56, 0x06, 0x00, 0xE2     ;Point 1
    .byte 0x70, 0x1D                 ;Point 2
;.org 0x8F9F
T_t8F9Fx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1D45
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8F9Fx
    ;mptblcname T8F9FX
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x8FA3
T_KnockSensorVoltageForKnock_FromRpm:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x1D51
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname KnockSensorVoltageForKnock_FromRpm
    ;mptblcname DLTKNK
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis A2D 0 5 volts
    ;mptbldesc Input_from_the_knock_sensor_that_is_above_this_voltage_is_considered_Knock.
    .byte 0x05                       ;Number of points in table
    .byte 0x4E, 0x10, 0x00, 0xC6     ;Point 1
    .byte 0x8C, 0x40, 0x01, 0xAF     ;Point 2
    .byte 0xA2, 0x65, 0x00, 0xF7     ;Point 3
    .byte 0xBE, 0x80, 0x7F, 0x00     ;Point 4
    .byte 0xBF, 0xFF                 ;Point 5
;.org 0x8FB6
T_t8FB6x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1D62
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8FB6x
    ;mptblcname T8FB6X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x8FBA
T_AdaptiveRetardFromRPM:
    ;mpgrp Spark_-_Adaptive_Retard\
    ;mptbladdr 0x1D6E
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AdaptiveRetardFromRPM
    ;mptblcname ARRPM
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Spark_Retard 0 128 Degrees
    ;mptbldesc The_result_of_this_table_is_multiplied_by_#002b_(0____1/4____1/2____3/4____or_1)_and_subtracted_from_the_table_at_#8098
    .byte 0x06                       ;Number of points in table
    .byte 0x2F, 0x00, 0x00, 0x22     ;Point 1
    .byte 0x3E, 0x02, 0x00, 0x30     ;Point 2
    .byte 0x5E, 0x08, 0x00, 0x00     ;Point 3
    .byte 0x71, 0x08, 0xFF, 0xC3     ;Point 4
    .byte 0x8A, 0x02, 0xFF, 0xEC     ;Point 5
    .byte 0xA3, 0x00                 ;Point 6
;.org 0x8FD1
T_t8FD1x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1D80
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8FD1x
    ;mptblcname T8FD1X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x8FD5
T_AdaptiveRetardFromMAP:
    ;mpgrp Spark_-_Adaptive_Retard\
    ;mptbladdr 0x1D8C
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AdaptiveRetardFromMAP
    ;mptblcname ARMAP
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Spark_Retard 0 128 Degrees
    ;mptbldesc This_table_is_reduced_by_the_value_in_#002b_(0____1/4____1/2____3/4____or_1)_depending_on_the_boost_control_routine._And_the_result_is_subtracted_from_the_advance_calculated_by_8010_or_805b
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x85, 0x00, 0x00, 0x55     ;Point 1
    .byte 0x91, 0x04                 ;Point 2
;.org 0x8FDC
T_t8FDCx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1D9B
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8FDCx
    ;mptblcname T8FDCX
    ;mpxaxis Xinput 20 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
    .byte 0xFF                       ;Point 13
    .byte 0xFF                       ;Point 14
    .byte 0xFF                       ;Point 15
    .byte 0xFF                       ;Point 16
    .byte 0xFF                       ;Point 17
    .byte 0xFF                       ;Point 18
    .byte 0xFF                       ;Point 19
    .byte 0xFF                       ;Point 20
;.org 0x8FF0
T_AdaptiveRetard_MinMAPForAdjustment:
    ;mpgrp Spark_-_Adaptive_Retard\
    ;mptbladdr 0x1DA8
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AdaptiveRetard_MinMAPForAdjustment
    ;mptblcname ARMPIC
    ;mpxaxis IN 0 255 X
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc ff_disables_the_Adaptive_Knock_Retard
    ;mpmapaxis y
    .byte 0x79                       ;Point 1
;.org 0x8FF1
T_AdaptiveRetardIndexBase_80:
    ;mpgrp Spark_-_Adaptive_Retard\
    ;mptbladdr 0x1DB5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardIndexBase_80
    ;mptblcname ARINDX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x80                       ;Point 1
;.org 0x8FF2
T_AdaptiveRetardFactorSubtract:
    ;mpgrp Spark_-_Adaptive_Retard\
    ;mptbladdr 0x1DC1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardFactorSubtract
    ;mptblcname ARSUBC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x40                       ;Point 1
;.org 0x8FF3
T_AdaptiveRetardCounterMask:
    ;mpgrp Spark_-_Adaptive_Retard\
    ;mptbladdr 0x1DCD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardCounterMask
    ;mptblcname ARCMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x3F                       ;Point 1
;.org 0x8FF4
T_AdaptiveRetardTimeOver5psiBoost:
    ;mpgrp Spark_-_Adaptive_Retard\
    ;mptbladdr 0x1DD9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardTimeOver5psiBoost
    ;mptblcname ARTM5P
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0B                       ;Point 1
;.org 0x8FF5
T_TotalKnockRetardRef:
    ;mpgrp Spark_-_Adaptive_Retard\
    ;mptbladdr 0x1DE5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TotalKnockRetardRef
    ;mptblcname TOTKRT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis retard 0 127 degrees
    ;mptbldesc Detailed_Description
    .byte 0x0C                       ;Point 1
;.org 0x8FF6
T_AdaptiveRetardMinimumTemp:
    ;mpgrp Spark_-_Adaptive_Retard\
    ;mptbladdr 0x1DF1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardMinimumTemp
    ;mptblcname ARMINT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 degrees
    ;mptbldesc Detailed_Description
    .byte 0xB4                       ;Point 1
;.org 0x8FF7
T_AdaptiveRetardCounterMask2_00:
    ;mpgrp Spark_-_Adaptive_Retard\
    ;mptbladdr 0x1DFD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardCounterMask2_00
    ;mptblcname ARCMS2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1
;.org 0x8FF8
T_AdaptiveRetardCounterMask3_FF:
    ;mpgrp Spark_-_Adaptive_Retard\
    ;mptbladdr 0x1E09
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardCounterMask3_FF
    ;mptblcname ARCMS3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1
;.org 0x8FF9
T_DistributorFallingEdgeScaleForDwellTimeCalc:
    ;mpgrp Spark_-_Dwell\
    ;mptbladdr 0x1E15
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DistributorFallingEdgeScaleForDwellTimeCalc
    ;mptblcname DFEDTS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xA0                       ;Point 1
;.org 0x8FFA
T_MaximumKnockRetardPerCylinder:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x1E21
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MaximumKnockRetardPerCylinder
    ;mptblcname MAXRTD
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis retard 0 127 degrees
    ;mptbldesc Detailed_Description
    ;mpmapaxis x
    .byte 0x02                       ;Point 1
;.org 0x8FFB
T_t8FFBx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1E2E
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t8FFBx
    ;mptblcname T8FFBX
    ;mpxaxis Xinput 10 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0x56                       ;Point 1
    .byte 0x06                       ;Point 2
    .byte 0x00                       ;Point 3
    .byte 0xE2                       ;Point 4
    .byte 0x70                       ;Point 5
    .byte 0x1D                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
;.org 0x9005
T_AdaptiveRetardFactorSubtract2:
    ;mpgrp Spark_-_Adaptive_Retard\
    ;mptbladdr 0x1E3A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardFactorSubtract2
    ;mptblcname ARSUB2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1
;.org 0x9006
T_MinimumRPMForKnockSensorFaultSetting:
    ;mpgrp Setup_-_Knock_Sensor_Diag\
    ;mptbladdr 0x1E46
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumRPMForKnockSensorFaultSetting
    ;mptblcname KNKFRP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis EngineRPM 0 8192 rpm
    ;mptbldesc Detailed_Description
    .byte 0x9C                       ;Point 1
;.org 0x9007
T_KnockVoltsThresholdForFaultDetection:
    ;mpgrp Setup_-_Knock_Sensor_Diag\
    ;mptbladdr 0x1E52
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockVoltsThresholdForFaultDetection
    ;mptblcname KNKVLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis KnockVolts 0 5 volts
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Point 1
;.org 0x9008
T_MinimumMainLoopCountForKnockSensorFaultSetting:
    ;mpgrp Setup_-_Knock_Sensor_Diag\
    ;mptbladdr 0x1E5E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumMainLoopCountForKnockSensorFaultSetting
    ;mptblcname KNKCML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x1F                       ;Point 1
;.org 0x9009
T_MaximumBoostWhenKnockSensorFault:
    ;mpgrp Setup_-_Knock_Sensor_Diag\
    ;mptbladdr 0x1E6A
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MaximumBoostWhenKnockSensorFault
    ;mptblcname IPLBST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis boost 0 29.4 psi
    ;mptbldesc Max_allowed_boost_when_knock_sensor_fault_detected.
    ;mpmapaxis y
    .byte 0x46                       ;Point 1
;.org 0x900A
T_MinimumMAPforKnockRetard:
    ;mpgrp Setup_-_Knock_Retard\
    ;mptbladdr 0x1E77
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MinimumMAPforKnockRetard
    ;mptblcname KNKMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis boost 0 29.4 psi
    ;mptbldesc desc
    ;mpmapaxis y
    .byte 0x66                       ;Point 1
;.org 0x900B
T_TempAboveWhichSparkScatterIsActive:
    ;mpgrp Spark_-_Scatter_Control\
    ;mptbladdr 0x1E84
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TempAboveWhichSparkScatterIsActive
    ;mptblcname SSTEMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Temperature_above_which_spark_scatter_is_active._For_road_racing____the_MP_cal_has_this_set_to_0xfe._This_keeps_the_revs_higher_during_shifts.
    .byte 0x58                       ;Point 1
;.org 0x900C
T_ScatterInhibitTime:
    ;mpgrp Spark_-_Scatter_Control\
    ;mptbladdr 0x1E90
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ScatterInhibitTime
    ;mptblcname SSITIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Spark_Scatter_Inhibit_Time_in_11ms_per_bit
    .word 0x008B                     ;Point 1
;.org 0x900E
T_ScatterInhibitBelowThisSpeed:
    ;mpgrp Spark_-_Scatter_Control\
    ;mptbladdr 0x1E9C
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ScatterInhibitBelowThisSpeed
    ;mptblcname SSIPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Spark_Scatter_inhibited_below_this_speed._The_MP_MTX_cal_has_this_value_set_to_0xfe33_to_keep_the_revs_high_during_shifts.
    .word 0x0075                     ;Point 1
;.org 0x9010
T_SparkAdvanceAddedWhenRpmBelowControl2_FromDeltaRpm:
    ;mpgrp Spark_-_Scatter_Control\
    ;mptbladdr 0x1EA8
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname SparkAdvanceAddedWhenRpmBelowControl2_FromDeltaRpm
    ;mptblcname SPKAD2
    ;mpxaxis DeltaRPM 0 512 RPM
    ;mpyaxis Advance 0 128 degrees
    ;mptbldesc This_is_how_much_advance_is_added_to_increase_engine_speed.
    .byte 0x03                       ;Number of points in table
    .byte 0x76, 0x10, 0xFD, 0x9A     ;Point 1
    .byte 0x7B, 0x04, 0xFE, 0xAB     ;Point 2
    .byte 0x7E, 0x00                 ;Point 3
;.org 0x901B
T_t901Bx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1EB7
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t901Bx
    ;mptblcname T901BX
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x9023
T_SparkAdvanceAddedWhenRpmBelowControl_FromDeltaRpm:
    ;mpgrp Spark_-_Scatter_Control\
    ;mptbladdr 0x1EC3
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname SparkAdvanceAddedWhenRpmBelowControl_FromDeltaRpm
    ;mptblcname SPKADD
    ;mpxaxis DeltaRPM 0 512 RPM
    ;mpyaxis Advance 0 128 degrees
    ;mptbldesc This_is_how_much_advance_is_added_to_increase_engine_speed.
    .byte 0x04                       ;Number of points in table
    .byte 0x82, 0x00, 0x01, 0x55     ;Point 1
    .byte 0x85, 0x04, 0x00, 0xCD     ;Point 2
    .byte 0x8A, 0x08, 0x01, 0x4D     ;Point 3
    .byte 0x94, 0x15                 ;Point 4
;.org 0x9032
T_t9032x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1ED3
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t9032x
    ;mptblcname T9032X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x9036
T_MinimumRPMForDeltaRPMEvaluation:
    ;mpgrp Spark_-_Retard\
    ;mptbladdr 0x1EDF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumRPMForDeltaRPMEvaluation
    ;mptblcname MRPDRE
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis EngineRPM 0 8192 rpm
    ;mptbldesc Min_RPM_for_DetlaRPMRetard
    .byte 0x01                       ;Point 1
;.org 0x9037
T_Minumim_DeltaEngineRPM_1:
    ;mpgrp Spark_-_Retard\
    ;mptbladdr 0x1EEB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Minumim_DeltaEngineRPM_1
    ;mptblcname MDRPRE
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis EngineRPM 0 8192 rpm
    ;mptbldesc Min_DeltaRPM_for_DetlaRPMRetard
    .byte 0x08                       ;Point 1
;.org 0x9038
T_RetardFrom_DeltaEngineRPM_1_Subractor:
    ;mpgrp Spark_-_DeltaRPMRetard\
    ;mptbladdr 0x1EF7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RetardFrom_DeltaEngineRPM_1_Subractor
    ;mptblcname RDRSUB
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis EngineRPM 0 8192 rpm
    ;mptbldesc Subtracted_from_DetlaRPMRetard
    .byte 0xFE                       ;Point 1
;.org 0x9039
T_Minimum_CounterForDeltaRPMRetard:
    ;mpgrp Spark_-_DeltaRPMRetard\
    ;mptbladdr 0x1F03
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Minimum_CounterForDeltaRPMRetard
    ;mptblcname MNCNRP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x10                       ;Point 1
;.org 0x903A
T_RetardFrom_DeltaEngineRPM:
    ;mpgrp Spark_-_DeltaRPMRetard\
    ;mptbladdr 0x1F0F
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname RetardFrom_DeltaEngineRPM
    ;mptblcname RETDRP
    ;mpxaxis DeltaRPM 0 512 RPM
    ;mpyaxis Retard 0 128 degrees
    ;mptbldesc Retard_from_DeltaRPM.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x32                 ;Point 1
;.org 0x903D
T_t903Dx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1F1C
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t903Dx
    ;mptblcname T903DX
    ;mpxaxis Xinput 12 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
;.org 0x9049
T_MinimumMAPForRetardFromSpeed:
    ;mpgrp Spark_-_RetardFromSpeed\
    ;mptbladdr 0x1F28
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MinimumMAPForRetardFromSpeed
    ;mptblcname RTSPMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc desc
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1
;.org 0x904A
T_RetardFromSpeed:
    ;mpgrp Spark_-_DeltaRPMRetard\
    ;mptbladdr 0x1F35
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname RetardFromSpeed
    ;mptblcname RETSPD
    ;mpxaxis Speed 0 127 mph
    ;mpyaxis Retard 0 128 degrees
    ;mptbldesc Retard_from_Speed.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1
;.org 0x904D
T_t904Dx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1F42
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t904Dx
    ;mptblcname T904DX
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x9051
T_ConstantSparkAdvanceWhenSettingBasicTiming:
    ;mpgrp Idle_-_Special_setup\
    ;mptbladdr 0x1F4E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ConstantSparkAdvanceWhenSettingBasicTiming
    ;mptblcname SPKSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Advance 0 128 degrees
    ;mptbldesc Constant_spark_advance_setting_when_setting_basic_timing_(stock_12_degrees)
    .byte 0x0C                       ;Point 1
;.org 0x9052
T_ConstantSparkAdvanceWhenSettingMinThrottleOpening:
    ;mpgrp Idle_-_Special_setup\
    ;mptbladdr 0x1F5A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ConstantSparkAdvanceWhenSettingMinThrottleOpening
    ;mptblcname IDLSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Advance 0 128 degrees
    ;mptbldesc Constant_spark_advance_setting_when_setting_min_throttle_blade_opening_(actuator_test_#70)
    .byte 0x0C                       ;Point 1
;.org 0x9053
T_MAPLimitForTPSRetard_NoAR:
    ;mpgrp Spark_-_TPSRetard\
    ;mptbladdr 0x1F66
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MAPLimitForTPSRetard_NoAR
    ;mptblcname MAPLM1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc desc
    ;mpmapaxis y
    .byte 0x77                       ;Point 1
;.org 0x9054
T_RPMLimitForTPSRetard_NoAR:
    ;mpgrp Spark_-_TPSRetard\
    ;mptbladdr 0x1F73
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimitForTPSRetard_NoAR
    ;mptblcname RPMLM1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc desc
    .byte 0x10                       ;Point 1
;.org 0x9055
T_TPSLimitForTPSRetard_NoAR:
    ;mpgrp Spark_-_TPSRetard\
    ;mptbladdr 0x1F7F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TPSLimitForTPSRetard_NoAR
    ;mptblcname TPSLM1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis TPSVolts 0 5 volts
    ;mptbldesc desc
    .byte 0x10                       ;Point 1
;.org 0x9056
T_TPSFilterForTPSRetard_NoAR:
    ;mpgrp Spark_-_TPSRetard\
    ;mptbladdr 0x1F8B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TPSFilterForTPSRetard_NoAR
    ;mptblcname TPSFL1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x08                       ;Point 1
;.org 0x9057
T_RetardFromDeltaTPSOverMINTHR_NoAR:
    ;mpgrp Spark_-_TPSRetard\
    ;mptbladdr 0x1F97
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname RetardFromDeltaTPSOverMINTHR_NoAR
    ;mptblcname TPSRT1
    ;mpxaxis DeltaTPS 0 5 volts
    ;mpyaxis Retard 0 128 degrees
    ;mptbldesc Retard_from_deltaTPS.
    .byte 0x02                       ;Number of points in table
    .byte 0x05, 0x00, 0x01, 0x55     ;Point 1
    .byte 0x14, 0x14                 ;Point 2
;.org 0x905E
T_t905Ex:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1FA5
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t905Ex
    ;mptblcname T905EX
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x9062
T_MAPLimitForTPSRetard_WithAR:
    ;mpgrp Spark_-_TPSRetard\
    ;mptbladdr 0x1FB1
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MAPLimitForTPSRetard_WithAR
    ;mptblcname MAPLM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc desc
    ;mpmapaxis y
    .byte 0x77                       ;Point 1
;.org 0x9063
T_RPMLimitForTPSRetard_WithAR:
    ;mpgrp Spark_-_TPSRetard\
    ;mptbladdr 0x1FBE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimitForTPSRetard_WithAR
    ;mptblcname RPMLM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc desc
    .byte 0x10                       ;Point 1
;.org 0x9064
T_TPSLimitForTPSRetard_WithAR:
    ;mpgrp Spark_-_TPSRetard\
    ;mptbladdr 0x1FCA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TPSLimitForTPSRetard_WithAR
    ;mptblcname TPSLM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis TPSVolts 0 5 volts
    ;mptbldesc desc
    .byte 0x10                       ;Point 1
;.org 0x9065
T_TPSFilterForTPSRetard_WithAR:
    ;mpgrp Spark_-_TPSRetard\
    ;mptbladdr 0x1FD6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TPSFilterForTPSRetard_WithAR
    ;mptblcname TPSFL2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x08                       ;Point 1
;.org 0x9066
T_RetardFromDeltaTPSOverMINTHR_WithAR2:
    ;mpgrp Spark_-_TPSRetard\
    ;mptbladdr 0x1FE2
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname RetardFromDeltaTPSOverMINTHR_WithAR2
    ;mptblcname TPSRT2
    ;mpxaxis DeltaTPS 0 5 volts
    ;mpyaxis Retard 0 128 degrees
    ;mptbldesc Retard_from_deltaTPS.
    .byte 0x02                       ;Number of points in table
    .byte 0x05, 0x00, 0x01, 0x55     ;Point 1
    .byte 0x14, 0x14                 ;Point 2
;.org 0x906D
T_t906Dx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x1FF0
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t906Dx
    ;mptblcname T906DX
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x9071
T_DeltaRPMFactorFromModifiedDeltaRPMOverIdle:
    ;mpgrp Idle_-AIS_RPM_Error\
    ;mptbladdr 0x1FFC
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DeltaRPMFactorFromModifiedDeltaRPMOverIdle
    ;mptblcname RPMFC1
    ;mpxaxis DeltaRPM 0 8192 rpm
    ;mpyaxis DeltaRPM 0 8192 rpm
    ;mptbldesc desc
    .byte 0x08                       ;Number of points in table
    .byte 0x24, 0xAF, 0xFE, 0xAB     ;Point 1
    .byte 0x30, 0x9F, 0xFE, 0x10     ;Point 2
    .byte 0x40, 0x80, 0xFD, 0x90     ;Point 3
    .byte 0x50, 0x59, 0xFE, 0xAB     ;Point 4
    .byte 0x5C, 0x49, 0xFF, 0x36     ;Point 5
    .byte 0x6F, 0x3A, 0xFF, 0x79     ;Point 6
    .byte 0xBD, 0x11, 0xFE, 0xF0     ;Point 7
    .byte 0xCD, 0x00                 ;Point 8
;.org 0x9090
T_FactorForRPMFC1_75percent:
    ;mpgrp Idle_-AIS_RPM_Error\
    ;mptbladdr 0x2010
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FactorForRPMFC1_75percent
    ;mptblcname RPMFC2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis factor 0 100 percent
    ;mptbldesc desc
    .byte 0xC0                       ;Point 1
;.org 0x9091
T_FactorForDeltaRPMOverDistPWFraction_25percent:
    ;mpgrp Idle_-AIS_RPM_Error\
    ;mptbladdr 0x201C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FactorForDeltaRPMOverDistPWFraction_25percent
    ;mptblcname RPMFC3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis factor 0 100 percent
    ;mptbldesc desc
    .byte 0x40                       ;Point 1
;.org 0x9092
T_FactorIdleSpeedControlFromCoolant:
    ;mpgrp Idle_-AIS_RPM_Error\
    ;mptbladdr 0x2028
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FactorIdleSpeedControlFromCoolant
    ;mptblcname IDLFC1
    ;mpxaxis Coolant_Temp -200 260 F
    ;mpyaxis Factor 0 100 percent
    ;mptbldesc desc
    .byte 0x02                       ;Number of points in table
    .byte 0xB1, 0x1F, 0xFE, 0xE5     ;Point 1
    .byte 0xCD, 0x00                 ;Point 2
;.org 0x9099
T_t9099x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x2036
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t9099x
    ;mptblcname T9099X
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x90A1
T_FactorIdleSpeedControlFromMAP:
    ;mpgrp Idle_-AIS_RPM_Error\
    ;mptbladdr 0x2042
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FactorIdleSpeedControlFromMAP
    ;mptblcname IDLFC2
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Factor 0 100 percent
    ;mptbldesc desc
    ;mpmapaxis x
    .byte 0x04                       ;Number of points in table
    .byte 0x19, 0x7F, 0xFC, 0x55     ;Point 1
    .byte 0x22, 0x5E, 0x00, 0x00     ;Point 2
    .byte 0x44, 0x5E, 0xFE, 0x2D     ;Point 3
    .byte 0x55, 0x3F                 ;Point 4
;.org 0x90B0
T_AISModifierFromDeltaRPMToTargetIdleSigned_Pos:
    ;mpgrp Idle_-AIS_RPM_Error\
    ;mptbladdr 0x2053
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AISModifierFromDeltaRPMToTargetIdleSigned_Pos
    ;mptblcname AISMD1
    ;mpxaxis DeltaRPM 0 8192 rpm
    ;mpyaxis Factor 0 100 percent
    ;mptbldesc desc
    .byte 0x04                       ;Number of points in table
    .byte 0x00, 0x03, 0x00, 0x00     ;Point 1
    .byte 0x10, 0x02, 0x00, 0x00     ;Point 2
    .byte 0x68, 0x01, 0x00, 0x00     ;Point 3
    .byte 0x7C, 0x00                 ;Point 4
;.org 0x90BF
T_AISModifierFromModifiedDeltaRPMOverIdle_Pos:
    ;mpgrp Idle_-AIS_RPM_Error\
    ;mptbladdr 0x2063
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AISModifierFromModifiedDeltaRPMOverIdle_Pos
    ;mptblcname AISMD2
    ;mpxaxis DeltaRPM 0 8192 rpm
    ;mpyaxis Factor 0 100 percent
    ;mptbldesc desc
    .byte 0x02                       ;Number of points in table
    .byte 0x58, 0x00, 0xF5, 0x55     ;Point 1
    .byte 0x64, 0x80                 ;Point 2
;.org 0x90C6
T_t90C6x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x2071
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t90C6x
    ;mptblcname T90C6X
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x90CE
T_AisColdPosition_FromTemp2:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x207D
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisColdPosition_FromTemp2
    ;mptblcname CLDPS2
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis AIS_Open 0 2048 steps
    ;mptbldesc Cold_OffIdle_AIS_Positioning____Increases_instantly____decreases_after_DLYOFI
    .byte 0x03                       ;Number of points in table
    .byte 0x7F, 0x42, 0xFF, 0x17     ;Point 1
    .byte 0xB6, 0x10, 0xFF, 0xB7     ;Point 2
    .byte 0xD2, 0x08                 ;Point 3
;.org 0x90D9
T_t90D9x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x208C
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t90D9x
    ;mptblcname T90D9X
    ;mpxaxis Xinput 1 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0x00                       ;Point 1
;.org 0x90DA
T_AISModifierFromDeltaRPMToTargetIdleSigned_Neg:
    ;mpgrp Idle_-AIS_RPM_Error\
    ;mptbladdr 0x2098
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AISModifierFromDeltaRPMToTargetIdleSigned_Neg
    ;mptblcname AISMD3
    ;mpxaxis DeltaRPM 0 8192 rpm
    ;mpyaxis Factor 0 100 percent
    ;mptbldesc desc
    .byte 0x04                       ;Number of points in table
    .byte 0x80, 0x00, 0x00, 0x00     ;Point 1
    .byte 0x84, 0x01, 0x00, 0x00     ;Point 2
    .byte 0xA0, 0x02, 0x00, 0x00     ;Point 3
    .byte 0xF0, 0x03                 ;Point 4
;.org 0x90E9
T_AISModifierFromModifiedDeltaRPMOverIdle_Neg:
    ;mpgrp Idle_-AIS_RPM_Error\
    ;mptbladdr 0x20A8
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AISModifierFromModifiedDeltaRPMOverIdle_Neg
    ;mptblcname AISMD4
    ;mpxaxis DeltaRPM 0 8192 rpm
    ;mpyaxis Factor 0 100 percent
    ;mptbldesc desc
    .byte 0x04                       ;Number of points in table
    .byte 0x33, 0x80, 0x12, 0x49     ;Point 1
    .byte 0x3A, 0x00, 0x00, 0x00     ;Point 2
    .byte 0x8B, 0x00, 0xFC, 0x9A     ;Point 3
    .byte 0xBD, 0x56                 ;Point 4
;.org 0x90F8
T_IdleControlCounterInit1:
    ;mpgrp Idle_-AIS_Control\
    ;mptbladdr 0x20B8
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname IdleControlCounterInit1
    ;mptblcname ICCNT1
    ;mpxaxis Coolant_Temp -200 260 F
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x03                       ;Number of points in table
    .byte 0x79, 0x2F, 0xFD, 0xD1     ;Point 1
    .byte 0x84, 0x17, 0xFE, 0x00     ;Point 2
    .byte 0x8D, 0x05                 ;Point 3
;.org 0x9103
T_t9103x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x20C7
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t9103x
    ;mptblcname T9103X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x9107
T_IdleControlCounterInit2:
    ;mpgrp Idle_-AIS_Control\
    ;mptbladdr 0x20D3
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname IdleControlCounterInit2
    ;mptblcname ICCNT2
    ;mpxaxis Coolant_Temp -200 260 F
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x03                       ;Number of points in table
    .byte 0x63, 0x10, 0xFF, 0xD1     ;Point 1
    .byte 0x79, 0x0C, 0xFF, 0xA6     ;Point 2
    .byte 0x8D, 0x05                 ;Point 3
;.org 0x9112
T_t9112x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x20E2
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t9112x
    ;mptblcname T9112X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x9116
T_AmbientTempAISCompensation:
    ;mpgrp Idle_-AIS_Control\
    ;mptbladdr 0x20EE
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AmbientTempAISCompensation
    ;mptblcname AMBAIS
    ;mpxaxis Ambient_Temp -200 260 F
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x03                       ;Number of points in table
    .byte 0x80, 0x0A, 0x00, 0x8E     ;Point 1
    .byte 0x9B, 0x19, 0x00, 0xE9     ;Point 2
    .byte 0xB1, 0x2D                 ;Point 3
;.org 0x9121
T_MinimumCounterAISAC:
    ;mpgrp Idle_-AIS_ACControl\
    ;mptbladdr 0x20FD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumCounterAISAC
    ;mptblcname MINACC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x11                       ;Point 1
;.org 0x9122
T_TimeBeforeAcEnabledAndFullDeltaUsed2:
    ;mpgrp Idle_-AIS_ACControl\
    ;mptbladdr 0x2109
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBeforeAcEnabledAndFullDeltaUsed2
    ;mptblcname ACTIM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x10                       ;Point 1
;.org 0x9123
T_OffsetTimeBeforeAcEnabledAndFullDeltaUsed:
    ;mpgrp Idle_-AIS_ACControl\
    ;mptbladdr 0x2115
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OffsetTimeBeforeAcEnabledAndFullDeltaUsed
    ;mptblcname ACTOFS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x08                       ;Point 1
;.org 0x9124
T_TimeBeforeAcEnabledAndFullDeltaUsed_Default:
    ;mpgrp Idle_-AIS_ACControl\
    ;mptbladdr 0x2121
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBeforeAcEnabledAndFullDeltaUsed_Default
    ;mptblcname ACTDEF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x20                       ;Point 1
;.org 0x9125
T_MinimumMainLoopCounterForAISACComp:
    ;mpgrp Idle_-AIS_ACControl\
    ;mptbladdr 0x212D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumMainLoopCounterForAISACComp
    ;mptblcname MINMLC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x1F                       ;Point 1
;.org 0x9126
T_Timer_AcClutchEngageRestrictionTimerFactorA:
    ;mpgrp Idle_-AIS_ACControl\
    ;mptbladdr 0x2139
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Timer_AcClutchEngageRestrictionTimerFactorA
    ;mptblcname TFCACA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x13                       ;Point 1
;.org 0x9127
T_AISPOSIncrementForSW2b7:
    ;mpgrp Idle_-AIS_ACControl\
    ;mptbladdr 0x2145
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AISPOSIncrementForSW2b7
    ;mptblcname AISINC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x04                       ;Point 1
;.org 0x9128
T_Timer_AcClutchEngageRestrictionTimerFactorB:
    ;mpgrp Idle_-AIS_ACControl\
    ;mptbladdr 0x2151
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Timer_AcClutchEngageRestrictionTimerFactorB
    ;mptblcname TFCACB
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x0C                       ;Point 1
;.org 0x9129
T_AdvanceDownCoutnerInitial:
    ;mpgrp Idle_-AIS_ACControl\
    ;mptbladdr 0x215D
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AdvanceDownCoutnerInitial
    ;mptblcname ADCINT
    ;mpxaxis Coolant_Temp -200 260 F
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc desc
    .byte 0x03                       ;Number of points in table
    .byte 0x63, 0x5D, 0xFD, 0xE9     ;Point 1
    .byte 0x79, 0x2F, 0xFE, 0xCD     ;Point 2
    .byte 0x8D, 0x17                 ;Point 3
;.org 0x9134
T_t9134x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x216C
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t9134x
    ;mptblcname T9134X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x9138
T_ClosedThrottleAcOffKick:
    ;mpgrp Idle_-AIS_ACControl\
    ;mptbladdr 0x2178
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname ClosedThrottleAcOffKick
    ;mptblcname ACOFFK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x0A, 0x0A, 0x01, 0x14     ;Point 1
    .byte 0x31, 0x34                 ;Point 2
;.org 0x913F
T_t913Fx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x2186
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t913Fx
    ;mptblcname T913FX
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x9147
T_TimeBeforeAcEnabledAndFullDeltaUsedFromACCompFactor:
    ;mpgrp Idle_-AIS_ACControl\
    ;mptbladdr 0x2192
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname TimeBeforeAcEnabledAndFullDeltaUsedFromACCompFactor
    ;mptblcname ACTIMX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x0A, 0x06, 0x00, 0xF9     ;Point 1
    .byte 0x31, 0x2C                 ;Point 2
;.org 0x914E
T_t914Ex:
    ;mpgrp Unassigned\
    ;mptbladdr 0x21A0
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t914Ex
    ;mptblcname T914EX
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x9156
T_ACFactorDeltaFromBase:
    ;mpgrp Idle_-AIS_ACControl\
    ;mptbladdr 0x21AC
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname ACFactorDeltaFromBase
    ;mptblcname DAACF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x0A, 0x08, 0x00, 0x69     ;Point 1
    .byte 0x2C, 0x16                 ;Point 2
;.org 0x915D
T_t915Dx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x21BA
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t915Dx
    ;mptblcname T915DX
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x9165
T_AisStartupPosition_FromTemp:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x21C6
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisStartupPosition_FromTemp
    ;mptblcname AISTRT
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis AIS_Open 0 255 steps
    ;mptbldesc AIS_motor_startup_position_from_engine_temp
    .byte 0x04                       ;Number of points in table
    .byte 0x69, 0x86, 0xFC, 0x25     ;Point 1
    .byte 0x77, 0x50, 0xFF, 0x5D     ;Point 2
    .byte 0xA6, 0x32, 0xFF, 0x83     ;Point 3
    .byte 0xCF, 0x1E                 ;Point 4
;.org 0x9174
T_t9174x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x21D6
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t9174x
    ;mptblcname T9174X
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x917C
T_RPMDefaultForIdleControl:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x21E2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMDefaultForIdleControl
    ;mptblcname RPMDEF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc Detailed_Description
    .byte 0xA0                       ;Point 1
;.org 0x917D
T_RPMThresholdForIdleControl:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x21EE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMThresholdForIdleControl
    ;mptblcname RPMTHS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc Detailed_Description
    .byte 0x0D                       ;Point 1
;.org 0x917E
T_DecelAisBaseAirflowCurveOffset_FromTime2:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x21FA
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
;.org 0x9185
T_t9185x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x2208
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t9185x
    ;mptblcname T9185X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x9189
T_DelayFromStartRunThatAisFeedbackDisabled:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x2214
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DelayFromStartRunThatAisFeedbackDisabled
    ;mptblcname AISDLY
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 720 sec
    ;mptbldesc Delay_from_Start/Run_transition_that_AIS_feedback_is_disabled_in_11msec_units
    .byte 0x4B                       ;Point 1
;.org 0x918A
T_IdleSpeedParkNeutral_FromTemp:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x2220
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname IdleSpeedParkNeutral_FromTemp
    ;mptblcname AISPN
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis RPM 0 2048 rpm
    ;mptbldesc Idle_Speed_From_Temp_in_park/neutral_or_manual_trans
    .byte 0x03                       ;Number of points in table
    .byte 0x6E, 0xA3, 0xFF, 0x3C     ;Point 1
    .byte 0x7F, 0x96, 0xFF, 0x54     ;Point 2
    .byte 0xB6, 0x71                 ;Point 3
;.org 0x9195
T_IdleSpeedDrive_FromTemp:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x222F
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname IdleSpeedDrive_FromTemp
    ;mptblcname AISCLD
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis RPM 0 2048 rpm
    ;mptbldesc Idle_Speed_From_temp_in_Drive____auto_trans_only
    .byte 0x03                       ;Number of points in table
    .byte 0x63, 0x96, 0xFF, 0x1B     ;Point 1
    .byte 0x7F, 0x7D, 0xFF, 0x8C     ;Point 2
    .byte 0xB6, 0x64                 ;Point 3
;.org 0x91A0
T_AisColdPosition_FromTemp:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x223E
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisColdPosition_FromTemp
    ;mptblcname CLDPOS
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis AIS_Open 0 2048 steps
    ;mptbldesc Cold_OffIdle_AIS_Positioning____Increases_instantly____decreases_after_DLYOFI
    .byte 0x05                       ;Number of points in table
    .byte 0x69, 0x86, 0xFC, 0x00     ;Point 1
    .byte 0x74, 0x5A, 0xFE, 0xAB     ;Point 2
    .byte 0x92, 0x32, 0xFF, 0x40     ;Point 3
    .byte 0xA6, 0x23, 0xFF, 0x40     ;Point 4
    .byte 0xD2, 0x02                 ;Point 5
;.org 0x91B3
T_t91B3x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x224F
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t91B3x
    ;mptblcname T91B3X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x91B7
T_AisPosition_FromRpm:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x225B
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisPosition_FromRpm
    ;mptblcname RPMPOS
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc AIS_Position_from_RPMs
    .byte 0x03                       ;Number of points in table
    .byte 0x1F, 0x00, 0x00, 0x30     ;Point 1
    .byte 0x2F, 0x03, 0x00, 0x21     ;Point 2
    .byte 0x46, 0x06                 ;Point 3
;.org 0x91C2
T_t91C2x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x226A
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t91C2x
    ;mptblcname T91C2X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x91C6
T_AisPosition_FromThrottle:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x2276
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisPosition_FromThrottle
    ;mptblcname THRPOS
    ;mpxaxis TPS 0 5 Volts
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc AIS_Position_from_throttle
    .byte 0x02                       ;Number of points in table
    .byte 0x03, 0x00, 0x00, 0x6B     ;Point 1
    .byte 0x0F, 0x05                 ;Point 2
;.org 0x91CD
T_t91CDx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x2284
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t91CDx
    ;mptblcname T91CDX
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x91D5
T_ACOffIdleDelta_FromSpeed:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x2290
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ACOffIdleDelta_FromSpeed
    ;mptblcname ACCTBL
    ;mpxaxis Speed 0 128 mph
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x32, 0x19, 0x00, 0x91     ;Point 1
    .byte 0x50, 0x2A, 0x00, 0x3A     ;Point 2
    .byte 0xA0, 0x3C                 ;Point 3
;.org 0x91E0
T_t91E0x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x229F
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t91E0x
    ;mptblcname T91E0X
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x91E8
T_Use_ACCTBL_WhenTempAboveThisElseUse_ACPOS:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x22AB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Use_ACCTBL_WhenTempAboveThisElseUse_ACPOS
    ;mptblcname ACTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x7F                       ;Point 1
;.org 0x91E9
T_UpdateRateOffIdleWhenAisClosing:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x22B7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UpdateRateOffIdleWhenAisClosing
    ;mptblcname DLYOF1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x07                       ;Point 1
;.org 0x91EA
T_AISAddedFromTimeEngRunning:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x22C3
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AISAddedFromTimeEngRunning
    ;mptblcname ADDAIS
    ;mpxaxis TimeEngRun 0 2.8 sec
    ;mpyaxis Factor 0 1 scale
    ;mptbldesc Description
    .byte 0x03                       ;Number of points in table
    .byte 0x03, 0x10, 0xFF, 0x00     ;Point 1
    .byte 0x0B, 0x08, 0xFF, 0x46     ;Point 2
    .byte 0x16, 0x00                 ;Point 3
;.org 0x91F5
T_t91F5x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x22D2
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t91F5x
    ;mptblcname T91F5X
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x91FD
T_BaroCompensation_FromBaro:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x22DE
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
;.org 0x9204
T_t9204x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x22ED
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t9204x
    ;mptblcname T9204X
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x920C
T_RPMThresholdFromTPSOverMIN:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x22F9
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname RPMThresholdFromTPSOverMIN
    ;mptblcname RPTHTP
    ;mpxaxis TPS 0 5 volts
    ;mpyaxis RPMThreshold 0 8192 rpm
    ;mptbldesc Description
    .byte 0x03                       ;Number of points in table
    .byte 0x03, 0x45, 0x02, 0x49     ;Point 1
    .byte 0x0A, 0x55, 0x01, 0x44     ;Point 2
    .byte 0x28, 0x7B                 ;Point 3
;.org 0x9217
T_t9217x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x2308
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t9217x
    ;mptblcname T9217X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x921B
T_DecelAisBaseAirflowCurveOffset_FromTime:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x2314
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelAisBaseAirflowCurveOffset_FromTime
    ;mptblcname TIMEDC
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis Time 0 720 sec
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x03, 0x08, 0xFF, 0x55     ;Point 1
    .byte 0x06, 0x06, 0xFF, 0x66     ;Point 2
    .byte 0x10, 0x00                 ;Point 3
;.org 0x9226
T_t9226x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x2323
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t9226x
    ;mptblcname T9226X
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x922A
T_DecelAis_FromTemp:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x232F
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelAis_FromTemp
    ;mptblcname TEMPDC
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Number of points in table
    .byte 0x63, 0x40, 0xFF, 0x17     ;Point 1
    .byte 0x90, 0x17, 0xFF, 0xB9     ;Point 2
    .byte 0xCA, 0x07, 0xFF, 0x20     ;Point 3
    .byte 0xD2, 0x00                 ;Point 4
;.org 0x9239
T_t9239x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x233F
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t9239x
    ;mptblcname T9239X
    ;mpxaxis Xinput 12 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
;.org 0x9245
T_DecelAisOpenStepsFromNeg_FromDeltaMap:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x234B
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname DecelAisOpenStepsFromNeg_FromDeltaMap
    ;mptblcname DAISOP
    ;mpxaxis DeltaMAP 0 29.4 psi
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Decel_AIS_open_steps_from_-Delta_MAP
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x01, 0x00, 0x01, 0x00     ;Point 1
    .byte 0x0C, 0x0B                 ;Point 2
;.org 0x924C
T_t924Cx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x235A
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t924Cx
    ;mptblcname T924CX
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x9254
T_DecelAisOpenStepsFromPos_FromDeltaMap:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x2366
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
;.org 0x925B
T_t925Bx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x2375
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t925Bx
    ;mptblcname T925BX
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x9263
T_AdditionToControlMap_FromRpm:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x2381
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AdditionToControlMap_FromRpm
    ;mptblcname MAPFLR
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc AIS_Decel_Addition_to_control_MAP_vs._RPM
    .byte 0x02                       ;Number of points in table
    .byte 0x23, 0x00, 0x00, 0x2B     ;Point 1
    .byte 0x2F, 0x02                 ;Point 2
;.org 0x926A
T_t926Ax:
    ;mpgrp Unassigned\
    ;mptbladdr 0x238F
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t926Ax
    ;mptblcname T926AX
    ;mpxaxis Xinput 12 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
;.org 0x9276
T_TempTermForMapOffset_FromTemp:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x239B
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
;.org 0x927D
T_t927Dx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x23A9
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t927Dx
    ;mptblcname T927DX
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x9285
T_OffsetCorrectionTo_MAPFLR_FromBaro:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x23B5
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
;.org 0x9288
T_t9288x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x23C3
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t9288x
    ;mptblcname T9288X
    ;mpxaxis Xinput 12 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
    .byte 0xFF                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11
    .byte 0xFF                       ;Point 12
;.org 0x9294
T_TimeBetweenAisPulsesForDecelAis:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x23CF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBetweenAisPulsesForDecelAis
    ;mptblcname DCLRFQ
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 Sec
    ;mptbldesc Detailed_Description
    .byte 0x17                       ;Point 1
;.org 0x9295
T_EngineTempToStartCalibratingDacal:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x23DB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineTempToStartCalibratingDacal
    ;mptblcname DATHOT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Deg
    ;mptbldesc Detailed_Description
    .byte 0xCD                       ;Point 1
;.org 0x9296
T_DeltaRpmFromIdleSpeedForDacalUpdate:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x23E7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaRpmFromIdleSpeedForDacalUpdate
    ;mptblcname DADRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1
;.org 0x9297
T_Base_nominalCal:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x23F3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Base_nominalCal
    ;mptblcname DANOM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1
;.org 0x9298
T_DacalInhibitTimeAfterStartup:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x23FF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DacalInhibitTimeAfterStartup
    ;mptblcname DCALTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x16                       ;Point 1
;.org 0x9299
T_DacalUpdateRate01_03_07_0f_1f_3f_7f_ff:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x240B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DacalUpdateRate01_03_07_0f_1f_3f_7f_ff
    ;mptblcname DCALRT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x7F                       ;Point 1
;.org 0x929A
T_MinLimitOnDecelAisControlledMap:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x2417
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinLimitOnDecelAisControlledMap
    ;mptblcname DCLMIN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1
;.org 0x929B
T_NoAisControlIfMapAndControlMapBelowThis:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x2423
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname NoAisControlIfMapAndControlMapBelowThis
    ;mptblcname DCLMN2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x16                       ;Point 1
;.org 0x929C
T_AisDelayAfterThrottleClosesWhenMoving:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x2430
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisDelayAfterThrottleClosesWhenMoving
    ;mptblcname DLYTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Decel_AIS_Delay_after_throttle_closes_when_moving
    .byte 0x8C                       ;Point 1
;.org 0x929D
T_AisDelayAfterThrottleClosesWhenStopped:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x243C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisDelayAfterThrottleClosesWhenStopped
    ;mptblcname DLYTIM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Decel_AIS_Delay_after_throttle_closes_when_stopped
    .byte 0x30                       ;Point 1
;.org 0x929E
T_AisDelayAfterThrottleClosesWhenRpmAbove_DLYRPM:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x2448
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisDelayAfterThrottleClosesWhenRpmAbove_DLYRPM
    ;mptblcname DLYTM3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Decel_AIS_Delay_after_throttle_closes_when_MAP_is_below_DCLMN2
    .byte 0x51                       ;Point 1
;.org 0x929F
T_RpmTriggerForAisDelay:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x2454
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RpmTriggerForAisDelay
    ;mptblcname DLYRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 rpm
    ;mptbldesc Decel_AIS_RPM_trigger_(third_AIS_delay)
    .byte 0x5E                       ;Point 1
;.org 0x92A0
T_SwitchPointForDecelIdleAisControl:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x2460
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SwitchPointForDecelIdleAisControl
    ;mptblcname MPHREF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 128 mph
    ;mptbldesc Switch_point_between_Decel_or_Idle_AIS_control._Note_there_is_also_a_1.5_mph_hysteresis
    .byte 0x08                       ;Point 1
;.org 0x92A1
T_DeltaRpmChangeToUse_DRPNK_or_PNDRK_B:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x246C
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname DeltaRpmChangeToUse_DRPNK_or_PNDRK_B
    ;mptblcname PNDLTP
    ;mpxaxis Coolant_Temp -200 260 F
    ;mpyaxis DeltaRPM 0 8192 rpm
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x74, 0xEC, 0x00, 0x29     ;Point 1
    .byte 0x8D, 0xF0, 0x00, 0x2B     ;Point 2
    .byte 0xC8, 0xFA                 ;Point 3
;.org 0x92AC
T_t92ACx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x247B
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t92ACx
    ;mptblcname T92ACX
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x92B0
T_DeltaRpmChangeToUse_DRPNK_or_PNDRK_A:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x2487
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname DeltaRpmChangeToUse_DRPNK_or_PNDRK_A
    ;mptblcname PNDLT
    ;mpxaxis Coolant_Temp -200 260 F
    ;mpyaxis DeltaRPM 0 8192 rpm
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x74, 0xEC, 0x00, 0x29     ;Point 1
    .byte 0x8D, 0xF0, 0x00, 0x2B     ;Point 2
    .byte 0xC8, 0xFA                 ;Point 3
;.org 0x92BB
T_t92BBx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x2496
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t92BBx
    ;mptblcname T92BBX
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x92BF
T_DriveToParkNeutralKicks_FromTemp:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x24A2
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DriveToParkNeutralKicks_FromTemp
    ;mptblcname DRPNK
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Number of points in table
    .byte 0x63, 0x46, 0xFE, 0xEE     ;Point 1
    .byte 0x7F, 0x28, 0xFF, 0x25     ;Point 2
    .byte 0x8D, 0x1C, 0xFF, 0xBF     ;Point 3
    .byte 0xC8, 0x0D                 ;Point 4
;.org 0x92CE
T_ParkNeutralToDriveKicks_FromTemp:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x24B2
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ParkNeutralToDriveKicks_FromTemp
    ;mptblcname PNDRK
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Number of points in table
    .byte 0x63, 0x46, 0xFE, 0xEE     ;Point 1
    .byte 0x7F, 0x28, 0xFF, 0x25     ;Point 2
    .byte 0x8D, 0x1C, 0xFF, 0xBF     ;Point 3
    .byte 0xC8, 0x0D                 ;Point 4
;.org 0x92DD
T_AcClutchAisAdjustmentConstant:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x24C2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcClutchAisAdjustmentConstant
    ;mptblcname PERKCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xC0                       ;Point 1
;.org 0x92DE
T_AisInstantlyClosesWhenAcDisengages2:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x24CE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisInstantlyClosesWhenAcDisengages2
    ;mptblcname OFFPER2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xA0                       ;Point 1
;.org 0x92DF
T_RollingAisMaxSpeed:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x24DA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisMaxSpeed
    ;mptblcname AISMPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1
;.org 0x92E0
T_RollingAisMinRpm:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x24E6
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname RollingAisMinRpm
    ;mptblcname RPMDLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x07D0                     ;Point 1
;.org 0x92E2
T_RollingAisDecay:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x24F2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisDecay
    ;mptblcname ISPDCY
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1
;.org 0x92E3
T_RollingAisUpdateRate_01_03_07_0f_1f_3f_7f_ff:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x24FE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisUpdateRate_01_03_07_0f_1f_3f_7f_ff
    ;mptblcname DECAIS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x82                       ;Point 1
;.org 0x92E4
T_RollingAisHighLimit:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x250A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisHighLimit
    ;mptblcname AISLMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x20                       ;Point 1
;.org 0x92E5
T_RollingAisLowLimit:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x2516
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisLowLimit
    ;mptblcname AISLML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1
;.org 0x92E6
T_MinVoltageForAis:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x2522
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinVoltageForAis
    ;mptblcname BTVAIS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x71                       ;Point 1
;.org 0x92E7
T_AisHighLimitMaxOpenSteps:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x252E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisHighLimitMaxOpenSteps
    ;mptblcname AISHLM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xA0                       ;Point 1
;.org 0x92E8
T_PositionAisMotorIsAtIdle:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x253A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PositionAisMotorIsAtIdle
    ;mptblcname CALPOS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AIS:_Position_electronics_thinks_motor_is_(at_idle)
    .byte 0x1A                       ;Point 1
;.org 0x92E9
T_AisAdjustRate:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x2546
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisAdjustRate
    ;mptblcname CALRAT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AIS_update_rate_when_calibrating_-_rate=(CALRAT+1)*11ms_(can_be_0___1___3___7___f___1f___3f___7f___ff)
    .byte 0x07                       ;Point 1
;.org 0x92EA
T_HiMAP3DInputModifierFromMAP:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x2552
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname HiMAP3DInputModifierFromMAP
    ;mptblcname MAPHI
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Description
    ;mpmapaxis x
    .byte 0x03                       ;Number of points in table
    .byte 0x11, 0x00, 0x01, 0xE2     ;Point 1
    .byte 0x44, 0x60, 0x00, 0xEF     ;Point 2
    .byte 0xEE, 0xFF                 ;Point 3
;.org 0x92F5
T_t92F5x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x2562
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t92F5x
    ;mptblcname T92F5X
    ;mpxaxis Xinput 8 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
    .byte 0xFF                       ;Point 5
    .byte 0xFF                       ;Point 6
    .byte 0xFF                       ;Point 7
    .byte 0xFF                       ;Point 8
;.org 0x92FD
T_ModifiedMAPFor3DTable_nonfuelspark:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x256E
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname ModifiedMAPFor3DTable_nonfuelspark
    ;mptblcname MAPMOD
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Description
    ;mpmapaxis x
    .byte 0x05                       ;Number of points in table
    .byte 0x22, 0x00, 0x03, 0xC4     ;Point 1
    .byte 0x44, 0x80, 0x01, 0xE2     ;Point 2
    .byte 0x55, 0xA0, 0x00, 0xF1     ;Point 3
    .byte 0x99, 0xE0, 0x00, 0x75     ;Point 4
    .byte 0xDD, 0xFF                 ;Point 5
;.org 0x9310
T_RPM3DInputModifierFromRPM:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x2580
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname RPM3DInputModifierFromRPM
    ;mptblcname RPMSCL
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc Output_is_used_as_the_input_to_the_3D_tables
    .byte 0x04                       ;Number of points in table
    .byte 0x13, 0x00, 0x05, 0x55     ;Point 1
    .byte 0x1F, 0x40, 0x02, 0x00     ;Point 2
    .byte 0x2F, 0x60, 0x01, 0x05     ;Point 3
    .byte 0xCB, 0xFF                 ;Point 4
;.org 0x931F
T_t931Fx:
    ;mpgrp Unassigned\
    ;mptbladdr 0x2590
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t931Fx
    ;mptblcname T931FX
    ;mpxaxis Xinput 4 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_Filler_Bytes
    .byte 0xFF                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0xFF                       ;Point 3
    .byte 0xFF                       ;Point 4
;.org 0x9323
T_TimeEngineRunningRescaledFor3D:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x259C
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TimeEngineRunningRescaledFor3D
    ;mptblcname TIMESC
    ;mpxaxis TimeEngineRunning 0 2.55 seconds
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc Output_is_used_as_the_input_to_the_3D_tables
    .byte 0x05                       ;Number of points in table
    .byte 0x00, 0x00, 0x0A, 0xAB     ;Point 1
    .byte 0x06, 0x40, 0x02, 0xBE     ;Point 2
    .byte 0x29, 0xA0, 0x01, 0x64     ;Point 3
    .byte 0x57, 0xE0, 0x00, 0x2F     ;Point 4
    .byte 0xFF, 0xFF                 ;Point 5
;.org 0x9336
T_FastDataOutputCommandByte:
    ;mpgrp Setup_-_DRB_Datalogging\
    ;mptbladdr 0x25AD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FastDataOutputCommandByte
    ;mptblcname FASTDT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1
;.org 0x9337
T_FastDataOutputAddressTable:
    ;mpgrp Setup_-_DRB_Datalogging\
    ;mptbladdr 0x25B9
    ;mptbltype 23
    ;mpsubtype n
    ;mptbllname FastDataOutputAddressTable
    ;mptblcname FASTDA
    ;mpxaxis in_desc 30 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc MapVolts/MapValueRaw/TPSVolts/CoolantTemp/LastTpsVolts/MissingAddr/MissingAddr/MissingAddr/MissingAddr/MissingAddr/MissingAddr/MissingAddr/MissingAddr/MissingAddr/MissingAddr
    .word 0x0079                     ;MapVolts
    .word 0x007A                     ;MapValueRaw
    .word 0x0082                     ;TPSVolts
    .word 0x0086                     ;CoolantTemp
    .word 0x0089                     ;LastTpsVolts
    .word 0x6096                     ;MissingAddr
    .word 0x6097                     ;MissingAddr
    .word 0x6098                     ;MissingAddr
    .word 0x6099                     ;MissingAddr
    .word 0x6081                     ;MissingAddr
    .word 0x6082                     ;MissingAddr
    .word 0x6083                     ;MissingAddr
    .word 0x6084                     ;MissingAddr
    .word 0x6085                     ;MissingAddr
    .word 0x6086                     ;MissingAddr
;.org 0x9355
T_t9355x:
    ;mpgrp Unassigned\
    ;mptbladdr 0x25D3
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname t9355x
    ;mptblcname T9355X
    ;mpxaxis Xinput 2 255 x_units
    ;mpyaxis Youtput 0 255 Y_units
    ;mptbldesc Desc_T8Ef4X
    .byte 0x3B                       ;Point 1
    .byte 0xFF                       ;Point 2
;.org 0x9357
T_SourceCodeVersionID:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x25DF
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname SourceCodeVersionID
    ;mptblcname SRCID
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Desc
    .word 0x1203                     ;Point 1
    ;mp******************************
    ;mpcodebase 0A T-LM
    ;mpcodebase 0B T-SMECt1
    ;mpcodebase 0C T-SBEC1
    ;mpcodebase 0D T-TIII_(91)
    ;mpcodebase 0E T-TIII_(92-93)
    ;mpcodebase 0F T-GLHS
    ;mpcodebase 10 FCC
    ;mpcodebase 11 T-SMECt2
    ;mpcodebase 12 T-SBEC2
    ;mp******************************
;.org 0x9359
T_BatteryVoltsTable:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x25F6
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
;.org 0x9360
T_TempForScaleAmbientA2D:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x2604
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
;.org 0x9377
T_TempForColdScaleFromA2D:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x2616
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
;.org 0x9392
T_TempForHotScaleA2D:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x2629
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
;.org 0x93A1
T_DwellTimeFromBatteryVolts:
    ;mpgrp Spark_-_Dwell_Control\
    ;mptbladdr 0x2639
    ;mptbltype 10
    ;mpsubtype n
    ;mptbllname DwellTimeFromBatteryVolts
    ;mptblcname DWELL
    ;mpxaxis BatV 0 16.2 V
    ;mpyaxis DwellTime 0 65535 uSec
    ;mptbldesc Complement_of_dwell_time_from_battery_volts.
    .byte 0x82                   ;Point 1
    .word 0xE609, 0x4059
    .byte 0xAA                   ;Point 2
    .word 0xF017, 0x2908
    .byte 0xC8                   ;Point 3
    .word 0xF4E6, 0x138C
    .byte 0xDC                   ;Point 4
    .word 0xF66D, 0x1100
    .byte 0xF0                   ;Point 5
    .word 0xF7C1, 0x0C55
    .byte 0xFF
;.org 0x93BB
T_BatteryVoltsHysteresisForAlternatorControl:
    ;mpgrp Setup_-_Alternator_Diagnostics\
    ;mptbladdr 0x264F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BatteryVoltsHysteresisForAlternatorControl
    ;mptblcname BTVHYS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1
;.org 0x93BC
T_BatteryVoltsDiagLimitOverTarget:
    ;mpgrp Setup_-_Alternator_Diagnostics\
    ;mptbladdr 0x265B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BatteryVoltsDiagLimitOverTarget
    ;mptblcname BTVLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1
;.org 0x93BD
T_BatteryVoltsDiagCounterMax:
    ;mpgrp Setup_-_Alternator_Diagnostics\
    ;mptbladdr 0x2667
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BatteryVoltsDiagCounterMax
    ;mptblcname BTVCNT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x8E                       ;Point 1
;.org 0x93BE
T_BatteryVoltsDiagCounterMin:
    ;mpgrp Setup_-_Alternator_Diagnostics\
    ;mptbladdr 0x2673
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BatteryVoltsDiagCounterMin
    ;mptblcname BTVCN3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x06                       ;Point 1
;.org 0x93BF
T_BatteryVoltsDiagCounterMax2:
    ;mpgrp Setup_-_Alternator_Diagnostics\
    ;mptbladdr 0x267F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BatteryVoltsDiagCounterMax2
    ;mptblcname BTVCN2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x7F                       ;Point 1
;.org 0x93C0
T_LowBatteryVoltageAtThisRpm1500:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x268B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowBatteryVoltageAtThisRpm1500
    ;mptblcname BTLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x2E                       ;Point 1
;.org 0x93C1
