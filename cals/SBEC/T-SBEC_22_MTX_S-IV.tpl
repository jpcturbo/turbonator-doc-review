;mpver 2.00
;mpassmfile t-sbec_v4.asm
.org DataOrg
;mpinjsize 52.0
;mpbar 3.0

;mprevisionstart
; ***********************************************************************
; T-SBEC_22_MTX_A415_Daytona-VNT.tpl
; 2.2 VNT Cal Data (Daytona VNT)
;
; Revision History
;
; 04/13/10 - 1st release and test of VNT-based T-SBEC (re-written).
;
; ***********************************************************************
;mprevisionend

.msg "Assembling Data Structures..." ; these are just messages to display during assemble to let you know what's going on...


;mpfuelparms 6000,60,55,3.793,.740_Regular,2.2
;mpfuelnone1 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpfuelnone2 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpfuelpart1 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpfuelpart2 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpfuelfull1 12.5,12.5,12.5,12.5,12.5,12.5,12.5,12.5,12.5,12.5,12.5,12.5,12.5,12.5,12.13,11.75,11.38,11,11,11,11,11,11,11,11,11,11,11,11,11,11
;mpfuelfull2 11,11,11,11,11,10.92,10.84,10.76,10.68,10.6,10.52,10.44,10.36,10.28,10.2,10.12,10.04,9.96,9.88,9.8,9.72,9.64,9.56,9.48,9.4,9.32,9.24,9.16,9.08,9


	;.org	0x8000
ENDIT1_PNPrefix:
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
;mpgroupstart Shift_Light\
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
;mpgroupstart Fuel\Individual_Cylinder_Trim\
;1 - Fuel\F - Adaptive memory\Individual Cylinder Trim\
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
;mpgroupstart Utility\On-Board_Diagnostics\Alternator_Diagnostics\
;7 - Aux Functions\On-Board Diagnostics\Alternator Diagnostics\
;mpgroupend
;mpgroupstart Spark\Adaptive_Retard\
;2 - Spark\Adaptive Retard\
;mpgroupend
;mpgroupstart Utility\On-Board_Diagnostics\Fuel_Monitor\
;7 - Aux Functions\On-Board Diagnostics\Fuel Monitor\
;mpgroupend
;mpgroupstart Utility\On-Board_Diagnostics\MAP_Sensor\
;7 - Aux Functions\On-Board Diagnostics\MAP Sensor\
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
;mpgroupstart 0_-_Setup\F_-_DRB_Datalogging\
;0 - Setup\DRB Datalogging\
;mpgroupend
;mpgroupstart Utility\On-Board_Diagnostics\O2_Sensor_Diagnostics\
;7 - Aux Functions\On-Board Diagnostics\O2 Sensor Diagnostics\
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
;mpgroupstart Boost_Control\VNT_Control\
;3 - Boost Control\B - WG Control\VNT Control\
;mpgroupend
    ;mpgrp 0_-_Setup\B_-_Cal_ID\
    ;mptbladdr 0x00EE
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname PNPrefix
    ;mptblcname ENDIT1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Part_Number_prefix._The_1st_4_digits_of_the_Mopar_PN_for_this_ECU.
    .word 0x5276                     ;Point 1

	;.org	0x8002
ENDITM_ECUID:
    ;mpgrp 0_-_Setup\B_-_Cal_ID\
    ;mptbladdr 0x00FB
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ECU_ID
    ;mptblcname ENDITM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ECU_ID._This_portion_of_the_PN_is_used_by_scan_tools_to_automatically_ID_the_ECU._This_number_is_different_for_every_computer/cal._The_1st_digit_is_possibly_a_revision_code_of_some_type._Or,_it_may_have_no_meaning_at_all.
    .word 0xA415                     ;Point 1

	;.org	0x8004
HunstvilleTesterCodeBits:
    ;mpgrp 0_-_Setup\B_-_Cal_ID\
    ;mptbladdr 0x0108
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname Huntsville_Code
    ;mptblcname HUNTSV
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Special_code_for_factory_testing.
    .word 0xC9E5                     ;Point 1

	;.org	0x8006
MDLCDE_ModelTypeCode:
    ;mpgrp 0_-_Setup\B_-_Cal_ID\
    ;mptbladdr 0x0115
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ModelTypeCode
    ;mptblcname MDLCDE
    ;mpxaxis X 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc The_1st_2_digits_are_the_model_year,_2nd_2_digits_are_the_engine_and_trans_type.
    .word 0x4040                     ;Point 1
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

	;.org	0x8008
SpecialBytes:
    ;mpgrp 0_-_Setup\B_-_Cal_ID\
    ;mptbladdr 0x0160
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname Setup_bytes
    ;mptblcname SETUP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Desc
    .word 0x55AA                     ;Point 1

	;.org	0x800a
SpecialBytes2:
    ;mpgrp 0_-_Setup\B_-_Cal_ID\
    ;mptbladdr 0x016D
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname Setup_bytes_2
    ;mptblcname SETUP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Desc
    .word 0x0012                     ;Point 1

	;.org	0x800c
CONFIG_ConfigurationFlags:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x017A
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname ConfigurationFlags
    ;mptblcname CONFIG
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc These_are_the_factory_configuration_options.
    ;mpchoices Bit0  TransFuelTPS  Bit2  PTU_Enable  Charge_Temp_Sensor_Enabled  Auto_Trans_Bit  EGR_Installed  A/C_Installed
    .byte 0x8A                       ;Point 1

    cfg_AC	                = $%10000000	; A/C Installed
    cfg_EGR		        = $%01000000	; EGR installed
    cfg_ATX		        = $%00100000	; Auto trans (if set)
    cfg_CSEnrich		= $%00010000	;
    cfg_O2		        = $%00001000	;
    cfg_VNTOBFuelShut		= $%00000100	; Use fuel shut with VNT OB control
    cfg_UseTPSTransFuelEarly	= $%00000010	;
    cfg_VNT		        = $%00000001	; Use VNT Boost Control

OPTN1_CalCustomOptionConfigFlags1:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x0190
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
    ;mptbladdr 0x01A6
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname CalCustomOptionConfigFlags2
    ;mptblcname OPTN2
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc These_are_options_available_to_enable_in_this_custom_codebase.
    ;mpchoices Spark-based_Rev_Limiter  Fuel-based_Rev_Limiter  Launch_Control  Bang_Bang  Bit4  Anti-Lag_Timing  T2_Boost_Control  WB-2-NB_Conversion
    .byte 0x05                       ;Point 1
    opt_WB2NB  			 = $%10000000	 ; Internal WB to O2 sensor conversion
    opt_T2BC			 = $%01000000	 ;
    opt_AntiLag	     		 = $%00100000	 ;
    opt_CTS 			 = $%00010000	 ;
    opt_BangBang     	     	 = $%00001000	 ;
    opt_StageLim		 = $%00000100	 ; Suppress the EMR (Emiss Maint Reminder) Code
    opt_FuelRevLim		 = $%00000010	 ; Use the fuel-based rev limiter
    opt_SprkRevLim 		 = $%00000001	 ; Use the spark-based rev limiter

	;.org	0x800e
CCDCFG_CCDConfigConstant:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x01BC
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname CCDConfigConstant
    ;mptblcname CCDCFG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CCD_Bus_configuration_constant._Not_sure_of_usage.
    ;mpchoices Bit7  Bit6  Bit5  Bit4  Bit3  Bit2  Bit1  Bit0
    .byte 0xA1                       ;Point 1

	;.org	0x800f
CCDCF2_CCDConfigConstant2:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x01CA
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname CCDConfigConstant2
    ;mptblcname CCDCF2
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc CCD_Bus_configuration_constant._Not_sure_of_usage.
    ;mpchoices Bit7  Bit6  Bit5  Bit4  Bit3  Bit2  Bit1  Bit0
    .byte 0x00                       ;Point 1

	;.org	0x8010
CLDMAP_AdvanceFromMAPCold:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x01D8
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname AdvanceFromMAPCold
    ;mptblcname CLDMAP
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc Curve_for_Spark_Advance_from_MAP_when_Engine_Temp_is_below_TMPSWP
    ;mpmapaxis x
    .byte 0x04                       ;Number of points in table
    .byte 0x33, 0x05, 0x01, 0x1C     ;Point 1
    .byte 0x3C, 0x0F, 0x00, 0x00     ;Point 2
    .byte 0x4B, 0x0F, 0xFF, 0xD9     ;Point 3
    .byte 0xC9, 0xFC                 ;Point 4

	;.org	0x8023
CLDLMT_LimitForColdMapAtClosedThrottle:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x01EA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LimitForColdMapAtClosedThrottle
    ;mptblcname CLDLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y -200 260 out
    ;mptbldesc Coldest_input_allowed_for_Cold_MAP
    .byte 0x14                       ;Point 1

	;.org	0x8024
HOTMAP_AdvanceFromMAPWarmPart:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x01F7
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname AdvanceFromMAPWarmPart
    ;mptblcname HOTMAP
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc Curve_for_Spark_Advance_from_MAP_when_Engine_Temp_is_above_TMPSWP_and_not_at_Full_Throttle
    ;mpmapaxis x
    .byte 0x05                       ;Number of points in table
    .byte 0x2D, 0x18, 0xFF, 0x60     ;Point 1
    .byte 0x35, 0x13, 0xFE, 0xF0     ;Point 2
    .byte 0x45, 0x02, 0xFF, 0x9C     ;Point 3
    .byte 0x8A, 0xE7, 0xFF, 0xDB     ;Point 4
    .byte 0xC9, 0xDE                 ;Point 5

	;.org	0x8043
TMPSWP_EngTempSwitchPointForSparkAdvance:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x020A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngTempSwitchPointForSparkAdvance
    ;mptblcname TMPSWP
    ;mpxaxis IN 0 255 X
    ;mpyaxis Coolant_Temperature -200 260 F
    ;mptbldesc Engine_temperature_switch_point_for_hot_and_cold_map_spark
    .byte 0xB1                       ;Point 1

	;.org	0x8044
ADVCLS_AdvanceAddedForClosedLoopFromTimer:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x0217
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AdvanceAddedForClosedLoopFromTimer
    ;mptblcname ADVCLS
    ;mpxaxis Timer 0 255 F
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc Advance_from_coolant_temp_when_throttle_is_closed
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

PartThrottleTiming:
    ;mpgrp 99_-_Calculated_Tables\
    ;mptbladdr 0x0224
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
    ;mptbladdr 0x0238
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

	;.org	0x805b
WOTMAP_AdvanceFromMAPWarmFull:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x024D
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
    .byte 0x4B, 0x00, 0xFF, 0x22     ;Point 2
    .byte 0x5A, 0xF3, 0xFF, 0xC2     ;Point 3
    .byte 0x77, 0xEC, 0xFF, 0x72     ;Point 4
    .byte 0x89, 0xE2, 0xFF, 0xE0     ;Point 5
    .byte 0xC9, 0xDA                 ;Point 6

	;.org	0x806e
MAPMUL_MultiplierOnMapAdvanceWhenRetarding_FromRpm:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x0261
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname MultiplierOnMapAdvanceWhenRetarding_FromRpm
    ;mptblcname MAPMUL
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Spark_Advance_Scale 0 3.984 out
    ;mptbldesc Multiplier_on_Map_based_spark_advance_-_used_when_spark_advance_is_below_zero._Output_is_a_multiplier.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x40                 ;Point 1

	;.org	0x8085
RPMLMT_LimitForHotMAPAdvance:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x026F
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname LimitForHotMAPAdvance
    ;mptblcname RPMLMT
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc RPM_vs_Advance_when_engine_above_161F_and_throttle_(used_to_limit_max_MAP_advance_from_above_when_there_is_some_to_full_throttle)
    .byte 0x03                       ;Number of points in table
    .byte 0x20, 0x08, 0x00, 0x8E     ;Point 1
    .byte 0x32, 0x12, 0x00, 0x8F     ;Point 2
    .byte 0x4B, 0x20                 ;Point 3

	;.org	0x8090
PNIDLE_AdvanceRemovedIdleParkNeutral:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x027F
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AdvanceRemovedIdleParkNeutral
    ;mptblcname PNIDLE
    ;mpxaxis Coolant_Temperature -200 260 F
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc Not_used
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0x8097
PNRPM_EngineSpeedBelowWhich_PNIDLE_Enabled:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x028D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineSpeedBelowWhich_PNIDLE_Enabled
    ;mptblcname PNRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 RPM
    ;mptbldesc Engine_speed_below_which_PNIDLE_is_Enabled_-_for_Automatics
    .byte 0x01                       ;Point 1

	;.org	0x8098
GOVNER_AdvanceFromRPM:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x029A
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

	;.org	0x80b3
SPKLMT_TotalAdvanceAllowed:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x02AB
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

	;.org	0x80be
ADVDFT_DefaultSparkAdvance1:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x02BB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DefaultSparkAdvance1
    ;mptblcname ADVDFT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Spark_Advance 0 127.5 Degrees
    ;mptbldesc Detailed_Description
    .byte 0x14                       ;Point 1

	;.org	0x80bf
ADO2CL_AdvanceAddedFromO2FeedbackCounterLimitLow:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x02C8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdvanceAddedFromO2FeedbackCounterLimitLow
    ;mptblcname ADO2CL
    ;mpxaxis X 0 255 in
    ;mpyaxis Counter 0 255 Cnt
    ;mptbldesc Description
    .byte 0x1A                       ;Point 1

	;.org	0x80c0
ADO2CH_AdvanceAddedFromO2FeedbackCounterLimitHi:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x02D5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdvanceAddedFromO2FeedbackCounterLimitHi
    ;mptblcname ADO2CH
    ;mpxaxis X 0 255 in
    ;mpyaxis Counter 0 255 Cnt
    ;mptbldesc Description
    .byte 0xE6                       ;Point 1

	;.org	0x80c1
ADO2C1_AdvanceAddedFromO2FeedbackCounter1:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x02E2
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AdvanceAddedFromO2FeedbackCounter1
    ;mptblcname ADO2C1
    ;mpxaxis Counter 0 255 Cnt
    ;mpyaxis Spark_Advance 0 127.5 Degrees
    ;mptbldesc Description
    .byte 0x03                       ;Number of points in table
    .byte 0x70, 0x04, 0xFF, 0xC0     ;Point 1
    .byte 0x80, 0x00, 0xFF, 0xC0     ;Point 2
    .byte 0x90, 0xFC                 ;Point 3

	;.org	0x80d8
ADO2C2_AdvanceAddedFromO2FeedbackCounter2:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x02F2
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AdvanceAddedFromO2FeedbackCounter2
    ;mptblcname ADO2C2
    ;mpxaxis Counter 0 255 Cnt
    ;mpyaxis Spark_Advance 0 127.5 Degrees
    ;mptbldesc Description
    .byte 0x03                       ;Number of points in table
    .byte 0x70, 0x06, 0xFF, 0xA0     ;Point 1
    .byte 0x80, 0x00, 0xFF, 0xA0     ;Point 2
    .byte 0x90, 0xFA                 ;Point 3

	;.org	0x80ef
KNKRPM_MinRpmforKnockRetard:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x0302
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinRpmforKnockRetard
    ;mptblcname KNKRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 RPM
    ;mptbldesc Minimum_RPM_for_Knock_Retard
    .byte 0x20                       ;Point 1

	;.org	0x80f0
KNKOFS_DeltaAboveBaroFor_RTRDRT_and_KNKCNT_and_KNKCOR_incremented:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x030F
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaAboveBaroFor_RTRDRT_and_KNKCNT_and_KNKCOR_incremented
    ;mptblcname KNKOFS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 44.1 psi
    ;mptbldesc Delta_above_Baro_up_to_which_RTRDRT_(Retard_Rate)_is_used_and_KNKCNT_and_KNKCOR_are_incremented._Stock_is_5.4_psi.
    ;mpmapaxis y
    .byte 0x1F                       ;Point 1

	;.org	0x80f1
RTRDRT_KnockRetardRateNoBoost:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x031D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardRateNoBoost
    ;mptblcname RTRDRT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Deg 0 127.5 Degrees
    ;mptbldesc Retard_rate_from_Knock,_no_boost._In_half_degrees
    .byte 0x06                       ;Point 1

	;.org	0x80f2
RTRDRT2_KnockRetardRateInBoost:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x032A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardRateInBoost
    ;mptblcname RTRDRT2
    ;mpxaxis IN 0 255 X
    ;mpyaxis Retard 0 127.5 deg
    ;mptbldesc Retard_rate_from_Knock,_in_boost._In_half_degrees
    .byte 0x04                       ;Point 1

	;.org	0x80f3
INCSRT_KnockRetardIncreaseRate:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x0337
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardIncreaseRate
    ;mptblcname INCSRT
    ;mpxaxis in_desc 0 255 retard
    ;mpyaxis Y 0 127.5 deg
    ;mptbldesc Increase_Rate._Recovery_from_Knock_Retard._Rate_is_1/2_engine_degree_every_INCSRT+1_*_11ms._Use_ONLY_0,1,3,7,f,1f,3f,7f_or_ff
    .byte 0x1F                       ;Point 1

	;.org	0x80f4
RETMAX_MaxKnockRetardFromMap:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x0344
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

	;.org	0x80ff
KNKLIM_MaxKnockRetard:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x0354
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxKnockRetard
    ;mptblcname KNKLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Retard 0 127.5 Degrees
    ;mptbldesc Knock_Limit_in_1/2_degrees._MaxRetard_=_KNKLIM_if_throttle_is_above_THRKNK_and_RPM_is_below_KLMRPM
    .byte 0x06                       ;Point 1

	;.org	0x8100
THRKNK_DeltaAbove_MINTHR:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x0361
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaAbove_MINTHR
    ;mptblcname THRKNK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis TPS 0 5 Volts
    ;mptbldesc Delta_above_MINTHR_for_knock_detect
    .byte 0x53                       ;Point 1

	;.org	0x8101
KLMRPM_MinKnockDetectRpm:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x036E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinKnockDetectRpm
    ;mptblcname KLMRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 RPM
    ;mptbldesc RPMS_for_Knock
    .byte 0x20                       ;Point 1

	;.org	0x8102
DLTKNK_KnockFromRpms:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x037B
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname KnockSensorVoltageForKnock_FromRpm
    ;mptblcname DLTKNK
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis A2D 0 5 volts
    ;mptbldesc Input_from_the_knock_sensor_that_is_above_this_voltage_is_considered_Knock.
    .byte 0x05                       ;Number of points in table
    .byte 0x3E, 0x15, 0x00, 0xC0     ;Point 1
    .byte 0x5E, 0x2D, 0x01, 0x50     ;Point 2
    .byte 0x7E, 0x57, 0x02, 0xC0     ;Point 3
    .byte 0x9E, 0xAF, 0x00, 0xE8     ;Point 4
    .byte 0xBE, 0xCC                 ;Point 5

	;.org	0x8119
ARRPM_AdaptiveRetardFromRPM:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x038D
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

	;.org	0x8134
ARMAP_AdaptiveRetardFromMAP:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x039F
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AdaptiveRetardFromMAP
    ;mptblcname ARMAP
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Spark_Retard 0 127.5 Degrees
    ;mptbldesc This_table_is_reduced_by_the_value_in_#002b_(0,_1/4,_1/2,_3/4,_or_1)_depending_on_the_boost_control_routine._And_the_result_is_subtracted_from_the_advance_calculated_by_8010_or_805b
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x59, 0x00, 0x00, 0x80     ;Point 1
    .byte 0x61, 0x04                 ;Point 2

	;.org	0x814f
ARMPIC_AdaptiveRetard_MinMAPForAdjustment:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x03AF
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AdaptiveRetard_MinMAPForAdjustment
    ;mptblcname ARMPIC
    ;mpxaxis IN 0 255 X
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc ff_disables_the_Adaptive_Knock_Retard
    ;mpmapaxis y
    .byte 0x51                       ;Point 1

	;.org	0x8150
ARINDX_AdaptiveRetardIndexBase_80:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x03BD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardIndexBase_80
    ;mptblcname ARINDX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x80                       ;Point 1

	;.org	0x8151
ARSUBC_AdaptiveRetardFactorSubtract:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x03CA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardFactorSubtract
    ;mptblcname ARSUBC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x40                       ;Point 1

	;.org	0x8152
ARCMSK_AdaptiveRetardCounterMask:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x03D7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardCounterMask
    ;mptblcname ARCMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x3F                       ;Point 1

	;.org	0x8153
ARTM5P_AdaptiveRetardTimeOver5psiBoost:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x03E4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardTimeOver5psiBoost
    ;mptblcname ARTM5P
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0C                       ;Point 1

	;.org	0x8154
ARMINT_AdaptiveRetardMinimumTemp:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x03F1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardMinimumTemp
    ;mptblcname ARMINT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 degrees
    ;mptbldesc Detailed_Description
    .byte 0xB1                       ;Point 1

	;.org	0x8155
ARCMS2_AdaptiveRetardCounterMask2_00:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x03FE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardCounterMask2_00
    ;mptblcname ARCMS2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x8156
ARCMS3_AdaptiveRetardCounterMask3_FF:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x040B
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
    ;mptbladdr 0x0417
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

MINADW_MinAntiDwellPeriod:
    ;mpgrp 2_-_Spark\E_-_Dwell_Control\
    ;mptbladdr 0x042D
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname MinAntiDwellPeriod
    ;mptblcname MINADW
    ;mpxaxis in 0 255 out
    ;mpyaxis AntiDwellTime 0 65535 uSec
    ;mptbldesc Minimum_anti-dwell_period._Use_caution_adjusting_this_constant_as_it_is_hardware_dependant.
    .word 0x0190                     ;Point 1

	;.org	0x8157
SSTEMP_TempAboveWhichSparkScatterIsActive:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x043A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TempAboveWhichSparkScatterIsActive
    ;mptblcname SSTEMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Temperature_above_which_spark_scatter_is_active._For_road_racing,_the_MP_cal_has_this_set_to_0xfe._This_keeps_the_revs_higher_during_shifts.
    .byte 0x58                       ;Point 1

	;.org	0x8158
FTUNPW_FineTuneStepForAis:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x0447
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FineTuneStepForAis
    ;mptblcname FTUNPW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Fine_Tune_Step_for_AIS_for_spark_scatter
    .byte 0x01                       ;Point 1

	;.org	0x8159
SSITIM_ScatterInhibitTime:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x0454
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ScatterInhibitTime
    ;mptblcname SSITIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Spark_Scatter_Inhibit_Time_in_11ms_per_bit
    .word 0x0088                     ;Point 1

	;.org	0x815b
SSIPRD_ScatterInhibitBelowThisSpeed:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x0461
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ScatterInhibitBelowThisSpeed
    ;mptblcname SSIPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Spark_Scatter_inhibited_below_this_speed._The_MP_MTX_cal_has_this_value_set_to_0xfe33_to_keep_the_revs_high_during_shifts.
    .word 0x0066                     ;Point 1

	;.org	0x815d
RPMFRT_SparkAdvanceRPMFilterRatio:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x046E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkAdvanceRPMFilterRatio
    ;mptblcname RPMFRT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Factor 0 0.996 factor
    ;mptbldesc Detailed_Description
    .byte 0x7F                       ;Point 1

	;.org	0x815e
RPMFPS_SparkAdvanceRPMFilterLimitPos:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x047B
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname SparkAdvanceRPMFilterLimitPos
    ;mptblcname RPMFPS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Description
    .word 0x0190                     ;Point 1

	;.org	0x8160
RPMFNG_SparkAdvanceRPMFilterLimitNeg:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x0488
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname SparkAdvanceRPMFilterLimitNeg
    ;mptblcname RPMFNG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Description
    .word 0x0190                     ;Point 1

	;.org	0x8162
SPKADD_SparkAdvanceAddedWhenRpmBelowControl_FromDeltaRpm:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x0495
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname SparkAdvanceAddedWhenRpmBelowControl_FromDeltaRpm
    ;mptblcname SPKADD
    ;mpxaxis DeltaRPM 0 512 RPM
    ;mpyaxis Advance 0 127.5 degrees
    ;mptbldesc This_is_how_much_advance_is_added_to_increase_engine_speed.
    .byte 0x02                       ;Number of points in table
    .byte 0x00, 0x00, 0x00, 0xCD     ;Point 1
    .byte 0x14, 0x10                 ;Point 2

	;.org	0x816d
