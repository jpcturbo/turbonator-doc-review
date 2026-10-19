;mpver 2.00
;mpassmfile T-LMv13.asm
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

;mpinjsize 34.9
;mpbar 2.0

;
;  MAP definition
;
;  This is the MAP range that the template is based on. It is only used
;  by MP Tuner for MAP Scaling.
;
;  20 = 2.0 Bar MAP, 30 = 3.0 Bar map, etc.


;mprevisionstart
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
; 11/01/11 - Added PumpShot Subgroup
;          - Added calculated tables group
;          - Fixed MDLCDE definition
;
;
; ***********************************************************************
;
;mprevisionend
; Rom Area
; ***********************************************************************

;mpgroupstart Fuel_-_Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
;mpgroupend
;mpgroupstart Fuel_-_Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
;mpgroupend

    .msg "Assembling Data Structures..." ; these are just messages to display during assemble to let you know what's going on...


;mpfuelparms 6000,60,55,3.793,.740_Regular,2.2
;mpfuelnone1 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpfuelnone2 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpfuelpart1 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpfuelpart2 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpfuelfull1 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
;mpfuelfull2 14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7,14.7
RomBegin:

	;.org	0xc000
ENDITM_ECUID:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x0092
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ECU_ID
    ;mptblcname ENDITM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc ECU_ID._This_portion_of_the_PN_is_used_by_scan_tools_to_automatically_ID_the_ECU._This_number_is_different_for_every_computer/cal._The_1st_digit_is_possibly_a_revision_code_of_some_type._Or,_it_may_have_no_meaning_at_all.____OVERVIEW:_ENDITM_(ECU_ID)_is_a_critical_16-bit_calibration_identifier_placed_at_the_very_beginning_of_the_calibration_ROM_table_structure_(address_$C000,_offset_$0092)._This_2-byte_word_represents_the_engineering_calibration_release_ID_(in_this_stock_binary,_0xA171)._When_a_factory_Chrysler_diagnostic_readout_box_(DRB-II)_or_modern_scan_tool_queries_the_ECU_over_the_serial_communications_interface_(SCI),_the_diagnostic_subroutine_DRB_SendROMSerial_MM_transmits_ENDITM_to_identify_the_engine_displacement,_transmission_type,_model_year,_and_emissions_calibration_family._Furthermore,_the_ECU's_power-on_self-test_routine_ResetStartup_uses_ENDITM_to_verify_ROM_integrity_by_calculating_an_8-bit_additive_checksum_of_the_entire_calibration_table_space._|_TUNER'S_GUIDE:_Tuning_Usage:_When_modifying_custom_calibrations_in_MPTune,_updating_or_modifying_this_identifier_is_typically_handled_automatically_or_left_intact._Changing_this_identifier_alters_what_model_number_displays_on_scan_tools_(e.g._Snap-on_MT2500_or_DRB-II)._Checksum_Verification:_During_power-on_boot,_the_ECU_adds_all_calibration_bytes_and_subtracts_the_second_byte_of_ENDITM_(subb_ENDITM_ECUID+1)._If_the_calculated_sum_does_not_equal_zero,_the_ECU_flags_a_memory_checksum_fault_(ThrowNonCriticalError),_storing_Fault_Code_53_/_8-bit_error_flag_in_ErrorBitRegisterStored0.
    .word 0xA171                     ;Point 1

	;.org	0xc002
UnknownCodeBits:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x009F
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname Unknown_Code
    ;mptblcname UNKWN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Special_code_for_factory_testing.____OVERVIEW:_UNKWN_(UnknownCodeBits)_is_a_16-bit_word_located_at_$C002_(offset_$009F)_in_the_calibration_header._Originally_implemented_by_Chrysler_Powertrain_Electronics_engineering,_this_word_contains_configuration_bits_utilized_by_factory_automated_end-of-line_test_fixtures_and_automated_burn-in_benches._In_production_vehicle_operation,_these_bits_are_ignored_by_normal_fuel_and_spark_control_routines._|_TUNER'S_GUIDE:_Tuning_Recommendations:_Leave_unchanged_at_0x0041._Modifying_this_value_has_no_effect_on_engine_performance_or_road_drivability,_but_preserving_it_ensures_alignment_with_factory_binary_templates.
    .word 0x0041                     ;Point 1

	;.org	0xc004
HuntsvilleTesterCode:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x0082
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname Huntsville_Test_Code
    ;mptblcname HUNTSV
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Special_code_for_factory_testing.____OVERVIEW:_HUNTSV_(HuntsvilleTesterCode)_is_a_16-bit_identifier_residing_at_$C004_(offset_$0082)_in_the_ROM_header._Chrysler_engine_control_modules_were_manufactured_at_Chrysler's_Huntsville_Electronics_division_in_Huntsville,_Alabama._During_automated_printed_circuit_board_assembly_and_functional_bed-of-nails_testing,_the_automated_test_fixture_read_HUNTSV_(0xE844)_to_configure_automated_pin-test_routines_and_verify_flash/ROM_burn_fidelity._|_TUNER'S_GUIDE:_Tuning_Recommendations:_Leave_at_0xE844._It_is_non-executable_calibration_data_and_does_not_alter_engine_fueling,_boost,_or_spark_mapping.
    .word 0xE844                     ;Point 1

	;.org	0xc006
IPLMSK_PowerLossLightMask:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x00B9
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PowerLossLightMask
    ;mptblcname IPLMSK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Illuminate_PowerLoss_Light_Mask1._These_errors_alert_the_driver.____OVERVIEW:_IPLMSK_(PowerLossLightMask)_is_an_8-bit_diagnostic_control_mask_that_determines_which_electronic_sensor_and_circuit_faults_cause_the_dashboard_'Power_Loss'_/_'Check_Engine'_lamp_to_illuminate._While_the_ECU_logs_dozens_of_minor_diagnostic_anomalies_into_memory,_not_every_fault_warrants_alerting_the_driver._Minor_faults_(such_as_a_temporary_A/C_switch_glitch)_are_stored_silently_as_fault_codes_for_mechanics_to_read_later._Critical_faults_that_directly_compromise_emissions_or_engine_survival_(such_as_a_disconnected_MAP_sensor,_dead_coolant_sensor,_or_charging_system_failure)_are_filtered_through_IPLMSK._If_an_active_fault_matches_an_enabled_bit_in_IPLMSK,_the_ECU_immediately_grounds_the_lamp_driver_to_illuminate_the_dashboard_warning_light._|_TUNER'S_GUIDE:_Custom_Warning_Light_Setup:_If_running_a_dedicated_race_car_or_custom_conversion_and_you_want_to_prevent_non-critical_sensor_faults_from_turning_on_the_dashboard_light,_you_can_selectively_clear_corresponding_bits_in_IPLMSK._CEL_Knock_Warning:_Note_that_in_Turbonator_custom_code,_the_Check_Engine_Light_can_also_be_repurposed_to_flash_on_knock_detection_via_CONFIG_(cfg_FlashCE).
    ;mpchoices ChargeTemp_Sensor  CoolantTemp_Sensor  Charging  bit3  BatVolts  Map_Signal  Tps_Signal  Map_Pneumatic
    .byte 0xE9                       ;Point 1

	;.org	0xc007
IPLMSK2_PowerLossLightMask2:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x00C7
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname PowerLossLightMask2
    ;mptblcname IPLMSK2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Illuminate_PowerLoss_Light_Mask2._These_errors_alert_the_driver.____OVERVIEW:_IPLMSK2_(PowerLossLightMask2)_provides_the_second_tier_of_fault-masking_for_dashboard_warning_light_activation._Where_IPLMSK_focuses_predominantly_on_primary_analog_engine_sensors,_IPLMSK2_governs_actuator_driver_circuits_and_critical_system_over-limits._Enabled_bits_in_IPLMSK2_illuminate_the_dashboard_lamp_for_conditions_including_wastegate_solenoid_electrical_faults,_fuel_injector_circuit_open/shorts,_and_major_internal_processor_faults._|_TUNER'S_GUIDE:_Wastegate_Solenoid_Elimination:_If_you_remove_the_factory_electronic_wastegate_solenoid_to_install_a_standalone_manual_boost_controller_(MBC)_or_electronic_boost_controller,_the_ECU_will_detect_an_open_circuit_and_set_Fault_Code_32._Clearing_Bit_3_in_IPLMSK2_prevents_this_code_from_illuminating_the_dashboard_Power_Loss_light_while_keeping_other_diagnostic_protections_active.
    ;mpchoices bit0  bit1  bit2  Wastegate  InjectorFault  bit5  MajorFault  bit7
    .byte 0x3F                       ;Point 1

	;.org	0xc008
SpecialBytes:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x00D5
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname Setup_bytes
    ;mptblcname SETUP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_SETUP_(SpecialBytes)_is_an_alternating-bit_signature_word_(0x55AA,_binary_01010101_10101010)_positioned_at_$C008_(offset_$00D5)._In_embedded_microprocessor_systems,_0x55AA_is_the_industry-standard_alternating_test_pattern_used_to_detect_shorted_or_floating_address_and_data_bus_lines_on_printed_circuit_boards._If_any_pin_on_the_ROM_chip_or_memory_address_latch_is_bridged_with_solder_or_floating,_reading_$00D5_will_fail_to_return_0x55AA,_alerting_testing_fixtures_to_hardware_failure_immediately._|_TUNER'S_GUIDE:_Do_Not_Modify:_Always_retain_0x55AA._Diagnostic_tools_and_burning_utilities_use_this_pattern_to_confirm_binary_alignment.
    .word 0x55AA                     ;Point 1

SourceCodeVersionID:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x00E1
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname SourceCodeVersionID
    ;mptblcname SRCID
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_SRCID_(SourceCodeVersionID)_defines_the_unique_architecture_and_version_identification_number_for_the_engine_management_firmware._In_the_Turbonator_codebase_hierarchy:_High_Byte_($0A):_Designates_the_T-LM_(Turbo_Logic_Module)_codebase_family._(For_reference,_$0B_represents_T-SMEC,_and_$0C_represents_T-SBEC)._Low_Byte_($0D):_Designates_the_release_revision_(hex_$0D_=_decimal_13,_representing_v13)._MPTuning_and_burning_software_inspect_SRCID_before_opening_or_modifying_a_calibration_file,_ensuring_that_table_offsets,_vector_tables,_and_disassembly_scripts_match_the_exact_firmware_architecture_of_the_ECU_hardware._|_TUNER'S_GUIDE:_Critical_Compatibility_Identifier:_Never_change_SRCID_unless_you_are_deliberately_porting_a_calibration_to_a_newer_codebase_version._If_SRCID_does_not_match_0x0A0D,_MPTune_may_reject_the_file_or_misalign_table_addresses.
    .word 0x0A0D                     ;Point 1
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

	;.org	0xc00a
; Manual00_AutomaticFF:
;        chem2 group "Setup - Cal Configuration"
;        .chem 3 n AutomaticFF in_desc 0 255 in Y 0 255 out MANUAL00 Detailed_Description
;        chem2 byte MANUAL00 use "in desc" 0 255 "in" "Detailed Description"
;        .byte   0x00
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
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x0146
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname ConfigurationFlags
    ;mptblcname CONFIG
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc These_are_the_calibration_configuration_options.____OVERVIEW:_CONFIG_(CONFIG_ConfigurationFlags)_is_one_of_the_most_powerful_and_versatile_calibration_bytes_in_the_entire_ECU_firmware._It_serves_as_the_master_software_toggle_for_major_driveline_architecture_and_Turbonator_performance_modifications._In_this_stock_factory_manual_transmission_binary_(T_LM_22_MTX_A171),_CONFIG_is_initialized_to_0x00._When_building_custom_performance_calibrations,_tuners_toggle_specific_bits_in_this_byte_to_enable_cutting-edge_features:_Bit_7_(cfg_ATX,_$80):_Driveline_selection._Set_=_Automatic_transmission_(ATX),_Cleared_=_Manual_transmission_(MTX)._Bit_6_(cfg_FlashCE,_$40):_Flash_Check_Engine_Light_on_knock_detection._Bit_5_(cfg_BankEnrich,_$20):_Enable_selective_bank_fuel_enrichment._Bit_4_(cfg_ShiftLight,_$10):_Repurpose_Purge_solenoid_driver_as_an_adjustable_RPM_Shift_Light._Bit_3_(cfg_SwBoost,_$08):_Enable_dual_switchable_boost_stages_via_dash_switch._Bit_2_(cfg_BstSwPol,_$04):_Invert_boost_switch_input_polarity_(normally_open_vs_normally_closed)._Bit_1_(cfg_StageLim,_$02):_Enable_2-step_staging_rev_limiter_for_drag_launches._Bit_0_(cfg_AntiLag,_$01):_Enable_anti-lag_launch_retard._|_TUNER'S_GUIDE:_Manual_vs_Auto_Swap:_When_swapping_a_manual_transmission_into_an_automatic_car_(or_vice_versa),_toggle_Bit_7_(cfg_ATX)._This_reconfigures_idle_decel_dashpot_routines,_target_idle_tables,_and_rev_limiters._Knock_CEL_Flash:_Enabling_Bit_6_(cfg_FlashCE,_+$40)_provides_real-time_in-cockpit_visual_knock_feedback_without_needing_a_scan_tool_or_laptop._Drag_Racing_2-Step:_Enable_Bit_1_(+02)_to_activate_staging_limiter_features_using_the_clutch_switch_or_an_auxiliary_staging_button.
    ;mpchoices Anti-Lag_Retard  Staging_Limiter(2-step)  Boost_Switch_Polarity_toggle  Switchable_Boost_mod  Shift_Light_mod  Alky_Inj_mod  FlashCE_Mod  Auto_Trans_Bit
    .byte 0x00                       ;Point 1
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
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x0179
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname AdvanceFromMAPCold
    ;mptblcname CLDMAP
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Spark_Advance -64 64 Degrees
    ;mptbldesc Curve_for_Spark_Advance_from_MAP_when_Engine_Temp_is_below_TMPSWP____OVERVIEW:_CLDMAP_AdvanceFromMAPCold_defines_the_base_MAP-dependent_ignition_advance_curve_used_exclusively_when_the_engine_coolant_temperature_is_below_normal_operating_temperature_(TMPSWP)._During_cold_operation,_fuel_atomization_is_poor_and_combustion_chamber_wall_quenching_slows_down_the_initial_flame_front_speed._To_ensure_smooth_combustion,_prevent_stalling,_and_provide_adequate_cold_drive-away_power_without_causing_backfires,_CLDMAP_supplies_a_tailored_spark_curve_as_a_function_of_intake_manifold_pressure._|_TUNER'S_GUIDE:_The_value_looked_up_from_CLDMAP_is_placed_into_Temp0_and_later_combined_with_RPM_advance_(GOVNER)_to_calculate_total_ignition_timing._Increasing_Table_Values_(Adding_Timing_in_CLDMAP):_Effect_on_Total_Timing:_Advances_cold-engine_ignition_timing_across_the_corresponding_manifold_pressure_range._Real-World_Driving_Feel:_Can_improve_cold_throttle_response_and_engine_pep_during_the_first_few_minutes_of_driving._However,_excessive_cold_advance_under_boost_or_load_can_cause_cold-engine_detonation_or_spark_scatter._Decreasing_Table_Values_(Pulling_Timing_in_CLDMAP):_Effect_on_Total_Timing:_Retards_cold-engine_ignition_timing_across_the_corresponding_manifold_pressure_range._Real-World_Driving_Feel:_Causes_softer_cold_acceleration_and_slower_warm-up._If_retarded_excessively,_it_can_lead_to_cold_hesitation,_misfires,_or_popping_through_the_intake._Closed-Throttle_Interaction:_If_adjusting_the_vacuum_portion_of_CLDMAP_to_modify_cold_idle,_be_aware_that_CLDLMT_caps_the_maximum_allowable_advance_when_the_throttle_is_closed.
    ;mpmapaxis x
    .byte 0x03                       ;Number of points in table
    .byte 0x5E, 0xF4, 0x01, 0x39     ;Point 1
    .byte 0x70, 0x0A, 0xFF, 0xD5     ;Point 2
    .byte 0xB8, 0xFE                 ;Point 3

	;.org	0xc01a
CLDLMT_LimitForColdMapAtClosedThrottle:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x018A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LimitForColdMapAtClosedThrottle
    ;mptblcname CLDLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y -200 260 out
    ;mptbldesc Coldest_input_allowed_for_Cold_MAP____OVERVIEW:_CLDLMT_LimitForColdMapAtClosedThrottle_is_a_safety_clamp_constant_that_limits_the_maximum_advance_that_the_cold_MAP_table_(CLDMAP)_can_produce_while_the_engine_is_at_closed_throttle_(idling_or_trailing_throttle_on_overrun)._During_cold_warm-up,_manifold_vacuum_can_be_erratic_due_to_cold_friction,_high_idle_AIS_air_bypass,_and_hunting_engine_speeds._If_the_cold_MAP_table_produces_high_advance_numbers_under_deep_manifold_vacuum,_cold_closed-throttle_timing_could_flare_unpredictably,_causing_unstable_cold_idle_flare,_surging,_or_erratic_deceleration._CLDLMT_enforces_a_maximum_ceiling_on_the_cold_MAP_timing_contribution_when_the_throttle_plates_are_shut._|_TUNER'S_GUIDE:_Increasing_the_Value_(Higher_Clamp):_Effect_on_Total_Timing:_Allows_more_cold_MAP_advance_during_closed-throttle_idle_and_decel._Real-World_Driving_Feel:_Can_raise_cold_idle_RPM_and_stabilize_an_engine_with_an_aggressive_camshaft_that_struggles_to_maintain_cold_idle_without_extra_timing._However,_setting_it_too_high_can_cause_high_cold_idle_hang_or_surging_as_the_engine_warms_up._Decreasing_the_Value_(Lower_Clamp):_Effect_on_Total_Timing:_Restricts_the_cold_MAP_advance_to_a_lower_number_at_closed_throttle._Real-World_Driving_Feel:_Prevents_cold_idle_speed_runaway_and_smooths_deceleration_overrun,_but_if_set_too_low,_cold_idle_may_become_sluggish,_unstable,_or_prone_to_stalling_when_dropping_back_to_idle.
    .byte 0x14                       ;Point 1

PartThrottleTiming:
    ;mpgrp Calculated_Tables\
    ;mptbladdr 0x0304
    ;mptbltype 16
    ;mpsubtype n
    ;mptbllname PartThrottleTotalTiming
    ;mptblcname PTTIME
    ;mpxaxis GOVNER 0 8192 rpm
    ;mpyaxis HOTMAP -15 15 degrees
    ;mptbldesc Part_throttle_total_timing.____OVERVIEW:_>_[!IMPORTANT]_>_PC_Tuning_Software_Display_Table_Only:_>_PartThrottleTiming_(PTTIME)_does_not_exist_in_the_6803_microcontroller_binary_or_ROM_firmware._>_The_factory_Chrysler_Logic_Module_(T-LM)_does_not_store_3D_ignition_maps._Instead,_it_computes_total_part-throttle_ignition_advance_dynamically_at_runtime_by_adding_the_2D_engine_speed_curve_(GOVNER)_to_the_2D_manifold_pressure_curve_(HOTMAP)._MPTuning_(and_early_MPScan/Chem)_introduces_PTTIME_as_a_synthetic_3D_visualization_surface._It_allows_tuners_accustomed_to_modern_standalone_ECUs_(which_use_true_3D_fuel/spark_grids)_to_visualize_what_total_part-throttle_advance_looks_like_across_the_RPM_vs._MAP_matrix._|_TUNER'S_GUIDE:_When_tuning_in_MPTune:_Viewing_the_3D_Surface:_The_3D_graph_gives_an_immediate_visual_picture_of_part-throttle_timing:_high_advance_peaks_under_deep_vacuum_cruise_tapering_down_as_engine_load_increases._Editing_Cells_in_MPTune:_Because_the_ECU_firmware_only_stores_the_underlying_2D_curves,_editing_a_single_cell_on_the_3D_surface_in_MPTune_prompts_the_software_to_update_either_the_corresponding_point_in_GOVNER_or_HOTMAP._Dynamic_Modifiers_at_Runtime:_Remember_that_the_actual_timing_executed_on_the_road_may_also_include_transient_offsets_such_as_ARADVR_(boost_blend_retard),_barometric_altitude_compensation,_and_coolant_temperature_trims.
    ;mp3dxtable GOVNER 
    ;mpxintv 500
    ;mp3dytable HOTMAP 
    ;mpyintv 1
    ;mp3dmintable MINADV
    ;mp3dmaxtable SPKLMT
    ;mp3dmapmul MAPMUL
    .byte 0x1F                       ;Number of rows in table
    .byte 0x11                       ;Number of cols in table
    .byte 0x00                       ;00 = unsigned, FF = signed
	
FullThrottleTiming:
    ;mpgrp Calculated_Tables\
    ;mptbladdr 0x0319
    ;mptbltype 16
    ;mpsubtype n
    ;mptbllname FullThrottleTotalTiming
    ;mptblcname FTTIME
    ;mpxaxis GOVNER 0 8192 rpm
    ;mpyaxis WOTMAP -15 15 degrees
    ;mptbldesc Full_throttle_total_timing.____OVERVIEW:_>_[!IMPORTANT]_>_PC_Tuning_Software_Display_Table_Only:_>_FullThrottleTiming_(FTTIME)_does_not_exist_in_the_6803_microcontroller_binary_or_ROM_firmware._>_Like_its_part-throttle_counterpart,_the_T-LM_ECU_does_not_look_up_full-throttle_timing_from_a_3D_matrix._It_calculates_WOT_advance_by_adding_the_2D_engine_speed_curve_(GOVNER)_to_the_2D_full-throttle_MAP_curve_(WOTMAP)._MPTuning_generates_FTTIME_as_a_synthetic_3D_surface_to_allow_tuners_to_visualize_total_wide-open_throttle_advance_across_the_entire_engine_operating_envelope_(RPM_vs._Boost)._|_TUNER'S_GUIDE:_Visualizing_WOT_Timing:_The_3D_surface_illustrates_how_total_full-throttle_timing_evolves_as_the_engine_spools_into_boost._Typical_curves_show_timing_tapering_downward_as_boost_rises_toward_10-14+_psi_to_prevent_detonation_under_high_cylinder_pressure._Editing_Cells_in_MPTune:_Adjusting_cells_on_the_FTTIME_3D_grid_modifies_the_underlying_2D_tables:_either_GOVNER_(RPM-dependent_advance)_or_WOTMAP_(boost-dependent_advance)._Live_Modifiers:_Total_actual_WOT_timing_experienced_on_the_road_will_also_be_modified_by_active_knock_retard_(KnockLookup),_anti-lag_retard_(ANTLAG),_and_TPS_transient_retard_(RETTPS).
    ;mp3dxtable GOVNER 
    ;mpxintv 500
    ;mp3dytable WOTMAP 
    ;mpyintv 1
    ;mp3dmintable MINADV
    ;mp3dmaxtable SPKLMT
    ;mp3dmapmul MAPMUL
    .byte 0x1F                       ;Number of rows in table
    .byte 0x11                       ;Number of cols in table
    .byte 0x00                       ;00 = unsigned, FF = signed

	;.org	0xc01b
WOTMAP_AdvanceFromMAPWarmFull:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x0197
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname AdvanceFromMAPWarmFull
    ;mptblcname WOTMAP
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Spark_Advance -64 64 Degrees
    ;mptbldesc Curve_for_Spark_Advance_from_MAP_when_Engine_Temp_is_above_TMPSWP_and_at_Full_Throttle____OVERVIEW:_WOTMAP_AdvanceFromMAPWarmFull_is_the_primary_full-throttle_/_wide-open_throttle_(WOT)_load_advance_table._It_establishes_the_base_ignition_advance_curve_as_a_function_of_intake_manifold_pressure_whenever_the_engine_is_operated_at_wide-open_throttle_under_warm_conditions._At_WOT,_volumetric_efficiency_is_maximized,_cylinder_pressures_are_at_their_peak,_and_combustion_chamber_temperatures_rise_rapidly-especially_under_turbocharger_boost._Because_high_charge_density_drastically_accelerates_flame_front_speeds,_ignition_timing_must_be_retarded_under_boost_to_keep_peak_cylinder_pressure_(PCP)_safely_timed_after_top_dead_center_(typically_~14-17_deg_ATDC)_and_prevent_destructive_detonation._In_addition_to_serving_as_the_WOT_ignition_curve,_WOTMAP_serves_as_the_absolute_minimum_advance_floor_for_warm_part-throttle_boost_timing_via_the_HOTMAP_blending_logic._|_TUNER'S_GUIDE:_Total_full-throttle_ignition_timing_is_calculated_as_the_base_RPM_advance_(GOVNER)_plus_the_MAP_advance_from_WOTMAP:_Total_WOT_Advance_~_GOVNER(RPM)_+_WOTMAP(MAP)_-_AntiLagRetard_-_KnockRetard_+/-_BaroTrims_Increasing_Table_Values_(Adding_Timing_in_WOTMAP):_Effect_on_Total_Timing:_Advances_full-throttle_ignition_timing_across_the_corresponding_boost/MAP_points._Real-World_Driving_Feel:_Increases_peak_torque,_accelerates_spool-up,_and_improves_high-RPM_horsepower._Cautions:_Extremely_critical_for_engine_safety!_Excessive_advance_under_boost_rapidly_causes_heavy_detonation,_blown_head_gaskets,_or_melted_ring_lands._Always_tune_with_a_knock_monitor_and_appropriate_fuel_octane._Decreasing_Table_Values_(Pulling_Timing_in_WOTMAP):_Effect_on_Total_Timing:_Retards_full-throttle_ignition_timing_under_boost._Real-World_Driving_Feel:_Produces_a_safe,_knock-resistant_tune_(ideal_for_low-octane_fuel_or_high_boost),_but_excessive_retard_causes_sluggish_power_delivery_and_very_high_exhaust_gas_temperatures_(EGTs),_which_can_overheat_turbochargers_and_exhaust_valves.
    ;mpmapaxis x
    .byte 0x04                       ;Number of points in table
    .byte 0x66, 0x14, 0xFE, 0x00     ;Point 1
    .byte 0x70, 0x00, 0xFF, 0x78     ;Point 2
    .byte 0x92, 0xEE, 0xFF, 0xC7     ;Point 3
    .byte 0xB6, 0xE6                 ;Point 4

	;.org	0xc02e
HOTMAP_AdvanceFromMAPWarmPart:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x01A9
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname AdvanceFromMAPWarmPart
    ;mptblcname HOTMAP
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Spark_Advance -64 64 Degrees
    ;mptbldesc Curve_for_Spark_Advance_from_MAP_when_Engine_Temp_is_above_TMPSWP_and_not_at_Full_Throttle____OVERVIEW:_HOTMAP_AdvanceFromMAPWarmPart_is_the_primary_warm_part-throttle_load_advance_table._In_Chrysler's_2D_speed-density_architecture,_ignition_timing_is_decomposed_into_an_engine_speed_component_(GOVNER)_and_an_engine_load_/_manifold_pressure_component._HOTMAP_provides_the_load_component_across_vacuum_and_part-throttle_boost_when_the_engine_is_fully_warmed_up._During_part-throttle_cruising_under_light_engine_load_(high_manifold_vacuum),_the_cylinder_charge_is_lean_and_less_dense,_burning_significantly_slower_than_a_dense_WOT_mixture._To_achieve_maximum_thermal_efficiency_and_fuel_economy,_HOTMAP_introduces_high_advance_figures_(up_to_+12_deg_or_more_of_additional_MAP_advance)_in_high-vacuum_regions,_progressively_decreasing_the_timing_as_manifold_pressure_approaches_atmospheric_and_transitions_into_boost._|_TUNER'S_GUIDE:_Total_part-throttle_ignition_timing_is_the_sum_of_RPM_advance_(GOVNER),_the_effective_part-throttle_MAP_advance_derived_from_HOTMAP,_and_barometric/temperature_trims:_Total_Timing_~_GOVNER(RPM)_+_max(WOTMAP,_HOTMAP_-_Retard)_+/-_Trims_Increasing_Table_Values_(Adding_Timing_in_HOTMAP):_Effect_on_Total_Timing:_Increases_part-throttle_advance_across_the_corresponding_MAP_region._Real-World_Driving_Feel:_Delivers_sharper,_crisper_throttle_response_under_cruising_and_light_tip-in,_improves_fuel_economy,_and_reduces_exhaust_gas_temperatures_(EGTs)_during_highway_driving._Cautions:_Excessive_advance_in_the_mid-vacuum_/_light-boost_region_can_induce_part-throttle_ping_or_knock,_especially_in_taller_gears_under_light_acceleration._Decreasing_Table_Values_(Pulling_Timing_in_HOTMAP):_Effect_on_Total_Timing:_Decreases_part-throttle_advance._Real-World_Driving_Feel:_Softens_throttle_response_and_makes_part-throttle_acceleration_feel_sluggish._Excessive_reduction_increases_EGTs_and_reduces_fuel_efficiency._Relation_to_WOTMAP:_In_the_ECU_assembly_code,_WOTMAP_serves_as_a_hard_lower_floor._HOTMAP_values_under_boost_should_blend_logically_into_WOTMAP_to_ensure_smooth_transition_behavior.
    ;mpmapaxis x
    .byte 0x07                       ;Number of points in table
    .byte 0x44, 0x18, 0xFF, 0x1C     ;Point 1
    .byte 0x4D, 0x10, 0x00, 0x00     ;Point 2
    .byte 0x54, 0x10, 0xFF, 0x33     ;Point 3
    .byte 0x5E, 0x08, 0x00, 0x00     ;Point 4
    .byte 0x77, 0x08, 0xFF, 0x73     ;Point 5
    .byte 0xAA, 0xEC, 0xFF, 0x92     ;Point 6
    .byte 0xB8, 0xE6                 ;Point 7

	;.org	0xc049
ARADVR_AdaptiveRetardAdvanceRatioFromMAP:
    ;mpgrp Spark_-_Adaptive_Retard\
    ;mptbladdr 0x01BE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardAdvanceRatioFromMAP
    ;mptblcname ARADVR
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc OVERVIEW:_In_factory_turbocharged_Chrysler_engine_calibrations_(such_as_the_1987_T1/T2_Logic_Module),_engines_run_significantly_more_ignition_advance_at_part_throttle_(cruising_and_light_load)_for_sharp_throttle_response_and_fuel_economy_than_they_do_at_wide-open_throttle_(WOT),_where_elevated_cylinder_pressures_and_combustion_temperatures_demand_lower,_safer_advance_to_avoid_detonation._When_a_driver_accelerates_and_begins_building_boost_at_part_throttle_without_fully_depressing_the_accelerator_pedal_to_WOT,_the_ECU_needs_a_method_to_safely_transition_ignition_timing_downward_from_the_higher_part-throttle_timing_table_toward_the_more_conservative_full-throttle_timing_table._ARADVR_AdaptiveRetardAdvanceRatioFromMAP_acts_as_a_part-throttle_boost_retard_multiplier_/_scaling_gain._It_dictates_how_aggressively_ignition_advance_is_pulled_out_(retarded)_as_manifold_boost_and_part-throttle_fuel_enrichment_accumulate._|_TUNER'S_GUIDE:_The_result_of_this_calculation_is_a_retard_offset_that_is_subtracted_from_the_warm_part-throttle_MAP_advance_table_(HOTMAP_AdvanceFromMAPWarmPart),_with_the_full-throttle_table_(WOTMAP_AdvanceFromMAPWarmFull)_acting_as_a_hard_floor._The_final_MAP_component_is_then_added_to_the_RPM_advance_curve_(GOVNER_AdvanceFromRPM)_to_produce_total_ignition_timing._Increasing_the_Value_(Larger_Number):_What_it_does:_Increases_the_amount_of_timing_pulled_out_under_part-throttle_boost._Effect_on_Total_Timing:_Retards_total_ignition_timing_much_faster,_pulling_total_advance_down_to_match_the_conservative_WOT_table_sooner._Real-World_Driving_Feel:_Produces_a_more_conservative,_knock-resistant_tune_under_heavy_mid-throttle_load_(e.g.,_pulling_a_grade_or_towing),_though_power_delivery_may_feel_slightly_softer_as_boost_builds._Decreasing_the_Value_(Smaller_Number):_What_it_does:_Decreases_the_amount_of_timing_pulled_out_under_part-throttle_boost._Effect_on_Total_Timing:_Advances_total_ignition_timing_during_boost_transitions,_keeping_ignition_advance_closer_to_the_higher_part-throttle_curve._Real-World_Driving_Feel:_Delivers_sharper_throttle_response_and_stronger_mid-range_torque_when_rolling_into_boost,_but_increases_the_risk_of_spark_knock_if_your_base_part-throttle_timing_table_is_too_aggressive_for_the_fuel_octane._Setting_the_Value_to_Zero_(0x00):_What_it_does:_Completely_disables_this_transitional_boost-retard_mechanism._Effect_on_Total_Timing:_The_ECU_will_not_pull_any_progressive_timing_based_on_boost_at_part_throttle,_it_will_run_the_raw_part-throttle_table_until_you_either_floor_it_to_WOT_or_the_table's_values_naturally_dip_below_the_WOT_curve.
    .byte 0x1F                       ;Point 1

	;.org	0xc04a
FACALC_AdaptiveRetardEnable:
    ;mpgrp Spark_-_Adaptive_Retard\
    ;mptbladdr 0x01CB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveRetardEnable
    ;mptblcname FACALC
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_FACALC_AdaptiveRetardEnable_is_a_mathematical_mode-switch_flag_that_dictates_the_arithmetic_operation_(subtraction_versus_addition)_applied_to_the_part-throttle_boost_blend_timing_calculation._When_an_engine_transitions_from_vacuum_to_boost_under_part_throttle,_the_ECU_calculates_a_proportional_timing_delta_(Temp1)_based_on_ARADVR,_boost_pressure,_and_Part-Throttle_Enrichment._FACALC_determines_whether_this_delta_is_subtracted_from_HOTMAP_(reducing_timing_toward_WOT_levels)_or_added_to_[HOTMAP]._In_factory_calibrations,_FACALC_is_set_to_0xFF_(signed_negative),_configuring_the_system_to_retard_timing_under_part-throttle_boost._|_TUNER'S_GUIDE:_The_CPU_evaluates_only_the_most_significant_bit_(bit_7)_of_FACALC_via_the_branch-if-minus_(bmi)_opcode:_Stock_Setting_(0xFF_/_Negative_/_Bit_7_=_1):_Function:_Subtractive_Mode_(Timing_Retard)._Effect_on_Total_Timing:_Subtracts_the_ARADVR_calculation_(Temp1)_from_HOTMAP._Total_ignition_timing_drops_progressively_as_boost_builds_at_part_throttle_until_clamped_by_WOTMAP._Tuning_Recommendation:_Standard_for_all_turbocharged_gasoline_engines._Keeps_the_engine_safe_from_part-throttle_detonation_during_boost_onset._Non-Stock_Setting_(0x00-0x7F_/_Positive_/_Bit_7_=_0):_Function:_Additive_Mode_(Timing_Advance)._Effect_on_Total_Timing:_Adds_Temp1_to_HOTMAP,_increasing_part-throttle_advance_under_load,_and_clamping_from_above_against_WOTMAP._Tuning_Recommendation:_DANGEROUS_on_turbocharged_gasoline_engines._Adding_advance_under_rising_manifold_boost_can_trigger_instant_severe_detonation._Do_not_change_this_value_to_a_positive_number_unless_testing_specialized_naturally-aspirated_or_alternative-fuel_strategies.
    .byte 0xFF                       ;Point 1

	;.org	0xc04b
TMPSWP_EngTempSwitchPointForSparkAdvance:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x01D8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngTempSwitchPointForSparkAdvance
    ;mptblcname TMPSWP
    ;mpxaxis IN 0 255 X
    ;mpyaxis Coolant_Temperature -200 260 F
    ;mptbldesc Engine_temperature_switch_point_for_hot_and_cold_map_spark____OVERVIEW:_TMPSWP_EngTempSwitchPointForSparkAdvance_is_the_primary_coolant_temperature_threshold_that_divides_the_ECU's_ignition_timing_logic_into_two_distinct_modes:_Cold_Engine_Operation_and_Warm_(Normal)_Engine_Operation._Cold_engines_have_lower_combustion_chamber_temperatures,_slower_fuel_vaporization,_and_slower_flame_propagation_speeds,_requiring_a_dedicated_ignition_advance_strategy_(CLDMAP)_to_maintain_stability_and_warm_up_the_engine_quickly._Once_the_coolant_reaches_normal_operating_temperature,_the_ECU_switches_to_its_primary_warm_timing_tables_(HOTMAP_and_WOTMAP)._TMPSWP_defines_the_exact_temperature_where_this_transition_occurs._|_TUNER'S_GUIDE:_Increasing_the_Value_(Higher_Temp_Threshold):_What_it_does:_Forces_the_engine_to_stay_in_cold-engine_ignition_mode_longer_into_its_warmup_cycle._Effect_on_Total_Timing:_Extends_the_use_of_CLDMAP._Total_timing_will_follow_cold_advance_tables_until_the_engine_reaches_a_higher_coolant_temperature._Real-World_Driving_Feel:_Useful_if_an_engine_exhibits_cold-stumble_or_hesitation_during_extended_warm-ups,_but_setting_it_too_high_causes_sluggish_throttle_response_and_poor_fuel_economy_once_the_vehicle_is_being_driven._Decreasing_the_Value_(Lower_Temp_Threshold):_What_it_does:_Causes_the_ECU_to_switch_into_warm-engine_spark_logic_earlier_during_warm-up._Effect_on_Total_Timing:_Engages_HOTMAP_and_WOTMAP_sooner_after_startup._Real-World_Driving_Feel:_Can_improve_throttle_response_earlier_during_warm-up,_but_if_set_too_low_(e.g.,_below_the_thermostat_opening_temperature),_a_cold_engine_may_encounter_poor_drivability_or_detonation_under_load_due_to_insufficient_warmup_timing._Typical_Tuning_Practice:_In_stock_calibrations,_TMPSWP_is_set_to_0xA6_(~166_degF_/_74_degC),_matching_the_factory_180_degF_thermostat_warm-up_curve._If_running_a_cooler_thermostat_(such_as_a_160_degF_unit),_tuners_occasionally_lower_this_constant_slightly_so_the_ECU_consistently_enters_warm-engine_spark_mode.
    .byte 0xA6                       ;Point 1

	;.org	0xc04c
ABCBAS_AdvanceBaroCompensationBaseFromRPM:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x01E5
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AdvanceBaroCompensationBaseFromRPM
    ;mptblcname ABCBAS
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Factor 0 1 out
    ;mptbldesc OVERVIEW:_ABCBAS_AdvanceBaroCompensationBaseFromRPM_provides_the_RPM-dependent_baseline_ceiling_for_the_ECU's_barometric_pressure_spark_compensation_calculation._At_higher_elevations_(lower_barometric_ambient_pressure),_air_is_less_dense_and_cylinder_filling_is_reduced_at_any_given_throttle_position._While_naturally_aspirated_engines_can_often_tolerate_additional_advance_at_altitude_due_to_lower_charge_density,_turbocharged_engines_operating_under_boost_at_high_elevation_face_hotter_intake_charges_(since_the_turbocharger_must_spin_faster_and_work_harder_at_a_higher_pressure_ratio_to_achieve_target_boost)_and_lower_exhaust_backpressure_ratios._ABCBAS,_in_conjunction_with_ABCFBR_and_ABCFRP,_provides_an_altitude-sensitive_ignition_timing_ceiling._|_TUNER'S_GUIDE:_The_barometric_calculation_determines_a_maximum_allowable_MAP_advance_ceiling_(_A_):_A_=_ABCBAS(RPM)_-_[(ABCFRP(RPM)_*_ABCFBR(BaroPressure)_/_256)]_If_A_<_Temp0_,_the_ECU_clamps_base_MAP_advance_to_A_(provided_A_>=_MINADV_)._Increasing_Table_Values_(Higher_Base_Factor):_Effect_on_Total_Timing:_Raises_the_barometric_ceiling,_allowing_more_base_MAP_advance_under_altitude_conditions._Real-World_Driving_Feel:_Prevents_premature_timing_reduction_at_high_elevation,_maintaining_crisp_throttle_response._Decreasing_Table_Values_(Lower_Base_Factor):_Effect_on_Total_Timing:_Lowers_the_barometric_timing_ceiling._Real-World_Driving_Feel:_Clamps_timing_more_aggressively_at_altitude_to_safeguard_against_hot_turbo_air_charges._Sea-Level_Operation:_At_sea_level_(~14.7_psi_baro_/_0x78),_ABCFBR_drops_to_0,_making_the_subtraction_term_zero_and_allowing_ABCBAS_to_act_as_an_absolute_RPM-based_MAP_advance_limiter.
    .byte 0x02                       ;Number of points in table
    .byte 0x3F, 0x08, 0x01, 0x55     ;Point 1
    .byte 0x4B, 0x18                 ;Point 2

	;.org	0xc057
ABCFBR_AdvanceBaroCompensationFactorFromBaro:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x01F4
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AdvanceBaroCompensationFactorFromBaro
    ;mptblcname ABCFBR
    ;mpxaxis Baro 0 29.4 psi
    ;mpyaxis Spark_Advance_Scale 0 4 out
    ;mptbldesc OVERVIEW:_ABCFBR_AdvanceBaroCompensationFactorFromBaro_provides_the_barometric_pressure_weighting_factor_for_the_ECU's_altitude_ignition_timing_limiter._As_ambient_atmospheric_pressure_drops_with_increasing_elevation,_the_turbocharger_must_work_at_higher_pressure_ratios_to_achieve_target_boost,_resulting_in_significantly_higher_compressor_outlet_temperatures._To_prevent_detonation_under_these_conditions,_ABCFBR_generates_a_scaling_multiplier_that_grows_as_ambient_barometric_pressure_decreases._This_multiplier_scales_the_RPM_factor_(ABCFRP),_and_the_product_is_subtracted_from_the_baseline_ceiling_(ABCBAS)_to_reduce_allowable_MAP_spark_advance_at_high_altitudes._|_TUNER'S_GUIDE:_Increasing_Table_Values_(Higher_Baro_Factor):_Effect_on_Total_Timing:_Retards_total_ignition_timing_more_aggressively_as_elevation_increases_by_pulling_more_timing_away_from_ABCBAS._Real-World_Driving_Feel:_Provides_an_extra_safety_margin_against_detonation_when_driving_high_in_the_mountains_where_intercoolers_and_radiators_are_less_effective._Decreasing_Table_Values_(Lower_Baro_Factor):_Effect_on_Total_Timing:_Maintains_higher_ignition_timing_at_altitude._Real-World_Driving_Feel:_Restores_mid-range_punch_and_responsiveness_at_high_elevation,_but_requires_adequate_fuel_octane_or_effective_intercooling_to_prevent_high-altitude_knock._Setting_to_Zero_(0x00_across_table):_Disables_barometric_timing_reduction_completely,_the_ECU_will_enforce_only_the_raw_ABCBAS_curve_regardless_of_altitude.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x6D, 0x04, 0xFF, 0xA3     ;Point 1
    .byte 0x78, 0x00                 ;Point 2

	;.org	0xc062
ABCFRP_AdvanceBaroCompensationFactorFromRPM:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x0204
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AdvanceBaroCompensationFactorFromRPM
    ;mptblcname ABCFRP
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Spark_Advance_Scale 0 4 out
    ;mptbldesc OVERVIEW:_ABCFRP_AdvanceBaroCompensationFactorFromRPM_is_the_engine_speed_modifier_for_the_barometric_spark_compensation_system._While_ABCFBR_senses_how_high_the_vehicle_is_operating_above_sea_level,_ABCFRP_determines_at_which_engine_speeds_altitude-related_ignition_retard_should_be_applied._Turbocharged_engines_operating_at_altitude_typically_experience_their_highest_thermal_stress_and_knock_vulnerability_across_the_peak_torque_/_mid-RPM_band_(typically_2,500_to_4,500_RPM)_where_cylinder_pressures_are_highest._ABCFRP_concentrates_the_barometric_retard_into_this_RPM_range_while_tapering_it_off_at_high_RPM._|_TUNER'S_GUIDE:_Increasing_Table_Values_(Higher_RPM_Factor):_Effect_on_Total_Timing:_Pulls_more_timing_at_the_specified_RPMs_when_operating_at_altitude._Real-World_Driving_Feel:_Calms_mid-range_detonation_tendencies_when_driving_under_load_in_mountain_passes._Decreasing_Table_Values_(Lower_RPM_Factor):_Effect_on_Total_Timing:_Reduces_altitude-induced_timing_retard_across_the_specified_RPM_range._Real-World_Driving_Feel:_Restores_mid-range_torque_and_responsiveness_at_high_elevation._Tuning_RPM_Distribution:_By_altering_the_RPM_points_in_ABCFRP,_tuners_can_selectively_protect_the_engine_in_the_spool-up/peak-torque_window_without_compromising_top-end_power.
    .byte 0x02                       ;Number of points in table
    .byte 0x38, 0xFF, 0xEC, 0x62     ;Point 1
    .byte 0x45, 0x00                 ;Point 2

	;.org	0xc06d
MINADV_MinimumAdvance:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x0213
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumAdvance
    ;mptblcname MINADV
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Advance 0 128 deg
    ;mptbldesc OVERVIEW:_MINADV_MinimumAdvance_is_an_absolute_minimum_safety_floor_applied_to_the_calculated_barometric_advance_limit._When_the_ECU_calculates_its_altitude_timing_ceiling_using_ABCBAS,_ABCFBR,_and_ABCFRP,_high_altitude_multipliers_could_theoretically_subtract_so_much_timing_that_the_resulting_ceiling_becomes_zero_or_negative_(excessive_retard)._Overly_retarded_ignition_timing_under_load_can_cause_combustion_to_continue_after_exhaust_valve_opening,_generating_extreme_exhaust_gas_temperatures_(EGTs)_that_can_warp_exhaust_manifolds,_burn_exhaust_valves,_and_melt_turbocharger_turbines._MINADV_guarantees_that_the_baro-calculated_timing_ceiling_will_never_fall_below_a_defined_minimum_floor_(+3.0_deg_in_stock_calibrations)._|_TUNER'S_GUIDE:_Increasing_the_Value_(Higher_Minimum_Floor):_Effect_on_Total_Timing:_Ensures_the_engine_never_runs_less_than_this_floor_from_the_baro_limiter._Real-World_Driving_Feel:_Protects_against_excessive_EGT_buildup_and_sluggish_performance_at_extreme_altitudes_(such_as_Pike's_Peak_or_mountain_passes_over_10,000_ft)._Decreasing_the_Value_(Lower_Minimum_Floor):_Effect_on_Total_Timing:_Allows_the_baro_calculation_to_pull_timing_further_downward._Real-World_Driving_Feel:_Provides_maximum_knock_protection_at_extreme_altitudes,_but_risks_high_exhaust_temperatures_under_extended_wide-open_throttle_climbs._Stock_Setting:_In_the_stock_A171_calibration,_MINADV_is_set_to_0x06_(_6_/_2_=_+3.0_deg_advance),_which_represents_an_ideal_failsafe_baseline.
    .byte 0x06                       ;Point 1

	;.org	0xc06e
RETTPS_RetardFromTPS:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x0220
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname RetardFromTPS
    ;mptblcname RETTPS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Advance 0 128 deg
    ;mptbldesc OVERVIEW:_RETTPS_RetardFromTPS_is_the_lookup_table_that_defines_how_many_degrees_of_ignition_timing_are_pulled_out_as_a_function_of_throttle_opening_speed_(_DeltaTPS_)._When_the_throttle_is_snapped_open_rapidly_under_boost,_the_rate_of_throttle_movement_reflects_the_suddenness_of_air_mass_change_entering_the_intake_manifold._RETTPS_scales_the_protective_retard_proportionally:_a_slow,_gradual_roll_into_the_throttle_produces_almost_zero_retard,_while_a_violent,_rapid_stomp_to_full_throttle_extracts_substantial_ignition_advance_(up_to_~25_deg_in_stock_tables)_for_a_brief_instant_to_quench_transient_detonation_before_fuel_film_dynamics_stabilize._|_TUNER'S_GUIDE:_The_value_looked_up_from_RETTPS_is_subtracted_directly_from_intermediate_total_advance:_Total_Advance_=_max(0,_Advance_-_RETTPS(DeltaTPS))_Increasing_Table_Values_(More_Retard_per_DeltaTPS_):_Effect_on_Total_Timing:_Retards_ignition_timing_more_aggressively_during_rapid_throttle_stabs._Real-World_Driving_Feel:_Completely_eliminates_tip-in_knock_and_pinging_on_gear_shifts_or_rapid_accelerator_stomps,_but_excessive_retard_causes_a_brief_'flat_spot'_or_delayed_power_delivery._Decreasing_Table_Values_(Less_Retard_per_DeltaTPS_):_Effect_on_Total_Timing:_Maintains_higher_ignition_advance_during_throttle_stabs._Real-World_Driving_Feel:_Delivers_explosive,_immediate_tip-in_acceleration_and_throttle_response._Highly_desirable_for_responsive_autocross_or_road_racing_applications,_provided_fuel_octane_or_water/methanol_injection_prevents_tip-in_detonation._Zeroing_Out_the_Table:_Setting_all_Y-axis_values_to_0x00_disables_TPS_transient_retard_completely_while_leaving_all_other_spark_tables_active.
    .byte 0x03                       ;Number of points in table
    .byte 0x05, 0x00, 0x01, 0x33     ;Point 1
    .byte 0x1E, 0x1E, 0x00, 0x72     ;Point 2
    .byte 0x4B, 0x32                 ;Point 3

	;.org	0xc079
RTMAPE_RetardFromTPSEnableAboveThisMAP:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x0230
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname RetardFromTPSEnableAboveThisMAP
    ;mptblcname RTMAPE
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc OVERVIEW:_RTMAPE_RetardFromTPSEnableAboveThisMAP_is_the_manifold_pressure_enable_threshold_for_the_Tip-In_/_Rapid_Throttle_Opening_Retard_routine_(CheckForTPSRetard)._When_an_engine_is_already_operating_under_positive_manifold_pressure_(boost)_and_the_driver_suddenly_snaps_the_throttle_open_further,_the_immediate_surge_of_air_into_the_intake_manifold_can_outpace_fuel_film_delivery_and_transient_enrichment,_causing_an_instantaneous_lean_spike._Under_boost,_a_momentary_lean_spike_paired_with_steady_ignition_advance_can_trigger_immediate_tip-in_knock._To_counter_this,_the_ECU_monitors_the_rate_of_throttle_opening_(_DeltaTPS_)_and_pulls_timing_instantaneously_via_RETTPS,_but_only_if_manifold_pressure_is_above_the_boost_threshold_defined_by_RTMAPE._|_TUNER'S_GUIDE:_Increasing_the_Value_(Higher_MAP_Threshold):_What_it_does:_Requires_higher_boost_pressure_before_rapid-throttle_ignition_retard_is_allowed_to_activate._Real-World_Driving_Feel:_Prevents_tip-in_retard_during_low-boost_throttle_adjustments,_providing_sharper_throttle_response._However,_setting_it_too_high_leaves_the_engine_unprotected_against_transient_tip-in_knock_under_moderate_boost._Decreasing_the_Value_(Lower_MAP_Threshold):_What_it_does:_Enables_transient_throttle_retard_at_lower_boost_levels_or_even_into_deep_vacuum._Real-World_Driving_Feel:_Enhances_knock_protection_during_aggressive_throttle_snaps,_but_setting_it_too_low_can_cause_a_noticeable_'bog'_or_hesitation_when_blipping_the_throttle._Disabling_TPS_Retard:_Setting_RTMAPE_to_0xFF_effectively_disables_the_entire_TPS_transient_retard_mechanism.
    ;mpmapaxis y
    .byte 0x93                       ;Point 1

	;.org	0xc07a
RTRPME_RetardFromTPSEnableAboveThisRPM:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x023E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RetardFromTPSEnableAboveThisRPM
    ;mptblcname RTRPME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 16384 rpm
    ;mptbldesc OVERVIEW:_RTRPME_RetardFromTPSEnableAboveThisRPM_defines_the_minimum_engine_speed_required_before_the_ECU_will_apply_ignition_timing_retard_on_rapid_throttle_openings_(CheckForTPSRetard)._At_very_low_engine_speeds_(below_~2,500_RPM),_engine_volumetric_efficiency_is_lower_and_turbocharger_transient_spool_is_slower,_so_tip-in_fueling_is_adequately_covered_by_base_acceleration_pump_shots._Furthermore,_pulling_ignition_timing_at_lower_engine_speeds_can_severely_impede_turbo_spool-up_and_cause_the_vehicle_to_bog_or_shudder._RTRPME_confines_the_rapid_TPS_retard_to_mid-_and_high-RPM_operations_where_turbocharger_response_is_instant_and_high_cylinder_pressures_make_tip-in_knock_a_critical_concern._|_TUNER'S_GUIDE:_Increasing_the_Value_(Higher_RPM_Threshold):_Effect_on_Total_Timing:_Delays_TPS_transient_retard_to_higher_RPMs._Real-World_Driving_Feel:_Improves_low-to-mid_RPM_throttle_responsiveness_and_off-corner_punch,_but_increases_knock_risk_if_aggressive_spool-up_occurs_around_2,500-3,000_RPM._Decreasing_the_Value_(Lower_RPM_Threshold):_Effect_on_Total_Timing:_Allows_TPS_transient_retard_to_trigger_at_lower_engine_speeds._Real-World_Driving_Feel:_Adds_knock_protection_for_fast-spooling_small_turbochargers_(such_as_stock_Garrett_T03_or_Mitsubishi_TE04H),_but_if_set_too_low,_can_cause_sluggish_tip-in_feel_during_low-speed_gear_shifts.
    .byte 0x27                       ;Point 1

	;.org	0xc07b
RTTPSE_RetardFromTPSEnableAboveThisTPS:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x024B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RetardFromTPSEnableAboveThisTPS
    ;mptblcname RTTPSE
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis TPS 0 5 V
    ;mptbldesc OVERVIEW:_RTTPSE_RetardFromTPSEnableAboveThisTPS_sets_the_minimum_baseline_throttle_position_voltage_required_before_rapid_throttle_opening_retard_can_be_engaged._Small_throttle_adjustments_around_idle_or_light_cruise_(such_as_minor_highway_speed_corrections)_do_not_create_significant_air_inrush_or_risk_tip-in_detonation._RTTPSE_prevents_the_transient_retard_logic_from_triggering_on_minor_pedal_movements,_requiring_the_throttle_to_already_be_open_to_a_moderate_baseline_position_(~31%_throttle_opening_/_1.57V)_before_rapid_stabs_can_pull_ignition_timing._|_TUNER'S_GUIDE:_Increasing_the_Value_(Higher_Baseline_TPS):_Effect_on_Total_Timing:_Restricts_TPS_transient_retard_to_transitions_occurring_higher_in_the_throttle_travel_range_(e.g.,_from_half-throttle_to_full-throttle)._Real-World_Driving_Feel:_Prevents_hesitation_during_mid-pedal_tip-ins._Decreasing_the_Value_(Lower_Baseline_TPS):_Effect_on_Total_Timing:_Allows_rapid_throttle_snaps_starting_from_lighter_pedal_positions_to_trigger_transient_timing_retard._Real-World_Driving_Feel:_Increases_knock_protection_when_stomping_the_throttle_from_light_cruise,_but_can_feel_laggy_if_set_too_low.
    .byte 0x50                       ;Point 1

	;.org	0xc07c
GOVNER_AdvanceFromRPM:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x0258
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AdvanceFromRPM2
    ;mptblcname GOVNER
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Spark_Advance 0 128 Degrees
    ;mptbldesc Simulates_the_mechanical_advance_function._Spark_Advance_is_added_from_this_table_from_RPMs_at_all_engine_temperatures._Added_to_MAP_based_advance____OVERVIEW:_GOVNER_AdvanceFromRPM_is_the_primary_engine_speed_advance_curve_(analogous_to_the_mechanical_/_centrifugal_advance_weights_in_a_traditional_distributor)._In_internal_combustion_engines,_the_time_available_for_the_air/fuel_charge_to_burn_decreases_proportionally_as_engine_RPM_increases._To_ensure_that_cylinder_pressure_peaks_at_the_optimal_mechanical_angle_(~14-17_deg_after_top_dead_center),_the_spark_plug_must_fire_earlier_in_the_compression_stroke_at_higher_engine_speeds._GOVNER_forms_the_core_foundation_of_total_ignition_timing_across_the_entire_operating_range,_to_which_MAP_load_advance_(HOTMAP_or_WOTMAP)_is_added._|_TUNER'S_GUIDE:_Because_GOVNER_is_an_additive_baseline_across_all_load_zones,_changes_to_GOVNER_shift_ignition_timing_across_both_part_throttle_and_wide-open_throttle:_Increasing_Table_Values_(Adding_RPM_Advance):_Effect_on_Total_Timing:_Advances_timing_across_the_specified_RPM_range_for_all_throttle_positions_and_boost_levels._Real-World_Driving_Feel:_Sharpens_throttle_response,_improves_high-RPM_power,_and_increases_overall_torque._Cautions:_Because_it_affects_both_WOT_and_cruising,_advancing_GOVNER_without_compensating_in_WOTMAP_can_push_WOT_boost_timing_into_detonation._Decreasing_Table_Values_(Pulling_RPM_Advance):_Effect_on_Total_Timing:_Retards_baseline_timing_across_the_board._Real-World_Driving_Feel:_Causes_softer_engine_response_and_higher_exhaust_gas_temperatures_(EGTs)._Idle_Stability:_At_idle_speeds_(800-1,200_RPM),_GOVNER_sets_the_idle_spark_timing._A_steeper_timing_slope_around_the_idle_target_helps_naturally_stabilize_idle_RPM_(engine_dips_->_timing_advances_->_torque_increases_to_recover_RPM).
    .byte 0x04                       ;Number of points in table
    .byte 0x20, 0x18, 0x01, 0x1C     ;Point 1
    .byte 0x32, 0x2C, 0x00, 0x00     ;Point 2
    .byte 0x71, 0x2C, 0x00, 0x33     ;Point 3
    .byte 0xA3, 0x36                 ;Point 4

	;.org	0xc08b
SKAPRD_SparkImmediateSwitchToRunAboveThisRpm:
    ;mpgrp Spark_-_Start_to_Run_Transfer\
    ;mptbladdr 0x0269
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname SparkImmediateSwitchToRunAboveThisRpm
    ;mptblcname SKAPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis EPPs 0 65535 epps
    ;mptbldesc Run_to_Start_transfer_point_for_spark____OVERVIEW:_SKAPRD_SparkImmediateSwitchToRunAboveThisRpm_is_the_instantaneous_engine_start-to-run_transfer_threshold._When_starting_a_car,_the_ECU_remains_in_a_dedicated_'Cranking_/_Start_Mode'_(running_locked_distributor_trigger_timing_and_fixed_cranking_fuel_pulse_widths)_until_the_engine_flares_to_life._Under_normal_cranking,_the_ECU_requires_the_engine_to_exceed_a_lower_threshold_(STRNTR,_~600_RPM)_for_a_set_number_of_consecutive_cylinder_pulses_(SRTIME)_before_transferring_to_'Run_Mode'._However,_if_the_engine_flares_violently_or_catches_immediately_and_revs_past_~800_RPM,_waiting_for_multiple_cylinder_pulses_is_unnecessary_and_could_delay_dynamic_spark_advance._SKAPRD_provides_an_immediate_bypass:_if_the_distributor_pulse_period_drops_below_SKAPRD_(speed_exceeds_~813_RPM),_the_ECU_switches_instantly_into_Run_Mode._|_TUNER'S_GUIDE:_Increasing_the_Value_(Lower_RPM_Threshold):_What_it_does:_Allows_a_lower_RPM_flare_to_trigger_immediate_Run_Mode._Real-World_Driving_Feel:_The_ECU_starts_controlling_dynamic_spark_advance_sooner_after_cranking._However,_if_set_too_low_(e.g.,_near_starter_cranking_speeds_of_300-400_RPM),_the_ECU_could_prematurely_switch_into_Run_Mode_during_a_slow,_struggling_crank,_causing_kickback_or_stalling._Decreasing_the_Value_(Higher_RPM_Threshold):_What_it_does:_Requires_the_engine_to_flare_higher_before_immediate_transfer_occurs._Real-World_Driving_Feel:_Forces_the_ECU_to_rely_on_the_consecutive_pulse_counters_(STRNTR_and_SRTIME),_which_can_make_cold_starts_feel_more_deliberate_but_may_slightly_delay_throttle_catch.
    .word 0x0092                     ;Point 1

	;.org	0xc08d
SRTIME_SparkEPPsNeededToBeAboveSR_Hot:
    ;mpgrp Spark_-_Start_to_Run_Transfer\
    ;mptbladdr 0x0276
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkEPPsNeededToBeAboveSR_Hot
    ;mptblcname SRTIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_consecutive_EPPs_needed_to_be_above_Start_Run_when_hot____OVERVIEW:_SRTIME_SparkEPPsNeededToBeAboveSR_Hot_defines_the_number_of_consecutive_Engine_Position_Pulses_(EPPs)_that_the_engine_must_maintain_above_the_start-to-run_speed_threshold_(STRNTR)_before_transferring_spark_control_to_Run_Mode_when_the_engine_is_warm/hot._When_starting_a_warm_engine,_cylinder_compression_is_consistent_and_combustion_catches_quickly._However,_a_single_cylinder_firing_during_a_crank_cycle_can_momentarily_whip_the_crankshaft_faster_than_600_RPM_before_slowing_down_again._SRTIME_ensures_that_the_engine_has_truly_caught_and_is_spinning_under_its_own_power_by_requiring_4_consecutive_distributor_sync_events_(two_full_crankshaft_revolutions_on_a_4-cylinder_engine)_above_STRNTR_before_locking_in_Run_Mode._|_TUNER'S_GUIDE:_Increasing_the_Value_(More_Pulses_Required):_What_it_does:_Keeps_the_engine_in_cranking_spark_mode_longer_when_warm._Real-World_Driving_Feel:_Can_help_prevent_premature_transfer_on_high-compression_or_alcohol_engines_that_exhibit_erratic_cranking_pulses,_but_setting_it_too_high_causes_sluggish_startup_flare_and_delayed_throttle_response._Decreasing_the_Value_(Fewer_Pulses_Required):_What_it_does:_Allows_the_ECU_to_switch_to_normal_running_advance_almost_instantly_once_the_engine_catches._Real-World_Driving_Feel:_Delivers_a_fast,_crisp_warm_restart._Stock_value_is_0x04_(4_pulses_=_1_complete_engine_cycle).
    .byte 0x04                       ;Point 1

	;.org	0xc08e
SRTIME2_SparkEPPsNeededToBeAboveSR_Cold:
    ;mpgrp Spark_-_Start_to_Run_Transfer\
    ;mptbladdr 0x0283
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkEPPsNeededToBeAboveSR_Cold
    ;mptblcname SRTIME2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_consecutive_EPPs_needed_to_be_above_Start_Run_when_cold____OVERVIEW:_SRTIME2_SparkEPPsNeededToBeAboveSR_Cold_defines_the_number_of_consecutive_Engine_Position_Pulses_(EPPs)_above_STRNTR_required_to_transfer_spark_control_into_Run_Mode_when_the_engine_is_cold._Cold_engines_suffer_from_thick_engine_oil_drag,_incomplete_fuel_vaporization,_and_uneven_cylinder-to-cylinder_combustion._A_cold_engine_can_experience_a_'false_start'_where_one_cylinder_fires_and_spins_the_engine_briefly,_only_to_stall_the_moment_cranking_enrichment_cuts_out._SRTIME2_allows_calibrators_to_set_a_distinct_pulse-count_requirement_for_cold_conditions_to_ensure_the_engine_is_fully_self-sustaining_before_switching_from_cranking_spark_to_running_spark._|_TUNER'S_GUIDE:_Increasing_the_Value_(More_Pulses):_What_it_does:_Demands_more_consecutive_pulses_above_600_RPM_before_allowing_cold_running_spark_tables_(CLDMAP)_to_engage._Real-World_Driving_Feel:_Prevents_cold_stall_on_start-up_in_freezing_weather_where_engines_tend_to_catch,_stumble,_and_die_if_transferred_to_run_spark_too_abruptly._Decreasing_the_Value_(Fewer_Pulses):_What_it_does:_Allows_the_ECU_to_transfer_to_cold_running_spark_almost_immediately_upon_firing._Real-World_Driving_Feel:_Faster_startup,_but_increases_the_chance_of_stalling_on_freezing_morning_cold_starts_if_base_fueling_is_lean.
    .byte 0x04                       ;Point 1

	;.org	0xc08f
SRTMTP_SparkTempSwitchPointFor_SRTIME:
    ;mpgrp Spark_-_Start_to_Run_Transfer\
    ;mptbladdr 0x0290
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SparkTempSwitchPointFor_SRTIME
    ;mptblcname SRTMTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Engine_Temperature_switch_point_for_SRTIME____OVERVIEW:_SRTMTP_SparkTempSwitchPointFor_SRTIME_is_the_coolant_temperature_switch_point_that_selects_between_the_hot_(SRTIME)_and_cold_(SRTIME2)_start-to-run_transfer_pulse_counters._It_establishes_what_the_ECU_considers_a_'warm_restart'_versus_a_'cold_start'_specifically_for_the_start-to-run_spark_transition._|_TUNER'S_GUIDE:_Increasing_the_Value_(Higher_Temp_Threshold):_What_it_does:_Classifies_warm_engines_as_'cold'_until_they_reach_a_higher_temperature._Real-World_Driving_Feel:_Applies_the_cold_pulse_counter_(SRTIME2)_across_a_wider_operating_temperature_range._Decreasing_the_Value_(Lower_Temp_Threshold):_What_it_does:_Allows_engines_that_are_still_lukewarm_to_use_the_warm_start_counter_(SRTIME)._Real-World_Driving_Feel:_Enables_faster_restarts_after_brief_heat_soaks.
    .byte 0xB0                       ;Point 1

	;.org	0xc090
STRNTR_SparkStartRunTransferPointRpm:
    ;mpgrp Spark_-_Start_to_Run_Transfer\
    ;mptbladdr 0x029D
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname SparkStartRunTransferPointRpm
    ;mptblcname STRNTR
    ;mpxaxis Coolant_Temp -200 260 Degrees
    ;mpyaxis DistOFs 0 65535 mSec
    ;mptbldesc Switch_Spark_To_Run_Mode_when_Inverse_RPMs_below_this_value._Stock_is_0x00c3_should_be_about_600_RPM____OVERVIEW:_STRNTR_SparkStartRunTransferPointRpm_defines_the_primary_engine_speed_threshold_required_to_transfer_from_Start_Mode_into_Run_Mode._During_starter_cranking,_engine_rotation_is_slow_(~150-250_RPM)_and_irregular._The_ECU_remains_in_cranking_mode,_holding_fixed_base_spark_timing_and_dwell_until_the_engine_catches_and_spins_up_past_STRNTR._Once_the_engine_crosses_above_STRNTR_(approximately_600_RPM)_for_the_duration_specified_by_SRTIME_or_SRTIME2,_the_ECU_formally_transitions_ignition_control_to_Run_Mode._|_TUNER'S_GUIDE:_Increasing_the_Value_(Lower_RPM_Threshold):_What_it_does:_Allows_the_engine_to_transfer_to_Run_Mode_at_a_lower_RPM_(e.g.,_500_RPM)._Real-World_Driving_Feel:_Enables_earlier_engagement_of_dynamic_spark_advance_and_idle_speed_AIS_stepper_motor_control._However,_setting_it_too_close_to_starter_cranking_speed_can_cause_premature_transfer_while_cranking,_resulting_in_starter_kickback_or_failure_to_catch._Decreasing_the_Value_(Higher_RPM_Threshold):_What_it_does:_Requires_the_engine_to_reach_a_higher_RPM_(e.g.,_700-800_RPM)_before_entering_Run_Mode._Real-World_Driving_Feel:_Ensures_the_engine_is_spinning_with_high_momentum_before_transferring,_but_if_set_higher_than_the_cold_flare_RPM,_the_engine_can_get_'stuck'_in_Start_Mode_and_fail_to_transition_into_normal_running.
    .word 0x00C3                     ;Point 1
       ;.byte   0xff
       ;.byte   0xff

	;.org	0xc09b
RNSTTR_SparkRunStartTransferPointRpm:
    ;mpgrp Spark_-_Start_to_Run_Transfer\
    ;mptbladdr 0x02AC
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname SparkRunStartTransferPointRpm
    ;mptblcname RNSTTR
    ;mpxaxis Coolant_Temp -200 260 Degrees
    ;mpyaxis DistOFs 0 65535 mSec
    ;mptbldesc Switch_Back_To_Spark_Start_Mode_if_Inverse_RPMs_increase_above_this_value._Stock_is_0x011b_should_be_about_410_RPM____OVERVIEW:_RNSTTR_SparkRunStartTransferPointRpm_is_the_stall-detection_hysteresis_threshold_that_drops_the_ECU_back_from_Run_Mode_into_Start_Mode._Once_the_engine_is_running_normally,_if_a_sudden_RPM_sag_occurs_(such_as_dropping_the_clutch_too_quickly,_a_severe_electrical_load,_or_stalling_out),_the_ECU_needs_to_recognize_that_the_engine_is_no_longer_sustaining_self-powered_rotation._If_engine_speed_falls_below_RNSTTR_(approximately_410_RPM),_the_ECU_disengages_dynamic_running_spark_advance_and_switches_back_to_cranking_Start_Mode_(fixed_base_timing_and_cranking_fuel_pulse_widths)_to_attempt_recovery_or_facilitate_immediate_restarting._|_TUNER'S_GUIDE:_Increasing_the_Value_(Lower_RPM_Threshold):_What_it_does:_Allows_the_engine_to_drop_lower_in_speed_(e.g.,_300_RPM)_before_conceding_that_it_has_stalled._Real-World_Driving_Feel:_Prevents_premature_switching_into_cranking_mode_when_lugging_the_engine_at_very_low_speeds,_but_can_cause_sluggish_recovery_if_the_engine_actually_dies._Decreasing_the_Value_(Higher_RPM_Threshold):_What_it_does:_Triggers_stall_recovery_/_cranking_mode_at_a_higher_speed_(e.g.,_500_RPM)._Real-World_Driving_Feel:_Drops_back_to_cranking_mode_sooner._If_set_too_high_(too_close_to_idle_speed),_an_abrupt_idle_dip_can_trigger_cranking_mode,_causing_a_sudden_surge_or_stall.
    .word 0x011B                     ;Point 1
       ;.byte   0xff
       ;.byte   0xff

	;.org	0xc0a1
SPKLMT_TotalAdvanceAllowed:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x02BB
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AdvanceFromRpmMAX
    ;mptblcname SPKLMT
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Spark_Advance -64 64 Degrees
    ;mptbldesc OVERVIEW:_SPKLMT_TotalAdvanceAllowed_is_the_hard_maximum_ceiling_curve_on_total_ignition_timing_across_engine_speed._Under_light_throttle_cruising_in_deep_vacuum_(high_HOTMAP_advance)_combined_with_high_RPM_(high_GOVNER_advance),_the_theoretical_mathematical_sum_of_RPM_timing_plus_MAP_advance_could_exceed_50_deg_to_60_deg_of_advance._Running_excessive_timing-even_under_very_light_load-can_cause_misfires,_cross-firing_in_the_distributor_cap,_rotor_phasing_alignment_problems,_and_negative_work_on_the_piston_during_compression._SPKLMT_acts_as_a_final_safety_limiter:_if_the_total_combined_ignition_timing_exceeds_the_value_in_SPKLMT_at_that_RPM,_it_is_clamped_down_to_SPKLMT._|_TUNER'S_GUIDE:_Increasing_Table_Values_(Raising_the_Ceiling):_Effect_on_Total_Timing:_Allows_higher_total_timing_during_light-load_high-RPM_highway_cruising._Real-World_Driving_Feel:_Can_improve_fuel_economy_slightly_on_light_cruise,_but_gains_diminish_past_~42-45_deg_on_typical_8-valve_2.2L/2.5L_combustion_chambers._Decreasing_Table_Values_(Lowering_the_Ceiling):_Effect_on_Total_Timing:_Imposes_a_lower_absolute_cap_on_timing_across_all_operating_conditions._Real-World_Driving_Feel:_Prevents_rotor_crossfire_and_ensures_safety,_but_setting_it_too_low_(e.g.,_<35_deg_at_3,000_RPM)_caps_part-throttle_cruising_advance_prematurely,_hurting_fuel_economy_and_increasing_cruise_exhaust_gas_temperatures._Stock_Curve_Reference:_In_stock_calibrations,_SPKLMT_starts_around_24-28_deg_at_low_RPM_and_ramps_up_to_roughly_42-46_deg_at_3,200+_RPM.
    .byte 0x02                       ;Number of points in table
    .byte 0x7D, 0x6A, 0xFF, 0x9E     ;Point 1
    .byte 0xDB, 0x46                 ;Point 2

	;.org	0xc0a8
PNIDLE_AdvanceRemovedIdleParkNeutral:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x02CA
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname AdvanceRemovedIdleParkNeutral
    ;mptblcname PNIDLE
    ;mpxaxis Coolant_Temperature -200 260 F
    ;mpyaxis Spark_Advance -64 64 Degrees
    ;mptbldesc Not_used____OVERVIEW:_PNIDLE_AdvanceRemovedIdleParkNeutral_provides_a_coolant_temperature-dependent_spark_advance_trim_applied_specifically_when_an_automatic_transmission_vehicle_is_in_Park_or_Neutral_at_idle_speeds._In_automatic_transmission_vehicles,_placing_the_shifter_into_Drive_or_Reverse_engages_the_torque_converter_and_applies_continuous_parasitic_drag_load_to_the_crankshaft._Conversely,_when_shifted_into_Park_or_Neutral,_this_parasitic_load_is_removed,_causing_engine_manifold_vacuum_to_deepen_and_idle_speed_to_flare_unless_timing_and_airflow_are_trimmed._PNIDLE_modifies_ignition_timing_as_a_function_of_coolant_temperature_to_smooth_out_gear_engagement_transitions_(Park-to-Drive_/_Drive-to-Park)._|_TUNER'S_GUIDE:_Increasing_Table_Values_(Adding_Timing_in_Park/Neutral):_Effect_on_Total_Timing:_Advances_idle_timing_when_in_Park_or_Neutral._Real-World_Driving_Feel:_Raises_idle_RPM_and_increases_vacuum_in_Park/Neutral._If_set_too_high,_will_cause_a_noticeable_idle_'thump'_or_flare_when_shifting_into_Park_or_Neutral_from_Drive._Decreasing_Table_Values_(Pulling_Timing_in_Park/Neutral):_Effect_on_Total_Timing:_Retards_idle_timing_in_Park/Neutral._Real-World_Driving_Feel:_Calms_idle_flare_when_coming_out_of_gear,_making_the_transition_from_In-Gear_to_Park/Neutral_feel_seamless_and_controlled._Manual_Transmission_(MTX)_Calibrations:_In_manual_transmission_calibrations_(such_as_the_A171_stock_MTX_calibration),_the_Park/Neutral_switch_circuit_is_typically_tied_to_clutch/ground_or_ignored,_however,_the_table_remains_defined_in_the_template_for_architecture_parity_across_ATX/MTX_calibrations.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0xc0af
PNRPM_EngineSpeedBelowWhich_PNIDLE_Enabled:
    ;mpgrp Spark_-_Normal_Advance\
    ;mptbladdr 0x02D8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineSpeedBelowWhich_PNIDLE_Enabled
    ;mptblcname PNRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 16384 RPM
    ;mptbldesc Engine_speed_below_which_PNIDLE_is_Enabled_-_for_Automatics____OVERVIEW:_PNRPM_EngineSpeedBelowWhich_PNIDLE_Enabled_establishes_the_maximum_engine_speed_threshold_below_which_the_Park/Neutral_idle_spark_modifier_(PNIDLE)_is_permitted_to_operate._Park/Neutral_spark_compensation_is_designed_strictly_for_low-RPM_idle_stabilization._If_an_automatic_transmission_vehicle_is_shifted_into_Neutral_while_coasting_at_speed_or_while_free-revving_the_engine,_applying_idle-specific_Park/Neutral_timing_trims_at_elevated_RPM_could_disrupt_engine_braking_or_cause_erratic_timing_shifts._PNRPM_acts_as_an_RPM_ceiling_to_ensure_that_Park/Neutral_trims_are_applied_only_within_the_expected_idle_window._|_TUNER'S_GUIDE:_Increasing_the_Value_(Higher_RPM_Threshold):_Effect_on_Total_Timing:_Extends_Park/Neutral_idle_spark_trims_to_higher_engine_speeds._Real-World_Driving_Feel:_Useful_on_engines_with_very_high_target_idle_speeds_(such_as_race_engines_with_large_cams_idling_at_1,200-1,500_RPM)_to_ensure_the_ECU_still_recognizes_the_engine_as_being_within_the_idle_timing_zone._Decreasing_the_Value_(Lower_RPM_Threshold):_Effect_on_Total_Timing:_Disables_Park/Neutral_trims_at_lower_speeds._Stock_Setting_Note:_In_many_factory_calibrations,_PNRPM_is_set_to_0x01_or_small_values_to_tightly_constrain_or_disable_this_modifier_in_specific_configurations.
    .byte 0x01                       ;Point 1

	;.org	0xc0b0
KNKRPM_MinRpmforKnockRetard:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x02E5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinRpmforKnockRetard
    ;mptblcname KNKRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 16384 RPM
    ;mptbldesc Minimum_RPM_for_Knock_Retard____OVERVIEW:_KNKRPM_MinRpmforKnockRetard_sets_the_minimum_engine_speed_required_for_the_ECU_to_activate_knock_retard._At_idle_and_very_low_engine_speeds_(below_~1,000_RPM),_mechanical_valvetrain_chatter,_piston_slap_in_cold_forged_pistons,_and_accessory_vibration_can_generate_acoustic_noise_resembling_detonation._Furthermore,_true_combustion_detonation_under_light_load_at_low_RPM_is_virtually_non-existent_on_properly_tuned_engines._KNKRPM_disables_knock_sensor-driven_ignition_retard_below_this_engine_speed_to_prevent_false_knock_triggers_from_destabilizing_engine_idle._|_TUNER'S_GUIDE:_Increasing_the_Value_(Higher_RPM_Threshold):_What_it_does:_Knock_retard_will_remain_disabled_up_to_a_higher_RPM_(e.g.,_0x14_=_1,280_RPM)._Real-World_Driving_Feel:_Prevents_false_knock_retard_caused_by_noisy_mechanical_valve_gear,_aggressive_solid_lifters,_or_lightweight_flywheel_rattle_at_low_speeds._Decreasing_the_Value_(Lower_RPM_Threshold):_What_it_does:_Allows_knock_retard_to_activate_closer_to_idle_speeds._Real-World_Driving_Feel:_Risky_on_older_engines,_mechanical_noise_can_trick_the_ECU_into_pulling_timing_at_idle,_leading_to_idle_hunting,_stalling,_or_erratic_off-idle_stumble._Stock_Value:_0x10_equals_16_64_=_1,024_RPM_,_perfectly_clearing_normal_idle_speeds_(800-950_RPM).
    .byte 0x10                       ;Point 1

	;.org	0xc0b1
KNKOFS_DeltaAboveBaroFor_RTRDRT_and_KNKCNT_and_KNKCOR_incremented:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x02F2
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaAboveBaroFor_RTRDRT_and_KNKCNT_and_KNKCOR_incremented
    ;mptblcname KNKOFS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc Delta_above_Baro_up_to_which_RTRDRT_(Retard_Rate)_is_used_and_KNKCNT_and_KNKCOR_are_incremented._Stock_is_5.4_psi.____OVERVIEW:_KNKOFS_DeltaAboveBaroFor_RTRDRT_and_KNKCNT_and_KNKCOR_incremented_is_the_manifold_pressure_boost_threshold_dividing_knock_retard_response_into_Vacuum_/_Low_Boost_Mode_versus_High_Boost_Mode._Combustion_knock_occurring_at_light_load_or_moderate_boost_requires_a_different_corrective_approach_than_severe_detonation_occurring_under_high_turbocharger_boost._When_knock_occurs_below_KNKOFS_(less_than_~5.4_psi_of_boost),_the_ECU_applies_larger_retard_steps_(RTRDRT)_to_rapidly_snuff_out_the_knock._When_manifold_pressure_exceeds_barometric_pressure_plus_KNKOFS_(higher_boost),_the_ECU_transitions_to_RTRDRT2_and_increments_the_boost_knock_counter_(Counter_Over5psiBoost)._|_TUNER'S_GUIDE:_Increasing_the_Value_(Higher_Boost_Threshold):_What_it_does:_Extends_the_low-boost_retard_rate_(RTRDRT)_to_higher_boost_levels._Real-World_Driving_Feel:_Pulls_larger_chunks_of_timing_if_knock_occurs_in_the_5-8_psi_transition_zone._Decreasing_the_Value_(Lower_Boost_Threshold):_What_it_does:_Engages_the_boost_knock_retard_rate_(RTRDRT2)_earlier._Stock_Setting:_0x2F_corresponds_to_~_5.4_psi_above_ambient_barometric_pressure_on_a_2-bar_MAP_sensor.
    ;mpmapaxis y
    .byte 0x2F                       ;Point 1

	;.org	0xc0b2
RTRDRT_KnockRetardRateNoBoost:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x0300
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardRateNoBoost
    ;mptblcname RTRDRT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Deg 0 128 Degrees
    ;mptbldesc Retard_rate_from_Knock,_no_boost._In_half_degreesn____OVERVIEW:_RTRDRT_KnockRetardRateNoBoost_defines_the_step-size_of_knock_retard_applied_when_knock_occurs_out_of_boost_(under_vacuum_or_light_load_below_KNKOFS)._When_detonation_occurs_at_light_load_or_part-throttle_vacuum,_cylinder_filling_is_low_and_pulling_a_substantial_step_of_timing_(3.0_deg_in_stock_calibrations)_quickly_snuffs_out_the_knock_event_without_significantly_impacting_drivability_or_torque._|_TUNER'S_GUIDE:_Increasing_the_Value_(Larger_Retard_Step):_Effect_on_Total_Timing:_Pulls_more_timing_(e.g.,_4.0_deg_or_5.0_deg)_on_the_very_first_knock_event._Real-World_Driving_Feel:_Extremely_fast_knock_suppression,_but_large_timing_drops_under_light_load_can_cause_a_brief_momentary_surge_or_hiccup_in_vehicle_feel._Decreasing_the_Value_(Smaller_Retard_Step):_Effect_on_Total_Timing:_Pulls_smaller_timing_increments_(e.g.,_1.5_deg_or_2.0_deg)._Real-World_Driving_Feel:_Smoother_recovery_from_light-load_knock,_but_if_fuel_octane_is_poor,_multiple_consecutive_knock_events_may_occur_before_timing_is_retarded_sufficiently.
    .byte 0x06                       ;Point 1

	;.org	0xc0b3
RTRDRT2_KnockRetardRateInBoost:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x030D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardRateInBoost
    ;mptblcname RTRDRT2
    ;mpxaxis IN 0 255 X
    ;mpyaxis Retard 0 128 deg
    ;mptbldesc OVERVIEW:_RTRDRT2_KnockRetardRateInBoost_defines_the_step-size_of_knock_retard_applied_when_knock_occurs_under_boost_(above_KNKOFS)._Under_positive_manifold_pressure_(boost),_pulling_huge_chunks_of_timing_abruptly_(such_as_3_deg_or_4_deg_in_a_single_cylinder_firing)_can_cause_a_violent_power_drop,_severe_torque_oscillation_through_the_drivetrain,_and_skyrocket_exhaust_gas_temperatures_(EGTs)._To_manage_boost_detonation_smoothly_while_preserving_power_delivery,_RTRDRT2_uses_a_finer_step_size_(1.5_deg_in_stock_calibrations)_applied_sequentially_to_each_knocking_cylinder._|_TUNER'S_GUIDE:_Increasing_the_Value_(Larger_Retard_Step_in_Boost):_Effect_on_Total_Timing:_Pulls_more_timing_(e.g.,_2.0_deg_or_2.5_deg)_on_each_knock_event_under_boost._Real-World_Driving_Feel:_Highly_protective_for_high-boost_setups_(18+_psi)_where_detonation_can_crack_piston_ring_lands_in_just_a_few_cycles,_but_may_feel_slightly_harsher_when_knock_occurs._Decreasing_the_Value_(Finer_Retard_Step_in_Boost):_Effect_on_Total_Timing:_Pulls_smaller_increments_(e.g.,_1.0_deg)._Real-World_Driving_Feel:_Extremely_smooth_power_delivery_without_sudden_torque_drops,_but_requires_the_calibration_to_be_very_close_to_optimal_so_small_retard_steps_are_sufficient_to_quell_knock.
    .byte 0x03                       ;Point 1

	;.org	0xc0b4
INCSRT_KnockRetardIncreaseRate:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x031A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KnockRetardIncreaseRate
    ;mptblcname INCSRT
    ;mpxaxis in_desc 0 255 retard
    ;mpyaxis Y 0 128 deg
    ;mptbldesc Increase_Rate._Recovery_from_Knock_Retard._Rate_is_1/2_engine_degree_every_INCSRT+1_*_11ms._Use_ONLY_0,1,3,7,f,1f,3f,7f_or_ff____OVERVIEW:_INCSRT_KnockRetardIncreaseRate_controls_the_decay_rate_/_recovery_rate_of_ignition_timing_after_a_knock_event_has_ended._When_the_ECU_detects_knock,_it_retards_ignition_timing_immediately._Once_detonation_ceases,_the_ECU_must_gradually_return_(decay)_the_timing_back_toward_the_normal_advance_curve._If_timing_is_returned_too_quickly,_the_engine_will_immediately_re-detonate,_if_returned_too_slowly,_the_vehicle_remains_sluggish_with_elevated_exhaust_temperatures_long_after_the_knock_event_has_passed._INCSRT_acts_as_a_loop_counter_bitmask:_every_time_the_main_loop_timer_matches_this_mask,_the_ECU_restores_0.5_deg_of_timing_to_each_cylinder_until_all_knock_retard_has_decayed_to_zero._|_TUNER'S_GUIDE:_>_[!WARNING]_>_Bitmask_Rule:_INCSRT_is_a_binary_bitmask._It_MUST_ONLY_be_set_to_binary_power-of-two_minus_one_values:_0x00,_0x01,_0x03,_0x07,_0x0F,_0x1F,_0x3F,_0x7F,_or_0xFF._Using_intermediate_values_(e.g.,_0x10)_will_cause_erratic,_non-uniform_timing_recovery_rates._Increasing_the_Value_(Larger_Mask_/_Slower_Recovery):_Effect:_Timing_decays_more_slowly_(recovers_fewer_degrees_per_second)._Real-World_Driving_Feel:_Prevents_repeat_detonation_after_severe_knock_events,_but_leaves_the_engine_in_a_retarded_state_longer._Decreasing_the_Value_(Smaller_Mask_/_Faster_Recovery):_Effect:_Timing_recovers_more_rapidly_back_to_base_advance._Real-World_Driving_Feel:_Restores_full_horsepower_quickly_after_transient_knock_(such_as_a_bad_gear_shift_or_fuel_splash),_but_risks_rapid_cyclic_re-knock_if_the_underlying_cause_is_low_fuel_octane._Stock_Rate:_Mask_0x1F_triggers_once_every_32_program_loops._At_~11_ms_per_loop,_timing_recovers_at_0.5_deg_every_~352_milliseconds_(~1.4_deg_per_second).
    .byte 0x1F                       ;Point 1

	;.org	0xc0b5
KNKLIM_MaxKnockRetard:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x0327
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxKnockRetard
    ;mptblcname KNKLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Retard 0 128 Degrees
    ;mptbldesc Knock_Limit_in_1/2_degrees._MaxRetard_=_KNKLIM_if_throttle_is_above_THRKNK_and_RPM_is_below_KLMRPM____OVERVIEW:_KNKLIM_MaxKnockRetard_specifies_the_maximum_ceiling_on_knock_retard_applied_during_low-speed_transient_throttle_transitions._When_accelerating_from_low_RPM_with_significant_throttle_input,_sudden_mechanical_load_and_engine_movement_can_rattle_engine_mounts_or_exhaust_heat_shields,_creating_mechanical_noise_spikes._Under_these_low-RPM,_high-throttle_conditions_(below_KLMRPM_with_throttle_delta_above_THRKNK),_KNKLIM_caps_the_maximum_allowable_knock_retard_to_a_modest_limit_(2.0_deg_in_stock_calibrations)_to_prevent_false_vibration_from_triggering_excessive,_bog-inducing_retard._|_TUNER'S_GUIDE:_Increasing_the_Value_(Higher_Low-RPM_Retard_Cap):_Effect:_Allows_more_timing_to_be_pulled_during_low-RPM_tip-in_if_knock_is_detected._Real-World_Driving_Feel:_Extra_safety_if_an_engine_experiences_low-RPM_tip-in_detonation_under_heavy_load,_but_risks_deeper_hesitation_if_false_knock_occurs._Decreasing_the_Value_(Lower_Low-RPM_Retard_Cap):_Effect:_Restricts_how_much_timing_can_be_pulled_at_low_RPM._Real-World_Driving_Feel:_Prevents_low-RPM_bogs_caused_by_false_knock_from_noisy_valvetrain_or_engine_mounts.
    .byte 0x04                       ;Point 1

	;.org	0xc0b6
THRKNK_DeltaAbove_MINTHR:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x0334
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaAbove_MINTHR
    ;mptblcname THRKNK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis TPS 0 5 Volts
    ;mptbldesc Delta_above_MINTHR_for_knock_detect____OVERVIEW:_THRKNK_DeltaAbove_MINTHR_defines_the_throttle_opening_threshold_above_base_idle_position_required_to_trigger_the_low-RPM_knock_retard_limit_(KNKLIM)._The_ECU_tracks_the_minimum_historical_TPS_voltage_recorded_during_the_driving_session_(MINTHR_LowestSessionTPS)._When_the_throttle_is_opened_beyond_MINTHR_by_more_than_THRKNK_while_operating_below_KLMRPM,_the_ECU_activates_the_low-RPM_knock_protection_ceiling._|_TUNER'S_GUIDE:_Increasing_the_Value_(Higher_Throttle_Delta):_Requires_a_larger_throttle_opening_before_the_low-RPM_KNKLIM_clamp_activates,_allowing_the_standard_RETMAX_curve_to_operate_over_a_broader_throttle_range._Decreasing_the_Value_(Lower_Throttle_Delta):_Engages_the_low-RPM_KNKLIM_retard_clamp_on_lighter_pedal_movements._Stock_Setting:_0x53_equals_(83_/_255)_5.0V_~_1.63_Volts_above_minimum_idle_TPS.
    .byte 0x53                       ;Point 1

	;.org	0xc0b7
KLMRPM_MinKnockDetectRpm:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x0341
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinKnockDetectRpm
    ;mptblcname KLMRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 8192 RPM
    ;mptbldesc RPMS_for_Knock____OVERVIEW:_KLMRPM_MinKnockDetectRpm_is_the_engine_speed_ceiling_for_the_low-RPM_knock_retard_clamp_(KNKLIM)._While_KNKRPM_completely_turns_off_knock_retard_below_1,024_RPM,_KLMRPM_establishes_the_transition_boundary_where_the_ECU_switches_from_the_restricted_low-RPM_knock_ceiling_(KNKLIM)_to_the_full_dynamic_knock_retard_table_(RETMAX)._|_TUNER'S_GUIDE:_Increasing_the_Value_(Higher_RPM_Threshold):_Extends_the_restricted_low-RPM_knock_clamp_(KNKLIM)_to_higher_engine_speeds_(e.g.,_1,500_or_2,000_RPM)._Useful_for_heavily_cammed_or_mechanically_noisy_engines_where_false_knock_causes_power_hesitation_during_lower_gear_acceleration._Decreasing_the_Value_(Lower_RPM_Threshold):_Allows_the_full_RETMAX_curve_to_take_effect_at_lower_RPMs,_providing_maximum_knock_retard_protection_sooner.
    .byte 0x10                       ;Point 1

	;.org	0xc0b8
RETMAX_MaxKnockRetardFromMap:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x034E
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname MaxKnockRetardFromMap
    ;mptblcname RETMAX
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Max_Retard 0 128 degrees
    ;mptbldesc Maximum_Knock_Retard_from_Map____OVERVIEW:_RETMAX_MaxKnockRetardFromMap_defines_the_maximum_allowable_knock_retard_ceiling_as_a_function_of_intake_manifold_pressure._Under_heavy_turbocharger_boost,_persistent_detonation_is_destructive_and_can_quickly_lead_to_engine_failure._To_protect_the_engine_under_severe_knock,_the_ECU_must_be_authorized_to_pull_significant_timing_(up_to_10.5_deg_or_more_in_stock_calibrations)._Conversely,_under_high_vacuum_or_light_load,_allowing_massive_knock_retard_would_be_counterproductive,_potentially_causing_combustion_to_flame_out_into_the_exhaust._RETMAX_scales_the_maximum_permissible_knock_retard_proportionally_with_manifold_pressure._|_TUNER'S_GUIDE:_Increasing_Table_Values_(Higher_Retard_Ceiling):_Effect_on_Total_Timing:_Gives_the_knock_control_system_authority_to_pull_more_total_timing_under_heavy_boost_if_detonation_persists._Real-World_Driving_Feel:_Crucial_safety_protection_when_pushing_high_boost_levels_(15-25+_psi)_on_pump_gasoline._Decreasing_Table_Values_(Lower_Retard_Ceiling):_Effect_on_Total_Timing:_Restricts_the_maximum_amount_of_timing_that_knock_retard_can_remove._Real-World_Driving_Feel:_Prevents_excessive_loss_of_power_if_false_knock_occurs,_but_leaves_the_engine_vulnerable_to_melted_pistons_if_real_detonation_is_present.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x56, 0x04, 0x00, 0xA7     ;Point 1
    .byte 0x70, 0x15                 ;Point 2

	;.org	0xc0bf
DLTKNK_KnockFromRpms:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x035E
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname KnockSensorVoltageForKnock_FromRpm
    ;mptblcname DLTKNK
    ;mpxaxis RPM 0 16384 rpm
    ;mpyaxis A2D 0 5 volts
    ;mptbldesc Input_from_the_knock_sensor_that_is_above_this_voltage_is_considered_Knock.____OVERVIEW:_DLTKNK_KnockFromRpms_is_the_knock_sensor_sensitivity_/_noise_threshold_curve_across_engine_RPM._A_piezoelectric_knock_sensor_mounted_to_the_engine_block_converts_engine_vibrations_into_an_AC_voltage_signal,_which_the_ECU_rectifies_and_reads_through_an_analog-to-digital_(A/D)_converter._Normal_mechanical_engine_noise_(valvetrain_action,_piston_motion,_rod_bearing_clearance)_naturally_increases_with_engine_speed._To_prevent_normal_mechanical_noise_from_falsely_triggering_knock_retard_at_high_RPM,_DLTKNK_establishes_the_baseline_noise_floor:_any_knock_sensor_voltage_reading_above_the_curve_at_that_RPM_is_flagged_as_real_combustion_detonation._|_TUNER'S_GUIDE:_Increasing_Table_Values_(Raising_the_Noise_Threshold):_What_it_does:_Desensitizes_the_knock_sensor._Requires_higher_vibration_amplitude_before_knock_is_flagged._Real-World_Driving_Feel:_Eliminates_false_knock_retard_caused_by_noisy_mechanical_modifications_(forged_pistons_with_loose_piston-to-wall_clearance,_aggressive_camshaft_profiles,_solid_lifters,_stiff_valvetrain_springs,_or_straight-cut_timing_gears)._Cautions:_Setting_the_curve_too_high_blinds_the_ECU_to_real_detonation,_risking_engine_damage_without_any_protective_timing_retard!_Decreasing_Table_Values_(Lowering_the_Noise_Threshold):_What_it_does:_Makes_the_knock_detection_system_more_sensitive._Real-World_Driving_Feel:_Catches_faint,_low-level_detonation_early,_but_risks_false_knock_retard_on_noisy_older_engines.
    .byte 0x05                       ;Number of points in table
    .byte 0x1F, 0x10, 0x00, 0xD0     ;Point 1
    .byte 0x2F, 0x1D, 0x02, 0xC0     ;Point 2
    .byte 0x3F, 0x49, 0x04, 0xF0     ;Point 3
    .byte 0x4F, 0x98, 0x01, 0x90     ;Point 4
    .byte 0x5F, 0xB1                 ;Point 5

	;.org	0xc0d2
FWDARP_SubtractedFromRPMDuringIdleRoutine:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x0370
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname SubtractedFromRPMDuringIdleRoutine
    ;mptblcname FWDARP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_FWDARP_SubtractedFromRPMDuringIdleRoutine_defines_the_forward_RPM_deadband_offset_for_the_ECU's_rapid_idle_speed_stabilization_system._While_the_Automatic_Idle_Speed_(AIS)_stepper_motor_provides_bulk_airflow_adjustments_for_idle_speed_control,_mechanical_stepper_motors_react_slowly_(hundreds_of_milliseconds)._To_achieve_rock-solid_idle_stability,_Chrysler_employs_rapid_ignition_timing_and_dwell_dithering_(often_called_'Spark_Scatter'):_if_idle_RPM_surges_above_target,_timing_is_retarded_instantaneously,_if_RPM_dips_below_target,_timing_is_advanced_immediately._FWDARP_establishes_the_positive_RPM_deadband_threshold_(stock_~30_RPM_above_target)_that_must_be_exceeded_before_over-speed_timing_corrections_are_engaged._|_TUNER'S_GUIDE:_Increasing_the_Value_(Wider_Deadband):_Allows_idle_RPM_to_fluctuate_further_above_target_before_timing_is_trimmed._Real-world_feel:_Useful_for_aggressive_aftermarket_camshafts_that_naturally_produce_lumpy_idle_pulses,_preventing_the_ECU_from_fighting_the_camshaft's_natural_lope._Decreasing_the_Value_(Tighter_Deadband):_Causes_immediate_timing_retards_on_the_slightest_upward_RPM_deviation._Real-world_feel:_Ultra-tight_idle_RPM_control_on_stock_engines,_but_can_cause_hunting/surging_on_modified_engines.
    .word 0x001E                     ;Point 1

	;.org	0xc0d4
REVARP_AddedBackToRPMDuringIdleRoutine:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x037D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AddedBackToRPMDuringIdleRoutine
    ;mptblcname REVARP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_REVARP_AddedBackToRPMDuringIdleRoutine_defines_the_reverse_(underspeed)_RPM_deadband_offset_for_the_idle_timing_stabilization_system._If_the_engine_speed_dips_below_target_idle,_adding_REVARP_back_to_the_negative_error_term_determines_whether_the_RPM_drop_is_severe_enough_to_warrant_immediate_timing_advance_to_catch_the_engine_and_prevent_an_impending_stall._|_TUNER'S_GUIDE:_Increasing_the_Value_(Wider_Deadband):_Tolerates_larger_RPM_drops_before_kicking_in_idle_advance._Real-world_feel:_Smooths_out_lumpy_cam_idle,_but_reduces_stall_protection_if_the_A/C_compressor_or_power_steering_engages_suddenly._Decreasing_the_Value_(Tighter_Deadband):_Kicks_in_advance_immediately_on_tiny_RPM_drops._Real-world_feel:_Instant_catch_when_coming_off_throttle_or_when_loads_engage,_but_can_cause_cyclic_hunting_on_modified_engines.
    .byte 0x1E                       ;Point 1

	;.org	0xc0d5
Idle_word_A:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x038A
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname Idle_word_A
    ;mptblcname IDLWA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_Idle_word_A_(IDLWA)_is_an_internal_calibration_structure_word_utilized_by_the_ECU's_distributor_timer_and_dwell_scheduler_during_closed-throttle_idle_stabilization._Together_with_Idle_bytes_A,_Idle_word_B,_and_Idle_bytes_B,_it_forms_a_fixed_parameter_table_referenced_by_index_registers_during_the_16-bit_timer_output_compare_operations_that_calculate_ignition_coil_dwell_and_spark_timing_offsets_at_idle._|_TUNER'S_GUIDE:_Tuning_Recommendation:_DO_NOT_MODIFY._These_hardware-specific_timer_coefficients_govern_the_low-level_interrupt_latency_and_dwell_scheduling_of_the_6803_microcontroller's_internal_timer_hardware._Changing_these_values_will_corrupt_idle_coil_charging_and_cause_ignition_misfires.
    .word 0x16BC                     ;Point 1

	;.org	0xc0d7
Idle_bytes_A:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x0397
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Idle_bytes_A
    ;mptblcname IDLBA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_Idle_bytes_A_(IDLBA)_is_a_companion_byte_constant_to_Idle_word_A_in_the_ECU's_idle_timer_parameter_block._It_provides_offset_scaling_for_the_closed-throttle_ignition_dwell_timer._|_TUNER'S_GUIDE:_Tuning_Recommendation:_DO_NOT_MODIFY._Factory_calibrated_at_0x00._Modifying_this_value_risks_desynchronizing_idle_coil_dwell_charging.
    .byte 0x00                       ;Point 1

	;.org	0xc0d8
Idle_word_B:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x03A4
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname Idle_word_B
    ;mptblcname IDLWB
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_Idle_word_B_(IDLWB)_is_the_secondary_timer_coefficient_word_in_the_idle_ignition_dwell_calculation_structure._It_pairs_with_Idle_word_A_to_define_timing_boundaries_for_low-speed_spark_generation._|_TUNER'S_GUIDE:_Tuning_Recommendation:_DO_NOT_MODIFY._These_values_represent_fixed_hardware_execution_timings_for_the_microcontroller's_internal_timer_registers.
    .word 0x0B5E                     ;Point 1

	;.org	0xc0da
Idle_bytes_B:
    ;mpgrp Spark_-_Knock_Retard\
    ;mptbladdr 0x03B1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Idle_bytes_B
    ;mptblcname IDLBB
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_Idle_bytes_B_(IDLBB)_is_the_companion_byte_constant_to_Idle_word_B_in_the_ECU's_idle_timer_parameter_block._|_TUNER'S_GUIDE:_Tuning_Recommendation:_DO_NOT_MODIFY._Factory_calibrated_at_0x00._Modifying_this_value_risks_corrupting_low-speed_ignition_coil_charging.
    .byte 0x00                       ;Point 1

	;.org	0xc0db
FTUNPW_FineTuneStepForAis:
    ;mpgrp Spark_-_Scatter_Control\
    ;mptbladdr 0x03BE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FineTuneStepForAis
    ;mptblcname FTUNPW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Fine_Tune_Step_for_AIS_for_spark_scatter____OVERVIEW:_FTUNPW_FineTuneStepForAis_is_the_enable_switch_and_step-size_multiplier_for_spark_scatter_idle_stabilization._During_closed-throttle_idle,_when_engine_RPM_deviates_outside_the_neutral_deadband_(FWDARP_and_REVARP),_the_ECU_applies_high-speed_ignition_timing_dithering_to_stabilize_engine_speed._FTUNPW_dictates_the_incremental_step_size_applied_by_the_spark_scatter_algorithm_on_each_correction_pass._|_TUNER'S_GUIDE:_Setting_to_0x00_(Disable_Spark_Scatter):_Disables_spark_scatter_completely._Real-world_feel:_The_ECU_will_rely_100%_on_the_mechanical_AIS_stepper_motor_for_idle_speed_control._Highly_recommended_by_tuners_when_running_aggressive_high-overlap_camshafts_or_lightweight_flywheels,_where_spark_scatter_dithering_can_cause_the_engine_to_'hunt'_or_rhythmically_surge._Stock_Setting_(0x01):_Enables_standard_1-step_spark_scatter._Provides_rapid,_imperceptible_idle_corrections_on_stock_or_mild_street_camshafts._Increasing_Value_(>_0x01):_Multiplies_the_timing_correction_step_size._Can_induce_severe_idle_surging_if_the_engine_responds_quickly_to_timing_shifts.
    .byte 0x01                       ;Point 1

	;.org	0xc0dc
SSIPRD_ScatterInhibitBelowThisSpeed:
    ;mpgrp Spark_-_Scatter_Control\
    ;mptbladdr 0x03CB
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ScatterInhibitBelowThisSpeed
    ;mptblcname SSIPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Spark_Scatter_inhibited_below_this_speed._The_MP_MTX_cal_has_this_value_set_to_0xfe33_to_keep_the_revs_high_during_shifts.____OVERVIEW:_SSIPRD_ScatterInhibitBelowThisSpeed_establishes_the_low-RPM_lockout_threshold_below_which_spark_scatter_idle_stabilization_is_inhibited._If_an_engine_speed_sags_severely_(below_~565_RPM)_toward_an_impending_stall,_dithering_spark_timing_can_cause_erratic_combustion_torque_and_finalize_the_stall._Under_near-stall_conditions,_the_ECU_inhibits_spark_scatter_dithering_and_focuses_on_solid_base_dwell_and_maximum_timing_recovery._|_TUNER'S_GUIDE:_Increasing_the_Value_(Lower_RPM_Lockout):_Allows_spark_scatter_to_operate_down_to_even_lower_engine_speeds_(e.g.,_450_RPM)._Decreasing_the_Value_(Higher_RPM_Lockout):_Shuts_off_spark_scatter_at_a_higher_speed_(e.g.,_750_RPM)._Mopar_Performance_(MP)_MTX_Calibration_Trick:_As_noted_in_the_original_template_comments,_official_Mopar_Performance_calibrations_occasionally_set_SSIPRD_to_0xFE33_to_inhibit_scatter_across_the_board_and_keep_revs_hanging_slightly_higher_between_manual_gear_shifts_for_improved_drivability_and_rev-matching.
    .word 0x00D0                     ;Point 1

	;.org	0xc0de
STRTFL_FuelStartFromCoolantTemp:
    ;mpgrp Fuel_-_Starting\
    ;mptbladdr 0x03D8
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname StartFuel_FromTemp
    ;mptblcname STRTFL
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis sqrtPW 0 222 uSec
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4____OVERVIEW:_STRTFL_FuelStartFromCoolantTemp_is_the_core_cranking_fuel_delivery_curve_used_while_the_engine_is_being_turned_over_by_the_starter_motor._During_cold_cranking,_cold_intake_manifold_runners_and_cylinder_head_ports_cause_injected_fuel_to_condense_onto_cold_metal_surfaces_('wall_wetting'),_preventing_it_from_vaporizing_and_reaching_the_spark_plug._To_establish_a_combustible_air/fuel_mixture_in_the_cylinder,_the_injectors_must_spray_substantially_more_fuel_at_cold_temperatures_(often_4_to_8_times_normal_running_fuel)._As_the_engine_warms_up,_fuel_vaporizes_readily_and_cranking_fuel_requirements_decrease_sharply._STRTFL_defines_this_baseline_fuel_pulse_width_as_a_function_of_engine_coolant_temperature._|_TUNER'S_GUIDE:_Square-Root_Math:_STRTFL_utilizes_square-root_pulse_width_scaling._The_ECU_squares_the_lookup_value_(_STRTFL_STRTFL_)_to_compute_base_pulse_width._Small_adjustments_to_high_table_values_have_a_large_exponential_impact_on_fuel_delivery!_Increasing_Table_Values_(Richer_Cranking):_Effect:_Injects_longer_fuel_pulses_during_cranking._Real-World_Feel:_Helps_engines_that_crank_endlessly_without_catching_in_cold_weather,_or_engines_running_E85_(which_requires_~30%_more_cranking_fuel)._Decreasing_Table_Values_(Leaner_Cranking):_Effect:_Shortens_cranking_fuel_pulses._Real-World_Feel:_Crucial_when_upgrading_to_larger_fuel_injectors_(+40%,_+20%,_or_52+_lb/hr)._If_STRTFL_is_not_scaled_down_for_big_injectors,_the_engine_will_instantly_foul_spark_plugs_and_flood_during_cranking.
    ;mpinjscale sqrt
    .byte 0x09                       ;Number of points in table
    .byte 0x58, 0xB1, 0xFF, 0xE9     ;Point 1
    .byte 0x63, 0xB0, 0xFD, 0x8C     ;Point 2
    .byte 0x6E, 0x95, 0xFD, 0x8C     ;Point 3
    .byte 0x79, 0x7A, 0xFE, 0xA3     ;Point 4
    .byte 0x84, 0x6B, 0xFE, 0x95     ;Point 5
    .byte 0x90, 0x5A, 0xFD, 0xE9     ;Point 6
    .byte 0x9B, 0x43, 0xFF, 0xE9     ;Point 7
    .byte 0xB1, 0x41, 0xFF, 0x39     ;Point 8
    .byte 0xCC, 0x2C                 ;Point 9

	;.org	0xc101
STRLMT_ColdestTempAllowedAtClosedThrottle:
    ;mpgrp Fuel_-_Starting\
    ;mptbladdr 0x03EF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ColdestTempAllowedAtClosedThrottle
    ;mptblcname STRLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Coldest_temperature_accepted_as_input_to_STRTFL_table_-_anything_below_this_value_will_be_replaced_with_this_value____OVERVIEW:_STRLMT_ColdestTempAllowedAtClosedThrottle_is_a_minimum_temperature_floor_clamped_onto_the_cranking_fuel_lookup_when_starting_at_closed_throttle._Because_the_cranking_fuel_table_(STRTFL)_uses_square-root_math,_pulse_widths_explode_exponentially_as_temperatures_plunge_into_sub-zero_freezing_ranges._If_a_car_is_started_in_-20_degF_weather_at_closed_throttle,_delivering_the_un-clamped_sub-zero_fuel_pulse_width_can_instantly_drown_the_intake_runners,_soak_the_spark_plugs_in_liquid_gasoline,_and_wash_down_cylinder_walls._STRLMT_prevents_this_by_capping_the_coldest_temperature_input_permitted_into_STRTFL_at_closed_throttle_to_roughly_30_degF_(0x63)._|_TUNER'S_GUIDE:_Increasing_the_Value_(Warmer_Clamp):_Caps_cold_cranking_fuel_at_a_warmer_temperature._Prevents_cold_flooding_in_winter_climates._Decreasing_the_Value_(Colder_Clamp):_Allows_the_ECU_to_deliver_richer_cranking_pulse_widths_at_extreme_sub-freezing_temperatures._Useful_in_extreme_northern_climates_(e.g.,_-20_degF_to_-40_degF)_if_an_engine_struggles_with_dry-cranking_lean-out.
    .byte 0x63                       ;Point 1

	;.org	0xc102
STFBAR_FuelStartReductionFromBaro:
    ;mpgrp Fuel_-_Starting\
    ;mptbladdr 0x03FC
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FuelStartReductionFromBaro
    ;mptblcname STFBAR
    ;mpxaxis Baro -14.7 14.7 psi
    ;mpyaxis Inverse 0 1 factor
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4._This_decreases_fuel_slightly_at_higher_altitudes_to_account_for_thinner_air.____OVERVIEW:_STFBAR_FuelStartReductionFromBaro_provides_an_altitude-dependent_reduction_factor_for_cranking_fuel_delivery._At_high_elevations_(e.g.,_Denver,_CO_or_mountain_passes),_atmospheric_pressure_is_low_and_ambient_air_is_significantly_less_dense._Delivering_sea-level_cranking_fuel_at_high_altitudes_produces_an_overly_rich_air/fuel_ratio_that_can_easily_wet_spark_plugs_and_flood_the_engine_before_it_catches._STFBAR_generates_a_reduction_multiplier_that_trims_base_cranking_fuel_(STRTFL)_as_ambient_barometric_pressure_decreases._|_TUNER'S_GUIDE:_Increasing_Table_Values_(More_Altitude_Fuel_Reduction):_Effect:_Trims_more_fuel_out_during_high-altitude_starts._Real-World_Feel:_Clears_up_black_exhaust_smoke,_rough_cold_starts,_and_fouled_plugs_when_starting_at_high_elevation._Decreasing_Table_Values_(Less_Altitude_Fuel_Reduction):_Effect:_Delivers_more_cranking_fuel_at_altitude._Sea-Level_Calibration:_At_sea_level_(~14.7_psi_baro_/_0x7A),_STFBAR_is_zero_(0x00),_producing_zero_reduction.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x60, 0x59, 0xFC, 0x94     ;Point 1
    .byte 0x7A, 0x00                 ;Point 2

	;.org	0xc10d
STFTMP_FuelStartFuelFromCoolant:
    ;mpgrp Fuel_-_Starting\
    ;mptbladdr 0x040C
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartFuelFromCoolant
    ;mptblcname STFTMP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Inverse 0 1 factor
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4____OVERVIEW:_STFTMP_FuelStartFuelFromCoolant_is_an_additional_coolant_temperature_weighting_factor_applied_to_the_barometric_starting_fuel_reduction_calculation._While_STFBAR_provides_the_primary_baro-based_reduction_factor,_STFTMP_allows_calibrators_to_scale_how_strongly_that_altitude_reduction_applies_as_the_engine_warms_up._In_the_stock_A171_calibration,_this_table_is_set_to_a_constant_100%_factor_(0xFF),_allowing_STFBAR_to_apply_full_barometric_reduction_across_all_temperatures._|_TUNER'S_GUIDE:_Stock_Setting_(0xFF):_Multiplier_is_1.0_(full_barometric_reduction_allowed)._Decreasing_Table_Values:_Dampens_altitude_fuel_reduction_at_cold_temperatures,_preserving_extra_rich_cranking_fuel_for_cold_morning_mountain_starts.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0xFF                 ;Point 1

	;.org	0xc118
EPPMUL_FuelStartFuelPerEPP:
    ;mpgrp Fuel_-_Starting\
    ;mptbladdr 0x041A
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartFuelPerEPP
    ;mptblcname EPPMUL
    ;mpxaxis EPPs 0 255 count
    ;mpyaxis Multiplier 0 1 factor
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4._This_table_decreases_fuel_for_each_engine_rotation_while_starting____OVERVIEW:_EPPMUL_FuelStartFuelPerEPP_provides_cranking_fuel_decay_as_engine_revolutions_accumulate_during_prolonged_cranking._When_a_driver_turns_the_key_to_start_the_car,_the_initial_1_to_3_engine_revolutions_require_heavy_fuel_delivery_to_wet_cold_intake_runners._However,_if_the_engine_fails_to_start_immediately_and_the_starter_continues_to_turn_the_engine_over_for_5_to_10_seconds,_delivering_that_initial_heavy_fuel_pulse_continuously_will_quickly_flood_the_spark_plugs_with_liquid_fuel._EPPMUL_tracks_the_running_count_of_Engine_Position_Pulses_(EPPs)_during_the_cranking_event_and_progressively_scales_down_cranking_fuel_pulse_width_as_cranking_drags_on,_preventing_engine_flooding._|_TUNER'S_GUIDE:_Increasing_Table_Values_(Less_Fuel_Decay_Over_Time):_Effect:_Keeps_cranking_pulse_width_richer_for_longer_during_extended_cranking._Real-World_Feel:_Helpful_for_stubborn_cold_starts_on_E85,_alcohol_fuels,_or_low-compression_engines_where_prolonged_cranking_is_required_to_build_sufficient_compression_heat_before_the_fuel_ignites._Decreasing_Table_Values_(More_Rapid_Fuel_Decay):_Effect:_Cuts_cranking_fuel_down_more_quickly_as_cranking_continues._Real-World_Feel:_Aggressively_protects_against_fouled_spark_plugs_if_the_engine_doesn't_catch_on_the_first_few_cranks.
    .byte 0x02                       ;Number of points in table
    .byte 0x21, 0xFF, 0xFF, 0x79     ;Point 1
    .byte 0x80, 0xCD                 ;Point 2

	;.org	0xc11f
SFDCAY_FuelStartDecayIntoRun:
    ;mpgrp Fuel_-_Starting\
    ;mptbladdr 0x0429
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelStartDecayIntoRun
    ;mptblcname SFDCAY
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Subtracted 0 255 ms/rev
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4._This_allows_fuel_to_decay_gradually_after_the_start-run_transition.____OVERVIEW:_SFDCAY_FuelStartDecayIntoRun_defines_the_fuel_decay_rate_during_the_immediate_start-to-run_transition._When_the_engine_catches_and_crosses_the_start-to-run_RPM_threshold_(RNFPRD),_the_fueling_requirement_drops_immediately_from_heavy_cranking_pulse_widths_down_to_base_speed-density_running_pulse_widths._An_abrupt,_step-change_drop_in_fuel_delivery_at_the_exact_instant_the_starter_disengages_can_cause_the_engine_to_stumble,_sag,_or_stall._SFDCAY_provides_an_after-start_enrichment_buffer_that_decays_smoothly_into_normal_running_fuel_over_the_first_few_seconds_of_operation,_with_the_decay_rate_tailored_to_engine_temperature._|_TUNER'S_GUIDE:_Increasing_Table_Values_(Faster_Fuel_Decay):_Effect:_Decays_after-start_enrichment_fuel_more_rapidly._Real-World_Feel:_Cleans_up_post-start_black_exhaust_smoke_and_soot_on_warm_restarts,_but_can_cause_a_cold_engine_to_sag_or_die_2-3_seconds_after_starting._Decreasing_Table_Values_(Slower_Fuel_Decay):_Effect:_Holds_extra_after-start_enrichment_longer._Real-World_Feel:_Essential_for_smooth_cold-start_drive-away_in_winter_weather._Keeps_the_engine_revving_cleanly_during_initial_startup_flare.
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x63, 0x1B, 0xFF, 0x94     ;Point 1
    .byte 0x90, 0x08, 0xFF, 0xEF     ;Point 2
    .byte 0xCC, 0x04                 ;Point 3

	;.org	0xc12a
PRSHOT_KeyOnPrimePW:
    ;mpgrp Fuel_-_Starting\
    ;mptbladdr 0x043A
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname KeyOnPrimePW
    ;mptblcname PRSHOT
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Pulsewidth 0 255 mSec
    ;mptbldesc Prime_Fuel_Shot_before_cranking____OVERVIEW:_PRSHOT_KeyOnPrimePW_defines_the_initial_'prime_shot'_fuel_injection_pulse_delivered_the_instant_the_ignition_key_is_turned_to_the_ON_/_RUN_position,_before_the_starter_motor_begins_cranking._When_an_engine_sits_overnight,_fuel_in_the_intake_ports_evaporates_and_the_manifold_walls_dry_completely._Delivering_a_brief,_pre-cranking_squirt_of_fuel_the_moment_the_key_is_turned_ON_wets_the_intake_ports_and_primes_the_air_charge_so_that_the_very_first_cylinder_to_reach_compression_during_cranking_has_vaporized_fuel_ready_to_ignite._PRSHOT_scales_this_initial_squirt_duration_based_on_engine_coolant_temperature:_delivering_a_large_prime_shot_when_ice_cold_and_tapering_down_to_a_minimal_pulse_when_the_engine_is_already_warm._|_TUNER'S_GUIDE:_Increasing_Table_Values_(Bigger_Prime_Shot):_Delivers_more_fuel_on_key_turn-on._Real-world_feel:_Produces_instant_'touch_of_the_key'_firing_on_cold_mornings._Cautions:_If_set_too_high_on_warm_restarts_(or_when_running_large_aftermarket_injectors),_turning_the_key_on-and-off_repeatedly_(e.g.,_listening_to_the_radio_or_testing_electrical_circuits)_will_repeatedly_prime_the_cylinders_and_flood_the_engine_before_cranking_even_starts!_Decreasing_Table_Values_(Smaller_Prime_Shot):_Injects_less_fuel_on_key-on._Real-world_feel:_Prevents_hot-start_flooding_and_plug_fouling_with_oversized_injectors_(+40%_or_larger)._Zeroing_Out:_Setting_PRSHOT_to_0x00_eliminates_the_pre-crank_prime_shot_entirely,_fuel_delivery_will_only_begin_once_the_starter_motor_cranks_and_generates_distributor_sync_pulses.
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x69, 0x64, 0xFD, 0x2F     ;Point 1
    .byte 0x84, 0x18, 0xFF, 0xD3     ;Point 2
    .byte 0x9B, 0x14                 ;Point 3

	;.org	0xc135
O2TIME_DelayTimeToClosedLoop:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x044B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DelayTimeToClosedLoop
    ;mptblcname O2TIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Delay_Time 0 720 Sec
    ;mptbldesc DelayTimeWhenGoingClosedLoop._o2_voltage_must_trigger_timer,_ie_must_gt_O2TLMH_or_lt_O2TLML.Each_1_is_2.8_sec,_cannot_exceed_$7f____OVERVIEW:_O2TIME_DelayTimeToClosedLoop_establishes_the_minimum_warmup_hold_time_that_the_ECU_must_wait_after_the_engine_has_reached_operating_temperature_(CLTEMP)_before_attempting_to_transition_from_Open-Loop_into_Closed-Loop_fuel_feedback_control._A_cold_narrow-band_zirconia_O2_sensor_cannot_generate_an_accurate_or_reliable_voltage_signal_until_its_ceramic_element_reaches_internal_operating_temperatures_of_at_least_600_degF_(315_degC)._Entering_closed-loop_operation_prematurely_causes_violent_fueling_oscillations,_surging,_or_stalling_because_the_ECU_misinterprets_the_high-impedance_resting_voltage_of_an_unheated_sensor_as_an_extreme_rich_or_lean_condition._O2TIME_guarantees_that_the_sensor_heater_and_hot_exhaust_gases_have_had_adequate_time_to_bring_the_sensor_up_to_full_operational_temperature._|_TUNER'S_GUIDE:_Factory_Calibration_Value:_0x15_(21_decimal_2.8_s_~_59_seconds_)._Increasing_O2TIME:_Effect:_Lengthens_the_time_the_engine_stays_in_open-loop_warm-up_mode_after_cold_startup._When_to_Use:_Unheated_1-wire_O2_sensors_installed_in_long-tube_headers_or_large-diameter_aftermarket_downpipes_located_further_downstream_from_the_exhaust_valves._The_extra_distance_requires_longer_time_for_exhaust_heat_to_soak_the_sensor._Decreasing_O2TIME:_Effect:_Causes_closed-loop_mode_to_engage_sooner_after_startup._When_to_Use:_Modern_heated_3-wire_or_4-wire_O2_sensors_with_dedicated,_fast-acting_ceramic_heaters_that_achieve_operating_temperature_in_under_15-20_seconds._Caution:_Setting_O2TIME_too_low_with_an_unheated_or_sluggish_sensor_will_induce_lean_stumbling_and_hesitation_during_drive-away.
    .byte 0x15                       ;Point 1

	;.org	0xc136
CLTEMP_TempToStartCLTIMETimer:
    ;mpgrp Fuel_-_Adaptive_Memory_Timer\
    ;mptbladdr 0x0458
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TempToStartCLTIMETimer
    ;mptblcname CLTEMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 degrees
    ;mptbldesc Temperature_to_start_CLTIME_Timer_-_$94_=_70degreesF____OVERVIEW:_CLTEMP_TempToStartCLTIMETimer_defines_the_coolant_temperature_threshold_that_unlocks_the_closed-loop_delay_timer._Before_the_ECU_will_consider_running_in_closed-loop_fuel_feedback_or_adapting_fuel_tables,_the_engine_must_warm_up_past_cold-enrichment_levels._When_coolant_temperature_reaches_CLTEMP,_the_ECU_starts_the_Timer_CLTIME_ClosedLoopTimer_countdown._Once_that_timer_reaches_O2TIME,_the_ECU_tests_oxygen_sensor_activity_and_transitions_into_closed-loop_control._|_TUNER'S_GUIDE:_Stock_Setting:_0x9B_(_~_77_degF_)._The_factory_cal_enables_closed-loop_qualification_early_(at_mild_ambient_temps)_to_reduce_cold-start_tailpipe_emissions._Increasing_CLTEMP_(e.g.,_to_120_degF-140_degF):_Effect:_Keeps_the_engine_in_open_loop_longer_until_physical_warmth_is_established_in_the_combustion_chambers._When_to_Use:_Ethanol_fuels_(E85)_or_large_aftermarket_camshafts_that_struggle_with_lean_stumble_or_erratic_idle_if_closed-loop_engages_at_lukewarm_engine_temperatures._Decreasing_CLTEMP:_Forces_closed-loop_qualification_when_cold,_risking_poor_driveability_and_surging.
    .byte 0x9B                       ;Point 1

	;.org	0xc137
O2HSWP_HighLimitForO2RampSwitching:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x0465
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForO2RampSwitching
    ;mptblcname O2HSWP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HighLimitForO2RampSwitching____OVERVIEW:_O2HSWP_HighLimitForO2RampSwitching_is_the_upper_voltage_switching_threshold_used_by_the_closed-loop_air/fuel_ratio_controller_to_detect_when_the_exhaust_mixture_has_transitioned_to_the_RICH_side_of_stoichiometric_(14.7:1_AFR_for_gasoline)._A_narrow-band_zirconia_oxygen_sensor_outputs_a_non-linear_S-curve_voltage:_typically_0.1V_when_lean_and_0.9V_when_rich,_with_an_extremely_steep_cliff_around_0.45V_to_0.50V._When_the_sensor_voltage_climbs_equal_to_or_above_O2HSWP,_the_ECU_confirms_that_excess_fuel_is_present_in_the_exhaust_gas_and_immediately_initiates_fuel_enleanment_ramps_to_drive_the_mixture_back_toward_stoichiometry._|_TUNER'S_GUIDE:_Pairing_with_O2LSWP:_O2HSWP_(0x19_~_0.488V_)_works_as_a_tight_hysteresis_pair_with_O2LSWP_(0x18_~_0.469V_)._This_tight_19mV_window_ensures_rapid,_responsive_switching_around_the_narrow-band_midpoint._Raising_O2HSWP_(e.g.,_to_0x22_/_0.66V):_The_sensor_must_reach_a_higher_voltage_before_the_ECU_acknowledges_a_rich_condition._Real-World_Effect:_Shifts_the_average_closed-loop_stoichiometric_target_slightly_richer_(e.g.,_14.3:1_-_14.5:1_AFR),_which_can_reduce_lean_misfire_or_improve_tip-in_smoothness_on_aggressive_camshafts._Lowering_O2HSWP:_Narrowing_the_gap_between_high_and_low_switch_points_makes_the_feedback_loop_twitchy,_increasing_susceptibility_to_electrical_noise_in_the_sensor_wiring.
    .byte 0x19                       ;Point 1

	;.org	0xc138
O2LSWP_LowLimitForO2RampSwitching:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x0472
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForO2RampSwitching
    ;mptblcname O2LSWP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LowLimitForO2RampSwitching____OVERVIEW:_O2LSWP_LowLimitForO2RampSwitching_is_the_lower_voltage_switching_threshold_used_by_the_closed-loop_air/fuel_controller_to_detect_when_the_exhaust_mixture_has_transitioned_to_the_LEAN_side_of_stoichiometric_(lambda_>_1.0)._When_combustion_leans_out,_free_oxygen_content_in_the_exhaust_stream_rises,_causing_the_zirconia_sensor_voltage_to_collapse_toward_0.1V._When_the_sensor_voltage_drops_strictly_below_O2LSWP,_the_ECU_registers_a_lean_condition_and_triggers_immediate_fuel_enrichment_ramps_to_reverse_the_trend_and_restore_stoichiometric_balance._|_TUNER'S_GUIDE:_Hysteresis_Band:_The_stock_calibration_sets_O2LSWP_at_0x18_(0.469V)_and_O2HSWP_at_0x19_(0.488V)._This_single-count_separation_(19_mV)_represents_the_absolute_minimum_hysteresis_possible_in_an_8-bit_ADC_system._Lowering_O2LSWP_(e.g.,_to_0x12_/_0.35V):_Forces_the_sensor_to_dip_significantly_deeper_into_lean_territory_before_enrichment_begins._Real-World_Effect:_Shifts_the_mean_cruise_AFR_slightly_leaner_(14.9:1_-_15.2:1_AFR)_for_modest_fuel_economy_gains,_but_increases_NOx_emissions_and_risks_mild_cruise_surge._Widening_Deadband:_If_you_suffer_from_erratic_O2_toggling_caused_by_electrical_grounding_offset_or_ignition_noise,_widening_the_gap_between_O2LSWP_and_O2HSWP_stabilizes_the_switching_cycle.
    .byte 0x18                       ;Point 1

	;.org	0xc139
O2TLMH_HighLimitForDelayedSwitchToClosedLoop:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x047F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForDelayedSwitchToClosedLoop
    ;mptblcname O2TLMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HighLimitForDelayedSwitchToClosedLoop____OVERVIEW:_O2TLMH_HighLimitForDelayedSwitchToClosedLoop_defines_the_upper_voltage_threshold_required_to_qualify_O2_sensor_readiness_before_the_ECU_officially_activates_closed-loop_feedback_operation._When_an_oxygen_sensor_is_cold_and_inactive,_its_internal_electrochemical_cell_cannot_pass_current_and_rests_at_an_indeterminate_floating_voltage_(typically_0.40V_to_0.50V)._To_prevent_entering_closed-loop_on_a_dead_or_cold_sensor,_the_ECU_requires_the_sensor_to_provide_positive_physical_proof_of_life_by_swinging_above_O2TLMH_(rich)_or_below_O2TLML_(lean)_before_closed-loop_control_is_allowed_to_engage._|_TUNER'S_GUIDE:_Stock_Value:_0x1F_(31_counts_~_0.605V_)._Sensor_Health_Diagnostic:_If_an_engine_has_reached_full_operating_temperature_(180_degF+)_but_steadfastly_refuses_to_enter_closed-loop_(scantool_shows_open-loop_status_indefinitely),_the_O2_sensor_may_have_lost_its_heater_or_deteriorated_to_where_it_cannot_swing_above_0x1F_(0.605V)._Adjusting_for_Aftermarket_/_Wideband_Emulated_Outputs:_When_using_a_wideband_controller's_simulated_narrow-band_output_(e.g._Innovate_LC-2,_AEM_X-Series),_ensure_the_emulated_analog_curve_crosses_cleanly_above_O2TLMH_(0.605V)_and_below_O2TLML_(0.293V).
    .byte 0x1F                       ;Point 1

	;.org	0xc13a
O2TLML_LowLimitForDelayedSwitchToClosedLoop:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x048C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForDelayedSwitchToClosedLoop
    ;mptblcname O2TLML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LowLimitForDelayedSwitchToClosedLoop____OVERVIEW:_O2TLML_LowLimitForDelayedSwitchToClosedLoop_is_the_lower_voltage_threshold_required_to_qualify_O2_sensor_readiness_before_enabling_closed-loop_fueling._Working_directly_in_conjunction_with_O2TLMH,_O2TLML_confirms_that_the_O2_sensor_is_active_by_verifying_that_it_can_pull_down_strongly_into_lean_voltage_territory_(_<_0.293V_)._If_the_sensor_has_not_yet_reached_sufficient_heat_to_overcome_its_internal_impedance_and_produce_a_valid_low_voltage,_closed-loop_entry_is_deferred._|_TUNER'S_GUIDE:_Stock_Value:_0x0F_(15_decimal_~_0.293V_)._Diagnostic_Utility:_An_O2_sensor_with_high_ground_offset_(common_in_older_wiring_harnesses_with_corroded_engine_ground_straps)_may_never_register_below_0.35V._In_such_cars,_the_ECU_will_fail_this_test_and_refuse_to_enter_closed-loop,_causing_poor_gas_mileage_and_continuous_open-loop_running._Adjustment_Guidance:_Generally_leave_at_stock_unless_troubleshooting_stubborn_closed-loop_entry_delays_caused_by_slight_electrical_ground_offsets.
    .byte 0x0F                       ;Point 1

	;.org	0xc13b
O2MIDH_HighLimitForInMiddleDetermination:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x0499
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HighLimitForInMiddleDetermination
    ;mptblcname O2MIDH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc HighLimitForInMiddleDetermination____OVERVIEW:_O2MIDH_HighLimitForInMiddleDetermination_defines_the_upper_voltage_boundary_of_the_O2_sensor_'stuck-in-the-middle'_fault_zone._During_normal_operation,_an_active_narrow-band_O2_sensor_continuously_toggles_rapidly_between_rich_(>_0.6V)_and_lean_(<_0.3V)._It_should_virtually_never_linger_at_mid-voltages_(~0.45V)._If_the_sensor_voltage_remains_continuously_trapped_between_O2MIDL_and_O2MIDH,_it_indicates_that_the_sensor_is_disconnected,_internally_shorted/open,_or_that_its_heater_has_failed._O2MIDH_guards_the_top_edge_of_this_inactive_detection_window._|_TUNER'S_GUIDE:_Stock_Value:_0x1C_(28_counts_~_0.547V_)._Diagnostic_Indicator:_If_an_engine_intermittently_kicks_out_of_closed_loop_and_throws_Fault_21,_check_the_sensor_wiring_for_high_resistance_or_a_failed_heater_circuit_that_causes_the_sensor_to_cool_off_and_drift_into_this_0.352V_-_0.547V_range_at_long_idle._Tuning_Implications:_Do_not_compress_O2MIDH_down_toward_switching_thresholds_(O2HSWP),_or_false-positive_Fault_21_triggers_will_occur_during_slow_sensor_transitions.
    .byte 0x1C                       ;Point 1

	;.org	0xc13c
O2MIDL_LowLimitForInMiddleDetermination:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x04A6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowLimitForInMiddleDetermination
    ;mptblcname O2MIDL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc LowLimitForInMiddleDetermination._Used_for_Reverting_to_openLoop,_Setting_fault21,_outputting_O2_level_to_miller_tool____OVERVIEW:_O2MIDL_LowLimitForInMiddleDetermination_defines_the_lower_voltage_boundary_of_the_O2_sensor_'stuck-in-the-middle'_fault_zone._Combined_with_O2MIDH,_it_creates_the_diagnostic_window_used_to_identify_dead,_disconnected,_or_unheated_O2_sensors._When_the_O2_sensor_output_stays_between_O2MIDL_and_O2MIDH_for_longer_than_the_allowable_timeout,_the_ECU_aborts_closed-loop_operation,_sets_Fault_21,_and_reverts_to_open-loop_default_fueling._|_TUNER'S_GUIDE:_Stock_Value:_0x12_(18_counts_~_0.352V_)._Troubleshooting_Fault_21:_If_Fault_21_occurs_after_installing_an_aftermarket_exhaust,_check_if_the_O2_sensor_is_placed_too_far_downstream_without_a_heated_element._At_idle,_exhaust_temperature_drops_below_the_sensor's_threshold,_causing_its_voltage_to_freeze_between_0.352V_and_0.547V_._Converting_to_a_3-wire_or_4-wire_heated_sensor_cures_this_issue_immediately.
    .byte 0x12                       ;Point 1

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
    ;mpgrp Fuel_-_O2_Controller_Ramps\
    ;mptbladdr 0x04FE
    ;mptbltype 11
    ;mpsubtype 1
    ;mptbllname PrimaryRamp
    ;mptblcname PRIRMP
    ;mpxaxis RPM 0 16384 rpm
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Lower_RPM_Boundary_-_RPM/32____OVERVIEW:_PRIRMP_PrimaryRamp_is_the_Proportional_Step_table_of_the_ECU's_Proportional-Integral_(PI)_closed-loop_fuel_controller._In_closed-loop_feedback,_whenever_the_oxygen_sensor_switches_states_(from_Lean_to_Rich,_or_Rich_to_Lean),_the_fuel_controller_must_take_immediate,_decisive_action_to_reverse_the_fuel_delivery_trend_before_exhaust_transport_delay_allows_the_engine_to_overshoot_too_far_into_the_opposite_condition._PRIRMP_specifies_the_instantaneous_step_jump_(proportional_jump)_applied_to_the_fuel_pulse_width_counter_the_moment_an_O2_toggle_is_detected._|_TUNER'S_GUIDE:_Proportional_Jump_Dynamics:_Larger_Step_Sizes:_Creates_wider,_faster_swings_across_stoichiometry._This_helps_old_catalytic_converters_light_off_and_perform_redox_reactions,_but_if_too_large,_causes_noticeable_exhaust_hunting,_audible_RPM_surging_at_cruise,_and_choppy_idle._Smaller_Step_Sizes:_Narrows_the_closed-loop_swing_limit,_smoothing_out_engine_idle_and_cruise_stability._However,_if_step_sizes_are_too_small,_the_ECU_responds_too_slowly_to_load_changes,_causing_lean_hesitation_on_gentle_tip-in_before_secondary_integration_catches_up._Tuning_for_Camshafts_and_Large_Injectors:_Upgrading_to_large_injectors_(+40%_or_+52_lb/hr)_doubles_or_triples_the_fuel_mass_delivered_per_step_tick!_Tuners_must_scale_down_PRIRMP_values_proportionately_to_restore_smooth_closed-loop_operation.
    ;mpmapaxis y
    .word 0x1319                  ;Rpm Low / High Boundary
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

	;.org	0xc169
SECRMP_SecondaryRamp:
    ;mpgrp Fuel_-_O2_Controller_Ramps\
    ;mptbladdr 0x0521
    ;mptbltype 11
    ;mpsubtype 1
    ;mptbllname SecondaryRamp
    ;mptblcname SECRMP
    ;mpxaxis RPM 0 16384 rpm
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc Lower_RPM_Boundary_-_RPM/32____OVERVIEW:_SECRMP_SecondaryRamp_represents_the_Integral_Ramp_(Slope)_table_of_the_ECU's_closed-loop_PI_fueling_algorithm._While_PRIRMP_provides_an_immediate_step_correction_when_the_O2_sensor_flips,_the_exhaust_gas_may_remain_on_one_side_of_stoichiometry_for_multiple_engine_cycles_while_waiting_for_physical_mixture_delivery._SECRMP_dictates_the_rate_at_which_the_ECU_steadily_ramps_fuel_pulse_width_richer_or_leaner_over_time_until_the_sensor_finally_crosses_the_stoichiometric_midpoint._|_TUNER'S_GUIDE:_Integral_Ramp_Dynamics:_Steeper_Slopes_(Higher_Values):_Causes_the_fuel_pulse_width_to_ramp_rapidly_towards_the_opposite_limit._Produces_higher_frequency_switching,_but_risks_heavy_overshoot_and_hunting._Flatter_Slopes_(Lower_Values):_Causes_slow,_gradual_fueling_adjustments._Produces_a_very_smooth_AFR_curve,_but_if_too_flat,_the_engine_will_spend_excessive_time_trapped_on_one_side_of_stoichiometry_during_sudden_load_changes._Injector_Scaling:_Large_fuel_injectors_(+40%,_+52_lb/hr)_deliver_significantly_more_fuel_per_tick_of_pulse_width._Scaling_SECRMP_down_is_essential_to_maintain_proper_integral_ramp_slopes_with_larger_injectors.
    ;mpmapaxis y
    .word 0x131B                  ;Rpm Low / High Boundary
    .word 0x2B50                  ;Map Low / High Boundary
    .word 0x03FD                  ;Cell 0 Ramp Rich/Lean
    .word 0x01FF                  ;Cell 1 Ramp Rich/Lean
    .word 0x01FF                  ;Cell 2 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 3 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 4 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 5 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 6 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 7 Ramp Rich/Lean
    .word 0x03FD                  ;Cell 8 Ramp Rich/Lean
    .word 0x03FD                  ;Ramp Idle Cell Rich/Lean
    .word 0x0708                  ;Cell 0 Limits/Rates Rich/Lean
    .word 0x0708                  ;Cell 1 Limits/Rates Rich/Lean
    .word 0x0708                  ;Cell 2 Limits/Rates Rich/Lean
    .word 0x0608                  ;Cell 3 Limits/Rates Rich/Lean
    .word 0x0708                  ;Cell 4 Limits/Rates Rich/Lean
    .word 0x0708                  ;Cell 5 Limits/Rates Rich/Lean
    .word 0x0608                  ;Cell 6 Limits/Rates Rich/Lean
    .word 0x0608                  ;Cell 7 Limits/Rates Rich/Lean
    .word 0x0508                  ;Cell 8 Limits/Rates Rich/Lean
    .word 0x0708                  ;Limit/Rates Idle Cell Rich/Lean

	;.org	0xc195
O2LIMH_O2RangeLimitHigh:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x0544
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2RangeLimitHigh
    ;mptblcname O2LIMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2_Range_Of_Authority_MaxMultiplier=1+O2LIMH/512_(cannot_be_above_$7f)____OVERVIEW:_O2LIMH_O2RangeLimitHigh_specifies_the_maximum_short-term_enrichment_authority_permitted_by_the_closed-loop_O2_feedback_controller._To_prevent_runaway_fueling_in_the_event_of_an_exhaust_leak,_misfire,_or_bad_oxygen_sensor,_the_ECU_strictly_caps_how_much_additional_fuel_the_closed-loop_feedback_loop_is_allowed_to_inject._O2LIMH_represents_the_upper_clamp_of_this_short-term_trim_accumulator_(Counter_PrimaryAndSecondaryRamp)._|_TUNER'S_GUIDE:_Stock_Value:_0x7F_(+127_decimal)._Max_Multiplier_=_1.0_+_(O2LIMH_/_512)_=_1.0_+_(127_/_512)_~_1.248_(+24.8%)_Increasing_O2LIMH:_Allows_the_closed-loop_controller_to_add_even_more_fuel_to_compensate_for_unmetered_air_leaks_or_undersized_fuel_delivery._Warning:_The_internal_math_register_is_signed_8-bit._0x7F_is_already_the_maximum_positive_value_allowable_without_signed_overflow!_Do_not_set_above_0x7F._Decreasing_O2LIMH_(e.g.,_to_0x40_/_+12.5%):_Tighter_authority_limit_protects_the_engine_from_fouling_plugs_or_washing_cylinder_walls_if_an_exhaust_leak_fools_the_sensor_into_seeing_phantom_air.
    .byte 0x7F                       ;Point 1

	;.org	0xc196
O2LIML_O2RangeLimitLow:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x0551
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2RangeLimitLow
    ;mptblcname O2LIML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2_Range_Of_Authority_MinMultiplier=.5+O2LIML/512_(cannot_be_below_$80)____OVERVIEW:_O2LIML_O2RangeLimitLow_establishes_the_maximum_short-term_enleanment_authority_permitted_by_the_closed-loop_O2_controller._Just_as_O2LIMH_limits_how_much_fuel_the_ECU_can_add,_O2LIML_protects_the_engine_from_being_leaned_out_dangerously_if_a_malfunctioning_O2_sensor_gets_stuck_producing_high_voltage._O2LIML_forms_the_floor_beneath_which_short-term_fuel_feedback_cannot_reduce_injector_pulse_width._|_TUNER'S_GUIDE:_Stock_Value:_0xB3_(Hex_0xB3_in_8-bit_signed_two's_complement_=_179_-_256_=_-77_decimal)._Min_Multiplier_=_1.0_+_(Signed(0xB3)_/_512)_=_1.0_-_(77_/_512)_~_1.0_-_0.1504_=_0.8496_(-15.0%)_Safety_Margin:_Notice_that_the_factory_calibration_allows_+24.8%_rich_authority_(0x7F),_but_only_-15.0%_lean_authority_(0xB3)._This_asymmetric_bias_is_intentional:_running_slightly_rich_under_error_conditions_is_safe,_while_running_excessively_lean_under_load_can_melt_pistons._Tuning_Note:_Do_not_set_below_0x80_(-128_counts_/_-25%),_as_that_would_trigger_signed_arithmetic_underflow.
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
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x056E
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary1
    ;mptblcname MP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc AutoCalMapCellBoundary1____OVERVIEW:_MP1_AutoCalMapCellBoundary1_defines_the_first_manifold_pressure_load_boundary_separating_Adaptive_Fuel_Memory_Cell_0/1_from_Cell_2/3._The_Chrysler_T-LM_ECU_divides_off-idle_part-throttle_operation_into_a_grid_of_12_adaptive_fuel_memory_cells_(6_MAP_load_bands_*_2_RPM_bands)._MP1_represents_the_lowest_MAP_transition_point,_dividing_extreme_high-vacuum_decel/light-coast_conditions_from_normal_light-load_cruise._|_TUNER'S_GUIDE:_Stock_Value:_0x24_(_~_21.6_inHg_vacuum_)._Engine_Dynamics:_Cell_0/1_covers_very_light_throttle_cruise_or_downhill_overrun._Altering_Boundaries:_When_running_higher-duration_performance_camshafts_with_reduced_idle_and_decel_vacuum,_MP1_may_be_adjusted_higher_to_ensure_light_cruise_does_not_bleed_into_the_decel_cell.
    ;mpmapaxis y
    .byte 0x24                       ;Point 1

	;.org	0xc198
MP2_AutoCalMapCellBoundary2:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x057C
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary2
    ;mptblcname MP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc AutoCalMapCellBoundary1____OVERVIEW:_MP2_AutoCalMapCellBoundary2_defines_the_second_manifold_pressure_load_boundary_separating_Adaptive_Fuel_Memory_Cells_2/3_from_Cells_4/5._This_transition_point_isolates_low-speed_neighborhood_cruising_(17-21_inHg_vacuum)_from_moderate_flat-highway_cruising_loads_(12-17_inHg_vacuum)._|_TUNER'S_GUIDE:_Stock_Setting:_0x37_(_~_17_inHg_vacuum_)._Tuning_Impact:_If_a_car_exhibits_distinct_fueling_errors_between_city_30_mph_cruise_and_flat_highway_55_mph_cruise,_moving_MP2_shifts_where_the_ECU_bifurcates_its_learned_long-term_fuel_trim_corrections.
    ;mpmapaxis y
    .byte 0x37                       ;Point 1

	;.org	0xc199
MP3_AutoCalMapCellBoundary3:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x058A
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary3
    ;mptblcname MP3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc AutoCalMapCellBoundary1____OVERVIEW:_MP3_AutoCalMapCellBoundary3_defines_the_third_manifold_pressure_load_boundary,_separating_Adaptive_Fuel_Memory_Cells_4/5_from_Cells_6/7._This_boundary_corresponds_to_standard_highway_cruising_loads_(approx._12_inHg_vacuum),_separating_level-grade_highway_driving_from_slight_incline_or_mild_passing_loads._|_TUNER'S_GUIDE:_Stock_Setting:_0x4B_(_~_12.4_inHg_vacuum_)._Real-World_Impact:_Cells_4_and_5_accumulate_the_vast_majority_of_interstate_highway_cruising_miles._Long-term_fuel_trims_stored_in_these_cells_have_the_biggest_impact_on_highway_fuel_economy.
    ;mpmapaxis y
    .byte 0x4B                       ;Point 1

	;.org	0xc19a
MP4_AutoCalMapCellBoundary4:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x0598
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary4
    ;mptblcname MP4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc AutoCalMapCellBoundary1____OVERVIEW:_MP4_AutoCalMapCellBoundary4_defines_the_fourth_manifold_pressure_load_boundary,_separating_Adaptive_Fuel_Memory_Cells_6/7_from_Cells_8/9._This_transition_point_marks_moderate_acceleration_and_moderate_hill-climbing_under_engine_vacuum_(approx._7_inHg_vacuum)._|_TUNER'S_GUIDE:_Stock_Value:_0x61_(_~_7.2_inHg_vacuum_)._Engine_Dynamics:_Cells_6_and_7_handle_hill_climbing_and_moderate_vehicle_acceleration_prior_to_approaching_atmospheric_pressure.
    ;mpmapaxis y
    .byte 0x61                       ;Point 1

	;.org	0xc19b
MP5_AutoCalMapCellBoundary5:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x05A6
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AutoCalMapCellBoundary5
    ;mptblcname MP5
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc AutoCalMapCellBoundary1____OVERVIEW:_MP5_AutoCalMapCellBoundary5_defines_the_fifth_and_highest_manifold_pressure_load_boundary,_separating_Adaptive_Fuel_Memory_Cells_8/9_from_Cells_10/11._Located_immediately_below_atmospheric_pressure_(approx._1.8_inHg_vacuum),_MP5_separates_moderate-to-heavy_vacuum_cruise_from_near-zero_vacuum_/_zero-boost_threshold_driving._|_TUNER'S_GUIDE:_Stock_Setting:_0x78_(_~_-0.9_psig_)._Near-Atmospheric_Learning:_Cells_10_and_11_represent_the_highest_load_cells_where_the_ECU_is_permitted_to_adapt_fuel_trims._Once_manifold_pressure_crosses_into_boost_(_>_MAPLIM_),_closed_loop_and_adaptive_memory_freeze,_locking_fuel_delivery_to_open-loop_base_tables.
    ;mpmapaxis y
    .byte 0x78                       ;Point 1

	;.org	0xc19c
DLTMAP_MapHysteresisAtMapCellBoundaries:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x05B4
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MapHysteresisAtMapCellBoundaries
    ;mptblcname DLTMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc Map_Hysteresis_At_Map_Cell_Boundaries____OVERVIEW:_DLTMAP_MapHysteresisAtMapCellBoundaries_provides_manifold_pressure_hysteresis_when_transitioning_between_adjacent_adaptive_fuel_memory_cells._Without_hysteresis,_driving_at_a_steady_load_that_hovers_precisely_on_a_cell_boundary_(e.g.,_exactly_at_MP2)_would_cause_the_cell_pointer_to_oscillate_rapidly_back_and_forth_between_cells_on_every_single_engine_revolution,_resetting_cell_timers_and_preventing_either_cell_from_ever_accumulating_enough_steady-state_time_to_update._DLTMAP_adds_a_deadband_offset_to_the_boundary_check_to_lock_the_cell_selection_until_pressure_moves_decisively_past_the_boundary._|_TUNER'S_GUIDE:_Stock_Value:_0x01_(1_ADC_step_~_0.12_psi_)._Tuning_Guidance:_The_stock_1-count_hysteresis_is_generally_optimal._Increasing_to_2_or_3_counts_can_help_vehicles_with_excessive_intake_manifold_pulsation_(e.g.,_individual_runner_intakes_or_radical_camshaft_overlap),_stabilizing_cell_selection.
    ;mpmapaxis y
    .byte 0x01                       ;Point 1

	;.org	0xc19d
R1_RPMCellBoundaryInRPMover32:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x05C2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMCellBoundaryInRPMover32
    ;mptblcname R1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 16384 rpm
    ;mptbldesc RPM_Cell_Boundary____OVERVIEW:_R1_RPMCellBoundaryInRPMover32_is_the_engine_speed_boundary_that_bifurcates_each_of_the_6_MAP_load_regions_into_a_Low-RPM_Cell_(even_numbers:_0,_2,_4,_6,_8,_10)_and_a_High-RPM_Cell_(odd_numbers:_1,_3,_5,_7,_9,_11)._Engines_experience_significantly_different_volumetric_efficiencies_and_exhaust_scavenging_dynamics_at_low_RPM_(near_idle_/_off-idle_lugging)_compared_to_higher_cruising_RPMs._R1_provides_the_RPM_split_that_allows_the_adaptive_fuel_trim_system_to_learn_separate_fuel_corrections_for_low-RPM_lugging_vs._mid/high-RPM_cruising._|_TUNER'S_GUIDE:_Stock_Value:_0x1D_(_29_32_=_928_RPM_)._Raising_R1_(e.g.,_to_0x32_/_1600_RPM):_Real-World_Impact:_In_stock_form,_R1_is_set_very_low_(928_RPM),_meaning_that_almost_all_driving_above_1000_RPM_falls_into_the_High-RPM_cells_(odd_cells),_while_the_even_cells_only_capture_off-idle_crawl._Raising_R1_to_1500-1800_RPM_divides_low-speed_city_driving_(under_1800_RPM)_cleanly_from_highway_cruising_(above_1800_RPM),_allowing_much_better_adaptive_fuel_resolution.
    .byte 0x1D                       ;Point 1

	;.org	0xc19e
DLTRPM_DeltaRPMAtRPMBoundariesInRPMOver32:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x05CF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaRPMAtRPMBoundariesInRPMOver32
    ;mptblcname DLTRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Delta_RPM_at_RPM_Boundaries____OVERVIEW:_DLTRPM_DeltaRPMAtRPMBoundariesInRPMOver32_provides_engine_speed_hysteresis_around_the_RPM_cell_boundary_(R1)._When_vehicle_engine_speed_hovers_right_at_the_R1_threshold_(e.g._928_RPM),_small_tachometer_fluctuations_would_cause_the_ECU_to_flip_between_even_and_odd_adaptive_memory_cells_constantly._DLTRPM_creates_a_deadband_to_prevent_cell_hunting._|_TUNER'S_GUIDE:_Stock_Value:_0x01_(32_RPM)._Tuning_Advice:_Generally_leave_at_stock_unless_you_raise_R1_substantially,_in_which_case_a_2-count_(_64_RPM_)_hysteresis_band_can_improve_stability.
    .byte 0x01                       ;Point 1

	;.org	0xc19f
IDLOFS_DeltaForIdleRPMForClosedThrottleCell:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x05DC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaForIdleRPMForClosedThrottleCell
    ;mptblcname IDLOFS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc RPM_Delta_for_Idle_RPM_For_Closed_Throttle_Cell____OVERVIEW:_IDLOFS_DeltaForIdleRPMForClosedThrottleCell_specifies_an_upper_RPM_offset_window_above_target_idle_speed_within_which_the_ECU_is_permitted_to_select_and_update_the_dedicated_Closed-Throttle_Idle_Adaptive_Cell_(Cell_12_/_AutoCalCell12idle)._When_the_throttle_is_closed,_the_engine_should_only_adapt_its_idle_fuel_cell_if_it_is_actually_operating_at_or_near_normal_idle_speed._If_the_car_is_coasting_in_gear_with_the_throttle_closed_at_2500_RPM_(engine_braking),_adapting_the_idle_cell_would_severely_corrupt_idle_fueling._IDLOFS_(along_with_HYTRPM)_enforces_the_maximum_allowable_RPM_ceiling_above_target_idle_speed_for_Cell_12_qualification._|_TUNER'S_GUIDE:_Stock_Value:_0x01_(32_RPM_above_target_idle)._Target_Idle_Relationship:_Target_idle_speed_is_dynamically_set_by_the_AIS_idle_speed_curve_(e.g._850_RPM)._Max_RPM_for_Cell_12_~_850_+_(2_32)_+_(1_32)_=_850_+_96_=_946_RPM_Tuning_Guidance:_If_your_modified_engine_has_a_lumpy_idle_with_a_high-lift_camshaft,_widening_IDLOFS_to_0x03_or_0x04_(96-128_RPM)_prevents_the_idle_cell_from_constantly_dropping_out_during_minor_RPM_hunting.
    .byte 0x01                       ;Point 1

	;.org	0xc1a0
HYTRPM_HysteresisFor_IDLOFS:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x05E9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HysteresisFor_IDLOFS
    ;mptblcname HYTRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Hysteresis_for_IDLOFS____OVERVIEW:_HYTRPM_HysteresisFor_IDLOFS_establishes_the_engine_speed_hysteresis_band_for_entry_and_exit_from_the_Closed-Throttle_Idle_Adaptive_Cell_(Cell_12)._Working_in_concert_with_IDLOFS,_HYTRPM_ensures_that_minor_idle_speed_flares_(such_as_when_the_radiator_cooling_fan_turns_on_or_the_A/C_compressor_cycles)_do_not_cause_erratic_toggling_between_idle_adaptive_memory_and_part-throttle_cruise_cells._|_TUNER'S_GUIDE:_Stock_Setting:_0x02_(64_RPM)._Tuning_Recommendation:_Leave_at_stock_unless_an_aggressive_camshaft_creates_large_idle_RPM_fluctuations,_in_which_case_increasing_HYTRPM_to_0x03_or_0x04_stabilizes_closed-loop_idle_adaptation.
    .byte 0x02                       ;Point 1

	;.org	0xc1a1
CALTHR_O2ControllerDeadbandLimitForUpdatingCells:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x05F6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname O2ControllerDeadbandLimitForUpdatingCells
    ;mptblcname CALTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc O2_Controller_Deadband_Limit_For_Updating_Cells____OVERVIEW:_CALTHR_O2ControllerDeadbandLimitForUpdatingCells_defines_the_short-term_fuel_feedback_deadband_threshold_required_to_trigger_an_update_to_long-term_adaptive_memory._The_ECU_should_only_update_long-term_adaptive_fuel_trim_cells_when_short-term_closed_loop_feedback_has_accumulated_a_persistent,_meaningful_error._If_short-term_feedback_is_oscillating_symmetrically_near_zero,_the_base_calibration_is_already_accurate,_and_no_adaptive_trim_update_is_needed._CALTHR_establishes_the_minimum_error_magnitude_required_before_a_cell_is_nudged_richer_or_leaner._|_TUNER'S_GUIDE:_Stock_Value:_0x09_(9_counts)._Increasing_CALTHR:_Requires_larger_persistent_fueling_errors_before_adaptive_trim_shifts._When_to_Use:_If_long-term_trims_wander_around_excessively_due_to_weather_changes_or_sensor_noise,_increasing_CALTHR_makes_adaptive_memory_more_conservative._Decreasing_CALTHR:_Causes_adaptive_cells_to_react_and_update_to_smaller_deviations,_making_trims_more_aggressive._If_set_too_small_(e.g._1_or_2),_normal_closed-loop_cross-count_ripple_will_cause_adaptive_cells_to_constantly_drift.
    .byte 0x09                       ;Point 1

	;.org	0xc1a2
RPMLIM_NoCellUpdateAboveThisRPMInRPMOver32:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x0603
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoCellUpdateAboveThisRPMInRPMOver32
    ;mptblcname RPMLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 16384 rpm
    ;mptbldesc No_Cell_Update_Above_This_RPM_-_in_rpms/32____OVERVIEW:_RPMLIM_NoCellUpdateAboveThisRPMInRPMOver32_defines_the_maximum_engine_speed_above_which_adaptive_memory_updates_are_locked_out._At_higher_engine_speeds,_rapid_throttle_transients,_high_exhaust_flow_rates,_and_potential_knock_events_make_steady-state_fuel_trim_adaptation_unreliable._To_preserve_calibration_integrity,_the_Chrysler_calibration_locks_adaptive_memory_cell_learning_once_engine_speed_surpasses_RPMLIM._|_TUNER'S_GUIDE:_Stock_Value:_0x2B_(_43_32_=_1376_RPM_)._Why_is_Stock_so_Low?_In_the_stock_T-LM_cal,_Chrysler_restricted_long-term_learning_primarily_to_low-speed_and_off-idle_urban_driving._Raising_RPMLIM_(e.g.,_to_0x60_/_3072_RPM_or_0x80_/_4096_RPM):_Real-World_Tuning_Benefit:_Raising_RPMLIM_allows_the_ECU_to_actively_adapt_fuel_trims_during_steady_65-75_mph_highway_cruising_(typically_2400-3000_RPM)._Without_raising_RPMLIM,_the_ECU_can_never_adapt_highway_cruising_cells_5,_7,_9,_or_11!
    .byte 0x2B                       ;Point 1

	;.org	0xc1a3
MAPLIM_NoCellUpdateAboveThisMAP:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x0610
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname NoCellUpdateAboveThisMAP
    ;mptblcname MAPLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc No_Cell_Update_Above_This_MAP____OVERVIEW:_MAPLIM_NoCellUpdateAboveThisMAP_sets_the_maximum_manifold_absolute_pressure_threshold_above_which_adaptive_fuel_learning_is_completely_inhibited._Closed-loop_stoichiometric_feedback_and_long-term_adaptive_trimming_are_strictly_vacuum/light-load_functions._When_an_engine_enters_positive_boost_pressure,_the_air/fuel_ratio_must_transition_immediately_to_power_enrichment_(11.5:1_-_12.5:1_AFR)_to_protect_against_detonation_and_piston_damage._If_the_ECU_were_permitted_to_adapt_fuel_trims_under_boost,_it_would_misinterpret_rich_boost_mixtures_as_an_error_and_attempt_to_lean_the_engine_out_to_14.7:1!_MAPLIM_acts_as_the_critical_barrier_that_disables_adaptive_learning_whenever_manifold_pressure_exceeds_barometric_pressure._|_TUNER'S_GUIDE:_Stock_Setting:_0x8A_(_~_1.2_psig_/_just_entering_positive_boost)._Tuning_Rule:_Never_set_MAPLIM_substantially_into_boost._It_must_always_stay_at_or_just_below_atmospheric_pressure_(typically_0_to_1_psig)_to_safeguard_boosted_open-loop_fueling.
    ;mpmapaxis y
    .byte 0x8A                       ;Point 1

	;.org	0xc1a4
PWMIN_NoCellUpdateBelow_PWMIN_Pulsewidth:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x061E
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname NoCellUpdateBelow_PWMIN_Pulsewidth
    ;mptblcname PWMIN
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc No_Cell_Update_below_PWMIN_-_this_value_times_4_uSec____OVERVIEW:_PWMIN_NoCellUpdateBelow_PWMIN_Pulsewidth_establishes_the_minimum_injector_pulse_width_threshold_below_which_adaptive_memory_cell_updates_are_prohibited._Fuel_injectors_exhibit_severe_non-linear_flow_characteristics_at_very_short_pulse_widths_(due_to_opening/closing_dead_times_and_mechanical_ball/pintle_inertia)._Adapting_fuel_trims_during_near-zero_pulse_widths_(such_as_during_decel_fuel_cut_or_deep_manifold_vacuum)_leads_to_corrupted_fuel_trims._PWMIN_blocks_adaptive_learning_unless_total_injector_opening_time_is_sufficiently_long_to_guarantee_linear_injector_delivery._|_TUNER'S_GUIDE:_Stock_Value:_0x04B0_(_4.80_ms_)._Crucial_Scaling_for_Larger_Injectors:_When_installing_larger_fuel_injectors_(+20%,_+40%,_+52_lb/hr),_normal_cruise_pulse_widths_drop_substantially_(often_into_the_2.0_ms_-_3.5_ms_range)!_Critical_Bug_Warning:_If_PWMIN_is_left_at_the_stock_4.8_ms_setting_with_large_injectors,_normal_cruise_pulse_width_will_never_exceed_4.8_ms,_completely_disabling_adaptive_memory_learning_forever!_Tuning_Recommendation:_Scale_PWMIN_down_proportionately_with_injector_size_(e.g._2.4_ms_-_3.0_ms_for_+40%_injectors).
    ;mpinjscale word
    .word 0x04B0                     ;Point 1

	;.org	0xc1a6
CELCHG_BitsChangePerUpdateWithinACell:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x062C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BitsChangePerUpdateWithinACell
    ;mptblcname CELCHG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_Bits_Change_Per_Update_Within_A_Cell____OVERVIEW:_CELCHG_BitsChangePerUpdateWithinACell_dictates_the_step_increment_size_by_which_an_adaptive_fuel_memory_cell_is_modified_each_time_an_update_condition_is_triggered._Long-term_fuel_trims_are_designed_to_be_a_slow,_steady_integrator_that_adapts_to_gradual_engine_wear,_air_filter_loading,_or_fuel_seasonal_blend_shifts._CELCHG_governs_the_learning_rate_of_this_integrator._A_value_of_1_bit_ensures_smooth,_gradual_long-term_fuel_adjustment_without_rapid_jumps._|_TUNER'S_GUIDE:_Stock_Setting:_0x01_(_~_0.2%_per_step)._Increasing_CELCHG_(e.g._2_or_3):_Accelerates_adaptive_learning_speed_after_a_battery_disconnect._Risk:_Can_lead_to_adaptive_hunting_or_overshoot_on_bumpy_roads._Tuning_Recommendation:_Keep_at_0x01_for_maximum_calibration_stability.
    .byte 0x01                       ;Point 1

	;.org	0xc1a7
AMTEMP_StartTempToSelectHotOrColdAMTimer:
    ;mpgrp Fuel_-_Adaptive_Memory_Timer\
    ;mptbladdr 0x0639
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StartTempToSelectHotOrColdAMTimer
    ;mptblcname AMTEMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc Starting_Temp_to_select_hot_or_cold_AM_timer____OVERVIEW:_AMTEMP_StartTempToSelectHotOrColdAMTimer_specifies_the_engine_operating_temperature_threshold_that_selects_between_hot_and_cold_adaptive_memory_timer_countdowns._The_engine_thermal_environment_differs_significantly_depending_on_whether_the_engine_was_started_cold_or_warm._When_the_engine_reaches_full_operating_temperature_(AMTEMP),_the_adaptive_timer_begins_counting_down,_unlocking_adaptive_fuel_memory_trimming_once_the_timer_expires._|_TUNER'S_GUIDE:_Stock_Value:_0xCD_(_~_196_degF_)._Thermostat_Considerations:_If_you_install_a_lower-temperature_thermostat_(such_as_a_160_degF_or_180_degF_thermostat)_and_the_engine_never_reaches_196_degF,_the_adaptive_memory_timer_will_never_countdown,_locking_adaptive_fuel_trimming_out_completely!_Tuning_Recommendation:_If_running_a_180_degF_thermostat,_lower_AMTEMP_to_0xB8-0xC0_(165_degF-175_degF)_so_the_ECU_can_adapt_fuel_trims_normally.
    .byte 0xCD                       ;Point 1

	;.org	0xc1a8
AMTML_SelectedAMTimerInitLow:
    ;mpgrp Fuel_-_Adaptive_Memory_Timer\
    ;mptbladdr 0x0646
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SelectedAMTimerInitLow
    ;mptblcname AMTML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_AMTML_SelectedAMTimerInitLow_defines_the_initial_countdown_timer_duration_used_to_inhibit_adaptive_memory_learning_after_a_hot_engine_restart._When_restarting_an_already_warm_engine,_heat_soak_can_cause_temporary_vapor_bubbles_in_the_fuel_rail_or_distorted_intake_charge_temperatures._To_ensure_the_fuel_rail_purges_and_intake_airflow_stabilizes,_AMTML_holds_adaptive_memory_updates_off_for_approximately_3_minutes_after_hot_restart._|_TUNER'S_GUIDE:_Stock_Setting:_0x40_(64_counts_~_3.0_minutes_)._Tuning_Guidance:_Shortening_AMTML_allows_quicker_adaptive_learning_resumption_after_hot_restarts_if_heat_soak_is_well_managed.
    .byte 0x40                       ;Point 1

	;.org	0xc1a9
AMTPSW_TempPointToEnableSelectedAMTimer:
    ;mpgrp Fuel_-_Adaptive_Memory_Timer\
    ;mptbladdr 0x0653
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TempPointToEnableSelectedAMTimer
    ;mptblcname AMTPSW
    ;mpxaxis in 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc AM_temp_inhibit_time_from_coolant_temp____OVERVIEW:_AMTPSW_TempPointToEnableSelectedAMTimer_specifies_the_alternate_(shorter)_countdown_duration_loaded_into_the_adaptive_memory_inhibit_timer_when_starting_the_engine_at_intermediate_coolant_temperatures._If_the_engine_is_started_below_the_full_heat-soak_threshold_(AMTMH),_fuel_rail_vaporization_is_not_an_issue,_so_a_much_shorter_hold_time_(approx._33_seconds)_is_applied_before_adaptive_memory_updates_can_proceed._|_TUNER'S_GUIDE:_Stock_Value:_0x0C_(_12_2.8_s_~_34_seconds_)._Tuning_Guidance:_Stock_values_provide_a_well-balanced_delay_for_warm_restarts.
    .byte 0x0C                       ;Point 1

	;.org	0xc1aa
AMTMH_SelectedAMTimerInitHi:
    ;mpgrp Fuel_-_Adaptive_Memory_Timer\
    ;mptbladdr 0x0660
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SelectedAMTimerInitHi
    ;mptblcname AMTMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_AMTMH_SelectedAMTimerInitHi_is_the_coolant_temperature_threshold_that_distinguishes_a_fully_hot_restart_from_a_warm_restart_for_adaptive_timer_selection._If_the_engine_is_started_with_coolant_temperature_at_or_above_AMTMH,_the_ECU_selects_the_longer_delay_(AMTML,_~3_minutes)_to_account_for_severe_engine_bay_heat_soak._If_below_AMTMH,_the_shorter_delay_(AMTPSW,_~34_seconds)_is_selected._|_TUNER'S_GUIDE:_Stock_Setting:_0xCD_(_~_196_degF_)._Tuning_Note:_Should_match_the_operating_temperature_threshold_set_in_AMTEMP.
    .byte 0xCD                       ;Point 1

	;.org	0xc1ab
AMUPDT_EPPsBetweenCalChangeUpdateOpenThrottle:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x066D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EPPsBetweenCalChangeUpdateOpenThrottle
    ;mptblcname AMUPDT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EPPs_Between_Cal_Change_Update_(Open_Throttle)____OVERVIEW:_AMUPDT_EPPsBetweenCalChangeUpdateOpenThrottle_defines_the_dwell_time_in_engine_events_(distributor_pulses)_that_the_engine_must_continuously_operate_within_a_specific_adaptive_cell_before_an_update_can_occur._Whenever_the_driver_changes_throttle_position_or_engine_load_transitions_to_a_new_adaptive_cell,_the_cell_timer_(AdaptiveCellUpdateTimer_IncrementedEveryDistRisingEdge)_resets_to_zero._The_engine_must_remain_steadily_inside_that_cell_for_at_least_AMUPDT_consecutive_distributor_reference_pulses_before_the_ECU_will_permit_the_cell_to_learn_and_update._This_prevents_transient_driving_and_shifting_through_gears_from_corrupting_steady-state_cells._|_TUNER'S_GUIDE:_Stock_Value:_0x1A_(26_pulses_=_13_crankshaft_rotations_on_a_4-cylinder_engine)._Increasing_AMUPDT:_Requires_longer_steady-state_driving_in_each_cell_before_adaptation_occurs._Filters_out_noise_and_ensures_trim_modifications_reflect_true_steady-state_conditions._Decreasing_AMUPDT:_Speeds_up_adaptive_trim_learning,_but_increases_vulnerability_to_throttle_flutter_and_transient_fueling_noise.
    .byte 0x1A                       ;Point 1

	;.org	0xc1ac
AMLIMH_MaxMultiplierCannotBeAbove7F:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x067A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxMultiplierCannotBeAbove7F
    ;mptblcname AMLIMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AutoCal_Range_Of_Authority_where_MaxMultiplier=1+AMLIMH/512_(cannot_exceed_$7f)____OVERVIEW:_AMLIMH_MaxMultiplierCannotBeAbove7F_establishes_the_maximum_positive_(enrichment)_authority_limit_permitted_for_any_adaptive_fuel_memory_cell._To_prevent_runaway_enrichment_from_an_undetected_vacuum_leak_or_mechanical_failure,_the_ECU_caps_the_maximum_correction_any_adaptive_fuel_cell_can_store._AMLIMH_forms_this_positive_clamp_ceiling_across_all_13_adaptive_memory_cells._|_TUNER'S_GUIDE:_Stock_Value:_0x7F_(+127_decimal)._Max_Multiplier_=_1.0_+_(AMLIMH_/_512)_=_1.0_+_(127_/_512)_~_1.248_(+24.8%)_Tuning_Guidance:_0x7F_is_the_maximum_allowable_positive_number_in_an_8-bit_signed_two's_complement_integer._Never_increase_above_0x7F,_as_doing_so_will_roll_the_value_over_into_a_negative_number_and_trigger_extreme_lean-out!
    .byte 0x7F                       ;Point 1

	;.org	0xc1ad
AMLIML_MinMultiplierCannotBeBelow80:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x0687
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinMultiplierCannotBeBelow80
    ;mptblcname AMLIML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AutoCal_Range_Of_Authority_where_MinMultiplier=.5+AMLIML/512_(cannot_be_below_$80)____OVERVIEW:_AMLIML_MinMultiplierCannotBeBelow80_establishes_the_maximum_negative_(enleanment)_authority_limit_permitted_for_any_adaptive_fuel_memory_cell._This_calibration_constant_prevents_the_adaptive_system_from_pulling_out_dangerous_amounts_of_fuel_if_an_exhaust_leak_or_failing_sensor_tricks_the_ECU_into_thinking_the_mixture_is_excessively_rich._AMLIML_represents_the_floor_below_which_adaptive_fuel_cells_cannot_subtract_fuel._|_TUNER'S_GUIDE:_Stock_Value:_0xB3_(-77_signed_counts)._Min_Multiplier_=_1.0_-_(77_/_512)_~_0.850_(-15.0%)_Asymmetric_Safety:_Consistent_with_short-term_trims_(O2LIML),_adaptive_memory_allows_+24.8%_rich_authority,_but_limits_lean_authority_to_-15.0%_to_safeguard_against_engine_damage.
    .byte 0xB3                       ;Point 1

	;.org	0xc1ae
ADMEMA_ValueFromAdaptivememoryAdder1:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x0694
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ValueFromAdaptivememoryAdder1
    ;mptblcname ADMEMA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_ADMEMA_ValueFromAdaptivememoryAdder1_provides_a_global_calibration_offset_adder_applied_to_learned_adaptive_memory_fuel_modifiers_during_total_fuel_pulse_width_calculation._When_the_ECU_calculates_the_final_composite_fuel_multiplier_in_CalculateSumOfAllFuelModifiers_MM,_it_extracts_the_learned_trim_from_the_active_adaptive_cell_and_compares/offsets_it_with_ADMEMA._In_the_factory_calibration,_ADMEMA_is_set_to_0x00,_allowing_the_learned_cell_value_to_pass_through_unmodified._|_TUNER'S_GUIDE:_Stock_Setting:_0x00_(Neutral)._Tuning_Guidance:_Leave_at_0x00._Modifying_ADMEMA_applies_an_artificial_skew_across_all_adaptive_cells._Fuel_curve_changes_should_be_made_directly_in_base_fuel_tables_(MAPTBL)_rather_than_skewing_the_adaptive_integrator_adder.
    .byte 0x00                       ;Point 1

	;.org	0xc1af
MAPTBL_FuelPartThrottle:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x06A1
    ;mptbltype 1
    ;mpsubtype 1
    ;mptbllname FuelPartThrottle
    ;mptblcname MAPTBL
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Pulsewidth 0 65535 uSec
    ;mptbldesc Fuel_at_Part_Throttle._Other_tweaks_will_be_added_to_this_amount,_to_a_MAXIMUM_of_the_Full_Throttle_table_value.____OVERVIEW:_MAPTBL_FuelPartThrottle_is_the_core_part-throttle_speed-density_fuel_pulse_width_table._In_Chrysler's_speed-density_architecture,_fuel_delivery_is_broken_into_a_base_volumetric_pulse_width_looked_up_by_manifold_pressure_(MAPTBL),_which_is_subsequently_scaled_by_engine_volumetric_pumping_efficiency_(PEFTBL),_charge_air_temperature_(AIRTMP),_and_warm-up_modifiers._MAPTBL_establishes_the_base_fueling_slope_for_light_cruise_and_part-throttle_acceleration_from_deep_vacuum_up_to_positive_manifold_boost._|_TUNER'S_GUIDE:_Increasing_Table_Values_(Richer_Part-Throttle_Fuel):_Effect:_Delivers_longer_injector_pulse_widths_across_the_specified_MAP_range._Real-World_Feel:_Enriches_cruising_air/fuel_ratios,_eliminates_light-throttle_lean_stumbles,_and_cools_down_cruising_exhaust_gas_temperatures_(EGTs)._Decreasing_Table_Values_(Leaner_Part-Throttle_Fuel):_Effect:_Shortens_injector_pulse_widths_across_the_specified_MAP_range._Real-World_Feel:_Leans_out_cruising_AFR_for_improved_fuel_economy._If_leaned_excessively,_causes_cruising_surge,_lean_hesitation,_and_elevated_EGTs._Injector_Rescaling:_Marked_with_,mpinjscale_scale._When_upgrading_injector_sizes_in_MPTune,_MAPTBL_is_scaled_globally_by_the_injector_constant.
    ;mpmapaxis x
    ;mpinjscale scale
    .byte 0x05                   ;Point 1
    .word 0x0000, 0x1E5D
    .byte 0x3C                   ;Point 2
    .word 0x0686, 0x1E0F
    .byte 0x4D                   ;Point 3
    .word 0x0885, 0x185A
    .byte 0x5E                   ;Point 4
    .word 0x0A23, 0x1C8A
    .byte 0x6B                   ;Point 5
    .word 0x0B96, 0x3133
    .byte 0x7F                   ;Point 6
    .word 0x0F6E, 0x1D12
    .byte 0xAA                   ;Point 7
    .word 0x1450, 0x3BC4
    .byte 0xFF

	;.org	0xc1dc
OBCONST_OverboostConstant1:
; this was previously not scaled for 2-bar use correctly...
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x06BF
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostConstant1
    ;mptblcname OBCONST
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc This_value_is_compared_against_the_MAP_Pressure____OVERVIEW:_OBCONST_OverboostConstant1_defines_the_baseline_manifold_pressure_transition_threshold_used_during_running_fuel_pulse_width_and_spark_advance_calculation_to_bifurcate_moderate_part-throttle_fuel_scheduling_from_higher-load_boost_fuel_enrichment._Despite_its_historical_label_name_containing_'Overboost',_in_the_fuel_assembly_logic_this_constant_is_not_the_overboost_fuel_cut_threshold_(which_is_handled_separately_by_boost_limit_routines)._Instead,_OBCONST_serves_as_a_critical_manifold_pressure_breakpoint_where_the_ECU_branches_its_injector_pulse_width_calculation_into_a_dedicated_high-load_scaling_branch._|_TUNER'S_GUIDE:_Stock_Value:_0xAA_(_~_4.9_psig_boost_)._Transition_Point:_Below_4.9_psig_boost,_base_running_fuel_pulse_width_scales_according_to_the_primary_part-throttle_equations._Above_4.9_psig_boost,_additional_slope_multipliers_engage._Tuning_Guidance:_Generally_preserve_at_factory_0xAA_unless_re-scaling_the_entire_boost_fuel_delivery_architecture_for_3-bar_MAP_sensors.
    ;mpmapaxis y
    .byte 0xAA                       ;Point 1

	;.org	0xc1e2
FuelPulsewidthFunctionUnknown:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x06CD
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname FuelPulsewidthFunctionUnknown
    ;mptblcname FPWUNK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_FPWUNK_FuelPulsewidthFunctionUnknown_provides_the_fixed-point_slope_multiplier_used_in_calculating_the_upper-manifold_pressure_fuel_addition_when_manifold_absolute_pressure_exceeds_OBCONST._When_the_turbocharger_spools_and_manifold_pressure_exceeds_4.9_psig_(OBCONST),_the_ECU_executes_a_differential_fuel_calculation:_it_multiplies_the_delta_manifold_pressure_(MAP_-_OBCONST)_by_FPWUNK_to_add_progressive,_non-linear_fuel_enrichment_necessary_to_sustain_combustion_at_high_boost_densities._|_TUNER'S_GUIDE:_Stock_Value:_0x1EB2_(7,858_counts)._Increasing_FPWUNK:_Injects_more_fuel_per_pound_of_boost_above_4.9_psig._Richer_high-boost_mixture._Decreasing_FPWUNK:_Leans_out_fuel_delivery_under_boost._Useful_when_switching_to_larger_fuel_injectors_or_higher_base_fuel_pressure_without_altering_the_base_2D_fuel_curves.
    .word 0x1EB2                     ;Point 1
       ;.inj word scale

	;.org	0xc1e4
PTENR_EppPerAmountForIncreasing:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x06DB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EppPerAmountForIncreasing
    ;mptblcname PTENR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc EPP_per_amount_for_increasing_multiplier____OVERVIEW:_PTENR_EppPerAmountForIncreasing_sets_the_engine_position_pulse_countdown_timer_governing_the_rate_at_which_part-throttle_transient_enrichment_ramps_back_down_toward_baseline_fuel_delivery._Following_a_throttle_tip-in_event_that_triggers_part-throttle_transient_enrichment_(PTE),_extra_fuel_is_delivered_to_overcome_manifold_wall-wetting._PTENR_determines_how_many_distributor_reference_pulses_must_elapse_between_incremental_decays_of_this_transient_enrichment_multiplier._|_TUNER'S_GUIDE:_Stock_Setting:_0x64_(100_pulses)._Increasing_PTENR:_Keeps_transient_enrichment_active_for_more_engine_cycles,_providing_a_richer,_longer_fuel_tail_following_acceleration_tip-in._Helps_prevent_lean_hesitation_on_heavy_vehicles_or_setups_with_large_intake_plenum_volumes._Decreasing_PTENR:_Causes_transient_fuel_to_decay_away_rapidly,_improving_fuel_economy_and_crispness_on_light_cars.
    .byte 0x64                       ;Point 1

	;.org	0xc1e5
LMTOLF1_LimitTimerOpenLoopFraction1:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x06E8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LimitTimerOpenLoopFraction1
    ;mptblcname LMTOLF1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_LMTOLF1_LimitTimerOpenLoopFraction1_defines_the_primary_threshold_for_the_Open_Loop_Fraction_timer_(Timer_OpenLoopFraction)._This_timer_tracks_cumulative_time_spent_in_open-loop_transient_operating_conditions._LMTOLF1_works_in_tandem_with_LMTOLF2_to_control_the_gradual_blending_and_transitions_between_open-loop_transient_enrichment_and_closed-loop_steady-state_fuel_delivery._|_TUNER'S_GUIDE:_Stock_Setting:_0x3C_(60_counts)._Tuning_Guidance:_Maintain_stock_calibration_values_to_preserve_smooth_open-to-closed_loop_transition_timing.
    .byte 0x3C                       ;Point 1

	;.org	0xc1e6
LMTOLF2_LimitTimerOpenLoopFraction2:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x06F5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LimitTimerOpenLoopFraction2
    ;mptblcname LMTOLF2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_LMTOLF2_LimitTimerOpenLoopFraction2_is_one_of_the_most_pervasive_gating_thresholds_in_the_Chrysler_ECU,_referenced_across_O2_processing,_adaptive_memory,_fuel_modifiers,_EVAP_purge_solenoid_control,_and_spark_advance._It_establishes_the_maximum_permissible_open-loop_fraction_time_before_closed-loop_fuel_feedback,_adaptive_fuel_trimming,_and_EVAP_purge_canister_purging_are_allowed_to_engage._If_transient_driving_conditions_keep_Timer_OpenLoopFraction_>=_LMTOLF2,_all_steady-state_feedback_systems_remain_frozen_in_open_loop._|_TUNER'S_GUIDE:_Stock_Value:_0x2B_(43_counts)._System_Interdependence:_Because_LMTOLF2_intersects_with_so_many_subsystems,_altering_it_affects_transient-to-steady-state_transitions_across_fuel,_spark,_and_emissions._Leave_at_factory_0x2B_for_stable_operation.
    .byte 0x2B                       ;Point 1

	;.org	0xc1e7
RPMLMT_RPMLimitForManyThings:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x0702
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimitForManyThings
    ;mptblcname RPMLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_RPMMAP_(labeled_RPMLMT_RPMLimitForManyThings_in_assembly)_serves_as_a_critical_engine_speed_boundary_(1856_RPM)_and_associated_lookup_curve_that_shifts_fuel_pulse_width_calculation_and_ignition_advance_between_low-RPM_lugging_algorithms_and_mid/high-RPM_running_algorithms._At_low_engine_speeds_(under_1856_RPM),_air_velocity_through_the_intake_manifold_runners_is_low,_requiring_distinct_pulse_width_calculation_logic_to_maintain_driveability._Above_RPMMAP,_the_ECU_switches_to_higher-velocity_volumetric_calculations._|_TUNER'S_GUIDE:_Stock_Breakpoint:_0x3A_(_58_32_=_1856_RPM_)._Tuning_Impact:_Defines_the_boundary_where_the_engine_transitions_from_low-speed_torque_management_to_high-speed_power_delivery.
    .byte 0x3A                       ;Point 1

	;.org	0xc1e8
RPMMAP_SwitchPointForDownUp_FromRpm :
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x070F
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname SwitchPointForDownUp_FromRpm
    ;mptblcname RPMMAP
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc EPP_Control_toggle____OVERVIEW:_RPMMAP_(labeled_RPMLMT_RPMLimitForManyThings_in_assembly)_serves_as_a_critical_engine_speed_boundary_(1856_RPM)_and_associated_lookup_curve_that_shifts_fuel_pulse_width_calculation_and_ignition_advance_between_low-RPM_lugging_algorithms_and_mid/high-RPM_running_algorithms._At_low_engine_speeds_(under_1856_RPM),_air_velocity_through_the_intake_manifold_runners_is_low,_requiring_distinct_pulse_width_calculation_logic_to_maintain_driveability._Above_RPMMAP,_the_ECU_switches_to_higher-velocity_volumetric_calculations._|_TUNER'S_GUIDE:_Stock_Breakpoint:_0x3A_(_58_32_=_1856_RPM_)._Tuning_Impact:_Defines_the_boundary_where_the_engine_transitions_from_low-speed_torque_management_to_high-speed_power_delivery.
    ;mpmapaxis y
    .byte 0x04                       ;Number of points in table
    .byte 0x4B, 0xB3, 0xFE, 0xA4     ;Point 1
    .byte 0x64, 0x91, 0xFF, 0x40     ;Point 2
    .byte 0x74, 0x85, 0xFB, 0x80     ;Point 3
    .byte 0x7A, 0x6A                 ;Point 4

	;.org	0xc1fb
RPMPSB_RPMMAPSubtractor:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x0721
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMMAPSubtractor
    ;mptblcname RPMPSB
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_RPMPSB_RPMMAPSubtractor_defines_the_step_decrement_rate_applied_to_the_open-loop_fraction_accumulator_during_engine_deceleration_and_speed_changes._In_A2DScan_MM,_as_engine_operating_conditions_stabilize,_RPMPSB_subtracts_3_counts_per_cycle_from_the_open-loop_timer_accumulator,_steadily_decaying_transient_state_counters_back_toward_steady-state_closed-loop_thresholds._|_TUNER'S_GUIDE:_Stock_Value:_0x03._Tuning_Guidance:_Leave_at_default_0x03_to_maintain_intended_decay_dynamics.
    .byte 0x03                       ;Point 1

	;.org	0xc1fc
WOTTBL_FuelFullThrottle:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x072E
    ;mptbltype 1
    ;mpsubtype 1
    ;mptbllname FuelFullThrottle
    ;mptblcname WOTTBL
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Pulsewidth 0 65535 uSec
    ;mptbldesc Fuel_at_Full_Throttle._This_is_also_a_maximum_for_the_Part_Throttle_value_after_other_tweaks_are_added.____OVERVIEW:_WOTTBL_FuelFullThrottle_is_the_core_wide-open_throttle_(WOT)_fuel_delivery_table_and_the_maximum_allowable_fuel_ceiling_for_part-throttle_boost_enrichment._At_wide-open_throttle_under_turbocharger_boost,_the_engine_operates_in_open-loop_mode_where_maximum_power_and_combustion_safety_require_rich_air/fuel_mixtures_(typically_11.2:1_to_12.0:1_on_pump_gasoline)._WOTTBL_defines_the_base_pulse_width_delivered_under_full_throttle_as_boost_pressure_climbs._Additionally,_during_heavy_part-throttle_boost_acceleration,_the_ECU_clamps_the_modified_part-throttle_fuel_delivery_so_that_it_never_exceeds_the_pulse_width_defined_in_WOTTBL._|_TUNER'S_GUIDE:_Increasing_Table_Values_(Richer_WOT_Fuel):_Effect:_Injects_longer_fuel_pulses_under_boost_and_full_throttle._Real-World_Feel:_Lowers_wide-open_throttle_air/fuel_ratios_(richer),_cools_combustion_chambers,_and_suppresses_detonation_under_boost._Decreasing_Table_Values_(Leaner_WOT_Fuel):_Effect:_Shortens_fuel_pulses_under_boost._Real-World_Feel:_Leans_out_WOT_air/fuel_ratio_for_increased_power,_but_risks_high_cylinder_temperatures_and_dangerous_detonation_if_leaned_beyond_~12.2:1_under_boost.
    ;mpmapaxis x
    ;mpinjscale scale
    .byte 0x00                   ;Point 1
    .word 0x0000, 0x25DA
    .byte 0x6B                   ;Point 2
    .word 0x0FD2, 0x362B
    .byte 0xB3                   ;Point 3
    .word 0x1F0E, 0x369B
    .byte 0xFF

	;.org	0xc211
MAPDEC_NoCellUpdateAndO2CNTRHeldBelowThisMap:
    ;mpgrp Fuel_-_Adaptive_memory\
    ;mptbladdr 0x0743
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname NoCellUpdateAndO2CNTRHeldBelowThisMap
    ;mptblcname MAPDEC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc No_Cell_Update_And_O2CNTR_Held_Below_This_Map._Set_to_0xff_to_disable_O2_feedback.____OVERVIEW:_MAPDEC_NoCellUpdateAndO2CNTRHeldBelowThisMap_is_the_master_manifold_pressure_boundary_above_which_the_closed-loop_O2_controller_is_forced_open-loop_and_adaptive_memory_updates_are_frozen._This_calibration_constant_serves_as_the_definitive_WOT_/_Boost_Open-Loop_switch._Even_if_coolant_temperature,_delay_timers,_and_TPS_thresholds_are_fully_satisfied_for_closed-loop_operation,_if_manifold_pressure_rises_to_or_above_MAPDEC,_the_ECU_immediately_freezes_the_closed-loop_feedback_loop_and_commands_open-loop_power_enrichment._|_TUNER'S_GUIDE:_Stock_Value:_0xAA_(170_counts_~_19.6_psia_~_4.9_psig_boost_)._Disabling_Closed-Loop_Control_Entirely:_Master_Open-Loop_Trick:_Setting_MAPDEC_=_0x00_(or_0x01)_causes_MapValue_>=_MAPDEC_to_evaluate_TRUE_100%_of_the_time,_permanently_disabling_closed-loop_feedback_and_adaptive_memory_updates_under_all_driving_conditions._Extremely_popular_among_tuners_running_aggressive_cam_setups,_drag-race_cars,_or_pure_wideband_open-loop_tuning._Lowering_MAPDEC_(e.g.,_to_atmospheric_/_0x8A):_Ensures_the_engine_drops_cleanly_into_open_loop_the_moment_boost_begins,_preventing_any_closed-loop_feedback_delay_when_rolling_into_boost.
    ;mpmapaxis y
    .byte 0xAA                       ;Point 1

	;.org	0xc212
MAPIDL_FuelBaselineFromMap:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x0751
    ;mptbltype 1
    ;mpsubtype 1
    ;mptbllname FuelBaselineFromMap
    ;mptblcname MAPIDL
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Pulsewidth 0 65535 uSec
    ;mptbldesc Base_Map_Fuel_Pulsewidth.____OVERVIEW:_MAPIDL_FuelBaselineFromMap_is_the_base_fuel_delivery_curve_used_exclusively_at_closed_throttle_(idling_and_trailing_throttle_deceleration_overrun)._When_the_throttle_plates_are_shut,_engine_airflow_dynamics_differ_drastically_from_open-throttle_cruising._The_engine_operates_in_deep_manifold_vacuum_(typically_18_to_22_inHg_vacuum),_and_fuel_puddle_dynamics_on_the_intake_port_walls_stabilize_into_an_idle_film._MAPIDL_provides_a_dedicated_base_pulse_width_curve_optimized_specifically_for_stable_idle_air/fuel_ratios_and_smooth_deceleration_without_backfiring_or_stalling._|_TUNER'S_GUIDE:_Increasing_Table_Values_(Richer_Idle/Decel_Fuel):_Effect:_Enriches_closed-throttle_fuel_delivery._Real-World_Feel:_Stabilizes_idle_on_engines_with_aggressive_camshafts_that_produce_low_or_erratic_idle_vacuum._Eliminates_decel_popping/backfiring_through_the_exhaust_on_trailing_throttle._Decreasing_Table_Values_(Leaner_Idle/Decel_Fuel):_Effect:_Leans_out_closed-throttle_fuel_delivery._Real-World_Feel:_Cleans_up_rich,_smelly_idle_on_engines_with_oversized_fuel_injectors._However,_leaning_excessively_will_cause_idle_surging,_hunting,_or_stalling_when_clutching_in_during_decel.
    ;mpmapaxis x
    ;mpinjscale scale
    .byte 0x0C                   ;Point 1
    .word 0x0000, 0x224C
    .byte 0x27                   ;Point 2
    .word 0x039E, 0x172B
    .byte 0x33                   ;Point 3
    .word 0x04B4, 0x2808
    .byte 0x74                   ;Point 4
    .word 0x0EDE, 0x1042
    .byte 0xFF

	;.org	0xc23b
AIRTMP_FuelEnrichmentFromChargeTemp:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x0768
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelEnrichmentFromChargeTemp
    ;mptblcname AIRTMP
    ;mpxaxis Charge_Temp 0 5 volts
    ;mpyaxis Factor 1 2 factor
    ;mptbldesc Charge_Temp_Factor._Note_that_this_is_an_unfiltered_charge_temp_voltage,_so_higher_numbers_are_lower_temps____OVERVIEW:_AIRTMP_FuelEnrichmentFromChargeTemp_provides_the_intake_air_/_charge_temperature_air_density_fuel_compensation_curve._Air_density_is_inversely_proportional_to_temperature_(Charles's_Law):_colder_intake_air_is_denser_and_contains_more_oxygen_molecules_per_unit_volume,_requiring_proportionally_more_fuel_mass_to_maintain_the_targeted_air/fuel_ratio._Conversely,_hot_intake_air_(common_after_hard_turbo_boost_pulls_or_during_hot_summer_idling)_is_less_dense_and_requires_less_fuel._AIRTMP_dynamically_scales_fuel_injector_pulse_width_based_on_the_thermistor_reading_in_the_intake_manifold._|_TUNER'S_GUIDE:_Cold_Weather_Protection:_In_sub-freezing_winter_weather,_AIRTMP_adds_up_to_+25%_fuel_to_prevent_dangerously_lean_mixtures_under_boost._Hot_Heat-Soak_Protection:_Prevents_over-fueling_and_bogging_when_intake_air_temperatures_rise_after_sitting_in_traffic._Intercooler_Upgrades:_If_installing_a_massive_front-mount_intercooler_(FMIC)_that_drops_charge_temps_by_50_degF-80_degF,_ensure_AIRTMP_has_sufficient_enrichment_at_higher_voltage_points_to_feed_the_denser_charge_air.
    .byte 0x05                       ;Number of points in table
    .byte 0x1A, 0x00, 0x00, 0x29     ;Point 1
    .byte 0x59, 0x0A, 0x00, 0x2F     ;Point 2
    .byte 0x90, 0x14, 0x00, 0x4B     ;Point 3
    .byte 0xE9, 0x2E, 0x01, 0x00     ;Point 4
    .byte 0xFB, 0x40                 ;Point 5

	;.org	0xc24e
FuelLeanoutFactorOnThrottle:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x077A
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelLeanoutFactorOnThrottle
    ;mptblcname FUELLEANOUTFACTORONTHROTTLE
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Factor 1 2 factor
    ;mptbldesc OVERVIEW:_FuelLeanoutFactorOnThrottle_defines_an_RPM-dependent_signed_fuel_pulse_width_modifier_curve_active_during_open-throttle_(on-throttle)_driving._Like_its_closed-throttle_counterpart_(FuelLeanoutFactorOffThrottle),_this_table_is_processed_in_firmware_as_a_signed_two's_complement_table:_Values_below_0x80_(0x00-0x7F)_act_as_positive_modifiers,_scaling_and_adding_fuel_to_the_base_pulse_width_variable_Temp0._Values_with_the_high_bit_set_(0x80-0xFF)_act_as_negative_modifiers,_sign-extending_and_subtracting_fuel_from_Temp0._In_stock_turbocharged_calibrations_(such_as_T_LM_22_MTX_A171_Stock),_this_curve_is_factory-set_to_a_flat_single_point_of_(0xFF,_0x00)._Because_the_factory_return_value_is_0x00,_it_adds_exactly_0_counts_across_all_engine_RPM_when_driving_on-throttle._|_TUNER'S_GUIDE:_Because_the_table_is_processed_as_signed_two's_complement_math:_|_Hex_Value_|_Signed_Decimal_|_Arithmetic_Effect_on_Fuel_Delivery_|_|_:---:_|_:---:_|_:---_|_|_0x00_|_0_|_Neutral_(0_fuel_added_or_subtracted_-_Factory_Stock_Setting)_|_|_0x01_-_0x7F_|_+1_to_+127_|_Adds_fuel_(increases_pulse_width_by_Value_*_8_counts)_|_|_0x80_-_0xFF_|_-128_to_-1_|_Subtracts_fuel_(reduces_pulse_width_by_abs(Value_-_256)_*_8_counts)_|_Practical_Tuning_Tips:_Turbocharged_Engines_(Leave_at_Stock_Zero):_In_turbocharged_applications,_it_is_strongly_recommended_to_leave_this_table_flat_zero_(0x00)._Subtracting_fuel_while_under_load_on-throttle_invites_lean_detonation,_while_adding_fuel_should_primarily_be_tuned_through_volumetric_efficiency_curves_(MAPTBL),_warm_part-throttle_curves_(WARMPT),_or_full-throttle_curves_(WARMFT)._High-Speed_Cruising_Leanout_(N/A_Tuning):_In_naturally_aspirated_or_high-mileage_economy_tuning,_entering_a_small_negative_value_(such_as_0xFE_=_-2_or_0xFD_=_-3,_subtracting_16-24_counts_of_pulse_width)_at_highway_cruising_RPM_(2,000-2,800_RPM)_can_produce_a_modest_lean-burn_fuel_economy_gain_when_cruising_at_light_throttle.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0xc261
FuelLeanoutFactorOffThrottle:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x0788
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelLeanoutFactorOffThrottle
    ;mptblcname FUELLEANOUTFACTOROFFTHROTTLE
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Factor 1 2 factor
    ;mptbldesc OVERVIEW:_Despite_its_historical_disassembly_label_containing_the_word_'Leanout',_FuelLeanoutFactorOffThrottle_actually_functions_as_a_signed_RPM-dependent_fuel_pulse_width_modifier_curve_applied_during_closed-throttle_(off-throttle)_conditions._In_the_Chrysler_Logic_Module_firmware,_this_table_acts_as_a_signed_two's_complement_table:_Return_values_with_the_high_bit_clear_(0x00_to_0x7F,_0_to_+127_decimal)_represent_positive_numbers_that_are_scaled_and_added_to_the_running_base_pulse_width_variable_Temp0._Return_values_with_the_high_bit_set_(0x80_to_0xFF,_-128_to_-1_in_two's_complement)_represent_negative_numbers_that_are_sign-extended_and,_when_added_to_Temp0,_effectively_subtract_from_the_fuel_pulse_width._In_the_factory_calibration:_Low_RPM_Coast_/_Decel_near_Idle_(Point_1,_~896_RPM):_The_table_value_is_0xFA_(-6_in_two's_complement)._This_negative_value_subtracts_fuel_from_Temp0_to_prevent_over-fueling_and_plug_fouling_as_the_engine_drops_down_to_idle._Mid-to-High_RPM_Closed_Throttle_Deceleration_(Points_2-4,_1440_to_2240+_RPM):_The_values_transition_to_positive_(0x0A_=_+10,_0x20_=_+32,_0x22_=_+34),_adding_fuel_back_to_maintain_combustion_stability_and_catalytic_converter_thermal_management_during_decel_coast-down._|_TUNER'S_GUIDE:_Because_this_table_operates_in_signed_two's_complement_math,_tuners_must_understand_the_binary_representation:_|_Hex_Value_|_Signed_Decimal_|_Arithmetic_Effect_on_Fuel_Delivery_|_|_:---:_|_:---:_|_:---_|_|_0x00_|_0_|_Neutral_(0_fuel_added_or_subtracted)_|_|_0x01_-_0x7F_|_+1_to_+127_|_Adds_fuel_(increases_pulse_width_by_Value_*_8_counts)_|_|_0x80_-_0xFF_|_-128_to_-1_|_Subtracts_fuel_(reduces_pulse_width_by_abs(Value_-_256)_*_8_counts)_|_Practical_Tuning_Tips:_Exhaust_Pops_/_Overrun_Burble:_To_create_an_aggressive_overrun_'burble_/_crackle_/_pop'_on_throttle_lift,_change_the_higher_RPM_decel_points_(1500-3000_RPM)_from_positive_values_to_slightly_negative_values_(e.g.,_0xFC_=_-4_or_0xF8_=_-8)_to_lean_the_mixture_into_the_misfire/afterfire_window._Alternatively,_adding_slightly_more_positive_fuel_on_decel_combined_with_ignition_timing_retard_will_dump_unburned_fuel_into_the_turbine_housing_for_aggressive_antilag-style_pops._Decel_Stumble_/_Stall_Prevention:_If_the_engine_dips_and_stumbles_when_popping_the_clutch_or_lifting_off_the_throttle_into_neutral,_check_Point_1_(0x1C_=_896_RPM)._The_factory_negative_value_0xFA_(-6)_pulls_fuel,_if_large_injectors_are_installed,_leaving_this_too_rich_or_too_lean_can_cause_an_idle_dip._Setting_it_closer_to_0x00_or_a_small_positive_value_can_stabilize_off-throttle_idle_catch.
    .byte 0x04                       ;Number of points in table
    .byte 0x1C, 0xFA, 0x00, 0xF1     ;Point 1
    .byte 0x2D, 0x0A, 0x02, 0x00     ;Point 2
    .byte 0x38, 0x20, 0x00, 0x25     ;Point 3
    .byte 0x46, 0x22                 ;Point 4

	;.org	0xc274
PWADD_FuelPWModifierFromBaro:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x0799
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FuelPWModifierFromBaro
    ;mptblcname PWADD
    ;mpxaxis Baro -14.7 14.7 psi
    ;mpyaxis Pulsewidth 0 768 uSec
    ;mptbldesc Additive_Baro_Fuel_Compensation_-_fuel_added_based_on_altitude____OVERVIEW:_PWADD_FuelPWModifierFromBaro_provides_an_additive_pulse_width_trim_curve_based_on_ambient_barometric_pressure_(altitude)._At_high_elevations_(low_barometric_pressure),_atmospheric_air_density_drops,_reducing_cylinder_filling._While_primary_fuel_tables_(MAPTBL)_account_for_manifold_pressure_directly,_PWADD_provides_a_dedicated_offset_table_to_add_or_subtract_a_fixed_pulse_width_based_on_barometric_pressure._|_TUNER'S_GUIDE:_Stock_Calibration:_Flat_zero_(0x00)._The_speed-density_algorithm_and_MAP_sensor_handle_altitude_compensation_naturally_without_needing_an_additive_barometric_offset._Tuning_Guidance:_Leave_at_stock_zero_unless_specifically_compensating_for_non-standard_altitude-dependent_fuel_pressure_regulators.
    ;mpmapaxis x
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1
       ;.inj table scale y

	;.org	0xc27b
FMODDV1_StandardFuelModifierDivisor_1:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x07A9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StandardFuelModifierDivisor_1
    ;mptblcname FMODDV1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_FMODDV1_StandardFuelModifierDivisor_1_serves_as_the_internal_arithmetic_scaling_divisor_used_when_aggregating_composite_fuel_modifiers_into_the_final_running_fuel_multiplier._In_CalculateSumOfAllFuelModifiers_MM,_various_fractional_fuel_compensations_(warmup_decay,_charge_temp,_transient_enrichment)_are_summed._FMODDV1_scales_the_intermediate_sum_to_fit_cleanly_within_16-bit_accumulator_registers_without_mathematical_clipping._|_TUNER'S_GUIDE:_Stock_Setting:_0x1A_(26_decimal)._Do_Not_Touch:_Altering_FMODDV1_warps_the_internal_math_of_all_fuel_modifiers_simultaneously,_causing_gross_fueling_calibration_corruption.
    .byte 0x1A                       ;Point 1

	;.org	0xc27c
PEFTBL_PumpingEfficiency:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x07B6
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname PumpingEfficiency_FromRpm
    ;mptblcname PEFTBL
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis PumpEff 0 100 Percent
    ;mptbldesc Pumping_Efficiency____OVERVIEW:_PEFTBL_PumpingEfficiency_is_the_core_Volumetric_Efficiency_(VE)_curve_vs._Engine_RPM_in_the_Chrysler_speed-density_fuel_algorithm._In_speed-density_engine_management,_fuel_mass_required_is_proportional_to:_Air_Mass_proportional_to_(MAP_Displacement_/_Gas_Constant_Temperature)_*_Volumetric_Efficiency_While_base_manifold_pressure_fuel_tables_(MAPTBL_/_WOTTBL)_scale_with_load,_PEFTBL_models_the_engine's_mechanical_breathing_curve_across_the_rev_range_reflecting_valve_timing,_intake_runner_harmonics,_cylinder_head_port_flow,_and_exhaust_backpressure._|_TUNER'S_GUIDE:_The_Primary_VE_Shaping_Tool:_When_installing_an_aftermarket_performance_camshaft_(e.g._Taft,_FWD-P,_or_custom_grind),_cylinder_filling_shifts_toward_higher_RPMs._Low_RPM_Cam_Drop:_Big_camshafts_breathe_worse_at_low_RPM_(1500_-_2500_RPM)_due_to_overlap_reversion._Lowering_PEFTBL_here_cleans_up_rich_low-RPM_operation._High_RPM_Cam_Peak:_At_4500_-_6000_RPM,_the_big_camshaft_flows_dramatically_more_air._Raising_PEFTBL_here_adds_the_necessary_fuel_to_support_higher_peak_horsepower_without_running_lean_at_the_top_end._Ported_Cylinder_Heads_/_Big_Valves:_Upgrading_cylinder_head_flow_increases_VE_across_the_board,_requiring_corresponding_increases_in_PEFTBL.
    .byte 0x05                       ;Number of points in table
    .byte 0x4B, 0xE7, 0xFF, 0xDB     ;Point 1
    .byte 0x67, 0xE3, 0x00, 0x69     ;Point 2
    .byte 0x7D, 0xEC, 0xFF, 0xF3     ;Point 3
    .byte 0x91, 0xEB, 0xFF, 0x3B     ;Point 4
    .byte 0xB8, 0xCD                 ;Point 5

	;.org	0xc28f
BATOFF_FuelBatteryOffset:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x07C8
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelBatteryOffset
    ;mptblcname BATOFF
    ;mpxaxis Battery 0 16.2 Volts
    ;mpyaxis Pulsewidth 0 4096 uSec
    ;mptbldesc Compensates_for_slower_opening_times_of_injectors_with_lower_voltage.____OVERVIEW:_BATOFF_FuelBatteryOffset_defines_the_injector_dead_time_/_battery_latency_compensation_curve_as_a_function_of_system_electrical_voltage._An_electronic_fuel_injector_is_an_electromagnetic_solenoid_with_mechanical_inertia._When_the_ECU_grounds_the_injector_circuit,_electrical_magnetic_field_buildup_and_pintle_opening_take_a_finite_duration_(typically_0.6_to_1.5_milliseconds)_before_fuel_actually_begins_spraying._At_lower_system_voltages_(such_as_during_starter_cranking_at_9-10V_or_when_the_alternator_fails),_the_coil_builds_magnetic_flux_much_more_slowly,_resulting_in_a_longer_opening_delay._BATOFF_adds_an_additional_voltage-dependent_pulse_width_offset_to_ensure_that_the_actual_effective_fuel_delivery_matches_the_ECU's_calculated_target_regardless_of_electrical_system_fluctuations._|_TUNER'S_GUIDE:_Aftermarket_Injector_Tuning:_When_installing_modern_high-impedance_or_large_aftermarket_injectors_(e.g.,_Bosch_EV14s,_Deka_60s,_or_RC_injectors),_setting_accurate_BATOFF_values_is_critical._Different_injector_coils_have_vastly_different_opening_latencies._Symptoms_of_Incorrect_BATOFF:_If_BATOFF_is_set_too_low:_The_engine_will_run_severely_lean_when_radiator_fans_kick_on,_headlights_are_turned_on,_or_during_starter_cranking._If_BATOFF_is_set_too_high:_The_engine_will_run_excessively_rich_whenever_system_voltage_drops._Idle_Stability:_Because_idle_pulse_widths_are_small_(~1.5-2.5_ms),_dead_time_makes_up_nearly_50%_of_the_total_commanded_pulse_width_at_idle!_Accurate_BATOFF_data_is_essential_for_stable_idle_AFR.
    .byte 0x04                       ;Number of points in table
    .byte 0x59, 0xD5, 0xFD, 0xB5     ;Point 1
    .byte 0x82, 0x77, 0xFF, 0x20     ;Point 2
    .byte 0xC2, 0x3F, 0xFF, 0x90     ;Point 3
    .byte 0xFB, 0x26                 ;Point 4

	;.org	0xc29e
RNFPRD_FuelStartRunTransferPointRpm:
    ;mpgrp Spark_-_Start_to_Run_Transfer\
    ;mptbladdr 0x07D9
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname FuelStartRunTransferPointRpm
    ;mptblcname RNFPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis EPPs 0 65535 epps
    ;mptbldesc OVERVIEW:_RNFPRD_FuelStartRunTransferPointRpm_is_the_fuel_injection_start-to-run_transfer_RPM_threshold._During_cranking,_injectors_deliver_rich,_fixed-duration_priming_pulses_designed_to_wet_the_intake_ports_and_cylinders_so_the_engine_can_catch_fire._Once_the_engine_catches_and_spins_up_past_RNFPRD_(approximately_705_RPM),_the_ECU_cuts_off_cranking_fuel_and_switches_to_normal_running_fuel_calculations_(speed-density_speed/MAP_lookup)._Grouped_under_Spark_-_Start_to_Run_Transfer/_in_the_template_along_with_the_spark_transfer_constants,_RNFPRD_synchronizes_the_fueling_transition_with_the_ignition_transition._|_TUNER'S_GUIDE:_Increasing_the_Value_(Lower_RPM_Threshold):_Effect:_Cuts_off_cranking_enrichment_at_a_lower_RPM_(e.g.,_550_RPM)._Real-World_Driving_Feel:_Prevents_engine_flooding_on_warm_restarts_or_when_running_oversized_fuel_injectors._However,_setting_it_too_low_on_freezing_cold_starts_can_cut_cranking_enrichment_before_the_engine_is_warm_enough_to_run_on_speed-density_fuel,_causing_it_to_die_immediately_after_catching._Decreasing_the_Value_(Higher_RPM_Threshold):_Effect:_Extends_cranking_enrichment_to_higher_engine_speeds_(e.g.,_850_RPM)._Real-World_Driving_Feel:_Helps_cold_starts_catch_solidly_by_delivering_rich_fuel_until_the_engine_flares_fully,_but_risks_loading_up_spark_plugs_with_excess_raw_fuel_on_warm_restarts.
    .word 0x00A7                     ;Point 1

	;.org	0xc2a0
STFPRD_FuelRunStartTransferPointRpm:
    ;mpgrp Spark_-_Start_to_Run_Transfer\
    ;mptbladdr 0x07E6
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname FuelRunStartTransferPointRpm
    ;mptblcname STFPRD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis EPPs 0 65535 epps
    ;mptbldesc OVERVIEW:_STFPRD_FuelRunStartTransferPointRpm_is_the_fuel_stall-detection_hysteresis_threshold_that_drops_fuel_injection_back_from_running_speed-density_mode_into_cranking_enrichment_mode_if_engine_RPM_sags_below_~450_RPM._If_an_engine_stalls_or_the_driver_lugs_it_down_to_near-zero_speed,_speed-density_MAP_readings_become_erratic_and_injectors_cannot_deliver_stable_fuel_pulses._If_engine_RPM_drops_below_STFPRD,_the_ECU_re-engages_starting/cranking_fuel_logic_to_prevent_backfiring_and_assist_the_engine_in_catching_or_restarting_cleanly._|_TUNER'S_GUIDE:_Increasing_the_Value_(Lower_RPM_Threshold):_Effect:_Allows_the_engine_to_drop_lower_in_speed_before_re-triggering_cranking_fuel._Real-World_Driving_Feel:_Prevents_sudden_rich_bogging_when_lugging_the_engine_at_low_speeds._Decreasing_the_Value_(Higher_RPM_Threshold):_Effect:_Re-triggers_cranking_fuel_at_a_higher_speed._Real-World_Driving_Feel:_Drops_back_to_cranking_fuel_sooner_during_stalls._If_set_too_high,_an_abrupt_idle_dip_can_flood_the_engine_with_cranking_fuel.
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
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x0801
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ColdLoadFromCoolantTemp
    ;mptblcname HIGHMP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis enrichment 0 100 Percent
    ;mptbldesc Cold_Load_Enrichment_Factor____OVERVIEW:_HIGHMP_ColdLoadFromCoolantTemp_provides_the_temperature-dependent_gain_for_Cold_Engine_High-Load_Enrichment._Accelerating_under_heavy_engine_load_(or_climbing_a_hill)_while_an_engine_is_still_cold_requires_substantially_more_supplemental_fuel_than_cold_idling_does,_because_the_high_manifold_air_mass_will_condense_fuel_against_cold_intake_walls._HIGHMP_scales_this_heavy-load_warmup_enrichment_based_on_coolant_temperature,_tapering_to_zero_once_the_engine_reaches_196_degF._|_TUNER'S_GUIDE:_Cold_Driveability:_Prevents_cold-engine_hesitation_or_backfiring_when_accelerating_onto_the_highway_immediately_after_starting._Tuning_Guidance:_If_an_engine_bogs_heavily_under_throttle_when_cold,_slightly_decrease_HIGHMP._If_it_stumbles_lean,_increase_it.
    .byte 0x03                       ;Number of points in table
    .byte 0x84, 0x6F, 0xFF, 0x1E     ;Point 1
    .byte 0x95, 0x60, 0xFE, 0x49     ;Point 2
    .byte 0xCD, 0x00                 ;Point 3

	;.org	0xc2b1
HMPMUL_ColdLoadFromMAP:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x0811
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname ColdLoadFromMAP
    ;mptblcname HMPMUL
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Facto 0 100 percent
    ;mptbldesc Cold_Load_Enrichment_Multiplier____OVERVIEW:_HMPMUL_ColdLoadFromMAP_defines_the_manifold_load_weighting_curve_for_cold-engine_high-load_enrichment._Works_in_partnership_with_HIGHMP:_while_HIGHMP_dictates_how_cold_the_engine_is,_HMPMUL_dictates_how_heavily_the_throttle_is_loaded._At_high_vacuum_(idle/coast),_HMPMUL_is_near_zero_(no_cold_load_fuel_added)._As_manifold_pressure_climbs_toward_atmospheric_pressure_and_boost,_HMPMUL_ramps_up_to_deliver_full_cold-load_enrichment._|_TUNER'S_GUIDE:_Load_Progression:_Ensures_cold_enrichment_is_applied_only_when_the_engine_is_under_load,_keeping_cold_idle_smooth_and_unflooded.
    ;mpmapaxis x
    .byte 0x04                       ;Number of points in table
    .byte 0x2E, 0x00, 0x00, 0xAB     ;Point 1
    .byte 0x55, 0x1A, 0x00, 0x2D     ;Point 2
    .byte 0x83, 0x22, 0xFE, 0xB3     ;Point 3
    .byte 0x97, 0x08                 ;Point 4

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
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x0830
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelColdEnrichmentCurveB
    ;mptblcname CURVEB
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 2 factor
    ;mptbldesc Coldenrichment_factor_=_1_+_(_(CurveA_*_ADVDCY/256_+_CurveC_*_ADVDCY/256_+_CurveB_*_FCRCVB/256_)_/_32_)_*_BAROCP/256____OVERVIEW:_CURVEB_FuelColdEnrichmentCurveB_is_the_long-term_/_steady-state_warm-up_enrichment_curve_applied_as_the_engine_warms_from_cold_start_up_to_normal_operating_temperature._Chrysler_divides_cold_engine_running_enrichment_into_three_distinct_curves:_Curve_A_(CURVEA):_Short-term_post-start_enrichment_that_decays_rapidly_within_30-60_seconds_after_startup._Curve_B_(CURVEB):_Long-term_coolant-temperature_enrichment_that_tracks_the_actual_physical_warm-up_of_the_engine_block_and_coolant_from_ice_cold_up_to_~140_degF+._Curve_C_(CURVEC):_Intermediate_transition_enrichment_curve._CURVEB_ensures_that_as_the_engine_is_driven_during_the_first_5_to_10_minutes_of_warm-up,_the_air/fuel_mixture_remains_sufficiently_rich_to_compensate_for_incomplete_fuel_vaporization_and_cold_intake_port_wall_condensation._|_TUNER'S_GUIDE:_Increasing_Table_Values_(Richer_Warm-Up):_Injects_additional_fuel_during_the_extended_warm-up_period._Real-world_feel:_Eliminates_cold_bucking,_stumbling,_or_surging_during_light_acceleration_in_the_first_few_minutes_of_driving_after_a_cold_start._Decreasing_Table_Values_(Leaner_Warm-Up):_Leans_out_fuel_delivery_during_warm-up._Real-world_feel:_Cleans_up_rich,_sooty_warm-up_mixtures,_saves_fuel,_and_improves_emissions,_but_if_leaned_too_far,_causes_cold_throttle_hesitation._Warm_Operating_Boundary:_Notice_that_by_0x9B_(~120-140_degF),_CURVEB_drops_to_zero_(0x00),_transitioning_the_engine_to_pure_warmed-up_speed-density_fueling.
    .byte 0x06                       ;Number of points in table
    .byte 0x58, 0x70, 0xFE, 0x37     ;Point 1
    .byte 0x74, 0x3E, 0xFE, 0x65     ;Point 2
    .byte 0x90, 0x11, 0xFE, 0x74     ;Point 3
    .byte 0x9B, 0x00, 0x00, 0x00     ;Point 4
    .byte 0xEE, 0x00, 0x00, 0xE9     ;Point 5
    .byte 0xF9, 0x0A                 ;Point 6

	;.org	0xc2db
CURVEA_FuelColdEnrichmentCurveA:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x0843
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelColdEnrichmentCurveA
    ;mptblcname CURVEA
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 1 2 factor
    ;mptbldesc Coldenrichment_factor_=_1_+_(_(CurveA_*_ADVDCY/256_+_CurveC_*_ADVDCY/256_+_CurveB_*_FCRCVB/256_)_/_32_)_*_BAROCP/256____OVERVIEW:_CURVEA_FuelColdEnrichmentCurveA_is_the_initial_post-start_enrichment_curve_(often_called_'After-Start_Enrichment'_or_ASE)._Immediately_after_an_engine_starts,_the_intake_ports_are_wet_with_raw_fuel_but_the_combustion_chamber_surfaces_and_valve_faces_are_still_cold._The_engine_requires_a_temporary_burst_of_heavy_enrichment_during_the_first_15_to_60_seconds_of_running_to_ensure_smooth_idle_and_clean_initial_throttle_tip-in._CURVEA_establishes_the_magnitude_of_this_initial_post-start_enrichment_as_a_function_of_coolant_temperature,_which_is_held_for_a_set_duration_(CLDHLD_/_HOTHLD)_before_decaying_away_via_DCYTMC_or_DCYTMH._|_TUNER'S_GUIDE:_Increasing_Table_Values_(Richer_Post-Start):_Delivers_heavier_enrichment_during_the_first_30-60_seconds_after_startup._Real-world_feel:_Fixes_post-start_idle_stumble_or_stalling_that_occurs_5-10_seconds_after_a_cold_morning_start._Decreasing_Table_Values_(Leaner_Post-Start):_Leans_out_initial_post-start_fuel._Real-world_feel:_Eliminates_strong_raw_gasoline_odor_and_black_exhaust_smoke_immediately_after_warm_restarts.
    .byte 0x05                       ;Number of points in table
    .byte 0x58, 0xFF, 0xFA, 0xCA     ;Point 1
    .byte 0x74, 0x6D, 0xFD, 0x80     ;Point 2
    .byte 0x84, 0x45, 0xFD, 0x5B     ;Point 3
    .byte 0x92, 0x20, 0xFF, 0xEB     ;Point 4
    .byte 0xCC, 0x1A                 ;Point 5

	;.org	0xc2f2
CURVEC_FuelColdEnrichmentCurveC:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x0855
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname FuelColdEnrichmentCurveC
    ;mptblcname CURVEC
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 1 3 factor
    ;mptbldesc Coldenrichment_factor_=_1_+_(_(CurveA_*_ADVDCY/256_+_CurveC_*_ADVDCY/256_+_CurveB_*_FCRCVB/256_)_/_32_)_*_BAROCP/256____OVERVIEW:_CURVEC_FuelColdEnrichmentCurveC_is_the_intermediate_warm-up_enrichment_curve_in_Chrysler's_tripartite_cold_enrichment_architecture._While_CURVEA_provides_high_initial_enrichment_that_fades_quickly_and_CURVEB_provides_long-duration_enrichment_that_tracks_engine_metal_temperature,_CURVEC_fills_the_intermediate_window._It_provides_supplementary_fueling_during_the_critical_1_to_3_minute_driving_window_where_Curve_A_has_decayed_but_the_engine_oil,_intake_manifold,_and_combustion_chambers_have_not_yet_absorbed_enough_heat_to_sustain_pure_Curve_B_operation._|_TUNER'S_GUIDE:_Increasing_Table_Values_(Richer_Intermediate_Warmup):_Delivers_extra_fuel_during_the_intermediate_warm-up_phase_(1-3_minutes_into_driving)._Real-world_feel:_Fixes_lean_hesitations_or_stumbling_that_occur_just_as_the_vehicle_drives_out_of_the_driveway_on_cold_mornings._Decreasing_Table_Values_(Leaner_Intermediate_Warmup):_Leans_out_intermediate_warmup_fuel_delivery.
    .byte 0x05                       ;Number of points in table
    .byte 0x79, 0x3A, 0xFF, 0x8C     ;Point 1
    .byte 0x84, 0x35, 0xFF, 0xC7     ;Point 2
    .byte 0x8D, 0x33, 0xFE, 0xCD     ;Point 3
    .byte 0x92, 0x2D, 0xFE, 0xDF     ;Point 4
    .byte 0xA9, 0x13                 ;Point 5

	;.org	0xc309
DCYTMC_CurveAColdDecayTime:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x0867
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAColdDecayTime
    ;mptblcname DCYTMC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Curve_A_Cold_Decay_Time_-_value_=_89.76_divided_by_this_number____OVERVIEW:_DCYTMC_CurveAColdDecayTime_sets_the_decay_rate_of_post-start_enrichment_(CURVEA)_when_the_engine_is_started_cold_(coolant_temperature_below_TMPHLD)._After_the_cold_hold_time_(CLDHLD)_expires,_the_ECU_gradually_steps_down_Curve_A's_enrichment_factor_to_zero._DCYTMC_dictates_how_quickly_this_ramp-down_occurs._|_TUNER'S_GUIDE:_Decay_Formula:_Decay_time_in_seconds_is_calculated_as:_Decay_Duration_~_(89.76_/_DCYTMC)_Increasing_Value:_Results_in_a_faster_decay_rate_(Curve_A_enrichment_fades_out_more_quickly)._Decreasing_Value:_Results_in_a_slower_decay_rate_(Curve_A_enrichment_lingers_longer).
    .byte 0x04                       ;Point 1

	;.org	0xc30a
DCYTMH_CurveAHotDecayTime:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x0874
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAHotDecayTime
    ;mptblcname DCYTMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Curve_A_Hot_Decay_Time_-_value_=_89.76_divided_by_this_number____OVERVIEW:_DCYTMH_CurveAHotDecayTime_sets_the_decay_rate_of_post-start_enrichment_(CURVEA)_when_the_engine_is_started_hot_(coolant_temperature_at_or_above_TMPHLD)._Because_a_warm_engine_already_has_hot_intake_valves_and_warm_combustion_chamber_walls,_it_does_not_need_prolonged_post-start_enrichment._DCYTMH_provides_a_much_faster_decay_rate_(stock_0x09_vs_cold_0x04)_so_the_ECU_returns_to_normal_closed-loop_running_fuel_quickly._|_TUNER'S_GUIDE:_Decay_Formula:_Hot_Decay_Duration_~_(89.76_/_DCYTMH)_Stock_Setting_(0x09):_Yields_a_rapid_decay_of_roughly_~10_seconds,_clearing_out_excess_fuel_quickly_on_warm_restarts.
    .byte 0x09                       ;Point 1

	;.org	0xc30b
CLDHLD_CurveAColdHoldTime:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x0881
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAColdHoldTime
    ;mptblcname CLDHLD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 180 out
    ;mptbldesc Curve_A_Cold_Hold_time_-_value_=_this_number_times_.704_sec____OVERVIEW:_CLDHLD_CurveAColdHoldTime_specifies_the_duration_that_post-start_enrichment_(CURVEA)_is_held_at_100%_full_strength_before_decay_begins,_following_a_cold_engine_start._On_freezing_mornings,_starting_the_decay_of_post-start_fuel_immediately_after_startup_causes_the_engine_to_lean_out_and_stumble_as_soon_as_the_driver_puts_the_car_in_gear._CLDHLD_locks_Curve_A_at_full_enrichment_for_a_solid_~90_seconds_to_allow_combustion_stability_to_establish._|_TUNER'S_GUIDE:_Increasing_the_Value:_Holds_full_cold_after-start_enrichment_longer_(e.g.,_2+_minutes)._Helpful_for_extreme_sub-zero_winter_climates_or_E85_conversions._Decreasing_the_Value:_Begins_decaying_cold_enrichment_sooner.
    .byte 0x80                       ;Point 1

	;.org	0xc30c
HOTHLD_CurveAHotHoldTime:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x088E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CurveAHotHoldTime
    ;mptblcname HOTHLD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Curve_A_Hot_Hold_Time_-_value_=_this_number_times_.704_sec____OVERVIEW:_HOTHLD_CurveAHotHoldTime_sets_the_duration_that_post-start_enrichment_(CURVEA)_is_held_at_full_strength_when_restarting_a_warm/hot_engine._On_a_warm_engine,_holding_post-start_fuel_for_90_seconds_(like_cold_starts)_would_cause_severe_rich_loading_and_exhaust_odor._HOTHLD_restricts_the_warm_hold_time_to_just_~15_seconds-just_long_enough_to_clear_vapor_bubbles_from_the_fuel_rail_after_hot_soak._|_TUNER'S_GUIDE:_Increasing_Value:_Extends_the_hold_window_on_warm_starts,_helping_combat_hot-soak_vapor_lock_or_lean_surges_on_quick_gas_station_restarts._Decreasing_Value:_Reduces_warm_start_hold_time.
    .byte 0x15                       ;Point 1

	;.org	0xc30d
TMPHLD_TempSwitchPointForCurveAHoldDecay:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x089B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TempSwitchPointForCurveAHoldDecay
    ;mptblcname TMPHLD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Temperature_switch_point_for_Curve_A_Hold_and_Decay_times____OVERVIEW:_TMPHLD_TempSwitchPointForCurveAHoldDecay_is_the_coolant_temperature_switch_point_that_selects_between_the_Cold_Hold/Decay_parameters_(CLDHLD_&_DCYTMC)_and_the_Hot_Hold/Decay_parameters_(HOTHLD_&_DCYTMH)._|_TUNER'S_GUIDE:_Thermostat_Matching:_In_stock_calibrations,_0xB2_corresponds_to_~178_degF,_matching_the_OEM_180_degF_thermostat._If_using_a_cooler_160_degF_thermostat,_lowering_TMPHLD_slightly_ensures_the_ECU_correctly_classifies_warm_restarts_under_hot_decay_rules.
    .byte 0xB2                       ;Point 1

	;.org	0xc30e
CCURV_HoldTimeForCurveC:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x08A8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HoldTimeForCurveC
    ;mptblcname CCURV
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 180 out
    ;mptbldesc Hold_Time_for_Curve_C_-_value_=_this_number_times_.704_sec____OVERVIEW:_CCURV_HoldTimeForCurveC_specifies_the_duration_that_intermediate_cold_enrichment_(CURVEC)_is_held_at_full_strength_before_decay_begins._|_TUNER'S_GUIDE:_Tuning_Tip:_Increasing_CCURV_extends_the_initial_dwell_of_intermediate_enrichment,_helping_smooth_cold-start_transitions_on_vehicles_with_large_aftermarket_intake_manifolds_or_cold_aluminum_cylinder_heads.
    .byte 0x0A                       ;Point 1

	;.org	0xc30f
DCYCC_DecayRateForCurveC:
    ;mpgrp Fuel_-_Running\
    ;mptbladdr 0x08B5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DecayRateForCurveC
    ;mptblcname DCYCC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Decay_Rate_for_Curve_C_-_value_=_89.76_divided_by_this_number____OVERVIEW:_DCYCC_DecayRateForCurveC_dictates_the_decay_rate_of_intermediate_warm-up_enrichment_(CURVEC)._After_intermediate_enrichment_is_held_for_the_duration_specified_by_CCURV,_DCYCC_controls_the_speed_at_which_Curve_C's_enrichment_multiplier_ramps_down_to_zero._|_TUNER'S_GUIDE:_Increasing_the_Value:_Causes_intermediate_warm-up_enrichment_to_decay_faster_(shorter_duration)._Decreasing_the_Value:_Causes_intermediate_warm-up_enrichment_to_decay_slower_(longer_duration).
    .byte 0x0D                       ;Point 1

	;.org	0xc310
BAROCP_BaroCompensationOfWarmupFactor_FromBaro:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x08C2
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BaroCompensationOfWarmupFactor_FromBaro
    ;mptblcname BAROCP
    ;mpxaxis Baro -14.7 14.7 psi
    ;mpyaxis Factor 0 100 Percent
    ;mptbldesc Baro_compensation_of_Warmup_Factor____OVERVIEW:_BAROCP_BaroCompensationOfWarmupFactor_FromBaro_scales_cold_warmup_fuel_enrichment_based_on_ambient_atmospheric_pressure_(altitude)._At_high_elevations,_reduced_ambient_barometric_pressure_decreases_overall_air_density._In_cold_weather_at_high_altitudes,_applying_full_sea-level_cold_enrichment_would_over-fuel_the_engine_and_cause_rich_cold-start_stalling._BAROCP_reduces_the_cold_warmup_enrichment_multiplier_at_lower_barometric_pressures._|_TUNER'S_GUIDE:_Stock_Values:_Factory_values_maintain_full_warmup_fuel_at_sea_level_and_taper_fuel_slightly_at_mountain_elevations_(e.g._5,000+_ft_in_Denver)._Tuning_Guidance:_Preserve_factory_curve.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x5F, 0xF3, 0x01, 0x00     ;Point 1
    .byte 0x6B, 0xFF                 ;Point 2

	;.org	0xc317
RUNTMP_ModifierOf_ENGTMP_FromStalltime:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x08D2
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ModifierOf_ENGTMP_FromStalltime
    ;mptblcname RUNTMP
    ;mpxaxis time_after_stall 0 720 sec
    ;mpyaxis delta 0 720 temp
    ;mptbldesc Delta_modifier_added_to_engine_temp_after_a_stall_before_key_on._This_is_to_approximate_heat_soak____OVERVIEW:_RUNTMP_ModifierOf_ENGTMP_FromStalltime_models_engine_heat_soak_following_an_engine_stall_or_brief_hot_restart._When_a_hot_engine_is_shut_off_or_stalls,_the_coolant_water_pump_stops_circulating,_causing_engine_block_and_cylinder_head_temperatures_to_soak_upward_while_coolant_temperature_around_the_sensor_momentarily_lags._RUNTMP_adds_a_virtual_temperature_boost_to_measured_coolant_temperature_based_on_elapsed_stall_time_to_approximate_true_combustion_chamber_heat_soak._|_TUNER'S_GUIDE:_Preventing_Hot_Restart_Flooding:_By_recognizing_that_the_engine_metal_is_hotter_than_the_stagnant_coolant_sensor_indicates,_this_table_prevents_the_ECU_from_injecting_unnecessary_cold-start_fuel_on_quick_restarts.
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x00, 0x03, 0xAB     ;Point 1
    .byte 0x06, 0x16, 0x09, 0x00     ;Point 2
    .byte 0x0B, 0x43                 ;Point 3

	;.org	0xc322
RUNLMT_MaxAllowableTempFor_RUNTMP:
    ;mpgrp Fuel_-_Modifiers\
    ;mptbladdr 0x08E2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxAllowableTempFor_RUNTMP
    ;mptblcname RUNLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Degrees
    ;mptbldesc Max_allowable_temp_for_RUNTMP_(heat_soak_approximation)____OVERVIEW:_RUNLMT_MaxAllowableTempFor_RUNTMP_defines_the_maximum_baseline_coolant_temperature_below_which_heat_soak_addition_(RUNTMP)_is_permitted._Heat_soak_modeling_is_only_relevant_when_an_engine_stalls_while_warming_up._If_the_engine_is_already_at_operating_temperature,_heat_soak_calculations_are_bypassed_to_prevent_artificial_temperature_inflation._|_TUNER'S_GUIDE:_Stock_Setting:_0x95_(_~_64_degF_)._Tuning_Guidance:_Leave_at_stock_setting.
    .byte 0x95                       ;Point 1

	;.org	0xc323
MAPTRG_DeltaMapTriggerLevel:
    ;mpgrp Fuel_-_Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x08EF
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMapTriggerLevel
    ;mptblcname MAPTRG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc MAP_Delta_required_to_trigger_transient_enrichment____OVERVIEW:_MAPTRG_DeltaMapTriggerLevel_establishes_the_minimum_rate_of_manifold_pressure_increase_(_DeltaMAP_)_required_to_fire_a_MAP_Acceleration_Enrichment_Pump_Shot._When_the_throttle_is_snapped_open,_manifold_absolute_pressure_spikes_upward_almost_instantly._This_sudden_pressure_jump_causes_fuel_droplets_in_the_intake_runner_to_fall_out_of_suspension,_leading_to_a_momentary_lean_stumble_('tip-in_leanout')_unless_compensated_immediately._If_the_instantaneous_increase_in_manifold_pressure_exceeding_the_rolling_average_exceeds_MAPTRG,_the_ECU_fires_an_asynchronous_extra_fuel_pulse_(analogous_to_the_accelerator_pump_on_a_carburetor)._|_TUNER'S_GUIDE:_Stock_Value:_0x05_(_~_0.58_psi_jump)._Lowering_MAPTRG_(e.g.,_to_2_or_3_counts):_Makes_the_ECU_highly_sensitive_to_throttle_movements,_firing_acceleration_enrichment_on_smaller_throttle_nudges._Eliminates_tip-in_hesitation,_but_if_set_too_low,_minor_manifold_pressure_pulsations_from_aggressive_camshafts_will_cause_false_pump_shots_and_wasted_fuel._Raising_MAPTRG:_Requires_a_more_aggressive_throttle_stab_before_enrichment_triggers.
    ;mpmapaxis y
    .byte 0x05                       ;Point 1

	;.org	0xc324
MAPMAX_MaxDeltaMapAllowed:
    ;mpgrp Fuel_-_Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x08FD
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MaxDeltaMapAllowed
    ;mptblcname MAPMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP 0 29.4 psi
    ;mptbldesc Maximum_Delta_MAP_allowed____OVERVIEW:_MAPMAX_MaxDeltaMapAllowed_defines_the_maximum_allowable_DeltaMAP_value_permitted_when_calculating_the_size_of_a_MAP_acceleration_enrichment_pump_shot._If_the_driver_violently_stomps_the_gas_pedal_from_deep_vacuum_(25_inHg_vac)_to_full_atmospheric_pressure_or_boost,_the_calculated_delta_MAP_could_theoretically_produce_an_excessively_large_pump_shot_that_bogs_or_drowns_the_engine._MAPMAX_acts_as_the_safety_ceiling,_clamping_the_calculated_DeltaMAP_before_it_is_multiplied_by_the_temperature_enrichment_curve_(AESLOP)._|_TUNER'S_GUIDE:_Stock_Value:_0xFF_(255_counts_-_completely_uncapped)._Tuning_Guidance:_In_stock_form,_Chrysler_left_this_ceiling_at_255_to_allow_full_maximum_pump_shot_delivery_on_violent_throttle_stabs._If_upgrading_to_massive_injectors_(+52_lb/hr)_and_rapid_throttle_snapping_causes_a_momentary_rich_stumble/bog,_lowering_MAPMAX_caps_the_maximum_pump_shot_volume.
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1

	;.org	0xc325
AESLOP_DeltaMAPEnrichment_FromTemp2:
    ;mpgrp Fuel_-_Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x090B
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname DeltaMAPEnrichment_FromTemp2
    ;mptblcname AESLOP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis pwEnrich 0 255 uS/torr
    ;mptbldesc Transient_Enrichment_PW_Addition____OVERVIEW:_AESLOP_DeltaMAPEnrichment_FromTemp2_defines_the_temperature-dependent_gain_curve_for_MAP-based_acceleration_enrichment_pump_shots._Cold_intake_manifolds_require_substantially_larger_acceleration_fuel_shots_than_warm_manifolds_because_cold_fuel_does_not_atomize_readily_and_coats_the_intake_runner_walls._AESLOP_provides_high_fuel_multipliers_when_coolant_temperature_is_cold,_decaying_down_to_lower_values_as_the_engine_reaches_operating_temperature._|_TUNER'S_GUIDE:_Increasing_AESLOP_Values:_Injects_more_fuel_on_quick_throttle_movements._Cures_lean_tip-in_stumbles,_backfiring_through_the_intake_manifold,_or_hesitations_upon_sudden_acceleration._Decreasing_AESLOP_Values:_Necessary_when_installing_larger_injectors._If_not_scaled_down,_large_injectors_will_cause_rich_bogging_and_black_puff_smoke_upon_every_throttle_punch.
    ;mpmapaxis -y
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x58, 0x23, 0xFF, 0xC9     ;Point 1
    .byte 0x95, 0x16, 0xFF, 0xA9     ;Point 2
    .byte 0xCD, 0x03                 ;Point 3

	;.org	0xc330
AETIME_EnrichmentTime_FromTemp:
    ;mpgrp Fuel_-_Transient_Enrichment\PumpShot_Calculation\MAP_PumpShot\
    ;mptbladdr 0x091D
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname EnrichmentTime_FromTemp_MAP
    ;mptblcname AETIME
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis time_const 0 100 percent
    ;mptbldesc MAP_Transient_Enrich_Time_Constant_when_MAP_gt_AVMAP____OVERVIEW:_AETIME_EnrichmentTime_FromTemp_establishes_the_decay_time_constant_for_MAP-based_transient_enrichment._Once_a_MAP_acceleration_enrichment_shot_is_triggered,_the_extra_fuel_pulse_should_not_vanish_instantly_on_the_very_next_cycle,_nor_should_it_linger_forever._AETIME_defines_the_exponential_decay_rate_at_which_the_MAP_transient_fuel_addition_bleeds_down_back_to_zero._|_TUNER'S_GUIDE:_Stock_Setting:_0x14_(20_counts)._Increasing_AETIME:_Stretches_the_duration_of_the_MAP_pump_shot_across_more_engine_revolutions._Helps_engines_with_heavy_turbo_lag_or_large_intake_plenums_maintain_smooth_AFR_while_boost_builds._Decreasing_AETIME:_Quenches_the_pump_shot_quicker.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x14                 ;Point 1

	;.org	0xc337
POSTRG_PositiveTransientTriggerLevel:
    ;mpgrp Fuel_-_Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0x092B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PositiveTransientTriggerLevel
    ;mptblcname POSTRG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Positive_Transient_Enrich_Trigger_Level_in_volts_times_0.02____OVERVIEW:_POSTRG_PositiveTransientTriggerLevel_sets_the_throttle_position_sensor_delta_trigger_threshold_(_DeltaTPS_)_required_to_fire_a_TPS_Acceleration_Enrichment_Pump_Shot._While_manifold_pressure_(MAPTRG)_detects_incoming_air_density_changes,_the_throttle_position_sensor_(TPS)_detects_the_driver's_physical_foot_movement_before_the_air_has_even_passed_the_throttle_blade._POSTRG_acts_as_the_immediate,_early-warning_trigger:_if_the_throttle_blade_moves_open_faster_than_POSTRG_(_0.08V_),_a_TPS_acceleration_pump_shot_is_fired_instantly._|_TUNER'S_GUIDE:_Stock_Value:_0x04_(_0.08_V_throttle_opening)._Lowering_POSTRG:_Increases_throttle_hair-trigger_response._If_set_too_sensitive_(e.g._1_count_/_0.02V),_foot_vibration_over_bumps_will_trigger_unintended_pump_shots._Raising_POSTRG:_Dulls_throttle_sensitivity,_requiring_a_deliberate_press_before_TPS_pump_shot_activates.
    .byte 0x04                       ;Point 1

	;.org	0xc338
THRMAX_MaxDeltaTHR:
    ;mpgrp Fuel_-_Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0x0938
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxDeltaTHR
    ;mptblcname THRMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Max_Delta_THR_(THR-AVTHR-POSTRG)_-_value_of_$26_is_.51_volts____OVERVIEW:_THRMAX_MaxDeltaTHR_defines_the_maximum_allowable_DeltaTPS_clamp_applied_when_calculating_the_volume_of_a_TPS_acceleration_pump_shot._If_the_throttle_is_smashed_wide_open_from_idle_(a_3.5V+_delta),_an_uncapped_TPS_calculation_would_inject_an_overwhelming_flood_of_fuel._THRMAX_clamps_the_effective_throttle_opening_delta_to_0x26_(_0.76V_),_preventing_throttle-stomp_engine_drowning._|_TUNER'S_GUIDE:_Stock_Setting:_0x26_(_0.76_V_)._Scaling_for_Large_Injectors:_When_upgrading_to_large_injectors_(+40%,_+52_lb/hr),_reducing_THRMAX_prevents_the_car_from_bogging_or_stumbling_rich_when_the_throttle_is_kicked_open_aggressively_from_a_dead_stop.
    .byte 0x26                       ;Point 1

	;.org	0xc339
POSSLP_DeltaTPSEnrichment_FromTemp:
    ;mpgrp Fuel_-_Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0x0945
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname Enrichment_FromTemp
    ;mptblcname POSSLP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis pw 0 60 ms/volt
    ;mptbldesc Throttle_Transient_Enrich_PW_Addition____OVERVIEW:_POSSLP_DeltaTPSEnrichment_FromTemp_defines_the_temperature-dependent_gain_curve_for_TPS-based_acceleration_enrichment_pump_shots._Whenever_the_throttle_blade_is_opened_rapidly_(_>_POSTRG_),_the_engine_requires_an_instant_squirt_of_fuel_before_the_manifold_pressure_change_can_be_measured._POSSLP_scales_the_magnitude_of_this_pump_shot_according_to_engine_coolant_temperature,_delivering_heavy_enrichment_on_cold_engines_and_tapering_down_to_moderate_enrichment_at_operating_temperature._|_TUNER'S_GUIDE:_Increasing_Table_Values:_Cures_instant_off-idle_hesitation_or_stumble_when_stabbing_the_throttle_pedal._Decreasing_Table_Values:_Crucial_when_upsizing_fuel_injectors_(+40%,_+52_lb/hr)_to_avoid_flooding_the_engine_on_sudden_throttle_tip-in.
    ;mpinjscale scale
    .byte 0x03                       ;Number of points in table
    .byte 0x74, 0x1B, 0xFF, 0x6E     ;Point 1
    .byte 0x90, 0x0B, 0xFF, 0xD9     ;Point 2
    .byte 0xB1, 0x06                 ;Point 3

	;.org	0xc344
THRTCN_EnrichmentTime_FromTemp:
    ;mpgrp Fuel_-_Transient_Enrichment\PumpShot_Calculation\TPS_PumpShot\
    ;mptbladdr 0x0956
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname EnrichmentTime_FromTemp
    ;mptblcname THRTCN
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis time_const 0 100 percent
    ;mptbldesc Throttle_Transient_Enrich_Time_Constant____OVERVIEW:_THRTCN_EnrichmentTime_FromTemp_defines_the_decay_time_constant_for_TPS-based_acceleration_enrichment._Following_a_throttle_opening_transient,_this_curve_dictates_how_long_the_TPS_fuel_shot_is_sustained_before_decaying_back_to_steady-state_fuel_delivery._It_ensures_smooth_transition_between_the_initial_throttle_stomp_and_steady-state_manifold_filling._|_TUNER'S_GUIDE:_Increasing_Table_Values:_Lengthens_the_duration_of_the_TPS_enrichment_pulse._Decreasing_Table_Values:_Shortens_duration,_making_throttle_response_snappier.
    .byte 0x02                       ;Number of points in table
    .byte 0x74, 0x18, 0x00, 0x17     ;Point 1
    .byte 0xCD, 0x20                 ;Point 2

	;.org	0xc34f
MINDLM_MinDeltaMAPForPTE:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x0965
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinDeltaMAPForPTE
    ;mptblcname MINDLM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_MINDLM_MinDeltaMAPForPTE_specifies_the_minimum_manifold_pressure_rate_of_change_(_DeltaMAP_)_required_to_set_the_Part_Throttle_Enrichment_(PTE)_operating_flag._PTE_is_a_continuous_transient_enrichment_multiplier_applied_to_injector_pulse_width_during_prolonged_acceleration._To_prevent_PTE_from_engaging_on_minor_throttle_flutter_or_road_vibration,_MINDLM_enforces_a_positive_pressure_delta_threshold_before_the_PTE_logic_can_qualify_for_activation._|_TUNER'S_GUIDE:_Stock_Setting:_0x05_(_~_0.58_psi_)._Tuning_Guidance:_Stock_values_provide_excellent_noise_immunity.
    .byte 0x05                       ;Point 1

	;.org	0xc350
MINCTS_MinCoolantTempForPTE:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x0972
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinCoolantTempForPTE
    ;mptblcname MINCTS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_MINCTS_MinCoolantTempForPTE_sets_the_minimum_coolant_temperature_required_to_allow_Part_Throttle_Enrichment_(PTE)_flag_activation._On_cold_engines_(below_138_degF),_cold_warmup_enrichment_curves_(CURVEA/CURVEB)_already_deliver_substantial_supplemental_fuel._Stacking_PTE_on_top_of_full_cold_enrichment_would_cause_plug-fouling_richness._MINCTS_blocks_PTE_until_the_engine_has_warmed_up_past_the_heavy_cold-enrichment_phase._|_TUNER'S_GUIDE:_Stock_Setting:_0xB1_(_~_138_degF_)._Tuning_Guidance:_If_using_a_160_degF_thermostat,_ensure_MINCTS_is_not_set_above_operating_temperatures.
    .byte 0xB1                       ;Point 1

	;.org	0xc351
MINERT_MinTimeForPTE:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x097F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinTimeForPTE
    ;mptblcname MINERT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_MINERT_MinTimeForPTE_establishes_the_minimum_dwell_time_filter_that_an_acceleration_transient_must_persist_before_the_PTE_flag_is_asserted._Brief,_momentary_pressure_spikes_lasting_only_one_ADC_sample_cycle_(such_as_road_bumps_shaking_the_intake)_are_filtered_out_by_requiring_the_transient_condition_to_sustain_for_at_least_MINERT_consecutive_sampling_intervals._|_TUNER'S_GUIDE:_Stock_Value:_0x02_(2_sample_passes)._Tuning_Guidance:_Leave_at_default_0x02.
    .byte 0x02                       ;Point 1

	;.org	0xc352
MINRPM_MinRPMforPTE:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x098C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinRPMforPTE
    ;mptblcname MINRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_MINRPM_MinRPMforPTE_sets_the_minimum_engine_speed_required_to_activate_Part_Throttle_Enrichment._At_low_idle_speeds_(under_1120_RPM),_tip-in_fuel_delivery_is_managed_entirely_by_the_discrete_MAP_and_TPS_pump_shots_(AESLOP_/_POSSLP)._Engaging_the_sustained_PTE_multiplier_at_idle_speeds_would_cause_engine_loading_down_and_rough_idling._MINRPM_locks_PTE_out_below_1120_RPM._|_TUNER'S_GUIDE:_Stock_Value:_0x23_(_1120_RPM_)._Tuning_Guidance:_If_your_car_has_a_high-stall_torque_converter_or_aggressive_camshaft_that_idles_around_1100_RPM,_raise_MINRPM_slightly_(e.g.,_to_1250_RPM)_so_off-idle_blips_don't_trip_PTE_prematurely.
    .byte 0x23                       ;Point 1

	;.org	0xc353
MNDCRP_MinRPMforDecelLeanout:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x0999
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinRPMforDecelLeanout
    ;mptblcname MNDCRP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_MNDCRP_MinRPMforDecelLeanout_defines_the_absolute_minimum_engine_speed_threshold_below_which_Deceleration_Fuel_Leanout_is_aborted._When_the_driver_lifts_off_the_throttle_to_decelerate,_the_ECU_leans_out_the_fuel_mixture_to_conserve_fuel_and_prevent_catalytic_converter_overheating._However,_as_engine_speed_falls_near_idle,_deceleration_leanout_must_disengage_immediately_to_prevent_engine_stalling._MNDCRP_serves_as_this_anti-stall_floor._|_TUNER'S_GUIDE:_Stock_Setting:_0x14_(_640_RPM_)._Preventing_Decel_Stalls:_On_lightweight_flywheels_or_aggressive_camshafts,_cars_often_stall_when_clutching_in_during_decel._Raising_MNDCRP_to_0x20-0x24_(1024-1152_RPM)_terminates_decel_leanout_earlier,_allowing_fuel_delivery_to_resume_well_before_idle_speed_and_preventing_stalling.
    .byte 0x14                       ;Point 1

	;.org	0xc354
MNDCTM_MinTimeforDecelLeanout:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x09A6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinTimeforDecelLeanout
    ;mptblcname MNDCTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_MNDCTM_MinTimeforDecelLeanout_specifies_the_minimum_hold_duration_required_before_deceleration_fuel_leanout_can_commence._This_delay_prevents_momentary_throttle_lifts_during_quick_manual_gear_shifts_from_triggering_decel_leanout,_avoiding_jerky_driveline_bucking_between_gear_changes._|_TUNER'S_GUIDE:_Stock_Setting:_0x02_(2_counts)._Tuning_Guidance:_Keeps_gear_changes_smooth_and_seamless.
    .byte 0x02                       ;Point 1

	;.org	0xc355
DMDCIC_DeltaMAPLeanoutIncrement:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x09B3
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMAPLeanoutIncrement
    ;mptblcname DMDCIC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc OVERVIEW:_DMDCIC_DeltaMAPLeanoutIncrement_establishes_the_step_rate_at_which_the_deceleration_leanout_multiplier_increments_towards_its_maximum_leanout_authority._Rather_than_cutting_fuel_instantaneously_(which_causes_driveline_shock),_the_ECU_ramps_fuel_down_progressively_by_adding_DMDCIC_counts_each_cycle_until_reaching_DMLMT._|_TUNER'S_GUIDE:_Stock_Value:_0x02._Increasing_DMDCIC:_Ramps_leanout_in_faster._Decreasing_DMDCIC:_Softer,_smoother_decel_transition.
    ;mpmapaxis y
    .byte 0x02                       ;Point 1

	;.org	0xc356
DMDCDC_DeltaMAPLeanoutDecrement:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x09C1
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMAPLeanoutDecrement
    ;mptblcname DMDCDC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc OVERVIEW:_DMDCDC_DeltaMAPLeanoutDecrement_specifies_the_step_rate_at_which_deceleration_leanout_decays_back_to_normal_running_fueling_when_throttle_is_re-applied._When_exiting_deceleration,_normal_fueling_must_be_restored_faster_than_it_entered_to_eliminate_throttle_re-application_lag._DMDCDC_(3_counts)_is_configured_higher_than_DMDCIC_(2_counts)_to_ensure_rapid_fueling_recovery._|_TUNER'S_GUIDE:_Stock_Setting:_0x03._Tuning_Guidance:_Faster_exit_than_entry_ensures_responsive_tip-in_coming_off_decel.
    ;mpmapaxis y
    .byte 0x03                       ;Point 1

	;.org	0xc357
DMLMT_DeltaMAPLeanoutLimit:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x09CF
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname DeltaMAPLeanoutLimit
    ;mptblcname DMLMT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc OVERVIEW:_DMLMT_DeltaMAPLeanoutLimit_establishes_the_maximum_authority_clamp_for_deceleration_fuel_leanout._Caps_the_maximum_fuel_reduction_that_the_deceleration_algorithm_is_permitted_to_enforce,_ensuring_the_mixture_does_not_become_so_lean_as_to_cause_backfiring_or_exhaust_popping._|_TUNER'S_GUIDE:_Stock_Setting:_0x08._Tuning_Guidance:_Increasing_DMLMT_produces_more_aggressive_decel_fuel_cutting,_lowering_DMLMT_reduces_decel_exhaust_gurgle/pops.
    ;mpmapaxis y
    .byte 0x08                       ;Point 1

	;.org	0xc358
TMDCNT_TimerLeanoutInitial:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x09DD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimerLeanoutInitial
    ;mptblcname TMDCNT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_TMDCNT_TimerLeanoutInitial_sets_the_initial_reload_value_for_the_deceleration_leanout_duration_timer._Governs_how_long_decel_leanout_is_sustained_before_beginning_automatic_timeout_recovery._|_TUNER'S_GUIDE:_Stock_Value:_0xED_(237_counts)._Tuning_Guidance:_Controls_sustained_decel_leanout_holding_time.
    .byte 0xED                       ;Point 1

	;.org	0xc359
LMAPTC_TimeConstant:
; this is actually one of the 2 MAP averaging factor constants
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x09EB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeConstant
    ;mptblcname LMAPTC
    ;mpxaxis X 0 255 in
    ;mpyaxis time_const 0 100 percent
    ;mptbldesc lean_out_time_constant_based_on_MAP____OVERVIEW:_LMAPTC_TimeConstant_specifies_the_digital_filtering_time_constant_applied_to_MAP_transient_decay_calculations._Works_as_the_time-constant_coefficient_in_the_rolling_average_digital_filter_that_tracks_manifold_pressure_transients_during_decel_and_recovery._|_TUNER'S_GUIDE:_Stock_Setting:_0x28_(40_counts)._Tuning_Guidance:_Modulates_rolling_MAP_average_lag._Leave_stock.
    .byte 0x28                       ;Point 1

	;.org	0xc35a
TestedAgainstMAPPressureDuringTransientCalc:
    ;mpgrp Fuel_-_Transient_Enrichment\
    ;mptbladdr 0x09F8
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname TestedAgainstMAPPressureDuringTransientCalc
    ;mptblcname TESTEDAGAINSTMAPPRESSUREDURINGTRANSIENTCALC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis psi 0 29.4 psi
    ;mptbldesc OVERVIEW:_TestedAgainstMAPPressureDuringTransientCalc_defines_the_manifold_pressure_transient_verification_threshold_used_during_full-throttle_(WOT)_transition_checks._When_the_driver_hits_full_throttle,_this_constant_ensures_that_manifold_absolute_pressure_is_genuinely_rising_in_unison_with_throttle_position_before_locking_in_WOT_power_enrichment_mode._|_TUNER'S_GUIDE:_Stock_Value:_0x0A_(_~_1.15_psi_)._Tuning_Guidance:_Protects_against_false_WOT_triggers_on_noisy_throttle_signals.
    ;mpmapaxis y
    .byte 0x0A                       ;Point 1

	;.org	0xc35b
AISTRT_AisStartupPosition_FromTemp:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x0A06
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisStartupPosition_FromTemp
    ;mptblcname AISTRT
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis AIS_Open 0 255 steps
    ;mptbldesc AIS_motor_startup_position_from_engine_temp____OVERVIEW:_AISTRT_(AisStartupPosition_FromTemp)_is_a_2D_lookup_table_that_establishes_the_open-loop_baseline_step_position_for_the_Automatic_Idle_Speed_(AIS)_stepper_motor_actuator_during_engine_cranking_and_initial_startup._When_the_ignition_key_is_turned_to_'Start'_(cranking)_or_immediately_after_fire-up_before_running_closed-loop_idle_speed_regulation_engages,_the_ECU_positions_the_idle_air_bypass_pintle_to_this_calibrated_step_count._Cold_engines_exhibit_high_internal_boundary_friction,_viscous_oil_drag,_and_poor_initial_fuel_vaporization,_requiring_significantly_more_bypass_air_to_guarantee_a_prompt_catch_without_prolonged_cranking._Conversely,_a_fully_warmed_engine_requires_far_less_bypass_airflow_to_prevent_an_aggressive_startup_RPM_over-flare._Once_the_engine_catches_and_exceeds_cranking_speed_threshold,_the_ECU_transitions_from_this_initial_starting_step_count_toward_running_idle_closed-loop_control._|_TUNER'S_GUIDE:_Increasing_Table_Values:_Forces_the_AIS_motor_to_open_wider_during_startup._Use_this_if_the_engine_stumbles,_catches_sluggishly,_or_fails_to_catch_cleanly_when_cold,_especially_with_large_camshafts,_heavy_valve_springs,_or_E85_fuels_requiring_additional_cranking_airflow._Decreasing_Table_Values:_Decreases_initial_bypass_opening._Helpful_if_the_engine_aggressively_flares_to_high_RPM_(e.g._>_2,000_RPM)_immediately_upon_starting_when_hot_or_warm._Modified_Throttle_Bodies_/_Big_Cams:_Aftermarket_throttle_bodies_(such_as_52mm_or_58mm_units)_or_throttle_plates_with_enlarged_bypass_holes_flow_substantially_more_air_per_step._If_an_aftermarket_throttle_body_causes_excessive_startup_flare,_scale_this_entire_curve_downward_by_15%_to_30%.
    .byte 0x05                       ;Number of points in table
    .byte 0x6E, 0x9B, 0xFC, 0x0D     ;Point 1
    .byte 0x81, 0x50, 0xFF, 0x14     ;Point 2
    .byte 0xCF, 0x08, 0x00, 0x00     ;Point 3
    .byte 0xE4, 0x08, 0x00, 0x20     ;Point 4
    .byte 0xF4, 0x0A                 ;Point 5

	;.org	0xc36e
DRIDHT_AdditionalStartupIdle:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x0A18
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisAdditionalStartupIdle
    ;mptblcname DRIDHT
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Additional_startup_idle_speed._x0D_=_104rpm____OVERVIEW:_DRIDHT_(AdditionalStartupIdle)_defines_a_calibrated_idle_speed_adder_that_is_appended_to_the_base_coolant-dependent_target_idle_speed_right_after_the_engine_starts._During_the_first_few_seconds_following_combustion_initiation,_engine_friction_and_alternator_drag_from_initial_battery_recharging_are_abnormally_elevated._Adding_a_moderate_RPM_buffer_prevents_the_engine_from_stalling_or_dipping_below_target_as_the_driver_releases_the_ignition_key_from_the_START_position_to_RUN._The_duration_of_this_adder_is_governed_by_STTIME_AdditionalStartupIdleTime._|_TUNER'S_GUIDE:_Increasing_DRIDHT:_Produces_a_more_pronounced_initial_post-start_idle_flare,_keeping_engine_speed_elevated_for_positive_oil_pressure_buildup_and_stall_avoidance_on_cold_mornings_or_with_lightweight_flywheels._Decreasing_DRIDHT:_Lowers_post-cranking_flare_RPM,_yielding_a_quieter,_softer_start._Setting_too_low_can_cause_the_engine_to_stumble_or_catch-and-die_immediately_after_cranking._High-Stall_/_Big_Cam_Applications:_High-duration_camshafts_with_low_manifold_vacuum_at_idle_benefit_from_setting_DRIDHT_slightly_higher_(e.g.,_0x12_to_0x18_=_+144_to_+192_RPM)_to_guarantee_stable_combustion_before_closed-loop_adaptive_idle_stabilizes.
    .byte 0x0D                       ;Point 1

	;.org	0xc36f
STTIME_AdditionalStartupIdleTime:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x0A25
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisAdditionalStartupIdleTime
    ;mptblcname STTIME
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Time_that_DRIDHT_is_used_-_x17_=_.65_seconds____OVERVIEW:_STTIME_(AdditionalStartupIdleTime)_sets_the_time_duration_during_which_the_startup_idle_flare_adder_(DRIDHT)_is_added_to_the_base_target_idle_speed._Once_the_engine_transitions_from_cranking_to_running,_the_runtime_timer_KeyOnOrEngineRunningTime_begins_incrementing._While_this_counter_is_strictly_less_than_STTIME,_the_ECU_holds_the_target_idle_speed_higher_by_DRIDHT._As_soon_as_the_timer_reaches_STTIME,_the_target_idle_speed_immediately_drops_back_to_the_steady-state_coolant_temperature_curve_(AISPN_or_AISCLD)._|_TUNER'S_GUIDE:_Increasing_STTIME:_Extends_the_post-start_elevated_idle_period._Useful_for_cold-start_stability_in_freezing_climates_or_with_large_injectors_where_fuel_puddling_requires_extra_time_to_establish_a_steady_wall_film._Decreasing_STTIME:_Shortens_the_flare_period,_allowing_the_engine_to_return_to_normal_base_idle_faster._Stock_Value:_0x0B_(~1.1_seconds)._Tuning_above_0x20_(~3.5_seconds)_will_cause_an_unnaturally_prolonged_high_idle_flare_upon_every_startup.
    .byte 0x0B                       ;Point 1

	;.org	0xc370
AISPN_IdleSpeedParkNeutral_FromTemp:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x0A32
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname IdleSpeedParkNeutral_FromTemp
    ;mptblcname AISPN
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis RPM 0 2048 rpm
    ;mptbldesc Idle_Speed_From_Temp_in_park/neutral_or_manual_trans____OVERVIEW:_AISPN_(IdleSpeedParkNeutral_FromTemp)_is_the_foundational_2D_calibration_curve_defining_the_target_engine_idle_speed_across_operating_coolant_temperatures_whenever_the_drivetrain_is_unloaded_(Park/Neutral_switch_closed,_or_clutch_switch_/_neutral_switch_grounded_on_manual_vehicles)._On_manual_transmission_vehicles_(such_as_this_T_LM_22_MTX_A171_calibration),_the_transmission_park/neutral_sense_input_on_Port_C_(Z83_PortCdata,_bit_3)_is_hard-tied_to_the_unloaded_state,_meaning_AISPN_is_the_primary_running_idle_target_table_used_during_all_normal_idle_conditions._Cold_engine_temperatures_command_elevated_idle_speeds_(~1,100_to_1,200_RPM)_to_accelerate_catalytic_converter_light-off_and_prevent_stall,_smoothly_declining_to_~850-900_RPM_at_full_operating_temperature_(180_degF_-_200_degF)._|_TUNER'S_GUIDE:_Setting_Target_Idle_RPM:_To_raise_your_hot_idle_speed_(e.g._for_a_lumpy_aftermarket_camshaft_or_higher_alternator_output),_adjust_the_hot_end_of_this_table_(right-side_coordinate)._Big_Cam_Tuning:_Large_overlap_camshafts_(e.g._F2,_F3,_or_custom_grinds)_produce_weak_manifold_vacuum_and_misfire_tendencies_at_stock_800-850_RPM_idle._Raising_the_warm_idle_target_in_AISPN_to_950_-_1,050_RPM_significantly_improves_idle_vacuum,_oil_pressure,_and_cabin_vibration._Lightweight_Flywheels:_Light_aluminum_flywheels_lose_rotational_inertia_quickly._Raising_cold_and_warm_points_in_AISPN_by_100-150_RPM_prevents_sudden_stalling_when_dipping_the_clutch_during_parking_maneuvers.
    .byte 0x02                       ;Number of points in table
    .byte 0x7F, 0xAF, 0xFF, 0x2F     ;Point 1
    .byte 0xCC, 0x70                 ;Point 2

	;.org	0xc37b
AISCLD_IdleSpeedDrive_FromTemp:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x0A41
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname IdleSpeedDrive_FromTemp
    ;mptblcname AISCLD
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis RPM 0 2048 rpm
    ;mptbldesc Idle_Speed_From_temp_in_Drive,_auto_trans_only____OVERVIEW:_AISCLD_(IdleSpeedDrive_FromTemp)_defines_the_target_idle_speed_curve_across_engine_coolant_temperatures_when_an_automatic_transmission_is_engaged_in_gear_(Drive,_Reverse,_1st,_or_2nd)._When_an_automatic_vehicle_is_shifted_from_Neutral_into_Drive,_the_torque_converter_impeller_imposes_substantial_hydrodynamic_drag_on_the_engine_crankshaft._AISCLD_typically_calibrates_target_idle_speed_approximately_50_to_100_RPM_lower_than_AISPN_to_prevent_excessive_vehicle_creep_at_stoplights_while_still_providing_adequate_airflow_to_resist_stalling._|_TUNER'S_GUIDE:_Automatic_Trans_Conversions_/_Retuned_ATX:_If_running_an_automatic_calibration,_match_or_stagger_AISCLD_against_AISPN._If_shifting_into_Drive_causes_harsh_engagement_or_vehicle_lunging,_lower_AISCLD._If_shifting_into_Drive_stalls_the_engine_due_to_torque_converter_load,_raise_AISCLD_by_50-80_RPM._Manual_Calibrations:_On_dedicated_MTX_cals,_this_table_exists_in_ROM_as_legacy_code/data_but_is_not_reached_unless_the_Port_C_sense_pin_state_is_altered.
    .byte 0x02                       ;Number of points in table
    .byte 0x7F, 0x96, 0xFF, 0x5A     ;Point 1
    .byte 0xCC, 0x64                 ;Point 2

	;.org	0xc386
CLDPOS_AisColdPosition_FromTemp:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x0A50
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisColdPosition_FromTemp
    ;mptblcname CLDPOS
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis AIS_Open 0 2048 steps
    ;mptbldesc Cold_OffIdle_AIS_Positioning,_Increases_instantly,_decreases_after_DLYOFI____OVERVIEW:_CLDPOS_(AisColdPosition_FromTemp)_establishes_an_extra_off-idle_bypass_airflow_opening_based_on_engine_coolant_temperature._When_a_cold_engine_is_driven_off-idle_and_the_throttle_is_opened,_the_engine_requires_additional_bypass_air_pre-positioning_so_that_when_the_throttle_suddenly_snaps_shut,_cold_intake_manifold_walls_(which_condense_liquid_fuel)_do_not_cause_an_immediate_lean_stall._As_engine_coolant_reaches_normal_operating_temperature,_CLDPOS_decays_down_towards_zero_steps,_handing_full_dynamic_dashpot_authority_over_to_throttle_and_RPM-based_tables._|_TUNER'S_GUIDE:_Cold_Stall_on_Decel_/_Clutch_In:_If_a_modified_engine_stalls_when_coming_to_a_stop_during_the_first_3-5_minutes_of_driving_before_full_warmup,_increase_the_values_in_CLDPOS_in_the_70_degF_-_140_degF_region._Cold_High_Idle_/_Hanging_RPM:_If_cold_off-idle_cruising_causes_engine_RPM_to_'hang'_or_refuse_to_drop_below_1,500_RPM_when_you_lift_off_the_accelerator,_reduce_the_step_values_in_CLDPOS.
    .byte 0x03                       ;Number of points in table
    .byte 0x6E, 0x78, 0xFC, 0x78     ;Point 1
    .byte 0x7F, 0x3C, 0xFF, 0x32     ;Point 2
    .byte 0xC7, 0x02                 ;Point 3

	;.org	0xc395
BARAIS_AISBaroCompensation:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x0A60
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BaroCompensation_FromBaro
    ;mptblcname BARAIS
    ;mpxaxis Baro -14.7 14.7 psi
    ;mpyaxis Factor 0 1 scale
    ;mptbldesc Barometric_compensation_factor_for_AIS_control____OVERVIEW:_BARAIS_(AISBaroCompensation)_scales_the_cold_off-idle_AIS_step_position_(CLDPOS)_as_a_function_of_atmospheric_barometric_pressure_(BaroPressure)._At_high_altitudes_(such_as_Denver,_Colorado_or_mountain_passes),_ambient_air_density_drops_significantly._A_given_physical_bypass_orifice_area_passes_substantially_less_air_mass_at_8,000_feet_than_at_sea_level._BARAIS_provides_a_multiplicative_correction_factor_to_increase_the_stepper_motor_opening_at_low_barometric_pressures,_ensuring_consistent_cold-engine_throttle-lift_recovery_regardless_of_altitude._|_TUNER'S_GUIDE:_Stock_Behavior:_Most_tuners_will_never_need_to_modify_BARAIS_unless_validating_high-altitude_vehicle_behavior._High_Altitude_Tuning:_If_vehicles_driven_at_high_elevation_suffer_from_cold-engine_dipping_on_decel,_elevate_the_low-baro_end_of_the_BARAIS_curve_to_command_more_open_steps.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x5E, 0x80, 0xFA, 0x2F     ;Point 1
    .byte 0x69, 0x40                 ;Point 2

	;.org	0xc3a0
THRPOS_AisPosition_FromThrottle:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x0A70
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisPosition_FromThrottle
    ;mptblcname THRPOS
    ;mpxaxis TPS 0 5 Volts
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc AIS_Position_from_throttle____OVERVIEW:_THRPOS_(AisPosition_FromThrottle)_acts_as_an_electronic_dashpot._It_maps_throttle_position_above_closed-throttle_idle_(TpsVolts_-_MINTHR_LowestSessionTPS)_directly_to_a_target_AIS_stepper_motor_step_opening._When_the_driver_depresses_the_accelerator_pedal,_the_ECU_pre-emptively_retracts_the_AIS_pintle_to_an_open_position_corresponding_to_throttle_angle._If_the_driver_suddenly_snaps_the_throttle_shut_at_high_RPM,_the_AIS_valve_is_already_open,_providing_a_cushioned_air_bypass_buffer_that_prevents_catastrophic_manifold_vacuum_spikes,_oil_pull_past_piston_rings,_and_decel_engine_stalling._As_engine_speed_and_throttle_return_to_idle,_the_ECU_ramps_the_motor_back_down._|_TUNER'S_GUIDE:_Throttle_Snap_Stalling:_If_dropping_the_throttle_quickly_causes_the_engine_to_dip_below_idle_speed_and_die,_increase_THRPOS_values,_particularly_in_the_lower_throttle_angle_range_(0%_to_15%_throttle)._Hanging_Throttle_/_Slow_Decel:_If_the_vehicle_feels_like_cruise_control_is_stuck_on_when_lifting_off_the_gas,_or_if_the_RPM_takes_several_seconds_to_return_to_idle,_THRPOS_is_set_too_high_or_the_physical_throttle_body_has_excess_mechanical_leakage.
    .byte 0x02                       ;Number of points in table
    .byte 0x02, 0x00, 0x00, 0x9E     ;Point 1
    .byte 0x0F, 0x08                 ;Point 2

	;.org	0xc3af
RPMPOS_AisPosition_FromRpm:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x0A7F
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname AisPosition_FromRpm
    ;mptblcname RPMPOS
    ;mpxaxis RPM 0 16384 rpm
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc AIS_Position_from_RPMs____OVERVIEW:_RPMPOS_(AisPosition_FromRpm)_establishes_a_minimum_AIS_stepper_motor_opening_based_purely_on_engine_RPM_(EngineRpm_HB)._Even_if_the_throttle_is_only_cracked_slightly,_high_engine_RPM_creates_immense_cylinder_intake_demand._If_the_throttle_closes_at_4,500_RPM_in_neutral_or_with_the_clutch_depressed,_manifold_absolute_pressure_collapses_instantly_to_near_zero_(extreme_vacuum)._RPMPOS_ensures_that_at_higher_engine_speeds,_the_idle_air_bypass_is_pre-emptively_opened_to_a_designated_step_count,_preventing_vacuum_collapse_and_providing_a_progressive_RPM_coastdown_curve._|_TUNER'S_GUIDE:_Decel_Dip_/_Return-to-Idle_Catching:_If_pressing_the_clutch_at_4,000_RPM_causes_the_tachometer_needle_to_plummet_like_a_rock_and_dip_below_target_idle_(or_stall),_increase_the_upper_RPM_steps_in_RPMPOS._Engine_Braking:_Excessive_values_in_RPMPOS_diminish_engine_braking_effect_during_off-throttle_deceleration._Keep_values_moderate_to_maintain_engine_braking_while_preserving_anti-stall_protection.
    .byte 0x03                       ;Number of points in table
    .byte 0x1F, 0x00, 0x00, 0x30     ;Point 1
    .byte 0x2F, 0x03, 0x00, 0x21     ;Point 2
    .byte 0x46, 0x06                 ;Point 3

	;.org	0xc3be
PNPOS_ParkNeutralPosition:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x0A8F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ParkNeutralPosition
    ;mptblcname PNPOS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_PNPOS_(ParkNeutralPosition)_is_a_single-byte_calibration_constant_that_adds_a_fixed_step_offset_to_the_desired_AIS_motor_position_whenever_the_transmission_is_in_Park_or_Neutral._When_shifting_out_of_gear_into_Park_or_Neutral,_the_torque_converter_load_vanishes,_and_engine_RPM_tends_to_rise._In_stock_calibrations,_PNPOS_is_set_to_0x00_(zero_added_steps)_because_the_ECU_handles_the_load_transition_via_separate_kick_tables_(DRPNK_and_PNDRK)_and_target_curves_(AISPN)._However,_the_calibration_location_exists_to_provide_an_immediate_static_step_adjustment_if_required_by_specific_driveline_configurations._|_TUNER'S_GUIDE:_Stock_Value:_0x00._Tuning_Usage:_Generally_left_at_zero._If_custom_automatic_transmissions_exhibit_an_immediate_RPM_drop_upon_shifting_into_neutral_before_the_closed-loop_integrator_responds,_a_small_positive_value_(2_-_5_steps)_can_be_entered_here.
    .byte 0x00                       ;Point 1

	;.org	0xc3bf
ACPOS_ACPositionWhenTempToCold:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x0A9C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ACPositionWhenTempToCold
    ;mptblcname ACPOS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AIS:_AC_clutch_position_when_temp_to_cold____OVERVIEW:_ACPOS_(ACPositionWhenTempToCold)_provides_a_fixed_step_addition_for_the_idle_air_bypass_whenever_the_Air_Conditioning_compressor_clutch_is_engaged_and_engine_coolant_temperature_is_below_the_warm_threshold_defined_by_ACTMP_AisTempSwap._When_the_engine_is_cold_or_warming_up,_refrigerant_head_pressures_and_compressor_pumping_displacement_place_a_massive_parasitic_torque_load_on_the_cold_engine._Because_the_vehicle_speed-dependent_table_ACCTBL_is_tuned_for_warm_operating_temperatures,_ACPOS_overrides_that_table_during_cold_running_with_a_generous_static_step_addition_(stock_calibration_=_23_steps_/_0x17)_to_keep_the_cold_engine_from_lugging_or_stalling_when_the_A/C_clutch_engages._|_TUNER'S_GUIDE:_A/C_Cold_Stall:_If_turning_on_the_air_conditioning_or_windshield_defroster_while_the_engine_is_cold_causes_a_severe_RPM_dip_or_engine_stall,_increase_ACPOS_(e.g.,_from_23_steps_to_30-35_steps)._A/C_Cold_High_Idle:_If_engaging_the_A/C_while_cold_causes_engine_speed_to_surge_excessively_high_(e.g._>_1,400_RPM),_reduce_ACPOS.
    .byte 0x17                       ;Point 1

	;.org	0xc3c0
ACTMP_AisTempSwap:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x0AA9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisTempSwap
    ;mptblcname ACTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_ACTMP_(AisTempSwap)_defines_the_coolant_temperature_crossover_point_separating_cold_A/C_compensation_from_warm_A/C_compensation._Below_ACTMP,_the_ECU_considers_the_engine_cold_and_applies_the_static_step_offset_defined_by_ACPOS_ACPositionWhenTempToCold._At_or_above_ACTMP,_the_ECU_switches_to_the_dynamic,_vehicle-speed-indexed_table_ACCTBL_ACOffIdleDelta_FromSpeed._This_allows_a_seamless_transition_from_high-effort_cold_anti-stall_compensation_to_refined_warm_cruising_idle_regulation._|_TUNER'S_GUIDE:_Stock_Value:_0xA6_(166_decimal,_corresponding_to_approximately_166_degF_/_74_degC)._Thermostat_Changes:_If_running_a_160_degF_low-temperature_racing_thermostat,_the_engine_may_operate_continuously_right_around_or_slightly_below_166_degF,_causing_the_ECU_to_remain_permanently_locked_into_the_cold_ACPOS_adder_mode._Tuners_running_160_degF_thermostats_should_lower_ACTMP_to_0x90_(~145_degF)_so_the_ECU_transitions_into_normal_warm_A/C_compensation.
    .byte 0xA6                       ;Point 1

	;.org	0xc3c1
CALPOS_PositionAisMotorIsAtIdle:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x0AB6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname PositionAisMotorIsAtIdle
    ;mptblcname CALPOS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AIS:_Position_electronics_thinks_motor_is_(at_idle)____OVERVIEW:_CALPOS_(PositionAisMotorIsAtIdle)_represents_the_electrical_baseline_step_count_of_the_AIS_stepper_motor_during_steady-state,_fully_warmed-up_curb_idle._In_the_Chrysler_idle_control_architecture,_closed-loop_idle_trims_and_deceleration_dashpot_adders_are_computed_as_delta_offsets_relative_to_a_baseline_reference._CALPOS_provides_this_nominal_base_(calibrated_at_26_steps_/_0x1A)._It_is_added_to_desired_position_calculations_and_is_also_utilized_in_CalculateAisPosition_MM_to_enforce_minimum_limits_and_initialize_the_idle_motor_tracking_register._|_TUNER'S_GUIDE:_Base_Throttle_Minimum_Airflow_Setup:_The_factory_service_manual_instructs_setting_the_mechanical_throttle_plate_minimum_stop_screw_(with_AIS_motor_disconnected_or_fully_closed)_so_that_warm_idle_runs_~700_RPM._When_reconnecting_the_AIS,_the_ECU_operates_around_CALPOS_(~20_to_30_steps)_to_achieve_850_RPM_target_idle._Aftermarket_Throttle_Bodies:_If_you_install_a_larger_throttle_body_or_bore_out_the_throttle_body,_the_engine_may_idle_at_1,100_RPM_even_with_the_AIS_fully_seated._After_adjusting_the_mechanical_throttle_stop_screw_to_bring_baseline_air_down,_verify_that_warm_idle_step_counts_in_scan_tools_(or_DRB)_float_close_to_CALPOS_(20-30_steps)._Modifying_CALPOS:_Adjusting_CALPOS_shifts_the_entire_baseline_operating_window_of_the_idle_stepper_motor.
    .byte 0x1A                       ;Point 1

	;.org	0xc3c2
CALRAT_AisAdjustRate:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x0AC3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisAdjustRate
    ;mptblcname CALRAT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc AIS_update_rate_when_calibrating_-_rate=(CALRAT+1)*11ms_(can_be_0,1,3,7,f,1f,3f,7f,ff)____OVERVIEW:_CALRAT_(AisAdjustRate)_is_a_timing_bitmask_applied_against_the_ECU's_master_loop_counter_(Counter_MainLoop1)_that_governs_how_rapidly_the_AIS_stepper_motor_is_permitted_to_step_downward_(close)_when_returning_to_target_idle._Stepper_motors_have_mechanical_inertia_and_physical_response_times._If_the_ECU_decremented_the_stepper_motor_pintle_every_single_11-millisecond_program_loop_when_engine_speed_is_above_target,_the_valve_would_close_too_rapidly,_causing_the_engine_to_undershoot_target_idle_and_stumble._CALRAT_forces_the_downward_step_decrement_logic_to_only_execute_periodically_(governed_by_the_bitmask_test),_creating_a_smooth,_stable,_damped_return_to_curb_idle_without_RPM_hunting_or_oscillating._|_TUNER'S_GUIDE:_Permissible_Values:_Must_be_power-of-two_minus_one_bitmasks_or_specific_bit_combinations_(0x01,_0x03,_0x07,_0x0E,_0x0F,_0x1F,_0x3F)._Stock_calibration_uses_0x0E._Faster_Idle_Return:_Lowering_the_mask_density_allows_more_frequent_decrements,_making_the_idle_drop_faster_after_revving_the_engine._However,_setting_this_too_fast_will_induce_RPM_undershoot_and_stalling._Solving_RPM_Dip_/_Stall_on_Decel:_If_the_engine_surges_downward_and_almost_stalls_when_returning_to_idle,_slowing_the_decrement_rate_(higher_bitmask_or_higher_bit_count)_prevents_the_AIS_from_closing_faster_than_the_engine_airflow_can_stabilize.
    .byte 0x0E                       ;Point 1

	;.org	0xc3c3
BRKRPM_BrakeOverrideForAis_FromDeltaThrottle:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x0AD0
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname BrakeOverrideForAis_FromDeltaThrottle
    ;mptblcname BRKRPM
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc OVERVIEW:_BRKRPM_(BrakeOverrideForAis_FromDeltaThrottle)_is_a_2D_calibration_lookup_table_that_defines_an_engine_RPM_threshold_indexed_by_throttle_opening_above_closed-throttle_baseline_(TpsVolts_-_MINTHR_LowestSessionTPS)._When_the_driver_is_operating_the_throttle_or_applying_the_brakes_off-idle,_closed-loop_idle_speed_regulation_must_be_temporarily_suspended_so_the_ECU_does_not_attempt_to_fight_the_driver's_throttle_inputs_or_fight_brake_booster_vacuum_surges._If_engine_RPM_is_below_the_looked-up_threshold_in_BRKRPM,_closed-loop_idle_control_is_bypassed_and_the_stepper_motor_enters_dashpot_/_tracking_mode._Once_engine_RPM_and_throttle_drop_into_valid_idle_conditions,_closed-loop_regulation_is_restored._|_TUNER'S_GUIDE:_Hanging_Idle_Off-Throttle:_If_the_engine_hangs_at_elevated_RPM_after_light_throttle_blips_or_when_braking_into_a_corner,_lowering_BRKRPM_allows_the_ECU_to_resume_closed-loop_idle_control_sooner._Surging_While_Creeping_in_Traffic:_If_the_car_surges_or_'bucks'_at_very_low_speeds_with_light_throttle_application,_the_ECU_may_be_toggling_in_and_out_of_closed-loop_idle_control_prematurely._Raising_BRKRPM_widens_the_deadband_to_prevent_premature_closed-loop_entry.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x3F                 ;Point 1

	;.org	0xc3ce
FWDAIS_ForwardAisSteps_NoSlope:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x0ADE
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ForwardAisSteps_NoSlope
    ;mptblcname FWDAIS
    ;mpxaxis DeltaRPM 0 2048 rpm
    ;mpyaxis AISSteps 0 255 step
    ;mptbldesc OVERVIEW:_FWDAIS_(ForwardAisSteps_NoSlope)_is_a_stepped_lookup_table_(without_linear_interpolation)_that_dictates_how_many_forward_(opening)_steps_the_ECU_commands_the_AIS_stepper_motor_to_take_when_the_engine_is_running_slower_than_target_idle_speed._When_engine_load_increases_(such_as_power_steering_pump_lock,_alternator_charging_surge,_or_clutch_drag),_engine_speed_sags_below_TargetIdleSpeed_HB._The_ECU_calculates_the_underspeed_error_(Target_-_Actual)_/_4._Based_on_the_magnitude_of_the_error,_FWDAIS_assigns_an_immediate_step_increase_(1,_2,_4,_or_6_steps)._Small_RPM_errors_command_single-step_adjustments_to_avoid_overshooting,_while_severe_RPM_drops_command_aggressive_multi-step_corrections_to_prevent_an_imminent_stall._|_TUNER'S_GUIDE:_Stalling_Under_Sudden_Load:_If_turning_the_steering_wheel_to_full_lock_or_turning_on_headlights_causes_the_engine_to_dip_and_stall,_increase_the_step_values_in_FWDAIS_(especially_for_mid-to-high_RPM_error_brackets)._Idle_Oscillating_/_Hunting:_If_the_engine_surges_up_and_down_rhythmically_at_idle_('hunting'_between_750_and_1,100_RPM),_FWDAIS_is_over-correcting._Reduce_the_step_counts_at_low_error_brackets_(e.g._keep_small_errors_at_1_step)._Large_Aftermarket_Throttle_Bodies:_Larger_throttle_bodies_flow_much_more_bypass_air_per_step._Reduce_FWDAIS_values_by_30%_to_50%_to_maintain_smooth,_non-oscillating_idle_recovery.
    .byte 0x04                       ;Number of points in table
    .byte 0x14, 0x01, 0x00, 0x00     ;Point 1
    .byte 0x28, 0x02, 0x00, 0x00     ;Point 2
    .byte 0x3C, 0x04, 0x00, 0x00     ;Point 3
    .byte 0x50, 0x06                 ;Point 4

	;.org	0xc3e5
REVAIS_ReverseAisSteps_NoSlope:
    ;mpgrp Idle_-_AIS_Control\
    ;mptbladdr 0x0AEF
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ReverseAisSteps_NoSlope
    ;mptblcname REVAIS
    ;mpxaxis DeltaRPM 0 2048 rpm
    ;mpyaxis AISSteps 0 255 step
    ;mptbldesc OVERVIEW:_REVAIS_(ReverseAisSteps_NoSlope)_is_a_stepped_lookup_table_that_dictates_how_many_reverse_(closing)_steps_the_ECU_commands_the_AIS_stepper_motor_to_take_when_the_engine_is_idling_faster_than_target_idle_speed._When_external_engine_load_is_removed_(such_as_A/C_compressor_cycling_off,_radiator_fan_turning_off,_or_clutch_disengagement),_engine_RPM_floats_above_TargetIdleSpeed_HB._The_ECU_calculates_the_overspeed_error_(Actual_-_Target)_/_4._REVAIS_outputs_negative_step_adjustments_(-1,_-2,_-4_steps)_to_gently_pull_the_engine_back_down_to_target_speed_without_causing_an_underspeed_sag._|_TUNER'S_GUIDE:_Slow_Return_to_Idle:_If_the_engine_revs_and_takes_an_excessively_long_time_to_settle_back_down_to_idle_after_load_is_removed,_increase_the_reverse_steps_in_REVAIS._Decel_Dipping_/_Stumble:_If_the_engine_drops_rapidly_and_undershoots_idle_speed_when_load_turns_off,_REVAIS_is_closing_the_bypass_valve_too_aggressively._Soften_the_reverse_step_counts.
    .byte 0x03                       ;Number of points in table
    .byte 0x14, 0xFF, 0x00, 0x00     ;Point 1
    .byte 0x28, 0xFE, 0x00, 0x00     ;Point 2
    .byte 0x50, 0xFC                 ;Point 3

	;.org	0xc3fc
TIMEDC_AISDecelBaseAirflowCurveOffset:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0AFF
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelAisBaseAirflowCurveOffset_FromTime
    ;mptblcname TIMEDC
    ;mpxaxis in_desc 0 255 scale
    ;mpyaxis Time 0 720 sec
    ;mptbldesc OVERVIEW:_TIMEDC_(AISDecelBaseAirflowCurveOffset)_provides_a_timed_deceleration_airflow_decay_curve_for_the_idle_air_bypass_system._When_the_vehicle_is_cruising_at_speed_and_the_driver_suddenly_lifts_off_the_throttle,_the_engine_transitions_into_trailing-throttle_overrun._Snapping_the_throttle_shut_instantaneously_produces_extreme_intake_manifold_depression_(vacuum_spike),_which_pulls_oil_past_the_valve_stem_seals,_scavenges_unburned_fuel_from_port_walls,_and_can_induce_lean_misfire_or_stalling._TIMEDC_injects_an_initial_airflow_offset_that_smoothly_ramps_down_over_several_seconds,_allowing_manifold_vacuum_to_stabilize_smoothly_as_the_vehicle_coasts._|_TUNER'S_GUIDE:_Decel_Popping_/_Exhaust_Burble:_High_manifold_vacuum_during_trailing_throttle_often_causes_exhaust_popping_or_backfiring_with_open_3'_downpipes._Increasing_TIMEDC_provides_more_decel_bypass_airflow,_smoothing_manifold_vacuum_and_reducing_harsh_decel_exhaust_pops._Engine_Braking_Response:_If_you_want_more_aggressive_engine_braking_when_lifting_off_the_throttle_on_road_courses_or_autocross,_reduce_the_initial_values_in_TIMEDC_to_allow_the_throttle_to_close_down_quicker.
    .byte 0x02                       ;Number of points in table
    .byte 0x07, 0x08, 0xFF, 0x1C     ;Point 1
    .byte 0x10, 0x00                 ;Point 2

	;.org	0xc403
TEMPDC_AISDecel_FromTemp:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0B0E
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DecelAis_FromTemp
    ;mptblcname TEMPDC
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc OVERVIEW:_TEMPDC_(AISDecel_FromTemp)_defines_an_additive_deceleration_bypass_airflow_correction_indexed_by_engine_coolant_temperature_(CoolantTemp)._Cold_engines_suffer_from_sluggish_fuel_vaporization_and_heightened_rotating_friction._During_closed-throttle_deceleration_on_a_cold_engine,_lifting_off_the_accelerator_is_far_more_likely_to_cause_an_undershoot_stall_than_on_a_fully_warmed_engine._TEMPDC_supplements_the_timed_decel_curve_(TIMEDC)_with_additional_open_steps_when_cold,_tapering_down_to_a_minimum_level_as_the_engine_reaches_normal_operating_temperature._|_TUNER'S_GUIDE:_Cold-Engine_Decel_Stalling:_If_the_car_frequently_dies_when_you_push_the_clutch_in_while_decelerating_on_cold_mornings,_increase_TEMPDC_in_the_40_degF_-_120_degF_coolant_temperature_range._Cold_Fast-Decel_Hang:_If_the_engine_RPM_hangs_up_around_2,000_RPM_on_cold_lift-off_and_takes_too_long_to_drop,_reduce_TEMPDC.
    .byte 0x02                       ;Number of points in table
    .byte 0x58, 0x25, 0xFF, 0xB4     ;Point 1
    .byte 0xD2, 0x01                 ;Point 2

	;.org	0xc416
DAISOP_DecelAisOpenStepsFromNeg_FromDeltaMap:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0B1D
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname DecelAisOpenStepsFromNeg_FromDeltaMap
    ;mptblcname DAISOP
    ;mpxaxis DeltaMAP 0 29.4 psi
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Decel_AIS_open_steps_from_-Delta_MAP____OVERVIEW:_DAISOP_(DecelAisOpenStepsFromNeg_FromDeltaMap)_is_a_dynamic_anti-stall_table_that_responds_directly_to_the_rate_of_manifold_vacuum_increase_(negative_Delta_MAP)._When_the_driver_suddenly_snaps_the_throttle_shut_at_high_RPM,_manifold_pressure_plunges_downward_at_an_extreme_rate_(_-Delta_MAP_)._If_the_ECU_waits_for_the_standard_closed-loop_idle_speed_routine_to_detect_an_RPM_drop,_the_engine_will_already_have_stalled_before_the_stepper_motor_can_travel._DAISOP_detects_this_sharp_negative_pressure_drop_and_instantly_commands_the_AIS_motor_to_step_open_by_a_calibrated_count,_arresting_the_pressure_drop_and_catching_the_falling_engine_speed_smoothly._|_TUNER'S_GUIDE:_Sudden_Lift_Stalling_(Blow-Off_/_Vent-to-Atmosphere_Valves):_Turbo_cars_that_stall_immediately_when_shifting_gears_or_snapping_the_throttle_shut_under_boost_often_suffer_from_sudden_vacuum_collapse._Increasing_DAISOP_commands_a_quicker,_larger_air_cushion_to_catch_the_RPM_drop._Lightweight_Aluminum_Flywheels:_Ultra-light_rotating_assemblies_drop_RPM_much_faster_than_stock_heavy_cast_flywheels._Increase_DAISOP_by_3_to_6_steps_at_high_delta_MAP_inputs_to_catch_the_rapid_engine_deceleration.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x01, 0x00, 0x00, 0xBA     ;Point 1
    .byte 0x0C, 0x08                 ;Point 2

	;.org	0xc425
DAISCL_DecelAisOpenStepsFromPos_FromDeltaMap:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0B2D
    ;mptbltype 2
    ;mpsubtype 1
    ;mptbllname DecelAisOpenStepsFromPos_FromDeltaMap
    ;mptblcname DAISCL
    ;mpxaxis DeltaMAP 0 29.4 psi
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc Decel_AIS_open_steps_from_+Delta_MAP____OVERVIEW:_DAISCL_(DecelAisOpenStepsFromPos_FromDeltaMap)_operates_as_the_companion_table_to_DAISOP._After_the_AIS_motor_has_stepped_open_to_catch_a_falling_engine_on_trailing-throttle_decel,_manifold_pressure_begins_to_stabilize_and_rise_back_toward_normal_idle_levels_(_+Delta_MAP_)._DAISCL_looks_up_negative_(closing)_step_corrections_based_on_this_positive_pressure_rise,_smoothly_stepping_the_bypass_valve_back_down_to_prevent_the_engine_from_settling_into_a_high,_hanging_idle._|_TUNER'S_GUIDE:_Hanging_Idle_After_Decel:_If_the_engine_catches_decel_successfully_but_then_sits_at_1,300_-_1,500_RPM_for_several_seconds_before_slowly_coming_down,_DAISCL_is_not_closing_the_valve_quickly_enough._Increase_the_closing_step_values_in_DAISCL._Secondary_Decel_Dip:_If_the_engine_catches,_revives,_and_then_immediately_dips_and_stalls_on_the_rebound,_DAISCL_is_closing_the_valve_too_aggressively.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x02, 0x00, 0xFF, 0xAB     ;Point 1
    .byte 0x11, 0xFB                 ;Point 2

	;.org	0xc434
MAPFLR_AISAdditionToControlMap_FromRpm:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0B3D
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AdditionToControlMap_FromRpm
    ;mptblcname MAPFLR
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis ScaledMAP 0 29.4 psi
    ;mptbldesc AIS_Decel_Addition_to_control_MAP_vs._RPM____OVERVIEW:_MAPFLR_(AISAdditionToControlMap_FromRpm)_defines_a_target_manifold_absolute_pressure_floor_as_a_function_of_engine_RPM_(EngineRpm_HB)._During_closed-throttle_deceleration,_the_engine_acts_as_a_powerful_vacuum_pump._At_high_RPM,_manifold_vacuum_can_easily_exceed_25-28_inHg_(_<_15_kPa)._Running_the_engine_in_this_deep_vacuum_zone_leads_to_high_oil_consumption_past_rings,_plug_fouling,_and_unstable_re-ignition._MAPFLR_establishes_a_synthetic_target_MAP_floor_that_rises_with_RPM._The_ECU_modulates_the_AIS_motor_steps_to_keep_live_manifold_pressure_at_or_above_this_calibrated_floor_during_decel._|_TUNER'S_GUIDE:_High_RPM_Decel_Backfire_/_Burble:_If_the_car_bangs_or_backfires_loudly_in_the_exhaust_when_letting_off_the_gas_at_high_RPM_(3,500_-_5,000_RPM),_raising_MAPFLR_forces_the_AIS_to_admit_more_bypass_air,_raising_manifold_pressure_and_preventing_extreme_vacuum_fuel_vaporization._Aggressive_Engine_Braking:_To_maximize_engine_braking_on_manual_transmission_road_race_cars,_reduce_MAPFLR_so_the_engine_pulls_deeper_vacuum.
    ;mpmapaxis y
    .byte 0x03                       ;Number of points in table
    .byte 0x5E, 0x00, 0x00, 0x29     ;Point 1
    .byte 0x7D, 0x05, 0x00, 0x10     ;Point 2
    .byte 0x9C, 0x07                 ;Point 3

	;.org	0xc443
BARFLR_OffsetCorrectionTo_MAPFLR_FromBaro:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0B4E
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname OffsetCorrectionTo_MAPFLR_FromBaro
    ;mptblcname BARFLR
    ;mpxaxis Baro -14.7 14.7 psi
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc AIS_Decel_Offset_correction_due_to_baro_effect____OVERVIEW:_BARFLR_(OffsetCorrectionTo_MAPFLR_FromBaro)_provides_ambient_barometric_pressure_compensation_to_the_deceleration_MAP_floor_(MAPFLR)._Because_ambient_atmospheric_pressure_drops_with_increasing_altitude,_the_physical_pressure_differential_across_the_throttle_plate_changes_drastically._A_target_absolute_pressure_floor_that_works_perfectly_at_sea_level_(101_kPa_/_29.9_inHg)_represents_a_vastly_different_manifold_depression_at_6,000_feet_(80_kPa_/_24_inHg)._BARFLR_scales_the_target_MAP_floor_so_that_altitude_changes_do_not_disrupt_deceleration_airflow_regulation._|_TUNER'S_GUIDE:_Standard_Calibrations:_Typically_calibrated_as_a_flat_multiplier_(0x80_=_128_/_1.0*_normalized)_or_slight_upward_taper_at_low_barometric_readings._High_Altitude_Tuning:_Only_adjust_if_high-altitude_field_testing_reveals_inconsistent_trailing-throttle_behavior_between_sea_level_and_mountainous_driving.
    ;mpmapaxis x
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x80                 ;Point 1

	;.org	0xc44a
MPTEMP_TempTermForMapOffset_FromTemp:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0B5D
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempTermForMapOffset_FromTemp
    ;mptblcname MPTEMP
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Factor 0 1 Factor
    ;mptbldesc AIS_Decel_Temperature_Term____OVERVIEW:_MPTEMP_(TempTermForMapOffset_FromTemp)_is_a_temperature-dependent_scaling_multiplier_applied_to_the_deceleration_MAP_floor_(MAPFLR)._When_the_engine_block_and_intake_manifold_are_cold,_fuel_atomization_is_severely_impaired._Fuel_clings_to_port_walls_in_thick_liquid_puddles,_and_high_manifold_vacuum_during_decel_causes_fuel_to_flash-boil_off_the_walls_erratically._MPTEMP_elevates_the_deceleration_MAP_floor_when_the_engine_is_cold,_forcing_the_AIS_motor_to_supply_more_bypass_airflow_and_maintain_higher_manifold_pressure_during_trailing_throttle_until_the_engine_warms_up._|_TUNER'S_GUIDE:_Cold_Decel_Stumble_/_Shudder:_If_releasing_the_accelerator_while_the_engine_is_warming_up_causes_vehicle_bucking,_shudder,_or_severe_jerking,_increase_the_low-temperature_values_in_MPTEMP._Warm_Consistency:_Above_160_degF,_MPTEMP_plateaus_to_a_constant_nominal_multiplier_to_hand_steady-state_authority_over_to_MAPFLR.
    .byte 0x02                       ;Number of points in table
    .byte 0x90, 0x80, 0x02, 0x4F     ;Point 1
    .byte 0xC7, 0xFF                 ;Point 2

	;.org	0xc451
DCLRFQ_TimeBetweenAisPulsesForDecelAis:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0B6C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBetweenAisPulsesForDecelAis
    ;mptblcname DCLRFQ
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 Sec
    ;mptbldesc OVERVIEW:_DCLRFQ_(TimeBetweenAisPulsesForDecelAis)_establishes_the_pulse_frequency_/_damping_interval_between_consecutive_stepper_motor_movements_while_in_deceleration_control_mode._During_deceleration,_the_ECU_continually_calculates_required_step_corrections_via_DAISOP_and_DAISCL._However,_physical_stepper_motors_require_finite_settling_time_to_move_their_pintles,_and_manifold_pressure_requires_time_to_equilibrate._If_the_ECU_pulsed_the_motor_on_every_program_pass,_the_pintle_would_rapidly_buzz,_skip_steps,_and_cause_erratic_pressure_fluctuations._DCLRFQ_enforces_a_calibrated_delay_timer_(Timer_AisChanges)_before_the_next_step_pulse_can_be_dispatched._|_TUNER'S_GUIDE:_Stock_Value:_0x3F_(63_timer_ticks_/_~0.7_seconds)._Faster_Anti-Stall_Response:_Lowering_DCLRFQ_(e.g._to_0x20_or_0x18)_allows_the_ECU_to_step_the_AIS_motor_open_more_rapidly_during_rapid_deceleration,_which_is_beneficial_for_lightweight_flywheels_or_quick-revving_road_race_cars._Motor_Buzzing_/_Hunting:_Setting_DCLRFQ_too_low_can_cause_the_stepper_motor_to_chatter_or_overshoot_its_intended_step_target.
    .byte 0x3F                       ;Point 1

	;.org	0xc452
DATHOT_EngineTempToStartCalibratingDacal:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0B79
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineTempToStartCalibratingDacal
    ;mptblcname DATHOT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Deg
    ;mptbldesc OVERVIEW:_DATHOT_(EngineTempToStartCalibratingDacal)_defines_the_minimum_engine_coolant_temperature_required_to_activate_DACAL_adaptive_learning._DACAL_(Deceleration_Adaptive_Calibration)_is_Chrysler's_self-learning_idle_trim_mechanism_that_learns_the_mechanical_air_leakage_characteristics_of_the_throttle_plate_and_engine_over_time._Because_cold_engines_exhibit_excessive_internal_friction,_high_oil_drag,_and_changing_throttle_body_thermal_expansion,_learning_decel_trims_on_a_cold_or_lukewarm_engine_would_permanently_corrupt_the_baseline_airflow_memory._DATHOT_ensures_DACAL_learning_only_runs_when_the_engine_has_reached_full_steady-state_operating_temperature_(stock_calibration_=_0xCD_/_~195_degF)._|_TUNER'S_GUIDE:_180_degF_/_160_degF_Thermostats:_This_is_a_major_calibration_trap!_Factory_stock_DATHOT_is_set_to_0xCD_(~195_degF)._If_a_tuner_installs_a_180_degF_or_160_degF_thermostat,_engine_coolant_temperature_will_hover_around_175_degF_-_185_degF,_meaning_CoolantTemp_NEVER_exceeds_DATHOT!_As_a_result,_the_ECU_will_NEVER_run_DACAL_adaptive_idle_learning,_causing_decel_hanging_or_dipping_over_time._Recommended_Setting_for_Cooler_Thermostats:_Lower_DATHOT_to_0xB5_(~175_degF)_for_180_degF_thermostats,_or_0xA0_(~155_degF)_for_160_degF_thermostats.
    .byte 0xCD                       ;Point 1

	;.org	0xc453
DADRPM_DeltaRpmFromIdleSpeedForDacalUpdate:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0B86
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaRpmFromIdleSpeedForDacalUpdate
    ;mptblcname DADRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_DADRPM_(DeltaRpmFromIdleSpeedForDacalUpdate)_establishes_the_maximum_allowable_RPM_error_window_for_DACAL_adaptive_trim_learning._To_guarantee_that_DACAL_learns_true_mechanical_airflow_and_not_transient_disturbances_(such_as_a_driver_resting_a_foot_on_the_pedal,_power_steering_twitches,_or_electrical_fan_cycling),_the_ECU_computes_the_absolute_error_between_target_idle_speed_and_actual_engine_speed:_|TargetIdleSpeed_-_EngineRpm|_._DACAL_learning_is_only_permitted_if_this_error_is_strictly_less_than_or_equal_to_DADRPM._In_stock_calibrations,_DADRPM_is_set_to_0x02_(_2_*_32_=_+/-_64_RPM),_ensuring_learning_occurs_only_under_rock-solid,_stable_idle_conditions._|_TUNER'S_GUIDE:_Lumpy_Aftermarket_Camshafts:_Aggressive_performance_camshafts_have_natural_cyclic_idle_speed_variation_(cam_lope)_that_easily_swings_+/-100_RPM_or_more._With_a_stock_DADRPM_of_64_RPM,_the_ECU_will_almost_never_allow_DACAL_to_update_because_the_idle_RPM_fluctuates_outside_the_narrow_window._Tuning_for_Big_Cams:_Increase_DADRPM_to_0x04_(+/-128_RPM)_or_0x05_(+/-160_RPM)_on_engines_with_performance_camshafts_to_allow_the_adaptive_decel_system_to_successfully_calibrate_at_idle.
    .byte 0x02                       ;Point 1

	;.org	0xc454
DAACF_ACFactorDeltaFromBase:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0B93
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ACFactorDeltaFromBase
    ;mptblcname DAACF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_DAACF_(ACFactorDeltaFromBase)_is_a_calibrated_step_adder_that_is_combined_with_the_deceleration_airflow_base_calculation_whenever_the_A/C_clutch_is_engaged._When_the_air_conditioning_compressor_is_pumping,_it_exerts_substantial_mechanical_torque_drag_on_the_engine_crankshaft._If_the_driver_releases_the_accelerator_pedal_while_the_A/C_is_active,_the_engine's_rotating_assembly_decelerates_much_more_rapidly_than_when_the_A/C_is_off._Without_compensation,_the_engine_would_violently_undershoot_target_idle_and_stall._DAACF_adds_a_calibrated_step_cushion_(stock_calibration_=_9_steps)_to_keep_the_deceleration_airflow_floor_higher_while_the_compressor_is_loading_the_engine._|_TUNER'S_GUIDE:_Decel_Stall_with_A/C_On:_If_the_engine_idles_fine_with_A/C_on,_but_stalls_every_time_you_push_the_clutch_in_or_brake_to_a_stop_with_the_A/C_running,_increase_DAACF_(e.g._from_9_steps_to_14-18_steps)._Hanging_RPM_with_A/C_On:_If_deceleration_RPM_hangs_up_around_1,500_RPM_when_the_A/C_is_running_and_won't_drop,_reduce_DAACF.
    .byte 0x09                       ;Point 1

	;.org	0xc455
DANOM_Base_nominalCal:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0BA0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Base_nominalCal
    ;mptblcname DANOM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_DANOM_(Base_nominalCal)_provides_the_foundational,_non-adaptive_baseline_offset_added_to_the_scaled_DACAL_countdown_timer_(Timer_DacalCountdown_/_4)_during_deceleration_airflow_processing._The_Chrysler_decel_airflow_subsystem_combines_an_adaptive_learned_term_(derived_from_Timer_DacalCountdown)_with_a_fixed_calibrated_floor._DANOM_sets_this_non-volatile_minimum_floor_(calibrated_at_16_steps_/_0x10)._Even_if_the_adaptive_decel_timer_clears_or_zeroes_out,_DANOM_guarantees_that_the_deceleration_routine_always_starts_with_a_solid_mechanical_airflow_cushion._|_TUNER'S_GUIDE:_Base_Decel_Airflow_Cushion:_Raising_DANOM_increases_the_baseline_air_cushion_on_every_deceleration_event,_regardless_of_adaptive_memory_state._Useful_for_lightweight_flywheels_or_engines_with_aggressive_cams_that_need_a_guaranteed_minimum_air_floor._Excessive_Coasting_Forward_Push:_If_the_car_feels_like_it_is_pushing_forward_or_coasting_too_easily_without_engine_braking,_decrease_DANOM_to_lower_the_baseline_airflow.
    .byte 0x10                       ;Point 1

	;.org	0xc456
DCALTM_DacalInhibitTimeAfterStartup:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0BAD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DacalInhibitTimeAfterStartup
    ;mptblcname DCALTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_DCALTM_(DacalInhibitTimeAfterStartup)_specifies_a_lockout_time_delay_immediately_after_the_engine_starts_during_which_DACAL_(Decel_Adaptive_Calibration)_is_forbidden_from_modifying_adaptive_idle_airflow_memories._Immediately_after_an_engine_fires_up,_oil_pressure_is_building,_alternator_charging_voltage_is_fluctuating,_and_initial_cylinder_wall_wetting_is_still_stabilizing._Any_adaptive_learning_performed_during_these_initial_seconds_would_learn_transient_friction_instead_of_true_throttle_body_leakage._DCALTM_inhibits_DACAL_learning_until_KeyOnOrEngineRunningTime_exceeds_this_threshold_(stock_calibration_=_21_ticks_/_~2.3_seconds)._|_TUNER'S_GUIDE:_Stock_Value:_0x15_(~2.3_seconds)._Tuner_Adjustments:_Rarely_needs_alteration._If_an_engine_has_extreme_cold-start_flare_or_prolonged_cranking_recovery,_increasing_DCALTM_to_0x30_(~5_seconds)_ensures_the_engine_has_settled_completely_before_idle_learning_activates.
    .byte 0x15                       ;Point 1

	;.org	0xc457
DCALRT_DacalUpdateRate01_03_07_0f_1f_3f_7f_ff:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0BBA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DacalUpdateRate01_03_07_0f_1f_3f_7f_ff
    ;mptblcname DCALRT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_DCALRT_(DacalUpdateRate01_03_07_0f_1f_3f_7f_ff)_is_a_timing_filter_bitmask_applied_against_Counter_MainLoop1_that_controls_how_frequently_the_DACAL_adaptive_countdown_timer_can_increment_or_decrement._Adaptive_airflow_learning_must_be_gradual._If_adaptive_decel_memory_adapted_instantly_to_every_minor_manifold_pressure_fluctuation,_the_idle_system_would_constantly_oscillate_and_chase_transient_perturbations._By_testing_the_main_loop_counter_against_DCALRT,_the_ECU_enforces_an_integration_time-constant_on_DACAL_updates,_ensuring_smooth_long-term_baseline_learning._|_TUNER'S_GUIDE:_Valid_Bitmask_Patterns:_Permissible_values_correspond_to_power-of-two_bit_patterns_(0x01,_0x03,_0x07,_0x0F,_0x1F,_0x3F,_0x7E,_0x7F,_0xFF)._Faster_Learning:_Decreasing_bitmask_density_causes_the_adaptive_decel_timer_to_adapt_more_rapidly_to_mechanical_throttle_stop_changes._Stability:_Stock_setting_0x7E_provides_excellent_long-term_stability_and_resistance_to_false_learning.
    .byte 0x7E                       ;Point 1

	;.org	0xc458
DDRPM2_AisDeltaRpmFromIdle2:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0BC7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisDeltaRpmFromIdle2
    ;mptblcname DDRPM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_DDRPM2_(AisDeltaRpmFromIdle2)_defines_an_RPM_error_threshold_evaluated_during_the_secondary_deceleration_control_phase_inside_CalculateAisPosition_MM._When_the_vehicle_is_decelerating_with_the_throttle_closed,_the_ECU_monitors_the_difference_between_actual_engine_speed_and_target_idle_speed_(EngineRpm_HB_-_TargetIdleSpeed_HB)._DDRPM2_acts_as_a_gatekeeper:_if_the_engine_speed_is_dropping_and_approaches_target_idle_within_DDRPM2,_the_routine_exits_decel_control_early,_handing_authority_back_to_closed-loop_idle_speed_control._|_TUNER'S_GUIDE:_Stock_Value:_0x00._Tuner_Recommendations:_Leave_at_0x00_unless_customizing_custom_decel_handover_behavior._Setting_higher_forces_an_earlier_handoff_from_decel_dashpot_mode_into_closed-loop_idle_regulation.
    .byte 0x00                       ;Point 1

	;.org	0xc459
DATHT2_EngineTempToStartCalibratingDacal2:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0BD4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname EngineTempToStartCalibratingDacal2
    ;mptblcname DATHT2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 Deg
    ;mptbldesc OVERVIEW:_DATHT2_(EngineTempToStartCalibratingDacal2)_establishes_the_temperature_threshold_for_the_secondary_decel_control_branch_in_CalculateAisPosition_MM._If_engine_coolant_temperature_is_below_DATHT2,_the_ECU_bypasses_the_secondary_RPM_gate_(DDRPM2)_and_branches_directly_into_the_decel_pulse_timer_check_(LDA87),_ensuring_that_colder_engines_receive_full_deceleration_bypass_air_regardless_of_engine_RPM_overspeed_margins._|_TUNER'S_GUIDE:_Low-Temp_Thermostats:_If_running_a_160_degF_or_180_degF_thermostat,_match_DATHT2_to_DATHOT_(e.g._set_to_0xB5_for_180_degF_thermostats)_so_the_thermal_branches_switch_synchronously.
    .byte 0xCD                       ;Point 1

	;.org	0xc45a
DCLMIN_MinLimitOnDecelAisControlledMap:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0BE1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinLimitOnDecelAisControlledMap
    ;mptblcname DCLMIN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_DCLMIN_(MinLimitOnDecelAisControlledMap)_provides_a_hard_minimum_lower_clamp_for_the_calculated_deceleration_target_MAP_floor._During_trailing-throttle_overrun_at_high_engine_speeds,_the_calculated_target_MAP_floor_might_theoretically_calculate_to_an_unrealistically_low_value._If_this_value_were_subtracted_directly_from_live_manifold_pressure,_it_could_produce_an_unintended_negative_delta._DCLMIN_clamps_the_target_MAP_floor_so_that_it_can_never_fall_below_this_absolute_lower_bound_(stock_calibration_=_0x14_/_~15_kPa_/_~25.5_inHg_vacuum),_guaranteeing_consistent_and_bounded_inputs_to_the_DAISOP_anti-stall_table._|_TUNER'S_GUIDE:_Stock_Value:_0x14_(~15_kPa)._Extreme_High-Vacuum_Engines:_Highly_efficient_tight-tolerance_race_engines_with_high_static_compression_can_pull_massive_vacuum_on_decel._Raising_DCLMIN_slightly_(e.g._to_0x1C_=_~21_kPa)_provides_an_earlier_air_cushion_on_trailing_throttle_to_catch_aggressive_decel_drops.
    .byte 0x14                       ;Point 1

	;.org	0xc45b
DLYTIM_AisDelayAfterThrottleClosesWhenMoving:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0BEE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisDelayAfterThrottleClosesWhenMoving
    ;mptblcname DLYTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Decel_AIS_Delay_after_throttle_closes_when_moving____OVERVIEW:_DLYTIM_(AisDelayAfterThrottleClosesWhenMoving)_defines_a_settling_time_delay_loaded_into_Timer_CountdownFromStartRunForAisFeedback_whenever_the_throttle_snaps_shut_while_the_vehicle_is_in_motion_(_>_MPHREF_,_approx_6_MPH)._When_decelerating_while_moving,_the_engine_needs_time_to_coast_down_smoothly_under_dashpot_control._Engaging_closed-loop_idle_speed_feedback_too_early_while_the_car_is_still_rolling_in_gear_would_cause_the_stepper_motor_to_violently_close_down,_inducing_driveline_jerk_and_bucking._DLYTIM_holds_off_closed-loop_idle_regulation_for_~1.6_seconds,_giving_the_vehicle_time_to_complete_its_initial_deceleration_gracefully._|_TUNER'S_GUIDE:_Driveline_Jerk_on_Decel:_If_letting_off_the_gas_while_cruising_causes_an_immediate_jerk_or_'thud'_as_the_engine_braking_kicks_in,_increasing_DLYTIM_extends_the_smooth_dashpot_transition._RPM_Hang_While_Rolling:_If_pushing_the_clutch_in_while_coasting_causes_the_engine_RPM_to_hang_above_1,500_RPM_for_too_long_before_dropping,_reduce_DLYTIM_(e.g._to_0x10_=_~1.0_sec).
    .byte 0x17                       ;Point 1

	;.org	0xc45c
DLYTM2_AisDelayAfterThrottleClosesWhenStopped:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0BFB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisDelayAfterThrottleClosesWhenStopped
    ;mptblcname DLYTIM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc Decel_AIS_Delay_after_throttle_closes_when_stopped____OVERVIEW:_DLYTIM2_(AisDelayAfterThrottleClosesWhenStopped)_defines_the_settling_time_delay_loaded_into_Timer_CountdownFromStartRunForAisFeedback_when_the_throttle_is_snapped_shut_while_the_vehicle_is_stationary_(_<_MPHREF_,_<_6_MPH)._When_the_vehicle_is_stopped_in_neutral_and_the_driver_revs_or_blips_the_throttle,_the_engine_decelerates_rapidly_under_zero_driveline_load._Engaging_closed-loop_idle_speed_control_instantly_as_the_throttle_hits_the_stop_screw_would_cause_the_AIS_motor_to_overreact,_resulting_in_an_RPM_undershoot_and_potential_stall._DLYTIM2_provides_a_generous_~3.0-second_cushion,_allowing_the_engine_to_settle_softly_onto_the_mechanical_stop_and_dashpot_air_cushion_before_closed-loop_trims_resume._|_TUNER'S_GUIDE:_Rev-Blip_Stalling_When_Stopped:_If_revving_the_engine_in_neutral_causes_the_tachometer_needle_to_drop_below_700_RPM_or_stall_when_the_throttle_snaps_shut,_increase_DLYTIM2._Sluggish_Free-Rev_Settle:_If_free-revving_the_engine_in_the_staging_lanes_or_driveway_causes_the_engine_to_take_an_annoying_3-4_seconds_to_return_to_base_idle,_reduce_DLYTIM2_to_0x1C_(~1.8_sec).
    .byte 0x2D                       ;Point 1

	;.org	0xc45d
DRPNK_DriveToParkNeutralKicks_FromTemp:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0C08
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname DriveToParkNeutralKicks_FromTemp
    ;mptblcname DRPNK
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc OVERVIEW:_DRPNK_(DriveToParkNeutralKicks_FromTemp)_defines_a_temporary_stepper_motor_position_kick_applied_when_an_automatic_transmission_is_shifted_out_of_gear_into_Park_or_Neutral._When_shifting_out_of_Drive,_torque_converter_drag_instantly_vanishes._In_stock_calibrations,_DRPNK_is_set_to_0x00_(zero_steps)_because_the_engine_naturally_tends_to_flare_up_rather_than_stall_when_load_is_removed._However,_the_calibration_infrastructure_exists_to_provide_positive_or_negative_step_offsets_across_coolant_temperatures_to_tailor_shift_transition_quality._|_TUNER'S_GUIDE:_Stock_Value:_Single-point_table_set_to_0x00._Automatic_Conversions:_On_automatic_vehicles_with_high-stall_torque_converters,_shifting_into_neutral_can_cause_RPM_flare,_leave_at_0x00._On_manual_transmission_cars,_this_routine_is_inactive.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0xc468
PNDRK_ParkNeutralToDriveKicks_FromTemp:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0C16
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ParkNeutralToDriveKicks_FromTemp
    ;mptblcname PNDRK
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc OVERVIEW:_PNDRK_(ParkNeutralToDriveKicks_FromTemp)_provides_a_pre-emptive_stepper_motor_opening_kick_when_an_automatic_transmission_is_shifted_from_Park_or_Neutral_into_Drive_or_Reverse._Engaging_Drive_locks_the_torque_converter_turbine_against_the_stationary_transmission_geartrain,_placing_an_instant_fluid_drag_load_on_the_idling_engine._If_the_ECU_waits_for_closed-loop_RPM_feedback_to_detect_the_engine_slowing_down,_the_sudden_load_can_cause_the_engine_to_shudder_or_stall._PNDRK_pre-emptively_steps_the_AIS_motor_open_across_engine_coolant_temperatures_to_cushion_the_engagement._|_TUNER'S_GUIDE:_Shifter_Engagement_Stall_(Automatic_Trans):_If_shifting_an_automatic_car_from_Park_into_Drive_or_Reverse_causes_the_engine_to_stall_or_shudder_violently,_populate_PNDRK_with_4_to_8_steps_in_the_cold_and_warm_operating_zones._Manual_Transmissions:_Inoperative_on_manual_transmission_calibrations.
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x00                 ;Point 1

	;.org	0xc473
PNDLTN_DeltaRpmChangeToUse_DRPNK_or_PNDRK:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0C24
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DeltaRpmChangeToUse_DRPNK_or_PNDRK_A
    ;mptblcname PNDLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_PNDLT_(PNDLTN_DeltaRpmChangeToUse_DRPNK_or_PNDRK)_is_a_16-bit_threshold_defining_the_minimum_RPM_deviation_that_must_occur_during_a_transmission_gear_selector_shift_before_the_ECU_will_execute_the_DRPNK_or_PNDRK_step_kick_tables._During_minor_gear_lever_vibrations_or_noisy_switch_contacts,_the_ECU_prevents_spurious_AIS_kicks_by_verifying_that_a_significant_physical_RPM_perturbation_(_|Target_-_Actual|_>=_PNDLT_)_has_occurred_as_a_result_of_torque_converter_coupling._In_stock_calibrations,_PNDLT_is_set_to_0x00C8_(200_RPM)._|_TUNER'S_GUIDE:_Stock_Value:_0x00C8_(200_RPM)._Tight_Torque_Converters:_If_an_aftermarket_torque_converter_has_high_stall_or_very_tight_lockup_that_creates_a_sudden_150_RPM_dip_that_fails_to_trigger_PNDRK,_lower_PNDLT_to_0x0064_(100_RPM)_so_the_kick_triggers_reliably.
    .word 0x00C8                     ;Point 1

	;.org	0xc475
ACCTBL_ACOffIdleDelta_FromSpeed:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0C31
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname ACOffIdleDelta_FromSpeed
    ;mptblcname ACCTBL
    ;mpxaxis Speed 0 128 mph
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc OVERVIEW:_ACCTBL_(ACOffIdleDelta_FromSpeed)_defines_the_dynamic_AIS_step_addition_applied_when_the_Air_Conditioning_compressor_clutch_is_engaged_and_the_engine_is_fully_warmed_up_(CoolantTemp_>=_ACTMP_AisTempSwap)._At_cruising_speeds,_the_A/C_compressor_operates_at_high_RPM,_demanding_significant_horsepower._When_cruising_on_the_highway_or_in_city_traffic,_releasing_the_throttle_while_the_A/C_is_pumping_requires_progressive_bypass_air_to_cushion_the_deceleration._ACCTBL_indexes_vehicle_speed_(VehicleSpeed_HB)_to_provide_an_increasing_step_offset_as_road_speed_rises,_ensuring_seamless_A/C_load_handling_at_all_speeds._|_TUNER'S_GUIDE:_A/C_Decel_Stumble_at_Speed:_If_letting_off_the_gas_while_driving_at_45_MPH_with_the_A/C_on_causes_the_car_to_buck_or_hesitate,_increase_the_mid-speed_points_in_ACCTBL._A/C_Disengagement_Flare:_When_the_A/C_cycles_off_at_speed,_ACCTBL_interacts_directly_with_OFFPER2_to_instantly_subtract_the_A/C_step_addition_and_avoid_engine_speed_flare.
    .byte 0x03                       ;Number of points in table
    .byte 0x32, 0x1E, 0x00, 0x70     ;Point 1
    .byte 0x64, 0x34, 0x00, 0xA6     ;Point 2
    .byte 0x78, 0x41                 ;Point 3

	;.org	0xc484
OFFPER2_AisInstantlyClosesWhenAcDisengages2:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0C41
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisInstantlyClosesWhenAcDisengages2
    ;mptblcname OFFPER2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_OFFPER2_(AisInstantlyClosesWhenAcDisengages2)_specifies_the_exact_fraction_of_the_active_A/C_step_addition_(ACCTBL)_that_is_instantly_subtracted_from_DesiredNewAisPosition_the_moment_the_A/C_compressor_clutch_disengages_while_moving._When_the_A/C_clutch_disengages,_several_horsepower_of_parasitic_load_are_instantaneously_removed_from_the_engine_crankshaft._If_the_AIS_motor_remained_in_its_open_A/C_cruising_position,_the_sudden_loss_of_compressor_drag_would_cause_the_vehicle_to_lurch_forward_or_the_engine_to_flare_noticeably._OFFPER2_multiplies_the_speed-looked-up_ACCTBL_value_by_~94%_(0xF0)_and_immediately_subtracts_it_from_the_desired_stepper_motor_position,_maintaining_constant_engine_torque._|_TUNER'S_GUIDE:_Engine_Flare_When_A/C_Cycles_Off:_If_you_feel_the_car_accelerate_or_hear_the_engine_flare_up_when_the_A/C_compressor_clutch_clicks_off_during_cruising,_increase_OFFPER2_(up_to_0xFF_=_100%_immediate_retraction)._RPM_Sag_When_A/C_Cycles_Off:_If_the_car_jerks_or_RPM_dips_momentarily_when_the_A/C_cycles_off,_reduce_OFFPER2_to_allow_a_softer_step_subtraction.
    .byte 0xF0                       ;Point 1

	;.org	0xc485
IAISOP_IdleAISOpenStepsNegative:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0C4E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname IdleAISOpenStepsNegative
    ;mptblcname IAISOP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_IAISOP_(IdleAISOpenStepsNegative)_provides_an_instant_negative_step_adjustment_to_the_Automatic_Idle_Speed_(AIS)_motor_when_the_A/C_compressor_clutch_disengages_while_the_engine_is_at_curb_idle_(closed_throttle)._While_the_A/C_compressor_is_running,_the_ECU_holds_the_AIS_motor_open_by_extra_steps_to_overcome_compressor_pumping_drag._The_moment_the_A/C_thermostat_or_pressure_switch_opens_and_disengages_the_clutch,_that_mechanical_drag_instantly_vanishes._If_the_extra_bypass_air_were_not_immediately_removed,_the_engine_would_surge_or_flare_up_by_200_to_300_RPM._IAISOP_subtracts_a_calibrated_step_offset_(stock_calibration_=_0xF8_/_-8_steps)_to_keep_idle_speed_stable_and_quiet_during_compressor_cycling._|_TUNER'S_GUIDE:_Idle_Flare_on_A/C_Cycling:_If_engine_RPM_flares_upward_noticeably_every_time_the_A/C_compressor_cycles_off_at_a_traffic_light,_increase_the_magnitude_of_IAISOP_(e.g._from_-8_steps_to_-12_or_-14_steps)._Idle_Dip_/_Sag_on_A/C_Disengagement:_If_engine_RPM_dips_momentarily_when_the_A/C_turns_off,_reduce_the_magnitude_of_IAISOP.
    .byte 0xF8                       ;Point 1

	;.org	0xc486
ACOFFK_ClosedThrottleAcOffKick:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0C5B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ClosedThrottleAcOffKick
    ;mptblcname ACOFFK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_ACOFFK_(ClosedThrottleAcOffKick)_is_a_calibration_parameter_used_during_the_secondary_stage_of_A/C_compressor_disengagement_at_closed_throttle._After_the_initial_negative_kick_(IAISOP)_arrests_engine_flare,_ACOFFK_establishes_the_transitional_intermediate_airflow_ceiling_while_Timer_AisOrO2Sensor_counts_down,_ensuring_the_stepper_motor_does_not_plunge_too_deep_and_cause_a_rebound_stall._|_TUNER'S_GUIDE:_Rebound_Stall_After_A/C_Cycling:_If_the_engine_revives_from_an_A/C_disengagement_flare_only_to_dip_and_stall_1-2_seconds_later,_increase_ACOFFK_to_provide_a_firmer_transitional_floor.
    .byte 0x12                       ;Point 1

	;.org	0xc487
AC2KCK_AcClutchKickOpenAfterAcEnabled:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0C68
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcClutchKickOpenAfterAcEnabled
    ;mptblcname AC2KCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_AC2KCK_(AcClutchKickOpenAfterAcEnabled)_delivers_an_immediate,_pre-emptive_opening_kick_(stock_calibration_=_7_steps)_to_the_AIS_stepper_motor_the_instant_the_ECU_detects_an_A/C_request_or_commands_the_clutch_relay_to_energize._Before_refrigerant_compressor_displacement_builds_head_pressure_against_the_piston_domes,_AC2KCK_cracks_the_idle_air_bypass_open._This_ensures_that_the_engine_is_already_producing_extra_torque_the_exact_millisecond_the_mechanical_clutch_plates_mate,_completely_eliminating_the_initial_RPM_sag_or_shudder_associated_with_A/C_engagement._|_TUNER'S_GUIDE:_A/C_Engagement_Shudder_/_Stumble:_If_turning_on_the_A/C_causes_an_immediate_100-200_RPM_dip_or_vibration_before_the_engine_recovers,_increase_AC2KCK_(e.g._from_7_steps_to_12-16_steps)._A/C_Turn-On_Flare:_If_turning_on_the_A/C_causes_the_engine_to_flare_up_to_1,300_RPM_before_settling,_decrease_AC2KCK.
    .byte 0x07                       ;Point 1

	;.org	0xc488
ACTIME_TimeBeforeAcEnabledAndFullDeltaUsed:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0C75
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBeforeAcEnabledAndFullDeltaUsed
    ;mptblcname ACTIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_ACTIME_(TimeBeforeAcEnabledAndFullDeltaUsed)_sets_the_settling_countdown_duration_(stock_calibration_=_22_ticks_/_~1.5_seconds)_loaded_into_Timer_AisOrO2Sensor_whenever_the_A/C_clutch_engages._During_this_transition_window,_the_pre-emptive_kick_AC2KCK_is_maintained,_and_closed-loop_idle_trims_are_held_in_a_transitional_state_to_give_the_automotive_A/C_refrigeration_circuit_time_to_equalize_head_pressures_before_the_ECU_resumes_standard_steady-state_idle_regulation._|_TUNER'S_GUIDE:_Stock_Setting:_0x16_(~1.5_seconds)._Heavy-Duty_Compressors:_If_running_an_upgraded_high-displacement_compressor_(or_high_ambient_desert_temperatures_where_head_pressures_take_longer_to_stabilize),_increasing_ACTIME_gives_the_engine_extra_cushioned_time_to_absorb_the_compressor_load.
    .byte 0x16                       ;Point 1

	;.org	0xc489
OFFPER_AisInstantlyClosesWhenAcDisengages:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0C82
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisInstantlyClosesWhenAcDisengages
    ;mptblcname OFFPER
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_OFFPER_(AisInstantlyClosesWhenAcDisengages)_defines_a_fractional_scalar_(stock_calibration_=_0x80_=_128/256_=_50%)_multiplied_against_the_speed-dependent_A/C_table_ACCTBL_when_calculating_running_AIS_position_with_the_A/C_clutch_disengaging_during_warm_operation._It_provides_a_50%_intermediate_attenuation_factor_to_softly_taper_off_the_dynamic_A/C_bypass_airflow_rather_than_chopping_it_off_abruptly._|_TUNER'S_GUIDE:_Tuning_Decel_Feel:_Setting_to_0x80_gives_a_50%_airflow_reduction_upon_clutch_disengagement._Setting_to_0x40_leaves_25%_airflow,_setting_to_0xC0_leaves_75%_airflow.
    .byte 0x80                       ;Point 1

	;.org	0xc48a
BTVAIS_MinVoltageForAis:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0C8F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinVoltageForAis
    ;mptblcname BTVAIS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_BTVAIS_(MinVoltageForAis)_is_a_critical_electrical_protection_threshold_that_guards_the_AIS_stepper_motor_and_ECU_hardware_against_low_system_voltage._The_Chrysler_AIS_unit_is_a_4-wire_bipolar_stepper_motor_that_draws_substantial_coil_current_through_the_ECU's_internal_quad-driver_circuitry._If_system_voltage_collapses_(e.g._during_heavy_starter_cranking,_dead_battery,_or_broken_alternator_belt),_pulsing_the_stepper_motor_coils_can_draw_enough_current_to_drag_the_ECU's_internal_5V_regulated_logic_rail_down,_causing_a_microprocessor_brownout_reset._Furthermore,_below_10.5V,_the_motor_coils_cannot_generate_sufficient_magnetic_torque_to_reliably_overcome_pintle_spring_tension,_causing_the_rotor_to_skip_steps_and_lose_position_synchronization._BTVAIS_freezes_the_stepper_motor_in_place_whenever_BatteryVolts_<_BTVAIS._|_TUNER'S_GUIDE:_Stock_Value:_0x71_(113_decimal_=_approximately_10.5_Volts)._Low-Voltage_Tuning_/_Relocated_Batteries:_Do_not_lower_BTVAIS_below_10.0V._If_an_aftermarket_trunk-mounted_battery_or_undersized_racing_battery_causes_voltage_sag_during_cranking,_keeping_BTVAIS_at_stock_ensures_the_ECU_does_not_lose_stepper_step_count_synchronization.
    .byte 0x71                       ;Point 1

L2529:
    ;mpgrp Decel_AIS\
    ;mptbladdr 0x0C9B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname L2529
    ;mptblcname L2529
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_L2529_is_an_unreferenced_or_legacy_Chrysler_engineering_constant_residing_in_the_calibration_ROM_at_address_$0C9B_(ROM_address_$C48B)._In_the_factory_calibration_structure,_L2529,_L3529,_and_L4529_form_a_consecutive_3-byte_data_block_situated_directly_between_BTVAIS_MinVoltageForAis_($0C8F)_and_DCLRF2_TimeBetweenAisPulsesForDecelAis2_($0CBE)._In_the_T-LMv13_codebase,_these_bytes_are_preserved_for_ROM_offset_alignment_and_compatibility_with_earlier_Chrysler_engineering_calibration_tools._|_TUNER'S_GUIDE:_Stock_Value:_0x0D._Tuning_Usage:_Retain_stock_value_(0x0D)._Do_not_modify_unless_developing_custom_assembly_patches_that_repurpose_these_ROM_locations.
    .byte 0x0D                       ;Point 1
L3529:
    ;mpgrp Decel_AIS\
    ;mptbladdr 0x0CA6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname L3529
    ;mptblcname L3529
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_L3529_is_a_preserved_Chrysler_engineering_calibration_constant_residing_at_address_$0CA6_(ROM_address_$C48C)._Like_its_predecessor_L2529,_this_constant_is_part_of_the_decel_idle_parameter_cluster_maintained_across_Chrysler_2.2L/2.5L_Turbo_calibrations_to_maintain_exact_binary_alignment_across_SMEC_and_Logic_Module_firmware_versions._|_TUNER'S_GUIDE:_Stock_Value:_0x0D._Tuning_Usage:_Leave_at_stock_factory_value.
    .byte 0x0D                       ;Point 1
L4529:
    ;mpgrp Decel_AIS\
    ;mptbladdr 0x0CB1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname L4529
    ;mptblcname L4529
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_L4529_is_a_preserved_Chrysler_engineering_calibration_constant_residing_at_address_$0CB1_(ROM_address_$C48D),_immediately_preceding_DCLRF2_TimeBetweenAisPulsesForDecelAis2._Maintained_to_ensure_100%_byte-for-byte_binary_fidelity_with_the_stock_factory_A171_calibration_layout._|_TUNER'S_GUIDE:_Stock_Value:_0xAC._Tuning_Usage:_Leave_untouched_at_stock_value.
    .byte 0xAC                       ;Point 1

	;.org	0xc48e
DCLRF2_TimeBetweenAisPulsesForDecelAis2:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0CBE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeBetweenAisPulsesForDecelAis2
    ;mptblcname DCLRF2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 Sec
    ;mptbldesc OVERVIEW:_DCLRF2_(TimeBetweenAisPulsesForDecelAis2)_establishes_the_settling_time_interval_between_successive_stepper_motor_corrections_while_operating_in_closed-loop_idle_speed_control._Once_the_ECU_enters_closed-loop_idle_feedback,_it_evaluates_whether_actual_engine_RPM_matches_target_idle_speed._If_an_error_exists,_the_ECU_commands_forward_(FWDAIS)_or_reverse_(REVAIS)_steps._However,_engine_speed_takes_several_engine_revolutions_to_respond_to_a_change_in_bypass_air_mass._DCLRF2_ensures_that_Timer_AisChanges_must_exceed_this_threshold_(stock_calibration_=_63_ticks_/_~0.7_seconds)_before_another_step_pulse_can_be_issued,_preventing_severe_closed-loop_hunting,_surging,_or_overshoot._|_TUNER'S_GUIDE:_Idle_Hunting_/_Cyclic_Surging:_If_the_engine_surges_up_and_down_rhythmically_at_idle_(750_RPM_->_1,100_RPM_->_750_RPM_every_1-2_seconds),_the_idle_control_loop_is_reacting_too_fast._Increasing_DCLRF2_dampens_the_closed-loop_response._Sluggish_Idle_Catching:_If_the_idle_takes_too_long_to_respond_to_electrical_loads_(headlights,_blower_motor),_slightly_reducing_DCLRF2_(e.g._to_0x28_/_~0.45_sec)_makes_closed-loop_idle_recovery_more_agile.
    .byte 0x3F                       ;Point 1

	;.org	0xc48f
AISHLM_AisHighLimitMaxOpenSteps:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0CCB
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AisHighLimitMaxOpenSteps
    ;mptblcname AISHLM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_AISHLM_(AisHighLimitMaxOpenSteps)_enforces_an_absolute_mechanical_protection_ceiling_on_the_AIS_stepper_motor_position._The_physical_Chrysler_AIS_stepper_motor_has_a_finite_linear_stroke_(approximately_230_to_240_steps_of_total_travel)._If_the_ECU_software_were_to_command_255_steps_or_allow_step_accumulators_to_roll_over,_the_stepper_motor_pintle_shaft_would_back_out_completely,_disengage_its_internal_lead_screw_threads,_or_jam_violently_against_the_motor_housing,_permanently_destroying_the_actuator._AISHLM_places_an_unyielding_hard_clamp_at_220_steps_(0xDC)._Any_calculated_step_demand_exceeding_AISHLM_is_instantly_clamped_to_AISHLM._|_TUNER'S_GUIDE:_Safety_Critical:_NEVER_increase_AISHLM_above_225_steps._Exceeding_mechanical_travel_will_jam_the_stepper_motor_pintle,_requiring_throttle_body_disassembly_or_motor_replacement._Aftermarket_Throttle_Bodies:_Some_aftermarket_throttle_bodies_have_shallower_bypass_cavities._If_an_aftermarket_throttle_body_binds_at_high_step_counts,_reduce_AISHLM_to_180_-_200_steps_to_guarantee_the_pintle_never_contacts_the_rear_stop.
    .byte 0xDC                       ;Point 1

	;.org	0xc490
DEFAIS_DefaultAISStartPosition:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0CD8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DefaultAISStartPosition
    ;mptblcname DEFAIS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_DEFAIS_(DefaultAISStartPosition)_establishes_the_default_fallback_step_position_for_the_idle_stepper_motor_when_startup_conditions_or_initialization_flags_dictate_a_safe_baseline_bypass_opening._During_early_power-up_before_coolant_temperature_ADC_conversion_is_validated,_or_if_startup_flags_in_BitFlags_80_signal_a_reset/reinitialization_state,_the_ECU_loads_DEFAIS_(stock_calibration_=_12_steps_/_0x0C)_into_DesiredNewAisPosition_to_guarantee_adequate_bypass_air_without_causing_an_uncontrollable_engine_runaway._|_TUNER'S_GUIDE:_Stock_Value:_0x0C_(12_steps)._Modified_Engines:_If_an_engine_with_a_large_camshaft_or_tight_converter_struggles_to_catch_during_early_key-on_initialization_before_the_temperature_table_takes_over,_DEFAIS_can_be_bumped_to_18-24_steps.
    .byte 0x0C                       ;Point 1

	;.org	0xc491
MPHREF_SwitchPointForDecelIdleAisControl:
    ;mpgrp Idle_-_AIS_Decel\
    ;mptbladdr 0x0CE5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname SwitchPointForDecelIdleAisControl
    ;mptblcname MPHREF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 128 mph
    ;mptbldesc Switch_point_between_Decel_or_Idle_AIS_control._Note_there_is_also_a_1.5_mph_hysteresis____OVERVIEW:_MPHREF_(SwitchPointForDecelIdleAisControl)_is_the_critical_speed_threshold_(stock_calibration_=_6_MPH_/_0x06)_defining_the_operational_boundary_between_stationary_curb_idle_regulation_and_moving_deceleration_control._When_the_vehicle_is_moving_above_MPHREF,_the_ECU_treats_closed-throttle_events_as_trailing-throttle_vehicle_deceleration,_engaging_dashpot_anti-stall_airflow_curves_(DLYTIM,_TIMEDC,_MAPFLR)._When_vehicle_speed_drops_below_MPHREF_(with_a_built-in_1.5_MPH_hysteresis_deadband),_the_ECU_transitions_to_stationary_curb_idle_control_(DLYTIM2,_FWDAIS,_REVAIS)._This_clean_separation_prevents_rolling_vehicles_from_surging_at_stop_signs_or_dragging_their_idle_motors_while_coasting_in_gear._|_TUNER'S_GUIDE:_Rolling_Idle_Surge_/_Stall:_If_pushing_the_clutch_in_while_rolling_up_to_a_red_light_at_10-15_MPH_causes_the_engine_to_dip_and_stall,_or_conversely_if_the_engine_hangs_at_1,500_RPM_until_the_vehicle_comes_to_a_dead_stop,_MPHREF_defines_the_boundary._Tuning_Recommendations:_Lowering_MPHREF_to_3-4_MPH_forces_the_ECU_into_stationary_idle_control_earlier._Raising_MPHREF_to_8-10_MPH_extends_deceleration_dashpot_protection_longer_during_low-speed_rolling_traffic.
    .byte 0x06                       ;Point 1

	;.org	0xc492
WSGRPM_AllowedBoost_FromRpm:
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x0CF2
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromRpm
    ;mptblcname WSGRPM
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_RPMs._Boost_is_defined_as_MAP_reading_above_Baro____OVERVIEW:_WSGRPM_AllowedBoost_FromRpm_defines_the_baseline_target_boost_pressure_curve_as_a_function_of_engine_RPM._In_the_Chrysler_Logic_Module_boost_control_architecture,_target_boost_is_not_a_fixed_static_number,_it_is_calculated_dynamically_to_match_the_compressor_map_and_torque_curve_of_the_engine._WSGRPM_forms_the_initial_foundation_of_this_target:_it_commands_lower_boost_at_low_RPM_to_prevent_turbocharger_compressor_surge_and_driveline_strain,_and_tapers_or_holds_boost_at_higher_RPMs_where_cylinder_filling_and_turbocharger_efficiency_are_optimal._|_TUNER'S_GUIDE:_Target_vs._Actual_Boost:_WSGRPM_sets_the_target_goal_(in_psi_above_baro)._The_wastegate_duty_cycle_algorithm_(DCWOT)_modulates_the_wastegate_solenoid_to_bring_manifold_absolute_pressure_up_to_match_this_target_plus_barometric_pressure._Raising_WSGRPM:_Increases_targeted_boost_pressure._To_raise_boost_to_14_psi,_18_psi,_or_higher,_raise_the_Y-axis_boost_values_in_WSGRPM._Crucial_Prerequisite:_Overboost_fuel_shutoff_limits_(MPSHFA_/_MPSHFT)_must_also_be_raised,_or_the_ECU_will_cut_fuel_when_boost_exceeds_the_factory_overboost_ceiling!_Compressor_Surge_Prevention:_Keep_boost_moderate_under_2800_RPM_to_avoid_putting_large_Garrett_or_Mitsubishi_turbos_into_surge.
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x64, 0x5C, 0x00, 0x43     ;Point 1
    .byte 0x96, 0x69                 ;Point 2

	;.org	0xc4a1
WSGTIM_AllowedBoost_FromTime:
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x0D02
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromTime
    ;mptblcname WSGTIM
    ;mpxaxis Time 0 0.72 Sec
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_time_in_boost._Boost_is_defined_as_MAP_reading_above_Baro____OVERVIEW:_WSGTIM_AllowedBoost_FromTime_limits_target_boost_pressure_as_a_function_of_sustained_time_in_boost._This_table_was_designed_by_Chrysler_engineers_to_implement_a_temporary_'overboost_burst'_feature_(delivering_a_short_burst_of_higher_boost_during_passing_maneuvers,_tapering_down_to_a_lower_continuous_boost_level_during_sustained_high-speed_autobahn-style_pulls_to_protect_exhaust_valves_and_turbine_wheels_from_thermal_saturation)._|_TUNER'S_GUIDE:_Stock_Setting:_Flat_12.1_psi_(0x69)._In_the_A171_manual_calibration,_Chrysler_chose_not_to_taper_boost_over_time,_keeping_the_limit_flat._Tuning_Guidance:_If_you_raise_WSGRPM_for_higher_boost_(e.g._18_psi),_you_must_also_raise_WSGTIM_to_at_least_18_psi._Because_the_ECU_enforces_the_lowest_value_between_all_target_tables,_leaving_WSGTIM_at_12.1_psi_will_cap_your_boost_to_12.1_psi!
    ;mpmapaxis y
    .byte 0x01                       ;Number of points in table
    .byte 0xFF, 0x69                 ;Point 1

	;.org	0xc4ac
WSGCLT_AllowedBoost_FromTemp:
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x0D11
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromTemp
    ;mptblcname WSGCLT
    ;mpxaxis Temp -200 260 degrees
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_Engine_Temp._Boost_is_defined_as_MAP_reading_above_Baro____OVERVIEW:_WSGCLT_AllowedBoost_FromTemp_is_the_engine_thermal_protection_boost_ceiling_curve_based_on_coolant_temperature._High_boost_on_a_cold_engine_causes_severe_piston_scuffing,_head_gasket_failure,_and_high_thermal_shock._High_boost_on_an_overheating_engine_causes_runaway_detonation_and_pre-ignition._WSGCLT_restricts_boost_to_low_spring_pressure_(approx._5.5_psi)_when_the_engine_is_cold_(<100_degF)_or_overheating_(>230_degF),_only_allowing_full_boost_when_coolant_temperature_is_within_safe_operating_range_(120_degF-215_degF)._|_TUNER'S_GUIDE:_Cold_Engine_Protection:_Prevents_drivers_from_beating_on_a_cold_engine_before_the_oil_and_coolant_have_reached_operating_temperatures._Overheating_Protection:_Acts_as_an_automatic_failsafe_if_a_radiator_hose_bursts_or_the_thermostat_sticks,_dropping_the_car_to_mechanical_wastegate_boost_to_save_the_engine._Raising_Boost:_When_raising_maximum_boost_to_15+_psi,_increase_the_plateau_of_WSGCLT_(between_130_degF_and_200_degF)_to_match_your_target,_while_maintaining_low_boost_at_cold_and_overheating_extremes.
    ;mpmapaxis y
    .byte 0x04                       ;Number of points in table
    .byte 0x7F, 0x30, 0x01, 0x76     ;Point 1
    .byte 0xA6, 0x69, 0x00, 0x00     ;Point 2
    .byte 0xEE, 0x69, 0xF6, 0x80     ;Point 3
    .byte 0xF4, 0x30                 ;Point 4

	;.org	0xc4bb
WSGCHG_AllowedBoost_FromChargeTemp:
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x0D23
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoost_FromChargeTemp
    ;mptblcname WSGCHG
    ;mpxaxis charge_temp_volts 0 5 volts
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_Charge_Temp._Boost_is_defined_as_MAP_reading_above_Baro._Charge_Temp_numbers_are_approximate_only____OVERVIEW:_WSGCHG_AllowedBoost_FromChargeTemp_provides_intake_air_charge_temperature_boost_limiting._Compressed_turbo_air_heats_up_dramatically._If_the_intake_charge_temperature_becomes_excessively_hot_(due_to_a_heat-soaked_intercooler,_high_ambient_summer_temps,_or_non-intercooled_Turbo_I_configurations),_the_risk_of_catastrophic_detonation_skyrockets._WSGCHG_senses_charge_temperature_and_pulls_boost_down_(from_12.1_psi_down_to_7.6_psi)_if_intake_air_temps_become_dangerously_elevated._|_TUNER'S_GUIDE:_Intercooler_Health:_If_your_car_pulls_hard_on_the_first_run_down_the_drag_strip_but_falls_flat_on_subsequent_runs,_check_charge_temperatures._An_undersized_intercooler_heat-soaks_quickly,_triggering_WSGCHG_boost_reduction._High_Boost_Tuning:_Remember_to_raise_WSGCHG_at_normal_operating_voltages_(above_0.3V)_when_increasing_boost_targets.
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x0A, 0x42, 0x05, 0x92     ;Point 1
    .byte 0x11, 0x69                 ;Point 2

	;.org	0xc4c6
WSGKNK_BoostTimeSinceLastKnock:
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x0D33
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BoostTimeSinceLastKnock
    ;mptblcname WSGKNK
    ;mpxaxis time 0 2.8 sec
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_time_since_last_knock._Boost_is_defined_as_MAP_reading_above_Baro._Charge_Temp_numbers_are_approximate_only____OVERVIEW:_WSGKNK_BoostTimeSinceLastKnock_defines_the_knock-triggered_boost_reduction_penalty_curve._When_the_piezoelectric_knock_sensor_detects_engine_knock_under_boost,_the_ECU_instantly_retards_ignition_timing._If_knock_persists_or_exceeds_knock_thresholds,_spark_retard_alone_is_insufficient._WSGKNK_directly_subtracts_boost_from_the_target_boost_goal_immediately_following_a_knock_event,_steadily_restoring_boost_back_to_normal_over_a_2.8-second_decay_window_as_long_as_no_further_knock_occurs._|_TUNER'S_GUIDE:_Stock_Setting:_Subtracts_2.1_psi_boost_immediately_upon_knock,_decaying_to_0_psi_over_~2.8_seconds._Safety_Failsafe:_Protects_the_engine_from_repeating_high-load_detonation_cycles._Tuning_Note:_Do_not_zero_out_WSGKNK_on_street_engines_running_pump_gas._If_knock_occurs,_lowering_boost_is_your_best_defense_against_broken_ring_lands_and_melted_pistons.
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x02, 0x12, 0xFB, 0x80     ;Point 1
    .byte 0x06, 0x00                 ;Point 2

	;.org	0xc4d1
MXSBST_AllowedBoost_FromSpeed:
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x0D43
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AllowedBoostForAutomatics_FromSpeed
    ;mptblcname MXSBST
    ;mpxaxis Speed 0 128 mph
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_from_Speed_to_protect_automatic_transmissions.____OVERVIEW:_MXSBST_AllowedBoost_FromSpeed_implements_vehicle_speed-dependent_boost_limiting_(gear-based_/_traction_boost_limiting)._In_front-wheel-drive_Chrysler_turbo_vehicles,_hitting_full_12+_psi_boost_in_1st_gear_causes_uncontrollable_wheelspin_and_violent_torque_steer._Additionally,_on_automatic_transmission_vehicles,_full-boost_low-speed_launches_cause_severe_torque_converter_and_differential_pin_wear._MXSBST_limits_boost_to_7.2_psi_below_21_mph,_allowing_boost_to_ramp_up_to_full_12.1_psi_as_vehicle_speed_crosses_30_mph._|_TUNER'S_GUIDE:_1st_Gear_Launch_Traction:_Excellent_tool_for_dialing_in_launch_traction_on_high-horsepower_street_cars._Manual_vs._Automatic:_On_manual_transmission_calibrations,_if_the_Park/Neutral_switch_or_speed_flag_is_grounded,_this_limiter_may_be_bypassed._Drag_Racing:_If_running_drag_slicks_and_you_want_full_boost_off_the_line,_raise_Point_1_to_match_your_target_boost_so_low_speed_does_not_hold_back_launch_power.
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x15, 0x3F, 0x04, 0xAB     ;Point 1
    .byte 0x1E, 0x69                 ;Point 2

	;.org	0xc4d8
WSGPRT_AllowedBoostPartThrottle_FromThrottle:
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x0D53
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AllowedBoostPartThrottle_FromThrottle
    ;mptblcname WSGPRT
    ;mpxaxis in 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Boost_Allowed_at_Part_Throttle._Boost_is_defined_as_MAP_reading_above_Baro____OVERVIEW:_WSGPRT_AllowedBoostPartThrottle_FromThrottle_establishes_the_maximum_target_boost_ceiling_permitted_when_the_engine_is_operating_at_part_throttle._Full_boost_should_only_be_available_when_the_driver's_foot_is_mashed_to_Wide-Open_Throttle._If_the_driver_is_holding_part_throttle_(modulating_speed_on_the_highway_or_in_a_curve),_delivering_15+_psi_boost_against_a_partially_closed_throttle_blade_creates_massive_intake_throttling_losses,_high_turbo_backpressure,_and_poor_drivability._WSGPRT_clamps_maximum_allowable_boost_to_7.2_psi_whenever_the_throttle_is_not_at_WOT._|_TUNER'S_GUIDE:_Stock_Value:_0x3F_(_7.2_psig_)._Part_Throttle_Drivability:_Keeps_the_car_smooth_and_controllable_when_passing_without_needing_to_downshift_or_floor_the_pedal._Tuning_Guidance:_If_you_want_more_responsive_passing_power_at_60-75%_throttle_without_flooring_it,_raise_WSGPRT_to_9-10_psi.
    ;mpmapaxis y
    .byte 0x3F                       ;Point 1

	;.org	0xc4d9
RESFAC_BoostMapCorrectionResponseFactor:
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x0D61
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BoostMapCorrectionResponseFactor
    ;mptblcname RESFAC
    ;mpxaxis DeltaBoost -14.7 14.7 psi
    ;mpyaxis Factor 0 1 factor
    ;mptbldesc OVERVIEW:_RESFAC_BoostMapCorrectionResponseFactor_defines_the_proportional_closed-loop_response_gain_for_wastegate_duty_cycle_correction._When_actual_manifold_pressure_deviates_from_target_boost_(_Delta_Boost_=_Actual_-_Target_),_the_closed-loop_wastegate_controller_must_modulate_duty_cycle_to_eliminate_the_error._RESFAC_scales_how_aggressively_the_controller_reacts_based_on_the_magnitude_of_the_error._|_TUNER'S_GUIDE:_Boost_Stability_vs._Hunting:_Higher_values_speed_up_wastegate_correction,_reducing_initial_boost_spike/overshoot._If_set_too_high,_the_wastegate_solenoid_will_oscillate,_causing_audible_flutter_and_boost_surge.
    ;mpmapaxis x
    .byte 0x02                       ;Number of points in table
    .byte 0x91, 0x06, 0xFF, 0xA6     ;Point 1
    .byte 0xA2, 0x00                 ;Point 2

	;.org	0xc4e8
RATLIM_BoostOverboostPrevention:
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x0D71
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BoostOverboostPrevention
    ;mptblcname RATLIM
    ;mpxaxis RPM 0 16384 mph
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc OVERVIEW:_RATLIM_BoostOverboostPrevention_establishes_an_RPM-dependent_rate-of-rise_boost_buffer_used_to_prevent_sudden_boost_spikes_and_overboost_shutoff_triggers._During_rapid_turbo_spool-up_in_low_gears,_boost_can_spike_past_the_target_before_the_wastegate_actuator_can_physically_move._RATLIM_models_the_maximum_allowable_rate_of_boost_increase_vs_RPM,_preemptively_pulling_wastegate_duty_cycle_to_cushion_the_spool_curve_and_prevent_slamming_into_the_overboost_fuel_cut_ceiling._|_TUNER'S_GUIDE:_Spike_Control:_Prevents_irritating_'hitting_the_windshield'_overboost_fuel_cuts_during_fast_2nd_gear_spool.
    ;mpmapaxis y
    .byte 0x02                       ;Number of points in table
    .byte 0x10, 0x0C, 0xFF, 0xE7     ;Point 1
    .byte 0x4E, 0x06                 ;Point 2

	;.org	0xc4f3
DCWOT_FullThrottleWastegateDutyCycle_C8is100Percent_FromMap:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0D81
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname FullThrottleWastegateDutyCycle_C8is100Percent_FromMap
    ;mptblcname DCWOT
    ;mpxaxis TargetBoost 0 29.4 psi
    ;mpyaxis Duty_Cycle 0 128 percent
    ;mptbldesc WOT_WG_Duty_Cycle____OVERVIEW:_DCWOT_FullThrottleWastegateDutyCycle_C8is100Percent_FromMap_is_the_primary_feed-forward_(open-loop_baseline)_wastegate_duty_cycle_curve_used_by_the_Chrysler_boost_control_system._The_Chrysler_wastegate_solenoid_bleeds_control_pressure_away_from_the_wastegate_actuator_can:_0%_Duty_Cycle_(Solenoid_De-energized):_Full_boost_pressure_reaches_the_actuator_canister,_forcing_the_wastegate_flapper_open_at_base_spring_pressure_(approx._5.5_to_7.0_psi)._100%_Duty_Cycle_(Solenoid_Fully_Pulsing_/_Venting):_All_pressure_is_bled_off_to_atmosphere,_the_wastegate_flapper_stays_held_shut,_producing_maximum_turbo_spool._DCWOT_maps_target_boost_pressure_to_the_expected_solenoid_duty_cycle_required_to_hold_that_boost_level._Closed-loop_corrections_then_trim_this_baseline._|_TUNER'S_GUIDE:_Scaling_Mechanics:_Duty_cycle_is_scaled_from_0_to_200_counts_(0x00_=_0%,_0xC8_=_100%,_1_count_=_0.5%)._Tuning_for_Higher_Boost:_When_raising_boost_targets_in_WSGRPM,_you_must_ensure_DCWOT_provides_sufficient_duty_cycle_to_hold_that_boost._If_the_turbo_cannot_reach_target_boost_despite_raising_target_tables,_raise_the_duty_cycle_values_in_DCWOT._Actuator_Spring_Upgrades:_If_you_install_a_stiffer_aftermarket_wastegate_can_(e.g._10_psi_spring_instead_of_5.5_psi_spring),_lower_DCWOT_across_the_board_to_prevent_uncontrolled_boost_overshooting.
    ;mpmapaxis x
    .byte 0x05                       ;Number of points in table
    .byte 0x30, 0xC8, 0xF9, 0x12     ;Point 1
    .byte 0x3E, 0x67, 0xFE, 0x80     ;Point 2
    .byte 0x50, 0x4C, 0xFE, 0xC0     ;Point 3
    .byte 0x58, 0x42, 0xFF, 0x39     ;Point 4
    .byte 0x7C, 0x26                 ;Point 5

	;.org	0xc506
DCWADJ_FullThrottleWastegateDutyCycleAdjustment_FromRpm:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0D94
    ;mptbltype 2
    ;mpsubtype n
    ;mptbllname FullThrottleWastegateDutyCycleAdjustment_FromRpm
    ;mptblcname DCWADJ
    ;mpxaxis RPM 0 16384 rpm
    ;mpyaxis DC_Adjust -64 64 percent
    ;mptbldesc WOT_Duty_Cycle_Adjustment____OVERVIEW:_DCWADJ_FullThrottleWastegateDutyCycleAdjustment_FromRpm_provides_an_RPM-dependent_duty_cycle_correction_adder_applied_to_the_base_wastegate_duty_cycle_(DCWOT)._Turbocharger_volumetric_efficiency_and_turbine_backpressure_change_dramatically_across_the_rev_range._At_low_RPM,_exhaust_energy_is_weak_and_extra_duty_cycle_is_required_to_spool_the_turbo._At_high_RPM,_rising_exhaust_manifold_backpressure_pushes_the_internal_wastegate_flapper_open,_often_requiring_progressive_duty_cycle_addition_to_prevent_boost_from_tapering_off_towards_redline._DCWADJ_curves_the_duty_cycle_across_RPM._|_TUNER'S_GUIDE:_Preventing_High-RPM_Boost_Drop:_Small_stock_turbos_(Garrett_T03_/_Mitsubishi_TE04H)_frequently_drop_boost_by_2-4_psi_above_5000_RPM_because_exhaust_backpressure_overcomes_the_weak_wastegate_canister_spring._Adding_positive_duty_cycle_in_DCWADJ_at_4800-6000_RPM_compensates_for_this_backpressure_bleed_and_holds_flat_boost_to_redline.
    .byte 0x04                       ;Number of points in table
    .byte 0x37, 0x0C, 0xFE, 0xA3     ;Point 1
    .byte 0x42, 0xFD, 0xFF, 0xD5     ;Point 2
    .byte 0x54, 0xFA, 0x00, 0x92     ;Point 3
    .byte 0x5B, 0xFE                 ;Point 4

	;.org	0xc51d
MAPOFS_BoostMapOffsetForDCWOT:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0DA5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BoostMapOffsetForDCWOT
    ;mptblcname MAPOFS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_MAPOFS_BoostMapOffsetForDCWOT_establishes_the_manifold_pressure_threshold_below_target_boost_where_wastegate_solenoid_closed-loop_modulation_begins._While_manifold_pressure_is_far_below_the_boost_target_(e.g._during_initial_spool-up),_the_wastegate_should_remain_clamped_100%_shut_to_achieve_the_fastest_possible_spool._Once_manifold_pressure_climbs_within_MAPOFS_of_target_boost,_the_ECU_transitions_into_modulating_wastegate_duty_cycle_to_prevent_overshooting._|_TUNER'S_GUIDE:_Stock_Value:_0x17_(_~_2.65_psi_)._Faster_Spool:_Keeping_MAPOFS_around_2-3_psi_ensures_the_wastegate_stays_clamped_shut_right_up_until_the_turbo_is_within_striking_distance_of_the_boost_target.
    .byte 0x17                       ;Point 1

	;.org	0xc51e
KNOKMP_BoostKNKCNTinc:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0DB2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BoostKNKCNTinc
    ;mptblcname KNOKMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_KNOKMP_BoostKNKCNTinc_sets_the_boost_error_threshold_above_barometric_pressure_required_to_increment_the_boost_knock_counter_(KNKCNT)._Knock_occurring_under_deep_vacuum_or_cruise_is_handled_strictly_with_spark_retard._Knock_occurring_under_significant_boost_(_>_KNOKMP_)_increments_KNKCNT,_signaling_the_boost_control_subsystem_that_boost_pressure_itself_must_be_curtailed_to_protect_the_engine._|_TUNER'S_GUIDE:_Stock_Value:_0x23_(_~_4.0_psi_boost_)._Tuning_Guidance:_Preserves_knock-triggered_boost_dump_protection_under_load.
    .byte 0x23                       ;Point 1

	;.org	0xc51f
KNKMAX_BoostMaxKNKBeforeReset:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0DBF
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BoostMaxKNKBeforeReset
    ;mptblcname KNKMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_KNKMAX_BoostMaxKNKBeforeReset_defines_the_maximum_knock_count_ceiling_allowed_under_boost_before_wastegate_duty_cycle_dumping_is_triggered_and_the_counter_resets._When_the_boost_knock_counter_reaches_KNKMAX_(16_events),_the_ECU_confirms_persistent,_dangerous_detonation_and_commands_immediate_wastegate_duty_cycle_reduction_(KDCINC)_to_pull_boost_down._|_TUNER'S_GUIDE:_Stock_Value:_0x10_(16_counts)._Tuning_Guidance:_Low_values_dump_boost_aggressively_on_minor_detonation,_high_values_tolerate_brief_knock_ticks._Leave_near_stock.
    .byte 0x10                       ;Point 1

	;.org	0xc520
RPMBST_MinimumRpmToTrackBoostCreep:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0DCC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinimumRpmToTrackBoostCreep
    ;mptblcname RPMBST
    ;mpxaxis X 0 255 in
    ;mpyaxis RPM 0 16384 rpm
    ;mptbldesc Min_RPM_to_increment_the_boost_error_timer.____OVERVIEW:_RPMBST_MinimumRpmToTrackBoostCreep_defines_the_minimum_engine_speed_required_before_the_ECU_begins_tracking_boost_error_and_boost_creep._At_very_low_engine_speeds_(under_1216_RPM),_turbo_boost_is_non-existent,_and_exhaust_pulses_are_widely_spaced._Tracking_boost_error_at_low_RPM_would_generate_false_error_signals._RPMBST_locks_boost_error_integration_out_below_1216_RPM._|_TUNER'S_GUIDE:_Stock_Value:_0x26_(_1216_RPM_)._Tuning_Guidance:_Leave_at_stock_setting.
    .byte 0x26                       ;Point 1

	;.org	0xc521
PRTMAX_MaxDCForPartThrottleInc:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0DD9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxDCForPartThrottleInc
    ;mptblcname PRTMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_PRTMAX_MaxDCForPartThrottleInc_establishes_the_maximum_permissible_wastegate_duty_cycle_ceiling_allowed_during_part-throttle_boost_control._Prevents_the_closed-loop_duty_cycle_accumulator_from_winding_up_beyond_100%_duty_cycle_(0xC8)_when_modulating_boost_at_part_throttle._|_TUNER'S_GUIDE:_Stock_Value:_0xC8_(100%)._Taming_Sensitive_Throttles:_Lowering_PRTMAX_(e.g._to_70%_/_0x8C)_caps_part-throttle_boost_aggressiveness_if_the_car_feels_too_twitchy_in_traffic.
    .byte 0xC8                       ;Point 1

	;.org	0xc522
MPDEL_HysteresisForBoostIncreasingCondition:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0DE6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname HysteresisForBoostIncreasingCondition
    ;mptblcname MPDEL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_MPDEL_HysteresisForBoostIncreasingCondition_provides_hysteresis_deadband_offset_for_rising_manifold_pressure_evaluation._Distinguishes_between_rising_boost_(accelerating_turbo)_and_falling_boost_(decelerating_turbo)_to_stabilize_closed-loop_wastegate_tracking._|_TUNER'S_GUIDE:_Stock_Value:_0x00._Leave_at_factory_setting.
    .byte 0x00                       ;Point 1

	;.org	0xc523
UPRLIM_UpperLimitOnMPCORR:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0DF3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UpperLimitOnMPCORR
    ;mptblcname UPRLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_UPRLIM_UpperLimitOnMPCORR_specifies_the_maximum_positive_closed-loop_duty_cycle_correction_authority_clamp_(MPCORR)._Limits_how_much_additional_duty_cycle_the_closed-loop_feedback_loop_is_allowed_to_add_on_top_of_the_base_table,_preventing_integral_windup_and_massive_boost_spikes_if_a_vacuum_line_leaks_or_tears._|_TUNER'S_GUIDE:_Stock_Value:_0x10_(16_counts_=_8%_max_duty_cycle_addition)._Tuning_Guidance:_Keeps_the_closed-loop_controller_within_safe_operating_boundaries.
    .byte 0x10                       ;Point 1

	;.org	0xc524
LWRLIM_LowerLimitOnMPCORR:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0E00
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowerLimitOnMPCORR
    ;mptblcname LWRLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_LWRLIM_LowerLimitOnMPCORR_specifies_the_maximum_negative_closed-loop_duty_cycle_reduction_authority_clamp_(MPCORR)._Establishes_how_much_duty_cycle_the_closed-loop_controller_can_pull_out_to_suppress_an_overshooting_boost_spike._Notice_that_Chrysler_configured_negative_authority_(0x20_=_16%)_twice_as_large_as_positive_authority_(0x10_=_8%)_to_ensure_quick,_decisive_suppression_of_dangerous_overboost_spikes._|_TUNER'S_GUIDE:_Stock_Value:_0x20_(32_counts_=_16%_DC_drop)._Overshoot_Control:_Allows_the_ECU_to_decisively_dump_duty_cycle_if_boost_starts_running_away.
    .byte 0x20                       ;Point 1

	;.org	0xc525
KDCINC_WastegateDutyCycleIncreaseStepWhenKnocking:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0E0D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseStepWhenKnocking
    ;mptblcname KDCINC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_KDCINC_WastegateDutyCycleIncreaseStepWhenKnocking_sets_the_incremental_step_size_applied_to_reduce_wastegate_duty_cycle_each_time_severe_knock_is_confirmed_under_boost._When_persistent_knock_is_verified_by_KNKMAX,_the_ECU_steps_down_the_wastegate_duty_cycle_by_adding_KDCINC_counts_to_the_knock_reduction_accumulator,_steadily_opening_the_wastegate_to_lower_manifold_pressure_until_knock_stops._|_TUNER'S_GUIDE:_Stock_Value:_0x04_(2.0%_duty_cycle_drop_per_step)._Tuning_Guidance:_Increasing_KDCINC_pulls_boost_down_faster_when_knocking,_providing_extra_safety_on_pump_gas.
    .byte 0x04                       ;Point 1

	;.org	0xc526
KDCMAX_WastegateDutyCycleIncreaseMaxWhenKnocking:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0E1A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseMaxWhenKnocking
    ;mptblcname KDCMAX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_KDCMAX_WastegateDutyCycleIncreaseMaxWhenKnocking_defines_the_maximum_allowable_cumulative_duty_cycle_reduction_permitted_for_knock_protection._Ensures_that_knock-driven_duty_cycle_reduction_does_not_wind_up_to_an_absurd_level,_capping_total_knock-driven_duty_cycle_reduction_to_40.0%_(0x50),_which_typically_drops_boost_straight_down_to_base_mechanical_actuator_spring_pressure._|_TUNER'S_GUIDE:_Stock_Value:_0x50_(40.0%_max_reduction)._Guaranteed_Failsafe:_Dropping_40%_duty_cycle_guarantees_the_wastegate_drops_to_base_actuator_spring_level_(5-7_psi),_instantly_extinguishing_high-load_knock.
    .byte 0x50                       ;Point 1

	;.org	0xc527
KDCMIN_WastegateDutyCycleIncreaseMinWhenKnocking:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0E27
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleIncreaseMinWhenKnocking
    ;mptblcname KDCMIN
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_KDCMIN_WastegateDutyCycleIncreaseMinWhenKnocking_defines_the_minimum_baseline_duty_cycle_reduction_applied_immediately_upon_the_onset_of_persistent_boost_knock._When_knock-driven_boost_reduction_engages,_dropping_only_a_fraction_of_a_percent_would_take_too_long_to_save_the_engine._KDCMIN_forces_an_immediate_minimum_drop_of_6.0%_duty_cycle_(0x0C),_delivering_an_instant_initial_reduction_in_boost_pressure._|_TUNER'S_GUIDE:_Stock_Value:_0x0C_(6.0%_initial_drop)._Tuning_Guidance:_Provides_immediate_physical_relief_to_knocking_cylinders.
    .byte 0x0C                       ;Point 1

	;.org	0xc528
BSOLCO_BoostSolenoidCutout:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0E34
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BoostSolenoidCutout
    ;mptblcname BSOLCO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_BSOLCO_BoostSolenoidCutout_specifies_the_knock_spark_retard_threshold_above_which_the_wastegate_solenoid_is_completely_de-energized_(cut_out)._When_severe_knock_occurs,_the_ECU_initially_retards_ignition_timing._If_timing_retard_reaches_BSOLCO_(_3.5_deg_of_retard),_the_ECU_determines_that_timing_retard_alone_cannot_control_the_detonation._It_immediately_cuts_power_to_the_wastegate_solenoid_(0%_duty_cycle),_dropping_the_turbocharger_down_to_mechanical_actuator_spring_pressure_(approx._5-7_psi)._|_TUNER'S_GUIDE:_Stock_Value:_0x07_(_~_3.5_deg_spark_retard)._Engine_Protection:_Immediate,_physical_boost_cut_to_protect_the_head_gasket_and_pistons_if_bad_gasoline_or_extreme_heat_causes_persistent_detonation._Tuning_Guidance:_Do_not_raise_excessively,_cutting_boost_when_knocking_is_the_safest_behavior_possible_on_a_turbocharged_engine.
    .byte 0x07                       ;Point 1

	;.org	0xc529
DECTIM_TimeScaleFor_DCDECK:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0E41
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TimeScaleFor_DCDECK
    ;mptblcname DECTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_DECTIM_TimeScaleFor_DCDECK_defines_the_time_interval_bitmask_clock_governing_the_rate_at_which_wastegate_duty_cycle_is_steadily_decremented_while_knock_spark_retard_remains_active._Works_as_the_time-base_prescaler_for_DCDECK._|_TUNER'S_GUIDE:_Stock_Value:_0x03._Leave_at_default_setting.
    .byte 0x03                       ;Point 1

	;.org	0xc52a
DCDECK_WastegateDutyCycleDecrementWhenSparkStillDerated:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0E4E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WastegateDutyCycleDecrementWhenSparkStillDerated
    ;mptblcname DCDECK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_DCDECK_WastegateDutyCycleDecrementWhenSparkStillDerated_specifies_the_continuous_decrement_rate_pulled_from_wastegate_duty_cycle_while_ignition_timing_remains_derated_from_a_knock_event._If_knock_has_occurred_and_spark_timing_has_not_yet_fully_recovered_to_baseline_advance,_the_ECU_steadily_bleeds_off_wastegate_duty_cycle_by_DCDECK_counts_every_clock_interval_(DECTIM),_ensuring_boost_ramps_down_until_ignition_advance_can_safely_recover._|_TUNER'S_GUIDE:_Stock_Value:_0x02_(1.0%_DC_per_interval)._Tuning_Guidance:_Provides_smooth,_gradual_boost_relaxation_during_sustained_knock.
    .byte 0x02                       ;Point 1

	;.org	0xc52b
MAPPT_WastegateDutyCycleMapSwitchPoint:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0E5B
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname WastegateDutyCycleMapSwitchPoint
    ;mptblcname MAPPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Wastegate_Duty_Cycle_Adjustment_boost_switch_point.____OVERVIEW:_MAPPT_WastegateDutyCycleMapSwitchPoint_defines_the_boost_pressure_breakpoint_dividing_low-load_wastegate_duty_cycle_correction_from_high-load_adaptive_duty_cycle_learning._When_manifold_pressure_crosses_above_MAPPT_(_11.2_psi_),_the_ECU_switches_its_closed-loop_boost_logic_into_Stage_2_adaptive_wastegate_duty_cycle_learning._|_TUNER'S_GUIDE:_Stock_Value:_0x62_(_~_11.2_psig_)._Tuning_Guidance:_Should_be_set_near_your_primary_target_boost_level.
    ;mpmapaxis y
    .byte 0x62                       ;Point 1

	;.org	0xc52c
MPDEL1_IncCounterWhenDeltaMapBelowThis:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0E69
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname IncCounterWhenDeltaMapBelowThis
    ;mptblcname MPDEL1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc OVERVIEW:_MPDEL1_IncCounterWhenDeltaMapBelowThis_defines_the_Stage_1_boost_error_threshold_below_which_the_adaptive_wastegate_timer_increments._If_boost_is_lagging_below_target_by_at_least_MPDEL1_(_0.35_psi_),_the_ECU_starts_counting_elapsed_time_toward_an_adaptive_duty_cycle_increase._|_TUNER'S_GUIDE:_Stock_Value:_0x03_(_0.35_psi_)._Tuning_Guidance:_Establishes_the_lower_error_sensitivity_band_for_adaptive_boost_trimming.
    ;mpmapaxis y
    .byte 0x03                       ;Point 1

	;.org	0xc52d
INCPT_AdaptiveIncAfterThisTime:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0E77
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveIncAfterThisTime
    ;mptblcname INCPT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_BoostErrTimer_counts_before_WG_Duty_Cycle_is_incremented._Used_when_boost_is_below_target.____OVERVIEW:_INCPT_AdaptiveIncAfterThisTime_defines_the_dwell_time_in_boost_error_counts_that_underboost_must_persist_before_adaptive_wastegate_duty_cycle_is_incremented._Prevents_transient_turbo_spool_delay_from_prematurely_adapting_the_wastegate_duty_cycle_upward._The_underboost_condition_must_persist_steadily_for_INCPT_counts_before_the_ECU_adds_a_permanent_duty_cycle_correction._|_TUNER'S_GUIDE:_Stock_Value:_0x0A_(10_counts)._Tuning_Guidance:_Keeps_adaptive_boost_trims_stable_and_immune_to_momentary_spool_lag.
    .byte 0x0A                       ;Point 1

	;.org	0xc52e
MPROOF_StopAdaptiveWGWhenMapIsThisCloseToBoostTarget:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0E84
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname StopAdaptiveWGWhenMapIsThisCloseToBoostTarget
    ;mptblcname MPROOF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc OVERVIEW:_MPROOF_StopAdaptiveWGWhenMapIsThisCloseToBoostTarget_defines_the_adaptive_wastegate_deadband_target_window._Once_manifold_pressure_is_within_MPROOF_(_0.23_psi_)_of_target_boost,_the_boost_level_is_considered_accurate,_and_all_adaptive_duty_cycle_learning_freezes_to_avoid_hunting._|_TUNER'S_GUIDE:_Stock_Value:_0x02_(_0.23_psi_)._Tuning_Guidance:_Tight_deadband_ensures_precision_boost_control_without_constant_adaptation_churn.
    ;mpmapaxis y
    .byte 0x02                       ;Point 1

	;.org	0xc52f
INCLM2_UpperLimitOnWastegateDutyCycleCorrection2:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0E92
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UpperLimitOnWastegateDutyCycleCorrection2
    ;mptblcname INCLM2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_INCLM2_UpperLimitOnWastegateDutyCycleCorrection2_establishes_the_Stage_2_upper_clamp_limit_on_total_adaptive_wastegate_duty_cycle._Caps_total_wastegate_duty_cycle_during_Stage_2_adaptive_adjustment_to_88.0%_(0xB0),_ensuring_that_the_wastegate_retains_some_mechanical_bleed_authority_and_does_not_pin_fully_closed._|_TUNER'S_GUIDE:_Stock_Value:_0xB0_(88.0%_DC)._Tuning_Guidance:_If_you_need_100%_duty_cycle_to_hold_high_boost_on_small_turbos,_raise_INCLM2_to_0xC8_(100%).
    .byte 0xB0                       ;Point 1

	;.org	0xc530
MPDEL2_IncCounterWhenDeltaMapBelowThis2:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0E9F
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname IncCounterWhenDeltaMapBelowThis2
    ;mptblcname MPDEL2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaMAP 0 29.4 psi
    ;mptbldesc OVERVIEW:_MPDEL2_IncCounterWhenDeltaMapBelowThis2_defines_the_Stage_2_secondary_boost_error_threshold_used_during_high-load_adaptive_duty_cycle_tracking._|_TUNER'S_GUIDE:_Stock_Value:_0x02_(_0.23_psi_)._Leave_at_stock_setting.
    ;mpmapaxis y
    .byte 0x02                       ;Point 1

	;.org	0xc531
INCPT2_AdaptiveIncAfterThisTime2:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0EAD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AdaptiveIncAfterThisTime2
    ;mptblcname INCPT2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Number_of_BoostErrTimer_counts_before_WG_Duty_Cycle_is_incremented._Used_when_boost_is_below_target.____OVERVIEW:_INCPT2_AdaptiveIncAfterThisTime2_specifies_the_secondary_stage_boost_error_dwell_duration_required_before_incrementing_duty_cycle_in_high-load_adaptive_mode._|_TUNER'S_GUIDE:_Stock_Value:_0x0A_(10_counts)._Leave_at_stock_setting.
    .byte 0x0A                       ;Point 1

	;.org	0xc532
MPDEL3_IncCounterWhenDeltaMapBelowThis3:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0EBA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname IncCounterWhenDeltaMapBelowThis3
    ;mptblcname MPDEL3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_MPDEL3_IncCounterWhenDeltaMapBelowThis3_provides_the_tertiary_error_comparison_threshold_for_adaptive_wastegate_duty_cycle_modulation._|_TUNER'S_GUIDE:_Stock_Setting:_0x00._Leave_at_factory_setting.
    .byte 0x00                       ;Point 1

	;.org	0xc533
INCLIM_UpperLimitOnWastegateDutyCycleCorrection:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0EC7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname UpperLimitOnWastegateDutyCycleCorrection
    ;mptblcname INCLIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_INCLIM_UpperLimitOnWastegateDutyCycleCorrection_establishes_the_primary_Stage_1_upper_clamp_limit_on_adaptive_wastegate_duty_cycle_correction._Caps_the_maximum_correction_allowed_during_the_initial_spool-up_adaptive_phase_to_49.0%_(0x62),_preventing_excessive_duty_cycle_accumulation_before_high_RPM_is_reached._|_TUNER'S_GUIDE:_Stock_Value:_0x62_(49.0%_DC)._Tuning_Guidance:_If_upgrading_to_a_large_turbo_that_requires_high_duty_cycle_to_spool,_raise_INCLIM_to_65-75%_(0x82-0x96).
    .byte 0x62                       ;Point 1

	;.org	0xc534
DCRPML_NoWastegateDutyCycleCorrectionBelowThisRpm:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0ED4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoWastegateDutyCycleCorrectionBelowThisRpm
    ;mptblcname DCRPML
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_DCRPML_NoWastegateDutyCycleCorrectionBelowThisRpm_defines_the_lower_engine_speed_threshold_below_which_adaptive_wastegate_duty_cycle_correction_is_completely_inhibited._Below_1504_RPM,_engine_exhaust_flow_is_insufficient_to_generate_meaningful_boost._Adapting_wastegate_duty_cycle_at_low_lugging_RPMs_would_corrupt_the_duty_cycle_tables._DCRPML_locks_adaptive_duty_cycle_learning_out_below_1504_RPM._|_TUNER'S_GUIDE:_Stock_Value:_0x2F_(_1504_RPM_)._Leave_at_factory_setting.
    .byte 0x2F                       ;Point 1

	;.org	0xc535
DCRPMH_NoWastegateDutyCycleCorrectionAboveThisRpm:
    ;mpgrp Boost_-_WG_Control\
    ;mptbladdr 0x0EE1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NoWastegateDutyCycleCorrectionAboveThisRpm
    ;mptblcname DCRPMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_DCRPMH_NoWastegateDutyCycleCorrectionAboveThisRpm_defines_the_upper_engine_speed_threshold_above_which_adaptive_wastegate_duty_cycle_correction_is_frozen._Chrysler's_adaptive_wastegate_algorithm_was_designed_specifically_to_learn_and_compensate_for_low-RPM_spool-up_variations_(1504_RPM_to_2528_RPM)._Above_2528_RPM,_the_turbo_is_already_fully_spooled,_so_adaptive_duty_cycle_learning_freezes_to_avoid_interference_with_high-RPM_closed-loop_regulation._|_TUNER'S_GUIDE:_Stock_Value:_0x4F_(_2528_RPM_)._Big_Turbo_Upgrades:_Large_turbos_(e.g._Holset_HX35,_Garrett_GT30R)_spool_later_(often_between_3000_and_4200_RPM)._Raising_DCRPMH_to_0x80_(_4096_RPM_)_expands_the_adaptive_spool-up_learning_window_to_match_the_spool_RPM_of_the_larger_turbo.
    .byte 0x4F                       ;Point 1

	;.org	0xc536
MPSHFT_OverboostFuelShutoffEnablePointFromMap_Timer:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\
    ;mptbladdr 0x0EEE
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostFuelShutoffEnablePointFromMap_Timer
    ;mptblcname MPSHFT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc If_MAP_+_BARO_exceeds_MPSHOF,_wait_SHFDLT,_then_kill_engine_for_TRNTM._Overboost_-_$ff_to_disable____OVERVIEW:_MPSHFT_OverboostFuelShutoffEnablePointFromMap_Timer_establishes_the_timed_overboost_fuel_shutoff_threshold._To_prevent_catastrophic_engine_destruction_from_an_overboosting_turbocharger_(e.g._disconnected_wastegate_actuator_hose_or_frozen_wastegate_flapper),_the_Chrysler_ECU_cuts_fuel_to_all_four_injectors_if_boost_pressure_exceeds_factory_safety_margins._MPSHFT_defines_the_initial_threshold_(_13.6_psi_boost_):_if_boost_exceeds_this_level,_the_ECU_starts_the_overboost_timer_(TRNTIM)._If_boost_does_not_fall_below_MPSHFT_before_the_timer_expires,_the_ECU_cuts_fuel_completely._|_TUNER'S_GUIDE:_Stock_Value:_0x76_(_13.6_psig_)._The_'Hitting_a_Brick_Wall'_Sensation:_When_modifying_a_Chrysler_turbo_car_with_a_manual_bleed_valve_or_aftermarket_boost_controller,_hitting_14_psi_triggers_the_overboost_fuel_cut,_causing_the_car_to_violently_buck_forward._Raising_for_More_Boost:_When_tuning_for_15+_psi_boost,_you_must_raise_MPSHFT_(e.g._to_18-20_psi,_or_0xFF_to_disable)_so_higher_boost_targets_can_be_sustained.
    ;mpmapaxis y
    .byte 0x76                       ;Point 1

	;.org	0xc537
MPSHFA_OverboostFuelShutoffEnablePointFromMap_Absolute:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\
    ;mptbladdr 0x0EFC
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostFuelShutoffEnablePointFromMap_Absolute
    ;mptblcname MPSHFA
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc If_MAP_+_BARO_exceeds_MPSHOF,_wait_SHFDLT,_then_kill_engine_for_TRNTM._Overboost_-_$ff_to_disable____OVERVIEW:_MPSHFA_OverboostFuelShutoffEnablePointFromMap_Absolute_defines_the_instantaneous_hard_overboost_ceiling_offset._While_moderate_overboost_(MPSHFT)_waits_for_a_delay_timer_to_allow_harmless_momentary_pressure_spikes,_extreme_runaway_overboost_requires_instant_intervention._MPSHFA_adds_an_absolute_ceiling_offset_(_3.0_psi_)_above_MPSHFT:_if_manifold_pressure_surpasses_this_combined_absolute_ceiling_(_13.6_+_3.0_=_16.6_psi_),_the_ECU_instantly_cuts_fuel_with_zero_timer_delay._|_TUNER'S_GUIDE:_Stock_Value:_0x1A_(_3.0_psi_above_MPSHFT)._Absolute_Failsafe:_Hard_stop_protecting_against_catastrophic_boost_spikes._Tuning_Guidance:_When_raising_MPSHFT,_ensure_MPSHFA_is_adjusted_appropriately,_or_set_MPSHFT_=_0xFF_to_disable_both_stages.
    ;mpmapaxis y
    .byte 0x1A                       ;Point 1

	;.org	0xc538
TRNTM_OverboostFuelShutoffDelay:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\
    ;mptbladdr 0x0F0A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OverboostFuelShutoffDuration
    ;mptblcname TRNTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 Sec
    ;mptbldesc Overboost_shutoff_duration_-_$ff_to_disable_-_stock_$5a____OVERVIEW:_TRNTM_OverboostFuelShutoffDelay_specifies_the_countdown_delay_duration_that_boost_must_exceed_MPSHFT_before_fuel_shutoff_triggers._Provides_an_0.8-second_buffer_window_so_quick_gear_shifts_or_momentary_spool_spikes_do_not_cause_irritating_fuel_cuts_if_boost_quickly_settles_back_down_to_target._|_TUNER'S_GUIDE:_Stock_Setting:_0x17_(_~_0.8_sec_)._Tuning_Guidance:_Increasing_TRNTIM_gives_the_wastegate_more_time_to_reel_in_minor_overshoots_without_cutting_fuel.
    .byte 0x17                       ;Point 1

	;.org	0xc539
LMPSHF_OverboostFuelShutoffDisablePointFromMap_Limp:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\
    ;mptbladdr 0x0F17
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OverboostFuelShutoffDisablePointFromMap_Limp
    ;mptblcname LMPSHF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Overboost_Shutoff_when_Wastegate_problem_has_been_detected_(should_not_disable_this)____OVERVIEW:_LMPSHF_OverboostFuelShutoffDisablePointFromMap_Limp_defines_the_overboost_fuel_shutoff_threshold_applied_when_the_ECU_is_in_Limp_Mode_(due_to_a_detected_wastegate_or_MAP_sensor_fault)._If_the_ECU_flags_a_wastegate_electrical_problem_or_MAP_sensor_out-of-range_condition_(BitFlags_80_bit_4_set),_standard_boost_targeting_cannot_be_trusted._LMPSHF_enforces_a_dedicated,_conservative_overboost_ceiling_to_protect_the_vehicle_in_limp_mode._|_TUNER'S_GUIDE:_Stock_Value:_0x73_(_13.2_psig_)._Tuning_Guidance:_Should_never_be_disabled,_ensures_limp_mode_safety_if_boost_control_wiring_fails.
    ;mpmapaxis y
    .byte 0x73                       ;Point 1

	;.org	0xc53a
FANTMP_FanTurnOnTempAbove45Mph:
    ;mpgrp Fan_Control\
    ;mptbladdr 0x0F25
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOnTempAbove45Mph
    ;mptblcname FANTMP1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc 'On'_setpoint_for_high_speed_fan_control.____OVERVIEW:_FANTMP1_(FanTurnOnTempAbove45Mph)_defines_the_radiator_cooling_fan_turn-on_temperature_threshold_(stock_calibration_=_0xEE_/_~218_degF)_when_the_vehicle_is_cruising_at_highway_speeds_(above_45_MPH)._At_highway_cruising_speeds,_high-velocity_ambient_ram-air_naturally_flows_through_the_front_grille,_condenser,_and_radiator_core,_providing_substantial_passive_cooling_without_requiring_electrical_fan_assistance._Running_the_high-amp_electric_cooling_fan_at_60_MPH_creates_aerodynamic_drag_through_the_radiator_shroud_and_places_unnecessary_electrical_load_on_the_alternator._FANTMP1_elevates_the_fan_turn-on_threshold_to_218_degF_at_speed,_ensuring_the_electric_fan_only_engages_on_the_highway_if_the_engine_encounters_severe_heat_distress_(such_as_climbing_steep_mountain_grades_or_towing_a_trailer)._|_TUNER'S_GUIDE:_160_degF_/_180_degF_Thermostats:_When_upgrading_to_a_180_degF_thermostat,_lower_FANTMP1_to_0xD2_(~195_degF)._For_a_160_degF_thermostat,_lower_to_0xBC_(~175_degF)._High-Speed_Overheating:_If_the_car_runs_cool_in_city_traffic_but_temperatures_climb_on_the_highway,_verify_that_FANTMP1_is_set_appropriately_to_assist_ram_airflow_if_the_radiator_core_is_partially_clogged_or_heat-soaked.
    .byte 0xEE                       ;Point 1

	;.org	0xc53b
FANTMP2_FanTurnOffTempAbove45Mph:
    ;mpgrp Fan_Control\
    ;mptbladdr 0x0F32
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOffTempAbove45Mph
    ;mptblcname FANTMP2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc 'Off'_setpoint_for_high_speed_fan_control.____OVERVIEW:_FANTMP2_(FanTurnOffTempAbove45Mph)_establishes_the_radiator_cooling_fan_turn-OFF_temperature_threshold_(stock_calibration_=_0xE8_/_~208_degF)_when_cruising_above_45_MPH._Once_high-speed_coolant_temperature_triggers_the_fan_ON_(FANTMP1_at_218_degF),_the_fan_continues_running_until_ram_airflow_and_forced_convection_pull_engine_coolant_down_below_FANTMP2._The_10_degF_hysteresis_deadband_between_FANTMP1_(218_degF)_and_FANTMP2_(208_degF)_prevents_the_heavy-duty_radiator_fan_relay_from_rapidly_chattering_on_and_off._|_TUNER'S_GUIDE:_Hysteresis_Staggering:_Always_calibrate_FANTMP2_roughly_8_degF_to_12_degF_below_FANTMP1._If_FANTMP2_is_set_too_close_to_FANTMP1,_relay_contacts_will_arc_and_wear_prematurely._Thermostat_Floor:_Never_set_FANTMP2_below_the_opening_temperature_of_your_mechanical_thermostat_(e.g._never_set_below_185_degF_for_a_180_degF_thermostat),_otherwise_the_electric_fan_will_run_continuously_and_never_turn_off_on_the_highway!
    .byte 0xE8                       ;Point 1

	;.org	0xc53c
FANTMP3_FanTurnOnTempBelow35Mph:
    ;mpgrp Fan_Control\
    ;mptbladdr 0x0F3F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOnTempBelow35Mph
    ;mptblcname FANTMP3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc 'On'_setpoint_for_low_speed_fan_control.____OVERVIEW:_FANTMP3_(FanTurnOnTempBelow35Mph)_is_the_primary_low-speed_and_curb_idle_radiator_fan_turn-on_threshold_(stock_calibration_=_0xE3_/_~200_degF)._When_driving_in_slow_city_traffic,_waiting_at_stoplights,_or_idling_in_gridlock_(_<_35_MPH),_there_is_virtually_zero_passive_ram_airflow_through_the_front_fascia._Engine_waste_heat_rapidly_accumulates_in_the_radiator_coolant._When_coolant_temperature_reaches_FANTMP3,_the_ECU_grounds_the_cooling_fan_relay_driver,_initiating_forced_airflow_through_the_radiator_core_and_condenser_to_bring_engine_temperature_under_control._|_TUNER'S_GUIDE:_Most_Important_Fan_Setting:_FANTMP3_is_the_parameter_tuners_adjust_most_frequently_to_control_hot_idle_temperatures._180_degF_Thermostat_Setup:_Lower_FANTMP3_from_stock_~200_degF_(0xE3)_down_to_0xCB_(~188_degF)._160_degF_Thermostat_Setup:_Lower_FANTMP3_to_0xB5_(~172_degF)._Summer_Traffic_Knock_Resistance:_Keeping_city_idle_coolant_temperatures_around_185_degF_-_190_degF_prevents_heat-soak_of_the_intake_manifold,_sharply_reducing_tip-in_knock_when_accelerating_away_from_stoplights.
    .byte 0xE3                       ;Point 1

	;.org	0xc53d
FANTMP4_FanTurnOffTempBelow35Mph:
    ;mpgrp Fan_Control\
    ;mptbladdr 0x0F4C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnOffTempBelow35Mph
    ;mptblcname FANTMP4
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 F
    ;mptbldesc 'Off'_setpoint_for_low_speed_fan_control.____OVERVIEW:_FANTMP4_(FanTurnOffTempBelow35Mph)_defines_the_temperature_(stock_calibration_=_0xDD_/_~192_degF)_where_the_electric_cooling_fan_shuts_off_after_completing_a_low-speed_cooling_cycle._Once_the_fan_turns_on_at_200_degF_(FANTMP3),_it_stays_running_until_coolant_drops_below_FANTMP4_(192_degF),_providing_an_8_degF_hysteresis_cushion_that_prevents_relay_chattering._|_TUNER'S_GUIDE:_Stagger_with_Thermostat:_Ensure_FANTMP4_is_at_least_3_degF_to_5_degF_above_your_thermostat_rated_opening_temperature._For_a_180_degF_thermostat,_set_FANTMP3_=_190_degF_and_FANTMP4_=_184_degF.
    .byte 0xDD                       ;Point 1

	;.org	0xc53e
FANMAP_FanTurnsOnWhenMapAboveBaroPlusThis:
    ;mpgrp Fan_Control\
    ;mptbladdr 0x0F59
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname FanTurnsOnWhenMapAboveBaroPlusThis
    ;mptblcname FANMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Turns_fan_on_when_boost_is_over_this_level._Used_for_I/C_colling.____OVERVIEW:_FANMAP_(FanTurnsOnWhenMapAboveBaroPlusThis)_is_a_specialized_performance_feature_(stock_calibration_=_0x1A_/_~3.2_psi_of_boost_above_baro)_that_energizes_the_radiator_cooling_fan_during_sustained_turbo_boost._In_factory_turbocharged_Chrysler_applications_(such_as_Daytona_Shelby_Z_and_GLHS_models),_the_radiator_and_intercooler_share_the_forward_front-end_airflow_pathway._During_hard_acceleration_or_boost_spool-up,_charging_the_intercooler_creates_localized_heat_soak._When_manifold_boost_exceeds_barometric_pressure_by_FANMAP_(_MapValue_>=_BaroPressure_+_FANMAP_),_the_ECU_turns_the_cooling_fan_ON_immediately_to_draw_extra_airflow_through_the_nose_of_the_vehicle,_lowering_intake_charge_temperatures._|_TUNER'S_GUIDE:_Drag_Racing_&_Heat-Soak_Protection:_Setting_FANMAP_to_0x10_(~2_psi)_ensures_that_the_moment_the_turbo_spools_into_boost,_the_cooling_fan_spins_up_immediately,_minimizing_heat-soak_in_the_engine_compartment_during_a_quarter-mile_pass._Eliminating_Fan_Cycling:_If_you_do_not_want_the_fan_cycling_on_boost,_set_FANMAP_to_0xFF.
    ;mpmapaxis y
    .byte 0x1A                       ;Point 1

	;.org	0xc53f
FANBAT_FanTurnsOnWhenBatteryTempAboveThis:
    ;mpgrp Fan_Control\
    ;mptbladdr 0x0F67
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FanTurnsOnWhenBatteryTempAboveThis
    ;mptblcname FANBAT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Battery_Temp -200 260 Degrees
    ;mptbldesc Turns_fan_on_when_battery_temp_gets_too_high_for_proper_charging.____OVERVIEW:_FANBAT_(FanTurnsOnWhenBatteryTempAboveThis)_defines_an_underhood_temperature_threshold_(stock_calibration_=_0x9A_/_~120_degF)_measured_by_the_battery_tray_thermistor._Turbocharged_engines_radiate_immense_underhood_heat_soak_from_the_exhaust_manifold_and_turbo_turbine_housing._If_the_battery_and_ECU_(which_sits_inside_the_Power_Module_behind_the_battery)_reach_extreme_temperatures,_lead-acid_battery_plates_warp,_and_alternator_field_regulators_lose_efficiency._If_battery_temperature_rises_above_FANBAT,_the_ECU_turns_the_cooling_fan_ON_to_flush_stagnant_hot_air_out_of_the_engine_bay._|_TUNER'S_GUIDE:_Underhood_Heat_Management:_Useful_on_tight_engine_bays_(like_Omni_/_Charger_GLH)_where_turbo_heat_buildup_is_intense._Battery_Relocation:_If_the_battery_tray_thermistor_is_disconnected_or_deleted,_ensure_this_check_does_not_trigger_false_fan_activation.
    .byte 0x9A                       ;Point 1

	;.org	0xc540
BRPML2_BaroReadLowRPM18002:
    ;mpgrp Baro_Read\
    ;mptbladdr 0x0F74
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname BaroReadLowRPM18002
    ;mptblcname BRPML2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 16384 rpm
    ;mptbldesc OVERVIEW:_BRPML2_(BaroReadLowRPM18002)_defines_the_minimum_engine_speed_(stock_calibration_=_1,800_RPM_/_0x1C20)_required_to_execute_an_in-flight_barometric_pressure_read._Chrysler_turbo_vehicles_utilize_a_single_Manifold_Absolute_Pressure_(MAP)_sensor_to_measure_both_intake_manifold_boost/vacuum_and_ambient_atmospheric_barometric_pressure._To_measure_barometric_pressure_while_driving,_the_ECU_momentarily_energizes_the_Baro_Solenoid,_venting_the_MAP_sensor_port_to_ambient_atmosphere._To_ensure_this_pressure_pulse_does_not_disrupt_engine_fueling_or_cause_a_stumble,_the_ECU_requires_the_engine_to_be_running_within_a_stable,_moderate_cruising_RPM_window_between_BRPML2_(1,800_RPM)_and_BRPMH_(6,650_RPM)._|_TUNER'S_GUIDE:_Stock_Setting:_0x1C20_(1,800_RPM)._Preventing_Low-Speed_Baro_Cycling:_Solenoid_clicks_during_slow_city_driving_can_occasionally_cause_tiny_manifold_pressure_dips._Keeping_BRPML2_at_or_above_1,800_RPM_ensures_the_baro_solenoid_only_cycles_during_highway_cruising_where_intake_airflow_momentum_absorbs_the_momentary_vent_pulse_seamlessly.
    .word 0x1C20                     ;Point 1

	;.org	0xc542
BRPMH2_BaroReadHighRPM66502:
    ;mpgrp Baro_Read\
    ;mptbladdr 0x0F81
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname BaroReadHighRPM66502
    ;mptblcname BRPMH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 16384 rpm
    ;mptbldesc OVERVIEW:_BRPMH_(BaroReadHighRPM66502)_defines_the_absolute_maximum_engine_speed_(stock_calibration_=_6,650_RPM_/_0x3E80)_beyond_which_the_ECU_will_never_attempt_an_in-flight_barometric_pressure_read._At_high_engine_speeds_(approaching_redline),_cylinder_intake_events_occur_at_frequencies_exceeding_200_pulses_per_second._Venting_the_MAP_sensor_to_atmospheric_pressure_at_6,000+_RPM_would_deprive_the_fuel_calculation_routine_of_actual_manifold_boost_data_during_a_maximum-power_condition,_risking_catastrophic_lean_detonation._BRPMH_acts_as_a_fail-safe_ceiling_to_lock_out_the_baro_read_solenoid_during_high-RPM_operation._|_TUNER'S_GUIDE:_High-Revving_Engines:_If_an_engine_is_built_to_rev_to_7,500_-_8,000_RPM,_keep_BRPMH_well_below_the_maximum_redline_(stock_6,650_RPM_is_ideal)_to_guarantee_baro_updates_never_occur_under_high-stress_operating_conditions.
    .word 0x3E80                     ;Point 1

	;.org	0xc544
BRDLAY_BaroReadDelayAfterThrottleClosed2sec:
    ;mpgrp Baro_Read\
    ;mptbladdr 0x0F8E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadDelayAfterThrottleClosed2sec
    ;mptblcname BRDLAY
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc OVERVIEW:_BRDLAY_(BaroReadDelayAfterThrottleClosed2sec)_establishes_the_settling_time_delay_(stock_calibration_=_45_ticks_/_~2.0_seconds)_that_the_engine_must_remain_in_a_stable,_closed-throttle_state_within_the_valid_RPM_window_before_the_baro_read_solenoid_is_energized._If_the_driver_is_rapidly_pumping_the_throttle_pedal_or_shifting_gears,_manifold_pressure_is_undergoing_turbulent_transient_swings._Venting_the_MAP_sensor_during_rapid_pedal_movements_would_introduce_severe_signal_noise._BRDLAY_ensures_the_vehicle_is_in_a_steady,_settled_state_before_initiating_a_baro_sample._|_TUNER'S_GUIDE:_Stock_Value:_0x2D_(~2.0_seconds)._Transient_Resistance:_Increasing_BRDLAY_makes_the_system_more_conservative,_requiring_longer_settled_periods_before_taking_a_reading._Setting_too_low_can_cause_baro_readings_to_be_triggered_during_erratic_pedal_movement.
    .byte 0x2D                       ;Point 1

	;.org	0xc545
BARTIM_BaroReadMinTimeBetweenReadings179sec:
    ;mpgrp Baro_Read\
    ;mptbladdr 0x0F9B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadMinTimeBetweenReadings179sec
    ;mptblcname BARTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 720 sec
    ;mptbldesc OVERVIEW:_BARTIM_(BaroReadMinTimeBetweenReadings179sec)_defines_the_mandatory_minimum_time_interval_(stock_calibration_=_64_ticks_/_~179_seconds_/_approx_3_minutes)_between_successive_barometric_pressure_sampling_events_while_driving._Atmospheric_barometric_pressure_changes_very_gradually_as_a_vehicle_ascends_or_descends_mountain_terrain_(typically_a_few_millibars_per_minute)._Cycling_the_baro_solenoid_too_frequently_would_subject_the_solenoid_valve_to_unnecessary_mechanical_wear_and_introduce_needless_MAP_sensor_signal_interruptions._BARTIM_ensures_the_ECU_updates_ambient_barometric_reference_at_a_sensible,_metered_3-minute_interval._|_TUNER'S_GUIDE:_Mountain_Pass_Racing:_On_hill-climb_race_courses_with_rapid_elevation_changes_(such_as_Pikes_Peak),_reducing_BARTIM_to_0x15_(~60_seconds)_allows_the_ECU_to_track_rapid_altitude_changes_and_altitude_fuel_trim_compensation_more_aggressively._Street_Driving:_Stock_3-minute_interval_is_ideal_for_component_longevity.
    .byte 0x40                       ;Point 1

	;.org	0xc546
BROPTM_BaroReadDelayAfterSolenoidOpenTenthSec:
    ;mpgrp Baro_Read\
    ;mptbladdr 0x0FA8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadDelayAfterSolenoidOpenTenthSec
    ;mptblcname BROPTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc OVERVIEW:_BROPTM_(BaroReadDelayAfterSolenoidOpenTenthSec)_specifies_the_precise_pneumatic_stabilization_delay_(stock_calibration_=_5_tenths_of_a_second_/_0.50_sec)_between_energizing_the_baro_solenoid_and_sampling_the_MAP_sensor_analog-to-digital_converter._When_the_baro_solenoid_opens,_atmospheric_air_rushes_through_the_vacuum_hoses_into_the_MAP_sensor_chamber,_equalizing_the_pressure_from_intake_manifold_vacuum_up_to_ambient_atmospheric_pressure._Due_to_pneumatic_hose_volume,_restriction_orifices,_and_sensor_diaphragm_inertia,_pressure_equalization_takes_several_hundred_milliseconds._If_the_ECU_sampled_the_ADC_immediately,_it_would_record_an_artificially_low_barometric_reading_(simulating_high_altitude)._BROPTM_guarantees_the_sensor_cavity_has_fully_equalized_to_ambient_atmosphere_before_the_reading_is_captured_into_BaroPressure._|_TUNER'S_GUIDE:_Long_Vacuum_Lines_/_Relocated_Sensors:_If_the_MAP_sensor_or_baro_solenoid_has_been_relocated_with_longer_vacuum_lines,_increase_BROPTM_to_0x08_(0.8_seconds)_to_ensure_full_pressure_equalization._Stock_Hardware:_Leave_at_0x05_(0.50_seconds).
    .byte 0x05                       ;Point 1

	;.org	0xc547
BRCLTM_BaroReadDelayAfterSolenoidClosedTenthSec:
    ;mpgrp Baro_Read\
    ;mptbladdr 0x0FB5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BaroReadDelayAfterSolenoidClosedTenthSec
    ;mptblcname BRCLTM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Time 0 2.8 sec
    ;mptbldesc OVERVIEW:_BRCLTM_(BaroReadDelayAfterSolenoidClosedTenthSec)_defines_the_required_pneumatic_recovery_delay_(stock_calibration_=_5_tenths_of_a_second_/_0.50_sec)_following_the_de-energization_(closure)_of_the_barometric_read_solenoid._During_an_in-flight_baro_reading,_the_solenoid_vents_the_MAP_sensor_chamber_to_atmospheric_air._Once_the_reading_is_captured_into_RAM,_the_solenoid_de-energizes,_reconnecting_the_sensor_port_to_the_intake_manifold_vacuum_runner._Because_the_sensor_chamber_was_filled_with_atmospheric_air,_several_hundred_milliseconds_are_required_for_manifold_vacuum_to_evacuate_the_vacuum_line_and_pull_the_sensor_diaphragm_back_down_to_live_manifold_depression._BRCLTM_enforces_a_0.5-second_settling_window_before_manifold_pressure_tracking_resumes,_preventing_false_transient_acceleration_enrichments_or_boost_error_flags._|_TUNER'S_GUIDE:_Stock_Value:_0x05_(0.50_seconds)._Extended_Vacuum_Routing:_If_the_MAP_sensor_is_installed_far_from_the_intake_plenum_with_long_rubber/silicone_hoses,_increasing_BRCLTM_to_0x07_or_0x08_gives_the_intake_vacuum_additional_time_to_evacuate_the_line_before_fuel_and_spark_calculations_read_the_sensor.
    .byte 0x05                       ;Point 1

	;.org	0xc548
BAROHI_BaroReadValidHighLimit:
    ;mpgrp Baro_Read\
    ;mptbladdr 0x0FC2
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BaroReadValidHighLimit
    ;mptblcname BAROHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 14.7 psi
    ;mptbldesc OVERVIEW:_BAROHI_(BaroReadValidHighLimit)_establishes_the_upper_physical_and_electrical_sanity_boundary_for_atmospheric_barometric_pressure._Under_real-world_meteorological_conditions_on_Earth,_ambient_sea-level_barometric_pressure_rarely_exceeds_30.5_-_31.0_inHg_(even_inside_high-pressure_cold_Arctic_air_masses)._If_the_MAP_sensor_returns_an_ADC_reading_exceeding_BAROHI_(stock_calibration_=_0x85_/_~31.2_inHg),_the_ECU_recognizes_that_the_sensor_signal_line_is_shorted_to_5V_reference,_electrically_biased,_or_defective._The_out-of-bounds_reading_is_rejected_and_overwritten_with_BARDFT_BaroReadDefaultValue_(standard_sea_level),_preventing_corrupted_fuel_calculations._|_TUNER'S_GUIDE:_3-Bar_MAP_Sensor_Upgrades:_When_converting_from_a_factory_2-Bar_MAP_sensor_to_a_3-Bar_sensor,_the_sensor_transfer_slope_changes_dramatically._If_using_custom_scaling,_BAROHI_must_be_adjusted_to_match_the_new_3-Bar_voltage_transfer_curve,_otherwise_valid_ambient_air_pressures_will_exceed_BAROHI_and_force_the_ECU_permanently_into_default_baro_limp_mode_(BARDFT)._In_Turbonator_codebases,_3-bar_scaling_tables_(MAPMULT_/_MAPADD)_manage_this_conversion.
    ;mpmapaxis y
    .byte 0x85                       ;Point 1

	;.org	0xc549
BAROLO_BaroReadValidLowLimit:
    ;mpgrp Baro_Read\
    ;mptbladdr 0x0FD0
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BaroReadValidLowLimit
    ;mptblcname BAROLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 14.7 psi
    ;mptbldesc OVERVIEW:_BAROLO_(BaroReadValidLowLimit)_establishes_the_lower_physical_and_electrical_sanity_limit_for_atmospheric_barometric_pressure._Even_at_extreme_drivable_elevations_(such_as_the_summit_of_Pikes_Peak_at_14,115_feet),_ambient_atmospheric_pressure_hovers_around_17.8_-_18.0_inHg_(~60_kPa)._If_an_in-flight_baro_reading_returns_an_ADC_value_below_BAROLO_(stock_calibration_=_0x45_/_~16.5_inHg_/_~15,000_feet),_the_reading_is_physically_impossible_for_a_ground-driven_vehicle._The_ECU_flags_the_sensor_as_open-circuit,_disconnected,_or_leaking_intake_vacuum_into_the_vent_line,_discards_the_reading,_and_substitutes_BARDFT._|_TUNER'S_GUIDE:_Pikes_Peak_/_Extreme_High_Altitude_Racing:_Stock_BAROLO_permits_operation_up_to_~15,000_feet._If_operating_specialized_vehicles_at_extreme_altitudes,_verify_that_raw_baro_readings_do_not_dip_below_BAROLO._Vacuum_Leaks_in_Baro_Solenoid:_If_the_baro_solenoid_internal_vent_valve_sticks_partially_closed,_engine_vacuum_will_bleed_into_the_reading,_dropping_the_reading_below_BAROLO_and_triggering_fallback_to_BARDFT.
    ;mpmapaxis y
    .byte 0x45                       ;Point 1

	;.org	0xc54a
BARDFT_BaroReadDefaultValue:
    ;mpgrp Baro_Read\
    ;mptbladdr 0x0FDE
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname BaroReadDefaultValue
    ;mptblcname BARDFT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Baro -14.7 14.7 psi
    ;mptbldesc OVERVIEW:_BARDFT_(BaroReadDefaultValue)_defines_the_nominal_sea-level_fallback_atmospheric_pressure_(stock_calibration_=_0x7F_/_127_decimal_=_29.92_inHg_/_101.325_kPa_standard_atmosphere)._If_the_MAP_sensor_is_disconnected,_if_the_baro_solenoid_harness_is_damaged,_or_if_an_in-flight_atmospheric_reading_fails_either_BAROHI_or_BAROLO_boundary_tests,_the_ECU_loads_BARDFT_into_BaroPressure._This_ensures_that_all_fuel_modifier_tables,_baro-compensations_(BARAIS,_BARFLR),_and_target_boost_altitude_calculations_fall_back_to_nominal_sea-level_operation,_keeping_the_engine_running_safely_with_standard_baseline_fueling._|_TUNER'S_GUIDE:_Stock_Value:_0x7F_(127_decimal_=_standard_1.0_atmosphere)._High_Altitude_Permanent_Relocation:_If_a_vehicle_operates_exclusively_at_high_altitude_(e.g._Denver,_CO_at_5,280_ft_where_average_baro_is_~25_inHg_/_0x6A),_and_has_a_deleted_or_non-functional_baro_solenoid,_changing_BARDFT_to_0x6A_ensures_that_even_during_limp-home_fallback,_baseline_altitude_fuel_and_spark_trims_remain_accurate.
    ;mpmapaxis y
    .byte 0x7F                       ;Point 1

	;.org	0xc54b
MXSPK1_MaxSparkAdvanceUknown1:
    ;mpgrp Baro_Read\
    ;mptbladdr 0x0FEC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxSparkAdvanceUknown1
    ;mptblcname MXSPK1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_MXSPK1_(MaxSparkAdvanceUknown1)_provides_a_hard_physical_ceiling_on_total_ignition_advance_(stock_calibration_=_0x6E_=_110_decimal_/_110_*_0.5_deg_=_55.0_deg_BTDC)_evaluated_inside_StoreDwell._In_distributor-equipped_Chrysler_2.2L/2.5L_engines,_the_distributor_rotor_sweeps_across_a_physical_brass_cap_terminal._If_total_spark_advance_exceeds_~55_deg_to_60_deg_BTDC,_the_rotor_tip_becomes_physically_closer_to_the_adjacent_cylinder's_cap_terminal_than_the_target_cylinder_terminal._Firing_the_ignition_coil_beyond_this_mechanical_limit_causes_cross-fire_(spark_jumping_to_the_wrong_cylinder),_which_can_break_ring_lands_or_bend_connecting_rods._MXSPK1_clamps_ignition_timing_to_safe_mechanical_limits._|_TUNER'S_GUIDE:_Mechanical_Rotor_Phase_Limit:_NEVER_increase_MXSPK1_above_56_deg_BTDC_on_factory_distributor_systems._Doing_so_will_cause_distributor_cap_cross-firing,_erratic_misfires,_and_backfires_under_light_cruising_conditions._Coil-on-Plug_/_Distributorless_(DIS)_Conversions:_Only_on_custom_distributorless_ignition_systems_(which_eliminate_the_physical_rotor_and_cap)_can_spark_ceilings_be_safely_raised.
    .byte 0x6E                       ;Point 1

	;.org	0xc54c
MXSPK2_MaxSparkAdvanceUknown2:
    ;mpgrp Baro_Read\
    ;mptbladdr 0x0FF9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaxSparkAdvanceUknown2
    ;mptblcname MXSPK2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_MXSPK2_(MaxSparkAdvanceUknown2)_provides_the_secondary_physical_ignition_advance_ceiling_(stock_calibration_=_0x6D_=_109_decimal_/_109_*_0.5_deg_=_54.5_deg_BTDC)._Evaluated_later_in_the_StoreDwell_routine_when_specific_spark_scatter_and_dwell_flags_are_active,_MXSPK2_ensures_that_even_when_deep_vacuum_cruise_advance,_air_charge_temperature_advance,_and_baseline_advance_are_fully_stacked,_total_commanded_ignition_advance_never_exceeds_distributor_terminal_phase_alignment._|_TUNER'S_GUIDE:_High-Vacuum_Cruise_Advance:_When_tuning_light-throttle_highway_cruise_ignition_timing_for_maximum_fuel_economy,_the_sum_of_SPKCRU_and_base_spark_may_approach_50_deg._MXSPK2_prevents_cumulative_additions_from_over-advancing_the_coil_trigger.
    .byte 0x6D                       ;Point 1

	;.org	0xc54d
FMODDV2_StandardFuelModifierDivisor_2:
    ;mpgrp Baro_Read\
    ;mptbladdr 0x1006
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname StandardFuelModifierDivisor_2
    ;mptblcname FMODDV2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_FMODDV2_(StandardFuelModifierDivisor_2)_is_an_internal_mathematical_scaling_divisor_(stock_calibration_=_0x1A_/_26_decimal)_utilized_inside_subroutine_CalculateSumOfAllFuelModifiers_MM._The_ECU_calculates_multiple_environmental_fuel_enrichment_and_leanout_multipliers_(coolant_warmup_enrichment,_air_charge_temperature_trim,_barometric_trim,_and_closed-loop_trims)._To_prevent_arithmetic_overflow_and_maintain_fractional_precision_across_8-bit_integer_multiplications,_intermediate_products_are_scaled_and_divided_by_FMODDV2_before_being_combined_into_the_master_fuel_pulsewidth_equation._|_TUNER'S_GUIDE:_Fixed_Mathematical_Constant:_Do_not_modify_FMODDV2._Changing_this_value_alters_the_fundamental_fixed-point_algebra_of_the_fuel_modifier_pipeline,_causing_global_over-fueling_or_severe_lean_conditions_across_all_driving_modes.
    .byte 0x1A                       ;Point 1

	;.org	0xc54e
ErrorCodeBitMask0:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x1013
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname ErrorCodeBitMask0
    ;mptblcname ERMSK0
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Error_code_masking_bits._Check_the_box_to_enable_that_specific_error.____OVERVIEW:_ERMSK0_(ErrorCodeBitMask0)_is_the_first_of_four_diagnostic_fault_masking_bytes_that_govern_whether_detected_hardware_anomalies_are_logged_into_non-volatile_error_memory_(ErrorBitRegisterStored0)._During_engine_operation,_diagnostic_subroutines_continually_evaluate_sensors_and_circuits._When_a_fault_occurs,_the_diagnostic_routine_sets_a_corresponding_bit_in_temporary_RAM._During_the_checksum_and_error_processing_routine_ChecksumFinished,_the_temporary_fault_bits_are_logically_ANDed_with_ErrorCodeBitMask0_(0xFF)._If_a_bit_is_enabled_(1),_the_fault_code_is_saved_to_battery-backed_RAM_and_can_be_flashed_out_on_the_Power_Loss_light_(Key-On_On-Off-On_sequence)_or_retrieved_via_scan_tool._If_a_bit_is_cleared_(0),_the_fault_is_masked_and_never_recorded._|_TUNER'S_GUIDE:_Disabling_Nuisance_Fault_Codes:_If_a_modified_engine_has_deleted_certain_emissions_components_or_sensor_circuits,_clearing_specific_bits_in_ERMSK0_stops_the_ECU_from_logging_those_error_codes_into_memory_or_flashing_them_on_the_Check_Engine_light._Stock_Value:_0xFF_(all_bits_enabled_in_this_byte).
    ;mpchoices 54_DistSync  53_Checksum  52_StuckRich  51_StuckLean  47_LowVoltage  46_HighVoltage  45_Overboost  44_LostFJ2
    .byte 0xFF                       ;Point 1

ErrorCodeBitMask1:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x1020
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname ErrorCodeBitMask1
    ;mptblcname ERMSK1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Error_code_masking_bits._Check_the_box_to_enable_that_specific_error.____OVERVIEW:_ERMSK1_(ErrorCodeBitMask1)_is_the_second_diagnostic_masking_byte,_located_at_$1020_directly_following_ERMSK0._It_selectively_enables_or_suppresses_OBD_trouble_codes_associated_with_oxygen_sensor_switching_(Code_21),_coolant_sensor_voltage_(Code_22),_throttle_position_sensor_voltage_(Code_24),_and_automatic_shutdown_(ASD)_relay_sensing_(Code_27)._In_this_stock_binary,_bit_6_is_cleared_(0xBF_=_binary_10111111),_intentionally_disabling_diagnostic_reporting_for_an_unused_circuit_variant._|_TUNER'S_GUIDE:_O2_Sensor_Deletion_(Track_Cars):_For_off-road_race_cars_running_open-loop_without_an_oxygen_sensor,_clearing_the_O2_diagnostic_bit_in_ERMSK1_prevents_the_ECU_from_continuously_storing_Code_21.
    ;mpchoices 43_IgnitionCoil  42_ASDRelay  41_ChargingSystem  37_BaroReadSolenoid  36_WastegateSolenoid  35_RadFanRelay  34_SpeedCtlSolenoid  33_AcCutoutRelay
    .byte 0xBF                       ;Point 1

ErrorCodeBitMask2:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x102D
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname ErrorCodeBitMask2
    ;mptblcname ERMSK2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Error_code_masking_bits._Check_the_box_to_enable_that_specific_error.____OVERVIEW:_ERMSK2_(ErrorCodeBitMask2)_controls_the_diagnostic_validation_of_powertrain_solenoid_output_drivers,_including_canister_purge_solenoid_(Code_31),_wastegate_solenoid_electrical_circuit_(Code_32),_EGR_solenoid_(Code_33),_and_radiator_fan_relay_driver_(Code_35)._In_stock_configuration,_bit_0_is_cleared_(0xFE_=_binary_11111110),_masking_an_unequipped_hardware_sensor_line._|_TUNER'S_GUIDE:_Aftermarket_Boost_Controller_/_Solenoid_Removal:_If_the_factory_wastegate_solenoid_is_disconnected_when_converting_to_an_aftermarket_electronic_boost_controller_or_external_gate,_clear_Bit_1_to_completely_suppress_Fault_Code_32_from_being_logged_into_memory.
    ;mpchoices 32_EGR  31_PurgeSolenoid  27_InjectorDriver  26_InjectorCurrent  25_AIS  24_TPS  23_ChargeTempSensor  22_CoolantTempSensor
    .byte 0xFE                       ;Point 1

ErrorCodeBitMask3:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x103A
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname ErrorCodeBitMask3
    ;mptblcname ERMSK3
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc Error_code_masking_bits._Check_the_box_to_enable_that_specific_error.____OVERVIEW:_ERMSK3_(ErrorCodeBitMask3)_is_the_fourth_diagnostic_trouble_code_mask,_governing_alternator_field_control_(Code_41),_automatic_shutdown_driver_(Code_42),_ignition_coil_primary_driver_(Code_44),_and_ROM_checksum_self-test_integrity_(Code_53)._Stock_calibration_sets_ERMSK3_to_0xFF_(all_faults_enabled),_ensuring_complete_system_monitoring_of_the_power_generation_and_ignition_circuits._|_TUNER'S_GUIDE:_External_Alternator_Regulators:_If_an_external_high-amp_racing_alternator_with_its_own_mechanical/internal_voltage_regulator_is_installed,_clearing_the_field_fault_bit_in_ERMSK3_prevents_the_ECU_from_setting_charging_system_fault_codes.
    ;mpchoices 21_O2Sensor  17_EngineTooCool  16_BattVoltageSense  15_DistanceSensor  14_MapElectrical  13_MapPneumatic  12_MemPowerLost  11_NotCranked
    .byte 0xFF                       ;Point 1

	;.org	0xc552
LTHTIM_IfNoO2SwitchForThisTimeThrowFault51or52:
    ;mpgrp Fuel_-_O2_Controller\
    ;mptbladdr 0x1048
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname IfNoO2SwitchForThisTimeThrowFault51or52
    ;mptblcname LTHTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc If_no_O2_sensor_state_change_for_this_time(*2.8sec)_then_fault_51_or_52____OVERVIEW:_LTHTIM_IfNoO2SwitchForThisTimeThrowFault51or52_sets_the_diagnostic_fault_timeout_for_detecting_a_permanently_stuck_or_unresponsive_oxygen_sensor_during_closed-loop_operation._If_an_oxygen_sensor_fails_to_toggle_across_stoichiometric_for_a_sustained_period_while_closed_loop_is_active,_it_indicates_an_unrecoverable_air/fuel_control_failure-such_as_a_massive_vacuum_leak,_failed_fuel_pressure_regulator,_clogged_injector,_or_dead_sensor._When_the_inactivity_timer_reaches_LTHTIM,_the_ECU_logs_Fault_51_(stuck_lean)_or_Fault_52_(stuck_rich),_erases_all_learned_adaptive_fuel_memory_cells,_and_locks_out_closed-loop_trimming._|_TUNER'S_GUIDE:_Stock_Setting:_0xFE_(254_counts_2.8_s_~_711_seconds_~_11.9_minutes_)._Diagnostic_Ramifications:_When_Fault_51_or_52_is_set,_your_learned_adaptive_fuel_trims_are_instantly_wiped_out._The_car_will_revert_to_pure_baseline_open-loop_tables_until_the_fault_condition_clears._Tuning_with_Wideband_/_Open_Loop_Only:_If_you_disable_closed-loop_control_or_run_an_aftermarket_standalone/piggyback_wideband_without_narrow-band_emulation,_the_inactivity_timer_will_eventually_expire_if_closed-loop_flags_remain_set._Ensure_closed-loop_is_cleanly_disabled_or_that_LTHTIM_is_configured_to_prevent_erroneous_CEL_triggers.
    .byte 0xFE                       ;Point 1

	;.org	0xc553
TTEMPL_TstatDiagnosticsMinTempToArmDiagnosticsAtStartup:
    ;mpgrp Setup_-_T-Stat_Diagnostics\
    ;mptbladdr 0x1055
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsMinTempToArmDiagnosticsAtStartup
    ;mptblcname TTEMPL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc OVERVIEW:_TTEMPL_(TstatDiagnosticsMinTempToArmDiagnosticsAtStartup)_defines_the_lower_temperature_boundary_(stock_calibration_=_0x63_/_~70_degF)_required_for_the_ECU_to_arm_the_onboard_thermostat_functional_diagnostic_monitor_(Timer_ThermostatDiagnostics)._The_thermostat_diagnostic_routine_checks_whether_the_engine_warms_up_to_operating_temperature_within_a_reasonable_time_window._However,_in_extreme_sub-zero_winter_temperatures,_a_perfectly_good_thermostat_may_take_very_long_to_warm_the_engine_block,_especially_if_the_cabin_heater_is_running_on_high._To_prevent_false_trouble_codes,_the_ECU_requires_ambient_startup_coolant_temperature_to_be_at_or_above_TTEMPL_before_it_will_arm_the_warmup_monitor._|_TUNER'S_GUIDE:_Cold_Climate_Tuning:_In_freezing_climates,_keeping_TTEMPL_at_stock_(~70_degF)_ensures_that_cold_winter_starts_do_not_trigger_false_Code_17_trouble_codes.
    .byte 0x63                       ;Point 1

	;.org	0xc554
TTEMPH_TstatDiagnosticsMaxTempToArmDiagnosticsAtStartup:
    ;mpgrp Setup_-_T-Stat_Diagnostics\
    ;mptbladdr 0x1062
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsMaxTempToArmDiagnosticsAtStartup
    ;mptblcname TTEMPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc OVERVIEW:_TTEMPH_(TstatDiagnosticsMaxTempToArmDiagnosticsAtStartup)_defines_the_upper_temperature_boundary_(stock_calibration_=_0xE4_/_~228_degF)_for_arming_the_thermostat_diagnostic_monitor._If_the_engine_is_restarted_while_already_fully_warmed_up_(e.g._stopping_for_fuel_or_restarting_a_warm_engine),_the_thermostat_diagnostic_is_redundant_because_the_engine_is_already_past_operating_temperature._If_startup_coolant_temperature_is_at_or_above_TTEMPH,_the_monitor_is_bypassed._|_TUNER'S_GUIDE:_Stock_Value:_0xE4_(~228_degF)._Tuner_Usage:_Retain_stock_setting._Prevents_unnecessary_diagnostic_timer_execution_on_hot_engine_restarts.
    .byte 0xE4                       ;Point 1

	;.org	0xc555
TDAGTP_TstatDiagnosticsTemperatureGoalWithin_HOTIME:
    ;mpgrp Setup_-_T-Stat_Diagnostics\
    ;mptbladdr 0x106F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsTemperatureGoalWithin_HOTIME
    ;mptblcname TDAGTP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Coolant_Temp -200 260 deg
    ;mptbldesc OVERVIEW:_TDAGTP_(TstatDiagnosticsTemperatureGoalWithin_HOTIME)_is_the_target_coolant_temperature_threshold_(stock_calibration_=_0xC7_/_~190_degF_/_88_degC)_that_the_engine_is_required_to_reach_during_warm-up_driving._Inside_subroutine_VerifyOperationOfThermostat_MM,_the_ECU_monitors_coolant_temperature_as_the_vehicle_is_driven_at_road_speed_(_>_VehicleSpeed_>=_7_)._If_the_engine_coolant_warms_up_and_reaches_TDAGTP,_the_thermostat_is_verified_as_functioning_correctly,_and_the_diagnostic_timer_is_cleared_(LC79E)._If_the_vehicle_is_driven_continuously_and_fails_to_reach_TDAGTP_before_HOTIME_expires,_the_ECU_determines_that_the_thermostat_is_stuck_open_or_missing,_setting_OBD_Trouble_Code_17._|_TUNER'S_GUIDE:_160_degF_/_180_degF_Low-Temperature_Thermostats:_This_is_a_classic_false_trouble_code_trigger_on_modified_cars!_If_you_install_a_160_degF_or_180_degF_performance_thermostat,_the_engine_may_stabilize_at_165_degF_-_175_degF._Because_this_is_below_TDAGTP_(~190_degF),_the_ECU_will_eventually_set_Fault_Code_17_and_turn_on_the_Check_Engine_light!_Solution_for_Cool_Thermostats:_Lower_TDAGTP_to_0xB0_(~170_degF)_for_180_degF_thermostats,_or_0x98_(~150_degF)_for_160_degF_thermostats.
    .byte 0xC7                       ;Point 1

	;.org	0xc556
HOTIME_TstatDiagnosticsTimeToAchieveTemperatureGoal:
    ;mpgrp Setup_-_T-Stat_Diagnostics\
    ;mptbladdr 0x107C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TstatDiagnosticsTimeToAchieveTemperatureGoal
    ;mptblcname HOTIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_HOTIME_(TstatDiagnosticsTimeToAchieveTemperatureGoal)_sets_the_maximum_elapsed_driving_time_window_(stock_calibration_=_174_ticks_/_~8_to_10_minutes)_during_which_the_engine_must_reach_the_thermostat_diagnostic_target_temperature_(TDAGTP)._If_the_vehicle_is_driven_at_road_speed_(_>_VehicleSpeed_>=_7_)_and_the_coolant_temperature_remains_below_TDAGTP_after_HOTIME_has_elapsed,_the_ECU_determines_that_coolant_is_freely_bypassing_a_missing_or_stuck-open_thermostat._The_ECU_immediately_sets_OBD_Trouble_Code_17_('Engine_operating_temperature_not_reached'),_alerting_the_technician_to_a_cooling_system_efficiency_defect._|_TUNER'S_GUIDE:_Winter_Warmup_/_High_Flow_Radiators:_In_cold_winter_climates_or_with_massive_aluminum_racing_radiators,_warmup_can_take_slightly_longer._Increasing_HOTIME_gives_the_engine_extra_time_to_warm_up_before_setting_a_trouble_code._Cooler_Thermostat_Compatibility:_Pair_with_TDAGTP_to_prevent_nuisance_Check_Engine_lights_on_modified_cooling_setups.
    .byte 0xAE                       ;Point 1

	;.org	0xc557
MPTHCK_MAPLimitforThrottleBelowHalfChecking:
    ;mpgrp Setup_-_T-Stat_Diagnostics\
    ;mptbladdr 0x1089
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MAPLimitforThrottleBelowHalfChecking
    ;mptblcname MPTHCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_MPTHCK_(MAPLimitforThrottleBelowHalfChecking)_defines_the_manifold_pressure_ceiling_(stock_calibration_=_0x5E_/_~75_kPa)_evaluated_during_throttle_sensor_rationality_routines_in_CheckThrottle_AtFullThrottle._Under_normal_engine_operation,_if_the_throttle_is_truly_near_closed_idle,_manifold_vacuum_should_be_deep_(low_manifold_absolute_pressure)._If_engine_RPM_is_moderate_and_manifold_pressure_is_higher_than_MPTHCK,_the_ECU_checks_whether_the_throttle_linkage_is_mechanically_stuck_or_if_the_TPS_voltage_baseline_has_shifted._|_TUNER'S_GUIDE:_Stock_Value:_0x5E._Large_Duration_Camshafts:_Radical_racing_camshafts_have_poor_idle_vacuum_(high_idle_MAP,_e.g._70-80_kPa)._If_a_big_camshaft_causes_erratic_TPS_learning_or_unintended_closed-throttle_baseline_shifts,_raising_MPTHCK_accommodates_the_lower_idle_vacuum.
    .byte 0x5E                       ;Point 1

	;.org	0xc558
RPTHCK_RPMLimitforThrottleBelowHalfChecking:
    ;mpgrp Setup_-_T-Stat_Diagnostics\
    ;mptbladdr 0x1096
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimitforThrottleBelowHalfChecking
    ;mptblcname RPTHCK
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_RPTHCK_(RPMLimitforThrottleBelowHalfChecking)_specifies_the_lower_engine_speed_limit_(stock_calibration_=_0x18_/_24_*_32_=_768_RPM)_for_throttle_sensor_rationality_evaluation._Prevents_the_ECU_from_adjusting_learned_closed-throttle_baselines_while_the_engine_is_cranking_or_running_at_sub-idle_stall_speeds._|_TUNER'S_GUIDE:_High_Target_Idle_Tuning:_If_target_idle_speed_is_raised_to_950_-_1,050_RPM_for_a_race_engine,_RPTHCK_can_be_left_stock_or_raised_proportionally_to_0x1E_(960_RPM).
    .byte 0x18                       ;Point 1

	;.org	0xc559
MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x10A3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ValueOf_MINTHR_WhenBatteryDisconnected
    ;mptblcname MTHRMX
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_MTHRMX_(ValueOf_MINTHR_WhenBatteryDisconnected)_is_the_default_baseline_closed-throttle_voltage_loaded_into_MINTHR_LowestSessionTPS_whenever_the_battery_is_disconnected_or_the_ECU_undergoes_a_hard_power_reset._Factory_TPS_sensors_typically_output_0.6V_to_0.9V_at_closed_throttle,_but_vary_due_to_mechanical_mounting_tolerances_and_throttle_shaft_wear._Rather_than_requiring_manual_potentiometer_calibration_with_a_voltmeter,_Chrysler_implemented_an_auto-zeroing_adaptive_TPS_baseline:_Upon_battery_reconnect,_MINTHR_is_initialized_to_MTHRMX_(0x5C_/_~1.8V)._The_very_first_time_the_driver_starts_the_car_and_leaves_their_foot_off_the_gas,_the_live_TPS_reading_will_be_lower_than_MTHRMX._The_ECU_ratchets_MINTHR_downward_until_it_locks_onto_the_true_mechanical_stop_voltage._MTHRMX_also_acts_as_a_hard_sanity_ceiling,_the_ECU_will_never_learn_a_closed-throttle_baseline_higher_than_MTHRMX._|_TUNER'S_GUIDE:_Aftermarket_Throttle_Bodies_(Holley_/_Ford_5.0_/_Willys):_When_retrofitting_aftermarket_throttle_bodies,_the_closed-throttle_sensor_voltage_might_rest_higher_or_lower_than_stock._Ensure_the_closed-throttle_output_voltage_is_strictly_below_1.5V_(well_below_MTHRMX_of_1.8V),_so_the_auto-zeroing_routine_can_latch_onto_the_physical_stop._Erratic_Idle_After_Battery_Disconnect:_When_first_reconnecting_the_battery,_always_turn_the_key_ON_and_wait_2-3_seconds_without_touching_the_gas_pedal_to_allow_MINTHR_to_ratchet_down_to_the_mechanical_stop.
    .byte 0x5C                       ;Point 1

	;.org	0xc55a
MININC_Amount_MINTHR_IsIncreasedAtKeyOnOnly:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\
    ;mptbladdr 0x10B0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Amount_MINTHR_IsIncreasedAtKeyOnOnly
    ;mptblcname MININC
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_MININC_Amount_MINTHR_IsIncreasedAtKeyOnOnly_specifies_an_initial_positive_voltage_buffer_added_to_minimum_throttle_baseline_voltage_(MINTHR)_during_key-on_reset_initialization._When_the_ignition_key_is_first_turned_on,_the_throttle_return_spring_might_not_have_seated_the_throttle_blade_fully_against_the_stop_screw,_or_electrical_ground_voltages_might_experience_initial_power-up_bounce._MININC_temporarily_pads_the_initial_minimum_throttle_voltage_estimate,_ensuring_the_ECU_does_not_mislearn_a_false_closed-throttle_zero_position_during_startup._|_TUNER'S_GUIDE:_Stock_Value:_0x05_(_0.10_V_)._Leave_at_factory_setting.
    .byte 0x03                       ;Point 1

	;.org	0xc55b
MININH_Amount_MINTHR_IsIncreasedAtKeyOnOnlyHalfThrottle:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\
    ;mptbladdr 0x10BD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname Amount_MINTHR_IsIncreasedAtKeyOnOnlyHalfThrottle
    ;mptblcname MININH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_MININH_Amount_MINTHR_IsIncreasedAtKeyOnOnlyHalfThrottle_provides_a_secondary_fine-trim_offset_applied_during_startup_throttle_normalization._|_TUNER'S_GUIDE:_Stock_Value:_0x02._Leave_at_default_setting.
    .byte 0x04                       ;Point 1

	;.org	0xc55c
MTHROP_NumberOfBitsAbove_MINTHR_ToDetermineOffThrottleTransition:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x10CA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NumberOfBitsAbove_MINTHR_ToDetermineOffThrottleTransition
    ;mptblcname MTHROP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_MTHROP_(NumberOfBitsAbove_MINTHR_ToDetermineOffThrottleTransition)_defines_the_tight_voltage_threshold_(stock_calibration_=_1_ADC_count_/_~0.02V)_above_MINTHR_LowestSessionTPS_for_the_ECU_to_declare_the_engine_has_returned_to_the_OFF-throttle_state._When_the_driver_releases_the_accelerator_pedal,_the_throttle_plate_snaps_back_toward_the_mechanical_stop._Due_to_return_spring_harmonics_and_cable_friction,_the_final_fraction_of_a_millimeter_takes_a_brief_moment_to_settle._MTHROP_allows_the_ECU_to_recognize_closed_throttle_when_the_TPS_signal_is_within_1_bit_of_learned_idle,_enabling_idle_closed_loop_and_decel_fuel_cutoff_promptly._|_TUNER'S_GUIDE:_Sticky_Throttle_Cables:_If_a_sticky_throttle_cable_or_weak_return_spring_causes_the_throttle_to_stop_0.05V_above_the_mechanical_stop,_the_ECU_may_think_the_driver_is_still_resting_a_foot_on_the_gas,_preventing_idle_regulation._Increasing_MTHROP_to_2_or_3_counts_widens_the_off-throttle_window.
    .byte 0x01                       ;Point 1

	;.org	0xc55d
MTHRCL_NumberOfBitsAbove_MINTHR_ToDetermineOnThrottleTransition:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x10D7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname NumberOfBitsAbove_MINTHR_ToDetermineOnThrottleTransition
    ;mptblcname MTHRCL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_MTHRCL_(NumberOfBitsAbove_MINTHR_ToDetermineOnThrottleTransition)_specifies_the_deadband_margin_(stock_calibration_=_3_ADC_counts_/_~0.059V)_above_MINTHR_LowestSessionTPS_that_the_throttle_voltage_must_exceed_before_the_ECU_declares_an_ON-throttle_transition._This_small_deadband_filters_out_electrical_noise,_alternator_ripple,_and_engine_vibration_from_being_misinterpreted_as_driver_throttle_inputs,_ensuring_idle_speed_regulation_is_not_spuriously_kicked_out_while_idling_at_stoplights._|_TUNER'S_GUIDE:_Hypersensitive_Tip-In:_If_light_vehicle_vibrations_or_rough_road_bumps_cause_the_engine_to_jerk_or_jump_out_of_closed-loop_idle,_increasing_MTHRCL_to_4_or_5_counts_increases_throttle_deadband_stability._Snappier_Tip-In_Response:_Lowering_MTHRCL_to_2_counts_creates_instant_tip-in_acceleration_enrichment_response.
    .byte 0x03                       ;Point 1

	;.org	0xc55e
MAXCNT_ProgramLoopsWithThrottleBelow_MINTHR_ToDecrement_MINTHR:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x10E4
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ProgramLoopsWithThrottleBelow_MINTHR_ToDecrement_MINTHR
    ;mptblcname MAXCNT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_MAXCNT_(ProgramLoopsWithThrottleBelow_MINTHR_ToDecrement_MINTHR)_is_the_integration_filter_counter_(stock_calibration_=_16_loops_/_~176_ms)_that_controls_the_ratcheting_speed_of_learned_closed-throttle_baseline_MINTHR._If_the_throttle_return_spring_pulls_the_throttle_plate_tighter_against_the_stop,_or_as_the_aluminum_throttle_body_cools_down,_the_closed-throttle_voltage_might_drop_slightly_below_the_currently_stored_MINTHR._If_the_ECU_instantly_changed_MINTHR_on_a_single_spike,_electrical_noise_or_ground_dips_could_corrupt_the_baseline._MAXCNT_requires_the_TPS_voltage_to_remain_below_MINTHR_for_16_consecutive_program_loops_before_MINTHR_is_decremented_by_1_step._|_TUNER'S_GUIDE:_Stock_Value:_0x10_(16_loops)._Fast_Adaptive_Learning:_Rarely_needs_modification._Provides_rock-solid_immunity_to_ignition_coil_firing_noise_on_the_sensor_ground_bus.
    .byte 0x10                       ;Point 1

	;.org	0xc55f
REVLMT_OverRevFuelShutoff:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\
    ;mptbladdr 0x10F1
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname OverRevFuelShutoffMapLimpinLower
    ;mptblcname REVLMT
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Map_limpin_and_throttle_above_25%_-_0x3f00=1850rpm____OVERVIEW:_REVLMT_OverRevFuelShutoff_is_the_master_engine_redline_rev_limiter_(fuel_cut_enable_RPM)._Protects_the_valvetrain_from_valve_float,_piston-to-valve_contact,_and_rod_bearing_failure._On_Chrysler_distributor_systems,_the_period_timer_measures_time_between_ignition_pulses_(inversely_proportional_to_RPM)._When_engine_speed_exceeds_REVLMT_(approx._6490_RPM),_the_ECU_immediately_cuts_fuel_delivery_to_all_injectors._|_TUNER'S_GUIDE:_Stock_Cut_Point:_~_6490_RPM_._Raising_Redline:_For_modified_engines_with_upgraded_valve_springs_and_performance_camshafts,_raise_REVLMT_to_6800-7200_RPM._Always_raise_REVLMT2_proportionally_to_ensure_smooth_fuel_recovery.
    .word 0x3F00                     ;Point 1

	;.org	0xc561
REVLMT2_OverRevFuelShutoff:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\
    ;mptbladdr 0x10FE
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname OverRevFuelShutoffMapLimpinUpper
    ;mptblcname REVLMT2
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Map_limpin_and_throttle_above_25%_-_0x3b00=2000rpm____OVERVIEW:_REVLMT2_OverRevFuelShutoff_is_the_rev_limiter_recovery_threshold_(fuel_cut_disable_RPM)._Works_with_REVLMT_to_provide_80_RPM_hysteresis._Once_fuel_is_cut_at_6490_RPM,_engine_speed_must_drop_below_6410_RPM_before_injector_pulses_are_re-enabled._|_TUNER'S_GUIDE:_Hysteresis_Band:_The_80_RPM_gap_produces_a_sharp,_clean_rev_limiter_bounce_rather_than_engine_bucking.
    .word 0x3B00                     ;Point 1

	;.org	0xc563
REVLMT3_OverRevFuelShutoff:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\
    ;mptbladdr 0x110B
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname OverRevFuelShutoffTpsLimpinLower
    ;mptblcname REVLMT3
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Map_gt_75%_of_Baro_and_IdleSwitch_Closed_OR_Map_gt_75%_of_Baro_and_Throttle_Limp-in_and_speed_lt_RVLSPD_-_0x3b00=2000rpm____OVERVIEW:_REVLMT3_OverRevFuelShutoff_defines_the_secondary_rev_limiter_enable_point_(used_during_low_vehicle_speed_or_closed-throttle_conditions)._|_TUNER'S_GUIDE:_Neutral_/_Staging_Rev_Limit:_Can_be_re-purposed_as_a_stationary_/_neutral_rev_limiter.
    .word 0x3B00                     ;Point 1

	;.org	0xc565
REVLMT4_OverRevFuelShutoff:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\
    ;mptbladdr 0x1118
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname OverRevFuelShutoffTpsLimpinUpper
    ;mptblcname REVLMT4
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Map_gt_75%_of_Baro_and_IdleSwitch_Closed_OR_Map_gt_75%_of_Baro_and_Throttle_Limp-in_and_speed_lt_RVLSPD_-_0x2700=3000rpm____OVERVIEW:_REVLMT4_OverRevFuelShutoff_is_the_recovery_threshold_(hysteresis_companion)_for_secondary_rev_limiter_REVLMT3._|_TUNER'S_GUIDE:_Hysteresis:_Paired_with_REVLMT3.
    .word 0x2700                     ;Point 1

	;.org	0xc567
REVLMT5_OverRevFuelShutoff:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\
    ;mptbladdr 0x1125
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname OverRevFuelShutoffNormalLower
    ;mptblcname REVLMT5
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Lower_limit_of_normal_operation_-_0x1300=6168rpm____OVERVIEW:_REVLMT5_OverRevFuelShutoff_defines_the_Stage_3_high-load_in-gear_rev_limiter_enable_point._|_TUNER'S_GUIDE:_Tuning_Guidance:_Adjust_in_unison_with_REVLMT_when_extending_engine_rev_range.
    .word 0x1300                     ;Point 1

	;.org	0xc569
REVLMT6_OverRevFuelShutoff:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\
    ;mptbladdr 0x1132
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname OverRevFuelShutoffNormalUpper
    ;mptblcname REVLMT6
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Upper_limit_of_normal_operation_-_0x119f=6650rpm____OVERVIEW:_REVLMT6_OverRevFuelShutoff_is_the_recovery_threshold_(hysteresis_companion)_for_Stage_3_rev_limiter_REVLMT5._|_TUNER'S_GUIDE:_Hysteresis:_Paired_with_REVLMT5.
    .word 0x119F                     ;Point 1

	;.org	0xc56b
THRTHR_25PctThrValueFromShutoff:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\
    ;mptbladdr 0x113F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname 25PctThrValueFromShutoff
    ;mptblcname THRTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_THRTHR_25PctThrValueFromShutoff_defines_the_25%_throttle_position_threshold_offset_added_to_minimum_throttle_voltage_to_distinguish_between_closed/light_throttle_rev_limiting_and_full-throttle_rev_limiting._|_TUNER'S_GUIDE:_Stock_Value:_0x21_(_~_25%_throttle_opening)._Leave_at_factory_setting.
    .byte 0x21                       ;Point 1

	;.org	0xc56c
RVLSPD_CarSpeedForRevLimitWithTBOff:
    ;mpgrp OB,_Speed,_and_Rev_Limiter\
    ;mptbladdr 0x114C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CarSpeedForRevLimitWithTBOff
    ;mptblcname RVLSPD
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 127 mph
    ;mptbldesc OVERVIEW:_RVLSPD_CarSpeedForRevLimitWithTBOff_defines_the_vehicle_speed_threshold_(20_mph)_that_transitions_between_stationary/neutral_rev_limiters_and_moving_in-gear_rev_limiters._Below_20_mph,_the_ECU_evaluates_low-speed_rev_limits,_above_20_mph,_the_vehicle_is_confirmed_driving_in_motion,_and_the_primary_high-speed_rev_limiter_engages._|_TUNER'S_GUIDE:_Stock_Setting:_0x14_(20_mph)._Launch_Control_Interlock:_Used_by_staging_rev_limiter_routines_to_determine_when_the_car_has_launched_off_the_line.
    .byte 0x14                       ;Point 1

	;.org	0xc56d
ACLRPM_DisableAcBelowThisRPM_500:
    ;mpgrp AC_Control\
    ;mptbladdr 0x1159
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DisableAcBelowThisRPM_500
    ;mptblcname ACLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_ACLRPM_(DisableAcBelowThisRPM_500)_provides_an_emergency_anti-stall_cutout_for_the_air_conditioning_compressor_clutch_(calibrated_around_500_RPM_/_0xA2)._If_engine_RPM_collapses_due_to_sudden_brake_lockup,_clutch_drag,_or_low_idle_instability,_dragging_a_mechanical_A/C_compressor_will_instantly_kill_the_engine._When_engine_speed_drops_below_TargetIdleSpeed_*_(ACLRPM_/_256),_the_ECU_immediately_de-energizes_the_A/C_clutch_relay,_dumping_compressor_drag_so_the_engine_can_catch_and_revive._|_TUNER'S_GUIDE:_Anti-Stall_Protection:_Prevents_stalling_when_coming_to_a_panic_stop_with_the_A/C_on._Big_Camshaft_Lope:_If_an_aftermarket_camshaft_causes_idle_RPM_to_lope_deeply,_ensuring_ACLRPM_is_set_around_500_RPM_keeps_the_compressor_from_short-cycling_during_idle_loping.
    .byte 0xA2                       ;Point 1

	;.org	0xc56e
ACOUT_DeltaAboveMinThrottleToCutOutAc:
    ;mpgrp AC_Control\
    ;mptbladdr 0x1166
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaAboveMinThrottleToCutOutAc
    ;mptblcname ACOUT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_ACOUT_(DeltaAboveMinThrottleToCutOutAc)_is_the_Wide_Open_Throttle_(WOT)_A/C_cutout_threshold_(stock_calibration_=_133_counts_/_~2.60V_above_learned_idle_MINTHR)._When_the_driver_pins_the_throttle_to_accelerate,_pass_a_vehicle,_or_launch_at_the_drag_strip,_the_ECU_temporarily_disengages_the_A/C_compressor_clutch._This_unloads_5_to_10_parasitic_horsepower_from_the_crankshaft,_delivering_100%_of_engine_power_to_the_front_wheels._Once_the_accelerator_pedal_is_released_back_below_ACOUT,_the_A/C_clutch_re-engages_smoothly._|_TUNER'S_GUIDE:_Passing_Power:_Stock_value_0x85_cuts_the_A/C_at_~75%_throttle._Lowering_ACOUT_to_0x60_cuts_the_A/C_sooner_(at_~50%_throttle),_giving_a_sportier,_more_responsive_feel_during_mid-throttle_passing_maneuvers.
    .byte 0x85                       ;Point 1

	;.org	0xc56f
ACCTIM_AcDelayFromStartRunTransfer:
    ;mpgrp AC_Control\
    ;mptbladdr 0x1173
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname AcDelayFromStartRunTransfer
    ;mptblcname ACCTIM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_ACCTIM_(AcDelayFromStartRunTransfer)_enforces_a_brief_delay_(stock_calibration_=_4_ticks_/_~0.4_sec)_following_engine_startup_before_the_ECU_allows_the_A/C_compressor_clutch_to_engage._When_an_engine_starts_with_the_dashboard_A/C_switch_already_ON,_engaging_the_compressor_clutch_while_the_starter_motor_is_disengaging_and_oil_pressure_is_building_would_impose_harsh_mechanical_shock_on_the_starter_drive_and_stall_the_engine._ACCTIM_holds_off_A/C_clutch_activation_until_the_engine_has_cleanly_transitioned_into_run_mode._|_TUNER'S_GUIDE:_Starter_Protection:_Retain_stock_setting._Gives_the_engine_time_to_establish_stable_combustion_before_absorbing_compressor_load.
    .byte 0x04                       ;Point 1

	;.org	0xc570
ACCRPM_DoNotAllowAcToEngageAboveThisRPM_4000:
    ;mpgrp AC_Control\
    ;mptbladdr 0x1180
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname DoNotAllowAcToEngageAboveThisRPM_4000
    ;mptblcname ACCRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_ACCRPM_(DoNotAllowAcToEngageAboveThisRPM_4000)_provides_critical_mechanical_over-speed_protection_for_the_automotive_air_conditioning_compressor_(stock_calibration_=_0x3E80_=_4,000_RPM)._Automotive_reciprocating_piston_and_rotary_vane_A/C_compressors_are_designed_for_maximum_operating_speeds_of_~4,000_to_5,000_engine_RPM._Running_an_A/C_compressor_at_6,000_RPM_causes_extreme_piston_velocities,_reed_valve_flutter,_and_catastrophic_clutch_bearing_destruction._If_engine_speed_exceeds_ACCRPM,_the_ECU_disengages_the_A/C_compressor_clutch_immediately,_re-engaging_it_only_when_engine_speed_falls_back_below_4,000_RPM._|_TUNER'S_GUIDE:_Compressor_Longevity:_Never_raise_ACCRPM_above_4,500_RPM._Spinning_a_factory_Sanden_or_Nippondenso_compressor_beyond_4,500_RPM_frequently_leads_to_thrown_compressor_belts,_seized_bearings,_or_blown_shaft_seals.
    .word 0x3E80                     ;Point 1

	;.org	0xc572
PURMAP_CannisterPurgeWhenBelowThisBaro:
    ;mpgrp Purge_Control\
    ;mptbladdr 0x118D
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname CannisterPurgeWhenBelowThisBaro
    ;mptblcname PURMAP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc OVERVIEW:_PURMAP_(CannisterPurgeWhenBelowThisBaro)_establishes_the_intake_manifold_vacuum_threshold_(stock_calibration_=_0x05_/_~1.0_inHg_vacuum_below_baro)_required_to_energize_the_evaporative_emission_canister_purge_solenoid._Evaporative_purge_pulls_fuel_vapors_from_the_charcoal_canister_directly_into_the_intake_plenum._Under_boost_or_near_wide-open_throttle,_manifold_pressure_is_positive_(boost),_which_would_blow_boost_pressure_backwards_through_the_purge_lines_into_the_gas_tank!_PURMAP_requires_manifold_pressure_to_be_strictly_below_atmospheric_pressure_(_MapValue_<_Baro_-_PURMAP_)_before_the_purge_solenoid_is_allowed_to_open._|_TUNER'S_GUIDE:_Boost_Check_Valve_Integrity:_Turbo_cars_have_one-way_check_valves_on_the_canister_purge_line,_but_PURMAP_provides_software_protection_by_shutting_the_solenoid_off_before_manifold_pressure_reaches_atmospheric_zero._Shift_Light_Mod:_When_bit_4_of_CONFIG_is_enabled,_the_Purge_Solenoid_output_is_repurposed_to_drive_an_RPM_Shift_Light!
    ;mpmapaxis y
    .byte 0x05                       ;Point 1

	;.org	0xc573
PURHYS_CannisterPurgeBaroHysteresis:
    ;mpgrp Purge_Control\
    ;mptbladdr 0x119B
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname CannisterPurgeBaroHysteresis
    ;mptblcname PURHYS
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc OVERVIEW:_PURHYS_(CannisterPurgeBaroHysteresis)_provides_a_2-count_(~0.4_inHg)_hysteresis_deadband_for_canister_purge_control._When_driving_at_light_throttle_near_atmospheric_pressure,_manifold_vacuum_naturally_fluctuates_due_to_road_bumps_and_subtle_pedal_adjustments._PURHYS_prevents_the_evaporative_purge_solenoid_from_rapidly_buzzing_or_cycling_on_and_off_as_manifold_pressure_hovers_around_the_purge_threshold._|_TUNER'S_GUIDE:_Stock_Value:_0x02._Tuning_Usage:_Retain_stock_value._Ensures_quiet,_reliable_canister_purge_valve_operation.
    ;mpmapaxis y
    .byte 0x02                       ;Point 1

	;.org	0xc574
WOTDLT_DeltaThrottleFrom_MINTHR_ToDetermineFullThrottle:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x11A9
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DeltaThrottleFrom_MINTHR_ToDetermineFullThrottle
    ;mptblcname WOTDLT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_WOTDLT_(DeltaThrottleFrom_MINTHR_ToDetermineFullThrottle)_establishes_the_throttle_threshold_for_Wide_Open_Throttle_(WOT)_power_enrichment_and_open-loop_operation._Rather_than_looking_for_a_fixed_absolute_voltage_(e.g._4.0V),_the_ECU_adds_WOTDLT_(stock_calibration_=_133_counts_/_~2.60V)_to_the_learned_closed-throttle_baseline_MINTHR._For_example,_if_learned_idle_is_0.85V,_WOT_activates_at_0.85V_+_2.60V_=_3.45V_(approximately_70%_to_75%_accelerator_pedal_travel)._Upon_crossing_this_threshold:_Closed-loop_oxygen_sensor_fuel_feedback_is_instantly_suspended._Fueling_transitions_to_the_high-output_WOTTBL_fuel_curve._Full_electronic_boost_control_targets_(WSGRPM_/_RPMBST)_are_unleashed._|_TUNER'S_GUIDE:_Earlier_Power_Enrichment:_If_you_want_WOT_fueling_and_max_boost_to_engage_earlier_in_the_pedal_travel_(e.g._at_60%_throttle_for_a_more_responsive_feel),_reduce_WOTDLT_to_0x70_(~2.2V_above_idle)._Highway_Cruise_Economy:_If_high-speed_cruising_with_a_heavy_load_or_headwind_accidentally_dips_into_WOT_enrichment_(wasting_fuel),_increase_WOTDLT_to_0x95_(~2.9V_above_idle)_so_WOT_only_triggers_when_the_pedal_is_pressed_firmly_toward_the_floor.
    .byte 0x85                       ;Point 1

	;.org	0xc575
TPDLTF_TPSDeltaOverWOTDLTToDetermineWOT:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x11B6
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname TPSDeltaOverWOTDLTToDetermineWOT
    ;mptblcname TPDLTF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_TPDLTF_(TPSDeltaOverWOTDLTToDetermineWOT)_is_a_high-speed_modifier_that_slightly_reduces_the_required_throttle_opening_threshold_(WOTDLT)_at_elevated_engine_speeds_inside_HandleO2Processing_MM._At_high_RPM,_engine_cylinder_air_ingestion_is_vastly_greater_than_at_low_speeds._A_throttle_plate_cracked_65%_open_flows_virtually_as_much_air_mass_as_100%_full_throttle._TPDLTF_subtracts_a_small_delta_from_the_required_WOT_tripwire_at_high_speeds,_ensuring_that_closed-loop_O2_fuel_trimming_disengages_earlier_at_high_engine_RPM_to_safeguard_against_lean_detonation._|_TUNER'S_GUIDE:_Stock_Value:_0x02._Tuning_Usage:_Retain_stock_setting._Works_automatically_in_tandem_with_WOTDLT.
    .byte 0x02                       ;Point 1

	;.org	0xc576
TMPLOW_OutOfRangeHotTooLowA2D:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x11C3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OutOfRangeHotTooLowA2D
    ;mptblcname TMPLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_TMPLOW_(OutOfRangeHotTooLowA2D)_defines_the_lower_electrical_voltage_limit_for_the_Engine_Coolant_Temperature_(ECT)_sensor_input._The_ECT_sensor_is_a_negative_temperature_coefficient_(NTC)_thermistor_supplied_by_an_internal_5V_pull-up_resistor_inside_the_ECU._As_coolant_temperature_rises,_sensor_resistance_drops,_causing_the_signal_voltage_to_decrease._Under_maximum_engine_operating_temperatures,_coolant_voltage_rarely_drops_below_0.6V_(~240_degF)._If_the_signal_voltage_drops_below_TMPLOW_(stock_calibration_=_0x1A_/_~0.51V),_the_ECU_detects_that_the_signal_wire_is_pinched,_shorted_to_ground,_or_the_sensor_element_has_collapsed._The_ECU_logs_Fault_Code_22,_turns_on_the_Power_Loss_light_(if_masked_in_IPLMSK),_and_substitutes_default_temperature_DEFTMP._|_TUNER'S_GUIDE:_Stock_Value:_0x1A_(~0.51V)._Diagnostics:_If_Code_22_is_present_and_live_scan_tool_data_shows_250_degF+,_inspect_the_coolant_sensor_harness_for_a_pinched_wire_touching_the_cylinder_head_or_exhaust_shield.
    .byte 0x1A                       ;Point 1

	;.org	0xc577
TMPHIG_OutOfRangeColdTooHighA2D:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x11D0
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname OutOfRangeColdTooHighA2D
    ;mptblcname TMPHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_TMPHIG_(OutOfRangeColdTooHighA2D)_establishes_the_upper_electrical_limit_for_the_Engine_Coolant_Temperature_sensor_input._Because_the_ECU's_5V_pull-up_resistor_pulls_the_circuit_up_to_5.0V_when_unplugged,_an_open_circuit,_disconnected_sensor_plug,_or_broken_signal_wire_will_cause_the_ADC_to_read_4.96V_-_5.0V_(0xFD_-_0xFF)._If_the_ADC_reading_equals_or_exceeds_TMPHIG,_the_ECU_flags_an_open-circuit_fault,_stores_Fault_Code_22,_forces_the_radiator_cooling_fan_ON_continuously_as_a_fail-safe,_and_substitutes_default_temperature_DEFTMP._|_TUNER'S_GUIDE:_Diagnostics:_If_the_radiator_cooling_fan_runs_at_full_speed_the_instant_the_key_is_turned_on,_and_Code_22_is_stored,_check_whether_the_two-pin_coolant_temperature_sensor_on_the_thermostat_housing_is_unplugged_or_has_corroded_connector_pins.
    .byte 0xFD                       ;Point 1

	;.org	0xc578
DEFTMP_DefaultEngineTemp:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x11DD
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DefaultEngineTemp
    ;mptblcname DEFTMP
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_DEFTMP_(DefaultEngineTemp)_defines_the_safe,_middle-ground_fallback_coolant_temperature_(stock_calibration_=_0x95_/_~150_degF_/_65_degC)_used_by_the_ECU_whenever_the_coolant_temperature_sensor_is_unplugged_or_shorted_(Code_22)._If_a_coolant_sensor_fails,_the_ECU_cannot_know_if_the_engine_is_freezing_cold_or_boiling_hot._Assuming_-40_degF_would_flood_the_cylinders_with_extreme_choke_enrichment,_while_assuming_220_degF_would_cause_lean_stalling_on_a_cold_morning._DEFTMP_chooses_a_moderately_warm_~150_degF_baseline_that_allows_the_vehicle_to_start,_run,_and_be_driven_safely_to_a_repair_facility_without_catalytic_converter_damage_or_engine_stalling._|_TUNER'S_GUIDE:_Stock_Value:_0x95_(~150_degF)._Limp-Home_Behavior:_When_DEFTMP_is_active,_warm-up_enrichment_curves_and_closed-loop_O2_timers_operate_under_the_assumption_of_a_lukewarm_engine.
    .byte 0x95                       ;Point 1

	;.org	0xc579
CHGLOW_ChargeTempOutOfRangeLow:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x11EA
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ChargeTempOutOfRangeLow
    ;mptblcname CHGLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_CHGLOW_(ChargeTempOutOfRangeLow)_defines_the_lower_electrical_threshold_(stock_calibration_=_0x03_/_~0.06V)_for_the_Intake_Manifold_Air_Charge_Temperature_(ACT)_sensor._Like_the_coolant_sensor,_the_charge_temperature_sensor_is_an_NTC_thermistor_whose_voltage_drops_as_manifold_air_temperature_increases._A_voltage_below_0.06V_represents_a_dead_short_to_ground_(such_as_a_wire_pinched_beneath_an_intake_manifold_runner)._When_detected,_the_ECU_stores_Fault_Code_23_and_substitutes_DEFCHG_DefaultChargeTemp_Limpin._|_TUNER'S_GUIDE:_Diagnostics:_If_Code_23_is_flagged,_check_the_wiring_harness_running_behind_the_intake_manifold_near_the_cylinder_head_for_abrasions.
    .byte 0x03                       ;Point 1

	;.org	0xc57a
CHGHIG_ChargeTempOutOfRangeHigh:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x11F7
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ChargeTempOutOfRangeHigh
    ;mptblcname CHGHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_CHGHIG_(ChargeTempOutOfRangeHigh)_sets_the_upper_electrical_threshold_(stock_calibration_=_0xFE_/_~4.98V)_for_the_Intake_Manifold_Air_Charge_Temperature_sensor._If_the_ACT_sensor_connector_is_unplugged_or_a_wire_breaks,_the_ECU's_internal_pull-up_resistor_pulls_the_circuit_up_to_5.0V._When_the_ADC_reading_reaches_or_exceeds_CHGHIG,_the_ECU_flags_an_open-circuit_condition,_stores_Fault_Code_23,_and_substitutes_default_air_charge_temperature_DEFCHG._|_TUNER'S_GUIDE:_Intercooler_Piping_/_Sensor_Relocation:_When_relocating_the_charge_temp_sensor_into_aftermarket_intercooler_plumbing,_ensure_the_sensor_body_or_harness_connector_makes_solid_contact._Disconnected_sensors_trigger_Code_23_immediately.
    .byte 0xFE                       ;Point 1

	;.org	0xc57b
DEFCHG_DefaultChargeTemp_Limpin:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1204
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname DefaultChargeTemp_Limpin
    ;mptblcname DEFCHG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_DEFCHG_(DefaultChargeTemp_Limpin)_defines_the_fail-safe_default_air_charge_temperature_(stock_calibration_=_0xAD_/_~100_degF_/_38_degC)_substituted_into_ChargeTemp_whenever_the_intake_manifold_charge_temperature_sensor_circuit_fails_(Fault_Code_23)._The_ECU_uses_charge_temperature_to_adjust_air_density_calculations_and_spark_timing_advance_(AIRTMP,_ADVCHG)._If_the_ACT_sensor_fails,_defaulting_to_extreme_cold_(-40_degF)_would_command_dangerous_timing_advance_under_boost,_while_defaulting_to_boiling_heat_(200_degF)_would_retard_spark_and_hurt_power_needlessly._DEFCHG_establishes_a_moderate_~100_degF_air_temperature_baseline_that_preserves_safe_combustion_and_normal_drivability_under_boost._|_TUNER'S_GUIDE:_Stock_Value:_0xAD_(~100_degF)._Non-Intercooled_vs_Intercooled:_On_non-intercooled_Turbo_I_cars_with_higher_baseline_manifold_temperatures,_DEFCHG_is_calibrated_slightly_warmer_(0xAD_/_~100_degF)._On_front-mount_intercooled_builds,_DEFCHG_can_remain_stock.
    .byte 0xAD                       ;Point 1

	;.org	0xc57c
AMBLOW_BattTempLowWhenHot:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1211
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BattTempLowWhenHot
    ;mptblcname AMBLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_AMBLOW_(BattTempLowWhenHot)_establishes_the_lower_electrical_threshold_(stock_calibration_=_0x02_/_~0.04V)_for_the_ambient_battery_temperature_thermistor_located_beneath_the_battery_tray._Lead-acid_batteries_require_higher_charging_voltage_in_freezing_weather_(up_to_14.8V)_and_lower_charging_voltage_in_hot_summer_weather_(13.5V)_to_prevent_boiling_off_electrolyte._The_ECU_reads_the_battery_temperature_sensor_to_adjust_its_internal_field_current_pulsewidth._If_the_sensor_wire_shorts_to_ground_(<_AMBLOW),_the_ECU_stores_Fault_Code_43_and_locks_alternator_field_control_to_a_fixed_nominal_charging_voltage._|_TUNER'S_GUIDE:_Battery_Relocation_to_Trunk:_When_relocating_the_battery_to_the_trunk_in_performance_builds,_the_under-hood_sensor_is_often_disconnected_or_damaged,_triggering_Code_43._Tuners_can_install_a_10k-ohm_resistor_across_the_harness_pins_to_simulate_70_degF_or_disable_the_fault_in_ERMSK3.
    .byte 0x02                       ;Point 1

	;.org	0xc57d
AMBHIG_BattTempHighWhenCold:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x121E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BattTempHighWhenCold
    ;mptblcname AMBHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_AMBHIG_(BattTempHighWhenCold)_establishes_the_upper_electrical_boundary_(stock_calibration_=_0xFD_/_~4.96V)_for_the_battery_temperature_thermistor._If_the_under-battery_sensor_is_unplugged,_the_internal_pull-up_resistor_pulls_the_circuit_to_5.0V_(>_AMBHIG)._The_ECU_detects_the_open_circuit,_logs_Fault_Code_43,_and_locks_the_internal_voltage_regulator_to_standard_default_13.8V_-_14.2V_charging._|_TUNER'S_GUIDE:_Diagnostics:_A_continuous_Code_43_on_a_factory_restoration_typically_indicates_a_missing_battery_tray_sensor_or_corroded_harness_plug_beneath_the_tray.
    .byte 0xFD                       ;Point 1

	;.org	0xc57e
BTLRPM_LowBatteryVoltageAtThisRpm1500:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x122B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowBatteryVoltageAtThisRpm1500
    ;mptblcname BTLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_BTLRPM_(LowBatteryVoltageAtThisRpm1500)_sets_the_minimum_engine_speed_threshold_(stock_calibration_=_0x17_/_23_*_32_=_736_RPM)_required_to_qualify_oxygen_sensor_diagnostic_routines._During_engine_cranking,_stall_recovery,_or_very_low_sub-idle_lugging,_exhaust_gas_temperature_(EGT)_drops_precipitously,_causing_unheated_oxygen_sensors_to_drop_below_their_600_degF_operating_temperature_and_stop_generating_voltage._Testing_the_O2_sensor_at_sub-idle_speeds_would_lead_to_false_Code_21_faults._BTLRPM_ensures_the_engine_is_spinning_above_736_RPM_before_diagnostic_testing_begins._|_TUNER'S_GUIDE:_Stock_Value:_0x17_(736_RPM)._Diagnostics:_Ensures_diagnostic_testing_runs_only_when_the_engine_is_sustaining_stable_running_idle.
    .byte 0x17                       ;Point 1

	;.org	0xc57f
CTLRPM_LowBatteryVoltageAtThisCoolantTemp:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1238
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname LowBatteryVoltageAtThisCoolantTemp
    ;mptblcname CTLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_CTLRPM_(LowBatteryVoltageAtThisCoolantTemp)_specifies_the_minimum_engine_operating_temperature_(stock_calibration_=_0xCD_/_~195_degF_/_90_degC)_required_before_the_ECU_will_flag_oxygen_sensor_inactivity_(Fault_Code_21)._Until_the_engine_block_and_exhaust_manifold_reach_full_operating_temperature,_unheated_O2_sensors_can_drop_out_of_closed_loop_during_prolonged_idling._CTLRPM_prevents_the_ECU_from_setting_false_O2_sensor_codes_until_the_engine_has_achieved_full,_steady-state_thermal_maturity._|_TUNER'S_GUIDE:_160_degF_/_180_degF_Thermostats:_If_running_a_160_degF_or_180_degF_thermostat,_coolant_temperature_may_never_reach_0xCD_(195_degF)!_As_a_result,_the_ECU_will_NEVER_run_O2_sensor_functional_diagnostics,_silently_suppressing_Code_21._If_you_want_O2_diagnostics_active_with_cooler_thermostats,_lower_CTLRPM_to_0xB0_(170_degF).
    .byte 0xCD                       ;Point 1

	;.org	0xc580
O2MNRT_MiniumRunTimeForO2SensorDiag:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1245
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MiniumRunTimeForO2SensorDiag
    ;mptblcname O2MNRT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_O2MNRT_(MiniumRunTimeForO2SensorDiag)_defines_the_cumulative_running_time_delay_(stock_calibration_=_0xFF_/_255_ticks_/_~3.5_minutes)_that_must_elapse_after_engine_start_before_O2_sensor_functional_testing_is_permitted._Even_on_a_warm_restart,_exhaust_gas_velocity_and_sensor_heater_stabilization_require_several_minutes_of_continuous_engine_operation_before_an_O2_sensor_reliably_cycles_between_rich_and_lean._O2MNRT_guarantees_the_sensor_has_had_ample_time_to_stabilize_before_evaluating_switching_performance._|_TUNER'S_GUIDE:_Stock_Setting:_0xFF_(maximum_8-bit_timer_span)._Diagnostics:_Explains_why_Fault_Code_21_never_sets_immediately_upon_startup,_the_vehicle_must_be_driven_continuously_for_several_minutes_before_the_monitor_runs.
    .byte 0xFF                       ;Point 1

	;.org	0xc581
ERRRPM_RPMLimitforErrorCodeSetting:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1252
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname RPMLimitforErrorCodeSetting
    ;mptblcname ERRRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_ERRRPM_(RPMLimitforErrorCodeSetting)_provides_an_RPM_offset_(stock_calibration_=_0x0C_/_12_*_8_=_+96_RPM)_added_to_TargetIdleSpeed_HB_to_define_the_boundary_between_curb_idle_and_off-idle_driving_diagnostics_inside_VerifyOperationOfO2SensorAnd._Certain_diagnostic_tests_(such_as_vehicle_speed_sensor_operation_and_dynamic_MAP_rationality)_must_only_run_when_the_vehicle_is_being_actively_driven,_not_while_idling_at_a_red_light._ERRRPM_establishes_the_engine_speed_threshold_above_which_the_ECU_recognizes_the_vehicle_is_operating_off-idle._|_TUNER'S_GUIDE:_Stock_Value:_0x0C_(+96_RPM)._Tuner_Usage:_Works_automatically_with_whatever_target_idle_speed_is_configured_in_AISPN.
    .byte 0x0C                       ;Point 1

	;.org	0xc582
ERRMPH_MPHLimitforErrorCodeSetting:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x125F
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MPHLimitforErrorCodeSetting
    ;mptblcname ERRMPH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_ERRMPH_(MPHLimitforErrorCodeSetting)_defines_the_minimum_vehicle_cruising_speed_(stock_calibration_=_18_MPH_/_0x12)_required_to_evaluate_dynamic_vehicle_sensor_diagnostics._For_example,_to_test_whether_the_vehicle_speed_sensor_(Distance_Sensor_/_VSS)_is_functional,_the_ECU_verifies_whether_the_vehicle_is_operating_at_cruising_RPM_and_load._If_the_vehicle_is_driven_under_cruising_conditions_and_the_distance_sensor_reports_0_MPH,_the_ECU_flags_Fault_Code_15_('No_vehicle_speed_sensor_signal_detected')._ERRMPH_ensures_this_test_is_only_evaluated_once_road_speed_has_safely_exceeded_18_MPH._|_TUNER'S_GUIDE:_Code_15_Diagnostics:_If_a_digital_dash_conversion_or_broken_speedometer_cable_causes_Code_15,_the_code_is_only_logged_after_exceeding_18_MPH.
    .byte 0x12                       ;Point 1

	;.org	0xc583
ERRKON_KeyOnTimeLimitforErrorCodeSetting:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x126C
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname KeyOnTimeLimitforErrorCodeSetting
    ;mptblcname ERRKON
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_ERRKON_(KeyOnTimeLimitforErrorCodeSetting)_enforces_a_key-on_delay_period_(stock_calibration_=_128_ticks_/_~1.8_minutes)_before_the_ECU_permits_driving-mode_diagnostic_monitors_to_log_fault_codes_into_memory._Ensures_that_transient_battery_voltage_dips_during_starting_or_rapid_ignition_cycling_do_not_cause_erroneous_trouble_codes_to_latch_into_memory._|_TUNER'S_GUIDE:_Stock_Value:_0x80_(~1.8_minutes)._Diagnostics:_Guarantees_that_diagnostic_fault_codes_are_only_set_after_the_vehicle_has_been_running_steadily.
    .byte 0x80                       ;Point 1

	;.org	0xc584
THRLOW_ThrottleLowerLimit:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1279
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleLowerLimit
    ;mptblcname THRLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_THRLOW_(ThrottleLowerLimit)_sets_the_absolute_minimum_valid_electrical_voltage_(stock_calibration_=_0x08_/_~0.156V)_for_the_Throttle_Position_Sensor_(TPS)_signal_input._Under_normal_mechanical_adjustment,_a_healthy_closed-throttle_TPS_outputs_between_0.60V_and_0.95V._A_reading_below_0.16V_indicates_that_the_signal_wire_is_severed,_shorted_directly_to_sensor_ground,_or_the_internal_wiper_arm_has_broken_off._When_TpsVolts_<_THRLOW,_the_ECU_immediately_logs_Fault_Code_24_(ThrowCriticalError),_illuminates_the_Check_Engine_light,_forces_MINTHR_to_a_default_value_(0x40),_and_switches_to_Alpha-N_limp-home_mode_based_on_manifold_pressure_(MPTHR)._|_TUNER'S_GUIDE:_Throttle_Body_Swaps:_When_installing_an_aftermarket_throttle_body,_use_a_scan_tool_or_voltmeter_to_confirm_that_closed-throttle_TPS_voltage_rests_safely_between_0.65V_and_0.90V,_well_above_THRLOW_(0.16V)._Code_24_Limp-Home_Mode:_When_Code_24_is_active,_the_ECU_ignores_the_broken_TPS_and_calculates_synthetic_throttle_angle_from_MAP_pressure_(MPTHR_/_LMPINN).
    .byte 0x08                       ;Point 1

	;.org	0xc585
THRHIG_ThrottleUpperLimit:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1286
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname ThrottleUpperLimit
    ;mptblcname THRHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_THRHIG_(ThrottleUpperLimit)_sets_the_maximum_valid_electrical_ceiling_(stock_calibration_=_0xF0_/_~4.70V)_for_the_Throttle_Position_Sensor_signal._Even_at_100%_wide_open_throttle,_physical_throttle_linkage_geometry_and_sensor_potentiometer_tracks_rarely_exceed_4.2V_-_4.5V._If_the_sensor_ground_wire_breaks_or_corrodes,_the_ECU's_internal_pull-up_resistor_or_reference_rail_pulls_the_TPS_signal_pin_up_to_4.8V_-_5.0V_(>_THRHIG)._The_ECU_detects_this_out-of-range_condition,_logs_Fault_Code_24,_and_activates_limp-home_MAP_substitution._|_TUNER'S_GUIDE:_Aftermarket_High-Angle_Sensors:_Ensure_wide-open_throttle_voltage_does_not_hit_or_exceed_4.70V_on_custom_throttle_quadrant_linkages.
    .byte 0xF0                       ;Point 1

	;.org	0xc586
MPTHR_MapSwitchPointForFullThrottleOrIdle:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1293
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname MapSwitchPointForFullThrottleOrIdle
    ;mptblcname MPTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc OVERVIEW:_MPTHR_(MapSwitchPointForFullThrottleOrIdle)_is_an_emergency_fail-safe_threshold_(stock_calibration_=_0x68_/_~83_kPa_/_5_inHg_vacuum)_utilized_when_the_Throttle_Position_Sensor_has_suffered_an_electrical_failure_(Code_24)._When_the_TPS_is_dead,_the_ECU_cannot_read_accelerator_pedal_position._To_ensure_the_driver_can_still_accelerate_safely_and_merge_into_traffic_without_leaning_out_the_engine,_the_ECU_monitors_the_MAP_sensor._If_the_driver_steps_on_the_gas,_manifold_vacuum_drops_and_MAP_rises_above_MPTHR._The_ECU_immediately_infers_that_the_driver_is_demanding_full_power,_triggers_WOT_mode_(adda_WOTDLT),_and_activates_full_power_enrichment_fueling._|_TUNER'S_GUIDE:_Stock_Value:_0x68_(~83_kPa)._Brilliant_Chrysler_Fail-Safe:_Demonstrates_the_extraordinary_depth_of_Chrysler's_1980s_embedded_engine_control_software,_a_broken_TPS_does_not_strand_the_vehicle_or_prevent_turbo_boost.
    ;mpmapaxis y
    .byte 0x68                       ;Point 1

	;.org	0xc587
MAXCDH_MaximumCounterDistrubtorHalfwayforErrorCodeReset:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x12A1
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MaximumCounterDistrubtorHalfwayforErrorCodeReset
    ;mptblcname MAXCDH
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_MAXCDH_(MaximumCounterDistrubtorHalfwayforErrorCodeReset)_defines_the_ignition_distributor_pulse_counter_ceiling_(stock_calibration_=_16_pulses_/_0x10)_evaluated_inside_Throttle_MM._Chrysler's_OBD_system_features_an_automated_self-healing_/_self-clearing_mechanism:_if_a_transient_fault_(such_as_a_temporary_MAP_or_TPS_glitch)_resolves_itself_and_passes_multiple_qualification_tests_while_driving,_the_ECU_decrements_the_fault_counter_and_eventually_clears_the_error_code_without_requiring_a_scan_tool._MAXCDH_validates_that_the_distributor_pickup_is_providing_stable_timing_pulses_before_permitting_self-clear_processing._|_TUNER'S_GUIDE:_Stock_Setting:_0x10._Diagnostic_Self-Reset:_Explains_how_Chrysler_ECUs_automatically_clear_old_trouble_codes_after_a_fixed_number_of_successful_fault-free_driving_trips.
    .byte 0x10                       ;Point 1

	;.org	0xc588
DLTTHR_MinDeltaThrottleforErrorCodeReset:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x12AE
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinDeltaThrottleforErrorCodeReset
    ;mptblcname DLTTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_DLTTHR_(MinDeltaThrottleforErrorCodeReset)_specifies_the_minimum_dynamic_throttle_voltage_sweep_(stock_calibration_=_16_counts_/_~0.31V)_required_to_validate_sensor_health_during_automated_error_code_clearing._To_clear_a_previously_logged_sensor_fault,_the_ECU_demands_proof_that_the_sensor_is_actively_responding_to_driver_inputs_rather_than_sitting_stuck_at_a_static_voltage._DLTTHR_requires_the_throttle_to_open_by_at_least_~0.31V_above_MINTHR_before_the_ECU_will_reset_transient_MAP_or_throttle_fault_codes._|_TUNER'S_GUIDE:_Stock_Value:_0x10_(~0.31V)._Clearing_Pending_Codes:_Depressing_the_throttle_smoothly_past_15-20%_during_normal_driving_satisfies_DLTTHR,_allowing_pending_codes_to_self-clear.
    .byte 0x10                       ;Point 1

	;.org	0xc589
MAXERT_MaximumEngineRunningTimeforErrorCodeReset:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x12BB
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname MaximumEngineRunningTimeforErrorCodeReset
    ;mptblcname MAXERT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_MAXERT_(MaximumEngineRunningTimeforErrorCodeReset)_defines_the_45-second_operational_time_window_(stock_calibration_=_0x002D_=_45_seconds)_following_engine_start_during_which_the_ECU_evaluates_automated_error_code_reset_conditions._Chrysler_engineers_designed_the_self-healing_error_reset_routine_to_run_early_in_the_drive_cycle._If_a_sensor_passed_all_initial_electrical_and_mechanical_tests_within_the_first_45_seconds_of_engine_operation,_the_fault_counters_are_decremented,_allowing_the_ECU_to_extinguish_dashboard_lights_promptly_after_a_repair._|_TUNER'S_GUIDE:_Stock_Value:_0x002D_(45_seconds)._16-Bit_Word:_Stored_as_a_2-byte_word_in_ROM.
    .word 0x002D                     ;Point 1

	;.org	0xc58b
MAPERR_MinMAPforErrorCodeReset:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x12C8
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MinMAPforErrorCodeReset
    ;mptblcname MAPERR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_MAPERR_(MinMAPforErrorCodeReset)_specifies_the_minimum_dynamic_manifold_pressure_change_(stock_calibration_=_2_ADC_counts_/_~1.6_kPa)_required_during_the_automated_error_code_self-clearing_routine_in_Throttle_MM._To_automatically_clear_a_previously_stored_MAP_sensor_fault_(Code_14)_without_a_diagnostic_scan_tool,_the_ECU_requires_proof_that_manifold_pressure_actually_moves_when_the_throttle_is_opened._If_the_difference_between_consecutive_MAP_readings_exceeds_MAPERR_during_an_off-idle_throttle_transition,_the_ECU_confirms_that_the_sensor_diaphragm_is_responsive_and_healthy,_allowing_the_fault_counters_to_clear._|_TUNER'S_GUIDE:_Stock_Value:_0x02._Diagnostic_Self-Reset:_Explains_why_blipping_the_throttle_during_a_road_test_often_turns_off_a_pending_Check_Engine_light_after_fixing_a_disconnected_vacuum_line.
    .byte 0x02                       ;Point 1

	;.org	0xc58c
MAPLOW_MapSensorLowerLimit:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x12D5
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapSensorLowerLimit
    ;mptblcname MAPLOW
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_MAPLOW_(MapSensorLowerLimit)_defines_the_absolute_minimum_electrical_voltage_boundary_(stock_calibration_=_0x01_/_~0.02V)_for_the_Manifold_Absolute_Pressure_(MAP)_sensor_input._Under_physical_driving_conditions,_even_full_trailing-throttle_deceleration_at_6,000_RPM_cannot_pull_manifold_absolute_pressure_below_~10-15_kPa_(~0.25V)._If_the_MAP_signal_pin_reads_below_0.02V,_the_ECU_detects_an_electrical_short_to_sensor_ground_or_a_broken_5V_reference_wire._When_MAPVolts_<_MAPLOW,_the_ECU_flags_Fault_Code_14,_sets_the_MapAppearsToBeFaulty_bit,_illuminates_the_Power_Loss_light,_and_switches_to_Alpha-N_limp-home_mode_(LMPINN)_using_throttle_angle._|_TUNER'S_GUIDE:_Code_14_Diagnosis:_If_Code_14_is_present_and_scan_tool_reads_0.0V,_inspect_the_3-pin_MAP_sensor_connector_for_water_intrusion,_corrosion,_or_a_broken_5V_supply_wire.
    .byte 0x01                       ;Point 1

	;.org	0xc58d
MAPHIG_MapSensorUpperLimit:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x12E2
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname MapSensorUpperLimit
    ;mptblcname MAPHIG
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_MAPHIG_(MapSensorUpperLimit)_establishes_the_maximum_valid_electrical_ceiling_(stock_calibration_=_0xFC_/_~4.94V)_for_the_MAP_sensor._If_the_3-wire_MAP_sensor_connector_becomes_unplugged_or_its_ground_wire_is_severed,_the_ECU's_internal_input_circuitry_pulls_the_signal_up_to_5.0V_(>_MAPHIG)._When_detected_in_VerifyOperationOfMapSensor_MM,_the_ECU_flags_Fault_Code_14._Additionally,_MAPHIG_is_referenced_inside_ControlEngineCutout_MM_as_a_secondary_overboost/sensor_limit_ceiling._|_TUNER'S_GUIDE:_3-Bar_MAP_Sensor_Calibration:_When_installing_a_3-Bar_MAP_sensor,_ensure_wiring_polarity_is_correct._If_the_sensor_ground_pin_is_improperly_pinned,_signal_voltage_will_float_at_5.0V,_instantly_triggering_Code_14_and_engine_cutout.
    .byte 0xFC                       ;Point 1

	;.org	0xc58e
DFTOC2_SomeKindOfDefaultValueForOCR2:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x12EF
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname SomeKindOfDefaultValueForOCR2
    ;mptblcname DFTOC2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_DFTOC2_(SomeKindOfDefaultValueForOCR2)_is_a_16-bit_hardware_timer_reload_constant_(stock_calibration_=_0x07D0_=_2,000_clock_cycles_/_~2.0_milliseconds)_loaded_into_the_Motorola_6803_CPU's_internal_Output_Compare_Register_2_(OCR2)._The_6803_MCU_utilizes_internal_hardware_timer_match_interrupts_to_generate_precise,_jitter-free_software_clocks_for_injector_pulsewidth_scheduling,_ignition_coil_dwell_charging,_and_analog-to-digital_converter_multiplexing._DFTOC2_reloads_the_hardware_compare_match_register_during_timer_interrupt_service_routine_HandleOtherTimerInterrupts._|_TUNER'S_GUIDE:_Fixed_Architecture_Constant:_DO_NOT_MODIFY._Changing_DFTOC2_alters_the_master_CPU_hardware_timer_interrupt_cadence,_disrupting_injector_pulse_timing_and_ignition_dwell_accuracy_globally.
    .word 0x07D0                     ;Point 1

; 	;.org	0xc590
L3634:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x12FC
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname L3634
    ;mptblcname L3634
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_L3634_is_a_preserved_Chrysler_engineering_calibration_constant_residing_at_address_$12FC_in_the_setup_and_configuration_table_structure._Maintained_across_Chrysler_2.2L/2.5L_Turbo_Logic_Module_binaries_to_preserve_exact_byte-for-byte_binary_offset_alignment_between_calibration_tables_and_executable_machine_code_routines._|_TUNER'S_GUIDE:_Tuning_Usage:_Retain_stock_factory_value_(0x0F).
    .byte 0x0F                       ;Point 1

	;.org	0xc591
BF80PL_BF80PowerLossLightMask:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1309
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname BF80PowerLossLightMask
    ;mptblcname BF80PL
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc OVERVIEW:_BF80PL_(BF80PowerLossLightMask)_is_an_8-bit_diagnostic_trigger_mask_(stock_calibration_=_0xDB_/_binary_11011011)_evaluated_inside_WorkWithPowerLossLight_MM._BitFlags_80_is_the_ECU's_primary_runtime_status_register_tracking_limp-home_modes,_sensor_failure_flags,_and_system_error_states._Inside_WorkWithPowerLossLight_MM,_the_ECU_executes_a_bitwise_test:_bita_BF80PL_BF80PowerLossLightMask._If_any_of_the_masked_error_bits_are_active,_the_routine_branches_directly_to_LD4A1_and_energizes_the_dashboard_Power_Loss_/_Check_Engine_warning_light_driver._|_TUNER'S_GUIDE:_Suppressing_Nuisance_CEL_Lights:_Tuners_creating_custom_engine_swaps_or_standalone_configurations_can_clear_specific_bits_in_BF80PL_to_prevent_secondary_status_flags_from_turning_on_the_Check_Engine_light.
    .byte 0xDB                       ;Point 1

	;.org	0xc592
FUELTR_FuelMonitorConversionFactor:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1316
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname FuelMonitorConversionFactor
    ;mptblcname FUELTR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_FUELTR_(FuelMonitorConversionFactor)_is_a_16-bit_calibration_constant_(stock_calibration_=_0x0311_=_785_decimal)_that_calibrates_the_fuel_consumption_output_signal_sent_from_the_ECU_to_the_vehicle's_dashboard_Electronic_Navigator_/_12-button_trip_computer_(often_factory_equipped_in_Daytona,_Lancer,_LeBaron,_and_Laser_models)._The_ECU_monitors_injector_pulsewidth_duration._Each_time_cumulative_injector_on-time_integrates_to_equal_FUELTR,_the_ECU_toggles_Port_B_bit_6_(Z83_PortBdata,_line_6283),_sending_a_discrete_electrical_pulse_to_the_trip_computer._The_overhead_console_uses_these_pulses,_combined_with_vehicle_distance_sensor_pulses,_to_calculate_live_Instant_MPG,_Average_MPG,_and_Gallons_Consumed._|_TUNER'S_GUIDE:_Upgraded_Injectors_(e.g._+20%,_+40%,_or_52_lb/hr):_When_installing_larger_fuel_injectors,_the_trip_computer_will_display_absurdly_optimistic_fuel_economy_(e.g._50+_MPG)_because_shorter_pulsewidths_are_required_to_deliver_the_same_fuel_mass._To_recalibrate_the_factory_trip_computer_for_larger_injectors,_increase_FUELTR_proportionally!_Formula:_New_FUELTR_=_Stock_FUELTR_*_((New_Flow_Rate_/_Stock_Flow_Rate))_._For_example,_installing_+40%_injectors_(_1.40*_flow)_requires_increasing_FUELTR_by_40%_(_785_*_1.40_=_1099_/_0x044B)._This_restores_100%_factory-accurate_MPG_readouts_on_the_dashboard!
    ;mpinjscale word
    .word 0x0311                     ;Point 1

	;.org	0xc594

	;.org	0xc5a0
TMPTL1_TempForColdScaleFromA2D:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x1326
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempForColdScaleFromA2D
    ;mptblcname TMPTL1
    ;mpxaxis raw 0 255 scale
    ;mpyaxis Coolant_Temperature -200 260 F
    ;mptbldesc OVERVIEW:_TMPTL1_(TempForColdScaleFromA2D)_is_the_primary_non-linear_analog_transfer_lookup_table_that_translates_raw_8-bit_ADC_voltages_from_the_Engine_Coolant_Temperature_(ECT)_sensor_into_engineering_temperature_units_when_operating_on_the_cold_temperature_range._Automotive_coolant_thermistors_have_severe_exponential_resistance_curves_(hundreds_of_thousands_of_ohms_when_freezing,_dropping_to_a_few_hundred_ohms_when_boiling)._An_8-bit_ADC_measuring_a_single_resistor_divider_would_lose_all_resolution_at_either_cold_or_hot_extremes._Chrysler_solved_this_by_creating_a_switched_dual-bias_circuit:_On_cold_engines,_the_ECU_engages_a_high-range_bias_resistor_on_Port_1_(bitb_#0x08)_and_references_TMPTL1._When_the_engine_warms_up_past_the_crossover_point,_the_ECU_toggles_the_bias_resistor_(ToggleCTSbias)_and_transitions_to_TMPTL2._This_provides_exceptional_+/-_1_degF_measurement_precision_across_the_entire_span_from_-40_degF_to_+260_degF._|_TUNER'S_GUIDE:_Sensor_Swaps_/_Custom_Sensors:_If_swapping_to_an_aftermarket_or_GM_coolant_temperature_sensor_with_a_different_thermistor_resistance_curve,_TMPTL1_and_TMPTL2_must_be_recalibrated_to_match_the_new_sensor's_voltage_output._Factory_Sensor:_Leave_stock_for_factory_Chrysler_2-pin_coolant_sensors.
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0xC9, 0xFF, 0xA2     ;Point 1
    .byte 0xD7, 0x7A, 0xFF, 0x0D     ;Point 2
    .byte 0xFF, 0x54                 ;Point 3

	;.org	0xc5ab
TMPTL2_TempForHotScaleA2D:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x1336
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempForHotScaleA2D
    ;mptblcname TMPTL2
    ;mpxaxis raw 0 255 scale
    ;mpyaxis Coolant_Temperature -200 260 F
    ;mptbldesc OVERVIEW:_TMPTL2_(TempForHotScaleA2D)_is_the_companion_transfer_lookup_table_to_TMPTL1,_dedicated_to_measuring_engine_coolant_temperature_during_normal_warm_running_and_high-temperature_conditions_(140_degF_to_260_degF+)._Once_the_engine_warms_past_the_crossover_threshold,_the_ECU_toggles_the_hardware_bias_resistor_on_Port_1,_expanding_the_hot-temperature_ADC_span_across_full_8-bit_resolution._TMPTL2_translates_these_warm_ADC_voltages_into_the_final_runtime_variable_CoolantTemp_used_by_spark_advance,_fuel_enrichment,_and_radiator_cooling_fan_control._|_TUNER'S_GUIDE:_Radiator_Fan_&_Overheat_Accuracy:_Because_normal_operating_temperature_(180_degF_-_210_degF)_resides_entirely_on_TMPTL2,_accurate_calibration_of_this_curve_is_vital_for_proper_radiator_fan_cycling_(FANTM1,_FANTM2)_and_hot_spark_retard_(HOTSPK).
    .byte 0x02                       ;Number of points in table
    .byte 0x40, 0xFF, 0xFF, 0x72     ;Point 1
    .byte 0xFF, 0x95                 ;Point 2

	;.org	0xc5b2
CHGTL1_TempForChargeTempA2D:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x1345
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname TempForChargeTempA2D
    ;mptblcname CHGTL1
    ;mpxaxis raw 0 255 scale
    ;mpyaxis Coolant_Temperature -200 260 F
    ;mptbldesc OVERVIEW:_CHGTL1_(TempForChargeTempA2D)_is_the_4-point_2D_transfer_curve_that_converts_analog_voltage_from_the_Intake_Manifold_Air_Charge_Temperature_(ACT)_sensor_into_calibrated_temperature_units_(ChargeTemp)._The_charge_temperature_sensor_measures_the_density_of_air_compressed_by_the_turbocharger_entering_the_intake_plenum._CHGTL1_maps_the_non-linear_thermistor_curve_across_extreme_winter_cold_(-40_degF)_to_extreme_intercooler_heat-soak_(+250_degF)._The_resulting_ChargeTemp_value_directly_scales_air_density_calculations_for_fuel_injection_and_trims_ignition_advance_(AIRTMP,_ADVCHG)._|_TUNER'S_GUIDE:_Aftermarket_Fast-Response_Thermistors:_Standard_factory_Chrysler_ACT_sensors_are_brass-encapsulated_and_have_significant_thermal_inertia._Many_tuners_upgrade_to_open-element_GM_or_Bosch_air_temp_sensors_for_instant_boost_temperature_tracking._If_swapping_to_a_non-Chrysler_sensor,_CHGTL1_must_be_revised_to_match_the_new_sensor's_calibration_curve.
    .byte 0x04                       ;Number of points in table
    .byte 0x0E, 0xFF, 0xFE, 0x43     ;Point 1
    .byte 0x29, 0xD0, 0xFF, 0x8D     ;Point 2
    .byte 0xE3, 0x7C, 0xFE, 0x70     ;Point 3
    .byte 0xFA, 0x58                 ;Point 4

	;.org	0xc5c1
LMPINN_LimpinTableForMapFromThrottle:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x1356
    ;mptbltype 10
    ;mpsubtype 1
    ;mptbllname LimpinTableForMapFromThrottle
    ;mptblcname LMPINN
    ;mpxaxis TPS 0 255 tps
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc OVERVIEW:_LMPINN_(LimpinTableForMapFromThrottle)_is_Chrysler's_legendary_emergency_Alpha-N_limp-home_table._If_the_Manifold_Absolute_Pressure_(MAP)_sensor_is_destroyed,_unplugged,_or_blown_off_its_vacuum_nipple_under_boost,_a_speed-density_engine_management_system_would_ordinarily_stall_and_strand_the_vehicle._Chrysler_engineers_anticipated_this_failure_mode:_when_Fault_Code_14_is_active,_subroutine_SimulateMapReadingFromTps_engages_LMPINN._This_table_models_the_physical_relationship_between_throttle_opening_angle_and_engine_intake_airflow,_generating_a_synthetic_manifold_pressure_value_that_substitutes_for_the_missing_MAP_sensor._This_allows_the_driver_to_drive_the_vehicle_normally_without_stalling._|_TUNER'S_GUIDE:_Limp-Home_Drivability_with_Blown_MAP_Hoses:_If_a_silicone_vacuum_hose_blows_off_the_MAP_sensor_at_the_racetrack,_LMPINN_allows_you_to_drive_the_car_back_to_the_pits_under_its_own_power._Large_Throttle_Bodies:_If_running_an_oversized_58mm_throttle_body,_raising_the_lower_points_of_LMPINN_provides_smoother_limp-home_off-idle_recovery.
    ;mpmapaxis y
    .byte 0x00                   ;Point 1
    .word 0x0000, 0x0250
    .byte 0x10                   ;Point 2
    .word 0x0025, 0x01DB
    .byte 0x17                   ;Point 3
    .word 0x0032, 0x015D
    .byte 0x22                   ;Point 4
    .word 0x0041, 0x00F9
    .byte 0x45                   ;Point 5
    .word 0x0063, 0x0000
    .byte 0xFF

	;.org	0xc5db
MPLMOF_OffsetForCalcMapInMapLimpin:
    ;mpgrp Setup_-_On-Board_Diagnostics\
    ;mptbladdr 0x136E
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname OffsetForCalcMapInMapLimpin
    ;mptblcname MPLMOF
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc OVERVIEW:_MPLMOF_(OffsetForCalcMapInMapLimpin)_defines_the_baseline_manifold_pressure_offset_(stock_calibration_=_0x20_/_~25_kPa_/_~22_inHg_vacuum)_added_to_the_synthetic_pressure_looked_up_from_LMPINN_during_MAP_sensor_failure_mode._At_closed_throttle,_an_engine_does_not_operate_at_0_kPa_absolute_pressure,_it_pulls_steady_idle_vacuum_(~25_to_30_kPa)._MPLMOF_provides_this_baseline_vacuum_floor_so_that_when_the_throttle_is_fully_closed,_the_synthetic_MAP_value_accurately_reflects_real_engine_idle_depression._|_TUNER'S_GUIDE:_Stock_Value:_0x20_(~25_kPa)._Camshaft_Tuning:_If_running_a_camshaft_that_idles_with_less_vacuum_(e.g._45_kPa_/_16_inHg),_raising_MPLMOF_to_0x30_(~38_kPa)_prevents_the_engine_from_idling_overly_lean_if_the_MAP_sensor_fails.
    ;mpmapaxis y
    .byte 0x20                       ;Point 1

	;.org	0xc5dc
MAPMULT_ScaleMAPVoltsToPresMultiplyConst:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x137C
    ;mptbltype 8
    ;mpsubtype 1
    ;mptbllname ScaleMAPVoltsToPresMultiplyConst
    ;mptblcname MAPMULT
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc Map_Scale_multiplier._This_is_the_slope_constant_for_the_MAP_sensor_transfer_function._#07_is_the_original_Mopar_2-bar_constant._#09_for_the_S60_3-bar_sensor._The_GM_or_MSD_3-Bar_sensors_may_need_these_values_changed_for_accuracy.____OVERVIEW:_MAPMULT_(ScaleMAPVoltsToPresMultiplyConst)_is_the_foundational_slope_multiplier_in_the_mathematical_transfer_function_that_converts_analog_MAP_sensor_voltage_(MapVolts)_into_calibrated_internal_pressure_units_(MapValue)._In_the_factory_Chrysler_6803_assembly_routine_ConvertMAPVoltsToValue,_the_ECU_executes:_Pressure_=_(MAPVolts_*_MAPMULT)_+_MAPVolts_+_MAPADD_Stock_Mopar_2-Bar_Sensor:_Calibrated_to_0x07._With_a_2-Bar_sensor,_a_5.0V_span_corresponds_to_0_-_208_kPa_(~14.7_psi_boost)._Mopar_Super_60_/_3-Bar_Sensor:_When_upgrading_to_a_3-Bar_sensor_(measuring_up_to_300_kPa_/_~29_psi_boost),_the_sensor_output_slope_is_shallower_(_1.5*_more_pressure_per_volt)._Setting_MAPMULT_to_0x09_(in_conjunction_with_MAPADD_=_0x0700)_recalibrates_the_entire_ECU_to_read_3-Bar_boost_accurately_without_altering_underlying_table_fuel/spark_axes!_|_TUNER'S_GUIDE:_3-Bar_MAP_Sensor_Conversion_Guide:_For_Mopar_2-Bar_(Stock):_Set_MAPMULT_=_0x07,_MAPADD_=_0x0361._For_Mopar_Super_60_3-Bar:_Set_MAPMULT_=_0x09,_MAPADD_=_0x0700._For_GM_/_MSD_3-Bar_(12223861_/_16040749):_May_require_fine-tuning_MAPADD_to_0x06C0_-_0x0720_depending_on_sensor_manufacturer_offset_tolerances._MPTuning_Integration:_In_MPTune,_selecting_the_'3-Bar_MAP'_option_automatically_updates_MAPMULT_and_MAPADD_to_their_correct_values.
    ;mpchoices 1.0_Bar 07 1.5_Bar 07 2.0_Bar 07 2.5_Bar 08 3.0_Bar 09 3.5_Bar 09 4.0_Bar 09 4.5_Bar 09
    ;mpmapaxis b
    .byte 0x07                       ;Point 1

	;.org	0xc5dd
MAPADD_ScaleMAPVoltsToPresAddConst:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x138B
    ;mptbltype 8
    ;mpsubtype 1
    ;mptbllname ScaleMAPVoltsToPresAddConst
    ;mptblcname MAPADD
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc Scale_MAP_Volts_to_MAP_add_constant:_This_is_the_offset_constant_for_the_MAP_sensor_transfer_function._#0361_is_the_original_Mopar_2-bar_constant._#0700_for_the_S60_3-bar_sensor._The_GM_or_MSD_3-Bar_sensors_may_need_these_values_changed_for_accuracy.____OVERVIEW:_MAPADD_(ScaleMAPVoltsToPresAddConst)_is_the_16-bit_zero-offset_/_intercept_constant_added_to_the_scaled_product_of_MAPVolts_*_MAPMULT_inside_ConvertMAPVoltsToValue._Pressure_sensors_output_a_small_non-zero_offset_voltage_at_absolute_zero_vacuum_(typically_0.2V_to_0.4V)._MAPADD_provides_the_mathematical_intercept_calibration_that_aligns_zero_manifold_absolute_pressure_to_the_baseline_of_the_ECU's_internal_lookup_tables:_Stock_Mopar_2-Bar:_.word_0x0361_(865_decimal)._Mopar_Super_60_/_3-Bar:_.word_0x0700_(1792_decimal)._Together_with_MAPMULT,_MAPADD_forms_the_classic_linear_equation_y_=_mx_+_b_for_manifold_pressure_sensing._|_TUNER'S_GUIDE:_Fine-Tuning_MAP_Accuracy:_When_verifying_MAP_sensor_calibration_with_a_hand_vacuum_pump_and_MPTune_live_data_display:_If_atmospheric_pressure_reads_29.9_inHg_but_live_scan_data_reads_28.5_inHg_(offset_error_across_all_points),_trim_MAPADD_upward_or_downward_by_a_few_counts_to_zero_the_sensor_perfectly._If_the_slope_is_incorrect_between_atmospheric_and_full_boost,_adjust_MAPMULT.
    ;mpchoices 1.0_Bar 0361 1.5_Bar 0361 2.0_Bar 0361 2.5_Bar 0700 3.0_Bar 0700 3.5_Bar 0700 4.0_Bar 0700 4.5_Bar 0700
    ;mpmapaxis w
    .word 0x0361                     ;Point 1

	;.org	0xc5df
VACREG_CruiseControlVacRegularGainGurve_FromDeltaSpeed:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x139A
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlVacRegularGainGurve_FromDeltaSpeed
    ;mptblcname VACREG
    ;mpxaxis Delta_Speed 0 127 mph
    ;mpyaxis AccRate 0 5 mph/sec
    ;mptbldesc OVERVIEW:_VACREG_(CruiseControlVacRegularGainGurve_FromDeltaSpeed)_defines_the_primary_proportional_vacuum_servo_gain_curve_used_by_the_cruise_control_system_under_steady-state_cruising._When_road_speed_falls_slightly_below_the_target_set_speed_(e.g._encountering_a_moderate_highway_grade_or_headwind),_the_ECU_calculates_the_delta_speed_error_(Target_Speed_-_Current_Speed)._VACREG_maps_this_speed_deficit_into_a_proportional_vacuum_solenoid_pulse_width._Applying_vacuum_draws_on_the_throttle_actuator_diaphragm,_opening_the_throttle_blade_smoothly_to_restore_the_target_cruising_speed_without_hunting_or_surging._|_TUNER'S_GUIDE:_Speed_Droop_on_Hills:_If_the_vehicle_loses_2-4_MPH_on_highway_hills_before_recovering,_increase_the_upper_points_of_VACREG_to_command_more_aggressive_vacuum_pull._Throttle_Surging_/_Hunting:_If_the_cruise_control_oscillates_or_pulses_the_accelerator_pedal_while_driving_on_flat_roads,_reduce_the_slope_of_VACREG_around_zero_delta_speed.
    .byte 0x05                       ;Number of points in table
    .byte 0x00, 0x00, 0x00, 0x60     ;Point 1
    .byte 0x10, 0x06, 0x00, 0x20     ;Point 2
    .byte 0x40, 0x0C, 0x00, 0x10     ;Point 3
    .byte 0x80, 0x10, 0x00, 0x11     ;Point 4
    .byte 0xFF, 0x18                 ;Point 5

	;.org	0xc5f2
VACACC_CruiseControlVacAcceleratedGainCurve_FromDeltaSpeed:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x13AC
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlVacAcceleratedGainCurve_FromDeltaSpeed
    ;mptblcname VACACC
    ;mpxaxis Delta_Speed 0 127 mph
    ;mpyaxis AccRate 0 5 mph/sec
    ;mptbldesc OVERVIEW:_VACACC_(CruiseControlVacAcceleratedGainCurve_FromDeltaSpeed)_defines_the_high-gain_vacuum_servo_pulse_curve_activated_during_large_speed_errors_or_when_resuming_vehicle_speed._When_the_driver_hits_Resume_from_a_significantly_lower_speed,_or_when_encountering_a_steep_incline_that_causes_vehicle_speed_to_drop_past_ACLRST,_the_ECU_sets_the_accelerated_cruise_flag._In_this_mode,_the_cruise_controller_switches_from_VACREG_to_VACACC,_delivering_much_larger_vacuum_solenoid_pulse_widths_to_forcefully_pull_the_throttle_open_and_accelerate_the_car_back_toward_the_target_set_speed_rapidly._|_TUNER'S_GUIDE:_Resume_Sluggishness:_If_resuming_from_45_MPH_to_65_MPH_feels_lethargic,_increase_the_gain_values_in_VACACC._Resume_Overshoot:_If_the_car_aggressively_overshoots_the_set_speed_upon_resuming_(e.g._climbing_to_72_MPH_before_settling_back_to_65_MPH),_reduce_VACACC_slope.
    .byte 0x02                       ;Number of points in table
    .byte 0x00, 0x18, 0x00, 0x00     ;Point 1
    .byte 0xC0, 0x30                 ;Point 2

	;.org	0xc5f9
VENTRG_CruiseControlVentRegularGainCurve_FromDeltaSpeed:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x13BB
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlVentRegularGainCurve_FromDeltaSpeed
    ;mptblcname VENTRG
    ;mpxaxis Delta_Speed 0 127 mph
    ;mpyaxis AccRate 0 5 mph/sec
    ;mptbldesc OVERVIEW:_VENTRG_(CruiseControlVentRegularGainCurve_FromDeltaSpeed)_establishes_the_vent_solenoid_pulse_duration_gain_curve_used_to_bleed_vacuum_from_the_cruise_servo_when_vehicle_speed_exceeds_the_set_target._When_descending_a_highway_incline_or_following_an_acceleration_event,_vehicle_speed_rises_above_the_target_cruise_setting_(Current_Speed_>_Target_Speed)._The_ECU_calculates_the_positive_speed_error_and_looks_up_VENTRG._The_resulting_pulse_energizes_the_vent_solenoid,_venting_vacuum_from_the_actuator_diaphragm_to_atmospheric_pressure_so_the_return_spring_pulls_the_throttle_blade_closed._|_TUNER'S_GUIDE:_Downhill_Speed_Creep:_If_the_vehicle_gains_significant_speed_on_downhill_stretches_with_cruise_engaged,_increase_VENTRG_values_to_vent_vacuum_more_aggressively._Throttle_Jerkiness:_Setting_VENTRG_excessively_high_causes_the_throttle_to_snap_shut_abruptly,_inducing_driveline_lash_on_manual_transmission_vehicles.
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x00, 0xFF, 0xC0     ;Point 1
    .byte 0x10, 0xFC, 0xFF, 0xE5     ;Point 2
    .byte 0x80, 0xF0                 ;Point 3

	;.org	0xc604
SETPW_CruiseControlSetupPulseForSet_FromSpeed:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x13CB
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlSetupPulseForSet_FromSpeed
    ;mptblcname SETPW
    ;mpxaxis Speed 0 128 mph
    ;mpyaxis Vacuum 0 2.8 Pulsewidth
    ;mptbldesc OVERVIEW:_SETPW_(CruiseControlSetupPulseForSet_FromSpeed)_determines_the_initial_'setup_pulse'_duration_applied_to_the_vacuum_servo_the_instant_the_driver_presses_the_'SET'_button._Before_cruise_engages,_the_vacuum_servo_bellows_is_completely_vented_to_atmospheric_pressure_and_the_throttle_is_held_solely_by_the_driver's_foot._When_'SET'_is_pressed,_the_ECU_must_instantly_pre-charge_the_bellows_with_engine_vacuum_to_take_over_the_mechanical_throttle_load_before_the_driver_lifts_off_the_gas_pedal._SETPW_scales_this_pre-charge_pulse_against_vehicle_speed,_ensuring_seamless_handoff_from_foot_throttle_to_cruise_control_without_a_momentary_deceleration_dip._|_TUNER'S_GUIDE:_Set-Speed_Sag_/_Dip:_If_releasing_the_accelerator_pedal_right_after_hitting_SET_causes_the_car_to_momentarily_sag_or_lose_1-2_MPH,_increase_SETPW_at_that_speed._Set-Speed_Surge:_If_the_car_surges_forward_with_unexpected_acceleration_when_tapping_SET,_reduce_SETPW.
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x00, 0x00, 0x00     ;Point 1
    .byte 0x3C, 0x14, 0x00, 0x33     ;Point 2
    .byte 0xAA, 0x2A                 ;Point 3

	;.org	0xc60f
RESTBL_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x13DB
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference
    ;mptblcname RESTBL
    ;mpxaxis Speed 0 128 mph
    ;mpyaxis Raw 0 255 count
    ;mptbldesc OVERVIEW:_RESTBL_(CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference)_specifies_an_additional_vacuum_setup_pulse_added_to_the_base_setup_pulse_when_the_driver_engages_'RESUME'._When_resuming_cruise_from_a_speed_lower_than_the_memorized_target,_the_engine_requires_immediate_additional_throttle_authority_beyond_a_standard_steady-state_SET_engagement._RESTBL_calculates_extra_vacuum_duration_proportional_to_the_deficit_between_current_road_speed_and_the_stored_target_speed,_pre-charging_the_servo_bellows_aggressively_to_begin_pulling_the_vehicle_back_up_to_speed_immediately._|_TUNER'S_GUIDE:_Resume_Hesitation:_If_tapping_Resume_produces_an_initial_hesitation_before_the_car_begins_accelerating,_increase_RESTBL._Resume_Kick:_If_hitting_Resume_causes_an_uncomfortably_sharp_jerk_of_the_throttle,_decrease_the_lower_slope_of_RESTBL.
    .byte 0x03                       ;Number of points in table
    .byte 0x00, 0x00, 0x00, 0x80     ;Point 1
    .byte 0x14, 0x0A, 0x00, 0x1C     ;Point 2
    .byte 0x6E, 0x14                 ;Point 3

	;.org	0xc61e
THGAIN_CruiseControlThrottleGainFactor_FromThrottle:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x13EB
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlThrottleGainFactor_FromThrottle
    ;mptblcname THGAIN
    ;mpxaxis TPS 0 255 tps
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc OVERVIEW:_THGAIN_(CruiseControlThrottleGainFactor_FromThrottle)_provides_a_nonlinear_gain_correction_factor_applied_to_cruise_servo_duty_cycle_based_on_the_current_throttle_opening_angle._Mechanical_throttle_linkages_and_butterfly_throttle_bodies_are_inherently_progressive:_a_1-degree_rotation_at_5%_throttle_allows_a_massive_percentage_change_in_airflow,_whereas_a_1-degree_rotation_at_40%_throttle_produces_a_much_smaller_change_in_airflow._THGAIN_compensates_for_this_progressive_airflow_response_by_adjusting_servo_pulse_authority_as_a_function_of_throttle_position,_linearizing_cruise_throttle_control_across_the_operational_range._|_TUNER'S_GUIDE:_Large_Throttle_Bodies:_Aftermarket_52mm_or_58mm_throttle_bodies_flow_significantly_more_air_at_small_throttle_angles_than_the_stock_48mm_unit._Flattening_or_reducing_THGAIN_at_low_throttle_prevents_cruise_control_twitchiness_with_oversized_throttle_bodies._High-Speed_Hill_Assist:_Increasing_THGAIN_at_higher_throttle_angles_gives_the_cruise_controller_more_authority_to_hold_highway_speeds_up_steep_mountain_passes.
    .byte 0x02                       ;Number of points in table
    .byte 0x00, 0x08, 0x00, 0x00     ;Point 1
    .byte 0x02, 0x12                 ;Point 2

	;.org	0xc629
SPGAIN_CruiseControlSpeedGainFactor_FromSpeed:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x13FA
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname CruiseControlSpeedGainFactor_FromSpeed
    ;mptblcname SPGAIN
    ;mpxaxis Speed 0 128 mph
    ;mpyaxis out_desc 0 255 scale
    ;mptbldesc OVERVIEW:_SPGAIN_(CruiseControlSpeedGainFactor_FromSpeed)_adjusts_the_overall_cruise_control_servo_gain_as_a_function_of_vehicle_road_speed._Aerodynamic_drag_increases_with_the_square_of_vehicle_speed_(_F_drag_proportional_to_v^2_)._At_35_MPH,_small_throttle_movements_produce_rapid_speed_changes,_while_at_75_MPH,_substantial_throttle_movements_are_required_to_counter_wind_resistance._SPGAIN_provides_speed-dependent_gain_scheduling,_scaling_vacuum_servo_responsiveness_across_the_vehicle's_speed_range_to_provide_uniform_control_response_from_35_MPH_to_85_MPH._|_TUNER'S_GUIDE:_High-Speed_Sluggishness:_If_cruise_holds_speed_crisply_at_45_MPH_but_feels_soft_and_unresponsive_at_75_MPH,_increase_SPGAIN_at_higher_road_speeds._Low-Speed_Twitch:_If_cruise_feels_jumpy_at_35-40_MPH,_ensure_SPGAIN_gain_is_calibrated_lower_in_the_lower_speed_range.
    .byte 0x02                       ;Number of points in table
    .byte 0x32, 0x20, 0xFF, 0x5D     ;Point 1
    .byte 0x64, 0x00                 ;Point 2

	;.org	0xc634
VNTAB1_CruiseControlLimitToAMaxVent:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x1409
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlLimitToAMaxVent
    ;mptblcname VNTAB1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_VNTAB1_(CruiseControlLimitToAMaxVent)_defines_the_maximum_allowable_pulse_width_duration_limit_for_the_cruise_control_vent_solenoid._When_the_vehicle_encounters_an_overspeed_condition_(e.g._cresting_a_hill),_the_vent_solenoid_opens_to_dump_vacuum_from_the_actuator._If_the_ECU_vented_vacuum_too_rapidly_or_held_the_vent_open_continuously,_the_throttle_butterfly_would_slam_shut_abruptly_against_its_idle_stop,_causing_severe_driveline_bucking_and_passenger_discomfort._VNTAB1_establishes_an_absolute_clamp_on_single_vent_pulses,_ensuring_throttle_retraction_is_smooth_and_controlled._|_TUNER'S_GUIDE:_Factory_Setting:_Stock_value_is_0x70_(112_counts)._Retain_stock_setting_for_factory_vacuum_actuator_diaphragms._Lightweight_Actuators:_If_using_an_aftermarket_or_smaller_vacuum_servo_actuator_that_vents_faster_than_stock,_reducing_VNTAB1_prevents_harsh_throttle_closing.
    .byte 0x70                       ;Point 1

	;.org	0xc635
VNTAB2_CruiseControlLimitToHalfMaxVent:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x1416
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlLimitToHalfMaxVent
    ;mptblcname VNTAB2
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_VNTAB2_(CruiseControlLimitToHalfMaxVent)_sets_a_intermediate_threshold_used_to_restrict_vent_solenoid_pulses_to_half-maximum_under_mild_overspeed_conditions._When_vehicle_speed_only_moderately_exceeds_the_set_target,_dumping_full_vent_capacity_would_vent_too_much_vacuum,_causing_the_vehicle_to_undershoot_set_speed_and_begin_an_annoying_oscillate/hunt_cycle._VNTAB2_provides_an_intermediate_throttling_clamp,_keeping_the_vent_pulse_gentle_during_minor_speed_corrections._|_TUNER'S_GUIDE:_Hunting_Around_Crests:_If_the_car_consistently_over-corrects_when_cresting_small_rolling_highway_hills_(venting_too_hard_and_then_surging_to_catch_back_up),_lower_VNTAB2_slightly_to_smooth_out_intermediate_venting.
    .byte 0x50                       ;Point 1

	;.org	0xc636
SETIME_CruiseControlNoSetupPulseWhenDecelTimerAboveThis:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x1423
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlNoSetupPulseWhenDecelTimerAboveThis
    ;mptblcname SETIME
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_SETIME_(CruiseControlNoSetupPulseWhenDecelTimerAboveThis)_establishes_the_upper_timer_limit_for_inhibiting_the_initial_vacuum_setup_pulse_during_vehicle_deceleration._If_the_driver_has_been_holding_down_the_'COAST_/_DECEL'_cruise_switch_button_and_releases_it_to_set_a_new_lower_cruise_speed,_the_vehicle_is_actively_decelerating._Applying_a_standard_aggressive_setup_pulse_immediately_upon_switch_release_would_cause_the_car_to_lurch_forward_abruptly._SETIME_checks_the_deceleration_elapsed_timer,_if_the_timer_is_above_this_limit,_the_ECU_suppresses_or_modifies_the_setup_pulse_to_ensure_smooth_engagement_at_the_new_lower_speed._|_TUNER'S_GUIDE:_Coast-to-Set_Behavior:_Retain_stock_setting_(0x37)._Ensures_smooth_deceleration_transitions_without_pedal_kickback_when_tapping_coast.
    .byte 0x37                       ;Point 1

	;.org	0xc637
SETIM1_CruiseControlNoSetupPulseWhenDecelTimerBelowThis:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x1430
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlNoSetupPulseWhenDecelTimerBelowThis
    ;mptblcname SETIM1
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_SETIM1_(CruiseControlNoSetupPulseWhenDecelTimerBelowThis)_sets_the_lower_timer_boundary_for_cruise_control_deceleration_pulse_qualification._In_conjunction_with_SETIME,_SETIM1_establishes_a_precise_timing_window_used_by_the_cruise_state_machine_to_verify_how_long_the_driver_held_the_Coast_button_before_releasing_it._This_prevents_momentary_electrical_switch_contact_bounce_or_brief_switch_taps_from_falsely_corrupting_the_deceleration_state_logic._|_TUNER'S_GUIDE:_Stock_Value:_Factory_setting_is_0x5B._Modification_is_rarely_required_unless_custom_non-factory_cruise_switch_stalks_with_unusual_switch_debounce_timings_are_installed.
    .byte 0x5B                       ;Point 1

	;.org	0xc638
ACLRST_CruiseControlDeltaSpeedToResetAccFlag:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x143D
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlDeltaSpeedToResetAccFlag
    ;mptblcname ACLRST
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis DeltaSpeed 0 127 mph
    ;mptbldesc OVERVIEW:_ACLRST_(CruiseControlDeltaSpeedToResetAccFlag)_defines_the_speed_error_delta_threshold_below_which_the_ECU_disengages_accelerated_cruise_gain_mode_and_returns_to_regular_steady-state_gain_mode._When_resuming_cruise_speed,_the_ECU_operates_in_high-gain_accelerated_mode_(VACACC)_to_pull_the_vehicle_back_up_toward_target_speed_rapidly._Once_vehicle_speed_climbs_close_enough_to_the_set_speed_such_that_the_remaining_deficit_(Target_Speed_-_Current_Speed)_is_less_than_ACLRST_(~2.5_MPH),_the_accelerated_cruise_flag_is_cleared._The_controller_switches_back_to_VACREG,_smoothly_settling_onto_the_target_speed_without_overshooting._|_TUNER'S_GUIDE:_Resume_Overshoot:_If_the_vehicle_consistently_overshoots_set_speed_when_resuming,_increase_ACLRST_to_e.g._0x07_or_0x08_(3.5_-_4.0_MPH)._This_forces_the_controller_to_drop_out_of_accelerated_gain_earlier_and_settle_smoothly._Resume_Undershoot:_If_the_car_accelerates_aggressively_on_resume_but_stalls_out_2-3_MPH_below_set_speed_and_takes_forever_to_climb_the_last_bit,_decrease_ACLRST_slightly.
    .byte 0x05                       ;Point 1

	;.org	0xc639
CLOTHR_CruiseControlDontVentIfThrottleBelowThis:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x144A
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlDontVentIfThrottleBelowThis
    ;mptblcname CLOTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_CLOTHR_(CruiseControlDontVentIfThrottleBelowThis)_specifies_the_minimum_throttle_angle_floor_below_which_the_cruise_vent_solenoid_is_completely_inhibited_from_firing._When_vehicle_speed_exceeds_set_speed_going_down_a_steep_hill,_the_vent_solenoid_bleeds_vacuum_to_close_the_throttle._Once_the_throttle_butterfly_has_returned_completely_to_its_closed_idle_stop_position,_further_venting_cannot_slow_the_car_down_any_more_(the_mechanical_throttle_is_already_at_0%)._Pulsing_the_vent_solenoid_when_the_throttle_is_already_fully_closed_accomplishes_nothing_except_causing_rapid_wear_on_the_solenoid_valve_and_producing_annoying_clicking_sounds_under_the_hood._CLOTHR_gates_the_vent_circuit,_shutting_off_the_vent_solenoid_whenever_the_throttle_is_closed_below_this_floor._|_TUNER'S_GUIDE:_TPS_Zero_Calibration:_If_you_install_an_aftermarket_throttle_body_and_TPS_sensor_where_idle_voltage_sits_slightly_higher_than_stock_(e.g._0.95V_vs_stock_0.85V),_increase_CLOTHR_slightly_to_ensure_the_ECU_knows_when_the_throttle_has_reached_its_physical_mechanical_stop.
    .byte 0x03                       ;Point 1

	;.org	0xc63a
MAXTHR_CruiseControlDontVacIfThrottleAboveThis:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x1457
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlDontVacIfThrottleAboveThis
    ;mptblcname MAXTHR
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_MAXTHR_(CruiseControlDontVacIfThrottleAboveThis)_establishes_the_maximum_throttle_angle_ceiling_allowed_under_cruise_control_operation._The_factory_vacuum_cruise_actuator_is_designed_for_modest_cruising_throttle_adjustments._If_the_vehicle_encounters_a_severe_hill_or_load_requiring_more_than_~30-35%_throttle,_pulling_full_vacuum_to_wide_open_throttle_could_cause_uncontrollable_runaway_acceleration_if_a_mechanical_vacuum_valve_were_to_stick._Furthermore,_operating_a_turbocharged_engine_at_high_boost_under_automated_cruise_control_could_result_in_dangerous_engine_conditions_without_driver_awareness._MAXTHR_places_an_absolute_electronic_clamp_on_vacuum_pull,_once_throttle_position_reaches_MAXTHR,_no_additional_vacuum_is_commanded._|_TUNER'S_GUIDE:_Steep_Mountain_Grades:_In_hilly_terrain,_if_the_car_loses_speed_on_steep_grades_because_cruise_stops_pulling_at_~30%_throttle,_tuners_can_raise_MAXTHR_to_0x60_or_0x70_to_give_the_cruise_system_more_authority_to_hold_speed._Safety_Margin:_Do_not_raise_MAXTHR_all_the_way_to_100%_(WOT)._Maintaining_a_reasonable_ceiling_prevents_runaway_conditions_and_avoids_entering_high_boost_under_cruise_control.
    .byte 0x50                       ;Point 1

	;.org	0xc63b
MAXSET_CruiseControlMaxSetSpeedTimesTwo:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x1464
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlMaxSetSpeedTimesTwo
    ;mptblcname MAXSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 128 MPH
    ;mptbldesc OVERVIEW:_MAXSET_(CruiseControlMaxSetSpeedTimesTwo)_enforces_the_maximum_legal_road_speed_at_which_the_cruise_control_system_is_permitted_to_be_engaged._For_highway_safety_and_federal_motor_vehicle_safety_regulations,_cruise_control_is_restricted_from_engaging_at_extreme_vehicle_speeds._In_the_Chrysler_logic_module,_vehicle_speed_is_represented_in_internal_counts_where_Value_=_MPH_*_2._Stock_MAXSET_is_calibrated_to_0xAA_(170_decimal),_corresponding_to_an_exact_maximum_set_speed_limit_of_85_MPH_(170_/_2)._If_the_driver_attempts_to_press_SET_or_RESUME_at_speeds_above_MAXSET,_the_ECU_ignores_the_command._|_TUNER'S_GUIDE:_Extended_Highway_Cruising:_For_western_US_states_or_track_transport_where_legal_speed_limits_reach_80_MPH,_drivers_wanting_to_cruise_at_85-90_MPH_can_raise_MAXSET_to_0xBE_(95_MPH)_or_0xC8_(100_MPH)._Speed_Clamping:_If_vehicle_speed_exceeds_MAXSET_during_an_acceleration_tap,_set_speed_clamps_at_MAXSET_/_2.
    .byte 0xAA                       ;Point 1

	;.org	0xc63c
MINSET_CruiseControlMinSetSpeedTimesTwo:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x1471
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlMinSetSpeedTimesTwo
    ;mptblcname MINSET
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis Speed 0 128 MPH
    ;mptbldesc OVERVIEW:_MINSET_(CruiseControlMinSetSpeedTimesTwo)_defines_the_minimum_low-speed_cutoff_threshold_for_cruise_control_operation._Cruise_control_is_strictly_designed_for_highway_and_open-road_use._Using_cruise_control_in_city_traffic,_school_zones,_or_residential_areas_represents_a_significant_safety_hazard._Stock_MINSET_is_set_to_0x3C_(60_decimal),_enforcing_a_strict_minimum_engagement_threshold_of_30_MPH_(60_/_2)._Any_attempt_to_engage_cruise_below_30_MPH_is_immediately_locked_out_by_the_ECU._|_TUNER'S_GUIDE:_Factory_Setting:_30_MPH_is_the_standard_factory_minimum_set_speed._It_is_strongly_recommended_to_keep_MINSET_at_stock_0x3C_(30_MPH)_for_public_road_safety.
    .byte 0x3C                       ;Point 1

	;.org	0xc63d
SCNVHI_CruiseControlForBrakeFlagManualTransmissionClutchDisable:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x147E
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlForBrakeFlagManualTransmissionClutchDisable
    ;mptblcname SCNVHI
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_SCNVHI_(CruiseControlForBrakeFlagManualTransmissionClutchDisable)_defines_the_upper_analog_voltage_threshold_used_to_detect_brake_pedal_application_or_manual_transmission_clutch_pedal_depression._On_manual_transmission_vehicles_(MTX),_depressing_either_the_brake_pedal_or_the_clutch_pedal_must_instantly_disengage_cruise_control_to_prevent_engine_over-revving_when_the_clutch_is_disengaged._The_pedal_switch_circuit_feeds_an_analog-to-digital_input_channel._SCNVHI_establishes_the_upper_boundary_of_the_valid_pedal_switch_disengagement_window._|_TUNER'S_GUIDE:_Clutch_/_Brake_Switch_Calibration:_If_cruise_disengages_intermittently_over_highway_bumps,_inspect_switch_alignment_at_the_pedal_bracket_before_altering_calibration_constants._Automatic_vs_Manual_Conversion:_Crucial_calibration_parameter_when_converting_an_automatic_wiring_harness_to_manual_transmission.
    .byte 0xF1                       ;Point 1

	;.org	0xc63e
SCNVLO_CruiseControlForBrakeFlagManualTransmissionClutchDisable:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x148B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname CruiseControlForBrakeFlagManualTransmissionClutchDisable2
    ;mptblcname SCNVLO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_SCNVLO_(CruiseControlForBrakeFlagManualTransmissionClutchDisable)_defines_the_lower_analog_voltage_threshold_of_the_brake/clutch_safety_cutout_window._In_tandem_with_SCNVHI,_SCNVLO_forms_a_noise-immune_voltage_comparator_window._If_the_brake_switch_or_clutch_switch_circuit_is_opened,_closed,_or_shorted_to_ground,_the_reading_falls_outside_the_safe_cruise_operating_band,_commanding_immediate_cruise_disengagement._|_TUNER'S_GUIDE:_Circuit_Diagnostics:_If_cruise_refuses_to_engage_at_all,_measure_the_voltage_on_the_brake/clutch_sense_pin._It_must_rest_within_the_window_between_SCNVLO_and_SCNVHI_when_pedals_are_untouched.
    .byte 0x52                       ;Point 1

	;.org	0xc63f
LOSPCO_CruiseControlLowSpeedCutoutSpeed:
    ;mpgrp Cruise_Control\
    ;mptbladdr 0x1498
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname CruiseControlLowSpeedCutoutSpeed
    ;mptblcname LOSPCO
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_LOSPCO_(CruiseControlLowSpeedCutoutSpeed)_establishes_the_absolute_low-speed_safety_cutout_threshold_(approx_25_MPH)_below_which_active_cruise_control_will_automatically_disengage_and_shut_down._If_vehicle_speed_drops_precipitously_while_cruise_is_active_(for_example,_coming_to_a_sudden_stop_in_traffic,_locking_up_tires_in_rain/snow,_or_spinning_the_vehicle),_LOSPCO_immediately_disengages_the_system._Unlike_MINSET_which_prevents_arming_below_30_MPH,_LOSPCO_monitors_vehicle_speed_during_active_cruising,_if_speed_ever_drops_below_LOSPCO_(~25_MPH),_the_cruise_logic_instantly_dumps_vacuum_and_returns_control_to_the_driver._|_TUNER'S_GUIDE:_Safety_Mechanism:_Never_disable_or_drastically_lower_this_threshold._It_is_an_essential_failsafe_preventing_the_cruise_actuator_from_holding_the_throttle_open_at_very_low_parking_lot_or_stop-and-go_speeds.
    .word 0x0640                     ;Point 1

AISTEP_BitPatternForAisControl:
    ;mpgrp Setup_-_Transfer_Functions\
    ;mptbladdr 0x14A4
    ;mptbltype 9
    ;mpsubtype n
    ;mptbllname BitPatternForAisControl
    ;mptblcname AISTEP
    ;mpxaxis in_desc 4 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc OVERVIEW:_AISTEP_(BitPatternForAisControl)_is_the_hardware_commutation_table_(4_bytes:_0x06,_0x0A,_0x09,_0x05)_that_defines_the_sequential_magnetic_coil_excitation_patterns_for_the_Automatic_Idle_Speed_bipolar_stepper_motor._The_Chrysler_AIS_actuator_contains_two_independent_stator_windings._To_step_the_rotor_forward_(opening_the_pintle)_or_backward_(closing_the_pintle),_the_ECU's_quad-driver_output_transistors_must_energize_the_coil_pairs_in_a_precise_quadrature_sequence:_Phase_0_(0x06,_binary_00000110):_Coils_A+_and_B+_energized._Phase_1_(0x0A,_binary_00001010):_Coils_A-_and_B+_energized._Phase_2_(0x09,_binary_00001001):_Coils_A-_and_B-_energized._Phase_3_(0x05,_binary_00000101):_Coils_A+_and_B-_energized._Inside_Operate_AIS_Motor,_the_ECU_increments_(+1)_or_decrements_(-1)_AISMotorBits,_masks_to_2_bits_(andb_#0x03),_and_fetches_the_coil_bit_pattern_from_AISTEP_to_drive_the_motor_hardware._|_TUNER'S_GUIDE:_Fixed_Hardware_Driver_Table:_NEVER_MODIFY._Changing_these_bit_patterns_will_cause_the_stepper_motor_coils_to_fight_each_other,_resulting_in_a_buzzing,_vibrating_motor_that_cannot_rotate,_leading_to_permanent_idle_motor_failure_or_blown_driver_transistors_in_the_Power_Module_/_SMEC.
    .byte 0x06                       ;Point 1
    .byte 0x0A                       ;Point 2
    .byte 0x09                       ;Point 3
    .byte 0x05                       ;Point 4

RVLSPS_Staging:
    ;mpgrp Turbonator_-_Staging_Limiter\
    ;mptbladdr 0x14B3
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname VehicleSpeedForRevLimit-Staging
    ;mptblcname RVLSPS
    ;mpxaxis X 0 255 in
    ;mpyaxis Speed 0 255 mph
    ;mptbldesc Staging_mod_speed_shutoff____OVERVIEW:_RVLSPS_(Staging)_defines_the_vehicle_speed_cutoff_threshold_for_the_Turbonator_2-step_staging_launch_rev_limiter._When_staging_at_the_drag_strip_starting_line,_the_driver_wants_an_aggressive_low-RPM_rev_limit_(e.g._3,300_RPM)_to_spool_the_turbocharger_against_the_brakes_without_over-revving._However,_the_moment_the_vehicle_launches_and_rolls_off_the_starting_line,_normal_high-RPM_power_is_required_immediately._RVLSPS_sets_the_road_speed_threshold_(stock_=_4_MPH):_while_vehicle_speed_is_below_RVLSPS,_the_staging_limiter_remains_active,_once_the_car_exceeds_this_speed,_the_ECU_automatically_hands_over_to_the_primary_high-RPM_engine_rev_limiter_(REVLMT)._|_TUNER'S_GUIDE:_Drag_Launch_Optimization:_Stock_value_of_4_MPH_(0x04)_works_exceptionally_well_for_both_slicks_and_street_tires,_ensuring_the_limiter_does_not_cut_fuel_down-track_if_wheelspin_occurs._Speed_Sensor_Prerequisite:_Requires_a_functioning_vehicle_distance/speed_sensor_(VSS)._If_the_speed_sensor_is_disconnected_or_broken,_the_ECU_will_remain_locked_in_the_staging_limiter!
    .byte 0x04                       ;Point 1
REVLMTX_StagingModFuelShutoff:
    ;mpgrp Turbonator_-_Staging_Limiter\
    ;mptbladdr 0x14BE
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname OverRevFuelShutoffStagingLower
    ;mptblcname REVLMTX
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Staging_mod_shutoff_-_0x2300=3300rpm____OVERVIEW:_REVLMTX_(StagingModFuelShutoff)_defines_the_primary_engine_speed_setpoint_for_the_Turbonator_2-step_staging_launch_limiter._When_sitting_stationary_at_the_starting_tree_with_the_staging_switch_activated_(e.g._clutch_pedal_depressed_or_launch_button_held),_the_ECU_compares_distributor_period_against_REVLMTX._When_engine_RPM_reaches_this_threshold,_the_ECU_cuts_injector_fuel_pulses._This_holds_engine_speed_perfectly_steady_at_the_calibrated_launch_RPM_(e.g._3,300_-_3,800_RPM),_allowing_the_exhaust_pulses_and_ignition_anti-lag_retard_to_build_several_pounds_of_launch_boost_on_the_starting_line_before_the_clutch_is_released._|_TUNER'S_GUIDE:_Launch_Boost_vs._Traction:_Calibrate_REVLMTX_based_on_tire_compound_and_track_prep._Street_radial_tires_typically_launch_best_around_3,200_-_3,500_RPM_to_avoid_excessive_wheel_hop._Drag_slicks_on_a_prepped_track_can_launch_at_4,000_-_4,500_RPM_for_maximum_boost_off_the_line._Anti-Lag_Retard_Synergy:_When_the_staging_limiter_is_active,_Turbonator_code_triggers_the_anti-lag_timing_retard_curve_to_spool_the_turbocharger_rapidly_on_the_2-step.
    .word 0x271D                     ;Point 1
REVLMTX2_StagingModFuelShutoff:
    ;mpgrp Turbonator_-_Staging_Limiter\
    ;mptbladdr 0x14C9
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname OverRevFuelShutoffStagingUpper
    ;mptblcname REVLMTX2
    ;mpxaxis X 0 255 in
    ;mpyaxis Y 0 255 out
    ;mptbldesc Staging_mod_shutoff2_-_0x2100=3500rpm____OVERVIEW:_REVLMTX2_(StagingModFuelShutoff)_establishes_the_secondary_hysteresis_recovery_threshold_for_the_Turbonator_2-step_staging_limiter._To_prevent_the_engine_from_violently_misfiring_or_jerking_at_a_single_knife-edge_RPM,_the_fuel_shutoff_routine_implements_a_dual-threshold_hysteresis_window._REVLMTX_defines_where_fuel_cut_initiates,_and_REVLMTX2_(located_at_offset_+2_from_REVLMTX)_defines_the_recovery_period_where_fuel_resumes._This_hysteresis_deadband_smooths_out_the_2-step_limiter_sound_and_maintains_stable_cylinder_temperatures_on_the_starting_line._|_TUNER'S_GUIDE:_Limiter_Cadence:_Spacing_REVLMTX_and_REVLMTX2_by_roughly_150-200_RPM_creates_a_rapid,_machine-gun_stutter_on_the_2-step,_ideal_for_building_consistent_manifold_boost._Synchronized_Tuning:_Always_adjust_REVLMTX2_proportionally_whenever_REVLMTX_is_moved_to_a_new_launch_RPM.
    .word 0x26F8                     ;Point 1
    
RVLSWS_StagingLimiterSwitchSelect:
    ;mpgrp Turbonator_-_Staging_Limiter\
    ;mptbladdr 0x14D5
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname StagingLimiterSwitchSelect
    ;mptblcname RVLSWS
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc Switch_that_will_activate_the_staging_limiter._If_no_switch_is_selected,_then_the_staging_limiter_is_enabled_by_speed_only.____OVERVIEW:_RVLSWS_(StagingLimiterSwitchSelect)_selects_the_physical_hardware_switch_input_used_to_arm_and_activate_the_Turbonator_2-step_staging_launch_limiter._T-LM_allows_flexible_configuration_of_the_launch_limiter_arming_trigger:_0x00:_Speed-only_arming_(active_automatically_whenever_vehicle_speed_is_below_RVLSPS)._0x08_(Stock_default):_Clutch_pedal_switch_input_(Port_C_Bit_3)._Limiter_engages_only_when_the_clutch_pedal_is_pressed_to_the_floor._Custom_bitmasks_allow_mapping_to_a_momentary_steering_wheel_launch_button,_line-lock_switch,_or_emergency_brake_switch._|_TUNER'S_GUIDE:_Manual_Transmission_(Clutch_Switch):_Leave_at_default_0x08._The_2-step_arms_when_staged_with_the_clutch_depressed,_and_disengages_the_instant_the_clutch_pedal_begins_releasing._Automatic_Transmission_(Brake_/_Line-Lock):_Wire_a_momentary_line-lock_button_to_the_brake/clutch_switch_sense_pin,_allowing_automatic_cars_to_stall_the_converter_against_the_brake_at_the_staging_line._No_Switch_Setup:_Setting_RVLSWS_to_0x00_enables_pure_speed_mode,_whenever_the_car_is_stopped_(_<_4_MPH),_the_2-step_is_armed.
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
    ;mpgrp Spark_-_Anti-Lag_Retard\
    ;mptbladdr 0x14F3
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname AntiLagRetardfromBoostGoalDelta
    ;mptblcname ANTLAG
    ;mpxaxis DeltaMAP 0 29.4 psi
    ;mpyaxis Spark_Retard 0 16 Degrees
    ;mptbldesc Curve_for_retard_based_on_delta_MAP_for_anti-lag_feature._This_will_be_subtracted_from_the_calculated_spark_advance.____OVERVIEW:_ANTLAG_AntiLagRetardfromBoostTargetDelta_is_the_lookup_table_for_the_Turbonator_Launch_Control_/_Anti-Lag_Boost_Building_System._When_a_turbocharged_car_is_staged_on_the_starting_line_against_a_two-step_launch_rev_limiter_(or_at_initial_wide-open_throttle_launch),_the_turbocharger_normally_struggles_to_spool_because_the_engine_is_not_under_sufficient_physical_rolling_load._Turbonator's_Anti-Lag_routine_solves_this_by_heavily_retarding_ignition_timing_when_there_is_a_large_deficit_between_actual_manifold_boost_and_the_target_boost_goal_(_DeltaMAP_=_BoostTarget_-_MapValue_)._Retarding_the_spark_causes_the_air/fuel_charge_to_finish_combustion_inside_the_exhaust_manifold_and_turbine_housing_rather_than_inside_the_cylinder._This_massive_expansion_of_hot_exhaust_gas_violently_spools_the_turbocharger_turbine,_allowing_the_vehicle_to_build_5_to_15+_psi_of_boost_while_stationary_on_the_starting_line._|_TUNER'S_GUIDE:_The_value_looked_up_from_ANTLAG_is_divided_by_8_and_subtracted_directly_from_WOTMAP_at_line_6593_of_CalculateSparkAdvance_MM:_WOT_Timing_=_WOTMAP(MAP)_-_AntiLagRetard_Increasing_Table_Values_(More_Retard):_Effect_on_Total_Timing:_Pulls_more_timing_(up_to_16_deg_retard)_when_boost_is_below_target._Real-World_Driving_Feel:_Dramatically_accelerates_turbocharger_spool_on_the_starting_line,_building_boost_faster_and_louder_with_aggressive_exhaust_popping._Cautions:_Extreme_exhaust_gas_temperatures_(EGTs)_are_generated!_Extended_anti-lag_operation_(more_than_3-5_seconds_on_the_launch_limiter)_can_overheat_exhaust_valves,_crack_turbocharger_turbine_housings,_and_damage_catalytic_converters._Decreasing_Table_Values_(Less_Retard):_Effect_on_Total_Timing:_Pulls_less_timing_during_boost_spool-up._Real-World_Driving_Feel:_Gentler_on_exhaust_components,_but_builds_starting-line_boost_more_slowly._Zeroing_Out:_Setting_all_Y-axis_values_to_0x00_completely_disables_anti-lag_timing_retard_while_preserving_normal_two-step_rev_limiting.
    ;mpmapaxis x
    .byte 0x05                       ;Number of points in table
    .byte 0x0F, 0x00, 0x02, 0x5E     ;Point 1
    .byte 0x2A, 0x40, 0x01, 0x2F     ;Point 2
    .byte 0x45, 0x60, 0x00, 0xA1     ;Point 3
    .byte 0x6B, 0x78, 0x00, 0x2B     ;Point 4
    .byte 0x9A, 0x80                 ;Point 5

AKPMON_AlkyPumpOnSetpointFromMAP:
    ;mpgrp Turbonator_-_Alky_Injection\
    ;mptbladdr 0x1505
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyPumpOnSetpointFromMAP
    ;mptblcname AKPMON
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc OVERVIEW:_AKPMON_(AlkyPumpOnSetpointFromMAP)_establishes_the_manifold_absolute_pressure_(MAP)_turn-on_threshold_for_the_Turbonator_water/methanol_(alky)_injection_delivery_pump._Turbonator_firmware_includes_native_logic_to_repurpose_unused_ECU_output_drivers_(such_as_the_purge_or_EGR_solenoid_drivers)_to_control_an_external_progressive_water/methanol_pump_relay._AKPMON_defines_the_boost_pressure_where_the_ECU_energizes_the_pump_relay_to_prime_and_pressurize_the_injection_lines_before_injector_solenoids_open._|_TUNER'S_GUIDE:_Enabling_Alky_Injection:_Set_cfg_AlkyInj_in_configuration_flags._Calibrate_AKPMON_to_roughly_3-5_psi_of_boost_(approx_0x90_on_a_2-bar_or_3-bar_MAP_sensor)._Early_Priming:_Priming_the_high-pressure_pump_2-3_psi_before_opening_the_injection_nozzle_solenoids_(AKI1ON)_prevents_spray_pressure_lag_and_uneven_atomization.
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1

AKPMOF_AlkyPumpOffSetpointFromMAP:
    ;mpgrp Turbonator_-_Alky_Injection\
    ;mptbladdr 0x1512
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyPumpOffSetpointFromMAP
    ;mptblcname AKPMOF
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc OVERVIEW:_AKPMOF_(AlkyPumpOffSetpointFromMAP)_establishes_the_shut-off_MAP_threshold_for_the_water/methanol_injection_pump._Once_the_water/methanol_pump_has_been_energized_at_AKPMON,_AKPMOF_creates_a_pressure_hysteresis_cushion._As_the_driver_lifts_off_the_throttle_and_boost_falls_below_AKPMOF,_the_pump_driver_de-energizes._This_hysteresis_deadband_prevents_the_pump_relay_from_buzzing_or_cycling_rapidly_if_manifold_pressure_fluctuates_near_the_trigger_point._|_TUNER'S_GUIDE:_Hysteresis_Calibration:_Set_AKPMOF_approximately_1.5_-_2.0_psi_below_AKPMON._For_example,_if_the_pump_turns_on_at_5_psi_boost,_set_it_to_turn_off_at_3_psi_boost._Smooth_Cutoff:_Prevents_sudden_pump_shutdown_on_momentary_boost_fluctuations_during_gear_shifts.
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1

AKI1ON_AlkyInj1OnSetpointFromMAP:
    ;mpgrp Turbonator_-_Alky_Injection\
    ;mptbladdr 0x151F
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyInj1OnSetpointFromMAP
    ;mptblcname AKI1ON
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc OVERVIEW:_AKI1ON_(AlkyInj1OnSetpointFromMAP)_sets_the_manifold_pressure_threshold_where_the_Stage_1_water/methanol_injection_nozzle_solenoid_opens._In_a_staged_water/methanol_injection_system,_Stage_1_introduces_a_small,_finely_atomized_spray_nozzle_into_the_charge_pipe_at_moderate_boost_levels_(e.g._7-10_psi)_to_suppress_initial_intake_air_temperatures_and_prevent_detonation_as_cylinder_pressure_begins_climbing._|_TUNER'S_GUIDE:_Stage_1_Activation:_Calibrate_AKI1ON_to_trigger_at_the_boost_level_where_engine_knock_margin_begins_to_narrow_on_pump_gas_(typically_7_to_10_psi_boost)._Nozzle_Sizing:_Size_Stage_1_nozzle_for_approximately_10-15%_of_total_fuel_flow_to_avoid_rich_bogging.
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1

AKI1OF_AlkyInj1OffSetpointFromMAP:
    ;mpgrp Turbonator_-_Alky_Injection\
    ;mptbladdr 0x152C
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyInj1OffSetpointFromMAP
    ;mptblcname AKI1OF
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc OVERVIEW:_AKI1OF_(AlkyInj1OffSetpointFromMAP)_specifies_the_MAP_threshold_where_the_Stage_1_water/methanol_solenoid_shuts_off_as_manifold_pressure_drops._Provides_hysteresis_cutoff_protection_for_Stage_1_water/methanol_injection,_ensuring_the_nozzle_snaps_closed_cleanly_when_throttle_lifts_occur._|_TUNER'S_GUIDE:_Staggering:_Calibrate_AKI1OF_approximately_1.5_-_2.0_psi_below_AKI1ON._Ensures_clean_cutoff_without_premature_shutoff_during_boost_ramping.
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1

AKI2ON_AlkyInj2OnSetpointFromMAP:
    ;mpgrp Turbonator_-_Alky_Injection\
    ;mptbladdr 0x1539
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyInj2OnSetpointFromMAP
    ;mptblcname AKI2ON
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc OVERVIEW:_AKI2ON_(AlkyInj2OnSetpointFromMAP)_establishes_the_trigger_threshold_for_the_high-flow_Stage_2_water/methanol_injection_nozzle_solenoid._Under_maximum_boost_conditions_(e.g._15-25+_psi),_engine_thermal_loading_and_octane_demand_escalate_drastically._AKI2ON_activates_a_secondary_high-volume_methanol_nozzle,_delivering_supplemental_fuel_volume,_charge_cooling,_and_high_octane_equivalent_to_support_elevated_boost_without_detonation._|_TUNER'S_GUIDE:_High_Boost_Staging:_Set_AKI2ON_4-8_psi_higher_than_AKI1ON_(e.g._Stage_1_at_8_psi,_Stage_2_at_16_psi)._This_two-stage_delivery_provides_linear_octane_supplementation_without_drowning_the_motor_at_mid-range_boost.
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1

AKI2OF_AlkyInj2OffSetpointFromMAP:
    ;mpgrp Turbonator_-_Alky_Injection\
    ;mptbladdr 0x1546
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname AlkyInj2OffSetpointFromMAP
    ;mptblcname AKI2OF
    ;mpxaxis X 0 255 in
    ;mpyaxis MAP -14.7 14.7 psi
    ;mptbldesc OVERVIEW:_AKI2OF_(AlkyInj2OffSetpointFromMAP)_establishes_the_shut-off_threshold_for_Stage_2_water/methanol_injection._Closes_the_high-flow_Stage_2_nozzle_when_manifold_pressure_falls_below_the_calibrated_hysteresis_threshold,_preserving_water/methanol_fluid_and_preventing_over-rich_fueling_as_boost_begins_tapering._|_TUNER'S_GUIDE:_Hysteresis_Margin:_Set_AKI2OF_roughly_2_psi_below_AKI2ON._Maintain_gap_above_AKI1ON_so_stages_hand_over_smoothly.
    ;mpmapaxis y
    .byte 0xFF                       ;Point 1

KNKMIN_FlashCEMinTemp:
    ;mpgrp Turbonator_-_Flash_CE_on_Knock\
    ;mptbladdr 0x1553
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname FlashCEMinTemp
    ;mptblcname KNKMIN
    ;mpxaxis IN 0 255 X
    ;mpyaxis CoolantTemp -200 260 deg
    ;mptbldesc The_min_temp_allowed_before_the_CE_light_is_flashed._To_avoid_false_indication_on_a_cold_engine.____OVERVIEW:_KNKMIN_(FlashCEMinTemp)_defines_the_minimum_engine_coolant_temperature_required_before_the_ECU_will_flash_the_instrument_cluster_'Check_Engine'_/_'Power_Loss'_light_upon_detecting_spark_knock._Turbonator_firmware_features_real-time_knock_indication:_whenever_the_knock_sensor_detects_detonation_and_the_ECU_pulls_spark_timing_on_any_individual_cylinder_(Cylinder1-4Retard),_the_ECU_flashes_the_Check_Engine_light_to_alert_the_driver_immediately._However,_forged_pistons_or_cold_engine_blocks_naturally_exhibit_mechanical_piston_slap_and_valve_train_clatter_when_cold._If_knock_indication_were_enabled_on_a_cold_motor,_the_driver_would_see_constant_false_alarm_flashing._KNKMIN_blocks_knock_CEL_flashing_until_the_engine_warms_up_to_normal_operating_temperature_(~160_degF)._|_TUNER'S_GUIDE:_Forged_Piston_Engines:_Engines_built_with_loose_piston-to-wall_clearances_(forged_2618_pistons)_produce_noticeable_cold_slap._Raising_KNKMIN_to_0xB5_(~175_degF)_completely_silences_false_knock_alerts_until_the_pistons_have_fully_expanded._Instant_Detonation_Warning:_Invaluable_tuning_tool_on_the_street_or_dyno:_allows_the_tuner_to_instantly_see_real-time_detonation_without_looking_away_from_the_road_at_a_laptop_screen.
    .byte 0xA8                       ;Point 1

SLRPM_ShiftLightSetpoint:
    ;mpgrp Turbonator_-_Shift_Light\
    ;mptbladdr 0x155F
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ShiftLightSetpoint
    ;mptblcname SLRPM
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis RPM 0 16384 rpm
    ;mptbldesc Shift_light_setpoint.____OVERVIEW:_SLRPM_(ShiftLightSetpoint)_sets_the_precise_engine_RPM_at_which_the_ECU_illuminates_the_instrument_cluster_upshift_indicator_or_an_external_shift_light._Turbonator_code_repurposes_the_purge/EGR_driver_output_or_the_factory_cluster_upshift_arrow_to_function_as_a_programmable_high-RPM_shift_light._When_engine_speed_climbs_to_SLRPM,_the_ECU_grounds_the_driver_circuit,_illuminating_the_shift_light_to_tell_the_driver_to_shift_before_hitting_the_rev_limiter._Once_RPM_drops_below_SLRPM_during_gear_change,_the_light_turns_off_immediately._|_TUNER'S_GUIDE:_Power_Peak_Shift_Point:_Set_SLRPM_roughly_200-400_RPM_past_peak_horsepower_on_your_dyno_sheet,_but_300-500_RPM_below_your_hard_rev_limiter_(REVLMT)._This_gives_the_driver_human_reaction_time_to_initiate_the_shift_without_bouncing_off_the_limiter._Stock_Valvetrain_Safety:_On_stock_hydraulic_lifter_8-valve_engines,_set_SLRPM_to_5,600_-_5,800_RPM_to_protect_valvetrain_components_from_valve_float.
    .word 0xABDF                     ;Point 1
       
WOTBAT_WOTBatteryVoltsTarget:
    ;mpgrp Turbonator_-_Voltage_Regulator\
    ;mptbladdr 0x156B
    ;mptbltype 3
    ;mpsubtype n
    ;mptbllname WOTBatteryVoltsTarget
    ;mptblcname WOTBAT
    ;mpxaxis in_desc 0 255 in
    ;mpyaxis BatVolts 0 16.2 V
    ;mptbldesc Battery_volts_target_when_at_WOT.____OVERVIEW:_WOTBAT_(WOTBatteryVoltsTarget)_specifies_the_target_battery_regulation_voltage_commanded_during_Wide_Open_Throttle_(WOT)_acceleration._The_Chrysler_logic_module_directly_controls_alternator_charging_field_duty_cycle_via_an_internal_pulse-width_modulated_voltage_regulator._An_energized_alternator_charging_at_14.5V_under_heavy_electrical_load_can_consume_3_to_5_engine_horsepower._Under_WOT_acceleration,_Turbonator_code_lowers_the_target_charging_voltage_to_WOTBAT_(approx_12.5V_-_12.8V)._This_effectively_de-energizes_the_alternator_field,_shedding_parasitic_mechanical_drag_from_the_crankshaft_and_transferring_every_possible_horsepower_directly_to_the_drive_wheels_during_wide-open_drag_strip_passes_or_passing_maneuvers._|_TUNER'S_GUIDE:_Free_Dyno_Horsepower:_Frees_3-5_HP_at_the_wheels_during_full-throttle_acceleration_pulls._Ignition_Coil_Considerations:_Ensure_your_ignition_system_and_fuel_pump_maintain_sufficient_voltage_at_~12.5V._If_running_an_exceptionally_high-draw_fuel_pump_without_a_dedicated_booster,_keep_WOTBAT_around_13.0V_(0xF0)_to_prevent_fuel_pressure_drop.
    .byte 0xEC                       ;Point 1

BSTSWS_HighBoostSwitchSelect:
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x1577
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname HighBoostSwitchSelect
    ;mptblcname BSTSWS
    ;mpxaxis IN 0 255 X
    ;mpyaxis OUT 0 255 Y
    ;mptbldesc Switch_that_will_activate_high_boost_mode._If_no_switch_is_selected,_then_theboost_is_not_selectable,_and_the_Low_Boost_curve_needs_to_be_setup_as_the_high_boost_curve.____OVERVIEW:_BSTSWS_HighBoostSwitchSelect_defines_the_hardware_input_pin_bitmask_used_to_toggle_Turbonator_Switchable_Boost_(High/Low_Boost)._Turbonator_firmware_allows_the_driver_to_toggle_between_a_daily-driver_'Low_Boost'_setting_and_a_race_'High_Boost'_setting_using_a_dashboard_switch_or_steering_wheel_button._BSTSWS_selects_which_physical_wire_on_Logic_Module_Connector_B_senses_this_toggle._|_TUNER'S_GUIDE:_Pin_Bitmask_Assignments:_0x01:_Cruise_Set_(Pin_B9)_0x02:_Cruise_Resume_(Pin_B10_-_Factory_Default)_0x04:_A/C_Clutch_Sense_(Pin_B11)_0x08:_Park/Neutral_(Pin_B12)_0x10:_Brake_Switch_(Pin_B13)_0x40:_Cruise_Enable_(Pin_B15)_Custom_Toggle_Switch:_Wire_a_toggle_switch_between_the_chosen_pin_and_ground/12V_(matching_polarity)_to_give_instant_dual-stage_boost_control.
    ;mpchoices Cruise_Set(Momentary)  Cruise_Resume(Momentary)  A/C_Clutch_Input(Do_Not_Use)  Brake_Pedal_Switch  P/N_Switch  Nothing(Do_Not_Use)  Cruise_On/Off  Dist_Sync(Do_Not_Use)
    .byte 0x02                       ;Point 1
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
    ;mpgrp Boost_-_Target_Lookup\
    ;mptbladdr 0x1595
    ;mptbltype 3
    ;mpsubtype 1
    ;mptbllname SwitchableBoostLoSetpoint
    ;mptblcname SWBSLO
    ;mpxaxis X 0 255 in
    ;mpyaxis Boost 0 29.4 psi
    ;mptbldesc Lo_boost_clip_point_for_switchable_boost.____OVERVIEW:_SWBSLO_SwitchableBoostLoSetpoint_defines_the_target_boost_ceiling_applied_when_Low_Boost_Mode_is_selected_via_the_dual-stage_boost_switch._When_the_driver_flips_the_boost_switch_selected_by_BSTSWS_to_Low_Boost,_the_ECU_clamps_the_accumulated_boost_goal_to_SWBSLO._|_TUNER'S_GUIDE:_Stock_Value:_0x56_(_~_9.9_psig_)._Valet_/_Economy_Mode:_Set_SWBSLO_to_spring_pressure_(e.g._5-7_psi)_for_a_valet_mode,_rain/winter_mode,_or_87-octane_emergency_mode._High_Boost_Mode:_Set_your_primary_curve_(WSGRPM)_to_18-25_psi,_flipping_the_switch_toggles_instantly_between_this_low_setting_and_full_high_boost.
    ;mpmapaxis y
    .byte 0x56                       ;Point 1

SBNRMP_BankScalingFromMAP:
    ;mpgrp Fuel_-_Selective_Bank_Enrichment\
    ;mptbladdr 0x15A2
    ;mptbltype 0
    ;mpsubtype 1
    ;mptbllname BankScalingFromMAP
    ;mptblcname SBNRMP
    ;mpxaxis MAP -14.7 14.7 psi
    ;mpyaxis Factor 0 1 x
    ;mptbldesc Selective_bank_enrichment_factor_from_MAP.____OVERVIEW:_SBNRMP_BankScalingFromMAP_provides_the_manifold_pressure_scaling_curve_for_Chrysler's_Selective_Bank_Fuel_Enrichment_feature._The_factory_Chrysler_2.2L_/_2.5L_8-valve_single-plenum_intake_manifold_has_asymmetrical_runner_lengths_and_uneven_plenum_distribution:_Cylinders_1_&_2_breathe_differently_than_Cylinders_3_&_4_at_specific_airflow_rates._Because_the_ECU_fires_injectors_in_two_paired_banks_(Bank_1:_Cylinders_1_&_2,_Bank_2:_Cylinders_3_&_4),_the_firmware_includes_selective_bank_enrichment_to_deliver_extra_fuel_to_the_leaner_bank._SBNRMP_scales_this_trim_based_on_manifold_pressure._|_TUNER'S_GUIDE:_Stock_Calibration:_Compensates_for_factory_log_and_two-piece_intake_manifold_distribution_biases._Custom_Aftermarket_Manifolds:_If_installing_an_aftermarket_custom_intake_manifold_with_equal-length_runners_or_an_upgraded_center-feed_plenum,_the_factory_distribution_asymmetry_is_eliminated!_Critical_Tuning_Action:_When_running_an_aftermarket_equal-length_intake_manifold,_zero_out_SBNRMP_(or_set_SBNRBS_to_neutral)_to_ensure_both_injector_banks_deliver_perfectly_matched_fuel_delivery.
    ;mpmapaxis x
    .byte 0x05                       ;Number of points in table
    .byte 0x1A, 0xAB, 0xFC, 0x1F     ;Point 1
    .byte 0x33, 0x4A, 0xFF, 0x08     ;Point 2
    .byte 0x55, 0x29, 0xFF, 0x95     ;Point 3
    .byte 0x74, 0x1C, 0x01, 0x2F     ;Point 4
    .byte 0xAA, 0x5C                 ;Point 5

SBNRRP_BankScalingFromRPM:
    ;mpgrp Fuel_-_Selective_Bank_Enrichment\
    ;mptbladdr 0x15B4
    ;mptbltype 0
    ;mpsubtype n
    ;mptbllname BankScalingFromRPM
    ;mptblcname SBNRRP
    ;mpxaxis RPM 0 8192 rpm
    ;mpyaxis Factor 0 1 x
    ;mptbldesc Selective_bank_enrichment_factor_from_RPM.____OVERVIEW:_SBNRRP_BankScalingFromRPM_provides_the_engine_speed_weighting_curve_for_Selective_Bank_Fuel_Enrichment._Intake_runner_resonance_and_distribution_biases_change_with_engine_RPM._SBNRRP_modulates_the_selective_bank_trim_across_the_RPM_band,_peaking_where_runner_acoustic_imbalances_are_greatest._|_TUNER'S_GUIDE:_Stock_Setting:_Modulates_runner_distribution_trim_from_1500_to_5000_RPM._Aftermarket_Intakes:_Zero_out_when_running_symmetrical_intake_manifolds.
    .byte 0x03                       ;Number of points in table
    .byte 0x3F, 0x9A, 0x00, 0x3B     ;Point 1
    .byte 0x96, 0xAE, 0x00, 0x00     ;Point 2
    .byte 0xCB, 0xAE                 ;Point 3
	
SBNRBS_BankSelect:
    ;mpgrp Fuel_-_Selective_Bank_Enrichment\
    ;mptbladdr 0x15C3
    ;mptbltype 5
    ;mpsubtype n
    ;mptbllname BankSelect
    ;mptblcname SBNRBS
    ;mpxaxis IN 0 255 x
    ;mpyaxis OUT 0 255 y
    ;mptbldesc Bank_to_enrich._Only_1_should_be_selected.____OVERVIEW:_SBNRBS_BankSelect_defines_which_physical_injector_driver_bank_receives_the_selective_bank_fuel_enrichment_pulse._In_the_6803_hardware_architecture,_fuel_injection_is_driven_by_two_physical_output_driver_transistors:_0x80:_Injector_Bank_1_(Cylinders_1_&_2)_0x40:_Injector_Bank_2_(Cylinders_3_&_4)_In_the_factory_calibration,_SBNRBS_is_set_to_0x40,_directing_the_supplemental_enrichment_to_Cylinders_3_&_4_to_compensate_for_lean_flow_into_the_rear_of_the_stock_intake_manifold._|_TUNER'S_GUIDE:_Factory_Setting:_0x40_(Bank_3-4)._Valid_Settings:_0x40:_Enriches_Bank_2_(Cylinders_3_&_4)._0x80:_Enriches_Bank_1_(Cylinders_1_&_2)._0x00:_Disables_selective_bank_enrichment_completely._Equal_Length_Manifolds:_If_running_an_aftermarket_equal-length_intake_manifold,_setting_SBNRBS_=_0x00_completely_disables_bank_differential_fueling,_ensuring_identical_injector_pulse_widths_on_all_4_cylinders.
    ;mpchoices NA  NA  NA  NA  NA  NA  Bank34(Stock)  Bank12(DC)
    .byte 0x40                       ;Point 1
    
MDLCDE_ModelTypeCode:
    ;mpgrp Setup_-_Cal_Configuration\
    ;mptbladdr 0x008F
    ;mptbltype 4
    ;mpsubtype n
    ;mptbllname ModelTypeCode
    ;mptblcname MDLCDE
    ;mpxaxis X 0 255 in
    ;mpyaxis out_desc 0 255 out
    ;mptbldesc The_1st_2_digits_are_the_model_year,_2nd_2_digits_are_the_engine_and_trans_type.____OVERVIEW:_MDLCDE_(ModelTypeCode)_is_a_2-byte_engineering_classification_word_located_at_$008F._The_first_two_hex_digits_(0x97)_encode_the_Chrysler_model_year_and_vehicle_chassis_platform_(e.g._G-body_Daytona,_P-body_Shadow,_H-body_Lancer/LeBaron_GTS),_while_the_second_two_digits_(0x09)_encode_the_engine_displacement_and_transmission_combination_(2.2L_Turbo_I_/_Turbo_II,_Manual_A555_/_A520_vs_Automatic_A413)._Diagnostic_scan_tools_read_this_word_during_vehicle_identification_handshake._|_TUNER'S_GUIDE:_Tuning_Usage:_Factory_identification_constant._Preserve_stock_value_(0x9709)_when_updating_custom_tunes.
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
    ;mp******************************

