	.title TurbonatorT3iiv1
	.area ROM (ABS)
; SET TABS to 4 if text appears jumbled
;  ____________________________________________________________________________
; |									       \
; |									       |
; |   Mopar ECM T3 SBEC							       |
; |   Based on 1991 Turbo III Codebase				               |
; |									       |
; | Code and original design and data Copyright � 1990 by Chrysler Corporation |
; | This relocateable source is Copyright 2010 by Robert Lloyd		       |
; | Modified code modules are Copyright 2010				       |
; |				  by Robert Lloyd			       |
; | 1) Added option config constant for new module options.		       |
; | 2) Added switchable boost option, changed code from previous "mod" to      |
; |    in-line code; allow for enable/disable by option register.	       |
; | 3) Added staging rev limiter (2-step). User can enable/disable in code, or |
; |    by button by the driver, and by speed.				       |
; | 4) Added anti-lag code. Pulls timing when transitioning from P/T to WOT    |
; |    and while the staging limiter is enabled.                               |
; | 5) Added CE Flash for knock indication. CE Light flashes in proportion to  |
; |    knock retard. 
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
; 06/06/11 - Converted to MPT2 format (prior to 1st release).
;
; Version 1.1
; 08/04/11 - Added 'TBLBK3_3DTableBreakPointHiLo' to the template. This was
;            previously a declared value in the code that specifies the break
;            point between the hi- and lo-MAP 3D input tables.
;          - Fixed the definition of 'AVMRPM_MinimumRPMToResetAverageMAP'.
;          - Added 'OFSMID_OffsetForMAPOverIdle' to MAP scaling list.
;
; Version 1.2
; 08/08/11 - Updated the Density Factors and MAP-dependant transient fuel
;            tables to scale inversely with MAP.
;          - Updated the naming of the Decel Fuel Shutoff valules and added to
;            a new separate group.
;          - Updated the Staging Limiter code. Was not working due to the decel
;            fuel shutoff code.
;          - Added code to correct the fuel mileage reporting to the CCD bus.
;
; Version 1.3
; 09/26/12 - Fixed Cruise Control, update the fuel and spark for 3-bar +40
;            version.
;
version == 01
;
; ***********************************************************************

; Routines ending with "_MM" are called from MainProgramLoop.

; ***********************************************************************
; Code/data can be org'd anywhere in the $8000-$ffd5 range, except
; you MUST leave a hole from $b600-$b7ff (on chip eeprom). The interrupt
; vectors must be from $ffd6-$ffff.
; ***********************************************************************

DataOrg == 0x8000
CodeOrg == 0x9500 ;original was 0x9100


; ***********************************************************************
; These variables can be changed, then the source recompiled.
; ***********************************************************************

IncludeFillerBytes = 1	    ; 1=stock - to ensure exact byte for byte reloc

; ***********************************************************************
; MAP SENSOR
; ***********************************************************************
;
; !!! MAP Changes are now handled directly thru MP Tune !!!
; !!!       Do Not Use the MAP switches anymore         !!!
;
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

.define CalDataFile /C:\Users\jpctu\Dropbox\ROM\cals\T-T3_IIv1\T-T3_22_T3ii_T3_MTX_3-bar+40.tpl/
        
; Currently supplied template files :
;
;    T-T3_22_T3_MTX_A393.v1
;
; More to be added later. Simply copy the filename above into the .include
; statement and it will assemble with those calibration values.
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
; If I ever build my own template editor, I will move this scaling to the
; editor.
; ***********************************************************************
; CHeM2 CalX Header Info

    chem2 title TurbonatorT3v1
    chem2 description 1992 Chrysler Turbo III SBEC Calibration
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
;
; 68HC11 Disassembly
;    Mopar ECM
;
; Custom Code Seeking - Documenting disassembler
; Copyright � 2006 by Geoff Allan.

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

; RAM (bottom 256 bytes)

L0000	 == 0x0000
L0001	 == 0x0001
L0003	 == 0x0003
L0004	 == 0x0004
MINTHR_LowestSessionTPS	 == 0x0005
DCCOR0_AdaptiveVNTCell0	 == 0x0006
DCCOR1_AdaptiveWastegateCellBelow3psi	 == 0x0007
DCCOR2_AdaptiveWastegateCellTo4000rpm	 == 0x0008
DCCOR3_AdaptiveWastegateCellTo4992rpm	 == 0x0009
DCCOR4_AdaptiveWastegateCellTo5504rpm	 == 0x000a
DCCOR5_AdaptiveWastegateCellAbove5504rpm	 == 0x000b
DCCOR6_AdaptiveVNTCell1	 == 0x000c
DCCOR7_AdaptiveVNTCell2	 == 0x000d
Timer_DacalCountdown	 == 0x000e
CurrentAisPosition	 == 0x000f
BitFlags_AIS	 == 0x0010
    b10_bit7			= $%10000000	;
    b10_bit6			= $%01000000	;
    b10_UseAIS		        = $%00100000	;Too much boost
    b10_bit4			= $%00010000	;
    b10_ATXInGear		= $%00001000	;Auto in gear
    b10_ATXChngGear		= $%00000100	;Auto just changed gears
    b10_bit1			= $%00000010	;
    b10_bit0			= $%00000001	;
AutoCalCell0	 == 0x0011
AutoCalCell1	 == 0x0012
AutoCalCell2	 == 0x0013
AutoCalCell3	 == 0x0014
AutoCalCell4	 == 0x0015
AutoCalCell5	 == 0x0016
AutoCalCell6	 == 0x0017
AutoCalCell7	 == 0x0018
AutoCalCell8	 == 0x0019
AutoCalCell9	 == 0x001a
AutoCalCell10	 == 0x001b
AutoCalCell11	 == 0x001c
AutoCalCell12idle	 == 0x001d
AutoCalCellEnd	 == 0x001e
ErrorBitRegister0	 == 0x001f
    b1f_errLostFJ2		= $%10000000	; 44 Loss of FJ2
    b1f_errNothing		= $%01000000	; 45 Nothing (overboost)
    b1f_errHighVoltage		= $%00100000	; 46 Battery Volts High
    b1f_errLowVoltage		= $%00010000	; 47 Battery Volts Low
    b1f_errStuckLean		= $%00001000	; 51 Lean condition
    b1f_errStuckRich		= $%00000100	; 52 Rich Condition
    b1f_errChecksum		= $%00000010	; 53 Prom Checksum
    b1f_errDistSync		= $%00000001	; 54 Distributor Sync
ErrorBitRegister1	 == 0x0020
    b20_errAcCutoutRelay	= $%10000000	; 33 AC Cutout Relay
    b20_errSpeedCtlSolenoid	= $%01000000	; 34 Speed Ctl Solenoid
    b20_errRadFanRelay		= $%00100000	; 35 Radiator Fan Relay
    b20_errWastegateSolenoid	= $%00010000	; 36 Wastegate Solenoid
    b20_errBaroReadSolenoid	= $%00001000	; 37 Barometric Read Solenoid
    b20_errChargingSystem	= $%00000100	; 41 Charging System
    b20_errASDRelay		= $%00000010	; 42 Auto Shutdown Relay
    b20_errIgnitionCoil 	= $%00000001	; 43 Ignition Coil Control
ErrorBitRegister2	 == 0x0021
    b21_errCoolantTempSensor	= $%10000000	; 22 Coolant Temp Sensor
    b21_errChargeTempSensor	= $%01000000	; 23 Charge Temp Sensor
    b21_errTPS			= $%00100000	; 24 Throttle Position
    b21_errAIS			= $%00010000	; 25 AIS Motor
    b21_errInjectorCurrent	= $%00001000	; 26 Injector Current Limit Not Achieved
    b21_errInjectorDriver	= $%00000100	; 27 Injector Driver interface
    b21_errPurgeSolenoid	= $%00000010	; 31 Purge Solenoid
    b21_errEGR		        = $%00000001	; 32 Exh Gas Recirc Solenoid
ErrorBitRegister3	 == 0x0022
    b22_errNotCranked		= $%10000000	; 11 Engine Not Cranked Since Battery Disconnected
    b22_errMemPowerLost 	= $%01000000	; 12 Memory Standby Power Lost
    b22_errMapPneumatic 	= $%00100000	; 13 MAP Pneumatic
    b22_errMapElectrical	= $%00010000	; 14 MAP Electrical
    b22_errDistanceSensor	= $%00001000	; 15 Vehicle Distance Sensor
    b22_errBattVoltageSense	= $%00000100	; 16 Battery Voltage Sense
    b22_errEngineTooCool	= $%00000010	; 17 Engine Running Too Cool (thermostat)
    b22_errO2Sensor		= $%00000001	; 21 Oxygen Sensor
ErrorBitRegisterStored0	 == 0x0023
    b23_bit7			= $%10000000	; 44 Loss of FJ2
    b23_bit6			= $%01000000	; 45 Overboost
    b23_bit5			= $%00100000	; 46 Battery Volts High
    b23_bit4			= $%00010000	; 47 Battery Volts Low
    b23_bit3			= $%00001000	; 51 Lean condition
    b23_bit2			= $%00000100	; 52 Rich Condition
    b23_bit1			= $%00000010	; 53 Prom Checksum
    b23_bit0			= $%00000001	; 54 Distributor Sync
ErrorBitRegisterStored1	 == 0x0024
    b24_bit7			= $%10000000	; 33 AC Cutout Relay
    b24_bit6			= $%01000000	; 34 Speed Ctl Solenoid
    b24_bit5			= $%00100000	; 35 Radiator Fan Relay
    b24_bit4			= $%00010000	; 36 Wastegate Solenoid
    b24_bit3			= $%00001000	; 37 Barometric Read Solenoid
    b24_bit2			= $%00000100	; 41 Charging System
    b24_bit1			= $%00000010	; 42 Auto Shutdown Relay
    b24_bit0			= $%00000001	; 43 Ignition Coil Control
ErrorBitRegisterStored2	 == 0x0025
    b25_bit7			= $%10000000	; 22 Coolant Temp Sensor
    b25_bit6			= $%01000000	; 23 Charge Temp Sensor
    b25_bit5			= $%00100000	; 24 Throttle Position
    b25_bit4			= $%00010000	; 25 AIS Motor
    b25_bit3			= $%00001000	; 26 Injector Current Limit Not Achieved
    b25_bit2			= $%00000100	; 27 Injector Driver interface
    b25_bit1			= $%00000010	; 31 Purge Solenoid
    b25_bit0			= $%00000001	; 32 Exh Gas Recirc Solenoid
ErrorBitRegisterStored3	 == 0x0026
    b26_bit7			= $%10000000	; 11 Engine Not Cranked Since Battery Disconnected
    b26_bit6			= $%01000000	; 12 Memory Standby Power Lost
    b26_bit5			= $%00100000	; 13 MAP Pneumatic
    b26_bit4			= $%00010000	; 14 MAP Electrical
    b26_bit3			= $%00001000	; 15 Vehicle Distance Sensor
    b26_bit2			= $%00000100	; 16 Battery Voltage Sense
    b26_bit1			= $%00000010	; 17 Engine Running Too Cool
    b26_bit0			= $%00000001	; 21 Oxygen Sensor
ErrorCodeUpdateKeyOnCount	 == 0x0027
ErrorCodeUpdateKeyOnCount2	 == 0x0028
ErrorCodeUpdateKeyOnCount3	 == 0x0029
Cyl2_InjPWTrim	 == 0x002a
Cyl1_InjPWTrim	 == 0x002b
Cyl3_InjPWTrim	 == 0x002c
Cyl4_InjPWTrim	 == 0x002d
CylTrimFlags	 == 0x002e
L002F	 == 0x002f
L0030	 == 0x0030
L0031	 == 0x0031
L0032	 == 0x0032
Counter_SpeedSensorInterrupt_HB	 == 0x0033
Counter_SpeedSensorInterrupt_LB	 == 0x0034
AdaptiveRetardIndex	 == 0x0035
BitFlags_36	                 == 0x0036
    b36_EGR			= $%10000000	; EGR Active
    b36_bit6			= $%01000000	;
    b36_ReadBaroRequired	= $%00100000	; Read Baro At Next Opportunity
    b36_EMR			= $%00010000	; Emission Maint Reminder
    b36_bit3			= $%00001000	; Not used
    b36_bit2			= $%00000100	; Not used
    b36_ais1			= $%00000010	; AIS Step Phase - specifies which of the bit patterns
    b36_ais0			= $%00000001	; AIS Step Phase   is being output to the stepper motor
    b36_both			= $%00000011
BodyComputerBatteryVoltsOutput	 == 0x0037
Timer_Dwell_14	 == 0x0038
Timer_Dwell_23	 == 0x0039
CurrentWastegatePosition	 == 0x003a
WastegateDutyCycleDecreaseFromX	 == 0x003b
Timer_BoostErrTimer	 == 0x003c
StartupSwitchMirror1	 == 0x003d
    sw1_bit7           	        = $%10000000
    sw1_bit6       	        = $%01000000
    sw1_Brake                   = $%00100000
    sw1_PNswitch                = $%00010000
    sw1_CruiseResume            = $%00001000
    sw1_CruiseOnOff             = $%00000100
    sw1_CruiseSet               = $%00000010
    sw1_bit0                    = $%00000001
PIA_Buffer1	 == 0x003e
    pia_Fan                     = $%10000000
    pia_CEL                     = $%01000000
    pia_bit5                    = $%00100000
    pia_Baro                    = $%00010000
    pia_bit3                    = $%00001000
    pia_bit2                    = $%00000100
    pia_bit1                    = $%00000010
    pia_bit0                    = $%00000001
PIA_Buffer2	 == 0x003f
    pia_bit7                    = $%10000000
    pia_KnockCap                = $%01000000    
    pia_ChargeTemp              = $%00100000    
    pia_CoolantTemp             = $%00010000
    pia_FuelMon                 = $%00001000    
    pia_bit2                    = $%00000100    
    pia_Tach                    = $%00000010    
    pia_bit0                    = $%00000001
CruiseControlSpeedRef	 == 0x0040
L0041	 == 0x0041 ; not used
CruiseStatus_1	 == 0x0042
CruiseStatus_2	 == 0x0043
Counter_Cruise_1	 == 0x0044
Counter_Cruise	 == 0x0045
Counter_TimerRegHalfOverflowBetweenSpeedoPulses	 == 0x0046
PreviousVehicleSpeed_HB	 == 0x0047
PreviousVehicleSpeed_LB	 == 0x0048
TimerOverflowsBetweenSpeedoPulses	 == 0x0049
InverseVehicleSpeed_HB	 == 0x004a
InverseVehicleSpeed_LB	 == 0x004b
VehicleSpeed_HB	 == 0x004c
VehicleSpeed_LB	 == 0x004d
Counter_Cruise_2	 == 0x004e
Counter_Cruise_3	 == 0x004f
CruiseSpeedSetpoint	 == 0x0050
CruiseControlVar0	 == 0x0051
CruiseControlVar1	 == 0x0052
CruiseControlVar2	 == 0x0053
CruiseControlVar3	 == 0x0054
CruiseControlVar4	 == 0x0055
Counter_SomethingWithCamSensor	 == 0x0056
CruiseControlVar6	 == 0x0057
ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB	 == 0x0058
ErrorBitsAssociatedWithPIA1AndReg1eTo25_LB	 == 0x0059
ClearTheErrorTimer_0	 == 0x005a
ClearTheErrorTimer_1	 == 0x005b
b5c_IPL1						  == 0x005c
    b5c_MapStuck		= $%10000000	; Map Stuck
    b5c_TpsBadSignal		= $%01000000	; Throttle
    b5c_MapBadSignal		= $%00100000	; MapVolts
    b5c_Bad_BatVolts		= $%00010000	; BatVolts
    b5c_bit3			= $%00001000	;
    b5c_BattNotCharging 	= $%00000100	; BatVoltsNotNearTarget
    b5c_BadCoolantTemp		= $%00000010	; Cool Volts
    b5c_BadCTSensor		= $%00000001	; ChargeVolts
b5d_IPL2						  == 0x005d
    b5d_EGRSolFault		= $%10000000	; EGR Solenoid Fault
    b5d_MajorFault		= $%01000000	; Major Fault
    b5d_bit5			= $%00100000	;
    b5d_InjectorFault		= $%00010000	; Fuel Injector Fault
    b5d_WGSolFault		= $%00001000	; Map Wastegate
    b5d_EMRLight		= $%00000100	; EMR Light?
    b5d_bit1			= $%00000010	;
    b5d_bit0			= $%00000001	;
BitFlags5E	 == 0x005e
    b5e_MapOK			= $%10000000	; Map OK
    b5e_bit6			= $%01000000	;
    b5e_bit5			= $%00100000	;
    b5e_bit4			= $%00010000	;
    b5e_bit3		        = $%00001000	;
    b5e_bit2		        = $%00000100	;
    b5e_bit1			= $%00000010	;
    b5e_bit0 		        = $%00000001	;
ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR	 == 0x005f
TimerOverflowsBetweenCamPulses	 == 0x0060
DistributorFallingEdgePulsewidth_HB	 == 0x0061
DistributorFallingEdgePulsewidth_LB	 == 0x0062
Counter_TimerPastHalfwayBetweenCamPulses	 == 0x0063
LastCamFallingEdgeTime	 == 0x0064
BitFlags65	 == 0x0065
    b65_bit7			= $%10000000	;
    b65_bit6			= $%01000000	;
    b65_bit5			= $%00100000	;
    b65_bit4			= $%00010000	;
    b65_bit3			= $%00001000	;
    b65_bit2			= $%00000100	;
    b65_bit1			= $%00000010	;
    b65_bit0			= $%00000001	;
BitFlags66	 == 0x0066
    b66_OffIdle 		= $%10000000	; Throttle Pressed
    b66_UpdatedMINTHR		= $%01000000	; Minimum Throttle Value has been updated with an actual value
    b66_OpenLoop		= $%00100000	; Not In Closed Loop ;Oxygen Sensor Stuck
    b66_O2Valid 		= $%00010000	; Oxygen Sensor Has Been Outside .75V to .29V Range
    b66_PartThrottle		= $%00001000	; Throttle Lightly Pressed
    b66_O2Rich			= $%00000100	; Oxygen Sensor on the Rich Side
    b66_PTEisMaxed		= $%00000010	; Part Throttle Enrichment is maxed
    b66_FullThrottle		= $%00000001	; Throttle Floored
BitFlags67	 == 0x0067
    b67_Purge			= $%10000000	; Canister Purge
    b67_FallToIdle		= $%01000000	; Engine Speed Too High to be Idling
    b67_InMotion		= $%00100000	; Something to do with vehicle moving
    b67_StayOpenLoop		= $%00010000	; Dont Try Closed Loop
    b67_IdleSpeedMode		= $%00001000	; Dont Control Idle Speed (if clear dont control AIS, if set dont control idle with Injectors)
    b67_OpenLoop		= $%00000100	; Currently Open Loop
    b67_bit1			= $%00000010	; Something with reg 73
    b67_BadO2			= $%00000001	; Oxygen Sensor Bad
BitFlags68	 == 0x0068
    b68_SparkEngineNotRunning	= $%10000000	; Spark - Engine Not Running
    b68_bit6			= $%01000000	; AIS Stuff
    b68_BaroSolEnergized	= $%00100000	;
    b68_ASDon			= $%00010000	; ASD ON
    b68_SpeedOver40		= $%00001000	; SPEED GREATER THAN 40 MPH
    b68_Past12secRunning	= $%00000100	; ENGINE RUNNING MORE THAN 12 sec OR KEY ON FOR MORE THAN 12 sec
    b68_BladePassedSensor	= $%00000010	; WINDOW BLADE HAS PASSED THROUGH DISTRIBUTOR SYNC SENSOR
    b68_EndOfBlade		= $%00000001	; END OF ANY BLADE AT DISTRIBUTOR REF SENSOR
BitFlags69	 == 0x0069
    b69_bit7        		= $%10000000	; Coolant temp filter/store?
    b69_bit6			= $%01000000	; Coolant temp filter/store?
    b69_AtIdle			= $%00100000	; Just returned to idle
    b69_AcClutch		= $%00010000	; AC clutch engaged
    b69_bit3			= $%00001000	; ?
    b69_bit2			= $%00000100	; AC?
    b69_bit1			= $%00000010	;
    b69_bit0			= $%00000001	;
    b69_BadO2Read		= $%00000011    ; Indicates a bad O2 sensor reading?
BitFlags6a	 == 0x006a
    b6a_Cruise4 		= $%10000000	; cruise bit
    b6a_Cruise3 		= $%01000000	; cruise bit
    b6a_Cruise2 		= $%00100000	; cruise bit
    b6a_Cruise1 		= $%00010000	; cruise bit
    b6a_OverRev 		= $%00001000	; OverRevving
    b6a_FuelOff 		= $%00000100	; Shut Off Fuel
    b6a_DRBToggle2		= $%00000010	; DRBII Toggle
    b6a_DRBToggle1		= $%00000001	; DRBII Toggle
BitFlags6b	 == 0x006b
    b6b_bit7			= $%10000000	;
    b6b_bit6			= $%01000000	;
    b6b_bit5			= $%00100000	; Coil Test
    b6b_bit4			= $%00010000	;
    b6b_bit3			= $%00001000	;
    b6b_bit2			= $%00000100	;
    b6b_bit1		        = $%00000010	; Purge Solenoid
    b6b_bit0			= $%00000001	; Coil Test
BitFlags6c	 == 0x006c
    b6c_VNTOvBst		= $%10000000	; VNT Overboost 
    b6c_bit6			= $%01000000	;
    b6c_bit5			= $%00100000	;
    b6c_DRBModeFlag		= $%00010000	; indicates system is in DRB test mode
    b6c_bit3			= $%00001000	;
    b6c_bit2			= $%00000100	;
    b6c_bit1		        = $%00000010	;
    b6c_EMR_1			= $%00000001	; emission maint reminder
BitFlags6d	 == 0x006d
    b6d_FuelEngineNotRunning	= $%10000000	; Fuel - Engine Not Running
    b6d_BigMapChange		= $%01000000	; Significant MAP Change
    b6d_JustStarted		= $%00100000	; Engine Just Started
    b6d_Starting		= $%00010000	; Use Starting Injector PW Calculations (instead of Running Injector PW Calculations)
    b6d_BaroOkEngineStopped	= $%00001000	; Take Baro Reading Straight From MAP Since Engine Not Running
    b6d_Uncranked		= $%00000100	; Engine Not Cranked Since
    b6d_DisableNormalDwell	= $%00000010	; Normal Dwell Disable
    b6d_NeedSetup		= $%00000001	; System Needs To Run Setup Routine
BitFlags6e	 == 0x006e
    b6e_BoostOver5psi		= $%10000000	; Boost Greater than 5 PSI
    b6e_WastegateDC		= $%01000000	; Current WasteGate Duty Cycle
    b6e_DistSync		= $%00100000	; Distributor Sync Value
    b6e_UseSparkScatter 	= $%00010000	; Use Spark Scatter
    b6e_SearchBladeEndRef	= $%00001000	; Search for end of window blade on Reference Signal
    b6e_bit2		        = $%00000100	; Oxygen Sensor Enable or something with CAM position bits not in sync with distributor
    b6e_InjectorB		= $%00000010	; CAM Position Bit 1 - this bit controls InjectorB
    b6e_InjectorA		= $%00000001	; CAM Position Bit 0 - this bit controls InjectorA
    b6e_InjectorAandB		= $%00000011	; Both b6e_InjectorB and b6e_InjectorA
BitFlags6f	 == 0x006f
    b6f_bit7			= $%10000000
    b6f_bit6			= $%01000000
    b6f_bit5                    = $%00100000
    b6f_BadSpeedo1		= $%00010000    ; Stuck Off
    b6f_BadSpeedo2              = $%00001000    ; Stuck On
    b6f_BadASD			= $%00000100    ; ASD Test
    b6f_Alternator1	        = $%00000010    ; Alternator test
    b6f_Alternator2	        = $%00000001    ; Alternator test
    b6f_AlternatorBits		= $%00000011    ;
BitFlags70	 == 0x0070
    b70_bit7			= $%10000000
    b70_bit6			= $%01000000
    b70_O2Enable                = $%00100000
    b70_AlternatorField	        = $%00010000    ; AlternatorField
    b70_bit3		        = $%00001000
    b70_bit2			= $%00000100
    b70_bit1		        = $%00000010
    b70_bit0		        = $%00000001
BitFlags71	 == 0x0071
TargetIdleSpeedHB	 == 0x0072
TargetIdleSpeedLB	 == 0x0073
SumOfFuelModifiers_HB	 == 0x0074
SumOfFuelModifiers_LB	 == 0x0075
InjectorPulsewidth_HB	 == 0x0076
InjectorPulsewidth_LB	 == 0x0077
BaseInjectorPulsewidth_HB	 == 0x0078
BaseInjectorPulsewidth_LB	 == 0x0079
EngineRpm_HB	 == 0x007a
EngineRpm_LB	 == 0x007b
PreviousEngineRpm_HB	 == 0x007c
PreviousEngineRpm_LB	 == 0x007d
ChargeTempVolts	 == 0x007e
BaroPressure	 == 0x007f
MapVolts	 == 0x0080
MapAverageValue_HB	 == 0x0081
MapAverageValue_LB	 == 0x0082
MapValue	 == 0x0083
Factor_LeanoutOrEnrichTime_MAP	 == 0x0084
TpsAverageValue_HB	 == 0x0085
TpsAverageValue_LB	 == 0x0086
TpsVolts	 == 0x0087
Factor_LeanoutOrEnrichTime_TPS	 == 0x0088
Timer_DelayBeforeUpdating_MINTHR	 == 0x0089
CoolantTemp	 == 0x008a
BatteryVolts	 == 0x008b
O2SensorVolts	 == 0x008c
LastTPSVolts	 == 0x008d
LastCoolantTempVolts	 == 0x008e
LastChargeTempVolts	 == 0x008f
KnockVolts	 == 0x0090
AmbientAirTempVolts == 0x0091
TargetBatteryVolts	 == 0x0092
Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached	 == 0x0093
Counter_FallingEdgeEPP_MaxFF	 == 0x0094
Counter_EPP_MaxFF	 == 0x0095
Factor_StartFuelDecayIntoRunFuel	 == 0x0096
Timer_OpenLoopFraction	 == 0x0097
Factor_DecelLeanoutWhenMAPDecreasing	 == 0x0098
Timer_OffThrottleFuelEnrich	 == 0x0099
Timer_O2InhibitSwitchingRichIdleToClosedLoop	 == 0x009a
Pulsewidth_PartThrottleEnrichment_HB	 == 0x009b
Pulsewidth_PartThrottleEnrichment_LB	 == 0x009c
Pulsewidth_AISEnrichment_HB	 == 0x009d
Pulsewidth_AISEnrichment_LB	 == 0x009e
Counter_O2SensorFeedbackCount_Signed	 == 0x009f
Timer_CountdownFromStartRunForAisFeedback	 == 0x00a0
KeyOnOrEngineRunningTime	 == 0x00a1
Counter_MainLoop	 == 0x00a2
EngineRunningTimeMaxFF	 == 0x00a3
EngineRunningTimeBeforeStall	 == 0x00a4
Timer_AlternatorDutyCycle	 == 0x00a5
MinimumTimerCountBeforeMainloopCanContinue	 == 0x00a6
CountdownTimerFromKeyOn	 == 0x00a7
Timer_CLTIME_ClosedLoopTimer	 == 0x00a8
Counter_AdaptiveMem_Erase	 == 0x00a9
Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop	 == 0x00aa
AdaptiveCellUpdateTimer_IncrementedEveryCamRisingEdge	 == 0x00ab
PointerIntoAdaptiveMemory	 == 0x00ac
ValueFromAdaptiveMemory	 == 0x00ad
SparkScatterIncrement	 == 0x00ae
EngineRPM_3D	 == 0x00af
CurrentWGIncrement	 == 0x00b0
SparkScatterFuelStabilizationValue_HB	 == 0x00b1
SparkScatterFuelStabilizationValue_LB	 == 0x00b2
Timer_FuelEnrich	 == 0x00b3
InjectorLatency	 == 0x00b4
Timer_OutOfClosedLoopMode	 == 0x00b5
Timer_O2ToggleDuration	 == 0x00b6
DesiredNewAisPosition	 == 0x00b7
Timer_AisChanges	 == 0x00b8
Timer_AcClutchEngageRestrictionTimer	 == 0x00b9
Timer_AcCutout	 == 0x00ba
Timer_AisOrO2Sensor	 == 0x00bb
ACClutchToggleVar	 == 0x00bc
Counter_AirCond	 == 0x00bd
Timer_RadSteamingCountdown	 == 0x00be
Timer_MinimumFanRun	 == 0x00bf
BitFlagsC0	 == 0x00c0
Timer_OverboostCountdown	 == 0x00c1
Timer_Over5PsiBoostMaxFF	 == 0x00c2
CalculatedSparkAdvance	 == 0x00c3
Cylinder2Retard	 == 0x00c4
Cylinder1Retard	 == 0x00c5
Cylinder3Retard	 == 0x00c6
Cylinder4Retard	 == 0x00c7
MaxRetardFromMAP	 == 0x00c8
WastegateDutyCycleIncreaseFromKnock	 == 0x00c9
KnockSensorThreshold	 == 0x00ca
Timer_BaroReadInterval	 == 0x00cb
Timer_BaroReadRpmConditionsSatisfied	 == 0x00cc
Timer_ThermostatDiagnostics	 == 0x00cd
Timer_O2MiddleDiagnostics	 == 0x00ce
PreviousBoostOverBaro	 == 0x00cf
BoostDelta_Signed	 == 0x00d0
CCDFlagsX	 == 0x00d1
DRBOffsetStored_HB	 == 0x00d2
DRBOffsetStored_LB	 == 0x00d3
ATMOffset	 == 0x00d4
DRBPointer1	 == 0x00d5
DRBPointer2	 == 0x00d6
DRBPointer3	 == 0x00d7
DRBSerialMode	 == 0x00d8
    bbe_FastSerial		= $%10000000	; Hi-Speed Logger flag
    bbe_ByteMode		= $%01000000	; Byte-Mode Serial code Download (apprently special test for development/S60)
    bbe_TestType3		= $%00100000	; Test type indicator (1-, 2-, or 3-byte)
    bbe_TestType2		= $%00010000	; Test type indicator (1-, 2-, or 3-byte)
    bbe_bit3			= $%00001000	; The bottom half is used as a loop counter for timeout purposes
    bbe_bit2			= $%00000100	;
    bbe_bit1			= $%00000010	;
    bbe_bit0			= $%00000001	;
    bbe_top			= $%11110000	; all control bits
    bbe_bottom			= $%00001111	; all counter bits
CCDTemp_HB	 == 0x00d9
CCDTemp_LB	 == 0x00da
L00DB	 == 0x00db
CCDFuelOutput_HB	 == 0x00dc
CCDFuelOutput_LB	 == 0x00dd
CCDFlags1	 == 0x00de
CCDFlags2	 == 0x00df
CCDFlags3	 == 0x00e0
CCDFlags4	 == 0x00e1
CCDFlags5	 == 0x00e2

      ccd_AlarmDisable          = $%00100000

CCDFlags6	 == 0x00e3
AdvanceTemporary	 == 0x00e4
SparkScatter	 == 0x00e5
CylTrim_Adaptive_Var1	 == 0x00e6
CylTrim_FlagsE7	 == 0x00e7
CylTrim_FlagsE8	 == 0x00e8
Counter_FuelEngRunning	 == 0x00e9
Counter_CylTrim1	 == 0x00ea
Counter_CylTrim2	 == 0x00eb
BaseFuelScalar	 == 0x00ec
Counter_ACControl1	 == 0x00ed
AISCounter_Z	 == 0x00ee
BoostTarget	 == 0x00ef
TempX	 == 0x00f0
TempY	 == 0x00f1
CruiseControlSwitchStateAnalog	 == 0x00f2
FDRVar1	 == 0x00f3
FDRVar2	 == 0x00f4
FDRVar3	 == 0x00f5
Temp0	 == 0x00f6
Temp1	 == 0x00f7
Temp2	 == 0x00f8
Temp3	 == 0x00f9
Temp4	 == 0x00fa
Temp5	 == 0x00fb
Temp6	 == 0x00fc
Temp7	 == 0x00fd
L00FE	 == 0x00fe
L0100	 == 0x0100
L0108	 == 0x0108
L0A20	 == 0x0a20
L0D20	 == 0x0d20
L0E20	 == 0x0e20
L0F20	 == 0x0f20
CPU_PortA	 == 0x1000
CPU_L1001_Reserved	 == 0x1001
CPU_PortIOControl	 == 0x1002
CPU_PortC	 == 0x1003
CPU_PortB	 == 0x1004
CPU_PortCL	 == 0x1005
CPU_L1006Reserved	 == 0x1006
CPU_PortC_DataDirection	 == 0x1007
CPU_PortD	 == 0x1008
CPU_PortD_DataDirection	 == 0x1009
CPU_PortE	 == 0x100a
CPU_HardwareTimerForceCompare	 == 0x100b
CPU_OutputCompare1Mask	 == 0x100c
CPU_OutputCompare1D	 == 0x100d
CPU_TimerCounterRegHigh	 == 0x100e
CPU_TimerCounterRegLow	 == 0x100f
CPU_DistPickupCaptureRegHigh	 == 0x1010
CPU_TimerInputCapture2_Speedometer	 == 0x1012
CPU_TimerInputCapture3	 == 0x1014
CPU_TimerOutputCompareRegHigh1	 == 0x1016
CPU_Timer_OC2	 == 0x1018
CPU_Timer_OC3_Wastegate	 == 0x101a
CPU_Timer_OC4_DwellA	 == 0x101c
CPU_Timer_OC5_DwellB	 == 0x101e
CPU_TimerControlReg1	 == 0x1020
CPU_TimerControlReg2	 == 0x1021
CPU_TimerInterruptMask1	 == 0x1022
CPU_TimerInterruptFlag1	 == 0x1023
CPU_TimerInterruptMask2	 == 0x1024
CPU_TimerInterruptFlag2	 == 0x1025
CPU_PortA_Control	 == 0x1026
CPU_PulseAccCounterRegister	 == 0x1027
CPU_SerialPeripheralControl	 == 0x1028
    spi_InterruptEnable                 = $%10000000
    spi_SystemEnable                    = $%01000000
    spi_PortDWORMode                    = $%00100000
    spi_MasterModeEnable                = $%00010000
    spi_ClockPolarityMode               = $%00001000
    spi_ClockPhaseSelect                = $%00000100
    spi_BitRateSelect1                  = $%00000010
    spi_BitRateSelect0                  = $%00000001
CPU_SerialPeripheralStatus	 == 0x1029
    spi_TransferStatus                  = $%10000000
    spi_WriteCollisionError             = $%01000000
    spi_Bit5                            = $%00100000 ; not implemented
    spi_ModeFaultError                  = $%00010000
    spi_Bit3                            = $%00001000 ; not implemented
    spi_Bit2                            = $%00000100 ; not implemented
    spi_Bit1                            = $%00000010 ; not implemented
    spi_Bit0                            = $%00000001 ; not implemented
CPU_SerialPeripheralDataIO	 == 0x102a
CPU_SerialBaudRate	         == 0x102b
CPU_SerialControlReg1	         == 0x102c
CPU_SerialControlReg2	         == 0x102d
CPU_SerialStatus	         == 0x102e
CPU_SerialData	                 == 0x102f
CPU_A2DControlReg	         == 0x1030
CPU_A2DResults1	                 == 0x1031
CPU_A2DResults2	                 == 0x1032
CPU_A2DResults3	                 == 0x1033
CPU_A2DResults4	                 == 0x1034
CPU_BlockProtReg	         == 0x1035
CPU_SysConfigOptionReg	         == 0x1039
CPU_ArmResetCopTimerReg	         == 0x103a
CPU_EEPROMControlReg	         == 0x103b
CPU_HighPriorityInterruptMask	 == 0x103c
CPU_SysInit	                 == 0x103d
SystemConfigReg	                 == 0x103f


SwitchPortAccessReg1	         == 0x6400
SwitchPortAccessReg2	         == 0x6401
PIA_Ctrl_1	                 == 0x6402
PIA_Ctrl_2	                 == 0x6403
PIA_Ctrl_3	                 == 0x6404
PIA_Ctrl_4	                 == 0x6405
PIA_Ctrl_5	                 == 0x6406
PIA_Ctrl_6	                 == 0x6407
InjectorPulsewidth_HB_Cyl1	 == 0x6408
InjectorPulsewidth_HB_Cyl2	 == 0x640a
InjectorPulsewidth_HB_Cyl3	 == 0x640c
InjectorPulsewidth_HB_Cyl4	 == 0x640e

PortX_Control	                 == 0x6440

ErrorCodeCounter	         == 0x6480
ByteModeVar0	                 == 0x6481
ByteModeVar1	                 == 0x6482
ByteModeVar2	                 == 0x6483
ByteModeVar3	                 == 0x6484
BodyCompFlags4_X	         == 0x6485
Counter_SpeedSensorInterrupt_HB_X	 == 0x6486
MAPOffsetForCylTrim	         == 0x6487
DeltaBoostSampleCounter	         == 0x6488
MapValueX	                 == 0x6489
MapVoltsX	                 == 0x648a
BitFlags648b	                 == 0x648b
BatVoltsDiagCounter	         == 0x648c
A2DResults2Temp	                 == 0x648d
ColdStartFuelReduxCounter	 == 0x648e
O2AdvanceIncrement	         == 0x648f
Counter_O2Diagnostics	         == 0x6490
ScaledDistPWForCruiseControl	 == 0x6491
EngineRpm_HB_X	                 == 0x6492
EngineRpm_LB_X	                 == 0x6493
Timer_BoostTimer	         == 0x6494
MAPAvgDelta	                 == 0x6495
TPSAvgDelta	                 == 0x6496
FuelLookupValue3D	         == 0x6497
KnockEnrichmentFactor	         == 0x6498
BaseFuelModifier	         == 0x6499
CruiseControlSwitchStateDigital	 == 0x649a
CruiseControlSwitchStateAnalogSnapshot	 == 0x649b
DRB_ProgramModeFlag	         == 0x649c
DRB_SpecialProgramRoutine        == 0x649e

;------------------------------------------------------------------------------

; Pretty sure this space actually exsists
; So, I'll use it for the Turbonator Mods...
Turbonator_Flags    == 0x64a3
    Turbonator_SparkOff  	= $%10000000    ; Turbonator - Spark-based rev limiter
    Turbonator_Staging	        = $%01000000    ; Turbonator - staging limiter is active
    Turbonator_DroppingRPM      = $%00100000    ; Turbonator - RPM is dropping (for 2-step control)
RevLimiterRPMOff    == 0x64a4
RevLimiterRPMOn     == 0x64a5
AntiLagRetard       == 0x64a6

L64D0 == 0x64d0

;------------------------------------------------------------------------------

; *****************************************************************************
; load cal data
; *****************************************************************************

        .include /CalDataFile/

; *****************************************************************************
; begin code
; *****************************************************************************

	.org CodeOrg
        .msg "Assembling Code..."

Interrupt_TimerOutputCapture1:
           ldaa #0x80          ; load a with value -10000000-
           staa CPU_TimerInterruptFlag1
           ldaa #0x10          ; load a with value -00010000-
           staa CPU_A2DControlReg
           ldd  CPU_TimerOutputCompareRegHigh1
           addd #0x03be        ;  -00000011 10111110-
           cmpD CPU_TimerCounterRegHigh    ; compare D
           bpl  L911C          ; branch if plus (hi bit 0)
           ldd  CPU_TimerCounterRegHigh
           addd #0x03be        ;  -00000011 10111110-
   L911C:  addd #0x0004         ;  -00000000 00000100-
           std  CPU_TimerOutputCompareRegHigh1
           ldaa CPU_TimerInterruptMask1    ; load a with memory contents
           anda #0x7f          ; AND a with value -01111111-
           staa CPU_TimerInterruptMask1
           ldaa Timer_AlternatorDutyCycle    ; load a with memory contents
           inca                ; increment a
           staa Timer_AlternatorDutyCycle    ; store a into memory
           cli                 ; enable interrupts
           lsra            
           bcc  ControlAlternator    ; branch if greater or equal
           jmp  AisDriveRoutine

ControlAlternator:
           ldx  #SwitchPortAccessReg1    ; load index with value
           ldaa ATMOffset      ; load a with memory contents
           cmpa #0x0d          ; compare a with value -00001101-
           beq  L91B7          ; branch if equal (zero)
           brset *BitFlags6e, #$%10000000, TurnAlternatorOff    ; branch if bit(s) set
           ldab #0x11          ; load b with value -00010001-
           brset *BitFlags70, #$%00000010, L914B    ; branch if bit(s) set
           ldab #0x15          ; load b with value -00010101-
   L914B:  bclr *BitFlags70, #$%00000010    ; clear bits
           cmpb EngineRpm_HB
           bhi  TurnAlternatorOff    ; branch if higher
           bset *BitFlags70, #$%00000010    ; set bits
           ldaa BatteryVolts    ; load a with memory contents
           cmpa #0x41          ; compare a with value -01000001-
           bcc  L9161          ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x06          ;  -00000110-
           bne  TurnAlternatorOff    ; branch if not equal (not zero)
   L9161:  brclr *BitFlags71, #$%00001000, L9182    ; branch if bit(s) clear
           ldaa A2DResults2Temp    ; load a with memory contents
           bne  L9172          ; branch if not equal (not zero)
           ldaa CPU_A2DResults2    ; load a with memory contents
           staa A2DResults2Temp
           bra  TurnAlternatorOff    ; branch

   L9172:  suba CPU_A2DResults2
           bls  TurnAlternatorOff    ; branch if lower or same
           cmpa BTVHYS_BatteryVoltsHysteresisForAlternatorControl    ; compare a with memory contents (data is 04)
           bls  TurnAlternatorOff    ; branch if lower or same
           bset *BitFlags71, #$%00000100    ; set bits
           bclr *BitFlags71, #$%00001000    ; clear bits
   L9182:  clr  A2DResults2Temp    ; zero byte at memory location
           ldaa CPU_A2DResults2    ; load a with memory contents
           suba TargetBatteryVolts
           bne  L9192          ; branch if not equal (not zero)
           brclr  0, X, #$%00000100, TurnAlternatorOn    ; branch if bit(s) clear
           bra  TurnAlternatorOff    ; branch

   L9192:  ldaB #0x0e          ; load b with value -00001110-
           bcc  L91A5          ; branch if greater or equal
           nega                ; negate a (set high bit)
           cmpa #0x02          ; compare a with value -00000010-
           beq  L919F          ; branch if equal (zero)
           bcc  TurnAlternatorOn    ; branch if greater or equal
           ldaB #0x06          ; load b with value -00000110-
   L919F:  andb Timer_AlternatorDutyCycle
           beq  TurnAlternatorOff    ; branch if equal (zero)
           bra  TurnAlternatorOn    ; branch

   L91A5:  cmpa #0x02          ; compare a with value -00000010-
           beq  L91AD          ; branch if equal (zero)
           bcc  TurnAlternatorOff    ; branch if greater or equal
           ldaB #0x06          ; load b with value -00000110-
   L91AD:  andb Timer_AlternatorDutyCycle
           bne  TurnAlternatorOff    ; branch if not equal (not zero)
TurnAlternatorOn:
           bset 0, X, #$%00000100    ; bit set -00000000-
           bset *BitFlags70, #$%00000100    ; set bits
   L91B7:  bra  L91BF          ; branch

TurnAlternatorOff:
           bclr 0, X, #$%00000100    ; bit clear -00000000-
           bclr *BitFlags70, #$%00000100    ; clear bits
   L91BF:  sei                 ; disable interrupts
           bset 2, X, #$%00000100    ; bit set -00000010-
           ldaa #0x12          ; load a with value -00010010-
   L91C5:  deca                ; decrement a
           bne  L91C5          ; branch if not equal (not zero)
           bclr 2, X, #$%00000100    ; bit clear -00000010-
           cli                 ; enable interrupts
           jmp  XmitRequestedRamLocation

;	.org	0x91cf
AISCounter_ZInit:
	.byte	0x02
;	.org	0x91d0
AISTEP_BitPatternForAisControl:
	.byte	0x06,0x05,0x09,0x0a

AisDriveRoutine:
           ldab BatteryVolts    ; load b with memory contents
           cmpb BTVAIS_MinVoltageForAis    ; compare b with memory contents (data is 71)
           bcs  L9213          ; branch if lower
           ldab CountdownTimerFromKeyOn    ; load b with memory contents
           bne  L9213          ; branch if not equal (not zero)
           ldab CurrentAisPosition    ; load b with memory contents
           brset *BitFlags_AIS, #$%01000000, L920E    ; branch if bit(s) set
           lsra            
           bcs  L9213          ; branch if lower
           cmpb DesiredNewAisPosition
           beq  L9215          ; branch if equal (zero)
           bcs  L91FB          ; branch if lower
           brclr *BitFlags_AIS, #$%10000000, L921E    ; branch if bit(s) clear
           ldaa AISCounter_Z          ; load a with memory contents
           bne  L9217          ; branch if not equal (not zero)
           bclr *BitFlags_AIS, #$%10000000    ; clear bits
           bra  L921E          ; branch

   L91FB:  brset *BitFlags_AIS, #$%10000000, L9206    ; branch if bit(s) set
           ldaa AISCounter_Z          ; load a with memory contents
           bne  L9217          ; branch if not equal (not zero)
           bset *BitFlags_AIS, #$%10000000    ; set bits
   L9206:  inc  CurrentAisPosition
           ldab BitFlags_AIS    ; load b with memory contents
           incb            
           bra  L9224          ; branch

   L920E:  bne  L921E          ; branch if not equal (not zero)
           bclr *BitFlags_AIS, #$%11000000    ; clear bits
   L9213:  bra  XmitRequestedRamLocation    ; branch

   L9215:  ldaa AISCounter_Z          ; load a with memory contents
   L9217:  suba #0x01          ;  -00000001-
           bcc  L9268          ; branch if greater or equal
           clra                ; a = 0
           bra  L9268          ; branch

   L921E:  dec  CurrentAisPosition    ; decrement memory contents
           ldab BitFlags_AIS    ; load b with memory contents
           decb            
   L9224:  andb #0x03          ;  -00000011-
           ldx  #AISTEP_BitPatternForAisControl    ; load index with value
           abx                 ; add b to index
           ldaa BitFlags_AIS    ; load a with memory contents
           anda #0xfc          ; AND a with value -11111100-
           aba                 ; a=a+b
           staa BitFlags_AIS    ; store a into memory
           ldab 0x00, X        ; load b with memory at index + value
           sei                 ; disable interrupts
           ldaa PIA_Buffer2    ; load a with memory contents
           oraA #pia_bit0          ;  -00000001-
           staa PortX_Control
           anda #~pia_bit0          ; AND a with value -11111110-
           staa PortX_Control
           staa PIA_Buffer2    ; store a into memory
           bset *PIA_Buffer2, #pia_bit0    ; set bits
           ldaa PIA_Buffer2    ; load a with memory contents
           staa PortX_Control
           tba                 ; a = b
           comb            
           lslb            
           lslb            
           lslb            
           lslb            
           andA #0x0f          ; AND a with value -00001111-
           aba                 ; a=a+b
           ldx  #CPU_PortD     ; load index with value
           bclr 0, X, #$%00100000    ; bit clear -00000000-
           cmpa CPU_SerialPeripheralStatus    ; compare a with memory contents
           staa CPU_SerialPeripheralDataIO
           mul                 ; multiply (d=a*b)
           mul                 ; multiply (d=a*b)
           bset 0, X, #$%00100000    ; bit set -00000000-
           cli                 ; enable interrupts
           ldaa AISCounter_ZInit          ; load a with memory contents (data is 02)
   L9268:  staa AISCounter_Z          ; store a into memory
XmitRequestedRamLocation:
           brclr *DRBSerialMode, #$%10000000, L92AD    ; branch if bit(s) clear
           ldaa CPU_SerialStatus    ; load a with memory contents
           bitA #0x0e          ;  -00001110-
           beq  L927A          ; branch if equal (zero)
           ldab CPU_SerialData    ; load b with memory contents
           bra  L92AD          ; branch

   L927A:  bita #0x20          ;  -00100000-
           beq  L92AD          ; branch if equal (zero)
           ldab CPU_SerialData    ; load b with memory contents
           cmpb #0xf2          ;  -11110010-
           bne  L928A          ; branch if not equal (not zero)
           bclr *BitFlags71, #$%00000001    ; clear bits
           bra  L92AA          ; branch

; 0xF6 test added to read higher RAM locations (6400 and above)...
; Send 0xF6 after entering high-speed mode and the ECU responds with 0xF6,
; then enter the low-byte. The high-byte (0x64) is automatic.
   L928A:  cmpb #0xf6          ;  -11110110-
           bne  L9293          ; branch if not equal (not zero)
           bset *BitFlags71, #$%00000001    ; set bits
           bra  L92AA          ; branch

   L9293:  cmpb #0xfe          ;  -11111110-
           bne  L929D          ; branch if not equal (not zero)
           bclr *DRBSerialMode, #$%10110000    ; clear bits
           bclr *BitFlags71, #$%00000001    ; clear bits
   L929D:  ldx  #0x0000         ; load index with value
           brclr *BitFlags71, #$%00000001, L92A7    ; branch if bit(s) clear
           ldx  #0x6400    ; load index with value
   L92A7:  abx                 ; add b to index
           ldab 0x00, X        ; load b with memory at index + value
   L92AA:  stab CPU_SerialData    ; store b into memory
   L92AD:  ldaa CPU_A2DResults1    ; load a with memory contents
           brset *BitFlags6b, #$%00000100, L92B8    ; branch if bit(s) set
           brclr *Counter_MainLoop, #$%00111111, L92C7    ; branch if bit(s) clear
   L92B8:  cmpa MapVoltsX      ; compare a with memory contents
           bcs  L92CA          ; branch if lower
           cmpa MapValueX      ; compare a with memory contents
           bls  L92CD          ; branch if lower or same
           staa MapValueX  
           bra  L92CD          ; branch

   L92C7:  staa MapValueX  
   L92CA:  staa MapVoltsX  
   L92CD:  sei                 ; disable interrupts
           ldaa #0x80          ; load a with value -10000000-
           oraa CPU_TimerInterruptMask1
           staa CPU_TimerInterruptMask1
           rti                 ; return from interrupt

VerifyOperationOfBatteryVoltage_MM:
           brset *BitFlags71, #$%00000100, L9342    ; branch if bit(s) set
           brset *b5d_IPL2, #$%00000100, L9342    ; branch if bit(s) set
           brset *b5d_IPL2, #$%00000001, L9342    ; branch if bit(s) set
           ldaa TargetBatteryVolts    ; load a with memory contents
           suba CPU_A2DResults2
           bcs  L9342          ; branch if lower
           cmpa BTVLMT_BatteryVoltsDiagLimitOverTarget    ; compare a with memory contents (data is 10)
           bcs  L9342          ; branch if lower
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa BTLRPM_LowBatteryVoltageAtThisRpm1500    ; compare a with memory contents (data is 2e)
           bcs  L9342          ; branch if lower
           ldaA #0x0f          ; load a with value -00001111-
           brclr *BitFlags71, #$%00000010, L92FD    ; branch if bit(s) clear
           clra                ; a = 0
   L92FD:  anda Counter_MainLoop    ; logical and a with memory contents
           bne  L9319          ; branch if not equal (not zero)
           ldaa BatVoltsDiagCounter    ; load a with memory contents
           inca                ; increment a
           beq  L930A          ; branch if equal (zero)
           staa BatVoltsDiagCounter
   L930A:  brset *BitFlags71, #$%00000010, L931A    ; branch if bit(s) set
           cmpa BTVCNT_BatteryVoltsDiagCounterMax    ; compare a with memory contents (data is 8e)
           bcs  L9319          ; branch if lower
           clr  BatVoltsDiagCounter    ; zero byte at memory location
           bset *BitFlags71, #$%00000010    ; set bits
   L9319:  rts                 ; return from subroutine

   L931A:  brset *BitFlags71, #$%00001000, L932A    ; branch if bit(s) set
           cmpa BTVCN2_BatteryVoltsDiagCounterMax2    ; compare a with memory contents (data is 7f)
           bcs  L9319          ; branch if lower
           clr  BatVoltsDiagCounter    ; zero byte at memory location
           bset *BitFlags71, #$%00001000    ; set bits
           rts                 ; return from subroutine

   L932A:  cmpa BTVCN3_BatteryVoltsDiagCounterMin    ; compare a with memory contents (data is 06)
           bcs  L9319          ; branch if lower
           clr  BatVoltsDiagCounter    ; zero byte at memory location
           bclr *BitFlags71, #$%00001000    ; clear bits
           ldd  #0x058a        ; load d (a&b) with value -00000101 10001010-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  L9319          ; branch if greater or equal
           bset *b5d_IPL2, #$%00000100    ; set bits
           bra  L9345          ; branch

   L9342:  clr  BatVoltsDiagCounter    ; zero byte at memory location
   L9345:  bclr *BitFlags71, #$%00001110    ; clear bits
           rts                 ; return from subroutine

HandleBaroReadRequirement_MM:
           brclr *BitFlags6e, #$%10000000, BaroRead_EngRunning    ; branch if bit(s) clear
           bset *PIA_Buffer1, #pia_Baro    ; set bits
           rts                 ; return from subroutine

BaroRead_EngRunning:
           ldab BitFlags68     ; load b with memory contents
           bmi  BaroRead_THROTTLE_PREVIOUSLY_NOTPRESSED    ; branch if minus(hi bit 1)
           ldaa Timer_BaroReadInterval    ; load a with memory contents
           tst  Counter_MainLoop
           bne  BaroRead_THROTTLE_PREVIOUSLY_NOTPRESSED    ; branch if not equal (not zero)
           inca                ; increment a
           beq  BaroRead_THROTTLE_PREVIOUSLY_NOTPRESSED    ; branch if equal (zero)
           staa Timer_BaroReadInterval    ; store a into memory
BaroRead_THROTTLE_PREVIOUSLY_NOTPRESSED:
           ldaa BitFlags66     ; load a with memory contents
           bpl  ReadBaroIfPossible    ; branch if plus (hi bit 0)
           bset *PIA_Buffer1, #pia_Baro    ; set bits
           clra                ; a = 0
           staa Timer_BaroReadRpmConditionsSatisfied    ; store a into memory
           andb #0x5f          ;  -01011111-
           stab BitFlags68     ; store b into memory
           bclr *BitFlags6e, #$%00001000    ; clear bits
           rts                 ; return from subroutine

ReadBaroIfPossible:
           tstb            
           bmi  THROTTLE_HASNTCHANGED_STILLNOTPRESSED    ; branch if minus(hi bit 1)
           ldx  EngineRpm_HB
           cpx  BRPMHI_BaroReadHighRPM6650    ;  (data is cfd0)
           bhi  L93CC          ; branch if higher
           cpx  BRPMLO_BaroReadLowRPM1800    ;  (data is 3840)
           bcs  L93CC          ; branch if lower
           ldaa Timer_BaroReadRpmConditionsSatisfied    ; load a with memory contents
           inca                ; increment a
           beq  L938E          ; branch if equal (zero)
           staa Timer_BaroReadRpmConditionsSatisfied    ; store a into memory
           cmpa BRDLAY_BaroReadDelayAfterThrottleClosed2sec    ; compare a with memory contents (data is b5)
           bcs  L93CC          ; branch if lower
   L938E:  ldaa Timer_BaroReadInterval    ; load a with memory contents
           cmpa BARTIM_BaroReadMinTimeBetweenReadings179sec    ; compare a with memory contents (data is 40)
           bcs  L93CC          ; branch if lower
           bitb #0x20          ;  -00100000-
           bne  L93CC          ; branch if not equal (not zero)
           bclr *PIA_Buffer1, #pia_Baro    ; clear bits
           ldab #0x80          ; load b with value -10000000-
           bra  L93B3          ; branch

THROTTLE_HASNTCHANGED_STILLNOTPRESSED:
           inc  Timer_BaroReadInterval
           bitb #0x20          ;  -00100000-
           bne  L93B7          ; branch if not equal (not zero)
           ldaa Timer_BaroReadInterval    ; load a with memory contents
           cmpa BROPTM_BaroReadDelayAfterSolenoidOpenTenthSec    ; compare a with memory contents (data is 09)
           bcs  L93CC          ; branch if lower
           ldab #0x20          ; load b with value -00100000-
           bset *BitFlags6e, #$%00001000    ; set bits
   L93B3:  orab BitFlags68 
           bra  L93C7          ; branch

   L93B7:  brset *BitFlags6e, #$%00001000, L93C9    ; branch if bit(s) set
           bset *PIA_Buffer1, #pia_Baro    ; set bits
           ldaa Timer_BaroReadInterval    ; load a with memory contents
           cmpa BRCLTM_BaroReadDelayAfterSolenoidClosedTenthSec    ; compare a with memory contents (data is 09)
           bcs  L93CC          ; branch if lower
           andb #0x7f          ;  -01111111-
   L93C7:  stab BitFlags68     ; store b into memory
   L93C9:  clra                ; a = 0
           staa Timer_BaroReadInterval    ; store a into memory
   L93CC:  rts                 ; return from subroutine

SaveBaroPressure:
           jsr  ConvertMAPVoltsToValue    ; call subroutine
           tab                 ; b = a
           cmpb BAROHI_BaroReadValidHighLimit    ; compare b with memory contents (data is 85)
           bcc  L93DB          ; branch if greater or equal
           cmpb BAROLO_BaroReadValidLowLimit    ; compare b with memory contents (data is 45)
           bcc  L93DE          ; branch if greater or equal
   L93DB:  ldab BARDFT_BaroReadDefaultValue    ; load b with memory contents (data is 7f)
   L93DE:  stab BaroPressure    ; store b into memory
           rts                 ; return from subroutine

ControlAsdRelay_MM:
           ldaa DRBPointer1    ; load a with memory contents
           cmpa #0x18          ; compare a with value -00011000-
           bne  CONTROL_AUTOSHUTDOWN_RELAY_ROUTINE1    ; branch if not equal (not zero)
           ldaa DRBSerialMode    ; load a with memory contents
           bita #0x30          ;  -00110000-
           bne  CONTROL_AUTOSHUTDOWN_RELAY_ROUTINE1    ; branch if not equal (not zero)
           ldaa TimerOverflowsBetweenCamPulses    ; load a with memory contents
           cmpa #0x50          ; compare a with value -01010000-
           bls  L9424          ; branch if lower or same
           brset *BitFlags71, #$%00100000, L9424    ; branch if bit(s) set
           ldaa DRBPointer2    ; load a with memory contents
           tab                 ; b = a
           andA #0x0f          ; AND a with value -00001111-
           pshb                ; push b onto stack
           lsrb                ; logical shift right b
           lsrb                ; logical shift right b
           lsrb                ; logical shift right b
           lsrb                ; logical shift right b
           comb
           andb #$%00001111
           cba
           pulb
           bne  L9427 ;#0x1f
           tst  Counter_MainLoop
           bne  L9417
           deca
           beq  L942A
           andb #$%11110000
           addb #$%00010000
           aba                 ; a=a+b
           staa DRBPointer2    ; store a into memory
   L9417:  ldaa #0xe1          ; load a with value -11100001-
           jsr  SerialOutput1a    ; call subroutine
           ldx  #0xfe00        ; load index with value
           bset *BitFlags6c, #$%00000100    ; set bits
           bra  L9454          ; branch

   L9424:  bclr *BitFlags71, #$%00100000    ; clear bits
   L9427:  jsr  SerialOutput1    ; call subroutine
   L942A:  clra                ; a = 0
           staa DRBPointer1    ; store a into memory
           staa DRBPointer2    ; store a into memory
CONTROL_AUTOSHUTDOWN_RELAY_ROUTINE1:
           ldx  #0x002d    ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           cmpa #0x8f          ; compare a with value -10001111-
           bcc  ControlAsdRelay_Over119Ftemp    ; branch if greater or equal
           ldx  #0x005b    ; load index with value
ControlAsdRelay_Over119Ftemp:
           ldaB #0x08          ; load b with value -00001000-
           ldaa BatteryVolts    ; load a with memory contents
           cmpa #0xb2          ; compare a with value -10110010-
           brset *BitFlags68, #$%00000100, L9450    ; branch if bit(s) set
           bcc  L9454          ; branch if greater or equal
           cpx  #0x005b    ;  -00000000 01011011-
           bne  L9454          ; branch if not equal (not zero)
           ldab #0x17          ; load b with value -00010111-
           bra  L9454          ; branch

   L9450:  bcs  L9454          ; branch if lower
           ldaB #0x05          ; load b with value -00000101-
   L9454:  ldaa CCDFlags1      ; load a with memory contents
           anda #0xef          ; AND a with value -11101111-
           cmpb Counter_TimerPastHalfwayBetweenCamPulses
           bhi  L9462          ; branch if higher
           cpx  KeyOnOrEngineRunningTime
           bhi  L9462          ; branch if higher
           oraa #0x10          ;  -00010000-
   L9462:  staa CCDFlags1      ; store a into memory
           brset *BitFlags6e, #$%10000000, L9471    ; branch if bit(s) set
           ldab KeyOnOrEngineRunningTime    ; load b with memory contents
           cmpb #0x04          ;  -00000100-
           bcs  L9471          ; branch if lower
           bset *BitFlags68, #$%00000100    ; set bits
   L9471:  rts                 ; return from subroutine

ControlAirConditioning_MM:
           clra                ; a = 0
           brset *BitFlags69, #$%00000100, L94AB    ; branch if bit(s) set
           ldaa Counter_AirCond    ; load a with memory contents
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x3f          ;  -00111111-
           bne  L9484          ; branch if not equal (not zero)
           cmpa #0x01          ; compare a with value -00000001-
           bls  L9484          ; branch if lower or same
           deca                ; decrement a
   L9484:  ldab TpsVolts       ; load b with memory contents
           brclr *CCDFlags1, #$%00000001, AIRCONDITIONING_CURRENTLY_OFF    ; branch if bit(s) clear
           addb #0x03          ;  -00000011-
AIRCONDITIONING_CURRENTLY_OFF:
           subb MINTHR_LowestSessionTPS    ; b = b-memory contents
           bls  L9495          ; branch if lower or same
           cmpb ACOUT_DeltaAboveMinThrottleToCutOutAc    ; compare b with memory contents (data is 8a)
           bhi  SHUTOFF_AIRCONDITIONING    ; branch if higher
   L9495:  ldx  EngineRpm_HB
           cpx  ACCRPM_DoNotAllowAcToEngageAboveThisRPM_4000    ;  (data is 7d00)
           bcc  L94F4          ; branch if greater or equal
           cpx  TargetIdleSpeedHB
           bcc  L94D1          ; branch if greater or equal
           cpx  ACLRPM_DisableAcBelowThisRPM_500    ;  (data is 0fa0)
           bhi  L94B0          ; branch if higher
SHUTOFF_AIRCONDITIONING:
           tsta                ; test a
           bne  L94AB          ; branch if not equal (not zero)
           ldaa ACCNTI_ACCounterInitial    ; load a with memory contents (data is 06)
   L94AB:  bset *CCDFlags1, #$%00000001    ; set bits
           bra  L94F4          ; branch

   L94B0:  brclr *BitFlags6c, #$%00000010, L94F4    ; branch if bit(s) clear
           brset *CCDFlags1, #$%00000001, L94F4    ; branch if bit(s) set
           cpx  #0x1f40        ;  -00011111 01000000-
           bcc  L94AB          ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x03          ;  -00000011-
           bne  L94F4          ; branch if not equal (not zero)
           ldab Counter_ACControl1    ; load b with memory contents
           incb            
           stab Counter_ACControl1    ; store b into memory
           cmpb #0x5d          ;  -01011101-
           bcs  L94F4          ; branch if lower
           bset *BitFlags6c, #$%00001000    ; set bits
           bra  L94F4          ; branch

   L94D1:  cmpa #0x01          ; compare a with value -00000001-
           bhi  L94AB          ; branch if higher
           clra                ; a = 0
           brclr *BitFlags6c, #$%00000010, L94F1    ; branch if bit(s) clear
           cpx  #0x1f40        ;  -00011111 01000000-
           bcc  L94AB          ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x03          ;  -00000011-
           bne  L94F1          ; branch if not equal (not zero)
           ldab Counter_ACControl1    ; load b with memory contents
           incb            
           stab Counter_ACControl1    ; store b into memory
           cmpb #0x5d          ;  -01011101-
           bcs  L94F1          ; branch if lower
           bset *BitFlags6c, #$%00001000    ; set bits
   L94F1:  bclr *CCDFlags1, #$%00000001    ; clear bits
   L94F4:  staa Counter_AirCond    ; store a into memory
           rts                 ; return from subroutine

;	.org	0x94f7
; BATVLT_BatteryVoltsTable:
; 	.byte	2						; number of points
; 	.byte	0x6e, 0xeb, 0xff, 0xac	; point 1
; 	.byte	0xab, 0xd7				; point 2

;        .org    0x950a
DetermineTargetBatteryVoltage_MM:
           ldaa AmbientAirTempVolts    ; load a with memory contents
           ldx  #BATVLT_BatteryVoltsTable    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp0          ; store a into memory
           ldab BodyComputerBatteryVoltsOutput    ; load b with memory contents
           addb #0xf8          ;  -11111000-
           bcs  L951F          ; branch if lower
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           bra  L952A          ; branch

   L951F:  cmpb #0x08          ;  -00001000-
           bhi  L952A          ; branch if higher
           mul                 ; multiply (d=a*b)
           adca Temp0      
           bcc  L952A          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   L952A:  staa TargetBatteryVolts    ; store a into memory
           rts                 ; return from subroutine

ControlFan_MM:
           brclr *BitFlags6e, #$%10000000, PreventRadSteaming    ; branch if bit(s) clear
           jmp  L95EC      

PreventRadSteaming:
           ldaa Timer_RadSteamingCountdown    ; load a with memory contents
           cmpa #0x01          ; compare a with value -00000001-
           beq  L956F          ; branch if equal (zero)
           bhi  L9554          ; branch if higher
           brclr *KeyOnOrEngineRunningTime, #$%11111111, L956F    ; branch if bit(s) clear
           ldaA #0x01          ; load a with value -00000001-
           ldab CoolantTemp    ; load b with memory contents
           cmpb #0xa6          ;  -10100110-
           bcc  L9550          ; branch if greater or equal
           ldab AmbientAirTempVolts    ; load b with memory contents
           cmpb #0x90          ;  -10010000-
           bcc  L9550          ; branch if greater or equal
           ldaa #0x41          ; load a with value -01000001-
   L9550:  staa Timer_RadSteamingCountdown    ; store a into memory
           bra  L956F          ; branch

   L9554:  ldaa CoolantTemp    ; load a with memory contents
           cmpa #0xd2          ; compare a with value -11010010-
           bcs  L956F          ; branch if lower
           ldaa Counter_MainLoop    ; load a with memory contents
           cmpa #0x09          ; compare a with value -00001001-
           bne  L9563          ; branch if not equal (not zero)
           dec  Timer_RadSteamingCountdown    ; decrement memory contents
   L9563:  clra                ; a = 0
           ldab PIA_Buffer1    ; load b with memory contents
           bitb #pia_Fan          ;  -10000000-
           bne  L956B          ; branch if not equal (not zero)
           inca                ; increment a
   L956B:  cmpa VehicleSpeed_HB    ; compare a with memory contents
           bcc  L95C6          ; branch if greater or equal
   L956F:  ldab PIA_Buffer1    ; load b with memory contents
           brset *b5c_IPL1, #$%00000010, L95C6    ; branch if bit(s) set
           ldx  #FANTMP1_FanTurnOnTempAbove45Mph    ; load index with value
           ldaa VehicleSpeed_HB    ; load a with memory contents
           cmpa #0x0b          ; compare a with value -00001011-
           bcc  Above44MPH     ; branch if greater or equal
           cmpa #0x09          ; compare a with value -00001001-
           bcs  Below36MPH     ; branch if lower
           brset *BitFlags68, #$%00001000, L9590    ; branch if bit(s) set
Below36MPH:
           inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
           bclr *BitFlags68, #$%00001000    ; clear bits
           bra  L9590          ; branch

Above44MPH:
           bset *BitFlags68, #$%00001000    ; set bits
   L9590:  ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 91)
           bita #0x80          ;  -10000000-
           beq  L959B          ; branch if equal (zero)
           brclr *BitFlags_36, #$%01000000, L95C6    ; branch if bit(s) clear
   L959B:  bitb #pia_Fan          ;  -10000000-
           bne  L95A0          ; branch if not equal (not zero)
           inx                 ; increment index (x=x+1)
   L95A0:  ldaa 0x00, X        ; load a with memory at index + value
           cmpa CoolantTemp    ; compare a with memory contents
           bcs  L95C6          ; branch if lower
           ldaa BaroPressure    ; load a with memory contents
           adda FANMAP_FanTurnsOnWhenMapAboveBaroPlusThis    ;  (data is ff)
           bcs  L95EC          ; branch if lower
           bitb #pia_Fan          ;  -10000000-
           beq  CheckFor_FANMAP    ; branch if equal (zero)
           adda #0x03          ;  -00000011-
           bcs  L95EC          ; branch if lower
CheckFor_FANMAP:
           cmpa MapValue       ; compare a with memory contents
           bcc  L95EC          ; branch if greater or equal
           ldaa AmbientAirTempVolts    ; load a with memory contents
           bitb #pia_Fan          ;  -10000000-
           bne  L95C1          ; branch if not equal (not zero)
           inca                ; increment a
           inca                ; increment a
   L95C1:  cmpa FANBAT_FanTurnsOnWhenBatteryTempAboveThis    ; compare a with memory contents (data is 1b)
           bcs  L95EC          ; branch if lower
   L95C6:  brset *BitFlags68, #$%10000000, L95FE    ; branch if bit(s) set
           brclr *PIA_Buffer1, #$%10000000, L95FE    ; branch if bit(s) clear
           andb #~pia_Fan          ;  -01111111-
           ldaa #0x5b          ; load a with value -01011011-
           staa Timer_MinimumFanRun    ; store a into memory
           ldaa AISFAN_AisKickWhenFanTurnsOnClosedThrottle    ; load a with memory contents (data is 08)
           beq  L95FC          ; branch if equal (zero)
           adda DesiredNewAisPosition
           bcs  L95E2          ; branch if lower
           cmpa AISHLM_AisHighLimitMaxOpenSteps    ; compare a with memory contents (data is a0)
           bls  L95E5          ; branch if lower or same
   L95E2:  ldaa AISHLM_AisHighLimitMaxOpenSteps    ; load a with memory contents (data is a0)
   L95E5:  staa DesiredNewAisPosition    ; store a into memory
           clra                ; a = 0
           staa Timer_AisChanges    ; store a into memory
           bra  L95FC          ; branch

   L95EC:  ldaa Timer_MinimumFanRun    ; load a with memory contents
           beq  L95F4          ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_MinimumFanRun    ; store a into memory
           rts                 ; return from subroutine

   L95F4:  ldab PIA_Buffer1    ; load b with memory contents
           orab #pia_Fan          ;  -10000000-
           brset *BitFlags68, #$%10000000, L95FE    ; branch if bit(s) set
   L95FC:  stab PIA_Buffer1    ; store b into memory
   L95FE:  rts                 ; return from subroutine

CalculateAisPosition_MM:
           ldaa BitFlags6e     ; load a with memory contents
           oraa BitFlags66     ; OR a with memory contents
           bmi  L960D          ; branch if minus(hi bit 1)
           ldaa b5c_IPL1       ; load a with memory contents
           anda #0xa0          ; AND a with value -10100000-
           oraa TimerOverflowsBetweenCamPulses    ; OR a with memory contents
           beq  L960E          ; branch if equal (zero)
   L960D:  rts                 ; return from subroutine

   L960E:  ldaa Timer_DacalCountdown    ; load a with memory contents
           lsra            
           lsra            
           adda DANOM_Base_nominalCal    ;  (data is 05)
           bcc  L9619          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   L9619:  ldab DistributorFallingEdgePulsewidth_HB    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           asld                ; shift left (d=d*2)
           bcs  L9622          ; branch if lower
           asld                ; shift left (d=d*2)
           bcc  L9624          ; branch if greater or equal
   L9622:  ldaa #0xff          ; load a with value -11111111-
   L9624:  staa TempX          ; store a into memory
           ldx  #TIMEDC_AISDecelBaseAirflowCurveOffset    ; load index with value
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp0          ; store a into memory
           ldx  #TEMPDC_AISDecel_FromTemp    ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           adda Temp0      
           bcs  L9645          ; branch if lower
           brset *CCDFlags1, #$%00000001, L9647    ; branch if bit(s) set
           adda DAACF_ACFactorDeltaFromBase    ;  (data is 12)
           bcc  L9647          ; branch if greater or equal
   L9645:  ldaa #0xff          ; load a with value -11111111-
   L9647:  ldab DistributorFallingEdgePulsewidth_HB    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           asld                ; shift left (d=d*2)
           bcs  L9650          ; branch if lower
           asld                ; shift left (d=d*2)
           bcc  L9652          ; branch if greater or equal
   L9650:  ldaa #0xff          ; load a with value -11111111-
   L9652:  staa Temp0          ; store a into memory
           ldx  #MAPFLR_AISAdditionToControlMap    ; load index with value
           ldaa EngineRpm_HB    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp1          ; store a into memory
           ldx  #MPTEMP_TempTermForMapOffset_FromTemp    ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp1          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           adca Temp0      
           bcs  L967B          ; branch if lower
           staa Temp0          ; store a into memory
           ldx  #BARFLR_OffsetCorrectionTo_MAPFLR_FromBaro    ; load index with value
           ldaa BaroPressure    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           adda Temp0      
           bcc  L967D          ; branch if greater or equal
   L967B:  ldaa #0xff          ; load a with value -11111111-
   L967D:  adda TempX      
           bcc  L9683          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   L9683:  staa MAPOffsetForCylTrim
           brclr *BitFlags67, #$%01000000, L968C    ; branch if bit(s) clear
           staa TempX          ; store a into memory
   L968C:  ldaa TempX          ; load a with memory contents
           ldab Timer_CountdownFromStartRunForAisFeedback    ; load b with memory contents
           bne  L970D          ; branch if not equal (not zero)
           brset *BitFlags67, #$%00001000, L970D    ; branch if bit(s) set
           brset *BitFlags_36, #$%10000000, L970D    ; branch if bit(s) set
           brset *BitFlags67, #$%01000000, L970E    ; branch if bit(s) set
           ldab CONFIG_ConfigurationFlags    ; load b with memory contents (data is 91)
           bitb #0x20          ;  -00100000-
           beq  L96A9          ; branch if equal (zero)
           brclr *StartupSwitchMirror1, #sw1_PNswitch, L970D    ; branch if bit(s) clear
   L96A9:  ldab KeyOnOrEngineRunningTime    ; load b with memory contents
           cmpb DCALTM_DacalInhibitTimeAfterStartup    ; compare b with memory contents (data is 15)
           bcs  L970D          ; branch if lower
           brclr *CCDFlags1, #$%00000001, L970D    ; branch if bit(s) clear
           ldab CoolantTemp    ; load b with memory contents
           cmpb DATHOT_EngineTempToStartCalibratingDacal    ; compare b with memory contents (data is ca)
           bls  L970D          ; branch if lower or same
           ldab Counter_MainLoop    ; load b with memory contents
           bitb DCALRT_DacalUpdateRate01_03_07_0f_1f_3f_7f_ff    ;  (data is 3f)
           bne  L96DD          ; branch if not equal (not zero)
           ldab TargetIdleSpeedHB    ; load b with memory contents
           subb EngineRpm_HB    ; b = b-memory contents
           bcc  L96C9          ; branch if greater or equal
           negb            
   L96C9:  cmpb DADRPM_DeltaRpmFromIdleSpeedForDacalUpdate    ; compare b with memory contents (data is 04)
           bhi  L96DD          ; branch if higher
           ldab Timer_DacalCountdown    ; load b with memory contents
           cmpa MapValue       ; compare a with memory contents
           bhi  L96D7          ; branch if higher
           incb            
           bne  L96DB          ; branch if not equal (not zero)
   L96D7:  tstb            
           beq  L96DD          ; branch if equal (zero)
           decb            
   L96DB:  stab Timer_DacalCountdown    ; store b into memory
   L96DD:  ldab Counter_MainLoop    ; load b with memory contents
           bitb CALRAT_AisAdjustRate    ;  (data is 07)
           bne  L970D          ; branch if not equal (not zero)
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  L96EF          ; branch if greater or equal
           coma            
           comb            
           addd #0x0001         ;  -00000000 00000001-
   L96EF:  asld                ; shift left (d=d*2)
           bcs  L970D          ; branch if lower
           asld                ; shift left (d=d*2)
           bcs  L970D          ; branch if lower
           cmpa #0x0a          ; compare a with value -00001010-
           bcc  L970D          ; branch if greater or equal
           ldaa DesiredNewAisPosition    ; load a with memory contents
           cmpa CurrentAisPosition    ; compare a with memory contents
           bne  L970D          ; branch if not equal (not zero)
           cmpa CALPOS_PositionAisMotorIsAtIdle    ; compare a with memory contents (data is 1a)
           beq  L970D          ; branch if equal (zero)
           bhi  L9708          ; branch if higher
           inca                ; increment a
           inca                ; increment a
   L9708:  deca                ; decrement a
           staa DesiredNewAisPosition    ; store a into memory
           staa CurrentAisPosition    ; store a into memory
   L970D:  rts                 ; return from subroutine

   L970E:  ldab Timer_AisChanges    ; load b with memory contents
           cmpb DCLRFQ_TimeBetweenAisPulsesForDecelAis    ; compare b with memory contents (data is 14)
           bcs  L970D          ; branch if lower
           cmpa DCLMIN_MinLimitOnDecelAisControlledMap    ; compare a with memory contents (data is 01)
           bcc  L971D          ; branch if greater or equal
           ldaa DCLMIN_MinLimitOnDecelAisControlledMap    ; load a with memory contents (data is 01)
   L971D:  cmpa DCLMN2_NoAisControlIfMapAndControlMapBelowThis    ; compare a with memory contents (data is 15)
           bcc  L9729          ; branch if greater or equal
           ldab MapValue       ; load b with memory contents
           cmpb DCLMN2_NoAisControlIfMapAndControlMapBelowThis    ; compare b with memory contents (data is 15)
           bcs  L970D          ; branch if lower
   L9729:  ldx  #DAISOP_DecelAisOpenStepsFromNeg_FromDeltaMap    ; load index with value
           suba MapValue   
           bcc  L9734          ; branch if greater or equal
           nega                ; negate a (set high bit)
           ldx  #DAISCL_DecelAisOpenStepsFromPos_FromDeltaMap    ; load index with value
   L9734:  jsr  Lookup4ByteTable    ; call subroutine
           jsr  StoreAndLimitDesiredAisPosition    ; call subroutine
           cmpa CurrentAisPosition    ; compare a with memory contents
           beq  L970D          ; branch if equal (zero)
           clra                ; a = 0
           staa Timer_AisChanges    ; store a into memory
           rts                 ; return from subroutine

KickUpAisBy2DuringDecel_MM:
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x7f          ;  -01111111-
           bne  L9763          ; branch if not equal (not zero)
           brset *BitFlags67, #$%01000000, L9763    ; branch if bit(s) set
           brset *b5c_IPL1, #$%10000000, L9763    ; branch if bit(s) set
           brset *b5c_IPL1, #$%00100000, L9763    ; branch if bit(s) set
           ldaa DesiredNewAisPosition    ; load a with memory contents
           oraa CurrentAisPosition    ; OR a with memory contents
           bne  L9763          ; branch if not equal (not zero)
           adda #0x02          ;  -00000010-
           staa DesiredNewAisPosition    ; store a into memory
           staa CurrentAisPosition    ; store a into memory
           bset *BitFlags68, #$%00010000    ; set bits
   L9763:  rts                 ; return from subroutine

CalculateTargetIdleSpeedAndAisPosition_MM:
           brset *BitFlags_36, #$%00001000, L97B1    ; branch if bit(s) set
           brset *BitFlags6e, #$%10000000, L97A1    ; branch if bit(s) set
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa DCLMER_MinTimeEngineRunningForDecelFuelShutoff    ; compare a with memory contents (data is 02)
           bls  L97A1          ; branch if lower or same
           ldaa CoolantTemp    ; load a with memory contents
           cmpa DCLMCT_MinCoolantTempForDecelFuelShutoff    ; compare a with memory contents (data is d2)
           bls  L97A1          ; branch if lower or same
           brset *BitFlags66, #$%10000000, L97A1    ; branch if bit(s) set
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           cmpa MPHREF_SwitchPointForDecelIdleAisControl    ; compare a with memory contents (data is 07)
           bcc  L97A1          ; branch if greater or equal
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  L9792          ; branch if greater or equal
           clra                ; a = 0
   L9792:  brclr *BitFlags6b, #$%00000010, L97A6    ; branch if bit(s) clear
           cmpa DCLRPL_EngineRPMLimitForDecelFuelShutoffLow    ; compare a with memory contents (data is 0f)
           bhi  L97AB          ; branch if higher
           ldaa DCAISI_AISIncrementWhenUsingDecelFuelShut    ; load a with memory contents (data is 00)
           jsr  ClearAisTimer    ; call subroutine
   L97A1:  bclr *BitFlags6b, #$%00000010    ; clear bits
           bra  L97B1          ; branch

   L97A6:  cmpa DCLRPH_EngineRPMLimitForDecelFuelShutoffHigh    ; compare a with memory contents (data is 11)
           bls  L97A1          ; branch if lower or same
   L97AB:  bset *BitFlags6b, #$%00000010    ; set bits
           clr  Timer_CountdownFromStartRunForAisFeedback    ; zero byte at memory location
   L97B1:  ldaa BaroPressure    ; load a with memory contents
           ldx  #BARAIS_AISBaroCompensation    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp1          ; store a into memory
           brclr *BitFlags_36, #$%00000100, L97C2    ; branch if bit(s) clear
           jmp  L984A      

   L97C2:  ldx  #AISCLD_IdleSpeedDrive_FromTemp    ; load index with value
           brset *BitFlags_36, #$%00001000, L97FB    ; branch if bit(s) set
           ldaa DRBPointer1    ; load a with memory contents
           cmpa #0x19          ; compare a with value -00011001-
           beq  L97DA          ; branch if equal (zero)
           brclr *TargetIdleSpeedLB, #$%00111111, L97E7    ; branch if bit(s) clear
           ldd  TargetIdleSpeedHB    ; load d (a&b) with memory contents
           subd #0x0001         ;  -00000000 00000001-
           bra  L9848          ; branch

   L97DA:  brset *DRBSerialMode, #$%00100000, L984A    ; branch if bit(s) set
           clr  DRBPointer1    ; zero byte at memory location
           ldaa DRBPointer2    ; load a with memory contents
           ldab #0xfc          ; load b with value -11111100-
           bra  L9846          ; branch

   L97E7:  ldaa IDLDEF_TargetIdleSpeedDefault    ; load a with memory contents (data is 7d)
           brset *b5c_IPL1, #$%00000010, L9845    ; branch if bit(s) set
           brset *BitFlags6c, #$%00100000, L9845    ; branch if bit(s) set
           ldaa #0x30          ; load a with value -00110000-
           brset *BitFlags6c, #$%00010000, L9845    ; branch if bit(s) set
           ldx  #AISPN_IdleSpeedParkNeutral_FromTemp    ; load index with value
   L97FB:  ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp0          ; store a into memory
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           ldx  #TIMED2_AISDecelBaseAirflowCurveOffset2    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           adda Temp0      
           bcc  L9810          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   L9810:  brclr *BitFlags67, #$%00001000, L982C    ; branch if bit(s) clear
           ldab Counter_MainLoop    ; load b with memory contents
           andb DECAIS_RollingAisUpdateRate_01_03_07_0f_1f_3f_7f_ff    ;  (data is 7f)
           bne  L984A          ; branch if not equal (not zero)
           staa Temp0          ; store a into memory
           ldd  TargetIdleSpeedHB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           suba ISPDCY_RollingAisDecay    ;  (data is 04)
           bcs  L982A          ; branch if lower
           cmpa Temp0          ; compare a with memory contents
           bcc  L982C          ; branch if greater or equal
   L982A:  ldaa Temp0          ; load a with memory contents
   L982C:  brclr *BitFlags_36, #$%00000010, L9845    ; branch if bit(s) clear
           brset *BitFlags6e, #$%10000000, L9845    ; branch if bit(s) set
           ldx  KeyOnOrEngineRunningTime
           cpx  #0x0744        ;  -00000111 01000100-
           bls  L9845          ; branch if lower or same
           brset *BitFlags68, #$%01000000, L9845    ; branch if bit(s) set
           cmpa #0x77          ; compare a with value -01110111-
           bls  L9845          ; branch if lower or same
           ldaa #0x77          ; load a with value -01110111-
   L9845:  clrb                ; b = 0
   L9846:  lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
   L9848:  stD *TargetIdleSpeedHB    ; store D to RAM
   L984A:  ldaa DRBPointer1    ; load a with memory contents
           cmpa #0x13          ; compare a with value -00010011-
           bne  L985B          ; branch if not equal (not zero)
           ldaa ATMOffset      ; load a with memory contents
           cmpa #0x07          ; compare a with value -00000111-
           beq  L985A          ; branch if equal (zero)
           cmpa #0x14          ; compare a with value -00010100-
           bne  L985B          ; branch if not equal (not zero)
   L985A:  rts                 ; return from subroutine

   L985B:  brset *BitFlags_36, #$%00010000, L9875    ; branch if bit(s) set
           brclr *BitFlags6e, #$%10000000, L9870    ; branch if bit(s) clear
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa RPMTHS_RPMThresholdForIdleControl    ; compare a with memory contents (data is 10)
           bcc  L9870          ; branch if greater or equal
           ldaa RPMDEF_RPMDefaultForIdleControl    ; load a with memory contents (data is a0)
           jmp  L9B65      

   L9870:  bset *BitFlags_36, #$%00010000    ; set bits
           bra  L9888          ; branch

   L9875:  ldab BitFlags_36    ; load b with memory contents
           orab BitFlags6e 
           bpl  L9899          ; branch if plus (hi bit 0)
           ldaa DesiredNewAisPosition    ; load a with memory contents
           cmpa CurrentAisPosition    ; compare a with memory contents
           bne  L9888          ; branch if not equal (not zero)
           brset *BitFlags_AIS, #$%01000000, L9888    ; branch if bit(s) set
           bclr *BitFlags_36, #$%10000000    ; clear bits
   L9888:  bset *BitFlags_36, #$%01000000    ; set bits
           bset *BitFlags69, #$%00000100    ; set bits
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #AISTRT_AisStartupPosition_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           jmp  L9B65

   L9899:  brclr *b5c_IPL1, #$%10100000, HandleAcCutout    ; branch if bit(s) clear
           ldaa #0x20          ; load a with value -00100000-
           staa DesiredNewAisPosition    ; store a into memory
           brclr *BitFlags68, #$%01000000, L98A9    ; branch if bit(s) clear
           bset *BitFlags69, #$%00000100    ; set bits
           rts                 ; return from subroutine

   L98A9:  bclr *BitFlags69, #$%00000100    ; clear bits
           rts                 ; return from subroutine

HandleAcCutout:
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa ACCTIM_AcDelayFromStartRunTransfer    ; compare a with memory contents (data is 04)
           bcs  L9926          ; branch if lower
           ldaa Timer_AcCutout    ; load a with memory contents
           bne  L98E2          ; branch if not equal (not zero)
           ldaa CoolantTemp    ; load a with memory contents
           cmpa ACDTMP_PartThrottleAcCutoutDisableTemp    ; compare a with memory contents (data is ff)
           bcs  L9908          ; branch if lower
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bcs  L9908          ; branch if lower
           cmpa ACDTHR_PartThrottleAcCutoutDisableThrottle    ; compare a with memory contents (data is ff)
           bcs  L9908          ; branch if lower
           ldx  VehicleSpeed_HB
           cpx  ACDSPD_PartThrottleAcCutoutDisableSpeed    ;  (data is 0000)
           bcc  L9908          ; branch if greater or equal
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb ACERPM_AllowAcClutchAboveThisRpm    ; compare b with memory contents (data is 44)
           bcc  L9908          ; branch if greater or equal
           inc  Timer_AcCutout
           brset *BitFlags_36, #$%01000000, L9926    ; branch if bit(s) set
           jmp  L99C2      

   L98E2:  ldx  VehicleSpeed_HB
           cpx  ACESPD_AllowAcClutchAboveThisSpeed    ;  (data is 0500)
           bcc  L9905          ; branch if greater or equal
           ldab EngineRpm_HB    ; load b with memory contents
           subb #0x04          ;  -00000100-
           bcc  L98F0          ; branch if greater or equal
           clrb                ; b = 0
   L98F0:  cmpb ACERPM_AllowAcClutchAboveThisRpm    ; compare b with memory contents (data is 44)
           bcc  L9905          ; branch if greater or equal
           cmpa ACETIM_PartThrottleAcCutoutMaxTimeActive    ; compare a with memory contents (data is 08)
           bcc  L9905          ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x3f          ;  -00111111-
           bne  L9926          ; branch if not equal (not zero)
           inca                ; increment a
           staa Timer_AcCutout    ; store a into memory
           bra  L9926          ; branch

   L9905:  clra                ; a = 0
           staa Timer_AcCutout    ; store a into memory
   L9908:  ldab BitFlags_36    ; load b with memory contents
           eorb BitFlags68 
           andb #0x40          ;  -01000000-
           beq  L9929          ; branch if equal (zero)
           eorb BitFlags_36
           bitb #0x40          ;  -01000000-
           beq  L9919          ; branch if equal (zero)
           jmp  L99C2      

   L9919:  ldaa Pulsewidth_PartThrottleEnrichment_HB    ; load a with memory contents
           bne  L9921          ; branch if not equal (not zero)
           ldaa Pulsewidth_PartThrottleEnrichment_LB    ; load a with memory contents
           beq  L998F          ; branch if equal (zero)
   L9921:  ldaa ACAETH_DisallowAcClutchEngageForThisTimeAfterAccelEnrich    ; load a with memory contents (data is d6)
           staa Timer_AcClutchEngageRestrictionTimer    ; store a into memory
   L9926:  jmp  L9A07      

   L9929:  stab Timer_AcClutchEngageRestrictionTimer    ; store b into memory
           brset *BitFlags_36, #$%01000000, L994E    ; branch if bit(s) set
           ldaa Timer_AisOrO2Sensor    ; load a with memory contents
           bne  L9936          ; branch if not equal (not zero)
   L9933:  jmp  L99FF      

   L9936:  clrb                ; b = 0
           stab Timer_AisChanges    ; store b into memory
           deca                ; decrement a
           staa Timer_AisOrO2Sensor    ; store a into memory
           bne  L9926          ; branch if not equal (not zero)
           brset *BitFlags66, #$%10000000, L9933    ; branch if bit(s) set
           ldaa AC2KCK_AcClutchKickOpenAfterAcEnabled    ; load a with memory contents (data is 00)
           jsr  MultiplyTempvar1ByA_Pos    ; call subroutine
           jsr  StoreAndLimitDesiredAisPosition    ; call subroutine
           jmp  L99FF      

   L994E:  ldaa Timer_AisOrO2Sensor    ; load a with memory contents
           beq  L9926          ; branch if equal (zero)
           clrb                ; b = 0
           stab Timer_AisChanges    ; store b into memory
           deca                ; decrement a
           staa Timer_AisOrO2Sensor    ; store a into memory
           bne  L9933          ; branch if not equal (not zero)
           brset *BitFlags66, #$%10000000, L9977    ; branch if bit(s) set
           ldaa MapValue       ; load a with memory contents
           cmpa DCLMN2_NoAisControlIfMapAndControlMapBelowThis    ; compare a with memory contents (data is 15)
           bls  L996A          ; branch if lower or same
           ldaa AC3KCK_AcClutchKickOpenAfterAcEnabled2    ; load a with memory contents (data is 00)
           bra  L996E          ; branch

   L996A:  ldaa AC2KCK_AcClutchKickOpenAfterAcEnabled    ; load a with memory contents (data is 00)
           nega                ; negate a (set high bit)
   L996E:  jsr  MultiplyTempvar1ByA_Neg    ; call subroutine
           jsr  StoreAndLimitDesiredAisPosition    ; call subroutine
           jmp  L9A07      

   L9977:  ldx  #ACCTBL_ACOffIdleDelta_FromSpeed    ; load index with value
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    ; call subroutine
           ldab OFFPER2_AisInstantlyClosesWhenAcDisengages2    ; load b with memory contents (data is 80)
           mul                 ; multiply (d=a*b)
           jsr  MultiplyTempvar1ByA_Pos    ; call subroutine
           nega                ; negate a (set high bit)
           jsr  L9BD7          ; call subroutine
           bra  L9A07          ; branch

   L998F:  ldaa Timer_AcClutchEngageRestrictionTimer    ; load a with memory contents
           beq  L9998          ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_AcClutchEngageRestrictionTimer    ; store a into memory
           bne  L9A07          ; branch if not equal (not zero)
   L9998:  stab BitFlags_36    ; store b into memory
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           ldab ACTIME_TimeBeforeAcEnabledAndFullDeltaUsed    ; load b with memory contents (data is 16)
           cmpa MPHREF_SwitchPointForDecelIdleAisControl    ; compare a with memory contents (data is 07)
           bhi  L99B1          ; branch if higher
           brset *BitFlags66, #$%10000000, L99B1    ; branch if bit(s) set
           ldab ACTDEF_TimeBeforeAcEnabledAndFullDeltaUsed_Default    ; load b with memory contents (data is 16)
   L99B1:  stab Timer_AisOrO2Sensor    ; store b into memory
           brset *BitFlags66, #$%10000000, L9A04    ; branch if bit(s) set
           ldaa ACOFFK_ClosedThrottleAcOffKick    ; load a with memory contents (data is 10)
           jsr  MultiplyTempvar1ByA_Pos    ; call subroutine
           jsr  ClearAisTimer    ; call subroutine
           bra  L9A07          ; branch

   L99C2:  bset *BitFlags_36, #$%01000000    ; set bits
           ldaa ACTIM2_TimeBeforeAcEnabledAndFullDeltaUsed2    ; load a with memory contents (data is 16)
           staa Timer_AisOrO2Sensor    ; store a into memory
           brset *BitFlags66, #$%10000000, L99E6    ; branch if bit(s) set
           ldaa MapValue       ; load a with memory contents
           cmpa DCLMN2_NoAisControlIfMapAndControlMapBelowThis    ; compare a with memory contents (data is 15)
           bls  L99DA          ; branch if lower or same
           ldaa AC4KCK_AcClutchKickOpenBeforeAcEnabled2    ; load a with memory contents (data is f2)
           bra  L99DE          ; branch

   L99DA:  ldaa ACOFFK_ClosedThrottleAcOffKick    ; load a with memory contents (data is 10)
           nega                ; negate a (set high bit)
   L99DE:  jsr  MultiplyTempvar1ByA_Neg    ; call subroutine
           jsr  ClearAisTimer    ; call subroutine
           bra  L99FF          ; branch

   L99E6:  ldx  #ACCTBL_ACOffIdleDelta_FromSpeed    ; load index with value
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    ; call subroutine
           ldab OFFPER_AisInstantlyClosesWhenAcDisengages    ; load b with memory contents (data is 80)
           mul                 ; multiply (d=a*b)
           jsr  MultiplyTempvar1ByA_Pos    ; call subroutine
           nega                ; negate a (set high bit)
           jsr  L9BD7          ; call subroutine
           clra                ; a = 0
           staa Timer_AisChanges    ; store a into memory
   L99FF:  bclr *BitFlags69, #$%00000100    ; clear bits
           bra  L9A0A          ; branch

   L9A04:  clra                ; a = 0
           staa Timer_AisChanges    ; store a into memory
   L9A07:  bset *BitFlags69, #$%00000100    ; set bits
   L9A0A:  brclr *BitFlags66, #$%10000000, L9A23    ; branch if bit(s) clear
           bclr *BitFlags_36, #$%00000100    ; clear bits
           brclr *StartupSwitchMirror1, #sw1_Brake, L9A27    ; branch if bit(s) clear
           ldx  #BRKRPM_BrakeOverrideForAis_FromDeltaThrottle    ; load index with value
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           jsr  Lookup4ByteTable    ; call subroutine
           cmpb EngineRpm_HB
           bcc  L9A27          ; branch if greater or equal
   L9A23:  brclr *BitFlags69, #$%00100000, L9A2A    ; branch if bit(s) clear
   L9A27:  jmp  L9AEC

   L9A2A:  brclr *BitFlags67, #$%01000000, L9A2F    ; branch if bit(s) clear
           rts                 ; return from subroutine

   L9A2F:  ldaa DesiredNewAisPosition    ; load a with memory contents
           cmpa #0x04          ; compare a with value -00000100-
           bcs  L9A38          ; branch if lower
           bclr *BitFlags68, #$%00010000    ; clear bits
   L9A38:  brclr *BitFlags_36, #$%00000100, L9A6D    ; branch if bit(s) clear
           brclr *BitFlags_36, #$%00001000, L9A49    ; branch if bit(s) clear
           ldx  #PNDLTP_DeltaRpmChangeToUse_DRPNK_or_PNDRK    ; load index with value
           ldd  TargetIdleSpeedHB    ; load d (a&b) with memory contents
           subd EngineRpm_HB    ; d = d - memory contents
           bra  L9A50          ; branch

   L9A49:  ldx  #PNDLTN_DeltaRpmChangeToUse_DRPNK_or_PNDRK    ; load index with value
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
   L9A50:  bcs  L9A6D          ; branch if lower
           subd 0x00, X    
           bcs  L9A6D          ; branch if lower
           ldaa CoolantTemp    ; load a with memory contents
           inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
           jsr  Lookup4ByteTable    ; call subroutine
           bmi  L9A64          ; branch if minus(hi bit 1)
           jsr  MultiplyTempvar1ByA_Pos    ; call subroutine
           bra  L9A67          ; branch

   L9A64:  jsr  MultiplyTempvar1ByA_Neg    ; call subroutine
   L9A67:  jsr  ClearAisTimer    ; call subroutine
           bclr *BitFlags_36, #$%00000100    ; clear bits
   L9A6D:  ldaa Timer_CountdownFromStartRunForAisFeedback    ; load a with memory contents
           bne  L9AEB          ; branch if not equal (not zero)
           ldab AISFRQ_AisPeriodForRpmFeedback11ms    ; load b with memory contents (data is 82)
           cmpb Timer_AisChanges
           bcc  L9AAB          ; branch if greater or equal
           ldx  #FWDAIS_ForwardAisSteps_NoSlope    ; load index with value
           ldd  TargetIdleSpeedHB    ; load d (a&b) with memory contents
           subd EngineRpm_HB    ; d = d - memory contents
           bcc  L9A86          ; branch if greater or equal
           ldx  #REVAIS_ReverseAisSteps_NoSlope    ; load index with value
           coma            
           comb            
   L9A86:  lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           brset *BitFlags_36, #$%00001000, L9A8D    ; branch if bit(s) set
           lsrd                ; shift right (d=d/2)
   L9A8D:  tsta                ; test a
           beq  L9A92          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   L9A92:  tba                 ; a = b
           cmpa 0x01, X        ; compare a with memory at index + value
           bcs  L9AAB          ; branch if lower
           ldab 0x00, X        ; load b with memory at index + value
           beq  L9AAB          ; branch if equal (zero)
   L9A9B:  inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
           decb            
           beq  L9AA4          ; branch if equal (zero)
           cmpa 0x01, X        ; compare a with memory at index + value
           bcc  L9A9B          ; branch if greater or equal
   L9AA4:  ldaa 0x00, X        ; load a with memory at index + value
           beq  L9AAB          ; branch if equal (zero)
           jsr  ClearAisTimer    ; call subroutine
   L9AAB:  brclr *BitFlags67, #$%00001000, L9AEB    ; branch if bit(s) clear
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #CLDPOS_AisColdPosition_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           brset *BitFlags68, #$%00010000, L9AC0    ; branch if bit(s) set
           adda CALPOS_PositionAisMotorIsAtIdle    ;  (data is 1a)
           bcs  L9ACE          ; branch if lower
   L9AC0:  brset *BitFlags_36, #$%01000000, L9AD0    ; branch if bit(s) set
           adda ACOFFK_ClosedThrottleAcOffKick    ;  (data is 10)
           bcs  L9ACE          ; branch if lower
           adda AC2KCK_AcClutchKickOpenAfterAcEnabled    ;  (data is 00)
           bcc  L9AD0          ; branch if greater or equal
   L9ACE:  ldaa #0xff          ; load a with value -11111111-
   L9AD0:  staa Temp0          ; store a into memory
           adda AISLMH_RollingAisHighLimit    ;  (data is 1a)
           bcs  L9ADB          ; branch if lower
           cmpa DesiredNewAisPosition    ; compare a with memory contents
           bcs  L9AE6          ; branch if lower
   L9ADB:  ldaa Temp0          ; load a with memory contents
           suba AISLML_RollingAisLowLimit    ;  (data is 06)
           bcs  L9AEB          ; branch if lower
           cmpa DesiredNewAisPosition    ; compare a with memory contents
           bcs  L9AEB          ; branch if lower
   L9AE6:  jsr  MultiplyTempvar1ByA_Unsign    ; call subroutine
           staa DesiredNewAisPosition    ; store a into memory
   L9AEB:  rts                 ; return from subroutine

   L9AEC:  ldaa CoolantTemp    ; load a with memory contents
           ldx  #CLDPOS_AisColdPosition_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp0          ; store a into memory
           ldx  #RPMPOS_AisPosition_FromRpm    ; load index with value
           ldaa EngineRpm_HB    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           cmpa Temp0          ; compare a with memory contents
           bcs  L9B04          ; branch if lower
           staa Temp0          ; store a into memory
   L9B04:  ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bcc  L9B0B          ; branch if greater or equal
           clra                ; a = 0
   L9B0B:  ldx  #THRPOS_AisPosition_FromThrottle    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           cmpa Temp0          ; compare a with memory contents
           bcc  L9B17          ; branch if greater or equal
           ldaa Temp0          ; load a with memory contents
   L9B17:  brset *BitFlags_36, #$%01000000, L9B56    ; branch if bit(s) set
           staa Temp4          ; store a into memory
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           ldab ACPOS_ACPositionWhenTempToCold    ; load b with memory contents (data is 16)
           cmpa MPHREF_SwitchPointForDecelIdleAisControl    ; compare a with memory contents (data is 07)
           bhi  L9B30          ; branch if higher
           ldab ACPOS2_ACPositionWhenTempToCold2    ; load b with memory contents (data is 18)
   L9B30:  brset *BitFlags69, #$%00100000, L9B51    ; branch if bit(s) set
           ldaa CoolantTemp    ; load a with memory contents
           cmpa ACTMP_Use_ACCTBL_WhenTempAboveThisElseUse_ACPOS    ; compare a with memory contents (data is a6)
           bcs  L9B51          ; branch if lower
           ldx  #ACCTBL_ACOffIdleDelta_FromSpeed    ; load index with value
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    ; call subroutine
           brclr *BitFlags69, #$%00000100, L9B51    ; branch if bit(s) clear
           ldaa PERKCK_AcClutchAisAdjustmentConstant    ; load a with memory contents (data is 80)
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           tab                 ; b = a
   L9B51:  ldaa Temp4          ; load a with memory contents
           aba                 ; a=a+b
           bcs  L9B75          ; branch if lower
   L9B56:  staa Temp4          ; store a into memory
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           ldx  #ADDAIS_AISAddedFromTimeEngRunning    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp4          ; load a with memory contents
           aba                 ; a=a+b
           bcs  L9B75          ; branch if lower
   L9B65:  brset *BitFlags68, #$%00010000, L9B6E    ; branch if bit(s) set
           adda CALPOS_PositionAisMotorIsAtIdle    ;  (data is 1a)
           bcs  L9B75          ; branch if lower
   L9B6E:  bsr  MultiplyTempvar1ByA_Unsign    ; call subroutine
           cmpa AISHLM_AisHighLimitMaxOpenSteps    ; compare a with memory contents (data is a0)
           bcs  L9B78          ; branch if lower
   L9B75:  ldaa AISHLM_AisHighLimitMaxOpenSteps    ; load a with memory contents (data is a0)
   L9B78:  brset *BitFlags69, #$%00100000, L9B92    ; branch if bit(s) set
           brclr *BitFlags_36, #$%00010000, L9B95    ; branch if bit(s) clear
           brset *BitFlags_36, #$%10000000, L9B95    ; branch if bit(s) set
           cmpa DesiredNewAisPosition    ; compare a with memory contents
           bcc  L9B95          ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bitb DLYOF1_UpdateRateOffIdleWhenAisClosing    ;  (data is 1f)
           bne  L9B97          ; branch if not equal (not zero)
           ldaa DesiredNewAisPosition    ; load a with memory contents
           deca                ; decrement a
   L9B92:  bclr *BitFlags69, #$%00100000    ; clear bits
   L9B95:  staa DesiredNewAisPosition    ; store a into memory
   L9B97:  rts                 ; return from subroutine

MultiplyTempvar1ByA_Unsign:
           ldab Temp1          ; load b with memory contents
           beq  L9BC3          ; branch if equal (zero)
           staa Temp4          ; store a into memory
           mul                 ; multiply (d=a*b)
           adca Temp4      
           bcc  L9BC3          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
           rts                 ; return from subroutine

MultiplyTempvar1ByA_Pos:
           ldab Temp1          ; load b with memory contents
           beq  L9BC3          ; branch if equal (zero)
           staa Temp4          ; store a into memory
           mul                 ; multiply (d=a*b)
           adca Temp4      
           bvc  L9BC3          ; branch if overflow
           ldaa #0x7f          ; load a with value -01111111-
           rts                 ; return from subroutine

MultiplyTempvar1ByA_Neg:
           ldab Temp1          ; load b with memory contents
           beq  L9BC3          ; branch if equal (zero)
           nega                ; negate a (set high bit)
           staa Temp4          ; store a into memory
           mul                 ; multiply (d=a*b)
           adca Temp4      
           bvc  L9BC2          ; branch if overflow
           ldaa #0x7f          ; load a with value -01111111-
   L9BC2:  nega                ; negate a (set high bit)
   L9BC3:  rts                 ; return from subroutine

ClearAisTimer:
           clrb                ; b = 0
           stab Timer_AisChanges    ; store b into memory
StoreAndLimitDesiredAisPosition:
           tsta                ; test a
           bmi  L9BD7          ; branch if minus(hi bit 1)
           adda DesiredNewAisPosition
           ldab AISHLM_AisHighLimitMaxOpenSteps    ; load b with memory contents (data is a0)
           bcs  L9BD4          ; branch if lower
           cba             
           bcs  L9BDC          ; branch if lower
   L9BD4:  stab DesiredNewAisPosition    ; store b into memory
           rts                 ; return from subroutine

   L9BD7:  adda DesiredNewAisPosition
           bcs  L9BDC          ; branch if lower
           clra                ; a = 0
   L9BDC:  staa DesiredNewAisPosition    ; store a into memory
           rts                 ; return from subroutine

CCDBusComs:
           ldab #0x93          ; load b with value -10010011-
           ldaa Temp0          ; load a with memory contents
           bne  L9BE7          ; branch if not equal (not zero)
           ldab #0x80          ; load b with value -10000000-
   L9BE7:  aba                 ; a=a+b
           adda Temp1      
           adda Temp2      
           staa Temp3          ; store a into memory
           tba                 ; a = b
           ldab #0x40          ; load b with value -01000000-
           ldY #CPU_PortA      ; load Y index -00010000 00000000-
           ldx  #SwitchPortAccessReg1    ; load index with value
           bset 0, X, #$%00001000    ; bit set -00000000-
           sei                 ; disable interrupts
           bclr 8, Y, #$%00100000    ; bit clear -00001000-
           cmpb CPU_SerialPeripheralStatus    ; compare b with memory contents
           staa CPU_SerialPeripheralDataIO
           bset 2, X, #$%00001000    ; bit set -00000010-
           bclr 2, X, #$%00001000    ; bit clear -00000010-
           nop                 ; no operation
           ldaa CPU_SerialPeripheralDataIO    ; load a with memory contents
           cmpa CPU_SerialPeripheralStatus    ; compare a with memory contents
           ldaa Temp0          ; load a with memory contents
   L9C15:  brclr  0, X, #$%00001000, L9C1F    ; branch if bit(s) clear
           decb            
           bne  L9C15          ; branch if not equal (not zero)
           jmp  L9CAE      

   L9C1F:  staa CPU_SerialPeripheralDataIO
           bset 2, X, #$%00001000    ; bit set -00000010-
           bclr 2, X, #$%00001000    ; bit clear -00000010-
           nop                 ; no operation
           ldaa CPU_SerialPeripheralDataIO    ; load a with memory contents
           staa Temp0          ; store a into memory
           cmpa CPU_SerialPeripheralStatus    ; compare a with memory contents
           ldaa Temp1          ; load a with memory contents
   L9C33:  brclr  0, X, #$%00001000, L9C3D    ; branch if bit(s) clear
           decb            
           bne  L9C33          ; branch if not equal (not zero)
           jmp  L9CAE      

   L9C3D:  staa CPU_SerialPeripheralDataIO
           bset 2, X, #$%00001000    ; bit set -00000010-
           bclr 2, X, #$%00001000    ; bit clear -00000010-
           nop                 ; no operation
           ldaa CPU_SerialPeripheralDataIO    ; load a with memory contents
           staa Temp1          ; store a into memory
           cmpa CPU_SerialPeripheralStatus    ; compare a with memory contents
           ldaa Temp2          ; load a with memory contents
   L9C51:  brclr  0, X, #$%00001000, L9C5B    ; branch if bit(s) clear
           decb            
           bne  L9C51          ; branch if not equal (not zero)
           jmp  L9CAE      

   L9C5B:  staa CPU_SerialPeripheralDataIO
           bset 2, X, #$%00001000    ; bit set -00000010-
           bclr 2, X, #$%00001000    ; bit clear -00000010-
           nop                 ; no operation
           ldaa CPU_SerialPeripheralDataIO    ; load a with memory contents
           staa Temp2          ; store a into memory
           cmpa CPU_SerialPeripheralStatus    ; compare a with memory contents
           ldaa Temp3          ; load a with memory contents
   L9C6F:  brclr  0, X, #$%00001000, L9C78    ; branch if bit(s) clear
           decb            
           bne  L9C6F          ; branch if not equal (not zero)
           bra  L9CAE          ; branch

   L9C78:  staa CPU_SerialPeripheralDataIO
           bset 2, X, #$%00001000    ; bit set -00000010-
           bclr 2, X, #$%00001000    ; bit clear -00000010-
           nop                 ; no operation
   L9C82:  brset 41, Y, #$%10000000, L9C8C    ; branch if bit(s) set -00101001-
           decb            
           bne  L9C82          ; branch if not equal (not zero)
           bra  L9CAE          ; branch

   L9C8C:  ldaa CPU_SerialPeripheralDataIO    ; load a with memory contents
           bset 8, Y, #$%00100000    ; bit set -00001000-
           cli                 ; enable interrupts
           suba Temp0      
           suba Temp1      
           suba Temp2      
           bne  L9CAF          ; branch if not equal (not zero)
           ldaa Temp0          ; load a with memory contents
           andA #0x0f          ; AND a with value -00001111-
           cmpa #0x01          ; compare a with value -00000001-
           bne  L9CAF          ; branch if not equal (not zero)
           bset *CCDFlags5, #$%01000000    ; set bits
           brset *CCDFlags6, #$%10000000, L9CAF    ; branch if bit(s) set
           bset *CCDFlagsX, #$%00010000    ; set bits
   L9CAE:  nop                 ; no operation
   L9CAF:  rts                 ; return from subroutine

PrepareCCDDataForXmit_MM:
           ldab Counter_MainLoop    ; load b with memory contents
           andb #0x0f          ;  -00001111-
           bne  L9CF8          ; branch if not equal (not zero)
           brset *CCDFlagsX, #$%00001000, L9CDC    ; branch if bit(s) set
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa #0x83          ; compare a with value -10000011-
           bcs  L9CF4          ; branch if lower
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa #0x2f          ; compare a with value -00101111-
           bcs  L9CF4          ; branch if lower
           ldaa BatteryVolts    ; load a with memory contents
           cmpa #0xbd          ; compare a with value -10111101-
           bcc  L9CF4          ; branch if greater or equal
           ldab BodyCompFlags4_X    ; load b with memory contents
           incb            
           stab BodyCompFlags4_X    ; store b into memory
           cmpb #0x71          ;  -01110001-
           bcs  L9CF8          ; branch if lower
           bset *CCDFlagsX, #$%00001000    ; set bits
           bra  L9CF4          ; branch

   L9CDC:  ldaa TargetBatteryVolts    ; load a with memory contents
           suba BatteryVolts
           bcs  L9CE6          ; branch if lower
           cmpa #0x01          ; compare a with value -00000001-
           bhi  L9CF4          ; branch if higher
   L9CE6:  ldab BodyCompFlags4_X    ; load b with memory contents
           incb            
           stab BodyCompFlags4_X    ; store b into memory
           cmpb #0x22          ;  -00100010-
           bcs  L9CF8          ; branch if lower
           bclr *CCDFlagsX, #$%00001000    ; clear bits
   L9CF4:  clra                ; a = 0
           staa BodyCompFlags4_X
   L9CF8:  brset *Counter_MainLoop, #$%00000001, L9D11    ; branch if bit(s) set
           ldx  #CCDDataStream    ; load index with value
           ldab CCDTemp_HB     ; load b with memory contents
           asld                ; shift left (d=d*2)
           addb #0x02          ;  -00000010-
           abx                 ; add b to index
           lsrd                ; shift right (d=d/2)
           stab CCDTemp_HB     ; store b into memory
           ldx  0x00, X    
           jsr  0x00, X    
           stD *Temp1          ; store D to RAM
           jsr  CCDBusComs     ; call subroutine
   L9D11:  ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           bne  L9D1F          ; branch if not equal (not zero)
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 91)
           bitA #0x04          ;  -00000100-
           beq  L9D20          ; branch if equal (zero)
           bclr *CCDFlags5, #ccd_AlarmDisable    ; clear bits
   L9D1F:  rts                 ; return from subroutine

   L9D20:  ldaa CPU_EEPROMControlReg    ; load a with memory contents
           bitA #0x02          ;  -00000010-
           bne  L9D34          ; branch if not equal (not zero)
           bclr *CCDFlagsX, #$%00100000    ; clear bits
           ldaa LB612          ; load a with memory contents (data is ff)
           bitA #0x01          ;  -00000001-
           beq  L9D34          ; branch if equal (zero)
           bset *CCDFlagsX, #$%00100000    ; set bits
   L9D34:  ldaa Counter_MainLoop    ; load a with memory contents
           bitA #0x03          ;  -00000011-
           bne  L9D9D          ; branch if not equal (not zero)
           brclr *CCDFlags5, #$%01000000, L9D5C    ; branch if bit(s) clear
           bset *CCDFlags5, #$%10000000    ; set bits
           bclr *CCDFlags5, #$%01100000    ; clear bits
           bclr *CCDFlags6, #$%01111111    ; clear bits
           brset *CCDFlags6, #$%10000000, L9D9D    ; branch if bit(s) set
           ldaa BitFlags6a     ; load a with memory contents
           bitA #0x03          ;  -00000011-
           bne  L9D9D          ; branch if not equal (not zero)
           ldaa LB612          ; load a with memory contents (data is ff)
           bitA #0x02          ;  -00000010-
           beq  L9D9D          ; branch if equal (zero)
           anda #0xfd          ; AND a with value -11111101-
           bra  L9D8B          ; branch

   L9D5C:  ldaa CCDFlags6      ; load a with memory contents
           anda #0x7f          ; AND a with value -01111111-
           brclr *CCDFlags5, #$%10000000, L9D6A    ; branch if bit(s) clear
           cmpa #0x7e          ; compare a with value -01111110-
           bcc  L9D73          ; branch if greater or equal
           bra  L9D6E          ; branch

   L9D6A:  cmpa #0x2d          ; compare a with value -00101101-
           bcc  L9D9D          ; branch if greater or equal
   L9D6E:  inc  CCDFlags6  
           bra  L9D9D          ; branch

   L9D73:  ldaa BitFlags6a     ; load a with memory contents
           bitA #0x03          ;  -00000011-
           bne  L9D9D          ; branch if not equal (not zero)
           ldaa LB612          ; load a with memory contents (data is ff)
           bitA #0x02          ;  -00000010-
           bne  L9D9D          ; branch if not equal (not zero)
           bset *CCDFlags6, #$%10000000    ; set bits
           oraA #0x02          ;  -00000010-
           cmpa #0x4c          ; compare a with value -01001100-
           bcc  L9D8B          ; branch if greater or equal
           oraa #0xff          ;  -11111111-
   L9D8B:  sei                 ; disable interrupts
           brclr *BitFlags6a, #$%00000001, L9D93    ; branch if bit(s) clear
           cli                 ; enable interrupts
           bra  L9D9D          ; branch

   L9D93:  bset *BitFlags6a, #$%00000001    ; set bits
           cli                 ; enable interrupts
           staa DRBOffsetStored_LB    ; store a into memory
           ldaa #0x12          ; load a with value -00010010-
           staa DRBOffsetStored_HB    ; store a into memory
   L9D9D:  brclr *CCDFlags5, #$%00010000, L9DB1    ; branch if bit(s) clear
           brset *CCDFlags5, #$%10000000, L9DB0    ; branch if bit(s) set
           ldaa CCDFlags6      ; load a with memory contents
           anda #0x7f          ; AND a with value -01111111-
           cmpa #0x2d          ; compare a with value -00101101-
           bcs  L9DB0          ; branch if lower
           bset *CCDFlags5, #ccd_AlarmDisable    ; set bits
   L9DB0:  rts                 ; return from subroutine

   L9DB1:  brset *CCDFlags5, #$%00010000, L9DFF    ; branch if bit(s) set
           brset *BitFlags6e, #$%10000000, L9DFF    ; branch if bit(s) set
           ldaa BitFlags6a     ; load a with memory contents
           bitA #0x03          ;  -00000011-
           bne  L9DFF          ; branch if not equal (not zero)
           ldaa LB612          ; load a with memory contents (data is ff)
           bitA #0x01          ;  -00000001-
           bne  L9DCC          ; branch if not equal (not zero)
           bitA #0x02          ;  -00000010-
           bne  L9DF9          ; branch if not equal (not zero)
           bra  L9DFC          ; branch

   L9DCC:  brset *CCDFlags5, #$%10000000, L9DDA    ; branch if bit(s) set
           ldaa CCDFlags6      ; load a with memory contents
           anda #0x7f          ; AND a with value -01111111-
           cmpa #0x2d          ; compare a with value -00101101-
           bcs  L9DFF          ; branch if lower
           bra  L9DF6          ; branch

   L9DDA:  sei                 ; disable interrupts
           brclr *BitFlags6a, #$%00000001, L9DE2    ; branch if bit(s) clear
           cli                 ; enable interrupts
           bra  L9DFF          ; branch

   L9DE2:  bset *BitFlags6a, #$%00000001    ; set bits
           cli                 ; enable interrupts
           adda #0x04          ;  -00000100-
           cmpa #0x4c          ; compare a with value -01001100-
           bcs  L9DEE          ; branch if lower
           anda #0xfe          ; AND a with value -11111110-
   L9DEE:  anda #0xfd          ; AND a with value -11111101-
           staa DRBOffsetStored_LB    ; store a into memory
           ldaa #0x12          ; load a with value -00010010-
           staa DRBOffsetStored_HB    ; store a into memory
   L9DF6:  bset *CCDFlagsX, #$%00100000    ; set bits
   L9DF9:  bset *CCDFlags5, #$%10000000    ; set bits
   L9DFC:  bset *CCDFlags5, #$%00010000    ; set bits
   L9DFF:  rts                 ; return from subroutine

   L9E00:  ldd  #0x0000         ; load d (a&b) with value -00000000 00000000-
           staa Temp0          ; store a into memory
           rts                 ; return from subroutine

CCD_EngineRPM:
           ldaa #0xe4          ; load a with value -11100100-
           staa Temp0          ; store a into memory
           ldaa EngineRpm_HB    ; load a with memory contents
           ldab MapValue       ; load b with memory contents
           rts                 ; return from subroutine

CCD_FuelOutput:
           ldaa #0x84          ; load a with value -10000100-
           staa Temp0          ; store a into memory
           sei                 ; disable interrupts
           ldaa CCDFuelOutput_HB    ; load a with memory contents
           ldab Counter_SpeedSensorInterrupt_HB_X    ; load b with memory contents
           clr  CCDFuelOutput_HB    ; zero byte at memory location
           clr  Counter_SpeedSensorInterrupt_HB_X    ; zero byte at memory location
           cli                 ; enable interrupts
           rts                 ; return from subroutine

CCD_ConfigConst1:
           ldaa #0xac          ; load a with value -10101100-
           staa Temp0          ; store a into memory
           ldd  CCDCFG_CCDConfigConstant    ;  (data is 4030)
           rts                 ; return from subroutine

CCD_CoolantTemp:
           ldaa #0x8c          ; load a with value -10001100-
           staa Temp0          ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldab AmbientAirTempVolts    ; load b with memory contents
           rts                 ; return from subroutine

CCD_BatVolts:
           ldaa #0xd4          ; load a with value -11010100-
           staa Temp0          ; store a into memory
           ldaa BatteryVolts    ; load a with memory contents
           bsr  L9E43          ; call subroutine
           stab Temp3          ; store b into memory
           ldaa TargetBatteryVolts    ; load a with memory contents
           bsr  L9E43          ; call subroutine
           ldaa Temp3          ; load a with memory contents
           rts                 ; return from subroutine

   L9E43:  ldab BodyComputerBatteryVoltsOutput    ; load b with memory contents
           cmpb #0x10          ;  -00010000-
           bhi  L9E5C          ; branch if higher
           comb            
           addb #0x09          ;  -00001001-
           bcs  L9E53          ; branch if lower
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           bra  L9E5C          ; branch

   L9E53:  staa Temp4          ; store a into memory
           mul                 ; multiply (d=a*b)
           adca Temp4      
           bcc  L9E5C          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   L9E5C:  tab                 ; b = a
           rts                 ; return from subroutine

CCD_ThrottlePos:
           ldaa #0x42          ; load a with value -01000010-
           staa Temp0          ; store a into memory
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bcc  L9E69          ; branch if greater or equal
           clra                ; a = 0
   L9E69:  clrb                ; b = 0
           rts                 ; return from subroutine

CCD_B600:
           ldaa #0xcc          ; load a with value -11001100-
           staa Temp0          ; store a into memory
           ldaa CPU_EEPROMControlReg    ; load a with memory contents
           bitA #0x02          ;  -00000010-
           bne  L9E00          ; branch if not equal (not zero)
           ldd  LB600          ;  (data is ffff)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           staa Temp3          ; store a into memory
           ldd  TargetIdleSpeedHB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           tab                 ; b = a
           ldaa Temp3          ; load a with memory contents
           rts                 ; return from subroutine

CCD_Baro:
           ldaa #0x54          ; load a with value -01010100-
           staa Temp0          ; store a into memory
           ldaa BaroPressure    ; load a with memory contents
           clrb                ; b = 0
           rts                 ; return from subroutine

CCD_VehicleSpeed:
           ldaa #0x24          ; load a with value -00100100-
           staa Temp0          ; store a into memory
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           staa Temp3          ; store a into memory
           asld                ; shift left (d=d*2)
           bcc  L9E9C          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   L9E9C:  ldab #0x34          ; load b with value -00110100-
           mul                 ; multiply (d=a*b)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           tab                 ; b = a
           ldaa Temp3          ; load a with memory contents
           rts                 ; return from subroutine

CCD_B672:
           ldaa CPU_EEPROMControlReg    ; load a with memory contents
           bitA #0x02          ;  -00000010-
           bne  L9ED8          ; branch if not equal (not zero)
           ldx  #0xb672        ; load index with value
           ldab CCDFlagsX      ; load b with memory contents
           tba                 ; a = b
           incb            
           andb #0x07          ;  -00000111-
           anda #0xf8          ; AND a with value -11111000-
           cmpb #0x06          ;  -00000110-
           bne  L9EBF          ; branch if not equal (not zero)
           clrb                ; b = 0
   L9EBF:  aba                 ; a=a+b
           staa CCDFlagsX      ; store a into memory
           lslb            
           lslb            
           abx                 ; add b to index
           brset  0, X, #$%11111111, L9ED8    ; branch if bit(s) set
           ldaa 0x00, X        ; load a with memory at index + value
           staa Temp0          ; store a into memory
           adda 0x01, X    
           adda 0x02, X    
           cmpa 0x03, X        ; compare a with memory at index + value
           bne  L9ED8          ; branch if not equal (not zero)
           ldd  0x01, X    
           rts                 ; return from subroutine

   L9ED8:  jmp  L9E00      

CCD_ToggleBCFlags:
           ldaa #0xec          ; load a with value -11101100-
           staa Temp0          ; store a into memory
           clra                ; a = 0
           brclr *b5c_IPL1, #$%00000010, L9EE6    ; branch if bit(s) clear
           oraA #0x01          ;  -00000001-
   L9EE6:  brclr *b5c_IPL1, #$%01000000, L9EEC    ; branch if bit(s) clear
           oraA #0x02          ;  -00000010-
   L9EEC:  brclr *CCDFlagsX, #$%00001000, L9EF2    ; branch if bit(s) clear
           oraA #0x04          ;  -00000100-
   L9EF2:  brclr *b5c_IPL1, #$%00000100, L9EF8    ; branch if bit(s) clear
           oraA #0x08          ;  -00001000-
   L9EF8:  clrb                ; b = 0
           brclr *CCDFlagsX, #$%00010000, L9F02    ; branch if bit(s) clear
           bclr *CCDFlagsX, #$%00010000    ; clear bits
           oraB #0x01          ;  -00000001-
   L9F02:  brclr *CCDFlagsX, #$%00100000, L9F08    ; branch if bit(s) clear
           oraB #0x02          ;  -00000010-
   L9F08:  rts                 ; return from subroutine

CCD_SwitchState:
           ldaa #0xa4          ; load a with value -10100100-
           staa Temp0          ; store a into memory
           clra                ; a = 0
           brset *CruiseStatus_1, #$%10000000, L9F14    ; branch if bit(s) set
           oraA #0x01          ;  -00000001-
   L9F14:  ldab TpsVolts       ; load b with memory contents
           subb MINTHR_LowestSessionTPS    ; b = b-memory contents
           bcs  L9F20          ; branch if lower
           cmpb #0x05          ;  -00000101-
           bcs  L9F20          ; branch if lower
           oraA #0x02          ;  -00000010-
   L9F20:  brclr *StartupSwitchMirror1, #sw1_Brake, L9F26    ; branch if bit(s) clear
           oraA #0x04          ;  -00000100-
   L9F26:  brclr *CCDFlags1, #$%00000001, L9F2C    ; branch if bit(s) clear
           oraA #0x08          ;  -00001000-
   L9F2C:  brset *PIA_Buffer1, #pia_CEL, L9F32    ; branch if bit(s) set
           oraa #0x20          ;  -00100000-
   L9F32:  clrb                ; b = 0
           rts                 ; return from subroutine

;	.org	0x9f34
CCDDataStream:
	.word	CCD_EngineRPM
	.word	CCD_FuelOutput
	.word	L9E00
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_BatVolts
	.word	L9E00
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_VehicleSpeed
	.word	CCD_SwitchState
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_ThrottlePos
	.word	L9E00
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_FuelOutput
	.word	L9E00
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_Baro
	.word	L9E00
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_VehicleSpeed
	.word	CCD_SwitchState
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_ThrottlePos
	.word	L9E00
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_FuelOutput
	.word	L9E00
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_CoolantTemp
	.word	L9E00
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_VehicleSpeed
	.word	CCD_SwitchState
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_ThrottlePos
	.word	L9E00
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_FuelOutput
	.word	L9E00
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_B600
	.word	L9E00
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_VehicleSpeed
	.word	CCD_SwitchState
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_ThrottlePos
	.word	L9E00
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_FuelOutput
	.word	CCD_ToggleBCFlags
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_BatVolts
	.word	L9E00
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_VehicleSpeed
	.word	CCD_SwitchState
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_ThrottlePos
	.word	L9E00
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_FuelOutput
	.word	L9E00
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_B672
	.word	L9E00
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_VehicleSpeed
	.word	CCD_SwitchState
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_ThrottlePos
	.word	L9E00
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_FuelOutput
	.word	L9E00
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_CoolantTemp
	.word	L9E00
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_VehicleSpeed
	.word	CCD_SwitchState
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_ThrottlePos
	.word	L9E00
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_FuelOutput
	.word	L9E00
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_ConfigConst1
	.word	L9E00
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_VehicleSpeed
	.word	CCD_SwitchState
	.word	L9E00
	.word	CCD_EngineRPM
	.word	CCD_ThrottlePos
	.word	L9E00
	.word	L9E00
HandleO2Processing_MM:
           clra                ; a = 0
           brset *BitFlags66, #$%10000000, LA052    ; branch if bit(s) set
           ldab CONFIG2_ConfigurationFlags2    ; load b with memory contents (data is 01)
           bitb #0x01          ;  -00000001-
           beq  LA044          ; branch if equal (zero)
           brclr *BitFlags6b, #$%00010000, LA052    ; branch if bit(s) clear
   LA044:  ldab EngineRpm_HB    ; load b with memory contents
           subb TargetIdleSpeedHB    ; b = b-memory contents
           bcs  LA052          ; branch if lower
           cmpb MNRPO2_MinimumRPMOverIdleForO2Feedback    ; compare b with memory contents (data is d0)
           bls  LA052          ; branch if lower or same
           jmp  O2_StopUsingFeedback

   LA052:  ldab MapValue       ; load b with memory contents
           cmpb MAPDEC_NoCellUpdateAndO2CNTRHeldBelowThisMap    ; compare b with memory contents (data is 14)
           bls  LA06E          ; branch if lower or same
           ldab Timer_O2InhibitSwitchingRichIdleToClosedLoop    ; load b with memory contents
           orab Factor_DecelLeanoutWhenMAPDecreasing
           orab Timer_OffThrottleFuelEnrich
           bne  LA06E          ; branch if not equal (not zero)
           ldab Timer_OpenLoopFraction    ; load b with memory contents
           beq  LA069          ; branch if equal (zero)
           brset *BitFlags66, #$%10000000, LA06E    ; branch if bit(s) set
   LA069:  bclr *BitFlags67, #$%00010000    ; clear bits
           bra  LA073          ; branch

   LA06E:  bset *BitFlags67, #$%00010000    ; set bits
           staa Timer_OutOfClosedLoopMode    ; store a into memory
   LA073:  brset *BitFlags66, #$%00000001, LA07F    ; branch if bit(s) set
           brclr *BitFlags66, #$%00000010, LA085    ; branch if bit(s) clear
           brclr *BitFlags67, #$%00010000, LA085    ; branch if bit(s) clear
   LA07F:  brset *BitFlags66, #$%00010000, O2_StopUsingFeedback    ; branch if bit(s) set
           bra  LA089          ; branch

   LA085:  brset *BitFlags66, #$%00010000, O2_UsingFeedback    ; branch if bit(s) set
   LA089:  ldab CoolantTemp    ; load b with memory contents
           cmpb CLTEMP_TempToStartCLTIMETimer    ; compare b with memory contents (data is 92)
           bcs  O2_StopUsingFeedback    ; branch if lower
           brset *BitFlags66, #$%00100000, LA0A4    ; branch if bit(s) set
           ldab Counter_MainLoop    ; load b with memory contents
           bne  O2_StopUsingFeedback    ; branch if not equal (not zero)
           ldab Timer_CLTIME_ClosedLoopTimer    ; load b with memory contents
           beq  LA0A1          ; branch if equal (zero)
           decb            
           stab Timer_CLTIME_ClosedLoopTimer    ; store b into memory
           bne  O2_StopUsingFeedback    ; branch if not equal (not zero)
   LA0A1:  bset *BitFlags66, #$%00100000    ; set bits
   LA0A4:  ldab O2SensorVolts    ; load b with memory contents
           cmpb O2HIGH_HighLimitForImmediateSwitchToClosedLoop    ; compare b with memory contents (data is 26)
           bcc  O2_ValidSignal_OutsideMiddleRange    ; branch if greater or equal
           cmpb O2LOW_LowLimitForImmediateSwitchToClosedLoop    ; compare b with memory contents (data is 0f)
           bcc  O2_InvalidSignal_InMiddleRange    ; branch if greater or equal
O2_ValidSignal_OutsideMiddleRange:
           brset *PIA_Buffer2, #pia_FuelMon, O2_StopUsingFeedback    ; branch if bit(s) set
           bset *BitFlags66, #$%00010000    ; set bits
           staa Counter_AdaptiveMem_Erase    ; store a into memory
           clrb                ; b = 0
           bra  LA0D9          ; branch

O2_InvalidSignal_InMiddleRange:
           brset *Timer_CLTIME_ClosedLoopTimer, #$%10000000, LA0CD    ; branch if bit(s) set
           cmpb O2TLMH_HighLimitForDelayedSwitchToClosedLoop    ; compare b with memory contents (data is 1f)
           bcc  LA0CA          ; branch if greater or equal
           cmpb O2TLML_LowLimitForDelayedSwitchToClosedLoop    ; compare b with memory contents (data is 0f)
           bcc  O2_StopUsingFeedback    ; branch if greater or equal
   LA0CA:  bset *Timer_CLTIME_ClosedLoopTimer, #$%10000000    ; set bits
   LA0CD:  ldab Counter_MainLoop    ; load b with memory contents
           bne  O2_StopUsingFeedback    ; branch if not equal (not zero)
           ldab Timer_CLTIME_ClosedLoopTimer    ; load b with memory contents
           cmpb O2TIME_DelayTimeToClosedLoop    ; compare b with memory contents (data is 07)
           bmi  O2_ValidSignal_OutsideMiddleRange    ; branch if minus(hi bit 1)
           incb            
   LA0D9:  stab Timer_CLTIME_ClosedLoopTimer    ; store b into memory
O2_StopUsingFeedback:
           staa Counter_O2SensorFeedbackCount_Signed    ; store a into memory
           staa Timer_OutOfClosedLoopMode    ; store a into memory
           bset *BitFlags67, #$%00010100    ; set bits
           rts                 ; return from subroutine

O2_UsingFeedback:
           ldab O2SensorVolts    ; load b with memory contents
           cmpb O2MIDX_HighLimitForInMiddleDeterminationX    ; compare b with memory contents (data is 3e)
           bcc  O2Signal_InOuterMiddleRange    ; branch if greater or equal
           cmpb O2MIDH_HighLimitForInMiddleDetermination    ; compare b with memory contents (data is 1f)
           bcc  LA107          ; branch if greater or equal
           cmpb O2MIDL_LowLimitForInMiddleDetermination    ; compare b with memory contents (data is 12)
           bcs  LA107          ; branch if lower
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa #0x2c          ; compare a with value -00101100-
           bcs  LA106          ; branch if lower
O2Signal_InOuterMiddleRange:
           ldaa Timer_CLTIME_ClosedLoopTimer    ; load a with memory contents
           inca                ; increment a
           bne  LA102          ; branch if not equal (not zero)
           jmp  Save_CLTIME_ToOtherTimers_O2InMiddle

   LA102:  brset *Counter_MainLoop, #$%00000001, LA109    ; branch if bit(s) set
   LA106:  clra                ; a = 0
   LA107:  staa Timer_CLTIME_ClosedLoopTimer    ; store a into memory
   LA109:  clra                ; a = 0
           cmpb O2HSWP_HighLimitForO2RampSwitching    ; compare b with memory contents (data is 19)
           bcc  O2Signal_AboveToggle    ; branch if greater or equal
           cmpb O2LSWP_LowLimitForO2RampSwitching    ; compare b with memory contents (data is 18)
           bcs  O2Signal_BelowToggle    ; branch if lower
           rts                 ; return from subroutine

O2Signal_AboveToggle:
           deca                ; decrement a
O2Signal_BelowToggle:
           staa Temp0          ; store a into memory
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb RPMLIM_NoCellUpdateAboveThisRPMInRPMOver32    ; compare b with memory contents (data is 60)
           bhi  LA188          ; branch if higher
           brset *BitFlags66, #$%10000000, LA137    ; branch if bit(s) set
           ldaa CONFIG2_ConfigurationFlags2    ; load a with memory contents (data is 01)
           bitA #0x01          ;  -00000001-
           beq  LA12E          ; branch if equal (zero)
           brclr *BitFlags6b, #$%00010000, LA137    ; branch if bit(s) clear
   LA12E:  subb TargetIdleSpeedHB    ; b = b-memory contents
           bcs  LA137          ; branch if lower
           cmpb MNRPO2_MinimumRPMOverIdleForO2Feedback    ; compare b with memory contents (data is d0)
           bhi  LA188          ; branch if higher
   LA137:  ldab Timer_FuelEnrich    ; load b with memory contents
           orab Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop
           bne  LA188          ; branch if not equal (not zero)
           ldab MapValue       ; load b with memory contents
           cmpb MAPLIM_NoCellUpdateAboveThisMAP    ; compare b with memory contents (data is 8a)
           bhi  LA188          ; branch if higher
           cmpb MAPDEC_NoCellUpdateAndO2CNTRHeldBelowThisMap    ; compare b with memory contents (data is 14)
           bls  SwitchOrStayOpenLoop    ; branch if lower or same
           ldab Factor_DecelLeanoutWhenMAPDecreasing    ; load b with memory contents
           orab Timer_OffThrottleFuelEnrich
           orab Timer_OpenLoopFraction
           bne  SwitchOrStayOpenLoop    ; branch if not equal (not zero)
           ldab CylTrim_Adaptive_Var1    ; load b with memory contents
           beq  LA15A          ; branch if equal (zero)
           cmpb CLTRMN_MinimumCylinderTrim    ; compare b with memory contents (data is 07)
           bcs  SwitchOrStayOpenLoop    ; branch if lower
   LA15A:  ldab CALTH1_O2ControllerDeadbandLimitForUpdatingCells1    ; load b with memory contents (data is 09)
           brset *BitFlags66, #$%10000000, LA173    ; branch if bit(s) set
           pshb                ; push b onto stack
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           cmpa MPHREF_SwitchPointForDecelIdleAisControl    ; compare a with memory contents (data is 07)
           pulb                ; pull b from stack
           bhi  LA173          ; branch if higher
           ldab CALTH2_O2ControllerDeadbandLimitForUpdatingCells2    ; load b with memory contents (data is 09)
   LA173:  brset *Temp0, #$%11111111, LA178    ; branch if bit(s) set
           negb            
   LA178:  addb Counter_O2SensorFeedbackCount_Signed    ; b=b+memory contents
           bvs  SwitchOrStayOpenLoop    ; branch if no overflow
           eorb Temp0      
           bmi  SwitchOrStayOpenLoop    ; branch if minus(hi bit 1)
           bclr *BitFlags67, #$%00000100    ; clear bits
           bclr *CylTrim_FlagsE8, #$%00100000    ; clear bits
           bra  SwitchOrStayClosedLoop    ; branch

   LA188:  bset *CylTrim_FlagsE8, #$%00100000    ; set bits
SwitchOrStayOpenLoop:
           bset *BitFlags67, #$%00000100    ; set bits
SwitchOrStayClosedLoop:
           clra                ; a = 0
           brclr *BitFlags67, #$%00010000, LA196    ; branch if bit(s) clear
           staa Counter_AdaptiveMem_Erase    ; store a into memory
           rts                 ; return from subroutine

   LA196:  ldab Temp0          ; load b with memory contents
           eorb BitFlags66 
           andb #0x04          ;  -00000100-
           beq  O2HasNotToggled    ; branch if equal (zero)
           eorb BitFlags66 
           stab BitFlags66     ; store b into memory
           clrb                ; b = 0
           ldaa Timer_OutOfClosedLoopMode    ; load a with memory contents
           stab Timer_OutOfClosedLoopMode    ; store b into memory
           stab Timer_O2ToggleDuration    ; store b into memory
           bclr *BitFlags69, #$%00000011    ; clear bits
           bclr *BitFlags67, #$%00000001    ; clear bits
           bra  WorkWithPrimaryRamp    ; branch

O2HasNotToggled:
           ldab Timer_OutOfClosedLoopMode    ; load b with memory contents
           beq  LA1EA          ; branch if equal (zero)
WorkWithPrimaryRamp:
           staa Temp0          ; store a into memory
           ldx  #PRIRMP_PrimaryRamp    ; load index with value
           jsr  DetermineRampCellFromRPMandMAP    ; call subroutine
           ldab Timer_OutOfClosedLoopMode    ; load b with memory contents
           addb 0x00, X        ; add memory at index + value to b
           sba                 ; subtract (a=a-b)
           bhi  LA1CE          ; branch if higher
           adda 0x00, X    
           bpl  LA1C9          ; branch if plus (hi bit 0)
           clra                ; a = 0
   LA1C9:  clrb                ; b = 0
           stab Timer_OutOfClosedLoopMode    ; store b into memory
           bra  LA1D5          ; branch

   LA1CE:  ldaa 0x00, X        ; load a with memory at index + value
           tab                 ; b = a
           addb Timer_OutOfClosedLoopMode    ; b=b+memory contents
           stab Timer_OutOfClosedLoopMode    ; store b into memory
   LA1D5:  ldab Temp0          ; load b with memory contents
           beq  LA1DD          ; branch if equal (zero)
           cba             
           bcs  LA1DD          ; branch if lower
           tba                 ; a = b
   LA1DD:  ldab BitFlags66     ; load b with memory contents
           bitb #0x04          ;  -00000100-
           beq  LA1E4          ; branch if equal (zero)
           nega                ; negate a (set high bit)
   LA1E4:  jsr  IncrementO2SensorFeedbackCount    ; call subroutine
           clra                ; a = 0
           bra  LA1FA          ; branch

   LA1EA:  brset *BitFlags67, #$%00010000, LA1FC    ; branch if bit(s) set
           ldaa Counter_AdaptiveMem_Erase    ; load a with memory contents
           cmpa LTHTIM_IfNoO2SwitchForThisTimeThrowFault51or52    ; compare a with memory contents (data is 2b)
           bcc  EraseAdaptiveMemory_possiblySetErrorBit    ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bne  LA1FC          ; branch if not equal (not zero)
           inca                ; increment a
   LA1FA:  staa Counter_AdaptiveMem_Erase    ; store a into memory
   LA1FC:  rts                 ; return from subroutine

EraseAdaptiveMemory_possiblySetErrorBit:
           brset *BitFlags69, #$%00000011, LA206    ; branch if bit(s) set
           inc  BitFlags69 
           bra  EraseAdaptiveMemory1    ; branch

   LA206:  bset *BitFlags67, #$%00000001    ; set bits
           ldd  #0x0301        ; load d (a&b) with value -00000011 00000001-
           brset *BitFlags66, #$%00000100, LA211    ; branch if bit(s) set
           inca                ; increment a
   LA211:  jsr  ThrowNonCriticalError    ; call subroutine
EraseAdaptiveMemory1:
           clra                ; a = 0
           staa ValueFromAdaptiveMemory    ; store a into memory
           ldx  #AutoCalCell0    ; load index with value
   LA21A:  staa 0x00, X    
           inx                 ; increment index (x=x+1)
           cpx  #ErrorBitRegister0    ;  -00000000 00011111-
           bne  LA21A          ; branch if not equal (not zero)
Save_CLTIME_ToOtherTimers_O2InMiddle:
           staa AdaptiveCellUpdateTimer_IncrementedEveryCamRisingEdge    ; store a into memory
           staa Counter_AdaptiveMem_Erase    ; store a into memory
           staa Timer_CLTIME_ClosedLoopTimer    ; store a into memory
           bclr *BitFlags66, #$%00010000    ; clear bits
           rts                 ; return from subroutine

ModifyO2FeedbackCountVarToMaintainStoich_MM:
           brset *BitFlags67, #$%00010000, LA234    ; branch if bit(s) set
           brset *BitFlags66, #$%00010000, WorkWithSecondaryRamp    ; branch if bit(s) set
   LA234:  clra                ; a = 0
           staa Timer_O2ToggleDuration    ; store a into memory
           rts                 ; return from subroutine

WorkWithSecondaryRamp:
           ldx  #SECRMP_SecondaryRamp    ; load index with value
           bsr  DetermineRampCellFromRPMandMAP    ; call subroutine
           sei                 ; disable interrupts
           ldaa Timer_O2ToggleDuration    ; load a with memory contents
           sba                 ; subtract (a=a-b)
           bcc  O2_SensorStuckOnOneSideTooLong    ; branch if greater or equal
           cli                 ; enable interrupts
           rts                 ; return from subroutine

O2_SensorStuckOnOneSideTooLong:
           staa Timer_O2ToggleDuration    ; store a into memory
           cli                 ; enable interrupts
           ldaa 0x00, X        ; load a with memory at index + value
IncrementO2SensorFeedbackCount:
           ldab O2LIMH_O2RangeLimitHigh    ; load b with memory contents (data is 7f)
           adda Counter_O2SensorFeedbackCount_Signed
           bvc  DIDNT_2SCOMPLEMENT_OVERFLOW_UNDERFLOW1    ; branch if overflow
           brclr *Counter_O2SensorFeedbackCount_Signed, #$%10000000, SET_TO_MAX_OR_MIN_VALUE    ; branch if bit(s) clear
           ldab O2LIML_O2RangeLimitLow    ; load b with memory contents (data is 80)
           bra  SET_TO_MAX_OR_MIN_VALUE    ; branch

DIDNT_2SCOMPLEMENT_OVERFLOW_UNDERFLOW1:
           cba             
           bge  SET_TO_MAX_OR_MIN_VALUE    ; branch if greater or equal
           ldab O2LIML_O2RangeLimitLow    ; load b with memory contents (data is 80)
           cba             
           bge  LA264          ; branch if greater or equal
SET_TO_MAX_OR_MIN_VALUE:
           tba                 ; a = b
   LA264:  brclr *BitFlags67, #$%00000001, LA26B    ; branch if bit(s) clear
           tsta                ; test a
           bmi  DontUpdateO2FeedbackCount    ; branch if minus(hi bit 1)
   LA26B:  staa Counter_O2SensorFeedbackCount_Signed    ; store a into memory
DontUpdateO2FeedbackCount:
           rts                 ; return from subroutine

DetermineRampCellFromRPMandMAP:
           brset *BitFlags67, #$%01000000, LA27A    ; branch if bit(s) set
           brset *BitFlags66, #$%10000000, LA27A    ; branch if bit(s) set
           ldab #0x16          ; load b with value -00010110-
           bra  LA2A4          ; branch

   LA27A:  clrb                ; b = 0
           ldaa EngineRpm_HB    ; load a with memory contents
   LA27D:  cmpa 0x00, X        ; compare a with memory at index + value
           bcs  LA289          ; branch if lower
           incb            
           inx                 ; increment index (x=x+1)
           cmpb #0x02          ;  -00000010-
           bcs  LA27D          ; branch if lower
           bra  LA28E          ; branch

   LA289:  tstb            
           bne  LA28D          ; branch if not equal (not zero)
           inx                 ; increment index (x=x+1)
   LA28D:  inx                 ; increment index (x=x+1)
   LA28E:  ldaa MapValue       ; load a with memory contents
   LA290:  cmpa 0x00, X        ; compare a with memory at index + value
           bcs  LA29D          ; branch if lower
           addb #0x03          ;  -00000011-
           inx                 ; increment index (x=x+1)
           cmpb #0x06          ;  -00000110-
           bcs  LA290          ; branch if lower
           bra  LA2A3          ; branch

   LA29D:  cmpb #0x03          ;  -00000011-
           bcc  LA2A2          ; branch if greater or equal
           inx                 ; increment index (x=x+1)
   LA2A2:  inx                 ; increment index (x=x+1)
   LA2A3:  lslb            
   LA2A4:  brclr *BitFlags66, #$%00000100, LA2A9    ; branch if bit(s) clear
           incb            
   LA2A9:  abx                 ; add b to index
           ldaa 0x14, X        ; load a with memory at index + value
           tab                 ; b = a
           rts                 ; return from subroutine

AdaptiveMemory_UpdateCellIfRequired_MM:
           ldx  #AutoCalCell0    ; load index with value
           ldab PointerIntoAdaptiveMemory    ; load b with memory contents
           abx                 ; add b to index
           brset *CCDFlags1, #$%00100000, LA2BC    ; branch if bit(s) set
           ldaa CylTrim_Adaptive_Var1    ; load a with memory contents
           bne  LA2C1          ; branch if not equal (not zero)
   LA2BC:  bclr *CylTrim_FlagsE8, #$%00010000    ; clear bits
           bra  LA2EC          ; branch

   LA2C1:  ldY #Cyl2_InjPWTrim    ; load Y index -00000000 00101010-
           cmpb CL2PTR_Cyl2AdaptiveMemoryPointer    ; compare b with memory contents (data is 0d)
           beq  LA2DF          ; branch if equal (zero)
           inY                 ; increment Y
           cmpb CL1PTR_Cyl1AdaptiveMemoryPointer    ; compare b with memory contents (data is 03)
           beq  LA2DF          ; branch if equal (zero)
           inY                 ; increment Y
           cmpb CL3PTR_Cyl3AdaptiveMemoryPointer    ; compare b with memory contents (data is 04)
           beq  LA2DF          ; branch if equal (zero)
           inY                 ; increment Y
           cmpb CL4PTR_Cyl4AdaptiveMemoryPointer    ; compare b with memory contents (data is 05)
           bne  LA2EC          ; branch if not equal (not zero)
   LA2DF:  xgDY                ; exchange D and Y
           xgDX                ; exchange D and X
           brset *CylTrim_FlagsE8, #$%00010000, LA2EC    ; branch if bit(s) set
           clr  Counter_O2SensorFeedbackCount_Signed    ; zero byte at memory location
           bset *CylTrim_FlagsE8, #$%00010000    ; set bits
   LA2EC:  ldab AMUPDT_EPPsBetweenCalChangeUpdateOpenThrottle    ; load b with memory contents (data is 14)
           brset *BitFlags66, #$%10000000, UpdateAdaptive_OffIdle    ; branch if bit(s) set
           ldab AMUPDI_EPPsBetweenCalChangeUpdateClosedThrottle    ; load b with memory contents (data is 1a)
UpdateAdaptive_OffIdle:
           brset *BitFlags67, #$%00000100, DontUpdateCell_MaybeUpdateTimer    ; branch if bit(s) set
           stab Temp0          ; store b into memory
           ldd  InjectorPulsewidth_HB    ; load d (a&b) with memory contents
           addd Pulsewidth_PartThrottleEnrichment_HB    ; d = d + memory contents
           subd PWMIN_NoCellUpdateBelow_PWMIN_Pulsewidth    ;  (data is 00af)
           ldab Temp0          ; load b with memory contents
           bcs  DontUpdateCell_MaybeUpdateTimer    ; branch if lower
           sei                 ; disable interrupts
           ldaa AdaptiveCellUpdateTimer_IncrementedEveryCamRisingEdge    ; load a with memory contents
           sba                 ; subtract (a=a-b)
           bcs  DontUpdateCellOrTimer    ; branch if lower
           staa AdaptiveCellUpdateTimer_IncrementedEveryCamRisingEdge    ; store a into memory
           cli                 ; enable interrupts
           ldaa CELCHG_BitsChangePerUpdateWithinACell    ; load a with memory contents (data is 01)
           ldab Counter_O2SensorFeedbackCount_Signed    ; load b with memory contents
           bpl  LA318          ; branch if plus (hi bit 0)
           nega                ; negate a (set high bit)
   LA318:  ldab AMLIMH_MaxMultiplierCannotBeAbove7F    ; load b with memory contents (data is 7f)
           adda 0x00, X    
           bvc  Adaptive_Overflowed    ; branch if overflow
           ldaa 0x00, X        ; load a with memory at index + value
           bpl  Adaptive_SetCellToMaxOrMinValue    ; branch if plus (hi bit 0)
           ldab AMLIML_MinMultiplierCannotBeBelow80    ; load b with memory contents (data is 80)
           bra  Adaptive_SetCellToMaxOrMinValue    ; branch

Adaptive_Overflowed:
           cba             
           bge  Adaptive_SetCellToMaxOrMinValue    ; branch if greater or equal
           ldab AMLIML_MinMultiplierCannotBeBelow80    ; load b with memory contents (data is 80)
           cba             
           bge  LA332          ; branch if greater or equal
Adaptive_SetCellToMaxOrMinValue:
           tba                 ; a = b
   LA332:  staa 0x00, X    
DontUpdateCellOrTimer:
           cli                 ; enable interrupts
           ldaa 0x00, X        ; load a with memory at index + value
           staa ValueFromAdaptiveMemory    ; store a into memory
           rts                 ; return from subroutine

DontUpdateCell_MaybeUpdateTimer:
           ldaa 0x00, X        ; load a with memory at index + value
           staa ValueFromAdaptiveMemory    ; store a into memory
           ldaa AdaptiveCellUpdateTimer_IncrementedEveryCamRisingEdge    ; load a with memory contents
           cba             
           bcs  LA345          ; branch if lower
           stab AdaptiveCellUpdateTimer_IncrementedEveryCamRisingEdge    ; store b into memory
   LA345:  rts                 ; return from subroutine

AdaptiveMemory_DetermineWhichCellApplies_MM:
           clra                ; a = 0
           staa Temp0          ; store a into memory
           ldx  #MP1_AutoCalMapCellBoundary1    ; load index with value
           ldab PointerIntoAdaptiveMemory    ; load b with memory contents
           brset *BitFlags66, #$%10000000, ONTHROTTLE_OR_RPMTOOHIGHFORIDLE    ; branch if bit(s) set
           ldaa TargetIdleSpeedHB    ; load a with memory contents
           adda IDLOFS_DeltaForIdleRPMForClosedThrottleCell    ;  (data is 03)
           cmpb #0x0c          ;  -00001100-
           bcs  LA35E          ; branch if lower
           adda HYTRPM_HysteresisFor_IDLOFS    ;  (data is 02)
   LA35E:  cmpa EngineRpm_HB    ; compare a with memory contents
           bcs  ONTHROTTLE_OR_RPMTOOHIGHFORIDLE    ; branch if lower
           ldaB #0x0c          ; load b with value -00001100-
           brset *BitFlags_36, #$%00001000, LA395    ; branch if bit(s) set
           incb            
           bra  LA395          ; branch

   LA36B:  ldaa 0x00, X        ; load a with memory at index + value
           cmpb Temp0      
           bcc  LA374          ; branch if greater or equal
           adda DLTMAP_MapHysteresisAtMapCellBoundaries    ;  (data is 04)
   LA374:  cmpa MapValue       ; compare a with memory contents
           bcc  LA384          ; branch if greater or equal
           inx                 ; increment index (x=x+1)
ONTHROTTLE_OR_RPMTOOHIGHFORIDLE:
           ldaa Temp0          ; load a with memory contents
           adda #0x02          ;  -00000010-
           staa Temp0          ; store a into memory
           cpx  #MP5_AutoCalMapCellBoundary5    ;  -10001011 11011010-
           bls  LA36B          ; branch if lower or same
   LA384:  ldaa R1_RPMCellBoundaryInRPMover32    ; load a with memory contents (data is 40)
           lsrb                ; logical shift right b
           bcs  LA38D          ; branch if lower
           adda DLTRPM_DeltaRPMAtRPMBoundariesInRPMOver32    ;  (data is 03)
   LA38D:  ldab Temp0          ; load b with memory contents
           cmpa EngineRpm_HB    ; compare a with memory contents
           bcs  LA394          ; branch if lower
           decb            
   LA394:  decb            
   LA395:  cmpb PointerIntoAdaptiveMemory
           beq  LA3BB          ; branch if equal (zero)
           clra                ; a = 0
           staa AdaptiveCellUpdateTimer_IncrementedEveryCamRisingEdge    ; store a into memory
           staa CylTrim_Adaptive_Var1    ; store a into memory
           ldaa #0x80          ; load a with value -10000000-
           cmpb CL2PTR_Cyl2AdaptiveMemoryPointer    ; compare b with memory contents (data is 0d)
           beq  LA3B7          ; branch if equal (zero)
           lsra            
           cmpb CL1PTR_Cyl1AdaptiveMemoryPointer    ; compare b with memory contents (data is 03)
           beq  LA3B7          ; branch if equal (zero)
           lsra            
           cmpb CL3PTR_Cyl3AdaptiveMemoryPointer    ; compare b with memory contents (data is 04)
           beq  LA3B7          ; branch if equal (zero)
           lsra            
           cmpb CL4PTR_Cyl4AdaptiveMemoryPointer    ; compare b with memory contents (data is 05)
           bne  LA3BB          ; branch if not equal (not zero)
   LA3B7:  eora CylTrim_FlagsE7
           staa CylTrim_FlagsE7    ; store a into memory
   LA3BB:  stab PointerIntoAdaptiveMemory    ; store b into memory
           rts                 ; return from subroutine

HandleAmTimer_MM:
           brclr *BitFlags6e, #$%10000000, AMTimer_EngineRunning    ; branch if bit(s) clear
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #AMTPSW_TempPointToEnableSelectedAMTimer    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop    ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #CLTIME_ClosedLoopTimeFromEngTempAtStartup_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Timer_CLTIME_ClosedLoopTimer    ; store a into memory
           bclr *BitFlags66, #$%00100000    ; clear bits
AMTimer_EngineRunning:
           ldaa CoolantTemp    ; load a with memory contents
           ldab Counter_MainLoop    ; load b with memory contents
           bne  LA3F8          ; branch if not equal (not zero)
           cmpa AMTEMP_StartTempToSelectHotOrColdAMTimer    ; compare a with memory contents (data is ca)
           bcs  LA3EC          ; branch if lower
           ldab Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop    ; load b with memory contents
           beq  LA3F8          ; branch if equal (zero)
           decb
           stab Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop    ; store b into memory
           rts                 ; return from subroutine

   LA3EC:  bne  LA3F8          ; branch if not equal (not zero)
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #AMTPSW_TempPointToEnableSelectedAMTimer    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop    ; store a into memory
   LA3F8:  rts                 ; return from subroutine


;	.org	0xa3f9
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

;	.org	0xa421
DRBSerialToggles:
	.word	0x2020
	.word	0x3020
	.word	0x0020
	.word	0x2020
	.word	0x0030
	.word	0x3030
	.word	0x3030
	.word	0x2020
        .byte   0x20

;	.org	0xa432
ATMFunctionTable:
	.word	LA5FB
	.word	ATM_IgnitionCoil1
	.word	ATM_IgnitionCoil2
	.word	LA5FB
	.word	ATM_InjBank1
	.word	ATM_InjBank2
	.word	ATM_InjBank3
	.word	ATM_AISMotorOpenClose
	.word	ATM_FanRelay
	.word	ATM_ACClutchRelay
	.word	ATM_ASDRelay
	.word	ATM_PurgeSolenoid
	.word	ATM_SCServoSolenoid
	.word	LAA36
	.word	ATM_Tachometer
	.word	LA5FB
	.word	LA5FB
	.word	ATM_WGSolenoid
	.word	ATM_BaroReadSolenoid
	.word	LA5FB
	.word	ATM_AllSolenoidsRelays
	.word	LA5FB
	.word	LA5FB
	.word	LA5FB
	.word	LA5FB
	.word	LA5FB
	.word	LA5FB
	.word	LA5FB
	.word	LA9AC
	.word	ATM_InjBank4
	.word	LA5FB
	.word	LA5FB
	.word	LA5FB
;	.org	0xa474
	.word	LA5FB
	
DRBMemoryTable:
	.word	Temp0
	.word	O2SensorVolts
	.word	Temp0
	.word	Temp0
	.word	CoolantTemp
	.word	LastCoolantTempVolts
	.word	LastTPSVolts
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
	.word	BitFlagsC0
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
	.word	BodyComputerBatteryVoltsOutput
	.word	TargetBatteryVolts
	.word	Temp0
	.word	CurrentWastegatePosition
	.word	CCDFlags5
	.word	CurrentWastegatePosition
	.word	Temp0
	.word	BitFlags6f
	.word	Temp0
	.word	CruiseControlSwitchStateAnalogSnapshot
;	.org	0xa4ce
	.word	AmbientAirTempVolts

SwitchTestTable:
	.word	LA79C
	.word	LA7A0
	.word	LA7AC

;	.org	0xa4d6
RealTimeDataTable:
	.word	SCI_MAPVolts
	.word	SCI_Speed
	.word	SCI_O2Volts
	.word	EndRealTimeData
	.word	LA623
	.word	SendBaro
	.word	SendTPS
	.word	SendAdvance

DRBIISerialCommunications_MM:
           jsr  NULL_ROUTINE    ; call subroutine
           jsr  BYTE_MODE_SERIAL_CODE_DOWNLOAD_ROUTINE    ; call subroutine
           ldab DRBSerialMode    ; load b with memory contents
           bitb #0xc0          ;  -11000000-
           bne  LA55D          ; branch if not equal (not zero)
           ldaa CPU_SerialBaudRate    ; load a with memory contents
           anda #0x37          ; AND a with value -00110111-
           cmpa #0x22          ; compare a with value -00100010-
           beq  LA501          ; branch if equal (zero)
           ldaa #0x22          ; load a with value -00100010-
           staa CPU_SerialBaudRate
           rts                 ; return from subroutine

   LA501:  ldaa CPU_SerialStatus    ; load a with memory contents
           bitA #0x0e          ;  -00001110-
           beq  DRB_NoRxError    ; branch if equal (zero)
           ldaa CPU_SerialData    ; load a with memory contents
           rts                 ; return from subroutine

DRB_NoRxError:
           bita #0x20          ;  -00100000-
           bne  DRB_ChrRxd     ; branch if not equal (not zero)
           brset *DRBSerialMode, #$%00001111, DRB_Timeout    ; branch if bit(s) set
           incb            
           stab DRBSerialMode    ; store b into memory
           rts                 ; return from subroutine

DRB_Timeout:
           brclr *DRBSerialMode, #$%00110000, LA55D    ; branch if bit(s) clear
           bclr *DRBSerialMode, #$%00110000    ; clear bits
           clr  DRBPointer1    ; zero byte at memory location
           rts                 ; return from subroutine

DRB_ChrRxd:
           ldaa CPU_SerialData    ; load a with memory contents
           staa CPU_SerialData
           andb #0xf0          ;  -11110000-
           stab DRBSerialMode    ; store b into memory
           bitb #0x30          ;  -00110000-
           bne  DRB_StorePointer    ; branch if not equal (not zero)
           cmpa #0x14          ; compare a with value -00010100-
           beq  DRB_SetModeVar    ; branch if equal (zero)
           bclr *BitFlags6c, #$%00010000    ; clear bits
DRB_SetModeVar:
           staa DRBPointer1    ; store a into memory
           clrb                ; b = 0
           stab DRBPointer2    ; store b into memory
           stab DRBPointer3    ; store b into memory
           cmpa #0x23          ; compare a with value -00100011-
           bhi  LA55D          ; branch if higher
           suba #0x13          ;  -00010011-
           bcs  LA55D          ; branch if lower
           tab                 ; b = a
           ldx  #DRBSerialToggles    ; load index with value
           abx                 ; add b to index
           ldab 0x00, X        ; load b with memory at index + value
           orab DRBSerialMode
           stab DRBSerialMode    ; store b into memory
           rts                 ; return from subroutine

DRB_StorePointer:
           bitb #0x20          ;  -00100000-
           bne  LA55E          ; branch if not equal (not zero)
           staa DRBPointer3    ; store a into memory
           andb #0xcf          ;  -11001111-
           stab DRBSerialMode    ; store b into memory
   LA55D:  rts                 ; return from subroutine

   LA55E:  staa DRBPointer2    ; store a into memory
           andb #0xdf          ;  -11011111-
           stab DRBSerialMode    ; store b into memory
           rts                 ; return from subroutine

DRBIIOuput_MM:
           ldaa DRBSerialMode    ; load a with memory contents
           bita #0x30          ;  -00110000-
           bne  LA55D          ; branch if not equal (not zero)
           ldab DRBPointer1    ; load b with memory contents
           subb #0x10          ;  -00010000-
           bcs  LA55D          ; branch if lower
           cmpb #0x13          ;  -00010011-
           bhi  LA55D          ; branch if higher
           lslb            
           ldx  #DRBFunctionTable    ; load index with value
           abx                 ; add b to index
           ldx  0x00, X    
           jmp  0x00, X        ; indexed jump

OutputErrorCodes:
           ldx  #ErrorBitRegister0    ; load index with value
           ldab DRBPointer2    ; load b with memory contents
           cmpb #0x07          ;  -00000111-
           bhi  LA594          ; branch if higher
           negb            
           addb #0x07          ;  -00000111-
           abx                 ; add b to index
           inc  DRBPointer2
           ldaa 0x00, X        ; load a with memory at index + value
           beq  LA595          ; branch if equal (zero)
           bra  LA5B7          ; branch

   LA594:  dex                 ; decrement index (x=x-1)
   LA595:  clr  DRBPointer1    ; zero byte at memory location
           ldaa #0xfe          ; load a with value -11111110-
           jsr  SerialOutput1a    ; call subroutine
           adda #0x10          ;  -00010000-
   LA59F:  inx                 ; increment index (x=x+1)
           cpx  #ErrorCodeUpdateKeyOnCount    ;  -00000000 00100111-
           bcc  LA5B7          ; branch if greater or equal
           adda 0x00, X    
           bra  LA59F          ; branch

OutputErrorBits:
           ldaa ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB    ; load a with memory contents
           brclr *DRBPointer2, #$%11111111, LA5B4    ; branch if bit(s) clear
           ldaa ErrorBitsAssociatedWithPIA1AndReg1eTo25_LB    ; load a with memory contents
           clr  DRBPointer1    ; zero byte at memory location
   LA5B4:  inc  DRBPointer2
   LA5B7:  jmp  SerialOutput1a

SetupHiSpeedDataTransfer:
           bset *DRBSerialMode, #$%10000000    ; set bits
           clr  DRBPointer1    ; zero byte at memory location
   LA5C0:  ldaa CPU_SerialStatus    ; load a with memory contents
           bita #0x40          ;  -01000000-
           beq  LA5C0          ; branch if equal (zero)
           ldaA #0x01          ; load a with value -00000001-
           staa CPU_SerialBaudRate
DRB_Return:
           rts                 ; return from subroutine

SetupATM:
           clra                ; a = 0
           staa DRBPointer1    ; store a into memory
           ldab TimerOverflowsBetweenCamPulses    ; load b with memory contents
           cmpb #0x50          ;  -01010000-
           bls  LA5E6          ; branch if lower or same
           brset *BitFlags71, #$%00100000, LA5E6    ; branch if bit(s) set
           ldaa DRBPointer2    ; load a with memory contents
           cmpa #0x21          ; compare a with value -00100001-
           bhi  LA5E6          ; branch if higher
           ldaB #0x02          ; load b with value -00000010-
           stab KeyOnOrEngineRunningTime    ; store b into memory
           bra  LA5EA          ; branch

   LA5E6:  bclr *BitFlags71, #$%00100000    ; clear bits
           clra                ; a = 0
   LA5EA:  staa ATMOffset      ; store a into memory
           tab                 ; b = a
           lslb            
           beq  LA5FB          ; branch if equal (zero)
           ldx  #ATMFunctionTable    ; load index with value
           abx                 ; add b to index
           ldx  0x00, X    
           cpx  #LA5FB         ;  -10100101 11111011-
           bne  LA5B7          ; branch if not equal (not zero)
   LA5FB:  clra                ; a = 0
           staa ATMOffset      ; store a into memory
           jmp  SerialOutput1

SendDiagnosticDataToSCI:
           clrb                ; b = 0
           stab Temp0          ; store b into memory
           stab DRBPointer1    ; store b into memory
           ldab DRBPointer2    ; load b with memory contents
           beq  LA623          ; branch if equal (zero)
           cmpb #0x40          ;  -01000000-
           bcc  LA63B          ; branch if greater or equal
           cmpb #0x2d          ;  -00101101-
           bhi  LA623          ; branch if higher
           cmpb #0x10          ;  -00010000-
           bne  SendRealTImeDatatoSCI    ; branch if not equal (not zero)
           brset *BitFlags66, #$%10000000, LA623    ; branch if bit(s) set
           brset *BitFlags_36, #$%00001000, LA623    ; branch if bit(s) set
           bset *BitFlags6c, #$%00010000    ; set bits
           bra  SendRealTImeDatatoSCI    ; branch

   LA623:  bclr *BitFlags6c, #$%00010000    ; clear bits
           clrb                ; b = 0
           staa DRBPointer1    ; store a into memory
           rts                 ; return from subroutine

SendRealTImeDatatoSCI:
           ldx  #DRBMemoryTable-2    ; load index with value
           lslb            
           abx                 ; add b to index
           ldx  0x00, X    
           cpx  #Temp0         ;  -00000000 11110110-
           beq  LA623          ; branch if equal (zero)
           ldaa 0x00, X        ; load a with memory at index + value
           jmp  SerialOutput1a

   LA63B:  subb #0x40          ;  -01000000-
           cmpb #0x07          ;  -00000111-
           bhi  LA623          ; branch if higher
           ldx  #RealTimeDataTable        ; load index with value
           lslb            
           abx                 ; add b to index
           ldx  0x00, X    
           jmp  0x00, X        ; indexed jump

SCI_MAPVolts:
           sei                 ; disable interrupts
           ldaa #0x10          ; load a with value -00010000-
           staa CPU_A2DControlReg
           ldaA #0x07          ; load a with value -00000111-
   LA652:  deca                ; decrement a
           bne  LA652          ; branch if not equal (not zero)
           ldaa CPU_A2DResults1    ; load a with memory contents
           cli                 ; enable interrupts
           bra  LA664          ; branch

SCI_Speed:
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           bcc  LA664          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LA664:  jmp  SerialOutput1a

SCI_O2Volts:
           ldab O2SensorVolts    ; load b with memory contents
           ldaa #0xff          ; load a with value -11111111-
           cmpb O2HIGH_HighLimitForImmediateSwitchToClosedLoop    ; compare b with memory contents (data is 26)
           bhi  LA677          ; branch if higher
           cmpb O2LOW_LowLimitForImmediateSwitchToClosedLoop    ; compare b with memory contents (data is 0f)
           bhi  LA664          ; branch if higher
           anda #0xa0          ; AND a with value -10100000-
   LA677:  anda #0xb1          ; AND a with value -10110001-
           bra  LA664          ; branch

EndRealTimeData:
           clrb                ; b = 0
           brset *BitFlags66, #$%10000000, LA6B1    ; branch if bit(s) set
           brset *BitFlags6e, #$%10000000, LA6B1    ; branch if bit(s) set
           staa Timer_BaroReadInterval    ; store a into memory
           bclr *BitFlags68, #$%00100000    ; clear bits
           bset *BitFlags68, #$%10000000    ; set bits
           bclr *PIA_Buffer1, #pia_Baro    ; clear bits
           ldaa #0xe3          ; load a with value -11100011-
           bra  LA6B1          ; branch

SendBaro:
           ldaa BaroPressure    ; load a with memory contents
           suba MapValue   
           jmp  SerialOutput1a

SendTPS:
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bcc  LA6A1          ; branch if greater or equal
           clra                ; a = 0
   LA6A1:  ldab #0xfd          ; load b with value -11111101-
           staa Temp0          ; store a into memory
           mul                 ; multiply (d=a*b)
           adca Temp0      
           bcc  LA6AC          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LA6AC:  jmp  SerialOutput1a

SendAdvance:
           ldaa CalculatedSparkAdvance    ; load a with memory contents
   LA6B1:  jmp  SerialOutput1a

SendECUIDToSCI:
           clrb                ; b = 0
           staa DRBPointer1    ; store a into memory
           ldab DRBPointer3    ; load b with memory contents
           ldaa DRBPointer2    ; load a with memory contents
           xgDX                ; exchange D and X
           ldaa 0x00, X        ; load a with memory at index + value
           jmp  SerialOutput1a

SendConstValues:
           ldaa DRBPointer2    ; load a with memory contents
           cmpa #0x80          ; compare a with value -10000000-
           bne  LA6DF          ; branch if not equal (not zero)
           ldaa CPU_EEPROMControlReg    ; load a with memory contents
           bitA #0x02          ;  -00000010-
           bne  LA6F2          ; branch if not equal (not zero)
           ldY #ConstValueTable    ; load Y index -10100111 00110000-
           ldaa LB7EF          ; load a with memory contents (data is ff)
           cmpa #0x55          ; compare a with value -01010101-
           bne  LA6F3          ; branch if not equal (not zero)
           ldY #0xa738         ; load Y index -10100111 00111000-
           bra  LA6F3          ; branch

   LA6DF:  ldY #0xa740         ; load Y index -10100111 01000000-
           cmpa #0x81          ; compare a with value -10000001-
           beq  LA6F3          ; branch if equal (zero)
           ldY #0xa748         ; load Y index -10100111 01001000-
           cmpa #0x82          ; compare a with value -10000010-
           beq  LA6F3          ; branch if equal (zero)
           clr  DRBPointer1    ; zero byte at memory location
   LA6F2:  rts                 ; return from subroutine

   LA6F3:  ldab DRBPointer3    ; load b with memory contents
           lslb            
           aby                 ; add b to y
           ldX 0, Y        ; load X indexed to Y -00000000-
           ldaa 0x00, X        ; load a with memory at index + value
           inc  DRBPointer3
           brclr *DRBPointer3, #$%00000011, LA707    ; branch if bit(s) clear
           jmp  SerialOutput1a

   LA707:  jsr  SerialOutput1a    ; call subroutine
           adda #0x16          ;  -00010110-
           deY                 ; decrement Y
           deY                 ; decrement Y
           ldX 0, Y        ; load X indexed to Y -00000000-
           adda 0x00, X    
           deY                 ; decrement Y
           deY                 ; decrement Y
           ldX 0, Y        ; load X indexed to Y -00000000-
           adda 0x00, X    
           deY                 ; decrement Y
           deY                 ; decrement Y
           ldX 0, Y        ; load X indexed to Y -00000000-
           adda 0x00, X    
           ldab DRBPointer2    ; load b with memory contents
           aba                 ; a=a+b
           clr  DRBPointer1    ; zero byte at memory location
           bra  SerialOutput1a    ; branch


;	.org	0xa72f
LA72F:
	.byte	0x00

;	.org	0xa730
ConstValueTable:
	.word	ENDIT1_PNPrefix
	.word	ENDIT1_PNPrefix+1
	.word	ENDITM_ECUID
	.word	ENDITM_ECUID+1
	.word	RFINO3_
	.word	RFINO2_
	.word	RFINO1
	.word	RFINO0_
	.word	CODE13_
	.word	CODE12_
	.word	MDLCDE_ModelTypeCode
	.word	MDLCDE_ModelTypeCode+1
	.word	PARTREV_RevisionLevel
	.word	LA72F
	.word	LA72F
	.word	LA72F

   LA750:  clrb                ; b = 0
           staa DRBPointer1    ; store a into memory
SerialOutput1:
           clra                ; a = 0
SerialOutput1a:
           ldab CPU_SerialStatus    ; load b with memory contents
           bpl  SerialOutput1a    ; branch if plus (hi bit 0)
           staa CPU_SerialData
           rts                 ; return from subroutine

ClearErrorCodes:
           clr  DRBPointer1    ; zero byte at memory location
           ldab TimerOverflowsBetweenCamPulses    ; load b with memory contents
           cmpb #0x50          ;  -01010000-
           bhi  LA769          ; branch if higher
           jmp  SerialOutput1

   LA769:  ldaa BitFlags65     ; load a with memory contents
           inca                ; increment a
           cmpa #0x18          ; compare a with value -00011000-
           bls  LA782          ; branch if lower or same
           ldaa CPU_EEPROMControlReg    ; load a with memory contents
           bitA #0x01          ;  -00000001-
           bne  LA784          ; branch if not equal (not zero)
           jsr  ERASE_ERROR_CODES    ; call subroutine
           clrb                ; b = 0
           staa BitFlags65     ; store a into memory
           ldaa #0xe0          ; load a with value -11100000-
           jmp  SerialOutput1a

   LA782:  staa BitFlags65     ; store a into memory
   LA784:  ldaa #0xff          ; load a with value -11111111-
           bra  SerialOutput1a    ; branch

SwitchTest:
           clr  DRBPointer1    ; zero byte at memory location
           ldab DRBPointer2    ; load b with memory contents
           beq  LA7B6          ; branch if equal (zero)
           cmpb #0x03          ;  -00000011-
           bhi  LA7B6          ; branch if higher
           ldx  #SwitchTestTable-2    ; load index with value
           lslb            
           abx                 ; add b to index
           ldx  0x00, X    
           jmp  0x00, X        ; indexed jump

   LA79C:  ldaa StartupSwitchMirror1    ; load a with memory contents
           bra  SerialOutput1a    ; branch

   LA7A0:  ldaa CCDFlags1      ; load a with memory contents
           oraA #0x04          ;  -00000100-
           brclr *CurrentWastegatePosition, #$%11111111, LA7AA    ; branch if bit(s) clear
           anda #0xfb          ; AND a with value -11111011-
   LA7AA:  bra  SerialOutput1a    ; branch

   LA7AC:  ldaa PIA_Buffer1    ; load a with memory contents
           bra  SerialOutput1a    ; branch

InitByteModeDownload:
           bset *DRBSerialMode, #$%01000000    ; set bits
           clr  DRBPointer1    ; zero byte at memory location
   LA7B6:  rts                 ; return from subroutine

DRB_ResetEMR:
           clr  DRBPointer1    ; zero byte at memory location
           sei                 ; disable interrupts
           ldab BitFlags6a     ; load b with memory contents
           bitb #0x03          ;  -00000011-
           bne  LA7CF          ; branch if not equal (not zero)
           bset *BitFlags6a, #$%00000001    ; set bits
           cli                 ; enable interrupts
           ldaa DRBPointer3    ; load a with memory contents
           staa DRBOffsetStored_LB    ; store a into memory
           ldab DRBPointer2    ; load b with memory contents
           stab DRBOffsetStored_HB    ; store b into memory
           ldaa #0xe2          ; load a with value -11100010-
   LA7CF:  cli                 ; enable interrupts
           jmp  SerialOutput1a

DRB_UseRAMForSpecialProgramRoutine:
           ldx  #0x0000         ; load index with value
           bra  LA7F7          ; branch

DRB_UseRAM2ForSpecialProgramRoutine:
           ldx  #0x6480    ; load index with value
           bra  LA7F7          ; branch

DRB_CheckSpecialProgramSize:
           ldaa DRBPointer2    ; load a with memory contents
           bne  LA7F4          ; branch if not equal (not zero)
           ldx  #DRB_ProgramModeFlag    ; load index with value
           ldab DRBPointer3    ; load b with memory contents
           abx                 ; add b to index
           cpx  #0x64c9        ;  -01100100 11001001-
           bcs  LA7F4          ; branch if lower
           ldaa #0xff          ; load a with value -11111111-
           staa DRB_ProgramModeFlag
   LA7F1:  jmp  LA750      

   LA7F4:  ldx  #DRB_ProgramModeFlag    ; load index with value
   LA7F7:  clrb                ; b = 0
           staa DRBPointer1    ; store a into memory
           ldab DRBPointer2    ; load b with memory contents
           ldaa DRBPointer3    ; load a with memory contents
           abx                 ; add b to index
           staa 0x00, X    
           ldaa #0xe5          ; load a with value -11100101-
           jmp  SerialOutput1a

DRB_SpecialProgramMode:
           ldx  #DRB_ProgramModeFlag    ; load index with value
           ldab DRBPointer3    ; load b with memory contents
           cmpb 0x01, X    
           beq  LA814          ; branch if equal (zero)
           comb            
           cmpb 0x01, X    
           bne  DRB_OutputSpecialCodes    ; branch if not equal (not zero)
   LA814:  ldab DRBPointer2    ; load b with memory contents
           cmpb 0x00, X    
           bne  LA844          ; branch if not equal (not zero)
           abx                 ; add b to index
           ldaa 0x01, X        ; load a with memory at index + value
           cmpa #0x39          ; compare a with value -00111001-
           bne  LA7F1          ; branch if not equal (not zero)
           ldx  #DRB_ProgramModeFlag    ; load index with value
           clrb                ; b = 0
   LA825:  inx                 ; increment index (x=x+1)
           adda 0x01, X    
           decb            
           bne  LA825          ; branch if not equal (not zero)
           cmpa DRBPointer3    ; compare a with memory contents
           beq  LA838          ; branch if equal (zero)
           ldab DRBPointer3    ; load b with memory contents
           comb            
           cba             
           bne  DRB_OutputSpecialCodes    ; branch if not equal (not zero)
           jmp  DRB_SpecialProgramRoutine

   LA838:  com  DRBPointer3
           ldaa #0xe4          ; load a with value -11100100-
           jmp  SerialOutput1a

DRB_OutputSpecialCodes:
           ldaA #0x01          ; load a with value -00000001-
           bra  LA84A          ; branch

   LA844:  ldaA #0x02          ; load a with value -00000010-
           bra  LA84A          ; branch

   LA848:  ldaA #0x03          ; load a with value -00000011-
   LA84A:  clrb                ; b = 0
           stab DRBPointer1    ; store b into memory
           jmp  SerialOutput1a

DRB_Special1:
           clr  DRBPointer1    ; zero byte at memory location
           ldaa DRBPointer2    ; load a with memory contents
           bne  LA85E          ; branch if not equal (not zero)
           clrb                ; b = 0
   LA858:  bclr *BitFlags6c, #$%00100000    ; clear bits
           jmp  SerialOutput1a

   LA85E:  ldaA #0x02          ; load a with value -00000010-
           brset *BitFlags66, #$%10000000, LA858    ; branch if bit(s) set
           ldaA #0x03          ; load a with value -00000011-
           brset *BitFlags_36, #$%00001000, LA858    ; branch if bit(s) set
           bset *BitFlags6c, #$%00100000    ; set bits
           ldaA #0x01          ; load a with value -00000001-
           jmp  SerialOutput1a

DRB_Special2:
           ldaa DRBPointer3    ; load a with memory contents
           beq  LA897          ; branch if equal (zero)
           ldaa DRBPointer2    ; load a with memory contents
           cmpa #0x01          ; compare a with value -00000001-
           beq  LA88F          ; branch if equal (zero)
           cmpa #0x02          ; compare a with value -00000010-
           beq  LA893          ; branch if equal (zero)
           cmpa #0x03          ; compare a with value -00000011-
           bne  LA89B          ; branch if not equal (not zero)
           ldd  TargetIdleSpeedHB    ; load d (a&b) with memory contents
   LA886:  stab Temp0          ; store b into memory
           jsr  SerialOutput1a    ; call subroutine
           ldaa Temp0          ; load a with memory contents
           bra  LA84A          ; branch

   LA88F:  ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           bra  LA886          ; branch

   LA893:  ldd  InjectorPulsewidth_HB    ; load d (a&b) with memory contents
           bra  LA886          ; branch

   LA897:  coma
           staa DRBPointer3    ; store a into memory
           rts                 ; return from subroutine

   LA89B:  clrb                ; b = 0
           staa DRBPointer1    ; store a into memory
           rts                 ; return from subroutine

DRB_ClearAdaptiveMemory:
           clrb                ; b = 0
           staa DRBPointer1    ; store a into memory
           ldaa TimerOverflowsBetweenCamPulses    ; load a with memory contents
           cmpa #0x50          ; compare a with value -01010000-
           bhi  LA8AB          ; branch if higher
           jmp  SerialOutput1

   LA8AB:  ldaa DRBPointer2    ; load a with memory contents
           cmpa #0x01          ; compare a with value -00000001-
           beq  LA8F8          ; branch if equal (zero)
           cmpa #0x02          ; compare a with value -00000010-
           beq  LA8D4          ; branch if equal (zero)
           cmpa #0x03          ; compare a with value -00000011-
           beq  LA8C9          ; branch if equal (zero)
           cmpa #0x04          ; compare a with value -00000100-
           beq  LA8C2          ; branch if equal (zero)
           ldaA #0x01          ; load a with value -00000001-
           jmp  SerialOutput1a

   LA8C2:  ldaa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load a with memory contents (data is 5c)
           staa MINTHR_LowestSessionTPS    ; store a into memory
           bra  LA901          ; branch

   LA8C9:  sei                 ; disable interrupts
           bset *BitFlags_AIS, #$%01000000    ; set bits
           ldaa #0xdf          ; load a with value -11011111-
           staa CurrentAisPosition    ; store a into memory
           cli                 ; enable interrupts
           bra  LA901          ; branch

   LA8D4:  clra                ; a = 0
           staa ValueFromAdaptiveMemory    ; store a into memory
           staa CylTrim_Adaptive_Var1    ; store a into memory
           staa CylTrimFlags    ; store a into memory
           staa CylTrim_FlagsE7    ; store a into memory
           staa Cyl2_InjPWTrim    ; store a into memory
           staa Cyl1_InjPWTrim    ; store a into memory
           staa Cyl3_InjPWTrim    ; store a into memory
           staa Cyl4_InjPWTrim    ; store a into memory
           bset *BitFlags67, #$%00000100    ; set bits
           bset *CylTrimFlags, #$%00100000    ; set bits
           ldx  #AutoCalCell0    ; load index with value
   LA8EE:  staa 0x00, X    
           inx                 ; increment index (x=x+1)
           cpx  #ErrorBitRegister0    ;  -00000000 00011111-
           bcs  LA8EE          ; branch if lower
           bra  LA901          ; branch

   LA8F8:  ldaa CPU_EEPROMControlReg    ; load a with memory contents
           bitA #0x01          ;  -00000001-
           bne  LA905          ; branch if not equal (not zero)
           bsr  ERASE_ERROR_CODES    ; call subroutine
   LA901:  ldaa #0xf0          ; load a with value -11110000-
           bra  LA907          ; branch

   LA905:  ldaA #0x02          ; load a with value -00000010-
   LA907:  jmp  SerialOutput1a

ERASE_ERROR_CODES:
           ldd  #0x0000         ; load d (a&b) with value -00000000 00000000-
           stD *ErrorBitRegister0    ; store D to RAM
           stD *ErrorBitRegister2    ; store D to RAM
           stD *ErrorBitRegisterStored0    ; store D to RAM
           stD *ErrorBitRegisterStored2    ; store D to RAM
           staa b5c_IPL1       ; store a into memory
           staa b5d_IPL2       ; store a into memory
           staa ErrorCodeUpdateKeyOnCount    ; store a into memory
           staa ErrorCodeUpdateKeyOnCount2    ; store a into memory
           staa ErrorCodeUpdateKeyOnCount3    ; store a into memory
           staa DRBPointer1    ; store a into memory
           ldaa LB620          ; load a with memory contents (data is ff)
           inca                ; increment a
           beq  LA958          ; branch if equal (zero)
           ldx  #0xB620         ; load index with value
           bsr  LA939          ; call subroutine
           ldx  #0xb630        ; load index with value
           bsr  LA939          ; call subroutine
           ldx  #0xb640        ; load index with value
           bsr  LA939          ; call subroutine
           ldx  #0xb650        ; load index with value
   LA939:  brset  0, X, #$%11111111, LA958    ; branch if bit(s) set
           ldaA #0x0e          ; load a with value -00001110-
           staa CPU_EEPROMControlReg
           stab 0x00, X    
           inca                ; increment a
           staa CPU_EEPROMControlReg
           ldx  #0x1a0a        ; load index with value
   LA94B:  dex                 ; decrement index (x=x-1)
           bne  LA94B          ; branch if not equal (not zero)
           deca                ; decrement a
           staa CPU_EEPROMControlReg
           clr  CPU_EEPROMControlReg    ; zero byte at memory location
           jmp  ResetCopTimer

   LA958:  rts                 ; return from subroutine

ActuatorTestMode_MM:
           ldaa ATMOffset      ; load a with memory contents
           beq  LA966          ; branch if equal (zero)
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa #0x99          ; compare a with value -10011001-
           bcs  LA967          ; branch if lower
           clrb                ; b = 0
           stab ATMOffset      ; store b into memory
   LA966:  rts                 ; return from subroutine

   LA967:  ldaa PIA_Buffer1    ; load a with memory contents
           ldx  #ATMFunctionTable    ; load index with value
           ldab ATMOffset      ; load b with memory contents
           lslb            
           abx                 ; add b to index
           ldx  0x00, X    
           jmp  0x00, X        ; indexed jump

ATM_FanRelay:
           anda #0x7f          ; AND a with value -01111111-
           brclr *Counter_MainLoop, #$%01110000, LA9F7    ; branch if bit(s) clear
           oraa #0x80          ;  -10000000-
           bra  LA9F7          ; branch

ATM_ACClutchRelay:
           ldaa CCDFlags1      ; load a with memory contents
           oraA #0x01          ;  -00000001-
           ldab CONFIG_ConfigurationFlags    ; load b with memory contents (data is 91)
           bitb #0x80          ;  -10000000-
           beq  LA98C          ; branch if equal (zero)
           bclr *PIA_Buffer1, #pia_Fan    ; clear bits
   LA98C:  brset *Counter_MainLoop, #$%10000000, LA992    ; branch if bit(s) set
           anda #0xfe          ; AND a with value -11111110-
   LA992:  jmp  LA9BA      

ATM_ASDRelay:
           ldaa CCDFlags1      ; load a with memory contents
           ldab CPU_TimerControlReg1    ; load b with memory contents
           andb #0xea          ;  -11101010-
           orab #0x2a          ;  -00101010-
           stab CPU_TimerControlReg1    ; store b into memory
           ldaB #0x08          ; load b with value -00001000-
           stab CPU_HardwareTimerForceCompare    ; store b into memory
           oraa #0x10          ;  -00010000-
           brset *Counter_MainLoop, #$%10000000, LA9BA    ; branch if bit(s) set
   LA9AC:  anda #0xef          ; AND a with value -11101111-
           bra  LA9BA          ; branch

ATM_PurgeSolenoid:
           ldaa CCDFlags1      ; load a with memory contents
           oraa #0x20          ;  -00100000-
           brset *Counter_MainLoop, #$%10000000, LA9BA    ; branch if bit(s) set
           anda #0xdf          ; AND a with value -11011111-
   LA9BA:  staa CCDFlags1      ; store a into memory
           rts                 ; return from subroutine

ATM_WGSolenoid:
           clra                ; a = 0
           brset *Counter_MainLoop, #$%10000000, LA9C4    ; branch if bit(s) set
           ldaa #0xc8          ; load a with value -11001000-
   LA9C4:  cmpb #0x22          ;  -00100010-
           beq  LA9CC          ; branch if equal (zero)
           cmpb #0x40          ;  -01000000-
           bne  LA9D8          ; branch if not equal (not zero)
   LA9CC:  staa CurrentWastegatePosition    ; store a into memory
           beq  LA9D4          ; branch if equal (zero)
           bclr *CCDFlags1, #$%00000100    ; clear bits
           rts                 ; return from subroutine

   LA9D4:  bset *CCDFlags1, #$%00000100    ; set bits
           rts                 ; return from subroutine

   LA9D8:  rts                 ; return from subroutine

ATM_SCServoSolenoid:
           ldaa CCDFlags1      ; load a with memory contents
           oraa #0xc0          ;  -11000000-
           ldab Counter_MainLoop    ; load b with memory contents
           cmpb #0x55          ;  -01010101-
           bcs  LA9BA          ; branch if lower
           anda #0x3f          ; AND a with value -00111111-
           cmpb #0xaa          ;  -10101010-
           bcs  LA9BA          ; branch if lower
           oraa #0x80          ;  -10000000-
           bra  LA9BA          ; branch

ATM_BaroReadSolenoid:
           ldaa PIA_Buffer1    ; load a with memory contents
           anda #~pia_Baro          ; AND a with value -11101111-
           brset *Counter_MainLoop, #$%10000000, LA9F7    ; branch if bit(s) set
           oraa #pia_Baro          ;  -00010000-
   LA9F7:  staa PIA_Buffer1    ; store a into memory
           rts                 ; return from subroutine

ATM_AllSolenoidsRelays:
           ldab CPU_TimerControlReg1    ; load b with memory contents
           andb #0xea          ;  -11101010-
           orab #0x2a          ;  -00101010-
           stab CPU_TimerControlReg1    ; store b into memory
           ldaB #0x08          ; load b with value -00001000-
           stab CPU_HardwareTimerForceCompare    ; store b into memory
           ldaa CCDFlags1      ; load a with memory contents
           oraa #0xf5          ;  -11110101-
           ldab DRBPointer1    ; load b with memory contents
           cmpb #0x18          ;  -00011000-
           bne  LAA15          ; branch if not equal (not zero)
           anda #0xef          ; AND a with value -11101111-
   LAA15:  clrb                ; b = 0
           brclr *Counter_MainLoop, #$%10000000, LAA20    ; branch if bit(s) clear
           ldaa CCDFlags1      ; load a with memory contents
           andA #0x0a          ; AND a with value -00001010-
           ldab #0xc8          ; load b with value -11001000-
   LAA20:  staa CCDFlags1      ; store a into memory
           stab CurrentWastegatePosition    ; store b into memory
           ldaa PIA_Buffer1    ; load a with memory contents
           oraa #pia_Fan | pia_Baro          ;  -10010000-
           ldab #0x10          ; load b with value -00010000-
           brclr *Counter_MainLoop, #$%10000000, LAA32    ; branch if bit(s) clear
           anda #~(pia_Fan | pia_Baro)          ; AND a with value -01101111-
           ldab #0x70          ; load b with value -01110000-
   LAA32:  staa PIA_Buffer1    ; store a into memory
           stab DesiredNewAisPosition    ; store b into memory
   LAA36:  ldab CPU_TimerControlReg1    ; load b with memory contents
           andb #0xee          ;  -11101110-
           stab CPU_TimerControlReg1    ; store b into memory
           ldab #0x28          ; load b with value -00101000-
           stab CPU_HardwareTimerForceCompare    ; store b into memory
           bclr *CCDFlags1, #$%00010000    ; clear bits
           sei                 ; disable interrupts
           ldx  #SwitchPortAccessReg1    ; load index with value
           brclr *Counter_MainLoop, #$%10000000, LAA56    ; branch if bit(s) clear
           bset 0, X, #$%00000100    ; bit set -00000000-
           bset *BitFlags70, #$%00000100    ; set bits
           bra  LAA5C          ; branch

   LAA56:  bclr 0, X, #$%00000100    ; bit clear -00000000-
           bclr *BitFlags70, #$%00000100    ; clear bits
   LAA5C:  bset 2, X, #$%00000100    ; bit set -00000010-
           ldaa #0x12          ; load a with value -00010010-
   LAA61:  deca                ; decrement a
           bne  LAA61          ; branch if not equal (not zero)
           bclr 2, X, #$%00000100    ; bit clear -00000010-
           cli                 ; enable interrupts
           rts                 ; return from subroutine

ATM_Tachometer:
           ldaa PIA_Buffer2    ; load a with memory contents
           eora #pia_Tach          ; XOR a with value -00000010-
           staa PortX_Control
           staa PIA_Buffer2    ; store a into memory
           rts                 ; return from subroutine

ATM_AISMotorOpenClose:
           ldaa #0x10          ; load a with value -00010000-
           brset *Counter_MainLoop, #$%10000000, LAA7B    ; branch if bit(s) set
           ldaa #0x70          ; load a with value -01110000-
   LAA7B:  staa DesiredNewAisPosition    ; store a into memory
           rts                 ; return from subroutine

ATM_IgnitionCoil1:
           ldx  #CPU_Timer_OC5_DwellB    ; load index with value
           ldaA #0x03          ; load a with value -00000011-
           ldaB #0x08          ; load b with value -00001000-
           bra  LAA8E          ; branch

ATM_IgnitionCoil2:
           ldx  #CPU_Timer_OC3_Wastegate    ; load index with value
           ldaa #0x30          ; load a with value -00110000-
           ldab #0x20          ; load b with value -00100000-
   LAA8E:  bclr *CCDFlags1, #$%00010000    ; clear bits
           brset *Counter_MainLoop, #$%01111111, LAA96    ; branch if bit(s) set
           rts                 ; return from subroutine

   LAA96:  sei                 ; disable interrupts
           oraa CPU_TimerControlReg1
           staa CPU_TimerControlReg1
           stab CPU_HardwareTimerForceCompare    ; store b into memory
           ldd  #0x0abe        ; load d (a&b) with value -00001010 10111110-
           addd CPU_TimerCounterRegHigh
           std  0x00, X        ; store d into index plus offset
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           anda #0x2e          ; AND a with value -00101110-
           staa CPU_TimerControlReg1
           cli                 ; enable interrupts
           rts                 ; return from subroutine

ATM_InjBank1:
           ldx  #InjectorPulsewidth_HB_Cyl1    ; load index with value
           bra  LAAC4          ; branch

ATM_InjBank2:
           ldx  #InjectorPulsewidth_HB_Cyl2    ; load index with value
           bra  LAAC4          ; branch

ATM_InjBank3:
           ldx  #InjectorPulsewidth_HB_Cyl3    ; load index with value
           bra  LAAC4          ; branch

ATM_InjBank4:
           ldx  #InjectorPulsewidth_HB_Cyl4    ; load index with value
   LAAC4:  ldaa Counter_MainLoop    ; load a with memory contents
           lsla                ; logical shift left a
           bne  LAACE          ; branch if not equal (not zero)
           ldd  #Temp4         ; load d (a&b) with value -00000000 11111010-
           std  0x00, X        ; store d into index plus offset
   LAACE:  bclr *CCDFlags1, #$%00010000    ; clear bits
           rts                 ; return from subroutine

CaculateChecksum:
           ldx  #IDENT1_IDCode_1    ; load index with value
           ldd  #0x9200        ; load d (a&b) with value -10010010 00000000-
           stD *Temp0          ; store D to RAM
           clra                ; a = 0
   LAADB:  ldaB #0x08          ; load b with value -00001000-
           cpx  #LB600         ;  -10110110 00000000-
           bne  LAAEB          ; branch if not equal (not zero)
           inc  Temp0      
           inc  Temp0      
           ldx  #LB800         ; load index with value
   LAAEB:  adda 0x00, X    
           adda 0x01, X    
           adda 0x02, X    
           adda 0x03, X    
           adda 0x04, X    
           adda 0x05, X    
           adda 0x06, X    
           adda 0x07, X    
           abx                 ; add b to index
           cpx  Temp0      
           bne  LAAEB          ; branch if not equal (not zero)
           brclr *Temp0, #$%11111111, LAB11    ; branch if bit(s) clear
           psha                ; push a onto stack
           jsr  ResetCopTimer    ; call subroutine
           ldaa #0x12          ; load a with value -00010010-
           adda Temp0      
           staa Temp0          ; store a into memory
           pula                ; pull a from stack
           bra  LAADB          ; branch

   LAB11:  cmpa ENDITM_ECUID+1       ; compare a with memory contents (data is 42)
           beq  LAB1C          ; branch if equal (zero)
           ldd  #0x0201        ; load d (a&b) with value -00000010 00000001-
           jmp  ThrowNonCriticalError

   LAB1C:  rts                 ; return from subroutine

MUCK_WITH_CEL:
           ldaa Counter_MainLoop    ; load a with memory contents
           lsla                ; logical shift left a
           lsla                ; logical shift left a
           bne  LAB79          ; branch if not equal (not zero)
           ldaa LastCamFallingEdgeTime    ; load a with memory contents
           bita #0x70          ;  -01110000-
           beq  LAB2F          ; branch if equal (zero)
           suba #0x10          ;  -00010000-
           bita #0x70          ;  -01110000-
           bne  LAB77          ; branch if not equal (not zero)
   LAB2F:  ldab PIA_Buffer1    ; load b with memory contents
           eorb #pia_CEL          ;  -01000000-
           stab PIA_Buffer1    ; store b into memory
           bitA #0x0f          ;  -00001111-
           beq  LAB42          ; branch if equal (zero)
           deca                ; decrement a
           bitA #0x0f          ;  -00001111-
           beq  LAB42          ; branch if equal (zero)
           oraa #0x10          ;  -00010000-
           bra  LAB77          ; branch

   LAB42:  tsta                ; test a
           bmi  LAB7A          ; branch if minus(hi bit 1)
           ldaa #0xaa          ; load a with value -10101010-
           ldab DRBPointer2    ; load b with memory contents
           cmpb #0xfe          ;  -11111110-
           beq  LAB6B          ; branch if equal (zero)
           tstb            
           bmi  LAB77          ; branch if minus(hi bit 1)
           cmpb #0x08          ;  -00001000-
           bcs  LAB5E          ; branch if lower
           ldx  #0xb618        ; load index with value
           abx                 ; add b to index
           brset  0, X, #$%11111111, LABC0    ; branch if bit(s) set
           bra  LAB65          ; branch

   LAB5E:  negb            
           addb #0x07          ;  -00000111-
           ldx  #ErrorBitRegister0    ; load index with value
           abx                 ; add b to index
   LAB65:  ldab 0x00, X        ; load b with memory at index + value
           beq  LAB77          ; branch if equal (zero)
           bra  LAB6C          ; branch

   LAB6B:  clrb                ; b = 0
   LAB6C:  ldx  #ErrorCodesToDash_Table    ; load index with value
           abx                 ; add b to index
           ldaa 0x00, X        ; load a with memory at index + value
           andA #0x0f          ; AND a with value -00001111-
           lsla                ; logical shift left a
           oraa #0xa0          ;  -10100000-
   LAB77:  staa LastCamFallingEdgeTime    ; store a into memory
   LAB79:  rts                 ; return from subroutine

   LAB7A:  ldab DRBPointer2    ; load b with memory contents
           cmpb #0xff          ;  -11111111-
           bne  LAB8C          ; branch if not equal (not zero)
           ldaa ErrorCodeUpdateKeyOnCount    ; load a with memory contents
           cmpa #0x32          ; compare a with value -00110010-
           bhi  LAB8C          ; branch if higher
           decb            
           stab DRBPointer2    ; store b into memory
           clrb                ; b = 0
           bra  LABB1          ; branch

   LAB8C:  cmpb #0xfe          ;  -11111110-
           bne  LAB91          ; branch if not equal (not zero)
           incb            
   LAB91:  incb            
           stab DRBPointer2    ; store b into memory
           cmpb #0x08          ;  -00001000-
           bcs  LABA6          ; branch if lower
           brset *DRBPointer2, #$%10000000, LABC7    ; branch if bit(s) set
           ldx  #0xb618        ; load index with value
           abx                 ; add b to index
           brset  0, X, #$%11111111, LABC0    ; branch if bit(s) set
           bra  LABAD          ; branch

   LABA6:  negb            
           addb #0x07          ;  -00000111-
           ldx  #ErrorBitRegister0    ; load index with value
           abx                 ; add b to index
   LABAD:  ldab 0x00, X        ; load b with memory at index + value
           beq  LABC0          ; branch if equal (zero)
   LABB1:  ldx  #ErrorCodesToDash_Table    ; load index with value
           abx                 ; add b to index
           ldaa 0x00, X        ; load a with memory at index + value
           lsra            
           lsra            
           lsra            
           lsra            
           lsla                ; logical shift left a
           oraa #0x40          ;  -01000000-
           bra  LAB77          ; branch

   LABC0:  bset *DRBPointer2, #$%10000000    ; set bits
           ldaa #0x4a          ; load a with value -01001010-
           bra  LAB77          ; branch

   LABC7:  clrb                ; b = 0
           staa DRBPointer1    ; store a into memory
           staa DRBPointer2    ; store a into memory
           rts                 ; return from subroutine


;	.org	0xabcd
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
	.word	0x2300
	.word	0x0027
	.word	0x2167
	.word	0x0066
	.byte   0x66

;	.org	0xac10
PIA_ControllerJumpTable2:
	.word	PIA_Jump5
	.word	PIA_Jump6
	.word	PIA_Jump7
	.word	PIA_Jump6
	.word	PIA_Jump8
	.word	PIA_Jump9
	.word	PIA_Jump6
	.word	PIA_Jump6

;	.org	0xac20
LAC20:
	.word	CPU_TimerControlReg1
	.word	0x0000
	.word	0x0D20
	.word	0x0000
	.word	0x0A20
	.word	0x1220
	.word	0x0F20
	.word	0x0F20

;	.org	0xac30
PIA_ControllerJumpTable:
	.word	PIA_Jump1
	.word	PIA_Jump1
	.word	PIA_Jump2
	.word	PIA_Jump1
	.word	PIA_Jump3
	.word	PIA_Jump1
	.word	PIA_Jump1
	.word	PIA_Jump4

;	.org	0xac40
LAC40:
	.word	0x0000
	.word	0x0000
	.word	0x1920
	.word	0x0000
	.word	0x2F20
	.word	0x0000
	.word	0x0000
	.word	0x0E20

ThrowCriticalError:
           ldx  #CONFIG_ConfigurationFlags    ; load index with value
           brclr  0, X, #$%01000000, ThrowNonCriticalError    ; branch if bit(s) clear
           brset *b5d_IPL2, #$%01000000, ThrowNonCriticalError    ; branch if bit(s) set
           orab #0x80          ;  -10000000-
ThrowNonCriticalError:
           ldx  #FLTMSK1_ErrorBitsMask1    ; load index with value
   LAC60:  brclr  0, X, #$%11111111, LAC6B    ; branch if bit(s) clear
           cmpa 0x00, X        ; compare a with memory at index + value
           beq  LACAD          ; branch if equal (zero)
           inx                 ; increment index (x=x+1)
           bra  LAC60          ; branch

   LAC6B:  tstb            
           bmi  LAC76          ; branch if minus(hi bit 1)
           cmpa ErrorBitRegisterStored3    ; compare a with memory contents
           beq  LACAA          ; branch if equal (zero)
           cmpa ErrorBitRegisterStored2    ; compare a with memory contents
           beq  LACA0          ; branch if equal (zero)
   LAC76:  andb #0x7f          ;  -01111111-
           cmpb #0x01          ;  -00000001-
           beq  LACB4          ; branch if equal (zero)
           stab Temp0          ; store b into memory
           ldx  #ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB    ; load index with value
           cmpa 0x00, X        ; compare a with memory at index + value
           beq  LAC93          ; branch if equal (zero)
           inx                 ; increment index (x=x+1)
           cmpa 0x00, X        ; compare a with memory at index + value
           beq  LAC93          ; branch if equal (zero)
           tst  0x00, X    
           beq  LAC93          ; branch if equal (zero)
           dex                 ; decrement index (x=x-1)
           tst  0x00, X    
           bne  LACAD          ; branch if not equal (not zero)
   LAC93:  staa 0x00, X    
           ldab 0x02, X        ; load b with memory at index + value
           incb            
           cmpb Temp0      
           bcc  LACB0          ; branch if greater or equal
           stab 0x02, X    
           clc                 ; clear carry
           rts                 ; return from subroutine

   LACA0:  ldd  ErrorBitRegisterStored2    ; load d (a&b) with memory contents
           staa ErrorBitRegisterStored3    ; store a into memory
           stab ErrorBitRegisterStored2    ; store b into memory
           ldaa ErrorCodeUpdateKeyOnCount    ; load a with memory contents
           staa ErrorCodeUpdateKeyOnCount2    ; store a into memory
   LACAA:  clra                ; a = 0
           staa ErrorCodeUpdateKeyOnCount    ; store a into memory
   LACAD:  clra                ; a = 0
           clc                 ; clear carry
           rts                 ; return from subroutine

   LACB0:  clr  0x00, X    
           clr  0x02, X    
   LACB4:  ldx  #ErrorBitRegister0    ; load index with value
   LACB7:  cmpa 0x00, X        ; compare a with memory at index + value
           bne  LACC0          ; branch if not equal (not zero)
           clrb                ; b = 0
           stab 0x00, X    
           bra  LACC8          ; branch

   LACC0:  inx                 ; increment index (x=x+1)
           cpx  #ErrorBitRegisterStored3    ;  -00000000 00100110-
           bls  LACB7          ; branch if lower or same
           ldab #0xff          ; load b with value -11111111-
   LACC8:  stab Temp0          ; store b into memory
           ldx  #ErrorBitRegisterStored3    ; load index with value
           ldY #ErrorCodeUpdateKeyOnCount    ; load Y index -00000000 00100111-
   LACD1:  cpx  #ErrorBitRegisterStored1    ;  -00000000 00100100-
           bcs  LACE4          ; branch if lower
           psha                ; push a onto stack
           ldaB 0, Y       ; load B with value indexed to Y -00000000-
           ldaa Temp0          ; load a with memory contents
           staA 0, Y       ; store A with value indexed to Y -00000000-
           inY                 ; increment Y
           stab Temp0          ; store b into memory
           pula                ; pull a from stack
   LACE4:  ldab 0x00, X        ; load b with memory at index + value
           staa 0x00, X    
           tba                 ; a = b
           beq  LAD20          ; branch if equal (zero)
           dex                 ; decrement index (x=x-1)
           cpx  #ErrorBitRegister0    ;  -00000000 00011111-
           bcc  LACD1          ; branch if greater or equal
           clrb                ; b = 0
           stab ErrorCodeUpdateKeyOnCount    ; store b into memory
           sei                 ; disable interrupts
           ldab BitFlags6f     ; load b with memory contents
           bitb #0x03          ;  -00000011-
           bne  LAD1D          ; branch if not equal (not zero)
           bset *BitFlags6f, #$%00000001    ; set bits
           cli                 ; enable interrupts
           staa DRBOffsetStored_LB    ; store a into memory
           ldx  #0xb61f        ; load index with value
   LAD04:  inx                 ; increment index (x=x+1)
           cpx  #0xb660        ;  -10110110 01100000-
           bhi  LAD1A          ; branch if higher
           ldab 0x00, X        ; load b with memory at index + value
           cba             
           beq  LAD1A          ; branch if equal (zero)
           incb            
           bne  LAD04          ; branch if not equal (not zero)
           xgDX                ; exchange D and X
           subd #LB600         ;  -10110110 00000000-
           stab DRBOffsetStored_HB    ; store b into memory
           bra  LAD1D          ; branch

   LAD1A:  bclr *BitFlags6f, #$%00000001    ; clear bits
   LAD1D:  cli                 ; enable interrupts
           bra  LAD32          ; branch

   LAD20:  cpY  #ErrorCodeUpdateKeyOnCount3    ; compare Y to memory 16-bit
           bhi  LAD2F          ; branch if higher
           ldab ErrorCodeUpdateKeyOnCount    ; load b with memory contents
           beq  LAD32          ; branch if equal (zero)
           ldab Temp0          ; load b with memory contents
           staB 0, Y       ; store B to location indexed to Y -00000000-
   LAD2F:  clrb                ; b = 0
           stab ErrorCodeUpdateKeyOnCount    ; store b into memory
   LAD32:  sec                 ; set carry
           rts                 ; return from subroutine

UpdatePIA1AndCheckOuputs_MM:
           ldaa PIA_Buffer1    ; load a with memory contents
           brclr *BitFlags6d, #$%00001000, LAD45    ; branch if bit(s) clear
           bclr *BitFlags6d, #$%00001000    ; clear bits
           adda #0xc8          ;  -11001000-
           staa Temp0          ; store a into memory
           ldaa #0x1f          ; load a with value -00011111-
           bra  LAD4B          ; branch

   LAD45:  adda #pia_bit3 | pia_bit1 | pia_bit0          ;  -00001011-
           staa Temp0          ; store a into memory
           ldaa #0x62          ; load a with value -01100010-
   LAD4B:  staa Temp1          ; store a into memory
           ldab #0x40          ; load b with value -01000000-
           ldaa #0x61          ; load a with value -01100001-
           ldY #CPU_PortA      ; load Y index -00010000 00000000-
           ldx  #SwitchPortAccessReg1    ; load index with value
           bset 0, X, #$%00001000    ; bit set -00000000-
           sei                 ; disable interrupts
           bclr 8, Y, #$%00100000    ; bit clear -00001000-
           cmpb CPU_SerialPeripheralStatus    ; compare b with memory contents
           staa CPU_SerialPeripheralDataIO
           bset 2, X, #$%00001000    ; bit set -00000010-
           bclr 2, X, #$%00001000    ; bit clear -00000010-
           nop                 ; no operation
           ldaa CPU_SerialPeripheralDataIO    ; load a with memory contents
           cmpa CPU_SerialPeripheralStatus    ; compare a with memory contents
           ldaa Temp1          ; load a with memory contents
   LAD75:  brclr  0, X, #$%00001000, LAD7F    ; branch if bit(s) clear
           decb            
           bne  LAD75          ; branch if not equal (not zero)
           jmp  LAEAC      

   LAD7F:  staa CPU_SerialPeripheralDataIO
           bset 2, X, #$%00001000    ; bit set -00000010-
           bclr 2, X, #$%00001000    ; bit clear -00000010-
           nop                 ; no operation
           ldaa CPU_SerialPeripheralDataIO    ; load a with memory contents
           staa Temp1          ; store a into memory
           cmpa CPU_SerialPeripheralStatus    ; compare a with memory contents
           ldaA #0x08          ; load a with value -00001000-
   LAD93:  brclr  0, X, #$%00001000, LAD9D    ; branch if bit(s) clear
           decb            
           bne  LAD93          ; branch if not equal (not zero)
           jmp  LAEAC      

   LAD9D:  staa CPU_SerialPeripheralDataIO
           bset 2, X, #$%00001000    ; bit set -00000010-
           bclr 2, X, #$%00001000    ; bit clear -00000010-
           nop                 ; no operation
           ldaa CPU_SerialPeripheralDataIO    ; load a with memory contents
           staa Temp2          ; store a into memory
           cmpa CPU_SerialPeripheralStatus    ; compare a with memory contents
           ldaa PIA_Buffer1    ; load a with memory contents
   LADB1:  brclr  0, X, #$%00001000, LADBB    ; branch if bit(s) clear
           decb            
           bne  LADB1          ; branch if not equal (not zero)
           jmp  LAEAC      

   LADBB:  staa CPU_SerialPeripheralDataIO
           bset 2, X, #$%00001000    ; bit set -00000010-
           bclr 2, X, #$%00001000    ; bit clear -00000010-
           nop                 ; no operation
           ldaa CPU_SerialPeripheralDataIO    ; load a with memory contents
           staa Temp3          ; store a into memory
           cmpa CPU_SerialPeripheralStatus    ; compare a with memory contents
           ldaa #0x40          ; load a with value -01000000-
   LADCF:  brclr  0, X, #$%00001000, LADD9    ; branch if bit(s) clear
           decb            
           bne  LADCF          ; branch if not equal (not zero)
           jmp  LAEAC      

   LADD9:  staa CPU_SerialPeripheralDataIO
           bset 2, X, #$%00001000    ; bit set -00000010-
           bclr 2, X, #$%00001000    ; bit clear -00000010-
           nop                 ; no operation
           ldaa CPU_SerialPeripheralDataIO    ; load a with memory contents
           staa Temp4          ; store a into memory
           cmpa CPU_SerialPeripheralStatus    ; compare a with memory contents
           ldaa Temp0          ; load a with memory contents
   LADED:  brclr  0, X, #$%00001000, LADF7    ; branch if bit(s) clear
           decb            
           bne  LADED          ; branch if not equal (not zero)
           jmp  LAEAC      

   LADF7:  staa CPU_SerialPeripheralDataIO
           bset 2, X, #$%00001000    ; bit set -00000010-
           bclr 2, X, #$%00001000    ; bit clear -00000010-
           nop                 ; no operation
   LAE01:  brset 41, Y, #$%10000000, LAE0C    ; branch if bit(s) set -00101001-
           decb            
           bne  LAE01          ; branch if not equal (not zero)
           jmp  LAEAC      

   LAE0C:  ldaa CPU_SerialPeripheralDataIO    ; load a with memory contents
           bset 8, Y, #$%00100000    ; bit set -00001000-
           cli                 ; enable interrupts
           ldab Temp1          ; load b with memory contents
           addb Temp2          ; b=b+memory contents
           addb Temp3          ; b=b+memory contents
           addb Temp4          ; b=b+memory contents
           cba             
           bne  LAE6E          ; branch if not equal (not zero)
           ldaa Temp2          ; load a with memory contents
           anda #0xf1          ; AND a with value -11110001-
           ldab StartupSwitchMirror1    ; load b with memory contents
           andb #0x0e          ;  -00001110-
           aba                 ; a=a+b
           staa StartupSwitchMirror1    ; store a into memory
           ldaa Temp4          ; load a with memory contents
           oraa FDRVar3        ; OR a with memory contents
           staa FDRVar3        ; store a into memory
           anda PIBMSK_PIA1BDDRMask    ;  (data is 94)
           ldab BatteryVolts    ; load b with memory contents
           cmpb #0xa2          ;  -10100010-
           bcs  LAE6E          ; branch if lower
           ldab CountdownTimerFromKeyOn    ; load b with memory contents
           bne  LAE6E          ; branch if not equal (not zero)
           ldx  #PIA_ControllerJumpTable    ; load index with value
           ldY #LAC40          ; load Y index -10101100 01000000-
           ldab Counter_MainLoop    ; load b with memory contents
           andb #0x07          ;  -00000111-
           lslb            
           aby                 ; add b to y
           abx                 ; add b to index
           ldx  0x00, X    
           jmp  0x00, X        ; indexed jump

PIA_Jump4:
           anda #0x80          ; AND a with value -10000000-
           beq  LAE6E          ; branch if equal (zero)
           bclr *FDRVar3, #$%10000000    ; clear bits
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 91)
           bitA #0x08          ;  -00001000-
           beq  LAE68          ; branch if equal (zero)
           brset *BitFlags6e, #$%10000000, LAE6E    ; branch if bit(s) set
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa #0x0a          ; compare a with value -00001010-
           bhi  LAE6E          ; branch if higher
   LAE68:  ldD 0x00, Y       ; load accumulator D -00000000-
           jsr  ThrowNonCriticalError    ; call subroutine
   LAE6E:  bra  PIA_Jump1      ; branch

PIA_Jump3:
           anda #0x10          ; AND a with value -00010000-
           beq  PIA_Jump1      ; branch if equal (zero)
           bclr *FDRVar3, #$%00010000    ; clear bits
           jsr  LAF64          ; call subroutine
           bra  PIA_Jump1      ; branch

PIA_Jump2:
           brset *BitFlags6c, #$%01000000, LAEA7    ; branch if bit(s) set
           bitA #0x01          ;  -00000001-
           bne  LAEA4          ; branch if not equal (not zero)
           andA #0x04          ; AND a with value -00000100-
           beq  LAEA4          ; branch if equal (zero)
           ldD 0x00, Y       ; load accumulator D -00000000-
           brset *BitFlags6d, #$%01000000, LAE94    ; branch if bit(s) set
           ldaB #0x04          ; load b with value -00000100-
           bset *BitFlags6d, #$%00001000    ; set bits
   LAE94:  orab #0x80          ;  -10000000-
           jsr  ThrowCriticalError    ; call subroutine
           bcc  LAEA7          ; branch if greater or equal
           bset *b5d_IPL2, #$%01000000    ; set bits
           bset *BitFlags6c, #$%01000000    ; set bits
           bclr *BitFlags6d, #$%00001000    ; clear bits
   LAEA4:  bset *BitFlags6d, #$%01000000    ; set bits
   LAEA7:  bclr *FDRVar3, #$%00000101    ; clear bits
           bra  PIA_Jump1      ; branch

   LAEAC:  bset 8, Y, #$%00100000    ; bit set -00001000-
           cli                 ; enable interrupts
           ldd  #0x4488        ; load d (a&b) with value -01000100 10001000-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  PIA_Jump1      ; branch if greater or equal
           ldaa SwitchPortAccessReg1    ; load a with memory contents
           anda #0xfe          ; AND a with value -11111110-
           staa SwitchPortAccessReg1
           oraA #0x01          ;  -00000001-
           staa SwitchPortAccessReg1
PIA_Jump1:
           sei                 ; disable interrupts
           ldab CPU_SerialPeripheralControl    ; load b with memory contents
           oraB #0x01          ;  -00000001-
           stab CPU_SerialPeripheralControl    ; store b into memory
           bclr *PIA_Buffer2, #pia_bit2    ; clear bits
           ldab PIA_Buffer2    ; load b with memory contents
           stab PortX_Control    ; store b into memory
           ldaa CCDFlags1      ; load a with memory contents
           cmpa CPU_SerialPeripheralStatus    ; compare a with memory contents
           staa CPU_SerialPeripheralDataIO
           mul                 ; multiply (d=a*b)
           mul                 ; multiply (d=a*b)
           nop                 ; no operation
           bset *PIA_Buffer2, #pia_bit2    ; set bits
           ldaa PIA_Buffer2    ; load a with memory contents
           staa PortX_Control
           ldaa CPU_SerialPeripheralDataIO    ; load a with memory contents
           ldab CPU_SerialPeripheralControl    ; load b with memory contents
           andb #0xfc          ;  -11111100-
           stab CPU_SerialPeripheralControl    ; store b into memory
           staa CCDFlags4      ; store a into memory
           eora CCDFlags2  
           anda PIAMSK_PIA1ADDRMask    ;  (data is 35)
           ldab CCDFlags2      ; load b with memory contents
           stab CCDFlags3      ; store b into memory
           ldab CCDFlags1      ; load b with memory contents
           stab CCDFlags2      ; store b into memory
           cli                 ; enable interrupts
           ldab BatteryVolts    ; load b with memory contents
           cmpb #0xa2          ;  -10100010-
           bcs  PIA_Return     ; branch if lower
           ldab CountdownTimerFromKeyOn    ; load b with memory contents
           bne  PIA_Return     ; branch if not equal (not zero)
           ldx  #PIA_ControllerJumpTable2    ; load index with value
           ldY #LAC20          ; load Y index -10101100 00100000-
           ldab Counter_MainLoop    ; load b with memory contents
           andb #0x07          ;  -00000111-
           lslb            
           abx                 ; add b to index
           aby                 ; add b to y
           ldx  0x00, X    
           jmp  0x00, X        ; indexed jump

PIA_Return:
           rts                 ; return from subroutine

PIA_Jump5:
           andA #0x01          ; AND a with value -00000001-
           beq  PIA_Return     ; branch if equal (zero)
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 91)
           bitA #0x08          ;  -00001000-
           bne  LAF40          ; branch if not equal (not zero)
           bita #0x80          ;  -10000000-
           bne  LAF42          ; branch if not equal (not zero)
           ldab KeyOnOrEngineRunningTime    ; load b with memory contents
           cmpb #0x0a          ;  -00001010-
           bcs  PIA_Return     ; branch if lower
           brset *BitFlags6e, #$%10000000, PIA_Return    ; branch if bit(s) set
           brset *StartupSwitchMirror1, #sw1_bit7, PIA_Return    ; branch if bit(s) set
   LAF40:  bra  PIA_Error      ; branch

   LAF42:  brset *PIA_Buffer1, #pia_Fan, PIA_Return    ; branch if bit(s) set
           bra  PIA_Error      ; branch

PIA_Jump7:
           andA #0x04          ; AND a with value -00000100-
           beq  LAF5D          ; branch if equal (zero)
           brset *b5d_IPL2, #$%00100000, LAF5D    ; branch if bit(s) set
           ldD 0x00, Y       ; load accumulator D -00000000-
           orab #0x80          ;  -10000000-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LAF5D          ; branch if greater or equal
           bset *b5d_IPL2, #$%00100000    ; set bits
   LAF5D:  rts                 ; return from subroutine

PIA_Jump8:
           anda #0x10          ; AND a with value -00010000-
           bra  LAF72          ; branch

PIA_Jump9:
           anda #0x20          ; AND a with value -00100000-
   LAF64:  beq  PIA_Return     ; branch if equal (zero)
           ldD 0x00, Y       ; load accumulator D -00000000-
           jsr  ThrowCriticalError    ; call subroutine
           bcc  LAF71          ; branch if greater or equal
           bset *b5d_IPL2, #$%01000000    ; set bits
   LAF71:  rts                 ; return from subroutine

   LAF72:  beq  PIA_Return     ; branch if equal (zero)
PIA_Error:
           ldD 0x00, Y       ; load accumulator D -00000000-
           jmp  ThrowNonCriticalError


	;.org	0xaf7a
ErrorBitManipulation_Table:
	.byte	0x2a,0x89,0x10,0x01,0x20,0x00,0xff,0x7f
	.byte	0x00,0x2b,0x89,0x10,0xff,0x7f,0x00,0xff
	.byte	0x7f,0x00,0xff,0x7f,0x00,0x26,0x8a,0x80

ProcessErrorBits_WorkWithData_MM:
           brclr *BitFlags5E, #$%11111111, PIA_Jump6    ; branch if bit(s) clear
           ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           bne  PIA_Jump6      ; branch if not equal (not zero)
           ldd  #0x0000         ; load d (a&b) with value -00000000 00000000-
           sec                 ; set carry
   LAF9E:  rola            
           bcs  PIA_Jump6      ; branch if lower
           addb #0x03          ;  -00000011-
           bita BitFlags5E 
           beq  LAF9E          ; branch if equal (zero)
           ldx  #ErrorBitManipulation_Table-3        ; load index with value
           abx                 ; add b to index
           stD *Temp3          ; store D to RAM
           coma            
           sei                 ; disable interrupts
           anda BitFlags5E     ; logical and a with memory contents
           staa BitFlags5E     ; store a into memory
           cli                 ; enable interrupts
           ldd  0x00, X    
           tstb            
           bpl  LAFBC          ; branch if plus (hi bit 0)
           bset *Temp4, #$%10000000    ; set bits
   LAFBC:  jsr  ThrowNonCriticalError    ; call subroutine
           brclr *Temp4, #$%10000000, LAFD5    ; branch if bit(s) clear
           bcc  LAFD5          ; branch if greater or equal
           ldx  #ErrorBitManipulation_Table-3        ; load index with value
           ldab Temp4          ; load b with memory contents
           andb #0x7f          ;  -01111111-
           abx                 ; add b to index
           ldaa 0x02, X        ; load a with memory at index + value
           sei                 ; disable interrupts
           oraa b5c_IPL1       ; OR a with memory contents
           staa b5c_IPL1       ; store a into memory
           cli                 ; enable interrupts
   LAFD5:  ldd  Temp3          ; load d (a&b) with memory contents
           andb #0x7f          ;  -01111111-
           clc                 ; clear carry
           bra  LAF9E          ; branch

SimulateMapReadingFromTps:
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb #0x7e          ;  -01111110-
           ldaA #0x00          ; load a with value -00000000-
           bcc  LAFF8          ; branch if greater or equal
           subb #0x10          ;  -00010000-
           bcc  LAFE9          ; branch if greater or equal
           clrb                ; b = 0
   LAFE9:  ldaa #0x52          ; load a with value -01010010-
           mul                 ; multiply (d=a*b)
           adca MINTHR_LowestSessionTPS
           tab                 ; b = a
           ldaa TpsVolts       ; load a with memory contents
           adda THROFF_OffsetAddedToCalcThrottle    ;  (data is 0b)
           sba                 ; subtract (a=a-b)
           bcc  LAFF8          ; branch if greater or equal
           clra                ; a = 0
   LAFF8:  ldx  #LMPINN_LimpinTableForMapFromThrottle    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           adda MPLMOF_OffsetForCalcMapInMapLimpin    ;  (data is 20)
PIA_Jump6:
           rts                 ; return from subroutine

DetectAlternatorFault_MM:
           ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x1f          ;  -00011111-
           bne  LB029          ; branch if not equal (not zero)
           brset *BitFlags6e, #$%10000000, LB029    ; branch if bit(s) set
           ldaa BatteryVolts    ; load a with memory contents
           suba TargetBatteryVolts
           bcs  LB026          ; branch if lower
           cmpa #0x10          ; compare a with value -00010000-
           bcs  LB026          ; branch if lower
           brset *b5c_IPL1, #$%00000100, LB029    ; branch if bit(s) set
           ldd  #0x06a0        ; load d (a&b) with value -00000110 10100000-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LB029          ; branch if greater or equal
           bset *b5c_IPL1, #$%00000100    ; set bits
           rts                 ; return from subroutine

   LB026:  bclr *b5c_IPL1, #$%00000100    ; clear bits
   LB029:  rts                 ; return from subroutine

CheckIfCheckEngineLightShouldBeOn_MM:
           brclr *BitFlags6e, #$%10000000, LB048    ; branch if bit(s) clear
           ldaa DRBPointer1    ; load a with memory contents
           cmpa #0x0a          ; compare a with value -00001010-
           bne  LB037          ; branch if not equal (not zero)
           jmp  MUCK_WITH_CEL

   LB037:  cmpa #0x18          ; compare a with value -00011000-
           bne  LB042          ; branch if not equal (not zero)
           ldaa Counter_MainLoop    ; load a with memory contents
           lsla                ; logical shift left a
           bmi  TurnCheckEngineLightOnAndOff    ; branch if minus(hi bit 1)
           bra  LB06B          ; branch

   LB042:  ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           bne  TurnCheckEngineLightOnAndOff    ; branch if not equal (not zero)
           bra  LB06B          ; branch

   LB048:  ldd  KeyOnOrEngineRunningTime    ; load d (a&b) with memory contents
           cmpD #0x0003         ; compare D -00000000 00000011-
           bls  TurnCheckEngineLightOnAndOff    ; branch if lower or same
           brclr *PIA_Buffer1, #pia_CEL, LB072    ; branch if bit(s) clear
           ldaa b5c_IPL1       ; load a with memory contents
           bita IPLMSK_PowerLossLightMask    ;  (data is f7)
           bne  LB06B          ; branch if not equal (not zero)
           ldaa b5d_IPL2       ; load a with memory contents
           ldab CONFIG_ConfigurationFlags    ; load b with memory contents (data is 91)
           bitb #0x40          ;  -01000000-
           bne  LB066          ; branch if not equal (not zero)
           anda #0x3f          ; AND a with value -00111111-
   LB066:  bita IPLMSK2_PowerLossLightMask2    ;  (data is 35)
           beq  TurnCheckEngineLightOnAndOff    ; branch if equal (zero)
   LB06B:  bclr *PIA_Buffer1, #pia_CEL    ; clear bits
           rts                 ; return from subroutine

TurnCheckEngineLightOnAndOff:
           bset *PIA_Buffer1, #pia_CEL    ; set bits
   LB072:  rts                 ; return from subroutine

UpdateErrorTimersAndPossiblyClearErrors_MM:
           ldaa Counter_MainLoop    ; load a with memory contents
           bne  LB09C          ; branch if not equal (not zero)
           ldd  ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB    ; load d (a&b) with memory contents
           tsta                ; test a
           beq  LB084          ; branch if equal (zero)
           dec  ClearTheErrorTimer_0    ; decrement memory contents
           bne  LB084          ; branch if not equal (not zero)
           clr  ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB    ; zero byte at memory location
   LB084:  tstb
           beq  LB08F          ; branch if equal (zero)
           dec  ClearTheErrorTimer_1    ; decrement memory contents
           bne  LB08F          ; branch if not equal (not zero)
           clr  ErrorBitsAssociatedWithPIA1AndReg1eTo25_LB    ; zero byte at memory location
   LB08F:  ldaa ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; load a with memory contents
           beq  LB09C          ; branch if equal (zero)
           suba #0x10          ;  -00010000-
           bita #0xf0          ;  -11110000-
           bne  LB09A          ; branch if not equal (not zero)
           clra                ; a = 0
   LB09A:  staa ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; store a into memory
   LB09C:  ldaa BitFlags6e     ; load a with memory contents
           bita #0x81          ;  -10000001-
           bne  LB0D6          ; branch if not equal (not zero)
           bset *BitFlags6e, #$%00000001    ; set bits
           brclr *ErrorBitRegisterStored3, #$%11111111, LB0CF    ; branch if bit(s) clear
           ldaa ErrorCodeUpdateKeyOnCount    ; load a with memory contents
           cmpa #0x32          ; compare a with value -00110010-
           bcs  LB0B9          ; branch if lower
           ldaa CPU_EEPROMControlReg    ; load a with memory contents
           bitA #0x01          ;  -00000001-
           bne  LB0D6          ; branch if not equal (not zero)
           jmp  ERASE_ERROR_CODES

   LB0B9:  ldaa ErrorBitRegisterStored1    ; load a with memory contents
           beq  LB0C4          ; branch if equal (zero)
           ldaa ErrorCodeUpdateKeyOnCount3    ; load a with memory contents
           inca                ; increment a
           beq  LB0C4          ; branch if equal (zero)
           staa ErrorCodeUpdateKeyOnCount3    ; store a into memory
   LB0C4:  ldaa ErrorBitRegisterStored2    ; load a with memory contents
           beq  LB0CF          ; branch if equal (zero)
           ldaa ErrorCodeUpdateKeyOnCount2    ; load a with memory contents
           inca                ; increment a
           beq  LB0CF          ; branch if equal (zero)
           staa ErrorCodeUpdateKeyOnCount2    ; store a into memory
   LB0CF:  ldaa ErrorCodeUpdateKeyOnCount    ; load a with memory contents
           inca                ; increment a
           beq  LB0D6          ; branch if equal (zero)
           staa ErrorCodeUpdateKeyOnCount    ; store a into memory
   LB0D6:  rts                 ; return from subroutine

CheckForErrorsAndSetCodes_MM:
           brset *BitFlags6e, #$%10000000, LB128    ; branch if bit(s) set
           ldaa CoolantTemp    ; load a with memory contents
           cmpa ERRTMP_CoolantTempLimitforErrorCodeSetting    ; compare a with memory contents (data is a0)
           bcs  LB128          ; branch if lower
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 91)
           bita #0x20          ;  -00100000-
           beq  LB0ED          ; branch if equal (zero)
           brclr *BitFlags_36, #$%00001000, LB128    ; branch if bit(s) clear
   LB0ED:  ldd  KeyOnOrEngineRunningTime    ; load d (a&b) with memory contents
           cmpa #0x0b          ; compare a with value -00001011-
           bcs  LB128          ; branch if lower
           bitb #0x1f          ;  -00011111-
           bne  LB128          ; branch if not equal (not zero)
           brset *StartupSwitchMirror1, #sw1_Brake, LB128    ; branch if bit(s) set
           brclr *BitFlags66, #$%10000000, LB128    ; branch if bit(s) clear
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa ERRRPM_RPMLimitforErrorCodeSetting    ; compare a with memory contents (data is 38)
           bcs  LB128          ; branch if lower
           ldaa BaroPressure    ; load a with memory contents
           suba MapValue   
           bcc  LB10D          ; branch if greater or equal
           clra                ; a = 0
   LB10D:  cmpa ERRMAP_MAPLimitforErrorCodeSetting    ; compare a with memory contents (data is 2b)
           bcc  LB128          ; branch if greater or equal
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           cmpD #Cyl2_InjPWTrim    ; compare D -00000000 00101010-
           bcc  LB128          ; branch if greater or equal
           ldd  #0x2320        ; load d (a&b) with value -00100011 00100000-
           jsr  ThrowCriticalError    ; call subroutine
           bcc  LB128          ; branch if greater or equal
           bset *b5d_IPL2, #$%01000000    ; set bits
           bset *BitFlags6b, #$%00100000    ; set bits
   LB128:  rts                 ; return from subroutine

ThrowMajorErrorIfRequired_MM:
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 91)
           bita #0x40          ;  -01000000-
           beq  LB138          ; branch if equal (zero)
           brclr *BitFlags67, #$%00000001, LB13B    ; branch if bit(s) clear
           bset *b5d_IPL2, #$%01000000    ; set bits
           rts                 ; return from subroutine

   LB138:  bclr *b5d_IPL2, #$%01000000    ; clear bits
   LB13B:  rts                 ; return from subroutine


	.org	0xb600
LB600:
	.chem 3 n LB600 in_desc 0 65535 in Y 0 256 out LB600 Detailed_Description
	.byte	0xff

	.org	0xb612
LB612:
	.chem 3 n LB612 in_desc 0 65535 in Y 0 256 out LB612 Detailed_Description
	.byte	0xff

	.org	0xb613
LB613:
	.chem 3 n LB613 in_desc 0 65535 in Y 0 256 out LB613 Detailed_Description
	.byte	0xff

	.org	0xb616
LB616:
	.chem 3 n LB616 in_desc 0 65535 in Y 0 256 out LB616 Detailed_Description
	.byte	0xff

	.org	0xb617
LB617:
	.chem 3 n LB617 in_desc 0 65535 in Y 0 256 out LB617 Detailed_Description
	.byte	0xff
	.byte	0xff

	.org	0xb620
LB620:
	.chem 3 n LB620 in_desc 0 65535 in Y 0 256 out LB620 Detailed_Description
	.byte	0xff

	.org	0xb7e0
LB7E0:
	.chem 3 n LB7E0 in_desc 0 65535 in Y 0 256 out LB7E0 Detailed_Description
	.byte	0xff

	.org	0xb7e1
LB7E1:
	.chem 3 n LB7E1 in_desc 0 65535 in Y 0 256 out LB7E1 Detailed_Description
	.byte	0xff

	.org	0xb7ef
LB7EF:
	.chem 3 n LB7EF in_desc 0 65535 in Y 0 256 out LB7EF Detailed_Description
	.byte	0xff

	.org	0xb800
LB800:
	.word	0x1513
	.word   0x3d14

VerifyOperationOfFuelInjectorDrivers_MM:
           ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           bne  LB87A          ; branch if not equal (not zero)
           ldaa SwitchPortAccessReg1    ; load a with memory contents
           bita #0x10          ;  -00010000-
           beq  LB85B          ; branch if equal (zero)
           sei                 ; disable interrupts
           ldaa SwitchPortAccessReg2    ; load a with memory contents
           anda #0xf0          ; AND a with value -11110000-
           bne  LB85B          ; branch if not equal (not zero)
           brclr *BitFlags6f, #$%00100000, LB85B    ; branch if bit(s) clear
           brset *b5d_IPL2, #$%00010000, LB852    ; branch if bit(s) set
           ldaB #0x04          ; load b with value -00000100-
   LB821:  decb            
           bne  LB821          ; branch if not equal (not zero)
           ldaB #0x04          ; load b with value -00000100-
           bitb PIA_Ctrl_4 
           bne  LB854          ; branch if not equal (not zero)
           ldab BitFlags6f     ; load b with memory contents
           ldx  #LB800         ; load index with value
           brset *BitFlags71, #$%10000000, LB838    ; branch if bit(s) set
           brset *BitFlagsC0, #$%00000100, LB839    ; branch if bit(s) set
   LB838:  decb            
   LB839:  cli                 ; enable interrupts
           ldx  #LB800         ; load index with value
           andb #0x03          ;  -00000011-
           abx                 ; add b to index
           ldaa 0x00, X        ; load a with memory at index + value
           ldab #0x89          ; load b with value -10001001-
           brset *BitFlags6e, #$%10000000, LB84A    ; branch if bit(s) set
           ldab #0xa0          ; load b with value -10100000-
   LB84A:  jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LB852          ; branch if greater or equal
           bset *b5d_IPL2, #$%00010000    ; set bits
   LB852:  ldaB #0x04          ; load b with value -00000100-
   LB854:  cli                 ; enable interrupts
           stab PIA_Ctrl_4     ; store b into memory
           bclr *BitFlags6f, #$%00100000    ; clear bits
   LB85B:  sei                 ; disable interrupts
           ldaa SwitchPortAccessReg1    ; load a with memory contents
           bita #0x10          ;  -00010000-
           beq  LB879          ; branch if equal (zero)
           eora BitFlags70 
           cli                 ; enable interrupts
           bitA #0x04          ;  -00000100-
           beq  LB87A          ; branch if equal (zero)
           brset *b5d_IPL2, #$%00000001, LB87A    ; branch if bit(s) set
           ldd  #0x0ba0        ; load d (a&b) with value -00001011 10100000-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LB87A          ; branch if greater or equal
           bset *b5d_IPL2, #$%00000001    ; set bits
   LB879:  cli                 ; enable interrupts
   LB87A:  rts                 ; return from subroutine

VerifyOperationOfMapSensor_MM:
           ldaa Counter_MainLoop    ; load a with memory contents
           bitA #0x07          ;  -00000111-
           bne  LB8F5          ; branch if not equal (not zero)
           brset *b5c_IPL1, #$%10000000, LB8C2    ; branch if bit(s) set
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           cmpD #0x0040    ; compare D -00000000 01000000-
           bcc  LB8C2          ; branch if greater or equal
           brset *BitFlags66, #$%10000000, LB8C2    ; branch if bit(s) set
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  LB899          ; branch if greater or equal
           coma            
           comb            
   LB899:  cmpD MPRMPD_CheckMapAtZeroSpeedAndThisDeltaRpm    ; compare D (data is 02)
           bcc  LB8C2          ; branch if greater or equal
           brset *BitFlags6e, #$%10000000, LB8C2    ; branch if bit(s) set
           ldaa BaroPressure    ; load a with memory contents
           tab                 ; b = a
           suba MapValue   
           bcs  LB8B7          ; branch if lower
           ldx  #MPVACD_AllowMapToTestGoodThisNearBaro    ; load index with value
           cmpb BAROSW_CheckMapAtZeroSpeedAndThisBaroSwitch    ; compare b with memory contents (data is 62)
           bcc  LB8B3          ; branch if greater or equal
           inx                 ; increment index (x=x+1)
   LB8B3:  cmpa 0x00, X        ; compare a with memory at index + value
           bcc  LB8C2          ; branch if greater or equal
   LB8B7:  ldd  #0x2794        ; load d (a&b) with value -00100111 10010100-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LB8C2          ; branch if greater or equal
           bset *b5c_IPL1, #$%10000000    ; set bits
   LB8C2:  ldx  EngineRpm_HB
           cpx  #0x2ee0        ;  -00101110 11100000-
           bcc  LB8F5          ; branch if greater or equal
           ldab TpsVolts       ; load b with memory contents
           subb MINTHR_LowestSessionTPS    ; b = b-memory contents
           bcs  LB8D4          ; branch if lower
           cmpb MPLTHR_ThrottleLevelAbove_MINTHR_ToMatureMapLimpin    ; compare b with memory contents (data is 42)
           bcc  LB8F5          ; branch if greater or equal
   LB8D4:  ldaa CPU_A2DResults1    ; load a with memory contents
           cmpa MAPHIG_MapSensorUpperLimit    ; compare a with memory contents (data is ee)
           bcc  LB8E6          ; branch if greater or equal
           cmpa MAPLOW_MapSensorLowerLimit    ; compare a with memory contents (data is 01)
           bcc  LB8F6          ; branch if greater or equal
           ldd  #0x2494        ; load d (a&b) with value -00100100 10010100-
           bra  LB8E9          ; branch

   LB8E6:  ldd  #0x2594        ; load d (a&b) with value -00100101 10010100-
   LB8E9:  brset *b5c_IPL1, #$%00100000, LB8F5    ; branch if bit(s) set
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LB8F5          ; branch if greater or equal
           bset *b5c_IPL1, #$%00100000    ; set bits
   LB8F5:  rts                 ; return from subroutine

   LB8F6:  brclr *b5c_IPL1, #$%00100000, LB8F5    ; branch if bit(s) clear
           ldaA #0x06          ; load a with value -00000110-
ResetErrorCodeIfTimerExpired:
           andA #0x0f          ; AND a with value -00001111-
           ldab ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; load b with memory contents
           beq  LB909          ; branch if equal (zero)
           andb #0x0f          ;  -00001111-
           cba             
           bne  LB90F          ; branch if not equal (not zero)
           ldaa ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; load a with memory contents
   LB909:  adda #0x10          ;  -00010000-
           bcs  SELECT_ERROR_BIT_POSITION_ROUT    ; branch if lower
           staa ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; store a into memory
   LB90F:  rts                 ; return from subroutine

SELECT_ERROR_BIT_POSITION_ROUT:
           ldaB #0x01          ; load b with value -00000001-
   LB912:  deca                ; decrement a
           beq  LB918          ; branch if equal (zero)
           lslb            
           bra  LB912          ; branch

   LB918:  clr  ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; zero byte at memory location
           tba                 ; a = b
           comb            
           sei                 ; disable interrupts
           andb b5c_IPL1   
           stab b5c_IPL1       ; store b into memory
           cmpa #0x80          ; compare a with value -10000000-
           beq  LB927          ; branch if equal (zero)
           cli                 ; enable interrupts
   LB927:  rts                 ; return from subroutine

CountRamValuesFrom05to3a:
           ldd  #0x0000         ; load d (a&b) with value -00000000 00000000-
           ldx  #MINTHR_LowestSessionTPS    ; load index with value
   LB92E:  addb 0x00, X        ; add memory at index + value to b
           bcc  LB933          ; branch if greater or equal
           inca                ; increment a
   LB933:  inx                 ; increment index (x=x+1)
           cpx  #CurrentWastegatePosition    ;  -00000000 00111010-
           bcs  LB92E          ; branch if lower
           rts                 ; return from subroutine

VerifyOperationOfThermostat_MM:
           brset *BitFlags6e, #$%10000000, LB96D    ; branch if bit(s) set
           brset *b5c_IPL1, #$%00000010, LB96D    ; branch if bit(s) set
           ldaa Timer_ThermostatDiagnostics    ; load a with memory contents
           beq  LB96D          ; branch if equal (zero)
           ldab Counter_MainLoop    ; load b with memory contents
           bne  LB96D          ; branch if not equal (not zero)
           ldab CoolantTemp    ; load b with memory contents
           cmpb TDAGTP_TstatDiagnosticsTemperatureGoalWithin_HOTIME    ; compare b with memory contents (data is c7)
           bcc  LB96A          ; branch if greater or equal
           ldab KeyOnOrEngineRunningTime    ; load b with memory contents
           incb            
           bne  LB96D          ; branch if not equal (not zero)
           ldab VehicleSpeed_HB    ; load b with memory contents
           cmpb #0x07          ;  -00000111-
           bcs  LB96D          ; branch if lower
           inca                ; increment a
           beq  LB964          ; branch if equal (zero)
           cmpa HOTIME_TstatDiagnosticsTimeToAchieveTemperatureGoal    ; compare a with memory contents (data is ae)
           bcs  LB96B          ; branch if lower
   LB964:  ldd  #0x2101        ; load d (a&b) with value -00100001 00000001-
           jsr  ThrowNonCriticalError    ; call subroutine
   LB96A:  clra                ; a = 0
   LB96B:  staa Timer_ThermostatDiagnostics    ; store a into memory
   LB96D:  rts                 ; return from subroutine

VerifyOperationOfASDRelayAndO2Sensor_MM:
           ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           bne  LB96D          ; branch if not equal (not zero)
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x03          ;  -00000011-
           bne  LB98F          ; branch if not equal (not zero)
           ldaa TimerOverflowsBetweenCamPulses    ; load a with memory contents
           bne  LB98F          ; branch if not equal (not zero)
           ldaa BatteryVolts    ; load a with memory contents
           cmpa #0x81          ; compare a with value -10000001-
           bcs  LB98F          ; branch if lower
           ldaa SwitchPortAccessReg1    ; load a with memory contents
           bita #0x10          ;  -00010000-
           bne  LB98F          ; branch if not equal (not zero)
           ldd  #0x2c14        ; load d (a&b) with value -00101100 00010100-
           jsr  ThrowNonCriticalError    ; call subroutine
   LB98F:  brset *BitFlags6e, #$%10000000, LB9D5    ; branch if bit(s) set
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa #0x2c          ; compare a with value -00101100-
           bcs  LB9D5          ; branch if lower
           ldaa CoolantTemp    ; load a with memory contents
           cmpa CTLRPM_LowBatteryVoltageAtThisCoolantTemp    ; compare a with memory contents (data is cd)
           bcs  LB9D5          ; branch if lower
           brclr *BitFlags67, #$%00100000, LB9DA    ; branch if bit(s) clear
           ldaa Counter_O2Diagnostics    ; load a with memory contents
           cmpa O2DIAG_CounterLimitForO2SensorDiag    ; compare a with memory contents (data is 13)
           bcs  LB9CF          ; branch if lower
           ldaa O2SensorVolts    ; load a with memory contents
           cmpa O2MID_LimitForO2SensorBatteryDiag    ; compare a with memory contents (data is 4d)
           bcs  LB9D5          ; branch if lower
           ldaa Timer_O2MiddleDiagnostics    ; load a with memory contents
           cmpa #0x16          ; compare a with value -00010110-
           bcs  LB9C4          ; branch if lower
           ldd  #0x2001        ; load d (a&b) with value -00100000 00000001-
           jsr  ThrowNonCriticalError    ; call subroutine
           bset *BitFlags67, #$%00000001    ; set bits
           bra  LBA25          ; branch

   LB9C4:  ldab Counter_MainLoop    ; load b with memory contents
           cmpb #0x50          ;  -01010000-
           bne  LBA25          ; branch if not equal (not zero)
           inca                ; increment a
           staa Timer_O2MiddleDiagnostics    ; store a into memory
           bra  LBA25          ; branch

   LB9CF:  inca                ; increment a
           staa Counter_O2Diagnostics
           bra  LBA25          ; branch

   LB9D5:  bclr *BitFlags67, #$%00100000    ; clear bits
           bra  LBA03          ; branch

   LB9DA:  ldaa O2SensorVolts    ; load a with memory contents
           cmpa O2MIDH_HighLimitForInMiddleDetermination    ; compare a with memory contents (data is 1f)
           bhi  LBA03          ; branch if higher
           cmpa O2MIDL_LowLimitForInMiddleDetermination    ; compare a with memory contents (data is 12)
           bcs  LBA03          ; branch if lower
           ldaa Timer_O2MiddleDiagnostics    ; load a with memory contents
           cmpa #0x0b          ; compare a with value -00001011-
           bcs  LB9FA          ; branch if lower
           bset *BitFlags67, #$%00100000    ; set bits
           clra                ; a = 0
           staa Timer_O2MiddleDiagnostics    ; store a into memory
           staa Counter_O2Diagnostics
           bset *PIA_Buffer2, #pia_FuelMon    ; set bits
           bra  LBA25          ; branch

   LB9FA:  ldab Counter_MainLoop    ; load b with memory contents
           cmpb #0xa0          ;  -10100000-
           bne  LBA06          ; branch if not equal (not zero)
           inca                ; increment a
           bra  LBA04          ; branch

   LBA03:  clra                ; a = 0
   LBA04:  staa Timer_O2MiddleDiagnostics    ; store a into memory
   LBA06:  bclr *PIA_Buffer2, #pia_FuelMon    ; clear bits
           ldaa Counter_MainLoop    ; load a with memory contents
           bitA #0x07          ;  -00000111-
           bne  LBA25          ; branch if not equal (not zero)
           brset *BitFlags67, #$%00000001, LBA25    ; branch if bit(s) set
           ldaa O2SensorVolts    ; load a with memory contents
           cmpa O2MIDX_HighLimitForInMiddleDeterminationX    ; compare a with memory contents (data is 3e)
           bls  LBA25          ; branch if lower or same
           ldd  #0x3e9e        ; load d (a&b) with value -00111110 10011110-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LBA25          ; branch if greater or equal
           bset *BitFlags67, #$%00000001    ; set bits
   LBA25:  rts                 ; return from subroutine

DealWithConfigurationAndPulseAccumulator_MM:
           ldx  #CPU_PortA     ; load index with value
           brset  9, X, #$%00111010, LBA30    ; branch if bit(s) set
           bset 9, X, #$%00111010    ; bit set -00001001-
   LBA30:  brclr  9, X, #$%00000101, LBA37    ; branch if bit(s) clear
           bclr 9, X, #$%00000101    ; bit clear -00001001-
   LBA37:  ldaa CPU_OutputCompare1Mask    ; load a with memory contents
           bita #0xf8          ;  -11111000-
           beq  LBA41          ; branch if equal (zero)
           clr  CPU_OutputCompare1Mask    ; zero byte at memory location
   LBA41:  brset 33, X, #$%00011010, LBA48    ; branch if bit(s) set
           bset 33, X, #$%00011010    ; bit set -00100001-
   LBA48:  brclr 33, X, #$%00100101, LBA4F    ; branch if bit(s) clear
           bclr 33, X, #$%00100101    ; bit clear -00100001-
   LBA4F:  brset 34, X, #$%10010110, LBA56    ; branch if bit(s) set
           bset 34, X, #$%10010110    ; bit set -00100010-
   LBA56:  brclr 34, X, #$%00000001, LBA5F    ; branch if bit(s) clear
           bclr 34, X, #$%00000001    ; bit clear -00100010-
           bra  LBA5F          ; branch

   LBA5F:  brclr 36, X, #$%11110000, LBA66    ; branch if bit(s) clear
           bclr 36, X, #$%11110000    ; bit clear -00100100-
   LBA66:  brset 38, X, #$%01110000, LBA6D    ; branch if bit(s) set
           bset 38, X, #$%01110000    ; bit set -00100110-
   LBA6D:  brclr 38, X, #$%10000000, LBA74    ; branch if bit(s) clear
           bclr 38, X, #$%10000000    ; bit clear -00100110-
   LBA74:  ldaa #0x54          ; load a with value -01010100-
           cmpa CPU_SerialPeripheralControl    ; compare a with memory contents
           beq  LBA7E          ; branch if equal (zero)
           staa CPU_SerialPeripheralControl
   LBA7E:  ldd  #DCCOR6_AdaptiveVNTCell1    ; load d (a&b) with value -00000000 00001100-
           cmpD CPU_SerialControlReg1    ; compare D
           beq  LBA8A          ; branch if equal (zero)
           std  CPU_SerialControlReg1
   LBA8A:  brset 57, X, #$%10001000, LBA91    ; branch if bit(s) set
           bset 57, X, #$%10001000    ; bit set -00111001-
   LBA91:  brclr 57, X, #$%01000000, LBA98    ; branch if bit(s) clear
           bclr 57, X, #$%01000000    ; bit clear -00111001-
   LBA98:  brset 60, X, #$%00001000, LBAA1    ; branch if bit(s) set
           sei                 ; disable interrupts
           bset 60, X, #$%00001000    ; bit set -00111100-
           cli                 ; enable interrupts
   LBAA1:  brclr 60, X, #$%00000111, LBAAA    ; branch if bit(s) clear
           sei                 ; disable interrupts
           bclr 60, X, #$%00000111    ; bit clear -00111100-
           cli                 ; enable interrupts
   LBAAA:  rts                 ; return from subroutine

VerifyOperationOfIgnitionCoilDriver_MM:
           ldaa TimerOverflowsBetweenCamPulses    ; load a with memory contents
           cmpa #0x50          ; compare a with value -01010000-
           bcs  LBAE8          ; branch if lower
           brset *BitFlagsC0, #$%10000000, LBAE8    ; branch if bit(s) set
           ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           bne  LBAEB          ; branch if not equal (not zero)
           brset *BitFlags6b, #$%00000100, LBAEB    ; branch if bit(s) set
           ldaa Counter_MainLoop    ; load a with memory contents
           bitA #0x0f          ;  -00001111-
           bne  LBAEB          ; branch if not equal (not zero)
           ldaa BatteryVolts    ; load a with memory contents
           cmpa #0x41          ; compare a with value -01000001-
           bcs  LBAEB          ; branch if lower
           cmpa COILHI_HiLimitBatteryVoltsForCoilVerify    ; compare a with memory contents (data is ba)
           bcc  LBAEB          ; branch if greater or equal
           ldaa MapValueX      ; load a with memory contents
           suba MapVoltsX  
           bls  LBAEB          ; branch if lower or same
           cmpa COILLO_LoLimitBatteryVoltsForCoilVerify    ; compare a with memory contents (data is 05)
           bcs  LBAEB          ; branch if lower
           ldd  #0x2814        ; load d (a&b) with value -00101000 00010100-
           brclr *BitFlagsC0, #$%01000000, LBAE5    ; branch if bit(s) clear
           ldd  #0x0114        ; load d (a&b) with value -00000001 00010100-
   LBAE5:  jmp  ThrowNonCriticalError

   LBAE8:  bset *BitFlags6b, #$%00000100    ; set bits
   LBAEB:  rts                 ; return from subroutine

NULL_ROUTINE:
           rts                 ; return from subroutine

CalculatePartThrottleTransientFuel_MM:
           clra                ; a = 0
           staa Temp2          ; store a into memory
           staa Temp3          ; store a into memory
           ldaa Timer_O2InhibitSwitchingRichIdleToClosedLoop    ; load a with memory contents
           beq  LBAF9          ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_O2InhibitSwitchingRichIdleToClosedLoop    ; store a into memory
   LBAF9:  ldaa CoolantTemp    ; load a with memory contents
           ldab MapValue       ; load b with memory contents
           subb MapAverageValue_HB    ; b = b-memory contents
           stab Temp0          ; store b into memory
           bcs  TransFuel_CalculateDecreasingMAPTransientFuel    ; branch if lower
           clrb                ; b = 0
           stab Factor_DecelLeanoutWhenMAPDecreasing    ; store b into memory
           brset *BitFlags66, #$%00000001, TransFuel_CalculateIncreasingMAPPartThrottlePW    ; branch if bit(s) set
           brset *BitFlags66, #$%10000000, TransFuel_CalculateIncreasingMAPFullThrottlePW    ; branch if bit(s) set
           ldx  #AETIME_EnrichmentTime_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Factor_LeanoutOrEnrichTime_MAP    ; store a into memory
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 91)
           bitA #0x02          ;  -00000010-
           beq  TransFuel_CalculateIncreasingMAPSpecialPW    ; branch if equal (zero)
   LBB1D:  jmp  LBBFC      

TransFuel_CalculateIncreasingMAPSpecialPW:
           ldaa Temp0          ; load a with memory contents
           suba MAPTRS_DeltaMapTriggerLevelSpecial    ;  (data is 06)
           bcs  LBB1D          ; branch if lower
           cmpa MAPMXS_MaxDeltaMapAllowedSpecial    ; compare a with memory contents (data is 22)
           bcs  LBB2F          ; branch if lower
           ldaa MAPMXS_MaxDeltaMapAllowedSpecial    ; load a with memory contents (data is 22)
   LBB2F:  staa Temp1          ; store a into memory
           ldx  #AESLPI_DeltaMAPEnrichmentIdle    ; load index with value
           bra  LBB70          ; branch

TransFuel_CalculateIncreasingMAPPartThrottlePW:
           ldx  #AESLPP_DeltaMAPEnrichmentPT_FromTempPart    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Factor_LeanoutOrEnrichTime_MAP    ; store a into memory
           ldaa Temp0          ; load a with memory contents
           suba MAPTRP_DeltaMapTriggerLevelPartThrottle    ;  (data is 0a)
           bcs  LBB1D          ; branch if lower
           cmpa MAPMXP_MaxDeltaMapAllowedPartThrottle    ; compare a with memory contents (data is ff)
           bcs  LBB4D          ; branch if lower
           ldaa MAPMXP_MaxDeltaMapAllowedPartThrottle    ; load a with memory contents (data is ff)
   LBB4D:  staa Temp1          ; store a into memory
           ldx  #AESLPW_DeltaMAPEnrichmentWOT    ; load index with value
           bra  LBB70          ; branch

TransFuel_CalculateIncreasingMAPFullThrottlePW:
           ldx  #AESLOW_DeltaMAPEnrichmentWOT_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Factor_LeanoutOrEnrichTime_MAP    ; store a into memory
           ldaa Temp0          ; load a with memory contents
           suba MAPTRG_DeltaMapTriggerLevel    ;  (data is 0a)
           bcs  LBB1D          ; branch if lower
           cmpa MAPMAX_MaxDeltaMapAllowed    ; compare a with memory contents (data is 1c)
           bcs  LBB6B          ; branch if lower
           ldaa MAPMAX_MaxDeltaMapAllowed    ; load a with memory contents (data is 1c)
   LBB6B:  staa Temp1          ; store a into memory
           ldx  #AESLOP_DeltaMAPEnrichmentPT    ; load index with value
   LBB70:  ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp1          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           stD *Temp2          ; store D to RAM
           bra  LBBE8          ; branch

TransFuel_CalculateDecreasingMAPTransientFuel:
           ldx  #LMAPTC_TimeConstant    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Factor_LeanoutOrEnrichTime_MAP    ; store a into memory
           brset *BitFlags6e, #$%10000000, LBBE1    ; branch if bit(s) set
           brset *BitFlags66, #$%00000001, LBBE1    ; branch if bit(s) set
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa LOTRPM_MinRpmForMapLeanout    ; compare a with memory contents (data is 27)
           bcs  LBBE1          ; branch if lower
           cmpa AVMRPM_MinimumRPMToResetAverageMAP    ; compare a with memory contents (data is d6)
           bcc  LBBE1          ; branch if greater or equal
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 91)
           bita #0x20          ;  -00100000-
           beq  LBBA3          ; branch if equal (zero)
           brclr *BitFlags_36, #$%00001000, LBBE1    ; branch if bit(s) clear
   LBBA3:  brclr *KeyOnOrEngineRunningTime, #$%11111111, LBBE1    ; branch if bit(s) clear
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           cmpD #MapVolts      ; compare D -00000000 10000000-
           bcs  LBBE1          ; branch if lower
           ldx  #DECTRG_DeltaMapTriggerForNoIncrementalLeanout    ; load index with value
           ldaa MapValue       ; load a with memory contents
           ldab Factor_DecelLeanoutWhenMAPDecreasing    ; load b with memory contents
           beq  LBBBB          ; branch if equal (zero)
           ldx  #DTRG2_DeltaMapTriggerForMaxLeanout    ; load index with value
   LBBBB:  jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp0          ; load a with memory contents
           nega                ; negate a (set high bit)
           cba             
           bcs  LBBE5          ; branch if lower
           ldx  #DECTPS_DeltaMAPLeanout_FromTPS    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp1          ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #NEGSL2_DeltaMAPLeanout_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp1          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           ldab DCELTM_O2CNTRInhibitAfterLeanoutDone    ; load b with memory contents (data is 69)
           stab Timer_O2InhibitSwitchingRichIdleToClosedLoop    ; store b into memory
           nega                ; negate a (set high bit)
           bra  LBBE6          ; branch

   LBBE1:  ldaa MapValue       ; load a with memory contents
           staa MapAverageValue_HB    ; store a into memory
   LBBE5:  clra                ; a = 0
   LBBE6:  staa Factor_DecelLeanoutWhenMAPDecreasing    ; store a into memory
   LBBE8:  brset *BitFlags6e, #$%10000000, LBBF7    ; branch if bit(s) set
           ldd  KeyOnOrEngineRunningTime    ; load d (a&b) with memory contents
           cmpa #0x00          ; compare a with value -00000000-
           bne  LBBFC          ; branch if not equal (not zero)
           cmpb MLPTPS_MainLoopCountToClearTPSTRansient    ; compare b with memory contents (data is 5d)
           bhi  LBBFC          ; branch if higher
   LBBF7:  ldd  #0x0000         ; load d (a&b) with value -00000000 00000000-
           stD *Temp2          ; store D to RAM
   LBBFC:  ldaa CoolantTemp    ; load a with memory contents
           ldab TpsVolts       ; load b with memory contents
           subb TpsAverageValue_HB    ; b = b-memory contents
           stab Temp0          ; store b into memory
           bcs  TransFuel_CalculateDecreasingTPSTransientFuel    ; branch if lower
           ldx  #THRTCN_EnrichmentTime_FromTemp        ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Factor_LeanoutOrEnrichTime_TPS    ; store a into memory
           clra                ; a = 0
           staa Timer_OffThrottleFuelEnrich    ; store a into memory
           ldaa Temp0          ; load a with memory contents
           suba POSTRG_PositiveTransientTriggerLevel    ;  (data is 03)
           bcs  TransFuel_SaveTemp2    ; branch if lower
           cmpa THRMAX_MaxDeltaTHR    ; compare a with memory contents (data is 40)
           bcs  LBC20          ; branch if lower
           ldaa THRMAX_MaxDeltaTHR    ; load a with memory contents (data is 40)
   LBC20:  staa Temp1          ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #POSSLP_DeltaTPSEnrichmentFactor    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp1          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           addd Temp2          ; d = d + memory contents
           bra  TransFuel_SaveD    ; branch

TransFuel_CalculateDecreasingTPSTransientFuel:
           ldx  #LOTIME_DecelLeanoutTimeConstant_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Factor_LeanoutOrEnrichTime_TPS    ; store a into memory
           brset *BitFlags6e, #$%10000000, LBC88    ; branch if bit(s) set
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa ATPRPM_MinimumRPMtoResetAverageTPS    ; compare a with memory contents (data is 64)
           bcc  LBC88          ; branch if greater or equal
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bcs  LBC88          ; branch if lower
           cmpa ATPDTP_MinimumDeltaTPStoResetAverageTPS    ; compare a with memory contents (data is 33)
           bcc  LBC88          ; branch if greater or equal
           brclr *KeyOnOrEngineRunningTime, #$%11111111, LBC88    ; branch if bit(s) clear
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           cmpD #MapVolts      ; compare D -00000000 10000000-
           bcs  LBC88          ; branch if lower
           ldx  #LOTTRG_DeltaTriggerForDecelLeanout    ; load index with value
           ldaa MapValue       ; load a with memory contents
           ldab Timer_OffThrottleFuelEnrich    ; load b with memory contents
           beq  LBC67          ; branch if equal (zero)
           ldx  #LOTRG2_SecondDecelLeanoutTrigger    ; load index with value
   LBC67:  jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp0          ; load a with memory contents
           nega                ; negate a (set high bit)
           cba             
           bcs  LBC8C          ; branch if lower
           ldx  #LOTTPS_DecelLeanoutFactor_FromTPS    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp1          ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #LOTTHR_DecelLeanoutFactor_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp1          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           nega                ; negate a (set high bit)
           bra  TransFuel_StoreLeanOutFactor    ; branch

   LBC88:  ldaa TpsVolts       ; load a with memory contents
           staa TpsAverageValue_HB    ; store a into memory
   LBC8C:  clra                ; a = 0
TransFuel_StoreLeanOutFactor:
           staa Timer_OffThrottleFuelEnrich    ; store a into memory
TransFuel_SaveTemp2:
           brset *BitFlags6e, #$%10000000, LBCB6    ; branch if bit(s) set
           ldd  Temp2          ; load d (a&b) with memory contents
TransFuel_SaveD:
           stD *Pulsewidth_PartThrottleEnrichment_HB    ; store D to RAM
           brset *BitFlags6e, #$%10000000, LBCB6    ; branch if bit(s) set
           brset *BitFlags66, #$%10000000, LBCB6    ; branch if bit(s) set
           ldaa SwitchPortAccessReg1    ; load a with memory contents
           bita #0x40          ;  -01000000-
           bne  LBCB6          ; branch if not equal (not zero)
           ldaa DesiredNewAisPosition    ; load a with memory contents
           suba CurrentAisPosition
           bcs  LBCB6          ; branch if lower
           cmpa POSTIG_MinAisPulseRequireToTriggerEnrichment    ; compare a with memory contents (data is 07)
           bcs  LBCB6          ; branch if lower
           ldd  POSFUL_AisEnrichmentFuelPulse    ;  (data is 00fa)
           stD *Pulsewidth_AISEnrichment_HB    ; store D to RAM
   LBCB6:  rts                 ; return from subroutine

CalculateInjectorPulsewidthForStarting_MM:
           brset *BitFlags6e, #$%10000000, LBCBC    ; branch if bit(s) set
           rts                 ; return from subroutine

   LBCBC:  ldaa TpsVolts       ; load a with memory contents
           cmpa #0xd0          ; compare a with value -11010000-
           bcc  ThrottleFlooredWhileStarting_UnloadFuel    ; branch if greater or equal
           suba MINTHR_LowestSessionTPS
           bls  LBCCB          ; branch if lower or same
           cmpa UNLOAD_DeltaThrottleFrom_MINTHR_ToUnloadCrankingFuel    ; compare a with memory contents (data is 85)
           bcc  ThrottleFlooredWhileStarting_UnloadFuel    ; branch if greater or equal
   LBCCB:  jsr  AllowForHeatSoakAfterStall    ; call subroutine
           brset *BitFlags66, #$%10000000, LBCDA    ; branch if bit(s) set
           cmpa STRLMT_ColdestTempAllowedAtClosedThrottle    ; compare a with memory contents (data is 69)
           bcc  LBCDA          ; branch if greater or equal
           ldaa STRLMT_ColdestTempAllowedAtClosedThrottle    ; load a with memory contents (data is 69)
   LBCDA:  ldx  #STRTFL_FuelStartFromCoolantTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           mul                 ; multiply (d=a*b)
           stD *Temp0          ; store D to RAM
           ldaa Counter_EPP_MaxFF    ; load a with memory contents
           ldx  #EPPMUL_FuelStartFuelPerEPP    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp4          ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #STFTMP_FuelStartFuelFromCoolant    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp4          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           beq  LBD07          ; branch if equal (zero)
           nega                ; negate a (set high bit)
           ldY Temp0           ; load Y index
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           stD *Temp0          ; store D to RAM
   LBD07:  ldaa BaroPressure    ; load a with memory contents
           ldx  #STFBAR_FuelStartReductionFromBaro    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp4          ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #STFTM2_FuelStartFuelFromCoolant2    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp4          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           beq  LBD2B          ; branch if equal (zero)
           nega                ; negate a (set high bit)
           ldY Temp0           ; load Y index
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           bra  LBD2D          ; branch

   LBD2B:  ldd  Temp0          ; load d (a&b) with memory contents
   LBD2D:  asld                ; shift left (d=d*2)
           bcs  LBD33          ; branch if lower
           asld                ; shift left (d=d*2)
           bcc  LBD3B          ; branch if greater or equal
   LBD33:  ldd  #0xffff        ; load d (a&b) with value -11111111 11111111-
           bra  LBD3B          ; branch

ThrottleFlooredWhileStarting_UnloadFuel:
           ldd  #0x0000         ; load d (a&b) with value -00000000 00000000-
   LBD3B:  jsr  NULL_ROUTINE    ; call subroutine
           stD *InjectorPulsewidth_HB    ; store D to RAM
           cli                 ; enable interrupts
           ldx  #SFDCAY_FuelStartDecayIntoRun    ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           staa Factor_StartFuelDecayIntoRunFuel    ; store a into memory
           rts                 ; return from subroutine

ControlEngineCutout_MM:
           brclr *TimerOverflowsBetweenCamPulses, #$%11111111, Cutout_CheckEnable    ; branch if bit(s) clear
           bclr *BitFlags6a, #$%00001100    ; clear bits
           clr  Counter_FuelEngRunning    ; zero byte at memory location
           rts                 ; return from subroutine
           
Cutout_CheckEnable:
;          New code - check to see if either of the rev limiter config flags is set before running the code...
;            ldaa OPTN2_CalCustomOptionConfigFlags2
;            bita #opt_FuelRevLim | opt_SprkRevLim
;           beq  LBE00 ; will this work instead? --> more efficient code
;            bne  Cutout_EngineRunning ; run the rev limiter code
;            rts  ; don't run the rev limiter code


Cutout_EngineRunning:
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           staa Temp1          ; store a into memory
           asld                ; shift left (d=d*2)
           bcc  Cutout_SpeedIsBelow128Mph    ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
Cutout_SpeedIsBelow128Mph:
           staa Temp0          ; store a into memory

; Staging limiter (2-step) code...
;
;	The staging limiter has 2 activation/deactivation methods.
;	1st, the limiter checks to see if it's active by looking for an "enable" switch.
;	This could be the brake or other input switch. Multiple switches can even be used.
;       IE, brake + cruise on to enable to staging limiter...
;	If the switch is "off", then the normal rev limiter values are used.
;	2nd, the limiter checks to see if the vehicle speed is above the cutoff point - STGSPD.
;	If it is, then the normal rev limiter value is loaded.
;

           ldx  #Turbonator_Flags
           ldaa OPTN1_CalCustomOptionConfigFlags1
           bita #opt_StageLim
           beq  Stage_Limiter_Off ;skip looking at the switch state completely if the stage limiter is off

           ; check to see if no switch is selected, if no switch, assume speed cutoff only
           ldab STGSWS_StagingLimiterEnableSwitch
           beq  Stage_Limiter_On

           ldab StartupSwitchMirror1    ; load b with memory contents
	   bita #opt_StagePol ; check the switch polarity
	   beq  StageLim_Polarity_Lo

StageLim_Polarity_Hi:
	   bitb STGSWS_StagingLimiterEnableSwitch
	   beq  Stage_Limiter_On	    ; branch if equal (zero)
	   bra  Stage_Limiter_Off

StageLim_Polarity_Lo:
	   bitb STGSWS_StagingLimiterEnableSwitch
           beq  Stage_Limiter_Off

Stage_Limiter_On:
           bset 0, x, #Turbonator_Staging           ; set the flag to indicate that the staging limiter is active...
	   ldaa Temp1
	   cmpa STGSPD_StageLimiterCutoffSpeed    ; compare a with memory contents (data is 0a)
	   bcc  Stage_Limiter_Off		       ; branch if the vehicle speed is greater than the cutoff speed
	   ldaa STGROF_StageLimiterRPMOffSetpoint ; load a with memory contents (data is 7d)
	   ldab STGRON_StageLimiterRPMOnSetpoint  ; load b with memory contents (data is 77)
	   bra  Store_Limiter_Values	       ; branch

Stage_Limiter_Off:
           bclr 0, x, #Turbonator_Staging           ; clear the flag indicating the staging limiter is active...
	   ldaa REVLMT6_RPMLimiterNormalOffRPM    ; load a with memory contents (data is dd)
	   ldab REVLMT5_RPMLimiterNormalOnRPM     ; load b with memory contents (data is d4)

Store_Limiter_Values:
	   stD RevLimiterRPMOff		       ; store D to RAM

           brclr *BitFlags6a, #$%00000100, Cutout_UseDecelFuelCut    ; branch if bit(s) clear
           jmp  Cutout_UseHysteresisToDetermineWhenToTurnFuelBackOn

Cutout_UseDecelFuelCut:
           brclr *BitFlags6b, #$%00000010, Cutout_CheckForOBConditions    ; branch if bit(s) clear
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  LBD76          ; branch if greater or equal
           clra                ; a = 0
   LBD76:  cmpa DFRPMH_DecelFuelShutoffDeltaRPMOff    ; compare a with memory contents (data is 1e)
           bls  Cutout_CheckForOBConditions    ; branch if lower or same
           bset *BitFlags6a, #$%00000100    ; set bits
           rts                 ; return from subroutine

Cutout_CheckForOBConditions:
           ldaa MapValue       ; load a with memory contents
           suba BaroPressure
           bcs  Cutout_BeginOverboostTimerCountdown    ; branch if lower
           brclr *b5d_IPL2, #$%00100000, LBDA3    ; branch if bit(s) clear
           cmpa LMPSHF_OverboostFuelShutoffDisablePointFromMap_Limp    ; compare a with memory contents (data is 73)
           bls  Cutout_CheckRevLimiters    ; branch if lower or same
   LBD8E:  brset *BitFlags6a, #$%00000100, LBD98    ; branch if bit(s) set
           bset *BitFlags6a, #$%00100000    ; set bits
ShutOffEngineForThisRotation:
           bset *BitFlags6a, #$%00000100    ; set bits
   LBD98:  bclr *BitFlags6a, #$%00001000    ; clear bits
           rts                 ; return from subroutine

Cutout_BeginOverboostTimerCountdown:
           ldaa TRNTIM_OverboostFuelShutoffDuration    ; load a with memory contents (data is 8a)
           staa Timer_OverboostCountdown    ; store a into memory
           bra  Cutout_CheckRevLimiters    ; branch

   LBDA3:  suba MPSHFT_OverboostFuelShutoffEnablePointFromMap_Timer    ;  (data is 7b)
           bcs  Cutout_BeginOverboostTimerCountdown    ; branch if lower
           cmpa MPSHFA_OverboostFuelShutoffEnablePointFromMap_Absolute    ; compare a with memory contents (data is 99)
           bhi  Cutout_SetOBCodeAndShutdown    ; branch if higher
           ldaa Timer_OverboostCountdown    ; load a with memory contents
           beq  Cutout_SetOBCodeAndShutdown    ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_OverboostCountdown    ; store a into memory
           bra  Cutout_CheckRevLimiters    ; branch

Cutout_SetOBCodeAndShutdown:
           ldd  #0x0708        ; load d (a&b) with value -00000111 00001000-
           jsr  ThrowNonCriticalError    ; call subroutine
           bra  LBD8E          ; branch

Cutout_CheckRevLimiters:
           ldx  #REVLMT2_MapLimpinAndThrAbove25PercentUpper2000    ; load index with value
           brclr *b5c_IPL1, #$%10100000, LBDCE    ; branch if bit(s) clear
           ldab THRTHR_25PctThrValueFromShutoff    ; load b with memory contents (data is 21)
           addb MINTHR_LowestSessionTPS    ; b=b+memory contents
           cmpb TpsVolts   
           bcs  Cutout_CheckRevLimitingValues    ; branch if lower
   LBDCE:  ldx  #REVLMT4_MapAbove75PctAndThrLimpin2000    ; load index with value
           brclr *b5c_IPL1, #$%01000000, Cutout_ThrottleSensorOK    ; branch if bit(s) clear
           ldaa Temp0          ; load a with memory contents
           cmpa RVLSPD_CarSpeedForRevLimitWithTBOff    ; compare a with memory contents (data is 14)
           bcc  LBDEC          ; branch if greater or equal
           bra  LBDE2          ; branch

Cutout_ThrottleSensorOK:
           ldab BitFlags66     ; load b with memory contents
           bmi  LBDEC          ; branch if minus(hi bit 1)
   LBDE2:  ldab BaroPressure    ; load b with memory contents
           lsrb                ; logical shift right b
           tba                 ; a = b
           lsrb                ; logical shift right b
           aba                 ; a=a+b
           cmpa MapValue       ; compare a with memory contents
           bcs  Cutout_CheckRevLimitingValues    ; branch if lower
   LBDEC:  ldx  #REVLMT6_RPMLimiterNormalOffRPM    ; load index with value
Cutout_CheckRevLimitingValues:
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa 0x00, X        ; compare a with memory at index + value
           bcc  ShutOffEngineForThisRotation    ; branch if greater or equal
           cmpa SPDRPM_EngineSpeedHighLimitToEnableOverspeed    ; compare a with memory contents (data is d5)
           bcs  LBE01          ; branch if lower
           ldab Temp1          ; load b with memory contents
           cmpb SPDLMH_SpeedLimitFuelShutoff254mph    ; compare b with memory contents (data is ff)
           bcc  ShutOffEngineForThisRotation    ; branch if greater or equal
   LBE01:  brset *BitFlags67, #$%01000000, Cutout_CheckMPHLimitingValues    ; branch if bit(s) set
           bclr *BitFlags6a, #$%00001000    ; clear bits
           clr  Counter_FuelEngRunning    ; zero byte at memory location
           rts                 ; return from subroutine

Cutout_CheckMPHLimitingValues:
           cmpa DFRPM2_2560RPM_DecelFuelShutoffUpperRpmLimit    ; compare a with memory contents (data is 36)
           bcs  LBE3D          ; branch if lower
           ldaa Temp0          ; load a with memory contents
           cmpa DFS20M_20MPHDecelFuelShutoffSpeedLimitOFF    ; compare a with memory contents (data is 14)
           bcs  LBE3D          ; branch if lower
           ldaa CoolantTemp    ; load a with memory contents
           cmpa DFSTMH_60DegCDecelFuelShutoffTempLimitOff    ; compare a with memory contents (data is 92)
           bcs  LBE3D          ; branch if lower
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa DFSTMRH_3minuteDecelFuelShutoffTimeLimitOFF    ; compare a with memory contents (data is 04)
           bcs  LBE3D          ; branch if lower
           ldaa MapValue       ; load a with memory contents
           cmpa DFSMPH_MAPDecelFuelShutoffTimeLimitOFF    ; compare a with memory contents (data is 24)
           bhi  LBE3D          ; branch if higher
           ldaa b5c_IPL1       ; load a with memory contents
           bita #0xe2          ;  -11100010-
           bne  LBE3D          ; branch if not equal (not zero)
           brclr *BitFlags69, #$%00000100, LBE3D    ; branch if bit(s) clear
           bset *BitFlags6a, #$%00001100    ; set bits
   LBE3A:  clra                ; a = 0
           staa Counter_O2SensorFeedbackCount_Signed    ; store a into memory
   LBE3D:  rts                 ; return from subroutine

Cutout_UseHysteresisToDetermineWhenToTurnFuelBackOn:
           brclr *BitFlags6b, #$%00000010, LBE4F    ; branch if bit(s) clear
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  LBE49          ; branch if greater or equal
           clra                ; a = 0
   LBE49:  cmpa DFRPML_DecelFuelShutoffDeltaRPMOn    ; compare a with memory contents (data is 11)
           bls  Cutout_TurnFuelBackOn    ; branch if lower or same
           rts                 ; return from subroutine

   LBE4F:  brclr *BitFlags6a, #$%00001000, LBE81    ; branch if bit(s) clear
           brclr *BitFlags67, #$%01000000, Cutout_TurnFuelBackOn    ; branch if bit(s) clear
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa DFRPM1_2050RPM_DecelFuelShutoffTurnonLimit    ; compare a with memory contents (data is 34)
           bcs  Cutout_TurnFuelBackOn    ; branch if lower
           ldaa Temp0          ; load a with memory contents
           cmpa DFS20L_20MPHDecelFuelShutoffSpeedLimitON    ; compare a with memory contents (data is 10)
           bcs  Cutout_TurnFuelBackOn    ; branch if lower
           ldaa CoolantTemp    ; load a with memory contents
           cmpa DFSTML_60DegCDecelFuelShutoffTempLimitON    ; compare a with memory contents (data is 90)
           bcs  Cutout_TurnFuelBackOn    ; branch if lower
           ldaa MapValue       ; load a with memory contents
           cmpa DFSMPL_MAPDecelFuelShutoffTimeLimitON    ; compare a with memory contents (data is 27)
           bhi  Cutout_TurnFuelBackOn    ; branch if higher
           ldaa b5c_IPL1       ; load a with memory contents
           bita #0xe2          ;  -11100010-
           bne  Cutout_TurnFuelBackOn    ; branch if not equal (not zero)
           brset *BitFlags69, #$%00000100, LBE3A    ; branch if bit(s) set
Cutout_TurnFuelBackOn:
           bclr *BitFlags6a, #$%00001100    ; clear bits
           rts                 ; return from subroutine

   LBE81:  ldaa MapValue       ; load a with memory contents
           suba BaroPressure
           bcs  LBE91          ; branch if lower
           brclr *b5d_IPL2, #$%00100000, LBE98    ; branch if bit(s) clear
           cmpa LMPSHF_OverboostFuelShutoffDisablePointFromMap_Limp    ; compare a with memory contents (data is 73)
           bls  Cutout_DetermineLimpModeCutoutRPM    ; branch if lower or same
           rts                 ; return from subroutine

   LBE91:  ldaa TRNTIM_OverboostFuelShutoffDuration    ; load a with memory contents (data is 8a)
           staa Timer_OverboostCountdown    ; store a into memory
           bra  Cutout_DetermineLimpModeCutoutRPM    ; branch

   LBE98:  suba MPSHFT_OverboostFuelShutoffEnablePointFromMap_Timer    ;  (data is 7b)
           bcs  LBE91          ; branch if lower
           cmpa MPSHFA_OverboostFuelShutoffEnablePointFromMap_Absolute    ; compare a with memory contents (data is 99)
           bhi  LBEAB          ; branch if higher
           ldaa Timer_OverboostCountdown    ; load a with memory contents
           beq  LBEAB          ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_OverboostCountdown    ; store a into memory
           bra  Cutout_DetermineLimpModeCutoutRPM    ; branch

   LBEAB:  ldd  #0x0708        ; load d (a&b) with value -00000111 00001000-
           jmp  ThrowNonCriticalError

Cutout_DetermineLimpModeCutoutRPM:
           ldx  #REVLMT_MapLimpinAndThrAbove25PercentLower1850    ; load index with value
           brclr *b5c_IPL1, #$%10100000, Cutout_MAPSENSOR_OKAY_OR_LIGHTTHROTTLE2    ; branch if bit(s) clear
           ldab THRTHR_25PctThrValueFromShutoff    ; load b with memory contents (data is 21)
           addb MINTHR_LowestSessionTPS    ; b=b+memory contents
           cmpb TpsVolts   
           bcs  LBEE2          ; branch if lower
Cutout_MAPSENSOR_OKAY_OR_LIGHTTHROTTLE2:
           ldx  #REVLMT3_MapAbove75PctAndIdleSwitchClosed2000    ; load index with value
           brclr *b5c_IPL1, #$%01000000, Cutout_THROTTLESENSOR_OKAY2    ; branch if bit(s) clear
           ldaa Temp0          ; load a with memory contents
           cmpa RVLSPD_CarSpeedForRevLimitWithTBOff    ; compare a with memory contents (data is 14)
           bcc  LBEDF          ; branch if greater or equal
           bra  LBED5          ; branch

Cutout_THROTTLESENSOR_OKAY2:
           ldab BitFlags66     ; load b with memory contents
           bmi  LBEDF          ; branch if minus(hi bit 1)
   LBED5:  ldab BaroPressure    ; load b with memory contents
           lsrb                ; logical shift right b
           tba                 ; a = b
           lsrb                ; logical shift right b
           aba                 ; a=a+b
           cmpa MapValue       ; compare a with memory contents
           bcs  LBEE2          ; branch if lower
   LBEDF:  ldx  #REVLMT5_RPMLimiterNormalOnRPM    ; load index with value
   LBEE2:  ldaa EngineRpm_HB    ; load a with memory contents
           cmpa 0x00, X        ; compare a with memory at index + value
           bcc  LBEF7          ; branch if greater or equal
           cmpa SPDRPM2_EngineSpeedLowLimitToDisableOverspeed    ; compare a with memory contents (data is d1)
           bhi  LBEF0          ; branch if higher
   LBEED:  jmp  Cutout_TurnFuelBackOn

   LBEF0:  ldaa Temp1          ; load a with memory contents
           cmpa SPDLML_SpeedLimitFuelShutoffRestore253mph    ; compare a with memory contents (data is fd)
           bls  LBEED          ; branch if lower or same
   LBEF7:  rts                 ; return from subroutine

CalculatePartThrottleEnrichmentAndSparkScatterFuel_MM:
           ldx  #RPMMAP_SwitchPointForDownUp_FromRpm    ; load index with value
           ldaa EngineRpm_HB    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           cmpa MapValue       ; compare a with memory contents
           rora            
           ldx  #PTENR_EppPerAmountForIncreasing    ; load index with value
           anda #0x80          ; AND a with value -10000000-
           bmi  LBF0C          ; branch if minus(hi bit 1)
           inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
   LBF0C:  staa Temp0          ; store a into memory
           tab                 ; b = a
           eorb Counter_FallingEdgeEPP_MaxFF
           bpl  LBF19          ; branch if plus (hi bit 0)
           staa Counter_FallingEdgeEPP_MaxFF    ; store a into memory
           ldab Timer_OpenLoopFraction    ; load b with memory contents
           bra  LBF7E          ; branch

   LBF19:  ldab 0x00, X        ; load b with memory at index + value
           sei                 ; disable interrupts
           eora Counter_FallingEdgeEPP_MaxFF
           cba             
           bcs  LBF22          ; branch if lower
           sba                 ; subtract (a=a-b)
   LBF22:  oraa Temp0          ; OR a with memory contents
           staa Counter_FallingEdgeEPP_MaxFF    ; store a into memory
           cli                 ; enable interrupts
           ldab Timer_OpenLoopFraction    ; load b with memory contents
           bcs  LBF7E          ; branch if lower
           addb 0x01, X        ; add memory at index + value to b
           bpl  LBF35          ; branch if plus (hi bit 0)
           clrb                ; b = 0
           tsta                ; test a
           bpl  LBF35          ; branch if plus (hi bit 0)
           ldab #0x7f          ; load b with value -01111111-
   LBF35:  stab Temp0          ; store b into memory
           ldx  #PTELMT_MultiplierMaxLimitFromRpm    ; load index with value
           ldaa EngineRpm_HB    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp4          ; store a into memory
           ldx  #PTEADJ_EnrichAdjust_FromMap    ; load index with value
           ldaa MapValue       ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp4          ; load a with memory contents
           tstb            
           beq  LBF51          ; branch if equal (zero)
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
   LBF51:  tab                 ; b = a
           cmpb Temp0      
           bls  LBF79          ; branch if lower or same
           brclr *BitFlags66, #$%00000010, LBF75    ; branch if bit(s) clear
           ldab Timer_OpenLoopFraction    ; load b with memory contents
           beq  LBF72          ; branch if equal (zero)
           sba                 ; subtract (a=a-b)
           staa Temp1          ; store a into memory
           ldaa PTENRD_AmountForDecreasingMultiplier_Negative    ; load a with memory contents (data is fd)
           beq  LBF75          ; branch if equal (zero)
           nega                ; negate a (set high bit)
           ldab PTENUM_NumberToReturnToHOTMAP    ; load b with memory contents (data is 02)
           mul                 ; multiply (d=a*b)
           tsta                ; test a
           bne  LBF75          ; branch if not equal (not zero)
           cmpb Temp1      
           bcc  LBF75          ; branch if greater or equal
   LBF72:  bclr *BitFlags66, #$%00000010    ; clear bits
   LBF75:  ldab Temp0          ; load b with memory contents
           bra  LBF7C          ; branch

   LBF79:  bset *BitFlags66, #$%00000010    ; set bits
   LBF7C:  stab Timer_OpenLoopFraction    ; store b into memory
   LBF7E:  brclr *BitFlags66, #$%10000000, LBF84    ; branch if bit(s) clear
           bne  LBF8B          ; branch if not equal (not zero)
   LBF84:  ldaa MapValue       ; load a with memory contents
           cmpa BOOSTP_AdjustO2ResponseForPTEWhenMapAboveThis    ; compare a with memory contents (data is 81)
           bcs  LBF92          ; branch if lower
   LBF8B:  ldaa Counter_O2SensorFeedbackCount_Signed    ; load a with memory contents
           bpl  LBF92          ; branch if plus (hi bit 0)
           clra                ; a = 0
           staa Counter_O2SensorFeedbackCount_Signed    ; store a into memory
   LBF92:  ldaa BatteryVolts    ; load a with memory contents
           ldx  #BATOFF_FuelBatteryOffset    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa InjectorLatency    ; store a into memory
           ldaa BaroPressure    ; load a with memory contents
           ldx  #PWADD_FuelPWModifierFromBaro    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           stD *Temp0          ; store D to RAM
           ldaa CoolantTemp    ; load a with memory contents
           cmpa IDLTMP_Use_IDLADD_AboveThisTemp    ; compare a with memory contents (data is 8a)
           bls  LBFB8          ; branch if lower or same
           brset *BitFlags67, #$%00001000, LBFB8    ; branch if bit(s) set
           brset *BitFlags6f, #$%00010000, UsingSparkScatterToControlIdle    ; branch if bit(s) set
   LBFB8:  ldd  Temp0          ; load d (a&b) with memory contents
           stD *SparkScatterFuelStabilizationValue_HB    ; store D to RAM
           rts                 ; return from subroutine

UsingSparkScatterToControlIdle:
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  IdleSpeedAboveTarget    ; branch if greater or equal

IdleSpeedBelowTarget:
           coma
           comb    ; DeltaRPM value is negative in this case, so complement is like ABS function for negative value
           ldx  #IDLADD_FuelStabilization_FromDeltaRPM    ; load index with value
           bsr  DIN_ACLRDBOUT_CALCULATE_BASEDON_IDLE_ERROR_ROUTINE    ; call subroutine
           addd Temp0          ; d = d + PWADD value
           stD *SparkScatterFuelStabilizationValue_HB    ; store D to RAM
           rts                 ; return from subroutine

IdleSpeedAboveTarget:
           ldx  #IDLSUB_FuelStabilizationSubtract_FromDeltaRPM    ; load index with value
           bsr  DIN_ACLRDBOUT_CALCULATE_BASEDON_IDLE_ERROR_ROUTINE    ; call subroutine
           subd Temp0          ; d = d - PWADD value
           coma
           comb
           stD *SparkScatterFuelStabilizationValue_HB    ; store D to RAM
           rts                 ; return from subroutine

DIN_ACLRDBOUT_CALCULATE_BASEDON_IDLE_ERROR_ROUTINE:
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           tsta                ; test a
           beq  LBFE4          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   LBFE4:  tba                 ; a = b
           jsr  Lookup4ByteTable    ; call subroutine
           clra                ; a = 0
           rts                 ; return from subroutine

CalculateSumOfAllFuelModifiers_MM:
           brset *BitFlags6e, #$%10000000, ClearTemp0ForResultStorage    ; branch if bit(s) set
           ldx  #TMPHLD_TempSwitchPointForCurveAHoldDecay    ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           cmpa 0x00, X        ; compare a with memory at index + value
           bcs  LBFF8          ; branch if lower
           inx                 ; increment index (x=x+1)
   LBFF8:  brset *BitFlags67, #$%00000010, LC01B    ; branch if bit(s) set
           brset *BitFlags66, #$%00010000, LC015    ; branch if bit(s) set
           ldd  KeyOnOrEngineRunningTime    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           bcs  LC015          ; branch if lower
           asld                ; shift left (d=d*2)
           bcs  LC015          ; branch if lower
           cmpa 0x01, X        ; compare a with memory at index + value
           bcc  LC015          ; branch if greater or equal
           ldx  #DCYTMC_CurveAColdDecayTime    ; load index with value
           cmpa 0x02, X        ; compare a with memory at index + value
           bcc  LC01B          ; branch if greater or equal
           bra  ClearTemp0ForResultStorage    ; branch

   LC015:  bset *Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached, #$%11111111    ; set bits
           bset *BitFlags67, #$%00000010    ; set bits
   LC01B:  brset *Counter_MainLoop, #$%00011111, LC021    ; branch if bit(s) set
           bra  ClearTemp0ForResultStorage    ; branch

   LC021:  ldab Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached    ; load b with memory contents
           subb 0x03, X    
           bcc  LC028          ; branch if greater or equal
           clrb                ; b = 0
   LC028:  stab Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached    ; store b into memory
ClearTemp0ForResultStorage:
           clra                ; a = 0
           staa Temp0          ; store a into memory
           brset *BitFlags66, #$%00000001, INCLUDE_COOLANTTEMP_ANDIFNOTFLOORED_RPM_COMBINATION    ; branch if bit(s) set
           brset *BitFlags66, #$%00000010, INCLUDE_COOLANTTEMP_ANDIFNOTFLOORED_RPM_COMBINATION    ; branch if bit(s) set
           brset *BitFlags66, #$%10000000, LC03D    ; branch if bit(s) set
           brset *BitFlags6b, #$%00010000, INCLUDE_COOLANTTEMP_ANDIFNOTFLOORED_RPM_COMBINATION    ; branch if bit(s) set
   LC03D:  jsr  AllowForHeatSoakAfterStall    ; call subroutine
           brset *BitFlags67, #$%00000010, LC055    ; branch if bit(s) set
           ldx  #CURVEC_FuelColdEnrichmentCurveC    ; load index with value
           staa Temp1          ; store a into memory
           jsr  Lookup4ByteTable    ; call subroutine
           ldab Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           staa Temp0          ; store a into memory
           ldaa Temp1          ; load a with memory contents
   LC055:  ldx  #CURVEA_FuelColdEnrichmentCurveA    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           brclr *BitFlags67, #$%00000010, LC064    ; branch if bit(s) clear
           ldab Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
   LC064:  adda Temp0      
           staa Temp0          ; store a into memory
INCLUDE_COOLANTTEMP_ANDIFNOTFLOORED_RPM_COMBINATION:
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #CURVEB_FuelColdEnrichmentCurveB    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           brclr *BitFlags66, #$%00000001, THROT_NOT_FLOORED3    ; branch if bit(s) clear
           stab Temp1          ; store b into memory
           ldaa EngineRpm_HB    ; load a with memory contents
           ldx  #FCRCVB_FuelWOTScaleEnrichBFromRpm    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldab Temp1          ; load b with memory contents
           tsta                ; test a
           beq  IncludePartThrottleEnrichmentIfNotFullThrottle    ; branch if equal (zero)
           mul                 ; multiply (d=a*b)
           tab                 ; b = a
THROT_NOT_FLOORED3:
           clra                ; a = 0
IncludePartThrottleEnrichmentIfNotFullThrottle:
           addb Temp0          ; b=b+memory contents
           rola            
           asld                ; shift left (d=d*2)
           stD *Temp0          ; store D to RAM
           brset *BitFlags66, #$%00000001, LC0D9    ; branch if bit(s) set
           brset *BitFlags66, #$%00000010, LC0D9    ; branch if bit(s) set
           ldx  #HIGHM2_ColdLoadFromCoolantTemp2        ; load index with value
           brset *BitFlags66, #$%10000000, LC09E    ; branch if bit(s) set
           ldx  #HIGHMP_ColdLoadFromCoolantTemp        ; load index with value
   LC09E:  ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp4          ; store a into memory
           ldx  #HMPMU2_ColdLoadFromMAP2        ; load index with value
           brset *BitFlags66, #$%10000000, LC0AF    ; branch if bit(s) set
           ldx  #HMPMUL_ColdLoadFromMAP        ; load index with value
   LC0AF:  ldaa MapValue       ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp4          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           stD *Temp2          ; store D to RAM
           ldx  #PEFTBL2_PumpingEfficiency2        ; load index with value
           brset *BitFlags66, #$%10000000, LC0C8    ; branch if bit(s) set
           ldx  #PEFTBL_PumpingEfficiency    ; load index with value
   LC0C8:  ldaa EngineRpm_HB    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           ldY Temp2           ; load Y index
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           addd Temp0          ; d = d + memory contents
           stD *Temp0          ; store D to RAM
   LC0D9:  ldd  Temp0          ; load d (a&b) with memory contents
           pshb                ; push b onto stack
           psha                ; push a onto stack
           lsrd                ; shift right (d=d/2)
           stD *Temp0          ; store D to RAM
           ldaa BaroPressure    ; load a with memory contents
           ldx  #BAROCP_BaroCompensationOfWarmupFactor_FromBaro    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           puly                ; pop Y from stack
           beq  LC0FA          ; branch if equal (zero)
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           addd Temp0          ; d = d + memory contents
           bcc  HandleOffThrottleEnrich    ; branch if greater or equal
           ldd  #0xffff        ; load d (a&b) with value -11111111 11111111-
           bra  HandleOffThrottleEnrich    ; branch

   LC0FA:  ldd  Temp0          ; load d (a&b) with memory contents
HandleOffThrottleEnrich:
           inca                ; increment a
           stD *Temp0          ; store D to RAM
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           stab BaseFuelModifier    ; store b into memory
           ldaa ChargeTempVolts    ; load a with memory contents
           ldx  #AIRTMP_FuelEnrichmentFromChargeTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldx  #Temp0         ; load index with value
           ldaA #0x01          ; load a with value -00000001-
           jsr  ScaleXbyB_addingA_intoD    ; call subroutine
           stD *Temp0          ; store D to RAM
           ldab Timer_FuelEnrich    ; load b with memory contents
           beq  LeanMixtureFromDecel_ThrottleDecreasing    ; branch if equal (zero)
           ldaA #0x01          ; load a with value -00000001-
           jsr  ScaleXbyB_addingA_intoD    ; call subroutine
           stD *Temp0          ; store D to RAM
LeanMixtureFromDecel_ThrottleDecreasing:
           ldaa Timer_OffThrottleFuelEnrich    ; load a with memory contents
           beq  LEAN_MIXTURE_FROM_DECEL_MAP_DECREASING    ; branch if equal (zero)
           ldY Temp0           ; load Y index
           jsr  ScaleYbyA      ; call subroutine
           stY Temp0           ; store Y index
LEAN_MIXTURE_FROM_DECEL_MAP_DECREASING:
           ldaa Factor_DecelLeanoutWhenMAPDecreasing    ; load a with memory contents
           beq  INCLUDE_ADAPTIVE_MEMORY    ; branch if equal (zero)
           ldY Temp0           ; load Y index
           jsr  ScaleYbyA      ; call subroutine
           stY Temp0           ; store Y index
INCLUDE_ADAPTIVE_MEMORY:
           brset *BitFlags66, #$%00000001, LC155    ; branch if bit(s) set
           clra                ; a = 0
           ldab Timer_OpenLoopFraction    ; load b with memory contents
           bne  LC151          ; branch if not equal (not zero)
           ldab ValueFromAdaptiveMemory    ; load b with memory contents
           bmi  LC149          ; branch if minus(hi bit 1)
   LC148:  inca                ; increment a
   LC149:  asrb            
           jsr  ScaleXbyB_addingA_intoD    ; call subroutine
           stD *Temp0          ; store D to RAM
           bra  LC155          ; branch

   LC151:  ldab ValueFromAdaptiveMemory    ; load b with memory contents
           bpl  LC148          ; branch if plus (hi bit 0)
   LC155:  clra                ; a = 0
           ldab Counter_O2SensorFeedbackCount_Signed    ; load b with memory contents
           tstb            
           bmi  LC15C          ; branch if minus(hi bit 1)
           inca                ; increment a
   LC15C:  asrb            
           jsr  ScaleXbyB_addingA_intoD    ; call subroutine
           stD *Temp0          ; store D to RAM
           clrb                ; b = 0
           brset *BitFlags66, #$%10000000, INCLUDE_OXYGEN_FEEDBACK_WITHRPM_COMBINATION    ; branch if bit(s) set
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 91)
           bitA #0x01          ;  -00000001-
           beq  LC172          ; branch if equal (zero)
           brclr *BitFlags6b, #$%00010000, INCLUDE_OXYGEN_FEEDBACK_WITHRPM_COMBINATION    ; branch if bit(s) clear
   LC172:  ldaa EngineRpm_HB    ; load a with memory contents
           suba TargetIdleSpeedHB
           bcc  LC179          ; branch if greater or equal
           clra                ; a = 0
   LC179:  ldx  #DFBFMD_DefaultBaseFuelModifierFromRPMOverIdle    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
INCLUDE_OXYGEN_FEEDBACK_WITHRPM_COMBINATION:
           clra                ; a = 0
           stab BaseFuelScalar    ; store b into memory
           bne  LC185          ; branch if not equal (not zero)
           inca                ; increment a
   LC185:  ldx  #Temp0         ; load index with value
           jsr  ScaleXbyB_addingA_intoD    ; call subroutine
           stD *SumOfFuelModifiers_HB    ; store D to RAM
           rts                 ; return from subroutine

AllowForHeatSoakAfterStall:
           ldaa CoolantTemp    ; load a with memory contents
           cmpa RUNLMT_MaxAllowableTempFor_RUNTMP    ; compare a with memory contents (data is 80)
           bcc  LC1A8          ; branch if greater or equal
           ldaa EngineRunningTimeBeforeStall    ; load a with memory contents
           ldx  #RUNTMP_ModifierOf_ENGTMP_FromStalltime    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           adda CoolantTemp
           ldab RUNLMT_MaxAllowableTempFor_RUNTMP    ; load b with memory contents (data is 80)
           bcs  LC1A7          ; branch if lower
           cba             
           bcs  LC1A8          ; branch if lower
   LC1A7:  tba                 ; a = b
   LC1A8:  rts                 ; return from subroutine

DealWithSpecialIdle_SetBasicTiming_MM:
           brset *BitFlags66, #$%10000000, THROTTLE_PRESSED1    ; branch if bit(s) set
           ldaa RICHSA_OpenLoopEnrichFactorWhenSettingBasicTiming    ; load a with memory contents (data is 1a)
           brset *b5c_IPL1, #$%00000010, LC1C0    ; branch if bit(s) set
           brset *BitFlags6c, #$%00100000, LC1C0    ; branch if bit(s) set
           ldaa RIDLST_OpenLoopEnrichFactorWhenSettingMinThrottleOpening    ; load a with memory contents (data is 1a)
           brset *BitFlags6c, #$%00010000, LC1C0    ; branch if bit(s) set
           clra                ; a = 0
   LC1C0:  brclr *Timer_FuelEnrich, #$%11111111, LOAD_FUELENRICHVAR    ; branch if bit(s) clear
           tsta                ; test a
           bne  LOAD_FUELENRICHVAR    ; branch if not equal (not zero)
           ldaa O2ITIM_TimeO2InhibitedSwitchingRichIdleToClosedLoop    ; load a with memory contents (data is ff)
           staa Timer_O2InhibitSwitchingRichIdleToClosedLoop    ; store a into memory
THROTTLE_PRESSED1:
           clra                ; a = 0
LOAD_FUELENRICHVAR:
           staa Timer_FuelEnrich    ; store a into memory
           beq  LC1D6          ; branch if equal (zero)
           clra                ; a = 0
           staa Counter_O2SensorFeedbackCount_Signed    ; store a into memory
           staa Counter_AdaptiveMem_Erase    ; store a into memory
   LC1D6:  rts                 ; return from subroutine


;	.org	0xc1d7
CrankPickupIntrAddressTable:
	.word	CrankInterrupt_FallingEdge
	.word	CrankInterrupt_HandleCamSensorRisingEdgeA
	.word	CrankInterrupt_HandleCamSensorRisingEdgeB
	.word	CrankInterrupt_CalculateFuel

;	.org	0xc1df
NotSure1:
	.word	0x1001
	.word	0xeffe
	.word	0x2008

Interrupt_CrankSensor_Signal:
           ldaa CPU_PulseAccCounterRegister    ; load a with memory contents
           ldab #0x20          ; load b with value -00100000-
           bitb CPU_TimerInterruptFlag2
           beq  LC1F4          ; branch if equal (zero)
           stab CPU_TimerInterruptFlag2    ; store b into memory
           bra  LC209          ; branch

   LC1F4:  clrb                ; b = 0
           ldx  TimerOverflowsBetweenCamPulses
           cpx  #ErrorBitRegister0    ;  -00000000 00011111-
           bls  LC1FF          ; branch if lower or same
           incb            
           bra  LC206          ; branch

   LC1FF:  ldx  DistributorFallingEdgePulsewidth_HB
           cpx  #0x12e7        ;  -00010010 11100111-
           bls  LC209          ; branch if lower or same
   LC206:  cba             
           bls  LC219          ; branch if lower or same
   LC209:  ldaa PIA_Ctrl_3     ; load a with memory contents
           anda #0xfe          ; AND a with value -11111110-
           staa PIA_Ctrl_3 
           bclr *BitFlagsC0, #$%00000011    ; clear bits
           bset *BitFlagsC0, #$%11000100    ; set bits
           bra  LC21C          ; branch

   LC219:  clr  PIA_Ctrl_6          ; zero byte at memory location
   LC21C:  ldaA #0x01          ; load a with value -00000001-
           staa PIA_Ctrl_4 
           rti                 ; return from interrupt

Interrupt_CamSensorSignal:
           ldd  CPU_DistPickupCaptureRegHigh
           subd CPU_TimerInputCapture3
           ldx  TimerOverflowsBetweenCamPulses
           cpx  #ErrorBitRegister0    ;  -00000000 00011111-
           bls  LC238          ; branch if lower or same
           cmpD #ErrorBitRegister1    ; compare D -00000000 00100000-
           bra  LC243          ; branch

   LC235:  jmp  LC2E7      

   LC238:  ldx  DistributorFallingEdgePulsewidth_HB
           cpx  #0x12e7        ;  -00010010 11100111-
           bls  LC245          ; branch if lower or same
           cmpD #BitFlags_AIS    ; compare D -00000000 00010000-
   LC243:  bls  LC235          ; branch if lower or same
   LC245:  ldx  CPU_DistPickupCaptureRegHigh
           ldab #0x20          ; load b with value -00100000-
           abx                 ; add b to index
           ldaA #0x04          ; load a with value -00000100-
           staa CPU_TimerInterruptFlag1
   LC250:  bita CPU_PortA  
           beq  LC235          ; branch if equal (zero)
           cpx  CPU_TimerCounterRegHigh
           bpl  LC250          ; branch if plus (hi bit 0)
           ldaA #0x05          ; load a with value -00000101-
           staa CPU_TimerInterruptFlag1
           clra                ; a = 0
           staa CPU_PulseAccCounterRegister
           staa ATMOffset      ; store a into memory
           ldaa DRBPointer1    ; load a with memory contents
           cmpa #0x13          ; compare a with value -00010011-
           bne  LC26E          ; branch if not equal (not zero)
           bset *BitFlags71, #$%00100000    ; set bits
   LC26E:  cmpa #0x0a          ; compare a with value -00001010-
           bne  LC275          ; branch if not equal (not zero)
           clr  DRBPointer1    ; zero byte at memory location
   LC275:  ldab BitFlagsC0     ; load b with memory contents
           bpl  LC2D2          ; branch if plus (hi bit 0)
           ldaA #0x01          ; load a with value -00000001-
           bita PIA_Ctrl_5      
           beq  LC287          ; branch if equal (zero)
           ldaa #0xf9          ; load a with value -11111001-
           staa PIA_Ctrl_5      
           bra  LC2D2          ; branch

   LC287:  ldaa PIA_Ctrl_6          ; load a with memory contents
           beq  LC2D2          ; branch if equal (zero)
           cmpa #0x04          ; compare a with value -00000100-
           bhi  LC2D2          ; branch if higher
           bne  LC293          ; branch if not equal (not zero)
           clra                ; a = 0
   LC293:  brclr *BitFlagsC0, #$%00000100, LC2B8    ; branch if bit(s) clear
           bclr *BitFlagsC0, #$%00000111    ; clear bits
           brset *BitFlags6f, #$%00001000, LC2AC    ; branch if bit(s) set
           bset *BitFlags6f, #$%00001000    ; set bits
           bclr *BitFlags6f, #$%00000011    ; clear bits
           eora #0x02          ; XOR a with value -00000010-
           oraa BitFlags6f     ; OR a with memory contents
           staa BitFlags6f     ; store a into memory
           bra  LC2C1          ; branch

   LC2AC:  brset *BitFlags6f, #$%00000011, LC2B5    ; branch if bit(s) set
           inc  BitFlags6f 
           bra  LC2B8          ; branch

   LC2B5:  bclr *BitFlags6f, #$%00000011    ; clear bits
   LC2B8:  ldab BitFlags6f     ; load b with memory contents
           andb #0x03          ;  -00000011-
           eorb #0x02          ;  -00000010-
           cba             
           bne  LC2D2          ; branch if not equal (not zero)
   LC2C1:  ldab BitFlagsC0     ; load b with memory contents
           incb            
           stab BitFlagsC0     ; store b into memory
           andb #0x07          ;  -00000111-
           decb            
           lslb            
           ldx  #CrankPickupIntrAddressTable    ; load index with value
           abx                 ; add b to index
           ldx  0x00, X    
           jmp  0x00, X        ; indexed jump

   LC2D2:  bclr *BitFlags6f, #$%00001011    ; clear bits
           ldaa #0x40          ; load a with value -01000000-
           staa BitFlagsC0     ; store a into memory
           clr  PIA_Ctrl_6          ; zero byte at memory location
           ldaA #0x01          ; load a with value -00000001-
           staa PIA_Ctrl_4 
           oraa PIA_Ctrl_3 
           staa PIA_Ctrl_3 
   LC2E7:  ldaA #0x05          ; load a with value -00000101-
           staa CPU_TimerInterruptFlag1
           rti                 ; return from interrupt

CrankInterrupt_FallingEdge:
           ldaa #0x10          ; load a with value -00010000-
           staa CPU_A2DControlReg
           ldd  CPU_DistPickupCaptureRegHigh
           jsr  DetermineNumberOfOverflowsBetweenCamSensorPulses_MM    ; call subroutine
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           oraa #0x22          ;  -00100010-
           staa CPU_TimerControlReg1
           ldaa Counter_TimerPastHalfwayBetweenCamPulses    ; load a with memory contents
           lsra            
           staa TimerOverflowsBetweenCamPulses    ; store a into memory
           ldd  CPU_DistPickupCaptureRegHigh
           subd LastCamFallingEdgeTime    ; d = d - memory contents
           stD *DistributorFallingEdgePulsewidth_HB    ; store D to RAM
           ldd  CPU_DistPickupCaptureRegHigh
           stD *LastCamFallingEdgeTime    ; store D to RAM
           clra                ; a = 0
           staa Counter_TimerPastHalfwayBetweenCamPulses    ; store a into memory
           brclr *BitFlags71, #$%10000000, LC342    ; branch if bit(s) clear
           ldab BitFlags6f     ; load b with memory contents
           andb #0x03          ;  -00000011-
           decb            
           andb #0x03          ;  -00000011-
           ldx  #NotSure5      ; load index with value
           abx                 ; add b to index
           ldab 0x00, X        ; load b with memory at index + value
           ldx  #InjectorPulsewidth_HB_Cyl1    ; load index with value
           abx                 ; add b to index
           ldd  BaseInjectorPulsewidth_HB    ; load d (a&b) with memory contents
           std  0x00, X        ; store d into index plus offset
           cmpD #PreviousEngineRpm_LB    ; compare D -00000000 01111101-
           bls  LC342          ; branch if lower or same
           ldaa SwitchPortAccessReg1    ; load a with memory contents
           bita #0x10          ;  -00010000-
           beq  LC342          ; branch if equal (zero)
           bset *BitFlags6f, #$%00100000    ; set bits
           ldaA #0x04          ; load a with value -00000100-
           staa PIA_Ctrl_4 
   LC342:  ldx  #Cylinder2Retard    ; load index with value
           ldab BitFlags6f     ; load b with memory contents
           andb #0x03          ;  -00000011-
           decb            
           andb #0x03          ;  -00000011-
           abx                 ; add b to index
           ldaa CalculatedSparkAdvance    ; load a with memory contents
           suba 0x00, X    
           bcc  LC354          ; branch if greater or equal
           clra                ; a = 0
   LC354:  staa AdvanceTemporary    ; store a into memory
           jsr  NULL_ROUTINE    ; call subroutine
           staa AdvanceTemporary    ; store a into memory
           ldaa #0x93          ; load a with value -10010011-
           suba AdvanceTemporary
           ldab #0xb6          ; load b with value -10110110-
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           ldY DistributorFallingEdgePulsewidth_HB    ; load Y index
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           addd CPU_DistPickupCaptureRegHigh
           subd #DCCOR4_AdaptiveWastegateCellTo5504rpm    ;  -00000000 00001010-
           stD *Temp5          ; store D to RAM
           ldab Timer_Dwell_14    ; load b with memory contents
           ldaa BitFlags6f     ; load a with memory contents
           andA #0x01          ; AND a with value -00000001-
           beq  LC37E          ; branch if equal (zero)
           ldab Timer_Dwell_23    ; load b with memory contents
   LC37E:  clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd #0x07d0        ;  -00000111 11010000-
           stD *Temp7          ; store D to RAM
           ldd  Temp5          ; load d (a&b) with memory contents
           subd Temp7          ; d = d - memory contents
           stD *Temp7          ; store D to RAM
           ldab BitFlags6f     ; load b with memory contents
           andb #0x01          ;  -00000001-
           ldx  #CPU_Timer_OC3_Wastegate    ; load index with value
           ldY #NotSure1       ; load Y index -11000001 11011111-
           aby                 ; add b to y
           lslb            
           lslb            
           abx                 ; add b to index
           ldaa TimerOverflowsBetweenCamPulses    ; load a with memory contents
           bne  LC3AE          ; branch if not equal (not zero)
           ldab STRNTR_SparkStartRunTransferPointRpm    ; load b with memory contents (data is 62)
           brset *BitFlags6e, #$%00000010, LC3AA    ; branch if bit(s) set
           ldab RNSTTR_SparkRunStartTransferPointRpm    ; load b with memory contents (data is 82)
   LC3AA:  cmpb DistributorFallingEdgePulsewidth_HB
           bcc  LC3B3          ; branch if greater or equal
   LC3AE:  bset *BitFlags6e, #$%00000010    ; set bits
           bra  LC3BC          ; branch

   LC3B3:  bclr *BitFlags6e, #$%00000010    ; clear bits
           ldab DistributorFallingEdgePulsewidth_HB    ; load b with memory contents
           cmpb #0x50          ;  -01010000-
           bcs  LC3BF          ; branch if lower
   LC3BC:  jmp  LC467      

   LC3BF:  ldd  Temp7          ; load d (a&b) with memory contents
           std  0x00, X        ; store d into index plus offset
           ldaA 4, Y       ; load A indexed to Y -00000100-
           tab                 ; b = a
           oraa CPU_TimerInterruptMask1
           staa CPU_TimerInterruptMask1
           stab CPU_TimerInterruptFlag1    ; store b into memory
           ldab CPU_TimerControlReg1    ; load b with memory contents
           oraB 0, Y       ; or B with memory at index Y + value -00000000-
           stab CPU_TimerControlReg1    ; store b into memory
           ldd  0x00, X    
           subd #MapVolts      ;  -00000000 10000000-
           subd CPU_TimerCounterRegHigh
           bpl  LC40D          ; branch if plus (hi bit 0)
           ldaA 4, Y       ; load A indexed to Y -00000100-
           staa CPU_HardwareTimerForceCompare
           ldd  Temp5          ; load d (a&b) with memory contents
           std  0x00, X        ; store d into index plus offset
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           andA 2, Y       ; and A with memory at index Y + value -00000010-
           staa CPU_TimerControlReg1
           ldaA 4, Y       ; load A indexed to Y -00000100-
           coma            
           anda CPU_TimerInterruptMask1
           staa CPU_TimerInterruptMask1
           ldd  0x00, X    
           subd CPU_TimerCounterRegHigh
           bpl  LC40D          ; branch if plus (hi bit 0)
           ldaA 4, Y       ; load A indexed to Y -00000100-
           staa CPU_HardwareTimerForceCompare
   LC40D:  ldab BitFlags6f     ; load b with memory contents
           andb #0x01          ;  -00000001-
           eorb #0x01          ;  -00000001-
           tba                 ; a = b
           ldY #NotSure1       ; load Y index -11000001 11011111-
           aby                 ; add b to y
           lslb            
           lslb            
           ldx  #CPU_Timer_OC3_Wastegate    ; load index with value
           abx                 ; add b to index
           ldab Timer_Dwell_14    ; load b with memory contents
           tsta                ; test a
           beq  LC427          ; branch if equal (zero)
           ldab Timer_Dwell_23    ; load b with memory contents
   LC427:  clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd #0x07d0        ;  -00000111 11010000-
           stD *Temp7          ; store D to RAM
           ldd  Temp5          ; load d (a&b) with memory contents
           subd Temp7          ; d = d - memory contents
           addd DistributorFallingEdgePulsewidth_HB    ; d = d + memory contents
           std  0x00, X        ; store d into index plus offset
           ldab CPU_TimerControlReg1    ; load b with memory contents
           oraB 0, Y       ; or B with memory at index Y + value -00000000-
           stab CPU_TimerControlReg1    ; store b into memory
           ldaB 4, Y       ; load B with value indexed to Y -00000100-
           tba                 ; a = b
           orab CPU_TimerInterruptMask1
           stab CPU_TimerInterruptMask1    ; store b into memory
           staa CPU_TimerInterruptFlag1
           ldd  0x00, X    
           subd #MapVolts      ;  -00000000 10000000-
           subd CPU_TimerCounterRegHigh
           bpl  LC467          ; branch if plus (hi bit 0)
           ldaA 4, Y       ; load A indexed to Y -00000100-
           staa CPU_HardwareTimerForceCompare
           ldaA 4, Y       ; load A indexed to Y -00000100-
           coma            
           anda CPU_TimerInterruptMask1
           staa CPU_TimerInterruptMask1
   LC467:  ldaa CPU_A2DControlReg    ; load a with memory contents
           bpl  LC467          ; branch if plus (hi bit 0)
           ldaA #0x06          ; load a with value -00000110-
           ldab CPU_A2DResults1    ; load b with memory contents
           staa CPU_A2DControlReg
           brset *BitFlags68, #$%10000000, LC4E0    ; branch if bit(s) set
           stab MapVolts       ; store b into memory
           ldaa BitFlags648b    ; load a with memory contents
           andA #0x0f          ; AND a with value -00001111-
           inca                ; increment a
           cmpa MPDELX_DeltaMapThatChecksGoodX    ; compare a with memory contents (data is 02)
           bcc  LC4AB          ; branch if greater or equal
           inc  BitFlags648b
           jmp  LC53D


;	.org	0xc48b
NotSure2:
	.word	0x7070
	.word	0x3020
	.word	0x1010
	.word	0x0000
	.word	0x0000
	.word	0x0000
	.word	0x0000
	.word	0x0000
	.word	0xF0F0
	.word	0xB080
	.word	0x5040
	.word	0x3030
	.word	0x2020
	.word	0x2010
	.word	0x1010
	.word	0x1010

   LC4AB:  ldx  #BitFlags648b    ; load index with value
           bclr 0, X, #$%00001111    ; bit clear -00000000-
           ldaa MapValueX      ; load a with memory contents
           suba MapVoltsX  
           stab MapValueX      ; store b into memory
           stab MapVoltsX      ; store b into memory
           brset *b5c_IPL1, #$%10000000, LC4E2    ; branch if bit(s) set
           cmpa MPDELT_DeltaMapThatChecksGood    ; compare a with memory contents (data is 01)
           bcc  LC537          ; branch if greater or equal
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           cmpD MPRPML_DisableMapCheckUnderThisRpm_600    ; compare D (data is 12)
           bcs  LC53D          ; branch if lower
           cmpD MPRPMH_DisableMapCheckAboveThisRpm_1500    ; compare D (data is 2e)
           bcc  LC53D          ; branch if greater or equal
           ldaa MapVolts       ; load a with memory contents
           cmpa MPDAGL_DisableMapCheckBelowThisMap    ; compare a with memory contents (data is 10)
           bcs  LC53D          ; branch if lower
           cmpa MPDAGH_DisableMapCheckAboveThisMap    ; compare a with memory contents (data is 81)
           bcs  LC506          ; branch if lower
   LC4E0:  bra  LC53D          ; branch

   LC4E2:  suba MPDELT_DeltaMapThatChecksGood    ;  (data is 01)
           bcs  LC537          ; branch if lower
           cmpa MPDELA_MatureMapLimpinWhenDeltaAbove_MPDELT_plus_MPDELA    ; compare a with memory contents (data is 01)
           bcs  LC537          ; branch if lower
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           cmpD #0x0040    ; compare D -00000000 01000000-
           bcc  LC506          ; branch if greater or equal
           brset *BitFlags66, #$%10000000, LC506    ; branch if bit(s) set
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  LC500          ; branch if greater or equal
           coma            
           comb            
   LC500:  cmpD MPRMPD_CheckMapAtZeroSpeedAndThisDeltaRpm    ; compare D (data is 02)
           bcs  LC537          ; branch if lower
   LC506:  ldab BitFlags648b    ; load b with memory contents
           addb #0x10          ;  -00010000-
           bcc  LC50F          ; branch if greater or equal
           orab #0xf0          ;  -11110000-
   LC50F:  stab BitFlags648b    ; store b into memory
           ldab MPDELX_DeltaMapThatChecksGoodX    ; load b with memory contents (data is 02)
           ldx  #NotSure2      ; load index with value
           abx                 ; add b to index
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa #0x20          ; compare a with value -00100000-
           bls  LC522          ; branch if lower or same
           ldab #0x10          ; load b with value -00010000-
           abx                 ; add b to index
   LC522:  ldaa 0x00, X        ; load a with memory at index + value
           cmpa BitFlags648b    ; compare a with memory contents
           bcc  LC53D          ; branch if greater or equal
           brset *b5c_IPL1, #$%10000000, LC532    ; branch if bit(s) set
           bset *BitFlags5E, #$%10000000    ; set bits
           bra  LC537          ; branch

   LC532:  ldaA #0x08          ; load a with value -00001000-
           jsr  ResetErrorCodeIfTimerExpired    ; call subroutine
   LC537:  ldx  #BitFlags648b    ; load index with value
           bclr 0, X, #$%11110000    ; bit clear -00000000-
   LC53D:  ldab #0x10          ; load b with value -00010000-
   LC53F:  ldaa CPU_A2DControlReg    ; load a with memory contents
           bpl  LC53F          ; branch if plus (hi bit 0)
           ldaa CPU_A2DResults1    ; load a with memory contents
           stab CPU_A2DControlReg    ; store b into memory
           brclr *BitFlags6e, #$%00000010, LC54F    ; branch if bit(s) clear
           clra                ; a = 0
   LC54F:  staa KnockVolts     ; store a into memory
           bset *PIA_Buffer2, #pia_KnockCap    ; set bits
           ldaa PIA_Buffer2    ; load a with memory contents
           staa PortX_Control
           brset *BitFlags6b, #$%00000010, DontUseSparkScatter    ; branch if bit(s) set
           ldaa SparkScatter    ; load a with memory contents
           adda SparkScatterIncrement
           bvc  DoUseSparkScatter    ; branch if overflow
           ldab DesiredNewAisPosition    ; load b with memory contents
           cmpb CurrentAisPosition
           bne  DontUseSparkScatter    ; branch if not equal (not zero)
           ldab FTUNPW_FineTuneStepForAis    ; load b with memory contents (data is 01)
           beq  DontUseSparkScatter    ; branch if equal (zero)
           tsta                ; test a
           bmi  LC579          ; branch if minus(hi bit 1)
           ldaa DesiredNewAisPosition    ; load a with memory contents
           sba                 ; subtract (a=a-b)
           bcc  SaveDesiredAisPosition    ; branch if greater or equal
           clra                ; a = 0
           bra  SaveDesiredAisPosition    ; branch

   LC579:  ldaa AISHLM_AisHighLimitMaxOpenSteps    ; load a with memory contents (data is a0)
           addb DesiredNewAisPosition    ; b=b+memory contents
           bcs  SaveDesiredAisPosition    ; branch if lower
           cba             
           bls  SaveDesiredAisPosition    ; branch if lower or same
           tba                 ; a = b
SaveDesiredAisPosition:
           staa DesiredNewAisPosition    ; store a into memory
DontUseSparkScatter:
           clra                ; a = 0
DoUseSparkScatter:
           staa SparkScatterIncrement    ; store a into memory
           ldaa Counter_SomethingWithCamSensor    ; load a with memory contents
           inca                ; increment a
           beq  LC590          ; branch if equal (zero)
           staa Counter_SomethingWithCamSensor    ; store a into memory
   LC590:  bset *PIA_Buffer2, #pia_Tach    ; set bits
           ldaa PIA_Buffer2    ; load a with memory contents
           staa PortX_Control
           rti                 ; return from interrupt


;	.org	0xc599
NotSure4:
	.byte	0x01
        .byte   0x08

   LC59B:  jmp  LC67A

CrankInterrupt_HandleCamSensorRisingEdgeA:
           ldd  TimerOverflowsBetweenCamPulses    ; load d (a&b) with memory contents
           cmpD #0x000e    ; compare D -00000000 00001110-
           bcs  LC59B          ; branch if lower
           ldd  CPU_DistPickupCaptureRegHigh
           stD *FDRVar1        ; store D to RAM
           subd LastCamFallingEdgeTime    ; d = d - memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           xgDY                ; exchange D and Y
           ldaa #0x66          ; load a with value -01100110-
           suba AdvanceTemporary
           bcs  LC59B          ; branch if lower
           ldab #0xb6          ; load b with value -10110110-
           mul                 ; multiply (d=a*b)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           addd CPU_DistPickupCaptureRegHigh
           subd #DCCOR4_AdaptiveWastegateCellTo5504rpm    ;  -00000000 00001010-
           stD *Temp5          ; store D to RAM
           ldab BitFlags6f     ; load b with memory contents
           andb #0x01          ;  -00000001-
           tba                 ; a = b
           ldY #NotSure1       ; load Y index -11000001 11011111-
           aby                 ; add b to y
           lslb            
           lslb            
           ldx  #CPU_Timer_OC3_Wastegate    ; load index with value
           abx                 ; add b to index
           ldab Timer_Dwell_14    ; load b with memory contents
           tsta                ; test a
           beq  LC5E3          ; branch if equal (zero)
           ldab Timer_Dwell_23    ; load b with memory contents
   LC5E3:  clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd #0x07d0        ;  -00000111 11010000-
           stD *Temp7          ; store D to RAM
           brset *BitFlags6e, #$%00000010, LC5F5    ; branch if bit(s) set
           ldaa DistributorFallingEdgePulsewidth_HB    ; load a with memory contents
           cmpa #0x50          ; compare a with value -01010000-
           bcs  LC606          ; branch if lower
   LC5F5:  ldaa CPU_TimerControlReg1    ; load a with memory contents
           oraA 0, Y       ; or A with memory at index Y + value -00000000-
           staa CPU_TimerControlReg1
           ldaB 4, Y       ; load B with value indexed to Y -00000100-
           stab CPU_TimerInterruptFlag1    ; store b into memory
           bra  LC674          ; branch

   LC606:  ldaa CPU_PortA      ; load a with memory contents
           bitA 4, Y       ; bit A with memory at index Y + value -00000100-
           bne  LC63C          ; branch if not equal (not zero)
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           bitA 0, Y       ; bit A with memory at index Y + value -00000000-
           beq  LC67A          ; branch if equal (zero)
           ldd  Temp5          ; load d (a&b) with memory contents
           subd Temp7          ; d = d - memory contents
           std  0x00, X        ; store d into index plus offset
           ldab CPU_TimerControlReg1    ; load b with memory contents
           oraB 0, Y       ; or B with memory at index Y + value -00000000-
           stab CPU_TimerControlReg1    ; store b into memory
           ldd  0x00, X    
           subd #MapVolts      ;  -00000000 10000000-
           subd CPU_TimerCounterRegHigh
           bpl  LC67A          ; branch if plus (hi bit 0)
           ldaA 4, Y       ; load A indexed to Y -00000100-
           staa CPU_HardwareTimerForceCompare
           ldd  CPU_TimerCounterRegHigh
           addd Temp7          ; d = d + memory contents
           stD *Temp5          ; store D to RAM
   LC63C:  ldaA 4, Y       ; load A indexed to Y -00000100-
           coma            
           anda CPU_TimerInterruptMask1
           staa CPU_TimerInterruptMask1
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           bitA 0, Y       ; bit A with memory at index Y + value -00000000-
           beq  LC65D          ; branch if equal (zero)
           ldd  0x00, X    
           addd Temp7          ; d = d + memory contents
           std  0x00, X        ; store d into index plus offset
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           andA 2, Y       ; and A with memory at index Y + value -00000010-
           staa CPU_TimerControlReg1
   LC65D:  ldd  Temp5          ; load d (a&b) with memory contents
           subd 0x00, X    
           bmi  LC66D          ; branch if minus(hi bit 1)
           cmpD #ErrorBitRegister1    ; compare D -00000000 00100000-
           bcs  LC66D          ; branch if lower
           ldd  Temp5          ; load d (a&b) with memory contents
           std  0x00, X        ; store d into index plus offset
   LC66D:  ldd  0x00, X    
           subd CPU_TimerCounterRegHigh
           bpl  LC67A          ; branch if plus (hi bit 0)
   LC674:  ldaA 4, Y       ; load A indexed to Y -00000100-
           staa CPU_HardwareTimerForceCompare
   LC67A:  rti                 ; return from interrupt

   LC67B:  jmp  LC75F      

CrankInterrupt_HandleCamSensorRisingEdgeB:
           ldd  TimerOverflowsBetweenCamPulses    ; load d (a&b) with memory contents
           cmpD #0x000e    ; compare D -00000000 00001110-
           bcs  LC67B          ; branch if lower
           ldd  CPU_DistPickupCaptureRegHigh
           subd FDRVar1        ; d = d - memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           xgDY                ; exchange D and Y
           ldaa #0x39          ; load a with value -00111001-
           suba AdvanceTemporary
           bcc  LC696          ; branch if greater or equal
           clra                ; a = 0
   LC696:  ldab #0xb6          ; load b with value -10110110-
           mul                 ; multiply (d=a*b)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           addd CPU_DistPickupCaptureRegHigh
           subd #DCCOR4_AdaptiveWastegateCellTo5504rpm    ;  -00000000 00001010-
           stD *Temp5          ; store D to RAM
           ldab BitFlags6f     ; load b with memory contents
           andb #0x01          ;  -00000001-
           tba                 ; a = b
           ldY #NotSure1       ; load Y index -11000001 11011111-
           aby                 ; add b to y
           lslb            
           lslb            
           ldx  #CPU_Timer_OC3_Wastegate    ; load index with value
           abx                 ; add b to index
           ldab Timer_Dwell_14    ; load b with memory contents
           tsta                ; test a
           beq  LC6C2          ; branch if equal (zero)
           ldab Timer_Dwell_23    ; load b with memory contents
   LC6C2:  clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd #0x07d0        ;  -00000111 11010000-
           stD *Temp7          ; store D to RAM
           brset *BitFlags6e, #$%00000010, LC67B    ; branch if bit(s) set
           ldaa DistributorFallingEdgePulsewidth_HB    ; load a with memory contents
           cmpa #0x50          ; compare a with value -01010000-
           bcs  LC6E5          ; branch if lower
           ldd  Temp5          ; load d (a&b) with memory contents
           std  0x00, X        ; store d into index plus offset
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           andA 2, Y       ; and A with memory at index Y + value -00000010-
           staa CPU_TimerControlReg1
           ldd  Temp5          ; load d (a&b) with memory contents
           bra  LC754          ; branch

   LC6E5:  ldaa CPU_PortA      ; load a with memory contents
           bitA 4, Y       ; bit A with memory at index Y + value -00000100-
           bne  LC721          ; branch if not equal (not zero)
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           bitA 0, Y       ; bit A with memory at index Y + value -00000000-
           beq  LC75F          ; branch if equal (zero)
           ldd  Temp5          ; load d (a&b) with memory contents
           subd Temp7          ; d = d - memory contents
           std  0x00, X        ; store d into index plus offset
           ldab CPU_TimerControlReg1    ; load b with memory contents
           oraB 0, Y       ; or B with memory at index Y + value -00000000-
           stab CPU_TimerControlReg1    ; store b into memory
           ldaB 4, Y       ; load B with value indexed to Y -00000100-
           stab CPU_TimerInterruptFlag1    ; store b into memory
           ldd  0x00, X    
           subd #MapVolts      ;  -00000000 10000000-
           subd CPU_TimerCounterRegHigh
           bpl  LC75F          ; branch if plus (hi bit 0)
           ldaA 4, Y       ; load A indexed to Y -00000100-
           staa CPU_HardwareTimerForceCompare
           ldd  CPU_TimerCounterRegHigh
           addd Temp7          ; d = d + memory contents
           stD *Temp5          ; store D to RAM
   LC721:  ldaA 4, Y       ; load A indexed to Y -00000100-
           coma            
           anda CPU_TimerInterruptMask1
           staa CPU_TimerInterruptMask1
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           bitA 0, Y       ; bit A with memory at index Y + value -00000000-
           beq  LC742          ; branch if equal (zero)
           ldd  0x00, X    
           addd Temp7          ; d = d + memory contents
           std  0x00, X        ; store d into index plus offset
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           andA 2, Y       ; and A with memory at index Y + value -00000010-
           staa CPU_TimerControlReg1
   LC742:  ldd  Temp5          ; load d (a&b) with memory contents
           subd 0x00, X    
           bmi  LC752          ; branch if minus(hi bit 1)
           cmpD #ErrorBitRegister1    ; compare D -00000000 00100000-
           bcs  LC752          ; branch if lower
           ldd  Temp5          ; load d (a&b) with memory contents
           std  0x00, X        ; store d into index plus offset
   LC752:  ldd  0x00, X    
   LC754:  subd CPU_TimerCounterRegHigh
           bpl  LC75F          ; branch if plus (hi bit 0)
           ldaA 4, Y       ; load A indexed to Y -00000100-
           staa CPU_HardwareTimerForceCompare
   LC75F:  rti                 ; return from interrupt

;	.org	0xc760
NotSure5:
	.byte	0x06, 0x02
	.byte	0x00, 0x04

; 	.org	0xc764
; MAPLO_LoMAP3DInputModifierFromMAP:
; 	.byte	2						; number of points
; 	.byte	0x18, 0x00, 0x06, 0x67	; point 1
; 	.byte	0x3f, 0xfa				; point 2
; 
; 	.org	0xc76b
; MAPHI_HiMAP3DInputModifierFromMAP:
; 	.byte	3						; number of points
; 	.byte	0x40, 0x00, 0x02, 0x00	; point 1
; 	.byte	0x90, 0xa0, 0x01, 0x00	; point 2
; 	.byte	0xef, 0xff				; point 3

CrankInterrupt_CalculateFuel:
           ldaa #0x10          ; load a with value -00010000-
           staa CPU_A2DControlReg
           brclr *BitFlags6e, #$%00000010, LC79E    ; branch if bit(s) clear
           ldab BitFlags6f     ; load b with memory contents
           andb #0x01          ;  -00000001-
           ldx  #CPU_Timer_OC3_Wastegate    ; load index with value
           ldY #NotSure1       ; load Y index -11000001 11011111-
           aby                 ; add b to y
           lslb            
           lslb            
           abx                 ; add b to index
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           andA 2, Y       ; and A with memory at index Y + value -00000010-
           staa CPU_TimerControlReg1
           ldaA 4, Y       ; load A indexed to Y -00000100-
           staa CPU_HardwareTimerForceCompare
   LC79E:  ldd  #0x0101       ; load d (a&b) with value -00000001 00000001-
           orab PIA_Ctrl_2 
           stab PIA_Ctrl_2     ; store b into memory
           staa PIA_Ctrl_4 
           clr  CPU_PulseAccCounterRegister    ; zero byte at memory location
           clr  PIA_Ctrl_6          ; zero byte at memory location
           oraa PIA_Ctrl_3 
           staa PIA_Ctrl_3 
           ldab TimerOverflowsBetweenCamPulses    ; load b with memory contents
           bne  LC7C6          ; branch if not equal (not zero)
           ldab DistributorFallingEdgePulsewidth_HB    ; load b with memory contents
           cmpb RNFPRD_FuelStartRunTransferPointRpm    ; compare b with memory contents (data is 60)
           bcs  LC7CB          ; branch if lower
           cmpb STFPRD_FuelRunStartTransferPointRpm    ; compare b with memory contents (data is 82)
           bcs  LC7EA          ; branch if lower
   LC7C6:  bset *BitFlags6e, #$%10010000    ; set bits
           bra  LC7EA          ; branch

   LC7CB:  brclr *BitFlags6e, #$%10000000, LC7EA    ; branch if bit(s) clear
           bclr *BitFlags6e, #$%10100000    ; clear bits
           ldd  #0x0000         ; load d (a&b) with value -00000000 00000000-
           stD *KeyOnOrEngineRunningTime    ; store D to RAM
           stD *Pulsewidth_PartThrottleEnrichment_HB    ; store D to RAM
           staa ATMOffset      ; store a into memory
           ldaa AISDLY_DelayFromStartRunThatAisFeedbackDisabled    ; load a with memory contents (data is 5d)
           staa Timer_CountdownFromStartRunForAisFeedback    ; store a into memory
           ldaa AdaptiveRetardIndex    ; load a with memory contents
           suba ARSUBC_AdaptiveRetardFactorSubtract    ;  (data is 40)
           bcc  LC7E8          ; branch if greater or equal
           clra                ; a = 0
   LC7E8:  staa AdaptiveRetardIndex    ; store a into memory
   LC7EA:  ldaa Counter_EPP_MaxFF    ; load a with memory contents
           inca                ; increment a
           beq  LC7F1          ; branch if equal (zero)
           staa Counter_EPP_MaxFF    ; store a into memory
   LC7F1:  ldab Counter_FallingEdgeEPP_MaxFF    ; load b with memory contents
           asld                ; shift left (d=d*2)
           addb #0x02          ;  -00000010-
           bcs  LC7FB          ; branch if lower
           lsrd                ; shift right (d=d/2)
           stab Counter_FallingEdgeEPP_MaxFF    ; store b into memory
   LC7FB:  inc  AdaptiveCellUpdateTimer_IncrementedEveryCamRisingEdge
           inc  Timer_O2ToggleDuration
           ldaa Counter_SomethingWithCamSensor    ; load a with memory contents
           inca                ; increment a
           beq  LC808          ; branch if equal (zero)
           staa Counter_SomethingWithCamSensor    ; store a into memory
   LC808:  bclr *PIA_Buffer2, #pia_KnockCap | pia_Tach    ; clear bits
           ldab PIA_Buffer2    ; load b with memory contents
           stab PortX_Control    ; store b into memory
           ldx  #TpsAverageValue_HB    ; load index with value
           jsr  ProcessMapOrTpsBlockData    ; call subroutine
   LC816:  ldaa CPU_A2DControlReg    ; load a with memory contents
           bpl  LC816          ; branch if plus (hi bit 0)
           ldaa CPU_A2DResults1    ; load a with memory contents
           brset *BitFlags68, #$%10000000, MAYBE_DO_BAROREADING    ; branch if bit(s) set
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb #0x2e          ;  -00101110-
           bcc  GREATER_THAN_1472RPM    ; branch if greater or equal
           ldab TpsVolts       ; load b with memory contents
           subb MINTHR_LowestSessionTPS    ; b = b-memory contents
           bcs  LC833          ; branch if lower
           cmpb MPLTHR_ThrottleLevelAbove_MINTHR_ToMatureMapLimpin    ; compare b with memory contents (data is 42)
           bcc  GREATER_THAN_1472RPM    ; branch if greater or equal
   LC833:  cmpa MAPHIG_MapSensorUpperLimit    ; compare a with memory contents (data is ee)
           bcc  LC841          ; branch if greater or equal
           cmpa MAPLOW_MapSensorLowerLimit    ; compare a with memory contents (data is 01)
           bcs  LC841          ; branch if lower
GREATER_THAN_1472RPM:
           brclr *b5c_IPL1, #$%10100000, GET_AVERAGE_MAP_READING    ; branch if bit(s) clear
   LC841:  jsr  SimulateMapReadingFromTps    ; call subroutine
           bra  LC849          ; branch

GET_AVERAGE_MAP_READING:
           adda MapVolts   
           rora            
   LC849:  jsr  ConvertMAPVoltsToValue    ; call subroutine
           staa MapValue       ; store a into memory
           bra  CALC_SPARK_RETARD_BASED_ON_KNOCK_VOLT    ; branch

MAYBE_DO_BAROREADING:
           brclr *BitFlags6e, #$%00001000, CALC_SPARK_RETARD_BASED_ON_KNOCK_VOLT    ; branch if bit(s) clear
           bclr *BitFlags6e, #$%00001000    ; clear bits
           jsr  SaveBaroPressure    ; call subroutine
CALC_SPARK_RETARD_BASED_ON_KNOCK_VOLT:
           ldx  #Cylinder2Retard    ; load index with value
           ldab BitFlags6f     ; load b with memory contents
           andb #0x03          ;  -00000011-
           eorb #0x02          ;  -00000010-
           abx                 ; add b to index
           ldab 0x00, X        ; load b with memory at index + value
           ldaa KnockVolts     ; load a with memory contents
           cmpa KnockSensorThreshold    ; compare a with memory contents
           bcc  CHECK_FOR_OVER5PSIBOOST    ; branch if greater or equal
           clra                ; a = 0
           bra  SUM_ADDITIONAL_RETARD    ; branch

CHECK_FOR_OVER5PSIBOOST:
           ldaa BaroPressure    ; load a with memory contents
           adda KNKOFS_DeltaAboveBaroFor_RTRDRT_and_KNKCNT_and_KNKCOR_incremented    ;  (data is 2f)
           cmpa MapValue       ; compare a with memory contents
           ldaa RTRDRT_KnockRetardRateNoBoost    ; load a with memory contents (data is 09)
           bcc  SUM_ADDITIONAL_RETARD    ; branch if greater or equal
           bset *BitFlags71, #$%01000000    ; set bits
           ldaa RTRDRT2_KnockRetardRateInBoost    ; load a with memory contents (data is 04)
SUM_ADDITIONAL_RETARD:
           aba                 ; a=a+b
           cmpa #0x40          ; compare a with value -01000000-
           bcs  MAX_RETARD     ; branch if lower
           ldaa #0x3f          ; load a with value -00111111-
MAX_RETARD:
           ldab MaxRetardFromMAP    ; load b with memory contents
           cba             
           bcs  STORE_SMALLEST_RETARD_VALUE    ; branch if lower
           tba                 ; a = b
STORE_SMALLEST_RETARD_VALUE:
           staa 0x00, X    
           ldab CONFIG_ConfigurationFlags    ; load b with memory contents (data is 91)
           andb #0x01          ;  -00000001-
           beq  THROTTLE_HAS_DECREASED    ; branch if equal (zero)
           staa Cylinder1Retard    ; store a into memory
           staa Cylinder2Retard    ; store a into memory
           staa Cylinder3Retard    ; store a into memory
           staa Cylinder4Retard    ; store a into memory
THROTTLE_HAS_DECREASED:
           ldx  #MapAverageValue_HB    ; load index with value
           jsr  ProcessMapOrTpsBlockData    ; call subroutine
           bclr *BitFlagsC0, #$%00001000    ; clear bits
           ldaa #0x82          ; load a with value -10000010-
           brset *BitFlags6e, #$%00000010, LC8B0    ; branch if bit(s) set
           ldaa #0xc2          ; load a with value -11000010-
   LC8B0:  cmpa BatteryVolts    ; compare a with memory contents
           bcc  LC909          ; branch if greater or equal
           ldaa SwitchPortAccessReg1    ; load a with memory contents
           bita #0x10          ;  -00010000-
           beq  LC909          ; branch if equal (zero)
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa #0x9d          ; compare a with value -10011101-
           bcc  LC909          ; branch if greater or equal
           ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           bne  LC909          ; branch if not equal (not zero)
           ldaa CPU_PortA      ; load a with memory contents
           bita #0x28          ;  -00101000-
           bne  LC909          ; branch if not equal (not zero)
           bset *BitFlagsC0, #$%00001000    ; set bits
           ldaa PIA_Ctrl_4     ; load a with memory contents
           bitA #0x02          ;  -00000010-
           bne  LC904          ; branch if not equal (not zero)
           ldab BitFlags6f     ; load b with memory contents
           andb #0x01          ;  -00000001-
           brset *BitFlags6e, #$%00000010, LC8F6    ; branch if bit(s) set
           ldx  #Timer_Dwell_14    ; load index with value
           abx                 ; add b to index
           ldaa 0x00, X        ; load a with memory at index + value
           adda #0x0c          ;  -00001100-
           bcc  LC8EA          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LC8EA:  cmpa #0xbc          ; compare a with value -10111100-
           bcc  LC8F2          ; branch if greater or equal
           staa 0x00, X    
           bra  LC904          ; branch

   LC8F2:  ldaa #0xbc          ; load a with value -10111100-
           staa 0x00, X    
   LC8F6:  brset *b5c_IPL1, #$%00010000, LC904    ; branch if bit(s) set
           ldx  #NotSure4      ; load index with value
           abx                 ; add b to index
           ldab 0x00, X        ; load b with memory at index + value
           orab BitFlags5E 
           stab BitFlags5E     ; store b into memory
   LC904:  ldaB #0x02          ; load b with value -00000010-
           stab PIA_Ctrl_4     ; store b into memory
   LC909:  brclr *CCDFlags5, #ccd_AlarmDisable, LC910    ; branch if bit(s) clear
           jmp  ClearInjectorPW ; antitheft shutdown is here, change this to NOP to disable... C90d, e, f
           ;
           ; c90d  nop ; 0x01
           ; c90e  nop ; 0x01
           ; c90f  nop ; 0x01

   LC910:  brset *BitFlags6e, #$%10000000, LC98C    ; branch if bit(s) set
           ldaa CoolantTemp    ; load a with memory contents
           cmpa SRTMTP_SparkTempSwitchPointFor_SRTIME    ; compare a with memory contents (data is 58)
           bcs  LC941          ; branch if lower
           brset *BitFlags66, #$%10000000, LC941    ; branch if bit(s) set
           brclr *BitFlags67, #$%01000000, LC92A    ; branch if bit(s) clear
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 91)
           bita #0x10          ;  -00010000-
           beq  LC941          ; branch if equal (zero)
   LC92A:  brset *BitFlags71, #$%10000000, LC944    ; branch if bit(s) set
           ldd  KeyOnOrEngineRunningTime    ; load d (a&b) with memory contents
           cmpD #DCCOR6_AdaptiveVNTCell1    ; compare D -00000000 00001100-
           bcs  LC93C          ; branch if lower
           ldaa SRTIME_SparkEPPsNeededToBeAboveSR_Hot    ; load a with memory contents (data is 04)
           staa ColdStartFuelReduxCounter
   LC93C:  bset *BitFlags71, #$%10000000    ; set bits
           bra  LC944          ; branch

   LC941:  bclr *BitFlags71, #$%10000000    ; clear bits
   LC944:  brset *BitFlags6a, #$%00000100, StartCalculatingFuel    ; branch if bit(s) set
           jmp  CalculateInjectorPulsewidthForEngineRunning

StartCalculatingFuel:
           brclr *BitFlags6a, #$%00001000, ClearInjectorPW    ; branch if bit(s) clear
           ldaa ColdStartFuelReduxCounter    ; load a with memory contents
           bne  CalculateInjectorPulsewidthForEngineRunning    ; branch if not equal (not zero)
           ldaa Counter_FuelEngRunning    ; load a with memory contents
           bne  LC974          ; branch if not equal (not zero)
           ldaa EngineRpm_HB    ; load a with memory contents
           suba TargetIdleSpeedHB
           bcc  LC95F          ; branch if greater or equal
           clra                ; a = 0
   LC95F:  ldx  #L8C65_L8C65        ; load index with value
           ldab 0x00, X        ; load b with memory at index + value
           inx                 ; increment index (x=x+1)
   LC965:  cmpa 0x00, X        ; compare a with memory at index + value
           bcc  LC970          ; branch if greater or equal
           inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
           decb            
           bne  LC965          ; branch if not equal (not zero)
           dex                 ; decrement index (x=x-1)
           dex                 ; decrement index (x=x-1)
   LC970:  ldaa 0x01, X        ; load a with memory at index + value
           beq  CalculateInjectorPulsewidthForEngineRunning    ; branch if equal (zero)
   LC974:  bitA #0x0f          ;  -00001111-
           beq  LC97D          ; branch if equal (zero)
           deca                ; decrement a
           staa Counter_FuelEngRunning    ; store a into memory
           bra  ClearInjectorPW          ; branch

   LC97D:  suba #0x10          ;  -00010000-
           staa Counter_FuelEngRunning    ; store a into memory
           bra  CalculateInjectorPulsewidthForEngineRunning    ; branch

ClearInjectorPW:
           ldd  #0x0000         ; load d (a&b) with value -00000000 00000000-
           stD *BaseInjectorPulsewidth_HB    ; store D to RAM
           stD *InjectorPulsewidth_HB    ; store D to RAM
           bra  StoreCylPulsewidths    ; branch

   LC98C:  bclr *BitFlags71, #$%10000000    ; clear bits
           ldab InjectorLatency    ; load b with memory contents
           clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           stD *Temp5          ; store D to RAM
           ldd  InjectorPulsewidth_HB    ; load d (a&b) with memory contents
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           addd Temp5          ; d = d + memory contents
           bcc  StoreCylPulsewidths    ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
StoreCylPulsewidths:
           std  InjectorPulsewidth_HB_Cyl1
           std  InjectorPulsewidth_HB_Cyl2
           std  InjectorPulsewidth_HB_Cyl3
           std  InjectorPulsewidth_HB_Cyl4
           rti                 ; return from interrupt

CalculateInjectorPulsewidthForEngineRunning:
           ldaa MapValue       ; load a with memory contents
           ldY DFFULL_DensityFactorFullThrottle    ; load Y with value from memory (data is 22)
           jsr  ScaleYbyA      ; call subroutine
           stY Temp5           ; store Y index
           ldaa MapValue       ; load a with memory contents
           ldx  #MAPHI_HiMAP3DInputModifierFromMAP    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldab EngineRPM_3D    ; load b with memory contents
           ldx  #WOTTBL_FuelFullThrottleFromHiMAP    ; load index with value
           jsr  Lookup3DTableRoutine    ; call subroutine
           staa FuelLookupValue3D
           ldY Temp5           ; load Y index
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           brset *BitFlags66, #$%00000001, LCA23    ; branch if bit(s) set
           stD *Temp7          ; store D to RAM
           ldaa MapValue       ; load a with memory contents
           ldY DFPART_DensityFactorPartThrottle    ; load Y with value from memory (data is 23)
           jsr  ScaleYbyA      ; call subroutine
           stY Temp5           ; store Y index
           ldaa MapValue       ; load a with memory contents
           cmpa TBLBK3_3DTableBreakPointHiLo          ; compare a with value -01000000-
           bcc  LC9F8          ; branch if greater or equal
           ldx  #MAPLO_LoMAP3DInputModifierFromMAP    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldx  #PRTTBL_FuelPartThrottleFromLoMap    ; load index with value
           bra  LCA01          ; branch

   LC9F8:  ldx  #MAPHI_HiMAP3DInputModifierFromMAP    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldx  #PRTTBH_FuelPartThrottleFromHiMAP    ; load index with value
   LCA01:  ldab EngineRPM_3D    ; load b with memory contents
           jsr  Lookup3DTableRoutine    ; call subroutine
           staa FuelLookupValue3D
           ldY Temp5           ; load Y index
           jsr  ScaleYbyA      ; call subroutine
           stY Temp5           ; store Y index
           ldx  #Temp5         ; load index with value
           ldab Timer_OpenLoopFraction    ; load b with memory contents
           ldaA #0x01          ; load a with value -00000001-
           jsr  ScaleXbyB_addingA_intoD    ; call subroutine
           cmpD Temp7          ; compare D
           bls  LCA23          ; branch if lower or same
           ldd  Temp7          ; load d (a&b) with memory contents
   LCA23:  addd SparkScatterFuelStabilizationValue_HB    ; d = d + memory contents
           bpl  CheckBoostForKnockEnrichment    ; branch if plus (hi bit 0)
           ldd  Pulsewidth_PartThrottleEnrichment_HB    ; load d (a&b) with memory contents
           addd Pulsewidth_AISEnrichment_HB    ; d = d + memory contents
           bra  HandleTransitionFromStartToRun    ; branch

CheckBoostForKnockEnrichment:
           stD *Temp7          ; store D to RAM
           ldaa EMBSLM_KnockEnrichmentBoostSetpoint    ; load a with memory contents (data is 7a)
           bmi  LCA3C          ; branch if minus(hi bit 1)
           adda BaroPressure
           bcc  LCA3A          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LCA3A:  bra  LCA41          ; branch

   LCA3C:  adda BaroPressure
           bcc  LCA41          ; branch if greater or equal
           clra                ; a = 0
   LCA41:  cmpa MapValue       ; compare a with memory contents
           bhi  ClearKnockEnrichmentFactor    ; branch if higher
           ldx  #Cylinder2Retard    ; load index with value
           ldaa 0x00, X        ; load a with memory at index + value
FindHighestKnockValueForEnrichment:
           cpx  #Cylinder4Retard    ;  -00000000 11000111-
           beq  LookupKnockEnrichmentFactor    ; branch if equal (zero)
           inx                 ; increment index (x=x+1)
           cmpa 0x00, X        ; compare a with memory at index + value
           bcc  FindHighestKnockValueForEnrichment    ; branch if greater or equal
           ldaa 0x00, X        ; load a with memory at index + value
           bra  FindHighestKnockValueForEnrichment    ; branch

LookupKnockEnrichmentFactor:
           tsta                ; test a
           beq  ClearKnockEnrichmentFactor    ; branch if equal (zero)
           ldx  #KNENRC_KnockRetardEnrichment    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           stab KnockEnrichmentFactor    ; store b into memory
           clr  Counter_O2SensorFeedbackCount_Signed    ; zero byte at memory location
           ldaA #0x01          ; load a with value -00000001-
           ldx  #Temp7         ; load index with value
           jsr  ScaleXbyB_addingA_intoD    ; call subroutine
           stD *Temp7          ; store D to RAM
           bra  IncludePWModifiers_CheckForOverflow    ; branch

ClearKnockEnrichmentFactor:
           clra                ; a = 0
           staa KnockEnrichmentFactor

IncludePWModifiers_CheckForOverflow:
           ldab L00FE          ; load b with memory contents
           tba                 ; a = b
           ldY SumOfFuelModifiers_HB    ; load Y index
           jsr  ScaleYbyA      ; call subroutine
           stY Temp5           ; store Y index
           ldaa Temp7          ; load a with memory contents
           ldab SumOfFuelModifiers_LB    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           addd Temp5          ; d = d + memory contents
           bcs  UseMaxInjectorPW    ; branch if lower
           stD *Temp5          ; store D to RAM
           ldaa Temp7          ; load a with memory contents
           ldab SumOfFuelModifiers_HB    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           tsta                ; test a
           bne  UseMaxInjectorPW    ; branch if not equal (not zero)
           addb Temp5          ; b=b+memory contents
           bcs  UseMaxInjectorPW    ; branch if lower
           tba                 ; a = b
           ldab Temp6          ; load b with memory contents
           addd Pulsewidth_PartThrottleEnrichment_HB    ; d = d + memory contents
           bcs  UseMaxInjectorPW    ; branch if lower
           addd Pulsewidth_AISEnrichment_HB    ; d = d + memory contents
           bcc  HandleTransitionFromStartToRun    ; branch if greater or equal
UseMaxInjectorPW:
           ldd  #0xffff        ; load d (a&b) with value -11111111 11111111-
HandleTransitionFromStartToRun:
           brclr *BitFlags6e, #$%00010000, IncludeInjectorLatency    ; branch if bit(s) clear
           stD *Temp5          ; store D to RAM
           ldd  InjectorPulsewidth_HB    ; load d (a&b) with memory contents
           suba Factor_StartFuelDecayIntoRunFuel
           bls  TransitionFromStartToRunComplete    ; branch if lower or same
           cmpa Temp5          ; compare a with memory contents
           bhi  IncludeInjectorLatency    ; branch if higher
TransitionFromStartToRunComplete:
           ldd  Temp5          ; load d (a&b) with memory contents
           bclr *BitFlags6e, #$%00010000    ; clear bits
IncludeInjectorLatency:
           jsr  NULL_ROUTINE    ; call subroutine
           stD *InjectorPulsewidth_HB    ; store D to RAM
           ldab InjectorLatency    ; load b with memory contents
           clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd InjectorPulsewidth_HB    ; d = d + memory contents
           bcc  LCACE          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LCACE:  stD *BaseInjectorPulsewidth_HB    ; store D to RAM
           clra                ; a = 0
           staa Temp5          ; store a into memory
           staa Temp6          ; store a into memory
           ldab BitFlags6f     ; load b with memory contents
           andb #0x03          ;  -00000011-
           ldx  #NotSure5      ; load index with value
           abx                 ; add b to index
           ldab 0x00, X        ; load b with memory at index + value
           ldx  #InjectorPulsewidth_HB_Cyl1    ; load index with value
           abx                 ; add b to index
           brclr *BitFlags71, #$%10000000, LCB16    ; branch if bit(s) clear
           ldaa ColdStartFuelReduxCounter    ; load a with memory contents
           beq  LCB2F          ; branch if equal (zero)
           deca                ; decrement a
           staa ColdStartFuelReduxCounter
           pshx                ; pull index from stack
           ldaa EngineRpm_HB    ; load a with memory contents
           ldx  #PCCSFE_PercentForColdStartFuelEnrichment    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           psha                ; push a onto stack
           ldY InjectorPulsewidth_HB    ; load Y index
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           stD *Temp5          ; store D to RAM
           pulb                ; pull b from stack -- value from PCCSFE_PercentForColdStartFuelEnrichment
           ldaa InjectorLatency    ; load a with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           tab                 ; b = a
           clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd Temp5          ; d = d + memory contents
           pulx                ; pull index from stack
           std  0x00, X        ; store d into index plus offset
           bra  LCB2F          ; branch

   LCB16:  ldd  BaseInjectorPulsewidth_HB    ; load d (a&b) with memory contents
           std  0x00, X        ; store d into index plus offset
           cmpD #PreviousEngineRpm_LB    ; compare D -00000000 01111101-
           bls  LCB2F          ; branch if lower or same
           ldaa SwitchPortAccessReg1    ; load a with memory contents
           bita #0x10          ;  -00010000-
           beq  LCB2F          ; branch if equal (zero)
           bset *BitFlags6f, #$%00100000    ; set bits
           ldaA #0x04          ; load a with value -00000100-
           staa PIA_Ctrl_4 
   LCB2F:  ldd  InjectorPulsewidth_HB    ; load d (a&b) with memory contents
           addd Temp5          ; d = d + memory contents
           subd IPWRDX_InjectorPulsewidthReductionColdStart    ;  (data is 0000)
           bcc  LCB3B          ; branch if greater or equal
           ldd  #0x0000         ; load d (a&b) with value -00000000 00000000-
   LCB3B:  lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           ; try to correct the fuel monitor output
           adca #0x00
           ldab FLMNC2_FuelMonitorCorrection2 ;temp name - base value is 0x80 for stock injectors, scaled with injectors
           mul
           lsld
           ; end correction code
           addd CCDFuelOutput_HB    ; d = d + memory contents
           bcc  LCB44          ; branch if greater or equal
           ldd  #0xffff        ; load d (a&b) with value -11111111 11111111-
   LCB44:  stD *CCDFuelOutput_HB    ; store D to RAM
           ldd  Pulsewidth_AISEnrichment_HB    ; load d (a&b) with memory contents
           subd MINPAI_MinPWForAISPulseEnrich    ;  (data is 0009)
           bcc  LCB50          ; branch if greater or equal
           ldd  #0x0000         ; load d (a&b) with value -00000000 00000000-
   LCB50:  stD *Pulsewidth_AISEnrichment_HB    ; store D to RAM
           rti                 ; return from interrupt

Interrupt_RealTime:
           ldaB #0x01          ; load b with value -00000001-
           bra  LCB6D          ; branch

Interrupt_XIRQ:
           ldaB #0x02          ; load b with value -00000010-
           bra  LCB6D          ; branch

Interrupt_COPFail:
           ldaB #0x04          ; load b with value -00000100-
           bra  LCB6D          ; branch

Interrupt_BadOp:
           ldab #0x10          ; load b with value -00010000-
           bra  LCB6D          ; branch

Interrupt_Software:
           ldab #0x20          ; load b with value -00100000-
           bra  LCB6D          ; branch

Interrupt_PulseAccumulatorInputEdge:
           ldab #0x40          ; load b with value -01000000-
           bra  LCB6D          ; branch

   Code80: ldab #0x80          ; load b with value -10000000-
   LCB6D:  sei                 ; disable interrupts
           stab Temp0          ; store b into memory
           ldd  #0x7001        ; load d (a&b) with value -01110000 00000001-
           staa CPU_PortA_Control
           stab CPU_TimerInterruptMask2    ; store b into memory
           ldd  #0xb978        ; load d (a&b) with value -10111001 01111000-
           staa CPU_SysConfigOptionReg
           stab CPU_HighPriorityInterruptMask    ; store b into memory
           ldaa #0x18          ; load a with value -00011000-
           staa CPU_BlockProtReg
           clr  CPU_OutputCompare1Mask    ; zero byte at memory location
           ldab Temp0          ; load b with memory contents
           orab L0000      
           stab L0000          ; store b into memory
           tsx                 ; transfer stack to index (x=sp+1)
           ldd  0x07, X    
           stD *L0001          ; store D to RAM
           stD *Temp1          ; store D to RAM
           lds  #0x64ff        ;  -01100100 11111111-
           ldaB #0x02          ; load b with value -00000010-
           stab BitFlags_36    ; store b into memory
           ldx  #0x4ab5        ; load index with value
           ldd  L0003          ; load d (a&b) with memory contents
           comb            
           cba             
           beq  LCC17          ; branch if equal (zero)
           dex                 ; decrement index (x=x-1)
           bra  LCC17          ; branch

Interrupt_ClockMonFail:
           sei                 ; disable interrupts
           ldd  #0xb978        ; load d (a&b) with value -10111001 01111000-
           staa CPU_SysConfigOptionReg
           stab CPU_HighPriorityInterruptMask    ; store b into memory
           ldaa #0x18          ; load a with value -00011000-
           staa CPU_BlockProtReg
           ldd  #0x7001        ; load d (a&b) with value -01110000 00000001-
           staa CPU_PortA_Control
           stab CPU_TimerInterruptMask2    ; store b into memory
           clr  CPU_OutputCompare1Mask    ; zero byte at memory location
           ldd  #0x0000         ; load d (a&b) with value -00000000 00000000-
           staa Temp0          ; store a into memory
           stD *Temp1          ; store D to RAM
           lds  #0x64ff        ;  -01100100 11111111-

CountRamValuesFrom00to3a:
           ldx  #0x0000         ; load index with value
   LCBD2:  ldaa 0x00, X        ; load a with memory at index + value
           bne  LCBE1          ; branch if not equal (not zero)
           inx                 ; increment index (x=x+1)
           cpx  #CurrentWastegatePosition    ;  -00000000 00111010-
           bcs  LCBD2          ; branch if lower

           ldx  #0x4ab4        ; load index with value
           bra  LCC17          ; branch

   LCBE1:  ldx  #0x4ab5        ; load index with value
           bra  LCC17          ; branch

ResetInterrupt:
           sei                 ; disable interrupts
           ldd  #0xb978        ; load d (a&b) with value -10111001 01111000-
           staa CPU_SysConfigOptionReg
           stab CPU_HighPriorityInterruptMask    ; store b into memory
           ldaa #0x18          ; load a with value -00011000-
           staa CPU_BlockProtReg
           ldd  #0x7001        ; load d (a&b) with value -01110000 00000001-
           staa CPU_PortA_Control
           stab CPU_TimerInterruptMask2    ; store b into memory
           clr  CPU_OutputCompare1Mask    ; zero byte at memory location
           ldd  #0x0000         ; load d (a&b) with value -00000000 00000000-
           staa Temp0          ; store a into memory
           stD *Temp1          ; store D to RAM
           lds  #0x64ff        ;  -01100100 11111111-

           jsr  CountRamValuesFrom05to3a    ; call subroutine
           ldx  #0x4ab5        ; load index with value
           cmpD L0003          ; compare D
           beq  LCC17          ; branch if equal (zero)
           inx                 ; increment index (x=x+1)

   LCC17:  stx  L0003          ; store index into memory
           ldd  #0x01f9        ; load d (a&b) with value -00000001 11111001-
           staa PIA_Ctrl_2 
           stab PIA_Ctrl_5          ; store b into memory
           ldd  #0x0000         ; load d (a&b) with value -00000000 00000000-
           std  InjectorPulsewidth_HB_Cyl1
           std  InjectorPulsewidth_HB_Cyl2
           std  InjectorPulsewidth_HB_Cyl3
           std  InjectorPulsewidth_HB_Cyl4
           ldaa #0x75          ; load a with value -01110101-
           staa PortX_Control
           ldaa #0x20          ; load a with value -00100000-
           staa CPU_PortD  
           ldd  #0x0003         ; load d (a&b) with value -00000000 00000011-
           staa SwitchPortAccessReg1
           stab PIA_Ctrl_1     ; store b into memory
           ldd  #0x3a54        ; load d (a&b) with value -00111010 01010100-
           staa CPU_PortD_DataDirection
           ldaa CPU_SerialPeripheralStatus    ; load a with memory contents
           stab CPU_SerialPeripheralControl    ; store b into memory
           jsr  ResetCopTimer    ; call subroutine
           ldaa #0xc8          ; load a with value -11001000-
   LCC55:  deca                ; decrement a
           bne  LCC55          ; branch if not equal (not zero)
           jsr  ResetCopTimer    ; call subroutine
           bclr *BitFlags_AIS, #$%01000000    ; clear bits
           ldx  #CurrentWastegatePosition    ; load index with value
           ldd  L0003          ; load d (a&b) with memory contents
           cmpD #0x4ab5        ; compare D -01001010 10110101-
           beq  LCC9A          ; branch if equal (zero)
           ldaa Temp0          ; load a with memory contents
           staa L0000          ; store a into memory
           ldd  Temp1          ; load d (a&b) with memory contents
           stD *L0001          ; store D to RAM
           jsr  ERASE_ERROR_CODES    ; call subroutine
           ldaa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load a with memory contents (data is 5c)
           staa MINTHR_LowestSessionTPS    ; store a into memory
           ldab #0xdf          ; load b with value -11011111-
           stab CurrentAisPosition    ; store b into memory
           bset *BitFlags_AIS, #$%01000000    ; set bits
           bclr *BitFlags_AIS, #$%10111111    ; clear bits
           ldaa #0x80          ; load a with value -10000000-
           staa Timer_DacalCountdown    ; store a into memory
           staa DCCOR1_AdaptiveWastegateCellBelow3psi    ; store a into memory
           staa DCCOR2_AdaptiveWastegateCellTo4000rpm    ; store a into memory
           staa DCCOR3_AdaptiveWastegateCellTo4992rpm    ; store a into memory
           staa DCCOR4_AdaptiveWastegateCellTo5504rpm    ; store a into memory
           staa DCCOR5_AdaptiveWastegateCellAbove5504rpm    ; store a into memory
           staa DCCOR6_AdaptiveVNTCell1    ; store a into memory
           staa DCCOR7_AdaptiveVNTCell2    ; store a into memory
           staa DCCOR0_AdaptiveVNTCell0    ; store a into memory
           ldx  #AutoCalCell0    ; load index with value
   LCC9A:  ldaa #0x10          ; load a with value -00010000-
           staa CPU_A2DControlReg
           ldaA #0x01          ; load a with value -00000001-
           staa SwitchPortAccessReg1
           clrb                ; b = 0
ZeroRamFrom0EtoFE:
           stab 0x00, X    
           inx                 ; increment index (x=x+1)
           cpx  #0x00ff        ;  -00000000 11111111-
           bls  ZeroRamFrom0EtoFE    ; branch if lower or same
           tsx                 ; transfer stack to index (x=sp+1)
   LCCAE:  dex                 ; decrement index (x=x-1)
           stab 0x00, X    
           cpx  #ErrorCodeCounter    ;  -01100100 10000000-
           bhi  LCCAE          ; branch if higher
           ldaa #~(pia_bit7 | pia_FuelMon | pia_Tach)          ; load a with value -01110101-
           staa PIA_Buffer2    ; store a into memory
           ldd  #0x0c22        ; load d (a&b) with value -00001100 00100010-
           staa CPU_SerialControlReg2
           stab CPU_SerialBaudRate    ; store b into memory
           clra                ; a = 0
           staa CPU_SerialControlReg1
           jsr  ResetCopTimer    ; call subroutine
           bset *BitFlags_36, #$%11000000    ; set bits
           ldaa #0x1a          ; load a with value -00011010-
           staa CPU_TimerControlReg2
           ldd  #0x96ff        ; load d (a&b) with value -10010110 11111111-
           staa CPU_TimerInterruptMask1
           stab CPU_TimerInterruptFlag1    ; store b into memory
           bset *CruiseStatus_1, #$%10100000    ; set bits
           bset *StartupSwitchMirror1, #sw1_CruiseSet    ; set bits
           ldaa #0x80          ; load a with value -10000000-
           staa Counter_Cruise_1    ; store a into memory
           bset *BitFlags6c, #$%00000010    ; set bits
           ldaa LB616          ; load a with memory contents (data is ff)
           cmpa #0x4a          ; compare a with value -01001010-
           bne  LCCF5          ; branch if not equal (not zero)
           coma            
           cmpa LB617          ; compare a with memory contents (data is ff)
           beq  LCCF8          ; branch if equal (zero)
   LCCF5:  bclr *BitFlags6c, #$%00000010    ; clear bits
   LCCF8:  bclr *BitFlags6c, #$%00001100    ; clear bits
           ldaa L0004          ; load a with memory contents
           cmpa #0xb4          ; compare a with value -10110100-
           beq  LCD0A          ; branch if equal (zero)
           ldaa BitFlags_36    ; load a with memory contents
           tab                 ; b = a
           andb #0x03          ;  -00000011-
           cmpb #0x02          ;  -00000010-
           bne  SetupSystemAndGoToMainLoop    ; branch if not equal (not zero)
   LCD0A:  ldd  #0x0aff        ; load d (a&b) with value -00001010 11111111-
           staa DRBPointer1    ; store a into memory
           stab DRBPointer2    ; store b into memory
           ldd  #0xf1ff        ; load d (a&b) with value -11110001 11111111-
           staa LastCamFallingEdgeTime    ; store a into memory
           bra  LCD1D          ; branch

SetupSystemAndGoToMainLoop:
           inca                ; increment a
           staa BitFlags_36    ; store a into memory
           ldab #0xef          ; load b with value -11101111-
   LCD1D:  stab CCDFlags1      ; store b into memory
           ldaa #~pia_CEL          ; load a with value -10111111-
           staa PIA_Buffer1    ; store a into memory
           ldaa PIA_Buffer2    ; load a with memory contents
           anda #~pia_bit2     ; AND a with value -11111011-
           staa PortX_Control
           stab CPU_SerialPeripheralDataIO    ; store b into memory
           ldaA #0x03          ; load a with value -00000011-
           staa Timer_DelayBeforeUpdating_MINTHR    ; store a into memory
           ldaA #0x0c         ; load a with value -00001100-
           staa BitFlags66     ; store a into memory
           bset *BitFlags6e, #$%10010010    ; set bits
           ldd  #0x14ff        ; load d (a&b) with value -00010100 11111111-
           staa BitFlags67     ; store a into memory
           stab Counter_TimerPastHalfwayBetweenCamPulses    ; store b into memory
           stab TimerOverflowsBetweenCamPulses    ; store b into memory
           stab Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; store b into memory
           stab TimerOverflowsBetweenSpeedoPulses    ; store b into memory
           stab Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached    ; store b into memory
           ldaa PIA_Buffer2    ; load a with memory contents
           staa PortX_Control
           jsr  ResetCopTimer    ; call subroutine
           ldx  #0x0d05        ; load index with value
   LCD52:  dex                 ; decrement index (x=x-1)
           bne  LCD52          ; branch if not equal (not zero)
           jsr  ResetCopTimer    ; call subroutine
           ldaa #0x14          ; load a with value -00010100-
           staa CPU_A2DControlReg
   LCD5D:  ldaa CPU_A2DControlReg    ; load a with memory contents
           bpl  LCD5D          ; branch if plus (hi bit 0)
           ldd  CPU_A2DResults1
           stD *LastCoolantTempVolts    ; store D to RAM
           ldab #0x10          ; load b with value -00010000-
           stab CPU_A2DControlReg    ; store b into memory
           cmpa #0x40          ; compare a with value -01000000-
           bcc  LCD73          ; branch if greater or equal
           bclr *PIA_Buffer2, #pia_CoolantTemp    ; clear bits
   LCD73:  cmpb #0x40          ;  -01000000-
           bcc  LCD7A          ; branch if greater or equal
           bclr *PIA_Buffer2, #pia_ChargeTemp    ; clear bits
   LCD7A:  ldaa PIA_Buffer2    ; load a with memory contents
           staa PortX_Control
   LCD7F:  ldaa CPU_A2DControlReg    ; load a with memory contents
           bpl  LCD7F          ; branch if plus (hi bit 0)
           jsr  ResetCopTimer    ; call subroutine
           ldd  CPU_A2DResults1
           stab BatteryVolts    ; store b into memory
           staa MapVolts       ; store a into memory
           staa MapValueX  
           staa MapVoltsX  
           jsr  SaveBaroPressure    ; call subroutine
           staa MapValue       ; store a into memory
           staa MapAverageValue_HB    ; store a into memory
           ldd  CPU_A2DResults3
           stD *O2SensorVolts    ; store D to RAM
           stab TpsVolts       ; store b into memory
           stab TpsAverageValue_HB    ; store b into memory
           ldaa MINTHR_LowestSessionTPS    ; load a with memory contents
           adda MININC_Amount_MINTHR_IsIncreasedAtKeyOnOnly    ;  (data is 03)
           cmpa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; compare a with memory contents (data is 5c)
           bcs  LCDB7          ; branch if lower
           addb #0x06          ;  -00000110-
           ldaa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load a with memory contents (data is 5c)
           cba             
           bcs  LCDB7          ; branch if lower
           tba                 ; a = b
   LCDB7:  staa MINTHR_LowestSessionTPS    ; store a into memory
           ldx  #0x07d0        ; load index with value
   LCDBC:  dex                 ; decrement index (x=x-1)
           bne  LCDBC          ; branch if not equal (not zero)
           ldaa #0x14          ; load a with value -00010100-
           staa CPU_A2DControlReg
           jsr  ResetCopTimer    ; call subroutine
   LCDC7:  ldaa CPU_A2DControlReg    ; load a with memory contents
           bpl  LCDC7          ; branch if plus (hi bit 0)
           ldd  CPU_A2DResults1
           stD *LastCoolantTempVolts    ; store D to RAM
           ldab #0x10          ; load b with value -00010000-
           stab CPU_A2DControlReg    ; store b into memory
           ldaa LastChargeTempVolts    ; load a with memory contents
           ldx  #TMPTL2_TempForHotScaleA2D    ; load index with value
           brclr *PIA_Buffer2, #pia_ChargeTemp, LCDE2    ; branch if bit(s) clear
           ldx  #TMPTL1_TempForColdScaleA2D    ; load index with value
   LCDE2:  jsr  Lookup4ByteTable    ; call subroutine
           staa ChargeTempVolts    ; store a into memory
           ldaa #0xc1          ; load a with value -11000001-
           staa AmbientAirTempVolts    ; store a into memory
           ldaa LastCoolantTempVolts    ; load a with memory contents
           ldx  #TMPTL2_TempForHotScaleA2D    ; load index with value
           brclr *PIA_Buffer2, #pia_CoolantTemp, LCDF7    ; branch if bit(s) clear
           ldx  #TMPTL1_TempForColdScaleA2D    ; load index with value
   LCDF7:  jsr  Lookup4ByteTable    ; call subroutine
           staa CoolantTemp    ; store a into memory
           cmpa TTEMPL_TstatDiagnosticsMinTempToArmDiagnosticsAtStartup    ; compare a with memory contents (data is 63)
           bcs  LCE09          ; branch if lower
           cmpa TTEMPH_TstatDiagnosticsMaxTempToArmDiagnosticsAtStartup    ; compare a with memory contents (data is e4)
           bcc  LCE09          ; branch if greater or equal
           inc  Timer_ThermostatDiagnostics
   LCE09:  ldx  #PRSHOT_KeyOnPrimePW        ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldab #0xfa          ; load b with value -11111010-
           mul                 ; multiply (d=a*b)
           stD *InjectorPulsewidth_HB    ; store D to RAM
           jsr  ResetCopTimer    ; call subroutine
           ldaa BatteryVolts    ; load a with memory contents
           ldx  #BATOFF_FuelBatteryOffset    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa DRBPointer1    ; load a with memory contents
           cmpa #0x0a          ; compare a with value -00001010-
           beq  LCE3A          ; branch if equal (zero)
           clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd InjectorPulsewidth_HB    ; d = d + memory contents
           bcc  LCE2E          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LCE2E:  std  InjectorPulsewidth_HB_Cyl1
           std  InjectorPulsewidth_HB_Cyl2
           std  InjectorPulsewidth_HB_Cyl3
           std  InjectorPulsewidth_HB_Cyl4
   LCE3A:  jsr  IncludeCylTrimWithAdaptiveCells    ; call subroutine
           jsr  ResetCopTimer    ; call subroutine
           ldd  CPU_TimerCounterRegHigh
           addd #DCCOR4_AdaptiveWastegateCellTo5504rpm    ;  -00000000 00001010-
           std  CPU_TimerOutputCompareRegHigh1
           addd #0x14f6        ;  -00010100 11110110-
           asld                ; shift left (d=d*2)
           staa MinimumTimerCountBeforeMainloopCanContinue    ; store a into memory
           cli                 ; enable interrupts
           jmp  MainProgramLoop

MainProgramLoop:
           jsr  DealWithConfigurationAndPulseAccumulator_MM    ; call subroutine
   LCE56:  cli                 ; enable interrupts
           ldd  #0x55aa        ; load d (a&b) with value -01010101 10101010-
           staa CPU_ArmResetCopTimerReg
           stab CPU_ArmResetCopTimerReg    ; store b into memory
           ldaa SwitchPortAccessReg1    ; load a with memory contents
           eora #0x02          ; XOR a with value -00000010-
           staa SwitchPortAccessReg1
           sei                 ; disable interrupts
           ldaa CPU_A2DControlReg    ; load a with memory contents
           bpl  LCE56          ; branch if plus (hi bit 0)
           ldaa Counter_MainLoop    ; load a with memory contents
           bitA #0x03          ;  -00000011-
           bne  LCE79          ; branch if not equal (not zero)
           ldaa CPU_A2DResults2    ; load a with memory contents
           staa BatteryVolts    ; store a into memory
   LCE79:  ldd  CPU_A2DResults3
           cli                 ; enable interrupts
           staa O2SensorVolts    ; store a into memory
           stab LastTPSVolts       ; store b into memory
           sei                 ; disable interrupts
           ldd  CPU_TimerCounterRegHigh
           stD *Temp0          ; store D to RAM
           jsr  DetermineNumberOfOverflowsBetweenCamSensorPulses_MM    ; call subroutine
           ldd  Temp0          ; load d (a&b) with memory contents
           jsr  DetermineNumberOfOverflowsBetweenSpeedoPulses_MM    ; call subroutine
           cli                 ; enable interrupts
           ;jsr  EmmissionMaintenanceRemider1_MM    ; call subroutine
           jsr  DRB_SomethingLikeEMR_MM    ; call subroutine
           ;jsr  EmmissionMaintenanceRemider2_MM    ; call subroutine
           jsr  CycleACClutch_MM    ; call subroutine
           jsr  CheckThrottleRoutine_MM    ; call subroutine
           jsr  CheckAndFilterCoolantTempSensor_MM    ; call subroutine
           jsr  CheckAndFilterChargeTempSensor_MM    ; call subroutine
           jsr  HandleBaroReadRequirement_MM    ; call subroutine
           jsr  CalculateInjectorPulsewidthForStarting_MM    ; call subroutine
           jsr  DetectParkNeutral_MM    ; call subroutine
           jsr  CALCULATE_RPM_SPEED_AND    ; call subroutine
           jsr  RescaleRPMFor3D_MM    ; call subroutine
           jsr  ControlAsdRelay_MM    ; call subroutine
           jsr  LD4AB          ; call subroutine
           jsr  ControlCruiseServo0_MM    ; call subroutine
           jsr  ControlCruiseServo1_MM    ; call subroutine
           jsr  CalculateSparkAdvance_MM    ; call subroutine
           jsr  PrepareCCDDataForXmit_MM    ; call subroutine
           jsr  KickUpAisBy2DuringDecel_MM    ; call subroutine
           jsr  CalculateTargetIdleSpeedAndAisPosition_MM    ; call subroutine
           jsr  CalculateAisPosition_MM    ; call subroutine
           jsr  CalculatePartThrottleEnrichmentAndSparkScatterFuel_MM    ; call subroutine
           jsr  HandleAmTimer_MM    ; call subroutine
           jsr  HandleO2Processing_MM    ; call subroutine
           jsr  ModifyO2FeedbackCountVarToMaintainStoich_MM    ; call subroutine
           jsr  AdaptiveMemory_DetermineWhichCellApplies_MM    ; call subroutine
           jsr  ControlPurgeSolenoid_MM    ; call subroutine
           jsr  AdaptiveMemory_UpdateCellIfRequired_MM    ; call subroutine
           jsr  DetermineIndividualInjectorTrims_MM    ; call subroutine
           jsr  DealWithSpecialIdle_SetBasicTiming_MM    ; call subroutine
           jsr  ControlEngineCutout_MM    ; call subroutine
           jsr  UseCELForKnockIndication_MM
           jsr  CalculatePartThrottleTransientFuel_MM    ; call subroutine
           ldaa MapValue       ; load a with memory contents
           suba MapAverageValue_HB
           staa MAPAvgDelta
           ldaa TpsVolts       ; load a with memory contents
           suba TpsAverageValue_HB
           staa TPSAvgDelta
           jsr  CalculateSumOfAllFuelModifiers_MM    ; call subroutine
           jsr  ControlFan_MM    ; call subroutine
           jsr  ControlAirConditioning_MM    ; call subroutine
           jsr  CalculateKnockRetard_MM    ; call subroutine
           jsr  CalcTargetBoost_MM    ; call subroutine
           jsr  GetControlFeedback_DetermineIfShutdownRequired_MM    ; call subroutine
           jsr  DetectAlternatorFault_MM    ; call subroutine
           jsr  VerifyOperationOfBatteryVoltage_MM    ; call subroutine
           jsr  UpdateCylTrimCounters_MM    ; call subroutine
           jsr  CheckForErrorsAndSetCodes_MM    ; call subroutine
           jsr  VerifyOperationOfASDRelayAndO2Sensor_MM    ; call subroutine
           jsr  VerifyOperationOfFuelInjectorDrivers_MM    ; call subroutine
           jsr  VerifyOperationOfIgnitionCoilDriver_MM    ; call subroutine
           jsr  VerifyOperationOfMapSensor_MM    ; call subroutine
           jsr  VerifyOperationOfThermostat_MM    ; call subroutine
           ldaa CPU_TimerCounterRegLow          ; load a with memory contents
           sei                 ; disable interrupts
           staa L0003          ; store a into memory
           coma            
           staa L0004          ; store a into memory
           cli                 ; enable interrupts
           jsr  DetermineTargetBatteryVoltage_MM    ; call subroutine
           jsr  DecrementDwellTimers_MM    ; call subroutine
           jsr  ProcessErrorBits_WorkWithData_MM    ; call subroutine
           jsr  ThrowMajorErrorIfRequired_MM    ; call subroutine
           jsr  UpdateErrorTimersAndPossiblyClearErrors_MM    ; call subroutine
           jsr  CheckIfCheckEngineLightShouldBeOn_MM    ; call subroutine
           jsr  DRBIISerialCommunications_MM    ; call subroutine
           jsr  ActuatorTestMode_MM    ; call subroutine
           jsr  DRBIIOuput_MM    ; call subroutine
           jsr  UpdatePIA1AndCheckOuputs_MM    ; call subroutine
           jsr  IncrementLoopCounters_MM    ; call subroutine
           sei                 ; disable interrupts
           ldaa MinimumTimerCountBeforeMainloopCanContinue    ; load a with memory contents
           ldab CPU_TimerCounterRegHigh    ; load b with memory contents
           cba             
           bmi  LCF60          ; branch if minus(hi bit 1)
           tab                 ; b = a
   LCF60:  addb #0x15          ;  -00010101-
           stab MinimumTimerCountBeforeMainloopCanContinue    ; store b into memory
           cli                 ; enable interrupts
   LCF65:  cmpa CPU_TimerCounterRegHigh    ; compare a with memory contents
           bpl  LCF65          ; branch if plus (hi bit 0)
           jmp  MainProgramLoop

ControlPurgeSolenoid_MM:
           brclr *BitFlags6e, #$%10000000, LCF86    ; branch if bit(s) clear
           ldaa CoolantTemp    ; load a with memory contents
           cmpa PURTMP_CanisterPurgeCoolantTemp    ; compare a with memory contents (data is b6)
           bcc  LCF7D          ; branch if greater or equal
           bclr *BitFlags67, #$%10000000    ; clear bits
           bra  LCF86          ; branch

   LCF7D:  bset *BitFlags67, #$%10000000    ; set bits
           bra  LCF86          ; branch

CanisterPurgeOff:
           bclr *CCDFlags1, #$%00100000    ; clear bits
           rts                 ; return from subroutine

   LCF86:  ldab BaroPressure    ; load b with memory contents
           brset *CCDFlags1, #$%00100000, LCF8F    ; branch if bit(s) set
           subb PURHYS_CannisterPurgeBaroHysteresis    ; subtract memory contents from b (data is 02)
   LCF8F:  tst  PURMAP_CannisterPurgeWhenBelowThisBaro    ;  (data is 7f)
           bpl  LCFA0          ; branch if plus (hi bit 0)
           tba                 ; a = b
           ldab PURMAP_CannisterPurgeWhenBelowThisBaro    ; load b with memory contents (data is 7f)
           negb            
           sba                 ; subtract (a=a-b)
           tab                 ; b = a
           bcc  LCFA7          ; branch if greater or equal
           clrb                ; b = 0
           bra  LCFA7          ; branch

   LCFA0:  addb PURMAP_CannisterPurgeWhenBelowThisBaro    ;  (data is 7f)
           bcc  LCFA7          ; branch if greater or equal
           ldab #0xff          ; load b with value -11111111-
   LCFA7:  cmpb MapValue   
           bcs  CanisterPurgeOff    ; branch if lower
           brset *BitFlags67, #$%10000000, CanisterPurgeOn    ; branch if bit(s) set
           brset *BitFlags67, #$%00000100, CanisterPurgeOff    ; branch if bit(s) set
           bset *BitFlags67, #$%10000000    ; set bits
           bra  LCFC0          ; branch

CanisterPurgeOn:
           brset *BitFlags66, #$%00010000, LCFC0    ; branch if bit(s) set
           ldab Timer_CLTIME_ClosedLoopTimer    ; load b with memory contents
           bne  CanisterPurgeOff    ; branch if not equal (not zero)
   LCFC0:  ldaB #0x08          ; load b with value -00001000-
           ldx  #CLTRP2_Cyl2TrimValueForPurgeVolume    ; load index with value
           ldaa PointerIntoAdaptiveMemory    ; load a with memory contents
           cmpa CL2PTR_Cyl2AdaptiveMemoryPointer    ; compare a with memory contents (data is 0d)
           bne  LCFD2          ; branch if not equal (not zero)
           brset *BitFlags67, #$%01000000, LD034    ; branch if bit(s) set
           bra  LCFE5          ; branch

   LCFD2:  inx                 ; increment index (x=x+1)
           lsrb                ; logical shift right b
           cmpa CL1PTR_Cyl1AdaptiveMemoryPointer    ; compare a with memory contents (data is 03)
           beq  LCFE5          ; branch if equal (zero)
           lsrb                ; logical shift right b
           cmpa CL3PTR_Cyl3AdaptiveMemoryPointer    ; compare a with memory contents (data is 04)
           beq  LCFE5          ; branch if equal (zero)
           lsrb                ; logical shift right b
           cmpa CL4PTR_Cyl4AdaptiveMemoryPointer    ; compare a with memory contents (data is 05)
           bne  LD034          ; branch if not equal (not zero)
   LCFE5:  brset *CylTrim_FlagsE8, #$%00100000, LD034    ; branch if bit(s) set
           brset *BitFlags67, #$%00010000, LD037    ; branch if bit(s) set
           bitb CylTrim_FlagsE7
           bne  LD034          ; branch if not equal (not zero)
           lslb            
           lslb            
           lslb            
           lslb            
           brclr *CylTrim_FlagsE8, #$%10000000, LD003    ; branch if bit(s) clear
           cmpb #0x80          ;  -10000000-
           bne  LD003          ; branch if not equal (not zero)
           bset *CylTrim_FlagsE7, #$%10000000    ; set bits
           bclr *CylTrim_FlagsE8, #$%10000000    ; clear bits
   LD003:  bitb CylTrim_FlagsE7
           beq  LD034          ; branch if equal (zero)
           ldaa CylTrim_Adaptive_Var1    ; load a with memory contents
           cmpa 0x00, X        ; compare a with memory at index + value
           bcc  LD027          ; branch if greater or equal
           bitb CylTrimFlags
           bne  LD034          ; branch if not equal (not zero)
           tsta                ; test a
           beq  LD01A          ; branch if equal (zero)
           brclr *Counter_MainLoop, #$%00111111, LD01A    ; branch if bit(s) clear
           bra  LD01F          ; branch

   LD01A:  inca                ; increment a
           beq  LD01F          ; branch if equal (zero)
           staa CylTrim_Adaptive_Var1    ; store a into memory
   LD01F:  cmpa #0x03          ; compare a with value -00000011-
           bcs  LD037          ; branch if lower
           bclr *CCDFlags1, #$%00100000    ; clear bits
           rts                 ; return from subroutine

   LD027:  lsrb                ; logical shift right b
           lsrb                ; logical shift right b
           lsrb                ; logical shift right b
           lsrb                ; logical shift right b
           tba                 ; a = b
           orab CylTrim_FlagsE7
           stab CylTrim_FlagsE7    ; store b into memory
           oraa CylTrimFlags    ; OR a with memory contents
           staa CylTrimFlags    ; store a into memory
   LD034:  clr  CylTrim_Adaptive_Var1    ; zero byte at memory location
   LD037:  bset *CCDFlags1, #$%00100000    ; set bits
           rts                 ; return from subroutine

DetermineIndividualInjectorTrims_MM:
           brclr *CylTrim_FlagsE8, #$%01000000, LD040    ; branch if bit(s) clear
           rts                 ; return from subroutine

   LD040:  brclr *CylTrimFlags, #$%00001000, LD062    ; branch if bit(s) clear
           ldx  #AutoCalCell0    ; load index with value
           ldab CL2PTR_Cyl2AdaptiveMemoryPointer    ; load b with memory contents (data is 0d)
           abx                 ; add b to index
           ldaa Cyl2_InjPWTrim    ; load a with memory contents
           suba 0x00, X    
           blt  LD062          ; branch if less
           brclr *CylTrimFlags, #$%10000000, LD058    ; branch if bit(s) clear
           adda CL2INC_Cyl2TrimIncrement    ;  (data is 05)
   LD058:  cmpa CL2LMT_Cyl2TrimLimit    ; compare a with memory contents (data is 33)
           bcs  LD062          ; branch if lower
           bset *CylTrimFlags, #$%10000000    ; set bits
           bra  LD065          ; branch

   LD062:  bclr *CylTrimFlags, #$%10000000    ; clear bits
   LD065:  brclr *CylTrimFlags, #$%00000100, LD087    ; branch if bit(s) clear
           ldx  #AutoCalCell0    ; load index with value
           ldab CL1PTR_Cyl1AdaptiveMemoryPointer    ; load b with memory contents (data is 03)
           abx                 ; add b to index
           ldaa Cyl1_InjPWTrim    ; load a with memory contents
           suba 0x00, X    
           blt  LD087          ; branch if less
           brclr *CylTrimFlags, #$%01000000, LD07D    ; branch if bit(s) clear
           adda CL1INC_Cyl1TrimIncrement    ;  (data is 05)
   LD07D:  cmpa CL1LMT_Cyl1TrimLimit    ; compare a with memory contents (data is 33)
           bcs  LD087          ; branch if lower
           bset *CylTrimFlags, #$%01000000    ; set bits
           bra  LD08A          ; branch

   LD087:  bclr *CylTrimFlags, #$%01000000    ; clear bits
   LD08A:  brclr *CylTrimFlags, #$%00000010, LD0AC    ; branch if bit(s) clear
           ldx  #AutoCalCell0    ; load index with value
           ldab CL3PTR_Cyl3AdaptiveMemoryPointer    ; load b with memory contents (data is 04)
           abx                 ; add b to index
           ldaa Cyl3_InjPWTrim    ; load a with memory contents
           suba 0x00, X    
           blt  LD0AC          ; branch if less
           brclr *CylTrimFlags, #$%00100000, LD0A2    ; branch if bit(s) clear
           adda CL3INC_Cyl3TrimIncrement    ;  (data is 05)
   LD0A2:  cmpa CL3LMT_Cyl3TrimLimit    ; compare a with memory contents (data is 33)
           bcs  LD0AC          ; branch if lower
           bset *CylTrimFlags, #$%00100000    ; set bits
           bra  LD0AF          ; branch

   LD0AC:  bclr *CylTrimFlags, #$%00100000    ; clear bits
   LD0AF:  brclr *CylTrimFlags, #$%00000001, LD0D0    ; branch if bit(s) clear
           ldx  #AutoCalCell0    ; load index with value
           ldab CL4PTR_Cyl4AdaptiveMemoryPointer    ; load b with memory contents (data is 05)
           abx                 ; add b to index
           ldaa Cyl4_InjPWTrim    ; load a with memory contents
           suba 0x00, X    
           blt  LD0D0          ; branch if less
           brclr *CylTrimFlags, #$%00010000, LD0C7    ; branch if bit(s) clear
           adda CL4INC_Cyl4TrimIncrement    ;  (data is 05)
   LD0C7:  cmpa CL4LMT_Cyl4TrimLimit    ; compare a with memory contents (data is 33)
           bcs  LD0D0          ; branch if lower
           bset *CylTrimFlags, #$%00010000    ; set bits
           rts                 ; return from subroutine

   LD0D0:  bclr *CylTrimFlags, #$%00010000    ; clear bits
           rts                 ; return from subroutine

IncludeCylTrimWithAdaptiveCells:
           bset *CylTrim_FlagsE8, #$%00100000    ; set bits
           bset *CylTrim_FlagsE7, #$%10000000    ; set bits
           ldab #0xf0          ; load b with value -11110000-
           bitb CylTrimFlags
           beq  LD136          ; branch if equal (zero)
           ldaa CoolantTemp    ; load a with memory contents
           cmpa CLTRP3_Cyl3TrimValueForPurgeVolume    ; compare a with memory contents (data is db)
           bhi  LD140          ; branch if higher
           ldaa Cyl1_InjPWTrim    ; load a with memory contents
           ldab Cyl3_InjPWTrim    ; load b with memory contents
           cba             
           bge  LD0EF          ; branch if greater or equal
           tba                 ; a = b
   LD0EF:  ldab Cyl4_InjPWTrim    ; load b with memory contents
           cba             
           bge  LD0F5          ; branch if greater or equal
           tba                 ; a = b
   LD0F5:  clrb                ; b = 0
   LD0F6:  cmpb CL2PTR_Cyl2AdaptiveMemoryPointer    ; compare b with memory contents (data is 0d)
           beq  LD10E          ; branch if equal (zero)
           cmpb CL1PTR_Cyl1AdaptiveMemoryPointer    ; compare b with memory contents (data is 03)
           beq  LD10E          ; branch if equal (zero)
           cmpb CL3PTR_Cyl3AdaptiveMemoryPointer    ; compare b with memory contents (data is 04)
           beq  LD10E          ; branch if equal (zero)
           cmpb CL4PTR_Cyl4AdaptiveMemoryPointer    ; compare b with memory contents (data is 05)
           beq  LD10E          ; branch if equal (zero)
           pshb                ; push b onto stack
           bsr  UpdateAdaptiveCellWithCylTrim    ; call subroutine
           pulb                ; pull b from stack
   LD10E:  incb            
           pshb                ; push b onto stack
           addb #0x11          ;  -00010001-
           cmpb #0x1f          ;  -00011111-
           pulb                ; pull b from stack
           bcs  LD0F6          ; branch if lower
           ldaa Cyl2_InjPWTrim    ; load a with memory contents
           ldab CL2PTR_Cyl2AdaptiveMemoryPointer    ; load b with memory contents (data is 0d)
           bsr  UpdateAdaptiveCellWithCylTrim    ; call subroutine
           ldaa Cyl1_InjPWTrim    ; load a with memory contents
           ldab CL1PTR_Cyl1AdaptiveMemoryPointer    ; load b with memory contents (data is 03)
           bsr  UpdateAdaptiveCellWithCylTrim    ; call subroutine
           ldaa Cyl3_InjPWTrim    ; load a with memory contents
           ldab CL3PTR_Cyl3AdaptiveMemoryPointer    ; load b with memory contents (data is 04)
           bsr  UpdateAdaptiveCellWithCylTrim    ; call subroutine
           ldaa Cyl4_InjPWTrim    ; load a with memory contents
           ldab CL4PTR_Cyl4AdaptiveMemoryPointer    ; load b with memory contents (data is 05)
           bsr  UpdateAdaptiveCellWithCylTrim    ; call subroutine
           bclr *CylTrimFlags, #$%11110000    ; clear bits
   LD136:  ldaa CoolantTemp    ; load a with memory contents
           cmpa CLTRP4_Cyl4TrimValueForPurgeVolume    ; compare a with memory contents (data is 84)
           bcc  LD140          ; branch if greater or equal
           bset *CylTrim_FlagsE8, #$%01000000    ; set bits
   LD140:  ldx  #CONFIG_ConfigurationFlags    ; load index with value
           brclr  0, X, #$%00100000, LD155    ; branch if bit(s) clear
           ldaa AutoCalCellEnd    ; load a with memory contents
           tab                 ; b = a
           suba AutoCalCell12idle
           blt  LD155          ; branch if less
           cmpa CL2LMT_Cyl2TrimLimit    ; compare a with memory contents (data is 33)
           bcs  LD155          ; branch if lower
           stab AutoCalCell12idle    ; store b into memory
   LD155:  rts                 ; return from subroutine

UpdateAdaptiveCellWithCylTrim:
           ldx  #AutoCalCell0    ; load index with value
           abx                 ; add b to index
           ldab 0x00, X        ; load b with memory at index + value
           cba             
           ble  LD161          ; branch if less or equal
           staa 0x00, X    
   LD161:  rts                 ; return from subroutine

; RPMHI_HiRPM3DInputModifierFromRPM:
; 	.byte	2						; number of points
; 	.byte	0x40, 0x80, 0x01, 0x00	; point 1
; 	.byte	0xbf, 0xff				; point 2
; RPMLO_LoRPM3DInputModifierFromRPM:
; 	.byte	4						; number of points
; 	.byte	0x64, 0x00, 0x01, 0x47	; point 1
; 	.byte	0x96, 0x40, 0x00, 0xa3	; point 2
; 	.byte	0xc8, 0x60, 0x00, 0x92	; point 3
; 	.byte	0xff, 0x7f				; point 4
; ARMPMD_ModifiedMAPForAdaptiveRetard3D:
; 	.byte	3						; number of points
; 	.byte	0x80, 0x00, 0x04, 0x00	; point 1
; 	.byte	0x90, 0x40, 0x02, 0x00	; point 2
; 	.byte	0xef, 0xff				; point 3

CalculateSparkAdvance_MM:
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd PreviousEngineRpm_HB    ; d = d - memory contents
           bcc  SparkAdvance_EngineDeccelerating    ; branch if greater or equal
           coma            
           comb            
           addd #0x0001         ;  -00000000 00000001-
           cmpD RPMFPS_SparkAdvanceRPMFilterLimitPos    ; compare D (data is 01)
           bcc  SparkAdvance_EngineSpeedNotAccelOrDeccel    ; branch if greater or equal
           xgDY                ; exchange D and Y
           ldaa RPMFRT_SparkAdvanceRPMFilterRatio    ; load a with memory contents (data is 7f)
           beq  SparkAdvance_EngineSpeedNotAccelOrDeccel    ; branch if equal (zero)
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           coma            
           comb            
           addd #0x0001         ;  -00000000 00000001-
           bra  LD1B9          ; branch

SparkAdvance_EngineDeccelerating:
           cmpD RPMFNG_SparkAdvanceRPMFilterLimitNeg    ; compare D (data is 01)
           bcc  SparkAdvance_EngineSpeedNotAccelOrDeccel    ; branch if greater or equal
           xgDY                ; exchange D and Y
           ldaa RPMFRT_SparkAdvanceRPMFilterRatio    ; load a with memory contents (data is 7f)
           beq  SparkAdvance_EngineSpeedNotAccelOrDeccel    ; branch if equal (zero)
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
   LD1B9:  addd PreviousEngineRpm_HB    ; d = d + memory contents
           bra  SparkAdvance_StorePreviousEngineRPM    ; branch

SparkAdvance_EngineSpeedNotAccelOrDeccel:
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
SparkAdvance_StorePreviousEngineRPM:
           stD *PreviousEngineRpm_HB    ; store D to RAM
           brset *BitFlags66, #$%10000000, SparkAdvance_LookupFullThrottleTiming    ; branch if bit(s) set
           brset *BitFlags67, #$%01000000, SparkAdvance_LookupFullThrottleTiming    ; branch if bit(s) set
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #IDLADV_IdleAdvanceFromCoolantTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp0          ; store a into memory
           brclr *BitFlags66, #$%00010000, LD200    ; branch if bit(s) clear
           ldaa Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop    ; load a with memory contents
           bne  LD200          ; branch if not equal (not zero)
           ldaa Counter_O2SensorFeedbackCount_Signed    ; load a with memory contents
           cmpa ADO2CL_AdvanceAddedFromO2FeedbackCounterLimitLow    ; compare a with memory contents (data is 1a)
           bge  LD200          ; branch if greater or equal
           cmpa ADO2CH_AdvanceAddedFromO2FeedbackCounterLimitHi    ; compare a with memory contents (data is e6)
           ble  LD200          ; branch if less or equal
           ldx  #ADO2C2_AdvanceAddedFromO2FeedbackCounter2    ; load index with value
           brset *BitFlags_36, #$%00001000, LD1F1    ; branch if bit(s) set
           ldx  #ADO2C1_AdvanceAddedFromO2FeedbackCounter1    ; load index with value
   LD1F1:  adda #0x80          ;  -10000000-
           jsr  Lookup4ByteTable    ; call subroutine
           staa O2AdvanceIncrement
           adda Temp0      
           bpl  LD1FE          ; branch if plus (hi bit 0)
           clra                ; a = 0
   LD1FE:  staa Temp0          ; store a into memory
   LD200:  jmp  LD29A      

SparkAdvance_LookupFullThrottleTiming:
           clrb                ; b = 0
           ldaa MapValue       ; load a with memory contents
           brclr *BitFlags66, #$%00000001, SparkAdvance_LookupPartThrottleTiming_LoMAP    ; branch if bit(s) clear
           decb            
           stab Temp2          ; store b into memory
           ldx  #MAPHI_HiMAP3DInputModifierFromMAP    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldx  #WOTMPH_FullThrottleTimingFromHiMAP    ; load index with value
           bra  SparkAdvance_LookupTimingFrom3DTable    ; branch

SparkAdvance_LookupPartThrottleTiming_LoMAP:
           cmpa TBLBK3_3DTableBreakPointHiLo          ; compare a with value -01000000-
           bcc  SparkAdvance_LookupPartThrottleTiming_HiMAP    ; branch if greater or equal
           stab Temp2          ; store b into memory
           ldx  #MAPLO_LoMAP3DInputModifierFromMAP    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldx  #HOTMPL_PartThrottleLowMAPTiming    ; load index with value
           bra  SparkAdvance_LookupTimingFrom3DTable    ; branch

SparkAdvance_LookupPartThrottleTiming_HiMAP:
           decb            
           stab Temp2          ; store b into memory
           ldx  #MAPHI_HiMAP3DInputModifierFromMAP    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldx  #HOTMPH_PartThrottleHiMAPTiming    ; load index with value
SparkAdvance_LookupTimingFrom3DTable:
           staa Temp3          ; store a into memory
           ldab EngineRPM_3D    ; load b with memory contents
           jsr  Lookup3DTableRoutine    ; call subroutine
           staa Temp0          ; store a into memory
           ldaa Temp3          ; load a with memory contents
           ldab EngineRPM_3D    ; load b with memory contents
           ldx  #IDLMOD_AdvanceModifier3DIdle    ; load index with value
           tst  Temp2      
           beq  LD24D          ; branch if equal (zero)
           ldx  #THRMOD_AdvanceModifier3DNormal    ; load index with value
   LD24D:  jsr  Lookup3DTableRoutine    ; call subroutine
           staa Temp3          ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #TMPSWP_EngTempSwitchPointForSparkAdvance    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldab Temp3          ; load b with memory contents
           bpl  LD25F          ; branch if plus (hi bit 0)
           negb            
   LD25F:  mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           tst  Temp3      
           bpl  LD268          ; branch if plus (hi bit 0)
           nega                ; negate a (set high bit)
   LD268:  adda Temp0      
           bvc  LD270          ; branch if overflow
           bpl  LD273          ; branch if plus (hi bit 0)
           ldaa #0x7f          ; load a with value -01111111-
   LD270:  tsta                ; test a
           bpl  LD274          ; branch if plus (hi bit 0)
   LD273:  clra                ; a = 0
   LD274:  staa Temp0          ; store a into memory
           ldaa MapValue       ; load a with memory contents
           ldx  #ARMPMD_ModifiedMAPForAdaptiveRetard3D    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldab EngineRPM_3D    ; load b with memory contents
           subb #0x80          ;  -10000000-
           bcc  LD285          ; branch if greater or equal
           clrb                ; b = 0
   LD285:  lslb
           ldx  #ARRPMP_AdaptiveRetardAdvanceFromRPMAndMAP3D    ; load index with value
           jsr  Lookup3DTableRoutine    ; call subroutine
           ldab AdaptiveRetardIndex    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           tab                 ; b = a
           ldaa Temp0          ; load a with memory contents
           sba                 ; subtract (a=a-b)
           bcc  CheckMaxSparkAdvance    ; branch if greater or equal
           clra                ; a = 0
CheckMaxSparkAdvance:
           staa Temp0          ; store a into memory
   LD29A:  ldx  #SPKLMT_TotalAdvanceAllowed    ; load index with value
           ldaa EngineRpm_HB    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           cmpa Temp0          ; compare a with memory contents
           bcc  LD2A8          ; branch if greater or equal
           staa Temp0          ; store a into memory
   LD2A8:  bclr *BitFlags6f, #$%00010000    ; clear bits
           clra                ; a = 0
           ldab BitFlags6e     ; load b with memory contents
           orab BitFlags66 
           bmi  LD328          ; branch if minus(hi bit 1)
           brset *BitFlags6b, #$%00010000, LD2C2    ; branch if bit(s) set
           ldab BitFlags_36    ; load b with memory contents
           andb #0x04          ;  -00000100-
           orab Timer_CountdownFromStartRunForAisFeedback
           bne  LD328          ; branch if not equal (not zero)
           brset *BitFlags67, #$%01000000, LD328    ; branch if bit(s) set
   LD2C2:  brset *b5c_IPL1, #$%10100000, LD328    ; branch if bit(s) set
           ldab SPKSET_ConstantSparkAdvanceWhenSettingBasicTiming    ; load b with memory contents (data is 18)
           brset *b5c_IPL1, #$%00000010, LD326    ; branch if bit(s) set
           brset *BitFlags6c, #$%00100000, LD326    ; branch if bit(s) set
           ldab IDLSET_ConstantSparkAdvanceWhenSettingMinThrottleOpening    ; load b with memory contents (data is 18)
           brset *BitFlags6c, #$%00010000, LD326    ; branch if bit(s) set
           ldab CoolantTemp    ; load b with memory contents
           cmpb SSTEMP_TempAboveWhichSparkScatterIsActive    ; compare b with memory contents (data is 58)
           bls  LD328          ; branch if lower or same
           ldx  KeyOnOrEngineRunningTime
           cpx  SSITIM_ScatterInhibitTime    ;  (data is 0088)
           bcs  LD328          ; branch if lower
           ldx  TimerOverflowsBetweenCamPulses
           cpx  SSIPRD_ScatterInhibitBelowThisSpeed    ;  (data is 0066)
           bcc  LD328          ; branch if greater or equal
           bset *BitFlags6f, #$%00010000    ; set bits
           ldx  #SPKRET_SparkAdvanceRetardedWhenRpmAboveControl_FromDeltaRpm    ; load index with value
           brset *BitFlags_36, #$%00001000, LD2FA    ; branch if bit(s) set
           ldx  #SPKRT2_SparkAdvanceRetardedWhenRpmAboveControl2_FromDeltaRpm    ; load index with value
   LD2FA:  ldd  PreviousEngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  LD30F          ; branch if greater or equal
           ldx  #SPKADD_SparkAdvanceAddedWhenRpmBelowControl_FromDeltaRpm    ; load index with value
           brset *BitFlags_36, #$%00001000, LD30A    ; branch if bit(s) set
           ldx  #SPKAD2_SparkAdvanceAddedWhenRpmBelowControl2_FromDeltaRpm    ; load index with value
   LD30A:  coma            
           comb            
           addd #0x0001         ;  -00000000 00000001-
   LD30F:  lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           bcc  LD318          ; branch if greater or equal
           addd #0x0001         ;  -00000000 00000001-
   LD318:  tsta                ; test a
           beq  LD31D          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   LD31D:  tba                 ; a = b
           jsr  Lookup4ByteTable    ; call subroutine
           addb Temp0          ; b=b+memory contents
           bpl  LD326          ; branch if plus (hi bit 0)
           clrb                ; b = 0
   LD326:  stab Temp0          ; store b into memory
   LD328:  staa SparkScatter    ; store a into memory
           ldab Temp0          ; load b with memory contents
           stab CalculatedSparkAdvance    ; store b into memory
           rts                 ; return from subroutine

Lookup3DTableRoutine:
           ldY #InterpUnsigned    ; load Y index -11010011 10110010-
           brclr  2, X, #$%11111111, LD33B    ; branch if bit(s) clear
           ldY #InterpSigned    ; load Y index -11010011 10101110-
   LD33B:  pshy                ; push Y onto stack
           psha                ; push a onto stack
           psha                ; push a onto stack
           ldaa 0x01, X        ; load a with memory at index + value
           deca                ; decrement a
           mul                 ; multiply (d=a*b)
           psha                ; push a onto stack
           pshb                ; push b onto stack
           tSY                 ; transfer stack to Y
           ldaA 2, Y       ; load A indexed to Y -00000010-
           ldab 0x00, X        ; load b with memory at index + value
           decb            
           mul                 ; multiply (d=a*b)
           staB 3, Y       ; store B to location indexed to Y -00000011-
           ldab 0x01, X        ; load b with memory at index + value
           staB 2, Y       ; store B to location indexed to Y -00000010-
           mul                 ; multiply (d=a*b)
           inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
           abx                 ; add b to index
           tsta                ; test a
           beq  LD362          ; branch if equal (zero)
           inx                 ; increment index (x=x+1)
           ldab #0xff          ; load b with value -11111111-
           abx                 ; add b to index
   LD362:  ldaB 1, Y       ; load B with value indexed to Y -00000001-
           abx                 ; add b to index
           ldaB 0, Y       ; load B with value indexed to Y -00000000-
           pshy                ; push Y onto stack
           ldY 4, Y        ; load Y indexed to Y -00000100-
           ldaa 0x00, X        ; load a with memory at index + value
           suba 0x01, X    
           jsr 0, Y        ; jump to subroutine at index Y + value -00000000-
           puly                ; pop Y from stack
           staA 1, Y       ; store A with value indexed to Y -00000001-
           ldaB 2, Y       ; load B with value indexed to Y -00000010-
           abx                 ; add b to index
           pulb                ; pull b from stack
           pshy                ; push Y onto stack
           ldY 4, Y        ; load Y indexed to Y -00000100-
           ldaa 0x00, X        ; load a with memory at index + value
           suba 0x01, X    
           jsr 0, Y        ; jump to subroutine at index Y + value -00000000-
           puly                ; pop Y from stack
           tsx                 ; transfer stack to index (x=sp+1)
           staa 0x01, X    
           ldab 0x02, X        ; load b with memory at index + value
           ldY 3, X        ; load Y indexed to X -00000011-
           ldaa 0x00, X        ; load a with memory at index + value
           suba 0x01, X    
           jsr 0, Y        ; jump to subroutine at index Y + value -00000000-
           pulb                ; pull b from stack
           pulx                ; pull index from stack
           pulx                ; pull index from stack
           rts                 ; return from subroutine

   LD3A0:  ldab 0x00, X        ; load b with memory at index + value
           decb            
           mul                 ; multiply (d=a*b)
           pshb                ; push b onto stack
           tab                 ; b = a
           incb            
           abx                 ; add b to index
           ldd  0x00, X    
           sba                 ; subtract (a=a-b)
           pulb                ; pull b from stack
           bra  InterpUnsigned    ; branch

InterpSigned:
           blt  LD3BA          ; branch if less
           bra  LD3B4          ; branch

InterpUnsigned:
           bcs  LD3BA          ; branch if lower
   LD3B4:  mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           nega                ; negate a (set high bit)
           bra  LD3BE          ; branch

   LD3BA:  nega                ; negate a (set high bit)
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
   LD3BE:  adda 0x00, X    
           rts                 ; return from subroutine

Interrupt_DwellTimerA:
           ldaa #0x20          ; load a with value -00100000-
           staa CPU_TimerInterruptFlag1
           brclr *BitFlagsC0, #$%10000000, LD403    ; branch if bit(s) clear
           ldab TimerOverflowsBetweenCamPulses    ; load b with memory contents
           bne  LD403          ; branch if not equal (not zero)
           brset *BitFlags6e, #$%00000010, LD403    ; branch if bit(s) set
           ldab CPU_TimerControlReg1    ; load b with memory contents
           bitb #0x10          ;  -00010000-
           beq  LD403          ; branch if equal (zero)
           ldaB #0x02          ; load b with value -00000010-
           ldaa AdvanceTemporary    ; load a with memory contents
           cmpa #0x66          ; compare a with value -01100110-
           bcc  LD3ED          ; branch if greater or equal
           cmpa #0x39          ; compare a with value -00111001-
           bcc  LD3E6          ; branch if greater or equal
           incb            
   LD3E6:  ldaa BitFlagsC0     ; load a with memory contents
           andA #0x07          ; AND a with value -00000111-
           cba             
           bcs  LD403          ; branch if lower
   LD3ED:  ldab CPU_TimerControlReg1    ; load b with memory contents
           andb #0xef          ;  -11101111-
           stab CPU_TimerControlReg1    ; store b into memory
           ldab Timer_Dwell_14    ; load b with memory contents
           clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd #0x07d0        ;  -00000111 11010000-
           addd CPU_Timer_OC3_Wastegate
           std  CPU_Timer_OC3_Wastegate
   LD403:  ldaa CPU_TimerInterruptMask1    ; load a with memory contents
           anda #0xdf          ; AND a with value -11011111-
           staa CPU_TimerInterruptMask1
           rti                 ; return from interrupt

Interrupt_DwellTimerB:
           ldaA #0x08          ; load a with value -00001000-
           staa CPU_TimerInterruptFlag1
           brclr *BitFlagsC0, #$%10000000, LD44E    ; branch if bit(s) clear
           ldab TimerOverflowsBetweenCamPulses    ; load b with memory contents
           bne  LD44E          ; branch if not equal (not zero)
           brset *BitFlags6e, #$%00000010, LD44E    ; branch if bit(s) set
           ldab CPU_TimerControlReg1    ; load b with memory contents
           bitb #0x01          ;  -00000001-
           beq  LD44E          ; branch if equal (zero)
           ldaB #0x02          ; load b with value -00000010-
           ldaa AdvanceTemporary    ; load a with memory contents
           cmpa #0x66          ; compare a with value -01100110-
           bcc  LD438          ; branch if greater or equal
           cmpa #0x39          ; compare a with value -00111001-
           bcc  LD431          ; branch if greater or equal
           incb            
   LD431:  ldaa BitFlagsC0     ; load a with memory contents
           andA #0x07          ; AND a with value -00000111-
           cba             
           bcs  LD44E          ; branch if lower
   LD438:  ldab CPU_TimerControlReg1    ; load b with memory contents
           andb #0xfe          ;  -11111110-
           stab CPU_TimerControlReg1    ; store b into memory
           ldab Timer_Dwell_23    ; load b with memory contents
           clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd #0x07d0        ;  -00000111 11010000-
           addd CPU_Timer_OC5_DwellB
           std  CPU_Timer_OC5_DwellB
   LD44E:  ldaa CPU_TimerInterruptMask1    ; load a with memory contents
           anda #0xf7          ; AND a with value -11110111-
           staa CPU_TimerInterruptMask1
           rti                 ; return from interrupt

CalculateKnockRetard_MM:
           clra                ; a = 0
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb KNKRPM_MinRpmforKnockRetard    ; compare b with memory contents (data is 20)
           bcs  LD485          ; branch if lower
           deca                ; decrement a
           ldab b5c_IPL1       ; load b with memory contents
           andb #0xe0          ;  -11100000-
           bne  LD47F          ; branch if not equal (not zero)
           ldaa MapValue       ; load a with memory contents
           ldab TpsVolts       ; load b with memory contents
           subb MINTHR_LowestSessionTPS    ; b = b-memory contents
           bcs  LD47F          ; branch if lower
           cmpb THRKNK_DeltaAbove_MINTHR    ; compare b with memory contents (data is 53)
           bcs  LD47F          ; branch if lower
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb KLMRPM_MinKnockDetectRpm    ; compare b with memory contents (data is 20)
           bcc  LD47F          ; branch if greater or equal
           ldaa KNKLIM_MaxKnockRetard    ; load a with memory contents (data is 06)
           bra  LD485          ; branch

   LD47F:  ldx  #RETMAX_MaxKnockRetardFromMap    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
   LD485:  staa MaxRetardFromMAP    ; store a into memory
           ldaa EngineRpm_HB    ; load a with memory contents
           ldx  #DLTKNK_KnockSensorVoltageForKnockFromRpm    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa KnockSensorThreshold    ; store a into memory
           ldaa Counter_MainLoop    ; load a with memory contents
           bita INCSRT_KnockRetardIncreaseRate    ;  (data is 0f)
           bne  LD4AA          ; branch if not equal (not zero)
           ldx  #Cylinder2Retard    ; load index with value
   LD49B:  sei                 ; disable interrupts
           ldaa 0x00, X        ; load a with memory at index + value
           beq  LD4A3          ; branch if equal (zero)
           deca                ; decrement a
           staa 0x00, X    
   LD4A3:  cli                 ; enable interrupts
           inx                 ; increment index (x=x+1)
           cpx  #Cylinder4Retard    ;  -00000000 11000111-
           bls  LD49B          ; branch if lower or same
   LD4AA:  rts                 ; return from subroutine

   LD4AB:  brclr *CCDFlags1, #$%00010000, LD4DB    ; branch if bit(s) clear
           ldaa TimerOverflowsBetweenCamPulses    ; load a with memory contents
           cmpa #0x05          ; compare a with value -00000101-
           bcs  LD4DB          ; branch if lower
           ldab #0x22          ; load b with value -00100010-
           stab CPU_TimerControlReg1    ; store b into memory
           ldab #0x28          ; load b with value -00101000-
           stab CPU_HardwareTimerForceCompare    ; store b into memory
           cmpa #0x13          ; compare a with value -00010011-
           bne  LD4DB          ; branch if not equal (not zero)
           sei                 ; disable interrupts
           clr  BitFlagsC0     ; zero byte at memory location
           clr  PIA_Ctrl_6          ; zero byte at memory location
           ldaB #0x01          ; load b with value -00000001-
           stab PIA_Ctrl_4     ; store b into memory
           stab CPU_TimerInterruptFlag1    ; store b into memory
           ldab #0xfe          ; load b with value -11111110-
           andb PIA_Ctrl_3 
           stab PIA_Ctrl_3     ; store b into memory
           cli                 ; enable interrupts
   LD4DB:  rts                 ; return from subroutine

DecrementDwellTimers_MM:
           brclr *BitFlagsC0, #$%00001000, LD4FA    ; branch if bit(s) clear
           brset *BitFlags6e, #$%00000010, LD4FA    ; branch if bit(s) set
           ldx  #Timer_Dwell_14    ; load index with value
           ldaa Counter_MainLoop    ; load a with memory contents
           anda #0x3f          ; AND a with value -00111111-
           cmpa #0x1f          ; compare a with value -00011111-
           beq  LD4F4          ; branch if equal (zero)
           inx                 ; increment index (x=x+1)
           cmpa #0x3f          ; compare a with value -00111111-
           bne  LD4FA          ; branch if not equal (not zero)
   LD4F4:  brclr  0, X, #$%11111111, LD4FA    ; branch if bit(s) clear
           dec  0x00, X    
   LD4FA:  rts                 ; return from subroutine

RescaleRPMFor3D_MM:
           ldx  #RPMHI_HiRPM3DInputModifierFromRPM    ; load index with value
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           cmpD #0x4000        ; compare D -01000000 00000000-
           bcc  LD50B          ; branch if greater or equal
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           ldx  #RPMLO_LoRPM3DInputModifierFromRPM    ; load index with value
   LD50B:  jsr  Lookup4ByteTable    ; call subroutine
           staa EngineRPM_3D    ; store a into memory
           rts                 ; return from subroutine

CalcTargetBoost_MM:
           ldaa ATMOffset      ; load a with memory contents
           cmpa #0x11          ; compare a with value -00010001-
           beq  LD51B          ; branch if equal (zero)
           cmpa #0x14          ; compare a with value -00010100-
           bne  LD51C          ; branch if not equal (not zero)
   LD51B:  rts                 ; return from subroutine

   LD51C:  brclr *BitFlags6e, #$%10000000, LD538    ; branch if bit(s) clear
           clra                ; a = 0
           staa WastegateDutyCycleIncreaseFromKnock    ; store a into memory
           jsr  NULL_ROUTINE    ; call subroutine
           staa CurrentWastegatePosition    ; store a into memory
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x1f          ;  -00011111-
           bne  LD537          ; branch if not equal (not zero)
           ldaa Timer_BoostTimer    ; load a with memory contents
           beq  LD537          ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_BoostTimer
   LD537:  rts                 ; return from subroutine

   LD538:  ldaa Counter_MainLoop    ; load a with memory contents
           ldx  #Cylinder2Retard    ; load index with value
   LD53D:  ldab 0x00, X        ; load b with memory at index + value
           beq  Boost_LookAtCylRetards    ; branch if equal (zero)
           bita ARCMSK_AdaptiveRetardCounterMask    ;  (data is 3f)
           bne  LD579          ; branch if not equal (not zero)
           ldaa CoolantTemp    ; load a with memory contents
           cmpa ARMINT_AdaptiveRetardMinimumTemp    ; compare a with memory contents (data is b1)
           bls  LD576          ; branch if lower or same
           ldaa Timer_Over5PsiBoostMaxFF    ; load a with memory contents
           inca                ; increment a
           cmpa ARTM5P_AdaptiveRetardTimeOver5psiBoost    ; compare a with memory contents (data is 09)
           bcs  LD577          ; branch if lower
           sei                 ; disable interrupts
           ldaa AdaptiveRetardIndex    ; load a with memory contents
           adda ARINDX_AdaptiveRetardIndexBase_80    ;  (data is 80)
           bcc  LD55F          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LD55F:  staa AdaptiveRetardIndex    ; store a into memory
           cli                 ; enable interrupts
           bra  LD576          ; branch

Boost_LookAtCylRetards:
           inx                 ; increment index (x=x+1)
           cpx  #Cylinder4Retard    ;  -00000000 11000111-
           bls  LD53D          ; branch if lower or same
           bita ARCMS2_AdaptiveRetardCounterMask2_00    ;  (data is 00)
           bne  LD579          ; branch if not equal (not zero)
           ldaa Timer_Over5PsiBoostMaxFF    ; load a with memory contents
           suba ARCMS3_AdaptiveRetardCounterMask3_FF    ;  (data is ff)
           bcc  LD577          ; branch if greater or equal
   LD576:  clra                ; a = 0
   LD577:  staa Timer_Over5PsiBoostMaxFF    ; store a into memory
   LD579:  brclr *BitFlags71, #$%01000000, LD598    ; branch if bit(s) clear
           bclr *BitFlags71, #$%01000000    ; clear bits
           ldab WastegateDutyCycleIncreaseFromKnock    ; load b with memory contents
           addb KDCINC_WastegateDutyCycleIncreaseStepWhenKnocking    ;  (data is 01)
           bcc  LD589          ; branch if greater or equal
           ldab #0xff          ; load b with value -11111111-
   LD589:  ldaa KDCMAX_WastegateDutyCycleIncreaseMaxWhenKnocking    ; load a with memory contents (data is 27)
           cba             
           bcs  LD595          ; branch if lower
           ldaa KDCMIN_WastegateDutyCycleIncreaseMinWhenKnocking    ; load a with memory contents (data is 02)
           cba             
           bcs  LD5B7          ; branch if lower
   LD595:  tab                 ; b = a
           bra  LD5B7          ; branch

   LD598:  ldab Counter_MainLoop    ; load b with memory contents
           bitb DECTIM_TimeScaleFor_DCDECK    ;  (data is 07)
           bne  BoostControlRoutine    ; branch if not equal (not zero)
           ldx  #CalculatedSparkAdvance    ; load index with value
   LD5A2:  inx                 ; increment index (x=x+1)
           cpx  #MaxRetardFromMAP    ;  -00000000 11001000-
           beq  LD5B6          ; branch if equal (zero)
           ldaa 0x00, X        ; load a with memory at index + value
           cmpa MPDEL1_IncCounterWhenDeltaMapBelowThis    ; compare a with memory contents (data is 07)
           bcs  LD5A2          ; branch if lower
           ldab WastegateDutyCycleIncreaseFromKnock    ; load b with memory contents
           subb DCDECK_WastegateDutyCycleDecrementWhenSparkStillDerated    ; subtract memory contents from b (data is 02)
           bcc  LD5B7          ; branch if greater or equal
   LD5B6:  clrb                ; b = 0
   LD5B7:  stab WastegateDutyCycleIncreaseFromKnock    ; store b into memory
BoostControlRoutine:
           ldaa MapValue       ; load a with memory contents
           staa Temp2          ; store a into memory
           tab                 ; b = a
           suba BaroPressure
           bcc  LD5C3          ; branch if greater or equal
           clra                ; a = 0
   LD5C3:  staa Temp1          ; store a into memory
           ldaa DeltaBoostSampleCounter    ; load a with memory contents
           cmpa DLTBSC_DeltaBoostSampleCounterMax    ; compare a with memory contents (data is 07)
           bcc  BC_CalculateSignedDeltaBoost    ; branch if greater or equal
           inca                ; increment a
           bra  BC_GetBoostTargetFromTables    ; branch

BC_CalculateSignedDeltaBoost:
           tba                 ; a = b
           subb PreviousBoostOverBaro    ; b = b-memory contents
           staa PreviousBoostOverBaro    ; store a into memory
           bcc  LD5DF          ; branch if greater or equal
           cmpb #0x80          ;  -10000000-
           bcc  BC_SaveSignedDeltaBoost    ; branch if greater or equal
           ldab #0x80          ; load b with value -10000000-
           bra  BC_SaveSignedDeltaBoost    ; branch

   LD5DF:  cmpb #0x7f          ;  -01111111-
           bls  BC_SaveSignedDeltaBoost    ; branch if lower or same
           ldab #0x7f          ; load b with value -01111111-
BC_SaveSignedDeltaBoost:
           stab BoostDelta_Signed    ; store b into memory
           clra                ; a = 0
BC_GetBoostTargetFromTables:
           staa DeltaBoostSampleCounter
           ldx  #WSGRPM_AllowedBoost_FromRpm    ; load index with value
           ldaa EngineRpm_HB    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp4          ; store a into memory
           brclr *AdaptiveRetardIndex, #$%11111111, LD601    ; branch if bit(s) clear
           ldx  #WSGRPA_AllowedBoostKnock_FromRpm    ; load index with value
           ldaa EngineRpm_HB    ; load a with memory contents
           jsr  LookupAndKeepSmallerBoostGoal    ; call subroutine
   LD601:  ldx  #WSGTIM_AllowedBoost_FromTime    ; load index with value
           ldaa Timer_BoostTimer    ; load a with memory contents
           jsr  LookupAndKeepSmallerBoostGoal    ; call subroutine
           ldx  #WSGCLT_AllowedBoost_FromTemp    ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           jsr  LookupAndKeepSmallerBoostGoal    ; call subroutine
           ldx  #WSGCHG_AllowedBoost_FromChargeTemp    ; load index with value
           ldaa ChargeTempVolts    ; load a with memory contents
           jsr  LookupAndKeepSmallerBoostGoal    ; call subroutine
           ldx  #MXSBST_AllowedBoost_FromSpeed    ; load index with value
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           jsr  LookupAndKeepSmallerBoostGoal    ; call subroutine
           ldx  #WSGPRT_AllowedBoostPartThrottle_FromThrottle    ; load index with value
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bcc  LD62F          ; branch if greater or equal
           clra                ; a = 0
   LD62F:  jsr  LookupAndKeepSmallerBoostGoal    ; call subroutine

BC_CheckBoostSwitch:
; ; the switchable boost code uses a constant for the "lo" boost setting
; ; if the boost switch is enabled (set to "hi" boost), the code ignores the "lo" constant
; ; the code first checks to see if the switchable boost option is even enabled...
; 
; ; here, I check to see if the switchable boost is enabled or not, if not just skip to StoreBoostTarget...
	   ldaa OPTN1_CalCustomOptionConfigFlags1
	   bita #opt_SwBoost ; check if switchable boost is enabled
           beq  BC_FinalBoostTarget ;skip looking at the switch state completely

	   ldab StartupSwitchMirror1    ; load b with memory contents
	   bita #opt_SwBstPol ; check the switch polarity
	   beq  BC_Polarity_Lo

BC_Polarity_Hi:
           bitb BSTSWS_HighBoostSwitchSelect
	   beq  BC_LoadLoBoostAndLookup	    ; branch if equal (zero)
	   bra  BC_FinalBoostTarget

BC_Polarity_Lo:
	   bitb BSTSWS_HighBoostSwitchSelect
	   bne  BC_LoadLoBoostAndLookup	    ; branch if not equal (not zero)
	   bra  BC_FinalBoostTarget

BC_LoadLoBoostAndLookup:
	   ldaa LOWBST_AllowedBoostLo    ; "lo" boost constant
           jsr  LookupAndKeepSmallerBoostGoal

BC_FinalBoostTarget:

; this is original code...

           ldaa Temp4          ; load a with memory contents
           adda BaroPressure
           bcc  BC_StoreBoostTarget    ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
BC_StoreBoostTarget:
           staa BoostTarget    ; store a into memory
           brclr *BitFlags66, #$%10000000, LD645    ; branch if bit(s) clear
           clr  CurrentWGIncrement    ; zero byte at memory location
           bra  LD652          ; branch

   LD645:  ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x03          ;  -00000011-
           bne  LD652          ; branch if not equal (not zero)
           ldaa CurrentWGIncrement    ; load a with memory contents
           inca                ; increment a
           beq  LD652          ; branch if equal (zero)
           staa CurrentWGIncrement    ; store a into memory
   LD652:  ldaa BaroPressure    ; load a with memory contents
           adda MAPPT2_WastegateDutyCycleMapSwitchPoint2    ;  (data is 04)
           cmpa Temp2          ; compare a with memory contents
           bls  BC_CalculateWGDutyCycleVars    ; branch if lower or same
           clra                ; a = 0
           staa WastegateDutyCycleIncreaseFromKnock    ; store a into memory
           brset *BitFlags66, #$%10000000, LD671    ; branch if bit(s) set
           ldab Timer_BoostTimer    ; load b with memory contents
           beq  LD671          ; branch if equal (zero)
           ldab CurrentWGIncrement    ; load b with memory contents
           cmpb DFWGD2_DefaultWastegateDutyCycle2    ; compare b with memory contents (data is 40)
           bhi  LD671          ; branch if higher
           ldaa WGILML_WGIncrementLimitLo    ; load a with memory contents (data is a0)
   LD671:  jsr  NULL_ROUTINE    ; call subroutine
           staa CurrentWastegatePosition    ; store a into memory
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x1f          ;  -00011111-
           bne  LD685          ; branch if not equal (not zero)
           ldaa Timer_BoostTimer    ; load a with memory contents
           beq  LD685          ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_BoostTimer
   LD685:  rts                 ; return from subroutine

BC_AdjustWGDutyCycle:
           bmi  LD694          ; branch if minus(hi bit 1)
           adda Temp4      
           bcs  LD690          ; branch if lower
           cmpa #0xc8          ; compare a with value -11001000-
           bls  LD699          ; branch if lower or same
   LD690:  ldaa #0xc8          ; load a with value -11001000-
           bra  LD699          ; branch

   LD694:  adda Temp4      
           bcs  LD699          ; branch if lower
           clra                ; a = 0
   LD699:  staa Temp4          ; store a into memory
           rts                 ; return from subroutine

BC_CalculateWGDutyCycleVars:
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x1f          ;  -00011111-
           bne  LD6B2          ; branch if not equal (not zero)
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb RPMBST_MinimumRpmToTrackBoostCreep    ; compare b with memory contents (data is 3b)
           bcs  LD6B2          ; branch if lower
           ldaa Timer_BoostTimer    ; load a with memory contents
           inca                ; increment a
           beq  LD6B2          ; branch if equal (zero)
           staa Timer_BoostTimer
   LD6B2:  ldaa BoostDelta_Signed    ; load a with memory contents
           bpl  LD6BB          ; branch if plus (hi bit 0)
           nega                ; negate a (set high bit)
           staa Temp0          ; store a into memory
           bra  BC_ClearWGDutyCycleVars    ; branch

   LD6BB:  staa Temp0          ; store a into memory
           ldab BPRMIN_VNTMinimumBoostForIncrRateAdjustment    ; load b with memory contents (data is ee)
           bmi  LD6CA          ; branch if minus(hi bit 1)
           addb BoostTarget    ; b=b+memory contents
           bcc  LD6C8          ; branch if greater or equal
           ldab #0xff          ; load b with value -11111111-
   LD6C8:  bra  LD6CF          ; branch

   LD6CA:  addb BoostTarget    ; b=b+memory contents
           bcs  LD6CF          ; branch if lower
           clrb                ; b = 0
   LD6CF:  ldaa BoostTarget    ; load a with memory contents
           cmpb Temp2      
           bhi  LD6D8          ; branch if higher
           ldaa BPRMN2_VNTMinimumDeltaBoostForIncrRateAdjustment    ; load a with memory contents (data is 06)
   LD6D8:  cmpa BoostDelta_Signed    ; compare a with memory contents
           bhi  BC_ClearWGDutyCycleVars    ; branch if higher
           ldx  #WGDCDB_VNTWGDutyCycleDecreaseFromDeltaBoost    ; load index with value
           ldaa BoostDelta_Signed    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           bra  BC_StoreWGDutyCycleFromKnock    ; branch

BC_ClearWGDutyCycleVars:
           clra                ; a = 0
BC_StoreWGDutyCycleFromKnock:
           staa WastegateDutyCycleDecreaseFromX    ; store a into memory
           ldaa BoostTarget    ; load a with memory contents
           suba BaroPressure
           bcc  BC_LookupWGDutyCycleBase    ; branch if greater or equal
           clra                ; a = 0
BC_LookupWGDutyCycleBase:
           ldx  #DCWOT_FullThrottleWastegateDutyCycle_C8is100Percent_FromMap    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp4          ; store a into memory
           ldaa EngineRpm_HB    ; load a with memory contents
           ldx  #DCWADJ_FullThrottleWastegateDutyCycleAdjustment_FromRpm    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           bsr  BC_AdjustWGDutyCycle    ; call subroutine
           ldaa ChargeTempVolts    ; load a with memory contents
           ldx  #DCWCHG_FullThrottleWastegateDutyCycleAdjustment_FromChargeTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           jsr  BC_AdjustWGDutyCycle    ; call subroutine
           ldaa Temp4          ; load a with memory contents
           suba WastegateDutyCycleDecreaseFromX
           bcc  LD714          ; branch if greater or equal
           clra                ; a = 0
   LD714:  staa Temp4          ; store a into memory
           ldaa BoostTarget    ; load a with memory contents
           ldab BaroPressure    ; load b with memory contents
           addb MAPPT_WastegateDutyCycleMapSwitchPoint    ;  (data is 46)
           bcc  BC_SelectAdaptiveWGCell    ; branch if greater or equal
           ldab #0xff          ; load b with value -11111111-
BC_SelectAdaptiveWGCell:
           ldx  #DCCOR1_AdaptiveWastegateCellBelow3psi    ; load index with value
           cba             
           bcs  LD748          ; branch if lower
           inx                 ; increment index (x=x+1)
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb DCRPM1_WastegateDutyCycleRpmBoundary1    ; compare b with memory contents (data is 7d)
           bcs  LD748          ; branch if lower
           inx                 ; increment index (x=x+1)
           cmpb DCRPM2_WastegateDutyCycleRpmBoundary2    ; compare b with memory contents (data is 96)
           bcs  LD748          ; branch if lower
           inx                 ; increment index (x=x+1)
           cmpb DCRPM3_WastegateDutyCycleRpmBoundary3    ; compare b with memory contents (data is af)
           bcs  LD748          ; branch if lower
           inx                 ; increment index (x=x+1)
           cmpb DCRPM4_WastegateDutyCycleRpmBoundary4    ; compare b with memory contents (data is fe)
           bcs  LD748          ; branch if lower
           inx                 ; increment index (x=x+1)
           cmpb DCRPM5_WastegateDutyCycleRpmBoundary5    ; compare b with memory contents (data is ff)
           bcs  LD748          ; branch if lower
           inx                 ; increment index (x=x+1)
   LD748:  ldab 0x00, X        ; load b with memory at index + value
           brclr *BitFlags6a, #$%00000100, LD765    ; branch if bit(s) clear
           brclr *BitFlags6a, #$%00100000, LD773    ; branch if bit(s) clear
           bclr *BitFlags6a, #$%00100000    ; clear bits
           subb WGDCOF_WastegateDutyCycleOffset    ; subtract memory contents from b (data is 00)
           bcs  LD75F          ; branch if lower
           cmpb DECLIM_LowerLimitOnWastegateDutyCycleCorrection    ; compare b with memory contents (data is 01)
           bhi  LD762          ; branch if higher
   LD75F:  ldab DECLIM_LowerLimitOnWastegateDutyCycleCorrection    ; load b with memory contents (data is 01)
   LD762:  jmp  BC_UpdateAdaptiveWGControlMemory

   LD765:  suba Temp2      
           bhi  BC_BoostIsBelowTarget    ; branch if higher
           nega                ; negate a (set high bit)
           staa Temp3          ; store a into memory
           brset *BitFlags68, #$%00000001, BC_ControlBoostCreep    ; branch if bit(s) set
           bset *BitFlags68, #$%00000001    ; set bits
   LD773:  jmp  BC_ClearBoostErrTimer

BC_ControlBoostCreep:
           ldaa BoostDelta_Signed    ; load a with memory contents
           bmi  LD77F          ; branch if minus(hi bit 1)
           cmpa DBCRPS_DeltaBoostLimitPositiveForBoostCreep    ; compare a with memory contents (data is 01)
           bcc  LD7AE          ; branch if greater or equal
   LD77F:  ldaa DBCRNG_DeltaBoostLimitNegativeForBoostCreep    ; load a with memory contents (data is 03)
           cmpa Temp0          ; compare a with memory contents
           bcs  LD7CD          ; branch if lower
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa DCRPMLV_NoWastegateDutyCycleCorrectionBelowThisRpmBC    ; compare a with memory contents (data is 40)
           bcc  LD797          ; branch if greater or equal
           ldaa Timer_BoostErrTimer    ; load a with memory contents
           inca                ; increment a
           cmpa DECPTV_AdaptiveDecAfterThisTimeBC    ; compare a with memory contents (data is 20)
           bcs  LD7CF          ; branch if lower
           bra  LD79F          ; branch

   LD797:  ldaa Timer_BoostErrTimer    ; load a with memory contents
           inca                ; increment a
           cmpa DECPT_AdaptiveDecAfterThisTime    ; compare a with memory contents (data is 18)
           bcs  LD7CF          ; branch if lower
   LD79F:  ldaa Temp3          ; load a with memory contents
           cmpa MPFLOR_StopAdaptiveWGWhenDeltaMapIsLessThanThis    ; compare a with memory contents (data is 02)
           bcs  LD7CD          ; branch if lower
           cmpb DECLIM_LowerLimitOnWastegateDutyCycleCorrection    ; compare b with memory contents (data is 01)
           bls  LD7CD          ; branch if lower or same
           decb            
           bra  BC_UpdateAdaptiveWGControlMemory    ; branch

   LD7AE:  ldaa BaroPressure    ; load a with memory contents
           adda OBCTRL_OverboostControlPoint    ;  (data is 73)
           bcc  LD7B7          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LD7B7:  cmpa Temp2          ; compare a with memory contents
           bhi  LD77F          ; branch if higher
           ldaa Timer_BoostErrTimer    ; load a with memory contents
           inca                ; increment a
           cmpa INCPT_AdaptiveIncAfterThisTime    ; compare a with memory contents (data is 06)
           bcs  BC_StoreBoostErrTimer    ; branch if lower
           cmpb DECLIM_LowerLimitOnWastegateDutyCycleCorrection    ; compare b with memory contents (data is 01)
           bls  LD7CD          ; branch if lower or same
           subb WGDCON_WGDCOffsetNegatve    ; subtract memory contents from b (data is 02)
           bra  BC_UpdateAdaptiveWGControlMemory    ; branch

   LD7CD:  bra  BC_ClearBoostErrTimer    ; branch

   LD7CF:  bra  BC_StoreBoostErrTimer    ; branch

BC_BoostIsBelowTarget:
           brclr *BitFlags68, #$%00000001, BC_IncrementWGAdaptive    ; branch if bit(s) clear
           bclr *BitFlags68, #$%00000001    ; clear bits
           bra  BC_ClearBoostErrTimer    ; branch

BC_IncrementWGAdaptive:
           cmpa MPROOF_StopAdaptiveWGWhenMapIsThisCloseToBoostTarget    ; compare a with memory contents (data is 00)
           bcs  BC_ClearBoostErrTimer    ; branch if lower
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bls  BC_ClearBoostErrTimer    ; branch if lower or same
           cmpa TPSLIM_UpdateAdaptiveWGTPSUpperLimit    ; compare a with memory contents (data is 5b)
           bcs  BC_ClearBoostErrTimer    ; branch if lower
           ldaa Temp2          ; load a with memory contents
           suba MapAverageValue_HB
           bcc  LD7F1          ; branch if greater or equal
           nega                ; negate a (set high bit)
   LD7F1:  cmpa MPDEL2_IncCounterWhenDeltaMapBelowThis2    ; compare a with memory contents (data is 09)
           bhi  BC_ClearBoostErrTimer    ; branch if higher
           ldaa WastegateDutyCycleIncreaseFromKnock    ; load a with memory contents
           bne  BC_ClearBoostErrTimer    ; branch if not equal (not zero)
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa DCRPML_NoWastegateDutyCycleCorrectionBelowThisRpm    ; compare a with memory contents (data is 55)
           bcs  BC_ClearBoostErrTimer    ; branch if lower
           cmpa DCRPMH_NoWastegateDutyCycleCorrectionAboveThisRpm    ; compare a with memory contents (data is be)
           bhi  BC_ClearBoostErrTimer    ; branch if higher
           ldaa CoolantTemp    ; load a with memory contents
           cmpa DCCTSL_NoWastegateDutyCycleCorrectionBelowThisCoolantTemp    ; compare a with memory contents (data is b1)
           bcs  BC_ClearBoostErrTimer    ; branch if lower
           ldaa Timer_BoostErrTimer    ; load a with memory contents
           inca                ; increment a
           cmpa DECPTX_AdaptiveDecAfterThisTimeX    ; compare a with memory contents (data is 20)
           bcs  BC_StoreBoostErrTimer    ; branch if lower
           cmpb WGMXER_MaxWGDCForBoostErrorCorrection    ; compare b with memory contents (data is c6)
           bcc  BC_ClearBoostErrTimer    ; branch if greater or equal
           incb            
BC_UpdateAdaptiveWGControlMemory:
           stab 0x00, X    
BC_ClearBoostErrTimer:
           clra                ; a = 0
BC_StoreBoostErrTimer:
           staa Timer_BoostErrTimer    ; store a into memory
           ldaa Temp4          ; load a with memory contents
           subb #0x80          ;  -10000000-
           bmi  LD831          ; branch if minus(hi bit 1)
           aba                 ; a=a+b
           bcs  BC_LoadMaxWGDutyCycle    ; branch if lower
           cmpa #0xc8          ; compare a with value -11001000-
           bls  BC_IncludeWGDutyCycleFromKnock    ; branch if lower or same
BC_LoadMaxWGDutyCycle:
           ldaa #0xc8          ; load a with value -11001000-
           bra  BC_IncludeWGDutyCycleFromKnock    ; branch

   LD831:  negb            
           sba                 ; subtract (a=a-b)
           bcc  BC_IncludeWGDutyCycleFromKnock    ; branch if greater or equal
           clra                ; a = 0
BC_IncludeWGDutyCycleFromKnock:
           suba WastegateDutyCycleIncreaseFromKnock
           bcc  LD83B          ; branch if greater or equal
           clra                ; a = 0
   LD83B:  brset *BitFlags66, #$%10000000, LD84E    ; branch if bit(s) set
           ldab Timer_BoostTimer    ; load b with memory contents
           beq  LD84E          ; branch if equal (zero)
           ldab CurrentWGIncrement    ; load b with memory contents
           cmpb DFWGD2_DefaultWastegateDutyCycle2    ; compare b with memory contents (data is 40)
           bhi  LD84E          ; branch if higher
           ldaa WGILML_WGIncrementLimitLo    ; load a with memory contents (data is a0)
   LD84E:  staa Temp4          ; store a into memory
           ldaa WastegateDutyCycleIncreaseFromKnock    ; load a with memory contents
           bne  LD877          ; branch if not equal (not zero)
           ldaa EngineRpm_HB    ; load a with memory contents
           ldx  #BSTTSH_BoostTargetThresholdForDefaultWGDutyCycle        ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa BoostTarget    ; load a with memory contents
           suba BaroPressure
           bcc  LD863          ; branch if greater or equal
           clra                ; a = 0
   LD863:  cmpa BSTTH2_BoostTargetThresholdForDefaultWGDutyCycle2    ; compare a with memory contents (data is 50)
           bcs  LD877          ; branch if lower
           ldaa BoostTarget    ; load a with memory contents
           sba                 ; subtract (a=a-b)
           bcc  LD86E          ; branch if greater or equal
           clra                ; a = 0
   LD86E:  cmpa Temp2          ; compare a with memory contents
           bls  LD877          ; branch if lower or same
           ldaa DFWGDC_DefaultWastegateDutyCycle    ; load a with memory contents (data is 6e)
           bra  BC_StoreWGDutyCycle    ; branch

   LD877:  ldaa Temp4          ; load a with memory contents
BC_StoreWGDutyCycle:
           jsr  NULL_ROUTINE    ; call subroutine
           staa CurrentWastegatePosition    ; store a into memory
           rts                 ; return from subroutine

LookupAndKeepSmallerBoostGoal:
           jsr  Lookup4ByteTable    ; call subroutine
           cmpa Temp4          ; compare a with memory contents
           bcc  LD888          ; branch if greater or equal
           staa Temp4          ; store a into memory
   LD888:  rts                 ; return from subroutine

Interrupt_TimerOC3_Wastegate:
           ldaa #0x64          ; load a with value -01100100-
           ldab CurrentWastegatePosition    ; load b with memory contents
           cmpb #0x04          ;  -00000100-
           bls  LD89C          ; branch if lower or same
           cmpb #0xc4          ;  -11000100-
           bcc  LD8A6          ; branch if greater or equal
           brset *CCDFlags2, #$%00000100, LD8A5    ; branch if bit(s) set
           ldaa #0xc8          ; load a with value -11001000-
           sba                 ; subtract (a=a-b)
   LD89C:  psha                ; push a onto stack
           bset *CCDFlags2, #$%00000100    ; set bits
           bset *CCDFlags1, #$%00000100    ; set bits
           bra  LD8AD          ; branch

   LD8A5:  tba                 ; a = b
   LD8A6:  psha                ; push a onto stack
           bclr *CCDFlags2, #$%00000100    ; clear bits
           bclr *CCDFlags1, #$%00000100    ; clear bits
   LD8AD:  ldab CPU_SerialPeripheralControl    ; load b with memory contents
           oraB #0x01          ;  -00000001-
           stab CPU_SerialPeripheralControl    ; store b into memory
           bclr *PIA_Buffer2, #pia_bit2    ; clear bits
           ldab PIA_Buffer2    ; load b with memory contents
           stab PortX_Control    ; store b into memory
           ldaa CCDFlags2      ; load a with memory contents
           cmpa CPU_SerialPeripheralStatus    ; compare a with memory contents
           staa CPU_SerialPeripheralDataIO
           mul                 ; multiply (d=a*b)
           mul                 ; multiply (d=a*b)
           nop                 ; no operation
           bset *PIA_Buffer2, #pia_bit2    ; set bits
           ldaa PIA_Buffer2    ; load a with memory contents
           staa PortX_Control
           ldaa CPU_SerialPeripheralDataIO    ; load a with memory contents
           ldab CPU_SerialPeripheralControl    ; load b with memory contents
           andb #0xfc          ;  -11111100-
           stab CPU_SerialPeripheralControl    ; store b into memory
           pula                ; pull a from stack
           clrb                ; b = 0
           lsrd                ; shift right (d=d/2)
           addd CPU_Timer_OC4_DwellA
           std  CPU_Timer_OC4_DwellA
           ldaa #0x10          ; load a with value -00010000-
           staa CPU_TimerInterruptFlag1
           rti                 ; return from interrupt

IncrementLoopCounters_MM:
           inc  Counter_MainLoop
           bne  LD906          ; branch if not equal (not zero)
           ldaa #0xff          ; load a with value -11111111-
           cmpa KeyOnOrEngineRunningTime    ; compare a with memory contents
           beq  LD8F8          ; branch if equal (zero)
           inc  KeyOnOrEngineRunningTime
   LD8F8:  brset *BitFlags6e, #$%10000000, LD906    ; branch if bit(s) set
           bclr *BitFlags_36, #$%00000011    ; clear bits
           cmpa EngineRunningTimeMaxFF    ; compare a with memory contents
           beq  LD906          ; branch if equal (zero)
           inc  EngineRunningTimeMaxFF
   LD906:  ldaa TimerOverflowsBetweenCamPulses    ; load a with memory contents
           cmpa #0x02          ; compare a with value -00000010-
           bcs  LD919          ; branch if lower
           bset *BitFlags6e, #$%10010010    ; set bits
           bclr *BitFlags66, #$%00110000    ; clear bits
           bclr *BitFlags67, #$%00000010    ; clear bits
           ldaa EngineRunningTimeMaxFF    ; load a with memory contents
           staa EngineRunningTimeBeforeStall    ; store a into memory
   LD919:  ldaa Timer_AisChanges    ; load a with memory contents
           inca                ; increment a
           beq  LD920          ; branch if equal (zero)
           staa Timer_AisChanges    ; store a into memory
   LD920:  rts                 ; return from subroutine

DRB_SomethingLikeEMR_MM:
           brset *BitFlags6c, #$%00000001, LD94F    ; branch if bit(s) set
           brclr *BitFlags6c, #$%00000010, LD94F    ; branch if bit(s) clear
           brset *BitFlags6e, #$%10000000, LD94F    ; branch if bit(s) set
           sei                 ; disable interrupts
           ldaa BitFlags6a     ; load a with memory contents
           bitA #0x03          ;  -00000011-
           bne  LD94D          ; branch if not equal (not zero)
           bset *BitFlags6c, #$%00000001    ; set bits
           ldaa LB613          ; load a with memory contents (data is ff)
           inca                ; increment a
           beq  LD94D          ; branch if equal (zero)
           cmpa #0x07          ; compare a with value -00000111-
           bcs  LD944          ; branch if lower
           bset *BitFlags6c, #$%00001000    ; set bits
   LD944:  staa DRBOffsetStored_LB    ; store a into memory
           ldaa #0x13          ; load a with value -00010011-
           staa DRBOffsetStored_HB    ; store a into memory
           bset *BitFlags6a, #$%00000001    ; set bits
   LD94D:  cli                 ; enable interrupts
           nop                 ; no operation
   LD94F:  sei                 ; disable interrupts
           brset *BitFlags6a, #$%00000001, LD9A9    ; branch if bit(s) set
           ldaa LB7E1          ; load a with memory contents (data is ff)
           coma            
           cmpa LB7E0          ; compare a with memory contents (data is ff)
           beq  LD95F          ; branch if equal (zero)
           ldaA #0x08          ; load a with value -00001000-
   LD95F:  staa BodyComputerBatteryVoltsOutput    ; store a into memory
           brclr *BitFlags6c, #$%00000100, LD994    ; branch if bit(s) clear
           ldaa #0x16          ; load a with value -00010110-
           ldab #0x4a          ; load b with value -01001010-
           brclr *BitFlags6a, #$%00000010, LD98D    ; branch if bit(s) clear
           cmpa DRBOffsetStored_HB    ; compare a with memory contents
           beq  LD986          ; branch if equal (zero)
           inca                ; increment a
           cmpa DRBOffsetStored_HB    ; compare a with memory contents
           bne  LD994          ; branch if not equal (not zero)
           bset *BitFlags6a, #$%00000001    ; set bits
           bclr *BitFlags6a, #$%00000010    ; clear bits
           bclr *BitFlags6c, #$%00000100    ; clear bits
           ldaa #0x13          ; load a with value -00010011-
           clrb                ; b = 0
           stab Counter_ACControl1    ; store b into memory
           bra  LD990          ; branch

   LD986:  bset *BitFlags6a, #$%00000001    ; set bits
           inca                ; increment a
           comb            
           bra  LD990          ; branch

   LD98D:  bset *BitFlags6a, #$%00000011    ; set bits
   LD990:  staa DRBOffsetStored_HB    ; store a into memory
           stab DRBOffsetStored_LB    ; store b into memory
   LD994:  ldaa LB617          ; load a with memory contents (data is ff)
           coma            
           cmpa LB616          ; compare a with memory contents (data is ff)
           bne  LD9A6          ; branch if not equal (not zero)
           cmpa #0x4a          ; compare a with value -01001010-
           bne  LD9A6          ; branch if not equal (not zero)
           bset *BitFlags6c, #$%00000010    ; set bits
           bra  LD9A9          ; branch

   LD9A6:  bclr *BitFlags6c, #$%00000010    ; clear bits
   LD9A9:  cli                 ; enable interrupts
           brclr *BitFlags6c, #$%00001000, LD9D3    ; branch if bit(s) clear
           sei                 ; disable interrupts
           brset *BitFlags6a, #$%00000001, LD9D2    ; branch if bit(s) set
           ldaa #0x16          ; load a with value -00010110-
           ldab #0xee          ; load b with value -11101110-
           brclr *BitFlags6a, #$%00000010, LD9CB    ; branch if bit(s) clear
           cmpa DRBOffsetStored_HB    ; compare a with memory contents
           bne  LD9D2          ; branch if not equal (not zero)
           inca                ; increment a
           bset *BitFlags6a, #$%00000001    ; set bits
           bclr *BitFlags6a, #$%00000010    ; clear bits
           bclr *BitFlags6c, #$%00001000    ; clear bits
           bra  LD9CE          ; branch

   LD9CB:  bset *BitFlags6a, #$%00000011    ; set bits
   LD9CE:  staa DRBOffsetStored_HB    ; store a into memory
           stab DRBOffsetStored_LB    ; store b into memory
   LD9D2:  cli                 ; enable interrupts
   LD9D3:  rts                 ; return from subroutine

CALCULATE_RPM_SPEED_AND:
           bsr  CalculateEngineRpm    ; call subroutine
           stD *EngineRpm_HB    ; store D to RAM
           brclr *Counter_MainLoop, #$%00000011, LD9DD    ; branch if bit(s) clear
           rts                 ; return from subroutine

   LD9DD:  ldd  EngineRpm_HB_X
           subd EngineRpm_HB    ; d = d - memory contents
           bcs  LDA05          ; branch if lower
           cmpD REVTHR_EngineRPMThresholdForClearingAverageMAP    ; compare D (data is 01)
           bcs  LDA05          ; branch if lower
           ldaa CurrentWGIncrement    ; load a with memory contents
           cmpa WGITHR_WGIncrementThresholdForClearingAverageMAP    ; compare a with memory contents (data is 30)
           bcs  LDA05          ; branch if lower
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           cmpa SPDTHR_VehicleSpeedThresholdForClearingAverageMAP    ; compare a with memory contents (data is 07)
           bcs  LDA05          ; branch if lower
           ldaa MapValue       ; load a with memory contents
           suba MPATHR_MAPThresholdForClearingAverageMAP    ;  (data is 22)
           bcc  LDA03          ; branch if greater or equal
           clra                ; a = 0
   LDA03:  staa MapAverageValue_HB    ; store a into memory
   LDA05:  ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           std  EngineRpm_HB_X
           rts                 ; return from subroutine

CalculateEngineRpm:
           ldY #DistributorFallingEdgePulsewidth_HB    ; load Y index -00000000 01100001-
           ldd  #0x0727        ; load d (a&b) with value -00000111 00100111-
           ldx  #0x0e00        ; load index with value
           tst  TimerOverflowsBetweenCamPulses
           beq  CalculateVehicleSpeedOrEngineRpms    ; branch if equal (zero)
           deY                 ; decrement Y
           ldd  #DCCOR1_AdaptiveWastegateCellBelow3psi    ; load d (a&b) with value -00000000 00000111-
           ldx  #0x270e        ; load index with value
CalculateVehicleSpeedOrEngineRpms:
           pshx                ; pull index from stack
           ldX 0, Y        ; load X indexed to Y -00000000-
           fdiv            
           stx  Temp0          ; store index into memory
           pula                ; pull a from stack
           pulb                ; pull b from stack
           ldX 0, Y        ; load X indexed to Y -00000000-
           idiv            
           xgDX                ; exchange D and X
           addd Temp0          ; d = d + memory contents
           bcc  LDA37          ; branch if greater or equal
           ldd  #0xffff        ; load d (a&b) with value -11111111 11111111-
   LDA37:  rts                 ; return from subroutine

Lookup4ByteTable:
           ldY #0x0000          ; load Y index -00000000 00000000-
           ldab 0x00, X        ; load b with memory at index + value
           aby                 ; add b to y
           inx                 ; increment index (x=x+1)
           ldaB #0x04          ; load b with value -00000100-
           cmpa 0x00, X        ; compare a with memory at index + value
           bhi  LDA4B          ; branch if higher
   LDA47:  clrb                ; b = 0
           bra  LDA66          ; branch

   LDA4A:  abx                 ; add b to index
   LDA4B:  deY                 ; decrement Y
           beq  LDA47          ; branch if equal (zero)
           cmpa 0x04, X        ; compare a with memory at index + value
           bcc  LDA4A          ; branch if greater or equal
           suba 0x00, X    
           psha                ; push a onto stack
           ldab 0x02, X        ; load b with memory at index + value
           mul                 ; multiply (d=a*b)
           xgDY                ; exchange D and Y
           pula                ; pull a from stack
           ldab 0x03, X        ; load b with memory at index + value
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           tab                 ; b = a
           aby                 ; add b to y
           xgDY                ; exchange D and Y
   LDA66:  addb 0x01, X        ; add memory at index + value to b
           tba                 ; a = b
           rts                 ; return from subroutine

ScaleYbyA:
           psha                ; push a onto stack
           pshy                ; push Y onto stack
           pulb                ; pull b from stack
           mul                 ; multiply (d=a*b)
           xgDY                ; exchange D and Y
           pulb                ; pull b from stack
           pula                ; pull a from stack
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           tab                 ; b = a
           aby                 ; add b to y
           rts                 ; return from subroutine

ScaleXbyB_addingA_intoD:
           psha                ; push a onto stack
           tba                 ; a = b
           ldY 0, X        ; load Y indexed to X -00000000-
           bsr  ScaleYbyA      ; call subroutine
           pula                ; pull a from stack
           tsta                ; test a
           xgDY                ; exchange D and Y
           beq  LDA8E          ; branch if equal (zero)
           addd 0x00, X    
           bcc  LDA8E          ; branch if greater or equal
           ldd  #0xffff        ; load d (a&b) with value -11111111 11111111-
   LDA8E:  rts                 ; return from subroutine

ProcessMapOrTpsBlockData:
           ldaa 0x03, X        ; load a with memory at index + value
           bne  LDA98          ; branch if not equal (not zero)
           clrb                ; b = 0
           ldaa 0x02, X        ; load a with memory at index + value
           bra  LDAAB          ; branch

   LDA98:  ldY 0, X        ; load Y indexed to X -00000000-
           bsr  ScaleYbyA      ; call subroutine
           pshy                ; push Y onto stack
           ldd  0x02, X    
           mul                 ; multiply (d=a*b)
           tSY                 ; transfer stack to Y
           subD 0, Y       ; subtract from D indexed to Y -00000000-
           puly                ; pop Y from stack
           addd 0x00, X    
   LDAAB:  std  0x00, X        ; store d into index plus offset
           rts                 ; return from subroutine

DetermineNumberOfOverflowsBetweenCamSensorPulses_MM:
           subd LastCamFallingEdgeTime    ; d = d - memory contents
           staa Temp5          ; store a into memory
           ldaa Counter_TimerPastHalfwayBetweenCamPulses    ; load a with memory contents
           lsrd                ; shift right (d=d/2)
           eorb Temp5      
           bpl  LDAC0          ; branch if plus (hi bit 0)
           ldaa Counter_TimerPastHalfwayBetweenCamPulses    ; load a with memory contents
           inca                ; increment a
           beq  LDAC0          ; branch if equal (zero)
           staa Counter_TimerPastHalfwayBetweenCamPulses    ; store a into memory
   LDAC0:  ldaa Counter_TimerPastHalfwayBetweenCamPulses    ; load a with memory contents
           lsra            
           cmpa TimerOverflowsBetweenCamPulses    ; compare a with memory contents
           bcs  LDAC9          ; branch if lower
           staa TimerOverflowsBetweenCamPulses    ; store a into memory
   LDAC9:  rts                 ; return from subroutine

GetControlFeedback_DetermineIfShutdownRequired_MM:
           ldab SwitchPortAccessReg1    ; load b with memory contents
           bitb #0x40          ;  -01000000-
           bne  LDAD6          ; branch if not equal (not zero)
   LDAD1:  cli                 ; enable interrupts
           clr  CountdownTimerFromKeyOn    ; zero byte at memory location
           rts                 ; return from subroutine

   LDAD6:  ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           bne  LDAE4          ; branch if not equal (not zero)
           ldaa #0x17          ; load a with value -00010111-
           ldab TimerOverflowsBetweenCamPulses    ; load b with memory contents
           cmpb #0x04          ;  -00000100-
           bcs  LDAE4          ; branch if lower
           ldaA #0x09          ; load a with value -00001001-
   LDAE4:  deca                ; decrement a
           beq  LDAEA          ; branch if equal (zero)
           staa CountdownTimerFromKeyOn    ; store a into memory
           rts                 ; return from subroutine

   LDAEA:  sei                 ; disable interrupts
           bsr  ResetCopTimer    ; call subroutine
           jsr  CaculateChecksum    ; call subroutine
           sei                 ; disable interrupts
           bsr  ResetCopTimer    ; call subroutine
           jsr  CountRamValuesFrom05to3a    ; call subroutine
           stD *L0003          ; store D to RAM
           ldaa #0x20          ; load a with value -00100000-
   LDAFA:  ldab SwitchPortAccessReg1    ; load b with memory contents
           bitb #0x40          ;  -01000000-
           beq  LDAD1          ; branch if equal (zero)
           deca                ; decrement a
           bne  LDAFA          ; branch if not equal (not zero)
           bsr  ResetCopTimer    ; call subroutine
           ldaa #0x10          ; load a with value -00010000-
           tap                 ; transfer a to p
           ldd  #MINTHR_LowestSessionTPS    ; load d (a&b) with value -00000000 00000101-
           stab PIA_Ctrl_1     ; store b into memory
           staa SwitchPortAccessReg1
           ldab #0xff          ; load b with value -11111111-
           stab PortX_Control    ; store b into memory
           staa PIA_Ctrl_5
           staa SwitchPortAccessReg2
           staa CPU_SerialControlReg2
           ldd  #0x3800        ; load d (a&b) with value -00111000 00000000-
           std  CPU_OutputCompare1Mask
           ldaa #0x80          ; load a with value -10000000-
           staa CPU_HardwareTimerForceCompare
           stab CPU_OutputCompare1Mask    ; store b into memory
   LDB2E:  ldab SwitchPortAccessReg1    ; load b with memory contents
           bitb #0x40          ;  -01000000-
           beq  LDB44          ; branch if equal (zero)
           ldd  #0x55aa        ; load d (a&b) with value -01010101 10101010-
           staa CPU_ArmResetCopTimerReg
           stab CPU_ArmResetCopTimerReg    ; store b into memory
           jmp  LDB2E      

   LDB41:  jmp  LDB2E      

   LDB44:  ldaa #0x40          ; load a with value -01000000-
   LDB46:  ldab SwitchPortAccessReg1    ; load b with memory contents
           bitb #0x40          ;  -01000000-
           bne  LDB2E          ; branch if not equal (not zero)
           deca                ; decrement a
           bne  LDB46          ; branch if not equal (not zero)
           jmp  ResetInterrupt      

ResetCopTimer:
           ldaa SwitchPortAccessReg1    ; load a with memory contents
           anda #0xfd          ; AND a with value -11111101-
           staa SwitchPortAccessReg1
           ldaB #0x0a          ; load b with value -00001010-
   LDB5D:  decb            
           bne  LDB5D          ; branch if not equal (not zero)
           oraA #0x02          ;  -00000010-
           staa SwitchPortAccessReg1
           ldd  #0x55aa        ; load d (a&b) with value -01010101 10101010-
           staa CPU_ArmResetCopTimerReg
           stab CPU_ArmResetCopTimerReg    ; store b into memory
           rts                 ; return from subroutine

EmmissionMaintenanceRemider1_MM:
           sei                 ; disable interrupts
           brset *BitFlags6a, #$%00000001, LDB9A    ; branch if bit(s) set
           brset *b5c_IPL1, #$%00001000, LDB9C    ; branch if bit(s) set
           brclr *BitFlags6a, #$%00010000, LDB9A    ; branch if bit(s) clear
           bset *BitFlags6a, #$%00000001    ; set bits
           cli                 ; enable interrupts
           ldaa #0x10          ; load a with value -00010000-
           ldab #0x5a          ; load b with value -01011010-
           brclr *BitFlags6a, #$%00000010, LDB93    ; branch if bit(s) clear
           cmpa DRBOffsetStored_HB    ; compare a with memory contents
           bne  LDBF3          ; branch if not equal (not zero)
           inca                ; increment a
           comb            
           bclr *BitFlags6a, #$%00010010    ; clear bits
           bra  LDB96          ; branch

   LDB93:  bset *BitFlags6a, #$%00000010    ; set bits
   LDB96:  staa DRBOffsetStored_HB    ; store a into memory
           stab DRBOffsetStored_LB    ; store b into memory
   LDB9A:  cli                 ; enable interrupts
           rts                 ; return from subroutine

   LDB9C:  bset *BitFlags6a, #$%00000001    ; set bits
           cli                 ; enable interrupts
           brset *BitFlags6a, #$%00000010, LDC0B    ; branch if bit(s) set
           ldx  #ErrorBitRegisterStored3    ; load index with value
           ldab #0x30          ; load b with value -00110000-
   LDBA9:  ldaa 0x00, X        ; load a with memory at index + value
           beq  LDBB6          ; branch if equal (zero)
           cba             
           beq  LDBF0          ; branch if equal (zero)
           dex                 ; decrement index (x=x-1)
           cpx  #ErrorBitRegister0    ;  -00000000 00011111-
           bcc  LDBA9          ; branch if greater or equal
   LDBB6:  ldd  #0x0000         ; load d (a&b) with value -00000000 00000000-
           stD *Temp0          ; store D to RAM
           ldx  #LB600         ; load index with value
   LDBBE:  ldd  0x02, X    
           cpx  #0xb60e        ;  -10110110 00001110-
           bne  LDBC8          ; branch if not equal (not zero)
           ldd  LB600          ;  (data is ffff)
   LDBC8:  subd 0x00, X    
           subd #0x0001         ;  -00000000 00000001-
           bne  LDBDD          ; branch if not equal (not zero)
           incb            
           addd 0x00, X    
           cmpD Temp0          ; compare D
           bcs  LDBDD          ; branch if lower
           stD *Temp0          ; store D to RAM
           xgDX                ; exchange D and X
           stab DRBOffsetStored_HB    ; store b into memory
           xgDX                ; exchange D and X
   LDBDD:  inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
           cpx  #0xb610        ;  -10110110 00010000-
           bne  LDBBE          ; branch if not equal (not zero)
           ldx  Temp0      
           bne  LDBF7          ; branch if not equal (not zero)
           ldd  #0x3003        ; load d (a&b) with value -00110000 00000011-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LDBF3          ; branch if greater or equal
   LDBF0:  bclr *b5c_IPL1, #$%00001000    ; clear bits
   LDBF3:  bclr *BitFlags6a, #$%00000001    ; clear bits
           rts                 ; return from subroutine

   LDBF7:  ldab DRBOffsetStored_HB    ; load b with memory contents
   LDBF9:  addb #0x04          ;  -00000100-
           cmpb #0x10          ;  -00010000-
           blt  LDC01          ; branch if less
           subb #0x10          ;  -00010000-
   LDC01:  stab DRBOffsetStored_HB    ; store b into memory
           bsr  LDC36          ; call subroutine
           staa DRBOffsetStored_LB    ; store a into memory
           bset *BitFlags6a, #$%00000010    ; set bits
           rts                 ; return from subroutine

   LDC0B:  ldab DRBOffsetStored_HB    ; load b with memory contents
           cmpb #0x0e          ;  -00001110-
           bhi  LDBF3          ; branch if higher
           cmpb #0x00          ;  -00000000-
           bcs  LDBF3          ; branch if lower
           bsr  LDC36          ; call subroutine
           stab DRBOffsetStored_LB    ; store b into memory
           inc  DRBOffsetStored_HB
           bclr *b5c_IPL1, #$%00001000    ; clear bits
           bclr *BitFlags6a, #$%00000010    ; clear bits
           xgDX                ; exchange D and X
           cpx  #0x1c9c        ;  -00011100 10011100-
           beq  LDC32          ; branch if equal (zero)
           cpx  #0x2757        ;  -00100111 01010111-
           beq  LDC32          ; branch if equal (zero)
           cpx  #0x3938        ;  -00111001 00111000-
           bne  LDC35          ; branch if not equal (not zero)
   LDC32:  bset *BitFlags6a, #$%00010000    ; set bits
   LDC35:  rts                 ; return from subroutine

   LDC36:  ldx  #LB600         ; load index with value
           subb #0x02          ;  -00000010-
           cmpb #0x00          ;  -00000000-
           bge  LDC41          ; branch if greater or equal
           ldaB #0x0e          ; load b with value -00001110-
   LDC41:  abx                 ; add b to index
           ldx  0x00, X    
           inx                 ; increment index (x=x+1)
           bne  LDC48          ; branch if not equal (not zero)
           dex                 ; decrement index (x=x-1)
   LDC48:  xgDX                ; exchange D and X
           rts                 ; return from subroutine

EmmissionMaintenanceRemider2_MM:
           brset *Counter_MainLoop, #$%00000001, LDCBB    ; branch if bit(s) set
           brclr *BitFlags6a, #$%00000001, LDCB7    ; branch if bit(s) clear
           ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           beq  LDC5D          ; branch if equal (zero)
           ldaB #0x03          ; load b with value -00000011-
           cba             
           bcc  LDC5D          ; branch if greater or equal
           stab CountdownTimerFromKeyOn    ; store b into memory
   LDC5D:  ldaa CPU_EEPROMControlReg    ; load a with memory contents
           clrb                ; b = 0
           stab CPU_EEPROMControlReg    ; store b into memory
           ldx  #LB600         ; load index with value
           ldab DRBOffsetStored_HB    ; load b with memory contents
           abx                 ; add b to index
           tab                 ; b = a
           ldaa 0x00, X        ; load a with memory at index + value
           cmpa DRBOffsetStored_LB    ; compare a with memory contents
           beq  LDCA7          ; branch if equal (zero)
           cmpb #0x03          ;  -00000011-
           beq  LDC7C          ; branch if equal (zero)
           bcs  LDC8D          ; branch if lower
           ldab DRBOffsetStored_LB    ; load b with memory contents
           inca                ; increment a
           beq  LDC9D          ; branch if equal (zero)
   LDC7C:  brset *b5d_IPL2, #$%00001000, LDCA7    ; branch if bit(s) set
           ldd  #0x318a        ; load d (a&b) with value -00110001 10001010-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LDC8D          ; branch if greater or equal
           bset *b5d_IPL2, #$%00001000    ; set bits
           bra  LDCA7          ; branch

   LDC8D:  ldx  #LB600         ; load index with value
           ldab DRBOffsetStored_HB    ; load b with memory contents
           abx                 ; add b to index
           ldab DRBOffsetStored_LB    ; load b with memory contents
           tba                 ; a = b
           anda 0x00, X    
           sba                 ; subtract (a=a-b)
           beq  LDC9D          ; branch if equal (zero)
           ldaa #0x16          ; load a with value -00010110-
   LDC9D:  oraA #0x02          ;  -00000010-
           staa CPU_EEPROMControlReg
           stab 0x00, X    
           inca                ; increment a
           bra  LDCB8          ; branch

   LDCA7:  bclr *BitFlags6a, #$%00000001    ; clear bits
           brset *BitFlags6a, #$%00000010, LDCB7    ; branch if bit(s) set
           ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           suba #0x03          ;  -00000011-
           bne  LDCB7          ; branch if not equal (not zero)
           inca                ; increment a
           staa CountdownTimerFromKeyOn    ; store a into memory
   LDCB7:  clra                ; a = 0
   LDCB8:  staa CPU_EEPROMControlReg
   LDCBB:  rts                 ; return from subroutine

BYTE_MODE_SERIAL_CODE_DOWNLOAD_ROUTINE:
           brset *DRBSerialMode, #$%01000000, LDCC4    ; branch if bit(s) set
           rts                 ; return from subroutine

   LDCC1:  jmp  LDE64      

   LDCC4:  brset *DRBSerialMode, #$%01110000, LDCC1    ; branch if bit(s) set
           ldab CPU_SerialData    ; load b with memory contents
           ldaa CPU_SerialStatus    ; load a with memory contents
           bita #0x20          ;  -00100000-
           bne  LDCD3          ; branch if not equal (not zero)
           rts                 ; return from subroutine

   LDCD3:  ldx  #ErrorCodeCounter    ; load index with value
           ldaa 0x00, X        ; load a with memory at index + value
           bitA #0x03          ;  -00000011-
           beq  LDCDF          ; branch if equal (zero)
           jmp  LDD41      

   LDCDF:  cmpb #0xf8          ;  -11111000-
           bcc  LDCEA          ; branch if greater or equal
   LDCE3:  jsr  NULL_ROUTINE    ; call subroutine
           jsr  LDE69          ; call subroutine
           rts                 ; return from subroutine

   LDCEA:  tsta                ; test a
           bne  LDCF6          ; branch if not equal (not zero)
           cmpb #0xf8          ;  -11111000-
           bne  LDCE3          ; branch if not equal (not zero)
           ldaa #0x80          ; load a with value -10000000-
           jmp  LDE62      

   LDCF6:  cmpa #0x80          ; compare a with value -10000000-
           bne  LDD03          ; branch if not equal (not zero)
           cmpb #0xf9          ;  -11111001-
           bne  LDCE3          ; branch if not equal (not zero)
           ldaa #0xc0          ; load a with value -11000000-
           jmp  LDE62      

   LDD03:  cmpa #0xc0          ; compare a with value -11000000-
           bne  LDD10          ; branch if not equal (not zero)
           cmpb #0xfb          ;  -11111011-
           bne  LDCE3          ; branch if not equal (not zero)
           ldaa #0xe0          ; load a with value -11100000-
           jmp  LDE62      

   LDD10:  cmpa #0xe0          ; compare a with value -11100000-
           bne  LDCE3          ; branch if not equal (not zero)
           cmpb #0xf8          ;  -11111000-
           bne  LDD1D          ; branch if not equal (not zero)
           ldaA #0x02          ; load a with value -00000010-
           jmp  LDE62      

   LDD1D:  cmpb #0xf9          ;  -11111001-
           bne  LDD26          ; branch if not equal (not zero)
           ldaA #0x01          ; load a with value -00000001-
           jmp  LDE62      

   LDD26:  cmpb #0xfb          ;  -11111011-
           bne  LDCE3          ; branch if not equal (not zero)
           ldY  EngineRpm_HB    ; load Y index
           cpY  #0x0100           ; compare Y to memory 16-bit
           bhi  LDD38          ; branch if higher
           ldaA #0x05          ; load a with value -00000101-
           jmp  LDE62      

   LDD38:  ldd  #AutoCalCell6    ; load d (a&b) with value -00000000 00010111-
           jsr  LDE69          ; call subroutine
           jmp  LDE62      

   LDD41:  bitA #0x01          ;  -00000001-
           beq  LDD48          ; branch if equal (zero)
           jmp  LDD4B      

   LDD48:  jmp  LDDF7      

   LDD4B:  lsla                ; logical shift left a
           bcs  LDD9F          ; branch if lower
           lsla                ; logical shift left a
           bcs  LDD70          ; branch if lower
           lsla                ; logical shift left a
           bcs  LDD65          ; branch if lower
           lsla                ; logical shift left a
           bcs  LDD5E          ; branch if lower
           stab ByteModeVar3    ; store b into memory
           ldaa #0x10          ; load a with value -00010000-
           bra  LDD9A          ; branch

   LDD5E:  stab ByteModeVar2    ; store b into memory
           ldaa #0x20          ; load a with value -00100000-
           bra  LDD9A          ; branch

   LDD65:  ldY ByteModeVar2    ; load Y with value from memory
           ldaB 0, Y       ; load B with value indexed to Y -00000000-
           ldaa #0x40          ; load a with value -01000000-
           bra  LDD9A          ; branch

   LDD70:  cmpb #0xfe          ;  -11111110-
           beq  LDD81          ; branch if equal (zero)
   LDD74:  jsr  LDE69          ; call subroutine
           cmpb #0x1b          ;  -00011011-
           bne  LDD7E          ; branch if not equal (not zero)
           bset *DRBSerialMode, #$%01000000    ; set bits
   LDD7E:  jmp  LDE64      

   LDD81:  ldaa 0x00, X        ; load a with memory at index + value
           bitA #0x04          ;  -00000100-
           beq  LDD98          ; branch if equal (zero)
           ldY EngineRpm_HB    ; load Y index
           cpY  #0x0100           ; compare Y to memory 16-bit
           bcs  LDD98          ; branch if lower
           ldab #0x17          ; load b with value -00010111-
           jsr  LDE69          ; call subroutine
           jmp  LDE64      

   LDD98:  ldaa #0x80          ; load a with value -10000000-
   LDD9A:  oraa 0x00, X    
           jmp  LDE62      

   LDD9F:  sei                 ; disable interrupts
           ldY ByteModeVar2    ; load Y with value from memory
           cpY  #0x9400           ; compare Y to value
           bcc  LDDB7          ; branch if greater or equal
           staB 0, Y       ; store B to location indexed to Y -00000000-
   LDDAD:  ldaB 0, Y       ; load B with value indexed to Y -00000000-
           jsr  LDE69          ; call subroutine
           cli                 ; enable interrupts
           jmp  LDE64      

   LDDB7:  ldx  #0x64d0        ; load index with value
           ldY  #0xDDDA          ; load Y index -11011101 11011010-
   LDDBE:  ldaA 0, Y       ; load A indexed to Y -00000000-
           staa 0x00, X    
           inx                 ; increment index (x=x+1)
           inY                 ; increment Y
           cpY  #0xDDF7           ; compare Y to memory 16-bit (data is 48)
           bne  LDDBE          ; branch if not equal (not zero)
           ldx  #0x64d0        ; load index with value
           ldY  ByteModeVar2    ; load Y with value from memory
           jsr  0x00, X
           ldx  #ErrorCodeCounter    ; load index with value
           bra  LDDAD          ; branch

;this gets loaded into RAM and run from there?
; 	.byte	0x86,0xaa,0xb7,0xd5,0x55,0x44,0xb7,0xaa
; 	.byte	0xaa,0x86,0xa0,0xb7,0xd5,0x55,0x18,0xe7
; 	.byte	0x00,0xce,0x00,0x00,0x18,0xe1,0x00,0x27
; 	.byte	0x03,0x09,0x26,0xf8,0x39

   LDDDA:  ldaa 0x00aa
	   staa 0xd555
	   lsra
	   ldaa 0x00a0
	   staa 0xd555
	   stab 0x00, Y
	   ldx  0x0000
           cmpb 0x00, Y
           beq  LDDF6; 03
           dex
           bne  LDD7E
   LDDF6:  rts

   LDDF7:  lsla                ; logical shift left a
           bcs  LDE30          ; branch if lower
           lsla                ; logical shift left a
           bcs  LDE22          ; branch if lower
           lsla                ; logical shift left a
           bcs  LDE1B          ; branch if lower
           lsla                ; logical shift left a
           bcs  LDE14          ; branch if lower
           lsla                ; logical shift left a
           bcs  LDE0D          ; branch if lower
           stab ByteModeVar1    ; store b into memory
           ldaA #0x08          ; load a with value -00001000-
           bra  LDE2B          ; branch

   LDE0D:  stab ByteModeVar0    ; store b into memory
           ldaa #0x10          ; load a with value -00010000-
           bra  LDE2B          ; branch

   LDE14:  stab ByteModeVar3    ; store b into memory
           ldaa #0x20          ; load a with value -00100000-
           bra  LDE2B          ; branch

   LDE1B:  stab ByteModeVar2    ; store b into memory
           ldaa #0xc0          ; load a with value -11000000-
           bra  LDE2B          ; branch

   LDE22:  cmpb #0xfd          ;  -11111101-
           beq  LDE29          ; branch if equal (zero)
           jmp  LDD74      

   LDE29:  ldaa #0x80          ; load a with value -10000000-
   LDE2B:  oraa 0x00, X    
           jmp  LDE62      

   LDE30:  ldx  ByteModeVar2
           ldY ByteModeVar0    ; load Y with value from memory
           ldab CPU_SerialData    ; load b with memory contents
           ldaa 0x00, X        ; load a with memory at index + value
           staa CPU_SerialData
           inx                 ; increment index (x=x+1)
           deY                 ; decrement Y
           bne  LDE4C          ; branch if not equal (not zero)
           ldx  #ErrorCodeCounter    ; load index with value
           jsr  LDE69          ; call subroutine
           pulx                ; pull index from stack
           rts                 ; return from subroutine

   LDE4C:  stx  ByteModeVar2
           stY ByteModeVar0    ; store Y
           cba             
           bne  LDE58          ; branch if not equal (not zero)
           pulx                ; pull index from stack
           rts                 ; return from subroutine

   LDE58:  ldaa ErrorCodeCounter    ; load a with memory contents
           anda #0x7f          ; AND a with value -01111111-
           staa ErrorCodeCounter
           pulx                ; pull index from stack
           rts                 ; return from subroutine

   LDE62:  staa 0x00, X    
   LDE64:  jsr  LDE6F          ; call subroutine
           pulx                ; pull index from stack
           rts                 ; return from subroutine

   LDE69:  clr  0x00, X    
           bclr *DRBSerialMode, #$%01000000    ; clear bits
           rts                 ; return from subroutine

   LDE6F:  ldaa CPU_SerialStatus    ; load a with memory contents
           ldaa CPU_SerialData    ; load a with memory contents
           stab CPU_SerialData    ; store b into memory
           rts                 ; return from subroutine

UpdateCylTrimCounters_MM:
           clr  Temp0          ; zero byte at memory location
           brclr *b5c_IPL1, #$%01000000, LDE8A    ; branch if bit(s) clear
           bclr *Counter_CylTrim1, #$%11111111    ; clear bits
           bclr *Counter_CylTrim2, #$%11111111    ; clear bits
           bclr *BitFlags6b, #$%00010000    ; clear bits
   LDE89:  rts                 ; return from subroutine

   LDE8A:  brset *BitFlags6e, #$%10000000, LDE89    ; branch if bit(s) set
           brset *b5c_IPL1, #$%00100000, LDEEF    ; branch if bit(s) set
           brset *b5c_IPL1, #$%10000000, LDEEF    ; branch if bit(s) set
           brset *BitFlags66, #$%10000000, LDEEF    ; branch if bit(s) set
           ldaa MAPOffsetForCylTrim    ; load a with memory contents
           beq  LDEEF          ; branch if equal (zero)
           ldaa MapValue       ; load a with memory contents
           suba MAPOffsetForCylTrim
           bcs  LDEDC          ; branch if lower
           suba OFSMID_OffsetForMAPOverIdle    ;  (data is fe)
           bcs  LDED7          ; branch if lower
           ldaa Counter_CylTrim1    ; load a with memory contents
           cmpa #0x80          ; compare a with value -10000000-
           bcc  LDECC          ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x0f          ;  -00001111-
           bne  LDEF2          ; branch if not equal (not zero)
           inca                ; increment a
           staa Counter_CylTrim1    ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #CTLMC1_CylinderTrimCounter1LimitFromCoolantTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           cmpa Counter_CylTrim1    ; compare a with memory contents
           bhi  LDEF2          ; branch if higher
           bset *Counter_CylTrim1, #$%10000000    ; set bits
           bset *BitFlags6b, #$%00010000    ; set bits
   LDECC:  brclr *Counter_CylTrim1, #$%10000000, LDEF2    ; branch if bit(s) clear
           ldaa #0x41          ; load a with value -01000001-
           jsr  LDF4D          ; call subroutine
           bra  LDEF2          ; branch

   LDED7:  adda INCMID_IncrementForMAPOverIdle    ;  (data is 02)
           bpl  LDECC          ; branch if plus (hi bit 0)
   LDEDC:  inc  Temp0      
           brclr *BitFlags67, #$%01000000, LDEEF    ; branch if bit(s) clear
           clr  Temp0          ; zero byte at memory location
           bclr *Counter_CylTrim2, #$%10000000    ; clear bits
           bclr *Counter_CylTrim1, #$%10000000    ; clear bits
           bclr *BitFlags6b, #$%00010000    ; clear bits
   LDEEF:  bclr *Counter_CylTrim1, #$%01111111    ; clear bits
   LDEF2:  brset *BitFlags6b, #$%00100000, LDF49    ; branch if bit(s) set
           brset *BitFlags66, #$%10000000, LDF49    ; branch if bit(s) set
           brclr *TargetIdleSpeedHB, #$%11111111, LDF49    ; branch if bit(s) clear
           brset *BitFlags67, #$%01000000, LDF4C    ; branch if bit(s) set
           ldaa EngineRpm_HB    ; load a with memory contents
           suba TargetIdleSpeedHB
           bcs  LDF3C          ; branch if lower
           suba OFSRID_OffsetForRPMOverIdle    ;  (data is d0)
           bcs  LDF37          ; branch if lower
           ldaa Counter_CylTrim2    ; load a with memory contents
           cmpa #0x80          ; compare a with value -10000000-
           bcc  LDF2E          ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x0f          ;  -00001111-
           bne  LDF4C          ; branch if not equal (not zero)
           inca                ; increment a
           staa Counter_CylTrim2    ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #CTLMC2_CylinderTrimCounter2LimitFromCoolantTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           cmpa Counter_CylTrim2    ; compare a with memory contents
           bhi  LDF4C          ; branch if higher
           bset *Counter_CylTrim2, #$%10000000    ; set bits
           bset *BitFlags6b, #$%00010000    ; set bits
   LDF2E:  brclr *Counter_CylTrim1, #$%10000000, LDF4C    ; branch if bit(s) clear
           ldaa #0x42          ; load a with value -01000010-
           jmp  LDF4D      

   LDF37:  adda INCRID_IncrementForRPMOverIdle    ;  (data is 01)
           bpl  LDF4C          ; branch if plus (hi bit 0)
   LDF3C:  brclr *Temp0, #$%11111111, LDF49    ; branch if bit(s) clear
           bclr *Counter_CylTrim2, #$%10000000    ; clear bits
           bclr *Counter_CylTrim1, #$%10000000    ; clear bits
           bclr *BitFlags6b, #$%00010000    ; clear bits
   LDF49:  bclr *Counter_CylTrim2, #$%01111111    ; clear bits
   LDF4C:  rts                 ; return from subroutine

   LDF4D:  ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x0f          ;  -00001111-
           bne  LDF61          ; branch if not equal (not zero)
           brset *b5d_IPL2, #$%00000010, LDF61    ; branch if bit(s) set
           ldab #0xb9          ; load b with value -10111001-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LDF61          ; branch if greater or equal
           bset *b5d_IPL2, #$%00000010    ; set bits
   LDF61:  rts                 ; return from subroutine

DetectParkNeutral_MM:
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 91)
           bita #0x20          ;  -00100000-
           beq  LDF88          ; branch if equal (zero)
           brset *StartupSwitchMirror1, #sw1_PNswitch, LDF76    ; branch if bit(s) set
           brclr *BitFlags_36, #$%00001000, LDF8B    ; branch if bit(s) clear
           bclr *BitFlags_36, #$%00001000    ; clear bits
           bra  LDF7D          ; branch

   LDF76:  brset *BitFlags_36, #$%00001000, LDF8B    ; branch if bit(s) set
           bset *BitFlags_36, #$%00001000    ; set bits
   LDF7D:  bclr *BitFlags67, #$%01000000    ; clear bits
           brset *BitFlags6e, #$%10000000, LDF8B    ; branch if bit(s) set
           bset *BitFlags_36, #$%00000100    ; set bits
           rts                 ; return from subroutine

   LDF88:  bclr *BitFlags_36, #$%00001100    ; clear bits
   LDF8B:  rts                 ; return from subroutine

CycleACClutch_MM:
           brset *Counter_MainLoop, #$%00000001, LDFDE    ; branch if bit(s) set
           ldaa StartupSwitchMirror1    ; load a with memory contents
           lsra            
           ldab ACClutchToggleVar    ; load b with memory contents
           eora BitFlags68 
           bita #0x40          ;  -01000000-
           beq  LDFC9          ; branch if equal (zero)
           brclr *StartupSwitchMirror1, #sw1_bit7, LDFB4    ; branch if bit(s) clear
           cmpb #0x30          ;  -00110000-
           bcs  LDFA9          ; branch if lower
           bset *BitFlags68, #$%01000000    ; set bits
           bclr *ACClutchToggleVar, #$%00000111    ; clear bits
   LDFA9:  ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x1f          ;  -00011111-
           bne  LDFDE          ; branch if not equal (not zero)
           addb #0x08          ;  -00001000-
           bcc  LDFDC          ; branch if greater or equal
           rts                 ; return from subroutine

   LDFB4:  brclr *ACClutchToggleVar, #$%00000111, LDFBF    ; branch if bit(s) clear
           tba                 ; a = b
           andA #0x07          ; AND a with value -00000111-
           cmpa #0x05          ; compare a with value -00000101-
           bls  LDFC6          ; branch if lower or same
   LDFBF:  cmpb #0xb8          ;  -10111000-
           bcs  LDFA9          ; branch if lower
           bclr *BitFlags68, #$%01000000    ; clear bits
   LDFC6:  clrb                ; b = 0
           bra  LDFDC          ; branch

   LDFC9:  brset *ACClutchToggleVar, #$%00000111, LDFD0    ; branch if bit(s) set
           incb            
           stab ACClutchToggleVar    ; store b into memory
   LDFD0:  brset *BitFlags68, #$%01000000, LDFA9    ; branch if bit(s) set
           cmpb #0x60          ;  -01100000-
           bcs  LDFA9          ; branch if lower
           andb #0x07          ;  -00000111-
           orab #0x60          ;  -01100000-
   LDFDC:  stab ACClutchToggleVar    ; store b into memory
   LDFDE:  rts                 ; return from subroutine

; TMPAMB_TempForScaleAmbientA2D:
; 	.byte	6						; number of points
; 	.byte	0x05, 0xff, 0xfc, 0xc0	; point 1
; 	.byte	0x15, 0xcb, 0xfe, 0xf8	; point 2
; 	.byte	0x32, 0xad, 0xff, 0x83	; point 3
; 	.byte	0x6f, 0x8f, 0xff, 0x9c	; point 4
; 	.byte	0xc8, 0x6c, 0xff, 0x60	; point 5
; 	.byte	0xe8, 0x58				; point 6
; 
; TMPTL1_TempForColdScaleA2D:
; 	.byte	7						; number of points
; 	.byte	0x00, 0xd3, 0xff, 0x85	; point 1
; 	.byte	0x53, 0xab, 0xff, 0x9d	; point 2
; 	.byte	0xd7, 0x78, 0xff, 0x55	; point 3
; 	.byte	0xe6, 0x6e, 0xff, 0x17	; point 4
; 	.byte	0xf1, 0x64, 0xfe, 0xcd	; point 5
; 	.byte	0xf6, 0x5e, 0xfd, 0xab	; point 6
; 	.byte	0xff, 0x49				; point 7
; 
; TMPTL2_TempForHotScaleA2D:
; 	.byte	4						; number of points
; 	.byte	0x42, 0xff, 0xff, 0x55	; point 1
; 	.byte	0x57, 0xf1, 0xff, 0x75	; point 2
; 	.byte	0xc5, 0xb5, 0xff, 0x4f	; point 3
; 	.byte	0xff, 0x8d				; point 4

CheckAndFilterCoolantTempSensor_MM:
           sei                 ; disable interrupts
           ldaa #0x14          ; load a with value -00010100-
           staa CPU_A2DControlReg
   LE026:  ldaa CPU_A2DControlReg    ; load a with memory contents
           bpl  LE026          ; branch if plus (hi bit 0)
           ldd  CPU_A2DResults1
           stab LastChargeTempVolts    ; store b into memory
           ldab #0x10          ; load b with value -00010000-
           stab CPU_A2DControlReg    ; store b into memory
           cli                 ; enable interrupts
           ldab Timer_O2MiddleDiagnostics    ; load b with memory contents
           bne  LE042          ; branch if not equal (not zero)
           ldab Counter_MainLoop    ; load b with memory contents
           andb #0x7f          ;  -01111111-
           cmpb #0x79          ;  -01111001-
           bcc  LE045          ; branch if greater or equal
   LE042:  jmp  LE0CB      

   LE045:  bitb #0x01          ;  -00000001-
           bne  LE05A          ; branch if not equal (not zero)
           cmpb #0x7a          ;  -01111010-
           bne  LE05B          ; branch if not equal (not zero)
           sei                 ; disable interrupts
           bset *PIA_Buffer2, #pia_bit7    ; set bits
           bclr *PIA_Buffer2, #pia_CoolantTemp    ; clear bits
   LE054:  ldab PIA_Buffer2    ; load b with memory contents
           stab PortX_Control    ; store b into memory
           cli                 ; enable interrupts
   LE05A:  rts                 ; return from subroutine

   LE05B:  cmpb #0x7c          ;  -01111100-
           bne  LE067          ; branch if not equal (not zero)
           staa TempY          ; store a into memory
           sei                 ; disable interrupts
           bclr *PIA_Buffer2, #pia_bit7    ; clear bits
           bra  LE054          ; branch

   LE067:  cmpa #0xdc          ; compare a with value -11011100-
           bcs  LE075          ; branch if lower
           sei                 ; disable interrupts
           bset *PIA_Buffer2, #pia_CoolantTemp    ; set bits
           ldab PIA_Buffer2    ; load b with memory contents
           stab PortX_Control    ; store b into memory
           cli                 ; enable interrupts
   LE075:  psha                ; push a onto stack
           suba TempY      
           bhi  LE07B          ; branch if higher
           clra                ; a = 0
   LE07B:  ldab #0xff          ; load b with value -11111111-
           mul                 ; multiply (d=a*b)
           stD *Temp2          ; store D to RAM
           pulb                ; pull b from stack
           ldaa TempY          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           psha                ; push a onto stack
           pshb                ; push b onto stack
           addd Temp2          ; d = d + memory contents
           stD *Temp2          ; store D to RAM
           ldY #Temp2          ; load Y index -00000000 11111000-
           pulb                ; pull b from stack
           ldaa #0xff          ; load a with value -11111111-
           mul                 ; multiply (d=a*b)
           staa Temp1          ; store a into memory
           tba                 ; a = b
           clrb                ; b = 0
           xgDX                ; exchange D and X
           pula                ; pull a from stack
           ldab #0xff          ; load b with value -11111111-
           mul                 ; multiply (d=a*b)
           addb Temp1          ; b=b+memory contents
           adca #0x00          ;  -00000000-
           jsr  CalculateVehicleSpeedOrEngineRpms    ; call subroutine
           tstb            
           bpl  LE0A6          ; branch if plus (hi bit 0)
           inca                ; increment a
   LE0A6:  staa Temp0          ; store a into memory
           ldx  #TMPAMB_TempForScaleAmbientA2D    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           beq  LE0C8          ; branch if equal (zero)
           subb AmbientAirTempVolts    ; b = b-memory contents
           tba                 ; a = b
           bcc  LE0C0          ; branch if greater or equal
           nega                ; negate a (set high bit)
           cmpa #0x10          ; compare a with value -00010000-
           bcs  LE0C6          ; branch if lower
           ldab #0xf0          ; load b with value -11110000-
           bra  LE0C6          ; branch

   LE0C0:  cmpa #0x10          ; compare a with value -00010000-
           bcs  LE0C6          ; branch if lower
           ldab #0x10          ; load b with value -00010000-
   LE0C6:  addb AmbientAirTempVolts    ; b=b+memory contents
   LE0C8:  stab AmbientAirTempVolts    ; store b into memory
   LE0CA:  rts                 ; return from subroutine

   LE0CB:  sei                 ; disable interrupts
           staa LastCoolantTempVolts    ; store a into memory
           bclr *PIA_Buffer2, #pia_bit7    ; clear bits
           ldaa PIA_Buffer2    ; load a with memory contents
           staa PortX_Control
           cli                 ; enable interrupts
           ldab Counter_MainLoop    ; load b with memory contents
           andb #0x07          ;  -00000111-
           bne  LE0CA          ; branch if not equal (not zero)
           ldaa #0x1e          ; load a with value -00011110-
           ldab LastCoolantTempVolts    ; load b with memory contents
           cmpb TMPHIG_OutOfRangeColdTooHighA2D    ; compare b with memory contents (data is fd)
           bhi  LE133          ; branch if higher
           cmpb TMPLOW_OutOfRangeHotTooLowA2D    ; compare b with memory contents (data is 1a)
           bcs  LE134          ; branch if lower
           brclr *b5c_IPL1, #$%00000010, LE0F6    ; branch if bit(s) clear
           ldaA #0x02          ; load a with value -00000010-
           jsr  ResetErrorCodeIfTimerExpired    ; call subroutine
           bra  UseDefCoolantTemp    ; branch

   LE0F6:  tba                 ; a = b
           brclr *PIA_Buffer2, #pia_CoolantTemp, LE117    ; branch if bit(s) clear
           ldx  #TMPTL1_TempForColdScaleA2D    ; load index with value
           cmpa #0x40          ; compare a with value -01000000-
           bcc  LE11E          ; branch if greater or equal
   LE102:  ldab BitFlags69     ; load b with memory contents
           addb #0x40          ;  -01000000-
           stab BitFlags69     ; store b into memory
           bcc  LE121          ; branch if greater or equal
           ldab #pia_CoolantTemp          ; load b with value -00010000-
           sei                 ; disable interrupts
           eorb PIA_Buffer2
           stab PortX_Control    ; store b into memory
           stab PIA_Buffer2    ; store b into memory
           cli                 ; enable interrupts
           bra  LE15A          ; branch

   LE117:  ldx  #TMPTL2_TempForHotScaleA2D    ; load index with value
           cmpa #0xdc          ; compare a with value -11011100-
           bcc  LE102          ; branch if greater or equal
   LE11E:  bclr *BitFlags69, #$%11000000    ; clear bits
   LE121:  jsr  Lookup4ByteTable    ; call subroutine
           ldab CoolantTemp    ; load b with memory contents
           sba                 ; subtract (a=a-b)
           bcc  LE12C          ; branch if greater or equal
           decb            
           bra  StoreCoolantTemp    ; branch

   LE12C:  cmpa #0x03          ; compare a with value -00000011-
           bcs  LE15A          ; branch if lower
           incb            
           bra  StoreCoolantTemp    ; branch

   LE133:  inca                ; increment a
   LE134:  brset *b5c_IPL1, #$%00000010, UseDefCoolantTemp    ; branch if bit(s) set
           ldab #0x9e          ; load b with value -10011110-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LE15A          ; branch if greater or equal
           ldaa #~pia_CoolantTemp          ; load a with value -11101111-
           sei                 ; disable interrupts
           anda PIA_Buffer2    ; logical and a with memory contents
           staa PIA_Buffer2    ; store a into memory
           staa PortX_Control
           cli                 ; enable interrupts
           bset *b5c_IPL1, #$%00000010    ; set bits
           bclr *BitFlags66, #$%00010000    ; clear bits
           clra                ; a = 0
           staa Timer_CLTIME_ClosedLoopTimer    ; store a into memory
           staa Timer_ThermostatDiagnostics    ; store a into memory
UseDefCoolantTemp:
           ldab DEFTMP_DefaultEngineTemp    ; load b with memory contents (data is b2)
StoreCoolantTemp:
           stab CoolantTemp    ; store b into memory
   LE15A:  rts                 ; return from subroutine

CheckAndFilterChargeTempSensor_MM:
           ldaa #0x39          ; load a with value -00111001-
           ldab LastChargeTempVolts    ; load b with memory contents
           cmpb CHGHIG_ChargeTempOutOfRangeHigh    ; compare b with memory contents (data is fd)
           bhi  LE1A5          ; branch if higher
           cmpb CHGLOW_ChargeTempOutOfRangeLow    ; compare b with memory contents (data is 1a)
           bcs  LE1A6          ; branch if lower
           brclr *b5c_IPL1, #$%00000001, LE174    ; branch if bit(s) clear
           ldaA #0x01          ; load a with value -00000001-
           jsr  ResetErrorCodeIfTimerExpired    ; call subroutine
           bra  UseDefChargeTemp    ; branch

   LE174:  tba                 ; a = b
           brclr *PIA_Buffer2, #pia_ChargeTemp, LE18C    ; branch if bit(s) clear
           ldx  #TMPTL1_TempForColdScaleA2D    ; load index with value
           cmpa #0x40          ; compare a with value -01000000-
           bcc  LE193          ; branch if greater or equal
   LE180:  ldab #pia_ChargeTemp          ; load b with value -00100000-
           sei                 ; disable interrupts
           eorb PIA_Buffer2
           stab PortX_Control    ; store b into memory
           stab PIA_Buffer2    ; store b into memory
           cli                 ; enable interrupts
           rts                 ; return from subroutine

   LE18C:  ldx  #TMPTL2_TempForHotScaleA2D    ; load index with value
           cmpa #0xdc          ; compare a with value -11011100-
           bcc  LE180          ; branch if greater or equal
   LE193:  jsr  Lookup4ByteTable    ; call subroutine
           ldab ChargeTempVolts    ; load b with memory contents
           sba                 ; subtract (a=a-b)
           bcc  LE19E          ; branch if greater or equal
           decb            
           bra  StoreChargeTemp    ; branch

   LE19E:  cmpa #0x03          ; compare a with value -00000011-
           bcs  LE1CA          ; branch if lower
           incb            
           bra  StoreChargeTemp    ; branch

   LE1A5:  inca                ; increment a
   LE1A6:  brset *b5c_IPL1, #$%00000001, UseDefChargeTemp    ; branch if bit(s) set
           ldab #0x94          ; load b with value -10010100-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LE1CA          ; branch if greater or equal
           ldaa #~pia_ChargeTemp          ; load a with value -11011111-
           sei                 ; disable interrupts
           anda PIA_Buffer2    ; logical and a with memory contents
           staa PIA_Buffer2    ; store a into memory
           staa PortX_Control
           cli                 ; enable interrupts
           bset *b5c_IPL1, #$%00000001    ; set bits
UseDefChargeTemp:
           ldab DEFCHG_DefaultChargeTemp_Limpin    ; load b with memory contents (data is 95)
           brset *b5c_IPL1, #$%00000010, StoreChargeTemp    ; branch if bit(s) set
           ldab CoolantTemp    ; load b with memory contents
StoreChargeTemp:
           stab ChargeTempVolts    ; store b into memory
   LE1CA:  rts                 ; return from subroutine

CheckThrottleRoutine_MM:
           ldab #0x1a          ; load b with value -00011010-
           ldaa LastTPSVolts       ; load a with memory contents
           cmpa THRLOW_ThrottleLowerLimit    ; compare a with memory contents (data is 08)
           bcs  CheckThrottle_BadTpsSignal    ; branch if lower
           incb            
           cmpa THRHIG_ThrottleUpperLimit    ; compare a with memory contents (data is e4)
           bcc  CheckThrottle_BadTpsSignal    ; branch if greater or equal
           brclr *b5c_IPL1, #$%01000000, CheckThrottle_GotTpsValue    ; branch if bit(s) clear
           ldaA #0x07          ; load a with value -00000111-
           bita Counter_MainLoop
           bne  CheckThrottle_ErrorAlreadyFlagged    ; branch if not equal (not zero)
           jsr  ResetErrorCodeIfTimerExpired    ; call subroutine
           bra  CheckThrottle_ErrorAlreadyFlagged    ; branch

CheckThrottle_BadTpsSignal:
           brset *b5c_IPL1, #$%01000000, CheckThrottle_ErrorAlreadyFlagged    ; branch if bit(s) set
           brclr *Counter_MainLoop, #$%00000001, LE22C    ; branch if bit(s) clear
           tba                 ; a = b
           ldab #0xa0          ; load b with value -10100000-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LE22C          ; branch if greater or equal
           bset *b5c_IPL1, #$%01000000    ; set bits
CheckThrottle_ErrorAlreadyFlagged:
           ldaa #0x40          ; load a with value -01000000-
           staa MINTHR_LowestSessionTPS    ; store a into memory
           brset *BitFlags6e, #$%10000000, CheckThrottle_GotTpsValue    ; branch if bit(s) set
           ldab MapValue       ; load b with memory contents
           cmpb MPTHR_MapSwitchPointForFullThrottleOrIdle    ; compare b with memory contents (data is 68)
           bcs  CheckThrottle_GotTpsValue    ; branch if lower
           adda WOTDLT_DeltaThrottleFrom_MINTHR_ToDetermineFullThrottle    ;  (data is 3d)
CheckThrottle_GotTpsValue:
           staa TpsVolts       ; store a into memory
           ldab WOTDLT_DeltaThrottleFrom_MINTHR_ToDetermineFullThrottle    ; load b with memory contents (data is 3d)
           addb MINTHR_LowestSessionTPS    ; b=b+memory contents
           cmpb #0xd0          ;  -11010000-
           bls  LE21B          ; branch if lower or same
           ldab #0xd0          ; load b with value -11010000-
   LE21B:  brclr *BitFlags66, #$%00000001, LE221    ; branch if bit(s) clear
           subb #0x03          ;  -00000011-
   LE221:  cba             
           bhi  CheckThrottle_AtFullThrottle    ; branch if higher
           bclr *BitFlags66, #$%00000001    ; clear bits
           bra  LE22C          ; branch

CheckThrottle_AtFullThrottle:
           bset *BitFlags66, #$%00000001    ; set bits
   LE22C:  ldaa TpsVolts       ; load a with memory contents
           ldab BitFlags66     ; load b with memory contents
           bmi  LE253          ; branch if minus(hi bit 1)
           cmpa MINTHR_LowestSessionTPS    ; compare a with memory contents
           bcc  LE253          ; branch if greater or equal
           ldaa Timer_CountdownFromStartRunForAisFeedback    ; load a with memory contents
           bne  LE253          ; branch if not equal (not zero)
           brset *BitFlags6e, #$%10000000, LE253    ; branch if bit(s) set
           brclr *KeyOnOrEngineRunningTime, #$%11111111, LE253    ; branch if bit(s) clear
           ldaa Timer_DelayBeforeUpdating_MINTHR    ; load a with memory contents
           deca                ; decrement a
           bne  LE256          ; branch if not equal (not zero)
           ldaa MINTHR_LowestSessionTPS    ; load a with memory contents
           deca                ; decrement a
           bge  LE24F          ; branch if greater or equal
           ldaa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load a with memory contents (data is 5c)
   LE24F:  staa MINTHR_LowestSessionTPS    ; store a into memory
           andb #0xbf          ;  -10111111-
   LE253:  ldaa MAXCNT_ProgramLoopsWithThrottleBelow_MINTHR_ToDecrement_MINTHR    ; load a with memory contents (data is 10)
   LE256:  staa Timer_DelayBeforeUpdating_MINTHR    ; store a into memory
           ldaa MTHRCL_NumberOfBitsAbove_MINTHR_ToDetermineOnThrottleTransition    ; load a with memory contents (data is 02)
           tstb            
           bpl  LE261          ; branch if plus (hi bit 0)
           ldaa MTHROP_NumberOfBitsAbove_MINTHR_ToDetermineOffThrottleTransition    ; load a with memory contents (data is 01)
   LE261:  adda MINTHR_LowestSessionTPS
           cmpa TpsVolts       ; compare a with memory contents
           bcc  CheckThrottle_AtIdle    ; branch if greater or equal
           tstb            
           bmi  LE2BC          ; branch if minus(hi bit 1)
           bitb #0x40          ;  -01000000-
           bne  LE279          ; branch if not equal (not zero)
           ldaa MINTHR_LowestSessionTPS    ; load a with memory contents
           inca                ; increment a
           cmpa TpsVolts       ; compare a with memory contents
           bcc  LE279          ; branch if greater or equal
           staa MINTHR_LowestSessionTPS    ; store a into memory
           orab #0x40          ;  -01000000-
   LE279:  ldaa MapValue       ; load a with memory contents
           suba OCTAE_FakeDeltaMapIncrease    ;  (data is 02)
           bcc  LE282          ; branch if greater or equal
           ldaA MINAMP_MinimumAverageMAP          ; load a with value -00000110-
   LE282:  staa MapAverageValue_HB    ; store a into memory
           ldaa TpsVolts       ; load a with memory contents
           staa TpsAverageValue_HB    ; store a into memory
           orab #0x80          ;  -10000000-
           bra  LE2BC          ; branch

CheckThrottle_AtIdle:
           tstb            
           bpl  LE2BC          ; branch if plus (hi bit 0)
           brset *BitFlags_36, #$%01000000, LE296    ; branch if bit(s) set
           bset *BitFlags69, #$%00100000    ; set bits
   LE296:  ldx  #DLYTIM_AisDelayAfterThrottleClosesWhenMoving    ; load index with value
           stab Temp0          ; store b into memory
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           cmpa MPHREF_SwitchPointForDecelIdleAisControl    ; compare a with memory contents (data is 07)
           bhi  CheckThrottle_VehicleSpeedStillAboveDecelIdle    ; branch if higher
           inx                 ; increment index (x=x+1)
           ldaa DLYTM3_AisDelayAfterThrottleClosesWhenRpmAbove_DLYRPM    ; load a with memory contents (data is d0)
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb DLYRPM_RpmTriggerForAisDelay    ; compare b with memory contents (data is 3d)
           bcc  LE2B2          ; branch if greater or equal
CheckThrottle_VehicleSpeedStillAboveDecelIdle:
           ldaa 0x00, X        ; load a with memory at index + value
   LE2B2:  cmpa Timer_CountdownFromStartRunForAisFeedback    ; compare a with memory contents
           bls  LE2B8          ; branch if lower or same
           staa Timer_CountdownFromStartRunForAisFeedback    ; store a into memory
   LE2B8:  ldab Temp0          ; load b with memory contents
           andb #0x7f          ;  -01111111-
   LE2BC:  bitb #0x08          ;  -00001000-
           bne  LE2E1          ; branch if not equal (not zero)
           brclr *StartupSwitchMirror1, #sw1_Brake, LE2E1    ; branch if bit(s) clear
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa RPMTHR_ThrottleSelfCalibrationRpmThreshold    ; compare a with memory contents (data is 30)
           bcs  LE2E1          ; branch if lower
           ldaa MapValue       ; load a with memory contents
           cmpa MAPTHR_ThrottleSelfCalibrationMapDeltaThreshold    ; compare a with memory contents (data is 31)
           bcc  LE2E1          ; branch if greater or equal
           ldaa MINTHR_LowestSessionTPS    ; load a with memory contents
           inca                ; increment a
           cmpa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; compare a with memory contents (data is 5c)
           bcs  LE2DD          ; branch if lower
           ldaa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load a with memory contents (data is 5c)
   LE2DD:  staa MINTHR_LowestSessionTPS    ; store a into memory
           oraB #0x08          ;  -00001000-
   LE2E1:  ldaa MINTHR_LowestSessionTPS    ; load a with memory contents
           adda #0x30          ;  -00110000-
           cmpa TpsVolts       ; compare a with memory contents
           bcc  LE2EB          ; branch if greater or equal
           andb #0xf7          ;  -11110111-
   LE2EB:  stab BitFlags66     ; store b into memory
           rts                 ; return from subroutine

ConvertMAPVoltsToValue:
           staa Temp5          ; store a into memory
           ldaB MAPMULT_ScaleMAPVoltsToPresMultiplyConst          ; load b with value -00000111-
           bpl  LE2F7          ; branch if plus (hi bit 0)
           clr  Temp5          ; zero byte at memory location
   LE2F7:  mul                 ; multiply (d=a*b)
           adda Temp5      
           bcc  LE2FE          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LE2FE:  addd MAPADD_ScaleMAPVoltsToPresAddConst        ;  -00000011 01100001-
           bcc  LE305          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LE305:  rts                 ; return from subroutine

   LE306:  ldaa CPU_TimerControlReg2    ; load a with memory contents
           lsra            
           eora CPU_PortA  
           bitA #0x02          ;  -00000010-
           rts                 ; return from subroutine

Interrupt_SpeedometerSignal:
           ldd  CPU_TimerInputCapture2_Speedometer
           stD *Temp5          ; store D to RAM
           bsr  LE306          ; call subroutine
           beq  LE323          ; branch if equal (zero)
           fdiv            
           bsr  LE306          ; call subroutine
           beq  LE323          ; branch if equal (zero)
           fdiv            
           bsr  LE306          ; call subroutine
           bne  LE357          ; branch if not equal (not zero)
   LE323:  ldd  Counter_SpeedSensorInterrupt_HB    ; load d (a&b) with memory contents
           addd #0x0001         ;  -00000000 00000001-
           stD *Counter_SpeedSensorInterrupt_HB    ; store D to RAM
           bne  LE32F          ; branch if not equal (not zero)
           bset *b5c_IPL1, #$%00001000    ; set bits
   LE32F:  inc  Counter_SpeedSensorInterrupt_HB_X
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           subD #0x0640        ;  -00000110 01000000-
           ldaa BitFlags70     ; load a with memory contents
           bcc  LE359          ; branch if greater or equal
           bita #0x10          ;  -00010000-
           bne  LE343          ; branch if not equal (not zero)
           oraa #0x10          ;  -00010000-
           bra  LE35D          ; branch

   LE343:  anda #0x1f          ; AND a with value -00011111-
           oraA #0x08          ;  -00001000-
           staa BitFlags70     ; store a into memory
           clra                ; a = 0
           staa CruiseControlVar4    ; store a into memory
           staa Counter_SomethingWithCamSensor    ; store a into memory
           staa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; store a into memory
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           addd #CruiseControlVar2    ;  -00000000 01010011-
           stD *VehicleSpeed_HB    ; store D to RAM
   LE357:  bra  LE3C2          ; branch

   LE359:  bita #0x10          ;  -00010000-
           bne  LE3C8          ; branch if not equal (not zero)
   LE35D:  adda #0x20          ;  -00100000-
           bcs  LE367          ; branch if lower
           anda #0xef          ; AND a with value -11101111-
           staa BitFlags70     ; store a into memory
           bra  LE3C2          ; branch

   LE367:  staa BitFlags70     ; store a into memory
           ldab CruiseControlVar4    ; load b with memory contents
           beq  LE38A          ; branch if equal (zero)
           bitA #0x08          ;  -00001000-
           bne  LE38A          ; branch if not equal (not zero)
           ldaa #0x3a          ; load a with value -00111010-
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           cmpa #0x03          ; compare a with value -00000011-
           bcc  LE37C          ; branch if greater or equal
           ldaA #0x03          ; load a with value -00000011-
   LE37C:  tab                 ; b = a
           ldaa Counter_SomethingWithCamSensor    ; load a with memory contents
           suba CruiseControlVar4
           bcc  LE384          ; branch if greater or equal
           nega                ; negate a (set high bit)
   LE384:  sba                 ; subtract (a=a-b)
           bcs  LE38E          ; branch if lower
           bset *BitFlags70, #$%00001000    ; set bits
   LE38A:  ldab Counter_SomethingWithCamSensor    ; load b with memory contents
           stab CruiseControlVar4    ; store b into memory
   LE38E:  clra                ; a = 0
           staa Counter_SomethingWithCamSensor    ; store a into memory
           ldd  Temp5          ; load d (a&b) with memory contents
           bsr  DetermineNumberOfOverflowsBetweenSpeedoPulses_MM    ; call subroutine
           ldaa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; load a with memory contents
           lsra            
           tab                 ; b = a
           oraa TimerOverflowsBetweenSpeedoPulses    ; OR a with memory contents
           beq  LE3A5          ; branch if equal (zero)
           stab TimerOverflowsBetweenSpeedoPulses    ; store b into memory
           ldd  Temp5          ; load d (a&b) with memory contents
           subd PreviousVehicleSpeed_HB    ; d = d - memory contents
           bra  LE3B9          ; branch

   LE3A5:  ldd  Temp5          ; load d (a&b) with memory contents
           subd PreviousVehicleSpeed_HB    ; d = d - memory contents
           subd InverseVehicleSpeed_HB    ; d = d - memory contents
           beq  LE3BB          ; branch if equal (zero)
           asra            
           rorb
           asra            
           rorb            
           subd #0x0000         ;  -00000000 00000000-
           bne  LE3B7          ; branch if not equal (not zero)
           incb            
   LE3B7:  addd InverseVehicleSpeed_HB    ; d = d + memory contents
   LE3B9:  stD *InverseVehicleSpeed_HB    ; store D to RAM
   LE3BB:  ldd  Temp5          ; load d (a&b) with memory contents
           stD *PreviousVehicleSpeed_HB    ; store D to RAM
           clra                ; a = 0
           staa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; store a into memory
   LE3C2:  ldaA #0x02          ; load a with value -00000010-
           staa CPU_TimerInterruptFlag1
           rti                 ; return from interrupt

   LE3C8:  anda #0xef          ; AND a with value -11101111-
           staa BitFlags70     ; store a into memory
           ldaA #0x01          ; load a with value -00000001-
           staa TimerOverflowsBetweenSpeedoPulses    ; store a into memory
           ldd  #0x1940        ; load d (a&b) with value -00011001 01000000-
           bra  LE3B9          ; branch

DetermineNumberOfOverflowsBetweenSpeedoPulses_MM:
           subd PreviousVehicleSpeed_HB    ; d = d - memory contents
           staa Temp7          ; store a into memory
           ldaa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; load a with memory contents
           lsrd                ; shift right (d=d/2)
           eorb Temp7      
           bpl  LE3F0          ; branch if plus (hi bit 0)
           ldaa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; load a with memory contents
           inca                ; increment a
           beq  LE3E7          ; branch if equal (zero)
           staa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; store a into memory
   LE3E7:  ldaa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; load a with memory contents
           lsra            
           cmpa TimerOverflowsBetweenSpeedoPulses    ; compare a with memory contents
           bls  LE3F0          ; branch if lower or same
           staa TimerOverflowsBetweenSpeedoPulses    ; store a into memory
   LE3F0:  rts                 ; return from subroutine

ControlCruiseServo1_MM:
           brclr *BitFlags70, #$%00010000, LE406    ; branch if bit(s) clear
           sei                 ; disable interrupts
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           stD *Temp0          ; store D to RAM
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           subd Temp0          ; d = d - memory contents
           stD *VehicleSpeed_HB    ; store D to RAM
           cli                 ; enable interrupts
   LE406:  ldaa Timer_CountdownFromStartRunForAisFeedback    ; load a with memory contents
           beq  LE41C          ; branch if equal (zero)
           brclr *BitFlags6e, #$%00100000, LE415    ; branch if bit(s) clear
           clra                ; a = 0
           ldx  EngineRpm_HB
           cpx  TargetIdleSpeedHB
           bls  LE418          ; branch if lower or same
   LE415:  ldaa Timer_CountdownFromStartRunForAisFeedback    ; load a with memory contents
           deca                ; decrement a
   LE418:  staa Timer_CountdownFromStartRunForAisFeedback    ; store a into memory
           bra  LE41F          ; branch

   LE41C:  bset *BitFlags6e, #$%00100000    ; set bits
   LE41F:  brclr *BitFlags66, #$%10000000, LE427    ; branch if bit(s) clear
   LE423:  bclr *BitFlags67, #$%01001000    ; clear bits
           rts                 ; return from subroutine

   LE427:  ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           ldab MPHREF_SwitchPointForDecelIdleAisControl    ; load b with memory contents (data is 07)
           brset *BitFlags67, #$%00001000, LE43C    ; branch if bit(s) set
           brset *BitFlags67, #$%01000000, LE43C    ; branch if bit(s) set
           addb #0x03          ;  -00000011-
   LE43C:  cba             
           bls  LE423          ; branch if lower or same
           ldab CONFIG_ConfigurationFlags    ; load b with memory contents (data is 91)
           bitb #0x20          ;  -00100000-
           bne  LE46B          ; branch if not equal (not zero)
           ldab AISMPH_RollingAisMaxSpeed    ; load b with memory contents (data is 10)
           brclr *BitFlags67, #$%00001000, LE44F    ; branch if bit(s) clear
           addb #0x03          ;  -00000011-
   LE44F:  cba             
           bhi  LE46B          ; branch if higher
           ldd  TargetIdleSpeedHB    ; load d (a&b) with memory contents
           addd RPMDLT_RollingAisMinRpm    ;  (data is 07)
           cmpD EngineRpm_HB    ; compare D
           bcs  LE46B          ; branch if lower
           brset *BitFlags67, #$%00001000, LE464    ; branch if bit(s) set
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           stD *TargetIdleSpeedHB    ; store D to RAM
   LE464:  bclr *BitFlags67, #$%01000000    ; clear bits
           bset *BitFlags67, #$%00001000    ; set bits
           rts                 ; return from subroutine

   LE46B:  bset *BitFlags67, #$%01000000    ; set bits
           bclr *BitFlags67, #$%00001000    ; clear bits
           rts                 ; return from subroutine

LE472:
           .byte 0x15, 0x50, 0xa1, 0xff
           ; these are the analog caomparison values for each switch state

ControlCruiseServo0_MM:
           ldaa #0x10          ; load a with value -00010000-
           tab                 ; b = a
           sei                 ; disable interrupts
           staa CPU_A2DControlReg
   LE47D:  ldaa CPU_A2DControlReg    ; load a with memory contents
           bpl  LE47D          ; branch if plus (hi bit 0)
           ldaa CPU_A2DResults2    ; load a with memory contents
           staa Temp0          ; store a into memory
           ldaa #0x14          ; load a with value -00010100-
           staa CPU_A2DControlReg
   LE48C:  ldaa CPU_A2DControlReg    ; load a with memory contents
           bpl  LE48C          ; branch if plus (hi bit 0)
           ldaa CPU_A2DResults4    ; load a with memory contents
           stab CPU_A2DControlReg    ; store b into memory
           cli                 ; enable interrupts
           staa CruiseControlSwitchStateAnalog        ; store a into memory
           clra                ; a = 0
           ldab Temp0          ; load b with memory contents
           beq  LE4AC          ; branch if equal (zero)
           xgDX                ; exchange D and X
           ldaa CruiseControlSwitchStateAnalog        ; load a with memory contents
           ldab #0xff          ; load b with value -11111111-
           mul                 ; multiply (d=a*b)
           idiv            
           xgDX                ; exchange D and X
           tsta                ; test a
           beq  LE4AC          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   LE4AC:  stab CruiseControlSwitchStateAnalogSnapshot    ; store b into memory
           tba                 ; a = b
           ldab #0xff          ; load b with value -11111111-
           ldx  #LE472-1
   LE4B5:  incb
           inx                 ; increment index (x=x+1)
           cmpa 0x00, X        ; compare a with memory at index + value
           bhi  LE4B5          ; branch if higher
           ldaa CruiseControlSwitchStateDigital          ; load a with memory contents
           andA #0x03          ; AND a with value -00000011-
           cba             
           bne  LE4CA          ; branch if not equal (not zero)
           ldab CruiseControlSwitchStateDigital          ; load b with memory contents
           addb #0x20          ;  -00100000-
           bcs  LE4CF          ; branch if lower
   LE4CA:  stab CruiseControlSwitchStateDigital          ; store b into memory
           bra  LE4F1          ; branch

   LE4CF:  bitb #0x03          ;  -00000011-
           beq  LE4E8          ; branch if equal (zero)
           bset *StartupSwitchMirror1, #sw1_CruiseOnOff    ; set bits
           bitb #0x02          ;  -00000010-
           beq  LE4EB          ; branch if equal (zero)
           bitb #0x01          ;  -00000001-
           bne  LE4E3          ; branch if not equal (not zero)
           bset *StartupSwitchMirror1, #sw1_CruiseResume | sw1_CruiseSet    ; set bits
           bra  LE4F1          ; branch

   LE4E3:  bclr *StartupSwitchMirror1, #sw1_CruiseResume | sw1_CruiseSet    ; clear bits
           bra  LE4F1          ; branch

   LE4E8:  bclr *StartupSwitchMirror1, #sw1_CruiseOnOff    ; clear bits
   LE4EB:  bclr *StartupSwitchMirror1, #sw1_CruiseResume    ; clear bits
           bset *StartupSwitchMirror1, #sw1_CruiseSet    ; set bits

; from here, the CC routine is the same as the earlier code...
   LE4F1:  ldaa TimerOverflowsBetweenCamPulses    ; load a with memory contents
           bne  LE50B          ; branch if not equal (not zero)
           ldab CruiseControlSpeedRef    ; load b with memory contents
           ldaa DistributorFallingEdgePulsewidth_HB    ; load a with memory contents
           mul                 ; multiply (d=a*b)
           xgDY                ; exchange D and Y
           ldaa #0x11          ; load a with value -00010001-
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           tsta                ; test a
           beq  LE508          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   LE508:  stab ScaledDistPWForCruiseControl    ; store b into memory
   LE50B:  bclr *Counter_Cruise_1, #$%00001111    ; clear bits
           brset *StartupSwitchMirror1, #sw1_CruiseOnOff, LE517    ; branch if bit(s) set
           clrb                ; b = 0
           stab CruiseSpeedSetpoint    ; store b into memory
           bra  LE56F          ; branch

   LE517:  inc  Counter_Cruise_1
           ldaa CruiseControlSpeedRef    ; load a with memory contents
           cmpa CRUZ21_UknownConstForCruiseControl21    ; compare a with memory contents (data is 3c)
           bcs  LE567          ; branch if lower
           inc  Counter_Cruise_1
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa CRUZ22_UknownConstForCruiseControl22    ; compare a with memory contents (data is bc)
           bcc  LE567          ; branch if greater or equal
           inc  Counter_Cruise_1
           brset *StartupSwitchMirror1, #sw1_Brake, LE567    ; branch if bit(s) set
           inc  Counter_Cruise_1
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 91)
           bita #0x20          ;  -00100000-
           beq  LE548          ; branch if equal (zero)
           brclr *StartupSwitchMirror1, #sw1_PNswitch, LE567    ; branch if bit(s) clear
           inc  Counter_Cruise_1
           inc  Counter_Cruise_1
           bra  LE5A3          ; branch

   LE548:  inc  Counter_Cruise_1
           ldaa TimerOverflowsBetweenCamPulses    ; load a with memory contents
           bne  LE55C          ; branch if not equal (not zero)
           ldab ScaledDistPWForCruiseControl    ; load b with memory contents
           cmpb SCNVHI_CruiseControlForBrakeFlagManualTransmissionClutchDisableHi    ; compare b with memory contents (data is ff)
           bcc  LE567          ; branch if greater or equal
           cmpb SCNVLO_CruiseControlForBrakeFlagManualTransmissionClutchDisableLo    ; compare b with memory contents (data is 52)
           bcs  LE567          ; branch if lower
   LE55C:  inc  Counter_Cruise_1
           brset *CruiseStatus_1, #$%10000000, LE5A3    ; branch if bit(s) set
           brclr *BitFlags70, #$%00001000, LE5A3    ; branch if bit(s) clear
   LE567:  brclr *CruiseStatus_1, #$%00011000, LE56F    ; branch if bit(s) clear
           ldaa CruiseControlSpeedRef    ; load a with memory contents
           staa CruiseSpeedSetpoint    ; store a into memory
   LE56F:  brset *CruiseStatus_1, #$%10000000, LE57C    ; branch if bit(s) set
           ldab Counter_Cruise_1    ; load b with memory contents
           andb #0x0f          ;  -00001111-
           ldaa #0x11          ; load a with value -00010001-
           mul                 ; multiply (d=a*b)
   LE57A:  stab Counter_Cruise_1    ; store b into memory
   LE57C:  clrb                ; b = 0
           stab Counter_Cruise_2    ; store b into memory
           stab Counter_Cruise_3    ; store b into memory
           stab CruiseControlVar0    ; store b into memory
           stab Counter_Cruise    ; store b into memory
           stab CruiseControlVar6    ; store b into memory
           stab CruiseControlVar2    ; store b into memory
           bclr *CruiseStatus_1, #$%00011111    ; clear bits
           bset *CruiseStatus_1, #$%10100000    ; set bits
           bclr *CruiseStatus_2, #$%00001111    ; clear bits
           brset *StartupSwitchMirror1, #sw1_CruiseOnOff, LE59D    ; branch if bit(s) set
           ldaa CRUZ7_UknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           bita #0x80          ;  -10000000-
           bne  LE5A0          ; branch if not equal (not zero)
   LE59D:  bset *Counter_Cruise_2, #$%10000000    ; set bits
   LE5A0:  jmp  LE784      

   LE5A3:  inc  Counter_Cruise_1
           brset *CruiseStatus_1, #$%01000000, LE567    ; branch if bit(s) set
           ldab CCDFlags4      ; load b with memory contents
           eorb CCDFlags3  
           andb #0xc0          ;  -11000000-
           beq  LE601          ; branch if equal (zero)
           tba                 ; a = b
           eorb CCDFlags4  
           staa Temp1          ; store a into memory
           andb Temp1      
           stab Temp1          ; store b into memory
           beq  LE5EC          ; branch if equal (zero)
           brset *CruiseStatus_1, #$%10000000, LE5E0    ; branch if bit(s) set
           ldd  #0x0f89        ; load d (a&b) with value -00001111 10001001-
           jsr  ThrowNonCriticalError    ; call subroutine
           ldd  #0x0f08        ; load d (a&b) with value -00001111 00001000-
           ldx  #ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB    ; load index with value
           cmpa 0x00, X        ; compare a with memory at index + value
           beq  LE5D6          ; branch if equal (zero)
           inx                 ; increment index (x=x+1)
           cmpa 0x00, X        ; compare a with memory at index + value
           bne  LE601          ; branch if not equal (not zero)
   LE5D6:  cmpb 0x02, X    
           bne  LE601          ; branch if not equal (not zero)
           clr  0x00, X    
           clr  0x02, X    
           bra  LE5FE          ; branch

   LE5E0:  ldaa #0x7f          ; load a with value -01111111-
           brset *Temp1, #$%11000000, LE5E8    ; branch if bit(s) set
           ldaA #0x07          ; load a with value -00000111-
   LE5E8:  bita Counter_MainLoop
           bne  LE5FE          ; branch if not equal (not zero)
   LE5EC:  pshb                ; push b onto stack
           ldd  #0x0f90        ; load d (a&b) with value -00001111 10010000-
           jsr  ThrowNonCriticalError    ; call subroutine
           pulb                ; pull b from stack
           bcs  LE5FB          ; branch if lower
           tstb            
           beq  LE601          ; branch if equal (zero)
           bra  LE5FE          ; branch

   LE5FB:  bset *CruiseStatus_1, #$%01000000    ; set bits
   LE5FE:  jmp  LE567      

   LE601:  inc  Counter_Cruise_1
           ldaa CRUZ7_UknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           bita #0x80          ;  -10000000-
           beq  LE613          ; branch if equal (zero)
           brset *CruiseStatus_1, #$%00000001, LE613    ; branch if bit(s) set
           brclr *StartupSwitchMirror1, #sw1_CruiseResume, LE67C    ; branch if bit(s) clear
   LE613:  brset *StartupSwitchMirror1, #sw1_CruiseSet, LE67C    ; branch if bit(s) set
           ldab Counter_Cruise_2    ; load b with memory contents
           incb            
           bne  LE61D          ; branch if not equal (not zero)
           decb            
   LE61D:  stab Counter_Cruise_2    ; store b into memory
           brset *CruiseStatus_1, #$%00000001, LE645    ; branch if bit(s) set
           brset *Counter_Cruise_2, #$%10000000, LE658    ; branch if bit(s) set
           cmpb #0x00          ;  -00000000-
           bls  LE658          ; branch if lower or same
           bset *CruiseStatus_1, #$%00100001    ; set bits
           bclr *CruiseStatus_1, #$%00001010    ; clear bits
           bset *CruiseStatus_2, #$%00000100    ; set bits
           clra                ; a = 0
           staa Counter_Cruise_3    ; store a into memory
           staa CruiseControlVar0    ; store a into memory
           ldaa CRUZ7_UknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           bita #0x80          ;  -10000000-
           bne  LE658          ; branch if not equal (not zero)
           bclr *CruiseStatus_1, #$%00000100    ; clear bits
           bra  LE658          ; branch

   LE645:  brset *CruiseStatus_1, #$%10000000, LE658    ; branch if bit(s) set
           brset *CruiseStatus_1, #$%00010000, LE66A    ; branch if bit(s) set
           ldaa CRUZ7_UknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           bita #0x80          ;  -10000000-
           beq  LE65B          ; branch if equal (zero)
           cmpb #0x38          ;  -00111000-
           bhi  LE660          ; branch if higher
   LE658:  jmp  LE871      

   LE65B:  cmpb CRUZ46_UknownConstForCruiseControl46    ; compare b with memory contents (data is 00)
           bls  LE658          ; branch if lower or same
   LE660:  bset *CruiseStatus_1, #$%00010000    ; set bits
           bclr *CruiseStatus_2, #$%00000011    ; clear bits
           ldaa CruiseControlSpeedRef    ; load a with memory contents
           staa CruiseControlVar0    ; store a into memory
   LE66A:  ldab CruiseStatus_2    ; load b with memory contents
           cmpb #0xa0          ;  -10100000-
           bcs  LE658          ; branch if lower
           ldab CruiseControlVar0    ; load b with memory contents
           subb CRUZ32_UknownConstForCruiseControl32    ; subtract memory contents from b (data is 08)
           bcc  LE678          ; branch if greater or equal
           clrb                ; b = 0
   LE678:  stab CruiseControlVar0    ; store b into memory
           bra  LE658          ; branch

   LE67C:  brclr *CruiseStatus_1, #$%00000001, LE6E7    ; branch if bit(s) clear
           ldaa #0x7f          ; load a with value -01111111-
           brset *CruiseStatus_1, #$%10000000, LE6BD    ; branch if bit(s) set
           brset *CruiseStatus_2, #$%00001000, LE694    ; branch if bit(s) set
           ldab CruiseSpeedSetpoint    ; load b with memory contents
           subb CruiseControlSpeedRef    ; b = b-memory contents
           bcc  LE694          ; branch if greater or equal
           cmpb #0xfc          ;  -11111100-
           bcs  LE6BD          ; branch if lower
   LE694:  brset *CruiseStatus_1, #$%00010000, LE6A2    ; branch if bit(s) set
           ldaa CRUZ7_UknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           anda #0x80          ; AND a with value -10000000-
           beq  LE6C3          ; branch if equal (zero)
           jmp  LE750      

   LE6A2:  ldaa Counter_Cruise_3    ; load a with memory contents
           ldab CRUZ31_UknownConstForCruiseControl31    ; load b with memory contents (data is 34)
           addb #0x80          ;  -10000000-
           bmi  LE6B2          ; branch if minus(hi bit 1)
           mul                 ; multiply (d=a*b)
           adca Counter_Cruise_3
           bcs  LE6B9          ; branch if lower
           bra  LE6B5          ; branch

   LE6B2:  mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
   LE6B5:  cmpa #0x7f          ; compare a with value -01111111-
           bls  LE6C3          ; branch if lower or same
   LE6B9:  ldaa #0x7f          ; load a with value -01111111-
           bra  LE6C3          ; branch

   LE6BD:  bset *CruiseStatus_2, #$%00000001    ; set bits
           clrb                ; b = 0
           stab CruiseControlVar6    ; store b into memory
   LE6C3:  ldab CruiseControlSpeedRef    ; load b with memory contents
           stab CruiseSpeedSetpoint    ; store b into memory
           staa Temp2          ; store a into memory
           jsr  LEB66          ; call subroutine
           ldab Temp2          ; load b with memory contents
           cba             
           bhi  LE6D2          ; branch if higher
           tab                 ; b = a
   LE6D2:  bclr *CruiseStatus_1, #$%10010001    ; clear bits
           bclr *CruiseStatus_2, #$%00001000    ; clear bits
           bclr *BitFlags70, #$%00001000    ; clear bits
           clra                ; a = 0
           staa Counter_Cruise_3    ; store a into memory
           staa Counter_Cruise_2    ; store a into memory
           staa CruiseControlVar0    ; store a into memory
           staa Counter_Cruise    ; store a into memory
           jmp  LE784      

   LE6E7:  clrb                ; b = 0
           stab Counter_Cruise_2    ; store b into memory
           brset *StartupSwitchMirror1, #sw1_CruiseResume, LE6F1    ; branch if bit(s) set
           jmp  LE7FB      

   LE6F1:  ldab Counter_Cruise_3    ; load b with memory contents
           incb            
           bne  LE6F7          ; branch if not equal (not zero)
           decb            
   LE6F7:  stab Counter_Cruise_3    ; store b into memory
           brclr *CruiseStatus_1, #$%00000010, LE700    ; branch if bit(s) clear
           jmp  LE7A7      

   LE700:  brclr *CruiseStatus_1, #$%00100000, LE707    ; branch if bit(s) clear
           jmp  LE852      

   LE707:  cmpb #0x00          ;  -00000000-
           bhi  LE70E          ; branch if higher
           jmp  LE871      

   LE70E:  bset *CruiseStatus_1, #$%00000110    ; set bits
           bset *CruiseStatus_2, #$%00000100    ; set bits
           clra                ; a = 0
           staa Counter_Cruise    ; store a into memory
           brclr *CruiseStatus_1, #$%10000000, LE750    ; branch if bit(s) clear
           bset *CruiseStatus_1, #$%00100000    ; set bits
           bclr *CruiseStatus_1, #$%10000000    ; clear bits
           bclr *BitFlags70, #$%00001000    ; clear bits
           jsr  LEB66          ; call subroutine
           staa Temp2          ; store a into memory
           ldaa CruiseSpeedSetpoint    ; load a with memory contents
           suba CruiseControlSpeedRef
           bcc  LE732          ; branch if greater or equal
           tab                 ; b = a
           eorb #0x80          ;  -10000000-
   LE732:  bpl  LE739          ; branch if plus (hi bit 0)
           lsla                ; logical shift left a
           ldaa #0x80          ; load a with value -10000000-
           sbca #0x00          ;  -00000000-
   LE739:  adda #0x80          ;  -10000000-
           ldx  #RESTBL2_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference2        ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           addb #0x80          ;  -10000000-
           addb Temp2          ; b=b+memory contents
           bpl  LE795          ; branch if plus (hi bit 0)
           bvc  LE74D          ; branch if overflow
           ldab #0x7f          ; load b with value -01111111-
           bra  LE795          ; branch

   LE74D:  clrb                ; b = 0
           bra  LE795          ; branch

   LE750:  bclr *CruiseStatus_2, #$%00000011    ; clear bits
           ldab CruiseControlVar3    ; load b with memory contents
           ldaa CRUZ7_UknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           bita #0x40          ;  -01000000-
           bne  LE77A          ; branch if not equal (not zero)
           ldaa CruiseSpeedSetpoint    ; load a with memory contents
           adda #0x04          ;  -00000100-
           staa CruiseSpeedSetpoint    ; store a into memory
           suba #0x03          ;  -00000011-
           cmpa MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; compare a with memory contents (data is aa)
           bhi  LE77A          ; branch if higher
           ldab CRUZ23_UknownConstForCruiseControl23    ; load b with memory contents (data is 03)
           ldaa CruiseControlVar3    ; load a with memory contents
           bmi  LE77A          ; branch if minus(hi bit 1)
           aba                 ; a=a+b
           bcs  LE777          ; branch if lower
           cmpa #0x7f          ; compare a with value -01111111-
           bls  LE779          ; branch if lower or same
   LE777:  ldaa #0x7f          ; load a with value -01111111-
   LE779:  tab                 ; b = a
   LE77A:  ldaa CRUZ7_UknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           bita #0x80          ;  -10000000-
           beq  LE784          ; branch if equal (zero)
           jmp  LE6D2      

   LE784:  ldaa CruiseSpeedSetpoint    ; load a with memory contents
           beq  LE797          ; branch if equal (zero)
           cmpa MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; compare a with memory contents (data is aa)
           bls  LE79A          ; branch if lower or same
           bclr *CruiseStatus_2, #$%00000011    ; clear bits
           ldaa MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; load a with memory contents (data is aa)
           staa CruiseSpeedSetpoint    ; store a into memory
   LE795:  stab CruiseControlVar3    ; store b into memory
   LE797:  jmp  LE871      

   LE79A:  cmpa MINSET_CruiseControlMinSetSpeedTimesTwo    ; compare a with memory contents (data is 46)
           bcc  LE795          ; branch if greater or equal
           clra                ; a = 0
           staa CruiseSpeedSetpoint    ; store a into memory
           ldab #0x11          ; load b with value -00010001-
           jmp  LE57A      

   LE7A7:  brset *CruiseStatus_1, #$%00100000, LE797    ; branch if bit(s) set
           brset *CruiseStatus_1, #$%00001000, LE7C5    ; branch if bit(s) set
           cmpb CRUZ47_UknownConstForCruiseControl47    ; compare b with memory contents (data is 2f)
           bls  LE797          ; branch if lower or same
           bset *CruiseStatus_1, #$%00001000    ; set bits
           bset *CruiseStatus_2, #$%00001000    ; set bits
           ldaa CruiseControlSpeedRef    ; load a with memory contents
           adda CRUZ34_UknownConstForCruiseControl34    ;  (data is 20)
           bcc  LE7C3          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LE7C3:  staa CruiseControlVar0    ; store a into memory
   LE7C5:  ldaa CruiseControlSpeedRef    ; load a with memory contents
           cmpa MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; compare a with memory contents (data is aa)
           bcs  LE7D3          ; branch if lower
           bset *CruiseStatus_1, #$%00100000    ; set bits
           ldab CruiseControlVar3    ; load b with memory contents
           bra  LE83C          ; branch

   LE7D3:  ldab CruiseStatus_2    ; load b with memory contents
           cmpb #0xa0          ;  -10100000-
           bcs  LE797          ; branch if lower
           ldab CruiseControlVar0    ; load b with memory contents
           subb CRUZ33_UknownConstForCruiseControl33    ; subtract memory contents from b (data is 01)
           bcc  LE7E1          ; branch if greater or equal
           clrb                ; b = 0
   LE7E1:  cmpb MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; compare b with memory contents (data is aa)
           bcc  LE7F7          ; branch if greater or equal
           adda CRUZ35_UknownConstForCruiseControl35    ;  (data is 0c)
           bcs  LE7F4          ; branch if lower
           cba             
           bls  LE7F7          ; branch if lower or same
           tab                 ; b = a
           cmpb MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; compare b with memory contents (data is aa)
           bls  LE7F7          ; branch if lower or same
   LE7F4:  ldab MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; load b with memory contents (data is aa)
   LE7F7:  stab CruiseControlVar0    ; store b into memory
           bra  LE797          ; branch

   LE7FB:  bclr *CruiseStatus_1, #$%00000010    ; clear bits
           brset *CruiseStatus_1, #$%10000000, LE809    ; branch if bit(s) set
           ldaa CRUZ7_UknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           bita #0x80          ;  -10000000-
           bne  LE852          ; branch if not equal (not zero)
   LE809:  ldaa CruiseSpeedSetpoint    ; load a with memory contents
           beq  LE810          ; branch if equal (zero)
           bclr *CruiseStatus_1, #$%00100000    ; clear bits
   LE810:  brclr *CruiseStatus_1, #$%00001000, LE852    ; branch if bit(s) clear
           ldaa CRUZ7_UknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           bita #0x40          ;  -01000000-
           bne  LE82B          ; branch if not equal (not zero)
           ldaa Counter_Cruise_3    ; load a with memory contents
           cmpa #0x5d          ; compare a with value -01011101-
           bhi  LE82B          ; branch if higher
           bclr *CruiseStatus_1, #$%00001000    ; clear bits
           bclr *CruiseStatus_2, #$%00001000    ; clear bits
           stab CruiseControlVar0    ; store b into memory
           bra  LE852          ; branch

   LE82B:  ldaa CruiseControlSpeedRef    ; load a with memory contents
           adda #0x04          ;  -00000100-
           suba CruiseSpeedSetpoint
           bcc  LE834          ; branch if greater or equal
           clra                ; a = 0
   LE834:  ldx  #CRUZ6_UknownTableForCruiseControl6        ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           orab #0x80          ;  -10000000-
   LE83C:  ldaa CruiseControlSpeedRef    ; load a with memory contents
           staa CruiseSpeedSetpoint    ; store a into memory
           bclr *CruiseStatus_1, #$%00001100    ; clear bits
           bclr *CruiseStatus_2, #$%00001000    ; clear bits
           clra                ; a = 0
           staa CruiseControlVar0    ; store a into memory
           staa Counter_Cruise_3    ; store a into memory
           tstb            
           bmi  LE84F          ; branch if minus(hi bit 1)
           clrb                ; b = 0
   LE84F:  jmp  LE784      

   LE852:  clrb                ; b = 0
           stab Counter_Cruise_3    ; store b into memory
           ldaa CruiseStatus_2    ; load a with memory contents
           eora #0x04          ; XOR a with value -00000100-
           bitA #0x07          ;  -00000111-
           bne  LE871          ; branch if not equal (not zero)
           ldaa Counter_MainLoop    ; load a with memory contents
           bne  LE871          ; branch if not equal (not zero)
           ldab Counter_Cruise    ; load b with memory contents
           incb            
           cmpb CRUZ26_UknownConstForCruiseControl26    ; compare b with memory contents (data is 02)
           bcs  LE86D          ; branch if lower
           bclr *CruiseStatus_2, #$%00000100    ; clear bits
           clrb                ; b = 0
   LE86D:  stab Counter_Cruise    ; store b into memory
           bra  LE871          ; branch

   LE871:  brset *CruiseStatus_1, #$%10000000, LE886    ; branch if bit(s) set
           inc  Counter_Cruise_1
           brclr *CruiseStatus_1, #$%00011000, LE886    ; branch if bit(s) clear
           inc  Counter_Cruise_1
           brset *CruiseStatus_1, #$%00001000, LE886    ; branch if bit(s) set
           inc  Counter_Cruise_1
   LE886:  ldaa CruiseStatus_2    ; load a with memory contents
           adda #0x10          ;  -00010000-
           cmpa #0xb0          ; compare a with value -10110000-
           bcs  LE890          ; branch if lower
           andA #0x0f          ; AND a with value -00001111-
   LE890:  staa CruiseStatus_2    ; store a into memory
           anda #0xf0          ; AND a with value -11110000-
           beq  LE899          ; branch if equal (zero)
           jmp  LEB2D      

   LE899:  clrb                ; b = 0
           brclr *BitFlags70, #$%00010000, LE8A1    ; branch if bit(s) clear
           jmp  LE98A      

   LE8A1:  ldY #InverseVehicleSpeed_HB    ; load Y index -00000000 01001010-
           ldx  #0xd000        ; load index with value
           ldd  #0x06dd        ; load d (a&b) with value -00000110 11011101-
           brclr *TimerOverflowsBetweenSpeedoPulses, #$%11111111, LE8BD    ; branch if bit(s) clear
           ldd  #0x0000         ; load d (a&b) with value -00000000 00000000-
           brset *TimerOverflowsBetweenSpeedoPulses, #$%01000000, LE8C0    ; branch if bit(s) set
           ldaB #0x06          ; load b with value -00000110-
           deY                 ; decrement Y
           ldx  #0xddd0        ; load index with value
   LE8BD:  jsr  CalculateVehicleSpeedOrEngineRpms    ; call subroutine
   LE8C0:  ldx  VehicleSpeed_HB
           stx  Temp0          ; store index into memory
           stD *VehicleSpeed_HB    ; store D to RAM
           cmpD #0x1fd0        ; compare D -00011111 11010000-
           bcc  LE8D4          ; branch if greater or equal
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           bra  LE8D6          ; branch

   LE8D4:  ldaa #0xff          ; load a with value -11111111-
   LE8D6:  staa CruiseControlSpeedRef    ; store a into memory
           brclr *CruiseStatus_2, #$%00000010, LE947    ; branch if bit(s) clear
           ldaa Counter_Cruise    ; load a with memory contents
           brclr *CruiseStatus_2, #$%00000001, LE8F2    ; branch if bit(s) clear
           cmpa CRMASK_CruiseMask    ; compare a with memory contents (data is 11)
           bcc  LE8EC          ; branch if greater or equal
           inca                ; increment a
           staa Counter_Cruise    ; store a into memory
           bra  LE947          ; branch

   LE8EC:  bclr *CruiseStatus_2, #$%00000001    ; clear bits
           clra                ; a = 0
           staa Counter_Cruise    ; store a into memory
   LE8F2:  cmpa CRSCN1_CruiseComapreConstant1    ; compare a with memory contents (data is 16)
           bcs  LE949          ; branch if lower
           ldab CruiseControlVar6    ; load b with memory contents
           tba                 ; a = b
           bpl  LE8FD          ; branch if plus (hi bit 0)
           negb            
   LE8FD:  cmpb CRSCN2_CruiseComapreConstant2    ; compare b with memory contents (data is 06)
           bcs  LE941          ; branch if lower
           ldx  #L002F         ; load index with value
           ldab CruiseSpeedSetpoint    ; load b with memory contents
           cmpb CRUZ36_UknownConstForCruiseControl36    ; compare b with memory contents (data is 8c)
           bls  LE90D          ; branch if lower or same
           inx                 ; increment index (x=x+1)
   LE90D:  ldab 0x00, X        ; load b with memory at index + value
           adda 0x02, X    
           bvc  LE918          ; branch if overflow
           lsla                ; logical shift left a
           ldaa #0x80          ; load a with value -10000000-
           sbca #0x00          ;  -00000000-
   LE918:  staa 0x02, X    
           cmpa CRMSK2_CruiseMask2    ; compare a with memory contents (data is 07)
           bgt  LE931          ; branch if greater
           cmpa CRMSK3_CruiseMask3    ; compare a with memory contents (data is f6)
           bge  LE941          ; branch if greater or equal
           subb CRMSK4_CruiseMask4    ; subtract memory contents from b (data is 02)
           cmpb CRMSK5_CruiseMask5    ; compare b with memory contents (data is e1)
           bge  LE93C          ; branch if greater or equal
           ldab CRMSK5_CruiseMask5    ; load b with memory contents (data is e1)
           bra  LE93C          ; branch

   LE931:  addb CRMSK7_CruiseMask7    ;  (data is 01)
           cmpb CRMSK6_CruiseMask6    ; compare b with memory contents (data is 1f)
           ble  LE93C          ; branch if less or equal
           ldab CRMSK6_CruiseMask6    ; load b with memory contents (data is 1f)
   LE93C:  stab 0x00, X    
           clra                ; a = 0
           staa 0x02, X    
   LE941:  bclr *CruiseStatus_2, #$%00000010    ; clear bits
           clra                ; a = 0
           staa Counter_Cruise    ; store a into memory
   LE947:  bra  LE973          ; branch

   LE949:  inca                ; increment a
           staa Counter_Cruise    ; store a into memory
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           ldaa CruiseSpeedSetpoint    ; load a with memory contents
           lsla                ; logical shift left a
           lsla                ; logical shift left a
           sba                 ; subtract (a=a-b)
           adda SETDLT_CruiseControlSetDeltaControlPointForCableAdaptive    ;  (data is 00)
           bmi  LE968          ; branch if minus(hi bit 1)
           ldab CruiseControlVar6    ; load b with memory contents
           bpl  LE961          ; branch if plus (hi bit 0)
           comb            
           incb            
   LE961:  cba             
           ble  LE973          ; branch if less or equal
           staa CruiseControlVar6    ; store a into memory
           bra  LE973          ; branch

   LE968:  ldab CruiseControlVar6    ; load b with memory contents
           bmi  LE96E          ; branch if minus(hi bit 1)
           comb            
           incb            
   LE96E:  cba             
           bge  LE973          ; branch if greater or equal
           staa CruiseControlVar6    ; store a into memory
   LE973:  ldd  Temp0          ; load d (a&b) with memory contents
           subd VehicleSpeed_HB    ; d = d - memory contents
           bne  LE97C          ; branch if not equal (not zero)
           clr  CruiseControlVar1    ; zero byte at memory location
   LE97C:  stD *Temp0          ; store D to RAM
           clra                ; a = 0
           ldab CruiseControlVar1    ; load b with memory contents
           bpl  LE984          ; branch if plus (hi bit 0)
           deca                ; decrement a
   LE984:  addd Temp0          ; d = d + memory contents
           asra            
           rorb            
           bsr  LE98E          ; call subroutine
   LE98A:  stab CruiseControlVar1    ; store b into memory
           bra  LE99F          ; branch

   LE98E:  asld                ; shift left (d=d*2)
           bcs  LE997          ; branch if lower
           tsta                ; test a
           beq  LE99D          ; branch if equal (zero)
           ldab #0x7f          ; load b with value -01111111-
           rts                 ; return from subroutine

   LE997:  cmpa #0xff          ; compare a with value -11111111-
           beq  LE99C          ; branch if equal (zero)
           clrb                ; b = 0
   LE99C:  sec                 ; set carry
   LE99D:  rorb            
           rts                 ; return from subroutine

   LE99F:  brset *CruiseStatus_1, #$%10000000, LE9F3    ; branch if bit(s) set
           ldx  #VACREG_CruiseControlVacRegularGainGurve_FromDeltaSpeed    ; load index with value
           clrb                ; b = 0
           ldaa CruiseSpeedSetpoint    ; load a with memory contents
           brclr *CruiseStatus_1, #$%00011000, LE9AF    ; branch if bit(s) clear
           ldaa CruiseControlVar0    ; load a with memory contents
   LE9AF:  lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           subd VehicleSpeed_HB    ; d = d - memory contents
           bcc  LE9F6          ; branch if greater or equal
           bclr *CruiseStatus_1, #$%00000100    ; clear bits
           ldx  #VENTRG_CruiseControlVentRegularGainCurve_FromDeltaSpeed    ; load index with value
           coma            
           comb            
           addd #0x0001         ;  -00000000 00000001-
           stab Temp0          ; store b into memory
           tsta                ; test a
           beq  LE9C9          ; branch if equal (zero)
           bset *Temp0, #$%11111111    ; set bits
   LE9C9:  lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           brclr *CruiseStatus_1, #$%00010000, LE9D9    ; branch if bit(s) clear
           ldx  #CRUZ1_UknownTableForCruiseControl1    ; load index with value
           tsta                ; test a
           beq  LEA0C          ; branch if equal (zero)
           ldaa #0xff          ; load a with value -11111111-
           bra  LEA0D          ; branch

   LE9D9:  tsta                ; test a
           bne  LE9ED          ; branch if not equal (not zero)
           cmpb VNTAB1_CruiseControlLimitToAMaxVent    ; compare b with memory contents (data is 90)
           bcc  LE9ED          ; branch if greater or equal
           tba                 ; a = b
           ldab Temp0          ; load b with memory contents
           cmpa VNTAB2_CruiseControlLimitToHalfMaxVent    ; compare a with memory contents (data is 60)
           bcs  LEA0C          ; branch if lower
           ldaA #0x05          ; load a with value -00000101-
           bra  LE9EF          ; branch

   LE9ED:  ldaA #0x0f          ; load a with value -00001111-
   LE9EF:  oraa #0x80          ;  -10000000-
           staa CruiseControlVar3    ; store a into memory
   LE9F3:  jmp  LEB2D      

   LE9F6:  brclr *CruiseStatus_1, #$%00001100, LE9FF    ; branch if bit(s) clear
           ldx  #VACACC_CruiseControlVacAcceleratedGainCurve_FromDeltaSpeed    ; load index with value
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
   LE9FF:  tsta                ; test a
           beq  LEA04          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   LEA04:  cmpb ACLRST_CruiseControlDeltaSpeedToResetAccFlag    ; compare b with memory contents (data is 09)
           bcc  LEA0C          ; branch if greater or equal
           bclr *CruiseStatus_1, #$%00000100    ; clear bits
   LEA0C:  tba                 ; a = b
   LEA0D:  jsr  Lookup4ByteTable    ; call subroutine
           clra                ; a = 0
           tstb            
           bpl  LEA15          ; branch if plus (hi bit 0)
           deca                ; decrement a
   LEA15:  stD *Temp0          ; store D to RAM
           ldx  #THGAIN_CruiseControlThrottleGainFactor_FromThrottle    ; load index with value
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bcc  LEA21          ; branch if greater or equal
           clra                ; a = 0
   LEA21:  jsr  Lookup4ByteTable    ; call subroutine
           staa Temp3          ; store a into memory
           ldx  #SPGAIN_CruiseControlSpeedGainFactor_FromSpeed    ; load index with value
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    ; call subroutine
           adda Temp3      
           bcc  LEA37          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LEA37:  staa Temp3          ; store a into memory
           clra                ; a = 0
           staa Temp2          ; store a into memory
           ldab CruiseControlVar1    ; load b with memory contents
           bpl  LEA41          ; branch if plus (hi bit 0)
           deca                ; decrement a
   LEA41:  asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd Temp0          ; d = d + memory contents
           stD *Temp0          ; store D to RAM
           brset *CruiseStatus_2, #$%00000100, LEA73    ; branch if bit(s) set
           bpl  LEA52          ; branch if plus (hi bit 0)
           coma            
           comb            
           addd #0x0001         ;  -00000000 00000001-
   LEA52:  tsta                ; test a
           beq  LEA57          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   LEA57:  cmpb CRUZ24_UknownConstForCruiseControl24    ; compare b with memory contents (data is 00)
           bhi  LEA73          ; branch if higher
           clrb                ; b = 0
           ldaa CruiseSpeedSetpoint    ; load a with memory contents
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           subd VehicleSpeed_HB    ; d = d - memory contents
           bpl  LEA6B          ; branch if plus (hi bit 0)
           coma            
           comb            
           addd #0x0001         ;  -00000000 00000001-
   LEA6B:  tsta                ; test a
           bne  LEA73          ; branch if not equal (not zero)
           cmpb CRUZ25_UknownConstForCruiseControl25    ; compare b with memory contents (data is 30)
           bls  LEA90          ; branch if lower or same
   LEA73:  clra                ; a = 0
           ldab CruiseControlVar2    ; load b with memory contents
           bpl  LEA79          ; branch if plus (hi bit 0)
           deca                ; decrement a
   LEA79:  addd Temp0          ; d = d + memory contents
           staa Temp4          ; store a into memory
           bpl  LEA84          ; branch if plus (hi bit 0)
           coma            
           comb            
           addd #0x0001         ;  -00000000 00000001-
   LEA84:  cmpD Temp2          ; compare D
           bcc  LEA93          ; branch if greater or equal
           ldaa Temp4          ; load a with memory contents
           bpl  LEA8E          ; branch if plus (hi bit 0)
           negb            
   LEA8E:  stab CruiseControlVar2    ; store b into memory
   LEA90:  jmp  LEB2D      

   LEA93:  clra                ; a = 0
           staa CruiseControlVar2    ; store a into memory
           ldaa Temp4          ; load a with memory contents
           anda #0x80          ; AND a with value -10000000-
           ldab CruiseControlVar3    ; load b with memory contents
           beq  LEAA5          ; branch if equal (zero)
           bpl  LEA90          ; branch if plus (hi bit 0)
           tab                 ; b = a
           eorb CruiseControlVar3
           bpl  LEA90          ; branch if plus (hi bit 0)
   LEAA5:  ldab TpsVolts       ; load b with memory contents
           subb MINTHR_LowestSessionTPS    ; b = b-memory contents
           bcc  LEAAC          ; branch if greater or equal
           clrb                ; b = 0
   LEAAC:  tsta                ; test a
           bpl  LEAD6          ; branch if plus (hi bit 0)
           oraa CRUZ28_UknownConstForCruiseControl28    ;  (data is 01)
           brclr *CruiseStatus_1, #$%00010000, LEABB    ; branch if bit(s) clear
           adda CRUZ30_UknownConstForCruiseControl30    ;  (data is 01)
           bra  LEAFD          ; branch

   LEABB:  staa Temp4          ; store a into memory
           clra                ; a = 0
           cmpb CLOTHR_CruiseControlDontVentIfThrottleBelowThis    ; compare b with memory contents (data is 01)
           bcs  LEAFD          ; branch if lower
           ldx  #CRUZ4_UknownTableForCruiseControl4    ; load index with value
           stx  Temp2          ; store index into memory
           ldx  #CRUZ5_UknownTableForCruiseControl5    ; load index with value
           bsr  LEB01          ; call subroutine
           oraa #0x80          ;  -10000000-
           ldab Temp4          ; load b with memory contents
           cba             
           bcc  LEAFD          ; branch if greater or equal
           bra  LEAFC          ; branch

   LEAD6:  cmpb MAXTHR_CruiseControlDontVacIfThrottleAboveThis    ; compare b with memory contents (data is 66)
           bcc  LEAFD          ; branch if greater or equal
           oraa CRUZ27_UknownConstForCruiseControl27    ;  (data is 01)
           brclr *CruiseStatus_1, #$%00001000, LEAE7    ; branch if bit(s) clear
           adda CRUZ29_UknownConstForCruiseControl29    ;  (data is 01)
           bra  LEAFD          ; branch

   LEAE7:  brset *CruiseStatus_1, #$%00000100, LEAFD    ; branch if bit(s) set
           staa Temp4          ; store a into memory
           ldx  #CRUZ2_UknownTableForCruiseControl2    ; load index with value
           stx  Temp2          ; store index into memory
           ldx  #CRUZ3_UknownTableForCruiseControl3    ; load index with value
           bsr  LEB01          ; call subroutine
           ldab Temp4          ; load b with memory contents
           cba             
           bcc  LEAFD          ; branch if greater or equal
   LEAFC:  tba                 ; a = b
   LEAFD:  staa CruiseControlVar3    ; store a into memory
           bra  LEB2D          ; branch

   LEB01:  clrb                ; b = 0
           ldaa CruiseSpeedSetpoint    ; load a with memory contents
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           subd VehicleSpeed_HB    ; d = d - memory contents
           asra            
           rorb            
           asra            
           rorb            
           asra            
           rorb            
           jsr  LE98E          ; call subroutine
           tba                 ; a = b
           adda #0x80          ;  -10000000-
           jsr  Lookup4ByteTable    ; call subroutine
           ldx  Temp2      
           staa Temp2          ; store a into memory
           ldd  Temp0          ; load d (a&b) with memory contents
           jsr  LE98E          ; call subroutine
           tba                 ; a = b
           adda #0x80          ;  -10000000-
           jsr  Lookup4ByteTable    ; call subroutine
           ldab Temp2          ; load b with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           rts                 ; return from subroutine

   LEB2D:  sei                 ; disable interrupts
           ldaa CCDFlags1      ; load a with memory contents
           anda #0x3f          ; AND a with value -00111111-
           brset *CruiseStatus_1, #$%10000000, LEB47    ; branch if bit(s) set
           ldab CruiseControlVar3    ; load b with memory contents
           beq  LEB49          ; branch if equal (zero)
           bpl  LEB4B          ; branch if plus (hi bit 0)
           brclr *CruiseStatus_1, #$%00010000, LEB47    ; branch if bit(s) clear
           ldab Counter_Cruise_3    ; load b with memory contents
           incb            
           beq  LEB47          ; branch if equal (zero)
           stab Counter_Cruise_3    ; store b into memory
   LEB47:  oraa #0xc0          ;  -11000000-
   LEB49:  oraa #0x80          ;  -10000000-
   LEB4B:  staa CCDFlags1      ; store a into memory
           cli                 ; enable interrupts
           ldab CruiseControlVar3    ; load b with memory contents
           beq  LEB5E          ; branch if equal (zero)
           asld                ; shift left (d=d*2)
           tstb            
           beq  LEB5B          ; branch if equal (zero)
           subb #0x02          ;  -00000010-
           beq  LEB5B          ; branch if equal (zero)
           lsrd                ; shift right (d=d/2)
   LEB5B:  stab CruiseControlVar3    ; store b into memory
           rts                 ; return from subroutine

   LEB5E:  brclr *CruiseStatus_2, #$%00000001, LEB65    ; branch if bit(s) clear
           bset *CruiseStatus_2, #$%00000010    ; set bits
   LEB65:  rts                 ; return from subroutine

   LEB66:  ldaa CruiseSpeedSetpoint    ; load a with memory contents
           ldx  #SETPW_CruiseControlSetupPulseForSet_FromSpeed        ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           bpl  LEB72          ; branch if plus (hi bit 0)
           ldab #0x7f          ; load b with value -01111111-
   LEB72:  stab Temp1          ; store b into memory
           ldaa MapValue       ; load a with memory contents
           suba BaroPressure
           bcc  LEB7D          ; branch if greater or equal
           tab                 ; b = a
           eorb #0x80          ;  -10000000-
   LEB7D:  bpl  LEB84          ; branch if plus (hi bit 0)
           lsla                ; logical shift left a
           ldaa #0x80          ; load a with value -10000000-
           sbca #0x00          ;  -00000000-
   LEB84:  adda #0x80          ;  -10000000-
           ldx  #RESTBL_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference        ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldab Temp1          ; load b with memory contents
           lslb            
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           bpl  LEB96          ; branch if plus (hi bit 0)
           ldaa #0x7f          ; load a with value -01111111-
   LEB96:  ldx  #L002F         ; load index with value
           ldab CruiseSpeedSetpoint    ; load b with memory contents
           cmpb CRUZ36_UknownConstForCruiseControl36    ; compare b with memory contents (data is 8c)
           bls  LEBA1          ; branch if lower or same
           inx                 ; increment index (x=x+1)
   LEBA1:  adda 0x00, X    
           bpl  LEBA8          ; branch if plus (hi bit 0)
           bvs  LEBA9          ; branch if no overflow
           clra                ; a = 0
   LEBA8:  rts                 ; return from subroutine

   LEBA9:  ldaa #0x7f          ; load a with value -01111111-
           rts                 ; return from subroutine
           
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
	brset *BitFlags6d, #b6d_FuelEngineNotRunning, FlashCEL_OnKnock_return	  ; branch if bit(s) set
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
	bset	*PIA_Buffer1, #pia_CEL
	bra	FlashCEL_OnKnock_return
KnockDetect_LightCEL:
	bclr	*PIA_Buffer1, #pia_CEL
FlashCEL_OnKnock_return:
	rts
;
;   -------------------------------------------------------
; 	Anti-Lag Retard Routine
;   -------------------------------------------------------
; 
; This will pull a small amount of timing under specific conditions to
; improve turbo spool.
; 
; Timing will normally be pulled when transitioning from P/T to WOT.
; But, the transition condition will be ignored if the staging limiter
; is active. This will allow the anti-lag to work when staging the car.
;
; The amount of timing pulled is a function of the difference between
; the target boost and the actual MAP reading. This can be tuned via
; the lookup table.
; 
; To enable this code, simply check the Custom Options flag for it
; in the table file. This codebase has been modified to check for
; the option and will automatically re-config the SMEC appropriately.
; 
; Keep in mind, the values from the lookup table will be truncated to the
; nearest 0.5 deg when subtracted from the "normal" advance.
; 
; CalculateAntiLagRetard_Routine_MM:
;        ldaa #0x00                                     ; load 0x00 into A, default anti-lag retard
; ; check that the option is enabled...
;        ldx  #OPTN1_CalCustomOptionConfigFlags1
;        brclr 0, X, #opt_AntiLag, AntiLag_return
; ; check the conditions for anti-lag - 1st check for staging limiter, then for WOT
;        ldx  #Turbonator_Flags
;        brset 0, x, #Turbonator_Staging, L3000           ;if the staging limiter is active, ignore WOT requirement
;        brclr *BitFlags66, #b66_FullThrottle, AntiLag_return
; L3000: 
;        ldx  #ANTLAG_AntiLagRetardfromBoostGoalDelta   ; load index with value
;        ldab 0x01,x                                    ; load minimum Delta MAP reference from the table
;        addb BaroPressure                              ; check if MAP is higher than the minimum...
;        cmpb MapValue
;        bcc  AntiLag_return
;        ldab BoostTarget                               ; load the target boost
;        subb MapValue                                  ; subtract the actual MAP value
;        bcs  AntiLag_return	                      ; branch if greater or equal - no need for antilag
;        tba
;        jsr  Lookup4ByteTable                          ; call subroutine
;        lsra                                           ; divide result by 2
;        lsra                                           ; divide result by 2
;        lsra                                           ; divide result by 2
;        lsra                                           ; divide result by 2
;        lsra                                           ; divide result by 2 - total dived by 32
; AntiLag_return:
;        staa AntiLagRetard                             ; store the antilag retard
;        rts
;
;   -------------------------------------------------------
; 	Shift Light Control Routine
;   -------------------------------------------------------
; 
; 
; This routine will control a shift light with many parameters
; configurable by the user/calibrator.
; 
; Here's how I think this should work:
; 
; 1) 2 setpoints for the shift light; 1 for 1st gear, one for all other gears
; 2) adjustable by the driver - special mode?
;    - special mode: when the engine is not running, press and hold the brake pedal, push cruise set (?) button
;    - to increment the shift light point; display the value on the tach?
; 3) option to flash the light 3 times before the shift, based on rpm
; 4) user/calibrator selectable output (cruise solenoids, purge solenoids, egr solenoid, or PTU output, EMR output, etc.)
; 5) will require 2 routines; 1 for running the light, the other for setup.
; 
; ControlShiftLight_MM:
;        brclr *Counter_MainLoop, #$%00010000, ShiftLight_Return
;        ldx   OPTN1_CalCustomOptionConfigFlags1
;        brclr 0, X, #opt_ShiftLight, ShiftLight_Return
;        brclr *BitFlags6d, #b6d_FuelEngineNotRunning, ShiftLight_Run
; 
; ShiftLight_Setup:
;        ; still need to figure this out...
;        ;
;        ; use brake pedal to engage the setup, and the throttle to adjust?
;        ; press brake pedal 3 times in 2 sec to engage setup (with engine not running, obviously)
;        ; then press throttle to indicate shift rpm on tach and press brake again to set
;        ; to set 2nd point, press brake 4 times in 2 sec, otherwise same procedure...
;        ;
;        ; need to figure out how to time the tach pulses to do this right, might be difficult to do
;        ;
;        ; for testing, I can do this with only constants, not variables...
;        ; should run with only this line in the "setup" routine...
; 
;        bra ShiftLight_Return
; 
; ShiftLight_Run:
;        ldx  EngineRpm_HB
;        cpx  SLRPM_ShiftLightSetpoint
;        bcc  ShiftLight_TurnLightOff
; 
; ShiftLight_TurnLightOn:
;        bset *PIA2_Buffer, #pi2_PTU
;        bra  ShiftLight_Return
; 
; ShiftLight_TurnLightOff:
;        bclr *PIA2_Buffer, #pi2_PTU
; 
; ShiftLight_Return:
;        rts

    .org	0xFEA0
ShelSoftCopyrightNotice:
    .str	"Turbonator mods and brand Copr. 2012 Rob Lloyd  "
    .str        "Turbonator T3   SBEC-II v1 "


; not sure what this is...
    .org 0xff9f
	.byte	0x90,0xc5,0xaa,0x54,0x22

;    .org        0xFFB0
ChryslerCopyrightNotice:
    .str	"Copr. 1990 Chrysler Corp."

	.byte	0x22,0x80,0x02

    .org        0xFFD6
SCI_Interrupt_vector:
	.word	Interrupt_RealTime
SPIE_Flag_Interrupt_vector:
	.word	Interrupt_RealTime
PAII_Flag_Interrupt_vector:
	.word	Interrupt_RealTime
PAOVI_Flag_Interrupt_vector:
	.word	Interrupt_PulseAccumulatorInputEdge
TOI_Flag_Interrupt_vector:
	.word	Code80
OC5_Flag_Interrupt_vector:
	.word	Interrupt_DwellTimerB
OC4_Flag_Interrupt_vector:
	.word	Interrupt_TimerOC3_Wastegate
OC3_Flag_Interrupt_vector:
	.word	Interrupt_DwellTimerA
OC2_Flag_Interrupt_vector:
	.word	Interrupt_RealTime
OC1_Timer_Interrupt_vector:
	.word	Interrupt_TimerOutputCapture1
IC3_Timer_Interrupt_vector:
	.word	Interrupt_RealTime
IC2_Timer_Interrupt_vector:
	.word	Interrupt_SpeedometerSignal
IC1_Timer_Interrupt_vector:
	.word	Interrupt_CamSensorSignal
Realtime_Interrupt_vector:
	.word	Code80
IRQ_hardware_Interrupt_vector:
	.word	Interrupt_CrankSensor_Signal
XIRQ_hardware_Interrupt_vector:
	.word	Interrupt_XIRQ
SWI_Software_Interrupt_vector:
	.word	Interrupt_Software
Illegal_Opcode_vector:
	.word	Interrupt_BadOp
COP_Watchdog_Timeout_vector:
	.word	Interrupt_COPFail
Clock_Monitor_Fail_vector:
	.word	Interrupt_ClockMonFail
ResetVector:
	.word	ResetInterrupt


        .msg "Assembly Complete..." ; these are just messages to display during assemble to let you know what's going on...