SPKAD2_SparkAdvanceAddedWhenRpmBelowControl2_FromDeltaRpm:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x04A4
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname SparkAdvanceAddedWhenRpmBelowControl2_FromDeltaRpm
    ;mptblcname SPKAD2
    ;mpxaxis DeltaRPM 0 512 RPM
    ;mpyaxis Advance 0 127.5 degrees
    ;mptbldesc This_is_how_much_advance_is_added_to_increase_engine_speed.
    .byte 0x02                       ;Number of points in table
    .byte 0x00, 0x00, 0x00, 0xCD     ;Point 1
    .byte 0x14, 0x10                 ;Point 2

	;.org	0x8178
SPKRET_SparkAdvanceRetardedWhenRpmAboveControl_FromDeltaRpm:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x04B3
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname SparkAdvanceRetardedWhenRpmAboveControl_FromDeltaRpm
    ;mptblcname SPKRET
    ;mpxaxis DeltaRPM 0 512 rpm
    ;mpyaxis Advance 0 127.5 degrees
    ;mptbldesc This_is_how_much_advance_is_removed_to_decrease_engine_speed
    .byte 0x03                       ;Number of points in table
    .byte 0x0A, 0x00, 0xFF, 0x9A     ;Point 1
    .byte 0x1E, 0xF8, 0xFF, 0xD0     ;Point 2
    .byte 0x64, 0xEB                 ;Point 3

	;.org	0x8183
SPKRT2_SparkAdvanceRetardedWhenRpmAboveControl2_FromDeltaRpm:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x04C3
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname SparkAdvanceRetardedWhenRpmAboveControl2_FromDeltaRpm
    ;mptblcname SPKRT2
    ;mpxaxis DeltaRPM 0 512 rpm
    ;mpyaxis Advance 0 127.5 degrees
    ;mptbldesc This_is_how_much_advance_is_removed_to_decrease_engine_speed
    .byte 0x03                       ;Number of points in table
    .byte 0x0A, 0x00, 0xFF, 0x9A     ;Point 1
    .byte 0x1E, 0xF8, 0xFF, 0xD0     ;Point 2
    .byte 0x64, 0xEB                 ;Point 3

	;.org	0x818e
IDLADD_FuelStabilization_FromDeltaRPM:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x04D3
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStabilization_FromDeltaRPM
    ;mptblcname IDLADD
    ;mpxaxis DeltaRPM 0 512 rpm
    ;mpyaxis Pulsewidth 0 1020 uSec
    ;mptbldesc This_is_how_much_fuel_is_added_or_subtracted_to_increase_or_decrease_speed
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x03, 0x00, 0x02, 0x51     ;Point 1
    .byte 0x16, 0x2C, 0x00, 0xAE     ;Point 2
    .byte 0x4B, 0x50                 ;Point 3

	;.org	0x8199
IDLTMP_Use_IDLADD_AboveThisTemp:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x04E4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Use_IDLADD_AboveThisTemp
    ;mptblcname IDLTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 degF
    ;mptbldesc IDLADD_enabled_when_engine_temp_is_above_IDLTMP
    .byte 0x6E                       ;Point 1

	;.org	0x819a
STRNTR_SparkStartRunTransferPointRpm:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x04F1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkStartRunTransferPointRpm
    ;mptblcname STRNTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DistPW 0 255 count
    ;mptbldesc Start_to_Run_transfer_point._Approx_RPM_=_30,000/count
    .byte 0x62                       ;Point 1

	;.org	0x819b
RNSTTR_SparkRunStartTransferPointRpm:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x04FE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkRunStartTransferPointRpm
    ;mptblcname RNSTTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DistPW 0 255 count
    ;mptbldesc Run_to_Start_transfer_point._Approx_RPM_=_30,000/count
    .byte 0x8E                       ;Point 1

	;.org	0x819c
SKAPRD_SparkImmediateSwitchToRunAboveThisRpm:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x050B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkImmediateSwitchToRunAboveThisRpm
    ;mptblcname SKAPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Immediate_switch_to_Spark_RUN_mode_when_above_this_RPM
    .byte 0x48                       ;Point 1

	;.org	0x819d
SRTIME_SparkEPPsNeededToBeAboveSR_Hot:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x0518
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkEPPsNeededToBeAboveSR_Hot
    ;mptblcname SRTIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_consecutive_EPPs_needed_to_be_above_Start_Run_when_hot
    .byte 0x04                       ;Point 1

	;.org	0x819e
SRTIME2_SparkEPPsNeededToBeAboveSR_Cold:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x0525
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkEPPsNeededToBeAboveSR_Cold
    ;mptblcname SRTIME2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_consecutive_EPPs_needed_to_be_above_Start_Run_when_cold
    .byte 0x04                       ;Point 1

	;.org	0x819f
SRTMTP_SparkTempSwitchPointFor_SRTIME:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x0532
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkTempSwitchPointFor_SRTIME
    ;mptblcname SRTMTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Engine_Temperature_switch_point_for_SRTIME
    .byte 0xB0                       ;Point 1

	;.org	0x81a0
CSFERT_MinTempForColdStartFuelEnrichment:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x053F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinTempForColdStartFuelEnrichment
    ;mptblcname CSFERT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis CoolantTemp -200 260 DegF
    ;mptbldesc Min_Engine_Temperature_for_cold_start_enrichment
    .byte 0x58                       ;Point 1

	;.org	0x81a1
RNFPRD_FuelStartRunTransferPointRpm:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x054C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FuelStartRunTransferPointRpm
    ;mptblcname RNFPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DistPW 0 255 count
    ;mptbldesc Start_to_Run_transfer_point_for_fuel._Approx_RPM_=_30,000/count
    .byte 0x60                       ;Point 1

	;.org	0x81a2
STFPRD_FuelRunStartTransferPointRpm:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x0559
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FuelRunStartTransferPointRpm
    ;mptblcname STFPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DistPW 0 255 Count
    ;mptbldesc Run_to_Start_transfer_point_for_spark._Approx_RPM_=_30,000/count
    .byte 0x82                       ;Point 1

	;.org	0x81a3
CSFERX_NumLoopsForColdStartFuelEnrich:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x0566
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NumLoopsForColdStartFuelEnrich
    ;mptblcname CSFERX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Count 0 255 cnt
    ;mptbldesc Num_Loops_for_cold_start_reduction
    .byte 0x04                       ;Point 1

	;.org	0x81a4
PCCSFE_PercentForColdStartFuelEnrichment:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x0573
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname PercentForColdStartFuelEnrichment
    ;mptblcname PCCSFE
    ;mpxaxis Coolant_Temp -200 260 Degrees
    ;mpyaxis Factor 0 0.996 factor
    ;mptbldesc Description
    .byte 0x03                       ;Number of points in table
    .byte 0x16, 0x01, 0x4C, 0x80     ;Point 1
    .byte 0x18, 0x9A, 0x00, 0xA4     ;Point 2
    .byte 0x3F, 0xB3                 ;Point 3

	;.org	0x81b3
STRTFL_FuelStartFromCoolantTemp:
    ;mpgrp 1_-_Fuel\A_-_Starting\
    ;mptbladdr 0x0583
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname StartFuel_FromTemp
    ;mptblcname STRTFL
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis sqrtPW 0 222 uSec
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4
    ;mpinjscale sqrt
    .byte 0x09                       ;Number of points in table
    .byte 0x58, 0x4B, 0x00, 0x00     ;Point 1
    .byte 0x63, 0x4B, 0xFF, 0xBA     ;Point 2
    .byte 0x6E, 0x48, 0xFE, 0xE9     ;Point 3
    .byte 0x79, 0x3C, 0xFF, 0x5D     ;Point 4
    .byte 0x84, 0x35, 0xFF, 0x2B     ;Point 5
    .byte 0x90, 0x2B, 0xFF, 0x46     ;Point 6
    .byte 0x9B, 0x23, 0xFF, 0x80     ;Point 7
    .byte 0xB1, 0x18, 0xFF, 0xAB     ;Point 8
    .byte 0xCC, 0x0F                 ;Point 9

	;.org	0x81da
STRLMT_ColdestTempAllowedAtClosedThrottle:
    ;mpgrp 1_-_Fuel\A_-_Starting\
    ;mptbladdr 0x059A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ColdestTempAllowedAtClosedThrottle
    ;mptblcname STRLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Coldest_temperature_accepted_as_input_to_STRTFL_table_-_anything_below_this_value_will_be_replaced_with_this_value
    .byte 0x69                       ;Point 1

	;.org	0x81db
STFTMP_FuelStartFuelFromCoolant:
    ;mpgrp 1_-_Fuel\A_-_Starting\
    ;mptbladdr 0x05A7
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartFuelFromCoolant
    ;mptblcname STFTMP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Inverse 0 0.996 factor
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4
    .byte 0x02                       ;Number of points in table
    .byte 0x63, 0xFF, 0xEB, 0x2F     ;Point 1
    .byte 0x6E, 0x1A                 ;Point 2

	;.org	0x81ea
EPPMUL_FuelStartFuelPerEPP:
    ;mpgrp 1_-_Fuel\A_-_Starting\
    ;mptbladdr 0x05B6
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartFuelPerEPP
    ;mptblcname EPPMUL
    ;mpxaxis EPPs 0 255 count
    ;mpyaxis Factor 0 0.996 factor
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4._This_table_decreases_fuel_for_each_engine_rotation_while_starting
    .byte 0x02                       ;Number of points in table
    .byte 0x0F, 0x00, 0x0B, 0x11     ;Point 1
    .byte 0x1E, 0xA6                 ;Point 2

	;.org	0x81f5
STFTM2_FuelStartFuelFromCoolant2:
    ;mpgrp 1_-_Fuel\A_-_Starting\
    ;mptbladdr 0x05C5
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartFuelFromCoolant2
    ;mptblcname STFTM2
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Inverse 0 0.996 factor
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4
    .byte 0x02                       ;Number of points in table
    .byte 0x6E, 0xFF, 0xFB, 0x74     ;Point 1
    .byte 0x79, 0xCD                 ;Point 2

	;.org	0x81fc
STFBAR_FuelStartReductionFromBaro:
    ;mpgrp 1_-_Fuel\A_-_Starting\
    ;mptbladdr 0x05D4
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FuelStartReductionFromBaro
    ;mptblcname STFBAR
    ;mpxaxis Baro -14.7 29.4 psi
    ;mpyaxis Inverse 0 0.996 factor
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4._This_decreases_fuel_slightly_at_higher_altitudes_to_account_for_thinner_air.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x3B, 0xA1, 0xF8, 0xAF     ;Point 1
    .byte 0x51, 0x00                 ;Point 2

	;.org	0x8207
SFDCAY_FuelStartDecayIntoRun:
    ;mpgrp 1_-_Fuel\A_-_Starting\
    ;mptbladdr 0x05E4
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

	;.org	0x8216
PRSHOT_KeyOnPrimePW:
    ;mpgrp 1_-_Fuel\A_-_Starting\
    ;mptbladdr 0x05F5
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname KeyOnPrimePW
    ;mptblcname PRSHOT
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Pulsewidth 0 255 mSec
    ;mptbldesc Prime_Fuel_Shot_before_cranking
    ;mpinjscale scale
    .byte 0x04                       ;Number of points in table
    .byte 0x6E, 0x28, 0xFE, 0xBA     ;Point 1
    .byte 0x84, 0x0C, 0xFF, 0xEA     ;Point 2
    .byte 0x9B, 0x0A, 0xFF, 0xE1     ;Point 3
    .byte 0xDD, 0x02                 ;Point 4

	;.org	0x8225
MAPIDL_FuelBaselineFromMap:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x0607
    ;mptbltype 1
    ;mpsubtype 1
    ;mptbllname FuelBaselineFromMap
    ;mptblcname MAPIDL
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Pulsewidth 0 65535 uSec
    ;mptbldesc Base_Map_Fuel_Pulsewidth.
    ;mpmapaxis x
    ;mpinjscale scale
    .byte 0x00                   ;Point 1
    .word 0x0000, 0x1100
    .byte 0x0B                   ;Point 2
    .word 0x00BB, 0x0000
    .byte 0x11                   ;Point 3
    .word 0x00BB, 0x0E40
    .byte 0x21                   ;Point 4
    .word 0x019F, 0x1692
    .byte 0x28                   ;Point 5
    .word 0x023D, 0x2500
    .byte 0x2D                   ;Point 6
    .word 0x02F6, 0x0EAB
    .byte 0x60                   ;Point 7
    .word 0x05E2, 0x174F
    .byte 0x7D                   ;Point 8
    .word 0x0886, 0x1FB1
    .byte 0xFF

	;.org	0x8253
MAPTBL_FuelPartThrottle:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x0626
    ;mptbltype 1
    ;mpsubtype 1
    ;mptbllname FuelPartThrottle
    ;mptblcname MAPTBL
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Pulsewidth 0 65535 uSec
    ;mptbldesc Fuel_at_Part_Throttle._Other_tweaks_will_be_added_to_this_amount,_to_a_MAXIMUM_of_the_Full_Throttle_table_value.
    ;mpmapaxis x
    ;mpinjscale scale
    .byte 0x09                   ;Point 1
    .word 0x0000, 0x14B7
    .byte 0x10                   ;Point 2
    .word 0x0091, 0x1900
    .byte 0x11                   ;Point 3
    .word 0x00AA, 0x1178
    .byte 0x22                   ;Point 4
    .word 0x01D3, 0x0F74
    .byte 0x2D                   ;Point 5
    .word 0x027D, 0x100B
    .byte 0x44                   ;Point 6
    .word 0x03EE, 0x1014
    .byte 0x51                   ;Point 7
    .word 0x04BF, 0x1366
    .byte 0x60                   ;Point 8
    .word 0x05E2, 0x174F
    .byte 0x7D                   ;Point 9
    .word 0x0886, 0x1FB1
    .byte 0xFF

	;.org	0x828b
WOTTBL_FuelFullThrottle:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x0647
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
    .word 0x0000, 0x1400
    .byte 0x50                   ;Point 2
    .word 0x0640, 0x2080
    .byte 0x64                   ;Point 3
    .word 0x08CA, 0x1800
    .byte 0xC8                   ;Point 4
    .word 0x122A, 0x1EE9
    .byte 0xFF

	;.org	0x82aa
BATOFF_FuelBatteryOffset:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x065E
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelBatteryOffset
    ;mptblcname BATOFF
    ;mpxaxis Battery 0 16.2 Volts
    ;mpyaxis Pulsewidth 0 4095.94 uSec
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

	;.org	0x82bd
CURVEA_FuelColdEnrichmentCurveA:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x067C
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelColdEnrichmentCurveA
    ;mptblcname CURVEA
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis factor 1 1.996 factor
    ;mptbldesc Coldenrichment_factor_=_1_+_(_(CurveA_*_ADVDCY/256_+_CurveC_*_ADVDCY/256_+_CurveB_*_FCRCVB/256_)_/_32_)_*_BAROCP/256
    .byte 0x07                       ;Number of points in table
    .byte 0x58, 0x6D, 0xFE, 0x8C     ;Point 1
    .byte 0x6E, 0x4D, 0xFE, 0xD5     ;Point 2
    .byte 0x74, 0x46, 0xFF, 0xE0     ;Point 3
    .byte 0x84, 0x44, 0xFD, 0x6E     ;Point 4
    .byte 0x92, 0x20, 0x00, 0x00     ;Point 5
    .byte 0xA6, 0x20, 0xFF, 0xC9     ;Point 6
    .byte 0xE3, 0x13                 ;Point 7

	;.org	0x82e0
CURVEB_FuelColdEnrichmentCurveB:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x0690
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelColdEnrichmentCurveB
    ;mptblcname CURVEB
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 1.992 factor
    ;mptbldesc Coldenrichment_factor_=_1_+_(_(CurveA_*_ADVDCY/256_+_CurveC_*_ADVDCY/256_+_CurveB_*_FCRCVB/256_)_/_32_)_*_BAROCP/256
    .byte 0x08                       ;Number of points in table
    .byte 0x58, 0x6F, 0xFE, 0x37     ;Point 1
    .byte 0x74, 0x3D, 0xFE, 0xD5     ;Point 2
    .byte 0x92, 0x1A, 0xFF, 0xD3     ;Point 3
    .byte 0xA3, 0x17, 0xFF, 0x84     ;Point 4
    .byte 0xC4, 0x07, 0xFF, 0x5D     ;Point 5
    .byte 0xCF, 0x00, 0x00, 0x00     ;Point 6
    .byte 0xEE, 0x00, 0x00, 0xE9     ;Point 7
    .byte 0xF9, 0x0A                 ;Point 8

	;.org	0x8303
CURVEC_FuelColdEnrichmentCurveC:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x06A5
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelColdEnrichmentCurveC
    ;mptblcname CURVEC
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 1 2.992 factor
    ;mptbldesc Coldenrichment_factor_=_1_+_(_(CurveA_*_ADVDCY/256_+_CurveC_*_ADVDCY/256_+_CurveB_*_FCRCVB/256_)_/_32_)_*_BAROCP/256
    .byte 0x06                       ;Number of points in table
    .byte 0x79, 0x3A, 0xFF, 0x74     ;Point 1
    .byte 0x84, 0x34, 0xFF, 0x92     ;Point 2
    .byte 0x92, 0x2E, 0xFF, 0x4F     ;Point 3
    .byte 0xBC, 0x11, 0xFF, 0xE9     ;Point 4
    .byte 0xE9, 0x0D, 0x05, 0x66     ;Point 5
    .byte 0xEE, 0x28                 ;Point 6

	;.org	0x831a
FCRCVB_FuelWOTScaleEnrichBFromRpm:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x06B8
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelWOTScaleEnrichBFromRpm
    ;mptblcname FCRCVB
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis factor 0 0.996 factor
    ;mptbldesc B_Curve_Multiplier_is_used_at_Full_Throttle_only
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x33                 ;Point 1

	;.org	0x832d
TMPHLD_TempSwitchPointForCurveAHoldDecay:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x06C6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TempSwitchPointForCurveAHoldDecay
    ;mptblcname TMPHLD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Temperature_switch_point_for_Curve_A_Hold_and_Decay_times
    .byte 0x92                       ;Point 1

	;.org	0x832e
CLDHLD_CurveAColdHoldTime:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x06D3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAColdHoldTime
    ;mptblcname CLDHLD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 180 out
    ;mptbldesc Curve_A_Cold_Hold_time_-_value_=_this_number_times_.704_sec
    .byte 0x1D                       ;Point 1

	;.org	0x832f
HOTHLD_CurveAHotHoldTime:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x06E0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAHotHoldTime
    ;mptblcname HOTHLD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Curve_A_Hot_Hold_Time_-_value_=_this_number_times_.704_sec
    .byte 0x0F                       ;Point 1

	;.org	0x8330
DCYTMC_CurveAColdDecayTime:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x06ED
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAColdDecayTime
    ;mptblcname DCYTMC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Curve_A_Cold_Decay_Time_-_value_=_89.76_divided_by_this_number
    .byte 0x04                       ;Point 1

	;.org	0x8331
DCYTMH_CurveAHotDecayTime:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x06FA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAHotDecayTime
    ;mptblcname DCYTMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Curve_A_Hot_Decay_Time_-_value_=_89.76_divided_by_this_number
    .byte 0x09                       ;Point 1

	;.org	0x8332
CCURV_HoldTimeForCurveC:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x0707
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HoldTimeForCurveC
    ;mptblcname CCURV
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 180 out
    ;mptbldesc Hold_Time_for_Curve_C_-_value_=_this_number_times_.704_sec
    .byte 0x07                       ;Point 1

	;.org	0x8333
DCYCC_DecayRateForCurveC:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x0714
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

	;.org	0x8334
HIGHMP_ColdLoadFromCoolantTemp:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x072F
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ColdLoadFromCoolantTemp
    ;mptblcname HIGHMP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis enrichment 0 99.6 percent
    ;mptbldesc Cold_Load_Enrichment_Factor
    .byte 0x05                       ;Number of points in table
    .byte 0x8D, 0xA5, 0xFA, 0xF6     ;Point 1
    .byte 0xA6, 0x27, 0xFF, 0x00     ;Point 2
    .byte 0xCD, 0x00, 0x00, 0x00     ;Point 3
    .byte 0xE9, 0x00, 0x1B, 0x33     ;Point 4
    .byte 0xEE, 0x88                 ;Point 5

	;.org	0x834f
HMPMUL_ColdLoadFromMAP:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x0741
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname ColdLoadFromMAP
    ;mptblcname HMPMUL
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Factor 0 99.6 percent
    ;mptbldesc Cold_Load_Enrichment_Multiplier
    ;mpmapaxis x
    .byte 0x04                       ;Number of points in table
    .byte 0x18, 0x00, 0x01, 0x00     ;Point 1
    .byte 0x1E, 0x06, 0x00, 0x1C     ;Point 2
    .byte 0x39, 0x09, 0x00, 0x26     ;Point 3
    .byte 0x5B, 0x0E                 ;Point 4

	;.org	0x8366
HIGHM2_ColdLoadFromCoolantTemp2:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x0753
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ColdLoadFromCoolantTemp2
    ;mptblcname HIGHM2
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis enrichment 0 99.6 percent
    ;mptbldesc Cold_Load_Enrichment_Factor
    .byte 0x02                       ;Number of points in table
    .byte 0xAB, 0x22, 0xFE, 0xC9     ;Point 1
    .byte 0xC7, 0x00                 ;Point 2

	;.org	0x8379
HMPMU2_ColdLoadFromMAP2:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x0762
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname ColdLoadFromMAP2
    ;mptblcname HMPMU2
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Factor 0 99.6 percent
    ;mptbldesc Cold_Load_Enrichment_Multiplier
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x42, 0x00, 0x01, 0x4F     ;Point 1
    .byte 0x4F, 0x11                 ;Point 2

	;.org	0x8390
BAROCP_BaroCompensationOfWarmupFactor_FromBaro:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x0772
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BaroCompensationOfWarmupFactor_FromBaro
    ;mptblcname BAROCP
    ;mpxaxis Baro -14.7 29.4 psi
    ;mpyaxis Factor 0 99.6 percent
    ;mptbldesc Baro_compensation_of_Warmup_Factor
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x39, 0x9A, 0xFE, 0xD1     ;Point 1
    .byte 0x4F, 0x80                 ;Point 2

	;.org	0x839b
RUNTMP_ModifierOf_ENGTMP_FromStalltime:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x0782
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

	;.org	0x83a6
RUNLMT_MaxAllowableTempFor_RUNTMP:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x0792
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxAllowableTempFor_RUNTMP
    ;mptblcname RUNLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Max_allowable_temp_for_RUNTMP_(heat_soak_approximation)
    .byte 0xA3                       ;Point 1

	;.org	0x83a7
PEFTBL_PumpingEfficiency:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x079F
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname PumpingEfficiency_FromRpm
    ;mptblcname PEFTBL
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis PumpEff 0 99.6 percent
    ;mptbldesc Pumping_Efficiency
    .byte 0x08                       ;Number of points in table
    .byte 0x10, 0xFF, 0xFC, 0x5D     ;Point 1
    .byte 0x1B, 0xD7, 0x00, 0x00     ;Point 2
    .byte 0x3F, 0xD7, 0x00, 0x53     ;Point 3
    .byte 0x64, 0xE3, 0x00, 0x33     ;Point 4
    .byte 0x7D, 0xE8, 0x00, 0x12     ;Point 5
    .byte 0x8B, 0xE9, 0xFF, 0xCD     ;Point 6
    .byte 0x9F, 0xE5, 0xFF, 0x00     ;Point 7
    .byte 0xDC, 0xA8                 ;Point 8

	;.org	0x83ce
AIRTMP_FuelEnrichmentFromChargeTemp:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x07B4
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelEnrichmentFromChargeTemp
    ;mptblcname AIRTMP
    ;mpxaxis Charge_Temp 0 5 volts
    ;mpyaxis factor 1 1.996 factor
    ;mptbldesc Charge_Temp_Factor._Note_that_this_is_an_unfiltered_charge_temp_voltage,_so_higher_numbers_are_lower_temps
    .byte 0x04                       ;Number of points in table
    .byte 0x58, 0x40, 0xFF, 0x66     ;Point 1
    .byte 0xA1, 0x14, 0xFF, 0x86     ;Point 2
    .byte 0xB6, 0x0A, 0xFF, 0xCB     ;Point 3
    .byte 0xE6, 0x00                 ;Point 4

	;.org	0x83dd
