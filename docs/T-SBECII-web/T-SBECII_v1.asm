	.title 92_25_t1_xTX_125.asm
	.area ROM (ABS)
	
; SET TABS to 4 if text appears jumbled
;  ____________________________________________________________________________
; |									       \
; |									       |
; |   Mopar ECM T1 SBECII						       |
; |   Based on 1992 SBECII TurboI Codebase			               |
; |									       |
; | Code and original design and data Copyright 1990 by Chrysler Corporation   |
; | This relocateable source is Copyright 2011 by Robert Lloyd		       |
; | Modified code modules are Copyright 2011 by Robert Lloyd           	       |
; |				  by Robert Lloyd			       |
; | 1) Added option config constant for new module options.		       |
; | 2) Added switchable boost option, changed code from previous "mod" to      |
; |    in-line code; allow for enable/disable by option register.	       |
; | 3) Added staging rev limiter (2-step). User can enable/disable in code, or |
; |    by button by the driver, and by speed.				       |
; | 4) Added anti-lag code. Pulls timing when transitioning from P/T to WOT    |
; |    and while the staging limiter is enabled.                               |
; | 5) Added CE Flash for knock indication. CE Light flashes in proportion to  |
; |    knock retard.                                                           |
; |									       |
; |    * indicates in progress or planned           			       |
; \____________________________________________________________________________|
;
; -----------------------------------------------------------------------------
; History
;
; Version 1.0 
; 04/18/11 - Assembles to (nearly) the original binary.
;          - Added basic Turbonator features (CE Flash, Switchable Boost, 
;            Staging Limiter, Anti-Lag).
;

version == 01

; ***********************************************************************

; Routines ending with "_MM" are called from MainProgramLoop.

; ***********************************************************************
; Code/data can be org'd anywhere in the $8000-$ffd5 range, except
; you MUST leave a hole from $b600-$b7ff (on chip eeprom). The interrupt
; vectors must be from $ffd6-$ffff.
; ***********************************************************************

DataOrg == 0x8000
CodeOrg == 0x9400

; ***********************************************************************
; These variables can be changed, then the source recompiled.
; ***********************************************************************

IncludeFillerBytes = 1	    ; 1=stock - to ensure exact byte for byte reloc

; *****************************************************************************
; Calibration Template definition
; *****************************************************************************
;
; This is the calibration template for T-SBEC.
;
; This template format will be used from T-SBEC v15 and later.
;
; I decided to switch to this format because it was getting clumsy
; trying to define the switches for all of the build options (MTX/ATX, 
; 2.2/2.5, boost control, etc.). This way, all the calibration data can be
; kept together in 1 place.
;
; T-SBEC and T-SMEC do have compatible template files formats and the 2 
; CAN NOT be interchanged. This is due to the different code structures 
; between the SMEC and SBEC.
;
; The relative positions of the data structures should not be changed.
; But, the calibration values can be changed at will to any value you wish.
; Or, to match any exsisting calibration.
;
; Eventually, I'd like to create a 'new' cal editor that actually edits
; this tempalte rather than editing the binary file as CHeM and D-Cal 
; currently do.
;
; Filename format:
;
;    T-SBEC_[displ]_[trans]_[ID]_[version].asm
;
; For example, the 1st tempalte file I made was from the 89 T1 Auto:
;
;    T-SBEC_25_ATX_1336.asm
;
; This way you can start your T-SMEC build with any calibration. Though,
; you may have to build a template file if you want a calibration that
; does not already have a template file.
;

.define CalDataFile /C:\Users\Rob\Google Drive\BoostButton\Products\Cal Data\Customer Files\Felipe  Orejel\T-SBECII_25_246Mex_Felipe.tpl/
        
;
; ***********************************************************************
; Injector flow rate
; ***********************************************************************
;
; The 'current' injector flow rate is defined in the template.
; here, input a 'new' injector scaling for use by the post-link program.

; MP Tuner handles injector scaling. You can un-comment these lines if you are not using MP Tuner...
;        .inj new 34.9
        
;
; ***********************************************************************
; Engine Type and Flow Rate (at 55psi)
; 1985 - 1988 2.2L Turbo I		       - 27 lbs/hr
; 1987 - 1988 2.2L Turbo II		       - 32 lbs/hr
; 1988 - 1993 2.5L Turbo I		       - 34.85 lbs/hr
; 1989 - 1990 2.2L Turbo II		       - 34.85 lbs/hr
; 1991 - 1993 2.2L Turbo III		       - 34.85 lbs/hr
; 1989 - 1990 2.2L Turbo IV		       - 34.85 lbs/hr
; Mopar Performance "803s" (P4452803)	       - 27 lbs/hr
; Mopar Performance "804s" (P4452804)	       - 34.85 lbs/hr
; Mopar Performance +20% (P4529495)	       - 42 lbs/hr
; Mopar Performance +40% "Super 60" (P5249452) - 52 lbs/hr
;
; ***********************************************************************
; CHeM2 CalX Header Info

    chem2 title TurbonatorSBECIIv1
    chem2 description 1991 Chrysler Turbo III SBEC Calibration
    chem2 author Robert Lloyd
    chem2 boost 12 psi
    chem2 inj 34.9 pph

; NOTE: the above information is strictly informative. Changing the numbers
; above will NOT change anything in the source. You must use ChEM to               
; change the injectors and desired boost.
;
; ***********************************************************************
;
; Bit functions:
; Many bytes in the RAM contain status bits. For each of these the address value
; was separated into bit numbers, for example Flags_50 has b50_bit7 through b50_bit0.
; As the function of the bits was decoded, a global replace was performed to replace
; the bit name with a meaningful name, like:
;
;	b50_SparkEngineNotRunning   = $%10000000		;  -10000000-
;
; When working with bits, you can add several together using the "or" operator | like this:
;
;	b50_SparkEngineNotRunning | b50_BaroSolEnergized	;  -10100000-
;
; The inverse function ~ sets all bits except the ones specified, so:
;
;	~b50_SparkEngineNotRunning				;  -01111111-
;
; You can combine the inverse ~ with the or | like this:
;
;	~(b50_SparkEngineNotRunning | b50_BaroSolEnergized)	;  -01011111-
;
; The intent here was to make the logical functionality of the code easier to follow.
;
; ***********************************************************************
;
; 68HC11 Disassembly
;    Mopar ECM
; 
; Custom disassembler
; Copyright � 2011 by Robert Lloyd.
;

; generic bits:

bit_bit7			= $%10000000	;
bit_bit6			= $%01000000	;
bit_bit5			= $%00100000	;
bit_bit4			= $%00010000	;
bit_bit3			= $%00001000	;
bit_bit2			= $%00000100	;
bit_bit1			= $%00000010	;
bit_bit0			= $%00000001	;
bit_tophalf			= $%11110000	; top 4 bits
bit_bothalf			= $%00001111	; bottom 4 bits
bit_toptwo			= $%11000000	; top 2 bits
bit_bottwo			= $%00000011	; bottom 2 bits
bit_all 			= $%11111111	; all bits
bit_none			= $%00000000	; not bits

L0000	                                 == 0x0000
L0001	                                 == 0x0001
L0002	                                 == 0x0002
L0003	                                 == 0x0003
L0004	                                 == 0x0004
MINTHR_LowestSessionTPS	                 == 0x0005
DCCOR0_AdaptiveVNTCell0	                 == 0x0006
DCCOR1_AdaptiveWastegateCellBelow3psi	 == 0x0007
DCCOR2_AdaptiveWastegateCellTo4000rpm	 == 0x0008
DCCOR3_AdaptiveWastegateCellTo4992rpm	 == 0x0009
DCCOR4_AdaptiveWastegateCellTo5504rpm	 == 0x000a
Timer_DacalCountdown	                 == 0x000b
AISACCompensation	                 == 0x000c
CurrentAisPosition	                 == 0x000d
BitFlags_AIS	                         == 0x000e
AutoCalCell0	                         == 0x000f
AutoCalCell1	                         == 0x0010
AutoCalCell2	                         == 0x0011
AutoCalCell3	                         == 0x0012
AutoCalCell4	                         == 0x0013
AutoCalCell5	                         == 0x0014
AutoCalCell6	                         == 0x0015
AutoCalCell7	                         == 0x0016
AutoCalCell8	                         == 0x0017
AutoCalCell9	                         == 0x0018
AutoCalCell10	                         == 0x0019
AutoCalCell11	                         == 0x001a
AutoCalCell12idle	                 == 0x001b
AutoCalCellEnd	                         == 0x001c
ErrorBitRegister0	                 == 0x001d
ErrorBitRegister1	                 == 0x001e
ErrorBitRegister2	                 == 0x001f
ErrorBitRegister3	                 == 0x0020
ErrorBitRegisterStored0	                 == 0x0021
ErrorBitRegisterStored1	                 == 0x0022
ErrorBitRegisterStored2	                 == 0x0023
ErrorBitRegisterStored3	                 == 0x0024
ErrorCodeUpdateKeyOnCount	         == 0x0025
ErrorCodeUpdateKeyOnCount2	         == 0x0026
ErrorCodeUpdateKeyOnCount3	         == 0x0027
Cyl2_InjPWTrim	                         == 0x0028
Cyl1_InjPWTrim	                         == 0x0029
Cyl3_InjPWTrim	                         == 0x002a
Cyl4_InjPWTrim	                         == 0x002b
CylTrimFlags	                         == 0x002c
L002D	                                 == 0x002d
L002E	                                 == 0x002e
L002F	                                 == 0x002f
L0030	                                 == 0x0030
Counter_SpeedSensorInterrupt_HB	         == 0x0031
Counter_SpeedSensorInterrupt_LB	         == 0x0032
AdaptiveRetardIndex	                 == 0x0033
Timer_BoostOver5psi	                 == 0x0034
CCDBatteryVoltsOutput	                 == 0x0035
PointlessFuelFactor	                 == 0x0036
BitFlags37	                         == 0x0037

    bf37_ATX                   	= $%00100000
    bf37_ATXInDrive             = $%00010000
    bf37_BOV                    = $%00000001

PreviousCoolantTemp	                 == 0x0038
EngineRunningTimeMaxFF	                 == 0x0039
Timer_BoostTimer	                 == 0x003a
CurrentWastegatePosition	         == 0x003b
Timer_BoostErrTimer	                 == 0x003c
StartupSwitchMirror1	                 == 0x003d
    sw1_bit7           	        = $%10000000	;
    sw1_ACclutch       	        = $%01000000	; A/C Clutch input
    sw1_CruiseSet              	= $%00100000	; Cruise Set
    sw1_bit4                    = $%00010000	;
    sw1_CruiseOnOff         	= $%00001000	; Cruise On/Off
    sw1_Brake          		= $%00000100	; Brake Switch
    sw1_CruiseResume   		= $%00000010	; Cruise Resume
    sw1_PNswitch                = $%00000001	; Park/Neutral switch
PIA2_Buffer	                         == 0x003e
    pia_bit7                    = $%10000000
    pia_KnockCap                = $%01000000    
    pia_ChargeTemp              = $%00100000    
    pia_CoolantTemp             = $%00010000
    pia_FuelMon                 = $%00001000    
    pia_bit2                    = $%00000100    
    pia_Tach                    = $%00000010    
    pia_bit0                    = $%00000001

CCDFlags2	                         == 0x003f
CCDFlags3	                         == 0x0040
StartupSwitchMirror2	                 == 0x0041
    sw2_bit7           	        = $%10000000	;
    sw2_ACclutch       	        = $%01000000	; A/C Clutch input
    sw2_CruiseSet              	= $%00100000	; Cruise Set
    sw2_bit4                    = $%00010000	;
    sw2_CruiseOnOff         	= $%00001000	; Cruise On/Off
    sw2_Brake          		= $%00000100	; Brake Switch
    sw2_CruiseResume   		= $%00000010	; Cruise Resume
    sw2_PNswitch                = $%00000001	; Park/Neutral switch

PIA1_Buffer	                         == 0x0042
    pia_Fan                     = $%10000000
    pia_CEL                     = $%01000000
    pia_bit5                    = $%00100000
    pia_Baro                    = $%00010000
    pia_bit3                    = $%00001000
    pia_bit2                    = $%00000100
    pia_bit1                    = $%00000010
    pia_bit0                    = $%00000001

CruiseStatus_1	                         == 0x0043
CruiseStatus_2	                         == 0x0044
Counter_Cruise_1	                 == 0x0045
Counter_Cruise	                         == 0x0046
Counter_TimerRegHalfOverflowBetweenSpeedoPulses	 == 0x0047
PreviousVehicleSpeed_HB	                 == 0x0048
PreviousVehicleSpeed_LB	                 == 0x0049
TimerOverflowsBetweenSpeedoPulses	 == 0x004a
SpeedoSensorPulsewidth_HB	         == 0x004b
SpeedoSensorPulsewidth_LB	         == 0x004c
VehicleSpeed_HB	                         == 0x004d
VehicleSpeed_LB	                         == 0x004e
VehicleSpeedScaled	                 == 0x004f
Counter_Cruise_2	                 == 0x0050
Counter_Cruise_3	                 == 0x0051
CruiseSpeedSetpoint	                 == 0x0052
CruiseControlVar0	                 == 0x0053
CruiseControlVar1	                 == 0x0054
CruiseControlVar2	                 == 0x0055
CruiseControlVar3	                 == 0x0056
CruiseControlVar4	                 == 0x0057
ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB	 == 0x0058
ErrorBitsAssociatedWithPIA1AndReg1eTo25_LB	 == 0x0059
ClearTheErrorTimer_0	                 == 0x005a
ClearTheErrorTimer_1	                 == 0x005b
b5C_IPL1	                         == 0x005c
b5D_IPL2	                         == 0x005d
BitFlags5E	                         == 0x005e
ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR	 == 0x005f
TimerOverflowsBetweenDistPulses	         == 0x0060
DistributorFallingEdgePulsewidth_HB	 == 0x0061
DistributorFallingEdgePulsewidth_LB	 == 0x0062
Counter_TimerPastHalfwayBetweenCamPulses == 0x0063
LastDistributorFallingEdgeTime	         == 0x0064
BitFlags65	                         == 0x0065
    b65_bit7			= $%10000000	;
    b65_bit6			= $%01000000	;
    b65_bit5			= $%00100000	;
    b65_bit4			= $%00010000	;
    b65_bit3			= $%00001000	;
    b65_bit2			= $%00000100	;
    b65_bit1			= $%00000010	;
    b65_bit0			= $%00000001	;
BitFlags66	                         == 0x0066
    b66_OffIdle 		= $%10000000	; Throttle Pressed
    b66_UpdatedMINTHR		= $%01000000	; Minimum Throttle Value has been updated with an actual value
    b66_OpenLoop		= $%00100000	; Not In Closed Loop ;Oxygen Sensor Stuck
    b66_O2Valid 		= $%00010000	; Oxygen Sensor Has Been Outside .75V to .29V Range
    b66_PartThrottle		= $%00001000	; Throttle Lightly Pressed
    b66_O2Rich			= $%00000100	; Oxygen Sensor on the Rich Side
    b66_PTEisMaxed		= $%00000010	; Part Throttle Enrichment is maxed
    b66_FullThrottle		= $%00000001	; Throttle Floored
BitFlags67	                         == 0x0067
    b67_Purge			= $%10000000	; Canister Purge
    b67_FallToIdle		= $%01000000	; Engine Speed Too High to be Idling
    b67_InMotion		= $%00100000	; Something to do with vehicle moving
    b67_StayOpenLoop		= $%00010000	; Dont Try Closed Loop
    b67_IdleSpeedMode		= $%00001000	; Dont Control Idle Speed (if clear dont control AIS, if set dont control idle with Injectors)
    b67_OpenLoop		= $%00000100	; Currently Open Loop
    b67_bit1			= $%00000010	; Something with reg 73
    b67_bit0			= $%00000001	;
BitFlags68	                         == 0x0068
    b68_bit7	                = $%10000000	; Spark - Engine Not Running
    b68_SparkEngineNotRunning	= $%01000000	; AIS Stuff
    b68_BaroSolEnergized	= $%00100000	;
    b68_ASDon			= $%00010000	; ASD ON
    b68_SpeedOver40		= $%00001000	; SPEED GREATER THAN 40 MPH
    b68_Past12secRunning	= $%00000100	; ENGINE RUNNING MORE THAN 12 sec OR KEY ON FOR MORE THAN 12 sec
    b68_BladePassedSensor	= $%00000010	; WINDOW BLADE HAS PASSED THROUGH DISTRIBUTOR SYNC SENSOR
    b68_EndOfBlade		= $%00000001	; END OF ANY BLADE AT DISTRIBUTOR REF SENSOR
BitFlags69	                         == 0x0069
    b69_bit7        		= $%10000000	; Coolant temp filter/store?
    b69_bit6			= $%01000000	; Coolant temp filter/store?
    b69_AtIdle			= $%00100000	; Just returned to idle
    b69_AcClutch		= $%00010000	; AC clutch engaged
    b69_bit3			= $%00001000	; ?
    b69_bit2			= $%00000100	; AC?
    b69_bit1			= $%00000010	;
    b69_bit0			= $%00000001	;
    b69_BadO2Read		= $%00000011    ; Indicates a bad O2 sensor reading?
BitFlags6A	                         == 0x006a
    b6a_Cruise4 		= $%10000000	; cruise bit
    b6a_Cruise3 		= $%01000000	; cruise bit
    b6a_Cruise2 		= $%00100000	; cruise bit
    b6a_Cruise1 		= $%00010000	; cruise bit
    b6a_OverRev 		= $%00001000	; OverRevving
    b6a_FuelOff 		= $%00000100	; Shut Off Fuel
    b6a_DRBToggle2		= $%00000010	; DRBII Toggle
    b6a_DRBToggle1		= $%00000001	; DRBII Toggle
BitFlags6B	                         == 0x006b
    b6b_bit7			= $%10000000	;
    b6b_bit6			= $%01000000	;
    b6b_bit5			= $%00100000	; Coil Test
    b6b_bit4			= $%00010000	;
    b6b_bit3			= $%00001000	;
    b6b_bit2			= $%00000100	;
    b6b_DecelFuelCut	        = $%00000010	; Purge Solenoid
    b6b_bit0			= $%00000001	; Coil Test
BitFlags6C	                         == 0x006c
    b6c_VNTOvBst		= $%10000000	; VNT Overboost
    b6c_bit6			= $%01000000	;
    b6c_bit5			= $%00100000	;
    b6c_DRBModeFlag		= $%00010000	; indicates system is in DRB test mode
    b6c_bit3			= $%00001000	;
    b6c_bit2			= $%00000100	;
    b6c_bit1		        = $%00000010	;
    b6c_EMR_1			= $%00000001	; emission maint reminder
BitFlags6D	                         == 0x006d
    b6d_bit7              	= $%10000000
    b6d_bit6		        = $%01000000
    b6d_bit5		        = $%00100000
    b6d_bit4		        = $%00010000
    b6d_bit3	                = $%00001000
    b6d_bit2		        = $%00000100
    b6d_bit1	                = $%00000010
    b6d_bit0		        = $%00000001
BitFlags6E	                         == 0x006e
    b6e_BoostOver5psi		= $%10000000	; Boost Greater than 5 PSI
    b6e_WastegateDC		= $%01000000	; Current WasteGate Duty Cycle
    b6e_DistSync		= $%00100000	; Distributor Sync Value
    b6e_UseSparkScatter 	= $%00010000	; Use Spark Scatter
    b6e_SearchBladeEndRef	= $%00001000	; Search for end of window blade on Reference Signal
    b6e_bit2		        = $%00000100	; Oxygen Sensor Enable or something with CAM position bits not in sync with distributor
    b6e_InjectorB		= $%00000010	; CAM Position Bit 1 - this bit controls InjectorB
    b6e_InjectorA		= $%00000001	; CAM Position Bit 0 - this bit controls InjectorA
    b6e_InjectorAandB		= $%00000011	; Both b6e_InjectorB and b6e_InjectorA
BitFlags6F	                         == 0x006f
    b6f_FuelEngineNotRunning	= $%10000000	; Fuel - Engine Not Running
    b6f_bit6		        = $%01000000
    b6f_JustStarted    		= $%00100000
    b6f_Starting        	= $%00010000
    b6f_BaroOkEngineStopped	= $%00001000
    b6f_bit2		        = $%00000100
    b6f_DisableNormalDwell	= $%00000010
    b6f_NeedSetup	        = $%00000001
BitFlags70	                         == 0x0070
    b70_bit7			= $%10000000
    b70_bit6			= $%01000000
    b70_O2Enable                = $%00100000
    b70_AlternatorField	        = $%00010000    ; AlternatorField
    b70_bit3		        = $%00001000
    b70_bit2			= $%00000100
    b70_bit1		        = $%00000010
    b70_bit0		        = $%00000001
BitFlags71	                         == 0x0071

    b71_BadO2                   = $%00000100

BitFlags72	                         == 0x0072
    b72_bit7			= $%10000000
    b72_bit6			= $%01000000
    b72_O2Enable                = $%00100000
    b72_AlternatorField	        = $%00010000    ; AlternatorField
    b72_SearchBladeEndRef	= $%00001000
    b72_bit2			= $%00000100
    b72_InjectorB	        = $%00000010
    b72_InjectorA	        = $%00000001
    b72_InjectorAandB           = $%00000011
    
TargetIdleSpeedHB	                 == 0x0073
TargetIdleSpeedLB	                 == 0x0074
EngineRpm_HB	                         == 0x0075
EngineRpm_LB	                         == 0x0076
ChargeTempVolts	                         == 0x0077
BaroPressure	                         == 0x0078
MapVolts	                         == 0x0079
MapValueRaw	                         == 0x007a
MapTemp	                                 == 0x007b
MapAverageValue_HB	                 == 0x007c
MapAverageValue_LB	                 == 0x007d
MapValue	                         == 0x007e
Factor_LeanoutOrEnrichTime_MAP	         == 0x007f
TpsAverageValue_HB	                 == 0x0080
TpsAverageValue_LB	                 == 0x0081
TPSVolts	                         == 0x0082
Factor_LeanoutOrEnrichTime_TPS	         == 0x0083
Timer_DelayBeforeUpdating_MINTHR	 == 0x0084
TpsVoltsOverMINTHR	                 == 0x0085
CoolantTemp	                         == 0x0086
BatteryVolts	                         == 0x0087
O2SensorVolts	                         == 0x0088
LastTpsVolts	                         == 0x0089
LastCoolantTempVolts	                 == 0x008a
LastChargeTempVolts	                 == 0x008b
KnockVolts	                         == 0x008c
AmbientAirTempVolts	                 == 0x008d
TempAmbientAirTempVolts	                 == 0x008e
TimeEngineRunningAlt	                 == 0x008f
Timer_FuelEnrich	                 == 0x0090
InjectorLatencyPW	                 == 0x0091
MAPRescaledfor3D	                 == 0x0092
RPMRescaledfor3D	                 == 0x0093
SumOfFuelModifiers_HB	                 == 0x0094
SumOfFuelModifiers_LB	                 == 0x0095
InjectorPulsewidth_HB	                 == 0x0096
InjectorPulsewidth_LB	                 == 0x0097
BaseInjectorPulsewidth_HB	         == 0x0098
BaseInjectorPulsewidth_LB	         == 0x0099
BaseFuelModifier	                 == 0x009a
BaseFuelModifier_LB                      == 0x009b
ThrottleFactor	                         == 0x009c
BaroCompFactorFuel	                 == 0x009d
ChargeTempCompFactorFuel	         == 0x009e
BaseInjectorPulsewidthX	                 == 0x009f
BaseInjectorPulsewidthX_LB               == 0x00a0
Factor_StartFuelDecayIntoRunFuel	 == 0x00a1
Factor_DecelLeanoutWhenMAPDecreasing	 == 0x00a2
L00A3	                                 == 0x00a3
Timer_OpenLoopFraction	                 == 0x00a4
Timer_O2InhibitSwitchingRichIdleToClosedLoop	 == 0x00a5
Pulsewidth_PartThrottleEnrichment_HB	 == 0x00a6
L00A7	                                 == 0x00a7
Pulsewidth_AISEnrichment_HB	         == 0x00a8
Pulsewidth_PartThrottleEnrichment_LB2	 == 0x00a9
Counter_FallingEdgeEPP_MaxFF	         == 0x00aa
Counter_EPP_MaxFF	                 == 0x00ab
TargetBatteryVolts	                 == 0x00ac
Counter_O2SensorFeedbackCount_Signed     == 0x00AD
Timer_CountdownFromStartRunForAisFeedback	 == 0x00ae
KeyOnOrEngineRunningTime	         == 0x00af
Counter_MainLoop	                 == 0x00b0
EngineRunningTimeBeforeStall	         == 0x00b1
Timer_AlternatorDutyCycle	         == 0x00b2
CountdownTimerFromKeyOn	                 == 0x00b3
Timer_CLTIME_ClosedLoopTimer	         == 0x00b4
Counter_AdaptiveMem_Erase	         == 0x00b5
Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop	 == 0x00b6
AdaptiveCellUpdateTimer_IncrementedEveryCamRisingEdge	 == 0x00b7
PointerIntoAdaptiveMemory	         == 0x00b8
ValueFromAdaptiveMemory	                 == 0x00b9
AntiDwellTime_HB	                 == 0x00ba
AntiDwellTime_LB	                 == 0x00bb
Timer_OutOfClosedLoopMode	         == 0x00bc
Timer_O2ToggleDuration	                 == 0x00bd
DesiredNewAisPosition	                 == 0x00be
Counter_AISACCompensation	         == 0x00bf
Timer_AisOrO2Sensor	                 == 0x00c0
Timer_AcClutchEngageRestrictionTimer	 == 0x00c1
Counter_IdleControl	                 == 0x00c2
BaroAISComp	                         == 0x00c3
Timer_AisChanges	                 == 0x00c4
Timer_AcSomething	                 == 0x00c5
Timer_AcCutout	                         == 0x00c6
ACClutchToggleVar	                 == 0x00c7
Counter_AirCond	                         == 0x00c8
Timer_RadSteamingCountdown	         == 0x00c9
Timer_MinimumFanRun	                 == 0x00ca
Timer_NormalDwell	                 == 0x00cb
Timer_OverboostCountdown	         == 0x00cc
Timer_Over5PsiBoostMaxFF	         == 0x00cd
CalculatedSparkAdvance	                 == 0x00ce
Cylinder2Retard	                         == 0x00cf
Cylinder1Retard	                         == 0x00d0
Cylinder3Retard	                         == 0x00d1
Cylinder4Retard	                         == 0x00d2
MaxRetardFromMAP	                 == 0x00d3
L00D4	                                 == 0x00d4
KnockSensorThreshold	                 == 0x00d5
Timer_BaroReadInterval	                 == 0x00d6
Timer_BaroReadRpmConditionsSatisfied	 == 0x00d7
Timer_O2MiddleDiagnostics	         == 0x00d8
PreviousBoostOverBaro	                 == 0x00d9
BoostDelta_Signed	                 == 0x00da
BoostTarget	                         == 0x00db
DRBOffsetStored_HB	                 == 0x00dc
DRBOffsetStored_LB	                 == 0x00dd
ATMOffset	                         == 0x00de
DRBPointer1	                         == 0x00df
DRBPointer2	                         == 0x00e0
DRBPointer3	                         == 0x00e1
DRBSerialMode	                         == 0x00e2
CCDVar0	                                 == 0x00e3
L00E4	                                 == 0x00e4
L00E5	                                 == 0x00e5
L00E6	                                 == 0x00e6
L00E7	                                 == 0x00e7
L00E8	                                 == 0x00e8
CCDFlags4	                         == 0x00e9
CCDFlags5	                         == 0x00ea

    ccd_AlarmDisable	        = $%00100000	; bit to indicate that the engine should not run due to alarm status

CCDFlags6	                         == 0x00eb
WastegateDCDecayCounter	                 == 0x00ec
L00ED	                                 == 0x00ed
CylTrim_Adaptive_Var1	                 == 0x00ee
CylTrim_FlagsEF	                         == 0x00ef
CylTrim_FlagsF0	                         == 0x00f0
Counter_FuelEngRunning	                 == 0x00f1
EGRVar2	                                 == 0x00f2
TempX	                                 == 0x00f3
TempA	                                 == 0x00f4
L00F5	                                 == 0x00f5
FDRVar0	                                 == 0x00f6
Temp0	                                 == 0x00f7
Temp1	                                 == 0x00f8
Temp2	                                 == 0x00f9
Temp3	                                 == 0x00fa
Temp4	                                 == 0x00fb
Temp5	                                 == 0x00fc
Temp6	                                 == 0x00fd
Temp7	                                 == 0x00fe
L00FF	                                 == 0x00ff

CPU_PortA	                         == 0x1000
CPU_L1001_Reserved	                 == 0x1001
CPU_PortIOControl	                 == 0x1002
CPU_PortC	                         == 0x1003
CPU_PortB	                         == 0x1004
CPU_PortCL	                         == 0x1005
CPU_L1006Reserved	                 == 0x1006
CPU_PortC_DataDirection	                 == 0x1007
CPU_PortD	                         == 0x1008
CPU_PortD_DataDirection	                 == 0x1009
CPU_PortE	                         == 0x100a
CPU_HardwareTimerForceCompare	         == 0x100b
CPU_OutputCompare1Mask	                 == 0x100c
CPU_OutputCompare1D	                 == 0x100d
CPU_TimerCounterRegHigh	                 == 0x100e
CPU_DistPickupCaptureRegHigh	         == 0x1010
CPU_TimerInputCapture2_Speedometer	 == 0x1012
CPU_TimerInputCapture3	                 == 0x1014
CPU_TimerOutputCompareRegHigh1	         == 0x1016
CPU_Timer_OC2	                         == 0x1018
CPU_Timer_OC3_Wastegate	                 == 0x101a
CPU_Timer_OC4_DwellA	                 == 0x101c
CPU_Timer_OC5_DwellB	                 == 0x101e
CPU_TimerControlReg1	                 == 0x1020
CPU_TimerControlReg2	                 == 0x1021
CPU_TimerInterruptMask1	                 == 0x1022
CPU_TimerInterruptFlag1	                 == 0x1023
CPU_TimerInterruptMask2	                 == 0x1024
CPU_TimerInterruptFlag2	                 == 0x1025
CPU_PortA_Control	                 == 0x1026
CPU_PulseAccCounterRegister	         == 0x1027
CPU_SerialPeripheralControl	         == 0x1028
CPU_SerialPeripheralStatus	         == 0x1029
CPU_SerialPeripheralDataIO	         == 0x102a
CPU_SerialBaudRate	                 == 0x102b
CPU_SerialControlReg1	                 == 0x102c
CPU_SerialControlReg2	                 == 0x102d
CPU_SerialStatus	                 == 0x102e
CPU_SerialData	                         == 0x102f
CPU_A2DControlReg	                 == 0x1030
CPU_A2DResults1	                         == 0x1031
CPU_A2DResults2	                         == 0x1032
CPU_A2DResults3	                         == 0x1033
CPU_A2DResults4	                         == 0x1034
CPU_BlockProtReg	                 == 0x1035
CPU_SysConfigOptionReg	                 == 0x1039
CPU_ArmResetCopTimerReg	                 == 0x103a
CPU_EEPROMControlReg	                 == 0x103b
CPU_HighPriorityInterruptMask	         == 0x103c
CPU_SysInit	                         == 0x103d
SystemConfigReg	                         == 0x103f

SwitchPortAccessReg1	                 == 0x6400
SwitchPortAccessReg2	                 == 0x6401
PIA_Ctrl_1	                         == 0x6402
PIA_Ctrl_2	                         == 0x6403
PIA_Ctrl_3	                         == 0x6404
PIA_Ctrl_4	                         == 0x6405
PIA_Ctrl_5	                         == 0x6406
InjectorPulsewidth_HB_Cyl1	         == 0x6408
InjectorPulsewidth_HB_Cyl2	         == 0x640a
InjectorPulsewidth_HB_Cyl3	         == 0x640c
InjectorPulsewidth_HB_Cyl4	         == 0x640e
PortX_Control	                         == 0x6440

ErrorCodeCounter	                 == 0x6480
AdvanceDownCounter_A	                 == 0x6481
EGR_Temp_1	                         == 0x6483
EGR_Temp_2	                         == 0x6484
FuelCompFactor_X	                 == 0x6485
CCDTemp_X	                         == 0x6486
MAPOffsetForCylTrim	                 == 0x6487
CCDCounterX	                         == 0x6488
MapValueX	                         == 0x6489
MapVoltsX	                         == 0x648a
DeltaBoostSampleCounter	                 == 0x648b
MapValue_X	                         == 0x648c
MapVolts_X	                         == 0x648d
BitFlags648e	                         == 0x648e
BatVoltsDiagCounter	                 == 0x648f
A2DResults2Temp	                         == 0x6490
ColdStartFuelReduxCounter	         == 0x6491
Factor_DecelLeanoutWhenMAPDecreasing_Temp	 == 0x6492
Timer_OpenLoopFraction2	                 == 0x6493
SparkScatter	                         == 0x6494
O2AdvanceIncrement	                 == 0x6495
AdvanceTemp	                         == 0x6496
FuelLookupValue3D	                 == 0x6497
PreviousMAPTemp	                         == 0x649c
DownCounterUnknown	                 == 0x649d
DwellTime_HB	                         == 0x649e
EngineRPM_Temp	                         == 0x64a0
DeltaEngineRPM_1	                 == 0x64a1
RetardFrom_DeltaEngineRPM_1	         == 0x64a2
Counter_DeltaEngineRPM_1	         == 0x64a3
FilteredTPSOverMINTHR_A	                 == 0x64a4
FilteredTPSOverMINTHR_B	                 == 0x64a6
MaxAdvanceLookup	                 == 0x64a8
AdaptiveRetardValue_A	                 == 0x64a9
KnockRetardSum_AllCyls	                 == 0x64aa
EngineRPMTemp	                         == 0x64ab
DistPWTemp	                         == 0x64ad
DeltaRPMFractionReducing	         == 0x64af
DeltaRPMOverDistPWFraction	         == 0x64b1
DeltaRPMSigned	                         == 0x64b3
ModifiedDeltaRPMFractionReducing	 == 0x64b5
ModifiedDeltaRPMOverIdle	         == 0x64b6
ModifiedDeltaRPMOverDistPWFraction	 == 0x64b7
DeltaRPMToTargetIdleSigned	         == 0x64b8
IdleFactorQuarters	                 == 0x64b9
IdleFactorFromMAP	                 == 0x64ba
IdleFactorFromCoolant	                 == 0x64bb
IdleFactorFromCombinedMAPAndCoolant	 == 0x64bc
AISIncrementFromCombinedDeltaRPMFactors_Pos	 == 0x64bd
IdleFactorFromCombinedDeltaRPMFactors_Neg	 == 0x64be
FactorFromSomethingIdleSpeedControlFromModifiedDeltaRPMOverIdle_Pos	 == 0x64bf
OneTimeCountXMitRequestRam	         == 0x64c0
CruiseControlVarX	                 == 0x64c1
Counter_SomethingWithDistributor	 == 0x64c2
ScaledDistPWForCruiseControl	         == 0x64c3
CruiseControlSwitchStateAnalog	         == 0x64c4
CruiseControlSwitchStateAnalogSnapshot	 == 0x64c5
CruiseControlSwitchStateDigital	         == 0x64c6
CCDFlagsX	                         == 0x64c7
Counter_ACControl1	                 == 0x64c8
Timer_ThermostatDiagnostics	         == 0x64c9
MinimumTimerCountBeforeMainloopCanContinue	 == 0x64ca
TempZ	                                 == 0x64cb
FDRVar1	                                 == 0x64cc
FDRVar2	                                 == 0x64cd
FDRVar3	                                 == 0x64ce
FDRVar4	                                 == 0x64cf
Temp0_X	                                 == 0x64d0
Temp1_X	                                 == 0x64d1
BoostDeltaThreshold	                 == 0x64d2
BoostTargetTemp	                         == 0x64d3

L64D4	                                 == 0x64d4
L64D5	                                 == 0x64d5

DRB_ProgramModeFlag	                 == 0x64d6
DRB_SpecialProgramRoutine                == 0x64D8

;------------------------------------------------------------------------------

; Pretty sure this space actually exsists
; So, I'll use it for the Turbonator Mods...
Turbonator_Flags                         == 0x64e0
    Turbonator_SparkCut	        = $%10000000    ; Turbonator - Spark-based rev limiter
    Turbonator_Staging	        = $%01000000    ; Turbonator - staging limiter is active
    Turbonator_FuelOff          = $%00100000    ; Turbonator - Fuel-based rev limiter
    Turbonator_OverRev          = $%00010000    ; over rev - replaced the original flag for simplicity
    Turbonator_AntiLag          = $%00001000    ; AntiLag is active
    Turbonator_Bit2             = $%00000100    ; Open
    Turbonator_AllowSpark       = $%00000010    ; Allow spark for only this cycle
    Turbonator_DecelFuelCut     = $%00000001    ; use decel fuel cut

Pattern_SparkCut                         == 0x64e1
Counter_SparkCut                         == 0x64e2
FinalAdvanceActual                       == 0x64e3
O2SensorValue                            == 0x64e4
AFRatio                                  == 0x64e5
RawAirFuelSensInput                      == 0x64e6 ; temp location, only to compile
;Counter_PartThrottleUnlock               == 0x64e7
;PTU_MapTemp                              == 0x64e8


;------------------------------------------------------------------------------

TopOfStack                               == 0x64ff


; *****************************************************************************
; load cal data
; *****************************************************************************

        .include /CalDataFile/

; *****************************************************************************
; begin code
; *****************************************************************************

	.org CodeOrg
        .msg "Assembling Code..."

ControlAirConditioning_MM:
           ldaa  TpsVoltsOverMINTHR    ; load A with memory contents
           brclr *PIA2_Buffer, #$%00000001, L9408    ; branch if bit(s) clear
           adda  #0x03         ;  -00000011-
   L9408:  cmpa  ACOUT_DeltaAboveMinThrottleToCutOutAc    ; compare A with memory contents (data is 85)
           bcc   SHUTOFF_AIRCONDITIONING    ; branch if greater or equal
           ldaa  Counter_AirCond    ; load A with memory contents
           cmpa  #0x01         ; compare a with value -00000001-
           bls   L941C         ; branch if lower or same
           ldab  Counter_MainLoop    ; load B with memory contents
           bitb  #0x3f         ;  -00111111-
           bne   L942C         ; branch if not equal (not zero)
           deca                ; decrement A
           bra   L942A         ; branch

   L941C:  ldx   EngineRpm_HB
           cpx   ACLRPM_DisableAcBelowThisRPM_500    ;  -10000010 10101101-
           bhi   L9435         ; branch if higher
           ldaa  Counter_AirCond    ; load A with memory contents
           bne   L942C         ; branch if not equal (not zero)
SHUTOFF_AIRCONDITIONING:
           ldaa  ACCNTI_ACCounterInitial    ; load A with memory contents (data is 06)
   L942A:  staa  Counter_AirCond    ; store A into memory
   L942C:  bclr  *BitFlags6D, #$%01000000    ; clear bits
           clra                ; A = 0
           staa  Timer_AcSomething    ; store A into memory
           jmp   L94CF     

   L9435:  brset *BitFlags6F, #b6f_FuelEngineNotRunning, L942C    ; branch if bit(s) set
           ldaa  KeyOnOrEngineRunningTime    ; load A with memory contents
           cmpa  ACCTIM_AcDelayFromStartRunTransfer    ; compare A with memory contents (data is 04)
           bcc   L9443         ; branch if greater or equal
           clra                ; A = 0
           bra   L942A         ; branch

   L9443:  ldaa  Timer_AcCutout    ; load A with memory contents
           bne   L9465         ; branch if not equal (not zero)
           ldab  CoolantTemp    ; load B with memory contents
           cmpb  ACDTMP_PartThrottleAcCutoutDisableTemp    ; compare B with memory contents (data is ff)
           bcs   L948B         ; branch if lower
           ldab  TpsVoltsOverMINTHR    ; load B with memory contents
           cmpb  ACDTHR_PartThrottleAcCutoutDisableThrottle    ; compare B with memory contents (data is ff)
           bcs   L948B         ; branch if lower
           ldx   VehicleSpeed_HB
           cpx   ACDSPD_PartThrottleAcCutoutDisableSpeed    ;  -10000000 11100110-
           bcc   L948B         ; branch if greater or equal
           ldab  EngineRpm_HB    ; load B with memory contents
           cmpb  ACERPM_AllowAcClutchAboveThisRpm    ; compare B with memory contents (data is 44)
           bcc   L948B         ; branch if greater or equal
           bra   L9483         ; branch

   L9465:  ldx   VehicleSpeed_HB
           cpx   ACESPD_AllowAcClutchAboveThisSpeed    ;  -10000000 11101010-
           bcc   L9488         ; branch if greater or equal
           ldab  EngineRpm_HB    ; load B with memory contents
           subb  #0x04         ;  -00000100-
           bcc   L9473         ; branch if greater or equal
           clrb                ; b = 0
   L9473:  cmpb  ACERPM_AllowAcClutchAboveThisRpm    ; compare B with memory contents (data is 44)
           bcc   L9488         ; branch if greater or equal
           cmpa  ACETIM_PartThrottleAcCutoutMaxTimeActive    ; compare A with memory contents (data is 08)
           bcc   L9488         ; branch if greater or equal
           ldab  Counter_MainLoop    ; load B with memory contents
           bitb  #0x3f         ;  -00111111-
           bne   L942C         ; branch if not equal (not zero)
   L9483:  inca                ; increment A
           staa  Timer_AcCutout    ; store A into memory
           bra   L942C         ; branch

   L9488:  clra                ; A = 0
           staa  Timer_AcCutout    ; store A into memory
   L948B:  brset *BitFlags68, #b68_bit7, L94B8    ; branch if bit(s) set
           ldx   EngineRpm_HB
           ldaa  Counter_AirCond    ; load A with memory contents
           beq   L9499         ; branch if equal (zero)
           cpx   TargetIdleSpeedHB
           bcs   L94D5
   L9499:  brclr *BitFlags6C, #$%00000010, L94D7    ; branch if bit(s) clear
           cpx   #0x1f40       ;  -00011111 01000000-
           bcc   L942C         ; branch if greater or equal
           ldab  Counter_MainLoop    ; load B with memory contents
           bitb  #0x03         ;  -00000011-
           bne   L94E0         ; branch if not equal (not zero)
           ldab  Counter_ACControl1    ; load B with memory contents
           incb                ; increment B
           stab  Counter_ACControl1    ; store B into memory
           cmpb  #0x5d         ;  -01011101-
           bcs   L94E0         ; branch if lower
           bset  *BitFlags6C, #$%00001000    ; set bits
           bra   L94E0         ; branch

   L94B8:  bclr  *BitFlags6D, #$%01000000    ; clear bits
           clra                ; A = 0
           staa  Timer_AcSomething    ; store A into memory
           brset *PIA2_Buffer, #$%00000001, L951C    ; branch if bit(s) set
           brset *BitFlags6E, #$%00000001, L94CB    ; branch if bit(s) set
           bset  *BitFlags6E, #$%00000001    ; set bits
           bra   L951F         ; branch

   L94CB:  brclr *BitFlags6E, #$%00000010, L9522    ; branch if bit(s) clear
   L94CF:  bclr  *BitFlags6B, #$%00010000    ; clear bits
           bset  *PIA2_Buffer, #$%00000001    ; set bits
   L94D5:  bra   L951C         ; branch

   L94D7:  brset *BitFlags6B, #$%00010000, L94E0    ; branch if bit(s) set
           cpx   ACCRPM_DoNotAllowAcToEngageAboveThisRPM_4000    ;  -10000010 10110000-
           bcc   L951C         ; branch if greater or equal
   L94E0:  brclr *PIA2_Buffer, #$%00000001, L951C    ; branch if bit(s) clear
           brset *BitFlags6D, #$%01000000, L9502    ; branch if bit(s) set
           ldd   Pulsewidth_PartThrottleEnrichment_HB    ; load D (A&B) with memory contents
           beq   L94F1         ; branch if equal (zero)
           ldaa  ACAETH_DisallowAcClutchEngageForThisTimeAfterAccelEnrich    ; load A with memory contents (data is 2e)
           bra   L94F6         ; branch

   L94F1:  ldaa  Timer_AcSomething    ; load A with memory contents
           beq   L94FA         ; branch if equal (zero)
           deca                ; decrement A
   L94F6:  staa  Timer_AcSomething    ; store A into memory
           bra   L9522         ; branch

   L94FA:  bset  *BitFlags6D, #$%01000000    ; set bits
           bclr  *BitFlags6D, #$%10000000    ; clear bits
           bra   L951C         ; branch

   L9502:  brclr *BitFlags6D, #$%10000000, L9522    ; branch if bit(s) clear
           brset *BitFlags6E, #$%00000100, L9512    ; branch if bit(s) set
           bset  *BitFlags6E, #$%00000100    ; set bits
           bset  *BitFlags6B, #$%00010000    ; set bits
           bra   L951F         ; branch

   L9512:  brclr *BitFlags6E, #$%00001000, L9522    ; branch if bit(s) clear
           clra                ; A = 0
           staa  Counter_AirCond    ; store A into memory
           bclr  *PIA2_Buffer, #$%00000001    ; clear bits
   L951C:  bclr  *BitFlags6E, #$%00001111    ; clear bits
   L951F:  clra                ; A = 0
           staa  Timer_AisOrO2Sensor    ; store A into memory
   L9522:  rts                 ; return from subroutine

ControlFan_MM:
           ;.byte 0xb6, 0x00, 0xca ; FIXME
           ldaa  Timer_MinimumFanRun    ; load A with memory contents  
           beq   L952C         ; branch if equal (zero)
           deca                ; decrement A
           jmp   StoreTimer_MinFanRun

   L952C:  brclr *BitFlags6F, #b6f_FuelEngineNotRunning, L9533    ; branch if bit(s) clear
           jmp   L9624     

   L9533:  brclr *BitFlags68, #b68_SparkEngineNotRunning, PreventRadSteaming    ; branch if bit(s) clear
           jmp   L9630     

PreventRadSteaming:
           ;.byte 0xb6, 0x00, 0xc9 ; FIXME
           ldaa  Timer_RadSteamingCountdown    ; load A with memory contents  
           cmpa  #0x01         ; compare a with value -00000001-
           beq   L957F         ; branch if equal (zero)
           bhi   L955C         ; branch if higher
           brclr *KeyOnOrEngineRunningTime, #$%11111111, L957F    ; branch if bit(s) clear
           ldaa  #0x01         ; load a with value -00000001-
           ldab  CoolantTemp    ; load B with memory contents
           cmpb  #0xa6         ;  -10100110-
           bcc   L9557         ; branch if greater or equal
           ldab  AmbientAirTempVolts    ; load B with memory contents
           cmpb  #0x90         ;  -10010000-
           bcc   L9557         ; branch if greater or equal
           ldaa  #0x41         ; load a with value -01000001-
   L9557:  ;.byte 0xb7, 0x00, 0xc9 ; FIXME
           staa  Timer_RadSteamingCountdown  
           bra   L957F         ; branch

   L955C:  ldaa  CoolantTemp    ; load A with memory contents
           cmpa  #0xd2         ; compare a with value -11010010-
           bcs   L957F         ; branch if lower
           ldaa  Counter_MainLoop    ; load A with memory contents
           cmpa  #0x09         ; compare a with value -00001001-
           bne   L956B         ; branch if not equal (not zero)
           dec   Timer_RadSteamingCountdown    ; decrement memory contents
   L956B:  clra                ; A = 0
           brclr *StartupSwitchMirror2, #$%10000000, L9576    ; branch if bit(s) clear
           brclr *BitFlags6E, #$%01000000, L957B    ; branch if bit(s) clear
           bra   L957A         ; branch

   L9576:  brset *BitFlags6E, #$%00010000, L957B    ; branch if bit(s) set
   L957A:  inca                ; increment A
   L957B:  cmpa  VehicleSpeed_HB    ; compare A with memory contents
           bcc   L95ED         ; branch if greater or equal
   L957F:  brset *b5C_IPL1, #$%00000010, L95ED    ; branch if bit(s) set
           ldaa  CONFIG_ConfigurationFlags    ; load A with memory contents (data is 92)
           bita  #0x80         ;  -10000000-
           beq   L958E         ; branch if equal (zero)
           brset *BitFlags6D, #$%01000000, L95ED    ; branch if bit(s) set
   L958E:  ldx   #FANTMP1_FanTurnOnTempAbove45Mph    ; load index with value
           ldaa  VehicleSpeed_HB    ; load A with memory contents
           cmpa  #0x0b         ; compare a with value -00001011-
           bcc   Above44MPH    ; branch if greater or equal
           cmpa  #0x09         ; compare a with value -00001001-
           bcs   Below36MPH    ; branch if lower
           brset *BitFlags68, #b68_SpeedOver40, L95A9    ; branch if bit(s) set
Below36MPH:
           inX                 ; increment index (I=I+1)
           inX                 ; increment index (I=I+1)
           bclr  *BitFlags68, #b68_SpeedOver40    ; clear bits
           bra   L95A9         ; branch

Above44MPH:
           bset  *BitFlags68, #b68_SpeedOver40    ; set bits
   L95A9:  brset *StartupSwitchMirror2, #$%10000000, L95AE    ; branch if bit(s) set
           inX                 ; increment index (I=I+1)
   L95AE:  ldaa  0x00, X      ; load A with memory at index + value -00000000-
           cmpa  CoolantTemp    ; compare A with memory contents
           bcs   L95ED         ; branch if lower
           ldaa  BaroPressure    ; load A with memory contents
           adda  FANMAP_FanTurnsOnWhenMapAboveBaroPlusThis    ;  (data is 33)
           bcs   L9608         ; branch if lower
           brclr *StartupSwitchMirror2, #$%10000000, L95C5    ; branch if bit(s) clear
           brset *BitFlags6E, #$%01000000, CheckFor_FANMAP    ; branch if bit(s) set
           bra   L95C9         ; branch

   L95C5:  brclr *BitFlags6E, #$%00010000, CheckFor_FANMAP    ; branch if bit(s) clear
   L95C9:  adda  #0x03         ;  -00000011-
           bcs   L9608         ; branch if lower
CheckFor_FANMAP:
           cmpa  MapValue      ; compare A with memory contents
           bcc   L9608         ; branch if greater or equal
           ldaa  AmbientAirTempVolts    ; load A with memory contents
           cmpa  AMBHIG_BattTempHighWhenCold    ; compare A with memory contents (data is f9)
           bhi   L9608         ; branch if higher
           brclr *StartupSwitchMirror2, #$%10000000, L95E2    ; branch if bit(s) clear
           brset *BitFlags6E, #$%01000000, L95E6    ; branch if bit(s) set
           bra   L95E8         ; branch

   L95E2:  brset *BitFlags6E, #$%00010000, L95E8    ; branch if bit(s) set
   L95E6:  deca                ; decrement A
           deca                ; decrement A
   L95E8:  cmpa  FANBAT_FanTurnsOnWhenBatteryTempAboveThis    ; compare A with memory contents (data is 92)
           bls   L9608         ; branch if lower or same
   L95ED:  brclr *StartupSwitchMirror2, #$%10000000, L9627    ; branch if bit(s) clear
           brset *BitFlags6E, #$%01000000, L95FA    ; branch if bit(s) set
           bset  *BitFlags6E, #$%01000000    ; set bits
           bra   L962D         ; branch

   L95FA:  brclr *BitFlags6E, #$%10000000, L9630    ; branch if bit(s) clear
           bclr  *StartupSwitchMirror2, #$%10000000    ; clear bits
           ldaa  #0x5b         ; load a with value -01011011-
StoreTimer_MinFanRun:
           ;.byte 0xb7, 0x00, 0xca ; FIXME
           staa  Timer_MinimumFanRun
           bra   L9627         ; branch

   L9608:  brset *StartupSwitchMirror2, #$%10000000, L9627    ; branch if bit(s) set
           brset *BitFlags6E, #$%00010000, L9620    ; branch if bit(s) set
           ldaa  DCLMN2_NoAisControlIfMapAndControlMapBelowThis    ; load A with memory contents (data is 16)
           cmpa  TempX         ; compare A with memory contents
           bls   L9624         ; branch if lower or same
           cmpa  MapValue      ; compare A with memory contents
           bls   L9624         ; branch if lower or same
           bset  *BitFlags6E, #$%00010000    ; set bits
           bra   L962D         ; branch

   L9620:  brclr *BitFlags6E, #$%00100000, L9630    ; branch if bit(s) clear
   L9624:  bset  *StartupSwitchMirror2, #$%10000000    ; set bits
   L9627:  bset  *BitFlags6D, #$%10000000    ; set bits
           bclr  *BitFlags6E, #$%11110000    ; clear bits
   L962D:  clra                ; A = 0
           staa  Timer_AcClutchEngageRestrictionTimer    ; store A into memory
   L9630:  rts                 ; return from subroutine

Interrupt_TimerOutputCapture1:
           ldaa  #0x80         ; load a with value -10000000-
           staa  CPU_TimerInterruptFlag1
           ldaa  #0x10         ; load a with value -00010000-
           staa  CPU_A2DControlReg
           ldd   CPU_TimerOutputCompareRegHigh1
           addd  #0x03be       ;  -00000011 10111110-
           cpd   CPU_TimerCounterRegHigh
           bpl   L964D         ; branch if plus (hi bit 0)
           ldd   CPU_TimerCounterRegHigh
           addd  #0x03be       ;  -00000011 10111110-
   L964D:  addd  #0x0004        ;  -00000000 00000100-
           std   CPU_TimerOutputCompareRegHigh1
           ldaa  CPU_TimerInterruptMask1    ; load A with memory contents
           anda  #0x7f         ; AND a with value -01111111-
           staa  CPU_TimerInterruptMask1
           ldaa  Timer_AlternatorDutyCycle    ; load A with memory contents
           inca                ; increment A
           staa  Timer_AlternatorDutyCycle    ; store A into memory
           cli                 ; enable interrupts
           lsra                ; logic shift right A
           bcc   ControlAlternator    ; branch if greater or equal
           jmp   AisDriveRoutine

ControlAlternator:
           ldx   #SwitchPortAccessReg1    ; load index with value
           ldaa  ATMOffset     ; load A with memory contents
           cmpa  #0x0d         ; compare a with value -00001101-
           bne   L9673         ; branch if not equal (not zero)
           jmp   L96F7     

   L9673:  brset *BitFlags6F, #b6f_FuelEngineNotRunning, L96B0    ; branch if bit(s) set
           ldab  #0x11         ; load B with value -00010001-
           brset *BitFlags70, #$%01000000, L967F    ; branch if bit(s) set
           ldab  #0x15         ; load B with value -00010101-
   L967F:  bclr  *BitFlags70, #$%01000000    ; clear bits
           cmpb  EngineRpm_HB
           bhi   TurnAlternatorOff    ; branch if higher
           bset  *BitFlags70, #$%01000000    ; set bits
   L9689:  ldaa  CPU_A2DControlReg    ; load A with memory contents
           bpl   L9689         ; branch if plus (hi bit 0)
           ldaa  CPU_A2DResults2    ; load A with memory contents
           cmpa  BatteryVolts    ; compare A with memory contents
           bcc   L9697         ; branch if greater or equal
           staa  BatteryVolts    ; store A into memory
   L9697:  cmpa  #0x41         ; compare a with value -01000001-
           bcc   L96A1         ; branch if greater or equal
           ldab  Counter_MainLoop    ; load B with memory contents
           bitb  #0x06         ;  -00000110-
           bne   TurnAlternatorOff    ; branch if not equal (not zero)
   L96A1:  brclr *BitFlags70, #$%00010000, L96C2    ; branch if bit(s) clear
           ldaa  A2DResults2Temp    ; load A with memory contents
           bne   L96B2         ; branch if not equal (not zero)
           ldaa  CPU_A2DResults2    ; load A with memory contents
           staa  A2DResults2Temp
   L96B0:  bra   TurnAlternatorOff    ; branch

   L96B2:  suba  CPU_A2DResults2
           bls   TurnAlternatorOff    ; branch if lower or same
           cmpa  BTVHYS_BatteryVoltsHysteresisForAlternatorControl    ; compare A with memory contents (data is 04)
           bls   TurnAlternatorOff    ; branch if lower or same
           bset  *BitFlags70, #$%00100000    ; set bits
           bclr  *BitFlags70, #$%00010000    ; clear bits
   L96C2:  clr   A2DResults2Temp    ; zero byte at memory location
   L96C5:  ldaa  CPU_A2DResults2    ; load A with memory contents
           suba  TargetBatteryVolts
           bne   L96D2         ; branch if not equal (not zero)
           brclr 0x00, X, #$%00000100, TurnAlternatorOn    ; branch if bit(s) clear -00000000-
           bra   TurnAlternatorOff    ; branch

   L96D2:  ldab  #0x0e         ; load B with value -00001110-
           bcc   L96E5         ; branch if greater or equal
           nega                ; negate A (set high bit)
           cmpa  #0x02         ; compare a with value -00000010-
           beq   L96DF         ; branch if equal (zero)
           bcc   TurnAlternatorOn    ; branch if greater or equal
           ldab  #0x06         ; load B with value -00000110-
   L96DF:  andb  Timer_AlternatorDutyCycle
           beq   TurnAlternatorOff    ; branch if equal (zero)
           bra   TurnAlternatorOn    ; branch

   L96E5:  cmpa  #0x02         ; compare a with value -00000010-
           beq   L96ED         ; branch if equal (zero)
           bcc   TurnAlternatorOff    ; branch if greater or equal
           ldab  #0x06         ; load B with value -00000110-
   L96ED:  andb  Timer_AlternatorDutyCycle
           bne   TurnAlternatorOff    ; branch if not equal (not zero)
TurnAlternatorOn:
           bset  0x00, X, #$%00000100    ; set bits -00000000-
           bset  *BitFlags70, #$%00000100    ; set bits
   L96F7:  bra   L96FF         ; branch

TurnAlternatorOff:
           bclr  0x00, X, #$%00000100    ; clear bits -00000000-
           bclr  *BitFlags70, #$%00000100    ; clear bits
   L96FF:  sei                 ; disable interrupts
           bset  0x02, X, #$%00000100    ; set bits -00000010-
           ldaa  #0x12         ; load a with value -00010010-
   L9705:  deca                ; decrement A
           bne   L9705         ; branch if not equal (not zero)
           bclr  0x02, X, #$%00000100    ; clear bits -00000010-
           cli                 ; enable interrupts
           bra   L9765         ; branch


;	.org	0x970e
AISTEP_BitPatternForAisControl:
	.byte	0x06,0x05,0x09,0x0a

;	.org	0x9712
InitForTempZ:
	.byte	0x02

;	.org	0x9713
CountForXMitRequestRAMRoutine:
	.byte	0x01

AisDriveRoutine:
           ldaa  OneTimeCountXMitRequestRam    ; load A with memory contents
           inca                ; increment A
           staa  OneTimeCountXMitRequestRam
           cmpa  CountForXMitRequestRAMRoutine    ; compare A with memory contents (data is 01)
           bls   L9765         ; branch if lower or same
           clra                ; A = 0
           staa  OneTimeCountXMitRequestRam
           ldaa  BatteryVolts    ; load A with memory contents
           cmpa  BTVAIS_MinVoltageForAis    ; compare A with memory contents (data is 71)
           bcs   L9765         ; branch if lower
           ldaa  CountdownTimerFromKeyOn    ; load A with memory contents
           bne   L9765         ; branch if not equal (not zero)
           ldab  CurrentAisPosition    ; load B with memory contents
           brset *BitFlags_AIS, #$%00100000, L975D    ; branch if bit(s) set
           cmpb  DesiredNewAisPosition
           beq   L9767         ; branch if equal (zero)
           bcs   L9749         ; branch if lower
           brclr *CCDFlags5, #$%00000001, L9771    ; branch if bit(s) clear
           ldaa  TempZ         ; load A with memory contents
           bne   L976A         ; branch if not equal (not zero)
           bclr  *CCDFlags5, #$%00000001    ; clear bits
           bra   L9771         ; branch

   L9749:  brset *CCDFlags5, #$%00000001, L9755    ; branch if bit(s) set
           ldaa  TempZ         ; load A with memory contents
           bne   L976A         ; branch if not equal (not zero)
           bset  *CCDFlags5, #$%00000001    ; set bits
   L9755:  inc   CurrentAisPosition
           ldab  Timer_BoostOver5psi    ; load B with memory contents
           incb                ; increment B
           bra   L9777         ; branch

   L975D:  bne   L9771         ; branch if not equal (not zero)
           bclr  *BitFlags_AIS, #$%00100000    ; clear bits
           bclr  *CCDFlags5, #$%00000001    ; clear bits
   L9765:  bra   XmitRequestedRamLocation    ; branch

   L9767:  ldaa  TempZ         ; load A with memory contents
   L976A:  suba  #0x01         ;  -00000001-
           bcc   L97BB         ; branch if greater or equal
           clra                ; A = 0
           bra   L97BB         ; branch

   L9771:  dec   CurrentAisPosition    ; decrement memory contents
           ldab  Timer_BoostOver5psi    ; load B with memory contents
           decb                ; decrement B
   L9777:  andb  #0x03         ;  -00000011-
           ldx   #AISTEP_BitPatternForAisControl    ; load index with value
           abx                 ; add B to index
           ldaa  Timer_BoostOver5psi    ; load A with memory contents
           anda  #0xfc         ; AND a with value -11111100-
           aba                 ; A=A+B
           staa  Timer_BoostOver5psi    ; store A into memory
           ldab  0x00, X      ; load B with memory at index + value -00000000-
           sei                 ; disable interrupts
   L9787:  ldaa  PIA1_Buffer    ; load A with memory contents
           oraa  #0x01         ;  -00000001-
           staa  PortX_Control
           anda  #0xfe         ; AND a with value -11111110-
           staa  PortX_Control
           staa  PIA1_Buffer    ; store A into memory
           bset  *PIA1_Buffer, #$%00000001    ; set bits
           ldaa  PIA1_Buffer    ; load A with memory contents
           staa  PortX_Control
           tba                 ; A = B
           comb                ; 1's complement B
           lslb                ; arithmetic shift left B
           lslb                ; arithmetic shift left B
           lslb                ; arithmetic shift left B
           lslb                ; arithmetic shift left B
           anda  #0x0f         ; AND a with value -00001111-
           aba                 ; A=A+B
           ldx   #CPU_PortD    ; load index with value
           bclr  0x00, X, #$%00100000    ; clear bits -00000000-
           cmpa  CPU_SerialPeripheralStatus    ; compare A with memory contents
           staa  CPU_SerialPeripheralDataIO
           mul                 ; multiply (D=A*B)
           mul                 ; multiply (D=A*B)
           bset  0x00, X, #$%00100000    ; set bits -00000000-
           cli                 ; enable interrupts
           ldaa  InitForTempZ    ; load A with memory contents (data is 02)
   L97BB:  staa  TempZ     
XmitRequestedRamLocation:
           brclr *DRBSerialMode, #$%10000000, L9811    ; branch if bit(s) clear
           ldaa  CPU_SerialStatus    ; load A with memory contents
           bita  #0x0e         ;  -00001110-
           beq   L97CE         ; branch if equal (zero)
           ldab  CPU_SerialData    ; load B with memory contents
           bra   L9811         ; branch

   L97CE:  bita  #0x20         ;  -00100000-
           beq   L9811         ; branch if equal (zero)
           ldab  CPU_SerialData    ; load B with memory contents
           cmpb  #0xf2         ;  -11110010-
           bne   L97DE         ; branch if not equal (not zero)
           bclr  *BitFlags70, #$%10000000    ; clear bits
           bra   L980E         ; branch

   L97DE:  cmpb  #0xf6         ;  -11110110-
           bne   L97E7         ; branch if not equal (not zero)
           bset  *BitFlags70, #$%10000000    ; set bits
           bra   L980E         ; branch

   L97E7:  cmpb  #0xfe         ;  -11111110-
           bne   L97F1         ; branch if not equal (not zero)
           bclr  *DRBSerialMode, #$%10110000    ; clear bits
           bclr  *BitFlags70, #$%10000000    ; clear bits
   L97F1:  brset *BitFlags70, #$%10000000, L97FB    ; branch if bit(s) set
           ldx   #0x0000        ; load index with value
           abx                 ; add B to index
           bra   L980C         ; branch

   L97FB:  ldaa  FastDataOutputCommandByte    ; load A with memory contents (data is 10)
           cba                 ; compare A to B
           bhi   L9805         ; branch if higher
           ldab  #0xff         ; load B with value -11111111-
           bra   L980E         ; branch

   L9805:  ldx   #FastDataOutputAddressTable    ; load index with value
           lslb                ; arithmetic shift left B
           abx                 ; add B to index
           ldx   0x00, X      ;  -00000000-
   L980C:  ldab  0x00, X      ; load B with memory at index + value -00000000-
   L980E:  stab  CPU_SerialData    ; store B into memory
  
   L9811:  ldaa  CPU_A2DResults1    ; load A with memory contents
           brset *BitFlags6B, #$%00000100, L981C    ; branch if bit(s) set
           brclr *Counter_MainLoop, #$%00111111, L982B    ; branch if bit(s) clear
   L981C:  cmpa  MapVolts_X     ; compare A with memory contents
           bcs   L982E         ; branch if lower
           cmpa  MapValue_X     ; compare A with memory contents
           bls   IncrementBoostTimers    ; branch if lower or same
           staa  MapValue_X 
           bra   IncrementBoostTimers    ; branch

   L982B:  staa  MapValue_X 
   L982E:  staa  MapVolts_X 
IncrementBoostTimers:
           ldab  MapVoltsX     ; load B with memory contents
           incb                ; increment B
           stab  MapVoltsX     ; store B into memory
           cmpb  #0xb3         ;  -10110011-
           bne   L9860         ; branch if not equal (not zero)
           clrb                ; b = 0
           stab  MapVoltsX     ; store B into memory
           ldaa  BaroPressure    ; load A with memory contents
           adda  BTMNBT_MinimumBoostToIncrementBoostTimer    ;  (data is 33)
           cmpa  MapValue      ; compare A with memory contents
           bls   L9852         ; branch if lower or same
           ldaa  Timer_BoostTimer    ; load A with memory contents
           beq   L9860         ; branch if equal (zero)
           deca                ; decrement A
           staa  Timer_BoostTimer    ; store A into memory
           bra   L9860         ; branch

   L9852:  ldab  EngineRpm_HB    ; load B with memory contents
           cmpb  BTMNRP_MinimumRPMToIncrementBoostTimer    ; compare B with memory contents (data is 00)
           bcs   L9860         ; branch if lower
           ldaa  Timer_BoostTimer    ; load A with memory contents
           inca                ; increment A
           beq   L9860         ; branch if equal (zero)
           staa  Timer_BoostTimer    ; store A into memory
   L9860:  ldaa  #0x80         ; load a with value -10000000-
           sei                 ; disable interrupts
           oraa  CPU_TimerInterruptMask1
           staa  CPU_TimerInterruptMask1
           rti                 ; return from interrupt


; 	.org	0x986a
; BTVHYS_BatteryVoltsHysteresisForAlternatorControl:
; 	.byte	0x04
; 
; 	.org	0x986b
; BTVLMT_BatteryVoltsDiagLimitOverTarget:
; 	.byte	0x10
; 
; 	.org	0x986c
; BTVCNT_BatteryVoltsDiagCounterMax:
; 	.byte	0x8e
; 
; 	.org	0x986d
; BTVCN3_BatteryVoltsDiagCounterMin:
; 	.byte	0x06
; 
; 	.org	0x986e
; BTVCN2_BatteryVoltsDiagCounterMax2:
; 	.byte	0x7f
; 
; 	.org	0x986f
; BTLRPM_LowBatteryVoltageAtThisRpm1500:
; 	.byte	0x2e

;        .org    0x9870 ; FIXME
VerifyOperationOfBatteryVoltage_MM:
           brset *BitFlags70, #$%00100000, L98D2    ; branch if bit(s) set
           brset *b5D_IPL2, #$%00000100, L98D2    ; branch if bit(s) set
           brset *b5D_IPL2, #$%00000001, L98D2    ; branch if bit(s) set
           ldaa  TargetBatteryVolts    ; load A with memory contents
           suba  CPU_A2DResults2
           bcs   L98D2         ; branch if lower
           cmpa  BTVLMT_BatteryVoltsDiagLimitOverTarget    ; compare A with memory contents (data is 10)
           bcs   L98D2         ; branch if lower
           ldaa  EngineRpm_HB    ; load A with memory contents
           cmpa  BTLRPM_LowBatteryVoltageAtThisRpm1500    ; compare A with memory contents (data is 2e)
           bcs   L98D2         ; branch if lower
           ldaa  #0x0f         ; load a with value -00001111-
           brclr *BitFlags70, #$%00001000, L9896    ; branch if bit(s) clear
           clra                ; A = 0
   L9896:  anda  Counter_MainLoop    ; logical and A with memory contents
           bne   L98D8         ; branch if not equal (not zero)
           ldaa  BatVoltsDiagCounter    ; load A with memory contents
           inca                ; increment A
           beq   L98A3         ; branch if equal (zero)
           staa  BatVoltsDiagCounter
   L98A3:  brset *BitFlags70, #$%00001000, L98B1    ; branch if bit(s) set
           cmpa  BTVCNT_BatteryVoltsDiagCounterMax    ; compare A with memory contents (data is 8e)
           bcs   L98D8         ; branch if lower
           bset  *BitFlags70, #$%00001000    ; set bits
           bra   L98D5         ; branch

   L98B1:  brset *BitFlags70, #$%00010000, L98BF    ; branch if bit(s) set
           cmpa  BTVCN2_BatteryVoltsDiagCounterMax2    ; compare A with memory contents (data is 7f)
           bcs   L98D8         ; branch if lower
           bset  *BitFlags70, #$%00010000    ; set bits
           bra   L98D5         ; branch

   L98BF:  cmpa  BTVCN3_BatteryVoltsDiagCounterMin    ; compare A with memory contents (data is 06)
           bcs   L98D8         ; branch if lower
           bclr  *BitFlags70, #$%00010000    ; clear bits
           ldd   #0x058a       ; load D (A&B) with value -00000101 10001010-
           jsr   ThrowNonCriticalError    ; call subroutine
           bcc   L98D5         ; branch if greater or equal
           bset  *b5D_IPL2, #$%00000100    ; set bits
   L98D2:  bclr  *BitFlags70, #$%00111000    ; clear bits
   L98D5:  clr   BatVoltsDiagCounter    ; zero byte at memory location
   L98D8:  rts                 ; return from subroutine

; 	.org	0x98d9
; BATVLT_BatteryVoltsTable:
; 	.byte	2			; number of points
; 	.byte	0x6e, 0xeb, 0xff, 0xac	; point 1
; 	.byte	0xab, 0xd7		; point 2

;	.org	0x98ec
DetermineTargetBatteryVoltage_MM:
           ldaa  AmbientAirTempVolts    ; load A with memory contents
           ldx   #BATVLT_BatteryVoltsTable    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  Temp0         ; store A into memory
           ldab  CCDBatteryVoltsOutput    ; load B with memory contents
           addb  #0xf8         ;  -11111000-
           bcs   L9901         ; branch if lower
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           bra   L990C         ; branch

   L9901:  cmpb  #0x08         ;  -00001000-
           bhi   L990C         ; branch if higher
           mul                 ; multiply (D=A*B)
           adca  Temp0     
           bcc   L990C         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   L990C:  staa  TargetBatteryVolts    ; store A into memory
           rts                 ; return from subroutine

;.org 0x990f ; FIXME
ControlAsdRelay_MM:
           ldaa  DRBPointer1    ; load A with memory contents
           cmpa  #0x18         ; compare a with value -00011000-
           beq   L991B         ; branch if equal (zero)
           cmpa  #0x0a         ; compare a with value -00001010-
           bne   CONTROL_AUTOSHUTDOWN_RELAY_ROUTINE1    ; branch if not equal (not zero)
           bra   L998D         ; branch

   L991B:  ldaa  DRBSerialMode    ; load A with memory contents
           bita  #0x30         ;  -00110000-
           bne   CONTROL_AUTOSHUTDOWN_RELAY_ROUTINE1    ; branch if not equal (not zero)
           ldab  TimerOverflowsBetweenDistPulses    ; load B with memory contents
           cmpb  #0x50         ;  -01010000-
           bls   L9955         ; branch if lower or same
           brset *BitFlags72, #b72_O2Enable, L9955    ; branch if bit(s) set
           ldaa  DRBPointer2    ; load A with memory contents
           tab                 ; B = A
           anda  #0x0f         ; AND a with value -00001111-
           comb                ; 1's complement B
           lsrb                ; logical shift right B
           lsrb                ; logical shift right B
           lsrb                ; logical shift right B
           lsrb                ; logical shift right B
           cba                 ; compare A to B
           bne   L9958         ; branch if not equal (not zero)
           ldab  Counter_MainLoop    ; load B with memory contents
           bne   L9948         ; branch if not equal (not zero)
           deca                ; decrement A
           beq   L995B         ; branch if equal (zero)
           ldab  DRBPointer2    ; load B with memory contents
           andb  #0xf0         ;  -11110000-
           addb  #0x10         ;  -00010000-
           aba                 ; A=A+B
           staa  DRBPointer2    ; store A into memory
   L9948:  ldaa  #0xe1         ; load a with value -11100001-
           jsr   SerialOutput1a    ; call subroutine
           ldx   #0xfe00       ; load index with value
           bset  *BitFlags6C, #$%00000100    ; set bits
           bra   L9985         ; branch

   L9955:  bclr  *BitFlags72, #b72_O2Enable    ; clear bits
   L9958:  jsr   SerialOutput1    ; call subroutine
   L995B:  clra                ; A = 0
           staa  DRBPointer1    ; store A into memory
           staa  ATMOffset     ; store A into memory
CONTROL_AUTOSHUTDOWN_RELAY_ROUTINE1:
           ldx   #0x002D        ; load index with value
           ldaa  CoolantTemp    ; load A with memory contents
           cmpa  #0x8f         ; compare a with value -10001111-
           bcc   ControlAsdRelay_Over119Ftemp    ; branch if greater or equal
           ldx   #0x005b    ; load index with value
ControlAsdRelay_Over119Ftemp:
           ldab  #0x08         ; load B with value -00001000-
           ldaa  BatteryVolts    ; load A with memory contents
           cmpa  #0xb2         ; compare a with value -10110010-
           brset *BitFlags68, #b68_Past12secRunning, L9981    ; branch if bit(s) set
           bcc   L9985         ; branch if greater or equal
           cpx   #0x005b    ;  -00000000 01011011-
           bne   L9985         ; branch if not equal (not zero)
           ldab  #0x17         ; load B with value -00010111-
           bra   L9985         ; branch

   L9981:  bcs   L9985         ; branch if lower
           ldab  #0x05         ; load B with value -00000101-
   L9985:  cmpb  Counter_TimerPastHalfwayBetweenCamPulses
           bhi   L9992         ; branch if higher
           cpx   KeyOnOrEngineRunningTime
           bhi   L9992
   L998D:  bset  *PIA2_Buffer, #$%00010000    ; set bits
           bra   L9995         ; branch

   L9992:  bclr  *PIA2_Buffer, #$%00010000    ; clear bits
   L9995:  brset *BitFlags6F, #b6f_FuelEngineNotRunning, L99A2    ; branch if bit(s) set
           ldab  KeyOnOrEngineRunningTime    ; load B with memory contents
           cmpb  #0x04         ;  -00000100-
           bcs   L99A2         ; branch if lower
           bset  *BitFlags68, #b68_Past12secRunning    ; set bits
   L99A2:  rts                 ; return from subroutine

HandleBaroReadRequirement_MM:
           brset *BitFlags6F, #b6f_FuelEngineNotRunning, L99BA    ; branch if bit(s) set
           brset *BitFlags68, #b68_SparkEngineNotRunning, L99B6    ; branch if bit(s) set
           ldaa  Timer_BaroReadInterval    ; load A with memory contents
           ldab  Counter_MainLoop    ; load B with memory contents
           bne   L99B6         ; branch if not equal (not zero)
           inca                ; increment A
           beq   L99B6         ; branch if equal (zero)
           staa  Timer_BaroReadInterval    ; store A into memory
   L99B6:  brclr *BitFlags66, #b66_OffIdle, ReadBaroIfPossible    ; branch if bit(s) clear
   L99BA:  bset  *StartupSwitchMirror2, #$%00010000    ; set bits
           clra                ; A = 0
           staa  Timer_BaroReadRpmConditionsSatisfied    ; store A into memory
           bclr  *BitFlags68, #b68_SparkEngineNotRunning | b68_BaroSolEnergized    ; clear bits
           bclr  *BitFlags6F, #b6f_BaroOkEngineStopped    ; clear bits
           rts                 ; return from subroutine

ReadBaroIfPossible:
           brset *BitFlags68, #b68_SparkEngineNotRunning, THROTTLE_HASNTCHANGED_STILLNOTPRESSED    ; branch if bit(s) set
           ldd   EngineRpm_HB    ; load D (A&B) with memory contents
           cpd   BRPMHI_BaroReadHighRPM6650    ;  (data is bb80)
           bhi   L9A22         ; branch if higher
           cpd   BRPMLO_BaroReadLowRPM1800    ;  (data is 3840)
           bcs   L9A22         ; branch if lower
           ldaa  Timer_BaroReadRpmConditionsSatisfied    ; load A with memory contents
           inca                ; increment A
           beq   L99E5         ; branch if equal (zero)
           staa  Timer_BaroReadRpmConditionsSatisfied    ; store A into memory
           cmpa  BRDLAY_BaroReadDelayAfterThrottleClosed2sec    ; compare A with memory contents (data is 2e)
           bcs   L9A22         ; branch if lower
   L99E5:  ldaa  Timer_BaroReadInterval    ; load A with memory contents
           cmpa  BARTIM_BaroReadMinTimeBetweenReadings179sec    ; compare A with memory contents (data is 0b)
           bcs   L9A22         ; branch if lower
           brset *BitFlags68, #b68_BaroSolEnergized, L9A22    ; branch if bit(s) set
           bclr  *StartupSwitchMirror2, #$%00010000    ; clear bits
           bset  *BitFlags68, #b68_SparkEngineNotRunning    ; set bits
           bra   L9A1F         ; branch

THROTTLE_HASNTCHANGED_STILLNOTPRESSED:
           inc   Timer_BaroReadInterval
           brset *BitFlags68, #b68_BaroSolEnergized, L9A0E    ; branch if bit(s) set
           ldaa  Timer_BaroReadInterval    ; load A with memory contents
           cmpa  BROPTM_BaroReadDelayAfterSolenoidOpenTenthSec    ; compare A with memory contents (data is 09)
           bcs   L9A22         ; branch if lower
           bset  *BitFlags68, #b68_BaroSolEnergized    ; set bits
           bset  *BitFlags6F, #b6f_BaroOkEngineStopped    ; set bits
           bra   L9A1F         ; branch

   L9A0E:  brset *BitFlags6F, #b6f_BaroOkEngineStopped, L9A1F    ; branch if bit(s) set
           bset  *StartupSwitchMirror2, #$%00010000    ; set bits
           ldaa  Timer_BaroReadInterval    ; load A with memory contents
           cmpa  BRCLTM_BaroReadDelayAfterSolenoidClosedTenthSec    ; compare A with memory contents (data is 09)
           bcs   L9A22         ; branch if lower
           bclr  *BitFlags68, #b68_SparkEngineNotRunning    ; clear bits
   L9A1F:  clra                ; A = 0
           staa  Timer_BaroReadInterval    ; store A into memory
   L9A22:  rts                 ; return from subroutine

SaveBaroPressure:
           jsr   ConvertMAPVoltsToValue    ; call subroutine
           tab                 ; B = A
           cmpb  BAROHI_BaroReadValidHighLimit    ; compare B with memory contents (data is 8a)
           bcc   L9A31         ; branch if greater or equal
           cmpb  BAROLO_BaroReadValidLowLimit    ; compare B with memory contents (data is 44)
           bcc   L9A34         ; branch if greater or equal
   L9A31:  ldab  BARDFT_BaroReadDefaultValue    ; load B with memory contents (data is 66)
   L9A34:  stab  BaroPressure    ; store B into memory
           rts                 ; return from subroutine

CalculateTargetIdleSpeedAndAisPosition_MM:
           brset *BitFlags69, #$%00000100, L9A65    ; branch if bit(s) set
           brclr *KeyOnOrEngineRunningTime, #$%11111111, L9A65    ; branch if bit(s) clear
           ldaa  AmbientAirTempVolts    ; load A with memory contents
           ldx   #AMBAIS_AmbientTempAISCompensation    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  Temp0         ; store A into memory
           ldaa  BaroPressure    ; load A with memory contents
           ldx   #BARAIS_AISBaroCompensation    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           bne   L9A57         ; branch if not equal (not zero)
           ldaa  Temp0         ; load A with memory contents
           bra   L9A60         ; branch

   L9A57:  ldaa  Temp0         ; load A with memory contents
           mul                 ; multiply (D=A*B)
           adca  Temp0     
           bvc   L9A60         ; branch if overflow
           ldaa  #0x7f         ; load a with value -01111111-
   L9A60:  staa  AISACCompensation    ; store A into memory
           bset  *BitFlags69, #$%00000100    ; set bits
   L9A65:  ldaa  Counter_IdleControl    ; load A with memory contents
           beq   L9A6C         ; branch if equal (zero)
           jmp   L9AF4     

   L9A6C:  ldx   #AISCLD_IdleSpeedDrive_FromTemp    ; load index with value
           brset *BitFlags_AIS, #$%00001000, L9AA5    ; branch if bit(s) set
           ldaa  DRBPointer1    ; load A with memory contents
           cmpa  #0x19         ; compare a with value -00011001-
           beq   L9A84         ; branch if equal (zero)
           brclr *TargetIdleSpeedLB, #$%00111111, L9A91    ; branch if bit(s) clear
           ldd   TargetIdleSpeedHB    ; load D (A&B) with memory contents
           subd  #0x0001        ;  -00000000 00000001-
           bra   L9AF2         ; branch

   L9A84:  brset *DRBSerialMode, #$%00100000, L9AF4    ; branch if bit(s) set
           clr   DRBPointer1    ; zero byte at memory location
           ldaa  DRBPointer2    ; load A with memory contents
           ldab  #0xfc         ; load B with value -11111100-
           bra   L9AF0         ; branch

   L9A91:  ldaa  IDLDEF_TargetIdleSpeedDefault    ; load A with memory contents (data is 7d)
           brset *b5C_IPL1, #$%00000010, L9AEF    ; branch if bit(s) set
           brset *BitFlags6C, #$%00100000, L9AEF    ; branch if bit(s) set
           ldaa  #0x30         ; load a with value -00110000-
           brset *BitFlags6C, #$%00010000, L9AEF    ; branch if bit(s) set
           ldx   #AISPN_IdleSpeedParkNeutral_FromTemp    ; load index with value
   L9AA5:  ldaa  CoolantTemp    ; load A with memory contents
           jsr   Lookup4ByteTable    ; call subroutine
           staa  Temp0         ; store A into memory
           ldaa  KeyOnOrEngineRunningTime    ; load A with memory contents
           ldx   #TIMED2_AISDecelBaseAirflowCurveOffset2    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           adda  Temp0     
           bcc   L9ABA         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   L9ABA:  brclr *BitFlags67, #b67_IdleSpeedMode, L9AD6    ; branch if bit(s) clear
           ldab  Counter_MainLoop    ; load B with memory contents
           andb  DECAIS_RollingAisUpdateRate_01_03_07_0f_1f_3f_7f_ff    ;  (data is 82)
           bne   L9AF4         ; branch if not equal (not zero)
           staa  Temp0         ; store A into memory
           ldd   TargetIdleSpeedHB    ; load D (A&B) with memory contents
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           suba  ISPDCY_RollingAisDecay    ;  (data is 04)
           bcs   L9AD4         ; branch if lower
           cmpa  Temp0         ; compare A with memory contents
           bcc   L9AD6         ; branch if greater or equal
   L9AD4:  ldaa  Temp0         ; load A with memory contents
   L9AD6:  brclr *BitFlags6C, #$%00000010, L9AEF    ; branch if bit(s) clear
           brset *BitFlags6F, #b6f_FuelEngineNotRunning, L9AEF    ; branch if bit(s) set
           ldx   KeyOnOrEngineRunningTime
           cpx   #0x0744       ;  -00000111 01000100-
           bls   L9AEF         ; branch if lower or same
           brset *BitFlags68, #b68_bit7, L9AEF    ; branch if bit(s) set
           cmpa  #0x77         ; compare a with value -01110111-
           bls   L9AEF         ; branch if lower or same
           ldaa  #0x77         ; load a with value -01110111-
   L9AEF:  clrb                ; b = 0
   L9AF0:  lsrd                ; shift right (D=D/2)
           lsrd                ; shift right (D=D/2)
   L9AF2:  std   TargetIdleSpeedHB    ; store D (A&B) into memory
   L9AF4:  ldaa  ATMOffset     ; load A with memory contents
           cmpa  #0x07         ; compare a with value -00000111-
           beq   L9AFE         ; branch if equal (zero)
           cmpa  #0x14         ; compare a with value -00010100-
           bne   L9AFF         ; branch if not equal (not zero)
   L9AFE:  rts                 ; return from subroutine

   L9AFF:  ldaa  BaroPressure    ; load A with memory contents
           ldx   #BARAIS_AISBaroCompensation    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  BaroAISComp    ; store A into memory
           brset *BitFlags_AIS, #$%00010000, L9B22    ; branch if bit(s) set
           brclr *BitFlags6F, #b6f_FuelEngineNotRunning, L9B1D    ; branch if bit(s) clear
           ldaa  EngineRpm_HB    ; load A with memory contents
           cmpa  RPMTHS_RPMThresholdForIdleControl    ; compare A with memory contents (data is 0d)
           bcc   L9B1D         ; branch if greater or equal
           ldaa  RPMDEF_RPMDefaultForIdleControl    ; load A with memory contents (data is a0)
           bra   L9B3D         ; branch

   L9B1D:  bset  *BitFlags_AIS, #$%00010000    ; set bits
           bra   L9B35         ; branch

   L9B22:  ldab  BitFlags_AIS    ; load B with memory contents
           orab  BitFlags6F
           bpl   L9B53         ; branch if plus (hi bit 0)
           ldaa  DesiredNewAisPosition    ; load A with memory contents
           cmpa  CurrentAisPosition    ; compare A with memory contents
           bne   L9B35         ; branch if not equal (not zero)
           brset *BitFlags_AIS, #$%00100000, L9B35    ; branch if bit(s) set
           bclr  *BitFlags_AIS, #$%10000000    ; clear bits
   L9B35:  ldaa  CoolantTemp    ; load A with memory contents
           ldx   #AISTRT_AisStartupPosition_FromTemp    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
   L9B3D:  adda  CALPOS_PositionAisMotorIsAtIdle    ;  (data is 1a)
           bcs   L9B4A         ; branch if lower
           jsr   MultiplyTempvar1ByA_Unsign    ; call subroutine
           cmpa  AISHLM_AisHighLimitMaxOpenSteps    ; compare A with memory contents (data is a0)
           bcs   L9B4D         ; branch if lower
   L9B4A:  ldaa  AISHLM_AisHighLimitMaxOpenSteps    ; load A with memory contents (data is a0)
   L9B4D:  staa  DesiredNewAisPosition    ; store A into memory
;    L9B4F:  bclr  *BitFlags6B, #b6b_DecelFuelCut    ; clear bits
;            rts                 ; return from subroutine

; v2 code paste
   L9B4F:
           ldx   #Turbonator_Flags
           bclr 0, x, #Turbonator_DecelFuelCut
           rts                 ; return from subroutine

   L9B53:  brclr *b5C_IPL1, #$%10100000, L9B6D    ; branch if bit(s) clear
           ldaa  CoolantTemp    ; load A with memory contents
           ldx   #CLDPS2_AisColdPosition_FromTemp2    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           adda  CALPOS_PositionAisMotorIsAtIdle    ;  (data is 1a)
           bcc   L9B66         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   L9B66:  staa  DesiredNewAisPosition    ; store A into memory
           bset  *BitFlags6E, #$%10101010    ; set bits
           bra   L9B4F         ; branch

   L9B6D:  jsr   DecideToUseDecelFuelCut    ; call subroutine
           brset *BitFlags69, #b69_AtIdle, L9B8F    ; branch if bit(s) set
           brset *BitFlags67, #b67_FallToIdle, L9B8C    ; branch if bit(s) set
           brclr *BitFlags66, #b66_OffIdle, L9B8C    ; branch if bit(s) clear
           brclr *StartupSwitchMirror1, #$%00100000, L9B8F    ; branch if bit(s) clear
           ldx   #RPTHTP_RPMThresholdFromTPSOverMIN    ; load index with value
           ldaa  TpsVoltsOverMINTHR    ; load A with memory contents
           jsr   Lookup4ByteTable    ; call subroutine
           cmpa  EngineRpm_HB    ; compare A with memory contents
           bcc   L9B8F         ; branch if greater or equal
   L9B8C:  jmp   CalculateAisPosition

   L9B8F:  bset  *BitFlags6E, #$%00100000    ; set bits
           brset *BitFlags6E, #$%01000000, L9BA1    ; branch if bit(s) set
           brset *BitFlags6E, #$%00000100, L9BCA    ; branch if bit(s) set
           brset *BitFlags6E, #$%00000001, L9BE3    ; branch if bit(s) set
           jmp   L9C23     

   L9BA1:  ldaa  Timer_AcClutchEngageRestrictionTimer    ; load A with memory contents
           bne   L9BBF         ; branch if not equal (not zero)
           ldaa  TFCACB_Timer_AcClutchEngageRestrictionTimerFactorB    ; load A with memory contents (data is 0c)
           beq   L9BC4         ; branch if equal (zero)
           jsr   StoreAndLimitDesiredAisPosition    ; call subroutine
           ldaa  TFCACB_Timer_AcClutchEngageRestrictionTimerFactorB    ; load A with memory contents (data is 0c)
           ldab  #0xb7         ; load B with value -10110111-
           mul                 ; multiply (D=A*B)
           adda  TFCACA_Timer_AcClutchEngageRestrictionTimerFactorA    ;  (data is 13)
           bcc   L9BBA         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   L9BBA:  staa  Timer_AcClutchEngageRestrictionTimer    ; store A into memory
           jmp   L9CBA     

   L9BBF:  deca                ; decrement A
           staa  Timer_AcClutchEngageRestrictionTimer    ; store A into memory
           bne   L9BC7         ; branch if not equal (not zero)
   L9BC4:  bset  *BitFlags6E, #$%10000000    ; set bits
   L9BC7:  jmp   L9CBA     

   L9BCA:  ldaa  Timer_AisOrO2Sensor    ; load A with memory contents
           bne   L9BD8         ; branch if not equal (not zero)
           ldaa  ACTDEF_TimeBeforeAcEnabledAndFullDeltaUsed_Default    ; load A with memory contents (data is 20)
           beq   L9BDD         ; branch if equal (zero)
           staa  Timer_AisOrO2Sensor    ; store A into memory
           jmp   L9C23     

   L9BD8:  deca                ; decrement A
           staa  Timer_AisOrO2Sensor    ; store A into memory
           bne   L9BE0         ; branch if not equal (not zero)
   L9BDD:  bset  *BitFlags6E, #$%00001000    ; set bits
   L9BE0:  jmp   L9C23     

   L9BE3:  ldaa  Timer_AisOrO2Sensor    ; load A with memory contents
           bne   L9C04         ; branch if not equal (not zero)
           ldaa  VehicleSpeedScaled    ; load A with memory contents
           ldx   #ACCTBL_ACOffIdleDelta_FromSpeed    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           ldab  OFFPER2_AisInstantlyClosesWhenAcDisengages2    ; load B with memory contents (data is a0)
           mul                 ; multiply (D=A*B)
           jsr   MultiplyTempvar1ByA_Pos    ; call subroutine
           nega                ; negate A (set high bit)
           jsr   L9D06         ; call subroutine
           ldaa  ACTIM2_TimeBeforeAcEnabledAndFullDeltaUsed2    ; load A with memory contents (data is 10)
           beq   L9C1D         ; branch if equal (zero)
           staa  Timer_AisOrO2Sensor    ; store A into memory
           jmp   L9CBA     

   L9C04:  deca                ; decrement A
           staa  Timer_AisOrO2Sensor    ; store A into memory
           bne   L9C20         ; branch if not equal (not zero)
           ldaa  VehicleSpeedScaled    ; load A with memory contents
           ldx   #ACCTBL_ACOffIdleDelta_FromSpeed    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           ldab  OFFPER2_AisInstantlyClosesWhenAcDisengages2    ; load B with memory contents (data is a0)
           comb                ; 1's complement B
           mul                 ; multiply (D=A*B)
           jsr   MultiplyTempvar1ByA_Pos    ; call subroutine
           nega                ; negate A (set high bit)
           jsr   L9D06         ; call subroutine
   L9C1D:  bset  *BitFlags6E, #$%00000010    ; set bits
   L9C20:  jmp   L9CBA     

   L9C23:  ldaa  CoolantTemp    ; load A with memory contents
           ldx   #CLDPOS_AisColdPosition_FromTemp    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  Temp0         ; store A into memory
           ldx   #RPMPOS_AisPosition_FromRpm    ; load index with value
           ldaa  EngineRpm_HB    ; load A with memory contents
           jsr   Lookup4ByteTable    ; call subroutine
           cmpa  Temp0         ; compare A with memory contents
           bcs   L9C3B         ; branch if lower
           staa  Temp0         ; store A into memory
   L9C3B:  ldaa  TpsVoltsOverMINTHR    ; load A with memory contents
           ldx   #THRPOS_AisPosition_FromThrottle    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           cmpa  Temp0         ; compare A with memory contents
           bls   L9C49         ; branch if lower or same
           staa  Temp0         ; store A into memory
   L9C49:  brset *StartupSwitchMirror2, #$%10000000, L9C56    ; branch if bit(s) set
           ldaa  Temp0         ; load A with memory contents
           adda  AISINC_AISPOSIncrementForSW2b7    ;  (data is 04)
           bcs   L9CA0         ; branch if lower
           staa  Temp0         ; store A into memory
   L9C56:  brset *BitFlags68, #b68_bit7, L9C83    ; branch if bit(s) set
           brclr *BitFlags6B, #$%00010000, L9C83    ; branch if bit(s) clear
           ldaa  AISACCompensation    ; load A with memory contents
           brset *BitFlags69, #b69_AtIdle, L9C7D    ; branch if bit(s) set
           ldab  CoolantTemp    ; load B with memory contents
           cmpb  ACTMP_Use_ACCTBL_WhenTempAboveThisElseUse_ACPOS    ; compare B with memory contents (data is 7f)
           bcs   L9C7D         ; branch if lower
           ldx   #ACCTBL_ACOffIdleDelta_FromSpeed    ; load index with value
           ldaa  VehicleSpeedScaled    ; load A with memory contents
           jsr   Lookup4ByteTable    ; call subroutine
   L9C73:  brclr *PIA2_Buffer, #$%00000001, L9C7D    ; branch if bit(s) clear
           ldaa  PERKCK_AcClutchAisAdjustmentConstant    ; load A with memory contents (data is c0)
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
   L9C7D:  adda  Temp0     
           bcs   L9CA0         ; branch if lower
           staa  Temp0         ; store A into memory
   L9C83:  ldaa  KeyOnOrEngineRunningTime    ; load A with memory contents
           ldx   #ADDAIS_AISAddedFromTimeEngRunning    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           adda  Temp0     
           bcs   L9CA0         ; branch if lower
           brset *BitFlags68, #b68_ASDon, L9C98    ; branch if bit(s) set
           adda  CALPOS_PositionAisMotorIsAtIdle    ;  (data is 1a)
           bcs   L9CA0         ; branch if lower
   L9C98:  jsr   MultiplyTempvar1ByA_Unsign    ; call subroutine
           cmpa  AISHLM_AisHighLimitMaxOpenSteps    ; compare A with memory contents (data is a0)
           bcs   L9CA3         ; branch if lower
   L9CA0:  ldaa  AISHLM_AisHighLimitMaxOpenSteps    ; load A with memory contents (data is a0)
   L9CA3:  brset *BitFlags69, #b69_AtIdle, L9CB5    ; branch if bit(s) set
           cmpa  DesiredNewAisPosition    ; compare A with memory contents
           bcc   L9CB8         ; branch if greater or equal
           ldab  Counter_MainLoop    ; load B with memory contents
           bitb  DLYOF1_UpdateRateOffIdleWhenAisClosing    ;  (data is 07)
           bne   L9CBA         ; branch if not equal (not zero)
           ldaa  DesiredNewAisPosition    ; load A with memory contents
           deca                ; decrement A
   L9CB5:  bclr  *BitFlags69, #b69_AtIdle    ; clear bits
   L9CB8:  staa  DesiredNewAisPosition    ; store A into memory
   L9CBA:  rts                 ; return from subroutine

; v2 code paste

DecideToUseDecelFuelCut:
           brset *BitFlags_AIS, #$%00001000, ClearDFCFlag    ; branch if bit(s) set
           ldaa  KeyOnOrEngineRunningTime    ; load A with memory contents
           cmpa  DCLMER_MinTimeEngineRunningForDecelFuelShutoff    ; compare A with memory contents (data is 02)
           bls   ClearDFCFlag         ; branch if lower or same
           ldaa  CoolantTemp    ; load A with memory contents
           cmpa  DCLMCT_MinCoolantTempForDecelFuelShutoff    ; compare A with memory contents (data is d2)
           bls   ClearDFCFlag         ; branch if lower or same
           brset *BitFlags66, #b66_OffIdle, ClearDFCFlag    ; branch if bit(s) set
           brset *BitFlags67, #b67_FallToIdle, ClearDFCFlag    ; branch if bit(s) set
           ldd   EngineRpm_HB    ; load D (A&B) with memory contents
           subd  TargetIdleSpeedHB    ; D = D - memory contents
           bcc   L9CDC         ; branch if greater or equal
           clra                ; A = 0
   L9CDC:  ldx   #Turbonator_Flags
           brclr 0, x, #Turbonator_DecelFuelCut, L9CEA    ; branch if bit(s) clear
           cmpa  DCLRPL_EngineRPMLimitForDecelFuelShutoffLow    ; compare A with memory contents (data is 0f)
           bhi   SetDFCFlag         ; branch if higher
ClearDFCFlag:
           ldx   #Turbonator_Flags
           bclr 0, x, #Turbonator_DecelFuelCut    ; clear bits
           bra   L9CF5         ; branch

   L9CEA:  cmpa  DCLRPH_EngineRPMLimitForDecelFuelShutoffHigh    ; compare A with memory contents (data is 1e)
           bls   ClearDFCFlag         ; branch if lower or same
SetDFCFlag:
           ldx   #Turbonator_Flags
           bset 0, x, #Turbonator_DecelFuelCut    ; set bits
           bset  *BitFlags6D, #$%00010000    ; set bits
   L9CF5:  rts                 ; return from subroutine

StoreAndLimitDesiredAisPosition:
           tsta                ; test A
           bmi   L9D06         ; branch if minus(hi bit 1)
           adda  DesiredNewAisPosition
           ldab  AISHLM_AisHighLimitMaxOpenSteps    ; load B with memory contents (data is a0)
           bcs   L9D03         ; branch if lower
           cba                 ; compare A to B
           bcs   L9D0B         ; branch if lower
   L9D03:  stab  DesiredNewAisPosition    ; store B into memory
           rts                 ; return from subroutine

   L9D06:  adda  DesiredNewAisPosition
           bcs   L9D0B         ; branch if lower
           clra                ; A = 0
   L9D0B:  staa  DesiredNewAisPosition    ; store A into memory
           rts                 ; return from subroutine

MultiplyTempvar1ByA_Unsign:
           ldab  BaroAISComp    ; load B with memory contents
           beq   L9D39         ; branch if equal (zero)
           staa  Temp4         ; store A into memory
           mul                 ; multiply (D=A*B)
           adca  Temp4     
           bcc   L9D39         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
           rts                 ; return from subroutine

MultiplyTempvar1ByA_Pos:
           ldab  BaroAISComp    ; load B with memory contents
           beq   L9D39         ; branch if equal (zero)
           staa  Temp4         ; store A into memory
           mul                 ; multiply (D=A*B)
           adca  Temp4     
           bvc   L9D39         ; branch if overflow
           ldaa  #0x7f         ; load a with value -01111111-
           rts                 ; return from subroutine

MultiplyTempvar1ByA_Neg:
           ldab  BaroAISComp    ; load B with memory contents
           beq   L9D39         ; branch if equal (zero)
           nega                ; negate A (set high bit)
           staa  Temp4         ; store A into memory
           mul                 ; multiply (D=A*B)
           adca  Temp4     
           bvc   L9D38         ; branch if overflow
           ldaa  #0x7f         ; load a with value -01111111-
   L9D38:  nega                ; negate A (set high bit)
   L9D39:  rts                 ; return from subroutine

CalculateAisPosition:
           ldaa  Timer_DacalCountdown    ; load A with memory contents
           lsra                ; logic shift right A
           lsra                ; logic shift right A
           adda  DANOM_Base_nominalCal    ;  (data is 0f)
           bcc   L9D45         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   L9D45:  ldab  DistributorFallingEdgePulsewidth_HB    ; load B with memory contents
           mul                 ; multiply (D=A*B)
           asld                ; shift left (D=D*2)
           bcs   L9D4E         ; branch if lower
           asld                ; shift left (D=D*2)
           bcc   L9D50         ; branch if greater or equal
   L9D4E:  ldaa  #0xff         ; load a with value -11111111-
   L9D50:  staa  TempX         ; store A into memory
           brclr *BitFlags67, #b67_FallToIdle, L9DC5    ; branch if bit(s) clear
           ldx   #TIMEDC_AISDecelBaseAirflowCurveOffset    ; load index with value
           ldaa  KeyOnOrEngineRunningTime    ; load A with memory contents
           jsr   Lookup4ByteTable    ; call subroutine
           staa  Temp0         ; store A into memory
           ldx   #TEMPDC_AISDecel_FromTemp    ; load index with value
           ldaa  CoolantTemp    ; load A with memory contents
           jsr   Lookup4ByteTable    ; call subroutine
           adda  Temp0     
           bcs   L9D7E         ; branch if lower
           brset *PIA2_Buffer, #$%00000001, L9D80    ; branch if bit(s) set
           staa  Temp0         ; store A into memory
           ldaa  AISACCompensation    ; load A with memory contents
           ldx   #DAACF_ACFactorDeltaFromBase    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           adda  Temp0     
           bcc   L9D80         ; branch if greater or equal
   L9D7E:  ldaa  #0xff         ; load a with value -11111111-
   L9D80:  ldab  DistributorFallingEdgePulsewidth_HB    ; load B with memory contents
           mul                 ; multiply (D=A*B)
           asld                ; shift left (D=D*2)
           bcs   L9DB6         ; branch if lower
           asld                ; shift left (D=D*2)
           bcs   L9DB6         ; branch if lower
           staa  Temp0         ; store A into memory
           ldx   #MAPFLR_AISAdditionToControlMap    ; load index with value
           ldaa  EngineRpm_HB    ; load A with memory contents
           jsr   Lookup4ByteTable    ; call subroutine
           staa  Temp1         ; store A into memory
           ldx   #MPTEMP_TempTermForMapOffset_FromTemp    ; load index with value
           ldaa  CoolantTemp    ; load A with memory contents
           jsr   Lookup4ByteTable    ; call subroutine
           ldaa  Temp1         ; load A with memory contents
           mul                 ; multiply (D=A*B)
           adca  Temp0     
           bcs   L9DB6         ; branch if lower
           staa  Temp0         ; store A into memory
           ldx   #BARFLR_OffsetCorrectionTo_MAPFLR_FromBaro    ; load index with value
           ldaa  BaroPressure    ; load A with memory contents
           jsr   Lookup4ByteTable    ; call subroutine
           adda  Temp0     
           bcs   L9DB6         ; branch if lower
           adda  TempX     
           bcc   L9DB8         ; branch if greater or equal
   L9DB6:  ldaa  #0xff         ; load a with value -11111111-
   L9DB8:  cmpa  DCLMIN_MinLimitOnDecelAisControlledMap    ; compare A with memory contents (data is 10)
           bcc   L9DC0         ; branch if greater or equal
           ldaa  DCLMIN_MinLimitOnDecelAisControlledMap    ; load A with memory contents (data is 10)
   L9DC0:  staa  TempX         ; store A into memory
   L9DC2:  jmp   L9E77     

   L9DC5:  clrb                ; b = 0
           brset *BitFlags68, #b68_bit7, L9DDA    ; branch if bit(s) set
           brset *PIA2_Buffer, #$%00000001, L9DDA    ; branch if bit(s) set
           ldab  Counter_MainLoop    ; load B with memory contents
           bitb  #0x1f         ;  -00011111-
           bne   L9DDC         ; branch if not equal (not zero)
           ldab  Counter_AISACCompensation    ; load B with memory contents
           incb                ; increment B
           bne   L9DDA         ; branch if not equal (not zero)
           decb                ; decrement B
   L9DDA:  stab  Counter_AISACCompensation    ; store B into memory
   L9DDC:  ldab  Timer_CountdownFromStartRunForAisFeedback    ; load B with memory contents
           bne   L9E4F         ; branch if not equal (not zero)
           brclr *BitFlags37, #bf37_ATX, L9DE8    ; branch if bit(s) clear
           brclr *StartupSwitchMirror1, #$%00010000, L9E4F    ; branch if bit(s) clear
   L9DE8:  brset *BitFlags67, #b67_IdleSpeedMode, L9E4F    ; branch if bit(s) set
           ldab  KeyOnOrEngineRunningTime    ; load B with memory contents
           cmpb  DCALTM_DacalInhibitTimeAfterStartup    ; compare B with memory contents (data is 16)
           bcs   L9DC2         ; branch if lower
           ldab  CoolantTemp    ; load B with memory contents
           cmpb  DATHOT_EngineTempToStartCalibratingDacal    ; compare B with memory contents (data is cd)
           bls   L9E77         ; branch if lower or same
           ldd   EngineRpm_HB    ; load D (A&B) with memory contents
           subd  TargetIdleSpeedHB    ; D = D - memory contents
           bcc   L9E02         ; branch if greater or equal
           coma                ; 1's complement A
           comb                ; 1's complement B
   L9E02:  asld                ; shift left (D=D*2)
           cmpa  DADRPM_DeltaRpmFromIdleSpeedForDacalUpdate    ; compare A with memory contents (data is 04)
           bcc   L9E77         ; branch if greater or equal
           brclr *BitFlags68, #b68_bit7, L9E51    ; branch if bit(s) clear
           brclr *PIA2_Buffer, #$%00000001, L9E77    ; branch if bit(s) clear
           ldaa  Counter_MainLoop    ; load A with memory contents
           bita  DCALRT_DacalUpdateRate01_03_07_0f_1f_3f_7f_ff    ;  (data is 7f)
           bne   L9E28         ; branch if not equal (not zero)
           ldab  Timer_DacalCountdown    ; load B with memory contents
           ldaa  TempX         ; load A with memory contents
           cmpa  MapValue      ; compare A with memory contents
           bhi   L9E22         ; branch if higher
           incb                ; increment B
           bne   L9E26         ; branch if not equal (not zero)
   L9E22:  tstb                ; test B
           beq   L9E28         ; branch if equal (zero)
           decb                ; decrement B
   L9E26:  stab  Timer_DacalCountdown    ; store B into memory
   L9E28:  ldaa  Counter_MainLoop    ; load A with memory contents
           bita  CALRAT_AisAdjustRate    ;  (data is 07)
           bne   L9E77         ; branch if not equal (not zero)
           ldaa  DesiredNewAisPosition    ; load A with memory contents
           cmpa  CurrentAisPosition    ; compare A with memory contents
           bne   L9E77         ; branch if not equal (not zero)
           ldab  CALPOS_PositionAisMotorIsAtIdle    ; load B with memory contents (data is 1a)
           brset *StartupSwitchMirror2, #$%10000000, L9E43    ; branch if bit(s) set
           addb  AISINC_AISPOSIncrementForSW2b7    ;  (data is 04)
           bcc   L9E43         ; branch if greater or equal
           ldab  #0xff         ; load B with value -11111111-
   L9E43:  cba                 ; compare A to B
           beq   L9E77         ; branch if equal (zero)
           bhi   L9E4A         ; branch if higher
           inca                ; increment A
           inca                ; increment A
   L9E4A:  deca                ; decrement A
           staa  DesiredNewAisPosition    ; store A into memory
           staa  CurrentAisPosition    ; store A into memory
   L9E4F:  bra   L9E77         ; branch

   L9E51:  brset *PIA2_Buffer, #$%00000001, L9E77    ; branch if bit(s) set
           ldab  Counter_AISACCompensation    ; load B with memory contents
           cmpb  MINACC_MinimumCounterAISAC    ; compare B with memory contents (data is 11)
           bcs   L9E77         ; branch if lower
           ldaa  Counter_MainLoop    ; load A with memory contents
           bita  MINMLC_MinimumMainLoopCounterForAISACComp    ;  (data is 1f)
           bne   L9E77         ; branch if not equal (not zero)
           ldaa  AISACCompensation    ; load A with memory contents
           ldab  DesiredNewAisPosition    ; load B with memory contents
           subb  CALPOS_PositionAisMotorIsAtIdle    ; subtract memory contents from B (data is 1a)
           bcc   L9E6D         ; branch if greater or equal
           clrb                ; b = 0
   L9E6D:  cba                 ; compare A to B
           beq   L9E77         ; branch if equal (zero)
           bhi   L9E74         ; branch if higher
           inca                ; increment A
           inca                ; increment A
   L9E74:  deca                ; decrement A
           staa  AISACCompensation    ; store A into memory
   L9E77:  brset *BitFlags6E, #$%01000000, L9E8A    ; branch if bit(s) set
           brset *BitFlags6E, #$%00010000, L9EA3    ; branch if bit(s) set
           brset *BitFlags6E, #$%00000100, L9ECC    ; branch if bit(s) set
           brset *BitFlags6E, #$%00000001, L9EF9    ; branch if bit(s) set
           jmp   L9F35     

   L9E8A:  ldaa  Timer_AcClutchEngageRestrictionTimer    ; load A with memory contents
           bne   L9E98         ; branch if not equal (not zero)
           ldaa  TFCACB_Timer_AcClutchEngageRestrictionTimerFactorB    ; load A with memory contents (data is 0c)
           beq   L9E9D         ; branch if equal (zero)
           jsr   StoreAndLimitDesiredAisPosition    ; call subroutine
           bra   L9EB0         ; branch

   L9E98:  deca                ; decrement A
           staa  Timer_AcClutchEngageRestrictionTimer    ; store A into memory
           bne   L9EA0         ; branch if not equal (not zero)
   L9E9D:  bset  *BitFlags6E, #$%10000000    ; set bits
   L9EA0:  jmp   L9F35     

   L9EA3:  ldaa  Timer_AcClutchEngageRestrictionTimer    ; load A with memory contents
           bne   L9EC2         ; branch if not equal (not zero)
           ldaa  TFCACB_Timer_AcClutchEngageRestrictionTimerFactorB    ; load A with memory contents (data is 0c)
           beq   L9EC7         ; branch if equal (zero)
           nega                ; negate A (set high bit)
   L9EAD:  jsr   L9D06         ; call subroutine
   L9EB0:  ldaa  TFCACB_Timer_AcClutchEngageRestrictionTimerFactorB    ; load A with memory contents (data is 0c)
           ldab  #0xb7         ; load B with value -10110111-
           mul                 ; multiply (D=A*B)
           adda  TFCACA_Timer_AcClutchEngageRestrictionTimerFactorA    ;  (data is 13)
           bcc   L9EBD         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   L9EBD:  staa  Timer_AcClutchEngageRestrictionTimer    ; store A into memory
           jmp   L9F35     

   L9EC2:  deca                ; decrement A
           staa  Timer_AcClutchEngageRestrictionTimer    ; store A into memory
           bne   L9F35         ; branch if not equal (not zero)
   L9EC7:  bset  *BitFlags6E, #$%00100000    ; set bits
           bra   L9F35         ; branch

   L9ECC:  ldaa  Timer_AisOrO2Sensor    ; load A with memory contents
           bne   L9EEF         ; branch if not equal (not zero)
           ldaa  AISACCompensation    ; load A with memory contents
           ldx   #ACOFFK_ClosedThrottleAcOffKick    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           beq   L9EF4         ; branch if equal (zero)
           staa  Temp0         ; store A into memory
           jsr   StoreAndLimitDesiredAisPosition    ; call subroutine
           ldaa  Temp0         ; load A with memory contents
           ldab  #0xb7         ; load B with value -10110111-
           mul                 ; multiply (D=A*B)
           adda  ACTOFS_OffsetTimeBeforeAcEnabledAndFullDeltaUsed    ;  (data is 08)
           bcc   L9EEB         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   L9EEB:  staa  Timer_AisOrO2Sensor    ; store A into memory
           bra   L9F35         ; branch

   L9EEF:  deca                ; decrement A
           staa  Timer_AisOrO2Sensor    ; store A into memory
           bne   L9EF7         ; branch if not equal (not zero)
   L9EF4:  bset  *BitFlags6E, #$%00001000    ; set bits
   L9EF7:  bra   L9F35         ; branch

   L9EF9:  ldaa  Timer_AisOrO2Sensor    ; load A with memory contents
           bne   L9F2D         ; branch if not equal (not zero)
           ldaa  DCLMN2_NoAisControlIfMapAndControlMapBelowThis    ; load A with memory contents (data is 16)
           cmpa  TempX         ; compare A with memory contents
           bls   L9F0D         ; branch if lower or same
           cmpa  MapValue      ; compare A with memory contents
           bls   L9F0D         ; branch if lower or same
           ldx   #ACOFFK_ClosedThrottleAcOffKick    ; load index with value
           bra   L9F10         ; branch

   L9F0D:  ldx   #ACTIMX_TimeBeforeAcEnabledAndFullDeltaUsedFromACCompFactor    ; load index with value
   L9F10:  ldaa  AISACCompensation    ; load A with memory contents
           jsr   Lookup4ByteTable    ; call subroutine
           beq   L9F32         ; branch if equal (zero)
           staa  Temp0         ; store A into memory
           nega                ; negate A (set high bit)
           jsr   L9D06         ; call subroutine
           ldaa  Temp0         ; load A with memory contents
           ldab  #0xb7         ; load B with value -10110111-
           mul                 ; multiply (D=A*B)
           adda  ACTIM2_TimeBeforeAcEnabledAndFullDeltaUsed2    ;  (data is 10)
           bcc   L9F29         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   L9F29:  staa  Timer_AisOrO2Sensor    ; store A into memory
           bra   L9F35         ; branch

   L9F2D:  deca                ; decrement A
           staa  Timer_AisOrO2Sensor    ; store A into memory
           bne   L9F35         ; branch if not equal (not zero)
   L9F32:  bset  *BitFlags6E, #$%00000010    ; set bits
   L9F35:  brclr *BitFlags67, #b67_FallToIdle, L9F6B    ; branch if bit(s) clear
           ldab  Timer_CountdownFromStartRunForAisFeedback    ; load B with memory contents
           bne   L9F6A         ; branch if not equal (not zero)
           ldab  Timer_AisChanges    ; load B with memory contents
           cmpb  DCLRFQ_TimeBetweenAisPulsesForDecelAis    ; compare B with memory contents (data is 17)
           bcs   L9F6A         ; branch if lower
           ldaa  TempX         ; load A with memory contents
           cmpa  DCLMN2_NoAisControlIfMapAndControlMapBelowThis    ; compare A with memory contents (data is 16)
           bcc   L9F52         ; branch if greater or equal
           ldab  MapValue      ; load B with memory contents
           cmpb  DCLMN2_NoAisControlIfMapAndControlMapBelowThis    ; compare B with memory contents (data is 16)
           bcs   L9F6A         ; branch if lower
   L9F52:  ldx   #DAISOP_AISDecelAisOpenStepsNeg_FromDeltaMap    ; load index with value
           suba  MapValue  
           bcc   L9F5D         ; branch if greater or equal
           nega                ; negate A (set high bit)
           ldx   #DAISCL_AISDecelAisOpenStepsPos_FromDeltaMap    ; load index with value
   L9F5D:  jsr   Lookup4ByteTable    ; call subroutine
           jsr   StoreAndLimitDesiredAisPosition    ; call subroutine
           cmpa  CurrentAisPosition    ; compare A with memory contents
           beq   L9F6A         ; branch if equal (zero)
           clra                ; A = 0
           staa  Timer_AisChanges    ; store A into memory
   L9F6A:  rts                 ; return from subroutine

   L9F6B:  ldaa  DesiredNewAisPosition    ; load A with memory contents
           cmpa  #0x04         ; compare a with value -00000100-
           bcs   KickUpAisBy2DuringDecel    ; branch if lower
           bclr  *BitFlags68, #b68_ASDon    ; clear bits
           bra   L9F8B         ; branch

KickUpAisBy2DuringDecel:
           ldab  Counter_MainLoop    ; load B with memory contents
           bitb  #0x7f         ;  -01111111-
           bne   L9F8B         ; branch if not equal (not zero)
           ldaa  DesiredNewAisPosition    ; load A with memory contents
           oraa  CurrentAisPosition    ; OR A with memory contents
           bne   L9F8B         ; branch if not equal (not zero)
           ldaa  #0x02         ; load a with value -00000010-
           staa  DesiredNewAisPosition    ; store A into memory
           staa  CurrentAisPosition    ; store A into memory
           bset  *BitFlags68, #b68_ASDon    ; set bits
   L9F8B:  ldaa  Counter_IdleControl    ; load A with memory contents
           cmpa  #0x01         ; compare a with value -00000001-
           bne   L9FC2         ; branch if not equal (not zero)
           clra                ; A = 0
           staa  Counter_IdleControl    ; store A into memory
           brset *BitFlags37, #bf37_ATXInDrive, L9F9D    ; branch if bit(s) set
           ldx   #DRPNK_DriveToParkNeutralKicks_FromTemp    ; load index with value
           bra   L9FA0         ; branch

   L9F9D:  ldx   #PNDRK_ParkNeutralToDriveKicks_FromTemp    ; load index with value
   L9FA0:  brset *BitFlags_AIS, #$%00001000, L9FB0    ; branch if bit(s) set
           brset *BitFlags37, #bf37_ATXInDrive, L9FAD    ; branch if bit(s) set
           ldx   #PNDLTP_DeltaRpmChangeToUse_DRPNK_or_PNDRK    ; load index with value
           bra   L9FB0         ; branch

   L9FAD:  ldx   #PNDLTN_DeltaRpmChangeToUse_DRPNK_or_PNDRK    ; load index with value
   L9FB0:  ldaa  CoolantTemp    ; load A with memory contents
           jsr   Lookup4ByteTable    ; call subroutine
           bmi   L9FBC         ; branch if minus(hi bit 1)
           jsr   MultiplyTempvar1ByA_Pos    ; call subroutine
           bra   L9FBF         ; branch

   L9FBC:  jsr   MultiplyTempvar1ByA_Neg    ; call subroutine
   L9FBF:  jsr   StoreAndLimitDesiredAisPosition    ; call subroutine
   L9FC2:  brset *BitFlags6D, #$%00000010, L9FC9    ; branch if bit(s) set
   L9FC6:  jmp   LA1BE     

   L9FC9:  ldaa  Timer_CountdownFromStartRunForAisFeedback    ; load A with memory contents
           bne   L9FC6         ; branch if not equal (not zero)
           bclr  *BitFlags6D, #$%00000010    ; clear bits
           ldd   EngineRpm_HB    ; load D (A&B) with memory contents
           subd  EngineRPMTemp
           bcs   DecreasingRPM    ; branch if lower
           bset  *BitFlags6D, #$%00000100    ; set bits
           std   DeltaRPMSigned
           bra   CalculateDeltaRPMFractionAndScale    ; branch

DecreasingRPM:
           bclr  *BitFlags6D, #$%00000100    ; clear bits
           std   DeltaRPMSigned
           coma                ; 1's complement A
           comb                ; 1's complement B
CalculateDeltaRPMFractionAndScale:
           ldx   DistPWTemp
           fdiv                ; fractional divide ACCD by IX
           xgdx                ; exchange D and index
           xgdy                ; exchange D and index
           ldaa  #0xf4         ; load a with value -11110100-
           jsr   ScaleYbyA     ; call subroutine
           xgdy                ; exchange D and index
           brset *BitFlags6D, #$%00000100, L9FFB    ; branch if bit(s) set
           coma                ; 1's complement A
           comb                ; 1's complement B
   L9FFB:  adda  #0x80         ;  -10000000-
           std   DeltaRPMOverDistPWFraction
           ldd   EngineRpm_HB    ; load D (A&B) with memory contents
           subd  TargetIdleSpeedHB    ; D = D - memory contents
           bcs   RPMBelowTargetIdle    ; branch if lower
           cpd   #0x5f40       ;  -01011111 01000000-
           bcs   RPMOverIdleButBelow3048    ; branch if lower
           ldaa  #0xff         ; load a with value -11111111-
           bra   LA01F         ; branch

RPMBelowTargetIdle:
           cpd   #0xe03f       ;  -11100000 00111111-
           bhi   RPMOverIdleButBelow3048    ; branch if higher
           clra                ; A = 0
           bra   LA01F         ; branch

RPMOverIdleButBelow3048:
           addd  #0x0040       ;  -00000000 01000000-
           asld                ; shift left (D=D*2)
           adda  #0x40         ;  -01000000-
   LA01F:  staa  ModifiedDeltaRPMOverIdle
           ldx   #RPMFC1_DeltaRPMFactorFromModifiedDeltaRPMOverIdle    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           brclr *BitFlags_AIS, #$%00001000, LA050    ; branch if bit(s) clear
           bmi   LA040         ; branch if minus(hi bit 1)
           suba  #0x80         ;  -10000000-
           nega                ; negate A (set high bit)
           ldab  RPMFC2_FactorForRPMFC1_75percent    ; load B with memory contents (data is c0)
           mul                 ; multiply (D=A*B)
           asld                ; shift left (D=D*2)
           bpl   LA03B         ; branch if plus (hi bit 0)
           clrb                ; b = 0
           bra   LA050         ; branch

   LA03B:  suba  #0x80         ;  -10000000-
           nega                ; negate A (set high bit)
           bra   LA04F         ; branch

   LA040:  adda  #0x80         ;  -10000000-
           ldab  RPMFC2_FactorForRPMFC1_75percent    ; load B with memory contents (data is c0)
           mul                 ; multiply (D=A*B)
           asld                ; shift left (D=D*2)
           bpl   LA04D         ; branch if plus (hi bit 0)
           ldab  #0xff         ; load B with value -11111111-
           bra   LA050         ; branch

   LA04D:  adda  #0x80         ;  -10000000-
   LA04F:  tab                 ; B = A
   LA050:  stab  ModifiedDeltaRPMOverDistPWFraction    ; store B into memory
           ;brset *BitFlags6B, #b6b_DecelFuelCut, LA06C    ; branch if bit(s) set

; v2 code paste
           ldx   #Turbonator_Flags
           brset 0, x, #Turbonator_DecelFuelCut, LA06C    ; branch if bit(s) set

           brset *BitFlags6D, #$%00010000, LA06F    ; branch if bit(s) set
           brset *BitFlags6D, #$%00001000, LA072    ; branch if bit(s) set
           ldy   DeltaRPMOverDistPWFraction
           ldaa  RPMFC3_FactorForDeltaRPMOverDistPWFraction_25percent    ; load A with memory contents (data is 40)
           bne   LA084         ; branch if not equal (not zero)
           xgdy                ; exchange D and index
           bra   StoreDeltaRPMFraction         ; branch

   LA06C:  jmp   LA1BE     

   LA06F:  bclr  *BitFlags6D, #$%00010000    ; clear bits
   LA072:  bclr  *BitFlags6D, #$%00001000    ; clear bits
           clra                ; A = 0
           ldab  ModifiedDeltaRPMOverDistPWFraction    ; load B with memory contents
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           std   Temp0         ; store D (A&B) into memory
           ldd   #0x7800       ; load D (A&B) with value -01111000 00000000-
           bra   LA097         ; branch

   LA084:  jsr   ScaleYbyA     ; call subroutine
           sty   Temp0         ; store index into memory
           ldy   DeltaRPMFractionReducing
           ldaa  RPMFC3_FactorForDeltaRPMOverDistPWFraction_25percent    ; load A with memory contents (data is 40)
           nega                ; negate A (set high bit)
           jsr   ScaleYbyA     ; call subroutine
           xgdy                ; exchange D and index
   LA097:  addd  Temp0         ; D = D + memory contents

StoreDeltaRPMFraction:
           std   DeltaRPMFractionReducing
           cpd   #0x87e8       ;  -10000111 11101000-
           bcs   LA0A6         ; branch if lower
           ldab  #0xff         ; load B with value -11111111-
           bra   StoreModifiedDeltaRPM         ; branch

   LA0A6:  cpd   #0x7807       ;  -01111000 00000111-
           bhi   LA0AF         ; branch if higher
           clrb                ; b = 0
           bra   StoreModifiedDeltaRPM         ; branch

   LA0AF:  addd  #0x0008       ;  -00000000 00001000-
           lsrd                ; shift right (D=D/2)
           lsrd                ; shift right (D=D/2)
           lsrd                ; shift right (D=D/2)
           lsrd                ; shift right (D=D/2)
           addb  #0x80         ;  -10000000-

StoreModifiedDeltaRPM:
           stab  ModifiedDeltaRPMFractionReducing    ; store B into memory
           ldab  ModifiedDeltaRPMOverDistPWFraction    ; load B with memory contents
           addb  #0x80         ;  -10000000-
           ldaa  ModifiedDeltaRPMFractionReducing    ; load A with memory contents
           adda  #0x80         ;  -10000000-
           sba                 ; subtract (A=A-B)
           bvc   StoreDeltaRPM         ; branch if overflow
           bpl   LA0CE         ; branch if plus (hi bit 0)
           ldaa  #0x7f         ; load a with value -01111111-
           bra   StoreDeltaRPM         ; branch

   LA0CE:  ldaa  #0x80         ; load a with value -10000000-

StoreDeltaRPM:
           tab                 ; B = A
           adda  #0x80         ;  -10000000-
           staa  DeltaRPMToTargetIdleSigned
           brset *BitFlags_AIS, #$%00000100, LA0E1    ; branch if bit(s) set
           brclr *BitFlags6E, #$%01010101, LA0E4    ; branch if bit(s) clear
           bset  *BitFlags6D, #$%00100000    ; set bits
   LA0E1:  jmp   LA1BE     

   LA0E4:  bclr  *BitFlags6D, #$%00100000    ; clear bits
           ldaa  IdleFactorQuarters    ; load A with memory contents
           adda  #0x80         ;  -10000000-
           aba                 ; A=A+B
           bvc   LA0F7         ; branch if overflow
           bpl   LA0F5         ; branch if plus (hi bit 0)
           ldaa  #0x7f         ; load a with value -01111111-
           bra   LA0F7         ; branch

   LA0F5:  ldaa  #0x80         ; load a with value -10000000-
   LA0F7:  adda  #0x80         ;  -10000000-
           staa  IdleFactorQuarters
           ldaa  MapValue      ; load A with memory contents
           ldx   #IDLFC2_FactorIdleSpeedControlFromMAP    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  IdleFactorFromMAP
           ldaa  CoolantTemp    ; load A with memory contents
           ldx   #IDLFC1_FactorIdleSpeedControlFromCoolant    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           stab  IdleFactorFromCoolant    ; store B into memory
           addb  IdleFactorFromMAP
           bcs   LA11B         ; branch if lower
           cmpb  #0x7f         ;  -01111111-
           bls   LA11D         ; branch if lower or same
   LA11B:  ldab  #0x7f         ; load B with value -01111111-
   LA11D:  stab  IdleFactorFromCombinedMAPAndCoolant    ; store B into memory
           ldaa  IdleFactorQuarters    ; load A with memory contents
           adda  #0x80         ;  -10000000-
           bpl   LA128         ; branch if plus (hi bit 0)
           nega                ; negate A (set high bit)
   LA128:  cba                 ; compare A to B
           bcc   LA12E         ; branch if greater or equal
           jmp   LA1BE     

   LA12E:  ldaa  #0x80         ; load a with value -10000000-
           staa  IdleFactorQuarters
           ldaa  DeltaRPMToTargetIdleSigned    ; load A with memory contents
           bpl   ModifyAISPosBasedOnIdleSpeedError         ; branch if plus (hi bit 0)
           ldx   #AISMD3_AISModifierFromDeltaRPMToTargetIdleSigned_Neg    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  Temp0         ; store A into memory
           ldaa  ModifiedDeltaRPMOverIdle    ; load A with memory contents
           ldx   #AISMD4_AISModifierFromModifiedDeltaRPMOverIdle_Neg    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           ldaa  Temp0         ; load A with memory contents
           stab  IdleFactorFromCombinedDeltaRPMFactors_Neg    ; store B into memory
           beq   LA153         ; branch if equal (zero)
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
   LA153:  nega                ; negate A (set high bit)
           bra   AdjustAISUsingIdleSpeedErrFactors         ; branch

ModifyAISPosBasedOnIdleSpeedError:
           ldx   #AISMD1_AISModifierFromDeltaRPMToTargetIdleSigned_Pos    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  Temp0         ; store A into memory
           ldaa  ModifiedDeltaRPMOverIdle    ; load A with memory contents
           ldx   #AISMD2_AISModifierFromModifiedDeltaRPMOverIdle_Pos    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           ldaa  Temp0         ; load A with memory contents
           stab  FactorFromSomethingIdleSpeedControlFromModifiedDeltaRPMOverIdle_Pos    ; store B into memory
           beq   AdjustAISUsingIdleSpeedErrFactors         ; branch if equal (zero)
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-

AdjustAISUsingIdleSpeedErrFactors:
           staa  AISIncrementFromCombinedDeltaRPMFactors_Pos
           jsr   StoreAndLimitDesiredAisPosition    ; call subroutine
           brclr *BitFlags67, #b67_IdleSpeedMode, LA1BE    ; branch if bit(s) clear
           ldaa  CoolantTemp    ; load A with memory contents
           ldx   #CLDPOS_AisColdPosition_FromTemp    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           brset *BitFlags68, #b68_ASDon, LA18C    ; branch if bit(s) set
           adda  CALPOS_PositionAisMotorIsAtIdle    ;  (data is 1a)
           bcs   LA19E         ; branch if lower
   LA18C:  brset *BitFlags68, #b68_bit7, LA1A0    ; branch if bit(s) set
           staa  Temp0         ; store A into memory
           ldaa  AISACCompensation    ; load A with memory contents
           ldx   #ACOFFK_ClosedThrottleAcOffKick    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           adda  Temp0     
           bcc   LA1A0         ; branch if greater or equal
   LA19E:  ldaa  #0xff         ; load a with value -11111111-
   LA1A0:  staa  Temp0         ; store A into memory
           adda  AISLMH_RollingAisHighLimit    ;  (data is 10)
           bcs   LA1AE         ; branch if lower
           jsr   MultiplyTempvar1ByA_Unsign    ; call subroutine
           cmpa  DesiredNewAisPosition    ; compare A with memory contents
           bcs   LA1BC         ; branch if lower
   LA1AE:  ldaa  Temp0         ; load A with memory contents
           suba  AISLML_RollingAisLowLimit    ;  (data is 04)
           bcs   LA1BE         ; branch if lower
           jsr   MultiplyTempvar1ByA_Unsign    ; call subroutine
           cmpa  DesiredNewAisPosition    ; compare A with memory contents
           bls   LA1BE         ; branch if lower or same
   LA1BC:  staa  DesiredNewAisPosition    ; store A into memory
   LA1BE:  rts                 ; return from subroutine

CCDBusComs:
           ldab  #0x93         ; load B with value -10010011-
           ldaa  Temp0         ; load A with memory contents
           bne   LA1C7         ; branch if not equal (not zero)
           ldab  #0x80         ; load B with value -10000000-
   LA1C7:  aba                 ; A=A+B
           adda  Temp1     
           adda  Temp2     
           staa  Temp3         ; store A into memory
           tba                 ; A = B
           ldab  #0x40         ; load B with value -01000000-
           ldy   #CPU_PortA    ; load index with value
           ldx   #SwitchPortAccessReg1    ; load index with value
           bset  0x00, X, #$%00001000    ; set bits -00000000-
           sei                 ; disable interrupts
           bclr  0x08, Y, #$%00100000    ; clear bits -00001000-
           cmpb  CPU_SerialPeripheralStatus    ; compare B with memory contents
           staa  CPU_SerialPeripheralDataIO
           bset  0x02, X, #$%00001000    ; set bits -00000010-
           bclr  0x02, X, #$%00001000    ; clear bits -00000010-
           nop                 ; no operation
           ldaa  CPU_SerialPeripheralDataIO    ; load A with memory contents
           cmpa  CPU_SerialPeripheralStatus    ; compare A with memory contents
           ldaa  Temp0         ; load A with memory contents
   LA1F5:  brclr 0x00, X, #$%00001000, LA1FF    ; branch if bit(s) clear -00000000-
           decb                ; decrement B
           bne   LA1F5         ; branch if not equal (not zero)
           jmp   LA297     

   LA1FF:  staa  CPU_SerialPeripheralDataIO
           bset  0x02, X, #$%00001000    ; set bits -00000010-
           bclr  0x02, X, #$%00001000    ; clear bits -00000010-
           nop                 ; no operation
           ldaa  CPU_SerialPeripheralDataIO    ; load A with memory contents
           staa  Temp0         ; store A into memory
           cmpa  CPU_SerialPeripheralStatus    ; compare A with memory contents
           ldaa  Temp1         ; load A with memory contents
   LA213:  brclr 0x00, X, #$%00001000, LA21D    ; branch if bit(s) clear -00000000-
           decb                ; decrement B
           bne   LA213         ; branch if not equal (not zero)
           jmp   LA297     

   LA21D:  staa  CPU_SerialPeripheralDataIO
           bset  0x02, X, #$%00001000    ; set bits -00000010-
           bclr  0x02, X, #$%00001000    ; clear bits -00000010-
           nop                 ; no operation
           ldaa  CPU_SerialPeripheralDataIO    ; load A with memory contents
           staa  Temp1         ; store A into memory
           cmpa  CPU_SerialPeripheralStatus    ; compare A with memory contents
           ldaa  Temp2         ; load A with memory contents
   LA231:  brclr 0x00, X, #$%00001000, LA23B    ; branch if bit(s) clear -00000000-
           decb                ; decrement B
           bne   LA231         ; branch if not equal (not zero)
           jmp   LA297     

   LA23B:  staa  CPU_SerialPeripheralDataIO
           bset  0x02, X, #$%00001000    ; set bits -00000010-
           bclr  0x02, X, #$%00001000    ; clear bits -00000010-
           nop                 ; no operation
           ldaa  CPU_SerialPeripheralDataIO    ; load A with memory contents
           staa  Temp2         ; store A into memory
           cmpa  CPU_SerialPeripheralStatus    ; compare A with memory contents
           ldaa  Temp3         ; load A with memory contents
   LA24F:  brclr 0x00, X, #$%00001000, LA258    ; branch if bit(s) clear -00000000-
           decb                ; decrement B
           bne   LA24F         ; branch if not equal (not zero)
           bra   LA297         ; branch

   LA258:  staa  CPU_SerialPeripheralDataIO
           bset  0x02, X, #$%00001000    ; set bits -00000010-
           bclr  0x02, X, #$%00001000    ; clear bits -00000010-
           nop                 ; no operation
   LA262:  brset 0x29, Y, #$%10000000, LA26C    ; branch if bit(s) set -00101001-
           decb                ; decrement B
           bne   LA262         ; branch if not equal (not zero)
           bra   LA297         ; branch

   LA26C:  ldaa  CPU_SerialPeripheralDataIO    ; load A with memory contents
           bset  0x08, Y, #$%00100000    ; set bits -00001000-
           cli                 ; enable interrupts
           suba  Temp0     
           suba  Temp1     
           suba  Temp2     
           bne   LA297         ; branch if not equal (not zero)
           ldaa  Temp0         ; load A with memory contents
           anda  #0x0f         ; AND a with value -00001111-
           cmpa  #0x01         ; compare a with value -00000001-
           bne   LA290         ; branch if not equal (not zero)
           bset  *CCDFlags5, #$%01000000    ; set bits
           brset *CCDFlags6, #$%10000000, LA297    ; branch if bit(s) set
           bset  *CCDFlags4, #$%00010000    ; set bits
           bra   LA297         ; branch

   LA290:  cmpa  #0x04         ; compare a with value -00000100-
           bne   LA297         ; branch if not equal (not zero)
           bset  *BitFlags37, #bf37_ATX | bf37_ATXInDrive    ; set bits
   LA297:  cli                 ; enable interrupts
           rts                 ; return from subroutine

PrepareCCDDataForXmit_MM:
           ldab  Counter_MainLoop    ; load B with memory contents
           andb  #0x0f         ;  -00001111-
           bne   LA2E1         ; branch if not equal (not zero)
           brset *CCDFlags4, #$%00001000, LA2C5    ; branch if bit(s) set
           ldaa  KeyOnOrEngineRunningTime    ; load A with memory contents
           cmpa  #0x83         ; compare a with value -10000011-
           bcs   LA2DD         ; branch if lower
           ldaa  EngineRpm_HB    ; load A with memory contents
           cmpa  #0x2f         ; compare a with value -00101111-
   LA2AD:  bcs   LA2DD         ; branch if lower
           ldaa  BatteryVolts    ; load A with memory contents
           cmpa  #0xbd         ; compare a with value -10111101-
           bcc   LA2DD         ; branch if greater or equal
           ldab  CCDCounterX    ; load B with memory contents
           incb                ; increment B
           stab  CCDCounterX    ; store B into memory
           cmpb  #0x71         ;  -01110001-
           bcs   LA2E1         ; branch if lower
           bset  *CCDFlags4, #$%00001000    ; set bits
           bra   LA2DD         ; branch

   LA2C5:  ldaa  TargetBatteryVolts    ; load A with memory contents
           suba  BatteryVolts
           bcs   LA2CF         ; branch if lower
           cmpa  #0x01         ; compare a with value -00000001-
           bhi   LA2DD         ; branch if higher
   LA2CF:  ldab  CCDCounterX    ; load B with memory contents
           incb                ; increment B
           stab  CCDCounterX    ; store B into memory
           cmpb  #0x22         ;  -00100010-
           bcs   LA2E1         ; branch if lower
           bclr  *CCDFlags4, #$%00001000    ; clear bits
   LA2DD:  clra                ; A = 0
           staa  CCDCounterX
   LA2E1:  brset *Counter_MainLoop, #$%00000001, LA2FA    ; branch if bit(s) set
           ldx   #CCDDataStream    ; load index with value
           ldab  CCDVar0       ; load B with memory contents
           asld                ; shift left (D=D*2)
           addb  #0x02         ;  -00000010-
           abx                 ; add B to index
           lsrd                ; shift right (D=D/2)
           stab  CCDVar0       ; store B into memory
           ldx   0x00, X      ;  -00000000-
           jsr   0x00, X      ;  -00000000-
           std   Temp1         ; store D (A&B) into memory
           jsr   CCDBusComs    ; call subroutine
   LA2FA:  ldaa  CountdownTimerFromKeyOn    ; load A with memory contents
           bne   LA308         ; branch if not equal (not zero)
           ldaa  CONFIG_ConfigurationFlags    ; load A with memory contents (data is 92)
           bita  #0x04         ;  -00000100-
           beq   CCD_HandleAlarm         ; branch if equal (zero)
           bclr  *CCDFlags5, #ccd_AlarmDisable    ; clear bits
   LA308:  rts                 ; return from subroutine

CCD_HandleAlarm:
           ldaa  CPU_EEPROMControlReg    ; load A with memory contents
           bita  #0x02         ;  -00000010-
           bne   LA31D         ; branch if not equal (not zero)
           bclr  *CCDFlags4, #$%00100000    ; clear bits
           ldaa  LB612         ; load A with memory contents (data is ff)
           bita  #0x01         ;  -00000001-
           beq   LA31D         ; branch if equal (zero)
           bset  *CCDFlags4, #$%00100000    ; set bits
   LA31D:  ldaa  Counter_MainLoop    ; load A with memory contents
           bita  #0x03         ;  -00000011-
           bne   LA386         ; branch if not equal (not zero)
           brclr *CCDFlags5, #$%01000000, LA345    ; branch if bit(s) clear
           bset  *CCDFlags5, #$%10000000    ; set bits
           bclr  *CCDFlags5, #$%01100000    ; clear bits
           bclr  *CCDFlags6, #$%01111111    ; clear bits
           brset *CCDFlags6, #$%10000000, LA386    ; branch if bit(s) set
           ldaa  BitFlags70    ; load A with memory contents
           bita  #0x03         ;  -00000011-
           bne   LA386         ; branch if not equal (not zero)
           ldaa  LB612         ; load A with memory contents (data is ff)
           bita  #0x02         ;  -00000010-
           beq   LA386         ; branch if equal (zero)
           anda  #0xfd         ; AND a with value -11111101-
           bra   LA374         ; branch

   LA345:  ldaa  CCDFlags6    ; load A with memory contents
           anda  #0x7f         ; AND a with value -01111111-
           brclr *CCDFlags5, #$%10000000, LA353    ; branch if bit(s) clear
           cmpa  #0x7e         ; compare a with value -01111110-
           bcc   LA35C         ; branch if greater or equal
           bra   LA357         ; branch

   LA353:  cmpa  #0x2d         ; compare a with value -00101101-
           bcc   LA386         ; branch if greater or equal
   LA357:  inc   CCDFlags6
           bra   LA386         ; branch

   LA35C:  ldaa  BitFlags70    ; load A with memory contents
           bita  #0x03         ;  -00000011-
           bne   LA386         ; branch if not equal (not zero)
           ldaa  LB612         ; load A with memory contents (data is ff)
           bita  #0x02         ;  -00000010-
           bne   LA386         ; branch if not equal (not zero)
           bset  *CCDFlags6, #$%10000000    ; set bits
           oraa  #0x02         ;  -00000010-
           cmpa  #0x4c         ; compare a with value -01001100-
           bcc   LA374         ; branch if greater or equal
           oraa  #0xff         ;  -11111111-
   LA374:  sei                 ; disable interrupts
           brclr *BitFlags70, #$%00000011, LA37C    ; branch if bit(s) clear
           cli                 ; enable interrupts
           bra   LA386         ; branch

   LA37C:  bset  *BitFlags70, #$%00000001    ; set bits
           cli                 ; enable interrupts
           staa  DRBOffsetStored_LB    ; store A into memory
           ldaa  #0x12         ; load a with value -00010010-
           staa  DRBOffsetStored_HB    ; store A into memory
   LA386:  brclr *CCDFlags5, #$%00010000, LA39A    ; branch if bit(s) clear
           brset *CCDFlags5, #$%10000000, LA399    ; branch if bit(s) set
           ldaa  CCDFlags6    ; load A with memory contents
           anda  #0x7f         ; AND a with value -01111111-
           cmpa  #0x2d         ; compare a with value -00101101-
           bcs   LA399         ; branch if lower
           bset  *CCDFlags5, #ccd_AlarmDisable    ; set bits
   LA399:  rts                 ; return from subroutine

   LA39A:  brset *CCDFlags5, #$%00010000, LA3E8    ; branch if bit(s) set
           brset *BitFlags6F, #b6f_FuelEngineNotRunning, LA3E8    ; branch if bit(s) set
           ldaa  BitFlags70    ; load A with memory contents
           bita  #0x03         ;  -00000011-
           bne   LA3E8         ; branch if not equal (not zero)
           ldaa  LB612         ; load A with memory contents (data is ff)
           bita  #0x01         ;  -00000001-
           bne   LA3B5         ; branch if not equal (not zero)
           bita  #0x02         ;  -00000010-
           bne   LA3E2         ; branch if not equal (not zero)
           bra   LA3E5         ; branch

   LA3B5:  brset *CCDFlags5, #$%10000000, LA3C3    ; branch if bit(s) set
           ldaa  CCDFlags6    ; load A with memory contents
           anda  #0x7f         ; AND a with value -01111111-
           cmpa  #0x2d         ; compare a with value -00101101-
           bcs   LA3E8         ; branch if lower
           bra   LA3DF         ; branch

   LA3C3:  sei                 ; disable interrupts
           brclr *BitFlags70, #$%00000011, LA3CB    ; branch if bit(s) clear
           cli                 ; enable interrupts
           bra   LA3E8         ; branch

   LA3CB:  bset  *BitFlags70, #$%00000001    ; set bits
           cli                 ; enable interrupts
           adda  #0x04         ;  -00000100-
           cmpa  #0x4c         ; compare a with value -01001100-
           bcs   LA3D7         ; branch if lower
           anda  #0xfe         ; AND a with value -11111110-
   LA3D7:  anda  #0xfd         ; AND a with value -11111101-
           staa  DRBOffsetStored_LB    ; store A into memory
           ldaa  #0x12         ; load a with value -00010010-
           staa  DRBOffsetStored_HB    ; store A into memory
   LA3DF:  bset  *CCDFlags4, #$%00100000    ; set bits
   LA3E2:  bset  *CCDFlags5, #$%10000000    ; set bits
   LA3E5:  bset  *CCDFlags5, #$%00010000    ; set bits
   LA3E8:  rts                 ; return from subroutine

CCD_Blank:
           ldd   #0x0000        ; load D (A&B) with value -00000000 00000000-
           staa  Temp0         ; store A into memory
           rts                 ; return from subroutine

CCD_EngineRPM:
           ldaa  #0xe4         ; load a with value -11100100-
           staa  Temp0         ; store A into memory
           ldaa  EngineRpm_HB    ; load A with memory contents
           ldab  MapValue      ; load B with memory contents
           rts                 ; return from subroutine

CCD_FuelOutput:
           ldaa  #0x84         ; load a with value -10000100-
           staa  Temp0         ; store A into memory
           sei                 ; disable interrupts
           ldaa  CCDTemp_X     ; load A with memory contents
           ldab  MapValueX     ; load B with memory contents
           clr   CCDTemp_X     ; zero byte at memory location
           clr   MapValueX     ; zero byte at memory location
           cli                 ; enable interrupts
           rts                 ; return from subroutine

CCD_ConfigConst1:
           ldaa  #0xac         ; load a with value -10101100-
           staa  Temp0         ; store A into memory
           ldd   CCDCFG_CCDConfigConstant    ;  (data is 2130)
           rts                 ; return from subroutine

CCD_CoolantTemp:
           ldaa  #0x8c         ; load a with value -10001100-
           staa  Temp0         ; store A into memory
           ldaa  CoolantTemp    ; load A with memory contents
           ldab  AmbientAirTempVolts    ; load B with memory contents
           rts                 ; return from subroutine

CCD_BatVolts:
           ldaa  #0xd4         ; load a with value -11010100-
           staa  Temp0         ; store A into memory
           ldaa  BatteryVolts    ; load A with memory contents
           bsr   LA42D         ; call subroutine
           stab  Temp3         ; store B into memory
           ldaa  TargetBatteryVolts    ; load A with memory contents
           bsr   LA42D         ; call subroutine
           ldaa  Temp3         ; load A with memory contents
           rts                 ; return from subroutine

   LA42D:  ldab  CCDBatteryVoltsOutput    ; load B with memory contents
           cmpb  #0x10         ;  -00010000-
           bhi   LA446         ; branch if higher
           comb                ; 1's complement B
           addb  #0x09         ;  -00001001-
           bcs   LA43D         ; branch if lower
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           bra   LA446         ; branch

   LA43D:  staa  Temp4         ; store A into memory
           mul                 ; multiply (D=A*B)
           adca  Temp4     
           bcc   LA446         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   LA446:  tab                 ; B = A
           rts                 ; return from subroutine

CCD_ThrottlePos:
           ldaa  #0x42         ; load a with value -01000010-
           staa  Temp0         ; store A into memory
           ldaa  TPSVolts      ; load A with memory contents
           suba  MINTHR_LowestSessionTPS
           bcc   LA453         ; branch if greater or equal
           clra                ; A = 0
   LA453:  clrb                ; b = 0
           rts                 ; return from subroutine

CCD_TargetIdleSPeed:
           ldaa  #0xcc         ; load a with value -11001100-
           staa  Temp0         ; store A into memory
           ldaa  CPU_EEPROMControlReg    ; load A with memory contents
           bita  #0x02         ;  -00000010-
           bne   CCD_Blank     ; branch if not equal (not zero)
           ldd   LB600         ;  (data is ffff)
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           staa  Temp3         ; store A into memory
           ldd   TargetIdleSpeedHB    ; load D (A&B) with memory contents
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           tab                 ; B = A
           ldaa  Temp3         ; load A with memory contents
           rts                 ; return from subroutine

CCD_Baro:
           ldaa  #0x54         ; load a with value -01010100-
           staa  Temp0         ; store A into memory
           ldaa  BaroPressure    ; load A with memory contents
           clrb                ; b = 0
           rts                 ; return from subroutine

CCD_VehicleSpeed:
           ldaa  #0x24         ; load a with value -00100100-
           staa  Temp0         ; store A into memory
           ldd   VehicleSpeed_HB    ; load D (A&B) with memory contents
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           staa  Temp3         ; store A into memory
           asld                ; shift left (D=D*2)
           bcc   LA486         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   LA486:  ldab  #0x34         ; load B with value -00110100-
           mul                 ; multiply (D=A*B)
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           lslb                ; arithmetic shift left B
           adca  #0x00         ;  -00000000-
           tab                 ; B = A
           ldaa  Temp3         ; load A with memory contents
           rts                 ; return from subroutine

CCD_EEPromData:
           ldaa  CPU_EEPROMControlReg    ; load A with memory contents
           bita  #0x02         ;  -00000010-
           bne   LA4C2         ; branch if not equal (not zero)
           ldx   #0xb672       ; load index with value
           ldab  CCDFlags4     ; load B with memory contents
           tba                 ; A = B
           incb                ; increment B
           andb  #0x07         ;  -00000111-
           anda  #0xf8         ; AND a with value -11111000-
           cmpb  #0x06         ;  -00000110-
           bne   LA4A9         ; branch if not equal (not zero)
           clrb                ; b = 0
   LA4A9:  aba                 ; A=A+B
           staa  CCDFlags4     ; store A into memory
           lslb                ; arithmetic shift left B
           lslb                ; arithmetic shift left B
           abx                 ; add B to index
           brset 0x00, X, #$%11111111, LA4C2    ; branch if bit(s) set -00000000-
           ldaa  0x00, X      ; load A with memory at index + value -00000000-
           staa  Temp0         ; store A into memory
           adda  0x01, X      ;  -00000001-
           adda  0x02, X      ;  -00000010-
           cmpa  0x03, X      ; compare A with memory at index + value -00000011-
           bne   LA4C2         ; branch if not equal (not zero)
           ldd   0x01, X      ;  -00000001-
           rts                 ; return from subroutine

   LA4C2:  jmp   CCD_Blank 

CCD_ToggleFlags:
           ldaa  #0xec         ; load a with value -11101100-
           staa  Temp0         ; store A into memory
           clra                ; A = 0
           brclr *b5C_IPL1, #$%00000010, LA4D0    ; branch if bit(s) clear
           oraa  #0x01         ;  -00000001-
   LA4D0:  brclr *b5C_IPL1, #$%01000000, LA4D6    ; branch if bit(s) clear
           oraa  #0x02         ;  -00000010-
   LA4D6:  brclr *CCDFlags4, #$%00001000, LA4DC    ; branch if bit(s) clear
           oraa  #0x04         ;  -00000100-
   LA4DC:  brclr *b5C_IPL1, #$%00000100, LA4E2    ; branch if bit(s) clear
           oraa  #0x08         ;  -00001000-
   LA4E2:  ldab  CCDCF3_CCDConfigConstant3    ; load B with memory contents (data is 64)
           andb  #0xfc         ;  -11111100-
           brclr *CCDFlags4, #$%00010000, LA4F0    ; branch if bit(s) clear
           bclr  *CCDFlags4, #$%00010000    ; clear bits
           orab  #0x01         ;  -00000001-
   LA4F0:  brclr *CCDFlags4, #$%00100000, LA4F6    ; branch if bit(s) clear
           orab  #0x02         ;  -00000010-
   LA4F6:  rts                 ; return from subroutine

CCD_SwitchState:
           ldaa  #0xa4         ; load a with value -10100100-
           staa  Temp0         ; store A into memory
           clra                ; A = 0
           brset *CruiseStatus_1, #$%10000000, LA502    ; branch if bit(s) set
           oraa  #0x01         ;  -00000001-
   LA502:  ldab  TPSVolts      ; load B with memory contents
           subb  MINTHR_LowestSessionTPS    ; B = B-memory contents
           bcs   LA50E         ; branch if lower
           cmpb  #0x05         ;  -00000101-
           bcs   LA50E         ; branch if lower
           oraa  #0x02         ;  -00000010-
   LA50E:  brclr *StartupSwitchMirror1, #$%00100000, LA514    ; branch if bit(s) clear
           oraa  #0x04         ;  -00000100-
   LA514:  brclr *PIA2_Buffer, #$%00000001, LA51A    ; branch if bit(s) clear
           oraa  #0x08         ;  -00001000-
   LA51A:  brset *StartupSwitchMirror2, #$%01000000, LA520    ; branch if bit(s) set
           oraa  #0x20         ;  -00100000-
   LA520:  brset *StartupSwitchMirror2, #$%00100000, LA526    ; branch if bit(s) set
           oraa  #0x10         ;  -00010000-
   LA526:  ldab  CONFIG_ConfigurationFlags    ; load B with memory contents (data is 92)
           bitb  #0x20         ;  -00100000-
           beq   LA533         ; branch if equal (zero)
           brclr *BitFlags_AIS, #$%00001000, LA533    ; branch if bit(s) clear
           oraa  #0x40         ;  -01000000-
   LA533:  clrb                ; b = 0
           rts                 ; return from subroutine


;	.org	0xa535
CCDDataStream:
	.word	CCD_EngineRPM
	.word	CCD_FuelOutput
	.word	CCD_Blank
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_BatVolts
	.word	CCD_Blank
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_VehicleSpeed
	.word	CCD_SwitchState
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_ThrottlePos
	.word	CCD_Blank
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_FuelOutput
	.word	CCD_Blank
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_Baro
	.word	CCD_Blank
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_VehicleSpeed
	.word	CCD_SwitchState
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_ThrottlePos
	.word	CCD_Blank
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_FuelOutput
	.word	CCD_Blank
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_CoolantTemp
	.word	CCD_Blank
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_VehicleSpeed
	.word	CCD_SwitchState
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_ThrottlePos
	.word	CCD_Blank
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_FuelOutput
	.word	CCD_Blank
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_TargetIdleSPeed
	.word	CCD_Blank
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_VehicleSpeed
	.word	CCD_SwitchState
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_ThrottlePos
	.word	CCD_Blank
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_FuelOutput
	.word	CCD_ToggleFlags
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_BatVolts
	.word	CCD_Blank
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_VehicleSpeed
	.word	CCD_SwitchState
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_ThrottlePos
	.word	CCD_Blank
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_FuelOutput
	.word	CCD_Blank
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_EEPromData
	.word	CCD_Blank
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_VehicleSpeed
	.word	CCD_SwitchState
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_ThrottlePos
	.word	CCD_Blank
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_FuelOutput
	.word	CCD_Blank
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_CoolantTemp
	.word	CCD_Blank
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_VehicleSpeed
	.word	CCD_SwitchState
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_ThrottlePos
	.word	CCD_Blank
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_FuelOutput
	.word	CCD_Blank
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_ConfigConst1
	.word	CCD_Blank
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_VehicleSpeed
	.word	CCD_SwitchState
	.word	CCD_Blank
	.word	CCD_EngineRPM
	.word	CCD_ThrottlePos
	.word	CCD_Blank
	.word	CCD_Blank
HandleO2Processing_MM:
           ldab  L64D4         ; load B with memory contents
           beq   LA649         ; branch if equal (zero)
           cmpb  #0x02         ;  -00000010-
           bne   LA649         ; branch if not equal (not zero)
           ldab  L64D5         ; load B with memory contents
           cmpb  #0x02         ;  -00000010-
           beq   LA649         ; branch if equal (zero)
           bset  *BitFlags67, #$%00010100    ; set bits
           rts                 ; return from subroutine

   LA649:  clra                ; A = 0
           ldab  MapValue      ; load B with memory contents
           cmpb  MAPDEC_NoCellUpdateAndO2CNTRHeldBelowThisMap    ; compare B with memory contents (data is 1e)
           bls   LA664         ; branch if lower or same
           ldab  Timer_O2InhibitSwitchingRichIdleToClosedLoop    ; load B with memory contents
           orab  Factor_DecelLeanoutWhenMAPDecreasing
           bne   LA664         ; branch if not equal (not zero)
           ldab  Timer_OpenLoopFraction    ; load B with memory contents
           beq   LA65F         ; branch if equal (zero)
           brset *BitFlags66, #b66_OffIdle, LA664    ; branch if bit(s) set
   LA65F:  bclr  *BitFlags67, #b67_StayOpenLoop    ; clear bits
           bra   LA669         ; branch

   LA664:  bset  *BitFlags67, #b67_StayOpenLoop    ; set bits
           staa  Timer_OutOfClosedLoopMode    ; store A into memory
   LA669:  brset *BitFlags66, #b66_FullThrottle, LA673    ; branch if bit(s) set
           bra   LA679         ; branch

   LA66F:  brclr *BitFlags67, #b67_StayOpenLoop, LA679    ; branch if bit(s) clear
   LA673:  brset *BitFlags66, #b66_O2Valid, O2_StopUsingFeedback    ; branch if bit(s) set
           bra   LA67D         ; branch

   LA679:  brset *BitFlags66, #b66_O2Valid, O2_UsingFeedback    ; branch if bit(s) set
   LA67D:  ldab  CoolantTemp    ; load B with memory contents
           cmpb  CLTEMP_TempToStartCLTIMETimer    ; compare B with memory contents (data is 92)
           bcs   O2_StopUsingFeedback    ; branch if lower
           brset *BitFlags66, #b66_OpenLoop, LA698    ; branch if bit(s) set
           ldab  Counter_MainLoop    ; load B with memory contents
           bne   O2_StopUsingFeedback    ; branch if not equal (not zero)
           ldab  Timer_CLTIME_ClosedLoopTimer    ; load B with memory contents
           beq   LA695         ; branch if equal (zero)
           decb                ; decrement B
           stab  Timer_CLTIME_ClosedLoopTimer    ; store B into memory
           bne   O2_StopUsingFeedback    ; branch if not equal (not zero)
   LA695:  bset  *BitFlags66, #b66_OpenLoop    ; set bits
   LA698:  ldab  O2SensorVolts    ; load B with memory contents
           cmpb  O2HIGH_HighLimitForImmediateSwitchToClosedLoop    ; compare B with memory contents (data is 26)
           bcc   O2_ValidSignal_OutsideMiddleRange    ; branch if greater or equal
           cmpb  O2LOW_LowLimitForImmediateSwitchToClosedLoop    ; compare B with memory contents (data is 0f)
           bcc   O2_InvalidSignal_InMiddleRange    ; branch if greater or equal
O2_ValidSignal_OutsideMiddleRange:
           brset *PIA1_Buffer, #$%00001000, O2_StopUsingFeedback    ; branch if bit(s) set
           bset  *BitFlags66, #b66_O2Valid    ; set bits
           staa  Counter_AdaptiveMem_Erase    ; store A into memory
           clrb                ; b = 0
           bra   LA6CD         ; branch

O2_InvalidSignal_InMiddleRange:
           brset *Timer_CLTIME_ClosedLoopTimer, #$%10000000, LA6C1    ; branch if bit(s) set
           cmpb  O2TLMH_HighLimitForDelayedSwitchToClosedLoop    ; compare B with memory contents (data is 26)
           bcc   LA6BE         ; branch if greater or equal
           cmpb  O2TLML_LowLimitForDelayedSwitchToClosedLoop    ; compare B with memory contents (data is 0f)
           bcc   O2_StopUsingFeedback    ; branch if greater or equal
   LA6BE:  bset  *Timer_CLTIME_ClosedLoopTimer, #$%10000000    ; set bits
   LA6C1:  ldab  Counter_MainLoop    ; load B with memory contents
           bne   O2_StopUsingFeedback    ; branch if not equal (not zero)
           ldab  Timer_CLTIME_ClosedLoopTimer    ; load B with memory contents
           cmpb  O2TIME_DelayTimeToClosedLoop    ; compare B with memory contents (data is 07)
           bmi   O2_ValidSignal_OutsideMiddleRange    ; branch if minus(hi bit 1)
           incb                ; increment B
   LA6CD:  stab  Timer_CLTIME_ClosedLoopTimer    ; store B into memory
O2_StopUsingFeedback:
           staa  Counter_O2SensorFeedbackCount_Signed    ; store A into memory
           staa  Timer_OutOfClosedLoopMode    ; store A into memory
           bset  *BitFlags67, #$%00010100    ; set bits
           rts                 ; return from subroutine

O2_UsingFeedback:
           ldab  O2SensorVolts    ; load B with memory contents
           cmpb  O2MIDX_HighLimitForInMiddleDeterminationX    ; compare B with memory contents (data is 3e)
           bcc   O2Signal_InOuterMiddleRange    ; branch if greater or equal
           cmpb  O2MIDH_HighLimitForInMiddleDetermination    ; compare B with memory contents (data is 1f)
           bcc   LA6FB         ; branch if greater or equal
           cmpb  O2MIDL_LowLimitForInMiddleDetermination    ; compare B with memory contents (data is 12)
           bcs   LA6FB         ; branch if lower
           ldaa  KeyOnOrEngineRunningTime    ; load A with memory contents
           cmpa  #0x2c         ; compare a with value -00101100-
           bcs   LA6FA         ; branch if lower
O2Signal_InOuterMiddleRange:
           ldaa  Timer_CLTIME_ClosedLoopTimer    ; load A with memory contents
           inca                ; increment A
           bne   LA6F6         ; branch if not equal (not zero)
           jmp   Save_CLTIME_ToOtherTimers_O2InMiddle

   LA6F6:  brset *Counter_MainLoop, #$%00000001, LA6FD    ; branch if bit(s) set
   LA6FA:  clra                ; A = 0
   LA6FB:  staa  Timer_CLTIME_ClosedLoopTimer    ; store A into memory
   LA6FD:  clra                ; A = 0
           cmpb  O2HSWP_HighLimitForO2RampSwitching    ; compare B with memory contents (data is 19)
           bcc   O2Signal_AboveToggle    ; branch if greater or equal
           cmpb  O2LSWP_LowLimitForO2RampSwitching    ; compare B with memory contents (data is 18)
           bcs   O2Signal_BelowToggle    ; branch if lower
           rts                 ; return from subroutine

O2Signal_AboveToggle:
           deca                ; decrement A
O2Signal_BelowToggle:
           staa  Temp0         ; store A into memory
           brclr *EGRVar2, #$%10000000, LA716    ; branch if bit(s) clear
           clr   Counter_AdaptiveMem_Erase    ; zero byte at memory location
   LA713:  jmp   LA766     

   LA716:  ldab  EngineRpm_HB    ; load B with memory contents
           cmpb  RPMLIM_NoCellUpdateAboveThisRPMInRPMOver32    ; compare B with memory contents (data is 56)
           bhi   LA713         ; branch if higher
           ldab  Timer_FuelEnrich    ; load B with memory contents
           orab  Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop
           bne   LA766         ; branch if not equal (not zero)
           ldab  MapValue      ; load B with memory contents
           cmpb  MAPLIM_NoCellUpdateAboveThisMAP    ; compare B with memory contents (data is 88)
           bhi   LA766         ; branch if higher
           cmpb  MAPDEC_NoCellUpdateAndO2CNTRHeldBelowThisMap    ; compare B with memory contents (data is 1e)
           bls   SwitchOrStayOpenLoop    ; branch if lower or same
           cmpb  BOOSTP_AdjustO2ResponseForPTEWhenMapAboveThis ; MAPINC_NoCellUpdateAndO2CNTRHeldAboveThisMap    
           bcc   SwitchOrStayOpenLoop    ; branch if greater or equal
           ldab  Factor_DecelLeanoutWhenMAPDecreasing    ; load B with memory contents
           orab  Timer_OpenLoopFraction
           bne   SwitchOrStayOpenLoop    ; branch if not equal (not zero)
           ldab  CylTrim_Adaptive_Var1    ; load B with memory contents
           beq   LA743         ; branch if equal (zero)
           cmpb  CLTRMN_MinimumCylinderTrim    ; compare B with memory contents (data is 07)
           bcs   SwitchOrStayOpenLoop    ; branch if lower
   LA743:  ldab  CALTHP_O2ControllerDeadbandLimitForUpdatingCellsPos    ; load B with memory contents (data is 09)
           brset *BitFlags66, #b66_OffIdle, LA751    ; branch if bit(s) set
           brset *BitFlags67, #b67_FallToIdle, LA751    ; branch if bit(s) set
           ldab  CALTHN_O2ControllerDeadbandLimitForUpdatingCellsNeg    ; load B with memory contents (data is 09)
   LA751:  brset *Temp0, #$%11111111, LA756    ; branch if bit(s) set
           negb                ; 2's complement B
   LA756:  addb  Counter_O2SensorFeedbackCount_Signed    ; B=B+memory contents
           bvs   SwitchOrStayOpenLoop    ; branch if no overflow
           eorb  Temp0     
           bmi   SwitchOrStayOpenLoop    ; branch if minus(hi bit 1)
           bclr  *BitFlags67, #b67_OpenLoop    ; clear bits
           bclr  *CylTrim_FlagsF0, #$%00100000    ; clear bits
           bra   SwitchOrStayClosedLoop    ; branch

   LA766:  bset  *CylTrim_FlagsF0, #$%00100000    ; set bits
SwitchOrStayOpenLoop:
           bset  *BitFlags67, #b67_OpenLoop    ; set bits
SwitchOrStayClosedLoop:
           clra                ; A = 0
           brclr *BitFlags67, #b67_StayOpenLoop, LA774    ; branch if bit(s) clear
           staa  Counter_AdaptiveMem_Erase    ; store A into memory
           rts                 ; return from subroutine

   LA774:  ldab  Temp0         ; load B with memory contents
           eorb  BitFlags66
           andb  #0x04         ;  -00000100-
           beq   O2HasNotToggled    ; branch if equal (zero)
           eorb  BitFlags66
           stab  BitFlags66    ; store B into memory
           clrb                ; b = 0
           ldaa  Timer_OutOfClosedLoopMode    ; load A with memory contents
           stab  Timer_OutOfClosedLoopMode    ; store B into memory
           stab  Timer_O2ToggleDuration    ; store B into memory
           bclr  *BitFlags69, #$%00000011    ; clear bits
           bclr  *BitFlags71, #b71_BadO2    ; b67_BadO2
           bra   WorkWithPrimaryRamp    ; branch

O2HasNotToggled:
           ldab  Timer_OutOfClosedLoopMode    ; load B with memory contents
           beq   LA7C8         ; branch if equal (zero)
WorkWithPrimaryRamp:
           staa  Temp0         ; store A into memory
           ldx   #PRIRMP_PrimaryRamp    ; load index with value
           jsr   DetermineRampCellFromRPMandMAP    ; call subroutine
           ldab  Timer_OutOfClosedLoopMode    ; load B with memory contents
           addb  0x00, X      ; add memory at index + value to B -00000000-
           sba                 ; subtract (A=A-B)
           bhi   LA7AC         ; branch if higher
           adda  0x00, X      ;  -00000000-
           bpl   LA7A7         ; branch if plus (hi bit 0)
           clra                ; A = 0
   LA7A7:  clrb                ; b = 0
           stab  Timer_OutOfClosedLoopMode    ; store B into memory
           bra   LA7B3         ; branch

   LA7AC:  ldaa  0x00, X      ; load A with memory at index + value -00000000-
           tab                 ; B = A
           addb  Timer_OutOfClosedLoopMode    ; B=B+memory contents
           stab  Timer_OutOfClosedLoopMode    ; store B into memory
   LA7B3:  ldab  Temp0         ; load B with memory contents
           beq   LA7BB         ; branch if equal (zero)
           cba                 ; compare A to B
           bcs   LA7BB         ; branch if lower
           tba                 ; A = B
   LA7BB:  ldab  BitFlags66    ; load B with memory contents
           bitb  #b66_O2Rich         ;  -00000100-
           beq   LA7C2         ; branch if equal (zero)
           nega                ; negate A (set high bit)
   LA7C2:  jsr   IncrementO2SensorFeedbackCount    ; call subroutine
           clra                ; A = 0
           bra   LA7D8         ; branch

   LA7C8:  brset *BitFlags67, #b67_StayOpenLoop, LA7DA    ; branch if bit(s) set
           ldaa  Counter_AdaptiveMem_Erase    ; load A with memory contents
           cmpa  LTHTIM_IfNoO2SwitchForThisTimeThrowFault51or52    ; compare A with memory contents (data is 2c)
           bcc   EraseAdaptiveMemory_possiblySetErrorBit    ; branch if greater or equal
           ldab  Counter_MainLoop    ; load B with memory contents
           bne   LA7DA         ; branch if not equal (not zero)
           inca                ; increment A
   LA7D8:  staa  Counter_AdaptiveMem_Erase    ; store A into memory
   LA7DA:  rts                 ; return from subroutine

EraseAdaptiveMemory_possiblySetErrorBit:
           brset *BitFlags69, #$%00000011, LA7E4    ; branch if bit(s) set
           inc   BitFlags69
           bra   EraseAdaptiveMemory1    ; branch

   LA7E4:  bset  *BitFlags71, #b71_BadO2    ; set bits
           ldd   #0x0301       ; load D (A&B) with value -00000011 00000001-
           brset *BitFlags66, #b66_O2Rich, LA7EF    ; branch if bit(s) set
           inca                ; increment A
   LA7EF:  jsr   ThrowNonCriticalError    ; call subroutine
EraseAdaptiveMemory1:
           clra                ; A = 0
           staa  ValueFromAdaptiveMemory    ; store A into memory
           ldx   #AutoCalCell0    ; load index with value
   LA7F8:  staa  0x00, X      ;  -00000000-
           inX                 ; increment index (I=I+1)
           cpx   #ErrorBitRegister0    ;  -00000000 00011101-
           bne   LA7F8         ; branch if not equal (not zero)
Save_CLTIME_ToOtherTimers_O2InMiddle:
           staa  AdaptiveCellUpdateTimer_IncrementedEveryCamRisingEdge    ; store A into memory
           staa  Counter_AdaptiveMem_Erase    ; store A into memory
           staa  Timer_CLTIME_ClosedLoopTimer    ; store A into memory
           bclr  *BitFlags66, #b66_O2Valid    ; clear bits
           rts                 ; return from subroutine

ModifyO2FeedbackCountVarToMaintainStoich_MM:
           brset *BitFlags67, #b67_StayOpenLoop, LA812    ; branch if bit(s) set
           brset *BitFlags66, #b66_O2Valid, WorkWithSecondaryRamp    ; branch if bit(s) set
   LA812:  clra                ; A = 0
           staa  Timer_O2ToggleDuration    ; store A into memory
           rts                 ; return from subroutine

WorkWithSecondaryRamp:
           ldx   #SECRMP_SecondaryRamp    ; load index with value
           bsr   DetermineRampCellFromRPMandMAP    ; call subroutine
           sei                 ; disable interrupts
           ldaa  Timer_O2ToggleDuration    ; load A with memory contents
           brclr *EGRVar2, #$%10000000, LA827    ; branch if bit(s) clear
           suba  SCRMP1_SecondaryRampSubtractor1    ;  (data is 02)
           bra   O2_FullThrottle    ; branch

   LA827:  sba                 ; subtract (A=A-B)
O2_FullThrottle:
           bcc   O2_SensorStuckOnOneSideTooLong    ; branch if greater or equal
           cli                 ; enable interrupts
           rts                 ; return from subroutine

O2_SensorStuckOnOneSideTooLong:
           staa  Timer_O2ToggleDuration    ; store A into memory
           cli                 ; enable interrupts
           ldaa  0x00, X      ; load A with memory at index + value -00000000-
IncrementO2SensorFeedbackCount:
           ldab  O2LIMH_O2RangeLimitHigh    ; load B with memory contents (data is 40)
           adda  Counter_O2SensorFeedbackCount_Signed
           bvc   DIDNT_2SCOMPLEMENT_OVERFLOW_UNDERFLOW1    ; branch if overflow
           brclr *Counter_O2SensorFeedbackCount_Signed, #$%10000000, SET_TO_MAX_OR_MIN_VALUE    ; branch if bit(s) clear
           ldab  O2LIML_O2RangeLimitLow    ; load B with memory contents (data is c0)
           bra   SET_TO_MAX_OR_MIN_VALUE    ; branch

DIDNT_2SCOMPLEMENT_OVERFLOW_UNDERFLOW1:
           cba                 ; compare A to B
           bge   SET_TO_MAX_OR_MIN_VALUE    ; branch if greater or equal
           ldab  O2LIML_O2RangeLimitLow    ; load B with memory contents (data is c0)
           cba                 ; compare A to B
           bge   LA84B         ; branch if greater or equal
SET_TO_MAX_OR_MIN_VALUE:
           tba                 ; A = B
   LA84B:  brclr *BitFlags71, #b71_BadO2, LA852    ; branch if bit(s) clear
           tsta                ; test A
           bmi   DontUpdateO2FeedbackCount    ; branch if minus(hi bit 1)
   LA852:  staa  Counter_O2SensorFeedbackCount_Signed    ; store A into memory
DontUpdateO2FeedbackCount:
           rts                 ; return from subroutine

DetermineRampCellFromRPMandMAP:
           brset *BitFlags67, #b67_FallToIdle, LA861    ; branch if bit(s) set
           brset *BitFlags66, #b66_OffIdle, LA861    ; branch if bit(s) set
           ldab  #0x16         ; load B with value -00010110-
           bra   LA88B         ; branch

   LA861:  clrb                ; b = 0
           ldaa  EngineRpm_HB    ; load A with memory contents
   LA864:  cmpa  0x00, X      ; compare A with memory at index + value -00000000-
           bcs   LA870         ; branch if lower
           incb                ; increment B
           inX                 ; increment index (I=I+1)
           cmpb  #0x02         ;  -00000010-
           bcs   LA864         ; branch if lower
           bra   LA875         ; branch

   LA870:  tstb                ; test B
           bne   LA874         ; branch if not equal (not zero)
           inX                 ; increment index (I=I+1)
   LA874:  inX                 ; increment index (I=I+1)
   LA875:  ldaa  MapValue      ; load A with memory contents
   LA877:  cmpa  0x00, X      ; compare A with memory at index + value -00000000-
           bcs   LA884         ; branch if lower
           addb  #0x03         ;  -00000011-
           inX                 ; increment index (I=I+1)
           cmpb  #0x06         ;  -00000110-
           bcs   LA877         ; branch if lower
           bra   LA88A         ; branch

   LA884:  cmpb  #0x03         ;  -00000011-
           bcc   LA889         ; branch if greater or equal
           inX                 ; increment index (I=I+1)
   LA889:  inX                 ; increment index (I=I+1)
   LA88A:  lslb                ; arithmetic shift left B
   LA88B:  brclr *BitFlags66, #b66_O2Rich, LA890    ; branch if bit(s) clear
           incb                ; increment B
   LA890:  abx                 ; add B to index
           ldaa  0x14, X      ; load A with memory at index + value -00010100-
           tab                 ; B = A
           rts                 ; return from subroutine

AdaptiveMemory_UpdateCellIfRequired_MM:
           ldx   #AutoCalCell0    ; load index with value
           ldab  PointerIntoAdaptiveMemory    ; load B with memory contents
           abx                 ; add B to index
           brset *PIA2_Buffer, #$%00100000, LA8A3    ; branch if bit(s) set
           ldaa  CylTrim_Adaptive_Var1    ; load A with memory contents
           bne   LA8A8         ; branch if not equal (not zero)
   LA8A3:  bclr  *CylTrim_FlagsF0, #$%00010000    ; clear bits
           bra   LA8D3         ; branch

   LA8A8:  ldy   #Cyl2_InjPWTrim    ; load index with value
           cmpb  CL2PTR_Cyl2AdaptiveMemoryPointer    ; compare B with memory contents (data is 0c)
           beq   LA8C6         ; branch if equal (zero)
           inY                 ; increment index (I=I+1)
           cmpb  CL1PTR_Cyl1AdaptiveMemoryPointer    ; compare B with memory contents (data is 02)
           beq   LA8C6         ; branch if equal (zero)
           inY                 ; increment index (I=I+1)
           cmpb  CL3PTR_Cyl3AdaptiveMemoryPointer    ; compare B with memory contents (data is 04)
           beq   LA8C6         ; branch if equal (zero)
           inY                 ; increment index (I=I+1)
           cmpb  CL4PTR_Cyl4AdaptiveMemoryPointer    ; compare B with memory contents (data is 05)
           bne   LA8D3         ; branch if not equal (not zero)
   LA8C6:  xgdy                ; exchange D and index
           xgdx                ; exchange D and index
           brset *CylTrim_FlagsF0, #$%00010000, LA8D3    ; branch if bit(s) set
           clr   Counter_O2SensorFeedbackCount_Signed    ; zero byte at memory location
           bset  *CylTrim_FlagsF0, #$%00010000    ; set bits
   LA8D3:  ldab  AMUPDT_EPPsBetweenCalChangeUpdateOpenThrottle    ; load B with memory contents (data is 1a)
           brset *BitFlags66, #b66_OffIdle, UpdateAdaptive_OffIdle    ; branch if bit(s) set
           ldab  AMUPDI_EPPsBetweenCalChangeUpdateClosedThrottle    ; load B with memory contents (data is 1a)
UpdateAdaptive_OffIdle:
           brset *BitFlags67, #b67_OpenLoop, DontUpdateCell_MaybeUpdateTimer    ; branch if bit(s) set
           stab  Temp0         ; store B into memory
           ldd   InjectorPulsewidth_HB    ; load D (A&B) with memory contents
           addd  Pulsewidth_PartThrottleEnrichment_HB    ; D = D + memory contents
           subd  PWMIN_NoCellUpdateBelow_PWMIN_Pulsewidth    ;  (data is 00af)
           ldab  Temp0         ; load B with memory contents
           bcs   DontUpdateCell_MaybeUpdateTimer    ; branch if lower
           sei                 ; disable interrupts
           ldaa  AdaptiveCellUpdateTimer_IncrementedEveryCamRisingEdge    ; load A with memory contents
           sba                 ; subtract (A=A-B)
           bcs   DontUpdateCellOrTimer    ; branch if lower
           staa  AdaptiveCellUpdateTimer_IncrementedEveryCamRisingEdge    ; store A into memory
           cli                 ; enable interrupts
           ldaa  CELCHG_BitsChangePerUpdateWithinACell    ; load A with memory contents (data is 01)
           ldab  Counter_O2SensorFeedbackCount_Signed    ; load B with memory contents
           bpl   LA8FF         ; branch if plus (hi bit 0)
           nega                ; negate A (set high bit)
   LA8FF:  ldab  AMLIMH_MaxMultiplierCannotBeAbove7F    ; load B with memory contents (data is 00)
           adda  0x00, X      ;  -00000000-
           bvc   Adaptive_Overflowed    ; branch if overflow
           ldaa  0x00, X      ; load A with memory at index + value -00000000-
           bpl   Adaptive_SetCellToMaxOrMinValue    ; branch if plus (hi bit 0)
           ldab  AMLIML_MinMultiplierCannotBeBelow80    ; load B with memory contents (data is 00)
           bra   Adaptive_SetCellToMaxOrMinValue    ; branch

Adaptive_Overflowed:
           cba                 ; compare A to B
           bge   Adaptive_SetCellToMaxOrMinValue    ; branch if greater or equal
           ldab  AMLIML_MinMultiplierCannotBeBelow80    ; load B with memory contents (data is 00)
           cba                 ; compare A to B
           bge   LA919         ; branch if greater or equal
Adaptive_SetCellToMaxOrMinValue:
           tba                 ; A = B
   LA919:  staa  0x00, X      ;  -00000000-
DontUpdateCellOrTimer:
           cli                 ; enable interrupts
           ldaa  0x00, X      ; load A with memory at index + value -00000000-
           staa  ValueFromAdaptiveMemory    ; store A into memory
           rts                 ; return from subroutine

DontUpdateCell_MaybeUpdateTimer:
           ldaa  0x00, X      ; load A with memory at index + value -00000000-
           staa  ValueFromAdaptiveMemory    ; store A into memory
           ldaa  AdaptiveCellUpdateTimer_IncrementedEveryCamRisingEdge    ; load A with memory contents
           cba                 ; compare A to B
           bcs   LA92C         ; branch if lower
           stab  AdaptiveCellUpdateTimer_IncrementedEveryCamRisingEdge    ; store B into memory
   LA92C:  rts                 ; return from subroutine

AdaptiveMemory_DetermineWhichCellApplies_MM:
           clra                ; A = 0
           staa  Temp0         ; store A into memory
           ldx   #MP1_AutoCalMapCellBoundary1    ; load index with value
           ldab  PointerIntoAdaptiveMemory    ; load B with memory contents
           brset *BitFlags66, #b66_OffIdle, ONTHROTTLE_OR_RPMTOOHIGHFORIDLE    ; branch if bit(s) set
           ldaa  TargetIdleSpeedHB    ; load A with memory contents
           adda  IDLOFS_DeltaForIdleRPMForClosedThrottleCell    ;  (data is 04)
           cmpb  #0x0c         ;  -00001100-
           bcs   LA945         ; branch if lower
           adda  HYTRPM_HysteresisFor_IDLOFS    ;  (data is 02)
   LA945:  cmpa  EngineRpm_HB    ; compare A with memory contents
           bcs   ONTHROTTLE_OR_RPMTOOHIGHFORIDLE    ; branch if lower
           ldab  #0x0c         ; load B with value -00001100-
           brset *BitFlags_AIS, #$%00001000, LA97C    ; branch if bit(s) set
           incb                ; increment B
           bra   LA97C         ; branch

   LA952:  ldaa  0x00, X      ; load A with memory at index + value -00000000-
           cmpb  Temp0     
           bcc   LA95B         ; branch if greater or equal
           adda  DLTMAP_MapHysteresisAtMapCellBoundaries    ;  (data is 02)
   LA95B:  cmpa  MapValue      ; compare A with memory contents
           bcc   LA96B         ; branch if greater or equal
           inX                 ; increment index (I=I+1)
ONTHROTTLE_OR_RPMTOOHIGHFORIDLE:
           ldaa  Temp0         ; load A with memory contents
           adda  #0x02         ;  -00000010-
           staa  Temp0         ; store A into memory
           cpx   #MP5_AutoCalMapCellBoundary5    ;  -10000000 01001010-
           bls   LA952         ; branch if lower or same
   LA96B:  ldaa  R1_RPMCellBoundaryInRPMover32    ; load A with memory contents (data is 3a)
           lsrb                ; logical shift right B
           bcs   LA974         ; branch if lower
           adda  DLTRPM_DeltaRPMAtRPMBoundariesInRPMOver32    ;  (data is 02)
   LA974:  ldab  Temp0         ; load B with memory contents
           cmpa  EngineRpm_HB    ; compare A with memory contents
           bcs   LA97B         ; branch if lower
           decb                ; decrement B
   LA97B:  decb                ; decrement B
   LA97C:  cmpb  PointerIntoAdaptiveMemory
           beq   LA9A2         ; branch if equal (zero)
           clra                ; A = 0
           staa  AdaptiveCellUpdateTimer_IncrementedEveryCamRisingEdge    ; store A into memory
           staa  CylTrim_Adaptive_Var1    ; store A into memory
           ldaa  #0x80         ; load a with value -10000000-
           cmpb  CL2PTR_Cyl2AdaptiveMemoryPointer    ; compare B with memory contents (data is 0c)
           beq   LA99E         ; branch if equal (zero)
           lsra                ; logic shift right A
           cmpb  CL1PTR_Cyl1AdaptiveMemoryPointer    ; compare B with memory contents (data is 02)
           beq   LA99E         ; branch if equal (zero)
           lsra                ; logic shift right A
           cmpb  CL3PTR_Cyl3AdaptiveMemoryPointer    ; compare B with memory contents (data is 04)
           beq   LA99E         ; branch if equal (zero)
           lsra                ; logic shift right A
           cmpb  CL4PTR_Cyl4AdaptiveMemoryPointer    ; compare B with memory contents (data is 05)
           bne   LA9A2         ; branch if not equal (not zero)
   LA99E:  eora  CylTrim_FlagsEF
           staa  CylTrim_FlagsEF    ; store A into memory
   LA9A2:  stab  PointerIntoAdaptiveMemory    ; store B into memory
           rts                 ; return from subroutine

HandleAmTimer_MM:
           brclr *BitFlags6F, #b6f_FuelEngineNotRunning, AMTimer_EngineRunning    ; branch if bit(s) clear
           ldaa  CoolantTemp    ; load A with memory contents
           ldx   #AMTPSW_TempPointToEnableSelectedAMTimer    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop    ; store A into memory
           ldaa  CoolantTemp    ; load A with memory contents
           ldx   #CLTIME_ClosedLoopTimeFromEngTempAtStartup_FromTemp    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  Timer_CLTIME_ClosedLoopTimer    ; store A into memory
           bclr  *BitFlags66, #b66_OpenLoop    ; clear bits
AMTimer_EngineRunning:
           ldaa  CoolantTemp    ; load A with memory contents
           ldab  Counter_MainLoop    ; load B with memory contents
           bne   LA9DF         ; branch if not equal (not zero)
           cmpa  AMTEMP_StartTempToSelectHotOrColdAMTimer    ; compare A with memory contents (data is cd)
           bcs   LA9D3         ; branch if lower
           ldab  Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop    ; load B with memory contents
           beq   LA9DF         ; branch if equal (zero)
           decb                ; decrement B
           stab  Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop    ; store B into memory
           rts                 ; return from subroutine

   LA9D3:  bne   LA9DF         ; branch if not equal (not zero)
           ldaa  CoolantTemp    ; load A with memory contents
           ldx   #AMTPSW_TempPointToEnableSelectedAMTimer    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop    ; store A into memory
   LA9DF:  rts                 ; return from subroutine


;	.org	0xa9e0
DRBFunctionTable:
	.word	OutputErrorCodes
	.word	OutputErrorBits
	.word	SetupHiSpeedDataTransfer
	.word	SetupATM
	.word	SendDiagnosticDataToSCI
	.word	SendECUIDToSCI
	.word	SendConstValues
	.word	ClearErrorCodes
	.word	DRB_Return
	.word	DRB_Return
	.word	SwitchTest
	.word	InitByteModeDownload
	.word	DRB_ResetEMR
	.word	DRB_UseRAMForSpecialProgramRoutine
	.word	DRB_UseRAM2ForSpecialProgramRoutine
	.word	DRB_CheckSpecialProgramSize
	.word	DRB_SpecialProgramMode
	.word	DRB_Special1
	.word	DRB_Special2
	.word	DRB_ClearAdaptiveMemory
	.word	DRB_Return
	.word	LAEBC

;	.org	0xaa0c
DRBSerialToggles:
	.word	0x2020
	.word	0x3020
	.word	0x0020
	.word	0x2020
	.word	0x0030
	.word	0x3030
	.word	0x3030
	.word	0x2020
	.word	0x2020
	.byte   0x30

;	.org	0xaa1d
ATMFunctionTable:
	.word	ATM_IgnitionCoil1
	.word	ATM_SerialOut
	.word	ATM_SerialOut
	.word	ATM_InjBank1
	.word	ATM_InjBank2
	.word	ATM_InjBank3
	.word	ATM_AISMotorOpenClose
	.word	ATM_FanRelay
	.word	ATM_ACClutchRelay
	.word	ATM_ASDRelay
	.word	ATM_PurgeSolenoid
	.word	ATM_SCServoSolenoid
	.word	LB06F
	.word	ATM_Tachometer
	.word	ATM_PTUIndicator
	.word	LAFE0
	.word	ATM_WGSolenoid
	.word	ATM_BaroReadSolenoid
	.word	ATM_SerialOut
	.word	ATM_AllSolenoidsRelays
	.word	ATM_SerialOut
	.word	ATM_SerialOut
	.word	ATM_PTUIndicator
	.word	ATM_SerialOut
	.word	LAFCF
	.word	ATM_SerialOut
	.word	ATM_SerialOut
	.word	LAFCB
	.word	ATM_InjBank4
	.word	ATM_SerialOut
	.word	ATM_SerialOut
	.word	ATM_SerialOut
	.word	ATM_SerialOut

;	.org	0xaa5f
DRBMemoryTable:
	.word	Temp0
	.word	O2SensorVolts
	.word	Temp0
	.word	Temp0
	.word	CoolantTemp
	.word	LastCoolantTempVolts
	.word	LastTpsVolts
	.word	MINTHR_LowestSessionTPS
	.word	KnockVolts
	.word	BatteryVolts
	.word	MapValue
	.word	DesiredNewAisPosition
	.word	Temp0
	.word	ValueFromAdaptiveMemory
	.word	BaroPressure
	.word	EngineRpm_HB
	.word	EngineRpm_HB
	.word	Temp0
	.word	ErrorCodeUpdateKeyOnCount
	.word	Temp0
	.word	CalculatedSparkAdvance
	.word	Cylinder1Retard
	.word	Cylinder2Retard
	.word	Cylinder3Retard
	.word	Cylinder4Retard
	.word	BoostTarget
	.word	ChargeTempVolts
	.word	LastChargeTempVolts
	.word	CruiseSpeedSetpoint
	.word	ErrorCodeUpdateKeyOnCount2
	.word	ErrorCodeUpdateKeyOnCount3
	.word	Counter_Cruise_1
	.word	Temp0
	.word	Temp0
	.word	CCDBatteryVoltsOutput
	.word	TargetBatteryVolts
        .word   Temp0
        .word   Temp0
        .word   CCDFlags5
        .word   CurrentWastegatePosition
        .word   PointlessFuelFactor
        .word   Temp0
        .word   Temp0
        .word   CruiseControlSwitchStateAnalogSnapshot
        .word   AmbientAirTempVolts
        .word   FuelCompFactor_X

DRBTable:
	.word	0x0102
	.word	0x0000
	.word	0x0000
	.word	0x0000
	.word	0x0000
	.word	0x0000
	.byte   0x00

SwitchTestTable:
        .word   SendSwitchStateToSerial
	.word	SendOutputStatusToSerial
	.word	SendOutputStatusToSerial2

;	.org	0xaad0
RealTimeDataTable:
	.word	SCI_MAPVolts
	.word	SCI_Speed
	.word	SCI_O2Volts
	.word	EndRealTimeData
	.word	LA597
	.word	SendBaro
	.word	SendTPS
	.word	LACAA
	
DRBIISerialCommunications_MM:
           jsr   NULL_ROUTINE    ; call subroutine
           jsr   BYTE_MODE_SERIAL_CODE_DOWNLOAD_ROUTINE    ; call subroutine
           ldab  DRBSerialMode    ; load B with memory contents
           bitb  #0xc0         ;  -11000000-
           bne   LAB5E         ; branch if not equal (not zero)
           ldaa  CPU_SerialBaudRate    ; load A with memory contents
           anda  #0x37         ; AND a with value -00110111-
           cmpa  #0x22         ; compare a with value -00100010-
           beq   LAAFB         ; branch if equal (zero)
           ldaa  #0x22         ; load a with value -00100010-
           staa  CPU_SerialBaudRate
           rts                 ; return from subroutine

   LAAFB:  ldaa  CPU_SerialStatus    ; load A with memory contents
           bita  #0x0e         ;  -00001110-
           beq   LAB06         ; branch if equal (zero)
           ldaa  CPU_SerialData    ; load A with memory contents
           rts                 ; return from subroutine

   LAB06:  bita  #0x20         ;  -00100000-
           bne   LAB1D         ; branch if not equal (not zero)
           brset *DRBSerialMode, #$%00001111, LAB12    ; branch if bit(s) set
           incb                ; increment B
           stab  DRBSerialMode    ; store B into memory
           rts                 ; return from subroutine

   LAB12:  brclr *DRBSerialMode, #$%00110000, LAB5E    ; branch if bit(s) clear
           bclr  *DRBSerialMode, #$%00110000    ; clear bits
           clr   DRBPointer1    ; zero byte at memory location
           rts                 ; return from subroutine

   LAB1D:  ldaa  CPU_SerialData    ; load A with memory contents
           staa  CPU_SerialData
           andb  #0xf0         ;  -11110000-
           stab  DRBSerialMode    ; store B into memory
           bitb  #0x30         ;  -00110000-
           bne   LAB4D         ; branch if not equal (not zero)
           cmpa  #0x14         ; compare a with value -00010100-
           beq   LAB32         ; branch if equal (zero)
           bclr  *BitFlags6C, #$%00010000    ; clear bits
   LAB32:  staa  DRBPointer1    ; store A into memory
           clrb                ; b = 0
           stab  DRBPointer2    ; store B into memory
           stab  DRBPointer3    ; store B into memory
           cmpa  #0x25         ; compare a with value -00100101-
           bhi   LAB5E         ; branch if higher
           suba  #0x13         ;  -00010011-
           bcs   LAB5E         ; branch if lower
           tab                 ; B = A
           ldx   #DRBSerialToggles    ; load index with value
           abx                 ; add B to index
           ldab  0x00, X      ; load B with memory at index + value -00000000-
           orab  DRBSerialMode
           stab  DRBSerialMode    ; store B into memory
           rts                 ; return from subroutine

   LAB4D:  bitb  #0x20         ;  -00100000-
           beq   LAB58         ; branch if equal (zero)
           staa  DRBPointer2    ; store A into memory
           andb  #0xdf         ;  -11011111-
           stab  DRBSerialMode    ; store B into memory
           rts                 ; return from subroutine

   LAB58:  staa  DRBPointer3    ; store A into memory
           andb  #0xcf         ;  -11001111-
           stab  DRBSerialMode    ; store B into memory
   LAB5E:  rts                 ; return from subroutine

DRBIIOuput_MM:
           ldaa  DRBSerialMode    ; load A with memory contents
           bita  #0x30         ;  -00110000-
           bne   LAB5E         ; branch if not equal (not zero)
           ldab  DRBPointer1    ; load B with memory contents
           subb  #0x10         ;  -00010000-
           bcs   LAB5E         ; branch if lower
           cmpb  #0x15         ;  -00010101-
           bhi   LAB5E         ; branch if higher
           lslb                ; arithmetic shift left B
           ldx   #DRBFunctionTable    ; load index with value
           abx                 ; add B to index
           ldx   0x00, X      ;  -00000000-
           jmp   0x00, X       ; indexed jump

OutputErrorCodes:
           ldx   #ErrorBitRegister0    ; load index with value
           ldab  DRBPointer2    ; load B with memory contents
           cmpb  #0x07         ;  -00000111-
           bhi   LAB8E         ; branch if higher
           negb                ; 2's complement B
           addb  #0x07         ;  -00000111-
           abx                 ; add B to index
           inc   DRBPointer2
           ldaa  0x00, X      ; load A with memory at index + value -00000000-
           beq   LAB8F         ; branch if equal (zero)
           bra   LABB1         ; branch

   LAB8E:  deX                 ; decrement index (I=I-1)
   LAB8F:  clr   DRBPointer1    ; zero byte at memory location
           ldaa  #0xfe         ; load a with value -11111110-
           jsr   SerialOutput1a    ; call subroutine
           adda  #0x10         ;  -00010000-
   LAB99:  inX                 ; increment index (I=I+1)
           cpx   #ErrorCodeUpdateKeyOnCount    ;  -00000000 00100101-
           bcc   LABB1         ; branch if greater or equal
           adda  0x00, X      ;  -00000000-
           bra   LAB99         ; branch

OutputErrorBits:
           ldaa  ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB    ; load A with memory contents
           brclr *DRBPointer2, #$%11111111, LABAE    ; branch if bit(s) clear
           ldaa  ErrorBitsAssociatedWithPIA1AndReg1eTo25_LB    ; load A with memory contents
           clr   DRBPointer1    ; zero byte at memory location
   LABAE:  inc   DRBPointer2
   LABB1:  jmp   SerialOutput1a

SetupHiSpeedDataTransfer:
           bset  *DRBSerialMode, #$%10000000    ; set bits
           clr   DRBPointer1    ; zero byte at memory location
   LABBA:  ldaa  CPU_SerialStatus    ; load A with memory contents
           bita  #0x40         ;  -01000000-
           beq   LABBA         ; branch if equal (zero)
           ldaa  #0x01         ; load a with value -00000001-
           staa  CPU_SerialBaudRate
DRB_Return:
           rts                 ; return from subroutine

SetupATM:
           clra                ; A = 0
           staa  DRBPointer1    ; store A into memory
           ldab  TimerOverflowsBetweenDistPulses    ; load B with memory contents
           cmpb  #0x50         ;  -01010000-
           bls   LABE0         ; branch if lower or same
           brset *BitFlags72, #b72_O2Enable, LABE0    ; branch if bit(s) set
           ldaa  DRBPointer2    ; load A with memory contents
           cmpa  #0x21         ; compare a with value -00100001-
           bhi   LABE0         ; branch if higher
           ldab  #0x02         ; load B with value -00000010-
           stab  KeyOnOrEngineRunningTime    ; store B into memory
           bra   LABE4         ; branch

   LABE0:  bclr  *BitFlags72, #b72_O2Enable    ; clear bits
           clra                ; A = 0
   LABE4:  staa  ATMOffset     ; store A into memory
           tab                 ; B = A
           lslb                ; arithmetic shift left B
           beq   ATM_SerialOut    ; branch if equal (zero)
           ldx   #ATMFunctionTable-2    ; load index with value
           abx                 ; add B to index
           ldx   0x00, X      ;  -00000000-
           cpx   #ATM_SerialOut    ;  -10101011 11110101-
           bne   LABB1         ; branch if not equal (not zero)
ATM_SerialOut:
           clra                ; A = 0
           staa  ATMOffset     ; store A into memory
           jmp   SerialOutput1

SendDiagnosticDataToSCI:
           clrb                ; b = 0
           stab  Temp0         ; store B into memory
           stab  DRBPointer1    ; store B into memory
           ldab  DRBPointer2    ; load B with memory contents
           beq   LA597         ; branch if equal (zero)
           cmpb  #0x40         ;  -01000000-
           bcc   LAC35         ; branch if greater or equal
           cmpb  #0x2e         ;  -00101110-
           bhi   LA597         ; branch if higher
           cmpb  #0x10         ;  -00010000-
           bne   SendRealTImeDatatoSCI    ; branch if not equal (not zero)
           brset *BitFlags66, #b66_OffIdle, LA597    ; branch if bit(s) set
           brset *BitFlags_AIS, #$%00001000, LA597    ; branch if bit(s) set
           bset  *BitFlags6C, #$%00010000    ; set bits
           bra   SendRealTImeDatatoSCI    ; branch

   LA597:  bclr  *BitFlags6C, #$%00010000    ; clear bits
           clra                ; A = 0
           staa  DRBPointer1    ; store A into memory
           rts                 ; return from subroutine

SendRealTImeDatatoSCI:
           ldx   #DRBMemoryTable-2    ; load index with value
           lslb                ; arithmetic shift left B
           abx                 ; add B to index
           ldx   0x00, X      ;  -00000000-
           cpx   #Temp0        ;  -00000000 11110111-
           beq   LA597         ; branch if equal (zero)
           ldaa  0x00, X      ; load A with memory at index + value -00000000-
           jmp   SerialOutput1a

   LAC35:  subb  #0x40         ;  -01000000-
           cmpb  #0x07         ;  -00000111-
           bhi   LA597         ; branch if higher
           ldx   #RealTimeDataTable    ; load index with value
           lslb                ; arithmetic shift left B
           abx                 ; add B to index
           ldx   0x00, X      ;  -00000000-
           jmp   0x00, X       ; indexed jump

   SCI_MAPVolts:  sei                 ; disable interrupts
           ldaa  #0x10         ; load a with value -00010000-
           staa  CPU_A2DControlReg
           ldaa  #0x07         ; load a with value -00000111-
   LAC4C:  deca                ; decrement A
           bne   LAC4C         ; branch if not equal (not zero)
           ldaa  CPU_A2DResults1    ; load A with memory contents
           cli                 ; enable interrupts
           bra   LAC5E         ; branch

SCI_Speed:
           ldd   VehicleSpeed_HB    ; load D (A&B) with memory contents
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           bcc   LAC5E         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   LAC5E:  jmp   SerialOutput1a

SCI_O2Volts:
           ldab  O2SensorVolts    ; load B with memory contents
           ldaa  #0xff         ; load a with value -11111111-
           cmpb  O2HIGH_HighLimitForImmediateSwitchToClosedLoop    ; compare B with memory contents (data is 26)
           bhi   LAC71         ; branch if higher
           cmpb  O2LOW_LowLimitForImmediateSwitchToClosedLoop    ; compare B with memory contents (data is 0f)
           bhi   LAC5E         ; branch if higher
           anda  #0xa0         ; AND a with value -10100000-
   LAC71:  anda  #0xb1         ; AND a with value -10110001-
           bra   LAC5E         ; branch

EndRealTimeData:
           clra                ; A = 0
           brset *BitFlags66, #b66_OffIdle, LAC8B    ; branch if bit(s) set
           brset *BitFlags6F, #b6f_FuelEngineNotRunning, LAC8B    ; branch if bit(s) set
           staa  Timer_BaroReadInterval    ; store A into memory
           bclr  *BitFlags68, #b68_BaroSolEnergized    ; clear bits
           bset  *BitFlags68, #b68_SparkEngineNotRunning    ; set bits
           bclr  *StartupSwitchMirror2, #$%00010000    ; clear bits
           ldaa  #0xe3         ; load a with value -11100011-
   LAC8B:  jmp   SerialOutput1a

SendBaro:
           ldaa  BaroPressure    ; load A with memory contents
           suba  MapValue  
           jmp   SerialOutput1a

SendTPS:
           ldaa  TPSVolts      ; load A with memory contents
           suba  MINTHR_LowestSessionTPS
           bcc   LAC9C         ; branch if greater or equal
           clra                ; A = 0
   LAC9C:  ldab  #0xfd         ; load B with value -11111101-
           staa  Temp0         ; store A into memory
           mul                 ; multiply (D=A*B)
           adca  Temp0     
           bcc   LACA7         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   LACA7:  jmp   SerialOutput1a

   LACAA:  ldaa  AdvanceTemp    ; load A with memory contents
           adda  #0x0c         ;  -00001100-
           bvc   LACB3         ; branch if overflow
           ldaa  #0x7f         ; load a with value -01111111-
   LACB3:  jmp   SerialOutput1a

SendECUIDToSCI:
           clra                ; A = 0
           staa  DRBPointer1    ; store A into memory
           ldab  DRBPointer3    ; load B with memory contents
           ldaa  DRBPointer2    ; load A with memory contents
           xgdx                ; exchange D and index
           ldaa  0x00, X      ; load A with memory at index + value -00000000-
           jmp   SerialOutput1a

SendConstValues:
           ldaa  DRBPointer2    ; load A with memory contents
           cmpa  #0x80         ; compare a with value -10000000-
           bne   LACE1         ; branch if not equal (not zero)
           ldaa  CPU_EEPROMControlReg    ; load A with memory contents
           bita  #0x02         ;  -00000010-
           bne   LACF4         ; branch if not equal (not zero)
           ldy   #LAD33        ; load index with value
           ldaa  LB7EF         ; load A with memory contents (data is ff)
           cmpa  #0x55         ; compare a with value -01010101-
           bne   LACF5         ; branch if not equal (not zero)
           ldy   #LAD3B       ; load index with value
           bra   LACF5         ; branch

   LACE1:  ldy   #LAD43       ; load index with value
           cmpa  #0x81         ; compare a with value -10000001-
           beq   LACF5         ; branch if equal (zero)
           ldy   #LAD4B       ; load index with value
           cmpa  #0x82         ; compare a with value -10000010-
           beq   LACF5         ; branch if equal (zero)
           clr   DRBPointer1    ; zero byte at memory location
   LACF4:  rts                 ; return from subroutine

   LACF5:  ldab  DRBPointer3    ; load B with memory contents
           lslb                ; arithmetic shift left B
           aby                 ; add B to index
           ldx   0x00, Y      ;  -00000000-
           ldaa  0x00, X      ; load A with memory at index + value -00000000-
           inc   DRBPointer3
           brclr *DRBPointer3, #$%00000011, LAD09    ; branch if bit(s) clear
           jmp   SerialOutput1a

   LAD09:  jsr   SerialOutput1a    ; call subroutine
           adda  #0x16         ;  -00010110-
           deY                 ; decrement index (I=I-1)
           deY                 ; decrement index (I=I-1)
           ldx   0x00, Y      ;  -00000000-
           adda  0x00, X      ;  -00000000-
           deY                 ; decrement index (I=I-1)
           deY                 ; decrement index (I=I-1)
           ldx   0x00, Y      ;  -00000000-
           adda  0x00, X      ;  -00000000-
           deY                 ; decrement index (I=I-1)
           deY                 ; decrement index (I=I-1)
           ldx   0x00, Y      ;  -00000000-
           adda  0x00, X      ;  -00000000-
           ldab  DRBPointer2    ; load B with memory contents
           aba                 ; A=A+B
           clr   DRBPointer1    ; zero byte at memory location
           jmp   SerialOutput1a


;	.org	0xad32
LAD32:
	.byte	0x00
LAD33:
        .word   ENDIT1_PNPrefix
	.word	0x8003
	.word	ENDITM_ECUID
	.word	0x8005
LAD3B:
	.word	RFINO3_
	.word	RFINO2_
	.word	RFINO1
	.word	RFINO0_
LAD43:
	.word	CODE13_
	.word	CODE12_
	.word	MDLCDE_ModelTypeCode
	.word	0x8010
LAD4B:
	.word	PARTREV_RevisionLevel
	.word	0xAD32
	.word	0xAD32
	.word	0xAD32

   LAD53:  clra                ; A = 0
           staa  DRBPointer1    ; store A into memory
SerialOutput1:
           clra                ; A = 0
SerialOutput1a:
           ldab  CPU_SerialStatus    ; load B with memory contents
           bpl   SerialOutput1a    ; branch if plus (hi bit 0)
           staa  CPU_SerialData
           rts                 ; return from subroutine

ClearErrorCodes:
           clr   DRBPointer1    ; zero byte at memory location
           ldab  TimerOverflowsBetweenDistPulses    ; load B with memory contents
           cmpb  #0x50         ;  -01010000-
           bhi   LAD6C         ; branch if higher
           jmp   SerialOutput1

   LAD6C:  ldaa  BitFlags65    ; load A with memory contents
           inca                ; increment A
           cmpa  #0x18         ; compare a with value -00011000-
           bls   LAD84         ; branch if lower or same
           ldaa  CPU_EEPROMControlReg    ; load A with memory contents
           bita  #0x01         ;  -00000001-
           bne   LAD86         ; branch if not equal (not zero)
           jsr   EraseErrorCodes    ; call subroutine
           clra                ; A = 0
           staa  BitFlags65    ; store A into memory
           ldaa  #0xe0         ; load a with value -11100000-
           bra   SerialOutput1a    ; branch

   LAD84:  staa  BitFlags65    ; store A into memory
   LAD86:  ldaa  #0xff         ; load a with value -11111111-
           bra   SerialOutput1a    ; branch

SwitchTest:
           clr   DRBPointer1    ; zero byte at memory location
           ldab  DRBPointer2    ; load B with memory contents
           beq   LADB0         ; branch if equal (zero)
           cmpb  #0x03         ;  -00000011-
           bhi   LADB0         ; branch if higher
           ldx   #SwitchTestTable-2       ; load index with value
           lslb                ; arithmetic shift left B
           abx                 ; add B to index
           ldx   0x00, X      ;  -00000000-
           jmp   0x00, X       ; indexed jump

SendSwitchStateToSerial:
           ldaa  StartupSwitchMirror1    ; load A with memory contents
           bra   SerialOutput1a    ; branch

SendOutputStatusToSerial:  
           ldaa  PIA2_Buffer    ; load A with memory contents
           bra   SerialOutput1a    ; branch

SendOutputStatusToSerial2:
           ldaa  StartupSwitchMirror2    ; load A with memory contents
           bra   SerialOutput1a    ; branch

InitByteModeDownload:
           bset  *DRBSerialMode, #$%01000000    ; set bits
           clr   DRBPointer1    ; zero byte at memory location
   LADB0:  rts                 ; return from subroutine

DRB_ResetEMR:
           clra                ; A = 0
           staa  DRBPointer1    ; store A into memory
           sei                 ; disable interrupts
           ldab  BitFlags70    ; load B with memory contents
           bitb  #0x03         ;  -00000011-
           bne   LADC9         ; branch if not equal (not zero)
           bset  *BitFlags70, #$%00000001    ; set bits
           cli                 ; enable interrupts
           ldaa  DRBPointer3    ; load A with memory contents
           staa  DRBOffsetStored_LB    ; store A into memory
           ldab  DRBPointer2    ; load B with memory contents
           stab  DRBOffsetStored_HB    ; store B into memory
           ldaa  #0xe2         ; load a with value -11100010-
   LADC9:  cli                 ; enable interrupts
           jmp   SerialOutput1a

DRB_UseRAMForSpecialProgramRoutine:
           ldx   #0x0000        ; load index with value
           bra   LADF1         ; branch

DRB_UseRAM2ForSpecialProgramRoutine:
           ldx   #ErrorCodeCounter    ; load index with value
           bra   LADF1         ; branch

DRB_CheckSpecialProgramSize:  
           ldaa  DRBPointer2    ; load A with memory contents
           bne   LADEE          ; branch if not equal (not zero)
           ldx   #DRB_ProgramModeFlag    ; load index with value
           ldab  DRBPointer3    ; load B with memory contents
           abx                 ; add B to index
           cpx   #ErrorCodeCounter    ;  -01100100 10000000-
           bcs   LADEE                ; branch if lower
           ldaa  #0xff         ; load a with value -11111111-
           staa  DRB_ProgramModeFlag
   LADEB:  jmp   LAD53     

   LADEE:  ldx   #DRB_ProgramModeFlag    ; load index with value
   LADF1:  clra                ; A = 0
           staa  DRBPointer1    ; store A into memory
           ldab  DRBPointer2    ; load B with memory contents
           ldaa  DRBPointer3    ; load A with memory contents
           abx                 ; add B to index
           staa  0x00, X      ;  -00000000-
           ldaa  #0xe5         ; load a with value -11100101-
           jmp   SerialOutput1a

   DRB_SpecialProgramMode:  ldx   #DRB_ProgramModeFlag    ; load index with value
           ldab  DRBPointer3    ; load B with memory contents
           cmpb  0x01, X      ;  -00000001-
           beq   LAE0E         ; branch if equal (zero)
           comb                ; 1's complement B
           cmpb  0x01, X      ;  -00000001-
           bne   DRB_OutputSpecialCodes    ; branch if not equal (not zero)
   LAE0E:  ldab  DRBPointer2    ; load B with memory contents
           cmpb  0x00, X      ;  -00000000-
           bne   LAE3E         ; branch if not equal (not zero)
           abx                 ; add B to index
           ldaa  0x01, X      ; load A with memory at index + value -00000001-
           cmpa  #0x39         ; compare a with value -00111001-
           bne   LADEB         ; branch if not equal (not zero)
           ldx   #DRB_ProgramModeFlag    ; load index with value
           clra                ; A = 0
   LAE1F:  inX                 ; increment index (I=I+1)
           adda  0x01, X      ;  -00000001-
           decb                ; decrement B
           bne   LAE1F         ; branch if not equal (not zero)
           cmpa  DRBPointer3    ; compare A with memory contents
           beq   LAE32         ; branch if equal (zero)
           ldab  DRBPointer3    ; load B with memory contents
           comb                ; 1's complement B
           cba                 ; compare A to B
           bne   DRB_OutputSpecialCodes    ; branch if not equal (not zero)
           jmp   DRB_SpecialProgramRoutine

   LAE32:  com   DRBPointer3
           ldaa  #0xe4         ; load a with value -11100100-
           jmp   SerialOutput1a

DRB_OutputSpecialCodes:
           ldaa  #0x01         ; load a with value -00000001-
           bra   LAE44         ; branch

   LAE3E:  ldaa  #0x02         ; load a with value -00000010-
           bra   LAE44         ; branch

   LAE42:  ldaa  #0x03         ; load a with value -00000011-
   LAE44:  clrb                ; b = 0
           stab  DRBPointer1    ; store B into memory
           jmp   SerialOutput1a

DRB_Special1:
           clr   DRBPointer1    ; zero byte at memory location
           ldaa  DRBPointer2    ; load A with memory contents
           bne   LAE58         ; branch if not equal (not zero)
           clra                ; A = 0
   LAE52:  bclr  *BitFlags6C, #$%00100000    ; clear bits
           jmp   SerialOutput1a

   LAE58:  ldaa  #0x02         ; load a with value -00000010-
           brset *BitFlags66, #b66_OffIdle, LAE52    ; branch if bit(s) set
           ldaa  #0x03         ; load a with value -00000011-
           brset *BitFlags_AIS, #$%00001000, LAE52    ; branch if bit(s) set
           bset  *BitFlags6C, #$%00100000    ; set bits
           ldaa  #0x01         ; load a with value -00000001-
           jmp   SerialOutput1a

DRB_Special2:
           ldaa  DRBPointer3    ; load A with memory contents
           beq   LAE91         ; branch if equal (zero)
           ldaa  DRBPointer2    ; load A with memory contents
           cmpa  #0x01         ; compare a with value -00000001-
           beq   LAE89         ; branch if equal (zero)
           cmpa  #0x02         ; compare a with value -00000010-
           beq   LAE8D         ; branch if equal (zero)
           cmpa  #0x03         ; compare a with value -00000011-
           bne   LAE95         ; branch if not equal (not zero)
           ldd   TargetIdleSpeedHB    ; load D (A&B) with memory contents
   LAE80:  stab  Temp0         ; store B into memory
           jsr   SerialOutput1a    ; call subroutine
           ldaa  Temp0         ; load A with memory contents
           bra   LAE44         ; branch

   LAE89:  ldd   EngineRpm_HB    ; load D (A&B) with memory contents
           bra   LAE80         ; branch

   LAE8D:  ldd   InjectorPulsewidth_HB    ; load D (A&B) with memory contents
           bra   LAE80         ; branch

   LAE91:  coma                ; 1's complement A
           staa  DRBPointer3    ; store A into memory
           rts                 ; return from subroutine

   LAE95:  clra                ; A = 0
           staa  DRBPointer1    ; store A into memory
           rts                 ; return from subroutine

DRB_ClearAdaptiveMemory:
           clra                ; A = 0
           staa  DRBPointer1    ; store A into memory
           ldaa  TimerOverflowsBetweenDistPulses    ; load A with memory contents
           cmpa  #0x50         ; compare a with value -01010000-
           bhi   LAEA5         ; branch if higher
           jmp   SerialOutput1

   LAEA5:  ldaa  DRBPointer2    ; load A with memory contents
           cmpa  #0x01         ; compare a with value -00000001-
           beq   LAF1C         ; branch if equal (zero)
           cmpa  #0x02         ; compare a with value -00000010-
           beq   EraseAdaptiveMemoryValues    ; branch if equal (zero)
           cmpa  #0x03         ; compare a with value -00000011-
           beq   LAEED         ; branch if equal (zero)
           cmpa  #0x04         ; compare a with value -00000100-
           beq   LAEE6         ; branch if equal (zero)
           ldaa  #0x01         ; load a with value -00000001-
           jmp   SerialOutput1a

   LAEBC:  ldab  DRBPointer2    ; load B with memory contents
           beq   LAEDD         ; branch if equal (zero)
           cmpb  #0x0d         ;  -00001101-
           bls   LAEC9         ; branch if lower or same
           ldaa  #0xff         ; load a with value -11111111-
           jmp   SerialOutput1a

   LAEC9:  brclr *DRBPointer3, #$%11111111, LAEDD    ; branch if bit(s) clear
           ldx   #DRBTable    ; load index with value
           abx                 ; add B to index
           deX                 ; decrement index (I=I-1)
           tba                 ; A = B
           ldab  DRBPointer3    ; load B with memory contents
           std   L64D4     
           ldaa  #0x01         ; load a with value -00000001-
           jmp   SerialOutput1a

   LAEDD:  ldd   #0x0000        ; load D (A&B) with value -00000000 00000000-
           std   L64D4     
           jmp   SerialOutput1a

   LAEE6:  ldaa  MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load A with memory contents (data is 5c)
           staa  MINTHR_LowestSessionTPS    ; store A into memory
           bra   LAF25         ; branch

   LAEED:  sei                 ; disable interrupts
           bset  *BitFlags_AIS, #$%00100000    ; set bits
           ldaa  #0xdf         ; load a with value -11011111-
           staa  CurrentAisPosition    ; store A into memory
           cli                 ; enable interrupts
           bra   LAF25         ; branch

EraseAdaptiveMemoryValues:
           clra                ; A = 0
           staa  ValueFromAdaptiveMemory    ; store A into memory
           staa  CylTrim_Adaptive_Var1    ; store A into memory
           staa  CylTrimFlags    ; store A into memory
           staa  CylTrim_FlagsEF    ; store A into memory
           staa  Cyl2_InjPWTrim    ; store A into memory
           staa  Cyl1_InjPWTrim    ; store A into memory
           staa  Cyl3_InjPWTrim    ; store A into memory
           staa  Cyl4_InjPWTrim    ; store A into memory
           bset  *BitFlags67, #b67_OpenLoop    ; set bits
           bset  *CylTrimFlags, #$%00100000    ; set bits
           ldx   #AutoCalCell0    ; load index with value
   LAF12:  staa  0x00, X      ;  -00000000-
           inX                 ; increment index (I=I+1)
           cpx   #ErrorBitRegister0    ;  -00000000 00011101-
           bcs   LAF12         ; branch if lower
           bra   LAF25         ; branch

   LAF1C:  ldaa  CPU_EEPROMControlReg    ; load A with memory contents
           bita  #0x01         ;  -00000001-
           bne   LAF29         ; branch if not equal (not zero)
           bsr   EraseErrorCodes    ; call subroutine
   LAF25:  ldaa  #0xf0         ; load a with value -11110000-
           bra   LAF2B         ; branch

   LAF29:  ldaa  #0x02         ; load a with value -00000010-
   LAF2B:  jmp   SerialOutput1a

EraseErrorCodes:
           clra                ; A = 0
           clrb                ; b = 0
           std   ErrorBitRegister0    ; store D (A&B) into memory
           std   ErrorBitRegister2    ; store D (A&B) into memory
           std   ErrorBitRegisterStored0    ; store D (A&B) into memory
           std   ErrorBitRegisterStored2    ; store D (A&B) into memory
           staa  b5C_IPL1      ; store A into memory
           staa  b5D_IPL2      ; store A into memory
           staa  ErrorCodeUpdateKeyOnCount    ; store A into memory
           staa  ErrorCodeUpdateKeyOnCount2    ; store A into memory
           staa  ErrorCodeUpdateKeyOnCount3    ; store A into memory
           ldaa  LB620         ; load A with memory contents (data is ff)
           inca                ; increment A
           beq   LAF79         ; branch if equal (zero)
           ldx   #0xB620        ; load index with value
           bsr   LAF5A         ; call subroutine
           ldx   #0xb630       ; load index with value
           bsr   LAF5A         ; call subroutine
           ldx   #0xb640       ; load index with value
           bsr   LAF5A         ; call subroutine
           ldx   #0xb650       ; load index with value
   LAF5A:  brset 0x00, X, #$%11111111, LAF79    ; branch if bit(s) set -00000000-
           ldaa  #0x0e         ; load a with value -00001110-
           staa  CPU_EEPROMControlReg
           stab  0x00, X      ;  -00000000-
           inca                ; increment A
           staa  CPU_EEPROMControlReg
           ldx   #0x1a0a       ; load index with value
   LAF6C:  deX                 ; decrement index (I=I-1)
           bne   LAF6C         ; branch if not equal (not zero)
           deca                ; decrement A
           staa  CPU_EEPROMControlReg
           clr   CPU_EEPROMControlReg    ; zero byte at memory location
           jmp   ResetCopTimer

   LAF79:  rts                 ; return from subroutine

ActuatorTestMode_MM:
           ldaa  ATMOffset     ; load A with memory contents
           beq   LAF87         ; branch if equal (zero)
           ldaa  KeyOnOrEngineRunningTime    ; load A with memory contents
           cmpa  #0x99         ; compare a with value -10011001-
           bcs   LAF88         ; branch if lower
           clrb                ; b = 0
           stab  ATMOffset     ; store B into memory
   LAF87:  rts                 ; return from subroutine

   LAF88:  ldaa  PIA2_Buffer    ; load A with memory contents
           ldx   #ATMFunctionTable-2    ; load index with value
           ldab  ATMOffset     ; load B with memory contents
           lslb                ; arithmetic shift left B
           abx                 ; add B to index
           ldab  StartupSwitchMirror2    ; load B with memory contents
           ldx   0x00, X      ;  -00000000-
           jmp   0x00, X       ; indexed jump

ATM_FanRelay:
           orab  #0x80         ;  -10000000-
           brset *Counter_MainLoop, #$%01110000, ATM_SetOutputBits_PIA_A    ; branch if bit(s) set
           andb  #0x7f         ;  -01111111-
           bra   ATM_SetOutputBits_PIA_A    ; branch

ATM_PTUIndicator:
           orab  #0x20         ;  -00100000-
           brset *Counter_MainLoop, #$%10000000, ATM_SetOutputBits_PIA_A    ; branch if bit(s) set
           andb  #0xdf         ;  -11011111-
           bra   ATM_SetOutputBits_PIA_A    ; branch

ATM_BaroReadSolenoid:
           orab  #0x10         ;  -00010000-
           brset *Counter_MainLoop, #$%10000000, ATM_SetOutputBits_PIA_A    ; branch if bit(s) set
           andb  #0xef         ;  -11101111-
ATM_SetOutputBits_PIA_A:
           stab  StartupSwitchMirror2    ; store B into memory
           rts                 ; return from subroutine

ATM_ASDRelay:
           ldab  CPU_TimerControlReg1    ; load B with memory contents
           andb  #0xea         ;  -11101010-
           orab  #0x2a         ;  -00101010-
           stab  CPU_TimerControlReg1    ; store B into memory
           ldab  #0x08         ; load B with value -00001000-
           stab  CPU_HardwareTimerForceCompare    ; store B into memory
           oraa  #0x10         ;  -00010000-
           brset *Counter_MainLoop, #$%10000000, ATM_SetOutputBits_PIA_B    ; branch if bit(s) set
   LAFCB:  anda  #0xef         ; AND a with value -11101111-
           bra   ATM_SetOutputBits_PIA_B    ; branch

   LAFCF:  ldx   #CODE13_      ; load index with value
           brset 0x00, X, #$%00010000, LAFDE    ; branch if bit(s) set -00000000-
           oraa  #0x02         ;  -00000010-
           brset *Counter_MainLoop, #$%10000000, ATM_SetOutputBits_PIA_B    ; branch if bit(s) set
           anda  #0xfd         ; AND a with value -11111101-
   LAFDE:  bra   ATM_SetOutputBits_PIA_B    ; branch

   LAFE0:  ldx   #CODE13_      ; load index with value
           brset 0x00, X, #$%00010000, LAFEF    ; branch if bit(s) set -00000000-
           oraa  #0x02         ;  -00000010-
           brset *Counter_MainLoop, #$%10000000, ATM_SetOutputBits_PIA_B    ; branch if bit(s) set
           anda  #0xfd         ; AND a with value -11111101-
   LAFEF:  bra   ATM_SetOutputBits_PIA_B    ; branch

ATM_WGSolenoid:
           clrb                ; b = 0
           oraa  #0x04         ;  -00000100-
           brset *Counter_MainLoop, #$%10000000, LAFFC    ; branch if bit(s) set
           anda  #0xfb         ; AND a with value -11111011-
           ldab  #0xc8         ; load B with value -11001000-
   LAFFC:  stab  CurrentWastegatePosition    ; store B into memory
           bra   ATM_SetOutputBits_PIA_B    ; branch

ATM_ACClutchRelay:
           oraa  #0x01         ;  -00000001-
           ldab  CONFIG_ConfigurationFlags    ; load B with memory contents (data is 92)
           bitb  #0x80         ;  -10000000-
           beq   LB00C         ; branch if equal (zero)
           bclr  *StartupSwitchMirror2, #$%10000000    ; clear bits
   LB00C:  brset *Counter_MainLoop, #$%10000000, ATM_SetOutputBits_PIA_B    ; branch if bit(s) set
           anda  #0xfe         ; AND a with value -11111110-
           bra   ATM_SetOutputBits_PIA_B    ; branch

ATM_SCServoSolenoid:
           oraa  #0xc0         ;  -11000000-
           ldab  Counter_MainLoop    ; load B with memory contents
           cmpb  #0x55         ;  -01010101-
           bcs   ATM_SetOutputBits_PIA_B    ; branch if lower
           anda  #0x3f         ; AND a with value -00111111-
           cmpb  #0xaa         ;  -10101010-
           bcs   ATM_SetOutputBits_PIA_B    ; branch if lower
           oraa  #0x80         ;  -10000000-
           bra   ATM_SetOutputBits_PIA_B    ; branch

ATM_PurgeSolenoid:
           oraa  #0x20         ;  -00100000-
           brset *Counter_MainLoop, #$%10000000, ATM_SetOutputBits_PIA_B    ; branch if bit(s) set
           anda  #0xdf         ; AND a with value -11011111-
ATM_SetOutputBits_PIA_B:
           staa  PIA2_Buffer    ; store A into memory
           rts                 ; return from subroutine

ATM_AllSolenoidsRelays:
           ldaa  CPU_TimerControlReg1    ; load A with memory contents
           anda  #0xea         ; AND a with value -11101010-
           oraa  #0x2a         ;  -00101010-
           staa  CPU_TimerControlReg1
           ldaa  #0x08         ; load a with value -00001000-
           staa  CPU_HardwareTimerForceCompare
           andb  #0xcf         ;  -11001111-
           ldaa  PIA2_Buffer    ; load A with memory contents
           anda  #0x01         ; AND a with value -00000001-
           brset *Counter_MainLoop, #$%10000000, LB05C    ; branch if bit(s) set
           orab  #0x30         ;  -00110000-
           ldaa  DRBPointer1    ; load A with memory contents
           cmpa  #0x18         ; compare a with value -00011000-
           beq   LB058         ; branch if equal (zero)
           ldaa  PIA2_Buffer    ; load A with memory contents
           oraa  #0xfe         ;  -11111110-
           bra   LB05C         ; branch

   LB058:  ldaa  PIA2_Buffer    ; load A with memory contents
           oraa  #0xee         ;  -11101110-
   LB05C:  staa  PIA2_Buffer    ; store A into memory
           stab  StartupSwitchMirror2    ; store B into memory
           ldaa  #0x10         ; load a with value -00010000-
           ldab  #0xc8         ; load B with value -11001000-
           brset *Counter_MainLoop, #$%10000000, LB06B    ; branch if bit(s) set
           clrb                ; b = 0
           ldaa  #0x70         ; load a with value -01110000-
   LB06B:  staa  DesiredNewAisPosition    ; store A into memory
           stab  CurrentWastegatePosition    ; store B into memory
   LB06F:  ldx   #SwitchPortAccessReg1    ; load index with value
           sei                 ; disable interrupts
           brclr *Counter_MainLoop, #$%10000000, LB07F    ; branch if bit(s) clear
           bset  0x00, X, #$%00000100    ; set bits -00000000-
           bset  *BitFlags70, #$%00000100    ; set bits
           bra   LB085         ; branch

   LB07F:  bclr  0x00, X, #$%00000100    ; clear bits -00000000-
           bclr  *BitFlags70, #$%00000100    ; clear bits
   LB085:  bset  0x02, X, #$%00000100    ; set bits -00000010-
           ldaa  #0x08         ; load a with value -00001000-
   LB08A:  deca                ; decrement A
           bne   LB08A         ; branch if not equal (not zero)
           bclr  0x02, X, #$%00000100    ; clear bits -00000010-
           cli                 ; enable interrupts
           rts                 ; return from subroutine

ATM_Tachometer:
           ldaa  PIA1_Buffer    ; load A with memory contents
           eora  #0x02         ; XOR a with value -00000010-
           staa  PortX_Control
           staa  PIA1_Buffer    ; store A into memory
           rts                 ; return from subroutine

ATM_AISMotorOpenClose:
           ldaa  #0x10         ; load a with value -00010000-
           brset *Counter_MainLoop, #$%10000000, LB0A4    ; branch if bit(s) set
           ldaa  #0x70         ; load a with value -01110000-
   LB0A4:  staa  DesiredNewAisPosition    ; store A into memory
           rts                 ; return from subroutine

ATM_IgnitionCoil1:
           ldab  Counter_MainLoop    ; load B with memory contents
           lslb                ; arithmetic shift left B
           bne   LB0EA         ; branch if not equal (not zero)
           sei                 ; disable interrupts
           ldaa  CPU_TimerControlReg1    ; load A with memory contents
           oraa  #0x03         ;  -00000011-
           staa  CPU_TimerControlReg1
           ldab  #0x08         ; load B with value -00001000-
           stab  CPU_HardwareTimerForceCompare    ; store B into memory
           ldd   CPU_TimerCounterRegHigh
           addd  #0x0dac       ;  -00001101 10101100-
           std   CPU_Timer_OC5_DwellB
           ldaa  CPU_TimerControlReg1    ; load A with memory contents
           anda  #0x3e         ; AND a with value -00111110-
           staa  CPU_TimerControlReg1
           cli                 ; enable interrupts
           bra   LB0EA         ; branch

ATM_InjBank1:
           ldx   #InjectorPulsewidth_HB_Cyl1    ; load index with value
           bra   LB0E0         ; branch

ATM_InjBank2:
           ldx   #InjectorPulsewidth_HB_Cyl2    ; load index with value
           bra   LB0E0         ; branch

ATM_InjBank3:
           ldx   #InjectorPulsewidth_HB_Cyl3    ; load index with value
           bra   LB0E0         ; branch

ATM_InjBank4:
           ldx   #InjectorPulsewidth_HB_Cyl4    ; load index with value
   LB0E0:  ldaa  Counter_MainLoop    ; load A with memory contents
           lsla                ; logical shift left A
           bne   LB0EA         ; branch if not equal (not zero)
           ldd   #Temp3        ; load D (A&B) with value -00000000 11111010-
           std   0x00, X      ; store D into index plus offset -00000000-
   LB0EA:  bclr  *PIA2_Buffer, #$%00010000    ; clear bits
           rts                 ; return from subroutine

CaculateChecksum:
           ldx   #IDENT1_IDCode_1    ; load index with value
           ldd   #0x9200       ; load D (A&B) with value -10010010 00000000-
           std   Temp0         ; store D (A&B) into memory
           clra                ; A = 0
   LB0F7:  ldab  #0x08         ; load B with value -00001000-
           bsr   LB117         ; call subroutine
           brclr *Temp0, #$%11111111, LB10C    ; branch if bit(s) clear
           psha                ; push A onto stack
           jsr   ResetCopTimer    ; call subroutine
           ldaa  #0x12         ; load a with value -00010010-
           adda  Temp0     
           staa  Temp0         ; store A into memory
           pula                ; pull A from stack
           bra   LB0F7         ; branch

   LB10C:  cmpa  ENDITM_ECUID+1      ; compare A with memory contents (data is 50)
           beq   LB13A         ; branch if equal (zero)
           ldd   #0x0201       ; load D (A&B) with value -00000010 00000001-
           jmp   ThrowNonCriticalError

   LB117:  cpx   #0xb600        ;  -10110110 00000000-
           bne   LB125         ; branch if not equal (not zero)
           inc   Temp0     
           inc   Temp0     
           ldx   #0xb800        ; load index with value
   LB125:  adda  0x00, X      ;  -00000000-
           adda  0x01, X      ;  -00000001-
           adda  0x02, X      ;  -00000010-
           adda  0x03, X      ;  -00000011-
           adda  0x04, X      ;  -00000100-
           adda  0x05, X      ;  -00000101-
           adda  0x06, X      ;  -00000110-
           adda  0x07, X      ;  -00000111-
           abx                ; add B to index
           cpx   Temp0
           bne   LB125
   LB13A:  rts                ; return from subroutine

MUCK_WITH_CEL:
           ldaa  Counter_MainLoop    ; load A with memory contents
           lsla                ; logical shift left A
           lsla                ; logical shift left A
           bne   LB197         ; branch if not equal (not zero)
           ldaa  LastDistributorFallingEdgeTime    ; load A with memory contents
           bita  #0x70         ;  -01110000-
           beq   LB14D         ; branch if equal (zero)
           suba  #0x10         ;  -00010000-
           bita  #0x70         ;  -01110000-
           bne   LB195         ; branch if not equal (not zero)
   LB14D:  ldab  StartupSwitchMirror2    ; load B with memory contents
           eorb  #0x40         ;  -01000000-
           stab  StartupSwitchMirror2    ; store B into memory
           bita  #0x0f         ;  -00001111-
           beq   LB160         ; branch if equal (zero)
           deca                ; decrement A
           bita  #0x0f         ;  -00001111-
           beq   LB160         ; branch if equal (zero)
           oraa  #0x10         ;  -00010000-
           bra   LB195         ; branch

   LB160:  tsta                ; test A
           bmi   LB198         ; branch if minus(hi bit 1)
           ldaa  #0xaa         ; load a with value -10101010-
           ldab  DRBPointer2    ; load B with memory contents
           cmpb  #0xfe         ;  -11111110-
           beq   LB189         ; branch if equal (zero)
           tstb                ; test B
           bmi   LB195         ; branch if minus(hi bit 1)
           cmpb  #0x08         ;  -00001000-
           bcs   LB17C         ; branch if lower
           ldx   #0xb618       ; load index with value
           abx                 ; add B to index
           brset 0x00, X, #$%11111111, LB1DE    ; branch if bit(s) set -00000000-
           bra   LB183         ; branch

   LB17C:  negb                ; 2's complement B
           addb  #0x07         ;  -00000111-
           ldx   #ErrorBitRegister0    ; load index with value
           abx                 ; add B to index
   LB183:  ldab  0x00, X      ; load B with memory at index + value -00000000-
           beq   LB195         ; branch if equal (zero)
           bra   LB18A         ; branch

   LB189:  clrb                ; b = 0
   LB18A:  ldx   #ErrorCodesToDash_Table    ; load index with value
           abx                 ; add B to index
           ldaa  0x00, X      ; load A with memory at index + value -00000000-
           anda  #0x0f         ; AND a with value -00001111-
           lsla                ; logical shift left A
           oraa  #0xa0         ;  -10100000-
   LB195:  staa  LastDistributorFallingEdgeTime    ; store A into memory
   LB197:  rts                 ; return from subroutine

   LB198:  ldab  DRBPointer2    ; load B with memory contents
           cmpb  #0xff         ;  -11111111-
           bne   LB1AA         ; branch if not equal (not zero)
           ldaa  ErrorCodeUpdateKeyOnCount    ; load A with memory contents
           cmpa  #0x32         ; compare a with value -00110010-
           bhi   LB1AA         ; branch if higher
           decb                ; decrement B
           stab  DRBPointer2    ; store B into memory
           clrb                ; b = 0
           bra   LB1CF         ; branch

   LB1AA:  cmpb  #0xfe         ;  -11111110-
           bne   LB1AF         ; branch if not equal (not zero)
           incb                ; increment B
   LB1AF:  incb                ; increment B
           stab  DRBPointer2    ; store B into memory
           cmpb  #0x08         ;  -00001000-
           bcs   LB1C4         ; branch if lower
           brset *DRBPointer2, #$%10000000, LB1E5    ; branch if bit(s) set
           ldx   #0xb618       ; load index with value
           abx                 ; add B to index
           brset 0x00, X, #$%11111111, LB1DE    ; branch if bit(s) set -00000000-
           bra   LB1CB         ; branch

   LB1C4:  negb                ; 2's complement B
           addb  #0x07         ;  -00000111-
           ldx   #ErrorBitRegister0    ; load index with value
           abx                 ; add B to index
   LB1CB:  ldab  0x00, X      ; load B with memory at index + value -00000000-
           beq   LB1DE         ; branch if equal (zero)
   LB1CF:  ldx   #ErrorCodesToDash_Table    ; load index with value
           abx                 ; add B to index
           ldaa  0x00, X      ; load A with memory at index + value -00000000-
           lsra                ; logic shift right A
           lsra                ; logic shift right A
           lsra                ; logic shift right A
           lsra                ; logic shift right A
           lsla                ; logical shift left A
           oraa  #0x40         ;  -01000000-
           bra   LB195         ; branch

   LB1DE:  bset  *DRBPointer2, #$%10000000    ; set bits
           ldaa  #0x4a         ; load a with value -01001010-
           bra   LB195         ; branch

   LB1E5:  clra                ; A = 0
           staa  DRBPointer1    ; store A into memory
           staa  DRBPointer2    ; store A into memory
           rts                 ; return from subroutine


;	.org	0xb1eb
ErrorCodesToDash_Table:
	.word	0x1254
	.word	0x5352
	.word	0x5147
	.word	0x4645
	.word	0x4443
	.word	0x4241
	.word	0x3736
	.word	0x3534
	.word	0x3332
	.word	0x3127
	.word	0x2727
	.word	0x2626
	.word	0x2625
	.word	0x2424
	.word	0x2323
	.word	0x2222
	.word	0x2117
	.word	0x1615
	.word	0x1414
	.word	0x1313
	.word	0x1143
	.word	0x4343
	.word	0x4252
	.word	0x3261
	.word	0x6263
	.word	0x4536
	.word	0x3535
	.word	0x3264
	.word	0x6523
	.word	0x2331
	.word	0x0027
	.word	0x2167
	.word	0x0066
	.byte	0x66
        
PIA1AManipulation_Table:
        .word   0x1513
	.word	0x3D14

VerifyOperationOfFuelInjectorDrivers_MM:
           ldaa  CountdownTimerFromKeyOn    ; load A with memory contents
           beq   LB239         ; branch if equal (zero)
           jmp   LB2AB     

   LB239:  ldaa  SwitchPortAccessReg1    ; load A with memory contents
           bita  #0x10         ;  -00010000-
           beq   LB2AB         ; branch if equal (zero)
           sei                 ; disable interrupts
           ldaa  SwitchPortAccessReg2    ; load A with memory contents
           anda  #0xf0         ; AND a with value -11110000-
           bne   LB28C         ; branch if not equal (not zero)
           brclr *BitFlags72, #b72_bit2, LB28C    ; branch if bit(s) clear
           brset *b5D_IPL2, #$%00010000, LB283    ; branch if bit(s) set
           ldab  #0x04         ; load B with value -00000100-
   LB252:  decb                ; decrement B
           bne   LB252         ; branch if not equal (not zero)
           ldab  #0x04         ; load B with value -00000100-
           bitb  PIA_Ctrl_4
           bne   LB285         ; branch if not equal (not zero)
           ldab  BitFlags72    ; load B with memory contents
           brclr *BitFlags72, #b72_bit7, LB26A    ; branch if bit(s) clear
           ldaa  CPU_TimerControlReg2    ; load A with memory contents
           bita  #0x10         ;  -00010000-
           bne   LB26A         ; branch if not equal (not zero)
           decb                ; decrement B
   LB26A:  cli                 ; enable interrupts
           ldx   #PIA1AManipulation_Table       ; load index with value
           andb  #0x03         ;  -00000011-
           abx                 ; add B to index
           ldaa  0x00, X      ; load A with memory at index + value -00000000-
           ldab  #0x89         ; load B with value -10001001-
           brset *BitFlags6F, #b6f_FuelEngineNotRunning, LB27B    ; branch if bit(s) set
           ldab  #0xa0         ; load B with value -10100000-
   LB27B:  jsr   ThrowNonCriticalError    ; call subroutine
           bcc   LB283         ; branch if greater or equal
           bset  *b5D_IPL2, #$%00010000    ; set bits
   LB283:  ldab  #0x04         ; load B with value -00000100-
   LB285:  cli                 ; enable interrupts
           stab  PIA_Ctrl_4    ; store B into memory
           bclr  *BitFlags72, #b72_bit2    ; clear bits
   LB28C:  sei                 ; disable interrupts
           ldaa  SwitchPortAccessReg1    ; load A with memory contents
           bita  #0x10         ;  -00010000-
           beq   LB2AA         ; branch if equal (zero)
           eora  BitFlags70
           cli                 ; enable interrupts
           bita  #0x04         ;  -00000100-
           beq   LB2AB         ; branch if equal (zero)
           brset *b5D_IPL2, #$%00000001, LB2AB    ; branch if bit(s) set
           ldd   #0x0ba0       ; load D (A&B) with value -00001011 10100000-
           jsr   ThrowNonCriticalError    ; call subroutine
           bcc   LB2AB         ; branch if greater or equal
           bset  *b5D_IPL2, #$%00000001    ; set bits
   LB2AA:  cli                 ; enable interrupts
   LB2AB:  rts                 ; return from subroutine

VerifyOperationOfMapSensor_MM:
           ldaa  Counter_MainLoop    ; load A with memory contents
           bita  #0x07         ;  -00000111-
           bne   LB2AB         ; branch if not equal (not zero)
           brset *b5C_IPL1, #$%10000000, LB2F1    ; branch if bit(s) set
           ldaa  VehicleSpeedScaled    ; load A with memory contents
           cmpa  #0x02         ; compare a with value -00000010-
           bcc   LB2F1         ; branch if greater or equal
           brset *BitFlags66, #b66_OffIdle, LB2F1    ; branch if bit(s) set
           ldd   EngineRpm_HB    ; load D (A&B) with memory contents
           subd  TargetIdleSpeedHB    ; D = D - memory contents
           bcc   LB2C8         ; branch if greater or equal
           coma                ; 1's complement A
           comb                ; 1's complement B
   LB2C8:  cpd   MPRMPD_CheckMapAtZeroSpeedAndThisDeltaRpm    ;  (data is 0200)
           bcc   LB2F1         ; branch if greater or equal
           brset *BitFlags6F, #b6f_FuelEngineNotRunning, LB2F1    ; branch if bit(s) set
           ldaa  BaroPressure    ; load A with memory contents
           tab                 ; B = A
           suba  MapValue  
           bcs   LB2E6         ; branch if lower
           ldx   #MPVACD_AllowMapToTestGoodThisNearBaro    ; load index with value
           cmpb  BAROSW_CheckMapAtZeroSpeedAndThisBaroSwitch    ; compare B with memory contents (data is 61)
           bcc   LB2E2         ; branch if greater or equal
           inX                 ; increment index (I=I+1)
   LB2E2:  cmpa  0x00, X      ; compare A with memory at index + value -00000000-
           bcc   LB2F1         ; branch if greater or equal
   LB2E6:  ldd   #0x2794       ; load D (A&B) with value -00100111 10010100-
           jsr   ThrowNonCriticalError    ; call subroutine
           bcc   LB2F1         ; branch if greater or equal
           bset  *b5C_IPL1, #$%10000000    ; set bits
   LB2F1:  ldx   EngineRpm_HB
           cpx   #0x2ee0       ;  -00101110 11100000-
           bcc   LB2AB         ; branch if greater or equal
           ldab  TpsVoltsOverMINTHR    ; load B with memory contents
           cmpb  MPLTHR_ThrottleLevelAbove_MINTHR_ToMatureMapLimpin    ; compare B with memory contents (data is 42)
           bcc   LB2AB         ; branch if greater or equal
           ldaa  CPU_A2DResults1    ; load A with memory contents
           cmpa  MAPHIG_MapSensorUpperLimit    ; compare A with memory contents (data is ee)
           bcc   LB311         ; branch if greater or equal
           cmpa  MAPLOW_MapSensorLowerLimit    ; compare A with memory contents (data is 01)
           bcc   LB321         ; branch if greater or equal
           ldd   #0x2494       ; load D (A&B) with value -00100100 10010100-
           bra   LB314         ; branch

   LB311:  ldd   #0x2594       ; load D (A&B) with value -00100101 10010100-
   LB314:  brset *b5C_IPL1, #$%00100000, LB320    ; branch if bit(s) set
           jsr   ThrowNonCriticalError    ; call subroutine
           bcc   LB320         ; branch if greater or equal
           bset  *b5C_IPL1, #$%00100000    ; set bits
   LB320:  rts                 ; return from subroutine

   LB321:  brclr *b5C_IPL1, #$%00100000, LB320    ; branch if bit(s) clear
           ldaa  #0x06         ; load a with value -00000110-
ResetErrorCodeIfTimerExpired:
           anda  #0x0f         ; AND a with value -00001111-
           ldab  ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; load B with memory contents
           beq   LB334         ; branch if equal (zero)
           andb  #0x0f         ;  -00001111-
           cba                 ; compare A to B
           bne   LB33A         ; branch if not equal (not zero)
           ldaa  ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; load A with memory contents
   LB334:  adda  #0x10         ;  -00010000-
           bcs   SELECT_ERROR_BIT_POSITION_ROUT    ; branch if lower
           staa  ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; store A into memory
   LB33A:  rts                 ; return from subroutine

SELECT_ERROR_BIT_POSITION_ROUT:
           ldab  #0x01         ; load B with value -00000001-
   LB33D:  deca                ; decrement A
           beq   LB343         ; branch if equal (zero)
           lslb                ; arithmetic shift left B
           bra   LB33D         ; branch

   LB343:  clr   ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; zero byte at memory location
           tba                 ; A = B
           comb                ; 1's complement B
           sei                 ; disable interrupts
           andb  b5C_IPL1  
           stab  b5C_IPL1      ; store B into memory
           cmpa  #0x80         ; compare a with value -10000000-
           beq   LB352         ; branch if equal (zero)
           cli                 ; enable interrupts
   LB352:  rts                 ; return from subroutine

CountRamValuesFrom05to38:
           clra                ; A = 0
           clrb                ; b = 0
           ldx   #MINTHR_LowestSessionTPS    ; load index with value
   LB358:  addb  0x00, X      ; add memory at index + value to B -00000000-
           bcc   LB35D         ; branch if greater or equal
           inca                ; increment A
   LB35D:  inX                 ; increment index (I=I+1)
           cpx   #Timer_BoostTimer    ;  -00000000 00111010-
           bcs   LB358         ; branch if lower
           rts                 ; return from subroutine

VerifyOperationOfThermostat_MM:
           brset *BitFlags6F, #b6f_FuelEngineNotRunning, LB399    ; branch if bit(s) set
           brset *b5C_IPL1, #$%00000010, LB399    ; branch if bit(s) set
           ldaa  Timer_ThermostatDiagnostics    ; load A with memory contents
           beq   LB399         ; branch if equal (zero)
           ldab  Counter_MainLoop    ; load B with memory contents
           bne   LB399         ; branch if not equal (not zero)
           ldab  CoolantTemp    ; load B with memory contents
           cmpb  TDAGTP_TstatDiagnosticsTemperatureGoalWithin_HOTIME    ; compare B with memory contents (data is c7)
           bcc   LB395         ; branch if greater or equal
           ldab  KeyOnOrEngineRunningTime    ; load B with memory contents
           incb                ; increment B
           bne   LB399         ; branch if not equal (not zero)
           ldab  VehicleSpeedScaled    ; load B with memory contents
           cmpb  #0x38         ;  -00111000-
           bcs   LB399         ; branch if lower
           inca                ; increment A
           beq   LB38F         ; branch if equal (zero)
           cmpa  HOTIME_TstatDiagnosticsTimeToAchieveTemperatureGoal    ; compare A with memory contents (data is ae)
           bcs   LB396         ; branch if lower
   LB38F:  ldd   #0x2101       ; load D (A&B) with value -00100001 00000001-
           jsr   ThrowNonCriticalError    ; call subroutine
   LB395:  clra                ; A = 0
   LB396:  staa  Timer_ThermostatDiagnostics
   LB399:  rts                 ; return from subroutine

VerifyOperationOfASDRelayAndO2Sensor_MM:
           ldaa  CountdownTimerFromKeyOn    ; load A with memory contents
           bne   LB399         ; branch if not equal (not zero)
           ldaa  Counter_MainLoop    ; load A with memory contents
           bita  #0x03         ;  -00000011-
           bne   LB3BB         ; branch if not equal (not zero)
           ldaa  TimerOverflowsBetweenDistPulses    ; load A with memory contents
           bne   LB3BB         ; branch if not equal (not zero)
           ldaa  BatteryVolts    ; load A with memory contents
           cmpa  #0x81         ; compare a with value -10000001-
           bcs   LB3BB         ; branch if lower
           ldaa  SwitchPortAccessReg1    ; load A with memory contents
           bita  #0x10         ;  -00010000-
           bne   LB3BB         ; branch if not equal (not zero)
           ldd   #0x2c14       ; load D (A&B) with value -00101100 00010100-
           jsr   ThrowNonCriticalError    ; call subroutine
   LB3BB:  brset *BitFlags6F, #b6f_FuelEngineNotRunning, LB405    ; branch if bit(s) set
           ldaa  KeyOnOrEngineRunningTime    ; load A with memory contents
           cmpa  #0x2c         ; compare a with value -00101100-
           bcs   LB405         ; branch if lower
           ldaa  CoolantTemp    ; load A with memory contents
           cmpa  CTLRPM_LowBatteryVoltageAtThisCoolantTemp    ; compare A with memory contents (data is cd)
           bcs   LB405         ; branch if lower
           brclr *BitFlags67, #b67_InMotion, LB40A    ; branch if bit(s) clear
           ldaa  FuelLookupValue3D    ; load A with memory contents
           cmpa  O2DIAG_CounterLimitForO2SensorDiag    ; compare A with memory contents (data is 13)
           bcs   LB3FB         ; branch if lower
           ldaa  O2SensorVolts    ; load A with memory contents
           cmpa  O2MID_LimitForO2SensorBatteryDiag    ; compare A with memory contents (data is 4d)
           bcs   LB401         ; branch if lower
           ldaa  Timer_O2MiddleDiagnostics    ; load A with memory contents
           cmpa  #0x16         ; compare a with value -00010110-
           bcs   LB3F0         ; branch if lower
           ldd   #0x2001       ; load D (A&B) with value -00100000 00000001-
           jsr   ThrowNonCriticalError    ; call subroutine
           bset  *BitFlags71, #b71_BadO2    ; set bits
           bra   LB462         ; branch

   LB3F0:  ldab  Counter_MainLoop    ; load B with memory contents
           cmpb  #0x50         ;  -01010000-
           bne   LB462         ; branch if not equal (not zero)
           inca                ; increment A
           staa  Timer_O2MiddleDiagnostics    ; store A into memory
           bra   LB462         ; branch

   LB3FB:  inca                ; increment A
           staa  FuelLookupValue3D
           bra   LB462         ; branch

   LB401:  clra                ; A = 0
           staa  FuelLookupValue3D
   LB405:  bclr  *BitFlags67, #b67_InMotion    ; clear bits
           bra   LB433         ; branch

   LB40A:  ldaa  O2SensorVolts    ; load A with memory contents
           cmpa  O2HIGH_HighLimitForImmediateSwitchToClosedLoop    ; compare A with memory contents (data is 26)
           bhi   LB433         ; branch if higher
           cmpa  O2LOW_LowLimitForImmediateSwitchToClosedLoop    ; compare A with memory contents (data is 0f)
           bcs   LB433         ; branch if lower
           ldaa  Timer_O2MiddleDiagnostics    ; load A with memory contents
           cmpa  #0x0b         ; compare a with value -00001011-
           bcs   LB42A         ; branch if lower
           bset  *BitFlags67, #b67_InMotion    ; set bits
           clra                ; A = 0
           staa  Timer_O2MiddleDiagnostics    ; store A into memory
           staa  FuelLookupValue3D
           bset  *PIA1_Buffer, #$%00001000    ; set bits
           bra   LB462         ; branch

   LB42A:  ldab  Counter_MainLoop    ; load B with memory contents
           cmpb  #0xa0         ;  -10100000-
           bne   LB436         ; branch if not equal (not zero)
           inca                ; increment A
           bra   LB434         ; branch

   LB433:  clra                ; A = 0
   LB434:  staa  Timer_O2MiddleDiagnostics    ; store A into memory
   LB436:  bclr  *PIA1_Buffer, #$%00001000    ; clear bits
           ldaa  FuelLookupValue3D    ; load A with memory contents
           cmpa  O2DIAG_CounterLimitForO2SensorDiag    ; compare A with memory contents (data is 13)
           bcc   LB446         ; branch if greater or equal
           inca                ; increment A
           staa  FuelLookupValue3D
           rts                 ; return from subroutine

   LB446:  ldaa  Counter_MainLoop    ; load A with memory contents
           bita  #0x07         ;  -00000111-
           bne   LB462         ; branch if not equal (not zero)
           brset *BitFlags71, #b71_BadO2, LB462    ; branch if bit(s) set
           ldaa  O2SensorVolts    ; load A with memory contents
           cmpa  O2MIDX_HighLimitForInMiddleDeterminationX    ; compare A with memory contents (data is 3e)
           bls   LB462         ; branch if lower or same
           ldd   #0x3e9e       ; load D (A&B) with value -00111110 10011110-
           jsr   ThrowNonCriticalError    ; call subroutine
           bcc   LB462         ; branch if greater or equal
           bset  *BitFlags71, #b71_BadO2    ; set bits
   LB462:  rts                 ; return from subroutine

DealWithConfigurationAndPulseAccumulator_MM:
           ldx   #CPU_PortA    ; load index with value
           brset 0x09, X, #$%00111010, LB46D    ; branch if bit(s) set -00001001-
           bset  0x09, X, #$%00111010    ; set bits -00001001-
   LB46D:  brclr 0x09, X, #$%00000101, LB474    ; branch if bit(s) clear -00001001-
           bclr  0x09, X, #$%00000101    ; clear bits -00001001-
   LB474:  ldaa  CPU_OutputCompare1Mask    ; load A with memory contents
           bita  #0xf8         ;  -11111000-
           beq   LB47E         ; branch if equal (zero)
           clr   CPU_OutputCompare1Mask    ; zero byte at memory location
   LB47E:  brset 0x21, X, #$%00001000, LB485    ; branch if bit(s) set -00100001-
           bset  0x21, X, #$%00001000    ; set bits -00100001-
   LB485:  brclr 0x21, X, #$%00000111, LB48C    ; branch if bit(s) clear -00100001-
           bclr  0x21, X, #$%00000111    ; clear bits -00100001-
   LB48C:  brset 0x22, X, #$%10111110, LB493    ; branch if bit(s) set -00100010-
           bset  0x22, X, #$%10111110    ; set bits -00100010-
   LB493:  brclr 0x22, X, #$%00000001, LB49A    ; branch if bit(s) clear -00100010-
           bclr  0x22, X, #$%00000001    ; clear bits -00100010-
   LB49A:  brclr 0x24, X, #$%11110001, LB4A1    ; branch if bit(s) clear -00100100-
           bclr  0x24, X, #$%11110001    ; clear bits -00100100-
   LB4A1:  ldaa  CPU_PortA_Control    ; load A with memory contents
           beq   LB4A9         ; branch if equal (zero)
           clr   CPU_PortA_Control    ; zero byte at memory location
   LB4A9:  ldaa  #0x54         ; load a with value -01010100-
           cmpa  CPU_SerialPeripheralControl    ; compare A with memory contents
           beq   LB4B3         ; branch if equal (zero)
           staa  CPU_SerialPeripheralControl
   LB4B3:  ldd   #AISACCompensation    ; load D (A&B) with value -00000000 00001100-
           cpd   CPU_SerialControlReg1
           beq   LB4BF         ; branch if equal (zero)
           std   CPU_SerialControlReg1
   LB4BF:  brset 0x39, X, #$%10001000, LB4C6    ; branch if bit(s) set -00111001-
           bset  0x39, X, #$%10001000    ; set bits -00111001-
   LB4C6:  brclr 0x39, X, #$%01000000, LB4CD    ; branch if bit(s) clear -00111001-
           bclr  0x39, X, #$%01000000    ; clear bits -00111001-
   LB4CD:  brset 0x3c, X, #$%00000101, LB4D6    ; branch if bit(s) set -00111100-
           sei                 ; disable interrupts
           bset  0x3c, X, #$%00000101    ; set bits -00111100-
           cli                 ; enable interrupts
   LB4D6:  brclr 0x3c, X, #$%00001010, LB4DF    ; branch if bit(s) clear -00111100-
           sei                 ; disable interrupts
           bclr  0x3c, X, #$%00001010    ; clear bits -00111100-
           cli                 ; enable interrupts
   LB4DF:  ldx   #SwitchPortAccessReg1    ; load index with value
           sei                 ; disable interrupts
           brclr 0x02, X, #$%01010100, LB4EA    ; branch if bit(s) clear -00000010-
           bclr  0x02, X, #$%01010100    ; clear bits -00000010-
   LB4EA:  ldaa  PIA1_Buffer    ; load A with memory contents
           staa  PortX_Control
           cli                 ; enable interrupts
           ldaa  0x03, X      ; load A with memory at index + value -00000011-
           beq   LB4F6         ; branch if equal (zero)
           clr   0x03, X       ; clear memory
   LB4F6:  ldaa  0x04, X      ; load A with memory at index + value -00000100-
           beq   LB4FC         ; branch if equal (zero)
           clr   0x04, X       ; clear memory
   LB4FC:  ldaa  #0xf8         ; load a with value -11111000-
           cmpa  0x06, X      ; compare A with memory at index + value -00000110-
           beq   LB504         ; branch if equal (zero)
           staa  0x06, X      ;  -00000110-
   LB504:  rts                 ; return from subroutine

VerifyOperationOfIgnitionCoilDriver_MM:
           ldaa  Counter_TimerPastHalfwayBetweenCamPulses    ; load A with memory contents
           cmpa  #0xa0         ; compare a with value -10100000-
           bcs   LB54D         ; branch if lower
           ldaa  CountdownTimerFromKeyOn    ; load A with memory contents
           bne   LB550         ; branch if not equal (not zero)
           ldaa  SwitchPortAccessReg2    ; load A with memory contents
           tab                 ; B = A
           eorb  BitFlags6B
           andb  #0x01         ;  -00000001-
           beq   LB525         ; branch if equal (zero)
           anda  #0x01         ; AND a with value -00000001-
           ldab  BitFlags6B    ; load B with memory contents
           andb  #0xfe         ;  -11111110-
           aba                 ; A=A+B
           staa  BitFlags6B    ; store A into memory
           bclr  *BitFlags6B, #$%00000100    ; clear bits
   LB525:  brset *BitFlags6B, #$%00000100, LB550    ; branch if bit(s) set
           ldaa  Counter_MainLoop    ; load A with memory contents
           bita  #0x0f         ;  -00001111-
           bne   LB550         ; branch if not equal (not zero)
           ldaa  BatteryVolts    ; load A with memory contents
           cmpa  #0x41         ; compare a with value -01000001-
           bcs   LB550         ; branch if lower
           cmpa  COILHI_HiLimitBatteryVoltsForCoilVerify    ; compare A with memory contents (data is ba)
           bcc   LB550         ; branch if greater or equal
           ldaa  MapValue_X     ; load A with memory contents
           suba  MapVolts_X 
           bls   LB550         ; branch if lower or same
           cmpa  COILLO_LoLimitBatteryVoltsForCoilVerify    ; compare A with memory contents (data is 05)
           bcs   LB550         ; branch if lower
           ldd   #0x2814       ; load D (A&B) with value -00101000 00010100-
           jmp   ThrowNonCriticalError

   LB54D:  bset  *BitFlags6B, #$%00000100    ; set bits
   LB550:  rts                 ; return from subroutine


	.org	0xb600
LB600:
	.byte	0xff

	.org	0xb610
LB610:
	.byte	0xff

	.org	0xb612
LB612:
	.byte	0xff

	.org	0xb613
LB613:
	.byte	0xff

	.org	0xb615
LB615:
	.byte	0xff

	.org	0xb616
LB616:
	.byte	0xff

	.org	0xb617
LB617:
	.byte	0xff

	.org	0xb620
LB620:
	.byte	0xff

	.org	0xb6de
LB6DE:
	.byte	0xff

	.org	0xb7e0
LB7E0:
	.byte	0xff

	.org	0xb7e1
LB7E1:
	.byte	0xff

	.org	0xb7ef
LB7EF:
	.byte	0xff

	.org	0xb800
ErrorBitManipulation_Table:
	.byte	0xff, 0x7f, 0x00
        .byte   0x01, 0x20, 0x02
        .byte   0xff, 0x7f, 0x00
        .byte   0xff, 0x7f, 0x00
        .byte   0xff, 0x7f, 0x00
        .byte   0xff, 0x7f, 0x00
        .byte   0xff, 0x7f, 0x00
        .byte   0x26, 0x8a, 0x80

	.org	0xb818
ErrorRoutineTablePIA_A:
	.word	LBA8F
	.word	LBA3F
	.word	SetErrorCodePIA_A
	.word	ErrorRoutineReturnPIA_A
	.word	LBA6F
	.word	LBA5F
	.word	LBA4F
	.word	ErrorRoutineReturnPIA_A

	.org	0xb828
ErrorCodeTablePIA_A:
	.word	0x1020 ; Code 33 AC Cut Relay
        .word   0x1120 ; Code 32 EGR Solenoid
        .word   0x0d20 ; Code 36 WG Solenoid
        .word   0x0000 ; Code 12
	.word	0x0a20 ; Code 42 ASD Relay
        .word   0x1220 ; Code 31 Purge Solenoid
        .word   0x3620 ; Code ??
        .word   0x0f20 ; Code 34 SC Solenoid

	.org	0xb838
ErrorRoutineTablePIA_B:
	.word	LB9E2
	.word	LB9E2
	.word	SetErrorCodePIA_B
	.word	LB9E2
	.word	LB98C
	.word	LB980
	.word	LB9E2
	.word	LB974

	.org	0xb848
ErrorCodeTablePIA_B:
	.word	0x0000 ; Code 12
        .word   0x0000 ; Code 12
        .word   0x1920 ; Code 25 AIS Motor
        .word   0x0000 ; Code 12
	.word	0x2f20 ; Code 63 EEPROM
        .word   0x0c20 ; Code 37 Baro Solenoid
        .word   0x0000 ; Code 12
        .word   0x0e20 ; Code 35 Rad Fan Relay


UpdatePIA1AndCheckOuputs_MM:
           ldaa  StartupSwitchMirror2    ; load A with memory contents
           brclr *BitFlags37, #$%00001000, LB869    ; branch if bit(s) clear
           bclr  *BitFlags37, #$%00001000    ; clear bits
           adda  #0xc8         ;  -11001000-
           staa  Temp0         ; store A into memory
           ldaa  #0x1f         ; load a with value -00011111-
           bra   LB86F         ; branch

   LB869:  adda  #0x0b         ;  -00001011-
           staa  Temp0         ; store A into memory
           ldaa  #0x62         ; load a with value -01100010-
   LB86F:  staa  Temp1         ; store A into memory
           ldab  #0x40         ; load B with value -01000000-
           ldaa  #0x61         ; load a with value -01100001-
           ldy   #CPU_PortA    ; load index with value
           ldx   #SwitchPortAccessReg1    ; load index with value
           bset  0x00, X, #$%00001000    ; set bits -00000000-
           sei                 ; disable interrupts
           bclr  0x08, Y, #$%00100000    ; clear bits -00001000-
           cmpb  CPU_SerialPeripheralStatus    ; compare B with memory contents
           staa  CPU_SerialPeripheralDataIO
           bset  0x02, X, #$%00001000    ; set bits -00000010-
           bclr  0x02, X, #$%00001000    ; clear bits -00000010-
           nop                 ; no operation
           ldaa  CPU_SerialPeripheralDataIO    ; load A with memory contents
           cmpa  CPU_SerialPeripheralStatus    ; compare A with memory contents
           ldaa  Temp1         ; load A with memory contents
   LB899:  brclr 0x00, X, #$%00001000, LB8A3    ; branch if bit(s) clear -00000000-
           decb                ; decrement B
           bne   LB899         ; branch if not equal (not zero)
           jmp   LB9C8     

   LB8A3:  staa  CPU_SerialPeripheralDataIO
           bset  0x02, X, #$%00001000    ; set bits -00000010-
           bclr  0x02, X, #$%00001000    ; clear bits -00000010-
           nop                 ; no operation
           ldaa  CPU_SerialPeripheralDataIO    ; load A with memory contents
           staa  Temp1         ; store A into memory
           cmpa  CPU_SerialPeripheralStatus    ; compare A with memory contents
           ldaa  #0x08         ; load a with value -00001000-
   LB8B7:  brclr 0x00, X, #$%00001000, LB8C1    ; branch if bit(s) clear -00000000-
           decb                ; decrement B
           bne   LB8B7         ; branch if not equal (not zero)
           jmp   LB9C8     

   LB8C1:  staa  CPU_SerialPeripheralDataIO
           bset  0x02, X, #$%00001000    ; set bits -00000010-
           bclr  0x02, X, #$%00001000    ; clear bits -00000010-
           nop                 ; no operation
           ldaa  CPU_SerialPeripheralDataIO    ; load A with memory contents
           staa  Temp2         ; store A into memory
           cmpa  CPU_SerialPeripheralStatus    ; compare A with memory contents
           ldaa  StartupSwitchMirror2    ; load A with memory contents
   LB8D5:  brclr 0x00, X, #$%00001000, LB8DF    ; branch if bit(s) clear -00000000-
           decb                ; decrement B
           bne   LB8D5         ; branch if not equal (not zero)
           jmp   LB9C8     

   LB8DF:  staa  CPU_SerialPeripheralDataIO
           bset  0x02, X, #$%00001000    ; set bits -00000010-
           bclr  0x02, X, #$%00001000    ; clear bits -00000010-
           nop                 ; no operation
           ldaa  CPU_SerialPeripheralDataIO    ; load A with memory contents
           staa  Temp3         ; store A into memory
           cmpa  CPU_SerialPeripheralStatus    ; compare A with memory contents
           ldaa  #0x40         ; load a with value -01000000-
   LB8F3:  brclr 0x00, X, #$%00001000, LB8FD    ; branch if bit(s) clear -00000000-
           decb                ; decrement B
           bne   LB8F3         ; branch if not equal (not zero)
           jmp   LB9C8     

   LB8FD:  staa  CPU_SerialPeripheralDataIO
           bset  0x02, X, #$%00001000    ; set bits -00000010-
           bclr  0x02, X, #$%00001000    ; clear bits -00000010-
           nop                 ; no operation
           ldaa  CPU_SerialPeripheralDataIO    ; load A with memory contents
           staa  Temp4         ; store A into memory
           cmpa  CPU_SerialPeripheralStatus    ; compare A with memory contents
           ldaa  Temp0         ; load A with memory contents
   LB911:  brclr 0x00, X, #$%00001000, LB91B    ; branch if bit(s) clear -00000000-
           decb                ; decrement B
           bne   LB911         ; branch if not equal (not zero)
           jmp   LB9C8     

   LB91B:  staa  CPU_SerialPeripheralDataIO
           bset  0x02, X, #$%00001000    ; set bits -00000010-
           bclr  0x02, X, #$%00001000    ; clear bits -00000010-
           nop                 ; no operation
   LB925:  brset 0x29, Y, #$%10000000, LB930    ; branch if bit(s) set -00101001-
           decb                ; decrement B
           bne   LB925         ; branch if not equal (not zero)
           jmp   LB9C8     

   LB930:  ldaa  CPU_SerialPeripheralDataIO    ; load A with memory contents
           bset  0x08, Y, #$%00100000    ; set bits -00001000-
           cli                 ; enable interrupts
           ldab  Temp1         ; load B with memory contents
           addb  Temp2         ; B=B+memory contents
           addb  Temp3         ; B=B+memory contents
           addb  Temp4         ; B=B+memory contents
           cba                 ; compare A to B
           bne   LB97E         ; branch if not equal (not zero)
           ldaa  Temp2         ; load A with memory contents
           anda  #0xf1         ; AND a with value -11110001-
           ldab  StartupSwitchMirror1    ; load B with memory contents
           andb  #0x0e         ;  -00001110-
           aba                 ; A=A+B
           staa  StartupSwitchMirror1    ; store A into memory
           ldaa  Temp4         ; load A with memory contents
           oraa  L00F5         ; OR A with memory contents
           staa  L00F5         ; store A into memory
           anda  PIBMSK_PIA1BDDRMask    ;  (data is 94)
           ldab  BatteryVolts    ; load B with memory contents
           cmpb  #0xa2         ;  -10100010-
           bcs   LB97E         ; branch if lower
           ldab  CountdownTimerFromKeyOn    ; load B with memory contents
           bne   LB97E         ; branch if not equal (not zero)
           ldx   #ErrorRoutineTablePIA_B    ; load index with value
           ldy   #ErrorCodeTablePIA_B    ; load index with value
           ldab  Counter_MainLoop    ; load B with memory contents
           andb  #0x07         ;  -00000111-
           lslb                ; arithmetic shift left B
           aby                 ; add B to index
           abx                 ; add B to index
           ldx   0x00, X      ;  -00000000-
           jmp   0x00, X       ; indexed jump

   LB974:  anda  #0x80         ; AND a with value -10000000-
           beq   LB9E2         ; branch if equal (zero)
           bclr  *L00F5, #$%10000000    ; clear bits
           jsr   LBA73         ; call subroutine
   LB97E:  bra   LB9E2         ; branch

   LB980:  anda  #0x20         ; AND a with value -00100000-
           beq   LB9E2         ; branch if equal (zero)
           bclr  *L00F5, #$%00100000    ; clear bits
           jsr   LBA73         ; call subroutine
           bra   LB9E2         ; branch

   LB98C:  anda  #0x10         ; AND a with value -00010000-
           beq   LB9E2         ; branch if equal (zero)
           bclr  *L00F5, #$%00010000    ; clear bits
           jsr   LBA61         ; call subroutine
           bra   LB9E2         ; branch

SetErrorCodePIA_B:  
           brset *BitFlags6C, #$%01000000, LB9E2    ; branch if bit(s) set
           bita  #0x01         ;  -00000001-
           bne   LB9C0         ; branch if not equal (not zero)
           anda  #0x04         ; AND a with value -00000100-
           beq   LB9C0         ; branch if equal (zero)
           ldd   0x00, Y      ;  -00000000-
           brset *BitFlags37, #$%01000000, LB9B0    ; branch if bit(s) set
           ldab  #0x04         ; load B with value -00000100-
           bset  *BitFlags37, #$%00001000    ; set bits
   LB9B0:  orab  #0x80         ;  -10000000-
           jsr   ThrowCriticalError    ; call subroutine
           bcc   LB9C3         ; branch if greater or equal
           bset  *b5D_IPL2, #$%01000000    ; set bits
           bset  *BitFlags6C, #$%01000000    ; set bits
           bclr  *BitFlags37, #$%00001000    ; clear bits
   LB9C0:  bset  *BitFlags37, #$%01000000    ; set bits
   LB9C3:  bclr  *L00F5, #$%00000101    ; clear bits
           bra   LB9E2         ; branch

   LB9C8:  bset  0x08, Y, #$%00100000    ; set bits -00001000-
           cli                 ; enable interrupts
           ldd   #0x4488       ; load D (A&B) with value -01000100 10001000-
           jsr   ThrowNonCriticalError    ; call subroutine
           bcc   LB9E2         ; branch if greater or equal
           ldaa  SwitchPortAccessReg1    ; load A with memory contents
           anda  #0xfe         ; AND a with value -11111110-
           staa  SwitchPortAccessReg1
           oraa  #0x01         ;  -00000001-
           staa  SwitchPortAccessReg1
   LB9E2:  sei                 ; disable interrupts
           ldab  CPU_SerialPeripheralControl    ; load B with memory contents
           orab  #0x01         ;  -00000001-
           stab  CPU_SerialPeripheralControl    ; store B into memory
           bclr  *PIA1_Buffer, #$%00000100    ; clear bits
           ldab  PIA1_Buffer    ; load B with memory contents
           stab  PortX_Control    ; store B into memory
           ldaa  PIA2_Buffer    ; load A with memory contents
           cmpa  CPU_SerialPeripheralStatus    ; compare A with memory contents
           staa  CPU_SerialPeripheralDataIO
           mul                 ; multiply (D=A*B)
           mul                 ; multiply (D=A*B)
           nop                 ; no operation
           bset  *PIA1_Buffer, #$%00000100    ; set bits
           ldaa  PIA1_Buffer    ; load A with memory contents
           staa  PortX_Control
           ldaa  CPU_SerialPeripheralDataIO    ; load A with memory contents
           ldab  CPU_SerialPeripheralControl    ; load B with memory contents
           andb  #0xfc         ;  -11111100-
           stab  CPU_SerialPeripheralControl    ; store B into memory
           staa  CCDFlagsX 
           eora  CCDFlags2 
           anda  PIAMSK_PIA1ADDRMask    ;  (data is 17)
           ldab  CCDFlags2     ; load B with memory contents
           stab  CCDFlags3     ; store B into memory
           ldab  PIA2_Buffer    ; load B with memory contents
           stab  CCDFlags2     ; store B into memory
           cli                 ; enable interrupts
           ldab  BatteryVolts    ; load B with memory contents
           cmpb  #0xa2         ;  -10100010-
           bcs   ErrorRoutineReturnPIA_A         ; branch if lower
           ldab  CountdownTimerFromKeyOn    ; load B with memory contents
           bne   ErrorRoutineReturnPIA_A         ; branch if not equal (not zero)
           ldx   #ErrorRoutineTablePIA_A    ; load index with value
           ldy   #ErrorCodeTablePIA_A    ; load index with value
           ldab  Counter_MainLoop    ; load B with memory contents
           andb  #0x07         ;  -00000111-
           lslb                ; arithmetic shift left B
           abx                 ; add B to index
           aby                 ; add B to index
           ldx   0x00, X      ;  -00000000-
           jmp   0x00, X       ; indexed jump

   LBA3F:  pshx                ; pull index from stack
           ldx   #CODE13_      ; load index with value
           brclr 0x00, X, #$%00010000, LBA4A    ; branch if bit(s) clear -00000000-
           pulx                ; pull index from stack
           bra   ErrorRoutineReturnPIA_A         ; branch

   LBA4A:  pulx                ; pull index from stack
           anda  #0x02         ; AND a with value -00000010-
           bra   LBA61         ; branch

   LBA4F:  pshx                ; pull index from stack
           ldx   #CODE13_      ; load index with value
           brset 0x00, X, #$%00010000, LBA5A    ; branch if bit(s) set -00000000-
           pulx                ; pull index from stack
           bra   ErrorRoutineReturnPIA_A         ; branch

   LBA5A:  pulx                ; pull index from stack
           anda  #0x02         ; AND a with value -00000010-
           bra   LBA71         ; branch

   LBA5F:  anda  #0x20         ; AND a with value -00100000-
   LBA61:  beq   ErrorRoutineReturnPIA_A         ; branch if equal (zero)
           ldd   0x00, Y      ;  -00000000-
           jsr   ThrowCriticalError    ; call subroutine
           bcc   ErrorRoutineReturnPIA_A         ; branch if greater or equal
           bset  *b5D_IPL2, #$%01000000    ; set bits

ErrorRoutineReturnPIA_A:  
           rts                 ; return from subroutine

   LBA6F:  anda  #0x10         ; AND a with value -00010000-
   LBA71:  beq   ErrorRoutineReturnPIA_A         ; branch if equal (zero)
   LBA73:  ldd   0x00, Y      ;  -00000000-
           jsr   ThrowNonCriticalError    ; call subroutine
           rts                 ; return from subroutine

SetErrorCodePIA_A:  
           anda  #0x04         ; AND a with value -00000100-
           beq   ErrorRoutineReturnPIA_A         ; branch if equal (zero)
           brset *b5D_IPL2, #$%00100000, ErrorRoutineReturnPIA_A    ; branch if bit(s) set
           ldd   0x00, Y      ;  -00000000-
           orab  #0x80         ;  -10000000-
           bsr   ThrowNonCriticalError    ; call subroutine
           bcc   ErrorRoutineReturnPIA_A         ; branch if greater or equal
           bset  *b5D_IPL2, #$%00100000    ; set bits
           rts                 ; return from subroutine

   LBA8F:  anda  #0x01         ; AND a with value -00000001-
           beq   ErrorRoutineReturnPIA_A         ; branch if equal (zero)
           ldaa  CONFIG_ConfigurationFlags    ; load A with memory contents (data is 92)
           bita  #0x80         ;  -10000000-
           bne   LBAA8         ; branch if not equal (not zero)
           ldab  KeyOnOrEngineRunningTime    ; load B with memory contents
           cmpb  #0x0a         ;  -00001010-
           bcs   ErrorRoutineReturnPIA_A         ; branch if lower
           brset *BitFlags6F, #b6f_FuelEngineNotRunning, ErrorRoutineReturnPIA_A    ; branch if bit(s) set
           brclr *StartupSwitchMirror1, #$%10000000, LBA73    ; branch if bit(s) clear
   LBAA8:  brclr *StartupSwitchMirror2, #$%10000000, LBA73    ; branch if bit(s) clear
           rts                 ; return from subroutine

;	.org	0xbaad
DELAY_36USEC_ROUTINE:
           nop		    ; no operation
	   nop		    ; no operation
	   nop		    ; no operation
	   nop		    ; no operation

Delay32uSec:
           ldy   #0x0007       ; load index with value
   LBAB5:  deY                 ; decrement index (I=I-1)
           bne   LBAB5         ; branch if not equal (not zero)
           rts                 ; return from subroutine

ThrowCriticalError:
           ldx   #CONFIG_ConfigurationFlags    ; load index with value
           brclr 0x00, X, #$%01000000, ThrowNonCriticalError    ; branch if bit(s) clear -00000000-
           brset *b5D_IPL2, #$%01000000, ThrowNonCriticalError    ; branch if bit(s) set
           orab  #0x80         ;  -10000000-
ThrowNonCriticalError:
           ldx   #FLTMSK1_ErrorBitsMask1       ; load index with value
   LBACA:  brclr 0x00, X, #$%11111111, LBAD5    ; branch if bit(s) clear -00000000-
           cmpa  0x00, X      ; compare A with memory at index + value -00000000-
           beq   LBB18         ; branch if equal (zero)
           inX                 ; increment index (I=I+1)
           bra   LBACA         ; branch

   LBAD5:  tstb                ; test B
           bmi   LBAE0         ; branch if minus(hi bit 1)
           cmpa  ErrorBitRegisterStored3    ; compare A with memory contents
           beq   LBB15         ; branch if equal (zero)
           cmpa  ErrorBitRegisterStored2    ; compare A with memory contents
           beq   LBB0B         ; branch if equal (zero)
   LBAE0:  andb  #0x7f         ;  -01111111-
           cmpb  #0x01         ;  -00000001-
           beq   LBB1F         ; branch if equal (zero)
           stab  Temp0         ; store B into memory
           ldx   #ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB    ; load index with value
           cmpa  0x00, X      ; compare A with memory at index + value -00000000-
           beq   LBAFD         ; branch if equal (zero)
           inX                 ; increment index (I=I+1)
           cmpa  0x00, X      ; compare A with memory at index + value -00000000-
           beq   LBAFD         ; branch if equal (zero)
           tst   0x00, X       ; test memory for 0 or -
           beq   LBAFD         ; branch if equal (zero)
           deX                 ; decrement index (I=I-1)
           tst   0x00, X       ; test memory for 0 or -
           bne   LBB18         ; branch if not equal (not zero)
   LBAFD:  staa  0x00, X      ;  -00000000-
           inc   0x02, X       ; increment memory
           beq   LBB1B         ; branch if equal (zero)
           cmpb  0x02, X      ;  -00000010-
           bcs   LBB1B         ; branch if lower
           ldab  0x02, X      ; load B with memory at index + value -00000010-
           clc                 ; clear carry
           rts                 ; return from subroutine

   LBB0B:  ldd   ErrorBitRegisterStored2    ; load D (A&B) with memory contents
           staa  ErrorBitRegisterStored3    ; store A into memory
           stab  ErrorBitRegisterStored2    ; store B into memory
           ldaa  ErrorCodeUpdateKeyOnCount    ; load A with memory contents
           staa  ErrorCodeUpdateKeyOnCount2    ; store A into memory
   LBB15:  clra                ; A = 0
           staa  ErrorCodeUpdateKeyOnCount    ; store A into memory
   LBB18:  clra                ; A = 0
           clc                 ; clear carry
           rts                 ; return from subroutine

   LBB1B:  clr   0x00, X       ; clear memory
           clr   0x02, X       ; clear memory
   LBB1F:  ldx   #ErrorBitRegister0    ; load index with value
   LBB22:  cmpa  0x00, X      ; compare A with memory at index + value -00000000-
           bne   LBB2B         ; branch if not equal (not zero)
           clrb                ; b = 0
           stab  0x00, X      ;  -00000000-
           bra   LBB33         ; branch

   LBB2B:  inX                 ; increment index (I=I+1)
           cpx   #ErrorBitRegisterStored3    ;  -00000000 00100100-
           bls   LBB22         ; branch if lower or same
           ldab  #0xff         ; load B with value -11111111-

   LBB33:  stab  Temp0         ; store B into memory
           ldx   #ErrorBitRegisterStored3    ; load index with value
           ldy   #ErrorCodeUpdateKeyOnCount    ; load index with value
   LBB3C:  cpx   #ErrorBitRegisterStored1    ;  -00000000 00100010-
           bcs   LBB4F         ; branch if lower
           psha                ; push A onto stack
           ldab  0x00, Y      ; load B with memory at index + value -00000000-
           ldaa  Temp0         ; load A with memory contents
           staa  0x00, Y      ;  -00000000-
           inY                 ; increment index (I=I+1)
           stab  Temp0         ; store B into memory
           pula                ; pull A from stack
   LBB4F:  ldab  0x00, X      ; load B with memory at index + value -00000000-
           staa  0x00, X      ;  -00000000-
           tba                 ; A = B
           beq   LBB8B         ; branch if equal (zero)
           deX                 ; decrement index (I=I-1)
           cpx   #ErrorBitRegister0    ;  -00000000 00011101-
           bcc   LBB3C         ; branch if greater or equal
           clrb                ; b = 0
           stab  ErrorCodeUpdateKeyOnCount    ; store B into memory
           sei                 ; disable interrupts
           ldab  BitFlags70    ; load B with memory contents
           bitb  #0x03         ;  -00000011-
           bne   LBB88         ; branch if not equal (not zero)
           bset  *BitFlags70, #$%00000001    ; set bits
           cli                 ; enable interrupts
           staa  DRBOffsetStored_LB    ; store A into memory
           ldx   #0xb61f       ; load index with value
   LBB6F:  inX                 ; increment index (I=I+1)
           cpx   #0xb660       ;  -10110110 01100000-
           beq   LBB85         ; branch if equal (zero)
           ldab  0x00, X      ; load B with memory at index + value -00000000-
           cba                 ; compare A to B
           beq   LBB85         ; branch if equal (zero)
           incb                ; increment B
           bne   LBB6F         ; branch if not equal (not zero)
           xgdx                ; exchange D and index
           subd  #LB600        ;  -10110110 00000000-
           stab  DRBOffsetStored_HB    ; store B into memory
           bra   LBB88         ; branch

   LBB85:  bclr  *BitFlags70, #$%00000001    ; clear bits
   LBB88:  cli                 ; enable interrupts
           bra   LBB9D         ; branch

   LBB8B:  cpy   #ErrorCodeUpdateKeyOnCount3    ;  -00000000 00100111-
           bhi   LBB9A         ; branch if higher
           ldab  ErrorCodeUpdateKeyOnCount    ; load B with memory contents
           beq   LBB9D         ; branch if equal (zero)
           ldab  Temp0         ; load B with memory contents
           stab  0x00, Y      ;  -00000000-
   LBB9A:  clrb                ; b = 0
           stab  ErrorCodeUpdateKeyOnCount    ; store B into memory
   LBB9D:  sec                 ; set carry
   LBB9E:  rts                 ; return from subroutine

ProcessErrorBits_WorkWithData_MM:
           brclr *BitFlags5E, #$%11111111, LBB9E    ; branch if bit(s) clear
           ldaa  CountdownTimerFromKeyOn    ; load A with memory contents
           bne   LBB9E         ; branch if not equal (not zero)
           clra                ; A = 0
           clrb                ; b = 0
           sec                 ; set carry
   LBBAA:  rola                ; rotate left A
           bcs   LBB9E         ; branch if lower
           addb  #0x03         ;  -00000011-
           bita  BitFlags5E
           beq   LBBAA         ; branch if equal (zero)
           ldx   #ErrorBitManipulation_Table - 3       ; load index with value
           abx                 ; add B to index
           std   Temp3         ; store D (A&B) into memory
           coma                ; 1's complement A
           sei                 ; disable interrupts
           anda  BitFlags5E    ; logical and A with memory contents
           staa  BitFlags5E    ; store A into memory
           cli                 ; enable interrupts
           ldd   0x00, X      ;  -00000000-
           tstb                ; test B
           bpl   LBBC8         ; branch if plus (hi bit 0)
           bset  *Temp4, #$%10000000    ; set bits
   LBBC8:  jsr   ThrowNonCriticalError    ; call subroutine
           brclr *Temp4, #$%10000000, LBBE1    ; branch if bit(s) clear
           bcc   LBBE1         ; branch if greater or equal
           ldx   #ErrorBitManipulation_Table - 3       ; load index with value
           ldab  Temp4         ; load B with memory contents
           andb  #0x7f         ;  -01111111-
           abx                 ; add B to index
           ldaa  0x02, X      ; load A with memory at index + value -00000010-
           sei                 ; disable interrupts
           oraa  b5C_IPL1      ; OR A with memory contents
           staa  b5C_IPL1      ; store A into memory
           cli                 ; enable interrupts
   LBBE1:  ldd   Temp3         ; load D (A&B) with memory contents
           andb  #0x7f         ;  -01111111-
           clc                 ; clear carry
           bra   LBBAA         ; branch

SimulateMapReadingFromTps:
           ldab  EngineRpm_HB    ; load B with memory contents
           cmpb  #0x7e         ;  -01111110-
           ldaa  #0x00         ; load a with value -00000000-
           bcc   LBC04         ; branch if greater or equal
           subb  #0x10         ;  -00010000-
           bcc   LBBF5         ; branch if greater or equal
           clrb                ; b = 0
   LBBF5:  ldaa  #0x52         ; load a with value -01010010-
           mul                 ; multiply (D=A*B)
           adca  MINTHR_LowestSessionTPS
           tab                 ; B = A
           ldaa  TPSVolts      ; load A with memory contents
           adda  THROFF_OffsetAddedToCalcThrottle    ;  (data is 0b)
           sba                 ; subtract (A=A-B)
           bcc   LBC04         ; branch if greater or equal
           clra                ; A = 0
   LBC04:  ldx   #LMPINN_LimpinTableForMapFromThrottle    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  Temp0         ; store A into memory
           ldaa  CoolantTemp    ; load A with memory contents
           ldx   #MPLMOF_OffsetForCalcMapInMapLimpin    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           adda  Temp0     
           bcc   LBC1A         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   LBC1A:  staa  Temp0         ; store A into memory
           ldaa  BaroPressure    ; load A with memory contents
           ldx   #BAROFF_OffsetSubtractedFromCalcMAP    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           ldaa  Temp0         ; load A with memory contents
           sba                 ; subtract (A=A-B)
           bcc   LBC2A         ; branch if greater or equal
           clra                ; A = 0
   LBC2A:  rts                 ; return from subroutine

CheckForErrorsAndSetCodes_MM:
           ldaa  Counter_MainLoop    ; load A with memory contents
           bita  #0x1f         ;  -00011111-
           bne   LBC52         ; branch if not equal (not zero)
           brset *BitFlags6F, #b6f_FuelEngineNotRunning, LBC52    ; branch if bit(s) set
           ldaa  BatteryVolts    ; load A with memory contents
           suba  TargetBatteryVolts
           bcs   LBC4F         ; branch if lower
           cmpa  #0x10         ; compare a with value -00010000-
           bcs   LBC4F         ; branch if lower
           brset *b5C_IPL1, #$%00000100, LBC52    ; branch if bit(s) set
           ldd   #0x06a0       ; load D (A&B) with value -00000110 10100000-
           jsr   ThrowNonCriticalError    ; call subroutine
           bcc   LBC52         ; branch if greater or equal
           bset  *b5C_IPL1, #$%00000100    ; set bits
           rts                 ; return from subroutine

   LBC4F:  bclr  *b5C_IPL1, #$%00000100    ; clear bits
   LBC52:  rts                 ; return from subroutine

CheckIfCheckEngineLightShouldBeOn_MM:
           ldab  #0x40         ; load B with value -01000000-
           brclr *BitFlags6F, #b6f_FuelEngineNotRunning, LBC73    ; branch if bit(s) clear
           ldaa  DRBPointer1    ; load A with memory contents
           cmpa  #0x0a         ; compare a with value -00001010-
           bne   LBC62         ; branch if not equal (not zero)
           jmp   MUCK_WITH_CEL

   LBC62:  cmpa  #0x18         ; compare a with value -00011000-
           bne   LBC6D         ; branch if not equal (not zero)
           ldaa  Counter_MainLoop    ; load A with memory contents
           lsla                ; logical shift left A
           bmi   TurnCheckEngineLightOnAndOff         ; branch if minus(hi bit 1)
           bra   LBC96         ; branch

   LBC6D:  ldaa  KeyOnOrEngineRunningTime    ; load A with memory contents
           bne   TurnCheckEngineLightOnAndOff         ; branch if not equal (not zero)
           bra   LBC96         ; branch

   LBC73:  ldd   KeyOnOrEngineRunningTime    ; load D (A&B) with memory contents
           cpd   #0x0003        ;  -00000000 00000011-
           bls   TurnCheckEngineLightOnAndOff         ; branch if lower or same
           brclr *StartupSwitchMirror2, #$%01000000, LBC9D    ; branch if bit(s) clear
           ldaa  b5C_IPL1      ; load A with memory contents
           bita  IPLMSK_PowerLossLightMask    ;  (data is e7)
           bne   LBC96         ; branch if not equal (not zero)
           ldx   #CONFIG_ConfigurationFlags    ; load index with value
           ldaa  b5D_IPL2      ; load A with memory contents
           brset 0x00, X, #$%01000000, LBC91    ; branch if bit(s) set -00000000-
           anda  #0x3f         ; AND a with value -00111111-
   LBC91:  bita  IPLMSK2_PowerLossLightMask2    ;  (data is 37)
           beq   TurnCheckEngineLightOnAndOff         ; branch if equal (zero)
   LBC96:  bclr  *StartupSwitchMirror2, #$%01000000    ; clear bits
           rts                 ; return from subroutine

TurnCheckEngineLightOnAndOff:
           bset  *StartupSwitchMirror2, #$%01000000    ; set bits
   LBC9D:  rts                 ; return from subroutine

UpdateErrorTimersAndPossiblyClearErrors_MM:
           ldaa  Counter_MainLoop    ; load A with memory contents
           bne   LBCC7         ; branch if not equal (not zero)
           ldd   ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB    ; load D (A&B) with memory contents
           tsta                ; test A
           beq   LBCAF         ; branch if equal (zero)
           dec   ClearTheErrorTimer_0    ; decrement memory contents
           bne   LBCAF         ; branch if not equal (not zero)
           clr   ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB    ; zero byte at memory location
   LBCAF:  tstb                ; test B
           beq   LBCBA         ; branch if equal (zero)
           dec   ClearTheErrorTimer_1    ; decrement memory contents
           bne   LBCBA         ; branch if not equal (not zero)
           clr   ErrorBitsAssociatedWithPIA1AndReg1eTo25_LB    ; zero byte at memory location
   LBCBA:  ldaa  ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; load A with memory contents
           beq   LBCC7         ; branch if equal (zero)
           suba  #0x10         ;  -00010000-
           bita  #0xf0         ;  -11110000-
           bne   LBCC5         ; branch if not equal (not zero)
           clra                ; A = 0
   LBCC5:  staa  ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; store A into memory
   LBCC7:  ldaa  BitFlags6F    ; load A with memory contents
           bita  #0x81         ;  -10000001-
           bne   LBD01         ; branch if not equal (not zero)
           bset  *BitFlags6F, #b6f_NeedSetup    ; set bits
           brclr *ErrorBitRegisterStored3, #$%11111111, LBCFA    ; branch if bit(s) clear
           ldaa  ErrorCodeUpdateKeyOnCount    ; load A with memory contents
           cmpa  #0x32         ; compare a with value -00110010-
           bcs   LBCE4         ; branch if lower
           ldaa  CPU_EEPROMControlReg    ; load A with memory contents
           bita  #0x01         ;  -00000001-
           bne   LBD01         ; branch if not equal (not zero)
           jmp   EraseErrorCodes

   LBCE4:  ldaa  ErrorBitRegisterStored1    ; load A with memory contents
           beq   LBCEF         ; branch if equal (zero)
           ldaa  ErrorCodeUpdateKeyOnCount3    ; load A with memory contents
           inca                ; increment A
           beq   LBCEF         ; branch if equal (zero)
           staa  ErrorCodeUpdateKeyOnCount3    ; store A into memory
   LBCEF:  ldaa  ErrorBitRegisterStored2    ; load A with memory contents
           beq   LBCFA         ; branch if equal (zero)
           ldaa  ErrorCodeUpdateKeyOnCount2    ; load A with memory contents
           inca                ; increment A
           beq   LBCFA         ; branch if equal (zero)
           staa  ErrorCodeUpdateKeyOnCount2    ; store A into memory
   LBCFA:  ldaa  ErrorCodeUpdateKeyOnCount    ; load A with memory contents
           inca                ; increment A
           beq   LBD01         ; branch if equal (zero)
           staa  ErrorCodeUpdateKeyOnCount    ; store A into memory
   LBD01:  rts                 ; return from subroutine

DetectAlternatorFault_MM:
           brset *BitFlags6F, #b6f_FuelEngineNotRunning, LBD50    ; branch if bit(s) set
           ldaa  CoolantTemp    ; load A with memory contents
           cmpa  ERRTMP_CoolantTempLimitforErrorCodeSetting    ; compare A with memory contents (data is a0)
           bcs   LBD50         ; branch if lower
           brclr *BitFlags37, #bf37_ATX, LBD15    ; branch if bit(s) clear
           brclr *BitFlags_AIS, #$%00001000, LBD50    ; branch if bit(s) clear
   LBD15:  ldd   KeyOnOrEngineRunningTime    ; load D (A&B) with memory contents
           cmpa  #0x0b         ; compare a with value -00001011-
           bcs   LBD50         ; branch if lower
           bitb  #0x1f         ;  -00011111-
           bne   LBD50         ; branch if not equal (not zero)
           brset *StartupSwitchMirror1, #$%00100000, LBD50    ; branch if bit(s) set
           brclr *BitFlags66, #b66_OffIdle, LBD50    ; branch if bit(s) clear
           ldaa  EngineRpm_HB    ; load A with memory contents
           cmpa  ERRRPM_RPMLimitforErrorCodeSetting    ; compare A with memory contents (data is 38)
           bcs   LBD50         ; branch if lower
           ldaa  BaroPressure    ; load A with memory contents
           suba  MapValue  
           bcc   LBD35         ; branch if greater or equal
           clra                ; A = 0
   LBD35:  cmpa  ERRMAP_MAPLimitforErrorCodeSetting    ; compare A with memory contents (data is 2b)
           bcc   LBD50         ; branch if greater or equal
           ldd   VehicleSpeed_HB    ; load D (A&B) with memory contents
           cpd   #Cyl3_InjPWTrim    ;  -00000000 00101010-
           bcc   LBD50         ; branch if greater or equal
           ldd   #0x2320       ; load D (A&B) with value -00100011 00100000-
           jsr   ThrowCriticalError    ; call subroutine
           bcc   LBD50         ; branch if greater or equal
           bset  *b5D_IPL2, #$%01000000    ; set bits
           bset  *BitFlags6B, #$%00100000    ; set bits
   LBD50:  rts                 ; return from subroutine

ThrowMajorErrorIfRequired_MM:
           ldaa  CONFIG_ConfigurationFlags    ; load A with memory contents (data is 92)
           bita  #0x40         ;  -01000000-
           beq   LBD60         ; branch if equal (zero)
           brclr *BitFlags71, #b71_BadO2, LBD63    ; branch if bit(s) clear
           bset  *b5D_IPL2, #$%01000000    ; set bits
           rts                 ; return from subroutine

   LBD60:  bclr  *b5D_IPL2, #$%11000000    ; clear bits
   LBD63:  rts                 ; return from subroutine

NULL_ROUTINE:
           rts                 ; return from subroutine

EmmissionMaintenanceRemider1_MM:
           bset  *StartupSwitchMirror2, #$%00001000    ; set bits
           ldaa  CPU_EEPROMControlReg    ; load A with memory contents
           bne   LBD73         ; branch if not equal (not zero)
           ldd   LB610         ;  (data is ffff)
           subd  #0x5aa5       ;  -01011010 10100101-
   LBD73:  brclr *BitFlags6F, #b6f_FuelEngineNotRunning, LBD79    ; branch if bit(s) clear
           ldaa  KeyOnOrEngineRunningTime    ; load A with memory contents
   LBD79:  bne   LBD7E         ; branch if not equal (not zero)
           bclr  *StartupSwitchMirror2, #$%00001000    ; clear bits
   LBD7E:  sei                 ; disable interrupts
           brset *BitFlags70, #$%00000001, LBDAC    ; branch if bit(s) set
           brset *BitFlags71, #$%00000010, LBDAE    ; branch if bit(s) set
           brclr *BitFlags71, #$%00000001, LBDAC    ; branch if bit(s) clear
           bset  *BitFlags70, #$%00000001    ; set bits
           cli                 ; enable interrupts
           ldaa  #0x10         ; load a with value -00010000-
           ldab  #0x5a         ; load B with value -01011010-
           brclr *BitFlags70, #$%00000010, LBDA5    ; branch if bit(s) clear
           cmpa  DRBOffsetStored_HB    ; compare A with memory contents
           bne   LBE04         ; branch if not equal (not zero)
           inca                ; increment A
           comb                ; 1's complement B
           bclr  *BitFlags70, #$%00000010    ; clear bits
           bclr  *BitFlags71, #$%00000001    ; clear bits
           bra   LBDA8         ; branch

   LBDA5:  bset  *BitFlags70, #$%00000010    ; set bits
   LBDA8:  staa  DRBOffsetStored_HB    ; store A into memory
           stab  DRBOffsetStored_LB    ; store B into memory
   LBDAC:  cli                 ; enable interrupts
           rts                 ; return from subroutine

   LBDAE:  bset  *BitFlags70, #$%00000001    ; set bits
           cli                 ; enable interrupts
           brset *BitFlags70, #$%00000010, LBE1C    ; branch if bit(s) set
           ldx   #ErrorBitRegisterStored3    ; load index with value
           ldab  #0x30         ; load B with value -00110000-
   LBDBB:  ldaa  0x00, X      ; load A with memory at index + value -00000000-
           beq   LBDC8         ; branch if equal (zero)
           cba                 ; compare A to B
           beq   LBE01         ; branch if equal (zero)
           deX                 ; decrement index (I=I-1)
           cpx   #ErrorBitRegister0    ;  -00000000 00011101-
           bcc   LBDBB         ; branch if greater or equal
   LBDC8:  clra                ; A = 0
           clrb                ; b = 0
           std   Temp0         ; store D (A&B) into memory
           ldx   #LB600        ; load index with value
   LBDCF:  ldd   0x02, X      ;  -00000010-
           cpx   #0xb60e       ;  -10110110 00001110-
           bne   LBDD9         ; branch if not equal (not zero)
           ldd   LB600         ;  (data is ffff)
   LBDD9:  subd  0x00, X      ;  -00000000-
           subd  #0x0001        ;  -00000000 00000001-
           bne   LBDEE         ; branch if not equal (not zero)
           incb                ; increment B
           addd  0x00, X      ;  -00000000-
           cpd   Temp0         ; D = D - memory contents
           bcs   LBDEE         ; branch if lower
           std   Temp0         ; store D (A&B) into memory
           xgdx                ; exchange D and index
           stab  DRBOffsetStored_HB    ; store B into memory
           xgdx                ; exchange D and index
   LBDEE:  inX                 ; increment index (I=I+1)
           inX                 ; increment index (I=I+1)
           cpx   #LB610        ;  -10110110 00010000-
           bne   LBDCF         ; branch if not equal (not zero)
           ldx   Temp0     
           bne   LBE08         ; branch if not equal (not zero)
           ldd   #0x3003       ; load D (A&B) with value -00110000 00000011-
           jsr   ThrowNonCriticalError    ; call subroutine
           bcc   LBE04         ; branch if greater or equal
   LBE01:  bclr  *BitFlags71, #$%00000010    ; clear bits
   LBE04:  bclr  *BitFlags70, #$%00000001    ; clear bits
           rts                 ; return from subroutine

   LBE08:  ldab  DRBOffsetStored_HB    ; load B with memory contents
           addb  #0x04         ;  -00000100-
           cmpb  #0x10         ;  -00010000-
           blt   LBE12         ; branch if less
           subb  #0x10         ;  -00010000-
   LBE12:  stab  DRBOffsetStored_HB    ; store B into memory
           bsr   LBE47         ; call subroutine
           staa  DRBOffsetStored_LB    ; store A into memory
           bset  *BitFlags70, #$%00000010    ; set bits
           rts                 ; return from subroutine

   LBE1C:  ldab  DRBOffsetStored_HB    ; load B with memory contents
           cmpb  #0x0e         ;  -00001110-
           bhi   LBE04         ; branch if higher
           cmpb  #0x00         ;  -00000000-
           bcs   LBE04         ; branch if lower
           bsr   LBE47         ; call subroutine
           stab  DRBOffsetStored_LB    ; store B into memory
           inc   DRBOffsetStored_HB
           bclr  *BitFlags71, #$%00000010    ; clear bits
           bclr  *BitFlags70, #$%00000010    ; clear bits
           xgdx                ; exchange D and index
           cpx   #0x1c9c       ;  -00011100 10011100-
           beq   LBE43         ; branch if equal (zero)
           cpx   #0x2757       ;  -00100111 01010111-
           beq   LBE43         ; branch if equal (zero)
           cpx   #0x3938       ;  -00111001 00111000-
           bne   LBE46         ; branch if not equal (not zero)
   LBE43:  bset  *BitFlags71, #$%00000001    ; set bits
   LBE46:  rts                 ; return from subroutine

   LBE47:  ldx   #LB600        ; load index with value
           subb  #0x02         ;  -00000010-
           cmpb  #0x00         ;  -00000000-
           bge   LBE52         ; branch if greater or equal
           ldab  #0x0e         ; load B with value -00001110-
   LBE52:  abx                 ; add B to index
           ldx   0x00, X      ;  -00000000-
           inX                 ; increment index (I=I+1)
           bne   LBE59         ; branch if not equal (not zero)
           deX                 ; decrement index (I=I-1)
   LBE59:  xgdx                ; exchange D and index
           rts                 ; return from subroutine

EmmissionMaintenanceRemider2_MM:
           brset *Counter_MainLoop, #$%00000001, LBECC    ; branch if bit(s) set
           brclr *BitFlags70, #$%00000001, LBEC8    ; branch if bit(s) clear
           ldaa  CountdownTimerFromKeyOn    ; load A with memory contents
           beq   LBE6E         ; branch if equal (zero)
           ldab  #0x03         ; load B with value -00000011-
           cba                 ; compare A to B
           bcc   LBE6E         ; branch if greater or equal
           stab  CountdownTimerFromKeyOn    ; store B into memory
   LBE6E:  ldaa  CPU_EEPROMControlReg    ; load A with memory contents
           clrb                ; b = 0
           stab  CPU_EEPROMControlReg    ; store B into memory
           ldx   #LB600        ; load index with value
           ldab  DRBOffsetStored_HB    ; load B with memory contents
           abx                 ; add B to index
           tab                 ; B = A
           ldaa  0x00, X      ; load A with memory at index + value -00000000-
           cmpa  DRBOffsetStored_LB    ; compare A with memory contents
           beq   LBEB8         ; branch if equal (zero)
           cmpb  #0x03         ;  -00000011-
           beq   LBE8D         ; branch if equal (zero)
           bcs   LBE9E         ; branch if lower
           ldab  DRBOffsetStored_LB    ; load B with memory contents
           inca                ; increment A
           beq   LBEAE         ; branch if equal (zero)
   LBE8D:  brset *b5D_IPL2, #$%00001000, LBEB8    ; branch if bit(s) set
           ldd   #0x318a       ; load D (A&B) with value -00110001 10001010-
           jsr   ThrowNonCriticalError    ; call subroutine
           bcc   LBE9E         ; branch if greater or equal
           bset  *b5D_IPL2, #$%00001000    ; set bits
           bra   LBEB8         ; branch

   LBE9E:  ldx   #LB600        ; load index with value
           ldab  DRBOffsetStored_HB    ; load B with memory contents
           abx                 ; add B to index
           ldab  DRBOffsetStored_LB    ; load B with memory contents
           tba                 ; A = B
           anda  0x00, X      ;  -00000000-
           sba                 ; subtract (A=A-B)
           beq   LBEAE         ; branch if equal (zero)
           ldaa  #0x16         ; load a with value -00010110-
   LBEAE:  oraa  #0x02         ;  -00000010-
           staa  CPU_EEPROMControlReg
           stab  0x00, X      ;  -00000000-
           inca                ; increment A
           bra   LBEC9         ; branch

   LBEB8:  bclr  *BitFlags70, #$%00000001    ; clear bits
           brset *BitFlags70, #$%00000010, LBEC8    ; branch if bit(s) set
           ldaa  CountdownTimerFromKeyOn    ; load A with memory contents
           suba  #0x03         ;  -00000011-
           bne   LBEC8         ; branch if not equal (not zero)
           inca                ; increment A
           staa  CountdownTimerFromKeyOn    ; store A into memory
   LBEC8:  clra                ; A = 0
   LBEC9:  staa  CPU_EEPROMControlReg
   LBECC:  rts                 ; return from subroutine

ExhGasRecirc_MM:
           ldx   #CODE13_      ; load index with value
           brclr 0x00, X, #$%00010000, LBED5    ; branch if bit(s) clear -00000000-
           rts                 ; return from subroutine

   LBED5:  ldaa  CONFIG_ConfigurationFlags    ; load A with memory contents (data is 92)
           bita  #0x40         ;  -01000000-
           bne   LBEDF         ; branch if not equal (not zero)
           jmp   LC008     

   LBEDF:  brclr *BitFlags6F, #b6f_FuelEngineNotRunning, LBEF2    ; branch if bit(s) clear
           ldaa  CoolantTemp    ; load A with memory contents
           cmpa  EGR27_ExhGasRecircConstFromCoolantTemp    ; compare A with memory contents (data is 82)
           bcc   LBEEF         ; branch if greater or equal
           bclr  *EGRVar2, #$%00100000    ; clear bits
           bra   LBEF2         ; branch

   LBEEF:  bset  *EGRVar2, #$%00100000    ; set bits
   LBEF2:  ldab  BitFlags66    ; load B with memory contents
           bitb  #0x03         ;  -00000011-
           bne   LBF39         ; branch if not equal (not zero)
           ldab  BaroPressure    ; load B with memory contents
           brset *PIA2_Buffer, #$%00000010, LBF01    ; branch if bit(s) set
           subb  EGR26_ExhGasRecircConstFromBaro2    ; subtract memory contents from B (data is 01)
   LBF01:  subb  EGR25_ExhGasRecircConstFromBaro1    ; subtract memory contents from B (data is ff)
           cmpb  MapValue
           bcs   LBF39         ; branch if lower
           brset *EGRVar2, #$%00100000, LBF15    ; branch if bit(s) set
           brset *BitFlags67, #b67_OpenLoop, LBF39    ; branch if bit(s) set
           bset  *EGRVar2, #$%00100000    ; set bits
           bra   LBF1D         ; branch

   LBF15:  brset *BitFlags66, #b66_O2Valid, LBF1D    ; branch if bit(s) set
           ldab  Timer_CLTIME_ClosedLoopTimer    ; load B with memory contents
           bne   LBF39         ; branch if not equal (not zero)
   LBF1D:  brclr *BitFlags66, #b66_OffIdle, LBF39    ; branch if bit(s) clear
           ldaa  EGR21_ExhGasRecircConstFromRPM1    ; load A with memory contents (data is fe)
           ldab  EGR23_ExhGasRecircConstFromMAP1    ; load B with memory contents (data is ee)
           brset *PIA2_Buffer, #$%00000010, LBF31    ; branch if bit(s) set
           adda  EGR22_ExhGasRecircConstFromRPM2    ;  (data is 01)
           addb  EGR24_ExhGasRecircConstFromMAP2    ;  (data is 01)
   LBF31:  cmpa  EngineRpm_HB    ; compare A with memory contents
           bls   LBF3F         ; branch if lower or same
           cmpb  MapValue  
           bcs   LBF3F         ; branch if lower
   LBF39:  bset  *EGRVar2, #$%00010000    ; set bits
           jmp   EGR_SetEGRtoOff

   LBF3F:  ldaa  KeyOnOrEngineRunningTime    ; load A with memory contents
           cmpa  EGR9_ExhGasRecircConstFromTimeEngRunning9    ; compare A with memory contents (data is 83)
           bcs   LBF56         ; branch if lower
           brset *EGRVar2, #$%01000000, LBF56    ; branch if bit(s) set
           brset *EGRVar2, #$%00010000, LBF56    ; branch if bit(s) set
           brclr *BitFlags66, #b66_O2Valid, LBF56    ; branch if bit(s) clear
           brclr *BitFlags67, #b67_StayOpenLoop, LBF59    ; branch if bit(s) clear
   LBF56:  jmp   EGR_ResetEGRVars

   LBF59:  ldd   IPLMSK_PowerLossLightMask    ;  (data is e737)
           bita  b5C_IPL1  
           bne   EGR_ResetEGRVars    ; branch if not equal (not zero)
           bitb  b5D_IPL2  
           bne   EGR_ResetEGRVars    ; branch if not equal (not zero)
           brclr *PIA2_Buffer, #$%00100000, EGR_ResetEGRVars    ; branch if bit(s) clear
           ldaa  BaroPressure    ; load A with memory contents
           suba  MapValue  
           bcs   EGR_ResetEGRVars    ; branch if lower
           cmpa  EGR2_ExhGasRecircConstFromMAPBelowBaro    ; compare A with memory contents (data is 0d)
           bcs   EGR_ResetEGRVars    ; branch if lower
           ldaa  MapValue      ; load A with memory contents
           ldx   #EGR18_ExhGasRecircConstLoLimit    ; load index with value
           bsr   EGR_CheckHiLoLimits    ; call subroutine
           ldaa  TPSVolts      ; load A with memory contents
           suba  MINTHR_LowestSessionTPS
           bls   EGR_ResetEGRVars    ; branch if lower or same
           ldx   #EGR14_ExhGasRecircConstFromTPSVoltsLoLimit14    ; load index with value
           bsr   EGR_CheckHiLoLimits    ; call subroutine
           ldaa  EngineRpm_HB    ; load A with memory contents
           ldx   #EGR15_ExhGasRecircConstFromRPMLoLimit15    ; load index with value
           bsr   EGR_CheckHiLoLimits    ; call subroutine
           ldaa  Counter_O2SensorFeedbackCount_Signed    ; load A with memory contents
           cmpa  EGR3_ExhGasRecircConst3    ; compare A with memory contents (data is 80)
           bge   EGR_ResetEGRVars    ; branch if greater or equal
           ldab  EGR8_ExhGasRecircConst8    ; load B with memory contents (data is 81)
           suba  EGR_Temp_1
           bvc   LBFAA         ; branch if overflow
           bmi   LBFAC         ; branch if minus(hi bit 1)
   LBF9D:  nega                ; negate A (set high bit)
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           nega                ; negate A (set high bit)
   LBFA2:  adda  EGR_Temp_1
           staa  EGR_Temp_1
           bra   LBFC6         ; branch

   LBFAA:  bmi   LBF9D         ; branch if minus(hi bit 1)
   LBFAC:  mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           bra   LBFA2         ; branch

EGR_CheckHiLoLimits:
           cmpa  0x00, X      ; compare A with memory at index + value -00000000-
           bcs   LBFBA         ; branch if lower
           cmpa  0x01, X      ; compare A with memory at index + value -00000001-
           bhi   LBFBA         ; branch if higher
           rts                 ; return from subroutine

   LBFBA:  pulx                ; pull index from stack
EGR_ResetEGRVars:
           ldd   #0x0000        ; load D (A&B) with value -00000000 00000000-
           bclr  *EGRVar2, #$%10010000    ; clear bits
           ldaa  Counter_O2SensorFeedbackCount_Signed    ; load A with memory contents
           staa  EGR_Temp_1
   LBFC6:  jmp   EGR_SetEGRtoOn

   LBFC9:  ldx   #0x0000        ; load index with value
           bset  *EGRVar2, #$%10000000    ; set bits
           ldaa  EGR_Temp_1    ; load A with memory contents
           staa  EGR_Temp_2
           bra   LBFDC         ; branch

   LBFD7:  cpx   EGR6_ExhGasRecircConst6    ;  -10000100 00010000-
           bcc   LC016         ; branch if greater or equal
   LBFDC:  inX                 ; increment index (I=I+1)
           ldaa  MapValue      ; load A with memory contents
           ldx   #EGR16_ExhGasRecircConstLoLimit16    ; load index with value
           bsr   EGR_CheckHiLoLimits    ; call subroutine
           ldaa  TPSVolts      ; load A with memory contents
           suba  MINTHR_LowestSessionTPS
           bls   EGR_ResetEGRVars    ; branch if lower or same
           ldx   #EGR19_ExhGasRecircConstLoLimit19    ; load index with value
           bsr   EGR_CheckHiLoLimits    ; call subroutine
           ldaa  EngineRpm_HB    ; load A with memory contents
           ldx   #EGR17a_ExhGasRecircConstHiLimit17a    ; load index with value
           bsr   EGR_CheckHiLoLimits    ; call subroutine
           ldaa  Counter_O2SensorFeedbackCount_Signed    ; load A with memory contents
           cmpa  EGR_Temp_2    ; compare A with memory contents
           ble   LC042         ; branch if less or equal
           staa  EGR_Temp_2
           suba  EGR_Temp_1
           cmpa  EGR7_ExhGasRecircConst7    ; compare A with memory contents (data is 00)
           bcs   LC042         ; branch if lower
   LC008:  clr   ErrorCodeCounter    ; zero byte at memory location
           bset  *EGRVar2, #$%01000000    ; set bits
           bclr  *EGRVar2, #$%10000000    ; clear bits
           bclr  *b5D_IPL2, #$%10000000    ; clear bits
           bra   EGR_SetEGRtoOn    ; branch

   LC016:  ldd   #0x0000        ; load D (A&B) with value -00000000 00000000-
           ldaa  ErrorCodeCounter    ; load A with memory contents
           inca                ; increment A
           staa  ErrorCodeCounter
           cmpa  EGR4_ExhGasRecircConst4    ; compare A with memory contents (data is eb)
           bcs   LC02E         ; branch if lower
           ldd   #0x2e01       ; load D (A&B) with value -00101110 00000001-
           jsr   ThrowNonCriticalError    ; call subroutine
           bset  *b5D_IPL2, #$%10000000    ; set bits
   LC02E:  ldab  EGRVar2       ; load B with memory contents
           andb  #0x7f         ;  -01111111-
           tba                 ; A = B
           inca                ; increment A
           anda  #0x0f         ; AND a with value -00001111-
           beq   LC03E         ; branch if equal (zero)
           incb                ; increment B
           cmpa  EGR5_ExhGasRecircConst5    ; compare A with memory contents (data is 00)
           bcs   LC040         ; branch if lower
   LC03E:  orab  #0x40         ;  -01000000-
   LC040:  stab  EGRVar2       ; store B into memory
   LC042:  brclr *EGRVar2, #$%10000000, EGR_SetEGRtoOn    ; branch if bit(s) clear
EGR_SetEGRtoOff:
           bclr  *PIA2_Buffer, #$%00000010    ; clear bits
           rts                 ; return from subroutine

EGR_SetEGRtoOn:
           bset  *PIA2_Buffer, #$%00000010    ; set bits
           rts                 ; return from subroutine

BYTE_MODE_SERIAL_CODE_DOWNLOAD_ROUTINE:
           brset *DRBSerialMode, #$%01000000, LC056    ; branch if bit(s) set
           rts                 ; return from subroutine

   LC053:  jmp   LC1FC     

   LC056:  brset *DRBSerialMode, #$%01110000, LC053    ; branch if bit(s) set
           ldab  CPU_SerialData    ; load B with memory contents
           ldaa  CPU_SerialStatus    ; load A with memory contents
           bita  #0x20         ;  -00100000-
           bne   LC065         ; branch if not equal (not zero)
           rts                 ; return from subroutine

   LC065:  ldx   #FDRVar0      ; load index with value
           ldaa  0x00, X      ; load A with memory at index + value -00000000-
           bita  #0x03         ;  -00000011-
           beq   LC071         ; branch if equal (zero)
           jmp   LC0D3

   LC071:  cmpb  #0xf8         ;  -11111000-
           bcc   LC07C         ; branch if greater or equal
   LC075:  jsr   NULL_ROUTINE    ; call subroutine
           jsr   LC201         ; call subroutine
           rts                 ; return from subroutine

   LC07C:  tsta                ; test A
           bne   LC088         ; branch if not equal (not zero)
           cmpb  #0xf8         ;  -11111000-
           bne   LC075         ; branch if not equal (not zero)
           ldaa  #0x80         ; load a with value -10000000-
           jmp   LC1FA     

   LC088:  cmpa  #0x80         ; compare a with value -10000000-
           bne   LC095         ; branch if not equal (not zero)
           cmpb  #0xf9         ;  -11111001-
           bne   LC075         ; branch if not equal (not zero)
           ldaa  #0xc0         ; load a with value -11000000-
           jmp   LC1FA     

   LC095:  cmpa  #0xc0         ; compare a with value -11000000-
           bne   LC0A2         ; branch if not equal (not zero)
           cmpb  #0xfb         ;  -11111011-
           bne   LC075         ; branch if not equal (not zero)
           ldaa  #0xe0         ; load a with value -11100000-
           jmp   LC1FA     

   LC0A2:  cmpa  #0xe0         ; compare a with value -11100000-
           bne   LC075         ; branch if not equal (not zero)
           cmpb  #0xf8         ;  -11111000-
           bne   LC0AF         ; branch if not equal (not zero)
           ldaa  #0x02         ; load a with value -00000010-
           jmp   LC1FA     

   LC0AF:  cmpb  #0xf9         ;  -11111001-
           bne   LC0B8         ; branch if not equal (not zero)
           ldaa  #0x01         ; load a with value -00000001-
           jmp   LC1FA     

   LC0B8:  cmpb  #0xfb         ;  -11111011-
           bne   LC075         ; branch if not equal (not zero)
           ldy   EngineRpm_HB
           cpy   #0x0100       ;  -00000001 00000000-
           bhi   LC0CA         ; branch if higher
           ldaa  #0x05         ; load a with value -00000101-
           jmp   LC1FA     

   LC0CA:  ldd   #AutoCalCell8    ; load D (A&B) with value -00000000 00010111-
           jsr   LC201         ; call subroutine
           jmp   LC1FA

   LC0D3:  bita  #0x01         ;  -00000001-
           beq   LC0DA         ; branch if equal (zero)
           jmp   LC0DD     

   LC0DA:  jmp   LC18C     

   LC0DD:  lsla                ; logical shift left A
           bcs   LC134         ; branch if lower
           lsla                ; logical shift left A
           bcs   LC105         ; branch if lower
           lsla                ; logical shift left A
           bcs   LC0FA         ; branch if lower
           lsla                ; logical shift left A
           bcs   LC0F0         ; branch if lower
           stab  FDRVar4       ; store B into memory
           ldaa  #0x10         ; load a with value -00010000-
           bra   LC12F         ; branch

   LC0F0:  stab  FDRVar3       ; store B into memory
           jsr   LC211         ; call subroutine
           ldaa  #0x20         ; load a with value -00100000-
           bra   LC12F         ; branch

   LC0FA:  ldy   FDRVar3   
           ldab  0x00, Y      ; load B with memory at index + value -00000000-
           ldaa  #0x40         ; load a with value -01000000-
           bra   LC12F         ; branch

   LC105:  cmpb  #0xfe         ;  -11111110-
           beq   LC116         ; branch if equal (zero)
   LC109:  jsr   LC201         ; call subroutine
           cmpb  #0x1b         ;  -00011011-
           bne   LC113         ; branch if not equal (not zero)
           bset  *DRBSerialMode, #$%01000000    ; set bits
   LC113:  jmp   LC1FC     

   LC116:  ldaa  0x00, X      ; load A with memory at index + value -00000000-
           bita  #0x04         ;  -00000100-
           beq   LC12D         ; branch if equal (zero)
           ldy   EngineRpm_HB
           cpy   #0x0100       ;  -00000001 00000000-
           bcs   LC12D         ; branch if lower
           ldab  #0x17         ; load B with value -00010111-
           jsr   LC201         ; call subroutine
           jmp   LC1FC     

   LC12D:  ldaa  #0x80         ; load a with value -10000000-
   LC12F:  oraa  0x00, X      ;  -00000000-
           jmp   LC1FA     

   LC134:  sei                 ; disable interrupts
           ldy   FDRVar3   
   LC139:  cpy   #ControlAirConditioning_MM    ;  -10010100 00000000-
           bcc   LC14C         ; branch if greater or equal
           stab  0x00, Y      ;  -00000000-
   LC142:  ldab  0x00, Y      ; load B with memory at index + value -00000000-
           jsr   LC201         ; call subroutine
           cli                 ; enable interrupts
           jmp   LC1FC     

   LC14C:  ldx   #0x60d0       ; load index with value
           ldy   #LC16F        ; load index with value
   LC153:  ldaa  0x00, Y      ; load A with memory at index + value -00000000-
           staa  0x00, X      ;  -00000000-
           inX                 ; increment index (I=I+1)
           inY                 ; increment index (I=I+1)
           cpy   #LC18C        ;  -11000001 10001100-
           bne   LC153         ; branch if not equal (not zero)
           ldx   #0x60d0       ; load index with value
           ldy   FDRVar3   
           jsr   0x00, X      ;  -00000000-
           ldx   #FDRVar0      ; load index with value
           bra   LC142         ; branch

   LC16F:  ldaa  #0xaa         ; load a with value -10101010-
           staa  0xD555         ;  (data is 02)
           lsra                ; logic shift right A
           staa  0xAAAA         ;  (data is f7)
           ldaa  #0xa0         ; load a with value -10100000-
           staa  0xD555         ;  (data is 02)
           stab  0x00, Y      ;  -00000000-
           ldx   #0x0000        ; load index with value
   LC183:  cmpb  0x00, Y      ;  -00000000-
           beq   LC18B         ; branch if equal (zero)
           deX                 ; decrement index (I=I-1)
           bne   LC183         ; branch if not equal (not zero)
   LC18B:  rts                 ; return from subroutine

   LC18C:  lsla                ; logical shift left A
           bcs   LC1C8         ; branch if lower
           lsla                ; logical shift left A
   LC190:  bcs   LC1BA         ; branch if lower
           lsla                ; logical shift left A
           bcs   LC1B0         ; branch if lower
           lsla                ; logical shift left A
           bcs   LC1A9         ; branch if lower
           lsla                ; logical shift left A
           bcs   LC1A2         ; branch if lower
           stab  FDRVar2       ; store B into memory
           ldaa  #0x08         ; load a with value -00001000-
           bra   LC1C3         ; branch

   LC1A2:  stab  FDRVar1       ; store B into memory
           ldaa  #0x10         ; load a with value -00010000-
           bra   LC1C3         ; branch

   LC1A9:  stab  FDRVar4       ; store B into memory
           ldaa  #0x20         ; load a with value -00100000-
           bra   LC1C3         ; branch

   LC1B0:  stab  FDRVar3       ; store B into memory
           jsr   LC211         ; call subroutine
           ldaa  #0xc0         ; load a with value -11000000-
           bra   LC1C3         ; branch

   LC1BA:  cmpb  #0xfd         ;  -11111101-
           beq   LC1C1         ; branch if equal (zero)
           jmp   LC109     

   LC1C1:  ldaa  #0x80         ; load a with value -10000000-
   LC1C3:  oraa  0x00, X      ;  -00000000-
           jmp   LC1FA

   LC1C8:  ldx   FDRVar3   
           ldy   FDRVar1   
           ldab  CPU_SerialData    ; load B with memory contents
           ldaa  0x00, X      ; load A with memory at index + value -00000000-
           staa  CPU_SerialData
           inX                 ; increment index (I=I+1)
           deY                 ; decrement index (I=I-1)
           bne   LC1E4         ; branch if not equal (not zero)
           ldx   #FDRVar0      ; load index with value
           jsr   LC201         ; call subroutine
           pulx                ; pull index from stack
           rts                 ; return from subroutine

   LC1E4:  stx   FDRVar3   
           sty   FDRVar1   
           cba                 ; compare A to B
           bne   LC1F0         ; branch if not equal (not zero)
           pulx                ; pull index from stack
           rts                 ; return from subroutine

   LC1F0:  ;.byte 0xb6, 0x00, 0xf6 ; FIXME
           ldaa  FDRVar0       ; load A with memory contents
           anda  #0x7f         ; AND a with value -01111111-
           ;.byte 0xb7, 0x00, 0xf6 ; FIXME
           staa  FDRVar0       ;
           pulx                ; pull index from stack
           rts                 ; return from subroutine

   LC1FA:  staa  0x00, X      ;  -00000000-
   LC1FC:  jsr   EchoSerialData    ; call subroutine
           pulx                ; pull index from stack
           rts                 ; return from subroutine

   LC201:  clr   0x00, X       ; clear memory
           bclr  *DRBSerialMode, #$%01000000    ; clear bits
           rts                 ; return from subroutine

EchoSerialData:
           ldaa  CPU_SerialStatus    ; load A with memory contents
           ldaa  CPU_SerialData    ; load A with memory contents
           stab  CPU_SerialData    ; store B into memory
           rts                 ; return from subroutine

   LC211:  pshx                ; pull index from stack
           ldx   FDRVar3
           cpx   #IDENT1_IDCode_1    ;  -10000000 00000000-
           bcs   LC229         ; branch if lower
           cpx   #0xFFFF        ;  -11111111 11111111-
           bhi   LC229         ; branch if higher
           cpx   #0xb600        ;  -10110110 00000000-
           bcs   LC232         ; branch if lower
           cpx   #0xb800        ;  -10111000 00000000-
           bcc   LC232         ; branch if greater or equal
   LC229:  pulx                ; pull index from stack
           ldx   #FDRVar0      ; load index with value
           jsr   LC201         ; call subroutine
           pulx                ; pull index from stack
           rts                 ; return from subroutine

   LC232:  pulx                ; pull index from stack
           rts                 ; return from subroutine

CalculatePartThrottleTransientFuel_MM:
           clra                ; A = 0
           staa  Temp2         ; store A into memory
           staa  Temp3         ; store A into memory
           ldaa  Timer_O2InhibitSwitchingRichIdleToClosedLoop    ; load A with memory contents
           beq   LC240         ; branch if equal (zero)
           deca                ; decrement A
           staa  Timer_O2InhibitSwitchingRichIdleToClosedLoop    ; store A into memory
   LC240:  ldaa  CoolantTemp    ; load A with memory contents
           ldab  MapValue      ; load B with memory contents
           subb  MapAverageValue_HB    ; B = B-memory contents
           stab  Temp0_X       ; store B into memory
           stab  Temp0         ; store B into memory
           bcs   TransFuel_CalculateDecreasingMAPTransientFuel    ; branch if lower
           ldx   #AETIME_EnrichmentTime_FromTemp    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  Factor_LeanoutOrEnrichTime_MAP    ; store A into memory
           clra                ; A = 0
           staa  Factor_DecelLeanoutWhenMAPDecreasing_Temp
           ldaa  CONFIG_ConfigurationFlags    ; load A with memory contents (data is 92)
           bita  #0x02         ;  -00000010-
           beq   TransFuel_CalculateIncreasingMAPTransientFuel    ; branch if equal (zero)
           brset *BitFlags66, #b66_OffIdle, TransFuel_CalculateIncreasingMAPTransientFuel    ; branch if bit(s) set
           jmp   TransFuel_IncludeTPSTransients

TransFuel_CalculateIncreasingMAPTransientFuel:
           ldaa  Temp0         ; load A with memory contents
           suba  MAPTRG_DeltaMapTriggerLevel    ;  (data is 0a)
           bcs   TransFuel_IncludeTPSTransients    ; branch if lower
           cmpa  MAPMAX_MaxDeltaMapAllowed    ; compare A with memory contents (data is 33)
           bcs   LC276         ; branch if lower
           ldaa  MAPMAX_MaxDeltaMapAllowed    ; load A with memory contents (data is 33)
   LC276:  staa  Temp1         ; store A into memory
           ldaa  CoolantTemp    ; load A with memory contents
           ldx   #AESLOP_DeltaMAPEnrichment_FromTemp    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           ldaa  Temp1         ; load A with memory contents
           mul                 ; multiply (D=A*B)
           std   Temp2         ; store D (A&B) into memory
           bra   TransFuel_IncludeTPSTransients    ; branch

TransFuel_CalculateDecreasingMAPTransientFuel:
           ldx   #LMAPTC_TimeConstant    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  Factor_LeanoutOrEnrichTime_MAP    ; store A into memory
           brset *BitFlags66, #b66_FullThrottle, ClearDecelLOMAPFactor    ; branch if bit(s) set
           ldaa  EngineRpm_HB    ; load A with memory contents
           cmpa  LOTRPM_MinRpmForMapLeanout    ; compare A with memory contents (data is 3e)
           bcs   ClearDecelLOMAPFactor         ; branch if lower
           brclr *BitFlags37, #bf37_ATX, LC2A2    ; branch if bit(s) clear
           brclr *BitFlags_AIS, #$%00001000, ClearDecelLOMAPFactor    ; branch if bit(s) clear
   LC2A2:  brclr *KeyOnOrEngineRunningTime, #$%11111111, ClearDecelLOMAPFactor    ; branch if bit(s) clear
           ldd   VehicleSpeed_HB    ; load D (A&B) with memory contents
           cpd   #0x0080    ;  -00000000 10000000-
           bcs   ClearDecelLOMAPFactor         ; branch if lower
           ldaa  Temp0         ; load A with memory contents
           nega                ; negate A (set high bit)
           ldab  Factor_DecelLeanoutWhenMAPDecreasing_Temp    ; load B with memory contents
           beq   LC2B9         ; branch if equal (zero)
           adda  DECHYS_DeltaMapHysteresisonTriggerLevels    ;  (data is 02)
   LC2B9:  cmpa  DECTRG_DeltaMapTriggerForNoIncrementalLeanout    ; compare A with memory contents (data is 04)
           bcs   ClearDecelLOMAPFactor         ; branch if lower
           cmpa  DTRG2_DeltaMapTriggerForMaxLeanout    ; compare A with memory contents (data is 08)
           bcs   LC2D2         ; branch if lower
           ldaa  DCELTM_O2CNTRInhibitAfterLeanoutDone    ; load A with memory contents (data is 01)
           staa  Timer_O2InhibitSwitchingRichIdleToClosedLoop    ; store A into memory
           ldaa  CoolantTemp    ; load A with memory contents
           ldx   #DECEL_DecelLeanoutFactorMAP    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           bra   StoreDecelLOMAPFactor         ; branch

   LC2D2:  tstb                ; test B
           beq   LC2DC         ; branch if equal (zero)
           incb                ; increment B
           bra   StoreDecelLOMAPFactor         ; branch

ClearDecelLOMAPFactor:
           clrb                ; b = 0
StoreDecelLOMAPFactor:
           stab  Factor_DecelLeanoutWhenMAPDecreasing_Temp    ; store B into memory
   LC2DC:  ldaa  Counter_MainLoop    ; load A with memory contents
           bita  #0x07         ;  -00000111-
           bne   TransFuel_IncludeTPSTransients    ; branch if not equal (not zero)
           ldx   #MapAverageValue_HB    ; load index with value
           sei                 ; disable interrupts
           jsr   ProcessMapOrTpsBlockData    ; call subroutine
           cli                 ; enable interrupts
TransFuel_IncludeTPSTransients:
           ldaa  CoolantTemp    ; load A with memory contents
           ldab  TPSVolts      ; load B with memory contents
           subb  TpsAverageValue_HB    ; B = B-memory contents
           stab  Temp1_X       ; store B into memory
           stab  Temp0         ; store B into memory
           bcs   TransFuel_CalculateDecreasingTPSTransientFuel    ; branch if lower
           ldx   #THRTCN_EnrichmentTime_FromTemp    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  Factor_LeanoutOrEnrichTime_TPS    ; store A into memory
           clra                ; A = 0
           staa  Timer_OpenLoopFraction2
           staa  Factor_DecelLeanoutWhenMAPDecreasing    ; store A into memory
           ldaa  Temp0         ; load A with memory contents
           suba  POSTRG_PositiveTransientTriggerLevel    ;  (data is 03)
           bcs   TransFuel_SaveTemp2    ; branch if lower
           cmpa  THRMAX_MaxDeltaTHR    ; compare A with memory contents (data is 22)
           bcs   LC314         ; branch if lower
           ldaa  THRMAX_MaxDeltaTHR    ; load A with memory contents (data is 22)
   LC314:  staa  Temp1         ; store A into memory
           ldaa  CoolantTemp    ; load A with memory contents
           ldx   #POSSLP_DeltaTPSEnrichmentFactor    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           ldaa  Temp1         ; load A with memory contents
           mul                 ; multiply (D=A*B)
           addd  Temp2         ; D = D + memory contents
           bra   TransFuel_SaveD    ; branch

TransFuel_CalculateDecreasingTPSTransientFuel:
           ldx   #LOTIME_DecelLeanoutTimeConstant_FromTemp    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  Factor_LeanoutOrEnrichTime_TPS    ; store A into memory
           brclr *KeyOnOrEngineRunningTime, #$%11111111, TransFuel_ClearLeanOutFactor    ; branch if bit(s) clear
           ldd   VehicleSpeed_HB    ; load D (A&B) with memory contents
           cpd   #TpsAverageValue_HB    ;  -00000000 10000000-
           bcs   TransFuel_ClearLeanOutFactor    ; branch if lower
           ldaa  Temp0         ; load A with memory contents
           nega                ; negate A (set high bit)
           ldab  Timer_OpenLoopFraction2    ; load B with memory contents
           beq   LC344         ; branch if equal (zero)
           adda  LOTHYS_LeanoutDeltaThrottleHysteresis    ;  (data is 03)
   LC344:  cmpa  LOTTRG_DeltaTriggerForDecelLeanout    ; compare A with memory contents (data is 05)
           bcs   TransFuel_ClearLeanOutFactor    ; branch if lower
           cmpa  LOTRG2_SecondDecelLeanoutTrigger    ; compare A with memory contents (data is 0a)
           bcs   LC358         ; branch if lower
           ldaa  CoolantTemp    ; load A with memory contents
           ldx   #LOTTHR_DecelLeanoutFactor_FromTemp    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           bra   TransFuel_StoreLeanOutFactor    ; branch

   LC358:  tstb                ; test B
           beq   LC36E         ; branch if equal (zero)
           incb                ; increment B
           bra   TransFuel_StoreLeanOutFactor    ; branch

TransFuel_ClearLeanOutFactor:
           clrb                ; b = 0
TransFuel_StoreLeanOutFactor:
           stab  Timer_OpenLoopFraction2    ; store B into memory
           beq   LC36E         ; branch if equal (zero)
           ldaa  Factor_DecelLeanoutWhenMAPDecreasing_Temp    ; load A with memory contents
           beq   LC373         ; branch if equal (zero)
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           bra   LC374         ; branch

   LC36E:  ldaa  Factor_DecelLeanoutWhenMAPDecreasing_Temp    ; load A with memory contents
           bra   LC374         ; branch

   LC373:  tba                 ; A = B
   LC374:  staa  Factor_DecelLeanoutWhenMAPDecreasing    ; store A into memory
           beq   LC37B         ; branch if equal (zero)
           bset  *BitFlags67, #b67_StayOpenLoop    ; set bits
   LC37B:  ldaa  Counter_MainLoop    ; load A with memory contents
           bita  #0x07         ;  -00000111-
           bne   TransFuel_SaveTemp2    ; branch if not equal (not zero)
           ldx   #TpsAverageValue_HB    ; load index with value
           sei                 ; disable interrupts
           jsr   ProcessMapOrTpsBlockData    ; call subroutine
           cli                 ; enable interrupts
TransFuel_SaveTemp2:
           brset *BitFlags6F, #b6f_FuelEngineNotRunning, LC3AC    ; branch if bit(s) set
           ldd   Temp2         ; load D (A&B) with memory contents
TransFuel_SaveD:
           std   Pulsewidth_PartThrottleEnrichment_HB    ; store D (A&B) into memory
           brset *BitFlags66, #b66_OffIdle, LC3AC    ; branch if bit(s) set
           ldaa  SwitchPortAccessReg1    ; load A with memory contents
           bita  #0x40         ;  -01000000-
           bne   LC3AC         ; branch if not equal (not zero)
           ldaa  DesiredNewAisPosition    ; load A with memory contents
           suba  CurrentAisPosition
           bcs   LC3AC         ; branch if lower
           cmpa  POSTIG_MinAisPulseRequireToTriggerEnrichment    ; compare A with memory contents (data is 0d)
           bcs   LC3AC         ; branch if lower
           ldd   POSFUL_AisEnrichmentFuelPulse    ;  (data is 00a0)
           std   Pulsewidth_AISEnrichment_HB    ; store D (A&B) into memory
   LC3AC:  rts                 ; return from subroutine

CalculateInjectorPulsewidthForStarting_MM:
           brset *BitFlags6F, #b6f_FuelEngineNotRunning, LC3B2    ; branch if bit(s) set
           rts                 ; return from subroutine

   LC3B2:  ldd   #0x0000        ; load D (A&B) with value -00000000 00000000-
           std   Pulsewidth_PartThrottleEnrichment_HB    ; store D (A&B) into memory
           ldaa  TPSVolts      ; load A with memory contents
           cmpa  #0xd0         ; compare a with value -11010000-
           bcc   LC3C6         ; branch if greater or equal
           suba  MINTHR_LowestSessionTPS
           bls   LC3C9         ; branch if lower or same
           cmpa  UNLOAD_DeltaThrottleFrom_MINTHR_ToUnloadCrankingFuel    ; compare A with memory contents (data is 85)
           bcs   LC3C9         ; branch if lower
   LC3C6:  jmp   ThrottleFlooredWhileStarting_UnloadFuel

   LC3C9:  jsr   AllowForHeatSoakAfterStall    ; call subroutine
           brset *BitFlags66, #b66_OffIdle, LC3D8    ; branch if bit(s) set
           cmpa  STRLMT_ColdestTempAllowedAtClosedThrottle    ; compare A with memory contents (data is 63)
           bcc   LC3D8         ; branch if greater or equal
           ldaa  STRLMT_ColdestTempAllowedAtClosedThrottle    ; load A with memory contents (data is 63)
   LC3D8:  ldx   #STRTFL_FuelStartFromCoolantTemp    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           mul                 ; multiply (D=A*B)
           std   Temp0         ; store D (A&B) into memory
           ldx   #STFLID_StartFuelIdleFactor_fromRPM    ; load index with value
           brset *BitFlags66, #b66_OffIdle, LC3EB    ; branch if bit(s) set
           ldx   #STFLOI_StartFuelOffIdleFactor_fromRPM    ; load index with value
   LC3EB:  ldd   EngineRpm_HB    ; load D (A&B) with memory contents
           asld                ; shift left (D=D*2)
           bcs   LC3F6         ; branch if lower
           asld                ; shift left (D=D*2)
           bcs   LC3F6         ; branch if lower
           asld                ; shift left (D=D*2)
           bcc   LC3F8         ; branch if greater or equal
   LC3F6:  ldaa  #0xff         ; load a with value -11111111-
   LC3F8:  jsr   Lookup4ByteTable    ; call subroutine
           ldy   Temp0     
           jsr   ScaleYbyA     ; call subroutine
           sty   Temp0         ; store index into memory
           ldaa  Counter_EPP_MaxFF    ; load A with memory contents
           ldx   #EPPMUL_FuelStartFuelPerEPP    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  Temp4         ; store A into memory
           ldaa  CoolantTemp    ; load A with memory contents
           ldx   #STFTMP_FuelStartFuelFromCoolant    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           ldaa  Temp4         ; load A with memory contents
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           beq   LC42C         ; branch if equal (zero)
           tab                 ; B = A
           comb                ; 1's complement B
           ldaa  #0xff         ; load a with value -11111111-
           addd  #0x0101        ;  -00000001 00000001-
           ldy   Temp0     
           jsr   ScaleYbyD_resultD    ; call subroutine
           std   Temp0         ; store D (A&B) into memory
   LC42C:  ldaa  BaroPressure    ; load A with memory contents
           ldx   #STFBAR_FuelStartReductionFromBaro    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  Temp4         ; store A into memory
           ldaa  CoolantTemp    ; load A with memory contents
           ldx   #STFTM2_FuelStartFuelFromCoolant2    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           ldaa  Temp4         ; load A with memory contents
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           beq   LC454         ; branch if equal (zero)
           tab                 ; B = A
           comb                ; 1's complement B
           ldaa  #0xff         ; load a with value -11111111-
           addd  #0x0101        ;  -00000001 00000001-
           ldy   Temp0     
           jsr   ScaleYbyD_resultD    ; call subroutine
           bra   LC456         ; branch

   LC454:  ldd   Temp0         ; load D (A&B) with memory contents
   LC456:  asld                ; shift left (D=D*2)
           bcs   LC45C         ; branch if lower
           asld                ; shift left (D=D*2)
           bcc   LC464         ; branch if greater or equal
   LC45C:  ldd   #0xFFFF        ; load D (A&B) with value -11111111 11111111-
           bra   LC464         ; branch

ThrottleFlooredWhileStarting_UnloadFuel:
           ldd   #0x0000        ; load D (A&B) with value -00000000 00000000-
   LC464:  jsr   NULL_ROUTINE    ; call subroutine
           std   InjectorPulsewidth_HB    ; store D (A&B) into memory
           cli                 ; enable interrupts
           ldx   #SFDCAY_FuelStartDecayIntoRun    ; load index with value
           ldaa  CoolantTemp    ; load A with memory contents
           jsr   Lookup4ByteTable    ; call subroutine
           staa  Factor_StartFuelDecayIntoRunFuel    ; store A into memory
           rts                 ; return from subroutine

ControlEngineCutout_MM:
           ldx   #Turbonator_Flags
           brset 0, x, #Turbonator_Staging, R1000 ; added to keep the normal rev limiter code from turning off the staging limiter...
           brclr *TimerOverflowsBetweenDistPulses, #$%11111111, Cutout_EngineRunning    ; branch if bit(s) clear
           bclr  0, x, #Turbonator_FuelOff | Turbonator_OverRev	 ; clear bits
           brset *BitFlags6B, #$%00001000, R1000    ; branch if bit(s) set
           clr   Counter_FuelEngRunning    ; zero byte at memory location
   R1000:  rts                 ; return from subroutine

; original code
Cutout_EngineRunning:
           ldd   VehicleSpeed_HB    ; load D (A&B) with memory contents
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           staa  Temp1         ; store A into memory
           asld                ; shift left (D=D*2)
           bcc   Cutout_SpeedIsBelow128Mph    ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
Cutout_SpeedIsBelow128Mph:
           staa  Temp0         ; store A into memory
	   brclr 0, x, #Turbonator_FuelOff, Cutout_UseDecelFuelCut    ; branch if bit(s) clear
           jmp   Cutout_UseHysteresisToDetermineWhenToTurnFuelBackOn

Cutout_UseDecelFuelCut:
           brclr 0, x, #Turbonator_DecelFuelCut, Cutout_CheckForOBConditions    ; branch if bit(s) clear
           ldd   EngineRpm_HB    ; load D (A&B) with memory contents
           subd  TargetIdleSpeedHB    ; D = D - memory contents
           bcc   LC4A3         ; branch if greater or equal
           clra                ; A = 0
   LC4A3:  cmpa  DFRPMH_DecelFuelShutoffDeltaRPMOff    ; compare A with memory contents (data is 1e)
           bls   Cutout_CheckForOBConditions    ; branch if lower or same
           bset  0, x, #Turbonator_FuelOff    ; set bits
           rts                 ; return from subroutine

Cutout_CheckForOBConditions:
           ldaa  MapValue      ; load A with memory contents
           suba  BaroPressure
           bcs   Cutout_ResetOverboostTimer    ; branch if lower
           brclr *b5D_IPL2, #$%00100000, Cutout_CheckNormalOB    ; branch if bit(s) clear
           cmpa  LMPSHF_OverboostFuelShutoffDisablePointFromMap_Limp    ; compare A with memory contents (data is 3e)
           bls   Cutout_CheckRevLimiters    ; branch if lower or same

   LC4BB:  brset 0, x, #Turbonator_FuelOff, LC4C5    ; branch if bit(s) set
           bset  *BitFlags6A, #b6a_Cruise2    ; set bits
Cutout_ShutOffEngineForThisRotation:
           bset 0, x, #Turbonator_FuelOff    ; set bits
   LC4C5:  bclr 0, x, #Turbonator_OverRev
           rts                 ; return from subroutine

Cutout_ResetOverboostTimer:
           ldaa  TRNTIM_OverboostFuelShutoffDelay    ; load A with memory contents (data is 00)
           staa  Timer_OverboostCountdown    ; store A into memory
           bra   Cutout_CheckRevLimiters    ; branch

Cutout_CheckNormalOB:
           suba  MPSHFT_OverboostFuelShutoffEnablePointFromMap_Timer    ;  (data is 99)
           bcs   Cutout_ResetOverboostTimer    ; branch if lower
           cmpa  MPSHFA_OverboostFuelShutoffEnablePointFromMap_Absolute    ; compare A with memory contents (data is 99)
           bhi   Cutout_SetOBCodeAndShutdown    ; branch if higher
           ldaa  Timer_OverboostCountdown    ; load A with memory contents
           beq   Cutout_SetOBCodeAndShutdown    ; branch if equal (zero)
           deca                ; decrement A
           staa  Timer_OverboostCountdown    ; store A into memory
           bra   Cutout_CheckRevLimiters    ; branch

Cutout_SetOBCodeAndShutdown:
           ldd   #0x0708       ; load D (A&B) with value -00000111 00001000-
           jsr   ThrowNonCriticalError    ; call subroutine
           bra   LC4BB         ; branch

Cutout_CheckRevLimiters:
           ldx   #REVLMT2_MapLimpinAndThrAbove25PercentUpper2000    ; load index with value
           brclr *b5C_IPL1, #$%10100000, MAPSENSOR_OKAY_OR_LIGHTTHROTTLE    ; branch if bit(s) clear
           ldab  THRTHR_25PctThrValueFromShutoff    ; load B with memory contents (data is 66)
           addb  MINTHR_LowestSessionTPS    ; B=B+memory contents
           cmpb  TPSVolts  
           bcs   Cutout_CheckRevLimitingValues    ; branch if lower

MAPSENSOR_OKAY_OR_LIGHTTHROTTLE:
           ldx   #REVLMT4_MapAbove75PctAndThrLimpin2000    ; load index with value
           brclr *b5C_IPL1, #$%01000000, Cutout_ThrottleSensorOK    ; branch if bit(s) clear
           ldaa  Temp0         ; load A with memory contents
           cmpa  RVLSPD_CarSpeedForRevLimitWithTBOff    ; compare A with memory contents (data is 14)
           bcc   LC519         ; branch if greater or equal
           bra   LC50F         ; branch

Cutout_ThrottleSensorOK:
           ldab  BitFlags66    ; load B with memory contents
           bmi   LC519         ; branch if minus(hi bit 1)
   LC50F:  ldab  BaroPressure    ; load B with memory contents
           lsrb                ; logical shift right B
           tba                 ; A = B
           lsrb                ; logical shift right B
           aba                 ; A=A+B
           cmpa  MapValue      ; compare A with memory contents
           bcs   Cutout_CheckRevLimitingValues    ; branch if lower
   LC519:  ldx   #REVLMT6_RPMLimiterNormalOffRPM    ; load index with value

Cutout_CheckRevLimitingValues:
           ldaa  EngineRpm_HB    ; load A with memory contents
           cmpa  0x00, X      ; compare A with memory at index + value -00000000-
           bcc   Cutout_ShutOffEngineForThisRotation    ; branch if greater or equal
           cmpa  SPDRPM_EngineSpeedHighLimitToEnableOverspeed    ; compare A with memory contents (data is ff)
           bcs   LC52E         ; branch if lower
           ldab  Temp1         ; load B with memory contents
           cmpb  SPDLMH_SpeedLimitFuelShutoff254mph    ; compare B with memory contents (data is ff)
           bcc   Cutout_ShutOffEngineForThisRotation    ; branch if greater or equal
   LC52E:  ldx  #Turbonator_Flags
           brset *BitFlags67, #b67_FallToIdle, Cutout_CheckMPHLimitingValues    ; branch if bit(s) set
           bclr 0, x, #Turbonator_OverRev
           brset *BitFlags6B, #$%00001000, LC53C    ; branch if bit(s) set
           clr   Counter_FuelEngRunning    ; zero byte at memory location
   LC53C:  rts                 ; return from subroutine

Cutout_CheckMPHLimitingValues:
           cmpa  DFRPM2_2560RPM_DecelFuelShutoffUpperRpmLimit    ; compare A with memory contents (data is 1c)
           bcs   LC572         ; branch if lower
           ldaa  Temp0         ; load A with memory contents
           cmpa  DFS20M_20MPHDecelFuelShutoffSpeedLimitOFF    ; compare A with memory contents (data is 1e)
           bcs   LC572         ; branch if lower
           ldaa  CoolantTemp    ; load A with memory contents
           cmpa  DFSTMH_60DegCDecelFuelShutoffTempLimitOff    ; compare A with memory contents (data is c2)
           bcs   LC572         ; branch if lower
           ldaa  KeyOnOrEngineRunningTime    ; load A with memory contents
           cmpa  DFSTMRH_3minuteDecelFuelShutoffTimeLimitOFF    ; compare A with memory contents (data is 0b)
           bcs   LC572         ; branch if lower
           ldaa  MapValue      ; load A with memory contents
           cmpa  DFSMPH_MAPDecelFuelShutoffTimeLimitOFF    ; compare A with memory contents (data is 35)
           bhi   LC572         ; branch if higher
           ldaa  b5C_IPL1      ; load A with memory contents
           bita  #0xe2         ;  -11100010-
           bne   LC572         ; branch if not equal (not zero)
           brclr *PIA2_Buffer, #$%00000001, LC572    ; branch if bit(s) clear
           brset 0, x, #Turbonator_OverRev, LC572    ; branch if bit(s) set
           bset 0, x, #Turbonator_OverRev | Turbonator_FuelOff    ; set bits

Cutout_ClearO2FBCounter:
           clra                ; A = 0
           staa  Counter_O2SensorFeedbackCount_Signed    ; store A into memory
   LC572:  rts                 ; return from subroutine

Cutout_UseHysteresisToDetermineWhenToTurnFuelBackOn:
           brclr 0, x, #Turbonator_DecelFuelCut, LC584    ; branch if bit(s) clear
           ldd   EngineRpm_HB    ; load D (A&B) with memory contents
           subd  TargetIdleSpeedHB    ; D = D - memory contents
           bcc   LC57E         ; branch if greater or equal
           clra                ; A = 0
   LC57E:  cmpa  DFRPML_DecelFuelShutoffDeltaRPMOn    ; compare A with memory contents (data is 11)
           bls   Cutout_TurnFuelBackOn    ; branch if lower or same
           rts                 ; return from subroutine

   LC584:  brclr 0, x, #Turbonator_OverRev, LC5B6    ; branch if bit(s) clear
           brclr *BitFlags67, #b67_FallToIdle, Cutout_TurnFuelBackOn    ; branch if bit(s) clear
           ldaa  EngineRpm_HB    ; load A with memory contents
           cmpa  DFRPM1_2050RPM_DecelFuelShutoffTurnonLimit    ; compare A with memory contents (data is 1c)
           bcs   Cutout_TurnFuelBackOn    ; branch if lower
           ldaa  Temp0         ; load A with memory contents
           cmpa  DFS20L_20MPHDecelFuelShutoffSpeedLimitON    ; compare A with memory contents (data is 14)
           bcs   Cutout_TurnFuelBackOn    ; branch if lower
           ldaa  CoolantTemp    ; load A with memory contents
           cmpa  DFSTML_60DegCDecelFuelShutoffTempLimitON    ; compare A with memory contents (data is be)
           bcs   Cutout_TurnFuelBackOn    ; branch if lower
           ldaa  MapValue      ; load A with memory contents
           cmpa  DFSMPL_MAPDecelFuelShutoffTimeLimitON    ; compare A with memory contents (data is 38)
           bhi   Cutout_TurnFuelBackOn    ; branch if higher
           ldaa  b5C_IPL1      ; load A with memory contents
           bita  #0xe2         ;  -11100010-
           bne   Cutout_TurnFuelBackOn    ; branch if not equal (not zero)
           brset *PIA2_Buffer, #$%00000001, Cutout_ClearO2FBCounter    ; branch if bit(s) set
Cutout_TurnFuelBackOn:
           bclr 0, x, #Turbonator_FuelOff
           rts                 ; return from subroutine

   LC5B6:  ldaa  MapValue      ; load A with memory contents
           suba  BaroPressure
           bcs   Cutout_ResetOverboostTimerAgain    ; branch if lower
           brclr *b5D_IPL2, #$%00100000, LC5CD    ; branch if bit(s) clear
           cmpa  LMPSHF_OverboostFuelShutoffDisablePointFromMap_Limp    ; compare A with memory contents (data is 3e)
           bls   Cutout_DetermineLimpModeCutoutRPM    ; branch if lower or same
           rts                 ; return from subroutine

Cutout_ResetOverboostTimerAgain:
           ldaa  TRNTIM_OverboostFuelShutoffDelay    ; load A with memory contents (data is 00)
           staa  Timer_OverboostCountdown    ; store A into memory
           bra   Cutout_DetermineLimpModeCutoutRPM    ; branch

   LC5CD:  suba  MPSHFT_OverboostFuelShutoffEnablePointFromMap_Timer    ;  (data is 99)
           bcs   Cutout_ResetOverboostTimerAgain    ; branch if lower
           cmpa  MPSHFA_OverboostFuelShutoffEnablePointFromMap_Absolute    ; compare A with memory contents (data is 99)
           bhi   LC5E0         ; branch if higher
           ldaa  Timer_OverboostCountdown    ; load A with memory contents
           beq   LC5E0         ; branch if equal (zero)
           deca                ; decrement A
           staa  Timer_OverboostCountdown    ; store A into memory
           bra   Cutout_DetermineLimpModeCutoutRPM    ; branch

   LC5E0:  ldd   #0x0708       ; load D (A&B) with value -00000111 00001000-
           jmp   ThrowNonCriticalError

Cutout_DetermineLimpModeCutoutRPM:
           ldx   #REVLMT_MapLimpinAndThrAbove25PercentLower1850    ; load index with value
           brclr *b5C_IPL1, #$%10100000, Cutout_MAPSENSOR_OKAY_OR_LIGHTTHROTTLE2    ; branch if bit(s) clear
           ldab  THRTHR_25PctThrValueFromShutoff    ; load B with memory contents (data is 66)
           addb  MINTHR_LowestSessionTPS    ; B=B+memory contents
           cmpb  TPSVolts  
           bcs   CHECK_IFOVER_1850_2000_6167RPM         ; branch if lower
Cutout_MAPSENSOR_OKAY_OR_LIGHTTHROTTLE2:
           ldx   #REVLMT3_MapAbove75PctAndIdleSwitchClosed2000    ; load index with value
           brclr *b5C_IPL1, #$%01000000, Cutout_THROTTLESENSOR_OKAY2    ; branch if bit(s) clear
           ldaa  Temp0         ; load A with memory contents
           cmpa  RVLSPD_CarSpeedForRevLimitWithTBOff    ; compare A with memory contents (data is 14)
           bcc   LC614         ; branch if greater or equal
           bra   LC60A         ; branch

Cutout_THROTTLESENSOR_OKAY2:
           brset *BitFlags66, #b66_OffIdle, LC614    ; branch if bit(s) set
   LC60A:  ldab  BaroPressure    ; load B with memory contents
           lsrb                ; logical shift right B
           tba                 ; A = B
           lsrb                ; logical shift right B
           aba                 ; A=A+B
           cmpa  MapValue      ; compare A with memory contents
           bcs   CHECK_IFOVER_1850_2000_6167RPM         ; branch if lower
   LC614:  ldx   #REVLMT5_RPMLimiterNormalOnRPM    ; load index with value
CHECK_IFOVER_1850_2000_6167RPM:
           ldaa  EngineRpm_HB    ; load A with memory contents
           cmpa  0x00, X      ; compare A with memory at index + value -00000000-
           bcc   LC62C         ; branch if greater or equal
           cmpa  SPDRPM2_EngineSpeedLowLimitToDisableOverspeed    ; compare A with memory contents (data is ff)
   LC620:  bhi   LC625         ; branch if higher
   LC622:  jmp   Cutout_TurnFuelBackOn

   LC625:  ldaa  Temp1         ; load A with memory contents
           cmpa  SPDLML_SpeedLimitFuelShutoffRestore253mph    ; compare A with memory contents (data is ff)
           bls   LC622         ; branch if lower or same
   LC62C:  rts                 ; return from subroutine

CalculateThrottleEnrichmentFactor_MM:
           clra                ; A = 0
           brset *BitFlags6F, #b6f_FuelEngineNotRunning, LC63D    ; branch if bit(s) set
           ldaa  Counter_MainLoop    ; load A with memory contents
           bita  #0x1f         ;  -00011111-
           bne   LC63F         ; branch if not equal (not zero)
           ldaa  TimeEngineRunningAlt    ; load A with memory contents
           inca                ; increment A
           beq   LC63F         ; branch if equal (zero)
   LC63D:  staa  TimeEngineRunningAlt    ; store A into memory
   LC63F:  ldx   #RPMMAP_SwitchPointForDownUp_FromRpm    ; load index with value
           ldaa  EngineRpm_HB    ; load A with memory contents
           jsr   Lookup4ByteTable    ; call subroutine
           cmpa  MapValue      ; compare A with memory contents
           rora                ; rotate right A
           ldx   #PTENR_EppPerAmountForIncreasing    ; load index with value
           anda  #0x80         ; AND a with value -10000000-
           bmi   LC653         ; branch if minus(hi bit 1)
           inX                 ; increment index (I=I+1)
           inX                 ; increment index (I=I+1)
   LC653:  staa  Temp0         ; store A into memory
           tab                 ; B = A
           eorb  Counter_FallingEdgeEPP_MaxFF
           bpl   LC660         ; branch if plus (hi bit 0)
           staa  Counter_FallingEdgeEPP_MaxFF    ; store A into memory
           ldab  Timer_OpenLoopFraction    ; load B with memory contents
           bra   PTECheckWOT         ; branch

   LC660:  ldab  0x00, X      ; load B with memory at index + value -00000000-
           sei                 ; disable interrupts
           eora  Counter_FallingEdgeEPP_MaxFF
           cba                 ; compare A to B
           bcs   LC669         ; branch if lower
           sba                 ; subtract (A=A-B)
   LC669:  oraa  Temp0         ; OR A with memory contents
           staa  Counter_FallingEdgeEPP_MaxFF    ; store A into memory
           cli                 ; enable interrupts
           ldab  TempA         ; load B with memory contents
           bcc   LC676         ; branch if greater or equal
           ldab  Timer_OpenLoopFraction    ; load B with memory contents
           bra   PTECheckWOT         ; branch

   LC676:  addb  0x01, X      ; add memory at index + value to B -00000001-
           ldaa  0x01, X      ; load A with memory at index + value -00000001-
           bpl   LC683         ; branch if plus (hi bit 0)
           cmpb  #0xff         ;  -11111111-
           bne   LC688         ; branch if not equal (not zero)
           clrb                ; b = 0
           bra   LC688         ; branch

   LC683:  tstb                ; test B
           bne   LC688         ; branch if not equal (not zero)
           ldab  #0xff         ; load B with value -11111111-
   LC688:  stab  TempA         ; store B into memory
           ldaa  Counter_FallingEdgeEPP_MaxFF    ; load A with memory contents
           bmi   PTECheckIfMaxed         ; branch if minus(hi bit 1)
           clrb                ; b = 0
           bra   PTEStoreFraction         ; branch

PTECheckIfMaxed:
           ldx   #PTEMAX_PTEnrichMax_FromMap    ; load index with value
           ldab  RPMRescaledfor3D    ; load B with memory contents
           ldaa  MAPRescaledfor3D    ; load A with memory contents
           jsr   Lookup3DTableRoutine2    ; call subroutine
           tab                 ; B = A
           cmpb  TempA     
           bls   PTEIsMaxed         ; branch if lower or same
           brclr *BitFlags66, #b66_PTEisMaxed, LC6BF    ; branch if bit(s) clear
           ldab  Timer_OpenLoopFraction    ; load B with memory contents
           beq   LC6BC         ; branch if equal (zero)
           sba                 ; subtract (A=A-B)
           staa  Temp0         ; store A into memory
           ldaa  PTENRD_AmountForDecreasingMultiplier_Negative    ; load A with memory contents (data is ff)
           beq   LC6BF         ; branch if equal (zero)
           nega                ; negate A (set high bit)
           ldab  PTENUM_NumberToReturnToHOTMAP    ; load B with memory contents (data is 00)
           mul                 ; multiply (D=A*B)
           tsta                ; test A
           bne   LC6BF         ; branch if not equal (not zero)
           cmpb  Temp0     
           bcc   LC6BF         ; branch if greater or equal
   LC6BC:  bclr  *BitFlags66, #b66_PTEisMaxed    ; clear bits
   LC6BF:  ldab  TempA         ; load B with memory contents
           bra   PTEStoreFraction         ; branch

PTEIsMaxed:
           bset  *BitFlags66, #b66_PTEisMaxed    ; set bits
PTEStoreFraction:
           stab  Timer_OpenLoopFraction    ; store B into memory
PTECheckWOT:
           brclr *BitFlags66, #b66_FullThrottle, PTESaveFractionToThrottleFactor    ; branch if bit(s) clear
           ldab  RPMRescaledfor3D    ; load B with memory contents
           ldaa  MAPRescaledfor3D    ; load A with memory contents
           ldx   #WOTENR_WOTEnrichmentFromRPMAndMAP    ; load index with value
           jsr   Lookup3DTableRoutine2    ; call subroutine
           clr   Counter_O2SensorFeedbackCount_Signed    ; zero byte at memory location
           bset  *BitFlags67, #b67_StayOpenLoop    ; set bits
           bra   PTEStoreThorttleFactor         ; branch

PTESaveFractionToThrottleFactor:
           tba                 ; A = B
PTEStoreThorttleFactor:
           staa  ThrottleFactor    ; store A into memory
           beq   PTELookupLatency         ; branch if equal (zero)
           ldab  Counter_O2SensorFeedbackCount_Signed    ; load B with memory contents
           bpl   PTELookupLatency         ; branch if plus (hi bit 0)
           clr   Counter_O2SensorFeedbackCount_Signed    ; zero byte at memory location
PTELookupLatency:
           ldaa  BatteryVolts    ; load A with memory contents
           ldx   #BATOFF_FuelBatteryOffset    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  InjectorLatencyPW    ; store A into memory
           rts                 ; return from subroutine

CalculateSumOfAllFuelModifiers_MM:
; need to re-reference the MAP axis so that the cold load tables are not scaled or extended for MAP.
; for the off-idle table, use the full range; for the idle table, use LoMAP...

           ldx   #CLDLDP_ColdLoad3DTableOffIdle    ; load index with value
           brset *BitFlags66, #b66_OffIdle, LC6FF    ; branch if bit(s) set
           ldx   #CLDLDI_ColdLoad3DTableIdle    ; load index with value
   LC6FF:  ldaa  MAPRescaledfor3D    ; load A with memory contents
           ldab  CoolantTemp    ; load B with memory contents
           jsr   Lookup3DTableRoutine    ; call subroutine
           tab                 ; B = A
           clra                ; A = 0
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           std   Temp0         ; store D (A&B) into memory
           ldaa  TimeEngineRunningAlt    ; load A with memory contents
           ldx   #TIMESC_TimeEngineRunningRescaledFor3D    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           psha                ; push A onto stack
           jsr   AllowForHeatSoakAfterStall    ; call subroutine
           tab                 ; B = A
           pula                ; pull A from stack
           ldx   #CURV3D_CurveABC_3DTable    ; b(x) = coolant temp; a(y) = time engine running
           jsr   Lookup3DTableRoutine    ; call subroutine
           tab                 ; B = A
           clra                ; A = 0
           asld                ; shift left (D=D*2)
           addd  Temp0         ; D = D + memory contents
           pshb                ; push B onto stack
           psha                ; push A onto stack
           lsrd                ; shift right (D=D/2)
           std   Temp0         ; store D (A&B) into memory
           ldaa  BaroPressure    ; load A with memory contents
           ldx   #BAROCP_BaroCompensationOfWarmupFactor_FromBaro    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           puly                ; pull index from stack
           beq   LC744         ; branch if equal (zero)
           jsr   ScaleYbyA     ; call subroutine
   LC739:  xgdy                ; exchange D and index
           addd  Temp0         ; D = D + memory contents
           bcc   LC746         ; branch if greater or equal
           ldd   #0xfeff       ; load D (A&B) with value -11111110 11111111-
           bra   LC746         ; branch

   LC744:  ldd   Temp0         ; load D (A&B) with memory contents
   LC746:  inca                ; increment A
           std   BaseFuelModifier    ; store D (A&B) into memory
           ldaa  BaroPressure    ; load A with memory contents
           ldx   #BARENR_FuelEnrichmentFromBaro    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           psha                ; push A onto stack
           ldaa  MapValue      ; load A with memory contents
           ldx   #BARMAP_MAPMultiplierForBARENR    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           pula                ; pull A from stack
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           psha                ; push A onto stack
           ldaa  EngineRpm_HB    ; load A with memory contents
           ldx   #BARRPM_RPMMultiplierForBARENR    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           pula                ; pull A from stack
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           staa  BaroCompFactorFuel    ; store A into memory
           ldaa  ChargeTempVolts    ; load A with memory contents
           ldx   #AIRTMP_FuelEnrichmentFromChargeTemp    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           psha                ; push A onto stack
           ldaa  MapValue      ; load A with memory contents
           ldx   #AIRMAP_MAPMultiplierForAIRTMP    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           pula                ; pull A from stack
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           psha                ; push A onto stack
           ldaa  EngineRpm_HB    ; load A with memory contents
           ldx   #AIRRPM_RPMMultiplierForAIRTMP    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           pula                ; pull A from stack
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           staa  ChargeTempCompFactorFuel    ; store A into memory
           tab                 ; B = A
           ldaa  #0x01         ; load a with value -00000001-
           xgdy                ; exchange D and index
           ldab  BaroCompFactorFuel    ; load B with memory contents
           ldaa  #0x01         ; load a with value -00000001-
           jsr   ScaleYbyD_resultD    ; call subroutine
           xgdy                ; exchange D and index
           ldaa  Factor_DecelLeanoutWhenMAPDecreasing    ; load A with memory contents
           beq   LC7A6         ; branch if equal (zero)
           jsr   ScaleYbyA     ; call subroutine
   LC7A6:  sty   Temp0         ; store index into memory
           ldx   #Temp0        ; load index with value
           ldab  Timer_FuelEnrich    ; load B with memory contents
           beq   LC7B7         ; branch if equal (zero)
           ldaa  #0x01         ; load a with value -00000001-
           jsr   ScaleXbyB_addingA_intoD    ; call subroutine
           std   Temp0         ; store D (A&B) into memory
   LC7B7:  ldx   #FuelModFromMAPAndSomething0036    ; load index with value
           ldaa  MapValue      ; load A with memory contents
           jsr   Lookup4ByteTable    ; call subroutine
           beq   LC7CD         ; branch if equal (zero)
           ldaa  PointlessFuelFactor    ; load A with memory contents
           bpl   LC7D4         ; branch if plus (hi bit 0)
           nega                ; negate A (set high bit)
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           nega                ; negate A (set high bit)
           tab                 ; B = A
           bra   LC7D1         ; branch

   LC7CD:  ldab  PointlessFuelFactor    ; load B with memory contents
           bpl   LC7D8         ; branch if plus (hi bit 0)
   LC7D1:  clra                ; A = 0
           bra   LC7DA         ; branch

   LC7D4:  mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           tab                 ; B = A
   LC7D8:  ldaa  #0x01         ; load a with value -00000001-
   LC7DA:  stab  FuelCompFactor_X    ; store B into memory
           ldx   #Temp0        ; load index with value
           jsr   ScaleXbyB_addingA_intoD    ; call subroutine
           std   Temp0         ; store D (A&B) into memory
           brset *BitFlags66, #b66_FullThrottle, LC7FF    ; branch if bit(s) set
           clra                ; A = 0
           ldab  Timer_OpenLoopFraction    ; load B with memory contents
           bne   LC7FB         ; branch if not equal (not zero)
           ldab  ValueFromAdaptiveMemory    ; load B with memory contents
           bmi   LC7F3         ; branch if minus(hi bit 1)
   LC7F2:  inca                ; increment A
   LC7F3:  asrb                ; arithmetic shift right B
           jsr   ScaleXbyB_addingA_intoD    ; call subroutine
           std   Temp0         ; store D (A&B) into memory
           bra   LC7FF         ; branch

   LC7FB:  ldab  ValueFromAdaptiveMemory    ; load B with memory contents
           bpl   LC7F2         ; branch if plus (hi bit 0)
   LC7FF:  clra                ; A = 0
           ldab  Counter_O2SensorFeedbackCount_Signed    ; load B with memory contents
           bmi   LC805         ; branch if minus(hi bit 1)
           inca                ; increment A
   LC805:  asrb                ; arithmetic shift right B
           jsr   ScaleXbyB_addingA_intoD    ; call subroutine
           std   Temp0         ; store D (A&B) into memory
           brset *EGRVar2, #$%00010000, LC836    ; branch if bit(s) set
           ldaa  BaroPressure    ; load A with memory contents
           suba  MapValue  
           bcc   LC816         ; branch if greater or equal
           clra                ; A = 0
   LC816:  ldx   #PEFMUL_PumpingEfficiencyMAPMultiplier    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           psha                ; push A onto stack
           ldaa  EngineRpm_HB    ; load A with memory contents
           ldx   #PEFTBL_PumpingEfficiency    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           pula                ; pull A from stack
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           tsta                ; test A
           beq   LC836         ; branch if equal (zero)
           ldy   Temp0     
           jsr   ScaleYbyA     ; call subroutine
           xgdy                ; exchange D and index
           bra   LC838         ; branch

   LC836:  ldd   Temp0         ; load D (A&B) with memory contents
   LC838:  std   SumOfFuelModifiers_HB    ; store D (A&B) into memory
           rts                 ; return from subroutine

AllowForHeatSoakAfterStall:
           ldaa  CoolantTemp    ; load A with memory contents
           cmpa  RUNLMT_MaxAllowableTempFor_RUNTMP    ; compare A with memory contents (data is a0)
           bcc   LC855         ; branch if greater or equal
           ldaa  EngineRunningTimeBeforeStall    ; load A with memory contents
           ldx   #RUNTMP_ModifierOf_ENGTMP_FromStalltime    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           adda  CoolantTemp
           ldab  RUNLMT_MaxAllowableTempFor_RUNTMP    ; load B with memory contents (data is a0)
           bcs   LC854         ; branch if lower
           cba                 ; compare A to B
           bcs   LC855         ; branch if lower
   LC854:  tba                 ; A = B
   LC855:  rts                 ; return from subroutine

DealWithSpecialIdle_SetBasicTiming_MM:
           brset *BitFlags66, #b66_OffIdle, THROTTLE_PRESSED1    ; branch if bit(s) set
           ldaa  RICHSA_OpenLoopEnrichFactorWhenSettingBasicTiming    ; load A with memory contents (data is 1a)
           brset *b5C_IPL1, #$%00000010, LC86D    ; branch if bit(s) set
           brset *BitFlags6C, #$%00100000, LC86D    ; branch if bit(s) set
           ldaa  RIDLST_OpenLoopEnrichFactorWhenSettingMinThrottleOpening    ; load A with memory contents (data is 00)
           brset *BitFlags6C, #$%00010000, LC86D    ; branch if bit(s) set
           clra                ; A = 0
   LC86D:  brclr *Timer_FuelEnrich, #$%11111111, LOAD_FUELENRICHVAR    ; branch if bit(s) clear
           tsta                ; test A
           bne   LOAD_FUELENRICHVAR    ; branch if not equal (not zero)
           ldaa  O2ITIM_TimeO2InhibitedSwitchingRichIdleToClosedLoop    ; load A with memory contents (data is ff)
           staa  Timer_O2InhibitSwitchingRichIdleToClosedLoop    ; store A into memory
THROTTLE_PRESSED1:
           clra                ; A = 0
LOAD_FUELENRICHVAR:
           staa  Timer_FuelEnrich    ; store A into memory
           beq   LC883         ; branch if equal (zero)
           clra                ; A = 0
           staa  Counter_O2SensorFeedbackCount_Signed    ; store A into memory
           staa  Counter_AdaptiveMem_Erase    ; store A into memory
   LC883:  rts                 ; return from subroutine

;	.org	0xc884
CylPWOffsetValueTable:
	.word	0x0602
	.word	0x0004

InterruptVector_DistributorSignal:
           clr   ATMOffset     ; zero byte at memory location
           ldaa  DRBPointer1    ; load A with memory contents
           cmpa  #0x0a         ; compare a with value -00001010-
           bne   LC893         ; branch if not equal (not zero)
           stab  DRBPointer1    ; store B into memory
   LC893:  ldaa  #0x10         ; load a with value -00010000-
           staa  CPU_A2DControlReg
           ldab  SwitchPortAccessReg2    ; load B with memory contents
           andb  #0x01         ;  -00000001-
           stab  Temp6         ; store B into memory
           bset  *BitFlags72, #b72_O2Enable    ; set bits
           ldd   CPU_DistPickupCaptureRegHigh
           jsr   DetermineNumberOfOverflowsBetweenCamSensorPulses_MM    ; call subroutine
   LC8A8:  ldd   CPU_TimerCounterRegHigh
           subd  CPU_DistPickupCaptureRegHigh
           subd  #TpsAverageValue_HB    ;  -00000000 10000000-
           bcs   LC8A8         ; branch if lower
           ldab  #0x04         ; load B with value -00000100-
           stab  CPU_TimerInterruptFlag1    ; store B into memory
           ldaa  CPU_TimerControlReg2    ; load A with memory contents
           anda  #0x30         ; AND a with value -00110000-
           beq   SETTOLOOKFORRISINGEDGE_STARTAD_RETURN    ; branch if equal (zero)
           cmpa  #0x30         ; compare a with value -00110000-
           beq   SETTOLOOKFORRISINGEDGE_STARTAD_RETURN    ; branch if equal (zero)
           lsra                ; logic shift right A
           lsra                ; logic shift right A
           eora  CPU_PortA 
           bita  #0x04         ;  -00000100-
           beq   DistributorSignalIsWhatWasExpected    ; branch if equal (zero)
SETTOLOOKFORRISINGEDGE_STARTAD_RETURN:
           ldaa  CPU_TimerControlReg2    ; load A with memory contents
           oraa  #0x10         ;  -00010000-
           anda  #0xdf         ; AND a with value -11011111-
           staa  CPU_TimerControlReg2
           rti                 ; return from interrupt

DistributorSignalIsWhatWasExpected:
           ldaa  Counter_SomethingWithDistributor    ; load A with memory contents
           inca                ; increment A
           beq   LC8E0         ; branch if equal (zero)
           staa  Counter_SomethingWithDistributor
   LC8E0:  ldaa  CPU_TimerControlReg2    ; load A with memory contents
           bita  #0x10         ;  -00010000-
           bne   Interrupt_HandleDistributorRisingEdge    ; branch if not equal (not zero)
           jmp   FALLING_EDGE_INTERRUPT

Interrupt_HandleDistributorRisingEdge:
           brclr *BitFlags68, #b68_BladePassedSensor, LC939    ; branch if bit(s) clear
           ldd   TimerOverflowsBetweenDistPulses    ; load D (A&B) with memory contents
           cpd   #AutoCalCell5    ;  -00000000 00010100-
           bcc   USE_DISTSYNCPICKUP_TOSETPOSITIONBITS    ; branch if greater or equal
           ldd   CPU_DistPickupCaptureRegHigh
           subd  LastDistributorFallingEdgeTime    ; D = D - memory contents
           asld                ; shift left (D=D*2)
           ldab  #0x03         ; load B with value -00000011-
           mul                 ; multiply (D=A*B)
           stab  Temp5         ; store B into memory
           ldd   DistributorFallingEdgePulsewidth_HB    ; load D (A&B) with memory contents
           asld                ; shift left (D=D*2)
           tab                 ; B = A
           bset  *BitFlags6A, #b6a_DRBToggle1    ; set bits
           ldaa  Temp5         ; load A with memory contents
           cba                 ; compare A to B
           bcc   DIST_SYNC_WENT_TO_ZERO_WINDOWBLADE_JUSTLEAVING_REFPICKUP    ; branch if greater or equal
           bclr  *BitFlags6A, #b6a_DRBToggle1    ; clear bits
           bra   DIST_SYNC_WENT_TO_ONE_WINDOWBLADE_JUSTCUTTING_REFPICKUP    ; branch

USE_DISTSYNCPICKUP_TOSETPOSITIONBITS:
           ldab  Temp6         ; load B with memory contents
           ldaa  BitFlags6A    ; load A with memory contents
           staa  Temp5         ; store A into memory
           anda  #0xfe         ; AND a with value -11111110-
           aba                 ; A=A+B
           staa  BitFlags6A    ; store A into memory
           eorb  Temp5     
           bitb  #0x01         ;  -00000001-
           beq   DIST_SYNC_HASNT_CHANGED_REGULARBLADE_CUT_REFPICKUP    ; branch if equal (zero)
           ldab  Temp6         ; load B with memory contents
           beq   DIST_SYNC_WENT_TO_ONE_WINDOWBLADE_JUSTCUTTING_REFPICKUP    ; branch if equal (zero)
           brclr *BitFlags72, #b72_AlternatorField, DIST_SYNC_WENT_TO_ZERO_WINDOWBLADE_JUSTLEAVING_REFPICKUP    ; branch if bit(s) clear
DIST_SYNC_WENT_TO_ONE_WINDOWBLADE_JUSTCUTTING_REFPICKUP:
           bclr  *BitFlags72, #b72_AlternatorField | b72_InjectorAandB    ; clear bits
           rti                 ; return from interrupt

DIST_SYNC_HASNT_CHANGED_REGULARBLADE_CUT_REFPICKUP:
           ldab  Temp6         ; load B with memory contents
           bne   CAM_POSITION_NOT_INSYNC    ; branch if not equal (not zero)
           bset  *BitFlags72, #b72_AlternatorField    ; set bits
   LC936:  bclr  *BitFlags68, #b68_BladePassedSensor    ; clear bits
   LC939:  bset  *BitFlags5E, #$%00000010    ; set bits
           rti                 ; return from interrupt

CAM_POSITION_NOT_INSYNC:
           brclr *BitFlags72, #b72_SearchBladeEndRef, LC949    ; branch if bit(s) clear
           brclr *BitFlags72, #b72_InjectorAandB, LC936    ; branch if bit(s) clear
DIST_SYNC_WENT_TO_ZERO_WINDOWBLADE_JUSTLEAVING_REFPICKUP:
           brset *BitFlags72, #b72_InjectorAandB, ZERO_CAM_POSITION_BITS    ; branch if bit(s) set
   LC949:  bset  *BitFlags72, #b72_SearchBladeEndRef    ; set bits
           inc   BitFlags72
           bra   LC954         ; branch

ZERO_CAM_POSITION_BITS:
           bclr  *BitFlags72, #b72_InjectorAandB    ; clear bits
   LC954:  ldab  CPU_TimerControlReg2    ; load B with memory contents
           orab  #0x20         ;  -00100000-
           andb  #0xef         ;  -11101111-
           stab  CPU_TimerControlReg2    ; store B into memory
           ldaa  TimerOverflowsBetweenDistPulses    ; load A with memory contents
           bne   FORCE_DWELL_TO_ACTIVATE    ; branch if not equal (not zero)
           brclr *BitFlags6F, #b6f_DisableNormalDwell, TachSignalAndClearKnockSensorCap    ; branch if bit(s) clear
FORCE_DWELL_TO_ACTIVATE:
           ldaa  CPU_TimerControlReg1    ; load A with memory contents
           anda  #0xfe         ; AND a with value -11111110-
           staa  CPU_TimerControlReg1
           ldaa  #0x08         ; load a with value -00001000-
           staa  CPU_HardwareTimerForceCompare
TachSignalAndClearKnockSensorCap:
           ldab  PIA1_Buffer    ; load B with memory contents
           andb  #0xbd         ;  -10111101-
           stab  PIA1_Buffer    ; store B into memory
           stab  PortX_Control    ; store B into memory
           ldd   CPU_DistPickupCaptureRegHigh
           subd  LastDistributorFallingEdgeTime    ; D = D - memory contents
           xgdy                ; exchange D and index
           ldaa  DFEDTS_DistributorFallingEdgeScaleForDwellTimeCalc    ; load A with memory contents (data is ff)
           jsr   ScaleYbyA     ; call subroutine
           xgdy                ; exchange D and index
           addd  CPU_DistPickupCaptureRegHigh
           std   CPU_Timer_OC4_DwellA
           ldaa  #0x10         ; load a with value -00010000-
           staa  CPU_TimerInterruptFlag1
           ldaa  EngineRpm_HB    ; load A with memory contents
           cmpa  #0x5f         ; compare a with value -01011111-
           bcs   LC9C7         ; branch if lower
           ldaa  #0x08         ; load a with value -00001000-
           bita  CPU_TimerInterruptFlag1
           beq   LC9C7         ; branch if equal (zero)
           staa  CPU_TimerInterruptFlag1
           brclr *BitFlags68, #b68_BladePassedSensor, LC9C7    ; branch if bit(s) clear
           brset *BitFlags72, #b72_AlternatorField, LC9C7    ; branch if bit(s) set
           
; v2 code paste
; here, add code to prevent ouput if spark cut is desired...
;            ldy  #Turbonator_Flags
;            brset 0, y, #Turbonator_AllowSpark, ContinueRisingInterruptRoutine ; skip the dwell time stuff...

           ldaa  CPU_TimerControlReg1    ; load A with memory contents
           eora  #0x01         ; XOR a with value -00000001-
           staa  CPU_TimerControlReg1
           lsra                ; logic shift right A
           bcc   SETTOLOOKFOR_FALLINGEDGE_NEXTTIME0    ; branch if greater or equal
           ldd   AntiDwellTime_HB    ; load D (A&B) with memory contents
           bra   LC9C1         ; branch

SETTOLOOKFOR_FALLINGEDGE_NEXTTIME0:
           ldd   DistributorFallingEdgePulsewidth_HB    ; load D (A&B) with memory contents
           subd  AntiDwellTime_HB    ; D = D - memory contents
   LC9C1:  addd  CPU_Timer_OC5_DwellB
           std   CPU_Timer_OC5_DwellB
   LC9C7:  inc   AdaptiveCellUpdateTimer_IncrementedEveryCamRisingEdge
           inc   Timer_O2ToggleDuration
           ldaa  CPU_A2DResults1    ; load A with memory contents
           brset *BitFlags68, #b68_SparkEngineNotRunning, MAYBE_DO_BAROREADING    ; branch if bit(s) set
           ldab  EngineRpm_HB    ; load B with memory contents
           cmpb  #0x2e         ;  -00101110-
           bcc   GREATER_THAN_1472RPM    ; branch if greater or equal
           ldab  TPSVolts      ; load B with memory contents
           subb  MINTHR_LowestSessionTPS    ; B = B-memory contents
           bcs   LC9E5         ; branch if lower
           cmpb  MPLTHR_ThrottleLevelAbove_MINTHR_ToMatureMapLimpin    ; compare B with memory contents (data is 42)
           bcc   GREATER_THAN_1472RPM    ; branch if greater or equal
   LC9E5:  cmpa  MAPHIG_MapSensorUpperLimit    ; compare A with memory contents (data is ee)
           bcc   LC9F3         ; branch if greater or equal
           cmpa  MAPLOW_MapSensorLowerLimit    ; compare A with memory contents (data is 01)
           bcs   LC9F3         ; branch if lower
GREATER_THAN_1472RPM:
           brclr *b5C_IPL1, #$%10100000, LC9F8    ; branch if bit(s) clear
   LC9F3:  jsr   SimulateMapReadingFromTps    ; call subroutine
           bra   LC9FB         ; branch

   LC9F8:  adda  MapVolts  
           rora                ; rotate right A
   LC9FB:  jsr   ConvertMAPVoltsToValue    ; call subroutine
           staa  MapValue      ; store A into memory
           bra   CALC_SPARK_RETARD_BASED_ON_KNOCK_VOLT    ; branch

MAYBE_DO_BAROREADING:
           brclr *BitFlags6F, #b6f_BaroOkEngineStopped, CALC_SPARK_RETARD_BASED_ON_KNOCK_VOLT    ; branch if bit(s) clear
           bclr  *BitFlags6F, #b6f_BaroOkEngineStopped    ; clear bits
           jsr   SaveBaroPressure    ; call subroutine
CALC_SPARK_RETARD_BASED_ON_KNOCK_VOLT:
           bclr  *BitFlags72, #b72_bit6    ; clear bits
           brset *BitFlags66, #b66_OffIdle, LCA16    ; branch if bit(s) set
           jmp   LCAB3     

   LCA16:  ldaa  MapValue      ; load A with memory contents
           cmpa  KNKMAP_MinimumMAPforKnockRetard    ; compare A with memory contents (data is 66)
           bls   LCA65         ; branch if lower or same
           ldaa  EngineRpm_HB    ; load A with memory contents
           cmpa  KNKRPM_MinRpmforKnockRetard    ; compare A with memory contents (data is 00)
           bls   LCA67         ; branch if lower or same
           ldx   #Cylinder2Retard    ; load index with value
           ldab  BitFlags72    ; load B with memory contents
           andb  #b72_InjectorAandB         ;  -00000011-
           eorb  #b72_InjectorB         ;  -00000010-
           abx                 ; add B to index
           pshx                ; pull index from stack
           ldx   #MAXRTD_MaximumKnockRetardPerCylinder    ; load index with value
           ldaa  MapValue      ; load A with memory contents
           jsr   Lookup4ByteTable    ; call subroutine
           pulx                ; pull index from stack
           pshx                ; pull index from stack
           psha                ; push A onto stack
           cmpa  0x00, X      ; compare A with memory at index + value -00000000-
           bls   LCAB1         ; branch if lower or same
           ldaa  KnockVolts    ; load A with memory contents
           suba  KnockSensorThreshold
           bls   LCAB1         ; branch if lower or same
           bset  *BitFlags72, #b72_bit6    ; set bits
           ldx   #RTRDRT_KnockRetardRateNoBoost    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           ldy   #INNBNK_KnockRetardIncrProduct_NoBoostNoKnock    ; load index with value
           ldaa  BaroPressure    ; load A with memory contents
           adda  KNKOFS_DeltaAboveBaroFor_RTRDRT_and_KNKCNT_and_KNKCOR_incremented    ;  (data is 0c)
           cmpa  MapValue      ; compare A with memory contents
           bcs   LCA6F         ; branch if lower
           tst   KnockRetardSum_AllCyls
           bne   LCA69         ; branch if not equal (not zero)
           ldaa  0x00, Y      ; load A with memory at index + value -00000000-
           mul                 ; multiply (D=A*B)
           bra   AddKnockIncrementToTotal    ; branch

   LCA65:  bra   LCAAF         ; branch

   LCA67:  bra   LCAB3         ; branch

   LCA69:  ldaa  0x01, Y      ; load A with memory at index + value -00000001-
           mul                 ; multiply (D=A*B)
           bra   AddKnockIncrementToTotal    ; branch

   LCA6F:  tst   CurrentWastegatePosition
           beq   LCA85         ; branch if equal (zero)
           tst   KnockRetardSum_AllCyls
           bne   LCA7F         ; branch if not equal (not zero)
           ldaa  0x02, Y      ; load A with memory at index + value -00000010-
           mul                 ; multiply (D=A*B)
           bra   AddKnockIncrementToTotal    ; branch

   LCA7F:  ldaa  0x03, Y      ; load A with memory at index + value -00000011-
           mul                 ; multiply (D=A*B)
           bra   AddKnockIncrementToTotal    ; branch

   LCA85:  tst   KnockRetardSum_AllCyls
           bne   LCA90         ; branch if not equal (not zero)
           ldaa  0x04, Y      ; load A with memory at index + value -00000100-
           mul                 ; multiply (D=A*B)
           bra   AddKnockIncrementToTotal    ; branch

   LCA90:  ldaa  0x05, Y      ; load A with memory at index + value -00000101-
           mul                 ; multiply (D=A*B)
AddKnockIncrementToTotal:
           pulb                ; pull B from stack
           pulx                ; pull index from stack
           adda  0x00, X       ; X contains cyl2retard address
           cba                 ; compare A to B
           bls   LCA9C         ; branch if lower or same
           tba                 ; A = B
   LCA9C:  ldab  CONFIG_ConfigurationFlags    ; load B with memory contents (data is 92)
           bitb  #0x01         ;  -00000001-
           beq   LCAAD         ; branch if equal (zero)
           staa  Cylinder2Retard    ; store A into memory
           staa  Cylinder1Retard    ; store A into memory
           staa  Cylinder3Retard    ; store A into memory
           staa  Cylinder4Retard    ; store A into memory
           bra   LCAB3         ; branch

   LCAAD:  staa  0x00, X      ;  -00000000-
   LCAAF:  bra   LCAB3         ; branch

   LCAB1:  pula                ; pull A from stack
           pulx                ; pull index from stack
   LCAB3:  ldaa  Cylinder2Retard    ; load A with memory contents
           adda  Cylinder1Retard
           bcs   LCAC1         ; branch if lower
           adda  Cylinder3Retard
           bcs   LCAC1         ; branch if lower
           adda  Cylinder4Retard
           bcc   LCAC3         ; branch if greater or equal
   LCAC1:  ldaa  #0xff         ; load a with value -11111111-
   LCAC3:  staa  KnockRetardSum_AllCyls
           ldaa  TPSVolts      ; load A with memory contents
           ldab  TPSFL1_TPSFilterForTPSRetard_NoAR    ; load B with memory contents (data is 08)
           ldx   #FilteredTPSOverMINTHR_A    ; load index with value
           jsr   FilterTPSbyB    ; call subroutine
           ldaa  TPSVolts      ; load A with memory contents
           ldab  TPSFL2_TPSFilterForTPSRetard_WithAR    ; load B with memory contents (data is 04)
           ldx   #FilteredTPSOverMINTHR_B    ; load index with value
           jsr   FilterTPSbyB    ; call subroutine
           ldaa  TPSVolts      ; load A with memory contents
           cmpa  TpsAverageValue_HB    ; compare A with memory contents
           bcs   THROTTLE_HAS_DECREASED         ; branch if lower
           ldx   #TpsAverageValue_HB    ; load index with value
           jsr   ProcessMapOrTpsBlockData    ; call subroutine
THROTTLE_HAS_DECREASED:
           brset *BitFlags66, #b66_FullThrottle, LCAF2    ; branch if bit(s) set
           ldaa  MapValue      ; load A with memory contents
           cmpa  MapAverageValue_HB    ; compare A with memory contents
           bcs   MAP_HAS_DECREASED0         ; branch if lower
   LCAF2:  ldx   #MapAverageValue_HB    ; load index with value
           jsr   ProcessMapOrTpsBlockData    ; call subroutine
MAP_HAS_DECREASED0:
           brset *CCDFlags5, #ccd_AlarmDisable, ClearInjectorPW    ; branch if bit(s) set
           brset *BitFlags6F, #b6f_FuelEngineNotRunning, IncludeLatency    ; branch if bit(s) set
;           brset *BitFlags6A, #b6a_FuelOff, StartCalculatingFuel    ; branch if bit(s) set
           
; v2 code paste
           ldx   #Turbonator_Flags
           brset 0, x, #Turbonator_FuelOff, StartCalculatingFuel    ; branch if bit(s) set

           brset *BitFlags6B, #$%00001000, LCB0E    ; branch if bit(s) set
           bra   CalculateInjectorPulsewidthForEngineRunning    ; branch

StartCalculatingFuel:
;           brclr *BitFlags6A, #b6a_OverRev, ClearInjectorPW    ; branch if bit(s) clear

; v2 code paste
          brclr 0, x, #Turbonator_OverRev, ClearInjectorPW    ; branch if bit(s) clear

   LCB0E:  ldaa  Counter_FuelEngRunning    ; load A with memory contents
           bne   LCB35         ; branch if not equal (not zero)
           ldaa  EngineRpm_HB    ; load A with memory contents
           suba  TargetIdleSpeedHB
           bcc   LCB19         ; branch if greater or equal
           clra                ; A = 0
   LCB19:  ldx   #CTFERA_CounterFuelEngineRunningInitA    ; load index with value
           brclr *BitFlags6B, #$%00001000, LCB23    ; branch if bit(s) clear
           ldx   #CTFERD_CounterFuelEngineRunningInitD    ; load index with value
   LCB23:  ldab  0x00, X      ; load B with memory at index + value -00000000-
           inX                 ; increment index (I=I+1)
   LCB26:  cmpa  0x00, X      ; compare A with memory at index + value -00000000-
           bcc   LCB31         ; branch if greater or equal
           inX                 ; increment index (I=I+1)
           inX                 ; increment index (I=I+1)
           decb                ; decrement B
           bne   LCB26         ; branch if not equal (not zero)
           deX                 ; decrement index (I=I-1)
           deX                 ; decrement index (I=I-1)
   LCB31:  ldaa  0x01, X      ; load A with memory at index + value -00000001-
           beq   CalculateInjectorPulsewidthForEngineRunning    ; branch if equal (zero)
   LCB35:  bita  #0x0f         ;  -00001111-
           beq   LCB3E         ; branch if equal (zero)
           deca                ; decrement A
           staa  Counter_FuelEngRunning    ; store A into memory
           bra   ClearInjectorPW    ; branch

   LCB3E:  suba  #0x10         ;  -00010000-
           staa  Counter_FuelEngRunning    ; store A into memory
           bra   CalculateInjectorPulsewidthForEngineRunning    ; branch

ClearInjectorPW:
           ldd   #0x0000        ; load D (A&B) with value -00000000 00000000-
           std   BaseInjectorPulsewidth_HB    ; store D (A&B) into memory
           std   InjectorPulsewidth_HB    ; store D (A&B) into memory
           bra   StoreCylinderInjectorPWs    ; branch

IncludeLatency:
           ldd   #0x0000        ; load D (A&B) with value -00000000 00000000-
           std   BaseInjectorPulsewidth_HB    ; store D (A&B) into memory
           ;.byte 0xf6, 0x00, 0x91 ; FIXME
           ldab  InjectorLatencyPW    ; load B with memory contents FIXLATER
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           std   Temp5         ; store D (A&B) into memory
           ldd   InjectorPulsewidth_HB    ; load D (A&B) with memory contents
           lsrd                ; shift right (D=D/2)
           lsrd                ; shift right (D=D/2)
           addd  Temp5         ; D = D + memory contents
           bcc   StoreCylinderInjectorPWs    ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
StoreCylinderInjectorPWs:
           std   InjectorPulsewidth_HB_Cyl1
           std   InjectorPulsewidth_HB_Cyl2
           std   InjectorPulsewidth_HB_Cyl3
           std   InjectorPulsewidth_HB_Cyl4
           rti                 ; return from interrupt

CalculateInjectorPulsewidthForEngineRunning:
           ldaa  MapValue      ; load A with memory contents
           ldx   #MAPHI_HiMAP3DInputModifierFromMAP    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  MAPRescaledfor3D    ; store A into memory
           ldaa  MapValue      ; load A with memory contents
           suba  MAPMIN_MinimumMAPForFuelCalculation    ;  (data is 09)
           bcc   LCB83         ; branch if greater or equal
           ldaa  #0x00         ; load a with value -00000000-
   LCB83:  ldab  DFPART_DensityFactorPartThrottle    ; load B with memory contents (data is 10)
           mul                 ; multiply (D=A*B)
           nop                 ; no operation
           nop                 ; no operation
           nop                 ; no operation
           pshb                ; push B onto stack
           psha                ; push A onto stack
           lsrd                ; shift right (D=D/2)
           std   Temp5         ; store D (A&B) into memory
           ldab  RPMRescaledfor3D    ; load B with memory contents
           ldaa  MAPRescaledfor3D    ; load A with memory contents
           ldx   #PRTTBL_FuelFromRPMAndMAP    ; load index with value
           jsr   Lookup3DTableRoutine2    ; call subroutine
           puly                ; pull index from stack
           tsta                ; test A
           beq   LCBAC         ; branch if equal (zero)
           jsr   ScaleYbyA     ; call subroutine
           xgdy                ; exchange D and index
           addd  Temp5         ; D = D + memory contents
           bcc   LCBAE         ; branch if greater or equal
           ldd   #0xFFFF        ; load D (A&B) with value -11111111 11111111-
           bra   LCBAE         ; branch

   LCBAC:  ldd   Temp5         ; load D (A&B) with memory contents
   LCBAE:  std   BaseInjectorPulsewidthX    ; store D (A&B) into memory
           ldaa  ThrottleFactor    ; load A with memory contents
           ldab  THRMUL_MultiplierForThrottleFactor    ; load B with memory contents (data is ff)
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           tab                 ; B = A
           clra                ; A = 0
           std   Temp5         ; store D (A&B) into memory
           ldd   BaseFuelModifier    ; load D (A&B) with memory contents
           subd  Temp5         ; D = D - memory contents
           cpd   #0x0100       ;  -00000001 00000000-
           bcc   INCLUDE_PW_MODIFIERS    ; branch if greater or equal
           ldd   #0x0100       ; load D (A&B) with value -00000001 00000000-
INCLUDE_PW_MODIFIERS:
           xgdy                ; exchange D and index
           ldab  ThrottleFactor    ; load B with memory contents
           ldaa  #0x01         ; load a with value -00000001-
           jsr   ScaleYbyD_resultD    ; call subroutine
           ldy   SumOfFuelModifiers_HB
           jsr   ScaleYbyD_resultD    ; call subroutine
           ldy   BaseInjectorPulsewidthX
           jsr   ScaleYbyD_resultD    ; call subroutine
           pshb                ; push B onto stack
           psha                ; push A onto stack
           ldaa  AdaptiveRetardValue_A    ; load A with memory contents
           ldab  AdaptiveRetardIndex    ; load B with memory contents
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           ldx   #Cylinder2Retard    ; load index with value
           ldab  BitFlags72    ; load B with memory contents
           andb  #b72_InjectorAandB         ;  -00000011-
           abx                 ; add B to index
           ldab  0x00, X      ; load B with memory at index + value -00000000-
           aba                 ; A=A+B
           tab                 ; B = A
           bcc   LCBF8         ; branch if greater or equal
           ldab  #0xff         ; load B with value -11111111-
   LCBF8:  ldaa  KNNRCH_EnrichmentFromTotalKnock    ; load A with memory contents (data is 05)
           mul                 ; multiply (D=A*B)
           lsrd                ; shift right (D=D/2)
           lsrd                ; shift right (D=D/2)
           tsta                ; test A
           bne   LCC06         ; branch if not equal (not zero)
           cmpb  MAXKNR_MaximumKnockEnrichment    ; compare B with memory contents (data is 20)
           bls   LCC09         ; branch if lower or same
   LCC06:  ldab  MAXKNR_MaximumKnockEnrichment    ; load B with memory contents (data is 20)
   LCC09:  ldaa  #0x01         ; load a with value -00000001-
           puly                ; pull index from stack
           jsr   ScaleYbyD_resultD    ; call subroutine
           addd  Pulsewidth_PartThrottleEnrichment_HB    ; D = D + memory contents
           bcs   LOAD_MAX_INJ_PULSEWIDTH    ; branch if lower
           addd  Pulsewidth_AISEnrichment_HB    ; D = D + memory contents
           bcc   HandleTransitionFromStartToRun         ; branch if greater or equal
LOAD_MAX_INJ_PULSEWIDTH:
           ldd   #0xFFFF        ; load D (A&B) with value -11111111 11111111-

HandleTransitionFromStartToRun:
           brclr *BitFlags6F, #b6f_Starting, IncludeInjectorLatency    ; branch if bit(s) clear
           std   Temp5         ; store D (A&B) into memory
           ldd   InjectorPulsewidth_HB    ; load D (A&B) with memory contents
           suba  Factor_StartFuelDecayIntoRunFuel
           bls   TransitionFromStartToRunComplete    ; branch if lower or same
           cmpa  Temp5         ; compare A with memory contents
           bhi   IncludeInjectorLatency    ; branch if higher
TransitionFromStartToRunComplete:
           ldd   Temp5         ; load D (A&B) with memory contents
           bclr  *BitFlags6F, #b6f_Starting    ; clear bits
IncludeInjectorLatency:
           jsr   NULL_ROUTINE    ; call subroutine
           std   InjectorPulsewidth_HB    ; store D (A&B) into memory
           ;.byte 0xf6, 0x00, 0x91 ; FIXME
           ldab  InjectorLatencyPW    ; load B with memory contents   
           clra                ; A = 0
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           addd  InjectorPulsewidth_HB    ; D = D + memory contents
           bcc   LCC41         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   LCC41:  std   BaseInjectorPulsewidth_HB    ; store D (A&B) into memory
           clra                ; A = 0
           staa  Temp5         ; store A into memory
           staa  Temp6         ; store A into memory
           ldab  BitFlags72    ; load B with memory contents
           andb  #b72_InjectorAandB         ;  -00000011-
           ldx   #CylPWOffsetValueTable     ; load index with value
           abx                 ; add B to index
           ldab  0x00, X      ; load B with memory at index + value -00000000-
           ldx   #InjectorPulsewidth_HB_Cyl1    ; load index with value
           abx                 ; add B to index
           ldaa  CoolantTemp    ; load A with memory contents
           cmpa  CTVCDS_CoolantTempForVeryColdStart    ; compare A with memory contents (data is 58)
           bcs   LCCB0         ; branch if lower
           brset *BitFlags66, #b66_OffIdle, LCCB0    ; branch if bit(s) set
           brclr *BitFlags67, #b67_FallToIdle, LCC6C    ; branch if bit(s) clear
           ldaa  CONFIG_ConfigurationFlags    ; load A with memory contents (data is 92)
           bita  #0x10         ;  -00010000-
           beq   LCCB0         ; branch if equal (zero)
   LCC6C:  brset *BitFlags72, #b72_bit7, LCC81    ; branch if bit(s) set
           ldd   KeyOnOrEngineRunningTime    ; load D (A&B) with memory contents
           cpd   #AISACCompensation    ;  -00000000 00001100-
           bcs   LCC7E         ; branch if lower
           ldaa  CSFERX_NumLoopsForColdStartFuelEnrich    ; load A with memory contents (data is 04)
           staa  ColdStartFuelReduxCounter
   LCC7E:  bset  *BitFlags72, #b72_bit7    ; set bits
   LCC81:  ldaa  ColdStartFuelReduxCounter    ; load A with memory contents
           beq   LCCCC         ; branch if equal (zero)
           deca                ; decrement A
           staa  ColdStartFuelReduxCounter
           pshx                ; pull index from stack
           ldaa  EngineRpm_HB    ; load A with memory contents
           ldx   #PCCSFE_PercentForColdStartFuelEnrichment    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           psha                ; push A onto stack
           ldy   InjectorPulsewidth_HB
           jsr   ScaleYbyA     ; call subroutine
           xgdy                ; exchange D and index
           std   Temp5         ; store D (A&B) into memory
           pulb                ; pull B from stack
           ;.byte 0xb6, 0x00, 0x91 ; FIXME
           ldaa  InjectorLatencyPW    ; load A with memory contents FIXLATER
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           tab                 ; B = A
           clra                ; A = 0
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           addd  Temp5         ; D = D + memory contents
           pulx                ; pull index from stack
           std   0x00, X      ; store D into index plus offset -00000000-
           bra   LCCCC         ; branch

   LCCB0:  bclr  *BitFlags72, #b72_bit7    ; clear bits
           ldd   BaseInjectorPulsewidth_HB    ; load D (A&B) with memory contents
           std   0x00, X      ; store D into index plus offset -00000000-
           cpd   #MapAverageValue_LB    ;  -00000000 01111101-
           bls   LCCCC         ; branch if lower or same
           ldaa  SwitchPortAccessReg1    ; load A with memory contents
           bita  #0x10         ;  -00010000-
           beq   LCCCC         ; branch if equal (zero)
           bset  *BitFlags72, #b72_bit2    ; set bits
           ldaa  #0x04         ; load a with value -00000100-
           staa  PIA_Ctrl_4
   LCCCC:  ldd   InjectorPulsewidth_HB    ; load D (A&B) with memory contents
           addd  Temp5         ; D = D + memory contents
           subd  IPWRDX_InjectorPulsewidthReductionColdStart    ;  (data is 0000)
           bcc   LCCD8         ; branch if greater or equal
           ldd   #0x0000        ; load D (A&B) with value -00000000 00000000-
   LCCD8:  lsrd                ; shift right (D=D/2)
           lsrd                ; shift right (D=D/2)
           addd  CCDTemp_X 
           bcc   LCCE2         ; branch if greater or equal
           ldd   #0xFFFF        ; load D (A&B) with value -11111111 11111111-
   LCCE2:  std   CCDTemp_X 
           ldd   Pulsewidth_AISEnrichment_HB    ; load D (A&B) with memory contents
           subd  MINPTE_MinPWForPartThorttleEnrich    ;  (data is 0003)
           bcc   LCCEF         ; branch if greater or equal
           ldd   #0x0000        ; load D (A&B) with value -00000000 00000000-
   LCCEF:  std   Pulsewidth_AISEnrichment_HB    ; store D (A&B) into memory
           rti                 ; return from interrupt

   LCCF2:  ldd   #0x1410       ; load D (A&B) with value -00010100 00010000-
           staa  CPU_A2DControlReg
           stab  CPU_TimerInterruptFlag1    ; store B into memory
           clra                ; A = 0
           brset *BitFlags6F, #b6f_FuelEngineNotRunning, LCD08    ; branch if bit(s) set
   LCD00:  ldaa  CPU_A2DControlReg    ; load A with memory contents
           bpl   LCD00         ; branch if plus (hi bit 0)
           ldaa  CPU_A2DResults3    ; load A with memory contents
   LCD08:  staa  KnockVolts    ; store A into memory
           ldd   #0x1040       ; load D (A&B) with value -00010000 01000000-
           staa  CPU_A2DControlReg
           orab  PIA1_Buffer
           stab  PIA1_Buffer    ; store B into memory
           stab  PortX_Control    ; store B into memory
   LCD17:  ldaa  CPU_A2DControlReg    ; load A with memory contents
           bpl   LCD17         ; branch if plus (hi bit 0)
           rti                 ; return from interrupt

FALLING_EDGE_INTERRUPT:
           bset  *BitFlags6D, #$%00000001    ; set bits
           ldaa  Counter_TimerPastHalfwayBetweenCamPulses    ; load A with memory contents
           lsra                ; logic shift right A
           staa  TimerOverflowsBetweenDistPulses    ; store A into memory
           ldd   CPU_DistPickupCaptureRegHigh
           subd  LastDistributorFallingEdgeTime    ; D = D - memory contents
           std   DistributorFallingEdgePulsewidth_HB    ; store D (A&B) into memory
           ldd   CPU_DistPickupCaptureRegHigh
           std   LastDistributorFallingEdgeTime    ; store D (A&B) into memory
           clra                ; A = 0
           staa  Counter_TimerPastHalfwayBetweenCamPulses    ; store A into memory
           ldaa  CPU_TimerControlReg2    ; load A with memory contents
           oraa  #0x10         ;  -00010000-
           anda  #0xdf         ; AND a with value -11011111-
           staa  CPU_TimerControlReg2
           brset *BitFlags72, #b72_AlternatorField, LCD46    ; branch if bit(s) set
           brset *BitFlags68, #b68_BladePassedSensor, LCD47    ; branch if bit(s) set
   LCD46:  rti                 ; return from interrupt

   LCD47:  ldab  PIA1_Buffer    ; load B with memory contents
           orab  #0x02         ;  -00000010-
           stab  PIA1_Buffer    ; store B into memory
           stab  PortX_Control    ; store B into memory
           brclr *BitFlags72, #b72_bit7, LCD7B    ; branch if bit(s) clear
           ldab  BitFlags72    ; load B with memory contents
           andb  #b72_InjectorAandB         ;  -00000011-
           ldx   #CylPWOffsetValueTable     ; load index with value
           abx                 ; add B to index
           ldab  0x00, X      ; load B with memory at index + value -00000000-
           ldx   #InjectorPulsewidth_HB_Cyl1    ; load index with value
           abx                 ; add B to index
           ldd   BaseInjectorPulsewidth_HB    ; load D (A&B) with memory contents
           std   0x00, X      ; store D into index plus offset -00000000-
           cpd   #MapAverageValue_LB    ;  -00000000 01111101-
           bls   LCD7B         ; branch if lower or same
           ldaa  SwitchPortAccessReg1    ; load A with memory contents
           bita  #0x10         ;  -00010000-
           beq   LCD7B         ; branch if equal (zero)
           bset  *BitFlags72, #b72_bit2    ; set bits
           ldaa  #0x04         ; load a with value -00000100-
           staa  PIA_Ctrl_4
   LCD7B:  ldaa  Counter_EPP_MaxFF    ; load A with memory contents
           inca                ; increment A
           beq   LCD82         ; branch if equal (zero)
           staa  Counter_EPP_MaxFF    ; store A into memory
   LCD82:  ldab  Counter_FallingEdgeEPP_MaxFF    ; load B with memory contents
           asld                ; shift left (D=D*2)
           addb  #0x02         ;  -00000010-
           bcs   LCD8C         ; branch if lower
           lsrd                ; shift right (D=D/2)
           stab  Counter_FallingEdgeEPP_MaxFF    ; store B into memory
   LCD8C:  clra                ; A = 0
           ldab  TimerOverflowsBetweenDistPulses    ; load B with memory contents
           beq   HandleFuelStartRunStartTransfer    ; branch if equal (zero)
           bset  *BitFlags6F, #b6f_FuelEngineNotRunning | b6f_Starting | b6f_DisableNormalDwell
           staa  Timer_NormalDwell    ; store A into memory
           bra   LCE04         ; branch

HandleFuelStartRunStartTransfer:
           ldab  DistributorFallingEdgePulsewidth_HB    ; load B with memory contents
           cmpb  RNFPRD_FuelStartRunTransferPointRpm    ; compare B with memory contents (data is 5a)
           bcc   RpmBelowStartRunTransfer    ; branch if greater or equal
           brclr *BitFlags6F, #b6f_FuelEngineNotRunning, LCDCE    ; branch if bit(s) clear
           bclr  *BitFlags6F, #b6f_FuelEngineNotRunning | b6f_JustStarted
           staa  KeyOnOrEngineRunningTime    ; store A into memory
           staa  Counter_MainLoop    ; store A into memory
           bset  *BitFlags6D, #$%00001000    ; set bits
           ldaa  AISDLY_DelayFromStartRunThatAisFeedbackDisabled    ; load A with memory contents (data is 4b)
           staa  Timer_CountdownFromStartRunForAisFeedback    ; store A into memory
           brclr *b5D_IPL2, #$%00000010, LCDBA    ; branch if bit(s) clear
           ldaa  #0xff         ; load a with value -11111111-
           bra   LCDC2         ; branch

   LCDBA:  ldaa  AdaptiveRetardIndex    ; load A with memory contents
           suba  ARSUBC_AdaptiveRetardFactorSubtract    ;  (data is ff)
           bcc   LCDC2         ; branch if greater or equal
           clra                ; A = 0
   LCDC2:  staa  AdaptiveRetardIndex    ; store A into memory
           bra   LCDCE         ; branch

RpmBelowStartRunTransfer:
           cmpb  STFPRD_FuelRunStartTransferPointRpm    ; compare B with memory contents (data is 82)
           bcs   LCDCE         ; branch if lower
           bset  *BitFlags6F, #b6f_FuelEngineNotRunning | b6f_Starting
   LCDCE:  ldaa  #0xff         ; load a with value -11111111-
           cmpb  SKAPRD_SparkImmediateSwitchToRunAboveThisRpm    ; compare B with memory contents (data is 48)
           bcs   ENGINE_IDLING_FASTERTHAN_813RPM    ; branch if lower
           cmpb  STRNTR_SparkStartRunTransferPointRpm    ; compare B with memory contents (data is 59)
           bcs   ENGINE_IDLING_BETWEEN598_813RPM    ; branch if lower
           brclr *BitFlags6F, #b6f_DisableNormalDwell, LCDE1    ; branch if bit(s) clear
           clra                ; A = 0
           staa  Timer_NormalDwell    ; store A into memory
   LCDE1:  cmpb  RNSTTR_SparkRunStartTransferPointRpm    ; compare B with memory contents (data is 8e)
           bcs   LCE04         ; branch if lower
           bset  *BitFlags6F, #b6f_DisableNormalDwell    ; set bits
           bra   LCE04         ; branch

ENGINE_IDLING_BETWEEN598_813RPM:
           ldaa  Timer_NormalDwell    ; load A with memory contents
           inca                ; increment A
           beq   LCE01         ; branch if equal (zero)
ENGINE_IDLING_FASTERTHAN_813RPM:
           staa  Timer_NormalDwell    ; store A into memory
           ldx   #SRTIME_SparkEPPsNeededToBeAboveSR_Hot    ; load index with value
           ldab  SRTMTP_SparkTempSwitchPointFor_SRTIME    ; load B with memory contents (data is b0)
           cmpb  CoolantTemp
           bcs   SETTOLOOKFOR_RISINGEDGE_AND_CALCULATE_DWELL    ; branch if lower
           inX                 ; increment index (I=I+1)
SETTOLOOKFOR_RISINGEDGE_AND_CALCULATE_DWELL:
           cmpa  0x00, X      ; compare A with memory at index + value -00000000-
           bcs   LCE04         ; branch if lower
   LCE01:  bclr  *BitFlags6F, #b6f_DisableNormalDwell    ; clear bits
   LCE04:  ldd   DistributorFallingEdgePulsewidth_HB    ; load D (A&B) with memory contents
           subd  DwellTime_HB
           bls   LCE11         ; branch if lower or same
           cpd   MINADW_MinAntiDwellPeriod       ;  -00000001 10010000-
           bcc   LCE14         ; branch if greater or equal
   LCE11:  ldd   MINADW_MinAntiDwellPeriod       ; load D (A&B) with value -00000001 10010000-
   LCE14:  std   AntiDwellTime_HB    ; store D (A&B) into memory
           brset *BitFlags68, #b68_SparkEngineNotRunning, LCE85    ; branch if bit(s) set
           ldab  CPU_A2DResults1    ; load B with memory contents
           stab  MapVolts      ; store B into memory
           ldaa  BitFlags648e    ; load A with memory contents
           anda  #0x0f         ; AND a with value -00001111-
           inca                ; increment A
           cmpa  MPDELX_DeltaMapThatChecksGoodX    ; compare A with memory contents (data is 02)
           bcc   LCE50         ; branch if greater or equal
           inc   BitFlags648e
           jmp   LCEE2


;	.org	0xce30
LCE30:
HighRPMMapCheckValues:
	.word	0x7070
	.word	0x3020
	.word	0x1010
	.word	0x0000
	.word	0x0000
	.word	0x0000
	.word	0x0000
	.word	0x0000
LowRPMMapCheckValues:
	.word	0xF0F0
	.word	0xB080
	.word	0x5040
	.word	0x3030
	.word	0x2020
	.word	0x2010
	.word	0x1010
	.word	0x1010

   LCE50:  ldx   #BitFlags648e    ; load index with value
           bclr  0x00, X, #$%00001111    ; clear bits -00000000-
           ldaa  MapValue_X     ; load A with memory contents
           suba  MapVolts_X 
           stab  MapValue_X     ; store B into memory
           stab  MapVolts_X     ; store B into memory
           brset *b5C_IPL1, #$%10000000, LCE87    ; branch if bit(s) set
           cmpa  MPDELT_DeltaMapThatChecksGood    ; compare A with memory contents (data is 01)
           bcc   LCEDC         ; branch if greater or equal
           ldd   EngineRpm_HB    ; load D (A&B) with memory contents
           cpd   MPRPML_DisableMapCheckUnderThisRpm_600    ;  (data is 12c0)
           bcs   LCEE2         ; branch if lower
           cpd   MPRPMH_DisableMapCheckAboveThisRpm_1500    ;  (data is 2ee0)
           bcc   LCEE2         ; branch if greater or equal
           ldaa  MapVolts      ; load A with memory contents
           cmpa  MPDAGL_DisableMapCheckBelowThisMap    ; compare A with memory contents (data is 10)
           bcs   LCEE2         ; branch if lower
           cmpa  MPDAGH_DisableMapCheckAboveThisMap    ; compare A with memory contents (data is 81)
           bcs   LCEAB         ; branch if lower
   LCE85:  bra   LCEE2         ; branch

   LCE87:  suba  MPDELT_DeltaMapThatChecksGood    ;  (data is 01)
           bcs   LCEDC         ; branch if lower
           cmpa  MPDELA_MatureMapLimpinWhenDeltaAbove_MPDELT_plus_MPDELA    ; compare A with memory contents (data is 01)
           bcs   LCEDC         ; branch if lower
           ldd   VehicleSpeed_HB    ; load D (A&B) with memory contents
           cpd   #CCDFlags3    ;  -00000000 01000000-
           bcc   LCEAB         ; branch if greater or equal
           brset *BitFlags66, #b66_OffIdle, LCEAB    ; branch if bit(s) set
           ldd   EngineRpm_HB    ; load D (A&B) with memory contents
           subd  TargetIdleSpeedHB    ; D = D - memory contents
           bcc   LCEA5         ; branch if greater or equal
           coma                ; 1's complement A
           comb                ; 1's complement B
   LCEA5:  cpd   MPRMPD_CheckMapAtZeroSpeedAndThisDeltaRpm    ;  (data is 0200)
           bcs   LCEDC         ; branch if lower
   LCEAB:  ldab  BitFlags648e    ; load B with memory contents
           addb  #0x10         ;  -00010000-
           bcc   LCEB4         ; branch if greater or equal
           orab  #0xf0         ;  -11110000-
   LCEB4:  stab  BitFlags648e    ; store B into memory
           ldab  MPDELX_DeltaMapThatChecksGoodX    ; load B with memory contents (data is 02)
           ldx   #LCE30        ; load index with value
           abx                 ; add B to index
           ldaa  EngineRpm_HB    ; load A with memory contents
           cmpa  #0x20         ; compare a with value -00100000-
           bls   LCEC7         ; branch if lower or same
           ldab  #0x10         ; load B with value -00010000-
           abx                 ; add B to index
   LCEC7:  ldaa  0x00, X      ; load A with memory at index + value -00000000-
           cmpa  BitFlags648e    ; compare A with memory contents
           bcc   LCEE2         ; branch if greater or equal
           brset *b5C_IPL1, #$%10000000, LCED7    ; branch if bit(s) set
           bset  *BitFlags5E, #$%10000000    ; set bits
           bra   LCEDC         ; branch

   LCED7:  ldaa  #0x08         ; load a with value -00001000-
           jsr   ResetErrorCodeIfTimerExpired    ; call subroutine
   LCEDC:  ldx   #BitFlags648e    ; load index with value
           bclr  0x00, X, #$%11110000    ; clear bits -00000000-
   LCEE2:  ldaa  TimerOverflowsBetweenDistPulses    ; load A with memory contents
           bne   SetupDwellToClearWhenTimeMatches    ; branch if not equal (not zero)
           brclr *BitFlags6F, #b6f_DisableNormalDwell, ReadKnockSensorAndRecalcSparkPosition    ; branch if bit(s) clear
SetupDwellToClearWhenTimeMatches:
           ldaa  CPU_TimerControlReg1    ; load A with memory contents
           oraa  #0x03         ;  -00000011-
           staa  CPU_TimerControlReg1
           jmp   ForceDwellOutputChange

ReadKnockSensorAndRecalcSparkPosition:
           ldx   #Cylinder2Retard    ; load index with value
           ldab  BitFlags72    ; load B with memory contents
           andb  #b72_InjectorAandB         ;  -00000011-
           abx                 ; add B to index
           ldaa  CalculatedSparkAdvance    ; load A with memory contents
           ldab  MaxRetardFromMAP    ; load B with memory contents
           cmpb  0x00, X      ;  -00000000-
           bcs   LCF09         ; branch if lower
           suba  0x00, X      ;  -00000000-
           bra   CheckAndSetMinimumAdvance    ; branch

   LCF09:  sba                 ; subtract (A=A-B)
CheckAndSetMinimumAdvance:
           bcc   StoreAdvanceToTemp5    ; branch if greater or equal
           ldab  CODE13_       ; load B with memory contents (data is 14)
           andb  #0x10         ;  -00010000-
           bne   AlternateMinimumAdvance    ; branch if not equal (not zero)
           clra                ; A = 0
           bra   StoreAdvanceToTemp5    ; branch

AlternateMinimumAdvance:
           cmpa  #0xf4         ; compare a with value -11110100-
           bcc   StoreAdvanceToTemp5    ; branch if greater or equal
           ldaa  #0xf4         ; load a with value -11110100-
StoreAdvanceToTemp5:
           staa  Temp5         ; store A into memory
           jsr   HandleSparkScatter    ; call subroutine
           ldaa  #0x10         ; load a with value -00010000-
           staa  CPU_A2DControlReg
           ldaa  Temp5         ; load A with memory contents
           jsr   NULL_ROUTINE    ; call subroutine
           staa  Temp5         ; store A into memory
           staa  AdvanceTemp

; v2 code paste
; IncludeAntiLag:
;            ; re-routed this jump to use the anti-lag lookup value
;            jsr  CalculateSparkCutandAntiLagRetard_Routine    ; call subroutine
;            staa Temp5	    ; store a into memory
;            staa FinalAdvanceActual

           ldaa  #0xa6         ; 83 degrees - distance from ref to sync shutters
           suba  Temp5     
           ldab  #0xb6         ; 71%
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           ldy   DistributorFallingEdgePulsewidth_HB
           jsr   ScaleYbyA     ; call subroutine
           xgdy                ; exchange D and index
           addd  LastDistributorFallingEdgeTime    ; D = D + memory contents
           std   Temp6         ; store D (A&B) into memory
           addd  AntiDwellTime_HB    ; D = D + memory contents
           subd  DistributorFallingEdgePulsewidth_HB    ; D = D - memory contents
           std   CPU_Timer_OC5_DwellB

; v2 code paste
; here, add code to prevent ouput if spark cut is desired... - set bits and jump...
;            ldy  #Turbonator_Flags
;            brset 0, y, #Turbonator_AllowSpark, NormalCoilOffTimeLoad ; skip TCR1 stuff if spark is off
;original stock code below...

NormalCoilOnTimeLoad:

           ldab  CPU_TimerControlReg1    ; load B with memory contents
           orab  #0x03         ;  -00000011-
           stab  CPU_TimerControlReg1    ; store B into memory
           ldx   DistributorFallingEdgePulsewidth_HB
           cpx   #0x7800       ;  -01111000 00000000-
           bcc   LCF8A         ; branch if greater or equal
           ldd   CPU_Timer_OC5_DwellB
           subd  #0x0084    ;  -00000000 10000100-
           subd  CPU_TimerCounterRegHigh
           bpl   LCF8A         ; branch if plus (hi bit 0)
           ldaa  #0x08         ; load a with value -00001000-
           staa  CPU_HardwareTimerForceCompare
           ldd   Temp6         ; load D (A&B) with memory contents
           std   CPU_Timer_OC5_DwellB
           ldaa  #0x08         ; load a with value -00001000-
           staa  CPU_TimerInterruptFlag1
           ldaa  CPU_TimerControlReg1    ; load A with memory contents
           anda  #0xfe         ; AND a with value -11111110-
           staa  CPU_TimerControlReg1

; v2 code paste
           ; not sure if this will help or not, seems to work as-is
;            brclr 0, y, #Turbonator_AllowSpark, ForceDwellOutputChange ; ensure coil is off if cutting spark

           ldd   CPU_Timer_OC5_DwellB
           subd  CPU_TimerCounterRegHigh
           bpl   LCF8A         ; branch if plus (hi bit 0)

ForceDwellOutputChange:
           ldaa  #0x08         ; load a with value -00001000-
           staa  CPU_HardwareTimerForceCompare
   LCF8A:  rti                 ; return from interrupt

Interrupt_RealTime:
           ldab  #0x01         ; load B with value -00000001-
           bra   LCFA9         ; branch

Interrupt_XIRQ:
           ldab  #0x02         ; load B with value -00000010-
           bra   LCFA9         ; branch

Interrupt_COPFail:
           ldab  #0x04         ; load B with value -00000100-
           bra   LCFA9         ; branch

Interrupt_ClockMonFail:
           ldab  #0x08         ; load B with value -00001000-
           bra   LCFA9         ; branch

Interrupt_BadOp:
           ldab  #0x10         ; load B with value -00010000-
           bra   LCFA9         ; branch

Interrupt_Software:
           ldab  #0x20         ; load B with value -00100000-
           bra   LCFA9         ; branch

Interrupt_PulseAccumulatorInputEdge:
           ldab  #0x40         ; load B with value -01000000-
           bra   LCFA9         ; branch

Interrupt_PIA_Signal:
           ldab  #0x80         ; load B with value -10000000-
   LCFA9:  stab  Temp0         ; store B into memory
           orab  L0000     
           stab  L0000         ; store B into memory
           tsx                 ; transfer stack to index (I=sp+1)
           ldd   0x07, X      ;  -00000111-
           std   L0001         ; store D (A&B) into memory
           std   Temp1         ; store D (A&B) into memory
           sei                 ; disable interrupts
           lds   #TopOfStack       ;  -01100100 11111111-
           ldd   #0xb978       ; load D (A&B) with value -10111001 01111000-
           staa  CPU_SysConfigOptionReg
           stab  CPU_HighPriorityInterruptMask    ; store B into memory
           ldd   #0x0001        ; load D (A&B) with value -00000000 00000001-
           staa  CPU_PortA_Control
           stab  CPU_TimerInterruptMask2    ; store B into memory
           clra                ; A = 0
           staa  CPU_OutputCompare1Mask
           ldd   #0x2a18       ; load D (A&B) with value -00101010 00011000-
           staa  CPU_TimerControlReg1
           stab  CPU_TimerControlReg2    ; store B into memory
           ldaa  #0x78         ; load a with value -01111000-
           staa  CPU_HardwareTimerForceCompare
           ldab  #0x02         ; load B with value -00000010-
           stab  BitFlags_AIS    ; store B into memory
           ldd   L0003         ; load D (A&B) with memory contents
           std   Temp3         ; store D (A&B) into memory
           ldd   #0xaaa5       ; load D (A&B) with value -10101010 10100101-
           cpd  L0003         ; D = D - memory contents
           beq   LD031         ; branch if equal (zero)
           decb                ; decrement B
           stab  Temp4         ; store B into memory
           bra   LD031         ; branch

ResetInterrupt:
           sei                 ; disable interrupts
           lds   #TopOfStack       ;  -01100100 11111111-
           ldd   #0xb978       ; load D (A&B) with value -10111001 01111000-
           staa  CPU_SysConfigOptionReg
           stab  CPU_HighPriorityInterruptMask    ; store B into memory
           ldd   #0x0001        ; load D (A&B) with value -00000000 00000001-
           staa  CPU_PortA_Control
           stab  CPU_TimerInterruptMask2    ; store B into memory
           clra                ; A = 0
           staa  CPU_OutputCompare1Mask
           ldd   #0x2a18       ; load D (A&B) with value -00101010 00011000-
           staa  CPU_TimerControlReg1
           stab  CPU_TimerControlReg2    ; store B into memory
           ldaa  #0x78         ; load a with value -01111000-
           staa  CPU_HardwareTimerForceCompare
           clra                ; A = 0
           clrb                ; b = 0
           staa  Temp0         ; store A into memory
           std   Temp1         ; store D (A&B) into memory
           jsr   CountRamValuesFrom05to38    ; call subroutine
           ldx   #0xaaa5       ; load index with value
           cpd   L0003         ; D = D - memory contents
           beq   LD02F         ; branch if equal (zero)
           ldx   #0x0000        ; load index with value
   LD02F:  stx   Temp3         ; store index into memory
   LD031:  ldx   #SwitchPortAccessReg1    ; load index with value
           ldd   #0x00f8        ; load D (A&B) with value -00000000 11111000-
           staa  0x03, X      ;  -00000011-
           stab  0x06, X      ;  -00000110-
           clra                ; A = 0
           clrb                ; b = 0
           std   0x08, X      ; store D into index plus offset -00001000-
           std   0x0a, X      ; store D into index plus offset -00001010-
           std   0x0c, X      ; store D into index plus offset -00001100-
           std   0x0e, X      ; store D into index plus offset -00001110-
           ldaa  #0x74         ; load a with value -01110100-
           staa  0x40, X      ;  -01000000-
           ldaa  #0x20         ; load a with value -00100000-
           staa  CPU_PortD
           ldd   #0x0003        ; load D (A&B) with value -00000000 00000011-
           staa  0x00, X      ;  -00000000-
           stab  0x02, X      ;  -00000010-
           ldd   #0x3a54       ; load D (A&B) with value -00111010 01010100-
           staa  CPU_PortD_DataDirection
           ldaa  CPU_SerialPeripheralStatus    ; load A with memory contents
           stab  CPU_SerialPeripheralControl    ; store B into memory
           jsr   ResetCopTimer    ; call subroutine
           ldaa  #0xc8         ; load a with value -11001000-
   LD066:  deca                ; decrement A
           bne   LD066         ; branch if not equal (not zero)
           jsr   ResetCopTimer    ; call subroutine
           bclr  *BitFlags_AIS, #$%00111100    ; clear bits
           ldd   Temp3         ; load D (A&B) with memory contents
           std   L0003         ; store D (A&B) into memory
           ldx   #Timer_BoostTimer    ; load index with value
           ldd   L0003         ; load D (A&B) with memory contents
           cpd   #0xaaa5       ;  -10101010 10100101-
           beq   LD0A6         ; branch if equal (zero)
           ldaa  Temp0         ; load A with memory contents
           staa  L0000         ; store A into memory
           ldd   Temp1         ; load D (A&B) with memory contents
           std   L0001         ; store D (A&B) into memory
           ldaa  MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load A with memory contents (data is 5c)
           staa  MINTHR_LowestSessionTPS    ; store A into memory
           bset  *BitFlags_AIS, #$%00100000    ; set bits
           ldab  #0xdf         ; load B with value -11011111-
           stab  CurrentAisPosition    ; store B into memory
           ldaa  #0x80         ; load a with value -10000000-
           staa  Timer_DacalCountdown    ; store A into memory
           staa  DCCOR0_AdaptiveVNTCell0    ; store A into memory
           staa  DCCOR1_AdaptiveWastegateCellBelow3psi    ; store A into memory
           staa  DCCOR2_AdaptiveWastegateCellTo4000rpm    ; store A into memory
           staa  DCCOR3_AdaptiveWastegateCellTo4992rpm    ; store A into memory
           staa  DCCOR4_AdaptiveWastegateCellTo5504rpm    ; store A into memory
           jsr   EraseErrorCodes    ; call subroutine
           ldx   #AutoCalCell0    ; load index with value
   LD0A6:  clrb                ; b = 0
           stab  CPU_A2DControlReg    ; store B into memory
   LD0AA:  stab  0x00, X      ;  -00000000-
           inX                 ; increment index (I=I+1)
           cpx   #0x00FF        ;  -00000000 11111111-
           bls   LD0AA         ; branch if lower or same
           ldaa  #0x09         ; load a with value -00001001-
           staa  SwitchPortAccessReg1
           tsx                 ; transfer stack to index (I=sp+1)
   LD0B8:  deX                 ; decrement index (I=I-1)
           stab  0x00, X      ;  -00000000-
           cpx   #ErrorCodeCounter    ;  -01100100 10000000-
           bhi   LD0B8         ; branch if higher
           ldaa  CPU_A2DResults1    ; load A with memory contents
           ldab  #0x14         ; load B with value -00010100-
           stab  CPU_A2DControlReg    ; store B into memory
           staa  MapVolts      ; store A into memory
           jsr   SaveBaroPressure    ; call subroutine
           staa  MapValue      ; store A into memory
           staa  MapAverageValue_HB    ; store A into memory

; v2 code paste
;            ldy  #Turbonator_Flags
;            bset 0, y, #Turbonator_AllowSpark  ; to allow spark by default
;            clr  Counter_SparkCut
;            ldy  #Pattern_SparkCut
;            bset 0, y, #bit_all ; set all bits to ensure cylidner firing

           ldd   #0x0c22       ; load D (A&B) with value -00001100 00100010-
           staa  CPU_SerialControlReg2
           stab  CPU_SerialBaudRate    ; store B into memory
           clra                ; A = 0
           staa  CPU_SerialControlReg1
           jsr   ResetCopTimer    ; call subroutine
           ldaa  #0x75         ; load a with value -01110101-
           staa  PIA1_Buffer    ; store A into memory
           ldd   CPU_A2DResults1
           cmpa  #0x40         ; compare a with value -01000000-
           bcc   LD0EF         ; branch if greater or equal
           bclr  *PIA1_Buffer, #$%00010000    ; clear bits
   LD0EF:  cmpb  #0x40         ;  -01000000-
           bcc   LD0F6         ; branch if greater or equal
           bclr  *PIA1_Buffer, #$%00100000    ; clear bits
   LD0F6:  ldaa  PIA1_Buffer    ; load A with memory contents
           staa  PortX_Control
           ldaa  #0x14         ; load a with value -00010100-
           staa  CPU_A2DControlReg
           jsr   ResetCopTimer    ; call subroutine
           bclr  *BitFlags37, #$%01001000    ; clear bits
           bset  *BitFlags_AIS, #$%10000000    ; set bits
           ldaa  #0xbe         ; load a with value -10111110-
           staa  CPU_TimerInterruptMask1
           ldab  #0xff         ; load B with value -11111111-
           stab  CPU_TimerInterruptFlag1    ; store B into memory
           stab  Counter_TimerPastHalfwayBetweenCamPulses    ; store B into memory
           stab  TimerOverflowsBetweenDistPulses    ; store B into memory
           stab  Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; store B into memory
           stab  TimerOverflowsBetweenSpeedoPulses    ; store B into memory
           bset  *CruiseStatus_1, #$%10100000    ; set bits
           ldaa  #0x80         ; load a with value -10000000-
           staa  Counter_Cruise_1    ; store A into memory
           bset  *BitFlags6C, #$%00000010    ; set bits
           ldaa  LB616         ; load A with memory contents (data is ff)
           cmpa  #0x4a         ; compare a with value -01001010-
           bne   LD132         ; branch if not equal (not zero)
           coma                ; 1's complement A
           cmpa  LB615         ; compare A with memory contents (data is ff)
           beq   LD135         ; branch if equal (zero)
   LD132:  bclr  *BitFlags6C, #$%00000010    ; clear bits
   LD135:  bclr  *BitFlags6C, #$%00001100    ; clear bits
           ldaa  L0004         ; load A with memory contents
           cmpa  #0xa4         ; compare a with value -10100100-
           beq   LD147         ; branch if equal (zero)
           ldaa  BitFlags_AIS    ; load A with memory contents
           tab                 ; B = A
           andb  #0x03         ;  -00000011-
           cmpb  #0x02         ;  -00000010-
           bne   LD155         ; branch if not equal (not zero)
   LD147:  ldd   #0x0aff       ; load D (A&B) with value -00001010 11111111-
           staa  DRBPointer1    ; store A into memory
           stab  DRBPointer2    ; store B into memory
           ldd   #0xf1ff       ; load D (A&B) with value -11110001 11111111-
           staa  LastDistributorFallingEdgeTime    ; store A into memory
           bra   LD15A         ; branch

   LD155:  inc   BitFlags_AIS
           ldab  #0xef         ; load B with value -11101111-
   LD15A:  stab  PIA2_Buffer    ; store B into memory
           ldaa  #0xbf         ; load a with value -10111111-
           staa  StartupSwitchMirror2    ; store A into memory
           ldaa  PIA1_Buffer    ; load A with memory contents
           anda  #0xfb         ; AND a with value -11111011-
           staa  PortX_Control
           stab  CPU_SerialPeripheralDataIO    ; store B into memory
           ldaa  #0x03         ; load a with value -00000011-
           staa  Timer_DelayBeforeUpdating_MINTHR    ; store A into memory
           ldd   #0x0c28       ; load D (A&B) with value -00001100 00101000-
           staa  BitFlags66    ; store A into memory
           ldaa  CPU_PortA     ; load A with memory contents
           bita  #0x04         ;  -00000100-
           bne   LD17C         ; branch if not equal (not zero)
           ldab  #0x18         ; load B with value -00011000-
   LD17C:  stab  CPU_TimerControlReg2    ; store B into memory
           bset  *BitFlags6F, #b6f_FuelEngineNotRunning  | b6f_Starting | b6f_DisableNormalDwell
           ldaa  #0x14         ; load a with value -00010100-
           staa  BitFlags67    ; store A into memory
           ldaa  PIA1_Buffer    ; load A with memory contents
           staa  PortX_Control
           jsr   ResetCopTimer    ; call subroutine
           ldx   #0x074b       ; load index with value
   LD191:  ldaa  SwitchPortAccessReg1    ; load A with memory contents
           bita  #0x10         ;  -00010000-
           bne   LD19B         ; branch if not equal (not zero)
           deX                 ; decrement index (I=I-1)
           bne   LD191         ; branch if not equal (not zero)
   LD19B:  jsr   ResetCopTimer    ; call subroutine
           ldab  #0x14         ; load B with value -00010100-
           stab  CPU_A2DControlReg    ; store B into memory
   LD1A3:  ldaa  CPU_A2DControlReg    ; load A with memory contents
           bpl   LD1A3         ; branch if plus (hi bit 0)
           ldaa  #0xc1         ; load a with value -11000001-
           staa  AmbientAirTempVolts    ; store A into memory
           ldd   CPU_A2DResults1
           std   LastCoolantTempVolts    ; store D (A&B) into memory
           ldab  #0x10         ; load B with value -00010000-
           stab  CPU_A2DControlReg    ; store B into memory
           ldx   #TMPTL2_TempForHotScaleA2D    ; load index with value
           brclr *PIA1_Buffer, #$%00010000, LD1C0    ; branch if bit(s) clear
           ldx   #TMPTL1_TempForColdScaleA2D    ; load index with value
   LD1C0:  jsr   Lookup4ByteTable    ; call subroutine
           staa  CoolantTemp    ; store A into memory
           ldaa  LastChargeTempVolts    ; load A with memory contents
           ldx   #TMPTL2_TempForHotScaleA2D    ; load index with value
           brclr *PIA1_Buffer, #$%00100000, LD1D1    ; branch if bit(s) clear
           ldx   #TMPTL1_TempForColdScaleA2D    ; load index with value
   LD1D1:  jsr   Lookup4ByteTable    ; call subroutine
           staa  ChargeTempVolts    ; store A into memory
           ldaa  ERTDLC_ResetEngRunTimerBelowThisDeltaCoolantTemp    ; load A with memory contents (data is 05)
           beq   LD1EF         ; branch if equal (zero)
           ldaa  CoolantTemp    ; load A with memory contents
           staa  Temp0_X   
           ldab  PreviousCoolantTemp    ; load B with memory contents
           stab  Temp1_X       ; store B into memory
           suba  PreviousCoolantTemp
           bcc   LD1EA         ; branch if greater or equal
           nega                ; negate A (set high bit)
   LD1EA:  cmpa  ERTDLC_ResetEngRunTimerBelowThisDeltaCoolantTemp    ; compare A with memory contents (data is 05)
           bcs   LD1F2         ; branch if lower
   LD1EF:  clr   EngineRunningTimeMaxFF    ; zero byte at memory location
   LD1F2:  ldaa  CoolantTemp    ; load A with memory contents
           staa  PreviousCoolantTemp    ; store A into memory
           cmpa  TTEMPL_TstatDiagnosticsMinTempToArmDiagnosticsAtStartup    ; compare A with memory contents (data is 63)
           bcs   LD203         ; branch if lower
           cmpa  TTEMPH_TstatDiagnosticsMaxTempToArmDiagnosticsAtStartup    ; compare A with memory contents (data is e4)
           bcc   LD203         ; branch if greater or equal
           inc   Timer_ThermostatDiagnostics
   LD203:  ldx   #PRSHOT_KeyOnPrimePW    ; load index with value
           ldaa  CoolantTemp    ; load A with memory contents
           jsr   Lookup4ByteTable    ; call subroutine
           ldab  #0xfa         ; load B with value -11111010-
           mul                 ; multiply (D=A*B)
           std   InjectorPulsewidth_HB    ; store D (A&B) into memory
           jsr   ResetCopTimer    ; call subroutine
           ldaa  CPU_A2DResults2    ; load A with memory contents
           staa  BatteryVolts    ; store A into memory
           ldx   #BATOFF_FuelBatteryOffset    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           ldaa  DRBPointer1    ; load A with memory contents
           cmpa  #0x0a         ; compare a with value -00001010-
           beq   LD239         ; branch if equal (zero)
           clra                ; A = 0
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           addd  InjectorPulsewidth_HB    ; D = D + memory contents
           bcc   LD22D         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   LD22D:  std   InjectorPulsewidth_HB_Cyl1
           std   InjectorPulsewidth_HB_Cyl2
           std   InjectorPulsewidth_HB_Cyl3
           std   InjectorPulsewidth_HB_Cyl4
   LD239:  bset  *CCDFlags2, #$%00001100    ; set bits
           bset  *BitFlags6A, #b6a_DRBToggle1    ; set bits
           ldd   CPU_A2DResults3
           std   O2SensorVolts    ; store D (A&B) into memory
           stab  TPSVolts      ; store B into memory
           stab  TpsAverageValue_HB    ; store B into memory
           ldaa  MINTHR_LowestSessionTPS    ; load A with memory contents
           adda  MININC_Amount_MINTHR_IsIncreasedAtKeyOnOnly    ;  (data is 03)
           cmpa  MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; compare A with memory contents (data is 5c)
           bcs   LD25B         ; branch if lower
           addb  #0x06         ;  -00000110-
           ldaa  MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load A with memory contents (data is 5c)
           cba                 ; compare A to B
           bcs   LD25B         ; branch if lower
           tba                 ; A = B
   LD25B:  staa  MINTHR_LowestSessionTPS    ; store A into memory
           jsr   IncludeCylTrimWithAdaptiveCells    ; call subroutine
           jsr   ResetCopTimer    ; call subroutine
           ldd   CPU_TimerCounterRegHigh
           addd  #DCCOR4_AdaptiveWastegateCellTo5504rpm    ;  -00000000 00001010-
           std   CPU_TimerOutputCompareRegHigh1
           addd  #0x14f6       ;  -00010100 11110110-
           asld                ; shift left (D=D*2)
           staa  MinimumTimerCountBeforeMainloopCanContinue
           ldaa  CoolantTemp    ; load A with memory contents
           cmpa  CLTRP3_Cyl3TrimValueForPurgeVolume    ; compare A with memory contents (data is db)
           bls   LD27D         ; branch if lower or same
           bset  *BitFlags6A, #b6a_Cruise1    ; set bits
   LD27D:  cli                 ; enable interrupts
           jmp   MainProgramLoop

ControlPTU_MM:

           brclr *BitFlags37, #bf37_ATX, LD2F9    ; ATX indicator copy
           ldaa  PreviousMAPTemp    ; load A with memory contents
           staa  Temp0         ; store A into memory
           ldaa  Counter_MainLoop    ; load A with memory contents
           bita  PTUCNI_PTUCounterTimerIntervalForLoop    ;  (data is 07)
           bne   LD296         ; branch if not equal (not zero)
           ldaa  MapValue      ; load A with memory contents
           staa  PreviousMAPTemp
   LD296:  ldaa  TPSVolts      ; load A with memory contents
           suba  MINTHR_LowestSessionTPS
           bls   PTU_SetPTUBits         ; branch if lower or same
           staa  Temp4         ; store A into memory
           ldaa  CoolantTemp    ; load A with memory contents
           cmpa  PTUMTP_PTUMinLockTemperature  ;CoolantTempForMysteryRoutine    ; compare A with memory contents (data is c1)
           bcs   PTU_SetPTUBits         ; branch if lower
           brclr *BitFlags_AIS, #$%00001000, PTU_SetPTUBits    ; branch if bit(s) clear
           brset *StartupSwitchMirror1, #$%00100000, PTU_SetPTUBits    ; branch if bit(s) set
           ldd   VehicleSpeed_HB    ; load D (A&B) with memory contents
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           bcs   LD2C6         ; branch if lower
           cmpa  PTUMSP_PTUMinLockSpeed    ; compare A with memory contents (data is 5a)
           bcc   LD2C6         ; branch if greater or equal
           ldaa  MapValue      ; load A with memory contents
           suba  Temp0
           bcs   LD2C6         ; branch if lower
           cmpa  PTUMP3_PTUMAPThresholdForLock3    ; compare A with memory contents (data is 19)
           bcc   PTU_SetPTUBits         ; branch if greater or equal
           bra   LD2FA         ; branch

   LD2C6:  ldaa  Temp0         ; load A with memory contents
           suba  MapValue  
           bcs   LD2FA         ; branch if lower
           staa  Temp0         ; store A into memory
           ldx   #PTUMP1_PTUMAPThresholdForLock1    ; load index with value
           brset *BitFlags6A, #b6a_Cruise3, LD2E9    ; branch if bit(s) set
           brset *BitFlags6A, #b6a_Cruise4, LD2E8    ; branch if bit(s) set
           ldaa  Temp4         ; load A with memory contents
           cmpa  PTUDTP_PTUDeltaTPSForUnlock    ; compare A with memory contents (data is 29)
           bcs   LD2E5         ; branch if lower
           bset  *BitFlags6A, #b6a_Cruise3    ; set bits
           bra   LD2E9         ; branch

   LD2E5:  bset  *BitFlags6A, #b6a_Cruise4    ; set bits
   LD2E8:  inX                 ; increment index (I=I+1)
   LD2E9:  ldab  Temp0         ; load B with memory contents
           cmpb  0x00, X      ;  -00000000-
           bcs   LD2FD         ; branch if lower

PTU_SetPTUBits:
           bset  *StartupSwitchMirror2, #$%00100000    ; set bits
           bclr  *BitFlags6A, #b6a_Cruise4 | b6a_Cruise3    ; clear bits
           clrb                ; b = 0
   LD2F6:  stab  DownCounterUnknown    ; store B into memory
   LD2F9:  rts                 ; return from subroutine

   LD2FA:  bclr  *BitFlags6A, #b6a_Cruise4 | b6a_Cruise3    ; clear bits
   LD2FD:  ldab  DownCounterUnknown    ; load B with memory contents
           cmpb  #0x01         ;  -00000001-
           bls   LD307         ; branch if lower or same
           decb                ; decrement B
           bra   LD2F6         ; branch

   LD307:  ldx   #PTUUUL_UpperLimitForPTUUnlock    ; load index with value
           brclr *StartupSwitchMirror2, #$%00100000, LD311    ; branch if bit(s) clear
           ldx   #PTULUL_UpperLimitForPTULock    ; load index with value
   LD311:  bsr   LookupTableFromVehSpdAndCompareToTPS    ; call subroutine
           bls   PTU_SetPTUBits         ; branch if lower or same
           ldx   #PTUULL_LowerLimitForPTUUnlock    ; load index with value
           brclr *StartupSwitchMirror2, #$%00100000, LD31F    ; branch if bit(s) clear
           ldx   #PTULLL_LowerLimitForPTULock    ; load index with value
   LD31F:  bsr   LookupTableFromVehSpdAndCompareToTPS    ; call subroutine
           bhi   PTU_SetPTUBits         ; branch if higher
           ldaa  DownCounterUnknown    ; load A with memory contents
           beq   PTU_LookupPTUParam         ; branch if equal (zero)
           bclr  *StartupSwitchMirror2, #$%00100000    ; clear bits
           rts                 ; return from subroutine

PTU_LookupPTUParam:
           ldd   VehicleSpeed_HB    ; load D (A&B) with memory contents
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           ldab  PTUCNH_PTUCounterHiSpeed    ; load B with memory contents (data is 5d)
           bcs   LD2F6         ; branch if lower
           cmpa  PTUMSP_PTUMinLockSpeed    ; compare A with memory contents (data is 5a)
           bcc   LD2F6         ; branch if greater or equal
           ldab  PTUCNL_PTUCounterLoSpeed    ; load B with memory contents (data is b9)
           bra   LD2F6         ; branch

LookupTableFromVehSpdAndCompareToTPS:
           ldd   VehicleSpeed_HB    ; load D (A&B) with memory contents
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           bcc   LD349         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   LD349:  jsr   Lookup4ByteTable    ; call subroutine
           cmpa  Temp4         ; compare A with memory contents
           rts                 ; return from subroutine

MainProgramLoop:
           jsr   DealWithConfigurationAndPulseAccumulator_MM    ; call subroutine
   LD352:  cli                 ; enable interrupts
           ldd   #0x55aa       ; load D (A&B) with value -01010101 10101010-
           staa  CPU_ArmResetCopTimerReg
           stab  CPU_ArmResetCopTimerReg    ; store B into memory
           ldaa  SwitchPortAccessReg1    ; load A with memory contents
           eora  #0x02         ; XOR a with value -00000010-
           staa  SwitchPortAccessReg1
           sei                 ; disable interrupts
           ldaa  CPU_A2DControlReg    ; load A with memory contents
           bpl   LD352         ; branch if plus (hi bit 0)
           ldaa  Counter_MainLoop    ; load A with memory contents
           bita  #0x03         ;  -00000011-
           bne   LD375         ; branch if not equal (not zero)
           ldaa  CPU_A2DResults2    ; load A with memory contents
           staa  BatteryVolts    ; store A into memory
   LD375:  ldd   CPU_A2DResults3
           cli                 ; enable interrupts
           staa  O2SensorVolts    ; store A into memory
           stab  LastTpsVolts    ; store B into memory
           sei                 ; disable interrupts
           ldd   CPU_TimerCounterRegHigh
           std   Temp0         ; store D (A&B) into memory
           ldaa  #0x14         ; load a with value -00010100-
           staa  CPU_A2DControlReg
           ldd   Temp0         ; load D (A&B) with memory contents
           jsr   DetermineNumberOfOverflowsBetweenCamSensorPulses_MM    ; call subroutine
           ldd   Temp0         ; load D (A&B) with memory contents
           jsr   DetermineNumberOfOverflowsBetweenSpeedoPulses_MM    ; call subroutine
   LD392:  ldaa  CPU_A2DControlReg    ; load A with memory contents
           bpl   LD392         ; branch if plus (hi bit 0)
           ldaa  #0x10         ; load a with value -00010000-
           staa  CPU_A2DControlReg
           cli                 ; enable interrupts
           ldaa  Counter_MainLoop    ; load A with memory contents
           bne   LD3B5         ; branch if not equal (not zero)
           jsr   LDFA1         ; call subroutine
           ldx   #CODE13_      ; load index with value
           brset 0x00, X, #$%00010000, LD3B5    ; branch if bit(s) set -00000000-
           ldx   #CONFIG_ConfigurationFlags    ; load index with value
           brclr 0x00, X, #$%00100000, LD3B5    ; branch if bit(s) clear -00000000-
           bset  *BitFlags37, #bf37_ATX    ; set bits
   LD3B5:  ldx   #CODE13_      ; load index with value
           brclr 0x00, X, #$%00010000, LD3C7    ; branch if bit(s) clear -00000000-
           brset *BitFlags37, #bf37_ATX, LD3C7    ; branch if bit(s) set
           brclr *StartupSwitchMirror1, #$%00010000, LD3C7    ; branch if bit(s) clear
           bset  *BitFlags37, #bf37_ATX    ; set bits
   LD3C7:  ;jsr   EmmissionMaintenanceRemider1_MM    ; FIXME
           jsr   DRB_SomethingLikeEMR_MM    ; call subroutine
           ;jsr   EmmissionMaintenanceRemider2_MM    ; FIXME
           jsr   CycleACClutch_MM    ; call subroutine
           jsr   CheckThrottleRoutine_MM    ; call subroutine
           jsr   CheckAndFilterCoolantTempSensor_MM    ; call subroutine
           jsr   CheckAndFilterChargeTempSensor_MM    ; call subroutine
           jsr   ClearKnockCap_MM    ; call subroutine
           jsr   HandleBaroReadRequirement_MM    ; call subroutine
           jsr   CalculateInjectorPulsewidthForStarting_MM    ; call subroutine
           jsr   SomethingWithAIS_MM    ; call subroutine
           jsr   ResetAverageValues_MM    ; call subroutine
           jsr   RescaleRPMFor3D_MM    ; call subroutine
           jsr   ControlCruiseServo0_MM    ; call subroutine
           jsr   ControlCruiseServo1_MM    ; call subroutine
           jsr   ControlAirConditioning_MM    ; call subroutine
           jsr   ControlFan_MM    ; call subroutine
           jsr   CalculateTargetIdleSpeedAndAisPosition_MM    ; call subroutine
           jsr   ControlAsdRelay_MM    ; call subroutine
           jsr   DetectKnockSensorFault_MM    ; call subroutine
           jsr   CalculateSparkAdvance_MM    ; call subroutine
           jsr   PrepareCCDDataForXmit_MM    ; call subroutine
           jsr   CalculateThrottleEnrichmentFactor_MM    ; call subroutine
           jsr   HandleAmTimer_MM    ; call subroutine
           jsr   HandleO2Processing_MM    ; call subroutine
           jsr   ModifyO2FeedbackCountVarToMaintainStoich_MM    ; call subroutine
           jsr   AdaptiveMemory_DetermineWhichCellApplies_MM    ; call subroutine
           jsr   ControlPurgeSolenoid_MM    ; call subroutine
           jsr   AdaptiveMemory_UpdateCellIfRequired_MM    ; call subroutine
           jsr   DetermineIndividualInjectorTrims_MM    ; call subroutine
           jsr   DealWithSpecialIdle_SetBasicTiming_MM    ; call subroutine
           jsr   ControlEngineCutout_MM    ; call subroutine
           jsr   UseCELForKnockIndication_MM  ; FIXME
           jsr   CalculatePartThrottleTransientFuel_MM    ; call subroutine
           jsr   CalculateSumOfAllFuelModifiers_MM    ; call subroutine
           jsr   CalculateKnockRetard_MM    ; call subroutine
           jsr   CalcTargetBoost_MM    ; call subroutine
           jsr   GetControlFeedback_DetermineIfShutdownRequired_MM    ; call subroutine
           
           ; skip from here
           jsr   CheckForErrorsAndSetCodes_MM    ; call subroutine
           jsr   VerifyOperationOfBatteryVoltage_MM    ; call subroutine
           jsr   DetectAlternatorFault_MM    ; call subroutine
           jsr   VerifyOperationOfASDRelayAndO2Sensor_MM    ; call subroutine
           jsr   VerifyOperationOfFuelInjectorDrivers_MM    ; call subroutine
           jsr   VerifyOperationOfIgnitionCoilDriver_MM    ; call subroutine
           jsr   VerifyOperationOfMapSensor_MM    ; call subroutine
           jsr   VerifyOperationOfThermostat_MM    ; call subroutine
           ; to here

           sei                 ; disable interrupts
           ldd   #0xaaa5       ; load D (A&B) with value -10101010 10100101-
           std   L0003         ; store D (A&B) into memory
           cli                 ; enable interrupts
           jsr   DetermineTargetBatteryVoltage_MM         ; call subroutine
           jsr   ControlPTU_MM    ; call subroutine
           ldx   #CODE13_      ; load index with value
           brset 0x00, X, #$%00010000, LD467    ; branch if bit(s) set -00000000-
           jsr   ExhGasRecirc_MM    ; call subroutine
           bra   LD46A         ; branch

   LD467:  jsr   ControlBOV_MM    ; call subroutine
   LD46A:  jsr   ProcessErrorBits_WorkWithData_MM    ; call subroutine
           jsr   ThrowMajorErrorIfRequired_MM    ; call subroutine
           jsr   UpdateErrorTimersAndPossiblyClearErrors_MM    ; call subroutine
           jsr   CheckIfCheckEngineLightShouldBeOn_MM    ; call subroutine
           jsr   DRBIISerialCommunications_MM    ; call subroutine
           jsr   ActuatorTestMode_MM    ; call subroutine
           jsr   DRBIIOuput_MM    ; call subroutine
           jsr   UpdatePIA1AndCheckOuputs_MM    ; call subroutine
           jsr   IncrementLoopCounters_MM    ; call subroutine
           sei                 ; disable interrupts
           ldaa  MinimumTimerCountBeforeMainloopCanContinue    ; load A with memory contents
           ldab  CPU_TimerCounterRegHigh    ; load B with memory contents
           cba                 ; compare A to B
           bmi   LD490         ; branch if minus(hi bit 1)
           tab                 ; B = A
   LD490:  addb  #0x15         ;  -00010101-
           stab  MinimumTimerCountBeforeMainloopCanContinue    ; store B into memory
           cli                 ; enable interrupts
   LD496:  cmpa  CPU_TimerCounterRegHigh    ; compare A with memory contents
           bpl   LD496         ; branch if plus (hi bit 0)
           jmp   MainProgramLoop

ControlPurgeSolenoid_MM:
           ldaa  L64D4         ; load A with memory contents
           beq   LD4B1         ; branch if equal (zero)
           cmpa  #0x01         ; compare a with value -00000001-
           bne   LD4B1         ; branch if not equal (not zero)
           ldaa  L64D5         ; load A with memory contents
           cmpa  #0x02         ; compare a with value -00000010-
           beq   LD4FA         ; branch if equal (zero)
           jmp   CanisterPurgeOn

   LD4B1:  brclr *BitFlags6A, #b6a_Cruise1, LD4B9    ; branch if bit(s) clear
           brclr *BitFlags6F, #b6f_FuelEngineNotRunning, LD4CC    ; branch if bit(s) clear
   LD4B9:  brset *BitFlags6F, #b6f_FuelEngineNotRunning, LD4F2    ; branch if bit(s) set
           brclr *BitFlags66, #b66_O2Valid, LD4F2    ; branch if bit(s) clear
           brset *CylTrim_FlagsF0, #$%00001000, LD4F7    ; branch if bit(s) set
           ldaa  CoolantTemp    ; load A with memory contents
           cmpa  PURTMP_CanisterPurgeCoolantTemp    ; compare A with memory contents (data is ff)
           bcs   LD4FA         ; branch if lower
   LD4CC:  ldaa  BaroPressure    ; load A with memory contents
           adda  PURMAP_CannisterPurgeWhenBelowThisBaro    ;  (data is 7f)
           bcc   LD4D5         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   LD4D5:  brclr *PIA2_Buffer, #$%00100000, LD4E6    ; branch if bit(s) clear
           adda  PURHYS_CannisterPurgeBaroHysteresis    ;  (data is 02)
           bcc   LD4E0         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   LD4E0:  cmpa  MapValue      ; compare A with memory contents
           bcc   LD4FE         ; branch if greater or equal
           bra   LD4FA         ; branch

   LD4E6:  suba  PURHYS_CannisterPurgeBaroHysteresis    ;  (data is 02)
           bcc   LD4EC         ; branch if greater or equal
           clra                ; A = 0
   LD4EC:  cmpa  MapValue      ; compare A with memory contents
           bcc   LD4FE         ; branch if greater or equal
           bra   LD4FD         ; branch

   LD4F2:  bset  *CylTrim_FlagsF0, #$%00001000    ; set bits
           bra   LD4FA         ; branch

   LD4F7:  bclr  *CylTrim_FlagsF0, #$%00001000    ; clear bits
   LD4FA:  bclr  *PIA2_Buffer, #$%00100000    ; clear bits
   LD4FD:  rts                 ; return from subroutine

   LD4FE:  ldab  #0x08         ; load B with value -00001000-
           ldx   #CLTRP2_Cyl2TrimValueForPurgeVolume    ; load index with value
           ldaa  PointerIntoAdaptiveMemory    ; load A with memory contents
           cmpa  CL2PTR_Cyl2AdaptiveMemoryPointer    ; compare A with memory contents (data is 0c)
           bne   LD510         ; branch if not equal (not zero)
           brset *BitFlags67, #b67_FallToIdle, LD572    ; branch if bit(s) set
           bra   LD523         ; branch

   LD510:  inX                 ; increment index (I=I+1)
           lsrb                ; logical shift right B
           cmpa  CL1PTR_Cyl1AdaptiveMemoryPointer    ; compare A with memory contents (data is 02)
           beq   LD523         ; branch if equal (zero)
           lsrb                ; logical shift right B
           cmpa  CL3PTR_Cyl3AdaptiveMemoryPointer    ; compare A with memory contents (data is 04)
           beq   LD523         ; branch if equal (zero)
           lsrb                ; logical shift right B
           cmpa  CL4PTR_Cyl4AdaptiveMemoryPointer    ; compare A with memory contents (data is 05)
           bne   LD572         ; branch if not equal (not zero)
   LD523:  brset *CylTrim_FlagsF0, #$%00100000, LD572    ; branch if bit(s) set
           brset *BitFlags67, #b67_StayOpenLoop, CanisterPurgeOn    ; branch if bit(s) set
           bitb  CylTrim_FlagsEF
           bne   LD572         ; branch if not equal (not zero)
           lslb                ; arithmetic shift left B
           lslb                ; arithmetic shift left B
           lslb                ; arithmetic shift left B
           lslb                ; arithmetic shift left B
           brclr *CylTrim_FlagsF0, #$%10000000, LD541    ; branch if bit(s) clear
           cmpb  #0x80         ;  -10000000-
           bne   LD541         ; branch if not equal (not zero)
           bset  *CylTrim_FlagsEF, #$%10000000    ; set bits
           bclr  *CylTrim_FlagsF0, #$%10000000    ; clear bits
   LD541:  bitb  CylTrim_FlagsEF
           beq   LD572         ; branch if equal (zero)
           ldaa  CylTrim_Adaptive_Var1    ; load A with memory contents
           cmpa  0x00, X      ; compare A with memory at index + value -00000000-
           bcc   LD565         ; branch if greater or equal
           bitb  CylTrimFlags
           bne   LD572         ; branch if not equal (not zero)
           tsta                ; test A
           beq   LD558         ; branch if equal (zero)
           brclr *Counter_MainLoop, #$%00111111, LD558    ; branch if bit(s) clear
           bra   CanisterPurgeOff    ; branch

   LD558:  inca                ; increment A
           beq   CanisterPurgeOff    ; branch if equal (zero)
           staa  CylTrim_Adaptive_Var1    ; store A into memory
CanisterPurgeOff:
           cmpa  #0x03         ; compare a with value -00000011-
           bcs   CanisterPurgeOn    ; branch if lower
           bclr  *PIA2_Buffer, #$%00100000    ; clear bits
           rts                 ; return from subroutine

   LD565:  lsrb                ; logical shift right B
           lsrb                ; logical shift right B
           lsrb                ; logical shift right B
           lsrb                ; logical shift right B
           tba                 ; A = B
           orab  CylTrim_FlagsEF
           stab  CylTrim_FlagsEF    ; store B into memory
           oraa  CylTrimFlags    ; OR A with memory contents
           staa  CylTrimFlags    ; store A into memory
   LD572:  clr   CylTrim_Adaptive_Var1    ; zero byte at memory location
CanisterPurgeOn:
           bset  *PIA2_Buffer, #$%00100000    ; set bits
           rts                 ; return from subroutine

DetermineIndividualInjectorTrims_MM:
           brclr *CylTrim_FlagsF0, #$%01000000, FindCyl2Trim    ; branch if bit(s) clear
           rts                 ; return from subroutine

FindCyl2Trim:
           brclr *CylTrimFlags, #$%00001000, FindCyl1Trim    ; branch if bit(s) clear
           ldx   #AutoCalCell0    ; load index with value
           ldab  CL2PTR_Cyl2AdaptiveMemoryPointer    ; load B with memory contents (data is 0c)
           abx                 ; add B to index
           ldaa  Cyl2_InjPWTrim    ; load A with memory contents
           suba  0x00, X      ;  -00000000-
           blt   FindCyl1Trim    ; branch if less
           brclr *CylTrimFlags, #$%10000000, LD596    ; branch if bit(s) clear
           adda  CL2INC_Cyl2TrimIncrement    ;  (data is 05)
   LD596:  cmpa  CL2LMT_Cyl2TrimLimit    ; compare A with memory contents (data is 2e)
           bcs   FindCyl1Trim    ; branch if lower
           bset  *CylTrimFlags, #$%10000000    ; set bits
           bra   LD5A3         ; branch

FindCyl1Trim:
           bclr  *CylTrimFlags, #$%10000000    ; clear bits
   LD5A3:  brclr *CylTrimFlags, #$%00000100, FindCyl3Trim    ; branch if bit(s) clear
           ldx   #AutoCalCell0    ; load index with value
           ldab  CL1PTR_Cyl1AdaptiveMemoryPointer    ; load B with memory contents (data is 02)
           abx                 ; add B to index
           ldaa  Cyl1_InjPWTrim    ; load A with memory contents
           suba  0x00, X      ;  -00000000-
           blt   FindCyl3Trim    ; branch if less
           brclr *CylTrimFlags, #$%01000000, LD5BB    ; branch if bit(s) clear
           adda  CL1INC_Cyl1TrimIncrement    ;  (data is 05)
   LD5BB:  cmpa  CL1LMT_Cyl1TrimLimit    ; compare A with memory contents (data is 3d)
           bcs   FindCyl3Trim    ; branch if lower
           bset  *CylTrimFlags, #$%01000000    ; set bits
           bra   LD5C8         ; branch

FindCyl3Trim:
           bclr  *CylTrimFlags, #$%01000000    ; clear bits
   LD5C8:  brclr *CylTrimFlags, #$%00000010, FindCyl4Trim    ; branch if bit(s) clear
           ldx   #AutoCalCell0    ; load index with value
           ldab  CL3PTR_Cyl3AdaptiveMemoryPointer    ; load B with memory contents (data is 04)
           abx                 ; add B to index
           ldaa  Cyl3_InjPWTrim    ; load A with memory contents
           suba  0x00, X      ;  -00000000-
           blt   FindCyl4Trim    ; branch if less
           brclr *CylTrimFlags, #$%00100000, LD5E0    ; branch if bit(s) clear
           adda  CL3INC_Cyl3TrimIncrement    ;  (data is 05)
   LD5E0:  cmpa  CL3LMT_Cyl3TrimLimit    ; compare A with memory contents (data is 3d)
           bcs   FindCyl4Trim    ; branch if lower
           bset  *CylTrimFlags, #$%00100000    ; set bits
           bra   LD5ED         ; branch

FindCyl4Trim:
           bclr  *CylTrimFlags, #$%00100000    ; clear bits
   LD5ED:  brclr *CylTrimFlags, #$%00000001, LD60E    ; branch if bit(s) clear
           ldx   #AutoCalCell0    ; load index with value
           ldab  CL4PTR_Cyl4AdaptiveMemoryPointer    ; load B with memory contents (data is 05)
           abx                 ; add B to index
           ldaa  Cyl4_InjPWTrim    ; load A with memory contents
           suba  0x00, X      ;  -00000000-
           blt   LD60E         ; branch if less
           brclr *CylTrimFlags, #$%00010000, LD605    ; branch if bit(s) clear
           adda  CL4INC_Cyl4TrimIncrement    ;  (data is 05)
   LD605:  cmpa  CL4LMT_Cyl4TrimLimit    ; compare A with memory contents (data is 3d)
           bcs   LD60E         ; branch if lower
           bset  *CylTrimFlags, #$%00010000    ; set bits
           rts                 ; return from subroutine

   LD60E:  bclr  *CylTrimFlags, #$%00010000    ; clear bits
           rts                 ; return from subroutine

IncludeCylTrimWithAdaptiveCells:
           bset  *CylTrim_FlagsF0, #$%00100000    ; set bits
           bset  *CylTrim_FlagsEF, #$%10000000    ; set bits
           ldab  #0xf0         ; load B with value -11110000-
           bitb  CylTrimFlags
           beq   LD674         ; branch if equal (zero)
           ldaa  CoolantTemp    ; load A with memory contents
           cmpa  CLTRP3_Cyl3TrimValueForPurgeVolume    ; compare A with memory contents (data is db)
           bhi   LD67E         ; branch if higher
           ldaa  Cyl1_InjPWTrim    ; load A with memory contents
           ldab  Cyl3_InjPWTrim    ; load B with memory contents
           cba                 ; compare A to B
           bge   LD62D         ; branch if greater or equal
           tba                 ; A = B
   LD62D:  ldab  Cyl4_InjPWTrim    ; load B with memory contents
           cba                 ; compare A to B
           bge   LD633         ; branch if greater or equal
           tba                 ; A = B
   LD633:  clrb                ; b = 0
   LD634:  cmpb  CL2PTR_Cyl2AdaptiveMemoryPointer    ; compare B with memory contents (data is 0c)
           beq   LD64C         ; branch if equal (zero)
           cmpb  CL1PTR_Cyl1AdaptiveMemoryPointer    ; compare B with memory contents (data is 02)
           beq   LD64C         ; branch if equal (zero)
           cmpb  CL3PTR_Cyl3AdaptiveMemoryPointer    ; compare B with memory contents (data is 04)
           beq   LD64C         ; branch if equal (zero)
           cmpb  CL4PTR_Cyl4AdaptiveMemoryPointer    ; compare B with memory contents (data is 05)
           beq   LD64C         ; branch if equal (zero)
           pshb                ; push B onto stack
           bsr   LD694         ; call subroutine
           pulb                ; pull B from stack
   LD64C:  incb                ; increment B
           pshb                ; push B onto stack
           addb  #0x0f         ;  -00001111-
           cmpb  #0x1d         ;  -00011101-
           pulb                ; pull B from stack
           bcs   LD634         ; branch if lower
           ldaa  Cyl2_InjPWTrim    ; load A with memory contents
           ldab  CL2PTR_Cyl2AdaptiveMemoryPointer    ; load B with memory contents (data is 0c)
           bsr   LD694         ; call subroutine
           ldaa  Cyl1_InjPWTrim    ; load A with memory contents
           ldab  CL1PTR_Cyl1AdaptiveMemoryPointer    ; load B with memory contents (data is 02)
           bsr   LD694         ; call subroutine
           ldaa  Cyl3_InjPWTrim    ; load A with memory contents
           ldab  CL3PTR_Cyl3AdaptiveMemoryPointer    ; load B with memory contents (data is 04)
           bsr   LD694         ; call subroutine
           ldaa  Cyl4_InjPWTrim    ; load A with memory contents
           ldab  CL4PTR_Cyl4AdaptiveMemoryPointer    ; load B with memory contents (data is 05)
           bsr   LD694         ; call subroutine
           bclr  *CylTrimFlags, #$%11110000    ; clear bits
   LD674:  ldaa  CoolantTemp    ; load A with memory contents
           cmpa  CLTRP4_Cyl4TrimValueForPurgeVolume    ; compare A with memory contents (data is 84)
           bcc   LD67E         ; branch if greater or equal
           bset  *CylTrim_FlagsF0, #$%01000000    ; set bits
   LD67E:  ldx   #CONFIG_ConfigurationFlags    ; load index with value
           brclr 0x00, X, #$%00100000, LD693    ; branch if bit(s) clear -00000000-
           ldaa  AutoCalCellEnd    ; load A with memory contents
           tab                 ; B = A
           suba  AutoCalCell12idle
           blt   LD693         ; branch if less
           cmpa  CL2LMT_Cyl2TrimLimit    ; compare A with memory contents (data is 2e)
           bcs   LD693         ; branch if lower
           stab  AutoCalCell12idle    ; store B into memory
   LD693:  rts                 ; return from subroutine

   LD694:  ldx   #AutoCalCell0    ; load index with value
           abx                 ; add B to index
           ldab  0x00, X      ; load B with memory at index + value -00000000-
           cba                 ; compare A to B
           ble   LD69F         ; branch if less or equal
           staa  0x00, X      ;  -00000000-
   LD69F:  rts                 ; return from subroutine


; 	.org	0xd6a0
; TMPAMB_TempForScaleAmbientA2D:
; 	.byte	6			; number of points
; 	.byte	0x05, 0xff, 0xfc, 0xc0	; point 1
; 	.byte	0x15, 0xcb, 0xfe, 0xf8	; point 2
; 	.byte	0x32, 0xad, 0xff, 0x83	; point 3
; 	.byte	0x6f, 0x8f, 0xff, 0x9c	; point 4
; 	.byte	0xc8, 0x6c, 0xff, 0x60	; point 5
; 	.byte	0xe8, 0x58		; point 6
; 
; 	.org	0xd6b7
; TMPTL1_TempForColdScaleFromA2D:
; 	.byte	7			; number of points
; 	.byte	0x00, 0xd3, 0xff, 0x85	; point 1
; 	.byte	0x53, 0xab, 0xff, 0x9d	; point 2
; 	.byte	0xd7, 0x78, 0xff, 0x55	; point 3
; 	.byte	0xe6, 0x6e, 0xff, 0x17	; point 4
; 	.byte	0xf1, 0x64, 0xfe, 0xcd	; point 5
; 	.byte	0xf6, 0x5e, 0xfd, 0xab	; point 6
; 	.byte	0xff, 0x49		; point 7
; 
; 	.org	0xd6d2
; TMPTL2_TempForHotScaleA2D:
; 	.byte	4			; number of points
; 	.byte	0x42, 0xff, 0xff, 0x55	; point 1
; 	.byte	0x57, 0xf1, 0xff, 0x75	; point 2
; 	.byte	0xc5, 0xb5, 0xff, 0x4f	; point 3
; 	.byte	0xff, 0x8d		; point 4

;.org 0xd6e1 ; FIXME
CheckAndFilterCoolantTempSensor_MM:
           sei                 ; disable interrupts
           ldaa  #0x14         ; load a with value -00010100-
           staa  CPU_A2DControlReg
   LD6E7:  ldaa  CPU_A2DControlReg    ; load A with memory contents
           bpl   LD6E7         ; branch if plus (hi bit 0)
           ldd   CPU_A2DResults1
           stab  LastChargeTempVolts    ; store B into memory
           ldab  #0x10         ; load B with value -00010000-
           stab  CPU_A2DControlReg    ; store B into memory
           cli                 ; enable interrupts
           ldab  Timer_O2MiddleDiagnostics    ; load B with memory contents
           bne   LD703         ; branch if not equal (not zero)
           ldab  Counter_MainLoop    ; load B with memory contents
           andb  #0x7f         ;  -01111111-
           cmpb  #0x79         ;  -01111001-
           bcc   LD706         ; branch if greater or equal
   LD703:  jmp   CheckAndFilterCoolantTempSensor

   LD706:  bitb  #0x01         ;  -00000001-
           bne   LD71B         ; branch if not equal (not zero)
           cmpb  #0x7a         ;  -01111010-
           bne   LD71C         ; branch if not equal (not zero)
           sei                 ; disable interrupts
           bset  *PIA1_Buffer, #$%10000000    ; set bits
           bclr  *PIA1_Buffer, #$%00010000    ; clear bits
   LD715:  ldab  PIA1_Buffer    ; load B with memory contents
           stab  PortX_Control    ; store B into memory
           cli                 ; enable interrupts
   LD71B:  rts                 ; return from subroutine

   LD71C:  cmpb  #0x7c         ;  -01111100-
           bne   LD728         ; branch if not equal (not zero)
           staa  TempAmbientAirTempVolts    ; store A into memory
           sei                 ; disable interrupts
           bclr  *PIA1_Buffer, #$%10000000    ; clear bits
           bra   LD715         ; branch

   LD728:  cmpa  #0xdc         ; compare a with value -11011100-
           bcs   LD736         ; branch if lower
           sei                 ; disable interrupts
           bset  *PIA1_Buffer, #$%00010000    ; set bits
           ldab  PIA1_Buffer    ; load B with memory contents
           stab  PortX_Control    ; store B into memory
           cli                 ; enable interrupts
   LD736:  psha                ; push A onto stack
           suba  TempAmbientAirTempVolts
           bhi   LD73C         ; branch if higher
           clra                ; A = 0
   LD73C:  ldab  #0xff         ; load B with value -11111111-
           mul                 ; multiply (D=A*B)
           std   Temp2         ; store D (A&B) into memory
           pulb                ; pull B from stack
           ldaa  TempAmbientAirTempVolts    ; load A with memory contents
           mul                 ; multiply (D=A*B)
           psha                ; push A onto stack
           pshb                ; push B onto stack
           addd  Temp2         ; D = D + memory contents
           std   Temp2         ; store D (A&B) into memory
           ldy   #Temp2        ; load index with value
           pulb                ; pull B from stack
           ldaa  #0xff         ; load a with value -11111111-
           mul                 ; multiply (D=A*B)
           staa  Temp1         ; store A into memory
           tba                 ; A = B
           clrb                ; b = 0
           xgdx                ; exchange D and index
           pula                ; pull A from stack
           ldab  #0xff         ; load B with value -11111111-
           mul                 ; multiply (D=A*B)
           addb  Temp1         ; B=B+memory contents
           adca  #0x00         ;  -00000000-
           jsr   CalculateVehicleSpeedOrEngineRpms    ; call subroutine
           tstb                ; test B
           bpl   LD767         ; branch if plus (hi bit 0)
           inca                ; increment A
   LD767:  staa  Temp0         ; store A into memory
           ldx   #TMPAMB_TempForScaleAmbientA2D    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           ldaa  KeyOnOrEngineRunningTime    ; load A with memory contents
           beq   LD789         ; branch if equal (zero)
           subb  AmbientAirTempVolts    ; B = B-memory contents
           tba                 ; A = B
           bcc   LD781         ; branch if greater or equal
           nega                ; negate A (set high bit)
           cmpa  #0x10         ; compare a with value -00010000-
           bcs   LD787         ; branch if lower
           ldab  #0xf0         ; load B with value -11110000-
           bra   LD787         ; branch

   LD781:  cmpa  #0x10         ; compare a with value -00010000-
           bcs   LD787         ; branch if lower
           ldab  #0x10         ; load B with value -00010000-
   LD787:  addb  AmbientAirTempVolts    ; B=B+memory contents
   LD789:  stab  AmbientAirTempVolts    ; store B into memory
   LD78B:  rts                 ; return from subroutine

CheckAndFilterCoolantTempSensor:
           sei                 ; disable interrupts
           staa  LastCoolantTempVolts    ; store A into memory
           bclr  *PIA1_Buffer, #$%10000000    ; clear bits
           ldaa  PIA1_Buffer    ; load A with memory contents
           staa  PortX_Control
           cli                 ; enable interrupts
           ldab  Counter_MainLoop    ; load B with memory contents
           andb  #0x07         ;  -00000111-
           bne   LD78B         ; branch if not equal (not zero)
           ldaa  #0x1e         ; load a with value -00011110-
           ldab  LastCoolantTempVolts    ; load B with memory contents
           cmpb  TMPHIG_OutOfRangeColdTooHighA2D    ; compare B with memory contents (data is fd)
           bhi   LD7F4         ; branch if higher
           cmpb  TMPLOW_OutOfRangeHotTooLowA2D    ; compare B with memory contents (data is 1a)
           bcs   LD7F5         ; branch if lower
           brclr *b5C_IPL1, #$%00000010, LD7B7    ; branch if bit(s) clear
           ldaa  #0x02         ; load a with value -00000010-
           jsr   ResetErrorCodeIfTimerExpired    ; call subroutine
           bra   SubstituteChargeTempForCoolantTemp    ; branch

   LD7B7:  tba                 ; A = B
           brclr *PIA1_Buffer, #$%00010000, LD7D8    ; branch if bit(s) clear
           ldx   #TMPTL1_TempForColdScaleA2D    ; load index with value
           cmpa  #0x40         ; compare a with value -01000000-
           bcc   LD7DF         ; branch if greater or equal
   LD7C3:  ldab  BitFlags69    ; load B with memory contents
           addb  #0x40         ;  -01000000-
           stab  BitFlags69    ; store B into memory
           bcc   LD7E2         ; branch if greater or equal
           ldab  #0x10         ; load B with value -00010000-
           sei                 ; disable interrupts
           eorb  PIA1_Buffer
           stab  PortX_Control    ; store B into memory
           stab  PIA1_Buffer    ; store B into memory
           cli                 ; enable interrupts
           bra   LD823         ; branch

   LD7D8:  ldx   #TMPTL2_TempForHotScaleA2D    ; load index with value
           cmpa  #0xdc         ; compare a with value -11011100-
           bcc   LD7C3         ; branch if greater or equal
   LD7DF:  bclr  *BitFlags69, #$%11000000    ; clear bits
   LD7E2:  jsr   Lookup4ByteTable    ; call subroutine
           ldab  CoolantTemp    ; load B with memory contents
           sba                 ; subtract (A=A-B)
           bcc   LD7ED         ; branch if greater or equal
           decb                ; decrement B
           bra   LD81F         ; branch

   LD7ED:  cmpa  #0x03         ; compare a with value -00000011-
           bcs   LD823         ; branch if lower
           incb                ; increment B
           bra   LD81F         ; branch

   LD7F4:  inca                ; increment A
   LD7F5:  brset *b5C_IPL1, #$%00000010, SubstituteChargeTempForCoolantTemp    ; branch if bit(s) set
           ldab  #0x9e         ; load B with value -10011110-
           jsr   ThrowNonCriticalError    ; call subroutine
           bcc   LD823         ; branch if greater or equal
           ldaa  #0xef         ; load a with value -11101111-
           sei                 ; disable interrupts
           anda  PIA1_Buffer    ; logical and A with memory contents
           staa  PIA1_Buffer    ; store A into memory
           staa  PortX_Control
           cli                 ; enable interrupts
           bset  *b5C_IPL1, #$%00000010    ; set bits
           bclr  *BitFlags66, #b66_O2Valid    ; clear bits
           clra                ; A = 0
           staa  Timer_CLTIME_ClosedLoopTimer    ; store A into memory
           staa  Timer_ThermostatDiagnostics
SubstituteChargeTempForCoolantTemp:
           ldaa  ChargeTempVolts    ; load A with memory contents
           ldx   #COOLXF_ConvertChargeTempToCoolantTemp    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
   LD81F:  stab  CoolantTemp    ; store B into memory
           stab  PreviousCoolantTemp    ; store B into memory
   LD823:  rts                 ; return from subroutine

CheckAndFilterChargeTempSensor_MM:
           brclr *Counter_MainLoop, #$%00000111, LD829    ; branch if bit(s) clear
           rts                 ; return from subroutine

   LD829:  ldab  #0x39         ; load B with value -00111001-
           ldaa  LastChargeTempVolts    ; load A with memory contents
           cmpa  CHGLOW_ChargeTempOutOfRangeLow    ; compare A with memory contents (data is 1a)
           bcs   LD87F         ; branch if lower
           incb                ; increment B
           cmpa  CHGHIG_ChargeTempOutOfRangeHigh    ; compare A with memory contents (data is fd)
           bcc   LD87F         ; branch if greater or equal
           brset *b5C_IPL1, #$%00000001, LD89B    ; branch if bit(s) set
           brclr *PIA1_Buffer, #$%00100000, LD863    ; branch if bit(s) clear
           ldx   #TMPTL1_TempForColdScaleA2D    ; load index with value
           cmpa  #0x40         ; compare a with value -01000000-
           bcc   LD86A         ; branch if greater or equal
   LD847:  brset *BitFlags6B, #$%11000000, LD853    ; branch if bit(s) set
           ldab  BitFlags6B    ; load B with memory contents
           addb  #0x40         ;  -01000000-
           stab  BitFlags6B    ; store B into memory
           bra   LookupChargeTempValue    ; branch

   LD853:  bclr  *BitFlags6B, #$%11000000    ; clear bits
           ldab  #0x20         ; load B with value -00100000-
           sei                 ; disable interrupts
           eorb  PIA1_Buffer
           stab  PortX_Control    ; store B into memory
           stab  PIA1_Buffer    ; store B into memory
           cli                 ; enable interrupts
           bra   ChargeTempReturn    ; branch

   LD863:  ldx   #TMPTL2_TempForHotScaleA2D    ; load index with value
           cmpa  #0xdc         ; compare a with value -11011100-
           bcc   LD847         ; branch if greater or equal
   LD86A:  bclr  *BitFlags6B, #$%11000000    ; clear bits
LookupChargeTempValue:
           jsr   Lookup4ByteTable    ; call subroutine
           ldab  ChargeTempVolts    ; load B with memory contents
           sba                 ; subtract (A=A-B)
           bcc   LD878         ; branch if greater or equal
           decb                ; decrement B
           bra   StoreChargeTempValue    ; branch

   LD878:  cmpa  #0x03         ; compare a with value -00000011-
           bcs   ChargeTempReturn    ; branch if lower
           incb                ; increment B
           bra   StoreChargeTempValue    ; branch

   LD87F:  brset *b5C_IPL1, #$%00000001, LD8A0    ; branch if bit(s) set
           tba                 ; A = B
           ldab  #0x9e         ; load B with value -10011110-
           jsr   ThrowNonCriticalError    ; call subroutine
           bcc   ChargeTempReturn    ; branch if greater or equal
           ldaa  #0xdf         ; load a with value -11011111-
           sei                 ; disable interrupts
           anda  PIA1_Buffer    ; logical and A with memory contents
           staa  PortX_Control
           staa  PIA1_Buffer    ; store A into memory
           cli                 ; enable interrupts
           bset  *b5C_IPL1, #$%00000001    ; set bits
           bra   ChargeTempReturn    ; branch

   LD89B:  ldaa  #0x01         ; load a with value -00000001-
           jsr   ResetErrorCodeIfTimerExpired    ; call subroutine
   LD8A0:  brclr *b5C_IPL1, #$%00000010, SubstituteCoolantTempForChargeTemp    ; branch if bit(s) clear
           ldaa  CoolantTemp    ; load A with memory contents
           ldx   #CHRGXF_ConvertCoolantTempToChargeTemp    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           bra   StoreChargeTempValue    ; branch

SubstituteCoolantTempForChargeTemp:
           ldab  CoolantTemp    ; load B with memory contents
StoreChargeTempValue:
           stab  ChargeTempVolts    ; store B into memory
ChargeTempReturn:
           rts                 ; return from subroutine

CheckThrottleRoutine_MM:
           ldaa  EngineRpm_HB    ; load A with memory contents
           ldx   #DLTPRP_DeltaTPSFromRPM    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  Temp0         ; store A into memory
           ldab  #0x1a         ; load B with value -00011010-
           ldaa  LastTpsVolts    ; load A with memory contents
           cmpa  THRLOW_ThrottleLowerLimit    ; compare A with memory contents (data is 08)
           bcs   CheckThrottle_BadTpsSignal    ; branch if lower
           incb                ; increment B
           cmpa  THRHIG_ThrottleUpperLimit    ; compare A with memory contents (data is e4)
           bcc   CheckThrottle_BadTpsSignal    ; branch if greater or equal
           brclr *b5C_IPL1, #$%01000000, CheckThrottle_GotTpsValue    ; branch if bit(s) clear
           ldaa  #0x07         ; load a with value -00000111-
           bita  Counter_MainLoop
           bne   CheckThrottle_ErrorAlreadyFlagged    ; branch if not equal (not zero)
           jsr   ResetErrorCodeIfTimerExpired    ; call subroutine
           bra   CheckThrottle_ErrorAlreadyFlagged    ; branch

CheckThrottle_BadTpsSignal:
           brset *b5C_IPL1, #$%01000000, CheckThrottle_ErrorAlreadyFlagged    ; branch if bit(s) set
           brclr *Counter_MainLoop, #$%00000001, LD927    ; branch if bit(s) clear
           tba                 ; A = B
           ldab  #0xa0         ; load B with value -10100000-
           jsr   ThrowNonCriticalError    ; call subroutine
           bcc   LD927         ; branch if greater or equal
           bset  *b5C_IPL1, #$%01000000    ; set bits
CheckThrottle_ErrorAlreadyFlagged:
           ldaa  #0x40         ; load a with value -01000000-
           staa  MINTHR_LowestSessionTPS    ; store A into memory
           brset *BitFlags6F, #b6f_FuelEngineNotRunning, CheckThrottle_GotTpsValue    ; branch if bit(s) set
           ldab  MapValue      ; load B with memory contents
           cmpb  MPTHR_MapSwitchPointForFullThrottleOrIdle    ; compare B with memory contents (data is 68)
           bcs   CheckThrottle_GotTpsValue    ; branch if lower
           adda  Temp0     
CheckThrottle_GotTpsValue:
           staa  TPSVolts      ; store A into memory

; v2 code paste
           ; here, check if launch control is active and force WOT flag if it is...
; 	   ldx   #Turbonator_Flags
;            brset 0, x, #Turbonator_Staging, CheckThrottle_AtFullThrottle

           tab                 ; B = A
           subb  MINTHR_LowestSessionTPS    ; B = B-memory contents
           bcc   LD907         ; branch if greater or equal
           clrb                ; b = 0
   LD907:  stab  TpsVoltsOverMINTHR    ; store B into memory
           ldab  Temp0         ; load B with memory contents
           addb  MINTHR_LowestSessionTPS    ; B=B+memory contents
           bcs   LD913         ; branch if lower
           cmpb  #0xd0         ;  -11010000-
           bls   LD915         ; branch if lower or same
   LD913:  ldab  #0xd0         ; load B with value -11010000-
   LD915:  brclr *BitFlags66, #b66_FullThrottle, LD91C    ; branch if bit(s) clear
           subb  TPSOFS_TPSOffset    ; subtract memory contents from B (data is 03)
   LD91C:  cba                 ; compare A to B
           bhi   CheckThrottle_AtFullThrottle    ; branch if higher
           bclr  *BitFlags66, #b66_FullThrottle    ; clear bits
           bra   LD927         ; branch

CheckThrottle_AtFullThrottle:
           bset  *BitFlags66, #b66_FullThrottle    ; set bits
   LD927:  ldaa  TPSVolts      ; load A with memory contents
           ldab  BitFlags66    ; load B with memory contents
           bmi   LD94E         ; branch if minus(hi bit 1)
           cmpa  MINTHR_LowestSessionTPS    ; compare A with memory contents
           bcc   LD94E         ; branch if greater or equal
           ldaa  Timer_CountdownFromStartRunForAisFeedback    ; load A with memory contents
           bne   LD94E         ; branch if not equal (not zero)
           brset *BitFlags6F, #b6f_FuelEngineNotRunning, LD94E    ; branch if bit(s) set
           brclr *KeyOnOrEngineRunningTime, #$%11111111, LD94E    ; branch if bit(s) clear
           ldaa  Timer_DelayBeforeUpdating_MINTHR    ; load A with memory contents
           deca                ; decrement A
           bne   LD951         ; branch if not equal (not zero)
           ldaa  MINTHR_LowestSessionTPS    ; load A with memory contents
           deca                ; decrement A
           bge   LD94A         ; branch if greater or equal
           ldaa  MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load A with memory contents (data is 5c)
   LD94A:  staa  MINTHR_LowestSessionTPS    ; store A into memory
           andb  #0xbf         ;  -10111111-
   LD94E:  ldaa  MAXCNT_ProgramLoopsWithThrottleBelow_MINTHR_ToDecrement_MINTHR    ; load A with memory contents (data is 10)
   LD951:  staa  Timer_DelayBeforeUpdating_MINTHR    ; store A into memory
           ldaa  MTHRCL_NumberOfBitsAbove_MINTHR_ToDetermineOnThrottleTransition    ; load A with memory contents (data is 02)
           tstb                ; test B
           bpl   LD95C         ; branch if plus (hi bit 0)
           ldaa  MTHROP_NumberOfBitsAbove_MINTHR_ToDetermineOffThrottleTransition    ; load A with memory contents (data is 01)
   LD95C:  adda  MINTHR_LowestSessionTPS
           cmpa  TPSVolts      ; compare A with memory contents
           bcc   CheckThrottle_AtIdle    ; branch if greater or equal
           tstb                ; test B
           bmi   LD9BA         ; branch if minus(hi bit 1)
           bitb  #0x40         ;  -01000000-
           bne   LD974         ; branch if not equal (not zero)
           ldaa  MINTHR_LowestSessionTPS    ; load A with memory contents
           inca                ; increment A
           cmpa  TPSVolts      ; compare A with memory contents
           bcc   LD974         ; branch if greater or equal
           staa  MINTHR_LowestSessionTPS    ; store A into memory
           orab  #0x40         ;  -01000000-
   LD974:  ldaa  MapValue      ; load A with memory contents
           suba  OCTAE_FakeDeltaMapIncrease    ;  (data is 02)
           bcc   LD97D         ; branch if greater or equal
           ;ldaa  #0x06    ; FIXME
           ldaa  MINAMP_MinimumAverageMAP         ; load a with value -00000110-
   LD97D:  staa  MapAverageValue_HB    ; store A into memory
           ldaa  TPSVolts      ; load A with memory contents
           staa  TpsAverageValue_HB    ; store A into memory
           bclr  *BitFlags6C, #$%00110000    ; clear bits
           orab  #0x80         ;  -10000000-
           bra   LD9BA         ; branch

CheckThrottle_AtIdle:
           tstb                ; test B
           bpl   LD9BA         ; branch if plus (hi bit 0)
           bset  *BitFlags6D, #$%00001000    ; set bits
           brset *BitFlags68, #b68_bit7, LD997    ; branch if bit(s) set
           bset  *BitFlags69, #b69_AtIdle    ; set bits
   LD997:  ldx   #DLYTIM_AisDelayAfterThrottleClosesWhenMoving    ; load index with value
           stab  Temp0         ; store B into memory
           ldaa  VehicleSpeedScaled    ; load A with memory contents
           cmpa  MPHREF_SwitchPointForDecelIdleAisControl    ; compare A with memory contents (data is 08)
           bhi   CheckThrottle_VehicleSpeedStillAboveDecelIdle    ; branch if higher
           inX                 ; increment index (I=I+1)
           ldaa  DLYTM3_AisDelayAfterThrottleClosesWhenRpmAbove_DLYRPM    ; load A with memory contents (data is 51)
           ldab  EngineRpm_HB    ; load B with memory contents
           cmpb  DLYRPM_RpmTriggerForAisDelay    ; compare B with memory contents (data is 5e)
           bcc   LD9B0         ; branch if greater or equal
CheckThrottle_VehicleSpeedStillAboveDecelIdle:
           ldaa  0x00, X      ; load A with memory at index + value -00000000-
   LD9B0:  cmpa  Timer_CountdownFromStartRunForAisFeedback    ; compare A with memory contents
           bls   LD9B6         ; branch if lower or same
           staa  Timer_CountdownFromStartRunForAisFeedback    ; store A into memory
   LD9B6:  ldab  Temp0         ; load B with memory contents
           andb  #0x7f         ;  -01111111-
   LD9BA:  bitb  #0x08         ;  -00001000-
           bne   LD9DF         ; branch if not equal (not zero)
           brclr *StartupSwitchMirror1, #$%00100000, LD9DF    ; branch if bit(s) clear
           ldaa  EngineRpm_HB    ; load A with memory contents
           cmpa  RPMTHR_ThrottleSelfCalibrationRpmThreshold    ; compare A with memory contents (data is 30)
           bcs   LD9DF         ; branch if lower
           ldaa  MapValue      ; load A with memory contents
           cmpa  MAPTHR_ThrottleSelfCalibrationMapDeltaThreshold    ; compare A with memory contents (data is 31)
           bcc   LD9DF         ; branch if greater or equal
           ldaa  MINTHR_LowestSessionTPS    ; load A with memory contents
           inca                ; increment A
           cmpa  MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; compare A with memory contents (data is 5c)
           bcs   LD9DB         ; branch if lower
           ldaa  MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load A with memory contents (data is 5c)
   LD9DB:  staa  MINTHR_LowestSessionTPS    ; store A into memory
           orab  #0x08         ;  -00001000-
   LD9DF:  ldaa  MINTHR_LowestSessionTPS    ; load A with memory contents
           adda  #0x30         ;  -00110000-
           cmpa  TPSVolts      ; compare A with memory contents
           bcc   LD9E9         ; branch if greater or equal
           andb  #0xf7         ;  -11110111-
   LD9E9:  stab  BitFlags66    ; store B into memory
           rts                 ; return from subroutine

SomethingWithAIS_MM:
           ldaa  Counter_IdleControl    ; load A with memory contents
           beq   LD9F5         ; branch if equal (zero)
           deca                ; decrement A
           beq   LD9F5         ; branch if equal (zero)
           staa  Counter_IdleControl    ; store A into memory
   LD9F5:  clrb                ; b = 0
           brclr *BitFlags37, #bf37_ATX, LDA39    ; branch if bit(s) clear
           ldaa  CoolantTemp    ; load A with memory contents
           brset *StartupSwitchMirror1, #$%00010000, LDA0C    ; branch if bit(s) set
           brclr *BitFlags_AIS, #$%00001000, LDA3E    ; branch if bit(s) clear
           ldx   #ICCNT1_IdleControlCounterInit1    ; load index with value
           bclr  *BitFlags_AIS, #$%00001000    ; clear bits
           bra   LDA19         ; branch

   LDA0C:  bclr  *BitFlags6C, #$%00110000    ; clear bits
           brset *BitFlags_AIS, #$%00001000, LDA3E    ; branch if bit(s) set
           ldx   #ICCNT2_IdleControlCounterInit2    ; load index with value
           bset  *BitFlags_AIS, #$%00001000    ; set bits
   LDA19:  bclr  *BitFlags67, #b67_FallToIdle    ; clear bits
           brset *BitFlags6F, #b6f_FuelEngineNotRunning, LDA3C    ; branch if bit(s) set
           brset *BitFlags66, #b66_OffIdle, LDA3C    ; branch if bit(s) set
           jsr   Lookup4ByteTable    ; call subroutine
           bset  *BitFlags_AIS, #$%00000100    ; set bits
           stab  Counter_IdleControl    ; store B into memory
           ldaa  CoolantTemp    ; load A with memory contents
           ldx   #ADCINT_AdvanceDownCoutnerInitial    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  AdvanceDownCounter_A
           bra   LDA3E         ; branch

   LDA39:  bclr  *BitFlags_AIS, #$%00001000    ; clear bits
   LDA3C:  stab  Counter_IdleControl    ; store B into memory
   LDA3E:  ldab  SwitchPortAccessReg2    ; load B with memory contents
           bitb  #0x01         ;  -00000001-
           bne   LDA48         ; branch if not equal (not zero)
           bset  *BitFlags68, #b68_BladePassedSensor    ; set bits
   LDA48:  rts                 ; return from subroutine

CycleACClutch_MM:
           brset *Counter_MainLoop, #$%00000001, LDA9A    ; branch if bit(s) set
           ldab  ACClutchToggleVar    ; load B with memory contents
           ldaa  StartupSwitchMirror1    ; load A with memory contents
           eora  BitFlags68
           bita  #0x80         ;  -10000000-
           beq   LDA85         ; branch if equal (zero)
           brclr *StartupSwitchMirror1, #$%10000000, LDA70    ; branch if bit(s) clear
           cmpb  #0x30         ;  -00110000-
           bcs   LDA65         ; branch if lower
           bset  *BitFlags68, #b68_bit7    ; set bits
           bclr  *ACClutchToggleVar, #$%00000111    ; clear bits
   LDA65:  ldaa  Counter_MainLoop    ; load A with memory contents
           bita  #0x1f         ;  -00011111-
           bne   LDA9A         ; branch if not equal (not zero)
           addb  #0x08         ;  -00001000-
           bcc   LDA98         ; branch if greater or equal
           rts                 ; return from subroutine

   LDA70:  brclr *ACClutchToggleVar, #$%00000111, LDA7B    ; branch if bit(s) clear
           tba                 ; A = B
           anda  #0x07         ; AND a with value -00000111-
           cmpa  #0x05         ; compare a with value -00000101-
           bls   LDA82         ; branch if lower or same
   LDA7B:  cmpb  #0xb8         ;  -10111000-
           bcs   LDA65         ; branch if lower
           bclr  *BitFlags68, #b68_bit7    ; clear bits
   LDA82:  clrb                ; b = 0
           bra   LDA98         ; branch

   LDA85:  brset *ACClutchToggleVar, #$%00000111, LDA8C    ; branch if bit(s) set
           incb                ; increment B
           stab  ACClutchToggleVar    ; store B into memory
   LDA8C:  brset *BitFlags68, #b68_bit7, LDA65    ; branch if bit(s) set
           cmpb  #0x60         ;  -01100000-
           bcs   LDA65         ; branch if lower
           andb  #0x07         ;  -00000111-
           orab  #0x60         ;  -01100000-
   LDA98:  stab  ACClutchToggleVar    ; store B into memory
   LDA9A:  rts                 ; return from subroutine

ConvertMAPVoltsToValue:
           staa  Temp5         ; store A into memory
           ldab  MAPMULT_ScaleMAPVoltsToPresMultiplyConst         ; load B with value -00000111-
           bpl   LDAA4         ; branch if plus (hi bit 0)
           clr   Temp5         ; zero byte at memory location
   LDAA4:  mul                 ; multiply (D=A*B)
           adda  Temp5     
           bcc   LDAAB         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   LDAAB:  addd  MAPADD_ScaleMAPVoltsToPresAddConst       ;  -00000011 01100001-
           bcc   LDAB2         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   LDAB2:  rts                 ; return from subroutine

Lookup3DTableRoutine:
; 3D Table Lookup

; Inputs:
; A = 0-FF Y-Axis/Row address
; B = 0-FF X-Axis/Column address

; Output:
; A = Interpolated value from table

; Default is unsigned data
           ldy   #InterpUnsigned        ; load index with value
           brclr 0x02, X, #$%11111111, LDABF    ; branch if bit(s) clear -00000010-
; Signed data interpolation
           ldy   #InterpSigned        ; load index with value
; Making room on the stack for local variables
   LDABF:  pshy                ; pull index from stack
; Push 2 copies of the Y input onto the stack
           psha                ; push A onto stack
           psha                ; push A onto stack
; this is different from the other 3D lookup
; push the table address onto the stack
           pshx                ; pull index from stack
; pull the table address into Y
           puly                ; pull index from stack
; point Y at the first data byte in the 3D table
           inY                 ; increment index (I=I+1)
           inY                 ; increment index (I=I+1)
           inY                 ; increment index (I=I+1)

           ldaa  #0x01         ; load a with value -00000001-
; comapre the X input to the first data point
           cmpb  0x00, Y      ;  -00000000-
; branch if the input value is less than or equal to the first byte in the table
           bls   LDB00         ; branch if lower or same
   LDAD3:  cmpa  0x01, X      ; compare A with memory at index + value -00000001-
           beq   LDB00         ; branch if equal (zero)
           cmpb  0x01, Y      ;  -00000001-
           bcs   LDAE1         ; branch if lower
           inca                ; increment A
           inY                 ; increment index (I=I+1)
           bra   LDAD3         ; branch

   LDAE1:  deca                ; decrement A
           psha                ; push A onto stack
           pshx                ; pull index from stack
           subb  0x00, Y      ;  -00000000-
           beq   LDAFD         ; branch if equal (zero)
           tba                 ; A = B
           clrb                ; b = 0
           xgdx                ; exchange D and index
           clra                ; A = 0
           ldab  0x01, Y      ; load B with memory at index + value -00000001-
           subb  0x00, Y      ;  -00000000-
           beq   LDAFD         ; branch if equal (zero)
           xgdx                ; exchange D and index
           idiv                ; integer divide ACCD by IX
           xgdx                ; exchange D and index
           tsta                ; test A
           beq   LDAFD         ; branch if equal (zero)
           ldab  #0xff         ; load B with value -11111111-
   LDAFD:  pulx                ; pull index from stack
           bra   LDB03         ; branch

; interpolate from 0 to the 2nd X value in the table
   LDB00:  clrb                ; b = 0
; clear the X input value
; point to just before the first byte in the table
           deca                ; decrement A
           psha                ; push A onto stack
   LDB03:  pshb                ; push B onto stack
; put 2 copies of the (Y) input value into Y
           tsy                 ; transfer stack to index (I=sp+1)
           ldaa  0x02, Y      ; load A with memory at index + value -00000010-
           ldab  0x00, X      ; load B with memory at index + value -00000000-
           decb                ; decrement B
           mul                 ; multiply (D=A*B)
           stab  0x03, Y      ;  -00000011-
           ldab  0x01, X      ; load B with memory at index + value -00000001-
           stab  0x02, Y      ;  -00000010-
           mul                 ; multiply (D=A*B)
           inX                 ; increment index (I=I+1)
           inX                 ; increment index (I=I+1)
           inX                 ; increment index (I=I+1)
           abx                 ; add B to index
           ldab  0x02, Y      ; load B with memory at index + value -00000010-
           abx                 ; add B to index
           bra   LDB4C         ; branch

Lookup3DTableRoutine2:
           ldy   #InterpUnsigned        ; load index with value
           brclr 0x02, X, #$%11111111, LDB2C    ; branch if bit(s) clear -00000010-
           ldy   #InterpSigned        ; load index with value
   LDB2C:  pshy                ; pull index from stack
           psha                ; push A onto stack
           psha                ; push A onto stack
           ldaa  0x01, X      ; load A with memory at index + value -00000001-
           deca                ; decrement A
           mul                 ; multiply (D=A*B)
           psha                ; push A onto stack
           pshb                ; push B onto stack
           tsy                 ; transfer stack to index (I=sp+1)
           ldaa  0x02, Y      ; load A with memory at index + value -00000010-
           ldab  0x00, X      ; load B with memory at index + value -00000000-
           decb                ; decrement B
           mul                 ; multiply (D=A*B)
           stab  0x03, Y      ;  -00000011-
           ldab  0x01, X      ; load B with memory at index + value -00000001-
           stab  0x02, Y      ;  -00000010-
           mul                 ; multiply (D=A*B)
           inX                 ; increment index (I=I+1)
           inX                 ; increment index (I=I+1)
           inX                 ; increment index (I=I+1)
           abx                 ; add B to index
   LDB4C:  tsta                ; test A
           beq   LDB53         ; branch if equal (zero)
           inX                 ; increment index (I=I+1)
           ldab  #0xff         ; load B with value -11111111-
           abx                 ; add B to index
   LDB53:  ldab  0x01, Y      ; load B with memory at index + value -00000001-
           abx                 ; add B to index
           ldab  0x00, Y      ; load B with memory at index + value -00000000-
           pshy                ; pull index from stack
           ldy   0x04, Y      ;  -00000100-
           ldaa  0x00, X      ; load A with memory at index + value -00000000-
           suba  0x01, X      ;  -00000001-
           jsr   0x00, Y      ;  -00000000-
           puly                ; pull index from stack
           staa  0x01, Y      ;  -00000001-
           ldab  0x02, Y      ; load B with memory at index + value -00000010-
           abx                 ; add B to index
           pulb                ; pull B from stack
           pshy                ; pull index from stack
           ldy   0x04, Y      ;  -00000100-
           ldaa  0x00, X      ; load A with memory at index + value -00000000-
           suba  0x01, X      ;  -00000001-
           jsr   0x00, Y      ;  -00000000-
           puly                ; pull index from stack
           tsx                 ; transfer stack to index (I=sp+1)
           staa  0x01, X      ;  -00000001-
           ldab  0x02, X      ; load B with memory at index + value -00000010-
           ldy   0x03, X      ;  -00000011-
           ldaa  0x00, X      ; load A with memory at index + value -00000000-
           suba  0x01, X      ;  -00000001-
           jsr   0x00, Y      ;  -00000000-
           pulb                ; pull B from stack
           pulx                ; pull index from stack
           pulx                ; pull index from stack
           rts                 ; return from subroutine

InterpSigned:
           blt   LDB9D         ; branch if less
           bra   LDB97         ; branch

InterpUnsigned:
           bcs   LDB9D         ; branch if lower
   LDB97:  mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           nega                ; negate A (set high bit)
           bra   LDBA1         ; branch

   LDB9D:  nega                ; negate A (set high bit)
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
   LDBA1:  adda  0x00, X      ;  -00000000-
           rts                 ; return from subroutine

RescaleRPMFor3D_MM:
           ldd   EngineRpm_HB    ; load D (A&B) with memory contents
           rolb                ; rotate B left through carry
           clrb                ; b = 0
           adca  #0x00         ;  -00000000-
           bcs   LDBB2         ; branch if lower
           ldx   #RPMSCL_RPM3DInputModifierFromRPM    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
   LDBB2:  tba                 ; A = B
           staa  RPMRescaledfor3D    ; store A into memory
           rts                 ; return from subroutine


; 	.org	0xdbb6
; DWELL_DwellTimeFromBatteryVoltsComp:
; 	.byte	0x82
; 	.word	0xe609, 0x4059
; 	.byte	0xaa
; 	.word	0xf017, 0x2908
; 	.byte	0xc8
; 	.word	0xf4e6, 0x138c
; 	.byte	0xdc
; 	.word	0xf66d, 0x1100
; 	.byte	0xf0
; 	.word	0xf7c1, 0x0c55
; 	.byte	0xff

;        .org    0xdbd5 ;FIXME
CalculateSparkAdvance_MM:
           ldaa  BatteryVolts    ; load A with memory contents
           ldx   #DWELL_DwellTimeFromBatteryVoltsComp    ; load index with value
           jsr   Lookup5ByteTable    ; call subroutine
           coma                ; 1's complement A
           comb                ; 1's complement B
           std   DwellTime_HB
           
           ldaa  AdvanceDownCounter_A    ; load A with memory contents
           beq   StartToCalculateAdvance    ; branch if equal (zero)
           deca                ; decrement A
           staa  AdvanceDownCounter_A
StartToCalculateAdvance:
           brclr *BitFlags66, #b66_OffIdle, CalculateIdleAdvance    ; branch if bit(s) clear
           ldaa  MapValue      ; load A with memory contents
           ldx   #MAPMOD_ModifiedMAPForBASADV    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           ldab  CoolantTemp    ; load B with memory contents
           ldx   #BASADV_BaseAdvanceFromMAPandCoolant3D    ; load index with value
           jsr   Lookup3DTableRoutine    ; call subroutine
           staa  Temp0         ; store A into memory
           ldaa  ChargeTempVolts    ; load A with memory contents
           ldx   #BASCHG_BaseAdvanceProductFromChargeTemp    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  Temp1         ; store A into memory
           ldaa  MapValue      ; load A with memory contents
           ldx   #BASMAP_BaseAdvanceProductFromMAP    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           ldab  Temp1         ; load B with memory contents
           mul                 ; multiply (D=A*B)
           adda  Temp0     
           bvc   LDC23         ; branch if overflow
           tsta                ; test A
           bpl   LDC21         ; branch if plus (hi bit 0)
           ldaa  #0x7f         ; load a with value -01111111-
           bra   LDC23         ; branch

   LDC21:  ldaa  #0x80         ; load a with value -10000000-
   LDC23:  staa  Temp0         ; store A into memory
           jmp   LookupNormalAdvance

CalculateIdleAdvance:
           ldab  RPMRescaledfor3D    ; load B with memory contents
           ldaa  MAPRescaledfor3D    ; load A with memory contents
           ldx   #HOTMRP_AdvanceFromMAPAndRPMWarmIdlePart    ; load index with value
           jsr   Lookup3DTableRoutine2    ; call subroutine
           staa  Temp0         ; store A into memory
           brclr *BitFlags_AIS, #$%00000100, LDC58    ; branch if bit(s) clear
           ldaa  AdvanceDownCounter_A    ; load A with memory contents
           beq   LDC53         ; branch if equal (zero)
           ldab  ModifiedDeltaRPMFractionReducing    ; load B with memory contents
           brset *BitFlags_AIS, #$%00001000, LDC4B    ; branch if bit(s) set
           cmpb  MDRPMB_ModifiedDeltaRPMFractionReducing_ThresholdB    ; compare B with memory contents (data is 88)
           bcs   LDC5C         ; branch if lower
           bra   LDC50         ; branch

   LDC4B:  cmpb  MDRPMA_ModifiedDeltaRPMFractionReducing_ThresholdA    ; compare B with memory contents (data is 78)
           bhi   LDC5C         ; branch if higher
   LDC50:  clr   AdvanceDownCounter_A    ; zero byte at memory location
   LDC53:  bclr  *BitFlags_AIS, #$%00000100    ; clear bits
           bra   LDC5C         ; branch

   LDC58:  brset *BitFlags_AIS, #$%00001000, LDC63    ; branch if bit(s) set
   LDC5C:  ldaa  EngineRpm_HB    ; load A with memory contents
           cmpa  IDLADR_RPMBreakPointForIdleAdvanceTable    ; compare A with memory contents (data is 7d)
           bls   LDC6C         ; branch if lower or same
   LDC63:  brclr *BitFlags37, #bf37_ATX, LDC6C    ; branch if bit(s) clear
           ldx   #IDLAD2_IdleAdvanceFromCoolantTemp2    ; load index with value
           bra   LDC6F         ; branch

   LDC6C:  ldx   #IDLADV_IdleAdvanceFromCoolantTemp    ; load index with value
   LDC6F:  ldaa  CoolantTemp    ; load A with memory contents
           jsr   Lookup4ByteTable    ; call subroutine
           adda  Temp0     
           bvc   LDC81         ; branch if overflow
           tsta                ; test A
           bpl   LDC7F         ; branch if plus (hi bit 0)
           ldaa  #0x7f         ; load a with value -01111111-
           bra   LDC81         ; branch

   LDC7F:  ldaa  #0x80         ; load a with value -10000000-
   LDC81:  staa  Temp0         ; store A into memory
           brclr *BitFlags66, #b66_O2Valid, SparkAdvance_BadO2    ; branch if bit(s) clear
           ldaa  Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop    ; load A with memory contents
           bne   SparkAdvance_BadO2    ; branch if not equal (not zero)
           ldaa  Counter_O2SensorFeedbackCount_Signed    ; load A with memory contents
           cmpa  ADO2CL_AdvanceAddedFromO2FeedbackCounterLimitLow    ; compare A with memory contents (data is 9a)
           bge   SparkAdvance_BadO2    ; branch if greater or equal
           cmpa  ADO2CH_AdvanceAddedFromO2FeedbackCounterLimitHi    ; compare A with memory contents (data is 66)
           ble   SparkAdvance_BadO2    ; branch if less or equal
           ldx   #ADO2C2_AdvanceAddedFromO2FeedbackCounter2    ; load index with value
           brset *BitFlags_AIS, #$%00001000, LDCA1    ; branch if bit(s) set
           ldx   #ADO2C1_AdvanceAddedFromO2FeedbackCounter1    ; load index with value
   LDCA1:  adda  #0x80         ;  -10000000-
           jsr   Lookup4ByteTable    ; call subroutine
           staa  O2AdvanceIncrement
           adda  Temp0     
           bvc   LDCB6         ; branch if overflow
           tsta                ; test A
           bpl   LDCB4         ; branch if plus (hi bit 0)
           ldaa  #0x7f         ; load a with value -01111111-
           bra   LDCB6         ; branch

   LDCB4:  ldaa  #0x80         ; load a with value -10000000-
   LDCB6:  staa  Temp0         ; store A into memory
           bra   STORE_SPARK_ADV    ; branch

SparkAdvance_BadO2:
           ldaa  Temp0         ; load A with memory contents
           jsr   CheckAndSetMinSparkAdvance    ; call subroutine
STORE_SPARK_ADV:
           staa  CalculatedSparkAdvance    ; store A into memory
           rts                 ; return from subroutine

LookupNormalAdvance:
           bclr  *BitFlags_AIS, #$%00000100    ; clear bits
           ldab  RPMRescaledfor3D    ; load B with memory contents
           ldaa  MAPRescaledfor3D    ; load A with memory contents
           ldx   #WOTMRP_AdvanceFromMAPAndRPMWarmFull    ; load index with value
           jsr   Lookup3DTableRoutine2    ; call subroutine
           staa  MaxAdvanceLookup
           brset *BitFlags66, #b66_FullThrottle, LDD0F    ; branch if bit(s) set
           ldab  RPMRescaledfor3D    ; load B with memory contents
           ldaa  MAPRescaledfor3D    ; load A with memory contents
           ldx   #HOTMRP_AdvanceFromMAPAndRPMWarmIdlePart    ; load index with value
           jsr   Lookup3DTableRoutine2    ; call subroutine
           staa  Temp1         ; store A into memory
           ldaa  Timer_OpenLoopFraction    ; load A with memory contents
           ldx   #ADOTFN_AdvanceAddedFromOffThrotFuelEnrichTimer    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           adda  Temp1     
           bvc   LDCF7         ; branch if overflow
           tsta                ; test A
           bpl   LDCF5         ; branch if plus (hi bit 0)
           ldaa  #0x7f         ; load a with value -01111111-
           bra   LDCF7         ; branch

   LDCF5:  ldaa  #0x80         ; load a with value -10000000-
   LDCF7:  staa  Temp1         ; store A into memory
           ldaa  EngineRpm_HB    ; load A with memory contents
           ldx   #RPMMAP_SwitchPointForDownUp_FromRpm    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           ldaa  Temp1         ; load A with memory contents
           cmpb  MapValue  
           bhi   LDD0F         ; branch if higher
           cmpa  MaxAdvanceLookup    ; compare A with memory contents
           bhi   LDD0F         ; branch if higher
           staa  MaxAdvanceLookup
   LDD0F:  adda  Temp0     
           bvc   LDD1C         ; branch if overflow
           tsta                ; test A
           bpl   LDD1A         ; branch if plus (hi bit 0)
           ldaa  #0x7f         ; load a with value -01111111-
           bra   LDD1C         ; branch

   LDD1A:  ldaa  #0x80         ; load a with value -10000000-
   LDD1C:  staa  Temp0         ; store A into memory
           brset *EGRVar2, #$%00010000, LDD3E    ; branch if bit(s) set
           ldaa  BaroPressure    ; load A with memory contents
           suba  MapValue  
           bcc   LDD29         ; branch if greater or equal
           clra                ; A = 0
   LDD29:  ldx   #ADVNGM_AdvanceAddedFromNegMAP    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           adda  Temp0     
           bvc   LDD3C         ; branch if overflow
           tsta                ; test A
           bpl   LDD3A         ; branch if plus (hi bit 0)
           ldaa  #0x7f         ; load a with value -01111111-
           bra   LDD3C         ; branch

   LDD3A:  ldaa  #0x80         ; load a with value -10000000-
   LDD3C:  staa  Temp0         ; store A into memory
   LDD3E:  ldaa  EngineRpm_HB    ; load A with memory contents
           ldx   #ARRPM_AdaptiveRetardFromRPM    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  Temp1         ; store A into memory
           ldaa  MapValue      ; load A with memory contents
           ldx   #ARMAP_AdaptiveRetardFromMAP    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           adda  Temp1     
           bvc   LDD5D         ; branch if overflow
           tsta                ; test A
           bpl   LDD5B         ; branch if plus (hi bit 0)
           ldaa  #0x7f         ; load a with value -01111111-
           bra   LDD5D         ; branch

   LDD5B:  ldaa  #0x80         ; load a with value -10000000-
   LDD5D:  ldab  AdaptiveRetardIndex    ; load B with memory contents
           staa  AdaptiveRetardValue_A
           bmi   LDD69         ; branch if minus(hi bit 1)
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           bra   CheckForOtherRetardFactors    ; branch

   LDD69:  nega                ; negate A (set high bit)
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           nega                ; negate A (set high bit)
CheckForOtherRetardFactors:
           staa  Temp1         ; store A into memory
           ldaa  AdaptiveRetardIndex    ; load A with memory contents
           bne   CheckForTPSRetard_NoAR    ; branch if not equal (not zero)
           ldaa  MapValue      ; load A with memory contents
           cmpa  MAPLM1_MAPLimitForTPSRetard_NoAR    ; compare A with memory contents (data is 77)
           bcs   CheckRetardFromSpeed    ; branch if lower
           ldaa  EngineRpm_HB    ; load A with memory contents
           cmpa  RPMLM1_RPMLimitForTPSRetard_NoAR    ; compare A with memory contents (data is 10)
           bcs   CheckRetardFromSpeed    ; branch if lower
           ldaa  TPSVolts      ; load A with memory contents
           suba  MINTHR_LowestSessionTPS
           bcc   LDD89         ; branch if greater or equal
           clra                ; A = 0
   LDD89:  cmpa  TPSLM1_TPSLimitForTPSRetard_NoAR    ; compare A with memory contents (data is 10)
           bcs   CheckRetardFromSpeed    ; branch if lower
           suba  FilteredTPSOverMINTHR_A
           bcc   LDD94         ; branch if greater or equal
           clra                ; A = 0
   LDD94:  ldx   #TPSRT1_RetardFromDeltaTPSOverMINTHR_NoAR    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           adda  Temp1     
           bvc   LDDA7         ; branch if overflow
           tsta                ; test A
           bpl   LDDA5         ; branch if plus (hi bit 0)
           ldaa  #0x7f         ; load a with value -01111111-
           bra   LDDA7         ; branch

   LDDA5:  ldaa  #0x80         ; load a with value -10000000-
   LDDA7:  staa  Temp1         ; store A into memory
           bra   CheckRetardFromSpeed    ; branch

CheckForTPSRetard_NoAR:
           ldaa  MapValue      ; load A with memory contents
           cmpa  MAPLM2_MAPLimitForTPSRetard_WithAR    ; compare A with memory contents (data is 55)
           bcs   CheckRetardFromSpeed    ; branch if lower
           ldaa  EngineRpm_HB    ; load A with memory contents
           cmpa  RPMLM2_RPMLimitForTPSRetard_WithAR    ; compare A with memory contents (data is 10)
           bcs   CheckRetardFromSpeed    ; branch if lower
           ldaa  TPSVolts      ; load A with memory contents
           suba  MINTHR_LowestSessionTPS
           bcc   LDDC0         ; branch if greater or equal
           clra                ; A = 0
   LDDC0:  cmpa  TPSLM2_TPSLimitForTPSRetard_WithAR    ; compare A with memory contents (data is 10)
           bcs   CheckRetardFromSpeed    ; branch if lower
           suba  FilteredTPSOverMINTHR_B
           bcc   LDDCB         ; branch if greater or equal
           clra                ; A = 0
   LDDCB:  ldx   #TPSRT2_RetardFromDeltaTPSOverMINTHR_WithAR2    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           adda  Temp1     
           bvc   StoreRetardValue    ; branch if overflow
           tsta                ; test A
           bpl   LDDDC         ; branch if plus (hi bit 0)
           ldaa  #0x7f         ; load a with value -01111111-
           bra   StoreRetardValue    ; branch

   LDDDC:  ldaa  #0x80         ; load a with value -10000000-
StoreRetardValue:
           staa  Temp1         ; store A into memory
CheckRetardFromSpeed:
           ldab  MapValue      ; load B with memory contents
           cmpb  RTSPMP_MinimumMAPForRetardFromSpeed    ; compare B with memory contents (data is 90)
           bls   LDE04         ; branch if lower or same
           ldd   VehicleSpeed_HB    ; load D (A&B) with memory contents
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           lslb                ; arithmetic shift left B
           adca  #0x00         ;  -00000000-
           ldx   #RETSPD_RetardFromSpeed    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           adda  Temp1     
           bvc   LDE02         ; branch if overflow
           tsta                ; test A
           bpl   LDE00         ; branch if plus (hi bit 0)
           ldaa  #0x7f         ; load a with value -01111111-
           bra   LDE02         ; branch

   LDE00:  ldaa  #0x80         ; load a with value -10000000-
   LDE02:  staa  Temp1         ; store A into memory
   LDE04:  ldaa  Temp0         ; load A with memory contents
           suba  Temp1     
           bvc   LDE13         ; branch if overflow
           tsta                ; test A
           bpl   LDE11         ; branch if plus (hi bit 0)
           ldaa  #0x7f         ; load a with value -01111111-
           bra   LDE13         ; branch

   LDE11:  ldaa  #0x80         ; load a with value -10000000-
   LDE13:  staa  Temp0         ; store A into memory
           brclr *BitFlags37, #bf37_ATX, LDE87    ; branch if bit(s) clear
;           brset *BitFlags6A, #b6a_FuelOff, ResetDeltaRPMValues    ; branch if bit(s) set

; v2 code paste
           ldx   #Turbonator_Flags
           brset 0, x, #Turbonator_FuelOff, ResetDeltaRPMValues    ; branch if bit(s) set

           brclr *BitFlags66, #b66_FullThrottle, ResetDeltaRPMValues    ; branch if bit(s) clear
           ldaa  EngineRpm_HB    ; load A with memory contents
           cmpa  MRPDRE_MinimumRPMForDeltaRPMEvaluation    ; compare A with memory contents (data is 01)
           bcc   CheckConditionsForDeltaRPMRetard    ; branch if greater or equal
ResetDeltaRPMValues:
           clr   RetardFrom_DeltaEngineRPM_1    ; zero byte at memory location
           clr   DeltaEngineRPM_1    ; zero byte at memory location
           clr   Counter_DeltaEngineRPM_1    ; zero byte at memory location
           ldaa  EngineRpm_HB    ; load A with memory contents
           staa  EngineRPM_Temp
           bra   LDE87         ; branch

CheckConditionsForDeltaRPMRetard:
           ldaa  Counter_DeltaEngineRPM_1    ; load A with memory contents
           cmpa  MNCNRP_Minimum_CounterForDeltaRPMRetard    ; compare A with memory contents (data is 10)
           bcc   LDE48         ; branch if greater or equal
           inc   Counter_DeltaEngineRPM_1
           ldaa  DeltaEngineRPM_1    ; load A with memory contents
           bra   LDE5A         ; branch

   LDE48:  clr   Counter_DeltaEngineRPM_1    ; zero byte at memory location
           ldaa  EngineRPM_Temp    ; load A with memory contents
           ldab  EngineRpm_HB    ; load B with memory contents
           stab  EngineRPM_Temp    ; store B into memory
           sba                 ; subtract (A=A-B)
           bcc   LDE57         ; branch if greater or equal
           clra                ; A = 0
   LDE57:  staa  DeltaEngineRPM_1
   LDE5A:  cmpa  MDRPRE_Minumim_DeltaEngineRPM_1    ; compare A with memory contents (data is 0c)
           bcc   LDE6C         ; branch if greater or equal
           ldab  RetardFrom_DeltaEngineRPM_1    ; load B with memory contents
           beq   LDE87         ; branch if equal (zero)
           subb  RDRSUB_RetardFrom_DeltaEngineRPM_1_Subractor    ; subtract memory contents from B (data is fe)
           bcc   LDE72         ; branch if greater or equal
           clrb                ; b = 0
           bra   LDE72         ; branch

   LDE6C:  ldx   #RETDRP_RetardFrom_DeltaEngineRPM    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
   LDE72:  stab  RetardFrom_DeltaEngineRPM_1    ; store B into memory
           beq   LDE87         ; branch if equal (zero)
           ldaa  Temp0         ; load A with memory contents
           sba                 ; subtract (A=A-B)
           bvc   LDE85         ; branch if overflow
           tsta                ; test A
           bpl   LDE83         ; branch if plus (hi bit 0)
           ldaa  #0x7f         ; load a with value -01111111-
           bra   LDE85         ; branch

   LDE83:  ldaa  #0x80         ; load a with value -10000000-
   LDE85:  staa  Temp0         ; store A into memory
   LDE87:  ldaa  Temp0         ; load A with memory contents
           jsr   CheckAndSetMinSparkAdvance    ; call subroutine
           staa  CalculatedSparkAdvance    ; store A into memory
           rts                 ; return from subroutine

HandleSparkScatter:
           ldaa  BitFlags6F    ; load A with memory contents
           oraa  BitFlags66    ; OR A with memory contents
           bmi   LDEB0         ; branch if minus(hi bit 1)
           brset *BitFlags6C, #$%00100000, LDE9D    ; branch if bit(s) set
           brclr *b5C_IPL1, #$%00000010, LDEA4    ; branch if bit(s) clear
   LDE9D:  ldab  SPKSET_ConstantSparkAdvanceWhenSettingBasicTiming    ; load B with memory contents (data is 00)
           stab  Temp5         ; store B into memory
           bra   LDEB0         ; branch

   LDEA4:  ldaa  BitFlags_AIS    ; load A with memory contents
           anda  #0x04         ; AND a with value -00000100-
           oraa  Timer_CountdownFromStartRunForAisFeedback    ; OR A with memory contents
           bne   LDEB0         ; branch if not equal (not zero)
           brclr *BitFlags67, #b67_FallToIdle, LDEB1    ; branch if bit(s) clear
   LDEB0:  rts                 ; return from subroutine

   LDEB1:  brclr *b5C_IPL1, #$%10100000, LDEB7    ; branch if bit(s) clear
           bra   DontUseSparkScatter    ; branch

   LDEB7:  ldab  CoolantTemp    ; load B with memory contents
           cmpb  SSTEMP_TempAboveWhichSparkScatterIsActive    ; compare B with memory contents (data is 58)
           bls   DontUseSparkScatter    ; branch if lower or same
           ldx   KeyOnOrEngineRunningTime
           cpx   SSITIM_ScatterInhibitTime    ;  -10010000 00001100-
           bcs   DontUseSparkScatter    ; branch if lower
           ldx   TimerOverflowsBetweenDistPulses
           cpx   SSIPRD_ScatterInhibitBelowThisSpeed    ;  -10010000 00001110-
           bcc   DontUseSparkScatter    ; branch if greater or equal
;           brset *BitFlags6B, #b6b_DecelFuelCut, DontUseSparkScatter    ; branch if bit(s) set

; v2 code paste
           ldx   #Turbonator_Flags
           brset 0, x, #Turbonator_DecelFuelCut, DontUseSparkScatter    ; branch if bit(s) set

           ldaa  DeltaRPMToTargetIdleSigned    ; load A with memory contents
           bpl   LDEEE         ; branch if plus (hi bit 0)
           ldx   #SPKADD_SparkAdvanceAddedWhenRpmBelowControl_FromDeltaRpm    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  SparkScatter
           ldaa  CalculatedSparkAdvance    ; load A with memory contents
           sba                 ; subtract (A=A-B)
           bvc   LDEEC         ; branch if overflow
           tsta                ; test A
           bpl   LDEEA         ; branch if plus (hi bit 0)
           ldaa  #0x7f         ; load a with value -01111111-
           bra   LDEEC         ; branch

   LDEEA:  ldaa  #0x80         ; load a with value -10000000-
   LDEEC:  bra   LDEF9         ; branch

   LDEEE:  ldx   #SPKAD2_SparkAdvanceAddedWhenRpmBelowControl2_FromDeltaRpm    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  SparkScatter
           adda  CalculatedSparkAdvance
   LDEF9:  staa  Temp5         ; store A into memory
DontUseSparkScatter:
           brclr *BitFlags6C, #$%00010000, LDF04    ; branch if bit(s) clear
           ldab  IDLSET_ConstantSparkAdvanceWhenSettingMinThrottleOpening    ; load B with memory contents (data is 0c)
           stab  Temp5         ; store B into memory
   LDF04:  rts                 ; return from subroutine

InterruptVector_DwellTimer:
           ldaa  #0x08         ; load a with value -00001000-
           staa  CPU_TimerInterruptFlag1
           ldaa  TimerOverflowsBetweenDistPulses    ; load A with memory contents
           bne   LDF31         ; branch if not equal (not zero)
           brset *BitFlags6F, #b6f_DisableNormalDwell, LDF31    ; branch if bit(s) set
           brclr *BitFlags68, #b68_BladePassedSensor, LDF31    ; branch if bit(s) clear
           brset *BitFlags72, #b72_AlternatorField, LDF31    ; branch if bit(s) set
           ldaa  CPU_TimerControlReg1    ; load A with memory contents
           eora  #0x01         ; XOR a with value -00000001-
           staa  CPU_TimerControlReg1
           lsra                ; logic shift right A
           bcs   IgnitionCoil_OnTimeLoad    ; branch if lower
           ldd   CPU_TimerControlReg1
           bitb  #0x10         ;  -00010000-
           bne   IgnitionCoil_OffTimeLoad    ; branch if not equal (not zero)
           oraa  #0x01         ;  -00000001-
           staa  CPU_TimerControlReg1
   LDF31:  rti                 ; return from interrupt

IgnitionCoil_OnTimeLoad:
           ldd   AntiDwellTime_HB    ; load D (A&B) with memory contents
           bra   LDF3A         ; branch

IgnitionCoil_OffTimeLoad:
           ldd   DistributorFallingEdgePulsewidth_HB    ; load D (A&B) with memory contents
           subd  AntiDwellTime_HB    ; D = D - memory contents
   LDF3A:  addd  CPU_Timer_OC5_DwellB
           std   CPU_Timer_OC5_DwellB
           rti                 ; return from interrupt

CalculateKnockRetard_MM:
           clra                ; A = 0
           ldab  EngineRpm_HB    ; load B with memory contents
           cmpb  KNKRPM_MinRpmforKnockRetard    ; compare B with memory contents (data is 00)
           bcs   LDF6F         ; branch if lower
           deca                ; decrement A
           ldab  b5C_IPL1      ; load B with memory contents
           andb  #0xe0         ;  -11100000-
           bne   LDF69         ; branch if not equal (not zero)
           ldaa  MapValue      ; load A with memory contents
           ldab  TPSVolts      ; load B with memory contents
           subb  MINTHR_LowestSessionTPS    ; B = B-memory contents
           bcs   LDF69         ; branch if lower
           cmpb  THRKNK_DeltaAbove_MINTHR    ; compare B with memory contents (data is 00)
           bcs   LDF69         ; branch if lower
           ldab  EngineRpm_HB    ; load B with memory contents
           cmpb  KLMRPM_MinKnockDetectRpm    ; compare B with memory contents (data is 00)
           bcc   LDF69         ; branch if greater or equal
           ldaa  KNKLIM_MaxKnockRetard    ; load A with memory contents (data is 3f)
           bra   LDF6F         ; branch

   LDF69:  ldx   #RETMAX_MaxKnockRetardFromMap    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
   LDF6F:  staa  MaxRetardFromMAP    ; store A into memory
           ldaa  EngineRpm_HB    ; load A with memory contents
           ldx   #DLTKNK_KnockSensorVoltageForKnockFromRpm    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  KnockSensorThreshold    ; store A into memory
           ldaa  INCSR2_KnockRetardIncreaseRate2    ; load A with memory contents (data is ff)
           ldab  BaroPressure    ; load B with memory contents
           addb  KNKOFS_DeltaAboveBaroFor_RTRDRT_and_KNKCNT_and_KNKCOR_incremented    ;  (data is 0c)
           cmpb  MapValue  
           bcc   LDF8A         ; branch if greater or equal
           ldaa  INCSRT_KnockRetardIncreaseRate    ; load A with memory contents (data is ff)
   LDF8A:  bita  Counter_MainLoop
           bne   LDFA0         ; branch if not equal (not zero)
           ldx   #Cylinder2Retard    ; load index with value
   LDF91:  sei                 ; disable interrupts
           ldaa  0x00, X      ; load A with memory at index + value -00000000-
           beq   LDF99         ; branch if equal (zero)
           deca                ; decrement A
           staa  0x00, X      ;  -00000000-
   LDF99:  cli                 ; enable interrupts
           inX                 ; increment index (I=I+1)
           cpx   #Cylinder4Retard    ;  -00000000 11010010-
           bls   LDF91         ; branch if lower or same
   LDFA0:  rts                 ; return from subroutine

   LDFA1:  sei                 ; disable interrupts
           ldaa  AdaptiveRetardIndex    ; load A with memory contents
           suba  ARSUB2_AdaptiveRetardFactorSubtract2    ;  (data is 01)
           bcc   LDFAA         ; branch if greater or equal
           clra                ; A = 0
   LDFAA:  staa  AdaptiveRetardIndex    ; store A into memory
           cli                 ; enable interrupts
           rts                 ; return from subroutine

DetectKnockSensorFault_MM:
           ldaa  KnockVolts    ; load A with memory contents
           cmpa  KNKVLT_KnockVoltsThresholdForFaultDetection    ; compare A with memory contents (data is 01)
           bcs   LDFB9         ; branch if lower
           bclr  *b5D_IPL2, #$%00000010    ; clear bits
           rts                 ; return from subroutine

   LDFB9:  brset *b5D_IPL2, #$%00000010, LDFD6    ; branch if bit(s) set
           ldaa  Counter_MainLoop    ; load A with memory contents
           bita  KNKCML_MinimumMainLoopCountForKnockSensorFaultSetting    ;  (data is 1f)
           bne   LDFD6         ; branch if not equal (not zero)
           ldaa  EngineRpm_HB    ; load A with memory contents
           cmpa  KNKFRP_MinimumRPMForKnockSensorFaultSetting    ; compare A with memory contents (data is 9c)
           bcs   LDFD6         ; branch if lower
           ldd   #0x3b88       ; load D (A&B) with value -00111011 10001000-
           jsr   ThrowNonCriticalError    ; call subroutine
           bcc   LDFD6         ; branch if greater or equal
           bset  *b5D_IPL2, #$%00000010    ; set bits
   LDFD6:  rts                 ; return from subroutine

ClearKnockCap_MM:
           brclr *BitFlags72, #b72_bit6, LDFE3    ; branch if bit(s) clear
           bclr  *PIA2_Buffer, #$%00001000    ; clear bits
           bset  *BitFlags67, #$%00000001    ; set bits
           bra   LDFF5         ; branch

   LDFE3:  ldab  Counter_MainLoop    ; load B with memory contents
           bitb  #0x0f         ;  -00001111-
           bne   LDFF5         ; branch if not equal (not zero)
           brclr *BitFlags67, #$%00000001, LDFF2    ; branch if bit(s) clear
           bclr  *BitFlags67, #$%00000001    ; clear bits
           bra   LDFF5         ; branch

   LDFF2:  bset  *PIA2_Buffer, #$%00001000    ; set bits
   LDFF5:  rts                 ; return from subroutine

CheckAndSetMinSparkAdvance:
           tsta                ; test A
           bpl   LE009         ; branch if plus (hi bit 0)
           ldab  CODE13_       ; load B with memory contents (data is 14)
           andb  #0x10         ;  -00010000-
           bne   SetMinAdvToNeg11Deg    ; branch if not equal (not zero)
           clra                ; A = 0
           bra   LE009         ; branch

SetMinAdvToNeg11Deg:
           cmpa  #0xf4         ; compare a with value -11110100-
           bcc   LE009         ; branch if greater or equal
           ldaa  #0xf4         ; load a with value -11110100-
   LE009:  rts                 ; return from subroutine

DetermineIfSpeedoSensorOnOrOff:
           ldaa  CPU_TimerControlReg2    ; load A with memory contents
           lsra                ; logic shift right A
           eora  CPU_PortA 
           bita  #0x02         ;  -00000010-
           rts                 ; return from subroutine

Interrupt_SpeedometerSignal:
           ldd   CPU_TimerInputCapture2_Speedometer
           std   Temp5         ; store D (A&B) into memory
           bsr   DetermineIfSpeedoSensorOnOrOff    ; call subroutine
           beq   LE027         ; branch if equal (zero)
           fdiv                ; fractional divide ACCD by IX
           bsr   DetermineIfSpeedoSensorOnOrOff    ; call subroutine
           beq   LE027         ; branch if equal (zero)
           fdiv                ; fractional divide ACCD by IX
           bsr   DetermineIfSpeedoSensorOnOrOff    ; call subroutine
           bne   JumpTo_ResetSpeedometerInterruptFlag    ; branch if not equal (not zero)
   LE027:  ldd   Counter_SpeedSensorInterrupt_HB    ; load D (A&B) with memory contents
           addd  #0x0001        ;  -00000000 00000001-
           std   Counter_SpeedSensorInterrupt_HB    ; store D (A&B) into memory
           bne   LE033         ; branch if not equal (not zero)
           bset  *BitFlags71, #$%00000010    ; set bits
   LE033:  inc   MapValueX
           ldd   VehicleSpeed_HB    ; load D (A&B) with memory contents
           subd  #0x0640       ;  -00000110 01000000-
           ldaa  BitFlags71    ; load A with memory contents
           bcc   LE071         ; branch if greater or equal
           bita  #0x10         ;  -00010000-
           bne   LE047         ; branch if not equal (not zero)
           oraa  #0x10         ;  -00010000-
           bra   LE075         ; branch

   LE047:  anda  #0x1f         ; AND a with value -00011111-
           oraa  #0x08         ;  -00001000-
           staa  BitFlags71    ; store A into memory
           clra                ; A = 0
           staa  CruiseControlVarX
           staa  Counter_SomethingWithDistributor
           staa  Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; store A into memory
           ldd   VehicleSpeed_HB    ; load D (A&B) with memory contents
           addd  #CruiseControlVar0    ;  -00000000 01010011-
           std   VehicleSpeed_HB    ; store D (A&B) into memory
           cpd   #0x1fd0       ;  -00011111 11010000-
           bcc   LE06B         ; branch if greater or equal
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           lslb                ; arithmetic shift left B
           adca  #0x00         ;  -00000000-
           bra   LE06D         ; branch

   LE06B:  ldaa  #0xff         ; load a with value -11111111-
   LE06D:  staa  VehicleSpeedScaled    ; store A into memory
JumpTo_ResetSpeedometerInterruptFlag:
           bra   ResetSpeedometerInterruptFlag    ; branch

   LE071:  bita  #0x10         ;  -00010000-
           bne   LE0E6         ; branch if not equal (not zero)
   LE075:  adda  #0x20         ;  -00100000-
           bcs   LE07F         ; branch if lower
           anda  #0xef         ; AND a with value -11101111-
           staa  BitFlags71    ; store A into memory
           bra   ResetSpeedometerInterruptFlag    ; branch

   LE07F:  staa  BitFlags71    ; store A into memory
           ldab  CruiseControlVarX    ; load B with memory contents
           beq   LE0A5         ; branch if equal (zero)
           bita  #0x08         ;  -00001000-
           bne   LE0A5         ; branch if not equal (not zero)
           ldaa  #0x3a         ; load a with value -00111010-
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           cmpa  #0x03         ; compare a with value -00000011-
           bcc   LE095         ; branch if greater or equal
           ldaa  #0x03         ; load a with value -00000011-
   LE095:  tab                 ; B = A
           ldaa  Counter_SomethingWithDistributor    ; load A with memory contents
           suba  CruiseControlVarX
           bcc   LE09F         ; branch if greater or equal
           nega                ; negate A (set high bit)
   LE09F:  sba                 ; subtract (A=A-B)
           bcs   LE0AB         ; branch if lower
           bset  *BitFlags71, #$%00001000    ; set bits
   LE0A5:  ldab  Counter_SomethingWithDistributor    ; load B with memory contents
           stab  CruiseControlVarX    ; store B into memory
   LE0AB:  clra                ; A = 0
           staa  Counter_SomethingWithDistributor
           ldd   Temp5         ; load D (A&B) with memory contents
           bsr   DetermineNumberOfOverflowsBetweenSpeedoPulses_MM    ; call subroutine
           ldaa  Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; load A with memory contents
           lsra                ; logic shift right A
           tab                 ; B = A
           oraa  TimerOverflowsBetweenSpeedoPulses    ; OR A with memory contents
           beq   LE0C3         ; branch if equal (zero)
           stab  TimerOverflowsBetweenSpeedoPulses    ; store B into memory
           ldd   Temp5         ; load D (A&B) with memory contents
           subd  PreviousVehicleSpeed_HB    ; D = D - memory contents
           bra   LE0D7         ; branch

   LE0C3:  ldd   Temp5         ; load D (A&B) with memory contents
           subd  PreviousVehicleSpeed_HB    ; D = D - memory contents
           subd  SpeedoSensorPulsewidth_HB    ; D = D - memory contents
           beq   LE0D9         ; branch if equal (zero)
           asra                ; arithmetic shift right A
           rorb                ; rotate right B
           asra                ; arithmetic shift right A
           rorb                ; rotate right B
           subd  #0x0000        ;  -00000000 00000000-
           bne   LE0D5         ; branch if not equal (not zero)
           incb                ; increment B
   LE0D5:  addd  SpeedoSensorPulsewidth_HB    ; D = D + memory contents
   LE0D7:  std   SpeedoSensorPulsewidth_HB    ; store D (A&B) into memory
   LE0D9:  ldd   Temp5         ; load D (A&B) with memory contents
           std   PreviousVehicleSpeed_HB    ; store D (A&B) into memory
           clra                ; A = 0
           staa  Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; store A into memory
ResetSpeedometerInterruptFlag:
           ldaa  #0x02         ; load a with value -00000010-
           staa  CPU_TimerInterruptFlag1
           rti                 ; return from interrupt

   LE0E6:  anda  #0xef         ; AND a with value -11101111-
           staa  BitFlags71    ; store A into memory
           ldaa  #0x01         ; load a with value -00000001-
           staa  TimerOverflowsBetweenSpeedoPulses    ; store A into memory
           ldd   #0x1940       ; load D (A&B) with value -00011001 01000000-
           bra   LE0D7         ; branch

DetermineNumberOfOverflowsBetweenSpeedoPulses_MM:
           subd  PreviousVehicleSpeed_HB    ; D = D - memory contents
           staa  Temp7         ; store A into memory
           ldaa  Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; load A with memory contents
           lsrd                ; shift right (D=D/2)
           eorb  Temp7     
           bpl   LE10E         ; branch if plus (hi bit 0)
           ldaa  Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; load A with memory contents
           inca                ; increment A
           beq   LE105         ; branch if equal (zero)
           staa  Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; store A into memory
   LE105:  ldaa  Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; load A with memory contents
           lsra                ; logic shift right A
           cmpa  TimerOverflowsBetweenSpeedoPulses    ; compare A with memory contents
           bls   LE10E         ; branch if lower or same
           staa  TimerOverflowsBetweenSpeedoPulses    ; store A into memory
   LE10E:  rts                 ; return from subroutine

ControlCruiseServo1_MM:
           brclr *BitFlags71, #$%00010000, LE12C    ; branch if bit(s) clear
           sei                 ; disable interrupts
           ldd   VehicleSpeed_HB    ; load D (A&B) with memory contents
           lsrd                ; shift right (D=D/2)
           lsrd                ; shift right (D=D/2)
           lsrd                ; shift right (D=D/2)
           lsrd                ; shift right (D=D/2)
           lsrd                ; shift right (D=D/2)
           std   Temp0         ; store D (A&B) into memory
           ldd   VehicleSpeed_HB    ; load D (A&B) with memory contents
           subd  Temp0         ; D = D - memory contents
           std   VehicleSpeed_HB    ; store D (A&B) into memory
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           lslb                ; arithmetic shift left B
           adca  #0x00         ;  -00000000-
           staa  VehicleSpeedScaled    ; store A into memory
           cli                 ; enable interrupts
   LE12C:  ldaa  Timer_CountdownFromStartRunForAisFeedback    ; load A with memory contents
           beq   LE142         ; branch if equal (zero)
           brclr *BitFlags6F, #b6f_JustStarted, LE13B    ; branch if bit(s) clear
           clra                ; A = 0
           ldx   EngineRpm_HB
           cpx   TargetIdleSpeedHB
           bls   LE13E
   LE13B:  ldaa  Timer_CountdownFromStartRunForAisFeedback    ; load A with memory contents
           deca                ; decrement A
   LE13E:  staa  Timer_CountdownFromStartRunForAisFeedback    ; store A into memory
           bra   LE145         ; branch

   LE142:  bset  *BitFlags6F, #b6f_JustStarted    ; set bits
   LE145:  brclr *BitFlags66, #b66_OffIdle, LE14D    ; branch if bit(s) clear
   LE149:  bclr  *BitFlags67, #$%01001000    ; clear bits
           rts                 ; return from subroutine

   LE14D:  ldaa  MPHREF_SwitchPointForDecelIdleAisControl    ; load A with memory contents (data is 08)
           brset *BitFlags67, #b67_IdleSpeedMode, LE15A    ; branch if bit(s) set
           brset *BitFlags67, #b67_FallToIdle, LE15A    ; branch if bit(s) set
           adda  #0x03         ;  -00000011-
   LE15A:  cmpa  VehicleSpeedScaled    ; compare A with memory contents
           bcc   LE149         ; branch if greater or equal
           brset *BitFlags37, #bf37_ATX, LE188    ; branch if bit(s) set
           ldaa  AISMPH_RollingAisMaxSpeed    ; load A with memory contents (data is 28)
           brclr *BitFlags67, #b67_IdleSpeedMode, LE16B    ; branch if bit(s) clear
           adda  #0x03         ;  -00000011-
   LE16B:  cmpa  VehicleSpeedScaled    ; compare A with memory contents
           bcs   LE188         ; branch if lower
           ldd   TargetIdleSpeedHB    ; load D (A&B) with memory contents
           addd  RPMDLT_RollingAisMinRpm    ;  (data is 07)
           cpd   EngineRpm_HB    ; D = D - memory contents
           bcs   LE188         ; branch if lower
           brset *BitFlags67, #b67_IdleSpeedMode, LE181    ; branch if bit(s) set
           ldd   EngineRpm_HB    ; load D (A&B) with memory contents
           std   TargetIdleSpeedHB    ; store D (A&B) into memory
   LE181:  bclr  *BitFlags67, #b67_FallToIdle    ; clear bits
           bset  *BitFlags67, #b67_IdleSpeedMode    ; set bits
           rts                 ; return from subroutine

   LE188:  bset  *BitFlags67, #b67_FallToIdle    ; set bits
           bclr  *BitFlags67, #b67_IdleSpeedMode    ; clear bits
           rts                 ; return from subroutine


;	.org	0xe18f
LE18F:
	.byte	0x15,0x50,0xa1,0xff

ControlCruiseServo0_MM:
           ldaa  #0x10         ; load a with value -00010000-
           tab                 ; B = A
           sei                 ; disable interrupts
           staa  CPU_A2DControlReg
   LE19A:  ldaa  CPU_A2DControlReg    ; load A with memory contents
           bpl   LE19A         ; branch if plus (hi bit 0)
           ldaa  CPU_A2DResults2    ; load A with memory contents
           staa  Temp0         ; store A into memory
           ldaa  #0x14         ; load a with value -00010100-
           staa  CPU_A2DControlReg
   LE1A9:  ldaa  CPU_A2DControlReg    ; load A with memory contents
           bpl   LE1A9         ; branch if plus (hi bit 0)
           ldaa  CPU_A2DResults4    ; load A with memory contents
           stab  CPU_A2DControlReg    ; store B into memory
           cli                 ; enable interrupts
           staa  CruiseControlSwitchStateAnalog
           clra                ; A = 0
           ldab  Temp0         ; load B with memory contents
           beq   LE1CB         ; branch if equal (zero)
           xgdx                ; exchange D and index
           ldaa  CruiseControlSwitchStateAnalog    ; load A with memory contents
           ldab  #0xff         ; load B with value -11111111-
           mul                 ; multiply (D=A*B)
           idiv                ; integer divide ACCD by IX
           xgdx                ; exchange D and index
           tsta                ; test A
           beq   LE1CB         ; branch if equal (zero)
           ldab  #0xff         ; load B with value -11111111-
   LE1CB:  stab  CruiseControlSwitchStateAnalogSnapshot    ; store B into memory
           tba                 ; A = B
           ldab  #0xff         ; load B with value -11111111-
           ldx   #LE18F-1
   LE1D4:  incb                ; increment B
           inX                 ; increment index (I=I+1)
           cmpa  0x00, X      ; compare A with memory at index + value -00000000-
           bhi   LE1D4         ; branch if higher
           ldaa  CruiseControlSwitchStateDigital    ; load A with memory contents
           anda  #0x03         ; AND a with value -00000011-
           cba                 ; compare A to B
           bne   LE1E9         ; branch if not equal (not zero)
           ldab  CruiseControlSwitchStateDigital    ; load B with memory contents
           addb  #0x20         ;  -00100000-
           bcs   LE1EE         ; branch if lower
   LE1E9:  stab  CruiseControlSwitchStateDigital    ; store B into memory
           bra   LE210         ; branch

   LE1EE:  bitb  #0x03         ;  -00000011-
           beq   LE207         ; branch if equal (zero)
           bset  *StartupSwitchMirror1, #$%00000100    ; set bits
           bitb  #0x02         ;  -00000010-
           beq   LE20A         ; branch if equal (zero)
           bitb  #0x01         ;  -00000001-
           bne   LE202         ; branch if not equal (not zero)
           bset  *StartupSwitchMirror1, #$%00001010    ; set bits
           bra   LE210         ; branch

   LE202:  bclr  *StartupSwitchMirror1, #$%00001010    ; clear bits
           bra   LE210         ; branch

   LE207:  bclr  *StartupSwitchMirror1, #$%00000100    ; clear bits
   LE20A:  bclr  *StartupSwitchMirror1, #$%00001000    ; clear bits
           bset  *StartupSwitchMirror1, #$%00000010    ; set bits
   LE210:  ldaa  TimerOverflowsBetweenDistPulses    ; load A with memory contents
           bne   LE22A         ; branch if not equal (not zero)
           ldab  VehicleSpeedScaled    ; load B with memory contents
           ldaa  DistributorFallingEdgePulsewidth_HB    ; load A with memory contents
           mul                 ; multiply (D=A*B)
           xgdy                ; exchange D and index
           ldaa  #0x11         ; load a with value -00010001-
           jsr   ScaleYbyA     ; call subroutine
           xgdy                ; exchange D and index
           tsta                ; test A
           beq   LE227         ; branch if equal (zero)
           ldab  #0xff         ; load B with value -11111111-
   LE227:  stab  ScaledDistPWForCruiseControl    ; store B into memory
   LE22A:  bclr  *Counter_Cruise_1, #$%00001111    ; clear bits
           brset *StartupSwitchMirror1, #$%00000100, LE236    ; branch if bit(s) set
           clrb                ; b = 0
           stab  CruiseSpeedSetpoint    ; store B into memory
           bra   LE28B         ; branch

   LE236:  inc   Counter_Cruise_1
           ldaa  VehicleSpeedScaled    ; load A with memory contents
           cmpa  CRUZ21_UnknownConstForCruiseControl21    ; compare A with memory contents (data is 3c)
           bcs   LE283         ; branch if lower
           inc   Counter_Cruise_1
           ldaa  EngineRpm_HB    ; load A with memory contents
           cmpa  CRUZ22_UnknownConstForCruiseControl22    ; compare A with memory contents (data is bc)
           bcc   LE283         ; branch if greater or equal
           inc   Counter_Cruise_1
           brset *StartupSwitchMirror1, #$%00100000, LE283    ; branch if bit(s) set
           inc   Counter_Cruise_1
           brclr *BitFlags37, #bf37_ATX, LE264    ; branch if bit(s) clear
           brclr *StartupSwitchMirror1, #$%00010000, LE283    ; branch if bit(s) clear
           inc   Counter_Cruise_1
           inc   Counter_Cruise_1
           bra   LE2BF         ; branch

   LE264:  inc   Counter_Cruise_1
           ldaa  TimerOverflowsBetweenDistPulses    ; load A with memory contents
           bne   LE278         ; branch if not equal (not zero)
           ldab  ScaledDistPWForCruiseControl    ; load B with memory contents
           cmpb  SCNVHI_CruiseControlForBrakeFlagManualTransmissionClutchDisableHi    ; compare B with memory contents (data is f1)
           bcc   LE283         ; branch if greater or equal
           cmpb  SCNVLO_CruiseControlForBrakeFlagManualTransmissionClutchDisableLo    ; compare B with memory contents (data is 52)
           bcs   LE283         ; branch if lower
   LE278:  inc   Counter_Cruise_1
           brset *CruiseStatus_1, #$%10000000, LE2BF    ; branch if bit(s) set
           brclr *BitFlags71, #$%00001000, LE2BF    ; branch if bit(s) clear
   LE283:  brclr *CruiseStatus_1, #$%00011000, LE28B    ; branch if bit(s) clear
           ldaa  VehicleSpeedScaled    ; load A with memory contents
           staa  CruiseSpeedSetpoint    ; store A into memory
   LE28B:  brset *CruiseStatus_1, #$%10000000, LE298    ; branch if bit(s) set
           ldab  Counter_Cruise_1    ; load B with memory contents
           andb  #0x0f         ;  -00001111-
           ldaa  #0x11         ; load a with value -00010001-
           mul                 ; multiply (D=A*B)
   LE296:  stab  Counter_Cruise_1    ; store B into memory
   LE298:  clrb                ; b = 0
           stab  Counter_Cruise_2    ; store B into memory
           stab  Counter_Cruise_3    ; store B into memory
           stab  CruiseControlVar0    ; store B into memory
           stab  Counter_Cruise    ; store B into memory
           stab  CruiseControlVar4    ; store B into memory
           stab  CruiseControlVar2    ; store B into memory
           bclr  *CruiseStatus_1, #$%00011111    ; clear bits
           bset  *CruiseStatus_1, #$%10100000    ; set bits
           bclr  *CruiseStatus_2, #$%00001111    ; clear bits
           brset *StartupSwitchMirror1, #$%00000100, LE2B9    ; branch if bit(s) set
           ldaa  CRUZ7_UnknownTableForCruiseControl7    ; load A with memory contents (data is 00)
           bita  #0x80         ;  -10000000-
           bne   LE2BC         ; branch if not equal (not zero)
   LE2B9:  bset  *Counter_Cruise_2, #$%10000000    ; set bits
   LE2BC:  jmp   LE4A2     

   LE2BF:  inc   Counter_Cruise_1
           brset *CruiseStatus_1, #$%01000000, LE283    ; branch if bit(s) set
           ldab  CCDFlagsX     ; load B with memory contents
           eorb  CCDFlags3 
           andb  #0xc0         ;  -11000000-
           beq   LE31F         ; branch if equal (zero)
           tba                 ; A = B
           eorb  CCDFlagsX
           staa  Temp1         ; store A into memory
           andb  Temp1     
           stab  Temp1         ; store B into memory
           beq   LE30A         ; branch if equal (zero)
           brset *CruiseStatus_1, #$%10000000, LE2FE    ; branch if bit(s) set
           ldd   #0x0f89       ; load D (A&B) with value -00001111 10001001-
           jsr   ThrowNonCriticalError    ; call subroutine
           ldd   #0x0f08       ; load D (A&B) with value -00001111 00001000-
           ldx   #ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB    ; load index with value
           cmpa  0x00, X      ; compare A with memory at index + value -00000000-
           beq   LE2F4         ; branch if equal (zero)
           inX                 ; increment index (I=I+1)
           cmpa  0x00, X      ; compare A with memory at index + value -00000000-
           bne   LE31F         ; branch if not equal (not zero)
   LE2F4:  cmpb  0x02, X      ;  -00000010-
           bne   LE31F         ; branch if not equal (not zero)
           clr   0x00, X       ; clear memory
           clr   0x02, X       ; clear memory
           bra   LE31C         ; branch

   LE2FE:  ldaa  #0x7f         ; load a with value -01111111-
           brset *Temp1, #$%11000000, LE306    ; branch if bit(s) set
           ldaa  #0x07         ; load a with value -00000111-
   LE306:  bita  Counter_MainLoop
           bne   LE31C         ; branch if not equal (not zero)
   LE30A:  pshb                ; push B onto stack
           ldd   #0x0f90       ; load D (A&B) with value -00001111 10010000-
           jsr   ThrowNonCriticalError    ; call subroutine
           pulb                ; pull B from stack
           bcs   LE319         ; branch if lower
           tstb                ; test B
           beq   LE31F         ; branch if equal (zero)
           bra   LE31C         ; branch

   LE319:  bset  *CruiseStatus_1, #$%01000000    ; set bits
   LE31C:  jmp   LE283     

   LE31F:  inc   Counter_Cruise_1
           ldaa  CRUZ7_UnknownTableForCruiseControl7    ; load A with memory contents (data is 00)
           bita  #0x80         ;  -10000000-
           beq   LE331         ; branch if equal (zero)
           brset *CruiseStatus_1, #$%00000001, LE331    ; branch if bit(s) set
           brclr *StartupSwitchMirror1, #$%00001000, LE39A    ; branch if bit(s) clear
   LE331:  brset *StartupSwitchMirror1, #$%00000010, LE39A    ; branch if bit(s) set
           ldab  Counter_Cruise_2    ; load B with memory contents
           incb                ; increment B
           bne   LE33B         ; branch if not equal (not zero)
           decb                ; decrement B
   LE33B:  stab  Counter_Cruise_2    ; store B into memory
           brset *CruiseStatus_1, #$%00000001, LE363    ; branch if bit(s) set
           brset *Counter_Cruise_2, #$%10000000, LE376    ; branch if bit(s) set
           cmpb  #0x00         ;  -00000000-
           bls   LE376         ; branch if lower or same
           bset  *CruiseStatus_1, #$%00100001    ; set bits
           bclr  *CruiseStatus_1, #$%00001010    ; clear bits
           bset  *CruiseStatus_2, #$%00000100    ; set bits
           clra                ; A = 0
           staa  Counter_Cruise_3    ; store A into memory
           staa  CruiseControlVar0    ; store A into memory
           ldaa  CRUZ7_UnknownTableForCruiseControl7    ; load A with memory contents (data is 00)
           bita  #0x80         ;  -10000000-
           bne   LE376         ; branch if not equal (not zero)
           bclr  *CruiseStatus_1, #$%00000100    ; clear bits
           bra   LE376         ; branch

   LE363:  brset *CruiseStatus_1, #$%10000000, LE376    ; branch if bit(s) set
           brset *CruiseStatus_1, #$%00010000, LE388    ; branch if bit(s) set
           ldaa  CRUZ7_UnknownTableForCruiseControl7    ; load A with memory contents (data is 00)
           bita  #0x80         ;  -10000000-
           beq   LE379         ; branch if equal (zero)
           cmpb  #0x38         ;  -00111000-
           bhi   LE37E         ; branch if higher
   LE376:  jmp   LE58F     

   LE379:  cmpb  CRUZ46_UnknownConstForCruiseControl46    ; compare B with memory contents (data is 00)
           bls   LE376         ; branch if lower or same
   LE37E:  bset  *CruiseStatus_1, #$%00010000    ; set bits
           bclr  *CruiseStatus_2, #$%00000011    ; clear bits
           ldaa  VehicleSpeedScaled    ; load A with memory contents
           staa  CruiseControlVar0    ; store A into memory
   LE388:  ldab  CruiseStatus_2    ; load B with memory contents
           cmpb  #0xa0         ;  -10100000-
           bcs   LE376         ; branch if lower
           ldab  CruiseControlVar0    ; load B with memory contents
           subb  CRUZ32_UnknownConstForCruiseControl32    ; subtract memory contents from B (data is 08)
           bcc   LE396         ; branch if greater or equal
           clrb                ; b = 0
   LE396:  stab  CruiseControlVar0    ; store B into memory
           bra   LE376         ; branch

   LE39A:  brclr *CruiseStatus_1, #$%00000001, LE405    ; branch if bit(s) clear
           ldaa  #0x7f         ; load a with value -01111111-
           brset *CruiseStatus_1, #$%10000000, LE3DB    ; branch if bit(s) set
           brset *CruiseStatus_2, #$%00001000, LE3B2    ; branch if bit(s) set
           ldab  CruiseSpeedSetpoint    ; load B with memory contents
           subb  VehicleSpeedScaled    ; B = B-memory contents
           bcc   LE3B2         ; branch if greater or equal
           cmpb  #0xfc         ;  -11111100-
           bcs   LE3DB         ; branch if lower
   LE3B2:  brset *CruiseStatus_1, #$%00010000, LE3C0    ; branch if bit(s) set
           ldaa  CRUZ7_UnknownTableForCruiseControl7    ; load A with memory contents (data is 00)
           anda  #0x80         ; AND a with value -10000000-
           beq   LE3E1         ; branch if equal (zero)
           jmp   LE46E     

   LE3C0:  ldaa  Counter_Cruise_3    ; load A with memory contents
           ldab  CRUZ31_UnknownConstForCruiseControl31    ; load B with memory contents (data is 4d)
           addb  #0x80         ;  -10000000-
           bmi   LE3D0         ; branch if minus(hi bit 1)
           mul                 ; multiply (D=A*B)
           adca  Counter_Cruise_3
           bcs   LE3D7         ; branch if lower
           bra   LE3D3         ; branch

   LE3D0:  mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
   LE3D3:  cmpa  #0x7f         ; compare a with value -01111111-
           bls   LE3E1         ; branch if lower or same
   LE3D7:  ldaa  #0x7f         ; load a with value -01111111-
           bra   LE3E1         ; branch

   LE3DB:  bset  *CruiseStatus_2, #$%00000001    ; set bits
           clrb                ; b = 0
           stab  CruiseControlVar4    ; store B into memory
   LE3E1:  ldab  VehicleSpeedScaled    ; load B with memory contents
           stab  CruiseSpeedSetpoint    ; store B into memory
           staa  Temp2         ; store A into memory
           jsr   LE883         ; call subroutine
           ldab  Temp2         ; load B with memory contents
           cba                 ; compare A to B
           bhi   LE3F0         ; branch if higher
           tab                 ; B = A
   LE3F0:  bclr  *CruiseStatus_1, #$%10010001    ; clear bits
           bclr  *CruiseStatus_2, #$%00001000    ; clear bits
           bclr  *BitFlags71, #$%00001000    ; clear bits
           clra                ; A = 0
           staa  Counter_Cruise_3    ; store A into memory
           staa  Counter_Cruise_2    ; store A into memory
           staa  CruiseControlVar0    ; store A into memory
           staa  Counter_Cruise    ; store A into memory
           jmp   LE4A2     

   LE405:  clrb                ; b = 0
           stab  Counter_Cruise_2    ; store B into memory
           brset *StartupSwitchMirror1, #$%00001000, LE40F    ; branch if bit(s) set
           jmp   LE519     

   LE40F:  ldab  Counter_Cruise_3    ; load B with memory contents
           incb                ; increment B
           bne   LE415         ; branch if not equal (not zero)
           decb                ; decrement B
   LE415:  stab  Counter_Cruise_3    ; store B into memory
           brclr *CruiseStatus_1, #$%00000010, LE41E    ; branch if bit(s) clear
           jmp   LE4C5     

   LE41E:  brclr *CruiseStatus_1, #$%00100000, LE425    ; branch if bit(s) clear
           jmp   LE570     

   LE425:  cmpb  #0x00         ;  -00000000-
           bhi   LE42C         ; branch if higher
           jmp   LE58F     

   LE42C:  bset  *CruiseStatus_1, #$%00000110    ; set bits
           bset  *CruiseStatus_2, #$%00000100    ; set bits
           clra                ; A = 0
           staa  Counter_Cruise    ; store A into memory
           brclr *CruiseStatus_1, #$%10000000, LE46E    ; branch if bit(s) clear
           bset  *CruiseStatus_1, #$%00100000    ; set bits
           bclr  *CruiseStatus_1, #$%10000000    ; clear bits
           bclr  *BitFlags71, #$%00001000    ; clear bits
           jsr   LE883         ; call subroutine
           staa  Temp2         ; store A into memory
           ldaa  CruiseSpeedSetpoint    ; load A with memory contents
           suba  VehicleSpeedScaled
           bcc   LE450         ; branch if greater or equal
           tab                 ; B = A
           eorb  #0x80         ;  -10000000-
   LE450:  bpl   LE457         ; branch if plus (hi bit 0)
           lsla                ; logical shift left A
           ldaa  #0x80         ; load a with value -10000000-
           sbca  #0x00         ;  -00000000-
   LE457:  adda  #0x80         ;  -10000000-
           ldx   #RESTBL2_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference2    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           addb  #0x80         ;  -10000000-
           addb  Temp2         ; B=B+memory contents
           bpl   LE4B3         ; branch if plus (hi bit 0)
           bvc   LE46B         ; branch if overflow
           ldab  #0x7f         ; load B with value -01111111-
           bra   LE4B3         ; branch

   LE46B:  clrb                ; b = 0
           bra   LE4B3         ; branch

   LE46E:  bclr  *CruiseStatus_2, #$%00000011    ; clear bits
           ldab  CruiseControlVar3    ; load B with memory contents
           ldaa  CRUZ7_UnknownTableForCruiseControl7    ; load A with memory contents (data is 00)
           bita  #0x40         ;  -01000000-
           bne   LE498         ; branch if not equal (not zero)
           ldaa  CruiseSpeedSetpoint    ; load A with memory contents
           adda  #0x04         ;  -00000100-
           staa  CruiseSpeedSetpoint    ; store A into memory
           suba  #0x03         ;  -00000011-
           cmpa  MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; compare A with memory contents (data is c8)
           bhi   LE498         ; branch if higher
           ldab  CRUZ23_UnknownConstForCruiseControl23    ; load B with memory contents (data is 08)
           ldaa  CruiseControlVar3    ; load A with memory contents
           bmi   LE498         ; branch if minus(hi bit 1)
           aba                 ; A=A+B
           bcs   LE495         ; branch if lower
           cmpa  #0x7f         ; compare a with value -01111111-
           bls   LE497         ; branch if lower or same
   LE495:  ldaa  #0x7f         ; load a with value -01111111-
   LE497:  tab                 ; B = A
   LE498:  ldaa  CRUZ7_UnknownTableForCruiseControl7    ; load A with memory contents (data is 00)
           bita  #0x80         ;  -10000000-
           beq   LE4A2         ; branch if equal (zero)
           jmp   LE3F0     

   LE4A2:  ldaa  CruiseSpeedSetpoint    ; load A with memory contents
           beq   LE4B5         ; branch if equal (zero)
           cmpa  MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; compare A with memory contents (data is c8)
           bls   LE4B8         ; branch if lower or same
           bclr  *CruiseStatus_2, #$%00000011    ; clear bits
           ldaa  MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; load A with memory contents (data is c8)
           staa  CruiseSpeedSetpoint    ; store A into memory
   LE4B3:  stab  CruiseControlVar3    ; store B into memory
   LE4B5:  jmp   LE58F     

   LE4B8:  cmpa  MINSET_CruiseControlMinSetSpeedTimesTwo    ; compare A with memory contents (data is 46)
           bcc   LE4B3         ; branch if greater or equal
           clra                ; A = 0
           staa  CruiseSpeedSetpoint    ; store A into memory
           ldab  #0x11         ; load B with value -00010001-
           jmp   LE296     

   LE4C5:  brset *CruiseStatus_1, #$%00100000, LE4B5    ; branch if bit(s) set
           brset *CruiseStatus_1, #$%00001000, LE4E3    ; branch if bit(s) set
           cmpb  CRUZ47_UnknownConstForCruiseControl47    ; compare B with memory contents (data is 2f)
           bls   LE4B5         ; branch if lower or same
           bset  *CruiseStatus_1, #$%00001000    ; set bits
           bset  *CruiseStatus_2, #$%00001000    ; set bits
           ldaa  VehicleSpeedScaled    ; load A with memory contents
           adda  CRUZ34_UnknownConstForCruiseControl34    ;  (data is 20)
           bcc   LE4E1         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   LE4E1:  staa  CruiseControlVar0    ; store A into memory
   LE4E3:  ldaa  VehicleSpeedScaled    ; load A with memory contents
           cmpa  MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; compare A with memory contents (data is c8)
           bcs   LE4F1         ; branch if lower
           bset  *CruiseStatus_1, #$%00100000    ; set bits
           ldab  CruiseControlVar3    ; load B with memory contents
           bra   LE55A         ; branch

   LE4F1:  ldab  CruiseStatus_2    ; load B with memory contents
           cmpb  #0xa0         ;  -10100000-
           bcs   LE4B5         ; branch if lower
           ldab  CruiseControlVar0    ; load B with memory contents
           subb  CRUZ33_UnknownConstForCruiseControl33    ; subtract memory contents from B (data is 01)
           bcc   LE4FF         ; branch if greater or equal
           clrb                ; b = 0
   LE4FF:  cmpb  MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; compare B with memory contents (data is c8)
           bcc   LE515         ; branch if greater or equal
           adda  CRUZ35_UnknownConstForCruiseControl35    ;  (data is 15)
           bcs   LE512         ; branch if lower
           cba                 ; compare A to B
           bls   LE515         ; branch if lower or same
           tab                 ; B = A
           cmpb  MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; compare B with memory contents (data is c8)
           bls   LE515         ; branch if lower or same
   LE512:  ldab  MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; load B with memory contents (data is c8)
   LE515:  stab  CruiseControlVar0    ; store B into memory
           bra   LE4B5         ; branch

   LE519:  bclr  *CruiseStatus_1, #$%00000010    ; clear bits
           brset *CruiseStatus_1, #$%10000000, LE527    ; branch if bit(s) set
           ldaa  CRUZ7_UnknownTableForCruiseControl7    ; load A with memory contents (data is 00)
           bita  #0x80         ;  -10000000-
           bne   LE570         ; branch if not equal (not zero)
   LE527:  ldaa  CruiseSpeedSetpoint    ; load A with memory contents
           beq   LE52E         ; branch if equal (zero)
           bclr  *CruiseStatus_1, #$%00100000    ; clear bits
   LE52E:  brclr *CruiseStatus_1, #$%00001000, LE570    ; branch if bit(s) clear
           ldaa  CRUZ7_UnknownTableForCruiseControl7    ; load A with memory contents (data is 00)
           bita  #0x40         ;  -01000000-
           bne   LE549         ; branch if not equal (not zero)
           ldaa  Counter_Cruise_3    ; load A with memory contents
           cmpa  #0x5d         ; compare a with value -01011101-
           bhi   LE549         ; branch if higher
           bclr  *CruiseStatus_1, #$%00001000    ; clear bits
           bclr  *CruiseStatus_2, #$%00001000    ; clear bits
           stab  CruiseControlVar0    ; store B into memory
           bra   LE570         ; branch

   LE549:  ldaa  VehicleSpeedScaled    ; load A with memory contents
           adda  #0x04         ;  -00000100-
           suba  CruiseSpeedSetpoint
           bcc   LE552         ; branch if greater or equal
           clra                ; A = 0
   LE552:  ldx   #CRUZ6_UnknownTableForCruiseControl6    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           orab  #0x80         ;  -10000000-
   LE55A:  ldaa  VehicleSpeedScaled    ; load A with memory contents
           staa  CruiseSpeedSetpoint    ; store A into memory
           bclr  *CruiseStatus_1, #$%00001100    ; clear bits
           bclr  *CruiseStatus_2, #$%00001000    ; clear bits
           clra                ; A = 0
           staa  CruiseControlVar0    ; store A into memory
           staa  Counter_Cruise_3    ; store A into memory
           tstb                ; test B
           bmi   LE56D         ; branch if minus(hi bit 1)
           clrb                ; b = 0
   LE56D:  jmp   LE4A2     

   LE570:  clrb                ; b = 0
           stab  Counter_Cruise_3    ; store B into memory
           ldaa  CruiseStatus_2    ; load A with memory contents
           eora  #0x04         ; XOR a with value -00000100-
           bita  #0x07         ;  -00000111-
           bne   LE58F         ; branch if not equal (not zero)
           ldaa  Counter_MainLoop    ; load A with memory contents
           bne   LE58F         ; branch if not equal (not zero)
           ldab  Counter_Cruise    ; load B with memory contents
           incb                ; increment B
           cmpb  CRUZ26_UnknownConstForCruiseControl26    ; compare B with memory contents (data is 02)
           bcs   LE58B         ; branch if lower
           bclr  *CruiseStatus_2, #$%00000100    ; clear bits
           clrb                ; b = 0
   LE58B:  stab  Counter_Cruise    ; store B into memory
           bra   LE58F         ; branch

   LE58F:  brset *CruiseStatus_1, #$%10000000, LE5A4    ; branch if bit(s) set
           inc   Counter_Cruise_1
           brclr *CruiseStatus_1, #$%00011000, LE5A4    ; branch if bit(s) clear
           inc   Counter_Cruise_1
           brset *CruiseStatus_1, #$%00001000, LE5A4    ; branch if bit(s) set
           inc   Counter_Cruise_1
   LE5A4:  ldaa  CruiseStatus_2    ; load A with memory contents
           adda  #0x10         ;  -00010000-
           cmpa  #0xb0         ; compare a with value -10110000-
           bcs   LE5AE         ; branch if lower
           anda  #0x0f         ; AND a with value -00001111-
   LE5AE:  staa  CruiseStatus_2    ; store A into memory
           anda  #0xf0         ; AND a with value -11110000-
           beq   LE5B7         ; branch if equal (zero)
           jmp   LE84A     

   LE5B7:  clrb                ; b = 0
           brclr *BitFlags71, #$%00010000, LE5BF    ; branch if bit(s) clear
           jmp   LE6A7     

   LE5BF:  ldy   #SpeedoSensorPulsewidth_HB    ; load index with value
           ldx   #0xd000       ; load index with value
           ldd   #0x06dd       ; load D (A&B) with value -00000110 11011101-
           brclr *TimerOverflowsBetweenSpeedoPulses, #$%11111111, LE5DA    ; branch if bit(s) clear
           clrb                ; b = 0
           clra                ; A = 0
           brset *TimerOverflowsBetweenSpeedoPulses, #$%01000000, LE5DD    ; branch if bit(s) set
           ldab  #0x06         ; load B with value -00000110-
           deY                 ; decrement index (I=I-1)
           ldx   #0xddd0       ; load index with value
   LE5DA:  jsr   CalculateVehicleSpeedOrEngineRpms    ; call subroutine
   LE5DD:  ldx   VehicleSpeed_HB
           stx   Temp0         ; store index into memory
           std   VehicleSpeed_HB    ; store D (A&B) into memory
           cpd   #0x1fd0       ;  -00011111 11010000-
           bcc   LE5F1         ; branch if greater or equal
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           lslb                ; arithmetic shift left B
           adca  #0x00         ;  -00000000-
           bra   LE5F3         ; branch

   LE5F1:  ldaa  #0xff         ; load a with value -11111111-
   LE5F3:  staa  VehicleSpeedScaled    ; store A into memory
           brclr *CruiseStatus_2, #$%00000010, LE664    ; branch if bit(s) clear
           ldaa  Counter_Cruise    ; load A with memory contents
           brclr *CruiseStatus_2, #$%00000001, LE60F    ; branch if bit(s) clear
           cmpa  CRMASK_CruiseMask    ; compare A with memory contents (data is 11)
           bcc   LE609         ; branch if greater or equal
           inca                ; increment A
           staa  Counter_Cruise    ; store A into memory
           bra   LE664         ; branch

   LE609:  bclr  *CruiseStatus_2, #$%00000001    ; clear bits
           clra                ; A = 0
           staa  Counter_Cruise    ; store A into memory
   LE60F:  cmpa  CRSCN1_CruiseComapreConstant1    ; compare A with memory contents (data is 16)
           bcs   LE666         ; branch if lower
           ldab  CruiseControlVar4    ; load B with memory contents
           tba                 ; A = B
           bpl   LE61A         ; branch if plus (hi bit 0)
           negb                ; 2's complement B
   LE61A:  cmpb  CRSCN2_CruiseComapreConstant2    ; compare B with memory contents (data is 06)
           bcs   LE65E         ; branch if lower
           ldx   #L002D        ; load index with value
           ldab  CruiseSpeedSetpoint    ; load B with memory contents
           cmpb  CRUZ36_UnknownConstForCruiseControl36    ; compare B with memory contents (data is 8c)
           bls   LE62A         ; branch if lower or same
           inX                 ; increment index (I=I+1)
   LE62A:  ldab  0x00, X      ; load B with memory at index + value -00000000-
           adda  0x02, X      ;  -00000010-
           bvc   LE635         ; branch if overflow
           lsla                ; logical shift left A
           ldaa  #0x80         ; load a with value -10000000-
           sbca  #0x00         ;  -00000000-
   LE635:  staa  0x02, X      ;  -00000010-
           cmpa  CRMSK2_CruiseMask2    ; compare A with memory contents (data is 07)
           bgt   LE64E         ; branch if greater
           cmpa  CRMSK3_CruiseMask3    ; compare A with memory contents (data is f4)
           bge   LE65E         ; branch if greater or equal
           subb  CRMSK4_CruiseMask4    ; subtract memory contents from B (data is 02)
           cmpb  CRMSK5_CruiseMask5    ; compare B with memory contents (data is e1)
           bge   LE659         ; branch if greater or equal
           ldab  CRMSK5_CruiseMask5    ; load B with memory contents (data is e1)
           bra   LE659         ; branch

   LE64E:  addb  CRMSK7_CruiseMask7    ;  (data is 01)
           cmpb  CRMSK6_CruiseMask6    ; compare B with memory contents (data is 1f)
           ble   LE659         ; branch if less or equal
           ldab  CRMSK6_CruiseMask6    ; load B with memory contents (data is 1f)
   LE659:  stab  0x00, X      ;  -00000000-
           clra                ; A = 0
           staa  0x02, X      ;  -00000010-
   LE65E:  bclr  *CruiseStatus_2, #$%00000010    ; clear bits
           clra                ; A = 0
           staa  Counter_Cruise    ; store A into memory
   LE664:  bra   LE690         ; branch

   LE666:  inca                ; increment A
           staa  Counter_Cruise    ; store A into memory
           ldd   VehicleSpeed_HB    ; load D (A&B) with memory contents
           lsrd                ; shift right (D=D/2)
           lsrd                ; shift right (D=D/2)
           lsrd                ; shift right (D=D/2)
           ldaa  CruiseSpeedSetpoint    ; load A with memory contents
           lsla                ; logical shift left A
           lsla                ; logical shift left A
           sba                 ; subtract (A=A-B)
           adda  SETDLT_CruiseControlSetDeltaControlPointForCableAdaptive    ;  (data is 00)
           bmi   LE685         ; branch if minus(hi bit 1)
           ldab  CruiseControlVar4    ; load B with memory contents
           bpl   LE67E         ; branch if plus (hi bit 0)
           comb                ; 1's complement B
           incb                ; increment B
   LE67E:  cba                 ; compare A to B
           ble   LE690         ; branch if less or equal
           staa  CruiseControlVar4    ; store A into memory
           bra   LE690         ; branch

   LE685:  ldab  CruiseControlVar4    ; load B with memory contents
           bmi   LE68B         ; branch if minus(hi bit 1)
           comb                ; 1's complement B
           incb                ; increment B
   LE68B:  cba                 ; compare A to B
           bge   LE690         ; branch if greater or equal
           staa  CruiseControlVar4    ; store A into memory
   LE690:  ldd   Temp0         ; load D (A&B) with memory contents
           subd  VehicleSpeed_HB    ; D = D - memory contents
           bne   LE699         ; branch if not equal (not zero)
           clr   CruiseControlVar1    ; zero byte at memory location
   LE699:  std   Temp0         ; store D (A&B) into memory
           clra                ; A = 0
           ldab  CruiseControlVar1    ; load B with memory contents
           bpl   LE6A1         ; branch if plus (hi bit 0)
           deca                ; decrement A
   LE6A1:  addd  Temp0         ; D = D + memory contents
           asra                ; arithmetic shift right A
           rorb                ; rotate right B
           bsr   LE6AB         ; call subroutine
   LE6A7:  stab  CruiseControlVar1    ; store B into memory
           bra   LE6BC         ; branch

   LE6AB:  asld                ; shift left (D=D*2)
           bcs   LE6B4         ; branch if lower
           tsta                ; test A
           beq   LE6BA         ; branch if equal (zero)
           ldab  #0x7f         ; load B with value -01111111-
           rts                 ; return from subroutine

   LE6B4:  cmpa  #0xff         ; compare a with value -11111111-
           beq   LE6B9         ; branch if equal (zero)
           clrb                ; b = 0
   LE6B9:  sec                 ; set carry
   LE6BA:  rorb                ; rotate right B
           rts                 ; return from subroutine

   LE6BC:  brset *CruiseStatus_1, #$%10000000, LE710    ; branch if bit(s) set
           ldx   #VACREG_CruiseControlVacRegularGainGurve_FromDeltaSpeed    ; load index with value
           clrb                ; b = 0
           ldaa  CruiseSpeedSetpoint    ; load A with memory contents
           brclr *CruiseStatus_1, #$%00011000, LE6CC    ; branch if bit(s) clear
           ldaa  CruiseControlVar0    ; load A with memory contents
   LE6CC:  lsrd                ; shift right (D=D/2)
           lsrd                ; shift right (D=D/2)
           lsrd                ; shift right (D=D/2)
           subd  VehicleSpeed_HB    ; D = D - memory contents
           bcc   LE713         ; branch if greater or equal
           bclr  *CruiseStatus_1, #$%00000100    ; clear bits
           ldx   #VENTRG_CruiseControlVentRegularGainCurve_FromDeltaSpeed    ; load index with value
           coma                ; 1's complement A
           comb                ; 1's complement B
           addd  #0x0001        ;  -00000000 00000001-
           stab  Temp0         ; store B into memory
           tsta                ; test A
           beq   LE6E6         ; branch if equal (zero)
           bset  *Temp0, #$%11111111    ; set bits
   LE6E6:  lsrd                ; shift right (D=D/2)
           lsrd                ; shift right (D=D/2)
           brclr *CruiseStatus_1, #$%00010000, LE6F6    ; branch if bit(s) clear
           ldx   #CRUZ1_UnknownTableForCruiseControl1    ; load index with value
           tsta                ; test A
           beq   LE729         ; branch if equal (zero)
           ldaa  #0xff         ; load a with value -11111111-
           bra   LE72A         ; branch

   LE6F6:  tsta                ; test A
           bne   LE70A         ; branch if not equal (not zero)
           cmpb  VNTAB1_CruiseControlLimitToAMaxVent    ; compare B with memory contents (data is 90)
           bcc   LE70A         ; branch if greater or equal
           tba                 ; A = B
           ldab  Temp0         ; load B with memory contents
           cmpa  VNTAB2_CruiseControlLimitToHalfMaxVent    ; compare A with memory contents (data is 60)
           bcs   LE729         ; branch if lower
           ldaa  #0x05         ; load a with value -00000101-
           bra   LE70C         ; branch

   LE70A:  ldaa  #0x0f         ; load a with value -00001111-
   LE70C:  oraa  #0x80         ;  -10000000-
           staa  CruiseControlVar3    ; store A into memory
   LE710:  jmp   LE84A     

   LE713:  brclr *CruiseStatus_1, #$%00001100, LE71C    ; branch if bit(s) clear
           ldx   #VACACC_CruiseControlVacAcceleratedGainCurve_FromDeltaSpeed    ; load index with value
           lsrd                ; shift right (D=D/2)
           lsrd                ; shift right (D=D/2)
   LE71C:  tsta                ; test A
           beq   LE721         ; branch if equal (zero)
           ldab  #0xff         ; load B with value -11111111-
   LE721:  cmpb  ACLRST_CruiseControlDeltaSpeedToResetAccFlag    ; compare B with memory contents (data is 09)
           bcc   LE729         ; branch if greater or equal
           bclr  *CruiseStatus_1, #$%00000100    ; clear bits
   LE729:  tba                 ; A = B
   LE72A:  jsr   Lookup4ByteTable    ; call subroutine
           clra                ; A = 0
           tstb                ; test B
           bpl   LE732         ; branch if plus (hi bit 0)
           deca                ; decrement A
   LE732:  std   Temp0         ; store D (A&B) into memory
           ldx   #THGAIN_CruiseControlThrottleGainFactor_FromThrottle    ; load index with value
           ldaa  TPSVolts      ; load A with memory contents
           suba  MINTHR_LowestSessionTPS
           bcc   LE73E         ; branch if greater or equal
           clra                ; A = 0
   LE73E:  jsr   Lookup4ByteTable    ; call subroutine
           staa  Temp3         ; store A into memory
           ldx   #SPGAIN_CruiseControlSpeedGainFactor_FromSpeed    ; load index with value
           ldd   VehicleSpeed_HB    ; load D (A&B) with memory contents
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           jsr   Lookup4ByteTable    ; call subroutine
           adda  Temp3     
           bcc   LE754         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   LE754:  staa  Temp3         ; store A into memory
           clra                ; A = 0
           staa  Temp2         ; store A into memory
           ldab  CruiseControlVar1    ; load B with memory contents
           bpl   LE75E         ; branch if plus (hi bit 0)
           deca                ; decrement A
   LE75E:  asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           addd  Temp0         ; D = D + memory contents
           std   Temp0         ; store D (A&B) into memory
           brset *CruiseStatus_2, #$%00000100, LE790    ; branch if bit(s) set
           bpl   LE76F         ; branch if plus (hi bit 0)
           coma                ; 1's complement A
           comb                ; 1's complement B
           addd  #0x0001        ;  -00000000 00000001-
   LE76F:  tsta                ; test A
           beq   LE774         ; branch if equal (zero)
           ldab  #0xff         ; load B with value -11111111-
   LE774:  cmpb  CRUZ24_UnknownConstForCruiseControl24    ; compare B with memory contents (data is 00)
           bhi   LE790         ; branch if higher
           clrb                ; b = 0
           ldaa  CruiseSpeedSetpoint    ; load A with memory contents
           lsrd                ; shift right (D=D/2)
           lsrd                ; shift right (D=D/2)
           lsrd                ; shift right (D=D/2)
           subd  VehicleSpeed_HB    ; D = D - memory contents
           bpl   LE788         ; branch if plus (hi bit 0)
           coma                ; 1's complement A
           comb                ; 1's complement B
           addd  #0x0001        ;  -00000000 00000001-
   LE788:  tsta                ; test A
           bne   LE790         ; branch if not equal (not zero)
           cmpb  CRUZ25_UnknownConstForCruiseControl25    ; compare B with memory contents (data is 30)
           bls   LE7AD         ; branch if lower or same
   LE790:  clra                ; A = 0
           ldab  CruiseControlVar2    ; load B with memory contents
           bpl   LE796         ; branch if plus (hi bit 0)
           deca                ; decrement A
   LE796:  addd  Temp0         ; D = D + memory contents
           staa  Temp4         ; store A into memory
           bpl   LE7A1         ; branch if plus (hi bit 0)
           coma                ; 1's complement A
           comb                ; 1's complement B
           addd  #0x0001        ;  -00000000 00000001-
   LE7A1:  cpd  Temp2         ; D = D - memory contents
           bcc   LE7B0         ; branch if greater or equal
           ldaa  Temp4         ; load A with memory contents
           bpl   LE7AB         ; branch if plus (hi bit 0)
           negb                ; 2's complement B
   LE7AB:  stab  CruiseControlVar2    ; store B into memory
   LE7AD:  jmp   LE84A     

   LE7B0:  clra                ; A = 0
           staa  CruiseControlVar2    ; store A into memory
           ldaa  Temp4         ; load A with memory contents
           anda  #0x80         ; AND a with value -10000000-
           ldab  CruiseControlVar3    ; load B with memory contents
           beq   LE7C2         ; branch if equal (zero)
           bpl   LE7AD         ; branch if plus (hi bit 0)
           tab                 ; B = A
           eorb  CruiseControlVar3
           bpl   LE7AD         ; branch if plus (hi bit 0)
   LE7C2:  ldab  TPSVolts      ; load B with memory contents
           subb  MINTHR_LowestSessionTPS    ; B = B-memory contents
           bcc   LE7C9         ; branch if greater or equal
           clrb                ; b = 0
   LE7C9:  tsta                ; test A
           bpl   LE7F3         ; branch if plus (hi bit 0)
           oraa  CRUZ28_UnknownConstForCruiseControl28    ;  (data is 01)
           brclr *CruiseStatus_1, #$%00010000, LE7D8    ; branch if bit(s) clear
           adda  CRUZ30_UnknownConstForCruiseControl30    ;  (data is 01)
           bra   LE81A         ; branch

   LE7D8:  staa  Temp4         ; store A into memory
           clra                ; A = 0
           cmpb  CLOTHR_CruiseControlDontVentIfThrottleBelowThis    ; compare B with memory contents (data is 01)
           bcs   LE81A         ; branch if lower
           ldx   #CRUZ4_UnknownTableForCruiseControl4    ; load index with value
           stx   Temp2         ; store index into memory
           ldx   #CRUZ5_UnknownTableForCruiseControl5    ; load index with value
           bsr   LE81E         ; call subroutine
           oraa  #0x80         ;  -10000000-
           ldab  Temp4         ; load B with memory contents
           cba                 ; compare A to B
           bcc   LE81A         ; branch if greater or equal
           bra   LE819         ; branch

   LE7F3:  cmpb  MAXTHR_CruiseControlDontVacIfThrottleAboveThis    ; compare B with memory contents (data is 66)
           bcc   LE81A         ; branch if greater or equal
           oraa  CRUZ27_UnknownConstForCruiseControl27    ;  (data is 01)
           brclr *CruiseStatus_1, #$%00001000, LE804    ; branch if bit(s) clear
           adda  CRUZ29_UnknownConstForCruiseControl29    ;  (data is 01)
           bra   LE81A         ; branch

   LE804:  brset *CruiseStatus_1, #$%00000100, LE81A    ; branch if bit(s) set
           staa  Temp4         ; store A into memory
           ldx   #CRUZ2_UnknownTableForCruiseControl2    ; load index with value
           stx   Temp2         ; store index into memory
           ldx   #CRUZ3_UnknownTableForCruiseControl3    ; load index with value
           bsr   LE81E         ; call subroutine
           ldab  Temp4         ; load B with memory contents
           cba                 ; compare A to B
           bcc   LE81A         ; branch if greater or equal
   LE819:  tba                 ; A = B
   LE81A:  staa  CruiseControlVar3    ; store A into memory
           bra   LE84A         ; branch

   LE81E:  clrb                ; b = 0
           ldaa  CruiseSpeedSetpoint    ; load A with memory contents
           lsrd                ; shift right (D=D/2)
           lsrd                ; shift right (D=D/2)
           lsrd                ; shift right (D=D/2)
           subd  VehicleSpeed_HB    ; D = D - memory contents
           asra                ; arithmetic shift right A
           rorb                ; rotate right B
           asra                ; arithmetic shift right A
           rorb                ; rotate right B
           asra                ; arithmetic shift right A
           rorb                ; rotate right B
           jsr   LE6AB         ; call subroutine
           tba                 ; A = B
           adda  #0x80         ;  -10000000-
           jsr   Lookup4ByteTable    ; call subroutine
           ldx   Temp2     
           staa  Temp2         ; store A into memory
           ldd   Temp0         ; load D (A&B) with memory contents
           jsr   LE6AB         ; call subroutine
           tba                 ; A = B
           adda  #0x80         ;  -10000000-
           jsr   Lookup4ByteTable    ; call subroutine
           ldab  Temp2         ; load B with memory contents
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           rts                 ; return from subroutine

   LE84A:  sei                 ; disable interrupts
           ldaa  PIA2_Buffer    ; load A with memory contents
           anda  #0x3f         ; AND a with value -00111111-
           brset *CruiseStatus_1, #$%10000000, LE864    ; branch if bit(s) set
           ldab  CruiseControlVar3    ; load B with memory contents
           beq   LE866         ; branch if equal (zero)
           bpl   LE868         ; branch if plus (hi bit 0)
           brclr *CruiseStatus_1, #$%00010000, LE864    ; branch if bit(s) clear
           ldab  Counter_Cruise_3    ; load B with memory contents
           incb                ; increment B
           beq   LE864         ; branch if equal (zero)
           stab  Counter_Cruise_3    ; store B into memory
   LE864:  oraa  #0xc0         ;  -11000000-
   LE866:  oraa  #0x80         ;  -10000000-
   LE868:  staa  PIA2_Buffer    ; store A into memory
           cli                 ; enable interrupts
           ldab  CruiseControlVar3    ; load B with memory contents
           beq   LE87B         ; branch if equal (zero)
           asld                ; shift left (D=D*2)
           tstb                ; test B
           beq   LE878         ; branch if equal (zero)
           subb  #0x02         ;  -00000010-
           beq   LE878         ; branch if equal (zero)
           lsrd                ; shift right (D=D/2)
   LE878:  stab  CruiseControlVar3    ; store B into memory
           rts                 ; return from subroutine

   LE87B:  brclr *CruiseStatus_2, #$%00000001, LE882    ; branch if bit(s) clear
           bset  *CruiseStatus_2, #$%00000010    ; set bits
   LE882:  rts                 ; return from subroutine

   LE883:  ldaa  CruiseSpeedSetpoint    ; load A with memory contents
           ldx   #SETPW_CruiseControlSetupPulseForSet_FromSpeed    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           bpl   LE88F         ; branch if plus (hi bit 0)
           ldab  #0x7f         ; load B with value -01111111-
   LE88F:  stab  Temp1         ; store B into memory
           ldaa  MapValue      ; load A with memory contents
           suba  BaroPressure
           bcc   LE89A         ; branch if greater or equal
           tab                 ; B = A
           eorb  #0x80         ;  -10000000-
   LE89A:  bpl   LE8A1         ; branch if plus (hi bit 0)
           lsla                ; logical shift left A
           ldaa  #0x80         ; load a with value -10000000-
           sbca  #0x00         ;  -00000000-
   LE8A1:  adda  #0x80         ;  -10000000-
           ldx   #RESTBL_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           ldab  Temp1         ; load B with memory contents
           lslb                ; arithmetic shift left B
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           bpl   LE8B3         ; branch if plus (hi bit 0)
           ldaa  #0x7f         ; load a with value -01111111-
   LE8B3:  ldx   #L002D        ; load index with value
           ldab  CruiseSpeedSetpoint    ; load B with memory contents
           cmpb  CRUZ36_UnknownConstForCruiseControl36    ; compare B with memory contents (data is 8c)
           bls   LE8BE         ; branch if lower or same
           inX                 ; increment index (I=I+1)
   LE8BE:  adda  0x00, X      ;  -00000000-
           bpl   LE8C5         ; branch if plus (hi bit 0)
           bvs   LE8C6         ; branch if no overflow
           clra                ; A = 0
   LE8C5:  rts                 ; return from subroutine

   LE8C6:  ldaa  #0x7f         ; load a with value -01111111-
           rts                 ; return from subroutine

IncrementLoopCounters_MM:
           inc   Counter_MainLoop
           bne   LE8E5         ; branch if not equal (not zero)
           ldaa  #0xff         ; load a with value -11111111-
           cmpa  KeyOnOrEngineRunningTime    ; compare A with memory contents
           beq   LE8D7         ; branch if equal (zero)
           inc   KeyOnOrEngineRunningTime
   LE8D7:  brset *BitFlags6F, #b6f_FuelEngineNotRunning, LE8E5    ; branch if bit(s) set
           bclr  *BitFlags_AIS, #$%00000011    ; clear bits
           cmpa  EngineRunningTimeMaxFF    ; compare A with memory contents
           beq   LE8E5         ; branch if equal (zero)
           inc   EngineRunningTimeMaxFF
   LE8E5:  ldaa  TimerOverflowsBetweenDistPulses    ; load A with memory contents
           cmpa  #0x02         ; compare a with value -00000010-
           bcs   LE8F8         ; branch if lower
           bset  *BitFlags6F, #b6f_FuelEngineNotRunning | b6f_Starting | b6f_DisableNormalDwell
           bclr  *BitFlags66, #b66_OpenLoop | b66_O2Valid    ; clear bits
           bclr  *BitFlags67, #b67_bit1    ; clear bits
           ldaa  EngineRunningTimeMaxFF    ; load A with memory contents
           staa  EngineRunningTimeBeforeStall    ; store A into memory
   LE8F8:  ldaa  Timer_AisChanges    ; load A with memory contents
           inca                ; increment A
           beq   LE8FF         ; branch if equal (zero)
           staa  Timer_AisChanges    ; store A into memory
   LE8FF:  rts                 ; return from subroutine

DRB_SomethingLikeEMR_MM:
           brset *BitFlags6C, #$%00000001, LE92E    ; branch if bit(s) set
           brclr *BitFlags6C, #$%00000010, LE92E    ; branch if bit(s) clear
           brset *BitFlags6F, #b6f_FuelEngineNotRunning, LE92E    ; branch if bit(s) set
           sei                 ; disable interrupts
           ldaa  BitFlags70    ; load A with memory contents
           bita  #0x03         ;  -00000011-
           bne   LE92C         ; branch if not equal (not zero)
           bset  *BitFlags6C, #$%00000001    ; set bits
           ldaa  LB613         ; load A with memory contents (data is ff)
           inca                ; increment A
           beq   LE92C         ; branch if equal (zero)
           cmpa  #0x07         ; compare a with value -00000111-
           bcs   LE923         ; branch if lower
           bset  *BitFlags6C, #$%00001000    ; set bits
   LE923:  staa  DRBOffsetStored_LB    ; store A into memory
           ldaa  #0x13         ; load a with value -00010011-
           staa  DRBOffsetStored_HB    ; store A into memory
           bset  *BitFlags70, #$%00000001    ; set bits
   LE92C:  cli                 ; enable interrupts
           nop                 ; no operation
   LE92E:  sei                 ; disable interrupts
           brset *BitFlags70, #$%00000001, LE995    ; branch if bit(s) set
           ldd   LB6DE         ;  (data is ffff)
           comb                ; 1's complement B
           cba                 ; compare A to B
           beq   LE93D         ; branch if equal (zero)
           ldaa  ValueCopiedTo0036    ; load A with memory contents (data is 00)
   LE93D:  staa  PointlessFuelFactor    ; store A into memory
           ldaa  LB7E1         ; load A with memory contents (data is ff)
           coma                ; 1's complement A
           cmpa  LB7E0         ; compare A with memory contents (data is ff)
           beq   LE94A         ; branch if equal (zero)
           ldaa  #0x08         ; load a with value -00001000-
   LE94A:  staa  CCDBatteryVoltsOutput    ; store A into memory
           brclr *BitFlags6C, #$%00000100, LE980    ; branch if bit(s) clear
           ldaa  #0x16         ; load a with value -00010110-
           ldab  #0x4a         ; load B with value -01001010-
           brclr *BitFlags70, #$%00000010, LE979    ; branch if bit(s) clear
           cmpa  DRBOffsetStored_HB    ; compare A with memory contents
           beq   LE972         ; branch if equal (zero)
           inca                ; increment A
           cmpa  DRBOffsetStored_HB    ; compare A with memory contents
           bne   LE980         ; branch if not equal (not zero)
           bset  *BitFlags70, #$%00000001    ; set bits
           bclr  *BitFlags70, #$%00000010    ; clear bits
           bclr  *BitFlags6C, #$%00000100    ; clear bits
           ldaa  #0x13         ; load a with value -00010011-
           clrb                ; b = 0
           stab  Counter_ACControl1    ; store B into memory
           bra   LE97C         ; branch

   LE972:  bset  *BitFlags70, #$%00000001    ; set bits
           inca                ; increment A
           comb                ; 1's complement B
           bra   LE97C         ; branch

   LE979:  bset  *BitFlags70, #$%00000011    ; set bits
   LE97C:  staa  DRBOffsetStored_HB    ; store A into memory
           stab  DRBOffsetStored_LB    ; store B into memory
   LE980:  ldaa  LB617         ; load A with memory contents (data is ff)
           coma                ; 1's complement A
           cmpa  LB616         ; compare A with memory contents (data is ff)
           bne   LE992         ; branch if not equal (not zero)
           cmpa  #0x4a         ; compare a with value -01001010-
           bne   LE992         ; branch if not equal (not zero)
           bset  *BitFlags6C, #$%00000010    ; set bits
           bra   LE995         ; branch

   LE992:  bclr  *BitFlags6C, #$%00000010    ; clear bits
   LE995:  cli                 ; enable interrupts
           brclr *BitFlags6C, #$%00001000, LE9BF    ; branch if bit(s) clear
           sei                 ; disable interrupts
           brset *BitFlags70, #$%00000001, LE9BE    ; branch if bit(s) set
           ldaa  #0x16         ; load a with value -00010110-
           ldab  #0xee         ; load B with value -11101110-
           brclr *BitFlags70, #$%00000010, LE9B7    ; branch if bit(s) clear
           cmpa  DRBOffsetStored_HB    ; compare A with memory contents
           bne   LE9BE         ; branch if not equal (not zero)
           inca                ; increment A
           bset  *BitFlags70, #$%00000001    ; set bits
           bclr  *BitFlags70, #$%00000010    ; clear bits
           bclr  *BitFlags6C, #$%00001000    ; clear bits
           bra   LE9BA         ; branch

   LE9B7:  bset  *BitFlags70, #$%00000011    ; set bits
   LE9BA:  staa  DRBOffsetStored_HB    ; store A into memory
           stab  DRBOffsetStored_LB    ; store B into memory
   LE9BE:  cli                 ; enable interrupts
   LE9BF:  rts                 ; return from subroutine

ResetAverageValues_MM:
           bclr  *BitFlags6D, #$%00000010    ; clear bits
           sei                 ; disable interrupts
           ldaa  TimerOverflowsBetweenDistPulses    ; load A with memory contents
           bne   CALCULATE_RPM_SPEED_AND    ; branch if not equal (not zero)
           brclr *BitFlags6D, #$%00000001, LEA00    ; branch if bit(s) clear
           bclr  *BitFlags6D, #$%00000001    ; clear bits
           bset  *BitFlags6D, #$%00000010    ; set bits
           ldd   EngineRpm_HB    ; load D (A&B) with memory contents
           std   EngineRPMTemp
           ldd   DistributorFallingEdgePulsewidth_HB    ; load D (A&B) with memory contents
           std   DistPWTemp
           ldaa  MapValue      ; load A with memory contents
           cmpa  MapAverageValue_HB    ; compare A with memory contents
           bcc   LE9FC         ; branch if greater or equal
           bsr   CalculateEngineRpm    ; call subroutine
           std   EngineRpm_HB    ; store D (A&B) into memory
           subd  EngineRPMTemp
           bcs   LEA00         ; branch if lower
           cmpa  DLRPRM_MinDeltaRPMToResetAvgMAP    ; compare A with memory contents (data is ff)
           bcs   LEA00         ; branch if lower
           ldaa  MapValue      ; load A with memory contents
           staa  MapAverageValue_HB    ; store A into memory
           bra   LEA00         ; branch

CALCULATE_RPM_SPEED_AND:
           ldd   #0xFFFF        ; load D (A&B) with value -11111111 11111111-
           std   DistPWTemp
   LE9FC:  bsr   CalculateEngineRpm    ; call subroutine
           std   EngineRpm_HB    ; store D (A&B) into memory
   LEA00:  cli                 ; enable interrupts
           rts                 ; return from subroutine

CalculateEngineRpm:
           ldy   #DistributorFallingEdgePulsewidth_HB    ; load index with value
           ldd   #0x0727       ; load D (A&B) with value -00000111 00100111-
           ldx   #0x0e00       ; load index with value
           tst   TimerOverflowsBetweenDistPulses
           beq   CalculateVehicleSpeedOrEngineRpms    ; branch if equal (zero)
           deY                 ; decrement index (I=I-1)
           ldd   #DCCOR1_AdaptiveWastegateCellBelow3psi    ; load D (A&B) with value -00000000 00000111-
           ldx   #0x270e       ; load index with value
CalculateVehicleSpeedOrEngineRpms:
           pshx                ; pull index from stack
           ldx   0x00, Y      ;  -00000000-
           fdiv                ; fractional divide ACCD by IX
           stx   Temp0         ; store index into memory
           pula                ; pull A from stack
           pulb                ; pull B from stack
           ldx   0x00, Y      ;  -00000000-
           idiv                ; integer divide ACCD by IX
           xgdx                ; exchange D and index
           addd  Temp0         ; D = D + memory contents
           bcc   LEA2E         ; branch if greater or equal
           ldd   #0xFFFF        ; load D (A&B) with value -11111111 11111111-
   LEA2E:  rts                 ; return from subroutine

Lookup4ByteTable:
           ldy   #0x0000        ; load index with value
           ldab  0x00, X      ; load B with memory at index + value -00000000-
           aby                 ; add B to index
           inX                 ; increment index (I=I+1)
           ldab  #0x04         ; load B with value -00000100-
           cmpa  0x00, X      ; compare A with memory at index + value -00000000-
           bhi   LEA42         ; branch if higher
   LEA3E:  clrb                ; b = 0
           bra   LEA5D         ; branch

   LEA41:  abx                 ; add B to index
   LEA42:  deY                 ; decrement index (I=I-1)
           beq   LEA3E         ; branch if equal (zero)
           cmpa  0x04, X      ; compare A with memory at index + value -00000100-
           bcc   LEA41         ; branch if greater or equal
           suba  0x00, X      ;  -00000000-
           psha                ; push A onto stack
           ldab  0x02, X      ; load B with memory at index + value -00000010-
           mul                 ; multiply (D=A*B)
           xgdy                ; exchange D and index
           pula                ; pull A from stack
           ldab  0x03, X      ; load B with memory at index + value -00000011-
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           tab                 ; B = A
           aby                 ; add B to index
           xgdy                ; exchange D and index
   LEA5D:  addb  0x01, X      ; add memory at index + value to B -00000001-
           tba                 ; A = B
           rts                 ; return from subroutine

ScaleYbyA:
           psha                ; push A onto stack
           pshy                ; pull index from stack
           pulb                ; pull B from stack
           mul                 ; multiply (D=A*B)
           xgdy                ; exchange D and index
           pulb                ; pull B from stack
           pula                ; pull A from stack
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           tab                 ; B = A
           aby                 ; add B to index
           rts                 ; return from subroutine

ScaleXbyB_addingA_intoD:
           psha                ; push A onto stack
           tba                 ; A = B
           ldy   0x00, X      ;  -00000000-
           bsr   ScaleYbyA     ; call subroutine
           pula                ; pull A from stack
           tsta                ; test A
           xgdy                ; exchange D and index
           beq   LEA85         ; branch if equal (zero)
           addd  0x00, X      ;  -00000000-
           bcc   LEA85         ; branch if greater or equal
           ldd   #0xFFFF        ; load D (A&B) with value -11111111 11111111-
   LEA85:  rts                 ; return from subroutine

ProcessMapOrTpsBlockData:
           ldaa  0x03, X      ; load A with memory at index + value -00000011-
           bne   LEA8F         ; branch if not equal (not zero)
           clrb                ; b = 0
           ldaa  0x02, X      ; load A with memory at index + value -00000010-
           bra   LEAA2         ; branch

   LEA8F:  ldy   0x00, X      ;  -00000000-
           bsr   ScaleYbyA     ; call subroutine
           pshy                ; pull index from stack
           ldd   0x02, X      ;  -00000010-
           mul                 ; multiply (D=A*B)
           tsy                 ; transfer stack to index (I=sp+1)
           subd  0x00, Y      ;  -00000000-
           puly                ; pull index from stack
           addd  0x00, X      ;  -00000000-
   LEAA2:  std   0x00, X      ; store D into index plus offset -00000000-
           rts                 ; return from subroutine

DetermineNumberOfOverflowsBetweenCamSensorPulses_MM:
           subd  LastDistributorFallingEdgeTime    ; D = D - memory contents
           staa  Temp5         ; store A into memory
           ldaa  Counter_TimerPastHalfwayBetweenCamPulses    ; load A with memory contents
           lsrd                ; shift right (D=D/2)
           eorb  Temp5     
           bpl   LEAB7         ; branch if plus (hi bit 0)
           ldaa  Counter_TimerPastHalfwayBetweenCamPulses    ; load A with memory contents
           inca                ; increment A
           beq   LEAB7         ; branch if equal (zero)
           staa  Counter_TimerPastHalfwayBetweenCamPulses    ; store A into memory
   LEAB7:  ldaa  Counter_TimerPastHalfwayBetweenCamPulses    ; load A with memory contents
           lsra                ; logic shift right A
           cmpa  TimerOverflowsBetweenDistPulses    ; compare A with memory contents
           bcs   LEAC0         ; branch if lower
           staa  TimerOverflowsBetweenDistPulses    ; store A into memory
   LEAC0:  rts                 ; return from subroutine

GetControlFeedback_DetermineIfShutdownRequired_MM:
           ldab  SwitchPortAccessReg1    ; load B with memory contents
           bitb  #0x40         ;  -01000000-
           bne   LEACD         ; branch if not equal (not zero)
   LEAC8:  cli                 ; enable interrupts
           clra                ; A = 0
           staa  CountdownTimerFromKeyOn    ; store A into memory
           rts                 ; return from subroutine

   LEACD:  ldaa  CountdownTimerFromKeyOn    ; load A with memory contents
           bne   LEADB         ; branch if not equal (not zero)
           ldaa  #0x17         ; load a with value -00010111-
           ldab  TimerOverflowsBetweenDistPulses    ; load B with memory contents
           cmpb  #0x04         ;  -00000100-
           bcs   LEADB         ; branch if lower
           ldaa  #0x09         ; load a with value -00001001-
   LEADB:  deca                ; decrement A
           beq   LEAE1         ; branch if equal (zero)
           staa  CountdownTimerFromKeyOn    ; store A into memory
           rts                 ; return from subroutine

   LEAE1:  sei                 ; disable interrupts
           jsr   ResetCopTimer    ; call subroutine
           jsr   CaculateChecksum    ; call subroutine
           sei                 ; disable interrupts
           jsr   ResetCopTimer    ; call subroutine
           jsr   CountRamValuesFrom05to38    ; call subroutine
           std   L0003         ; store D (A&B) into memory
           ldaa  #0x20         ; load a with value -00100000-
   LEAF3:  ldab  SwitchPortAccessReg1    ; load B with memory contents
           bitb  #0x40         ;  -01000000-
           beq   LEAC8         ; branch if equal (zero)
           deca                ; decrement A
           bne   LEAF3         ; branch if not equal (not zero)
           jsr   ResetCopTimer    ; call subroutine
           ldaa  #0x10         ; load a with value -00010000-
           tap                 ; transfer A to P
           ldd   #MINTHR_LowestSessionTPS    ; load D (A&B) with value -00000000 00000101-
           stab  PIA_Ctrl_1    ; store B into memory
           staa  SwitchPortAccessReg1
           ldab  #0xff         ; load B with value -11111111-
           stab  PortX_Control    ; store B into memory
           staa  PIA_Ctrl_5
           staa  SwitchPortAccessReg2
           staa  CPU_SerialControlReg2
           ldd   #0x3800       ; load D (A&B) with value -00111000 00000000-
           std   CPU_OutputCompare1Mask
           ldaa  #0x80         ; load a with value -10000000-
           staa  CPU_HardwareTimerForceCompare
           stab  CPU_OutputCompare1Mask    ; store B into memory
   LEB28:  ldab  SwitchPortAccessReg1    ; load B with memory contents
           bitb  #0x40         ;  -01000000-
           beq   LEB3E         ; branch if equal (zero)
           ldd   #0x55aa       ; load D (A&B) with value -01010101 10101010-
           staa  CPU_ArmResetCopTimerReg
           stab  CPU_ArmResetCopTimerReg    ; store B into memory
           jmp   LEB28     

   LEB3B:  jmp   LEB28     

   LEB3E:  ldaa  #0x40         ; load a with value -01000000-
   LEB40:  ldab  SwitchPortAccessReg1    ; load B with memory contents
           bitb  #0x40         ;  -01000000-
           bne   LEB28         ; branch if not equal (not zero)
           deca                ; decrement A
           bne   LEB40         ; branch if not equal (not zero)
           jmp   ResetInterrupt     

ResetCopTimer:
           ldaa  SwitchPortAccessReg1    ; load A with memory contents
           anda  #0xfd         ; AND a with value -11111101-
           staa  SwitchPortAccessReg1
           ldab  #0x10         ; load B with value -00010000-
   LEB57:  decb                ; decrement B
           bne   LEB57         ; branch if not equal (not zero)
           oraa  #0x02         ;  -00000010-
           staa  SwitchPortAccessReg1
           ldd   #0x55aa       ; load D (A&B) with value -01010101 10101010-
           staa  CPU_ArmResetCopTimerReg
           stab  CPU_ArmResetCopTimerReg    ; store B into memory
           rts                 ; return from subroutine

Lookup5ByteTable:
           ldab  #0x05         ; load B with value -00000101-
           cmpa  0x00, X      ; compare A with memory at index + value -00000000-
           bhi   LEB74         ; branch if higher
           ldd   0x01, X      ;  -00000001-
           bra   LEB84         ; branch

   LEB73:  abx                 ; add B to index
   LEB74:  cmpa  0x05, X      ; compare A with memory at index + value -00000101-
           bhi   LEB73         ; branch if higher
           suba  0x00, X      ;  -00000000-
           ldy   0x03, X      ;  -00000011-
           jsr   ScaleYbyA     ; call subroutine
           xgdy                ; exchange D and index
           addd  0x01, X      ;  -00000001-
   LEB84:  rts                 ; return from subroutine

ScaleYbyD_resultD:
           psha                ; push A onto stack
           pshy                ; pull index from stack
           tba                 ; A = B
           jsr   ScaleYbyA     ; call subroutine
           pshy                ; pull index from stack
           tsx                 ; transfer stack to index (I=sp+1)
           ldaa  0x04, X      ; load A with memory at index + value -00000100-
           ldab  0x03, X      ; load B with memory at index + value -00000011-
           mul                 ; multiply (D=A*B)
           addd  0x00, X      ;  -00000000-
           bcs   LEBAB         ; branch if lower
           std   0x00, X      ; store D into index plus offset -00000000-
           ldaa  0x04, X      ; load A with memory at index + value -00000100-
           ldab  0x02, X      ; load B with memory at index + value -00000010-
           mul                 ; multiply (D=A*B)
           tsta                ; test A
           bne   LEBAB         ; branch if not equal (not zero)
           addb  0x00, X      ; add memory at index + value to B -00000000-
           bcs   LEBAB         ; branch if lower
           tba                 ; A = B
           ldab  0x01, X      ; load B with memory at index + value -00000001-
           bra   LEBAE         ; branch

   LEBAB:  ldd   #0xFFFF        ; load D (A&B) with value -11111111 11111111-
   LEBAE:  pulx                ; pull index from stack
           pulx                ; pull index from stack
           ins                 ; increment stack pointer
           rts                 ; return from subroutine

FilterTPSbyB:
           pshb                ; push B onto stack
           clrb                ; b = 0
           subd  0x00, X      ;  -00000000-
           bcc   LEBCE         ; branch if greater or equal
           coma                ; 1's complement A
           comb                ; 1's complement B
           addd  #0x0001        ;  -00000000 00000001-
           xgdy                ; exchange D and index
           pula                ; pull A from stack
           jsr   ScaleYbyA     ; call subroutine
           xgdy                ; exchange D and index
           coma                ; 1's complement A
           comb                ; 1's complement B
           addd  #0x0001        ;  -00000000 00000001-
           addd  0x00, X      ;  -00000000-
           bra   LEBDD         ; branch

   LEBCE:  xgdy                ; exchange D and index
           pula                ; pull A from stack
           jsr   ScaleYbyA     ; call subroutine
           xgdy                ; exchange D and index
           addd  0x00, X      ;  -00000000-
           bcc   LEBDD         ; branch if greater or equal
           ldd   #0xFFFF        ; load D (A&B) with value -11111111 11111111-
   LEBDD:  std   0x00, X      ; store D into index plus offset -00000000-
           rts                 ; return from subroutine

ControlBOV_MM:
           ldaa  Counter_MainLoop    ; load A with memory contents
           bita  BOVMLP_MinimumMainLoopCountForBOV    ;  (data is 00)
           bne   LEC45         ; branch if not equal (not zero)
           ldaa  MapValue      ; load A with memory contents
           cmpa  MapValueRaw    ; compare A with memory contents
           bcs   LEBF1         ; branch if lower
           staa  MapValueRaw    ; store A into memory
           bra   LEC06         ; branch

   LEBF1:  ldx   #Temp0        ; load index with value
           ldab  BOVTCT_MAPAverageTimeConstantForBOV    ; load B with memory contents (data is 02)
           std   Temp2         ; store D (A&B) into memory
           ldd   MapValueRaw    ; load D (A&B) with memory contents
           std   Temp0         ; store D (A&B) into memory
           sei                 ; disable interrupts
           jsr   ProcessMapOrTpsBlockData    ; call subroutine
           cli                 ; enable interrupts
           ldd   Temp0         ; load D (A&B) with memory contents
           std   MapValueRaw    ; store D (A&B) into memory
   LEC06:  brset *BitFlags66, #b66_OffIdle, LEC16    ; branch if bit(s) set
           ldab  BaroPressure    ; load B with memory contents
           subb  BOVMNB_MinBaroForBOV    ; subtract memory contents from B (data is 1a)
           bcc   LEC12         ; branch if greater or equal
           clrb                ; b = 0
   LEC12:  cmpb  MapValueRaw
           bcs   BOV_SetBOVtoClose    ; branch if lower
   LEC16:  ldab  BaroPressure    ; load B with memory contents
           subb  BOVMB2_MinBaroForBOV    ; subtract memory contents from B (data is 00)
           bcc   LEC1E         ; branch if greater or equal
           clrb                ; b = 0
   LEC1E:  cmpb  MapValue  
           bcc   LEC29         ; branch if greater or equal
BOV_SetBOVtoOpen:
           bset  *PIA2_Buffer, #$%00000010    ; set bits
           bclr  *BitFlags37, #bf37_BOV    ; clear bits
           rts                 ; return from subroutine

   LEC29:  ldab  MapValue      ; load B with memory contents
           addb  BOVMNM_MinMAPForBOV    ;  (data is 1a)
           bcc   LEC32         ; branch if greater or equal
           ldab  #0xff         ; load B with value -11111111-
   LEC32:  brclr *BitFlags37, #bf37_BOV, LEC3C    ; branch if bit(s) clear
           subb  BOVMPO_MAPOffsetForBOV    ; subtract memory contents from B (data is 04)
           bcc   LEC3C         ; branch if greater or equal
           clrb                ; b = 0
   LEC3C:  cba                 ; compare A to B
           bcs   BOV_SetBOVtoOpen    ; branch if lower
BOV_SetBOVtoClose:
           bclr  *PIA2_Buffer, #$%00000010    ; clear bits
           bset  *BitFlags37, #bf37_BOV    ; set bits
   LEC45:  rts                 ; return from subroutine

LookupAndKeepSmallerBoostGoal:
           jsr   Lookup4ByteTable    ; call subroutine
           cmpa  Temp4         ; compare A with memory contents
           bcc   LEC4F         ; branch if greater or equal
           staa  Temp4         ; store A into memory
   LEC4F:  rts                 ; return from subroutine

CalcTargetBoost_MM:
           ldaa  ATMOffset     ; load A with memory contents
           cmpa  #0x11         ; compare a with value -00010001-
           beq   LEC62         ; branch if equal (zero)
           cmpa  #0x1b         ; compare a with value -00011011-
           beq   LEC62         ; branch if equal (zero)
           cmpa  #0x20         ; compare a with value -00100000-
           beq   LEC62         ; branch if equal (zero)
           cmpa  #0x14         ; compare a with value -00010100-
           bne   LEC63         ; branch if not equal (not zero)
   LEC62:  rts                 ; return from subroutine

   LEC63:  brclr *BitFlags6F, #b6f_FuelEngineNotRunning, LEC6A    ; branch if bit(s) clear
           jmp   BoostControlRoutine_T1

   LEC6A:  ldaa  CoolantTemp    ; load A with memory contents
           cmpa  ARMINT_AdaptiveRetardMinimumTemp    ; compare A with memory contents (data is 58)
           bls   LECA8         ; branch if lower or same
           ldaa  MapValue      ; load A with memory contents
           cmpa  ARMPIC_AdaptiveRetard_MinMAPForAdjustment    ; compare A with memory contents (data is 66)
           bcs   LECA8         ; branch if lower
           ldaa  KnockRetardSum_AllCyls    ; load A with memory contents
           beq   LECA8         ; branch if equal (zero)
           ldaa  Counter_MainLoop    ; load A with memory contents
           bita  ARCMSK_AdaptiveRetardCounterMask    ;  (data is 00)
           bne   BoostControlRoutine_T1    ; branch if not equal (not zero)
           ldaa  Timer_Over5PsiBoostMaxFF    ; load A with memory contents
           inca                ; increment A
           cmpa  ARTM5P_AdaptiveRetardTimeOver5psiBoost    ; compare A with memory contents (data is 00)
           bcs   LECB7         ; branch if lower
           ldab  KnockRetardSum_AllCyls    ; load B with memory contents
           cmpb  TOTKRT_TotalKnockRetardRef    ; compare B with memory contents (data is 0e)
           bls   LECB7         ; branch if lower or same
           clra                ; A = 0
           sei                 ; disable interrupts
           brset *b5D_IPL2, #$%00000010, LECA1    ; branch if bit(s) set
           ldab  AdaptiveRetardIndex    ; load B with memory contents
           addb  ARINDX_AdaptiveRetardIndexBase_80    ;  (data is ff)
           bcc   LECA3         ; branch if greater or equal
   LECA1:  ldab  #0xff         ; load B with value -11111111-
   LECA3:  stab  AdaptiveRetardIndex    ; store B into memory
           cli                 ; enable interrupts
           bra   LECB7         ; branch

   LECA8:  ldaa  Counter_MainLoop    ; load A with memory contents
           bita  ARCMS2_AdaptiveRetardCounterMask2_00    ;  (data is 00)
           bne   BoostControlRoutine_T1    ; branch if not equal (not zero)
           ldaa  Timer_Over5PsiBoostMaxFF    ; load A with memory contents
           suba  ARCMS3_AdaptiveRetardCounterMask3_FF    ;  (data is ff)
           bcc   LECB7         ; branch if greater or equal
           clra                ; A = 0
   LECB7:  staa  Timer_Over5PsiBoostMaxFF    ; store A into memory
BoostControlRoutine_T1:
           ldaa  MapValue      ; load A with memory contents
           staa  Temp2         ; store A into memory
           tab                 ; B = A
           suba  BaroPressure
           bcc   LECC3         ; branch if greater or equal
           clra                ; A = 0
   LECC3:  staa  Temp1         ; store A into memory
           ldaa  DeltaBoostSampleCounter    ; load A with memory contents
           cmpa  DLTBSC_DeltaBoostSampleCounterMax    ; compare A with memory contents (data is 01)
           bcc   BC_CalculateSignedDeltaBoost    ; branch if greater or equal
           inca                ; increment A
           bra   BC_StoreDeltaBoostSampleCounter    ; branch

BC_CalculateSignedDeltaBoost:
           tba                 ; A = B
           subb  PreviousBoostOverBaro    ; B = B-memory contents
           staa  PreviousBoostOverBaro    ; store A into memory
           bcc   LECDF         ; branch if greater or equal
           cmpb  #0x80         ; 0x55 for 3-bar
           bcc   BC_SaveSignedDeltaBoost    ; branch if greater or equal
           ldab  #0x80         ; 0x55 for 3-bar
           bra   BC_SaveSignedDeltaBoost    ; branch

   LECDF:  cmpb  #0x7f         ; 0x54 for 3-bar
           bls   BC_SaveSignedDeltaBoost    ; branch if lower or same
           ldab  #0x7f         ; 0x54 for 3-bar
BC_SaveSignedDeltaBoost:
           stab  BoostDelta_Signed    ; store B into memory
           clra                ; A = 0
BC_StoreDeltaBoostSampleCounter:
           staa  DeltaBoostSampleCounter
           brclr *BitFlags67, #b67_FallToIdle, BC_FallToIdleDecayWGDC    ; branch if bit(s) clear
           ldaa  WastegateDCDecayCounter    ; load A with memory contents
           beq   BC_GetBoostTargetFromTables    ; branch if equal (zero)
           deca                ; decrement A
           staa  WastegateDCDecayCounter    ; store A into memory
           bra   BC_GetBoostTargetFromTables    ; branch

BC_FallToIdleDecayWGDC:
           ldaa  WGDCDC_WGDCDecayCounterInit    ; load A with memory contents (data is 5d)
           staa  WastegateDCDecayCounter    ; store A into memory
BC_GetBoostTargetFromTables:
           ldx   #WSGRPA_AllowedBoostKnock_FromRpm    ; load index with value
           ldaa  EngineRpm_HB    ; load A with memory contents
           jsr   Lookup4ByteTable    ; call subroutine
           ldab  AdaptiveRetardIndex    ; load B with memory contents
           mul                 ; multiply (D=A*B)
           staa  Temp4         ; store A into memory
           ldx   #WSGRPM_AllowedBoost_FromRpm    ; load index with value
           brset *BitFlags_AIS, #$%00001000, LED14    ; branch if bit(s) set
           ldx   #WSGRP2_AllowedBoost_FromRpm    ; load index with value
   LED14:  ldaa  EngineRpm_HB    ; load A with memory contents
           jsr   Lookup4ByteTable    ; call subroutine
           suba  Temp4
           bpl   LED1E         ; branch if plus (hi bit 0)
           clra                ; A = 0
   LED1E:  staa  Temp4         ; store A into memory
           brclr *b5D_IPL2, #$%00000010, LED2E    ; branch if bit(s) clear
           cmpa  IPLBST_MaximumBoostWhenKnockSensorFault    ; compare A with memory contents (data is 00)
           bls   LED2E         ; branch if lower or same
           ldaa  IPLBST_MaximumBoostWhenKnockSensorFault    ; load A with memory contents (data is 00)
           staa  Temp4         ; store A into memory
   LED2E:  ldx   #WSGTIM_AllowedBoost_FromTime    ; load index with value
           ldaa  Timer_BoostTimer    ; load A with memory contents
           jsr   LookupAndKeepSmallerBoostGoal    ; call subroutine
           ldx   #WSGCLT_AllowedBoost_FromTemp    ; load index with value
           ldaa  CoolantTemp    ; load A with memory contents
           jsr   LookupAndKeepSmallerBoostGoal    ; call subroutine
           ldx   #WSGCHG_AllowedBoost_FromChargeTemp    ; load index with value
           ldaa  ChargeTempVolts    ; load A with memory contents
           jsr   LookupAndKeepSmallerBoostGoal    ; call subroutine
           brset *BitFlags37, #bf37_ATX, LED4F    ; branch if bit(s) set
           ldx   #MXSBS1_AllowedBoost_FromSpeed1    ; load index with value
           bra   LED5B         ; branch

   LED4F:  brset *BitFlags37, #bf37_ATXInDrive, LED58    ; branch if bit(s) set
           ldx   #MXSBS2_AllowedBoost_FromSpeed2    ; load index with value
           bra   LED5B         ; branch

   LED58:  ldx   #MXSBS3_AllowedBoost_FromSpeed3    ; load index with value
   LED5B:  ldd   VehicleSpeed_HB    ; load D (A&B) with memory contents
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           asld                ; shift left (D=D*2)
           jsr   LookupAndKeepSmallerBoostGoal    ; call subroutine
           brset *BitFlags66, #b66_FullThrottle, BC_CheckBoostSwitch    ; branch if bit(s) set
           ldx   #WSGPRT_AllowedBoostPartThrottle_FromThrottle    ; load index with value
           ldaa  TPSVolts      ; load A with memory contents
           suba  MINTHR_LowestSessionTPS
           bcc   LED71         ; branch if greater or equal
           clra                ; A = 0
   LED71:  jsr   LookupAndKeepSmallerBoostGoal    ; call subroutine
   
BC_CheckBoostSwitch:
; the switchable boost code uses a constant for the "lo" boost setting
; if the boost switch is enabled (set to "hi" boost), the code ignores the "lo" constant
; the code first checks to see if the switchable boost option is even enabled...

; here, I check to see if the switchable boost is enabled or not, if not just skip to StoreBoostTarget...
	   ldaa OPTN1_CalCustomOptionConfigFlags1
	   bita #opt_SwBoost ; check if switchable boost is enabled
           beq  BC_StoreBoostTargetToTemp4 ;skip looking at the switch state completely

	   ldab StartupSwitchMirror1    ; load b with memory contents
	   bita #opt_SwBstPol ; check the switch polarity
	   beq  BC_Polarity_Lo

BC_Polarity_Hi:
           bitb BSTSWS_HighBoostSwitchSelect
	   beq  BC_LoadLoBoostAndLookup	    ; branch if equal (zero)
	   bra  BC_StoreBoostTargetToTemp4

BC_Polarity_Lo:
	   bitb BSTSWS_HighBoostSwitchSelect
	   bne  BC_LoadLoBoostAndLookup	    ; branch if not equal (not zero)
	   bra  BC_StoreBoostTargetToTemp4

BC_LoadLoBoostAndLookup:
	   ldaa LOWBST_AllowedBoostLo    ; "lo" boost constant
           jsr  LookupAndKeepSmallerBoostGoal

BC_LoadStagingBoostAndLookup:
; add code to lookup specific boost target while staging
           ldx  #Turbonator_Flags
           brclr 0x00, x, #Turbonator_Staging, BC_StoreBoostTargetToTemp4 	 ; don't do anything unless we're staging, normal spark
           ldaa STGBST_AllowedBoostDuringStaging    ; staging boost constant
           jsr  LookupAndKeepSmallerBoostGoal

BC_StoreBoostTargetToTemp4:
           ldaa  Temp4         ; load A with memory contents
           psha                ; push A onto stack
           ldaa  BaroPressure    ; load A with memory contents
           ldx   #BSTMDB_BoostTargetModifierFromBaro    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           psha                ; push A onto stack
           ldaa  EngineRpm_HB    ; load A with memory contents
           ldx   #BSTMDR_BoostTargetModifierFromRPM    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           pula                ; pull A from stack
           mul                 ; multiply (D=A*B)
           tab                 ; B = A
           pula                ; pull A from stack
           sba                 ; subtract (A=A-B)
           bcc   LED90         ; branch if greater or equal
           clra                ; A = 0
   LED90:  psha                ; push A onto stack
           ldaa  BaroPressure    ; load A with memory contents
           ldx   #BSTMBR_BoostTargetModifierFromBaro2    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           pula                ; pull A from stack
           aba                 ; A=A+B
           bcc   LED9F         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   LED9F:  psha                ; push A onto stack
           ldaa  KnockRetardSum_AllCyls    ; load A with memory contents
           ldx   #BSTMDK_BoostTargetModifierFromTotalKnockRetard    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           pula                ; pull A from stack
           sba                 ; subtract (A=A-B)
           bcc   LEDAE         ; branch if greater or equal
           clra                ; A = 0
   LEDAE:  ldab  BaroPressure    ; load B with memory contents
           aba                 ; A=A+B
           bcc   BC_StoreBoostTargetTemp         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-

BC_StoreBoostTargetTemp:
           staa  BoostTargetTemp
           psha                ; push A onto stack
           tab                 ; B = A
           ldaa  MapValue      ; load A with memory contents
           sba                 ; subtract (A=A-B)
           bcc   BC_OverTargetBoost         ; branch if greater or equal
           cmpa  #0x80         ; 0x55 for 3-bar
           bcc   LEDCD         ; branch if greater or equal
           ldaa  #0x80         ; 0x55 for 3-bar
           bra   LEDCD         ; branch

BC_OverTargetBoost:
           cmpa  #0x7f         ; 0x54 for 3-bar
           bls   LEDCD         ; branch if lower or same
           ldaa  #0x7f         ; 0x54 for 3-bar
   LEDCD:  adda  #0x80         ; 0x55 for 3-bar
           ldx   #BSDLTH_BoostDeltaThresholdFromBoostTarget    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           staa  BoostDeltaThreshold
           ldaa  BoostDelta_Signed    ; load A with memory contents
           sba                 ; subtract (A=A-B)
           bvc   LEDE6         ; branch if overflow
           tsta                ; test A
           bpl   LEDE4         ; branch if plus (hi bit 0)
           ldaa  #0x7f         ; load a with value -01111111-
           bra   LEDE6         ; branch

   LEDE4:  ldaa  #0x80         ; load a with value -10000000-
   LEDE6:  adda  #0x80         ;  -10000000-
           ldx   #BSREDX_BoostTargetReductionFromDeltaBoost    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           pula                ; pull A from stack
           tstb                ; test B
           bpl   LEDF9         ; branch if plus (hi bit 0)
           negb                ; 2's complement B
           sba                 ; subtract (A=A-B)
           bcc   BC_StoreBoostTarget    ; branch if greater or equal
           clra                ; A = 0
           bra   BC_StoreBoostTarget    ; branch

   LEDF9:  brclr *BitFlags66, #b66_FullThrottle, BC_StoreBoostTarget    ; branch if bit(s) clear
           aba                 ; A=A+B
           bcc   BC_StoreBoostTarget    ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
BC_StoreBoostTarget:
           staa  BoostTarget    ; store A into memory
           ldaa  BoostDelta_Signed    ; load A with memory contents
           bpl   LEE09         ; branch if plus (hi bit 0)
           nega                ; negate A (set high bit)
   LEE09:  staa  Temp0         ; store A into memory
           ldaa  BoostTargetTemp    ; load A with memory contents
           ldab  BaroPressure    ; load B with memory contents
           addb  MAPPT_WastegateDutyCycleMapSwitchPoint    ;  (data is ff)
           bcc   BC_SelectAdaptiveWGCell    ; branch if greater or equal
           ldab  #0xff         ; load B with value -11111111-
BC_SelectAdaptiveWGCell:
           ldx   #DCCOR0_AdaptiveVNTCell0    ; load index with value
           cba                 ; compare A to B
           bcs   LEE36         ; branch if lower
           brclr *BitFlags66, #b66_FullThrottle, LEE36    ; branch if bit(s) clear
           inX                 ; increment index (I=I+1)
           ldab  EngineRpm_HB    ; load B with memory contents
           cmpb  DCRPM1_WastegateDutyCycleRpmBoundary1    ; compare B with memory contents (data is 88)
           bcs   LEE36         ; branch if lower
           inX                 ; increment index (I=I+1)
           cmpb  DCRPM2_WastegateDutyCycleRpmBoundary2    ; compare B with memory contents (data is 9c)
           bcs   LEE36         ; branch if lower
           inX                 ; increment index (I=I+1)
           cmpb  DCRPM3_WastegateDutyCycleRpmBoundary3    ; compare B with memory contents (data is ac)
           bcs   LEE36         ; branch if lower
           inX                 ; increment index (I=I+1)
   LEE36:  ldab  0x00, X      ; load B with memory at index + value -00000000-
;           brclr *BitFlags6A, #b6a_FuelOff, LEE53    ; branch if bit(s) clear

; v2 code paste
           ldx   #Turbonator_Flags
           brclr 0, x, #Turbonator_FuelOff, LEE53    ; branch if bit(s) set

           brclr *BitFlags6A, #b6a_Cruise2, LEE61    ; branch if bit(s) clear
           bclr  *BitFlags6A, #b6a_Cruise2    ; clear bits
           subb  WGDCOF_WastegateDutyCycleOffset    ; subtract memory contents from B (data is 00)
           bcs   LEE4D         ; branch if lower
           cmpb  WGMXER_MaxWGDCForBoostErrorCorrection    ; compare B with memory contents (data is 70)
           bhi   LEE50         ; branch if higher
   LEE4D:  ldab  WGMXER_MaxWGDCForBoostErrorCorrection    ; load B with memory contents (data is 70)
   LEE50:  jmp   BC_UpdateAdaptiveWGControlMemory

   LEE53:  suba  MapValue  
           bhi   BC_BoostIsBelowTarget    ; branch if higher
           nega                ; negate A (set high bit)
           staa  Temp3         ; store A into memory
           brset *BitFlags68, #b68_EndOfBlade, BC_ControlBoostCreep    ; branch if bit(s) set
           bset  *BitFlags68, #b68_EndOfBlade    ; set bits
   LEE61:  jmp   BC_ClearBoostErrTimer

BC_ControlBoostCreep:
           ldaa  BoostDelta_Signed    ; load A with memory contents
           bmi   LEE6D         ; branch if minus(hi bit 1)
           cmpa  DBCRPS_DeltaBoostLimitPositiveForBoostCreep    ; compare A with memory contents (data is 02)
           bcc   LEE9D         ; branch if greater or equal
   LEE6D:  ldaa  DBCRNG_DeltaBoostLimitNegativeForBoostCreep    ; load A with memory contents (data is 07)
           cmpa  Temp0         ; compare A with memory contents
           bcs   BC_JumpTo_ClearBoostErrorTimer    ; branch if lower
           ldaa  Timer_BoostErrTimer    ; load A with memory contents
           inca                ; increment A
           cmpa  DECPT_AdaptiveDecAfterThisTime    ; compare A with memory contents (data is 20)
           bcs   LEEBE         ; branch if lower
           ldaa  Temp3         ; load A with memory contents
           cmpa  MPFLOR_StopAdaptiveWGWhenDeltaMapIsLessThanThis    ; compare A with memory contents (data is 03)
           bcs   BC_JumpTo_ClearBoostErrorTimer    ; branch if lower
           ldaa  CurrentWastegatePosition    ; load A with memory contents
           beq   BC_JumpTo_ClearBoostErrorTimer    ; branch if equal (zero)
           ldaa  BoostTargetTemp    ; load A with memory contents
           cmpa  AMLIMH_MaxMultiplierCannotBeAbove7F    ; compare A with memory contents (data is 00)
           bcs   BC_JumpTo_ClearBoostErrorTimer    ; branch if lower
           ldaa  TpsVoltsOverMINTHR    ; load A with memory contents
           cmpa  TPSTHR_StopTrackingBoostErrorBelowThisDeltaTPS    ; compare A with memory contents (data is 00)
           bcs   BC_JumpTo_ClearBoostErrorTimer    ; branch if lower
           tst   BCTestValue1    ;  (data is ff)
           bmi   LEF19         ; branch if minus(hi bit 1)
           bra   LEF11         ; branch

   LEE9D:  ldaa  BaroPressure    ; load A with memory contents
           adda  OBCTRL_OverboostControlPoint    ;  (data is 75)
           bcc   LEEA6         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   LEEA6:  cmpa  MapValue      ; compare A with memory contents
           bhi   LEE6D         ; branch if higher
           ldaa  Timer_BoostErrTimer    ; load A with memory contents
           inca                ; increment A
           cmpa  INCPT_AdaptiveIncAfterThisTime    ; compare A with memory contents (data is 0f)
           bcs   BC_StoreBoostErrTimer    ; branch if lower
           cmpb  WGMXER_MaxWGDCForBoostErrorCorrection    ; compare B with memory contents (data is 70)
           bls   BC_JumpTo_ClearBoostErrorTimer    ; branch if lower or same
           subb  WGDCON_WGDCOffsetNegatve    ; subtract memory contents from B (data is 00)
           bra   BC_UpdateAdaptiveWGControlMemory    ; branch

BC_JumpTo_ClearBoostErrorTimer:
           bra   BC_ClearBoostErrTimer    ; branch

   LEEBE:  bra   BC_StoreBoostErrTimer    ; branch

BC_BoostIsBelowTarget:
           brclr *BitFlags68, #b68_EndOfBlade, BC_IncrementWGAdaptive    ; branch if bit(s) clear
           bclr  *BitFlags68, #b68_EndOfBlade    ; clear bits
           bra   BC_ClearBoostErrTimer    ; branch

BC_IncrementWGAdaptive:
           cmpa  MPROOF_StopAdaptiveWGWhenMapIsThisCloseToBoostTarget    ; compare A with memory contents (data is 03)
           bcs   BC_ClearBoostErrTimer    ; branch if lower
           ldaa  TPSVolts      ; load A with memory contents
           suba  MINTHR_LowestSessionTPS
           bls   BC_ClearBoostErrTimer    ; branch if lower or same
           cmpa  TPSLIM_UpdateAdaptiveWGTPSUpperLimit    ; compare A with memory contents (data is 85)
           bcs   BC_ClearBoostErrTimer    ; branch if lower
           ldaa  MapValue      ; load A with memory contents
           suba  MapAverageValue_HB
           bcc   LEEE0         ; branch if greater or equal
           nega                ; negate A (set high bit)
   LEEE0:  cmpa  MPDEL2_IncCounterWhenDeltaMapBelowThis2    ; compare A with memory contents (data is 0a)
           bhi   BC_ClearBoostErrTimer    ; branch if higher
           ldaa  EngineRpm_HB    ; load A with memory contents
           cmpa  DCRPML_NoWastegateDutyCycleCorrectionBelowThisRpm    ; compare A with memory contents (data is 46)
           bcs   BC_ClearBoostErrTimer    ; branch if lower
           cmpa  DCRPMH_NoWastegateDutyCycleCorrectionAboveThisRpm    ; compare A with memory contents (data is bc)
           bhi   BC_ClearBoostErrTimer    ; branch if higher
           ldaa  CoolantTemp    ; load A with memory contents
           cmpa  DCCTSL_NoWastegateDutyCycleCorrectionBelowThisCoolantTemp    ; compare A with memory contents (data is 58)
           bcs   BC_ClearBoostErrTimer    ; branch if lower
           ldaa  CurrentWastegatePosition    ; load A with memory contents
           beq   BC_ClearBoostErrTimer    ; branch if equal (zero)
           ldaa  BoostTargetTemp    ; load A with memory contents
           cmpa  AMLIML_MinMultiplierCannotBeBelow80    ; compare A with memory contents (data is 00)
           bcs   BC_ClearBoostErrTimer    ; branch if lower
           ldaa  Timer_BoostErrTimer    ; load A with memory contents
           inca                ; increment A
           cmpa  DECPTX_AdaptiveDecAfterThisTimeX    ; compare A with memory contents (data is 20)
           bcs   BC_StoreBoostErrTimer    ; branch if lower
           tst   BCTestValue2    ;  (data is 01)
           bmi   LEF19         ; branch if minus(hi bit 1)
   LEF11:  cmpb  WGMXR2_MaxWGDCForBoostErrorCorrection2    ; compare B with memory contents (data is 90)
           bcc   BC_ClearBoostErrTimer    ; branch if greater or equal
           incb                ; increment B
           bra   BC_UpdateAdaptiveWGControlMemory    ; branch

   LEF19:  cmpb  WGMXER_MaxWGDCForBoostErrorCorrection    ; compare B with memory contents (data is 70)
           bls   BC_ClearBoostErrTimer    ; branch if lower or same
           decb                ; decrement B
BC_UpdateAdaptiveWGControlMemory:
           stab  0x00, X      ;  -00000000-
BC_ClearBoostErrTimer:
           clra                ; A = 0
BC_StoreBoostErrTimer:
           staa  Timer_BoostErrTimer    ; store A into memory
           pshb                ; push B onto stack
           brset *BitFlags66, #b66_FullThrottle, BC_LookupWGDCFromTables    ; branch if bit(s) set
           brclr *BitFlags66, #b66_OffIdle, BC_JumpTo_UsePartThrottleWGDC    ; branch if bit(s) clear
           ldaa  BoostTargetTemp    ; load A with memory contents
           ldab  BSTGSC_BoostTargetScaleFactor    ; load B with memory contents (data is ff)
           mul                 ; multiply (D=A*B)
           adca  #0x00         ;  -00000000-
           psha                ; push A onto stack
           ldab  BaroPressure    ; load B with memory contents
           ldaa  BCTestValue3    ; load A with memory contents (data is ff)
           beq   LEF4E         ; branch if equal (zero)
           bpl   LEF47         ; branch if plus (hi bit 0)
           pula                ; pull A from stack
           sba                 ; subtract (A=A-B)
           bcc   LEF4D         ; branch if greater or equal
           clra                ; A = 0
           bra   LEF4D         ; branch

   LEF47:  pula                ; pull A from stack
           aba                 ; A=A+B
           bcc   LEF4D         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
   LEF4D:  psha                ; push A onto stack
   LEF4E:  ldaa  EngineRpm_HB    ; load A with memory contents
           ldx   #BSTTSH_BoostTargetThresholdForDefaultWGDutyCycle    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           pula                ; pull A from stack
           tstb                ; test B
           bpl   LEF63         ; branch if plus (hi bit 0)
           subb  #0x80         ;  -10000000-
           aba                 ; A=A+B
           bcc   LEF67         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
           bra   LEF67         ; branch

   LEF63:  sba                 ; subtract (A=A-B)
           bcc   LEF67         ; branch if greater or equal
           clra                ; A = 0
   LEF67:  brclr *BitFlags6A, #b6a_DRBToggle2, LEF7F    ; branch if bit(s) clear
           ldab  BSTHOF_BoostThresholdOffsetForWGControl    ; load B with memory contents (data is 00)
           sba                 ; subtract (A=A-B)
           bcc   LEF72         ; branch if greater or equal
           clra                ; A = 0
   LEF72:  cmpa  MapValue      ; compare A with memory contents
           bls   BC_LookupWGDCFromTables    ; branch if lower or same
           ldaa  MXWGDC_MaxWGDutyCycle    ; load A with memory contents (data is c8)
           pulb                ; pull B from stack
           bclr  *BitFlags6A, #b6a_DRBToggle2    ; clear bits
           bra   BC_StoreWGDutyCycle    ; branch

   LEF7F:  cmpa  MapValue      ; compare A with memory contents
           bhi   BC_LoadMaxWGDutyCycle    ; branch if higher
           bset  *BitFlags6A, #b6a_DRBToggle2    ; set bits
           bra   BC_LookupWGDCFromTables    ; branch

BC_LoadMaxWGDutyCycle:
           pulb                ; pull B from stack
           ldaa  MXWGDC_MaxWGDutyCycle    ; load A with memory contents (data is c8)
           bra   BC_StoreWGDutyCycle    ; branch

BC_JumpTo_UsePartThrottleWGDC:
           bra   BC_UsePartThrottleWGDC    ; branch

BC_LookupWGDCFromTables:
           ldaa  BoostTarget    ; load A with memory contents
           suba  BaroPressure
           bcc   LEF97         ; branch if greater or equal
           clra                ; A = 0
   LEF97:  ldx   #DCWOT_FullThrottleWastegateDutyCycle_C8is100Percent_FromMap    ; load index with value
           jsr   Lookup4ByteTable    ; call subroutine
           psha                ; push A onto stack
           ldx   #DCWADJ_FullThrottleWastegateDutyCycleAdjustment_FromRpm    ; load index with value
           brset *BitFlags66, #b66_FullThrottle, LEFA8    ; branch if bit(s) set
           ldx   #DCPADJ_PartThrottleWastegateDutyCycleAdjustment_FromRpm    ; load index with value
   LEFA8:  ldaa  EngineRpm_HB    ; load A with memory contents
           jsr   Lookup4ByteTable    ; call subroutine
           pula                ; pull A from stack
           tstb                ; test B
           bmi   LEFB8         ; branch if minus(hi bit 1)
           aba                 ; A=A+B
           bcc   LEFBD         ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
           bra   LEFBD         ; branch

   LEFB8:  negb                ; 2's complement B
           sba                 ; subtract (A=A-B)
           bcc   LEFBD         ; branch if greater or equal
           clra                ; A = 0
   LEFBD:  pulb                ; pull B from stack
           subb  #0x80         ;  -10000000-
           bmi   LEFC9         ; branch if minus(hi bit 1)
           aba                 ; A=A+B
           bcc   BC_UseMaxWGDC    ; branch if greater or equal
           ldaa  #0xff         ; load a with value -11111111-
           bra   BC_UseMaxWGDC    ; branch

   LEFC9:  negb                ; 2's complement B
           sba                 ; subtract (A=A-B)
           bcc   BC_UseMaxWGDC    ; branch if greater or equal
           clra                ; A = 0
           bra   BC_UseMaxWGDC    ; branch

BC_UsePartThrottleWGDC:
           pulb                ; pull B from stack
           ldaa  Timer_BoostTimer    ; load A with memory contents
           beq   BC_ClearWGDC    ; branch if equal (zero)
           ldaa  WastegateDCDecayCounter    ; load A with memory contents
           beq   BC_ClearWGDC    ; branch if equal (zero)
           ldaa  DFWGDC_DefaultWastegateDutyCycle    ; load A with memory contents (data is c8)
           bra   BC_StoreWGDutyCycle    ; branch

BC_ClearWGDC:
           clra                ; A = 0
BC_UseMaxWGDC:
           cmpa  #0xc8         ; compare a with value -11001000-
           bls   BC_StoreWGDutyCycle    ; branch if lower or same
           ldaa  #0xc8         ; load a with value -11001000-
BC_StoreWGDutyCycle:
           jsr   NULL_ROUTINE    ; call subroutine
           staa  CurrentWastegatePosition    ; store A into memory
           rts                 ; return from subroutine

Interrupt_TimerOC3_Wastegate:
           ldaa  CurrentWastegatePosition    ; load A with memory contents
           cmpa  #0x08         ; compare a with value -00001000-
           bhi   LEFF6         ; branch if higher
           ldd   WGDCDL_WasteGateDutyCycleTimeDelay    ;  (data is 4b00)
           bra   LF013         ; branch

   LEFF6:  ldab  WGDCMX_MaximumWGDutyCycleForControl    ; load B with memory contents (data is c8)
           subb  #0x08         ;  -00001000-
           cba                 ; compare A to B
           bcs   LF003         ; branch if lower
           ldd   WGDCDL_WasteGateDutyCycleTimeDelay    ;  (data is 4b00)
           bra   LF01B         ; branch

   LF003:  ldab  WGDCSC_WasteGateDutyCycleFactor    ; load B with memory contents (data is 60)
           mul                 ; multiply (D=A*B)
           brset *PIA2_Buffer, #$%00000100, LF01B    ; branch if bit(s) set
           subd  WGDCDL_WasteGateDutyCycleTimeDelay    ;  (data is 4b00)
           coma                ; 1's complement A
           comb                ; 1's complement B
           addd  #0x0001        ;  -00000000 00000001-
   LF013:  bset  *PIA2_Buffer, #$%00000100    ; set bits
           bset  *CCDFlags2, #$%00000100    ; set bits
           bra   LF021         ; branch

   LF01B:  bclr  *PIA2_Buffer, #$%00000100    ; clear bits
           bclr  *CCDFlags2, #$%00000100    ; clear bits
   LF021:  psha                ; push A onto stack
           pshb                ; push B onto stack
           ldab  CPU_SerialPeripheralControl    ; load B with memory contents
           orab  #0x01         ;  -00000001-
           stab  CPU_SerialPeripheralControl    ; store B into memory
           bclr  *PIA1_Buffer, #$%00000100    ; clear bits
           ldab  PIA1_Buffer    ; load B with memory contents
           stab  PortX_Control    ; store B into memory
           ldaa  CCDFlags2     ; load A with memory contents
           cmpa  CPU_SerialPeripheralStatus    ; compare A with memory contents
           staa  CPU_SerialPeripheralDataIO
           mul                 ; multiply (D=A*B)
           mul                 ; multiply (D=A*B)
           nop                 ; no operation
           bset  *PIA1_Buffer, #$%00000100    ; set bits
           ldaa  PIA1_Buffer    ; load A with memory contents
           staa  PortX_Control
           ldaa  CPU_SerialPeripheralDataIO    ; load A with memory contents
           ldab  CPU_SerialPeripheralControl    ; load B with memory contents
           andb  #0xfc         ;  -11111100-
           stab  CPU_SerialPeripheralControl    ; store B into memory
           pulb                ; pull B from stack
           pula                ; pull A from stack
           addd  CPU_Timer_OC3_Wastegate
           std   CPU_Timer_OC3_Wastegate
           ldaa  #0x20         ; load a with value -00100000-
           staa  CPU_TimerInterruptFlag1
           rti                 ; return from interrupt
           
; ***********************************************************************
;   ----------------------------------------------------
; 	Additional code modules
;   ----------------------------------------------------
;   ----------------------------------------------------
; 	Flash Check Engine Light on Knock Routine
;   ----------------------------------------------------
; 
; This needs to be called somewhere in the MainProgramLoop,
; it is known to work when called at CalcBoostGoal_MM.
; PIA1_A_Buffer gets altered throughout the code, every
; time through the main loop these bits are copied to the
; actual hardware.
; 
; To enable this code, simply check the Custom Options flag for it
; in the table file. This codebase has been modified to check for
; the option and will automatically re-config the SMEC appropriately.
; 
; 
UseCELForKnockIndication_MM:
        ldx   #OPTN1_CalCustomOptionConfigFlags1
	brclr 0, X, #opt_FlashCE, FlashCEL_OnKnock_return
	brset *BitFlags6F, #b6f_FuelEngineNotRunning, FlashCEL_OnKnock_return	  ; branch if bit(s) set
	ldaa  CoolantTemp
	cmpa  KNKMIN_FlashCEMinTemp
	bcs   FlashCEL_OnKnock_return; cold motor creates a LOT of false positives
	ldaa  Cylinder2Retard	 ; load a with memory contents
	bne   KnockDetect_LightCEL	    ; branch if not equal (not zero)
	ldaa  Cylinder1Retard	 ; load a with memory contents
	bne   KnockDetect_LightCEL	    ; branch if not equal (not zero)
	ldaa  Cylinder3Retard	 ; load a with memory contents
	bne   KnockDetect_LightCEL	    ; branch if not equal (not zero)
	ldaa  Cylinder4Retard	 ; load a with memory contents
	bne   KnockDetect_LightCEL	    ; branch if not equal (not zero)
NoKnockDetect_UnlightCEL:		; fallthrough, extinguish light
	bset	*PIA1_Buffer, #pia_CEL
	bra	FlashCEL_OnKnock_return
KnockDetect_LightCEL:
	bclr	*PIA1_Buffer, #pia_CEL
FlashCEL_OnKnock_return:
	rts
	
;   -------------------------------------------------------
;	Launch Control Routine
;   -------------------------------------------------------
LaunchControl_MM:

           ldx   #Turbonator_Flags
	   brclr *TimerOverflowsBetweenDistPulses, #$%11111111, LaunchControl_CheckEnable    ; branch if bit(s) clear
           bra   LaunchControl_Off

LaunchControl_CheckEnable:
           ldaa  OPTN2_CalCustomOptionConfigFlags2
           bita  #opt_StageLim ; do these all need to be here? Or just the stagelim optn?
           bne   LaunchControl_CheckSwitch       ; run the rev limiter code
           bra   LaunchControl_Off

LaunchControl_CheckSwitch:
           ; check to see if no switch is selected, if no switch, assume speed cutoff only
           ldab  STGSWS_StagingLimiterEnableSwitch
           beq   LaunchControl_CheckTPS

           ; if there is a switch specified, check it against the switch port to see if it's 'on'
	   bitb  StartupSwitchMirror1
           beq   LaunchControl_Off

LaunchControl_CheckTPS:
           ldab  TpsVolts
           subb  MINTHR_LowestSessionTPS
           bcs   LaunchControl_Off ; turn off launch control if TPS is lower than MINTHR
           cmpb  STGTPS_StageLimiterMinTPS ; to prevent the lauch control from coming on at idle
           bcs   LaunchControl_Off ; brach if TPS over MINTHR is less than threshold

LaunchControl_CheckSpeed:
	   ldd   VehicleSpeed_HB	               ; load d (a&b) with memory contents
	   asld		                       ; shift left (d=d*2)
	   asld		                       ; shift left (d=d*2)
	   cmpa  STGSPD_StageLimiterCutoffSpeed    ; compare a with memory contents (data is 0a)
	   bcc   LaunchControl_Off		       ; branch if the vehicle speed is greater than the cutoff speed

LaunchControl_On:
           bset  0, x, #Turbonator_Staging         ; set the flag to indicate that the staging limiter conditions are met
	   bra   LaunchControl_DecideEngineOnOff   ; branch

LaunchControl_Off:
           clr   Counter_SparkCut
           ldy   #Pattern_SparkCut
           bset  0, y, #bit_all
           bclr  0, x, #Turbonator_Staging         ; clear the flag indicating the staging limiter conditions are NOT met
           bra   LaunchControl_AllowFuelSpark

LaunchControl_DecideEngineOnOff:
	   brclr 0, x, #Turbonator_FuelOff | Turbonator_SparkCut, LaunchControl_CheckUpperRPM    ; branch if bit(s) clear
           jmp   LaunchControl_CheckLowerRPM

LaunchControl_CheckUpperRPM:
	   ldaa  EngineRpm_HB                      ; load a with memory contents
	   cmpa  STGROF_StageLimiterRPMOffSetpoint ; compare a with memory at index + value
	   bcs   LaunchControl_AllowFuelSpark; branch if launch control RPM is greater than current RPM

LaunchControl_Cutout_ShutOffEngineForThisRotation:
           ldaa  OPTN2_CalCustomOptionConfigFlags2
           bita  #opt_FuelRevLim
           beq   LaunchControl_CheckSparkCut       ; don't turn off the fuel...
           bset  0, x, #Turbonator_FuelOff         ; set bits

LaunchControl_CheckSparkCut:
           bita  #opt_SprkRevLim
           beq   LaunchControl_Return              ; don't turn off the spark...
           bset  0, x, #Turbonator_SparkCut        ; new T-SMEC Spark rev limiter
           bra   LaunchControl_Return

LaunchControl_CheckLowerRPM:
           ldaa  EngineRpm_HB    ; load a with memory contents
	   cmpa  STGRON_StageLimiterRPMOnSetpoint  ; compare a with memory at index + value
	   bcc   LaunchControl_Return	       ; branch if RPM is higher than OFF point

LaunchControl_AllowFuelSpark:
           bclr  0, x, #Turbonator_FuelOff | Turbonator_SparkCut ; new T-SMEC Spark rev limiter

LaunchControl_Return:
	   rts		                       ; return from subroutine

;   -------------------------------------------------------
;	Anti-Lag Retard Routine
;   -------------------------------------------------------
CalculateSparkCutandAntiLagRetard_Routine:
 
        ; ******************************************************************
        ; Called from the falling edge interrupt sevice routine...
        ; on entry and exit, accA contains the total timing (don't use accA for anything else in this routine!)
        ; if anti-lag should be on, substitute the antilag value for the total timing
        ; otherwise return the original
        
        ; Rotating spark cut:
        ; 2 address tables, one containing the 'value', 1 the 'base';
        ; 'base' is used to count (counter init)
        ; 'value' is rotated (ROLx), the result in carry is used to determine if the cylinder should be allowed to fire this time.
        ; When the count = base, then reset the counter and reload the pattern
        ;
        ; The 'Spark Cut Fraction' value is now simply a pointer to the pattern and counter base.

        ; Patterns:

        ; 1/3 - 011  00000; index = 0; value = 96(0x60); base = 3+1
        ; 2/3 - 001  00000; index = 1; value = 32(0x20); base = 3+1
        ; 3/5 - 00101  000; index = 2; value = 40(0x28); base = 5+1
        ; 4/5 - 01000  000; index = 3; value = 64(0x40); base = 5+1
        ; 3/7 - 0011011  0; index = 4; value = 54(0x36); base = 7+1
        ; 4/7 - 0010101  0; index = 5; value = 42(0x2a); base = 7+1
        ; 5/7 - 0010001  0; index = 6; value = 34(0x22); base = 7+1
        ; 6/7 - 0001000  0; index = 7; value = 16(0x10); base = 7+1
        
        ; Other patterns or modified patterns are also possible.

        ; ******************************************************************
        ; check spark and anti-lag enable conditions

           ldx  #Turbonator_Flags
           bclr 0x00, x, #Turbonator_AntiLag ; clear the antilag flag since it hasn't been determined yet
           bset  0x00, x, #Turbonator_AllowSpark ; spark is allowed normally
           brclr 0x00, x, #Turbonator_Staging, AntiLag_Return 	 ; don't do anything unless we're staging, normal spark
           brclr 0x00, x, #Turbonator_SparkCut, CalulateLaunchAdvance ; branch if the spark cut isn't on right now - check for anti-lag conditions since we are staging
           bclr  0x00, x, #Turbonator_AllowSpark ; spark cut is on, so clear the 'allow' flag

RotateSparkCutPattern:
           ; counter works because this routine is called from the rising edge routine - once per cylinder
           ldab Counter_SparkCut
           beq  SetBaseandPattern
           dec  Counter_SparkCut
           rol  Pattern_SparkCut ; if we should have spark, then the carry bit will be set after the rotate
           bcc  CalulateLaunchAdvance ; if carry is now set, then allow spark...

AllowSparkThisRotation:
           bset 0x00, x, #Turbonator_AllowSpark ; allow spark for just this revolution...

           ; check that antilag is enabled

CalulateLaunchAdvance:
           ldx  #OPTN2_CalCustomOptionConfigFlags2
           brclr 0x00, X, #opt_AntiLag, AntiLag_Return

           ldab ANLGRP_AntiLagRetardRPM
           cmpb EngineRpm_HB
           bcc  AntiLag_Return ; branch if
           ldaa ANTLAG_AntiLagRetardAbs
           asra
           asra ; divide by 4 - min/max = +/-16 deg
           adca #0x00 ; round up any remainder
           ldx  #Turbonator_Flags
           bset 0x00, x, #Turbonator_AntiLag ;just to indicate that the anti-lag is active, for logging purposes

AntiLag_Return:
           rts
        
SetBaseandPattern:
           ldab SPKFRC_SparkCutFraction ; this is now an offset value
           ldy  #LNCBDT_BaseDataTable
           aby
           ldab 0x00, Y ; b now contains the pattern
           stab Counter_SparkCut

           ldab SPKFRC_SparkCutFraction ; this is now an offset value -- oops, this was left off, made the pattern wrong
           ldy  #LNCPDT_PatternDataTable
           aby
           ldab 0x00, Y ; b now contains the base value
           stab Pattern_SparkCut ; need new RAM location for this
           bra  CalulateLaunchAdvance 
           
;   -------------------------------------------------------
;	Wideband Transfer Function Routine
;   -------------------------------------------------------
;
; This rotuine converts a WB input signal to a NBO2 type of signal for ue wit hthe stock O2 controller.
; Converts the WB signal to an AFR for different sensor types/outputs; can be logged.
; Has an option for a NB offset to allow twaeking of the rich/lean condition

ConvertWB2NBSignal_MM:

        ldaa RawAirFuelSensInput
        ldab OPTN2_CalCustomOptionConfigFlags2    ; load a with memory contents (data is 9f)
        bitb #opt_WB2NB                           ;  -00000001-
        beq  WB2NB_Return                         ; branch if equal (zero)

LookupWB2NBXferFunc:

        ldx  #WB2AFR_WidebandToAFRTransferFunction  ; load index with value
        jsr  Lookup4ByteTable                     ; call subroutine
        staa AFRatio
        ldx  #AFR2NB_WidebandAFRToO2TransferFunction  ; load index with value
        jsr  Lookup4ByteTable                     ; call subroutine
        adda NBOFFS_NarrowBandOffsetValue

WB2NB_Return:
        staa O2SensorValue
        rts                            ; * there is still code after this instruction


	.org	0xffa4
ChryslerCopyrightNotice:
	.str	"Copr. 1990 Chrysler Corp."

	.org	0xffd6
SCI_Interrupt_vector:
	.word	Interrupt_RealTime

	.org	0xffd8
SPIE_Flag_Interrupt_vector:
	.word	Interrupt_RealTime

	.org	0xffda
PAII_Flag_Interrupt_vector:
	.word	Interrupt_PulseAccumulatorInputEdge

	.org	0xffdc
PAOVI_Flag_Interrupt_vector:
	.word	Interrupt_PulseAccumulatorInputEdge

	.org	0xffde
TOI_Flag_Interrupt_vector:
	.word	Interrupt_RealTime

	.org	0xffe0
OC5_Flag_Interrupt_vector:
	.word	InterruptVector_DwellTimer

	.org	0xffe2
OC4_Flag_Interrupt_vector:
	.word	LCCF2

	.org	0xffe4
OC3_Flag_Interrupt_vector:
	.word	Interrupt_TimerOC3_Wastegate

	.org	0xffe6
OC2_Flag_Interrupt_vector:
	.word	Interrupt_PulseAccumulatorInputEdge

	.org	0xffe8
OC1_Timer_Interrupt_vector:
	.word	Interrupt_TimerOutputCapture1

	.org	0xffea
IC3_Timer_Interrupt_vector:
	.word	Interrupt_RealTime

	.org	0xffec
IC2_Timer_Interrupt_vector:
	.word	Interrupt_SpeedometerSignal

	.org	0xffee
IC1_Timer_Interrupt_vector:
	.word	InterruptVector_DistributorSignal

	.org	0xfff0
Realtime_Interrupt_vector:
	.word	Interrupt_RealTime

	.org	0xfff2
IRQ_hardware_Interrupt_vector:
	.word	Interrupt_PIA_Signal

	.org	0xfff4
XIRQ_hardware_Interrupt_vector:
	.word	Interrupt_XIRQ

	.org	0xfff6
SWI_Software_Interrupt_vector:
	.word	Interrupt_Software

	.org	0xfff8
Illegal_Opcode_vector:
	.word	Interrupt_BadOp

	.org	0xfffa
COP_Watchdog_Timeout_vector:
	.word	Interrupt_COPFail

	.org	0xfffc
Clock_Monitor_Fail_vector:
	.word	Interrupt_ClockMonFail

	.org	0xfffe
ResetVector:
	.word	ResetInterrupt

        .msg "Assembly Complete..." ; these are just messages to display during assemble to let you know what's going on...
