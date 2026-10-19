;mpver 2.00
;mpassmfile t-smec_v19.asm
.org DataOrg

;mpinjsize 52.0
;mpbar 3.0

;
;mprevisionstart
; ***********************************************************************
; T-SMEC_22_ATX_A124_Masi.tpl
; 2.2 T2 Auto Trans (Masi TC) Cal Data
;
; V19
; 04/29/12 - Updated grouping
;          - Corrected scaling for most values
;          - Added new values for anti-lag and spark cut limiter
;
; 06/05/12 - Added T2 Boost Control values.
;
;
; ***********************************************************************
;mprevisionend
; Rom Area
; ***********************************************************************


;mpgroupstart 3_-_Boost_Control\
;Boost Control
;mpgroupend
;mpgroupstart 3_-_Boost_Control\B_-_WG_Control\
;WG Control - These values are the lookup and adaptive controls for the WG Soleno
;  id Duty Cycle
;mpgroupend
;mpgroupstart 1_-_Fuel\F_-_Adaptive_memory\
;Adaptive Memory - these are the control points for the adaptive memory.
;mpgroupend
;mpgroupstart 1_-_Fuel\F_-_Adaptive_memory\Adaptive_Memory_Timer\
;Adaptive memory timer - these are the control points for the AM timer.
;mpgroupend
;mpgroupstart 1_-_Fuel\
;All fuel lookups
;mpgroupend
;mpgroupstart 1_-_Fuel\E_-_O2_Controller\
;O2 Controller - Control constants for the O2 feedback controller.
;mpgroupend
;mpgroupstart 1_-_Fuel\E_-_O2_Controller\O2_Controller_Ramps\
;O2 Controller Ramps.
;mpgroupend
;mpgroupstart 1_-_Fuel\B_-_Running\
;Running fuel lookups.
;mpgroupend
;mpgroupstart 1_-_Fuel\A_-_Starting\
;Starting fuel lookups. ATOFF*4))*4
;mpgroupend
;mpgroupstart 1_-_Fuel\D_-_Transient_Enrichment\
;Transient Enrichment
;mpgroupend
;mpgroupstart 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\
;Pumpshot Transient Enrichment
;mpgroupend
;mpgroupstart Idle_-_AIS_Control\
;Idle\
;mpgroupend
;mpgroupstart 5_-_Idle\B_-_AIS_Decel\
;AIS Decel\
;mpgroupend
;mpgroupstart 5_-_Idle\C_-_Special_setup\
;Special setup\
;mpgroupend
;mpgroupstart Spark_-_Adaptive_Retard\
;Spark\
;mpgroupend
;mpgroupstart Spark\Anti-Lag_Retard\
;Anti-Lag Retard\
;mpgroupend
;mpgroupstart 2_-_Spark\E_-_Dwell_Control\
;Dwell Control\
;mpgroupend
;mpgroupstart 2_-_Spark\B_-_Knock_Retard\
;Knock Retard\
;mpgroupend
;mpgroupstart 2_-_Spark\A_-_Normal_Advance\
;Normal Advance\
;mpgroupend
;mpgroupstart 2_-_Spark\C_-_Scatter_Control\
;Scatter Control\
;mpgroupend
;mpgroupstart 2_-_Spark\F_-_Start_to_Run_Transfer\
;Start to Run Transfer\
;mpgroupend
;mpgroupstart Turbonator_-_Alky_Injection\
;Turbonator\
;mpgroupend
;mpgroupstart 0_-_Setup\C_-_Turbonator_Features\CEL_Knock_Indicator\
;CEL Knock Indicator\
;mpgroupend
;mpgroupstart 0_-_Setup\C_-_Turbonator_Features\NO2_Retard\
;NO2 Retard\
;mpgroupend
;mpgroupstart Turbonator_Features\Shift_Light\
;Shift Light\
;mpgroupend
;mpgroupstart Turbonator_Features\Staging_Limiter\
;Staging Limiter\
;mpgroupend
;mpgroupstart Turbonator_Features\Voltage_Regulator\
;Voltage Regulator\
;mpgroupend
;mpgroupstart Setup_-_Baud_Rate\
;Setup\
;mpgroupend
;mpgroupstart 0_-_Setup\A_-_Cal_Configuration\
;Cal Configuration\
;mpgroupend
;mpgroupstart 7_-_Aux_Functions\On-Board_Diagnostics\
;On-Board Diagnostics\
;mpgroupend
;mpgroupstart 0_-_Setup\D_-_Transfer_Functions\
;Transfer Functions\
;mpgroupend
;mpgroupstart 7_-_Aux_Functions\On-Board_Diagnostics\T-Stat_Diagnostics\
;T-Stat Diagnostics\
;mpgroupend
;mpgroupstart Baro_Read\
;Setup\Baro Read\
;mpgroupend
;mpgroupstart 7_-_Aux_Functions\AC_Control\
;Setup\AC Control\
;mpgroupend
;mpgroupstart 7_-_Aux_Functions\PTU_Control\
;Setup\PTU Control\
;mpgroupend
;mpgroupstart 7_-_Aux_Functions\Purge_Control\
;Setup\Purge Control\
;mpgroupend
;mpgroupstart 7_-_Aux_Functions\EGR\
;Setup\EGR\
;mpgroupend
;mpgroupstart Setup\Baro_Read\
;Utility\Baro Read\
;mpgroupend
;mpgroupstart Cruise_Control\
;Utility\Cruise Control\
;mpgroupend
;mpgroupstart 3_-_Boost_Control\A_-_Target_Lookup\
;Boost Lookup - The value from each lookup is compared and the smallest value is 
;used as the boost target.
;mpgroupend
;mpgroupstart 1_-_Fuel\C_-_Modifiers\
;Injector PW Modifiers
;mpgroupend
;mpgroupstart 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\
;Decel Lean-out
;mpgroupend
;mpgroupstart Boost\WG_Control\WGDC_Adaptives\
;Boost Control\WG Control\WGDC Adaptives\
;mpgroupend
;mpgroupstart Boost\WG_Control\T1_WGDC_Knock_Adj\
;Boost Control\WG Control\T1 WGDC Knock Adj\
;mpgroupend
;mpgroupstart Boost\WG_Control\T1_WGDC_Lookup\
;Boost Control\WG Control\WGDC Lookup\
;mpgroupend
;mpgroupstart Turbonator\
;Turbonator Features\
;mpgroupend
;mpgroupstart Turbonator\Alky_Injection\
;Turbonator Features\Alky Injection\
;mpgroupend
;mpgroupstart OB,_Speed,_and_Rev_Limiter\Misc\
;OB, Speed, and Rev Limiter\Misc, Limp Mode\
;mpgroupend
;mpgroupstart 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\
;T1 (Bleed style) WG Control Values
;mpgroupend
;mpgroupstart 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Knock_Adj\
;Boost Control\WG Control\New 634744874681112346\T1 WGDC Knock Adj\
;mpgroupend
;mpgroupstart 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Lookup\
;Boost Control\WG Control\New 634744874681112346\T1 WGDC Lookup\
;mpgroupend
;mpgroupstart 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\
;T2 (Source style) WG Control
;mpgroupend
;mpgroupstart 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Adaptives\
;Boost Control\WG Control\New 634744875062295914\T2 WGDC Adaptives\
;mpgroupend
;mpgroupstart 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Knock_Adj\
;Boost Control\WG Control\New 634744875062295914\T2 WGDC Knock Adj\
;mpgroupend
;mpgroupstart 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Lookup\
;Boost Control\WG Control\New 634744875062295914\T2 WGDC Lookup\
;mpgroupend
;mpgroupstart 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_BoostCreep\
;Boost Control\WG Control\New 634744875062295914\T2 WGDC PTBoostCreep\
;mpgroupend
;mpgroupstart 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
;Boost Control\WG Control\T1 WG Control\WGDC Adaptives\
;mpgroupend
;mpgroupstart Setup\Transfer_Functions\AFR2WB\
;Turbonator Features\AFR2WB\
;mpgroupend
;mpgroupstart Turbonator_Features\AFR2WB\
;Turbonator Features\WB2NB\
;mpgroupend
;mpgroupstart Setup\
;0 - Setup\
;mpgroupend
;mpgroupstart Setup\Baud_Rate\
;0 - Setup\Baud Rate\
;mpgroupend
;mpgroupstart Setup\Cal_ID\
;0 - Setup\Cal ID\
;mpgroupend
;mpgroupstart 0_-_Setup\E_-_Throttle_Calibration\
;0 - Setup\Throttle Calibration\
;mpgroupend
;mpgroupstart Fuel\Decel_Fuel_Shutoff\
;1 - Fuel\Decel Fuel Shutoff\
;mpgroupend
;mpgroupstart Fuel\PumpShot_Calculation\AIS_PumpShot\
;1 - Fuel\PumpShot Calculation\AIS PumpShot\
;mpgroupend
;mpgroupstart Fuel\PumpShot_Calculation\MAP_PumpShot\
;1 - Fuel\PumpShot Calculation\MAP PumpShot\
;mpgroupend
;mpgroupstart Fuel\PumpShot_Calculation\TPS_PumpShot\
;1 - Fuel\PumpShot Calculation\TPS PumpShot\
;mpgroupend
;mpgroupstart Fuel\Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
;1 - Fuel\Transient Enrichment\Decel Lean-out\Decreasing MAP LO\
;mpgroupend
;mpgroupstart Fuel\Transient_Enrichment\Decel_Lean-out\Decreasing_TPS_LO\
;1 - Fuel\Transient Enrichment\Decel Lean-out\Decreasing TPS LO\
;mpgroupend
;mpgroupstart Fuel\Transient_Enrichment\Part_Throttle_Enrichment\
;1 - Fuel\Transient Enrichment\Part Throttle Enrichment\
;mpgroupend
;mpgroupstart Spark\
;2 - Spark\
;mpgroupend
;mpgroupstart Spark\Adaptive_Retard\
;2 - Spark\Adaptive Retard\
;mpgroupend
;mpgroupstart OB,_Speed,_and_Rev_Limiter\
;4 - OB, Speed, and Rev Limiter\
;mpgroupend
;mpgroupstart OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
;4 - OB, Speed, and Rev Limiter\Misc, Limp Mode\
;mpgroupend
;mpgroupstart OB,_Speed,_and_Rev_Limiter\Overboost\
;4 - OB, Speed, and Rev Limiter\Overboost\
;mpgroupend
;mpgroupstart OB,_Speed,_and_Rev_Limiter\Rev_Limiter\
;4 - OB, Speed, and Rev Limiter\Rev Limiter\
;mpgroupend
;mpgroupstart OB,_Speed,_and_Rev_Limiter\Speed_Limiter\
;4 - OB, Speed, and Rev Limiter\Speed Limiter\
;mpgroupend
;mpgroupstart Idle\
;5 - Idle\
;mpgroupend
;mpgroupstart Idle\AIS_Control\
;5 - Idle\AIS Control\
;mpgroupend
;mpgroupstart Fan_Control\
;6 - Fan Control\
;mpgroupend
;mpgroupstart Turbonator_Features\
;0 - Setup\Turbonator Features\
;mpgroupend
;mpgroupstart Turbonator_Features\Alky_Injection\
;0 - Setup\Turbonator Features\Alky Injection\
;mpgroupend
;mpgroupstart Turbonator_Features\Launch_Control\
;0 - Setup\Turbonator Features\Launch Control\
;mpgroupend
;mpgroupstart Turbonator_Features\Launch_Control\Antilag_Settings\
;0 - Setup\Turbonator Features\Launch Control\Antilag Settings\
;mpgroupend
;mpgroupstart Turbonator_Features\Launch_Control\Launch_Control_Enable\
;0 - Setup\Turbonator Features\Launch Control\Launch Control Enable\
;mpgroupend
;mpgroupstart Turbonator_Features\Launch_Control\Launch_Control_Entry_Conditions\
;0 - Setup\Turbonator Features\Launch Control\Launch Control Entry Conditions\
;mpgroupend
;mpgroupstart Turbonator_Features\Launch_Control\Launch_Control_RPM\
;0 - Setup\Turbonator Features\Launch Control\Launch Control RPM\
;mpgroupend
;mpgroupstart Turbonator_Features\Launch_Control\Rotating_Spark_Cut\
;0 - Setup\Turbonator Features\Launch Control\Rotating Spark Cut\
;mpgroupend
;mpgroupstart Turbonator_Features\WB2NB\
;0 - Setup\Turbonator Features\WB2NB\
;mpgroupend
;mpgroupstart 7_-_Aux_Functions\
;10 - Utility\
;mpgroupend
;mpgroupstart 7_-_Aux_Functions\Baro_Read\
;10 - Utility\Baro Read\
;mpgroupend
;mpgroupstart 7_-_Aux_Functions\Cruise_Control\
;10 - Utility\Cruise Control\
;mpgroupend
;mpgroupstart 7_-_Aux_Functions\PTU_Control\Entry_Conditions\
;10 - Utility\PTU Control\Entry Conditions\
;mpgroupend
;mpgroupstart 7_-_Aux_Functions\PTU_Control\Hysteresis\
;10 - Utility\PTU Control\Hysteresis\
;mpgroupend
;mpgroupstart 7_-_Aux_Functions\PTU_Control\TPS_Limits_for_Lockup\
;10 - Utility\PTU Control\TPS Limits for Lockup\
;mpgroupend
;mpgroupstart Calculated_Tables\
;99 - Calculated Tables\
;mpgroupend
;mpgroupstart 0_-_Setup\Cal_ID\
;0 - Setup\B - Cal ID\
;mpgroupend
;mpgroupstart 0_-_Setup\Turbonator_Features\
;0 - Setup\C - Turbonator Features\
;mpgroupend
;mpgroupstart 0_-_Setup\Turbonator_Features\Alky_Injection\
;0 - Setup\C - Turbonator Features\Alky Injection\
;mpgroupend
;mpgroupstart 0_-_Setup\Turbonator_Features\Launch_Control\
;0 - Setup\C - Turbonator Features\Launch Control\
;mpgroupend
;mpgroupstart 0_-_Setup\Turbonator_Features\Launch_Control\Antilag_Settings\
;0 - Setup\C - Turbonator Features\Launch Control\Antilag Settings\
;mpgroupend
;mpgroupstart 0_-_Setup\Turbonator_Features\Launch_Control\Launch_Control_Enable\
;0 - Setup\C - Turbonator Features\Launch Control\Launch Control Enable\
;mpgroupend
;mpgroupstart 0_-_Setup\Turbonator_Features\Launch_Control\Launch_Control_Entry_Conditions\
;0 - Setup\C - Turbonator Features\Launch Control\Launch Control Entry Conditions
;  \
;mpgroupend
;mpgroupstart 0_-_Setup\Turbonator_Features\Launch_Control\Launch_Control_RPM\
;0 - Setup\C - Turbonator Features\Launch Control\Launch Control RPM\
;mpgroupend
;mpgroupstart 0_-_Setup\Turbonator_Features\Launch_Control\Rotating_Spark_Cut\
;0 - Setup\C - Turbonator Features\Launch Control\Rotating Spark Cut\
;mpgroupend
;mpgroupstart 0_-_Setup\Turbonator_Features\WB2NB\
;0 - Setup\C - Turbonator Features\WB2NB\
;mpgroupend
;mpgroupstart 0_-_Setup\Baud_Rate\
;0 - Setup\F - Baud Rate\
;mpgroupend
;mpgroupstart 1_-_Fuel\Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
;1 - Fuel\D - Transient Enrichment\Decel Lean-out\Decreasing MAP LO\
;mpgroupend
;mpgroupstart 1_-_Fuel\Transient_Enrichment\Decel_Lean-out\Decreasing_TPS_LO\
;1 - Fuel\D - Transient Enrichment\Decel Lean-out\Decreasing TPS LO\
;mpgroupend
;mpgroupstart 1_-_Fuel\Transient_Enrichment\Part_Throttle_Enrichment\
;1 - Fuel\D - Transient Enrichment\Part Throttle Enrichment\
;mpgroupend
;mpgroupstart 1_-_Fuel\PumpShot_Calculation\AIS_PumpShot\
;1 - Fuel\D - Transient Enrichment\PumpShot Calculation\AIS PumpShot\
;mpgroupend
;mpgroupstart 1_-_Fuel\PumpShot_Calculation\MAP_PumpShot\
;1 - Fuel\D - Transient Enrichment\PumpShot Calculation\MAP PumpShot\
;mpgroupend
;mpgroupstart 1_-_Fuel\PumpShot_Calculation\TPS_PumpShot\
;1 - Fuel\D - Transient Enrichment\PumpShot Calculation\TPS PumpShot\
;mpgroupend
;mpgroupstart 1_-_Fuel\G_-_Decel_Fuel_Shutoff\
;1 - Fuel\F - Decel Fuel Shutoff\
;mpgroupend
;mpgroupstart 2_-_Spark\Adaptive_Retard\
;2 - Spark\D - Adaptive Retard\
;mpgroupend
;mpgroupstart 4_-_OB,_Speed,_and_Rev_Limiter\Overboost\
;4 - OB, Speed, and Rev Limiter\A - Overboost\
;mpgroupend
;mpgroupstart 4_-_OB,_Speed,_and_Rev_Limiter\Rev_Limiter\
;4 - OB, Speed, and Rev Limiter\B - Rev Limiter\
;mpgroupend
;mpgroupstart 4_-_OB,_Speed,_and_Rev_Limiter\Speed_Limiter\
;4 - OB, Speed, and Rev Limiter\C - Speed Limiter\
;mpgroupend
;mpgroupstart 4_-_OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
;4 - OB, Speed, and Rev Limiter\D - Misc, Limp Mode\
;mpgroupend
;mpgroupstart 5_-_Idle\AIS_Control\
;5 - Idle\A - AIS Control\
;mpgroupend

	.msg "Assembling Data Structures..." ; these are just messages to display during assemble to let you know what's going on...

;mpfuelparms 6000,60,55,3.793,.740_Regular,2.5
;mpfuelnone1 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpfuelnone2 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpfuelpart1 14.9,14.9,14.9,14.9,14.9,14.9,14.9,14.9,14.9,14.9,14.9,14.9,14.9,14.7,13.5,12.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5
;mpfuelpart2 11.5,11.5,11.5,11.5,11.5,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11
;mpfuelfull1 13.6,13.6,13.6,13.6,13.6,13.6,13.6,13.6,13.6,13.6,13.6,13.6,13,12.5,12,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5,11.5
;mpfuelfull2 11.5,11.5,11.5,11.5,11.5,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11

RomBegin:

ENDIT1_PNPrefix:
    ;mpgrp 0_-_Setup\B_-_Cal_ID\
    ;mptbladdr 0x0195
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname PNPrefix
    ;mptblcname ENDIT1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Part_Number_prefix._The_1st_4_digits_of_the_Mopar_PN_for_this_ECU.
    .word 0x4532                     ;Point 1

	;.org	0x8002
ENDITM_ECUID:
    ;mpgrp 0_-_Setup\B_-_Cal_ID\
    ;mptbladdr 0x01A2
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ECU_ID
    ;mptblcname ENDITM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ECU_ID._This_portion_of_the_PN_is_used_by_scan_tools_to_automatically_ID_the_ECU._This_number_is_different_for_every_computer/cal._The_1st_digit_is_possibly_a_revision_code_of_some_type._Or,_it_may_have_no_meaning_at_all.
    .word 0xA124                     ;Point 1

; the ECU ID MUST be the same as one of the 2.5 T1 stock cals. If it is changed, then
; scantools will not be able to ID the cal and may not work. If you want to change this
; value, then you may have to tell your scantool that you are running a 2.5 T1 manually.

	;.org	 0x8004
HunstvilleTesterCodeBits:
    ;mpgrp 0_-_Setup\B_-_Cal_ID\
    ;mptbladdr 0x01B3
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname Huntsville_Code
    ;mptblcname HUNTSV
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Special_code_for_factory_testing.
    .word 0xC92D                     ;Point 1

MDLCDE_ModelTypeCode:
    ;mpgrp 0_-_Setup\B_-_Cal_ID\
    ;mptbladdr 0x01BF
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ModelTypeCode
    ;mptblcname MDLCDE
    ;mpxaxis X 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc The_1st_2_digits_are_the_model_year,_2nd_2_digits_are_the_engine_and_trans_type.
    .word 0x9941                     ;Point 1
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
    ;mpmodelyr 96 1986
    ;mpmodelyr 97 1987
    ;mpmodelyr FF 1995_Neon
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
    ;mpengtran 44 2.2_T2_Auto
    ;mpengtran FF Neon_Tran
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

; Not sure what these bytes are for, but they're in the original dis-assy...
SpecialBytes:
    ;mpgrp 0_-_Setup\B_-_Cal_ID\
    ;mptbladdr 0x020F
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname Setup_bytes
    ;mptblcname SETUP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Desc
    .word 0x55AA                     ;Point 1

SpecialBytes2:
    ;mpgrp 0_-_Setup\B_-_Cal_ID\
    ;mptbladdr 0x021B
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname Setup_bytes_2
    ;mptblcname SETUP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Desc
    .word 0x0044                     ;Point 1
; Maybe this is a checksum fixup location?

CHKFIX_ChecksumFixupValue:
    ;mpgrp 0_-_Setup\B_-_Cal_ID\
    ;mptbladdr 0x0228
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ChecksumFixupValue
    ;mptblcname CHKFIX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis value 0 255 value
    ;mptbldesc Desc
    .byte 0xCD                       ;Point 1

SRCID_SourceCodeVersionID:
    ;mpgrp 0_-_Setup\B_-_Cal_ID\
    ;mptbladdr 0x0234
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname SourceCodeVersionID
    ;mptblcname SRCID
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Desc
    .word 0x0B13                     ;Point 1
    ;mp******************************
    ;mpcodebase 0A T-LM
    ;mpcodebase 0B T-SMEC
    ;mpcodebase 0C T-SBEC
    ;mpcodebase 0D T-TIII_(91)
    ;mpcodebase 0E T-TIII_(92-93)
    ;mpcodebase 0F T-GLHS
    ;mpcodebase 10 FCC
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

; ***********************************************************************
;
; ***********************************************************************
;
; *** Config/Option Constants ***
;
; These constants alow the user to enable/disable all of the
; added special functions without having to re-assemble from the source.
; These bits can be set/cleared in CHeM or D-Cal.
;
; ***********************************************************************
;
; *** Spark/Fuel Rev Limiters ***
;
; You can now enable/dis-able independantly the spark/fuel rev limiters.
; The Spark-based rev limiter is new. The stock code onyl cut fuel for
; the rev limiter (and overboost, speed limiter, etc.). This was a little
; rough when used for the 2-step. So, I added an option to use a spark
; limiter as well as -or in addition to- the fuel-based rev limiter.
;
; *** Switchable boost ***
;
; Switchable boost uses an additional boost from RPM table to limit the
; boost when the switch is inactive. Depending on the switch used, it may
; be active high or active low. The polarity flag is there to allow the
; user to set the switch to function as intended regardless of the switch
; used.
;
; *** Staging Limiter/2-Step ***
;
; The staging limiter has 2 activation/deactivation methods.
; 1st, the limiter checks to see if it's active by looking for an "enable"
; switch. This could be the brake or other input switch.
; If the switch is "off", then the normal rev limiter values are used.
; 2nd, the limiter checks to see if the vehicle speed is below the cutoff
; point - STGSPD. If it is, then the normal rev limiter value is loaded.
;
; !!! RPM is used differently in the '89 T1 code than the previous codebases.
; !!! Actual RPM is used, rather than the time between dist pulses (used in the
; !!! LM and T2 SMEC codebases).
;
; ***  Flash CE on Knock ***
;
; This option allows the user to flash the "Check Engine" lamp when knock is
; indicated. The individual cylinder retards are used for knock detection.
; In use, the lamp will flash proportionately to the amount of knock.
; It is also possible to use the PTU/Upshift indicator as a knock light (this
; ouput is not used on turbo cars). I may add that as an option in the future.
;
; *** Hi-Speed logger ***
;
; The hi-speed logger allows for much faster than stock datalogging rates
; using an external logging program. It also disables all DRB routines, so
; communication with a standard scantool will no longer be possible. The
; option flag allows the feature to be turned on/off without losing
; calibration data. the function is very simple in operation. It loads a
; single byte memory address into B and then send the data stored at that
; address to the serial port.
;
; *** Anti-lag ***
;
; See description at the anti-lag routine for the specifics.
;
; ***********************************************************************

	;.org	0x800c
CONFIG_ConfigurationFlags:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x029C
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname ConfigurationFlags
    ;mptblcname CONFIG
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc These_are_the_factory_configuration_options.
    ;mpchoices Bit0  TransFuelTPS  Bit2  PTU_Enable  Charge_Temp_Sensor_Enabled  Auto_Trans_Bit  EGR_Installed  A/C_Installed
    .byte 0xB2                       ;Point 1

    cfg_AC			= $%10000000	; A/C Installed
    cfg_EGR			= $%01000000	; EGR installed
    cfg_ATX			= $%00100000	; Auto trans (if set)
    cfg_CTS			= $%00010000	; Charge Temp Sensor Enable, on if set
    cfg_PTU			= $%00001000	; Enable PTU Solenoid control routine
    cfg_bit2			= $%00000100	;
    cfg_UseTPSTransFuelEarly	= $%00000010	; Transient fuel switch
    cfg_bit0			= $%00000001	;

	;.org	0x800d
OPTN1_CalCustomOptionConfigFlags1:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x02B3
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname CalCustomOptionConfigFlags1
    ;mptblcname OPTN1
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc These_are_options_available_to_enable_in_this_custom_codebase.
    ;mpchoices Switchable_boost_enable  Boost_switch_polarity  Bit2  Bit3  FlashCE_On_Knock_Enable  NO2_Sw_Polarity  NO2_Retard_Enable  Bit7
    .byte 0x10                       ;Point 1
    opt_bit7                     = $%10000000	 ;
    opt_bit6			 = $%01000000	 ;
    opt_bit5       	 	 = $%00100000	 ;
    opt_FlashCE 		 = $%00010000	 ; Flash the CE light when knock is indicated
    opt_NO2Pol       	 	 = $%00001000	 ;
    opt_NO2Retard      		 = $%00000100	 ;
    opt_SwBstPol		 = $%00000010	 ; Switchable boost switch polarity
    opt_SwBoost 		 = $%00000001	 ; Switchable boost enable

	;.org	0x800e ;- not used