PWADD_FuelPWModifierFromBaro:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x07C5
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FuelPWModifierFromBaro
    ;mptblcname PWADD
    ;mpxaxis Baro -14.7 29.4 psi
    ;mpyaxis Pulsewidth 0 12288 uSec
    ;mptbldesc Additive_Baro_Fuel_Compensation_-_fuel_added_based_on_altitude
    ;mpmapaxis x
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x39, 0x07, 0xFF, 0xB7     ;Point 1
    .byte 0x47, 0x03, 0xFF, 0xC9     ;Point 2
    .byte 0x55, 0x00                 ;Point 3

	;.org	0x83ec
POSTRG_PositiveTransientTriggerLevel:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0x07D7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PositiveTransientTriggerLevel
    ;mptblcname POSTRG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Positive_Transient_Enrich_Trigger_Level_in_volts_times_0.02
    .byte 0x03                       ;Point 1

	;.org	0x83ed
THRMAX_MaxDeltaTHR:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0x07E4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxDeltaTHR
    ;mptblcname THRMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Max_Delta_THR_(THR-AVTHR-POSTRG)_-_value_of_$26_is_.51_volts
    .byte 0x26                       ;Point 1

	;.org	0x83ee
POSSLP_DeltaTPSEnrichment_FromTemp:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0x07F1
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname Enrichment_FromTemp
    ;mptblcname POSSLP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis pw 0 60 ms/volt
    ;mptbldesc Throttle_Transient_Enrich_PW_Addition
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x74, 0x20, 0xFF, 0x37     ;Point 1
    .byte 0x90, 0x0A, 0xFF, 0xC2     ;Point 2
    .byte 0xB1, 0x02                 ;Point 3

	;.org	0x83fd
MAPTRG_DeltaMapTriggerLevel:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x0802
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapTriggerLevel
    ;mptblcname MAPTRG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 44.1 psi
    ;mptbldesc MAP_Delta_required_to_trigger_transient_enrichment
    ;mpmapaxis y
    .byte 0x05                       ;Point 1

	;.org	0x83fe
MAPMAX_MaxDeltaMapAllowed:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x0810
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MaxDeltaMapAllowed
    ;mptblcname MAPMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 44.1 psi
    ;mptbldesc Maximum_Delta_MAP_allowed
    ;mpmapaxis y
    .byte 0xAA                       ;Point 1

	;.org	0x83ff
AESLOP_DeltaMAPEnrichmentPT:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x081E
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
    .byte 0x6E, 0x42, 0xFE, 0x8C     ;Point 1
    .byte 0x79, 0x32, 0xFF, 0x80     ;Point 2
    .byte 0x95, 0x24, 0xFF, 0x65     ;Point 3
    .byte 0xCD, 0x02                 ;Point 4

	;.org	0x840e
OCTAE_FakeDeltaMapIncrease:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x0831
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname FakeDeltaMapIncrease
    ;mptblcname OCTAE
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc Fake_Delta_Map_Increase._AVMAP_is_set_to_(MAP-OCTAE)_any_time_throttle_is_just_opened.
    ;mpmapaxis y
    .byte 0x00                       ;Point 1

	;.org	0x840f
LOTTHR_DecelLeanoutFactor_FromTemp:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_TPS_LO\
    ;mptbladdr 0x083F
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelLeanoutFactor_FromTemp
    ;mptblcname LOTTHR
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 0.996 factor
    ;mptbldesc Decel_leanout_factor_-_THR_based._When_Y_is_zero,_factor_is_1.00
    .byte 0x02                       ;Number of points in table
    .byte 0xB1, 0x00, 0xF9, 0x9A     ;Point 1
    .byte 0xB6, 0xE0                 ;Point 2

	;.org	0x841e
LOTTRG_DeltaTriggerForDecelLeanout:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_TPS_LO\
    ;mptbladdr 0x084E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaTriggerForDecelLeanout
    ;mptblcname LOTTRG
    ;mpxaxis in_desc -200 260 degrees
    ;mpyaxis Factor 0 0.996 percent
    ;mptbldesc Main_trigger_(Delta_trigger_level_for_THR_leanout)_-_Delta_THR
    .byte 0x0B                       ;Point 1

	;.org	0x841f
LOTRG2_SecondDecelLeanoutTrigger:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_TPS_LO\
    ;mptbladdr 0x085B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SecondDecelLeanoutTrigger
    ;mptblcname LOTRG2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Second_trigger_-_leanout_inc_toward_1_when_between_triggers
    .byte 0x0B                       ;Point 1

	;.org	0x8420
LOTHYS_LeanoutDeltaThrottleHysteresis:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_TPS_LO\
    ;mptbladdr 0x0868
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LeanoutDeltaThrottleHysteresis
    ;mptblcname LOTHYS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc hysteresis_about_delta_THR_trigger_levels
    .byte 0x01                       ;Point 1

	;.org	0x8421
DECEL_DecelLeanoutFactorMAP:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x0875
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelLeanoutFactorMAP_FromTemp
    ;mptblcname DECEL
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 0.996 factor
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0xB1, 0x00, 0xF8, 0x66     ;Point 1
    .byte 0xB6, 0xDA                 ;Point 2

	;.org	0x8430
DECTRG_DeltaMapTriggerForNoIncrementalLeanout:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x0884
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapTriggerForNoIncrementalLeanout
    ;mptblcname DECTRG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc delta_map_trigger_level_for_no_incremental_leanout
    ;mpmapaxis y
    .byte 0x0D                       ;Point 1

	;.org	0x8431
DTRG2_DeltaMapTriggerForMaxLeanout:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x0892
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapTriggerForMaxLeanout
    ;mptblcname DTRG2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc delta_map_trigger_level_for_max_leanout_on_decel
    ;mpmapaxis y
    .byte 0x0D                       ;Point 1

	;.org	0x8432
DECHYS_DeltaMapHysteresisonTriggerLevels:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x08A0
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapHysteresisonTriggerLevels
    ;mptblcname DECHYS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc delta_map_hysteresis_on_trigger_levels
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

	;.org	0x8433
DLTRPM2_RPMDeltaForRPMFilter:
    ;mpgrp 0_-_Setup\D_-_Transfer_Functions\
    ;mptbladdr 0x08AE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMDeltaForRPMFilter
    ;mptblcname DLTRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Delta_RPM_at_RPM_Boundaries
    .byte 0xFF                       ;Point 1

	;.org	0x8434
LOTRPM_MinRpmForMapLeanout:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x08BB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinRpmForMapLeanout
    ;mptblcname LOTRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc No_map_leanout_if_below_this_RPM
    .byte 0x35                       ;Point 1

	;.org	0x8435
DCELTM_O2CNTRInhibitAfterLeanoutDone:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x08C8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2CNTRInhibitAfterLeanoutDone
    ;mptblcname DCELTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2CNTR_inhibit_after_MAP/THR_leanout_is_done_(times_11_ms)
    .byte 0x01                       ;Point 1

	;.org	0x8436
POSTIG_MinAisPulseRequireToTriggerEnrichment:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\AIS_PumpShot\
    ;mptbladdr 0x08D5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinAisPulseRequireToTriggerEnrichment
    ;mptblcname POSTIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Min_AIS_pulse_required_to_trigger_enrichment_(steps)
    .byte 0x09                       ;Point 1

	;.org	0x8437
POSFUL_AisEnrichmentFuelPulse:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\AIS_PumpShot\
    ;mptbladdr 0x08E2
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname AisEnrichmentFuelPulse
    ;mptblcname POSFUL
    ;mpxaxis in_desc 0 65535 scale
    ;mpyaxis AISPW 0 65535 uSec
    ;mptbldesc AIS_enrichment_fuel_pulse_in_uSec
    ;mpinjscale word
    .word 0x006B                     ;Point 1

	;.org	0x8439
MINPTE_MinPWForPartThorttleEnrich:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x08F0
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname MinPWForPartThorttleEnrich
    ;mptblcname MINPTE
    ;mpxaxis X 0 255 scale
    ;mpyaxis Y 0 255 out
    ;mptbldesc MinPWForPartThorttleEnrich
    ;mpinjscale word
    .word 0x0002                     ;Point 1

	;.org	0x843b
AETIME_EnrichmentTime_FromTemp:
; this is actually one of the 2 MAP averaging factor tables
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x08FF
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname EnrichmentTime_FromTemp_MAP
    ;mptblcname AETIME
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 0.996 factor
    ;mptbldesc MAP_Transient_Enrich_Time_Constant_when_MAP_gt_AVMAP
    .byte 0x03                       ;Number of points in table
    .byte 0x84, 0x14, 0xFF, 0x6B     ;Point 1
    .byte 0x90, 0x0D, 0x00, 0x29     ;Point 2
    .byte 0xBC, 0x14                 ;Point 3

	;.org	0x8446
LMAPTC_TimeConstant:
; this is actually one of the 2 MAP averaging factor tables
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x0910
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TimeConstant
    ;mptblcname LMAPTC
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 0.996 factor
    ;mptbldesc lean_out_time_constant_based_on_MAP
    .byte 0x02                       ;Number of points in table
    .byte 0xBC, 0xE6, 0xF4, 0xB7     ;Point 1
    .byte 0xCA, 0x48                 ;Point 2

	;.org	0x844d
THRTCN_EnrichmentTime_FromTemp:
; this is actually one of the 2 TPS averaging factor tables
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0x0920
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

	;.org	0x8458
LOTIME_DecelLeanoutTimeConstant_FromTemp:
; this is actually one of the 2 TPS averaging factor tables
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_TPS_LO\
    ;mptbladdr 0x0930
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelLeanoutTimeConstant_FromTemp
    ;mptblcname LOTIME
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 0.996 factor
    ;mptbldesc Leanout_Time_Constant_based_on_Delta_THR_-_uses_average_throttle
    .byte 0x02                       ;Number of points in table
    .byte 0xB1, 0xE6, 0xFB, 0x00     ;Point 1
    .byte 0xCD, 0x5A                 ;Point 2

	;.org	0x845f
RPMMAP_SwitchPointForDownUp_FromRpm :
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x093F
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname SwitchPointForDownUp_FromRpm
    ;mptblcname RPMMAP
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc EPP_Control_toggle
    ;mpmapaxis y
    .byte 0x04                       ;Number of points in table
    .byte 0x3F, 0x6F, 0xFF, 0xA4     ;Point 1
    .byte 0x71, 0x5D, 0xFE, 0xCD     ;Point 2
    .byte 0x8A, 0x3F, 0xFF, 0xBB     ;Point 3
    .byte 0xAF, 0x35                 ;Point 4

	;.org	0x8476
PTELMT_MultiplierMaxLimitFromRpm:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0951
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname MultiplierMaxLimitFromRpm
    ;mptblcname PTELMT
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Factor 0 0.996 percent
    ;mptbldesc PTE_Multiplier_limit
    .byte 0x05                       ;Number of points in table
    .byte 0x3F, 0x2D, 0x00, 0x32     ;Point 1
    .byte 0x5E, 0x33, 0x01, 0x2F     ;Point 2
    .byte 0x74, 0x4D, 0x00, 0x00     ;Point 3
    .byte 0x8A, 0x4D, 0x00, 0x8A     ;Point 4
    .byte 0xAF, 0x61                 ;Point 5

	;.org	0x848d
PTEADJ_EnrichAdjust_FromMap:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0963
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname EnrichAdjust_FromMap
    ;mptblcname PTEADJ
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Factor 0.5 1.496 factor
    ;mptbldesc Part_Throttle_Enrichment_-_multiplier_from_MAP_-_NOTE:_zero_is_1.00
    ;mpmapaxis x
    .byte 0x04                       ;Number of points in table
    .byte 0x4A, 0xB3, 0x02, 0x0D     ;Point 1
    .byte 0x5E, 0xDC, 0x00, 0x00     ;Point 2
    .byte 0x66, 0xDC, 0xFE, 0xD2     ;Point 3
    .byte 0x8D, 0xAE                 ;Point 4

	;.org	0x84a8
PTENR_EppPerAmountForIncreasing:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0975
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname EppPerAmountForIncreasing
    ;mptblcname PTENR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EPP_per_amount_for_increasing_multiplier
    .word 0x3D01                     ;Point 1

	;.org	0x84aa
PTENR2_EppPerAmountForDecreasingMultiplier:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0982
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EppPerAmountForDecreasingMultiplier
    ;mptblcname PTENR2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EPP_per_amount_for_decreasing_multiplier
    .byte 0x2D                       ;Point 1

	;.org	0x84ab
PTENRD_AmountForDecreasingMultiplier_Negative:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x098F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AmountForDecreasingMultiplier_Negative
    ;mptblcname PTENRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Amount_for_decreasing_multiplier_(neg_number)
    .byte 0xFF                       ;Point 1

	;.org	0x84ac
PTENUM_NumberToReturnToHOTMAP:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x099C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NumberToReturnToHOTMAP
    ;mptblcname PTENUM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc No_of_PTENRD_below_PTELMT_that_PT_enrich_must_be_to_return_to_HOTMAP_spark_advance_after_maxed_out
    .byte 0x02                       ;Point 1

	;.org	0x84ad
BOOSTP_AdjustO2ResponseForPTEWhenMapAboveThis:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x09A9
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AdjustO2ResponseForPTEWhenMapAboveThis
    ;mptblcname BOOSTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 44.1 psi
    ;mptbldesc Zero_percent_limit_on_lean_O2CNTR_if_MAP_gt_BOOSTP_and_no_PTE
    ;mpmapaxis y
    .byte 0xAA                       ;Point 1

	;.org	0x84ae
O2ITIM_TimeO2InhibitedSwitchingRichIdleToClosedLoop:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x09B7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeO2InhibitedSwitchingRichIdleToClosedLoop
    ;mptblcname O2ITIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2_is_inhibited_for_this_time_when_switching_from_rich_idle_to_closed_loop_idle
    .byte 0xFF                       ;Point 1

	;.org	0x84af
RICHSA_OpenLoopEnrichFactorWhenSettingBasicTiming:
    ;mpgrp 5_-_Idle\C_-_Special_setup\
    ;mptbladdr 0x09C4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OpenLoopEnrichFactorWhenSettingBasicTiming
    ;mptblcname RICHSA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Open_loop_enrich_factor_when_setting_mechanical_basic_timing
    .byte 0x00                       ;Point 1

	;.org	0x84b0
SPKSET_ConstantSparkAdvanceWhenSettingBasicTiming:
    ;mpgrp 5_-_Idle\C_-_Special_setup\
    ;mptbladdr 0x09D1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ConstantSparkAdvanceWhenSettingBasicTiming
    ;mptblcname SPKSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Advance 0 127.5 degrees
    ;mptbldesc Constant_spark_advance_setting_when_setting_basic_timing_(stock_12_degrees)
    .byte 0x0C                       ;Point 1

	;.org	0x84b1
IDLDEF_TargetIdleSpeed_HBDefault:
    ;mpgrp 5_-_Idle\C_-_Special_setup\
    ;mptbladdr 0x09DE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TargetIdleSpeed_HBDefault
    ;mptblcname IDLDEF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x7D                       ;Point 1

	;.org	0x84b2
