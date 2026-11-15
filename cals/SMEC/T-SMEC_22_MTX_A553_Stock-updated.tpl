;mpver 2.00
;mpassmfile t-smec_v19.asm
.org DataOrg

;mpinjsize 34.9
;mpbar 2.0

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
    ;mptbladdr 0x0196
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname PNPrefix
    ;mptblcname ENDIT1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ENDIT1_stores_the_high-order_part_number_prefix_in_the_Chrysler_engine_controller_read-only_calibration_header._In_factory_Chrysler_electronics,_each_engine_control_computer_is_assigned_a_distinctive_seven-digit_Mopar_part_number._Modifying_ENDIT1_changes_the_four-digit_part_number_prefix_reported_to_diagnostic_scan_tools,_but_has_no_effect_on_engine_fueling,_spark_advance,_boost_management,_or_transmission_control.
    .word 0x5234                     ;Point 1

	;.org	0x8002
ENDITM_ECUID:
    ;mpgrp 0_-_Setup\B_-_Cal_ID\
    ;mptbladdr 0x01A3
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ECU_ID
    ;mptblcname ENDITM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ENDITM_defines_the_primary_electronic_calibration_identifier_word_within_the_engine_controller_ROM_header._Tuners_must_exercise_caution_when_altering_ENDITM._Factory_diagnostic_scan_tools_rely_on_this_identifier_to_automatically_configure_their_data_displays;_changing_ENDITM_to_a_non-standard_value_will_prevent_scan_tools_from_recognizing_the_vehicle,_requiring_technicians_to_select_the_vehicle_year_and_engine_displacement_manually.
    .word 0xA553                     ;Point 1

; the ECU ID MUST be the same as one of the 2.5 T1 stock cals. If it is changed, then
; scantools will not be able to ID the cal and may not work. If you want to change this
; value, then you may have to tell your scantool that you are running a 2.5 T1 manually.

	;.org	 0x8004
HunstvilleTesterCodeBits:
    ;mpgrp 0_-_Setup\B_-_Cal_ID\
    ;mptbladdr 0x01B4
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname Huntsville_Code
    ;mptblcname HUNTSV
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HUNTSV_holds_the_Huntsville_manufacturing_test_code_within_the_calibration_identification_header._HUNTSV_has_no_operational_effect_on_engine_management,_ignition_advance,_air-fuel_delivery,_or_boost_control._Tuners_should_leave_HUNTSV_at_its_stock_factory_setting.
    .word 0xC92D                     ;Point 1

MDLCDE_ModelTypeCode:
    ;mpgrp 0_-_Setup\B_-_Cal_ID\
    ;mptbladdr 0x01C0
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ModelTypeCode
    ;mptblcname MDLCDE
    ;mpxaxis X 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MDLCDE_defines_the_vehicle_model_year,_engine_architecture,_and_transmission_configuration_in_the_calibration_header._When_performing_custom_engine_conversions,_transmission_swaps,_or_flashing_updated_calibrations_across_different_model-year_vehicles,_updating_MDLCDE_ensures_diagnostic_scan_tools_display_the_correct_vehicle_platform_information.
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
    ;mpmodelyr 95 1985
    ;mpmodelyr 98 1988
    ;mpmodelyr 04 1994
    ;mpmodelyr 05 1995
    ;mpmodelyr 12 1992
    ;mpmodelyr 13 1993_Mex
    ;mpengtran 10 2.2_TIV
    ;mpengtran 40 2.2_VNT_Manual
    ;mpengtran 01 2.5_T1
    ;mpengtran 02 2.5_T1_Canada
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
    ;mpengtran 08 2.2_T1
    ;mpengtran 09 2.2_T2
    ;mpengtran 99 2.2_TIII
    ;mpengtran 81 2.5_T1_Unk
    ;mpengtran C1 2.5_T2_Manual_Mex
    ;mpengtran 17 4.0_Jeep_Manual
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
    ;mptbladdr 0x0211
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname Setup_bytes
    ;mptblcname SETUP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SETUP_stores_a_dedicated_sixteen-bit_diagnostic_synchronization_pattern_within_the_calibration_identification_header._Configured_to_fifty-five_AA_in_factory_calibrations,_this_parameter_establishes_an_alternating_binary_bit_pattern_of_alternating_zeros_and_ones._SETUP_should_not_be_modified._It_serves_strictly_as_a_communication_alignment_signature_for_diagnostic_and_manufacturing_hardware.
    .word 0x55AA                     ;Point 1

SpecialBytes2:
    ;mpgrp 0_-_Setup\B_-_Cal_ID\
    ;mptbladdr 0x021D
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname Setup_bytes_2
    ;mptblcname SETUP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SETUP2_defines_a_secondary_sixteen-bit_setup_and_structural_alignment_word_in_the_calibration_identification_header._Tuners_should_leave_SETUP2_unmodified._Changing_this_parameter_does_not_alter_any_engine_performance_variables,_fuel_injector_pulsewidths,_or_boost_solenoid_control.
    .word 0x0044                     ;Point 1
; Maybe this is a checksum fixup location?

CHKFIX_ChecksumFixupValue:
    ;mpgrp 0_-_Setup\B_-_Cal_ID\
    ;mptbladdr 0x022A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ChecksumFixupValue
    ;mptblcname CHKFIX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis value 0 255 value
    ;mptbldesc CHKFIX_is_the_single-byte_calibration_checksum_fixup_constant_located_in_the_engine_controller_ROM_header._Whenever_any_table,_scalar_constant,_or_flag_is_altered_in_the_calibration,_the_total_arithmetic_sum_of_the_calibration_changes._If_the_sum_does_not_match_the_target_byte,_the_engine_controller_immediately_sets_diagnostic_fault_code_fifty-three,_signaling_an_internal_controller_checksum_failure.
    .byte 0x9D                       ;Point 1

SRCID_SourceCodeVersionID:
    ;mpgrp 0_-_Setup\B_-_Cal_ID\
    ;mptbladdr 0x0236
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname SourceCodeVersionID
    ;mptblcname SRCID
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SRCID_defines_the_Turbonator_custom_codebase_version_and_controller_family_identifier_within_the_calibration_header._Tuners_should_leave_SRCID_matched_to_the_exact_firmware_codebase_loaded_into_the_controller._MPTune_and_other_calibration_editors_use_SRCID_to_detect_which_custom_features_are_available,_such_as_switchable_boost,_two-step_launch_control,_anti-lag_timing_retards,_and_wideband_oxygen_sensor_conversion.
    .word 0x0B13                     ;Point 1
    ;mp******************************
    ;mpcodebase 0A T-LM
    ;mpcodebase 0B T-SMEC
    ;mpcodebase 0C T-SBEC
    ;mpcodebase 0D T-TIII_(91)
    ;mpcodebase 0E T-TIII_(92-93)
    ;mpcodebase 0F T-GLHS
    ;mpcodebase 10 FCC
    ;mpcodebase 11 T-SMECt2
    ;mpcodebase 12 T-SBEC2
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
    ;mptbladdr 0x029E
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname ConfigurationFlags
    ;mptblcname CONFIG
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc CONFIG_serves_as_the_master_factory_vehicle_hardware_configuration_register_for_the_engine_controller._Configured_in_factory_calibrations_to_one_hundred_sixty-two_counts,_CONFIG_uses_individual_binary_bits_to_declare_the_presence_or_absence_of_core_vehicle_hardware_systems._CONFIG_is_one_of_the_most_critical_registers_adjusted_during_engine_swaps,_transmission_conversions,_and_emissions_simplification.
    ;mpchoices Bit0  TransFuelTPS  Bit2  PTU_Enable  Charge_Temp_Sensor_Enabled  Auto_Trans_Bit  EGR_Installed  A/C_Installed
    .byte 0x02                       ;Point 1

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
    ;mptbladdr 0x02B5
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname CalCustomOptionConfigFlags1
    ;mptblcname OPTN1
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc OPTN1_is_the_first_custom_feature_configuration_register_introduced_in_the_Turbonator_codebase_to_unlock_advanced_performance_enhancements._Tuners_configure_OPTN1_in_MPTune_to_suit_street,_drag,_and_track_applications._Enabling_switchable_boost_allows_drivers_to_alternate_between_a_conservative_low-boost_daily_setting_and_full_target_boost_using_a_physical_toggle_switch_on_the_dashboard.
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
    ;mptbladdr 0x02CB
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname CalCustomOptionConfigFlags2
    ;mptblcname OPTN2
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc OPTN2_serves_as_the_second_custom_feature_configuration_register_in_the_Turbonator_codebase,_controlling_rev_limiter_mechanics,_launch_control,_turbocharger_anti-lag,_boost_algorithms,_and_wideband_oxygen_sensor_emulation._In_factory_baseline_files,_OPTN2_is_configured_to_five_counts,_enabling_spark-based_rev_limiting_and_two-step_launch_control._OPTN2_gives_tuners_unprecedented_flexibility_for_race_and_performance_calibrations.
    ;mpchoices Spark-based_Rev_Limiter  Fuel-based_Rev_Limiter  Launch_Control  Bang_Bang  Bit4  Anti-Lag_Timing  T2_Boost_Control  WB-2-NB_Conversion
    .byte 0x05                       ;Point 1
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
    ;mptbladdr 0x02E1
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname CCDConfigConstant
    ;mptblcname CCDCFG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CCDCFG_defines_the_configuration_constant_for_the_Chrysler_Collision_Detection_serial_communication_network_bus._Modifying_CCDCFG_has_no_operational_effect_in_Turbonator_firmware_because_all_assembly_instructions_referencing_it_were_deactivated_in_revision_seventeen_point_zero._Tuners_should_leave_CCDCFG_at_its_default_factory_setting.
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
    ;mptbladdr 0x0330
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask1
    ;mptblcname FLTMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc FLTMSK_defines_the_first_configurable_error_suppression_slot_in_the_engine_controller_diagnostic_subsystem._In_Chrysler_nineteen_eighty-nine_engine_controllers,_diagnostic_fault_logging_is_managed_through_an_internal_fault_code_table._Tuners_use_FLTMSK_to_permanently_silence_specific_diagnostic_trouble_codes_when_factory_emissions_components,_vacuum_solenoids,_or_auxiliary_circuits_are_removed.
    .byte 0x00                       ;Point 1

	;.org	0x887d
FLTMSK2_ErrorBitsMask2:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x033D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask2
    ;mptblcname FLTMSK2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc FLTMSK2_defines_the_second_configurable_error_suppression_slot_in_the_eight-byte_diagnostic_fault_mask_array._Positioned_at_index_offset_one_from_the_base_mask_address,_FLTMSK2_allows_tuners_to_suppress_a_second_distinct_diagnostic_error_code._FLTMSK2_functions_identically_to_the_primary_error_mask_byte,_providing_an_additional_slot_for_emissions_and_hardware_deletion.
    .byte 0x00                       ;Point 1

	;.org	0x887e
FLTMSK3_ErrorBitsMask3:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x034A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask3
    ;mptblcname FLTMSK3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc FLTMSK3_provides_the_third_error_suppression_slot_in_the_diagnostic_fault_mask_array._Tuners_use_FLTMSK3_when_building_track_vehicles_or_engine_conversions_that_remove_three_or_more_factory_sensors_or_actuators._Entering_an_internal_error_offset_into_this_slot_allows_suppressing_a_third_diagnostic_code_without_affecting_other_error_detection_logic._If_fewer_than_three_error_codes_are_suppressed,_leave_FLTMSK3_set_to_zero.
    .byte 0x00                       ;Point 1

	;.org	0x887f
FLTMSK4_ErrorBitsMask4:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x0357
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask4
    ;mptblcname FLTMSK4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc FLTMSK4_provides_the_fourth_configurable_error_suppression_slot_in_the_diagnostic_fault_mask_array._FLTMSK4_provides_additional_capacity_for_complex_race_calibrations_where_numerous_factory_components_have_been_deleted._If_four_distinct_fault_codes_must_be_suppressed,_place_the_fourth_internal_fault_offset_into_this_location._Leave_FLTMSK4_set_to_zero_if_four_fault_suppressions_are_not_required.
    .byte 0x00                       ;Point 1

	;.org	0x8880
FLTMSK5_ErrorBitsMask5:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x0364
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask5
    ;mptblcname FLTMSK5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc FLTMSK5_provides_the_fifth_configurable_error_suppression_slot_in_the_diagnostic_fault_mask_array._FLTMSK5_is_utilized_in_highly_modified_vehicle_projects_where_multiple_factory_circuits_and_emissions_devices_are_eliminated._When_five_distinct_codes_require_suppression,_enter_the_fifth_internal_code_into_this_slot._If_fewer_than_five_codes_are_being_suppressed,_keep_FLTMSK5_set_to_zero.
    .byte 0x00                       ;Point 1

	;.org	0x8881
FLTMSK6_ErrorBitsMask6:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x0371
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask6
    ;mptblcname FLTMSK6
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc FLTMSK6_defines_the_sixth_configurable_error_suppression_slot_in_the_diagnostic_fault_mask_array._Stored_at_index_offset_five_from_the_base_address,_FLTMSK6_allows_tuners_to_suppress_a_sixth_distinct_diagnostic_failure_code._FLTMSK6_provides_extended_error_suppression_capacity_for_extreme_vehicle_modifications_and_custom_racing_engines._Enter_the_internal_code_for_a_sixth_suppressed_failure_if_necessary,_or_leave_set_to_zero_if_unneeded.
    .byte 0x00                       ;Point 1

	;.org	0x8882
FLTMSK7_ErrorBitsMask7:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x037E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMask7
    ;mptblcname FLTMSK7
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc FLTMSK7_defines_the_seventh_and_final_configurable_error_suppression_slot_in_the_diagnostic_fault_mask_array._FLTMSK7_is_the_last_user-configurable_code_slot_before_the_mandatory_list_terminator._Tuners_can_place_a_seventh_suppressed_internal_fault_code_here_when_undertaking_extensive_engine_conversions._If_fewer_than_seven_error_codes_are_suppressed,_FLTMSK7_must_be_left_at_zero_counts.
    .byte 0x00                       ;Point 1

	;.org	0x8883
FLTMSKX_ErrorBitsMaskTerminator:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x038B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ErrorBitsMaskTerminator
    ;mptblcname FLTMSKX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc FLTMSKX_is_the_mandatory_end-of-list_terminator_byte_for_the_diagnostic_error_suppression_array._Never_modify_FLTMSKX._It_must_always_remain_zero_counts._If_a_non-zero_value_is_entered_into_FLTMSKX,_the_processor_will_fail_to_terminate_the_suppression_search_at_the_end_of_the_array_and_will_continue_scanning_into_subsequent_ROM_addresses.
    .byte 0x00                       ;Point 1

	;.org	0x8884
IPLMSK_PowerLossLightMask:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x0398
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PowerLossLightMask
    ;mptblcname IPLMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc IPLMSK_defines_the_primary_dashboard_warning_lamp_illumination_mask_register_for_analog_electronic_sensor_faults._In_Chrysler_engine_controllers,_sensor_circuit_diagnostics_continuously_update_internal_status_flags_in_memory._Tuners_adjust_IPLMSK_to_prevent_non-critical_sensor_faults_from_turning_on_the_dashboard_warning_light_in_custom_engine_conversions,_stripped_track_cars,_or_modified_sensor_setups.
    ;mpchoices ChargeTemp_Sensor  CoolantTemp_Sensor  Charging  bit3  BatVolts  Map_Signal  Tps_Signal  Map_Pneumatic
    .byte 0xFF                       ;Point 1

	;.org	0x8885
IPLMSK2_PowerLossLightMask2:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x03A6
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PowerLossLightMask2
    ;mptblcname IPLMSK2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc IPLMSK2_defines_the_second_dashboard_warning_lamp_mask_register,_focusing_on_actuator_circuit_failures_and_major_system_diagnostic_faults._IPLMSK2_is_vital_when_upgrading_turbocharged_vehicles_with_manual_or_standalone_boost_controllers._When_the_factory_electronic_wastegate_solenoid_is_unplugged_or_removed,_the_engine_controller_detects_an_open_circuit_and_sets_internal_error_flag_b46_WGSolFault.
    ;mpchoices bit0  bit1  bit2  Wastegate  InjectorFault  bit5  MajorFault  bit7
    .byte 0x18                       ;Point 1

	;.org	0x8886
PIAMSK_PIA1ADDRMask:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x03B4
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PIAMSK_PIA1ADDRMask
    ;mptblcname PIAMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc PIAMSK_defines_the_diagnostic_output_driver_circuit_mask_for_Port_A_of_the_Peripheral_Interface_Adapter._In_Chrysler_SMEC_engine_controllers,_high-current_inductive_drivers_and_relays_are_driven_through_a_6821_Peripheral_Interface_Adapter._When_simplifying_engine_bays_or_deleting_auxiliary_vehicle_subsystems,_clearing_the_corresponding_bit_in_PIAMSK_disables_diagnostic_circuit_testing_for_that_specific_output_driver.
    ;mpchoices Cruise_Vacuum  Purge_Solenoid  Part_Throt_Unlock  AC_Clutch_Relay  Fan_Relay  ASD_Relay  CE_Light  Cruise_Vent
    .byte 0x3A                       ;Point 1

	;.org	0x8887
PIBMSK_PIA1BDDRMask:
    ;mpgrp 0_-_Setup\A_-_Cal_Configuration\
    ;mptbladdr 0x03C2
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PIBMSK_PIA1BDDRMask
    ;mptblcname PIBMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc PIBMSK_defines_the_diagnostic_output_driver_circuit_mask_for_Port_B_of_the_Peripheral_Interface_Adapter._PIBMSK_is_frequently_adjusted_when_installing_aftermarket_boost_control_equipment_or_removing_factory_emissions_hardware.
    ;mpchoices bit0  bit1  bit2  bit3  Emission_Light  Baro_Read_Solenoid  Wastegate_Solenoid  EGR_Solenoid
    .byte 0xE0                       ;Point 1




	;.org	0x8010
CLDMAP_AdvanceFromMAPCold:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x03D3
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname AdvanceFromMAPCold
    ;mptblcname CLDMAP
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc CLDMAP_defines_the_manifold_pressure_spark_advance_curve_applied_while_engine_coolant_temperature_remains_below_the_warm_operating_threshold._Raising_values_in_CLDMAP_adds_ignition_timing_during_cold_operation,_which_sharpens_cold_throttle_response_and_helps_the_engine_produce_cleaner_torque_during_morning_warm-up._However,_adding_excessive_timing_under_boost_while_the_engine_is_cold_can_cause_detonation_once_charge_temperatures_rise.
    ;mpmapaxis x
    .byte 0x04                       ;Number of points in table
    .byte 0x4D, 0x00, 0x00, 0xC5     ;Point 1
    .byte 0x5A, 0x0A, 0x00, 0x00     ;Point 2
    .byte 0x70, 0x0A, 0xFF, 0xE8     ;Point 3
    .byte 0xD9, 0x00                 ;Point 4

	;.org	0x8023
CLDLMT_LimitForColdMapAtClosedThrottle:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x03E5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LimitForColdMapAtClosedThrottle
    ;mptblcname CLDLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y -200 260 out
    ;mptbldesc CLDLMT_establishes_the_maximum_allowable_ignition_advance_ceiling_that_the_cold_manifold_pressure_spark_curve_(CLDMAP)_can_contribute_while_the_engine_is_at_closed_throttle._Raising_CLDLMT_permits_higher_cold_MAP_advance_during_closed-throttle_idle_and_deceleration_overrun._This_can_help_stabilize_cold_idle_speed_on_engines_fitted_with_aggressive_high-duration_camshafts_that_require_elevated_timing_to_idle_smoothly_when_cold.
    .byte 0x0A                       ;Point 1

	;.org	0x8024
HOTMAP_AdvanceFromMAPWarmPart:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x03F2
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname AdvanceFromMAPWarmPart
    ;mptblcname HOTMAP
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc HOTMAP_defines_the_primary_warm_part-throttle_manifold_pressure_spark_advance_curve_used_when_the_engine_is_fully_warmed_up_and_operating_at_partial_throttle._Raising_values_in_HOTMAP_adds_part-throttle_ignition_advance_across_the_corresponding_manifold_pressure_region,_delivering_crisper_throttle_response,_higher_cruising_torque,_improved_fuel_economy,_and_lower_exhaust_gas_temperatures_during_highway_driving.
    ;mpmapaxis x
    .byte 0x05                       ;Number of points in table
    .byte 0x44, 0x18, 0xFE, 0x97     ;Point 1
    .byte 0x55, 0x00, 0x00, 0x00     ;Point 2
    .byte 0x73, 0x00, 0xFF, 0xB7     ;Point 3
    .byte 0x8F, 0xF8, 0xFF, 0xC7     ;Point 4
    .byte 0xC5, 0xEC                 ;Point 5

	;.org	0x8043
TMPSWP_EngTempSwitchPointForSparkAdvance:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x0405
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngTempSwitchPointForSparkAdvance
    ;mptblcname TMPSWP
    ;mpxaxis IN 0 255 X
    ;mpyaxis Coolant_Temperature -200 260 F
    ;mptbldesc TMPSWP_defines_the_coolant_temperature_switch_threshold_that_divides_the_engine_controller's_ignition_advance_logic_between_Cold_Engine_Mode_and_Warm_Engine_Mode._Raising_TMPSWP_forces_the_engine_controller_to_remain_in_cold-engine_spark_advance_mode_longer_into_its_warm-up_cycle.
    .byte 0xB1                       ;Point 1

	;.org	0x8044
ADVCLS_AdvanceAddedForClosedLoopFromTimer:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x0412
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AdvanceAddedForClosedLoopFromTimer
    ;mptblcname ADVCLS
    ;mpxaxis Timer 0 255 F
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc ADVCLS_defines_an_additive_spark_advance_correction_table_indexed_by_the_open-loop_timer_fraction_during_warm_part-throttle_operation._Raising_values_in_ADVCLS_adds_extra_timing_during_the_warm-up_to_closed-loop_transition,_which_can_provide_a_subtle_boost_in_engine_responsiveness_as_closed-loop_fueling_engages.
    .byte 0x02                       ;Number of points in table
    .byte 0x00, 0x00, 0x00, 0x00     ;Point 1
    .byte 0x1C, 0x00                 ;Point 2

PartThrottleTiming:
    ;mpgrp 99_-_Calculated_Tables\
    ;mptbladdr 0x0420
    ;mptbltype 16
    ;mpsubtype n
    ;mptbllname PartThrottleTotalTiming
    ;mptblcname PTTIME
    ;mpxaxis GOVNER 0 8160 rpm
    ;mpyaxis HOTMAP -15 15 Degrees
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
    ;mptbladdr 0x0435
    ;mptbltype 16
    ;mpsubtype n
    ;mptbllname FullThrottleTotalTiming
    ;mptblcname FTTIME
    ;mpxaxis GOVNER 0 8160 rpm
    ;mpyaxis WOTMAP -15 15 Degrees
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
    ;mptbladdr 0x044B
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname AdvanceFromMAPWarmFull
    ;mptblcname WOTMAP
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc WOTMAP_defines_the_full-throttle_manifold_pressure_spark_advance_curve_used_whenever_the_engine_is_operated_at_wide-open_throttle_under_warm_conditions._Raising_values_in_WOTMAP_advances_ignition_timing_under_boost,_which_increases_peak_engine_torque,_accelerates_turbocharger_spool-up,_and_improves_high-RPM_horsepower.
    ;mpmapaxis x
    .byte 0x05                       ;Number of points in table
    .byte 0x66, 0x0A, 0xFF, 0x00     ;Point 1
    .byte 0x70, 0x00, 0xFF, 0x7A     ;Point 2
    .byte 0x87, 0xF4, 0xFF, 0xF0     ;Point 3
    .byte 0xB8, 0xF1, 0xFF, 0x51     ;Point 4
    .byte 0xCE, 0xE2                 ;Point 5

	;.org	0x806e
MAPMUL_MultiplierOnMapAdvanceWhenRetarding_FromRpm: ;taken from the VNT calibration - similar code to the '89 T1
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x045E
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname MultiplierOnMapAdvanceWhenRetarding_FromRpm
    ;mptblcname MAPMUL
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Spark_Advance_Scale 0 3.984 out
    ;mptbldesc MAPMUL_defines_an_RPM-indexed_scaling_multiplier_applied_to_negative_manifold_pressure_spark_advance_(boost_retard)._Raising_values_in_MAPMUL_amplifies_the_amount_of_boost_retard_pulled_at_higher_engine_speeds,_providing_an_extra_safety_cushion_against_high-RPM_boost_knock._Lowering_values_in_MAPMUL_reduces_the_multiplier_effect,_maintaining_less_aggressive_retard_as_RPM_climbs.
    .byte 0x07                       ;Number of points in table
    .byte 0x3F, 0x37, 0x01, 0x46     ;Point 1
    .byte 0x4A, 0x45, 0x00, 0x00     ;Point 2
    .byte 0x67, 0x45, 0x00, 0x66     ;Point 3
    .byte 0x71, 0x49, 0xFF, 0xA3     ;Point 4
    .byte 0x7C, 0x45, 0x00, 0x9E     ;Point 5
    .byte 0x89, 0x4D, 0xFF, 0x28     ;Point 6
    .byte 0xA9, 0x32                 ;Point 7


	;.org	0x8085
RPMLMT_LimitForHotMAPAdvance:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x0473
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname LimitForHotMAPAdvance
    ;mptblcname RPMLMT
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc RPMLMT_defines_an_RPM-indexed_upper_limit_ceiling_on_warm_part-throttle_manifold_pressure_spark_advance._Raising_values_in_RPMLMT_allows_more_positive_part-throttle_MAP_advance_at_lower_engine_speeds,_providing_crisper_light-throttle_response_on_responsive,_lightweight_vehicles._However,_raising_it_excessively_at_low_engine_speeds_can_cause_light-throttle_surging_or_bucking.
    .byte 0x03                       ;Number of points in table
    .byte 0x20, 0x08, 0x00, 0x8E     ;Point 1
    .byte 0x32, 0x12, 0x00, 0x8F     ;Point 2
    .byte 0x4B, 0x20                 ;Point 3

	;.org	0x8090
PNIDLE_AdvanceRemovedIdleParkNeutral:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x0483
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AdvanceRemovedIdleParkNeutral
    ;mptblcname PNIDLE
    ;mpxaxis Coolant_Temperature -200 260 F
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc PNIDLE_defines_a_coolant_temperature-indexed_spark_advance_trim_applied_specifically_when_an_automatic_transmission_vehicle_is_idling_in_Park_or_Neutral_at_low_engine_speed._Raising_values_in_PNIDLE_advances_ignition_timing_while_idling_in_Park_or_Neutral,_which_raises_idle_RPM_and_increases_manifold_vacuum._If_set_too_high,_shifting_from_Drive_to_Neutral_or_Park_can_produce_a_harsh_idle_flare_or_surge.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0x8097
PNRPM_EngineSpeedBelowWhich_PNIDLE_Enabled:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x0491
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineSpeedBelowWhich_PNIDLE_Enabled
    ;mptblcname PNRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 RPM
    ;mptbldesc PNRPM_defines_the_maximum_engine_speed_threshold_below_which_Park/Neutral_idle_spark_trim_(PNIDLE)_is_permitted_to_operate._Raising_PNRPM_extends_the_engine_speed_range_where_Park/Neutral_idle_spark_trims_can_operate,_which_is_beneficial_when_calibrating_an_automatic_engine_with_an_elevated_target_idle_speed_(such_as_1100_to_1200_RPM_for_high-stall_torque_converters_or_lumpy_camshafts).
    .byte 0x01                       ;Point 1

	;.org	0x8098
GOVNER_AdvanceFromRPM:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x049E
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AdvanceFromRPM2
    ;mptblcname GOVNER
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Spark_Advance 0 127.5 Degrees
    ;mptbldesc GOVNER_defines_the_primary_engine_speed_(RPM)_ignition_advance_curve_in_the_Chrysler_engine_controller,_functioning_as_the_electronic_equivalent_of_centrifugal_mechanical_advance_weights_in_a_conventional_distributor._Because_GOVNER_is_an_additive_baseline_across_all_engine_loads,_changes_to_GOVNER_shift_ignition_timing_across_both_part_throttle_and_wide-open_throttle.
    .byte 0x04                       ;Number of points in table
    .byte 0x20, 0x24, 0x00, 0x72     ;Point 1
    .byte 0x32, 0x2C, 0x00, 0x00     ;Point 2
    .byte 0x71, 0x2C, 0x00, 0x33     ;Point 3
    .byte 0xA3, 0x36                 ;Point 4

	;.org	0x80b3
SPKLMT_TotalAdvanceAllowed:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x04AF
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AdvanceFromRpmMAX
    ;mptblcname SPKLMT
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Spark_Advance -64 63.5 Degrees
    ;mptbldesc SPKLMT_defines_the_absolute_maximum_spark_advance_ceiling_curve_across_engine_speed._Raising_SPKLMT_allows_higher_total_timing_during_light-load_high-RPM_cruising,_which_can_yield_slight_fuel_economy_gains_on_highway_cruising,_though_thermal_efficiency_gains_taper_off_past_42_to_45_degrees_BTDC_on_typical_8-valve_combustion_chambers.
    .byte 0x03                       ;Number of points in table
    .byte 0x64, 0x64, 0xFE, 0x76     ;Point 1
    .byte 0x71, 0x50, 0xFF, 0xE8     ;Point 2
    .byte 0xDB, 0x46                 ;Point 3

	;.org	0x80be
ADVDFT_DefaultSparkAdvance1:
    ;mpgrp 2_-_Spark\A_-_Normal_Advance\
    ;mptbladdr 0x04BF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DefaultSparkAdvance1
    ;mptblcname ADVDFT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Spark_Advance 0 127.5 Degrees
    ;mptbldesc ADVDFT_establishes_the_default_minimum_mechanical_baseline_spark_advance_floor_(factory_setting_20_counts_=_10.0_degrees_BTDC)._Raising_ADVDFT_increases_the_minimum_closed-throttle_baseline_timing_floor_(e.g.,_to_12_or_14_degrees_BTDC),_providing_a_stronger_torque_foundation_to_stabilize_idle_on_engines_fitted_with_aggressive_aftermarket_camshafts.
    .byte 0x1E                       ;Point 1




	;.org	0x80bf
KNKRPM_MinRpmforKnockRetard:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x04CF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinRpmforKnockRetard
    ;mptblcname KNKRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 RPM
    ;mptbldesc KNKRPM_establishes_the_minimum_engine_speed_threshold_required_for_the_engine_controller_to_activate_knock_retard_detection._Raising_KNKRPM_extends_the_knock_retard_lockout_to_higher_engine_speeds_(such_as_1280_or_1500_RPM)._This_is_particularly_useful_on_competition_engines_equipped_with_noisy_solid_mechanical_lifters,_aggressive_valve_springs,_or_loose_piston-to-wall_clearances_that_generate_mechanical_chatter_in_lower_gears.
    .byte 0x20                       ;Point 1

	;.org	0x80c0
KNKOFS_DeltaAboveBaroFor_RTRDRT_and_KNKCNT_and_KNKCOR_incremented:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x04DC
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaAboveBaroFor_RTRDRT_and_KNKCNT_and_KNKCOR_incremented
    ;mptblcname KNKOFS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc KNKOFS_defines_the_positive_manifold_boost_pressure_offset_above_barometric_pressure_that_divides_knock_retard_into_non-boost_versus_in-boost_operational_modes._Raising_KNKOFS_extends_the_non-boost_knock_retard_rate_(RTRDRT)_to_higher_boost_levels,_applying_larger_timing_reduction_steps_during_light_to_moderate_boost.
    ;mpmapaxis y
    .byte 0x2F                       ;Point 1

	;.org	0x80c1
RTRDRT_KnockRetardRateNoBoost:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x04EA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardRateNoBoost
    ;mptblcname RTRDRT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Deg 0 127.5 Degrees
    ;mptbldesc RTRDRT_defines_the_step-size_of_knock_retard_applied_to_a_knocking_cylinder_when_knock_is_detected_out_of_boost_(under_vacuum_or_light_load_below_KNKOFS)._Raising_RTRDRT_pulls_a_larger_chunk_of_timing_(e.g.,_4.0_or_5.0_degrees)_on_the_very_first_knock_event_out_of_boost,_providing_rapid_suppression_of_transient_light-load_pinging.
    .byte 0x09                       ;Point 1

	;.org	0x80c2
RTRDRT2_KnockRetardRateInBoost:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x04F7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardRateInBoost
    ;mptblcname RTRDRT2
    ;mpxaxis IN 0 255 X
    ;mpyaxis Retard 0 127.5 deg
    ;mptbldesc RTRDRT2_defines_the_step-size_of_knock_retard_applied_to_a_knocking_cylinder_when_knock_is_detected_under_boost_(manifold_pressure_above_barometric_pressure_plus_KNKOFS)._Raising_RTRDRT2_increases_the_in-boost_retard_step_size_(e.g.,_to_2.5_or_3.0_degrees),_which_provides_aggressive,_rapid_timing_reduction_under_heavy_boost.
    .byte 0x04                       ;Point 1

	;.org	0x80c3
INCSRT_KnockRetardIncreaseRate:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x0504
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardIncreaseRate
    ;mptblcname INCSRT
    ;mpxaxis in_desc 0 255 retard
    ;mpyaxis Y 0 127.5 deg
    ;mptbldesc INCSRT_controls_the_recovery_and_decay_rate_of_ignition_timing_after_a_knock_event_has_ended._When_the_engine_controller_detects_detonation,_it_retards_ignition_timing_immediately._INCSRT_is_a_binary_bitmask_and_MUST_STRICTLY_be_set_to_power-of-two_minus_one_values:_0,_1,_3,_7,_15,_31,_63,_127,_or_255._Using_intermediate_values_causes_erratic,_non-uniform_timing_recovery_rates.
    .byte 0x1F                       ;Point 1

	;.org	0x80c4
RETMAX_MaxKnockRetardFromMap:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x0511
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname MaxKnockRetardFromMap
    ;mptblcname RETMAX
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Max_Retard 0 127.5 degrees
    ;mptbldesc RETMAX_defines_the_maximum_allowable_knock_retard_ceiling_curve_indexed_by_intake_manifold_pressure._Raising_values_in_RETMAX_expands_the_maximum_knock_retard_authority_under_boost,_providing_an_essential_safety_net_when_tuning_for_elevated_boost_pressures_(15_to_25+_psi)_on_pump_gasoline._Lowering_values_in_RETMAX_restricts_the_maximum_amount_of_timing_that_knock_retard_can_remove.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x56, 0x06, 0x00, 0xE2     ;Point 1
    .byte 0x70, 0x1D                 ;Point 2

	;.org	0x80cf
KNKLIM_MaxKnockRetard:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x0521
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxKnockRetard
    ;mptblcname KNKLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Retard 0 127.5 Degrees
    ;mptbldesc KNKLIM_defines_a_fixed_maximum_knock_retard_limit_applied_during_low-speed_transient_throttle_transitions._Raising_KNKLIM_allows_more_timing_to_be_pulled_during_low-speed_tip-in_if_genuine_detonation_occurs_under_heavy_engine_lugging._However,_setting_it_too_high_risks_sluggish_acceleration_off_idle_if_mechanical_driveline_vibrations_trigger_false_knock.
    .byte 0x06                       ;Point 1

	;.org	0x80d0
THRKNK_DeltaAbove_MINTHR:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x052E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaAbove_MINTHR
    ;mptblcname THRKNK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis TPS 0 5 Volts
    ;mptbldesc THRKNK_defines_the_throttle_position_sensor_voltage_delta_above_minimum_session_idle_TPS_(MINTHR)_required_to_activate_the_low-RPM_knock_retard_limit_(KNKLIM)._Raising_THRKNK_requires_a_larger_throttle_pedal_depression_before_the_low-RPM_knock_limit_activates,_allowing_the_dynamic_RETMAX_curve_to_operate_over_a_broader_throttle_range_during_low-speed_driving.
    .byte 0x53                       ;Point 1

	;.org	0x80d1
KLMRPM_MinKnockDetectRpm:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x053B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinKnockDetectRpm
    ;mptblcname KLMRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 RPM
    ;mptbldesc KLMRPM_defines_the_engine_speed_transition_boundary_that_separates_the_restricted_low-RPM_knock_retard_limit_(KNKLIM)_from_the_standard_dynamic_knock_retard_curve_(RETMAX)._Raising_KLMRPM_extends_the_low-RPM_KNKLIM_clamp_to_higher_engine_speeds_(such_as_1500_or_1800_RPM).
    .byte 0x20                       ;Point 1

	;.org	0x80d2
DLTKNK_KnockFromRpms:
    ;mpgrp 2_-_Spark\B_-_Knock_Retard\
    ;mptbladdr 0x0548
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname KnockSensorVoltageForKnock_FromRpm
    ;mptblcname DLTKNK
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis A2D 0 5 volts
    ;mptbldesc DLTKNK_defines_the_knock_sensor_acoustic_noise_threshold_curve_indexed_by_engine_speed_(RPM)._Raising_values_in_DLTKNK_desensitizes_knock_detection_by_requiring_higher_vibration_amplitude_before_knock_is_flagged._This_is_essential_on_competition_engines_with_noisy_forged_pistons,_aggressive_camshaft_profiles,_solid_mechanical_lifters,_stiff_dual_valve_springs,_or_straight-cut_timing_gears_that_produce_heavy_acoustic_background_noise.
    .byte 0x05                       ;Number of points in table
    .byte 0x3E, 0x10, 0x00, 0x68     ;Point 1
    .byte 0x5E, 0x1D, 0x01, 0x60     ;Point 2
    .byte 0x7E, 0x49, 0x02, 0x78     ;Point 3
    .byte 0x9E, 0x98, 0x00, 0xC8     ;Point 4
    .byte 0xBE, 0xB1                 ;Point 5

	;.org	0x80e9
ARRPM_AdaptiveRetardFromRPM:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x055A
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AdaptiveRetardFromRPM
    ;mptblcname ARRPM
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Spark_Retard 0 127.5 Degrees
    ;mptbldesc ARRPM_defines_the_RPM-indexed_adaptive_spark_retard_curve._Raising_values_in_ARRPM_increases_the_maximum_timing_reduction_that_can_be_adaptively_learned_across_RPM_when_boost_detonation_occurs,_providing_an_aggressive_protective_response_against_low-octane_fuel._Lowering_values_in_ARRPM_softens_the_learned_timing_reduction._Setting_ARRPM_to_zero_across_all_breakpoints_disables_RPM-dependent_adaptive_knock_retard.
    .byte 0x05                       ;Number of points in table
    .byte 0x3F, 0x00, 0x00, 0x42     ;Point 1
    .byte 0x5E, 0x08, 0x00, 0x00     ;Point 2
    .byte 0x71, 0x08, 0xFF, 0xC3     ;Point 3
    .byte 0x8A, 0x02, 0xFF, 0xEC     ;Point 4
    .byte 0xA3, 0x00                 ;Point 5

	;.org	0x8104
ARMAP_AdaptiveRetardFromMAP:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x056C
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AdaptiveRetardFromMAP
    ;mptblcname ARMAP
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Spark_Retard 0 127.5 Degrees
    ;mptbldesc ARMAP_defines_the_manifold_pressure-indexed_adaptive_spark_retard_curve._In_parallel_with_ARRPM,_ARMAP_establishes_a_learned_timing_reduction_based_on_manifold_load._Raising_values_in_ARMAP_increases_the_amount_of_timing_pulled_under_boost_when_adaptive_retard_is_active,_providing_extra_protection_against_persistent_boost_knock._Lowering_values_in_ARMAP_reduces_the_load-dependent_retard_contribution.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x85, 0x00, 0x00, 0x55     ;Point 1
    .byte 0x91, 0x04                 ;Point 2

	;.org	0x811f
ARMPIC_AdaptiveRetard_MinMAPForAdjustment:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x057C
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AdaptiveRetard_MinMAPForAdjustment
    ;mptblcname ARMPIC
    ;mpxaxis IN 0 255 X
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc ARMPIC_defines_the_minimum_manifold_absolute_pressure_threshold_required_for_adaptive_knock_retard_subtraction_to_take_effect._Adaptive_knock_retard_is_engineered_specifically_to_protect_the_engine_against_sustained_detonation_under_high-load_boost_operation._Raising_ARMPIC_pushes_the_activation_threshold_higher_into_positive_boost,_ensuring_that_learned_timing_retard_is_applied_strictly_during_heavy_boost_rather_than_light_vacuum_transitions.
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1

	;.org	0x8120
ARINDX_AdaptiveRetardIndexBase_80:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x058A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardIndexBase_80
    ;mptblcname ARINDX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ARINDX_defines_the_increment_step_size_added_to_the_adaptive_retard_index_(AdaptiveRetardIndex)_whenever_persistent_combustion_detonation_under_boost_is_confirmed._Raising_ARINDX_causes_the_controller_to_jump_more_aggressively_to_full_adaptive_retard_when_boost_knock_occurs,_providing_fast,_maximum_safety_on_vehicles_driven_under_demanding_conditions.
    .byte 0x80                       ;Point 1

	;.org	0x8121
ARSUBC_AdaptiveRetardFactorSubtract:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x0597
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardFactorSubtract
    ;mptblcname ARSUBC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ARSUBC_defines_the_decay_step_size_subtracted_from_the_adaptive_retard_index_(AdaptiveRetardIndex)_every_time_the_engine_undergoes_a_successful_start-to-run_transition._Raising_ARSUBC_accelerates_the_clearing_of_learned_adaptive_retard_across_engine_restarts._Setting_ARSUBC_to_255_instantly_wipes_out_all_learned_adaptive_retard_on_the_very_first_engine_restart,_resetting_timing_to_factory_baseline_tables.
    .byte 0x40                       ;Point 1

	;.org	0x8122
ARCMSK_AdaptiveRetardCounterMask:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x05A4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardCounterMask
    ;mptblcname ARCMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ARCMSK_defines_the_background_program_loop_counter_bitmask_controlling_how_frequently_the_engine_controller_samples_cylinder_knock_retards_during_wastegate_control_and_adaptive_retard_evaluation._ARCMSK_is_a_binary_bitmask_and_must_strictly_be_configured_to_binary_power-of-two_minus_one_values:_0,_1,_3,_7,_15,_31,_63,_127,_or_255.
    .byte 0x3F                       ;Point 1

	;.org	0x8123
ARTM5P_AdaptiveRetardTimeOver5psiBoost:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x05B1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardTimeOver5psiBoost
    ;mptblcname ARTM5P
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ARTM5P_defines_the_persistence_timer_threshold_required_to_accumulate_in-boost_knock_before_the_engine_controller_increments_the_adaptive_retard_index_(AdaptiveRetardIndex)._Raising_ARTM5P_requires_boost_knock_to_persist_longer_before_adaptive_retard_is_triggered,_filtering_out_transient_knock_spikes_and_preventing_unnecessary_timing_reduction_during_aggressive_driving.
    .byte 0x0C                       ;Point 1

	;.org	0x8124
ARMINT_AdaptiveRetardMinimumTemp:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x05BE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardMinimumTemp
    ;mptblcname ARMINT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 degrees
    ;mptbldesc ARMINT_defines_the_minimum_coolant_temperature_threshold_required_for_the_engine_controller_to_learn_adaptive_knock_retard._During_cold_engine_operation_and_initial_warm-up,_combustion_chamber_temperatures_are_uneven,_forged_pistons_may_exhibit_piston_slap_chatter,_and_fuel_atomization_is_imperfect._Raising_ARMINT_ensures_that_adaptive_knock_retard_is_only_learned_when_the_engine_is_fully_warmed_up_and_operating_at_higher_coolant_temperatures.
    .byte 0xFF                       ;Point 1

	;.org	0x8125
ARCMS2_AdaptiveRetardCounterMask2_00:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x05CB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardCounterMask2_00
    ;mptblcname ARCMS2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ARCMS2_defines_a_loop_counter_bitmask_evaluated_when_all_four_cylinders_have_zero_active_knock_retard_during_wastegate_duty_cycle_processing._In_virtually_all_tuning_scenarios,_ARCMS2_should_remain_at_its_factory_setting_of_0._Setting_ARCMS2_to_a_non-zero_bitmask_would_delay_the_evaluation_of_timer_decay_when_cylinders_stop_knocking,_which_could_cause_transient_boost_knock_timers_to_linger_longer_than_necessary_after_combustion_stabilizes.
    .byte 0x00                       ;Point 1

	;.org	0x8126
ARCMS3_AdaptiveRetardCounterMask3_FF:
    ;mpgrp 2_-_Spark\D_-_Adaptive_Retard\
    ;mptbladdr 0x05D8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardCounterMask3_FF
    ;mptblcname ARCMS3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ARCMS3_defines_the_subtraction_decrement_value_applied_to_the_boost_knock_persistence_timer_(Timer_Over5PsiBoostMaxFF)_whenever_all_cylinders_are_clear_of_knock_retard._ARCMS3_should_be_retained_at_its_factory_setting_of_255_in_virtually_all_street_and_performance_applications._Setting_ARCMS3_to_255_ensures_that_any_interruption_in_knock_instantly_resets_the_boost_knock_timer,_requiring_knock_to_be_continuous_before_adaptive_retard_accumulates.
    .byte 0xFF                       ;Point 1

DWELL_DwellTimeFromBatteryVoltsComp:
    ;mpgrp 2_-_Spark\E_-_Dwell_Control\
    ;mptbladdr 0x05E4
    ;mptbltype 10
    ;mpsubtype n
    ;mptbllname DwellTimeFromBatteryVolts
    ;mptblcname DWELL
    ;mpxaxis BatV 0 16.2 V
    ;mpyaxis DwellTime 0 65535 uSec
    ;mptbldesc DWELL_defines_the_primary_ignition_coil_dwell_time_curve_indexed_by_battery_voltage._Adjusting_DWELL_is_necessary_when_upgrading_from_the_factory_ignition_coil_to_aftermarket_high-energy_coils,_multi-spark_systems,_or_modern_low-inductance_coils_that_feature_different_primary_resistance_and_charge_saturation_curves.
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
    ;mptbladdr 0x05FA
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname MinAntiDwellPeriod
    ;mptblcname MINADW
    ;mpxaxis in 0 255 out
    ;mpyaxis AntiDwellTime 0 65535 uSec
    ;mptbldesc MINADW_defines_the_minimum_anti-dwell_period_(time_between_spark_firing_and_the_start_of_the_next_coil_charge_cycle)_enforced_by_the_engine_controller._MINADW_is_closely_tied_to_the_physical_electrical_characteristics_of_the_ignition_coil_and_ECU_power_switching_hardware._In_nearly_all_engine_calibrations,_MINADW_should_remain_at_its_factory_setting_of_400_microseconds.
    .word 0x00C8                     ;Point 1

ANTLAG_AntiLagRetardAbs:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Launch_Control\Antilag_Settings\
    ;mptbladdr 0x0606
    ;mptbltype 19
    ;mpsubtype n
    ;mptbllname AntiLagRetardAbs
    ;mptblcname ANTLAGX
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Spark_Retard -16 15.875 Degrees
    ;mptbldesc ANTLAGX_sets_the_absolute_ignition_timing_commanded_by_the_engine_controller_when_anti-lag_launch_control_is_active_on_the_staging_line._Calibrate_ANTLAGX_to_deliver_the_desired_launch_boost_pressure_without_creating_excessive_exhaust_heat._Positive_numbers_advance_timing_toward_top_dead_center,_creating_gentler_anti-lag_action_with_lower_exhaust_temperatures_and_slower_boost_rise.
    .byte 0xE0                       ;Point 1

ANLGRP_AntiLagRetardRPM:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Launch_Control\Antilag_Settings\
    ;mptbladdr 0x0612
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AntiLagRetardRPM
    ;mptblcname ANLGRP
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc ANLGRP_defines_the_engine_speed_threshold_required_before_anti-lag_ignition_timing_takes_effect_during_staging_launch_control._Set_ANLGRP_approximately_200_to_400_RPM_below_the_lower_staging_limiter_threshold._For_example,_if_staging_launch_speed_is_set_to_3800_RPM,_configure_ANLGRP_between_3400_and_3600_RPM.
    .byte 0x45                       ;Point 1

LNCBDT_BaseDataTable:
; counter init value for each spark pattern
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Launch_Control\Rotating_Spark_Cut\
    ;mptbladdr 0x061F
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname BaseDataTable
    ;mptblcname LNCBDT
    ;mpxaxis in_desc 8 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LNCBDT_stores_the_counter_initialization_values_that_define_the_cycle_length_for_each_of_the_eight_rotating_spark_cut_patterns_in_launch_control._Keep_LNCBDT_synchronized_with_the_corresponding_bitmask_patterns_in_LNCPDT._Standard_calibrations_use_base_values_of_3,_3,_5,_5,_7,_7,_7,_and_7_for_pattern_indices_0_through_7.
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
    ;mptbladdr 0x0633
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname PatternDataTable
    ;mptblcname LNCPDT
    ;mpxaxis in_desc 8 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LNCPDT_defines_the_eight-bit_spark_cut_patterns_that_govern_cylinder-by-cylinder_ignition_enabling_during_launch_control_staging._Patterns_are_indexed_by_the_SPKFRC_selection_in_MPTune._Standard_patterns_include_1/3_cut_for_mild_limiting_and_fast_spool,_3/5_cut_and_4/5_cut_for_balanced_starting_line_control,_and_5/7_or_6/7_cut_for_strict_RPM_limiting_on_high-traction_surfaces.
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
    ;mptbladdr 0x0647
    ;mptbltype 6
    ;mpsubtype n
    ;mptbllname SparkCutFraction
    ;mptblcname SPKFRC
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis desc 0 255 out
    ;mptbldesc SPKFRC_selects_the_active_spark_cut_fraction_from_the_pre-programmed_pattern_tables_for_launch_control._Choose_the_spark_cut_fraction_that_matches_your_turbocharger_size_and_launch_requirements._Choice_0_(1/3_cut)_and_Choice_2_(3/5_cut)_fire_more_frequently,_producing_massive_exhaust_heat_and_expansion_to_spool_large_turbochargers,_but_allow_engine_RPM_to_creep_upward_if_staging_dwell_is_extended.
    ;mpchoices 1/3_Cut 0 2/3_Cut 1 3/5_Cut 2 4/5_Cut 3 3/7_Cut 4 4/7_Cut 5 5/7_Cut 6 6/7_Cut 7
    .byte 0x03                       ;Point 1

	;.org	0x8127
SSTEMP_TempAboveWhichSparkScatterIsActive:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x0655
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TempAboveWhichSparkScatterIsActive
    ;mptblcname SSTEMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc SSTEMP_defines_the_minimum_engine_coolant_temperature_threshold_required_to_activate_spark_scatter_idle_speed_stabilization._Raising_SSTEMP_delays_the_activation_of_spark_scatter_until_the_engine_reaches_a_higher_coolant_temperature,_which_is_helpful_if_an_engine_exhibits_an_irregular_idle_hunt_during_the_intermediate_warm-up_phase._Lowering_SSTEMP_enables_spark_scatter_earlier_in_the_warm-up_cycle.
    .byte 0x58                       ;Point 1

	;.org	0x8128
FTUNPW_FineTuneStepForAis:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x0662
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FineTuneStepForAis
    ;mptblcname FTUNPW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc FTUNPW_defines_the_Automatic_Idle_Speed_(AIS)_stepper_motor_fine-tuning_step_size_driven_by_spark_scatter_tracking_register_overflow._Raising_FTUNPW_causes_the_automatic_idle_speed_stepper_motor_to_make_larger_mechanical_airflow_adjustments_whenever_spark_scatter_accumulates_continuous_error.
    .byte 0x01                       ;Point 1

	;.org	0x8129
SSITIM_ScatterInhibitTime:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x066F
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ScatterInhibitTime
    ;mptblcname SSITIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SSITIM_defines_the_start-up_inhibit_duration_that_delays_the_activation_of_spark_scatter_idle_stabilization_after_engine_cranking._Raising_SSITIM_extends_the_post-start_delay_before_spark_scatter_begins_operating._This_is_beneficial_on_engines_with_lightweight_flywheels_or_aggressive_camshafts_that_exhibit_prolonged_post-crank_RPM_settling_or_flare-up,_ensuring_that_engine_speed_stabilizes_before_ignition_timing_modulation_takes_over.
    .word 0x0080                     ;Point 1

	;.org	0x812b
SSIPRD_ScatterInhibitBelowThisSpeed:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x067C
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ScatterInhibitBelowThisSpeed
    ;mptblcname SSIPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SSIPRD_defines_the_low-engine-speed_distributor_pulse_period_threshold_below_which_spark_scatter_idle_stabilization_is_inhibited._In_period_units,_raising_SSIPRD_allows_spark_scatter_to_operate_down_to_lower_engine_speeds_before_locking_out,_while_lowering_SSIPRD_shuts_off_spark_scatter_at_a_higher_engine_speed._In_Mopar_Performance_manual_transmission_calibrations,_SSIPRD_is_famously_configured_to_65075_counts_(hexadecimal_FE33).
    .word 0x0033                     ;Point 1

	;.org	0x812d
SPKADD_SparkAdvanceAddedWhenRpmBelowControl_FromDeltaRpm:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x0689
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname SparkAdvanceAddedWhenRpmBelowControl_FromDeltaRpm
    ;mptblcname SPKADD
    ;mpxaxis DeltaRPM 0 512 RPM
    ;mpyaxis Advance 0 127.5 degrees
    ;mptbldesc SPKADD_defines_the_spark_advance_addition_curve_applied_by_the_spark_scatter_algorithm_when_engine_speed_drops_below_target_idle_speed._Raising_values_in_SPKADD_increases_the_spark_advance_kick_delivered_when_idle_speed_drops_below_target,_providing_a_powerful_torque_bump_that_prevents_stalling_on_engines_equipped_with_lightweight_flywheels,_aggressive_camshafts,_or_heavy_electrical_loads.
    .byte 0x02                       ;Number of points in table
    .byte 0x00, 0x00, 0x00, 0x6C     ;Point 1
    .byte 0x13, 0x08                 ;Point 2

	;.org	0x8138
SPKRET_SparkAdvanceRetardedWhenRpmAboveControl_FromDeltaRpm:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x0698
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname SparkAdvanceRetardedWhenRpmAboveControl_FromDeltaRpm
    ;mptblcname SPKRET
    ;mpxaxis DeltaRPM 0 512 rpm
    ;mpyaxis Advance 0 127.5 degrees
    ;mptbldesc SPKRET_defines_the_spark_advance_retard_curve_applied_by_the_spark_scatter_algorithm_when_engine_speed_flares_above_target_idle_speed._Just_as_SPKADD_adds_ignition_timing_when_engine_speed_sags,_SPKRET_pulls_ignition_timing_when_engine_speed_overshoots_target_idle._Raising_values_in_SPKRET_pulls_more_ignition_timing_when_engine_speed_flares,_quickly_taming_idle_speed_overshoot_when_dropping_out_of_gear_or_releasing_the_throttle.
    .byte 0x02                       ;Number of points in table
    .byte 0x04, 0x00, 0xFE, 0x89     ;Point 1
    .byte 0x13, 0xEA                 ;Point 2

	;.org	0x8143
IDLADD_FuelStabilization_FromDeltaRPM:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x06A7
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStabilization_FromDeltaRPM
    ;mptblcname IDLADD
    ;mpxaxis DeltaRPM 0 512 rpm
    ;mpyaxis Pulsewidth 0 1020 uSec
    ;mptbldesc IDLADD_defines_the_fuel_pulsewidth_stabilization_correction_curve_indexed_by_idle_engine_speed_error._In_coordination_with_spark_scatter_ignition_timing_modulation,_the_engine_controller_applies_high-speed_fuel_pulsewidth_adjustments_when_engine_speed_deviates_from_target_idle._Raising_values_in_IDLADD_increases_the_fuel_correction_delivered_during_idle_speed_deviations.
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x03, 0x00, 0x03, 0x79     ;Point 1
    .byte 0x16, 0x42, 0x01, 0x00     ;Point 2
    .byte 0x4B, 0x77                 ;Point 3

	;.org	0x814e
IDLTMP_Use_IDLADD_AboveThisTemp:
    ;mpgrp 2_-_Spark\C_-_Scatter_Control\
    ;mptbladdr 0x06B8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Use_IDLADD_AboveThisTemp
    ;mptblcname IDLTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 degF
    ;mptbldesc IDLTMP_defines_the_minimum_engine_coolant_temperature_threshold_required_to_activate_IDLADD_idle_fuel_stabilization._While_the_engine_is_cold,_fuel_puddle_dynamics_in_the_intake_manifold_runners_are_unstable_and_cold_enrichment_fuel_multipliers_are_active._Raising_IDLTMP_ensures_that_fuel_stabilization_corrections_are_delayed_until_the_engine_is_thoroughly_heat-soaked.
    .byte 0x6E                       ;Point 1

	;.org	0x814f
STRNTR_SparkStartRunTransferPointRpm:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x06C5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkStartRunTransferPointRpm
    ;mptblcname STRNTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DistPW 0 255 count
    ;mptbldesc STRNTR_defines_the_engine_speed_distributor_pulse_period_threshold_required_to_transfer_ignition_control_from_cranking_Start_Mode_to_normal_running_Run_Mode._During_engine_cranking_with_the_starter_motor,_crankshaft_rotation_is_slow_and_irregular_(typically_150_to_250_RPM)._In_period_units,_raising_STRNTR_lowers_the_transfer_engine_speed_(e.g.,_60_counts_≈_500_RPM),_allowing_earlier_transfer_to_dynamic_running_spark_tables.
    .byte 0x31                       ;Point 1

	;.org	0x8150
RNSTTR_SparkRunStartTransferPointRpm:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x06D2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkRunStartTransferPointRpm
    ;mptblcname RNSTTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DistPW 0 255 count
    ;mptbldesc RNSTTR_defines_the_stall-detection_hysteresis_distributor_pulse_period_threshold_that_drops_ignition_control_back_from_running_Run_Mode_into_cranking_Start_Mode._In_period_units,_raising_RNSTTR_allows_the_engine_to_drop_to_a_lower_engine_speed_(e.g.,_90_counts_≈_333_RPM)_before_conceding_a_stall_and_reverting_to_cranking_mode.
    .byte 0x47                       ;Point 1

	;.org	0x8151
SKAPRD_SparkImmediateSwitchToRunAboveThisRpm:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x06DF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkImmediateSwitchToRunAboveThisRpm
    ;mptblcname SKAPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc SKAPRD_defines_the_instantaneous_engine_speed_distributor_pulse_period_threshold_that_triggers_immediate_transfer_from_cranking_Start_Mode_into_running_Run_Mode,_bypassing_all_pulse_countdown_timers._In_period_units,_raising_SKAPRD_lowers_the_required_flare_engine_speed_(e.g.,_45_counts_≈_667_RPM)_to_trigger_immediate_Run_Mode._This_enables_immediate_running_ignition_advance_on_engines_that_catch_smoothly_but_do_not_flare_high_on_startup.
    .byte 0x24                       ;Point 1

	;.org	0x8152
SRTIME_SparkEPPsNeededToBeAboveSR_Hot:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x06EC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkEPPsNeededToBeAboveSR_Hot
    ;mptblcname SRTIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SRTIME_defines_the_number_of_consecutive_Engine_Position_Pulses_(EPPs)_that_engine_speed_must_remain_above_the_start-to-run_threshold_(STRNTR)_before_transferring_spark_control_to_Run_Mode_when_the_engine_is_warm._Raising_SRTIME_requires_the_engine_to_maintain_speed_above_STRNTR_for_more_consecutive_pulses_(such_as_6_or_8_pulses),_ensuring_rock-solid_rotational_momentum_before_switching_from_cranking_dwell_to_running_dwell.
    .byte 0x04                       ;Point 1

	;.org	0x8153
SRTIME2_SparkEPPsNeededToBeAboveSR_Cold:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x06F9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkEPPsNeededToBeAboveSR_Cold
    ;mptblcname SRTIME2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SRTIME2_defines_the_number_of_consecutive_Engine_Position_Pulses_(EPPs)_above_STRNTR_required_to_transfer_ignition_control_into_Run_Mode_when_the_engine_is_cold_(coolant_temperature_below_or_equal_to_SRTMTP)._Raising_SRTIME2_demands_more_consecutive_pulses_above_STRNTR_before_allowing_cold_running_spark_advance_(CLDMAP)_to_take_over,_keeping_the_engine_on_fixed_cranking_spark_and_rich_cranking_dwell_longer.
    .byte 0x04                       ;Point 1

	;.org	0x8154
SRTMTP_SparkTempSwitchPointFor_SRTIME:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x0706
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkTempSwitchPointFor_SRTIME
    ;mptblcname SRTMTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc SRTMTP_defines_the_engine_coolant_temperature_switch_point_that_selects_between_the_warm_start_pulse_counter_(SRTIME)_and_the_cold_start_pulse_counter_(SRTIME2)._It_establishes_the_controller's_definition_of_a_warm_restart_versus_a_cold_start_specifically_for_the_start-to-run_spark_transfer_routine._Raising_SRTMTP_classifies_engines_as_cold_across_a_broader_temperature_range,_applying_the_cold_pulse_counter_(SRTIME2)_even_after_brief_heat_soaks.
    .byte 0xB0                       ;Point 1

	;.org	0x8155
RNFPRD_FuelStartRunTransferPointRpm:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x0713
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FuelStartRunTransferPointRpm
    ;mptblcname RNFPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DistPW 0 255 count
    ;mptbldesc RNFPRD_defines_the_fuel_injection_start-to-run_transfer_distributor_pulse_period_threshold._In_period_units,_raising_RNFPRD_transitions_to_running_speed-density_fueling_at_a_lower_engine_speed_(e.g.,_60_counts_≈_500_RPM)._This_is_advantageous_when_installing_oversized_aftermarket_fuel_injectors_(such_as_+40%_or_52+_lb/hr_units),_where_prolonged_cranking_pulses_quickly_flood_the_cylinders_and_foul_spark_plugs_on_warm_restarts.
    .byte 0x30                       ;Point 1

	;.org	0x8156
STFPRD_FuelRunStartTransferPointRpm:
    ;mpgrp 2_-_Spark\F_-_Start_to_Run_Transfer\
    ;mptbladdr 0x0720
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FuelRunStartTransferPointRpm
    ;mptblcname STFPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DistPW 0 255 Count
    ;mptbldesc STFPRD_defines_the_fuel_injection_run-to-start_stall_hysteresis_distributor_pulse_period_threshold._In_period_units,_raising_STFPRD_allows_the_engine_to_drop_to_a_lower_engine_speed_(e.g.,_80_counts_≈_375_RPM)_before_re-engaging_cranking_fuel._This_prevents_sudden_rich_fuel_dumping_when_lugging_the_engine_at_very_low_speeds_in_manual_transmission_cars.
    .byte 0x41                       ;Point 1

	;.org	0x8157
STRTFL_FuelStartFromCoolantTemp:
    ;mpgrp 1_-_Fuel\A_-_Starting\
    ;mptbladdr 0x072D
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname StartFuel_FromTemp
    ;mptblcname STRTFL
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis sqrtPW 0 222 uSec
    ;mptbldesc STRTFL_defines_the_base_cranking_fuel_delivery_curve_indexed_against_engine_coolant_temperature_during_starter_cranking._Tuning_STRTFL_is_required_when_installing_larger_fuel_injectors_or_converting_to_alternative_fuels_like_E85._When_upgrading_to_higher-flow_injectors,_scale_the_entire_STRTFL_curve_downward_by_the_injector_flow_ratio_to_prevent_rich_spark_plug_fouling_and_hard_hot-restarts.
    ;mpinjscale sqrt
    .byte 0x09                       ;Number of points in table
    .byte 0x58, 0xB8, 0xFF, 0xF1     ;Point 1
    .byte 0x69, 0xB7, 0xFE, 0xCD     ;Point 2
    .byte 0x6E, 0xB1, 0xFD, 0x5D     ;Point 3
    .byte 0x79, 0x94, 0xFE, 0x5D     ;Point 4
    .byte 0x84, 0x82, 0xFE, 0x00     ;Point 5
    .byte 0x90, 0x6A, 0xFE, 0x1A     ;Point 6
    .byte 0x9A, 0x57, 0xFF, 0x0B     ;Point 7
    .byte 0xB1, 0x41, 0xFF, 0x39     ;Point 8
    .byte 0xCC, 0x2C                 ;Point 9

	;.org	0x817e
STRLMT_ColdestTempAllowedAtClosedThrottle:
    ;mpgrp 1_-_Fuel\A_-_Starting\
    ;mptbladdr 0x0744
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ColdestTempAllowedAtClosedThrottle
    ;mptblcname STRLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc STRLMT_defines_the_minimum_coolant_temperature_floor_permitted_for_cranking_fuel_calculations_when_starting_at_closed_throttle._Raising_STRLMT_limits_cold_starting_fuel_delivery_during_freezing_weather,_which_helps_prevent_flooded_spark_plugs_when_running_high-flow_aftermarket_fuel_injectors.
    .byte 0x69                       ;Point 1

	;.org	0x817f
EPPMUL_FuelStartFuelPerEPP:
    ;mpgrp 1_-_Fuel\A_-_Starting\
    ;mptbladdr 0x0751
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartFuelPerEPP
    ;mptblcname EPPMUL
    ;mpxaxis EPPs 0 255 count
    ;mpyaxis Factor 0 0.996 factor
    ;mptbldesc EPPMUL_defines_a_multiplicative_fuel_decay_factor_indexed_against_crankshaft_revolutions_during_engine_starting._Adjusting_EPPMUL_improves_extended_cranking_reliability_and_cures_warm-start_flooding._If_an_engine_fires_immediately_on_the_first_revolution_but_dies_if_it_fails_to_catch_instantly,_raise_the_tail_of_EPPMUL_to_maintain_adequate_fuel_delivery_during_extended_cranking.
    .byte 0x02                       ;Number of points in table
    .byte 0x0A, 0xFF, 0xFD, 0xE6     ;Point 1
    .byte 0x28, 0xC0                 ;Point 2

	;.org	0x818a
STFTMP_FuelStartFuelFromCoolant:
    ;mpgrp 1_-_Fuel\A_-_Starting\
    ;mptbladdr 0x0760
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartFuelFromCoolant
    ;mptblcname STFTMP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Inverse 0 0.996 factor
    ;mptbldesc STFTMP_defines_a_temperature-dependent_reduction_factor_that_subtracts_fuel_from_the_cranking_calculation_as_the_engine_warms_up._Tuning_STFTMP_resolves_hard_warm-starting_issues,_extended_hot_cranking,_and_fuel_odor_upon_restart._If_an_engine_restarts_with_difficulty_when_warm,_exhibiting_a_heavy_gasoline_smell_or_requiring_partial_throttle_to_catch,_increase_STFTMP_at_warm_coolant_temperatures.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0xFF                 ;Point 1

	;.org	0x8191
STFBAR_FuelStartReductionFromBaro:
    ;mpgrp 1_-_Fuel\A_-_Starting\
    ;mptbladdr 0x076E
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FuelStartReductionFromBaro
    ;mptblcname STFBAR
    ;mpxaxis Baro -14.7 14.7 psi
    ;mpyaxis Inverse 0 0.996 factor
    ;mptbldesc STFBAR_defines_the_barometric_pressure_compensation_curve_for_cranking_fuel_delivery._STFBAR_ensures_crisp_starting_when_operating_vehicles_at_high_elevations,_such_as_mountain_regions_or_high-altitude_race_tracks._If_a_vehicle_starts_cleanly_at_sea_level_but_floods_or_cranks_sluggishly_with_black_exhaust_smoke_in_the_mountains,_increase_STFBAR_values_at_lower_barometric_pressures.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x60, 0x4D, 0xFD, 0x0A     ;Point 1
    .byte 0x7A, 0x00                 ;Point 2

	;.org	0x819c
SFDCAY_FuelStartDecayIntoRun:
    ;mpgrp 1_-_Fuel\A_-_Starting\
    ;mptbladdr 0x077E
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartDecayIntoRun
    ;mptblcname SFDCAY
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis InjectorPW 256 65535 uSec
    ;mptbldesc SFDCAY_defines_the_initial_fuel_enrichment_pulsewidth_loaded_at_the_instant_the_engine_catches_and_transfers_from_cranking_into_running_mode._SFDCAY_is_the_primary_calibration_parameter_for_curing_start-and-stall_behavior,_where_an_engine_starts_instantly_on_the_key_but_stalls_the_moment_the_starter_is_released.
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x63, 0x1B, 0xFF, 0x94     ;Point 1
    .byte 0x90, 0x08, 0xFF, 0xEF     ;Point 2
    .byte 0xCC, 0x04                 ;Point 3

	;.org	0x81ab
PRSHOT_KeyOnPrimePW:
    ;mpgrp 1_-_Fuel\A_-_Starting\
    ;mptbladdr 0x078F
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname KeyOnPrimePW
    ;mptblcname PRSHOT
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Pulsewidth 0 255 mSec
    ;mptbldesc PRSHOT_defines_the_single_key-on_injector_priming_pulsewidth_delivered_immediately_upon_turning_the_ignition_key_from_off_to_run._PRSHOT_is_critical_for_fast,_crisp_starting_response._On_cold_mornings,_an_adequate_prime_shot_allows_the_engine_to_catch_on_the_first_or_second_starter_revolution._However,_when_upgrading_to_high-flow_fuel_injectors,_PRSHOT_must_be_scaled_downward_by_the_injector_size_ratio.
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x69, 0x7D, 0xFC, 0x09     ;Point 1
    .byte 0x84, 0x12, 0xFF, 0xDF     ;Point 2
    .byte 0x9B, 0x0F                 ;Point 3

	;.org	0x81ba
MAPIDL_FuelBaselineFromMap:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x07A0
    ;mptbltype 1
    ;mpsubtype 1
    ;mptbllname FuelBaselineFromMap
    ;mptblcname MAPIDL
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Pulsewidth 0 65535 uSec
    ;mptbldesc MAPIDL_defines_the_base_fuel_delivery_curve_indexed_by_intake_manifold_pressure_when_operating_at_closed_throttle._Recalibrating_MAPIDL_is_necessary_whenever_installing_larger_aftermarket_fuel_injectors_or_upgrading_to_a_3-bar_MAP_sensor._When_swapping_to_higher-flow_injectors,_scale_all_pulsewidth_values_downward_across_the_table_by_the_injector_flow_ratio_to_prevent_rich_idle_hunting,_black_spark_plug_deposits,_and_raw_fuel_exhaust_odor.
    ;mpmapaxis x
    ;mpinjscale scale
    .byte 0x0D                   ;Point 1
    .word 0x0000, 0x12D5
    .byte 0x19                   ;Point 2
    .word 0x00E2, 0x0B33
    .byte 0x1E                   ;Point 3
    .word 0x011A, 0x3D00
    .byte 0x1F                   ;Point 4
    .word 0x0157, 0x0D43
    .byte 0x32                   ;Point 5
    .word 0x0253, 0x16B3
    .byte 0x3C                   ;Point 6
    .word 0x0336, 0x2120
    .byte 0x44                   ;Point 7
    .word 0x043F, 0x16B3
    .byte 0xFF

	;.org	0x81e8
MAPTBL_FuelPartThrottle:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x07BD
    ;mptbltype 1
    ;mpsubtype 1
    ;mptbllname FuelPartThrottle
    ;mptblcname MAPTBL
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Pulsewidth 0 65535 uSec
    ;mptbldesc MAPTBL_defines_the_primary_part-throttle_fuel_delivery_curve_indexed_by_intake_manifold_pressure._MAPTBL_must_be_rescaled_whenever_replacing_stock_injectors_with_higher-capacity_units_or_when_upgrading_to_a_3-bar_MAP_sensor._When_installing_larger_injectors,_reduce_table_values_across_all_manifold_pressure_points_by_the_injector_flow_multiplier.
    ;mpmapaxis x
    ;mpinjscale scale
    .byte 0x0D                   ;Point 1
    .word 0x0000, 0x13E9
    .byte 0x18                   ;Point 2
    .word 0x00DB, 0x2800
    .byte 0x19                   ;Point 3
    .word 0x0103, 0x114F
    .byte 0x33                   ;Point 4
    .word 0x02C5, 0x1019
    .byte 0x66                   ;Point 5
    .word 0x05FA, 0x1428
    .byte 0x79                   ;Point 6
    .word 0x0779, 0x0FE2
    .byte 0x93                   ;Point 7
    .word 0x0916, 0x1144
    .byte 0xB5                   ;Point 8
    .word 0x0B61, 0x20DA
    .byte 0xFF

	;.org	0x8220
WOTTBL_FuelFullThrottle:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x07DC
    ;mptbltype 1
    ;mpsubtype 1
    ;mptbllname FuelFullThrottle
    ;mptblcname WOTTBL
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Pulsewidth 0 65535 uSec
    ;mptbldesc WOTTBL_defines_the_wide-open_throttle_base_fuel_delivery_curve_indexed_by_manifold_absolute_pressure._WOTTBL_is_the_primary_table_for_adjusting_wide-open_throttle_air-fuel_ratios_under_turbo_boost._When_upgrading_to_larger_injectors,_scale_WOTTBL_downward_proportionally_across_all_boost_points_to_prevent_rich_misfires_and_loss_of_power.
    ;mpmapaxis x
    ;mpinjscale scale
    .byte 0x00                   ;Point 1
    .word 0x0000, 0x1551
    .byte 0x81                   ;Point 2
    .word 0x0ABE, 0x21B9
    .byte 0xAC                   ;Point 3
    .word 0x1068, 0x14C8
    .byte 0xFF

	;.org	0x8235
BATOFF_FuelBatteryOffset:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x07F1
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelBatteryOffset
    ;mptblcname BATOFF
    ;mpxaxis Battery 0 16.2 Volts
    ;mpyaxis Pulsewidth 0 4095.94 uSec
    ;mptbldesc BATOFF_defines_the_fuel_injector_dead_time_latency_offset_curve_indexed_against_electrical_system_battery_voltage._BATOFF_must_be_recalibrated_whenever_installing_aftermarket_fuel_injectors,_such_as_Bosch_EV14_or_Siemens_Deka_units._Modern_high-impedance_injectors_have_faster_opening_response_and_different_voltage_sensitivity_curves_compared_to_stock_factory_low-impedance_or_high-impedance_pintle_injectors.
    .byte 0x04                       ;Number of points in table
    .byte 0x59, 0x6A, 0xFE, 0xDB     ;Point 1
    .byte 0x82, 0x3B, 0xFF, 0x90     ;Point 2
    .byte 0xC2, 0x1F, 0xFF, 0xCA     ;Point 3
    .byte 0xFB, 0x13                 ;Point 4

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

	;.org	0x8248
CURVEA_FuelColdEnrichmentCurveA:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x080F
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelColdEnrichmentCurveA
    ;mptblcname CURVEA
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis factor 1 1.996 factor
    ;mptbldesc CURVEA_defines_the_initial_post-start_enrichment_curve_(Curve_A)_indexed_against_engine_coolant_temperature._CURVEA_is_the_primary_parameter_for_eliminating_post-start_stumbling,_hesitation,_and_lean_misfires_during_the_first_15_to_45_seconds_after_driving_away._If_an_engine_starts_cleanly_but_stumbles,_bucks,_or_leans_out_within_the_first_half-minute_of_driving_on_cold_mornings,_raise_CURVEA_values_at_the_corresponding_coolant_temperature.
    .byte 0x06                       ;Number of points in table
    .byte 0x58, 0xFF, 0xFA, 0xCA     ;Point 1
    .byte 0x74, 0x6D, 0xFD, 0x80     ;Point 2
    .byte 0x84, 0x45, 0xFD, 0x5B     ;Point 3
    .byte 0x92, 0x20, 0x00, 0x00     ;Point 4
    .byte 0xA6, 0x20, 0xFF, 0xC9     ;Point 5
    .byte 0xE3, 0x13                 ;Point 6

	;.org	0x8263
CURVEB_FuelColdEnrichmentCurveB:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x0822
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelColdEnrichmentCurveB
    ;mptblcname CURVEB
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 1.992 factor
    ;mptbldesc CURVEB_defines_the_steady-state_warm-up_enrichment_curve_(Curve_B)_indexed_against_engine_coolant_temperature._Adjusting_CURVEB_is_essential_for_eliminating_warm-up_flat_spots_and_lean_hesitation_during_the_first_several_miles_of_driving._If_the_engine_starts_and_drives_fine_for_the_first_30_seconds_but_begins_hesitating,_bucking,_or_running_lean_as_you_drive_down_the_road_before_reaching_180_degF,_raise_CURVEB_at_those_coolant_temperatures.
    .byte 0x08                       ;Number of points in table
    .byte 0x58, 0x70, 0xFE, 0x37     ;Point 1
    .byte 0x74, 0x3E, 0xFE, 0xCD     ;Point 2
    .byte 0x92, 0x1A, 0xFF, 0xB7     ;Point 3
    .byte 0xA0, 0x16, 0xFD, 0x80     ;Point 4
    .byte 0xA6, 0x07, 0xFF, 0xB8     ;Point 5
    .byte 0xBF, 0x00, 0x00, 0x00     ;Point 6
    .byte 0xEE, 0x00, 0x00, 0xE9     ;Point 7
    .byte 0xF9, 0x0A                 ;Point 8

	;.org	0x8286
CURVEC_FuelColdEnrichmentCurveC:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x0837
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelColdEnrichmentCurveC
    ;mptblcname CURVEC
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 1 2.992 factor
    ;mptbldesc CURVEC_defines_the_intermediate_warm-up_enrichment_curve_(Curve_C)_indexed_against_engine_coolant_temperature._Tuning_CURVEC_cures_drivability_flat_spots_that_emerge_roughly_one_minute_after_starting,_after_Curve_A_has_decayed_but_before_the_engine_is_warm_enough_for_Curve_B_alone_to_sustain_smooth_operation.
    .byte 0x06                       ;Number of points in table
    .byte 0x79, 0x3A, 0xFF, 0x8C     ;Point 1
    .byte 0x84, 0x35, 0xFE, 0xEE     ;Point 2
    .byte 0x92, 0x26, 0xFF, 0x2D     ;Point 3
    .byte 0xA9, 0x13, 0x00, 0x00     ;Point 4
    .byte 0xEE, 0x13, 0x02, 0x80     ;Point 5
    .byte 0xF6, 0x27                 ;Point 6

	;.org	0x829d
FCRCVB_FuelWOTScaleEnrichBFromRpm:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x084A
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelWOTScaleEnrichBFromRpm
    ;mptblcname FCRCVB
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis factor 0 0.996 factor
    ;mptbldesc FCRCVB_defines_an_engine_speed_(RPM)_scaling_curve_applied_to_warm-up_enrichment_Curve_B_during_wide-open_throttle_operation._FCRCVB_protects_against_over-fueling_during_aggressive_driving_on_cold_engine_oil_and_coolant._For_street_calibrations,_retaining_the_factory_scaling_ensures_that_full-throttle_pulls_before_full_operating_temperature_do_not_bog_the_engine_or_wet-foul_spark_plugs.
    .byte 0x02                       ;Number of points in table
    .byte 0x7D, 0x00, 0xFD, 0x91     ;Point 1
    .byte 0xCE, 0x3B                 ;Point 2

	;.org	0x82b0
TMPHLD_TempSwitchPointForCurveAHoldDecay:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x0859
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TempSwitchPointForCurveAHoldDecay
    ;mptblcname TMPHLD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc TMPHLD_defines_the_coolant_temperature_switch_point_that_divides_cold_starts_from_hot_restarts_for_after-start_enrichment_hold_and_decay_timing._TMPHLD_should_be_calibrated_to_match_the_engine's_mechanical_thermostat_rating._In_factory_calibrations_with_a_stock_180_degF_thermostat,_the_176_degF_switch_point_correctly_classifies_warm_restarts_under_hot_decay_rules_while_treating_warm-up_operations_as_cold_starts.
    .byte 0x95                       ;Point 1

	;.org	 0x82b1
CLDHLD_CurveAColdHoldTime:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x0866
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAColdHoldTime
    ;mptblcname CLDHLD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 180 out
    ;mptbldesc CLDHLD_specifies_the_duration_that_after-start_cold_enrichment_(Curve_A)_is_held_at_100%_full_strength_before_decay_begins_following_a_cold_start._When_the_engine_starts_with_coolant_temperature_below_TMPHLD,_fuel_droplets_condense_heavily_on_cold_intake_runner_walls._Adjusting_CLDHLD_resolves_cold_morning_driveaway_hesitation_and_rough_idle_flare.
    .byte 0x55                       ;Point 1

	;.org	 0x82b2
HOTHLD_CurveAHotHoldTime:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x0873
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAHotHoldTime
    ;mptblcname HOTHLD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HOTHLD_specifies_the_duration_that_after-start_enrichment_(Curve_A)_is_held_at_full_strength_following_a_hot_restart._Tuning_HOTHLD_cures_lean_hot-restart_surges,_rough_idle,_and_stalling_after_brief_stops_(such_as_restarting_after_fueling_at_a_gas_station)._If_a_warm_engine_starts_readily_but_experiences_a_lean_stumble,_rpm_drop,_or_hesitation_when_driving_away_after_a_10-minute_hot_soak,_raise_HOTHLD_to_extend_enrichment_hold_time.
    .byte 0x0E                       ;Point 1

	;.org	0x82b3
DCYTMC_CurveAColdDecayTime:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x0880
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAColdDecayTime
    ;mptblcname DCYTMC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DCYTMC_defines_the_decay_rate_divisor_for_after-start_cold_enrichment_(Curve_A)_following_a_cold_start._Tuning_DCYTMC_smooths_the_handoff_between_after-start_cold_enrichment_and_long-term_warm-up_enrichment._Raising_DCYTMC_causes_after-start_enrichment_to_decay_more_rapidly,_terminating_extra_cold_fuel_faster._Lowering_DCYTMC_slows_the_decay_rate,_prolonging_the_decay_taper_over_a_longer_time_span.
    .byte 0x04                       ;Point 1

	;.org	 0x82b4
DCYTMH_CurveAHotDecayTime:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x088D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAHotDecayTime
    ;mptblcname DCYTMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DCYTMH_defines_the_decay_rate_divisor_for_after-start_enrichment_(Curve_A)_following_a_hot_restart._Tuning_DCYTMH_controls_hot_restart_fuel_decay_speed._Raising_DCYTMH_accelerates_hot_enrichment_decay,_dropping_extra_fuel_quickly_after_restarting_a_warm_engine._This_helps_eliminate_rich_stumbling,_spark_plug_carbon_fouling,_and_high_exhaust_emissions_when_restarting_warm_engines_equipped_with_large_aftermarket_injectors.
    .byte 0x09                       ;Point 1

	 ;.org	 0x82b5
CCURV_HoldTimeForCurveC:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x089A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HoldTimeForCurveC
    ;mptblcname CCURV
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 180 out
    ;mptbldesc CCURV_defines_the_hold_duration_for_intermediate_warm-up_enrichment_(Curve_C)._Tuning_CCURV_smooths_intermediate_cold-start_drivability._Raising_CCURV_extends_the_full-strength_dwell_of_intermediate_enrichment,_preventing_cold-engine_hesitation_or_lean_stumbles_when_driving_away_shortly_after_starting._Lowering_CCURV_begins_the_decay_process_sooner,_reducing_fuel_enrichment_during_early_warm-up_driving.
    .byte 0x07                       ;Point 1

	 ;.org	 0x82b6
DCYCC_DecayRateForCurveC:
    ;mpgrp 1_-_Fuel\B_-_Running\
    ;mptbladdr 0x08A7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DecayRateForCurveC
    ;mptblcname DCYCC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DCYCC_defines_the_decay_rate_subtraction_constant_for_intermediate_cold_enrichment_(Curve_C)._After_intermediate_hold_time_(CCURV)_expires,_DCYCC_is_subtracted_from_the_enrichment_decay_register_every_32_main_loop_passes._DCYCC_controls_the_decay_speed_of_intermediate_warm-up_enrichment._Raising_DCYCC_accelerates_the_decay_rate,_causing_intermediate_cold_enrichment_to_fade_out_faster_and_reducing_fuel_consumption_during_warm-up.
    .byte 0x12                       ;Point 1



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

	;.org	0x82b7
HIGHMP_ColdLoadFromCoolantTemp:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x08C4
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ColdLoadFromCoolantTemp
    ;mptblcname HIGHMP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis enrichment 0 99.6 percent
    ;mptbldesc HIGHMP_defines_the_temperature-dependent_gain_curve_for_cold_engine_high-load_enrichment_at_closed_throttle_and_idle._Tuning_HIGHMP_cures_cold-engine_idle_sag,_hesitation,_and_stalling_when_placing_an_automatic_transmission_into_gear_or_loading_the_engine_shortly_after_cold_start._Raising_HIGHMP_values_provides_richer_cold-load_enrichment,_smoothing_out_cold_idle_load_transitions.
    .byte 0x02                       ;Number of points in table
    .byte 0x84, 0x6F, 0xFD, 0xE8     ;Point 1
    .byte 0x89, 0x00                 ;Point 2

	;.org	0x82ca
HMPMUL_ColdLoadFromMAP:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x08D3
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname ColdLoadFromMAP
    ;mptblcname HMPMUL
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Factor 0 99.6 percent
    ;mptbldesc HMPMUL_defines_the_manifold_absolute_pressure_weighting_curve_for_cold_engine_load_enrichment_at_closed_throttle_and_idle._HMPMUL_must_be_rescaled_when_upgrading_from_a_factory_2-bar_MAP_sensor_to_a_3-bar_MAP_sensor._Because_a_3-bar_sensor_outputs_lower_voltage_for_a_given_vacuum_level,_leaving_HMPMUL_unscaled_causes_under-enrichment_during_cold_loading.
    ;mpmapaxis x
    .byte 0x03                       ;Number of points in table
    .byte 0x44, 0x00, 0x00, 0x88     ;Point 1
    .byte 0x55, 0x09, 0x00, 0x19     ;Point 2
    .byte 0x88, 0x0E                 ;Point 3

	;.org	0x82e1
HIGHM2_ColdLoadFromCoolantTemp2:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x08E4
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ColdLoadFromCoolantTemp2
    ;mptblcname HIGHM2
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis enrichment 0 99.6 percent
    ;mptbldesc HIGHM2_defines_the_part-throttle_cold_load_enrichment_curve_indexed_by_engine_coolant_temperature._Tuning_HIGHM2_cures_cold_part-throttle_acceleration_stumble,_hesitation,_or_lean_popping_when_driving_away_on_a_cold_morning._If_an_engine_idles_smoothly_when_cold_but_stumbles_or_hesitates_when_stepping_on_the_gas_to_drive_down_the_street_before_reaching_180_degF,_increase_HIGHM2_values_at_the_corresponding_coolant_temperatures.
    .byte 0x02                       ;Number of points in table
    .byte 0x84, 0x6F, 0xFD, 0xE8     ;Point 1
    .byte 0x89, 0x00                 ;Point 2

	;.org	0x82f4
HMPMU2_ColdLoadFromMAP2:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x08F3
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname ColdLoadFromMAP2
    ;mptblcname HMPMU2
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Factor 0 99.6 percent
    ;mptbldesc HMPMU2_defines_the_part-throttle_cold_load_manifold_pressure_weighting_curve._HMPMU2_must_be_rescaled_when_converting_to_a_3-bar_MAP_sensor_to_maintain_proper_vacuum_calibration._Raising_HMPMU2_values_enriches_cold_part-throttle_acceleration,_eliminating_flat_spots_and_hesitation_during_cold_driveaway._Lowering_HMPMU2_values_leans_out_cold_cruising_mixtures,_preventing_spark_plug_fouling_and_improving_fuel_economy_during_warm-up.
    ;mpmapaxis x
    .byte 0x03                       ;Number of points in table
    .byte 0x44, 0x00, 0x00, 0x88     ;Point 1
    .byte 0x55, 0x09, 0x00, 0x19     ;Point 2
    .byte 0x88, 0x0E                 ;Point 3

	;.org	0x830b
BAROCP_BaroCompensationOfWarmupFactor_FromBaro:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x0904
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BaroCompensationOfWarmupFactor_FromBaro
    ;mptblcname BAROCP
    ;mpxaxis Baro -14.7 14.7 psi
    ;mpyaxis Factor 0 99.6 percent
    ;mptbldesc BAROCP_defines_the_barometric_pressure_compensation_curve_for_warm-up_fuel_enrichment._BAROCP_ensures_consistent_cold_drivability_when_driving_across_varying_elevations._In_factory_calibrations,_BAROCP_maintains_100%_warm-up_fueling_at_sea_level_(14.7_psi_absolute)_and_tapers_fuel_slightly_at_mountain_elevations.
    ;mpmapaxis x
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0x8316
RUNTMP_ModifierOf_ENGTMP_FromStalltime:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x0913
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ModifierOf_ENGTMP_FromStalltime
    ;mptblcname RUNTMP
    ;mpxaxis time_after_stall 0 720 sec
    ;mpyaxis delta 0 720 temp
    ;mptbldesc RUNTMP_defines_a_coolant_temperature_offset_curve_that_simulates_engine_heat_soak_following_an_engine_stall_or_brief_key-off._Tuning_RUNTMP_cures_hot-restart_flooding,_rich_stumbling,_and_extended_cranking_after_an_unexpected_engine_stall._If_an_engine_stalls_during_warm-up_(such_as_popping_the_clutch_when_pulling_away)_and_subsequently_cranks_sluggishly_with_a_strong_fuel_smell_or_flooded_spark_plugs,_increase_RUNTMP_values.
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x00, 0x03, 0xAB     ;Point 1
    .byte 0x06, 0x16, 0x09, 0x00     ;Point 2
    .byte 0x0B, 0x43                 ;Point 3

	;.org	0x8321
RUNLMT_MaxAllowableTempFor_RUNTMP:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x0923
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxAllowableTempFor_RUNTMP
    ;mptblcname RUNLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc RUNLMT_defines_the_maximum_allowable_coolant_temperature_ceiling_below_which_post-stall_heat_soak_temperature_modeling_(RUNTMP)_is_permitted._If_an_engine_stalls_when_coolant_temperature_is_already_above_RUNLMT,_the_engine_is_recognized_as_fully_warmed_up,_and_heat_soak_modeling_is_bypassed_completely._In_almost_all_performance_and_street_applications,_RUNLMT_should_remain_at_its_factory_setting_of_160_counts_(145_degF).
    .byte 0xA3                       ;Point 1

	;.org	0x8322
PEFTBL_PumpingEfficiency:
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x0930
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname PumpingEfficiency_FromRpm
    ;mptblcname PEFTBL
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis PumpEff 0 99.6 percent
    ;mptbldesc PEFTBL_defines_the_engine_pumping_efficiency_(volumetric_efficiency)_curve_versus_engine_speed_(RPM)_in_Chrysler_speed-density_calibrations._PEFTBL_is_the_primary_volumetric_efficiency_shaping_tool_when_upgrading_camshafts,_porting_cylinder_heads,_installing_larger_valves,_or_fitting_high-flow_intake_manifolds.
    .byte 0x0B                       ;Number of points in table
    .byte 0x10, 0xD7, 0x00, 0x00     ;Point 1
    .byte 0x1B, 0xD7, 0x00, 0x00     ;Point 2
    .byte 0x3F, 0xD7, 0x00, 0x95     ;Point 3
    .byte 0x4B, 0xDE, 0xFF, 0xEB     ;Point 4
    .byte 0x57, 0xDD, 0x00, 0x51     ;Point 5
    .byte 0x7D, 0xE9, 0x00, 0x4F     ;Point 6
    .byte 0x8A, 0xED, 0xFF, 0xEB     ;Point 7
    .byte 0x96, 0xEC, 0xFF, 0x55     ;Point 8
    .byte 0xA2, 0xE4, 0xFF, 0x14     ;Point 9
    .byte 0xBB, 0xCD, 0xFE, 0xA6     ;Point 10
    .byte 0xCF, 0xB2                 ;Point 11

	;.org	0x8349
AIRTMP_FuelEnrichmentFromChargeTemp: ;copied from the '89T2 calibration, does not exsist in the '89T1 cals
    ;mpgrp 1_-_Fuel\C_-_Modifiers\
    ;mptbladdr 0x0948
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelEnrichmentFromChargeTemp
    ;mptblcname AIRTMP
    ;mpxaxis Charge_Temp 0 5 volts
    ;mpyaxis factor 1 1.996 factor
    ;mptbldesc AIRTMP_defines_the_intake_air_charge_temperature_fuel_compensation_curve._AIRTMP_ensures_consistent_air-fuel_ratios_across_varying_weather_conditions_and_intercooler_temperatures._In_sub-freezing_winter_driving,_AIRTMP_adds_enrichment_(up_to_+25_percent_fuel)_to_prevent_lean_combustion_under_dense_ambient_air.
    .byte 0x05                       ;Number of points in table
    .byte 0x1A, 0x00, 0x00, 0x29     ;Point 1
    .byte 0x59, 0x0A, 0x00, 0x2F     ;Point 2
    .byte 0x90, 0x14, 0x00, 0x4B     ;Point 3
    .byte 0xE9, 0x2E, 0x01, 0x00     ;Point 4
    .byte 0xFB, 0x40                 ;Point 5

	;.org	0x8358
PWADD_FuelPWModifierFromBaro:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x095A
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FuelPWModifierFromBaro
    ;mptblcname PWADD
    ;mpxaxis Baro -14.7 14.7 psi
    ;mpyaxis Pulsewidth 0 12288 uSec
    ;mptbldesc PWADD_provides_barometric_pressure_fuel_compensation_by_adding_injector_pulse_width_at_high_altitudes._Raise_table_values_if_the_engine_experiences_lean_surging,_rough_idle,_or_hesitation_when_driving_in_high-altitude_environments._Lower_or_zero_out_table_values_if_modified_engines_or_large_injectors_run_excessively_rich_at_elevation.
    ;mpmapaxis x
    ;mpinjscale scale
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0x8367
POSTRG_PositiveTransientTriggerLevel:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0x096A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PositiveTransientTriggerLevel
    ;mptblcname POSTRG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc POSTRG_defines_the_minimum_rate_of_throttle_position_sensor_voltage_increase_required_to_trigger_a_throttle-based_acceleration_enrichment_pump_shot._Lowering_POSTRG_makes_the_throttle_acceleration_pump_more_sensitive,_firing_extra_fuel_on_very_small_throttle_inputs_to_eliminate_hairline_tip-in_hesitations.
    .byte 0x03                       ;Point 1

	;.org	0x8368
THRMAX_MaxDeltaTHR:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0x0977
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxDeltaTHR
    ;mptblcname THRMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc THRMAX_defines_the_maximum_allowable_throttle_position_sensor_delta_voltage_used_to_compute_the_throttle-based_acceleration_enrichment_pump_shot._Lowering_THRMAX_limits_the_maximum_volume_of_fuel_that_a_rapid_throttle_depression_can_deliver,_which_is_especially_critical_when_running_high-flow_aftermarket_fuel_injectors_that_deliver_substantially_more_fuel_per_millisecond.
    .byte 0x26                       ;Point 1

	;.org	0x8369
POSSLP_DeltaTPSEnrichment_FromTemp:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0x0984
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname Enrichment_FromTemp
    ;mptblcname POSSLP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis pw 0 60 ms/volt
    ;mptbldesc POSSLP_establishes_the_temperature-dependent_gain_curve_for_throttle-based_acceleration_enrichment_pump_shots._Raising_table_values_increases_the_size_of_the_throttle_pump_shot,_curing_lean_tip-in_stumbles,_intake_manifold_pops,_or_hesitations_upon_sudden_acceleration._Lowering_table_values_reduces_transient_fuel_volume,_which_is_essential_when_installing_larger_fuel_injectors.
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x74, 0x36, 0xFE, 0xD1     ;Point 1
    .byte 0x8F, 0x16, 0xFF, 0x7C     ;Point 2
    .byte 0xB2, 0x04                 ;Point 3

	;.org	0x8378
MAPTRG_DeltaMapTriggerLevel:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x0995
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapTriggerLevel
    ;mptblcname MAPTRG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc MAPTRG_defines_the_minimum_rate_of_intake_manifold_pressure_increase_required_to_trigger_a_MAP-based_acceleration_enrichment_pump_shot._Lowering_MAPTRG_increases_sensitivity_to_manifold_pressure_changes,_triggering_transient_enrichment_on_smaller_throttle_modulations_to_eliminate_light-throttle_tip-in_hesitation.
    ;mpmapaxis y
    .byte 0x07                       ;Point 1

	;.org	0x8379
MAPMAX_MaxDeltaMapAllowed:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x09A3
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MaxDeltaMapAllowed
    ;mptblcname MAPMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc MAPMAX_sets_the_maximum_allowable_manifold_pressure_delta_used_when_calculating_a_MAP-based_acceleration_enrichment_pump_shot._Lowering_MAPMAX_caps_the_maximum_transient_fuel_delivered_during_rapid_manifold_pressure_spikes,_preventing_rich_bogging_when_snapping_the_throttle_open_at_low_RPM.
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1

	;.org	0x837a
AESLOP_DeltaMAPEnrichmentPT:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x09B1
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname DeltaMAPEnrichmentPT
    ;mptblcname AESLOP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis pwEnrich 0 255 uS/torr
    ;mptbldesc AESLOP_defines_the_temperature-dependent_gain_curve_for_MAP-based_acceleration_enrichment_pump_shots._Increasing_table_values_cures_lean_tip-in_stumbles,_hesitation,_or_intake_popping_that_occurs_specifically_as_manifold_pressure_jumps_from_vacuum_into_boost._Decreasing_table_values_is_required_when_installing_larger_injectors_to_prevent_momentary_rich_bogging_and_exhaust_smoke_upon_sudden_acceleration.
    ;mpmapaxis -y
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x58, 0x56, 0xFF, 0x6D     ;Point 1
    .byte 0x95, 0x33, 0xFF, 0x20     ;Point 2
    .byte 0xCD, 0x02                 ;Point 3

	;.org	0x8389
OCTAE_FakeDeltaMapIncrease:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x09C3
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname FakeDeltaMapIncrease
    ;mptblcname OCTAE
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc OCTAE_defines_the_artificial_manifold_pressure_delta_step_injected_during_off-idle_throttle_transitions._When_the_driver_steps_on_the_accelerator_pedal_and_the_throttle_blade_opens,_intake_manifold_pressure_rises_rapidly._Adjusting_OCTAE_tailors_the_sharpness_of_off-idle_throttle_response._Raising_OCTAE_forces_a_larger_artificial_pressure_differential_upon_tip-in,_prompting_the_fuel_system_to_inject_a_heavier_burst_of_acceleration_enrichment.
    ;mpmapaxis y
    .byte 0x02                       ;Point 1

	;.org	0x838a
LOTTHR_DecelLeanoutFactor_FromTemp:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_TPS_LO\
    ;mptbladdr 0x09D1
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelLeanoutFactor_FromTemp
    ;mptblcname LOTTHR
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 0.996 factor
    ;mptbldesc LOTTHR_specifies_the_coolant_temperature-dependent_fuel_multiplier_applied_when_the_throttle_closes_rapidly_during_vehicle_deceleration._Increasing_table_values_above_zero_engages_deceleration_fuel_leaning,_multiplying_the_base_fuel_pulse_width_by_less_than_1.00_to_reduce_fuel_consumption_and_prevent_rich_exhaust_burble_on_deceleration.
    .byte 0x04                       ;Number of points in table
    .byte 0x8A, 0x00, 0xFA, 0xAB     ;Point 1
    .byte 0x90, 0xE0, 0x00, 0x00     ;Point 2
    .byte 0xBC, 0xE0, 0x01, 0xD3     ;Point 3
    .byte 0xCD, 0x00                 ;Point 4

	;.org	0x8399
LOTTRG_DeltaTriggerForDecelLeanout:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_TPS_LO\
    ;mptbladdr 0x09E2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaTriggerForDecelLeanout
    ;mptblcname LOTTRG
    ;mpxaxis in_desc -200 260 degrees
    ;mpyaxis Factor 0 0.996 percent
    ;mptbldesc LOTTRG_establishes_the_primary_trigger_threshold_for_throttle-based_deceleration_lean-out._In_calibrations_where_throttle_deceleration_lean-out_is_desired,_lower_LOTTRG_from_255_to_a_sensible_threshold_such_as_5_to_10_counts_representing_0.10_to_0.20_volts._Setting_the_trigger_too_low_causes_minor_pedal_modulations_during_cruising_to_trigger_unwanted_fuel_reductions,_causing_noticeable_surging_and_hesitation.
    .byte 0x0B                       ;Point 1

	;.org	0x839a
LOTRG2_SecondDecelLeanoutTrigger:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_TPS_LO\
    ;mptbladdr 0x09EF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SecondDecelLeanoutTrigger
    ;mptblcname LOTRG2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LOTRG2_defines_the_second,_more_aggressive_trigger_threshold_for_throttle-based_deceleration_lean-out._When_enabling_throttle_deceleration_lean-out,_set_LOTRG2_approximately_5_to_10_counts_higher_than_LOTTRG._For_example,_setting_LOTTRG_to_5_counts_and_LOTRG2_to_10_counts_creates_a_two-stage_response_where_gentle_throttle_closures_apply_mild,_incremental_fuel_reductions_while_abrupt_lift-offs_engage_full_deceleration_lean-out_immediately.
    .byte 0x0B                       ;Point 1

	;.org	0x839b
LOTHYS_LeanoutDeltaThrottleHysteresis:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_TPS_LO\
    ;mptbladdr 0x09FC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LeanoutDeltaThrottleHysteresis
    ;mptblcname LOTHYS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LOTHYS_provides_hysteresis_for_throttle_deceleration_lean-out_triggers_to_prevent_rapid_toggling_between_normal_fueling_and_decel_lean-out._Once_deceleration_lean-out_becomes_active,_the_engine_controller_adds_LOTHYS_to_the_closing_throttle_delta_before_comparing_it_to_the_trigger_thresholds._When_configuring_throttle_deceleration_lean-out,_set_LOTHYS_to_approximately_2_to_4_counts_representing_0.04_to_0.08_volts.
    .byte 0x01                       ;Point 1

	;.org	0x839c
DECEL_DecelLeanoutFactorMAP:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x0A09
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelLeanoutFactorMAP_FromTemp
    ;mptblcname DECEL
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 0.996 factor
    ;mptbldesc DECEL_defines_the_coolant_temperature-dependent_fuel_multiplier_applied_when_manifold_absolute_pressure_drops_rapidly_during_engine_deceleration._Increasing_table_values_reduces_the_amount_of_deceleration_fuel_leaning,_preserving_richer_mixtures_during_lift-off._Lowering_table_values_cuts_fuel_more_aggressively,_improving_fuel_economy_and_engine_braking_on_long_downhill_descents.
    .byte 0x02                       ;Number of points in table
    .byte 0x90, 0x00, 0xD0, 0x00     ;Point 1
    .byte 0xB1, 0xD0                 ;Point 2

	;.org	0x83ab
DECTRG_DeltaMapTriggerForNoIncrementalLeanout:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x0A18
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapTriggerForNoIncrementalLeanout
    ;mptblcname DECTRG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc DECTRG_sets_the_primary_manifold_pressure_drop_threshold_required_to_initiate_incremental_deceleration_lean-out._Lowering_DECTRG_makes_MAP_deceleration_lean-out_engage_on_smaller_vacuum_increases,_helping_lean_out_the_mixture_sooner_during_gradual_deceleration._However,_setting_this_value_too_low_can_cause_steady-speed_cruising_surging_if_manifold_vacuum_fluctuates_slightly.
    ;mpmapaxis y
    .byte 0x14                       ;Point 1

	;.org	0x83ac
DTRG2_DeltaMapTriggerForMaxLeanout:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x0A26
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapTriggerForMaxLeanout
    ;mptblcname DTRG2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc DTRG2_defines_the_second_manifold_pressure_drop_threshold_that_triggers_full,_immediate_deceleration_lean-out._Set_DTRG2_higher_than_DECTRG_to_create_a_smooth_two-stage_deceleration_response._Lowering_DTRG2_causes_the_engine_controller_to_jump_directly_to_maximum_lean-out_on_moderate_throttle_releases,_sharpening_engine_braking_and_cutting_emissions_quickly.
    ;mpmapaxis y
    .byte 0x14                       ;Point 1

	;.org	0x83ad
DECHYS_DeltaMapHysteresisonTriggerLevels:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x0A34
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapHysteresisonTriggerLevels
    ;mptblcname DECHYS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc DECHYS_establishes_hysteresis_for_MAP_deceleration_lean-out_trigger_levels_to_stabilize_fuel_control_during_unsteady_deceleration._Keep_DECHYS_calibrated_between_1_and_3_counts_to_maintain_stable_deceleration_fueling._Setting_DECHYS_too_high_delays_the_exit_from_decel_lean-out_when_the_driver_begins_lightly_re-applying_the_throttle,_resulting_in_a_lean_stumble_or_hesitation_upon_tip-in.
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

	;.org	0x83ae
DLTRPM2_RPMDeltaForRPMFilter:
    ;mpgrp 0_-_Setup\D_-_Transfer_Functions\
    ;mptbladdr 0x0A42
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMDeltaForRPMFilter
    ;mptblcname DLTRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DLTRPM2_establishes_the_engine_speed_delta_filter_threshold_evaluated_during_manifold_pressure_averaging_updates._Tuners_should_leave_DLTRPM2_at_its_factory_setting_of_two_hundred_fifty-five_counts._Chrysler_calibrators_defaulted_this_constant_to_the_maximum_value_to_bypass_rapid_engine_speed_delta_clamping.
    .byte 0xFF                       ;Point 1

	;.org	0x83af
LOTRPM_MinRpmForMapLeanout:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x0A4F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinRpmForMapLeanout
    ;mptblcname LOTRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc LOTRPM_sets_the_minimum_engine_speed_threshold_required_for_MAP-based_deceleration_lean-out_to_operate._Adjust_LOTRPM_based_on_transmission_type_and_idle_characteristics._In_manual_transmission_setups_with_lightweight_flywheels,_raising_LOTRPM_to_2200_to_2400_RPM_gives_the_engine_more_time_to_recover_full_fueling,_eliminating_RPM_dipping_and_stalling_when_pushing_the_clutch_pedal_in_during_deceleration.
    .byte 0x2F                       ;Point 1

	;.org	0x83b0
DCELTM_O2CNTRInhibitAfterLeanoutDone:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x0A5C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2CNTRInhibitAfterLeanoutDone
    ;mptblcname DCELTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DCELTM_defines_the_duration_for_which_closed-loop_oxygen_sensor_feedback_is_inhibited_following_maximum_deceleration_lean-out._When_an_engine_decelerates_with_leaned-out_fuel_delivery,_the_exhaust_gas_stream_temporarily_goes_very_lean._Increase_DCELTM_to_10_to_30_counts_representing_approximately_110_to_330_milliseconds_if_wideband_data_logging_shows_rich_overshooting_or_fuel_trim_distortion_immediately_after_deceleration_events.
    .byte 0x01                       ;Point 1

	;.org	0x83b1
POSTIG_MinAisPulseRequireToTriggerEnrichment:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\AIS_PumpShot\
    ;mptbladdr 0x0A69
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinAisPulseRequireToTriggerEnrichment
    ;mptblcname POSTIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc POSTIG_sets_the_minimum_idle_air_stepper_motor_step_increase_required_to_trigger_automatic_idle_air_acceleration_enrichment._Lowering_POSTIG_makes_the_idle_transient_enrichment_activate_on_smaller_idle_air_movements,_preventing_RPM_dips_or_stumbles_when_shifting_an_automatic_transmission_into_gear_or_when_the_electric_radiator_fan_turns_on.
    .byte 0x0D                       ;Point 1

	;.org	0x83b2
POSFUL_AisEnrichmentFuelPulse:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\AIS_PumpShot\
    ;mptbladdr 0x0A76
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname AisEnrichmentFuelPulse
    ;mptblcname POSFUL
    ;mpxaxis in_desc 0 65535 scale
    ;mpyaxis AISPW 0 65535 uSec
    ;mptbldesc POSFUL_specifies_the_pulse_width_of_the_auxiliary_acceleration_enrichment_pulse_injected_when_the_idle_air_stepper_motor_opens_rapidly._Scale_POSFUL_inversely_when_upgrading_to_larger_fuel_injectors._For_example,_if_upgrading_to_injectors_that_flow_50_percent_more_fuel,_reduce_POSFUL_to_approximately_233_microseconds_so_the_actual_volume_of_injected_fuel_remains_constant.
    ;mpinjscale word
    .word 0x0140                     ;Point 1

	;.org	0x83b4
LMAPTC_TimeConstant:
; this is actually one of the 2 MAP averaging factor tables
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_MAP_LO\
    ;mptbladdr 0x0A85
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TimeConstant
    ;mptblcname LMAPTC
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 0.996 factor
    ;mptbldesc LMAPTC_establishes_the_digital_filter_time_constant_for_the_rolling_average_manifold_pressure_during_deceleration_conditions._Adjusting_LMAPTC_alters_the_decay_rate_of_the_manifold_pressure_delta_during_deceleration._Lowering_table_values_causes_the_rolling_average_to_lag_further_behind_the_falling_manifold_pressure,_prolonging_the_calculated_pressure_delta_and_extending_deceleration_lean-out_duration.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x48                 ;Point 1

	;.org	0x83bf
AETIME_EnrichmentTime_FromTemp:
; this is actually one of the 2 MAP averaging factor tables
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x0A94
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname EnrichmentTime_FromTemp_MAP
    ;mptblcname AETIME
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 0.996 factor
    ;mptbldesc AETIME_establishes_the_digital_filter_time_constant_that_governs_the_decay_rate_of_MAP-based_acceleration_enrichment._Increasing_AETIME_causes_the_rolling_average_to_catch_up_faster,_shortening_the_duration_of_the_MAP_pump_shot_for_crisper_throttle_response_on_light_cars._Decreasing_AETIME_slows_the_filter_update_rate,_allowing_the_rolling_average_to_lag_longer_and_extending_the_duration_of_transient_enrichment.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x14                 ;Point 1

	;.org	0x83c6
THRTCN_EnrichmentTime_FromTemp:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0x0AA2
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname EnrichmentTime_FromTemp_TPS
    ;mptblcname THRTCN
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 0.996 factor
    ;mptbldesc THRTCN_defines_the_digital_filter_time_constant_governing_the_duration_of_throttle-based_acceleration_enrichment_pump_shots_across_engine_coolant_temperatures._Increasing_table_values_accelerates_the_rolling_average_filter,_causing_the_TPS_transient_fuel_pulse_to_decay_away_more_rapidly._This_produces_a_sharper,_more_responsive_throttle_feel_on_responsive_engines.
    .byte 0x02                       ;Number of points in table
    .byte 0x74, 0x18, 0x00, 0x17     ;Point 1
    .byte 0xCD, 0x20                 ;Point 2

	;.org	0x83d1
LOTIME_DecelLeanoutTimeConstant_FromTemp:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Decel_Lean-out\Decreasing_TPS_LO\
    ;mptbladdr 0x0AB1
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelLeanoutTimeConstant_FromTemp
    ;mptblcname LOTIME
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 0.996 factor
    ;mptbldesc LOTIME_establishes_the_digital_filter_time_constant_for_rolling_average_throttle_voltage_during_throttle_closing_transitions._Modifying_LOTIME_alters_the_persistence_of_the_calculated_throttle_closing_delta._Lowering_table_values_slows_the_decay_of_the_rolling_average,_keeping_the_calculated_throttle_drop_active_across_more_engine_cycles_and_prolonging_throttle_deceleration_lean-out.
    .byte 0x02                       ;Number of points in table
    .byte 0xBC, 0x04, 0x0E, 0xC4     ;Point 1
    .byte 0xCD, 0xFF                 ;Point 2

	;.org	0x83d8
RPMMAP_SwitchPointForDownUp_FromRpm :
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0AC0
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname SwitchPointForDownUp_FromRpm
    ;mptblcname RPMMAP
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc RPMMAP_defines_the_manifold_pressure_threshold_curve_across_engine_speed_that_separates_the_increasing_part-throttle_enrichment_zone_from_the_decreasing_part-throttle_enrichment_zone._Adjust_RPMMAP_to_control_the_engine_load_threshold_where_aggressive_part-throttle_boost_enrichment_begins.
    ;mpmapaxis y
    .byte 0x05                       ;Number of points in table
    .byte 0x51, 0xB3, 0xFE, 0xB0     ;Point 1
    .byte 0x61, 0x9E, 0xFD, 0x80     ;Point 2
    .byte 0x67, 0x8F, 0xFD, 0x91     ;Point 3
    .byte 0x7E, 0x57, 0xFF, 0x5F     ;Point 4
    .byte 0xCC, 0x26                 ;Point 5

	;.org	0x83ef
PTELMT_MultiplierMaxLimitFromRpm:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0AD3
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname MultiplierMaxLimitFromRpm
    ;mptblcname PTELMT
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Factor 0 0.996 percent
    ;mptbldesc PTELMT_establishes_the_engine_speed-dependent_ceiling_for_part-throttle_open-loop_fuel_enrichment._Raise_PTELMT_values_if_wideband_data_logging_shows_that_the_engine_runs_leaner_than_desired_during_long_part-throttle_pulls_in_boost._Raising_the_limit_allows_the_open-loop_enrichment_multiplier_to_ramp_to_higher_fuel_percentages,_providing_extra_detonation_margin_on_high-performance_turbocharged_builds.
    .byte 0x06                       ;Number of points in table
    .byte 0x3F, 0x3E, 0xFF, 0x37     ;Point 1
    .byte 0x5B, 0x28, 0x00, 0xA8     ;Point 2
    .byte 0x81, 0x41, 0x02, 0x80     ;Point 3
    .byte 0x87, 0x50, 0xFF, 0xDA     ;Point 4
    .byte 0xA2, 0x4C, 0x00, 0x8A     ;Point 5
    .byte 0xAF, 0x53                 ;Point 6

	;.org	0x8406
PTEADJ_EnrichAdjust_FromMap:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0AE6
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname EnrichAdjust_FromMap
    ;mptblcname PTEADJ
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Factor 0.5 1.496 factor
    ;mptbldesc PTEADJ_provides_signed_manifold_pressure-dependent_scaling_to_the_part-throttle_enrichment_ceiling_established_by_PTELMT._Calibrate_PTEADJ_to_sculpt_the_part-throttle_enrichment_ceiling_across_specific_boost_levels._Increasing_table_values_in_the_positive_boost_region_raises_the_maximum_enrichment_ceiling,_ensuring_that_heavily_boosted_engines_receive_sufficient_fuel_under_sustained_part-throttle_acceleration.
    ;mpmapaxis x
    .byte 0x06                       ;Number of points in table
    .byte 0x55, 0xA6, 0x02, 0xCD     ;Point 1
    .byte 0x6E, 0xEC, 0x00, 0x00     ;Point 2
    .byte 0x97, 0xEC, 0x02, 0x80     ;Point 3
    .byte 0x9F, 0x00, 0x00, 0x00     ;Point 4
    .byte 0xC4, 0x00, 0xFD, 0x44     ;Point 5
    .byte 0xE2, 0xAE                 ;Point 6

	;.org	0x8421
PTENR_EppPerAmountForIncreasing:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0AFA
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname EppPerAmountForIncreasing
    ;mptblcname PTENR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc PTENR_establishes_the_engine_position_pulse_countdown_interval_and_step_size_governing_how_rapidly_part-throttle_enrichment_ramps_upward_when_manifold_pressure_exceeds_the_RPMMAP_boundary_curve._Calibrate_PTENR_to_tune_the_ramp-in_rate_of_part-throttle_boost_enrichment.
    .word 0x3D01                     ;Point 1

	;.org	 0x8423
PTENR2_EppPerAmountForDecreasingMultiplier:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0B07
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EppPerAmountForDecreasingMultiplier
    ;mptblcname PTENR2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc PTENR2_sets_the_distributor_reference_pulse_countdown_interval_governing_the_decay_rate_of_part-throttle_enrichment_when_manifold_pressure_falls_below_the_RPMMAP_boundary_curve._Adjust_PTENR2_to_optimize_how_quickly_transient_enrichment_decays_when_exiting_boost.
    .byte 0x3D                       ;Point 1

	;.org	0x8424
PTENRD_AmountForDecreasingMultiplier_Negative:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0B14
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AmountForDecreasingMultiplier_Negative
    ;mptblcname PTENRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc PTENRD_specifies_the_signed_step_decrement_added_to_the_open-loop_fraction_timer_on_each_decay_interval_when_manifold_pressure_falls_below_the_RPMMAP_boundary_curve._Configure_PTENRD_to_control_the_step_size_of_transient_fuel_decay_when_exiting_boost._Setting_PTENRD_to_more_negative_values_such_as_minus_two_or_minus_three_counts_accelerates_enrichment_decay,_rapidly_leaning_out_the_mixture_to_save_fuel.
    .byte 0xFF                       ;Point 1

	;.org	0x8425
PTENUM_NumberToReturnToHOTMAP:
    ;mpgrp 1_-_Fuel\D_-_Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0x0B21
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NumberToReturnToHOTMAP
    ;mptblcname PTENUM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc PTENUM_defines_the_hysteresis_threshold_multiplier_required_to_clear_the_part-throttle_enrichment_maximum_flag_and_return_ignition_advance_to_standard_running_schedules_after_transient_enrichment_has_peaked._Tune_PTENUM_to_stabilize_ignition_timing_transitions_following_hard_part-throttle_acceleration._Increasing_PTENUM_broadens_the_hysteresis_window,_keeping_modified_ignition_timing_active_longer_after_peak_enrichment_is_reached.
    .byte 0x02                       ;Point 1

	;.org	0x8426
BOOSTP_AdjustO2ResponseForPTEWhenMapAboveThis:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0B2E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdjustO2ResponseForPTEWhenMapAboveThis
    ;mptblcname BOOSTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc BOOSTP_defines_the_manifold_absolute_pressure_threshold_above_which_closed-loop_oxygen_sensor_feedback_is_inhibited_and_the_engine_controller_is_forced_into_open-loop_fueling._Lowering_BOOSTP_ensures_that_the_engine_controller_reliably_transitions_out_of_closed-loop_oxygen_sensor_feedback_into_open-loop_power_enrichment_whenever_manifold_pressure_approaches_or_exceeds_atmospheric_pressure.
    .byte 0xFF                       ;Point 1

	;.org	0x8427
O2ITIM_TimeO2InhibitedSwitchingRichIdleToClosedLoop:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0B3B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeO2InhibitedSwitchingRichIdleToClosedLoop
    ;mptblcname O2ITIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2ITIM_defines_the_duration_that_closed-loop_oxygen_sensor_feedback_is_inhibited_when_transitioning_from_a_rich_idle_state_back_to_standard_closed-throttle_closed-loop_operation._Tuning_O2ITIM_helps_prevent_idle_hunting_and_lean_stumbling_when_returning_to_closed_loop_after_idle_diagnostic_modes_or_rich_idle_stabilization_periods.
    .byte 0xFF                       ;Point 1

	;.org	0x8428
RICHSA_OpenLoopEnrichFactorWhenSettingBasicTiming:
    ;mpgrp 5_-_Idle\C_-_Special_setup\
    ;mptbladdr 0x0B48
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OpenLoopEnrichFactorWhenSettingBasicTiming
    ;mptblcname RICHSA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc RICHSA_establishes_the_open-loop_fuel_enrichment_factor_injected_whenever_the_engine_controller_enters_mechanical_basic_ignition_timing_service_mode._Retain_RICHSA_at_its_factory_calibration_value_of_26_counts_for_standard_street_setups._Raising_RICHSA_enriches_the_open-loop_fueling_mixture_during_distributor_timing_synchronization,_which_can_help_smooth_out_rough_idling_on_high-lift_camshaft_configurations_with_significant_overlap.
    .byte 0x34                       ;Point 1

	;.org	0x8429
SPKSET_ConstantSparkAdvanceWhenSettingBasicTiming:
    ;mpgrp 5_-_Idle\C_-_Special_setup\
    ;mptbladdr 0x0B55
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ConstantSparkAdvanceWhenSettingBasicTiming
    ;mptblcname SPKSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Advance 0 127.5 degrees
    ;mptbldesc SPKSET_defines_the_fixed_reference_spark_advance_angle_commanded_by_the_engine_controller_when_operating_in_mechanical_basic_timing_mode._SPKSET_should_generally_remain_at_its_factory_setting_of_12_degrees_BTDC_to_preserve_alignment_with_the_physical_factory_timing_marks_on_the_flywheel_and_transmission_bellhousing.
    .byte 0x0C                       ;Point 1

	;.org	0x842a
IDLDEF_TargetIdleSpeed_HBDefault:
    ;mpgrp 5_-_Idle\C_-_Special_setup\
    ;mptbladdr 0x0B62
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TargetIdleSpeed_HBDefault
    ;mptblcname IDLDEF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc IDLDEF_defines_the_default_target_idle_speed_commanded_by_the_engine_controller_when_the_coolant_temperature_sensor_signal_is_invalid_or_disconnected._During_normal_vehicle_operation,_the_SMEC_calculates_target_idle_speed_dynamically_by_indexing_2D_temperature_curves_for_in-gear_and_park_or_neutral_states._Raising_IDLDEF_increases_the_backup_idle_target_speed_during_sensor_fault_conditions.
    .byte 0x7D                       ;Point 1

	;.org	0x842b
RIDLST_OpenLoopEnrichFactorWhenSettingMinThrottleOpening:
    ;mpgrp 5_-_Idle\C_-_Special_setup\
    ;mptbladdr 0x0B6F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OpenLoopEnrichFactorWhenSettingMinThrottleOpening
    ;mptblcname RIDLST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc RIDLST_establishes_the_open-loop_fuel_enrichment_multiplier_commanded_when_entering_diagnostic_service_mode_to_calibrate_the_mechanical_minimum_throttle_plate_stop_screw._Chrysler_throttle_bodies_incorporate_a_mechanical_stop_screw_that_establishes_the_minimum_closed-throttle_bypass_airflow_around_the_throttle_plate._Maintain_RIDLST_at_its_factory_setting_of_26_counts_for_standard_calibrations.
    .byte 0x34                       ;Point 1

	;.org	0x842c
IDLSET_ConstantSparkAdvanceWhenSettingMinThrottleOpening:
    ;mpgrp 5_-_Idle\C_-_Special_setup\
    ;mptbladdr 0x0B7C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ConstantSparkAdvanceWhenSettingMinThrottleOpening
    ;mptblcname IDLSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Advance 0 127.5 degrees
    ;mptbldesc IDLSET_defines_the_fixed_spark_advance_angle_commanded_when_the_engine_controller_enters_DRB_diagnostic_service_mode_for_minimum_throttle_airflow_adjustment._Maintain_IDLSET_at_the_factory_calibration_value_of_12_degrees_BTDC._This_constant_ensures_consistent_ignition_advance_during_baseline_mechanical_throttle_body_stop_screw_alignment_across_all_Chrysler_turbo_engines.
    .byte 0x0C                       ;Point 1

	;.org	0x842d
AMTEMP_StartTempToSelectHotOrColdAMTimer:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Adaptive_Memory_Timer\
    ;mptbladdr 0x0B89
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StartTempToSelectHotOrColdAMTimer
    ;mptblcname AMTEMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc AMTEMP_defines_the_engine_coolant_temperature_threshold_that_switches_the_adaptive_fuel_memory_system_between_cold_warmup_delay_timing_and_fully_warmed_hot_engine_operation._Adjusting_AMTEMP_is_necessary_when_installing_lower-temperature_performance_thermostats,_such_as_180_degF_or_160_degF_units.
    .byte 0xCD                       ;Point 1

	;.org	0x842e
AMTPSW_TempPointToEnableSelectedAMTimer:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Adaptive_Memory_Timer\
    ;mptbladdr 0x0B96
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempPointToEnableSelectedAMTimer
    ;mptblcname AMTPSW
    ;mpxaxis Coolant_Temp -200 260 deg
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AMTPSW_is_a_two-dimensional_lookup_table_that_establishes_the_initial_delay_time_before_adaptive_fuel_memory_learning_is_enabled,_indexed_against_engine_coolant_temperature._Tuning_AMTPSW_allows_control_over_how_quickly_long-term_fuel_trims_begin_learning_after_cold_starts_or_hot_restarts.
    .byte 0x02                       ;Number of points in table
    .byte 0xA6, 0x0C, 0x01, 0x55     ;Point 1
    .byte 0xCD, 0x40                 ;Point 2

	;.org	0x843d
CLTIME_ClosedLoopTimeFromEngTempAtStartup_FromTemp:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Adaptive_Memory_Timer\
    ;mptbladdr 0x0BA5
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ClosedLoopTimeFromEngTempAtStartup_FromTemp
    ;mptblcname CLTIME
    ;mpxaxis Coolant_Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc CLTIME_is_a_two-dimensional_lookup_table_that_specifies_the_elapsed_delay_time_required_before_the_engine_controller_transitions_from_open-loop_startup_enrichment_into_closed-loop_oxygen_sensor_feedback,_indexed_against_startup_coolant_temperature._Freshly_cranked_engines_require_rich_open-loop_fuel_delivery_to_maintain_steady_combustion_until_cylinders_warm_and_intake_manifold_air_velocity_stabilizes.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x03                 ;Point 1

	;.org	0x8444
CLTEMP_TempToStartCLTIMETimer:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\Adaptive_Memory_Timer\
    ;mptbladdr 0x0BB3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TempToStartCLTIMETimer
    ;mptblcname CLTEMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 degrees
    ;mptbldesc CLTEMP_defines_the_absolute_minimum_engine_coolant_temperature_required_before_the_engine_controller_will_start_the_closed-loop_countdown_timer_and_allow_closed-loop_oxygen_sensor_feedback._Modifying_CLTEMP_alters_the_thermal_gatekeeper_for_closed-loop_operation._In_warm_climates_or_mild_ambient_conditions,_lowering_CLTEMP_allows_the_engine_to_enter_closed_loop_earlier_during_morning_warmups,_saving_fuel.
    .byte 0x94                       ;Point 1

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

    ;.org   0xc37b
MP1_AutoCalMapCellBoundary1:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0BD0
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary1
    ;mptblcname MP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc MP1_defines_the_first_manifold_absolute_pressure_load_boundary_in_the_adaptive_fuel_memory_grid,_separating_Cell_0_and_1_from_Cell_2_and_3._Tuning_MP1_is_essential_when_converting_to_high-duration_performance_camshafts_or_upgrading_to_a_3-bar_manifold_absolute_pressure_sensor.
    ;mpmapaxis y
    .byte 0x28                       ;Point 1

    ;.org   0xc37c
MP2_AutoCalMapCellBoundary2:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0BDE
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary2
    ;mptblcname MP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc MP2_establishes_the_second_manifold_absolute_pressure_boundary_in_the_adaptive_memory_system,_separating_Cell_2_and_3_from_Cell_4_and_5._Adjusting_MP2_enables_tuners_to_fine-tune_the_transition_between_steady_highway_cruising_and_gentle_acceleration._Lowering_MP2_narrows_the_light-cruise_fuel_trim_band,_forcing_the_engine_controller_into_the_mid-load_cells_sooner_during_throttle_tip-in.
    ;mpmapaxis y
    .byte 0x37                       ;Point 1

    ;.org   0xc37d
MP3_AutoCalMapCellBoundary3:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0BEC
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary3
    ;mptblcname MP3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc MP3_defines_the_third_manifold_absolute_pressure_boundary_in_the_adaptive_fuel_memory_structure,_separating_Cell_4_and_5_from_Cell_6_and_7._Tuning_MP3_allows_isolation_of_mid-range_driveability_issues._If_an_engine_exhibits_part-throttle_hesitations_or_lean_surges_during_gradual_hill_climbs,_shifting_MP3_higher_or_lower_helps_align_the_boundary_with_the_engine_volumetric_efficiency_curve.
    ;mpmapaxis y
    .byte 0x4B                       ;Point 1

    ;.org   0xc37e
MP4_AutoCalMapCellBoundary4:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0BFA
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary4
    ;mptblcname MP4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc MP4_sets_the_fourth_manifold_absolute_pressure_boundary,_separating_Cell_6_and_7_from_Cell_8_and_9_in_the_adaptive_memory_grid._Adjusting_MP4_helps_segregate_heavy_part-throttle_cruise_from_the_near-atmospheric_transition._Lowering_MP4_allows_the_upper_adaptive_cells_to_engage_earlier,_which_is_beneficial_when_tuning_heavy_vehicles_or_vehicles_pulling_trailers_where_heavy_part-throttle_operation_is_sustained.
    ;mpmapaxis y
    .byte 0x61                       ;Point 1

    ;.org   0xc37f
MP5_AutoCalMapCellBoundary5:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0C08
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary5
    ;mptblcname MP5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc MP5_defines_the_fifth_and_highest_manifold_absolute_pressure_boundary_in_the_adaptive_memory_grid,_separating_Cell_8_and_9_from_Cell_10_and_11._Tuning_MP5_determines_how_close_to_positive_boost_pressure_the_final_closed-loop_adaptive_fuel_trim_cells_operate._If_MP5_is_set_too_close_to_barometric_pressure,_rapid_atmospheric_fluctuations_or_high_elevation_can_cause_the_engine_to_bounce_across_the_boundary.
    ;mpmapaxis y
    .byte 0x78                       ;Point 1

    ;.org   0xc380
DLTMAP_MapHysteresisAtMapCellBoundaries:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0C16
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MapHysteresisAtMapCellBoundaries
    ;mptblcname DLTMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc DLTMAP_establishes_the_directional_manifold_absolute_pressure_hysteresis_added_to_each_boundary_point_when_determining_whether_to_transition_into_a_higher-load_adaptive_memory_cell._Raising_DLTMAP_increases_the_stability_of_cell_selection_on_engines_with_rough_manifold_pressure_signals,_such_as_those_equipped_with_aggressive_camshafts_or_individual_runner_manifolds_that_produce_strong_intake_pulsations.
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

    ;.org   0xc381
R1_RPMCellBoundaryInRPMover32:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0C24
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMCellBoundaryInRPMover32
    ;mptblcname R1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Engine_RPM 0 8160 RPM
    ;mptbldesc R1_defines_the_primary_engine_speed_boundary_separating_the_lower_engine_speed_adaptive_memory_cells_from_the_upper_engine_speed_cells_across_all_six_manifold_pressure_columns._The_12_off-idle_cells_are_organized_as_6_load_columns_split_into_low-RPM_even_cells_(0,_2,_4,_6,_8,_10)_and_high-RPM_odd_cells_(1,_3,_5,_7,_9,_11)._Adjusting_R1_aligns_the_adaptive_memory_speed_split_with_the_engine_cruising_RPM_characteristics.
    .byte 0x3A                       ;Point 1

    ;.org   0xc382
DLTRPM_DeltaRPMAtRPMBoundariesInRPMOver32:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0C31
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaRPMAtRPMBoundariesInRPMOver32
    ;mptblcname DLTRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DLTRPM_establishes_the_directional_engine_speed_hysteresis_applied_to_the_R1_boundary_when_transitioning_between_low-RPM_and_high-RPM_adaptive_fuel_cells._Tuning_DLTRPM_prevents_boundary_hunting_on_engines_with_lightweight_flywheels,_manual_transmissions,_or_irregular_engine_speeds._Raising_DLTRPM_to_3_or_4_counts_(96_to_128_RPM)_creates_a_broader_deadband_that_prevents_cell_oscillation_during_small_speed_variations_on_choppy_roads.
    .byte 0x02                       ;Point 1

    ;.org   0xc383
IDLOFS_DeltaForIdleRPMForClosedThrottleCell:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0C3E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaForIdleRPMForClosedThrottleCell
    ;mptblcname IDLOFS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc IDLOFS_defines_the_engine_speed_window_above_the_target_idle_speed_that_qualifies_the_engine_to_use_Cell_12,_the_dedicated_closed-throttle_idle_adaptive_fuel_trim_cell._When_the_throttle_is_closed,_the_engine_controller_checks_whether_actual_engine_speed_is_below_target_idle_speed_plus_IDLOFS._Tuning_IDLOFS_is_critical_when_setting_up_engines_with_aggressive_camshafts_or_elevated_idle_speeds.
    .byte 0x03                       ;Point 1

    ;.org   0xc384
HYTRPM_HysteresisFor_IDLOFS:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0C4B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HysteresisFor_IDLOFS
    ;mptblcname HYTRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HYTRPM_provides_extra_engine_speed_hysteresis_added_to_the_idle_cell_qualification_threshold_once_the_engine_is_already_operating_inside_Cell_12._If_the_engine_is_currently_in_Cell_12,_the_controller_adds_HYTRPM_on_top_of_IDLOFS_before_comparing_actual_engine_speed_against_the_ceiling._Raising_HYTRPM_stabilizes_idle_fuel_trim_tracking_on_engines_with_noticeable_idle_lope_or_significant_electrical_and_accessory_load_fluctuations.
    .byte 0x02                       ;Point 1

    ;.org   0xc385
CELCHG_BitsChangePerUpdateWithinACell:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0C58
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BitsChangePerUpdateWithinACell
    ;mptblcname CELCHG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CELCHG_defines_the_incremental_step_size_in_bits_by_which_an_active_adaptive_fuel_memory_cell_is_adjusted_whenever_an_update_event_occurs._Raising_CELCHG_allows_adaptive_memory_cells_to_learn_and_compensate_for_fueling_errors_more_rapidly,_which_can_speed_up_adaptation_after_battery_disconnects_or_when_changing_fuel_blends.
    .byte 0x01                       ;Point 1

    ;.org   0xc386
AMUPDT_EPPsBetweenCalChangeUpdateOpenThrottle:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0C65
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EPPsBetweenCalChangeUpdateOpenThrottle
    ;mptblcname AMUPDT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AMUPDT_specifies_the_number_of_engine_pulse_periods_(distributor_rising_edges)_that_must_accumulate_while_operating_off-idle_before_the_controller_is_permitted_to_update_the_active_adaptive_fuel_memory_cell._Raising_AMUPDT_slows_the_adaptation_rate_during_part-throttle_cruising_by_requiring_more_engine_cycles_between_trim_increments,_which_prevents_transient_throttle_movements_from_corrupting_cruising_cells.
    .byte 0x1A                       ;Point 1

    ;.org   0xc387
AMUPDI_EPPsBetweenCalChangeUpdateClosedThrottle:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0C72
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EPPsBetweenCalChangeUpdateClosedThrottle
    ;mptblcname AMUPDI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AMUPDI_specifies_the_number_of_engine_pulse_periods_(distributor_rising_edges)_required_between_adaptive_fuel_memory_updates_while_operating_at_closed-throttle_idle_in_Cell_12._At_800_RPM,_26_distributor_pulses_elapse_in_approximately_one_second._In_stock_calibrations,_AMUPDI_is_set_to_26_counts,_matching_the_part-throttle_rate._Adjusting_AMUPDI_is_beneficial_when_stabilizing_idle_fueling_on_engines_with_aftermarket_camshafts_or_large_injectors.
    .byte 0x1A                       ;Point 1

    ;.org   0xc388
CALTHR_O2ControllerDeadbandLimitForUpdatingCells:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0C7F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2ControllerDeadbandLimitForUpdatingCells
    ;mptblcname CALTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CALTHR_defines_the_deadband_threshold_evaluated_against_the_short-term_oxygen_sensor_feedback_counter_before_determining_whether_closed-loop_operation_is_stable._When_closed_loop_is_active,_the_feedback_counter_accumulates_rich_and_lean_kicks._Tuning_CALTHR_controls_the_sensitivity_of_the_closed-loop_feedback_stability_verification.
    .byte 0x09                       ;Point 1

    ;.org   0xc389
MAPLIM_NoCellUpdateAboveThisMAP:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0C8C
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname NoCellUpdateAboveThisMAP
    ;mptblcname MAPLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc MAPLIM_defines_the_upper_manifold_absolute_pressure_limit_above_which_closed-loop_oxygen_sensor_feedback_is_inhibited_and_adaptive_memory_cell_updates_are_blocked._Lowering_MAPLIM_forces_the_engine_controller_into_open_loop_at_lower_manifold_pressures,_ensuring_that_power_enrichment_takes_over_earlier.
    ;mpmapaxis y
    .byte 0x8A                       ;Point 1

    ;.org   0xc38a
MAPDEC_NoCellUpdateAndO2CNTRHeldBelowThisMap:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0C9A
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname NoCellUpdateAndO2CNTRHeldBelowThisMap
    ;mptblcname MAPDEC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc MAPDEC_defines_the_minimum_manifold_absolute_pressure_floor_below_which_closed-loop_oxygen_sensor_feedback_is_held_in_open_loop_and_adaptive_cell_updates_are_blocked._Tuning_MAPDEC_ensures_that_trailing-throttle_deceleration_does_not_falsely_influence_closed-loop_trims_or_cause_open-loop_dropouts_during_normal_cruise.
    ;mpmapaxis y
    .byte 0x1F                       ;Point 1

    ;.org   0xc38b
RPMLIM_NoCellUpdateAboveThisRPMInRPMOver32:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0CA8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoCellUpdateAboveThisRPMInRPMOver32
    ;mptblcname RPMLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Engine_RPM 0 8160 rpm
    ;mptbldesc RPMLIM_establishes_the_upper_engine_speed_limit_for_closed-loop_oxygen_sensor_feedback_and_adaptive_fuel_memory_updates._At_high_engine_speeds,_rapid_valve_timing_and_high_exhaust_gas_velocity_reduce_the_precision_of_narrowband_oxygen_sensor_feedback,_while_engine_load_demands_favor_rich,_open-loop_power_enrichment._Raising_RPMLIM_extends_closed-loop_stoichiometric_fuel_control_and_adaptive_trim_learning_to_higher_cruising_engine_speeds.
    .byte 0x56                       ;Point 1

    ;.org   0xc38c
AMLIMH_MaxMultiplierCannotBeAbove7F:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0CB5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxMultiplierCannotBeAbove7F
    ;mptblcname AMLIMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AMLIMH_establishes_the_maximum_allowable_positive_fuel_enrichment_ceiling_for_all_long-term_adaptive_fuel_memory_cells_(AutoCal_cells)._Adjusting_AMLIMH_is_a_primary_tool_for_constraining_or_disabling_long-term_fuel_trims._When_tuning_base_fuel_tables_on_a_dyno_using_a_wideband_sensor,_setting_AMLIMH_to_zero_prevents_adaptive_memory_from_adding_positive_trims_that_would_mask_underlying_calibration_errors.
    .byte 0x7F                       ;Point 1

    ;.org   0xc38d
AMLIML_MinMultiplierCannotBeBelow80:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0CC2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinMultiplierCannotBeBelow80
    ;mptblcname AMLIML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AMLIML_defines_the_maximum_allowable_negative_fuel_leanout_floor_for_all_long-term_adaptive_fuel_memory_cells_(AutoCal_cells)._Constraining_AMLIML_provides_critical_safety_when_running_aftermarket_fuel_systems._When_conducting_initial_base_table_mapping_with_a_wideband_controller,_setting_AMLIML_to_zero_locks_out_negative_adaptation,_ensuring_that_the_engine_runs_purely_on_the_programmed_base_fuel_curves.
    .byte 0xB3                       ;Point 1


    ;.org   0xc365
PWMIN_NoCellUpdateBelow_PWMIN_Pulsewidth:
    ;mpgrp 1_-_Fuel\F_-_Adaptive_memory\
    ;mptbladdr 0x0CD0
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname NoCellUpdateBelow_PWMIN_Pulsewidth
    ;mptblcname PWMIN
    ;mpxaxis in_desc 0 65535 scale
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc PWMIN_establishes_the_absolute_minimum_injector_pulse_width_required_before_the_engine_controller_will_permit_an_adaptive_fuel_memory_cell_update._Tuning_PWMIN_is_mandatory_when_installing_larger_high-flow_fuel_injectors.
    ;mpinjscale word
    .word 0x00FA                     ;Point 1

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

PRIRMP_PrimaryRamp:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\O2_Controller_Ramps\
    ;mptbladdr 0x0D28
    ;mptbltype 11
    ;mpsubtype 1
    ;mptbllname PrimaryRamp
    ;mptblcname PRIRMP
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc PRIRMP_is_a_specialized_22-word_ramp_configuration_table_that_governs_short-term_oxygen_sensor_feedback_fuel_corrections_across_a_3_by_3_grid_of_engine_speed_and_manifold_pressure_load_cells,_plus_a_dedicated_closed-throttle_idle_cell._Tuning_PRIRMP_is_essential_for_resolving_rich_closed-loop_fueling_bias,_a_known_characteristic_in_early_factory_and_Mopar_Performance_calibrations_where_rich_kicks_were_larger_than_lean_kicks.
    ;mpmapaxis y
    .word 0x2632                  ;Rpm Low / High Boundary
    .word 0x3355                  ;Map Low / High Boundary
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

; *****************************************
; The Limits are the maximum number of kicks that may be applied to each
; cell. If the O2 sensor fails to toggle after reaching the limit for more
; than a few sec, the AutoCal cell gets changed.
; *****************************************

	;.org	0x8486
O2LIMH_O2RangeLimitHigh:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0D5B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2RangeLimitHigh
    ;mptblcname O2LIMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2LIMH_defines_the_absolute_maximum_positive_fuel_trim_limit_for_short-term_oxygen_sensor_feedback._During_closed-loop_operation,_the_feedback_counter_accumulates_primary_and_secondary_ramp_kicks_to_correct_for_lean_conditions._Constraining_O2LIMH_prevents_the_oxygen_sensor_from_heavily_over-fueling_the_engine_during_transient_lean_spikes_or_misfires.
    .byte 0x7F                       ;Point 1

	;.org	0x8487
O2LIML_O2RangeLimitLow:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0D68
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2RangeLimitLow
    ;mptblcname O2LIML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2LIML_defines_the_absolute_minimum_negative_fuel_trim_limit_for_short-term_oxygen_sensor_feedback._When_the_oxygen_sensor_detects_a_rich_mixture,_the_controller_decrements_the_feedback_counter_to_remove_fuel._Raising_O2LIML_toward_zero_narrows_the_allowable_short-term_leanout_authority,_protecting_modified_engines_against_excessive_leaning_during_tuning_or_road_operation.
    .byte 0xB3                       ;Point 1

	;.org	0x8488
O2HIGH_HighLimitForImmediateSwitchToClosedLoop:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0D75
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForImmediateSwitchToClosedLoop
    ;mptblcname O2HIGH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2HIGH_defines_the_upper_voltage_threshold_required_for_immediate_validation_of_the_narrowband_oxygen_sensor_signal_during_the_closed-loop_entry_sequence._Raising_O2HIGH_requires_the_oxygen_sensor_to_generate_a_higher_rich_voltage_peak_before_it_is_recognized_as_active,_which_can_help_reject_noisy_signals_from_unheated_single-wire_sensors_on_cold_mornings.
    .byte 0x26                       ;Point 1

	;.org	0x8489
O2TLMH_HighLimitForDelayedSwitchToClosedLoop:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0D82
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForDelayedSwitchToClosedLoop
    ;mptblcname O2TLMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2TLMH_establishes_the_upper_boundary_of_the_delayed_closed-loop_entry_voltage_band._Adjusting_O2TLMH_modifies_the_sensitivity_of_the_warmup_qualification_window._Raising_O2TLMH_expands_the_delayed_entry_band,_permitting_the_controller_to_initiate_the_timed_qualification_sequence_across_a_broader_voltage_range_during_sensor_warmup.
    .byte 0x1F                       ;Point 1

	;.org	0x848a
O2MIDH_HighLimitForInMiddleDetermination:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0D8F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForInMiddleDetermination
    ;mptblcname O2MIDH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2MIDH_defines_the_upper_voltage_limit_of_the_stuck-in-the-middle_diagnostic_zone_for_active_closed-loop_operation._A_healthy_narrowband_oxygen_sensor_constantly_swings_between_rich_(above_0.6V)_and_lean_(below_0.3V)._Widening_the_middle_band_by_raising_O2MIDH_makes_the_stuck-sensor_detection_logic_more_aggressive,_catching_sluggish_or_aged_sensors_that_fail_to_swing_cleanly_into_rich_voltage_territory.
    .byte 0x1C                       ;Point 1

	;.org	0x848b
O2HSWP_HighLimitForO2RampSwitching:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0D9C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForO2RampSwitching
    ;mptblcname O2HSWP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2HSWP_establishes_the_rich_switching_threshold_for_closed-loop_oxygen_sensor_feedback._Adjusting_O2HSWP_allows_tuners_to_subtly_shift_the_closed-loop_target_air-fuel_ratio._Raising_O2HSWP_requires_the_sensor_to_reach_a_higher_voltage_before_recognizing_a_rich_mixture,_which_biases_the_average_closed-loop_air-fuel_ratio_slightly_richer,_improving_combustion_smoothness_on_engines_with_large_cams.
    .byte 0x17                       ;Point 1

	;.org	0x848c
O2LSWP_LowLimitForO2RampSwitching:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0DA9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForO2RampSwitching
    ;mptblcname O2LSWP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2LSWP_defines_the_lean_switching_threshold_for_closed-loop_oxygen_sensor_feedback._When_sensor_voltage_falls_below_O2LSWP,_the_mixture_is_classified_as_lean,_instructing_the_controller_to_apply_rich_ramp_kicks_to_add_fuel._Shifting_O2LSWP_works_in_tandem_with_O2HSWP_to_define_the_closed-loop_switching_window._Raising_O2LSWP_biases_the_closed-loop_average_richer,_while_lowering_O2LSWP_biases_it_leaner.
    .byte 0x16                       ;Point 1

	;.org	0x848d
O2MIDL_LowLimitForInMiddleDetermination:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0DB6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForInMiddleDetermination
    ;mptblcname O2MIDL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2MIDL_establishes_the_lower_voltage_limit_of_the_stuck-in-the-middle_diagnostic_zone_during_closed-loop_operation._Tuning_O2MIDL_adjusts_the_lower_boundary_of_the_diagnostic_stuck-sensor_window._Raising_O2MIDL_widens_the_detection_window,_which_increases_diagnostic_sensitivity_to_catch_degraded_sensors_that_cannot_pull_down_to_low_lean_voltages.
    .byte 0x12                       ;Point 1

	;.org	0x848e
O2TLML_LowLimitForDelayedSwitchToClosedLoop:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0DC3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForDelayedSwitchToClosedLoop
    ;mptblcname O2TLML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2TLML_defines_the_lower_boundary_of_the_delayed_closed-loop_entry_voltage_band._Modifying_O2TLML_alters_the_lower_threshold_of_the_warmup_qualification_window._Raising_O2TLML_requires_the_sensor_to_produce_a_higher_voltage_before_the_delayed_qualification_timer_can_start,_which_prevents_noisy_cold_sensor_signals_from_triggering_early_closed-loop_entry._Lowering_O2TLML_allows_the_controller_to_recognize_weak_early_sensor_activity_sooner.
    .byte 0x0F                       ;Point 1

	;.org	0x848f
O2LOW_LowLimitForImmediateSwitchToClosedLoop:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0DD0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForImmediateSwitchToClosedLoop
    ;mptblcname O2LOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2LOW_defines_the_lower_voltage_threshold_for_immediate_validation_of_the_narrowband_oxygen_sensor_signal._Raising_O2LOW_allows_higher_lean_voltages_to_qualify_as_immediate_sensor_validation,_which_speeds_up_closed-loop_entry_after_cold_starts_on_engines_with_good_exhaust_heat_retention.
    .byte 0x0F                       ;Point 1

	;.org	0x8490
O2TIME_DelayTimeToClosedLoop:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0DDD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DelayTimeToClosedLoop
    ;mptblcname O2TIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Delay_Time 0 720 Sec
    ;mptbldesc O2TIME_defines_the_delay_time_required_to_validate_the_oxygen_sensor_when_its_output_voltage_is_hovering_in_the_intermediate_warmup_band_between_O2TLML_and_O2TLMH._Rather_than_forcing_immediate_closed_loop_or_staying_in_open_loop_indefinitely,_the_engine_controller_increments_a_qualification_timer_against_O2TIME._Adjusting_O2TIME_controls_how_conservatively_the_ECU_qualifies_a_warming_oxygen_sensor.
    .byte 0x07                       ;Point 1

	;.org	0x8491
LTHTIM_IfNoO2SwitchForThisTimeThrowFault51or52:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\
    ;mptbladdr 0x0DEA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname IfNoO2SwitchForThisTimeThrowFault51or52
    ;mptblcname LTHTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LTHTIM_defines_the_timeout_duration_that_the_oxygen_sensor_is_permitted_to_remain_on_one_side_(stuck_rich_or_stuck_lean)_without_toggling_before_the_engine_controller_initiates_its_two-strike_fault_sequence._Tuning_LTHTIM_is_crucial_when_installing_long-tube_exhaust_headers,_large-diameter_downpipes,_or_wideband_oxygen_sensors_with_narrowband_simulated_outputs.
    .byte 0x2B                       ;Point 1

    ;.org   0xc3c6
SECRMP_SecondaryRamp:
    ;mpgrp 1_-_Fuel\E_-_O2_Controller\O2_Controller_Ramps\
    ;mptbladdr 0x0DF7
    ;mptbltype 11
    ;mpsubtype 1
    ;mptbllname SecondaryRamp
    ;mptblcname SECRMP
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc SECRMP_is_a_specialized_22-word_secondary_ramp_rate_table_that_functions_as_a_closed-loop_recovery_failsafe_when_the_oxygen_sensor_remains_on_one_side_(rich_or_lean)_longer_than_expected._Tuning_SECRMP_controls_the_aggression_of_the_closed-loop_recovery_system.
    ;mpmapaxis y
    .word 0x2F49                  ;Rpm Low / High Boundary
    .word 0x2B50                  ;Map Low / High Boundary
    .word 0x03FD                  ;Cell 0 Ramp Rich/Lean
    .word 0x04FC                  ;Cell 1 Ramp Rich/Lean
    .word 0x01FF                  ;Cell 2 Ramp Rich/Lean
    .word 0x04FC                  ;Cell 3 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 4 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 5 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 6 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 7 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 8 Ramp Rich/Lean
    .word 0x02FE                  ;Ramp Idle Cell Rich/Lean
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
; ** The 'lean' value is stored in 2's complement format **
;
;     STEP - (factor * 512) - 512  (signed number)
; eg: %0.4  ->	(1.004	* 512) - 512 = 2.048 (dec) = 0x02
; each bit is ~ 0.2%
; *****************************************

	;.org	0x84be
AISTRT_AisStartupPosition_FromTemp:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E26
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisStartupPosition_FromTemp
    ;mptblcname AISTRT
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis AIS_Open 0 255 steps
    ;mptbldesc AISTRT_is_a_2D_calibration_curve_that_establishes_the_open-loop_baseline_step_position_for_the_automatic_idle_speed_stepper_motor_actuator_during_engine_cranking_and_initial_startup_flare._Tuning_AISTRT_is_essential_for_curing_engine_startup_flare_or_cranking_stumble.
    .byte 0x04                       ;Number of points in table
    .byte 0x6E, 0x99, 0xFC, 0x0D     ;Point 1
    .byte 0x81, 0x4E, 0xFF, 0x24     ;Point 2
    .byte 0xCF, 0x0B, 0x00, 0x45     ;Point 3
    .byte 0xF4, 0x15                 ;Point 4

	;.org	0x84d5
RPMDEF_RPMDefaultForIdleControl:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E37
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMDefaultForIdleControl
    ;mptblcname RPMDEF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc RPMDEF_defines_the_default_baseline_engine_speed_target_utilized_by_the_idle_control_logic_during_engine_cranking_and_initial_stall_recovery._When_the_starter_motor_is_turning_the_crankshaft,_actual_engine_speed_is_typically_only_150_to_250_RPM,_which_is_well_below_normal_operating_idle_speed._RPMDEF_should_generally_remain_at_its_factory_setting_of_1280_RPM_for_the_majority_of_street_and_performance_builds.
    .byte 0xA0                       ;Point 1

	;.org	0x84d6
RPMTHS_RPMThresholdForIdleControl:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E44
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMThresholdForIdleControl
    ;mptblcname RPMTHS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc RPMTHS_defines_the_engine_speed_threshold_separating_starter_motor_cranking_or_engine_stall_states_from_active_engine_running_idle_control._RPMTHS_should_remain_at_its_factory_setting_of_200_RPM_under_almost_all_circumstances._This_threshold_ensures_a_clean_boundary_between_starter-driven_rotation_(typically_120_to_180_RPM)_and_genuine_autonomous_engine_operation.
    .byte 0x19                       ;Point 1

	;.org	0x84d7
; this table replaces the 2 constants in the '89 T2 - STTIME and DRIDHT
TIMED2_AISDecelBaseAirflowCurveOffset2:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E52
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelAisBaseAirflowCurveOffset_FromTime2
    ;mptblcname TIMED2
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis Time 0 720 sec
    ;mptbldesc TIMED2_is_a_2D_lookup_curve_that_provides_a_time-decaying_target_idle_speed_adder_following_engine_startup._TIMED2_is_a_useful_tool_for_shaping_post-start_drivability_and_settling_behavior._If_an_engine_tends_to_stumble,_shake,_or_stall_within_the_first_10_to_20_seconds_after_starting,_elevating_the_initial_points_in_TIMED2_to_command_100_to_150_extra_RPM_gives_the_engine_additional_breathing_room_until_combustion_stabilizes.
    .byte 0x02                       ;Number of points in table
    .byte 0x13, 0x0D, 0xFD, 0xD5     ;Point 1
    .byte 0x17, 0x00                 ;Point 2

	;.org	0x84e2
AISDLY_DelayFromStartRunThatAisFeedbackDisabled:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E61
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DelayFromStartRunThatAisFeedbackDisabled
    ;mptblcname AISDLY
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 720 sec
    ;mptbldesc AISDLY_defines_the_post-startup_time_delay_during_which_closed-loop_automatic_idle_speed_feedback_and_spark_scatter_idle_stabilization_are_temporarily_inhibited._Immediately_following_engine_start,_combustion_chamber_conditions_undergo_rapid_thermal_changes,_and_engine_speed_naturally_flares_before_settling_down._Adjusting_AISDLY_helps_stabilize_engines_that_surge_or_dip_immediately_after_starting.
    .byte 0x2D                       ;Point 1

	;.org	0x84e3
AISPN_IdleSpeedParkNeutral_FromTemp:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E6E
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname IdleSpeedParkNeutral_FromTemp
    ;mptblcname AISPN
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis RPM 0 2048 rpm
    ;mptbldesc AISPN_is_the_foundational_2D_calibration_curve_defining_the_target_engine_idle_speed_across_operating_coolant_temperatures_whenever_the_drivetrain_is_unloaded._AISPN_is_the_primary_table_to_adjust_when_setting_baseline_warm_idle_speed_on_manual_transmission_cars_or_in_Park_and_Neutral_on_automatics.
    .byte 0x02                       ;Number of points in table
    .byte 0x7F, 0xAF, 0xFF, 0x35     ;Point 1
    .byte 0xCC, 0x72                 ;Point 2

	;.org	0x84ee
AISCLD_IdleSpeedDrive_FromTemp:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E7D
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname IdleSpeedDrive_FromTemp
    ;mptblcname AISCLD
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis RPM 0 2048 rpm
    ;mptbldesc AISCLD_defines_the_target_idle_speed_curve_across_engine_coolant_temperatures_when_an_automatic_transmission_is_engaged_in_gear_(Drive,_Reverse,_1st,_or_2nd)._AISCLD_is_the_primary_table_for_tuning_in-gear_idle_speed_on_automatic_transmission_Chrysler_vehicles._If_an_aftermarket_camshaft_causes_the_engine_to_shake_or_stall_when_placed_into_Drive_with_the_brakes_applied,_raise_the_warm_operating_cells_of_AISCLD_from_800_RPM_up_to_875_or_950_RPM.
    .byte 0x02                       ;Number of points in table
    .byte 0x80, 0x8A, 0xFF, 0x95     ;Point 1
    .byte 0xCD, 0x6A                 ;Point 2

	;.org	0x84f9
CLDPOS_AisColdPosition_FromTemp:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E8C
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisColdPosition_FromTemp
    ;mptblcname CLDPOS
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis AIS_Open 0 2048 steps
    ;mptbldesc CLDPOS_is_a_2D_calibration_curve_that_establishes_an_additional_cold_off-idle_bypass_airflow_floor_based_on_engine_coolant_temperature._CLDPOS_is_a_key_drivability_curve_for_cold_morning_operation._If_a_cold_vehicle_drives_away_from_a_stop_and_then_stalls_or_stumbles_severely_when_the_driver_lifts_off_the_throttle_to_shift_gears_or_come_to_a_stop_sign,_increase_the_values_in_the_cold_and_warm-up_cells_of_CLDPOS_by_10_to_15_steps.
    .byte 0x03                       ;Number of points in table
    .byte 0x58, 0x54, 0xFF, 0x96     ;Point 1
    .byte 0xB1, 0x2F, 0xFE, 0x55     ;Point 2
    .byte 0xCC, 0x02                 ;Point 3

	;.org	0x8510
RPMPOS_AisPosition_FromRpm:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0E9C
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisPosition_FromRpm
    ;mptblcname RPMPOS
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc RPMPOS_is_a_2D_calibration_curve_that_establishes_a_minimum_automatic_idle_speed_stepper_motor_opening_based_purely_on_engine_RPM._Even_if_the_throttle_is_only_cracked_open_slightly,_high_engine_RPM_creates_massive_engine_vacuum_demand_when_the_throttle_plate_suddenly_snaps_shut._RPMPOS_provides_an_electronic_dashpot_cushion_that_prevents_deceleration_stalling_from_high_engine_speeds.
    .byte 0x02                       ;Number of points in table
    .byte 0x1F, 0x00, 0x00, 0x1A     ;Point 1
    .byte 0x46, 0x04                 ;Point 2

	;.org	0x851f
THRPOS_AisPosition_FromThrottle:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0EAB
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisPosition_FromThrottle
    ;mptblcname THRPOS
    ;mpxaxis TPS 0 5 Volts
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc THRPOS_is_a_2D_calibration_curve_that_establishes_a_minimum_idle_air_stepper_motor_position_based_on_throttle_position_sensor_voltage._As_the_driver_depresses_the_accelerator_pedal_and_drives_off-idle,_the_engine_controller_tracks_throttle_plate_angle._THRPOS_shapes_the_off-idle_throttle-following_behavior_of_the_idle_stepper_motor.
    .byte 0x02                       ;Number of points in table
    .byte 0x03, 0x00, 0x00, 0xAB     ;Point 1
    .byte 0x0F, 0x08                 ;Point 2

	;.org	0x852e
ACPOS_ACPositionWhenTempToCold:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0EBA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ACPositionWhenTempToCold
    ;mptblcname ACPOS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACPOS_defines_the_fixed_auxiliary_step_opening_added_to_the_idle_air_stepper_motor_when_the_air_conditioning_compressor_engages_while_engine_coolant_temperature_is_cold._A_cold_air_conditioning_compressor_pump_contains_thick,_viscous_refrigeration_lubricant_that_imposes_substantial_mechanical_drag_when_the_magnetic_clutch_locks_up._ACPOS_cures_cold-engine_A/C_engagement_stumbles.
    .byte 0x17                       ;Point 1

	;.org	0x852f
CALPOS_PositionAisMotorIsAtIdle:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0EC7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PositionAisMotorIsAtIdle
    ;mptblcname CALPOS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CALPOS_defines_the_calibrated_nominal_step_position_where_the_electronic_controller_assumes_the_idle_air_stepper_motor_sits_during_normal_warm_closed-throttle_idle._Because_stepper_motors_operate_without_a_physical_position_feedback_potentiometer,_the_ECU_tracks_motor_position_by_counting_step_pulses_sent_to_the_motor_coils._CALPOS_must_be_adjusted_whenever_the_mechanical_throttle_body_is_modified_or_replaced.
    .byte 0x1A                       ;Point 1

	;.org	0x8530
CALRAT_AisAdjustRate:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0ED4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisAdjustRate
    ;mptblcname CALRAT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CALRAT_defines_the_loop_counter_bitmask_that_paces_how_frequently_the_engine_controller_nudges_the_automatic_idle_speed_stepper_motor_toward_its_nominal_idle_position._CALRAT_rarely_needs_modification_unless_you_are_debugging_idle_hunting_issues_on_custom_induction_setups.
    .byte 0x07                       ;Point 1

	;.org	0x8531
BARAIS_AISBaroCompensation:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0EE1
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BaroCompensation_FromBaro
    ;mptblcname BARAIS
    ;mpxaxis Baro -14.7 14.7 psi
    ;mpyaxis factor 0 0.996 factor
    ;mptbldesc BARAIS_is_a_2D_calibration_curve_that_provides_barometric_pressure_compensation_for_idle_and_air_conditioning_stepper_motor_adjustments._At_higher_altitudes,_atmospheric_pressure_drops,_reducing_air_density_and_oxygen_mass_per_unit_volume_of_intake_air._BARAIS_ensures_seamless_drivability_and_consistent_idle_recovery_when_driving_in_mountainous_regions.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x5E, 0x26, 0xFC, 0x8C     ;Point 1
    .byte 0x69, 0x00                 ;Point 2

	;.org	0x8540
DLYOF1_UpdateRateOffIdleWhenAisClosing:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0EF1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UpdateRateOffIdleWhenAisClosing
    ;mptblcname DLYOF1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DLYOF1_defines_the_main_program_loop_counter_bitmask_that_paces_the_rate_at_which_the_automatic_idle_speed_stepper_motor_is_permitted_to_step_closed_during_off-idle_driving._When_the_driver_operates_the_throttle_pedal_off-idle,_the_stepper_motor_is_dynamically_pre-positioned_open_based_on_engine_speed_and_throttle_angle._DLYOF1_controls_the_smoothness_of_off-idle_stepper_motor_retraction.
    .byte 0x07                       ;Point 1

	;.org	0x8541
BRKRPM_BrakeOverrideForAis_FromDeltaThrottle:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0EFE
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname BrakeOverrideForAis_FromDeltaThrottle
    ;mptblcname BRKRPM
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc BRKRPM_is_a_2D_calibration_curve_that_establishes_an_engine_speed_brake_override_threshold_for_off-idle_dashpot_airflow._Under_normal_driving,_the_idle_air_stepper_motor_is_held_partially_open_off-idle_to_soften_deceleration_and_prevent_driveline_bucking._BRKRPM_directly_impacts_vehicle_braking_feel_and_engine_braking_performance.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0xC8                 ;Point 1

; these 2 tables have a unique format, they will not disply all the values in CHeM or D-Cal
; they are basically a standard unsigned table, except that the slope is always 0 - making it a step-function
; in the '89 T1 code, this uses a simplified lookup, but the lookup and return values are similar
; this data is translated from the '89 T2 code.
	;.org	0x8550
FWDAIS_ForwardAisSteps_NoSlope:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0F10
    ;mptbltype 12
    ;mpsubtype n
    ;mptbllname ForwardAisSteps_NoSlope
    ;mptblcname FWDAIS
    ;mpxaxis DeltaRPM 0 2048 rpm
    ;mpyaxis AISSteps 0 255 step
    ;mptbldesc FWDAIS_is_the_proportional_correction_lookup_table_that_commands_opening_steps_on_the_automatic_idle_speed_stepper_motor_whenever_engine_speed_falls_below_target_idle._When_electrical_or_mechanical_loads_suddenly_engage,_such_as_the_radiator_cooling_fan_turning_on,_alternator_heavy_charging,_or_power_steering_pump_assist,_engine_speed_sags._FWDAIS_governs_how_aggressively_the_idle_controller_fights_engine_underspeed_dips.
    .byte 0x05                       ;Number of points in table
    .byte 0x0A, 0x01                 ;Point 1
    .byte 0x14, 0x02                 ;Point 2
    .byte 0x1E, 0x04                 ;Point 3
    .byte 0x28, 0x05                 ;Point 4
    .byte 0x32, 0x06                 ;Point 5

	;.org	0x855f
REVAIS_ReverseAisSteps_NoSlope:
    ;mpgrp 5_-_Idle\A_-_AIS_Control\
    ;mptbladdr 0x0F22
    ;mptbltype 12
    ;mpsubtype n
    ;mptbllname ReverseAisSteps_NoSlope
    ;mptblcname REVAIS
    ;mpxaxis DeltaRPM 0 2048 rpm
    ;mpyaxis AISSteps 0 255 step
    ;mptbldesc REVAIS_is_the_proportional_correction_lookup_table_that_commands_closing_steps_on_the_automatic_idle_speed_stepper_motor_whenever_engine_speed_exceeds_target_idle._During_idle_operation,_sudden_reductions_in_engine_load_(such_as_the_cooling_fan_turning_off_or_shifting_from_Drive_into_Neutral)_can_cause_engine_speed_to_flare_above_the_desired_setpoint._REVAIS_controls_how_aggressively_the_engine_pulls_down_an_elevated_or_hanging_idle_speed.
    .byte 0x03                       ;Number of points in table
    .byte 0x0A, 0xFF                 ;Point 1
    .byte 0x14, 0xFE                 ;Point 2
    .byte 0x28, 0xFC                 ;Point 3

	;.org	0x856e
TIMEDC_AISDecelBaseAirflowCurveOffset:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F32
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelAisBaseAirflowCurveOffset_FromTime
    ;mptblcname TIMEDC
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis Time 0 720 sec
    ;mptbldesc TIMEDC_is_a_2D_lookup_curve_that_provides_a_time-decaying_manifold_pressure_offset_added_to_the_deceleration_control_calculation_after_engine_start._When_an_engine_has_recently_started_and_is_driven_off-idle,_intake_manifold_runners_and_cylinder_heads_are_still_absorbing_heat,_and_fuel_atomization_is_not_yet_fully_optimized._TIMEDC_cures_post-start_drive-away_stalls.
    .byte 0x02                       ;Number of points in table
    .byte 0x07, 0x08, 0xFF, 0x1C     ;Point 1
    .byte 0x10, 0x00                 ;Point 2

	;.org	0x857d
TEMPDC_AISDecel_FromTemp:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F41
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelAis_FromTemp
    ;mptblcname TEMPDC
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc TEMPDC_is_a_2D_calibration_curve_that_adds_a_temperature-dependent_offset_to_the_deceleration_control_manifold_pressure_calculation._TEMPDC_is_crucial_for_smoothing_cold_vehicle_deceleration._If_an_engine_decelerates_smoothly_when_hot_but_stumbles,_jerks,_or_stalls_when_you_let_off_the_gas_while_the_engine_is_warming_up_(between_50_°F_and_140_°F),_raise_the_corresponding_temperature_cells_in_TEMPDC.
    .byte 0x02                       ;Number of points in table
    .byte 0x58, 0x28, 0xFF, 0xAA     ;Point 1
    .byte 0xCF, 0x00                 ;Point 2

	;.org	0x858c
DAISOP_DecelAisOpenStepsFromNeg_FromDeltaMap:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F50
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname DecelAisOpenStepsFromNeg_FromDeltaMap
    ;mptblcname DAISOP
    ;mpxaxis DeltaMAP 0 29.4 psi
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc DAISOP_is_the_primary_2D_calibration_curve_that_determines_how_many_steps_to_open_the_automatic_idle_speed_stepper_motor_during_rapid_throttle_deceleration._When_the_driver_suddenly_releases_the_accelerator_pedal,_intake_manifold_pressure_plunges_toward_deep_vacuum._DAISOP_is_the_single_most_powerful_calibration_curve_for_curing_deceleration_stalls_on_modified_Chrysler_turbo_vehicles.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x01, 0x00, 0x00, 0xBA     ;Point 1
    .byte 0x0C, 0x08                 ;Point 2

	;.org	0x859b
DAISCL_DecelAisOpenStepsFromPos_FromDeltaMap:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F60
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname DecelAisOpenStepsFromPos_FromDeltaMap
    ;mptblcname DAISCL
    ;mpxaxis DeltaMAP 0 29.4 psi
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc DAISCL_is_the_2D_calibration_curve_that_determines_how_many_steps_to_close_the_automatic_idle_speed_stepper_motor_as_intake_manifold_pressure_recovers_during_deceleration._DAISCL_governs_how_quickly_the_deceleration_air_cushion_is_pulled_away_as_engine_speed_settles_toward_idle.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x02, 0x00, 0xFF, 0xAB     ;Point 1
    .byte 0x11, 0xFB                 ;Point 2

	;.org	0x85aa
MAPFLR_AISAdditionToControlMap_FromRpm:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F70
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AdditionToControlMap_FromRpm
    ;mptblcname MAPFLR
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis ScaledMAP 0 29.4 psi
    ;mptbldesc MAPFLR_is_a_2D_calibration_curve_that_defines_an_engine-speed-dependent_manifold_absolute_pressure_floor_added_to_the_deceleration_control_calculation._As_engine_RPM_rises,_the_cylinders_pump_a_vastly_greater_volume_of_air_per_unit_time,_resulting_in_deeper_intake_manifold_vacuum_when_the_throttle_plate_closes._MAPFLR_controls_how_much_extra_dashpot_air_is_injected_during_high-RPM_throttle_lift-off.
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x26, 0x00, 0x00, 0x55     ;Point 1
    .byte 0x2F, 0x03                 ;Point 2

	;.org	0x85bd
MPTEMP_TempTermForMapOffset_FromTemp:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F80
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempTermForMapOffset_FromTemp
    ;mptblcname MPTEMP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 0.996 percent
    ;mptbldesc MPTEMP_is_a_2D_calibration_curve_that_provides_a_coolant-temperature-dependent_scaling_multiplier_applied_to_the_RPM-based_deceleration_control_MAP_term._During_cold_engine_operation,_separate_warm-up_tables_(such_as_TEMPDC)_already_provide_substantial_auxiliary_bypass_airflow._MPTEMP_shapes_how_aggressively_high-RPM_decel_air_is_introduced_across_the_engine_warm-up_cycle.
    .byte 0x02                       ;Number of points in table
    .byte 0x90, 0x00, 0x04, 0x83     ;Point 1
    .byte 0xC7, 0xFF                 ;Point 2

	;.org	0x85cc
BARFLR_OffsetCorrectionTo_MAPFLR_FromBaro:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F8F
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname OffsetCorrectionTo_MAPFLR_FromBaro
    ;mptblcname BARFLR
    ;mpxaxis Baro -14.7 14.7 psi
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc BARFLR_is_a_2D_calibration_curve_that_applies_an_altitude-dependent_barometric_pressure_correction_to_the_deceleration_control_manifold_pressure_calculation._At_higher_altitudes,_atmospheric_pressure_is_substantially_lower_than_at_sea_level._BARFLR_rarely_requires_modification_unless_tuning_a_vehicle_specifically_for_extreme_high-altitude_operation_(such_as_Pikes_Peak_hill_climbs_or_high_mountain_passes).
    ;mpmapaxis x
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0x85db
DCLRFQ_TimeBetweenAisPulsesForDecelAis:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0F9E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBetweenAisPulsesForDecelAis
    ;mptblcname DCLRFQ
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 Sec
    ;mptbldesc DCLRFQ_defines_the_minimum_time_delay_that_must_elapse_between_successive_stepper_motor_repositioning_pulses_during_deceleration_dashpot_control._When_the_vehicle_decelerates_with_closed_throttle,_manifold_pressure_drops_rapidly,_triggering_the_decel_dashpot_routines_to_open_the_stepper_motor_to_catch_the_descent._DCLRFQ_controls_how_rapidly_the_idle_stepper_motor_can_respond_to_fast_deceleration_transients.
    .byte 0x3F                       ;Point 1

	;.org	0x85dc
DATHOT_EngineTempToStartCalibratingDacal:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0FAB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineTempToStartCalibratingDacal
    ;mptblcname DATHOT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Deg
    ;mptbldesc DATHOT_defines_the_minimum_engine_coolant_temperature_threshold_required_before_the_controller_enables_adaptive_idle_airflow_calibration._DATHOT_should_match_your_engine_thermostat_rating._If_you_install_a_low-temperature_160_°F_thermostat,_the_engine_may_operate_between_165_°F_and_172_°F_during_cold_weather_driving.
    .byte 0xCD                       ;Point 1

	;.org	0x85dd
DADRPM_DeltaRpmFromIdleSpeedForDacalUpdate:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0FB8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaRpmFromIdleSpeedForDacalUpdate
    ;mptblcname DADRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DADRPM_defines_the_engine_speed_error_deadband_window_within_which_adaptive_idle_airflow_learning_is_permitted_to_operate._DADRPM_must_be_adapted_when_installing_high-performance_camshafts._Factory_engines_idle_smoothly_with_very_little_RPM_fluctuation,_allowing_a_tight_32_RPM_deadband.
    .byte 0x04                       ;Point 1

	;.org	0x85de
DAACF_ACFactorDeltaFromBase:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0FC5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ACFactorDeltaFromBase
    ;mptblcname DAACF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DAACF_defines_the_additional_manifold_pressure_offset_added_to_the_deceleration_control_calculation_whenever_the_air_conditioning_compressor_clutch_is_engaged._When_the_air_conditioner_is_running,_the_mechanical_compressor_pump_imposes_a_continuous_parasitic_torque_load_on_the_engine_crankshaft._DAACF_is_the_primary_adjustment_for_preventing_deceleration_stalls_that_occur_exclusively_when_the_air_conditioning_is_running.
    .byte 0x0D                       ;Point 1

	;.org	0x85df
DANOM_Base_nominalCal:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0FD2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Base_nominalCal
    ;mptblcname DANOM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DANOM_defines_the_base_nominal_calibration_offset_utilized_by_the_Chrysler_SMEC_deceleration_airflow_calculation._DANOM_directly_establishes_the_baseline_sensitivity_of_the_deceleration_dashpot_system._Raising_DANOM_shifts_the_calculated_decel_control_manifold_pressure_higher,_which_causes_the_controller_to_perceive_a_larger_vacuum_delta_when_the_throttle_snaps_shut,_commanding_more_aggressive_opening_steps_from_DAISOP_to_cushion_deceleration.
    .byte 0x10                       ;Point 1

	;.org	0x85e0
DCALTM_DacalInhibitTimeAfterStartup:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0FDF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DacalInhibitTimeAfterStartup
    ;mptblcname DCALTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DCALTM_defines_the_post-start_time_delay_that_must_elapse_before_the_engine_controller_is_permitted_to_begin_adaptive_idle_airflow_calibration._Immediately_following_engine_start,_combustion_dynamics,_cylinder_wall_temperature,_and_manifold_pressure_undergo_rapid_transient_changes_as_the_engine_stabilizes._DCALTM_prevents_premature_adaptive_idle_air_learning.
    .byte 0x15                       ;Point 1

	;.org	0x85e1
DCALRT_DacalUpdateRate01_03_07_0f_1f_3f_7f_ff:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0FEC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DacalUpdateRate01_03_07_0f_1f_3f_7f_ff
    ;mptblcname DCALRT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DCALRT_defines_the_loop_counter_bitmask_that_paces_the_execution_frequency_of_the_DACAL_adaptive_idle_airflow_integrator._DCALRT_controls_the_integration_speed_of_the_adaptive_idle_airflow_trim._The_factory_setting_of_127_counts_(every_128th_loop)_provides_excellent_long-term_stability_and_should_be_retained_for_street_applications.
    .byte 0x7F                       ;Point 1


	;.org	0x85e2
DCLMIN_MinLimitOnDecelAisControlledMap:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x0FFA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinLimitOnDecelAisControlledMap
    ;mptblcname DCLMIN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DCLMIN_establishes_a_minimum_lower_clamp_on_the_calculated_deceleration_control_manifold_absolute_pressure_value._During_closed-throttle_deceleration,_intake_manifold_vacuum_reaches_extreme_levels._DCLMIN_ensures_that_the_deceleration_dashpot_calculation_always_maintains_positive_opening_authority_under_deep_overrun_vacuum.
    .byte 0x04                       ;Point 1

	;.org	0x85e3
DCLMN2_NoAisControlIfMapAndControlMapBelowThis:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1007
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname NoAisControlIfMapAndControlMapBelowThis
    ;mptblcname DCLMN2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc DCLMN2_defines_the_master_safety_manifold_absolute_pressure_lockout_threshold_below_which_all_deceleration_idle_stepper_motor_control_and_air_conditioning_kick_routines_are_inhibited._DCLMN2_functions_as_a_critical_stability_lockout_during_severe_engine_overrun._In_almost_all_performance_applications,_DCLMN2_should_remain_at_its_factory_calibration_of_13_counts_(~1.5_psi_absolute).
    ;mpmapaxis y
    .byte 0x14                       ;Point 1

	;.org	 0x85e4
DLYTIM_AisDelayAfterThrottleClosesWhenMoving:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1015
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisDelayAfterThrottleClosesWhenMoving
    ;mptblcname DLYTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc DLYTIM_defines_the_time_delay_that_the_engine_controller_holds_the_idle_air_stepper_motor_in_its_open_dashpot_position_after_the_throttle_snaps_shut_while_the_vehicle_is_moving._DLYTIM_governs_deceleration_manners_and_shift_smoothness_while_driving.
    .byte 0x5A                       ;Point 1

	;.org	 0x85e5
DLYTM2_AisDelayAfterThrottleClosesWhenStopped:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1022
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisDelayAfterThrottleClosesWhenStopped
    ;mptblcname DLYTIM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc DLYTIM2_defines_the_time_delay_that_the_engine_controller_holds_the_idle_air_stepper_motor_in_open_dashpot_position_after_the_throttle_snaps_shut_while_the_vehicle_is_stopped_or_moving_at_low_speed_with_engine_RPM_below_DLYRPM._DLYTIM2_is_a_primary_parameter_for_curing_stationary_throttle-blip_stalls_and_stoplight_die-out.
    .byte 0x5A                       ;Point 1

	;.org	0x85e6
DLYTM3_AisDelayAfterThrottleClosesWhenRpmAbove_DLYRPM:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x102F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisDelayAfterThrottleClosesWhenRpmAbove_DLYRPM
    ;mptblcname DLYTM3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc DLYTM3_defines_the_extended_time_delay_that_the_engine_controller_holds_the_idle_air_stepper_motor_in_open_dashpot_position_when_the_throttle_snaps_shut_at_a_standstill_with_engine_speed_above_DLYRPM._DLYTM3_governs_high-RPM_neutral_throttle_release_behavior._The_factory_setting_of_255_counts_(maximum_timer_saturation,_~16_seconds)_is_very_conservative,_ensuring_that_revving_in_neutral_will_never_result_in_an_undershoot_stall.
    .byte 0xFF                       ;Point 1

	;.org	0x85e7
DLYRPM_RpmTriggerForAisDelay:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x103C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RpmTriggerForAisDelay
    ;mptblcname DLYRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc DLYRPM_defines_the_engine_speed_threshold_that_switches_the_stationary_closed-throttle_dashpot_delay_between_the_standard_low-RPM_timer_DLYTIM2_and_the_extended_high-RPM_timer_DLYTM3._DLYRPM_establishes_the_split_point_between_short_and_long_stationary_deceleration_dashpot_delays._If_you_have_modified_DLYTM3_to_provide_a_shorter,_crisper_rev_return,_DLYRPM_dictates_when_that_behavior_begins.
    .byte 0x46                       ;Point 1

	;.org	0x85e8
MPHREF_SwitchPointForDecelIdleAisControl:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1049
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SwitchPointForDecelIdleAisControl
    ;mptblcname MPHREF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 127.5 mph
    ;mptbldesc MPHREF_defines_the_critical_vehicle_speed_threshold_that_separates_moving_or_rolling_deceleration_logic_from_stationary_closed-throttle_idle_control._When_a_vehicle_is_moving_down_the_road_at_highway_or_suburban_speeds,_letting_off_the_accelerator_pedal_requires_vehicle_deceleration_dashpot_airflow_to_cushion_engine_braking._MPHREF_controls_the_transition_between_rolling_decel_dashpot_mode_and_stationary_idle_control.
    .byte 0x07                       ;Point 1

	;.org	0x85e9
PNDLTN_DeltaRpmChangeToUse_DRPNK_or_PNDRK:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1056
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DeltaRpmChangeToUse_DRPNK_or_PNDRK_A
    ;mptblcname PNDLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc PNDLT_defines_the_engine_speed_error_deadband_threshold_required_before_the_controller_triggers_the_automatic_transmission_Park/Neutral_to_Drive_kick_opening_table._When_the_driver_shifts_an_automatic_transmission_from_Park_or_Neutral_into_Drive_or_Reverse,_the_transmission_hydraulic_clutches_engage_and_the_torque_converter_impeller_suddenly_loads_the_crankshaft._PNDLT_controls_how_quickly_the_ECU_intervenes_when_shifting_into_gear.
    .word 0x00C8                     ;Point 1

	;.org	0x85eb
PNDRK_ParkNeutralToDriveKicks_FromTemp:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1063
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ParkNeutralToDriveKicks_FromTemp
    ;mptblcname PNDRK
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc PNDRK_is_a_2D_calibration_curve_that_establishes_the_pre-emptive_opening_steps_added_to_the_idle_air_stepper_motor_when_shifting_an_automatic_transmission_from_Park_or_Neutral_into_Drive._When_the_transmission_shifts_into_gear,_the_hydraulic_torque_converter_immediately_places_a_heavy_mechanical_drag_on_the_crankshaft._PNDRK_is_the_primary_tuning_curve_for_eliminating_in-gear_shift_stumble_on_automatic_Chrysler_vehicles.
    .byte 0x07                       ;Number of points in table
    .byte 0x2B, 0x2F, 0x49, 0x2B     ;Point 1
    .byte 0x50, 0x03, 0xFD, 0x04     ;Point 2
    .byte 0xFC, 0x01, 0xFF, 0x04     ;Point 3
    .byte 0xFC, 0x03, 0xFD, 0x03     ;Point 4
    .byte 0xFD, 0x03, 0xFD, 0x03     ;Point 5
    .byte 0xFD, 0x03, 0xFD, 0x02     ;Point 6
    .byte 0xFE, 0x06                 ;Point 7

	;.org	0x85fa
PNDLTP_DeltaRpmChangeToUse_DRPNK_or_PNDRK:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1077
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DeltaRpmChangeToUse_DRPNK_or_PNDRK_B
    ;mptblcname PNDLTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc PNDLTP_defines_the_engine_speed_error_threshold_required_before_the_controller_triggers_the_automatic_transmission_Drive_to_Park/Neutral_step_reduction_table._When_the_driver_shifts_an_automatic_transmission_out_of_Drive_or_Reverse_into_Park_or_Neutral,_the_hydraulic_load_of_the_torque_converter_is_suddenly_released_from_the_crankshaft._PNDLTP_controls_how_sensitive_the_ECU_is_to_shifting_out_of_gear.
    .word 0x01FF                     ;Point 1

	;.org	0x85fc
DRPNK_DriveToParkNeutralKicks_FromTemp:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1084
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DriveToParkNeutralKicks_FromTemp
    ;mptblcname DRPNK
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc DRPNK_is_a_2D_calibration_curve_that_establishes_the_closing_step_reduction_applied_to_the_idle_air_stepper_motor_when_shifting_an_automatic_transmission_from_Drive_into_Park_or_Neutral._While_in_gear,_the_idle_air_motor_is_held_open_further_to_overcome_the_hydraulic_viscous_drag_of_the_torque_converter._DRPNK_is_the_primary_tuning_curve_for_eliminating_neutral_flare_upon_gear_selector_release.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0x860b
ACCTBL_ACOffIdleDelta_FromSpeed:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1092
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ACOffIdleDelta_FromSpeed
    ;mptblcname ACCTBL
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc ACCTBL_is_a_2D_calibration_curve_that_establishes_the_off-idle_stepper_motor_opening_offset_as_a_function_of_vehicle_road_speed_whenever_the_air_conditioning_compressor_is_operating._At_highway_cruising_speeds,_high_condenser_ram_airflow_and_elevated_compressor_displacement_impose_substantial_mechanical_drag_when_the_driver_lifts_off_the_throttle._ACCTBL_controls_highway_deceleration_manners_with_the_air_conditioning_running.
    .byte 0x04                       ;Number of points in table
    .byte 0x1E, 0x25, 0x00, 0x9A     ;Point 1
    .byte 0x28, 0x2B, 0xFF, 0xF1     ;Point 2
    .byte 0x6E, 0x27, 0xFF, 0xC0     ;Point 3
    .byte 0x82, 0x22                 ;Point 4

	;.org	0x861e
ACTMP_Use_ACCTBL_WhenTempAboveThisElseUse_ACPOS:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10A3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Use_ACCTBL_WhenTempAboveThisElseUse_ACPOS
    ;mptblcname ACTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACTMP_defines_the_engine_coolant_temperature_switch_point_separating_cold_fixed_A/C_compensation_from_warm_speed-dependent_A/C_airflow_compensation._ACTMP_establishes_the_boundary_between_cold_and_warm_air_conditioning_idle_compensation._The_factory_setting_of_77_°F_works_well_across_broad_climates.
    .byte 0x7F                       ;Point 1

	;.org	0x861f
AISMPH_RollingAisMaxSpeed:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10B0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisMaxSpeed
    ;mptblcname AISMPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AISMPH_defines_the_maximum_vehicle_speed_ceiling_for_active_rolling_idle_mode_on_manual_transmission_Chrysler_vehicles._When_coasting_in_neutral_with_the_clutch_disengaged,_maintaining_a_slightly_elevated_rolling_idle_speed_prevents_the_engine_from_stalling,_provides_vacuum_assist_for_power_brakes,_and_facilitates_smooth_rev-matching_when_shifting_back_into_gear._AISMPH_controls_rolling_idle_availability_on_manual_transmission_vehicles.
    .byte 0x10                       ;Point 1

	;.org	0x8620
RPMDLT_RollingAisMinRpm:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10BD
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname RollingAisMinRpm
    ;mptblcname RPMDLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc RPMDLT_defines_the_engine_speed_tolerance_adder_above_target_idle_speed_that_permits_entry_into_rolling_idle_mode_on_manual_transmission_vehicles._While_coasting_in_neutral_below_the_speed_threshold_set_in_AISMPH,_the_engine_controller_must_decide_whether_engine_speed_is_close_enough_to_target_idle_to_engage_closed-loop_rolling_idle_regulation._RPMDLT_sets_the_catch_window_for_rolling_idle_engagement.
    .word 0x07D0                     ;Point 1

	;.org	0x8622
ISPDCY_RollingAisDecay:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10CA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisDecay
    ;mptblcname ISPDCY
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ISPDCY_defines_the_RPM_decrement_step_size_subtracted_from_target_idle_speed_during_rolling_idle_decay._ISPDCY_controls_how_rapidly_elevated_rolling_idle_speed_steps_down_to_base_idle._If_your_vehicle_stays_at_a_high_rolling_idle_for_an_annoying_length_of_time_after_coming_off_the_highway,_increasing_ISPDCY_to_6_or_8_counts_(48_to_64_RPM_per_step)_will_ramp_the_idle_target_down_more_quickly.
    .byte 0x04                       ;Point 1

	;.org	0x8623
DECAIS_RollingAisUpdateRate_01_03_07_0f_1f_3f_7f_ff:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10D7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisUpdateRate_01_03_07_0f_1f_3f_7f_ff
    ;mptblcname DECAIS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DECAIS_defines_the_loop_counter_bitmask_that_paces_how_frequently_the_target_idle_speed_decay_step_ISPDCY_is_applied_during_rolling_idle_mode._DECAIS_controls_the_time_duration_of_rolling_idle_speed_decay._The_factory_setting_of_127_counts_(~1.4_seconds_per_step)_provides_a_very_gradual_decay._Combined_with_an_ISPDCY_of_32_RPM,_the_target_drops_roughly_23_RPM_per_second.
    .byte 0x7F                       ;Point 1

	;.org	0x8624
AISLMH_RollingAisHighLimit:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10E4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisHighLimit
    ;mptblcname AISLMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AISLMH_defines_the_upper_step_limit_offset_added_to_baseline_idle_position_to_clamp_the_maximum_opening_of_the_idle_stepper_motor_during_rolling_idle_mode._While_operating_in_rolling_idle_mode,_closed-loop_feedback_dynamically_adjusts_stepper_motor_position_to_match_target_rolling_idle_speed._AISLMH_bounds_the_dynamic_opening_range_of_the_idle_stepper_motor_while_rolling.
    .byte 0x20                       ;Point 1

	;.org	0x8625
AISLML_RollingAisLowLimit:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10F1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RollingAisLowLimit
    ;mptblcname AISLML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AISLML_defines_the_lower_step_limit_offset_subtracted_from_baseline_idle_position_to_clamp_the_minimum_opening_of_the_idle_stepper_motor_during_rolling_idle_mode._While_the_vehicle_is_rolling_in_neutral_with_closed_throttle,_the_engine_relies_on_auxiliary_bypass_airflow_to_avoid_sudden_stalling_when_the_brakes_are_applied_or_when_clutching_back_into_gear._AISLML_protects_against_rolling_idle_undershoot_stalls.
    .byte 0x04                       ;Point 1

	;.org	0x8626
ACDTMP_PartThrottleAcCutoutDisableTemp:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x10FE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PartThrottleAcCutoutDisableTemp
    ;mptblcname ACDTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACDTMP_defines_the_engine_coolant_temperature_threshold_above_which_the_controller_is_permitted_to_engage_part-throttle_air_conditioning_compressor_cutout._ACDTMP_can_be_re-enabled_to_protect_modified_turbo_engines_from_overheating_during_aggressive_driving_in_hot_summer_weather.
    .byte 0xFF                       ;Point 1

	;.org	0x8627
ACDTHR_PartThrottleAcCutoutDisableThrottle:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x110B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PartThrottleAcCutoutDisableThrottle
    ;mptblcname ACDTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACDTHR_defines_the_throttle_position_sensor_voltage_delta_threshold_required_to_activate_part-throttle_air_conditioning_compressor_cutout._ACDTHR_can_be_tuned_to_provide_a_noticeable_acceleration_boost_during_brisk_part-throttle_driving._If_you_want_the_air_conditioning_compressor_to_automatically_disengage_when_you_press_the_accelerator_pedal_past_roughly_half-throttle,_lower_ACDTHR_to_2.0_to_2.5_Volts_(100_to_128_counts)_and_enable_ACDTMP.
    .byte 0xFF                       ;Point 1

	;.org	0x8628
ACDSPD_PartThrottleAcCutoutDisableSpeed:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1118
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname PartThrottleAcCutoutDisableSpeed
    ;mptblcname ACDSPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACDSPD_defines_the_maximum_vehicle_speed_ceiling_below_which_part-throttle_air_conditioning_compressor_cutout_is_permitted_to_engage._ACDSPD_bounds_the_operational_speed_range_for_part-throttle_A/C_cutout._If_you_have_lowered_ACDTMP_and_ACDTHR_to_enable_part-throttle_cutout,_set_ACDSPD_to_35_to_45_mph_(2240_to_2880_counts_in_the_16-bit_word_format).
    .word 0x0000                     ;Point 1

	;.org	0x862a
ACETIM_PartThrottleAcCutoutMaxTimeActive:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1125
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PartThrottleAcCutoutMaxTimeActive
    ;mptblcname ACETIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACETIM_defines_the_maximum_duration_that_part-throttle_air_conditioning_compressor_cutout_is_permitted_to_remain_continuously_active._ACETIM_sets_the_maximum_duration_of_the_part-throttle_acceleration_boost_window._If_you_have_enabled_part-throttle_cutout_and_want_a_longer,_more_sustained_power_boost_while_passing_traffic_or_accelerating_down_an_on-ramp,_increase_ACETIM_to_5_to_10_seconds_(80_to_160_counts).
    .byte 0x08                       ;Point 1

	;.org	0x862b
ACERPM_AllowAcClutchAboveThisRpm:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1132
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AllowAcClutchAboveThisRpm
    ;mptblcname ACERPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACERPM_defines_the_engine_speed_threshold_above_which_part-throttle_air_conditioning_compressor_cutout_is_terminated,_allowing_the_compressor_clutch_to_re-engage._ACERPM_establishes_the_upper_RPM_boundary_for_part-throttle_A/C_cutout._If_you_want_part-throttle_compressor_cutout_to_stay_active_higher_into_the_rev_band_during_spirited_driving,_raise_ACERPM_to_3000_to_3500_RPM_(94_to_109_counts).
    .byte 0x44                       ;Point 1

	;.org	0x862c
ACESPD_AllowAcClutchAboveThisSpeed:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x113F
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname AllowAcClutchAboveThisSpeed
    ;mptblcname ACESPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACESPD_defines_the_vehicle_speed_threshold_above_which_part-throttle_air_conditioning_compressor_cutout_is_terminated,_allowing_the_compressor_to_re-engage._When_accelerating_from_a_standstill_with_part-throttle_cutout_active,_the_vehicle_quickly_accelerates_up_to_normal_traffic_speeds._ACESPD_sets_the_road_speed_ceiling_for_terminating_low-speed_part-throttle_A/C_cutout.
    .word 0x0500                     ;Point 1

	;.org	0x862e
ACAETH_DisallowAcClutchEngageForThisTimeAfterAccelEnrich:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x114C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DisallowAcClutchEngageForThisTimeAfterAccelEnrich
    ;mptblcname ACAETH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACAETH_defines_the_lockout_delay_timer_that_prevents_the_air_conditioning_compressor_clutch_from_engaging_immediately_following_an_acceleration_enrichment_transient._When_the_driver_steps_into_the_throttle_to_accelerate,_the_fuel_injection_system_delivers_acceleration_enrichment_to_prevent_a_lean_tip-in_stumble._ACAETH_eliminates_tip-in_acceleration_stumbles_caused_by_A/C_clutch_cycling.
    .byte 0xD6                       ;Point 1

	;.org	0x862f
ACOFFK_ClosedThrottleAcOffKick:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1159
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ClosedThrottleAcOffKick
    ;mptblcname ACOFFK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACOFFK_defines_the_closed-throttle_stepper_motor_kick_step_reduction_applied_when_the_air_conditioning_compressor_clutch_disengages._While_the_air_conditioning_compressor_is_pumping,_auxiliary_bypass_airflow_is_injected_to_prevent_the_engine_from_stalling_under_compressor_load._ACOFFK_eliminates_idle_flaring_when_the_air_conditioning_compressor_cycles_off_at_a_stoplight.
    .byte 0xEE                       ;Point 1

	;.org	0x8630
AC2KCK_AcClutchKickOpenAfterAcEnabled:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1166
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcClutchKickOpenAfterAcEnabled
    ;mptblcname AC2KCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AC2KCK_defines_the_pre-emptive_opening_step_kick_added_to_the_idle_air_stepper_motor_when_the_air_conditioning_compressor_clutch_is_commanded_to_engage._When_the_air_conditioning_system_calls_for_cooling,_the_magnetic_compressor_clutch_locks_up,_suddenly_imposing_heavy_mechanical_pumping_drag_on_the_engine._AC2KCK_is_the_primary_parameter_for_eliminating_engine_RPM_dips_when_the_air_conditioning_compressor_turns_on_at_idle.
    .byte 0x00                       ;Point 1

	;.org	0x8631
ACTIME_TimeBeforeAcEnabledAndFullDeltaUsed:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1173
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBeforeAcEnabledAndFullDeltaUsed
    ;mptblcname ACTIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACTIME_defines_the_transition_delay_timer_that_paces_the_blending_of_air_conditioning_idle_airflow_compensation_during_clutch_engagement._ACTIME_governs_the_timing_of_A/C_airflow_blending._If_turning_on_the_air_conditioning_causes_the_engine_to_flare_slightly_before_compressor_load_pulls_it_back_down,_increasing_ACTIME_to_3.0_seconds_(48_counts)_lengthens_the_blend_ramp,_creating_a_smoother_transition.
    .byte 0x17                       ;Point 1

	;.org	0x8632
PERKCK_AcClutchAisAdjustmentConstant:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x1180
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcClutchAisAdjustmentConstant
    ;mptblcname PERKCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc PERKCK_defines_the_scaling_percentage_multiplier_applied_to_the_off-idle_air_conditioning_airflow_adder_ACCTBL._PERKCK_provides_a_simple_master_scalar_to_increase_or_decrease_off-idle_air_conditioning_airflow_across_all_vehicle_speeds_without_modifying_the_individual_points_in_ACCTBL.
    .byte 0xFF                       ;Point 1

	;.org	0x8633
AC4KCK_AcClutchKickOpenBeforeAcEnabled2:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x118D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcClutchKickOpenBeforeAcEnabled2
    ;mptblcname AC4KCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AC4KCK_defines_the_secondary_stepper_motor_opening_kick_offset_applied_before_air_conditioning_clutch_engagement_under_elevated_intake_manifold_pressure_conditions._AC4KCK_fine-tunes_A/C_clutch_engagement_behavior_under_elevated_manifold_pressure._In_standard_street_applications,_this_parameter_rarely_requires_modification.
    .byte 0xFA                       ;Point 1

	;.org	0x8634
AC3KCK_AcClutchKickOpenAfterAcEnabled2:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x119A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcClutchKickOpenAfterAcEnabled2
    ;mptblcname AC3KCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AC3KCK_defines_the_secondary_stepper_motor_opening_kick_offset_applied_after_air_conditioning_clutch_engagement_under_elevated_intake_manifold_pressure_conditions._AC3KCK_fine-tunes_post-engagement_A/C_idle_stability._If_the_engine_flares_or_surges_immediately_after_the_compressor_clutch_locks_up_while_idling_under_load,_increasing_the_negative_trim_in_AC3KCK_(for_example,_setting_to_252_counts_/_-4_steps)_will_pull_back_excess_bypass_airflow.
    .byte 0xFE                       ;Point 1

	;.org	0x8635
ACTIM2_TimeBeforeAcEnabledAndFullDeltaUsed2:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x11A7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBeforeAcEnabledAndFullDeltaUsed2
    ;mptblcname ACTIM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACTIM2_defines_the_secondary_transition_delay_timer_utilized_during_alternate_air_conditioning_clutch_engagement_paths._ACTIM2_controls_transition_pacing_in_the_secondary_A/C_engagement_branch._It_functions_identically_to_ACTIME_and_should_mirror_ACTIME's_value_in_almost_all_calibrations.
    .byte 0x24                       ;Point 1

	;.org	0x8636
OFFPER_AisInstantlyClosesWhenAcDisengages:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x11B4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisInstantlyClosesWhenAcDisengages
    ;mptblcname OFFPER
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OFFPER_defines_the_percentage_proportion_of_the_off-idle_air_conditioning_airflow_adder_ACCTBL_that_is_instantly_retracted_when_the_compressor_clutch_disengages._While_driving_off-idle_with_the_air_conditioner_on,_ACCTBL_injects_auxiliary_bypass_airflow_to_counteract_compressor_drag_during_coast-down._OFFPER_controls_deceleration_feel_when_the_air_conditioning_compressor_turns_off_while_coasting_down_from_speed.
    .byte 0xFF                       ;Point 1

	;.org	0x8637
OFFPER2_AisInstantlyClosesWhenAcDisengages2:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x11C1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisInstantlyClosesWhenAcDisengages2
    ;mptblcname OFFPER2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OFFPER2_defines_the_secondary_percentage_proportion_of_the_off-idle_air_conditioning_airflow_adder_ACCTBL_that_is_retracted_during_alternate_clutch_disengagement_transitions._When_the_air_conditioning_system_cycles_off_in_the_secondary_branch,_a_different_residual_airflow_cushion_may_be_required_than_in_the_primary_branch._OFFPER2_controls_the_gentler_secondary_A/C_disengagement_air_retraction.
    .byte 0x40                       ;Point 1

	;.org	0x8638
BTVAIS_MinVoltageForAis:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x11CE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinVoltageForAis
    ;mptblcname BTVAIS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc BTVAIS_defines_the_minimum_electrical_system_battery_voltage_required_before_the_controller_allows_actuation_of_the_automatic_idle_speed_stepper_motor._The_4-wire_stepper_motor_actuator_relies_on_electromagnetic_coils_to_overcome_internal_friction,_spring_pressure,_and_intake_manifold_vacuum_force_to_move_the_pintle._BTVAIS_protects_the_idle_air_stepper_motor_from_losing_calibration_during_severe_electrical_system_load_transients.
    .byte 0x71                       ;Point 1

	;.org	0x8639
AISFRQ_AisPeriodForRpmFeedback11ms:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x11DB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisPeriodForRpmFeedback11ms
    ;mptblcname AISFRQ
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AISFRQ_defines_the_closed-loop_feedback_update_period_that_governs_how_frequently_the_automatic_idle_speed_stepper_motor_can_make_corrective_position_changes_based_on_RPM_error._AISFRQ_is_a_primary_tool_for_eliminating_persistent_idle_hunting_and_surging.
    .byte 0x7F                       ;Point 1

	;.org	0x863a
AISHLM_AisHighLimitMaxOpenSteps:
    ;mpgrp 5_-_Idle\B_-_AIS_Decel\
    ;mptbladdr 0x11E8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisHighLimitMaxOpenSteps
    ;mptblcname AISHLM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AISHLM_establishes_the_absolute_high_limit_clamp_for_the_maximum_number_of_open_steps_that_can_ever_be_commanded_on_the_automatic_idle_speed_stepper_motor._AISHLM_should_generally_remain_at_160_steps_for_factory_and_stock-style_throttle_bodies._Raising_AISHLM_above_160_steps_does_not_provide_additional_airflow_on_stock_Chrysler_throttle_bodies_because_the_bypass_port_reaches_complete_aerodynamic_saturation_at_approximately_150_to_160_steps.
    .byte 0xA0                       ;Point 1

	;.org	0x863b
AISFAN_AisKickWhenFanTurnsOnClosedThrottle:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x11F5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisKickWhenFanTurnsOnClosedThrottle
    ;mptblcname AISFAN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AISFAN_defines_the_number_of_proactive_stepper_motor_steps_added_to_the_target_idle_air_position_whenever_the_radiator_cooling_fan_is_commanded_on_while_the_throttle_is_closed._Raising_AISFAN_provides_greater_airflow_anticipation_for_heavy-duty_aftermarket_cooling_fans_or_high-output_alternators_that_induce_a_noticeable_idle_RPM_dip_when_the_cooling_fan_engages.
    .byte 0x08                       ;Point 1




; this is not changed from 2.2 to 2.5. Both version of this software use the same boost control scheme. So,
; if you change from 2.5 to 2.2, you will still need to use the T1 style boost control and vac routing.

BSTSWS_HighBoostSwitchSelect:  ;0x8a25 is where this ends up...
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x1207
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname HighBoostSwitchSelect
    ;mptblcname BSTSWS
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc BSTSWS_defines_the_hardware_input_pin_bitmask_used_to_toggle_Turbonator_Switchable_Boost_(High/Low_Boost):_0x01=Cruise_Set_(B9),_0x02=Cruise_Resume_(B10,_default),_0x04=A/C_Sense_(B11),_0x08=Park/Neutral_(B12),_0x10=Brake_Switch_(B13),_0x40=Cruise_Enable_(B15)._Wire_a_toggle_switch_between_the_chosen_pin_and_ground_or_12V_to_enable_dual-stage_boost_control.
    ;mpchoices B1Voltage_Sense(Do_Not_Use)  Speed_Control_Set_(Momentary)  Speed_Control_On/Off  Speed_Control_Resume_(Momentary)  A/C_Switch  A/C_Clutch_Input(Do_Not_Use)  Brake_Switch  Park/Neutral_Switch
    .byte 0x02                       ;Point 1
    bst_PNswitch		= $%10000000	; Park/Neutral switch
    bst_Brake			= $%01000000	; Brake Switch
    bst_DistSync		= $%00100000	; Distributor Sync
    bst_ACclutch		= $%00010000	; A/C Clutch input
    bst_CruiseResume		= $%00001000	; Cruise Resume
    bst_CruiseOnOff		= $%00000100	; Cruise On/Off
    bst_CruiseSet		= $%00000010	; Cruise Set
    bst_B1Volt			= $%00000001	; B1 Voltage Sense

	;.org	0x863c
WSGRPM_AllowedBoost_FromRpm:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x121D
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromRpm
    ;mptblcname WSGRPM
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc WSGRPM_defines_the_primary_wide-open_throttle_turbocharger_boost_target_curve_as_a_function_of_engine_speed._Raising_this_table_increases_maximum_engine_boost_and_torque_output_across_the_entire_RPM_curve._When_tuning_modified_engines_with_upgraded_intercoolers_and_high-octane_fuel,_tuners_typically_elevate_this_curve_to_14_to_18_psi_on_2-bar_sensors,_or_up_to_25_to_30_psi_on_3-bar_MAP_sensors.
    ;mpmapaxis y
    .byte 0x04                       ;Number of points in table
    .byte 0x4B, 0x5D, 0x00, 0x5A     ;Point 1
    .byte 0x70, 0x6A, 0x00, 0x00     ;Point 2
    .byte 0xC8, 0x6A, 0xFA, 0x2B     ;Point 3
    .byte 0xCE, 0x47                 ;Point 4

	;.org	0x864f
LOWBST_AllowedBoostLo:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x122F
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AllowedBoostLo
    ;mptblcname LOWBST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc LOWBST_sets_the_fixed_turbocharger_gauge_boost_target_ceiling_enforced_when_switchable_dual-boost_control_is_enabled_and_the_external_boost_switch_is_toggled_to_the_low-boost_position._Raising_LOWBST_increases_the_power_output_of_the_low-boost_mode,_while_lowering_it_creates_a_milder_or_more_conservative_setting.
    ;mpmapaxis y
    .byte 0x57                       ;Point 1

STGBST_AllowedBoostDuringStaging:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x123C
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AllowedBoostDuringStaging
    ;mptblcname STGBST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc STGBST_defines_the_maximum_allowable_turbocharger_boost_pressure_permitted_while_launch_control_staging_mode_is_actively_engaged._Raising_STGBST_builds_higher_boost_and_exhaust_energy_while_holding_the_vehicle_on_the_starting_line,_which_provides_a_harder,_more_aggressive_launch_when_traction_conditions_permit,_such_as_on_sticky_drag_strip_tires.
    ;mpmapaxis y
    .byte 0x29                       ;Point 1

	;.org	0x8662
WSGTIM_AllowedBoost_FromTime:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x124A
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromTime
    ;mptblcname WSGTIM
    ;mpxaxis Time 0 0.72 Sec
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc WSGTIM_governs_the_rate_at_which_turbocharger_boost_is_permitted_to_ramp_upward_over_time_once_wide-open_throttle_is_applied._Flattening_or_steepening_this_curve_directly_adjusts_turbocharger_spool_response_and_transient_boost_ramp-in._Tuners_seeking_maximum_drag_racing_spool_rate_can_raise_the_initial_time_points_to_match_the_target_boost_curve_in_WSGRPM,_allowing_the_wastegate_to_stay_clamped_shut_for_immediate_full_boost.
    ;mpmapaxis y
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x6A                 ;Point 1

	;.org	0x866d
WSGCLT_AllowedBoost_FromTemp:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x1259
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromTemp
    ;mptblcname WSGCLT
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc WSGCLT_establishes_the_maximum_allowable_turbocharger_boost_pressure_as_a_function_of_engine_coolant_temperature._Raising_the_cold_temperature_entries_allows_the_turbocharger_to_build_higher_boost_before_the_engine_reaches_full_thermostat_operating_temperature,_but_doing_so_increases_the_likelihood_of_mechanical_stress_or_premature_head_gasket_fatigue_on_cold_cylinder_walls.
    ;mpmapaxis y
    .byte 0x04                       ;Number of points in table
    .byte 0x9B, 0x30, 0x01, 0x7D     ;Point 1
    .byte 0xC2, 0x6A, 0x00, 0x00     ;Point 2
    .byte 0xEE, 0x6A, 0xF6, 0x55     ;Point 3
    .byte 0xF4, 0x30                 ;Point 4

	;.org	0x8680
WSGCHG_AllowedBoost_FromChargeTemp:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x126B
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromChargeTemp
    ;mptblcname WSGCHG
    ;mpxaxis charge_temp_volts 0 5 volts
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc WSGCHG_regulates_maximum_allowable_turbocharger_boost_pressure_according_to_intake_manifold_charge_air_temperature._For_vehicles_equipped_with_highly_efficient_aftermarket_front-mount_intercoolers,_this_table_can_be_raised_across_typical_operating_temperature_ranges_to_sustain_full_boost_during_back-to-back_pulls.
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x0A, 0x42, 0x05, 0xB7     ;Point 1
    .byte 0x11, 0x6A                 ;Point 2

	;.org	0x868f
MXSBST_AllowedBoost_FromSpeed:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x127B
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromSpeed
    ;mptblcname MXSBST
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc MXSBST_defines_the_upper_boundary_for_allowable_turbocharger_boost_pressure_as_a_function_of_road_vehicle_speed._Because_turbocharged_front-wheel-drive_vehicles_easily_break_traction_and_induce_severe_wheel_spin_or_torque_steer_in_first_and_second_gears,_Chrysler_engineers_incorporated_speed-dependent_boost_limits_into_the_controller._Functions_as_a_simple_and_effective_boost-by-speed_traction_management_tool.
    ;mpmapaxis y
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x6A                 ;Point 1

	;.org	0x86a2
WSGPRT_AllowedBoostPartThrottle_FromThrottle:
    ;mpgrp 3_-_Boost_Control\A_-_Target_Lookup\
    ;mptbladdr 0x128A
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoostPartThrottle_FromThrottle
    ;mptblcname WSGPRT
    ;mpxaxis TPS 0 5 volts
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc WSGPRT_controls_the_maximum_allowable_turbocharger_boost_target_under_part-throttle_operating_conditions_based_on_throttle_position_sensor_voltage._Smoothing_and_reshaping_this_curve_directly_refines_part-throttle_driveability_and_highway_cruising_manners.
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x93, 0x3F, 0x01, 0x22     ;Point 1
    .byte 0xB9, 0x6A                 ;Point 2




	;.org	0x86b1
DCWOT_FullThrottleWastegateDutyCycle_C8is100Percent_FromMap:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Lookup\
    ;mptbladdr 0x129D
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FullThrottleWastegateDutyCycle_C8is100Percent_FromMap
    ;mptblcname DCWOT
    ;mpxaxis TargetBoost 0 29.4 psi
    ;mpyaxis Duty_Cycle 0 127.5 percent
    ;mptbldesc DCWOT_provides_the_open-loop_base_wastegate_solenoid_duty_cycle_curve_as_a_function_of_target_boost_pressure_for_T1_wastegate_control._Adjusting_DCWOT_establishes_the_feed-forward_baseline_for_boost_control._If_the_engine_consistently_overshoots_target_boost_upon_initial_spool-up,_lowering_DCWOT_in_the_corresponding_boost_region_bleeds_less_pressure,_allowing_the_wastegate_to_open_earlier_and_suppress_the_boost_spike.
    ;mpmapaxis x
    .byte 0x05                       ;Number of points in table
    .byte 0x42, 0x43, 0x01, 0x00     ;Point 1
    .byte 0x46, 0x47, 0x02, 0x66     ;Point 2
    .byte 0x50, 0x5F, 0x00, 0xD1     ;Point 3
    .byte 0x5B, 0x68, 0x01, 0x00     ;Point 4
    .byte 0x61, 0x6E                 ;Point 5

	;.org	0x86cc
DCWADJ_FullThrottleWastegateDutyCycleAdjustment_FromRpm:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Lookup\
    ;mptbladdr 0x12B0
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname FullThrottleWastegateDutyCycleAdjustment_FromRpm
    ;mptblcname DCWADJ
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis DC_Adjust -64 63.5 percent
    ;mptbldesc DCWADJ_supplies_an_engine-speed-dependent_signed_duty_cycle_adjustment_to_the_base_wastegate_duty_cycle_in_T1_control._Modifying_DCWADJ_corrects_for_RPM-related_boost_sag_or_boost_creep.
    .byte 0x07                       ;Number of points in table
    .byte 0x3E, 0x40, 0xFC, 0x00     ;Point 1
    .byte 0x4E, 0x00, 0x00, 0x00     ;Point 2
    .byte 0x6D, 0x00, 0x00, 0x4A     ;Point 3
    .byte 0x8C, 0x09, 0x00, 0xE0     ;Point 4
    .byte 0x9C, 0x17, 0x00, 0x84     ;Point 5
    .byte 0xBB, 0x27, 0x00, 0x50     ;Point 6
    .byte 0xCB, 0x2C                 ;Point 7

DCWBST_FullThrottleWastegateDutyCycleAdjustment_FromBoostTarget:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Lookup\
    ;mptbladdr 0x12C3
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FullThrottleWastegateDutyCycleAdjustment_FromBoostTarget
    ;mptblcname DCWBST
    ;mpxaxis DeltaMAP 0 29.4 psi
    ;mpyaxis DC_Adjust 0 127.5 percent
    ;mptbldesc DCWBST_provides_a_proportional_duty_cycle_boost_offset_based_on_the_error_delta_between_target_boost_and_actual_manifold_pressure_in_T1_control._Essential_for_shaping_turbocharger_transient_response_and_spool-up_aggressiveness._Increasing_duty_cycle_values_at_large_boost_error_deltas_(such_as_5_to_15_psi_below_target)_forces_the_wastegate_shut_for_explosive_spool-up.
    ;mpmapaxis x
    .byte 0x06                       ;Number of points in table
    .byte 0x2C, 0x00, 0x08, 0x92     ;Point 1
    .byte 0x3A, 0x78, 0x01, 0xB9     ;Point 2
    .byte 0x57, 0xAA, 0x01, 0x08     ;Point 3
    .byte 0x74, 0xC8, 0x00, 0x00     ;Point 4
    .byte 0x84, 0xC8, 0x00, 0x00     ;Point 5
    .byte 0x94, 0xC8                 ;Point 6

	;.org	0x86df
MAPPT2_WastegateDutyCycleMapSwitchPoint2:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x12D7
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname WastegateDutyCycleMapSwitchPoint2
    ;mptblcname MAPPT2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc MAPPT2_establishes_the_minimum_manifold_gauge_pressure_threshold_that_must_be_reached_before_the_engine_controller_activates_electronic_wastegate_duty_cycle_calculations._Raising_MAPPT2_delays_wastegate_solenoid_activation_until_higher_manifold_pressure_is_reached,_which_keeps_the_solenoid_quiet_and_dormant_during_normal_vacuum_and_light_boost_transitions.
    ;mpmapaxis y
    .byte 0x00                       ;Point 1

	;.org	0x86e0
RPMBST_MinimumRpmToTrackBoostCreep:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Lookup\
    ;mptbladdr 0x12E5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumRpmToTrackBoostCreep
    ;mptblcname RPMBST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc RPMBST_defines_the_minimum_engine_speed_threshold_required_to_advance_the_boost_ramp_countdown_timer_(Timer_BoostTimer)_in_T1_wastegate_control._Setting_RPMBST_properly_ensures_that_boost_ramping_occurs_only_when_the_engine_is_operating_in_an_RPM_band_capable_of_spooling_the_turbocharger.
    .byte 0x4C                       ;Point 1

	;.org	0x86e1
KDCINC_WastegateDutyCycleIncreaseStepWhenKnocking:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Knock_Adj\
    ;mptbladdr 0x12F2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseStepWhenKnocking
    ;mptblcname KDCINC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc KDCINC_establishes_the_incremental_duty_cycle_reduction_step_added_to_the_knock_reduction_penalty_each_time_detonation_is_detected_while_operating_under_boost_in_T1_control._Increasing_KDCINC_causes_the_engine_controller_to_pull_boost_down_more_aggressively_when_detonation_is_detected,_offering_an_additional_safety_margin_on_pump_gasoline_or_during_hot_weather_track_sessions.
    .byte 0x08                       ;Point 1

	;.org	0x86e2
KDCMAX_WastegateDutyCycleIncreaseMaxWhenKnocking:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Knock_Adj\
    ;mptbladdr 0x12FF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseMaxWhenKnocking
    ;mptblcname KDCMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc KDCMAX_defines_the_upper_ceiling_on_total_cumulative_wastegate_duty_cycle_reduction_that_can_be_commanded_by_the_knock_protection_system_in_T1_control._When_severe_or_persistent_detonation_occurs_under_boost,_repeated_knock_events_add_incremental_duty_cycle_reductions_to_the_knock_reduction_variable._Setting_KDCMAX_establishes_the_ultimate_depth_of_boost_reduction_available_to_save_an_engine_during_severe_knock_conditions.
    .byte 0x3C                       ;Point 1

	;.org	0x86e3
KDCMIN_WastegateDutyCycleIncreaseMinWhenKnocking:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Knock_Adj\
    ;mptbladdr 0x130C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseMinWhenKnocking
    ;mptblcname KDCMIN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc KDCMIN_specifies_the_minimum_baseline_wastegate_duty_cycle_reduction_applied_immediately_upon_the_initial_detection_of_knock_under_boost_in_T1_control._Elevating_KDCMIN_makes_the_boost_control_system_react_decisively_to_the_first_onset_of_knock,_dropping_boost_instantly_by_a_noticeable_margin_to_prevent_piston_crown_and_ring_land_damage_on_aggressive_timing_calibrations.
    .byte 0x10                       ;Point 1

	;.org	0x86e4
DECTIM_TimeScaleFor_DCDECK:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x1319
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeScaleFor_DCDECK
    ;mptblcname DECTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DECTIM_sets_the_timing_prescaler_bitmask_that_governs_how_frequently_the_knock_duty_cycle_recovery_decrement_(DCDECK)_is_executed_in_T1_control._Changing_DECTIM_alters_the_time_interval_between_successive_boost_recovery_steps._In_factory_calibrations,_DECTIM_is_set_to_1,_meaning_DCDECK_is_subtracted_every_second_main_loop_pass_(approximately_every_22_milliseconds).
    .byte 0x07                       ;Point 1

	;.org	0x86e5
DCDECK_WastegateDutyCycleDecrementWhenSparkStillDerated:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Knock_Adj\
    ;mptbladdr 0x1326
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleDecrementWhenSparkStillDerated
    ;mptblcname DCDECK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DCDECK_controls_the_rate_at_which_wastegate_duty_cycle_is_restored_after_a_knock_event_has_subsided_in_T1_control._Raising_DCDECK_accelerates_boost_recovery_after_knock_events,_allowing_the_engine_to_return_to_full_power_quickly_once_detonation_ends._However,_recovering_boost_too_quickly_can_cause_the_engine_to_cycle_in_and_out_of_knock,_especially_if_the_underlying_cause_was_high_intake_air_temperature_or_marginal_fuel_octane.
    .byte 0x02                       ;Point 1

	;.org	0x86e6
MPDEL1_IncCounterWhenDeltaMapBelowThis:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x1333
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname IncCounterWhenDeltaMapBelowThis
    ;mptblcname MPDEL1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc MPDEL1_defines_the_minimum_positive_boost_error_threshold_(overboost)_required_before_the_engine_controller_begins_timing_an_adaptive_duty_cycle_reduction_in_T1_control._Serves_as_the_overboost_sensitivity_gate_for_adaptive_wastegate_learning._In_factory_calibrations,_MPDEL1_is_calibrated_to_2_counts_(approximately_0.23_psi_of_overboost).
    ;mpmapaxis y
    .byte 0x02                       ;Point 1

	;.org	0x86e7
MPFLOR_StopAdaptiveWGWhenDeltaMapIsLessThanThis:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x1341
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname StopAdaptiveWhenDeltaMapIsLessThanThis
    ;mptblcname MPFLOR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc MPFLOR_establishes_a_manifold_pressure_rate-of-change_stability_gate_required_to_permit_adaptive_wastegate_duty_cycle_decrementing_in_T1_control._Acts_as_a_transient_noise_filter_for_downward_adaptive_learning._In_factory_calibrations,_MPFLOR_is_set_to_2_counts_(approximately_0.23_psi_delta_between_instantaneous_and_average_MAP).
    ;mpmapaxis y
    .byte 0x02                       ;Point 1

	;.org	0x86e8
DECPT_AdaptiveDecAfterThisTime:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x134F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveDecAfterThisTime
    ;mptblcname DECPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DECPT_specifies_the_dwell_time_threshold_that_a_sustained_overboost_condition_must_persist_before_the_controller_decrements_the_active_adaptive_wastegate_cell._Adjusting_DECPT_balances_adaptive_learning_speed_against_immunity_to_transient_boost_overshoot._Raising_DECPT_requires_overboost_to_persist_for_a_longer_time_before_duty_cycle_is_decremented,_which_prevents_the_controller_from_trimming_away_duty_cycle_during_brief_spool_spikes.
    .byte 0x10                       ;Point 1

	;.org	0x86e9
DECLIM_LowerLimitOnWastegateDutyCycleCorrection:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x135C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowerLimitOnWastegateDutyCycleCorrection
    ;mptblcname DECLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DECLIM_establishes_the_lower_clamp_boundary_for_adaptive_wastegate_cell_values,_preventing_the_adaptive_system_from_trimming_baseline_duty_cycle_below_a_safe_authority_limit._Defines_the_maximum_downward_correction_authority_of_the_adaptive_wastegate_system._In_factory_calibrations,_DECLIM_is_set_to_68_counts,_which_allows_a_maximum_negative_trim_of_60_counts_(approximately_30_percent_duty_cycle_reduction_below_base_table_values).
    .byte 0x44                       ;Point 1

	;.org	0x86ea
MPROOF_StopAdaptiveWGWhenMapIsThisCloseToBoostTarget:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x1369
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname StopAdaptiveWGWhenMapIsThisCloseToBoostTarget
    ;mptblcname MPROOF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc MPROOF_sets_the_underboost_deadband_threshold_below_target_boost_where_the_controller_permits_adaptive_duty_cycle_incrementing_in_T1_control._When_manifold_pressure_is_below_target,_the_engine_controller_calculates_the_underboost_delta._In_factory_calibrations,_MPROOF_is_set_to_0_counts,_meaning_adaptive_incrementing_is_permitted_whenever_actual_boost_is_any_amount_below_target_boost.
    ;mpmapaxis y
    .byte 0x00                       ;Point 1

	;.org	0x86eb
MPDEL2_IncCounterWhenDeltaMapBelowThis2:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x1377
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname IncCounterWhenDeltaMapBelowThis2
    ;mptblcname MPDEL2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc MPDEL2_defines_the_manifold_pressure_stability_threshold_required_to_permit_adaptive_wastegate_duty_cycle_incrementing_when_boost_is_below_target._Acts_as_the_transient_stability_filter_for_upward_adaptive_boost_learning._In_factory_calibrations,_MPDEL2_is_set_to_2_counts_(approximately_0.23_psi).
    ;mpmapaxis y
    .byte 0x02                       ;Point 1

	;.org	0x86ec
INCPT_AdaptiveIncAfterThisTime:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x1385
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveIncAfterThisTime
    ;mptblcname INCPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc INCPT_specifies_the_dwell_time_threshold_that_an_underboost_condition_must_continuously_persist_before_the_controller_increments_the_active_adaptive_wastegate_cell_in_T1_control._Adjusting_INCPT_controls_how_quickly_the_adaptive_system_compensates_for_low_boost._In_factory_calibrations,_INCPT_is_set_to_32_counts_(approximately_0.35_seconds).
    .byte 0x10                       ;Point 1

	;.org	0x86ed
INCLIM_UpperLimitOnWastegateDutyCycleCorrection:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x1392
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UpperLimitOnWastegateDutyCycleCorrection
    ;mptblcname INCLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc INCLIM_establishes_the_upper_clamp_boundary_for_adaptive_wastegate_cell_values,_capping_the_maximum_positive_duty_cycle_correction_that_the_adaptive_system_can_add_on_top_of_the_base_table._Caps_the_upward_learning_authority_of_the_adaptive_wastegate_system._In_factory_calibrations,_INCLIM_is_set_to_255_counts,_giving_maximum_upward_adaptation_headroom_(+127_counts,_or_approximately_63.5_percent_duty_cycle_addition).
    .byte 0xE0                       ;Point 1

	;.org	0x86ee
DCRPML_NoWastegateDutyCycleCorrectionBelowThisRpm:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x139F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoWastegateDutyCycleCorrectionBelowThisRpm
    ;mptblcname DCRPML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc DCRPML_sets_the_lower_engine_speed_threshold_below_which_adaptive_wastegate_duty_cycle_learning_is_completely_inhibited._Defines_the_low-RPM_boundary_for_closed-loop_adaptive_learning._In_factory_calibrations,_DCRPML_is_set_to_84_counts_(approximately_2688_RPM)._When_using_a_small,_rapid-spooling_stock_turbocharger,_DCRPML_can_remain_at_factory_levels_or_be_lowered_slightly_to_2200_to_2400_RPM.
    .byte 0x42                       ;Point 1

	;.org	0x86ef
TPSLIM_UpdateAdaptiveWGTPSUpperLimit:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x13AC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UpdateAdaptiveWGTPSUpperLimit
    ;mptblcname TPSLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis TPS_Volts 0 5 volts
    ;mptbldesc TPSLIM_defines_the_minimum_throttle_position_sensor_delta_voltage_above_idle_required_to_permit_adaptive_wastegate_duty_cycle_incrementing_in_T1_control._Ensures_that_adaptive_boost_learning_occurs_only_under_genuine_high-throttle_demands._In_factory_calibrations,_TPSLIM_is_set_to_112_counts,_representing_approximately_2.2_volts_above_minimum_idle_throttle_position.
    .byte 0x66                       ;Point 1

	;.org	0x86f0
MAPPT_WastegateDutyCycleMapSwitchPoint:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x13B9
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname WastegateDutyCycleMapSwitchPoint
    ;mptblcname MAPPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc MAPPT_sets_the_manifold_gauge_pressure_switch_point_that_divides_low-load_adaptive_wastegate_learning_from_high-load_RPM-split_adaptive_learning_in_T1_control._When_tuning_for_higher_boost_targets,_MAPPT_should_be_positioned_near_or_slightly_above_mechanical_wastegate_spring_pressure._If_MAPPT_is_set_too_low_(e.g.,_below_base_actuator_spring_pressure),_the_controller_will_prematurely_place_low-speed_spooling_into_the_RPM-split_high-load_cells.
    ;mpmapaxis y
    .byte 0x53                       ;Point 1

	;.org	0x86f1
DCRPM1_WastegateDutyCycleRpmBoundary1:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x13C7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleRpmBoundary1
    ;mptblcname DCRPM1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc DCRPM1_establishes_the_first_engine_speed_boundary_dividing_the_RPM-split_adaptive_wastegate_cells_in_high-boost_operation._Adjusting_DCRPM1_allows_tuners_to_align_the_adaptive_cell_boundaries_with_the_torque_and_volumetric_efficiency_characteristics_of_modified_engines._In_factory_calibrations,_DCRPM1_is_set_to_approximately_4000_to_4200_RPM.
    .byte 0x5E                       ;Point 1

	;.org	0x86f2
DCRPM2_WastegateDutyCycleRpmBoundary2:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x13D4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleRpmBoundary2
    ;mptblcname DCRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc DCRPM2_defines_the_second_engine_speed_boundary_dividing_high-load_adaptive_wastegate_cells,_separating_Cell_3_(mid-range_torque)_from_Cell_4_(upper_mid-range)._Sets_the_transition_point_where_the_controller_switches_from_mid-range_boost_adaptation_to_high-RPM_adaptation.
    .byte 0x7A                       ;Point 1

	;.org	0x86f3
DCRPM3_WastegateDutyCycleRpmBoundary3:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T1_WG_Control\T1_WGDC_Adaptives\
    ;mptbladdr 0x13E1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleRpmBoundary3
    ;mptblcname DCRPM3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc DCRPM3_sets_the_third_and_highest_engine_speed_boundary_in_the_adaptive_wastegate_grid,_separating_Cell_4_from_Cell_5_(the_high-RPM_redline_cell)._Establishing_DCRPM3_near_5200_to_5600_RPM_ensures_that_top-end_boost_behavior_does_not_corrupt_mid-range_duty_cycle_adaptation.
    .byte 0x96                       ;Point 1

T2MAPPT_WastegateDutyCycleMapSwitchPoint:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Adaptives\
    ;mptbladdr 0x13ED
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname WastegateDutyCycleMapSwitchPoint
    ;mptblcname T2MAPPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc T2MAPPT_sets_the_manifold_gauge_boost_pressure_threshold_that_divides_low-load_adaptive_wastegate_learning_from_high-load_RPM-split_adaptive_learning_in_T2_control._Position_T2MAPPT_near_or_slightly_above_mechanical_wastegate_actuator_spring_pressure_on_T2_hardware_setups._If_set_too_low,_the_controller_prematurely_transitions_into_the_RPM-split_cells_before_the_turbo_has_built_sufficient_boost.
    ;mpmapaxis y
    .byte 0x53                       ;Point 1

T2MAPPT2_WastegateDutyCycleMapSwitchPoint2:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Adaptives\
    ;mptbladdr 0x13FA
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname WastegateDutyCycleMapSwitchPoint2
    ;mptblcname T2MAPPT2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc T2MAPPT2_was_designed_to_define_the_minimum_manifold_gauge_pressure_threshold_required_to_activate_wastegate_duty_cycle_calculations_in_T2_control._In_factory_calibration_templates,_T2MAPPT2_is_set_to_46_counts_(approximately_5.3_psi_of_boost)._Modifying_T2MAPPT2_in_calibration_editing_software_will_produce_no_physical_change_in_engine_behavior_on_stock_T-SMEC_v19_firmware_because_line_9764_of_CalcWGDutyCycleT2_reads_MAPPT2_instead.
    ;mpmapaxis y
    .byte 0x2E                       ;Point 1

T2KNOKMP_MinimumBoostToCountKnockEvents:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Knock_Adj\
    ;mptbladdr 0x1407
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MinimumBoostToCountKnockEvents
    ;mptblcname T2KNOKMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc T2KNOKMP_specifies_the_minimum_manifold_gauge_pressure_threshold_required_before_the_controller_registers_detonation_events_toward_wastegate_duty_cycle_reduction_in_T2_control._Ensures_that_wastegate_duty_cycle_is_not_reduced_during_low-load_or_off-boost_knock_events,_such_as_tip-in_rattle_or_false_knock_from_valvetrain_noise_at_light_load._In_factory_calibrations,_T2KNOKMP_is_set_to_35_counts_(approximately_4.0_psi_of_boost).
    ;mpmapaxis y
    .byte 0x23                       ;Point 1

T2WGKNRD_MinimumKnockToReduceWGDC:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Knock_Adj\
    ;mptbladdr 0x1414
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumKnockToReduceWGDC
    ;mptblcname T2WGKNRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis KnockRetard 0 127 deg
    ;mptbldesc T2WGKNRD_defines_the_individual_cylinder_spark_retard_threshold_required_to_trigger_wastegate_duty_cycle_reduction_and_decay_pacing_in_T2_control._The_engine_controller_monitors_knock_spark_retard_across_individual_cylinders_(Cylinder_2_through_Cylinder_4)._Sets_the_sensitivity_threshold_between_spark_retard_and_boost_reduction_in_T2_mode._In_factory_calibrations,_T2WGKNRD_is_set_to_7_counts_(approximately_0.875_degrees_of_spark_retard).
    .byte 0x07                       ;Point 1

T2RPMBST_MinimumRpmToTrackBoostCreep:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_BoostCreep\
    ;mptbladdr 0x1420
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumRpmToTrackBoostCreep
    ;mptblcname T2RPMBST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc T2RPMBST_defines_the_minimum_engine_speed_threshold_required_to_advance_the_boost_ramp_countdown_timer_(Timer_BoostTimer)_in_T2_control._Aligns_the_boost_ramp_timer_with_turbocharger_spool_characteristics_on_T2_hardware._In_factory_calibrations,_T2RPMBST_is_set_to_76_counts_(approximately_2432_RPM)._For_fast-spooling_stock_turbochargers,_lowering_T2RPMBST_slightly_allows_the_ramp_timer_to_begin_incrementing_earlier_in_the_rev_band.
    .byte 0x4C                       ;Point 1

T2RATLIM_OverboostPreventionRateLimit_FromRpm:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_BoostCreep\
    ;mptbladdr 0x142C
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname OverboostPreventionRateLimit_FromRpm
    ;mptblcname T2RATLIM
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis DeltaBoost 0 29.4 psi
    ;mptbldesc T2RATLIM_establishes_the_maximum_allowable_rate_of_turbocharger_boost_pressure_rise_as_a_function_of_engine_speed_in_T2_control._Key_calibration_table_for_controlling_boost_spikes_and_boost_creep_on_T2_systems._In_factory_calibrations,_T2RATLIM_sets_a_tight_rate-of-rise_threshold_(typically_12_counts_at_low_RPM_tapering_to_6_counts_at_high_RPM).
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x20, 0x0C, 0xFF, 0xF4     ;Point 1
    .byte 0x9C, 0x06                 ;Point 2

T2PRTMAX_MaxWastegateDutyCycleforPartThrottleBoostCreep:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_BoostCreep\
    ;mptbladdr 0x143B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxWastegateDutyCycleforPartThrottleBoostCreep
    ;mptblcname T2PRTMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis WGDC 0 127 percent
    ;mptbldesc T2PRTMAX_defines_the_emergency_wastegate_duty_cycle_value_forced_directly_onto_the_solenoid_output_whenever_the_rate_of_boost_rise_exceeds_the_rate_limit_threshold_(T2RATLIM)_in_T2_control._Acts_as_the_emergency_wastegate_command_when_boost_rises_too_quickly._In_factory_calibrations,_T2PRTMAX_is_set_to_200_counts_(representing_100_percent_duty_cycle).
    .byte 0xC8                       ;Point 1

T2MPDEL_HysteresisForBoostCreep:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_BoostCreep\
    ;mptbladdr 0x1447
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname HysteresisForBoostCreep
    ;mptblcname T2MPDEL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc T2MPDEL_establishes_a_deadband_hysteresis_threshold_subtracted_from_the_rate_of_boost_change_before_the_controller_calculates_the_dynamic_response_factor_correction_in_T2_control._Adjusts_the_threshold_where_dynamic_response_factor_correction_engages_in_T2_mode._In_factory_calibrations,_T2MPDEL_is_set_to_0_counts,_meaning_any_non-zero_rate_of_boost_change_is_processed_through_the_response_factor_table.
    ;mpmapaxis y
    .byte 0x00                       ;Point 1

T2RESFAC_MapCorrectionResponseFactor_FromMap:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_BoostCreep\
    ;mptbladdr 0x1454
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname MapCorrectionResponseFactor_FromMap
    ;mptblcname T2RESFAC
    ;mpxaxis Boost 0 29.4 psi
    ;mpyaxis PerMAP 0 29.4 units/psi
    ;mptbldesc T2RESFAC_supplies_a_manifold-pressure-dependent_response_factor_gain_table_used_to_dynamically_scale_the_rate-of-boost_correction_in_T2_control._Modulates_the_strength_of_dynamic_feedback_damping_in_T2_control._Raising_the_values_in_T2RESFAC_increases_the_correction_gain,_causing_the_controller_to_respond_more_aggressively_to_rising_boost_rates_by_trimming_target_boost_and_opening_the_wastegate_sooner.
    ;mpmapaxis x-y
    .byte 0x02                       ;Number of points in table
    .byte 0x91, 0x06, 0xFF, 0xA6     ;Point 1
    .byte 0xA2, 0x00                 ;Point 2

T2DCWOT_FullThrottleWastegateDutyCycle_C8is100Percent_FromMap:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Lookup\
    ;mptbladdr 0x1463
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FullThrottleWastegateDutyCycle_C8is100Percent_FromMap
    ;mptblcname T2DCWOT
    ;mpxaxis TargetBoost 0 29.4 psi
    ;mpyaxis Duty_Cycle 0 127.5 percent
    ;mptbldesc T2DCWOT_provides_the_open-loop_base_wastegate_duty_cycle_curve_as_a_function_of_target_boost_pressure_for_T2_wastegate_control._Serves_as_the_foundational_duty_cycle_curve_when_running_T2_wastegate_control._If_the_engine_consistently_overshoots_or_creeps_past_target_boost_in_T2_mode,_increasing_T2DCWOT_commands_higher_solenoid_duty_cycle_to_open_the_wastegate_further.
    ;mpmapaxis x
    .byte 0x05                       ;Number of points in table
    .byte 0x2E, 0xC8, 0xF3, 0x9A     ;Point 1
    .byte 0x33, 0x8A, 0xFE, 0x85     ;Point 2
    .byte 0x4E, 0x62, 0xFE, 0xE4     ;Point 3
    .byte 0x69, 0x44, 0xFF, 0xAD     ;Point 4
    .byte 0x88, 0x3A                 ;Point 5

T2DCWADJ_FullThrottleWastegateDutyCycleAdjustment_FromRpm:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Lookup\
    ;mptbladdr 0x1475
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname FullThrottleWastegateDutyCycleAdjustment_FromRpm
    ;mptblcname T2DCWADJ
    ;mpxaxis RPM 0 8160 rpm
    ;mpyaxis DC_Adjust -64 63.5 percent
    ;mptbldesc T2DCWADJ_supplies_an_engine-speed-dependent_signed_duty_cycle_adjustment_to_the_base_wastegate_duty_cycle_in_T2_control._Used_to_eliminate_high-RPM_boost_sag_or_boost_creep_in_T2_mode._If_boost_tends_to_fall_off_near_redline_on_a_T2_setup,_subtracting_duty_cycle_at_high_RPM_in_T2DCWADJ_keeps_control_pressure_off_the_actuator,_holding_the_wastegate_valve_closed_to_maintain_boost.
    .byte 0x06                       ;Number of points in table
    .byte 0x3F, 0xD0, 0x04, 0x00     ;Point 1
    .byte 0x4B, 0x00, 0x00, 0x00     ;Point 2
    .byte 0x75, 0x00, 0xFF, 0xDA     ;Point 3
    .byte 0x90, 0xFC, 0x00, 0x55     ;Point 4
    .byte 0x9C, 0x00, 0xFE, 0xDB     ;Point 5
    .byte 0xA3, 0xF8                 ;Point 6

T2DCWBST_FullThrottleWastegateDutyCycleAdjustment_FromBoostTarget:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Lookup\
    ;mptbladdr 0x1487
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FullThrottleWastegateDutyCycleAdjustment_FromBoostTarget
    ;mptblcname T2DCWBST
    ;mpxaxis DeltaMAP 0 29.4 psi
    ;mpyaxis DC_Adjust 0 127.5 percent
    ;mptbldesc T2DCWBST_provides_an_error-proportional_duty_cycle_correction_based_on_the_difference_between_target_boost_and_actual_manifold_pressure_in_T2_control._Unlike_the_T1_routine_where_positive_error_adds_duty_cycle,_the_T2_routine_explicitly_negates_the_lookup_result_(using_the_assembly_instruction_nega)_before_applying_it_to_the_duty_cycle_total._Shapes_the_closed-loop_proportional_boost_correction_and_spool-up_behavior_in_T2_mode.
    ;mpmapaxis x
    .byte 0x06                       ;Number of points in table
    .byte 0x2C, 0x00, 0x08, 0x92     ;Point 1
    .byte 0x3A, 0x78, 0x01, 0xB9     ;Point 2
    .byte 0x57, 0xAA, 0x01, 0x08     ;Point 3
    .byte 0x74, 0xC8, 0x00, 0x00     ;Point 4
    .byte 0x84, 0xC8, 0x00, 0x00     ;Point 5
    .byte 0x94, 0xC8                 ;Point 6

T2KDCINC_WastegateDutyCycleIncreaseStepWhenKnocking:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Knock_Adj\
    ;mptbladdr 0x149A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseStepWhenKnocking
    ;mptblcname T2KDCINC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc T2KDCINC_sets_the_incremental_duty_cycle_step_added_to_the_knock_reduction_penalty_on_each_confirmed_detonation_event_under_boost_in_T2_control._Adjusts_the_speed_of_boost_reduction_during_detonation_in_T2_mode._Increasing_T2KDCINC_causes_boost_to_drop_more_aggressively_with_each_knock_event,_offering_rapid_protection_against_bad_fuel_or_excessive_charge_temperatures.
    .byte 0x08                       ;Point 1

T2KDCMAX_WastegateDutyCycleIncreaseMaxWhenKnocking:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Knock_Adj\
    ;mptbladdr 0x14A6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseMaxWhenKnocking
    ;mptblcname T2KDCMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc T2KDCMAX_establishes_the_upper_ceiling_on_cumulative_knock_duty_cycle_modification_in_T2_control._When_persistent_detonation_occurs_under_boost,_repeated_knock_events_accumulate_additional_duty_cycle_steps._Sets_the_ultimate_limit_of_boost_reduction_authority_available_to_resolve_knock_in_T2_mode._In_factory_calibrations,_T2KDCMAX_is_set_to_60_to_80_counts_(30.0_to_40.0_percent_duty_cycle_adjustment).
    .byte 0x3C                       ;Point 1

T2KDCMIN_WastegateDutyCycleIncreaseMinWhenKnocking:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Knock_Adj\
    ;mptbladdr 0x14B2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseMinWhenKnocking
    ;mptblcname T2KDCMIN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc T2KDCMIN_specifies_the_minimum_baseline_duty_cycle_step_applied_immediately_upon_the_initial_detection_of_detonation_under_boost_in_T2_control._Governs_the_immediacy_of_boost_reduction_upon_knock_onset_in_T2_mode._In_factory_calibrations,_T2KDCMIN_is_set_to_12_to_16_counts_(6.0_to_8.0_percent_duty_cycle_adjustment).
    .byte 0x10                       ;Point 1

T2DECTIM_TimeScaleFor_DCDECK:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Knock_Adj\
    ;mptbladdr 0x14BE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeScaleFor_DCDECK
    ;mptblcname T2DECTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc T2DECTIM_sets_the_timing_prescaler_bitmask_that_governs_how_frequently_the_knock_duty_cycle_recovery_decrement_(T2DCDECK)_is_executed_in_T2_control._Regulates_the_elapsed_time_between_boost_recovery_steps_in_T2_mode._In_factory_calibrations,_T2DECTIM_is_set_to_7,_meaning_T2DCDECK_is_executed_every_8th_main_loop_pass_(approximately_every_88_milliseconds).
    .byte 0x07                       ;Point 1

T2DCDECK_WastegateDutyCycleDecrementWhenSparkStillDerated:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Knock_Adj\
    ;mptbladdr 0x14CA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleDecrementWhenSparkStillDerated
    ;mptblcname T2DCDECK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc T2DCDECK_controls_the_rate_at_which_wastegate_duty_cycle_recovers_toward_normal_operation_after_a_detonation_event_has_subsided_in_T2_control._Modifying_T2DCDECK_tunes_the_rate_of_boost_recovery_in_T2_mode._In_factory_calibrations,_T2DCDECK_is_set_to_2_counts_(1.0_percent_duty_cycle_recovery_per_interval)._Increasing_T2DCDECK_restores_full_boost_faster_once_knock_clears,_improving_acceleration_recovery_on_race_fuel_or_cool_intake_air.
    .byte 0x02                       ;Point 1

T2MPDEL1_IncCounterWhenDeltaMapBelowThis:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Adaptives\
    ;mptbladdr 0x14D6
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname IncCounterWhenDeltaMapBelowThis
    ;mptblcname T2MPDEL1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc T2MPDEL1_sets_the_rate-of-change_stability_threshold_for_manifold_pressure_required_before_the_error_timer_can_advance_when_boost_is_above_target_in_T2_control._T2_control_actively_tracks_the_signed_rate_of_boost_change_(BoostDelta_Signed)._Acts_as_a_dynamic_stability_filter_for_T2_adaptive_learning._In_factory_calibrations,_T2MPDEL1_is_set_to_2_counts_(approximately_0.23_psi).
    ;mpmapaxis y
    .byte 0x02                       ;Point 1

T2INCPT_AdaptiveIncAfterThisTime:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Adaptives\
    ;mptbladdr 0x14E3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveIncAfterThisTime
    ;mptblcname T2INCPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc T2INCPT_defines_the_error_timer_dwell_duration_required_before_incrementing_an_adaptive_wastegate_cell_in_T2_control._Controls_the_responsiveness_of_adaptive_learning_in_T2_mode._In_factory_calibrations,_T2INCPT_is_configured_to_10_to_16_counts_(approximately_0.11_to_0.18_seconds)._Setting_T2INCPT_lower_speeds_up_adaptive_learning,_making_the_system_converge_on_target_boost_faster_but_increasing_susceptibility_to_transient_error_over-correction.
    .byte 0x10                       ;Point 1
    
UPRLIM_UpperLimitOnMPCORR: 
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Adaptives\
    ;mptbladdr 0x14EF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UpperLimitOnMPCORR
    ;mptblcname UPRLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc UPRLIM_specifies_the_upper_authority_clamp_applied_to_the_dynamic_manifold_pressure_response_correction_(MPCORR)_in_T2_boost_creep_control._Controls_how_aggressively_the_T2_algorithm_can_intervene_to_arrest_rapid_boost_rise._In_factory_calibrations,_UPRLIM_is_set_to_16_counts_(8.0_percent_duty_cycle_offset).
    .byte 0x10                       ;Point 1

LWRLIM_LowerLimitOnMPCORR:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Adaptives\
    ;mptbladdr 0x14FB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowerLimitOnMPCORR
    ;mptblcname LWRLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LWRLIM_specifies_the_lower_authority_clamp_applied_to_the_dynamic_manifold_pressure_response_correction_(MPCORR)_in_T2_boost_creep_control_when_the_rate_of_boost_change_is_negative._Establishes_the_maximum_recovery_authority_when_boost_pressure_drops_below_target_in_T2_mode._Setting_LWRLIM_to_32_counts_provides_decisive_authority_to_prop_up_duty_cycle_if_boost_dips_during_gear_shifts_or_transient_throttle_transitions.
    .byte 0x20                       ;Point 1
    
T2MPROOF_StopAdaptiveWhenMapIsThisCloseToBoostTarget:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Adaptives\
    ;mptbladdr 0x1507
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname StopAdaptiveWhenMapIsThisCloseToBoostTarget
    ;mptblcname T2MPROOF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc T2MPROOF_defines_the_adaptive_deadband_threshold_below_target_boost_where_adaptive_duty_cycle_incrementing_is_halted_in_T2_control._Establishes_the_upper_deadband_margin_for_T2_adaptive_boost_trimming._In_factory_calibrations,_T2MPROOF_is_configured_to_2_counts_(approximately_0.23_psi)._Setting_T2MPROOF_too_low_can_cause_the_adaptive_system_to_hunt_continuously,_adding_and_subtracting_duty_cycle_on_successive_passes.
    ;mpmapaxis y
    .byte 0x02                       ;Point 1

T2MPFLOR_StopAdaptiveWhenMapIsThisCloseToBoostFloor:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Adaptives\
    ;mptbladdr 0x1514
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname StopAdaptiveWhenMapIsThisCloseToBoostFloor
    ;mptblcname T2MPFLOR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc T2MPFLOR_defines_the_adaptive_deadband_threshold_above_target_boost_where_adaptive_duty_cycle_decrementing_is_halted_in_T2_control._Sets_the_lower_deadband_margin_for_downward_adaptive_trimming_in_T2_mode._In_factory_calibrations,_T2MPFLOR_is_set_to_0_to_2_counts_(0.0_to_0.23_psi)._Setting_T2MPFLOR_to_zero_ensures_that_downward_duty_cycle_trimming_continues_until_actual_boost_is_strictly_at_or_below_target.
    ;mpmapaxis y
    .byte 0x00                       ;Point 1

DCRPMH_NoWastegateDutyCycleCorrectionAboveThisRpm:
    ;mpgrp 3_-_Boost_Control\B_-_WG_Control\T2_WG_Control\T2_WGDC_Adaptives\
    ;mptbladdr 0x1521
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoWastegateDutyCycleCorrectionAboveThisRpm
    ;mptblcname DCRPMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc DCRPMH_defines_the_upper_engine_speed_threshold_above_which_adaptive_wastegate_duty_cycle_learning_is_completely_inhibited_in_T2_control._Establishes_the_upper_cutoff_for_closed-loop_adaptive_learning_in_T2_mode._In_factory_calibrations,_DCRPMH_is_configured_to_188_counts_(approximately_6016_RPM).
    .byte 0xBC                       ;Point 1

	;.org	0x86f4
BRPMLO_BaroReadLowRPM1800:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x152E
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname BaroReadLowRPM1800
    ;mptblcname BRPMLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc BRPMLO_defines_the_lower_engine_speed_boundary_for_in-flight_atmospheric_barometric_pressure_sampling_during_vehicle_deceleration._Raising_BRPMLO_narrows_the_permissible_RPM_window_for_deceleration_baro_updates,_which_can_be_useful_when_fitting_aggressive_high-overlap_camshafts_that_produce_erratic_manifold_pressure_pulses_at_low_to_intermediate_engine_speeds.
    .word 0x3840                     ;Point 1

	;.org	0x86f6
BRPMHI_BaroReadHighRPM6650:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x153B
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname BaroReadHighRPM6650
    ;mptblcname BRPMHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc BRPMHI_defines_the_upper_engine_speed_boundary_for_in-flight_atmospheric_barometric_pressure_sampling_during_vehicle_deceleration._On_modified_engines_that_rev_to_7000_RPM_or_higher,_BRPMHI_should_be_kept_around_6000_to_6500_RPM_to_avoid_switching_the_manifold_pressure_sensor_to_atmospheric_vent_while_the_engine_is_spinning_at_elevated_rotational_speeds.
    .word 0xCFD0                     ;Point 1

	;.org	0x86f8
BRDLAY_BaroReadDelayAfterThrottleClosed2sec:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x1548
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadDelayAfterThrottleClosed2sec
    ;mptblcname BRDLAY
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc BRDLAY_defines_the_required_duration_of_steady_closed-throttle_deceleration_before_the_engine_controller_is_permitted_to_initiate_an_in-flight_barometric_pressure_reading._Lowering_BRDLAY_allows_the_controller_to_sample_barometric_pressure_during_shorter_deceleration_events,_which_can_improve_altitude_tracking_when_driving_through_rapid_mountain_switchbacks_with_short_downhill_corners.
    .byte 0xB6                       ;Point 1

	;.org	0x86f9
BARTIM_BaroReadMinTimeBetweenReadings179sec:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x1555
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadMinTimeBetweenReadings179sec
    ;mptblcname BARTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 720 sec
    ;mptbldesc BARTIM_defines_the_minimum_time_interval_required_between_successive_in-flight_barometric_pressure_updates._Lowering_BARTIM_allows_more_frequent_barometric_pressure_sampling,_which_is_advantageous_for_hill-climb_competition_or_mountain_driving_where_road_elevation_changes_by_thousands_of_feet_within_a_short_drive._Reducing_BARTIM_to_60_or_90_seconds_improves_altitude_fuel_trimming_responsiveness.
    .byte 0x40                       ;Point 1

	;.org	0x86fa
BROPTM_BaroReadDelayAfterSolenoidOpenTenthSec:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x1562
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadDelayAfterSolenoidOpenTenthSec
    ;mptblcname BROPTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc BROPTM_defines_the_pneumatic_stabilization_delay_after_the_barometric_read_solenoid_is_energized_before_the_engine_controller_reads_the_manifold_absolute_pressure_sensor_voltage._If_aftermarket_vacuum_lines_to_the_pressure_sensor_have_been_lengthened,_or_if_an_inline_pneumatic_pulsation_dampener_or_filter_is_installed_in_the_sensor_line,_pneumatic_pressure_equalization_requires_more_time.
    .byte 0x09                       ;Point 1

	;.org	0x86fb
BRCLTM_BaroReadDelayAfterSolenoidClosedTenthSec:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x156F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadDelayAfterSolenoidClosedTenthSec
    ;mptblcname BRCLTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc BRCLTM_defines_the_pneumatic_stabilization_delay_after_the_barometric_read_solenoid_is_de-energized_before_the_engine_controller_resumes_using_sensor_readings_for_manifold_pressure_calculations._Maintaining_proper_delay_in_BRCLTM_prevents_false_transient_enrichments_upon_throttle_reapplication.
    .byte 0x09                       ;Point 1

	;.org	0x86fc
BAROHI_BaroReadValidHighLimit:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x157C
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BaroReadValidHighLimit
    ;mptblcname BAROHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 14.7 psi
    ;mptbldesc BAROHI_defines_the_maximum_credible_atmospheric_pressure_threshold_used_during_barometric_pressure_validation._When_converting_to_a_3-bar_MAP_sensor,_BAROHI_must_be_rescaled._On_a_factory_2-bar_sensor,_0_to_5_volts_spans_0_to_29.4_psi_absolute,_placing_sea_level_atmospheric_pressure_near_128_counts.
    ;mpmapaxis y
    .byte 0x85                       ;Point 1

	;.org	0x86fd
BAROLO_BaroReadValidLowLimit:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x158A
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BaroReadValidLowLimit
    ;mptblcname BAROLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 14.7 psi
    ;mptbldesc BAROLO_defines_the_minimum_credible_atmospheric_pressure_threshold_used_during_barometric_pressure_validation._When_the_engine_controller_reads_ambient_barometric_pressure,_it_verifies_that_the_measurement_is_above_BAROLO_before_storing_it_into_RAM._When_converting_to_a_3-bar_MAP_sensor,_BAROLO_must_be_rescaled_downward._On_a_3-bar_sensor,_7.9_psi_absolute_corresponds_to_approximately_46_counts_on_the_0_to_44.1_psi_scale.
    ;mpmapaxis y
    .byte 0x45                       ;Point 1

	;.org	0x86fe
BARDFT_BaroReadDefaultValue:
    ;mpgrp 7_-_Aux_Functions\Baro_Read\
    ;mptbladdr 0x1598
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BaroReadDefaultValue
    ;mptblcname BARDFT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 14.7 psi
    ;mptbldesc BARDFT_defines_the_failsafe_default_atmospheric_barometric_pressure_value_loaded_into_memory_whenever_a_measured_barometric_reading_fails_sensor_plausibility_verification._BARDFT_must_be_rescaled_whenever_upgrading_to_a_3-bar_MAP_sensor._On_a_factory_2-bar_sensor,_14.6_psi_absolute_corresponds_to_127_counts_on_the_0_to_29.4_psi_span._On_a_3-bar_sensor,_14.6_psi_absolute_corresponds_to_approximately_85_counts_on_the_0_to_44.1_psi_span.
    ;mpmapaxis y
    .byte 0x7F                       ;Point 1




	;.org	0x86ff
FANTMP_FanTurnOnTempAbove45MPH:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x15A9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOnTempAbove45Mph
    ;mptblcname FANTMP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc FANTMP1_defines_the_engine_coolant_temperature_threshold_required_to_energize_the_radiator_cooling_fan_when_the_vehicle_is_traveling_at_highway_speeds_above_45_MPH._Lowering_FANTMP1_turns_the_cooling_fan_on_at_cooler_operating_temperatures_during_highway_cruising,_which_is_essential_when_installing_a_160_°F_or_180_°F_performance_thermostat.
    .byte 0xE8                       ;Point 1

	;.org	0x8700
FANTMP2_FanTurnOffTempAbove45MPH:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x15B6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOffTempAbove45Mph
    ;mptblcname FANTMP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc FANTMP2_defines_the_engine_coolant_temperature_threshold_where_the_radiator_cooling_fan_is_turned_off_after_a_highway_cooling_cycle_above_45_MPH._When_lowering_FANTMP1_for_a_cooler_thermostat,_FANTMP2_must_be_lowered_proportionally_to_maintain_an_adequate_hysteresis_deadband._For_a_180_°F_thermostat_setup_with_FANTMP1_at_194_°F,_set_FANTMP2_to_approximately_188_°F.
    .byte 0xE3                       ;Point 1

	;.org	0x8701
FANTMP3_FanTurnOnTempBelow35MPH:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x15C3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOnTempBelow35Mph
    ;mptblcname FANTMP3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc FANTMP3_defines_the_coolant_temperature_threshold_that_energizes_the_radiator_cooling_fan_during_low-speed_driving_or_idle_conditions_below_35_MPH._When_stopped_in_traffic_or_driving_at_low_vehicle_speeds,_no_ram_airflow_enters_the_front_grille_to_cool_the_radiator_and_intercooler_cores._FANTMP3_is_the_primary_parameter_tuners_modify_to_control_engine_operating_temperature_in_stop-and-go_driving.
    .byte 0xE3                       ;Point 1

	;.org	0x8702
FANTMP4_FanTurnOffTempBelow35MPH:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x15D0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOffTempBelow35Mph
    ;mptblcname FANTMP4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc FANTMP4_defines_the_engine_coolant_temperature_threshold_where_the_cooling_fan_shuts_off_after_completing_a_low-speed_cooling_cycle_below_35_MPH._When_lowering_FANTMP3_for_a_cooler_thermostat,_FANTMP4_must_be_lowered_by_a_matching_amount_to_preserve_the_hysteresis_band._For_a_180_°F_thermostat,_set_FANTMP3_to_190_°F_and_FANTMP4_to_184_°F._Ensure_FANTMP4_is_positioned_at_least_3_to_5_°F_above_the_thermostat_rated_opening_temperature.
    .byte 0xDD                       ;Point 1

	;.org	0x8703
FANMAP_FanTurnsOnWhenMapAboveBaroPlusThis:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x15DD
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname FanTurnsOnWhenMapAboveBaroPlusThis
    ;mptblcname FANMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc FANMAP_defines_the_turbocharger_boost_pressure_threshold_relative_to_barometric_pressure_that_turns_on_the_radiator_and_intercooler_cooling_fan._For_performance_and_intercooled_calibrations,_lowering_FANMAP_to_approximately_2.0_to_4.0_psi_of_boost_(17_to_35_counts)_energizes_the_cooling_fan_during_boost_spool-up.
    ;mpmapaxis y
    .byte 0x1A                       ;Point 1

	;.org	0x8704
FANBAT_FanTurnsOnWhenBatteryTempAboveThis:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x15EB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnsOnWhenBatteryTempAboveThis
    ;mptblcname FANBAT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Battery_Temp -200 260 Degrees
    ;mptbldesc FANBAT_defines_the_underhood_temperature_threshold_measured_at_the_battery_tray_thermistor_that_triggers_radiator_cooling_fan_activation._Lowering_FANBAT_causes_the_cooling_fan_to_engage_at_cooler_underhood_temperatures,_which_is_beneficial_for_tight_engine_compartments_(such_as_Dodge_Omni_or_Charger_GLH_bodies)_where_turbo_heat_buildup_is_intense._Raising_FANBAT_delays_underhood_heat-triggered_fan_activation.
    .byte 0x1B                       ;Point 1

FNSPHI_FanControlSpeedHi:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x15F7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanControlSpeedHi
    ;mptblcname FNSPHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 1020 MPH
    ;mptbldesc FNSPHI_defines_the_high_vehicle_speed_transition_threshold_that_switches_the_cooling_fan_logic_between_low-speed_city_mode_and_high-speed_highway_mode._FNSPHI_works_in_tandem_with_FNSPLO_to_establish_a_speed_hysteresis_deadband,_preventing_the_cooling_fan_controller_from_erratic_mode_switching_around_40_MPH.
    .byte 0x0B                       ;Point 1

FNSPLO_FanControlSpeedLo:
    ;mpgrp 6_-_Fan_Control\
    ;mptbladdr 0x1603
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanControlSpeedLo
    ;mptblcname FNSPLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 1020 MPH
    ;mptbldesc FNSPLO_defines_the_low_vehicle_speed_transition_threshold_that_switches_the_cooling_fan_logic_back_into_low-speed_mode_when_the_vehicle_decelerates._FNSPLO_establishes_the_lower_boundary_of_the_vehicle_speed_hysteresis_deadband._Lowering_FNSPLO_in_counts_raises_the_road_speed_in_miles_per_hour_where_the_controller_transitions_out_of_low-speed_fan_mode._Raising_FNSPLO_in_counts_allows_low-speed_mode_to_persist_down_to_lower_road_speeds.
    .byte 0x09                       ;Point 1

	;.org	0x8705
PURMAP_CannisterPurgeWhenBelowThisBaro:
    ;mpgrp 7_-_Aux_Functions\Purge_Control\
    ;mptbladdr 0x1610
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname CannisterPurgeWhenBelowThisBaro
    ;mptblcname PURMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc PURMAP_establishes_the_intake_manifold_vacuum_margin_required_below_atmospheric_barometric_pressure_to_enable_the_evaporative_emission_canister_purge_solenoid._When_converting_to_a_3-bar_MAP_sensor,_PURMAP_should_be_checked_and_rescaled._On_a_3-bar_sensor,_5_counts_represents_a_wider_pressure_delta_(~0.86_psi),_requiring_deeper_engine_vacuum_before_canister_purge_opens.
    ;mpmapaxis y
    .byte 0x05                       ;Point 1

	;.org	0x8706
PURHYS_CannisterPurgeBaroHysteresis:
    ;mpgrp 7_-_Aux_Functions\Purge_Control\
    ;mptbladdr 0x161E
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname CannisterPurgeBaroHysteresis
    ;mptblcname PURHYS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc PURHYS_defines_the_vacuum_hysteresis_deadband_for_the_evaporative_canister_purge_solenoid_control_routine._Retain_the_factory_setting_of_2_counts_for_normal_street_operation._Increasing_PURHYS_widens_the_hysteresis_deadband,_preventing_purge_shutdown_during_minor_throttle_tip-ins_and_keeping_the_valve_flowing_vapors_steadily_under_variable_cruise_loads.
    ;mpmapaxis y
    .byte 0x02                       ;Point 1

	;.org	0x8707
PURTMP_CanisterPurgeCoolantTemp:
    ;mpgrp 7_-_Aux_Functions\Purge_Control\
    ;mptbladdr 0x162C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CanisterPurgeCoolantTemp
    ;mptblcname PURTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc PURTMP_defines_the_minimum_engine_coolant_temperature_required_to_enable_evaporative_canister_purge_operation._When_an_engine_is_warming_up_from_a_cold_start,_fuel_atomization_is_inefficient,_combustion_chamber_walls_are_cold,_and_the_engine_operates_in_open-loop_fuel_enrichment._Raising_PURTMP_to_160_°F_or_170_°F_delays_canister_purge_until_the_engine_has_completely_warmed_up_and_settled_into_fully_adapted_closed-loop_oxygen_sensor_control.
    .byte 0x82                       ;Point 1

	;.org	0x8708
ACLRPM_DisableAcBelowThisRPM_500:
    ;mpgrp 7_-_Aux_Functions\AC_Control\
    ;mptbladdr 0x1639
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DisableAcBelowThisRPM_500
    ;mptblcname ACLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACLRPM_defines_the_low_engine_speed_emergency_anti-stall_cutout_threshold_for_the_air_conditioning_compressor_clutch._Raising_ACLRPM_to_600_or_700_RPM_provides_an_earlier_anti-stall_safety_net,_which_is_highly_recommended_for_lightweight_flywheel_installations,_aggressive_camshafts_with_low_idle_vacuum,_or_manual_transmission_conversions_where_sudden_RPM_dips_occur_when_coming_to_a_quick_stop.
    .word 0x0FA0                     ;Point 1

	;.org	0x870a
ACOUT_DeltaAboveMinThrottleToCutOutAc:
    ;mpgrp 7_-_Aux_Functions\AC_Control\
    ;mptbladdr 0x1646
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaAboveMinThrottleToCutOutAc
    ;mptblcname ACOUT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACOUT_defines_the_throttle_position_sensor_voltage_delta_above_learned_closed_throttle_(MINTHR)_that_disengages_the_air_conditioning_compressor_clutch_during_heavy_acceleration._Lowering_ACOUT_to_approximately_90_to_100_counts_(~1.8_to_2.0_Volts_above_MINTHR_/_~50%_throttle)_disengages_the_A/C_compressor_earlier_during_moderate_acceleration.
    .byte 0x85                       ;Point 1

	;.org	0x870b
ACCRPM_DoNotAllowAcToEngageAboveThisRPM_4000:
    ;mpgrp 7_-_Aux_Functions\AC_Control\
    ;mptbladdr 0x1653
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DoNotAllowAcToEngageAboveThisRPM_4000
    ;mptblcname ACCRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACCRPM_defines_the_maximum_engine_speed_lockout_threshold_for_air_conditioning_compressor_clutch_engagement._Never_raise_ACCRPM_above_4500_RPM._On_modified_turbocharged_engines_built_for_high_engine_speeds_(6000_to_7000+_RPM),_ACCRPM_provides_essential_mechanical_protection_for_the_compressor_clutch_and_accessory_drive_belt._Lowering_ACCRPM_to_3500_RPM_reduces_mechanical_strain_on_aged_factory_compressors_during_highway_driving.
    .word 0x7D00                     ;Point 1

	;.org	0x870d
ACCTIM_AcDelayFromStartRunTransfer:
    ;mpgrp 7_-_Aux_Functions\AC_Control\
    ;mptbladdr 0x1660
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcDelayFromStartRunTransfer
    ;mptblcname ACCTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACCTIM_defines_the_post-start_time_delay_enforced_after_the_engine_transitions_into_run_mode_before_the_controller_allows_the_air_conditioning_compressor_clutch_to_engage._Raising_ACCTIM_to_1.0_or_2.0_seconds_(10_to_20_counts)_gives_modified_engines_with_large_fuel_injectors,_lightweight_flywheels,_or_low-vacuum_camshafts_extra_time_to_settle_into_a_stable_idle_after_starting_before_absorbing_compressor_load.
    .byte 0x04                       ;Point 1

	;.org	0x870e
WOTDLT_DeltaThrottleFrom_MINTHR_ToDetermineFullThrottle:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x166D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaThrottleFrom_MINTHR_ToDetermineFullThrottle
    ;mptblcname WOTDLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc WOTDLT_defines_the_throttle_position_sensor_voltage_delta_required_to_command_wide-open_throttle_mode._Tuners_modify_WOTDLT_to_customize_how_early_wide-open_throttle_power_enrichment_and_maximum_turbocharger_boost_engage_during_pedal_travel.
    .byte 0x85                       ;Point 1

	;.org	0x870f
UNLOAD_DeltaThrottleFrom_MINTHR_ToUnloadCrankingFuel:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x167A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaThrottleFrom_MINTHR_ToUnloadCrankingFuel
    ;mptblcname UNLOAD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc UNLOAD_establishes_the_throttle_position_sensor_delta_threshold_that_activates_clear-flood_mode_during_engine_cranking._Tuners_typically_leave_UNLOAD_matched_to_WOTDLT._If_retrofitting_an_aftermarket_throttle_body_with_non-standard_linkage_geometry_where_wide-open_throttle_yields_lower_total_sensor_voltage_swing,_verify_that_flooring_the_pedal_delivers_enough_voltage_delta_to_exceed_UNLOAD.
    .byte 0x85                       ;Point 1

	;.org	0x8710
VACREG_CruiseControlVacRegularGainGurve_FromDeltaSpeed:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1687
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlVacRegularGainGurve_FromDeltaSpeed
    ;mptblcname VACREG
    ;mpxaxis Delta_Speed 0 127.5 mph
    ;mpyaxis AccRate 0 5 mph/sec
    ;mptbldesc VACREG_defines_the_primary_proportional_vacuum_servo_gain_curve_utilized_during_steady-state_cruising_when_road_speed_falls_below_the_target_setting._Increasing_the_slope_or_upper_values_of_VACREG_commands_larger_vacuum_pulses_for_a_given_speed_deficit,_making_the_cruise_control_react_more_aggressively_when_encountering_uphill_grades_and_preventing_highway_speed_sag.
    .byte 0x05                       ;Number of points in table
    .byte 0x00, 0x00, 0x00, 0x33     ;Point 1
    .byte 0x0A, 0x02, 0x00, 0x09     ;Point 2
    .byte 0x40, 0x04, 0x00, 0x08     ;Point 3
    .byte 0x80, 0x06, 0x00, 0x14     ;Point 4
    .byte 0xFF, 0x10                 ;Point 5

	;.org	0x8727
VACACC_CruiseControlVacAcceleratedGainCurve_FromDeltaSpeed:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1699
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlVacAcceleratedGainCurve_FromDeltaSpeed
    ;mptblcname VACACC
    ;mpxaxis Delta_Speed 0 127.5 mph
    ;mpyaxis AccRate 0 5 mph/sec
    ;mptbldesc VACACC_establishes_the_high-authority_accelerated_vacuum_servo_gain_curve_deployed_when_large_speed_deficits_occur_or_when_the_driver_engages_the_resume_function._Increasing_VACACC_values_sharpens_resume_acceleration,_reducing_the_elapsed_time_required_to_pull_the_vehicle_back_to_cruising_speed_after_slowing_down_for_highway_traffic_or_toll_plazas._If_resuming_feels_sluggish_or_unresponsive,_raising_this_curve_provides_firmer_throttle_engagement.
    .byte 0x02                       ;Number of points in table
    .byte 0x00, 0x02, 0x00, 0x2E     ;Point 1
    .byte 0xFF, 0x30                 ;Point 2

	;.org	0x873e
VENTRG_CruiseControlVentRegularGainCurve_FromDeltaSpeed:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x16A8
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlVentRegularGainCurve_FromDeltaSpeed
    ;mptblcname VENTRG
    ;mpxaxis Delta_Speed 0 127.5 mph
    ;mpyaxis AccRate 0 5 mph/sec
    ;mptbldesc VENTRG_defines_the_proportional_vent_solenoid_gain_curve_utilized_when_vehicle_speed_exceeds_the_target_cruise_setting._When_descending_highway_grades_or_following_an_acceleration_event,_gravity_or_residual_engine_power_causes_road_speed_to_climb_above_the_setpoint._Increasing_VENTRG_gain_causes_the_cruise_system_to_bleed_vacuum_more_aggressively_when_cresting_hills_or_descending_highway_slopes,_mitigating_downhill_speed_creep.
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x00, 0xFF, 0xFB     ;Point 1
    .byte 0x66, 0xFE, 0xFF, 0xEF     ;Point 2
    .byte 0xFF, 0xF4                 ;Point 3

	;.org	0x874d
SETPW_CruiseControlSetupPulseForSet_FromSpeed:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x16B8
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlSetupPulseForSet_FromSpeed
    ;mptblcname SETPW
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis Vacuum 0 2.8 Pulsewidth
    ;mptbldesc SETPW_defines_the_initial_vacuum_setup_pulse_duration_applied_to_the_cruise_servo_the_instant_the_driver_presses_the_set_switch._If_releasing_the_gas_pedal_immediately_after_pressing_the_set_switch_causes_the_vehicle_to_momentarily_sag_or_lose_1_to_2_mph_before_the_servo_catches,_increase_SETPW_at_that_speed_range_to_command_a_longer_pre-charge_pulse.
    .byte 0x03                       ;Number of points in table
    .byte 0x46, 0x24, 0x00, 0x40     ;Point 1
    .byte 0x82, 0x33, 0x00, 0x50     ;Point 2
    .byte 0xFF, 0x5A                 ;Point 3

	;.org	0x875c
RESTBL_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x16C8
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference
    ;mptblcname RESTBL
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis AbsMAP 0 29.4 psi
    ;mptbldesc RESTBL_defines_the_manifold_absolute_pressure_compensation_curve_applied_to_the_cruise_setup_pulse_during_set_and_resume_engagement._The_rate_at_which_the_cruise_servo_bellows_fills_with_vacuum_depends_heavily_on_available_engine_intake_manifold_vacuum._On_turbocharged_applications_or_vehicles_equipped_with_aggressive_performance_camshafts_with_reduced_idle_vacuum,_available_manifold_vacuum_during_highway_cruise_may_be_lower_than_stock.
    ;mpmapaxis y
    .byte 0x06                       ;Number of points in table
    .byte 0x13, 0x80, 0x00, 0x00     ;Point 1
    .byte 0x53, 0x80, 0x00, 0x6E     ;Point 2
    .byte 0x6F, 0x8C, 0x02, 0x33     ;Point 3
    .byte 0x79, 0xA2, 0x00, 0x00     ;Point 4
    .byte 0x9A, 0xA2, 0xFD, 0x40     ;Point 5
    .byte 0xA2, 0x8C                 ;Point 6

	;.org	0x8773
RESTBL2_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference2:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x16DC
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference2
    ;mptblcname RESTBL2
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis Vacuum 0 2.8 Pulsewidth
    ;mptbldesc RESTBL2_defines_the_secondary_resume_setup_pulse_duration_added_directly_to_the_cruise_servo_command_based_on_the_difference_between_current_vehicle_speed_and_the_saved_target_setpoint._Increasing_RESTBL2_values_delivers_a_sharper,_more_immediate_throttle_opening_when_the_driver_presses_the_resume_button_from_low_speeds,_eliminating_hesitation_or_lag_before_acceleration_begins.
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x00, 0x00, 0x80     ;Point 1
    .byte 0x14, 0x0A, 0x00, 0x1C     ;Point 2
    .byte 0x6E, 0x14                 ;Point 3

	;.org	0x8786
THGAIN_CruiseControlThrottleGainFactor_FromThrottle:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x16EC
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlThrottleGainFactor_FromThrottle
    ;mptblcname THGAIN
    ;mpxaxis TPS 0 255 tps
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc THGAIN_provides_a_progressive_throttle_position_gain_correction_factor_applied_to_the_cruise_servo_command_based_on_throttle_opening_angle_above_idle._When_upgrading_to_larger_aftermarket_throttle_bodies_(such_as_52mm_or_58mm_units),_airflow_per_degree_of_throttle_rotation_increases_significantly._Leaving_THGAIN_at_stock_levels_with_an_oversized_throttle_body_produces_twitchy,_nervous_cruise_operation_and_throttle_hunting.
    .byte 0x02                       ;Number of points in table
    .byte 0x00, 0x08, 0x00, 0x00     ;Point 1
    .byte 0x11, 0x20                 ;Point 2

	;.org	0x8795
SPGAIN_CruiseControlSpeedGainFactor_FromSpeed:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x16FB
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlSpeedGainFactor_FromSpeed
    ;mptblcname SPGAIN
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc SPGAIN_establishes_the_vehicle_road_speed_gain_correction_factor_that_scales_cruise_servo_responsiveness_as_a_function_of_road_speed._If_the_cruise_control_holds_speed_crisply_around_town_at_45_mph_but_feels_sluggish,_soft,_or_drops_speed_on_highway_hills_at_70_to_75_mph,_increase_the_higher_speed_values_in_SPGAIN_to_deliver_more_servo_authority_at_elevated_highway_speeds.
    .byte 0x03                       ;Number of points in table
    .byte 0x3C, 0x14, 0xFF, 0x9A     ;Point 1
    .byte 0x6E, 0x00, 0x00, 0x9A     ;Point 2
    .byte 0xAA, 0x24                 ;Point 3

	;.org	0x87a4
VNTAB1_CruiseControlLimitToAMaxVent:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x170B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlLimitToAMaxVent
    ;mptblcname VNTAB1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc VNTAB1_defines_the_maximum_overspeed_error_threshold_above_which_the_cruise_control_system_bypasses_proportional_vent_curve_calculations_and_forces_continuous_maximum_vent_solenoid_pulse_duration._The_factory_setting_of_255_counts_effectively_disables_the_forced_full-vent_override_under_normal_conditions,_ensuring_that_the_proportional_vent_curve_controls_deceleration_smoothly_across_all_realistic_road_speeds.
    .byte 0xFF                       ;Point 1

	;.org	0x87a5
VNTAB2_CruiseControlLimitToHalfMaxVent:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1718
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlLimitToHalfMaxVent
    ;mptblcname VNTAB2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc VNTAB2_defines_the_intermediate_overspeed_error_threshold_for_commanding_a_fixed_half-maximum_vent_pulse_duration._Lowering_VNTAB2_provides_a_stepped_intermediate_vent_response_during_moderate_overspeed_situations,_allowing_the_cruise_controller_to_arrest_downhill_acceleration_before_vehicle_speed_runs_away.
    .byte 0xA0                       ;Point 1

	;.org	0x87a6
SETIME_CruiseControlNoSetupPulseWhenDecelTimerAboveThis:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1725
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlNoSetupPulseWhenDecelTimerAboveThis
    ;mptblcname SETIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SETIME_defines_the_deceleration_elapsed_timer_threshold_for_suppressing_or_modifying_the_vacuum_setup_pre-charge_pulse_when_the_driver_releases_the_coast_button._When_holding_down_the_coast_or_decelerate_switch,_the_cruise_servo_vents_and_the_vehicle_slows_down._The_factory_setting_of_55_counts_(approximately_0.61_seconds)_provides_balanced_switch_debounce_and_deceleration_transition_timing.
    .byte 0x37                       ;Point 1

	;.org	0x87a7
SETIM1_CruiseControlNoSetupPulseWhenDecelTimerBelowThis:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1732
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlNoSetupPulseWhenDecelTimerBelowThis
    ;mptblcname SETIM1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SETIM1_defines_the_upper_timer_qualification_boundary_paired_with_SETIME_to_establish_a_precise_deceleration_pulse_suppression_window._When_the_driver_presses_the_coast_switch,_the_deceleration_timer_increments._SETIM1_governs_the_transition_between_moderate_coast-down_and_extended_coasting._Retain_the_factory_value_of_82_counts_in_virtually_all_calibrations.
    .byte 0x52                       ;Point 1

	;.org	0x87a8
ACLRST_CruiseControlDeltaSpeedToResetAccFlag:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x173F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlDeltaSpeedToResetAccFlag
    ;mptblcname ACLRST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACLRST_defines_the_vehicle_speed_deficit_threshold_below_which_the_accelerated_cruise_mode_flag_is_cleared,_returning_the_cruise_servo_loop_from_high-gain_VACACC_to_standard_VACREG_operation._Raising_ACLRST_(for_example,_to_14_to_18_counts,_representing_7_to_9_miles_per_hour)_clears_the_accelerated_cruise_flag_earlier_during_acceleration,_providing_a_gentler_transition_into_steady-state_cruise_and_eliminating_target_speed_overshoot.
    .byte 0x09                       ;Point 1

	;.org	0x87a9
CLOTHR_CruiseControlDontVentIfThrottleBelowThis:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x174C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlDontVentIfThrottleBelowThis
    ;mptblcname CLOTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CLOTHR_defines_the_closed-throttle_angle_threshold_below_which_the_cruise_vent_solenoid_is_completely_inhibited_from_pulsing._When_vehicle_speed_climbs_above_the_setpoint_going_down_a_hill,_the_cruise_controller_commands_the_vent_solenoid_to_bleed_vacuum_and_close_the_throttle._The_factory_setting_of_1_count_above_lowest_session_idle_TPS_ensures_that_venting_ceases_the_instant_the_throttle_plate_returns_to_rest.
    .byte 0x03                       ;Point 1

	;.org	0x87aa
MAXTHR_CruiseControlDontVacIfThrottleAboveThis:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1759
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlDontVacIfThrottleAboveThis
    ;mptblcname MAXTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MAXTHR_defines_the_maximum_throttle_position_ceiling_above_which_the_cruise_control_vacuum_solenoid_is_blocked_from_applying_further_vacuum._Cruise_control_is_engineered_solely_for_maintaining_highway_cruising_speed_under_moderate_load,_not_for_wide-open_throttle_acceleration._In_mountainous_terrain_or_when_towing,_vehicles_may_lose_speed_on_steep_interstate_grades_because_the_cruise_system_stops_pulling_when_throttle_opening_reaches_31_percent.
    .byte 0x50                       ;Point 1

	;.org	0x87ab
MAXSET_CruiseControlMaxSetSpeedTimesTwo:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1766
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlMaxSetSpeedTimesTwo
    ;mptblcname MAXSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 127.5 mph
    ;mptbldesc MAXSET_establishes_the_maximum_vehicle_road_speed_setpoint_permitted_for_cruise_control_engagement._Operating_cruise_control_at_excessive_vehicle_velocities_presents_serious_safety_risks_and_exceeds_federal_motor_vehicle_safety_standards._In_states_where_highway_speed_limits_reach_80_miles_per_hour,_drivers_desiring_to_cruise_at_80_to_90_miles_per_hour_can_raise_MAXSET_to_180_counts_(90_miles_per_hour)_or_190_counts_(95_miles_per_hour).
    .byte 0xAA                       ;Point 1

	;.org	0x87ac
MINSET_CruiseControlMinSetSpeedTimesTwo:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1773
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlMinSetSpeedTimesTwo
    ;mptblcname MINSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 127.5 mph
    ;mptbldesc MINSET_defines_the_minimum_vehicle_road_speed_threshold_required_for_cruise_control_engagement._Lowering_MINSET_to_60_counts_(30_miles_per_hour)_allows_cruise_control_to_be_utilized_on_slower_rural_roads_and_secondary_highways,_matching_Stage_IV_and_early_LM_calibration_behavior._Never_lower_MINSET_below_50_counts_(25_miles_per_hour),_as_cruise_servo_authority_is_poorly_suited_to_low-speed_stop-and-go_driving_and_poses_safety_concerns.
    .byte 0x46                       ;Point 1

	;.org	0x87ad
SCNVHI_CruiseControlForBrakeFlagManualTransmissionClutchDisable:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1780
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlForBrakeFlagManualTransmissionClutchDisable_Hi
    ;mptblcname SCNVHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SCNVHI_defines_the_upper_gear_ratio_threshold_for_manual_transmission_clutch_pedal_disengagement_and_clutch_slip_detection._SCNVHI_is_a_vital_safety_setting_for_manual_transmission_vehicles_that_lack_a_dedicated_clutch_pedal_cruise_cutout_switch.
    .byte 0xF1                       ;Point 1

	;.org	0x87ae
SCNVLO_CruiseControlForBrakeFlagManualTransmissionClutchDisable:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x178D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlForBrakeFlagManualTransmissionClutchDisable_Lo
    ;mptblcname SCNVLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SCNVLO_defines_the_lower_gear_ratio_threshold_for_manual_transmission_clutch_disengagement_and_downshift_cutout_detection._Retain_the_factory_setting_of_82_counts_for_stock_manual_transaxles_(A520,_A523,_A555,_A568)._If_swapping_transaxles_or_installing_custom_close-ratio_gear_sets_where_4th_gear_produces_a_lower_speed-to-RPM_product,_verify_that_the_calculated_ratio_in_4th_gear_remains_safely_above_SCNVLO.
    .byte 0x52                       ;Point 1

	;.org	0x87af
LOSPCO_CruiseControlLowSpeedCutoutSpeed:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x179A
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname CruiseControlLowSpeedCutoutSpeed
    ;mptblcname LOSPCO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LOSPCO_defines_the_absolute_low-speed_safety_cutout_threshold_below_which_active_cruise_control_will_automatically_disengage_and_vent_the_servo._LOSPCO_is_a_primary_safety_cutout_mechanism_and_should_never_be_disabled._Lowering_LOSPCO_to_1600_counts_(25_miles_per_hour)_matches_Stage_IV_and_early_LM_calibration_parameters,_permitting_cruise_control_to_remain_engaged_down_to_25_miles_per_hour_on_secondary_roads_without_dropping_out.
    .word 0x0780                     ;Point 1

	;.org	0x87b1
CRSVAR_CruiseControlVariableAdd:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x17A7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlVariableAdd
    ;mptblcname CRSVAR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CRSVAR_defines_the_variable_feedforward_addition_value_applied_during_tap-up_speed_adjustment._The_factory_setting_of_3_counts_provides_balanced_feedforward_authority_for_smooth_2_miles_per_hour_speed_steps._If_tapping_the_resume_switch_causes_sluggish_speed_increases_where_the_vehicle_takes_several_seconds_to_begin_accelerating,_raising_CRSVAR_to_4_or_5_counts_sharpens_initial_tap-up_response.
    .byte 0x02                       ;Point 1

	;.org	0x87b2
VACTIM_CruiseControlVacuumTime:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x17B4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlVacuumTime
    ;mptblcname VACTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc VACTIM_defines_the_minimum_vacuum_solenoid_pulse_duration_mask_applied_whenever_the_cruise_controller_commands_throttle_opening._The_factory_setting_of_1_count_matches_OEM_Chrysler_cruise_solenoids._If_aging,_stiff,_or_aftermarket_vacuum_solenoids_fail_to_respond_to_minor_cruise_corrections,_raising_VACTIM_to_2_counts_increases_minimum_pulse_duration_to_break_through_valve_stiction.
    .byte 0x01                       ;Point 1

	;.org	0x87b3
SETDLT_CruiseControlSetDeltaControlPointForCableAdaptive:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x17C1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlSetDeltaControlPointForCableAdaptive
    ;mptblcname SETDLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SETDLT_defines_the_calibration_offset_bias_added_to_speed_error_during_evaluation_of_the_throttle_cable_adaptive_delta_variable._In_Chrysler_SMEC_engine_management,_the_cruise_controller_continuously_monitors_mechanical_throttle_linkage_compliance_and_cable_stretch_by_calculating_the_difference_between_commanded_speed_and_measured_vehicle_velocity._Retain_the_factory_setting_of_0_counts_in_all_standard_vehicle_applications.
    .byte 0x01                       ;Point 1

	;.org	0x87b4
CRMSK2_CruiseMask2:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x17CE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask2
    ;mptblcname CRMSK2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CRMSK2_defines_the_positive_accumulated_servo_error_threshold_for_incrementing_the_adaptive_integrator_trim._Raising_CRMSK2_increases_the_speed_deficit_that_must_accumulate_before_the_long-term_integrator_begins_adding_throttle_trim,_which_can_be_useful_on_undulating_roads_to_prevent_the_integrator_from_reacting_to_temporary_dips.
    .byte 0x14                       ;Point 1

	;.org	0x87b5
CRMSK3_CruiseMask3:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x17DB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask3
    ;mptblcname CRMSK3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CRMSK3_defines_the_negative_accumulated_servo_error_threshold_for_decrementing_the_adaptive_integrator_trim._CRMSK3_prevents_the_cruise_controller_from_maintaining_unnecessary_throttle_opening_after_cresting_a_hill._Setting_CRMSK3_closer_to_zero_(for_example,_negative_6_to_negative_8_counts)_causes_the_integrator_to_shed_learned_throttle_trim_earlier_on_descents,_preventing_downhill_speed_buildup.
    .byte 0xEC                       ;Point 1

	;.org	0x87b6
CRMSK7_CruiseMask7:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x17E8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask7
    ;mptblcname CRMSK7
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CRMSK7_defines_the_step_increment_added_to_the_adaptive_integrator_trim_when_accumulated_servo_error_exceeds_CRMSK2._The_factory_setting_of_1_count_ensures_smooth,_imperceptible_throttle_adjustments_during_long_highway_climbs._Raising_CRMSK7_to_2_counts_accelerates_the_rate_at_which_the_cruise_system_learns_extra_throttle_authority,_which_benefits_heavy_vehicles_towing_trailers_on_mountainous_interstates.
    .byte 0x02                       ;Point 1

	;.org	0x87b7
CRMSK4_CruiseMask4:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x17F5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask4
    ;mptblcname CRMSK4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CRMSK4_defines_the_step_decrement_subtracted_from_the_adaptive_integrator_trim_when_accumulated_servo_error_is_below_CRMSK3._When_cresting_a_highway_hill,_the_extra_throttle_opening_learned_during_the_climb_is_no_longer_needed._The_factory_setting_of_2_counts_provides_prompt_shedding_of_learned_throttle_trim,_ensuring_that_vehicle_speed_settles_cleanly_without_sustained_overspeed_when_descending_hilltops.
    .byte 0x02                       ;Point 1

	;.org	0x87b8
CRMSK6_CruiseMask6:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1802
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask6
    ;mptblcname CRMSK6
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CRMSK6_defines_the_positive_clamp_ceiling_for_the_adaptive_integrator_trim._The_factory_ceiling_of_30_counts_provides_sufficient_long-term_authority_to_maintain_speed_on_standard_interstate_grades_while_preventing_excessive_integrator_accumulation._On_heavily_loaded_vehicles_or_vehicles_with_tall_overdrive_gearing_climbing_long_mountain_passes,_raising_CRMSK6_to_40_or_45_counts_provides_more_sustained_throttle_opening.
    .byte 0x13                       ;Point 1

	;.org	0x87b9
CRMSK5_CruiseMask5:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x180F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask5
    ;mptblcname CRMSK5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CRMSK5_defines_the_negative_clamp_floor_for_the_adaptive_integrator_trim._The_factory_setting_of_negative_30_counts_provides_balanced_negative_trim_authority_without_stalling_throttle_recovery_when_leveling_out_after_a_long_downhill_descent._Retain_CRMSK5_at_factory_setting_in_virtually_all_calibrations._If_modifying_CRMSK6,_adjust_CRMSK5_symmetrically_to_maintain_balanced_bidirectional_integrator_bounds.
    .byte 0xEC                       ;Point 1

	;.org	0x87ba
CRSCN1_CruiseComapreConstant1:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x181C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseComapreConstant1
    ;mptblcname CRSCN1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CRSCN1_defines_the_evaluation_interval_timer_threshold_determining_how_frequently_adaptive_servo_integration_and_cable_slack_updates_occur._CRSCN1_establishes_the_update_frequency_of_the_cruise_control_adaptive_integrator._Raising_CRSCN1_lengthens_the_interval_between_integrator_adjustments,_stabilizing_response_on_undulating_roads_and_preventing_the_cruise_system_from_chasing_momentary_speed_variations.
    .byte 0x15                       ;Point 1

	;.org	0x87bb
CRMASK_CruiseMask:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1829
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseMask
    ;mptblcname CRMASK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CRMASK_defines_the_startup_delay_count_and_reset_mask_applied_to_Counter_Cruise_when_cruise_control_is_freshly_engaged._The_factory_setting_of_17_counts_provides_proper_mechanical_stabilization_following_engagement._Retain_CRMASK_at_17_counts_in_all_calibrations.
    .byte 0x10                       ;Point 1

	;.org	0x87bc
CRSCN2_CruiseComapreConstant2:
    ;mpgrp 7_-_Aux_Functions\Cruise_Control\
    ;mptbladdr 0x1836
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseComapreConstant2
    ;mptblcname CRSCN2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CRSCN2_defines_the_speed_error_deadband_threshold_for_the_cable_adaptive_delta_variable._The_factory_setting_of_6_counts_(approx_3.0_miles_per_hour)_provides_excellent_balance_between_speed-holding_precision_and_solenoid_life._Lowering_CRSCN2_to_3_or_4_counts_tightens_speed_tracking,_forcing_the_cruise_system_to_correct_smaller_speed_variations,_though_it_can_induce_subtle_throttle_pedal_flutter_on_rough_pavement.
    .byte 0x06                       ;Point 1

PTUMTP_PTUMinLockTemperature:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Entry_Conditions\
    ;mptbladdr 0x1842
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUMinLockTemperature
    ;mptblcname PTUMTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc PTUMTP_defines_the_minimum_engine_coolant_temperature_threshold_required_to_permit_Part_Throttle_Unlock_(PTU)_torque_converter_clutch_modulation._Raising_PTUMTP_delays_torque_converter_clutch_modulation_until_higher_coolant_temperatures_are_reached_(such_as_160_°F_or_170_°F),_which_protects_transmission_clutch_linings_and_ensures_smooth_shift_feel_during_cold_morning_warm-up.
    .byte 0xC1                       ;Point 1

PTUMSP_PTUMinLockSpeed:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Entry_Conditions\
    ;mptbladdr 0x184E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUMinLockSpeed
    ;mptblcname PTUMSP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 127.5 mph
    ;mptbldesc PTUMSP_defines_the_vehicle_speed_boundary_that_splits_the_Part_Throttle_Unlock_control_logic_between_low-speed_city_operation_and_high-speed_highway_cruising._Raising_PTUMSP_extends_low-speed_PTU_behavior_up_to_higher_vehicle_speeds_(e.g._50_to_55_MPH),_which_forces_the_torque_converter_to_remain_firmly_locked_against_throttle_modulation_until_higher_cruising_speeds_are_achieved.
    .byte 0x5A                       ;Point 1

PTUCNH_PTUCounterHiSpeed:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Hysteresis\
    ;mptbladdr 0x185A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUCounterHiSpeed
    ;mptblcname PTUCNH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc PTUCNH_defines_the_high-speed_debounce_counter_reload_value_for_Part_Throttle_Unlock_state_transitions._Raising_PTUCNH_increases_the_stabilization_delay_required_to_change_torque_converter_lockup_state_at_highway_speeds,_creating_a_firm,_deliberate_lockup_feel_that_resists_hunting_during_gentle_pedal_adjustments_on_highway_hills.
    .byte 0x5D                       ;Point 1

PTUCNL_PTUCounterLoSpeed:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Hysteresis\
    ;mptbladdr 0x1866
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUCounterLoSpeed
    ;mptblcname PTUCNL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc PTUCNL_defines_the_low-speed_debounce_counter_reload_value_for_Part_Throttle_Unlock_state_transitions._Raising_PTUCNL_provides_a_longer_delay_before_the_torque_converter_is_allowed_to_change_state_at_low_speeds,_preventing_erratic_lockup_cycling_in_stop-and-go_city_traffic._Lowering_PTUCNL_allows_the_torque_converter_to_unlock_more_rapidly_when_accelerating_from_a_slow_roll,_giving_a_punchier,_more_responsive_low-speed_throttle_feel.
    .byte 0x5D                       ;Point 1

PTUDTP_PTUDeltaTPSForUnlock:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Hysteresis\
    ;mptbladdr 0x1872
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUDeltaTPSForUnlock
    ;mptblcname PTUDTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Delta_TPS 0 5 V
    ;mptbldesc PTUDTP_defines_the_throttle_position_sensor_voltage_delta_threshold_used_to_classify_throttle_application_as_either_gentle_or_aggressive_in_the_Part_Throttle_Unlock_system._Raising_PTUDTP_broadens_the_range_of_throttle_input_treated_as_gentle_cruising,_keeping_the_secondary_threshold_PTUMP2_active_across_a_larger_pedal_travel_range.
    .byte 0x34                       ;Point 1

PTUMP1_PTUMAPThresholdForLock1:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Entry_Conditions\
    ;mptbladdr 0x187E
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname PTUMAPThresholdForLock1
    ;mptblcname PTUMP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Delta_MAP 0 29.4 PSI
    ;mptbldesc PTUMP1_defines_the_primary_manifold_pressure_delta_threshold_for_Part_Throttle_Unlock_lockup_enforcement_under_moderate-to-heavy_throttle_modulation._When_upgrading_to_a_3-bar_MAP_sensor,_PTUMP1_must_be_rescaled_to_match_the_expanded_pressure_range._On_a_3-bar_sensor,_13.8_psi_delta_corresponds_to_approximately_80_counts_on_the_44.1_psi_scale.
    ;mpmapaxis y
    .byte 0x78                       ;Point 1

PTUMP2_PTUMAPThresholdForLock2:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Entry_Conditions\
    ;mptbladdr 0x188B
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname PTUMAPThresholdForLock2
    ;mptblcname PTUMP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis deltaMAP 0 29.4 psi
    ;mptbldesc PTUMP2_defines_the_secondary_manifold_absolute_pressure_delta_threshold_for_Part_Throttle_Unlock_lockup_enforcement_under_gentle_throttle_modulation._In_the_assembly_source,_PTUMP2_is_stored_immediately_following_PTUMP1_in_ROM_and_is_accessed_via_an_indexed_increment_(inx)_off_base_pointer_PTUMP1_PTUMAPThresholdForLock1._In_3-bar_MAP_sensor_installations,_PTUMP2_must_be_rescaled_to_match_the_expanded_sensor_span_(~57_counts_on_3-bar).
    ;mpmapaxis y
    .byte 0x56                       ;Point 1

PTUMP3_PTUMAPThresholdForLock3:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Entry_Conditions\
    ;mptbladdr 0x1898
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname PTUMAPThresholdForLock3
    ;mptblcname PTUMP3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Delta_MAP 0 29.4 PSI
    ;mptbldesc PTUMP3_defines_the_immediate_manifold_pressure_spike_threshold_for_low-speed_Part_Throttle_Unlock_lockup_engagement._PTUMP3_must_be_rescaled_when_converting_to_a_3-bar_MAP_sensor_(~80_counts_on_3-bar_scale)._Raising_PTUMP3_requires_more_aggressive_throttle_input_to_trigger_immediate_low-speed_lockup,_allowing_the_torque_converter_to_slip_and_multiply_torque_longer_during_brisk_low-speed_acceleration.
    ;mpmapaxis y
    .byte 0x78                       ;Point 1

PTUCNI_PTUCounterTimerIntervalForLoop:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\Entry_Conditions\
    ;mptbladdr 0x18A5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PTUCounterTimerIntervalForLoop
    ;mptblcname PTUCNI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc PTUCNI_defines_the_loop_execution_decimation_bitmask_for_the_Part_Throttle_Unlock_control_routine._Retain_the_factory_setting_of_7_counts_for_PTUCNI._Modifying_this_bitmask_alters_the_time_duration_between_manifold_pressure_baseline_updates,_which_directly_distorts_all_downstream_MAP_delta_calculations_(PTUMP1,_PTUMP2,_and_PTUMP3).
    .byte 0x07                       ;Point 1

PTUUUL_UpperLimitForPTUUnlock:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\TPS_Limits_for_Lockup\
    ;mptbladdr 0x18B1
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname UpperLimitForPTUUnlock
    ;mptblcname PTUUUL
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis Delta_TPS 0 5 Volts
    ;mptbldesc PTUUUL_defines_the_upper_throttle_position_sensor_delta_threshold_curve_as_a_function_of_vehicle_speed_when_the_torque_converter_is_currently_in_the_unlocked_state._Raising_points_in_PTUUUL_allows_the_driver_to_apply_more_throttle_before_the_torque_converter_is_forced_to_lock_up,_keeping_the_converter_unlocked_longer_for_improved_acceleration,_lower-gear_torque_multiplication,_and_crisper_passing_response.
    .byte 0x04                       ;Number of points in table
    .byte 0x44, 0x04, 0x09, 0x40     ;Point 1
    .byte 0x48, 0x29, 0x00, 0xAB     ;Point 2
    .byte 0x5A, 0x35, 0x0A, 0xCD     ;Point 3
    .byte 0x64, 0xA1                 ;Point 4

PTUULL_LowerLimitForPTUUnlock:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\TPS_Limits_for_Lockup\
    ;mptbladdr 0x18C1
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname LowerLimitForPTUUnlock
    ;mptblcname PTUULL
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis Delta_TPS 0 5 Volts
    ;mptbldesc PTUULL_defines_the_lower_throttle_position_sensor_delta_threshold_curve_as_a_function_of_vehicle_speed_when_the_torque_converter_is_currently_in_the_unlocked_state._Raising_PTUULL_narrows_the_unlocked_throttle_deadband,_requiring_higher_minimum_throttle_to_maintain_unlocked_operation._Lowering_PTUULL_broadens_the_unlocked_operating_window,_keeping_the_converter_unlocked_during_closed-throttle_coasting_or_very_light_pedal_modulation.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x04                 ;Point 1

PTULUL_UpperLimitForPTULock:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\TPS_Limits_for_Lockup\
    ;mptbladdr 0x18CE
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname UpperLimitForPTULock
    ;mptblcname PTULUL
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis Delta_TPS 0 5 Volts
    ;mptbldesc PTULUL_defines_the_upper_throttle_position_sensor_delta_threshold_curve_as_a_function_of_vehicle_speed_when_the_torque_converter_is_currently_in_the_locked_state._To_prevent_rapid_torque_converter_clutch_cycling,_the_controller_evaluates_separate_threshold_tables_depending_on_current_clutch_state._Raising_points_in_PTULUL_keeps_the_torque_converter_locked_under_heavier_throttle_application_before_allowing_it_to_unlock.
    .byte 0x04                       ;Number of points in table
    .byte 0x48, 0x06, 0x06, 0x80     ;Point 1
    .byte 0x4C, 0x20, 0x00, 0x80     ;Point 2
    .byte 0x6E, 0x31, 0x0B, 0x33     ;Point 3
    .byte 0x78, 0xA1                 ;Point 4

PTULLL_LowerLimitForPTULock:
    ;mpgrp 7_-_Aux_Functions\PTU_Control\TPS_Limits_for_Lockup\
    ;mptbladdr 0x18DE
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname LowerLimitForPTULock
    ;mptblcname PTULLL
    ;mpxaxis Speed 0 127.5 mph
    ;mpyaxis Delta_TPS 0 5 Volts
    ;mptbldesc PTULLL_defines_the_lower_throttle_position_sensor_delta_threshold_curve_as_a_function_of_vehicle_speed_when_the_torque_converter_is_currently_in_the_locked_state._Paired_with_PTULUL,_PTULLL_establishes_the_lower_boundary_of_the_locked-state_throttle_deadband._Adjusting_PTULLL_sets_the_lower_boundary_for_locked-state_operation._Raising_PTULLL_narrows_the_locked_deadband,_causing_the_converter_to_unlock_at_higher_closed-throttle_decel_speeds.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x06                 ;Point 1

STGSWS_StagingLimiterEnableSwitch:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Launch_Control\Launch_Control_Enable\
    ;mptbladdr 0x18EB
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname StagingLimiterEnableSwitch
    ;mptblcname STGSWS
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc STGSWS_defines_the_digital_input_switch_bitmask_used_to_arm_the_launch_control_staging_limiter._Choose_the_switch_input_that_matches_your_vehicle_wiring._For_manual_transmission_drag_cars,_wiring_a_momentary_switch_or_clutch_interlock_switch_to_the_Brake_Switch_or_Speed_Control_On/Off_input_allows_launch_control_to_activate_only_when_the_clutch_pedal_is_fully_depressed_to_the_floor.
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
    ;mptbladdr 0x1901
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StageLimiterCutoffSpeed
    ;mptblcname STGSPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 255 mph
    ;mptbldesc STGSPD_defines_the_vehicle_speed_cutoff_threshold_above_which_launch_control_is_completely_disengaged._Set_STGSPD_between_5_mph_and_15_mph_depending_on_vehicle_drivetrain_and_tire_setup._For_front-wheel-drive_or_high-traction_drag_cars,_5_to_10_mph_provides_crisp,_immediate_disengagement_as_soon_as_the_tires_roll_out_of_the_staging_beams.
    .byte 0x0A                       ;Point 1

STGTPS_StageLimiterMinTPS:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Launch_Control\Launch_Control_Entry_Conditions\
    ;mptbladdr 0x190D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StageLimiterMinTPS
    ;mptblcname STGTPS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis TPSOverMINTHR 0 5 volts
    ;mptbldesc STGTPS_defines_the_minimum_throttle_opening_required_above_the_closed-throttle_idle_baseline_before_the_staging_rev_limiter_will_engage._Calibrate_STGTPS_to_ensure_reliable_arming_during_starting_line_staging_without_false_activation_at_idle._The_factory_setting_of_39_counts_(approx_0.76_volts_above_idle)_works_well_for_most_street_and_drag_racing_applications.
    .byte 0x27                       ;Point 1

STGROF_StageLimiterRPMOffSetpoint:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Launch_Control\Launch_Control_RPM\
    ;mptbladdr 0x1919
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StageLimiterRPMOffSetpoint
    ;mptblcname STGROF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc STGROF_establishes_the_upper_engine_speed_limit_where_launch_control_cuts_ignition_and/or_fuel_injection_while_staging._Adjust_STGROF_to_set_your_target_launch_staging_RPM_ceiling._For_front-wheel-drive_cars_on_street_tires,_set_STGROF_between_3200_and_3600_RPM_to_manage_launch_wheelspin._For_drag_slick_applications_or_high-stall_torque_converters,_calibrate_STGROF_between_4200_and_4800_RPM_to_load_the_turbo_heavily.
    .byte 0x7D                       ;Point 1

STGRON_StageLimiterRPMOnSetpoint:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Launch_Control\Launch_Control_RPM\
    ;mptbladdr 0x1925
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StageLimiterRPMOnSetpoint
    ;mptblcname STGRON
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc STGRON_establishes_the_lower_engine_speed_threshold_where_fuel_injection_and_ignition_spark_are_restored_after_being_cut_by_launch_control._When_the_staging_rev_limiter_cuts_spark_at_the_upper_ceiling,_engine_speed_begins_to_decay._Calibrate_STGRON_approximately_150_to_250_RPM_below_STGROF._A_200_RPM_window_creates_a_steady,_rhythmic_staging_cadence_that_builds_and_maintains_positive_boost_pressure_without_severe_drivetrain_shaking.
    .byte 0x77                       ;Point 1




	;.org	0x8802
MPSHFT_OverboostFuelShutoffEnablePointFromMap_Timer:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\A_-_Overboost\
    ;mptbladdr 0x1935
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostFuelShutoffEnablePointFromMap_Timer
    ;mptblcname MPSHFT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc MPSHFT_defines_the_primary_manifold_gauge_pressure_threshold_that_activates_the_timed_overboost_protection_logic._Turbocharged_Chrysler_engines_monitor_manifold_pressure_relative_to_barometric_pressure_to_detect_dangerous_overboost_conditions,_such_as_a_disconnected_wastegate_actuator_line,_torn_wastegate_diaphragm,_or_frozen_flapper_valve._Raising_MPSHFT_allows_the_engine_to_run_higher_turbocharger_boost_levels_without_triggering_fuel_cutout.
    ;mpmapaxis y
    .byte 0x35                       ;Point 1

	;.org	0x8803
MPSHFA_OverboostFuelShutoffEnablePointFromMap_Absolute:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\A_-_Overboost\
    ;mptbladdr 0x1943
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostFuelShutoffEnablePointFromMap_Absolute
    ;mptblcname MPSHFA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc MPSHFA_defines_the_instantaneous_or_absolute_overboost_fuel_cutout_threshold_in_the_Chrysler_engine_controller._While_MPSHFT_allows_a_temporary_boost_spike_by_decrementing_a_countdown_timer,_MPSHFA_serves_as_an_emergency_upper_boundary_where_fuel_injection_is_cut_immediately_without_waiting_for_any_timer_to_expire._Raising_MPSHFA_is_essential_when_increasing_turbocharger_boost_limits_beyond_stock_parameters.
    ;mpmapaxis y
    .byte 0x76                       ;Point 1

	;.org	0x8804
TRNTM_OverboostFuelShutoffDelay:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\A_-_Overboost\
    ;mptbladdr 0x1951
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OverboostFuelShutoffDuration
    ;mptblcname TRNTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 Sec
    ;mptbldesc TRNTIM_defines_the_duration_of_the_countdown_timer_that_delays_overboost_fuel_shutoff_when_manifold_pressure_exceeds_the_primary_timed_overboost_threshold_(MPSHFT)._Raising_TRNTIM_provides_a_longer_grace_period_for_aggressive_turbocharger_spool-up,_large_intercooler_volume_pressure_dynamics,_or_sluggish_wastegate_actuators,_preventing_premature_fuel_cuts_during_momentary_boost_spikes.
    .byte 0x5A                       ;Point 1

	;.org	0x8805
LMPSHF_OverboostFuelShutoffDisablePointFromMap_Limp:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\A_-_Overboost\
    ;mptbladdr 0x195E
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostFuelShutoffDisablePointFromMap_Limp
    ;mptblcname LMPSHF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc LMPSHF_establishes_the_overboost_fuel_cutout_threshold_used_whenever_the_engine_controller_detects_an_electrical_fault_in_the_wastegate_solenoid_circuit._In_most_street_and_competition_applications,_LMPSHF_should_remain_active_as_a_critical_failsafe_to_protect_the_engine_if_wastegate_solenoid_control_is_lost.
    ;mpmapaxis y
    .byte 0x73                       ;Point 1

	;.org	0x8806
REVLMT_MapLimpinAndThrAbove25PercentLower1850:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x196C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapLimpinAndThrAbove25PercentLower1850
    ;mptblcname REVLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc REVLMT_defines_the_lower_engine_speed_recovery_threshold_used_to_restore_fuel_injection_when_the_engine_controller_is_operating_in_MAP_sensor_limp-in_mode_with_the_throttle_opened_beyond_25_percent._REVLMT_forms_a_companion_hysteresis_pair_with_REVLMT2._Tuners_modifying_street_or_track_vehicles_rarely_need_to_alter_REVLMT_unless_they_wish_to_raise_the_limp-home_driving_speed_when_testing_with_a_disconnected_or_failed_MAP_sensor.
    .byte 0x3A                       ;Point 1

	;.org	0x8807
REVLMT2_MapLimpinAndThrAbove25PercentUpper2000:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x1979
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapLimpinAndThrAbove25PercentUpper2000
    ;mptblcname REVLMT2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc REVLMT2_establishes_the_upper_engine_speed_fuel_cutout_threshold_enforced_whenever_the_manifold_absolute_pressure_sensor_experiences_a_circuit_fault_and_the_throttle_is_opened_past_25_percent._REVLMT2_functions_as_the_shutoff_threshold_for_the_MAP_limp-in_rev_limiter,_paired_with_REVLMT_as_its_recovery_point.
    .byte 0x3E                       ;Point 1

	;.org	0x8808
REVLMT3_MapAbove75PctAndIdleSwitchClosed2000:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x1986
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapAbove75PctAndIdleSwitchClosed2000
    ;mptblcname REVLMT3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc REVLMT3_defines_the_lower_engine_speed_recovery_setpoint_for_the_plausibility_rev_limiter_that_activates_when_manifold_pressure_indicates_significant_engine_load_while_the_throttle_position_sensor_or_idle_switch_reports_a_closed_throttle._REVLMT3_operates_as_the_recovery_setpoint_paired_with_REVLMT4.
    .byte 0x3E                       ;Point 1

	;.org	0x8809
REVLMT4_MapAbove75PctAndThrLimpin2000:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x1993
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapAbove75PctAndThrLimpin2000
    ;mptblcname REVLMT4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc REVLMT4_establishes_the_upper_engine_speed_fuel_cutout_threshold_for_the_plausibility_safety_check_that_protects_against_throttle_mechanical_sticking_and_low-speed_throttle_sensor_faults._REVLMT4_functions_as_the_cutout_setpoint_paired_with_REVLMT3_(recovery_setpoint).
    .byte 0x5E                       ;Point 1

	;.org	0x880a
REVLMT5_RPMLimiterNormalOnRPM:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\B_-_Rev_Limiter\
    ;mptbladdr 0x19A0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimiterNormalOnRPM
    ;mptblcname REVLMT5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc REVLMT5_defines_the_primary_engine_speed_recovery_threshold_where_fuel_injection_is_restored_after_reaching_the_factory_engine_redline_rev_limiter_under_normal,_fault-free_operating_conditions._REVLMT5_must_always_be_adjusted_in_tandem_with_REVLMT6._When_building_a_performance_engine_with_upgraded_valve_springs,_lightweight_retainers,_and_forged_connecting_rods,_tuners_raise_REVLMT6_to_6500_or_7000_RPM_to_extend_the_engine_powerband.
    .byte 0xC1                       ;Point 1

	;.org	0x880b
REVLMT6_RPMLimiterNormalOffRPM:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\B_-_Rev_Limiter\
    ;mptbladdr 0x19AD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimiterNormalOffRPM
    ;mptblcname REVLMT6
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8160 rpm
    ;mptbldesc REVLMT6_defines_the_primary_engine_speed_redline_fuel_cutout_threshold_during_normal,_fault-free_vehicle_operation._Raising_REVLMT6_is_one_of_the_most_common_calibration_changes_when_optimizing_an_engine_for_track_use_or_when_upgrading_valvetrain_hardware._Stock_hydraulic_lifters_and_valve_springs_begin_to_lose_control_above_6300_RPM,_so_raising_REVLMT6_on_a_stock_valvetrain_provides_minimal_power_benefit_and_increases_mechanical_wear.
    .byte 0xCF                       ;Point 1

	;.org	0x880c
THRTHR_25PctThrValueFromShutoff:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x19BA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 25PctThrValueFromShutoff
    ;mptblcname THRTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc THRTHR_defines_the_throttle_position_offset_above_closed_throttle_that_delineates_light-throttle_driving_from_loaded_acceleration_during_MAP_sensor_limp-in_mode._THRTHR_acts_as_the_throttle_gating_threshold_for_the_MAP_limp-in_rev_limiter._Tuners_using_larger_throttle_bodies_(such_as_52mm_or_58mm_upgrades)_may_find_that_25_percent_throttle_angle_delivers_significantly_more_airflow_than_the_factory_46mm_unit.
    .byte 0x21                       ;Point 1

	;.org	0x880d
RVLSPD_CarSpeedForRevLimitWithTBOff:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x19C7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CarSpeedForRevLimitWithTBOff
    ;mptblcname RVLSPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 127.5 mph
    ;mptbldesc RVLSPD_establishes_the_vehicle_speed_threshold_that_determines_how_the_engine_controller_handles_rev_limiting_when_the_throttle_position_sensor_signal_is_invalid_or_failing._If_the_throttle_position_sensor_produces_a_bad_signal_(for_instance,_an_open_wiper_trace_or_erratic_voltage),_the_controller_cannot_ascertain_throttle_blade_position._RVLSPD_governs_low-speed_safety_gating_when_a_throttle_position_sensor_fault_occurs.
    .byte 0x14                       ;Point 1

	;.org	0x880e
DFRPM1_2050RPM_DecelFuelShutoffTurnonLimit:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x19D4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 2050RPM_DecelFuelShutoffTurnonLimit
    ;mptblcname DFRPM1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DFRPM1_defines_the_engine_speed_recovery_threshold_that_restores_fuel_injection_following_deceleration_fuel_shutoff_initiated_through_the_high-RPM_over-rev_decel_pathway._Raising_DFRPM1_restores_fuel_earlier_during_deceleration,_which_can_eliminate_popping_in_the_exhaust_and_prevent_stalling_on_vehicles_with_lightweight_flywheels,_aggressive_camshafts,_or_tight_torque_converters.
    .byte 0xA0                       ;Point 1

	;.org	0x880f
DFRPM2_2560RPM_DecelFuelShutoffUpperRpmLimit:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x19E1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 2560RPM_DecelFuelShutoffUpperRpmLimit
    ;mptblcname DFRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DFRPM2_defines_the_minimum_engine_speed_required_to_qualify_for_deceleration_fuel_shutoff_through_the_secondary_over-rev_deceleration_pathway._In_calibrations_where_this_secondary_deceleration_routine_is_utilized,_DFRPM2_establishes_the_entry_RPM_floor.
    .byte 0xB0                       ;Point 1

	;.org	0x8810
DFSMPH_20MPHDecelFuelShutoffSpeedLimit:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x19EE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 20MPHDecelFuelShutoffSpeedLimit
    ;mptblcname DFSMPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DFSMPH_defines_the_minimum_vehicle_speed_required_to_enable_the_secondary_deceleration_fuel_shutoff_routine._Lowering_DFSMPH_enables_the_secondary_deceleration_fuel_shutoff_at_typical_driving_speeds._For_example,_setting_DFSMPH_to_40_counts_enables_deceleration_fuel_cut_at_20_mph_(matching_the_label's_20MPH_designation)._This_provides_noticeable_engine_braking_and_maximizes_fuel_efficiency_during_coast-down_from_highway_speeds.
    .byte 0xA0                       ;Point 1

	;.org	0x8811
DFSTMP_60DegCDecelFuelShutoffTempLimit:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x19FB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 60DegCDecelFuelShutoffTempLimit
    ;mptblcname DFSTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DFSTMP_establishes_the_minimum_engine_coolant_temperature_required_to_permit_secondary_deceleration_fuel_shutoff._Lowering_DFSTMP_permits_deceleration_fuel_shutoff_earlier_during_the_engine_warmup_cycle._However,_on_engines_with_large_fuel_injectors_(such_as_+20%,_+40%,_or_3-bar_setups),_cold_deceleration_fuel_cut_often_leads_to_hesitation_or_stumbling_upon_tip-in.
    .byte 0xC0                       ;Point 1

	;.org	0x8812
DFSTMR_3minuteDecelFuelShutoffTimeLimit:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x1A08
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 3minuteDecelFuelShutoffTimeLimit
    ;mptblcname DFSTMR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DFSTMR_defines_the_minimum_operating_time_required_after_engine_start_before_secondary_deceleration_fuel_shutoff_can_be_activated._Lowering_DFSTMR_reduces_the_post-start_delay_before_deceleration_fuel_shutoff_can_activate._For_track_or_competition_vehicles_where_warm_engine_restarts_are_frequent_before_staging,_reducing_DFSTMR_to_10_or_20_counts_(30_to_60_seconds)_allows_immediate_normal_deceleration_behavior.
    .byte 0x01                       ;Point 1

	;.org	0x8813
SPDLMH_SpeedLimitFuelShutoff254MPH:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\C_-_Speed_Limiter\
    ;mptbladdr 0x1A15
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SpeedLimitFuelShutoff254mph
    ;mptblcname SPDLMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 255 mph
    ;mptbldesc SPDLMH_establishes_the_maximum_permissible_vehicle_road_speed_fuel_shutoff_threshold._Raising_or_disabling_SPDLMH_is_standard_practice_when_preparing_a_vehicle_for_track,_drag_strip,_or_closed-course_competition_where_road_speeds_exceed_factory_tire_limits._To_eliminate_the_top_speed_fuel_cutout_completely,_set_SPDLMH_to_the_maximum_value_of_255_counts_(255_mph)._In_Stage_IV_calibrations,_SPDLMH_is_elevated_to_175_counts_(175_mph).
    .byte 0xFE                       ;Point 1

	;.org	0x8814
SPDLML_SpeedLimitFuelShutoffRestore253MPH:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\C_-_Speed_Limiter\
    ;mptbladdr 0x1A22
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SpeedLimitFuelShutoffRestore253mph
    ;mptblcname SPDLML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SPDLML_defines_the_lower_vehicle_road_speed_recovery_threshold_that_restores_fuel_injection_after_a_top-speed_cutout_event._SPDLML_functions_as_the_recovery_threshold_for_the_vehicle_speed_limiter_and_must_always_be_paired_with_SPDLMH._When_raising_SPDLMH_for_track_use,_SPDLML_must_be_adjusted_accordingly_(for_example,_setting_SPDLMH_to_175_mph_and_SPDLML_to_170_mph,_as_configured_in_Stage_IV_calibrations).
    .byte 0xFD                       ;Point 1

	;.org	0x8815
SPDRPM_EngineSpeedHighLimitToEnableOverspeed:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x1A2F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineSpeedHighLimitToEnableOverspeed
    ;mptblcname SPDRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SPDRPM_defines_the_engine_speed_arming_threshold_that_gates_the_vehicle_road_speed_limiter._SPDRPM_provides_an_additional_layer_of_control_over_the_top_speed_limiter._Raising_SPDRPM_to_5500_or_6000_RPM_prevents_the_vehicle_speed_limiter_from_engaging_unless_the_engine_is_wound_out_near_redline.
    .byte 0x7D                       ;Point 1

	;.org	0x8816
SPDRPM2_EngineSpeedLowLimitToDisableOverspeed:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x1A3C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineSpeedLowLimitToDisableOverspeed
    ;mptblcname SPDRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SPDRPM2_establishes_the_lower_engine_speed_recovery_threshold_that_disarms_the_overspeed_fuel_shutoff_condition._SPDRPM2_functions_as_the_companion_restore_setpoint_to_SPDRPM._Maintaining_a_200_RPM_gap_below_SPDRPM_prevents_rapid_cycling_in_the_overspeed_detection_loop._When_adjusting_SPDRPM_upward,_SPDRPM2_must_be_raised_proportionally_(for_example,_setting_SPDRPM_to_5000_RPM_and_SPDRPM2_to_4800_RPM).
    .byte 0x77                       ;Point 1

	;.org	0x8817
MININC_Amount_MINTHR_IsIncreasedAtKeyOnOnly:
    ;mpgrp 4_-_OB,_Speed,_and_Rev_Limiter\D_-_Misc,_Limp_Mode\
    ;mptbladdr 0x1A49
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Amount_MINTHR_IsIncreasedAtKeyOnOnly
    ;mptblcname MININC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MININC_defines_the_incremental_voltage_offset_added_to_the_stored_minimum_closed-throttle_position_sensor_reading_at_key-on_initialization._MININC_fine-tunes_closed-throttle_reference_tracking._In_most_applications,_the_factory_value_of_3_counts_provides_ideal_tracking_without_interfering_with_idle_switch_detection.
    .byte 0x03                       ;Point 1

	;.org	0x8818
MAPTHR_ThrottleSelfCalibrationMapDeltaThreshold:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x1A56
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname ThrottleSelfCalibrationMapDeltaThreshold
    ;mptblcname MAPTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc MAPTHR_defines_the_manifold_pressure_ceiling_required_to_permit_upward_adaptive_learning_of_the_closed-throttle_baseline_voltage._MAPTHR_is_particularly_important_when_tuning_engines_equipped_with_aggressive_aftermarket_camshafts._High-duration,_tight-lobe-separation_camshafts_significantly_reduce_manifold_vacuum_at_idle_and_during_deceleration_overrun.
    ;mpmapaxis y
    .byte 0x31                       ;Point 1

	;.org	0x8819
RPMTHR_ThrottleSelfCalibrationRpmThreshold:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x1A64
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleSelfCalibrationRpmThreshold
    ;mptblcname RPMTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc RPMTHR_defines_the_minimum_engine_speed_boundary_required_to_permit_upward_adaptive_learning_of_the_closed-throttle_baseline_voltage._When_an_engine_decelerates,_the_vehicle_must_be_traveling_at_sufficient_speed_with_the_engine_spinning_above_idle_to_ensure_high_manifold_vacuum_and_verify_that_the_throttle_plate_is_completely_closed_against_its_mechanical_stop._Tuners_generally_leave_RPMTHR_at_its_factory_setting_of_fifteen_hundred_RPM.
    .byte 0x30                       ;Point 1

	;.org	0x881a
MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x1A71
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ValueOf_MINTHR_WhenBatteryDisconnected
    ;mptblcname MTHRMX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MTHRMX_defines_the_default_closed-throttle_position_baseline_voltage_loaded_into_memory_whenever_the_vehicle_battery_is_disconnected,_keep-alive_memory_power_is_lost,_or_the_engine_controller_undergoes_a_hard_reset._MTHRMX_must_be_checked_whenever_installing_aftermarket_throttle_bodies_or_custom_throttle_position_sensor_brackets.
    .byte 0x5C                       ;Point 1

	;.org	0x881b
MAXCNT_ProgramLoopsWithThrottleBelow_MINTHR_ToDecrement_MINTHR:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x1A7E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ProgramLoopsWithThrottleBelow_MINTHR_ToDecrement_MINTHR
    ;mptblcname MAXCNT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MAXCNT_defines_the_debounce_integration_counter_that_governs_how_quickly_the_learned_closed-throttle_baseline_voltage_ratchets_downward_when_throttle_position_sensor_voltage_drops_below_the_current_learned_minimum._MAXCNT_provides_vital_electrical_noise_immunity_for_the_throttle_position_sensing_subsystem._Tuners_rarely_need_to_adjust_this_parameter.
    .byte 0x10                       ;Point 1

	;.org	0x881c
MTHRCL_NumberOfBitsAbove_MINTHR_ToDetermineOnThrottleTransition:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x1A8B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NumberOfBitsAbove_MINTHR_ToDetermineOnThrottleTransition
    ;mptblcname MTHRCL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MTHRCL_defines_the_voltage_deadband_threshold_above_the_learned_minimum_closed-throttle_position_required_to_declare_an_off-idle_throttle_transition._MTHRCL_directly_dictates_initial_throttle_tip-in_sensitivity.
    .byte 0x02                       ;Point 1

	;.org	0x881d
MTHROP_NumberOfBitsAbove_MINTHR_ToDetermineOffThrottleTransition:
    ;mpgrp 0_-_Setup\E_-_Throttle_Calibration\
    ;mptbladdr 0x1A98
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NumberOfBitsAbove_MINTHR_ToDetermineOffThrottleTransition
    ;mptblcname MTHROP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MTHROP_defines_the_return-to-idle_threshold_above_the_learned_minimum_closed-throttle_position._After_an_engine_has_been_driven_off-idle,_releasing_the_accelerator_pedal_causes_throttle_position_sensor_voltage_to_drop_back_toward_the_mechanical_stop._MTHROP_is_critical_for_vehicles_with_aging_throttle_linkages,_weak_return_springs,_or_slight_throttle_shaft_friction.
    .byte 0x01                       ;Point 1

	;.org	0x881e
EGR1_ExhGasRecircConst:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1AA5
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst1
    ;mptblcname EGR1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR1_establishes_the_Phase_1_diagnostic_sampling_timer_threshold_for_the_onboard_Exhaust_Gas_Recirculation_flow_verification_system_(Fault_Code_32)._Raising_EGR1_increases_the_duration_of_stable_driving_required_before_the_engine_controller_concludes_its_baseline_oxygen_sensor_measurement,_reducing_the_frequency_of_diagnostic_tests_during_city_driving.
    .word 0x01C7                     ;Point 1

	;.org	0x8820
EGR3_ExhGasRecircConst:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1AB2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst3
    ;mptblcname EGR3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR3_establishes_the_maximum_allowable_closed-loop_fuel_trim_ceiling_during_Phase_1_of_the_Exhaust_Gas_Recirculation_diagnostic_verification_routine._Raising_EGR3_widens_the_allowable_closed-loop_fuel_trim_range_during_Phase_1_baseline_sampling,_permitting_the_EGR_diagnostic_routine_to_proceed_even_when_the_engine_is_operating_with_positive_closed-loop_fuel_addition.
    .byte 0x80                       ;Point 1

	;.org	0x8821
EGR18_ExhGasRecircConstLoLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1ABF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstLoLimit18
    ;mptblcname EGR18
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR18_establishes_the_lower_manifold_absolute_pressure_boundary_for_the_Phase_1_Exhaust_Gas_Recirculation_diagnostic_sampling_window._Lowering_EGR18_below_255_creates_an_active_lower_pressure_cutoff,_preventing_Phase_1_diagnostic_baseline_tracking_under_deep_intake_vacuum_(such_as_high-speed_trailing-throttle_cruising)._Raising_EGR18_keeps_the_lower_gate_open.
    .byte 0xFF                       ;Point 1

	;.org	0x8822
EGR18a_ExhGasRecircConstHiLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1ACC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstHiLimit18a
    ;mptblcname EGRR18A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGRR18A_establishes_the_upper_manifold_absolute_pressure_boundary_for_the_Phase_1_Exhaust_Gas_Recirculation_diagnostic_sampling_window._Located_immediately_following_EGR18_in_calibration_memory,_this_parameter_defines_the_maximum_intake_manifold_pressure_under_which_Phase_1_baseline_oxygen_sensor_tracking_is_permitted_to_operate._Lowering_EGRR18A_establishes_a_strict_upper_manifold_pressure_ceiling_above_which_Phase_1_baseline_sampling_aborts.
    .byte 0xFF                       ;Point 1

	;.org	0x8823
EGR16_ExhGasRecircConstLoLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1AD9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstLoLimit16
    ;mptblcname EGR16
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR16_establishes_the_lower_manifold_absolute_pressure_boundary_for_the_Phase_2_Exhaust_Gas_Recirculation_diagnostic_verification_window_(Fault_Code_32)._Lowering_EGR16_below_255_establishes_an_active_minimum_manifold_pressure_requirement_during_Phase_2_testing.
    .byte 0xFF                       ;Point 1

	;.org	0x8824
EGR16a_ExhGasRecircConstHiLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1AE6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstHiLimit16a
    ;mptblcname EGR16A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR16A_establishes_the_upper_manifold_absolute_pressure_boundary_for_the_Phase_2_Exhaust_Gas_Recirculation_diagnostic_verification_window_(Fault_Code_32)._Lowering_EGR16A_restricts_Phase_2_EGR_shutoff_flow_testing_to_lighter_engine_load_conditions._If_an_upper_pressure_limit_is_desired_to_ensure_that_exhaust_gas_flow_testing_only_occurs_under_deep_manifold_vacuum,_EGR16A_can_be_set_to_an_intermediate_value_such_as_90_or_100_counts.
    .byte 0xFF                       ;Point 1

	;.org	0x8825
EGR14_ExhGasRecircConstFromTPSVoltsLoLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1AF3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromTPSVoltsLoLimit14
    ;mptblcname EGR14
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR14_establishes_the_lower_throttle_position_threshold_for_the_Phase_1_Exhaust_Gas_Recirculation_diagnostic_baseline_sampling_window._Raising_EGR14_requires_a_greater_throttle_opening_before_Phase_1_baseline_sampling_can_proceed._This_can_be_useful_on_engines_with_large_aftermarket_throttle_bodies_where_very_small_throttle_angles_produce_significant_airflow_variations.
    .byte 0x0C                       ;Point 1

	;.org	0x8826
EGR14a_ExhGasRecircConstFromTPSVoltsHiLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B00
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromTPSVoltsHiLimit14a
    ;mptblcname EGR14A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR14A_establishes_the_upper_throttle_position_boundary_for_the_Phase_1_Exhaust_Gas_Recirculation_diagnostic_baseline_sampling_window._Raising_EGR14A_widens_the_allowable_throttle_window_for_Phase_1_baseline_sampling,_permitting_the_monitor_to_gather_baseline_data_during_moderate_acceleration_or_hill_climbs.
    .byte 0x18                       ;Point 1

	;.org	0x8827
EGR19_ExhGasRecircConstLoLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B0D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstLoLimit19
    ;mptblcname EGR19
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR19_establishes_the_lower_throttle_position_threshold_for_the_Phase_2_Exhaust_Gas_Recirculation_diagnostic_flow_verification_window_(Fault_Code_32)._Raising_EGR19_ensures_Phase_2_flow_verification_occurs_only_when_the_driver_is_applying_more_throttle,_which_generates_stronger_exhaust_backpressure_and_makes_the_EGR_shutoff_transition_more_distinct_on_the_oxygen_sensor.
    .byte 0x0F                       ;Point 1

	;.org	0x8828
EGR19a_ExhGasRecircConstHiLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B1A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstHiLimit19a
    ;mptblcname EGR19A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR19A_establishes_the_upper_throttle_position_boundary_for_the_Phase_2_Exhaust_Gas_Recirculation_diagnostic_flow_verification_window_(Fault_Code_32)._Raising_EGR19A_allows_Phase_2_flow_verification_to_continue_under_moderately_heavier_throttle_applications._This_can_prevent_aborted_tests_when_driving_on_rolling_highway_terrain_where_keeping_speed_requires_intermittent_throttle_increases.
    .byte 0x15                       ;Point 1

	;.org	0x8829
EGR15_ExhGasRecircConstFromRPMLoLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B27
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromRPMLoLimit15
    ;mptblcname EGR15
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR15_establishes_the_lower_engine_speed_boundary_for_the_Phase_1_Exhaust_Gas_Recirculation_diagnostic_baseline_sampling_window._Lowering_EGR15_establishes_an_active_minimum_engine_speed_required_for_Phase_1_baseline_tracking._For_example,_setting_EGR15_to_47_counts_enforces_a_minimum_speed_of_approximately_1500_RPM,_ensuring_that_diagnostic_sampling_only_begins_once_the_vehicle_is_cruising_in_top_gear.
    .byte 0xFF                       ;Point 1

	;.org	0x882a
EGR15b_ExhGasRecircConstFromRPMLoLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B34
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromRPMLoLimit15b
    ;mptblcname EGR15B
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR15B_establishes_the_upper_engine_speed_boundary_for_the_Phase_1_Exhaust_Gas_Recirculation_diagnostic_baseline_sampling_window._Lowering_EGR15B_establishes_a_firm_upper_engine_speed_ceiling_for_Phase_1_baseline_sampling._For_example,_setting_EGR15B_to_94_counts_enforces_an_upper_speed_limit_of_approximately_3000_RPM_(94_x_32_RPM),_preventing_diagnostic_tests_during_high-speed_highway_driving_or_sustained_downshifts.
    .byte 0xFF                       ;Point 1

	;.org	0x882b
EGR17_ExhGasRecircConstLoLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B41
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstLoLimit17
    ;mptblcname EGR17
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR17_establishes_the_lower_engine_speed_boundary_for_the_Phase_2_Exhaust_Gas_Recirculation_diagnostic_flow_verification_window_(Fault_Code_32)._Lowering_EGR17_establishes_an_active_minimum_engine_speed_for_Phase_2_flow_verification._If_calibrated,_the_engine_must_operate_above_this_speed_while_the_EGR_solenoid_is_commanded_closed;_if_engine_speed_drops_below_EGR17,_Phase_2_immediately_aborts_and_resets_to_Phase_1.
    .byte 0xFF                       ;Point 1

	;.org	0x882c
EGR17a_ExhGasRecircConstHiLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B4E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstHiLimit17a
    ;mptblcname EGR17A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR17A_establishes_the_upper_engine_speed_boundary_for_the_Phase_2_Exhaust_Gas_Recirculation_diagnostic_flow_verification_window_(Fault_Code_32)._Lowering_EGR17A_restricts_Phase_2_flow_verification_to_moderate_cruising_speeds._For_example,_setting_EGR17A_to_94_counts_enforces_an_upper_limit_of_approximately_3000_RPM_(94_x_32_RPM),_ensuring_that_the_test_does_not_execute_during_spirited_driving.
    .byte 0xFF                       ;Point 1

	;.org	0x882d
EGR4_ExhGasRecircConst:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B5B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst4
    ;mptblcname EGR4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR4_establishes_the_cumulative_diagnostic_failure_threshold_before_the_engine_controller_logs_Fault_Code_32_(EGR_System_Failure)_and_illuminates_the_Check_Engine_lamp._Raising_EGR4_to_its_maximum_value_of_255_requires_255_consecutive_failed_diagnostic_attempts_before_Fault_Code_32_can_trip,_substantially_reducing_the_likelihood_of_a_Check_Engine_lamp_on_engines_with_borderline_EGR_flow_or_aftermarket_exhausts.
    .byte 0xEB                       ;Point 1

	;.org	0x882e
EGR5_ExhGasRecircConst:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B68
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst5
    ;mptblcname EGR5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR5_establishes_the_per-trip_diagnostic_retry_limit_before_the_engine_controller_inhibits_further_Exhaust_Gas_Recirculation_flow_verification_attempts_for_the_remainder_of_the_current_driving_cycle._Raising_EGR5_allows_the_engine_controller_to_retry_Phase_2_flow_verification_multiple_times_during_a_single_driving_trip_if_an_earlier_attempt_timed_out_due_to_traffic_or_minor_road_grade_changes.
    .byte 0x00                       ;Point 1

	;.org	0x882f
EGR6_ExhGasRecircConst:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B75
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst6
    ;mptblcname EGR6
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR6_establishes_the_high_byte_of_the_16-bit_Phase_2_diagnostic_timeout_timer_threshold_for_the_Exhaust_Gas_Recirculation_flow_verification_routine._Raising_EGR6_increases_the_maximum_duration_permitted_for_Phase_2_flow_verification_by_256_loop_counts_(roughly_2.5_to_3.8_seconds)_for_each_integer_increment.
    .byte 0x01                       ;Point 1

	;.org	0x8830
EGR15a_ExhGasRecircConstFromRPMHiLimit:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B82
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromRPMHiLimit15a
    ;mptblcname EGR15A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR15A_represents_the_low_byte_of_the_16-bit_Phase_2_diagnostic_timeout_timer_threshold_in_the_Exhaust_Gas_Recirculation_verification_routine._Because_EGR15A_is_the_low_byte_of_the_16-bit_Phase_2_timeout_timer_threshold,_modifying_it_provides_fine_adjustment_of_the_timeout_window_(1_loop_count_=_approx_10_to_15_milliseconds).
    .byte 0x6C                       ;Point 1

	;.org	0x8831
EGR7_ExhGasRecircConst:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B8F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst7
    ;mptblcname EGR7
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR7_establishes_the_minimum_closed-loop_oxygen_sensor_fuel_trim_shift_threshold_required_to_confirm_Exhaust_Gas_Recirculation_valve_flow_and_pass_the_onboard_diagnostic_test_(Fault_Code_32)._During_Phase_2,_the_engine_controller_commands_the_EGR_valve_closed,_cutting_off_inert_exhaust_gas_into_the_cylinders._Raising_EGR7_demands_a_larger_positive_shift_in_closed-loop_fuel_trim_before_the_controller_declares_the_EGR_system_operational.
    .byte 0x00                       ;Point 1

	;.org	0x8832
SCRMP1_SecondaryRampSubtractor1:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1B9C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SecondaryRampSubtractor1
    ;mptblcname SCRMP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SCRMP1_establishes_the_closed-loop_oxygen_sensor_toggle_duration_modifier_used_specifically_while_Phase_2_of_the_Exhaust_Gas_Recirculation_diagnostic_verification_routine_is_active._Raising_SCRMP1_subtracts_a_larger_value_from_the_oxygen_sensor_toggle_duration_timer,_causing_the_closed-loop_system_to_switch_and_step_its_integrator_more_rapidly_while_the_EGR_flow_test_is_underway.
    .byte 0x02                       ;Point 1

	;.org	0x8833
ADMEMA_ValueFromAdaptivememoryAdder1:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1BA9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ValueFromAdaptivememoryAdder1
    ;mptblcname ADMEMA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ADMEMA_establishes_an_adaptive_memory_fuel_trim_modifier_offset_applied_specifically_while_Phase_2_of_the_Exhaust_Gas_Recirculation_diagnostic_verification_routine_is_running._Raising_ADMEMA_adds_an_artificial_positive_fuel_trim_offset_to_the_closed-loop_ramp_integrator_while_Phase_2_is_executing,_enriching_the_mixture_during_the_active_EGR_flow_test.
    .byte 0x00                       ;Point 1

	;.org	0x8834
EGR8_ExhGasRecircConst:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1BB6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst8
    ;mptblcname EGR8
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR8_establishes_the_exponential_smoothing_filter_coefficient_for_the_Phase_1_baseline_oxygen_sensor_fuel_trim_calculation._Raising_EGR8_increases_the_filter_weighting,_allowing_the_baseline_fuel_trim_value_to_adapt_more_quickly_to_changing_engine_conditions._This_can_be_useful_if_Phase_1_sampling_duration_(EGR1)_has_been_shortened_and_the_baseline_needs_to_settle_more_rapidly.
    .byte 0x81                       ;Point 1

	;.org	0x8835
EGR8a_ExhGasRecircConst:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1BC3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConst8a
    ;mptblcname EGR8A
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR8A_is_an_unreferenced_single-byte_calibration_constant_residing_in_the_Exhaust_Gas_Recirculation_calibration_memory_block._Positioned_immediately_following_EGR8,_this_byte_holds_a_factory_value_of_249_counts._Because_EGR8A_is_never_referenced_by_executable_assembly_instructions_in_T-SMEC_v19.asm,_altering_its_value_in_MPTune_produces_absolutely_no_change_in_engine_operation,_emissions_solenoid_behavior,_or_diagnostic_trouble_code_logging.
    .byte 0xF9                       ;Point 1

	;.org	0x8836
EGR33_ExhGasRecircConstFromMAPBelowBaro:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1BD0
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname ExhGasRecircConstFromMAPBelowBaro33
    ;mptblcname EGR33
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc EGR33_establishes_the_minimum_intake_manifold_vacuum_threshold_below_barometric_pressure_required_to_permit_Exhaust_Gas_Recirculation_diagnostic_testing_(Fault_Code_32)._The_onboard_diagnostic_routine_can_only_evaluate_EGR_flow_when_the_engine_is_drawing_sufficient_manifold_vacuum_to_pull_exhaust_gas_into_the_cylinders._Raising_EGR33_requires_greater_manifold_vacuum_before_the_controller_initiates_or_continues_EGR_diagnostic_testing.
    ;mpmapaxis y
    .byte 0x0D                       ;Point 1

	;.org	0x8837
EGR9_ExhGasRecircConstFromTimeEngRunning:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1BDE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromTimeEngRunning9
    ;mptblcname EGR9
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR9_establishes_the_post-start_engine_running_time_delay_before_closed-throttle_idle_EGR_shutoff_logic_becomes_active._Lowering_EGR9_reduces_the_warmup_delay_before_idle_EGR_shutoff_logic_engages,_shutting_off_EGR_at_closed_throttle_sooner_after_starting._On_street_vehicles_with_functioning_EGR,_keeping_EGR9_at_its_factory_setting_of_128_seconds_prevents_idle_instability.
    .byte 0x80                       ;Point 1

	;.org	0x8838
EGR13_ExhGasRecircConstFromRPM:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1BEB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromRPM13
    ;mptblcname EGR13
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR13_establishes_the_manual_transmission_engine_speed_enable_threshold_for_Exhaust_Gas_Recirculation_solenoid_control._On_automatic_transmission_vehicles,_modifying_EGR13_has_zero_effect_because_line_5390_branches_around_manual_transmission_logic._On_manual_transmission_vehicles,_raising_EGR13_establishes_an_active_minimum_engine_speed_below_which_the_EGR_solenoid_is_turned_off.
    .byte 0x00                       ;Point 1

	;.org	0x8839
EGR10_ExhGasRecircConstFromRPM:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1BF8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ExhGasRecircConstFromRPM10
    ;mptblcname EGR10
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EGR10_establishes_the_manual_transmission_engine_speed_hysteresis_adder_for_Exhaust_Gas_Recirculation_solenoid_control._On_manual_transmission_vehicles,_if_the_EGR_valve_were_to_switch_on_and_off_at_the_exact_same_engine_speed,_minor_RPM_fluctuations_during_cruise_would_cause_annoying_solenoid_clicking_and_vehicle_surging._Raising_EGR10_creates_an_engine_speed_deadband_on_manual_transmission_calibrations,_stabilizing_solenoid_operation.
    .byte 0x00                       ;Point 1

	;.org	0x883a
EGR11_ExhGasRecircConstFromMAP:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1C05
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname ExhGasRecircConstFromMAP11
    ;mptblcname EGR11
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc EGR11_establishes_the_manual_transmission_manifold_absolute_pressure_enable_threshold_for_Exhaust_Gas_Recirculation_solenoid_control._On_automatic_transmission_vehicles,_EGR11_is_bypassed_by_configuration_flags_and_has_no_effect._On_manual_transmission_vehicles,_raising_EGR11_requires_higher_manifold_pressure_(heavier_load)_before_EGR_can_activate_when_engine_speed_is_below_EGR13.
    ;mpmapaxis y
    .byte 0x00                       ;Point 1

	;.org	0x883b
EGR12_ExhGasRecircConstFromMAP:
    ;mpgrp 7_-_Aux_Functions\EGR\
    ;mptbladdr 0x1C13
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname ExhGasRecircConstFromMAP12
    ;mptblcname EGR12
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc EGR12_establishes_the_manual_transmission_manifold_absolute_pressure_hysteresis_adder_for_Exhaust_Gas_Recirculation_solenoid_control._On_manual_transmission_vehicles,_if_intake_manifold_pressure_fluctuates_near_the_base_enable_threshold_(EGR11),_rapid_solenoid_cycling_can_occur._Raising_EGR12_widens_the_manifold_pressure_deadband_required_to_turn_on_the_EGR_valve_on_manual_transmission_calibrations.
    ;mpmapaxis y
    .byte 0x00                       ;Point 1




	;.org	0x883c
LMPINN_LimpinTableForMapFromThrottle:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1C24
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname LimpinTableForMapFromThrottle
    ;mptblcname LMPINN
    ;mpxaxis TPS 0 255 tps
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc LMPINN_provides_the_engine_controller_with_a_synthetic_manifold_pressure_estimate_derived_from_throttle_position_whenever_the_primary_manifold_absolute_pressure_sensor_fails_or_is_disconnected._Adjusting_LMPINN_modifies_the_synthetic_manifold_pressure_and_resulting_fuel_delivery_and_spark_timing_when_operating_in_emergency_limp-home_mode.
    ;mpmapaxis y
    .byte 0x05                       ;Number of points in table
    .byte 0x00, 0x00, 0x02, 0x50     ;Point 1
    .byte 0x10, 0x25, 0x01, 0xDB     ;Point 2
    .byte 0x17, 0x32, 0x01, 0x5D     ;Point 3
    .byte 0x22, 0x41, 0x00, 0xF9     ;Point 4
    .byte 0x45, 0x63                 ;Point 5

	;.org	0x8853
MPLMOF_OffsetForCalcMapInMapLimpin:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1C37
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OffsetForCalcMapInMapLimpin
    ;mptblcname MPLMOF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc MPLMOF_establishes_a_baseline_pressure_offset_added_directly_to_the_interpolated_manifold_absolute_pressure_value_during_throttle-based_limp-home_operation._Raising_MPLMOF_increases_the_baseline_manifold_pressure_calculation_across_the_entire_throttle-based_limp-home_operating_window,_commanding_richer_air-fuel_mixtures_and_softer_spark_advance.
    ;mpmapaxis y
    .byte 0x20                       ;Point 1

	;.org	0x8854
THROFF_OffsetAddedToCalcThrottle:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1C45
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OffsetAddedToCalcThrottle
    ;mptblcname THROFF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc THROFF_introduces_a_calibrated_voltage_bias_to_the_measured_throttle_position_signal_prior_to_looking_up_simulated_manifold_absolute_pressure_during_MAP_sensor_limp-home_mode._Raising_THROFF_makes_the_emergency_throttle-based_load_calculation_more_sensitive_to_throttle_pedal_input,_commanding_earlier_enrichment_and_lower_ignition_advance_when_stepping_off_idle.
    .byte 0x0B                       ;Point 1

	;.org	0x8855
TMPHIG_OutOfRangeColdTooHighA2D:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1C52
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OutOfRangeColdTooHighA2D
    ;mptblcname TMPHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc TMPHIG_defines_the_upper_electrical_voltage_boundary_for_the_engine_coolant_temperature_sensor_analog_input_circuit._TMPHIG_establishes_the_open-circuit_detection_threshold_for_the_coolant_temperature_circuit._Raising_TMPHIG_to_255_counts_effectively_disables_open-circuit_fault_detection,_preventing_the_engine_controller_from_identifying_a_broken_signal_wire_or_disconnected_sensor_plug.
    .byte 0xFD                       ;Point 1

	;.org	0x8856
TMPLOW_OutOfRangeHotTooLowA2D:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1C5F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OutOfRangeHotTooLowA2D
    ;mptblcname TMPLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc TMPLOW_defines_the_lower_electrical_voltage_boundary_for_the_engine_coolant_temperature_sensor_analog_input_circuit._TMPLOW_establishes_the_short-circuit_detection_threshold_for_the_coolant_temperature_sensor._Raising_TMPLOW_narrows_the_high-temperature_threshold,_which_can_cause_false_Fault_Code_22_triggers_during_high-load_track_sessions_or_extended_idling_in_hot_summer_weather_when_coolant_temperatures_naturally_rise_toward_230_deg_F.
    .byte 0x1A                       ;Point 1

	;.org	0x8857
DEFTMP_DefaultEngineTemp:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1C6C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DefaultEngineTemp
    ;mptblcname DEFTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis CoolantTemp -200 260 DegF
    ;mptbldesc DEFTMP_specifies_the_fixed_default_engine_coolant_temperature_value_substituted_into_the_engine_controller's_temperature_calculation_whenever_the_primary_coolant_sensor_is_faulted._DEFTMP_controls_how_rich_or_lean_the_engine_runs_when_operating_in_failsafe_mode_with_a_defective_coolant_temperature_sensor._Raising_DEFTMP_simulates_a_hotter_engine,_leaning_out_warm-up_fuel_enrichment_and_increasing_idle_target_speed.
    .byte 0x95                       ;Point 1

	;.org	0x8858
BTLRPM_LowBatteryVoltageAtThisRpm1500:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1C79
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowBatteryVoltageAtThisRpm1500
    ;mptblcname BTLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc BTLRPM_defines_the_minimum_engine_speed_threshold_required_before_the_engine_controller_evaluates_low-voltage_charging_system_performance._BTLRPM_controls_the_engine_speed_gate_that_prevents_false_charging_system_error_codes_at_stoplights_and_idle.
    .byte 0x2E                       ;Point 1

	;.org	0x8859
CTLRPM_LowBatteryVoltageAtThisCoolantTemp:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1C86
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowBatteryVoltageAtThisCoolantTemp
    ;mptblcname CTLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CTLRPM_specifies_the_minimum_engine_coolant_temperature_required_before_the_engine_controller_enables_diagnostic_testing_of_the_oxygen_sensor_middle-band_circuit._CTLRPM_establishes_the_engine_operating_temperature_gate_for_oxygen_sensor_fault_detection._When_installing_a_160_deg_F_or_180_deg_F_low-temperature_thermostat_or_a_high-capacity_aluminum_radiator,_the_engine_may_struggle_to_maintain_170_deg_F_during_highway_cruising_in_cold_weather.
    .byte 0xCD                       ;Point 1

	;.org	0x885a
BTLRPM2_LowBatteryVoltageAtThisRpm1500:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1C93
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowBatteryVoltageAtThisRpm1500_2
    ;mptblcname BTLRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc BTLRPM2_defines_the_minimum_engine_speed_threshold_required_before_the_engine_controller_enables_diagnostic_testing_of_the_oxygen_sensor_middle-band_circuit._BTLRPM2_ensures_that_oxygen_sensor_diagnostics_are_evaluated_only_during_road_cruising_where_exhaust_temperature_is_sufficient_to_keep_the_sensor_active.
    .byte 0x2E                       ;Point 1

	;.org	0x885b
AMBLOW_BattTempLowWhenHot:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1CA0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BattTempLowWhenHot
    ;mptblcname AMBLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AMBLOW_establishes_the_lower_electrical_voltage_boundary_for_the_ambient_air_and_battery_temperature_sensor_analog_input_circuit._Chrysler_SMEC_controllers_monitor_underhood_battery_temperature_to_regulate_alternator_charging_voltage,_because_lead-acid_batteries_accept_charge_more_readily_when_warm_and_require_higher_voltage_when_cold._AMBLOW_sets_the_short-circuit_detection_threshold_for_the_underhood_ambient_and_battery_temperature_sensor.
    .byte 0x05                       ;Point 1

	;.org	0x885c
AMBHIG_BattTempHighWhenCold:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1CAD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BattTempHighWhenCold
    ;mptblcname AMBHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AMBHIG_establishes_the_upper_electrical_voltage_boundary_for_the_ambient_air_and_battery_temperature_sensor_analog_input_circuit._AMBHIG_sets_the_open-circuit_detection_threshold_for_the_ambient_air_and_battery_temperature_sensor_circuit._Raising_AMBHIG_toward_255_counts_narrows_the_open-circuit_margin,_and_setting_it_to_255_counts_blinds_the_controller_to_a_disconnected_sensor.
    .byte 0xFA                       ;Point 1

	;.org	0x885d
CHGLOW_ChargeTempOutOfRangeLow:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1CBA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ChargeTempOutOfRangeLow
    ;mptblcname CHGLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CHGLOW_establishes_the_lower_electrical_voltage_boundary_for_the_charge_air_temperature_sensor_circuit._CHGLOW_defines_the_short-circuit_detection_threshold_for_the_charge_air_temperature_sensor_circuit._Raising_CHGLOW_narrows_the_allowable_high-temperature_voltage_window,_which_can_cause_false_Fault_Code_23_triggers_on_high-boost_turbo_setups_where_intake_manifold_air_temperatures_reach_200_deg_F_or_higher_during_sustained_full-throttle_pulls.
    .byte 0x08                       ;Point 1

	;.org	0x885e
CHGHIG_ChargeTempOutOfRangeHigh:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1CC7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ChargeTempOutOfRangeHigh
    ;mptblcname CHGHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CHGHIG_establishes_the_upper_electrical_voltage_boundary_for_the_charge_air_temperature_sensor_circuit._CHGHIG_defines_the_open-circuit_detection_threshold_for_the_charge_air_temperature_sensor._Raising_CHGHIG_to_255_counts_blinds_the_diagnostic_logic,_preventing_the_controller_from_detecting_an_unplugged_sensor_connector_or_broken_harness_wire.
    .byte 0xFD                       ;Point 1

	;.org	0x885f
DEFCHG_DefaultChargeTemp_Limpin:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1CD4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DefaultChargeTemp_Limpin
    ;mptblcname DEFCHG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DEFCHG_specifies_the_fixed_default_charge_air_temperature_value_substituted_into_the_engine_controller's_fueling_and_spark_calculations_when_the_charge_air_temperature_sensor_is_faulted._DEFCHG_controls_the_fallback_air_temperature_assumed_by_the_engine_controller_when_the_charge_temperature_sensor_fails.
    .byte 0xAD                       ;Point 1

	;.org	0x8860
ERRRPM_RPMLimitforErrorCodeSetting:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1CE1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimitforErrorCodeSetting
    ;mptblcname ERRRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ERRRPM_defines_the_minimum_engine_speed_threshold_required_before_the_engine_controller_latches_major_system_fault_codes_and_illuminates_the_check_engine_lamp._ERRRPM_establishes_the_engine_speed_qualification_gate_for_escalating_diagnostic_trouble_codes_to_the_check_engine_lamp.
    .byte 0x38                       ;Point 1

	;.org	0x8861
ERRMAP_MAPLimitforErrorCodeSetting:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1CEE
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MAPLimitforErrorCodeSetting
    ;mptblcname ERRMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc ERRMAP_specifies_the_manifold_vacuum_threshold_required_before_the_engine_controller_latches_major_system_fault_codes_and_illuminates_the_check_engine_lamp._Major_error_confirmation_requires_that_the_vehicle_be_operated_under_moderate,_steady_cruising_conditions_rather_than_during_deep_trailing-throttle_overrun._ERRMAP_establishes_the_load_criteria_required_for_the_engine_controller_to_escalate_and_latch_major_fault_codes.
    ;mpmapaxis y
    .byte 0x2B                       ;Point 1

	;.org	0x8862
ERRTMP_CoolantTempLimitforErrorCodeSetting:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1CFC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CoolantTempLimitforErrorCodeSetting
    ;mptblcname ERRTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ERRTMP_specifies_the_minimum_engine_coolant_temperature_required_before_the_engine_controller_enables_major_system_fault_escalation_and_check_engine_lamp_illumination._During_cold_engine_warm-up,_air-fuel_mixtures_are_enriched,_combustion_stability_is_lower,_and_emissions_systems_have_not_reached_operating_temperature._ERRTMP_controls_the_warm-up_threshold_that_prevents_premature_check_engine_lamp_activation_on_a_cold_engine.
    .byte 0xA0                       ;Point 1

	;.org	0x8863
THRLOW_ThrottleLowerLimit:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D09
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleLowerLimit
    ;mptblcname THRLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc THRLOW_defines_the_lower_electrical_voltage_boundary_for_the_throttle_position_sensor_analog_input_circuit._The_throttle_position_sensor_is_a_potentiometer_powered_by_a_5.0-volt_reference_supply_that_produces_an_output_voltage_proportional_to_throttle_plate_angle._THRLOW_sets_the_minimum_allowable_voltage_before_the_engine_controller_declares_an_open_circuit_or_short_to_ground_on_the_throttle_position_sensor.
    .byte 0x08                       ;Point 1

	;.org	0x8864
THRHIG_ThrottleUpperLimit:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D16
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleUpperLimit
    ;mptblcname THRHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc THRHIG_defines_the_upper_electrical_voltage_boundary_for_the_throttle_position_sensor_analog_input_circuit._THRHIG_establishes_the_short-to-reference-voltage_detection_limit_for_the_throttle_position_sensor_circuit._Raising_THRHIG_toward_255_counts_permits_higher_wide-open_throttle_voltages,_which_may_be_necessary_on_custom_aftermarket_throttle_setups_that_output_higher_voltage_at_mechanical_full_travel.
    .byte 0xF0                       ;Point 1

	;.org	0x8865
MPTHR_MapSwitchPointForFullThrottleOrIdle:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D23
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MapSwitchPointForFullThrottleOrIdle
    ;mptblcname MPTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc MPTHR_defines_the_manifold_absolute_pressure_switch_point_where_the_engine_controller_toggles_its_synthetic_throttle_calculation_between_closed-throttle_idle_and_wide-open_throttle_when_the_throttle_position_sensor_is_faulted._MPTHR_controls_the_load_threshold_where_emergency_throttle_failsafe_logic_snaps_into_wide-open_throttle_fueling_and_spark_timing.
    ;mpmapaxis y
    .byte 0x68                       ;Point 1

	;.org	0x8866
COILLO_LoLimitBatteryVoltsForCoilVerify:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D31
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname LoLimitBatteryVoltsForCoilVerify
    ;mptblcname COILLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc COILLO_defines_the_minimum_intake_manifold_pressure_disturbance_threshold_evaluated_during_the_secondary_ignition_coil_driver_verification_routine._COILLO_controls_the_sensitivity_of_the_secondary_ignition_coil_driver_verification_diagnostic.
    ;mpmapaxis y
    .byte 0x05                       ;Point 1

	;.org	0x8867
COILHI_HiLimitBatteryVoltsForCoilVerify:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D3F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HiLimitBatteryVoltsForCoilVerify
    ;mptblcname COILHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc COILHI_defines_the_upper_battery_voltage_boundary_for_enabling_the_secondary_ignition_coil_driver_diagnostic_routine._COILHI_establishes_the_battery_voltage_ceiling_that_restricts_secondary_ignition_coil_checking_to_pre-charging_and_low-voltage_states._Raising_COILHI_allows_the_secondary_test_to_continue_running_at_higher_battery_voltages,_but_can_cause_false_Fault_Code_43_triggers_on_modified_engines_once_the_engine_catches_and_begins_charging.
    .byte 0xBA                       ;Point 1

	;.org	0x8868
MAPLOW_MapSensorLowerLimit:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D4C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapSensorLowerLimit
    ;mptblcname MAPLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MAPLOW_defines_the_lower_electrical_voltage_boundary_for_the_manifold_absolute_pressure_sensor_analog_input_circuit._MAPLOW_sets_the_ground_short_and_open_circuit_detection_boundary_for_the_primary_manifold_pressure_sensor._Because_automotive_pressure_sensors_rarely_drop_below_0.20_volts_even_under_maximum_deceleration_overrun_vacuum,_setting_MAPLOW_to_1_count_ensures_that_normal_extreme_vacuum_never_falsely_sets_Fault_Code_14.
    .byte 0x01                       ;Point 1

	;.org	0x8869
MAPHIG_MapSensorUpperLimit:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D59
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapSensorUpperLimit
    ;mptblcname MAPHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MAPHIG_defines_the_upper_electrical_voltage_boundary_for_the_manifold_absolute_pressure_sensor_analog_input_circuit._Under_maximum_turbocharger_boost_pressure,_a_2-bar_manifold_pressure_sensor_generates_output_voltages_approaching_4.60_volts._MAPHIG_establishes_the_maximum_valid_operating_voltage_for_the_manifold_pressure_sensor.
    .byte 0xEE                       ;Point 1

	;.org	0x886a
MPLTHR_ThrottleLevelAbove_MINTHR_ToMatureMapLimpin:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D66
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleLevelAbove_MINTHR_ToMatureMapLimpin
    ;mptblcname MPLTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MPLTHR_defines_the_throttle_angle_threshold_above_closed_throttle_above_which_electrical_diagnostic_checking_of_the_manifold_absolute_pressure_sensor_is_bypassed._MPLTHR_acts_as_a_diagnostic_filter_window_that_confines_electrical_MAP_testing_to_idle_and_light_cruise._Raising_MPLTHR_expands_the_throttle_window_where_electrical_checks_remain_active,_ensuring_that_faulty_sensor_wiring_or_failing_sensors_are_identified_across_a_wider_driving_range.
    .byte 0x42                       ;Point 1

	;.org	0x886b
MPDELT_DeltaMapThatChecksGood:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D73
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaMapThatChecksGood
    ;mptblcname MPDELT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MPDELT_establishes_the_minimum_pressure_delta_between_successive_sensor_readings_required_to_verify_that_the_manifold_absolute_pressure_sensor_is_dynamically_responding_to_engine_airflow_changes._MPDELT_defines_the_sensitivity_threshold_for_proving_that_the_manifold_pressure_sensor_is_alive_and_responding_to_intake_manifold_events.
    .byte 0x01                       ;Point 1

	;.org	0x886c
MPDELA_MatureMapLimpinWhenDeltaAbove_MPDELT_plus_MPDELA:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D80
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MatureMapLimpinWhenDeltaAbove_MPDELT_plus_MPDELA
    ;mptblcname MPDELA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MPDELA_provides_a_calibrated_hysteresis_adder_combined_with_MPDELT_to_establish_an_elevated_pressure_change_requirement_when_clearing_a_previously_latched_stuck_MAP_sensor_fault_code._MPDELA_controls_the_strictness_of_the_recovery_logic_after_the_engine_controller_has_detected_a_stuck_manifold_pressure_sensor_or_disconnected_vacuum_hose.
    .byte 0x01                       ;Point 1

	;.org	0x886d
MPRPML_DisableMapCheckUnderThisRpm_600:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D8D
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DisableMapCheckUnderThisRpm_600
    ;mptblcname MPRPML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MPRPML_defines_the_lower_engine_speed_limit_for_the_manifold_absolute_pressure_sensor_steady-state_rationality_validation_window._MPRPML_establishes_the_lower_engine_speed_gate_for_validating_that_manifold_pressure_is_within_a_healthy_operating_window.
    .word 0x12C0                     ;Point 1

	;.org	0x886f
MPRPMH_DisableMapCheckAboveThisRpm_1500:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1D9A
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DisableMapCheckAboveThisRpm_1500
    ;mptblcname MPRPMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MPRPMH_defines_the_upper_engine_speed_limit_for_the_manifold_absolute_pressure_sensor_steady-state_rationality_validation_window._The_engine_controller_continuously_monitors_the_health_of_the_primary_pressure_sensor_during_engine_operation._MPRPMH_establishes_the_ceiling_of_the_engine_speed_window_used_to_confirm_that_the_manifold_pressure_sensor_is_reading_realistic_intake_manifold_vacuum.
    .word 0x2EE0                     ;Point 1

	;.org	0x8871
MPDAGL_DisableMapCheckBelowThisMap:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1DA7
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DisableMapCheckBelowThisMap
    ;mptblcname MPDAGL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc MPDAGL_defines_the_lower_manifold_pressure_boundary_for_the_steady-state_manifold_absolute_pressure_sensor_rationality_validation_window._MPDAGL_sets_the_floor_of_the_manifold_pressure_window_used_to_qualify_steady-state_sensor_rationality._Raising_MPDAGL_narrows_the_allowable_vacuum_window,_requiring_the_engine_to_operate_with_less_vacuum_before_steady-state_sensor_health_can_be_verified.
    ;mpmapaxis y
    .byte 0x10                       ;Point 1

	;.org	0x8872
MPDAGH_DisableMapCheckAboveThisMap:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1DB5
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DisableMapCheckAboveThisMap
    ;mptblcname MPDAGH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc MPDAGH_defines_the_upper_manifold_pressure_boundary_for_the_steady-state_manifold_absolute_pressure_sensor_rationality_validation_window._When_testing_whether_the_pressure_sensor_is_healthy_and_delivering_plausible_signals,_the_engine_controller_requires_manifold_pressure_to_stay_below_heavy_load_or_boost_levels._MPDAGH_sets_the_maximum_load_ceiling_where_steady-state_manifold_pressure_rationality_is_evaluated.
    ;mpmapaxis y
    .byte 0xF2                       ;Point 1

	;.org	0x8873
MPRMPD_CheckMapAtZeroSpeedAndThisDeltaRpm:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1DC3
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname CheckMapAtZeroSpeedAndThisDeltaRpm
    ;mptblcname MPRMPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MPRMPD_defines_the_maximum_allowable_engine_speed_deviation_from_target_idle_speed_permitted_when_evaluating_manifold_absolute_pressure_sensor_pneumatic_health_at_closed_throttle._MPRMPD_establishes_the_stability_window_around_target_idle_speed_required_before_the_engine_controller_checks_for_valid_closed-throttle_intake_manifold_vacuum.
    .word 0x0200                     ;Point 1

	;.org	0x8875
BAROSW_CheckMapAtZeroSpeedAndThisBaroSwitch:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1DD0
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname CheckMapAtZeroSpeedAndThisBaroSwitch
    ;mptblcname BAROSW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc BAROSW_defines_the_barometric_pressure_switch_point_used_to_select_between_sea-level_and_high-altitude_intake_manifold_vacuum_criteria_during_the_idle_pneumatic_MAP_sensor_check._BAROSW_determines_the_altitude_transition_where_the_engine_controller_relaxes_its_idle_manifold_vacuum_diagnostic_criteria.
    ;mpmapaxis y
    .byte 0x62                       ;Point 1

	;.org	0x8876
MPVACD_AllowMapToTestGoodThisNearBaro:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1DDE
    ;mptbltype 4
    ;mpsubtype 1
    ;mptbllname AllowMapToTestGoodThisNearBaro
    ;mptblcname MPVACD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc MPVACD_defines_the_minimum_intake_manifold_vacuum_that_the_manifold_absolute_pressure_sensor_must_indicate_at_closed-throttle_idle_to_prove_that_it_is_physically_connected_to_the_intake_manifold._MPVACD_is_one_of_the_most_critical_diagnostic_parameters_for_modified_engines_fitted_with_aggressive_high-duration_performance_camshafts.
    ;mpmapaxis y
    .word 0x1108                     ;Point 1

	;.org	0x8878
FUELTR_FuelMonitorConversionFactor:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1DEC
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname FuelMonitorConversionFactor
    ;mptblcname FUELTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc FUELTR_(stock_0x0311_=_785)_calibrates_the_fuel_consumption_signal_sent_from_the_ECU_to_the_dashboard_Electronic_Navigator_/_trip_computer._When_installing_larger_fuel_injectors,_scale_FUELTR_upward_proportionally_to_your_injector_flow_increase_so_MPG_and_distance-to-empty_readings_remain_accurate.
    ;mpinjscale word
    .word 0x0311                     ;Point 1

	;.org	0x887a
FLWMNC_FuelMonitorCorrection:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\
    ;mptbladdr 0x1DFA
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname FuelMonitorCorrection
    ;mptblcname FLWMNC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc FLWMNC_defines_the_fuel_injector_dead-time_offset_correction_historically_subtracted_from_calculated_fuel_pulse_width_prior_to_broadcasting_fuel_consumption_data_over_the_Chrysler_Collision_Detection_network_bus._Electromechanical_fuel_injectors_exhibit_opening_dead-time_delays_during_which_no_fuel_flows._FLWMNC_is_an_inactive_legacy_calibration_parameter_in_Turbonator_SMEC_v19_firmware.
    .word 0x0000                     ;Point 1




	;.org	0x88cd
TTEMPL_TstatDiagnosticsMinTempToArmDiagnosticsAtStartup:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\T-Stat_Diagnostics\
    ;mptbladdr 0x1E0A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsMinTempToArmDiagnosticsAtStartup
    ;mptblcname TTEMPL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc TTEMPL_defines_the_minimum_engine_coolant_temperature_required_at_engine_startup_to_arm_the_thermostat_warm-up_diagnostic_monitor._TTEMPL_establishes_the_cold-weather_lockout_for_thermostat_diagnostics._In_cold_northern_climates_where_winter_ambient_temperatures_regularly_dip_below_freezing,_the_factory_40_deg_F_setting_prevents_nuisance_Fault_Code_17_errors_by_waiting_for_milder_starting_conditions_before_evaluating_warm-up_times.
    .byte 0x63                       ;Point 1

	;.org	0x88ce
TTEMPH_TstatDiagnosticsMaxTempToArmDiagnosticsAtStartup:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\T-Stat_Diagnostics\
    ;mptbladdr 0x1E17
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsMaxTempToArmDiagnosticsAtStartup
    ;mptblcname TTEMPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc TTEMPH_defines_the_maximum_engine_coolant_temperature_allowed_at_engine_startup_to_arm_the_thermostat_warm-up_diagnostic_monitor._TTEMPH_controls_the_warm_restart_lockout_for_the_thermostat_diagnostic_monitor._If_TTEMPH_is_set_too_high_(for_example,_above_the_thermostat_opening_temperature_of_180_or_195_deg_F),_restarting_a_fully_warm_engine_can_falsely_re-arm_the_thermostat_timer_if_temperatures_dip_slightly_during_a_brief_stop.
    .byte 0xE4                       ;Point 1

	;.org	0x88cf
TDAGTP_TstatDiagnosticsTemperatureGoalWithin_HOTIME:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\T-Stat_Diagnostics\
    ;mptbladdr 0x1E24
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsTemperatureGoalWithin_HOTIME
    ;mptblcname TDAGTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc TDAGTP_defines_the_target_coolant_temperature_goal_that_the_engine_must_achieve_within_the_HOTIME_driving_window_to_pass_thermostat_diagnostic_verification._TDAGTP_is_a_vital_calibration_parameter_when_installing_low-temperature_performance_thermostats._A_stock_Chrysler_thermostat_is_rated_at_195_deg_F,_easily_achieving_the_factory_180_deg_F_TDAGTP_goal.
    .byte 0xC7                       ;Point 1

	;.org	0x88d0
HOTIME_TstatDiagnosticsTimeToAchieveTemperatureGoal:
    ;mpgrp 7_-_Aux_Functions\On-Board_Diagnostics\T-Stat_Diagnostics\
    ;mptbladdr 0x1E31
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsTimeToAchieveTemperatureGoal
    ;mptblcname HOTIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HOTIME_defines_the_maximum_allowable_vehicle_driving_time_permitted_for_the_engine_to_achieve_the_TDAGTP_warm-up_temperature_goal_before_the_engine_controller_declares_a_thermostat_fault._HOTIME_controls_the_warm-up_duration_window_before_a_stuck-open_thermostat_is_flagged.
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
    ;mptbladdr 0x1E49
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempForColdScaleFromA2D
    ;mptblcname TMPTL1
    ;mpxaxis raw 0 255 scale
    ;mpyaxis Coolant_Temperature -200 260 F
    ;mptbldesc TMPTL1_is_the_primary_non-linear_transfer_table_converting_raw_voltage_counts_from_the_engine_coolant_temperature_sensor_into_engineering_temperature_units_under_cold_operating_conditions._The_Chrysler_SMEC_hardware_incorporates_a_dual-range_thermistor_input_circuit_with_a_switched_pull-up_resistor._TMPTL1_is_calibrated_to_match_the_resistance_characteristics_of_the_factory_Chrysler_negative_temperature_coefficient_coolant_thermistor.
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
    ;mptbladdr 0x1E5D
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempForHotScaleA2D
    ;mptblcname TMPTL2
    ;mpxaxis raw 0 255 scale
    ;mpyaxis Coolant_Temperature -200 260 F
    ;mptbldesc TMPTL2_is_the_hot-range_non-linear_transfer_table_converting_raw_voltage_counts_from_the_engine_coolant_temperature_sensor_into_engineering_temperature_units_under_warm_running_conditions._Maintaining_accurate_calibration_in_TMPTL2_is_critical_for_engine_cooling_and_thermal_management.
    .byte 0x04                       ;Number of points in table
    .byte 0x42, 0xFF, 0xFF, 0x55     ;Point 1
    .byte 0x57, 0xF1, 0xFF, 0x75     ;Point 2
    .byte 0xC5, 0xB5, 0xFF, 0x4F     ;Point 3
    .byte 0xFF, 0x8D                 ;Point 4

	;.org	0x88ba
CHGTL1_TempForChargeTempA2D:
    ;mpgrp 0_-_Setup\D_-_Transfer_Functions\
    ;mptbladdr 0x1E6E
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempForChargeTempA2D
    ;mptblcname CHGTL1
    ;mpxaxis raw 0 255 scale
    ;mpyaxis Coolant_Temperature -200 260 F
    ;mptbldesc CHGTL1_defines_the_four-point_non-linear_transfer_table_converting_raw_voltage_counts_from_the_intake_manifold_air_charge_temperature_sensor_into_engineering_temperature_units._CHGTL1_is_frequently_recalibrated_when_installing_fast-response_open-element_intake_air_temperature_sensors._Factory_Chrysler_charge_temperature_sensors_are_housed_in_heavy_brass_casings_that_suffer_from_thermal_heat_soak_and_sluggish_reaction_times.
    .byte 0x04                       ;Number of points in table
    .byte 0x0E, 0xFF, 0xFE, 0x43     ;Point 1
    .byte 0x29, 0xD0, 0xFF, 0x8D     ;Point 2
    .byte 0xE3, 0x7C, 0xFE, 0x70     ;Point 3
    .byte 0xFA, 0x58                 ;Point 4

MAPMULT_ScaleMAPVoltsToPresMultiplyConst:
    ;mpgrp 0_-_Setup\D_-_Transfer_Functions\
    ;mptbladdr 0x1E7E
    ;mptbltype 8
    ;mpsubtype 1
    ;mptbllname ScaleMAPVoltsToPresMultiplyConst
    ;mptblcname MAPMULT
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc MAPMULT_is_the_foundational_mathematical_slope_multiplier_in_the_transfer_function_that_converts_analog_manifold_absolute_pressure_sensor_voltage_into_calibrated_internal_pressure_units._MAPMULT_must_be_updated_whenever_changing_manifold_absolute_pressure_sensor_hardware._For_standard_Mopar_two-bar_sensors_supporting_up_to_fourteen_point_seven_psi_boost,_MAPMULT_is_seven_counts.
    ;mpchoices 1.0_Bar 07 1.5_Bar 07 2.0_Bar 07 2.5_Bar 08 3.0_Bar 09 3.5_Bar 09 4.0_Bar 09 4.5_Bar 09
    ;mpmapaxis b
    .byte 0x07                       ;Point 1

MAPADD_ScaleMAPVoltsToPresAddConst:
    ;mpgrp 0_-_Setup\D_-_Transfer_Functions\
    ;mptbladdr 0x1E8C
    ;mptbltype 8
    ;mpsubtype 1
    ;mptbllname ScaleMAPVoltsToPresAddConst
    ;mptblcname MAPADD
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc MAPADD_is_the_sixteen-bit_zero-offset_addition_constant_in_the_manifold_absolute_pressure_sensor_transfer_function._In_linear_sensor_scaling,_physical_pressure_transducers_produce_a_residual_electrical_offset_voltage_even_under_complete_vacuum._MAPADD_works_in_strict_partnership_with_MAPMULT._When_converting_to_a_three-bar_pressure_sensor,_MAPADD_must_be_changed_from_eight_hundred_sixty-five_counts_to_seventeen_hundred_counts.
    ;mpchoices 1.0_Bar 0361 1.5_Bar 0361 2.0_Bar 0361 2.5_Bar 0700 3.0_Bar 0700 3.5_Bar 0700 4.0_Bar 0700 4.5_Bar 0700
    ;mpmapaxis w
    .word 0x0361                     ;Point 1

MINAMP_MinimumAverageMAP:
    ;mpgrp 0_-_Setup\D_-_Transfer_Functions\
    ;mptbladdr 0x1E9A
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MinimumAverageMAP
    ;mptblcname MINAMP
    ;mpxaxis IN 0 255 X
    ;mpyaxis PSI 0 29.4 psi
    ;mptbldesc MINAMP_defines_the_absolute_lower_limit_floor_for_the_running_average_manifold_absolute_pressure_variable._Tuners_rarely_need_to_modify_MINAMP_on_stock_two-bar_calibrations._When_converting_to_a_three-bar_manifold_pressure_sensor_where_the_pressure_counts_per_psi_are_compressed_by_thirty-three_percent,_MINAMP_can_be_left_at_six_counts_or_reduced_to_four_counts_to_maintain_equivalent_deep-vacuum_underflow_protection.
    ;mpmapaxis y
    .byte 0x06                       ;Point 1

	;.org	0x89f7
AISTEP_BitPatternForAisControl:
    ;mpgrp 0_-_Setup\D_-_Transfer_Functions\
    ;mptbladdr 0x1EA8
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname BitPatternForAisControl
    ;mptblcname AISTEP
    ;mpxaxis in_desc 4 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AISTEP_defines_the_four-byte_electromagnetic_commutation_sequence_that_drives_the_bipolar_stepper_motor_inside_the_automatic_idle_speed_actuator._AISTEP_is_a_fixed_hardware_driver_definition_that_must_never_be_altered_when_using_the_factory_Chrysler_automatic_idle_speed_stepper_motor._Modifying_these_bit_patterns_breaks_the_electromagnetic_commutation_sequence,_causing_the_stepper_motor_coils_to_oppose_one_another.
    .byte 0x06                       ;Point 1
    .byte 0x05                       ;Point 2
    .byte 0x09                       ;Point 3
    .byte 0x0A                       ;Point 4




KNKMIN_FlashCEMinTemp:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\CEL_Knock_Indicator\
    ;mptbladdr 0x1EBA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FlashCEMinTemp
    ;mptblcname KNKMIN
    ;mpxaxis IN 0 255 X
    ;mpyaxis CoolantTemp -200 260 deg
    ;mptbldesc KNKMIN_defines_the_minimum_engine_coolant_temperature_required_before_the_engine_controller_will_flash_the_instrument_cluster_Check_Engine_or_Power_Loss_light_upon_detecting_detonation_knock._Maintain_KNKMIN_near_the_factory_160_degF_setting_for_engines_equipped_with_stock_cast_pistons.
    .byte 0xA8                       ;Point 1

; SLRPM_ShiftLightSetpoint:
;     ;mpgrp Turbonator_Features\Shift_Light\
;     ;mptbladdr 0x1DC7
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
    ;mptbladdr 0x1ED2
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyPumpOnSetpointFromMAP
    ;mptblcname AKPMON
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc AKPMON_establishes_the_manifold_absolute_pressure_threshold_where_the_auxiliary_water_or_methanol_injection_pump_relay_is_energized._When_water_or_alcohol_injection_logic_is_enabled_in_firmware,_configure_AKPMON_to_energize_the_pump_approximately_2_to_3_psi_of_boost_before_the_first_injection_nozzle_opens._For_example,_if_stage_one_injection_is_scheduled_to_activate_at_8_psi_of_boost,_set_AKPMON_between_5_and_6_psi_of_boost.
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1

AKPMOF_AlkyPumpOffSetpointFromMAP:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Alky_Injection\
    ;mptbladdr 0x1EDF
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyPumpOffSetpointFromMAP
    ;mptblcname AKPMOF
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc AKPMOF_establishes_the_manifold_pressure_turn-off_threshold_for_the_auxiliary_alcohol_or_water_injection_delivery_pump._When_using_water_or_alcohol_injection_logic,_configure_AKPMOF_approximately_1_to_2_psi_of_boost_below_the_pump_turn-on_threshold_AKPMON._For_example,_if_the_pump_turns_on_at_6_psi_of_boost,_set_AKPMOF_to_4_or_5_psi_of_boost._This_small_hysteresis_gap_prevents_pump_relay_chattering_when_hovering_near_the_activation_pressure.
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1

AKI1ON_AlkyInj1OnSetpointFromMAP:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Alky_Injection\
    ;mptbladdr 0x1EEC
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyInj1OnSetpointFromMAP
    ;mptblcname AKI1ON
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc AKI1ON_establishes_the_manifold_pressure_turn-on_threshold_for_the_primary_stage_water_or_alcohol_injection_solenoid._When_alcohol_injection_is_enabled_in_custom_firmware,_set_AKI1ON_to_the_boost_level_where_charge_cooling_is_first_required,_typically_7_to_10_psi_of_boost._Ensure_AKI1ON_is_set_higher_than_the_pump_turn-on_threshold_AKPMON_so_the_high-pressure_pump_is_already_primed_before_the_injection_solenoid_opens.
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1

AKI1OF_AlkyInj1OffSetpointFromMAP:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Alky_Injection\
    ;mptbladdr 0x1EF9
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyInj1OffSetpointFromMAP
    ;mptblcname AKI1OF
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc AKI1OF_establishes_the_manifold_pressure_turn-off_threshold_for_the_primary_stage_water_or_alcohol_injection_solenoid._When_stage_one_injection_is_enabled,_calibrate_AKI1OF_approximately_1_to_2_psi_of_boost_below_the_turn-on_setpoint_AKI1ON._For_instance,_if_stage_one_turns_on_at_8_psi_of_boost,_set_AKI1OF_to_6_or_7_psi_of_boost._This_hysteresis_gap_prevents_rapid_on-off_solenoid_cycling_during_gear_shifts_or_partial-throttle_modulation.
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1

AKI2ON_AlkyInj2OnSetpointFromMAP:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Alky_Injection\
    ;mptbladdr 0x1F06
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyInj2OnSetpointFromMAP
    ;mptblcname AKI2ON
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc AKI2ON_establishes_the_manifold_pressure_turn-on_threshold_for_the_secondary_stage_water_or_alcohol_injection_solenoid._When_secondary_alcohol_injection_is_active,_calibrate_AKI2ON_roughly_5_to_8_psi_of_boost_higher_than_the_primary_stage_AKI1ON,_typically_between_14_and_18_psi_of_boost._Staggering_the_two_stages_prevents_sudden_in-rush_of_liquid_that_could_quench_cylinder_combustion_while_ensuring_massive_evaporative_cooling_at_peak_boost.
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1

AKI2OF_AlkyInj2OffSetpointFromMAP:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\Alky_Injection\
    ;mptbladdr 0x1F13
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyInj2OffSetpointFromMAP
    ;mptblcname AKI2OF
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc AKI2OF_establishes_the_manifold_pressure_turn-off_threshold_for_the_secondary_stage_water_or_alcohol_injection_solenoid._When_secondary_stage_injection_is_configured,_set_AKI2OF_approximately_1_to_2_psi_of_boost_below_the_turn-on_setpoint_AKI2ON._For_example,_if_stage_two_turns_on_at_16_psi_of_boost,_calibrate_AKI2OF_between_14_and_15_psi_of_boost.
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1

; these are the added baud rate definitions
; in D-Cal, these can be defined as data type 6 (value list), but not in chem...

; To achieve 977 baud, byte=0x25
; To achieve 1200 baud, byte ox33
; To achieve 9608 baud, byte = 0x30
; to achieve 7812 baud, byte = 0x22
; To achieve 62500 baud, byte = 0x01

BAUDLO_DRBBaudRateLo:
    ;mpgrp 0_-_Setup\F_-_Baud_Rate\
    ;mptbladdr 0x1F29
    ;mptbltype 6
    ;mpsubtype n
    ;mptbllname DRBBaudRateLow
    ;mptblcname BAUDLO
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc BAUDLO_defines_the_initial_serial_communication_baud_rate_loaded_into_the_on-chip_serial_communications_interface_during_standard_diagnostic_tool_communication._BAUDLO_should_remain_configured_to_seventy-eight_twelve_baud_(twenty-two_in_hex_/_thirty-four_decimal_counts)_to_maintain_compatibility_with_factory_Chrysler_diagnostic_readout_box_testers,_Snap-on_scanners,_and_generic_diagnostic_tools.
    ;mpchoices 977_Baud 25 1200_Baud 33 9608_Baud 30 7812_Baud 22 62500_Baud 01 12500_Baud 00 Unused 00 Unused 00
    .byte 0x22                       ;Point 1

BAUDHI_DRBBaudRateHi:
    ;mpgrp 0_-_Setup\F_-_Baud_Rate\
    ;mptbladdr 0x1F36
    ;mptbltype 6
    ;mpsubtype n
    ;mptbllname DRBBaudRateHi
    ;mptblcname BAUDHI
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc BAUDHI_defines_the_accelerated_diagnostic_communications_baud_rate_used_during_high-speed_serial_datalogging_and_flash_transfer_operations._Factory_calibrations_configure_BAUDHI_to_one_count,_corresponding_to_sixty-two_thousand_five_hundred_baud_(62500_baud)._BAUDHI_directly_dictates_the_data_streaming_speed_for_modern_PC-based_logging_applications_like_MPScan.
    ;mpchoices 977_Baud 25 1200_Baud 33 9608_Baud 30 7812_Baud 22 62500_Baud 01 12500_Baud 00 Unused 00 Unused 00
    .byte 0x01                       ;Point 1

BAUDMD_HiSpeedSerialBaudRate:
    ;mpgrp 0_-_Setup\F_-_Baud_Rate\
    ;mptbladdr 0x1F43
    ;mptbltype 6
    ;mpsubtype n
    ;mptbllname HiSpeedSerialBaudRate
    ;mptblcname BAUDMD
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc BAUDMD_defines_an_intermediate_serial_communication_baud_rate_setting_originally_intended_for_custom_datalogging_programs._Modifying_BAUDMD_has_no_effect_on_datalogging_transfer_speeds_or_scan_tool_communications_in_T-SMEC_v19_firmware_because_all_high-speed_serial_routines_reference_BAUDHI_instead._Tuners_wishing_to_adjust_datalogging_communication_speeds_should_modify_BAUDHI_rather_than_BAUDMD.
    ;mpchoices 977_Baud 25 1200_Baud 33 9608_Baud 30 7812_Baud 22 62500_Baud 01 12500_Baud 00 Unused 00 Unused 00
    .byte 0x30                       ;Point 1

NO2SWS_NO2SwitchSelect:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\NO2_Retard\
    ;mptbladdr 0x1F50
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname NO2SwitchSelect
    ;mptblcname NO2SWS
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc NO2SWS_selects_the_digital_input_switch_bitmask_that_signals_nitrous_oxide_activation_to_the_engine_controller._Select_the_digital_input_switch_bitmask_that_corresponds_to_your_nitrous_system_wiring._Common_choices_include_Speed_Control_On/Off_or_Set_switch,_Brake_Switch,_or_Air_Conditioning_Switch.
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
    ;mptbladdr 0x1F65
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NO2RetardConstant
    ;mptblcname NO2RET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Retard 0 15 deg
    ;mptbldesc NO2RET_defines_the_amount_of_ignition_timing_retard_applied_when_the_nitrous_oxide_activation_switch_is_triggered._Calibrate_NO2RET_according_to_the_size_of_your_nitrous_shot._A_general_automotive_tuning_rule_of_thumb_is_approximately_1.5_to_2.0_degrees_of_timing_retard_for_every_50_horsepower_of_nitrous_flow._For_a_50_hp_shot,_calibrate_NO2RET_for_roughly_2.0_degrees_retard_(16_counts)._For_a_100_hp_shot,_use_4.0_degrees_retard_(32_counts).
    .byte 0x1F                       ;Point 1

AFR2NB_WidebandAFRToO2TransferFunction:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\WB2NB\
    ;mptbladdr 0x1F71
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname WidebandAFRToO2TransferFunction
    ;mptblcname AFR2NB
    ;mpxaxis AFR 4 19.9375 ratio
    ;mpyaxis O2SensorVolts 0 5 volts
    ;mptbldesc AFR2NB_is_the_second_stage_transfer_function_in_the_Turbonator_wideband-to-narrowband_emulation_system,_translating_calculated_air-fuel_ratio_into_simulated_narrowband_oxygen_sensor_voltage._The_factory_four-point_curve_provides_a_sharp_switching_transition_centered_at_14.7:1_air-fuel_ratio_for_standard_gasoline.
    ;mpmapaxis y
    .byte 0x04                       ;Number of points in table
    .byte 0x00, 0x32, 0xFF, 0xFA     ;Point 1
    .byte 0xA7, 0x2E, 0xFB, 0x72     ;Point 2
    .byte 0xB0, 0x05, 0xFF, 0xFA     ;Point 3
    .byte 0xFF, 0x03                 ;Point 4

WB2AFR_WidebandToAFRTransferFunction:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\WB2NB\
    ;mptbladdr 0x1F82
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname WidebandToAFRTransferFunction
    ;mptblcname WB2AFR
    ;mpxaxis SensorVolts 0 5 volts
    ;mpyaxis AFR 4 19.9375 ratio
    ;mptbldesc WB2AFR_is_the_primary_input_transfer_function_in_the_Turbonator_wideband_conversion_system,_translating_the_analog_0_to_5_volt_signal_from_an_aftermarket_wideband_controller_into_internal_engine_air-fuel_ratio._Different_wideband_controllers_(such_as_AEM,_Innovate,_or_Zeitronix)_output_different_linear_voltage-to-AFR_relationships._Configure_WB2AFR_to_match_the_published_0-5V_analog_output_calibration_curve_of_your_wideband_controller.
    .byte 0x02                       ;Number of points in table
    .byte 0x00, 0x52, 0x00, 0x9F     ;Point 1
    .byte 0xFF, 0xF0                 ;Point 2
    
NBOFFS_NarrowBandOffsetValue:
    ;mpgrp 0_-_Setup\C_-_Turbonator_Features\WB2NB\
    ;mptbladdr 0x1F90
    ;mptbltype 19
    ;mpsubtype n
    ;mptbllname NarrowBandOffsetValue
    ;mptblcname NBOFFS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis O2SensorVolts -2.5 2.5 volts
    ;mptbldesc NBOFFS_provides_a_fine-tuning_voltage_offset_added_to_the_simulated_narrowband_oxygen_sensor_voltage_in_the_wideband_conversion_routine._Use_NBOFFS_to_bias_closed-loop_cruising_air-fuel_ratio_richer_or_leaner_without_altering_transfer_function_tables._Lowering_NBOFFS_below_128_subtracts_voltage,_making_the_controller_perceive_a_leaner_mixture_and_driving_closed-loop_fueling_richer_(e.g.,_14.2:1_AFR_for_enhanced_idle_stability).
    .byte 0x80                       ;Point 1
    
; Decel fuel cut template data to add:

DCLMER_MinTimeEngineRunningForDecelFuelShutoff:
    ;mpgrp 1_-_Fuel\G_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x1F9E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinTimeEngineRunningForDecelFuelShutoff
    ;mptblcname DCLMER
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc DCLMER_defines_the_minimum_engine_run_time_required_after_startup_before_decel_fuel_shutoff_logic_is_permitted_to_activate._DCLMER_prevents_sudden_engine_stalling_when_releasing_the_throttle_immediately_after_starting._If_an_engine_tends_to_stumble,_jerk,_or_die_when_backing_off_the_throttle_right_after_starting_the_vehicle,_increase_DCLMER_to_5_or_10_counts_(5_to_10_seconds).
    .byte 0x02                       ;Point 1

DCLMCT_MinCoolantTempForDecelFuelShutoff:
    ;mpgrp 1_-_Fuel\G_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x1FAA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinCoolantTempForDecelFuelShutoff
    ;mptblcname DCLMCT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc DCLMCT_defines_the_minimum_coolant_temperature_required_before_decel_fuel_shutoff_is_allowed_to_arm._DCLMCT_is_crucial_when_using_cooler_aftermarket_thermostats._If_you_install_a_160_degF_thermostat_while_leaving_DCLMCT_at_the_factory_178_degF_setting_(210_counts),_the_engine_will_never_reach_the_threshold,_and_decel_fuel_shutoff_will_remain_disabled_indefinitely.
    .byte 0xD2                       ;Point 1

DCLRPH_EngineRPMLimitForDecelFuelShutoffHigh:
    ;mpgrp 1_-_Fuel\G_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x1FB6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineRPMLimitForDecelFuelShutoffHigh
    ;mptblcname DCLRPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc DCLRPH_defines_the_high_engine_speed_delta_above_target_idle_speed_required_to_arm_the_decel_fuel_cut_flag_(Turbonator_DecelFuelCut)._DCLRPH_controls_how_far_above_idle_speed_the_engine_must_be_before_decel_fuel_shutoff_is_allowed_to_arm._Raising_DCLRPH_prevents_fuel_cut_during_low-speed_decel,_eliminating_driveline_jerkiness_and_bucking_in_stop-and-go_traffic.
    .byte 0x11                       ;Point 1

DCLRPL_EngineRPMLimitForDecelFuelShutoffLow:
    ;mpgrp 1_-_Fuel\G_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x1FC2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineRPMLimitForDecelFuelShutoffLow
    ;mptblcname DCLRPL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc DCLRPL_defines_the_low_engine_speed_delta_above_target_idle_speed_at_which_the_decel_fuel_cut_flag_is_disarmed._Once_decel_fuel_shutoff_has_been_armed,_engine_speed_delta_must_remain_above_DCLRPL._Tuning_DCLRPL_prevents_coast-down_stalling_and_idle_undershoot._If_an_engine_dips_below_target_idle_speed_or_stalls_when_coasting_to_a_stop_with_the_clutch_pushed_in,_raise_DCLRPL.
    .byte 0x0F                       ;Point 1

DCAISI_AISIncrementWhenUsingDecelFuelShut:
    ;mpgrp 1_-_Fuel\G_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x1FCE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AISIncrementWhenUsingDecelFuelShut
    ;mptblcname DCAISI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc DCAISI_defines_the_Automatic_Idle_Speed_(AIS)_stepper_motor_position_increment_added_when_disarming_decel_fuel_shutoff._DCAISI_is_highly_effective_for_curing_stalling_during_coast-down_on_vehicles_equipped_with_lightweight_flywheels,_aggressive_camshafts,_or_manual_transmission_conversions.
    .byte 0x00                       ;Point 1

DFRPMH_DecelFuelShutoffDeltaRPMOff:
    ;mpgrp 1_-_Fuel\G_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x1FDA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DecelFuelShutoffDeltaRPMOff
    ;mptblcname DFRPMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPMOverIdle 0 8192 rpm
    ;mptbldesc DFRPMH_defines_the_engine_speed_delta_above_target_idle_speed_at_which_fuel_injection_is_actively_shut_off_during_deceleration._DFRPMH_governs_the_onset_of_active_fuel_shutoff_when_lifting_off_the_throttle._Raising_DFRPMH_delays_fuel_shutoff_until_higher_engine_RPM,_creating_a_smoother_transition_into_trailing-throttle_decel_and_reducing_exhaust_burble_or_popping.
    .byte 0x1E                       ;Point 1

DFRPML_DecelFuelShutoffDeltaRPMOn:
    ;mpgrp 1_-_Fuel\G_-_Decel_Fuel_Shutoff\
    ;mptbladdr 0x1FE6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DecelFuelShutoffDeltaRPMOn
    ;mptblcname DFRPML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPMOverIdle 0 8192 rpm
    ;mptbldesc DFRPML_defines_the_engine_speed_delta_above_target_idle_speed_at_which_fuel_injection_is_restored_during_deceleration._While_fuel_is_shut_off_during_deceleration,_engine_speed_steadily_drops_toward_idle._DFRPML_is_critical_for_smooth,_seamless_fuel_re-engagement_and_preventing_coast-down_bucking_or_stalling._If_the_vehicle_jerks_violently_or_stumbles_when_fuel_turns_back_on_during_deceleration,_raise_DFRPML_to_restore_fuel_earlier_at_higher_RPM.
    .byte 0x11                       ;Point 1

	.msg "Complete."

; ********************************************************