OPTN2_CalCustomOptionConfigFlags2:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x02C9
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname CalCustomOptionConfigFlags2
    ;mptblcname OPTN2
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc These_are_options_available_to_enable_in_this_custom_codebase.
    ;mpchoices Spark-based_Rev_Limiter  Fuel-based_Rev_Limiter  Launch_Control  Bang_Bang  Bit4  Anti-Lag_Timing  T2_Boost_Control  WB-2-NB_Conversion
    .byte 0x42                       ;Point 1
    opt_WB2NB  			 = $%10000000	 ; Internal WB to O2 sensor conversion
    opt_T2BC			 = $%01000000	 ;
    opt_AntiLag	     		 = $%00100000	 ;
    opt_bit4 			 = $%00010000	 ;
    opt_BangBang     	     	 = $%00001000	 ; use bang-bang style rev limiter when enabled
    opt_StageLim		 = $%00000100	 ; Suppress the EMR (Emiss Maint Reminder) Code
    opt_FuelRevLim		 = $%00000010	 ; Use the fuel-based rev limiter
    opt_SprkRevLim 		 = $%00000001	 ; Use the spark-based rev limiter

	;.org	0x800f
CCDCFG_CCDConfigConstant:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x02DF
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname CCDConfigConstant
    ;mptblcname CCDCFG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CCD_Bus_configuration_constant._Not_sure_of_usage.
    ;mpchoices Bit7  Bit6  Bit5  Bit4  Bit3  Bit2  Bit1  Bit0
    .byte 0x22                       ;Point 1

; I still need to figure out what the bits in this byte do...

; ***********************************************************************
; ERROR CODE MASKS
; ***********************************************************************
; Error code "masking" is implemented differently in the '89 T1 than in the earlier code.
; Instead of masking bits for the individual codes, an internal code is used to mask up to
; 7 different code bytes. The code bytes are as follows:
;
; Code #	Code					Offset (masking code)
; 61	Baro sensor open or shorted			 31
; 62	EMR mileage cannot be stored in EEPROM 		 30
; 63	Controller cannot write to EEPROM		 2f
;
; 44	Loss of FJ2					 08,2c
; 45	Nothing (overboost)				 07
; 46	Battery Volts High				 06
; 47	Battery Volts Low				 05
; 51	Lean condition					 04
; 52	Rich Condition					 03,2d
; 53	Prom Checksum					 02
; 54	Distributor Sync				 01
;
; 33	AC Cutout Relay 				 10
; 34	Speed Ctl Solenoid				 0f
; 35	Radiator Fan Relay				 0e
; 36	Wastegate Solenoid				 0d
; 37	Barometric Read Solenoid			 0c
; 41	Charging System 				 0b
; 42	Auto Shutdown Relay				 0a
; 43	Ignition Coil Control				 09,28,29,2b
;
; 22	Coolant Temp Sensor				 1e,1f
; 23	Charge Temp Sensor				 1c,1d
; 24	Throttle Position				 1a,1b
; 25	AIS Motor					 19
; 26	Injector Current Limit Not Achieved		 16,17,18
; 27	Injector Driver interface			 13,14,15
; 31	Purge Solenoid					 12
; 32	Exh Gas Recirc Solenoid 			 11,2e
;
; 11	Engine Not Cranked Since Battery Disconnected	 28
; 12	Memory Standby Power Lost			 00
; 13	MAP Pneumatic					 26,27
; 14	MAP Electrical					 24,25
; 15	Vehicle Distance Sensor 			 23
; 16	Battery Voltage Sense				 22
; 17	Engine Running Too Cool (thermostat)		 21
; 21	Oxygen Sensor					 20
;
; The "internal" or "masking" code is actually the offset used to lookup the code
; in the table 'ErrorCodesToDash_Table'
;
; The last byte MUST be 0x00, otherwise the code will result in an error.
; I think the original intent was to allow the factory calibrators to mask
; specific internal codes to try and debug errors. Previously, only the final
; error code could be masked - making the cause unclear in the case where multiple
; internal codes set the same error code.
;
; It should be possible to increase the size of the list by adding additional code
; bytes after "FLTMSK7_ErrorBitsMask7". Just make sure that the byte after the last one in
; the list remains 0x00. The mask cheking routine looks for this to mark the end of
; the list. Also, if the list is too long, it may cause lack of space for other
; items. So, be careful if adding to this list.

	;.org	0x887c ;<--- this signifies the original location from the dis-assy...
FLTMSK_ErrorBitsMask1:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x032E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask1
    ;mptblcname FLTMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1

	;.org	0x887d
FLTMSK2_ErrorBitsMask2:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x033B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask2
    ;mptblcname FLTMSK2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1

	;.org	0x887e
FLTMSK3_ErrorBitsMask3:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x0348
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask3
    ;mptblcname FLTMSK3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1

	;.org	0x887f
FLTMSK4_ErrorBitsMask4:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x0355
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask4
    ;mptblcname FLTMSK4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1

	;.org	0x8880
FLTMSK5_ErrorBitsMask5:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x0362
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask5
    ;mptblcname FLTMSK5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1

	;.org	0x8881
FLTMSK6_ErrorBitsMask6:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x036F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask6
    ;mptblcname FLTMSK6
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1

	;.org	0x8882
FLTMSK7_ErrorBitsMask7:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x037C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask7
    ;mptblcname FLTMSK7
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1

	;.org	0x8883
FLTMSKX_ErrorBitsMaskTerminator:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x0389
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMaskTerminator
    ;mptblcname FLTMSKX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Must_be_0x00,_and_must_be_at_the_end_of_the_error_code_list.
    .byte 0x00                       ;Point 1

	;.org	0x8884
IPLMSK_PowerLossLightMask:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x0396
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PowerLossLightMask
    ;mptblcname IPLMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Illuminate_PowerLoss_Light_Mask1._These_errors_alert_the_driver.
    ;mpchoices ChargeTemp_Sensor  CoolantTemp_Sensor  Charging  bit3  BatVolts  Map_Signal  Tps_Signal  Map_Pneumatic
    .byte 0xFE                       ;Point 1

	;.org	0x8885
IPLMSK2_PowerLossLightMask2:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x03A4
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PowerLossLightMask2
    ;mptblcname IPLMSK2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Illuminate_PowerLoss_Light_Mask2._These_errors_alert_the_driver.
    ;mpchoices bit0  bit1  bit2  Wastegate  InjectorFault  bit5  MajorFault  bit7
    .byte 0xD8                       ;Point 1

	;.org	0x8886
PIAMSK_PIA1ADDRMask:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x03B2
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PIAMSK_PIA1ADDRMask
    ;mptblcname PIAMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc These_flags_enable_error_reporting_on_specific_output_bits.
    ;mpchoices Cruise_Vacuum  Purge_Solenoid  Part_Throt_Unlock  AC_Clutch_Relay  Fan_Relay  ASD_Relay  CE_Light  Cruise_Vent
    .byte 0x3A                       ;Point 1

	;.org	0x8887
PIBMSK_PIA1BDDRMask:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x03C0
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PIBMSK_PIA1BDDRMask
    ;mptblcname PIBMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc These_flags_enable_error_reporting_on_specific_output_bits.
    ;mpchoices bit0  bit1  bit2  bit3  Emission_Light  Baro_Read_Solenoid  Wastegate_Solenoid  EGR_Solenoid
    .byte 0xE0                       ;Point 1




CLDMAP_AdvanceFromMAPCold:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x03D0
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname AdvanceFromMAPCold
    ;mptblcname CLDMAP
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc Curve_for_Spark_Advance_from_MAP_when_Engine_Temp_is_below_TMPSWP
    ;mpmapaxis x
    .byte 0x04                       ;Number of points in table
    .byte 0x35, 0x05, 0x01, 0x1C     ;Point 1
    .byte 0x3E, 0x0F, 0x00, 0x00     ;Point 2
    .byte 0x4B, 0x0F, 0xFF, 0xD7     ;Point 3
    .byte 0xC9, 0xFB                 ;Point 4

	;.org	0xc026
CLDLMT_LimitForColdMapAtClosedThrottle:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x03E2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LimitForColdMapAtClosedThrottle
    ;mptblcname CLDLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y -200 260 out
    ;mptbldesc Coldest_input_allowed_for_Cold_MAP
    .byte 0x14                       ;Point 1

HOTMAP_AdvanceFromMAPWarmPart:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x03EE
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname AdvanceFromMAPWarmPart
    ;mptblcname HOTMAP
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc Curve_for_Spark_Advance_from_MAP_when_Engine_Temp_is_above_TMPSWP_and_not_at_Full_Throttle
    ;mpmapaxis x
    .byte 0x08                       ;Number of points in table
    .byte 0x2D, 0x1A, 0xFF, 0x39     ;Point 1
    .byte 0x36, 0x13, 0xFE, 0x8E     ;Point 2
    .byte 0x3F, 0x06, 0xFF, 0x2B     ;Point 3
    .byte 0x45, 0x01, 0xFF, 0xE0     ;Point 4
    .byte 0x4D, 0x00, 0xFF, 0x8E     ;Point 5
    .byte 0x5F, 0xF8, 0xFF, 0x9B     ;Point 6
    .byte 0x8A, 0xE7, 0xFF, 0xDB     ;Point 7
    .byte 0xC9, 0xDE                 ;Point 8

TMPSWP_EngTempSwitchPointForSparkAdvance:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x0403
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngTempSwitchPointForSparkAdvance
    ;mptblcname TMPSWP
    ;mpxaxis IN 0 255 X
    ;mpyaxis Coolant_Temperature -200 260 F
    ;mptbldesc Engine_temperature_switch_point_for_hot_and_cold_map_spark
    .byte 0xA6                       ;Point 1

	;.org	0x8044
ADVCLS_AdvanceAddedForClosedLoopFromTimer:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x0410
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AdvanceAddedForClosedLoopFromTimer
    ;mptblcname ADVCLS
    ;mpxaxis Timer 0 255 F
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc Advance_from_coolant_temp_when_throttle_is_closed
    .byte 0x02                       ;Number of points in table
    .byte 0x00, 0x00, 0x00, 0x38     ;Point 1
    .byte 0x1B, 0x06                 ;Point 2


PartThrottleTiming:
    ;mpgrp 99_-_Calculated_Tables\
    ;mptbladdr 0x041F
    ;mptbltype 16
    ;mpsubtype n
    ;mptbllname PartThrottleTotalTiming
    ;mptblcname PTTIME
    ;mpxaxis GOVNER 0 8160 rpm
    ;mpyaxis HOTMAP -15 15 degrees
    ;mptbldesc Part_throttle_total_timing.
    ;mp3dxtable GOVNER 
    ;mpxintv 500
    ;mp3dytable HOTMAP 
    ;mpyintv 1
    ;mp3dmintable RPMLMT
    ;mp3dmaxtable SPKLMT
    ;mp3dmapmul MAPMUL
    .byte 0x1F                       ;Number of rows in table
    .byte 0x11                       ;Number of cols in table
    .byte 0x00                       ;00 = unsigned, FF = signed
	
FullThrottleTiming:
    ;mpgrp 99_-_Calculated_Tables\
    ;mptbladdr 0x0434
    ;mptbltype 16
    ;mpsubtype n
    ;mptbllname FullThrottleTotalTiming
    ;mptblcname FTTIME
    ;mpxaxis GOVNER 0 8160 rpm
    ;mpyaxis WOTMAP -15 15 degrees
    ;mptbldesc Full_throttle_total_timing.
    ;mp3dxtable GOVNER 
    ;mpxintv 500
    ;mp3dytable WOTMAP 
    ;mpyintv 1
    ;mp3dmintable RPMLMT
    ;mp3dmaxtable SPKLMT
    ;mp3dmapmul MAPMUL
    .byte 0x1F                       ;Number of rows in table
    .byte 0x11                       ;Number of cols in table
    .byte 0x00                       ;00 = unsigned, FF = signed



WOTMAP_AdvanceFromMAPWarmFull:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x044B
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname AdvanceFromMAPWarmFull
    ;mptblcname WOTMAP
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc Curve_for_Spark_Advance_from_MAP_when_Engine_Temp_is_above_TMPSWP_and_at_Full_Throttle
    ;mpmapaxis x
    .byte 0x06                       ;Number of points in table
    .byte 0x3D, 0x14, 0xFE, 0x92     ;Point 1
    .byte 0x4B, 0x00, 0xFF, 0x30     ;Point 2
    .byte 0x5B, 0xF3, 0xFF, 0xBE     ;Point 3
    .byte 0x76, 0xEC, 0xFF, 0x79     ;Point 4
    .byte 0x89, 0xE2, 0xFF, 0xDC     ;Point 5
    .byte 0xC9, 0xD9                 ;Point 6

MAPMUL_MultiplierOnMapAdvanceWhenRetarding_FromRpm:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x045E
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname MultiplierOnMapAdvanceWhenRetarding_FromRpm
    ;mptblcname MAPMUL
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Spark_Advance_Scale 0 3.984 out
    ;mptbldesc Multiplier_on_Map_based_spark_advance_-_used_when_spark_advance_is_below_zero._Output_is_a_multiplier.
    .byte 0x07                       ;Number of points in table
    .byte 0x3F, 0x37, 0x01, 0x46     ;Point 1
    .byte 0x4A, 0x45, 0x00, 0x00     ;Point 2
    .byte 0x67, 0x45, 0x00, 0x66     ;Point 3
    .byte 0x71, 0x49, 0xFF, 0xA3     ;Point 4
    .byte 0x7C, 0x45, 0x00, 0x9E     ;Point 5
    .byte 0x89, 0x4D, 0xFF, 0x28     ;Point 6
    .byte 0xA9, 0x32                 ;Point 7

RPMLMT_LimitForHotMAPAdvance:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x0471
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname LimitForHotMAPAdvance
    ;mptblcname RPMLMT
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc RPM_vs_Advance_when_engine_above_161F_and_throttle_(used_to_limit_max_MAP_advance_from_above_when_there_is_some_to_full_throttle)
    .byte 0x02                       ;Number of points in table
    .byte 0x32, 0x12, 0x00, 0x8F     ;Point 1
    .byte 0x4B, 0x20                 ;Point 2

PNIDLE_AdvanceRemovedIdleParkNeutral:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x047F
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AdvanceRemovedIdleParkNeutral
    ;mptblcname PNIDLE
    ;mpxaxis Coolant_Temperature -200 260 F
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc Not_used
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0xEC                 ;Point 1

PNRPM_EngineSpeedBelowWhich_PNIDLE_Enabled:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x048C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineSpeedBelowWhich_PNIDLE_Enabled
    ;mptblcname PNRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 RPM
    ;mptbldesc Engine_speed_below_which_PNIDLE_is_Enabled_-_for_Automatics
    .byte 0xFF                       ;Point 1

GOVNER_AdvanceFromRPM:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x0498
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AdvanceFromRPM2
    ;mptblcname GOVNER
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Spark_Advance 0 127.5 Degrees
    ;mptbldesc Simulates_the_mechanical_advance_function._Spark_Advance_is_added_from_this_table_from_RPMs_at_all_engine_temperatures._Added_to_MAP_based_advance
    .byte 0x04                       ;Number of points in table
    .byte 0x20, 0x24, 0x00, 0xAB     ;Point 1
    .byte 0x32, 0x30, 0x00, 0x00     ;Point 2
    .byte 0x71, 0x30, 0x00, 0x52     ;Point 3
    .byte 0xA3, 0x40                 ;Point 4

SPKLMT_TotalAdvanceAllowed:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x04A8
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AdvanceFromRpmMAX
    ;mptblcname SPKLMT
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc Description
    .byte 0x03                       ;Number of points in table
    .byte 0x64, 0x64, 0xFE, 0x76     ;Point 1
    .byte 0x71, 0x50, 0xFF, 0xE8     ;Point 2
    .byte 0xDB, 0x46                 ;Point 3

ADVDFT_DefaultSparkAdvance1:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x04B7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DefaultSparkAdvance1
    ;mptblcname ADVDFT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Spark_Advance 0 127.5 Degrees
    ;mptbldesc Detailed_Description
    .byte 0x14                       ;Point 1




KNKRPM_MinRpmforKnockRetard:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x04C6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinRpmforKnockRetard
    ;mptblcname KNKRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 RPM
    ;mptbldesc Minimum_RPM_for_Knock_Retard
    .byte 0x20                       ;Point 1

KNKOFS_DeltaAboveBaroFor_RTRDRT_and_KNKCNT_and_KNKCOR_incremented:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x04D2
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaAboveBaroFor_RTRDRT_and_KNKCNT_and_KNKCOR_incremented
    ;mptblcname KNKOFS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 44.1 psi
    ;mptbldesc Delta_above_Baro_up_to_which_RTRDRT_(Retard_Rate)_is_used_and_KNKCNT_and_KNKCOR_are_incremented._Stock_is_5.4_psi.
    ;mpmapaxis y
    .byte 0x1F                       ;Point 1

RTRDRT_KnockRetardRateNoBoost:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x04DF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardRateNoBoost
    ;mptblcname RTRDRT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Deg 0 127.5 Degrees
    ;mptbldesc Retard_rate_from_Knock,_no_boost._In_half_degrees
    .byte 0x09                       ;Point 1

RTRDRT2_KnockRetardRateInBoost:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x04EB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardRateInBoost
    ;mptblcname RTRDRT2
    ;mpxaxis IN 0 255 X
    ;mpyaxis Retard 0 127.5 deg
    ;mptbldesc Retard_rate_from_Knock,_in_boost._In_half_degrees
    .byte 0x04                       ;Point 1

INCSRT_KnockRetardIncreaseRate:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x04F7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardIncreaseRate
    ;mptblcname INCSRT
    ;mpxaxis in_desc 0 255 retard
    ;mpyaxis Y 0 127.5 deg
    ;mptbldesc Increase_Rate._Recovery_from_Knock_Retard._Rate_is_1/2_engine_degree_every_INCSRT+1_*_11ms._Use_ONLY_0,1,3,7,f,1f,3f,7f_or_ff
    .byte 0x1F                       ;Point 1

RETMAX_MaxKnockRetardFromMap:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x0503
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname MaxKnockRetardFromMap
    ;mptblcname RETMAX
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Max_Retard 0 127.5 degrees
    ;mptbldesc Maximum_Knock_Retard_from_Map
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x39, 0x06, 0x01, 0x47     ;Point 1
    .byte 0x4B, 0x1D                 ;Point 2

KNKLIM_MaxKnockRetard:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x0512
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxKnockRetard
    ;mptblcname KNKLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Retard 0 127.5 Degrees
    ;mptbldesc Knock_Limit_in_1/2_degrees._MaxRetard_=_KNKLIM_if_throttle_is_above_THRKNK_and_RPM_is_below_KLMRPM
    .byte 0x06                       ;Point 1

THRKNK_DeltaAbove_MINTHR:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x051E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaAbove_MINTHR
    ;mptblcname THRKNK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis TPS 0 5 Volts
    ;mptbldesc Delta_above_MINTHR_for_knock_detect
    .byte 0x53                       ;Point 1

KLMRPM_MinKnockDetectRpm:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x052A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinKnockDetectRpm
    ;mptblcname KLMRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 RPM
    ;mptbldesc RPMS_for_Knock
    .byte 0x20                       ;Point 1

DLTKNK_KnockFromRpms:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x0536
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname KnockSensorVoltageForKnock_FromRpm
    ;mptblcname DLTKNK
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis A2D 0 5 volts
    ;mptbldesc Input_from_the_knock_sensor_that_is_above_this_voltage_is_considered_Knock.
    .byte 0x05                       ;Number of points in table
    .byte 0x3E, 0x15, 0x00, 0xB0     ;Point 1
    .byte 0x5E, 0x2B, 0x01, 0x50     ;Point 2
    .byte 0x7E, 0x55, 0x02, 0xC0     ;Point 3
    .byte 0x9E, 0xAD, 0x00, 0xE8     ;Point 4
    .byte 0xBE, 0xCA                 ;Point 5

ARRPM_AdaptiveRetardFromRPM:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x0547
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AdaptiveRetardFromRPM
    ;mptblcname ARRPM
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Spark_Retard 0 127.5 Degrees
    ;mptbldesc The_result_of_this_table_is_multiplied_by_#002b_(0,_1/4,_1/2,_3/4,_or_1)_and_subtracted_from_the_table_at_#8098
    .byte 0x05                       ;Number of points in table
    .byte 0x3F, 0x00, 0x00, 0x42     ;Point 1
    .byte 0x5E, 0x08, 0x00, 0x00     ;Point 2
    .byte 0x71, 0x08, 0xFF, 0xC3     ;Point 3
    .byte 0x8A, 0x02, 0xFF, 0xEC     ;Point 4
    .byte 0xA3, 0x00                 ;Point 5

ARMAP_AdaptiveRetardFromMAP:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x0558
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AdaptiveRetardFromMAP
    ;mptblcname ARMAP
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Spark_Retard 0 127.5 Degrees
    ;mptbldesc This_table_is_reduced_by_the_value_in_#002b_(0,_1/4,_1/2,_3/4,_or_1)_depending_on_the_boost_control_routine._And_the_result_is_subtracted_from_the_advance_calculated_by_8010_or_805b
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x58, 0x00, 0x00, 0x80     ;Point 1
    .byte 0x60, 0x04                 ;Point 2

ARMPIC_AdaptiveRetard_MinMAPForAdjustment:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x0567
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AdaptiveRetard_MinMAPForAdjustment
    ;mptblcname ARMPIC
    ;mpxaxis IN 0 255 X
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc ff_disables_the_Adaptive_Knock_Retard
    ;mpmapaxis y
    .byte 0xAA                       ;Point 1

ARINDX_AdaptiveRetardIndexBase_80:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x0574
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardIndexBase_80
    ;mptblcname ARINDX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x80                       ;Point 1

ARSUBC_AdaptiveRetardFactorSubtract:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x0580
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardFactorSubtract
    ;mptblcname ARSUBC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x40                       ;Point 1

ARCMSK_AdaptiveRetardCounterMask:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x058C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardCounterMask
    ;mptblcname ARCMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x3F                       ;Point 1

ARTM5P_AdaptiveRetardTimeOver5psiBoost:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x0598
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardTimeOver5psiBoost
    ;mptblcname ARTM5P
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0C                       ;Point 1

ARMINT_AdaptiveRetardMinimumTemp:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x05A4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardMinimumTemp
    ;mptblcname ARMINT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 degrees
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

ARCMS2_AdaptiveRetardCounterMask2_00:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x05B0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardCounterMask2_00
    ;mptblcname ARCMS2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

ARCMS3_AdaptiveRetardCounterMask3_FF:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x05BC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardCounterMask3_FF
    ;mptblcname ARCMS3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

DWELL_DwellTimeFromBatteryVoltsComp:
    ;mpgrp 2_-_Spark\E_-_Dwell_Control\
    ;mptbladdr 0x05C8
    ;mptbltype 10
    ;mpsubtype n
    ;mptbllname DwellTimeFromBatteryVolts
    ;mptblcname DWELL
    ;mpxaxis BatV 0 16.2 V
    ;mpyaxis DwellTime 0 65535 uSec
    ;mptbldesc Complement_of_dwell_time_from_battery_volts.
    .byte 0x82                   ;Point 1
    .word 0xF304, 0x202D
    .byte 0xAA                   ;Point 2
    .word 0xF80B, 0x1489
    .byte 0xC8                   ;Point 3
    .word 0xFA73, 0x09C0
    .byte 0xDC                   ;Point 4
    .word 0xFB36, 0x0880
    .byte 0xF0                   ;Point 5
    .word 0xFBE0, 0x0622
    .byte 0xFF

MINADW_MinAntiDwellPeriod:
    ;mpgrp 2_-_Spark\E_-_Dwell_Control\
    ;mptbladdr 0x05DE
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname MinAntiDwellPeriod
    ;mptblcname MINADW
    ;mpxaxis in 0 255 out
    ;mpyaxis AntiDwellTime 0 65535 uSec
    ;mptbldesc Minimum_anti-dwell_period._Use_caution_adjusting_this_constant_as_it_is_hardware_dependant.
    .word 0x00C8                     ;Point 1

ANTLAG_AntiLagRetardAbs:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Launch_Control\Antilag_Settings\
    ;mptbladdr 0x05EA
    ;mptbltype 19
    ;mpsubtype n
    ;mptbllname AntiLagRetardAbs
    ;mptblcname ANTLAGX
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Spark_Retard -16 15.875 Degrees
    ;mptbldesc Antilag_retard_value(absolute)._The_acutal_advance_value_used._Use_negative_values_with_caution._[This_value_should_be_signed:_124_=_-4_actual]
    .byte 0xE0                       ;Point 1

ANLGRP_AntiLagRetardRPM:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Launch_Control\Antilag_Settings\
    ;mptbladdr 0x05F6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AntiLagRetardRPM
    ;mptblcname ANLGRP
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc RPM_to_trigger_antilag._When_staging,_any_RPM_over_this_the_antilag_value_will_be_active._Usually_set_~200rpm_below_staging_limiter.
    .byte 0x45                       ;Point 1

LNCBDT_BaseDataTable:
; counter init value for each spark pattern
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Launch_Control\Rotating_Spark_Cut\
    ;mptbladdr 0x0603
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname BaseDataTable
    ;mptblcname LNCBDT
    ;mpxaxis in_desc 8 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc counter_init_for_launch_control_spark_cut
    .byte 0x03                       ;Point 1
    .byte 0x03                       ;Point 2
    .byte 0x05                       ;Point 3
    .byte 0x05                       ;Point 4
    .byte 0x07                       ;Point 5
    .byte 0x07                       ;Point 6
    .byte 0x07                       ;Point 7
    .byte 0x07                       ;Point 8