RIDLST_OpenLoopEnrichFactorWhenSettingMinThrottleOpening:
    ;mpgrp 5_-_Idle\C_-_Special_setup\
    ;mptbladdr 0x09EB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OpenLoopEnrichFactorWhenSettingMinThrottleOpening
    ;mptblcname RIDLST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Open_loop_enrich_factor_when_setting_min_throttle_blade_opening_(actuator_test_#70)
    .byte 0x08                       ;Point 1

	;.org	0x84b3
IDLSET_ConstantSparkAdvanceWhenSettingMinThrottleOpening:
    ;mpgrp 5_-_Idle\C_-_Special_setup\
    ;mptbladdr 0x09F8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ConstantSparkAdvanceWhenSettingMinThrottleOpening
    ;mptblcname IDLSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Advance 0 127.5 degrees
    ;mptbldesc Constant_spark_advance_setting_when_setting_min_throttle_blade_opening_(actuator_test_#70)
    .byte 0x0C                       ;Point 1

	;.org	0x84b4
AMTEMP_StartTempToSelectHotOrColdAMTimer:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Adaptive_Memory_Timer\
    ;mptbladdr 0x0A05
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StartTempToSelectHotOrColdAMTimer
    ;mptblcname AMTEMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc Starting_Temp_to_select_hot_or_cold_AM_timer
    .byte 0xCF                       ;Point 1

	;.org	0x84b5
AMTPSW_TempPointToEnableSelectedAMTimer:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Adaptive_Memory_Timer\
    ;mptbladdr 0x0A12
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempPointToEnableSelectedAMTimer
    ;mptblcname AMTPSW
    ;mpxaxis Coolant_Temp -200 260 deg
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AM_temp_inhibit_time_from_coolant_temp
    .byte 0x02                       ;Number of points in table
    .byte 0xBD, 0x0C, 0x03, 0x50     ;Point 1
    .byte 0xCD, 0x41                 ;Point 2

	;.org	0x84c4
CLTIME_ClosedLoopTimeFromEngTempAtStartup_FromTemp:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Adaptive_Memory_Timer\
    ;mptbladdr 0x0A21
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ClosedLoopTimeFromEngTempAtStartup_FromTemp
    ;mptblcname CLTIME
    ;mpxaxis Coolant_Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Leave_at_one_-_2.8_sec
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x03                 ;Point 1

	;.org	0x84cb
CLTEMP_TempToStartCLTIMETimer:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Adaptive_Memory_Timer\
    ;mptbladdr 0x0A2F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TempToStartCLTIMETimer
    ;mptblcname CLTEMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 degrees
    ;mptbldesc Temperature_to_start_CLTIME_Timer_-_$94_=_70degreesF
    .byte 0x90                       ;Point 1

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

	;.org	0x84cc
MP1_AutoCalMapCellBoundary1:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0A4C
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary1
    ;mptblcname MP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc AutoCalMapCellBoundary1
    ;mpmapaxis y
    .byte 0x1B                       ;Point 1

	;.org	0x84cd
MP2_AutoCalMapCellBoundary2:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0A5A
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary2
    ;mptblcname MP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc AutoCalMapCellBoundary2
    ;mpmapaxis y
    .byte 0x25                       ;Point 1

	;.org	0x84ce
MP3_AutoCalMapCellBoundary3:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0A68
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary3
    ;mptblcname MP3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc AutoCalMapCellBoundary3
    ;mpmapaxis y
    .byte 0x32                       ;Point 1

	;.org	0x84cf
MP4_AutoCalMapCellBoundary4:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0A76
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary4
    ;mptblcname MP4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc AutoCalMapCellBoundary4
    ;mpmapaxis y
    .byte 0x41                       ;Point 1

	;.org	0x84d0
MP5_AutoCalMapCellBoundary5:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0A84
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary5
    ;mptblcname MP5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc AutoCalMapCellBoundary5
    ;mpmapaxis y
    .byte 0x50                       ;Point 1

	;.org	0x84d1
DLTMAP_MapHysteresisAtMapCellBoundaries:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0A92
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MapHysteresisAtMapCellBoundaries
    ;mptblcname DLTMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc Map_Hysteresis_At_Map_Cell_Boundaries
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

	;.org	0x84d2
R1_RPMCellBoundaryInRPMover32:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0AA0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMCellBoundaryInRPMover32
    ;mptblcname R1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Engine_RPM 0 8160 RPM
    ;mptbldesc RPM_Cell_Boundary
    .byte 0x3A                       ;Point 1

	;.org	0x84d3
DLTRPM_DeltaRPMAtRPMBoundariesInRPMOver32:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0AAD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaRPMAtRPMBoundariesInRPMOver32
    ;mptblcname DLTRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Delta_RPM_at_RPM_Boundaries
    .byte 0x02                       ;Point 1

	;.org	0x84d4
IDLOFS_DeltaForIdleRPMForClosedThrottleCell:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0ABA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaForIdleRPMForClosedThrottleCell
    ;mptblcname IDLOFS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc RPM_Delta_for_Idle_RPM_For_Closed_Throttle_Cell
    .byte 0x03                       ;Point 1

	;.org	0x84d5
HYTRPM_HysteresisFor_IDLOFS:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0AC7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HysteresisFor_IDLOFS
    ;mptblcname HYTRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Hysteresis_for_IDLOFS
    .byte 0x02                       ;Point 1

	;.org	0x84d6
CELCHG_BitsChangePerUpdateWithinACell:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0AD4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BitsChangePerUpdateWithinACell
    ;mptblcname CELCHG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_Bits_Change_Per_Update_Within_A_Cell
    .byte 0x01                       ;Point 1

	;.org	0x84d7
AMUPDT_EPPsBetweenCalChangeUpdateOpenThrottle:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0AE1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EPPsBetweenCalChangeUpdateOpenThrottle
    ;mptblcname AMUPDT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EPPs_Between_Cal_Change_Update_(Open_Throttle)
    .byte 0x1A                       ;Point 1

	;.org	0x84d8
AMUPDI_EPPsBetweenCalChangeUpdateClosedThrottle:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0AEE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EPPsBetweenCalChangeUpdateClosedThrottle
    ;mptblcname AMUPDI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EPPs_Between_Cal_Change_Update_(Closed_Throttle)
    .byte 0x1A                       ;Point 1

	;.org	0x84d9
CALTH1_O2ControllerDeadbandLimitForUpdatingCells1:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0AFB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2ControllerDeadbandLimitForUpdatingCells1
    ;mptblcname CALTH1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2_Controller_Deadband_Limit_For_Updating_Cells
    .byte 0x09                       ;Point 1

	;.org	0x84da
CALTH2_O2ControllerDeadbandLimitForUpdatingCells2:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0B08
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2ControllerDeadbandLimitForUpdatingCells2
    ;mptblcname CALTH2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2_Controller_Deadband_Limit_For_Updating_Cells
    .byte 0x09                       ;Point 1

	;.org	0x84db
MAPLIM_NoCellUpdateAboveThisMAP:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0B15
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname NoCellUpdateAboveThisMAP
    ;mptblcname MAPLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc No_Cell_Update_Above_This_MAP
    ;mpmapaxis y
    .byte 0x5C                       ;Point 1

	;.org	0x84dc
MAPDEC_NoCellUpdateAndO2CNTRHeldBelowThisMap:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0B23
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname NoCellUpdateAndO2CNTRHeldBelowThisMap
    ;mptblcname MAPDEC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc No_Cell_Update_And_O2CNTR_Held_Below_This_Map._Set_to_0xff_to_disable_O2_feedback.
    ;mpmapaxis y
    .byte 0x11                       ;Point 1

	;.org	0x84dd
RPMLIM_NoCellUpdateAboveThisRPMInRPMOver32:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0B31
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoCellUpdateAboveThisRPMInRPMOver32
    ;mptblcname RPMLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Engine_RPM 0 8160 rpm
    ;mptbldesc No_Cell_Update_Above_This_RPM_-_in_rpms/32
    .byte 0x56                       ;Point 1

	;.org	0x84de
PWMIN_NoCellUpdateBelow_PWMIN_Pulsewidth:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0B3E
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname NoCellUpdateBelow_PWMIN_Pulsewidth
    ;mptblcname PWMIN
    ;mpxaxis in_desc 0 65535 scale
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc No_Cell_Update_below_PWMIN_-_this_value_times_4_uSec
    ;mpinjscale word
    .word 0x00C9                     ;Point 1

MNPWDS_MinimumInjPWForDistSync:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x0B4B
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname MinimumInjPWForDistSync
    ;mptblcname MNPWDS
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc No_Dist_Sync_below_MNPWDS
    .word 0x007D                     ;Point 1
;       .inj word scale

	;.org	0x84e0
AMLIMH_MaxMultiplierCannotBeAbove7F:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0B59
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxMultiplierCannotBeAbove7F
    ;mptblcname AMLIMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AutoCal_Range_Of_Authority_where_MaxMultiplier=1+AMLIMH/512_(cannot_exceed_$7f)
    .byte 0x7F                       ;Point 1

	;.org	0x84e1
AMLIML_MinMultiplierCannotBeBelow80:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0B66
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
;     From http://www.faqs;;.org/faqs/autos/gasoline-faq/part2/ comes the following table
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

	;.org	0x84e2
PRIRMP_PrimaryRamp:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\O2_Controller_Ramps\
    ;mptbladdr 0x0BC1
    ;mptbltype 11
    ;mpsubtype 1
    ;mptbllname PrimaryRamp
    ;mptblcname PRIRMP
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Lower_RPM_Boundary_-_RPM/32
    ;mpmapaxis y
    .word 0x2632                  ;Rpm Low / High Boundary
    .word 0x2239                  ;Map Low / High Boundary
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
; eg: $19  -   1.05  * 512  - 512 - 5%
; *****************************************
; *****************************************
; The Limits are the maximum number of kicks that may be applied to each
; cell. If the O2 sensor fails to toggle after reaching the limit for more
; than a few sec, the AutoCal cell gets changed.
; *****************************************

	;.org	0x850e
O2LIMH_O2RangeLimitHigh:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0BF2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2RangeLimitHigh
    ;mptblcname O2LIMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2_Range_Of_Authority_MaxMultiplier=1+O2LIMH/512_(cannot_be_above_$7f)
    .byte 0x7F                       ;Point 1

	;.org	0x850f
O2LIML_O2RangeLimitLow:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0BFF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2RangeLimitLow
    ;mptblcname O2LIML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2_Range_Of_Authority_MinMultiplier=.5+O2LIML/512_(cannot_be_below_$80)
    .byte 0xB3                       ;Point 1

	;.org	0x8510
O2HIGH_HighLimitForImmediateSwitchToClosedLoop:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0C0C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForImmediateSwitchToClosedLoop
    ;mptblcname O2HIGH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HighLimitForImmediateSwitchToClosedLoop_$26_=_0.73v
    .byte 0x26                       ;Point 1

	;.org	0x8511
O2TLMH_HighLimitForDelayedSwitchToClosedLoop:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0C19
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForDelayedSwitchToClosedLoop
    ;mptblcname O2TLMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HighLimitForDelayedSwitchToClosedLoop
    .byte 0x1F                       ;Point 1

	;.org	0x8512
O2MIDH_HighLimitForInMiddleDetermination:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0C26
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForInMiddleDetermination
    ;mptblcname O2MIDH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HighLimitForInMiddleDetermination
    .byte 0x1C                       ;Point 1

	;.org	0x8513
O2HSWP_HighLimitForO2RampSwitching:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0C33
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForO2RampSwitching
    ;mptblcname O2HSWP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HighLimitForO2RampSwitching
    .byte 0x17                       ;Point 1

	;.org	0x8514
O2LSWP_LowLimitForO2RampSwitching:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0C40
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForO2RampSwitching
    ;mptblcname O2LSWP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LowLimitForO2RampSwitching
    .byte 0x16                       ;Point 1

	;.org	0x8515
O2MIDL_LowLimitForInMiddleDetermination:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0C4D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForInMiddleDetermination
    ;mptblcname O2MIDL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LowLimitForInMiddleDetermination._Used_for_Reverting_to_openLoop,_Setting_fault21,_outputting_O2_level_to_miller_tool
    .byte 0x12                       ;Point 1

	;.org	0x8516
O2TLML_LowLimitForDelayedSwitchToClosedLoop:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0C5A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForDelayedSwitchToClosedLoop
    ;mptblcname O2TLML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LowLimitForDelayedSwitchToClosedLoop
    .byte 0x0F                       ;Point 1

	;.org	0x8517
O2LOW_LowLimitForImmediateSwitchToClosedLoop:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0C67
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForImmediateSwitchToClosedLoop
    ;mptblcname O2LOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LowLimitForImmediateSwitchToClosedLoop
    .byte 0x0F                       ;Point 1

	;.org	0x8518
O2TIME_DelayTimeToClosedLoop:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0C74
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DelayTimeToClosedLoop
    ;mptblcname O2TIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Delay_Time 0 720 Sec
    ;mptbldesc DelayTimeWhenGoingClosedLoop._o2_voltage_must_trigger_timer,_ie_must_gt_O2TLMH_or_lt_O2TLML.Each_1_is_2.8_sec,_cannot_exceed_$7f
    .byte 0x07                       ;Point 1

	;.org	0x8519
LTHTIM_IfNoO2SwitchForThisTimeThrowFault51or52:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0C81
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname IfNoO2SwitchForThisTimeThrowFault51or52
    ;mptblcname LTHTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc If_no_O2_sensor_state_change_for_this_time(*2.8sec)_then_fault_51_or_52
    .byte 0x2C                       ;Point 1

	;.org	0x851a
SECRMP_SecondaryRamp:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\O2_Controller_Ramps\
    ;mptbladdr 0x0C8E
    ;mptbltype 11
    ;mpsubtype 1
    ;mptbllname SecondaryRamp
    ;mptblcname SECRMP
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Lower_RPM_Boundary_-_RPM/32
    ;mpmapaxis y
    .word 0x2649                  ;Rpm Low / High Boundary
    .word 0x1D35                  ;Map Low / High Boundary
    .word 0x03FD                  ;Cell 0 Ramp Rich/Lean
    .word 0x04FC                  ;Cell 1 Ramp Rich/Lean
    .word 0x01FF                  ;Cell 2 Ramp Rich/Lean
    .word 0x04FC                  ;Cell 3 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 4 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 5 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 6 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 7 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 8 Ramp Rich/Lean
    .word 0x01FF                  ;Ramp Idle Cell Rich/Lean
    .word 0x0608                  ;Cell 0 Limits/Rates Rich/Lean
    .word 0x0608                  ;Cell 1 Limits/Rates Rich/Lean
    .word 0x0608                  ;Cell 2 Limits/Rates Rich/Lean
    .word 0x0606                  ;Cell 3 Limits/Rates Rich/Lean
    .word 0x0208                  ;Cell 4 Limits/Rates Rich/Lean
    .word 0x0508                  ;Cell 5 Limits/Rates Rich/Lean
    .word 0x0708                  ;Cell 6 Limits/Rates Rich/Lean
    .word 0x0308                  ;Cell 7 Limits/Rates Rich/Lean
    .word 0x0708                  ;Cell 8 Limits/Rates Rich/Lean
    .word 0x0608                  ;Limit/Rates Idle Cell Rich/Lean

; *****************************************
; For each cell, the first number is "rich", the second is "lean".
; If the O2 sensor is returning a lean value, "rich" kicks are added.
; If the O2 sensor is returning a rich value, "lean" kicks are added.
;
;     STEP - (factor * 512) - 512  (signed number)
; eg: %0.4  ->	(1.004	* 512) - 512 = 2.048 (dec) = 0x02
; each bit is ~ 0.2%
; *****************************************

        


	;.org	0x8546
MPSHFT_OverboostFuelShutoffEnablePointFromMap_Timer:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\A_-_Overboost\
    ;mptbladdr 0x0CBE
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostFuelShutoffEnablePointFromMap_Timer
    ;mptblcname MPSHFT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc If_MAP_+_BARO_exceeds_MPSHOF,_wait_SHFDLT,_then_kill_engine_for_TRNTM._Overboost_-_$ff_to_disable
    ;mpmapaxis y
    .byte 0x6E                       ;Point 1

	;.org	0x8547
MPSHFA_OverboostFuelShutoffEnablePointFromMap_Absolute:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\A_-_Overboost\
    ;mptbladdr 0x0CCC
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostFuelShutoffEnablePointFromMap_Absolute
    ;mptblcname MPSHFA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc If_MAP_+_BARO_exceeds_MPSHOF,_wait_SHFDLT,_then_kill_engine_for_TRNTM._Overboost_-_$ff_to_disable
    ;mpmapaxis y
    .byte 0x0C                       ;Point 1

	;.org	0x8548
TRNTIM_OverboostFuelShutoffDuration:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\A_-_Overboost\
    ;mptbladdr 0x0CDA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OverboostFuelShutoffDuration
    ;mptblcname TRNTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 Sec
    ;mptbldesc Overboost_shutoff_duration_-_$ff_to_disable_-_stock_$5a
    .byte 0x5C                       ;Point 1

	;.org	0x8549
LMPSHF_OverboostFuelShutoffDisablePointFromMap_Limp:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\A_-_Overboost\
    ;mptbladdr 0x0CE7
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostFuelShutoffDisablePointFromMap_Limp
    ;mptblcname LMPSHF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Overboost_Shutoff_when_Wastegate_problem_has_been_detected_(should_not_disable_this)
    ;mpmapaxis y
    .byte 0x4B                       ;Point 1

	;.org	0x854a
REVLMT_MapLimpinAndThrAbove25PercentLower1850:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x0CF5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapLimpinAndThrAbove25PercentLower1850
    ;mptblcname REVLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Fuel_Off_RPM_for_bad_MAP
    .byte 0x3A                       ;Point 1

	;.org	0x854b
REVLMT2_MapLimpinAndThrAbove25PercentUpper2000:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x0D02
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapLimpinAndThrAbove25PercentUpper2000
    ;mptblcname REVLMT2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Fuel_On_RPM_for_bad_MAP
    .byte 0x3E                       ;Point 1

	;.org	0x854c
REVLMT3_MapAbove75PctAndIdleSwitchClosed2000:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x0D0F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapAbove75PctAndIdleSwitchClosed2000
    ;mptblcname REVLMT3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x3E                       ;Point 1

	;.org	0x854d
REVLMT4_MapAbove75PctAndThrLimpin2000:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x0D1C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapAbove75PctAndThrLimpin2000
    ;mptblcname REVLMT4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x5E                       ;Point 1

	;.org	0x854e
REVLMT5_RPMLimiterNormalOnRPM:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\B_-_Rev_Limiter\
    ;mptbladdr 0x0D29
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimiterNormalOnRPM
    ;mptblcname REVLMT5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0xD9                       ;Point 1

	;.org	0x854f
REVLMT6_RPMLimiterNormalOffRPM:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\B_-_Rev_Limiter\
    ;mptbladdr 0x0D36
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimiterNormalOffRPM
    ;mptblcname REVLMT6
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0xDA                       ;Point 1

	;.org	0x8550
THRTHR_25PctThrValueFromShutoff:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x0D43
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 25PctThrValueFromShutoff
    ;mptblcname THRTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x21                       ;Point 1

	;.org	0x8551
RVLSPD_CarSpeedForRevLimitWithTBOff:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x0D50
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CarSpeedForRevLimitWithTBOff
    ;mptblcname RVLSPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 127.5 mph
    ;mptbldesc Detailed_Description
    .byte 0x14                       ;Point 1

	;.org	0x8552
DFRPM1_2050RPM_DecelFuelShutoffTurnonLimit:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x0D5D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 2050RPM_DecelFuelShutoffTurnonLimit
    ;mptblcname DFRPM1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x2C                       ;Point 1

	;.org	0x8553
DFRPM2_2550RPM_DecelFuelShutoffUpperRpmLimit:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x0D6A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 2560RPM_DecelFuelShutoffUpperRpmLimit
    ;mptblcname DFRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x32                       ;Point 1

	;.org	0x8554
DFS20M_20MPHDecelFuelShutoffSpeedLimitOFF:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\E_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x0D77
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 20MPHDecelFuelShutoffSpeedLimitOFF
    ;mptblcname DFS20M
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x14                       ;Point 1

	;.org	0x8555
DFS20L_20MPHDecelFuelShutoffSpeedLimitON:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\E_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x0D84
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 20MPHDecelFuelShutoffSpeedLimitON
    ;mptblcname DFS20L
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1

	;.org	0x8556
DFSTMH_60DegCDecelFuelShutoffTempLimitOff:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\E_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x0D91
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 60DegCDecelFuelShutoffTempLimitOff
    ;mptblcname DFSTMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xCD                       ;Point 1

	;.org	0x8557
DFSTML_60DegCDecelFuelShutoffTempLimitON:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\E_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x0D9E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 60DegCDecelFuelShutoffTempLimitOn
    ;mptblcname DFSTML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xCA                       ;Point 1

	;.org	0x8558
DFSTMRH_3minuteDecelFuelShutoffTimeLimitOFF:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\E_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x0DAB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 3minuteDecelFuelShutoffTimeLimitOFF
    ;mptblcname DFSTMRH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0B                       ;Point 1

	;.org	0x8559
DFSMPH_MAPDecelFuelShutoffTimeLimitOFF:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x0DB8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 20MPHDecelFuelShutoffSpeedLimit
    ;mptblcname DFSMPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x24                       ;Point 1

	;.org	0x855a
DFSMPL_MAPDecelFuelShutoffTimeLimitON:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\E_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x0DC5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MAPDecelFuelShutoffTimeLimitON
    ;mptblcname DFSMPL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x27                       ;Point 1

	;.org	0x855b
L855C_L855c:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x0DD2
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname L855C_L855c
    ;mptblcname L855C
    ;mpxaxis in_desc 11 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Point 1
    .byte 0x2F                       ;Point 2
    .byte 0x12                       ;Point 3
    .byte 0x1F                       ;Point 4
    .byte 0x23                       ;Point 5
    .byte 0x1B                       ;Point 6
    .byte 0x11                       ;Point 7
    .byte 0x16                       ;Point 8
    .byte 0x32                       ;Point 9
    .byte 0x11                       ;Point 10
    .byte 0x21                       ;Point 11

	;.org	0x8566
SPDLMH_SpeedLimitFuelShutoff254mph:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\C_-_Speed_Limiter\
    ;mptbladdr 0x0DE9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SpeedLimitFuelShutoff254mph
    ;mptblcname SPDLMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 255 mph
    ;mptbldesc Detailed_Description
    .byte 0xAF                       ;Point 1

	;.org	0x8567
SPDLML_SpeedLimitFuelShutoffRestore253mph:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\C_-_Speed_Limiter\
    ;mptbladdr 0x0DF6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SpeedLimitFuelShutoffRestore253mph
    ;mptblcname SPDLML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xAA                       ;Point 1

	;.org	0x8568
SPDRPM_EngineSpeedHighLimitToEnableOverspeed:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x0E03
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineSpeedHighLimitToEnableOverspeed
    ;mptblcname SPDRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xD5                       ;Point 1

	;.org	0x8569
SPDRPM2_EngineSpeedLowLimitToDisableOverspeed:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x0E10
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineSpeedLowLimitToDisableOverspeed
    ;mptblcname SPDRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xD1                       ;Point 1

	;.org	0x856a
AISTRT_AisStartupPosition_FromTemp:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E1D
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisStartupPosition_FromTemp
    ;mptblcname AISTRT
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis AIS_Open 0 255 steps
    ;mptbldesc AIS_motor_startup_position_from_engine_temp
    .byte 0x03                       ;Number of points in table
    .byte 0x6E, 0x99, 0xFC, 0x33     ;Point 1
    .byte 0x7D, 0x60, 0xFF, 0x44     ;Point 2
    .byte 0xDB, 0x1B                 ;Point 3

	;.org	0x8581
RPMDEF_RPMDefaultForIdleControl:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E2D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMDefaultForIdleControl
    ;mptblcname RPMDEF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0xA0                       ;Point 1

	;.org	0x8582
RPMTHS_RPMThresholdForIdleControl:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E3A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMThresholdForIdleControl
    ;mptblcname RPMTHS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x0D                       ;Point 1

	;.org	0x8583
TIMED2_AISDecelBaseAirflowCurveOffset2:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E47
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelAisBaseAirflowCurveOffset_FromTime2
    ;mptblcname TIMED2
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis Time 0 720 sec
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x16, 0x0D, 0xF9, 0x80     ;Point 1
    .byte 0x18, 0x00                 ;Point 2

	;.org	0x858e
AISDLY_DelayFromStartRunThatAisFeedbackDisabled:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E56
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DelayFromStartRunThatAisFeedbackDisabled
    ;mptblcname AISDLY
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 720 sec
    ;mptbldesc Delay_from_Start/Run_transition_that_AIS_feedback_is_disabled_in_11msec_units
    .byte 0x5D                       ;Point 1

	;.org	0x858f
AISPN_IdleSpeedParkNeutral_FromTemp:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E63
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname IdleSpeedParkNeutral_FromTemp
    ;mptblcname AISPN
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis RPM 0 2048 rpm
    ;mptbldesc Idle_Speed_From_Temp_in_park/neutral_or_manual_trans
    .byte 0x02                       ;Number of points in table
    .byte 0x7F, 0xA3, 0xFF, 0x5C     ;Point 1
    .byte 0xBC, 0x7C                 ;Point 2

	;.org	0x859a
AISCLD_IdleSpeedDrive_FromTemp:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E72
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname IdleSpeedDrive_FromTemp
    ;mptblcname AISCLD
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis RPM 0 2048 rpm
    ;mptbldesc Idle_Speed_From_temp_in_Drive,_auto_trans_only
    .byte 0x02                       ;Number of points in table
    .byte 0x7F, 0xAF, 0xFF, 0x41     ;Point 1
    .byte 0xC2, 0x7D                 ;Point 2

	;.org	0x85a5
CLDPOS_AisColdPosition_FromTemp:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E81
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisColdPosition_FromTemp
    ;mptblcname CLDPOS
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis AIS_Open 0 2048 steps
    ;mptbldesc Cold_OffIdle_AIS_Positioning,_Increases_instantly,_decreases_after_DLYOFI
    .byte 0x06                       ;Number of points in table
    .byte 0x63, 0x77, 0xFC, 0x74     ;Point 1
    .byte 0x6E, 0x50, 0xFE, 0xD3     ;Point 2
    .byte 0x7F, 0x3C, 0xFE, 0xE2     ;Point 3
    .byte 0x90, 0x29, 0xFF, 0x80     ;Point 4
    .byte 0xA6, 0x1E, 0xFF, 0x57     ;Point 5
    .byte 0xD2, 0x01                 ;Point 6

	;.org	0x85bc
RPMPOS_AisPosition_FromRpm:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E94
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisPosition_FromRpm
    ;mptblcname RPMPOS
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc AIS_Position_from_RPMs
    .byte 0x04                       ;Number of points in table
    .byte 0x21, 0x00, 0x00, 0x1C     ;Point 1
    .byte 0x46, 0x04, 0x00, 0x00     ;Point 2
    .byte 0x64, 0x04, 0x00, 0x52     ;Point 3
    .byte 0x7D, 0x0C                 ;Point 4

	;.org	0x85cb
THRPOS_AisPosition_FromThrottle:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0EA5
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisPosition_FromThrottle
    ;mptblcname THRPOS
    ;mpxaxis TPS 0 5 Volts
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc AIS_Position_from_throttle
    .byte 0x02                       ;Number of points in table
    .byte 0x03, 0x00, 0x00, 0xAB     ;Point 1
    .byte 0x0F, 0x08                 ;Point 2

	;.org	0x85da
ACCTBL_ACOffIdleDelta_FromSpeed:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0EB4
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ACOffIdleDelta_FromSpeed
    ;mptblcname ACCTBL
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Number of points in table
    .byte 0x1E, 0x19, 0x00, 0x9A     ;Point 1
    .byte 0x32, 0x25, 0x00, 0x40     ;Point 2
    .byte 0x46, 0x2A, 0xFF, 0x9A     ;Point 3
    .byte 0x5A, 0x22, 0x00, 0x13     ;Point 4
    .byte 0x82, 0x25                 ;Point 5

	;.org	0x85ed
ACPOS_ACPositionWhenTempToCold:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0EC6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ACPositionWhenTempToCold
    ;mptblcname ACPOS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AIS:_AC_clutch_position_when_temp_to_cold
    .byte 0x24                       ;Point 1

	;.org	0x85ee
ACTMP_Use_ACCTBL_WhenTempAboveThisElseUse_ACPOS:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0ED3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Use_ACCTBL_WhenTempAboveThisElseUse_ACPOS
    ;mptblcname ACTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x7F                       ;Point 1

	;.org	0x85ef
DLYOF1_UpdateRateOffIdleWhenAisClosing:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0EE0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UpdateRateOffIdleWhenAisClosing
    ;mptblcname DLYOF1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x07                       ;Point 1

	;.org	0x85f0
ADDAIS_AISAddedFromTimeEngRunning:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0EED
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AISAddedFromTimeEngRunning
    ;mptblcname ADDAIS
    ;mpxaxis TimeEngRun 0 2.8 sec
    ;mpyaxis factor 0 0.996 factor
    ;mptbldesc Description
    .byte 0x02                       ;Number of points in table
    .byte 0x07, 0x08, 0xFF, 0x88     ;Point 1
    .byte 0x18, 0x00                 ;Point 2

	;.org	0x8603
BARAIS_AISBaroCompensation:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0EFC
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

	;.org	0x8612
BRKRPM_BrakeOverrideForAis_FromDeltaThrottle:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0F0C
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname BrakeOverrideForAis_FromDeltaThrottle
    ;mptblcname BRKRPM
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0xD0                 ;Point 1

	;.org	0x8621
FWDAIS_ForwardAisSteps_NoSlope:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0F1A
    ;mptbltype 12
    ;mpsubtype n
    ;mptbllname ForwardAisSteps_NoSlope
    ;mptblcname FWDAIS
    ;mpxaxis DeltaRPM 0 2048 rpm
    ;mpyaxis AISSteps 0 255 step
    ;mptbldesc Detailed_Description
    .byte 0x06                       ;Number of points in table
    .byte 0x0F, 0x00                 ;Point 1
    .byte 0x14, 0x01                 ;Point 2
    .byte 0x28, 0x02                 ;Point 3
    .byte 0x3C, 0x04                 ;Point 4
    .byte 0x50, 0x05                 ;Point 5
    .byte 0x64, 0x06                 ;Point 6

	;.org	0x8630
REVAIS_ReverseAisSteps_NoSlope:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0F2D
    ;mptbltype 12
    ;mpsubtype n
    ;mptbllname ReverseAisSteps_NoSlope
    ;mptblcname REVAIS
    ;mpxaxis DeltaRPM 0 2048 rpm
    ;mpyaxis AISSteps 0 255 step
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Number of points in table
    .byte 0x0F, 0x00                 ;Point 1
    .byte 0x14, 0xFF                 ;Point 2
    .byte 0x28, 0xFE                 ;Point 3
    .byte 0x50, 0xFC                 ;Point 4

	;.org	0x863f
TIMEDC_AISDecelBaseAirflowCurveOffset:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F3E
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelAisBaseAirflowCurveOffset_FromTime
    ;mptblcname TIMEDC
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis Time 0 720 sec
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x16, 0x08, 0xFC, 0x00     ;Point 1
    .byte 0x18, 0x00                 ;Point 2

	;.org	0x864e
TEMPDC_AISDecel_FromTemp:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F4D
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelAis_FromTemp
    ;mptblcname TEMPDC
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x58, 0x28, 0xFF, 0xAA     ;Point 1
    .byte 0xCF, 0x00                 ;Point 2

	;.org	0x8669
DAISOP_DecelAisOpenStepsFromNeg_FromDeltaMap:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F5C
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname DecelAisOpenStepsFromNeg_FromDeltaMap
    ;mptblcname DAISOP
    ;mpxaxis DeltaMAP 0 44.1 psi
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Decel_AIS_open_steps_from_-Delta_MAP
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x01, 0x00, 0x01, 0x25     ;Point 1
    .byte 0x08, 0x08                 ;Point 2

	;.org	0x8678
DAISCL_DecelAisOpenStepsFromPos_FromDeltaMap:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F6C
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname DecelAisOpenStepsFromPos_FromDeltaMap
    ;mptblcname DAISCL
    ;mpxaxis DeltaMAP 0 44.1 psi
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Decel_AIS_open_steps_from_+Delta_MAP
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x01, 0x00, 0xFF, 0x80     ;Point 1
    .byte 0x0B, 0xFB                 ;Point 2

	;.org	0x8687
MAPFLR_AISAdditionToControlMap_FromRpm:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F7C
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AdditionToControlMap_FromRpm
    ;mptblcname MAPFLR
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis ScaledMAP 0 44.1 psi
    ;mptbldesc AIS_Decel_Addition_to_control_MAP_vs._RPM
    .byte 0x02                       ;Number of points in table
    .byte 0x26, 0x00, 0x00, 0x55     ;Point 1
    .byte 0x2F, 0x03                 ;Point 2

	;.org	0x869a
MPTEMP_TempTermForMapOffset_FromTemp:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F8B
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempTermForMapOffset_FromTemp
    ;mptblcname MPTEMP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 0.996 percent
    ;mptbldesc AIS_Decel_Temperature_Term
    .byte 0x02                       ;Number of points in table
    .byte 0x90, 0x00, 0x04, 0xA3     ;Point 1
    .byte 0xC7, 0xFF                 ;Point 2

	;.org	0x86a9
BARFLR_OffsetCorrectionTo_MAPFLR_FromBaro:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F9A
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

	;.org	0x86b8
DCLRFQ_TimeBetweenAisPulsesForDecelAis:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0FA9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBetweenAisPulsesForDecelAis
    ;mptblcname DCLRFQ
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 Sec
    ;mptbldesc Detailed_Description
    .byte 0x40                       ;Point 1

	;.org	0x86b9
DATHOT_EngineTempToStartCalibratingDacal:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0FB6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineTempToStartCalibratingDacal
    ;mptblcname DATHOT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Deg
    ;mptbldesc Detailed_Description
    .byte 0xCD                       ;Point 1

	;.org	0x86ba
DADRPM_DeltaRpmFromIdleSpeedForDacalUpdate:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0FC3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaRpmFromIdleSpeedForDacalUpdate
    ;mptblcname DADRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1

	;.org	0x86bb
DAACF_ACFactorDeltaFromBase:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0FD0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ACFactorDeltaFromBase
    ;mptblcname DAACF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0F                       ;Point 1

	;.org	0x86bc
DANOM_Base_nominalCal:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0FDD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Base_nominalCal
    ;mptblcname DANOM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x12                       ;Point 1

	;.org	0x86bd
DCALTM_DacalInhibitTimeAfterStartup:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0FEA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DacalInhibitTimeAfterStartup
    ;mptblcname DCALTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x15                       ;Point 1

	;.org	0x86be
DCALRT_DacalUpdateRate01_03_07_0f_1f_3f_7f_ff:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0FF7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DacalUpdateRate01_03_07_0f_1f_3f_7f_ff
    ;mptblcname DCALRT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x3F                       ;Point 1

	;.org	0x86bf
DCLMIN_MinLimitOnDecelAisControlledMap:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1004
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinLimitOnDecelAisControlledMap
    ;mptblcname DCLMIN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x86c0
DCLMN2_NoAisControlIfMapAndControlMapBelowThis:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1011
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname NoAisControlIfMapAndControlMapBelowThis
    ;mptblcname DCLMN2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x0D                       ;Point 1

	;.org	0x86c1
DLYTIM_AisDelayAfterThrottleClosesWhenMoving:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x101F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisDelayAfterThrottleClosesWhenMoving
    ;mptblcname DLYTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Decel_AIS_Delay_after_throttle_closes_when_moving
    .byte 0x95                       ;Point 1

	;.org	0x86c2
DLYTM2_AisDelayAfterThrottleClosesWhenStopped:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x102C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisDelayAfterThrottleClosesWhenStopped
    ;mptblcname DLYTIM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Decel_AIS_Delay_after_throttle_closes_when_stopped
    .byte 0x20                       ;Point 1

	;.org	0x86c3
DLYTM3_AisDelayAfterThrottleClosesWhenRpmAbove_DLYRPM:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1039
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisDelayAfterThrottleClosesWhenRpmAbove_DLYRPM
    ;mptblcname DLYTM3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Decel_AIS_Delay_after_throttle_closes_when_MAP_is_below_DCLMN2
    .byte 0xD0                       ;Point 1

	;.org	0x86c4
DLYRPM_RpmTriggerForAisDelay:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1046
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RpmTriggerForAisDelay
    ;mptblcname DLYRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Decel_AIS_RPM_trigger_(third_AIS_delay)
    .byte 0x3D                       ;Point 1

	;.org	0x86c5
MPHREF_SwitchPointForDecelIdleAisControl:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1053
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SwitchPointForDecelIdleAisControl
    ;mptblcname MPHREF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 127.5 mph
    ;mptbldesc Switch_point_between_Decel_or_Idle_AIS_control._Note_there_is_also_a_1.5_mph_hysteresis
    .byte 0x07                       ;Point 1

	;.org	0x86c6
PNDLTN_DeltaRpmChangeToUse_DRPNK_or_PNDRK:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1060
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DeltaRpmChangeToUse_DRPNK_or_PNDRK_A
    ;mptblcname PNDLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x1F40                     ;Point 1

	;.org	0x86c8
PNDRK_ParkNeutralToDriveKicks_FromTemp:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x106D
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ParkNeutralToDriveKicks_FromTemp
    ;mptblcname PNDRK
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0x86d7
PNDLTP_DeltaRpmChangeToUse_DRPNK_or_PNDRK:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x107B
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DeltaRpmChangeToUse_DRPNK_or_PNDRK_B
    ;mptblcname PNDLTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x1F40                     ;Point 1

	;.org	0x86d9
DRPNK_DriveToParkNeutralKicks_FromTemp:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1088
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DriveToParkNeutralKicks_FromTemp
    ;mptblcname DRPNK
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0x86e8
ACOFFK_ClosedThrottleAcOffKick:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1096
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ClosedThrottleAcOffKick
    ;mptblcname ACOFFK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x18                       ;Point 1

	;.org	0x86e9
AC2KCK_AcClutchKickOpenAfterAcEnabled:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10A3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcClutchKickOpenAfterAcEnabled
    ;mptblcname AC2KCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x86ea
ACTIME_TimeBeforeAcEnabledAndFullDeltaUsed:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10B0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBeforeAcEnabledAndFullDeltaUsed
    ;mptblcname ACTIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x20                       ;Point 1

	;.org	0x86eb
ACTDEF_TimeBeforeAcEnabledAndFullDeltaUsed_Default:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10BD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBeforeAcEnabledAndFullDeltaUsed_Default
    ;mptblcname ACTDEF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x2A                       ;Point 1

	;.org	0x86ec
PERKCK_AcClutchAisAdjustmentConstant:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10CA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcClutchAisAdjustmentConstant
    ;mptblcname PERKCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x86ed
AC4KCK_AcClutchKickOpenBeforeAcEnabled2:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10D7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcClutchKickOpenBeforeAcEnabled2
    ;mptblcname AC4KCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xF4                       ;Point 1

	;.org	0x86ee
AC3KCK_AcClutchKickOpenAfterAcEnabled2:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10E4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcClutchKickOpenAfterAcEnabled2
    ;mptblcname AC3KCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFA                       ;Point 1

	;.org	0x86ef
ACTIM2_TimeBeforeAcEnabledAndFullDeltaUsed2:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10F1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBeforeAcEnabledAndFullDeltaUsed2
    ;mptblcname ACTIM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x14                       ;Point 1

	;.org	0x86f0
OFFPER_AisInstantlyClosesWhenAcDisengages:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10FE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisInstantlyClosesWhenAcDisengages
    ;mptblcname OFFPER
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x80                       ;Point 1

	;.org	0x86f1
OFFPER2_AisInstantlyClosesWhenAcDisengages2:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x110B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisInstantlyClosesWhenAcDisengages2
    ;mptblcname OFFPER2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x80                       ;Point 1

	;.org	0x86f2
AISMPH_RollingAisMaxSpeed:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1118
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisMaxSpeed
    ;mptblcname AISMPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1

	;.org	0x86f3
RPMDLT_RollingAisMinRpm:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1125
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname RollingAisMinRpm
    ;mptblcname RPMDLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc RPM_added_to_the_target_idle_speed_when_rolling...
    .word 0x07D0                     ;Point 1

	;.org	0x86f5
ISPDCY_RollingAisDecay:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1132
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisDecay
    ;mptblcname ISPDCY
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1

	;.org	0x86f6
DECAIS_RollingAisUpdateRate_01_03_07_0f_1f_3f_7f_ff:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x113F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisUpdateRate_01_03_07_0f_1f_3f_7f_ff
    ;mptblcname DECAIS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x7F                       ;Point 1

	;.org	0x86f7
AISLMH_RollingAisHighLimit:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x114C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisHighLimit
    ;mptblcname AISLMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x20                       ;Point 1

	;.org	0x86f8
AISLML_RollingAisLowLimit:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1159
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisLowLimit
    ;mptblcname AISLML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1

	;.org	0x86f9
ACDTMP_PartThrottleAcCutoutDisableTemp:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1166
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PartThrottleAcCutoutDisableTemp
    ;mptblcname ACDTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x58                       ;Point 1

	;.org	0x86fa
ACDTHR_PartThrottleAcCutoutDisableThrottle:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1173
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PartThrottleAcCutoutDisableThrottle
    ;mptblcname ACDTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x1A                       ;Point 1

	;.org	0x86fb
ACDSPD_PartThrottleAcCutoutDisableSpeed:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1180
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname PartThrottleAcCutoutDisableSpeed
    ;mptblcname ACDSPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0440                     ;Point 1

	;.org	0x86fd
ACETIM_PartThrottleAcCutoutMaxTimeActive:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x118D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PartThrottleAcCutoutMaxTimeActive
    ;mptblcname ACETIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0C                       ;Point 1

	;.org	0x86fe
ACERPM_AllowAcClutchAboveThisRpm:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x119A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AllowAcClutchAboveThisRpm
    ;mptblcname ACERPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x54                       ;Point 1

	;.org	0x86ff
ACESPD_AllowAcClutchAboveThisSpeed:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x11A7
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname AllowAcClutchAboveThisSpeed
    ;mptblcname ACESPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0500                     ;Point 1

	;.org	0x8701
ACAETH_DisallowAcClutchEngageForThisTimeAfterAccelEnrich:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x11B4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DisallowAcClutchEngageForThisTimeAfterAccelEnrich
    ;mptblcname ACAETH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x2D                       ;Point 1

	;.org	0x8702
BTVAIS_MinVoltageForAis:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x11C1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinVoltageForAis
    ;mptblcname BTVAIS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x71                       ;Point 1

	;.org	0x8703
AISFRQ_AisPeriodForRpmFeedback11ms:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x11CE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisPeriodForRpmFeedback11ms
    ;mptblcname AISFRQ
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x82                       ;Point 1

	;.org	0x8704
AISHLM_AisHighLimitMaxOpenSteps:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x11DB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisHighLimitMaxOpenSteps
    ;mptblcname AISHLM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xA0                       ;Point 1

	;.org	0x8705
AISFAN_AisKickWhenFanTurnsOnClosedThrottle:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x11E8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisKickWhenFanTurnsOnClosedThrottle
    ;mptblcname AISFAN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0A                       ;Point 1

	;.org	0x8706
CALPOS_PositionAisMotorIsAtIdle:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x11F5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PositionAisMotorIsAtIdle
    ;mptblcname CALPOS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AIS:_Position_electronics_thinks_motor_is_(at_idle)
    .byte 0x1A                       ;Point 1

	;.org	0x8707
CALRAT_AisAdjustRate:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x1202
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisAdjustRate
    ;mptblcname CALRAT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AIS_update_rate_when_calibrating_-_rate=(CALRAT+1)*11ms_(can_be_0,1,3,7,f,1f,3f,7f,ff)
    .byte 0x07                       ;Point 1

        

BSTSWS_HighBoostSwitchSelect:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x1210
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname HighBoostSwitchSelect
    ;mptblcname BSTSWS
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc Switch_that_will_activate_high_boost_mode._If_no_switch_is_selected,_then_theboost_is_not_selectable,_and_the_Low_Boost_curve_needs_to_be_setup_as_the_high_boost_curve.
    ;mpchoices B1Voltage_Sense(Do_Not_Use)  Speed_Control_Set_(Momentary)  Speed_Control_On/Off  Speed_Control_Resume_(Momentary)  A/C_Switch  A/C_Clutch_Input(Do_Not_Use)  Brake_Switch  Park/Neutral_Switch
    .byte 0x00                       ;Point 1
;        sw1_bit7           	        = $%10000000	;
;        sw1_ACclutch       	        = $%01000000	; A/C Clutch input
;        sw1_CruiseSet              	= $%00100000	; Cruise Set
;        sw1_bit4                       = $%00010000	;
;        sw1_CruiseOnOff         	= $%00001000	; Cruise On/Off
;        sw1_Brake          		= $%00000100	; Brake Switch
;        sw1_CruiseResume   		= $%00000010	; Cruise Resume
;        sw1_PNswitch                   = $%00000001	; Park/Neutral switch

	;.org	0x8708
WSGRPM_AllowedBoost_FromRpm:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x1226
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromRpm
    ;mptblcname WSGRPM
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Boost_Allowed_from_RPMs._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x04                       ;Number of points in table
    .byte 0x4B, 0x68, 0x00, 0x00     ;Point 1
    .byte 0x64, 0x68, 0x00, 0x00     ;Point 2
    .byte 0xC8, 0x68, 0x00, 0x00     ;Point 3
    .byte 0xCE, 0x68                 ;Point 4

	;.org	0x871b
WSGRPA_AllowedBoostKnock_FromRpm:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x1238
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoostKnock_FromRpm
    ;mptblcname WSGRPA
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Boost_Allowed_from_RPMs_while_knocking._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x04                       ;Number of points in table
    .byte 0x6A, 0x29, 0x00, 0xC0     ;Point 1
    .byte 0x8A, 0x41, 0x00, 0x00     ;Point 2
    .byte 0xA8, 0x41, 0xFF, 0x55     ;Point 3
    .byte 0xBA, 0x35                 ;Point 4

LOWBST_AllowedBoostLo:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x1249
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AllowedBoostLo
    ;mptblcname LOWBST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Low_boost_setting._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1

STGBST_AllowedBoostDuringStaging:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x1256
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AllowedBoostDuringStaging
    ;mptblcname STGBST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Boost_setting_while_launch_control_is_active._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x29                       ;Point 1

	;.org	0x872e
WSGTIM_AllowedBoost_FromTime:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x1264
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

	;.org	0x8739
WSGCLT_AllowedBoost_FromTemp:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x1273
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromTemp
    ;mptblcname WSGCLT
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Boost_Allowed_from_Engine_Temp._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x04                       ;Number of points in table
    .byte 0x9B, 0x20, 0x01, 0xD9     ;Point 1
    .byte 0xC2, 0x68, 0x00, 0x00     ;Point 2
    .byte 0xEE, 0x68, 0xF4, 0x00     ;Point 3
    .byte 0xF4, 0x20                 ;Point 4

	;.org	0x874c
WSGCHG_AllowedBoost_FromChargeTemp:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x1285
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromChargeTemp
    ;mptblcname WSGCHG
    ;mpxaxis charge_temp_volts 0 5 volts
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Boost_Allowed_from_Charge_Temp._Boost_is_defined_as_MAP_reading_above_Baro._Charge_Temp_numbers_are_approximate_only
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0xF8, 0x68, 0xF5, 0x40     ;Point 1
    .byte 0xFC, 0x3D                 ;Point 2

	;.org	0x875b
MXSBST_AllowedBoost_FromSpeed:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x1295
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromSpeed
    ;mptblcname MXSBST
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Boost_Allowed_from_Speed_to_protect_automatic_transmissions.
    ;mpmapaxis y
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0xFF                 ;Point 1

	;.org	0x876e
WSGPRT_AllowedBoostPartThrottle_FromThrottle:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x12A4
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoostPartThrottle_FromThrottle
    ;mptblcname WSGPRT
    ;mpxaxis TPS 0 5 volts
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Boost_Allowed_from_Throttle_at_Part_Throttle._Boost_is_defined_as_MAP_reading_above_Baro
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x93, 0x3A, 0x01, 0x36     ;Point 1
    .byte 0xB9, 0x68                 ;Point 2

	;.org	0x877d
DCWOT_FullThrottleWastegateDutyCycle_C8is100Percent_FromMap:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Lookup\
    ;mptbladdr 0x12B4
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FullThrottleWastegateDutyCycle_C8is100Percent_FromMap
    ;mptblcname DCWOT
    ;mpxaxis TargetBoost 0 44.1 psi
    ;mpyaxis Duty_Cycle 0 127.5 percent
    ;mptbldesc WOT_WG_Duty_Cycle
    ;mpmapaxis x
    .byte 0x03                       ;Number of points in table
    .byte 0x29, 0x00, 0x02, 0xCD     ;Point 1
    .byte 0x33, 0x1C, 0x02, 0x94     ;Point 2
    .byte 0x6E, 0xB4                 ;Point 3

	;.org	0x8798
DCWADJ_FullThrottleWastegateDutyCycleAdjustment_FromRpm:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Lookup\
    ;mptbladdr 0x12C5
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

	;.org	0x87b7
MAPPT2_WastegateDutyCycleMapSwitchPoint2:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x12D9
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname WastegateDutyCycleMapSwitchPoint2
    ;mptblcname MAPPT2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Wastegate_Duty_Cycle_Adjustment_Map_Switch_Point
    ;mpmapaxis y
    .byte 0x15                       ;Point 1

	;.org	0x87b8
RPMBST_MinimumRpmToTrackBoostCreep:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Lookup\
    ;mptbladdr 0x12E7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumRpmToTrackBoostCreep
    ;mptblcname RPMBST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Min_RPM_to_increment_the_boost_error_timer.
    .byte 0x4C                       ;Point 1

	;.org	0x87b9
KDCINC_WastegateDutyCycleIncreaseStepWhenKnocking:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Knock_Adj\
    ;mptbladdr 0x12F4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseStepWhenKnocking
    ;mptblcname KDCINC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

	;.org	0x87ba
KDCMAX_WastegateDutyCycleIncreaseMaxWhenKnocking:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Knock_Adj\
    ;mptbladdr 0x1301
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseMaxWhenKnocking
    ;mptblcname KDCMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x14                       ;Point 1

	;.org	0x87bb
KDCMIN_WastegateDutyCycleIncreaseMinWhenKnocking:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Knock_Adj\
    ;mptbladdr 0x130E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseMinWhenKnocking
    ;mptblcname KDCMIN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1

	;.org	0x87bc
DECTIM_TimeScaleFor_DCDECK:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x131B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeScaleFor_DCDECK
    ;mptblcname DECTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x07                       ;Point 1

	;.org	0x87bd
DCDECK_WastegateDutyCycleDecrementWhenSparkStillDerated:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Knock_Adj\
    ;mptbladdr 0x1328
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleDecrementWhenSparkStillDerated
    ;mptblcname DCDECK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

	;.org	0x87be
MNRTWG_MinRetardToDerateWGDC:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Knock_Adj\
    ;mptbladdr 0x1335
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MinRetardToDerateWGDC
    ;mptblcname MNRTWG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x05                       ;Point 1

	;.org	0x87bf
MPFLOR_StopAdaptiveWGWhenDeltaMapIsLessThanThis:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x1343
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname StopAdaptiveWhenDeltaMapIsLessThanThis
    ;mptblcname MPFLOR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

	;.org	0x87c1
DECPT_AdaptiveDecAfterThisTime:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x1351
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveDecAfterThisTime
    ;mptblcname DECPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_BoostErrTimer_counts_before_WG_Duty_Cycle_is_decremented._Used_when_boost_is_above_target.
    .byte 0x14                       ;Point 1

	;.org	0x87c2
DECLIM_LowerLimitOnWastegateDutyCycleCorrection:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x135E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowerLimitOnWastegateDutyCycleCorrection
    ;mptblcname DECLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x18                       ;Point 1

	;.org	0x87c3
WGDCOF_WastegateDutyCycleOffset:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x136B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleOffset
    ;mptblcname WGDCOF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DutyCycle 0 127.5 Percent
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x87c4
MPROOF_StopAdaptiveWGWhenMapIsThisCloseToBoostTarget:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x1378
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname StopAdaptiveWGWhenMapIsThisCloseToBoostTarget
    ;mptblcname MPROOF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

	;.org	0x87c5
MPDEL2_MinRetardToDerateWGDC2:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x1386
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname IncCounterWhenDeltaMapBelowThis2
    ;mptblcname MPDEL2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x02                       ;Point 1

	;.org	0x87c6
DECPTX_AdaptiveDecAfterThisTimeX:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x1394
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveDecAfterThisTimeX
    ;mptblcname DECPTX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x1F                       ;Point 1

	;.org	0x87c7
WGMXER_MaxWGDCForBoostErrorCorrection:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x13A1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxWGDCForBoostErrorCorrection
    ;mptblcname WGMXER
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis WGDC 0 127.5 percent
    ;mptbldesc Detailed_Description
    .byte 0xBC                       ;Point 1

	;.org	0x87c8
DCRPML_NoWastegateDutyCycleCorrectionBelowThisRpm:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x13AE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoWastegateDutyCycleCorrectionBelowThisRpm
    ;mptblcname DCRPML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x3B                       ;Point 1

	;.org	0x87c9
DCRPMH_NoWastegateDutyCycleCorrectionAboveThisRpm:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x13BB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoWastegateDutyCycleCorrectionAboveThisRpm
    ;mptblcname DCRPMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Desc
    .byte 0xC8                       ;Point 1

	;.org	0x87ca
TPSLIM_UpdateAdaptiveWGTPSUpperLimit:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x13C8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UpdateAdaptiveWGTPSUpperLimit
    ;mptblcname TPSLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis TPS_Volts 0 5 volts
    ;mptbldesc Detailed_Description
    .byte 0x66                       ;Point 1

	;.org	0x87cb
DCCTSL_NoWastegateDutyCycleCorrectionBelowThisCoolantTemp:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x13D5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoWastegateDutyCycleCorrectionBelowThisCoolantTemp
    ;mptblcname DCCTSL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis CoolantTemp -200 260 DegF
    ;mptbldesc Detailed_Description
    .byte 0xB1                       ;Point 1

	;.org	0x87cc
MAPPT_WastegateDutyCycleMapSwitchPoint:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x13E2
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname WastegateDutyCycleMapSwitchPoint
    ;mptblcname MAPPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Wastegate_Duty_Cycle_Adjustment_boost_switch_point.
    ;mpmapaxis y
    .byte 0x3D                       ;Point 1

	;.org	0x87cd
DCRPM1_WastegateDutyCycleRpmBoundary1:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x13F0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleRpmBoundary1
    ;mptblcname DCRPM1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x4B                       ;Point 1

	;.org	0x87ce
DCRPM2_WastegateDutyCycleRpmBoundary2:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x13FD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleRpmBoundary2
    ;mptblcname DCRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x58                       ;Point 1

	;.org	0x87cf
DCRPM3_WastegateDutyCycleRpmBoundary3:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x140A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleRpmBoundary3
    ;mptblcname DCRPM3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x67                       ;Point 1

	;.org	0x87d0
VNTALT_VNTHighAltitudeBoostSetpointBase:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x1417
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname VNTHighAltitudeBoostSetpointBase
    ;mptblcname VNTALT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x47                       ;Point 1

	;.org	0x87d1
VNTTMP_VNTDecelEngineTempToDetermineVanePos:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x1425
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname VNTDecelEngineTempToDetermineVanePos
    ;mptblcname VNTTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis CoolantTemp -200 260 DegF
    ;mptbldesc Detailed_Description
    .byte 0xA6                       ;Point 1

	;.org	0x87d2
VNTMAX_VNTMaxActuatorDutyCycle:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x1432
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname VNTMaxActuatorDutyCycle
    ;mptblcname VNTMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis VNTDC 0 127.5 percent
    ;mptbldesc Detailed_Description
    .byte 0xC8                       ;Point 1

	;.org	0x87d3
VNTRPM_RPMThresholdForVNTControl:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x143F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMThresholdForVNTControl
    ;mptblcname VNTRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x32                       ;Point 1

	;.org	0x87d4
VNTMIN_VNTMinActuatorDutyCycle:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x144C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname VNTMinActuatorDutyCycle
    ;mptblcname VNTMIN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis VNTDC 0 127.5 percent
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x87d5
DECPTV_AdaptiveDecAfterThisTimeVNT:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x1459
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveDecAfterThisTimeVNT
    ;mptblcname DECPTV
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis BstErrTime 0 2.8 sec
    ;mptbldesc Detailed_Description
    .byte 0x1F                       ;Point 1

	;.org	0x87d6
INCPTV_AdaptiveIncAfterThisTimeVNT:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x1466
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveIncAfterThisTimeVNT
    ;mptblcname INCPTV
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis BstErrTime 0 2.8 sec
    ;mptbldesc Detailed_Description
    .byte 0x2F                       ;Point 1

	;.org	0x87d7
DCRPMLV_NoWastegateDutyCycleCorrectionBelowThisRpmVNT:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x1473
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoWastegateDutyCycleCorrectionBelowThisRpmVNT
    ;mptblcname DCRPMLV
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x51                       ;Point 1

	;.org	0x87d8
DCRPM4_WastegateDutyCycleRpmBoundary4:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x1480
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleRpmBoundary4
    ;mptblcname DCRPM4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x8A                       ;Point 1

	;.org	0x87d9
DCRPM5_WastegateDutyCycleRpmBoundary5:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x148D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleRpmBoundary5
    ;mptblcname DCRPM5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0xA9                       ;Point 1

	;.org	0x87da
HABARO_VNTHighAltitudeBoostCalculationFromBaro:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x149A
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname VNTHighAltitudeBoostCalculationFromBaro
    ;mptblcname HABARO
    ;mpxaxis Baro 0 44.1 psi
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x38, 0x18, 0xFE, 0x97     ;Point 1
    .byte 0x49, 0x00                 ;Point 2

	;.org	0x87e1
HARPM_VNTHighAltitudeBoostCalculationFromRPM:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x14AA
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname VNTHighAltitudeBoostCalculationFromRPM
    ;mptblcname HARPM
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x7D, 0x00, 0x07, 0xC9     ;Point 1
    .byte 0x99, 0xDA, 0x01, 0xF3     ;Point 2
    .byte 0xAC, 0xFF                 ;Point 3

	;.org	0x87ec
BPRMIN_VNTMinimumBoostForIncrRateAdjustment:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x14BA
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname VNTMinimumBoostForIncrRateAdjustment
    ;mptblcname BPRMIN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0xAA                       ;Point 1

	;.org	0x87ed
OBCTRL_OverboostControlPoint:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x14C8
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostControlPoint
    ;mptblcname OBCTRL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x4E                       ;Point 1

	;.org	0x87ee
BPRMN2_VNTMinimumDeltaBoostForIncrRateAdjustment:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x14D6
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname VNTMinimumDeltaBoostForIncrRateAdjustment
    ;mptblcname BPRMN2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x04                       ;Point 1

	;.org	0x87ef
DBCRNG_DeltaBoostLimitNegativeForBoostCreep:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x14E4
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaBoostLimitNegativeForBoostCreep
    ;mptblcname DBCRNG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x02                       ;Point 1

	;.org	0x87f0
DLTBSC_DeltaBoostSampleCounterMax:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x14F2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaBoostSampleCounterMax
    ;mptblcname DLTBSC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaBTimer 0 2.8 sec
    ;mptbldesc Detailed_Description
    .byte 0x07                       ;Point 1

	;.org	0x87f1
DECMAX_VNTWGDutyCylceMaxDecreaseFromIncrRate:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x14FF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname VNTWGDutyCylceMaxDecreaseFromIncrRate
    ;mptblcname DECMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xB4                       ;Point 1

	;.org	0x87f2
DBCRPS_DeltaBoostLimitPositiveForBoostCreep:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x150C
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaBoostLimitPositiveForBoostCreep
    ;mptblcname DBCRPS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

	;.org	0x87f3
INCPT_AdaptiveIncAfterThisTime:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x151A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveIncAfterThisTime
    ;mptblcname INCPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_BoostErrTimer_counts_before_WG_Duty_Cycle_is_incremented._Used_when_boost_is_below_target.
    .byte 0x0F                       ;Point 1

	;.org	0x87f4
WGDCON_WGDCOffsetNegatve:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x1527
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WGDCOffsetNegatve
    ;mptblcname WGDCON
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis WGDC 0 127.5 percent
    ;mptbldesc Detailed_Description
    .byte 0x08                       ;Point 1

	;.org	0x87f5
WGDCDB_VNTWGDutyCycleDecreaseFromDeltaBoost:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x1534
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname VNTWGDutyCycleDecreaseFromDeltaBoost
    ;mptblcname WGDCDB
    ;mpxaxis DeltaBst 0 44.1 psi
    ;mpyaxis WGDCChange 0 127.5 percent
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x04                       ;Number of points in table
    .byte 0x05, 0x00, 0x02, 0x9A     ;Point 1
    .byte 0x0A, 0x0D, 0x04, 0x00     ;Point 2
    .byte 0x0F, 0x21, 0x04, 0x00     ;Point 3
    .byte 0x14, 0x35                 ;Point 4

	;.org	0x8804
VNTCNT_VNTBoostControlCounter1Init:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x1546
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname VNTBoostControlCounter1Init
    ;mptblcname VNTCNT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Counter 0 255 cnt
    ;mptbldesc Detailed_Description
    .byte 0xE3                       ;Point 1

	;.org	0x8805
VMINRP_MinimumRPMForVNTBoostControl:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x1553
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumRPMForVNTBoostControl
    ;mptblcname VMINRP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x8806
WGDCMN_MinimumWastegateDutyCycle:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x1560
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumWastegateDutyCycle
    ;mptblcname WGDCMN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DutyCycle 0 127.5 percent
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x8807
WGDCMX_MaximumWastegateDutyCycle:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x156D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaximumWastegateDutyCycle
    ;mptblcname WGDCMX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DutyCycle 0 127.5 percent
    ;mptbldesc Detailed_Description
    .byte 0xC8                       ;Point 1

	;.org	0x8808
VNTDCR_VNTDutyCycleFromRPM:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x157A
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname VNTDutyCycleFromRPM
    ;mptblcname VNTDCR
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis DutyCycle 0 127.5 percent
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x5D, 0x00, 0x00, 0x00     ;Point 1
    .byte 0x7D, 0x00, 0x00, 0xF8     ;Point 2
    .byte 0x9C, 0x1E                 ;Point 3
        
	;.org	0x8817
VNTDCL_MAPBelowBaroForDecelDetermination:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x158A
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MAPBelowBaroForDecelDetermination
    ;mptblcname VNTDCL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x19                       ;Point 1

	;.org	0x8818
VNTVAC_VNTActuatorDutyCycleFromVacBelowThreshold:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x1598
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname VNTActuatorDutyCycleFromVacBelowThreshold
    ;mptblcname VNTVAC
    ;mpxaxis MAP 0 44.1 psi
    ;mpyaxis VNTDC 0 127.5 percent
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x01, 0x00, 0x00, 0x25     ;Point 1
    .byte 0x32, 0x07                 ;Point 2

	;.org	0x881f
WGTVAC_WastegateDutyCycleFromVacBelowThreshold:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x15A8
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname WastegateDutyCycleFromVacBelowThreshold
    ;mptblcname WGTVAC
    ;mpxaxis MAP 0 44.1 psi
    ;mpyaxis WGDC 0 127.5 percent
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x01, 0x0D, 0x00, 0xD1     ;Point 1
    .byte 0x32, 0x35                 ;Point 2

	;.org	0x8826
VNTBLM_BoostLimitForNormalVNTControl:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x15B8
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BoostLimitForNormalVNTControl
    ;mptblcname VNTBLM
    ;mpxaxis in 0 255 in
    ;mpyaxis MAP 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x09                       ;Point 1

	;.org	0x8827
VNTWOT_VNTFullThrottleDutyCycle:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x15C6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname VNTFullThrottleDutyCycle
    ;mptblcname VNTWOT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis VNTDC 0 127.5 percent
    ;mptbldesc Detailed_Description
    .byte 0xC8                       ;Point 1

	;.org	0x8828
VNTDC_VNTDutyCycleFromBoost:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x15D3
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname VNTDutyCycleFromBoost
    ;mptblcname VNTDC
    ;mpxaxis Boost 0 44.1 psi
    ;mpyaxis VNTDC 0 127.5 percent
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x0D, 0x07, 0x07, 0x00     ;Point 1
    .byte 0x1F, 0x85                 ;Point 2

	;.org	0x882f
WGDCVN_WGDCFromVNTDutyCycle:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x15E3
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname WGDCFromBoost
    ;mptblcname WGDCVN
    ;mpxaxis Boost 0 44.1 psi
    ;mpyaxis VNTDC 0 127.5 percent
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x0D, 0x35, 0x01, 0xE4     ;Point 1
    .byte 0x1F, 0x57                 ;Point 2

	;.org	0x8836
VNTDCW_VNTFullThrottleWastegateDutyCycle:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x15F3
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname VNTFullThrottleWastegateDutyCycle
    ;mptblcname VNTDCW
    ;mpxaxis Boost 0 44.1 psi
    ;mpyaxis VNTDC 0 127.5 percent
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x04, 0x64, 0xFF, 0x00     ;Point 1
    .byte 0x1F, 0x49                 ;Point 2

	;.org	0x883d
L883E_L883e:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x1603
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname L883E_L883e
    ;mptblcname L883E
    ;mpxaxis in_desc 11 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1
    .byte 0x5A                       ;Point 2
    .byte 0x34                       ;Point 3
    .byte 0x22                       ;Point 4
    .byte 0x11                       ;Point 5
    .byte 0x1C                       ;Point 6
    .byte 0x41                       ;Point 7
    .byte 0x01                       ;Point 8
    .byte 0x40                       ;Point 9
    .byte 0xFF                       ;Point 10
    .byte 0xFF                       ;Point 11

	;.org	0x8848
VNTLMP_BoostFromRPMForVNTLimpInMode:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x161A
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BoostFromRPMForVNTLimpInMode
    ;mptblcname VNTLMP
    ;mpxaxis Boost 0 44.1 psi
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x71, 0x58, 0xFC, 0x2B     ;Point 1
    .byte 0x7D, 0x2A                 ;Point 2

	;.org   0x8857
RPMMP2_SwitchPointForDownUp_FromRpm2 :
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x162A
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname SwitchPointForDownUp_FromRpm2
    ;mptblcname RPMMP2
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc EPP_Control_toggle
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x4D, 0x6B, 0xFE, 0x8C     ;Point 1
    .byte 0x6E, 0x3B                 ;Point 2

	;.org	0x886a
VLMPMN_MinimumBoostSetpointForVNTLimpinMode:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x163A
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MinimumBoostSetpointForVNTLimpinMode
    ;mptblcname VLMPMN
    ;mpxaxis Boost 0 44.1 psi
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    ;mpmapaxis x
    .byte 0x19                       ;Point 1

	;.org	0x886b
VNTRMX_MaximumRPMForVNTLimpInControl:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x1648
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaximumRPMForVNTLimpInControl
    ;mptblcname VNTRMX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0xBC                       ;Point 1

;       .byte  0x00,0x01,0xff

	;.org	0x886f
BRPMLO_BaroReadLowRPM1800:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x1657
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname BaroReadLowRPM1800
    ;mptblcname BRPMLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .word 0x3840                     ;Point 1

	;.org	0x8871
BRPMHI_BaroReadHighRPM6650:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x1664
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname BaroReadHighRPM6650
    ;mptblcname BRPMHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .word 0xCFD0                     ;Point 1

	;.org	0x8873
BRDLAY_BaroReadDelayAfterThrottleClosed2sec:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x1671
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadDelayAfterThrottleClosed2sec
    ;mptblcname BRDLAY
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Detailed_Description
    .byte 0xB5                       ;Point 1

	;.org	0x8874
BARTIM_BaroReadMinTimeBetweenReadings179sec:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x167E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadMinTimeBetweenReadings179sec
    ;mptblcname BARTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 720 sec
    ;mptbldesc Detailed_Description
    .byte 0x40                       ;Point 1

	;.org	0x8875
BROPTM_BaroReadDelayAfterSolenoidOpenTenthSec:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x168B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadDelayAfterSolenoidOpenTenthSec
    ;mptblcname BROPTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Detailed_Description
    .byte 0x09                       ;Point 1

	;.org	0x8876
BRCLTM_BaroReadDelayAfterSolenoidClosedTenthSec:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x1698
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadDelayAfterSolenoidClosedTenthSec
    ;mptblcname BRCLTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Detailed_Description
    .byte 0x09                       ;Point 1

	;.org	0x8877
BAROHI_BaroReadValidHighLimit:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x16A5
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BaroReadValidHighLimit
    ;mptblcname BAROHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x59                       ;Point 1

	;.org	0x8878
BAROLO_BaroReadValidLowLimit:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x16B3
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BaroReadValidLowLimit
    ;mptblcname BAROLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x2E                       ;Point 1

	;.org	0x8879
BARDFT_BaroReadDefaultValue:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x16C1
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BaroReadDefaultValue
    ;mptblcname BARDFT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x55                       ;Point 1

	;.org	0x887a
FANTMP1_FanTurnOnTempAbove45Mph:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x16CF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOnTempAbove45Mph
    ;mptblcname FANTMP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc Detailed_Description3
    .byte 0xE2                       ;Point 1

	;.org	0x887b
FANTMP2_FanTurnOffTempAbove45Mph:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x16DC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOffTempAbove45Mph
    ;mptblcname FANTMP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc Detailed_Description3
    .byte 0xDD                       ;Point 1

	;.org	0x887c
FANTMP3_FanTurnOnTempBelow35Mph:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x16E9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOnTempBelow35Mph
    ;mptblcname FANTMP3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc Detailed_Description3
    .byte 0xDD                       ;Point 1

	;.org	0x887d
FANTMP4_FanTurnOffTempBelow35Mph:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x16F6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOffTempBelow35Mph
    ;mptblcname FANTMP4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc Detailed_Description3
    .byte 0xD7                       ;Point 1

	;.org	0x887e
FANMAP_FanTurnsOnWhenMapAboveBaroPlusThis:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x1703
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname FanTurnsOnWhenMapAboveBaroPlusThis
    ;mptblcname FANMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x17                       ;Point 1

	;.org	0x887f
FANBAT_FanTurnsOnWhenBatteryTempAboveThis:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x1711
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnsOnWhenBatteryTempAboveThis
    ;mptblcname FANBAT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Battery_Temp -200 260 Degrees
    ;mptbldesc Detailed_Description
    .byte 0xBB                       ;Point 1



FNSPHI_FanControlSpeedHi:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x171F
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
    ;mptbladdr 0x172B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanControlSpeedLo
    ;mptblcname FNSPLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 1020 MPH
    ;mptbldesc Detailed_Description
    .byte 0x09                       ;Point 1

	;.org	0x8880
PURMAP_CannisterPurgeWhenBelowThisBaro:
    ;mpgrp 7_-_Aux_Functions\Purge_Control\
    ;mptbladdr 0x1738
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname CannisterPurgeWhenBelowThisBaro
    ;mptblcname PURMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x03                       ;Point 1

	;.org	0x8881
PURHYS_CannisterPurgeBaroHysteresis:
    ;mpgrp 7_-_Aux_Functions\Purge_Control\
    ;mptbladdr 0x1746
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname CannisterPurgeBaroHysteresis
    ;mptblcname PURHYS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

	;.org	0x8882
PURTMP_CanisterPurgeCoolantTemp:
    ;mpgrp 7_-_Aux_Functions\Purge_Control\
    ;mptbladdr 0x1754
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CanisterPurgeCoolantTemp
    ;mptblcname PURTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xB6                       ;Point 1

	;.org	0x8883
CL2PTR_Cyl2AdaptiveMemoryPointer:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Individual_Cylinder_Trim\
    ;mptbladdr 0x1761
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl2AdaptiveMemoryPointer
    ;mptblcname CL2PTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0D                       ;Point 1

	;.org	0x8884
CL1PTR_Cyl1AdaptiveMemoryPointer:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Individual_Cylinder_Trim\
    ;mptbladdr 0x176E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl1AdaptiveMemoryPointer
    ;mptblcname CL1PTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Point 1

	;.org	0x8885
CL3PTR_Cyl3AdaptiveMemoryPointer:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Individual_Cylinder_Trim\
    ;mptbladdr 0x177B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl3AdaptiveMemoryPointer
    ;mptblcname CL3PTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1

	;.org	0x8886
CL4PTR_Cyl4AdaptiveMemoryPointer:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Individual_Cylinder_Trim\
    ;mptbladdr 0x1788
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl4AdaptiveMemoryPointer
    ;mptblcname CL4PTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Point 1

	;.org	0x8887
CL2LMT_Cyl2TrimLimit:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Individual_Cylinder_Trim\
    ;mptbladdr 0x1795
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl2TrimLimit
    ;mptblcname CL2LMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x33                       ;Point 1

	;.org	0x8888
CL1LMT_Cyl1TrimLimit:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Individual_Cylinder_Trim\
    ;mptbladdr 0x17A2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl1TrimLimit
    ;mptblcname CL1LMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x33                       ;Point 1

	;.org	0x8889
CL3LMT_Cyl3TrimLimit:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Individual_Cylinder_Trim\
    ;mptbladdr 0x17AF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl3TrimLimit
    ;mptblcname CL3LMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x33                       ;Point 1

	;.org	0x888a
CL4LMT_Cyl4TrimLimit:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Individual_Cylinder_Trim\
    ;mptbladdr 0x17BC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl4TrimLimit
    ;mptblcname CL4LMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x33                       ;Point 1

	;.org	0x888b
CL2INC_Cyl2TrimIncrement:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Individual_Cylinder_Trim\
    ;mptbladdr 0x17C9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl2TrimIncrement
    ;mptblcname CL2INC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Point 1

	;.org	0x888c
CL1INC_Cyl1TrimIncrement:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Individual_Cylinder_Trim\
    ;mptbladdr 0x17D6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl1TrimIncrement
    ;mptblcname CL1INC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Point 1

	;.org	0x888d
CL3INC_Cyl3TrimIncrement:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Individual_Cylinder_Trim\
    ;mptbladdr 0x17E3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl3TrimIncrement
    ;mptblcname CL3INC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Point 1

	;.org	0x888e
CL4INC_Cyl4TrimIncrement:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Individual_Cylinder_Trim\
    ;mptbladdr 0x17F0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl4TrimIncrement
    ;mptblcname CL4INC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Point 1

	;.org	0x888f
CLTRMN_MinimumCylinderTrim:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Individual_Cylinder_Trim\
    ;mptbladdr 0x17FD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumCylinderTrim
    ;mptblcname CLTRMN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x07                       ;Point 1

	;.org	0x8890
CLTRP2_Cyl2TrimValueForPurgeVolume:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Individual_Cylinder_Trim\
    ;mptbladdr 0x180A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl2TrimValueForPurgeVolume
    ;mptblcname CLTRP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x20                       ;Point 1

	;.org	0x8891
CLTRP1_Cyl1TrimValueForPurgeVolume:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Individual_Cylinder_Trim\
    ;mptbladdr 0x1817
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl1TrimValueForPurgeVolume
    ;mptblcname CLTRP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x12                       ;Point 1

	;.org	0x8892
CLTRP3_Cyl3TrimValueForPurgeVolume:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Individual_Cylinder_Trim\
    ;mptbladdr 0x1824
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl3TrimValueForPurgeVolume
    ;mptblcname CLTRP3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFE                       ;Point 1

	;.org	0x8893
CLTRP4_Cyl4TrimValueForPurgeVolume:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Individual_Cylinder_Trim\
    ;mptbladdr 0x1831
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Cyl4TrimValueForPurgeVolume
    ;mptblcname CLTRP4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x84                       ;Point 1

	;.org	0x8894
ACLRPM_DisableAcBelowThisRPM_500:
    ;mpgrp 7_-_Aux_Functions\AC_Control\
    ;mptbladdr 0x183E
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DisableAcBelowThisRPM_500
    ;mptblcname ACLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0FA0                     ;Point 1

	;.org	0x8896
ACOUT_DeltaAboveMinThrottleToCutOutAc:
    ;mpgrp 7_-_Aux_Functions\AC_Control\
    ;mptbladdr 0x184B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaAboveMinThrottleToCutOutAc
    ;mptblcname ACOUT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x8A                       ;Point 1

	;.org	0x8897
ACCRPM_DoNotAllowAcToEngageAboveThisRPM_4000:
    ;mpgrp 7_-_Aux_Functions\AC_Control\
    ;mptbladdr 0x1858
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DoNotAllowAcToEngageAboveThisRPM_4000
    ;mptblcname ACCRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x7D00                     ;Point 1

	;.org	0x8899
ACCTIM_AcDelayFromStartRunTransfer:
    ;mpgrp 7_-_Aux_Functions\AC_Control\
    ;mptbladdr 0x1865
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcDelayFromStartRunTransfer
    ;mptblcname ACCTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1

	;.org	0x889a
ACCNTI_ACCounterInitial:
    ;mpgrp 7_-_Aux_Functions\AC_Control\
    ;mptbladdr 0x1872
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ACCounterInitial
    ;mptblcname ACCNTI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x06                       ;Point 1

	;.org	0x889b
WOTDLT_DeltaThrottleFrom_MINTHR_ToDetermineFullThrottle:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x187F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaThrottleFrom_MINTHR_ToDetermineFullThrottle
    ;mptblcname WOTDLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x85                       ;Point 1

	;.org	0x889c
UNLOAD_DeltaThrottleFrom_MINTHR_ToUnloadCrankingFuel:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x188C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaThrottleFrom_MINTHR_ToUnloadCrankingFuel
    ;mptblcname UNLOAD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x85                       ;Point 1

	;.org	0x889d
VACREG_CruiseControlVacRegularGainGurve_FromDeltaSpeed:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1899
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlVacRegularGainGurve_FromDeltaSpeed
    ;mptblcname VACREG
    ;mpxaxis Delta_Speed 0 127.5 mph
    ;mpyaxis AccRate 0 5 mph/sec
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x02, 0x00, 0x0E     ;Point 1
    .byte 0x24, 0x04, 0x00, 0x10     ;Point 2
    .byte 0xFF, 0x12                 ;Point 3

	;.org	0x88b4
VACACC_CruiseControlVacAcceleratedGainCurve_FromDeltaSpeed:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x18A9
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlVacAcceleratedGainCurve_FromDeltaSpeed
    ;mptblcname VACACC
    ;mpxaxis Delta_Speed 0 127.5 mph
    ;mpyaxis AccRate 0 5 mph/sec
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x02, 0x00, 0x78     ;Point 1
    .byte 0x40, 0x20, 0x00, 0x0E     ;Point 2
    .byte 0xFD, 0x2A                 ;Point 3

	;.org	0x88c3
VENTRG_CruiseControlVentRegularGainCurve_FromDeltaSpeed:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x18B9
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlVentRegularGainCurve_FromDeltaSpeed
    ;mptblcname VENTRG
    ;mpxaxis Delta_Speed 0 127.5 mph
    ;mpyaxis AccRate 0 5 mph/sec
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Number of points in table
    .byte 0x00, 0x02, 0xFF, 0xF2     ;Point 1
    .byte 0x12, 0x01, 0xFF, 0xE6     ;Point 2
    .byte 0x1C, 0x00, 0xFF, 0xF7     ;Point 3
    .byte 0xFF, 0xF8                 ;Point 4

	;.org	0x88d2
CRUZ1_UknownTableForCruiseControl1:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x18CA
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname UknownTableForCruiseControl1
    ;mptblcname CRUZ1
    ;mpxaxis in 0 255 in
    ;mpyaxis out 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x00, 0xE0, 0xFF, 0xC0     ;Point 1
    .byte 0xC0, 0xB0                 ;Point 2

	;.org	0x88e1
CRUZ2_UknownTableForCruiseControl2:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x18D9
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

	;.org	0x88ec
CRUZ3_UknownTableForCruiseControl3:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x18E8
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname UknownTableForCruiseControl3
    ;mptblcname CRUZ3
    ;mpxaxis in 0 255 in
    ;mpyaxis out 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x78, 0x80, 0x03, 0xF8     ;Point 1
    .byte 0x98, 0xFF                 ;Point 2

	;.org	0x88f7
CRUZ4_UknownTableForCruiseControl4:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x18F7
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname UknownTableForCruiseControl4
    ;mptblcname CRUZ4
    ;mpxaxis in 0 255 in
    ;mpyaxis out 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x33, 0x06, 0xFF, 0xE8     ;Point 1
    .byte 0x68, 0x01                 ;Point 2

	;.org	0x8902
CRUZ5_UknownTableForCruiseControl5:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1906
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

	;.org	0x890d
SETPW_CruiseControlSetupPulseForSet_FromSpeed:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1915
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

	;.org	0x891c
RESTBL_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1926
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference
    ;mptblcname RESTBL
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis AbsMAP 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x06                       ;Number of points in table
    .byte 0x1A, 0x4F, 0x00, 0x1B     ;Point 1
    .byte 0x53, 0x55, 0x00, 0x49     ;Point 2
    .byte 0x6F, 0x5D, 0x00, 0xA0     ;Point 3
    .byte 0x87, 0x6C, 0x00, 0x00     ;Point 4
    .byte 0x9A, 0x6C, 0xFE, 0x20     ;Point 5
    .byte 0xA2, 0x5D                 ;Point 6

	;.org	0x8933
RESTBL2_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference2:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x193A
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

	;.org	0x8952
THGAIN_CruiseControlThrottleGainFactor_FromThrottle:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x194B
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlThrottleGainFactor_FromThrottle
    ;mptblcname THGAIN
    ;mpxaxis TPS 0 255 tps
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Number of points in table
    .byte 0x01, 0x08, 0x0C, 0x00     ;Point 1
    .byte 0x03, 0x20                 ;Point 2

	;.org	0x895d
SPGAIN_CruiseControlSpeedGainFactor_FromSpeed:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x195A
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlSpeedGainFactor_FromSpeed
    ;mptblcname SPGAIN
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Number of points in table
    .byte 0x3C, 0x14, 0xFF, 0x9A     ;Point 1
    .byte 0x6E, 0x00, 0x00, 0xF3     ;Point 2
    .byte 0x94, 0x24                 ;Point 3

	;.org	0x8968
CRUZ6_UknownTableForCruiseControl6:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x196A
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

	;.org	0x8973
CRUZ7_UknownTableForCruiseControl7:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1979
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownTableForCruiseControl7
    ;mptblcname CRUZ7
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x8974
VNTAB1_CruiseControlLimitToAMaxVent:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1986
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlLimitToAMaxVent
    ;mptblcname VNTAB1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x90                       ;Point 1

	;.org	0x8975
VNTAB2_CruiseControlLimitToHalfMaxVent:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1993
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlLimitToHalfMaxVent
    ;mptblcname VNTAB2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x60                       ;Point 1

	;.org	0x8976
CRUZ46_UknownConstForCruiseControl46:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x19A0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl46
    ;mptblcname CRUZ46
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x09                       ;Point 1

	;.org	0x8977
CRUZ47_UknownConstForCruiseControl47:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x19AD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl47
    ;mptblcname CRUZ47
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x2F                       ;Point 1

	;.org	0x8978
ACLRST_CruiseControlDeltaSpeedToResetAccFlag:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x19BA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlDeltaSpeedToResetAccFlag
    ;mptblcname ACLRST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x18                       ;Point 1

	;.org	0x8979
CLOTHR_CruiseControlDontVentIfThrottleBelowThis:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x19C7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlDontVentIfThrottleBelowThis
    ;mptblcname CLOTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x897a
MAXTHR_CruiseControlDontVacIfThrottleAboveThis:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x19D4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlDontVacIfThrottleAboveThis
    ;mptblcname MAXTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x66                       ;Point 1

	;.org	0x897b
MAXSET_CruiseControlMaxSetSpeedTimesTwo:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x19E1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlMaxSetSpeedTimesTwo
    ;mptblcname MAXSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 127.5 mph
    ;mptbldesc Detailed_Description
    .byte 0xAA                       ;Point 1

	;.org	0x897c
MINSET_CruiseControlMinSetSpeedTimesTwo:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x19EE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlMinSetSpeedTimesTwo
    ;mptblcname MINSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 127.5 mph
    ;mptbldesc Detailed_Description
    .byte 0x46                       ;Point 1

	;.org	0x897d
SCNVHI_CruiseControlForBrakeFlagManualTransmissionClutchDisableHi:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x19FB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlForBrakeFlagManualTransmissionClutchDisable_Hi
    ;mptblcname SCNVHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x897e
SCNVLO_CruiseControlForBrakeFlagManualTransmissionClutchDisableLo:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1A08
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlForBrakeFlagManualTransmissionClutchDisable_Lo
    ;mptblcname SCNVLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x52                       ;Point 1

	;.org	0x897f
CRUZ21_UknownConstForCruiseControl21:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1A15
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl21
    ;mptblcname CRUZ21
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x3C                       ;Point 1

	;.org	0x8980
CRUZ22_UknownConstForCruiseControl22:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1A22
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl22
    ;mptblcname CRUZ22
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xBC                       ;Point 1

	;.org	0x8981
CRUZ23_UknownConstForCruiseControl23:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1A2F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl23
    ;mptblcname CRUZ23
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x06                       ;Point 1
 
CRUZ2x_UknownConstForCruiseControl2x:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1A3B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl2x
    ;mptblcname CRUZ2X
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1

CRUZ2y_UknownConstForCruiseControl2y:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1A47
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl2y
    ;mptblcname CRUZ2Y
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xBA                       ;Point 1

	;.org	0x8984
CRUZ24_UknownConstForCruiseControl24:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1A54
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl24
    ;mptblcname CRUZ24
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x8985
CRUZ25_UknownConstForCruiseControl25:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1A61
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl25
    ;mptblcname CRUZ25
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x30                       ;Point 1

	;.org	0x8986
CRUZ26_UknownConstForCruiseControl26:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1A6E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl26
    ;mptblcname CRUZ26
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

	;.org	0x8987
CRUZ27_UknownConstForCruiseControl27:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1A7B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl27
    ;mptblcname CRUZ27
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x8988
CRUZ28_UknownConstForCruiseControl28:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1A88
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl28
    ;mptblcname CRUZ28
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x8989
CRUZ29_UknownConstForCruiseControl29:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1A95
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl29
    ;mptblcname CRUZ29
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x898a
CRUZ30_UknownConstForCruiseControl30:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1AA2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl30
    ;mptblcname CRUZ30
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

	;.org	0x898b
CRUZ31_UknownConstForCruiseControl31:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1AAF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl31
    ;mptblcname CRUZ31
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x34                       ;Point 1

	;.org	0x898c
CRUZ32_UknownConstForCruiseControl32:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1ABC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl32
    ;mptblcname CRUZ32
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x08                       ;Point 1

	;.org	0x898d
CRUZ33_UknownConstForCruiseControl33:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1AC9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl33
    ;mptblcname CRUZ33
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x898e
CRUZ34_UknownConstForCruiseControl34:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1AD6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl34
    ;mptblcname CRUZ34
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x20                       ;Point 1

	;.org	0x898f
CRUZ35_UknownConstForCruiseControl35:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1AE3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl35
    ;mptblcname CRUZ35
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0C                       ;Point 1

	;.org	0x8990
CRUZ36_UknownConstForCruiseControl36:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1AF0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownConstForCruiseControl36
    ;mptblcname CRUZ36
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x8C                       ;Point 1

	;.org	0x8991
SETDLT_CruiseControlSetDeltaControlPointForCableAdaptive:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1AFD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlSetDeltaControlPointForCableAdaptive
    ;mptblcname SETDLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x8992
CRSCN2_CruiseComapreConstant2:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1B0A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseComapreConstant2
    ;mptblcname CRSCN2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x06                       ;Point 1

	;.org	0x8993
CRMSK2_CruiseMask2:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1B17
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask2
    ;mptblcname CRMSK2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x07                       ;Point 1

	;.org	0x8994
CRMSK3_CruiseMask3:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1B24
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask3
    ;mptblcname CRMSK3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xF6                       ;Point 1

	;.org	0x8995
CRMSK7_CruiseMask7:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1B31
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask7
    ;mptblcname CRMSK7
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x8996
CRMSK4_CruiseMask4:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1B3E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask4
    ;mptblcname CRMSK4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

	;.org	0x8997
CRMSK6_CruiseMask6:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1B4B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask6
    ;mptblcname CRMSK6
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x1F                       ;Point 1

	;.org	0x8998
CRMSK5_CruiseMask5:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1B58
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask5
    ;mptblcname CRMSK5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xE1                       ;Point 1

	;.org	0x8999
CRSCN1_CruiseComapreConstant1:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1B65
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseComapreConstant1
    ;mptblcname CRSCN1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x16                       ;Point 1

	;.org	0x899a
CRMASK_CruiseMask:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1B72
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask
    ;mptblcname CRMASK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x11                       ;Point 1

	;.org	0x899b
PTUMTP_PTUMinLockTemperature:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Entry_Conditions\
    ;mptbladdr 0x1B7F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUMinLockTemperature
    ;mptblcname PTUMTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc Min_temp_for_PTU_lock
    .byte 0xFF                       ;Point 1

	;.org	0x899c
PTUMSP_PTUMinLockSpeed:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Entry_Conditions\
    ;mptbladdr 0x1B8C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUMinLockSpeed
    ;mptblcname PTUMSP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 127.5 mph
    ;mptbldesc Min_Speed_for_PTU_lock
    .byte 0x5B                       ;Point 1

	;.org	0x899d
PTUCNH_PTUCounterHiSpeed:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Hysteresis\
    ;mptbladdr 0x1B99
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUCounterHiSpeed
    ;mptblcname PTUCNH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x5B                       ;Point 1

	;.org	0x899e
PTUCNL_PTUCounterLoSpeed:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Hysteresis\
    ;mptbladdr 0x1BA6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUCounterLoSpeed
    ;mptblcname PTUCNL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x5B                       ;Point 1

	;.org	0x899f
PTUDTP_PTUDeltaTPSForUnlock:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Hysteresis\
    ;mptbladdr 0x1BB3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUDeltaTPSForUnlock
    ;mptblcname PTUDTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Delta_TPS 0 5 V
    ;mptbldesc Min_TPS_for_PTU_unlock
    .byte 0x34                       ;Point 1

	;.org	0x89a0
PTUMP1_PTUMAPThresholdForLock1:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Entry_Conditions\
    ;mptbladdr 0x1BC0
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname PTUMAPThresholdForLock1
    ;mptblcname PTUMP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Delta_MAP 0 44.1 PSI
    ;mptbldesc Delta_MAP_for_PTU_unlock
    ;mpmapaxis y
    .byte 0x50                       ;Point 1

	;.org	0x89a1
PTUMP2_PTUMAPThresholdForLock2:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Entry_Conditions\
    ;mptbladdr 0x1BCE
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname PTUMAPThresholdForLock2
    ;mptblcname PTUMP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis deltaMAP 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x39                       ;Point 1

	;.org	0x89a2
PTUMP3_PTUMAPThresholdForLock3:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Entry_Conditions\
    ;mptbladdr 0x1BDC
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname PTUMAPThresholdForLock3
    ;mptblcname PTUMP3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Delta_MAP 0 44.1 PSI
    ;mptbldesc Delta_MAP_for_PTU_unlock
    ;mpmapaxis y
    .byte 0x50                       ;Point 1

	;.org	0x89a3
PTUCNI_PTUCounterTimerIntervalForLoop:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Entry_Conditions\
    ;mptbladdr 0x1BEA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUCounterTimerIntervalForLoop
    ;mptblcname PTUCNI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x07                       ;Point 1

	;.org	0x89a4
PTUUUL_UpperLimitForPTUUnlock:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\TPS_Limits_for_Lockup\
    ;mptbladdr 0x1BF7
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname UpperLimitForPTUUnlock
    ;mptblcname PTUUUL
    ;mpxaxis Speed 0 128 Speed
    ;mpyaxis Delta_TPS 0 5 Volts
    ;mptbldesc Primary_engagnement_point_for_PTU
    .byte 0x04                       ;Number of points in table
    .byte 0x44, 0x04, 0x09, 0x40     ;Point 1
    .byte 0x48, 0x29, 0x00, 0xAB     ;Point 2
    .byte 0x5A, 0x35, 0x0A, 0xCD     ;Point 3
    .byte 0x64, 0xA1                 ;Point 4

	;.org	0x89b7
PTUULL_LowerLimitForPTUUnlock:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\TPS_Limits_for_Lockup\
    ;mptbladdr 0x1C08
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname LowerLimitForPTUUnlock
    ;mptblcname PTUULL
    ;mpxaxis Speed 0 128 Speed
    ;mpyaxis Delta_TPS 0 5 Volts
    ;mptbldesc Primary_disengagnement_point_for_PTU
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x04                 ;Point 1

	;.org	0x89c2
PTULUL_UpperLimitForPTULock:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\TPS_Limits_for_Lockup\
    ;mptbladdr 0x1C16
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname UpperLimitForPTULock
    ;mptblcname PTULUL
    ;mpxaxis Speed 0 128 Speed
    ;mpyaxis Delta_TPS 0 5 Volts
    ;mptbldesc Secondary_engagnement_point_for_PTU
    .byte 0x04                       ;Number of points in table
    .byte 0x48, 0x06, 0x06, 0x80     ;Point 1
    .byte 0x4C, 0x20, 0x00, 0x80     ;Point 2
    .byte 0x6E, 0x31, 0x0B, 0x33     ;Point 3
    .byte 0x78, 0xA1                 ;Point 4

	;.org	0x89d5
PTULLL_LowerLimitForPTULock:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\TPS_Limits_for_Lockup\
    ;mptbladdr 0x1C27
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname LowerLimitForPTULock
    ;mptblcname PTULLL
    ;mpxaxis Speed 0 128 Speed
    ;mpyaxis Delta_TPS 0 5 Volts
    ;mptbldesc Secondary_disengagnement_point_for_PTU
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x06                 ;Point 1

	;.org	0x89e0
MININC_Amount_MINTHR_IsIncreasedAtKeyOnOnly:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x1C35
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Amount_MINTHR_IsIncreasedAtKeyOnOnly
    ;mptblcname MININC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Point 1

	;.org	0x89e1
MAPTHR_ThrottleSelfCalibrationMapDeltaThreshold:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x1C42
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname ThrottleSelfCalibrationMapDeltaThreshold
    ;mptblcname MAPTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x21                       ;Point 1

	;.org	0x89e2
RPMTHR_ThrottleSelfCalibrationRpmThreshold:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x1C50
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleSelfCalibrationRpmThreshold
    ;mptblcname RPMTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x30                       ;Point 1

	;.org	0x89e3
MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x1C5D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ValueOf_MINTHR_WhenBatteryDisconnected
    ;mptblcname MTHRMX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x5C                       ;Point 1

	;.org	0x89e4
MAXCNT_ProgramLoopsWithThrottleBelow_MINTHR_ToDecrement_MINTHR:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x1C6A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ProgramLoopsWithThrottleBelow_MINTHR_ToDecrement_MINTHR
    ;mptblcname MAXCNT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1

	;.org	0x89e5
MTHRCL_NumberOfBitsAbove_MINTHR_ToDetermineOnThrottleTransition:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x1C77
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NumberOfBitsAbove_MINTHR_ToDetermineOnThrottleTransition
    ;mptblcname MTHRCL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

	;.org	0x89e6
MTHROP_NumberOfBitsAbove_MINTHR_ToDetermineOffThrottleTransition:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x1C84
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NumberOfBitsAbove_MINTHR_ToDetermineOffThrottleTransition
    ;mptblcname MTHROP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x89e7
EGR1_ExhGasRecircConst:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1C91
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst1
    ;mptblcname EGR1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x01C6                     ;Point 1

	;.org	0x89e9
EGR3_ExhGasRecircConst3:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1C9E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst3
    ;mptblcname EGR3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x28                       ;Point 1

	;.org	0x89ea
EGR18_ExhGasRecircConstLoLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1CAB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstLoLimit18
    ;mptblcname EGR18
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x89eb
EGR18a_ExhGasRecircConstHiLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1CB8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstHiLimit18a
    ;mptblcname EGRR18A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x89ec
EGR16_ExhGasRecircConstLoLimit16:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1CC5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstLoLimit16
    ;mptblcname EGR16
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x89ed
EGR16a_ExhGasRecircConstHiLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1CD2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstHiLimit16a
    ;mptblcname EGR16A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x89ee
EGR14_ExhGasRecircConstFromTPSVoltsLoLimit14:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1CDF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromTPSVoltsLoLimit14
    ;mptblcname EGR14
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x89ef
EGR14a_ExhGasRecircConstFromTPSVoltsHiLimit14a:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1CEC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromTPSVoltsHiLimit14a
    ;mptblcname EGR14A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x89f0
EGR19_ExhGasRecircConstLoLimit19:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1CF9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstLoLimit19
    ;mptblcname EGR19
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x89f1
EGR19a_ExhGasRecircConstHiLimit19a:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1D06
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstHiLimit19a
    ;mptblcname EGR19A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x89f2
EGR15_ExhGasRecircConstFromRPMLoLimit15:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1D13
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromRPMLoLimit15
    ;mptblcname EGR15
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x89f3
EGR17_ExhGasRecircConstLoLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1D20
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstLoLimit17
    ;mptblcname EGR17
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x89f4
EGR17a_ExhGasRecircConstHiLimit17a:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1D2D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstHiLimit17a
    ;mptblcname EGR17A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x89f6
EGR4_ExhGasRecircConst4:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1D3A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst4
    ;mptblcname EGR4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xEB                       ;Point 1
;	.byte	0xff

	;.org	0x89f7
EGR5_ExhGasRecircConst5:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1D48
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst5
    ;mptblcname EGR5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x89f8
EGR6_ExhGasRecircConst6:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1D55
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst6
    ;mptblcname EGR6
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x89f9
EGR15a_ExhGasRecircConstFromRPMHiLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1D62
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromRPMHiLimit15a
    ;mptblcname EGR15A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x6C                       ;Point 1

	;.org	0x89fa
EGR7_ExhGasRecircConst7:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1D6F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst7
    ;mptblcname EGR7
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x14                       ;Point 1

	;.org	0x89fb
SCRMP1_SecondaryRampSubtractor1:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1D7C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SecondaryRampSubtractor1
    ;mptblcname SCRMP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1

	;.org	0x89fc
ADMEMA_ValueFromAdaptivememoryAdder1:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1D89
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ValueFromAdaptivememoryAdder1
    ;mptblcname ADMEMA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

	;.org	0x89fd
EGR8_ExhGasRecircConst8:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1D96
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst8
    ;mptblcname EGR8
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0D                       ;Point 1

	;.org	0x89fe
EGR8a_ExhGasRecircConst8a:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1DA3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst8a
    ;mptblcname EGR8A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x89ff
EGR2_ExhGasRecircConstFromMAPBelowBaro:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1DB0
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname ExhGasRecircConstFromMAPBelowBaro2
    ;mptblcname EGR2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x0F                       ;Point 1

	;.org	0x8a00
EGR9_ExhGasRecircConstFromTimeEngRunning9:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1DBE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromTimeEngRunning9
    ;mptblcname EGR9
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x6B                       ;Point 1

	;.org	0x8a01
EGR21_ExhGasRecircConstFromRPM1:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1DCB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromRPM1
    ;mptblcname EGR21
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFA                       ;Point 1

	;.org	0x8a02
EGR22_ExhGasRecircConstFromRPM2:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1DD8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromRPM2
    ;mptblcname EGR22
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x8a03
EGR23_ExhGasRecircConstFromMAP1:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1DE5
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname ExhGasRecircConstFromMAP1
    ;mptblcname EGR23
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0xA7                       ;Point 1

	;.org	0x8a04
EGR24_ExhGasRecircConstFromMAP2:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1DF3
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname ExhGasRecircConstFromMAP2
    ;mptblcname EGR24
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x02                       ;Point 1

	;.org	0x8a05
EGR25_ExhGasRecircConstFromBaro1:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1E01
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname ExhGasRecircConstFromBaro1
    ;mptblcname EGR25
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x00                       ;Point 1

	;.org	0x8a06
EGR26_ExhGasRecircConstFromBaro2:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1E0F
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname ExhGasRecircConstFromBaro2
    ;mptblcname EGR26
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x00                       ;Point 1

	;.org	0x8a07
EGR27_ExhGasRecircConstFromCoolantTemp:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1E1D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromCoolantTemp
    ;mptblcname EGR27
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFF                       ;Point 1

	;.org	0x8a08
LMPINN_LimpinTableForMapFromThrottle:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1E2A
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

	;.org	0x8a1f
MPLMOF_OffsetForCalcMapInMapLimpin:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1E3D
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OffsetForCalcMapInMapLimpin
    ;mptblcname MPLMOF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x15                       ;Point 1

	;.org	0x8a20
THROFF_OffsetAddedToCalcThrottle:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1E4B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OffsetAddedToCalcThrottle
    ;mptblcname THROFF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x0B                       ;Point 1

	;.org	0x8a21
OFSMID_OffsetForMAPOverIdle:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1E58
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OffsetForMAPOverIdle
    ;mptblcname OFSMID
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFE                       ;Point 1

	;.org	0x8a22
INCMID_IncrementForMAPOverIdle:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1E65
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname IncrementForMAPOverIdle
    ;mptblcname INCMID
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

	;.org	0x8a23
OFSRID_OffsetForRPMOverIdle:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1E72
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OffsetForRPMOverIdle
    ;mptblcname OFSRID
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xD0                       ;Point 1

	;.org	0x8a24
INCRID_IncrementForRPMOverIdle:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1E7F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname IncrementForRPMOverIdle
    ;mptblcname INCRID
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x8a25
MNRPO2_MinimumRPMOverIdleForO2Feedback:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x1E8C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumRPMOverIdleForO2Feedback
    ;mptblcname MNRPO2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xD0                       ;Point 1

	;.org	0x8a26
CTLMC1_CylinderTrimCounter1LimitFromCoolantTemp:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Individual_Cylinder_Trim\
    ;mptbladdr 0x1E99
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CylinderTrimCounter1LimitFromCoolantTemp
    ;mptblcname CTLMC1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x7F                 ;Point 1

	;.org	0x8a31
CTLMC2_CylinderTrimCounter2LimitFromCoolantTemp:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Individual_Cylinder_Trim\
    ;mptbladdr 0x1EA7
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CylinderTrimCounter2LimitFromCoolantTemp
    ;mptblcname CTLMC2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x7F                 ;Point 1

	;.org	0x8a3c
DFBFMD_DefaultBaseFuelModifierFromRPMOverIdle:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x1EB5
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DefaultBaseFuelModifierFromRPMOverIdle
    ;mptblcname DFBFMD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0x8a47
TMPLOW_OutOfRangeHotTooLowA2D:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1EC3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OutOfRangeHotTooLowA2D
    ;mptblcname TMPLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x1A                       ;Point 1

	;.org	0x8a48
TMPHIG_OutOfRangeColdTooHighA2D:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1ED0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OutOfRangeColdTooHighA2D
    ;mptblcname TMPHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFD                       ;Point 1

	;.org	0x8a49
DEFTMP_DefaultEngineTemp:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1EDD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DefaultEngineTemp
    ;mptblcname DEFTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis CoolantTemp -200 260 DegF
    ;mptbldesc Detailed_Description
    .byte 0xB2                       ;Point 1

	;.org	0x8a4a
BTLRPM_LowBatteryVoltageAtThisRpm1500:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1EEA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowBatteryVoltageAtThisRpm1500
    ;mptblcname BTLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x2E                       ;Point 1

	;.org	0x8a4b
CTLRPM_LowBatteryVoltageAtThisCoolantTemp:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1EF7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowBatteryVoltageAtThisCoolantTemp
    ;mptblcname CTLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xCD                       ;Point 1

	;.org	0x8a4c
BTLRPM2_LowBatteryVoltageAtThisRpm1500:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1F04
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowBatteryVoltageAtThisRpm1500_2
    ;mptblcname BTLRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x2E                       ;Point 1

	;.org	0x8a4d
AMBLOW_BattTempLowWhenHot:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1F11
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BattTempLowWhenHot
    ;mptblcname AMBLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x05                       ;Point 1

	;.org	0x8a4e
AMBHIG_BattTempHighWhenCold:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1F1E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BattTempHighWhenCold
    ;mptblcname AMBHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFA                       ;Point 1

	;.org	0x8a4f
CHGLOW_ChargeTempOutOfRangeLow:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1F2B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ChargeTempOutOfRangeLow
    ;mptblcname CHGLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x1A                       ;Point 1

	;.org	0x8a50
CHGHIG_ChargeTempOutOfRangeHigh:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1F38
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ChargeTempOutOfRangeHigh
    ;mptblcname CHGHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFD                       ;Point 1

	;.org	0x8a51
DEFCHG_DefaultChargeTemp_Limpin:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1F45
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DefaultChargeTemp_Limpin
    ;mptblcname DEFCHG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x95                       ;Point 1

	;.org	0x8a52
ERRRPM_RPMLimitforErrorCodeSetting:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1F52
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimitforErrorCodeSetting
    ;mptblcname ERRRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x38                       ;Point 1

	;.org	0x8a53
ERRMAP_MAPLimitforErrorCodeSetting:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1F5F
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MAPLimitforErrorCodeSetting
    ;mptblcname ERRMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x1D                       ;Point 1

	;.org	0x8a54
ERRTMP_CoolantTempLimitforErrorCodeSetting:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1F6D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CoolantTempLimitforErrorCodeSetting
    ;mptblcname ERRTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xA0                       ;Point 1

	;.org	0x8a55
THRLOW_ThrottleLowerLimit:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1F7A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleLowerLimit
    ;mptblcname THRLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x08                       ;Point 1

	;.org	0x8a56
THRHIG_ThrottleUpperLimit:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1F87
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleUpperLimit
    ;mptblcname THRHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xE4                       ;Point 1

	;.org	0x8a57
MPTHR_MapSwitchPointForFullThrottleOrIdle:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1F94
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MapSwitchPointForFullThrottleOrIdle
    ;mptblcname MPTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x45                       ;Point 1

	;.org	0x8a58
COILLO_LoLimitBatteryVoltsForCoilVerify:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1FA2
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname LoLimitBatteryVoltsForCoilVerify
    ;mptblcname COILLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x03                       ;Point 1

	;.org	0x8a59
COILHI_HiLimitBatteryVoltsForCoilVerify:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1FB0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HiLimitBatteryVoltsForCoilVerify
    ;mptblcname COILHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xBA                       ;Point 1

	;.org	0x8a5a
MAPLOW_MapSensorLowerLimit:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1FBD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapSensorLowerLimit
    ;mptblcname MAPLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x8a5b
MAPHIG_MapSensorUpperLimit:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1FCA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapSensorUpperLimit
    ;mptblcname MAPHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xEE                       ;Point 1

	;.org	0x8a5c
MPLTHR_ThrottleLevelAbove_MINTHR_ToMatureMapLimpin:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1FD7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleLevelAbove_MINTHR_ToMatureMapLimpin
    ;mptblcname MPLTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x42                       ;Point 1

	;.org	0x8a5d
MPDELT_DeltaMapThatChecksGood:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1FE4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaMapThatChecksGood
    ;mptblcname MPDELT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x8a5e
MPDELA_MatureMapLimpinWhenDeltaAbove_MPDELT_plus_MPDELA:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1FF1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MatureMapLimpinWhenDeltaAbove_MPDELT_plus_MPDELA
    ;mptblcname MPDELA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1

	;.org	0x8a5f
MPRPML_DisableMapCheckUnderThisRpm_600:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1FFE
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DisableMapCheckUnderThisRpm_600
    ;mptblcname MPRPML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x12C0                     ;Point 1

	;.org	0x8a61
MPRPMH_DisableMapCheckAboveThisRpm_1500:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x200B
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DisableMapCheckAboveThisRpm_1500
    ;mptblcname MPRPMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x2EE0                     ;Point 1

	;.org	0x8a63
MPDAGL_DisableMapCheckBelowThisMap:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x2018
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DisableMapCheckBelowThisMap
    ;mptblcname MPDAGL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x0B                       ;Point 1

	;.org	0x8a64
MPDAGH_DisableMapCheckAboveThisMap:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x2026
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DisableMapCheckAboveThisMap
    ;mptblcname MPDAGH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x56                       ;Point 1

	;.org	0x8a65
MPRMPD_CheckMapAtZeroSpeedAndThisDeltaRpm:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x2034
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname CheckMapAtZeroSpeedAndThisDeltaRpm
    ;mptblcname MPRMPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0200                     ;Point 1

	;.org	0x8a67
BAROSW_CheckMapAtZeroSpeedAndThisBaroSwitch:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x2041
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname CheckMapAtZeroSpeedAndThisBaroSwitch
    ;mptblcname BAROSW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x41                       ;Point 1

	;.org	0x8a68
MPVACD_AllowMapToTestGoodThisNearBaro:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0x204F
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AllowMapToTestGoodThisNearBaro
    ;mptblcname MPVACD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x0B                       ;Point 1

MPVAC2_AllowMapToTestGoodThisNearBaro2:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0x205C
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AllowMapToTestGoodThisNearBaro2
    ;mptblcname MPVAC2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x05                       ;Point 1

	;.org	0x8a6a
MPDELX_DeltaMapThatChecksGoodX:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0x206A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaMapThatChecksGoodX
    ;mptblcname MPDELX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

UknownByteA:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x2076
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownBytesA
    ;mptblcname UKNOWNBYTESA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x03                       ;Point 1

UknownByteB:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x2082
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UknownBytesB
    ;mptblcname UKNOWNBYTESB
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xA8                       ;Point 1

	;.org	0x8a6d
FLWMNC_FuelMonitorCorrection:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x208F
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname FuelMonitorCorrection
    ;mptblcname FLWMNC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    ;mpinjscale word
    .word 0x0000                     ;Point 1

FLMNC2_FuelMonitorCorrection2:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\Fuel_Monitor\
    ;mptbladdr 0x209C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FuelMonitorCorrection2
    ;mptblcname FLMNC2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

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

	;.org	0x8a6f ;<--- this signifies the original location from the dis-assy...
FLTMSK_ErrorBitsMask1:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x20E8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask1
    ;mptblcname FLTMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1

FLTMSK2_ErrorBitsMask2:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x20F4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask2
    ;mptblcname FLTMSK2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1

FLTMSK3_ErrorBitsMask3:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x2100
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask3
    ;mptblcname FLTMSK3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1

FLTMSK4_ErrorBitsMask4:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x210C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask4
    ;mptblcname FLTMSK4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1

FLTMSK5_ErrorBitsMask5:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x2118
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask5
    ;mptblcname FLTMSK5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1

FLTMSK6_ErrorBitsMask6:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x2124
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask6
    ;mptblcname FLTMSK6
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1

FLTMSK7_ErrorBitsMask7:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x2130
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask7
    ;mptblcname FLTMSK7
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Used_to_disable_error_code_storage.
    .byte 0x00                       ;Point 1

FLTMSKX_ErrorBitsMaskTerminator:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x213C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMaskTerminator
    ;mptblcname FLTMSKX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Must_be_0x00,_and_must_be_at_the_end_of_the_error_code_list.
    .byte 0x00                       ;Point 1

	;.org	0x8a77
IPLMSK_PowerLossLightMask:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x2149
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PowerLossLightMask
    ;mptblcname IPLMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Illuminate_PowerLoss_Light_Mask1._These_errors_alert_the_driver.
    ;mpchoices ChargeTemp_Sensor  CoolantTemp_Sensor  Charging  bit3  BatVolts  Map_Signal  Tps_Signal  Map_Pneumatic
    .byte 0xFF                       ;Point 1

	;.org	0x8a78
IPLMSK2_PowerLossLightMask2:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x2157
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PowerLossLightMask2
    ;mptblcname IPLMSK2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Illuminate_PowerLoss_Light_Mask2._These_errors_alert_the_driver.
    ;mpchoices bit0  bit1  bit2  Wastegate  InjectorFault  bit5  MajorFault  bit7
    .byte 0xF8                       ;Point 1

	;.org	0x8a79
PIAMSK_PIA1ADDRMask:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x2165
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PIAMSK_PIA1ADDRMask
    ;mptblcname PIAMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc These_flags_enable_error_reporting_on_specific_output_bits.
    ;mpchoices Cruise_Vacuum  Purge_Solenoid  Part_Throt_Unlock  AC_Clutch_Relay  Fan_Relay  ASD_Relay  CE_Light  Cruise_Vent
    .byte 0x70                       ;Point 1

	;.org	0x8a7a
PIBMSK_PIA1BDDRMask:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x2173
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PIBMSK_PIA1BDDRMask
    ;mptblcname PIBMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc These_flags_enable_error_reporting_on_specific_output_bits.
    ;mpchoices bit0  bit1  bit2  bit3  Emission_Light  Baro_Read_Solenoid  Wastegate_Solenoid  EGR_Solenoid
    .byte 0xDC                       ;Point 1

	;.org	0x8a7b
TTEMPL_TstatDiagnosticsMinTempToArmDiagnosticsAtStartup:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\T-Stat_Diagnostics\
    ;mptbladdr 0x2181
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsMinTempToArmDiagnosticsAtStartup
    ;mptblcname TTEMPL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc Detailed_Description
    .byte 0x63                       ;Point 1

	;.org	0x8a7c
TTEMPH_TstatDiagnosticsMaxTempToArmDiagnosticsAtStartup:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\T-Stat_Diagnostics\
    ;mptbladdr 0x218E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsMaxTempToArmDiagnosticsAtStartup
    ;mptblcname TTEMPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc Detailed_Description
    .byte 0xE4                       ;Point 1

	;.org	0x8a7d
TDAGTP_TstatDiagnosticsTemperatureGoalWithin_HOTIME:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\T-Stat_Diagnostics\
    ;mptbladdr 0x219B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsTemperatureGoalWithin_HOTIME
    ;mptblcname TDAGTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc Detailed_Description
    .byte 0xC7                       ;Point 1

	;.org	0x8a7e
HOTIME_TstatDiagnosticsTimeToAchieveTemperatureGoal:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\T-Stat_Diagnostics\
    ;mptbladdr 0x21A8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsTimeToAchieveTemperatureGoal
    ;mptblcname HOTIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xAE                       ;Point 1

	;.org	0x8a7f
BTVHYS_BatteryVoltsHysteresisForAlternatorControl:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\Alternator_Diagnostics\
    ;mptbladdr 0x21B5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BatteryVoltsHysteresisForAlternatorControl
    ;mptblcname BTVHYS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x04                       ;Point 1

	;.org	0x8a80
BTVLMT_BatteryVoltsDiagLimitOverTarget:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\Alternator_Diagnostics\
    ;mptbladdr 0x21C2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BatteryVoltsDiagLimitOverTarget
    ;mptblcname BTVLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1

	;.org	0x8a81
BTVCNT_BatteryVoltsDiagCounterMax:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\Alternator_Diagnostics\
    ;mptbladdr 0x21CF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BatteryVoltsDiagCounterMax
    ;mptblcname BTVCNT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x8E                       ;Point 1

	;.org	0x8a82
BTVCN3_BatteryVoltsDiagCounterMin:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\Alternator_Diagnostics\
    ;mptbladdr 0x21DC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BatteryVoltsDiagCounterMin
    ;mptblcname BTVCN3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x06                       ;Point 1

	;.org	0x8a83
BTVCN2_BatteryVoltsDiagCounterMax2:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\Alternator_Diagnostics\
    ;mptbladdr 0x21E9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BatteryVoltsDiagCounterMax2
    ;mptblcname BTVCN2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x7F                       ;Point 1

	;.org	0x8a84
O2DIAG_CounterLimitForO2SensorDiag:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\O2_Sensor_Diagnostics\
    ;mptbladdr 0x21F6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CounterLimitForO2SensorDiag
    ;mptblcname O2DIAG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x13                       ;Point 1

	;.org	0x8a85
O2MID_LimitForO2SensorBatteryDiag:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\O2_Sensor_Diagnostics\
    ;mptbladdr 0x2203
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LimitForO2SensorBatteryDiag
    ;mptblcname O2MID
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x4D                       ;Point 1

	;.org	0x8a86
O2MIDX_HighLimitForInMiddleDeterminationX:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\O2_Sensor_Diagnostics\
    ;mptbladdr 0x2210
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForInMiddleDeterminationX
    ;mptblcname O2MIDX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x3E                       ;Point 1

	;.org	0x8a87
DCLMER_MinTimeEngineRunningForDecelFuelShutoff:
    ;mpgrp 1_-_Fuel\G_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x221D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinTimeEngineRunningForDecelFuelShutoff
    ;mptblcname DCLMER
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x02                       ;Point 1

	;.org	0x8a88
DCLMCT_MinCoolantTempForDecelFuelShutoff:
    ;mpgrp 1_-_Fuel\G_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x222A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinCoolantTempForDecelFuelShutoff
    ;mptblcname DCLMCT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xD2                       ;Point 1

	;.org	0x8a89
DCLRPH_EngineRPMLimitForDecelFuelShutoffHigh:
    ;mpgrp 1_-_Fuel\G_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x2237
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineRPMLimitForDecelFuelShutoffHigh
    ;mptblcname DCLRPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc High_RPM_to_activate_decel_fuel_shutoff._Should_be_lower_than_shutoff_RPM_Off_point.
    .byte 0x11                       ;Point 1

	;.org	0x8a8a
DCLRPL_EngineRPMLimitForDecelFuelShutoffLow:
    ;mpgrp 1_-_Fuel\G_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x2244
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineRPMLimitForDecelFuelShutoffLow
    ;mptblcname DCLRPL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Low_RPM_to_activate_decel_fuel_shutoff._Should_be_lower_than_shutoff_RPM_On_point.
    .byte 0x0F                       ;Point 1

	;.org	0x8a8b
DCAISI_AISIncrementWhenUsingDecelFuelShut:
    ;mpgrp 1_-_Fuel\G_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x2251
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AISIncrementWhenUsingDecelFuelShut
    ;mptblcname DCAISI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc AIS_Increment_for_recovery_from_decel_fuel_shutoff.
    .byte 0x00                       ;Point 1

	;.org	0x8a8c
DFRPMH_DecelFuelShutoffDeltaRPMOff:
    ;mpgrp 1_-_Fuel\G_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x225E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DecelFuelShutoffDeltaRPMOff
    ;mptblcname DFRPMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPMOverIdle 0 8192 rpm
    ;mptbldesc Decel_fuel_shutoff_RPM_over_Idle_off_point.
    .byte 0x1E                       ;Point 1

	;.org	0x8a8d
DFRPML_DecelFuelShutoffDeltaRPMOn:
    ;mpgrp 1_-_Fuel\G_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x226B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DecelFuelShutoffDeltaRPMOn
    ;mptblcname DFRPML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPMOverIdle 0 8192 rpm
    ;mptbldesc Decel_fuel_shutoff_RPM_over_Idle_on_point.
    .byte 0x11                       ;Point 1

	;.org	0x8a8e
VOBMAP_VNTOverboostSampleCounterMAP:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x2278
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname VNTOverboostSampleCounterMAP
    ;mptblcname VOBMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0xFE                       ;Point 1

	;.org	0x8a8f
VOBCT_VNTOverboostSampleCounterCoolantTemp:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x2285
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname VNTOverboostSampleCounterCoolantTemp
    ;mptblcname VOBCT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x58                       ;Point 1

	;.org	0x8a90
VOBTPS_VNTOverboostSampleCounterTPS:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x2292
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname VNTOverboostSampleCounterTPS
    ;mptblcname VOBTPS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x10                       ;Point 1

	;.org	0x8a91
VOBSCI_VNTOverboostSampleCounterIncr:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x229F
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname VNTOverboostSampleCounterIncr
    ;mptblcname VOBSCI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x02A0                     ;Point 1

	;.org	0x8a93
VOBSCL_VNTOverboostSampleCounterLimit:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x22AC
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname VNTOverboostSampleCounterLimit
    ;mptblcname VOBSCL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0002                     ;Point 1

	;.org	0x8a95
VOBSCD_VNTOverboostSampleCounterDecr:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x22B9
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname VNTOverboostSampleCounterDecr
    ;mptblcname VOBSCD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0006                     ;Point 1

	;.org	0x8a97
VOBSCL2_VNTOverboostSampleCounterLimit2:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x22C6
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname VNTOverboostSampleCounterLimit2
    ;mptblcname VOBSCL2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0001                     ;Point 1

	;.org	0x8a99
VOBSCL3_VNTOverboostSampleCounterLimit3:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x22D3
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname VNTOverboostSampleCounterLimit3
    ;mptblcname VOBSCL3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0200                     ;Point 1

	;.org	0x8a9b
VOBSCI2_VNTOverboostSampleCounterIncr2:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x22E0
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname VNTOverboostSampleCounterIncr2
    ;mptblcname VOBSCI2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0002                     ;Point 1

	;.org	0x8a9d
VOBSCD2_VNTOverboostSampleCounterDecr2:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x22ED
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname VNTOverboostSampleCounterDecr2
    ;mptblcname VOBSCD2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .word 0x0001                     ;Point 1

	;.org	0x8a9f
VOBRPX_VNTOverboostFuelAddedFromRPMWhenOverboosting:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x22FA
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname VNTOverboostFuelAddedFromRPMWhenOverboosting
    ;mptblcname VOBRPX
    ;mpxaxis EngineRPM 0 8160 rpm
    ;mpyaxis Scale 0 99.6 percent
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x80                 ;Point 1

;        .byte   0x80

	;.org	0x8ab6
ADRMRP_AdvanceRemovedFromRPMForDwellCalculation:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x230A
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AdvanceRemovedFromRPMForDwellCalculation
    ;mptblcname ADRMRP
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Advance 0 127.5 deg
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x14                 ;Point 1
	
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


	;.org	0x8acd
L8ACE_L8ace:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x2329
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname L8ACE_L8ace
    ;mptblcname L8ACE
    ;mpxaxis in_desc 4 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x01                       ;Point 1
    .byte 0xFF                       ;Point 2
    .byte 0x52                       ;Point 3
    .byte 0xFF                       ;Point 4

	;.org	0x8ad8
OBSMPL_OverboostSampleThreshold:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\VNT_Control\
    ;mptbladdr 0x2339
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostSampleThreshold
    ;mptblcname OBSMPL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc Detailed_Description
    ;mpmapaxis y
    .byte 0x58                       ;Point 1

	;.org	0x8ae0
FastDataOutputCommandByte:
    ;mpgrp 0_-_Setup\F_-_DRB_Datalogging\
    ;mptbladdr 0x2347
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FastDataOutputCommandByte
    ;mptblcname FASTDT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x18                       ;Point 1

	;.org	0x8ae1
FastDataOutputAddressTable:
    ;mpgrp 0_-_Setup\F_-_DRB_Datalogging\
    ;mptbladdr 0x2354
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname FastDataOutputAddressTable
    ;mptblcname FASTDA
    ;mpxaxis in_desc 30 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1
    .byte 0x00                       ;Point 2
    .byte 0x00                       ;Point 3
    .byte 0x00                       ;Point 4
    .byte 0x00                       ;Point 5
    .byte 0x00                       ;Point 6
    .byte 0x00                       ;Point 7
    .byte 0x00                       ;Point 8
    .byte 0x00                       ;Point 9
    .byte 0x00                       ;Point 10
    .byte 0x00                       ;Point 11
    .byte 0x00                       ;Point 12
    .byte 0x00                       ;Point 13
    .byte 0x00                       ;Point 14
    .byte 0x00                       ;Point 15
    .byte 0x00                       ;Point 16
    .byte 0x00                       ;Point 17
    .byte 0x00                       ;Point 18
    .byte 0x00                       ;Point 19
    .byte 0x00                       ;Point 20
    .byte 0x00                       ;Point 21
    .byte 0x00                       ;Point 22
    .byte 0x00                       ;Point 23
    .byte 0x00                       ;Point 24
    .byte 0x00                       ;Point 25
    .byte 0x00                       ;Point 26
    .byte 0x00                       ;Point 27
    .byte 0x00                       ;Point 28
    .byte 0x00                       ;Point 29
    .byte 0x00                       ;Point 30

	;.org	0x8aff
FastDataOutTerminator:
    ;mpgrp 0_-_Setup\F_-_DRB_Datalogging\
    ;mptbladdr 0x237E
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname FastDataOutTerminator
    ;mptblcname FASTTM
    ;mpxaxis in_desc 1 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Detailed_Description
    .byte 0x00                       ;Point 1

; data moved to data section from code section
TMPTL1_TempForColdScaleFromA2D:
    ;mpgrp 0_-_Setup\D_-_Transfer_Functions\
    ;mptbladdr 0x238B
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

	;;.org	0x88a7
TMPTL2_TempForHotScaleA2D:
    ;mpgrp 0_-_Setup\D_-_Transfer_Functions\
    ;mptbladdr 0x239F
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
       
MINAMP_MinimumAverageMAP:
    ;mpgrp 0_-_Setup\D_-_Transfer_Functions\
    ;mptbladdr 0x23AF
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MinimumAverageMAP
    ;mptblcname MINAMP
    ;mpxaxis IN 0 255 X
    ;mpyaxis PSI 0 44.1 psi
    ;mptbldesc Minimum_value_for_the_MAP_averaging_function.
    ;mpmapaxis y
    .byte 0x04                       ;Point 1

KNKMIN_FlashCEMinTemp:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\CEL_Knock_Indicator\
    ;mptbladdr 0x23BC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FlashCEMinTemp
    ;mptblcname KNKMIN
    ;mpxaxis IN 0 255 X
    ;mpyaxis CoolantTemp -200 260 deg
    ;mptbldesc The_min_temp_allowed_before_the_CE_light_is_flashed._To_avoid_false_indication_on_a_cold_engine.
    .byte 0xA8                       ;Point 1

MAPMULT_ScaleMAPVoltsToPresMultiplyConst:
    ;mpgrp 0_-_Setup\D_-_Transfer_Functions\
    ;mptbladdr 0x23C8
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
    ;mptbladdr 0x23D6
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

ANTLAG_AntiLagRetardAbs:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Launch_Control\Antilag_Settings\
    ;mptbladdr 0x23E4
    ;mptbltype 19
    ;mpsubtype n
    ;mptbllname AntiLagRetardAbs
    ;mptblcname ANTLAGX
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Spark_Retard -16 15.875 Degrees
    ;mptbldesc Antilag_retard_value(absolute)._The_acutal_advance_value_used._Use_negative_values_with_caution._[This_value_should_be_signed:_124_=_-4_actual]
    .byte 0xFD                       ;Point 1

ANLGRP_AntiLagRetardRPM:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Launch_Control\Antilag_Settings\
    ;mptbladdr 0x23F0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AntiLagRetardRPM
    ;mptblcname ANLGRP
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc RPM_to_trigger_antilag._When_staging,_any_RPM_over_this_the_antilag_value_will_be_active._Usually_set_~200rpm_below_staging_limiter.
    .byte 0x57                       ;Point 1

LNCBDT_BaseDataTable:
; counter init value for each spark pattern
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Launch_Control\Rotating_Spark_Cut\
    ;mptbladdr 0x23FD
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
    ;mptbladdr 0x2411
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
    ;mptbladdr 0x2425
    ;mptbltype 6
    ;mpsubtype n
    ;mptbllname SparkCutFraction
    ;mptblcname SPKFRC
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis desc 0 255 out
    ;mptbldesc Spark_Cut_fraction-number_of_cut_cylinders.
    ;mpchoices 1/3_Cut 0 2/3_Cut 1 3/5_Cut 2 4/5_Cut 3 3/7_Cut 4 4/7_Cut 5 5/7_Cut 6 6/7_Cut 7
    .byte 0x03                       ;Point 1

AFR2NB_WidebandAFRToO2TransferFunction:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\WB2NB\
    ;mptbladdr 0x2432
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
    ;mptbladdr 0x2443
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
    ;mptbladdr 0x2451
    ;mptbltype 19
    ;mpsubtype n
    ;mptbllname NarrowBandOffsetValue
    ;mptblcname NBOFFS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis O2SensorVolts -2.5 2.5 volts
    ;mptbldesc Offset_for_NB_lookup_value._Use_to_shift_the_sensor_rich_or_lean.
    .byte 0x80                       ;Point 1

STGSWS_StagingLimiterEnableSwitch:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Launch_Control\Launch_Control_Enable\
    ;mptbladdr 0x245D
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
    ;mptbladdr 0x2472
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
    ;mptbladdr 0x247E
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
    ;mptbladdr 0x248A
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
    ;mptbladdr 0x2496
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StageLimiterRPMOnSetpoint
    ;mptblcname STGRON
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc Detailed_Description
    .byte 0x77                       ;Point 1
       
SRCID_SourceCodeVersionID:
    ;mpgrp 0_-_Setup\B_-_Cal_ID\
    ;mptbladdr 0x24AE
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname SourceCodeVersionID
    ;mptblcname SRCID
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Desc
    .word 0x0C04                     ;Point 1
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


        .msg "Complete." ; these are just messages to display during assemble to let you know what's going on...


