;mpver 2.00
;mpassmfile t-lmv13-wideband.asm
.org DataOrg
; ***********************************************************************
; Turbonator-LM Calibration Data Template
; ***********************************************************************
; T-LM_22_MTX_a171_stock.v12
; ***********************************************************************
;
; This is the calibration template for T-LM.
;
; This template format will be used from T-LM v10 and later.
;
; I decided to switch to this format because it was getting clumsy
; trying to define the switches for all of the build options (MTX/ATX, 
; 2.2/2.5, boost control, etc.). This way, all the calibration data can be
; kept together in 1 place.
;
; T-SMEC, and T-SBEC have thier own template format and the 2 CAN NOT be
; interchanged. This is due to the different code structures between the
; LM, SMEC and SBEC.
;
; The relative positions of the data structures should not be changed.
; But, the calibration values can be changed at will to any value you wish.
; Or, to match any exsisting calibration.
;
; Filename format:
;
;    T-LM_[displ]_[trans]_[ID]_[version].v16
;
; For example, the 1st tempalte file I made was from the 87 T2:
;
;    T-LM_22_MTX_A171_T2.v10
;
; This way you can start your T-LM build with any calibration. Though,
; you may have to build a template file if you want a calibration that
; does not already have a tempalte file.
;
; If you modify a 'stock' calibration, please change the [version] part
; of the filename so that it will not get confused. Of course, you can 
; name your custom calibrations anything you wish.
;
; Before building, this template file MUST be added to the .include
; statement in the T-SMEC .asm file. Otherwise, you'll get an error.
;
; ***********************************************************************
; FUEL INJECTORS
; ***********************************************************************
;
; From v10, fuel injector scaling has been moved to the template file.
;
; Control fuel injector scaling, performed by a post-link program, this way.
;

;mpinjsize 52.0

;
;  MAP definition
;
;  This is the MAP range that the template is based on. It is only used
;  by MP Tuner for MAP Scaling.
;
;  20 = 2.0 Bar MAP, 30 = 3.0 Bar map, etc.

;mpbar 3.0

;mprevisionstart
;8/25/25 rev 12. Set FuelBatteryOffset Y Max to 2040. Set the values to match S60 cals. Noticed my old cal  (test87t2_3barcd_v6.bin) had battery offset scaled by injector size (60%) which is what we thought you needed to do back then. The car always seems to start hard and is very rich cold, but idles fine. Will just have to see if this change helps any of that.
;
;6/26/22 added part throttle fuel at 6psi. from 14.7 to 13.0. noticed some engine light at low boost in 3rd.  Made a small reduction in advance in the cold map spark table.
;6/12/22 JPC - This is rev 11.  The goal is to re-tune fuel starting at the lowest the g-valve will go that is outside of adaptives. I want to be able to set fuel and from there perhaps find optimal timing.
;
;4/22? JPC - notes lost on rev 10 for an unkown reason. Looks like I adjusted PE based on dyno results. I increased the max advance spark also.
;
;6/1/20 JPC - Added fuel to Part throttle and remove from Fulll. New A/F guage installed and verifed lean on part throttle (13s). Bascially I adjusted both tables to closer match the A/F line.
;
;5/16/20 JPC - All revs since 02 are invalid on fueling due to guage and wideband mismatch (4/6/19).  This revision reverts fueling back to version 02. The goal from here is to use the wideband logging to re-tune the cal. First re-scaled from 55 to 52pph injectors and then used Beyond Compare to revert these tables to the values from version 02.
;MAPTBL_FuelPartThrottle
;WOTTBL_FuelFullThrottle
;MAPIDL_FuelBaselineFromMap
;PEFTBL_PumpingEfficiency
;
;5/7/20 JPC - Modified for wideband O2 input.  This cal uses the LM13-Wideband asm file.
;
;7/21/19 JPC - Added fuel in last 2 points (I think the WOT table). Saw 12.5 into 16psi. Adjusted second point from~6800 to 7200. Added a little to 3rd. A/F line is about 0.6 too rich.
;
;7/12/19 JPC - Resetting PF yeilded 10.8 until about 16psi and then it seems to fall back to 10:0. So I leaned out WOT fuel a little. Looks to be about 0.5 A/F off so far.
;
;7/11/19 JPC - Reset pump eff back to stock because at all boost levels WOT is 10.0:1. So either too much fuel somewhere or the sensor doesn't read correctly at WOT.   Also restored some advance in WOT and HOT advance tables.
;
;6/22/19 JPC - Pulled timing from full throttle to match part throttle curve. Noticed intermittent check ending light up near 20 psi at wot. Added about 1% more fuel above 20 psi.  This turned out to be the spark blowing out and I gapped the plugs to 28 from 35 per Andrew and ?? else.
;
;6/21/19 JPC - Pulled out more timing at part throttle by smoothing out the curve to match the previous cal.
;
;6/16/19 JPC - Copying over some spark table data from old FWD cal. Car feels good and no knock but a little weak. The FWD cal is more agressive.
;
;6/11/19 JPC - Slightly richened -1 psi to 3psi closer to 12.5. Driving showed 14s and 13s in that range, felt weak.
;
;5/22/19 JPC - leaned out last 3 points in basefuel table to match base Boost Button IV cal.  Added about 10% -3psi point in part throttle fue; table. Car idle is getting worse when cold and adaptives say it's very rich.
;
;5/21/19 JPC - Set AF fuel type from 0.8 to 0.74 due to lean conditions when driving. Moved all 3 fuel tables in line with the AF line. Even smooth out the baslinefrommap table lower end that was customized from the origional cal.
;
;5/18/19 JPC - Set AF as Brian from NY suggested. Altered part and full throttle tables to match line.  Noticed that boost is acutally 12/15 as being set to 12/12.  Part throttle was lean (14.7s) and full was rich (10s).  So that's why I just went with the AF settings.
;
;5/16/19 JPC - Scaled Injectors to 55pph from 52 for this rev 5. On startup had some stalling issues but after warming or chaning addaptives it seemed ok. less fuel smell. Not driven yet.  Also set overboost from 25psi to 16psi.
;
;5/16/19 JPC - set boost to 12/12. 15 on full boost was acutally going to 20 with knock light on at > 15, no noise. Lowered fueling at part throttle to the 12.5a/f line for 11 and 17 psi points.
;
;5/10/19 JPC - set boost to 10/15.
;
;7/28/15 JPC - Set allowed boost from RPM lower for tuning.  8psi. Which I think because of WG probems is 11psi.
;
;7/21/14 JPC - Moved values from the 3 fuel vs map tables from teh old FWD Cal. (test87t2_3barcd_v6.bin).  This added fuel to the part throttle and baseline tables.  Only moved the pot at $59 in the FuelFullThrottle table. The rest of the points were very close to the FWD cal.
;
;7/8/14 JPC - Set FTUNPW Fine Tue Step for AIS from 0 to 1.  This the value from the FWD cal.  having idle issues.
;  Increased first PumpingEff point from E6 to E7 to match FWD cal.
;
;7/1/14 JPC - set second PumpingEff point to E6 to match FWD (Neil) cal and remove observed lean spot around 3500 rpm.
;
;4/19/13 - JPC - Migrated previous LMv13 cal to Boost Button 22_ATX_S-IV cal.   So the stage IV cal with G-head spark curve.
;
;6/10/12 - Modified by Jeff C. for a G-head using data from the 85_22_T1_795 cal.  These tables changed
;  AdvanceFromMapCold
;  AdvanceFromMapWarmFull
;  AdvanceFromMapWarmPart
;  AdvanceFromRPM
;
; ***********************************************************************
;
; Revision History
;
;
; 10/12/10 - Complete re-write of the code starting with a fresh dis-assembled
;            source. Converted naming conventions to be common with T-SMEC and
;            T_SBEC whereever possible for variables, table data and
;            subroutines.
;          - Added Battery Volts Target for WOT operation. Allows you to set a
;            different bat volts at WOT to either disable the alternator
;            (by setting the value low) or to increase the output (by setting
;            it high).
;
; 02/01/11 - Fixed the definitions for STRNTR_SparkStartRunTransferPointRpm and
;            RNSTTR_SparkRunStartTransferPointRpm that was causing a starting
;            issue.
;
; 02/25/11 - Moved the relative position of the Turbonator ID bytes. They were
;            causing the 0x55AA security bytes to be moved from the 5th byte to
;            the 6th byte resulting in COP errors.
;
; 05/18/11 - Updated these decel MAP constants to be scaled with MAP.
;                    DMDCIC_DeltaMAPLeanoutIncrement
;                    DMDCDC_DeltaMAPLeanoutDecrement
;                    DMLMT_DeltaMAPLeanoutLimit
;
; 06/07/11 - Updated template to MPT2 Format.
;          - Added Selective Bank Enrichment values.
;
; ***********************************************************************
;mprevisionend
; Rom Area
; ***********************************************************************

    .msg "Assembling Data Structures..." ; these are just messages to display during assemble to let you know what's going on...


;mpfuelparms 6000,60,56,3.79,.760_E10_Eth,2.2
;mpfuelnone1 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpfuelnone2 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpfuelpart1 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpfuelpart2 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpfuelfull1 12.5,12.5,12.5,12.5,12.5,12.5,12.5,12.5,12.5,12.5,12.5,12.5,12.5,12.5,12.5,12.5,12.5,12.5,12.5,12.5,12.5,11.8,11.8,11.8,11.8,11.8,11.8,11.8,11.8,11.8,11.5
;mpfuelfull2 11.5,11.5,11.5,11.5,11.5,10.92,10.84,10.76,10.68,10.6,10.52,10.44,10.36,10.28,10.2,10.12,10.04,9.96,9.88,9.8,9.72,9.64,9.56,9.48,9.4,9.32,9.24,9.16,9.08,9
RomBegin:

	;.org	0xc000
ENDITM_ECUID:
;mpgroupstart Boost_-_Target_Lookup\
;Boost\
;mpgroupend
;mpgroupstart Boost_Control\WG_Control\
;Boost\Boost - WG Control\
;mpgroupend
;mpgroupstart Fuel\O2_Feedback_Control\Adaptive_memory\
;Fuel\O2 Feedback Control\Fuel - Adaptive memory\
;mpgroupend
;mpgroupstart Fuel\O2_Feedback_Control\O2_Controller_Ramps\
;Fuel\O2 Feedback Control\Fuel - O2 Controller Ramps\
;mpgroupend
;mpgroupstart Fuel\O2_Feedback_Control\O2_Controller\
;Fuel\O2 Feedback Control\Fuel - O2 Controller\
;mpgroupend
;mpgroupstart Fuel_-_Adaptive_Memory_Timer\
;Fuel\
;mpgroupend
;mpgroupstart Fuel\Modifiers\
;Fuel\Fuel - Modifiers\
;mpgroupend
;mpgroupstart Fuel\Running\
;Fuel\Fuel - Running\
;mpgroupend
;mpgroupstart Fuel\Selective_Bank_Enrichment\
;Selective Bank Enrichment - Enable in cal setup. Used for Log setups only.
;mpgroupend
;mpgroupstart Fuel\Starting\
;Starting Fuel
;mpgroupend
;mpgroupstart Fuel\Transient_Enrichment\
;Fuel\Fuel - Transient Enrichment\
;mpgroupend
;mpgroupstart Fuel\Transient_Enrichment\PumpShot_Calculation\
;Fuel\Fuel - Transient Enrichment\PumpShot Calculation\
;mpgroupend
;mpgroupstart Turbonator_Features\Flash_CE_on_Knock\
;Turbonator - Alky Injection\Turbonator - Flash CE on Knock\
;mpgroupend
;mpgroupstart Turbonator_Features\Shift_Light\
;Turbonator - Alky Injection\Turbonator - Shift Light\
;mpgroupend
;mpgroupstart Turbonator_Features\Staging_Limiter\
;Turbonator - Alky Injection\Turbonator - Staging Limiter\
;mpgroupend
;mpgroupstart Turbonator_Features\Voltage_Regulator\
;Turbonator - Alky Injection\Turbonator - Voltage Regulator\
;mpgroupend
;mpgroupstart Turbonator_-_Alky_Injection\
;Turbonator\
;mpgroupend
;mpgroupstart Spark\Start_to_Run_Transfer\
;Spark - Adaptive Retard\Spark - Start to Run Transfer\
;mpgroupend
;mpgroupstart Spark\Scatter_Control\
;Spark - Adaptive Retard\Spark - Scatter Control\
;mpgroupend
;mpgroupstart Spark\Normal_Advance\
;Spark - Adaptive Retard\Spark - Normal Advance\
;mpgroupend
;mpgroupstart Spark\Knock_Retard\
;Spark - Adaptive Retard\Spark - Knock Retard\
;mpgroupend
;mpgroupstart Spark\Anti-Lag_Retard\
;Spark - Adaptive Retard\Spark - Anti-Lag Retard\
;mpgroupend
;mpgroupstart Utility\On-Board_Diagnostics\
;Setup - Cal Configuration\Setup - On-Board Diagnostics\
;mpgroupend
;mpgroupstart Spark_-_Adaptive_Retard\
;Spark\
;mpgroupend
;mpgroupstart Setup\Transfer_Functions\
;Setup - Cal Configuration\Setup - Transfer Functions\
;mpgroupend
;mpgroupstart Utility\On-Board_Diagnostics\T-Stat_Diagnostics\
;Setup - Cal Configuration\Setup - T-Stat Diagnostics\
;mpgroupend
;mpgroupstart AC_Control\
;Utility\AC Control\
;mpgroupend
;mpgroupstart Baro_Read\
;Utility\Baro Read\
;mpgroupend
;mpgroupstart Cruise_Control\
;Utility\Cruise Control\
;mpgroupend
;mpgroupstart Purge_Control\
;Utility\
;mpgroupend
;mpgroupstart Setup_-_Cal_Configuration\
;Setup\
;mpgroupend
;mpgroupstart Fuel\PumpShot_Calculation\MAP_PumpShot\
;Fuel\Transient Enrichment\PumpShot Calculation\MAP PumpShot\
;mpgroupend
;mpgroupstart Fuel\PumpShot_Calculation\TPS_PumpShot\
;Fuel\Transient Enrichment\PumpShot Calculation\TPS PumpShot\
;mpgroupend
;mpgroupstart Idle\AIS_Decel\
;Idle - AIS Control\Idle - AIS Decel\
;mpgroupend
;mpgroupstart Idle_-_AIS_Control\
;Idle\
;mpgroupend
;mpgroupstart Boost_Control\
;Boost control\
;mpgroupend
;mpgroupstart Boost_Control\Target_Lookup\
;Boost control\Target Lookup\
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
    ;mpgrp Setup\Cal_ID\
    ;mptbladdr 0xC000
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ECU_ID
    ;mptblcname ENDITM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ENDITM_is_a_critical_16-bit_calibration_identifier_placed_at_the_very_beginning_of_the_calibration_ROM_table_structure_(address_$C000,_offset_$0092)._Tuning_Usage:_When_modifying_custom_calibrations_in_MPTune,_updating_or_modifying_this_identifier_is_typically_handled_automatically_or_left_intact._Changing_this_identifier_alters_what_model_number_displays_on_scan_tools_(e.g._Snap-on_MT2500_or_DRB-II).
    .word 0x0078                     ;Point 1

	;.org	0xc002
UnknownCodeBits:
    ;mpgrp Setup\
    ;mptbladdr 0xC002
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname Unknown_Code
    ;mptblcname UNKWN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc UNKWN_is_a_16-bit_word_located_at_$C002_(offset_$009F)_in_the_calibration_header._Tuning_Recommendations:_Leave_unchanged_at_0x0041._Modifying_this_value_has_no_effect_on_engine_performance_or_road_drivability,_but_preserving_it_ensures_alignment_with_factory_binary_templates.
    .word 0x00EA                     ;Point 1

	;.org	0xc004
HuntsvilleTesterCode:
    ;mpgrp Setup\Cal_ID\
    ;mptbladdr 0xC004
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname Huntsville_Test_Code
    ;mptblcname HUNTSV
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HUNTSV_is_a_16-bit_identifier_residing_at_$C004_(offset_$0082)_in_the_ROM_header._Chrysler_engine_control_modules_were_manufactured_at_Chrysler's_Huntsville_Electronics_division_in_Huntsville,_Alabama._Tuning_Recommendations:_Leave_at_0xE844._It_is_non-executable_calibration_data_and_does_not_alter_engine_fueling,_boost,_or_spark_mapping.
    .word 0xE844                     ;Point 1

	;.org	0xc006
IPLMSK_PowerLossLightMask:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0xC006
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PowerLossLightMask
    ;mptblcname IPLMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc IPLMSK_is_an_8-bit_diagnostic_control_mask_that_determines_which_electronic_sensor_and_circuit_faults_cause_the_dashboard_'Power_Loss'_/_'Check_Engine'_lamp_to_illuminate._Custom_Warning_Light_Setup:_If_running_a_dedicated_race_car_or_custom_conversion_and_you_want_to_prevent_non-critical_sensor_faults_from_turning_on_the_dashboard_light,_you_can_selectively_clear_corresponding_bits_in_IPLMSK.
    ;mpchoices ChargeTemp_Sensor  CoolantTemp_Sensor  Charging  bit3  BatVolts  Map_Signal  Tps_Signal  Map_Pneumatic
    .byte 0xEB                       ;Point 1

	;.org	0xc007
IPLMSK2_PowerLossLightMask2:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0xC007
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PowerLossLightMask2
    ;mptblcname IPLMSK2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc IPLMSK2_provides_the_second_tier_of_fault-masking_for_dashboard_warning_light_activation._Wastegate_Solenoid_Elimination:_If_you_remove_the_factory_electronic_wastegate_solenoid_to_install_a_standalone_manual_boost_controller_(MBC)_or_electronic_boost_controller,_the_ECU_will_detect_an_open_circuit_and_set_Fault_Code_32.
    ;mpchoices bit0  bit1  bit2  Wastegate  InjectorFault  bit5  MajorFault  bit7
    .byte 0x3F                       ;Point 1

	;.org	0xc008
SpecialBytes:
    ;mpgrp Setup\Cal_ID\
    ;mptbladdr 0xC008
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname Setup_bytes
    ;mptblcname SETUP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SETUP_is_an_alternating-bit_signature_word_(0x55AA,_binary_01010101_10101010)_positioned_at_$C008_(offset_$00D5)._In_embedded_microprocessor_systems,_0x55AA_is_the_industry-standard_alternating_test_pattern_used_to_detect_shorted_or_floating_address_and_data_bus_lines_on_printed_circuit_boards._Do_Not_Modify:_Always_retain_0x55AA._Diagnostic_tools_and_burning_utilities_use_this_pattern_to_confirm_binary_alignment.
    .word 0x55AA                     ;Point 1

SourceCodeVersionID:
    ;mpgrp Setup\Cal_ID\
    ;mptbladdr 0xC00A
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname SourceCodeVersionID
    ;mptblcname SRCID
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SRCID_defines_the_unique_architecture_and_version_identification_number_for_the_engine_management_firmware._In_the_Turbonator_codebase_hierarchy:_High_Byte_($0A):_Designates_the_T-LM_(Turbo_Logic_Module)_codebase_family._Critical_Compatibility_Identifier:_Never_change_SRCID_unless_you_are_deliberately_porting_a_calibration_to_a_newer_codebase_version._If_SRCID_does_not_match_0x0A0D,_MPTune_may_reject_the_file_or_misalign_table_addresses.
    .word 0x0A0D                     ;Point 1
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

	;.org	0xc00a
; Manual00_AutomaticFF:
;        chem2 group "Setup - Cal Configuration"
;        .chem 3 n AutomaticFF in_desc 0 255 in Y 0 255 out MANUAL00 Detailed_Description
;        chem2 byte MANUAL00 use "in desc" 0 255 "in" "Detailed Description"
;        .byte   0xFF
; 
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
; 
CONFIG_ConfigurationFlags:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0xC00C
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname ConfigurationFlags
    ;mptblcname CONFIG
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc CONFIG_is_one_of_the_most_powerful_and_versatile_calibration_bytes_in_the_entire_ECU_firmware._Manual_vs_Auto_Swap:_When_swapping_a_manual_transmission_into_an_automatic_car_(or_vice_versa),_toggle_Bit_7_(cfg_ATX)._This_reconfigures_idle_decel_dashpot_routines,_target_idle_tables,_and_rev_limiters._Knock_CEL_Flash:_Enabling_Bit_6_(cfg_FlashCE,_+$40)_provides_real-time_in-cockpit_visual_knock_feedback_without_needing_a_scan_tool_or_laptop.
    ;mpchoices Anti-Lag_Retard  Staging_Limiter(2-step)  Boost_Switch_Polarity_toggle  Switchable_Boost_mod  Shift_Light_mod  Alky_Inj_mod  FlashCE_Mod  Auto_Trans_Bit
    .byte 0xC0                       ;Point 1
       cfg_ATX			= $%10000000	; Auto trans (if set)
       cfg_FlashCE		= $%01000000	; Flash the check engine light on knock
       cfg_BankEnrich		= $%00100000	; use selective bank enrichment
       cfg_ShiftLight	        = $%00010000	; Shift Light enabled (also uses Purge/EGR solenoids, cannot both be enabled)
       cfg_SwBoost		= $%00001000	; Switchable boost
       cfg_BstSwPol		= $%00000100	; Switchable boost polarity toggle
       cfg_StageLim		= $%00000010	; Staging Limiter enable
       cfg_AntiLag		= $%00000001	; Anti-Lag Retard
;
; OPTN1_CalCustomOptionConfigFlags1:
;        chem2 group "Setup - Cal Configuration"
;        .chem 5 n CalCustomOptionConfigFlags1 IN 0 255 X OUT 0 255 Y OPTN1 These_are_options_available_to_enable_in_this_custom_codebase. Switchable_boost_enable Boost_switch_polarity Staging_limiter_Enable Staging_Limiter_sw_polarity FlashCE_On_Knock_Enable Hi-Speed_Logger_Enable Anti-Lag_Enable Shift_Light_Enable
;        chem2 byte OPTN1 bit 0 "Switchable boost enable" bit 1 "Boost switch polarity" bit 2 "Staging limiter Enable" bit 3 "Staging Limiter sw polarity" bit 4 "FlashCE On Knock Enable" bit 5 "Hi-Speed Logger Enable" bit 6 "Anti-Lag Enable" bit 7 "Shift Light Enable" "These are options available to enable in this custom codebase."
;        .byte   0x00
;     opt_ShiftLight		 = $%10000000	 ; Shift light enabled
;     opt_AntiLag			 = $%01000000	 ; Use the Anti-Lag retard routine
;     opt_HiSpdLog	 	 = $%00100000	 ; Use the hi-speed logger interrupt routine
;     opt_FlashCE 		 = $%00010000	 ; Flash the CE light when knock is indicated
;     opt_StagePol	 	 = $%00001000	 ; Staging Limiter switch polarity
;     opt_StageLim		 = $%00000100	 ; Staging limiter (2-step) enable
;     opt_SwBstPol		 = $%00000010	 ; Switchable boost switch polarity
;     opt_SwBoost 		 = $%00000001	 ; Switchable boost enable
; 
; OPTN2_CalCustomOptionConfigFlags2:
;        chem2 group "Setup - Cal Configuration"
;        .chem 5 n CalCustomOptionConfigFlags2 IN 0 255 X OUT 0 255 Y OPTN2 These_are_options_available_to_enable_in_this_custom_codebase. Spark-based_Rev_Limiter Fuel-based_Rev_Limiter Suppress_EMR Not_Used Not_Used Not_Used Not_Used Not_Used
;        chem2 byte OPTN2 bit 0 "Spark-based Rev Limiter" bit 1 "Fuel-based Rev Limiter" bit 2 "Suppress EMR" bit 3 "Not Used" bit 4 "Not Used" bit 5 "Not Used" bit 6 "Not Used" bit 7 "Not Used" "These are options available to enable in this custom codebase."
;        .byte   0x02
;     opt_Bit7  			 = $%10000000	 ;
;     opt_Bit6			 = $%01000000	 ;
;     opt_Bit5	     		 = $%00100000	 ;
;     opt_Bit4 			 = $%00010000	 ;
;     opt_Bit3	     		 = $%00001000	 ;
;     opt_SupressEMR		 = $%00000100	 ; Suppress the EMR (Emiss Maint Reminder) Code
;     opt_FuelRevLim		 = $%00000010	 ; Use the fuel-based rev limiter
;     opt_SprkRevLim 		 = $%00000001	 ; Use the spark-based rev limiter


	;.org	0xc00b
CLDMAP_AdvanceFromMAPCold:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0xC00D
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname AdvanceFromMAPCold
    ;mptblcname CLDMAP
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Spark_Advance -64 64 Degrees
    ;mptbldesc CLDMAP_defines_the_base_MAP-dependent_ignition_advance_curve_used_exclusively_when_the_engine_coolant_temperature_is_below_normal_operating_temperature_(TMPSWP)._During_cold_operation,_fuel_atomization_is_poor_and_combustion_chamber_wall_quenching_slows_down_the_initial_flame_front_speed._The_value_looked_up_from_CLDMAP_is_placed_into_Temp0_and_later_combined_with_RPM_advance_(GOVNER)_to_calculate_total_ignition_timing.
    ;mpmapaxis x
    .byte 0x04                       ;Number of points in table
    .byte 0x2B, 0x0A, 0x01, 0x80     ;Point 1
    .byte 0x3F, 0x28, 0xFF, 0xEE     ;Point 2
    .byte 0x4D, 0x27, 0xFF, 0x9C     ;Point 3
    .byte 0x9C, 0x08                 ;Point 4

	;.org	0xc01a
CLDLMT_LimitForColdMapAtClosedThrottle:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0xC01C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LimitForColdMapAtClosedThrottle
    ;mptblcname CLDLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y -200 260 out
    ;mptbldesc CLDLMT_is_a_safety_clamp_constant_that_limits_the_maximum_advance_that_the_cold_MAP_table_(CLDMAP)_can_produce_while_the_engine_is_at_closed_throttle_(idling_or_trailing_throttle_on_overrun)._During_cold_warm-up,_manifold_vacuum_can_be_erratic_due_to_cold_friction,_high_idle_AIS_air_bypass,_and_hunting_engine_speeds._Increasing_the_Value_(Higher_Clamp):_Effect_on_Total_Timing:_Allows_more_cold_MAP_advance_during_closed-throttle_idle_and_decel.
    .byte 0x14                       ;Point 1

PartThrottleTiming:
    ;mpgrp Calculated_Tables\
    ;mptbladdr 0xC01D
    ;mptbltype 16
    ;mpsubtype n
    ;mptbllname PartThrottleTotalTiming
    ;mptblcname PTTIME
    ;mpxaxis GOVNER 0 8192 rpm
    ;mpyaxis HOTMAP -15 15 Degrees
    ;mptbldesc Part_throttle_total_timing.
    ;mp3dxtable GOVNER 
    ;mpxintv 500
    ;mp3dytable HOTMAP 
    ;mpyintv 1
    ;mp3dmintable MINADV
    ;mp3dmaxtable SPKLMT
    .byte 0x2D                       ;Number of rows in table
    .byte 0x11                       ;Number of cols in table
    .byte 0x00                       ;00 = unsigned, FF = signed
	
FullThrottleTiming:
    ;mpgrp Calculated_Tables\
    ;mptbladdr 0xC020
    ;mptbltype 16
    ;mpsubtype n
    ;mptbllname FullThrottleTotalTiming
    ;mptblcname FTTIME
    ;mpxaxis GOVNER 0 8192 rpm
    ;mpyaxis WOTMAP -15 15 Degrees
    ;mptbldesc Full_throttle_total_timing.
    ;mp3dxtable GOVNER 
    ;mpxintv 500
    ;mp3dytable WOTMAP 
    ;mpyintv 1
    ;mp3dmintable MINADV
    ;mp3dmaxtable SPKLMT
    .byte 0x2D                       ;Number of rows in table
    .byte 0x11                       ;Number of cols in table
    .byte 0x00                       ;00 = unsigned, FF = signed

	;.org	0xc01b
WOTMAP_AdvanceFromMAPWarmFull:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0xC023
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname AdvanceFromMAPWarmFull
    ;mptblcname WOTMAP
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Spark_Advance -64 64 Degrees
    ;mptbldesc WOTMAP_is_the_primary_full-throttle_/_wide-open_throttle_(WOT)_load_advance_table._Total_full-throttle_ignition_timing_is_calculated_as_the_base_RPM_advance_(GOVNER)_plus_the_MAP_advance_from_WOTMAP:_Total_WOT_Advance_~_GOVNER(RPM)_+_WOTMAP(MAP)_-_AntiLagRetard_-_KnockRetard_+/-_BaroTrims_Increasing_Table_Values_(Adding_Timing_in_WOTMAP):_Effect_on_Total_Timing:_Advances_full-throttle_ignition_timing_across_the_corresponding_boost/MAP_points.
    ;mpmapaxis x
    .byte 0x07                       ;Number of points in table
    .byte 0x23, 0x2A, 0xFF, 0xEA     ;Point 1
    .byte 0x3A, 0x28, 0xFF, 0x3A     ;Point 2
    .byte 0x59, 0x10, 0xFF, 0x66     ;Point 3
    .byte 0x77, 0xFE, 0xFF, 0x95     ;Point 4
    .byte 0x8F, 0xF4, 0xFF, 0x80     ;Point 5
    .byte 0xB3, 0xE2, 0xFF, 0x65     ;Point 6
    .byte 0xFF, 0xB4                 ;Point 7

	;.org	0xc02e
HOTMAP_AdvanceFromMAPWarmPart:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0xC03E
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname AdvanceFromMAPWarmPart
    ;mptblcname HOTMAP
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Spark_Advance -64 64 Degrees
    ;mptbldesc HOTMAP_is_the_primary_warm_part-throttle_load_advance_table._Total_part-throttle_ignition_timing_is_the_sum_of_RPM_advance_(GOVNER),_the_effective_part-throttle_MAP_advance_derived_from_HOTMAP,_and_barometric/temperature_trims:_Total_Timing_~_GOVNER(RPM)_+_max(WOTMAP,_HOTMAP_-_Retard)_+/-_Trims_Increasing_Table_Values_(Adding_Timing_in_HOTMAP):_Effect_on_Total_Timing:_Increases_part-throttle_advance_across_the_corresponding_MAP_region.
    ;mpmapaxis x
    .byte 0x05                       ;Number of points in table
    .byte 0x3B, 0x2E, 0xFF, 0x22     ;Point 1
    .byte 0x59, 0x14, 0xFF, 0x33     ;Point 2
    .byte 0x77, 0xFC, 0xFF, 0x95     ;Point 3
    .byte 0xB3, 0xE3, 0xFF, 0x8D     ;Point 4
    .byte 0xFF, 0xC1                 ;Point 5

	;.org	0xc049
ARADVR_AdaptiveRetardAdvanceRatioFromMAP:
    ;mpgrp Spark\Adaptive_Retard\
    ;mptbladdr 0xC051
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardAdvanceRatioFromMAP
    ;mptblcname ARADVR
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc ARADVR_is_a_10-point_lookup_table_that_blends_ignition_timing_between_the_warm_part-throttle_advance_curve_(HOTMAP)_and_the_full-throttle_advance_curve_(WOTMAP)_as_the_throttle_opens._Increasing_values_pulls_timing_toward_the_safer_WOT_curve_sooner_during_mid-throttle_boost_spool-up;_decreasing_values_retains_higher_part-throttle_advance_longer_for_crisper_response.
    .byte 0x1F                       ;Point 1

	;.org	0xc04a
FACALC_AdaptiveRetardEnable:
    ;mpgrp Spark\Adaptive_Retard\
    ;mptbladdr 0xC052
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardEnable
    ;mptblcname FACALC
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc FACALC_is_a_mathematical_mode-switch_flag_that_dictates_the_arithmetic_operation_(subtraction_versus_addition)_applied_to_the_part-throttle_boost_blend_timing_calculation._The_CPU_evaluates_only_the_most_significant_bit_(bit_7)_of_FACALC_via_the_branch-if-minus_(bmi)_opcode:_Stock_Setting_(0xFF_/_Negative_/_Bit_7_=_1):_Function:_Subtractive_Mode_(Timing_Retard)._Effect_on_Total_Timing:_Subtracts_the_ARADVR_calculation_(Temp1)_from_HOTMAP.
    .byte 0xFF                       ;Point 1

	;.org	0xc04b
TMPSWP_EngTempSwitchPointForSparkAdvance:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0xC053
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngTempSwitchPointForSparkAdvance
    ;mptblcname TMPSWP
    ;mpxaxis IN 0 255 X
    ;mpyaxis Coolant_Temperature -200 260 F
    ;mptbldesc TMPSWP_is_the_primary_coolant_temperature_threshold_that_divides_the_ECU's_ignition_timing_logic_into_two_distinct_modes:_Cold_Engine_Operation_and_Warm_(Normal)_Engine_Operation._Increasing_the_Value_(Higher_Temp_Threshold):_What_it_does:_Forces_the_engine_to_stay_in_cold-engine_ignition_mode_longer_into_its_warmup_cycle._Effect_on_Total_Timing:_Extends_the_use_of_CLDMAP.
    .byte 0xA6                       ;Point 1

	;.org	0xc04c
ABCBAS_AdvanceBaroCompensationBaseFromRPM:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0xC054
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AdvanceBaroCompensationBaseFromRPM
    ;mptblcname ABCBAS
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Factor 0 1 out
    ;mptbldesc ABCBAS_provides_the_RPM-dependent_baseline_ceiling_for_the_ECU's_barometric_pressure_spark_compensation_calculation._The_barometric_calculation_determines_a_maximum_allowable_MAP_advance_ceiling_(_A_):_A_=_ABCBAS(RPM)_-_[(ABCFRP(RPM)_*_ABCFBR(BaroPressure)_/_256)]_If_A_<_Temp0_,_the_ECU_clamps_base_MAP_advance_to_A_(provided_A_>=_MINADV_).
    .byte 0x02                       ;Number of points in table
    .byte 0x3F, 0x08, 0x02, 0x00     ;Point 1
    .byte 0x4B, 0x20                 ;Point 2

	;.org	0xc057
ABCFBR_AdvanceBaroCompensationFactorFromBaro:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0xC05B
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AdvanceBaroCompensationFactorFromBaro
    ;mptblcname ABCFBR
    ;mpxaxis Baro 0 44.1 psi
    ;mpyaxis Spark_Advance_Scale 0 4 out
    ;mptbldesc ABCFBR_provides_the_barometric_pressure_weighting_factor_for_the_ECU's_altitude_ignition_timing_limiter._Increasing_Table_Values_(Higher_Baro_Factor):_Effect_on_Total_Timing:_Retards_total_ignition_timing_more_aggressively_as_elevation_increases_by_pulling_more_timing_away_from_ABCBAS._Real-World_Driving_Feel:_Provides_an_extra_safety_margin_against_detonation_when_driving_high_in_the_mountains_where_intercoolers_and_radiators_are_less_effective.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x49, 0x04, 0xFF, 0x6E     ;Point 1
    .byte 0x50, 0x00                 ;Point 2

	;.org	0xc062
ABCFRP_AdvanceBaroCompensationFactorFromRPM:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0xC062
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AdvanceBaroCompensationFactorFromRPM
    ;mptblcname ABCFRP
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Spark_Advance_Scale 0 4 out
    ;mptbldesc ABCFRP_is_the_engine_speed_modifier_for_the_barometric_spark_compensation_system._Increasing_Table_Values_(Higher_RPM_Factor):_Effect_on_Total_Timing:_Pulls_more_timing_at_the_specified_RPMs_when_operating_at_altitude._Real-World_Driving_Feel:_Calms_mid-range_detonation_tendencies_when_driving_under_load_in_mountain_passes.
    .byte 0x02                       ;Number of points in table
    .byte 0x38, 0xFF, 0xEC, 0x62     ;Point 1
    .byte 0x45, 0x00                 ;Point 2

	;.org	0xc06d
MINADV_MinimumAdvance:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0xC069
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumAdvance
    ;mptblcname MINADV
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Advance 0 128 deg
    ;mptbldesc MINADV_is_an_absolute_minimum_safety_floor_applied_to_the_calculated_barometric_advance_limit._Increasing_the_Value_(Higher_Minimum_Floor):_Effect_on_Total_Timing:_Ensures_the_engine_never_runs_less_than_this_floor_from_the_baro_limiter._Real-World_Driving_Feel:_Protects_against_excessive_EGT_buildup_and_sluggish_performance_at_extreme_altitudes_(such_as_Pike's_Peak_or_mountain_passes_over_10,000_ft).
    .byte 0x04                       ;Point 1

	;.org	0xc06e
RETTPS_RetardFromTPS:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0xC06A
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname RetardFromTPS
    ;mptblcname RETTPS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Advance 0 128 deg
    ;mptbldesc RETTPS_is_the_lookup_table_that_defines_how_many_degrees_of_ignition_timing_are_pulled_out_as_a_function_of_throttle_opening_speed_(_DeltaTPS_)._The_value_looked_up_from_RETTPS_is_subtracted_directly_from_intermediate_total_advance:_Total_Advance_=_max(0,_Advance_-_RETTPS(DeltaTPS))_Increasing_Table_Values_(More_Retard_per_DeltaTPS_):_Effect_on_Total_Timing:_Retards_ignition_timing_more_aggressively_during_rapid_throttle_stabs.
    .byte 0x03                       ;Number of points in table
    .byte 0x05, 0x00, 0x01, 0x33     ;Point 1
    .byte 0x1E, 0x1E, 0x00, 0x72     ;Point 2
    .byte 0x4B, 0x32                 ;Point 3

	;.org	0xc079
RTMAPE_RetardFromTPSEnableAboveThisMAP:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0xC075
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname RetardFromTPSEnableAboveThisMAP
    ;mptblcname RTMAPE
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc RTMAPE_is_the_manifold_pressure_enable_threshold_for_the_Tip-In_/_Rapid_Throttle_Opening_Retard_routine_(CheckForTPSRetard)._Increasing_the_Value_(Higher_MAP_Threshold):_What_it_does:_Requires_higher_boost_pressure_before_rapid-throttle_ignition_retard_is_allowed_to_activate._Real-World_Driving_Feel:_Prevents_tip-in_retard_during_low-boost_throttle_adjustments,_providing_sharper_throttle_response.
    ;mpmapaxis y
    .byte 0x62                       ;Point 1

	;.org	0xc07a
RTRPME_RetardFromTPSEnableAboveThisRPM:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0xC076
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RetardFromTPSEnableAboveThisRPM
    ;mptblcname RTRPME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 16384 rpm
    ;mptbldesc RTRPME_defines_the_minimum_engine_speed_required_before_the_ECU_will_apply_ignition_timing_retard_on_rapid_throttle_openings_(CheckForTPSRetard)._Increasing_the_Value_(Higher_RPM_Threshold):_Effect_on_Total_Timing:_Delays_TPS_transient_retard_to_higher_RPMs._Real-World_Driving_Feel:_Improves_low-to-mid_RPM_throttle_responsiveness_and_off-corner_punch,_but_increases_knock_risk_if_aggressive_spool-up_occurs_around_2,500-3,000_RPM.
    .byte 0x27                       ;Point 1

	;.org	0xc07b
RTTPSE_RetardFromTPSEnableAboveThisTPS:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0xC077
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RetardFromTPSEnableAboveThisTPS
    ;mptblcname RTTPSE
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis TPS 0 5 V
    ;mptbldesc RTTPSE_sets_the_minimum_baseline_throttle_position_voltage_required_before_rapid_throttle_opening_retard_can_be_engaged._Increasing_the_Value_(Higher_Baseline_TPS):_Effect_on_Total_Timing:_Restricts_TPS_transient_retard_to_transitions_occurring_higher_in_the_throttle_travel_range_(e.g.,_from_half-throttle_to_full-throttle)._Real-World_Driving_Feel:_Prevents_hesitation_during_mid-pedal_tip-ins.
    .byte 0x50                       ;Point 1

	;.org	0xc07c
GOVNER_AdvanceFromRPM:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0xC078
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AdvanceFromRPM2
    ;mptblcname GOVNER
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Spark_Advance 0 128 Degrees
    ;mptbldesc GOVNER_is_the_primary_engine_speed_advance_curve_(analogous_to_the_mechanical_/_centrifugal_advance_weights_in_a_traditional_distributor)._In_internal_combustion_engines,_the_time_available_for_the_air/fuel_charge_to_burn_decreases_proportionally_as_engine_RPM_increases.
    .byte 0x04                       ;Number of points in table
    .byte 0x20, 0x1C, 0x00, 0xE4     ;Point 1
    .byte 0x32, 0x2C, 0x00, 0x41     ;Point 2
    .byte 0x71, 0x3C, 0x00, 0x11     ;Point 3
    .byte 0xCC, 0x42                 ;Point 4

	;.org	0xc08b
SKAPRD_SparkImmediateSwitchToRunAboveThisRpm:
    ;mpgrp Spark\Start_to_Run_Transfer\
    ;mptbladdr 0xC087
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname SparkImmediateSwitchToRunAboveThisRpm
    ;mptblcname SKAPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis EPPs 0 65535 epps
    ;mptbldesc SKAPRD_is_the_instantaneous_engine_start-to-run_transfer_threshold._Increasing_the_Value_(Lower_RPM_Threshold):_What_it_does:_Allows_a_lower_RPM_flare_to_trigger_immediate_Run_Mode._Real-World_Driving_Feel:_The_ECU_starts_controlling_dynamic_spark_advance_sooner_after_cranking.
    .word 0x0092                     ;Point 1

	;.org	0xc08d
SRTIME_SparkEPPsNeededToBeAboveSR_Hot:
    ;mpgrp Spark\Start_to_Run_Transfer\
    ;mptbladdr 0xC089
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkEPPsNeededToBeAboveSR_Hot
    ;mptblcname SRTIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SRTIME_defines_the_number_of_consecutive_Engine_Position_Pulses_(EPPs)_that_the_engine_must_maintain_above_the_start-to-run_speed_threshold_(STRNTR)_before_transferring_spark_control_to_Run_Mode_when_the_engine_is_warm/hot._When_starting_a_warm_engine,_cylinder_compression_is_consistent_and_combustion_catches_quickly._Increasing_the_Value_(More_Pulses_Required):_What_it_does:_Keeps_the_engine_in_cranking_spark_mode_longer_when_warm.
    .byte 0x04                       ;Point 1

	;.org	0xc08e
SRTIME2_SparkEPPsNeededToBeAboveSR_Cold:
    ;mpgrp Spark\Start_to_Run_Transfer\
    ;mptbladdr 0xC08A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkEPPsNeededToBeAboveSR_Cold
    ;mptblcname SRTIME2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SRTIME2_defines_the_number_of_consecutive_Engine_Position_Pulses_(EPPs)_above_STRNTR_required_to_transfer_spark_control_into_Run_Mode_when_the_engine_is_cold._Cold_engines_suffer_from_thick_engine_oil_drag,_incomplete_fuel_vaporization,_and_uneven_cylinder-to-cylinder_combustion._Increasing_the_Value_(More_Pulses):_What_it_does:_Demands_more_consecutive_pulses_above_600_RPM_before_allowing_cold_running_spark_tables_(CLDMAP)_to_engage.
    .byte 0x04                       ;Point 1

	;.org	0xc08f
SRTMTP_SparkTempSwitchPointFor_SRTIME:
    ;mpgrp Spark\Start_to_Run_Transfer\
    ;mptbladdr 0xC08B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkTempSwitchPointFor_SRTIME
    ;mptblcname SRTMTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc SRTMTP_is_the_coolant_temperature_switch_point_that_selects_between_the_hot_(SRTIME)_and_cold_(SRTIME2)_start-to-run_transfer_pulse_counters._Increasing_the_Value_(Higher_Temp_Threshold):_What_it_does:_Classifies_warm_engines_as_"cold"_until_they_reach_a_higher_temperature._Real-World_Driving_Feel:_Applies_the_cold_pulse_counter_(SRTIME2)_across_a_wider_operating_temperature_range.
    .byte 0xB0                       ;Point 1

	;.org	0xc090
STRNTR_SparkStartRunTransferPointRpm:
    ;mpgrp Spark\Start_to_Run_Transfer\
    ;mptbladdr 0xC08C
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname SparkStartRunTransferPointRpm
    ;mptblcname STRNTR
    ;mpxaxis Coolant_Temp -200 260 Degrees
    ;mpyaxis DistOFs 0 65535 mSec
    ;mptbldesc STRNTR_defines_the_primary_engine_speed_threshold_required_to_transfer_from_Start_Mode_into_Run_Mode._During_starter_cranking,_engine_rotation_is_slow_(~150-250_RPM)_and_irregular._Increasing_the_Value_(Lower_RPM_Threshold):_What_it_does:_Allows_the_engine_to_transfer_to_Run_Mode_at_a_lower_RPM_(e.g.,_500_RPM)._Real-World_Driving_Feel:_Enables_earlier_engagement_of_dynamic_spark_advance_and_idle_speed_AIS_stepper_motor_control.
    .word 0x00C3                     ;Point 1
       ;.byte   0xff
       ;.byte   0xff

	;.org	0xc09b
RNSTTR_SparkRunStartTransferPointRpm:
    ;mpgrp Spark\Start_to_Run_Transfer\
    ;mptbladdr 0xC08E
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname SparkRunStartTransferPointRpm
    ;mptblcname RNSTTR
    ;mpxaxis Coolant_Temp -200 260 Degrees
    ;mpyaxis DistOFs 0 65535 mSec
    ;mptbldesc RNSTTR_is_the_stall-detection_hysteresis_threshold_that_drops_the_ECU_back_from_Run_Mode_into_Start_Mode._Increasing_the_Value_(Lower_RPM_Threshold):_What_it_does:_Allows_the_engine_to_drop_lower_in_speed_(e.g.,_300_RPM)_before_conceding_that_it_has_stalled._Real-World_Driving_Feel:_Prevents_premature_switching_into_cranking_mode_when_lugging_the_engine_at_very_low_speeds,_but_can_cause_sluggish_recovery_if_the_engine_actually_dies.
    .word 0x011B                     ;Point 1
       ;.byte   0xff
       ;.byte   0xff

	;.org	0xc0a1
SPKLMT_TotalAdvanceAllowed:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0xC090
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AdvanceFromRpmMAX
    ;mptblcname SPKLMT
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Spark_Advance -64 64 Degrees
    ;mptbldesc SPKLMT_is_the_hard_maximum_ceiling_curve_on_total_ignition_timing_across_engine_speed._Increasing_Table_Values_(Raising_the_Ceiling):_Effect_on_Total_Timing:_Allows_higher_total_timing_during_light-load_high-RPM_highway_cruising._Real-World_Driving_Feel:_Can_improve_fuel_economy_slightly_on_light_cruise,_but_gains_diminish_past_~42-45_deg_on_typical_8-valve_2.2L/2.5L_combustion_chambers.
    .byte 0x02                       ;Number of points in table
    .byte 0x7D, 0x6A, 0xFF, 0x9F     ;Point 1
    .byte 0xDC, 0x46                 ;Point 2

	;.org	0xc0a8
PNIDLE_AdvanceRemovedIdleParkNeutral:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0xC097
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AdvanceRemovedIdleParkNeutral
    ;mptblcname PNIDLE
    ;mpxaxis Coolant_Temperature -200 260 F
    ;mpyaxis Spark_Advance -64 64 Degrees
    ;mptbldesc PNIDLE_provides_a_coolant_temperature-dependent_spark_advance_trim_applied_specifically_when_an_automatic_transmission_vehicle_is_in_Park_or_Neutral_at_idle_speeds._Increasing_Table_Values_(Adding_Timing_in_Park/Neutral):_Effect_on_Total_Timing:_Advances_idle_timing_when_in_Park_or_Neutral._Real-World_Driving_Feel:_Raises_idle_RPM_and_increases_vacuum_in_Park/Neutral.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0xc0af
PNRPM_EngineSpeedBelowWhich_PNIDLE_Enabled:
    ;mpgrp Spark\Normal_Advance\
    ;mptbladdr 0xC09A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineSpeedBelowWhich_PNIDLE_Enabled
    ;mptblcname PNRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 16384 RPM
    ;mptbldesc PNRPM_establishes_the_maximum_engine_speed_threshold_below_which_the_Park/Neutral_idle_spark_modifier_(PNIDLE)_is_permitted_to_operate._Park/Neutral_spark_compensation_is_designed_strictly_for_low-RPM_idle_stabilization._Increasing_the_Value_(Higher_RPM_Threshold):_Effect_on_Total_Timing:_Extends_Park/Neutral_idle_spark_trims_to_higher_engine_speeds.
    .byte 0x00                       ;Point 1

	;.org	0xc0b0
KNKRPM_MinRpmforKnockRetard:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0xC09B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinRpmforKnockRetard
    ;mptblcname KNKRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 16384 RPM
    ;mptbldesc KNKRPM_sets_the_minimum_engine_speed_required_for_the_ECU_to_activate_knock_retard._Increasing_the_Value_(Higher_RPM_Threshold):_What_it_does:_Knock_retard_will_remain_disabled_up_to_a_higher_RPM_(e.g.,_0x14_=_1,280_RPM)._Real-World_Driving_Feel:_Prevents_false_knock_retard_caused_by_noisy_mechanical_valve_gear,_aggressive_solid_lifters,_or_lightweight_flywheel_rattle_at_low_speeds.
    .byte 0x10                       ;Point 1

	;.org	0xc0b1
KNKOFS_DeltaAboveBaroFor_RTRDRT_and_KNKCNT_and_KNKCOR_incremented:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0xC09C
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaAboveBaroFor_RTRDRT_and_KNKCNT_and_KNKCOR_incremented
    ;mptblcname KNKOFS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 44.1 psi
    ;mptbldesc KNKOFS_is_the_manifold_pressure_boost_threshold_dividing_knock_retard_response_into_Vacuum_/_Low_Boost_Mode_versus_High_Boost_Mode._Increasing_the_Value_(Higher_Boost_Threshold):_What_it_does:_Extends_the_low-boost_retard_rate_(RTRDRT)_to_higher_boost_levels._Real-World_Driving_Feel:_Pulls_larger_chunks_of_timing_if_knock_occurs_in_the_5-8_psi_transition_zone.
    ;mpmapaxis y
    .byte 0x1F                       ;Point 1

	;.org	0xc0b2
RTRDRT_KnockRetardRateNoBoost:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0xC09D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardRateNoBoost
    ;mptblcname RTRDRT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Deg 0 128 Degrees
    ;mptbldesc RTRDRT_defines_the_step-size_of_knock_retard_applied_when_knock_occurs_out_of_boost_(under_vacuum_or_light_load_below_KNKOFS)._Increasing_the_Value_(Larger_Retard_Step):_Effect_on_Total_Timing:_Pulls_more_timing_(e.g.,_4.0_deg_or_5.0_deg)_on_the_very_first_knock_event._Real-World_Driving_Feel:_Extremely_fast_knock_suppression,_but_large_timing_drops_under_light_load_can_cause_a_brief_momentary_surge_or_hiccup_in_vehicle_feel.
    .byte 0x06                       ;Point 1

	;.org	0xc0b3
RTRDRT2_KnockRetardRateInBoost:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0xC09E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardRateInBoost
    ;mptblcname RTRDRT2
    ;mpxaxis IN 0 255 X
    ;mpyaxis Retard 0 128 deg
    ;mptbldesc RTRDRT2_defines_the_step-size_of_knock_retard_applied_when_knock_occurs_under_boost_(above_KNKOFS)._Increasing_the_Value_(Larger_Retard_Step_in_Boost):_Effect_on_Total_Timing:_Pulls_more_timing_(e.g.,_2.0_deg_or_2.5_deg)_on_each_knock_event_under_boost._Real-World_Driving_Feel:_Highly_protective_for_high-boost_setups_(18+_psi)_where_detonation_can_crack_piston_ring_lands_in_just_a_few_cycles,_but_may_feel_slightly_harsher_when_knock_occurs.
    .byte 0x03                       ;Point 1

	;.org	0xc0b4
INCSRT_KnockRetardIncreaseRate:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0xC09F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardIncreaseRate
    ;mptblcname INCSRT
    ;mpxaxis in_desc 0 255 retard
    ;mpyaxis Y 0 128 deg
    ;mptbldesc INCSRT_controls_the_decay_rate_/_recovery_rate_of_ignition_timing_after_a_knock_event_has_ended._When_the_ECU_detects_knock,_it_retards_ignition_timing_immediately._>_[!WARNING]_>_Bitmask_Rule:_INCSRT_is_a_binary_bitmask._It_MUST_ONLY_be_set_to_binary_power-of-two_minus_one_values:_0x00,_0x01,_0x03,_0x07,_0x0F,_0x1F,_0x3F,_0x7F,_or_0xFF._Using_intermediate_values_(e.g.,_0x10)_will_cause_erratic,_non-uniform_timing_recovery_rates.
    .byte 0x1F                       ;Point 1

	;.org	0xc0b5
KNKLIM_MaxKnockRetard:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0xC0A0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxKnockRetard
    ;mptblcname KNKLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Retard 0 128 Degrees
    ;mptbldesc KNKLIM_specifies_the_maximum_ceiling_on_knock_retard_applied_during_low-speed_transient_throttle_transitions._Increasing_the_Value_(Higher_Low-RPM_Retard_Cap):_Effect:_Allows_more_timing_to_be_pulled_during_low-RPM_tip-in_if_knock_is_detected._Real-World_Driving_Feel:_Extra_safety_if_an_engine_experiences_low-RPM_tip-in_detonation_under_heavy_load,_but_risks_deeper_hesitation_if_false_knock_occurs.
    .byte 0x04                       ;Point 1

	;.org	0xc0b6
THRKNK_DeltaAbove_MINTHR:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0xC0A1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaAbove_MINTHR
    ;mptblcname THRKNK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis TPS 0 5 Volts
    ;mptbldesc THRKNK_defines_the_throttle_opening_threshold_above_base_idle_position_required_to_trigger_the_low-RPM_knock_retard_limit_(KNKLIM)._Increasing_the_Value_(Higher_Throttle_Delta):_Requires_a_larger_throttle_opening_before_the_low-RPM_KNKLIM_clamp_activates,_allowing_the_standard_RETMAX_curve_to_operate_over_a_broader_throttle_range._Decreasing_the_Value_(Lower_Throttle_Delta):_Engages_the_low-RPM_KNKLIM_retard_clamp_on_lighter_pedal_movements.
    .byte 0x53                       ;Point 1

	;.org	0xc0b7
KLMRPM_MinKnockDetectRpm:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0xC0A2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinKnockDetectRpm
    ;mptblcname KLMRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 RPM
    ;mptbldesc KLMRPM_is_the_engine_speed_ceiling_for_the_low-RPM_knock_retard_clamp_(KNKLIM)._Increasing_the_Value_(Higher_RPM_Threshold):_Extends_the_restricted_low-RPM_knock_clamp_(KNKLIM)_to_higher_engine_speeds_(e.g.,_1,500_or_2,000_RPM)._Useful_for_heavily_cammed_or_mechanically_noisy_engines_where_false_knock_causes_power_hesitation_during_lower_gear_acceleration.
    .byte 0x2F                       ;Point 1

	;.org	0xc0b8
RETMAX_MaxKnockRetardFromMap:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0xC0A3
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname MaxKnockRetardFromMap
    ;mptblcname RETMAX
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Max_Retard 0 128 degrees
    ;mptbldesc RETMAX_defines_the_maximum_allowable_knock_retard_ceiling_as_a_function_of_intake_manifold_pressure._Increasing_Table_Values_(Higher_Retard_Ceiling):_Effect_on_Total_Timing:_Gives_the_knock_control_system_authority_to_pull_more_total_timing_under_heavy_boost_if_detonation_persists._Real-World_Driving_Feel:_Crucial_safety_protection_when_pushing_high_boost_levels_(15-25+_psi)_on_pump_gasoline.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x39, 0x04, 0x00, 0xF2     ;Point 1
    .byte 0x4B, 0x15                 ;Point 2

	;.org	0xc0bf
DLTKNK_KnockFromRpms:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0xC0AA
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname KnockSensorVoltageForKnock_FromRpm
    ;mptblcname DLTKNK
    ;mpxaxis RPM 0 16384 rpm
    ;mpyaxis A2D 0 5 volts
    ;mptbldesc DLTKNK_is_the_knock_sensor_sensitivity_/_noise_threshold_curve_across_engine_RPM._A_piezoelectric_knock_sensor_mounted_to_the_engine_block_converts_engine_vibrations_into_an_AC_voltage_signal,_which_the_ECU_rectifies_and_reads_through_an_analog-to-digital_(A/D)_converter._Increasing_Table_Values_(Raising_the_Noise_Threshold):_What_it_does:_Desensitizes_the_knock_sensor._Requires_higher_vibration_amplitude_before_knock_is_flagged.
    .byte 0x05                       ;Number of points in table
    .byte 0x1F, 0x15, 0x01, 0x60     ;Point 1
    .byte 0x2F, 0x2B, 0x02, 0xA0     ;Point 2
    .byte 0x3F, 0x55, 0x05, 0x80     ;Point 3
    .byte 0x4F, 0xAD, 0x01, 0xD0     ;Point 4
    .byte 0x5F, 0xCA                 ;Point 5

	;.org	0xc0d2
FWDARP_SubtractedFromRPMDuringIdleRoutine:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0xC0BD
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname SubtractedFromRPMDuringIdleRoutine
    ;mptblcname FWDARP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc FWDARP_defines_the_forward_RPM_deadband_offset_for_the_ECU's_rapid_idle_speed_stabilization_system._Increasing_the_Value_(Wider_Deadband):_Allows_idle_RPM_to_fluctuate_further_above_target_before_timing_is_trimmed._Real-world_feel:_Useful_for_aggressive_aftermarket_camshafts_that_naturally_produce_lumpy_idle_pulses,_preventing_the_ECU_from_fighting_the_camshaft's_natural_lope.
    .word 0x001E                     ;Point 1

	;.org	0xc0d4
REVARP_AddedBackToRPMDuringIdleRoutine:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0xC0BF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AddedBackToRPMDuringIdleRoutine
    ;mptblcname REVARP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc REVARP_defines_the_reverse_(underspeed)_RPM_deadband_offset_for_the_idle_timing_stabilization_system._Increasing_the_Value_(Wider_Deadband):_Tolerates_larger_RPM_drops_before_kicking_in_idle_advance._Real-world_feel:_Smooths_out_lumpy_cam_idle,_but_reduces_stall_protection_if_the_A/C_compressor_or_power_steering_engages_suddenly._Decreasing_the_Value_(Tighter_Deadband):_Kicks_in_advance_immediately_on_tiny_RPM_drops.
    .byte 0x1E                       ;Point 1

	;.org	0xc0d5
Idle_word_A:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0xC0C0
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname Idle_word_A
    ;mptblcname IDLWA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc IDLWA_is_an_internal_calibration_structure_word_utilized_by_the_ECU's_distributor_timer_and_dwell_scheduler_during_closed-throttle_idle_stabilization._Tuning_Recommendation:_DO_NOT_MODIFY._These_hardware-specific_timer_coefficients_govern_the_low-level_interrupt_latency_and_dwell_scheduling_of_the_6803_microcontroller's_internal_timer_hardware._Changing_these_values_will_corrupt_idle_coil_charging_and_cause_ignition_misfires.
    .word 0x16BC                     ;Point 1

	;.org	0xc0d7
Idle_bytes_A:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0xC0C2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Idle_bytes_A
    ;mptblcname IDLBA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc IDLBA_is_a_companion_byte_constant_to_Idle_word_A_in_the_ECU's_idle_timer_parameter_block._It_provides_offset_scaling_for_the_closed-throttle_ignition_dwell_timer._Tuning_Recommendation:_DO_NOT_MODIFY._Factory_calibrated_at_0x00._Modifying_this_value_risks_desynchronizing_idle_coil_dwell_charging.
    .byte 0x00                       ;Point 1

	;.org	0xc0d8
Idle_word_B:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0xC0C3
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname Idle_word_B
    ;mptblcname IDLWB
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc IDLWB_is_the_secondary_timer_coefficient_word_in_the_idle_ignition_dwell_calculation_structure._It_pairs_with_Idle_word_A_to_define_timing_boundaries_for_low-speed_spark_generation._Tuning_Recommendation:_DO_NOT_MODIFY._These_values_represent_fixed_hardware_execution_timings_for_the_microcontroller's_internal_timer_registers.
    .word 0x0B5E                     ;Point 1

	;.org	0xc0da
Idle_bytes_B:
    ;mpgrp Spark\Knock_Retard\
    ;mptbladdr 0xC0C5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Idle_bytes_B
    ;mptblcname IDLBB
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc IDLBB_is_the_companion_byte_constant_to_Idle_word_B_in_the_ECU's_idle_timer_parameter_block._Tuning_Recommendation:_DO_NOT_MODIFY._Factory_calibrated_at_0x00._Modifying_this_value_risks_corrupting_low-speed_ignition_coil_charging.
    .byte 0x00                       ;Point 1

	;.org	0xc0db
FTUNPW_FineTuneStepForAis:
    ;mpgrp Spark\Scatter_Control\
    ;mptbladdr 0xC0C6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FineTuneStepForAis
    ;mptblcname FTUNPW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc FTUNPW_is_the_enable_switch_and_step-size_multiplier_for_spark_scatter_idle_stabilization._During_closed-throttle_idle,_when_engine_RPM_deviates_outside_the_neutral_deadband_(FWDARP_and_REVARP),_the_ECU_applies_high-speed_ignition_timing_dithering_to_stabilize_engine_speed._Setting_to_0x00_(Disable_Spark_Scatter):_Disables_spark_scatter_completely._Real-world_feel:_The_ECU_will_rely_100%_on_the_mechanical_AIS_stepper_motor_for_idle_speed_control.
    .byte 0x00                       ;Point 1

	;.org	0xc0dc
SSIPRD_ScatterInhibitBelowThisSpeed:
    ;mpgrp Spark\Scatter_Control\
    ;mptbladdr 0xC0C7
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ScatterInhibitBelowThisSpeed
    ;mptblcname SSIPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SSIPRD_establishes_the_low-RPM_lockout_threshold_below_which_spark_scatter_idle_stabilization_is_inhibited._Increasing_the_Value_(Lower_RPM_Lockout):_Allows_spark_scatter_to_operate_down_to_even_lower_engine_speeds_(e.g.,_450_RPM)._Decreasing_the_Value_(Higher_RPM_Lockout):_Shuts_off_spark_scatter_at_a_higher_speed_(e.g.,_750_RPM).
    .word 0x00D0                     ;Point 1

	;.org	0xc0de
STRTFL_FuelStartFromCoolantTemp:
    ;mpgrp Fuel\Starting\
    ;mptbladdr 0xC0C9
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname StartFuel_FromTemp
    ;mptblcname STRTFL
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis sqrtPW 0 222 uSec
    ;mptbldesc STRTFL_is_the_core_cranking_fuel_delivery_curve_used_while_the_engine_is_being_turned_over_by_the_starter_motor._Square-Root_Math:_STRTFL_utilizes_square-root_pulse_width_scaling._The_ECU_squares_the_lookup_value_(_STRTFL_STRTFL_)_to_compute_base_pulse_width._Small_adjustments_to_high_table_values_have_a_large_exponential_impact_on_fuel_delivery!_Increasing_Table_Values_(Richer_Cranking):_Effect:_Injects_longer_fuel_pulses_during_cranking.
    ;mpinjscale sqrt
    .byte 0x09                       ;Number of points in table
    .byte 0x58, 0x91, 0xFF, 0xE9     ;Point 1
    .byte 0x63, 0x90, 0xFE, 0x00     ;Point 2
    .byte 0x6E, 0x7A, 0xFE, 0x00     ;Point 3
    .byte 0x79, 0x64, 0xFE, 0xE9     ;Point 4
    .byte 0x84, 0x58, 0xFE, 0xD5     ;Point 5
    .byte 0x90, 0x4A, 0xFE, 0x46     ;Point 6
    .byte 0x9B, 0x37, 0xFF, 0xE9     ;Point 7
    .byte 0xB1, 0x35, 0xFF, 0x5F     ;Point 8
    .byte 0xCC, 0x24                 ;Point 9

	;.org	0xc101
STRLMT_ColdestTempAllowedAtClosedThrottle:
    ;mpgrp Fuel\Starting\
    ;mptbladdr 0xC0EC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ColdestTempAllowedAtClosedThrottle
    ;mptblcname STRLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc STRLMT_is_a_minimum_temperature_floor_clamped_onto_the_cranking_fuel_lookup_when_starting_at_closed_throttle._Increasing_the_Value_(Warmer_Clamp):_Caps_cold_cranking_fuel_at_a_warmer_temperature._Prevents_cold_flooding_in_winter_climates._Decreasing_the_Value_(Colder_Clamp):_Allows_the_ECU_to_deliver_richer_cranking_pulse_widths_at_extreme_sub-freezing_temperatures.
    .byte 0x63                       ;Point 1

	;.org	0xc102
STFBAR_FuelStartReductionFromBaro:
    ;mpgrp Fuel\Starting\
    ;mptbladdr 0xC0ED
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FuelStartReductionFromBaro
    ;mptblcname STFBAR
    ;mpxaxis Baro -14.7 29.4 psi
    ;mpyaxis Inverse 0 1 factor
    ;mptbldesc STFBAR_provides_an_altitude-dependent_reduction_factor_for_cranking_fuel_delivery._Increasing_Table_Values_(More_Altitude_Fuel_Reduction):_Effect:_Trims_more_fuel_out_during_high-altitude_starts._Real-World_Feel:_Clears_up_black_exhaust_smoke,_rough_cold_starts,_and_fouled_plugs_when_starting_at_high_elevation._Decreasing_Table_Values_(Less_Altitude_Fuel_Reduction):_Effect:_Delivers_more_cranking_fuel_at_altitude.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x40, 0x59, 0xFA, 0xC4     ;Point 1
    .byte 0x51, 0x00                 ;Point 2

	;.org	0xc10d
STFTMP_FuelStartFuelFromCoolant:
    ;mpgrp Fuel\Starting\
    ;mptbladdr 0xC0F4
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartFuelFromCoolant
    ;mptblcname STFTMP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Inverse 0 1 factor
    ;mptbldesc STFTMP_is_an_additional_coolant_temperature_weighting_factor_applied_to_the_barometric_starting_fuel_reduction_calculation._Stock_Setting_(0xFF):_Multiplier_is_1.0_(full_barometric_reduction_allowed)._Decreasing_Table_Values:_Dampens_altitude_fuel_reduction_at_cold_temperatures,_preserving_extra_rich_cranking_fuel_for_cold_morning_mountain_starts.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0xFF                 ;Point 1

	;.org	0xc118
EPPMUL_FuelStartFuelPerEPP:
    ;mpgrp Fuel\Starting\
    ;mptbladdr 0xC0F7
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartFuelPerEPP
    ;mptblcname EPPMUL
    ;mpxaxis EPPs 0 255 count
    ;mpyaxis Multiplier 0 1 factor
    ;mptbldesc EPPMUL_provides_cranking_fuel_decay_as_engine_revolutions_accumulate_during_prolonged_cranking._Increasing_Table_Values_(Less_Fuel_Decay_Over_Time):_Effect:_Keeps_cranking_pulse_width_richer_for_longer_during_extended_cranking._Real-World_Feel:_Helpful_for_stubborn_cold_starts_on_E85,_alcohol_fuels,_or_low-compression_engines_where_prolonged_cranking_is_required_to_build_sufficient_compression_heat_before_the_fuel_ignites.
    .byte 0x02                       ;Number of points in table
    .byte 0x21, 0xFF, 0xFF, 0x79     ;Point 1
    .byte 0x80, 0xCD                 ;Point 2

	;.org	0xc11f
SFDCAY_FuelStartDecayIntoRun:
    ;mpgrp Fuel\Starting\
    ;mptbladdr 0xC0FE
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartDecayIntoRun
    ;mptblcname SFDCAY
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Subtracted 0 255 ms/rev
    ;mptbldesc SFDCAY_defines_the_fuel_decay_rate_during_the_immediate_start-to-run_transition._Increasing_Table_Values_(Faster_Fuel_Decay):_Effect:_Decays_after-start_enrichment_fuel_more_rapidly._Real-World_Feel:_Cleans_up_post-start_black_exhaust_smoke_and_soot_on_warm_restarts,_but_can_cause_a_cold_engine_to_sag_or_die_2-3_seconds_after_starting._Decreasing_Table_Values_(Slower_Fuel_Decay):_Effect:_Holds_extra_after-start_enrichment_longer.
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x63, 0x12, 0xFF, 0xB6     ;Point 1
    .byte 0x90, 0x05, 0xFF, 0xF7     ;Point 2
    .byte 0xCC, 0x03                 ;Point 3

	;.org	0xc12a
PRSHOT_KeyOnPrimePW:
    ;mpgrp Fuel\Starting\
    ;mptbladdr 0xC109
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname KeyOnPrimePW
    ;mptblcname PRSHOT
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Pulsewidth 0 255 mSec
    ;mptbldesc PRSHOT_defines_the_initial_"prime_shot"_fuel_injection_pulse_delivered_the_instant_the_ignition_key_is_turned_to_the_ON_/_RUN_position,_before_the_starter_motor_begins_cranking._When_an_engine_sits_overnight,_fuel_in_the_intake_ports_evaporates_and_the_manifold_walls_dry_completely._Increasing_Table_Values_(Bigger_Prime_Shot):_Delivers_more_fuel_on_key_turn-on._Real-world_feel:_Produces_instant_"touch_of_the_key"_firing_on_cold_mornings.
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x69, 0x43, 0xFE, 0x1C     ;Point 1
    .byte 0x84, 0x10, 0xFF, 0xDF     ;Point 2
    .byte 0x9B, 0x0D                 ;Point 3

	;.org	0xc135
O2TIME_DelayTimeToClosedLoop:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0xC114
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DelayTimeToClosedLoop
    ;mptblcname O2TIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Delay_Time 0 720 Sec
    ;mptbldesc O2TIME_establishes_the_minimum_warmup_hold_time_that_the_ECU_must_wait_after_the_engine_has_reached_operating_temperature_(CLTEMP)_before_attempting_to_transition_from_Open-Loop_into_Closed-Loop_fuel_feedback_control._Factory_Calibration_Value:_0x15_(21_decimal_2.8_s_~_59_seconds_)._Increasing_O2TIME:_Effect:_Lengthens_the_time_the_engine_stays_in_open-loop_warm-up_mode_after_cold_startup.
    .byte 0x15                       ;Point 1

	;.org	0xc136
CLTEMP_TempToStartCLTIMETimer:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_Memory_Timer\
    ;mptbladdr 0xC115
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TempToStartCLTIMETimer
    ;mptblcname CLTEMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 degrees
    ;mptbldesc CLTEMP_defines_the_coolant_temperature_threshold_that_unlocks_the_closed-loop_delay_timer._Stock_Setting:_0x9B_(_~_77_degF_)._The_factory_cal_enables_closed-loop_qualification_early_(at_mild_ambient_temps)_to_reduce_cold-start_tailpipe_emissions._Increasing_CLTEMP_(e.g.,_to_120_degF-140_degF):_Effect:_Keeps_the_engine_in_open_loop_longer_until_physical_warmth_is_established_in_the_combustion_chambers.
    .byte 0x9B                       ;Point 1

	;.org	0xc137
O2HSWP_HighLimitForO2RampSwitching:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0xC116
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForO2RampSwitching
    ;mptblcname O2HSWP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2HSWP_is_the_upper_voltage_switching_threshold_used_by_the_closed-loop_air/fuel_ratio_controller_to_detect_when_the_exhaust_mixture_has_transitioned_to_the_RICH_side_of_stoichiometric_(14.7:1_AFR_for_gasoline)._Pairing_with_O2LSWP:_O2HSWP_(0x19_~_0.488V_)_works_as_a_tight_hysteresis_pair_with_O2LSWP_(0x18_~_0.469V_)._This_tight_19mV_window_ensures_rapid,_responsive_switching_around_the_narrow-band_midpoint.
    .byte 0x79                       ;Point 1

	;.org	0xc138
O2LSWP_LowLimitForO2RampSwitching:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0xC117
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForO2RampSwitching
    ;mptblcname O2LSWP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2LSWP_is_the_lower_voltage_switching_threshold_used_by_the_closed-loop_air/fuel_controller_to_detect_when_the_exhaust_mixture_has_transitioned_to_the_LEAN_side_of_stoichiometric_(lambda_>_1.0)._Hysteresis_Band:_The_stock_calibration_sets_O2LSWP_at_0x18_(0.469V)_and_O2HSWP_at_0x19_(0.488V)._This_single-count_separation_(19_mV)_represents_the_absolute_minimum_hysteresis_possible_in_an_8-bit_ADC_system.
    .byte 0x78                       ;Point 1

	;.org	0xc139
O2TLMH_HighLimitForDelayedSwitchToClosedLoop:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0xC118
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForDelayedSwitchToClosedLoop
    ;mptblcname O2TLMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2TLMH_defines_the_upper_voltage_threshold_required_to_qualify_O2_sensor_readiness_before_the_ECU_officially_activates_closed-loop_feedback_operation._When_an_oxygen_sensor_is_cold_and_inactive,_its_internal_electrochemical_cell_cannot_pass_current_and_rests_at_an_indeterminate_floating_voltage_(typically_0.40V_to_0.50V)._Stock_Value:_0x1F_(31_counts_~_0.605V_).
    .byte 0x1C                       ;Point 1

	;.org	0xc13a
O2TLML_LowLimitForDelayedSwitchToClosedLoop:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0xC119
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForDelayedSwitchToClosedLoop
    ;mptblcname O2TLML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2TLML_is_the_lower_voltage_threshold_required_to_qualify_O2_sensor_readiness_before_enabling_closed-loop_fueling._Stock_Value:_0x0F_(15_decimal_~_0.293V_)._Diagnostic_Utility:_An_O2_sensor_with_high_ground_offset_(common_in_older_wiring_harnesses_with_corroded_engine_ground_straps)_may_never_register_below_0.35V._In_such_cars,_the_ECU_will_fail_this_test_and_refuse_to_enter_closed-loop,_causing_poor_gas_mileage_and_continuous_open-loop_running.
    .byte 0x12                       ;Point 1

	;.org	0xc13b
O2MIDH_HighLimitForInMiddleDetermination:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0xC11A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForInMiddleDetermination
    ;mptblcname O2MIDH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2MIDH_defines_the_upper_voltage_boundary_of_the_O2_sensor_"stuck-in-the-middle"_fault_zone._Stock_Value:_0x1C_(28_counts_~_0.547V_)._Diagnostic_Indicator:_If_an_engine_intermittently_kicks_out_of_closed_loop_and_throws_Fault_21,_check_the_sensor_wiring_for_high_resistance_or_a_failed_heater_circuit_that_causes_the_sensor_to_cool_off_and_drift_into_this_0.352V_-_0.547V_range_at_long_idle.
    .byte 0x80                       ;Point 1

	;.org	0xc13c
O2MIDL_LowLimitForInMiddleDetermination:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0xC11B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForInMiddleDetermination
    ;mptblcname O2MIDL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2MIDL_defines_the_lower_voltage_boundary_of_the_O2_sensor_"stuck-in-the-middle"_fault_zone._Stock_Value:_0x12_(18_counts_~_0.352V_)._Troubleshooting_Fault_21:_If_Fault_21_occurs_after_installing_an_aftermarket_exhaust,_check_if_the_O2_sensor_is_placed_too_far_downstream_without_a_heated_element._At_idle,_exhaust_temperature_drops_below_the_sensor's_threshold,_causing_its_voltage_to_freeze_between_0.352V_and_0.547V_.
    .byte 0x70                       ;Point 1

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

	;.org	0xc13d
PRIRMP_PrimaryRamp:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller_Ramps\
    ;mptbladdr 0xC11C
    ;mptbltype 11
    ;mpsubtype 1
    ;mptbllname PrimaryRamp
    ;mptblcname PRIRMP
    ;mpxaxis RPM 0 16384 rpm
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc PRIRMP_is_the_Proportional_Step_table_of_the_ECU's_Proportional-Integral_(PI)_closed-loop_fuel_controller._Proportional_Jump_Dynamics:_Larger_Step_Sizes:_Creates_wider,_faster_swings_across_stoichiometry._This_helps_old_catalytic_converters_light_off_and_perform_redox_reactions,_but_if_too_large,_causes_noticeable_exhaust_hunting,_audible_RPM_surging_at_cruise,_and_choppy_idle.
    ;mpmapaxis y
    .word 0x1C25                  ;Rpm Low / High Boundary
    .word 0x223F                  ;Map Low / High Boundary
    .word 0x1A0B                  ;Cell 0 Ramp Rich/Lean
    .word 0x1A09                  ;Cell 1 Ramp Rich/Lean
    .word 0x1A08                  ;Cell 2 Ramp Rich/Lean
    .word 0x1A0B                  ;Cell 3 Ramp Rich/Lean
    .word 0x1A09                  ;Cell 4 Ramp Rich/Lean
    .word 0x1A08                  ;Cell 5 Ramp Rich/Lean
    .word 0x1A0B                  ;Cell 6 Ramp Rich/Lean
    .word 0x1A09                  ;Cell 7 Ramp Rich/Lean
    .word 0x1A08                  ;Cell 8 Ramp Rich/Lean
    .word 0x0101                  ;Ramp Idle Cell Rich/Lean
    .word 0x0C0C                  ;Cell 0 Limits/Rates Rich/Lean
    .word 0x1312                  ;Cell 1 Limits/Rates Rich/Lean
    .word 0x1A19                  ;Cell 2 Limits/Rates Rich/Lean
    .word 0x0C0C                  ;Cell 3 Limits/Rates Rich/Lean
    .word 0x1312                  ;Cell 4 Limits/Rates Rich/Lean
    .word 0x1A19                  ;Cell 5 Limits/Rates Rich/Lean
    .word 0x0C0C                  ;Cell 6 Limits/Rates Rich/Lean
    .word 0x1312                  ;Cell 7 Limits/Rates Rich/Lean
    .word 0x1A19                  ;Cell 8 Limits/Rates Rich/Lean
    .word 0x0101                  ;Limit/Rates Idle Cell Rich/Lean

	;.org	0xc169
SECRMP_SecondaryRamp:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller_Ramps\
    ;mptbladdr 0xC148
    ;mptbltype 11
    ;mpsubtype 1
    ;mptbllname SecondaryRamp
    ;mptblcname SECRMP
    ;mpxaxis RPM 0 16384 rpm
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc SECRMP_represents_the_Integral_Ramp_(Slope)_table_of_the_ECU's_closed-loop_PI_fueling_algorithm._Integral_Ramp_Dynamics:_Steeper_Slopes_(Higher_Values):_Causes_the_fuel_pulse_width_to_ramp_rapidly_towards_the_opposite_limit._Produces_higher_frequency_switching,_but_risks_heavy_overshoot_and_hunting._Flatter_Slopes_(Lower_Values):_Causes_slow,_gradual_fueling_adjustments.
    ;mpmapaxis y
    .word 0x1C25                  ;Rpm Low / High Boundary
    .word 0x223F                  ;Map Low / High Boundary
    .word 0x01FF                  ;Cell 0 Ramp Rich/Lean
    .word 0x01FF                  ;Cell 1 Ramp Rich/Lean
    .word 0x01FF                  ;Cell 2 Ramp Rich/Lean
    .word 0x01FF                  ;Cell 3 Ramp Rich/Lean
    .word 0x01FF                  ;Cell 4 Ramp Rich/Lean
    .word 0x01FF                  ;Cell 5 Ramp Rich/Lean
    .word 0x01FF                  ;Cell 6 Ramp Rich/Lean
    .word 0x01FF                  ;Cell 7 Ramp Rich/Lean
    .word 0x01FF                  ;Cell 8 Ramp Rich/Lean
    .word 0x01FF                  ;Ramp Idle Cell Rich/Lean
    .word 0x0709                  ;Cell 0 Limits/Rates Rich/Lean
    .word 0x0709                  ;Cell 1 Limits/Rates Rich/Lean
    .word 0x0709                  ;Cell 2 Limits/Rates Rich/Lean
    .word 0x0309                  ;Cell 3 Limits/Rates Rich/Lean
    .word 0x0309                  ;Cell 4 Limits/Rates Rich/Lean
    .word 0x0309                  ;Cell 5 Limits/Rates Rich/Lean
    .word 0x0309                  ;Cell 6 Limits/Rates Rich/Lean
    .word 0x0309                  ;Cell 7 Limits/Rates Rich/Lean
    .word 0x0709                  ;Cell 8 Limits/Rates Rich/Lean
    .word 0x0709                  ;Limit/Rates Idle Cell Rich/Lean

	;.org	0xc195
O2LIMH_O2RangeLimitHigh:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0xC174
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2RangeLimitHigh
    ;mptblcname O2LIMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2LIMH_specifies_the_maximum_short-term_enrichment_authority_permitted_by_the_closed-loop_O2_feedback_controller._Stock_Value:_0x7F_(+127_decimal)._Max_Multiplier_=_1.0_+_(O2LIMH_/_512)_=_1.0_+_(127_/_512)_~_1.248_(+24.8%)_Increasing_O2LIMH:_Allows_the_closed-loop_controller_to_add_even_more_fuel_to_compensate_for_unmetered_air_leaks_or_undersized_fuel_delivery._Warning:_The_internal_math_register_is_signed_8-bit.
    .byte 0x7F                       ;Point 1

	;.org	0xc196
O2LIML_O2RangeLimitLow:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0xC175
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2RangeLimitLow
    ;mptblcname O2LIML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2LIML_establishes_the_maximum_short-term_enleanment_authority_permitted_by_the_closed-loop_O2_controller._Stock_Value:_0xB3_(Hex_0xB3_in_8-bit_signed_two's_complement_=_179_-_256_=_-77_decimal)._Min_Multiplier_=_1.0_+_(Signed(0xB3)_/_512)_=_1.0_-_(77_/_512)_~_1.0_-_0.1504_=_0.8496_(-15.0%)_Safety_Margin:_Notice_that_the_factory_calibration_allows_+24.8%_rich_authority_(0x7F),_but_only_-15.0%_lean_authority_(0xB3).
    .byte 0xB3                       ;Point 1

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

	;.org	0xc197
MP1_AutoCalMapCellBoundary1:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0xC176
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary1
    ;mptblcname MP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc MP1_defines_the_first_manifold_pressure_load_boundary_separating_Adaptive_Fuel_Memory_Cell_0/1_from_Cell_2/3._Stock_Value:_0x24_(_~_21.6_inHg_vacuum_)._Engine_Dynamics:_Cell_0/1_covers_very_light_throttle_cruise_or_downhill_overrun._Altering_Boundaries:_When_running_higher-duration_performance_camshafts_with_reduced_idle_and_decel_vacuum,_MP1_may_be_adjusted_higher_to_ensure_light_cruise_does_not_bleed_into_the_decel_cell.
    ;mpmapaxis y
    .byte 0x1B                       ;Point 1

	;.org	0xc198
MP2_AutoCalMapCellBoundary2:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0xC177
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary2
    ;mptblcname MP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc MP2_defines_the_second_manifold_pressure_load_boundary_separating_Adaptive_Fuel_Memory_Cells_2/3_from_Cells_4/5._Stock_Setting:_0x37_(_~_17_inHg_vacuum_)._Tuning_Impact:_If_a_car_exhibits_distinct_fueling_errors_between_city_30_mph_cruise_and_flat_highway_55_mph_cruise,_moving_MP2_shifts_where_the_ECU_bifurcates_its_learned_long-term_fuel_trim_corrections.
    ;mpmapaxis y
    .byte 0x29                       ;Point 1

	;.org	0xc199
MP3_AutoCalMapCellBoundary3:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0xC178
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary3
    ;mptblcname MP3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc MP3_defines_the_third_manifold_pressure_load_boundary,_separating_Adaptive_Fuel_Memory_Cells_4/5_from_Cells_6/7._Stock_Setting:_0x4B_(_~_12.4_inHg_vacuum_)._Real-World_Impact:_Cells_4_and_5_accumulate_the_vast_majority_of_interstate_highway_cruising_miles._Long-term_fuel_trims_stored_in_these_cells_have_the_biggest_impact_on_highway_fuel_economy.
    ;mpmapaxis y
    .byte 0x36                       ;Point 1

	;.org	0xc19a
MP4_AutoCalMapCellBoundary4:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0xC179
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary4
    ;mptblcname MP4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc MP4_defines_the_fourth_manifold_pressure_load_boundary,_separating_Adaptive_Fuel_Memory_Cells_6/7_from_Cells_8/9._This_transition_point_marks_moderate_acceleration_and_moderate_hill-climbing_under_engine_vacuum_(approx._7_inHg_vacuum)._Stock_Value:_0x61_(_~_7.2_inHg_vacuum_)._Engine_Dynamics:_Cells_6_and_7_handle_hill_climbing_and_moderate_vehicle_acceleration_prior_to_approaching_atmospheric_pressure.
    ;mpmapaxis y
    .byte 0x43                       ;Point 1

	;.org	0xc19b
MP5_AutoCalMapCellBoundary5:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0xC17A
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary5
    ;mptblcname MP5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc MP5_defines_the_fifth_and_highest_manifold_pressure_load_boundary,_separating_Adaptive_Fuel_Memory_Cells_8/9_from_Cells_10/11._Stock_Setting:_0x78_(_~_-0.9_psig_)._Near-Atmospheric_Learning:_Cells_10_and_11_represent_the_highest_load_cells_where_the_ECU_is_permitted_to_adapt_fuel_trims._Once_manifold_pressure_crosses_into_boost_(_>_MAPLIM_),_closed_loop_and_adaptive_memory_freeze,_locking_fuel_delivery_to_open-loop_base_tables.
    ;mpmapaxis y
    .byte 0x50                       ;Point 1

	;.org	0xc19c
DLTMAP_MapHysteresisAtMapCellBoundaries:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0xC17B
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MapHysteresisAtMapCellBoundaries
    ;mptblcname DLTMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc DLTMAP_provides_manifold_pressure_hysteresis_when_transitioning_between_adjacent_adaptive_fuel_memory_cells._Stock_Value:_0x01_(1_ADC_step_~_0.12_psi_)._Tuning_Guidance:_The_stock_1-count_hysteresis_is_generally_optimal._Increasing_to_2_or_3_counts_can_help_vehicles_with_excessive_intake_manifold_pulsation_(e.g.,_individual_runner_intakes_or_radical_camshaft_overlap),_stabilizing_cell_selection.
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

	;.org	0xc19d
R1_RPMCellBoundaryInRPMover32:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0xC17C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMCellBoundaryInRPMover32
    ;mptblcname R1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 16384 rpm
    ;mptbldesc R1_is_the_engine_speed_boundary_that_bifurcates_each_of_the_6_MAP_load_regions_into_a_Low-RPM_Cell_(even_numbers:_0,_2,_4,_6,_8,_10)_and_a_High-RPM_Cell_(odd_numbers:_1,_3,_5,_7,_9,_11)._Engines_experience_significantly_different_volumetric_efficiencies_and_exhaust_scavenging_dynamics_at_low_RPM_(near_idle_/_off-idle_lugging)_compared_to_higher_cruising_RPMs._Stock_Value:_0x1D_(_29_32_=_928_RPM_).
    .byte 0x1D                       ;Point 1

	;.org	0xc19e
DLTRPM_DeltaRPMAtRPMBoundariesInRPMOver32:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0xC17D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaRPMAtRPMBoundariesInRPMOver32
    ;mptblcname DLTRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DLTRPM_provides_engine_speed_hysteresis_around_the_RPM_cell_boundary_(R1)._When_vehicle_engine_speed_hovers_right_at_the_R1_threshold_(e.g._928_RPM),_small_tachometer_fluctuations_would_cause_the_ECU_to_flip_between_even_and_odd_adaptive_memory_cells_constantly._Stock_Value:_0x01_(32_RPM)._Tuning_Advice:_Generally_leave_at_stock_unless_you_raise_R1_substantially,_in_which_case_a_2-count_(_64_RPM_)_hysteresis_band_can_improve_stability.
    .byte 0x01                       ;Point 1

	;.org	0xc19f
IDLOFS_DeltaForIdleRPMForClosedThrottleCell:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0xC17E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaForIdleRPMForClosedThrottleCell
    ;mptblcname IDLOFS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc IDLOFS_specifies_an_upper_RPM_offset_window_above_target_idle_speed_within_which_the_ECU_is_permitted_to_select_and_update_the_dedicated_Closed-Throttle_Idle_Adaptive_Cell_(Cell_12_/_AutoCalCell12idle)._Stock_Value:_0x01_(32_RPM_above_target_idle)._Target_Idle_Relationship:_Target_idle_speed_is_dynamically_set_by_the_AIS_idle_speed_curve_(e.g._850_RPM).
    .byte 0x01                       ;Point 1

	;.org	0xc1a0
HYTRPM_HysteresisFor_IDLOFS:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0xC17F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HysteresisFor_IDLOFS
    ;mptblcname HYTRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HYTRPM_establishes_the_engine_speed_hysteresis_band_for_entry_and_exit_from_the_Closed-Throttle_Idle_Adaptive_Cell_(Cell_12)._Stock_Setting:_0x02_(64_RPM)._Tuning_Recommendation:_Leave_at_stock_unless_an_aggressive_camshaft_creates_large_idle_RPM_fluctuations,_in_which_case_increasing_HYTRPM_to_0x03_or_0x04_stabilizes_closed-loop_idle_adaptation.
    .byte 0x02                       ;Point 1

	;.org	0xc1a1
CALTHR_O2ControllerDeadbandLimitForUpdatingCells:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0xC180
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2ControllerDeadbandLimitForUpdatingCells
    ;mptblcname CALTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CALTHR_defines_the_short-term_fuel_feedback_deadband_threshold_required_to_trigger_an_update_to_long-term_adaptive_memory._Stock_Value:_0x09_(9_counts)._Increasing_CALTHR:_Requires_larger_persistent_fueling_errors_before_adaptive_trim_shifts._When_to_Use:_If_long-term_trims_wander_around_excessively_due_to_weather_changes_or_sensor_noise,_increasing_CALTHR_makes_adaptive_memory_more_conservative.
    .byte 0x09                       ;Point 1

	;.org	0xc1a2
RPMLIM_NoCellUpdateAboveThisRPMInRPMOver32:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0xC181
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoCellUpdateAboveThisRPMInRPMOver32
    ;mptblcname RPMLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 16384 rpm
    ;mptbldesc RPMLIM_defines_the_maximum_engine_speed_above_which_adaptive_memory_updates_are_locked_out._At_higher_engine_speeds,_rapid_throttle_transients,_high_exhaust_flow_rates,_and_potential_knock_events_make_steady-state_fuel_trim_adaptation_unreliable._Stock_Value:_0x2B_(_43_32_=_1376_RPM_)._Why_is_Stock_so_Low?_In_the_stock_T-LM_cal,_Chrysler_restricted_long-term_learning_primarily_to_low-speed_and_off-idle_urban_driving.
    .byte 0x2B                       ;Point 1

	;.org	0xc1a3
MAPLIM_NoCellUpdateAboveThisMAP:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0xC182
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname NoCellUpdateAboveThisMAP
    ;mptblcname MAPLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc MAPLIM_sets_the_maximum_manifold_absolute_pressure_threshold_above_which_adaptive_fuel_learning_is_completely_inhibited._Stock_Setting:_0x8A_(_~_1.2_psig_/_just_entering_positive_boost)._Tuning_Rule:_Never_set_MAPLIM_substantially_into_boost._It_must_always_stay_at_or_just_below_atmospheric_pressure_(typically_0_to_1_psig)_to_safeguard_boosted_open-loop_fueling.
    ;mpmapaxis y
    .byte 0x5C                       ;Point 1

	;.org	0xc1a4
PWMIN_NoCellUpdateBelow_PWMIN_Pulsewidth:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0xC183
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname NoCellUpdateBelow_PWMIN_Pulsewidth
    ;mptblcname PWMIN
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc PWMIN_establishes_the_minimum_injector_pulse_width_threshold_below_which_adaptive_memory_cell_updates_are_prohibited._Stock_Value:_0x04B0_(_4.80_ms_)._Crucial_Scaling_for_Larger_Injectors:_When_installing_larger_fuel_injectors_(+20%,_+40%,_+52_lb/hr),_normal_cruise_pulse_widths_drop_substantially_(often_into_the_2.0_ms_-_3.5_ms_range)!
    ;mpinjscale word
    .word 0x0324                     ;Point 1

	;.org	0xc1a6
CELCHG_BitsChangePerUpdateWithinACell:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0xC185
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BitsChangePerUpdateWithinACell
    ;mptblcname CELCHG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CELCHG_dictates_the_step_increment_size_by_which_an_adaptive_fuel_memory_cell_is_modified_each_time_an_update_condition_is_triggered._Stock_Setting:_0x01_(_~_0.2%_per_step)._Increasing_CELCHG_(e.g._2_or_3):_Accelerates_adaptive_learning_speed_after_a_battery_disconnect._Risk:_Can_lead_to_adaptive_hunting_or_overshoot_on_bumpy_roads._Tuning_Recommendation:_Keep_at_0x01_for_maximum_calibration_stability.
    .byte 0x01                       ;Point 1

	;.org	0xc1a7
AMTEMP_StartTempToSelectHotOrColdAMTimer:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_Memory_Timer\
    ;mptbladdr 0xC186
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StartTempToSelectHotOrColdAMTimer
    ;mptblcname AMTEMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc AMTEMP_specifies_the_engine_operating_temperature_threshold_that_selects_between_hot_and_cold_adaptive_memory_timer_countdowns._Stock_Value:_0xCD_(_~_196_degF_)._Thermostat_Considerations:_If_you_install_a_lower-temperature_thermostat_(such_as_a_160_degF_or_180_degF_thermostat)_and_the_engine_never_reaches_196_degF,_the_adaptive_memory_timer_will_never_countdown,_locking_adaptive_fuel_trimming_out_completely!
    .byte 0xCD                       ;Point 1

	;.org	0xc1a8
AMTML_SelectedAMTimerInitLow:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_Memory_Timer\
    ;mptbladdr 0xC187
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SelectedAMTimerInitLow
    ;mptblcname AMTML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc AMTML_defines_the_initial_countdown_timer_duration_used_to_inhibit_adaptive_memory_learning_after_a_hot_engine_restart._When_restarting_an_already_warm_engine,_heat_soak_can_cause_temporary_vapor_bubbles_in_the_fuel_rail_or_distorted_intake_charge_temperatures._Stock_Setting:_0x40_(64_counts_~_3.0_minutes_)._Tuning_Guidance:_Shortening_AMTML_allows_quicker_adaptive_learning_resumption_after_hot_restarts_if_heat_soak_is_well_managed.
    .byte 0x40                       ;Point 1

	;.org	0xc1a9
AMTPSW_TempPointToEnableSelectedAMTimer:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_Memory_Timer\
    ;mptbladdr 0xC188
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TempPointToEnableSelectedAMTimer
    ;mptblcname AMTPSW
    ;mpxaxis in 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc AMTPSW_specifies_the_alternate_(shorter)_countdown_duration_loaded_into_the_adaptive_memory_inhibit_timer_when_starting_the_engine_at_intermediate_coolant_temperatures._Stock_Value:_0x0C_(_12_2.8_s_~_34_seconds_)._Tuning_Guidance:_Stock_values_provide_a_well-balanced_delay_for_warm_restarts.
    .byte 0x0C                       ;Point 1

	;.org	0xc1aa
AMTMH_SelectedAMTimerInitHi:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_Memory_Timer\
    ;mptbladdr 0xC189
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SelectedAMTimerInitHi
    ;mptblcname AMTMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc AMTMH_is_the_coolant_temperature_threshold_that_distinguishes_a_fully_hot_restart_from_a_warm_restart_for_adaptive_timer_selection._If_the_engine_is_started_with_coolant_temperature_at_or_above_AMTMH,_the_ECU_selects_the_longer_delay_(AMTML,_~3_minutes)_to_account_for_severe_engine_bay_heat_soak._Stock_Setting:_0xCD_(_~_196_degF_)._Tuning_Note:_Should_match_the_operating_temperature_threshold_set_in_AMTEMP.
    .byte 0xCD                       ;Point 1

	;.org	0xc1ab
AMUPDT_EPPsBetweenCalChangeUpdateOpenThrottle:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0xC18A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EPPsBetweenCalChangeUpdateOpenThrottle
    ;mptblcname AMUPDT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AMUPDT_defines_the_dwell_time_in_engine_events_(distributor_pulses)_that_the_engine_must_continuously_operate_within_a_specific_adaptive_cell_before_an_update_can_occur._Stock_Value:_0x1A_(26_pulses_=_13_crankshaft_rotations_on_a_4-cylinder_engine)._Increasing_AMUPDT:_Requires_longer_steady-state_driving_in_each_cell_before_adaptation_occurs._Filters_out_noise_and_ensures_trim_modifications_reflect_true_steady-state_conditions.
    .byte 0x1A                       ;Point 1

	;.org	0xc1ac
AMLIMH_MaxMultiplierCannotBeAbove7F:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0xC18B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxMultiplierCannotBeAbove7F
    ;mptblcname AMLIMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AMLIMH_establishes_the_maximum_positive_(enrichment)_authority_limit_permitted_for_any_adaptive_fuel_memory_cell._Stock_Value:_0x7F_(+127_decimal)._Max_Multiplier_=_1.0_+_(AMLIMH_/_512)_=_1.0_+_(127_/_512)_~_1.248_(+24.8%)_Tuning_Guidance:_0x7F_is_the_maximum_allowable_positive_number_in_an_8-bit_signed_two's_complement_integer._Never_increase_above_0x7F,_as_doing_so_will_roll_the_value_over_into_a_negative_number_and_trigger_extreme_lean-out!
    .byte 0x7F                       ;Point 1

	;.org	0xc1ad
AMLIML_MinMultiplierCannotBeBelow80:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0xC18C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinMultiplierCannotBeBelow80
    ;mptblcname AMLIML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AMLIML_establishes_the_maximum_negative_(enleanment)_authority_limit_permitted_for_any_adaptive_fuel_memory_cell._Stock_Value:_0xB3_(-77_signed_counts)._Min_Multiplier_=_1.0_-_(77_/_512)_~_0.850_(-15.0%)_Asymmetric_Safety:_Consistent_with_short-term_trims_(O2LIML),_adaptive_memory_allows_+24.8%_rich_authority,_but_limits_lean_authority_to_-15.0%_to_safeguard_against_engine_damage.
    .byte 0xB3                       ;Point 1

	;.org	0xc1ae
ADMEMA_ValueFromAdaptivememoryAdder1:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0xC18D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ValueFromAdaptivememoryAdder1
    ;mptblcname ADMEMA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ADMEMA_provides_a_global_calibration_offset_adder_applied_to_learned_adaptive_memory_fuel_modifiers_during_total_fuel_pulse_width_calculation._Stock_Setting:_0x00_(Neutral)._Tuning_Guidance:_Leave_at_0x00._Modifying_ADMEMA_applies_an_artificial_skew_across_all_adaptive_cells._Fuel_curve_changes_should_be_made_directly_in_base_fuel_tables_(MAPTBL)_rather_than_skewing_the_adaptive_integrator_adder.
    .byte 0x00                       ;Point 1

	;.org	0xc1af
MAPTBL_FuelPartThrottle:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0xC18E
    ;mptbltype 1
    ;mpsubtype 1
    ;mptbllname FuelPartThrottle
    ;mptblcname MAPTBL
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Pulsewidth 0 65535 uSec
    ;mptbldesc MAPTBL_is_the_core_part-throttle_speed-density_fuel_pulse_width_table._Increasing_Table_Values_(Richer_Part-Throttle_Fuel):_Effect:_Delivers_longer_injector_pulse_widths_across_the_specified_MAP_range._Real-World_Feel:_Enriches_cruising_air/fuel_ratios,_eliminates_light-throttle_lean_stumbles,_and_cools_down_cruising_exhaust_gas_temperatures_(EGTs).
    ;mpmapaxis x
    ;mpinjscale scale
    .byte 0x00                   ;Point 1
    .word 0x0000, 0x1CE3
    .byte 0x23                   ;Point 2
    .word 0x03F3, 0x29A2
    .byte 0x36                   ;Point 3
    .word 0x070A, 0x2180
    .byte 0x42                   ;Point 4
    .word 0x089C, 0x218E
    .byte 0x54                   ;Point 5
    .word 0x0AF8, 0x2180
    .byte 0x66                   ;Point 6
    .word 0x0D53, 0x3D00
    .byte 0x79                   ;Point 7
    .word 0x11DA, 0x3C9C
    .byte 0x90                   ;Point 8
    .word 0x174C, 0x3905
    .byte 0xC5                   ;Point 9
    .word 0x231A, 0x2B60
    .byte 0xE5                   ;Point 10
    .word 0x2886, 0x003B
    .byte 0xFF

	;.org	0xc1dc
OBCONST_OverboostConstant1:
; this was previously not scaled for 2-bar use correctly...
    ;mpgrp Utility\
    ;mptbladdr 0xC1C1
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostConstant1
    ;mptblcname OBCONST
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc OBCONST_defines_the_baseline_manifold_pressure_transition_threshold_used_during_running_fuel_pulse_width_and_spark_advance_calculation_to_bifurcate_moderate_part-throttle_fuel_scheduling_from_higher-load_boost_fuel_enrichment._Stock_Value:_0xAA_(_~_4.9_psig_boost_)._Transition_Point:_Below_4.9_psig_boost,_base_running_fuel_pulse_width_scales_according_to_the_primary_part-throttle_equations.
    ;mpmapaxis y
    .byte 0x71                       ;Point 1

	;.org	0xc1e2
PTPWOF_PartThrottlePulsewidthOffset:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0xC1C2
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname PartThrottlePulsewidthOffset
    ;mptblcname PTPWOF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis InjPW 0 65.5 mSec
    ;mptbldesc PTPWOF_is_the_boost-onset_fuel_rate_adder_for_part-throttle_driving._Physical_Effects_of_Raising_vs._Lowering:_Raising_the_Value_(Richer_Boost_Spool):_Delivers_more_extra_fuel_for_every_pound_of_boost_you_make_under_part-throttle_acceleration._If_your_engine_feels_like_it_hesitates,_surges,_or_pings_as_boost_begins_building_at_half-throttle,_bumping_this_value_up_will_richen_the_mixture_and_smooth_out_turbo_spool-up.
    .word 0x24EB                     ;Point 1
       ;.inj word scale

	;.org	0xc1e4
PTENR_EppPerAmountForIncreasing:
    ;mpgrp Fuel\Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0xC1C4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EppPerAmountForIncreasing
    ;mptblcname PTENR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc PTENR_sets_the_engine_position_pulse_countdown_timer_governing_the_rate_at_which_part-throttle_transient_enrichment_ramps_back_down_toward_baseline_fuel_delivery._Stock_Setting:_0x64_(100_pulses)._Increasing_PTENR:_Keeps_transient_enrichment_active_for_more_engine_cycles,_providing_a_richer,_longer_fuel_tail_following_acceleration_tip-in._Helps_prevent_lean_hesitation_on_heavy_vehicles_or_setups_with_large_intake_plenum_volumes.
    .byte 0x64                       ;Point 1

	;.org	0xc1e5
LMTOLF1_LimitTimerOpenLoopFraction1:
    ;mpgrp Fuel\Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0xC1C5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LimitTimerOpenLoopFraction1
    ;mptblcname LMTOLF1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc LMTOLF1_defines_the_primary_threshold_for_the_Open_Loop_Fraction_timer_(Timer_OpenLoopFraction)._This_timer_tracks_cumulative_time_spent_in_open-loop_transient_operating_conditions._Stock_Setting:_0x3C_(60_counts)._Tuning_Guidance:_Maintain_stock_calibration_values_to_preserve_smooth_open-to-closed_loop_transition_timing.
    .byte 0x3C                       ;Point 1

	;.org	0xc1e6
LMTOLF2_LimitTimerOpenLoopFraction2:
    ;mpgrp Fuel\Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0xC1C6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LimitTimerOpenLoopFraction2
    ;mptblcname LMTOLF2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc LMTOLF2_is_one_of_the_most_pervasive_gating_thresholds_in_the_Chrysler_ECU,_referenced_across_O2_processing,_adaptive_memory,_fuel_modifiers,_EVAP_purge_solenoid_control,_and_spark_advance._Stock_Value:_0x2B_(43_counts)._System_Interdependence:_Because_LMTOLF2_intersects_with_so_many_subsystems,_altering_it_affects_transient-to-steady-state_transitions_across_fuel,_spark,_and_emissions._Leave_at_factory_0x2B_for_stable_operation.
    .byte 0x2B                       ;Point 1

	;.org	0xc1e7
RPMLMT_RPMLimitForManyThings:
    ;mpgrp Utility\
    ;mptbladdr 0xC1C7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimitForManyThings
    ;mptblcname RPMLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc RPMMAP_serves_as_a_critical_engine_speed_boundary_(1856_RPM)_and_associated_lookup_curve_that_shifts_fuel_pulse_width_calculation_and_ignition_advance_between_low-RPM_lugging_algorithms_and_mid/high-RPM_running_algorithms._Stock_Breakpoint:_0x3A_(_58_32_=_1856_RPM_)._Tuning_Impact:_Defines_the_boundary_where_the_engine_transitions_from_low-speed_torque_management_to_high-speed_power_delivery.
    .byte 0x3A                       ;Point 1

	;.org	0xc1e8
RPMMAP_SwitchPointForDownUp_FromRpm :
    ;mpgrp Fuel\Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0xC1C8
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname SwitchPointForDownUp_FromRpm
    ;mptblcname RPMMAP
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc RPMMAP_serves_as_a_critical_engine_speed_boundary_(1856_RPM)_and_associated_lookup_curve_that_shifts_fuel_pulse_width_calculation_and_ignition_advance_between_low-RPM_lugging_algorithms_and_mid/high-RPM_running_algorithms._Stock_Breakpoint:_0x3A_(_58_32_=_1856_RPM_)._Tuning_Impact:_Defines_the_boundary_where_the_engine_transitions_from_low-speed_torque_management_to_high-speed_power_delivery.
    ;mpmapaxis y
    .byte 0x04                       ;Number of points in table
    .byte 0x4B, 0x77, 0xFF, 0x1F     ;Point 1
    .byte 0x64, 0x61, 0xFF, 0x80     ;Point 2
    .byte 0x74, 0x59, 0xFD, 0x00     ;Point 3
    .byte 0x7A, 0x47                 ;Point 4

	;.org	0xc1fb
RPMPSB_RPMMAPSubtractor:
    ;mpgrp Fuel\Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0xC1D7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMMAPSubtractor
    ;mptblcname RPMPSB
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc RPMPSB_defines_the_step_decrement_rate_applied_to_the_open-loop_fraction_accumulator_during_engine_deceleration_and_speed_changes._In_A2DScan_MM,_as_engine_operating_conditions_stabilize,_RPMPSB_subtracts_3_counts_per_cycle_from_the_open-loop_timer_accumulator,_steadily_decaying_transient_state_counters_back_toward_steady-state_closed-loop_thresholds._Stock_Value:_0x03._Tuning_Guidance:_Leave_at_default_0x03_to_maintain_intended_decay_dynamics.
    .byte 0x03                       ;Point 1

	;.org	0xc1fc
WOTTBL_FuelFullThrottle:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0xC1D8
    ;mptbltype 1
    ;mpsubtype 1
    ;mptbllname FuelFullThrottle
    ;mptblcname WOTTBL
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Pulsewidth 0 65535 uSec
    ;mptbldesc WOTTBL_is_the_core_wide-open_throttle_(WOT)_fuel_delivery_table_and_the_maximum_allowable_fuel_ceiling_for_part-throttle_boost_enrichment._Increasing_Table_Values_(Richer_WOT_Fuel):_Effect:_Injects_longer_fuel_pulses_under_boost_and_full_throttle._Real-World_Feel:_Lowers_wide-open_throttle_air/fuel_ratios_(richer),_cools_combustion_chambers,_and_suppresses_detonation_under_boost.
    ;mpmapaxis x
    ;mpinjscale scale
    .byte 0x00                   ;Point 1
    .word 0x0000, 0x2767
    .byte 0x72                   ;Point 2
    .word 0x118C, 0x325E
    .byte 0x90                   ;Point 3
    .word 0x1773, 0x37A1
    .byte 0xD6                   ;Point 4
    .word 0x26A9, 0x445E
    .byte 0xFF

	;.org	0xc211
MAPDEC_NoCellUpdateAndO2CNTRHeldBelowThisMap:
    ;mpgrp Fuel\O2_Feedback_Control\Adaptive_memory\
    ;mptbladdr 0xC1ED
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname NoCellUpdateAndO2CNTRHeldBelowThisMap
    ;mptblcname MAPDEC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc MAPDEC_is_the_master_manifold_pressure_boundary_above_which_the_closed-loop_O2_controller_is_forced_open-loop_and_adaptive_memory_updates_are_frozen._This_calibration_constant_serves_as_the_definitive_WOT_/_Boost_Open-Loop_switch._Stock_Value:_0xAA_(170_counts_~_19.6_psia_~_4.9_psig_boost_).
    ;mpmapaxis y
    .byte 0x71                       ;Point 1

	;.org	0xc212
MAPIDL_FuelBaselineFromMap:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0xC1EE
    ;mptbltype 1
    ;mpsubtype 1
    ;mptbllname FuelBaselineFromMap
    ;mptblcname MAPIDL
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Pulsewidth 0 65535 uSec
    ;mptbldesc MAPIDL_is_the_base_fuel_delivery_curve_used_exclusively_at_closed_throttle_(idling_and_trailing_throttle_deceleration_overrun)._Increasing_Table_Values_(Richer_Idle/Decel_Fuel):_Effect:_Enriches_closed-throttle_fuel_delivery._Real-World_Feel:_Stabilizes_idle_on_engines_with_aggressive_camshafts_that_produce_low_or_erratic_idle_vacuum._Eliminates_decel_popping/backfiring_through_the_exhaust_on_trailing_throttle.
    ;mpmapaxis x
    ;mpinjscale scale
    .byte 0x00                   ;Point 1
    .word 0x0000, 0x169E
    .byte 0x1A                   ;Point 2
    .word 0x024C, 0x1EAB
    .byte 0x23                   ;Point 3
    .word 0x0360, 0x2DDE
    .byte 0x32                   ;Point 4
    .word 0x0610, 0x33AD
    .byte 0x51                   ;Point 5
    .word 0x0C52, 0x2479
    .byte 0xFF

	;.org	0xc23b
AIRTMP_FuelEnrichmentFromChargeTemp:
    ;mpgrp Fuel\Modifiers\
    ;mptbladdr 0xC208
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelEnrichmentFromChargeTemp
    ;mptblcname AIRTMP
    ;mpxaxis Charge_Temp 0 5 volts
    ;mpyaxis Factor 1 2 factor
    ;mptbldesc AIRTMP_provides_the_intake_air_/_charge_temperature_air_density_fuel_compensation_curve._Cold_Weather_Protection:_In_sub-freezing_winter_weather,_AIRTMP_adds_up_to_+25%_fuel_to_prevent_dangerously_lean_mixtures_under_boost._Hot_Heat-Soak_Protection:_Prevents_over-fueling_and_bogging_when_intake_air_temperatures_rise_after_sitting_in_traffic.
    .byte 0x05                       ;Number of points in table
    .byte 0x1A, 0x00, 0x00, 0x29     ;Point 1
    .byte 0x59, 0x0A, 0x00, 0x2F     ;Point 2
    .byte 0x90, 0x14, 0x00, 0x4B     ;Point 3
    .byte 0xE9, 0x2E, 0x01, 0x00     ;Point 4
    .byte 0xFB, 0x40                 ;Point 5

	;.org	0xc24e
FuelLeanoutFactorOnThrottle:
    ;mpgrp Fuel\Modifiers\
    ;mptbladdr 0xC21B
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelLeanoutFactorOnThrottle
    ;mptblcname FUELLEANOUTFACTORONTHROTTLE
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Factor 1 2 factor
    ;mptbldesc FuelLeanoutFactorOnThrottle_defines_an_RPM-dependent_signed_fuel_pulsewidth_modifier_curve_active_during_open-throttle_driving._Values_use_signed_two's_complement_math:_0x00_is_neutral_(stock),_0x01-0x7F_(+1_to_+127)_adds_fuel,_and_0x80-0xFF_(-128_to_-1)_subtracts_fuel._In_turbocharged_applications,_leave_this_table_at_stock_zero_(0x00)_and_tune_fueling_via_the_primary_MAP_and_WOT_tables.
    .byte 0x04                       ;Number of points in table
    .byte 0x25, 0x03, 0x00, 0x24     ;Point 1
    .byte 0x2C, 0x04, 0x00, 0x2B     ;Point 2
    .byte 0x38, 0x06, 0xFF, 0x49     ;Point 3
    .byte 0x3F, 0x01                 ;Point 4

	;.org	0xc261
FuelLeanoutFactorOffThrottle:
    ;mpgrp Fuel\Modifiers\
    ;mptbladdr 0xC22A
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelLeanoutFactorOffThrottle
    ;mptblcname FUELLEANOUTFACTOROFFTHROTTLE
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Factor 1 2 factor
    ;mptbldesc FuelLeanoutFactorOffThrottle_is_a_signed_RPM-dependent_fuel_pulsewidth_modifier_curve_applied_during_closed-throttle_deceleration._Values_use_signed_two's_complement_math:_0x00_is_neutral,_0x01-0x7F_(+1_to_+127)_adds_fuel,_and_0x80-0xFF_(-128_to_-1)_subtracts_fuel._To_create_overrun_exhaust_burble_on_throttle_lift,_set_the_1500-3000_RPM_decel_points_slightly_negative_(e.g._0xFC_=_-4_or_0xF8_=_-8).
    .byte 0x05                       ;Number of points in table
    .byte 0x19, 0xE2, 0x01, 0x6E     ;Point 1
    .byte 0x20, 0xEC, 0x01, 0x80     ;Point 2
    .byte 0x26, 0xF5, 0x00, 0xAB     ;Point 3
    .byte 0x2C, 0xF9, 0x01, 0x55     ;Point 4
    .byte 0x32, 0x01                 ;Point 5

	;.org	0xc274
PWADD_FuelPWModifierFromBaro:
    ;mpgrp Fuel\Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0xC23D
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FuelPWModifierFromBaro
    ;mptblcname PWADD
    ;mpxaxis Baro -14.7 29.4 psi
    ;mpyaxis Pulsewidth 0 768 uSec
    ;mptbldesc PWADD_provides_an_additive_pulse_width_trim_curve_based_on_ambient_barometric_pressure_(altitude)._Stock_Calibration:_Flat_zero_(0x00)._The_speed-density_algorithm_and_MAP_sensor_handle_altitude_compensation_naturally_without_needing_an_additive_barometric_offset._Tuning_Guidance:_Leave_at_stock_zero_unless_specifically_compensating_for_non-standard_altitude-dependent_fuel_pressure_regulators.
    ;mpmapaxis x
    .byte 0x01                       ;Number of points in table
    .byte 0xAA, 0x00                 ;Point 1
       ;.inj table scale y

	;.org	0xc27b
FMODDV1_StandardFuelModifierDivisor_1:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0xC240
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StandardFuelModifierDivisor_1
    ;mptblcname FMODDV1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc FMODDV1_serves_as_the_internal_arithmetic_scaling_divisor_used_when_aggregating_composite_fuel_modifiers_into_the_final_running_fuel_multiplier._Stock_Setting:_0x1A_(26_decimal)._Do_Not_Touch:_Altering_FMODDV1_warps_the_internal_math_of_all_fuel_modifiers_simultaneously,_causing_gross_fueling_calibration_corruption.
    .byte 0x1A                       ;Point 1

	;.org	0xc27c
PEFTBL_PumpingEfficiency:
    ;mpgrp Fuel\Modifiers\
    ;mptbladdr 0xC241
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname PumpingEfficiency_FromRpm
    ;mptblcname PEFTBL
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis PumpEff 0 100 Percent
    ;mptbldesc PEFTBL_is_the_core_Volumetric_Efficiency_(VE)_curve_vs._Engine_RPM_in_the_Chrysler_speed-density_fuel_algorithm._The_Primary_VE_Shaping_Tool:_When_installing_an_aftermarket_performance_camshaft_(e.g._Taft,_FWD-P,_or_custom_grind),_cylinder_filling_shifts_toward_higher_RPMs._Low_RPM_Cam_Drop:_Big_camshafts_breathe_worse_at_low_RPM_(1500_-_2500_RPM)_due_to_overlap_reversion._Lowering_PEFTBL_here_cleans_up_rich_low-RPM_operation.
    .byte 0x05                       ;Number of points in table
    .byte 0x4B, 0xE5, 0x00, 0x09     ;Point 1
    .byte 0x67, 0xE6, 0x00, 0x53     ;Point 2
    .byte 0x86, 0xF0, 0x00, 0x00     ;Point 3
    .byte 0x89, 0xF0, 0xFF, 0x37     ;Point 4
    .byte 0xD3, 0xB6                 ;Point 5
    ;mp******************************
    ;mpwbtbl 01010101010101010101WOTTBL
    ;mpwbdata 700 0.200000002980232 14.16 22 255 1100 0 14.75 34 255 2500 0 15.41 78 255 2800 0.319999992847443 15.3 87 255 2900 0.529999971389771 13.58 90 255
    ;mpwbdata 3000 0.400000005960464 13.94 93 255 3100 1.02999997138977 14.17 96 255 3200 1.75999999046326 13.91 100 255 3300 2.0699999332428 14.02 103 255 3400 2.58999991416931 13.64 106 255
    ;mpwbdata 3500 3.58999991416931 13.3 109 255 3600 4 12.72 112 255 3700 4.57999992370605 12.9 115 255 3800 4.59000015258789 12.87 118 255 3900 4.42999982833862 12.67 121 255
    ;mpwbdata 4000 4.76999998092651 12.61 125 255 4100 5.01000022888184 12.41 128 255 4200 5.21000003814697 11.94 131 254 4300 5.30000019073486 11.71 134 250 4400 5.26000022888184 11.44 137 245
    ;mpwbdata 4500 5.71999979019165 11.07 140 235 4600 5.34999990463257 11.24 143 236 4700 5.59000015258789 11.1 146 231 4800 5.38000011444092 11.34 149 234 4900 5.17999982833862 11.38 153 232
    ;mpwbdata 5000 4.90000009536743 11.59 156 234 5100 4.92999982833862 11.5 159 230 5200 4.48000001907349 12.06 162 239 5300 4.94000005722046 11.15 165 219 5400 4.73000001907349 11.07 168 215
    ;mpwbdata 5500 4.94999980926514 10.89 171 210 5600 5.17999982833862 10.54 174 201 5700 5.98000001907349 10.09 177 191 5800 5.67000007629395 10.38 181 193 5900 6.09999990463257 10.16 184 187
    ;mpwbdata 6000 6.15000009536743 10.08 187 184
    ;mp******************************

	;.org	0xc28f
BATOFF_FuelBatteryOffset:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0xC254
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelBatteryOffset
    ;mptblcname BATOFF
    ;mpxaxis Battery 0 16.2 Volts
    ;mpyaxis Pulsewidth 0 2040 uSec
    ;mptbldesc BATOFF_defines_the_injector_dead_time_/_battery_latency_compensation_curve_as_a_function_of_system_electrical_voltage._Aftermarket_Injector_Tuning:_When_installing_modern_high-impedance_or_large_aftermarket_injectors_(e.g.,_Bosch_EV14s,_Deka_60s,_or_RC_injectors),_setting_accurate_BATOFF_values_is_critical._Different_injector_coils_have_vastly_different_opening_latencies.
    .byte 0x04                       ;Number of points in table
    .byte 0x59, 0x8A, 0xFE, 0x1A     ;Point 1
    .byte 0x80, 0x40, 0xFF, 0x3E     ;Point 2
    .byte 0xC2, 0x0E, 0xFF, 0xC6     ;Point 3
    .byte 0xFB, 0x01                 ;Point 4

	;.org	0xc29e
RNFPRD_FuelStartRunTransferPointRpm:
    ;mpgrp Spark\Start_to_Run_Transfer\
    ;mptbladdr 0xC263
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname FuelStartRunTransferPointRpm
    ;mptblcname RNFPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis EPPs 0 65535 epps
    ;mptbldesc RNFPRD_is_the_fuel_injection_start-to-run_transfer_RPM_threshold._During_cranking,_injectors_deliver_rich,_fixed-duration_priming_pulses_designed_to_wet_the_intake_ports_and_cylinders_so_the_engine_can_catch_fire._Increasing_the_Value_(Lower_RPM_Threshold):_Effect:_Cuts_off_cranking_enrichment_at_a_lower_RPM_(e.g.,_550_RPM)._Real-World_Driving_Feel:_Prevents_engine_flooding_on_warm_restarts_or_when_running_oversized_fuel_injectors.
    .word 0x00A7                     ;Point 1

	;.org	0xc2a0
STFPRD_FuelRunStartTransferPointRpm:
    ;mpgrp Spark\Start_to_Run_Transfer\
    ;mptbladdr 0xC265
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname FuelRunStartTransferPointRpm
    ;mptblcname STFPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis EPPs 0 65535 epps
    ;mptbldesc STFPRD_is_the_fuel_stall-detection_hysteresis_threshold_that_drops_fuel_injection_back_from_running_speed-density_mode_into_cranking_enrichment_mode_if_engine_RPM_sags_below_~450_RPM._Increasing_the_Value_(Lower_RPM_Threshold):_Effect:_Allows_the_engine_to_drop_lower_in_speed_before_re-triggering_cranking_fuel._Real-World_Driving_Feel:_Prevents_sudden_rich_bogging_when_lugging_the_engine_at_low_speeds.
    .word 0x0104                     ;Point 1

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

	;.org	0xc2a2
HIGHMP_ColdLoadFromCoolantTemp:
    ;mpgrp Fuel\Modifiers\
    ;mptbladdr 0xC267
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ColdLoadFromCoolantTemp
    ;mptblcname HIGHMP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis enrichment 0 100 Percent
    ;mptbldesc HIGHMP_provides_the_temperature-dependent_gain_for_Cold_Engine_High-Load_Enrichment._Cold_Driveability:_Prevents_cold-engine_hesitation_or_backfiring_when_accelerating_onto_the_highway_immediately_after_starting._Tuning_Guidance:_If_an_engine_bogs_heavily_under_throttle_when_cold,_slightly_decrease_HIGHMP._If_it_stumbles_lean,_increase_it.
    .byte 0x04                       ;Number of points in table
    .byte 0x58, 0x90, 0xFE, 0xE9     ;Point 1
    .byte 0x84, 0x60, 0xFD, 0xB2     ;Point 2
    .byte 0x9B, 0x2B, 0xFF, 0x24     ;Point 3
    .byte 0xCD, 0x00                 ;Point 4

	;.org	0xc2b1
HMPMUL_ColdLoadFromMAP:
    ;mpgrp Fuel\Modifiers\
    ;mptbladdr 0xC276
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname ColdLoadFromMAP
    ;mptblcname HMPMUL
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Facto 0 100 percent
    ;mptbldesc HMPMUL_defines_the_manifold_load_weighting_curve_for_cold-engine_high-load_enrichment._Works_in_partnership_with_HIGHMP:_while_HIGHMP_dictates_how_cold_the_engine_is,_HMPMUL_dictates_how_heavily_the_throttle_is_loaded._At_high_vacuum_(idle/coast),_HMPMUL_is_near_zero_(no_cold_load_fuel_added)._Load_Progression:_Ensures_cold_enrichment_is_applied_only_when_the_engine_is_under_load,_keeping_cold_idle_smooth_and_unflooded.
    ;mpmapaxis x
    .byte 0x04                       ;Number of points in table
    .byte 0x36, 0x00, 0x01, 0x0A     ;Point 1
    .byte 0x4F, 0x1A, 0x00, 0x59     ;Point 2
    .byte 0x66, 0x22, 0xFD, 0x92     ;Point 3
    .byte 0x6D, 0x11                 ;Point 4

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

	;.org	0xc2c0
CURVEB_FuelColdEnrichmentCurveB:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0xC285
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelColdEnrichmentCurveB
    ;mptblcname CURVEB
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 2 factor
    ;mptbldesc CURVEB_is_the_long-term_/_steady-state_warm-up_enrichment_curve_applied_as_the_engine_warms_from_cold_start_up_to_normal_operating_temperature._Increasing_Table_Values_(Richer_Warm-Up):_Injects_additional_fuel_during_the_extended_warm-up_period._Real-world_feel:_Eliminates_cold_bucking,_stumbling,_or_surging_during_light_acceleration_in_the_first_few_minutes_of_driving_after_a_cold_start.
    .byte 0x07                       ;Number of points in table
    .byte 0x58, 0x70, 0xFE, 0x37     ;Point 1
    .byte 0x74, 0x3E, 0xFE, 0x77     ;Point 2
    .byte 0x90, 0x13, 0xFF, 0x20     ;Point 3
    .byte 0xA0, 0x05, 0xFF, 0xE4     ;Point 4
    .byte 0xCD, 0x00, 0x00, 0x00     ;Point 5
    .byte 0xE8, 0x00, 0x02, 0x2B     ;Point 6
    .byte 0xF4, 0x1A                 ;Point 7

	;.org	0xc2db
CURVEA_FuelColdEnrichmentCurveA:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0xC2A0
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelColdEnrichmentCurveA
    ;mptblcname CURVEA
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 1 2 factor
    ;mptbldesc CURVEA_is_the_initial_post-start_enrichment_curve_(often_called_"After-Start_Enrichment"_or_ASE)._Increasing_Table_Values_(Richer_Post-Start):_Delivers_heavier_enrichment_during_the_first_30-60_seconds_after_startup._Real-world_feel:_Fixes_post-start_idle_stumble_or_stalling_that_occurs_5-10_seconds_after_a_cold_morning_start._Decreasing_Table_Values_(Leaner_Post-Start):_Leans_out_initial_post-start_fuel.
    .byte 0x06                       ;Number of points in table
    .byte 0x58, 0xFF, 0xFA, 0xC9     ;Point 1
    .byte 0x74, 0x6D, 0xFD, 0xC0     ;Point 2
    .byte 0x84, 0x49, 0xFD, 0xC9     ;Point 3
    .byte 0x92, 0x2A, 0xFF, 0xAD     ;Point 4
    .byte 0xB1, 0x20, 0xFF, 0xC1     ;Point 5
    .byte 0xE6, 0x13                 ;Point 6

	;.org	0xc2f2
CURVEC_FuelColdEnrichmentCurveC:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0xC2B7
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelColdEnrichmentCurveC
    ;mptblcname CURVEC
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 1 3 factor
    ;mptbldesc CURVEC_is_the_intermediate_warm-up_enrichment_curve_in_Chrysler's_tripartite_cold_enrichment_architecture._Increasing_Table_Values_(Richer_Intermediate_Warmup):_Delivers_extra_fuel_during_the_intermediate_warm-up_phase_(1-3_minutes_into_driving)._Real-world_feel:_Fixes_lean_hesitations_or_stumbling_that_occur_just_as_the_vehicle_drives_out_of_the_driveway_on_cold_mornings.
    .byte 0x05                       ;Number of points in table
    .byte 0x79, 0x40, 0xFF, 0xA3     ;Point 1
    .byte 0x84, 0x3C, 0xFF, 0x55     ;Point 2
    .byte 0x8D, 0x36, 0xFE, 0x33     ;Point 3
    .byte 0x92, 0x2D, 0xFF, 0x38     ;Point 4
    .byte 0xA9, 0x1B                 ;Point 5

	;.org	0xc309
DCYTMC_CurveAColdDecayTime:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0xC2CA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAColdDecayTime
    ;mptblcname DCYTMC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DCYTMC_sets_the_decay_rate_of_post-start_enrichment_(CURVEA)_when_the_engine_is_started_cold_(coolant_temperature_below_TMPHLD)._Decay_Formula:_Decay_time_in_seconds_is_calculated_as:_Decay_Duration_~_(89.76_/_DCYTMC)_Increasing_Value:_Results_in_a_faster_decay_rate_(Curve_A_enrichment_fades_out_more_quickly)._Decreasing_Value:_Results_in_a_slower_decay_rate_(Curve_A_enrichment_lingers_longer).
    .byte 0x04                       ;Point 1

	;.org	0xc30a
DCYTMH_CurveAHotDecayTime:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0xC2CB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAHotDecayTime
    ;mptblcname DCYTMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DCYTMH_sets_the_decay_rate_of_post-start_enrichment_(CURVEA)_when_the_engine_is_started_hot_(coolant_temperature_at_or_above_TMPHLD)._Because_a_warm_engine_already_has_hot_intake_valves_and_warm_combustion_chamber_walls,_it_does_not_need_prolonged_post-start_enrichment._Decay_Formula:_Hot_Decay_Duration_~_(89.76_/_DCYTMH)_Stock_Setting_(0x09):_Yields_a_rapid_decay_of_roughly_~10_seconds,_clearing_out_excess_fuel_quickly_on_warm_restarts.
    .byte 0x06                       ;Point 1

	;.org	0xc30b
CLDHLD_CurveAColdHoldTime:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0xC2CC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAColdHoldTime
    ;mptblcname CLDHLD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 180 out
    ;mptbldesc CLDHLD_specifies_the_duration_that_post-start_enrichment_(CURVEA)_is_held_at_100%_full_strength_before_decay_begins,_following_a_cold_engine_start._Increasing_the_Value:_Holds_full_cold_after-start_enrichment_longer_(e.g.,_2+_minutes)._Helpful_for_extreme_sub-zero_winter_climates_or_E85_conversions._Decreasing_the_Value:_Begins_decaying_cold_enrichment_sooner.
    .byte 0x80                       ;Point 1

	;.org	0xc30c
HOTHLD_CurveAHotHoldTime:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0xC2CD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAHotHoldTime
    ;mptblcname HOTHLD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HOTHLD_sets_the_duration_that_post-start_enrichment_(CURVEA)_is_held_at_full_strength_when_restarting_a_warm/hot_engine._On_a_warm_engine,_holding_post-start_fuel_for_90_seconds_(like_cold_starts)_would_cause_severe_rich_loading_and_exhaust_odor._Increasing_Value:_Extends_the_hold_window_on_warm_starts,_helping_combat_hot-soak_vapor_lock_or_lean_surges_on_quick_gas_station_restarts._Decreasing_Value:_Reduces_warm_start_hold_time.
    .byte 0x16                       ;Point 1

	;.org	0xc30d
TMPHLD_TempSwitchPointForCurveAHoldDecay:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0xC2CE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TempSwitchPointForCurveAHoldDecay
    ;mptblcname TMPHLD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc TMPHLD_is_the_coolant_temperature_switch_point_that_selects_between_the_Cold_Hold/Decay_parameters_(CLDHLD_&_DCYTMC)_and_the_Hot_Hold/Decay_parameters_(HOTHLD_&_DCYTMH)._Thermostat_Matching:_In_stock_calibrations,_0xB2_corresponds_to_~178_degF,_matching_the_OEM_180_degF_thermostat._If_using_a_cooler_160_degF_thermostat,_lowering_TMPHLD_slightly_ensures_the_ECU_correctly_classifies_warm_restarts_under_hot_decay_rules.
    .byte 0xB2                       ;Point 1

	;.org	0xc30e
CCURV_HoldTimeForCurveC:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0xC2CF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HoldTimeForCurveC
    ;mptblcname CCURV
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 180 out
    ;mptbldesc CCURV_specifies_the_duration_that_intermediate_cold_enrichment_(CURVEC)_is_held_at_full_strength_before_decay_begins._Tuning_Tip:_Increasing_CCURV_extends_the_initial_dwell_of_intermediate_enrichment,_helping_smooth_cold-start_transitions_on_vehicles_with_large_aftermarket_intake_manifolds_or_cold_aluminum_cylinder_heads.
    .byte 0x07                       ;Point 1

	;.org	0xc30f
DCYCC_DecayRateForCurveC:
    ;mpgrp Fuel\Running\
    ;mptbladdr 0xC2D0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DecayRateForCurveC
    ;mptblcname DCYCC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DCYCC_dictates_the_decay_rate_of_intermediate_warm-up_enrichment_(CURVEC)._After_intermediate_enrichment_is_held_for_the_duration_specified_by_CCURV,_DCYCC_controls_the_speed_at_which_Curve_C's_enrichment_multiplier_ramps_down_to_zero._Increasing_the_Value:_Causes_intermediate_warm-up_enrichment_to_decay_faster_(shorter_duration)._Decreasing_the_Value:_Causes_intermediate_warm-up_enrichment_to_decay_slower_(longer_duration).
    .byte 0x0F                       ;Point 1

	;.org	0xc310
BAROCP_BaroCompensationOfWarmupFactor_FromBaro:
    ;mpgrp Fuel\Modifiers\
    ;mptbladdr 0xC2D1
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BaroCompensationOfWarmupFactor_FromBaro
    ;mptblcname BAROCP
    ;mpxaxis Baro -14.7 29.4 psi
    ;mpyaxis Factor 0 100 Percent
    ;mptbldesc BAROCP_scales_cold_warmup_fuel_enrichment_based_on_ambient_atmospheric_pressure_(altitude)._At_high_elevations,_reduced_ambient_barometric_pressure_decreases_overall_air_density._Stock_Values:_Factory_values_maintain_full_warmup_fuel_at_sea_level_and_taper_fuel_slightly_at_mountain_elevations_(e.g._5,000+_ft_in_Denver)._Tuning_Guidance:_Preserve_factory_curve.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x3F, 0xF3, 0x01, 0x80     ;Point 1
    .byte 0x47, 0xFF                 ;Point 2

	;.org	0xc317
RUNTMP_ModifierOf_ENGTMP_FromStalltime:
    ;mpgrp Fuel\Modifiers\
    ;mptbladdr 0xC2D8
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ModifierOf_ENGTMP_FromStalltime
    ;mptblcname RUNTMP
    ;mpxaxis time_after_stall 0 720 sec
    ;mpyaxis delta 0 720 temp
    ;mptbldesc RUNTMP_models_engine_heat_soak_following_an_engine_stall_or_brief_hot_restart._Preventing_Hot_Restart_Flooding:_By_recognizing_that_the_engine_metal_is_hotter_than_the_stagnant_coolant_sensor_indicates,_this_table_prevents_the_ECU_from_injecting_unnecessary_cold-start_fuel_on_quick_restarts.
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x00, 0x03, 0xAB     ;Point 1
    .byte 0x06, 0x16, 0x09, 0x00     ;Point 2
    .byte 0x0B, 0x43                 ;Point 3

	;.org	0xc322
RUNLMT_MaxAllowableTempFor_RUNTMP:
    ;mpgrp Fuel\Modifiers\
    ;mptbladdr 0xC2E3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxAllowableTempFor_RUNTMP
    ;mptblcname RUNLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc RUNLMT_defines_the_maximum_baseline_coolant_temperature_below_which_heat_soak_addition_(RUNTMP)_is_permitted._Heat_soak_modeling_is_only_relevant_when_an_engine_stalls_while_warming_up._If_the_engine_is_already_at_operating_temperature,_heat_soak_calculations_are_bypassed_to_prevent_artificial_temperature_inflation._Stock_Setting:_0x95_(_~_64_degF_)._Tuning_Guidance:_Leave_at_stock_setting.
    .byte 0x95                       ;Point 1

	;.org	0xc323
MAPTRG_DeltaMapTriggerLevel:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0xC2E4
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapTriggerLevel
    ;mptblcname MAPTRG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 44.1 psi
    ;mptbldesc MAPTRG_establishes_the_minimum_rate_of_manifold_pressure_increase_(_DeltaMAP_)_required_to_fire_a_MAP_Acceleration_Enrichment_Pump_Shot._When_the_throttle_is_snapped_open,_manifold_absolute_pressure_spikes_upward_almost_instantly._Stock_Value:_0x05_(_~_0.58_psi_jump)._Lowering_MAPTRG_(e.g.,_to_2_or_3_counts):_Makes_the_ECU_highly_sensitive_to_throttle_movements,_firing_acceleration_enrichment_on_smaller_throttle_nudges.
    ;mpmapaxis y
    .byte 0x03                       ;Point 1

	;.org	0xc324
MAPMAX_MaxDeltaMapAllowed:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0xC2E5
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MaxDeltaMapAllowed
    ;mptblcname MAPMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 44.1 psi
    ;mptbldesc MAPMAX_defines_the_maximum_allowable_DeltaMAP_value_permitted_when_calculating_the_size_of_a_MAP_acceleration_enrichment_pump_shot._Stock_Value:_0xFF_(255_counts_-_completely_uncapped)._Tuning_Guidance:_In_stock_form,_Chrysler_left_this_ceiling_at_255_to_allow_full_maximum_pump_shot_delivery_on_violent_throttle_stabs.
    ;mpmapaxis y
    .byte 0xAA                       ;Point 1

	;.org	0xc325
AESLOP_DeltaMAPEnrichment_FromTemp2:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0xC2E6
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DeltaMAPEnrichment_FromTemp2
    ;mptblcname AESLOP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis pwEnrich 0 255 uS/torr
    ;mptbldesc AESLOP_defines_the_temperature-dependent_gain_curve_for_MAP-based_acceleration_enrichment_pump_shots._Increasing_AESLOP_Values:_Injects_more_fuel_on_quick_throttle_movements._Cures_lean_tip-in_stumbles,_backfiring_through_the_intake_manifold,_or_hesitations_upon_sudden_acceleration._Decreasing_AESLOP_Values:_Necessary_when_installing_larger_injectors.
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x58, 0x17, 0xFF, 0xD2     ;Point 1
    .byte 0x90, 0x0D, 0xFF, 0xD2     ;Point 2
    .byte 0xCD, 0x02                 ;Point 3

	;.org	0xc330
AETIME_EnrichmentTime_FromTemp:
; this is actually one of the 2 MAP averaging factor tables
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0xC2F1
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname EnrichmentTime_FromTemp_MAP
    ;mptblcname AETIME
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis time_const 0 100 percent
    ;mptbldesc AETIME_establishes_the_decay_time_constant_for_MAP-based_transient_enrichment._Stock_Setting:_0x14_(20_counts)._Increasing_AETIME:_Stretches_the_duration_of_the_MAP_pump_shot_across_more_engine_revolutions._Helps_engines_with_heavy_turbo_lag_or_large_intake_plenums_maintain_smooth_AFR_while_boost_builds._Decreasing_AETIME:_Quenches_the_pump_shot_quicker.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x14                 ;Point 1

	;.org	0xc337
POSTRG_PositiveTransientTriggerLevel:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0xC2F4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PositiveTransientTriggerLevel
    ;mptblcname POSTRG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc POSTRG_sets_the_throttle_position_sensor_delta_trigger_threshold_(_DeltaTPS_)_required_to_fire_a_TPS_Acceleration_Enrichment_Pump_Shot._Stock_Value:_0x04_(_0.08_V_throttle_opening)._Lowering_POSTRG:_Increases_throttle_hair-trigger_response._If_set_too_sensitive_(e.g._1_count_/_0.02V),_foot_vibration_over_bumps_will_trigger_unintended_pump_shots.
    .byte 0x04                       ;Point 1

	;.org	0xc338
THRMAX_MaxDeltaTHR:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0xC2F5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxDeltaTHR
    ;mptblcname THRMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc THRMAX_defines_the_maximum_allowable_DeltaTPS_clamp_applied_when_calculating_the_volume_of_a_TPS_acceleration_pump_shot._Stock_Setting:_0x26_(_0.76_V_)._Scaling_for_Large_Injectors:_When_upgrading_to_large_injectors_(+40%,_+52_lb/hr),_reducing_THRMAX_prevents_the_car_from_bogging_or_stumbling_rich_when_the_throttle_is_kicked_open_aggressively_from_a_dead_stop.
    .byte 0x26                       ;Point 1

	;.org	0xc339
POSSLP_DeltaTPSEnrichment_FromTemp:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0xC2F6
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname Enrichment_FromTemp
    ;mptblcname POSSLP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis pw 0 60 ms/volt
    ;mptbldesc POSSLP_defines_the_temperature-dependent_gain_curve_for_TPS-based_acceleration_enrichment_pump_shots._Increasing_Table_Values:_Cures_instant_off-idle_hesitation_or_stumble_when_stabbing_the_throttle_pedal._Decreasing_Table_Values:_Crucial_when_upsizing_fuel_injectors_(+40%,_+52_lb/hr)_to_avoid_flooding_the_engine_on_sudden_throttle_tip-in.
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x74, 0x0F, 0xFF, 0xAE     ;Point 1
    .byte 0x90, 0x06, 0xFF, 0xF0     ;Point 2
    .byte 0xB1, 0x04                 ;Point 3

	;.org	0xc344
THRTCN_EnrichmentTime_FromTemp:
    ;mpgrp Fuel\Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0xC301
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname EnrichmentTime_FromTemp
    ;mptblcname THRTCN
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis time_const 0 100 percent
    ;mptbldesc THRTCN_defines_the_decay_time_constant_for_TPS-based_acceleration_enrichment._Following_a_throttle_opening_transient,_this_curve_dictates_how_long_the_TPS_fuel_shot_is_sustained_before_decaying_back_to_steady-state_fuel_delivery._Increasing_Table_Values:_Lengthens_the_duration_of_the_TPS_enrichment_pulse._Decreasing_Table_Values:_Shortens_duration,_making_throttle_response_snappier.
    .byte 0x02                       ;Number of points in table
    .byte 0x74, 0x18, 0x00, 0x17     ;Point 1
    .byte 0xCD, 0x20                 ;Point 2

	;.org	0xc34f
MINDLM_MinDeltaMAPForPTE:
    ;mpgrp Fuel\Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0xC308
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinDeltaMAPForPTE
    ;mptblcname MINDLM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc MINDLM_specifies_the_minimum_manifold_pressure_rate_of_change_(_DeltaMAP_)_required_to_set_the_Part_Throttle_Enrichment_(PTE)_operating_flag._PTE_is_a_continuous_transient_enrichment_multiplier_applied_to_injector_pulse_width_during_prolonged_acceleration._Stock_Setting:_0x05_(_~_0.58_psi_)._Tuning_Guidance:_Stock_values_provide_excellent_noise_immunity.
    .byte 0x07                       ;Point 1

	;.org	0xc350
MINCTS_MinCoolantTempForPTE:
    ;mpgrp Fuel\Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0xC309
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinCoolantTempForPTE
    ;mptblcname MINCTS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc MINCTS_sets_the_minimum_coolant_temperature_required_to_allow_Part_Throttle_Enrichment_(PTE)_flag_activation._On_cold_engines_(below_138_degF),_cold_warmup_enrichment_curves_(CURVEA/CURVEB)_already_deliver_substantial_supplemental_fuel._Stock_Setting:_0xB1_(_~_138_degF_)._Tuning_Guidance:_If_using_a_160_degF_thermostat,_ensure_MINCTS_is_not_set_above_operating_temperatures.
    .byte 0xFF                       ;Point 1

	;.org	0xc351
MINERT_MinTimeForPTE:
    ;mpgrp Fuel\Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0xC30A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinTimeForPTE
    ;mptblcname MINERT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc MINERT_establishes_the_minimum_dwell_time_filter_that_an_acceleration_transient_must_persist_before_the_PTE_flag_is_asserted._Brief,_momentary_pressure_spikes_lasting_only_one_ADC_sample_cycle_(such_as_road_bumps_shaking_the_intake)_are_filtered_out_by_requiring_the_transient_condition_to_sustain_for_at_least_MINERT_consecutive_sampling_intervals._Stock_Value:_0x02_(2_sample_passes)._Tuning_Guidance:_Leave_at_default_0x02.
    .byte 0x02                       ;Point 1

	;.org	0xc352
MINRPM_MinRPMforPTE:
    ;mpgrp Fuel\Transient_Enrichment\Part_Throttle_Enrichment\
    ;mptbladdr 0xC30B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinRPMforPTE
    ;mptblcname MINRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc MINRPM_sets_the_minimum_engine_speed_required_to_activate_Part_Throttle_Enrichment._Stock_Value:_0x23_(_1120_RPM_)._Tuning_Guidance:_If_your_car_has_a_high-stall_torque_converter_or_aggressive_camshaft_that_idles_around_1100_RPM,_raise_MINRPM_slightly_(e.g.,_to_1250_RPM)_so_off-idle_blips_don't_trip_PTE_prematurely.
    .byte 0x23                       ;Point 1

	;.org	0xc353
MNDCRP_MinRPMforDecelLeanout:
    ;mpgrp Fuel\Transient_Enrichment\Decel_Lean-out\
    ;mptbladdr 0xC30C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinRPMforDecelLeanout
    ;mptblcname MNDCRP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc MNDCRP_defines_the_absolute_minimum_engine_speed_threshold_below_which_Deceleration_Fuel_Leanout_is_aborted._Stock_Setting:_0x14_(_640_RPM_)._Preventing_Decel_Stalls:_On_lightweight_flywheels_or_aggressive_camshafts,_cars_often_stall_when_clutching_in_during_decel._Raising_MNDCRP_to_0x20-0x24_(1024-1152_RPM)_terminates_decel_leanout_earlier,_allowing_fuel_delivery_to_resume_well_before_idle_speed_and_preventing_stalling.
    .byte 0x14                       ;Point 1

	;.org	0xc354
MNDCTM_MinTimeforDecelLeanout:
    ;mpgrp Fuel\Transient_Enrichment\Decel_Lean-out\
    ;mptbladdr 0xC30D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinTimeforDecelLeanout
    ;mptblcname MNDCTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc MNDCTM_specifies_the_minimum_hold_duration_required_before_deceleration_fuel_leanout_can_commence._This_delay_prevents_momentary_throttle_lifts_during_quick_manual_gear_shifts_from_triggering_decel_leanout,_avoiding_jerky_driveline_bucking_between_gear_changes._Stock_Setting:_0x02_(2_counts)._Tuning_Guidance:_Keeps_gear_changes_smooth_and_seamless.
    .byte 0x02                       ;Point 1

	;.org	0xc355
DMDCIC_DeltaMAPLeanoutIncrement:
    ;mpgrp Fuel\Transient_Enrichment\Decel_Lean-out\
    ;mptbladdr 0xC30E
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMAPLeanoutIncrement
    ;mptblcname DMDCIC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc DMDCIC_establishes_the_step_rate_at_which_the_deceleration_leanout_multiplier_increments_towards_its_maximum_leanout_authority._Rather_than_cutting_fuel_instantaneously_(which_causes_driveline_shock),_the_ECU_ramps_fuel_down_progressively_by_adding_DMDCIC_counts_each_cycle_until_reaching_DMLMT._Stock_Value:_0x02._Increasing_DMDCIC:_Ramps_leanout_in_faster._Decreasing_DMDCIC:_Softer,_smoother_decel_transition.
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

	;.org	0xc356
DMDCDC_DeltaMAPLeanoutDecrement:
    ;mpgrp Fuel\Transient_Enrichment\Decel_Lean-out\
    ;mptbladdr 0xC30F
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMAPLeanoutDecrement
    ;mptblcname DMDCDC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc DMDCDC_specifies_the_step_rate_at_which_deceleration_leanout_decays_back_to_normal_running_fueling_when_throttle_is_re-applied._When_exiting_deceleration,_normal_fueling_must_be_restored_faster_than_it_entered_to_eliminate_throttle_re-application_lag._DMDCDC_is_configured_higher_than_DMDCIC_(2_counts)_to_ensure_rapid_fueling_recovery._Stock_Setting:_0x03._Tuning_Guidance:_Faster_exit_than_entry_ensures_responsive_tip-in_coming_off_decel.
    ;mpmapaxis y
    .byte 0x02                       ;Point 1

	;.org	0xc357
DMLMT_DeltaMAPLeanoutLimit:
    ;mpgrp Fuel\Transient_Enrichment\Decel_Lean-out\
    ;mptbladdr 0xC310
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMAPLeanoutLimit
    ;mptblcname DMLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc DMLMT_establishes_the_maximum_authority_clamp_for_deceleration_fuel_leanout._Caps_the_maximum_fuel_reduction_that_the_deceleration_algorithm_is_permitted_to_enforce,_ensuring_the_mixture_does_not_become_so_lean_as_to_cause_backfiring_or_exhaust_popping._Stock_Setting:_0x08._Tuning_Guidance:_Increasing_DMLMT_produces_more_aggressive_decel_fuel_cutting;_lowering_DMLMT_reduces_decel_exhaust_gurgle/pops.
    ;mpmapaxis y
    .byte 0x05                       ;Point 1

	;.org	0xc358
TMDCNT_TimerLeanoutInitial:
    ;mpgrp Fuel\Transient_Enrichment\Decel_Lean-out\
    ;mptbladdr 0xC311
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimerLeanoutInitial
    ;mptblcname TMDCNT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc TMDCNT_sets_the_initial_reload_value_for_the_deceleration_leanout_duration_timer._Governs_how_long_decel_leanout_is_sustained_before_beginning_automatic_timeout_recovery._Stock_Value:_0xED_(237_counts)._Tuning_Guidance:_Controls_sustained_decel_leanout_holding_time.
    .byte 0xED                       ;Point 1

	;.org	0xc359
LMAPTC_TimeConstant:
; this is actually one of the 2 MAP averaging factor constants
    ;mpgrp Fuel\Transient_Enrichment\Decel_Lean-out\
    ;mptbladdr 0xC312
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeConstant
    ;mptblcname LMAPTC
    ;mpxaxis X 0 255 in
    ;mpyaxis time_const 0 100 percent
    ;mptbldesc LMAPTC_specifies_the_digital_filtering_time_constant_applied_to_MAP_transient_decay_calculations._Works_as_the_time-constant_coefficient_in_the_rolling_average_digital_filter_that_tracks_manifold_pressure_transients_during_decel_and_recovery._Stock_Setting:_0x28_(40_counts)._Tuning_Guidance:_Modulates_rolling_MAP_average_lag._Leave_stock.
    .byte 0x5A                       ;Point 1

	;.org	0xc35a
TestedAgainstMAPPressureDuringTransientCalc:
    ;mpgrp Fuel\Transient_Enrichment\
    ;mptbladdr 0xC313
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname TestedAgainstMAPPressureDuringTransientCalc
    ;mptblcname TESTEDAGAINSTMAPPRESSUREDURINGTRANSIENTCALC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis psi 0 44.1 psi
    ;mptbldesc TESTEDAGAINSTMAPPRESSUREDURINGTRANSIENTCALC_defines_the_manifold_pressure_transient_verification_threshold_used_during_full-throttle_(WOT)_transition_checks._Stock_Value:_0x0A_(_~_1.15_psi_)._Tuning_Guidance:_Protects_against_false_WOT_triggers_on_noisy_throttle_signals.
    ;mpmapaxis y
    .byte 0x07                       ;Point 1

	;.org	0xc35b
AISTRT_AisStartupPosition_FromTemp:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0xC314
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisStartupPosition_FromTemp
    ;mptblcname AISTRT
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis AIS_Open 0 255 steps
    ;mptbldesc AISTRT_is_a_2D_lookup_table_that_establishes_the_open-loop_baseline_step_position_for_the_Automatic_Idle_Speed_(AIS)_stepper_motor_actuator_during_engine_cranking_and_initial_startup._Increasing_Table_Values:_Forces_the_AIS_motor_to_open_wider_during_startup.
    .byte 0x05                       ;Number of points in table
    .byte 0x6E, 0x9B, 0xFB, 0xAF     ;Point 1
    .byte 0x87, 0x2F, 0xFF, 0x76     ;Point 2
    .byte 0xCF, 0x08, 0x00, 0x00     ;Point 3
    .byte 0xE4, 0x08, 0x00, 0x20     ;Point 4
    .byte 0xF4, 0x0A                 ;Point 5

	;.org	0xc36e
DRIDHT_AdditionalStartupIdle:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0xC327
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisAdditionalStartupIdle
    ;mptblcname DRIDHT
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc DRIDHT_defines_a_calibrated_idle_speed_adder_that_is_appended_to_the_base_coolant-dependent_target_idle_speed_right_after_the_engine_starts._Increasing_DRIDHT:_Produces_a_more_pronounced_initial_post-start_idle_flare,_keeping_engine_speed_elevated_for_positive_oil_pressure_buildup_and_stall_avoidance_on_cold_mornings_or_with_lightweight_flywheels._Decreasing_DRIDHT:_Lowers_post-cranking_flare_RPM,_yielding_a_quieter,_softer_start.
    .byte 0x0D                       ;Point 1

	;.org	0xc36f
STTIME_AdditionalStartupIdleTime:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0xC328
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisAdditionalStartupIdleTime
    ;mptblcname STTIME
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc STTIME_sets_the_time_duration_during_which_the_startup_idle_flare_adder_(DRIDHT)_is_added_to_the_base_target_idle_speed._Increasing_STTIME:_Extends_the_post-start_elevated_idle_period._Useful_for_cold-start_stability_in_freezing_climates_or_with_large_injectors_where_fuel_puddling_requires_extra_time_to_establish_a_steady_wall_film._Decreasing_STTIME:_Shortens_the_flare_period,_allowing_the_engine_to_return_to_normal_base_idle_faster.
    .byte 0x0B                       ;Point 1

	;.org	0xc370
AISPN_IdleSpeedParkNeutral_FromTemp:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0xC329
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname IdleSpeedParkNeutral_FromTemp
    ;mptblcname AISPN
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis RPM 0 2048 rpm
    ;mptbldesc AISPN_is_the_foundational_2D_calibration_curve_defining_the_target_engine_idle_speed_across_operating_coolant_temperatures_whenever_the_drivetrain_is_unloaded_(Park/Neutral_switch_closed,_or_clutch_switch_/_neutral_switch_grounded_on_manual_vehicles)._Setting_Target_Idle_RPM:_To_raise_your_hot_idle_speed_(e.g._for_a_lumpy_aftermarket_camshaft_or_higher_alternator_output),_adjust_the_hot_end_of_this_table_(right-side_coordinate).
    .byte 0x02                       ;Number of points in table
    .byte 0x83, 0xA6, 0xFF, 0x43     ;Point 1
    .byte 0xCC, 0x70                 ;Point 2

	;.org	0xc37b
AISCLD_IdleSpeedDrive_FromTemp:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0xC330
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname IdleSpeedDrive_FromTemp
    ;mptblcname AISCLD
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis RPM 0 2048 rpm
    ;mptbldesc AISCLD_defines_the_target_idle_speed_curve_across_engine_coolant_temperatures_when_an_automatic_transmission_is_engaged_in_gear_(Drive,_Reverse,_1st,_or_2nd)._Automatic_Trans_Conversions_/_Retuned_ATX:_If_running_an_automatic_calibration,_match_or_stagger_AISCLD_against_AISPN._If_shifting_into_Drive_causes_harsh_engagement_or_vehicle_lunging,_lower_AISCLD.
    .byte 0x02                       ;Number of points in table
    .byte 0x82, 0x93, 0xFF, 0x5D     ;Point 1
    .byte 0xCC, 0x64                 ;Point 2

	;.org	0xc386
CLDPOS_AisColdPosition_FromTemp:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0xC337
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisColdPosition_FromTemp
    ;mptblcname CLDPOS
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis AIS_Open 0 2048 steps
    ;mptbldesc CLDPOS_establishes_an_extra_off-idle_bypass_airflow_opening_based_on_engine_coolant_temperature._Cold_Stall_on_Decel_/_Clutch_In:_If_a_modified_engine_stalls_when_coming_to_a_stop_during_the_first_3-5_minutes_of_driving_before_full_warmup,_increase_the_values_in_CLDPOS_in_the_70_degF_-_140_degF_region.
    .byte 0x04                       ;Number of points in table
    .byte 0x6E, 0x78, 0xFC, 0x79     ;Point 1
    .byte 0x7F, 0x3C, 0xFF, 0x00     ;Point 2
    .byte 0xB6, 0x05, 0xFF, 0xD3     ;Point 3
    .byte 0xD2, 0x00                 ;Point 4

	;.org	0xc395
BARAIS_AISBaroCompensation:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0xC346
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BaroCompensation_FromBaro
    ;mptblcname BARAIS
    ;mpxaxis Baro -14.7 29.4 psi
    ;mpyaxis Factor 0 1 scale
    ;mptbldesc BARAIS_scales_the_cold_off-idle_AIS_step_position_(CLDPOS)_as_a_function_of_atmospheric_barometric_pressure_(BaroPressure)._Stock_Behavior:_Most_tuners_will_never_need_to_modify_BARAIS_unless_validating_high-altitude_vehicle_behavior._High_Altitude_Tuning:_If_vehicles_driven_at_high_elevation_suffer_from_cold-engine_dipping_on_decel,_elevate_the_low-baro_end_of_the_BARAIS_curve_to_command_more_open_steps.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x3F, 0x80, 0xF6, 0xDB     ;Point 1
    .byte 0x46, 0x40                 ;Point 2

	;.org	0xc3a0
THRPOS_AisPosition_FromThrottle:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0xC34D
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisPosition_FromThrottle
    ;mptblcname THRPOS
    ;mpxaxis TPS 0 5 Volts
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc THRPOS_acts_as_an_electronic_dashpot._It_maps_throttle_position_above_closed-throttle_idle_(TpsVolts_-_MINTHR_LowestSessionTPS)_directly_to_a_target_AIS_stepper_motor_step_opening._Throttle_Snap_Stalling:_If_dropping_the_throttle_quickly_causes_the_engine_to_dip_below_idle_speed_and_die,_increase_THRPOS_values,_particularly_in_the_lower_throttle_angle_range_(0%_to_15%_throttle).
    .byte 0x04                       ;Number of points in table
    .byte 0x0F, 0x00, 0x00, 0x4C     ;Point 1
    .byte 0x19, 0x03, 0x00, 0x0E     ;Point 2
    .byte 0x4F, 0x06, 0x00, 0x30     ;Point 3
    .byte 0x64, 0x0A                 ;Point 4

	;.org	0xc3af
RPMPOS_AisPosition_FromRpm:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0xC35C
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisPosition_FromRpm
    ;mptblcname RPMPOS
    ;mpxaxis RPM 0 16384 rpm
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc RPMPOS_establishes_a_minimum_AIS_stepper_motor_opening_based_purely_on_engine_RPM_(EngineRpm_HB)._Decel_Dip_/_Return-to-Idle_Catching:_If_pressing_the_clutch_at_4,000_RPM_causes_the_tachometer_needle_to_plummet_like_a_rock_and_dip_below_target_idle_(or_stall),_increase_the_upper_RPM_steps_in_RPMPOS._Engine_Braking:_Excessive_values_in_RPMPOS_diminish_engine_braking_effect_during_off-throttle_deceleration.
    .byte 0x03                       ;Number of points in table
    .byte 0x1F, 0x00, 0x00, 0x30     ;Point 1
    .byte 0x2F, 0x03, 0x00, 0x21     ;Point 2
    .byte 0x46, 0x06                 ;Point 3

	;.org	0xc3be
PNPOS_ParkNeutralPosition:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0xC367
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ParkNeutralPosition
    ;mptblcname PNPOS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc PNPOS_is_a_single-byte_calibration_constant_that_adds_a_fixed_step_offset_to_the_desired_AIS_motor_position_whenever_the_transmission_is_in_Park_or_Neutral._Stock_Value:_0x00._Tuning_Usage:_Generally_left_at_zero._If_custom_automatic_transmissions_exhibit_an_immediate_RPM_drop_upon_shifting_into_neutral_before_the_closed-loop_integrator_responds,_a_small_positive_value_(2_-_5_steps)_can_be_entered_here.
    .byte 0x00                       ;Point 1

	;.org	0xc3bf
ACPOS_ACPositionWhenTempToCold:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0xC368
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ACPositionWhenTempToCold
    ;mptblcname ACPOS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACPOS_provides_a_fixed_step_addition_for_the_idle_air_bypass_whenever_the_Air_Conditioning_compressor_clutch_is_engaged_and_engine_coolant_temperature_is_below_the_warm_threshold_defined_by_ACTMP_AisTempSwap._A/C_Cold_Stall:_If_turning_on_the_air_conditioning_or_windshield_defroster_while_the_engine_is_cold_causes_a_severe_RPM_dip_or_engine_stall,_increase_ACPOS_(e.g.,_from_23_steps_to_30-35_steps).
    .byte 0x14                       ;Point 1

	;.org	0xc3c0
ACTMP_AisTempSwap:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0xC369
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisTempSwap
    ;mptblcname ACTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc ACTMP_defines_the_coolant_temperature_crossover_point_separating_cold_A/C_compensation_from_warm_A/C_compensation._Stock_Value:_0xA6_(166_decimal,_corresponding_to_approximately_166_degF_/_74_degC)._Thermostat_Changes:_If_running_a_160_degF_low-temperature_racing_thermostat,_the_engine_may_operate_continuously_right_around_or_slightly_below_166_degF,_causing_the_ECU_to_remain_permanently_locked_into_the_cold_ACPOS_adder_mode.
    .byte 0x92                       ;Point 1

	;.org	0xc3c1
CALPOS_PositionAisMotorIsAtIdle:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0xC36A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PositionAisMotorIsAtIdle
    ;mptblcname CALPOS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CALPOS_represents_the_electrical_baseline_step_count_of_the_AIS_stepper_motor_during_steady-state,_fully_warmed-up_curb_idle._Base_Throttle_Minimum_Airflow_Setup:_The_factory_service_manual_instructs_setting_the_mechanical_throttle_plate_minimum_stop_screw_(with_AIS_motor_disconnected_or_fully_closed)_so_that_warm_idle_runs_~700_RPM._When_reconnecting_the_AIS,_the_ECU_operates_around_CALPOS_(~20_to_30_steps)_to_achieve_850_RPM_target_idle.
    .byte 0x1A                       ;Point 1

	;.org	0xc3c2
CALRAT_AisAdjustRate:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0xC36B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisAdjustRate
    ;mptblcname CALRAT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CALRAT_is_a_timing_bitmask_applied_against_the_ECU's_master_loop_counter_(Counter_MainLoop1)_that_governs_how_rapidly_the_AIS_stepper_motor_is_permitted_to_step_downward_(close)_when_returning_to_target_idle._Stepper_motors_have_mechanical_inertia_and_physical_response_times._Permissible_Values:_Must_be_power-of-two_minus_one_bitmasks_or_specific_bit_combinations_(0x01,_0x03,_0x07,_0x0E,_0x0F,_0x1F,_0x3F)._Stock_calibration_uses_0x0E.
    .byte 0x06                       ;Point 1

	;.org	0xc3c3
BRKRPM_BrakeOverrideForAis_FromDeltaThrottle:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0xC36C
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname BrakeOverrideForAis_FromDeltaThrottle
    ;mptblcname BRKRPM
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc BRKRPM_is_a_2D_calibration_lookup_table_that_defines_an_engine_RPM_threshold_indexed_by_throttle_opening_above_closed-throttle_baseline_(TpsVolts_-_MINTHR_LowestSessionTPS)._Hanging_Idle_Off-Throttle:_If_the_engine_hangs_at_elevated_RPM_after_light_throttle_blips_or_when_braking_into_a_corner,_lowering_BRKRPM_allows_the_ECU_to_resume_closed-loop_idle_control_sooner.
    .byte 0x03                       ;Number of points in table
    .byte 0x03, 0x17, 0x01, 0x25     ;Point 1
    .byte 0x0A, 0x1F, 0x00, 0x91     ;Point 2
    .byte 0x28, 0x30                 ;Point 3

	;.org	0xc3ce
FWDAIS_ForwardAisSteps_NoSlope:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0xC377
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ForwardAisSteps_NoSlope
    ;mptblcname FWDAIS
    ;mpxaxis DeltaRPM 0 2048 rpm
    ;mpyaxis AISSteps 0 255 step
    ;mptbldesc FWDAIS_is_a_stepped_lookup_table_(without_linear_interpolation)_that_dictates_how_many_forward_(opening)_steps_the_ECU_commands_the_AIS_stepper_motor_to_take_when_the_engine_is_running_slower_than_target_idle_speed._Stalling_Under_Sudden_Load:_If_turning_the_steering_wheel_to_full_lock_or_turning_on_headlights_causes_the_engine_to_dip_and_stall,_increase_the_step_values_in_FWDAIS_(especially_for_mid-to-high_RPM_error_brackets).
    .byte 0x04                       ;Number of points in table
    .byte 0x14, 0x01, 0x00, 0x00     ;Point 1
    .byte 0x28, 0x02, 0x00, 0x00     ;Point 2
    .byte 0x3C, 0x04, 0x00, 0x00     ;Point 3
    .byte 0x50, 0x06                 ;Point 4

	;.org	0xc3e5
REVAIS_ReverseAisSteps_NoSlope:
    ;mpgrp Idle\AIS_Control\
    ;mptbladdr 0xC386
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ReverseAisSteps_NoSlope
    ;mptblcname REVAIS
    ;mpxaxis DeltaRPM 0 2048 rpm
    ;mpyaxis AISSteps 0 255 step
    ;mptbldesc REVAIS_is_a_stepped_lookup_table_that_dictates_how_many_reverse_(closing)_steps_the_ECU_commands_the_AIS_stepper_motor_to_take_when_the_engine_is_idling_faster_than_target_idle_speed._Slow_Return_to_Idle:_If_the_engine_revs_and_takes_an_excessively_long_time_to_settle_back_down_to_idle_after_load_is_removed,_increase_the_reverse_steps_in_REVAIS.
    .byte 0x03                       ;Number of points in table
    .byte 0x14, 0xFF, 0x00, 0x00     ;Point 1
    .byte 0x28, 0xFE, 0x00, 0x00     ;Point 2
    .byte 0x50, 0xFC                 ;Point 3

	;.org	0xc3fc
TIMEDC_AISDecelBaseAirflowCurveOffset:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC391
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelAisBaseAirflowCurveOffset_FromTime
    ;mptblcname TIMEDC
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis Time 0 720 sec
    ;mptbldesc TIMEDC_provides_a_timed_deceleration_airflow_decay_curve_for_the_idle_air_bypass_system._Decel_Popping_/_Exhaust_Burble:_High_manifold_vacuum_during_trailing_throttle_often_causes_exhaust_popping_or_backfiring_with_open_3"_downpipes._Increasing_TIMEDC_provides_more_decel_bypass_airflow,_smoothing_manifold_vacuum_and_reducing_harsh_decel_exhaust_pops.
    .byte 0x02                       ;Number of points in table
    .byte 0x00, 0x05, 0xFF, 0x8C     ;Point 1
    .byte 0x0B, 0x00                 ;Point 2

	;.org	0xc403
TEMPDC_AISDecel_FromTemp:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC398
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelAis_FromTemp
    ;mptblcname TEMPDC
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc TEMPDC_defines_an_additive_deceleration_bypass_airflow_correction_indexed_by_engine_coolant_temperature_(CoolantTemp)._Cold-Engine_Decel_Stalling:_If_the_car_frequently_dies_when_you_push_the_clutch_in_while_decelerating_on_cold_mornings,_increase_TEMPDC_in_the_40_degF_-_120_degF_coolant_temperature_range._Cold_Fast-Decel_Hang:_If_the_engine_RPM_hangs_up_around_2,000_RPM_on_cold_lift-off_and_takes_too_long_to_drop,_reduce_TEMPDC.
    .byte 0x05                       ;Number of points in table
    .byte 0x58, 0x1D, 0xFF, 0x9F     ;Point 1
    .byte 0x8A, 0x0A, 0xFF, 0xE5     ;Point 2
    .byte 0xA6, 0x05, 0xFF, 0xE9     ;Point 3
    .byte 0xC7, 0x02, 0xFF, 0xE2     ;Point 4
    .byte 0xD8, 0x00                 ;Point 5

	;.org	0xc416
DAISOP_DecelAisOpenStepsFromNeg_FromDeltaMap:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC3AB
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname DecelAisOpenStepsFromNeg_FromDeltaMap
    ;mptblcname DAISOP
    ;mpxaxis DeltaMAP 0 44.1 psi
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc DAISOP_is_a_dynamic_anti-stall_table_that_responds_directly_to_the_rate_of_manifold_vacuum_increase_(negative_Delta_MAP)._Sudden_Lift_Stalling_(Blow-Off_/_Vent-to-Atmosphere_Valves):_Turbo_cars_that_stall_immediately_when_shifting_gears_or_snapping_the_throttle_shut_under_boost_often_suffer_from_sudden_vacuum_collapse._Increasing_DAISOP_commands_a_quicker,_larger_air_cushion_to_catch_the_RPM_drop.
    ;mpmapaxis x
    .byte 0x03                       ;Number of points in table
    .byte 0x01, 0x00, 0x00, 0xC0     ;Point 1
    .byte 0x09, 0x06, 0x01, 0x80     ;Point 2
    .byte 0x0B, 0x09                 ;Point 3

	;.org	0xc425
DAISCL_DecelAisOpenStepsFromPos_FromDeltaMap:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC3B6
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname DecelAisOpenStepsFromPos_FromDeltaMap
    ;mptblcname DAISCL
    ;mpxaxis DeltaMAP 0 44.1 psi
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc DAISCL_operates_as_the_companion_table_to_DAISOP._Hanging_Idle_After_Decel:_If_the_engine_catches_decel_successfully_but_then_sits_at_1,300_-_1,500_RPM_for_several_seconds_before_slowly_coming_down,_DAISCL_is_not_closing_the_valve_quickly_enough._Increase_the_closing_step_values_in_DAISCL._Secondary_Decel_Dip:_If_the_engine_catches,_revives,_and_then_immediately_dips_and_stalls_on_the_rebound,_DAISCL_is_closing_the_valve_too_aggressively.
    ;mpmapaxis x
    .byte 0x03                       ;Number of points in table
    .byte 0x01, 0x00, 0xFF, 0x00     ;Point 1
    .byte 0x06, 0xFB, 0xFF, 0x72     ;Point 2
    .byte 0x0F, 0xF6                 ;Point 3

	;.org	0xc434
MAPFLR_AISAdditionToControlMap_FromRpm:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC3C1
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AdditionToControlMap_FromRpm
    ;mptblcname MAPFLR
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis ScaledMAP 0 44.1 psi
    ;mptbldesc MAPFLR_defines_a_target_manifold_absolute_pressure_floor_as_a_function_of_engine_RPM_(EngineRpm_HB)._High_RPM_Decel_Backfire_/_Burble:_If_the_car_bangs_or_backfires_loudly_in_the_exhaust_when_letting_off_the_gas_at_high_RPM_(3,500_-_5,000_RPM),_raising_MAPFLR_forces_the_AIS_to_admit_more_bypass_air,_raising_manifold_pressure_and_preventing_extreme_vacuum_fuel_vaporization.
    ;mpmapaxis y
    .byte 0x03                       ;Number of points in table
    .byte 0x5E, 0x00, 0x00, 0x19     ;Point 1
    .byte 0x7D, 0x03, 0x00, 0x11     ;Point 2
    .byte 0x9C, 0x05                 ;Point 3

	;.org	0xc443
BARFLR_OffsetCorrectionTo_MAPFLR_FromBaro:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC3CC
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname OffsetCorrectionTo_MAPFLR_FromBaro
    ;mptblcname BARFLR
    ;mpxaxis Baro -14.7 29.4 psi
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc BARFLR_provides_ambient_barometric_pressure_compensation_to_the_deceleration_MAP_floor_(MAPFLR)._Standard_Calibrations:_Typically_calibrated_as_a_flat_multiplier_(0x80_=_128_/_1.0*_normalized)_or_slight_upward_taper_at_low_barometric_readings._High_Altitude_Tuning:_Only_adjust_if_high-altitude_field_testing_reveals_inconsistent_trailing-throttle_behavior_between_sea_level_and_mountainous_driving.
    ;mpmapaxis x
    .byte 0x01                       ;Number of points in table
    .byte 0xAA, 0x80                 ;Point 1

	;.org	0xc44a
MPTEMP_TempTermForMapOffset_FromTemp:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC3CF
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempTermForMapOffset_FromTemp
    ;mptblcname MPTEMP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 1 Factor
    ;mptbldesc MPTEMP_is_a_temperature-dependent_scaling_multiplier_applied_to_the_deceleration_MAP_floor_(MAPFLR)._Cold_Decel_Stumble_/_Shudder:_If_releasing_the_accelerator_while_the_engine_is_warming_up_causes_vehicle_bucking,_shudder,_or_severe_jerking,_increase_the_low-temperature_values_in_MPTEMP._Warm_Consistency:_Above_160_degF,_MPTEMP_plateaus_to_a_constant_nominal_multiplier_to_hand_steady-state_authority_over_to_MAPFLR.
    .byte 0x02                       ;Number of points in table
    .byte 0x90, 0x00, 0x04, 0x83     ;Point 1
    .byte 0xC7, 0xFF                 ;Point 2

	;.org	0xc451
DCLRFQ_TimeBetweenAisPulsesForDecelAis:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC3D6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBetweenAisPulsesForDecelAis
    ;mptblcname DCLRFQ
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 Sec
    ;mptbldesc DCLRFQ_establishes_the_pulse_frequency_/_damping_interval_between_consecutive_stepper_motor_movements_while_in_deceleration_control_mode._Stock_Value:_0x3F_(63_timer_ticks_/_~0.7_seconds)._Faster_Anti-Stall_Response:_Lowering_DCLRFQ_(e.g._to_0x20_or_0x18)_allows_the_ECU_to_step_the_AIS_motor_open_more_rapidly_during_rapid_deceleration,_which_is_beneficial_for_lightweight_flywheels_or_quick-revving_road_race_cars.
    .byte 0x3F                       ;Point 1

	;.org	0xc452
DATHOT_EngineTempToStartCalibratingDacal:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC3D7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineTempToStartCalibratingDacal
    ;mptblcname DATHOT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Deg
    ;mptbldesc DATHOT_defines_the_minimum_engine_coolant_temperature_required_to_activate_DACAL_adaptive_learning._180_degF_/_160_degF_Thermostats:_This_is_a_major_calibration_trap!_Factory_stock_DATHOT_is_set_to_0xCD_(~195_degF)._If_a_tuner_installs_a_180_degF_or_160_degF_thermostat,_engine_coolant_temperature_will_hover_around_175_degF_-_185_degF,_meaning_CoolantTemp_NEVER_exceeds_DATHOT!
    .byte 0xCD                       ;Point 1

	;.org	0xc453
DADRPM_DeltaRpmFromIdleSpeedForDacalUpdate:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC3D8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaRpmFromIdleSpeedForDacalUpdate
    ;mptblcname DADRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DADRPM_establishes_the_maximum_allowable_RPM_error_window_for_DACAL_adaptive_trim_learning._Lumpy_Aftermarket_Camshafts:_Aggressive_performance_camshafts_have_natural_cyclic_idle_speed_variation_(cam_lope)_that_easily_swings_+/-100_RPM_or_more._With_a_stock_DADRPM_of_64_RPM,_the_ECU_will_almost_never_allow_DACAL_to_update_because_the_idle_RPM_fluctuates_outside_the_narrow_window.
    .byte 0x02                       ;Point 1

	;.org	0xc454
DAACF_ACFactorDeltaFromBase:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC3D9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ACFactorDeltaFromBase
    ;mptblcname DAACF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DAACF_is_a_calibrated_step_adder_that_is_combined_with_the_deceleration_airflow_base_calculation_whenever_the_A/C_clutch_is_engaged._Decel_Stall_with_A/C_On:_If_the_engine_idles_fine_with_A/C_on,_but_stalls_every_time_you_push_the_clutch_in_or_brake_to_a_stop_with_the_A/C_running,_increase_DAACF_(e.g._from_9_steps_to_14-18_steps).
    .byte 0x09                       ;Point 1

	;.org	0xc455
DANOM_Base_nominalCal:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC3DA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Base_nominalCal
    ;mptblcname DANOM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DANOM_provides_the_foundational,_non-adaptive_baseline_offset_added_to_the_scaled_DACAL_countdown_timer_(Timer_DacalCountdown_/_4)_during_deceleration_airflow_processing._Base_Decel_Airflow_Cushion:_Raising_DANOM_increases_the_baseline_air_cushion_on_every_deceleration_event,_regardless_of_adaptive_memory_state._Useful_for_lightweight_flywheels_or_engines_with_aggressive_cams_that_need_a_guaranteed_minimum_air_floor.
    .byte 0x10                       ;Point 1

	;.org	0xc456
DCALTM_DacalInhibitTimeAfterStartup:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC3DB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DacalInhibitTimeAfterStartup
    ;mptblcname DCALTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DCALTM_specifies_a_lockout_time_delay_immediately_after_the_engine_starts_during_which_DACAL_(Decel_Adaptive_Calibration)_is_forbidden_from_modifying_adaptive_idle_airflow_memories._Stock_Value:_0x15_(~2.3_seconds)._Tuner_Adjustments:_Rarely_needs_alteration._If_an_engine_has_extreme_cold-start_flare_or_prolonged_cranking_recovery,_increasing_DCALTM_to_0x30_(~5_seconds)_ensures_the_engine_has_settled_completely_before_idle_learning_activates.
    .byte 0x15                       ;Point 1

	;.org	0xc457
DCALRT_DacalUpdateRate01_03_07_0f_1f_3f_7f_ff:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC3DC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DacalUpdateRate01_03_07_0f_1f_3f_7f_ff
    ;mptblcname DCALRT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DCALRT_is_a_timing_filter_bitmask_applied_against_Counter_MainLoop1_that_controls_how_frequently_the_DACAL_adaptive_countdown_timer_can_increment_or_decrement._Valid_Bitmask_Patterns:_Permissible_values_correspond_to_power-of-two_bit_patterns_(0x01,_0x03,_0x07,_0x0F,_0x1F,_0x3F,_0x7E,_0x7F,_0xFF)._Faster_Learning:_Decreasing_bitmask_density_causes_the_adaptive_decel_timer_to_adapt_more_rapidly_to_mechanical_throttle_stop_changes.
    .byte 0x7E                       ;Point 1

	;.org	0xc458
DDRPM2_AisDeltaRpmFromIdle2:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC3DD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisDeltaRpmFromIdle2
    ;mptblcname DDRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc DDRPM2_defines_an_RPM_error_threshold_evaluated_during_the_secondary_deceleration_control_phase_inside_CalculateAisPosition_MM._Stock_Value:_0x00._Tuner_Recommendations:_Leave_at_0x00_unless_customizing_custom_decel_handover_behavior._Setting_higher_forces_an_earlier_handoff_from_decel_dashpot_mode_into_closed-loop_idle_regulation.
    .byte 0x01                       ;Point 1

	;.org	0xc459
DATHT2_EngineTempToStartCalibratingDacal2:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC3DE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineTempToStartCalibratingDacal2
    ;mptblcname DATHT2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Deg
    ;mptbldesc DATHT2_establishes_the_temperature_threshold_for_the_secondary_decel_control_branch_in_CalculateAisPosition_MM._Low-Temp_Thermostats:_If_running_a_160_degF_or_180_degF_thermostat,_match_DATHT2_to_DATHOT_(e.g._set_to_0xB5_for_180_degF_thermostats)_so_the_thermal_branches_switch_synchronously.
    .byte 0xD2                       ;Point 1

	;.org	0xc45a
DCLMIN_MinLimitOnDecelAisControlledMap:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC3DF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinLimitOnDecelAisControlledMap
    ;mptblcname DCLMIN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DCLMIN_provides_a_hard_minimum_lower_clamp_for_the_calculated_deceleration_target_MAP_floor._Stock_Value:_0x14_(~15_kPa)._Extreme_High-Vacuum_Engines:_Highly_efficient_tight-tolerance_race_engines_with_high_static_compression_can_pull_massive_vacuum_on_decel._Raising_DCLMIN_slightly_(e.g._to_0x1C_=_~21_kPa)_provides_an_earlier_air_cushion_on_trailing_throttle_to_catch_aggressive_decel_drops.
    .byte 0x16                       ;Point 1

	;.org	0xc45b
DLYTIM_AisDelayAfterThrottleClosesWhenMoving:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC3E0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisDelayAfterThrottleClosesWhenMoving
    ;mptblcname DLYTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc DLYTIM_defines_a_settling_time_delay_loaded_into_Timer_CountdownFromStartRunForAisFeedback_whenever_the_throttle_snaps_shut_while_the_vehicle_is_in_motion_(_>_MPHREF_,_approx_6_MPH)._Driveline_Jerk_on_Decel:_If_letting_off_the_gas_while_cruising_causes_an_immediate_jerk_or_'thud'_as_the_engine_braking_kicks_in,_increasing_DLYTIM_extends_the_smooth_dashpot_transition.
    .byte 0x17                       ;Point 1

	;.org	0xc45c
DLYTM2_AisDelayAfterThrottleClosesWhenStopped:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC3E1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisDelayAfterThrottleClosesWhenStopped
    ;mptblcname DLYTIM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc DLYTIM2_defines_the_settling_time_delay_loaded_into_Timer_CountdownFromStartRunForAisFeedback_when_the_throttle_is_snapped_shut_while_the_vehicle_is_stationary_(_<_MPHREF_,_<_6_MPH)._Rev-Blip_Stalling_When_Stopped:_If_revving_the_engine_in_neutral_causes_the_tachometer_needle_to_drop_below_700_RPM_or_stall_when_the_throttle_snaps_shut,_increase_DLYTIM2.
    .byte 0x0C                       ;Point 1

	;.org	0xc45d
DRPNK_DriveToParkNeutralKicks_FromTemp:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC3E2
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DriveToParkNeutralKicks_FromTemp
    ;mptblcname DRPNK
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc DRPNK_defines_a_temporary_stepper_motor_position_kick_applied_when_an_automatic_transmission_is_shifted_out_of_gear_into_Park_or_Neutral._When_shifting_out_of_Drive,_torque_converter_drag_instantly_vanishes._Stock_Value:_Single-point_table_set_to_0x00._Automatic_Conversions:_On_automatic_vehicles_with_high-stall_torque_converters,_shifting_into_neutral_can_cause_RPM_flare;_leave_at_0x00._On_manual_transmission_cars,_this_routine_is_inactive.
    .byte 0x03                       ;Number of points in table
    .byte 0x79, 0xF6, 0x00, 0x14     ;Point 1
    .byte 0x92, 0xF8, 0x00, 0x18     ;Point 2
    .byte 0xD2, 0xFE                 ;Point 3

	;.org	0xc468
PNDRK_ParkNeutralToDriveKicks_FromTemp:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC3ED
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ParkNeutralToDriveKicks_FromTemp
    ;mptblcname PNDRK
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc PNDRK_provides_a_pre-emptive_stepper_motor_opening_kick_when_an_automatic_transmission_is_shifted_from_Park_or_Neutral_into_Drive_or_Reverse._Shifter_Engagement_Stall_(Automatic_Trans):_If_shifting_an_automatic_car_from_Park_into_Drive_or_Reverse_causes_the_engine_to_stall_or_shudder_violently,_populate_PNDRK_with_4_to_8_steps_in_the_cold_and_warm_operating_zones._Manual_Transmissions:_Inoperative_on_manual_transmission_calibrations.
    .byte 0x03                       ;Number of points in table
    .byte 0x6E, 0x28, 0xFF, 0xA4     ;Point 1
    .byte 0x92, 0x1B, 0xFF, 0xA4     ;Point 2
    .byte 0xD2, 0x04                 ;Point 3

	;.org	0xc473
PNDLTN_DeltaRpmChangeToUse_DRPNK_or_PNDRK:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC3F8
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DeltaRpmChangeToUse_DRPNK_or_PNDRK_A
    ;mptblcname PNDLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc PNDLT_is_a_16-bit_threshold_defining_the_minimum_RPM_deviation_that_must_occur_during_a_transmission_gear_selector_shift_before_the_ECU_will_execute_the_DRPNK_or_PNDRK_step_kick_tables._Stock_Value:_0x00C8_(200_RPM)._Tight_Torque_Converters:_If_an_aftermarket_torque_converter_has_high_stall_or_very_tight_lockup_that_creates_a_sudden_150_RPM_dip_that_fails_to_trigger_PNDRK,_lower_PNDLT_to_0x0064_(100_RPM)_so_the_kick_triggers_reliably.
    .word 0x003C                     ;Point 1

	;.org	0xc475
ACCTBL_ACOffIdleDelta_FromSpeed:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC3FA
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ACOffIdleDelta_FromSpeed
    ;mptblcname ACCTBL
    ;mpxaxis Speed 0 128 mph
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc ACCTBL_defines_the_dynamic_AIS_step_addition_applied_when_the_Air_Conditioning_compressor_clutch_is_engaged_and_the_engine_is_fully_warmed_up_(CoolantTemp_>=_ACTMP_AisTempSwap)._At_cruising_speeds,_the_A/C_compressor_operates_at_high_RPM,_demanding_significant_horsepower._A/C_Decel_Stumble_at_Speed:_If_letting_off_the_gas_while_driving_at_45_MPH_with_the_A/C_on_causes_the_car_to_buck_or_hesitate,_increase_the_mid-speed_points_in_ACCTBL.
    .byte 0x04                       ;Number of points in table
    .byte 0x32, 0x18, 0x00, 0x6F     ;Point 1
    .byte 0x50, 0x25, 0x01, 0xD5     ;Point 2
    .byte 0x6E, 0x5C, 0x00, 0x80     ;Point 3
    .byte 0x78, 0x61                 ;Point 4

	;.org	0xc484
OFFPER2_AisInstantlyClosesWhenAcDisengages2:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC409
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisInstantlyClosesWhenAcDisengages2
    ;mptblcname OFFPER2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OFFPER2_specifies_the_exact_fraction_of_the_active_A/C_step_addition_(ACCTBL)_that_is_instantly_subtracted_from_DesiredNewAisPosition_the_moment_the_A/C_compressor_clutch_disengages_while_moving._Engine_Flare_When_A/C_Cycles_Off:_If_you_feel_the_car_accelerate_or_hear_the_engine_flare_up_when_the_A/C_compressor_clutch_clicks_off_during_cruising,_increase_OFFPER2_(up_to_0xFF_=_100%_immediate_retraction).
    .byte 0x40                       ;Point 1

	;.org	0xc485
IAISOP_IdleAISOpenStepsNegative:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC40A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname IdleAISOpenStepsNegative
    ;mptblcname IAISOP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc IAISOP_provides_an_instant_negative_step_adjustment_to_the_Automatic_Idle_Speed_(AIS)_motor_when_the_A/C_compressor_clutch_disengages_while_the_engine_is_at_curb_idle_(closed_throttle)._Idle_Flare_on_A/C_Cycling:_If_engine_RPM_flares_upward_noticeably_every_time_the_A/C_compressor_cycles_off_at_a_traffic_light,_increase_the_magnitude_of_IAISOP_(e.g._from_-8_steps_to_-12_or_-14_steps).
    .byte 0xF4                       ;Point 1

	;.org	0xc486
ACOFFK_ClosedThrottleAcOffKick:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC40B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ClosedThrottleAcOffKick
    ;mptblcname ACOFFK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACOFFK_is_a_calibration_parameter_used_during_the_secondary_stage_of_A/C_compressor_disengagement_at_closed_throttle._Rebound_Stall_After_A/C_Cycling:_If_the_engine_revives_from_an_A/C_disengagement_flare_only_to_dip_and_stall_1-2_seconds_later,_increase_ACOFFK_to_provide_a_firmer_transitional_floor.
    .byte 0x10                       ;Point 1

	;.org	0xc487
AC2KCK_AcClutchKickOpenAfterAcEnabled:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC40C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcClutchKickOpenAfterAcEnabled
    ;mptblcname AC2KCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AC2KCK_delivers_an_immediate,_pre-emptive_opening_kick_(stock_calibration_=_7_steps)_to_the_AIS_stepper_motor_the_instant_the_ECU_detects_an_A/C_request_or_commands_the_clutch_relay_to_energize._A/C_Engagement_Shudder_/_Stumble:_If_turning_on_the_A/C_causes_an_immediate_100-200_RPM_dip_or_vibration_before_the_engine_recovers,_increase_AC2KCK_(e.g._from_7_steps_to_12-16_steps).
    .byte 0x04                       ;Point 1

	;.org	0xc488
ACTIME_TimeBeforeAcEnabledAndFullDeltaUsed:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC40D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBeforeAcEnabledAndFullDeltaUsed
    ;mptblcname ACTIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACTIME_sets_the_settling_countdown_duration_(stock_calibration_=_22_ticks_/_~1.5_seconds)_loaded_into_Timer_AisOrO2Sensor_whenever_the_A/C_clutch_engages._Stock_Setting:_0x16_(~1.5_seconds)._Heavy-Duty_Compressors:_If_running_an_upgraded_high-displacement_compressor_(or_high_ambient_desert_temperatures_where_head_pressures_take_longer_to_stabilize),_increasing_ACTIME_gives_the_engine_extra_cushioned_time_to_absorb_the_compressor_load.
    .byte 0x16                       ;Point 1

	;.org	0xc489
OFFPER_AisInstantlyClosesWhenAcDisengages:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC40E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisInstantlyClosesWhenAcDisengages
    ;mptblcname OFFPER
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OFFPER_defines_a_fractional_scalar_(stock_calibration_=_0x80_=_128/256_=_50%)_multiplied_against_the_speed-dependent_A/C_table_ACCTBL_when_calculating_running_AIS_position_with_the_A/C_clutch_disengaging_during_warm_operation._Tuning_Decel_Feel:_Setting_to_0x80_gives_a_50%_airflow_reduction_upon_clutch_disengagement._Setting_to_0x40_leaves_25%_airflow;_setting_to_0xC0_leaves_75%_airflow.
    .byte 0x80                       ;Point 1

	;.org	0xc48a
BTVAIS_MinVoltageForAis:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC40F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinVoltageForAis
    ;mptblcname BTVAIS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc BTVAIS_is_a_critical_electrical_protection_threshold_that_guards_the_AIS_stepper_motor_and_ECU_hardware_against_low_system_voltage._The_Chrysler_AIS_unit_is_a_4-wire_bipolar_stepper_motor_that_draws_substantial_coil_current_through_the_ECU's_internal_quad-driver_circuitry._Stock_Value:_0x71_(113_decimal_=_approximately_10.5_Volts)._Low-Voltage_Tuning_/_Relocated_Batteries:_Do_not_lower_BTVAIS_below_10.0V.
    .byte 0x71                       ;Point 1

L2529:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC410
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname L2529
    ;mptblcname L2529
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc L2529_is_an_unreferenced_or_legacy_Chrysler_engineering_constant_residing_in_the_calibration_ROM_at_address_$0C9B_(ROM_address_$C48B)._Stock_Value:_0x0D._Tuning_Usage:_Retain_stock_value_(0x0D)._Do_not_modify_unless_developing_custom_assembly_patches_that_repurpose_these_ROM_locations.
    .byte 0x0D                       ;Point 1
L3529:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC411
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname L3529
    ;mptblcname L3529
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc L3529_is_a_preserved_Chrysler_engineering_calibration_constant_residing_at_address_$0CA6_(ROM_address_$C48C)._Like_its_predecessor_L2529,_this_constant_is_part_of_the_decel_idle_parameter_cluster_maintained_across_Chrysler_2.2L/2.5L_Turbo_calibrations_to_maintain_exact_binary_alignment_across_SMEC_and_Logic_Module_firmware_versions._Stock_Value:_0x0D._Tuning_Usage:_Leave_at_stock_factory_value.
    .byte 0x0D                       ;Point 1
L4529:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC412
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname L4529
    ;mptblcname L4529
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc L4529_is_a_preserved_Chrysler_engineering_calibration_constant_residing_at_address_$0CB1_(ROM_address_$C48D),_immediately_preceding_DCLRF2_TimeBetweenAisPulsesForDecelAis2._Maintained_to_ensure_100%_byte-for-byte_binary_fidelity_with_the_stock_factory_A171_calibration_layout._Stock_Value:_0xAC._Tuning_Usage:_Leave_untouched_at_stock_value.
    .byte 0xAC                       ;Point 1

	;.org	0xc48e
DCLRF2_TimeBetweenAisPulsesForDecelAis2:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC413
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBetweenAisPulsesForDecelAis2
    ;mptblcname DCLRF2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 Sec
    ;mptbldesc DCLRF2_establishes_the_settling_time_interval_between_successive_stepper_motor_corrections_while_operating_in_closed-loop_idle_speed_control._Idle_Hunting_/_Cyclic_Surging:_If_the_engine_surges_up_and_down_rhythmically_at_idle_(750_RPM_->_1,100_RPM_->_750_RPM_every_1-2_seconds),_the_idle_control_loop_is_reacting_too_fast._Increasing_DCLRF2_dampens_the_closed-loop_response.
    .byte 0x3F                       ;Point 1

	;.org	0xc48f
AISHLM_AisHighLimitMaxOpenSteps:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC414
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisHighLimitMaxOpenSteps
    ;mptblcname AISHLM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AISHLM_enforces_an_absolute_mechanical_protection_ceiling_on_the_AIS_stepper_motor_position._Safety_Critical:_NEVER_increase_AISHLM_above_225_steps._Exceeding_mechanical_travel_will_jam_the_stepper_motor_pintle,_requiring_throttle_body_disassembly_or_motor_replacement._Aftermarket_Throttle_Bodies:_Some_aftermarket_throttle_bodies_have_shallower_bypass_cavities.
    .byte 0xDC                       ;Point 1

	;.org	0xc490
DEFAIS_DefaultAISStartPosition:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC415
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DefaultAISStartPosition
    ;mptblcname DEFAIS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc DEFAIS_establishes_the_default_fallback_step_position_for_the_idle_stepper_motor_when_startup_conditions_or_initialization_flags_dictate_a_safe_baseline_bypass_opening._Stock_Value:_0x0C_(12_steps)._Modified_Engines:_If_an_engine_with_a_large_camshaft_or_tight_converter_struggles_to_catch_during_early_key-on_initialization_before_the_temperature_table_takes_over,_DEFAIS_can_be_bumped_to_18-24_steps.
    .byte 0x0C                       ;Point 1

	;.org	0xc491
MPHREF_SwitchPointForDecelIdleAisControl:
    ;mpgrp Idle\AIS_Decel\
    ;mptbladdr 0xC416
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SwitchPointForDecelIdleAisControl
    ;mptblcname MPHREF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 128 mph
    ;mptbldesc MPHREF_is_the_critical_speed_threshold_(stock_calibration_=_6_MPH_/_0x06)_defining_the_operational_boundary_between_stationary_curb_idle_regulation_and_moving_deceleration_control._Rolling_Idle_Surge_/_Stall:_If_pushing_the_clutch_in_while_rolling_up_to_a_red_light_at_10-15_MPH_causes_the_engine_to_dip_and_stall,_or_conversely_if_the_engine_hangs_at_1,500_RPM_until_the_vehicle_comes_to_a_dead_stop,_MPHREF_defines_the_boundary.
    .byte 0x04                       ;Point 1

	;.org	0xc492
WSGRPM_AllowedBoost_FromRpm:
    ;mpgrp Boost_Control\Target_Lookup\
    ;mptbladdr 0xC417
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromRpm
    ;mptblcname WSGRPM
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc WSGRPM_defines_the_baseline_target_boost_pressure_curve_as_a_function_of_engine_RPM._Target_vs._Actual_Boost:_WSGRPM_sets_the_target_goal_(in_psi_above_baro)._The_wastegate_duty_cycle_algorithm_(DCWOT)_modulates_the_wastegate_solenoid_to_bring_manifold_absolute_pressure_up_to_match_this_target_plus_barometric_pressure._Raising_WSGRPM:_Increases_targeted_boost_pressure.
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x47, 0x45, 0x00, 0x00     ;Point 1
    .byte 0xB2, 0x45                 ;Point 2

	;.org	0xc4a1
WSGTIM_AllowedBoost_FromTime:
    ;mpgrp Boost_Control\Target_Lookup\
    ;mptbladdr 0xC41E
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromTime
    ;mptblcname WSGTIM
    ;mpxaxis Time 0 0.72 Sec
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc WSGTIM_limits_target_boost_pressure_as_a_function_of_sustained_time_in_boost._Stock_Setting:_Flat_12.1_psi_(0x69)._In_the_A171_manual_calibration,_Chrysler_chose_not_to_taper_boost_over_time,_keeping_the_limit_flat._Tuning_Guidance:_If_you_raise_WSGRPM_for_higher_boost_(e.g._18_psi),_you_must_also_raise_WSGTIM_to_at_least_18_psi.
    ;mpmapaxis y
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0xFF                 ;Point 1

	;.org	0xc4ac
WSGCLT_AllowedBoost_FromTemp:
    ;mpgrp Boost_Control\Target_Lookup\
    ;mptbladdr 0xC421
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromTemp
    ;mptblcname WSGCLT
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc WSGCLT_is_the_engine_thermal_protection_boost_ceiling_curve_based_on_coolant_temperature._Cold_Engine_Protection:_Prevents_drivers_from_beating_on_a_cold_engine_before_the_oil_and_coolant_have_reached_operating_temperatures._Overheating_Protection:_Acts_as_an_automatic_failsafe_if_a_radiator_hose_bursts_or_the_thermostat_sticks,_dropping_the_car_to_mechanical_wastegate_boost_to_save_the_engine.
    ;mpmapaxis y
    .byte 0x04                       ;Number of points in table
    .byte 0x7F, 0x20, 0x02, 0x16     ;Point 1
    .byte 0xAD, 0x80, 0x00, 0x00     ;Point 2
    .byte 0xE9, 0x80, 0xF7, 0x46     ;Point 3
    .byte 0xF4, 0x20                 ;Point 4

	;.org	0xc4bb
WSGCHG_AllowedBoost_FromChargeTemp:
    ;mpgrp Boost_Control\Target_Lookup\
    ;mptbladdr 0xC430
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromChargeTemp
    ;mptblcname WSGCHG
    ;mpxaxis charge_temp_volts 0 5 volts
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc WSGCHG_provides_intake_air_charge_temperature_boost_limiting._Compressed_turbo_air_heats_up_dramatically._Intercooler_Health:_If_your_car_pulls_hard_on_the_first_run_down_the_drag_strip_but_falls_flat_on_subsequent_runs,_check_charge_temperatures._An_undersized_intercooler_heat-soaks_quickly,_triggering_WSGCHG_boost_reduction._High_Boost_Tuning:_Remember_to_raise_WSGCHG_at_normal_operating_voltages_(above_0.3V)_when_increasing_boost_targets.
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x0A, 0x2C, 0x04, 0x33     ;Point 1
    .byte 0x1E, 0x80                 ;Point 2

	;.org	0xc4c6
WSGKNK_BoostTimeSinceLastKnock:
    ;mpgrp Boost_Control\Target_Lookup\
    ;mptbladdr 0xC437
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BoostTimeSinceLastKnock
    ;mptblcname WSGKNK
    ;mpxaxis time 0 2.8 sec
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc WSGKNK_defines_the_knock-triggered_boost_reduction_penalty_curve._Stock_Setting:_Subtracts_2.1_psi_boost_immediately_upon_knock,_decaying_to_0_psi_over_~2.8_seconds._Safety_Failsafe:_Protects_the_engine_from_repeating_high-load_detonation_cycles._Tuning_Note:_Do_not_zero_out_WSGKNK_on_street_engines_running_pump_gas._If_knock_occurs,_lowering_boost_is_your_best_defense_against_broken_ring_lands_and_melted_pistons.
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x02, 0x0C, 0xFD, 0x00     ;Point 1
    .byte 0x06, 0x00                 ;Point 2

	;.org	0xc4d1
MXSBST_AllowedBoost_FromSpeed:
    ;mpgrp Boost_Control\Target_Lookup\
    ;mptbladdr 0xC43E
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoostForAutomatics_FromSpeed
    ;mptblcname MXSBST
    ;mpxaxis Speed 0 128 mph
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc MXSBST_implements_vehicle_speed-dependent_boost_limiting_(gear-based_/_traction_boost_limiting)._1st_Gear_Launch_Traction:_Excellent_tool_for_dialing_in_launch_traction_on_high-horsepower_street_cars._Manual_vs._Automatic:_On_manual_transmission_calibrations,_if_the_Park/Neutral_switch_or_speed_flag_is_grounded,_this_limiter_may_be_bypassed.
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x0B, 0x80, 0x00, 0x00     ;Point 1
    .byte 0x1A, 0x80                 ;Point 2

	;.org	0xc4d8
WSGPRT_AllowedBoostPartThrottle_FromThrottle:
    ;mpgrp Boost_Control\Target_Lookup\
    ;mptbladdr 0xC445
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AllowedBoostPartThrottle_FromThrottle
    ;mptblcname WSGPRT
    ;mpxaxis in 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc WSGPRT_establishes_the_maximum_target_boost_ceiling_permitted_when_the_engine_is_operating_at_part_throttle._Stock_Value:_0x3F_(_7.2_psig_)._Part_Throttle_Drivability:_Keeps_the_car_smooth_and_controllable_when_passing_without_needing_to_downshift_or_floor_the_pedal._Tuning_Guidance:_If_you_want_more_responsive_passing_power_at_60-75%_throttle_without_flooring_it,_raise_WSGPRT_to_9-10_psi.
    ;mpmapaxis y
    .byte 0x45                       ;Point 1

	;.org	0xc4d9
RESFAC_BoostMapCorrectionResponseFactor:
    ;mpgrp Boost_Control\Target_Lookup\
    ;mptbladdr 0xC446
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BoostMapCorrectionResponseFactor
    ;mptblcname RESFAC
    ;mpxaxis DeltaBoost -14.7 29.4 psi
    ;mpyaxis Factor 0 1 factor
    ;mptbldesc RESFAC_defines_the_proportional_closed-loop_response_gain_for_wastegate_duty_cycle_correction._Boost_Stability_vs._Hunting:_Higher_values_speed_up_wastegate_correction,_reducing_initial_boost_spike/overshoot._If_set_too_high,_the_wastegate_solenoid_will_oscillate,_causing_audible_flutter_and_boost_surge.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x61, 0x06, 0xFF, 0x74     ;Point 1
    .byte 0x6C, 0x00                 ;Point 2

	;.org	0xc4e8
RATLIM_BoostOverboostPrevention:
    ;mpgrp Boost_Control\Target_Lookup\
    ;mptbladdr 0xC44D
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BoostOverboostPrevention
    ;mptblcname RATLIM
    ;mpxaxis RPM 0 16384 rpm
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc RATLIM_establishes_an_RPM-dependent_rate-of-rise_boost_buffer_used_to_prevent_sudden_boost_spikes_and_overboost_shutoff_triggers._During_rapid_turbo_spool-up_in_low_gears,_boost_can_spike_past_the_target_before_the_wastegate_actuator_can_physically_move._Spike_Control:_Prevents_irritating_"hitting_the_windshield"_overboost_fuel_cuts_during_fast_2nd_gear_spool.
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x10, 0x08, 0xFF, 0xEF     ;Point 1
    .byte 0x4E, 0x04                 ;Point 2

	;.org	0xc4f3
DCWOT_FullThrottleWastegateDutyCycle_C8is100Percent_FromMap:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC454
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FullThrottleWastegateDutyCycle_C8is100Percent_FromMap
    ;mptblcname DCWOT
    ;mpxaxis TargetBoost 0 44.1 psi
    ;mpyaxis Duty_Cycle 0 128 percent
    ;mptbldesc DCWOT_is_the_primary_feed-forward_(open-loop_baseline)_wastegate_duty_cycle_curve_used_by_the_Chrysler_boost_control_system._Scaling_Mechanics:_Duty_cycle_is_scaled_from_0_to_200_counts_(0x00_=_0%,_0xC8_=_100%,_1_count_=_0.5%)._Tuning_for_Higher_Boost:_When_raising_boost_targets_in_WSGRPM,_you_must_ensure_DCWOT_provides_sufficient_duty_cycle_to_hold_that_boost.
    ;mpmapaxis x
    .byte 0x05                       ;Number of points in table
    .byte 0x20, 0xC8, 0xF5, 0x39     ;Point 1
    .byte 0x29, 0x67, 0xFD, 0xC0     ;Point 2
    .byte 0x35, 0x4C, 0xFE, 0x55     ;Point 3
    .byte 0x3B, 0x42, 0xFE, 0xBB     ;Point 4
    .byte 0x6B, 0x05                 ;Point 5

	;.org	0xc506
DCWADJ_FullThrottleWastegateDutyCycleAdjustment_FromRpm:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC467
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname FullThrottleWastegateDutyCycleAdjustment_FromRpm
    ;mptblcname DCWADJ
    ;mpxaxis RPM 0 16384 rpm
    ;mpyaxis DC_Adjust -64 64 percent
    ;mptbldesc DCWADJ_provides_an_RPM-dependent_duty_cycle_correction_adder_applied_to_the_base_wastegate_duty_cycle_(DCWOT)._Preventing_High-RPM_Boost_Drop:_Small_stock_turbos_(Garrett_T03_/_Mitsubishi_TE04H)_frequently_drop_boost_by_2-4_psi_above_5000_RPM_because_exhaust_backpressure_overcomes_the_weak_wastegate_canister_spring._Adding_positive_duty_cycle_in_DCWADJ_at_4800-6000_RPM_compensates_for_this_backpressure_bleed_and_holds_flat_boost_to_redline.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0xc51d
MAPOFS_BoostMapOffsetForDCWOT:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC46A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BoostMapOffsetForDCWOT
    ;mptblcname MAPOFS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc MAPOFS_establishes_the_manifold_pressure_threshold_below_target_boost_where_wastegate_solenoid_closed-loop_modulation_begins._Stock_Value:_0x17_(_~_2.65_psi_)._Faster_Spool:_Keeping_MAPOFS_around_2-3_psi_ensures_the_wastegate_stays_clamped_shut_right_up_until_the_turbo_is_within_striking_distance_of_the_boost_target.
    .byte 0x17                       ;Point 1

	;.org	0xc51e
KNOKMP_BoostKNKCNTinc:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC46B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BoostKNKCNTinc
    ;mptblcname KNOKMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc KNOKMP_sets_the_boost_error_threshold_above_barometric_pressure_required_to_increment_the_boost_knock_counter_(KNKCNT)._Knock_occurring_under_deep_vacuum_or_cruise_is_handled_strictly_with_spark_retard._Stock_Value:_0x23_(_~_4.0_psi_boost_)._Tuning_Guidance:_Preserves_knock-triggered_boost_dump_protection_under_load.
    .byte 0x23                       ;Point 1

	;.org	0xc51f
KNKMAX_BoostMaxKNKBeforeReset:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC46C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BoostMaxKNKBeforeReset
    ;mptblcname KNKMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc KNKMAX_defines_the_maximum_knock_count_ceiling_allowed_under_boost_before_wastegate_duty_cycle_dumping_is_triggered_and_the_counter_resets._Stock_Value:_0x10_(16_counts)._Tuning_Guidance:_Low_values_dump_boost_aggressively_on_minor_detonation;_high_values_tolerate_brief_knock_ticks._Leave_near_stock.
    .byte 0x10                       ;Point 1

	;.org	0xc520
RPMBST_MinimumRpmToTrackBoostCreep:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC46D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumRpmToTrackBoostCreep
    ;mptblcname RPMBST
    ;mpxaxis X 0 255 in
    ;mpyaxis RPM 0 16384 rpm
    ;mptbldesc RPMBST_defines_the_minimum_engine_speed_required_before_the_ECU_begins_tracking_boost_error_and_boost_creep._At_very_low_engine_speeds_(under_1216_RPM),_turbo_boost_is_non-existent,_and_exhaust_pulses_are_widely_spaced._Tracking_boost_error_at_low_RPM_would_generate_false_error_signals._RPMBST_locks_boost_error_integration_out_below_1216_RPM._Stock_Value:_0x26_(_1216_RPM_)._Tuning_Guidance:_Leave_at_stock_setting.
    .byte 0x26                       ;Point 1

	;.org	0xc521
PRTMAX_MaxDCForPartThrottleInc:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC46E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxDCForPartThrottleInc
    ;mptblcname PRTMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc PRTMAX_establishes_the_maximum_permissible_wastegate_duty_cycle_ceiling_allowed_during_part-throttle_boost_control._Prevents_the_closed-loop_duty_cycle_accumulator_from_winding_up_beyond_100%_duty_cycle_(0xC8)_when_modulating_boost_at_part_throttle._Stock_Value:_0xC8_(100%)._Taming_Sensitive_Throttles:_Lowering_PRTMAX_(e.g._to_70%_/_0x8C)_caps_part-throttle_boost_aggressiveness_if_the_car_feels_too_twitchy_in_traffic.
    .byte 0xC8                       ;Point 1

	;.org	0xc522
MPDEL_HysteresisForBoostIncreasingCondition:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC46F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HysteresisForBoostIncreasingCondition
    ;mptblcname MPDEL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc MPDEL_provides_hysteresis_deadband_offset_for_rising_manifold_pressure_evaluation._Distinguishes_between_rising_boost_(accelerating_turbo)_and_falling_boost_(decelerating_turbo)_to_stabilize_closed-loop_wastegate_tracking._Stock_Value:_0x00._Leave_at_factory_setting.
    .byte 0x00                       ;Point 1

	;.org	0xc523
UPRLIM_UpperLimitOnMPCORR:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC470
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UpperLimitOnMPCORR
    ;mptblcname UPRLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc UPRLIM_specifies_the_maximum_positive_closed-loop_duty_cycle_correction_authority_clamp_(MPCORR)._Limits_how_much_additional_duty_cycle_the_closed-loop_feedback_loop_is_allowed_to_add_on_top_of_the_base_table,_preventing_integral_windup_and_massive_boost_spikes_if_a_vacuum_line_leaks_or_tears._Stock_Value:_0x10_(16_counts_=_8%_max_duty_cycle_addition)._Tuning_Guidance:_Keeps_the_closed-loop_controller_within_safe_operating_boundaries.
    .byte 0x10                       ;Point 1

	;.org	0xc524
LWRLIM_LowerLimitOnMPCORR:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC471
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowerLimitOnMPCORR
    ;mptblcname LWRLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc LWRLIM_specifies_the_maximum_negative_closed-loop_duty_cycle_reduction_authority_clamp_(MPCORR)._Establishes_how_much_duty_cycle_the_closed-loop_controller_can_pull_out_to_suppress_an_overshooting_boost_spike._Stock_Value:_0x20_(32_counts_=_16%_DC_drop)._Overshoot_Control:_Allows_the_ECU_to_decisively_dump_duty_cycle_if_boost_starts_running_away.
    .byte 0x20                       ;Point 1

	;.org	0xc525
KDCINC_WastegateDutyCycleIncreaseStepWhenKnocking:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC472
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseStepWhenKnocking
    ;mptblcname KDCINC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc KDCINC_sets_the_incremental_step_size_applied_to_reduce_wastegate_duty_cycle_each_time_severe_knock_is_confirmed_under_boost._Stock_Value:_0x04_(2.0%_duty_cycle_drop_per_step)._Tuning_Guidance:_Increasing_KDCINC_pulls_boost_down_faster_when_knocking,_providing_extra_safety_on_pump_gas.
    .byte 0x04                       ;Point 1

	;.org	0xc526
KDCMAX_WastegateDutyCycleIncreaseMaxWhenKnocking:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC473
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseMaxWhenKnocking
    ;mptblcname KDCMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc KDCMAX_defines_the_maximum_allowable_cumulative_duty_cycle_reduction_permitted_for_knock_protection._Stock_Value:_0x50_(40.0%_max_reduction)._Guaranteed_Failsafe:_Dropping_40%_duty_cycle_guarantees_the_wastegate_drops_to_base_actuator_spring_level_(5-7_psi),_instantly_extinguishing_high-load_knock.
    .byte 0x50                       ;Point 1

	;.org	0xc527
KDCMIN_WastegateDutyCycleIncreaseMinWhenKnocking:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC474
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseMinWhenKnocking
    ;mptblcname KDCMIN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc KDCMIN_defines_the_minimum_baseline_duty_cycle_reduction_applied_immediately_upon_the_onset_of_persistent_boost_knock._When_knock-driven_boost_reduction_engages,_dropping_only_a_fraction_of_a_percent_would_take_too_long_to_save_the_engine._Stock_Value:_0x0C_(6.0%_initial_drop)._Tuning_Guidance:_Provides_immediate_physical_relief_to_knocking_cylinders.
    .byte 0x0C                       ;Point 1

	;.org	0xc528
BSOLCO_BoostSolenoidCutout:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC475
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BoostSolenoidCutout
    ;mptblcname BSOLCO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc BSOLCO_specifies_the_knock_spark_retard_threshold_above_which_the_wastegate_solenoid_is_completely_de-energized_(cut_out)._Stock_Value:_0x07_(_~_3.5_deg_spark_retard)._Engine_Protection:_Immediate,_physical_boost_cut_to_protect_the_head_gasket_and_pistons_if_bad_gasoline_or_extreme_heat_causes_persistent_detonation._Tuning_Guidance:_Do_not_raise_excessively;_cutting_boost_when_knocking_is_the_safest_behavior_possible_on_a_turbocharged_engine.
    .byte 0x07                       ;Point 1

	;.org	0xc529
DECTIM_TimeScaleFor_DCDECK:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC476
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeScaleFor_DCDECK
    ;mptblcname DECTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DECTIM_defines_the_time_interval_bitmask_clock_governing_the_rate_at_which_wastegate_duty_cycle_is_steadily_decremented_while_knock_spark_retard_remains_active._Works_as_the_time-base_prescaler_for_DCDECK._Stock_Value:_0x03._Leave_at_default_setting.
    .byte 0x03                       ;Point 1

	;.org	0xc52a
DCDECK_WastegateDutyCycleDecrementWhenSparkStillDerated:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC477
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleDecrementWhenSparkStillDerated
    ;mptblcname DCDECK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DCDECK_specifies_the_continuous_decrement_rate_pulled_from_wastegate_duty_cycle_while_ignition_timing_remains_derated_from_a_knock_event._Stock_Value:_0x02_(1.0%_DC_per_interval)._Tuning_Guidance:_Provides_smooth,_gradual_boost_relaxation_during_sustained_knock.
    .byte 0x02                       ;Point 1

	;.org	0xc52b
MAPPT_WastegateDutyCycleMapSwitchPoint:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC478
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname WastegateDutyCycleMapSwitchPoint
    ;mptblcname MAPPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc MAPPT_defines_the_boost_pressure_breakpoint_dividing_low-load_wastegate_duty_cycle_correction_from_high-load_adaptive_duty_cycle_learning._When_manifold_pressure_crosses_above_MAPPT_(_11.2_psi_),_the_ECU_switches_its_closed-loop_boost_logic_into_Stage_2_adaptive_wastegate_duty_cycle_learning._Stock_Value:_0x62_(_~_11.2_psig_)._Tuning_Guidance:_Should_be_set_near_your_primary_target_boost_level.
    ;mpmapaxis y
    .byte 0x41                       ;Point 1

	;.org	0xc52c
MPDEL1_IncCounterWhenDeltaMapBelowThis:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC479
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname IncCounterWhenDeltaMapBelowThis
    ;mptblcname MPDEL1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc MPDEL1_defines_the_Stage_1_boost_error_threshold_below_which_the_adaptive_wastegate_timer_increments._If_boost_is_lagging_below_target_by_at_least_MPDEL1_(_0.35_psi_),_the_ECU_starts_counting_elapsed_time_toward_an_adaptive_duty_cycle_increase._Stock_Value:_0x03_(_0.35_psi_)._Tuning_Guidance:_Establishes_the_lower_error_sensitivity_band_for_adaptive_boost_trimming.
    ;mpmapaxis y
    .byte 0x02                       ;Point 1

	;.org	0xc52d
INCPT_AdaptiveIncAfterThisTime:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC47A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveIncAfterThisTime
    ;mptblcname INCPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc INCPT_defines_the_dwell_time_in_boost_error_counts_that_underboost_must_persist_before_adaptive_wastegate_duty_cycle_is_incremented._Prevents_transient_turbo_spool_delay_from_prematurely_adapting_the_wastegate_duty_cycle_upward._Stock_Value:_0x0A_(10_counts)._Tuning_Guidance:_Keeps_adaptive_boost_trims_stable_and_immune_to_momentary_spool_lag.
    .byte 0x0A                       ;Point 1

	;.org	0xc52e
MPROOF_StopAdaptiveWGWhenMapIsThisCloseToBoostTarget:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC47B
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname StopAdaptiveWGWhenMapIsThisCloseToBoostTarget
    ;mptblcname MPROOF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc MPROOF_defines_the_adaptive_wastegate_deadband_target_window._Once_manifold_pressure_is_within_MPROOF_(_0.23_psi_)_of_target_boost,_the_boost_level_is_considered_accurate,_and_all_adaptive_duty_cycle_learning_freezes_to_avoid_hunting._Stock_Value:_0x02_(_0.23_psi_)._Tuning_Guidance:_Tight_deadband_ensures_precision_boost_control_without_constant_adaptation_churn.
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

	;.org	0xc52f
INCLM2_UpperLimitOnWastegateDutyCycleCorrection2:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC47C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UpperLimitOnWastegateDutyCycleCorrection2
    ;mptblcname INCLM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc INCLM2_establishes_the_Stage_2_upper_clamp_limit_on_total_adaptive_wastegate_duty_cycle._Caps_total_wastegate_duty_cycle_during_Stage_2_adaptive_adjustment_to_88.0%_(0xB0),_ensuring_that_the_wastegate_retains_some_mechanical_bleed_authority_and_does_not_pin_fully_closed._Stock_Value:_0xB0_(88.0%_DC)._Tuning_Guidance:_If_you_need_100%_duty_cycle_to_hold_high_boost_on_small_turbos,_raise_INCLM2_to_0xC8_(100%).
    .byte 0xB0                       ;Point 1

	;.org	0xc530
MPDEL2_IncCounterWhenDeltaMapBelowThis2:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC47D
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname IncCounterWhenDeltaMapBelowThis2
    ;mptblcname MPDEL2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 44.1 psi
    ;mptbldesc MPDEL2_defines_the_Stage_2_secondary_boost_error_threshold_used_during_high-load_adaptive_duty_cycle_tracking._Stock_Value:_0x02_(_0.23_psi_)._Leave_at_stock_setting.
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

	;.org	0xc531
INCPT2_AdaptiveIncAfterThisTime2:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC47E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveIncAfterThisTime2
    ;mptblcname INCPT2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc INCPT2_specifies_the_secondary_stage_boost_error_dwell_duration_required_before_incrementing_duty_cycle_in_high-load_adaptive_mode._Stock_Value:_0x0A_(10_counts)._Leave_at_stock_setting.
    .byte 0x0A                       ;Point 1

	;.org	0xc532
MPDEL3_IncCounterWhenDeltaMapBelowThis3:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC47F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname IncCounterWhenDeltaMapBelowThis3
    ;mptblcname MPDEL3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc MPDEL3_provides_the_tertiary_error_comparison_threshold_for_adaptive_wastegate_duty_cycle_modulation._Stock_Setting:_0x00._Leave_at_factory_setting.
    .byte 0x00                       ;Point 1

	;.org	0xc533
INCLIM_UpperLimitOnWastegateDutyCycleCorrection:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC480
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UpperLimitOnWastegateDutyCycleCorrection
    ;mptblcname INCLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc INCLIM_establishes_the_primary_Stage_1_upper_clamp_limit_on_adaptive_wastegate_duty_cycle_correction._Caps_the_maximum_correction_allowed_during_the_initial_spool-up_adaptive_phase_to_49.0%_(0x62),_preventing_excessive_duty_cycle_accumulation_before_high_RPM_is_reached._Stock_Value:_0x62_(49.0%_DC)._Tuning_Guidance:_If_upgrading_to_a_large_turbo_that_requires_high_duty_cycle_to_spool,_raise_INCLIM_to_65-75%_(0x82-0x96).
    .byte 0x62                       ;Point 1

	;.org	0xc534
DCRPML_NoWastegateDutyCycleCorrectionBelowThisRpm:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC481
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoWastegateDutyCycleCorrectionBelowThisRpm
    ;mptblcname DCRPML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc DCRPML_defines_the_lower_engine_speed_threshold_below_which_adaptive_wastegate_duty_cycle_correction_is_completely_inhibited._Below_1504_RPM,_engine_exhaust_flow_is_insufficient_to_generate_meaningful_boost._Adapting_wastegate_duty_cycle_at_low_lugging_RPMs_would_corrupt_the_duty_cycle_tables._DCRPML_locks_adaptive_duty_cycle_learning_out_below_1504_RPM._Stock_Value:_0x2F_(_1504_RPM_)._Leave_at_factory_setting.
    .byte 0x2F                       ;Point 1

	;.org	0xc535
DCRPMH_NoWastegateDutyCycleCorrectionAboveThisRpm:
    ;mpgrp Boost_Control\WG_Control\
    ;mptbladdr 0xC482
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoWastegateDutyCycleCorrectionAboveThisRpm
    ;mptblcname DCRPMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc DCRPMH_defines_the_upper_engine_speed_threshold_above_which_adaptive_wastegate_duty_cycle_correction_is_frozen._Stock_Value:_0x4F_(_2528_RPM_)._Big_Turbo_Upgrades:_Large_turbos_(e.g._Holset_HX35,_Garrett_GT30R)_spool_later_(often_between_3000_and_4200_RPM)._Raising_DCRPMH_to_0x80_(_4096_RPM_)_expands_the_adaptive_spool-up_learning_window_to_match_the_spool_RPM_of_the_larger_turbo.
    .byte 0xFF                       ;Point 1

	;.org	0xc536
MPSHFT_OverboostFuelShutoffEnablePointFromMap_Timer:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Overboost\
    ;mptbladdr 0xC483
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostFuelShutoffEnablePointFromMap_Timer
    ;mptblcname MPSHFT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc MPSHFT_establishes_the_timed_overboost_fuel_shutoff_threshold._Stock_Value:_0x76_(_13.6_psig_)._The_"Hitting_a_Brick_Wall"_Sensation:_When_modifying_a_Chrysler_turbo_car_with_a_manual_bleed_valve_or_aftermarket_boost_controller,_hitting_14_psi_triggers_the_overboost_fuel_cut,_causing_the_car_to_violently_buck_forward.
    ;mpmapaxis y
    .byte 0x97                       ;Point 1

	;.org	0xc537
MPSHFA_OverboostFuelShutoffEnablePointFromMap_Absolute:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Overboost\
    ;mptbladdr 0xC484
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostFuelShutoffEnablePointFromMap_Absolute
    ;mptblcname MPSHFA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc MPSHFA_defines_the_instantaneous_hard_overboost_ceiling_offset._Stock_Value:_0x1A_(_3.0_psi_above_MPSHFT)._Absolute_Failsafe:_Hard_stop_protecting_against_catastrophic_boost_spikes._Tuning_Guidance:_When_raising_MPSHFT,_ensure_MPSHFA_is_adjusted_appropriately,_or_set_MPSHFT_=_0xFF_to_disable_both_stages.
    ;mpmapaxis y
    .byte 0x0C                       ;Point 1

	;.org	0xc538
TRNTM_OverboostFuelShutoffDelay:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Overboost\
    ;mptbladdr 0xC485
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OverboostFuelShutoffDuration
    ;mptblcname TRNTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 Sec
    ;mptbldesc TRNTIM_specifies_the_countdown_delay_duration_that_boost_must_exceed_MPSHFT_before_fuel_shutoff_triggers._Provides_an_0.8-second_buffer_window_so_quick_gear_shifts_or_momentary_spool_spikes_do_not_cause_irritating_fuel_cuts_if_boost_quickly_settles_back_down_to_target._Stock_Setting:_0x17_(_~_0.8_sec_)._Tuning_Guidance:_Increasing_TRNTIM_gives_the_wastegate_more_time_to_reel_in_minor_overshoots_without_cutting_fuel.
    .byte 0x5B                       ;Point 1

	;.org	0xc539
LMPSHF_OverboostFuelShutoffDisablePointFromMap_Limp:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Overboost\
    ;mptbladdr 0xC486
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostFuelShutoffDisablePointFromMap_Limp
    ;mptblcname LMPSHF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc LMPSHF_defines_the_overboost_fuel_shutoff_threshold_applied_when_the_ECU_is_in_Limp_Mode_(due_to_a_detected_wastegate_or_MAP_sensor_fault)._If_the_ECU_flags_a_wastegate_electrical_problem_or_MAP_sensor_out-of-range_condition_(BitFlags_80_bit_4_set),_standard_boost_targeting_cannot_be_trusted._Stock_Value:_0x73_(_13.2_psig_)._Tuning_Guidance:_Should_never_be_disabled;_ensures_limp_mode_safety_if_boost_control_wiring_fails.
    ;mpmapaxis y
    .byte 0x4B                       ;Point 1

	;.org	0xc53a
FANTMP_FanTurnOnTempAbove45Mph:
    ;mpgrp Fan_Control\
    ;mptbladdr 0xC487
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOnTempAbove45Mph
    ;mptblcname FANTMP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc FANTMP1_defines_the_radiator_cooling_fan_turn-on_temperature_threshold_(stock_calibration_=_0xEE_/_~218_degF)_when_the_vehicle_is_cruising_at_highway_speeds_(above_45_MPH)._160_degF_/_180_degF_Thermostats:_When_upgrading_to_a_180_degF_thermostat,_lower_FANTMP1_to_0xD2_(~195_degF)._For_a_160_degF_thermostat,_lower_to_0xBC_(~175_degF).
    .byte 0xE8                       ;Point 1

	;.org	0xc53b
FANTMP2_FanTurnOffTempAbove45Mph:
    ;mpgrp Fan_Control\
    ;mptbladdr 0xC488
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOffTempAbove45Mph
    ;mptblcname FANTMP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc FANTMP2_establishes_the_radiator_cooling_fan_turn-OFF_temperature_threshold_(stock_calibration_=_0xE8_/_~208_degF)_when_cruising_above_45_MPH._Hysteresis_Staggering:_Always_calibrate_FANTMP2_roughly_8_degF_to_12_degF_below_FANTMP1._If_FANTMP2_is_set_too_close_to_FANTMP1,_relay_contacts_will_arc_and_wear_prematurely.
    .byte 0xE2                       ;Point 1

	;.org	0xc53c
FANTMP3_FanTurnOnTempBelow35Mph:
    ;mpgrp Fan_Control\
    ;mptbladdr 0xC489
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOnTempBelow35Mph
    ;mptblcname FANTMP3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc FANTMP3_is_the_primary_low-speed_and_curb_idle_radiator_fan_turn-on_threshold_(stock_calibration_=_0xE3_/_~200_degF)._Most_Important_Fan_Setting:_FANTMP3_is_the_parameter_tuners_adjust_most_frequently_to_control_hot_idle_temperatures._180_degF_Thermostat_Setup:_Lower_FANTMP3_from_stock_~200_degF_(0xE3)_down_to_0xCB_(~188_degF)._160_degF_Thermostat_Setup:_Lower_FANTMP3_to_0xB5_(~172_degF).
    .byte 0xD9                       ;Point 1

	;.org	0xc53d
FANTMP4_FanTurnOffTempBelow35Mph:
    ;mpgrp Fan_Control\
    ;mptbladdr 0xC48A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOffTempBelow35Mph
    ;mptblcname FANTMP4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc FANTMP4_defines_the_temperature_(stock_calibration_=_0xDD_/_~192_degF)_where_the_electric_cooling_fan_shuts_off_after_completing_a_low-speed_cooling_cycle._Stagger_with_Thermostat:_Ensure_FANTMP4_is_at_least_3_degF_to_5_degF_above_your_thermostat_rated_opening_temperature._For_a_180_degF_thermostat,_set_FANTMP3_=_190_degF_and_FANTMP4_=_184_degF.
    .byte 0xD7                       ;Point 1

	;.org	0xc53e
FANMAP_FanTurnsOnWhenMapAboveBaroPlusThis:
    ;mpgrp Fan_Control\
    ;mptbladdr 0xC48B
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname FanTurnsOnWhenMapAboveBaroPlusThis
    ;mptblcname FANMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc FANMAP_is_a_specialized_performance_feature_(stock_calibration_=_0x1A_/_~3.2_psi_of_boost_above_baro)_that_energizes_the_radiator_cooling_fan_during_sustained_turbo_boost._Drag_Racing_&_Heat-Soak_Protection:_Setting_FANMAP_to_0x10_(~2_psi)_ensures_that_the_moment_the_turbo_spools_into_boost,_the_cooling_fan_spins_up_immediately,_minimizing_heat-soak_in_the_engine_compartment_during_a_quarter-mile_pass.
    ;mpmapaxis y
    .byte 0x11                       ;Point 1

	;.org	0xc53f
FANBAT_FanTurnsOnWhenBatteryTempAboveThis:
    ;mpgrp Fan_Control\
    ;mptbladdr 0xC48C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnsOnWhenBatteryTempAboveThis
    ;mptblcname FANBAT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Battery_Temp -200 260 Degrees
    ;mptbldesc FANBAT_defines_an_underhood_temperature_threshold_(stock_calibration_=_0x9A_/_~120_degF)_measured_by_the_battery_tray_thermistor._Underhood_Heat_Management:_Useful_on_tight_engine_bays_(like_Omni_/_Charger_GLH)_where_turbo_heat_buildup_is_intense._Battery_Relocation:_If_the_battery_tray_thermistor_is_disconnected_or_deleted,_ensure_this_check_does_not_trigger_false_fan_activation.
    .byte 0x9A                       ;Point 1

	;.org	0xc540
BRPML2_BaroReadLowRPM18002:
    ;mpgrp Utility\Baro_Read\
    ;mptbladdr 0xC48D
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname BaroReadLowRPM18002
    ;mptblcname BRPML2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 16384 rpm
    ;mptbldesc BRPML2_defines_the_minimum_engine_speed_(stock_calibration_=_1,800_RPM_/_0x1C20)_required_to_execute_an_in-flight_barometric_pressure_read._Stock_Setting:_0x1C20_(1,800_RPM)._Preventing_Low-Speed_Baro_Cycling:_Solenoid_clicks_during_slow_city_driving_can_occasionally_cause_tiny_manifold_pressure_dips.
    .word 0x1770                     ;Point 1

	;.org	0xc542
BRPMH2_BaroReadHighRPM66502:
    ;mpgrp Utility\Baro_Read\
    ;mptbladdr 0xC48F
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname BaroReadHighRPM66502
    ;mptblcname BRPMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 16384 rpm
    ;mptbldesc BRPMH_defines_the_absolute_maximum_engine_speed_(stock_calibration_=_6,650_RPM_/_0x3E80)_beyond_which_the_ECU_will_never_attempt_an_in-flight_barometric_pressure_read._High-Revving_Engines:_If_an_engine_is_built_to_rev_to_7,500_-_8,000_RPM,_keep_BRPMH_well_below_the_maximum_redline_(stock_6,650_RPM_is_ideal)_to_guarantee_baro_updates_never_occur_under_high-stress_operating_conditions.
    .word 0x3E80                     ;Point 1

	;.org	0xc544
BRDLAY_BaroReadDelayAfterThrottleClosed2sec:
    ;mpgrp Utility\Baro_Read\
    ;mptbladdr 0xC491
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadDelayAfterThrottleClosed2sec
    ;mptblcname BRDLAY
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc BRDLAY_establishes_the_settling_time_delay_(stock_calibration_=_45_ticks_/_~2.0_seconds)_that_the_engine_must_remain_in_a_stable,_closed-throttle_state_within_the_valid_RPM_window_before_the_baro_read_solenoid_is_energized._Stock_Value:_0x2D_(~2.0_seconds)._Transient_Resistance:_Increasing_BRDLAY_makes_the_system_more_conservative,_requiring_longer_settled_periods_before_taking_a_reading.
    .byte 0x17                       ;Point 1

	;.org	0xc545
BARTIM_BaroReadMinTimeBetweenReadings179sec:
    ;mpgrp Utility\Baro_Read\
    ;mptbladdr 0xC492
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadMinTimeBetweenReadings179sec
    ;mptblcname BARTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 720 sec
    ;mptbldesc BARTIM_defines_the_mandatory_minimum_time_interval_(stock_calibration_=_64_ticks_/_~179_seconds_/_approx_3_minutes)_between_successive_barometric_pressure_sampling_events_while_driving._Mountain_Pass_Racing:_On_hill-climb_race_courses_with_rapid_elevation_changes_(such_as_Pikes_Peak),_reducing_BARTIM_to_0x15_(~60_seconds)_allows_the_ECU_to_track_rapid_altitude_changes_and_altitude_fuel_trim_compensation_more_aggressively.
    .byte 0x40                       ;Point 1

	;.org	0xc546
BROPTM_BaroReadDelayAfterSolenoidOpenTenthSec:
    ;mpgrp Utility\Baro_Read\
    ;mptbladdr 0xC493
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadDelayAfterSolenoidOpenTenthSec
    ;mptblcname BROPTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc BROPTM_specifies_the_precise_pneumatic_stabilization_delay_(stock_calibration_=_5_tenths_of_a_second_/_0.50_sec)_between_energizing_the_baro_solenoid_and_sampling_the_MAP_sensor_analog-to-digital_converter._Long_Vacuum_Lines_/_Relocated_Sensors:_If_the_MAP_sensor_or_baro_solenoid_has_been_relocated_with_longer_vacuum_lines,_increase_BROPTM_to_0x08_(0.8_seconds)_to_ensure_full_pressure_equalization._Stock_Hardware:_Leave_at_0x05_(0.50_seconds).
    .byte 0x05                       ;Point 1

	;.org	0xc547
BRCLTM_BaroReadDelayAfterSolenoidClosedTenthSec:
    ;mpgrp Utility\Baro_Read\
    ;mptbladdr 0xC494
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadDelayAfterSolenoidClosedTenthSec
    ;mptblcname BRCLTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc BRCLTM_defines_the_required_pneumatic_recovery_delay_(stock_calibration_=_5_tenths_of_a_second_/_0.50_sec)_following_the_de-energization_(closure)_of_the_barometric_read_solenoid._During_an_in-flight_baro_reading,_the_solenoid_vents_the_MAP_sensor_chamber_to_atmospheric_air._Once_the_reading_is_captured_into_RAM,_the_solenoid_de-energizes,_reconnecting_the_sensor_port_to_the_intake_manifold_vacuum_runner._Stock_Value:_0x05_(0.50_seconds).
    .byte 0x05                       ;Point 1

	;.org	0xc548
BAROHI_BaroReadValidHighLimit:
    ;mpgrp Utility\Baro_Read\
    ;mptbladdr 0xC495
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BaroReadValidHighLimit
    ;mptblcname BAROHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 29.4 psi
    ;mptbldesc BAROHI_establishes_the_upper_physical_and_electrical_sanity_boundary_for_atmospheric_barometric_pressure._Under_real-world_meteorological_conditions_on_Earth,_ambient_sea-level_barometric_pressure_rarely_exceeds_30.5_-_31.0_inHg_(even_inside_high-pressure_cold_Arctic_air_masses)._3-Bar_MAP_Sensor_Upgrades:_When_converting_from_a_factory_2-Bar_MAP_sensor_to_a_3-Bar_sensor,_the_sensor_transfer_slope_changes_dramatically.
    ;mpmapaxis y
    .byte 0x59                       ;Point 1

	;.org	0xc549
BAROLO_BaroReadValidLowLimit:
    ;mpgrp Utility\Baro_Read\
    ;mptbladdr 0xC496
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BaroReadValidLowLimit
    ;mptblcname BAROLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 29.4 psi
    ;mptbldesc BAROLO_establishes_the_lower_physical_and_electrical_sanity_limit_for_atmospheric_barometric_pressure._Pikes_Peak_/_Extreme_High_Altitude_Racing:_Stock_BAROLO_permits_operation_up_to_~15,000_feet._If_operating_specialized_vehicles_at_extreme_altitudes,_verify_that_raw_baro_readings_do_not_dip_below_BAROLO.
    ;mpmapaxis y
    .byte 0x2E                       ;Point 1

	;.org	0xc54a
BARDFT_BaroReadDefaultValue:
    ;mpgrp Utility\Baro_Read\
    ;mptbladdr 0xC497
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BaroReadDefaultValue
    ;mptblcname BARDFT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 29.4 psi
    ;mptbldesc BARDFT_defines_the_nominal_sea-level_fallback_atmospheric_pressure_(stock_calibration_=_0x7F_/_127_decimal_=_29.92_inHg_/_101.325_kPa_standard_atmosphere)._If_the_MAP_sensor_is_disconnected,_if_the_baro_solenoid_harness_is_damaged,_or_if_an_in-flight_atmospheric_reading_fails_either_BAROHI_or_BAROLO_boundary_tests,_the_ECU_loads_BARDFT_into_BaroPressure._Stock_Value:_0x7F_(127_decimal_=_standard_1.0_atmosphere).
    ;mpmapaxis y
    .byte 0x55                       ;Point 1

	;.org	0xc54b
MXSPK1_MaxSparkAdvanceUknown1:
    ;mpgrp Utility\Baro_Read\
    ;mptbladdr 0xC498
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxSparkAdvanceUknown1
    ;mptblcname MXSPK1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc MXSPK1_provides_a_hard_physical_ceiling_on_total_ignition_advance_(stock_calibration_=_0x6E_=_110_decimal_/_110_*_0.5_deg_=_55.0_deg_BTDC)_evaluated_inside_StoreDwell._Mechanical_Rotor_Phase_Limit:_NEVER_increase_MXSPK1_above_56_deg_BTDC_on_factory_distributor_systems._Doing_so_will_cause_distributor_cap_cross-firing,_erratic_misfires,_and_backfires_under_light_cruising_conditions.
    .byte 0x6E                       ;Point 1

	;.org	0xc54c
MXSPK2_MaxSparkAdvanceUknown2:
    ;mpgrp Utility\Baro_Read\
    ;mptbladdr 0xC499
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxSparkAdvanceUknown2
    ;mptblcname MXSPK2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc MXSPK2_provides_the_secondary_physical_ignition_advance_ceiling_(stock_calibration_=_0x6D_=_109_decimal_/_109_*_0.5_deg_=_54.5_deg_BTDC)._High-Vacuum_Cruise_Advance:_When_tuning_light-throttle_highway_cruise_ignition_timing_for_maximum_fuel_economy,_the_sum_of_SPKCRU_and_base_spark_may_approach_50_deg._MXSPK2_prevents_cumulative_additions_from_over-advancing_the_coil_trigger.
    .byte 0x6D                       ;Point 1

	;.org	0xc54d
FMODDV2_StandardFuelModifierDivisor_2:
    ;mpgrp Utility\Baro_Read\
    ;mptbladdr 0xC49A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StandardFuelModifierDivisor_2
    ;mptblcname FMODDV2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc FMODDV2_is_an_internal_mathematical_scaling_divisor_(stock_calibration_=_0x1A_/_26_decimal)_utilized_inside_subroutine_CalculateSumOfAllFuelModifiers_MM._Fixed_Mathematical_Constant:_Do_not_modify_FMODDV2._Changing_this_value_alters_the_fundamental_fixed-point_algebra_of_the_fuel_modifier_pipeline,_causing_global_over-fueling_or_severe_lean_conditions_across_all_driving_modes.
    .byte 0x1A                       ;Point 1

	;.org	0xc54e
ErrorCodeBitMask0:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0xC49B
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname ErrorCodeBitMask0
    ;mptblcname ERMSK0
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ERMSK0_is_the_first_of_four_diagnostic_fault_masking_bytes_that_govern_whether_detected_hardware_anomalies_are_logged_into_non-volatile_error_memory_(ErrorBitRegisterStored0)._Disabling_Nuisance_Fault_Codes:_If_a_modified_engine_has_deleted_certain_emissions_components_or_sensor_circuits,_clearing_specific_bits_in_ERMSK0_stops_the_ECU_from_logging_those_error_codes_into_memory_or_flashing_them_on_the_Check_Engine_light.
    ;mpchoices 54_DistSync  53_Checksum  52_StuckRich  51_StuckLean  47_LowVoltage  46_HighVoltage  45_Overboost  44_LostFJ2
    .byte 0xFF                       ;Point 1

ErrorCodeBitMask1:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0xC49C
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname ErrorCodeBitMask1
    ;mptblcname ERMSK1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ERMSK1_is_the_second_diagnostic_masking_byte,_located_at_$1020_directly_following_ERMSK0._O2_Sensor_Deletion_(Track_Cars):_For_off-road_race_cars_running_open-loop_without_an_oxygen_sensor,_clearing_the_O2_diagnostic_bit_in_ERMSK1_prevents_the_ECU_from_continuously_storing_Code_21.
    ;mpchoices 43_IgnitionCoil  42_ASDRelay  41_ChargingSystem  37_BaroReadSolenoid  36_WastegateSolenoid  35_RadFanRelay  34_SpeedCtlSolenoid  33_AcCutoutRelay
    .byte 0xBF                       ;Point 1

ErrorCodeBitMask2:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0xC49D
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname ErrorCodeBitMask2
    ;mptblcname ERMSK2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ERMSK2_controls_diagnostic_fault_code_detection_for_powertrain_solenoid_drivers,_including_canister_purge_(Code_31),_wastegate_solenoid_(Code_32),_EGR_solenoid_(Code_33),_and_fan_relay_(Code_35)._If_disconnecting_the_factory_wastegate_solenoid_for_a_manual_or_aftermarket_boost_controller,_clear_Bit_1_to_suppress_Fault_Code_32.
    ;mpchoices 32_EGR  31_PurgeSolenoid  27_InjectorDriver  26_InjectorCurrent  25_AIS  24_TPS  23_ChargeTempSensor  22_CoolantTempSensor
    .byte 0xFE                       ;Point 1

ErrorCodeBitMask3:
    ;mpgrp Setup\Cal_Configuration\
    ;mptbladdr 0xC49E
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname ErrorCodeBitMask3
    ;mptblcname ERMSK3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ERMSK3_is_the_fourth_diagnostic_trouble_code_mask,_governing_alternator_field_control_(Code_41),_automatic_shutdown_driver_(Code_42),_ignition_coil_primary_driver_(Code_44),_and_ROM_checksum_self-test_integrity_(Code_53)._Stock_calibration_sets_ERMSK3_to_0xFF_(all_faults_enabled),_ensuring_complete_system_monitoring_of_the_power_generation_and_ignition_circuits.
    ;mpchoices 21_O2Sensor  17_EngineTooCool  16_BattVoltageSense  15_DistanceSensor  14_MapElectrical  13_MapPneumatic  12_MemPowerLost  11_NotCranked
    .byte 0xFF                       ;Point 1

	;.org	0xc552
LTHTIM_IfNoO2SwitchForThisTimeThrowFault51or52:
    ;mpgrp Fuel\O2_Feedback_Control\O2_Controller\
    ;mptbladdr 0xC49F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname IfNoO2SwitchForThisTimeThrowFault51or52
    ;mptblcname LTHTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LTHTIM_sets_the_diagnostic_fault_timeout_for_detecting_a_permanently_stuck_or_unresponsive_oxygen_sensor_during_closed-loop_operation._Stock_Setting:_0xFE_(254_counts_2.8_s_~_711_seconds_~_11.9_minutes_)._Diagnostic_Ramifications:_When_Fault_51_or_52_is_set,_your_learned_adaptive_fuel_trims_are_instantly_wiped_out._The_car_will_revert_to_pure_baseline_open-loop_tables_until_the_fault_condition_clears.
    .byte 0xFE                       ;Point 1

	;.org	0xc553
TTEMPL_TstatDiagnosticsMinTempToArmDiagnosticsAtStartup:
    ;mpgrp Utility\On-Board_Diagnostics\T-Stat_Diagnostics\
    ;mptbladdr 0xC4A0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsMinTempToArmDiagnosticsAtStartup
    ;mptblcname TTEMPL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc TTEMPL_defines_the_lower_temperature_boundary_(stock_calibration_=_0x63_/_~70_degF)_required_for_the_ECU_to_arm_the_onboard_thermostat_functional_diagnostic_monitor_(Timer_ThermostatDiagnostics)._Cold_Climate_Tuning:_In_freezing_climates,_keeping_TTEMPL_at_stock_(~70_degF)_ensures_that_cold_winter_starts_do_not_trigger_false_Code_17_trouble_codes.
    .byte 0x63                       ;Point 1

	;.org	0xc554
TTEMPH_TstatDiagnosticsMaxTempToArmDiagnosticsAtStartup:
    ;mpgrp Utility\On-Board_Diagnostics\T-Stat_Diagnostics\
    ;mptbladdr 0xC4A1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsMaxTempToArmDiagnosticsAtStartup
    ;mptblcname TTEMPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc TTEMPH_defines_the_upper_temperature_boundary_(stock_calibration_=_0xE4_/_~228_degF)_for_arming_the_thermostat_diagnostic_monitor._Stock_Value:_0xE4_(~228_degF)._Tuner_Usage:_Retain_stock_setting._Prevents_unnecessary_diagnostic_timer_execution_on_hot_engine_restarts.
    .byte 0xE4                       ;Point 1

	;.org	0xc555
TDAGTP_TstatDiagnosticsTemperatureGoalWithin_HOTIME:
    ;mpgrp Utility\On-Board_Diagnostics\T-Stat_Diagnostics\
    ;mptbladdr 0xC4A2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsTemperatureGoalWithin_HOTIME
    ;mptblcname TDAGTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc TDAGTP_is_the_target_coolant_temperature_threshold_(stock_calibration_=_0xC7_/_~190_degF_/_88_degC)_that_the_engine_is_required_to_reach_during_warm-up_driving._160_degF_/_180_degF_Low-Temperature_Thermostats:_This_is_a_classic_false_trouble_code_trigger_on_modified_cars!_If_you_install_a_160_degF_or_180_degF_performance_thermostat,_the_engine_may_stabilize_at_165_degF_-_175_degF.
    .byte 0xC7                       ;Point 1

	;.org	0xc556
HOTIME_TstatDiagnosticsTimeToAchieveTemperatureGoal:
    ;mpgrp Utility\On-Board_Diagnostics\T-Stat_Diagnostics\
    ;mptbladdr 0xC4A3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsTimeToAchieveTemperatureGoal
    ;mptblcname HOTIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HOTIME_sets_the_maximum_elapsed_driving_time_window_(stock_calibration_=_174_ticks_/_~8_to_10_minutes)_during_which_the_engine_must_reach_the_thermostat_diagnostic_target_temperature_(TDAGTP)._Winter_Warmup_/_High_Flow_Radiators:_In_cold_winter_climates_or_with_massive_aluminum_racing_radiators,_warmup_can_take_slightly_longer._Increasing_HOTIME_gives_the_engine_extra_time_to_warm_up_before_setting_a_trouble_code.
    .byte 0xAE                       ;Point 1

	;.org	0xc557
MPTHCK_MAPLimitforThrottleBelowHalfChecking:
    ;mpgrp Setup\Throttle_Calibration\
    ;mptbladdr 0xC4A4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MAPLimitforThrottleBelowHalfChecking
    ;mptblcname MPTHCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc MPTHCK_defines_the_manifold_pressure_ceiling_(stock_calibration_=_0x5E_/_~75_kPa)_evaluated_during_throttle_sensor_rationality_routines_in_CheckThrottle_AtFullThrottle._Stock_Value:_0x5E._Large_Duration_Camshafts:_Radical_racing_camshafts_have_poor_idle_vacuum_(high_idle_MAP,_e.g._70-80_kPa)._If_a_big_camshaft_causes_erratic_TPS_learning_or_unintended_closed-throttle_baseline_shifts,_raising_MPTHCK_accommodates_the_lower_idle_vacuum.
    .byte 0x5E                       ;Point 1

	;.org	0xc558
RPTHCK_RPMLimitforThrottleBelowHalfChecking:
    ;mpgrp Setup\Throttle_Calibration\
    ;mptbladdr 0xC4A5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimitforThrottleBelowHalfChecking
    ;mptblcname RPTHCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc RPTHCK_specifies_the_lower_engine_speed_limit_(stock_calibration_=_0x18_/_24_*_32_=_768_RPM)_for_throttle_sensor_rationality_evaluation._Prevents_the_ECU_from_adjusting_learned_closed-throttle_baselines_while_the_engine_is_cranking_or_running_at_sub-idle_stall_speeds._High_Target_Idle_Tuning:_If_target_idle_speed_is_raised_to_950_-_1,050_RPM_for_a_race_engine,_RPTHCK_can_be_left_stock_or_raised_proportionally_to_0x1E_(960_RPM).
    .byte 0x18                       ;Point 1

	;.org	0xc559
MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected:
    ;mpgrp Setup\Throttle_Calibration\
    ;mptbladdr 0xC4A6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ValueOf_MINTHR_WhenBatteryDisconnected
    ;mptblcname MTHRMX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MTHRMX_is_the_default_baseline_closed-throttle_voltage_loaded_into_MINTHR_LowestSessionTPS_whenever_the_battery_is_disconnected_or_the_ECU_undergoes_a_hard_power_reset._Aftermarket_Throttle_Bodies_(Holley_/_Ford_5.0_/_Willys):_When_retrofitting_aftermarket_throttle_bodies,_the_closed-throttle_sensor_voltage_might_rest_higher_or_lower_than_stock.
    .byte 0x5C                       ;Point 1

	;.org	0xc55a
MININC_Amount_MINTHR_IsIncreasedAtKeyOnOnly:
    ;mpgrp Setup\Throttle_Calibration\
    ;mptbladdr 0xC4A7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Amount_MINTHR_IsIncreasedAtKeyOnOnly
    ;mptblcname MININC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MININC_specifies_an_initial_positive_voltage_buffer_added_to_minimum_throttle_baseline_voltage_(MINTHR)_during_key-on_reset_initialization._When_the_ignition_key_is_first_turned_on,_the_throttle_return_spring_might_not_have_seated_the_throttle_blade_fully_against_the_stop_screw,_or_electrical_ground_voltages_might_experience_initial_power-up_bounce._Stock_Value:_0x05_(_0.10_V_)._Leave_at_factory_setting.
    .byte 0x03                       ;Point 1

	;.org	0xc55b
MININH_Amount_MINTHR_IsIncreasedAtKeyOnOnlyHalfThrottle:
    ;mpgrp Setup\Throttle_Calibration\
    ;mptbladdr 0xC4A8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Amount_MINTHR_IsIncreasedAtKeyOnOnlyHalfThrottle
    ;mptblcname MININH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc MININH_provides_a_secondary_fine-trim_offset_applied_during_startup_throttle_normalization._Stock_Value:_0x02._Leave_at_default_setting.
    .byte 0x04                       ;Point 1

	;.org	0xc55c
MTHROP_NumberOfBitsAbove_MINTHR_ToDetermineOffThrottleTransition:
    ;mpgrp Setup\Throttle_Calibration\
    ;mptbladdr 0xC4A9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NumberOfBitsAbove_MINTHR_ToDetermineOffThrottleTransition
    ;mptblcname MTHROP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MTHROP_defines_the_tight_voltage_threshold_(stock_calibration_=_1_ADC_count_/_~0.02V)_above_MINTHR_LowestSessionTPS_for_the_ECU_to_declare_the_engine_has_returned_to_the_OFF-throttle_state._Sticky_Throttle_Cables:_If_a_sticky_throttle_cable_or_weak_return_spring_causes_the_throttle_to_stop_0.05V_above_the_mechanical_stop,_the_ECU_may_think_the_driver_is_still_resting_a_foot_on_the_gas,_preventing_idle_regulation.
    .byte 0x01                       ;Point 1

	;.org	0xc55d
MTHRCL_NumberOfBitsAbove_MINTHR_ToDetermineOnThrottleTransition:
    ;mpgrp Setup\Throttle_Calibration\
    ;mptbladdr 0xC4AA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NumberOfBitsAbove_MINTHR_ToDetermineOnThrottleTransition
    ;mptblcname MTHRCL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MTHRCL_specifies_the_deadband_margin_(stock_calibration_=_3_ADC_counts_/_~0.059V)_above_MINTHR_LowestSessionTPS_that_the_throttle_voltage_must_exceed_before_the_ECU_declares_an_ON-throttle_transition._Hypersensitive_Tip-In:_If_light_vehicle_vibrations_or_rough_road_bumps_cause_the_engine_to_jerk_or_jump_out_of_closed-loop_idle,_increasing_MTHRCL_to_4_or_5_counts_increases_throttle_deadband_stability.
    .byte 0x03                       ;Point 1

	;.org	0xc55e
MAXCNT_ProgramLoopsWithThrottleBelow_MINTHR_ToDecrement_MINTHR:
    ;mpgrp Setup\Throttle_Calibration\
    ;mptbladdr 0xC4AB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ProgramLoopsWithThrottleBelow_MINTHR_ToDecrement_MINTHR
    ;mptblcname MAXCNT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MAXCNT_is_the_integration_filter_counter_(stock_calibration_=_16_loops_/_~176_ms)_that_controls_the_ratcheting_speed_of_learned_closed-throttle_baseline_MINTHR._Stock_Value:_0x10_(16_loops)._Fast_Adaptive_Learning:_Rarely_needs_modification._Provides_rock-solid_immunity_to_ignition_coil_firing_noise_on_the_sensor_ground_bus.
    .byte 0x10                       ;Point 1

	;.org	0xc55f
REVLMT_OverRevFuelShutoff:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0xC4AC
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname OverRevFuelShutoffMapLimpinLower
    ;mptblcname REVLMT
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc REVLMT_is_the_master_engine_redline_rev_limiter_(fuel_cut_enable_RPM)._Protects_the_valvetrain_from_valve_float,_piston-to-valve_contact,_and_rod_bearing_failure._Stock_Cut_Point:_~_6490_RPM_._Raising_Redline:_For_modified_engines_with_upgraded_valve_springs_and_performance_camshafts,_raise_REVLMT_to_6800-7200_RPM._Always_raise_REVLMT2_proportionally_to_ensure_smooth_fuel_recovery.
    .word 0x3F00                     ;Point 1

	;.org	0xc561
REVLMT2_OverRevFuelShutoff:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0xC4AE
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname OverRevFuelShutoffMapLimpinUpper
    ;mptblcname REVLMT2
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc REVLMT2_is_the_rev_limiter_recovery_threshold_(fuel_cut_disable_RPM)._Works_with_REVLMT_to_provide_80_RPM_hysteresis._Once_fuel_is_cut_at_6490_RPM,_engine_speed_must_drop_below_6410_RPM_before_injector_pulses_are_re-enabled._Hysteresis_Band:_The_80_RPM_gap_produces_a_sharp,_clean_rev_limiter_bounce_rather_than_engine_bucking.
    .word 0x3B00                     ;Point 1

	;.org	0xc563
REVLMT3_OverRevFuelShutoff:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0xC4B0
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname OverRevFuelShutoffTpsLimpinLower
    ;mptblcname REVLMT3
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc REVLMT3_defines_the_secondary_rev_limiter_enable_point_(used_during_low_vehicle_speed_or_closed-throttle_conditions)._Neutral_/_Staging_Rev_Limit:_Can_be_re-purposed_as_a_stationary_/_neutral_rev_limiter.
    .word 0x3B00                     ;Point 1

	;.org	0xc565
REVLMT4_OverRevFuelShutoff:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0xC4B2
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname OverRevFuelShutoffTpsLimpinUpper
    ;mptblcname REVLMT4
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc REVLMT4_is_the_recovery_threshold_(hysteresis_companion)_for_secondary_rev_limiter_REVLMT3._Hysteresis:_Paired_with_REVLMT3.
    .word 0x2700                     ;Point 1

	;.org	0xc567
REVLMT5_OverRevFuelShutoff:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Rev_Limit\
    ;mptbladdr 0xC4B4
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname OverRevFuelShutoffNormalLower
    ;mptblcname REVLMT5
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc REVLMT5_defines_the_Stage_3_high-load_in-gear_rev_limiter_enable_point._Tuning_Guidance:_Adjust_in_unison_with_REVLMT_when_extending_engine_rev_range.
    .word 0x1121                     ;Point 1

	;.org	0xc569
REVLMT6_OverRevFuelShutoff:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Rev_Limit\
    ;mptbladdr 0xC4B6
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname OverRevFuelShutoffNormalUpper
    ;mptblcname REVLMT6
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc REVLMT6_is_the_recovery_threshold_(hysteresis_companion)_for_Stage_3_rev_limiter_REVLMT5._Hysteresis:_Paired_with_REVLMT5.
    .word 0x10BD                     ;Point 1

	;.org	0xc56b
THRTHR_25PctThrValueFromShutoff:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0xC4B8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 25PctThrValueFromShutoff
    ;mptblcname THRTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc THRTHR_defines_the_25%_throttle_position_threshold_offset_added_to_minimum_throttle_voltage_to_distinguish_between_closed/light_throttle_rev_limiting_and_full-throttle_rev_limiting._Stock_Value:_0x21_(_~_25%_throttle_opening)._Leave_at_factory_setting.
    .byte 0x21                       ;Point 1

	;.org	0xc56c
RVLSPD_CarSpeedForRevLimitWithTBOff:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\Misc,_Limp_Mode\
    ;mptbladdr 0xC4B9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CarSpeedForRevLimitWithTBOff
    ;mptblcname RVLSPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 127 mph
    ;mptbldesc RVLSPD_defines_the_vehicle_speed_threshold_(20_mph)_that_transitions_between_stationary/neutral_rev_limiters_and_moving_in-gear_rev_limiters._Below_20_mph,_the_ECU_evaluates_low-speed_rev_limits;_above_20_mph,_the_vehicle_is_confirmed_driving_in_motion,_and_the_primary_high-speed_rev_limiter_engages._Stock_Setting:_0x14_(20_mph)._Launch_Control_Interlock:_Used_by_staging_rev_limiter_routines_to_determine_when_the_car_has_launched_off_the_line.
    .byte 0x14                       ;Point 1

	;.org	0xc56d
ACLRPM_DisableAcBelowThisRPM_500:
    ;mpgrp Utility\AC_Control\
    ;mptbladdr 0xC4BA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DisableAcBelowThisRPM_500
    ;mptblcname ACLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACLRPM_provides_an_emergency_anti-stall_cutout_for_the_air_conditioning_compressor_clutch_(calibrated_around_500_RPM_/_0xA2)._Anti-Stall_Protection:_Prevents_stalling_when_coming_to_a_panic_stop_with_the_A/C_on._Big_Camshaft_Lope:_If_an_aftermarket_camshaft_causes_idle_RPM_to_lope_deeply,_ensuring_ACLRPM_is_set_around_500_RPM_keeps_the_compressor_from_short-cycling_during_idle_loping.
    .byte 0xA2                       ;Point 1

	;.org	0xc56e
ACOUT_DeltaAboveMinThrottleToCutOutAc:
    ;mpgrp Utility\AC_Control\
    ;mptbladdr 0xC4BB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaAboveMinThrottleToCutOutAc
    ;mptblcname ACOUT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACOUT_is_the_Wide_Open_Throttle_(WOT)_A/C_cutout_threshold_(stock_calibration_=_133_counts_/_~2.60V_above_learned_idle_MINTHR)._Passing_Power:_Stock_value_0x85_cuts_the_A/C_at_~75%_throttle._Lowering_ACOUT_to_0x60_cuts_the_A/C_sooner_(at_~50%_throttle),_giving_a_sportier,_more_responsive_feel_during_mid-throttle_passing_maneuvers.
    .byte 0x85                       ;Point 1

	;.org	0xc56f
ACCTIM_AcDelayFromStartRunTransfer:
    ;mpgrp Utility\AC_Control\
    ;mptbladdr 0xC4BC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcDelayFromStartRunTransfer
    ;mptblcname ACCTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACCTIM_enforces_a_brief_delay_(stock_calibration_=_4_ticks_/_~0.4_sec)_following_engine_startup_before_the_ECU_allows_the_A/C_compressor_clutch_to_engage._Starter_Protection:_Retain_stock_setting._Gives_the_engine_time_to_establish_stable_combustion_before_absorbing_compressor_load.
    .byte 0x04                       ;Point 1

	;.org	0xc570
ACCRPM_DoNotAllowAcToEngageAboveThisRPM_4000:
    ;mpgrp Utility\AC_Control\
    ;mptbladdr 0xC4BD
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DoNotAllowAcToEngageAboveThisRPM_4000
    ;mptblcname ACCRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ACCRPM_provides_critical_mechanical_over-speed_protection_for_the_automotive_air_conditioning_compressor_(stock_calibration_=_0x3E80_=_4,000_RPM)._Compressor_Longevity:_Never_raise_ACCRPM_above_4,500_RPM._Spinning_a_factory_Sanden_or_Nippondenso_compressor_beyond_4,500_RPM_frequently_leads_to_thrown_compressor_belts,_seized_bearings,_or_blown_shaft_seals.
    .word 0x3E80                     ;Point 1

	;.org	0xc572
PURMAP_CannisterPurgeWhenBelowThisBaro:
    ;mpgrp Utility\Purge_Control\
    ;mptbladdr 0xC4BF
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname CannisterPurgeWhenBelowThisBaro
    ;mptblcname PURMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc PURMAP_establishes_the_intake_manifold_vacuum_threshold_(stock_calibration_=_0x05_/_~1.0_inHg_vacuum_below_baro)_required_to_energize_the_evaporative_emission_canister_purge_solenoid._Boost_Check_Valve_Integrity:_Turbo_cars_have_one-way_check_valves_on_the_canister_purge_line,_but_PURMAP_provides_software_protection_by_shutting_the_solenoid_off_before_manifold_pressure_reaches_atmospheric_zero.
    ;mpmapaxis y
    .byte 0x03                       ;Point 1

	;.org	0xc573
PURHYS_CannisterPurgeBaroHysteresis:
    ;mpgrp Utility\Purge_Control\
    ;mptbladdr 0xC4C0
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname CannisterPurgeBaroHysteresis
    ;mptblcname PURHYS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc PURHYS_provides_a_2-count_(~0.4_inHg)_hysteresis_deadband_for_canister_purge_control._When_driving_at_light_throttle_near_atmospheric_pressure,_manifold_vacuum_naturally_fluctuates_due_to_road_bumps_and_subtle_pedal_adjustments._Stock_Value:_0x02._Tuning_Usage:_Retain_stock_value._Ensures_quiet,_reliable_canister_purge_valve_operation.
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

	;.org	0xc574
WOTDLT_DeltaThrottleFrom_MINTHR_ToDetermineFullThrottle:
    ;mpgrp Setup\Throttle_Calibration\
    ;mptbladdr 0xC4C1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaThrottleFrom_MINTHR_ToDetermineFullThrottle
    ;mptblcname WOTDLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc WOTDLT_establishes_the_throttle_threshold_for_Wide_Open_Throttle_(WOT)_power_enrichment_and_open-loop_operation._Earlier_Power_Enrichment:_If_you_want_WOT_fueling_and_max_boost_to_engage_earlier_in_the_pedal_travel_(e.g._at_60%_throttle_for_a_more_responsive_feel),_reduce_WOTDLT_to_0x70_(~2.2V_above_idle).
    .byte 0x85                       ;Point 1

	;.org	0xc575
TPDLTF_TPSDeltaOverWOTDLTToDetermineWOT:
    ;mpgrp Setup\Throttle_Calibration\
    ;mptbladdr 0xC4C2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TPSDeltaOverWOTDLTToDetermineWOT
    ;mptblcname TPDLTF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc TPDLTF_is_a_high-speed_modifier_that_slightly_reduces_the_required_throttle_opening_threshold_(WOTDLT)_at_elevated_engine_speeds_inside_HandleO2Processing_MM._At_high_RPM,_engine_cylinder_air_ingestion_is_vastly_greater_than_at_low_speeds._A_throttle_plate_cracked_65%_open_flows_virtually_as_much_air_mass_as_100%_full_throttle._Stock_Value:_0x02._Tuning_Usage:_Retain_stock_setting._Works_automatically_in_tandem_with_WOTDLT.
    .byte 0x02                       ;Point 1

	;.org	0xc576
TMPLOW_OutOfRangeHotTooLowA2D:
    ;mpgrp Utility\On-Board_Diagnostics\Coolant_Temp_Sensor\
    ;mptbladdr 0xC4C3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OutOfRangeHotTooLowA2D
    ;mptblcname TMPLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc TMPLOW_defines_the_lower_electrical_voltage_limit_for_the_Engine_Coolant_Temperature_(ECT)_sensor_input._The_ECT_sensor_is_a_negative_temperature_coefficient_(NTC)_thermistor_supplied_by_an_internal_5V_pull-up_resistor_inside_the_ECU._Stock_Value:_0x1A_(~0.51V)._Diagnostics:_If_Code_22_is_present_and_live_scan_tool_data_shows_250_degF+,_inspect_the_coolant_sensor_harness_for_a_pinched_wire_touching_the_cylinder_head_or_exhaust_shield.
    .byte 0x1A                       ;Point 1

	;.org	0xc577
TMPHIG_OutOfRangeColdTooHighA2D:
    ;mpgrp Utility\On-Board_Diagnostics\Coolant_Temp_Sensor\
    ;mptbladdr 0xC4C4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OutOfRangeColdTooHighA2D
    ;mptblcname TMPHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc TMPHIG_establishes_the_upper_electrical_limit_for_the_Engine_Coolant_Temperature_sensor_input._Diagnostics:_If_the_radiator_cooling_fan_runs_at_full_speed_the_instant_the_key_is_turned_on,_and_Code_22_is_stored,_check_whether_the_two-pin_coolant_temperature_sensor_on_the_thermostat_housing_is_unplugged_or_has_corroded_connector_pins.
    .byte 0xFD                       ;Point 1

	;.org	0xc578
DEFTMP_DefaultEngineTemp:
    ;mpgrp Utility\On-Board_Diagnostics\Coolant_Temp_Sensor\
    ;mptbladdr 0xC4C5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DefaultEngineTemp
    ;mptblcname DEFTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DEFTMP_defines_the_safe,_middle-ground_fallback_coolant_temperature_(stock_calibration_=_0x95_/_~150_degF_/_65_degC)_used_by_the_ECU_whenever_the_coolant_temperature_sensor_is_unplugged_or_shorted_(Code_22)._Stock_Value:_0x95_(~150_degF)._Limp-Home_Behavior:_When_DEFTMP_is_active,_warm-up_enrichment_curves_and_closed-loop_O2_timers_operate_under_the_assumption_of_a_lukewarm_engine.
    .byte 0x95                       ;Point 1

	;.org	0xc579
CHGLOW_ChargeTempOutOfRangeLow:
    ;mpgrp Utility\On-Board_Diagnostics\Charge_Temp_Sensor\
    ;mptbladdr 0xC4C6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ChargeTempOutOfRangeLow
    ;mptblcname CHGLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CHGLOW_defines_the_lower_electrical_threshold_(stock_calibration_=_0x03_/_~0.06V)_for_the_Intake_Manifold_Air_Charge_Temperature_(ACT)_sensor._Like_the_coolant_sensor,_the_charge_temperature_sensor_is_an_NTC_thermistor_whose_voltage_drops_as_manifold_air_temperature_increases._Diagnostics:_If_Code_23_is_flagged,_check_the_wiring_harness_running_behind_the_intake_manifold_near_the_cylinder_head_for_abrasions.
    .byte 0x03                       ;Point 1

	;.org	0xc57a
CHGHIG_ChargeTempOutOfRangeHigh:
    ;mpgrp Utility\On-Board_Diagnostics\Charge_Temp_Sensor\
    ;mptbladdr 0xC4C7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ChargeTempOutOfRangeHigh
    ;mptblcname CHGHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CHGHIG_sets_the_upper_electrical_threshold_(stock_calibration_=_0xFE_/_~4.98V)_for_the_Intake_Manifold_Air_Charge_Temperature_sensor._Intercooler_Piping_/_Sensor_Relocation:_When_relocating_the_charge_temp_sensor_into_aftermarket_intercooler_plumbing,_ensure_the_sensor_body_or_harness_connector_makes_solid_contact._Disconnected_sensors_trigger_Code_23_immediately.
    .byte 0xFE                       ;Point 1

	;.org	0xc57b
DEFCHG_DefaultChargeTemp_Limpin:
    ;mpgrp Utility\On-Board_Diagnostics\Charge_Temp_Sensor\
    ;mptbladdr 0xC4C8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DefaultChargeTemp_Limpin
    ;mptblcname DEFCHG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DEFCHG_defines_the_fail-safe_default_air_charge_temperature_(stock_calibration_=_0xAD_/_~100_degF_/_38_degC)_substituted_into_ChargeTemp_whenever_the_intake_manifold_charge_temperature_sensor_circuit_fails_(Fault_Code_23)._Stock_Value:_0xAD_(~100_degF)._Non-Intercooled_vs_Intercooled:_On_non-intercooled_Turbo_I_cars_with_higher_baseline_manifold_temperatures,_DEFCHG_is_calibrated_slightly_warmer_(0xAD_/_~100_degF).
    .byte 0xAD                       ;Point 1

	;.org	0xc57c
AMBLOW_BattTempLowWhenHot:
    ;mpgrp Utility\On-Board_Diagnostics\Battery\
    ;mptbladdr 0xC4C9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BattTempLowWhenHot
    ;mptblcname AMBLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AMBLOW_establishes_the_lower_electrical_threshold_(stock_calibration_=_0x02_/_~0.04V)_for_the_ambient_battery_temperature_thermistor_located_beneath_the_battery_tray._Battery_Relocation_to_Trunk:_When_relocating_the_battery_to_the_trunk_in_performance_builds,_the_under-hood_sensor_is_often_disconnected_or_damaged,_triggering_Code_43._Tuners_can_install_a_10k-ohm_resistor_across_the_harness_pins_to_simulate_70_degF_or_disable_the_fault_in_ERMSK3.
    .byte 0x02                       ;Point 1

	;.org	0xc57d
AMBHIG_BattTempHighWhenCold:
    ;mpgrp Utility\On-Board_Diagnostics\Battery\
    ;mptbladdr 0xC4CA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BattTempHighWhenCold
    ;mptblcname AMBHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AMBHIG_establishes_the_upper_electrical_boundary_(stock_calibration_=_0xFD_/_~4.96V)_for_the_battery_temperature_thermistor._If_the_under-battery_sensor_is_unplugged,_the_internal_pull-up_resistor_pulls_the_circuit_to_5.0V_(>_AMBHIG)._Diagnostics:_A_continuous_Code_43_on_a_factory_restoration_typically_indicates_a_missing_battery_tray_sensor_or_corroded_harness_plug_beneath_the_tray.
    .byte 0xFD                       ;Point 1

	;.org	0xc57e
BTLRPM_LowBatteryVoltageAtThisRpm1500:
    ;mpgrp Utility\On-Board_Diagnostics\Battery\
    ;mptbladdr 0xC4CB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowBatteryVoltageAtThisRpm1500
    ;mptblcname BTLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc BTLRPM_sets_the_minimum_engine_speed_threshold_(stock_calibration_=_0x17_/_23_*_32_=_736_RPM)_required_to_qualify_oxygen_sensor_diagnostic_routines._Stock_Value:_0x17_(736_RPM)._Diagnostics:_Ensures_diagnostic_testing_runs_only_when_the_engine_is_sustaining_stable_running_idle.
    .byte 0x17                       ;Point 1

	;.org	0xc57f
CTLRPM_LowBatteryVoltageAtThisCoolantTemp:
    ;mpgrp Utility\On-Board_Diagnostics\Battery\
    ;mptbladdr 0xC4CC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowBatteryVoltageAtThisCoolantTemp
    ;mptblcname CTLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CTLRPM_specifies_the_minimum_engine_operating_temperature_(stock_calibration_=_0xCD_/_~195_degF_/_90_degC)_required_before_the_ECU_will_flag_oxygen_sensor_inactivity_(Fault_Code_21)._160_degF_/_180_degF_Thermostats:_If_running_a_160_degF_or_180_degF_thermostat,_coolant_temperature_may_never_reach_0xCD_(195_degF)!_As_a_result,_the_ECU_will_NEVER_run_O2_sensor_functional_diagnostics,_silently_suppressing_Code_21.
    .byte 0xCD                       ;Point 1

	;.org	0xc580
O2MNRT_MiniumRunTimeForO2SensorDiag:
    ;mpgrp Utility\On-Board_Diagnostics\
    ;mptbladdr 0xC4CD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MiniumRunTimeForO2SensorDiag
    ;mptblcname O2MNRT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc O2MNRT_defines_the_cumulative_running_time_delay_(stock_calibration_=_0xFF_/_255_ticks_/_~3.5_minutes)_that_must_elapse_after_engine_start_before_O2_sensor_functional_testing_is_permitted._Stock_Setting:_0xFF_(maximum_8-bit_timer_span)._Diagnostics:_Explains_why_Fault_Code_21_never_sets_immediately_upon_startup;_the_vehicle_must_be_driven_continuously_for_several_minutes_before_the_monitor_runs.
    .byte 0xFF                       ;Point 1

	;.org	0xc581
ERRRPM_RPMLimitforErrorCodeSetting:
    ;mpgrp Utility\On-Board_Diagnostics\Error_Code\
    ;mptbladdr 0xC4CE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimitforErrorCodeSetting
    ;mptblcname ERRRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc ERRRPM_provides_an_RPM_offset_(stock_calibration_=_0x0C_/_12_*_8_=_+96_RPM)_added_to_TargetIdleSpeed_HB_to_define_the_boundary_between_curb_idle_and_off-idle_driving_diagnostics_inside_VerifyOperationOfO2SensorAnd._Stock_Value:_0x0C_(+96_RPM)._Tuner_Usage:_Works_automatically_with_whatever_target_idle_speed_is_configured_in_AISPN.
    .byte 0x0C                       ;Point 1

	;.org	0xc582
ERRMPH_MPHLimitforErrorCodeSetting:
    ;mpgrp Utility\On-Board_Diagnostics\Error_Code\
    ;mptbladdr 0xC4CF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MPHLimitforErrorCodeSetting
    ;mptblcname ERRMPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc ERRMPH_defines_the_minimum_vehicle_cruising_speed_(stock_calibration_=_18_MPH_/_0x12)_required_to_evaluate_dynamic_vehicle_sensor_diagnostics._Code_15_Diagnostics:_If_a_digital_dash_conversion_or_broken_speedometer_cable_causes_Code_15,_the_code_is_only_logged_after_exceeding_18_MPH.
    .byte 0x12                       ;Point 1

	;.org	0xc583
ERRKON_KeyOnTimeLimitforErrorCodeSetting:
    ;mpgrp Utility\On-Board_Diagnostics\
    ;mptbladdr 0xC4D0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KeyOnTimeLimitforErrorCodeSetting
    ;mptblcname ERRKON
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc ERRKON_enforces_a_key-on_delay_period_(stock_calibration_=_128_ticks_/_~1.8_minutes)_before_the_ECU_permits_driving-mode_diagnostic_monitors_to_log_fault_codes_into_memory._Stock_Value:_0x80_(~1.8_minutes)._Diagnostics:_Guarantees_that_diagnostic_fault_codes_are_only_set_after_the_vehicle_has_been_running_steadily.
    .byte 0x80                       ;Point 1

	;.org	0xc584
THRLOW_ThrottleLowerLimit:
    ;mpgrp Utility\On-Board_Diagnostics\
    ;mptbladdr 0xC4D1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleLowerLimit
    ;mptblcname THRLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc THRLOW_sets_the_absolute_minimum_valid_electrical_voltage_(stock_calibration_=_0x08_/_~0.156V)_for_the_Throttle_Position_Sensor_(TPS)_signal_input._Throttle_Body_Swaps:_When_installing_an_aftermarket_throttle_body,_use_a_scan_tool_or_voltmeter_to_confirm_that_closed-throttle_TPS_voltage_rests_safely_between_0.65V_and_0.90V,_well_above_THRLOW_(0.16V).
    .byte 0x08                       ;Point 1

	;.org	0xc585
THRHIG_ThrottleUpperLimit:
    ;mpgrp Utility\On-Board_Diagnostics\
    ;mptbladdr 0xC4D2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleUpperLimit
    ;mptblcname THRHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc THRHIG_sets_the_maximum_valid_electrical_ceiling_(stock_calibration_=_0xF0_/_~4.70V)_for_the_Throttle_Position_Sensor_signal._Even_at_100%_wide_open_throttle,_physical_throttle_linkage_geometry_and_sensor_potentiometer_tracks_rarely_exceed_4.2V_-_4.5V._Aftermarket_High-Angle_Sensors:_Ensure_wide-open_throttle_voltage_does_not_hit_or_exceed_4.70V_on_custom_throttle_quadrant_linkages.
    .byte 0xF0                       ;Point 1

	;.org	0xc586
MPTHR_MapSwitchPointForFullThrottleOrIdle:
    ;mpgrp Utility\On-Board_Diagnostics\
    ;mptbladdr 0xC4D3
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MapSwitchPointForFullThrottleOrIdle
    ;mptblcname MPTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc MPTHR_is_an_emergency_fail-safe_threshold_(stock_calibration_=_0x68_/_~83_kPa_/_5_inHg_vacuum)_utilized_when_the_Throttle_Position_Sensor_has_suffered_an_electrical_failure_(Code_24)._Stock_Value:_0x68_(~83_kPa)._Brilliant_Chrysler_Fail-Safe:_Demonstrates_the_extraordinary_depth_of_Chrysler's_1980s_embedded_engine_control_software;_a_broken_TPS_does_not_strand_the_vehicle_or_prevent_turbo_boost.
    ;mpmapaxis y
    .byte 0x45                       ;Point 1

	;.org	0xc587
MAXCDH_MaximumCounterDistrubtorHalfwayforErrorCodeReset:
    ;mpgrp Utility\On-Board_Diagnostics\Error_Code\
    ;mptbladdr 0xC4D4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaximumCounterDistrubtorHalfwayforErrorCodeReset
    ;mptblcname MAXCDH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc MAXCDH_defines_the_ignition_distributor_pulse_counter_ceiling_(stock_calibration_=_16_pulses_/_0x10)_evaluated_inside_Throttle_MM._Stock_Setting:_0x10._Diagnostic_Self-Reset:_Explains_how_Chrysler_ECUs_automatically_clear_old_trouble_codes_after_a_fixed_number_of_successful_fault-free_driving_trips.
    .byte 0x10                       ;Point 1

	;.org	0xc588
DLTTHR_MinDeltaThrottleforErrorCodeReset:
    ;mpgrp Utility\On-Board_Diagnostics\Error_Code\
    ;mptbladdr 0xC4D5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinDeltaThrottleforErrorCodeReset
    ;mptblcname DLTTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc DLTTHR_specifies_the_minimum_dynamic_throttle_voltage_sweep_(stock_calibration_=_16_counts_/_~0.31V)_required_to_validate_sensor_health_during_automated_error_code_clearing._Stock_Value:_0x10_(~0.31V)._Clearing_Pending_Codes:_Depressing_the_throttle_smoothly_past_15-20%_during_normal_driving_satisfies_DLTTHR,_allowing_pending_codes_to_self-clear.
    .byte 0x10                       ;Point 1

	;.org	0xc589
MAXERT_MaximumEngineRunningTimeforErrorCodeReset:
    ;mpgrp Utility\On-Board_Diagnostics\Error_Code\
    ;mptbladdr 0xC4D6
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname MaximumEngineRunningTimeforErrorCodeReset
    ;mptblcname MAXERT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc MAXERT_defines_the_45-second_operational_time_window_(stock_calibration_=_0x002D_=_45_seconds)_following_engine_start_during_which_the_ECU_evaluates_automated_error_code_reset_conditions._Chrysler_engineers_designed_the_self-healing_error_reset_routine_to_run_early_in_the_drive_cycle._Stock_Value:_0x002D_(45_seconds)._16-Bit_Word:_Stored_as_a_2-byte_word_in_ROM.
    .word 0x002D                     ;Point 1

	;.org	0xc58b
MAPERR_MinMAPforErrorCodeReset:
    ;mpgrp Utility\On-Board_Diagnostics\Error_Code\
    ;mptbladdr 0xC4D8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinMAPforErrorCodeReset
    ;mptblcname MAPERR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc MAPERR_specifies_the_minimum_dynamic_manifold_pressure_change_(stock_calibration_=_2_ADC_counts_/_~1.6_kPa)_required_during_the_automated_error_code_self-clearing_routine_in_Throttle_MM._Stock_Value:_0x02._Diagnostic_Self-Reset:_Explains_why_blipping_the_throttle_during_a_road_test_often_turns_off_a_pending_Check_Engine_light_after_fixing_a_disconnected_vacuum_line.
    .byte 0x02                       ;Point 1

	;.org	0xc58c
MAPLOW_MapSensorLowerLimit:
    ;mpgrp Utility\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0xC4D9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapSensorLowerLimit
    ;mptblcname MAPLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MAPLOW_defines_the_absolute_minimum_electrical_voltage_boundary_(stock_calibration_=_0x01_/_~0.02V)_for_the_Manifold_Absolute_Pressure_(MAP)_sensor_input._Code_14_Diagnosis:_If_Code_14_is_present_and_scan_tool_reads_0.0V,_inspect_the_3-pin_MAP_sensor_connector_for_water_intrusion,_corrosion,_or_a_broken_5V_supply_wire.
    .byte 0x01                       ;Point 1

	;.org	0xc58d
MAPHIG_MapSensorUpperLimit:
    ;mpgrp Utility\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0xC4DA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapSensorUpperLimit
    ;mptblcname MAPHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MAPHIG_establishes_the_maximum_valid_electrical_ceiling_(stock_calibration_=_0xFC_/_~4.94V)_for_the_MAP_sensor._3-Bar_MAP_Sensor_Calibration:_When_installing_a_3-Bar_MAP_sensor,_ensure_wiring_polarity_is_correct._If_the_sensor_ground_pin_is_improperly_pinned,_signal_voltage_will_float_at_5.0V,_instantly_triggering_Code_14_and_engine_cutout.
    .byte 0xFC                       ;Point 1

	;.org	0xc58e
DFTOC2_SomeKindOfDefaultValueForOCR2:
    ;mpgrp Utility\On-Board_Diagnostics\
    ;mptbladdr 0xC4DB
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname SomeKindOfDefaultValueForOCR2
    ;mptblcname DFTOC2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc DFTOC2_is_a_16-bit_hardware_timer_reload_constant_(stock_calibration_=_0x07D0_=_2,000_clock_cycles_/_~2.0_milliseconds)_loaded_into_the_Motorola_6803_CPU's_internal_Output_Compare_Register_2_(OCR2)._Fixed_Architecture_Constant:_DO_NOT_MODIFY._Changing_DFTOC2_alters_the_master_CPU_hardware_timer_interrupt_cadence,_disrupting_injector_pulse_timing_and_ignition_dwell_accuracy_globally.
    .word 0x07D0                     ;Point 1

; 	;.org	0xc590
L3634:
    ;mpgrp Utility\On-Board_Diagnostics\
    ;mptbladdr 0xC4DD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname L3634
    ;mptblcname L3634
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc L3634_is_a_preserved_Chrysler_engineering_calibration_constant_residing_at_address_$12FC_in_the_setup_and_configuration_table_structure._Maintained_across_Chrysler_2.2L/2.5L_Turbo_Logic_Module_binaries_to_preserve_exact_byte-for-byte_binary_offset_alignment_between_calibration_tables_and_executable_machine_code_routines._Tuning_Usage:_Retain_stock_factory_value_(0x0F).
    .byte 0x0F                       ;Point 1

	;.org	0xc591
BF80PL_BF80PowerLossLightMask:
    ;mpgrp Utility\On-Board_Diagnostics\
    ;mptbladdr 0xC4DE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BF80PowerLossLightMask
    ;mptblcname BF80PL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc BF80PL_is_an_8-bit_diagnostic_trigger_mask_(stock_calibration_=_0xDB_/_binary_11011011)_evaluated_inside_WorkWithPowerLossLight_MM._Suppressing_Nuisance_CEL_Lights:_Tuners_creating_custom_engine_swaps_or_standalone_configurations_can_clear_specific_bits_in_BF80PL_to_prevent_secondary_status_flags_from_turning_on_the_Check_Engine_light.
    .byte 0xDB                       ;Point 1

	;.org	0xc592
FUELTR_FuelMonitorConversionFactor:
    ;mpgrp Utility\On-Board_Diagnostics\
    ;mptbladdr 0xC4DF
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname FuelMonitorConversionFactor
    ;mptblcname FUELTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc FUELTR_(stock_0x0311_=_785)_calibrates_the_fuel_consumption_signal_sent_from_the_ECU_to_the_dashboard_Electronic_Navigator_/_trip_computer._When_installing_larger_fuel_injectors,_scale_FUELTR_upward_proportionally_to_your_injector_flow_increase_so_MPG_and_distance-to-empty_readings_remain_accurate.
    ;mpinjscale word
    .word 0x0492                     ;Point 1

	;.org	0xc594

	;.org	0xc5a0
TMPTL1_TempForColdScaleFromA2D:
    ;mpgrp Setup\Transfer_Functions\
    ;mptbladdr 0xC4E1
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempForColdScaleFromA2D
    ;mptblcname TMPTL1
    ;mpxaxis raw 0 255 scale
    ;mpyaxis Coolant_Temperature -200 260 F
    ;mptbldesc TMPTL1_is_the_primary_non-linear_analog_transfer_lookup_table_that_translates_raw_8-bit_ADC_voltages_from_the_Engine_Coolant_Temperature_(ECT)_sensor_into_engineering_temperature_units_when_operating_on_the_cold_temperature_range._Automotive_coolant_thermistors_have_severe_exponential_resistance_curves_(hundreds_of_thousands_of_ohms_when_freezing,_dropping_to_a_few_hundred_ohms_when_boiling).
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0xC9, 0xFF, 0xA2     ;Point 1
    .byte 0xD7, 0x7A, 0xFF, 0x0D     ;Point 2
    .byte 0xFF, 0x54                 ;Point 3

	;.org	0xc5ab
TMPTL2_TempForHotScaleA2D:
    ;mpgrp Setup\Transfer_Functions\
    ;mptbladdr 0xC4EC
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempForHotScaleA2D
    ;mptblcname TMPTL2
    ;mpxaxis raw 0 255 scale
    ;mpyaxis Coolant_Temperature -200 260 F
    ;mptbldesc TMPTL2_is_the_companion_transfer_lookup_table_to_TMPTL1,_dedicated_to_measuring_engine_coolant_temperature_during_normal_warm_running_and_high-temperature_conditions_(140_degF_to_260_degF+)._Radiator_Fan_&_Overheat_Accuracy:_Because_normal_operating_temperature_(180_degF_-_210_degF)_resides_entirely_on_TMPTL2,_accurate_calibration_of_this_curve_is_vital_for_proper_radiator_fan_cycling_(FANTM1,_FANTM2)_and_hot_spark_retard_(HOTSPK).
    .byte 0x02                       ;Number of points in table
    .byte 0x40, 0xFF, 0xFF, 0x72     ;Point 1
    .byte 0xFF, 0x95                 ;Point 2

	;.org	0xc5b2
CHGTL1_TempForChargeTempA2D:
    ;mpgrp Setup\Transfer_Functions\
    ;mptbladdr 0xC4F3
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempForChargeTempA2D
    ;mptblcname CHGTL1
    ;mpxaxis raw 0 255 scale
    ;mpyaxis Coolant_Temperature -200 260 F
    ;mptbldesc CHGTL1_is_the_4-point_2D_transfer_curve_that_converts_analog_voltage_from_the_Intake_Manifold_Air_Charge_Temperature_(ACT)_sensor_into_calibrated_temperature_units_(ChargeTemp)._Aftermarket_Fast-Response_Thermistors:_Standard_factory_Chrysler_ACT_sensors_are_brass-encapsulated_and_have_significant_thermal_inertia._Many_tuners_upgrade_to_open-element_GM_or_Bosch_air_temp_sensors_for_instant_boost_temperature_tracking.
    .byte 0x04                       ;Number of points in table
    .byte 0x0E, 0xFF, 0xFE, 0x43     ;Point 1
    .byte 0x29, 0xD0, 0xFF, 0x8D     ;Point 2
    .byte 0xE3, 0x7C, 0xFE, 0x70     ;Point 3
    .byte 0xFA, 0x58                 ;Point 4

	;.org	0xc5c1
LMPINN_LimpinTableForMapFromThrottle:
    ;mpgrp Utility\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0xC502
    ;mptbltype 10
    ;mpsubtype 1
    ;mptbllname LimpinTableForMapFromThrottle
    ;mptblcname LMPINN
    ;mpxaxis TPS 0 255 tps
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc LMPINN_is_Chrysler's_legendary_emergency_Alpha-N_limp-home_table._Limp-Home_Drivability_with_Blown_MAP_Hoses:_If_a_silicone_vacuum_hose_blows_off_the_MAP_sensor_at_the_racetrack,_LMPINN_allows_you_to_drive_the_car_back_to_the_pits_under_its_own_power._Large_Throttle_Bodies:_If_running_an_oversized_58mm_throttle_body,_raising_the_lower_points_of_LMPINN_provides_smoother_limp-home_off-idle_recovery.
    ;mpmapaxis y
    .byte 0x00                   ;Point 1
    .word 0x0000, 0x0190
    .byte 0x10                   ;Point 2
    .word 0x0019, 0x0125
    .byte 0x17                   ;Point 3
    .word 0x0021, 0x00E9
    .byte 0x22                   ;Point 4
    .word 0x002B, 0x00A8
    .byte 0x45                   ;Point 5
    .word 0x0042, 0x0000
    .byte 0xFF

	;.org	0xc5db
MPLMOF_OffsetForCalcMapInMapLimpin:
    ;mpgrp Utility\On-Board_Diagnostics\MAP_Sensor\
    ;mptbladdr 0xC51C
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OffsetForCalcMapInMapLimpin
    ;mptblcname MPLMOF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc MPLMOF_defines_the_baseline_manifold_pressure_offset_(stock_calibration_=_0x20_/_~25_kPa_/_~22_inHg_vacuum)_added_to_the_synthetic_pressure_looked_up_from_LMPINN_during_MAP_sensor_failure_mode._Stock_Value:_0x20_(~25_kPa)._Camshaft_Tuning:_If_running_a_camshaft_that_idles_with_less_vacuum_(e.g._45_kPa_/_16_inHg),_raising_MPLMOF_to_0x30_(~38_kPa)_prevents_the_engine_from_idling_overly_lean_if_the_MAP_sensor_fails.
    ;mpmapaxis y
    .byte 0x15                       ;Point 1

	;.org	0xc5dc
MAPMULT_ScaleMAPVoltsToPresMultiplyConst:
    ;mpgrp Setup\Transfer_Functions\
    ;mptbladdr 0xC51D
    ;mptbltype 8
    ;mpsubtype 1
    ;mptbllname ScaleMAPVoltsToPresMultiplyConst
    ;mptblcname MAPMULT
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc MAPMULT_is_the_foundational_slope_multiplier_in_the_mathematical_transfer_function_that_converts_analog_MAP_sensor_voltage_(MapVolts)_into_calibrated_internal_pressure_units_(MapValue)._3-Bar_MAP_Sensor_Conversion_Guide:_For_Mopar_2-Bar_(Stock):_Set_MAPMULT_=_0x07,_MAPADD_=_0x0361._For_Mopar_Super_60_3-Bar:_Set_MAPMULT_=_0x09,_MAPADD_=_0x0700.
    ;mpchoices 1.0_Bar 07 1.5_Bar 07 2.0_Bar 07 2.5_Bar 08 3.0_Bar 09 3.5_Bar 09 4.0_Bar 09 4.5_Bar 09
    ;mpmapaxis b
    .byte 0x09                       ;Point 1

	;.org	0xc5dd
MAPADD_ScaleMAPVoltsToPresAddConst:
    ;mpgrp Setup\Transfer_Functions\
    ;mptbladdr 0xC51E
    ;mptbltype 8
    ;mpsubtype 1
    ;mptbllname ScaleMAPVoltsToPresAddConst
    ;mptblcname MAPADD
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc MAPADD_is_the_16-bit_zero-offset_/_intercept_constant_added_to_the_scaled_product_of_MAPVolts_*_MAPMULT_inside_ConvertMAPVoltsToValue._Fine-Tuning_MAP_Accuracy:_When_verifying_MAP_sensor_calibration_with_a_hand_vacuum_pump_and_MPTune_live_data_display:_If_atmospheric_pressure_reads_29.9_inHg_but_live_scan_data_reads_28.5_inHg_(offset_error_across_all_points),_trim_MAPADD_upward_or_downward_by_a_few_counts_to_zero_the_sensor_perfectly.
    ;mpchoices 1.0_Bar 0361 1.5_Bar 0361 2.0_Bar 0361 2.5_Bar 0700 3.0_Bar 0700 3.5_Bar 0700 4.0_Bar 0700 4.5_Bar 0700
    ;mpmapaxis w
    .word 0x0700                     ;Point 1

	;.org	0xc5df
VACREG_CruiseControlVacRegularGainGurve_FromDeltaSpeed:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0xC520
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlVacRegularGainGurve_FromDeltaSpeed
    ;mptblcname VACREG
    ;mpxaxis Delta_Speed 0 127 mph
    ;mpyaxis AccRate 0 5 mph/sec
    ;mptbldesc VACREG_defines_the_primary_proportional_vacuum_servo_gain_curve_used_by_the_cruise_control_system_under_steady-state_cruising._Speed_Droop_on_Hills:_If_the_vehicle_loses_2-4_MPH_on_highway_hills_before_recovering,_increase_the_upper_points_of_VACREG_to_command_more_aggressive_vacuum_pull.
    .byte 0x05                       ;Number of points in table
    .byte 0x00, 0x00, 0x00, 0x60     ;Point 1
    .byte 0x10, 0x06, 0x00, 0x20     ;Point 2
    .byte 0x40, 0x0C, 0x00, 0x10     ;Point 3
    .byte 0x80, 0x10, 0x00, 0x11     ;Point 4
    .byte 0xFF, 0x18                 ;Point 5

	;.org	0xc5f2
VACACC_CruiseControlVacAcceleratedGainCurve_FromDeltaSpeed:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0xC533
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlVacAcceleratedGainCurve_FromDeltaSpeed
    ;mptblcname VACACC
    ;mpxaxis Delta_Speed 0 127 mph
    ;mpyaxis AccRate 0 5 mph/sec
    ;mptbldesc VACACC_defines_the_high-gain_vacuum_servo_pulse_curve_activated_during_large_speed_errors_or_when_resuming_vehicle_speed._Resume_Sluggishness:_If_resuming_from_45_MPH_to_65_MPH_feels_lethargic,_increase_the_gain_values_in_VACACC._Resume_Overshoot:_If_the_car_aggressively_overshoots_the_set_speed_upon_resuming_(e.g._climbing_to_72_MPH_before_settling_back_to_65_MPH),_reduce_VACACC_slope.
    .byte 0x02                       ;Number of points in table
    .byte 0x00, 0x18, 0x00, 0x00     ;Point 1
    .byte 0xC0, 0x30                 ;Point 2

	;.org	0xc5f9
VENTRG_CruiseControlVentRegularGainCurve_FromDeltaSpeed:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0xC53A
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlVentRegularGainCurve_FromDeltaSpeed
    ;mptblcname VENTRG
    ;mpxaxis Delta_Speed 0 127 mph
    ;mpyaxis AccRate 0 5 mph/sec
    ;mptbldesc VENTRG_establishes_the_vent_solenoid_pulse_duration_gain_curve_used_to_bleed_vacuum_from_the_cruise_servo_when_vehicle_speed_exceeds_the_set_target._Downhill_Speed_Creep:_If_the_vehicle_gains_significant_speed_on_downhill_stretches_with_cruise_engaged,_increase_VENTRG_values_to_vent_vacuum_more_aggressively.
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x00, 0xFF, 0xC0     ;Point 1
    .byte 0x10, 0xFC, 0xFF, 0xE5     ;Point 2
    .byte 0x80, 0xF0                 ;Point 3

	;.org	0xc604
SETPW_CruiseControlSetupPulseForSet_FromSpeed:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0xC545
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlSetupPulseForSet_FromSpeed
    ;mptblcname SETPW
    ;mpxaxis Speed 0 128 mph
    ;mpyaxis Vacuum 0 2.8 Pulsewidth
    ;mptbldesc SETPW_determines_the_initial_"setup_pulse"_duration_applied_to_the_vacuum_servo_the_instant_the_driver_presses_the_"SET"_button._Set-Speed_Sag_/_Dip:_If_releasing_the_accelerator_pedal_right_after_hitting_SET_causes_the_car_to_momentarily_sag_or_lose_1-2_MPH,_increase_SETPW_at_that_speed._Set-Speed_Surge:_If_the_car_surges_forward_with_unexpected_acceleration_when_tapping_SET,_reduce_SETPW.
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x00, 0x00, 0x00     ;Point 1
    .byte 0x3C, 0x14, 0x00, 0x33     ;Point 2
    .byte 0xAA, 0x2A                 ;Point 3

	;.org	0xc60f
RESTBL_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0xC550
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference
    ;mptblcname RESTBL
    ;mpxaxis Speed 0 128 mph
    ;mpyaxis Raw 0 255 count
    ;mptbldesc RESTBL_specifies_an_additional_vacuum_setup_pulse_added_to_the_base_setup_pulse_when_the_driver_engages_"RESUME"._Resume_Hesitation:_If_tapping_Resume_produces_an_initial_hesitation_before_the_car_begins_accelerating,_increase_RESTBL._Resume_Kick:_If_hitting_Resume_causes_an_uncomfortably_sharp_jerk_of_the_throttle,_decrease_the_lower_slope_of_RESTBL.
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x00, 0x00, 0x80     ;Point 1
    .byte 0x14, 0x0A, 0x00, 0x1C     ;Point 2
    .byte 0x6E, 0x14                 ;Point 3

	;.org	0xc61e
THGAIN_CruiseControlThrottleGainFactor_FromThrottle:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0xC55B
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlThrottleGainFactor_FromThrottle
    ;mptblcname THGAIN
    ;mpxaxis TPS 0 255 tps
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc THGAIN_provides_a_nonlinear_gain_correction_factor_applied_to_cruise_servo_duty_cycle_based_on_the_current_throttle_opening_angle._Large_Throttle_Bodies:_Aftermarket_52mm_or_58mm_throttle_bodies_flow_significantly_more_air_at_small_throttle_angles_than_the_stock_48mm_unit._Flattening_or_reducing_THGAIN_at_low_throttle_prevents_cruise_control_twitchiness_with_oversized_throttle_bodies.
    .byte 0x02                       ;Number of points in table
    .byte 0x00, 0x08, 0x00, 0x00     ;Point 1
    .byte 0x02, 0x12                 ;Point 2

	;.org	0xc629
SPGAIN_CruiseControlSpeedGainFactor_FromSpeed:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0xC562
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlSpeedGainFactor_FromSpeed
    ;mptblcname SPGAIN
    ;mpxaxis Speed 0 128 mph
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc SPGAIN_adjusts_the_overall_cruise_control_servo_gain_as_a_function_of_vehicle_road_speed._Aerodynamic_drag_increases_with_the_square_of_vehicle_speed_(_F_drag_proportional_to_v^2_)._High-Speed_Sluggishness:_If_cruise_holds_speed_crisply_at_45_MPH_but_feels_soft_and_unresponsive_at_75_MPH,_increase_SPGAIN_at_higher_road_speeds._Low-Speed_Twitch:_If_cruise_feels_jumpy_at_35-40_MPH,_ensure_SPGAIN_gain_is_calibrated_lower_in_the_lower_speed_range.
    .byte 0x02                       ;Number of points in table
    .byte 0x32, 0x20, 0xFF, 0x5D     ;Point 1
    .byte 0x64, 0x00                 ;Point 2

	;.org	0xc634
VNTAB1_CruiseControlLimitToAMaxVent:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0xC569
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlLimitToAMaxVent
    ;mptblcname VNTAB1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc VNTAB1_defines_the_maximum_allowable_pulse_width_duration_limit_for_the_cruise_control_vent_solenoid._Factory_Setting:_Stock_value_is_0x70_(112_counts)._Retain_stock_setting_for_factory_vacuum_actuator_diaphragms._Lightweight_Actuators:_If_using_an_aftermarket_or_smaller_vacuum_servo_actuator_that_vents_faster_than_stock,_reducing_VNTAB1_prevents_harsh_throttle_closing.
    .byte 0x70                       ;Point 1

	;.org	0xc635
VNTAB2_CruiseControlLimitToHalfMaxVent:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0xC56A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlLimitToHalfMaxVent
    ;mptblcname VNTAB2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc VNTAB2_sets_a_intermediate_threshold_used_to_restrict_vent_solenoid_pulses_to_half-maximum_under_mild_overspeed_conditions._Hunting_Around_Crests:_If_the_car_consistently_over-corrects_when_cresting_small_rolling_highway_hills_(venting_too_hard_and_then_surging_to_catch_back_up),_lower_VNTAB2_slightly_to_smooth_out_intermediate_venting.
    .byte 0x50                       ;Point 1

	;.org	0xc636
SETIME_CruiseControlNoSetupPulseWhenDecelTimerAboveThis:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0xC56B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlNoSetupPulseWhenDecelTimerAboveThis
    ;mptblcname SETIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SETIME_establishes_the_upper_timer_limit_for_inhibiting_the_initial_vacuum_setup_pulse_during_vehicle_deceleration._If_the_driver_has_been_holding_down_the_"COAST_/_DECEL"_cruise_switch_button_and_releases_it_to_set_a_new_lower_cruise_speed,_the_vehicle_is_actively_decelerating._Coast-to-Set_Behavior:_Retain_stock_setting_(0x37)._Ensures_smooth_deceleration_transitions_without_pedal_kickback_when_tapping_coast.
    .byte 0x37                       ;Point 1

	;.org	0xc637
SETIM1_CruiseControlNoSetupPulseWhenDecelTimerBelowThis:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0xC56C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlNoSetupPulseWhenDecelTimerBelowThis
    ;mptblcname SETIM1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SETIM1_sets_the_lower_timer_boundary_for_cruise_control_deceleration_pulse_qualification._In_conjunction_with_SETIME,_SETIM1_establishes_a_precise_timing_window_used_by_the_cruise_state_machine_to_verify_how_long_the_driver_held_the_Coast_button_before_releasing_it._Stock_Value:_Factory_setting_is_0x5B._Modification_is_rarely_required_unless_custom_non-factory_cruise_switch_stalks_with_unusual_switch_debounce_timings_are_installed.
    .byte 0x5B                       ;Point 1

	;.org	0xc638
ACLRST_CruiseControlDeltaSpeedToResetAccFlag:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0xC56D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlDeltaSpeedToResetAccFlag
    ;mptblcname ACLRST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaSpeed 0 127 mph
    ;mptbldesc ACLRST_defines_the_speed_error_delta_threshold_below_which_the_ECU_disengages_accelerated_cruise_gain_mode_and_returns_to_regular_steady-state_gain_mode._Resume_Overshoot:_If_the_vehicle_consistently_overshoots_set_speed_when_resuming,_increase_ACLRST_to_e.g._0x07_or_0x08_(3.5_-_4.0_MPH)._This_forces_the_controller_to_drop_out_of_accelerated_gain_earlier_and_settle_smoothly.
    .byte 0x05                       ;Point 1

	;.org	0xc639
CLOTHR_CruiseControlDontVentIfThrottleBelowThis:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0xC56E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlDontVentIfThrottleBelowThis
    ;mptblcname CLOTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc CLOTHR_specifies_the_minimum_throttle_angle_floor_below_which_the_cruise_vent_solenoid_is_completely_inhibited_from_firing._TPS_Zero_Calibration:_If_you_install_an_aftermarket_throttle_body_and_TPS_sensor_where_idle_voltage_sits_slightly_higher_than_stock_(e.g._0.95V_vs_stock_0.85V),_increase_CLOTHR_slightly_to_ensure_the_ECU_knows_when_the_throttle_has_reached_its_physical_mechanical_stop.
    .byte 0x03                       ;Point 1

	;.org	0xc63a
MAXTHR_CruiseControlDontVacIfThrottleAboveThis:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0xC56F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlDontVacIfThrottleAboveThis
    ;mptblcname MAXTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MAXTHR_establishes_the_maximum_throttle_angle_ceiling_allowed_under_cruise_control_operation._Steep_Mountain_Grades:_In_hilly_terrain,_if_the_car_loses_speed_on_steep_grades_because_cruise_stops_pulling_at_~30%_throttle,_tuners_can_raise_MAXTHR_to_0x60_or_0x70_to_give_the_cruise_system_more_authority_to_hold_speed._Safety_Margin:_Do_not_raise_MAXTHR_all_the_way_to_100%_(WOT).
    .byte 0x50                       ;Point 1

	;.org	0xc63b
MAXSET_CruiseControlMaxSetSpeedTimesTwo:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0xC570
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlMaxSetSpeedTimesTwo
    ;mptblcname MAXSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 128 MPH
    ;mptbldesc MAXSET_enforces_the_maximum_legal_road_speed_at_which_the_cruise_control_system_is_permitted_to_be_engaged._Extended_Highway_Cruising:_For_western_US_states_or_track_transport_where_legal_speed_limits_reach_80_MPH,_drivers_wanting_to_cruise_at_85-90_MPH_can_raise_MAXSET_to_0xBE_(95_MPH)_or_0xC8_(100_MPH)._Speed_Clamping:_If_vehicle_speed_exceeds_MAXSET_during_an_acceleration_tap,_set_speed_clamps_at_MAXSET_/_2.
    .byte 0xAA                       ;Point 1

	;.org	0xc63c
MINSET_CruiseControlMinSetSpeedTimesTwo:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0xC571
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlMinSetSpeedTimesTwo
    ;mptblcname MINSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 128 MPH
    ;mptbldesc MINSET_defines_the_minimum_low-speed_cutoff_threshold_for_cruise_control_operation._Cruise_control_is_strictly_designed_for_highway_and_open-road_use._Using_cruise_control_in_city_traffic,_school_zones,_or_residential_areas_represents_a_significant_safety_hazard._Factory_Setting:_30_MPH_is_the_standard_factory_minimum_set_speed._It_is_strongly_recommended_to_keep_MINSET_at_stock_0x3C_(30_MPH)_for_public_road_safety.
    .byte 0x3C                       ;Point 1

	;.org	0xc63d
SCNVHI_CruiseControlForBrakeFlagManualTransmissionClutchDisable:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0xC572
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlForBrakeFlagManualTransmissionClutchDisable
    ;mptblcname SCNVHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SCNVHI_defines_the_upper_analog_voltage_threshold_used_to_detect_brake_pedal_application_or_manual_transmission_clutch_pedal_depression._Clutch_/_Brake_Switch_Calibration:_If_cruise_disengages_intermittently_over_highway_bumps,_inspect_switch_alignment_at_the_pedal_bracket_before_altering_calibration_constants._Automatic_vs_Manual_Conversion:_Crucial_calibration_parameter_when_converting_an_automatic_wiring_harness_to_manual_transmission.
    .byte 0xF1                       ;Point 1

	;.org	0xc63e
SCNVLO_CruiseControlForBrakeFlagManualTransmissionClutchDisable:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0xC573
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlForBrakeFlagManualTransmissionClutchDisable2
    ;mptblcname SCNVLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc SCNVLO_defines_the_lower_analog_voltage_threshold_of_the_brake/clutch_safety_cutout_window._In_tandem_with_SCNVHI,_SCNVLO_forms_a_noise-immune_voltage_comparator_window._Circuit_Diagnostics:_If_cruise_refuses_to_engage_at_all,_measure_the_voltage_on_the_brake/clutch_sense_pin._It_must_rest_within_the_window_between_SCNVLO_and_SCNVHI_when_pedals_are_untouched.
    .byte 0x52                       ;Point 1

	;.org	0xc63f
LOSPCO_CruiseControlLowSpeedCutoutSpeed:
    ;mpgrp Utility\Cruise_Control\
    ;mptbladdr 0xC574
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname CruiseControlLowSpeedCutoutSpeed
    ;mptblcname LOSPCO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LOSPCO_establishes_the_absolute_low-speed_safety_cutout_threshold_(approx_25_MPH)_below_which_active_cruise_control_will_automatically_disengage_and_shut_down._Safety_Mechanism:_Never_disable_or_drastically_lower_this_threshold._It_is_an_essential_failsafe_preventing_the_cruise_actuator_from_holding_the_throttle_open_at_very_low_parking_lot_or_stop-and-go_speeds.
    .word 0x0640                     ;Point 1

AISTEP_BitPatternForAisControl:
    ;mpgrp Setup\Transfer_Functions\
    ;mptbladdr 0xC576
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname BitPatternForAisControl
    ;mptblcname AISTEP
    ;mpxaxis in_desc 4 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AISTEP_is_the_hardware_commutation_table_(4_bytes:_0x06,_0x0A,_0x09,_0x05)_that_defines_the_sequential_magnetic_coil_excitation_patterns_for_the_Automatic_Idle_Speed_bipolar_stepper_motor._The_Chrysler_AIS_actuator_contains_two_independent_stator_windings._Fixed_Hardware_Driver_Table:_NEVER_MODIFY.
    .byte 0x43                       ;Point 1
    .byte 0x4F                       ;Point 2
    .byte 0x50                       ;Point 3
    .byte 0x52                       ;Point 4

RVLSPS_Staging:
    ;mpgrp Turbonator_Features\Staging_Limiter\
    ;mptbladdr 0xC57A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname VehicleSpeedForRevLimit-Staging
    ;mptblcname RVLSPS
    ;mpxaxis X 0 255 in
    ;mpyaxis Speed 0 255 mph
    ;mptbldesc RVLSPS_defines_the_vehicle_speed_cutoff_threshold_for_the_Turbonator_2-step_staging_launch_rev_limiter._Drag_Launch_Optimization:_Stock_value_of_4_MPH_(0x04)_works_exceptionally_well_for_both_slicks_and_street_tires,_ensuring_the_limiter_does_not_cut_fuel_down-track_if_wheelspin_occurs._Speed_Sensor_Prerequisite:_Requires_a_functioning_vehicle_distance/speed_sensor_(VSS).
    .byte 0x04                       ;Point 1
REVLMTX_StagingModFuelShutoff:
    ;mpgrp Turbonator_Features\Staging_Limiter\
    ;mptbladdr 0xC57B
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname OverRevFuelShutoffStagingLower
    ;mptblcname REVLMTX
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc REVLMTX_defines_the_primary_engine_speed_setpoint_for_the_Turbonator_2-step_staging_launch_limiter._Launch_Boost_vs._Traction:_Calibrate_REVLMTX_based_on_tire_compound_and_track_prep._Street_radial_tires_typically_launch_best_around_3,200_-_3,500_RPM_to_avoid_excessive_wheel_hop._Drag_slicks_on_a_prepped_track_can_launch_at_4,000_-_4,500_RPM_for_maximum_boost_off_the_line.
    .word 0x271D                     ;Point 1
REVLMTX2_StagingModFuelShutoff:
    ;mpgrp Turbonator_Features\Staging_Limiter\
    ;mptbladdr 0xC57D
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname OverRevFuelShutoffStagingUpper
    ;mptblcname REVLMTX2
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc REVLMTX2_establishes_the_secondary_hysteresis_recovery_threshold_for_the_Turbonator_2-step_staging_limiter._Limiter_Cadence:_Spacing_REVLMTX_and_REVLMTX2_by_roughly_150-200_RPM_creates_a_rapid,_machine-gun_stutter_on_the_2-step,_ideal_for_building_consistent_manifold_boost._Synchronized_Tuning:_Always_adjust_REVLMTX2_proportionally_whenever_REVLMTX_is_moved_to_a_new_launch_RPM.
    .word 0x26F8                     ;Point 1
    
RVLSWS_StagingLimiterSwitchSelect:
    ;mpgrp Turbonator_Features\Staging_Limiter\
    ;mptbladdr 0xC57F
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname StagingLimiterSwitchSelect
    ;mptblcname RVLSWS
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc RVLSWS_selects_the_physical_hardware_switch_input_used_to_arm_and_activate_the_Turbonator_2-step_staging_launch_limiter._Manual_Transmission_(Clutch_Switch):_Leave_at_default_0x08._The_2-step_arms_when_staged_with_the_clutch_depressed,_and_disengages_the_instant_the_clutch_pedal_begins_releasing.
    ;mpchoices Cruise_Set(Momentary)  Cruise_Resume(Momentary)  A/C_Clutch_Input(Do_Not_Use)  Brake_Pedal_Switch  P/N_Switch  Nothing(Do_Not_Use)  Cruise_On/Off  Dist_Sync(Do_Not_Use)
    .byte 0x08                       ;Point 1
rvl_DistSync 		= $%10000000	; Distributor Sync
rvl_CruiseOnOff 	= $%01000000	; Cruise On/Off
rvl_B1Volt		= $%00100000	; B1 Voltage Sense (not sure, maybe nothing)
rvl_PNswitch  		= $%00010000	; Park/Neutral switch
rvl_Brake  		= $%00001000	; Brake Switch
rvl_ACclutch  		= $%00000100	; A/C Clutch input
rvl_CruiseResume 	= $%00000010	; Cruise Resume
rvl_CruiseSet 		= $%00000001	; Cruise Set
      
        ; 35    x80     7   dist sync           B17
        ; 36    x40     6   cruise enable       B15
        ; 37    x20     5                       B14
        ; 38    x10     4   brake               B13
        ; 39    x08     3   park/neutral        B12
        ; 1     x04     2   ac clutch in        B11
        ; 2     x02     1   cruise resume       B10
        ; 3     x01     0   cruise set          B9

ANTLAG_AntiLagRetardfromBoostTargetDelta:
    ;mpgrp Spark\Anti-Lag_Retard\
    ;mptbladdr 0xC580
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AntiLagRetardfromBoostGoalDelta
    ;mptblcname ANTLAG
    ;mpxaxis DeltaMAP 0 44.1 psi
    ;mpyaxis Spark_Retard 0 16 Degrees
    ;mptbldesc ANTLAG_is_the_lookup_table_for_the_Turbonator_Launch_Control_/_Anti-Lag_Boost_Building_System._The_value_looked_up_from_ANTLAG_is_divided_by_8_and_subtracted_directly_from_WOTMAP_at_line_6593_of_CalculateSparkAdvance_MM:_WOT_Timing_=_WOTMAP(MAP)_-_AntiLagRetard_Increasing_Table_Values_(More_Retard):_Effect_on_Total_Timing:_Pulls_more_timing_(up_to_16_deg_retard)_when_boost_is_below_target.
    ;mpmapaxis x
    .byte 0x05                       ;Number of points in table
    .byte 0x0A, 0x00, 0x03, 0x8E     ;Point 1
    .byte 0x1C, 0x40, 0x01, 0xC7     ;Point 2
    .byte 0x2E, 0x60, 0x00, 0xF6     ;Point 3
    .byte 0x47, 0x78, 0x00, 0x40     ;Point 4
    .byte 0x67, 0x80                 ;Point 5

AKPMON_AlkyPumpOnSetpointFromMAP:
    ;mpgrp Turbonator_Features\Alky_Injection\
    ;mptbladdr 0xC593
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyPumpOnSetpointFromMAP
    ;mptblcname AKPMON
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc AKPMON_establishes_the_manifold_absolute_pressure_(MAP)_turn-on_threshold_for_the_Turbonator_water/methanol_(alky)_injection_delivery_pump._Enabling_Alky_Injection:_Set_cfg_AlkyInj_in_configuration_flags._Calibrate_AKPMON_to_roughly_3-5_psi_of_boost_(approx_0x90_on_a_2-bar_or_3-bar_MAP_sensor).
    ;mpmapaxis y
    .byte 0xAA                       ;Point 1

AKPMOF_AlkyPumpOffSetpointFromMAP:
    ;mpgrp Turbonator_Features\Alky_Injection\
    ;mptbladdr 0xC594
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyPumpOffSetpointFromMAP
    ;mptblcname AKPMOF
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc AKPMOF_establishes_the_shut-off_MAP_threshold_for_the_water/methanol_injection_pump._Once_the_water/methanol_pump_has_been_energized_at_AKPMON,_AKPMOF_creates_a_pressure_hysteresis_cushion._Hysteresis_Calibration:_Set_AKPMOF_approximately_1.5_-_2.0_psi_below_AKPMON._For_example,_if_the_pump_turns_on_at_5_psi_boost,_set_it_to_turn_off_at_3_psi_boost._Smooth_Cutoff:_Prevents_sudden_pump_shutdown_on_momentary_boost_fluctuations_during_gear_shifts.
    ;mpmapaxis y
    .byte 0xAA                       ;Point 1

AKI1ON_AlkyInj1OnSetpointFromMAP:
    ;mpgrp Turbonator_Features\Alky_Injection\
    ;mptbladdr 0xC595
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyInj1OnSetpointFromMAP
    ;mptblcname AKI1ON
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc AKI1ON_sets_the_manifold_pressure_threshold_where_the_Stage_1_water/methanol_injection_nozzle_solenoid_opens._Stage_1_Activation:_Calibrate_AKI1ON_to_trigger_at_the_boost_level_where_engine_knock_margin_begins_to_narrow_on_pump_gas_(typically_7_to_10_psi_boost)._Nozzle_Sizing:_Size_Stage_1_nozzle_for_approximately_10-15%_of_total_fuel_flow_to_avoid_rich_bogging.
    ;mpmapaxis y
    .byte 0xAA                       ;Point 1

AKI1OF_AlkyInj1OffSetpointFromMAP:
    ;mpgrp Turbonator_Features\Alky_Injection\
    ;mptbladdr 0xC596
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyInj1OffSetpointFromMAP
    ;mptblcname AKI1OF
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc AKI1OF_specifies_the_MAP_threshold_where_the_Stage_1_water/methanol_solenoid_shuts_off_as_manifold_pressure_drops._Provides_hysteresis_cutoff_protection_for_Stage_1_water/methanol_injection,_ensuring_the_nozzle_snaps_closed_cleanly_when_throttle_lifts_occur._Staggering:_Calibrate_AKI1OF_approximately_1.5_-_2.0_psi_below_AKI1ON._Ensures_clean_cutoff_without_premature_shutoff_during_boost_ramping.
    ;mpmapaxis y
    .byte 0xAA                       ;Point 1

AKI2ON_AlkyInj2OnSetpointFromMAP:
    ;mpgrp Turbonator_Features\Alky_Injection\
    ;mptbladdr 0xC597
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyInj2OnSetpointFromMAP
    ;mptblcname AKI2ON
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc AKI2ON_establishes_the_trigger_threshold_for_the_high-flow_Stage_2_water/methanol_injection_nozzle_solenoid._Under_maximum_boost_conditions_(e.g._15-25+_psi),_engine_thermal_loading_and_octane_demand_escalate_drastically._High_Boost_Staging:_Set_AKI2ON_4-8_psi_higher_than_AKI1ON_(e.g._Stage_1_at_8_psi,_Stage_2_at_16_psi)._This_two-stage_delivery_provides_linear_octane_supplementation_without_drowning_the_motor_at_mid-range_boost.
    ;mpmapaxis y
    .byte 0xAA                       ;Point 1

AKI2OF_AlkyInj2OffSetpointFromMAP:
    ;mpgrp Turbonator_Features\Alky_Injection\
    ;mptbladdr 0xC598
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyInj2OffSetpointFromMAP
    ;mptblcname AKI2OF
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 29.4 psi
    ;mptbldesc AKI2OF_establishes_the_shut-off_threshold_for_Stage_2_water/methanol_injection._Closes_the_high-flow_Stage_2_nozzle_when_manifold_pressure_falls_below_the_calibrated_hysteresis_threshold,_preserving_water/methanol_fluid_and_preventing_over-rich_fueling_as_boost_begins_tapering._Hysteresis_Margin:_Set_AKI2OF_roughly_2_psi_below_AKI2ON._Maintain_gap_above_AKI1ON_so_stages_hand_over_smoothly.
    ;mpmapaxis y
    .byte 0xAA                       ;Point 1

KNKMIN_FlashCEMinTemp:
    ;mpgrp Turbonator_Features\Flash_CE_on_Knock\
    ;mptbladdr 0xC599
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FlashCEMinTemp
    ;mptblcname KNKMIN
    ;mpxaxis IN 0 255 X
    ;mpyaxis CoolantTemp -200 260 deg
    ;mptbldesc KNKMIN_defines_the_minimum_engine_coolant_temperature_required_before_the_ECU_will_flash_the_instrument_cluster_"Check_Engine"_/_"Power_Loss"_light_upon_detecting_spark_knock._Forged_Piston_Engines:_Engines_built_with_loose_piston-to-wall_clearances_(forged_2618_pistons)_produce_noticeable_cold_slap._Raising_KNKMIN_to_0xB5_(~175_degF)_completely_silences_false_knock_alerts_until_the_pistons_have_fully_expanded.
    .byte 0xA6                       ;Point 1

SLRPM_ShiftLightSetpoint:
    ;mpgrp Turbonator_Features\Shift_Light\
    ;mptbladdr 0xC59A
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ShiftLightSetpoint
    ;mptblcname SLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 16384 rpm
    ;mptbldesc SLRPM_sets_the_precise_engine_RPM_at_which_the_ECU_illuminates_the_instrument_cluster_upshift_indicator_or_an_external_shift_light._Power_Peak_Shift_Point:_Set_SLRPM_roughly_200-400_RPM_past_peak_horsepower_on_your_dyno_sheet,_but_300-500_RPM_below_your_hard_rev_limiter_(REVLMT)._This_gives_the_driver_human_reaction_time_to_initiate_the_shift_without_bouncing_off_the_limiter.
    .word 0xABDF                     ;Point 1
       
WOTBAT_WOTBatteryVoltsTarget:
    ;mpgrp Turbonator_Features\Voltage_Regulator\
    ;mptbladdr 0xC59C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WOTBatteryVoltsTarget
    ;mptblcname WOTBAT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis BatVolts 0 16.2 V
    ;mptbldesc WOTBAT_specifies_the_target_battery_regulation_voltage_commanded_during_Wide_Open_Throttle_(WOT)_acceleration._The_Chrysler_logic_module_directly_controls_alternator_charging_field_duty_cycle_via_an_internal_pulse-width_modulated_voltage_regulator._Free_Dyno_Horsepower:_Frees_3-5_HP_at_the_wheels_during_full-throttle_acceleration_pulls._Ignition_Coil_Considerations:_Ensure_your_ignition_system_and_fuel_pump_maintain_sufficient_voltage_at_~12.5V.
    .byte 0xEC                       ;Point 1

BSTSWS_HighBoostSwitchSelect:
    ;mpgrp Boost_Control\Target_Lookup\
    ;mptbladdr 0xC59D
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname HighBoostSwitchSelect
    ;mptblcname BSTSWS
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc BSTSWS_defines_the_hardware_input_pin_bitmask_used_to_toggle_Turbonator_Switchable_Boost_(High/Low_Boost):_0x01=Cruise_Set_(B9),_0x02=Cruise_Resume_(B10,_default),_0x04=A/C_Sense_(B11),_0x08=Park/Neutral_(B12),_0x10=Brake_Switch_(B13),_0x40=Cruise_Enable_(B15)._Wire_a_toggle_switch_between_the_chosen_pin_and_ground_or_12V_to_enable_dual-stage_boost_control.
    ;mpchoices Cruise_Set(Momentary)  Cruise_Resume(Momentary)  A/C_Clutch_Input(Do_Not_Use)  Brake_Pedal_Switch  P/N_Switch  Nothing(Do_Not_Use)  Cruise_On/Off  Dist_Sync(Do_Not_Use)
    .byte 0x00                       ;Point 1
bst_DistSync 		= $%10000000	; Distributor Sync
bst_CruiseOnOff 	= $%01000000	; Cruise On/Off
bst_B1Volt		= $%00100000	; B1 Voltage Sense (not sure, maybe nothing)
bst_PNswitch  		= $%00010000	; Park/Neutral switch
bst_Brake  		= $%00001000	; Brake Switch
bst_ACclutch  		= $%00000100	; A/C Clutch input
bst_CruiseResume 	= $%00000010	; Cruise Resume
bst_CruiseSet 		= $%00000001	; Cruise Set
      
        ; 35    x80     7   dist sync           B17
        ; 36    x40     6   cruise enable       B15
        ; 37    x20     5                       B14
        ; 38    x10     4   brake               B13
        ; 39    x08     3   park/neutral        B12
        ; 1     x04     2   ac clutch in        B11
        ; 2     x02     1   cruise resume       B10
        ; 3     x01     0   cruise set          B9
        
SWBSLO_SwitchableBoostLoSetpoint:
    ;mpgrp Boost_Control\Target_Lookup\
    ;mptbladdr 0xC59E
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname SwitchableBoostLoSetpoint
    ;mptblcname SWBSLO
    ;mpxaxis X 0 255 in
    ;mpyaxis Boost 0 44.1 psi
    ;mptbldesc SWBSLO_defines_the_target_boost_ceiling_applied_when_Low_Boost_Mode_is_selected_via_the_dual-stage_boost_switch._Stock_Value:_0x56_(_~_9.9_psig_)._Valet_/_Economy_Mode:_Set_SWBSLO_to_spring_pressure_(e.g._5-7_psi)_for_a_valet_mode,_rain/winter_mode,_or_87-octane_emergency_mode._High_Boost_Mode:_Set_your_primary_curve_(WSGRPM)_to_18-25_psi;_flipping_the_switch_toggles_instantly_between_this_low_setting_and_full_high_boost.
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1

    SBNRMP_BankScalingFromMAP:
    ;mpgrp Fuel\Selective_Bank_Enrichment\
    ;mptbladdr 0xC59F
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BankScalingFromMAP
    ;mptblcname SBNRMP
    ;mpxaxis MAP -14.7 29.4 psi
    ;mpyaxis Factor 0 1 x
    ;mptbldesc SBNRMP_provides_the_manifold_pressure_scaling_curve_for_Chrysler's_Selective_Bank_Fuel_Enrichment_feature._Stock_Calibration:_Compensates_for_factory_log_and_two-piece_intake_manifold_distribution_biases._Custom_Aftermarket_Manifolds:_If_installing_an_aftermarket_custom_intake_manifold_with_equal-length_runners_or_an_upgraded_center-feed_plenum,_the_factory_distribution_asymmetry_is_eliminated!
    ;mpmapaxis x
    .byte 0x05                       ;Number of points in table
    .byte 0x11, 0xAB, 0xFA, 0x4B     ;Point 1
    .byte 0x22, 0x4A, 0xFE, 0x91     ;Point 2
    .byte 0x39, 0x29, 0xFF, 0x5A     ;Point 3
    .byte 0x4D, 0x1C, 0x01, 0xC7     ;Point 4
    .byte 0x71, 0x5C                 ;Point 5

SBNRRP_BankScalingFromRPM:
    ;mpgrp Fuel\Selective_Bank_Enrichment\
    ;mptbladdr 0xC5B2
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname BankScalingFromRPM
    ;mptblcname SBNRRP
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Factor 0 1 x
    ;mptbldesc SBNRRP_provides_the_engine_speed_weighting_curve_for_Selective_Bank_Fuel_Enrichment._Intake_runner_resonance_and_distribution_biases_change_with_engine_RPM._SBNRRP_modulates_the_selective_bank_trim_across_the_RPM_band,_peaking_where_runner_acoustic_imbalances_are_greatest._Stock_Setting:_Modulates_runner_distribution_trim_from_1500_to_5000_RPM._Aftermarket_Intakes:_Zero_out_when_running_symmetrical_intake_manifolds.
    .byte 0x03                       ;Number of points in table
    .byte 0x3F, 0x9A, 0x00, 0x3B     ;Point 1
    .byte 0x96, 0xAE, 0x00, 0x00     ;Point 2
    .byte 0xCB, 0xAE                 ;Point 3
	
SBNRBS_BankSelect:
    ;mpgrp Fuel\Selective_Bank_Enrichment\
    ;mptbladdr 0xC5BD
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname BankSelect
    ;mptblcname SBNRBS
    ;mpxaxis IN 0 255 x
    ;mpyaxis OUT 0 255 y
    ;mptbldesc SBNRBS_defines_which_physical_injector_driver_bank_receives_the_selective_bank_fuel_enrichment_pulse._Factory_Setting:_0x40_(Bank_3-4)._Valid_Settings:_0x40:_Enriches_Bank_2_(Cylinders_3_&_4)._0x80:_Enriches_Bank_1_(Cylinders_1_&_2)._0x00:_Disables_selective_bank_enrichment_completely.
    ;mpchoices NA  NA  NA  NA  NA  NA  Bank34(Stock)  Bank12(DC)
    .byte 0x40                       ;Point 1
    
MDLCDE_ModelTypeCode:
    ;mpgrp Setup\Cal_ID\
    ;mptbladdr 0xC5BE
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ModelTypeCode
    ;mptblcname MDLCDE
    ;mpxaxis X 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc MDLCDE_is_a_2-byte_engineering_classification_word_located_at_$008F._Tuning_Usage:_Factory_identification_constant._Preserve_stock_value_(0x9709)_when_updating_custom_tunes.
    .word 0x9709                     ;Point 1
    ;mp******************************
    ;mpmodelyr 97 1987
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
    ;mpmodelyr FF 1995_Neon
    ;mpmodelyr 95 1985
    ;mpmodelyr 98 1988
    ;mpmodelyr 04 1994
    ;mpmodelyr 05 1995
    ;mpmodelyr 12 1992
    ;mpmodelyr 13 1993_Mex
    ;mpengtran 09 2.2_TII
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
    ;mpengtran 08 2.2_T1
    ;mpengtran 99 2.2_TIII
    ;mpengtran 81 2.5_T1_Unk
    ;mpengtran 02 2.5_T1_Canada
    ;mpengtran C1 2.5_T2_Manual_Mex
    ;mpengtran 17 4.0_Jeep_Manual
    ;mp******************************

