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
    ;mptbldesc ECU_ID._This_portion_of_the_PN_is_used_by_scan_tools_to_automatically_ID_the_ECU._This_number_is_different_for_every_computer/cal._The_1st_digit_is_possibly_a_revision_code_of_some_type._Or,_it_may_have_no_meaning_at_all.
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
    ;mptbldesc Special_code_for_factory_testing.
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
    ;mptbldesc Special_code_for_factory_testing.
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
    ;mptbldesc Illuminate_PowerLoss_Light_Mask1._These_errors_alert_the_driver.
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
    ;mptbldesc Illuminate_PowerLoss_Light_Mask2._These_errors_alert_the_driver.
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
    ;mptbldesc Desc
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
    ;mptbldesc Desc
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
    ;mptbldesc These_are_the_calibration_configuration_options.
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
    ;mptbldesc Curve_for_Spark_Advance_from_MAP_when_Engine_Temp_is_below_TMPSWP
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
    ;mptbldesc Coldest_input_allowed_for_Cold_MAP
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
    ;mptbldesc Curve_for_Spark_Advance_from_MAP_when_Engine_Temp_is_above_TMPSWP_and_at_Full_Throttle
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
    ;mptbldesc Curve_for_Spark_Advance_from_MAP_when_Engine_Temp_is_above_TMPSWP_and_not_at_Full_Throttle
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Engine_temperature_switch_point_for_hot_and_cold_map_spark
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Simulates_the_mechanical_advance_function._Spark_Advance_is_added_from_this_table_from_RPMs_at_all_engine_temperatures._Added_to_MAP_based_advance
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
    ;mptbldesc Run_to_Start_transfer_point_for_spark
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
    ;mptbldesc Number_of_consecutive_EPPs_needed_to_be_above_Start_Run_when_hot
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
    ;mptbldesc Number_of_consecutive_EPPs_needed_to_be_above_Start_Run_when_cold
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
    ;mptbldesc Engine_Temperature_switch_point_for_SRTIME
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
    ;mptbldesc Switch_Spark_To_Run_Mode_when_Inverse_RPMs_below_this_value._Stock_is_0x00c3_should_be_about_600_RPM
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
    ;mptbldesc Switch_Back_To_Spark_Start_Mode_if_Inverse_RPMs_increase_above_this_value._Stock_is_0x011b_should_be_about_410_RPM
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
    ;mptbldesc Description
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
    ;mptbldesc Not_used
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
    ;mptbldesc Engine_speed_below_which_PNIDLE_is_Enabled_-_for_Automatics
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
    ;mptbldesc Minimum_RPM_for_Knock_Retard
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
    ;mptbldesc Delta_above_Baro_up_to_which_RTRDRT_(Retard_Rate)_is_used_and_KNKCNT_and_KNKCOR_are_incremented._Stock_is_5.4_psi.
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
    ;mptbldesc Retard_rate_from_Knock,_no_boost._In_half_degreesn
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Increase_Rate._Recovery_from_Knock_Retard._Rate_is_1/2_engine_degree_every_INCSRT+1_*_11ms._Use_ONLY_0,1,3,7,f,1f,3f,7f_or_ff
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
    ;mptbldesc Knock_Limit_in_1/2_degrees._MaxRetard_=_KNKLIM_if_throttle_is_above_THRKNK_and_RPM_is_below_KLMRPM
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
    ;mptbldesc Delta_above_MINTHR_for_knock_detect
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
    ;mptbldesc RPMS_for_Knock
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
    ;mptbldesc Maximum_Knock_Retard_from_Map
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
    ;mptbldesc Input_from_the_knock_sensor_that_is_above_this_voltage_is_considered_Knock.
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Fine_Tune_Step_for_AIS_for_spark_scatter
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
    ;mptbldesc Spark_Scatter_inhibited_below_this_speed._The_MP_MTX_cal_has_this_value_set_to_0xfe33_to_keep_the_revs_high_during_shifts.
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
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4
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
    ;mptbldesc Coldest_temperature_accepted_as_input_to_STRTFL_table_-_anything_below_this_value_will_be_replaced_with_this_value
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
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4._This_decreases_fuel_slightly_at_higher_altitudes_to_account_for_thinner_air.
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
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4
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
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4._This_table_decreases_fuel_for_each_engine_rotation_while_starting
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
    ;mptbldesc Start_fuel_uSec_=_[_STRTFL_*_STRTFL_*_(1_-_STFBAR_-_STFTMP)_*_EPPMUL_+_(BATOFF_*_4)_]_*_4._This_allows_fuel_to_decay_gradually_after_the_start-run_transition.
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
    ;mptbldesc Prime_Fuel_Shot_before_cranking
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
    ;mptbldesc DelayTimeWhenGoingClosedLoop._o2_voltage_must_trigger_timer,_ie_must_gt_O2TLMH_or_lt_O2TLML.Each_1_is_2.8_sec,_cannot_exceed_$7f
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
    ;mptbldesc Temperature_to_start_CLTIME_Timer_-_$94_=_70degreesF
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
    ;mptbldesc HighLimitForO2RampSwitching
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
    ;mptbldesc LowLimitForO2RampSwitching.__Rich_side_of_the_switch_limit.
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
    ;mptbldesc HighLimitForDelayedSwitchToClosedLoop._0.35v_This_is_not_a_F/A_ratio.
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
    ;mptbldesc LowLimitForDelayedSwitchToClosedLoop._0.55v_this_is_not_an_A/F_ratio.
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
    ;mptbldesc HighLimitForInMiddleDetermination._Lean_side_of_the_limit
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
    ;mptbldesc LowLimitForInMiddleDetermination._Used_for_Reverting_to_openLoop,_Setting_fault21,_outputting_O2_level_to_miller_tool.__This_is_the_rich_side_of_the_limit.
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
    ;mptbldesc Lower_RPM_Boundary_-_RPM/32
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
    ;mptbldesc Lower_RPM_Boundary_-_RPM/32
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
    ;mptbldesc O2_Range_Of_Authority_MaxMultiplier=1+O2LIMH/512_(cannot_be_above_$7f)
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
    ;mptbldesc O2_Range_Of_Authority_MinMultiplier=.5+O2LIML/512_(cannot_be_below_$80)
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
    ;mptbldesc AutoCalMapCellBoundary1
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
    ;mptbldesc AutoCalMapCellBoundary1
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
    ;mptbldesc AutoCalMapCellBoundary1
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
    ;mptbldesc AutoCalMapCellBoundary1
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
    ;mptbldesc AutoCalMapCellBoundary1
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
    ;mptbldesc Map_Hysteresis_At_Map_Cell_Boundaries
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
    ;mptbldesc RPM_Cell_Boundary
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
    ;mptbldesc Delta_RPM_at_RPM_Boundaries
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
    ;mptbldesc RPM_Delta_for_Idle_RPM_For_Closed_Throttle_Cell
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
    ;mptbldesc Hysteresis_for_IDLOFS
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
    ;mptbldesc O2_Controller_Deadband_Limit_For_Updating_Cells
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
    ;mptbldesc No_Cell_Update_Above_This_RPM_-_in_rpms/32
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
    ;mptbldesc No_Cell_Update_Above_This_MAP
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
    ;mptbldesc No_Cell_Update_below_PWMIN_-_this_value_times_4_uSec
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
    ;mptbldesc Number_of_Bits_Change_Per_Update_Within_A_Cell
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
    ;mptbldesc Starting_Temp_to_select_hot_or_cold_AM_timer
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc AM_temp_inhibit_time_from_coolant_temp
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc EPPs_Between_Cal_Change_Update_(Open_Throttle)
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
    ;mptbldesc AutoCal_Range_Of_Authority_where_MaxMultiplier=1+AMLIMH/512_(cannot_exceed_$7f)
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
    ;mptbldesc AutoCal_Range_Of_Authority_where_MinMultiplier=.5+AMLIML/512_(cannot_be_below_$80)
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Fuel_at_Part_Throttle._Other_tweaks_will_be_added_to_this_amount,_to_a_MAXIMUM_of_the_Full_Throttle_table_value.
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
    ;mptbldesc This_value_is_compared_against_the_MAP_Pressure
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc EPP_per_amount_for_increasing_multiplier
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc EPP_Control_toggle
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Fuel_at_Full_Throttle._This_is_also_a_maximum_for_the_Part_Throttle_value_after_other_tweaks_are_added.
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
    ;mptbldesc No_Cell_Update_And_O2CNTR_Held_Below_This_Map._Set_to_0xff_to_disable_O2_feedback.
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
    ;mptbldesc Base_Map_Fuel_Pulsewidth.
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
    ;mptbldesc Charge_Temp_Factor._Note_that_this_is_an_unfiltered_charge_temp_voltage,_so_higher_numbers_are_lower_temps
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
    ;mptbldesc Desc
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
    ;mptbldesc Desc
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
    ;mptbldesc Additive_Baro_Fuel_Compensation_-_fuel_added_based_on_altitude
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Pumping_Efficiency
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
    ;mptbldesc Compensates_for_slower_opening_times_of_injectors_with_lower_voltage.
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Cold_Load_Enrichment_Factor
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
    ;mptbldesc Cold_Load_Enrichment_Multiplier
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
    ;mptbldesc Coldenrichment_factor_=_1_+_(_(CurveA_*_ADVDCY/256_+_CurveC_*_ADVDCY/256_+_CurveB_*_FCRCVB/256_)_/_32_)_*_BAROCP/256
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
    ;mptbldesc Coldenrichment_factor_=_1_+_(_(CurveA_*_ADVDCY/256_+_CurveC_*_ADVDCY/256_+_CurveB_*_FCRCVB/256_)_/_32_)_*_BAROCP/256
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
    ;mptbldesc Coldenrichment_factor_=_1_+_(_(CurveA_*_ADVDCY/256_+_CurveC_*_ADVDCY/256_+_CurveB_*_FCRCVB/256_)_/_32_)_*_BAROCP/256
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
    ;mptbldesc Curve_A_Cold_Decay_Time_-_value_=_89.76_divided_by_this_number
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
    ;mptbldesc Curve_A_Hot_Decay_Time_-_value_=_89.76_divided_by_this_number
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
    ;mptbldesc Curve_A_Cold_Hold_time_-_value_=_this_number_times_.704_sec
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
    ;mptbldesc Curve_A_Hot_Hold_Time_-_value_=_this_number_times_.704_sec
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
    ;mptbldesc Temperature_switch_point_for_Curve_A_Hold_and_Decay_times
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
    ;mptbldesc Hold_Time_for_Curve_C_-_value_=_this_number_times_.704_sec
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
    ;mptbldesc Decay_Rate_for_Curve_C_-_value_=_89.76_divided_by_this_number
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
    ;mptbldesc Baro_compensation_of_Warmup_Factor
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
    ;mptbldesc Delta_modifier_added_to_engine_temp_after_a_stall_before_key_on._This_is_to_approximate_heat_soak
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
    ;mptbldesc Max_allowable_temp_for_RUNTMP_(heat_soak_approximation)
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
    ;mptbldesc MAP_Delta_required_to_trigger_transient_enrichment
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
    ;mptbldesc Maximum_Delta_MAP_allowed
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
    ;mptbldesc Transient_Enrichment_PW_Addition
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
    ;mptbldesc MAP_Transient_Enrich_Time_Constant_when_MAP_gt_AVMAP
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
    ;mptbldesc Positive_Transient_Enrich_Trigger_Level_in_volts_times_0.02
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
    ;mptbldesc Max_Delta_THR_(THR-AVTHR-POSTRG)_-_value_of_$26_is_.51_volts
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
    ;mptbldesc Throttle_Transient_Enrich_PW_Addition
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
    ;mptbldesc Throttle_Transient_Enrich_Time_Constant
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc lean_out_time_constant_based_on_MAP
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc AIS_motor_startup_position_from_engine_temp
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
    ;mptbldesc Additional_startup_idle_speed._x0D_=_104rpm
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
    ;mptbldesc Time_that_DRIDHT_is_used_-_x17_=_.65_seconds
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
    ;mptbldesc Idle_Speed_From_Temp_in_park/neutral_or_manual_trans
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
    ;mptbldesc Idle_Speed_From_temp_in_Drive,_auto_trans_only
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
    ;mptbldesc Cold_OffIdle_AIS_Positioning,_Increases_instantly,_decreases_after_DLYOFI
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
    ;mptbldesc Barometric_compensation_factor_for_AIS_control
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
    ;mptbldesc AIS_Position_from_throttle
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
    ;mptbldesc AIS_Position_from_RPMs
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc AIS:_AC_clutch_position_when_temp_to_cold
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc AIS:_Position_electronics_thinks_motor_is_(at_idle)
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
    ;mptbldesc AIS_update_rate_when_calibrating_-_rate=(CALRAT+1)*11ms_(can_be_0,1,3,7,f,1f,3f,7f,ff)
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Decel_AIS_open_steps_from_-Delta_MAP
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
    ;mptbldesc Decel_AIS_open_steps_from_+Delta_MAP
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
    ;mptbldesc AIS_Decel_Addition_to_control_MAP_vs._RPM
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
    ;mptbldesc AIS_Decel_Offset_correction_due_to_baro_effect
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
    ;mptbldesc AIS_Decel_Temperature_Term
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Decel_AIS_Delay_after_throttle_closes_when_moving
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
    ;mptbldesc Decel_AIS_Delay_after_throttle_closes_when_stopped
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Desc
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
    ;mptbldesc Desc
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
    ;mptbldesc Desc
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Switch_point_between_Decel_or_Idle_AIS_control._Note_there_is_also_a_1.5_mph_hysteresis
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
    ;mptbldesc Boost_Allowed_from_RPMs._Boost_is_defined_as_MAP_reading_above_Baro
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
    ;mptbldesc Boost_Allowed_from_time_in_boost._Boost_is_defined_as_MAP_reading_above_Baro
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
    ;mptbldesc Boost_Allowed_from_Engine_Temp._Boost_is_defined_as_MAP_reading_above_Baro
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
    ;mptbldesc Boost_Allowed_from_Charge_Temp._Boost_is_defined_as_MAP_reading_above_Baro._Charge_Temp_numbers_are_approximate_only
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
    ;mptbldesc Boost_Allowed_from_time_since_last_knock._Boost_is_defined_as_MAP_reading_above_Baro._Charge_Temp_numbers_are_approximate_only
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
    ;mptbldesc Boost_Allowed_from_Speed_to_protect_automatic_transmissions.
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
    ;mptbldesc Boost_Allowed_at_Part_Throttle._Boost_is_defined_as_MAP_reading_above_Baro
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
    ;mptbldesc Desc
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
    ;mptbldesc Desc
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
    ;mptbldesc WOT_WG_Duty_Cycle
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
    ;mptbldesc WOT_Duty_Cycle_Adjustment
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Min_RPM_to_increment_the_boost_error_timer.
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Wastegate_Duty_Cycle_Adjustment_boost_switch_point.
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Number_of_BoostErrTimer_counts_before_WG_Duty_Cycle_is_incremented._Used_when_boost_is_below_target.
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Number_of_BoostErrTimer_counts_before_WG_Duty_Cycle_is_incremented._Used_when_boost_is_below_target.
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc If_MAP_+_BARO_exceeds_MPSHOF,_wait_SHFDLT,_then_kill_engine_for_TRNTM._Overboost_-_$ff_to_disable
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
    ;mptbldesc If_MAP_+_BARO_exceeds_MPSHOF,_wait_SHFDLT,_then_kill_engine_for_TRNTM._Overboost_-_$ff_to_disable
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
    ;mptbldesc Overboost_shutoff_duration_-_$ff_to_disable_-_stock_$5a
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
    ;mptbldesc Overboost_Shutoff_when_Wastegate_problem_has_been_detected_(should_not_disable_this)
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
    ;mptbldesc 'On'_setpoint_for_high_speed_fan_control.
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
    ;mptbldesc 'Off'_setpoint_for_high_speed_fan_control.
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
    ;mptbldesc 'On'_setpoint_for_low_speed_fan_control.
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
    ;mptbldesc 'Off'_setpoint_for_low_speed_fan_control.
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
    ;mptbldesc Turns_fan_on_when_boost_is_over_this_level._Used_for_I/C_colling.
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
    ;mptbldesc Turns_fan_on_when_battery_temp_gets_too_high_for_proper_charging.
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Error_code_masking_bits._Check_the_box_to_enable_that_specific_error.
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
    ;mptbldesc Error_code_masking_bits._Check_the_box_to_enable_that_specific_error.
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
    ;mptbldesc Error_code_masking_bits._Check_the_box_to_enable_that_specific_error.
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
    ;mptbldesc Error_code_masking_bits._Check_the_box_to_enable_that_specific_error.
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
    ;mptbldesc If_no_O2_sensor_state_change_for_this_time(*2.8sec)_then_fault_51_or_52
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Map_limpin_and_throttle_above_25%_-_0x3f00=1850rpm
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
    ;mptbldesc Map_limpin_and_throttle_above_25%_-_0x3b00=2000rpm
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
    ;mptbldesc Map_gt_75%_of_Baro_and_IdleSwitch_Closed_OR_Map_gt_75%_of_Baro_and_Throttle_Limp-in_and_speed_lt_RVLSPD_-_0x3b00=2000rpm
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
    ;mptbldesc Map_gt_75%_of_Baro_and_IdleSwitch_Closed_OR_Map_gt_75%_of_Baro_and_Throttle_Limp-in_and_speed_lt_RVLSPD_-_0x2700=3000rpm
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
    ;mptbldesc Lower_limit_of_normal_operation_-_0x1300=6168rpm
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
    ;mptbldesc Upper_limit_of_normal_operation_-_0x119f=6650rpm
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Desc
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Map_Scale_multiplier._This_is_the_slope_constant_for_the_MAP_sensor_transfer_function._#07_is_the_original_Mopar_2-bar_constant._#09_for_the_S60_3-bar_sensor._The_GM_or_MSD_3-Bar_sensors_may_need_these_values_changed_for_accuracy.
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
    ;mptbldesc Scale_MAP_Volts_to_MAP_add_constant:_This_is_the_offset_constant_for_the_MAP_sensor_transfer_function._#0361_is_the_original_Mopar_2-bar_constant._#0700_for_the_S60_3-bar_sensor._The_GM_or_MSD_3-Bar_sensors_may_need_these_values_changed_for_accuracy.
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Detailed_Description
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
    ;mptbldesc Staging_mod_speed_shutoff
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
    ;mptbldesc Staging_mod_shutoff_-_0x2300=3300rpm
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
    ;mptbldesc Staging_mod_shutoff2_-_0x2100=3500rpm
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
    ;mptbldesc Switch_that_will_activate_the_staging_limiter._If_no_switch_is_selected,_then_the_staging_limiter_is_enabled_by_speed_only.
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
    ;mptbldesc Curve_for_retard_based_on_delta_MAP_for_anti-lag_feature._This_will_be_subtracted_from_the_calculated_spark_advance.
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
    ;mptbldesc Description
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
    ;mptbldesc Description
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
    ;mptbldesc Description
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
    ;mptbldesc Description
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
    ;mptbldesc Description
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
    ;mptbldesc Description
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
    ;mptbldesc The_min_temp_allowed_before_the_CE_light_is_flashed._To_avoid_false_indication_on_a_cold_engine.
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
    ;mptbldesc Shift_light_setpoint.
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
    ;mptbldesc Battery_volts_target_when_at_WOT.
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
    ;mptbldesc Switch_that_will_activate_high_boost_mode._If_no_switch_is_selected,_then_theboost_is_not_selectable,_and_the_Low_Boost_curve_needs_to_be_setup_as_the_high_boost_curve.
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
    ;mptbldesc Lo_boost_clip_point_for_switchable_boost.
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
    ;mptbldesc Selective_bank_enrichment_factor_from_MAP.
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
    ;mptbldesc Selective_bank_enrichment_factor_from_RPM.
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
    ;mptbldesc Bank_to_enrich._Only_1_should_be_selected.
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
    ;mptbldesc The_1st_2_digits_are_the_model_year,_2nd_2_digits_are_the_engine_and_trans_type.
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