LNCPDT_PatternDataTable:
; spark bit pattern for each cut fraction
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Launch_Control\Rotating_Spark_Cut\
    ;mptbladdr 0x0617
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname PatternDataTable
    ;mptblcname LNCPDT
    ;mpxaxis in_desc 8 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc spark_pattern_for_launch_control_spark_cut
    .byte 0x60                       ;Point 1
    .byte 0x20                       ;Point 2
    .byte 0x28                       ;Point 3
    .byte 0x40                       ;Point 4
    .byte 0x36                       ;Point 5
    .byte 0x2A                       ;Point 6
    .byte 0x22                       ;Point 7
    .byte 0x10                       ;Point 8

SPKFRC_SparkCutFraction:
; this value is now a pointer to the pattern and counter init values above
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Launch_Control\Rotating_Spark_Cut\
    ;mptbladdr 0x062B
    ;mptbltype 6
    ;mpsubtype n
    ;mptbllname SparkCutFraction
    ;mptblcname SPKFRC
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis desc 0 255 out
    ;mptbldesc Spark_Cut_fraction-number_of_cut_cylinders.
    ;mpchoices 1/3_Cut 0 2/3_Cut 1 3/5_Cut 2 4/5_Cut 3 3/7_Cut 4 4/7_Cut 5 5/7_Cut 6 6/7_Cut 7
    .byte 0x03                       ;Point 1

SSTEMP_TempAboveWhichSparkScatterIsActive:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x0638
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TempAboveWhichSparkScatterIsActive
    ;mptblcname SSTEMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Temperature_above_which_spark_scatter_is_active._For_road_racing,_the_MP_cal_has_this_set_to_0xfe._This_keeps_the_revs_higher_during_shifts.
    .byte 0x58                       ;Point 1

FTUNPW_FineTuneStepForAis:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x0644
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FineTuneStepForAis
    ;mptblcname FTUNPW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Fine_Tune_Step_for_AIS_for_spark_scatter
    .byte 0x01                       ;Point 1

SSITIM_ScatterInhibitTime:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x0650
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ScatterInhibitTime
    ;mptblcname SSITIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Spark_Scatter_Inhibit_Time_in_11ms_per_bit
    .word 0x0080                     ;Point 1

SSIPRD_ScatterInhibitBelowThisSpeed:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x065C
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ScatterInhibitBelowThisSpeed
    ;mptblcname SSIPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Spark_Scatter_inhibited_below_this_speed._The_MP_MTX_cal_has_this_value_set_to_0xfe33_to_keep_the_revs_high_during_shifts.
    .word 0x0033                     ;Point 1

SPKADD_SparkAdvanceAddedWhenRpmBelowControl_FromDeltaRpm:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x0668
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname SparkAdvanceAddedWhenRpmBelowControl_FromDeltaRpm
    ;mptblcname SPKADD
    ;mpxaxis DeltaRPM 0 512 RPM
    ;mpyaxis Advance 0 127.5 degrees
    ;mptbldesc This_is_how_much_advance_is_added_to_increase_engine_speed.
    .byte 0x02                       ;Number of points in table
    .byte 0x00, 0x00, 0x01, 0x8A     ;Point 1
    .byte 0x0D, 0x14                 ;Point 2

SPKRET_SparkAdvanceRetardedWhenRpmAboveControl_FromDeltaRpm:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x0676
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname SparkAdvanceRetardedWhenRpmAboveControl_FromDeltaRpm
    ;mptblcname SPKRET
    ;mpxaxis DeltaRPM 0 512 rpm
    ;mpyaxis Advance 0 127.5 degrees
    ;mptbldesc This_is_how_much_advance_is_removed_to_decrease_engine_speed
    .byte 0x02                       ;Number of points in table
    .byte 0x00, 0x00, 0xFD, 0xCD     ;Point 1
    .byte 0x0F, 0xDF                 ;Point 2

IDLADD_FuelStabilization_FromDeltaRPM:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x0684
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStabilization_FromDeltaRPM
    ;mptblcname IDLADD
    ;mpxaxis DeltaRPM 0 512 rpm
    ;mpyaxis Pulsewidth 0 1020 uSec
    ;mptbldesc This_is_how_much_fuel_is_added_or_subtracted_to_increase_or_decrease_speed
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x1E, 0x00, 0x01, 0x22     ;Point 1
    .byte 0x3C, 0x22, 0x01, 0x40     ;Point 2
    .byte 0x64, 0x54                 ;Point 3

IDLTMP_Use_IDLADD_AboveThisTemp:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x0694
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Use_IDLADD_AboveThisTemp
    ;mptblcname IDLTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 degF
    ;mptbldesc IDLADD_enabled_when_engine_temp_is_above_IDLTMP
    .byte 0x8A                       ;Point 1

STRNTR_SparkStartRunTransferPointRpm:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x06A0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkStartRunTransferPointRpm
    ;mptblcname STRNTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DistPW 0 255 count
    ;mptbldesc Start_to_Run_transfer_point._Approx_RPM_=_30,000/count
    .byte 0x31                       ;Point 1

RNSTTR_SparkRunStartTransferPointRpm:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x06AC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkRunStartTransferPointRpm
    ;mptblcname RNSTTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DistPW 0 255 count
    ;mptbldesc Run_to_Start_transfer_point._Approx_RPM_=_30,000/count
    .byte 0x47                       ;Point 1

SKAPRD_SparkImmediateSwitchToRunAboveThisRpm:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x06B8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkImmediateSwitchToRunAboveThisRpm
    ;mptblcname SKAPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Immediate_switch_to_Spark_RUN_mode_when_above_this_RPM
    .byte 0x24                       ;Point 1

SRTIME_SparkEPPsNeededToBeAboveSR_Hot:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x06C4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkEPPsNeededToBeAboveSR_Hot
    ;mptblcname SRTIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_consecutive_EPPs_needed_to_be_above_Start_Run_when_hot
    .byte 0x04                       ;Point 1

SRTIME2_SparkEPPsNeededToBeAboveSR_Cold:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x06D0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkEPPsNeededToBeAboveSR_Cold
    ;mptblcname SRTIME2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_consecutive_EPPs_needed_to_be_above_Start_Run_when_cold
    .byte 0x04                       ;Point 1

SRTMTP_SparkTempSwitchPointFor_SRTIME:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x06DC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkTempSwitchPointFor_SRTIME
    ;mptblcname SRTMTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Engine_Temperature_switch_point_for_SRTIME
    .byte 0xB0                       ;Point 1

RNFPRD_FuelStartRunTransferPointRpm:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x06E8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FuelStartRunTransferPointRpm
    ;mptblcname RNFPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DistPW 0 255 count
    ;mptbldesc Start_to_Run_transfer_point_for_fuel._Approx_RPM_=_30,000/count
    .byte 0x30                       ;Point 1

STFPRD_FuelRunStartTransferPointRpm:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x06F4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FuelRunStartTransferPointRpm
    ;mptblcname STFPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DistPW 0 255 Count
    ;mptbldesc Run_to_Start_transfer_point_for_spark._Approx_RPM_=_30,000/count
    .byte 0x41                       ;Point 1

STRTFL_FuelStartFromCoolantTemp:
    ;mpgrp 1_-_Fuel\A_-_Starting\
    ;mptbladdr 0x0700
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname StartFuel_FromTemp
    ;mptblcname STRTFL
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis sqrtPW 0 222 uSec
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4
    ;mpinjscale sqrt
    .byte 0x09                       ;Number of points in table
    .byte 0x58, 0x97, 0xFF, 0xF1     ;Point 1
    .byte 0x69, 0x96, 0xFF, 0x00     ;Point 2
    .byte 0x6E, 0x91, 0xFD, 0xD1     ;Point 3
    .byte 0x79, 0x79, 0xFE, 0xBA     ;Point 4
    .byte 0x84, 0x6B, 0xFE, 0x55     ;Point 5
    .byte 0x90, 0x57, 0xFE, 0x66     ;Point 6
    .byte 0x9A, 0x47, 0xFF, 0x38     ;Point 7
    .byte 0xB1, 0x35, 0xFF, 0x5F     ;Point 8
    .byte 0xCC, 0x24                 ;Point 9

STRLMT_ColdestTempAllowedAtClosedThrottle:
    ;mpgrp 1_-_Fuel\A_-_Starting\
    ;mptbladdr 0x0716
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ColdestTempAllowedAtClosedThrottle
    ;mptblcname STRLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Coldest_temperature_accepted_as_input_to_STRTFL_table_-_anything_below_this_value_will_be_replaced_with_this_value
    .byte 0x69                       ;Point 1

EPPMUL_FuelStartFuelPerEPP:
    ;mpgrp 1_-_Fuel\A_-_Starting\
    ;mptbladdr 0x0722
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartFuelPerEPP
    ;mptblcname EPPMUL
    ;mpxaxis EPPs 0 255 count
    ;mpyaxis Factor 0 0.996 factor
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4._This_table_decreases_fuel_for_each_engine_rotation_while_starting
    .byte 0x02                       ;Number of points in table
    .byte 0x0A, 0xFF, 0xFD, 0xE6     ;Point 1
    .byte 0x28, 0xC0                 ;Point 2

STFTMP_FuelStartFuelFromCoolant:
    ;mpgrp 1_-_Fuel\A_-_Starting\
    ;mptbladdr 0x0730
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartFuelFromCoolant
    ;mptblcname STFTMP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Inverse 0 0.996 factor
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0xFF                 ;Point 1

STFBAR_FuelStartReductionFromBaro:
    ;mpgrp 1_-_Fuel\A_-_Starting\
    ;mptbladdr 0x073D
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FuelStartReductionFromBaro
    ;mptblcname STFBAR
    ;mpxaxis Baro -14.7 29.4 psi
    ;mpyaxis Inverse 0 0.996 factor
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4._This_decreases_fuel_slightly_at_higher_altitudes_to_account_for_thinner_air.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x40, 0x4D, 0xFB, 0x78     ;Point 1
    .byte 0x51, 0x00                 ;Point 2

SFDCAY_FuelStartDecayIntoRun:
    ;mpgrp 1_-_Fuel\A_-_Starting\
    ;mptbladdr 0x074C
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartDecayIntoRun
    ;mptblcname SFDCAY
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis InjectorPW 256 65535 uSec
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4._This_allows_fuel_to_decay_gradually_after_the_start-run_transition.
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x63, 0x12, 0xFF, 0xBC     ;Point 1
    .byte 0x90, 0x06, 0xFF, 0xEF     ;Point 2
    .byte 0xCC, 0x02                 ;Point 3

PRSHOT_KeyOnPrimePW:
    ;mpgrp 1_-_Fuel\A_-_Starting\
    ;mptbladdr 0x075C
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname KeyOnPrimePW
    ;mptblcname PRSHOT
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Pulsewidth 0 255 mSec
    ;mptbldesc Prime_Fuel_Shot_before_cranking
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x69, 0x54, 0xFD, 0x55     ;Point 1
    .byte 0x84, 0x0C, 0xFF, 0xEA     ;Point 2
    .byte 0x9B, 0x0A                 ;Point 3

MAPIDL_FuelBaselineFromMap:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x076C
    ;mptbltype 1
    ;mpsubtype 1
    ;mptbllname FuelBaselineFromMap
    ;mptblcname MAPIDL
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Pulsewidth 0 65535 uSec
    ;mptbldesc Base_Map_Fuel_Pulsewidth.
    ;mpmapaxis x
    ;mpinjscale scale
    .byte 0x08                   ;Point 1
    .word 0x0000, 0x1255
    .byte 0x11                   ;Point 2
    .word 0x00A5, 0x0880
    .byte 0x17                   ;Point 3
    .word 0x00D8, 0x1097
    .byte 0x39                   ;Point 4
    .word 0x030C, 0x18DA
    .byte 0x4D                   ;Point 5
    .word 0x04FD, 0x128E
    .byte 0xFF

MAPTBL_FuelPartThrottle:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x0784
    ;mptbltype 1
    ;mpsubtype 1
    ;mptbllname FuelPartThrottle
    ;mptblcname MAPTBL
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Pulsewidth 0 65535 uSec
    ;mptbldesc Fuel_at_Part_Throttle._Other_tweaks_will_be_added_to_this_amount,_to_a_MAXIMUM_of_the_Full_Throttle_table_value.
    ;mpmapaxis x
    ;mpinjscale scale
    .byte 0x04                   ;Point 1
    .word 0x0000, 0x0C36
    .byte 0x17                   ;Point 2
    .word 0x00E8, 0x128C
    .byte 0x22                   ;Point 3
    .word 0x01B4, 0x0FBA
    .byte 0x2D                   ;Point 4
    .word 0x0261, 0x1155
    .byte 0x39                   ;Point 5
    .word 0x0331, 0x0F17
    .byte 0x44                   ;Point 6
    .word 0x03D7, 0x14A3
    .byte 0x4F                   ;Point 7
    .word 0x04BA, 0x0CD5
    .byte 0x5B                   ;Point 8
    .word 0x0554, 0x1C25
    .byte 0x62                   ;Point 9
    .word 0x0619, 0x1121
    .byte 0x79                   ;Point 10
    .word 0x07A3, 0x214C
    .byte 0xFF

WOTTBL_FuelFullThrottle:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x07A6
    ;mptbltype 1
    ;mpsubtype 1
    ;mptbllname FuelFullThrottle
    ;mptblcname WOTTBL
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Pulsewidth 0 65535 uSec
    ;mptbldesc Fuel_at_Full_Throttle._This_is_also_a_maximum_for_the_Part_Throttle_value_after_other_tweaks_are_added.
    ;mpmapaxis x
    ;mpinjscale scale
    .byte 0x00                   ;Point 1
    .word 0x0000, 0x132E
    .byte 0x3D                   ;Point 2
    .word 0x0492, 0x1D0A
    .byte 0x56                   ;Point 3
    .word 0x0768, 0x17D7
    .byte 0xFF

BATOFF_FuelBatteryOffset:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x07BA
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelBatteryOffset
    ;mptblcname BATOFF
    ;mpxaxis Battery 0 16.2 Volts
    ;mpyaxis Pulsewidth 0 4095.94 uSec
    ;mptbldesc Compensates_for_slower_opening_times_of_injectors_with_lower_voltage.
    .byte 0x04                       ;Number of points in table
    .byte 0x59, 0x46, 0xFF, 0x3E     ;Point 1
    .byte 0x82, 0x27, 0xFF, 0xB4     ;Point 2
    .byte 0xC2, 0x14, 0xFF, 0xE1     ;Point 3
    .byte 0xFB, 0x0D                 ;Point 4

; *****************************************************************************
; Cold Enrichment Factor Calculation (CNRICH)
;
; 1 + ((CURVEA * ACVDCY/256 + CURVEC * ACVDCY/256 + CURVEB * FCRCVB/256) * 2 +
;     (HMPMUL * HIGHMP)/32) * BAROCP/256
;
; CURVEA, CURVEB, CURVEC Factors:
; X == Engine Temp DegC + 128 ( Engine Temp is scaled between -128C and +128C
;							      -198F and +262F
; Y == (Factor - 1) * 128 where the factor is between 1.00 and 2.99
;
; *****************************************************************************

CURVEA_FuelColdEnrichmentCurveA:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x07D7
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelColdEnrichmentCurveA
    ;mptblcname CURVEA
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis factor 1 1.996 factor
    ;mptbldesc Coldenrichment_factor_=_1_+_(_(CurveA_*_ADVDCY/256_+_CurveC_*_ADVDCY/256_+_CurveB_*_FCRCVB/256_)_/_32_)_*_BAROCP/256
    .byte 0x06                       ;Number of points in table
    .byte 0x58, 0xFF, 0xFA, 0xC9     ;Point 1
    .byte 0x74, 0x6D, 0xFD, 0xC0     ;Point 2
    .byte 0x84, 0x49, 0xFE, 0x37     ;Point 3
    .byte 0x92, 0x30, 0xFF, 0x7C     ;Point 4
    .byte 0xB1, 0x20, 0xFF, 0xCB     ;Point 5
    .byte 0xE6, 0x15                 ;Point 6

CURVEB_FuelColdEnrichmentCurveB:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x07E9
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelColdEnrichmentCurveB
    ;mptblcname CURVEB
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 1.992 factor
    ;mptbldesc Coldenrichment_factor_=_1_+_(_(CurveA_*_ADVDCY/256_+_CurveC_*_ADVDCY/256_+_CurveB_*_FCRCVB/256_)_/_32_)_*_BAROCP/256
    .byte 0x07                       ;Number of points in table
    .byte 0x58, 0xB1, 0xFC, 0x5B     ;Point 1
    .byte 0x74, 0x4B, 0xFE, 0xAE     ;Point 2
    .byte 0x90, 0x26, 0xFE, 0xC0     ;Point 3
    .byte 0xA0, 0x12, 0xFF, 0x9A     ;Point 4
    .byte 0xCD, 0x00, 0x00, 0x00     ;Point 5
    .byte 0xE8, 0x00, 0x02, 0x2B     ;Point 6
    .byte 0xF4, 0x1A                 ;Point 7

CURVEC_FuelColdEnrichmentCurveC:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x07FC
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelColdEnrichmentCurveC
    ;mptblcname CURVEC
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 1 2.992 factor
    ;mptbldesc Coldenrichment_factor_=_1_+_(_(CurveA_*_ADVDCY/256_+_CurveC_*_ADVDCY/256_+_CurveB_*_FCRCVB/256_)_/_32_)_*_BAROCP/256
    .byte 0x05                       ;Number of points in table
    .byte 0x79, 0x40, 0xFF, 0xA3     ;Point 1
    .byte 0x84, 0x3C, 0xFF, 0x55     ;Point 2
    .byte 0x8D, 0x36, 0xFA, 0x66     ;Point 3
    .byte 0x92, 0x1A, 0xFF, 0xAD     ;Point 4
    .byte 0xB1, 0x10                 ;Point 5

FCRCVB_FuelWOTScaleEnrichBFromRpm:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x080D
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelWOTScaleEnrichBFromRpm
    ;mptblcname FCRCVB
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis factor 0 0.996 factor
    ;mptbldesc B_Curve_Multiplier_is_used_at_Full_Throttle_only
    .byte 0x02                       ;Number of points in table
    .byte 0x8C, 0x00, 0xFD, 0xA0     ;Point 1
    .byte 0x9C, 0xDA                 ;Point 2

TMPHLD_TempSwitchPointForCurveAHoldDecay:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x081B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TempSwitchPointForCurveAHoldDecay
    ;mptblcname TMPHLD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Temperature_switch_point_for_Curve_A_Hold_and_Decay_times
    .byte 0xB2                       ;Point 1

CLDHLD_CurveAColdHoldTime:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x0827
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAColdHoldTime
    ;mptblcname CLDHLD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 180 out
    ;mptbldesc Curve_A_Cold_Hold_time_-_value_=_this_number_times_.704_sec
    .byte 0x10                       ;Point 1

HOTHLD_CurveAHotHoldTime:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x0833
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAHotHoldTime
    ;mptblcname HOTHLD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Curve_A_Hot_Hold_Time_-_value_=_this_number_times_.704_sec
    .byte 0x80                       ;Point 1

DCYTMC_CurveAColdDecayTime:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x083F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAColdDecayTime
    ;mptblcname DCYTMC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Curve_A_Cold_Decay_Time_-_value_=_89.76_divided_by_this_number
    .byte 0x0A                       ;Point 1

DCYTMH_CurveAHotDecayTime:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x084B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAHotDecayTime
    ;mptblcname DCYTMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Curve_A_Hot_Decay_Time_-_value_=_89.76_divided_by_this_number
    .byte 0x04                       ;Point 1

CCURV_HoldTimeForCurveC:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x0857
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HoldTimeForCurveC
    ;mptblcname CCURV
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 180 out
    ;mptbldesc Hold_Time_for_Curve_C_-_value_=_this_number_times_.704_sec
    .byte 0x07                       ;Point 1

DCYCC_DecayRateForCurveC:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x0863
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DecayRateForCurveC
    ;mptblcname DCYCC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Decay_Rate_for_Curve_C_-_value_=_89.76_divided_by_this_number
    .byte 0x0F                       ;Point 1


; *****************************************************************************
; Load Enrichment:
; Cold Load Factor == HIGHMP * HMPMUL/32
;
; HIGHMP Factors:
; X - Engine Temp
; Y - (% enrichment per Torr/100) * 32 * 5.88 * 256
;
; HMPMUL Factors:
; X - MAP in Torr * 0.17
; Y - MAP in Torr * 0.17
;
; *****************************************************************************

HIGHMP_ColdLoadFromCoolantTemp:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x087E
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ColdLoadFromCoolantTemp
    ;mptblcname HIGHMP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis enrichment 0 99.6 percent
    ;mptbldesc Cold_Load_Enrichment_Factor
    .byte 0x02                       ;Number of points in table
    .byte 0x7F, 0x6F, 0xF9, 0x78     ;Point 1
    .byte 0x90, 0x00                 ;Point 2

HMPMUL_ColdLoadFromMAP:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x088C
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname ColdLoadFromMAP
    ;mptblcname HMPMUL
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Factor 0 99.6 percent
    ;mptbldesc Cold_Load_Enrichment_Multiplier
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x17, 0x00, 0x01, 0x80     ;Point 1
    .byte 0x1F, 0x0C                 ;Point 2

HIGHM2_ColdLoadFromCoolantTemp2:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x089B
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ColdLoadFromCoolantTemp2
    ;mptblcname HIGHM2
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis enrichment 0 99.6 percent
    ;mptbldesc Cold_Load_Enrichment_Factor
    .byte 0x03                       ;Number of points in table
    .byte 0x84, 0x56, 0xFB, 0xC0     ;Point 1
    .byte 0x90, 0x23, 0xEE, 0x80     ;Point 2
    .byte 0x92, 0x00                 ;Point 3

HMPMU2_ColdLoadFromMAP2:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x08AA
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname ColdLoadFromMAP2
    ;mptblcname HMPMU2
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Factor 0 99.6 percent
    ;mptbldesc Cold_Load_Enrichment_Multiplier
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x1E, 0x00, 0x01, 0x27     ;Point 1
    .byte 0x38, 0x1E                 ;Point 2


BAROCP_BaroCompensationOfWarmupFactor_FromBaro:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x08BA
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BaroCompensationOfWarmupFactor_FromBaro
    ;mptblcname BAROCP
    ;mpxaxis Baro -14.7 29.4 psi
    ;mpyaxis Factor 0 99.6 percent
    ;mptbldesc Baro_compensation_of_Warmup_Factor
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x4A, 0xDC, 0xD4, 0x00     ;Point 1
    .byte 0x4F, 0x00                 ;Point 2

RUNTMP_ModifierOf_ENGTMP_FromStalltime:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x08C9
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

RUNLMT_MaxAllowableTempFor_RUNTMP:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x08D8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxAllowableTempFor_RUNTMP
    ;mptblcname RUNLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Max_allowable_temp_for_RUNTMP_(heat_soak_approximation)
    .byte 0x95                       ;Point 1

PEFTBL_PumpingEfficiency:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x08E4
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname PumpingEfficiency_FromRpm
    ;mptblcname PEFTBL
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis PumpEff 0 99.6 percent
    ;mptbldesc Pumping_Efficiency
    .byte 0x0A                       ;Number of points in table
    .byte 0x13, 0xF2, 0xF7, 0x00     ;Point 1
    .byte 0x14, 0xE9, 0xF9, 0x55     ;Point 2
    .byte 0x17, 0xD5, 0x00, 0x00     ;Point 3
    .byte 0x3F, 0xD5, 0x00, 0x95     ;Point 4
    .byte 0x4B, 0xDC, 0x00, 0x15     ;Point 5
    .byte 0x57, 0xDD, 0x00, 0x51     ;Point 6
    .byte 0x7D, 0xE9, 0xFF, 0xBE     ;Point 7
    .byte 0x98, 0xE2, 0xFF, 0x27     ;Point 8
    .byte 0xA5, 0xD7, 0xFE, 0xF2     ;Point 9
    .byte 0xDC, 0x9D                 ;Point 10

AIRTMP_FuelEnrichmentFromChargeTemp: ;copied from the '89T2 calibration, does not exsist in the '89T1 cals
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x08FA
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelEnrichmentFromChargeTemp
    ;mptblcname AIRTMP
    ;mpxaxis Charge_Temp 0 5 volts
    ;mpyaxis factor 1 1.996 factor
    ;mptbldesc Charge_Temp_Factor._Note_that_this_is_an_unfiltered_charge_temp_voltage,_so_higher_numbers_are_lower_temps
    .byte 0x05                       ;Number of points in table
    .byte 0x1A, 0x00, 0x00, 0x29     ;Point 1
    .byte 0x59, 0x0A, 0x00, 0x2F     ;Point 2
    .byte 0x90, 0x14, 0x00, 0x4B     ;Point 3
    .byte 0xE9, 0x2E, 0x01, 0x00     ;Point 4
    .byte 0xFB, 0x40                 ;Point 5

PWADD_FuelPWModifierFromBaro:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x090B
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FuelPWModifierFromBaro
    ;mptblcname PWADD
    ;mpxaxis Baro -14.7 29.4 psi
    ;mpyaxis Pulsewidth 0 12288 uSec
    ;mptbldesc Additive_Baro_Fuel_Compensation_-_fuel_added_based_on_altitude
    ;mpmapaxis x
    ;mpinjscale scale
    .byte 0x01                       ;Number of points in table
    .byte 0xAA, 0x00                 ;Point 1

POSTRG_PositiveTransientTriggerLevel:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0x091A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PositiveTransientTriggerLevel
    ;mptblcname POSTRG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Positive_Transient_Enrich_Trigger_Level_in_volts_times_0.02
    .byte 0x04                       ;Point 1

THRMAX_MaxDeltaTHR:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0x0926
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxDeltaTHR
    ;mptblcname THRMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Max_Delta_THR_(THR-AVTHR-POSTRG)_-_value_of_$26_is_.51_volts
    .byte 0x26                       ;Point 1

POSSLP_DeltaTPSEnrichment_FromTemp:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0x0932
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname Enrichment_FromTemp
    ;mptblcname POSSLP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis pw 0 60 ms/volt
    ;mptbldesc Throttle_Transient_Enrich_PW_Addition
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x74, 0x1E, 0xFF, 0x5B     ;Point 1
    .byte 0x90, 0x0C, 0xFF, 0xE1     ;Point 2
    .byte 0xB1, 0x08                 ;Point 3

MAPTRG_DeltaMapTriggerLevel:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x0942
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapTriggerLevel
    ;mptblcname MAPTRG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 44.1 psi
    ;mptbldesc MAP_Delta_required_to_trigger_transient_enrichment
    ;mpmapaxis y
    .byte 0x03                       ;Point 1

MAPMAX_MaxDeltaMapAllowed:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x094F
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MaxDeltaMapAllowed
    ;mptblcname MAPMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 44.1 psi
    ;mptbldesc Maximum_Delta_MAP_allowed
    ;mpmapaxis y
    .byte 0xAA                       ;Point 1

AESLOP_DeltaMAPEnrichmentPT:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x095C
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname DeltaMAPEnrichmentPT
    ;mptblcname AESLOP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis pwEnrich 0 255 uS/torr
    ;mptbldesc Transient_Enrichment_PW_Addition
    ;mpmapaxis -y
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x58, 0x8D, 0xFE, 0xDB     ;Point 1
    .byte 0x90, 0x4D, 0xFE, 0xEF     ;Point 2
    .byte 0xCD, 0x0C                 ;Point 3

	;.org	0xc2ea
OCTAE_FakeDeltaMapIncrease:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x096E
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname FakeDeltaMapIncrease
    ;mptblcname OCTAE
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc Fake_Delta_Map_Increase._AVMAP_is_set_to_(MAP-OCTAE)_any_time_throttle_is_just_opened.
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

	;.org	0xc2f2
LOTTHR_DecelLeanoutFactor_FromTemp:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_TPS_LO\
    ;mptbladdr 0x097C
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelLeanoutFactor_FromTemp
    ;mptblcname LOTTHR
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 0.996 factor
    ;mptbldesc Decel_leanout_factor_-_THR_based._When_Y_is_zero,_factor_is_1.00
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0xc301
LOTTRG_DeltaTriggerForDecelLeanout:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_TPS_LO\
    ;mptbladdr 0x098A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaTriggerForDecelLeanout
    ;mptblcname LOTTRG
    ;mpxaxis in_desc -200 260 degrees
    ;mpyaxis Factor 0 0.996 percent
    ;mptbldesc Main_trigger_(Delta_trigger_level_for_THR_leanout)_-_Delta_THR
    .byte 0x0A                       ;Point 1

	;.org	0xc302
LOTRG2_SecondDecelLeanoutTrigger:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_TPS_LO\
    ;mptbladdr 0x0997
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SecondDecelLeanoutTrigger
    ;mptblcname LOTRG2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Second_trigger_-_leanout_inc_toward_1_when_between_triggers
    .byte 0x04                       ;Point 1

	;.org	0xc303
LOTHYS_LeanoutDeltaThrottleHysteresis:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_TPS_LO\
    ;mptbladdr 0x09A4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LeanoutDeltaThrottleHysteresis
    ;mptblcname LOTHYS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc hysteresis_about_delta_THR_trigger_levels
    .byte 0x02                       ;Point 1

	;.org	0xc309
DECEL_DecelLeanoutFactorMAP:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x09B1
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelLeanoutFactorMAP_FromTemp
    ;mptblcname DECEL
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 0.996 factor
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Number of points in table
    .byte 0x00, 0xE8                 ;Point 1

	;.org	0xc305
DECTRG_DeltaMapTriggerForNoIncrementalLeanout:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x09BF
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapTriggerForNoIncrementalLeanout
    ;mptblcname DECTRG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc delta_map_trigger_level_for_no_incremental_leanout
    ;mpmapaxis y
    .byte 0x03                       ;Point 1

	;.org	0xc306
DTRG2_DeltaMapTriggerForMaxLeanout:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x09CD
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapTriggerForMaxLeanout
    ;mptblcname DTRG2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc delta_map_trigger_level_for_max_leanout_on_decel
    ;mpmapaxis y
    .byte 0x08                       ;Point 1

	;.org	0xc307
DECHYS_DeltaMapHysteresisonTriggerLevels:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x09DB
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapHysteresisonTriggerLevels
    ;mptblcname DECHYS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc delta_map_hysteresis_on_trigger_levels
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

DLTRPM2_RPMDeltaForRPMFilter:
    ;mpgrp 0_-_Setup\D_-_Transfer_Functions\
    ;mptbladdr 0x09E8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMDeltaForRPMFilter
    ;mptblcname DLTRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Delta_RPM_at_RPM_Boundaries
    .byte 0xFF                       ;Point 1

	;.org	0xc304
LOTRPM_MinRpmForMapLeanout:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x09F5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinRpmForMapLeanout
    ;mptblcname LOTRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc No_map_leanout_if_below_this_RPM
    .byte 0x2F                       ;Point 1

	;.org	0xc308
DCELTM_O2CNTRInhibitAfterLeanoutDone:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x0A02
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2CNTRInhibitAfterLeanoutDone
    ;mptblcname DCELTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2CNTR_inhibit_after_MAP/THR_leanout_is_done_(times_11_ms)
    .byte 0x01                       ;Point 1

	;.org	0xc30b
POSTIG_MinAisPulseRequireToTriggerEnrichment:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\AIS_PumpShot\
    ;mptbladdr 0x0A0F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinAisPulseRequireToTriggerEnrichment
    ;mptblcname POSTIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Min_AIS_pulse_required_to_trigger_enrichment_(steps)
    .byte 0x08                       ;Point 1

	;.org	0xc30c
POSFUL_AisEnrichmentFuelPulse:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\AIS_PumpShot\
    ;mptbladdr 0x0A1C
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname AisEnrichmentFuelPulse
    ;mptblcname POSFUL
    ;mpxaxis in_desc 0 65535 scale
    ;mpyaxis AISPW 0 65535 uSec
    ;mptbldesc AIS_enrichment_fuel_pulse_in_uSec
    ;mpinjscale word
    .word 0x0105                     ;Point 1

LMAPTC_TimeConstant:
; this is actually one of the 2 MAP averaging factor tables
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x0A2A
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TimeConstant
    ;mptblcname LMAPTC
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 0.996 factor
    ;mptbldesc lean_out_time_constant_based_on_MAP
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x28                 ;Point 1

AETIME_EnrichmentTime_FromTemp:
; this is actually one of the 2 MAP averaging factor tables
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x0A38
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname EnrichmentTime_FromTemp_MAP
    ;mptblcname AETIME
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 0.996 factor
    ;mptbldesc MAP_Transient_Enrich_Time_Constant_when_MAP_gt_AVMAP
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x14                 ;Point 1

THRTCN_EnrichmentTime_FromTemp:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0x0A45
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname EnrichmentTime_FromTemp_TPS
    ;mptblcname THRTCN
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 0.996 factor
    ;mptbldesc Throttle_Transient_Enrich_Time_Constant
    .byte 0x02                       ;Number of points in table
    .byte 0x74, 0x18, 0x00, 0x17     ;Point 1
    .byte 0xCD, 0x20                 ;Point 2

LOTIME_DecelLeanoutTimeConstant_FromTemp:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_TPS_LO\
    ;mptbladdr 0x0A53
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelLeanoutTimeConstant_FromTemp
    ;mptblcname LOTIME
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 0.996 factor
    ;mptbldesc Leanout_Time_Constant_based_on_Delta_THR_-_uses_average_throttle
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0xFF                 ;Point 1

	;.org	0xc30e
RPMMAP_SwitchPointForDownUp_FromRpm:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0A61
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname SwitchPointForDownUp_FromRpm
    ;mptblcname RPMMAP
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc EPP_Control_toggle
    ;mpmapaxis y
    .byte 0x05                       ;Number of points in table
    .byte 0x4C, 0x70, 0xFB, 0x00     ;Point 1
    .byte 0x4E, 0x66, 0x00, 0x00     ;Point 2
    .byte 0x64, 0x66, 0xFE, 0xBA     ;Point 3
    .byte 0x85, 0x3C, 0xFF, 0x77     ;Point 4
    .byte 0xA1, 0x2D                 ;Point 5

	;.org	0xc325
PTELMT_MultiplierMaxLimitFromRpm:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0A74
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname MultiplierMaxLimitFromRpm
    ;mptblcname PTELMT
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Factor 0 0.996 percent
    ;mptbldesc PTE_Multiplier_limit
    .byte 0x06                       ;Number of points in table
    .byte 0x3F, 0x3E, 0xFF, 0x37     ;Point 1
    .byte 0x5B, 0x28, 0x00, 0xC3     ;Point 2
    .byte 0x70, 0x38, 0x00, 0x78     ;Point 3
    .byte 0x90, 0x47, 0x00, 0x00     ;Point 4
    .byte 0xA2, 0x47, 0x01, 0x27     ;Point 5
    .byte 0xAF, 0x56                 ;Point 6

	;.org	0xc33c
PTEADJ_EnrichAdjust_FromMap:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0A87
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname EnrichAdjust_FromMap
    ;mptblcname PTEADJ
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Factor 0.5 1.496 factor
    ;mptbldesc Part_Throttle_Enrichment_-_multiplier_from_MAP_-_NOTE:_zero_is_1.00
    ;mpmapaxis x
    .byte 0x06                       ;Number of points in table
    .byte 0x39, 0xA6, 0x04, 0x60     ;Point 1
    .byte 0x49, 0xEC, 0x00, 0x00     ;Point 2
    .byte 0x65, 0xEC, 0x04, 0x00     ;Point 3
    .byte 0x6A, 0x00, 0x00, 0x00     ;Point 4
    .byte 0x89, 0x00, 0xFC, 0x00     ;Point 5
    .byte 0x8F, 0xE8                 ;Point 6

	;.org	0x8421
PTENR_EppPerAmountForIncreasing:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0A9B
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname EppPerAmountForIncreasing
    ;mptblcname PTENR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EPP_per_amount_for_increasing_multiplier
    .word 0x3D01                     ;Point 1

	;.org	 0x8423
PTENR2_EppPerAmountForDecreasingMultiplier:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0AA8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EppPerAmountForDecreasingMultiplier
    ;mptblcname PTENR2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EPP_per_amount_for_decreasing_multiplier
    .byte 0x3D                       ;Point 1

	;.org	0x8424
PTENRD_AmountForDecreasingMultiplier_Negative:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0AB5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AmountForDecreasingMultiplier_Negative
    ;mptblcname PTENRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Amount_for_decreasing_multiplier_(neg_number)
    .byte 0xFF                       ;Point 1

	;.org	0xc357
PTENUM_NumberToReturnToHOTMAP:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0AC2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NumberToReturnToHOTMAP
    ;mptblcname PTENUM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc No_of_PTENRD_below_PTELMT_that_PT_enrich_must_be_to_return_to_HOTMAP_spark_advance_after_maxed_out
    .byte 0x02                       ;Point 1

	;.org	0xc359
BOOSTP_AdjustO2ResponseForPTEWhenMapAboveThis:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0ACF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdjustO2ResponseForPTEWhenMapAboveThis
    ;mptblcname BOOSTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc Zero_percent_limit_on_lean_O2CNTR_if_MAP_gt_BOOSTP_and_no_PTE
    .byte 0xFF                       ;Point 1

	;.org	0xc35a
O2ITIM_TimeO2InhibitedSwitchingRichIdleToClosedLoop:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0ADC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeO2InhibitedSwitchingRichIdleToClosedLoop
    ;mptblcname O2ITIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2_is_inhibited_for_this_time_when_switching_from_rich_idle_to_closed_loop_idle
    .byte 0xFF                       ;Point 1

	;.org	0xc35b
RICHSA_OpenLoopEnrichFactorWhenSettingBasicTiming:
    ;mpgrp 5_-_Idle\C_-_Special_setup\
    ;mptbladdr 0x0AE9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OpenLoopEnrichFactorWhenSettingBasicTiming
    ;mptblcname RICHSA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Open_loop_enrich_factor_when_setting_mechanical_basic_timing
    .byte 0x34                       ;Point 1

	;.org	0xc35c
SPKSET_ConstantSparkAdvanceWhenSettingBasicTiming:
    ;mpgrp 5_-_Idle\C_-_Special_setup\
    ;mptbladdr 0x0AF6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ConstantSparkAdvanceWhenSettingBasicTiming
    ;mptblcname SPKSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Advance 0 127.5 degrees
    ;mptbldesc Constant_spark_advance_setting_when_setting_basic_timing_(stock_12_degrees)
    .byte 0x0C                       ;Point 1

	;.org	0x842a
IDLDEF_TargetIdleSpeed_HBDefault:
    ;mpgrp 5_-_Idle\C_-_Special_setup\
    ;mptbladdr 0x0B03
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TargetIdleSpeed_HBDefault
    ;mptblcname IDLDEF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x7D                       ;Point 1

	;.org	0xc35d
RIDLST_OpenLoopEnrichFactorWhenSettingMinThrottleOpening:
    ;mpgrp 5_-_Idle\C_-_Special_setup\
    ;mptbladdr 0x0B10
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OpenLoopEnrichFactorWhenSettingMinThrottleOpening
    ;mptblcname RIDLST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Open_loop_enrich_factor_when_setting_min_throttle_blade_opening_(actuator_test_#70)
    .byte 0x34                       ;Point 1

	;.org	0xc35e
IDLSET_ConstantSparkAdvanceWhenSettingMinThrottleOpening:
    ;mpgrp 5_-_Idle\C_-_Special_setup\
    ;mptbladdr 0x0B1D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ConstantSparkAdvanceWhenSettingMinThrottleOpening
    ;mptblcname IDLSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Advance 0 127.5 degrees
    ;mptbldesc Constant_spark_advance_setting_when_setting_min_throttle_blade_opening_(actuator_test_#70)
    .byte 0x0C                       ;Point 1

	;.org	0xc361
AMTEMP_StartTempToSelectHotOrColdAMTimer:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Adaptive_Memory_Timer\
    ;mptbladdr 0x0B2A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StartTempToSelectHotOrColdAMTimer
    ;mptblcname AMTEMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc Starting_Temp_to_select_hot_or_cold_AM_timer
    .byte 0xCD                       ;Point 1

	;.org	0xc364
AMTPSW_TempPointToEnableSelectedAMTimer:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Adaptive_Memory_Timer\
    ;mptbladdr 0x0B37
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempPointToEnableSelectedAMTimer
    ;mptblcname AMTPSW
    ;mpxaxis Coolant_Temp -200 260 deg
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AM_temp_inhibit_time_from_coolant_temp
    .byte 0x01                       ;Number of points in table
    .byte 0x00, 0xCD                 ;Point 1

	;.org	0xc367
CLTIME_ClosedLoopTimeFromEngTempAtStartup_FromTemp:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Adaptive_Memory_Timer\
    ;mptbladdr 0x0B45
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ClosedLoopTimeFromEngTempAtStartup_FromTemp
    ;mptblcname CLTIME
    ;mpxaxis Coolant_Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Leave_at_one_-_2.8_sec
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x03                 ;Point 1

	;.org	0xc37a
CLTEMP_TempToStartCLTIMETimer:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Adaptive_Memory_Timer\
    ;mptbladdr 0x0B53
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TempToStartCLTIMETimer
    ;mptblcname CLTEMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 degrees
    ;mptbldesc Temperature_to_start_CLTIME_Timer_-_$94_=_70degreesF
    .byte 0x95                       ;Point 1

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

	;.org	0xc37b
MP1_AutoCalMapCellBoundary1:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0B70
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary1
    ;mptblcname MP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc AutoCalMapCellBoundary1
    ;mpmapaxis y
    .byte 0x1B                       ;Point 1

	;.org	0xc37c
MP2_AutoCalMapCellBoundary2:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0B7E
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary2
    ;mptblcname MP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc AutoCalMapCellBoundary2
    ;mpmapaxis y
    .byte 0x29                       ;Point 1

	;.org	0xc37d
MP3_AutoCalMapCellBoundary3:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0B8C
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary3
    ;mptblcname MP3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc AutoCalMapCellBoundary3
    ;mpmapaxis y
    .byte 0x36                       ;Point 1

	;.org	0xc37e
MP4_AutoCalMapCellBoundary4:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0B9A
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary4
    ;mptblcname MP4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc AutoCalMapCellBoundary4
    ;mpmapaxis y
    .byte 0x43                       ;Point 1

	;.org	0xc37f
MP5_AutoCalMapCellBoundary5:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0BA8
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary5
    ;mptblcname MP5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc AutoCalMapCellBoundary5
    ;mpmapaxis y
    .byte 0x50                       ;Point 1

	;.org	0xc380
DLTMAP_MapHysteresisAtMapCellBoundaries:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0BB6
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MapHysteresisAtMapCellBoundaries
    ;mptblcname DLTMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc Map_Hysteresis_At_Map_Cell_Boundaries
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

	;.org	0xc381
R1_RPMCellBoundaryInRPMover32:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0BC4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMCellBoundaryInRPMover32
    ;mptblcname R1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Engine_RPM 0 8160 RPM
    ;mptbldesc RPM_Cell_Boundary
    .byte 0x3A                       ;Point 1

	;.org	0xc382
DLTRPM_DeltaRPMAtRPMBoundariesInRPMOver32:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0BD1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaRPMAtRPMBoundariesInRPMOver32
    ;mptblcname DLTRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Delta_RPM_at_RPM_Boundaries
    .byte 0x02                       ;Point 1

	;.org	0xc383
IDLOFS_DeltaForIdleRPMForClosedThrottleCell:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0BDE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaForIdleRPMForClosedThrottleCell
    ;mptblcname IDLOFS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc RPM_Delta_for_Idle_RPM_For_Closed_Throttle_Cell
    .byte 0x03                       ;Point 1

	;.org	0xc384
HYTRPM_HysteresisFor_IDLOFS:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0BEB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HysteresisFor_IDLOFS
    ;mptblcname HYTRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Hysteresis_for_IDLOFS
    .byte 0x02                       ;Point 1

	;.org	0xc385
CELCHG_BitsChangePerUpdateWithinACell:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0BF8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BitsChangePerUpdateWithinACell
    ;mptblcname CELCHG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_Bits_Change_Per_Update_Within_A_Cell
    .byte 0x01                       ;Point 1

	;.org	0xc386
AMUPDT_EPPsBetweenCalChangeUpdateOpenThrottle:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0C05
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EPPsBetweenCalChangeUpdateOpenThrottle
    ;mptblcname AMUPDT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EPPs_Between_Cal_Change_Update_(Open_Throttle)
    .byte 0x1A                       ;Point 1

	;.org	0xc387
AMUPDI_EPPsBetweenCalChangeUpdateClosedThrottle:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0C12
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EPPsBetweenCalChangeUpdateClosedThrottle
    ;mptblcname AMUPDI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EPPs_Between_Cal_Change_Update_(Closed_Throttle)
    .byte 0x1A                       ;Point 1

	;.org	0xc388
CALTHR_O2ControllerDeadbandLimitForUpdatingCells:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0C1F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2ControllerDeadbandLimitForUpdatingCells
    ;mptblcname CALTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2_Controller_Deadband_Limit_For_Updating_Cells
    .byte 0x09                       ;Point 1

	;.org	0xc389
MAPLIM_NoCellUpdateAboveThisMAP:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0C2C
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname NoCellUpdateAboveThisMAP
    ;mptblcname MAPLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc No_Cell_Update_Above_This_MAP
    ;mpmapaxis y
    .byte 0x61                       ;Point 1

	;.org	0xc38a
MAPDEC_NoCellUpdateAndO2CNTRHeldBelowThisMap:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0C3A
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname NoCellUpdateAndO2CNTRHeldBelowThisMap
    ;mptblcname MAPDEC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc No_Cell_Update_And_O2CNTR_Held_Below_This_Map._Set_to_0xff_to_disable_O2_feedback.
    ;mpmapaxis y
    .byte 0x0D                       ;Point 1

	;.org	0xc38b
RPMLIM_NoCellUpdateAboveThisRPMInRPMOver32:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0C48
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoCellUpdateAboveThisRPMInRPMOver32
    ;mptblcname RPMLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Engine_RPM 0 8160 rpm
    ;mptbldesc No_Cell_Update_Above_This_RPM_-_in_rpms/32
    .byte 0x77                       ;Point 1

	;.org	0xc38c
AMLIMH_MaxMultiplierCannotBeAbove7F:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0C55
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxMultiplierCannotBeAbove7F
    ;mptblcname AMLIMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AutoCal_Range_Of_Authority_where_MaxMultiplier=1+AMLIMH/512_(cannot_exceed_$7f)
    .byte 0x7F                       ;Point 1

	;.org	0xc38d
AMLIML_MinMultiplierCannotBeBelow80:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0C62
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinMultiplierCannotBeBelow80
    ;mptblcname AMLIML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AutoCal_Range_Of_Authority_where_MinMultiplier=.5+AMLIML/512_(cannot_be_below_$80)
    .byte 0xB3                       ;Point 1

	;.org	0xc365
PWMIN_NoCellUpdateBelow_PWMIN_Pulsewidth:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0C6F
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname NoCellUpdateBelow_PWMIN_Pulsewidth
    ;mptblcname PWMIN
    ;mpxaxis in_desc 0 65535 scale
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc No_Cell_Update_below_PWMIN_-_this_value_times_4_uSec
    ;mpinjscale word
    .word 0x00C9                     ;Point 1

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
;     From http://www.faqs;.org/faqs/autos/gasoline-faq/part2/ comes the following table
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

	;.org	0xc38e
PRIRMP_PrimaryRamp:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\O2_Controller_Ramps\
    ;mptbladdr 0x0CC8
    ;mptbltype 11
    ;mpsubtype 1
    ;mptbllname PrimaryRamp
    ;mptblcname PRIRMP
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Lower_RPM_Boundary_-_RPM/32
    ;mpmapaxis y
    .word 0x262C                  ;Rpm Low / High Boundary
    .word 0x2235                  ;Map Low / High Boundary
    .word 0x1A04                  ;Cell 0 Ramp Rich/Lean
    .word 0x1A05                  ;Cell 1 Ramp Rich/Lean
    .word 0x1A05                  ;Cell 2 Ramp Rich/Lean
    .word 0x1A04                  ;Cell 3 Ramp Rich/Lean
    .word 0x1A05                  ;Cell 4 Ramp Rich/Lean
    .word 0x1A05                  ;Cell 5 Ramp Rich/Lean
    .word 0x1A04                  ;Cell 6 Ramp Rich/Lean
    .word 0x1A05                  ;Cell 7 Ramp Rich/Lean
    .word 0x1A05                  ;Cell 8 Ramp Rich/Lean
    .word 0x0101                  ;Ramp Idle Cell Rich/Lean
    .word 0x0F0F                  ;Cell 0 Limits/Rates Rich/Lean
    .word 0x1515                  ;Cell 1 Limits/Rates Rich/Lean
    .word 0x1515                  ;Cell 2 Limits/Rates Rich/Lean
    .word 0x0F0F                  ;Cell 3 Limits/Rates Rich/Lean
    .word 0x1515                  ;Cell 4 Limits/Rates Rich/Lean
    .word 0x1515                  ;Cell 5 Limits/Rates Rich/Lean
    .word 0x0F0F                  ;Cell 6 Limits/Rates Rich/Lean
    .word 0x1515                  ;Cell 7 Limits/Rates Rich/Lean
    .word 0x1515                  ;Cell 8 Limits/Rates Rich/Lean
    .word 0x0101                  ;Limit/Rates Idle Cell Rich/Lean

; *****************************************
; For each cell, the first number is "rich", the second is "lean".
; If the O2 sensor is returning a lean value, "rich" kicks are added.
; If the O2 sensor is returning a rich value, "lean" kicks are added.
;
;     KICK - (factor * 512) - 512  (unsigned number)
; eg: %5  ->  (1.05  * 512) - 512 = 25.6 (dec) = 0x19
; each bit is ~ 0.2%
; *****************************************


	;.org	0xc3ba
O2LIMH_O2RangeLimitHigh:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0CF6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2RangeLimitHigh
    ;mptblcname O2LIMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2_Range_Of_Authority_MaxMultiplier=1+O2LIMH/512_(cannot_be_above_$7f)
    .byte 0x7F                       ;Point 1

	;.org	0xc3bb
O2LIML_O2RangeLimitLow:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0D03
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2RangeLimitLow
    ;mptblcname O2LIML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2_Range_Of_Authority_MinMultiplier=.5+O2LIML/512_(cannot_be_below_$80)
    .byte 0xB3                       ;Point 1

	;.org	0xc3bc
O2HIGH_HighLimitForImmediateSwitchToClosedLoop:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0D10
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForImmediateSwitchToClosedLoop
    ;mptblcname O2HIGH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HighLimitForImmediateSwitchToClosedLoop_$26_=_0.73v
    .byte 0x26                       ;Point 1

	;.org	0xc3bd
O2TLMH_HighLimitForDelayedSwitchToClosedLoop:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0D1D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForDelayedSwitchToClosedLoop
    ;mptblcname O2TLMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HighLimitForDelayedSwitchToClosedLoop
    .byte 0x1F                       ;Point 1

	;.org	0xc3be
O2MIDH_HighLimitForInMiddleDetermination:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0D2A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForInMiddleDetermination
    ;mptblcname O2MIDH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HighLimitForInMiddleDetermination
    .byte 0x1C                       ;Point 1

	;.org	0xc3bf
O2HSWP_HighLimitForO2RampSwitching:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0D37
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForO2RampSwitching
    ;mptblcname O2HSWP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HighLimitForO2RampSwitching
    .byte 0x17                       ;Point 1

	;.org	0xc3c0
O2LSWP_LowLimitForO2RampSwitching:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0D44
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForO2RampSwitching
    ;mptblcname O2LSWP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LowLimitForO2RampSwitching
    .byte 0x16                       ;Point 1

	;.org	0xc3c1
O2MIDL_LowLimitForInMiddleDetermination:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0D51
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForInMiddleDetermination
    ;mptblcname O2MIDL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LowLimitForInMiddleDetermination._Used_for_Reverting_to_openLoop,_Setting_fault21,_outputting_O2_level_to_miller_tool
    .byte 0x12                       ;Point 1

	;.org	0xc3c2
O2TLML_LowLimitForDelayedSwitchToClosedLoop:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0D5E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForDelayedSwitchToClosedLoop
    ;mptblcname O2TLML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LowLimitForDelayedSwitchToClosedLoop
    .byte 0x0F                       ;Point 1

	;.org	0xc3c3
O2LOW_LowLimitForImmediateSwitchToClosedLoop:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0D6B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForImmediateSwitchToClosedLoop
    ;mptblcname O2LOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LowLimitForImmediateSwitchToClosedLoop
    .byte 0x0F                       ;Point 1

	;.org	0xc3c4
O2TIME_DelayTimeToClosedLoop:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0D78
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DelayTimeToClosedLoop
    ;mptblcname O2TIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Delay_Time 0 720 Sec
    ;mptbldesc DelayTimeWhenGoingClosedLoop._o2_voltage_must_trigger_timer,_ie_must_gt_O2TLMH_or_lt_O2TLML.Each_1_is_2.8_sec,_cannot_exceed_$7f
    .byte 0x07                       ;Point 1

	;.org	0xc3c5
LTHTIM_IfNoO2SwitchForThisTimeThrowFault51or52:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0D85
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname IfNoO2SwitchForThisTimeThrowFault51or52
    ;mptblcname LTHTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc If_no_O2_sensor_state_change_for_this_time(*2.8sec)_then_fault_51_or_52
    .byte 0x2B                       ;Point 1

	;.org	0xc3c6
SECRMP_SecondaryRamp:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\O2_Controller_Ramps\
    ;mptbladdr 0x0D92
    ;mptbltype 11
    ;mpsubtype 1
    ;mptbllname SecondaryRamp
    ;mptblcname SECRMP
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Lower_RPM_Boundary_-_RPM/32
    ;mpmapaxis y
    .word 0x2636                  ;Rpm Low / High Boundary
    .word 0x1D35                  ;Map Low / High Boundary
    .word 0x03FD                  ;Cell 0 Ramp Rich/Lean
    .word 0x01FF                  ;Cell 1 Ramp Rich/Lean
    .word 0x01FF                  ;Cell 2 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 3 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 4 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 5 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 6 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 7 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 8 Ramp Rich/Lean
    .word 0x02FE                  ;Ramp Idle Cell Rich/Lean
    .word 0x0308                  ;Cell 0 Limits/Rates Rich/Lean
    .word 0x0308                  ;Cell 1 Limits/Rates Rich/Lean
    .word 0x0308                  ;Cell 2 Limits/Rates Rich/Lean
    .word 0x0308                  ;Cell 3 Limits/Rates Rich/Lean
    .word 0x0308                  ;Cell 4 Limits/Rates Rich/Lean
    .word 0x0308                  ;Cell 5 Limits/Rates Rich/Lean
    .word 0x0308                  ;Cell 6 Limits/Rates Rich/Lean
    .word 0x0308                  ;Cell 7 Limits/Rates Rich/Lean
    .word 0x0308                  ;Cell 8 Limits/Rates Rich/Lean
    .word 0x0308                  ;Limit/Rates Idle Cell Rich/Lean

; *****************************************
; For each cell, the first number is "rich", the second is "lean".
; If the O2 sensor is returning a lean value, "rich" kicks are added.
; If the O2 sensor is returning a rich value, "lean" kicks are added.
;
;     STEP - (factor * 512) - 512  (signed number)
; eg: %0.4  ->	(1.004	* 512) - 512 = 2.048 (dec) = 0x02
; each bit is ~ 0.2%
; *****************************************

	;.org	0xc3f2
AISTRT_AisStartupPosition_FromTemp:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0DBF
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisStartupPosition_FromTemp
    ;mptblcname AISTRT
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis AIS_Open 0 255 steps
    ;mptbldesc AIS_motor_startup_position_from_engine_temp
    .byte 0x05                       ;Number of points in table
    .byte 0x6E, 0x99, 0xFC, 0x0D     ;Point 1
    .byte 0x81, 0x4E, 0xFF, 0x1A     ;Point 2
    .byte 0xCF, 0x08, 0x00, 0x00     ;Point 3
    .byte 0xE4, 0x08, 0x00, 0x20     ;Point 4
    .byte 0xF4, 0x0A                 ;Point 5


	;.org	0x84d5
RPMDEF_RPMDefaultForIdleControl:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0DD2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMDefaultForIdleControl
    ;mptblcname RPMDEF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0xA0                       ;Point 1

	;.org	0x84d6
RPMTHS_RPMThresholdForIdleControl:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0DDF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMThresholdForIdleControl
    ;mptblcname RPMTHS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x19                       ;Point 1

; this table replaces the 2 constants in the '89 T2 - STTIME and DRIDHT
TIMED2_AISDecelBaseAirflowCurveOffset2:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0DEC
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelAisBaseAirflowCurveOffset_FromTime2
    ;mptblcname TIMED2
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis Time 0 720 sec
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x13, 0x0D, 0xFD, 0xD5     ;Point 1
    .byte 0x16, 0x00                 ;Point 2


	;.org	0xc407
AISDLY_DelayFromStartRunThatAisFeedbackDisabled:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0DFC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DelayFromStartRunThatAisFeedbackDisabled
    ;mptblcname AISDLY
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 720 sec
    ;mptbldesc Delay_from_Start/Run_transition_that_AIS_feedback_is_disabled_in_11msec_units
    .byte 0x2D                       ;Point 1

	;.org	0xc408
AISPN_IdleSpeedParkNeutral_FromTemp:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E09
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname IdleSpeedParkNeutral_FromTemp
    ;mptblcname AISPN
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis RPM 0 2048 rpm
    ;mptbldesc Idle_Speed_From_Temp_in_park/neutral_or_manual_trans
    .byte 0x02                       ;Number of points in table
    .byte 0x7F, 0xAF, 0xFF, 0x2F     ;Point 1
    .byte 0xCC, 0x70                 ;Point 2

	;.org	0xc41b
AISCLD_IdleSpeedDrive_FromTemp:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E18
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname IdleSpeedDrive_FromTemp
    ;mptblcname AISCLD
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis RPM 0 2048 rpm
    ;mptbldesc Idle_Speed_From_temp_in_Drive,_auto_trans_only
    .byte 0x02                       ;Number of points in table
    .byte 0x7F, 0x96, 0xFF, 0x5A     ;Point 1
    .byte 0xCC, 0x64                 ;Point 2

	;.org	0xc42e
CLDPOS_AisColdPosition_FromTemp:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E27
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisColdPosition_FromTemp
    ;mptblcname CLDPOS
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis AIS_Open 0 2048 steps
    ;mptbldesc Cold_OffIdle_AIS_Positioning,_Increases_instantly,_decreases_after_DLYOFI
    .byte 0x04                       ;Number of points in table
    .byte 0x6E, 0xC2, 0xFC, 0xF1     ;Point 1
    .byte 0x7F, 0x8E, 0xFC, 0xAB     ;Point 2
    .byte 0x9A, 0x34, 0xFF, 0xD8     ;Point 3
    .byte 0xC7, 0x00                 ;Point 4

	;.org	0xc43d
RPMPOS_AisPosition_FromRpm:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E38
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisPosition_FromRpm
    ;mptblcname RPMPOS
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc AIS_Position_from_RPMs
    .byte 0x03                       ;Number of points in table
    .byte 0x3E, 0x00, 0x00, 0x18     ;Point 1
    .byte 0x5E, 0x03, 0x00, 0x11     ;Point 2
    .byte 0x8C, 0x06                 ;Point 3

	;.org	0xc44c
THRPOS_AisPosition_FromThrottle:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E48
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisPosition_FromThrottle
    ;mptblcname THRPOS
    ;mpxaxis TPS 0 5 Volts
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc AIS_Position_from_throttle
    .byte 0x03                       ;Number of points in table
    .byte 0x07, 0x00, 0x00, 0x4C     ;Point 1
    .byte 0x19, 0x03, 0x00, 0x0E     ;Point 2
    .byte 0x4F, 0x06                 ;Point 3

	;.org	0xc45b
ACPOS_ACPositionWhenTempToCold:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E58
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ACPositionWhenTempToCold
    ;mptblcname ACPOS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AIS:_AC_clutch_position_when_temp_to_cold
    .byte 0x17                       ;Point 1

; 	;.org	0xc45c
; PNPOS_ParkNeutralPositionSigned:
; 	.chem 3 n ParkNeutralPositionSigned in_desc 0 255 in out_desc 0 255 out PNPOS Detailed_Description
; C45C		.byte	0x00

	;.org	0xc45d
CALPOS_PositionAisMotorIsAtIdle:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E6A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PositionAisMotorIsAtIdle
    ;mptblcname CALPOS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AIS:_Position_electronics_thinks_motor_is_(at_idle)
    .byte 0x1A                       ;Point 1

	;.org	0xc45e
CALRAT_AisAdjustRate:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E77
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisAdjustRate
    ;mptblcname CALRAT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AIS_update_rate_when_calibrating_-_rate=(CALRAT+1)*11ms_(can_be_0,1,3,7,f,1f,3f,7f,ff)
    .byte 0x07                       ;Point 1

	;.org	0xc45f
BARAIS_AISBaroCompensation:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E84
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BaroCompensation_FromBaro
    ;mptblcname BARAIS
    ;mpxaxis Baro -14.7 29.4 psi
    ;mpyaxis factor 0 0.996 factor
    ;mptbldesc Barometric_compensation_factor_for_AIS_control
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x3F, 0x26, 0xFA, 0x92     ;Point 1
    .byte 0x46, 0x00                 ;Point 2

	;.org	0xc46a
DLYOF1_UpdateRateOffIdleWhenAisClosing:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E94
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UpdateRateOffIdleWhenAisClosing
    ;mptblcname DLYOF1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x07                       ;Point 1

	;.org	0xc46b
BRKRPM_BrakeOverrideForAis_FromDeltaThrottle:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0EA1
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname BrakeOverrideForAis_FromDeltaThrottle
    ;mptblcname BRKRPM
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x45, 0x01, 0x00     ;Point 1
    .byte 0x0F, 0x54, 0x00, 0xED     ;Point 2
    .byte 0x38, 0x7A                 ;Point 3

; these 2 tables have a unique format, they will not disply all the values in CHeM or D-Cal
; they are basically a standard unsigned table, except that the slope is always 0 - making it a step-function
; in the '89 T1 code, this uses a simplified lookup, but the lookup and return values are similar
; this data is traslated from the '89 T2 code.

	;.org	0xc476
FWDAIS_ForwardAisSteps_NoSlope:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0EB6
    ;mptbltype 12
    ;mpsubtype n
    ;mptbllname ForwardAisSteps_NoSlope
    ;mptblcname FWDAIS
    ;mpxaxis DeltaRPM 0 2048 rpm
    ;mpyaxis AISSteps 0 255 step
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Number of points in table
    .byte 0x0A, 0x01                 ;Point 1
    .byte 0x14, 0x02                 ;Point 2
    .byte 0x1E, 0x04                 ;Point 3
    .byte 0x28, 0x06                 ;Point 4

	;.org	0xc48d
REVAIS_ReverseAisSteps_NoSlope:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0EC7
    ;mptbltype 12
    ;mpsubtype n
    ;mptbllname ReverseAisSteps_NoSlope
    ;mptblcname REVAIS
    ;mpxaxis DeltaRPM 0 2048 rpm
    ;mpyaxis AISSteps 0 255 step
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x1E, 0xFE                 ;Point 1
    .byte 0x28, 0xFD                 ;Point 2
    .byte 0x32, 0xFC                 ;Point 3

	;.org	0xc4a4
TIMEDC_AISDecelBaseAirflowCurveOffset:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0ED7
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelAisBaseAirflowCurveOffset_FromTime
    ;mptblcname TIMEDC
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis Time 0 720 sec
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x00, 0x05, 0xFF, 0x8C     ;Point 1
    .byte 0x0B, 0x00                 ;Point 2

	;.org	0xc4ab
TEMPDC_AISDecel_FromTemp:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0EE6
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelAis_FromTemp
    ;mptblcname TEMPDC
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Number of points in table
    .byte 0x58, 0x2D, 0xFF, 0xC6     ;Point 1
    .byte 0x6E, 0x28, 0xFF, 0xB0     ;Point 2
    .byte 0x9B, 0x1A, 0xFF, 0x80     ;Point 3
    .byte 0xCD, 0x01                 ;Point 4

	;.org	0xc4be
DAISOP_DecelAisOpenStepsFromNeg_FromDeltaMap:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0EF7
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname DecelAisOpenStepsFromNeg_FromDeltaMap
    ;mptblcname DAISOP
    ;mpxaxis DeltaMAP 0 44.1 psi
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Decel_AIS_open_steps_from_-Delta_MAP
    ;mpmapaxis x
    .byte 0x03                       ;Number of points in table
    .byte 0x01, 0x00, 0x00, 0xC0     ;Point 1
    .byte 0x09, 0x06, 0x01, 0x80     ;Point 2
    .byte 0x0B, 0x09                 ;Point 3

	;.org	0xc4cd
DAISCL_DecelAisOpenStepsFromPos_FromDeltaMap:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F08
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname DecelAisOpenStepsFromPos_FromDeltaMap
    ;mptblcname DAISCL
    ;mpxaxis DeltaMAP 0 44.1 psi
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Decel_AIS_open_steps_from_+Delta_MAP
    ;mpmapaxis x
    .byte 0x03                       ;Number of points in table
    .byte 0x01, 0x00, 0xFF, 0x00     ;Point 1
    .byte 0x06, 0xFB, 0xFF, 0x72     ;Point 2
    .byte 0x0F, 0xF6                 ;Point 3

	;.org	0xc4dc
MAPFLR_AISAdditionToControlMap_FromRpm:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F19
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AdditionToControlMap_FromRpm
    ;mptblcname MAPFLR
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis ScaledMAP 0 44.1 psi
    ;mptbldesc AIS_Decel_Addition_to_control_MAP_vs._RPM
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x23, 0x00, 0x00, 0x15     ;Point 1
    .byte 0x47, 0x03                 ;Point 2

	;.org	0xc4f2
MPTEMP_TempTermForMapOffset_FromTemp:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F29
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempTermForMapOffset_FromTemp
    ;mptblcname MPTEMP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 0.996 percent
    ;mptbldesc AIS_Decel_Temperature_Term
    .byte 0x02                       ;Number of points in table
    .byte 0x90, 0x00, 0x04, 0x83     ;Point 1
    .byte 0xC7, 0xFF                 ;Point 2

	;.org	0xc4eb
BARFLR_OffsetCorrectionTo_MAPFLR_FromBaro:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F38
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname OffsetCorrectionTo_MAPFLR_FromBaro
    ;mptblcname BARFLR
    ;mpxaxis Baro -14.7 29.4 psi
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc AIS_Decel_Offset_correction_due_to_baro_effect
    ;mpmapaxis x
    .byte 0x01                       ;Number of points in table
    .byte 0xAA, 0x00                 ;Point 1


	;.org	0xc4f9
DCLRFQ_TimeBetweenAisPulsesForDecelAis:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F48
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBetweenAisPulsesForDecelAis
    ;mptblcname DCLRFQ
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 Sec
    ;mptbldesc Detailed_Description
    .byte 0x3F                       ;Point 1

	;.org	0xc4fa
DATHOT_EngineTempToStartCalibratingDacal:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F55
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineTempToStartCalibratingDacal
    ;mptblcname DATHOT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Deg
    ;mptbldesc Detailed_Description
    .byte 0xCD                       ;Point 1

	;.org	0xc4fb
DADRPM_DeltaRpmFromIdleSpeedForDacalUpdate:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F62
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaRpmFromIdleSpeedForDacalUpdate
    ;mptblcname DADRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1

	;.org	0xc4fc
DAACF_ACFactorDeltaFromBase:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F6F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ACFactorDeltaFromBase
    ;mptblcname DAACF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0B                       ;Point 1

	;.org	0xc4fd
DANOM_Base_nominalCal:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F7C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Base_nominalCal
    ;mptblcname DANOM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1

	;.org	0xc4fe
DCALTM_DacalInhibitTimeAfterStartup:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F89
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DacalInhibitTimeAfterStartup
    ;mptblcname DCALTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x15                       ;Point 1

	;.org	0xc4ff
DCALRT_DacalUpdateRate01_03_07_0f_1f_3f_7f_ff:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F96
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DacalUpdateRate01_03_07_0f_1f_3f_7f_ff
    ;mptblcname DCALRT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x7F                       ;Point 1

	;.org	0xc500
DCLMIN_MinLimitOnDecelAisControlledMap:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0FA3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinLimitOnDecelAisControlledMap
    ;mptblcname DCLMIN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1

	;.org	0xc501
DCLMN2_NoAisControlIfMapAndControlMapBelowThis:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0FB0
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname NoAisControlIfMapAndControlMapBelowThis
    ;mptblcname DCLMN2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x0D                       ;Point 1

	;.org	0xc502
DLYTIM_AisDelayAfterThrottleClosesWhenMoving:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0FBE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisDelayAfterThrottleClosesWhenMoving
    ;mptblcname DLYTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Decel_AIS_Delay_after_throttle_closes_when_moving
    .byte 0x5A                       ;Point 1

	;.org	0xc503
DLYTIM2_AisDelayAfterThrottleClosesWhenStopped:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0FCB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisDelayAfterThrottleClosesWhenStopped
    ;mptblcname DLYTIM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Decel_AIS_Delay_after_throttle_closes_when_stopped
    .byte 0x6A                       ;Point 1

	;.org	0xc504
DLYTM3_AisDelayAfterThrottleClosesWhenRpmAbove_DLYRPM:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0FD8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisDelayAfterThrottleClosesWhenRpmAbove_DLYRPM
    ;mptblcname DLYTM3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Decel_AIS_Delay_after_throttle_closes_when_MAP_is_below_DCLMN2
    .byte 0x6A                       ;Point 1

	;.org	0xc505
DLYRPM_RpmTriggerForAisDelay:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0FE5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RpmTriggerForAisDelay
    ;mptblcname DLYRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Decel_AIS_RPM_trigger_(third_AIS_delay)
    .byte 0x46                       ;Point 1

	;.org	0x85e8
MPHREF_SwitchPointForDecelIdleAisControl:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0FF2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SwitchPointForDecelIdleAisControl
    ;mptblcname MPHREF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 127.5 mph
    ;mptbldesc Switch_point_between_Decel_or_Idle_AIS_control._Note_there_is_also_a_1.5_mph_hysteresis
    .byte 0x07                       ;Point 1

	;.org	0x85e9
PNDLTN_DeltaRpmChangeToUse_DRPNK_or_PNDRK:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0FFF
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DeltaRpmChangeToUse_DRPNK_or_PNDRK_A
    ;mptblcname PNDLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0140                     ;Point 1

	;.org	0x85eb
PNDRK_ParkNeutralToDriveKicks_FromTemp:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x100C
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ParkNeutralToDriveKicks_FromTemp
    ;mptblcname PNDRK
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x79, 0x32, 0xFE, 0x7B     ;Point 1
    .byte 0x92, 0x0C, 0xFF, 0xD0     ;Point 2
    .byte 0xD2, 0x00                 ;Point 3

	;.org	0x85fa
PNDLTP_DeltaRpmChangeToUse_DRPNK_or_PNDRK:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x101C
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DeltaRpmChangeToUse_DRPNK_or_PNDRK_B
    ;mptblcname PNDLTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0140                     ;Point 1

	;.org	0x85fc
DRPNK_DriveToParkNeutralKicks_FromTemp:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1029
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DriveToParkNeutralKicks_FromTemp
    ;mptblcname DRPNK
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x79, 0xDD, 0x01, 0x29     ;Point 1
    .byte 0x92, 0xFA, 0x00, 0x18     ;Point 2
    .byte 0xD2, 0x00                 ;Point 3

	;.org	0x860b
ACCTBL_ACOffIdleDelta_FromSpeed:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1039
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ACOffIdleDelta_FromSpeed
    ;mptblcname ACCTBL
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Number of points in table
    .byte 0x32, 0x1D, 0x00, 0x8D     ;Point 1
    .byte 0x46, 0x28, 0x00, 0x66     ;Point 2
    .byte 0x5A, 0x30, 0xFF, 0x33     ;Point 3
    .byte 0x6E, 0x20                 ;Point 4

	;.org	0x861e
ACTMP_Use_ACCTBL_WhenTempAboveThisElseUse_ACPOS:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x104A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Use_ACCTBL_WhenTempAboveThisElseUse_ACPOS
    ;mptblcname ACTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x7F                       ;Point 1

	;.org	0x861f
AISMPH_RollingAisMaxSpeed:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1057
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisMaxSpeed
    ;mptblcname AISMPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x07                       ;Point 1

	;.org	0x8620
RPMDLT_RollingAisMinRpm:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1064
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname RollingAisMinRpm
    ;mptblcname RPMDLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc RPM_added_to_the_target_idle_speed_when_rolling...
    .word 0x0008                     ;Point 1

	;.org	0x8622
ISPDCY_RollingAisDecay:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1071
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisDecay
    ;mptblcname ISPDCY
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x8623
DECAIS_RollingAisUpdateRate_01_03_07_0f_1f_3f_7f_ff:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x107E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisUpdateRate_01_03_07_0f_1f_3f_7f_ff
    ;mptblcname DECAIS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x8624
AISLMH_RollingAisHighLimit:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x108B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisHighLimit
    ;mptblcname AISLMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x20                       ;Point 1

	;.org	0x8625
AISLML_RollingAisLowLimit:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1098
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisLowLimit
    ;mptblcname AISLML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x25                       ;Point 1

	;.org	0x8626
ACDTMP_PartThrottleAcCutoutDisableTemp:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10A5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PartThrottleAcCutoutDisableTemp
    ;mptblcname ACDTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x8627
ACDTHR_PartThrottleAcCutoutDisableThrottle:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10B2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PartThrottleAcCutoutDisableThrottle
    ;mptblcname ACDTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x8628
ACDSPD_PartThrottleAcCutoutDisableSpeed:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10BF
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname PartThrottleAcCutoutDisableSpeed
    ;mptblcname ACDSPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0000                     ;Point 1

	;.org	0x862a
ACETIM_PartThrottleAcCutoutMaxTimeActive:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10CC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PartThrottleAcCutoutMaxTimeActive
    ;mptblcname ACETIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x08                       ;Point 1

	;.org	0x862b
ACERPM_AllowAcClutchAboveThisRpm:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10D9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AllowAcClutchAboveThisRpm
    ;mptblcname ACERPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x44                       ;Point 1

	;.org	0x862c
ACESPD_AllowAcClutchAboveThisSpeed:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10E6
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname AllowAcClutchAboveThisSpeed
    ;mptblcname ACESPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0500                     ;Point 1

	;.org	0x862e
ACAETH_DisallowAcClutchEngageForThisTimeAfterAccelEnrich:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10F3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DisallowAcClutchEngageForThisTimeAfterAccelEnrich
    ;mptblcname ACAETH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xD6                       ;Point 1

	;.org	0x862f
ACOFFK_ClosedThrottleAcOffKick:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1100
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ClosedThrottleAcOffKick
    ;mptblcname ACOFFK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xF2                       ;Point 1

	;.org	0x8630
AC2KCK_AcClutchKickOpenAfterAcEnabled:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x110D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcClutchKickOpenAfterAcEnabled
    ;mptblcname AC2KCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x06                       ;Point 1

	;.org	0x8631
ACTIME_TimeBeforeAcEnabledAndFullDeltaUsed:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x111A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBeforeAcEnabledAndFullDeltaUsed
    ;mptblcname ACTIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x16                       ;Point 1

	;.org	0x8632
PERKCK_AcClutchAisAdjustmentConstant:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1127
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcClutchAisAdjustmentConstant
    ;mptblcname PERKCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x80                       ;Point 1

	;.org	0x8633
AC4KCK_AcClutchKickOpenBeforeAcEnabled2:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1134
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcClutchKickOpenBeforeAcEnabled2
    ;mptblcname AC4KCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFA                       ;Point 1

	;.org	0x8634
AC3KCK_AcClutchKickOpenAfterAcEnabled2:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1141
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcClutchKickOpenAfterAcEnabled2
    ;mptblcname AC3KCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFE                       ;Point 1

	;.org	0x8635
ACTIM2_TimeBeforeAcEnabledAndFullDeltaUsed2:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x114E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBeforeAcEnabledAndFullDeltaUsed2
    ;mptblcname ACTIM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x24                       ;Point 1

	;.org	0x8636
OFFPER_AisInstantlyClosesWhenAcDisengages:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x115B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisInstantlyClosesWhenAcDisengages
    ;mptblcname OFFPER
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x40                       ;Point 1

	;.org	0x8637
OFFPER2_AisInstantlyClosesWhenAcDisengages2:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1168
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisInstantlyClosesWhenAcDisengages2
    ;mptblcname OFFPER2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x40                       ;Point 1

	;.org	0x8638
BTVAIS_MinVoltageForAis:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1175
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinVoltageForAis
    ;mptblcname BTVAIS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x71                       ;Point 1

	;.org	0x8639
AISFRQ_AisPeriodForRpmFeedback11ms:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1182
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisPeriodForRpmFeedback11ms
    ;mptblcname AISFRQ
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x7F                       ;Point 1

	;.org	0x863a
AISHLM_AisHighLimitMaxOpenSteps:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x118F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisHighLimitMaxOpenSteps
    ;mptblcname AISHLM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xA0                       ;Point 1

	;.org	0x863b
AISFAN_AisKickWhenFanTurnsOnClosedThrottle:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x119C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisKickWhenFanTurnsOnClosedThrottle
    ;mptblcname AISFAN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Point 1

; this is not changed from 2.2 to 2.5. Both version of this software use the same boost control scheme. So,
; if you change from 2.5 to 2.2, you will still need to use the T1 style boost control and vac routing.

BSTSWS_HighBoostSwitchSelect:  ;0x8a25 is where this ends up...
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x11AB
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname HighBoostSwitchSelect
    ;mptblcname BSTSWS
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc Switch_that_will_activate_high_boost_mode._If_no_switch_is_selected,_then_theboost_is_not_selectable,_and_the_Low_Boost_curve_needs_to_be_setup_as_the_high_boost_curve.
    ;mpchoices B1Voltage_Sense(Do_Not_Use)  Speed_Control_Set_(Momentary)  Speed_Control_On/Off  Speed_Control_Resume_(Momentary)  A/C_Switch  A/C_Clutch_Input(Do_Not_Use)  Brake_Switch  Park/Neutral_Switch
    .byte 0x00                       ;Point 1
    bst_PNswitch		= $%10000000	; Park/Neutral switch
    bst_Brake			= $%01000000	; Brake Switch
    bst_DistSync		= $%00100000	; Distributor Sync
    bst_ACclutch		= $%00010000	; A/C Clutch input
    bst_CruiseResume		= $%00001000	; Cruise Resume
    bst_CruiseOnOff		= $%00000100	; Cruise On/Off
    bst_CruiseSet		= $%00000010	; Cruise Set
    bst_B1Volt			= $%00000001	; B1 Voltage Sense

	;.org	0xc549
WSGRPM_AllowedBoost_FromRpm:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x11C1
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromRpm
    ;mptblcname WSGRPM
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Boost_Allowed_from_RPMs._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x04                       ;Number of points in table
    .byte 0x3E, 0xFF, 0x00, 0x00     ;Point 1
    .byte 0x4E, 0xFF, 0x00, 0x00     ;Point 2
    .byte 0x73, 0xFF, 0x00, 0x00     ;Point 3
    .byte 0xA4, 0xFF                 ;Point 4

LOWBST_AllowedBoostLo:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x11D2
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AllowedBoostLo
    ;mptblcname LOWBST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Low_boost_setting._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x3A                       ;Point 1

STGBST_AllowedBoostDuringStaging:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x11DF
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AllowedBoostDuringStaging
    ;mptblcname STGBST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Boost_setting_while_launch_control_is_active._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x29                       ;Point 1

	;.org	0xc558
WSGTIM_AllowedBoost_FromTime:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x11ED
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromTime
    ;mptblcname WSGTIM
    ;mpxaxis Time 0 0.72 Sec
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Boost_Allowed_from_time_in_boost._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0xFF                 ;Point 1

	;.org	0xc563
WSGCLT_AllowedBoost_FromTemp:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x11FC
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromTemp
    ;mptblcname WSGCLT
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Boost_Allowed_from_Engine_Temp._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x04                       ;Number of points in table
    .byte 0x9B, 0x20, 0x02, 0x92     ;Point 1
    .byte 0xB7, 0x68, 0x00, 0x00     ;Point 2
    .byte 0xEE, 0x68, 0xF4, 0x00     ;Point 3
    .byte 0xF4, 0x20                 ;Point 4

	;.org	0xc572
WSGCHG_AllowedBoost_FromChargeTemp:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x120E
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromChargeTemp
    ;mptblcname WSGCHG
    ;mpxaxis charge_temp_volts 0 5 volts
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Boost_Allowed_from_Charge_Temp._Boost_is_defined_as_MAP_reading_above_Baro._Charge_Temp_numbers_are_approximate_only
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x0A, 0x2C, 0x1E, 0x25     ;Point 1
    .byte 0x11, 0xFF                 ;Point 2

	;.org	0xc597
MXSBST_AllowedBoost_FromSpeed:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x121E
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromSpeed
    ;mptblcname MXSBST
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Boost_Allowed_from_Speed_to_protect_automatic_transmissions.
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x05, 0x37, 0x03, 0x44     ;Point 1
    .byte 0x14, 0x68                 ;Point 2

	;.org	0xc57d
WSGPRT_AllowedBoostPartThrottle_FromThrottle:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x122E
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoostPartThrottle_FromThrottle
    ;mptblcname WSGPRT
    ;mpxaxis TPS 0 5 volts
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Boost_Allowed_from_Throttle_at_Part_Throttle._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x93, 0x37, 0x01, 0x4A     ;Point 1
    .byte 0xB9, 0x68                 ;Point 2

	;.org	0xc5b8
DCWOT_FullThrottleWastegateDutyCycle_C8is100Percent_FromMap:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Lookup\
    ;mptbladdr 0x123E
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FullThrottleWastegateDutyCycle_C8is100Percent_FromMap
    ;mptblcname DCWOT
    ;mpxaxis TargetBoost 0 44.1 psi
    ;mpyaxis Duty_Cycle 0 127.5 percent
    ;mptbldesc WOT_WG_Duty_Cycle
    ;mpmapaxis x
    .byte 0x05                       ;Number of points in table
    .byte 0x21, 0xC8, 0xF6, 0xA0     ;Point 1
    .byte 0x29, 0x7D, 0xFD, 0xC0     ;Point 2
    .byte 0x35, 0x62, 0xFE, 0x55     ;Point 3
    .byte 0x3B, 0x58, 0xFE, 0xD5     ;Point 4
    .byte 0x53, 0x3C                 ;Point 5

	;.org	0xc5cb
DCWADJ_FullThrottleWastegateDutyCycleAdjustment_FromRpm:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Lookup\
    ;mptbladdr 0x1251
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname FullThrottleWastegateDutyCycleAdjustment_FromRpm
    ;mptblcname DCWADJ
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis DC_Adjust -64 63.5 percent
    ;mptbldesc WOT_Duty_Cycle_Adjustment
    .byte 0x06                       ;Number of points in table
    .byte 0x6E, 0x00, 0xFF, 0x9E     ;Point 1
    .byte 0x83, 0xF8, 0xFF, 0xEC     ;Point 2
    .byte 0x90, 0xF7, 0xFF, 0x00     ;Point 3
    .byte 0x96, 0xF1, 0xFF, 0xD5     ;Point 4
    .byte 0xA8, 0xEE, 0x00, 0x49     ;Point 5
    .byte 0xB6, 0xF2                 ;Point 6

DCWBST_FullThrottleWastegateDutyCycleAdjustment_FromBoostTarget:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Lookup\
    ;mptbladdr 0x1263
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FullThrottleWastegateDutyCycleAdjustment_FromBoostTarget
    ;mptblcname DCWBST
    ;mpxaxis DeltaMAP 0 44.1 psi
    ;mpyaxis DC_Adjust 0 127.5 percent
    ;mptbldesc WOT_WG_Duty_Cycle_added_vs_delta_to_boost_target.
    ;mpmapaxis x
    .byte 0x06                       ;Number of points in table
    .byte 0x1D, 0x00, 0x0C, 0x00     ;Point 1
    .byte 0x27, 0x78, 0x02, 0xA2     ;Point 2
    .byte 0x3A, 0xAA, 0x01, 0x94     ;Point 3
    .byte 0x4D, 0xC8, 0x00, 0x00     ;Point 4
    .byte 0x58, 0xC8, 0x00, 0x00     ;Point 5
    .byte 0x63, 0xC8                 ;Point 6

	;.org	0x86df
MAPPT2_WastegateDutyCycleMapSwitchPoint2:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x1277
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname WastegateDutyCycleMapSwitchPoint2
    ;mptblcname MAPPT2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Wastegate_Duty_Cycle_Adjustment_Map_Switch_Point
    ;mpmapaxis y
    .byte 0x00                       ;Point 1

	;.org	0x86e0
RPMBST_MinimumRpmToTrackBoostCreep:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Lookup\
    ;mptbladdr 0x1285
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumRpmToTrackBoostCreep
    ;mptblcname RPMBST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Min_RPM_to_increment_the_boost_error_timer.
    .byte 0x42                       ;Point 1

	;.org	0x86e1
KDCINC_WastegateDutyCycleIncreaseStepWhenKnocking:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Knock_Adj\
    ;mptbladdr 0x1292
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseStepWhenKnocking
    ;mptblcname KDCINC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x08                       ;Point 1

	;.org	0x86e2
KDCMAX_WastegateDutyCycleIncreaseMaxWhenKnocking:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Knock_Adj\
    ;mptbladdr 0x129F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseMaxWhenKnocking
    ;mptblcname KDCMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x3C                       ;Point 1

	;.org	0x86e3
KDCMIN_WastegateDutyCycleIncreaseMinWhenKnocking:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Knock_Adj\
    ;mptbladdr 0x12AC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseMinWhenKnocking
    ;mptblcname KDCMIN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1

	;.org	0x86e4
DECTIM_TimeScaleFor_DCDECK:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x12B9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeScaleFor_DCDECK
    ;mptblcname DECTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x86e5
DCDECK_WastegateDutyCycleDecrementWhenSparkStillDerated:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Knock_Adj\
    ;mptbladdr 0x12C6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleDecrementWhenSparkStillDerated
    ;mptblcname DCDECK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

	;.org	0x86e6
MPDEL1_IncCounterWhenDeltaMapBelowThis:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x12D3
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname IncCounterWhenDeltaMapBelowThis
    ;mptblcname MPDEL1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

	;.org	0x86e7
MPFLOR_StopAdaptiveWGWhenDeltaMapIsLessThanThis:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x12E1
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname StopAdaptiveWhenDeltaMapIsLessThanThis
    ;mptblcname MPFLOR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

	;.org	0x86e8
DECPT_AdaptiveDecAfterThisTime:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x12EF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveDecAfterThisTime
    ;mptblcname DECPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_BoostErrTimer_counts_before_WG_Duty_Cycle_is_decremented._Used_when_boost_is_above_target.
    .byte 0x10                       ;Point 1

	;.org	0x86e9
DECLIM_LowerLimitOnWastegateDutyCycleCorrection:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x12FC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowerLimitOnWastegateDutyCycleCorrection
    ;mptblcname DECLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x44                       ;Point 1

	;.org	0x86ea
MPROOF_StopAdaptiveWGWhenMapIsThisCloseToBoostTarget:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x1309
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname StopAdaptiveWGWhenMapIsThisCloseToBoostTarget
    ;mptblcname MPROOF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x00                       ;Point 1

	;.org	0x86eb
MPDEL2_IncCounterWhenDeltaMapBelowThis2:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x1317
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname IncCounterWhenDeltaMapBelowThis2
    ;mptblcname MPDEL2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

	;.org	0x86ec
INCPT_AdaptiveIncAfterThisTime:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x1325
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveIncAfterThisTime
    ;mptblcname INCPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_BoostErrTimer_counts_before_WG_Duty_Cycle_is_incremented._Used_when_boost_is_below_target.
    .byte 0x10                       ;Point 1

	;.org	0x86ed
INCLIM_UpperLimitOnWastegateDutyCycleCorrection:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x1332
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UpperLimitOnWastegateDutyCycleCorrection
    ;mptblcname INCLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xE0                       ;Point 1

	;.org	0x86ee
DCRPML_NoWastegateDutyCycleCorrectionBelowThisRpm:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x133F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoWastegateDutyCycleCorrectionBelowThisRpm
    ;mptblcname DCRPML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x42                       ;Point 1

	;.org	0x86ef
TPSLIM_UpdateAdaptiveWGTPSUpperLimit:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x134C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UpdateAdaptiveWGTPSUpperLimit
    ;mptblcname TPSLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis TPS_Volts 0 5 volts
    ;mptbldesc Detailed_Description
    .byte 0x66                       ;Point 1

	;.org	0x86f0
MAPPT_WastegateDutyCycleMapSwitchPoint:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x1359
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname WastegateDutyCycleMapSwitchPoint
    ;mptblcname MAPPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Wastegate_Duty_Cycle_Adjustment_boost_switch_point.
    ;mpmapaxis y
    .byte 0x37                       ;Point 1

	;.org	0x86f1
DCRPM1_WastegateDutyCycleRpmBoundary1:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x1367
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleRpmBoundary1
    ;mptblcname DCRPM1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x5E                       ;Point 1

	;.org	0x86f2
DCRPM2_WastegateDutyCycleRpmBoundary2:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x1374
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleRpmBoundary2
    ;mptblcname DCRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x7A                       ;Point 1

	;.org	0x86f3
DCRPM3_WastegateDutyCycleRpmBoundary3:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x1381
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleRpmBoundary3
    ;mptblcname DCRPM3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x96                       ;Point 1

T2MAPPT_WastegateDutyCycleMapSwitchPoint:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Adaptives\
    ;mptbladdr 0x138D
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname WastegateDutyCycleMapSwitchPoint
    ;mptblcname T2MAPPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Wastegate_Duty_Cycle_Adjustment_boost_switch_point.
    ;mpmapaxis y
    .byte 0x37                       ;Point 1

T2MAPPT2_WastegateDutyCycleMapSwitchPoint2:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Adaptives\
    ;mptbladdr 0x139A
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname WastegateDutyCycleMapSwitchPoint2
    ;mptblcname T2MAPPT2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Wastegate_Duty_Cycle_Adjustment_Map_Switch_Point
    ;mpmapaxis y
    .byte 0x1F                       ;Point 1

T2KNOKMP_MinimumBoostToCountKnockEvents:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Knock_Adj\
    ;mptbladdr 0x13A7
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MinimumBoostToCountKnockEvents
    ;mptblcname T2KNOKMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Desc
    ;mpmapaxis y
    .byte 0x17                       ;Point 1

T2WGKNRD_MinimumKnockToReduceWGDC:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Knock_Adj\
    ;mptbladdr 0x13B4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumKnockToReduceWGDC
    ;mptblcname T2WGKNRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis KnockRetard 0 127 deg
    ;mptbldesc Desc
    .byte 0x07                       ;Point 1

T2RPMBST_MinimumRpmToTrackBoostCreep:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_BoostCreep\
    ;mptbladdr 0x13C0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumRpmToTrackBoostCreep
    ;mptblcname T2RPMBST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Desc
    .byte 0x4C                       ;Point 1

T2RATLIM_OverboostPreventionRateLimit_FromRpm:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_BoostCreep\
    ;mptbladdr 0x13CC
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname OverboostPreventionRateLimit_FromRpm
    ;mptblcname T2RATLIM
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis DeltaBoost 0 44.1 psi
    ;mptbldesc Delta_boost_from_RPM_to_use_PRTMAX.
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x20, 0x08, 0xFF, 0xF8     ;Point 1
    .byte 0x9C, 0x04                 ;Point 2

T2PRTMAX_MaxWastegateDutyCycleforPartThrottleBoostCreep:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_BoostCreep\
    ;mptbladdr 0x13DB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxWastegateDutyCycleforPartThrottleBoostCreep
    ;mptblcname T2PRTMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis WGDC 0 127 percent
    ;mptbldesc Desc
    .byte 0xC8                       ;Point 1

T2MPDEL_HysteresisForBoostCreep:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_BoostCreep\
    ;mptbladdr 0x13E7
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname HysteresisForBoostCreep
    ;mptblcname T2MPDEL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Desc
    ;mpmapaxis y
    .byte 0x00                       ;Point 1

T2RESFAC_MapCorrectionResponseFactor_FromMap:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_BoostCreep\
    ;mptbladdr 0x13F4
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname MapCorrectionResponseFactor_FromMap
    ;mptblcname T2RESFAC
    ;mpxaxis Boost 0 44.1 psi
    ;mpyaxis PerMAP 0 44.1 units/psi
    ;mptbldesc Delta_boost_from_RPM_to_use_PRTMAX.
    ;mpmapaxis x-y
    .byte 0x02                       ;Number of points in table
    .byte 0x61, 0x09, 0xFF, 0x2F     ;Point 1
    .byte 0x6C, 0x00                 ;Point 2

T2DCWOT_FullThrottleWastegateDutyCycle_C8is100Percent_FromMap:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Lookup\
    ;mptbladdr 0x1403
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FullThrottleWastegateDutyCycle_C8is100Percent_FromMap
    ;mptblcname T2DCWOT
    ;mpxaxis TargetBoost 0 44.1 psi
    ;mpyaxis Duty_Cycle 0 127.5 percent
    ;mptbldesc WOT_WG_Duty_Cycle
    ;mpmapaxis x
    .byte 0x05                       ;Number of points in table
    .byte 0x1F, 0xC8, 0xF8, 0x80     ;Point 1
    .byte 0x29, 0x7D, 0xFD, 0xC0     ;Point 2
    .byte 0x35, 0x62, 0xFE, 0x55     ;Point 3
    .byte 0x3B, 0x58, 0xFE, 0xEE     ;Point 4
    .byte 0x74, 0x1B                 ;Point 5

T2DCWADJ_FullThrottleWastegateDutyCycleAdjustment_FromRpm:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Lookup\
    ;mptbladdr 0x1415
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname FullThrottleWastegateDutyCycleAdjustment_FromRpm
    ;mptblcname T2DCWADJ
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis DC_Adjust -64 63.5 percent
    ;mptbldesc WOT_Duty_Cycle_Adjustment
    .byte 0x06                       ;Number of points in table
    .byte 0x6E, 0x00, 0xFF, 0x9E     ;Point 1
    .byte 0x83, 0xF8, 0xFF, 0xEC     ;Point 2
    .byte 0x90, 0xF7, 0xFF, 0x00     ;Point 3
    .byte 0x96, 0xF1, 0xFF, 0xD5     ;Point 4
    .byte 0xA8, 0xEE, 0x00, 0x49     ;Point 5
    .byte 0xB6, 0xF2                 ;Point 6

T2DCWBST_FullThrottleWastegateDutyCycleAdjustment_FromBoostTarget:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Lookup\
    ;mptbladdr 0x1427
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FullThrottleWastegateDutyCycleAdjustment_FromBoostTarget
    ;mptblcname T2DCWBST
    ;mpxaxis DeltaMAP 0 44.1 psi
    ;mpyaxis DC_Adjust 0 127.5 percent
    ;mptbldesc WOT_WG_Duty_Cycle_added_vs_delta_to_boost_target.
    ;mpmapaxis x
    .byte 0x06                       ;Number of points in table
    .byte 0x1D, 0x00, 0x0C, 0x00     ;Point 1
    .byte 0x27, 0x78, 0x02, 0xA2     ;Point 2
    .byte 0x3A, 0xAA, 0x01, 0x94     ;Point 3
    .byte 0x4D, 0xC8, 0x00, 0x00     ;Point 4
    .byte 0x58, 0xC8, 0x00, 0x00     ;Point 5
    .byte 0x63, 0xC8                 ;Point 6

T2KDCINC_WastegateDutyCycleIncreaseStepWhenKnocking:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Knock_Adj\
    ;mptbladdr 0x143A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseStepWhenKnocking
    ;mptblcname T2KDCINC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x08                       ;Point 1

T2KDCMAX_WastegateDutyCycleIncreaseMaxWhenKnocking:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Knock_Adj\
    ;mptbladdr 0x1446
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseMaxWhenKnocking
    ;mptblcname T2KDCMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x3C                       ;Point 1

T2KDCMIN_WastegateDutyCycleIncreaseMinWhenKnocking:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Knock_Adj\
    ;mptbladdr 0x1452
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseMinWhenKnocking
    ;mptblcname T2KDCMIN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1

T2DECTIM_TimeScaleFor_DCDECK:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Knock_Adj\
    ;mptbladdr 0x145E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeScaleFor_DCDECK
    ;mptblcname T2DECTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x07                       ;Point 1

T2DCDECK_WastegateDutyCycleDecrementWhenSparkStillDerated:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Knock_Adj\
    ;mptbladdr 0x146A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleDecrementWhenSparkStillDerated
    ;mptblcname T2DCDECK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

T2MPDEL1_IncCounterWhenDeltaMapBelowThis:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Adaptives\
    ;mptbladdr 0x1476
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname IncCounterWhenDeltaMapBelowThis
    ;mptblcname T2MPDEL1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

T2INCPT_AdaptiveIncAfterThisTime:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Adaptives\
    ;mptbladdr 0x1483
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveIncAfterThisTime
    ;mptblcname T2INCPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_BoostErrTimer_counts_before_WG_Duty_Cycle_is_incremented._Used_when_boost_is_below_target.
    .byte 0x10                       ;Point 1
    
UPRLIM_UpperLimitOnMPCORR: 
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Adaptives\
    ;mptbladdr 0x148F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UpperLimitOnMPCORR
    ;mptblcname UPRLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Desc
    .byte 0x10                       ;Point 1

LWRLIM_LowerLimitOnMPCORR:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Adaptives\
    ;mptbladdr 0x149B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowerLimitOnMPCORR
    ;mptblcname LWRLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Desc
    .byte 0x20                       ;Point 1
    
T2MPROOF_StopAdaptiveWhenMapIsThisCloseToBoostTarget:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Adaptives\
    ;mptbladdr 0x14A7
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname StopAdaptiveWhenMapIsThisCloseToBoostTarget
    ;mptblcname T2MPROOF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

T2MPFLOR_StopAdaptiveWhenMapIsThisCloseToBoostFloor:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Adaptives\
    ;mptbladdr 0x14B4
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname StopAdaptiveWhenMapIsThisCloseToBoostFloor
    ;mptblcname T2MPFLOR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x00                       ;Point 1

DCRPMH_NoWastegateDutyCycleCorrectionAboveThisRpm:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Adaptives\
    ;mptbladdr 0x14C1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoWastegateDutyCycleCorrectionAboveThisRpm
    ;mptblcname DCRPMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Desc
    .byte 0xBC                       ;Point 1

	;.org	0xc619
BRPMLO_BaroReadLowRPM1800:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x14CE
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname BaroReadLowRPM1800
    ;mptblcname BRPMLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .word 0x3840                     ;Point 1

	;.org	0xc61b
BRPMHI_BaroReadHighRPM6650:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x14DB
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname BaroReadHighRPM6650
    ;mptblcname BRPMHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .word 0xCFD0                     ;Point 1

	;.org	0xc61d
BRDLAY_BaroReadDelayAfterThrottleClosed2sec:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x14E8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadDelayAfterThrottleClosed2sec
    ;mptblcname BRDLAY
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Detailed_Description
    .byte 0xB5                       ;Point 1

	;.org	0xc61e
BARTIM_BaroReadMinTimeBetweenReadings179sec:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x14F5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadMinTimeBetweenReadings179sec
    ;mptblcname BARTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 720 sec
    ;mptbldesc Detailed_Description
    .byte 0x40                       ;Point 1

	;.org	0xc61f
BROPTM_BaroReadDelayAfterSolenoidOpenTenthSec:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x1502
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadDelayAfterSolenoidOpenTenthSec
    ;mptblcname BROPTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Detailed_Description
    .byte 0x09                       ;Point 1

	;.org	0xc620
BRCLTM_BaroReadDelayAfterSolenoidClosedTenthSec:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x150F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadDelayAfterSolenoidClosedTenthSec
    ;mptblcname BRCLTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Detailed_Description
    .byte 0x09                       ;Point 1

	;.org	0xc621
BAROHI_BaroReadValidHighLimit:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x151C
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BaroReadValidHighLimit
    ;mptblcname BAROHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x59                       ;Point 1

	;.org	0xc622
BAROLO_BaroReadValidLowLimit:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x152A
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BaroReadValidLowLimit
    ;mptblcname BAROLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x2E                       ;Point 1

	;.org	0xc623
BARDFT_BaroReadDefaultValue:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x1538
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BaroReadDefaultValue
    ;mptblcname BARDFT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x55                       ;Point 1




	;.org	0x86ff
FANTMP_FanTurnOnTempAbove45MPH:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x1549
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOnTempAbove45Mph
    ;mptblcname FANTMP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc Detailed_Description3
    .byte 0xE3                       ;Point 1

	;.org	0x8700
FANTMP2_FanTurnOffTempAbove45MPH:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x1556
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOffTempAbove45Mph
    ;mptblcname FANTMP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc Detailed_Description3
    .byte 0xDE                       ;Point 1

	;.org	0x8701
FANTMP3_FanTurnOnTempBelow35MPH:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x1563
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOnTempBelow35Mph
    ;mptblcname FANTMP3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc Detailed_Description3
    .byte 0xDE                       ;Point 1

	;.org	0x8702
FANTMP4_FanTurnOffTempBelow35MPH:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x1570
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOffTempBelow35Mph
    ;mptblcname FANTMP4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc Detailed_Description3
    .byte 0xD8                       ;Point 1

	;.org	0x8703
FANMAP_FanTurnsOnWhenMapAboveBaroPlusThis:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x157D
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname FanTurnsOnWhenMapAboveBaroPlusThis
    ;mptblcname FANMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x11                       ;Point 1

	;.org	0x8704
FANBAT_FanTurnsOnWhenBatteryTempAboveThis:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x158B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnsOnWhenBatteryTempAboveThis
    ;mptblcname FANBAT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Battery_Temp -200 260 Degrees
    ;mptbldesc Detailed_Description
    .byte 0x9A                       ;Point 1

FNSPHI_FanControlSpeedHi:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x1597
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanControlSpeedHi
    ;mptblcname FNSPHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 1020 MPH
    ;mptbldesc Detailed_Description
    .byte 0x0B                       ;Point 1

FNSPLO_FanControlSpeedLo:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x15A3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanControlSpeedLo
    ;mptblcname FNSPLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 1020 MPH
    ;mptbldesc Detailed_Description
    .byte 0x09                       ;Point 1

	;.org	0xc687
PURMAP_CannisterPurgeWhenBelowThisBaro:
    ;mpgrp 7_-_Aux_Functions\Purge_Control\
    ;mptbladdr 0x15B0
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname CannisterPurgeWhenBelowThisBaro
    ;mptblcname PURMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x03                       ;Point 1

	;.org	0xc688
PURHYS_CannisterPurgeBaroHysteresis:
    ;mpgrp 7_-_Aux_Functions\Purge_Control\
    ;mptbladdr 0x15BE
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname CannisterPurgeBaroHysteresis
    ;mptblcname PURHYS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

PURTMP_CanisterPurgeCoolantTemp:
    ;mpgrp 7_-_Aux_Functions\Purge_Control\
    ;mptbladdr 0x15CB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CanisterPurgeCoolantTemp
    ;mptblcname PURTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x82                       ;Point 1

	;.org	0xc689
ACLRPM_DisableAcBelowThisRPM_500:
    ;mpgrp 7_-_Aux_Functions\AC_Control\
    ;mptbladdr 0x15D8
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DisableAcBelowThisRPM_500
    ;mptblcname ACLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0FA0                     ;Point 1

	;.org	0xc68b
ACOUT_DeltaAboveMinThrottleToCutOutAc:
    ;mpgrp 7_-_Aux_Functions\AC_Control\
    ;mptbladdr 0x15E5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaAboveMinThrottleToCutOutAc
    ;mptblcname ACOUT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x8A                       ;Point 1

	;.org	0xc68c
ACCRPM_DoNotAllowAcToEngageAboveThisRPM_4000:
    ;mpgrp 7_-_Aux_Functions\AC_Control\
    ;mptbladdr 0x15F2
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DoNotAllowAcToEngageAboveThisRPM_4000
    ;mptblcname ACCRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x7D00                     ;Point 1

	;.org	0xc68e
ACCTIM_AcDelayFromStartRunTransfer:
    ;mpgrp 7_-_Aux_Functions\AC_Control\
    ;mptbladdr 0x15FF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcDelayFromStartRunTransfer
    ;mptblcname ACCTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1

 	;.org	0x870e
WOTDLT_DeltaThrottleFrom_MINTHR_ToDetermineFullThrottle:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x160C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaThrottleFrom_MINTHR_ToDetermineFullThrottle
    ;mptblcname WOTDLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x85                       ;Point 1

	;.org	0x870f
UNLOAD_DeltaThrottleFrom_MINTHR_ToUnloadCrankingFuel:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x1619
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaThrottleFrom_MINTHR_ToUnloadCrankingFuel
    ;mptblcname UNLOAD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x85                       ;Point 1

	;.org	0x8710
VACREG_CruiseControlVacRegularGainGurve_FromDeltaSpeed:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1626
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlVacRegularGainGurve_FromDeltaSpeed
    ;mptblcname VACREG
    ;mpxaxis Delta_Speed 0 127.5 mph
    ;mpyaxis AccRate 0 5 mph/sec
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Number of points in table
    .byte 0x00, 0x00, 0x00, 0x33     ;Point 1
    .byte 0x05, 0x01, 0x00, 0x0D     ;Point 2
    .byte 0x40, 0x04, 0x00, 0x18     ;Point 3
    .byte 0x80, 0x0A, 0x00, 0x14     ;Point 4
    .byte 0xFF, 0x14                 ;Point 5

	;.org	0x8727
VACACC_CruiseControlVacAcceleratedGainCurve_FromDeltaSpeed:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1638
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlVacAcceleratedGainCurve_FromDeltaSpeed
    ;mptblcname VACACC
    ;mpxaxis Delta_Speed 0 127.5 mph
    ;mpyaxis AccRate 0 5 mph/sec
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x00, 0x02, 0x00, 0x2E     ;Point 1
    .byte 0xFF, 0x30                 ;Point 2

	;.org	0x873e
VENTRG_CruiseControlVentRegularGainCurve_FromDeltaSpeed:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1647
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlVentRegularGainCurve_FromDeltaSpeed
    ;mptblcname VENTRG
    ;mpxaxis Delta_Speed 0 127.5 mph
    ;mpyaxis AccRate 0 5 mph/sec
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x00, 0xFF, 0xFB     ;Point 1
    .byte 0x33, 0xFF, 0xFF, 0xEE     ;Point 2
    .byte 0xFF, 0xF1                 ;Point 3

	;.org	0x874d
SETPW_CruiseControlSetupPulseForSet_FromSpeed:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1657
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlSetupPulseForSet_FromSpeed
    ;mptblcname SETPW
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis Vacuum 0 2.8 Pulsewidth
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x46, 0x27, 0x00, 0x40     ;Point 1
    .byte 0x82, 0x36, 0x00, 0x50     ;Point 2
    .byte 0xFF, 0x5D                 ;Point 3

	;.org	0x875c
RESTBL_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1667
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference
    ;mptblcname RESTBL
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis AbsMAP 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x00, 0x00, 0x5A     ;Point 1
    .byte 0x14, 0x07, 0x00, 0x11     ;Point 2
    .byte 0x6E, 0x0D                 ;Point 3

	;.org	0x8773
RESTBL2_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference2:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1678
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference2
    ;mptblcname RESTBL2
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis Vacuum 0 2.8 Pulsewidth
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x00, 0x00, 0x80     ;Point 1
    .byte 0x14, 0x0A, 0x00, 0x1C     ;Point 2
    .byte 0x6E, 0x14                 ;Point 3

	;.org	0x8786
THGAIN_CruiseControlThrottleGainFactor_FromThrottle:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1688
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlThrottleGainFactor_FromThrottle
    ;mptblcname THGAIN
    ;mpxaxis TPS 0 255 tps
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x00, 0x08, 0x00, 0x00     ;Point 1
    .byte 0x11, 0x40                 ;Point 2

	;.org	0x8795
SPGAIN_CruiseControlSpeedGainFactor_FromSpeed:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1697
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlSpeedGainFactor_FromSpeed
    ;mptblcname SPGAIN
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x3C, 0x14, 0xFF, 0x9A     ;Point 1
    .byte 0x6E, 0x00, 0x00, 0x9A     ;Point 2
    .byte 0xAA, 0x24                 ;Point 3

	;.org	0x87a4
VNTAB1_CruiseControlLimitToAMaxVent:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x16A7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlLimitToAMaxVent
    ;mptblcname VNTAB1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x87a5
VNTAB2_CruiseControlLimitToHalfMaxVent:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x16B4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlLimitToHalfMaxVent
    ;mptblcname VNTAB2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x80                       ;Point 1

	;.org	0x87a6
SETIME_CruiseControlNoSetupPulseWhenDecelTimerAboveThis:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x16C1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlNoSetupPulseWhenDecelTimerAboveThis
    ;mptblcname SETIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x37                       ;Point 1

	;.org	0x87a7
SETIM1_CruiseControlNoSetupPulseWhenDecelTimerBelowThis:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x16CE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlNoSetupPulseWhenDecelTimerBelowThis
    ;mptblcname SETIM1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x52                       ;Point 1

	;.org	0x87a8
ACLRST_CruiseControlDeltaSpeedToResetAccFlag:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x16DB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlDeltaSpeedToResetAccFlag
    ;mptblcname ACLRST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x30                       ;Point 1

	;.org	0x87a9
CLOTHR_CruiseControlDontVentIfThrottleBelowThis:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x16E8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlDontVentIfThrottleBelowThis
    ;mptblcname CLOTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Point 1

	;.org	0x87aa
MAXTHR_CruiseControlDontVacIfThrottleAboveThis:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x16F5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlDontVacIfThrottleAboveThis
    ;mptblcname MAXTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x50                       ;Point 1

	;.org	0x87ab
MAXSET_CruiseControlMaxSetSpeedTimesTwo:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1702
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlMaxSetSpeedTimesTwo
    ;mptblcname MAXSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 127.5 mph
    ;mptbldesc Detailed_Description
    .byte 0xAA                       ;Point 1

	;.org	0x87ac
MINSET_CruiseControlMinSetSpeedTimesTwo:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x170F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlMinSetSpeedTimesTwo
    ;mptblcname MINSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 127.5 mph
    ;mptbldesc Detailed_Description
    .byte 0x3C                       ;Point 1

	;.org	0x87ad
SCNVHI_CruiseControlForBrakeFlagManualTransmissionClutchDisable:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x171C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlForBrakeFlagManualTransmissionClutchDisable_Hi
    ;mptblcname SCNVHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xF1                       ;Point 1

	;.org	0x87ae
SCNVLO_CruiseControlForBrakeFlagManualTransmissionClutchDisable:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1729
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlForBrakeFlagManualTransmissionClutchDisable_Lo
    ;mptblcname SCNVLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x52                       ;Point 1

	;.org	0x87af
LOSPCO_CruiseControlLowSpeedCutoutSpeed:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1736
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname CruiseControlLowSpeedCutoutSpeed
    ;mptblcname LOSPCO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0640                     ;Point 1

	;.org	0x87b1
CRSVAR_CruiseControlVariableAdd:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1743
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlVariableAdd
    ;mptblcname CRSVAR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Point 1

	;.org	0x87b2
VACTIM_CruiseControlVacuumTime:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1750
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlVacuumTime
    ;mptblcname VACTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x87b3
SETDLT_CruiseControlSetDeltaControlPointForCableAdaptive:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x175D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlSetDeltaControlPointForCableAdaptive
    ;mptblcname SETDLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x87b4
CRMSK2_CruiseMask2:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x176A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask2
    ;mptblcname CRMSK2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x07                       ;Point 1

	;.org	0x87b5
CRMSK3_CruiseMask3:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1777
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask3
    ;mptblcname CRMSK3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xF4                       ;Point 1

	;.org	0x87b6
CRMSK7_CruiseMask7:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1784
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask7
    ;mptblcname CRMSK7
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x87b7
CRMSK4_CruiseMask4:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1791
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask4
    ;mptblcname CRMSK4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

	;.org	0x87b8
CRMSK6_CruiseMask6:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x179E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask6
    ;mptblcname CRMSK6
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x1E                       ;Point 1

	;.org	0x87b9
CRMSK5_CruiseMask5:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x17AB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask5
    ;mptblcname CRMSK5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xE2                       ;Point 1

	;.org	0x87ba
CRSCN1_CruiseComapreConstant1:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x17B8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseComapreConstant1
    ;mptblcname CRSCN1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x15                       ;Point 1

	;.org	0x87bb
CRMASK_CruiseMask:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x17C5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask
    ;mptblcname CRMASK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x11                       ;Point 1

	;.org	0x87bc
CRSCN2_CruiseComapreConstant2:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x17D2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseComapreConstant2
    ;mptblcname CRSCN2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x06                       ;Point 1

PTUMTP_PTUMinLockTemperature:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Entry_Conditions\
    ;mptbladdr 0x17DE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUMinLockTemperature
    ;mptblcname PTUMTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc Min_temp_for_PTU_lock
    .byte 0xC1                       ;Point 1

PTUMSP_PTUMinLockSpeed:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Entry_Conditions\
    ;mptbladdr 0x17EA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUMinLockSpeed
    ;mptblcname PTUMSP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 127.5 mph
    ;mptbldesc Min_Speed_for_PTU_lock
    .byte 0x5A                       ;Point 1

PTUCNH_PTUCounterHiSpeed:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Hysteresis\
    ;mptbladdr 0x17F6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUCounterHiSpeed
    ;mptblcname PTUCNH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x5D                       ;Point 1

PTUCNL_PTUCounterLoSpeed:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Hysteresis\
    ;mptbladdr 0x1802
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUCounterLoSpeed
    ;mptblcname PTUCNL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x5D                       ;Point 1

PTUDTP_PTUDeltaTPSForUnlock:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Hysteresis\
    ;mptbladdr 0x180E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUDeltaTPSForUnlock
    ;mptblcname PTUDTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Delta_TPS 0 5 V
    ;mptbldesc Min_TPS_for_PTU_unlock
    .byte 0x34                       ;Point 1

PTUMP1_PTUMAPThresholdForLock1:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Entry_Conditions\
    ;mptbladdr 0x181A
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname PTUMAPThresholdForLock1
    ;mptblcname PTUMP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Delta_MAP 0 44.1 PSI
    ;mptbldesc Delta_MAP_for_PTU_unlock
    ;mpmapaxis y
    .byte 0x50                       ;Point 1

PTUMP2_PTUMAPThresholdForLock2:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Entry_Conditions\
    ;mptbladdr 0x1827
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname PTUMAPThresholdForLock2
    ;mptblcname PTUMP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis deltaMAP 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x39                       ;Point 1

PTUMP3_PTUMAPThresholdForLock3:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Entry_Conditions\
    ;mptbladdr 0x1834
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname PTUMAPThresholdForLock3
    ;mptblcname PTUMP3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Delta_MAP 0 44.1 PSI
    ;mptbldesc Delta_MAP_for_PTU_unlock
    ;mpmapaxis y
    .byte 0x50                       ;Point 1

PTUCNI_PTUCounterTimerIntervalForLoop:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Entry_Conditions\
    ;mptbladdr 0x1841
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUCounterTimerIntervalForLoop
    ;mptblcname PTUCNI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x07                       ;Point 1

PTUUUL_UpperLimitForPTUUnlock:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\TPS_Limits_for_Lockup\
    ;mptbladdr 0x184D
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname UpperLimitForPTUUnlock
    ;mptblcname PTUUUL
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis Delta_TPS 0 5 Volts
    ;mptbldesc Primary_engagnement_point_for_PTU
    .byte 0x04                       ;Number of points in table
    .byte 0x44, 0x04, 0x09, 0x40     ;Point 1
    .byte 0x48, 0x29, 0x00, 0xAB     ;Point 2
    .byte 0x5A, 0x35, 0x0A, 0xCD     ;Point 3
    .byte 0x64, 0xA1                 ;Point 4

PTUULL_LowerLimitForPTUUnlock:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\TPS_Limits_for_Lockup\
    ;mptbladdr 0x185D
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname LowerLimitForPTUUnlock
    ;mptblcname PTUULL
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis Delta_TPS 0 5 Volts
    ;mptbldesc Primary_disengagnement_point_for_PTU
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x04                 ;Point 1

PTULUL_UpperLimitForPTULock:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\TPS_Limits_for_Lockup\
    ;mptbladdr 0x186A
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname UpperLimitForPTULock
    ;mptblcname PTULUL
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis Delta_TPS 0 5 Volts
    ;mptbldesc Secondary_engagnement_point_for_PTU
    .byte 0x04                       ;Number of points in table
    .byte 0x48, 0x06, 0x06, 0x80     ;Point 1
    .byte 0x4C, 0x20, 0x00, 0x80     ;Point 2
    .byte 0x6E, 0x31, 0x0B, 0x33     ;Point 3
    .byte 0x78, 0xA1                 ;Point 4

PTULLL_LowerLimitForPTULock:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\TPS_Limits_for_Lockup\
    ;mptbladdr 0x187A
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname LowerLimitForPTULock
    ;mptblcname PTULLL
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis Delta_TPS 0 5 Volts
    ;mptbldesc Secondary_disengagnement_point_for_PTU
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x06                 ;Point 1

STGSWS_StagingLimiterEnableSwitch:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Launch_Control\Launch_Control_Enable\
    ;mptbladdr 0x1887
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
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Launch_Control\Launch_Control_Enable\
    ;mptbladdr 0x189D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StageLimiterCutoffSpeed
    ;mptblcname STGSPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 255 mph
    ;mptbldesc Detailed_Description
    .byte 0x0A                       ;Point 1

STGTPS_StageLimiterMinTPS:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Launch_Control\Launch_Control_Entry_Conditions\
    ;mptbladdr 0x18A9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StageLimiterMinTPS
    ;mptblcname STGTPS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis TPSOverMINTHR 0 5 volts
    ;mptbldesc Fuel_added_while_launch_control_is_active.
    .byte 0x27                       ;Point 1

STGROF_StageLimiterRPMOffSetpoint:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Launch_Control\Launch_Control_RPM\
    ;mptbladdr 0x18B5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StageLimiterRPMOffSetpoint
    ;mptblcname STGROF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x7D                       ;Point 1

STGRON_StageLimiterRPMOnSetpoint:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Launch_Control\Launch_Control_RPM\
    ;mptbladdr 0x18C1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StageLimiterRPMOnSetpoint
    ;mptblcname STGRON
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x77                       ;Point 1

	;.org	0x8802
MPSHFT_OverboostFuelShutoffEnablePointFromMap_Timer:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\A_-_Overboost\
    ;mptbladdr 0x18CE
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostFuelShutoffEnablePointFromMap_Timer
    ;mptblcname MPSHFT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc If_MAP_+_BARO_exceeds_MPSHOF,_wait_SHFDLT,_then_kill_engine_for_TRNTM._Overboost_-_$ff_to_disable
    ;mpmapaxis y
    .byte 0x6F                       ;Point 1

	;.org	0x8803
MPSHFA_OverboostFuelShutoffEnablePointFromMap_Absolute:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\A_-_Overboost\
    ;mptbladdr 0x18DC
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostFuelShutoffEnablePointFromMap_Absolute
    ;mptblcname MPSHFA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc If_MAP_+_BARO_exceeds_MPSHOF,_wait_SHFDLT,_then_kill_engine_for_TRNTM._Overboost_-_$ff_to_disable
    ;mpmapaxis y
    .byte 0x0C                       ;Point 1

	;.org	0x8804
TRNTM_OverboostFuelShutoffDelay:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\A_-_Overboost\
    ;mptbladdr 0x18EA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OverboostFuelShutoffDuration
    ;mptblcname TRNTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 Sec
    ;mptbldesc Overboost_shutoff_duration_-_$ff_to_disable_-_stock_$5a
    .byte 0x5C                       ;Point 1

	;.org	0x8805
LMPSHF_OverboostFuelShutoffDisablePointFromMap_Limp:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\A_-_Overboost\
    ;mptbladdr 0x18F7
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostFuelShutoffDisablePointFromMap_Limp
    ;mptblcname LMPSHF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Overboost_Shutoff_when_Wastegate_problem_has_been_detected_(should_not_disable_this)
    ;mpmapaxis y
    .byte 0x4B                       ;Point 1

	;.org	0x8806
REVLMT_MapLimpinAndThrAbove25PercentLower1850:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x1905
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapLimpinAndThrAbove25PercentLower1850
    ;mptblcname REVLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Fuel_Off_RPM_for_bad_MAP
    .byte 0x3A                       ;Point 1

	;.org	0x8807
REVLMT2_MapLimpinAndThrAbove25PercentUpper2000:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x1912
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapLimpinAndThrAbove25PercentUpper2000
    ;mptblcname REVLMT2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Fuel_On_RPM_for_bad_MAP
    .byte 0x3E                       ;Point 1

	;.org	0x8808
REVLMT3_MapAbove75PctAndIdleSwitchClosed2000:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x191F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapAbove75PctAndIdleSwitchClosed2000
    ;mptblcname REVLMT3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x3E                       ;Point 1

	;.org	0x8809
REVLMT4_MapAbove75PctAndThrLimpin2000:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x192C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapAbove75PctAndThrLimpin2000
    ;mptblcname REVLMT4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x5E                       ;Point 1

	;.org	0x880a
REVLMT5_RPMLimiterNormalOnRPM:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\B_-_Rev_Limiter\
    ;mptbladdr 0x1939
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimiterNormalOnRPM
    ;mptblcname REVLMT5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0xDA                       ;Point 1

	;.org	0x880b
REVLMT6_RPMLimiterNormalOffRPM:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\B_-_Rev_Limiter\
    ;mptbladdr 0x1946
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimiterNormalOffRPM
    ;mptblcname REVLMT6
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0xDB                       ;Point 1

	;.org	0x880c
THRTHR_25PctThrValueFromShutoff:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x1953
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 25PctThrValueFromShutoff
    ;mptblcname THRTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x21                       ;Point 1

	;.org	0x880d
RVLSPD_CarSpeedForRevLimitWithTBOff:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x1960
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CarSpeedForRevLimitWithTBOff
    ;mptblcname RVLSPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 127.5 mph
    ;mptbldesc Detailed_Description
    .byte 0x14                       ;Point 1

	;.org	0x880e
DFRPM1_2050RPM_DecelFuelShutoffTurnonLimit:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x196D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 2050RPM_DecelFuelShutoffTurnonLimit
    ;mptblcname DFRPM1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xAD                       ;Point 1

	;.org	0x880f
DFRPM2_2560RPM_DecelFuelShutoffUpperRpmLimit:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x197A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 2560RPM_DecelFuelShutoffUpperRpmLimit
    ;mptblcname DFRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xDB                       ;Point 1

	;.org	0x8810
DFSMPH_20MPHDecelFuelShutoffSpeedLimit:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x1987
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 20MPHDecelFuelShutoffSpeedLimit
    ;mptblcname DFSMPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xAD                       ;Point 1

	;.org	0x8811
DFSTMP_60DegCDecelFuelShutoffTempLimit:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x1994
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 60DegCDecelFuelShutoffTempLimit
    ;mptblcname DFSTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xC0                       ;Point 1

	;.org	0x8812
DFSTMR_3minuteDecelFuelShutoffTimeLimit:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x19A1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 3minuteDecelFuelShutoffTimeLimit
    ;mptblcname DFSTMR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x8813
SPDLMH_SpeedLimitFuelShutoff254MPH:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\C_-_Speed_Limiter\
    ;mptbladdr 0x19AE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SpeedLimitFuelShutoff254mph
    ;mptblcname SPDLMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 255 mph
    ;mptbldesc Detailed_Description
    .byte 0xAF                       ;Point 1

	;.org	0x8814
SPDLML_SpeedLimitFuelShutoffRestore253MPH:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\C_-_Speed_Limiter\
    ;mptbladdr 0x19BB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SpeedLimitFuelShutoffRestore253mph
    ;mptblcname SPDLML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xAA                       ;Point 1

	;.org	0x8815
SPDRPM_EngineSpeedHighLimitToEnableOverspeed:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x19C8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineSpeedHighLimitToEnableOverspeed
    ;mptblcname SPDRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x78                       ;Point 1

	;.org	0x8816
SPDRPM2_EngineSpeedLowLimitToDisableOverspeed:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x19D5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineSpeedLowLimitToDisableOverspeed
    ;mptblcname SPDRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x77                       ;Point 1

MININC_Amount_MINTHR_IsIncreasedAtKeyOnOnly:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x19E1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Amount_MINTHR_IsIncreasedAtKeyOnOnly
    ;mptblcname MININC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Point 1

	;.org	0x8818
MAPTHR_ThrottleSelfCalibrationMapDeltaThreshold:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x19EE
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname ThrottleSelfCalibrationMapDeltaThreshold
    ;mptblcname MAPTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x21                       ;Point 1

	;.org	0x8819
RPMTHR_ThrottleSelfCalibrationRpmThreshold:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x19FC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleSelfCalibrationRpmThreshold
    ;mptblcname RPMTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x30                       ;Point 1

	;.org	0x881a
MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x1A09
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ValueOf_MINTHR_WhenBatteryDisconnected
    ;mptblcname MTHRMX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x5C                       ;Point 1

	;.org	0x881b
MAXCNT_ProgramLoopsWithThrottleBelow_MINTHR_ToDecrement_MINTHR:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x1A16
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ProgramLoopsWithThrottleBelow_MINTHR_ToDecrement_MINTHR
    ;mptblcname MAXCNT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1

	;.org	0x881c
MTHRCL_NumberOfBitsAbove_MINTHR_ToDetermineOnThrottleTransition:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x1A23
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NumberOfBitsAbove_MINTHR_ToDetermineOnThrottleTransition
    ;mptblcname MTHRCL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

	;.org	0x881d
MTHROP_NumberOfBitsAbove_MINTHR_ToDetermineOffThrottleTransition:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x1A30
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NumberOfBitsAbove_MINTHR_ToDetermineOffThrottleTransition
    ;mptblcname MTHROP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x881e
EGR1_ExhGasRecircConst:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1A3D
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst1
    ;mptblcname EGR1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x01C7                     ;Point 1

	;.org	0x8820
EGR3_ExhGasRecircConst:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1A4A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst3
    ;mptblcname EGR3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x80                       ;Point 1

	;.org	0x8821
EGR18_ExhGasRecircConstLoLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1A57
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstLoLimit18
    ;mptblcname EGR18
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x8822
EGR18a_ExhGasRecircConstHiLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1A64
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstHiLimit18a
    ;mptblcname EGRR18A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x8823
EGR16_ExhGasRecircConstLoLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1A71
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstLoLimit16
    ;mptblcname EGR16
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x8824
EGR16a_ExhGasRecircConstHiLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1A7E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstHiLimit16a
    ;mptblcname EGR16A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x8825
EGR14_ExhGasRecircConstFromTPSVoltsLoLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1A8B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromTPSVoltsLoLimit14
    ;mptblcname EGR14
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0C                       ;Point 1

	;.org	0x8826
EGR14a_ExhGasRecircConstFromTPSVoltsHiLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1A98
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromTPSVoltsHiLimit14a
    ;mptblcname EGR14A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x18                       ;Point 1

	;.org	0x8827
EGR19_ExhGasRecircConstLoLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1AA5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstLoLimit19
    ;mptblcname EGR19
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0F                       ;Point 1

	;.org	0x8828
EGR19a_ExhGasRecircConstHiLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1AB2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstHiLimit19a
    ;mptblcname EGR19A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x15                       ;Point 1

	;.org	0x8829
EGR15_ExhGasRecircConstFromRPMLoLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1ABF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromRPMLoLimit15
    ;mptblcname EGR15
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x882a
EGR15b_ExhGasRecircConstFromRPMLoLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1ACC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromRPMLoLimit15b
    ;mptblcname EGR15B
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x882b
EGR17_ExhGasRecircConstLoLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1AD9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstLoLimit17
    ;mptblcname EGR17
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x882c
EGR17a_ExhGasRecircConstHiLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1AE6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstHiLimit17a
    ;mptblcname EGR17A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x882d
EGR4_ExhGasRecircConst:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1AF3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst4
    ;mptblcname EGR4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xEB                       ;Point 1

	;.org	0x882e
EGR5_ExhGasRecircConst:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B00
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst5
    ;mptblcname EGR5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x882f
EGR6_ExhGasRecircConst:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B0D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst6
    ;mptblcname EGR6
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x8830
EGR15a_ExhGasRecircConstFromRPMHiLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B1A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromRPMHiLimit15a
    ;mptblcname EGR15A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x6C                       ;Point 1

	;.org	0x8831
EGR7_ExhGasRecircConst:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B27
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst7
    ;mptblcname EGR7
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x8832
SCRMP1_SecondaryRampSubtractor1:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B34
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SecondaryRampSubtractor1
    ;mptblcname SCRMP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

	;.org	0x8833
ADMEMA_ValueFromAdaptivememoryAdder1:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B41
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ValueFromAdaptivememoryAdder1
    ;mptblcname ADMEMA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x8834
EGR8_ExhGasRecircConst:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B4E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst8
    ;mptblcname EGR8
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x81                       ;Point 1

	;.org	0x8835
EGR8a_ExhGasRecircConst:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B5B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst8a
    ;mptblcname EGR8A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xF9                       ;Point 1

	;.org	0x8836
EGR33_ExhGasRecircConstFromMAPBelowBaro:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B68
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname ExhGasRecircConstFromMAPBelowBaro33
    ;mptblcname EGR33
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x09                       ;Point 1

	;.org	0x8837
EGR9_ExhGasRecircConstFromTimeEngRunning:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B76
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromTimeEngRunning9
    ;mptblcname EGR9
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x80                       ;Point 1

	;.org	0x8838
EGR13_ExhGasRecircConstFromRPM:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B83
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromRPM13
    ;mptblcname EGR13
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x8839
EGR10_ExhGasRecircConstFromRPM:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B90
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromRPM10
    ;mptblcname EGR10
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x883a
EGR11_ExhGasRecircConstFromMAP:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B9D
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname ExhGasRecircConstFromMAP11
    ;mptblcname EGR11
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x00                       ;Point 1

	;.org	0x883b
EGR12_ExhGasRecircConstFromMAP:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1BAB
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname ExhGasRecircConstFromMAP12
    ;mptblcname EGR12
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x00                       ;Point 1

	;.org	0x883c
LMPINN_LimpinTableForMapFromThrottle:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1BB9
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname LimpinTableForMapFromThrottle
    ;mptblcname LMPINN
    ;mpxaxis TPS 0 255 tps
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x05                       ;Number of points in table
    .byte 0x00, 0x00, 0x01, 0x90     ;Point 1
    .byte 0x10, 0x19, 0x01, 0x25     ;Point 2
    .byte 0x17, 0x21, 0x00, 0xE9     ;Point 3
    .byte 0x22, 0x2B, 0x00, 0xA8     ;Point 4
    .byte 0x45, 0x42                 ;Point 5

	;.org	0x8853
MPLMOF_OffsetForCalcMapInMapLimpin:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1BCC
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OffsetForCalcMapInMapLimpin
    ;mptblcname MPLMOF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x15                       ;Point 1

	;.org	0x8854
THROFF_OffsetAddedToCalcThrottle:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1BDA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OffsetAddedToCalcThrottle
    ;mptblcname THROFF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0B                       ;Point 1

	;.org	0x8855
TMPHIG_OutOfRangeColdTooHighA2D:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1BE7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OutOfRangeColdTooHighA2D
    ;mptblcname TMPHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFD                       ;Point 1

	;.org	0x8856
TMPLOW_OutOfRangeHotTooLowA2D:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1BF4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OutOfRangeHotTooLowA2D
    ;mptblcname TMPLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x1A                       ;Point 1

	;.org	0x8857
DEFTMP_DefaultEngineTemp:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1C01
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DefaultEngineTemp
    ;mptblcname DEFTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis CoolantTemp -200 260 DegF
    ;mptbldesc Detailed_Description
    .byte 0x95                       ;Point 1

	;.org	0x8858
BTLRPM_LowBatteryVoltageAtThisRpm1500:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1C0E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowBatteryVoltageAtThisRpm1500
    ;mptblcname BTLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x2E                       ;Point 1

	;.org	0x8859
CTLRPM_LowBatteryVoltageAtThisCoolantTemp:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1C1B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowBatteryVoltageAtThisCoolantTemp
    ;mptblcname CTLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xCD                       ;Point 1

	;.org	0x885a
BTLRPM2_LowBatteryVoltageAtThisRpm1500:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1C28
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowBatteryVoltageAtThisRpm1500_2
    ;mptblcname BTLRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x2E                       ;Point 1

	;.org	0x885b
AMBLOW_BattTempLowWhenHot:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1C35
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BattTempLowWhenHot
    ;mptblcname AMBLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Point 1

	;.org	0x885c
AMBHIG_BattTempHighWhenCold:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1C42
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BattTempHighWhenCold
    ;mptblcname AMBHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFA                       ;Point 1

	;.org	0x885d
CHGLOW_ChargeTempOutOfRangeLow:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1C4F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ChargeTempOutOfRangeLow
    ;mptblcname CHGLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x08                       ;Point 1

	;.org	0x885e
CHGHIG_ChargeTempOutOfRangeHigh:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1C5C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ChargeTempOutOfRangeHigh
    ;mptblcname CHGHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFD                       ;Point 1

	;.org	0x885f
DEFCHG_DefaultChargeTemp_Limpin:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1C69
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DefaultChargeTemp_Limpin
    ;mptblcname DEFCHG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xAD                       ;Point 1

	;.org	0x8860
ERRRPM_RPMLimitforErrorCodeSetting:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1C76
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimitforErrorCodeSetting
    ;mptblcname ERRRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x38                       ;Point 1

	;.org	0x8861
ERRMAP_MAPLimitforErrorCodeSetting:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1C83
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MAPLimitforErrorCodeSetting
    ;mptblcname ERRMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x1D                       ;Point 1

	;.org	0x8862
ERRTMP_CoolantTempLimitforErrorCodeSetting:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1C91
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CoolantTempLimitforErrorCodeSetting
    ;mptblcname ERRTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xA0                       ;Point 1

	;.org	0x8863
THRLOW_ThrottleLowerLimit:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1C9E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleLowerLimit
    ;mptblcname THRLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x08                       ;Point 1

	;.org	0x8864
THRHIG_ThrottleUpperLimit:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1CAB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleUpperLimit
    ;mptblcname THRHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xF0                       ;Point 1

	;.org	0x8865
MPTHR_MapSwitchPointForFullThrottleOrIdle:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1CB8
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MapSwitchPointForFullThrottleOrIdle
    ;mptblcname MPTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x45                       ;Point 1

	;.org	0x8866
COILLO_LoLimitBatteryVoltsForCoilVerify:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1CC6
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname LoLimitBatteryVoltsForCoilVerify
    ;mptblcname COILLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x03                       ;Point 1

	;.org	0x8867
COILHI_HiLimitBatteryVoltsForCoilVerify:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1CD4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HiLimitBatteryVoltsForCoilVerify
    ;mptblcname COILHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xBA                       ;Point 1

	;.org	0x8868
MAPLOW_MapSensorLowerLimit:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1CE1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapSensorLowerLimit
    ;mptblcname MAPLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x8869
MAPHIG_MapSensorUpperLimit:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1CEE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapSensorUpperLimit
    ;mptblcname MAPHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xEE                       ;Point 1

	;.org	0x886a
MPLTHR_ThrottleLevelAbove_MINTHR_ToMatureMapLimpin:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1CFB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleLevelAbove_MINTHR_ToMatureMapLimpin
    ;mptblcname MPLTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x42                       ;Point 1

	;.org	0x886b
MPDELT_DeltaMapThatChecksGood:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D08
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaMapThatChecksGood
    ;mptblcname MPDELT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x886c
MPDELA_MatureMapLimpinWhenDeltaAbove_MPDELT_plus_MPDELA:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D15
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MatureMapLimpinWhenDeltaAbove_MPDELT_plus_MPDELA
    ;mptblcname MPDELA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x886d
MPRPML_DisableMapCheckUnderThisRpm_600:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D22
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DisableMapCheckUnderThisRpm_600
    ;mptblcname MPRPML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x12C0                     ;Point 1

	;.org	0x886f
MPRPMH_DisableMapCheckAboveThisRpm_1500:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D2F
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DisableMapCheckAboveThisRpm_1500
    ;mptblcname MPRPMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x2EE0                     ;Point 1

	;.org	0x8871
MPDAGL_DisableMapCheckBelowThisMap:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D3C
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DisableMapCheckBelowThisMap
    ;mptblcname MPDAGL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x0B                       ;Point 1

	;.org	0x8872
MPDAGH_DisableMapCheckAboveThisMap:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D4A
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DisableMapCheckAboveThisMap
    ;mptblcname MPDAGH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x56                       ;Point 1

	;.org	0x8873
MPRMPD_CheckMapAtZeroSpeedAndThisDeltaRpm:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D58
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname CheckMapAtZeroSpeedAndThisDeltaRpm
    ;mptblcname MPRMPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0200                     ;Point 1

	;.org	0x8875
BAROSW_CheckMapAtZeroSpeedAndThisBaroSwitch:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D65
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname CheckMapAtZeroSpeedAndThisBaroSwitch
    ;mptblcname BAROSW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x41                       ;Point 1

	;.org	0x8876
MPVACD_AllowMapToTestGoodThisNearBaro:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D73
    ;mptbltype 4
    ;mpsubtype 1
    ;mptbllname AllowMapToTestGoodThisNearBaro
    ;mptblcname MPVACD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .word 0x0B5B                     ;Point 1

	;.org	0x8878
FUELTR_FuelMonitorConversionFactor:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D81
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname FuelMonitorConversionFactor
    ;mptblcname FUELTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    ;mpinjscale word
    .word 0x020F                     ;Point 1

	;.org	0x887a
FLWMNC_FuelMonitorCorrection:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D8F
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname FuelMonitorCorrection
    ;mptblcname FLWMNC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0066                     ;Point 1

	;.org	0x88cd
TTEMPL_TstatDiagnosticsMinTempToArmDiagnosticsAtStartup:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\T-Stat_Diagnostics\
    ;mptbladdr 0x1D9C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsMinTempToArmDiagnosticsAtStartup
    ;mptblcname TTEMPL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc Detailed_Description
    .byte 0x63                       ;Point 1

	;.org	0x88ce
TTEMPH_TstatDiagnosticsMaxTempToArmDiagnosticsAtStartup:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\T-Stat_Diagnostics\
    ;mptbladdr 0x1DA9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsMaxTempToArmDiagnosticsAtStartup
    ;mptblcname TTEMPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc Detailed_Description
    .byte 0xE4                       ;Point 1

	;.org	0x88cf
TDAGTP_TstatDiagnosticsTemperatureGoalWithin_HOTIME:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\T-Stat_Diagnostics\
    ;mptbladdr 0x1DB6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsTemperatureGoalWithin_HOTIME
    ;mptblcname TDAGTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc Detailed_Description
    .byte 0xC7                       ;Point 1

	;.org	0x88d0
HOTIME_TstatDiagnosticsTimeToAchieveTemperatureGoal:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\T-Stat_Diagnostics\
    ;mptbladdr 0x1DC3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsTimeToAchieveTemperatureGoal
    ;mptblcname HOTIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xAE                       ;Point 1




; I changed the MAP transfer function constants to be read from a constant value, rather than hard-coded
; into the binary. This makes it easier to find/change these values when changing MAP sensors.
;
; I'll add more info about the MAP transfer function later, but basically these constants are only used
; to convert MAP volts to MAP pressure. NOT for altering 2 to 3- bar. These constants will be unique for
; each MAP sensor (but should be the same for a given type/manufacturer).


	;.org	0x8888
TMPTL1_TempForColdScaleFromA2D:
    ;mpgrp 0_-_Setup\D_-_Transfer_Functions\
    ;mptbladdr 0x1DDB
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

	;.org	0x88a7
TMPTL2_TempForHotScaleA2D:
    ;mpgrp 0_-_Setup\D_-_Transfer_Functions\
    ;mptbladdr 0x1DEF
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

	;.org	0x88ba
CHGTL1_TempForChargeTempA2D:
    ;mpgrp 0_-_Setup\D_-_Transfer_Functions\
    ;mptbladdr 0x1E00
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempForChargeTempA2D
    ;mptblcname CHGTL1
    ;mpxaxis raw 0 255 scale
    ;mpyaxis Coolant_Temperature -200 260 F
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Number of points in table
    .byte 0x0E, 0xFF, 0xFE, 0x43     ;Point 1
    .byte 0x29, 0xD0, 0xFF, 0x8D     ;Point 2
    .byte 0xE3, 0x7C, 0xFE, 0x70     ;Point 3
    .byte 0xFA, 0x58                 ;Point 4

MAPMULT_ScaleMAPVoltsToPresMultiplyConst:
    ;mpgrp 0_-_Setup\D_-_Transfer_Functions\
    ;mptbladdr 0x1E10
    ;mptbltype 8
    ;mpsubtype 1
    ;mptbllname ScaleMAPVoltsToPresMultiplyConst
    ;mptblcname MAPMULT
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc Map_Scale_multiplier._This_is_the_slope_constant_for_the_MAP_sensor_transfer_function._#07_is_the_original_Mopar_2-bar_constant._#09_for_the_S60_3-bar_sensor._The_GM_or_MSD_3-Bar_sensors_may_need_these_values_changed_for_accuracy.
    ;mpchoices 1.0_Bar 07 1.5_Bar 07 2.0_Bar 7 2.5_Bar 08 3.0_Bar 9 3.5_Bar 09 4.0_Bar 09 4.5_Bar 09
    ;mpmapaxis b
    .byte 0x09                       ;Point 1

MAPADD_ScaleMAPVoltsToPresAddConst:
    ;mpgrp 0_-_Setup\D_-_Transfer_Functions\
    ;mptbladdr 0x1E1E
    ;mptbltype 8
    ;mpsubtype 1
    ;mptbllname ScaleMAPVoltsToPresAddConst
    ;mptblcname MAPADD
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc Scale_MAP_Volts_to_MAP_add_constant:_This_is_the_offset_constant_for_the_MAP_sensor_transfer_function._#0361_is_the_original_Mopar_2-bar_constant._#0700_for_the_S60_3-bar_sensor._The_GM_or_MSD_3-Bar_sensors_may_need_these_values_changed_for_accuracy.
    ;mpchoices 1.0_Bar 0361 1.5_Bar 0361 2.0_Bar 361 2.5_Bar 0700 3.0_Bar 700 3.5_Bar 0700 3.984.0_Bar 0700 3.984.5_Bar 0700
    ;mpmapaxis w
    .word 0x0700                     ;Point 1

MINAMP_MinimumAverageMAP:
    ;mpgrp 0_-_Setup\D_-_Transfer_Functions\
    ;mptbladdr 0x1E2C
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MinimumAverageMAP
    ;mptblcname MINAMP
    ;mpxaxis IN 0 255 X
    ;mpyaxis PSI 0 44.1 psi
    ;mptbldesc Minimum_value_for_the_MAP_averaging_function.
    ;mpmapaxis y
    .byte 0x04                       ;Point 1

	;.org	0x89f7
AISTEP_BitPatternForAisControl:
    ;mpgrp 0_-_Setup\D_-_Transfer_Functions\
    ;mptbladdr 0x1E3A
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname BitPatternForAisControl
    ;mptblcname AISTEP
    ;mpxaxis in_desc 4 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x06                       ;Point 1
    .byte 0x05                       ;Point 2
    .byte 0x09                       ;Point 3
    .byte 0x0A                       ;Point 4

KNKMIN_FlashCEMinTemp:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\CEL_Knock_Indicator\
    ;mptbladdr 0x1E49
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FlashCEMinTemp
    ;mptblcname KNKMIN
    ;mpxaxis IN 0 255 X
    ;mpyaxis CoolantTemp -200 260 deg
    ;mptbldesc The_min_temp_allowed_before_the_CE_light_is_flashed._To_avoid_false_indication_on_a_cold_engine.
    .byte 0xA8                       ;Point 1

; SLRPM_ShiftLightSetpoint:
;     ;mpgrp Turbonator_Features\Shift_Light\
;     ;mptbladdr 0x1D52
;     ;mptbltype 4
;     ;mpsubtype n
;     ;mptbllname ShiftLightSetpoint
;     ;mptblcname SLRPM
;     ;mpxaxis in_desc 0 255 in
;     ;mpyaxis RPM 0 8160 rpm
;     ;mptbldesc Shift_light_setpoint.
;     .word 0x9B00                     ;Point 1

AKPMON_AlkyPumpOnSetpointFromMAP:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Alky_Injection\
    ;mptbladdr 0x1E61
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyPumpOnSetpointFromMAP
    ;mptblcname AKPMON
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Description
    ;mpmapaxis y
    .byte 0xAA                       ;Point 1

AKPMOF_AlkyPumpOffSetpointFromMAP:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Alky_Injection\
    ;mptbladdr 0x1E6E
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyPumpOffSetpointFromMAP
    ;mptblcname AKPMOF
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Description
    ;mpmapaxis y
    .byte 0xAA                       ;Point 1

AKI1ON_AlkyInj1OnSetpointFromMAP:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Alky_Injection\
    ;mptbladdr 0x1E7B
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyInj1OnSetpointFromMAP
    ;mptblcname AKI1ON
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Description
    ;mpmapaxis y
    .byte 0xAA                       ;Point 1

AKI1OF_AlkyInj1OffSetpointFromMAP:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Alky_Injection\
    ;mptbladdr 0x1E88
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyInj1OffSetpointFromMAP
    ;mptblcname AKI1OF
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Description
    ;mpmapaxis y
    .byte 0xAA                       ;Point 1

AKI2ON_AlkyInj2OnSetpointFromMAP:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Alky_Injection\
    ;mptbladdr 0x1E95
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyInj2OnSetpointFromMAP
    ;mptblcname AKI2ON
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Description
    ;mpmapaxis y
    .byte 0xAA                       ;Point 1

AKI2OF_AlkyInj2OffSetpointFromMAP:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Alky_Injection\
    ;mptbladdr 0x1EA2
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyInj2OffSetpointFromMAP
    ;mptblcname AKI2OF
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Description
    ;mpmapaxis y
    .byte 0xAA                       ;Point 1

; these are the added baud rate definitions
; in D-Cal, these can be defined as data type 6 (value list), but not in chem...

; To achieve 977 baud, byte=0x25
; To achieve 1200 baud, byte ox33
; To achieve 9608 baud, byte = 0x30
; to achieve 7812 baud, byte = 0x22
; To achieve 62500 baud, byte = 0x01

BAUDLO_DRBBaudRateLo:
    ;mpgrp 0_-_Setup\F_-_Baud_Rate\
    ;mptbladdr 0x1EB8
    ;mptbltype 6
    ;mpsubtype n
    ;mptbllname DRBBaudRateLow
    ;mptblcname BAUDLO
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc Initial_(low-speed)_baudrate_for_DRB_protocol.
    ;mpchoices 977_Baud 25 1200_Baud 33 9608_Baud 30 7812_Baud 22 62500_Baud 01 12500_Baud 00 Unused 00 Unused 00
    .byte 0x22                       ;Point 1

BAUDHI_DRBBaudRateHi:
    ;mpgrp 0_-_Setup\F_-_Baud_Rate\
    ;mptbladdr 0x1EC5
    ;mptbltype 6
    ;mpsubtype n
    ;mptbllname DRBBaudRateHi
    ;mptblcname BAUDHI
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc Data_(high-speed)_baudrate_for_DRB_protocol.
    ;mpchoices 977_Baud 25 1200_Baud 33 9608_Baud 30 7812_Baud 22 62500_Baud 01 12500_Baud 00 Unused 00 Unused 00
    .byte 0x01                       ;Point 1

BAUDMD_HiSpeedSerialBaudRate:
    ;mpgrp 0_-_Setup\F_-_Baud_Rate\
    ;mptbladdr 0x1ED2
    ;mptbltype 6
    ;mpsubtype n
    ;mptbllname HiSpeedSerialBaudRate
    ;mptblcname BAUDMD
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc Baudrate_for_hi-speed_datalogger.
    ;mpchoices 977_Baud 25 1200_Baud 33 9608_Baud 30 7812_Baud 22 62500_Baud 01 12500_Baud 00 Unused 00 Unused 00
    .byte 0x30                       ;Point 1

NO2SWS_NO2SwitchSelect:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\NO2_Retard\
    ;mptbladdr 0x1EDF
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname NO2SwitchSelect
    ;mptblcname NO2SWS
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc Switch_that_will_activate_high_boost_mode._If_no_switch_is_selected,_then_theboost_is_not_selectable,_and_the_Low_Boost_curve_needs_to_be_setup_as_the_high_boost_curve.
    ;mpchoices B1Voltage_Sense(Do_Not_Use)  Speed_Control_Set_(Momentary)  Speed_Control_On/Off  Speed_Control_Resume_(Momentary)  A/C_Switch  A/C_Clutch_Input(Do_Not_Use)  Brake_Switch  Park/Neutral_Switch
    .byte 0x02                       ;Point 1
       no2_PNswitch		= $%10000000	; Park/Neutral switch
       no2_Brake		= $%01000000	; Brake Switch
       no2_DistSync		= $%00100000	; Distributor Sync
       no2_ACclutch		= $%00010000	; A/C Clutch input
       no2_CruiseResume		= $%00001000	; Cruise Resume
       no2_CruiseOnOff		= $%00000100	; Cruise On/Off
       no2_CruiseSet		= $%00000010	; Cruise Set
       no2_B1Volt		= $%00000001	; B1 Voltage Sense

NO2RET_NO2RetardConstant:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\NO2_Retard\
    ;mptbladdr 0x1EF4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NO2RetardConstant
    ;mptblcname NO2RET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Retard 0 15 deg
    ;mptbldesc Retard_amount_when_NO2_input_is_activated.
    .byte 0x1F                       ;Point 1

AFR2NB_WidebandAFRToO2TransferFunction:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\WB2NB\
    ;mptbladdr 0x1F00
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname WidebandAFRToO2TransferFunction
    ;mptblcname AFR2NB
    ;mpxaxis AFR 4 19.9375 ratio
    ;mpyaxis O2SensorVolts 0 5 volts
    ;mptbldesc Wideband_to_O2_transfer_function._Should_be_matched_to_the_sensor/driver_output.
    ;mpmapaxis y
    .byte 0x04                       ;Number of points in table
    .byte 0x00, 0x32, 0xFF, 0xFA     ;Point 1
    .byte 0xA7, 0x2E, 0xFB, 0x72     ;Point 2
    .byte 0xB0, 0x05, 0xFF, 0xFA     ;Point 3
    .byte 0xFF, 0x03                 ;Point 4

WB2AFR_WidebandToAFRTransferFunction:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\WB2NB\
    ;mptbladdr 0x1F11
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname WidebandToAFRTransferFunction
    ;mptblcname WB2AFR
    ;mpxaxis SensorVolts 0 5 volts
    ;mpyaxis AFR 4 19.9375 ratio
    ;mptbldesc Wideband_to_AFR_transfer_function._Should_be_matched_to_the_sensor/driver_output.
    .byte 0x02                       ;Number of points in table
    .byte 0x00, 0x52, 0x00, 0x9F     ;Point 1
    .byte 0xFF, 0xF0                 ;Point 2
    
NBOFFS_NarrowBandOffsetValue:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\WB2NB\
    ;mptbladdr 0x1F1F
    ;mptbltype 19
    ;mpsubtype n
    ;mptbllname NarrowBandOffsetValue
    ;mptblcname NBOFFS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis O2SensorVolts -2.5 2.5 volts
    ;mptbldesc Offset_for_NB_lookup_value._Use_to_shift_the_sensor_rich_or_lean.
    .byte 0x80                       ;Point 1
    
; Decel fuel cut template data to add:

DCLMER_MinTimeEngineRunningForDecelFuelShutoff:
    ;mpgrp 1_-_Fuel\G_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x1F2D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinTimeEngineRunningForDecelFuelShutoff
    ;mptblcname DCLMER
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

DCLMCT_MinCoolantTempForDecelFuelShutoff:
    ;mpgrp 1_-_Fuel\G_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x1F39
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinCoolantTempForDecelFuelShutoff
    ;mptblcname DCLMCT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xD2                       ;Point 1

DCLRPH_EngineRPMLimitForDecelFuelShutoffHigh:
    ;mpgrp 1_-_Fuel\G_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x1F45
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineRPMLimitForDecelFuelShutoffHigh
    ;mptblcname DCLRPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc High_RPM_to_activate_decel_fuel_shutoff._Should_be_lower_than_shutoff_RPM_Off_point.
    .byte 0x11                       ;Point 1

DCLRPL_EngineRPMLimitForDecelFuelShutoffLow:
    ;mpgrp 1_-_Fuel\G_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x1F51
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineRPMLimitForDecelFuelShutoffLow
    ;mptblcname DCLRPL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Low_RPM_to_activate_decel_fuel_shutoff._Should_be_lower_than_shutoff_RPM_On_point.
    .byte 0x0F                       ;Point 1

DCAISI_AISIncrementWhenUsingDecelFuelShut:
    ;mpgrp 1_-_Fuel\G_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x1F5D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AISIncrementWhenUsingDecelFuelShut
    ;mptblcname DCAISI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc AIS_Increment_for_recovery_from_decel_fuel_shutoff.
    .byte 0x00                       ;Point 1

DFRPMH_DecelFuelShutoffDeltaRPMOff:
    ;mpgrp 1_-_Fuel\G_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x1F69
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DecelFuelShutoffDeltaRPMOff
    ;mptblcname DFRPMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPMOverIdle 0 8192 rpm
    ;mptbldesc Decel_fuel_shutoff_RPM_over_Idle_off_point.
    .byte 0x1E                       ;Point 1

DFRPML_DecelFuelShutoffDeltaRPMOn:
    ;mpgrp 1_-_Fuel\G_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x1F75
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DecelFuelShutoffDeltaRPMOn
    ;mptblcname DFRPML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPMOverIdle 0 8192 rpm
    ;mptbldesc Decel_fuel_shutoff_RPM_over_Idle_on_point.
    .byte 0x11                       ;Point 1

	.msg "Complete."

; ********************************************************

