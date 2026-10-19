	.title TurbonatorSBECv4
	.area ROM (ABS)
; SET TABS to 4 if text appears jumbled
;  ____________________________________________________________________________
; |									       \
; |									       |
; |   Mopar ECM SBEC							       |
; |   Based on 1990 Turbo I/VNT Codebase				       |
; |									       |
; | Code and original design and data Copyright 1987 by Chrysler Corporation   |
; | This relocateable source is Copyright 2008 by Robert Lloyd		       |
; | Modified code modules are Copyright 2013				       |
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
; Version X.0
; 04/22/08 - Project begins...
; 
; Version X.1
; 11/28/08 - Assembles to (nearly) the original binary.
;
; Version 1.0
; 6/25/09 - 1st release, added Turbonator options.
; 6/26/09 - r1: fixed data addressing assembler directive error.
;
; Version 2.0
; 9/29/09 - Converted template/asm files for use with MP Tuner.
;
; Version 2.1
; 1/28/10 - Change the PumpEff code back to stock. In T-SMEC this was the 
;           cause of the long-running misfire.
;
; Version 2.2
; 3/26/10 - Changed codebase to VNT disassembly to make VNT boost control
;           easier to integrate.
;           Added shiftlight routine.
;
; Version 2.3
; 7/30/10 - Removed extra '.org' statements that were inadvertently forgotten.
;           Caused a bad compile, but with no errors.
;           Added A596 VNT Template. Not sure of the application, and the cal
;           data appears nearly identical to the A415 except for some overboost
;           timer changes.
;
; Version 2.4
;  8/18/10 - Fixed a bad table for the VNT OverBoost control. It appears to add
;            fuel when the VNT Overboost control is working. Has no effect on
;            the WG control system.
;          - Identified a previously unknown flag that appears to enable fuel
;            cut for the VNT overboost control rouitne (default is no fuel cut,
;            I think).
;          - Fixed a conflict between the Charge Temp Enable flag and the cold
;            start enrichment flag (not sure what the purpose of this flag is,
;            could be for Canada models?)
;          - Fixed a conflict between the Turbonator RAM locations and the
;            cruise control routine. The RAM I originally chose was already
;            being used by Cruise.
;          - Added bit definitions for the major bit flag variables.
;          - Fixed the Boost Switch Definitions
;
; Version 2.5
; 10/05/10 - Fixed a couple of missing bytes in the PIA interface table and
;            in the DRB control tables.
;
; Version 2.6
; 10/19/10 - Fixed an assemnler directive from .byte to .word ; something to do
;            with the injector driver diagnostic routine.
;          - Fixed an assembler asssignment at LAD4C to use 16-bit addressing 
;            instead of 8-bit. Should have been OK, but this matches the 
;            original code.
;          - Fixed the location of a ldx for the staging limiter code. Was
;            looking at an unknown memory location.
;          - Added in the anti-lag subtraction, same as T-SMEC inplementation.
;          - Corrected rev limiter reference for the staging limiter code.
;          - Fixed an addressing (assembler) error in the reset interrupt 
;            routine.
;          - Fixed an immediate mode error on many instances of 0xFFFF 
;            assignments. 
;          - Fixed an immediate mode error with the fan control speeds.
;          - Fixed the CalID reference in the checksum routine.
;          - Fixed mode assignments on Injector PW Reference 
;            (MNPWDS_MinimumInjPWForDistSync) - Immediate to Extended
;          
; Version 2.7
; 02/20/11 - Fixed the order of the MAPHI and MAPLOW references at C013.
;          - Fixed the definition of RPMMP2 (RPMMAP); was missing.
;          - Fixed definition of 3 8-bit fuel timer lookup tables.
;
; Version 2.8
; 06/06/11 - Moved the AIS Bit pattern back to in-line with the code. Not sure
;            why, but it fixed an issue with the AIS running with the key-off.
;
; Version 3.0
; 06/XX/11 - Updated asm and templates to MP Tuner 2 format.
;
; Version 3.1
; 08/30/11 - Updated the naming of the Decel Fuel Shutoff valules and added to 
;            a new separate group.
;          - Updated the Staging Limiter code. Was not working due to the decel
;            fuel shutoff code.
;          - Added code to fix the CCD Fuel Monitor value.
;          - Split MPVACD_AllowMapToTestGoodThisNearBaro into 2 value to correct
;            MAP scaling.
;          - Updated Staging Limiter code to work when no switch is selected (on
;            speed only).
;          - Setup AESLOP to scale inversley with MAP (only in MPT 2.0.0.9)
;
; Version 4.0
; 04/30/12 - Completely re-written anti-lag and staging limiter.
;          - Anti-lag now goes to a single pre-set value rather than a
;            retard value.
;          - Anti-lag comes on at user-set RPM level.
;          - Staging limiter now has spark cut option. Spark cut is
;            rotating and has a selectable fraction.
;          - Fixed an issue with the DRB Sensor value reading and switch test 
;            function.
;          - Changed the dwell calculation to be like the SBECII
;
; Version 4.1
; 12/14/14 - Fixed the Main rev limiter issues caused by the staging limiter.
;
version == 04
;
; ***********************************************************************

; Routines ending with "_MM" are called from MainProgramLoop.

; ***********************************************************************
; Code/data can be org'd anywhere in the $8000-$ffd5 range, except
; you MUST leave a hole from $b600-$b7ff (on chip eeprom). The interrupt
; vectors must be from $ffd6-$ffff.
; ***********************************************************************

DataOrg == 0x8000
CodeOrg == 0x9000

; ***********************************************************************
; These variables can be changed, then the source recompiled.
; ***********************************************************************

IncludeFillerBytes = 1	    ; 1=stock - to ensure exact byte for byte reloc

;
; *****************************************************************************
; Calibration Template definition
; *****************************************************************************
;
; Currently, this is handled completely by MP Tuner.

.define CalDataFile /C:\Users\Rob\Dropbox\BoostButton\Products\Cal Data\Source Files\90T1_Master\v4\T-SBEC_25_MTX_B246_HiTorq.tpl/

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
; Mopar ECM - 68HC11 Disassembly
; 1989 Turbo I
;
; Custom disassembler
; Copyright � 2012 by Robert Lloyd.
; www.boostbutton.com

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

L0000                                                      == 0x0000
L0001                                                      == 0x0001
L0002                                                      == 0x0002
L0003                                                      == 0x0003
L0004                                                      == 0x0004
MINTHR_LowestSessionTPS                                    == 0x0005
DCCOR0_AdaptiveVNTCell0                                    == 0x0006
DCCOR1_AdaptiveWastegateCellBelowMAPPT                     == 0x0007
DCCOR2_AdaptiveWastegateCellTo4000rpm                      == 0x0008
DCCOR3_AdaptiveWastegateCellTo4992rpm                      == 0x0009
DCCOR4_AdaptiveWastegateCellTo5504rpm                      == 0x000A
DCCOR5_AdaptiveWastegateCellAbove5504rpm                   == 0x000B
DCCOR6_AdaptiveVNTCell1                                    == 0x000C
DCCOR7_AdaptiveVNTCell2                                    == 0x000D
Timer_DacalCountdown                                       == 0x000E
CurrentAisPosition                                         == 0x000F
BitFlags_AIS                                               == 0x0010
    b10_bit7			= $%10000000	;
    b10_bit6			= $%01000000	;
    b10_UseAIS		        = $%00100000	;Too much boost
    b10_bit4			= $%00010000	;
    b10_ATXInGear		= $%00001000	;Auto in gear
    b10_ATXChngGear		= $%00000100	;Auto just changed gears
    b10_bit1			= $%00000010	;
    b10_bit0			= $%00000001	;
AutoCalCell0                                               == 0x0011
AutoCalCell1                                               == 0x0012
AutoCalCell2                                               == 0x0013
AutoCalCell3                                               == 0x0014
AutoCalCell4                                               == 0x0015
AutoCalCell5                                               == 0x0016
AutoCalCell6                                               == 0x0017
AutoCalCell7                                               == 0x0018
AutoCalCell8                                               == 0x0019
AutoCalCell9                                               == 0x001A
AutoCalCell10                                              == 0x001B
AutoCalCell11                                              == 0x001C
AutoCalCell12idle                                          == 0x001D
AutoCalCellEnd                                             == 0x001E
ErrorBitRegister0                                          == 0x001F
    b1f_errLostFJ2		= $%10000000	; 44 Loss of FJ2
    b1f_errNothing		= $%01000000	; 45 Nothing (overboost)
    b1f_errHighVoltage		= $%00100000	; 46 Battery Volts High
    b1f_errLowVoltage		= $%00010000	; 47 Battery Volts Low
    b1f_errStuckLean		= $%00001000	; 51 Lean condition
    b1f_errStuckRich		= $%00000100	; 52 Rich Condition
    b1f_errChecksum		= $%00000010	; 53 Prom Checksum
    b1f_errDistSync		= $%00000001	; 54 Distributor Sync
ErrorBitRegister1                                          == 0x0020
    b20_errAcCutoutRelay	= $%10000000	; 33 AC Cutout Relay
    b20_errSpeedCtlSolenoid	= $%01000000	; 34 Speed Ctl Solenoid
    b20_errRadFanRelay		= $%00100000	; 35 Radiator Fan Relay
    b20_errWastegateSolenoid	= $%00010000	; 36 Wastegate Solenoid
    b20_errBaroReadSolenoid	= $%00001000	; 37 Barometric Read Solenoid
    b20_errChargingSystem	= $%00000100	; 41 Charging System
    b20_errASDRelay		= $%00000010	; 42 Auto Shutdown Relay
    b20_errIgnitionCoil 	= $%00000001	; 43 Ignition Coil Control
ErrorBitRegister2                                          == 0x0021
    b21_errCoolantTempSensor	= $%10000000	; 22 Coolant Temp Sensor
    b21_errChargeTempSensor	= $%01000000	; 23 Charge Temp Sensor
    b21_errTPS			= $%00100000	; 24 Throttle Position
    b21_errAIS			= $%00010000	; 25 AIS Motor
    b21_errInjectorCurrent	= $%00001000	; 26 Injector Current Limit Not Achieved
    b21_errInjectorDriver	= $%00000100	; 27 Injector Driver interface
    b21_errPurgeSolenoid	= $%00000010	; 31 Purge Solenoid
    b21_errEGR		        = $%00000001	; 32 Exh Gas Recirc Solenoid
ErrorBitRegister3                                          == 0x0022
    b22_errNotCranked		= $%10000000	; 11 Engine Not Cranked Since Battery Disconnected
    b22_errMemPowerLost 	= $%01000000	; 12 Memory Standby Power Lost
    b22_errMapPneumatic 	= $%00100000	; 13 MAP Pneumatic
    b22_errMapElectrical	= $%00010000	; 14 MAP Electrical
    b22_errDistanceSensor	= $%00001000	; 15 Vehicle Distance Sensor
    b22_errBattVoltageSense	= $%00000100	; 16 Battery Voltage Sense
    b22_errEngineTooCool	= $%00000010	; 17 Engine Running Too Cool (thermostat)
    b22_errO2Sensor		= $%00000001	; 21 Oxygen Sensor
ErrorBitRegisterStored0                                    == 0x0023
    b23_bit7			= $%10000000	; 44 Loss of FJ2
    b23_bit6			= $%01000000	; 45 Overboost
    b23_bit5			= $%00100000	; 46 Battery Volts High
    b23_bit4			= $%00010000	; 47 Battery Volts Low
    b23_bit3			= $%00001000	; 51 Lean condition
    b23_bit2			= $%00000100	; 52 Rich Condition
    b23_bit1			= $%00000010	; 53 Prom Checksum
    b23_bit0			= $%00000001	; 54 Distributor Sync
ErrorBitRegisterStored1                                    == 0x0024
    b24_bit7			= $%10000000	; 33 AC Cutout Relay
    b24_bit6			= $%01000000	; 34 Speed Ctl Solenoid
    b24_bit5			= $%00100000	; 35 Radiator Fan Relay
    b24_bit4			= $%00010000	; 36 Wastegate Solenoid
    b24_bit3			= $%00001000	; 37 Barometric Read Solenoid
    b24_bit2			= $%00000100	; 41 Charging System
    b24_bit1			= $%00000010	; 42 Auto Shutdown Relay
    b24_bit0			= $%00000001	; 43 Ignition Coil Control
ErrorBitRegisterStored2                                    == 0x0025
    b25_bit7			= $%10000000	; 22 Coolant Temp Sensor
    b25_bit6			= $%01000000	; 23 Charge Temp Sensor
    b25_bit5			= $%00100000	; 24 Throttle Position
    b25_bit4			= $%00010000	; 25 AIS Motor
    b25_bit3			= $%00001000	; 26 Injector Current Limit Not Achieved
    b25_bit2			= $%00000100	; 27 Injector Driver interface
    b25_bit1			= $%00000010	; 31 Purge Solenoid
    b25_bit0			= $%00000001	; 32 Exh Gas Recirc Solenoid
ErrorBitRegisterStored3                                    == 0x0026
    b26_bit7			= $%10000000	; 11 Engine Not Cranked Since Battery Disconnected
    b26_bit6			= $%01000000	; 12 Memory Standby Power Lost
    b26_bit5			= $%00100000	; 13 MAP Pneumatic
    b26_bit4			= $%00010000	; 14 MAP Electrical
    b26_bit3			= $%00001000	; 15 Vehicle Distance Sensor
    b26_bit2			= $%00000100	; 16 Battery Voltage Sense
    b26_bit1			= $%00000010	; 17 Engine Running Too Cool
    b26_bit0			= $%00000001	; 21 Oxygen Sensor
ErrorCodeUpdateKeyOnCount                                  == 0x0027
ErrorCodeUpdateKeyOnCount2                                 == 0x0028
ErrorCodeUpdateKeyOnCount3                                 == 0x0029
Cyl2_InjPWTrim                                             == 0x002A
Cyl1_InjPWTrim                                             == 0x002B
Cyl3_InjPWTrim                                             == 0x002C
Cyl4_InjPWTrim                                             == 0x002D
CylTrimFlags                                               == 0x002E
              ; need to define flags!!!
    b2e_bit7			= $%10000000
    b2e_bit6			= $%01000000
    b2e_bit5			= $%00100000
    b2e_bit4			= $%00010000
    b2e_bit3			= $%00001000
    b2e_bit2			= $%00000100
    b2e_bit1			= $%00000010
    b2e_bit0			= $%00000001

; can't use these, they're for cruise control...
;---------------------------------------------------

L002f                                                      == 0x002F
L0030                                                      == 0x0030
L0031                                                      == 0x0031
L0032                                                      == 0x0032

;---------------------------------------------------

Counter_SpeedSensorInterrupt                               == 0x0033
AdaptiveRetardIndex                                        == 0x0035
BitFlags_36                                                == 0x0036
    b36_EGR			= $%10000000	; EGR Active
    b36_bit6			= $%01000000	;
    b36_ReadBaroRequired	= $%00100000	; Read Baro At Next Opportunity
    b36_EMR			= $%00010000	; Emission Maint Reminder
    b36_bit3			= $%00001000	; Not used
    b36_bit2			= $%00000100	; Not used
    b36_ais1			= $%00000010	; AIS Step Phase - specifies which of the bit patterns
    b36_ais0			= $%00000001	; AIS Step Phase   is being output to the stepper motor
    b36_both			= $%00000011

CCDBatteryVoltsOutput                                      == 0x0037
Timer_BoostTimer                                           == 0x0038
BoostActuatorADutyCycle_VNT                                == 0x0039
BoostActuatorBDutyCycle_WG                                 == 0x003A
WastegateDutyCycleDecreaseFromIncrRate                     == 0x003B
Timer_BoostErrTimer                                        == 0x003C
StartupSwitchMirror1                                       == 0x003D
    sw1_B1Volt         	        = $%10000000	;
    sw1_ACclutch       	        = $%01000000	; A/C Clutch input
    sw1_CruiseSet              	= $%00100000	; Cruise Set
    sw1_bit4                    = $%00010000	;
    sw1_CruiseOnOff         	= $%00001000	; Cruise On/Off
    sw1_Brake          		= $%00000100	; Brake Switch
    sw1_CruiseResume   		= $%00000010	; Cruise Resume
    sw1_PNswitch                = $%00000001	; Park/Neutral switch
StartupSwitchMirror2                                       == 0x003E
    sw2_B1Volt           	= $%10000000	;
    sw2_ACclutch       	        = $%01000000	; A/C Clutch input
    sw2_CruiseSet              	= $%00100000	; Cruise Set
    sw2_bit4                    = $%00010000	;
    sw2_CruiseOnOff         	= $%00001000	; Cruise On/Off
    sw2_Brake          		= $%00000100	; Brake Switch
    sw2_CruiseResume   		= $%00000010	; Cruise Resume
    sw2_PNswitch                = $%00000001	; Park/Neutral switch
PIA1_Buffer                                                == 0x003F
    pi1_CEL                     = $%10000000    ; Check Engine Light (Pin )
    pi1_PurgeSol                = $%01000000    ; Purge Solenoid (Pin )
    pi1_Fan                     = $%00100000    ; Fan Relay (Pin )
    pi1_ASD                     = $%00010000    ; Auto Shutdown Relay (Pin )
    pi1_AISMotor3               = $%00001000    ; AISM (Pin )
    pi1_AISMotor2               = $%00000100    ; AISM (Pin )
    pi1_AISMotor1               = $%00000010    ; AISM (Pin )
    pi1_AISMotor0               = $%00000001    ; AISM (Pin )
PIA2_Buffer                                                == 0x0040
    pi2_VNTSol                  = $%10000000    ; Waste Gate Solenoid VNT (Pin )
    pi2_WGSol                   = $%01000000    ; Waste Gate Solenoid (Pin )
    pi2_EGRSol                  = $%00100000    ; Part Throttle Unlock (Pin )
    pi2_Baro                    = $%00010000    ; Baro Read Solenoid (Pin )
    pi2_ACRelay                 = $%00001000    ; A/C Clutch Relay (Pin )
    pi2_PTU                     = $%00000100    ; EGR Solenoid (Pin )
    pi2_SCVent                  = $%00000010    ; Speed Ctl Vent (Pin )
    pi2_SCVac                   = $%00000001    ; Speed Ctl Vacuum (Pin )
PIA3_Buffer                                                == 0x0041
    pi3_bit7                    = $%10000000    ;
    pi3_KnockCap                = $%01000000    ; Knock Voltage Storage Cap
    pi3_ChargeTemp              = $%00100000    ; 1K Pullup Resistor For Charge Temp Sensor Circuit Control
    pi3_CoolantTemp             = $%00010000    ; 1K Pullup Resistor For Coolant Sensor Circuit Control
    pi3_FuelMon                 = $%00001000    ; Fuel Monitor?  (Pin )
    pi3_CCDEnable               = $%00000100    ; CCD Enable
    pi3_Tach                    = $%00000010    ; Tach Signal? (Pin )
    pi3_bit0                    = $%00000001    ;
CruiseStatus_1                                             == 0x0042
CruiseStatus_2                                             == 0x0043
Counter_Cruise_1                                           == 0x0044
Counter_Cruise                                             == 0x0045
Counter_TimerRegHalfOverflowBetweenSpeedoPulses            == 0x0046
PreviousVehicleSpeed_HB                                    == 0x0047
PreviousVehicleSpeed_LB                                    == 0x0048
TimerOverflowsBetweenSpeedoPulses                          == 0x0049
SpeedoSensorPulsewidth_HB                                  == 0x004A
SpeedoSensorPulsewidth_LB                                  == 0x004B
VehicleSpeed_HB                                            == 0x004C
VehicleSpeed_LB                                            == 0x004D
Counter_Cruise_2                                           == 0x004E
Counter_Cruise_3                                           == 0x004F
CruiseSpeedSetpoint                                        == 0x0050
CruiseControlVar0                                          == 0x0051
CruiseControlVar1                                          == 0x0052
CruiseControlVar2                                          == 0x0053
CruiseControlVar3                                          == 0x0054
CruiseControlVar4                                          == 0x0055
Counter_SomethingWithDistributor                           == 0x0056
CruiseControlVar6                                          == 0x0057
ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB                 == 0x0058
ErrorBitsAssociatedWithPIA1AndReg1eTo25_LB                 == 0x0059
ClearTheErrorTimer_0                                       == 0x005A
ClearTheErrorTimer_1                                       == 0x005B
b5c_IPL1                                                   == 0x005C
    b5c_MapStuck		= $%10000000	; Map Stuck
    b5c_TpsBadSignal		= $%01000000	; Throttle
    b5c_MapBadSignal		= $%00100000	; MapVolts
    b5c_Bad_BatVolts		= $%00010000	; BatVolts
    b5c_bit3			= $%00001000	;
    b5c_BattNotCharging 	= $%00000100	; BatVoltsNotNearTarget
    b5c_BadCoolantTemp		= $%00000010	; Cool Volts
    b5c_BadIATSensor		= $%00000001	; ChargeVolts
; IPL 2
b5d_IPL2                                                   == 0x005D
    b5d_EGRSolFault		= $%10000000	; EGR Solenoid Fault
    b5d_MajorFault		= $%01000000	; Major Fault
    b5d_bit5			= $%00100000	;
    b5d_InjectorFault		= $%00010000	; Fuel Injector Fault
    b5d_WGSolFault		= $%00001000	; Map Wastegate
    b5d_EMRLight		= $%00000100	; EMR Light?
    b5d_bit1			= $%00000010	;
    b5d_bit0			= $%00000001	;
BitFlags5E                                                 == 0x005E
    b5e_MapOK			= $%10000000	; Map OK
    b5e_bit6			= $%01000000	;
    b5e_bit5			= $%00100000	;
    b5e_bit4			= $%00010000	;
    b5e_bit3		        = $%00001000	;
    b5e_bit2		        = $%00000100	;
    b5e_bit1			= $%00000010	;
    b5e_bit0 		        = $%00000001	;
ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR                == 0x005F
TimerOverflowsBetweenDistPulses                            == 0x0060
DistributorFallingEdgePulsewidth_HB                        == 0x0061
DistributorFallingEdgePulsewidth_LB                        == 0x0062
Counter_TimerPastHalfwayBetweenDistPulses                  == 0x0063
LastDistributorFallingEdgeTime                             == 0x0064
ErrorCodeEraseCounter                                      == 0x0065
BitFlags66                                                 == 0x0066
    b66_OffIdle 		= $%10000000	; Throttle Pressed
    b66_UpdatedMINTHR		= $%01000000	; Minimum Throttle Value has been updated with an actual value
    b66_OpenLoop		= $%00100000	; Not In Closed Loop ;Oxygen Sensor Stuck
    b66_O2Valid 		= $%00010000	; Oxygen Sensor Has Been Outside .75V to .29V Range
    b66_PartThrottle		= $%00001000	; Throttle Lightly Pressed
    b66_O2Rich			= $%00000100	; Oxygen Sensor on the Rich Side
    b66_PTEisMaxed		= $%00000010	; Part Throttle Enrichment is maxed
    b66_FullThrottle		= $%00000001	; Throttle Floored
BitFlags67                                                 == 0x0067
    b67_Purge			= $%10000000	; Canister Purge
    b67_FallToIdle		= $%01000000	; Engine Speed Too High to be Idling
    b67_InMotion		= $%00100000	; Something to do with vehicle moving
    b67_StayOpenLoop		= $%00010000	; Dont Try Closed Loop
    b67_IdleSpeedMode		= $%00001000	; Dont Control Idle Speed (if clear dont control AIS, if set dont control idle with Injectors)
    b67_OpenLoop		= $%00000100	; Currently Open Loop
    b67_bit1			= $%00000010	; Something with reg 73
    b67_BadO2			= $%00000001	; Oxygen Sensor Bad
BitFlags68                                                 == 0x0068
    b68_SparkEngineNotRunning	= $%10000000	; Spark - Engine Not Running
    b68_bit6			= $%01000000	; AIS Stuff
    b68_BaroSolEnergized	= $%00100000	;
    b68_ASDon			= $%00010000	; ASD ON
    b68_SpeedOver40		= $%00001000	; SPEED GREATER THAN 40 MPH
    b68_Past12secRunning	= $%00000100	; ENGINE RUNNING MORE THAN 12 sec OR KEY ON FOR MORE THAN 12 sec
    b68_BladePassedSensor	= $%00000010	; WINDOW BLADE HAS PASSED THROUGH DISTRIBUTOR SYNC SENSOR
    b68_EndOfBlade		= $%00000001	; END OF ANY BLADE AT DISTRIBUTOR REF SENSOR
BitFlags69                                                 == 0x0069
    b69_bit7        		= $%10000000	; Coolant temp filter/store?
    b69_bit6			= $%01000000	; Coolant temp filter/store?
    b69_AtIdle			= $%00100000	; Just returned to idle
    b69_AcClutch		= $%00010000	; AC clutch engaged
    b69_bit3			= $%00001000	; ?
    b69_bit2			= $%00000100	; AC?
    b69_bit1			= $%00000010	;
    b69_bit0			= $%00000001	;
    b69_BadO2Read		= $%00000011    ; Indicates a bad O2 sensor reading?
BitFlags6a                                                 == 0x006A
    b6a_PTU_B 		        = $%10000000
    b6a_PTU_A 		        = $%01000000
    b6a_WGDC 		        = $%00100000
    b6a_EMR 		        = $%00010000	
    b6a_OverRev 		= $%00001000	; OverRevving
    b6a_FuelOff 		= $%00000100	; Shut Off Fuel
    b6a_DRBToggle2		= $%00000010	; DRBII Toggle
    b6a_DRBToggle1		= $%00000001	; DRBII Toggle
BitFlags6b                                                 == 0x006B
    b6b_bit7			= $%10000000	;
    b6b_bit6			= $%01000000	;
    b6b_bit5			= $%00100000	; Coil Test
    b6b_bit4			= $%00010000	;
    b6b_bit3			= $%00001000	; fall to idle?
    b6b_bit2			= $%00000100	;
    b6b_DecelFuelCut		= $%00000010	; Purge Solenoid
    b6b_bit0			= $%00000001	; Coil Test
BitFlags6c                                                 == 0x006C
    b6c_VNTOvBst		= $%10000000	; VNT Overboost 
    b6c_bit6			= $%01000000	;
    b6c_bit5			= $%00100000	;
    b6c_DRBModeFlag		= $%00010000	; indicates system is in DRB test mode
    b6c_bit3			= $%00001000	;
    b6c_bit2			= $%00000100	;
    b6c_bit1		        = $%00000010	;
    b6c_EMR_1			= $%00000001	; emission maint reminder
BitFlags6d                                                 == 0x006D
    b6d_FuelEngineNotRunning	= $%10000000	; Fuel - Engine Not Running
    b6d_BigMapChange		= $%01000000	; Significant MAP Change
    b6d_JustStarted		= $%00100000	; Engine Just Started
    b6d_Starting		= $%00010000	; Use Starting Injector PW Calculations (instead of Running Injector PW Calculations)
    b6d_BaroOkEngineStopped	= $%00001000	; Take Baro Reading Straight From MAP Since Engine Not Running
    b6d_Uncranked		= $%00000100	; Engine Not Cranked Since
    b6d_DisableNormalDwell	= $%00000010	; Normal Dwell Disable
    b6d_NeedSetup		= $%00000001	; System Needs To Run Setup Routine
BitFlags6e                                                 == 0x006E
    b6e_BoostOver5psi		= $%10000000	; Boost Greater than 5 PSI
    b6e_WastegateDC		= $%01000000	; Current WasteGate Duty Cycle
    b6e_DistSync		= $%00100000	; Distributor Sync Value
    b6e_UseSparkScatter 	= $%00010000	; Use Spark Scatter
    b6e_SearchBladeEndRef_INSYNC	= $%00001000	; Search for end of window blade on Reference Signal
    b6e_PIAKeepIntEnabled	= $%00000100	; Keeps the interrupts disabled during the PIA communications when set
    b6e_InjectorB		= $%00000010	; CAM Position Bit 1 - this bit controls InjectorB
    b6e_InjectorA		= $%00000001	; CAM Position Bit 0 - this bit controls InjectorA
    b6e_InjectorAandB		= $%00000011	; Both b6e_InjectorB and b6e_InjectorA
BitFlags6f                                                 == 0x006F
    b6f_bit7			= $%10000000
    b6f_bit6			= $%01000000
    b6f_bit5                    = $%00100000
    b6f_BadSpeedo1		= $%00010000    ; Stuck Off
    b6f_BadSpeedo2              = $%00001000    ; Stuck On
    b6f_BadASD			= $%00000100    ; ASD Test
    b6f_Alternator1	        = $%00000010    ; Alternator test
    b6f_Alternator2	        = $%00000001    ; Alternator test
    b6f_AlternatorBits		= $%00000011    ;
BitFlags70                                                 == 0x0070
    b70_bit7			= $%10000000
    b70_bit6			= $%01000000
    b70_O2Enable                = $%00100000
    b70_AlternatorField	        = $%00010000    ; AlternatorField
    b70_bit3		        = $%00001000
    b70_bit2			= $%00000100
    b70_bit1		        = $%00000010
    b70_bit0		        = $%00000001
TargetIdleSpeedHB                                          == 0x0071
TargetIdleSpeedLB                                          == 0x0072
SumOfFuelModifiers_HB                                      == 0x0073
SumOfFuelModifiers_LB                                      == 0x0074
InjectorPulsewidth_HB                                      == 0x0075
InjectorPulsewidth_LB                                      == 0x0076
BaseInjectorPulsewidth_HB                                  == 0x0077
BaseInjectorPulsewidth_LB                                  == 0x0078
EngineRpm_HB                                               == 0x0079
EngineRpm_LB                                               == 0x007A
FilteredEngineRpm_HB                                       == 0x007B
FilteredEngineRpm_LB                                       == 0x007C
ChargeTemp                                                 == 0x007D
BaroPressure                                               == 0x007E
MapVolts                                                   == 0x007F
MapAverageValue_HB                                         == 0x0080
MapAverageValue_LB                                         == 0x0081
MapValue                                                   == 0x0082
Factor_LeanoutOrEnrichTime_MAP                             == 0x0083
TpsAverageValue_HB                                         == 0x0084
TpsAverageValue_LB                                         == 0x0085
TpsVolts                                                   == 0x0086
Factor_LeanoutOrEnrichTime_TPS                             == 0x0087
Timer_DelayBeforeUpdating_MINTHR                           == 0x0088
CoolantTemp                                                == 0x0089
BatteryVolts                                               == 0x008A
RawAirFuelSensInput                                        == 0x008B
LastTpsVolts                                               == 0x008C
LastCoolantTempVolts                                       == 0x008D
ChargeTempRaw                                              == 0x008E
KnockVolts                                                 == 0x008F
AmbientAirTempVolts                                        == 0x0090
TargetBatteryVolts                                         == 0x0091
Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached         == 0x0092
Counter_FallingEdgeEPP_MaxFF                               == 0x0093
Counter_EPP_MaxFF                                          == 0x0094
Factor_StartFuelDecayIntoRunFuel                           == 0x0095
Timer_OpenLoopFraction                                     == 0x0096
Factor_DecelLeanoutWhenMAPDecreasing                       == 0x0097
Timer_OffThrottleFuelEnrich                                == 0x0098
Timer_O2InhibitSwitchingRichIdleToClosedLoop               == 0x0099
Pulsewidth_PartThrottleEnrichment_HB                       == 0x009A
Pulsewidth_PartThrottleEnrichment_LB                       == 0x009B
Pulsewidth_AISEnrichment_HB                                == 0x009C
Pulsewidth_AISEnrichment_LB                                == 0x009D
Counter_O2SensorFeedbackCount_Signed                       == 0x009E
Timer_CountdownFromStartRunForAisFeedback                  == 0x009F
KeyOnOrEngineRunningTime                                   == 0x00A0
Counter_MainLoop                                           == 0x00A1
EngineRunningTimeMaxFF                                     == 0x00A2
EngineRunningTimeBeforeStall                               == 0x00A3
Timer_AlternatorDutyCycle                                  == 0x00A4
MinimumTimerCountBeforeMainloopCanContinue                 == 0x00A5
CountdownTimerFromKeyOn                                    == 0x00A6
Timer_CLTIME_ClosedLoopTimer                               == 0x00A7
Counter_AdaptiveMem_Erase                                  == 0x00A8
Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop      == 0x00A9
AdaptiveCellUpdateTimer_IncrementedEveryDistRisingEdge     == 0x00AA
PointerIntoAdaptiveMemory                                  == 0x00AB
ValueFromAdaptiveMemory                                    == 0x00AC
SparkScatter                                               == 0x00AD
AntiDwellTime_HB                                           == 0x00AE
AntiDwellTime_LB                                           == 0x00AF
SparkScatterFuelstabilizationValue_HB                      == 0x00B0
SparkScatterFuelstabilizationValue_LB                      == 0x00B1
Timer_FuelEnrich                                           == 0x00B2
InjectorLatency                                            == 0x00B3
Timer_OutOfClosedLoopMode                                  == 0x00B4
Timer_O2ToggleDuration                                     == 0x00B5
DesiredNewAisPosition                                      == 0x00B6
Timer_AisChanges                                           == 0x00B7
Timer_AcClutchEngageRestrictionTimer                       == 0x00B8
Timer_AcCutout                                             == 0x00B9
Timer_AisOrO2Sensor                                        == 0x00BA
ACClutchToggleVar                                          == 0x00BB
Counter_AirCond                                            == 0x00BC
Timer_RadSteamingCountdown                                 == 0x00BD
Timer_MinimumFanRun                                        == 0x00BE
Timer_NormalDwell                                          == 0x00BF
Timer_OverboostCountdown                                   == 0x00C0
Timer_Over5PsiBoostMaxFF                                   == 0x00C1
CalculatedSparkAdvance                                     == 0x00C2
Cylinder2Retard                                            == 0x00C3
Cylinder1Retard                                            == 0x00C4
Cylinder3Retard                                            == 0x00C5
Cylinder4Retard                                            == 0x00C6
MaxRetardFromMAP                                           == 0x00C7
WastegateDutyCycleIncreaseFromKnock                        == 0x00C8
KnockSensorThreshold                                       == 0x00C9
Timer_BaroReadInterval                                     == 0x00CA
Timer_BaroReadRpmConditionsSatisfied                       == 0x00CB
Timer_ThermostatDiagnostics                                == 0x00CC
Timer_O2MiddleDiagnostics                                  == 0x00CD
PreviousBoostOverBaro                                      == 0x00CE
BoostDelta_Signed                                          == 0x00CF
EGRVar2                                                    == 0x00D0
DRBOffsetStored_HB                                         == 0x00D1
DRBOffsetStored_LB                                         == 0x00D2
ATMOffset                                                  == 0x00D3
DRBPointer1                                                == 0x00D4
DRBPointer2                                                == 0x00D5
DRBPointer3                                                == 0x00D6
DRBSerialMode                                              == 0x00D7
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
CCDVar0                                                    == 0x00D8
    ccd_ErrBit		        = $%10000000	; CCD Error
    ccd_bit6		        = $%01000000	;
    ccd_bit5		        = $%00100000	;
    ccd_bit4		        = $%00010000	;
    ccd_bit3			= $%00001000	;
    ccd_bit2			= $%00000100	;
    ccd_bit1			= $%00000010	;
    ccd_bit0			= $%00000001	;
CCDTemp_HB                                                 == 0x00D9
CCDTemp_LB                                                 == 0x00DA
CCDFuelOutput_HB                                           == 0x00DB
CCDFuelOutput_LB                                           == 0x00DC
CCDFlags1                                                  == 0x00DD
CCDFlags2                                                  == 0x00DE
CCDFlags3                                                  == 0x00DF
CCDFlags4                                                  == 0x00E0
CCDFlags5                                                  == 0x00E1
    ccd_bit7		        = $%10000000	;
    ccd_bit6		        = $%01000000	;
    ccd_AlarmDisable	        = $%00100000	; bit to indicate that the engine should not run due to alarm status
    ccd_bit4		        = $%00010000	;
    ccd_bit3			= $%00001000	;
    ccd_bit2			= $%00000100	;
    ccd_bit1			= $%00000010	;
    ccd_bit0			= $%00000001	;
CCDFlags6                                                  == 0x00E2
VNT_BstCtrl_Counter1                                       == 0x00E3
VNT_BstCtrl_Var2                                           == 0x00E4
CylTrim_Adaptive_Var1                                      == 0x00E5
CylTrim_FlagsE6                                            == 0x00E6
CylTrim_FlagsE7                                            == 0x00E7
Counter_FuelEngRunning                                     == 0x00E8
Counter_CylTrim1                                           == 0x00E9
Counter_CylTrim2                                           == 0x00EA
BaseFuelScalar                                             == 0x00EB
Counter_ACControl1                                         == 0x00EC
BoostTarget                                                == 0x00ED
BaseFuelModifier                                           == 0x00EE
TempX                                                      == 0x00EF

Turbonator_Flags                                           == 0x00F0
    Turbonator_SparkCut	        = $%10000000    ; Turbonator - Spark-based rev limiter
    Turbonator_Staging	        = $%01000000    ; Turbonator - staging limiter is active
    Turbonator_FuelOff          = $%00100000    ; Turbonator - Fuel-based rev limiter
    Turbonator_OverRev          = $%00010000    ; over rev - replaced the original flag for simplicity
    Turbonator_AntiLag          = $%00001000    ; AntiLag is active
    Turbonator_MainFuelOff      = $%00000100    ; Open
    Turbonator_AllowSpark       = $%00000010    ; Allow spark for only this cycle
    Turbonator_DecelFuelCut     = $%00000001    ; use decel fuel cut

AFRatio                                                    == 0x00F1
FinalAdvanceActual                                         == 0x00F2
O2SensorValue                                              == 0x00F3
TurbonatorSwitchState                                      == 0x00F4


; FDRVar0                                                    == 0x00F0
; FDRVar1                                                    == 0x00F1
; FDRVar2                                                    == 0x00F2
; FDRVar3                                                    == 0x00F3
; FDRVar4                                                    == 0x00F4
Temp0                                                      == 0x00F5
Temp1                                                      == 0x00F6
Temp2                                                      == 0x00F7
Temp3                                                      == 0x00F8
Temp4                                                      == 0x00F9
Temp5                                                      == 0x00FA
Temp6                                                      == 0x00FB
Temp7                                                      == 0x00FC
DwellTime_HB                                               == 0x00FD
DwellTime_LB                                               == 0x00FE
L00FF                                                      == 0x00FF

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
CPU_DistPickupCaptureRegHigh	 == 0x1010
CPU_TimerInputCapture2_Speedometer	 == 0x1012
CPU_TimerOutputCompareRegHigh1	 == 0x1016
CPU_Timer_OC2_Wastegate	 == 0x1018
CPU_Timer_OC3_InjectorBDriver	 == 0x101a
CPU_Timer_OC4_InjectorADriver	 == 0x101c
CPU_Timer_OC5_Dwell	 == 0x101e
CPU_TimerControlReg1	 == 0x1020
CPU_TimerControlReg2	 == 0x1021
CPU_TimerInterruptMask1	 == 0x1022
CPU_TimerInterruptFlag1	 == 0x1023
CPU_TimerInterruptMask2	 == 0x1024
CPU_PortA_Control	 == 0x1026

CPU_SerialPeripheralControl	 == 0x1028
    spi_InterruptEnable                 = $%10000000
    spi_SystemEnable                    = $%01000000  ;1
    spi_PortDWORMode                    = $%00100000
    spi_MasterModeEnable                = $%00010000  ;1
    spi_ClockPolarityMode               = $%00001000
    spi_ClockPhaseSelect                = $%00000100  ;1
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

CPU_SerialBaudRate	 == 0x102b
CPU_SerialControlReg1	 == 0x102c
CPU_SerialControlReg2	 == 0x102d
CPU_SerialStatus	 == 0x102e
CPU_SerialData	 == 0x102f
CPU_A2DControlReg	 == 0x1030
CPU_A2DResults1	 == 0x1031
CPU_A2DResults2	 == 0x1032
CPU_A2DResults3	 == 0x1033
CPU_A2DResults4	 == 0x1034
CPU_BlockProtReg	 == 0x1035
CPU_SysConfigOptionReg	 == 0x1039
CPU_ArmResetCopTimerReg	 == 0x103a
CPU_EEPROMControlReg	 == 0x103b
CPU_HighPriorityInterruptMask	 == 0x103c
CPU_SysInit	 == 0x103d
SystemConfigReg	 == 0x103f

SwitchPortAccessReg1	 == 0x6000
    ;sp1_     		        = $%10000000
    sp1_OC1Toggle	        = $%01000000
    sp1_B1Volt		        = $%00100000
    ;sp1_       		= $%00010000
    ;sp1_		        = $%00001000
    ;sp1_			= $%00000100
    ;sp1_		        = $%00000010
    ;sp1_		        = $%00000001

; smec flags
;     sp1_B1Volt     		= $%10000000	; B1 Voltage Sense
;     sp1_ACclutch		= $%01000000	; A/C Clutch input
;     sp1_CruiseSet		= $%00100000	; Cruise Set
;     sp1_bit4       		= $%00010000	;
;     sp1_CruiseOnOff		= $%00001000	; Cruise On/Off
;     sp1_Brake			= $%00000100	; Brake Switch
;     sp1_CruiseResume		= $%00000010	; Cruise Resume
;     sp1_PNswitch		= $%00000001	; Park/Neutral switch

SwitchPortAccessReg2	 == 0x6001

    sp2_CCDBus                  = $%00001000    ;

PIA_Ctrl_1	 == 0x6002
PIA_Ctrl_2	 == 0x6003
PIA_Ctrl_3	 == 0x6004
PIA_Ctrl_4	 == 0x6005
PIA_Ctrl_5	 == 0x6006
InjectorPulsewidthBank1_HB	 == 0x6008
InjectorPulsewidthBank1_LB	 == 0x6009
InjectorPulsewidthBank2_HB	 == 0x600a
InjectorPulsewidthBank2_LB	 == 0x600b
InjectorPulsewidthBank3_HB	 == 0x600c
InjectorPulsewidthBank3_LB	 == 0x600d
InjectorPulsewidthBank4_HB	 == 0x600e
InjectorPulsewidthBank4_LB	 == 0x600f

PIA3_Buffer_2	 == 0x6040
ErrorCodeCounter	 == 0x6080
ErrorCodeBufferHB	 == 0x6081
ErrorCodeBufferLB	 == 0x6082
EGR_Temp_1	 == 0x6083
EGR_Temp_2	 == 0x6084
EGR_Temp_3	 == 0x6085
CCDCounterX	 == 0x6086
Counter_SpeedSensorInterrupt_HB_X	 == 0x6087
CCDFlags3x	 == 0x6088
MAPOffsetForCylTrim	 == 0x6089
DeltaBoostSampleCounter	 == 0x608a
MapValue_X	 == 0x608b
MapVolts_X	 == 0x608c
BitFlags608D	 == 0x608d
BatVoltsDiagCounter	 == 0x608e
A2DResults2Temp	 == 0x608f
ColdStartFuelReduxCounter	 == 0x6090
SparkScatterIncrement	 == 0x6091
O2AdvanceIncrement	 == 0x6092
CalculatedSparkAdvanceTemp	 == 0x6093
Counter_O2Diagnostics	 == 0x6094
ScaledDistPWForCruiseControl	 == 0x6095
VNTOverboostSampleCounter1	 == 0x6096
VNTOverboostSampleCounter2	 == 0x6098
DRB_ProgramModeFlag	 == 0x609a
DRB_SpecialProgramRoutine	 == 0x609c

;------------------------------------------------------------------------------

; Pretty sure this space actually exsists
; So, I'll use it for the Turbonator Mods...
; Turbonator_Flags    == 0x60a3
;     Turbonator_SparkCut	        = $%10000000    ; Turbonator - Spark-based rev limiter
;     Turbonator_Staging	        = $%01000000    ; Turbonator - staging limiter is active
;     Turbonator_FuelOff          = $%00100000    ; Turbonator - Fuel-based rev limiter
;     Turbonator_OverRev          = $%00010000    ; over rev - replaced the original flag for simplicity
;     Turbonator_AntiLag          = $%00001000    ; AntiLag is active
;     Turbonator_Bit2             = $%00000100    ; Open
;     Turbonator_AllowSpark       = $%00000010    ; Allow spark for only this cycle
;     Turbonator_DecelFuelCut     = $%00000001    ; use decel fuel cut

Pattern_SparkCut    == 0x60a5
Counter_SparkCut    == 0x60a6
; FinalAdvanceActual  == 0x60a7
; O2SensorValue       == 0x60a8
;AFRatio             == 0x60a9
NO2Retard           == 0x60aa
Counter_PartThrottleUnlock == 0x60ab
PTU_MapTemp         == 0x60ac


;------------------------------------------------------------------------------

L60E1	 == 0x60e1
L60E2	 == 0x60e2
CPU_TimerCounterRegHighX	 == 0x60e4

TopOfStack == 0x60ff


; *****************************************************************************
; load cal data
; *****************************************************************************

        .include /CalDataFile/

; *****************************************************************************
; begin code
; *****************************************************************************

	.org CodeOrg
        .msg "Assembling Code..."



InterruptPointer_MainRealTimeInterrupt:
           jmp  Interrupt_RealTime_X

InterruptPointer_SerialPeripheralInterface:
           jmp  Interrupt_RealTime

InterruptPointer_PulseAccumulatorInputEdge:
           jmp  Interrupt_PulseAccumulatorInputEdge

InterruptPointer_PulseAccumulatorOverflow:
           jmp  Interrupt_PulseAccumulatorInputEdge

InterruptPointer_TimerOverflow:
           jmp  Interrupt_RealTime

InterruptPointer_DwellTimer:
           jmp  InterruptVector_DwellTimer

InterruptPointer_TimerOutputCapture4:
           jmp  Interrupt_TimerOC4_VNTActuator

InterruptPointer_TimerOutputCapture3:
           jmp  Interrupt_TimerOC3_Wastegate

InterruptPointer_TimerOC2_Wastegate:
           jmp  Interrupt_PulseAccumulatorInputEdge

InterruptPointer_TimerOutputCapture1:
           jmp  Interrupt_TimerOutputCapture1

InterruptPointer_TimerInputCapture3:
           jmp  Interrupt_RealTime

InterruptPointer_SpeedoSignal:
           jmp  Interrupt_SpeedometerSignal

InterruptPointer_DistributorSignal:
           jmp  InterruptVector_DistributorSignal

InterruptPointer_RealTime:
           jmp  Interrupt_RealTime

InterruptPointer_PIA_Signal:
           jmp  Interrupt_PIA_Signal

InterruptPointer_XIRQ:
           jmp  Interrupt_XIRQ

InterruptPointer_Software:
           jmp  Interrupt_Software

InterruptPointer_BadOp:
           jmp  Interrupt_BadOp

InterruptPointer_COPFail:
           jmp  Interrupt_COPFail

InterruptPointer_ClockMonFail:
           jmp  Interrupt_ClockMonFail

Interrupt_TimerOutputCapture1:
           ldaa #0x80          ; load a with value -10000000-
           staa CPU_TimerInterruptFlag1
           ldaa #0x10          ; load a with value -00010000-
           staa CPU_A2DControlReg
           ldd  CPU_TimerOutputCompareRegHigh1
           addd #0x03be        ;  -00000011 10111110-
           cmpD CPU_TimerCounterRegHigh    ; compare D
           bpl  L9058          ; branch if plus (hi bit 0)
           ldd  CPU_TimerCounterRegHigh
           addd #0x03be        ;  -00000011 10111110-
   L9058:  addd #0x0004        ;  -00000000 00000100-
           std  CPU_TimerOutputCompareRegHigh1
           ldaa CPU_TimerInterruptMask1    ; load a with memory contents
           anda #0x7f          ; AND a with value -01111111-
           staa CPU_TimerInterruptMask1
           ldaa Timer_AlternatorDutyCycle    ; load a with memory contents
           inca                ; increment a
           staa Timer_AlternatorDutyCycle    ; store a into memory
           cli                 ; enable interrupts
           ldaa Timer_AlternatorDutyCycle    ; load a with memory contents
           lsra            
           bcc  ControlAlternator    ; branch if greater or equal
           jmp  L911B      

ControlAlternator:
           ldaa ATMOffset      ; load a with memory contents
           cmpa #0x0d          ; compare a with value -00001101-
           beq  L907E          ; branch if equal (zero)
           cmpa #0x14          ; compare a with value -00010100-
           bne  L9081          ; branch if not equal (not zero)
   L907E:  jmp  L9118      

   L9081:  ldx  #SwitchPortAccessReg1    ; load index with value
           brset *BitFlags6d, #b6d_FuelEngineNotRunning, TurnAlternatorOff    ; branch if bit(s) set
           ldab #0x11          ; load b with value -00010001-
           brset *BitFlags6f, #b6f_Alternator1, L9090    ; branch if bit(s) set
           ldab #0x15          ; load b with value -00010101-
   L9090:  bclr *BitFlags6f, #b6f_Alternator1    ; clear bits
           cmpb EngineRpm_HB
           bhi  TurnAlternatorOff    ; branch if higher
           bset *BitFlags6f, #b6f_Alternator1    ; set bits
           ldaa CPU_A2DResults2    ; load a with memory contents
           cmpa BatteryVolts    ; compare a with memory contents
           bcc  L90A3          ; branch if greater or equal
           staa BatteryVolts    ; store a into memory
   L90A3:  cmpa #0x41          ; compare a with value -01000001-
           bcc  L90AD          ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x06          ;  -00000110-
           bne  TurnAlternatorOff    ; branch if not equal (not zero)
   L90AD:  brclr *BitFlags70, #b70_bit3, L90CE    ; branch if bit(s) clear
           ldaa A2DResults2Temp    ; load a with memory contents
           bne  L90BE          ; branch if not equal (not zero)
           ldaa CPU_A2DResults2    ; load a with memory contents
           staa A2DResults2Temp
           bra  TurnAlternatorOff    ; branch

   L90BE:  suba CPU_A2DResults2
           bls  TurnAlternatorOff    ; branch if lower or same
           cmpa BTVHYS_BatteryVoltsHysteresisForAlternatorControl    ; compare a with memory contents (data is 04)
           bls  TurnAlternatorOff    ; branch if lower or same
           bset *BitFlags70, #b70_bit2    ; set bits
           bclr *BitFlags70, #b70_bit3    ; clear bits
   L90CE:  clr  A2DResults2Temp    ; zero byte at memory location
           ldaa CPU_A2DResults2    ; load a with memory contents
           suba TargetBatteryVolts
           bne  L90DE          ; branch if not equal (not zero)
           brclr  0, X, #$%00000100, TurnAlternatorOn    ; branch if bit(s) clear
           bra  TurnAlternatorOff    ; branch

   L90DE:  ldab #0x0e          ; load b with value -00001110-
           bcc  L90F1          ; branch if greater or equal
           nega                ; negate a (set high bit)
           cmpa #0x02          ; compare a with value -00000010-
           beq  L90EB          ; branch if equal (zero)
           bcc  TurnAlternatorOn    ; branch if greater or equal
           ldab #0x06          ; load b with value -00000110-
   L90EB:  andb Timer_AlternatorDutyCycle
           beq  TurnAlternatorOff    ; branch if equal (zero)
           bra  TurnAlternatorOn    ; branch

   L90F1:  cmpa #0x02          ; compare a with value -00000010-
           beq  L90F9          ; branch if equal (zero)
           bcc  TurnAlternatorOff    ; branch if greater or equal
           ldab #0x06          ; load b with value -00000110-
   L90F9:  andb Timer_AlternatorDutyCycle
           bne  TurnAlternatorOff    ; branch if not equal (not zero)
TurnAlternatorOn:
           bset  0, X, #$%00000100    ; bit set
           bset *BitFlags6f, #b6f_BadASD    ; set bits
           bra  L910B          ; branch

TurnAlternatorOff:
           bclr  0, X, #$%00000100    ; bit clear
           bclr *BitFlags6f, #b6f_BadASD    ; clear bits
   L910B:  sei                 ; disable interrupts
           bset  2, X, #$%00000100    ; bit set
           ldaa #0x12          ; load a with value -00010010-
   L9111:  deca                ; decrement a
           bne  L9111          ; branch if not equal (not zero)
           bclr  2, X, #$%00000100    ; bit clear
           cli                 ; enable interrupts
   L9118:  jmp  XmitRequestedRamLocation

   L911B:  brset *BitFlags_AIS, #b10_UseAIS, AisDriveRoutine    ; branch if bit(s) set
           lsra            
           bcs  L9118          ; branch if lower
AisDriveRoutine:
           ldaa BatteryVolts    ; load a with memory contents
           cmpa BTVAIS_MinVoltageForAis    ; compare a with memory contents (data is 71)
           bcs  XmitRequestedRamLocation    ; branch if lower
           brset *BitFlags69, #b69_bit3, XmitRequestedRamLocation    ; branch if bit(s) set
           ldab CountdownTimerFromKeyOn    ; load b with memory contents
           bne  XmitRequestedRamLocation    ; branch if not equal (not zero)
           ldaa #0x01          ; load a with value -00000001-
           ldab CurrentAisPosition    ; load b with memory contents
           brclr *BitFlags_AIS, #b10_UseAIS, L9144    ; branch if bit(s) clear
           bne  L914A          ; branch if not equal (not zero)
           bclr *BitFlags_AIS, #b10_UseAIS    ; clear bits
           bra  XmitRequestedRamLocation    ; branch

	;.org	0x9140
AISTEP_BitPatternForAisControl:
       .byte   0x06                              ; byte 1
       .byte   0x05                              ; byte 2
       .byte   0x09                              ; byte 3
       .byte   0x0A                              ; byte 4

   L9144:  cmpb DesiredNewAisPosition
           beq  L9166          ; branch if equal (zero)
           bcs  L914B          ; branch if lower
   L914A:  nega                ; negate a (set high bit)
   L914B:  tab                 ; b = a
           ldx  #AISTEP_BitPatternForAisControl    ; load index with value
           addb BitFlags_36    ; b=b+memory contents
           andb #0x03          ;  -00000011-
           abx                 ; add b to index
           sei                 ; disable interrupts
           stab Temp7          ; store b into memory
           ldab BitFlags_36    ; load b with memory contents
           andb #0xfc          ;  -11111100-
           orab Temp7      
           cli                 ; enable interrupts
           stab BitFlags_36    ; store b into memory
           adda CurrentAisPosition
           staa CurrentAisPosition    ; store a into memory
           bra  L917F          ; branch

   L9166:  brset *BitFlags6c, #b6c_bit6, XmitRequestedRamLocation    ; branch if bit(s) set
           ldd  #0x80ff    ; load d (a&b) with value -10000000 11111111-
           jsr  SetPIAOutputBits    ; call subroutine
           ldab BitFlags_36    ; load b with memory contents
           andb #0x03          ;  -00000011-
           ldx  #AISTEP_BitPatternForAisControl    ; load index with value
           abx                 ; add b to index
           ldab 0x00, X        ; load b with memory at index + value
           anda #0x0f          ; AND a with value -00001111-
           cba             
           beq  XmitRequestedRamLocation    ; branch if equal (zero)
   L917F:  ldab 0x00, X        ; load b with memory at index + value
           ldaa #0x90          ; load a with value -10010000-
           jsr  SetPIAOutputBits    ; call subroutine
           bset *BitFlags6e, #b6e_PIAKeepIntEnabled    ; set bits
           ldd  #0xbc0f        ; load d (a&b) with value -10111100 00001111-
           jsr  SetPIAOutputBits    ; call subroutine
           bclr *BitFlags6e, #b6e_PIAKeepIntEnabled    ; clear bits
           ldd  #0xb80f        ; load d (a&b) with value -10111000 00001111-
           jsr  SetPIAOutputBits    ; call subroutine

XmitRequestedRamLocation:
           brclr *DRBSerialMode, #$%10000000, L91EF    ; branch if bit(s) clear
           ldaa CPU_SerialStatus    ; load a with memory contents
           bita #0x0e          ;  -00001110-
           beq  L91A8          ; branch if equal (zero)
           ldab CPU_SerialData    ; load b with memory contents
           bra  L91EF          ; branch

   L91A8:  bita #0x20          ;  -00100000-
           beq  L91EF          ; branch if equal (zero)
           ldab CPU_SerialData    ; load b with memory contents
           cmpb #0xf2          ;  -11110010-
           bne  L91B8          ; branch if not equal (not zero)
           bclr *BitFlags6c, #b6c_DRBModeFlag    ; clear bits
           bra  L91EC          ; branch

   L91B8:  cmpb #0xf6          ;  -11110110-
           bne  L91C1          ; branch if not equal (not zero)
           bset *BitFlags6c, #b6c_DRBModeFlag    ; set bits
           bra  L91EC          ; branch

   L91C1:  cmpb #0xfe          ;  -11111110-
           bne  L91CB          ; branch if not equal (not zero)
           bclr *DRBSerialMode, #$%10110000    ; clear bits
           bclr *BitFlags6c, #b6c_DRBModeFlag    ; clear bits
   L91CB:  ldaa BitFlags6c     ; load a with memory contents
           bita #b6c_DRBModeFlag          ;  -00010000-
           bne  L91D9          ; branch if not equal (not zero)
           ldx  #L0000         ; load index with value
           abx                 ; add b to index
           ldab 0x00, X        ; load b with memory at index + value
           bra  L91EC          ; branch

   L91D9:  ldaa FastDataOutputCommandByte    ; load a with memory contents (data is 18)
           cba             
           bhi  L91E3          ; branch if higher
           ldab #0xff          ; load b with value -11111111-
           bra  L91EC          ; branch

   L91E3:  ldx  #FastDataOutputAddressTable    ; load index with value
           lslb            
           abx                 ; add b to index
           ldx  0x00, X    
           ldab 0x00, X        ; load b with memory at index + value
   L91EC:  stab CPU_SerialData    ; store b into memory
   L91EF:  jsr  CCDBusComs     ; call subroutine
           jsr  LAFED          ; call subroutine
           ldaa CPU_A2DResults1    ; load a with memory contents
           brset *BitFlags6b, #$%00000100, L9200    ; branch if bit(s) set
           brclr *Counter_MainLoop, #$%00111111, L920F    ; branch if bit(s) clear
   L9200:  cmpa MapVolts_X     ; compare a with memory contents
           bcs  L9212          ; branch if lower
           cmpa MapValue_X     ; compare a with memory contents
           bls  L9215          ; branch if lower or same
           staa MapValue_X 
           bra  L9215          ; branch

   L920F:  staa MapValue_X 
   L9212:  staa MapVolts_X 
   L9215:  sei                 ; disable interrupts
           ldaa #0x80          ; load a with value -10000000-
           oraa CPU_TimerInterruptMask1
           staa CPU_TimerInterruptMask1
           rti                 ; return from interrupt

VerifyOperationOfBatteryVoltage_MM:
           brset *BitFlags70, #b70_bit2, L928A    ; branch if bit(s) set
           brset *b5d_IPL2, #b5d_EMRLight, L928A    ; branch if bit(s) set
           brset *b5c_IPL1, #b5c_Bad_BatVolts, L928A    ; branch if bit(s) set
           ldaa TargetBatteryVolts    ; load a with memory contents
           suba CPU_A2DResults2
           bcs  L928A          ; branch if lower
           cmpa BTVLMT_BatteryVoltsDiagLimitOverTarget    ; compare a with memory contents (data is 10)
           bcs  L928A          ; branch if lower
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa BTLRPM_LowBatteryVoltageAtThisRpm1500    ; compare a with memory contents (data is 2e)
           bcs  L928A          ; branch if lower
           ldaa #0x0f          ; load a with value -00001111-
           brclr *BitFlags70, #b70_bit1, L9245    ; branch if bit(s) clear
           clra                ; a = 0
   L9245:  anda Counter_MainLoop    ; logical and a with memory contents
           bne  L9261          ; branch if not equal (not zero)
           ldaa BatVoltsDiagCounter    ; load a with memory contents
           inca                ; increment a
           beq  L9252          ; branch if equal (zero)
           staa BatVoltsDiagCounter
   L9252:  brset *BitFlags70, #b70_bit1, L9262    ; branch if bit(s) set
           cmpa BTVCNT_BatteryVoltsDiagCounterMax    ; compare a with memory contents (data is 8e)
           bcs  L9261          ; branch if lower
           clr  BatVoltsDiagCounter    ; zero byte at memory location
           bset *BitFlags70, #b70_bit1    ; set bits
   L9261:  rts                 ; return from subroutine

   L9262:  brset *BitFlags70, #b70_bit3, L9272    ; branch if bit(s) set
           cmpa BTVCN2_BatteryVoltsDiagCounterMax2    ; compare a with memory contents (data is 7f)
           bcs  L9261          ; branch if lower
           clr  BatVoltsDiagCounter    ; zero byte at memory location
           bset *BitFlags70, #b70_bit3    ; set bits
           rts                 ; return from subroutine

   L9272:  cmpa BTVCN3_BatteryVoltsDiagCounterMin    ; compare a with memory contents (data is 06)
           bcs  L9261          ; branch if lower
           clr  BatVoltsDiagCounter    ; zero byte at memory location
           bclr *BitFlags70, #b70_bit3    ; clear bits
           ldd  #0x058a        ; load d (a&b) with value -00000101 10001010-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  L9261          ; branch if greater or equal
           bset *b5d_IPL2, #b5d_EMRLight    ; set bits
           bra  L928D          ; branch

   L928A:  clr  BatVoltsDiagCounter    ; zero byte at memory location
   L928D:  bclr *BitFlags70, #b70_bit3 | b70_bit2 | b70_bit1    ; clear bits
           rts                 ; return from subroutine

HandleBaroReadRequirement_MM:
           brclr *BitFlags6d, #b6d_FuelEngineNotRunning, EngRunning    ; branch if bit(s) clear
           bset *PIA2_Buffer, #pi2_Baro    ; set bits
           rts                 ; return from subroutine

EngRunning:
           ldab BitFlags68     ; load b with memory contents
           bmi  THROTTLE_PREVIOUSLY_NOTPRESSED    ; branch if minus(hi bit 1)
           ldaa Timer_BaroReadInterval    ; load a with memory contents
           tst  Counter_MainLoop
           bne  THROTTLE_PREVIOUSLY_NOTPRESSED    ; branch if not equal (not zero)
           inca                ; increment a
           beq  THROTTLE_PREVIOUSLY_NOTPRESSED    ; branch if equal (zero)
           staa Timer_BaroReadInterval    ; store a into memory
THROTTLE_PREVIOUSLY_NOTPRESSED:
           ldaa BitFlags66     ; load a with memory contents
           bpl  ReadBaroIfPossible    ; branch if plus (hi bit 0)
           bset *PIA2_Buffer, #pi2_Baro    ; set bits
           clra                ; a = 0
           staa Timer_BaroReadRpmConditionsSatisfied    ; store a into memory
           andb #~(b68_SparkEngineNotRunning | b68_BaroSolEnergized)          ;  -01011111-
           stab BitFlags68     ; store b into memory
           bclr *BitFlags6d, #b6d_BaroOkEngineStopped    ; clear bits
           rts                 ; return from subroutine

ReadBaroIfPossible:
           tstb            
           bmi  THROTTLE_HASNTCHANGED_STILLNOTPRESSED    ; branch if minus(hi bit 1)
           ldx  EngineRpm_HB
           cpx  BRPMHI_BaroReadHighRPM6650    ;  (data is cfd0)
           bhi  L9314          ; branch if higher
           cpx  BRPMLO_BaroReadLowRPM1800    ;  (data is 3840)
           bcs  L9314          ; branch if lower
           ldaa Timer_BaroReadRpmConditionsSatisfied    ; load a with memory contents
           inca                ; increment a
           beq  L92D6          ; branch if equal (zero)
           staa Timer_BaroReadRpmConditionsSatisfied    ; store a into memory
           cmpa BRDLAY_BaroReadDelayAfterThrottleClosed2sec    ; compare a with memory contents (data is b5)
           bcs  L9314          ; branch if lower
   L92D6:  ldaa Timer_BaroReadInterval    ; load a with memory contents
           cmpa BARTIM_BaroReadMinTimeBetweenReadings179sec    ; compare a with memory contents (data is 40)
           bcs  L9314          ; branch if lower
           bitb #0x20          ;  -00100000-
           bne  L9314          ; branch if not equal (not zero)
           bclr *PIA2_Buffer, #pi2_Baro    ; clear bits
           ldab #0x80          ; load b with value -10000000-
           bra  L92FB          ; branch

THROTTLE_HASNTCHANGED_STILLNOTPRESSED:
           inc  Timer_BaroReadInterval
           bitb #0x20          ;  -00100000-
           bne  L92FF          ; branch if not equal (not zero)
           ldaa Timer_BaroReadInterval    ; load a with memory contents
           cmpa BROPTM_BaroReadDelayAfterSolenoidOpenTenthSec    ; compare a with memory contents (data is 09)
           bcs  L9314          ; branch if lower
           ldab #b68_BaroSolEnergized          ; load b with value -00100000-
           bset *BitFlags6d, #b6d_BaroOkEngineStopped    ; set bits
   L92FB:  orab BitFlags68 
           bra  L930F          ; branch

   L92FF:  brset *BitFlags6d, #b6d_BaroOkEngineStopped, L9311    ; branch if bit(s) set
           bset *PIA2_Buffer, #pi2_Baro    ; set bits
           ldaa Timer_BaroReadInterval    ; load a with memory contents
           cmpa BRCLTM_BaroReadDelayAfterSolenoidClosedTenthSec    ; compare a with memory contents (data is 09)
           bcs  L9314          ; branch if lower
           andb #~b68_SparkEngineNotRunning          ;  -01111111-
   L930F:  stab BitFlags68     ; store b into memory
   L9311:  clra                ; a = 0
           staa Timer_BaroReadInterval    ; store a into memory
   L9314:  rts                 ; return from subroutine

SaveBaroPressure:
           jsr  ConvertMAPVoltsToValue    ; call subroutine
           tab                 ; b = a
           cmpb BAROHI_BaroReadValidHighLimit    ; compare b with memory contents (data is 85)
           bcc  L9323          ; branch if greater or equal
           cmpb BAROLO_BaroReadValidLowLimit    ; compare b with memory contents (data is 45)
           bcc  L9326          ; branch if greater or equal
   L9323:  ldab BARDFT_BaroReadDefaultValue    ; load b with memory contents (data is 7f)
   L9326:  stab BaroPressure    ; store b into memory
           rts                 ; return from subroutine

ControlAsdRelay_MM:
           ldaa DRBPointer1    ; load a with memory contents
           cmpa #0x18          ; compare a with value -00011000-
           bne  CONTROL_AUTOSHUTDOWN_RELAY_ROUTINE1    ; branch if not equal (not zero)
           ldaa DRBSerialMode    ; load a with memory contents
           bita #0x30          ;  -00110000-
           bne  CONTROL_AUTOSHUTDOWN_RELAY_ROUTINE1    ; branch if not equal (not zero)
           ldaa TimerOverflowsBetweenDistPulses    ; load a with memory contents
           cmpa #0x50          ; compare a with value -01010000-
           bls  L936C          ; branch if lower or same
           brset *BitFlags70, #b70_O2Enable, L936C    ; branch if bit(s) set
           ldaa DRBPointer2    ; load a with memory contents
           tab                 ; b = a
           anda #0x0f          ; AND a with value -00001111-
           pshb                ; push b onto stack
           lsrb                ; logical shift right b
           lsrb                ; logical shift right b
           lsrb                ; logical shift right b
           lsrb                ; logical shift right b
           comb            
           andb #0x0f          ;  -00001111-
           cba             
           pulb                ; pull b from stack
           bne  L936F          ; branch if not equal (not zero)
           tst  Counter_MainLoop
           bne  L935F          ; branch if not equal (not zero)
           deca                ; decrement a
           beq  L9372          ; branch if equal (zero)
           andb #0xf0          ;  -11110000-
           addb #0x10          ;  -00010000-
           aba                 ; a=a+b
           staa DRBPointer2    ; store a into memory
   L935F:  ldaa #0xe1          ; load a with value -11100001-
           jsr  SerialOutput1a    ; call subroutine
           ldx  #0xfe00        ; load index with value
           bset *BitFlags6c, #b6c_bit2    ; set bits
           bra  ASD_ToggleOnOff          ; branch

   L936C:  bclr *BitFlags70, #b70_O2Enable    ; clear bits
   L936F:  jsr  SerialOutput1    ; call subroutine
   L9372:  clra                ; a = 0
           staa DRBPointer1    ; store a into memory
           staa DRBPointer2    ; store a into memory
CONTROL_AUTOSHUTDOWN_RELAY_ROUTINE1:
           ldx  #Cyl4_InjPWTrim    ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           cmpa #0x8f          ; compare a with value -10001111-
           bcc  ControlAsdRelay_Over119Ftemp    ; branch if greater or equal
           ldx  #ClearTheErrorTimer_1    ; load index with value
ControlAsdRelay_Over119Ftemp:
           ldab #0x08          ; load b with value -00001000-
           ldaa BatteryVolts    ; load a with memory contents
           cmpa #0xb2          ; compare a with value -10110010-
           brset *BitFlags68, #b68_Past12secRunning, ASD_EngRunningCheckBatVolts    ; branch if bit(s) set
           bcc  ASD_ToggleOnOff          ; branch if greater or equal
           cpx  #ClearTheErrorTimer_1    ;  -00000000 01011011-
           bne  ASD_ToggleOnOff          ; branch if not equal (not zero)
           ldab #0x17          ; load b with value -00010111-
           bra  ASD_ToggleOnOff          ; branch

ASD_EngRunningCheckBatVolts:  
           bcs  ASD_ToggleOnOff          ; branch if lower
           ldab #0x05          ; load b with value -00000101-
ASD_ToggleOnOff:  
           ldaa PIA1_Buffer    ; load a with memory contents
           anda #~pi1_ASD          ; AND a with value -11101111-
           cmpb Counter_TimerPastHalfwayBetweenDistPulses
           bhi  ASD_StoreStateToBuffer          ; branch if higher
           cpx  KeyOnOrEngineRunningTime
           bhi  ASD_StoreStateToBuffer          ; branch if higher
           oraa #pi1_ASD          ;  -00010000-
ASD_StoreStateToBuffer:  
           staa PIA1_Buffer    ; store a into memory
           brset *BitFlags6d, #b6d_FuelEngineNotRunning, L93B9    ; branch if bit(s) set
           ldab KeyOnOrEngineRunningTime    ; load b with memory contents
           cmpb #0x04          ;  -00000100-
           bcs  L93B9          ; branch if lower
           bset *BitFlags68, #b68_Past12secRunning    ; set bits
   L93B9:  rts                 ; return from subroutine

ControlAirConditioning_MM:
           clra                ; a = 0
           brset *BitFlags69, #b69_bit2, SetACClutchBit    ; branch if bit(s) set
           ldaa Counter_AirCond    ; load a with memory contents
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x3f          ;  -00111111-
           bne  L93CC          ; branch if not equal (not zero)
           cmpa #0x01          ; compare a with value -00000001-
           bls  L93CC          ; branch if lower or same
           deca                ; decrement a
   L93CC:  ldab TpsVolts       ; load b with memory contents
           brclr *PIA2_Buffer, #pi2_ACRelay, AIRCONDITIONING_CURRENTLY_OFF    ; branch if bit(s) clear
           addb #0x03          ;  -00000011-
AIRCONDITIONING_CURRENTLY_OFF:
           subb MINTHR_LowestSessionTPS    ; b = b-memory contents
           bls  L93DD          ; branch if lower or same
           cmpb ACOUT_DeltaAboveMinThrottleToCutOutAc    ; compare b with memory contents (data is 8a)
           bhi  SHUTOFF_AIRCONDITIONING    ; branch if higher
   L93DD:  ldx  EngineRpm_HB
           cpx  ACCRPM_DoNotAllowAcToEngageAboveThisRPM_4000    ;  (data is 7d00)
           bcc  StoreACCounterAndReturn          ; branch if greater or equal
           cpx  TargetIdleSpeedHB
           bcc  L9419          ; branch if greater or equal
           cpx  ACLRPM_DisableAcBelowThisRPM_500    ;  (data is 0fa0)
           bhi  L93F8          ; branch if higher
SHUTOFF_AIRCONDITIONING:
           tsta                ; test a
           bne  SetACClutchBit          ; branch if not equal (not zero)
           ldaa ACCNTI_ACCounterInitial    ; load a with memory contents (data is 06)
SetACClutchBit:
           bset *PIA2_Buffer, #pi2_ACRelay    ; set bits
           bra  StoreACCounterAndReturn          ; branch

   L93F8:  brclr *BitFlags6c, #b6c_bit1, StoreACCounterAndReturn    ; branch if bit(s) clear
           brset *PIA2_Buffer, #pi2_ACRelay, StoreACCounterAndReturn    ; branch if bit(s) set
           cpx  #0x1f40        ;  996rpm
           bcc  SetACClutchBit          ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x03          ;  -00000011-
           bne  StoreACCounterAndReturn          ; branch if not equal (not zero)
           ldab Counter_ACControl1    ; load b with memory contents
           incb            
           stab Counter_ACControl1    ; store b into memory
           cmpb #0x5d          ;  -01011101-
           bcs  StoreACCounterAndReturn          ; branch if lower
           bset *BitFlags6c, #b6c_bit3    ; set bits
           bra  StoreACCounterAndReturn          ; branch

   L9419:  cmpa #0x01          ; compare a with value -00000001-
           bhi  SetACClutchBit          ; branch if higher
           clra                ; a = 0
           brclr *BitFlags6c, #b6c_bit1, ClearACClutchBit    ; branch if bit(s) clear
           cpx  #0x1f40        ;  -00011111 01000000-
           bcc  SetACClutchBit          ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x03          ;  -00000011-
           bne  ClearACClutchBit          ; branch if not equal (not zero)
           ldab Counter_ACControl1    ; load b with memory contents
           incb            
           stab Counter_ACControl1    ; store b into memory
           cmpb #0x5d          ;  -01011101-
           bcs  ClearACClutchBit          ; branch if lower
           bset *BitFlags6c, #b6c_bit3    ; set bits
ClearACClutchBit:
           bclr *PIA2_Buffer, #pi2_ACRelay    ; clear bits
StoreACCounterAndReturn:  
           staa Counter_AirCond    ; store a into memory
           rts                 ; return from subroutine

DetermineTargetBatteryVoltage_MM:
           ldaa AmbientAirTempVolts    ; load a with memory contents
           cmpa AMBLOW_BattTempLowWhenHot    ; compare a with memory contents (data is 05)
           bcs  AmbientTempSensorFault    ; branch if lower
           cmpa AMBHIG_BattTempHighWhenCold    ; compare a with memory contents (data is fa)
           bls  AmbientTempSensorValid    ; branch if lower or same
AmbientTempSensorFault:
           ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x7f          ;  -01111111-
           bne  L9486          ; branch if not equal (not zero)
           ldd  #0x0208        ; load d (a&b) with value -00000010 00001000-
           jsr  ThrowNonCriticalError    ; call subroutine
           ldaa #0xe3          ; load a with value -11100011-
           bra  L946C          ; branch

AmbientTempSensorValid:
           ldab #0x20          ; load b with value -00100000-
           mul                 ; multiply (d=a*b)
           adca #0xd1          ;  -11010001-
           cmpa #0xec          ; compare a with value -11101100-
           bcs  L9466          ; branch if lower
           ldaa #0xec          ; load a with value -11101100-
   L9466:  cmpa #0xd8          ; compare a with value -11011000-
           bcc  L946C          ; branch if greater or equal
           ldaa #0xd8          ; load a with value -11011000-
   L946C:  staa Temp0          ; store a into memory
           ldab CCDBatteryVoltsOutput    ; load b with memory contents
           addb #0xf8          ;  -11111000-
           bcs  L9479          ; branch if lower
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           bra  L9484          ; branch

   L9479:  cmpb #0x08          ;  -00001000-
           bhi  L9484          ; branch if higher
           mul                 ; multiply (d=a*b)
           adca Temp0      
           bcc  L9484          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   L9484:  staa TargetBatteryVolts    ; store a into memory
   L9486:  rts                 ; return from subroutine

ControlFan_MM:
           brclr *BitFlags6d, #b6d_FuelEngineNotRunning, PreventRadSteaming    ; branch if bit(s) clear
           jmp  TurnFanOffByTimer

PreventRadSteaming:
           ldab PIA1_Buffer    ; load b with memory contents
           ldaa Timer_RadSteamingCountdown    ; load a with memory contents
           beq  L94AD          ; branch if equal (zero)
           ldaa CoolantTemp    ; load a with memory contents
           cmpa #0xd2          ; compare a with value -11010010-
           bcs  L94AD          ; branch if lower
           ldaa Counter_MainLoop    ; load a with memory contents
           cmpa #0x09          ; compare a with value -00001001-
           bne  L94A3          ; branch if not equal (not zero)
           dec  Timer_RadSteamingCountdown    ; decrement memory contents
   L94A3:  clra                ; a = 0
           bitb #pi1_Fan          ;  -00100000-
           bne  L94A9          ; branch if not equal (not zero)
           inca                ; increment a
   L94A9:  cmpa VehicleSpeed_HB    ; compare a with memory contents
           bcc  TurnFanOn      ; branch if greater or equal
   L94AD:  brset *b5c_IPL1, #b5c_BadCoolantTemp, TurnFanOn    ; branch if bit(s) set
           ldx  #FANTMP1_FanTurnOnTempAbove45Mph    ; load index with value
           ldaa VehicleSpeed_HB    ; load a with memory contents
           cmpa FNSPHI_FanControlSpeedHi          ; compare a with value -00001011-
           bcc  Above44MPH     ; branch if greater or equal
           cmpa FNSPLO_FanControlSpeedLo          ; compare a with value -00001001-
           bcs  Below36MPH     ; branch if lower
           brset *BitFlags68, #b68_SpeedOver40, L94CC    ; branch if bit(s) set
Below36MPH:
           inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
           bclr *BitFlags68, #b68_SpeedOver40    ; clear bits
           bra  L94CC          ; branch

Above44MPH:
           bset *BitFlags68, #b68_SpeedOver40    ; set bits
   L94CC:  ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_AC          ;  -10000000-
           beq  L94D7          ; branch if equal (zero)
           brclr *PIA2_Buffer, #pi2_ACRelay, TurnFanOn    ; branch if bit(s) clear
   L94D7:  bitb #0x20          ;  -00100000-
           bne  L94DC          ; branch if not equal (not zero)
           inx                 ; increment index (x=x+1)
   L94DC:  ldaa 0x00, X        ; load a with memory at index + value
           cmpa CoolantTemp    ; compare a with memory contents
           bcs  TurnFanOn      ; branch if lower
           ldaa BaroPressure    ; load a with memory contents
           adda FANMAP_FanTurnsOnWhenMapAboveBaroPlusThis    ;  (data is 22)
           bcs  TurnFanOffByTimer    ; branch if lower
           bitb #0x20          ;  -00100000-
           beq  CheckFor_FANMAP    ; branch if equal (zero)
           adda #0x03          ;  -00000011-
           bcs  TurnFanOffByTimer    ; branch if lower
CheckFor_FANMAP:
           cmpa MapValue       ; compare a with memory contents
           bcc  TurnFanOffByTimer    ; branch if greater or equal
           ldaa AmbientAirTempVolts    ; load a with memory contents
           cmpa AMBLOW_BattTempLowWhenHot    ; compare a with memory contents (data is 05)
           bcs  TurnFanOffByTimer    ; branch if lower
           bitb #0x20          ;  -00100000-
           bne  L9502          ; branch if not equal (not zero)
           deca                ; decrement a
           deca                ; decrement a
   L9502:  cmpa FANBAT_FanTurnsOnWhenBatteryTempAboveThis    ; compare a with memory contents (data is bb)
           bcc  TurnFanOffByTimer    ; branch if greater or equal
TurnFanOn:
           brset *BitFlags68, #b68_SparkEngineNotRunning, L953F    ; branch if bit(s) set
           brclr *PIA1_Buffer, #pi1_Fan, L953F    ; branch if bit(s) clear
           andb #0xdf          ;  -11011111-
           ldaa #0x5b          ; load a with value -01011011-
           staa Timer_MinimumFanRun    ; store a into memory
           ldaa AISFAN_AisKickWhenFanTurnsOnClosedThrottle    ; load a with memory contents (data is 0a)
           beq  L953D          ; branch if equal (zero)
           adda DesiredNewAisPosition
           bcs  L9523          ; branch if lower
           cmpa AISHLM_AisHighLimitMaxOpenSteps    ; compare a with memory contents (data is a0)
           bls  L9526          ; branch if lower or same
   L9523:  ldaa AISHLM_AisHighLimitMaxOpenSteps    ; load a with memory contents (data is a0)
   L9526:  staa DesiredNewAisPosition    ; store a into memory
           clra                ; a = 0
           staa Timer_AisChanges    ; store a into memory
           bra  L953D          ; branch

TurnFanOffByTimer:
           ldaa Timer_MinimumFanRun    ; load a with memory contents
           beq  TurnFanOff     ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_MinimumFanRun    ; store a into memory
           rts                 ; return from subroutine

TurnFanOff:
           ldab PIA1_Buffer    ; load b with memory contents
           orab #pi1_Fan          ;  -00100000-
           brset *BitFlags68, #b68_SparkEngineNotRunning, L953F    ; branch if bit(s) set
   L953D:  stab PIA1_Buffer    ; store b into memory
   L953F:  rts                 ; return from subroutine

CalculateAisPosition_MM:
           ldaa BitFlags6d     ; load a with memory contents
           oraa BitFlags66     ; OR a with memory contents
           bmi  L954E          ; branch if minus(hi bit 1)
           ldaa b5c_IPL1       ; load a with memory contents
           anda #0xa0          ; AND a with value -10100000-
           oraa TimerOverflowsBetweenDistPulses    ; OR a with memory contents
           beq  L954F          ; branch if equal (zero)
   L954E:  rts                 ; return from subroutine

   L954F:  ldaa Timer_DacalCountdown    ; load a with memory contents
           lsra            
           lsra            
           adda DANOM_Base_nominalCal    ;  (data is 12)
           bcc  L955A          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   L955A:  ldab DistributorFallingEdgePulsewidth_HB    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           asld                ; shift left (d=d*2)
           bcs  L9563          ; branch if lower
           asld                ; shift left (d=d*2)
           bcc  L9565          ; branch if greater or equal
   L9563:  ldaa #0xff          ; load a with value -11111111-
   L9565:  staa TempX          ; store a into memory
           ldx  #TIMEDC_AISDecelBaseAirflowCurveOffset    ; load index with value
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp0          ; store a into memory
           ldx  #TEMPDC_AISDecel_FromTemp    ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           adda Temp0
           bcs  L9586          ; branch if lower
           brset *PIA2_Buffer, #pi2_ACRelay, L9588    ; branch if bit(s) set
           adda DAACF_ACFactorDeltaFromBase    ;  (data is 0f)
           bcc  L9588          ; branch if greater or equal
   L9586:  ldaa #0xff          ; load a with value -11111111-
   L9588:  ldab DistributorFallingEdgePulsewidth_HB    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           asld                ; shift left (d=d*2)
           bcs  L9591          ; branch if lower
           asld                ; shift left (d=d*2)
           bcc  L9593          ; branch if greater or equal
   L9591:  ldaa #0xff          ; load a with value -11111111-
   L9593:  staa Temp0          ; store a into memory
           ldx  #MAPFLR_AISAdditionToControlMap_FromRpm    ; load index with value
           ldaa EngineRpm_HB    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp1          ; store a into memory
           ldx  #MPTEMP_TempTermForMapOffset_FromTemp    ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp1          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           adca Temp0      
           bcs  L95BC          ; branch if lower
           staa Temp0          ; store a into memory
           ldx  #BARFLR_OffsetCorrectionTo_MAPFLR_FromBaro    ; load index with value
           ldaa BaroPressure    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           adda Temp0      
           bcc  L95BE          ; branch if greater or equal
   L95BC:  ldaa #0xff          ; load a with value -11111111-
   L95BE:  adda TempX      
           bcc  L95C4          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   L95C4:  staa MAPOffsetForCylTrim
           brclr *BitFlags67, #b67_FallToIdle, L95CD    ; branch if bit(s) clear
           staa TempX          ; store a into memory
   L95CD:  ldaa TempX          ; load a with memory contents
           ldab Timer_CountdownFromStartRunForAisFeedback    ; load b with memory contents
           bne  L964E          ; branch if not equal (not zero)
           brset *BitFlags67, #b67_IdleSpeedMode, L964E    ; branch if bit(s) set
           brset *BitFlags_AIS, #b10_bit7, L964E    ; branch if bit(s) set
           brset *BitFlags67, #b67_FallToIdle, L964F    ; branch if bit(s) set
           ldab CONFIG_ConfigurationFlags    ; load b with memory contents (data is 9f)
           bitb #cfg_ATX          ;  -00100000-
           beq  L95EA          ; branch if equal (zero)
           brclr *StartupSwitchMirror1, #sw1_PNswitch, L964E    ; branch if bit(s) clear
   L95EA:  ldab KeyOnOrEngineRunningTime    ; load b with memory contents
           cmpb DCALTM_DacalInhibitTimeAfterStartup    ; compare b with memory contents (data is 15)
           bcs  L964E          ; branch if lower
           brclr *PIA2_Buffer, #pi2_ACRelay, L964E    ; branch if bit(s) clear
           ldab CoolantTemp    ; load b with memory contents
           cmpb DATHOT_EngineTempToStartCalibratingDacal    ; compare b with memory contents (data is cd)
           bls  L964E          ; branch if lower or same
           ldab Counter_MainLoop    ; load b with memory contents
           bitb DCALRT_DacalUpdateRate01_03_07_0f_1f_3f_7f_ff    ;  (data is 3f)
           bne  L961E          ; branch if not equal (not zero)
           ldab TargetIdleSpeedHB    ; load b with memory contents
           subb EngineRpm_HB    ; b = b-memory contents
           bcc  L960A          ; branch if greater or equal
           negb            
   L960A:  cmpb DADRPM_DeltaRpmFromIdleSpeedForDacalUpdate    ; compare b with memory contents (data is 04)
           bhi  L961E          ; branch if higher
           ldab Timer_DacalCountdown    ; load b with memory contents
           cmpa MapValue       ; compare a with memory contents
           bhi  L9618          ; branch if higher
           incb            
           bne  L961C          ; branch if not equal (not zero)
   L9618:  tstb            
           beq  L961E          ; branch if equal (zero)
           decb            
   L961C:  stab Timer_DacalCountdown    ; store b into memory
   L961E:  ldab Counter_MainLoop    ; load b with memory contents
           bitb CALRAT_AisAdjustRate    ;  (data is 07)
           bne  L964E          ; branch if not equal (not zero)
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  L9630          ; branch if greater or equal
           coma            
           comb            
           addd #L0001         ;  -00000000 00000001-
   L9630:  asld                ; shift left (d=d*2)
           bcs  L964E          ; branch if lower
           asld                ; shift left (d=d*2)
           bcs  L964E          ; branch if lower
           cmpa #0x0a          ; compare a with value -00001010-
           bcc  L964E          ; branch if greater or equal
           ldaa DesiredNewAisPosition    ; load a with memory contents
           cmpa CurrentAisPosition    ; compare a with memory contents
           bne  L964E          ; branch if not equal (not zero)
           cmpa CALPOS_PositionAisMotorIsAtIdle    ; compare a with memory contents (data is 1a)
           beq  L964E          ; branch if equal (zero)
           bhi  L9649          ; branch if higher
           inca                ; increment a
           inca                ; increment a
   L9649:  deca                ; decrement a
           staa DesiredNewAisPosition    ; store a into memory
           staa CurrentAisPosition    ; store a into memory
   L964E:  rts                 ; return from subroutine

   L964F:  ldab Timer_AisChanges    ; load b with memory contents
           cmpb DCLRFQ_TimeBetweenAisPulsesForDecelAis    ; compare b with memory contents (data is 40)
           bcs  L964E          ; branch if lower
           cmpa DCLMIN_MinLimitOnDecelAisControlledMap    ; compare a with memory contents (data is 01)
           bcc  L965E          ; branch if greater or equal
           ldaa DCLMIN_MinLimitOnDecelAisControlledMap    ; load a with memory contents (data is 01)
   L965E:  cmpa DCLMN2_NoAisControlIfMapAndControlMapBelowThis    ; compare a with memory contents (data is 14)
           bcc  L966A          ; branch if greater or equal
           ldab MapValue       ; load b with memory contents
           cmpb DCLMN2_NoAisControlIfMapAndControlMapBelowThis    ; compare b with memory contents (data is 14)
           bcs  L964E          ; branch if lower
   L966A:  ldx  #DAISOP_DecelAisOpenStepsFromNeg_FromDeltaMap    ; load index with value
           suba MapValue   
           bcc  L9675          ; branch if greater or equal
           nega                ; negate a (set high bit)
           ldx  #DAISCL_DecelAisOpenStepsFromPos_FromDeltaMap    ; load index with value
   L9675:  jsr  Lookup4ByteTable    ; call subroutine
           jsr  StoreAndLimitDesiredAisPosition    ; call subroutine
           cmpa CurrentAisPosition    ; compare a with memory contents
           beq  L964E          ; branch if equal (zero)
           clra                ; a = 0
           staa Timer_AisChanges    ; store a into memory
           rts                 ; return from subroutine

KickUpAisBy2DuringDecel_MM:
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x7f          ;  -01111111-
           bne  L96A4          ; branch if not equal (not zero)
   L9689:  brset *BitFlags67, #b67_FallToIdle, L96A4    ; branch if bit(s) set
           brset *b5c_IPL1, #b5c_MapStuck, L96A4    ; branch if bit(s) set
           brset *b5c_IPL1, #b5c_MapBadSignal, L96A4    ; branch if bit(s) set
           ldaa DesiredNewAisPosition    ; load a with memory contents
           oraa CurrentAisPosition    ; OR a with memory contents
           bne  L96A4          ; branch if not equal (not zero)
           adda #0x02          ;  -00000010-
           staa DesiredNewAisPosition    ; store a into memory
           staa CurrentAisPosition    ; store a into memory
           bset *BitFlags68, #b68_ASDon    ; set bits
   L96A4:  rts                 ; return from subroutine



CalculateTargetIdleSpeedAndAisPosition_MM:
           ldaa DRBPointer1    ; load a with memory contents
           cmpa #0x13          ; compare a with value -00010011-
           bne  L96B6          ; branch if not equal (not zero)
           ldaa ATMOffset      ; load a with memory contents
           cmpa #0x07          ; compare a with value -00000111-
           beq  L96B5          ; branch if equal (zero)
           cmpa #0x14          ; compare a with value -00010100-
           bne  L96B6          ; branch if not equal (not zero)
   L96B5:  rts                 ; return from subroutine

; this is the start of the decel fuel cut code...
   L96B6:  brset *BitFlags_AIS, #b10_ATXInGear, L9703    ; branch if bit(s) set
           brset *BitFlags6d, #b6d_FuelEngineNotRunning, ClearDFCFlag    ; branch if bit(s) set
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa DCLMER_MinTimeEngineRunningForDecelFuelShutoff    ; compare a with memory contents (data is 02)
           bls  ClearDFCFlag          ; branch if lower or same
           ldaa CoolantTemp    ; load a with memory contents
           cmpa DCLMCT_MinCoolantTempForDecelFuelShutoff    ; compare a with memory contents (data is d2)
           bls  ClearDFCFlag          ; branch if lower or same
           brset *BitFlags66, #b66_OffIdle, ClearDFCFlag    ; branch if bit(s) set
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           cmpa MPHREF_SwitchPointForDecelIdleAisControl    ; compare a with memory contents (data is 07)
           bcc  ClearDFCFlag          ; branch if greater or equal
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  L96E4          ; branch if greater or equal
           clra                ; a = 0
   L96E4:  brclr *Turbonator_Flags, #Turbonator_DecelFuelCut, L96F8    ; branch if bit(s) clear
           cmpa DCLRPL_EngineRPMLimitForDecelFuelShutoffLow    ; compare a with memory contents (data is 0f)
           bhi  SetDFCFlag          ; branch if higher
           ldaa DCAISI_AISIncrementWhenUsingDecelFuelShut    ; load a with memory contents (data is 00)
           jsr  ClearAisTimer    ; call subroutine
ClearDFCFlag:
           bclr *Turbonator_Flags, #Turbonator_DecelFuelCut    ; clear bits
           bra  L9703          ; branch

   L96F8:  cmpa DCLRPH_EngineRPMLimitForDecelFuelShutoffHigh    ; compare a with memory contents (data is 11)
           bls  ClearDFCFlag          ; branch if lower or same
SetDFCFlag:
           bset *Turbonator_Flags, #Turbonator_DecelFuelCut    ; set bits
           clr  Timer_CountdownFromStartRunForAisFeedback    ; zero byte at memory location
; this is the end of the main pportion of the decel fuel cut code...

   L9703:  ldaa BaroPressure    ; load a with memory contents
           ldx  #BARAIS_AISBaroCompensation    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp1          ; store a into memory
           brclr *BitFlags70, #b70_bit0, L9723    ; branch if bit(s) clear
           brset *BitFlags_AIS, #b10_ATXInGear, L9719    ; branch if bit(s) set
           brclr *BitFlags66, #b66_OffIdle, LoadDiagIdleSpeed    ; branch if bit(s) clear
   L9719:  bclr *BitFlags70, #b70_bit0    ; clear bits
           bra  L9723          ; branch

LoadDiagIdleSpeed:
           ldaa #0x30          ; load a with value -00110000-
           jmp  L97AD      

   L9723:  brclr *BitFlags_AIS, #b10_ATXChngGear, L972A    ; branch if bit(s) clear
           jmp  L97B2      

   L972A:  ldx  #AISCLD_IdleSpeedDrive_FromTemp    ; load index with value
           brset *BitFlags_AIS, #b10_ATXInGear, L9763    ; branch if bit(s) set
           ldaa DRBPointer1    ; load a with memory contents
           cmpa #0x19          ; compare a with value -00011001-
           beq  L9749          ; branch if equal (zero)
           brclr *BitFlags67, #b67_InMotion, L9759    ; branch if bit(s) clear
           ldd  TargetIdleSpeedHB    ; load d (a&b) with memory contents
           subd #L0001         ;  -00000000 00000001-
           bitb #0x3f          ;  -00111111-
           bne  L97B0          ; branch if not equal (not zero)
           bclr *BitFlags67, #b67_InMotion    ; clear bits
           bra  L97B0          ; branch

   L9749:  brset *DRBSerialMode, #$%00100000, L97B2    ; branch if bit(s) set
           clr  DRBPointer1    ; zero byte at memory location
           ldaa DRBPointer2    ; load a with memory contents
           ldab #0xff          ; load b with value -11111111-
           bset *BitFlags67, #b67_InMotion    ; set bits
           bra  L97AE          ; branch

   L9759:  ldaa IDLDEF_TargetIdleSpeed_HBDefault    ; load a with memory contents (data is 7d)
           brset *b5c_IPL1, #b5c_BadCoolantTemp, L97AD    ; branch if bit(s) set
           ldx  #AISPN_IdleSpeedParkNeutral_FromTemp    ; load index with value
   L9763:  ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp0          ; store a into memory
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           ldx  #TIMED2_AISDecelBaseAirflowCurveOffset2    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           adda Temp0      
           bcc  L9778          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   L9778:  brclr *BitFlags67, #b67_IdleSpeedMode, L9794    ; branch if bit(s) clear
           ldab Counter_MainLoop    ; load b with memory contents
           andb DECAIS_RollingAisUpdateRate_01_03_07_0f_1f_3f_7f_ff    ;  (data is 7f)
           bne  L97B2          ; branch if not equal (not zero)
           staa Temp0          ; store a into memory
           ldd  TargetIdleSpeedHB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           suba ISPDCY_RollingAisDecay    ;  (data is 04)
           bcs  L9792          ; branch if lower
           cmpa Temp0          ; compare a with memory contents
           bcc  L9794          ; branch if greater or equal
   L9792:  ldaa Temp0          ; load a with memory contents
   L9794:  brclr *BitFlags_AIS, #b10_bit1, L97AD    ; branch if bit(s) clear
           brset *BitFlags6d, #b6d_FuelEngineNotRunning, L97AD    ; branch if bit(s) set
           ldx  KeyOnOrEngineRunningTime
           cpx  #0x0744        ;  -00000111 01000100-
           bls  L97AD          ; branch if lower or same
           brset *BitFlags68, #b68_bit6, L97AD    ; branch if bit(s) set
           cmpa #0x77          ; compare a with value -01110111-
           bls  L97AD          ; branch if lower or same
           ldaa #0x77          ; load a with value -01110111-
   L97AD:  clrb                ; b = 0
   L97AE:  lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
   L97B0:  stD *TargetIdleSpeedHB    ; store D to RAM
   L97B2:  brset *BitFlags_AIS, #b10_bit4, L97CC    ; branch if bit(s) set
           brclr *BitFlags6d, #b6d_FuelEngineNotRunning, L97C7    ; branch if bit(s) clear
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa RPMTHS_RPMThresholdForIdleControl    ; compare a with memory contents (data is 0d)
           bcc  L97C7          ; branch if greater or equal
           ldaa RPMDEF_RPMDefaultForIdleControl    ; load a with memory contents (data is a0)
           jmp  L9AAC      

   L97C7:  bset *BitFlags_AIS, #b10_bit4    ; set bits
           bra  L97DF          ; branch

   L97CC:  ldab BitFlags_AIS    ; load b with memory contents
           orab BitFlags6d 
           bpl  L97F0          ; branch if plus (hi bit 0)
           ldaa DesiredNewAisPosition    ; load a with memory contents
           cmpa CurrentAisPosition    ; compare a with memory contents
           bne  L97DF          ; branch if not equal (not zero)
           brset *BitFlags_AIS, #b10_UseAIS, L97DF    ; branch if bit(s) set
           bclr *BitFlags_AIS, #b10_bit7    ; clear bits
   L97DF:  bset *BitFlags_AIS, #b10_bit6    ; set bits
           bset *BitFlags69, #b69_bit2    ; set bits
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #AISTRT_AisStartupPosition_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           jmp  L9AAC      

   L97F0:  brclr *b5c_IPL1, #b5c_MapStuck | b5c_MapBadSignal, HandleAcCutout    ; branch if bit(s) clear
           ldaa #0x20          ; load a with value -00100000-
           staa DesiredNewAisPosition    ; store a into memory
           brclr *BitFlags68, #b68_bit6, L9800    ; branch if bit(s) clear
           bset *BitFlags69, #b69_bit2    ; set bits
           rts                 ; return from subroutine

   L9800:  bclr *BitFlags69, #b69_bit2    ; clear bits
           rts                 ; return from subroutine

HandleAcCutout:
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa ACCTIM_AcDelayFromStartRunTransfer    ; compare a with memory contents (data is 04)
           bcs  L987D          ; branch if lower
           ldaa Timer_AcCutout    ; load a with memory contents
           bne  L9839          ; branch if not equal (not zero)
           ldaa CoolantTemp    ; load a with memory contents
           cmpa ACDTMP_PartThrottleAcCutoutDisableTemp    ; compare a with memory contents (data is 58)
           bcs  L985F          ; branch if lower
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bcs  L985F          ; branch if lower
           cmpa ACDTHR_PartThrottleAcCutoutDisableThrottle    ; compare a with memory contents (data is 1a)
           bcs  L985F          ; branch if lower
           ldx  VehicleSpeed_HB
           cpx  ACDSPD_PartThrottleAcCutoutDisableSpeed    ;  (data is 0440)
           bcc  L985F          ; branch if greater or equal
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb ACERPM_AllowAcClutchAboveThisRpm    ; compare b with memory contents (data is 54)
           bcc  L985F          ; branch if greater or equal
           inc  Timer_AcCutout
           brset *BitFlags_AIS, #b10_bit6, L987D    ; branch if bit(s) set
           jmp  L9919      

   L9839:  ldx  VehicleSpeed_HB
           cpx  ACESPD_AllowAcClutchAboveThisSpeed    ;  (data is 0500)
           bcc  L985C          ; branch if greater or equal
           ldab EngineRpm_HB    ; load b with memory contents
           subb #0x04          ;  -00000100-
           bcc  L9847          ; branch if greater or equal
           clrb                ; b = 0
   L9847:  cmpb ACERPM_AllowAcClutchAboveThisRpm    ; compare b with memory contents (data is 54)
           bcc  L985C          ; branch if greater or equal
           cmpa ACETIM_PartThrottleAcCutoutMaxTimeActive    ; compare a with memory contents (data is 0c)
           bcc  L985C          ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x3f          ;  -00111111-
           bne  L987D          ; branch if not equal (not zero)
           inca                ; increment a
           staa Timer_AcCutout    ; store a into memory
           bra  L987D          ; branch

   L985C:  clra                ; a = 0
           staa Timer_AcCutout    ; store a into memory
   L985F:  ldab BitFlags_AIS    ; load b with memory contents
           eorb BitFlags68 
           andb #b68_bit6          ;  -01000000-
           beq  L9880          ; branch if equal (zero)
           eorb BitFlags_AIS
           bitb #b10_bit6          ;  -01000000-
           beq  L9870          ; branch if equal (zero)
           jmp  L9919      

   L9870:  ldaa Pulsewidth_PartThrottleEnrichment_HB    ; load a with memory contents
           bne  L9878          ; branch if not equal (not zero)
           ldaa Pulsewidth_PartThrottleEnrichment_LB    ; load a with memory contents
           beq  L98E6          ; branch if equal (zero)
   L9878:  ldaa ACAETH_DisallowAcClutchEngageForThisTimeAfterAccelEnrich    ; load a with memory contents (data is 2d)
           staa Timer_AcClutchEngageRestrictionTimer    ; store a into memory
   L987D:  jmp  L995E      

   L9880:  stab Timer_AcClutchEngageRestrictionTimer    ; store b into memory
           brset *BitFlags_AIS, #b10_bit6, L98A5    ; branch if bit(s) set
           ldaa Timer_AisOrO2Sensor    ; load a with memory contents
           bne  L988D          ; branch if not equal (not zero)
   L988A:  jmp  L9956      

   L988D:  clrb                ; b = 0
           stab Timer_AisChanges    ; store b into memory
           deca                ; decrement a
           staa Timer_AisOrO2Sensor    ; store a into memory
           bne  L987D          ; branch if not equal (not zero)
           brset *BitFlags66, #b66_OffIdle, L988A    ; branch if bit(s) set
           ldaa AC2KCK_AcClutchKickOpenAfterAcEnabled    ; load a with memory contents (data is 00)
           jsr  MultiplyTempvar1ByA_Pos    ; call subroutine
           jsr  StoreAndLimitDesiredAisPosition    ; call subroutine
           jmp  L9956      

   L98A5:  ldaa Timer_AisOrO2Sensor    ; load a with memory contents
           beq  L987D          ; branch if equal (zero)
           clrb                ; b = 0
           stab Timer_AisChanges    ; store b into memory
           deca                ; decrement a
           staa Timer_AisOrO2Sensor    ; store a into memory
           bne  L988A          ; branch if not equal (not zero)
           brset *BitFlags66, #b66_OffIdle, L98CE    ; branch if bit(s) set
           ldaa MapValue       ; load a with memory contents
           cmpa DCLMN2_NoAisControlIfMapAndControlMapBelowThis    ; compare a with memory contents (data is 14)
           bls  L98C1          ; branch if lower or same
           ldaa AC3KCK_AcClutchKickOpenAfterAcEnabled2    ; load a with memory contents (data is fa)
           bra  L98C5          ; branch

   L98C1:  ldaa AC2KCK_AcClutchKickOpenAfterAcEnabled    ; load a with memory contents (data is 00)
           nega                ; negate a (set high bit)
   L98C5:  jsr  MultiplyTempvar1ByA_Neg    ; call subroutine
           jsr  StoreAndLimitDesiredAisPosition    ; call subroutine
           jmp  L995E      

   L98CE:  ldx  #ACCTBL_ACOffIdleDelta_FromSpeed    ; load index with value
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    ; call subroutine
           ldab OFFPER2_AisInstantlyClosesWhenAcDisengages2    ; load b with memory contents (data is 80)
           mul                 ; multiply (d=a*b)
           jsr  MultiplyTempvar1ByA_Pos    ; call subroutine
           nega                ; negate a (set high bit)
           jsr  L9B1E          ; call subroutine
           bra  L995E          ; branch

   L98E6:  ldaa Timer_AcClutchEngageRestrictionTimer    ; load a with memory contents
           beq  L98EF          ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_AcClutchEngageRestrictionTimer    ; store a into memory
           bne  L995E          ; branch if not equal (not zero)
   L98EF:  stab BitFlags_AIS    ; store b into memory
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           ldab ACTIME_TimeBeforeAcEnabledAndFullDeltaUsed    ; load b with memory contents (data is 20)
           cmpa MPHREF_SwitchPointForDecelIdleAisControl    ; compare a with memory contents (data is 07)
           bhi  L9908          ; branch if higher
           brset *BitFlags66, #b66_OffIdle, L9908    ; branch if bit(s) set
           ldab ACTDEF_TimeBeforeAcEnabledAndFullDeltaUsed_Default    ; load b with memory contents (data is 2a)
   L9908:  stab Timer_AisOrO2Sensor    ; store b into memory
           brset *BitFlags66, #b66_OffIdle, L995B    ; branch if bit(s) set
           ldaa ACOFFK_ClosedThrottleAcOffKick    ; load a with memory contents (data is 18)
           jsr  MultiplyTempvar1ByA_Pos    ; call subroutine
           jsr  ClearAisTimer    ; call subroutine
           bra  L995E          ; branch

   L9919:  bset *BitFlags_AIS, #b10_bit6    ; set bits
           ldaa ACTIM2_TimeBeforeAcEnabledAndFullDeltaUsed2    ; load a with memory contents (data is 14)
           staa Timer_AisOrO2Sensor    ; store a into memory
           brset *BitFlags66, #b66_OffIdle, L993D    ; branch if bit(s) set
           ldaa MapValue       ; load a with memory contents
           cmpa DCLMN2_NoAisControlIfMapAndControlMapBelowThis    ; compare a with memory contents (data is 14)
           bls  L9931          ; branch if lower or same
           ldaa AC4KCK_AcClutchKickOpenBeforeAcEnabled2    ; load a with memory contents (data is f4)
           bra  L9935          ; branch

   L9931:  ldaa ACOFFK_ClosedThrottleAcOffKick    ; load a with memory contents (data is 18)
           nega                ; negate a (set high bit)
   L9935:  jsr  MultiplyTempvar1ByA_Neg    ; call subroutine
           jsr  ClearAisTimer    ; call subroutine
           bra  L9956          ; branch

   L993D:  ldx  #ACCTBL_ACOffIdleDelta_FromSpeed    ; load index with value
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    ; call subroutine
           ldab OFFPER_AisInstantlyClosesWhenAcDisengages    ; load b with memory contents (data is 80)
           mul                 ; multiply (d=a*b)
           jsr  MultiplyTempvar1ByA_Pos    ; call subroutine
           nega                ; negate a (set high bit)
           jsr  L9B1E          ; call subroutine
           clra                ; a = 0
           staa Timer_AisChanges    ; store a into memory
   L9956:  bclr *BitFlags69, #b69_bit2    ; clear bits
           bra  L9961          ; branch

   L995B:  clra                ; a = 0
           staa Timer_AisChanges    ; store a into memory
   L995E:  bset *BitFlags69, #b69_bit2    ; set bits
   L9961:  brclr *BitFlags66, #b66_OffIdle, L997A    ; branch if bit(s) clear
           bclr *BitFlags_AIS, #b10_ATXChngGear    ; clear bits
           brclr *StartupSwitchMirror1, #sw1_Brake, L997E    ; branch if bit(s) clear
           ldx  #BRKRPM_BrakeOverrideForAis_FromDeltaThrottle    ; load index with value
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           jsr  Lookup4ByteTable    ; call subroutine
           cmpb EngineRpm_HB
           bcc  L997E          ; branch if greater or equal
   L997A:  brclr *BitFlags69, #b69_AtIdle, L9981    ; branch if bit(s) clear
   L997E:  jmp  L9A43      

   L9981:  brclr *BitFlags67, #b67_FallToIdle, L9986    ; branch if bit(s) clear
           rts                 ; return from subroutine

   L9986:  ldaa DesiredNewAisPosition    ; load a with memory contents
           cmpa #0x04          ; compare a with value -00000100-
           bcs  L998F          ; branch if lower
           bclr *BitFlags68, #b68_ASDon    ; clear bits
   L998F:  brclr *BitFlags_AIS, #b10_ATXChngGear, L99C4    ; branch if bit(s) clear
           brclr *BitFlags_AIS, #b10_ATXInGear, L99A0    ; branch if bit(s) clear
           ldx  #PNDLTP_DeltaRpmChangeToUse_DRPNK_or_PNDRK    ; load index with value
           ldd  TargetIdleSpeedHB    ; load d (a&b) with memory contents
           subd EngineRpm_HB    ; d = d - memory contents
           bra  L99A7          ; branch

   L99A0:  ldx  #PNDLTN_DeltaRpmChangeToUse_DRPNK_or_PNDRK    ; load index with value
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
   L99A7:  bcs  L99C4          ; branch if lower
           subd 0x00, X    
           bcs  L99C4          ; branch if lower
           ldaa CoolantTemp    ; load a with memory contents
           inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
           jsr  Lookup4ByteTable    ; call subroutine
           bmi  L99BB          ; branch if minus(hi bit 1)
           jsr  MultiplyTempvar1ByA_Pos    ; call subroutine
           bra  L99BE          ; branch

   L99BB:  jsr  MultiplyTempvar1ByA_Neg    ; call subroutine
   L99BE:  jsr  ClearAisTimer    ; call subroutine
           bclr *BitFlags_AIS, #b10_ATXChngGear    ; clear bits
   L99C4:  ldaa Timer_CountdownFromStartRunForAisFeedback    ; load a with memory contents
           bne  L9A42          ; branch if not equal (not zero)
           ldab AISFRQ_AisPeriodForRpmFeedback11ms    ; load b with memory contents (data is 82)
           cmpb Timer_AisChanges
           bcc  L9A02          ; branch if greater or equal
           ldx  #FWDAIS_ForwardAisSteps_NoSlope    ; load index with value
           ldd  TargetIdleSpeedHB    ; load d (a&b) with memory contents
           subd EngineRpm_HB    ; d = d - memory contents
           bcc  L99DD          ; branch if greater or equal
           ldx  #REVAIS_ReverseAisSteps_NoSlope    ; load index with value
           coma
           comb
   L99DD:  lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           brset *BitFlags_AIS, #b10_ATXInGear, L99E4    ; branch if bit(s) set
           lsrd                ; shift right (d=d/2)
   L99E4:  tsta                ; test a
           beq  L99E9          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   L99E9:  tba                 ; a = b
           cmpa 0x01, X        ; compare a with memory at index + value
           bcs  L9A02          ; branch if lower
           ldab 0x00, X        ; load b with memory at index + value
           beq  L9A02          ; branch if equal (zero)
   L99F2:  inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
           decb            
           beq  L99FB          ; branch if equal (zero)
           cmpa 0x01, X        ; compare a with memory at index + value
           bcc  L99F2          ; branch if greater or equal
   L99FB:  ldaa 0x00, X        ; load a with memory at index + value
           beq  L9A02          ; branch if equal (zero)
           jsr  ClearAisTimer    ; call subroutine
   L9A02:  brclr *BitFlags67, #b67_IdleSpeedMode, L9A42    ; branch if bit(s) clear
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #CLDPOS_AisColdPosition_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           brset *BitFlags68, #b68_ASDon, L9A17    ; branch if bit(s) set
           adda CALPOS_PositionAisMotorIsAtIdle    ;  (data is 1a)
           bcs  L9A25          ; branch if lower
   L9A17:  brset *BitFlags_AIS, #b10_bit6, L9A27    ; branch if bit(s) set
           adda ACOFFK_ClosedThrottleAcOffKick    ;  (data is 18)
           bcs  L9A25          ; branch if lower
           adda AC2KCK_AcClutchKickOpenAfterAcEnabled    ;  (data is 00)
           bcc  L9A27          ; branch if greater or equal
   L9A25:  ldaa #0xff          ; load a with value -11111111-
   L9A27:  staa Temp0          ; store a into memory
           adda AISLMH_RollingAisHighLimit    ;  (data is 20)
           bcs  L9A32          ; branch if lower
           cmpa DesiredNewAisPosition    ; compare a with memory contents
           bcs  L9A3D          ; branch if lower
   L9A32:  ldaa Temp0          ; load a with memory contents
           suba AISLML_RollingAisLowLimit    ;  (data is 04)
           bcs  L9A42          ; branch if lower
           cmpa DesiredNewAisPosition    ; compare a with memory contents
           bcs  L9A42          ; branch if lower
   L9A3D:  jsr  MultiplyTempvar1ByA_Unsign    ; call subroutine
           staa DesiredNewAisPosition    ; store a into memory
   L9A42:  rts                 ; return from subroutine

   L9A43:  ldaa CoolantTemp    ; load a with memory contents
           ldx  #CLDPOS_AisColdPosition_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp0          ; store a into memory
           ldx  #RPMPOS_AisPosition_FromRpm    ; load index with value
           ldaa EngineRpm_HB    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           cmpa Temp0          ; compare a with memory contents
           bcs  L9A5B          ; branch if lower
           staa Temp0          ; store a into memory
   L9A5B:  ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bcc  L9A62          ; branch if greater or equal
           clra                ; a = 0
   L9A62:  ldx  #THRPOS_AisPosition_FromThrottle    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           cmpa Temp0          ; compare a with memory contents
           bcc  L9A6E          ; branch if greater or equal
           ldaa Temp0          ; load a with memory contents
   L9A6E:  brset *BitFlags_AIS, #b10_bit6, L9A9D    ; branch if bit(s) set
           ldab ACPOS_ACPositionWhenTempToCold    ; load b with memory contents (data is 24)
           brset *BitFlags69, #b69_AtIdle, L9A9A    ; branch if bit(s) set
           staa Temp4          ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           cmpa ACTMP_Use_ACCTBL_WhenTempAboveThisElseUse_ACPOS    ; compare a with memory contents (data is 7f)
           bcs  L9A98          ; branch if lower
           ldx  #ACCTBL_ACOffIdleDelta_FromSpeed    ; load index with value
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    ; call subroutine
           brclr *BitFlags69, #b69_bit2, L9A98    ; branch if bit(s) clear
           ldaa PERKCK_AcClutchAisAdjustmentConstant    ; load a with memory contents (data is ff)
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           tab                 ; b = a
   L9A98:  ldaa Temp4          ; load a with memory contents
   L9A9A:  aba                 ; a=a+b
           bcs  L9ABC          ; branch if lower
   L9A9D:  staa Temp4          ; store a into memory
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           ldx  #ADDAIS_AISAddedFromTimeEngRunning    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp4          ; load a with memory contents
           aba                 ; a=a+b
           bcs  L9ABC          ; branch if lower
   L9AAC:  brset *BitFlags68, #b68_ASDon, L9AB5    ; branch if bit(s) set
           adda CALPOS_PositionAisMotorIsAtIdle    ;  (data is 1a)
           bcs  L9ABC          ; branch if lower
   L9AB5:  bsr  MultiplyTempvar1ByA_Unsign    ; call subroutine
           cmpa AISHLM_AisHighLimitMaxOpenSteps    ; compare a with memory contents (data is a0)
           bcs  L9ABF          ; branch if lower
   L9ABC:  ldaa AISHLM_AisHighLimitMaxOpenSteps    ; load a with memory contents (data is a0)
   L9ABF:  brset *BitFlags69, #b69_AtIdle, L9AD9    ; branch if bit(s) set
           brclr *BitFlags_AIS, #b10_bit4, L9ADC    ; branch if bit(s) clear
           brset *BitFlags_AIS, #b10_bit7, L9ADC    ; branch if bit(s) set
           cmpa DesiredNewAisPosition    ; compare a with memory contents
           bcc  L9ADC          ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bitb DLYOF1_UpdateRateOffIdleWhenAisClosing    ;  (data is 07)
           bne  L9ADE          ; branch if not equal (not zero)
           ldaa DesiredNewAisPosition    ; load a with memory contents
           deca                ; decrement a
   L9AD9:  bclr *BitFlags69, #b69_AtIdle    ; clear bits
   L9ADC:  staa DesiredNewAisPosition    ; store a into memory
   L9ADE:  rts                 ; return from subroutine

MultiplyTempvar1ByA_Unsign:
           ldab Temp1          ; load b with memory contents
           beq  L9B0A          ; branch if equal (zero)
           staa Temp4          ; store a into memory
           mul                 ; multiply (d=a*b)
           adca Temp4      
           bcc  L9B0A          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
           rts                 ; return from subroutine

MultiplyTempvar1ByA_Pos:
           ldab Temp1          ; load b with memory contents
           beq  L9B0A          ; branch if equal (zero)
           staa Temp4          ; store a into memory
           mul                 ; multiply (d=a*b)
           adca Temp4      
           bvc  L9B0A          ; branch if overflow
           ldaa #0x7f          ; load a with value -01111111-
           rts                 ; return from subroutine

MultiplyTempvar1ByA_Neg:
           ldab Temp1          ; load b with memory contents
           beq  L9B0A          ; branch if equal (zero)
           nega                ; negate a (set high bit)
           staa Temp4          ; store a into memory
           mul                 ; multiply (d=a*b)
           adca Temp4
           bvc  L9B09          ; branch if overflow
           ldaa #0x7f          ; load a with value -01111111-
   L9B09:  nega                ; negate a (set high bit)
   L9B0A:  rts                 ; return from subroutine

ClearAisTimer:
           clrb                ; b = 0
           stab Timer_AisChanges    ; store b into memory
StoreAndLimitDesiredAisPosition:
           tsta                ; test a
           bmi  L9B1E          ; branch if minus(hi bit 1)
           adda DesiredNewAisPosition
           ldab AISHLM_AisHighLimitMaxOpenSteps    ; load b with memory contents (data is a0)
           bcs  L9B1B          ; branch if lower
           cba             
           bcs  L9B23          ; branch if lower
   L9B1B:  stab DesiredNewAisPosition    ; store b into memory
           rts                 ; return from subroutine

   L9B1E:  adda DesiredNewAisPosition
           bcs  L9B23          ; branch if lower
           clra                ; a = 0
   L9B23:  staa DesiredNewAisPosition    ; store a into memory
           rts                 ; return from subroutine

CCDBusComs:
           sei                 ; disable interrupts
           ldaa SwitchPortAccessReg2    ; load a with memory contents
           bita #0x08          ;  -00001000-
           bne  L9BA7          ; branch if not equal (not zero)
           ldaa PIA3_Buffer    ; load a with memory contents
           anda #~pi3_CCDEnable       ; AND a with value -11111011-
           staa PIA3_Buffer_2
           brset *CCDVar0, #$%10000000, CCD_Error    ; branch if bit(s) set
           ldd  CCDTemp_HB     ; load d (a&b) with memory contents
           bsr  CCD_XmitCode    ; call subroutine
           cmpD CCDTemp_HB     ; compare D
           beq  L9B83          ; branch if equal (zero)
           cmpa CCDTemp_HB     ; compare a with memory contents
           bne  L9B4E          ; branch if not equal (not zero)
           cmpa #0x84          ; compare a with value -10000100-
           beq  L9B83          ; branch if equal (zero)
           cmpa #0xc4          ; compare a with value -11000100-
           beq  L9B83          ; branch if equal (zero)
   L9B4E:  brset *CCDFlags4, #$%10000000, L9B81    ; branch if bit(s) set
           ldx  #SwitchPortAccessReg1    ; load index with value
           brset  1, X, #$%00001000, L9B9E    ; branch if bit(s) set
           bclr  0, X, #$%00001000    ; bit clear
           bset  2, X, #$%00001000    ; bit set
           bclr  2, X, #$%00001000    ; bit clear
           ldab CCDFlags4      ; load b with memory contents
           addb #0x20          ;  -00100000-
           bcs  L9B6A          ; branch if lower
           stab CCDFlags4      ; store b into memory
   L9B6A:  bra  L9B71          ; branch

CCD_Error:
           ldd  #0xFFFF         ; load d (a&b) with value -11111111 11111111-
           bsr  CCD_XmitCode    ; call subroutine
   L9B71:  cmpa #0xaa          ; compare a with value -10101010-
           bne  L9B9E          ; branch if not equal (not zero)
           bset *CCDFlags5, #$%01000000    ; set bits
           brset *CCDFlags6, #$%10000000, L9B9E    ; branch if bit(s) set
           bset *CCDFlags2, #$%00100000    ; set bits
           bra  L9B9E          ; branch

   L9B81:  ldaa CCDTemp_HB     ; load a with memory contents
   L9B83:  cmpa #0x84          ; compare a with value -10000100-
           bne  L9B9B          ; branch if not equal (not zero)
           ldab CCDFlags3x     ; load b with memory contents
           bpl  L9B9B          ; branch if plus (hi bit 0)
           andb #0x7f          ;  -01111111-
           clra                ; a = 0
           staa CCDFlags3x 
           ldaa #0xc4          ; load a with value -11000100-
           stD *CCDTemp_HB     ; store D to RAM
           bclr *CCDFlags4, #$%11100000    ; clear bits
           bra  L9B9E          ; branch

   L9B9B:  bset *CCDVar0, #$%10000000    ; set bits
   L9B9E:  ldaa PIA3_Buffer    ; load a with memory contents
           oraa #pi3_CCDEnable          ;  -00000100-
           staa PIA3_Buffer    ; store a into memory
           staa PIA3_Buffer_2
   L9BA7:  rts                 ; return from subroutine

CCD_XmitCode:
           cmpb CPU_SerialPeripheralStatus    ; compare b with memory contents
           staa CPU_SerialPeripheralDataIO
           ldx  #CPU_SerialPeripheralStatus    ; load index with value
           ldY #MINTHR_LowestSessionTPS    ; load Y index -00000000 00000101-
   L9BB5:  brset  0, X, #$%10000000, CCD_XmitData    ; branch if bit(s) set
           deY                 ; decrement Y
           bne  L9BB5          ; branch if not equal (not zero)
           rts                 ; return from subroutine

CCD_XmitData:
           ldaa CPU_SerialPeripheralDataIO    ; load a with memory contents
           stab CPU_SerialPeripheralDataIO    ; store b into memory
           ldY #MINTHR_LowestSessionTPS    ; load Y index -00000000 00000101-
   L9BC8:  brset  0, X, #$%10000000, CCD_ReadResult    ; branch if bit(s) set
           deY                 ; decrement Y
           bne  L9BC8          ; branch if not equal (not zero)
           rts                 ; return from subroutine

CCD_ReadResult:
           ldab CPU_SerialPeripheralDataIO    ; load b with memory contents
           rts                 ; return from subroutine

PrepareCCDDataForXmit_MM:
           ldab Counter_MainLoop    ; load b with memory contents
           andb #0x0f          ;  -00001111-
           bne  L9C1D          ; branch if not equal (not zero)
           brset *CCDFlags1, #$%00000100, L9C01    ; branch if bit(s) set
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa #0x83          ; compare a with value -10000011-
           bcs  L9C19          ; branch if lower
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa #0x2f          ; compare a with value -00101111-
           bcs  L9C19          ; branch if lower
           ldaa BatteryVolts    ; load a with memory contents
           cmpa #0xbd          ; compare a with value -10111101-
           bcc  L9C19          ; branch if greater or equal
           ldab CCDCounterX    ; load b with memory contents
           incb            
           stab CCDCounterX    ; store b into memory
           cmpb #0x71          ;  -01110001-
           bcs  L9C1D          ; branch if lower
           bset *CCDFlags1, #$%00000100    ; set bits
           bra  L9C19          ; branch

   L9C01:  ldaa TargetBatteryVolts    ; load a with memory contents
           suba BatteryVolts
           bcs  L9C0B          ; branch if lower
           cmpa #0x01          ; compare a with value -00000001-
           bhi  L9C19          ; branch if higher
   L9C0B:  ldab CCDCounterX    ; load b with memory contents
           incb
           stab CCDCounterX    ; store b into memory
           cmpb #0x22          ;  -00100010-
           bcs  L9C1D          ; branch if lower
           bclr *CCDFlags1, #$%00000100    ; clear bits
   L9C19:  clra                ; a = 0
           staa CCDCounterX
   L9C1D:  brset *Counter_MainLoop, #$%00000001, L9C98    ; branch if bit(s) set
           ldab CCDVar0        ; load b with memory contents
           incb            
           andb #0x7f          ;  -01111111-
           stab Temp0          ; store b into memory
           ldx  #CCDDataStream    ; load index with value
           abx                 ; add b to index
           abx                 ; add b to index
           ldx  0x00, X    
           ldaa CCDTemp_HB     ; load a with memory contents
           sei                 ; disable interrupts
           brset *CCDVar0, #$%10000000, L9C8B    ; branch if bit(s) set
           bset *CCDVar0, #$%10000000    ; set bits
           cmpa #0x84          ; compare a with value -10000100-
           bne  L9C6F          ; branch if not equal (not zero)
           cpx  #CCD_SpeedSensorCounter    ;  -10011101 10011011-
           bne  L9C59          ; branch if not equal (not zero)
           clra                ; a = 0
           ldab CCDFlags3x     ; load b with memory contents
           andb #0x7f          ;  -01111111-
           addb Counter_SpeedSensorInterrupt_HB_X
           bpl  L9C4F          ; branch if plus (hi bit 0)
           ldab #0x7f          ; load b with value -01111111-
   L9C4F:  staa Counter_SpeedSensorInterrupt_HB_X
           orab #0x80          ;  -10000000-
           stab CCDFlags3x     ; store b into memory
           bra  L9C93          ; branch

   L9C59:  cpx  #CCD_FuelOutput    ;  -10011101 10010001-
           bne  L9C93          ; branch if not equal (not zero)
           clra                ; a = 0
           ldab CCDTemp_LB     ; load b with memory contents
           addb CCDFuelOutput_HB    ; b=b+memory contents
           bcc  L9C69          ; branch if greater or equal
           tba                 ; a = b
           inca                ; increment a
           ldab #0xff          ; load b with value -11111111-
   L9C69:  staa CCDFuelOutput_HB    ; store a into memory
           stab CCDTemp_LB     ; store b into memory
           bra  L9C93          ; branch

   L9C6F:  cmpa #0xc4          ; compare a with value -11000100-
           bne  L9C8B          ; branch if not equal (not zero)
           cpx  #CCD_SpeedSensorCounter    ;  -10011101 10011011-
           bne  L9C93          ; branch if not equal (not zero)
           clra                ; a = 0
           ldab CCDTemp_LB     ; load b with memory contents
           addb Counter_SpeedSensorInterrupt_HB_X
           bcc  L9C84          ; branch if greater or equal
           tba                 ; a = b
           inca                ; increment a
           ldab #0xff          ; load b with value -11111111-
   L9C84:  staa Counter_SpeedSensorInterrupt_HB_X
           stab CCDTemp_LB     ; store b into memory
           bra  L9C93          ; branch

   L9C8B:  cli                 ; enable interrupts
           bclr *CCDFlags4, #$%11100000    ; clear bits
           jsr  0x00, X    
           stD *CCDTemp_HB     ; store D to RAM
   L9C93:  ldaa Temp0          ; load a with memory contents
           staa CCDVar0        ; store a into memory
           cli                 ; enable interrupts
   L9C98:  ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           bne  L9CA4          ; branch if not equal (not zero)
           ldaa CCDCF2_CCDConfigConstant2    ; load a with memory contents (data is 00)
           beq  CCD_HandleAlarm          ; branch if equal (zero)
           bclr *CCDFlags5, #ccd_AlarmDisable    ; clear bits
   L9CA4:  rts                 ; return from subroutine

CCD_HandleAlarm:
           ldaa CPU_EEPROMControlReg    ; load a with memory contents
           bita #0x02          ;  -00000010-
           bne  L9CB9          ; branch if not equal (not zero)
           bclr *CCDFlags2, #$%10000000    ; clear bits
           ldaa LB612          ; load a with memory contents (data is ff)
           bita #0x01          ;  -00000001-
           beq  L9CB9          ; branch if equal (zero)
           bset *CCDFlags2, #$%10000000    ; set bits
   L9CB9:  ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x03          ;  -00000011-
           bne  L9D1C          ; branch if not equal (not zero)
           brclr *CCDFlags5, #$%01000000, L9CE1    ; branch if bit(s) clear
           bset *CCDFlags5, #ccd_bit7    ; set bits
           bclr *CCDFlags5, #ccd_bit6 | ccd_AlarmDisable    ; clear bits
           bclr *CCDFlags6, #$%01111111    ; clear bits
           brset *CCDFlags6, #$%10000000, L9D1C    ; branch if bit(s) set
           ldaa BitFlags6a     ; load a with memory contents
           bita #b6a_DRBToggle2 | b6a_DRBToggle1          ;  -00000011-
           bne  L9D1C          ; branch if not equal (not zero)
           ldaa LB612          ; load a with memory contents (data is ff)
           bita #0x02          ;  -00000010-
           beq  L9D1C          ; branch if equal (zero)
           anda #0xfd          ; AND a with value -11111101-
           bra  L9D0A          ; branch

   L9CE1:  ldaa CCDFlags6      ; load a with memory contents
           anda #0x7f          ; AND a with value -01111111-
           brclr *CCDFlags5, #ccd_bit7, L9CEF    ; branch if bit(s) clear
           cmpa #0x71          ; compare a with value -01110001-
           bcc  L9CF8          ; branch if greater or equal
           bra  L9CF3          ; branch

   L9CEF:  cmpa #0x2d          ; compare a with value -00101101-
           bcc  L9D1C          ; branch if greater or equal
   L9CF3:  inc  CCDFlags6  
           bra  L9D1C          ; branch

   L9CF8:  ldaa BitFlags6a     ; load a with memory contents
           bita #b6a_DRBToggle2 | b6a_DRBToggle1          ;  -00000011-
           bne  L9D1C          ; branch if not equal (not zero)
           ldaa LB612          ; load a with memory contents (data is ff)
           bita #0x02          ;  -00000010-
           bne  L9D1C          ; branch if not equal (not zero)
           bset *CCDFlags6, #$%10000000    ; set bits
           oraa #0x02          ;  -00000010-
   L9D0A:  sei                 ; disable interrupts
           brclr *BitFlags6a, #b6a_DRBToggle1, L9D12    ; branch if bit(s) clear
           cli                 ; enable interrupts
           bra  L9D1C          ; branch

   L9D12:  bset *BitFlags6a, #b6a_DRBToggle1    ; set bits
           cli                 ; enable interrupts
           staa DRBOffsetStored_LB    ; store a into memory
           ldaa #0x12          ; load a with value -00010010-
           staa DRBOffsetStored_HB    ; store a into memory
   L9D1C:  brclr *CCDFlags5, #$%00010000, L9D30    ; branch if bit(s) clear
           brset *CCDFlags5, #ccd_bit7, L9D2F    ; branch if bit(s) set
           ldaa CCDFlags6      ; load a with memory contents
           anda #0x7f          ; AND a with value -01111111-
           cmpa #0x2d          ; compare a with value -00101101-
           bcs  L9D2F          ; branch if lower
           bset *CCDFlags5, #ccd_AlarmDisable    ; set bits
   L9D2F:  rts                 ; return from subroutine

   L9D30:  brset *CCDFlags5, #$%00010000, L9D7E    ; branch if bit(s) set
           brset *BitFlags6d, #b6d_FuelEngineNotRunning, L9D7E    ; branch if bit(s) set
           ldaa BitFlags6a     ; load a with memory contents
           bita #b6a_DRBToggle2  |b6a_DRBToggle1          ;  -00000011-
           bne  L9D7E          ; branch if not equal (not zero)
           ldaa LB612          ; load a with memory contents (data is ff)
           bita #0x01          ;  -00000001-
           bne  L9D4B          ; branch if not equal (not zero)
           bita #0x02          ;  -00000010-
           bne  L9D78          ; branch if not equal (not zero)
           bra  L9D7B          ; branch

   L9D4B:  brset *CCDFlags5, #ccd_bit7, L9D59    ; branch if bit(s) set
           ldaa CCDFlags6      ; load a with memory contents
           anda #0x7f          ; AND a with value -01111111-
           cmpa #0x2d          ; compare a with value -00101101-
           bcs  L9D7E          ; branch if lower
           bra  L9D75          ; branch

   L9D59:  sei                 ; disable interrupts
           brclr *BitFlags6a, #b6a_DRBToggle1, L9D61    ; branch if bit(s) clear
           cli                 ; enable interrupts
           bra  L9D7E          ; branch

   L9D61:  bset *BitFlags6a, #b6a_DRBToggle1    ; set bits
           cli                 ; enable interrupts
           adda #0x04          ;  -00000100-
           cmpa #0x4c          ; compare a with value -01001100-
           bcs  L9D6D          ; branch if lower
           anda #0xfe          ; AND a with value -11111110-
   L9D6D:  anda #0xfd          ; AND a with value -11111101-
           staa DRBOffsetStored_LB    ; store a into memory
           ldaa #0x12          ; load a with value -00010010-
           staa DRBOffsetStored_HB    ; store a into memory
   L9D75:  bset *CCDFlags2, #$%10000000    ; set bits
   L9D78:  bset *CCDFlags5, #ccd_bit7    ; set bits
   L9D7B:  bset *CCDFlags5, #$%00010000    ; set bits
   L9D7E:  rts                 ; return from subroutine

CCD_CCDBusOutputStatus:
           ldaa Temp0          ; load a with memory contents
           oraa #0x80          ;  -10000000-
           staa CCDVar0        ; store a into memory
           pulx                ; pull index from stack
           rts                 ; return from subroutine

CCD_EngineRPM:
           ldaa #0xe4          ; load a with value -11100100-
           ldab EngineRpm_HB    ; load b with memory contents
           rts                 ; return from subroutine

CCD_MAP:
           ldaa #0x94          ; load a with value -10010100-
           ldab MapValue       ; load b with memory contents
           rts                 ; return from subroutine

CCD_FuelOutput:
           clra                ; a = 0
           sei                 ; disable interrupts
           ldab CCDFuelOutput_HB    ; load b with memory contents
           staa CCDFuelOutput_HB    ; store a into memory
           cli                 ; enable interrupts
           ldaa #0x84          ; load a with value -10000100-
           rts                 ; return from subroutine

CCD_SpeedSensorCounter:
           clra                ; a = 0
           sei                 ; disable interrupts
           ldab Counter_SpeedSensorInterrupt_HB_X    ; load b with memory contents
           staa Counter_SpeedSensorInterrupt_HB_X
           cli                 ; enable interrupts
           staa CCDFlags3x
           ldaa #0xc4          ; load a with value -11000100-
           rts                 ; return from subroutine

CCD_ConfigConst1:
           ldaa #0xac          ; load a with value -10101100-
           ldab CCDCFG_CCDConfigConstant    ; load b with memory contents (data is a1)
           rts                 ; return from subroutine

CCD_CoolantTemp:
           ldaa #0x8c          ; load a with value -10001100-
           ldab CoolantTemp    ; load b with memory contents
           rts                 ; return from subroutine

CCD_AmbientAirTemp:
           ldaa #0x4c          ; load a with value -01001100-
           ldab AmbientAirTempVolts    ; load b with memory contents
           rts                 ; return from subroutine

CCD_TargetBatVolts:
           ldaa TargetBatteryVolts    ; load a with memory contents
           bsr  L9DC8          ; call subroutine
           ldaa #0xc2          ; load a with value -11000010-
           rts                 ; return from subroutine

CCD_BatVolts:
           ldaa BatteryVolts    ; load a with memory contents
           bsr  L9DC8          ; call subroutine
           ldaa #0xd4          ; load a with value -11010100-
           rts                 ; return from subroutine

   L9DC8:  ldab CCDBatteryVoltsOutput    ; load b with memory contents
           cmpb #0x10          ;  -00010000-
           bhi  L9DE1          ; branch if higher
           comb            
           addb #0x09          ;  -00001001-
           bcs  L9DD8          ; branch if lower
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           bra  L9DE1          ; branch

   L9DD8:  staa Temp1          ; store a into memory
           mul                 ; multiply (d=a*b)
           adca Temp1      
           bcc  L9DE1          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   L9DE1:  tab                 ; b = a
           rts                 ; return from subroutine

CCD_TargetIdleSPeed:
           ldd  TargetIdleSpeedHB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           tab                 ; b = a
           ldaa #0xcc          ; load a with value -11001100-
           rts                 ; return from subroutine

CCD_ThrottlePos:
           ldab TpsVolts       ; load b with memory contents
           subb MINTHR_LowestSessionTPS    ; b = b-memory contents
           bcc  L9DF2          ; branch if greater or equal
           clrb                ; b = 0
   L9DF2:  ldaa #0x42          ; load a with value -01000010-
           rts                 ; return from subroutine

CCD_B600:
           ldaa CPU_EEPROMControlReg    ; load a with memory contents
           bita #0x02          ;  -00000010-
           bne  CCD_CCDBusOutputStatus    ; branch if not equal (not zero)
           ldd  LB600          ;  (data is ffff)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           tab                 ; b = a
           ldaa #0x2c          ; load a with value -00101100-
           rts                 ; return from subroutine

CCD_AlarmStatus:
           ldaa CPU_EEPROMControlReg    ; load a with memory contents
           bita #0x02          ;  -00000010-
           bne  L9E2D          ; branch if not equal (not zero)
           ldx  #0xb672        ; load index with value
           sei                 ; disable interrupts
           ldab CCDFlags4      ; load b with memory contents
           tba                 ; a = b
           incb            
           andb #0x07          ;  -00000111-
           anda #0xf8          ; AND a with value -11111000-
           aba                 ; a=a+b
           staa CCDFlags4      ; store a into memory
           cli                 ; enable interrupts
           abx                 ; add b to index
           abx                 ; add b to index
           abx                 ; add b to index
           brset  0, X, #$%11111111, L9E2D    ; branch if bit(s) set
           ldd  0x00, X    
           aba                 ; a=a+b
           cmpa 0x02, X        ; compare a with memory at index + value
           bne  L9E2D          ; branch if not equal (not zero)
           ldd  0x00, X    
           rts                 ; return from subroutine

   L9E2D:  jmp  CCD_CCDBusOutputStatus

CCD_VehicleSpeed:
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           bcc  L9E39          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   L9E39:  ldab #0x34          ; load b with value -00110100-
           mul                 ; multiply (d=a*b)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           tab                 ; b = a
           ldaa #0x24          ; load a with value -00100100-
           rts                 ; return from subroutine

CCD_SwitchState:
           clrb                ; b = 0
           brset *PIA1_Buffer, #pi1_CEL, L9E4C    ; branch if bit(s) set
           orab #0x01          ;  -00000001-
   L9E4C:  brset *PIA2_Buffer, #pi2_PTU, L9E52    ; branch if bit(s) set
           orab #0x40          ;  -01000000-
   L9E52:  brclr *b5c_IPL1, #b5c_BattNotCharging, L9E58    ; branch if bit(s) clear
           orab #0x08          ;  -00001000-
   L9E58:  ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bcs  L9E64          ; branch if lower
           cmpa #0x05          ; compare a with value -00000101-
           bcs  L9E64          ; branch if lower
           orab #0x02          ;  -00000010-
   L9E64:  brclr *CCDFlags1, #$%00000100, L9E6A    ; branch if bit(s) clear
           orab #0x04          ;  -00000100-
   L9E6A:  brclr *StartupSwitchMirror2, #sw2_Brake, L9E70    ; branch if bit(s) clear
           orab #0x10          ;  -00010000-
   L9E70:  brclr *PIA2_Buffer, #pi2_ACRelay, L9E76    ; branch if bit(s) clear
           orab #0x20          ;  -00100000-
   L9E76:  stab CCDFlags1      ; store b into memory
           ldaa #0xa4          ; load a with value -10100100-
           rts                 ; return from subroutine

CCD_ToggleFlags:
           clrb                ; b = 0
           brclr *b5c_IPL1, #b5c_TpsBadSignal, L9E82    ; branch if bit(s) clear
           orab #0x02          ;  -00000010-
   L9E82:  brclr *b5c_IPL1, #b5c_BadCoolantTemp, L9E88    ; branch if bit(s) clear
           orab #0x01          ;  -00000001-
   L9E88:  sei                 ; disable interrupts
           ldaa CCDFlags2      ; load a with memory contents
           anda #0xa0          ; AND a with value -10100000-
           aba                 ; a=a+b
           tab                 ; b = a
           anda #0xdf          ; AND a with value -11011111-
           staa CCDFlags2      ; store a into memory
           cli                 ; enable interrupts
           ldaa #0xec          ; load a with value -11101100-
           rts                 ; return from subroutine

CCD_Flag_Status:
           clrb                ; b = 0
           brset *CruiseStatus_1, #$%10000000, L9E9E    ; branch if bit(s) set
           orab #0x01          ;  -00000001-
   L9E9E:  stab CCDFlags3      ; store b into memory
           ldaa #0x64          ; load a with value -01100100-
           rts                 ; return from subroutine


	;.org	0x9ea3
CCDDataStream:
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_FuelOutput
		.word	CCD_SpeedSensorCounter
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_BatVolts
		.word	CCD_AmbientAirTemp
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_SwitchState
		.word	CCD_VehicleSpeed
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_Flag_Status
		.word	CCD_ThrottlePos
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_FuelOutput
		.word	CCD_SpeedSensorCounter
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_CCDBusOutputStatus
		.word	CCD_B600
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_SwitchState
		.word	CCD_VehicleSpeed
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_Flag_Status
		.word	CCD_ThrottlePos
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_FuelOutput
		.word	CCD_SpeedSensorCounter
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_CoolantTemp
		.word	CCD_TargetBatVolts
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_SwitchState
		.word	CCD_VehicleSpeed
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_Flag_Status
		.word	CCD_ThrottlePos
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_FuelOutput
		.word	CCD_SpeedSensorCounter
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_CCDBusOutputStatus
		.word	CCD_TargetIdleSPeed
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_SwitchState
		.word	CCD_VehicleSpeed
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_Flag_Status
		.word	CCD_ThrottlePos
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_FuelOutput
		.word	CCD_SpeedSensorCounter
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_BatVolts
		.word	CCD_ToggleFlags
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_SwitchState
		.word	CCD_VehicleSpeed
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_Flag_Status
		.word	CCD_ThrottlePos
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_FuelOutput
		.word	CCD_SpeedSensorCounter
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_CCDBusOutputStatus
		.word	CCD_AlarmStatus
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_SwitchState
		.word	CCD_VehicleSpeed
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_Flag_Status
		.word	CCD_ThrottlePos
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_FuelOutput
		.word	CCD_SpeedSensorCounter
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_CoolantTemp
		.word	CCD_TargetBatVolts
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_SwitchState
		.word	CCD_VehicleSpeed
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_Flag_Status
		.word	CCD_ThrottlePos
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_FuelOutput
		.word	CCD_SpeedSensorCounter
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_CCDBusOutputStatus
		.word	CCD_ConfigConst1
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_SwitchState
		.word	CCD_VehicleSpeed
		.word	CCD_EngineRPM
		.word	CCD_MAP
		.word	CCD_Flag_Status
		.word	CCD_ThrottlePos

        

HandleO2Processing_MM:
           clra                ; a = 0
           brset *BitFlags66, #b66_OffIdle, L9FC1    ; branch if bit(s) set
           ldab CONFIG_ConfigurationFlags    ; load b with memory contents (data is 9f)
           bitb #cfg_O2          ;  -00001000-
           beq  L9FB3          ; branch if equal (zero)
           brclr *BitFlags6b, #$%00010000, L9FC1    ; branch if bit(s) clear
   L9FB3:  ldab EngineRpm_HB    ; load b with memory contents
           subb TargetIdleSpeedHB    ; b = b-memory contents
           bcs  L9FC1          ; branch if lower
           cmpb MNRPO2_MinimumRPMOverIdleForO2Feedback    ; compare b with memory contents (data is d0)
           bls  L9FC1          ; branch if lower or same
           jmp  O2_StopUsingFeedback

   L9FC1:  ldab MapValue       ; load b with memory contents
           cmpb MAPDEC_NoCellUpdateAndO2CNTRHeldBelowThisMap    ; compare b with memory contents (data is 1a)
           bls  L9FDD          ; branch if lower or same
           ldab Timer_O2InhibitSwitchingRichIdleToClosedLoop    ; load b with memory contents
           orab Timer_OffThrottleFuelEnrich
           orab Factor_DecelLeanoutWhenMAPDecreasing
           bne  L9FDD          ; branch if not equal (not zero)
           ldab Timer_OpenLoopFraction    ; load b with memory contents
           beq  L9FD8          ; branch if equal (zero)
           brset *BitFlags66, #b66_OffIdle, L9FDD    ; branch if bit(s) set
   L9FD8:  bclr *BitFlags67, #b67_StayOpenLoop    ; clear bits
           bra  L9FE2          ; branch

   L9FDD:  bset *BitFlags67, #b67_StayOpenLoop    ; set bits
           staa Timer_OutOfClosedLoopMode    ; store a into memory
   L9FE2:  brset *BitFlags66, #b66_FullThrottle, O2_FullThrottle    ; branch if bit(s) set
           brclr *BitFlags66, #b66_PTEisMaxed, L9FF4    ; branch if bit(s) clear
           brclr *BitFlags67, #b67_StayOpenLoop, L9FF4    ; branch if bit(s) clear
O2_FullThrottle:
           brset *BitFlags66, #b66_O2Valid, O2_StopUsingFeedback    ; branch if bit(s) set
           bra  L9FF8          ; branch

   L9FF4:  brset *BitFlags66, #b66_O2Valid, O2_UsingFeedback    ; branch if bit(s) set
   L9FF8:  ldab CoolantTemp    ; load b with memory contents
           cmpb CLTEMP_TempToStartCLTIMETimer    ; compare b with memory contents (data is 90)
           bcs  O2_StopUsingFeedback    ; branch if lower
           brset *BitFlags66, #b66_OpenLoop, LA013    ; branch if bit(s) set
           ldab Counter_MainLoop    ; load b with memory contents
           bne  O2_StopUsingFeedback    ; branch if not equal (not zero)
           ldab Timer_CLTIME_ClosedLoopTimer    ; load b with memory contents
           beq  LA010          ; branch if equal (zero)
           decb            
           stab Timer_CLTIME_ClosedLoopTimer    ; store b into memory
           bne  O2_StopUsingFeedback    ; branch if not equal (not zero)
   LA010:  bset *BitFlags66, #b66_OpenLoop    ; set bits
   LA013:  ldab O2SensorValue    ; load b with memory contents
           cmpb O2HIGH_HighLimitForImmediateSwitchToClosedLoop    ; compare b with memory contents (data is 26)
           bcc  O2_ValidSignal_OutsideMiddleRange    ; branch if greater or equal
           cmpb O2LOW_LowLimitForImmediateSwitchToClosedLoop    ; compare b with memory contents (data is 0f)
           bcc  O2_InvalidSignal_InMiddleRange    ; branch if greater or equal
O2_ValidSignal_OutsideMiddleRange:
           brset *PIA3_Buffer, #pi3_FuelMon, O2_StopUsingFeedback    ; branch if bit(s) set
           bset *BitFlags66, #b66_O2Valid    ; set bits
           staa Counter_AdaptiveMem_Erase    ; store a into memory
           clrb                ; b = 0
           bra  LA048          ; branch

O2_InvalidSignal_InMiddleRange:
           brset *Timer_CLTIME_ClosedLoopTimer, #$%10000000, LA03C    ; branch if bit(s) set
           cmpb O2TLMH_HighLimitForDelayedSwitchToClosedLoop    ; compare b with memory contents (data is 1f)
           bcc  LA039          ; branch if greater or equal
           cmpb O2TLML_LowLimitForDelayedSwitchToClosedLoop    ; compare b with memory contents (data is 0f)
           bcc  O2_StopUsingFeedback    ; branch if greater or equal
   LA039:  bset *Timer_CLTIME_ClosedLoopTimer, #$%10000000    ; set bits
   LA03C:  ldab Counter_MainLoop    ; load b with memory contents
           bne  O2_StopUsingFeedback    ; branch if not equal (not zero)
           ldab Timer_CLTIME_ClosedLoopTimer    ; load b with memory contents
           cmpb O2TIME_DelayTimeToClosedLoop    ; compare b with memory contents (data is 07)
           bmi  O2_ValidSignal_OutsideMiddleRange    ; branch if minus(hi bit 1)
           incb            
   LA048:  stab Timer_CLTIME_ClosedLoopTimer    ; store b into memory
O2_StopUsingFeedback:
           staa Counter_O2SensorFeedbackCount_Signed    ; store a into memory
           staa Timer_OutOfClosedLoopMode    ; store a into memory
           bset *BitFlags67, #b67_StayOpenLoop | b67_OpenLoop    ; set bits
           rts                 ; return from subroutine

O2_UsingFeedback:
           ldab O2SensorValue    ; load b with memory contents
           cmpb O2MIDX_HighLimitForInMiddleDeterminationX    ; compare b with memory contents (data is 3e)
           bcc  O2Signal_InOuterMiddleRange    ; branch if greater or equal
           cmpb O2MIDH_HighLimitForInMiddleDetermination    ; compare b with memory contents (data is 1c)
           bcc  LA076          ; branch if greater or equal
           cmpb O2MIDL_LowLimitForInMiddleDetermination    ; compare b with memory contents (data is 12)
           bcs  LA076          ; branch if lower
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa #0x2c          ; compare a with value -00101100-
           bcs  LA075          ; branch if lower
O2Signal_InOuterMiddleRange:
           ldaa Timer_CLTIME_ClosedLoopTimer    ; load a with memory contents
           inca                ; increment a
           bne  LA071          ; branch if not equal (not zero)
           jmp  Save_CLTIME_ToOtherTimers_O2InMiddle

   LA071:  brset *Counter_MainLoop, #$%00000001, LA078    ; branch if bit(s) set
   LA075:  clra                ; a = 0
   LA076:  staa Timer_CLTIME_ClosedLoopTimer    ; store a into memory
   LA078:  clra                ; a = 0
           cmpb O2HSWP_HighLimitForO2RampSwitching    ; compare b with memory contents (data is 17)
           bcc  O2Signal_AboveToggle    ; branch if greater or equal
           cmpb O2LSWP_LowLimitForO2RampSwitching    ; compare b with memory contents (data is 16)
           bcs  O2Signal_BelowToggle    ; branch if lower
           rts                 ; return from subroutine

O2Signal_AboveToggle:
           deca                ; decrement a
O2Signal_BelowToggle:
           staa Temp0          ; store a into memory
           brclr *EGRVar2, #$%10000000, LA091    ; branch if bit(s) clear
           clr  Counter_AdaptiveMem_Erase    ; zero byte at memory location
   LA08E:  jmp  LA106      

   LA091:  ldab EngineRpm_HB    ; load b with memory contents
           cmpb RPMLIM_NoCellUpdateAboveThisRPMInRPMOver32    ; compare b with memory contents (data is 56)
           bhi  LA08E          ; branch if higher
           brset *BitFlags66, #b66_OffIdle, LA0B0    ; branch if bit(s) set
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_O2          ;  -00001000-
           beq  LA0A7          ; branch if equal (zero)
           brclr *BitFlags6b, #$%00010000, LA0B0    ; branch if bit(s) clear
   LA0A7:  subb TargetIdleSpeedHB    ; b = b-memory contents
           bcs  LA0B0          ; branch if lower
           cmpb MNRPO2_MinimumRPMOverIdleForO2Feedback    ; compare b with memory contents (data is d0)
           bhi  LA106          ; branch if higher
   LA0B0:  ldab Timer_FuelEnrich    ; load b with memory contents
           orab Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop
           bne  LA106          ; branch if not equal (not zero)
           ldab MapValue       ; load b with memory contents
           cmpb MAPLIM_NoCellUpdateAboveThisMAP    ; compare b with memory contents (data is 8a)
           bhi  LA106          ; branch if higher
           cmpb MAPDEC_NoCellUpdateAndO2CNTRHeldBelowThisMap    ; compare b with memory contents (data is 1a)
           bls  SwitchOrStayOpenLoop    ; branch if lower or same
           cmpb BOOSTP_AdjustO2ResponseForPTEWhenMapAboveThis    ; compare b with memory contents (data is ff)
           bcc  SwitchOrStayOpenLoop    ; branch if greater or equal
           ldab Factor_DecelLeanoutWhenMAPDecreasing    ; load b with memory contents
           orab Timer_OffThrottleFuelEnrich
           orab Timer_OpenLoopFraction
           bne  SwitchOrStayOpenLoop    ; branch if not equal (not zero)
           ldab CylTrim_Adaptive_Var1    ; load b with memory contents
           beq  LA0D8          ; branch if equal (zero)
           cmpb CLTRMN_MinimumCylinderTrim    ; compare b with memory contents (data is 07)
           bcs  SwitchOrStayOpenLoop    ; branch if lower
   LA0D8:  ldab CALTH1_O2ControllerDeadbandLimitForUpdatingCells1    ; load b with memory contents (data is 09)
           brset *BitFlags66, #b66_OffIdle, LA0F1    ; branch if bit(s) set
           pshb                ; push b onto stack
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           cmpa MPHREF_SwitchPointForDecelIdleAisControl    ; compare a with memory contents (data is 07)
           pulb                ; pull b from stack
           bhi  LA0F1          ; branch if higher
           ldab CALTH2_O2ControllerDeadbandLimitForUpdatingCells2    ; load b with memory contents (data is 09)
   LA0F1:  brset *Temp0, #$%11111111, LA0F6    ; branch if bit(s) set
           negb            
   LA0F6:  addb Counter_O2SensorFeedbackCount_Signed    ; b=b+memory contents
           bvs  SwitchOrStayOpenLoop    ; branch if no overflow
           eorb Temp0      
           bmi  SwitchOrStayOpenLoop    ; branch if minus(hi bit 1)
           bclr *BitFlags67, #b67_OpenLoop    ; clear bits
           bclr *CylTrim_FlagsE7, #$%00100000    ; clear bits
           bra  SwitchOrStayClosedLoop    ; branch

   LA106:  bset *CylTrim_FlagsE7, #$%00100000    ; set bits
SwitchOrStayOpenLoop:
           bset *BitFlags67, #b67_OpenLoop    ; set bits
SwitchOrStayClosedLoop:
           clra                ; a = 0
           brclr *BitFlags67, #b67_StayOpenLoop, LA114    ; branch if bit(s) clear
           staa Counter_AdaptiveMem_Erase    ; store a into memory
           rts                 ; return from subroutine

   LA114:  ldab Temp0          ; load b with memory contents
           eorb BitFlags66 
           andb #b66_O2Rich          ;  -00000100-
           beq  O2HasNotToggled    ; branch if equal (zero)
           eorb BitFlags66 
           stab BitFlags66     ; store b into memory
           clrb                ; b = 0
           ldaa Timer_OutOfClosedLoopMode    ; load a with memory contents
           stab Timer_OutOfClosedLoopMode    ; store b into memory
           stab Timer_O2ToggleDuration    ; store b into memory
           bclr *BitFlags69, #b69_BadO2Read     ; clear bits
           bclr *BitFlags67, #b67_BadO2    ; clear bits
           bra  WorkWithPrimaryRamp    ; branch

O2HasNotToggled:
           ldab Timer_OutOfClosedLoopMode    ; load b with memory contents
           beq  LA168          ; branch if equal (zero)
WorkWithPrimaryRamp:
           staa Temp0          ; store a into memory
           ldx  #PRIRMP_PrimaryRamp    ; load index with value
           jsr  DetermineRampCellFromRPMandMAP    ; call subroutine
           ldab Timer_OutOfClosedLoopMode    ; load b with memory contents
           addb 0x00, X        ; add memory at index + value to b
           sba                 ; subtract (a=a-b)
           bhi  LA14C          ; branch if higher
           adda 0x00, X    
           bpl  LA147          ; branch if plus (hi bit 0)
           clra                ; a = 0
   LA147:  clrb                ; b = 0
           stab Timer_OutOfClosedLoopMode    ; store b into memory
           bra  LA153          ; branch

   LA14C:  ldaa 0x00, X        ; load a with memory at index + value
           tab                 ; b = a
           addb Timer_OutOfClosedLoopMode    ; b=b+memory contents
           stab Timer_OutOfClosedLoopMode    ; store b into memory
   LA153:  ldab Temp0          ; load b with memory contents
           beq  LA15B          ; branch if equal (zero)
           cba             
           bcs  LA15B          ; branch if lower
           tba                 ; a = b
   LA15B:  ldab BitFlags66     ; load b with memory contents
           bitb #b66_O2Rich          ;  -00000100-
           beq  LA162          ; branch if equal (zero)
           nega                ; negate a (set high bit)
   LA162:  jsr  IncrementO2SensorFeedbackCount    ; call subroutine
           clra                ; a = 0
           bra  LA178          ; branch

   LA168:  brset *BitFlags67, #b67_StayOpenLoop, LA17A    ; branch if bit(s) set
           ldaa Counter_AdaptiveMem_Erase    ; load a with memory contents
           cmpa LTHTIM_IfNoO2SwitchForThisTimeThrowFault51or52    ; compare a with memory contents (data is 2c)
           bcc  EraseAdaptiveMemory_possiblySetErrorBit    ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bne  LA17A          ; branch if not equal (not zero)
           inca                ; increment a
   LA178:  staa Counter_AdaptiveMem_Erase    ; store a into memory
   LA17A:  rts                 ; return from subroutine

EraseAdaptiveMemory_possiblySetErrorBit:
           brset *BitFlags69, #b69_BadO2Read, LA184    ; branch if bit(s) set
           inc  BitFlags69 
           bra  EraseAdaptiveMemory1    ; branch

   LA184:  bset *BitFlags67, #b67_BadO2    ; set bits
           ldd  #0x0301        ; load d (a&b) with value -00000011 00000001-
           brset *BitFlags66, #b66_O2Rich, LA18F    ; branch if bit(s) set
           inca                ; increment a
   LA18F:  jsr  ThrowNonCriticalError    ; call subroutine
EraseAdaptiveMemory1:
           clra                ; a = 0
           staa ValueFromAdaptiveMemory    ; store a into memory
           ldx  #AutoCalCell0    ; load index with value
   LA198:  staa 0x00, X    
           inx                 ; increment index (x=x+1)
           cpx  #ErrorBitRegister0    ;  -00000000 00011111-
           bne  LA198          ; branch if not equal (not zero)
Save_CLTIME_ToOtherTimers_O2InMiddle:
           staa AdaptiveCellUpdateTimer_IncrementedEveryDistRisingEdge    ; store a into memory
           staa Counter_AdaptiveMem_Erase    ; store a into memory
           staa Timer_CLTIME_ClosedLoopTimer    ; store a into memory
           bclr *BitFlags66, #b66_O2Valid    ; clear bits
           rts                 ; return from subroutine

ModifyO2FeedbackCountVarToMaintainStoich_MM:
           brset *BitFlags67, #b67_StayOpenLoop, LA1B2    ; branch if bit(s) set
           brset *BitFlags66, #b66_O2Valid, WorkWithSecondaryRamp    ; branch if bit(s) set
   LA1B2:  clra                ; a = 0
           staa Timer_O2ToggleDuration    ; store a into memory
           rts                 ; return from subroutine

WorkWithSecondaryRamp:
           ldx  #SECRMP_SecondaryRamp    ; load index with value
           bsr  DetermineRampCellFromRPMandMAP    ; call subroutine
           sei                 ; disable interrupts
           ldaa Timer_O2ToggleDuration    ; load a with memory contents
           brclr *EGRVar2, #$%10000000, LA1C7    ; branch if bit(s) clear
           suba SCRMP1_SecondaryRampSubtractor1    ;  (data is 10)
           bra  LA1C8          ; branch

   LA1C7:  sba                 ; subtract (a=a-b)
   LA1C8:  bcc  O2_SensorStuckOnOneSideTooLong    ; branch if greater or equal
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
           ldab O2LIML_O2RangeLimitLow    ; load b with memory contents (data is b3)
           bra  SET_TO_MAX_OR_MIN_VALUE    ; branch

DIDNT_2SCOMPLEMENT_OVERFLOW_UNDERFLOW1:
           cba             
           bge  SET_TO_MAX_OR_MIN_VALUE    ; branch if greater or equal
           ldab O2LIML_O2RangeLimitLow    ; load b with memory contents (data is b3)
           cba             
           bge  LA1EB          ; branch if greater or equal
SET_TO_MAX_OR_MIN_VALUE:
           tba                 ; a = b
   LA1EB:  brclr *BitFlags67, #b67_BadO2, LA1F2    ; branch if bit(s) clear
           tsta                ; test a
           bmi  DontUpdateO2FeedbackCount    ; branch if minus(hi bit 1)
   LA1F2:  staa Counter_O2SensorFeedbackCount_Signed    ; store a into memory
DontUpdateO2FeedbackCount:
           rts                 ; return from subroutine

DetermineRampCellFromRPMandMAP:
           brset *BitFlags67, #b67_FallToIdle, LA201    ; branch if bit(s) set
           brset *BitFlags66, #b66_OffIdle, LA201    ; branch if bit(s) set
           ldab #0x16          ; load b with value -00010110-
           bra  LoadCellValue    ; branch

   LA201:  clrb                ; b = 0
           ldaa EngineRpm_HB    ; load a with memory contents
FindRPMCell:
           cmpa 0x00, X        ; compare a with memory at index + value
           bcs  LA210          ; branch if lower
           incb            
           inx                 ; increment index (x=x+1)
           cmpb #0x02          ;  -00000010-
           bcs  FindRPMCell    ; branch if lower
           bra  LA215          ; branch

   LA210:  tstb            
           bne  LA214          ; branch if not equal (not zero)
           inx                 ; increment index (x=x+1)
   LA214:  inx                 ; increment index (x=x+1)
   LA215:  ldaa MapValue       ; load a with memory contents
FindMAPCell:
           cmpa 0x00, X        ; compare a with memory at index + value
           bcs  LA224          ; branch if lower
           addb #0x03          ;  -00000011-
           inx                 ; increment index (x=x+1)
           cmpb #0x06          ;  -00000110-
           bcs  FindMAPCell    ; branch if lower
           bra  LA22A          ; branch

   LA224:  cmpb #0x03          ;  -00000011-
           bcc  LA229          ; branch if greater or equal
           inx                 ; increment index (x=x+1)
   LA229:  inx                 ; increment index (x=x+1)
   LA22A:  lslb            
LoadCellValue:
           brclr *BitFlags66, #b66_O2Rich, LA230    ; branch if bit(s) clear
           incb            
   LA230:  abx                 ; add b to index
           ldaa 0x14, X        ; load a with memory at index + value
           tab                 ; b = a
           rts                 ; return from subroutine

AdaptiveMemory_UpdateCellIfRequired_MM:
           ldx  #AutoCalCell0    ; load index with value
           ldab PointerIntoAdaptiveMemory    ; load b with memory contents
           abx                 ; add b to index
           brset *PIA1_Buffer, #pi1_PurgeSol, LA264    ; branch if bit(s) set
           brclr *CylTrim_Adaptive_Var1, #$%11111111, LA264    ; branch if bit(s) clear
           ldY #Cyl2_InjPWTrim    ; load Y index -00000000 00101010-
           cmpb CL2PTR_Cyl2AdaptiveMemoryPointer    ; compare b with memory contents (data is 0d)
           beq  LA261          ; branch if equal (zero)
           inY                 ; increment Y
           cmpb CL1PTR_Cyl1AdaptiveMemoryPointer    ; compare b with memory contents (data is 03)
           beq  LA261          ; branch if equal (zero)
           inY                 ; increment Y
           cmpb CL3PTR_Cyl3AdaptiveMemoryPointer    ; compare b with memory contents (data is 04)
           beq  LA261          ; branch if equal (zero)
           inY                 ; increment Y
           cmpb CL4PTR_Cyl4AdaptiveMemoryPointer    ; compare b with memory contents (data is 05)
           bne  LA264          ; branch if not equal (not zero)
   LA261:  xgDY                ; exchange D and Y
           xgDX                ; exchange D and X
   LA264:  ldab AMUPDT_EPPsBetweenCalChangeUpdateOpenThrottle    ; load b with memory contents (data is 1a)
           brset *BitFlags66, #b66_OffIdle, UpdateAdaptive_OffIdle    ; branch if bit(s) set
           ldab AMUPDI_EPPsBetweenCalChangeUpdateClosedThrottle    ; load b with memory contents (data is 1a)
UpdateAdaptive_OffIdle:
           brset *BitFlags67, #b67_OpenLoop, DontUpdateCell_MaybeUpdateTimer    ; branch if bit(s) set
           stab Temp0          ; store b into memory
           ldd  InjectorPulsewidth_HB    ; load d (a&b) with memory contents
           addd Pulsewidth_PartThrottleEnrichment_HB    ; d = d + memory contents
           subd PWMIN_NoCellUpdateBelow_PWMIN_Pulsewidth    ;  (data is 012c)
           ldab Temp0          ; load b with memory contents
           bcs  DontUpdateCell_MaybeUpdateTimer    ; branch if lower
           sei                 ; disable interrupts
           ldaa AdaptiveCellUpdateTimer_IncrementedEveryDistRisingEdge    ; load a with memory contents
           sba                 ; subtract (a=a-b)
           bcs  DontUpdateCellOrTimer    ; branch if lower
           staa AdaptiveCellUpdateTimer_IncrementedEveryDistRisingEdge    ; store a into memory
           cli                 ; enable interrupts
           ldaa CELCHG_BitsChangePerUpdateWithinACell    ; load a with memory contents (data is 01)
           ldab Counter_O2SensorFeedbackCount_Signed    ; load b with memory contents
           bpl  LA290          ; branch if plus (hi bit 0)
           nega                ; negate a (set high bit)
   LA290:  ldab AMLIMH_MaxMultiplierCannotBeAbove7F    ; load b with memory contents (data is 7f)
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
           bge  LA2AA          ; branch if greater or equal
Adaptive_SetCellToMaxOrMinValue:
           tba                 ; a = b
   LA2AA:  staa 0x00, X    
DontUpdateCellOrTimer:
           cli                 ; enable interrupts
           ldaa 0x00, X        ; load a with memory at index + value
           staa ValueFromAdaptiveMemory    ; store a into memory
           rts                 ; return from subroutine

DontUpdateCell_MaybeUpdateTimer:
           ldaa 0x00, X        ; load a with memory at index + value
           staa ValueFromAdaptiveMemory    ; store a into memory
           ldaa AdaptiveCellUpdateTimer_IncrementedEveryDistRisingEdge    ; load a with memory contents
           cba             
           bcs  LA2BD          ; branch if lower
           stab AdaptiveCellUpdateTimer_IncrementedEveryDistRisingEdge    ; store b into memory
   LA2BD:  rts                 ; return from subroutine

AdaptiveMemory_DetermineWhichCellApplies_MM:
           clra                ; a = 0
           staa Temp0          ; store a into memory
           ldx  #MP1_AutoCalMapCellBoundary1    ; load index with value
           ldab PointerIntoAdaptiveMemory    ; load b with memory contents
           brset *BitFlags66, #b66_OffIdle, ONTHROTTLE_OR_RPMTOOHIGHFORIDLE    ; branch if bit(s) set
           ldaa TargetIdleSpeedHB    ; load a with memory contents
           adda IDLOFS_DeltaForIdleRPMForClosedThrottleCell    ;  (data is 03)
           cmpb #0x0c          ;  -00001100-
           bcs  LA2D6          ; branch if lower
           adda HYTRPM_HysteresisFor_IDLOFS    ;  (data is 02)
   LA2D6:  cmpa EngineRpm_HB    ; compare a with memory contents
           bcs  ONTHROTTLE_OR_RPMTOOHIGHFORIDLE    ; branch if lower
           ldab #0x0c          ; load b with value -00001100-
           brset *BitFlags_AIS, #b10_ATXInGear, LA30D    ; branch if bit(s) set
           incb            
           bra  LA30D          ; branch

   LA2E3:  ldaa 0x00, X        ; load a with memory at index + value
           cmpb Temp0      
           bcc  LA2EC          ; branch if greater or equal
           adda DLTMAP_MapHysteresisAtMapCellBoundaries    ;  (data is 01)
   LA2EC:  cmpa MapValue       ; compare a with memory contents
           bcc  LA2FC          ; branch if greater or equal
           inx                 ; increment index (x=x+1)
ONTHROTTLE_OR_RPMTOOHIGHFORIDLE:
           ldaa Temp0          ; load a with memory contents
           adda #0x02          ;  -00000010-
           staa Temp0          ; store a into memory
           cpx  #MP5_AutoCalMapCellBoundary5    ;  -10000100 11010000-
           bls  LA2E3          ; branch if lower or same
   LA2FC:  ldaa R1_RPMCellBoundaryInRPMover32    ; load a with memory contents (data is 3a)
           lsrb                ; logical shift right b
           bcs  LA305          ; branch if lower
           adda DLTRPM_DeltaRPMAtRPMBoundariesInRPMOver32    ;  (data is 02)
   LA305:  ldab Temp0          ; load b with memory contents
           cmpa EngineRpm_HB    ; compare a with memory contents
           bcs  LA30C          ; branch if lower
           decb            
   LA30C:  decb            
   LA30D:  cmpb PointerIntoAdaptiveMemory
           beq  LA333          ; branch if equal (zero)
           clra                ; a = 0
           staa AdaptiveCellUpdateTimer_IncrementedEveryDistRisingEdge    ; store a into memory
           staa CylTrim_Adaptive_Var1    ; store a into memory
           ldaa #0x80          ; load a with value -10000000-
           cmpb CL2PTR_Cyl2AdaptiveMemoryPointer    ; compare b with memory contents (data is 0d)
           beq  LA32F          ; branch if equal (zero)
           lsra            
           cmpb CL1PTR_Cyl1AdaptiveMemoryPointer    ; compare b with memory contents (data is 03)
           beq  LA32F          ; branch if equal (zero)
           lsra            
           cmpb CL3PTR_Cyl3AdaptiveMemoryPointer    ; compare b with memory contents (data is 04)
           beq  LA32F          ; branch if equal (zero)
           lsra            
           cmpb CL4PTR_Cyl4AdaptiveMemoryPointer    ; compare b with memory contents (data is 05)
           bne  LA333          ; branch if not equal (not zero)
   LA32F:  eora CylTrim_FlagsE6
           staa CylTrim_FlagsE6    ; store a into memory
   LA333:  stab PointerIntoAdaptiveMemory    ; store b into memory
           rts                 ; return from subroutine

HandleAmTimer_MM:
           brclr *BitFlags6d, #b6d_FuelEngineNotRunning, AMTimer_EngineRunning    ; branch if bit(s) clear
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #AMTPSW_TempPointToEnableSelectedAMTimer    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop    ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #CLTIME_ClosedLoopTimeFromEngTempAtStartup_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Timer_CLTIME_ClosedLoopTimer    ; store a into memory
           bclr *BitFlags66, #b66_OpenLoop    ; clear bits
AMTimer_EngineRunning:
           ldaa CoolantTemp    ; load a with memory contents
           ldab Counter_MainLoop    ; load b with memory contents
           bne  LA370          ; branch if not equal (not zero)
           cmpa AMTEMP_StartTempToSelectHotOrColdAMTimer    ; compare a with memory contents (data is cf)
           bcs  LA364          ; branch if lower
           ldab Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop    ; load b with memory contents
           beq  LA370          ; branch if equal (zero)
           decb            
           stab Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop    ; store b into memory
           rts                 ; return from subroutine

   LA364:  bne  LA370          ; branch if not equal (not zero)
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #AMTPSW_TempPointToEnableSelectedAMTimer    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop    ; store a into memory
   LA370:  rts                 ; return from subroutine


	;.org	0xa371
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

	;.org	0xa399
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

	;.org	0xa3aa
ATMFunctionTable:
		.word	ATM_SerialOut
		.word	ATM_IgnitionCoil
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
		.word	LA96C
		.word	ATM_Tachometer
		.word	ATM_PTUIndicator
		.word	LA91D
		.word	ATM_WGSolenoid
		.word	ATM_BaroReadSolenoid
		.word	ATM_SerialOut
		.word	ATM_AllSolenoidsRelays
		.word	ATM_SerialOut
		.word	ATM_SerialOut
		.word	ATM_PTUIndicator
		.word	ATM_SerialOut
		.word	ATM_SerialOut
		.word	ATM_PTUIndicator
		.word	ATM_WGSolenoid
		.word	LA8C7
		.word	ATM_InjBank4
		.word	ATM_SerialOut
		.word	ATM_SerialOut
		.word	ATM_WGSolenoid
		.word	ATM_SerialOut

	;.org	0xa3ee
DRBMemoryTable:
		.word	AmbientAirTempVolts
		.word	O2SensorValue
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
		.word	ChargeTemp
		.word	ChargeTempRaw
		.word	CruiseSpeedSetpoint
		.word	ErrorCodeUpdateKeyOnCount2
		.word	ErrorCodeUpdateKeyOnCount3
		.word	Counter_Cruise_1
		.word	Temp0
		.word	Temp0
		.word	CCDBatteryVoltsOutput
		.word	TargetBatteryVolts
		.word	BoostActuatorADutyCycle_VNT
		.word	BoostActuatorBDutyCycle_WG
		.word	CCDFlags5
		.word	BoostActuatorBDutyCycle_WG
		.word	Temp0
		.word	Temp0
		.word	Temp0

	;.org	0xa444
SwitchTestTable:
		.word	SendSwitchStateToSerial
		.word	SendOutputStatusToSerial
		.word	SendOutputStatusToSerial2

	;.org	0xa44a
RealTimeDataTable:
		.word	SCI_MAPVolts
		.word	SCI_Speed
		.word	SCI_O2Volts
		.word	EndRealTimeData
		.word	DRB_Return
		.word	SendBaro
		.word	SendTPS
		.word	LA622

        

DRBIISerialCommunications_MM:
           ;jsr  NULL_ROUTINE    ; call subroutine
           ;jsr  BYTE_MODE_SERIAL_CODE_DOWNLOAD_ROUTINE    ; call subroutine
           ldab DRBSerialMode    ; load b with memory contents
           bitb #0xc0          ;  -11000000-
           bne  LA4D1          ; branch if not equal (not zero)
           ldaa CPU_SerialBaudRate    ; load a with memory contents
           anda #0x37          ; AND a with value -00110111-
           cmpa #0x22          ; compare a with value -00100010-
           beq  LA475          ; branch if equal (zero)
           ldaa #0x22          ; load a with value -00100010-
           staa CPU_SerialBaudRate
           rts                 ; return from subroutine

   LA475:  ldaa CPU_SerialStatus    ; load a with memory contents
           bita #0x0e          ;  -00001110-
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
           brclr *DRBSerialMode, #$%00110000, LA4D1    ; branch if bit(s) clear
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
           bclr *BitFlags70, #b70_bit0    ; clear bits
DRB_SetModeVar:
           staa DRBPointer1    ; store a into memory
           clrb                ; b = 0
           stab DRBPointer2    ; store b into memory
           stab DRBPointer3    ; store b into memory
           cmpa #0x23          ; compare a with value -00100011-
           bhi  LA4D1          ; branch if higher
           suba #0x13          ;  -00010011-
           bcs  LA4D1          ; branch if lower
           tab                 ; b = a
           ldx  #DRBSerialToggles    ; load index with value
           abx                 ; add b to index
           ldab 0x00, X        ; load b with memory at index + value
           orab DRBSerialMode
           stab DRBSerialMode    ; store b into memory
           rts                 ; return from subroutine

DRB_StorePointer:
           bitb #0x20          ;  -00100000-
           bne  LA4D2          ; branch if not equal (not zero)
           staa DRBPointer3    ; store a into memory
           andb #0xcf          ;  -11001111-
           stab DRBSerialMode    ; store b into memory
   LA4D1:  rts                 ; return from subroutine

   LA4D2:  staa DRBPointer2    ; store a into memory
           andb #0xdf          ;  -11011111-
           stab DRBSerialMode    ; store b into memory
           rts                 ; return from subroutine

DRBIIOuput_MM:
           ldaa DRBSerialMode    ; load a with memory contents
           bita #0x30          ;  -00110000-
           bne  LA4D1          ; branch if not equal (not zero)
           ldab DRBPointer1    ; load b with memory contents
           subb #0x10          ;  -00010000-
           bcs  LA4D1          ; branch if lower
           cmpb #0x13          ;  -00010011-
           bhi  LA4D1          ; branch if higher
           lslb            
           ldx  #DRBFunctionTable    ; load index with value
           abx                 ; add b to index
           ldx  0x00, X    
           jmp  0x00, X        ; indexed jump

OutputErrorCodes:
           ldx  #ErrorBitRegister0    ; load index with value
           ldab DRBPointer2    ; load b with memory contents
           cmpb #0x07          ;  -00000111-
           bhi  LA508          ; branch if higher
           negb            
           addb #0x07          ;  -00000111-
           abx                 ; add b to index
           inc  DRBPointer2
           ldaa 0x00, X        ; load a with memory at index + value
           beq  LA509          ; branch if equal (zero)
           bra  LA52B          ; branch

   LA508:  dex                 ; decrement index (x=x-1)
   LA509:  clr  DRBPointer1    ; zero byte at memory location
           ldaa #0xfe          ; load a with value -11111110-
           jsr  SerialOutput1a    ; call subroutine
           adda #0x10          ;  -00010000-
   LA513:  inx                 ; increment index (x=x+1)
           cpx  #ErrorCodeUpdateKeyOnCount    ;  -00000000 00100111-
           bcc  LA52B          ; branch if greater or equal
           adda 0x00, X    
           bra  LA513          ; branch

OutputErrorBits:
           ldaa ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB    ; load a with memory contents
           brclr *DRBPointer2, #$%11111111, LA528    ; branch if bit(s) clear
           ldaa ErrorBitsAssociatedWithPIA1AndReg1eTo25_LB    ; load a with memory contents
           clr  DRBPointer1    ; zero byte at memory location
   LA528:  inc  DRBPointer2
   LA52B:  jmp  SerialOutput1a

SetupHiSpeedDataTransfer:
           bset *DRBSerialMode, #$%10000000    ; set bits
           clr  DRBPointer1    ; zero byte at memory location
   LA534:  ldaa CPU_SerialStatus    ; load a with memory contents
           bita #0x40          ;  -01000000-
           beq  LA534          ; branch if equal (zero)
           ldaa #0x01          ; load a with value -00000001-
           staa CPU_SerialBaudRate
DRB_Return:
           rts                 ; return from subroutine

SetupATM:
           clra                ; a = 0
           staa DRBPointer1    ; store a into memory
           ldab TimerOverflowsBetweenDistPulses    ; load b with memory contents
           cmpb #0x50          ;  -01010000-
           bls  LA55A          ; branch if lower or same
           brset *BitFlags70, #b70_O2Enable, LA55A    ; branch if bit(s) set
           ldaa DRBPointer2    ; load a with memory contents
           cmpa #0x21          ; compare a with value -00100001-
           bhi  LA55A          ; branch if higher
           ldab #0x02          ; load b with value -00000010-
           stab KeyOnOrEngineRunningTime    ; store b into memory
           bra  LA55E          ; branch

   LA55A:  bclr *BitFlags70, #b70_O2Enable    ; clear bits
           clra                ; a = 0
   LA55E:  staa ATMOffset      ; store a into memory
           tab                 ; b = a
           lslb            
           beq  ATM_SerialOut          ; branch if equal (zero)
           ldx  #ATMFunctionTable    ; load index with value
           abx                 ; add b to index
           ldx  0x00, X    
           cpx  #ATM_SerialOut         ;  -10100101 01101111-
           bne  LA52B          ; branch if not equal (not zero)
ATM_SerialOut:
           clra                ; a = 0
           staa ATMOffset      ; store a into memory
           jmp  SerialOutput1

SendDiagnosticDataToSCI:
           clrb                ; b = 0
           stab Temp0          ; store b into memory
           stab DRBPointer1    ; store b into memory
           ldab DRBPointer2    ; load b with memory contents
           beq  LA597          ; branch if equal (zero)
           cmpb #0x40          ;  -01000000-
           bcc  LA5AC          ; branch if greater or equal
           cmpb #0x2b          ;  -00101011-
           bhi  LA597          ; branch if higher
           cmpb #0x10          ;  -00010000-
           bne  SendRealTImeDatatoSCI    ; branch if not equal (not zero)
           brset *BitFlags66, #b66_OffIdle, LA597    ; branch if bit(s) set
           brset *BitFlags_AIS, #b10_ATXInGear, LA597    ; branch if bit(s) set
           bset *BitFlags70, #b70_bit0    ; set bits
           bra  SendRealTImeDatatoSCI    ; branch

   LA597:  clra                ; a = 0
           staa DRBPointer1    ; store a into memory
           rts                 ; return from subroutine

SendRealTImeDatatoSCI:
           ldx  #DRBMemoryTable-2        ; load index with value
           lslb
           abx                 ; add b to index
           ldx  0x00, X    
           cpx  #Temp0         ;  -00000000 11110101-
           beq  LA597          ; branch if equal (zero)
           ldaa 0x00, X        ; load a with memory at index + value
           jmp  SerialOutput1a

   LA5AC:  subb #0x40          ;  -01000000-
           cmpb #0x07          ;  -00000111-
           bhi  LA597          ; branch if higher
           ldx  #RealTimeDataTable    ; load index with value
           lslb            
           abx                 ; add b to index
           ldx  0x00, X    
           jmp  0x00, X        ; indexed jump

SCI_MAPVolts:
           sei                 ; disable interrupts
           ldaa #0x10          ; load a with value -00010000-
           staa CPU_A2DControlReg
           ldaa #0x07          ; load a with value -00000111-
   LA5C3:  deca                ; decrement a
           bne  LA5C3          ; branch if not equal (not zero)
           ldaa CPU_A2DResults1    ; load a with memory contents
           cli                 ; enable interrupts
           bra  LA5D5          ; branch

SCI_Speed:
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           bcc  LA5D5          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LA5D5:  jmp  SerialOutput1a

SCI_O2Volts:
           ldab O2SensorValue    ; load b with memory contents
           ldaa #0xff          ; load a with value -11111111-
           cmpb O2MIDH_HighLimitForInMiddleDetermination    ; compare b with memory contents (data is 1c)
           bhi  LA5E8          ; branch if higher
           cmpb O2MIDL_LowLimitForInMiddleDetermination    ; compare b with memory contents (data is 12)
           bhi  LA5D5          ; branch if higher
           anda #0xa0          ; AND a with value -10100000-
   LA5E8:  anda #0xb1          ; AND a with value -10110001-
           bra  LA5D5          ; branch

EndRealTimeData:
           clra                ; a = 0
           staa DRBPointer1    ; store a into memory
           brset *BitFlags66, #b66_OffIdle, SerialOutput1a    ; branch if bit(s) set
           brset *BitFlags6d, #b6d_FuelEngineNotRunning, SerialOutput1a    ; branch if bit(s) set
           staa Timer_BaroReadInterval    ; store a into memory
           bclr *BitFlags68, #b68_BaroSolEnergized    ; clear bits
           bset *BitFlags68, #b68_SparkEngineNotRunning    ; set bits
           bclr *PIA2_Buffer, #pi2_Baro    ; clear bits
           ldaa #0xe3          ; load a with value -11100011-
           bra  SerialOutput1a    ; branch

SendBaro:
           ldaa BaroPressure    ; load a with memory contents
           suba MapValue   
           jmp  SerialOutput1a

SendTPS:
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bcc  LA614          ; branch if greater or equal
           clra                ; a = 0
   LA614:  ldab #0xc5          ; load b with value -11000101-
           staa Temp0          ; store a into memory
           mul                 ; multiply (d=a*b)
           adca Temp0
           bcc  LA61F          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LA61F:  jmp  SerialOutput1a

   LA622:  ldaa CalculatedSparkAdvance    ; load a with memory contents
           jmp  SerialOutput1a

SendECUIDToSCI:
           clra                ; a = 0
           staa DRBPointer1    ; store a into memory
           ldab DRBPointer3    ; load b with memory contents
           ldaa DRBPointer2    ; load a with memory contents
           xgDX                ; exchange D and X
           ldaa 0x00, X        ; load a with memory at index + value
           jmp  SerialOutput1a

SendConstValues:
           ldx  #ENDIT1_PNPrefix    ; load index with value
           ldab DRBPointer2    ; load b with memory contents
           bpl  LA63F          ; branch if plus (hi bit 0)
           lslb            
           lslb            
           stab DRBPointer2    ; store b into memory
   LA63F:  abx                 ; add b to index
           ldaa 0x00, X        ; load a with memory at index + value
           inc  DRBPointer2
           brclr *DRBPointer2, #$%00000011, LA64B    ; branch if bit(s) clear
           bra  SerialOutput1a    ; branch

   LA64B:  bsr  SerialOutput1a    ; call subroutine
           adda #0x16          ;  -00010110-
           dex                 ; decrement index (x=x-1)
           adda 0x00, X    
           dex                 ; decrement index (x=x-1)
           adda 0x00, X    
           dex                 ; decrement index (x=x-1)
           adda 0x00, X    
           ldab DRBPointer2    ; load b with memory contents
           subb #0x04          ;  -00000100-
           lsrb                ; logical shift right b
           lsrb                ; logical shift right b
           orab #0x80          ;  -10000000-
           aba                 ; a=a+b
           clr  DRBPointer1    ; zero byte at memory location
           bra  SerialOutput1a    ; branch

   LA666:  clra                ; a = 0
           staa DRBPointer1    ; store a into memory
SerialOutput1:
           clra                ; a = 0
SerialOutput1a:
           ldab CPU_SerialStatus    ; load b with memory contents
           bpl  SerialOutput1a    ; branch if plus (hi bit 0)
           staa CPU_SerialData
           rts                 ; return from subroutine

ClearErrorCodes:
           ldab TimerOverflowsBetweenDistPulses    ; load b with memory contents
           cmpb #0x50          ;  -01010000-
           bhi  LA67C          ; branch if higher
   LA679:  jmp  LA55A      

   LA67C:  brset *BitFlags70, #b70_O2Enable, LA679    ; branch if bit(s) set
           ldab DRBSerialMode    ; load b with memory contents
           andb #0x0f          ;  -00001111-
           cmpb #0x03          ;  -00000011-
           bls  LA68B          ; branch if lower or same
           clr  ErrorCodeEraseCounter     ; zero byte at memory location
   LA68B:  ldaa ErrorCodeEraseCounter     ; load a with memory contents
           inca                ; increment a
           cmpa #0x18          ; compare a with value -00011000-
           bls  LA69C          ; branch if lower or same
           clra                ; a = 0
           staa ErrorCodeEraseCounter     ; store a into memory
           jsr  DRB_ClearErrorCodes    ; call subroutine
           ldaa #0xe0          ; load a with value -11100000-
           bra  SerialOutput1a    ; branch

   LA69C:  staa ErrorCodeEraseCounter     ; store a into memory
           ldd  #0xff00        ; load d (a&b) with value -11111111 00000000-
           stab DRBPointer1    ; store b into memory
           bra  SerialOutput1a    ; branch

SwitchTest:
           ldab DRBPointer2    ; load b with memory contents
           beq  LA6D3          ; branch if equal (zero)
           cmpb #0x03          ;  -00000011-
           bhi  LA6D3          ; branch if higher
           ldx  #SwitchTestTable-2        ; load index with value
           lslb
           abx                 ; add b to index
           ldx  0x00, X    
           jmp  0x00, X        ; indexed jump

SendSwitchStateToSerial:
           ldaa StartupSwitchMirror1    ; load a with memory contents
           anda #~sw1_B1Volt          ; AND a with value -01111111-
           ldab SwitchPortAccessReg1    ; load b with memory contents
           bitb #0x20          ;  -00100000-
           beq  SerialOutput1a    ; branch if equal (zero)
           oraa #0x80          ;  -10000000-
           bra  SerialOutput1a    ; branch

SendOutputStatusToSerial:
           ldaa PIA2_Buffer    ; load a with memory contents
           bra  SerialOutput1a    ; branch

SendOutputStatusToSerial2:
           ldaa PIA1_Buffer    ; load a with memory contents
           bra  SerialOutput1a    ; branch

InitByteModeDownload:
           bset *DRBSerialMode, #$%01000000    ; set bits
           clr  DRBPointer1    ; zero byte at memory location
   LA6D3:  rts                 ; return from subroutine

DRB_ResetEMR:
           clr  DRBPointer1    ; zero byte at memory location
           sei                 ; disable interrupts
           ldab BitFlags6a     ; load b with memory contents
           bitb #b6a_DRBToggle2 | b6a_DRBToggle1          ;  -00000011-
           bne  LA6EC          ; branch if not equal (not zero)
           bset *BitFlags6a, #b6a_DRBToggle1    ; set bits
           cli                 ; enable interrupts
           ldaa DRBPointer3    ; load a with memory contents
           staa DRBOffsetStored_LB    ; store a into memory
           ldab DRBPointer2    ; load b with memory contents
           stab DRBOffsetStored_HB    ; store b into memory
           ldaa #0xe2          ; load a with value -11100010-
   LA6EC:  cli                 ; enable interrupts
           jmp  SerialOutput1a

DRB_UseRAMForSpecialProgramRoutine:
           ldx  #L0000         ; load index with value
           bra  LA714          ; branch

DRB_UseRAM2ForSpecialProgramRoutine:
           ldx  #ErrorCodeCounter    ; load index with value
           bra  LA714          ; branch

DRB_CheckSpecialProgramSize:
           ldaa DRBPointer2    ; load a with memory contents
           bne  LA711          ; branch if not equal (not zero)
           ldx  #DRB_ProgramModeFlag    ; load index with value
           ldab DRBPointer3    ; load b with memory contents
           abx                 ; add b to index
           cpx  #0x60c9        ;  -01100000 11001001-
           bcs  LA711          ; branch if lower
           ldaa #0xff          ; load a with value -11111111-
           staa DRB_ProgramModeFlag
   LA70E:  jmp  LA666      

   LA711:  ldx  #DRB_ProgramModeFlag    ; load index with value
   LA714:  clra                ; a = 0
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
           beq  LA731          ; branch if equal (zero)
           comb            
           cmpb 0x01, X    
           bne  DRB_OutputSpecialCodes    ; branch if not equal (not zero)
   LA731:  ldab DRBPointer2    ; load b with memory contents
           cmpb 0x00, X    
           bne  LA761          ; branch if not equal (not zero)
           abx                 ; add b to index
           ldaa 0x01, X        ; load a with memory at index + value
           cmpa #0x39          ; compare a with value -00111001-
           bne  LA70E          ; branch if not equal (not zero)
           ldx  #DRB_ProgramModeFlag    ; load index with value
           clra                ; a = 0
   LA742:  inx                 ; increment index (x=x+1)
           adda 0x01, X    
           decb            
           bne  LA742          ; branch if not equal (not zero)
           cmpa DRBPointer3    ; compare a with memory contents
           beq  LA755          ; branch if equal (zero)
           ldab DRBPointer3    ; load b with memory contents
           comb            
           cba             
           bne  DRB_OutputSpecialCodes    ; branch if not equal (not zero)
           jmp  DRB_SpecialProgramRoutine

   LA755:  com  DRBPointer3
           ldaa #0xe4          ; load a with value -11100100-
           jmp  SerialOutput1a

DRB_OutputSpecialCodes:
           ldaa #0x01          ; load a with value -00000001-
           bra  LA767          ; branch

   LA761:  ldaa #0x02          ; load a with value -00000010-
           bra  LA767          ; branch

   LA765:  ldaa #0x03          ; load a with value -00000011-
   LA767:  clrb                ; b = 0
           stab DRBPointer1    ; store b into memory
           jmp  SerialOutput1a

DRB_Special1:
           brclr *DRBPointer2, #$%11111111, LA70E    ; branch if bit(s) clear
           ldaa DRBPointer3    ; load a with memory contents
           bne  LA785          ; branch if not equal (not zero)
           brset *BitFlags66, #b66_OffIdle, LA761    ; branch if bit(s) set
           brset *BitFlags_AIS, #b10_ATXInGear, LA765    ; branch if bit(s) set
           coma            
           staa DRBPointer3    ; store a into memory
   LA780:  ldaa #0x01          ; load a with value -00000001-
           jmp  SerialOutput1a

   LA785:  brset *BitFlags66, #b66_OffIdle, LA78D    ; branch if bit(s) set
           brclr *BitFlags_AIS, #b10_ATXInGear, LA790    ; branch if bit(s) clear
   LA78D:  clra                ; a = 0
           staa DRBPointer1    ; store a into memory
   LA790:  rts                 ; return from subroutine

DRB_Special2:
           ldaa DRBPointer3    ; load a with memory contents
           beq  LA7B6          ; branch if equal (zero)
           ldaa DRBPointer2    ; load a with memory contents
           cmpa #0x01          ; compare a with value -00000001-
           beq  LA7AE          ; branch if equal (zero)
           cmpa #0x02          ; compare a with value -00000010-
           beq  LA7B2          ; branch if equal (zero)
           cmpa #0x03          ; compare a with value -00000011-
           bne  LA78D          ; branch if not equal (not zero)
           ldd  TargetIdleSpeedHB    ; load d (a&b) with memory contents
   LA7A5:  stab Temp0          ; store b into memory
           jsr  SerialOutput1a    ; call subroutine
           ldaa Temp0          ; load a with memory contents
           bra  LA767          ; branch

   LA7AE:  ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           bra  LA7A5          ; branch

   LA7B2:  ldd  InjectorPulsewidth_HB    ; load d (a&b) with memory contents
           bra  LA7A5          ; branch

   LA7B6:  coma            
           staa DRBPointer3    ; store a into memory
           rts                 ; return from subroutine

DRB_ClearAdaptiveMemory:
           clra                ; a = 0
           staa DRBPointer1    ; store a into memory
           ldaa TimerOverflowsBetweenDistPulses    ; load a with memory contents
           cmpa #0x50          ; compare a with value -01010000-
           bhi  LA7C6          ; branch if higher
           jmp  SerialOutput1

   LA7C6:  ldaa DRBPointer2    ; load a with memory contents
           cmpa #0x01          ; compare a with value -00000001-
           beq  LA80E          ; branch if equal (zero)
           cmpa #0x02          ; compare a with value -00000010-
           beq  DRB_ClearAdaptives          ; branch if equal (zero)
           cmpa #0x03          ; compare a with value -00000011-
           beq  LA7DF          ; branch if equal (zero)
           cmpa #0x04          ; compare a with value -00000100-
           bne  LA780          ; branch if not equal (not zero)
           ldaa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load a with memory contents (data is 5c)
           staa MINTHR_LowestSessionTPS    ; store a into memory
           bra  LA817          ; branch

   LA7DF:  sei                 ; disable interrupts
           bset *BitFlags_AIS, #b10_UseAIS    ; set bits
           ldaa #0xdf          ; load a with value -11011111-
           staa CurrentAisPosition    ; store a into memory
           cli                 ; enable interrupts
           bra  LA817          ; branch

DRB_ClearAdaptives:
           clra                ; a = 0
           staa ValueFromAdaptiveMemory    ; store a into memory
           staa CylTrim_Adaptive_Var1    ; store a into memory
           staa CylTrimFlags    ; store a into memory
           staa CylTrim_FlagsE6    ; store a into memory
           staa Cyl2_InjPWTrim    ; store a into memory
           staa Cyl1_InjPWTrim    ; store a into memory
           staa Cyl3_InjPWTrim    ; store a into memory
           staa Cyl4_InjPWTrim    ; store a into memory
           bset *BitFlags67, #b67_OpenLoop    ; set bits
           bset *CylTrimFlags, #$%00100000    ; set bits
           ldx  #AutoCalCell0    ; load index with value
   LA804:  staa 0x00, X    
           inx                 ; increment index (x=x+1)
           cpx  #ErrorBitRegister0    ;  -00000000 00011111-
           bcs  LA804          ; branch if lower
           bra  LA817          ; branch

   LA80E:  ldaa CPU_EEPROMControlReg    ; load a with memory contents
           bita #0x01          ;  -00000001-
           bne  LA81B          ; branch if not equal (not zero)
           bsr  DRB_ClearErrorCodes    ; call subroutine
   LA817:  ldaa #0xf0          ; load a with value -11110000-
           bra  LA81D          ; branch

   LA81B:  ldaa #0x02          ; load a with value -00000010-
   LA81D:  jmp  SerialOutput1a

DRB_ClearErrorCodes:
           clra                ; a = 0
           clrb                ; b = 0
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
           beq  DRB_ClearMiscReturn          ; branch if equal (zero)
           ldx  #LB620         ; load index with value
           bsr  DRB_ClearEEPROMLocation          ; call subroutine
           ldx  #0xb630        ; load index with value
           bsr  DRB_ClearEEPROMLocation          ; call subroutine
           ldx  #0xb640        ; load index with value
           bsr  DRB_ClearEEPROMLocation          ; call subroutine
           ldx  #0xb650        ; load index with value

DRB_ClearEEPROMLocation:
           brset  0, X, #$%11111111, DRB_ClearMiscReturn    ; branch if bit(s) set
           ldaa #0x0e          ; load a with value -00001110-
           staa CPU_EEPROMControlReg
           stab 0x00, X    
           inca                ; increment a
           staa CPU_EEPROMControlReg
           ldx  #0x1a0a        ; delay value to wait until the erase cycle is complete...
   LA860:  dex                 ; decrement index (x=x-1)
           bne  LA860          ; branch if not equal (not zero)
           deca                ; decrement a
           staa CPU_EEPROMControlReg
           clr  CPU_EEPROMControlReg    ; zero byte at memory location
           jmp  OCToggleAndResetCopTimer

DRB_ClearMiscReturn:
           rts                 ; return from subroutine

ActuatorTestMode_MM:
           ldaa ATMOffset      ; load a with memory contents
           beq  LA883          ; branch if equal (zero)
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa #0x99          ; compare a with value -10011001-
           bcs  LA884          ; branch if lower
           clrb                ; b = 0
           ldaa DRBPointer1    ; load a with memory contents
           cmpa #0x13          ; compare a with value -00010011-
           bne  LA881          ; branch if not equal (not zero)
           stab DRBPointer1    ; store b into memory
   LA881:  stab ATMOffset      ; store b into memory
   LA883:  rts                 ; return from subroutine

   LA884:  ldaa PIA1_Buffer    ; load a with memory contents
           ldx  #ATMFunctionTable    ; load index with value
           ldab ATMOffset      ; load b with memory contents
           lslb            
           abx                 ; add b to index
           ldx  0x00, X    
           jmp  0x00, X        ; indexed jump

ATM_FanRelay:
           anda #0xdf          ; AND a with value -11011111-
           brclr *Counter_MainLoop, #$%01111110, ATM_SetOutputBits    ; branch if bit(s) clear
           oraa #0x20          ;  -00100000-
           bra  ATM_SetOutputBits    ; branch

ATM_ACClutchRelay:
           ldaa PIA2_Buffer    ; load a with memory contents
           oraa #pi2_ACRelay          ;  -00001000-
           ldab CONFIG_ConfigurationFlags    ; load b with memory contents (data is 9f)
           bitb #cfg_AC          ;  -10000000-
           beq  LA8A9          ; branch if equal (zero)
           bclr *PIA1_Buffer, #pi1_Fan    ; clear bits
   LA8A9:  brset *Counter_MainLoop, #$%10000000, LA8AF    ; branch if bit(s) set
           anda #0xf7          ; AND a with value -11110111-
   LA8AF:  jmp  LA933      

ATM_ASDRelay:
           ldab CPU_TimerControlReg1    ; load b with memory contents
           andb #0xea          ;  -11101010-
           orab #0x2a          ;  -00101010-
           stab CPU_TimerControlReg1    ; store b into memory
           ldab #0x08          ; load b with value -00001000-
           stab CPU_HardwareTimerForceCompare    ; store b into memory
           oraa #0x10          ;  -00010000-
           brset *Counter_MainLoop, #$%10000000, ATM_SetOutputBits    ; branch if bit(s) set
   LA8C7:  anda #0xef          ; AND a with value -11101111-
           bra  ATM_SetOutputBits    ; branch

ATM_PurgeSolenoid:
           oraa #0x40          ;  -01000000-
           brset *Counter_MainLoop, #$%10000000, ATM_SetOutputBits    ; branch if bit(s) set
           anda #0xbf          ; AND a with value -10111111-
ATM_SetOutputBits:
           staa PIA1_Buffer    ; store a into memory
           rts                 ; return from subroutine

ATM_WGSolenoid:
           clra                ; a = 0
           brset *Counter_MainLoop, #$%10000000, LA8DD    ; branch if bit(s) set
           ldaa #0xc8          ; load a with value -11001000-
   LA8DD:  cmpb #0x22          ;  -00100010-
           beq  LA8E5          ; branch if equal (zero)
           cmpb #0x40          ;  -01000000-
           bne  LA8F1          ; branch if not equal (not zero)
   LA8E5:  staa BoostActuatorBDutyCycle_WG    ; store a into memory
           beq  LA8ED          ; branch if equal (zero)
           bclr *PIA2_Buffer, #pi2_VNTSol    ; clear bits
           rts                 ; return from subroutine

   LA8ED:  bset *PIA2_Buffer, #pi2_VNTSol    ; set bits
           rts                 ; return from subroutine

   LA8F1:  staa BoostActuatorADutyCycle_VNT    ; store a into memory
           beq  LA8F9          ; branch if equal (zero)
           bclr *PIA2_Buffer, #pi2_WGSol    ; clear bits
           rts                 ; return from subroutine

   LA8F9:  bset *PIA2_Buffer, #pi2_WGSol    ; set bits
           rts                 ; return from subroutine

ATM_PTUIndicator:
           ldaa PIA2_Buffer    ; load a with memory contents
           oraa #pi2_PTU          ;  -00000100-
           brset *Counter_MainLoop, #$%10000000, LA933    ; branch if bit(s) set
           anda #~pi2_PTU          ; AND a with value -11111011-
           bra  LA933          ; branch

ATM_SCServoSolenoid:
           ldaa PIA2_Buffer    ; load a with memory contents
           oraa #pi2_SCVent | pi2_SCVac          ;  -00000011-
           ldab Counter_MainLoop    ; load b with memory contents
           cmpb #0x55          ;  -01010101-
           bcs  LA933          ; branch if lower
           anda #~(pi2_SCVent | pi2_SCVac)         ; AND a with value -11111100-
           cmpb #0xaa          ;  -10101010-
           bcs  LA933          ; branch if lower
           oraa #0x02          ;  -00000010-
           bra  LA933          ; branch

   LA91D:  ldaa PIA2_Buffer    ; load a with memory contents
           anda #~pi2_EGRSol          ; AND a with value -11011111-
           brset *Counter_MainLoop, #$%10000000, LA933    ; branch if bit(s) set
           oraa #pi2_EGRSol          ;  -00100000-
           bra  LA933          ; branch

ATM_BaroReadSolenoid:
           ldaa PIA2_Buffer    ; load a with memory contents
           anda #~pi2_Baro          ; AND a with value -11101111-
           brset *Counter_MainLoop, #$%10000000, LA933    ; branch if bit(s) set
           oraa #pi2_Baro          ;  -00010000-
   LA933:  staa PIA2_Buffer    ; store a into memory
           rts                 ; return from subroutine

ATM_AllSolenoidsRelays:
           ldab CPU_TimerControlReg1    ; load b with memory contents
           andb #0xea          ;  -11101010-
           orab #0x2a          ;  -00101010-
           stab CPU_TimerControlReg1    ; store b into memory
           ldab #0x08          ; load b with value -00001000-
           stab CPU_HardwareTimerForceCompare    ; store b into memory
           ldab #0x10          ; load b with value -00010000-
           anda #0xaf          ; AND a with value -10101111-
           brset *Counter_MainLoop, #$%10000000, LA951    ; branch if bit(s) set
           oraa #0x50          ;  -01010000-
           ldab #0x70          ; load b with value -01110000-
   LA951:  stab DesiredNewAisPosition    ; store b into memory
           staa PIA1_Buffer    ; store a into memory
           ldaa PIA2_Buffer    ; load a with memory contents
           oraa #0x37          ;  -00110111-
           anda #0x3f          ; AND a with value -00111111-
           ldab #0xc8          ; load b with value -11001000-
           brset *Counter_MainLoop, #$%10000000, LA966    ; branch if bit(s) set
           anda #0xc8          ; AND a with value -11001000-
           oraa #0xc0          ;  -11000000-
           clrb                ; b = 0
   LA966:  staa PIA2_Buffer    ; store a into memory
           stab BoostActuatorBDutyCycle_WG    ; store b into memory
           stab BoostActuatorADutyCycle_VNT    ; store b into memory
   LA96C:  ldx  #SwitchPortAccessReg1    ; load index with value
           brclr *Counter_MainLoop, #$%10000000, LA97B    ; branch if bit(s) clear
           bset  0, X, #$%00000100    ; bit set
           bset *BitFlags6f, #b6f_BadASD    ; set bits
           bra  LA981          ; branch

   LA97B:  bclr  0, X, #$%00000100    ; bit clear
           bclr *BitFlags6f, #b6f_BadASD    ; clear bits
   LA981:  sei                 ; disable interrupts
           bset  2, X, #$%00000100    ; bit set
           ldaa #0x08          ; load a with value -00001000-
   LA987:  deca                ; decrement a
           bne  LA987          ; branch if not equal (not zero)
           bclr  2, X, #$%00000100    ; bit clear
           cli                 ; enable interrupts
           rts                 ; return from subroutine

ATM_Tachometer:
           ldaa PIA3_Buffer    ; load a with memory contents
           eora #pi3_Tach          ; XOR a with value -00000010-
           staa PIA3_Buffer_2
           staa PIA3_Buffer    ; store a into memory
           rts                 ; return from subroutine

ATM_AISMotorOpenClose:
           ldaa #0x10          ; load a with value -00010000-
           brset *Counter_MainLoop, #$%10000000, LA9A1    ; branch if bit(s) set
           ldaa #0x70          ; load a with value -01110000-
   LA9A1:  staa DesiredNewAisPosition    ; store a into memory
           rts                 ; return from subroutine

ATM_IgnitionCoil:
           bclr *PIA1_Buffer, #pi1_ASD    ; clear bits
           ldab Counter_MainLoop    ; load b with memory contents
           lslb            
           bne  LA9CC          ; branch if not equal (not zero)
           sei                 ; disable interrupts
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           oraa #0x03          ;  -00000011-
           staa CPU_TimerControlReg1
           ldab #0x08          ; load b with value -00001000-
           stab CPU_HardwareTimerForceCompare    ; store b into memory
           ldd  CPU_TimerCounterRegHigh
           addd #0x0dac        ;  -00001101 10101100-
           std  CPU_Timer_OC5_Dwell
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           anda #0x3e          ; AND a with value -00111110-
           staa CPU_TimerControlReg1
           cli                 ; enable interrupts
   LA9CC:  rts                 ; return from subroutine

ATM_InjBank1:
           ldx  #InjectorPulsewidthBank1_HB    ; load index with value
           bra  LA9DF          ; branch

ATM_InjBank2:
           ldx  #InjectorPulsewidthBank2_HB    ; load index with value
           bra  LA9DF          ; branch

ATM_InjBank3:
           ldx  #InjectorPulsewidthBank3_HB    ; load index with value
           bra  LA9DF          ; branch

ATM_InjBank4:
           ldx  #InjectorPulsewidthBank4_HB    ; load index with value
   LA9DF:  ldaa Counter_MainLoop    ; load a with memory contents
           lsla                ; logical shift left a
           bne  LA9E9          ; branch if not equal (not zero)
           ldd  #0x00FA         ; load d (a&b) with value -00000000 11111010-
           std  0x00, X        ; store d into index plus offset
   LA9E9:  bclr *PIA1_Buffer, #pi1_ASD    ; clear bits
ATM_EGRSolenoid:
           rts                 ; return from subroutine

CaculateChecksum:
           ldx  #ENDIT1_PNPrefix    ; load index with value
           ldd  #L9200         ; load d (a&b) with value -10010010 00000000-
           stD *Temp0          ; store D to RAM
           clra                ; a = 0
   LA9F6:  ldab #0x08          ; load b with value -00001000-
           cpx  #LB600         ;  -10110110 00000000-
           bne  LAA06          ; branch if not equal (not zero)
           inc  Temp0      
           inc  Temp0      
           ldx  #0xB800    ; load index with value
   LAA06:  adda 0x00, X    
           adda 0x01, X    
           adda 0x02, X    
           adda 0x03, X    
           adda 0x04, X    
           adda 0x05, X    
           adda 0x06, X    
           adda 0x07, X    
           abx                 ; add b to index
           cpx  Temp0      
           bne  LAA06          ; branch if not equal (not zero)
           brclr *Temp0, #$%11111111, LAA2C    ; branch if bit(s) clear
           psha                ; push a onto stack
           jsr  OCToggleAndResetCopTimer    ; call subroutine
           ldaa #0x12          ; load a with value -00010010-
           adda Temp0      
           staa Temp0          ; store a into memory
           pula                ; pull a from stack
           bra  LA9F6          ; branch

   LAA2C:  cmpa ENDITM_ECUID+1    ; compare a with memory contents (data is 15)
           beq  LAA37          ; branch if equal (zero)
           ldd  #0x0201        ; load d (a&b) with value -00000010 00000001-
           jmp  ThrowNonCriticalError

   LAA37:  rts                 ; return from subroutine

FlashCodesOutOnCEL:
           ldaa Counter_MainLoop    ; load a with memory contents
           lsla                ; logical shift left a
           lsla                ; logical shift left a
           bne  LAA94          ; branch if not equal (not zero)
           ldaa LastDistributorFallingEdgeTime    ; load a with memory contents
           bita #0x70          ;  -01110000-
           beq  LAA4A          ; branch if equal (zero)
           suba #0x10          ;  -00010000-
           bita #0x70          ;  -01110000-
           bne  LAA92          ; branch if not equal (not zero)
   LAA4A:  ldab PIA1_Buffer    ; load b with memory contents
           eorb #pi1_CEL          ;  -10000000-
           stab PIA1_Buffer    ; store b into memory
           bita #0x0f          ;  -00001111-
           beq  LAA5D          ; branch if equal (zero)
           deca                ; decrement a
           bita #0x0f          ;  -00001111-
           beq  LAA5D          ; branch if equal (zero)
           oraa #0x10          ;  -00010000-
           bra  LAA92          ; branch

   LAA5D:  tsta                ; test a
           bmi  LAA95          ; branch if minus(hi bit 1)
           ldaa #0xaa          ; load a with value -10101010-
           ldab DRBPointer2    ; load b with memory contents
           cmpb #0xfe          ;  -11111110-
           beq  LAA86          ; branch if equal (zero)
           tstb            
           bmi  LAA92          ; branch if minus(hi bit 1)
           cmpb #0x08          ;  -00001000-
           bcs  LAA79          ; branch if lower
           ldx  #0xb618        ; load index with value
           abx                 ; add b to index
           brset  0, X, #$%11111111, LAADB    ; branch if bit(s) set
           bra  LAA80          ; branch

   LAA79:  negb            
           addb #0x07          ;  -00000111-
           ldx  #ErrorBitRegister0    ; load index with value
           abx                 ; add b to index
   LAA80:  ldab 0x00, X        ; load b with memory at index + value
           beq  LAA92          ; branch if equal (zero)
           bra  LAA87          ; branch

   LAA86:  clrb                ; b = 0
   LAA87:  ldx  #ErrorCodesToDash_Table    ; load index with value
           abx                 ; add b to index
           ldaa 0x00, X        ; load a with memory at index + value
           anda #0x0f          ; AND a with value -00001111-
           lsla                ; logical shift left a
           oraa #0xa0          ;  -10100000-
   LAA92:  staa LastDistributorFallingEdgeTime    ; store a into memory
   LAA94:  rts                 ; return from subroutine

   LAA95:  ldab DRBPointer2    ; load b with memory contents
           cmpb #0xff          ;  -11111111-
           bne  LAAA7          ; branch if not equal (not zero)
           ldaa ErrorCodeUpdateKeyOnCount    ; load a with memory contents
           cmpa #0x32          ; compare a with value -00110010-
           bhi  LAAA7          ; branch if higher
           decb            
           stab DRBPointer2    ; store b into memory
           clrb                ; b = 0
           bra  LAACC          ; branch

   LAAA7:  cmpb #0xfe          ;  -11111110-
           bne  LAAAC          ; branch if not equal (not zero)
           incb            
   LAAAC:  incb            
           stab DRBPointer2    ; store b into memory
           cmpb #0x08          ;  -00001000-
           bcs  LAAC1          ; branch if lower
           brset *DRBPointer2, #$%10000000, LAAE2    ; branch if bit(s) set
           ldx  #0xb618        ; load index with value
           abx                 ; add b to index
           brset  0, X, #$%11111111, LAADB    ; branch if bit(s) set
           bra  LAAC8          ; branch

   LAAC1:  negb            
           addb #0x07          ;  -00000111-
           ldx  #ErrorBitRegister0    ; load index with value
           abx                 ; add b to index
   LAAC8:  ldab 0x00, X        ; load b with memory at index + value
           beq  LAADB          ; branch if equal (zero)
   LAACC:  ldx  #ErrorCodesToDash_Table    ; load index with value
           abx                 ; add b to index
           ldaa 0x00, X        ; load a with memory at index + value
           lsra            
           lsra            
           lsra            
           lsra            
           lsla                ; logical shift left a
           oraa #0x40          ;  -01000000-
           bra  LAA92          ; branch

   LAADB:  bset *DRBPointer2, #$%10000000    ; set bits
           ldaa #0x4a          ; load a with value -01001010-
           bra  LAA92          ; branch

   LAAE2:  clra                ; a = 0
           staa DRBPointer1    ; store a into memory
           staa DRBPointer2    ; store a into memory
           rts                 ; return from subroutine


	;.org	0xaae8
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

	;.org	0xab2b
PIA1AManipulation_Table:
		.word	0x0102
		.word	0x0408
		.word	0x1020
		.word	0x4080
		.word	0xFFFF
		.word	0xFFFF
		.word	0x0A0E
		.word	0x12FF
		.word	0xFFFF
		.word	0x0C10
		.word	0x2F11
		.word	0xFF0D
		.word	0xFFFF
		.word	0x3710
		.byte   0x2f

ErrorBitManipulation_Table:
		.word	0x1138
		.word	0x0DFF
		.word	0x7F00
		.word	0x0120
		.word	0x00FF
		.word	0x7F00
		.word	0xFF7F
		.word	0x00FF
		.word	0x7F00
		.word	0xFF7F
		.word	0x00FF
		.word	0x7F00
		.word	0x268A
		.byte	0x80

        ;.org   0xab63
; DELAY_36USEC_ROUTINE:
;            nop		    ; no operation
; 	   nop		    ; no operation
; 	   nop		    ; no operation
; 	   nop		    ; no operation
; 
; 
;         ;.org   0xab67
; Delay32uSec:
;            ldy  #0x0007
;            dey
;            bne  Delay32uSec
;            rts

UpdatePIAAndCheckOuputs_MM:
           ldaa #0x50          ; load a with value -01010000-
           ldab PIA1_Buffer    ; load b with memory contents
           jsr  SetPIAOutputBits    ; call subroutine
           bset *BitFlags6e, #b6e_PIAKeepIntEnabled    ; set bits
           ldaa #0x70          ; load a with value -01110000-
           ldab #0xff          ; load b with value -11111111-
           jsr  SetPIAOutputBits    ; call subroutine
           bclr *BitFlags6e, #b6e_PIAKeepIntEnabled    ; clear bits
           ldaa #0x70          ; load a with value -01110000-
           ldab #0x02          ; load b with value -00000010-
           jsr  SetPIAOutputBits    ; call subroutine
           idiv            
           idiv            
           ldaa #0x40          ; load a with value -01000000-
           ldab #0xff          ; load b with value -11111111-
           jsr  SetPIAOutputBits    ; call subroutine
           eora PIA1_Buffer
           ldab #0xa5          ; load b with value -10100101-
           bsr  PIA_CheckErrors          ; call subroutine
           clrb                ; b = 0
           ldx  #CONFIG_ConfigurationFlags    ; load index with value
           brclr *PIA2_Buffer, #pi2_ACRelay, LABB2    ; branch if bit(s) clear
           ldaa StartupSwitchMirror1    ; load a with memory contents
           bita #sw1_ACclutch          ;  -01000000-
           brclr  0, X, #cfg_AC, LABAE    ; branch if bit(s) clear
           ldaa PIA1_Buffer    ; load a with memory contents
           bita #pi1_Fan          ;  -00100000-
   LABAE:  beq  LABB2          ; branch if equal (zero)
           ldab #0x08          ; load b with value -00001000-
   LABB2:  stab Temp0          ; store b into memory
           ldaa #0xdc          ; load a with value -11011100-
           ldab PIA2_Buffer    ; load b with memory contents
           andb #~(pi2_VNTSol | pi2_WGSol)          ;  -00111111-
           jsr  SetPIAOutputBits    ; call subroutine
           ldaa #0xd8          ; load a with value -11011000-
           ldab PIA2_Buffer    ; load b with memory contents
           comb            
           andb #~(pi2_VNTSol | pi2_WGSol)          ;  -00111111-
           jsr  SetPIAOutputBits    ; call subroutine
           bset *BitFlags6e, #b6e_PIAKeepIntEnabled    ; set bits
           ldaa #0xfc          ; load a with value -11111100-
           ldab #0x3f          ; load b with value -00111111-
           jsr  SetPIAOutputBits    ; call subroutine
           bclr *BitFlags6e, #b6e_PIAKeepIntEnabled    ; clear bits
           ldaa #0xf0          ; load a with value -11110000-
           ldab Temp0          ; load b with memory contents
           jsr  SetPIAOutputBits    ; call subroutine
           idiv            
           idiv            
           ldd  #0xc0ff        ; load d (a&b) with value -11000000 11111111-
           bset *BitFlags6e, #b6e_PIAKeepIntEnabled    ; set bits
           jsr  SetPIAOutputBits    ; call subroutine
           bclr *BitFlags6e, #b6e_PIAKeepIntEnabled    ; clear bits
           staa Temp0          ; store a into memory
           ldaa #b6e_BoostOver5psi | b6e_WastegateDC          ; load a with value -11000000-
           anda BitFlags6e     ; logical and a with memory contents
           cli                 ; enable interrupts
           ldab PIA2_Buffer    ; load b with memory contents
           andb #~(pi2_VNTSol | pi2_WGSol)          ;  -00111111-
           aba                 ; a=a+b
           eora Temp0      
           clrb                ; b = 0

PIA_CheckErrors:
           stab Temp0          ; store b into memory
           ldx  #PIA1AManipulation_Table    ; load index with value
           ldab BatteryVolts    ; load b with memory contents
           cmpb #0xa2          ;  -10100010-
           bcs  PIA_CheckErrors_Return          ; branch if lower
           ldab CountdownTimerFromKeyOn    ; load b with memory contents
           bne  PIA_CheckErrors_Return          ; branch if not equal (not zero)
           ldab Counter_MainLoop    ; load b with memory contents
           andb #0x07          ;  -00000111-
           abx                 ; add b to index
           anda 0x00, X    
           brclr *Temp0, #$%11111111, LAC1B    ; branch if bit(s) clear
           bita PIAMSK_PIA1ADDRMask    ;  (data is 70)
           beq  PIA_CheckErrors_Return          ; branch if equal (zero)
           ldaa 0x08, X        ; load a with memory at index + value
           bra  LAC2B          ; branch

   LAC1B:  bita PIBMSK_PIA1BDDRMask    ;  (data is dc)
           beq  PIA_CheckErrors_Return          ; branch if equal (zero)
           ldaa 0x10, X        ; load a with memory at index + value
           ldab CONFIG_ConfigurationFlags    ; load b with memory contents (data is 9f)
           bitb #cfg_VNT          ;  -00000001-
           beq  LAC2B          ; branch if equal (zero)
           ldaa 0x18, X        ; load a with memory at index + value
   LAC2B:  ldab #0x20          ; load b with value -00100000-
           cmpa #0x11          ; compare a with value -00010001-
           beq  LAC65          ; branch if equal (zero)
           cmpa #0x2f          ; compare a with value -00101111-
           beq  LAC65          ; branch if equal (zero)
           cmpa #0x12          ; compare a with value -00010010-
           beq  LAC65          ; branch if equal (zero)
           cmpa #0x0d          ; compare a with value -00001101-
           beq  LAC6D          ; branch if equal (zero)
           cmpa #0x37          ; compare a with value -00110111-
           beq  LAC6D          ; branch if equal (zero)
           cmpa #0x38          ; compare a with value -00111000-
           beq  LAC6D          ; branch if equal (zero)
           cmpa #0x10          ; compare a with value -00010000-
           bne  LAC63          ; branch if not equal (not zero)
           tst  CONFIG_ConfigurationFlags    ;  (data is 9f)
           bpl  LAC54          ; branch if plus (hi bit 0) - VNT is NOT set
           brclr *PIA1_Buffer, #pi1_Fan, LAC63    ; branch if bit(s) clear
           bra  PIA_CheckErrors_Return          ; branch

   LAC54:  brset *BitFlags6d, #b6d_DisableNormalDwell, PIA_CheckErrors_Return    ; branch if bit(s) set
           ldx  KeyOnOrEngineRunningTime
           cpx  #0x0b00        ;  -00001011 00000000-
           bcs  PIA_CheckErrors_Return          ; branch if lower
           brset *StartupSwitchMirror1, #sw1_ACclutch, PIA_CheckErrors_Return    ; branch if bit(s) set
   LAC63:  bra  ThrowNonCriticalError    ; branch

   LAC65:  bsr  ThrowCriticalError    ; call subroutine
           bcc  PIA_CheckErrors_Return          ; branch if greater or equal
           bset *b5d_IPL2, #b5d_MajorFault    ; set bits
PIA_CheckErrors_Return:
           rts                 ; return from subroutine

   LAC6D:  brset *b5d_IPL2, #b5d_WGSolFault, PIA_CheckErrors_Return    ; branch if bit(s) set
           ldab #0xa0          ; load b with value -10100000-
           bsr  ThrowNonCriticalError    ; call subroutine
           bcc  PIA_CheckErrors_Return          ; branch if greater or equal
           bset *b5d_IPL2, #b5d_WGSolFault    ; set bits
           rts                 ; return from subroutine

ThrowCriticalError:
           ldx  #CONFIG_ConfigurationFlags    ; load index with value
           brclr  0, X, #cfg_EGR, ThrowNonCriticalError    ; branch if bit(s) clear
           brset *b5d_IPL2, #b5d_MajorFault, ThrowNonCriticalError    ; branch if bit(s) set
           orab #0x80          ;  -10000000-
ThrowNonCriticalError:
           ldx  #FLTMSK_ErrorBitsMask1        ; load index with value
   LAC8B:  brclr  0, X, #$%11111111, LAC96    ; branch if bit(s) clear
           cmpa 0x00, X        ; compare a with memory at index + value
           beq  LACD9          ; branch if equal (zero)
           inx                 ; increment index (x=x+1)
           bra  LAC8B          ; branch

   LAC96:  tstb            
           bmi  LACA1          ; branch if minus(hi bit 1)
           cmpa ErrorBitRegisterStored3    ; compare a with memory contents
           beq  LACD6          ; branch if equal (zero)
           cmpa ErrorBitRegisterStored2    ; compare a with memory contents
           beq  LACCC          ; branch if equal (zero)
   LACA1:  andb #0x7f          ;  -01111111-
           cmpb #0x01          ;  -00000001-
           beq  LACE0          ; branch if equal (zero)
           stab Temp0          ; store b into memory
           ldx  #ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB    ; load index with value
           cmpa 0x00, X        ; compare a with memory at index + value
           beq  LACBE          ; branch if equal (zero)
           inx                 ; increment index (x=x+1)
           cmpa 0x00, X        ; compare a with memory at index + value
           beq  LACBE          ; branch if equal (zero)
           tst  0x00, X    
           beq  LACBE          ; branch if equal (zero)
           dex                 ; decrement index (x=x-1)
           tst  0x00, X    
           bne  LACD9          ; branch if not equal (not zero)
   LACBE:  staa 0x00, X    
           inc  0x02, X    
           beq  LACDC          ; branch if equal (zero)
           cmpb 0x02, X    
           bcs  LACDC          ; branch if lower
           ldab 0x02, X        ; load b with memory at index + value
           clc                 ; clear carry
           rts                 ; return from subroutine

   LACCC:  ldd  ErrorBitRegisterStored2    ; load d (a&b) with memory contents
           staa ErrorBitRegisterStored3    ; store a into memory
           stab ErrorBitRegisterStored2    ; store b into memory
           ldaa ErrorCodeUpdateKeyOnCount    ; load a with memory contents
           staa ErrorCodeUpdateKeyOnCount2    ; store a into memory
   LACD6:  clra                ; a = 0
           staa ErrorCodeUpdateKeyOnCount    ; store a into memory
   LACD9:  clra                ; a = 0
           clc                 ; clear carry
           rts                 ; return from subroutine

   LACDC:  clr  0x00, X    
           clr  0x02, X    
   LACE0:  ldx  #ErrorBitRegister0    ; load index with value
   LACE3:  cmpa 0x00, X        ; compare a with memory at index + value
           bne  LACEC          ; branch if not equal (not zero)
           clrb                ; b = 0
           stab 0x00, X    
           bra  LACF4          ; branch

   LACEC:  inx                 ; increment index (x=x+1)
           cpx  #ErrorBitRegisterStored3    ;  -00000000 00100110-
           bls  LACE3          ; branch if lower or same
           ldab #0xff          ; load b with value -11111111-
   LACF4:  stab Temp0          ; store b into memory
           ldx  #ErrorBitRegisterStored3    ; load index with value
           ldY #ErrorCodeUpdateKeyOnCount    ; load Y index -00000000 00100111-
   LACFD:  cpx  #ErrorBitRegisterStored1    ;  -00000000 00100100-
           bcs  LAD10          ; branch if lower
           psha                ; push a onto stack
           ldaB 0x00, Y       ; load B with value indexed to Y -00000000-
           ldaa Temp0          ; load a with memory contents
           staA 0x00, Y       ; store A with value indexed to Y -00000000-
           inY                 ; increment Y
           stab Temp0          ; store b into memory
           pula                ; pull a from stack
   LAD10:  ldab 0x00, X        ; load b with memory at index + value
           staa 0x00, X    
           tba                 ; a = b
           beq  LAD4C          ; branch if equal (zero)
           dex                 ; decrement index (x=x-1)
           cpx  #ErrorBitRegister0    ;  -00000000 00011111-
           bcc  LACFD          ; branch if greater or equal
           clrb                ; b = 0
           stab ErrorCodeUpdateKeyOnCount    ; store b into memory
           sei                 ; disable interrupts
           ldab BitFlags6a     ; load b with memory contents
           bitb #b6a_DRBToggle2 | b6a_DRBToggle1          ;  -00000011-
           bne  LAD49          ; branch if not equal (not zero)
           bset *BitFlags6a, #b6a_DRBToggle1    ; set bits
           cli                 ; enable interrupts
           staa DRBOffsetStored_LB    ; store a into memory
           ldx  #0xb61f        ; load index with value
   LAD30:  inx                 ; increment index (x=x+1)
           cpx  #0xb660        ;  -10110110 01100000-
           beq  LAD46          ; branch if equal (zero)
           ldab 0x00, X        ; load b with memory at index + value
           cba             
           beq  LAD46          ; branch if equal (zero)
           incb            
           bne  LAD30          ; branch if not equal (not zero)
           xgDX                ; exchange D and X
           subd #LB600         ;  -10110110 00000000-
           stab DRBOffsetStored_HB    ; store b into memory
           bra  LAD49          ; branch

   LAD46:  bclr *BitFlags6a, #b6a_DRBToggle1    ; clear bits
   LAD49:  cli                 ; enable interrupts
           bra  LAD5E          ; branch

   LAD4C:  cpY  #ErrorCodeUpdateKeyOnCount3    ; compare Y to memory 16-bit
           bhi  LAD5B          ; branch if higher
           ldab ErrorCodeUpdateKeyOnCount    ; load b with memory contents
           beq  LAD5E          ; branch if equal (zero)
           ldab Temp0          ; load b with memory contents
           staB 0x00, Y       ; store B to location indexed to Y -00000000-
   LAD5B:  clrb                ; b = 0
           stab ErrorCodeUpdateKeyOnCount    ; store b into memory
   LAD5E:  sec                 ; set carry
   LAD5F:  rts                 ; return from subroutine

ProcessErrorBits_WorkWithData_MM:
           brclr *BitFlags5E, #$%11111111, LAD5F    ; branch if bit(s) clear
           ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           bne  LAD5F          ; branch if not equal (not zero)
           clra                ; a = 0
           clrb                ; b = 0
           sec                 ; set carry
   LAD6B:  rola            
           bcs  LAD5F          ; branch if lower
           addb #0x03          ;  -00000011-
           bita BitFlags5E 
           beq  LAD6B          ; branch if equal (zero)
           ldx  #ErrorBitManipulation_Table    ; load index with value
           abx                 ; add b to index
           stD *Temp3          ; store D to RAM
           coma            
           sei                 ; disable interrupts
           anda BitFlags5E     ; logical and a with memory contents
           staa BitFlags5E     ; store a into memory
           cli                 ; enable interrupts
           ldd  0x00, X    
           tstb            
           bpl  LAD89          ; branch if plus (hi bit 0)
           bset *Temp4, #$%10000000    ; set bits
   LAD89:  jsr  ThrowNonCriticalError    ; call subroutine
           brclr *Temp4, #$%10000000, LADA2    ; branch if bit(s) clear
           bcc  LADA2          ; branch if greater or equal
           ldx  #ErrorBitManipulation_Table    ; load index with value
           ldab Temp4          ; load b with memory contents
           andb #0x7f          ;  -01111111-
           abx                 ; add b to index
           ldaa 0x02, X        ; load a with memory at index + value
           sei                 ; disable interrupts
           oraa b5c_IPL1       ; OR a with memory contents
           staa b5c_IPL1       ; store a into memory
           cli                 ; enable interrupts
   LADA2:  ldd  Temp3          ; load d (a&b) with memory contents
           andb #0x7f          ;  -01111111-
           clc                 ; clear carry
           bra  LAD6B          ; branch

SimulateMapReadingFromTps:
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb #0x7e          ;  -01111110-
           ldaa #0x00          ; load a with value -00000000-
           bcc  LADC5          ; branch if greater or equal
           subb #0x10          ;  -00010000-
           bcc  LADB6          ; branch if greater or equal
           clrb                ; b = 0
   LADB6:  ldaa #0x52          ; load a with value -01010010-
           mul                 ; multiply (d=a*b)
           adca MINTHR_LowestSessionTPS
           tab                 ; b = a
           ldaa TpsVolts       ; load a with memory contents
           adda THROFF_OffsetAddedToCalcThrottle    ;  (data is 0b)
           sba                 ; subtract (a=a-b)
           bcc  LADC5          ; branch if greater or equal
           clra                ; a = 0
   LADC5:  ldx  #LMPINN_LimpinTableForMapFromThrottle    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           adda MPLMOF_OffsetForCalcMapInMapLimpin    ;  (data is 20)
           rts                 ; return from subroutine

   LADCF:  ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x1f          ;  -00011111-
           bne  LADF6          ; branch if not equal (not zero)
           brset *BitFlags6d, #b6d_FuelEngineNotRunning, LADF6    ; branch if bit(s) set
           ldaa BatteryVolts    ; load a with memory contents
           suba TargetBatteryVolts
           bcs  LADF3          ; branch if lower
           cmpa #0x10          ; compare a with value -00010000-
           bcs  LADF3          ; branch if lower
           brset *b5c_IPL1, #b5c_BattNotCharging, LADF6    ; branch if bit(s) set
           ldd  #0x06a0        ; load d (a&b) with value -00000110 10100000-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LADF6          ; branch if greater or equal
           bset *b5c_IPL1, #b5c_BattNotCharging    ; set bits
           rts                 ; return from subroutine

   LADF3:  bclr *b5c_IPL1, #b5c_BattNotCharging    ; clear bits
   LADF6:  rts                 ; return from subroutine

CheckIfCheckEngineLightShouldBeOn_MM:
           ldab #0x80          ; load b with value -10000000-
           brclr *BitFlags6d, #b6d_FuelEngineNotRunning, DetermineEngineRunningCELStatus    ; branch if bit(s) clear
           ldaa DRBPointer1    ; load a with memory contents
           cmpa #0x0a          ; compare a with value -00001010-
           bne  LAE06          ; branch if not equal (not zero)
           jmp  FlashCodesOutOnCEL

   LAE06:  cmpa #0x18          ; compare a with value -00011000-
           bne  LAE11          ; branch if not equal (not zero)
           ldaa Counter_MainLoop    ; load a with memory contents
           lsla                ; logical shift left a
           bmi  TurnCheckEngineLightOn    ; branch if minus(hi bit 1)
           bra  TurnCheckEngineLightOff    ; branch

   LAE11:  ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           bne  TurnCheckEngineLightOn    ; branch if not equal (not zero)
           bra  TurnCheckEngineLightOff    ; branch

DetermineEngineRunningCELStatus:
           ldd  KeyOnOrEngineRunningTime    ; load d (a&b) with memory contents
           cmpD #0x0003         ; compare D -00000000 00000011-
           bls  TurnCheckEngineLightOn    ; branch if lower or same
           brclr *PIA1_Buffer, #pi1_CEL, LAE41    ; branch if bit(s) clear
           ldaa b5c_IPL1       ; load a with memory contents
           bita IPLMSK_PowerLossLightMask    ;  (data is ff)
           bne  TurnCheckEngineLightOff    ; branch if not equal (not zero)
           ldx  #CONFIG_ConfigurationFlags    ; load index with value
           ldaa b5d_IPL2       ; load a with memory contents
           brset  0, X, #cfg_EGR, LAE35    ; branch if bit(s) set
           anda #0x3f          ; AND a with value -00111111-
   LAE35:  bita IPLMSK2_PowerLossLightMask2    ;  (data is f8)
           beq  TurnCheckEngineLightOn    ; branch if equal (zero)
TurnCheckEngineLightOff:
           bclr *PIA1_Buffer, #pi1_CEL    ; clear bits
           rts                 ; return from subroutine

TurnCheckEngineLightOn:
           bset *PIA1_Buffer, #pi1_CEL    ; set bits
   LAE41:  rts                 ; return from subroutine

UpdateErrorTimersAndPossiblyClearErrors_MM:
           ldaa Counter_MainLoop    ; load a with memory contents
           bne  LAE6B          ; branch if not equal (not zero)
           ldd  ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB    ; load d (a&b) with memory contents
           tsta                ; test a
           beq  LAE53          ; branch if equal (zero)
           dec  ClearTheErrorTimer_0    ; decrement memory contents
           bne  LAE53          ; branch if not equal (not zero)
           clr  ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB    ; zero byte at memory location
   LAE53:  tstb            
           beq  LAE5E          ; branch if equal (zero)
           dec  ClearTheErrorTimer_1    ; decrement memory contents
           bne  LAE5E          ; branch if not equal (not zero)
           clr  ErrorBitsAssociatedWithPIA1AndReg1eTo25_LB    ; zero byte at memory location
   LAE5E:  ldaa ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; load a with memory contents
           beq  LAE6B          ; branch if equal (zero)
           suba #0x10          ;  -00010000-
           bita #0xf0          ;  -11110000-
           bne  LAE69          ; branch if not equal (not zero)
           clra                ; a = 0
   LAE69:  staa ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; store a into memory
   LAE6B:  ldaa BitFlags6d     ; load a with memory contents
           bita #b6d_FuelEngineNotRunning | b6d_NeedSetup          ;  -10000001-
           bne  LAEA5          ; branch if not equal (not zero)
           bset *BitFlags6d, #b6d_NeedSetup    ; set bits
           brclr *ErrorBitRegisterStored3, #$%11111111, LAE9E    ; branch if bit(s) clear
           ldaa ErrorCodeUpdateKeyOnCount    ; load a with memory contents
           cmpa #0x32          ; compare a with value -00110010-
           bcs  LAE88          ; branch if lower
           ldaa CPU_EEPROMControlReg    ; load a with memory contents
           bita #0x01          ;  -00000001-
           bne  LAEA5          ; branch if not equal (not zero)
           jmp  DRB_ClearErrorCodes

   LAE88:  ldaa ErrorBitRegisterStored1    ; load a with memory contents
           beq  LAE93          ; branch if equal (zero)
           ldaa ErrorCodeUpdateKeyOnCount3    ; load a with memory contents
           inca                ; increment a
           beq  LAE93          ; branch if equal (zero)
           staa ErrorCodeUpdateKeyOnCount3    ; store a into memory
   LAE93:  ldaa ErrorBitRegisterStored2    ; load a with memory contents
           beq  LAE9E          ; branch if equal (zero)
           ldaa ErrorCodeUpdateKeyOnCount2    ; load a with memory contents
           inca                ; increment a
           beq  LAE9E          ; branch if equal (zero)
           staa ErrorCodeUpdateKeyOnCount2    ; store a into memory
   LAE9E:  ldaa ErrorCodeUpdateKeyOnCount    ; load a with memory contents
           inca                ; increment a
           beq  LAEA5          ; branch if equal (zero)
           staa ErrorCodeUpdateKeyOnCount    ; store a into memory
   LAEA5:  rts                 ; return from subroutine

CheckForErrorsAndSetCodes_MM:
           ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x1f          ;  -00011111-
           bne  LAEE2          ; branch if not equal (not zero)
           brset *BitFlags6d, #b6d_FuelEngineNotRunning, LAEE2    ; branch if bit(s) set
           ldaa BatteryVolts    ; load a with memory contents
           suba TargetBatteryVolts
           bcc  LAECB          ; branch if greater or equal
           bclr *b5c_IPL1, #b5c_BattNotCharging    ; clear bits
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb BTLRPM_LowBatteryVoltageAtThisRpm1500    ; compare b with memory contents (data is 2e)
           bcs  LAEE2          ; branch if lower
           nega                ; negate a (set high bit)
           cmpa #0x10          ; compare a with value -00010000-
           bcs  LAEE2          ; branch if lower
           ldd  #0x0555        ; load d (a&b) with value -00000101 01010101-
           jmp  ThrowNonCriticalError

   LAECB:  cmpa #0x10          ; compare a with value -00010000-
           bcs  LAEDF          ; branch if lower
           brset *b5c_IPL1, #b5c_BattNotCharging, LAEE2    ; branch if bit(s) set
           ldd  #0x06a0        ; load d (a&b) with value -00000110 10100000-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LAEE2          ; branch if greater or equal
           bset *b5c_IPL1, #b5c_BattNotCharging    ; set bits
           rts                 ; return from subroutine

   LAEDF:  bclr *b5c_IPL1, #b5c_BattNotCharging    ; clear bits
   LAEE2:  rts                 ; return from subroutine

DetectAlternatorFault_MM:
           brset *BitFlags6d, #b6d_FuelEngineNotRunning, LAF34    ; branch if bit(s) set
           ldaa CoolantTemp    ; load a with memory contents
           cmpa ERRTMP_CoolantTempLimitforErrorCodeSetting    ; compare a with memory contents (data is a0)
           bcs  LAF34          ; branch if lower
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_ATX          ;  -00100000-
           beq  LAEF9          ; branch if equal (zero)
           brclr *BitFlags_AIS, #b10_ATXInGear, LAF34    ; branch if bit(s) clear
   LAEF9:  ldd  KeyOnOrEngineRunningTime    ; load d (a&b) with memory contents
           cmpa #0x0b          ; compare a with value -00001011-
           bcs  LAF34          ; branch if lower
           bitb #0x1f          ;  -00011111-
           bne  LAF34          ; branch if not equal (not zero)
           brset *StartupSwitchMirror1, #sw1_Brake, LAF34    ; branch if bit(s) set
           brclr *BitFlags66, #b66_OffIdle, LAF34    ; branch if bit(s) clear
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa ERRRPM_RPMLimitforErrorCodeSetting    ; compare a with memory contents (data is 38)
           bcs  LAF34          ; branch if lower
           ldaa BaroPressure    ; load a with memory contents
           suba MapValue   
           bcc  LAF19          ; branch if greater or equal
           clra                ; a = 0
   LAF19:  cmpa ERRMAP_MAPLimitforErrorCodeSetting    ; compare a with memory contents (data is 2b)
           bcc  LAF34          ; branch if greater or equal
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           cmpD #0x002a    ; compare D -00000000 00101010-
           bcc  LAF34          ; branch if greater or equal
           ldd  #0x2320        ; load d (a&b) with value -00100011 00100000-
           jsr  ThrowCriticalError    ; call subroutine
           bcc  LAF34          ; branch if greater or equal
           bset *b5d_IPL2, #b5d_MajorFault    ; set bits
           bset *BitFlags6b, #$%00100000    ; set bits
   LAF34:  rts                 ; return from subroutine

ThrowMajorErrorIfRequired_MM:
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_EGR          ;  -01000000-
           beq  LAF44          ; branch if equal (zero)
           brclr *BitFlags67, #b67_BadO2, LAF47    ; branch if bit(s) clear
           bset *b5d_IPL2, #b5d_MajorFault    ; set bits
           rts                 ; return from subroutine

   LAF44:  bclr *b5d_IPL2, #b5d_EGRSolFault | b5d_MajorFault    ; clear bits
   LAF47:  rts                 ; return from subroutine


	;.org	0xaf48
   LAF48:
	.word 0x1513
	.word 0x3D14

VerifyOperationOfFuelInjectorDrivers_MM:
           ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           beq  LAF53          ; branch if equal (zero)
           jmp  LAFEC      

   LAF53:  ldaa SwitchPortAccessReg1    ; load a with memory contents
           bita #sp1_B1Volt          ;  -00100000-
           beq  LAFA6          ; branch if equal (zero)
           sei                 ; disable interrupts
           ldaa SwitchPortAccessReg2    ; load a with memory contents
           anda #0xf0          ; AND a with value -11110000-
           bne  LAFA6          ; branch if not equal (not zero)
           brclr *BitFlags6e, #b6e_DistSync, LAFA6    ; branch if bit(s) clear
           brset *b5d_IPL2, #b5d_InjectorFault, LAF9D    ; branch if bit(s) set
           ldab #0x04          ; load b with value -00000100-
   LAF6C:  decb            
           bne  LAF6C          ; branch if not equal (not zero)
           ldab #0x04          ; load b with value -00000100-
           bitb PIA_Ctrl_4 
           bne  LAF9F          ; branch if not equal (not zero)
           ldab BitFlags6e     ; load b with memory contents
           brclr *BitFlags70, #b70_bit7, LAF84    ; branch if bit(s) clear
           ldaa CPU_TimerControlReg2    ; load a with memory contents
           bita #0x10          ;  -00010000-
           bne  LAF84          ; branch if not equal (not zero)
           decb            
   LAF84:  cli                 ; enable interrupts
           ldx  #LAF48         ; load index with value
           andb #0x03          ;  -00000011-
           abx                 ; add b to index
           ldaa 0x00, X        ; load a with memory at index + value
           ldab #0x89          ; load b with value -10001001-
           brset *BitFlags6d, #b6d_FuelEngineNotRunning, LAF95    ; branch if bit(s) set
           ldab #0xa0          ; load b with value -10100000-
   LAF95:  jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LAF9D          ; branch if greater or equal
           bset *b5d_IPL2, #b5d_InjectorFault    ; set bits
   LAF9D:  ldab #0x04          ; load b with value -00000100-
   LAF9F:  cli                 ; enable interrupts
           stab PIA_Ctrl_4     ; store b into memory
           bclr *BitFlags6e, #b6e_DistSync    ; clear bits
   LAFA6:  sei                 ; disable interrupts
           ldaa SwitchPortAccessReg1    ; load a with memory contents
           eora BitFlags6f 
           cli                 ; enable interrupts
           bita #0x04          ;  -00000100-
           beq  LAFC0          ; branch if equal (zero)
           brset *b5c_IPL1, #b5c_Bad_BatVolts, LAFC0    ; branch if bit(s) set
           ldd  #0x0ba0        ; load d (a&b) with value -00001011 10100000-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LAFC0          ; branch if greater or equal
           bset *b5c_IPL1, #b5c_Bad_BatVolts    ; set bits
   LAFC0:  bset *BitFlags6e, #b6e_PIAKeepIntEnabled    ; set bits
           ldd  #0x80ff    ; load d (a&b) with value -10000000 11111111-
           jsr  SetPIAOutputBits    ; call subroutine
           bclr *BitFlags6e, #b6e_PIAKeepIntEnabled    ; clear bits
           ldx  #AISTEP_BitPatternForAisControl    ; load index with value
           tba                 ; a = b
           ldab BitFlags_36    ; load b with memory contents
           abx                 ; add b to index
           eora 0x00, X    
           cli                 ; enable interrupts
           bita #0x0f          ;  -00001111-
           beq  LAFEC          ; branch if equal (zero)
           brset *BitFlags6c, #b6c_bit6, LAFEC    ; branch if bit(s) set
           ldd  #0x19a0        ; load d (a&b) with value -00011001 10100000-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LAFEC          ; branch if greater or equal
           bset *BitFlags6c, #b6c_bit6    ; set bits
           bset *b5d_IPL2, #b5d_MajorFault    ; set bits
   LAFEC:  rts                 ; return from subroutine

   LAFED:  ldaa TimerOverflowsBetweenDistPulses    ; load a with memory contents
           cmpa #0x50          ; compare a with value -01010000-
           bcs  LB00A          ; branch if lower
           ldaa CPU_A2DResults1    ; load a with memory contents
           brclr *Counter_MainLoop, #$%01111111, LB006    ; branch if bit(s) clear
           cmpa MapVolts       ; compare a with memory contents
           bcs  LB008          ; branch if lower
           cmpa MapValue       ; compare a with memory contents
           bls  LB00A          ; branch if lower or same
           staa MapValue       ; store a into memory
           bra  LB00A          ; branch

   LB006:  staa MapValue       ; store a into memory
   LB008:  staa MapVolts       ; store a into memory
   LB00A:  ldaa MapVolts       ; load a with memory contents
           suba CPU_A2DResults1
           bcc  LB012          ; branch if greater or equal
           nega                ; negate a (set high bit)
   LB012:  ldab MPDELT_DeltaMapThatChecksGood    ; load b with memory contents (data is 01)
           brclr *b5c_IPL1, #b5c_MapStuck, LB01C    ; branch if bit(s) clear
           addb MPDELA_MatureMapLimpinWhenDeltaAbove_MPDELT_plus_MPDELA    ;  (data is 01)
   LB01C:  cba             
           bcs  LB04B          ; branch if lower
           bset *BitFlags6d, #b6d_BigMapChange    ; set bits
           brclr *b5c_IPL1, #b5c_MapStuck, LB04B    ; branch if bit(s) clear
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x1f          ;  -00011111-
           bne  LB04B          ; branch if not equal (not zero)
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           cmpD #0x0040    ; compare D -00000000 01000000-
           bcc  LB046          ; branch if greater or equal
           brset *BitFlags66, #b66_OffIdle, LB046    ; branch if bit(s) set
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  LB040          ; branch if greater or equal
           coma            
           comb            
   LB040:  cmpD MPRMPD_CheckMapAtZeroSpeedAndThisDeltaRpm    ; compare D (data is 02)
           bcs  LB04B          ; branch if lower
   LB046:  ldaa #0x08          ; load a with value -00001000-
           jmp  ResetErrorCodeIfTimerExpired

   LB04B:  rts                 ; return from subroutine

VerifyOperationOfMapSensor_MM:
           ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x07          ;  -00000111-
           bne  LB04B          ; branch if not equal (not zero)
           brset *b5c_IPL1, #b5c_MapStuck, LB093    ; branch if bit(s) set
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           cmpD #0x0040    ; compare D -00000000 01000000-
           bcc  LB093          ; branch if greater or equal
           brset *BitFlags66, #b66_OffIdle, LB093    ; branch if bit(s) set
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  LB06A          ; branch if greater or equal
           coma            
           comb            
   LB06A:  cmpD MPRMPD_CheckMapAtZeroSpeedAndThisDeltaRpm    ; compare D (data is 02)
           bcc  LB093          ; branch if greater or equal
           brset *BitFlags6d, #b6d_FuelEngineNotRunning, LB093    ; branch if bit(s) set
           ldaa BaroPressure    ; load a with memory contents
           tab                 ; b = a
           suba MapValue   
           bcs  LB088          ; branch if lower
           ldx  #MPVACD_AllowMapToTestGoodThisNearBaro    ; load index with value
           cmpb BAROSW_CheckMapAtZeroSpeedAndThisBaroSwitch    ; compare b with memory contents (data is 62)
           bcc  LB084          ; branch if greater or equal
           inx                 ; increment index (x=x+1)
   LB084:  cmpa 0x00, X        ; compare a with memory at index + value
           bcc  LB093          ; branch if greater or equal
   LB088:  ldd  #0x2794        ; load d (a&b) with value -00100111 10010100-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LB093          ; branch if greater or equal
           bset *b5c_IPL1, #b5c_MapStuck    ; set bits
   LB093:  ldx  EngineRpm_HB
           cpx  #0x2ee0        ;  -00101110 11100000-
           bcc  LB04B          ; branch if greater or equal
           ldab TpsVolts       ; load b with memory contents
           subb MINTHR_LowestSessionTPS    ; b = b-memory contents
           bcs  LB0A5          ; branch if lower
           cmpb MPLTHR_ThrottleLevelAbove_MINTHR_ToMatureMapLimpin    ; compare b with memory contents (data is 42)
           bcc  LB04B          ; branch if greater or equal
   LB0A5:  ldaa CPU_A2DResults1    ; load a with memory contents
           cmpa MAPHIG_MapSensorUpperLimit    ; compare a with memory contents (data is ee)
           bcc  LB0B7          ; branch if greater or equal
           cmpa MAPLOW_MapSensorLowerLimit    ; compare a with memory contents (data is 01)
           bcc  LB0C7          ; branch if greater or equal
           ldd  #0x2494        ; load d (a&b) with value -00100100 10010100-
           bra  LB0BA          ; branch

   LB0B7:  ldd  #0x2594        ; load d (a&b) with value -00100101 10010100-
   LB0BA:  brset *b5c_IPL1, #b5c_MapBadSignal, LB0C6    ; branch if bit(s) set
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LB0C6          ; branch if greater or equal
           bset *b5c_IPL1, #b5c_MapBadSignal    ; set bits
   LB0C6:  rts                 ; return from subroutine

   LB0C7:  brclr *b5c_IPL1, #b5c_MapBadSignal, LB0C6    ; branch if bit(s) clear
           ldaa #0x06          ; load a with value -00000110-
ResetErrorCodeIfTimerExpired:
           anda #0x0f          ; AND a with value -00001111-
           ldab ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; load b with memory contents
           beq  LB0DA          ; branch if equal (zero)
           andb #0x0f          ;  -00001111-
           cba             
           bne  LB0E0          ; branch if not equal (not zero)
           ldaa ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; load a with memory contents
   LB0DA:  adda #0x10          ;  -00010000-
           bcs  SELECT_ERROR_BIT_POSITION_ROUT    ; branch if lower
           staa ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; store a into memory
   LB0E0:  rts                 ; return from subroutine

SELECT_ERROR_BIT_POSITION_ROUT:
           ldab #0x01          ; load b with value -00000001-
   LB0E3:  deca                ; decrement a
           beq  LB0E9          ; branch if equal (zero)
           lslb            
           bra  LB0E3          ; branch

   LB0E9:  clr  ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; zero byte at memory location
           tba                 ; a = b
           comb            
           sei                 ; disable interrupts
           andb b5c_IPL1   
           stab b5c_IPL1       ; store b into memory
           cmpa #0x80          ; compare a with value -10000000-
           beq  LB0F8          ; branch if equal (zero)
           cli                 ; enable interrupts
   LB0F8:  rts                 ; return from subroutine

CountRamValuesFrom05to38:
           clra                ; a = 0
           clrb                ; b = 0
           ldx  #MINTHR_LowestSessionTPS    ; load index with value
   LB0FE:  addb 0x00, X        ; add memory at index + value to b
           bcc  LB103          ; branch if greater or equal
           inca                ; increment a
   LB103:  inx                 ; increment index (x=x+1)
           cpx  #Timer_BoostTimer    ;  -00000000 00111000-
           bcs  LB0FE          ; branch if lower
           rts                 ; return from subroutine

VerifyOperationOfThermostat_MM:
           brset *BitFlags6d, #b6d_FuelEngineNotRunning, LB13D    ; branch if bit(s) set
           brset *b5c_IPL1, #b5c_BadCoolantTemp, LB13D    ; branch if bit(s) set
           ldaa Timer_ThermostatDiagnostics    ; load a with memory contents
           beq  LB13D          ; branch if equal (zero)
           ldab Counter_MainLoop    ; load b with memory contents
           bne  LB13D          ; branch if not equal (not zero)
           ldab CoolantTemp    ; load b with memory contents
           cmpb TDAGTP_TstatDiagnosticsTemperatureGoalWithin_HOTIME    ; compare b with memory contents (data is c7)
           bcc  LB13A          ; branch if greater or equal
           ldab KeyOnOrEngineRunningTime    ; load b with memory contents
           incb            
           bne  LB13D          ; branch if not equal (not zero)
           ldab VehicleSpeed_HB    ; load b with memory contents
           cmpb #0x07          ;  -00000111-
           bcs  LB13D          ; branch if lower
           inca                ; increment a
           beq  LB134          ; branch if equal (zero)
           cmpa HOTIME_TstatDiagnosticsTimeToAchieveTemperatureGoal    ; compare a with memory contents (data is ae)
           bcs  LB13B          ; branch if lower
   LB134:  ldd  #0x2101        ; load d (a&b) with value -00100001 00000001-
           jsr  ThrowNonCriticalError    ; call subroutine
   LB13A:  clra                ; a = 0
   LB13B:  staa Timer_ThermostatDiagnostics    ; store a into memory
   LB13D:  rts                 ; return from subroutine

VerifyOperationOfASDRelayAndO2Sensor_MM:
           ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           bne  LB13D          ; branch if not equal (not zero)
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x03          ;  -00000011-
           bne  LB15F          ; branch if not equal (not zero)
           ldaa TimerOverflowsBetweenDistPulses    ; load a with memory contents
           bne  LB15F          ; branch if not equal (not zero)
           ldaa BatteryVolts    ; load a with memory contents
           cmpa #0x81          ; compare a with value -10000001-
           bcs  LB15F          ; branch if lower
           ldaa SwitchPortAccessReg1    ; load a with memory contents
           bita #sp1_B1Volt          ;  -00100000-
           bne  LB15F          ; branch if not equal (not zero)
           ldd  #0x2c14        ; load d (a&b) with value -00101100 00010100-
           jsr  ThrowNonCriticalError    ; call subroutine
   LB15F:  brset *BitFlags6d, #b6d_FuelEngineNotRunning, LB1A5    ; branch if bit(s) set
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa #0x2c          ; compare a with value -00101100-
           bcs  LB1A5          ; branch if lower
           ldaa CoolantTemp    ; load a with memory contents
           cmpa CTLRPM_LowBatteryVoltageAtThisCoolantTemp    ; compare a with memory contents (data is cd)
           bcs  LB1A5          ; branch if lower
           brclr *BitFlags6c, #b6c_bit5, LB1AA    ; branch if bit(s) clear
           ldaa Counter_O2Diagnostics    ; load a with memory contents
           cmpa O2DIAG_CounterLimitForO2SensorDiag    ; compare a with memory contents (data is 13)
           bcs  LB19F          ; branch if lower
           ldaa O2SensorValue    ; load a with memory contents
           cmpa O2MID_LimitForO2SensorBatteryDiag    ; compare a with memory contents (data is 4d)
           bcs  LB1A5          ; branch if lower
           ldaa Timer_O2MiddleDiagnostics    ; load a with memory contents
           cmpa #0x16          ; compare a with value -00010110-
           bcs  LB194          ; branch if lower
           ldd  #0x2001        ; load d (a&b) with value -00100000 00000001-
           jsr  ThrowNonCriticalError    ; call subroutine
           bset *BitFlags67, #b67_BadO2    ; set bits
           bra  LB1F5          ; branch

   LB194:  ldab Counter_MainLoop    ; load b with memory contents
           cmpb #0x50          ;  -01010000-
           bne  LB1F5          ; branch if not equal (not zero)
           inca                ; increment a
           staa Timer_O2MiddleDiagnostics    ; store a into memory
           bra  LB1F5          ; branch

   LB19F:  inca                ; increment a
           staa Counter_O2Diagnostics
           bra  LB1F5          ; branch

   LB1A5:  bclr *BitFlags6c, #b6c_bit5    ; clear bits
           bra  LB1D3          ; branch

   LB1AA:  ldaa O2SensorValue    ; load a with memory contents
           cmpa O2MIDH_HighLimitForInMiddleDetermination    ; compare a with memory contents (data is 1c)
           bhi  LB1D3          ; branch if higher
           cmpa O2MIDL_LowLimitForInMiddleDetermination    ; compare a with memory contents (data is 12)
           bcs  LB1D3          ; branch if lower
           ldaa Timer_O2MiddleDiagnostics    ; load a with memory contents
           cmpa #0x0b          ; compare a with value -00001011-
           bcs  LB1CA          ; branch if lower
           bset *BitFlags6c, #b6c_bit5    ; set bits
           clra                ; a = 0
           staa Timer_O2MiddleDiagnostics    ; store a into memory
           staa Counter_O2Diagnostics
           bset *PIA3_Buffer, #pi3_FuelMon    ; set bits
           bra  LB1F5          ; branch

   LB1CA:  ldab Counter_MainLoop    ; load b with memory contents
           cmpb #0xa0          ;  -10100000-
           bne  LB1D6          ; branch if not equal (not zero)
           inca                ; increment a
           bra  LB1D4          ; branch

   LB1D3:  clra                ; a = 0
   LB1D4:  staa Timer_O2MiddleDiagnostics    ; store a into memory
   LB1D6:  bclr *PIA3_Buffer, #pi3_FuelMon    ; clear bits
           ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x07          ;  -00000111-
           bne  LB1F5          ; branch if not equal (not zero)
           brset *BitFlags67, #b67_BadO2, LB1F5    ; branch if bit(s) set
           ldaa O2SensorValue    ; load a with memory contents
           cmpa O2MIDX_HighLimitForInMiddleDeterminationX    ; compare a with memory contents (data is 3e)
           bls  LB1F5          ; branch if lower or same
           ldd  #0x3e9e        ; load d (a&b) with value -00111110 10011110-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LB1F5          ; branch if greater or equal
           bset *BitFlags67, #b67_BadO2    ; set bits
   LB1F5:  rts                 ; return from subroutine

DealWithConfigurationAndPulseAccumulator_MM:
           ldx  #CPU_PortA     ; load index with value
           brset  9, X, #$%00111010, LB200    ; branch if bit(s) set
           bset  9, X, #$%00111010    ; bit set
   LB200:  brclr  9, X, #$%00000101, LB207    ; branch if bit(s) clear
           bclr  9, X, #$%00000101    ; bit clear
   LB207:  ldaa CPU_OutputCompare1Mask    ; load a with memory contents
           bita #0xf8          ;  -11111000-
           beq  LB211          ; branch if equal (zero)
           clr  CPU_OutputCompare1Mask    ; zero byte at memory location
   LB211:  brset 33, X, #$%00001000, LB218    ; branch if bit(s) set
           bset 33, X, #$%00001000    ; bit set
   LB218:  brclr 33, X, #$%00000111, LB21F    ; branch if bit(s) clear
           bclr 33, X, #$%00000111    ; bit clear
   LB21F:  ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_VNT          ;  -00000001-
           bne  LB236          ; branch if not equal (not zero)
           brset 34, X, #$%10101110, LB22D    ; branch if bit(s) set
           bset 34, X, #$%10101110    ; bit set
   LB22D:  brclr 34, X, #$%00010001, LB244    ; branch if bit(s) clear
           bclr 34, X, #$%00010001    ; bit clear
           bra  LB244          ; branch

   LB236:  brset 34, X, #$%10111110, LB23D    ; branch if bit(s) set
           bset 34, X, #$%10111110    ; bit set
   LB23D:  brclr 34, X, #$%00000001, LB244    ; branch if bit(s) clear
           bclr 34, X, #$%00000001    ; bit clear
   LB244:  brclr 36, X, #$%11110001, LB24B    ; branch if bit(s) clear
           bclr 36, X, #$%11110001    ; bit clear
   LB24B:  ldaa CPU_PortA_Control    ; load a with memory contents
           beq  LB253          ; branch if equal (zero)
           clr  CPU_PortA_Control    ; zero byte at memory location
   LB253:  ldaa #0x54          ; load a with value -01010100-
           cmpa CPU_SerialPeripheralControl    ; compare a with memory contents
           beq  LB25D          ; branch if equal (zero)
           staa CPU_SerialPeripheralControl
   LB25D:  ldd  #0x000c    ; load d (a&b) with value -00000000 00001100-
           cmpD CPU_SerialControlReg1    ; compare D
           beq  LB269          ; branch if equal (zero)
           std  CPU_SerialControlReg1
   LB269:  brset 57, X, #$%10001000, LB270    ; branch if bit(s) set
           bset 57, X, #$%10001000    ; bit set
   LB270:  brclr 57, X, #$%01000000, LB277    ; branch if bit(s) clear
           bclr 57, X, #$%01000000    ; bit clear
   LB277:  brset 60, X, #$%00000101, LB280    ; branch if bit(s) set
           sei                 ; disable interrupts
           bset 60, X, #$%00000101    ; bit set
           cli                 ; enable interrupts
   LB280:  brclr 60, X, #$%00001010, LB289    ; branch if bit(s) clear
           sei                 ; disable interrupts
           bclr 60, X, #$%00001010    ; bit clear
           cli                 ; enable interrupts
   LB289:  ldx  #0x1770        ; load index with value
           sei                 ; disable interrupts
           brclr  2, X, #$%01100100, LB294    ; branch if bit(s) clear
           bclr  2, X, #$%01100100    ; bit clear
   LB294:  cli                 ; enable interrupts
           bclr 64, X, #$%00001000    ; bit clear
           ldaa PIA_Ctrl_2     ; load a with memory contents
           beq  LB2A0          ; branch if equal (zero)
           clr  PIA_Ctrl_2     ; zero byte at memory location
   LB2A0:  ldaa PIA_Ctrl_3     ; load a with memory contents
           beq  LB2A8          ; branch if equal (zero)
           clr  PIA_Ctrl_3     ; zero byte at memory location
   LB2A8:  ldaa #0xf8          ; load a with value -11111000-
           cmpa PIA_Ctrl_5     ; compare a with memory contents
           beq  LB2B2          ; branch if equal (zero)
           staa PIA_Ctrl_5 
   LB2B2:  rts                 ; return from subroutine

VerifyOperationOfIgnitionCoilDriver_MM:
           ldaa TimerOverflowsBetweenDistPulses    ; load a with memory contents
           cmpa #0x50          ; compare a with value -01010000-
           bcs  LB2F9          ; branch if lower
           ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           bne  LB2FC          ; branch if not equal (not zero)
           ldaa SwitchPortAccessReg2    ; load a with memory contents
           tab                 ; b = a
           eorb BitFlags6b 
           andb #0x01          ;  -00000001-
           beq  LB2D3          ; branch if equal (zero)
           anda #0x01          ; AND a with value -00000001-
           ldab BitFlags6b     ; load b with memory contents
           andb #0xfe          ;  -11111110-
           aba                 ; a=a+b
           staa BitFlags6b     ; store a into memory
           bclr *BitFlags6b, #$%00000100    ; clear bits
   LB2D3:  brset *BitFlags6b, #$%00000100, LB2FC    ; branch if bit(s) set
           ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x0f          ;  -00001111-
           bne  LB2FC          ; branch if not equal (not zero)
           ldaa BatteryVolts    ; load a with memory contents
           cmpa #0x41          ; compare a with value -01000001-
           bcs  LB2FC          ; branch if lower
           cmpa COILHI_HiLimitBatteryVoltsForCoilVerify    ; compare a with memory contents (data is ba)
           bcc  LB2FC          ; branch if greater or equal
           ldaa MapValue       ; load a with memory contents
           suba MapVolts   
           bls  LB2FC          ; branch if lower or same
           cmpa COILLO_LoLimitBatteryVoltsForCoilVerify    ; compare a with memory contents (data is 05)
           bcs  LB2FC          ; branch if lower
           ldd  #0x2814        ; load d (a&b) with value -00101000 00010100-
           jmp  ThrowNonCriticalError

   LB2F9:  bset *BitFlags6b, #$%00000100    ; set bits
   LB2FC:  rts                 ; return from subroutine

NULL_ROUTINE:
           rts                 ; return from subroutine

; Up to B600, the code is byte-for-byte identical to the original, except for addresses

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


;---------------------------------------
	.org	0xb672
AlarmStatus:
		.byte	0xff
		
; B672 thru B687 appear to possibly be the alarm status bytes		
;---------------------------------------


	.org	0xb7e0
LB7E0:
		.byte	0xff

	.org	0xb7e1
LB7E1:
		.byte	0xff

        .org    0xB800

CalculatePartThrottleTransientFuel_MM:
           clra                ; a = 0
           staa Temp2          ; store a into memory
           staa Temp3          ; store a into memory
           ldaa Timer_O2InhibitSwitchingRichIdleToClosedLoop    ; load a with memory contents
           beq  LB80C          ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_O2InhibitSwitchingRichIdleToClosedLoop    ; store a into memory
   LB80C:  ldaa CoolantTemp    ; load a with memory contents
           ldab MapValue       ; load b with memory contents
           subb MapAverageValue_HB    ; b = b-memory contents
           stab Temp0          ; store b into memory
           bcs  TransFuel_CalculateDecreasingMAPTransientFuel    ; branch if lower
           ldx  #AETIME_EnrichmentTime_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Factor_LeanoutOrEnrichTime_MAP    ; store a into memory
           clra                ; a = 0
           staa Factor_DecelLeanoutWhenMAPDecreasing    ; store a into memory
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_UseTPSTransFuelEarly          ;  -00000010-
           beq  TransFuel_CalculateIncreasingMAPTransientFuel    ; branch if equal (zero)
           brset *BitFlags66, #b66_OffIdle, TransFuel_CalculateIncreasingMAPTransientFuel    ; branch if bit(s) set
           jmp  TransFuel_IncludeTPSTransients

TransFuel_CalculateIncreasingMAPTransientFuel:
           ldaa Temp0          ; load a with memory contents
           suba MAPTRG_DeltaMapTriggerLevel    ;  (data is 07)
           bcs  TransFuel_IncludeTPSTransients    ; branch if lower
           cmpa MAPMAX_MaxDeltaMapAllowed    ; compare a with memory contents (data is ff)
           bcs  LB83E          ; branch if lower
           ldaa MAPMAX_MaxDeltaMapAllowed    ; load a with memory contents (data is ff)
   LB83E:  staa Temp1          ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #AESLOP_DeltaMAPEnrichmentPT    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp1          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           stD *Temp2          ; store D to RAM
           bra  TransFuel_IncludeTPSTransients    ; branch

TransFuel_CalculateDecreasingMAPTransientFuel:
           ldx  #LMAPTC_TimeConstant    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Factor_LeanoutOrEnrichTime_MAP    ; store a into memory
           brset *BitFlags66, #b66_FullThrottle, LB8A2    ; branch if bit(s) set
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa LOTRPM_MinRpmForMapLeanout    ; compare a with memory contents (data is 35)
           bcs  LB8A2          ; branch if lower
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_ATX          ;  -00100000-
           beq  LB86D          ; branch if equal (zero)
           brclr *BitFlags_AIS, #b10_ATXInGear, LB8A2    ; branch if bit(s) clear
   LB86D:  brclr *KeyOnOrEngineRunningTime, #$%11111111, LB8A2    ; branch if bit(s) clear
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           cmpD #0x0080    ; compare D -00000000 10000000-
           bcs  LB8A2          ; branch if lower
           ldaa Temp0          ; load a with memory contents
           nega                ; negate a (set high bit)
           ldab Factor_DecelLeanoutWhenMAPDecreasing    ; load b with memory contents
           beq  LB883          ; branch if equal (zero)
           adda DECHYS_DeltaMapHysteresisonTriggerLevels    ;  (data is 01)
   LB883:  cmpa DECTRG_DeltaMapTriggerForNoIncrementalLeanout    ; compare a with memory contents (data is 13)
           bcs  LB8A2          ; branch if lower
           cmpa DTRG2_DeltaMapTriggerForMaxLeanout    ; compare a with memory contents (data is 13)
           bcs  LB89C          ; branch if lower
           ldaa DCELTM_O2CNTRInhibitAfterLeanoutDone    ; load a with memory contents (data is 01)
           staa Timer_O2InhibitSwitchingRichIdleToClosedLoop    ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #DECEL_DecelLeanoutFactorMAP    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           bra  LB8A3          ; branch

   LB89C:  tstb            
           beq  LB8A5          ; branch if equal (zero)
           incb            
           bra  LB8A3          ; branch

   LB8A2:  clrb                ; b = 0
   LB8A3:  stab Factor_DecelLeanoutWhenMAPDecreasing    ; store b into memory
   LB8A5:  ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x07          ;  -00000111-
           bne  TransFuel_IncludeTPSTransients    ; branch if not equal (not zero)
           ldx  #MapAverageValue_HB    ; load index with value
           sei                 ; disable interrupts
           jsr  ProcessMapOrTpsBlockData    ; call subroutine
           cli                 ; enable interrupts
TransFuel_IncludeTPSTransients:
           ldaa CoolantTemp    ; load a with memory contents
           ldab TpsVolts       ; load b with memory contents
           subb TpsAverageValue_HB    ; b = b-memory contents
           stab Temp0          ; store b into memory
           bcs  TransFuel_CalculateDecreasingTPSTransientFuel    ; branch if lower
           ldx  #THRTCN_EnrichmentTime_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Factor_LeanoutOrEnrichTime_TPS    ; store a into memory
           clra                ; a = 0
           staa Timer_OffThrottleFuelEnrich    ; store a into memory
           ldaa Temp0          ; load a with memory contents
           suba POSTRG_PositiveTransientTriggerLevel    ;  (data is 03)
           bcs  TransFuel_SaveTemp2    ; branch if lower
           cmpa THRMAX_MaxDeltaTHR    ; compare a with memory contents (data is 26)
           bcs  LB8D7          ; branch if lower
           ldaa THRMAX_MaxDeltaTHR    ; load a with memory contents (data is 26)
   LB8D7:  staa Temp1          ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #POSSLP_DeltaTPSEnrichment_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp1          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           addd Temp2          ; d = d + memory contents
           bra  TransFuel_SaveD    ; branch

TransFuel_CalculateDecreasingTPSTransientFuel:
           ldx  #LOTIME_DecelLeanoutTimeConstant_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Factor_LeanoutOrEnrichTime_TPS    ; store a into memory
           brclr *KeyOnOrEngineRunningTime, #$%11111111, TransFuel_ClearLeanOutFactor    ; branch if bit(s) clear
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           cmpD #0x0080    ; compare D -00000000 10000000-
           bcs  TransFuel_ClearLeanOutFactor    ; branch if lower
           ldaa Temp0          ; load a with memory contents
           nega                ; negate a (set high bit)
           ldab Timer_OffThrottleFuelEnrich    ; load b with memory contents
           beq  LB906          ; branch if equal (zero)
           adda LOTHYS_LeanoutDeltaThrottleHysteresis    ;  (data is 01)
   LB906:  cmpa LOTTRG_DeltaTriggerForDecelLeanout    ; compare a with memory contents (data is 0b)
           bcs  TransFuel_ClearLeanOutFactor    ; branch if lower
           cmpa LOTRG2_SecondDecelLeanoutTrigger    ; compare a with memory contents (data is 0b)
           bcs  LB91A          ; branch if lower
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #LOTTHR_DecelLeanoutFactor_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           bra  TransFuel_StoreLeanOutFactor    ; branch

   LB91A:  tstb            
           beq  LB923          ; branch if equal (zero)
           incb            
           bra  TransFuel_StoreLeanOutFactor    ; branch

TransFuel_ClearLeanOutFactor:
           clrb                ; b = 0
TransFuel_StoreLeanOutFactor:
           stab Timer_OffThrottleFuelEnrich    ; store b into memory
   LB923:  ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x07          ;  -00000111-
           bne  TransFuel_SaveTemp2    ; branch if not equal (not zero)
           ldx  #TpsAverageValue_HB    ; load index with value
           sei                 ; disable interrupts
           jsr  ProcessMapOrTpsBlockData    ; call subroutine
           cli                 ; enable interrupts
TransFuel_SaveTemp2:
           brset *BitFlags6d, #b6d_FuelEngineNotRunning, LB954    ; branch if bit(s) set
           ldd  Temp2          ; load d (a&b) with memory contents
TransFuel_SaveD:
           stD *Pulsewidth_PartThrottleEnrichment_HB    ; store D to RAM
           brset *BitFlags66, #b66_OffIdle, LB954    ; branch if bit(s) set
           ldaa SwitchPortAccessReg1    ; load a with memory contents
           bita #0x40          ;  -01000000-
           bne  LB954          ; branch if not equal (not zero)
           ldaa DesiredNewAisPosition    ; load a with memory contents
           suba CurrentAisPosition
           bcs  LB954          ; branch if lower
           cmpa POSTIG_MinAisPulseRequireToTriggerEnrichment    ; compare a with memory contents (data is 09)
           bcs  LB954          ; branch if lower
TransFuel_UseIdlePulse:
           ldd  POSFUL_AisEnrichmentFuelPulse    ;  (data is 00a0)
           stD *Pulsewidth_AISEnrichment_HB    ; store D to RAM
   LB954:  rts                 ; return from subroutine

CalculateInjectorPulsewidthForStarting_MM:
           brset *BitFlags6d, #b6d_FuelEngineNotRunning, LB95A    ; branch if bit(s) set
           rts                 ; return from subroutine

   LB95A:  clra                ; a = 0
           clrb                ; b = 0
           stD *Pulsewidth_PartThrottleEnrichment_HB    ; store D to RAM
           ldaa TpsVolts       ; load a with memory contents
           cmpa #0xd0          ; compare a with value -11010000-
           bcc  ThrottleFlooredWhileStarting_UnloadFuel    ; branch if greater or equal
           suba MINTHR_LowestSessionTPS
           bls  LB96D          ; branch if lower or same
           cmpa UNLOAD_DeltaThrottleFrom_MINTHR_ToUnloadCrankingFuel    ; compare a with memory contents (data is 85)
           bcc  ThrottleFlooredWhileStarting_UnloadFuel    ; branch if greater or equal
   LB96D:  jsr  AllowForHeatSoakAfterStall    ; call subroutine
           brset *BitFlags66, #b66_OffIdle, LB97C    ; branch if bit(s) set
           cmpa STRLMT_ColdestTempAllowedAtClosedThrottle    ; compare a with memory contents (data is 69)
           bcc  LB97C          ; branch if greater or equal
           ldaa STRLMT_ColdestTempAllowedAtClosedThrottle    ; load a with memory contents (data is 69)
   LB97C:  ldx  #STRTFL_FuelStartFromCoolantTemp    ; load index with value
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
           beq  LB9A9          ; branch if equal (zero)
           nega                ; negate a (set high bit)
           ldY Temp0           ; load Y index
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           stD *Temp0          ; store D to RAM
   LB9A9:  ldaa BaroPressure    ; load a with memory contents
           ldx  #STFBAR_FuelStartReductionFromBaro    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp4          ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #STFTM2_FuelStartFuelFromCoolant2    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp4          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           beq  LB9CD          ; branch if equal (zero)
           nega                ; negate a (set high bit)
           ldY Temp0           ; load Y index
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           bra  LB9CF          ; branch

   LB9CD:  ldd  Temp0          ; load d (a&b) with memory contents
   LB9CF:  asld                ; shift left (d=d*2)
           bcs  LB9D5          ; branch if lower
           asld                ; shift left (d=d*2)
           bcc  LB9DC          ; branch if greater or equal
   LB9D5:  ldd  #0xFFFF         ; load d (a&b) with value -11111111 11111111-
           bra  LB9DC          ; branch

ThrottleFlooredWhileStarting_UnloadFuel:
           clra                ; a = 0
           clrb                ; b = 0
   LB9DC:  jsr  NULL_ROUTINE    ; call subroutine
           stD *InjectorPulsewidth_HB    ; store D to RAM
           cli                 ; enable interrupts
           ldx  #SFDCAY_FuelStartDecayIntoRun    ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           staa Factor_StartFuelDecayIntoRunFuel    ; store a into memory
           rts                 ; return from subroutine

ControlEngineCutout_MM:
           brset *Turbonator_Flags, #Turbonator_Staging, R1000 ; added to keep the normal rev limiter code from turning off the staging limiter...
           brclr *TimerOverflowsBetweenDistPulses, #$%11111111, Cutout_EngineRunning    ; branch if bit(s) clear
           bclr  *Turbonator_Flags, #Turbonator_MainFuelOff | Turbonator_OverRev	 ; clear bits
           brset *BitFlags6b, #b6b_bit3, R1000    ; branch if bit(s) set
           clr  Counter_FuelEngRunning    ; zero byte at memory location
   R1000:  rts                 ; return from subroutine

; original code
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
	   brclr *Turbonator_Flags, #Turbonator_MainFuelOff, Cutout_UseDecelFuelCut    ; branch if bit(s) clear
           jmp  Cutout_UseHysteresisToDetermineWhenToTurnFuelBackOn

Cutout_UseDecelFuelCut:
           brclr *Turbonator_Flags, #Turbonator_DecelFuelCut, CheckForVNTOB    ; branch if bit(s) clear
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  LBA1B          ; branch if greater or equal
           clra                ; a = 0
   LBA1B:  cmpa DFRPMH_DecelFuelShutoffDeltaRPMOff    ; compare a with memory contents (data is 1e)
           bls  CheckForVNTOB          ; branch if lower or same
           bset *Turbonator_Flags, #Turbonator_MainFuelOff    ; set bits
           rts                 ; return from subroutine

CheckForVNTOB:
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_VNT          ;  -00000001-
           beq  Cutout_CheckForOBConditions    ; branch if equal (zero)
           brclr *BitFlags6c, #b6c_VNTOvBst, Cutout_CheckRevLimiters    ; branch if bit(s) clear
           brset *b5d_IPL2, #b5d_WGSolFault, LBA39    ; branch if bit(s) set
           ldd  #0x0708        ; load d (a&b) with value -00000111 00001000-
           jsr  ThrowNonCriticalError    ; call subroutine
   LBA39:  ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_VNTOBFuelShut          ;  -00000100-
           beq  Cutout_CheckRevLimiters    ; branch if equal (zero)
           bclr *Turbonator_Flags, #Turbonator_OverRev    ; clear bits
           bset *Turbonator_Flags, #Turbonator_MainFuelOff    ; set bits
           rts                 ; return from subroutine

Cutout_CheckForOBConditions:
           ldaa MapValue       ; load a with memory contents
           suba BaroPressure
           bcs  Cutout_ResetOverboostTimer    ; branch if lower
           brclr *b5d_IPL2, #b5d_WGSolFault, Cutout_CheckNormalOB    ; branch if bit(s) clear
           cmpa LMPSHF_OverboostFuelShutoffDisablePointFromMap_Limp    ; compare a with memory contents (data is 73)
           bls  Cutout_CheckRevLimiters    ; branch if lower or same

Cutout_ShutOffEngineForThisRotation:
	   bclr *Turbonator_Flags, #Turbonator_OverRev        ; clear bits
           brset *Turbonator_Flags, #Turbonator_MainFuelOff, LBA60    ; branch if bit(s) set
	   bset *Turbonator_Flags, #Turbonator_MainFuelOff
           bset *BitFlags6a, #b6a_WGDC        ; set bits
LBA60:	   rts		                       ; return from subroutine

Cutout_ResetOverboostTimer:
           ldaa TRNTIM_OverboostFuelShutoffDuration    ; load a with memory contents (data is ff)
           staa Timer_OverboostCountdown    ; store a into memory
           bra  Cutout_CheckRevLimiters    ; branch

Cutout_CheckNormalOB:
           suba MPSHFT_OverboostFuelShutoffEnablePointFromMap_Timer    ;  (data is 95)
           bcs  Cutout_ResetOverboostTimer    ; branch if lower
           cmpa MPSHFA_OverboostFuelShutoffEnablePointFromMap_Absolute    ; compare a with memory contents (data is 35)
           bhi  Cutout_SetOBCodeAndShutdown    ; branch if higher
           ldaa Timer_OverboostCountdown    ; load a with memory contents
           beq  Cutout_SetOBCodeAndShutdown    ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_OverboostCountdown    ; store a into memory
           bra  Cutout_CheckRevLimiters    ; branch

Cutout_SetOBCodeAndShutdown:
           ldd  #0x0708        ; load d (a&b) with value -00000111 00001000-
           jsr  ThrowNonCriticalError    ; call subroutine
           bra  Cutout_ShutOffEngineForThisRotation    ; branch

Cutout_CheckRevLimiters:
           ldx  #REVLMT2_MapLimpinAndThrAbove25PercentUpper2000    ; load index with value
           brclr *b5c_IPL1, #b5c_MapStuck | b5c_MapBadSignal, MAPSENSOR_OKAY_OR_LIGHTTHROTTLE    ; branch if bit(s) clear
           ldab THRTHR_25PctThrValueFromShutoff    ; load b with memory contents (data is 21)
           addb MINTHR_LowestSessionTPS    ; b=b+memory contents
           cmpb TpsVolts   
           bcs  Cutout_CheckRevLimitingValues    ; branch if lower

MAPSENSOR_OKAY_OR_LIGHTTHROTTLE:
           ldx  #REVLMT4_MapAbove75PctAndThrLimpin2000    ; load index with value
           brclr *b5c_IPL1, #b5c_TpsBadSignal, THROTTLESENSOR_OKAY    ; branch if bit(s) clear
           ldaa Temp0          ; load a with memory contents
           cmpa RVLSPD_CarSpeedForRevLimitWithTBOff    ; compare a with memory contents (data is 14)
           bcc  LBAB1          ; branch if greater or equal
           bra  LBAA7          ; branch

THROTTLESENSOR_OKAY:
           ldab BitFlags66     ; load b with memory contents
           bmi  LBAB1          ; branch if minus(hi bit 1)  - OffIdle
   LBAA7:  ldab BaroPressure    ; load b with memory contents
           lsrb                ; logical shift right b
           tba                 ; a = b
           lsrb                ; logical shift right b
           aba                 ; a=a+b
           cmpa MapValue       ; compare a with memory contents
           bcs  Cutout_CheckRevLimitingValues    ; branch if lower
   LBAB1:  ldx  #REVLMT6_RPMLimiterNormalOffRPM  ; load index with value

Cutout_CheckRevLimitingValues:
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa 0x00, X        ; compare a with memory at index + value
           bcc  Cutout_ShutOffEngineForThisRotation    ; branch if greater or equal
           cmpa SPDRPM_EngineSpeedHighLimitToEnableOverspeed    ; compare a with memory contents (data is d5)
           bcs  LBAC6          ; branch if lower
           ldab Temp1          ; load b with memory contents
           cmpb SPDLMH_SpeedLimitFuelShutoff254mph    ; compare b with memory contents (data is fa)
           bcc  Cutout_ShutOffEngineForThisRotation    ; branch if greater or equal
   LBAC6:  brset *BitFlags67, #b67_FallToIdle, Cutout_CheckMPHLimitingValues    ; branch if bit(s) set
           bclr *Turbonator_Flags, #Turbonator_OverRev    ; clear bits
           brset *BitFlags6b, #b6b_bit3, LBAD4    ; branch if bit(s) set
           clr  Counter_FuelEngRunning    ; zero byte at memory location
   LBAD4:  rts                 ; return from subroutine

Cutout_CheckMPHLimitingValues:
           cmpa DFRPM2_2550RPM_DecelFuelShutoffUpperRpmLimit    ; compare a with memory contents (data is 32)
           bcs  LBB0A          ; branch if lower
           ldaa Temp0          ; load a with memory contents
           cmpa DFS20M_20MPHDecelFuelShutoffSpeedLimitOFF    ; compare a with memory contents (data is 14)
           bcs  LBB0A          ; branch if lower
           ldaa CoolantTemp    ; load a with memory contents
           cmpa DFSTMH_60DegCDecelFuelShutoffTempLimitOff    ; compare a with memory contents (data is cd)
           bcs  LBB0A          ; branch if lower
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa DFSTMRH_3minuteDecelFuelShutoffTimeLimitOFF    ; compare a with memory contents (data is 0b)
           bcs  LBB0A          ; branch if lower
           ldaa MapValue       ; load a with memory contents
           cmpa DFSMPH_MAPDecelFuelShutoffTimeLimitOFF    ; compare a with memory contents (data is 24)
           bhi  LBB0A          ; branch if higher
           ldaa b5c_IPL1       ; load a with memory contents
           bita #0xe2          ;  -11100010-
           bne  LBB0A          ; branch if not equal (not zero)
           brclr *BitFlags69, #b69_bit2, LBB0A    ; branch if bit(s) clear
           brset *Turbonator_Flags, #Turbonator_OverRev, LBB0A    ; branch if bit(s) set
           bset *Turbonator_Flags, #Turbonator_OverRev | Turbonator_MainFuelOff    ; set bits

Cutout_ClearO2FBCounter:
           clra                ; a = 0
           staa Counter_O2SensorFeedbackCount_Signed    ; store a into memory
   LBB0A:  rts                 ; return from subroutine

Cutout_UseHysteresisToDetermineWhenToTurnFuelBackOn:
           brclr *Turbonator_Flags, #Turbonator_DecelFuelCut, LBB1C    ; branch if bit(s) clear
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  LBB16          ; branch if greater or equal
           clra                ; a = 0
   LBB16:  cmpa DFRPML_DecelFuelShutoffDeltaRPMOn    ; compare a with memory contents (data is 11)
           bls  Cutout_TurnFuelBackOn    ; branch if lower or same
           rts                 ; return from subroutine

   LBB1C:  brclr *Turbonator_Flags, #Turbonator_OverRev, LBB4E    ; branch if bit(s) clear
           brclr *BitFlags67, #b67_FallToIdle, Cutout_TurnFuelBackOn    ; branch if bit(s) clear
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa DFRPM1_2050RPM_DecelFuelShutoffTurnonLimit    ; compare a with memory contents (data is 2c)
           bcs  Cutout_TurnFuelBackOn    ; branch if lower
           ldaa Temp0          ; load a with memory contents
           cmpa DFS20L_20MPHDecelFuelShutoffSpeedLimitON    ; compare a with memory contents (data is 10)
           bcs  Cutout_TurnFuelBackOn    ; branch if lower
           ldaa CoolantTemp    ; load a with memory contents
           cmpa DFSTML_60DegCDecelFuelShutoffTempLimitON    ; compare a with memory contents (data is ca)
           bcs  Cutout_TurnFuelBackOn    ; branch if lower
           ldaa MapValue       ; load a with memory contents
           cmpa DFSMPL_MAPDecelFuelShutoffTimeLimitON    ; compare a with memory contents (data is 27)
           bhi  Cutout_TurnFuelBackOn    ; branch if higher
           ldaa b5c_IPL1       ; load a with memory contents
           bita #0xe2          ;  -11100010-
           bne  Cutout_TurnFuelBackOn    ; branch if not equal (not zero)
           brset *BitFlags69, #b69_bit2, Cutout_ClearO2FBCounter    ; branch if bit(s) set
Cutout_TurnFuelBackOn:
           bclr *Turbonator_Flags, #Turbonator_MainFuelOff
           rts                 ; return from subroutine

   LBB4E:  ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_VNT          ;  -00000001-
           beq  LBB64          ; branch if equal (zero)
           brclr *BitFlags6c, #b6c_VNTOvBst, Cutout_DetermineLimpModeCutoutRPM    ; branch if bit(s) clear
           brset *b5d_IPL2, #b5d_WGSolFault, LBB63    ; branch if bit(s) set
           ldd  #0x0708        ; load d (a&b) with value -00000111 00001000-
           jsr  ThrowNonCriticalError    ; call subroutine
   LBB63:  rts                 ; return from subroutine

   LBB64:  ldaa MapValue       ; load a with memory contents
           suba BaroPressure
           bcs  Cutout_ResetOverboostTimerAgain    ; branch if lower
           brclr *b5d_IPL2, #b5d_WGSolFault, LBB7B    ; branch if bit(s) clear
           cmpa LMPSHF_OverboostFuelShutoffDisablePointFromMap_Limp    ; compare a with memory contents (data is 73)
           bls  Cutout_DetermineLimpModeCutoutRPM    ; branch if lower or same
           rts                 ; return from subroutine

Cutout_ResetOverboostTimerAgain:
           ldaa TRNTIM_OverboostFuelShutoffDuration    ; load a with memory contents (data is ff)
           staa Timer_OverboostCountdown    ; store a into memory
           bra  Cutout_DetermineLimpModeCutoutRPM    ; branch

   LBB7B:  suba MPSHFT_OverboostFuelShutoffEnablePointFromMap_Timer    ;  (data is 95)
           bcs  Cutout_ResetOverboostTimerAgain    ; branch if lower
           cmpa MPSHFA_OverboostFuelShutoffEnablePointFromMap_Absolute    ; compare a with memory contents (data is 35)
           bhi  LBB8E          ; branch if higher
           ldaa Timer_OverboostCountdown    ; load a with memory contents
           beq  LBB8E          ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_OverboostCountdown    ; store a into memory
           bra  Cutout_DetermineLimpModeCutoutRPM    ; branch

   LBB8E:  ldd  #0x0708        ; load d (a&b) with value -00000111 00001000-
           jmp  ThrowNonCriticalError

Cutout_DetermineLimpModeCutoutRPM:
           ldx  #REVLMT_MapLimpinAndThrAbove25PercentLower1850    ; load index with value
           brclr *b5c_IPL1, #b5c_MapStuck | b5c_MapBadSignal, MAPSENSOR_OKAY_OR_LIGHTTHROTTLE2    ; branch if bit(s) clear
           ldab THRTHR_25PctThrValueFromShutoff    ; load b with memory contents (data is 21)
           addb MINTHR_LowestSessionTPS    ; b=b+memory contents
           cmpb TpsVolts   
           bcs  CHECK_IFOVER_1850_2000_6167RPM    ; branch if lower
MAPSENSOR_OKAY_OR_LIGHTTHROTTLE2:
           ldx  #REVLMT3_MapAbove75PctAndIdleSwitchClosed2000    ; load index with value
           brclr *b5c_IPL1, #b5c_TpsBadSignal, THROTTLESENSOR_OKAY2    ; branch if bit(s) clear
           ldaa Temp0          ; load a with memory contents
           cmpa RVLSPD_CarSpeedForRevLimitWithTBOff    ; compare a with memory contents (data is 14)
           bcc  LBBC2          ; branch if greater or equal
           bra  LBBB8          ; branch

THROTTLESENSOR_OKAY2:
           ldab BitFlags66     ; load b with memory contents
           bmi  LBBC2          ; branch if minus(hi bit 1)
   LBBB8:  ldab BaroPressure    ; load b with memory contents
           lsrb                ; logical shift right b
           tba                 ; a = b
           lsrb                ; logical shift right b
           aba                 ; a=a+b
           cmpa MapValue       ; compare a with memory contents
           bcs  CHECK_IFOVER_1850_2000_6167RPM    ; branch if lower
   LBBC2:  ldx  #REVLMT5_RPMLimiterNormalOnRPM     ; load index with value
CHECK_IFOVER_1850_2000_6167RPM:
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa 0x00, X        ; compare a with memory at index + value
           bcc  LBBDA          ; branch if greater or equal
           cmpa SPDRPM2_EngineSpeedLowLimitToDisableOverspeed    ; compare a with memory contents (data is d1)
           bhi  LBBD3          ; branch if higher
   LBBD0:  jmp  Cutout_TurnFuelBackOn

   LBBD3:  ldaa Temp1          ; load a with memory contents
           cmpa SPDLML_SpeedLimitFuelShutoffRestore253mph    ; compare a with memory contents (data is fa)
           bls  LBBD0          ; branch if lower or same
   LBBDA:  rts                 ; return from subroutine

CalculatePartThrottleEnrichmentAndSparkScatterFuel_MM:
           ldx  #RPMMAP_SwitchPointForDownUp_FromRpm    ; load index with value
           brclr *b5c_IPL1, #$%00001000, LBBE5    ; branch if bit(s) clear
           ldx  #RPMMP2_SwitchPointForDownUp_FromRpm2        ; load index with value
   LBBE5:  ldaa EngineRpm_HB    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           cmpa MapValue       ; compare a with memory contents
           rora            
           ldx  #PTENR_EppPerAmountForIncreasing    ; load index with value
           anda #0x80          ; AND a with value -10000000-
           bmi  LBBF6          ; branch if minus(hi bit 1)
           inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
   LBBF6:  staa Temp0          ; store a into memory
           tab                 ; b = a
           eorb Counter_FallingEdgeEPP_MaxFF
           bpl  LBC03          ; branch if plus (hi bit 0)
           staa Counter_FallingEdgeEPP_MaxFF    ; store a into memory
           ldab Timer_OpenLoopFraction    ; load b with memory contents
           bra  LBC68          ; branch

   LBC03:  ldab 0x00, X        ; load b with memory at index + value
           sei                 ; disable interrupts
           eora Counter_FallingEdgeEPP_MaxFF
           cba             
           bcs  LBC0C          ; branch if lower
           sba                 ; subtract (a=a-b)
   LBC0C:  oraa Temp0          ; OR a with memory contents
           staa Counter_FallingEdgeEPP_MaxFF    ; store a into memory
           cli                 ; enable interrupts
           ldab Timer_OpenLoopFraction    ; load b with memory contents
           bcs  LBC68          ; branch if lower
           addb 0x01, X        ; add memory at index + value to b
           bpl  LBC1F          ; branch if plus (hi bit 0)
           clrb                ; b = 0
           tsta                ; test a
           bpl  LBC1F          ; branch if plus (hi bit 0)
           ldab #0x7f          ; load b with value -01111111-
   LBC1F:  stab Temp0          ; store b into memory
           ldx  #PTELMT_MultiplierMaxLimitFromRpm    ; load index with value
           ldaa EngineRpm_HB    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp4          ; store a into memory
           ldx  #PTEADJ_EnrichAdjust_FromMap    ; load index with value
           ldaa MapValue       ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp4          ; load a with memory contents
           tstb            
           beq  LBC3B          ; branch if equal (zero)
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
   LBC3B:  tab                 ; b = a
           cmpb Temp0      
           bls  LBC63          ; branch if lower or same
           brclr *BitFlags66, #b66_PTEisMaxed, LBC5F    ; branch if bit(s) clear
           ldab Timer_OpenLoopFraction    ; load b with memory contents
           beq  LBC5C          ; branch if equal (zero)
           sba                 ; subtract (a=a-b)
           staa Temp1          ; store a into memory
           ldaa PTENRD_AmountForDecreasingMultiplier_Negative    ; load a with memory contents (data is ff)
           beq  LBC5F          ; branch if equal (zero)
           nega                ; negate a (set high bit)
           ldab PTENUM_NumberToReturnToHOTMAP    ; load b with memory contents (data is 02)
           mul                 ; multiply (d=a*b)
           tsta                ; test a
           bne  LBC5F          ; branch if not equal (not zero)
           cmpb Temp1      
           bcc  LBC5F          ; branch if greater or equal
   LBC5C:  bclr *BitFlags66, #b66_PTEisMaxed    ; clear bits
   LBC5F:  ldab Temp0          ; load b with memory contents
           bra  LBC66          ; branch

   LBC63:  bset *BitFlags66, #b66_PTEisMaxed    ; set bits
   LBC66:  stab Timer_OpenLoopFraction    ; store b into memory
   LBC68:  brclr *BitFlags66, #b66_OffIdle, LBC6E    ; branch if bit(s) clear
           bne  LBC75          ; branch if not equal (not zero)
   LBC6E:  ldaa MapValue       ; load a with memory contents
           cmpa BOOSTP_AdjustO2ResponseForPTEWhenMapAboveThis    ; compare a with memory contents (data is ff)
           bcs  LBC7C          ; branch if lower
   LBC75:  ldaa Counter_O2SensorFeedbackCount_Signed    ; load a with memory contents
           bpl  LBC7C          ; branch if plus (hi bit 0)
           clra                ; a = 0
           staa Counter_O2SensorFeedbackCount_Signed    ; store a into memory
   LBC7C:  ldaa BatteryVolts    ; load a with memory contents
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
           cmpa IDLTMP_Use_IDLADD_AboveThisTemp    ; compare a with memory contents (data is 6e)
           bls  LBCA2          ; branch if lower or same
           brset *BitFlags67, #b67_IdleSpeedMode, LBCA2    ; branch if bit(s) set
           brset *BitFlags6e, #b6e_UseSparkScatter, UsingSparkScatterToControlIdle    ; branch if bit(s) set
   LBCA2:  ldd  Temp0          ; load d (a&b) with memory contents
           stD *SparkScatterFuelstabilizationValue_HB    ; store D to RAM
           rts                 ; return from subroutine

UsingSparkScatterToControlIdle:
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  IDLERPM_TOO_HIGH    ; branch if greater or equal
           coma            
           comb            
           bsr  DIN_ACLRDBOUT_CALCULATE_BASEDON_IDLE_ERROR_ROUTINE    ; call subroutine
           addd Temp0          ; d = d + memory contents
           stD *SparkScatterFuelstabilizationValue_HB    ; store D to RAM
           rts                 ; return from subroutine

IDLERPM_TOO_HIGH:
           bsr  DIN_ACLRDBOUT_CALCULATE_BASEDON_IDLE_ERROR_ROUTINE    ; call subroutine
           subd Temp0          ; d = d - memory contents
           coma            
           comb            
           stD *SparkScatterFuelstabilizationValue_HB    ; store D to RAM
           rts                 ; return from subroutine

DIN_ACLRDBOUT_CALCULATE_BASEDON_IDLE_ERROR_ROUTINE:
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           tsta                ; test a
           beq  LBCC8          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   LBCC8:  tba                 ; a = b
           ldx  #IDLADD_FuelStabilization_FromDeltaRPM    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           clra                ; a = 0
           rts                 ; return from subroutine

CalculateSumOfAllFuelModifiers_MM:
           brset *BitFlags6d, #b6d_FuelEngineNotRunning, ClearTemp0ForResultStorage    ; branch if bit(s) set
           ldx  #TMPHLD_TempSwitchPointForCurveAHoldDecay    ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           cmpa 0x00, X        ; compare a with memory at index + value
           bcs  LBCDF          ; branch if lower
           inx                 ; increment index (x=x+1)
   LBCDF:  brset *BitFlags67, #b67_bit1, LBD02    ; branch if bit(s) set
           brset *BitFlags66, #b66_O2Valid, LBCFC    ; branch if bit(s) set
           ldd  KeyOnOrEngineRunningTime    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           bcs  LBCFC          ; branch if lower
           asld                ; shift left (d=d*2)
           bcs  LBCFC          ; branch if lower
           cmpa 0x01, X        ; compare a with memory at index + value
           bcc  LBCFC          ; branch if greater or equal
           ldx  #DCYTMC_CurveAColdDecayTime    ; load index with value
           cmpa 0x02, X        ; compare a with memory at index + value
           bcc  LBD02          ; branch if greater or equal
           bra  ClearTemp0ForResultStorage    ; branch

   LBCFC:  bset *Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached, #$%11111111    ; set bits
           bset *BitFlags67, #b67_bit1    ; set bits
   LBD02:  brset *Counter_MainLoop, #$%00011111, LBD08    ; branch if bit(s) set
           bra  ClearTemp0ForResultStorage    ; branch

   LBD08:  ldab Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached    ; load b with memory contents
           subb 0x03, X    
           bcc  LBD0F          ; branch if greater or equal
           clrb                ; b = 0
   LBD0F:  stab Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached    ; store b into memory
ClearTemp0ForResultStorage:
           clra                ; a = 0
           staa Temp0          ; store a into memory
           brset *BitFlags66, #b66_FullThrottle, INCLUDE_COOLANTTEMP_ANDIFNOTFLOORED_RPM_COMBINATION    ; branch if bit(s) set
           brset *BitFlags66, #b66_PTEisMaxed, INCLUDE_COOLANTTEMP_ANDIFNOTFLOORED_RPM_COMBINATION    ; branch if bit(s) set
           brset *BitFlags66, #b66_OffIdle, LBD24    ; branch if bit(s) set
           brset *BitFlags6b, #$%00010000, INCLUDE_COOLANTTEMP_ANDIFNOTFLOORED_RPM_COMBINATION    ; branch if bit(s) set
   LBD24:  jsr  AllowForHeatSoakAfterStall    ; call subroutine
           brset *BitFlags67, #b67_bit1, LBD3C    ; branch if bit(s) set
           ldx  #CURVEC_FuelColdEnrichmentCurveC    ; load index with value
           staa Temp1          ; store a into memory
           jsr  Lookup4ByteTable    ; call subroutine
           ldab Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           staa Temp0          ; store a into memory
           ldaa Temp1          ; load a with memory contents
   LBD3C:  ldx  #CURVEA_FuelColdEnrichmentCurveA    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           brclr *BitFlags67, #b67_bit1, LBD4B    ; branch if bit(s) clear
           ldab Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
   LBD4B:  adda Temp0      
           staa Temp0          ; store a into memory
INCLUDE_COOLANTTEMP_ANDIFNOTFLOORED_RPM_COMBINATION:
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #CURVEB_FuelColdEnrichmentCurveB    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           brclr *BitFlags66, #b66_FullThrottle, THROT_NOT_FLOORED3    ; branch if bit(s) clear
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
           brset *BitFlags66, #b66_FullThrottle, LBDA7    ; branch if bit(s) set
           brset *BitFlags66, #b66_PTEisMaxed, LBDA7    ; branch if bit(s) set
           ldx  #HIGHM2_ColdLoadFromCoolantTemp2    ; load index with value
           brset *BitFlags66, #b66_OffIdle, LBD85    ; branch if bit(s) set
           ldx  #HIGHMP_ColdLoadFromCoolantTemp    ; load index with value
   LBD85:  ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp4          ; store a into memory
           ldx  #HMPMU2_ColdLoadFromMAP2    ; load index with value
           brset *BitFlags66, #b66_OffIdle, LBD96    ; branch if bit(s) set
           ldx  #HMPMUL_ColdLoadFromMAP    ; load index with value
   LBD96:  ldaa MapValue       ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp4          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           addd Temp0          ; d = d + memory contents
           stD *Temp0          ; store D to RAM
   LBDA7:  ldd  Temp0          ; load d (a&b) with memory contents
           pshb                ; push b onto stack
           psha                ; push a onto stack
           lsrd                ; shift right (d=d/2)
           stD *Temp0          ; store D to RAM
HandleBaroCompForWarmup:
           ldaa BaroPressure    ; load a with memory contents
           ldx  #BAROCP_BaroCompensationOfWarmupFactor_FromBaro    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           puly                ; pop Y from stack
           beq  LBDC8          ; branch if equal (zero)
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           addd Temp0          ; d = d + memory contents
           bcc  HandleOffThrottleEnrich    ; branch if greater or equal
           ldd  #0xFFFF         ; load d (a&b) with value -11111111 11111111-
           bra  HandleOffThrottleEnrich    ; branch

   LBDC8:  ldd  Temp0          ; load d (a&b) with memory contents
HandleOffThrottleEnrich:
           inca                ; increment a
           stD *Temp0          ; store D to RAM
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           stab BaseFuelModifier    ; store b into memory
           ldaa ChargeTemp    ; load a with memory contents
           ldx  #AIRTMP_FuelEnrichmentFromChargeTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldx  #Temp0         ; load index with value
           ldaa #0x01          ; load a with value -00000001-
           jsr  ScaleXbyB_addingA_intoD    ; call subroutine
           stD *Temp0          ; store D to RAM
           ldab Timer_FuelEnrich    ; load b with memory contents
           beq  LeanMixtureFromDecel_ThrottleDecreasing    ; branch if equal (zero)
           ldaa #0x01          ; load a with value -00000001-
           jsr  ScaleXbyB_addingA_intoD    ; call subroutine
           stD *Temp0          ; store D to RAM
LeanMixtureFromDecel_ThrottleDecreasing:
           ldaa Timer_OffThrottleFuelEnrich    ; load a with memory contents
           beq  LeanMixtureFromDecel_MapDecreasing    ; branch if equal (zero)
           ldY Temp0           ; load Y index
           jsr  ScaleYbyA      ; call subroutine
           stY Temp0           ; store Y index
LeanMixtureFromDecel_MapDecreasing:
           ldaa Factor_DecelLeanoutWhenMAPDecreasing    ; load a with memory contents
           beq  INCLUDE_ADAPTIVE_MEMORY    ; branch if equal (zero)
           ldY Temp0           ; load Y index
           jsr  ScaleYbyA      ; call subroutine
           stY Temp0           ; store Y index
INCLUDE_ADAPTIVE_MEMORY:
           brset *BitFlags66, #b66_FullThrottle, LBE22    ; branch if bit(s) set
           clra                ; a = 0
           ldab Timer_OpenLoopFraction    ; load b with memory contents
           bne  LBE1E          ; branch if not equal (not zero)
           ldab ValueFromAdaptiveMemory    ; load b with memory contents
           bmi  LBE16          ; branch if minus(hi bit 1)
   LBE15:  inca                ; increment a
   LBE16:  asrb            
           jsr  ScaleXbyB_addingA_intoD    ; call subroutine
           stD *Temp0          ; store D to RAM
           bra  LBE22          ; branch

   LBE1E:  ldab ValueFromAdaptiveMemory    ; load b with memory contents
           bpl  LBE15          ; branch if plus (hi bit 0)
   LBE22:  clra                ; a = 0
           ldab Counter_O2SensorFeedbackCount_Signed    ; load b with memory contents
           brclr *EGRVar2, #$%10000000, INCLUDE_OXYGEN_FEEDBACK_WITHRPM_COMBINATION    ; branch if bit(s) clear
           addb ADMEMA_ValueFromAdaptivememoryAdder1    ;  (data is 00)
           bvc  INCLUDE_OXYGEN_FEEDBACK_WITHRPM_COMBINATION    ; branch if overflow
           ldab #0x7f          ; load b with value -01111111-
INCLUDE_OXYGEN_FEEDBACK_WITHRPM_COMBINATION:
           tstb
           bmi  LBE34          ; branch if minus(hi bit 1)
           inca                ; increment a
   LBE34:  asrb            
           jsr  ScaleXbyB_addingA_intoD    ; call subroutine
           stD *Temp0          ; store D to RAM
           clrb                ; b = 0
           brset *BitFlags66, #b66_OffIdle, LBE57    ; branch if bit(s) set
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_O2          ;  -00001000-
           beq  LBE4A          ; branch if equal (zero)
           brclr *BitFlags6b, #$%00010000, LBE57    ; branch if bit(s) clear
   LBE4A:  ldaa EngineRpm_HB    ; load a with memory contents
           suba TargetIdleSpeedHB
           bcc  LBE51          ; branch if greater or equal
           clra                ; a = 0
   LBE51:  ldx  #DFBFMD_DefaultBaseFuelModifierFromRPMOverIdle    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
   LBE57:  clra                ; a = 0
           stab BaseFuelScalar          ; store b into memory
           bne  LBE5D          ; branch if not equal (not zero)
           inca                ; increment a
   LBE5D:  ldx  #Temp0         ; load index with value
           jsr  ScaleXbyB_addingA_intoD    ; call subroutine
           stD *Temp0          ; store D to RAM
           ldaa EngineRpm_HB    ; load a with memory contents
           ldx  #PEFTBL_PumpingEfficiency    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
; 150% PEFTBL code...
;            ldx  #Temp0
;            clra
;            tstb
;            bmi  LBB98          ; branch if minus(hi bit 1)
;            inca                ; increment a
; LBB98:     jsr  ScaleXbyB_addingA_intoD    ; call subroutine
;            stD *SumOfFuelModifiers_HB    ; store D to RAM
;            rts

; stock PEFTBL Code - only use with stock peftbl template!!!
           beq  LBE79          ; branch if equal (zero)
           ldY Temp0           ; load Y index
           jsr  ScaleYbyA      ; call subroutine
           stY SumOfFuelModifiers_HB    ; store Y index
           rts                 ; return from subroutine

   LBE79:  ldd  Temp0          ; load d (a&b) with memory contents
           stD *SumOfFuelModifiers_HB    ; store D to RAM
           rts                 ; return from subroutine

AllowForHeatSoakAfterStall:
           ldaa CoolantTemp    ; load a with memory contents
           cmpa RUNLMT_MaxAllowableTempFor_RUNTMP    ; compare a with memory contents (data is a3)
           bcc  LBE98          ; branch if greater or equal
           ldaa EngineRunningTimeBeforeStall    ; load a with memory contents
           ldx  #RUNTMP_ModifierOf_ENGTMP_FromStalltime    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           adda CoolantTemp
           ldab RUNLMT_MaxAllowableTempFor_RUNTMP    ; load b with memory contents (data is a3)
           bcs  LBE97          ; branch if lower
           cba             
           bcs  LBE98          ; branch if lower
   LBE97:  tba                 ; a = b
   LBE98:  rts                 ; return from subroutine

        

DealWithSpecialIdle_SetBasicTiming_MM:
           brset *BitFlags66, #b66_OffIdle, THROTTLE_PRESSED1    ; branch if bit(s) set
           ldaa RICHSA_OpenLoopEnrichFactorWhenSettingBasicTiming    ; load a with memory contents (data is 00)
           brset *b5c_IPL1, #b5c_BadCoolantTemp, LBEB4    ; branch if bit(s) set
           ldaa RIDLST_OpenLoopEnrichFactorWhenSettingMinThrottleOpening    ; load a with memory contents (data is 08)
           ldab DRBPointer1    ; load b with memory contents
           cmpb #0x14          ;  -00010100-
           bne  LBEB3          ; branch if not equal (not zero)
           ldab DRBPointer2    ; load b with memory contents
           cmpb #0x10          ;  -00010000-
           beq  LBEB4          ; branch if equal (zero)
   LBEB3:  clra                ; a = 0
   LBEB4:  brclr *Timer_FuelEnrich, #$%11111111, LOAD_FUELENRICHVAR    ; branch if bit(s) clear
           tsta                ; test a
           bne  LOAD_FUELENRICHVAR    ; branch if not equal (not zero)
           ldaa O2ITIM_TimeO2InhibitedSwitchingRichIdleToClosedLoop    ; load a with memory contents (data is ff)
           staa Timer_O2InhibitSwitchingRichIdleToClosedLoop    ; store a into memory
THROTTLE_PRESSED1:
           clra                ; a = 0
LOAD_FUELENRICHVAR:
           staa Timer_FuelEnrich    ; store a into memory
           beq  LBECA          ; branch if equal (zero)
           clra                ; a = 0
           staa Counter_O2SensorFeedbackCount_Signed    ; store a into memory
           staa Counter_AdaptiveMem_Erase    ; store a into memory
   LBECA:  rts                 ; return from subroutine


	;.org	0xbecb
LBECB:
		.word	0x0004
		.word	0x0602

InterruptVector_DistributorSignal:
           clrb                ; b = 0
           stab ATMOffset      ; store b into memory
           ldaa DRBPointer1    ; load a with memory contents
           cmpa #0x0a          ; compare a with value -00001010-
           bne  LBEDA          ; branch if not equal (not zero)
           stab DRBPointer1    ; store b into memory
   LBEDA:  ldaa #0x10          ; load a with value -00010000-
           staa CPU_A2DControlReg
           ldab SwitchPortAccessReg2    ; load b with memory contents
           andb #0x01          ;  -00000001-
           stab Temp6          ; store b into memory
           bset *BitFlags70, #b70_O2Enable    ; set bits
           ldd  CPU_DistPickupCaptureRegHigh
           jsr  DetermineNumberOfOverflowsBetweenDistributorPulses_MM    ; call subroutine
Delay256uSec:
           ldd  CPU_TimerCounterRegHigh
           subd CPU_DistPickupCaptureRegHigh
           subd #MapAverageValue_HB    ;  -00000000 10000000-
           bcs  Delay256uSec    ; branch if lower
           ldab #0x04          ; load b with value -00000100-
           stab CPU_TimerInterruptFlag1    ; store b into memory
           ldaa CPU_TimerControlReg2    ; load a with memory contents
           anda #0x30          ; AND a with value -00110000-
           beq  SETTOLOOKFORRISINGEDGE_STARTAD_RETURN    ; branch if equal (zero)
           cmpa #0x30          ; compare a with value -00110000-
           beq  SETTOLOOKFORRISINGEDGE_STARTAD_RETURN    ; branch if equal (zero)
           lsra            
           lsra            
           eora CPU_PortA  
           bita #0x04          ;  -00000100-
           beq  DistributorSignalIsWhatWasExpected    ; branch if equal (zero)
SETTOLOOKFORRISINGEDGE_STARTAD_RETURN:
           ldaa CPU_TimerControlReg2    ; load a with memory contents
           oraa #0x10          ;  -00010000-
           anda #0xdf          ; AND a with value -11011111-
           staa CPU_TimerControlReg2
           rti                 ; return from interrupt

DistributorSignalIsWhatWasExpected:
           ldaa Counter_SomethingWithDistributor    ; load a with memory contents
           inca                ; increment a
           beq  LBF25          ; branch if equal (zero)
           staa Counter_SomethingWithDistributor    ; store a into memory
   LBF25:  ldaa CPU_TimerControlReg2    ; load a with memory contents
           bita #0x10          ;  -00010000-
           bne  Interrupt_HandleDistributorRisingEdge    ; branch if not equal (not zero)
           jmp  FALLING_EDGE_INTERRUPT

Interrupt_HandleDistributorRisingEdge:
           brclr *BitFlags68, #b68_BladePassedSensor, LBF81    ; branch if bit(s) clear
           ldd  TimerOverflowsBetweenDistPulses    ; load d (a&b) with memory contents
           cmpD #0x0014    ; compare D -00000000 00010100-
           bcc  USE_DISTSYNCPICKUP_TOSETPOSITIONBITS    ; branch if greater or equal
           ldd  CPU_DistPickupCaptureRegHigh
           subd LastDistributorFallingEdgeTime    ; d = d - memory contents
           asld                ; shift left (d=d*2)
           ldab #0x03          ; load b with value -00000011-
           mul                 ; multiply (d=a*b)
           stab Temp5          ; store b into memory
           ldd  DistributorFallingEdgePulsewidth_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           tab                 ; b = a
           bset *BitFlags6f, #b6f_Alternator2    ; set bits
           ldaa Temp5          ; load a with memory contents
           cba             
           bcc  DIST_SYNC_WENT_TO_ZERO_WINDOWBLADE_JUSTLEAVING_REFPICKUP    ; branch if greater or equal
           bclr *BitFlags6f, #b6f_Alternator2    ; clear bits
           bra  DIST_SYNC_WENT_TO_ONE_WINDOWBLADE_JUSTCUTTING_REFPICKUP    ; branch

USE_DISTSYNCPICKUP_TOSETPOSITIONBITS:
           ldab Temp6          ; load b with memory contents
           ldaa BitFlags6f     ; load a with memory contents
           staa Temp5          ; store a into memory
           anda #0xfe          ; AND a with value -11111110-
           aba                 ; a=a+b
           staa BitFlags6f     ; store a into memory
           eorb Temp5      
           bitb #b6f_Alternator2          ;  -00000001-
           beq  DIST_SYNC_HASNT_CHANGED_REGULARBLADE_CUT_REFPICKUP    ; branch if equal (zero)
           ldab Temp6          ; load b with memory contents
           beq  DIST_SYNC_WENT_TO_ONE_WINDOWBLADE_JUSTCUTTING_REFPICKUP    ; branch if equal (zero)
           brclr *BitFlags70, #b70_AlternatorField, DIST_SYNC_WENT_TO_ZERO_WINDOWBLADE_JUSTLEAVING_REFPICKUP    ; branch if bit(s) clear
DIST_SYNC_WENT_TO_ONE_WINDOWBLADE_JUSTCUTTING_REFPICKUP:
           bclr *BitFlags70, #b70_AlternatorField    ; clear bits
           bclr *BitFlags6e, #b6e_InjectorAandB    ; clear bits
           rti                 ; return from interrupt

DIST_SYNC_HASNT_CHANGED_REGULARBLADE_CUT_REFPICKUP:
           ldab Temp6          ; load b with memory contents
           bne  CAM_POSITION_NOT_INSYNC    ; branch if not equal (not zero)
           bset *BitFlags70, #b70_AlternatorField    ; set bits
   LBF7E:  bclr *BitFlags68, #b68_BladePassedSensor    ; clear bits
   LBF81:  bset *BitFlags5E, #$%00000010    ; set bits
           rti                 ; return from interrupt

CAM_POSITION_NOT_INSYNC:
           brclr *BitFlags6e, #b6e_SearchBladeEndRef_INSYNC, LBF91    ; branch if bit(s) clear
           brclr *BitFlags6e, #b6e_InjectorAandB, LBF7E    ; branch if bit(s) clear
DIST_SYNC_WENT_TO_ZERO_WINDOWBLADE_JUSTLEAVING_REFPICKUP:
           brset *BitFlags6e, #b6e_InjectorAandB, ZERO_CAM_POSITION_BITS    ; branch if bit(s) set
   LBF91:  bset *BitFlags6e, #b6e_SearchBladeEndRef_INSYNC    ; set bits
           inc  BitFlags6e 
           bra  SetTCR2ForFallingEdge          ; branch

ZERO_CAM_POSITION_BITS:
           bclr *BitFlags6e, #b6e_InjectorAandB    ; clear bits

SetTCR2ForFallingEdge:
           ldab CPU_TimerControlReg2    ; load b with memory contents
           orab #0x20          ;  -00100000-
           andb #0xef          ;  -11101111-
           stab CPU_TimerControlReg2    ; store b into memory
           
           ldaa TimerOverflowsBetweenDistPulses    ; load a with memory contents
           bne  FORCE_DWELL_TO_ACTIVATE    ; branch if not equal (not zero)
           brclr *BitFlags6d, #b6d_DisableNormalDwell, TachSignalAndClearKnockSensorCap    ; branch if bit(s) clear
FORCE_DWELL_TO_ACTIVATE:
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           anda #0xfe          ; AND a with value -11111110-
           staa CPU_TimerControlReg1
           ldaa #0x08          ; load a with value -00001000-
           staa CPU_HardwareTimerForceCompare
TachSignalAndClearKnockSensorCap:
           ldab PIA3_Buffer    ; load b with memory contents
           andb #~(pi3_KnockCap | pi3_Tach)          ;  -10111101-
           stab PIA3_Buffer    ; store b into memory
           stab PIA3_Buffer_2    ; store b into memory
SETTOLOOKFOR_FALLINGEDGE_NEXTTIME0:
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa #0x5f           ; 3040rpm
           bcs  ContinueRisingInterruptRoutine          ; branch if lower
           ldaa #0x08          ; load a with value -00001000-
           bita CPU_TimerInterruptFlag1
           beq  ContinueRisingInterruptRoutine          ; branch if equal (zero)
           staa CPU_TimerInterruptFlag1
NORMAL_BLADE_JUST_TRIGGERED_INTERRUPT:
           brclr *BitFlags68, #b68_BladePassedSensor, ContinueRisingInterruptRoutine    ; branch if bit(s) clear
           brset *BitFlags70, #b70_AlternatorField, ContinueRisingInterruptRoutine    ; branch if bit(s) set

; here, add code to prevent ouput if spark cut is desired...
           brclr *Turbonator_Flags, #Turbonator_AllowSpark, ContinueRisingInterruptRoutine ; skip the dwell time stuff...

NormalCoilFiring:
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           eora #0x01          ; XOR a with value -00000001-
           staa CPU_TimerControlReg1
           lsra            
           bcc  L1568    ; branch if greater or equal
           ldd  AntiDwellTime_HB    ; load d (a&b) with memory contents
           bra  LBFEF          ; branch

   L1568:  ldd  DistributorFallingEdgePulsewidth_HB    ; load d (a&b) with memory contents
           subd AntiDwellTime_HB    ; d = d - memory contents
   LBFEF:  addd CPU_Timer_OC5_Dwell
           std  CPU_Timer_OC5_Dwell

ContinueRisingInterruptRoutine:
; what happened to the CPU_TimerControlReg2 values from the SMEC code? --> moved to beginning of routine
           inc  AdaptiveCellUpdateTimer_IncrementedEveryDistRisingEdge
           inc  Timer_O2ToggleDuration
           ldaa CPU_A2DResults1    ; load a with memory contents
           brset *BitFlags68, #b68_SparkEngineNotRunning, MAYBE_DO_BAROREADING    ; branch if bit(s) set
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb #0x2e          ;  -00101110-
           bcc  GREATER_THAN_1472RPM    ; branch if greater or equal
           ldab TpsVolts       ; load b with memory contents
           subb MINTHR_LowestSessionTPS    ; b = b-memory contents
           bcs  LC013          ; branch if lower
           cmpb MPLTHR_ThrottleLevelAbove_MINTHR_ToMatureMapLimpin    ; compare b with memory contents (data is 42)
           bcc  GREATER_THAN_1472RPM    ; branch if greater or equal
   LC013:  cmpa MAPHIG_MapSensorUpperLimit    ; compare a with memory contents (data is ee)
           bcc  LC021          ; branch if greater or equal
           cmpa MAPLOW_MapSensorLowerLimit    ; compare a with memory contents (data is 01)
           bcs  LC021          ; branch if lower
GREATER_THAN_1472RPM:
           brclr *b5c_IPL1, #b5c_MapStuck | b5c_MapBadSignal, GET_AVERAGE_MAP_READING    ; branch if bit(s) clear
   LC021:  jsr  SimulateMapReadingFromTps    ; call subroutine
           bra  LC029          ; branch

GET_AVERAGE_MAP_READING:
           adda MapVolts   
           rora            
   LC029:  jsr  ConvertMAPVoltsToValue    ; call subroutine
           staa MapValue       ; store a into memory
           bra  CALC_SPARK_RETARD_BASED_ON_KNOCK_VOLT    ; branch

MAYBE_DO_BAROREADING:
           brclr *BitFlags6d, #b6d_BaroOkEngineStopped, CALC_SPARK_RETARD_BASED_ON_KNOCK_VOLT    ; branch if bit(s) clear
           bclr *BitFlags6d, #b6d_BaroOkEngineStopped    ; clear bits
           jsr  SaveBaroPressure    ; call subroutine
CALC_SPARK_RETARD_BASED_ON_KNOCK_VOLT:
           ldx  #Cylinder2Retard    ; load index with value
           ldab BitFlags6e     ; load b with memory contents
           andb #b6e_InjectorAandB          ;  -00000011-
           eorb #b6e_InjectorB          ;  -00000010-
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
           ldaa RTRDRT_KnockRetardRateNoBoost    ; load a with memory contents (data is 06)
           bcc  SUM_ADDITIONAL_RETARD    ; branch if greater or equal
           bset *BitFlags70, #b70_bit6    ; set bits
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
           ldaa TpsVolts       ; load a with memory contents
           cmpa TpsAverageValue_HB    ; compare a with memory contents
           bcs  THROTTLE_HAS_DECREASED    ; branch if lower
           ldx  #TpsAverageValue_HB    ; load index with value
           jsr  ProcessMapOrTpsBlockData    ; call subroutine
THROTTLE_HAS_DECREASED:
           brset *BitFlags66, #b66_FullThrottle, LC086    ; branch if bit(s) set
           ldaa MapValue       ; load a with memory contents
           cmpa MapAverageValue_HB    ; compare a with memory contents
           bcs  MAP_HAS_DECREASED0    ; branch if lower
   LC086:  ldx  #MapAverageValue_HB    ; load index with value
           jsr  ProcessMapOrTpsBlockData    ; call subroutine
MAP_HAS_DECREASED0:
CheckConditonsToTurnOffInjectors:
           brset *CCDFlags5, #ccd_AlarmDisable, ClearInjectorPW    ; this might be the theft routine shutdown
           brset *BitFlags6d, #b6d_FuelEngineNotRunning, LC0F9    ; branch if bit(s) set
           brset *Turbonator_Flags, #Turbonator_MainFuelOff | Turbonator_FuelOff, LC09E    ; branch if bit(s) set
           brset *BitFlags6b, #$%00001000, LC0AD    ; branch if bit(s) set
           bra  CalculateInjectorPulsewidthForEngineRunning    ; branch

   LC09E:  ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_VNT          ;  -00000001-
           beq  LC0A9          ; branch if equal (zero)
           brset *BitFlags6c, #b6c_VNTOvBst, LC0AD    ; branch if bit(s) set
   LC0A9:  brclr *Turbonator_Flags, #Turbonator_OverRev, ClearInjectorPW    ; branch if bit(s) clear
   LC0AD:  ldaa Counter_FuelEngRunning    ; load a with memory contents
           bne  LC0E2          ; branch if not equal (not zero)
           ldaa EngineRpm_HB    ; load a with memory contents
           suba TargetIdleSpeedHB
           bcc  LC0B8          ; branch if greater or equal
           clra                ; a = 0
   LC0B8:  ldx  #L855C_L855c    ; load index with value
           brclr *BitFlags6b, #$%00001000, LC0C2    ; branch if bit(s) clear
           ldx  #L883E_L883e    ; load index with value
   LC0C2:  ldab CONFIG_ConfigurationFlags    ; load b with memory contents (data is 9f)
           bitb #cfg_VNT          ;  -00000001-
           beq  LC0D0          ; branch if equal (zero)
           brclr *BitFlags6c, #b6c_VNTOvBst, LC0D0    ; branch if bit(s) clear
           ldx  #L8ACE_L8ace    ; load index with value
   LC0D0:  ldab 0x00, X        ; load b with memory at index + value
           inx                 ; increment index (x=x+1)
   LC0D3:  cmpa 0x00, X        ; compare a with memory at index + value
           bcc  LC0DE          ; branch if greater or equal
           inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
           decb
           bne  LC0D3          ; branch if not equal (not zero)
           dex                 ; decrement index (x=x-1)
           dex                 ; decrement index (x=x-1)
   LC0DE:  ldaa 0x01, X        ; load a with memory at index + value
           beq  CalculateInjectorPulsewidthForEngineRunning    ; branch if equal (zero)
   LC0E2:  bita #0x0f          ;  -00001111-
           beq  LC0EB          ; branch if equal (zero)
           deca                ; decrement a
           staa Counter_FuelEngRunning    ; store a into memory
           bra  ClearInjectorPW          ; branch

   LC0EB:  suba #0x10          ;  -00010000-
           staa Counter_FuelEngRunning    ; store a into memory
           bra  CalculateInjectorPulsewidthForEngineRunning    ; branch

ClearInjectorPW:  
           clra                ; a = 0
           clrb                ; b = 0
           stD *BaseInjectorPulsewidth_HB    ; store D to RAM
           stD *InjectorPulsewidth_HB    ; store D to RAM
           bra  StoreInjectorPW          ; branch

   LC0F9:  ldab InjectorLatency    ; load b with memory contents
           clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           stD *Temp5          ; store D to RAM
           ldd  InjectorPulsewidth_HB    ; load d (a&b) with memory contents
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           addd Temp5          ; d = d + memory contents
           bcc  StoreInjectorPW          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-

StoreInjectorPW:
           std  InjectorPulsewidthBank1_HB
           std  InjectorPulsewidthBank2_HB
           std  InjectorPulsewidthBank3_HB
           std  InjectorPulsewidthBank4_HB
           rti                 ; return from interrupt

CalculateInjectorPulsewidthForEngineRunning:
           brset *BitFlags66, #b66_OffIdle, LC124    ; branch if bit(s) set
           ldx  #MAPIDL_FuelBaselineFromMap    ; load index with value
           jsr  Lookup5ByteTable    ; call subroutine
           bra  LC142          ; branch

   LC124:  brclr *BitFlags66, #b66_FullThrottle, LC130    ; branch if bit(s) clear
           ldx  #WOTTBL_FuelFullThrottle    ; load index with value
           jsr  Lookup5ByteTable    ; call subroutine
           bra  LC151          ; branch

   LC130:  ldx  #MAPTBL_FuelPartThrottle    ; load index with value
           jsr  Lookup5ByteTable    ; call subroutine
           stD *Temp5          ; store D to RAM
           ldx  #Temp5         ; load index with value
           ldab Timer_OpenLoopFraction    ; load b with memory contents
           ldaa #0x01          ; load a with value -00000001-
           jsr  ScaleXbyB_addingA_intoD    ; call subroutine
   LC142:  stD *Temp5          ; store D to RAM
           ldx  #WOTTBL_FuelFullThrottle    ; load index with value
           jsr  Lookup5ByteTable    ; call subroutine
           cmpD Temp5          ; compare D
           bls  LC151          ; branch if lower or same
           ldd  Temp5          ; load d (a&b) with memory contents
   LC151:  addd SparkScatterFuelstabilizationValue_HB    ; d = d + memory contents
           bpl  IncludePWModifiers_CheckForOverflow    ; branch if plus (hi bit 0)
           ldd  Pulsewidth_PartThrottleEnrichment_HB    ; load d (a&b) with memory contents
           addd Pulsewidth_AISEnrichment_HB    ; d = d + memory contents
           bra  HandleTransitionFromStartToRun    ; branch

IncludePWModifiers_CheckForOverflow:
           staa Temp7          ; store a into memory
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
           ldd  #0xFFFF         ; load d (a&b) with value -11111111 11111111-
HandleTransitionFromStartToRun:
           brclr *BitFlags6d, #b6d_Starting, IncludeInjectorLatency    ; branch if bit(s) clear
           stD *Temp5          ; store D to RAM
           ldd  InjectorPulsewidth_HB    ; load d (a&b) with memory contents
           suba Factor_StartFuelDecayIntoRunFuel
           bls  TransitionFromStartToRunComplete    ; branch if lower or same
           cmpa Temp5          ; compare a with memory contents
           bhi  IncludeInjectorLatency    ; branch if higher
TransitionFromStartToRunComplete:
           ldd  Temp5          ; load d (a&b) with memory contents
           bclr *BitFlags6d, #b6d_Starting    ; clear bits
IncludeInjectorLatency:
           jsr  NULL_ROUTINE    ; call subroutine
           stD *InjectorPulsewidth_HB    ; store D to RAM
           ldab InjectorLatency    ; load b with memory contents
           clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd InjectorPulsewidth_HB    ; d = d + memory contents
           bcc  LC1B2          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LC1B2:  stD *BaseInjectorPulsewidth_HB    ; store D to RAM
           clra                ; a = 0
           staa Temp5          ; store a into memory
           staa Temp6          ; store a into memory
           ldab BitFlags6e     ; load b with memory contents
           andb #b6e_InjectorAandB          ;  -00000011-
           ldx  #LBECB         ; load index with value
           abx                 ; add b to index
           ldab 0x00, X        ; load b with memory at index + value
           ldx  #InjectorPulsewidthBank1_HB    ; load index with value
           abx                 ; add b to index
           ldaa CoolantTemp    ; load a with memory contents
           cmpa CSFERT_MinTempForColdStartFuelEnrichment    ; compare a with memory contents (data is 58)
           bcs  LC221          ; branch if lower
           brset *BitFlags66, #b66_OffIdle, LC221    ; branch if bit(s) set
           brclr *BitFlags67, #b67_FallToIdle, LC1DD    ; branch if bit(s) clear
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_CSEnrich          ;  -00010000-
           beq  LC221          ; branch if equal (zero)
   LC1DD:  brset *BitFlags70, #b70_bit7, LC1F2    ; branch if bit(s) set
           ldd  KeyOnOrEngineRunningTime    ; load d (a&b) with memory contents
           cmpD #0x000c        ; compare D -00000000 00001100-
           bcs  LC1EF          ; branch if lower
           ldaa CSFERX_NumLoopsForColdStartFuelEnrich    ; load a with memory contents (data is 04)
           staa ColdStartFuelReduxCounter
   LC1EF:  bset *BitFlags70, #b70_bit7    ; set bits
   LC1F2:  ldaa ColdStartFuelReduxCounter    ; load a with memory contents
           beq  LC236          ; branch if equal (zero)
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
           pulb                ; pull b from stack
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
           bra  LC236          ; branch

   LC221:  bclr *BitFlags70, #b70_bit7    ; clear bits
           ldd  BaseInjectorPulsewidth_HB    ; load d (a&b) with memory contents
           std  0x00, X        ; store d into index plus offset
           cmpD MNPWDS_MinimumInjPWForDistSync    ; compare D -00000000 01111101-
           bls  LC236          ; branch if lower or same
           bset *BitFlags6e, #b6e_DistSync    ; set bits
           ldaa #0x04          ; load a with value -00000100-
           staa PIA_Ctrl_4 
   LC236:  ldd  InjectorPulsewidth_HB    ; load d (a&b) with memory contents
           addd Temp5          ; d = d + memory contents
           subd FLWMNC_FuelMonitorCorrection    ;  (data is 0000)
           bcc  LC241          ; branch if greater or equal
           clra                ; a = 0
           clrb                ; b = 0
   LC241:  lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           ; try to correct the fuel monitor output
           lsrd
           ldab FLMNC2_FuelMonitorCorrection2 ;temp name - base value is 0x80 for stock injectors, scaled with injectors
           mul
           lsld
           ; end correction code
           addd CCDFuelOutput_HB    ; d = d + memory contents
           bcc  LC24A          ; branch if greater or equal
           ldd  #0xFFFF         ; load d (a&b) with value -11111111 11111111-
   LC24A:  stD *CCDFuelOutput_HB    ; store D to RAM
           ldd  Pulsewidth_AISEnrichment_HB    ; load d (a&b) with memory contents
           subd MINPTE_MinPWForPartThorttleEnrich    ;  (data is 0004)
           bcc  LC255          ; branch if greater or equal
           clra                ; a = 0
           clrb                ; b = 0
   LC255:  stD *Pulsewidth_AISEnrichment_HB    ; store D to RAM
           rti                 ; return from interrupt

;.org 0xc258
Lookup5ByteTable:
           ldab #0x05          ; load b with value -00000101-
           ldaa MapValue       ; load a with memory contents
           cmpa 0x00, X        ; compare a with memory at index + value
           bhi  LC265          ; branch if higher
           ldd  0x01, X    
           bra  LC275          ; branch

   LC264:  abx                 ; add b to index
   LC265:  cmpa 0x05, X        ; compare a with memory at index + value
           bhi  LC264          ; branch if higher
           suba 0x00, X    
           ldY 0x03, X        ; load Y indexed to X -00000011-
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           addd 0x01, X    
   LC275:  pshb                ; push b onto stack
           psha                ; push a onto stack
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_VNT          ;  -00000001-
           beq  LC2A8          ; branch if equal (zero)
           brclr *BitFlags69, #b69_AcClutch, LC2A8    ; branch if bit(s) clear
           ldab CoolantTemp    ; load b with memory contents
           cmpb VOBCT_VNTOverboostSampleCounterCoolantTemp    ; compare b with memory contents (data is 58)
           bcs  LC2A8          ; branch if lower
           brclr *BitFlags6c, #b6c_VNTOvBst, LC291    ; branch if bit(s) clear
           bita #0x04          ;  -00000100-
           bne  LC2A8          ; branch if not equal (not zero)
   LC291:  ldaa EngineRpm_HB    ; load a with memory contents
           ldx  #VOBRPX_VNTOverboostFuelAddedFromRPMWhenOverboosting    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           puly                ; pop Y from stack
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           asld                ; shift left (d=d*2)
           bcc  LC2AA          ; branch if greater or equal
           ldd  #0xFFFF         ; load d (a&b) with value -11111111 11111111-
           bra  LC2AA          ; branch

   LC2A8:  pula                ; pull a from stack
           pulb                ; pull b from stack
   LC2AA:  rts                 ; return from subroutine

FALLING_EDGE_INTERRUPT:
           ldaa Counter_TimerPastHalfwayBetweenDistPulses    ; load a with memory contents
           lsra            
           staa TimerOverflowsBetweenDistPulses    ; store a into memory
           ldd  CPU_DistPickupCaptureRegHigh
           subd LastDistributorFallingEdgeTime    ; d = d - memory contents
           stD *DistributorFallingEdgePulsewidth_HB    ; store D to RAM
           ldd  CPU_DistPickupCaptureRegHigh
           stD *LastDistributorFallingEdgeTime    ; store D to RAM
           clra                ; a = 0
           staa Counter_TimerPastHalfwayBetweenDistPulses    ; store a into memory
           ldaa CPU_TimerControlReg2    ; load a with memory contents
           oraa #0x10          ;  -00010000-
           anda #0xdf          ; AND a with value -11011111-
           staa CPU_TimerControlReg2
           brset *BitFlags70, #b70_AlternatorField, LC2D1    ; branch if bit(s) set
           brset *BitFlags68, #b68_BladePassedSensor, LC2D2    ; branch if bit(s) set
   LC2D1:  rti                 ; return from interrupt

   LC2D2:  ldab PIA3_Buffer    ; load b with memory contents
           orab #pi3_Tach          ;  -00000010-
           stab PIA3_Buffer    ; store b into memory
           stab PIA3_Buffer_2    ; store b into memory
           brclr *BitFlags70, #b70_bit7, LC2FF    ; branch if bit(s) clear
           ldab BitFlags6e     ; load b with memory contents
           andb #b6e_InjectorAandB          ;  -00000011-
           ldx  #LBECB         ; load index with value
           abx                 ; add b to index
           ldab 0x00, X        ; load b with memory at index + value
           ldx  #InjectorPulsewidthBank1_HB    ; load index with value
           abx                 ; add b to index
           ldd  BaseInjectorPulsewidth_HB    ; load d (a&b) with memory contents
           std  0x00, X        ; store d into index plus offset
           cmpD MNPWDS_MinimumInjPWForDistSync    ; compare D -00000000 01111101-
           bls  LC2FF          ; branch if lower or same
           bset *BitFlags6e, #b6e_DistSync    ; set bits
           ldaa #0x04          ; load a with value -00000100-
           staa PIA_Ctrl_4 
   LC2FF:  ldaa Counter_EPP_MaxFF    ; load a with memory contents
           inca                ; increment a
           beq  LC306          ; branch if equal (zero)
           staa Counter_EPP_MaxFF    ; store a into memory
   LC306:  ldab Counter_FallingEdgeEPP_MaxFF    ; load b with memory contents
           asld                ; shift left (d=d*2)
           addb #0x02          ;  -00000010-
           bcs  LC310          ; branch if lower
           lsrd                ; shift right (d=d/2)
           stab Counter_FallingEdgeEPP_MaxFF    ; store b into memory
   LC310:  clra                ; a = 0
           ldab TimerOverflowsBetweenDistPulses    ; load b with memory contents
           beq  HandleFuelStartRunStartTransfer    ; branch if equal (zero)
           bset *BitFlags6d, #b6d_FuelEngineNotRunning | b6d_Starting | b6d_DisableNormalDwell    ; set bits
           staa Timer_NormalDwell    ; store a into memory
           bra  IncludeDwellTime          ; branch

HandleFuelStartRunStartTransfer:
           ldab DistributorFallingEdgePulsewidth_HB    ; load b with memory contents
           cmpb RNFPRD_FuelStartRunTransferPointRpm    ; compare b with memory contents (data is 60)
           bcc  RpmBelowStartRunTransfer    ; branch if greater or equal
           brclr *BitFlags6d, #b6d_FuelEngineNotRunning, LC347    ; branch if bit(s) clear
           bclr *BitFlags6d, #b6d_FuelEngineNotRunning | b6d_JustStarted    ; clear bits
           staa KeyOnOrEngineRunningTime    ; store a into memory
           staa Counter_MainLoop    ; store a into memory
           ldaa AISDLY_DelayFromStartRunThatAisFeedbackDisabled    ; load a with memory contents (data is 5d)
           staa Timer_CountdownFromStartRunForAisFeedback    ; store a into memory
           ldaa AdaptiveRetardIndex    ; load a with memory contents
           suba ARSUBC_AdaptiveRetardFactorSubtract    ;  (data is 40)
           bcc  LC33B          ; branch if greater or equal
           clra                ; a = 0
   LC33B:  staa AdaptiveRetardIndex    ; store a into memory
           bra  LC347          ; branch

RpmBelowStartRunTransfer:
           cmpb STFPRD_FuelRunStartTransferPointRpm    ; compare b with memory contents (data is 82)
           bcs  LC347          ; branch if lower
           bset *BitFlags6d, #b6d_FuelEngineNotRunning | b6d_Starting    ; set bits
   LC347:  ldaa #0xff          ; load a with value -11111111-
           cmpb SKAPRD_SparkImmediateSwitchToRunAboveThisRpm    ; compare b with memory contents (data is 48)
           bcs  ENGINE_IDLING_FASTERTHAN_813RPM    ; branch if lower
           cmpb STRNTR_SparkStartRunTransferPointRpm    ; compare b with memory contents (data is 62)
           bcs  ENGINE_IDLING_BETWEEN598_813RPM    ; branch if lower
           brclr *BitFlags6d, #b6d_DisableNormalDwell, LC35A    ; branch if bit(s) clear
           clra                ; a = 0
           staa Timer_NormalDwell    ; store a into memory
   LC35A:  cmpb RNSTTR_SparkRunStartTransferPointRpm    ; compare b with memory contents (data is 8e)
           bcs  IncludeDwellTime          ; branch if lower
           bset *BitFlags6d, #b6d_DisableNormalDwell    ; set bits
           bra  IncludeDwellTime          ; branch

ENGINE_IDLING_BETWEEN598_813RPM:
           ldaa Timer_NormalDwell    ; load a with memory contents
           inca                ; increment a
           beq  LC37A          ; branch if equal (zero)
ENGINE_IDLING_FASTERTHAN_813RPM:
           staa Timer_NormalDwell    ; store a into memory
           ldx  #SRTIME_SparkEPPsNeededToBeAboveSR_Hot    ; load index with value
           ldab SRTMTP_SparkTempSwitchPointFor_SRTIME    ; load b with memory contents (data is b0)
           cmpb CoolantTemp
           bcs  SetForRisingEdge_AndIncludeDwell    ; branch if lower
           inx                 ; increment index (x=x+1)
SetForRisingEdge_AndIncludeDwell:
           cmpa 0x00, X        ; compare a with memory at index + value
           bcs  IncludeDwellTime          ; branch if lower
   LC37A:  bclr *BitFlags6d, #b6d_DisableNormalDwell    ; clear bits

;dwell time calulation from the SBECII code
IncludeDwellTime:
           subd  DwellTime_HB
           bls   UseMaxDwell         ; branch if lower or same
           cpd   MINADW_MinAntiDwellPeriod
           bcc   StoreAntiDwell         ; branch if greater or equal
UseMaxDwell:
           ldd   MINADW_MinAntiDwellPeriod
StoreAntiDwell:
           std   AntiDwellTime_HB    ; store D (A&B) into memory

           brset *BitFlags68, #b68_SparkEngineNotRunning, LC3FE    ; branch if bit(s) set
           ldab CPU_A2DResults1    ; load b with memory contents
           stab MapVolts       ; store b into memory
           ldaa BitFlags608D    ; load a with memory contents
           anda #0x0f          ; AND a with value -00001111-
           inca                ; increment a
           cmpa MPDELX_DeltaMapThatChecksGoodX    ; compare a with memory contents (data is 02)
           bcc  LC3C9          ; branch if greater or equal
           inc  BitFlags608D
           jmp  LC45B


	;.org	0xc3a9
LC3A9:
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
   LC3C9:  ldx  #BitFlags608D    ; load index with value
           bclr  0, X, #$%00001111    ; bit clear
           ldaa MapValue_X     ; load a with memory contents
           suba MapVolts_X 
           stab MapValue_X     ; store b into memory
           stab MapVolts_X     ; store b into memory
           brset *b5c_IPL1, #b5c_MapStuck, LC400    ; branch if bit(s) set
           cmpa MPDELT_DeltaMapThatChecksGood    ; compare a with memory contents (data is 01)
           bcc  LC455          ; branch if greater or equal
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           cmpD MPRPML_DisableMapCheckUnderThisRpm_600    ; compare D (data is 12)
           bcs  LC45B          ; branch if lower
           cmpD MPRPMH_DisableMapCheckAboveThisRpm_1500    ; compare D (data is 2e)
           bcc  LC45B          ; branch if greater or equal
           ldaa MapVolts       ; load a with memory contents
           cmpa MPDAGL_DisableMapCheckBelowThisMap    ; compare a with memory contents (data is 10)
           bcs  LC45B          ; branch if lower
           cmpa MPDAGH_DisableMapCheckAboveThisMap    ; compare a with memory contents (data is 81)
           bcs  LC424          ; branch if lower
   LC3FE:  bra  LC45B          ; branch

   LC400:  suba MPDELT_DeltaMapThatChecksGood    ;  (data is 01)
           bcs  LC455          ; branch if lower
           cmpa MPDELA_MatureMapLimpinWhenDeltaAbove_MPDELT_plus_MPDELA    ; compare a with memory contents (data is 01)
           bcs  LC455          ; branch if lower
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           cmpD #0x0040    ; compare D -00000000 01000000-
           bcc  LC424          ; branch if greater or equal
           brset *BitFlags66, #b66_OffIdle, LC424    ; branch if bit(s) set
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  LC41E          ; branch if greater or equal
           coma            
           comb            
   LC41E:  cmpD MPRMPD_CheckMapAtZeroSpeedAndThisDeltaRpm    ; compare D (data is 02)
           bcs  LC455          ; branch if lower
   LC424:  ldab BitFlags608D    ; load b with memory contents
           addb #0x10          ;  -00010000-
           bcc  LC42D          ; branch if greater or equal
           orab #0xf0          ;  -11110000-
   LC42D:  stab BitFlags608D    ; store b into memory
           ldab MPDELX_DeltaMapThatChecksGoodX    ; load b with memory contents (data is 02)
           ldx  #LC3A9         ; load index with value
           abx                 ; add b to index
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa #0x20          ; compare a with value -00100000-
           bls  LC440          ; branch if lower or same
           ldab #0x10          ; load b with value -00010000-
           abx                 ; add b to index
   LC440:  ldaa 0x00, X        ; load a with memory at index + value
           cmpa BitFlags608D    ; compare a with memory contents
           bcc  LC45B          ; branch if greater or equal
           brset *b5c_IPL1, #b5c_MapStuck, LC450    ; branch if bit(s) set
           bset *BitFlags5E, #$%10000000    ; set bits
           bra  LC455          ; branch

   LC450:  ldaa #0x08          ; load a with value -00001000-
           jsr  ResetErrorCodeIfTimerExpired    ; call subroutine
   LC455:  ldx  #BitFlags608D    ; load index with value
           bclr  0, X, #$%11110000    ; bit clear
   LC45B:  ldaa TimerOverflowsBetweenDistPulses    ; load a with memory contents
           bne  SetupDwellToClearWhenTimeMatches    ; branch if not equal (not zero)
           brclr *BitFlags6d, #b6d_DisableNormalDwell, ReadKnockSensorAndRecalcSparkPosition    ; branch if bit(s) clear
SetupDwellToClearWhenTimeMatches:
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           oraa #0x03          ;  -00000011-
           staa CPU_TimerControlReg1
           clra                ; a = 0
           staa KnockVolts     ; store a into memory
           jmp  ForceDwellOutputChange      

ReadKnockSensorAndRecalcSparkPosition:
           ldaa #0x06          ; load a with value -00000110-
           staa CPU_A2DControlReg
           ldx  #Cylinder2Retard    ; load index with value
           ldab BitFlags6e     ; load b with memory contents
           andb #b6e_InjectorAandB          ;  -00000011-
           abx                 ; add b to index
           ldaa CalculatedSparkAdvance    ; load a with memory contents
           suba 0x00, X    
           bcc  LC485          ; branch if greater or equal
           clra                ; a = 0
   LC485:  staa Temp5          ; store a into memory
           bclr *BitFlags6e, #b6e_UseSparkScatter    ; clear bits
           jsr  HandleSparkScatter    ; call subroutine
           ldaa #0x10          ; load a with value -00010000-
           ldab CPU_A2DResults1    ; load b with memory contents
           staa CPU_A2DControlReg
           stab KnockVolts     ; store b into memory
           ldaa Temp5          ; load a with memory contents
           jsr  NULL_ROUTINE    ; call subroutine
           staa Temp5          ; store a into memory
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_VNT          ;  -00000001-
           beq  LC4B9          ; branch if equal (zero)
           brclr *BitFlags69, #b69_AcClutch, LC4B9    ; branch if bit(s) clear
           ldaa EngineRpm_HB    ; load a with memory contents
           ldx  #ADRMRP_AdvanceRemovedFromRPMForDwellCalculation    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp5          ; load a with memory contents
           sba                 ; subtract (a=a-b)
           bcc  LC4B7          ; branch if greater or equal
           clra                ; a = 0
   LC4B7:  staa Temp5          ; store a into memory

;code added for anti-lag/sparkcut
   LC4B9:  ldaa Temp5	    ; load a with memory contents

IncludeAntiLag:
           ; re-routed this jump to use the anti-lag lookup value
           jsr  CalculateSparkCutandAntiLagRetard_Routine    ; call subroutine
           staa Temp5	    ; store a into memory
           staa FinalAdvanceActual

           ldaa #0xa6          ; 0xa6 = 83deg - this is the angle between the rising edge and falling edge; falling edge should be at TDC;
           suba Temp5          ; temp5 contains the total advance - cyl#retard
           ldab #0xb6          ; 71% is the conversion from degrees to percent - 64/90 = 0.711
           mul                 ; multiply (d=a*b)
           adca #0x00          ; A now contains the position in scaled degrees from the current edge to ignition firing
           ldY DistributorFallingEdgePulsewidth_HB    ; load Y index
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; D now contains the position in time degrees from the current edge to ignition firing
           addd LastDistributorFallingEdgeTime    ; d = d + memory contents
           stD *Temp6          ; Temp6/D now contain the position in time degrees from the current system time to ignition firing
           addd AntiDwellTime_HB    ; add the anti-dwell time
           subd DistributorFallingEdgePulsewidth_HB    ; subtract the FE PW to get the system time to power the coil 'ON' (DwellStart)
           std  CPU_Timer_OC5_Dwell

; here, add code to prevent ouput if spark cut is desired... - set bits and jump...
           brclr *Turbonator_Flags, #Turbonator_AllowSpark, NormalCoilOffTimeLoad ; skip TCR1 stuff if spark is off
;original stock code below...

NormalCoilOnTimeLoad:
           ldab CPU_TimerControlReg1    ; load b with memory contents
           orab #0x03          ;  -00000011-
           stab CPU_TimerControlReg1    ; store b into memory
           ldx  DistributorFallingEdgePulsewidth_HB
           cpx  #0x7800        ; ~977rpm
           bcc  SetBitToClearKnockCap          ; branch if greater or equal
; special dwell time setup for low RPM only...
           ldd  CPU_Timer_OC5_Dwell
           subd #0x0084    ; 64uS
           subd CPU_TimerCounterRegHigh
           bpl  SetBitToClearKnockCap          ; branch if plus (hi bit 0)
           ldaa #0x08          ; load a with value -00001000-
           staa CPU_HardwareTimerForceCompare
           ldd  Temp6          ; load d (a&b) with memory contents
           std  CPU_Timer_OC5_Dwell
           ldaa #0x08          ; load a with value -00001000-
           staa CPU_TimerInterruptFlag1

NormalCoilOffTimeLoad:
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           anda #0xfe          ; AND a with value -11111110-
           staa CPU_TimerControlReg1

           ; not sure if this will help or not, seems to work as-is
           brclr *Turbonator_Flags, #Turbonator_AllowSpark, ForceDwellOutputChange ; ensure coil is off if cutting spark

           ldd  CPU_Timer_OC5_Dwell
           subd CPU_TimerCounterRegHigh
           bpl  SetBitToClearKnockCap          ; branch if plus (hi bit 0)

ForceDwellOutputChange:
           ldaa #0x08          ; load a with value -00001000-
           staa CPU_HardwareTimerForceCompare

SetBitToClearKnockCap:
           ldab PIA3_Buffer    ; load b with memory contents
           orab #pi3_KnockCap          ;  -01000000-
           stab PIA3_Buffer    ; store b into memory
           stab PIA3_Buffer_2    ; store b into memory
;            ldaa FDRVar0        ; load a with memory contents
;            bita #0x01          ;  -00000001-
;            beq  LC533          ; branch if equal (zero)
;            bita #0x08          ;  -00001000-
;            beq  LC533          ; branch if equal (zero)
;            ldx  FDRVar3
;            ldab FDRVar2        ; load b with memory contents
;            jsr  FDRSerialIORoutine    ; call subroutine
;            cmpa #0xfc          ; compare a with value -11111100-
;            bne  LC533          ; branch if not equal (not zero)
;            staa FDRVar0        ; store a into memory
   LC533:  rti                 ; return from interrupt

Interrupt_RealTime:
           ldab #0x01          ; load b with value -00000001-
           bra  LC552          ; branch

Interrupt_XIRQ:
           ldab #0x02          ; load b with value -00000010-
           bra  LC552          ; branch

Interrupt_COPFail:
           ldab #0x04          ; load b with value -00000100-
           bra  LC552          ; branch

Interrupt_ClockMonFail:
           ldab #0x08          ; load b with value -00001000-
           bra  LC552          ; branch

Interrupt_BadOp:
           ldab #0x10          ; load b with value -00010000-
           bra  LC552          ; branch

Interrupt_Software:
           ldab #0x20          ; load b with value -00100000-
           bra  LC552          ; branch

Interrupt_PulseAccumulatorInputEdge:
           ldab #0x40          ; load b with value -01000000-
           bra  LC552          ; branch

Interrupt_PIA_Signal:
           ldab #0x80          ; load b with value -10000000-
   LC552:  stab Temp0          ; store b into memory
           orab L0000      
           stab L0000          ; store b into memory
           tsx                 ; transfer stack to index (x=sp+1)
           ldd  0x07, X    
           stD *L0001          ; store D to RAM
           stD *Temp1          ; store D to RAM
           sei                 ; disable interrupts
           lds  #TopOfStack        ;  -01100000 11111111-
           ldd  #0xb978        ; load d (a&b) with value -10111001 01111000-
           staa CPU_SysConfigOptionReg
           stab CPU_HighPriorityInterruptMask    ; store b into memory
           ldd  #0x0001         ; load d (a&b) with value -00000000 00000001-
           staa CPU_PortA_Control
           stab CPU_TimerInterruptMask2    ; store b into memory
           clra                ; a = 0
           staa CPU_OutputCompare1Mask
           ldd  #0x2a18        ; load d (a&b) with value -00101010 00011000-
           staa CPU_TimerControlReg1
           stab CPU_TimerControlReg2    ; store b into memory
           ldaa #0x78          ; load a with value -01111000-
           staa CPU_HardwareTimerForceCompare
           ldab #0x02          ; load b with value -00000010-
           stab BitFlags_AIS    ; store b into memory
           ldd  L0003          ; load d (a&b) with memory contents
           stD *Temp3          ; store D to RAM
           ldd  #0xaaa5        ; load d (a&b) with value -10101010 10100101-
           cmpD L0003          ; compare D
           beq  LC5B6          ; branch if equal (zero)
           decb            
           stab Temp4          ; store b into memory
           bra  LC5B6          ; branch

Interrupt_RealTime_X:
           sei                 ; disable interrupts
           lds  #TopOfStack        ;  -01100000 11111111-
           clra                ; a = 0
           clrb                ; b = 0
           staa Temp0          ; store a into memory
           stD *Temp1          ; store D to RAM
           jsr  CountRamValuesFrom05to38    ; call subroutine
           ldx  #0xaaa5        ; load index with value
           cmpD L0003          ; compare D
           beq  LC5B4          ; branch if equal (zero)
           ldx  #0x0000         ; load index with value
   LC5B4:  stx  Temp3          ; store index into memory
   LC5B6:  ldd  #0x00f8         ; load d (a&b) with value -00000000 11111000-
           staa PIA_Ctrl_2 
           stab PIA_Ctrl_5     ; store b into memory
           clra                ; a = 0
           clrb                ; b = 0
           std  InjectorPulsewidthBank1_HB
           std  InjectorPulsewidthBank2_HB
           std  InjectorPulsewidthBank3_HB
           std  InjectorPulsewidthBank4_HB
           ldaa #0x74          ; load a with value -01110100-
           staa PIA3_Buffer_2
           ldaa #0x20          ; load a with value -00100000-
           staa CPU_PortD  
           ldd  #0x3a54        ; load d (a&b) with value -00111010 01010100-
           staa CPU_PortD_DataDirection
           ldaa CPU_SerialPeripheralStatus    ; load a with memory contents
           stab CPU_SerialPeripheralControl    ; store b into memory
           bset *BitFlags6e, #b6e_PIAKeepIntEnabled    ; set bits
           ldaa #0x70          ; load a with value -01110000-
           ldab #0xff          ; load b with value -11111111-
           jsr  SetPIAOutputBits    ; call subroutine
           ldaa #0x50          ; load a with value -01010000-
           ldab #0xff          ; load b with value -11111111-
           jsr  SetPIAOutputBits    ; call subroutine
           jsr  OCToggleAndResetCopTimer    ; call subroutine
           ldaa #0xc8          ; load a with value -11001000-
   LC5F9:  deca                ; decrement a
           bne  LC5F9          ; branch if not equal (not zero)
           jsr  OCToggleAndResetCopTimer    ; call subroutine
           bclr *BitFlags_AIS, #b10_UseAIS | b10_bit4 | b10_ATXInGear | b10_ATXChngGear    ; clear bits
           ldd  Temp3          ; load d (a&b) with memory contents
           stD *L0003          ; store D to RAM
           ldx  #0x0038        ; load index with value
           ldd  L0003          ; load d (a&b) with memory contents
           cmpD #0xaaa5        ; compare D -10101010 10100101-
           beq  LC63F          ; branch if equal (zero)
           ldaa Temp0          ; load a with memory contents
           staa L0000          ; store a into memory
           ldd  Temp1          ; load d (a&b) with memory contents
           stD *L0001          ; store D to RAM
           ldaa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load a with memory contents (data is 5c)
           staa MINTHR_LowestSessionTPS    ; store a into memory
           bset *BitFlags_AIS, #b10_UseAIS    ; set bits
           ldab #0xdf          ; load b with value -11011111-
           stab CurrentAisPosition    ; store b into memory
           ldaa #0x80          ; load a with value -10000000-
           staa Timer_DacalCountdown    ; store a into memory
           staa DCCOR1_AdaptiveWastegateCellBelowMAPPT    ; store a into memory
           staa DCCOR2_AdaptiveWastegateCellTo4000rpm    ; store a into memory
           staa DCCOR3_AdaptiveWastegateCellTo4992rpm    ; store a into memory
           staa DCCOR4_AdaptiveWastegateCellTo5504rpm    ; store a into memory
           staa DCCOR5_AdaptiveWastegateCellAbove5504rpm    ; store a into memory
           staa DCCOR6_AdaptiveVNTCell1    ; store a into memory
           staa DCCOR7_AdaptiveVNTCell2    ; store a into memory
           staa DCCOR0_AdaptiveVNTCell0    ; store a into memory
           jsr  DRB_ClearErrorCodes    ; call subroutine
           ldx  #AutoCalCell0    ; load index with value
   LC63F:  clrb                ; b = 0
           stab CPU_A2DControlReg    ; store b into memory
ZeroRamFrom11toFE:
           stab 0x00, X    
           inx                 ; increment index (x=x+1)
           cpx  #0x00FF        ;  -00000000 11111111-
           bls  ZeroRamFrom11toFE    ; branch if lower or same
           tsx                 ; transfer stack to index (x=sp+1)
ZeroMemFromFFFFto6080:
           dex                 ; decrement index (x=x-1)
           stab 0x00, X
           cpx  #0x6080        ;  -01100000 10000000-
           bhi  ZeroMemFromFFFFto6080          ; branch if higher
           ldaa CPU_A2DResults1    ; load a with memory contents
           ldab #0x14          ; load b with value -00010100-
           stab CPU_A2DControlReg    ; store b into memory
           staa MapVolts       ; store a into memory
           jsr  SaveBaroPressure    ; call subroutine
           staa MapValue       ; store a into memory
           staa MapAverageValue_HB    ; store a into memory
           ldaa #0xf0          ; load a with value -11110000-
           ldab #0xff          ; load b with value -11111111-
           bset *BitFlags6e, #b6e_PIAKeepIntEnabled    ; set bits
           jsr  SetPIAOutputBits    ; call subroutine
           ldaa #0xd0          ; load a with value -11010000-
           ldab #0xff          ; load b with value -11111111-
           jsr  SetPIAOutputBits    ; call subroutine
           ldaa #0x00          ; load a with value -00000000-
           ldab #0xff          ; load b with value -11111111-
           jsr  SetPIAOutputBits    ; call subroutine
           stab StartupSwitchMirror2    ; store b into memory
           stab StartupSwitchMirror1    ; store b into memory
           ldaa #0xbc          ; load a with value -10111100-
           ldab #0x0f          ; load b with value -00001111-
           jsr  SetPIAOutputBits    ; call subroutine

           bset *Turbonator_Flags, #Turbonator_AllowSpark  ; to allow spark by default
           clr  Counter_SparkCut
           ldaa #bit_all
           staa Pattern_SparkCut

           ldd  #0x0c22        ; load d (a&b) with value -00001100 00100010-
           staa CPU_SerialControlReg2
           stab CPU_SerialBaudRate    ; store b into memory
           clra                ; a = 0
           staa CPU_SerialControlReg1
           jsr  OCToggleAndResetCopTimer    ; call subroutine
           ldaa #0x74          ; load a with value -01110100-
           staa PIA3_Buffer    ; store a into memory
           ldd  CPU_A2DResults1
           cmpa #0x40          ; compare a with value -01000000-
           bcc  LC6A6          ; branch if greater or equal
           bclr *PIA3_Buffer, #pi3_CoolantTemp    ; clear bits
   LC6A6:  cmpb #0x40          ;  -01000000-
           bcc  LC6AD          ; branch if greater or equal
           bclr *PIA3_Buffer, #pi3_ChargeTemp    ; clear bits
   LC6AD:  ldaa PIA3_Buffer    ; load a with memory contents
           staa PIA3_Buffer_2
           ldaa #0x14          ; load a with value -00010100-
           staa CPU_A2DControlReg
           ldab BitFlags_36    ; load b with memory contents
           andb #0x03          ;  -00000011-
           ldx  #AISTEP_BitPatternForAisControl    ; load index with value
           abx                 ; add b to index
           ldab 0x00, X        ; load b with memory at index + value
           ldaa #0x90          ; load a with value -10010000-
           jsr  SetPIAOutputBits    ; call subroutine
           jsr  OCToggleAndResetCopTimer    ; call subroutine
           bset *BitFlags_AIS, #b10_bit7 | b10_bit6    ; set bits
           ldaa #0xbe          ; load a with value -10111110-
           ldab CONFIG_ConfigurationFlags    ; load b with memory contents (data is 9f)
           bitb #cfg_VNT          ;  -00000001-
           bne  LC6D7          ; branch if not equal (not zero)
           ldaa #0xae          ; load a with value -10101110-
   LC6D7:  staa CPU_TimerInterruptMask1
           ldab #0xff          ; load b with value -11111111-
           stab CPU_TimerInterruptFlag1    ; store b into memory
           stab Counter_TimerPastHalfwayBetweenDistPulses    ; store b into memory
           stab TimerOverflowsBetweenDistPulses    ; store b into memory
           stab Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; store b into memory
           stab TimerOverflowsBetweenSpeedoPulses    ; store b into memory
           stab Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached    ; store b into memory
           bset *CruiseStatus_1, #$%10100000    ; set bits
           ldaa #0x80          ; load a with value -10000000-
           staa Counter_Cruise_1    ; store a into memory
           bset *BitFlags6c, #b6c_bit1    ; set bits
           ldaa LB616          ; load a with memory contents (data is ff)
           cmpa #0x4a          ; compare a with value -01001010-
           bne  LC700          ; branch if not equal (not zero)
           coma            
           cmpa LB615          ; compare a with memory contents (data is ff)
           beq  LC703          ; branch if equal (zero)
   LC700:  bclr *BitFlags6c, #b6c_bit1    ; clear bits
   LC703:  bclr *BitFlags6c, #b6c_bit3 | b6c_bit2    ; clear bits
           ldaa L0004          ; load a with memory contents
           cmpa #0xa4          ; compare a with value -10100100-
           beq  LC715          ; branch if equal (zero)
           ldaa BitFlags_AIS    ; load a with memory contents
           tab                 ; b = a
           andb #b10_bit1 | b10_bit0          ;  -00000011-
           cmpb #b10_bit1          ;  -00000010-
           bne  SetupSystemAndGoToMainLoop    ; branch if not equal (not zero)
   LC715:  ldd  #0x0aff        ; load d (a&b) with value -00001010 11111111-
           staa DRBPointer1    ; store a into memory
           stab DRBPointer2    ; store b into memory
           ldd  #0xf1ff        ; load d (a&b) with value -11110001 11111111-
           staa LastDistributorFallingEdgeTime    ; store a into memory
           bra  LC728          ; branch

SetupSystemAndGoToMainLoop:
           inca                ; increment a
           staa BitFlags_AIS    ; store a into memory
           ldab #0xef          ; load b with value -11101111-
   LC728:  ldaa #0x50          ; load a with value -01010000-
           jsr  SetPIAOutputBits    ; call subroutine
           ldaa #0x03          ; load a with value -00000011-
           staa Timer_DelayBeforeUpdating_MINTHR    ; store a into memory
           ldd  #0x0c28        ; load d (a&b) with value -00001100 00101000-
           staa BitFlags66     ; store a into memory
           ldaa CPU_PortA      ; load a with memory contents
           bita #0x04          ;  -00000100-
           bne  LC73F          ; branch if not equal (not zero)
           ldab #0x18          ; load b with value -00011000-
   LC73F:  stab CPU_TimerControlReg2    ; store b into memory
           bset *BitFlags6d, #b6d_FuelEngineNotRunning | b6d_Starting | b6d_DisableNormalDwell    ; set bits
           ldaa #b67_StayOpenLoop | b67_OpenLoop          ; load a with value -00010100-
           staa BitFlags67     ; store a into memory
           jsr  OCToggleAndResetCopTimer    ; call subroutine
           ldx  #0x074b        ; load index with value
   LC74F:  ldaa SwitchPortAccessReg1    ; load a with memory contents
           bita #sp1_B1Volt          ;  -00100000-
           bne  LC759          ; branch if not equal (not zero)
           dex                 ; decrement index (x=x-1)
           bne  LC74F          ; branch if not equal (not zero)
   LC759:  jsr  OCToggleAndResetCopTimer    ; call subroutine
           ldab #0x14          ; load b with value -00010100-
           stab CPU_A2DControlReg    ; store b into memory
   LC761:  ldaa CPU_A2DControlReg    ; load a with memory contents
           bpl  LC761          ; branch if plus (hi bit 0)
           ldaa CPU_A2DResults4    ; load a with memory contents
           staa AmbientAirTempVolts    ; store a into memory
           ldd  CPU_A2DResults1
           stD *LastCoolantTempVolts    ; store D to RAM
           ldab #0x10          ; load b with value -00010000-
           stab CPU_A2DControlReg    ; store b into memory
           ldx  #TMPTL2_TempForHotScaleA2D    ; load index with value
           brclr *PIA3_Buffer, #pi3_CoolantTemp, ConvertCoolantRawReadingToTemperature    ; branch if bit(s) clear
           ldx  #TMPTL1_TempForColdScaleFromA2D    ; load index with value
ConvertCoolantRawReadingToTemperature:
           jsr  Lookup4ByteTable    ; call subroutine
           staa CoolantTemp    ; store a into memory
           ldaa ChargeTempRaw    ; load a with memory contents
           ldx  #TMPTL2_TempForHotScaleA2D    ; load index with value
           brclr *PIA3_Buffer, #pi3_ChargeTemp, ConvertChargeTempRawReadingToTemperature    ; branch if bit(s) clear
           ldx  #TMPTL1_TempForColdScaleFromA2D    ; load index with value
ConvertChargeTempRawReadingToTemperature:
           jsr  Lookup4ByteTable    ; call subroutine
           staa ChargeTemp    ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           cmpa #0xa6          ; compare a with value -10100110-
           bcc  LC7A5          ; branch if greater or equal
           ldab AmbientAirTempVolts    ; load b with memory contents
           cmpb #0x99          ;  -10011001-
           bcs  LC7A5          ; branch if lower
           ldab #0x40          ; load b with value -01000000-
           stab Timer_RadSteamingCountdown    ; store b into memory
   LC7A5:  cmpa TTEMPL_TstatDiagnosticsMinTempToArmDiagnosticsAtStartup    ; compare a with memory contents (data is 63)
           bcs  CalculatePrimingFuel          ; branch if lower
           cmpa TTEMPH_TstatDiagnosticsMaxTempToArmDiagnosticsAtStartup    ; compare a with memory contents (data is e4)
           bcc  CalculatePrimingFuel          ; branch if greater or equal
           inc  Timer_ThermostatDiagnostics
CalculatePrimingFuel:
           ldx  #PRSHOT_KeyOnPrimePW    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldab #0xfa          ; load b with value -11111010-
           mul                 ; multiply (d=a*b)
           stD *InjectorPulsewidth_HB    ; store D to RAM
           jsr  OCToggleAndResetCopTimer    ; call subroutine
           ldaa CPU_A2DResults2    ; load a with memory contents
           staa BatteryVolts    ; store a into memory
           ldx  #BATOFF_FuelBatteryOffset    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa DRBPointer1    ; load a with memory contents
           cmpa #0x0a          ; compare a with value -00001010-
           beq  LC7E6          ; branch if equal (zero)
           clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd InjectorPulsewidth_HB    ; d = d + memory contents
           bcc  LC7DA          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LC7DA:  std  InjectorPulsewidthBank1_HB
           std  InjectorPulsewidthBank2_HB
           std  InjectorPulsewidthBank3_HB
           std  InjectorPulsewidthBank4_HB
   LC7E6:  bset *BitFlags6e, #b6e_BoostOver5psi | b6e_WastegateDC    ; set bits
           bset *BitFlags6f, #b6f_Alternator2    ; set bits
           ldd  CPU_A2DResults3
           stD *RawAirFuelSensInput    ; store D to RAM
           stab TpsVolts       ; store b into memory
           stab TpsAverageValue_HB    ; store b into memory
           ldaa MINTHR_LowestSessionTPS    ; load a with memory contents
           adda MININC_Amount_MINTHR_IsIncreasedAtKeyOnOnly    ;  (data is 03)
           cmpa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; compare a with memory contents (data is 5c)
           bcs  LC808          ; branch if lower
           addb #0x06          ;  -00000110-
           ldaa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load a with memory contents (data is 5c)
           cba             
           bcs  LC808          ; branch if lower
           tba                 ; a = b
   LC808:  staa MINTHR_LowestSessionTPS    ; store a into memory
           jsr  IncludeCylTrimWithAdaptiveCells    ; call subroutine
           jsr  OCToggleAndResetCopTimer    ; call subroutine
           bclr *BitFlags6e, #b6e_PIAKeepIntEnabled    ; clear bits
           ldd  CPU_TimerCounterRegHigh
           addd #0x000a    ;  -00000000 00001010-
           std  CPU_TimerOutputCompareRegHigh1
           addd #0x14f6        ;  -00010100 11110110-
           asld                ; shift left (d=d*2)
           staa MinimumTimerCountBeforeMainloopCanContinue    ; store a into memory
           cli                 ; enable interrupts
           jmp  MainProgramLoop

MainProgramLoop:
           jsr  DealWithConfigurationAndPulseAccumulator_MM    ; call subroutine
   LC829:  cli                 ; enable interrupts
           ldd  #0x55aa        ; load d (a&b) with value -01010101 10101010-
           staa CPU_ArmResetCopTimerReg
           stab CPU_ArmResetCopTimerReg    ; store b into memory
           ldaa PIA1_Buffer    ; load a with memory contents
           eora #pi1_AISMotor1          ; XOR a with value -00000010-
           staa PIA1_Buffer    ; store a into memory
           sei                 ; disable interrupts
           ldaa CPU_A2DControlReg    ; load a with memory contents
           bpl  LC829          ; branch if plus (hi bit 0)
           ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x03          ;  -00000011-
           bne  LC84A          ; branch if not equal (not zero)
           ldaa CPU_A2DResults2    ; load a with memory contents
           staa BatteryVolts    ; store a into memory
   LC84A:  ldd  CPU_A2DResults3
           cli                 ; enable interrupts
           staa RawAirFuelSensInput    ; store a into memory
           stab LastTpsVolts    ; store b into memory
     	   jsr  ConvertWB2NBSignal_MM
           sei                 ; disable interrupts
           ldd  CPU_TimerCounterRegHigh
           stD *Temp0          ; store D to RAM
           ldaa #0x14          ; load a with value -00010100-
           staa CPU_A2DControlReg
           ldd  Temp0          ; load d (a&b) with memory contents
           jsr  DetermineNumberOfOverflowsBetweenDistributorPulses_MM    ; call subroutine
           ldd  Temp0          ; load d (a&b) with memory contents
           jsr  DetermineNumberOfOverflowsBetweenSpeedoPulses_MM    ; call subroutine
   LC867:  ldaa CPU_A2DControlReg    ; load a with memory contents
           bpl  LC867          ; branch if plus (hi bit 0)
           ldd  CPU_A2DResults1
           stD *LastCoolantTempVolts    ; store D to RAM
           ldaa CPU_A2DResults4    ; load a with memory contents
           staa AmbientAirTempVolts    ; store a into memory
           ldaa #0x10          ; load a with value -00010000-
           staa CPU_A2DControlReg
           cli                 ; enable interrupts
           ;jsr  EmmissionMaintenanceRemider1_MM    ; call subroutine
           jsr  DRB_SomethingLikeEMR_MM    ; call subroutine
           jsr  EmmissionMaintenanceRemider2_MM    ; call subroutine
           jsr  CycleACClutch_MM    ; call subroutine
           jsr  CheckThrottleRoutine_MM    ; call subroutine
           jsr  CheckAndFilterCoolantAndChargeTempSensors_MM    ; call subroutine
           jsr  HandleBaroReadRequirement_MM    ; call subroutine
           jsr  CalculateInjectorPulsewidthForStarting_MM    ; call subroutine
           jsr  DetectParkNeutral_MM    ; call subroutine
           jsr  CALCULATE_RPM_SPEED_AND    ; call subroutine
           jsr  ControlAsdRelay_MM    ; call subroutine
           jsr  CalculateSparkAdvance_MM    ; call subroutine
           jsr  ControlCruiseServo0_MM    ; call subroutine
           jsr  ControlCruiseServo1_MM    ; call subroutine
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
	   jsr  LaunchControl_MM
           jsr  CalculatePartThrottleTransientFuel_MM    ; call subroutine
           jsr  CalculateSumOfAllFuelModifiers_MM    ; call subroutine
           jsr  ControlFan_MM    ; call subroutine
           jsr  ControlAirConditioning_MM    ; call subroutine
	   jsr  CalculateKnockRetard_MM	  ; call subroutine
	   jsr  UseCELForKnockIndication_MM     ; call subroutine
           ;jsr  CalculateNO2Retard_Routine_MM
           jsr  CalcTargetBoost_MM    ; call subroutine
           jsr  GetControlFeedback_DetermineIfShutdownRequired_MM    ; call subroutine
           jsr  LADCF          ; call subroutine
           jsr  VerifyOperationOfBatteryVoltage_MM    ; call subroutine
           jsr  UpdateCylTrimCounters_MM    ; call subroutine
           jsr  CheckForErrorsAndSetCodes_MM    ; call subroutine
           jsr  DetectAlternatorFault_MM    ; call subroutine
           jsr  VerifyOperationOfASDRelayAndO2Sensor_MM    ; call subroutine
           jsr  VerifyOperationOfFuelInjectorDrivers_MM    ; call subroutine
           jsr  VerifyOperationOfIgnitionCoilDriver_MM    ; call subroutine
           jsr  VerifyOperationOfMapSensor_MM    ; call subroutine
           jsr  VerifyOperationOfThermostat_MM    ; call subroutine
           sei                 ; disable interrupts
           ldd  #0xaaa5        ; load d (a&b) with value -10101010 10100101-
           stD *L0003          ; store D to RAM
           cli                 ; enable interrupts
           jsr  DetermineTargetBatteryVoltage_MM    ; call subroutine
           jsr  ControlPTU_MM    ; call subroutine
           jsr  ExhGasRecirc_MM    ; call subroutine
           jsr  ProcessErrorBits_WorkWithData_MM    ; call subroutine
           jsr  ThrowMajorErrorIfRequired_MM    ; call subroutine
           jsr  UpdateErrorTimersAndPossiblyClearErrors_MM    ; call subroutine
           jsr  CheckIfCheckEngineLightShouldBeOn_MM    ; call subroutine
           jsr  DRBIISerialCommunications_MM    ; call subroutine
           jsr  ActuatorTestMode_MM    ; call subroutine
           jsr  DRBIIOuput_MM    ; call subroutine
           jsr  UpdatePIAAndCheckOuputs_MM    ; call subroutine
           jsr  IncrementLoopCounters_MM    ; call subroutine
           sei                 ; disable interrupts
           ldaa MinimumTimerCountBeforeMainloopCanContinue    ; load a with memory contents
           ldab CPU_TimerCounterRegHigh    ; load b with memory contents
           cba             
           bmi  LC938          ; branch if minus(hi bit 1)
           tab                 ; b = a
   LC938:  addb #0x15          ;  10.5mSec - 0x15 = 21d / 2 = 10.5mSec
           stab MinimumTimerCountBeforeMainloopCanContinue    ; store b into memory
           cli                 ; enable interrupts
   LC93D:  cmpa CPU_TimerCounterRegHigh    ; compare a with memory contents
           bpl  LC93D          ; branch if plus (hi bit 0)
           jmp  MainProgramLoop

ControlPurgeSolenoid_MM:
           brclr *BitFlags6d, #b6d_FuelEngineNotRunning, LC958    ; branch if bit(s) clear
           ldaa CoolantTemp    ; load a with memory contents
           cmpa PURTMP_CanisterPurgeCoolantTemp    ; compare a with memory contents (data is b6)
           bcc  LC955          ; branch if greater or equal
           bclr *BitFlags67, #b67_Purge    ; clear bits
           bra  LC958          ; branch

   LC955:  bset *BitFlags67, #b67_Purge    ; set bits
   LC958:  brclr *BitFlags66, #b66_PTEisMaxed | b66_FullThrottle, LC960    ; branch if bit(s) clear
CanisterPurgeOff:
           bclr *PIA1_Buffer, #pi1_PurgeSol    ; clear bits
           rts                 ; return from subroutine

   LC960:  ldab BaroPressure    ; load b with memory contents
           brset *PIA1_Buffer, #pi1_PurgeSol, LC969    ; branch if bit(s) set
           subb PURHYS_CannisterPurgeBaroHysteresis    ; subtract memory contents from b (data is 02)
   LC969:  subb PURMAP_CannisterPurgeWhenBelowThisBaro    ; subtract memory contents from b (data is 05)
           cmpb MapValue   
           bcs  CanisterPurgeOff    ; branch if lower
           brset *BitFlags67, #b67_Purge, CanisterPurgeOn    ; branch if bit(s) set
           brset *BitFlags67, #b67_OpenLoop, CanisterPurgeOff    ; branch if bit(s) set
           bset *BitFlags67, #b67_Purge    ; set bits
           bra  LC985          ; branch

CanisterPurgeOn:
           brset *BitFlags66, #b66_O2Valid, LC985    ; branch if bit(s) set
           ldab Timer_CLTIME_ClosedLoopTimer    ; load b with memory contents
           bne  CanisterPurgeOff    ; branch if not equal (not zero)
   LC985:  ldab #0x08          ; load b with value -00001000-
           ldx  #CLTRP2_Cyl2TrimValueForPurgeVolume    ; load index with value
           ldaa PointerIntoAdaptiveMemory    ; load a with memory contents
           cmpa CL2PTR_Cyl2AdaptiveMemoryPointer    ; compare a with memory contents (data is 0d)
           bne  CanisterPurgeAdjustCylTrimsForPurgeVolume    ; branch if not equal (not zero)
           brset *BitFlags67, #b67_FallToIdle, LC9F9    ; branch if bit(s) set
           bra  LC9AA          ; branch

CanisterPurgeAdjustCylTrimsForPurgeVolume:
           inx                 ; increment index (x=x+1)
           lsrb                ; logical shift right b
           cmpa CL1PTR_Cyl1AdaptiveMemoryPointer    ; compare a with memory contents (data is 03)
           beq  LC9AA          ; branch if equal (zero)
           lsrb                ; logical shift right b
           cmpa CL3PTR_Cyl3AdaptiveMemoryPointer    ; compare a with memory contents (data is 04)
           beq  LC9AA          ; branch if equal (zero)
           lsrb                ; logical shift right b
           cmpa CL4PTR_Cyl4AdaptiveMemoryPointer    ; compare a with memory contents (data is 05)
           bne  LC9F9          ; branch if not equal (not zero)
   LC9AA:  brset *CylTrim_FlagsE7, #$%00100000, LC9F9    ; branch if bit(s) set
           brset *BitFlags67, #b67_StayOpenLoop, LC9FC    ; branch if bit(s) set
           bitb CylTrim_FlagsE6
           bne  LC9F9          ; branch if not equal (not zero)
           lslb            
           lslb            
           lslb            
           lslb            
           brclr *CylTrim_FlagsE7, #$%10000000, LC9C8    ; branch if bit(s) clear
           cmpb #0x80          ;  -10000000-
           bne  LC9C8          ; branch if not equal (not zero)
           bset *CylTrim_FlagsE6, #$%10000000    ; set bits
           bclr *CylTrim_FlagsE7, #$%10000000    ; clear bits
   LC9C8:  bitb CylTrim_FlagsE6
           beq  LC9F9          ; branch if equal (zero)
           ldaa CylTrim_Adaptive_Var1    ; load a with memory contents
           cmpa 0x00, X        ; compare a with memory at index + value
           bcc  LC9EC          ; branch if greater or equal
           bitb CylTrimFlags
           bne  LC9F9          ; branch if not equal (not zero)
           tsta                ; test a
           beq  LC9DF          ; branch if equal (zero)
           brclr *Counter_MainLoop, #$%00111111, LC9DF    ; branch if bit(s) clear
           bra  LC9E4          ; branch

   LC9DF:  inca                ; increment a
           beq  LC9E4          ; branch if equal (zero)
           staa CylTrim_Adaptive_Var1    ; store a into memory
   LC9E4:  cmpa #0x03          ; compare a with value -00000011-
           bcs  LC9FC          ; branch if lower
           bclr *PIA1_Buffer, #pi1_PurgeSol    ; clear bits
           rts                 ; return from subroutine

   LC9EC:  lsrb                ; logical shift right b
           lsrb                ; logical shift right b
           lsrb                ; logical shift right b
           lsrb                ; logical shift right b
           tba                 ; a = b
           orab CylTrim_FlagsE6
           stab CylTrim_FlagsE6    ; store b into memory
           oraa CylTrimFlags    ; OR a with memory contents
           staa CylTrimFlags    ; store a into memory
   LC9F9:  clr  CylTrim_Adaptive_Var1    ; zero byte at memory location
   LC9FC:  bset *PIA1_Buffer, #pi1_PurgeSol    ; set bits
           rts                 ; return from subroutine

DetermineIndividualInjectorTrims_MM:
           brclr *CylTrim_FlagsE7, #$%01000000, LCA05    ; branch if bit(s) clear
           rts                 ; return from subroutine

   LCA05:  brclr *CylTrimFlags, #$%00001000, LCA27    ; branch if bit(s) clear
           ldx  #AutoCalCell0    ; load index with value
           ldab CL2PTR_Cyl2AdaptiveMemoryPointer    ; load b with memory contents (data is 0d)
           abx                 ; add b to index
           ldaa Cyl2_InjPWTrim    ; load a with memory contents
           suba 0x00, X    
           blt  LCA27          ; branch if less
           brclr *CylTrimFlags, #$%10000000, LCA1D    ; branch if bit(s) clear
           adda CL2INC_Cyl2TrimIncrement    ;  (data is 05)
   LCA1D:  cmpa CL2LMT_Cyl2TrimLimit    ; compare a with memory contents (data is 33)
           bcs  LCA27          ; branch if lower
           bset *CylTrimFlags, #$%10000000    ; set bits
           bra  LCA2A          ; branch

   LCA27:  bclr *CylTrimFlags, #$%10000000    ; clear bits
   LCA2A:  brclr *CylTrimFlags, #$%00000100, LCA4C    ; branch if bit(s) clear
           ldx  #AutoCalCell0    ; load index with value
           ldab CL1PTR_Cyl1AdaptiveMemoryPointer    ; load b with memory contents (data is 03)
           abx                 ; add b to index
           ldaa Cyl1_InjPWTrim    ; load a with memory contents
           suba 0x00, X    
           blt  LCA4C          ; branch if less
           brclr *CylTrimFlags, #$%01000000, LCA42    ; branch if bit(s) clear
           adda CL1INC_Cyl1TrimIncrement    ;  (data is 05)
   LCA42:  cmpa CL1LMT_Cyl1TrimLimit    ; compare a with memory contents (data is 33)
           bcs  LCA4C          ; branch if lower
           bset *CylTrimFlags, #$%01000000    ; set bits
           bra  LCA4F          ; branch

   LCA4C:  bclr *CylTrimFlags, #$%01000000    ; clear bits
   LCA4F:  brclr *CylTrimFlags, #$%00000010, LCA71    ; branch if bit(s) clear
           ldx  #AutoCalCell0    ; load index with value
           ldab CL3PTR_Cyl3AdaptiveMemoryPointer    ; load b with memory contents (data is 04)
           abx                 ; add b to index
           ldaa Cyl3_InjPWTrim    ; load a with memory contents
           suba 0x00, X    
           blt  LCA71          ; branch if less
           brclr *CylTrimFlags, #$%00100000, LCA67    ; branch if bit(s) clear
           adda CL3INC_Cyl3TrimIncrement    ;  (data is 05)
   LCA67:  cmpa CL3LMT_Cyl3TrimLimit    ; compare a with memory contents (data is 33)
           bcs  LCA71          ; branch if lower
           bset *CylTrimFlags, #$%00100000    ; set bits
           bra  LCA74          ; branch

   LCA71:  bclr *CylTrimFlags, #$%00100000    ; clear bits
   LCA74:  brclr *CylTrimFlags, #$%00000001, LCA95    ; branch if bit(s) clear
           ldx  #AutoCalCell0    ; load index with value
           ldab CL4PTR_Cyl4AdaptiveMemoryPointer    ; load b with memory contents (data is 05)
           abx                 ; add b to index
           ldaa Cyl4_InjPWTrim    ; load a with memory contents
           suba 0x00, X    
           blt  LCA95          ; branch if less
           brclr *CylTrimFlags, #$%00010000, LCA8C    ; branch if bit(s) clear
           adda CL4INC_Cyl4TrimIncrement    ;  (data is 05)
   LCA8C:  cmpa CL4LMT_Cyl4TrimLimit    ; compare a with memory contents (data is 33)
           bcs  LCA95          ; branch if lower
           bset *CylTrimFlags, #$%00010000    ; set bits
           rts                 ; return from subroutine

   LCA95:  bclr *CylTrimFlags, #$%00010000    ; clear bits
           rts                 ; return from subroutine

IncludeCylTrimWithAdaptiveCells:
           bset *CylTrim_FlagsE7, #$%00100000    ; set bits
           bset *CylTrim_FlagsE6, #$%10000000    ; set bits
           ldab #0xf0          ; load b with value -11110000-
           bitb CylTrimFlags
           beq  LCAFF          ; branch if equal (zero)
           ldaa CoolantTemp    ; load a with memory contents
           cmpa CLTRP3_Cyl3TrimValueForPurgeVolume    ; compare a with memory contents (data is fe)
           bcs  LCAB0          ; branch if lower
           cmpb CylTrimFlags
           beq  LCB09          ; branch if equal (zero)
   LCAB0:  ldaa Cyl1_InjPWTrim    ; load a with memory contents
           ldab Cyl3_InjPWTrim    ; load b with memory contents
           cba
           bge  LCAB8          ; branch if greater or equal
           tba                 ; a = b
   LCAB8:  ldab Cyl4_InjPWTrim    ; load b with memory contents
           cba             
           bge  LCABE          ; branch if greater or equal
           tba                 ; a = b
   LCABE:  clrb                ; b = 0
   LCABF:  cmpb CL2PTR_Cyl2AdaptiveMemoryPointer    ; compare b with memory contents (data is 0d)
           beq  LCAD7          ; branch if equal (zero)
           cmpb CL1PTR_Cyl1AdaptiveMemoryPointer    ; compare b with memory contents (data is 03)
           beq  LCAD7          ; branch if equal (zero)
           cmpb CL3PTR_Cyl3AdaptiveMemoryPointer    ; compare b with memory contents (data is 04)
           beq  LCAD7          ; branch if equal (zero)
           cmpb CL4PTR_Cyl4AdaptiveMemoryPointer    ; compare b with memory contents (data is 05)
           beq  LCAD7          ; branch if equal (zero)
           pshb                ; push b onto stack
           bsr  UpdateAdaptiveCellWithCylTrim    ; call subroutine
           pulb                ; pull b from stack
   LCAD7:  incb            
           pshb                ; push b onto stack
           addb #0x11          ;  -00010001-
           cmpb #0x1f          ;  -00011111-
           pulb                ; pull b from stack
           bcs  LCABF          ; branch if lower
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
   LCAFF:  ldaa CoolantTemp    ; load a with memory contents
           cmpa CLTRP4_Cyl4TrimValueForPurgeVolume    ; compare a with memory contents (data is 84)
           bcc  LCB09          ; branch if greater or equal
           bset *CylTrim_FlagsE7, #$%01000000    ; set bits
   LCB09:  ldx  #CONFIG_ConfigurationFlags    ; load index with value
           brclr  0, X, #cfg_ATX, LCB1E    ; branch if bit(s) clear
           ldaa AutoCalCellEnd    ; load a with memory contents
           tab                 ; b = a
           suba AutoCalCell12idle
           blt  LCB1E          ; branch if less
           cmpa CL2LMT_Cyl2TrimLimit    ; compare a with memory contents (data is 33)
           bcs  LCB1E          ; branch if lower
           stab AutoCalCell12idle    ; store b into memory
   LCB1E:  rts                 ; return from subroutine

UpdateAdaptiveCellWithCylTrim:
           ldx  #AutoCalCell0    ; load index with value
           abx                 ; add b to index
           ldab 0x00, X        ; load b with memory at index + value
           cba             
           ble  LCB2A          ; branch if less or equal
           staa 0x00, X    
   LCB2A:  rts                 ; return from subroutine

UpdateCylTrimCounters_MM:
           clr  Temp0          ; zero byte at memory location
           brclr *b5c_IPL1, #b5c_TpsBadSignal, LCB3C    ; branch if bit(s) clear
           bclr *Counter_CylTrim1, #$%11111111    ; clear bits
           bclr *Counter_CylTrim2, #$%11111111    ; clear bits
           bclr *BitFlags6b, #$%00010000    ; clear bits
   LCB3B:  rts                 ; return from subroutine

   LCB3C:  brset *BitFlags6d, #b6d_FuelEngineNotRunning, LCB3B    ; branch if bit(s) set
           brset *b5c_IPL1, #b5c_MapBadSignal, LCBA1    ; branch if bit(s) set
           brset *b5c_IPL1, #b5c_MapStuck, LCBA1    ; branch if bit(s) set
           brset *BitFlags66, #b66_OffIdle, LCBA1    ; branch if bit(s) set
           ldaa MAPOffsetForCylTrim    ; load a with memory contents
           beq  LCBA1          ; branch if equal (zero)
           ldaa MapValue       ; load a with memory contents
           suba MAPOffsetForCylTrim
           bcs  LCB8E          ; branch if lower
           suba OFSMID_OffsetForMAPOverIdle    ;  (data is fe)
           bcs  LCB89          ; branch if lower
           ldaa Counter_CylTrim1    ; load a with memory contents
           cmpa #0x80          ; compare a with value -10000000-
           bcc  LCB7E          ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x0f          ;  -00001111-
           bne  LCBA4          ; branch if not equal (not zero)
           inca                ; increment a
           staa Counter_CylTrim1    ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #CTLMC1_CylinderTrimCounter1LimitFromCoolantTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           cmpa Counter_CylTrim1    ; compare a with memory contents
           bhi  LCBA4          ; branch if higher
           bset *Counter_CylTrim1, #$%10000000    ; set bits
           bset *BitFlags6b, #$%00010000    ; set bits
   LCB7E:  brclr *Counter_CylTrim1, #$%10000000, LCBA4    ; branch if bit(s) clear
           ldaa #0x41          ; load a with value -01000001-
           jsr  LCBFF          ; call subroutine
           bra  LCBA4          ; branch

   LCB89:  adda INCMID_IncrementForMAPOverIdle    ;  (data is 02)
           bpl  LCB7E          ; branch if plus (hi bit 0)
   LCB8E:  inc  Temp0      
           brclr *BitFlags67, #b67_FallToIdle, LCBA1    ; branch if bit(s) clear
           clr  Temp0          ; zero byte at memory location
           bclr *Counter_CylTrim2, #$%10000000    ; clear bits
           bclr *Counter_CylTrim1, #$%10000000    ; clear bits
           bclr *BitFlags6b, #$%00010000    ; clear bits
   LCBA1:  bclr *Counter_CylTrim1, #$%01111111    ; clear bits
   LCBA4:  brset *BitFlags6b, #$%00100000, LCBFB    ; branch if bit(s) set
           brset *BitFlags66, #b66_OffIdle, LCBFB    ; branch if bit(s) set
           brclr *TargetIdleSpeedHB, #$%11111111, LCBFB    ; branch if bit(s) clear
           brset *BitFlags67, #b67_FallToIdle, LCBFE    ; branch if bit(s) set
           ldaa EngineRpm_HB    ; load a with memory contents
           suba TargetIdleSpeedHB
           bcs  LCBEE          ; branch if lower
           suba OFSRID_OffsetForRPMOverIdle    ;  (data is d0)
           bcs  LCBE9          ; branch if lower
           ldaa Counter_CylTrim2    ; load a with memory contents
           cmpa #0x80          ; compare a with value -10000000-
           bcc  LCBE0          ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x0f          ;  -00001111-
           bne  LCBFE          ; branch if not equal (not zero)
           inca                ; increment a
           staa Counter_CylTrim2    ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #CTLMC2_CylinderTrimCounter2LimitFromCoolantTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           cmpa Counter_CylTrim2    ; compare a with memory contents
           bhi  LCBFE          ; branch if higher
           bset *Counter_CylTrim2, #$%10000000    ; set bits
           bset *BitFlags6b, #$%00010000    ; set bits
   LCBE0:  brclr *Counter_CylTrim1, #$%10000000, LCBFE    ; branch if bit(s) clear
           ldaa #0x42          ; load a with value -01000010-
           jmp  LCBFF      

   LCBE9:  adda INCRID_IncrementForRPMOverIdle    ;  (data is 01)
           bpl  LCBFE          ; branch if plus (hi bit 0)
   LCBEE:  brclr *Temp0, #$%11111111, LCBFB    ; branch if bit(s) clear
           bclr *Counter_CylTrim2, #$%10000000    ; clear bits
           bclr *Counter_CylTrim1, #$%10000000    ; clear bits
           bclr *BitFlags6b, #$%00010000    ; clear bits
   LCBFB:  bclr *Counter_CylTrim2, #$%01111111    ; clear bits
   LCBFE:  rts                 ; return from subroutine

   LCBFF:  ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x0f          ;  -00001111-
           bne  LCC13          ; branch if not equal (not zero)
           brset *b5d_IPL2, #b5d_bit1, LCC13    ; branch if bit(s) set
           ldab #0xb9          ; load b with value -10111001-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LCC13          ; branch if greater or equal
           bset *b5d_IPL2, #b5d_bit1    ; set bits
   LCC13:  rts                 ; return from subroutine

DetectParkNeutral_MM:
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_ATX          ;  -00100000-
           beq  LCC3B          ; branch if equal (zero)
           brset *StartupSwitchMirror1, #sw1_PNswitch, LCC28    ; branch if bit(s) set
           brclr *BitFlags_AIS, #b10_ATXInGear, LCC3E    ; branch if bit(s) clear
           bclr *BitFlags_AIS, #b10_ATXInGear    ; clear bits
           bra  LCC2F          ; branch

   LCC28:  brset *BitFlags_AIS, #b10_ATXInGear, LCC3E    ; branch if bit(s) set
           bset *BitFlags_AIS, #b10_ATXInGear    ; set bits
   LCC2F:  bclr *BitFlags67, #b67_FallToIdle    ; clear bits
           brset *BitFlags6d, #b6d_FuelEngineNotRunning, LCC3E    ; branch if bit(s) set
           bset *BitFlags_AIS, #b10_ATXChngGear    ; set bits
           bra  LCC3E          ; branch

   LCC3B:  bclr *BitFlags_AIS, #b10_ATXInGear | b10_ATXChngGear    ; clear bits
   LCC3E:  ldab SwitchPortAccessReg2    ; load b with memory contents
           bitb #0x01          ;  -00000001-
           bne  LCC48          ; branch if not equal (not zero)
           bset *BitFlags68, #b68_BladePassedSensor    ; set bits
   LCC48:  rts                 ; return from subroutine

CycleACClutch_MM:
           brset *Counter_MainLoop, #$%00000001, LCCB6    ; branch if bit(s) set
           ldaa #0x30          ; load a with value -00110000-
           clrb                ; b = 0
           jsr  SetPIAOutputBits    ; call subroutine
           ldaa #0x00          ; load a with value -00000000-
           ldab #0xff          ; load b with value -11111111-
           jsr  SetPIAOutputBits    ; call subroutine
           cmpa StartupSwitchMirror2    ; compare a with memory contents
           beq  LCC67          ; branch if equal (zero)
           pshb                ; push b onto stack
           anda StartupSwitchMirror2    ; logical and a with memory contents
           eorb StartupSwitchMirror2
           andb StartupSwitchMirror1
           aba                 ; a=a+b
           pulb                ; pull b from stack
   LCC67:  staa StartupSwitchMirror1    ; store a into memory
           stab StartupSwitchMirror2    ; store b into memory
           ldab ACClutchToggleVar    ; load b with memory contents
           eora BitFlags68 
           bita #b68_bit6          ;  -01000000-
           beq  LCCA1          ; branch if equal (zero)
           brclr *StartupSwitchMirror1, #sw1_ACclutch, LCC8C    ; branch if bit(s) clear
           cmpb #0x30          ;  -00110000-
           bcs  LCC81          ; branch if lower
           bset *BitFlags68, #b68_bit6    ; set bits
           bclr *ACClutchToggleVar, #$%00000111    ; clear bits
   LCC81:  ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x1f          ;  -00011111-
           bne  LCCB6          ; branch if not equal (not zero)
           addb #0x08          ;  -00001000-
           bcc  LCCB4          ; branch if greater or equal
           rts                 ; return from subroutine

   LCC8C:  brclr *ACClutchToggleVar, #$%00000111, LCC97    ; branch if bit(s) clear
           tba                 ; a = b
           anda #0x07          ; AND a with value -00000111-
           cmpa #0x05          ; compare a with value -00000101-
           bls  LCC9E          ; branch if lower or same
   LCC97:  cmpb #0xb8          ;  -10111000-
           bcs  LCC81          ; branch if lower
           bclr *BitFlags68, #b68_bit6    ; clear bits
   LCC9E:  clrb                ; b = 0
           bra  LCCB4          ; branch

   LCCA1:  brset *ACClutchToggleVar, #$%00000111, LCCA8    ; branch if bit(s) set
           incb            
           stab ACClutchToggleVar    ; store b into memory
   LCCA8:  brset *BitFlags68, #b68_bit6, LCC81    ; branch if bit(s) set
           cmpb #0x60          ;  -01100000-
           bcs  LCC81          ; branch if lower
           andb #0x07          ;  -00000111-
           orab #0x60          ;  -01100000-
   LCCB4:  stab ACClutchToggleVar    ; store b into memory
   LCCB6:  rts                 ; return from subroutine

  ;.org    0xcce1
CheckAndFilterCoolantAndChargeTempSensors_MM:
           brclr *Counter_MainLoop, #$%00000111, CheckForChargeTempOption    ; branch if bit(s) clear
           rts                 ; return from subroutine

CheckForChargeTempOption:
           ldab #0xff
           ldaa OPTN2_CalCustomOptionConfigFlags2
           bita #opt_CTS
           bne  FilterAndStoreChargeTemp
           jmp  StoreChargeTempValue

FilterAndStoreChargeTemp:
           ldab #0x39          ; load b with value -00111001-
           ldaa ChargeTempRaw    ; load a with memory contents
           cmpa CHGLOW_ChargeTempOutOfRangeLow    ; compare a with memory contents (data is 1a)
           bcs  ChargeTempOutOfRange          ; branch if lower
           incb
           cmpa CHGHIG_ChargeTempOutOfRangeHigh    ; compare a with memory contents (data is fd)
           bcc  ChargeTempOutOfRange          ; branch if greater or equal
           brset *b5c_IPL1, #b5c_BadIATSensor, LCD58    ; branch if bit(s) set
           brclr *PIA3_Buffer, #pi3_ChargeTemp, LCD20    ; branch if bit(s) clear
           ldx  #TMPTL1_TempForColdScaleFromA2D    ; load index with value
           cmpa #0x40          ; compare a with value -01000000-
           bcc  LCD27          ; branch if greater or equal
   LCD04:  brset *BitFlags6b, #$%11000000, LCD10    ; branch if bit(s) set
           ldab BitFlags6b     ; load b with memory contents
           addb #0x40          ;  -01000000-
           stab BitFlags6b     ; store b into memory
           bra  LookupAndFilterChargeTempValue    ; branch

   LCD10:  bclr *BitFlags6b, #$%11000000    ; clear bits
           ldab #pi3_ChargeTemp          ; load b with value -00100000-
           sei                 ; disable interrupts
           eorb PIA3_Buffer
           stab PIA3_Buffer_2    ; store b into memory
           stab PIA3_Buffer    ; store b into memory
           cli                 ; enable interrupts
           bra  FilterAndStoreCoolantTemp    ; branch

   LCD20:  ldx  #TMPTL2_TempForHotScaleA2D    ; load index with value
           cmpa #0xdc          ; compare a with value -11011100-
           bcc  LCD04          ; branch if greater or equal
   LCD27:  bclr *BitFlags6b, #$%11000000    ; clear bits
LookupAndFilterChargeTempValue:
           jsr  Lookup4ByteTable    ; call subroutine
           ldab ChargeTemp    ; load b with memory contents
           sba                 ; subtract (a=a-b)
           bcc  LCD35          ; branch if greater or equal
           decb
           bra  StoreChargeTempValue    ; branch

   LCD35:  cmpa #0x03          ; compare a with value -00000011-
           bcs  FilterAndStoreCoolantTemp    ; branch if lower
           incb            
           bra  StoreChargeTempValue    ; branch

ChargeTempOutOfRange:
           brset *b5c_IPL1, #b5c_BadIATSensor, LCD5D    ; branch if bit(s) set
           tba                 ; a = b
           ldab #0x9e          ; load b with value -10011110-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  FilterAndStoreCoolantTemp    ; branch if greater or equal
           ldaa #~pi3_ChargeTemp          ; load a with value -11011111-
           sei                 ; disable interrupts
           anda PIA3_Buffer    ; logical and a with memory contents
           staa PIA3_Buffer_2
           staa PIA3_Buffer    ; store a into memory
           cli                 ; enable interrupts
           bset *b5c_IPL1, #b5c_BadIATSensor    ; set bits
           bra  FilterAndStoreCoolantTemp    ; branch

   LCD58:  ldaa #0x01          ; load a with value -00000001-
           jsr  ResetErrorCodeIfTimerExpired    ; call subroutine
   LCD5D:  brclr *b5c_IPL1, #b5c_BadCoolantTemp, SubCoolantforChargeTemp    ; branch if bit(s) clear
           ldab DEFCHG_DefaultChargeTemp_Limpin    ; load b with memory contents (data is 95)
           bra  StoreChargeTempValue    ; branch

SubCoolantforChargeTemp:
           ldab CoolantTemp    ; load b with memory contents
StoreChargeTempValue:
           stab ChargeTemp    ; store b into memory
FilterAndStoreCoolantTemp:
           ldab #0x1e          ; load b with value -00011110-
           ldaa LastCoolantTempVolts    ; load a with memory contents
           cmpa TMPLOW_OutOfRangeHotTooLowA2D    ; compare a with memory contents (data is 1a)
           bcs  CoolantTempOutOfRange          ; branch if lower
           incb            
           cmpa TMPHIG_OutOfRangeColdTooHighA2D    ; compare a with memory contents (data is fd)
           bcc  CoolantTempOutOfRange          ; branch if greater or equal
           brset *b5c_IPL1, #b5c_BadCoolantTemp, LCDE2    ; branch if bit(s) set
           brclr *PIA3_Buffer, #pi3_CoolantTemp, LCDA3    ; branch if bit(s) clear
           ldx  #TMPTL1_TempForColdScaleFromA2D    ; load index with value
           cmpa #0x40          ; compare a with value -01000000-
           bcc  LCDAA          ; branch if greater or equal
   LCD88:  brset *BitFlags69, #b69_bit7 | b69_bit6, LCD94    ; branch if bit(s) set
           ldab BitFlags69     ; load b with memory contents
           addb #b69_bit6          ;  -01000000-
           stab BitFlags69     ; store b into memory
           bra  LookupAndFilterCoolantTempValue          ; branch

   LCD94:  bclr *BitFlags69, #b69_bit7 | b69_bit6    ; clear bits
           ldab #pi3_CoolantTemp          ; load b with value -00010000-
           sei                 ; disable interrupts
           eorb PIA3_Buffer
           stab PIA3_Buffer_2    ; store b into memory
           stab PIA3_Buffer    ; store b into memory
           cli                 ; enable interrupts
   LCDA2:  rts                 ; return from subroutine

   LCDA3:  ldx  #TMPTL2_TempForHotScaleA2D    ; load index with value
           cmpa #0xdc          ; compare a with value -11011100-
           bcc  LCD88          ; branch if greater or equal
   LCDAA:  bclr *BitFlags69, #b69_bit7 | b69_bit6    ; clear bits
LookupAndFilterCoolantTempValue:
           jsr  Lookup4ByteTable    ; call subroutine
           ldab CoolantTemp    ; load b with memory contents
           sba                 ; subtract (a=a-b)
           bcc  LCDB8          ; branch if greater or equal
           decb            
           bra  StoreCoolantTemp          ; branch

   LCDB8:  cmpa #0x03          ; compare a with value -00000011-
           bcs  LCDA2          ; branch if lower
           incb
           bra  StoreCoolantTemp          ; branch

CoolantTempOutOfRange:
           brset *b5c_IPL1, #b5c_BadCoolantTemp, UseSubForCoolantTemp    ; branch if bit(s) set
           tba                 ; a = b
           ldab #0x9e          ; load b with value -10011110-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LCDA2          ; branch if greater or equal
           ldaa #~pi3_CoolantTemp          ; load a with value -11101111-
           sei                 ; disable interrupts
           anda PIA3_Buffer    ; logical and a with memory contents
           staa PIA3_Buffer_2
           staa PIA3_Buffer    ; store a into memory
           cli                 ; enable interrupts
           bset *b5c_IPL1, #b5c_BadCoolantTemp    ; set bits
           bclr *BitFlags66, #b66_O2Valid    ; clear bits
           clra                ; a = 0
           staa Timer_CLTIME_ClosedLoopTimer    ; store a into memory
           staa Timer_ThermostatDiagnostics    ; store a into memory
           rts                 ; return from subroutine

   LCDE2:  ldaa #0x02          ; load a with value -00000010-
           jsr  ResetErrorCodeIfTimerExpired    ; call subroutine
UseSubForCoolantTemp:
           ldaa OPTN2_CalCustomOptionConfigFlags2
           bita #opt_CTS
           beq  UseDefCoolantTemp          ; branch if equal (zero)
           brset *b5c_IPL1, #b5c_BadIATSensor, UseDefCoolantTemp    ; branch if bit(s) set
           ldab ChargeTemp    ; load b with memory contents
           bra  StoreCoolantTemp          ; branch
UseDefCoolantTemp:
           ldab DEFTMP_DefaultEngineTemp    ; load b with memory contents (data is b2)
StoreCoolantTemp:
           stab CoolantTemp    ; store b into memory
           rts ; added by RCL - forgotten by Mopar?

CheckThrottleRoutine_MM:
           ldab #0x1a          ; load b with value -00011010-
           ldaa LastTpsVolts    ; load a with memory contents
           cmpa THRLOW_ThrottleLowerLimit    ; compare a with memory contents (data is 08)
           bcs  CheckThrottle_BadTpsSignal    ; branch if lower
           incb            
           cmpa THRHIG_ThrottleUpperLimit    ; compare a with memory contents (data is e4)
           bcc  CheckThrottle_BadTpsSignal    ; branch if greater or equal
           brclr *b5c_IPL1, #b5c_TpsBadSignal, CheckThrottle_GotTpsValue    ; branch if bit(s) clear
           ldaa #0x07          ; load a with value -00000111-
           bita Counter_MainLoop
           bne  CheckThrottle_ErrorAlreadyFlagged    ; branch if not equal (not zero)
           jsr  ResetErrorCodeIfTimerExpired    ; call subroutine
           bra  CheckThrottle_ErrorAlreadyFlagged    ; branch

CheckThrottle_BadTpsSignal:
           brset *b5c_IPL1, #b5c_TpsBadSignal, CheckThrottle_ErrorAlreadyFlagged    ; branch if bit(s) set
           brclr *Counter_MainLoop, #$%00000001, LCE5C    ; branch if bit(s) clear
           tba                 ; a = b
           ldab #0xa0          ; load b with value -10100000-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LCE5C          ; branch if greater or equal
           bset *b5c_IPL1, #b5c_TpsBadSignal    ; set bits
CheckThrottle_ErrorAlreadyFlagged:
           ldaa #0x40          ; load a with value -01000000-
           staa MINTHR_LowestSessionTPS    ; store a into memory
           brset *BitFlags6d, #b6d_FuelEngineNotRunning, CheckThrottle_GotTpsValue    ; branch if bit(s) set
           ldab MapValue       ; load b with memory contents
           cmpb MPTHR_MapSwitchPointForFullThrottleOrIdle    ; compare b with memory contents (data is 68)
           bcs  CheckThrottle_GotTpsValue    ; branch if lower
           adda WOTDLT_DeltaThrottleFrom_MINTHR_ToDetermineFullThrottle    ;  (data is 85)
CheckThrottle_GotTpsValue:
           staa TpsVolts       ; store a into memory

           ; here, check if launch control is active and force WOT flag if it is...
           brset *Turbonator_Flags, #Turbonator_Staging, CheckThrottle_AtFullThrottle

           ldab WOTDLT_DeltaThrottleFrom_MINTHR_ToDetermineFullThrottle    ; load b with memory contents (data is 85)
           addb MINTHR_LowestSessionTPS    ; b=b+memory contents
           cmpb #0xd0          ;  -11010000-
           bls  LCE4B          ; branch if lower or same
           ldab #0xd0          ; load b with value -11010000-
   LCE4B:  brclr *BitFlags66, #b66_FullThrottle, LCE51    ; branch if bit(s) clear
           subb #0x03          ;  -00000011-
   LCE51:  cba             
           bhi  CheckThrottle_AtFullThrottle    ; branch if higher
           bclr *BitFlags66, #b66_FullThrottle    ; clear bits
           bra  LCE5C          ; branch

CheckThrottle_AtFullThrottle:
           bset *BitFlags66, #b66_FullThrottle    ; set bits
   LCE5C:  ldaa TpsVolts       ; load a with memory contents
           ldab BitFlags66     ; load b with memory contents
           bmi  LCE83          ; branch if minus(hi bit 1)
           cmpa MINTHR_LowestSessionTPS    ; compare a with memory contents
           bcc  LCE83          ; branch if greater or equal
           ldaa Timer_CountdownFromStartRunForAisFeedback    ; load a with memory contents
           bne  LCE83          ; branch if not equal (not zero)
           brset *BitFlags6d, #b6d_FuelEngineNotRunning, LCE83    ; branch if bit(s) set
           brclr *KeyOnOrEngineRunningTime, #$%11111111, LCE83    ; branch if bit(s) clear
           ldaa Timer_DelayBeforeUpdating_MINTHR    ; load a with memory contents
           deca                ; decrement a
           bne  LCE86          ; branch if not equal (not zero)
           ldaa MINTHR_LowestSessionTPS    ; load a with memory contents
           deca                ; decrement a
           bge  LCE7F          ; branch if greater or equal
           ldaa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load a with memory contents (data is 5c)
   LCE7F:  staa MINTHR_LowestSessionTPS    ; store a into memory
           andb #0xbf          ;  -10111111-
   LCE83:  ldaa MAXCNT_ProgramLoopsWithThrottleBelow_MINTHR_ToDecrement_MINTHR    ; load a with memory contents (data is 10)
   LCE86:  staa Timer_DelayBeforeUpdating_MINTHR    ; store a into memory
           ldaa MTHRCL_NumberOfBitsAbove_MINTHR_ToDetermineOnThrottleTransition    ; load a with memory contents (data is 02)
           tstb
           bpl  LCE91          ; branch if plus (hi bit 0)
           ldaa MTHROP_NumberOfBitsAbove_MINTHR_ToDetermineOffThrottleTransition    ; load a with memory contents (data is 01)
   LCE91:  adda MINTHR_LowestSessionTPS
           cmpa TpsVolts       ; compare a with memory contents
           bcc  CheckThrottle_AtIdle    ; branch if greater or equal
           tstb            
           bmi  LCEEC          ; branch if minus(hi bit 1)
           bitb #0x40          ;  -01000000-
           bne  LCEA9          ; branch if not equal (not zero)
           ldaa MINTHR_LowestSessionTPS    ; load a with memory contents
           inca                ; increment a
           cmpa TpsVolts       ; compare a with memory contents
           bcc  LCEA9          ; branch if greater or equal
           staa MINTHR_LowestSessionTPS    ; store a into memory
           orab #0x40          ;  -01000000-
   LCEA9:  ldaa MapValue       ; load a with memory contents
           suba OCTAE_FakeDeltaMapIncrease    ;  (data is 00)
           bcc  LCEB2          ; branch if greater or equal
           ldaa MINAMP_MinimumAverageMAP          ; load a with value -00000110-
   LCEB2:  staa MapAverageValue_HB    ; store a into memory
           ldaa TpsVolts       ; load a with memory contents
           staa TpsAverageValue_HB    ; store a into memory
           orab #0x80          ;  -10000000-
           bra  LCEEC          ; branch

CheckThrottle_AtIdle:
           tstb
           bpl  LCEEC          ; branch if plus (hi bit 0)
           brset *BitFlags_AIS, #b10_bit6, LCEC6    ; branch if bit(s) set
           bset *BitFlags69, #b69_AtIdle    ; set bits
   LCEC6:  ldx  #DLYTIM_AisDelayAfterThrottleClosesWhenMoving    ; load index with value
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
           bcc  LCEE2          ; branch if greater or equal
CheckThrottle_VehicleSpeedStillAboveDecelIdle:
           ldaa 0x00, X        ; load a with memory at index + value
   LCEE2:  cmpa Timer_CountdownFromStartRunForAisFeedback    ; compare a with memory contents
           bls  LCEE8          ; branch if lower or same
           staa Timer_CountdownFromStartRunForAisFeedback    ; store a into memory
   LCEE8:  ldab Temp0          ; load b with memory contents
           andb #0x7f          ;  -01111111-
   LCEEC:  bitb #0x08          ;  -00001000-
           bne  LCF11          ; branch if not equal (not zero)
           brclr *StartupSwitchMirror1, #sw1_Brake, LCF11    ; branch if bit(s) clear
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa RPMTHR_ThrottleSelfCalibrationRpmThreshold    ; compare a with memory contents (data is 30)
           bcs  LCF11          ; branch if lower
           ldaa MapValue       ; load a with memory contents
           cmpa MAPTHR_ThrottleSelfCalibrationMapDeltaThreshold    ; compare a with memory contents (data is 31)
           bcc  LCF11          ; branch if greater or equal
           ldaa MINTHR_LowestSessionTPS    ; load a with memory contents
           inca                ; increment a
           cmpa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; compare a with memory contents (data is 5c)
           bcs  LCF0D          ; branch if lower
           ldaa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load a with memory contents (data is 5c)
   LCF0D:  staa MINTHR_LowestSessionTPS    ; store a into memory
           orab #0x08          ;  -00001000-
   LCF11:  ldaa MINTHR_LowestSessionTPS    ; load a with memory contents
           adda #0x30          ;  -00110000-
           cmpa TpsVolts       ; compare a with memory contents
           bcc  LCF1B          ; branch if greater or equal
           andb #0xf7          ;  -11110111-
   LCF1B:  stab BitFlags66     ; store b into memory
           rts                 ; return from subroutine

ConvertMAPVoltsToValue:
           staa Temp5          ; store a into memory
           ldab MAPMULT_ScaleMAPVoltsToPresMultiplyConst          ; load b with value -00001001-
           bpl  LCF27          ; branch if plus (hi bit 0)
           clr  Temp5          ; zero byte at memory location
   LCF27:  mul                 ; multiply (d=a*b)
           adda Temp5
           bcc  LCF2E          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LCF2E:  addd MAPADD_ScaleMAPVoltsToPresAddConst        ;  -00000111 00000000-
           bcc  LCF35          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LCF35:  rts                 ; return from subroutine

CalculateSparkAdvance_MM:
;  Dwell calculation:
;
;  The dwell lookup/calculation is pretty simple.
;
;  First, the ideal dwell period is calculated from the complement of the 
;  lookup value from battery volts. Battery volts is the largest factor for
;  determining dwell period. The complement is used because the 16-bit 
;  table type cannot have a negative slope.
;
;  Then, the Ditributor PW is compared to the ideal dwell period plus the
;  the minimum antidwell period. If the dwell + min anti dwell is greater 
;  than the distributor PW, then the minimum antidwell is used. Otherwise,
;  the ideal dwell is used and the anit-dwell is set to the difference
;  between the distributor PW and the dwell (floating anti-dwell).
;
;  Logically --> If (DWELL + MINADW) < DISTPW 
;                   Then ADWELL = DISTPW - DWELL
;                   Else ADWELL = MINADW

CalculateDwell:
           ldaa BatteryVolts                            ; load a with memory contents
           ldx  #DWELL_DwellTimeFromBatteryVoltsComp        ; lookup complement of dwell period
           jsr  Lookup5ByteTable
           comb
           coma                                         ; now AccD contains the dwell period
           std  DwellTime_HB

StartToCalculateAdvance:
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd FilteredEngineRpm_HB    ; d = d - memory contents
           bcc  LCF5A          ; branch if greater or equal
           coma            
           comb            
           addd #L0001         ;  -00000000 00000001-
           cmpD RPMFPS_SparkAdvanceRPMFilterLimitPos    ; compare D (data is 01)
           bcc  LCF70          ; branch if greater or equal
           xgDY                ; exchange D and Y
           ldaa RPMFRT_SparkAdvanceRPMFilterRatio    ; load a with memory contents (data is 7f)
           beq  LCF70          ; branch if equal (zero)
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           coma            
           comb            
           addd #L0001         ;  -00000000 00000001-
           bra  LCF6C          ; branch

   LCF5A:  cmpD RPMFNG_SparkAdvanceRPMFilterLimitNeg    ; compare D (data is 01)
           bcc  LCF70          ; branch if greater or equal
           xgDY                ; exchange D and Y
           ldaa RPMFRT_SparkAdvanceRPMFilterRatio    ; load a with memory contents (data is 7f)
           beq  LCF70          ; branch if equal (zero)
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
   LCF6C:  addd FilteredEngineRpm_HB    ; d = d + memory contents
           bra  LCF72          ; branch

   LCF70:  ldd  EngineRpm_HB    ; load d (a&b) with memory contents
   LCF72:  stD *FilteredEngineRpm_HB    ; store D to RAM
           clra                ; a = 0
           staa Temp0          ; store a into memory
           staa Temp1          ; store a into memory
           staa Temp2          ; store a into memory
           ldab CoolantTemp    ; load b with memory contents
           cmpb TMPSWP_EngTempSwitchPointForSparkAdvance    ; compare b with memory contents (data is b1)
           bcc  DetermineHotAdvanceFromMap    ; branch if greater or equal
           ldx  #CLDMAP_AdvanceFromMAPCold    ; load index with value
SparkAdvance_TempAboveTMPSWP:
           jsr  SparkAdvance_GetAdvanceFromTableUsingMap    ; call subroutine
           brclr *BitFlags66, #b66_OffIdle, LCF8F    ; branch if bit(s) clear
           jmp  LD02A      

   LCF8F:  staa Temp0          ; store a into memory
           bmi  LCF98          ; branch if minus(hi bit 1)
           ldaa CLDLMT_LimitForColdMapAtClosedThrottle    ; load a with memory contents (data is 14)
           staa Temp0          ; store a into memory
   LCF98:  ldaa Temp2          ; load a with memory contents
           ble  SparkAdvance_NoThrottle    ; branch if less or equal
   LCF9C:  brclr *BitFlags66, #b66_O2Valid, SparkAdvance_NoThrottle    ; branch if bit(s) clear
           ldaa Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop    ; load a with memory contents
           bne  SparkAdvance_NoThrottle    ; branch if not equal (not zero)
           ldaa Counter_O2SensorFeedbackCount_Signed    ; load a with memory contents
           cmpa ADO2CL_AdvanceAddedFromO2FeedbackCounterLimitLow    ; compare a with memory contents (data is 1a)
           bge  SparkAdvance_NoThrottle    ; branch if greater or equal
           cmpa ADO2CH_AdvanceAddedFromO2FeedbackCounterLimitHi    ; compare a with memory contents (data is e6)
           ble  SparkAdvance_NoThrottle    ; branch if less or equal
           ldx  #ADO2C2_AdvanceAddedFromO2FeedbackCounter2    ; load index with value
           brset *BitFlags_AIS, #b10_ATXInGear, LCFBA    ; branch if bit(s) set
           ldx  #ADO2C1_AdvanceAddedFromO2FeedbackCounter1    ; load index with value
   LCFBA:  adda #0x80          ;  -10000000-
           jsr  Lookup4ByteTable    ; call subroutine
           staa O2AdvanceIncrement
           adda Temp0      
           bvc  LCFCE          ; branch if overflow
           bpl  LCFCC          ; branch if plus (hi bit 0)
           ldaa #0x7f          ; load a with value -01111111-
           bra  LCFCE          ; branch

   LCFCC:  ldaa #0x80          ; load a with value -10000000-
   LCFCE:  staa Temp0          ; store a into memory
SparkAdvance_NoThrottle:
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb PNRPM_EngineSpeedBelowWhich_PNIDLE_Enabled    ; compare b with memory contents (data is 01)
           bhi  DetermineMechanicalAdvanceFromRpm    ; branch if higher
           brset *BitFlags_AIS, #b10_ATXInGear, DetermineMechanicalAdvanceFromRpm    ; branch if bit(s) set
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #PNIDLE_AdvanceRemovedIdleParkNeutral    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           adda Temp0      
           bra  LD02A          ; branch

DetermineHotAdvanceFromMap:
           brclr *BitFlags66, #b66_OffIdle, LCF9C    ; branch if bit(s) clear
           ldx  #WOTMAP_AdvanceFromMAPWarmFull    ; load index with value
           jsr  SparkAdvance_GetAdvanceFromTableUsingMap    ; call subroutine
           brset *BitFlags66, #b66_FullThrottle, LD01C    ; branch if bit(s) set
           staa Temp0          ; store a into memory
           ldx  #HOTMAP_AdvanceFromMAPWarmPart    ; load index with value
           ldaa MapValue       ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp1          ; store a into memory
           ldx  #ADVCLS_AdvanceAddedForClosedLoopFromTimer    ; load index with value
           ldaa Timer_OpenLoopFraction    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           adda Temp1      
           bvc  LD016          ; branch if overflow
           tsta                ; test a
           bpl  LD014          ; branch if plus (hi bit 0)
           ldaa #0x7f          ; load a with value -01111111-
           bra  LD016          ; branch

   LD014:  ldaa #0x80          ; load a with value -10000000-
   LD016:  bsr  IncludeAdaptiveRetard    ; call subroutine
           cmpa Temp0          ; compare a with memory contents
           bge  LD01E          ; branch if greater or equal

   LD01C:  suba NO2Retard ; 

           staa Temp0          ; store a into memory
   LD01E:  ldx  #RPMLMT_LimitForHotMAPAdvance    ; load index with value
           ldaa EngineRpm_HB    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           cmpa Temp0          ; compare a with memory contents
           bgt  DetermineMechanicalAdvanceFromRpm    ; branch if greater
   LD02A:  staa Temp0          ; store a into memory
DetermineMechanicalAdvanceFromRpm:
           ldx  #GOVNER_AdvanceFromRPM    ; load index with value
           ldaa EngineRpm_HB    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           ldab MapValue       ; load b with memory contents
           cmpb ARMPIC_AdaptiveRetard_MinMAPForAdjustment    ; compare b with memory contents (data is 79)
           bls  LD051          ; branch if lower or same
           staa Temp1          ; store a into memory
           ldx  #ARRPM_AdaptiveRetardFromRPM    ; load index with value
           ldaa EngineRpm_HB    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           ldab AdaptiveRetardIndex    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           tab                 ; b = a
           ldaa Temp1          ; load a with memory contents
           sba                 ; subtract (a=a-b)
           bcc  LD051          ; branch if greater or equal
           clra                ; a = 0
   LD051:  cmpa ADVDFT_DefaultSparkAdvance1    ; compare a with memory contents (data is 14)
           bcc  LD05D          ; branch if greater or equal
           brset *BitFlags66, #b66_OffIdle, LD05D    ; branch if bit(s) set
           ldaa ADVDFT_DefaultSparkAdvance1    ; load a with memory contents (data is 14)
   LD05D:  adda Temp0      
           bpl  CheckMaxSparkAdvance    ; branch if plus (hi bit 0)
           clra                ; a = 0
CheckMaxSparkAdvance:
           staa Temp0          ; store a into memory
           ldx  #SPKLMT_TotalAdvanceAllowed    ; load index with value
           ldaa EngineRpm_HB    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           cmpa Temp0          ; compare a with memory contents
           bcs  STORE_SPARK_ADV    ; branch if lower
           ldaa Temp0          ; load a with memory contents
STORE_SPARK_ADV:
           staa CalculatedSparkAdvance    ; store a into memory
           rts                 ; return from subroutine

SparkAdvance_GetAdvanceFromTableUsingMap:
           ldaa MapValue       ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
IncludeAdaptiveRetard:
           ldab MapValue       ; load b with memory contents
           cmpb ARMPIC_AdaptiveRetard_MinMAPForAdjustment    ; compare b with memory contents (data is 79)
           bls  IncludeMAPAdvMultiplier    ; branch if lower or same
           staa Temp1          ; store a into memory
           ldaa MapValue       ; load a with memory contents
           ldx  #ARMAP_AdaptiveRetardFromMAP    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldab AdaptiveRetardIndex    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           tab                 ; b = a
           ldaa Temp1          ; load a with memory contents
           sba                 ; subtract (a=a-b)
           bvc  IncludeMAPAdvMultiplier    ; branch if overflow
           ldaa #0x80          ; load a with value -10000000-
IncludeMAPAdvMultiplier:
           staa Temp2          ; store a into memory
           tsta                ; test a
           bpl  LD0BB          ; branch if plus (hi bit 0)
           nega                ; negate a (set high bit)
           staa Temp1          ; store a into memory
           ldaa EngineRpm_HB    ; load a with memory contents
           ldx  #MAPMUL_MultiplierOnMapAdvanceWhenRetarding_FromRpm    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp1          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           asld                ; shift left (d=d*2)
           bmi  LD0B7          ; branch if minus(hi bit 1)
           asld                ; shift left (d=d*2)
           bmi  LD0B7          ; branch if minus(hi bit 1)
           tstb            
           bpl  LD0BA          ; branch if plus (hi bit 0)
           inca                ; increment a
           bpl  LD0BA          ; branch if plus (hi bit 0)
   LD0B7:  ldaa #0x81          ; load a with value -10000001-
           rts                 ; return from subroutine

   LD0BA:  nega                ; negate a (set high bit)
   LD0BB:  rts                 ; return from subroutine

HandleSparkScatter:
           ldaa BitFlags6d     ; load a with memory contents
           oraa BitFlags66     ; OR a with memory contents
           bmi  LD0DD          ; branch if minus(hi bit 1)
           brclr *b5c_IPL1, #b5c_BadCoolantTemp, LD0CD    ; branch if bit(s) clear
           ldab SPKSET_ConstantSparkAdvanceWhenSettingBasicTiming    ; load b with memory contents (data is 0c)
           stab Temp5          ; store b into memory
           bra  LD0DD          ; branch

   LD0CD:  brset *BitFlags6b, #$%00010000, LD0DE    ; branch if bit(s) set
           ldaa BitFlags_AIS    ; load a with memory contents
           anda #b10_ATXChngGear          ; AND a with value -00000100-
           oraa Timer_CountdownFromStartRunForAisFeedback    ; OR a with memory contents
           bne  LD0DD          ; branch if not equal (not zero)
           brclr *BitFlags67, #b67_FallToIdle, LD0DE    ; branch if bit(s) clear
   LD0DD:  rts                 ; return from subroutine

   LD0DE:  brclr *b5c_IPL1, #b5c_MapStuck | b5c_MapBadSignal, LD0E4    ; branch if bit(s) clear
           jmp  DontUseSparkScatter    ; branch

   LD0E4:  ldab CoolantTemp    ; load b with memory contents
           cmpb SSTEMP_TempAboveWhichSparkScatterIsActive    ; compare b with memory contents (data is 58)
           bls  DontUseSparkScatter    ; branch if lower or same
           ldx  KeyOnOrEngineRunningTime
           cpx  SSITIM_ScatterInhibitTime    ;  (data is 0088)
           bcs  DontUseSparkScatter    ; branch if lower
           ldx  TimerOverflowsBetweenDistPulses
           cpx  SSIPRD_ScatterInhibitBelowThisSpeed    ;  (data is 0066)
           bcc  DontUseSparkScatter    ; branch if greater or equal
           ldx  #SPKRET_SparkAdvanceRetardedWhenRpmAboveControl_FromDeltaRpm    ; load index with value
           brset *BitFlags_AIS, #b10_ATXInGear, LD103    ; branch if bit(s) set
           ldx  #SPKRT2_SparkAdvanceRetardedWhenRpmAboveControl2_FromDeltaRpm    ; load index with value
   LD103:  ldd  FilteredEngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  LD118          ; branch if greater or equal
           ldx  #SPKADD_SparkAdvanceAddedWhenRpmBelowControl_FromDeltaRpm    ; load index with value
           brset *BitFlags_AIS, #b10_ATXInGear, LD113    ; branch if bit(s) set
           ldx  #SPKAD2_SparkAdvanceAddedWhenRpmBelowControl2_FromDeltaRpm    ; load index with value
   LD113:  coma            
           comb            
           addd #L0001         ;  -00000000 00000001-
   LD118:  lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           bcc  LD121          ; branch if greater or equal
           addd #L0001         ;  -00000000 00000001-
   LD121:  tsta                ; test a
           beq  LD126          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   LD126:  tba                 ; a = b
           jsr  Lookup4ByteTable    ; call subroutine
           staa SparkScatterIncrement
           addb CalculatedSparkAdvance    ; b=b+memory contents
           stab Temp5          ; store b into memory
           stab CalculatedSparkAdvanceTemp    ; store b into memory
           bset *BitFlags6e, #b6e_UseSparkScatter    ; set bits
           brset *Turbonator_Flags, #Turbonator_DecelFuelCut, DontUseSparkScatter    ; branch if bit(s) set
           adda SparkScatter
           bvc  DoUseSparkScatter    ; branch if overflow
           ldab DesiredNewAisPosition    ; load b with memory contents
           cmpb CurrentAisPosition
           bne  DontUseSparkScatter    ; branch if not equal (not zero)
           ldab FTUNPW_FineTuneStepForAis    ; load b with memory contents (data is 01)
           beq  DontUseSparkScatter    ; branch if equal (zero)
           tsta                ; test a
           bmi  LD155          ; branch if minus(hi bit 1)
           ldaa DesiredNewAisPosition    ; load a with memory contents
           sba                 ; subtract (a=a-b)
           bcc  SaveDesiredAisPosition    ; branch if greater or equal
           clra                ; a = 0
           bra  SaveDesiredAisPosition    ; branch

   LD155:  ldaa AISHLM_AisHighLimitMaxOpenSteps    ; load a with memory contents (data is a0)
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
           staa SparkScatter    ; store a into memory
           ldaa DRBPointer1    ; load a with memory contents
           cmpa #0x14          ; compare a with value -00010100-
           bne  LD179          ; branch if not equal (not zero)
           ldaa DRBPointer2    ; load a with memory contents
           cmpa #0x10          ; compare a with value -00010000-
           bne  LD179          ; branch if not equal (not zero)
           ldab IDLSET_ConstantSparkAdvanceWhenSettingMinThrottleOpening    ; load b with memory contents (data is 0c)
           stab Temp5          ; store b into memory
           bclr *BitFlags6e, #b6e_UseSparkScatter    ; clear bits
   LD179:  rts                 ; return from subroutine

InterruptVector_DwellTimer:
           ldaa #0x08          ; load a with value -00001000-
           staa CPU_TimerInterruptFlag1
           ldaa TimerOverflowsBetweenDistPulses    ; load a with memory contents
           bne  LD1A6          ; branch if not equal (not zero)
           brset *BitFlags6d, #b6d_DisableNormalDwell, LD1A6    ; branch if bit(s) set
           brclr *BitFlags68, #b68_BladePassedSensor, LD1A6    ; branch if bit(s) clear
           brset *BitFlags70, #b70_AlternatorField, LD1A6    ; branch if bit(s) set
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           eora #0x01          ; XOR a with value -00000001-
           staa CPU_TimerControlReg1
           lsra            
           bcs  IgnitionCoil_OnTimeLoad    ; branch if lower
           ldd  CPU_TimerControlReg1
           bitb #0x10          ;  -00010000-
           bne  IgnitionCoil_OffTimeLoad    ; branch if not equal (not zero)
           oraa #0x01          ;  -00000001-
           staa CPU_TimerControlReg1
   LD1A6:  rti                 ; return from interrupt

IgnitionCoil_OnTimeLoad:
           ldd  AntiDwellTime_HB    ; load d (a&b) with memory contents
           bra  LD1AF          ; branch

IgnitionCoil_OffTimeLoad:
           ldd  DistributorFallingEdgePulsewidth_HB    ; load d (a&b) with memory contents
           subd AntiDwellTime_HB    ; d = d - memory contents
   LD1AF:  addd CPU_Timer_OC5_Dwell
           std  CPU_Timer_OC5_Dwell
           rti                 ; return from interrupt

CalculateKnockRetard_MM:
           clra                ; a = 0
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb KNKRPM_MinRpmforKnockRetard    ; compare b with memory contents (data is 20)
           bcs  StoreMaxAllowedRetard    ; branch if lower
           deca                ; decrement a
           ldab b5c_IPL1       ; load b with memory contents
           andb #0xe0          ;  -11100000-
           bne  CalculateMaxAllowedRetard    ; branch if not equal (not zero)
           ldaa MapValue       ; load a with memory contents
           ldab TpsVolts       ; load b with memory contents
           subb MINTHR_LowestSessionTPS    ; b = b-memory contents
           bcs  CalculateMaxAllowedRetard    ; branch if lower
           cmpb THRKNK_DeltaAbove_MINTHR    ; compare b with memory contents (data is 53)
           bcs  CalculateMaxAllowedRetard    ; branch if lower
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb KLMRPM_MinKnockDetectRpm    ; compare b with memory contents (data is 20)
           bcc  CalculateMaxAllowedRetard    ; branch if greater or equal
           ldaa KNKLIM_MaxKnockRetard    ; load a with memory contents (data is 06)
           bra  StoreMaxAllowedRetard    ; branch

CalculateMaxAllowedRetard:
           ldx  #RETMAX_MaxKnockRetardFromMap    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
StoreMaxAllowedRetard:
           staa MaxRetardFromMAP    ; store a into memory
           ldaa EngineRpm_HB    ; load a with memory contents
           ldx  #DLTKNK_KnockFromRpms    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa KnockSensorThreshold    ; store a into memory
           ldaa Counter_MainLoop    ; load a with memory contents
           bita INCSRT_KnockRetardIncreaseRate    ;  (data is 1f)
           bne  LD209          ; branch if not equal (not zero)
           ldx  #Cylinder2Retard    ; load index with value
ReduceAllRetardsByOne:
           sei                 ; disable interrupts
           ldaa 0x00, X        ; load a with memory at index + value
           beq  LD202          ; branch if equal (zero)
           deca                ; decrement a
           staa 0x00, X    
   LD202:  cli                 ; enable interrupts
           inx                 ; increment index (x=x+1)
           cpx  #Cylinder4Retard    ;  -00000000 11000110-
           bls  ReduceAllRetardsByOne    ; branch if lower or same
   LD209:  rts                 ; return from subroutine

DetermineIfSpeedoSensorOnOrOff:
           ldaa CPU_TimerControlReg2    ; load a with memory contents
           lsra            
           eora CPU_PortA  
           bita #0x02          ;  -00000010-
           rts                 ; return from subroutine

Interrupt_SpeedometerSignal:
           ldd  CPU_TimerInputCapture2_Speedometer
           stD *Temp5          ; store D to RAM
           bsr  DetermineIfSpeedoSensorOnOrOff    ; call subroutine
           beq  LD227          ; branch if equal (zero)
           fdiv            
           bsr  DetermineIfSpeedoSensorOnOrOff    ; call subroutine
           beq  LD227          ; branch if equal (zero)
           fdiv            
           bsr  DetermineIfSpeedoSensorOnOrOff    ; call subroutine
           bne  JumpTo_ResetSpeedometerInterruptFlag    ; branch if not equal (not zero)
   LD227:  ldd  Counter_SpeedSensorInterrupt    ; load d (a&b) with memory contents
           addd #L0001         ;  -00000000 00000001-
           stD *Counter_SpeedSensorInterrupt    ; store D to RAM
           bne  LD233          ; branch if not equal (not zero)
           bset *b5d_IPL2, #b5d_bit0    ; set bits
   LD233:  inc  Counter_SpeedSensorInterrupt_HB_X
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           subd #0x0640        ;  -00000110 01000000-
           ldaa BitFlags6f     ; load a with memory contents
           bcc  LD25D          ; branch if greater or equal
           bita #b6f_BadSpeedo1          ;  -00010000-
           bne  LD247          ; branch if not equal (not zero)
           oraa #b6f_BadSpeedo1          ;  -00010000-
           bra  LD261          ; branch

   LD247:  anda #0x1f          ; AND a with value -00011111-
           oraa #b6f_BadSpeedo2          ;  -00001000-
           staa BitFlags6f     ; store a into memory
           clra                ; a = 0
           staa CruiseControlVar4    ; store a into memory
           staa Counter_SomethingWithDistributor    ; store a into memory
           staa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; store a into memory
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           addd #0x0053    ;  -00000000 01010011-
           stD *VehicleSpeed_HB    ; store D to RAM
JumpTo_ResetSpeedometerInterruptFlag:
           bra  ResetSpeedometerInterruptFlag    ; branch

   LD25D:  bita #b6f_BadSpeedo1          ;  -00010000-
           bne  LD2CC          ; branch if not equal (not zero)
   LD261:  adda #b6f_bit5          ;  -00100000-
           bcs  LD26B          ; branch if lower
           anda #~b6f_BadSpeedo1          ; AND a with value -11101111-
           staa BitFlags6f     ; store a into memory
           bra  ResetSpeedometerInterruptFlag    ; branch

   LD26B:  staa BitFlags6f     ; store a into memory
           ldab CruiseControlVar4    ; load b with memory contents
           beq  LD28E          ; branch if equal (zero)
           bita #b6f_BadSpeedo2          ;  -00001000-
           bne  LD28E          ; branch if not equal (not zero)
           ldaa #0x3a          ; load a with value -00111010-
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           cmpa #0x03          ; compare a with value -00000011-
           bcc  LD280          ; branch if greater or equal
           ldaa #0x03          ; load a with value -00000011-
   LD280:  tab                 ; b = a
           ldaa Counter_SomethingWithDistributor    ; load a with memory contents
           suba CruiseControlVar4
           bcc  LD288          ; branch if greater or equal
           nega                ; negate a (set high bit)
   LD288:  sba                 ; subtract (a=a-b)
           bcs  LD292          ; branch if lower
           bset *BitFlags6f, #b6f_BadSpeedo2    ; set bits
   LD28E:  ldab Counter_SomethingWithDistributor    ; load b with memory contents
           stab CruiseControlVar4    ; store b into memory
   LD292:  clra                ; a = 0
           staa Counter_SomethingWithDistributor    ; store a into memory
           ldd  Temp5          ; load d (a&b) with memory contents
           bsr  DetermineNumberOfOverflowsBetweenSpeedoPulses_MM    ; call subroutine
           ldaa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; load a with memory contents
           lsra            
           tab                 ; b = a
           oraa TimerOverflowsBetweenSpeedoPulses    ; OR a with memory contents
           beq  LD2A9          ; branch if equal (zero)
           stab TimerOverflowsBetweenSpeedoPulses    ; store b into memory
           ldd  Temp5          ; load d (a&b) with memory contents
           subd PreviousVehicleSpeed_HB    ; d = d - memory contents
           bra  LD2BD          ; branch

   LD2A9:  ldd  Temp5          ; load d (a&b) with memory contents
           subd PreviousVehicleSpeed_HB    ; d = d - memory contents
           subd SpeedoSensorPulsewidth_HB    ; d = d - memory contents
           beq  LD2BF          ; branch if equal (zero)
           asra            
           rorb            
           asra            
           rorb            
           subd #L0000         ;  -00000000 00000000-
           bne  LD2BB          ; branch if not equal (not zero)
           incb            
   LD2BB:  addd SpeedoSensorPulsewidth_HB    ; d = d + memory contents
   LD2BD:  stD *SpeedoSensorPulsewidth_HB    ; store D to RAM
   LD2BF:  ldd  Temp5          ; load d (a&b) with memory contents
           stD *PreviousVehicleSpeed_HB    ; store D to RAM
           clra                ; a = 0
           staa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; store a into memory
ResetSpeedometerInterruptFlag:
           ldaa #0x02          ; load a with value -00000010-
           staa CPU_TimerInterruptFlag1
           rti                 ; return from interrupt

   LD2CC:  anda #~b6f_BadSpeedo1          ; AND a with value -11101111-
           staa BitFlags6f     ; store a into memory
           ldaa #0x01          ; load a with value -00000001-
           staa TimerOverflowsBetweenSpeedoPulses    ; store a into memory
           ldd  #0x1940        ; load d (a&b) with value -00011001 01000000-
           bra  LD2BD          ; branch

        

DetermineNumberOfOverflowsBetweenSpeedoPulses_MM:
           subd PreviousVehicleSpeed_HB    ; d = d - memory contents
           staa Temp7          ; store a into memory
           ldaa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; load a with memory contents
           lsrd                ; shift right (d=d/2)
           eorb Temp7      
           bpl  LD2F4          ; branch if plus (hi bit 0)
           ldaa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; load a with memory contents
           inca                ; increment a
           beq  LD2EB          ; branch if equal (zero)
           staa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; store a into memory
   LD2EB:  ldaa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; load a with memory contents
           lsra            
           cmpa TimerOverflowsBetweenSpeedoPulses    ; compare a with memory contents
           bls  LD2F4          ; branch if lower or same
           staa TimerOverflowsBetweenSpeedoPulses    ; store a into memory
   LD2F4:  rts                 ; return from subroutine

ControlCruiseServo1_MM:
           brclr *BitFlags6f, #b6f_BadSpeedo1, LD30A    ; branch if bit(s) clear
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
   LD30A:  ldaa Timer_CountdownFromStartRunForAisFeedback    ; load a with memory contents
           beq  LD320          ; branch if equal (zero)
           brclr *BitFlags6d, #b6d_JustStarted, LD319    ; branch if bit(s) clear
           clra                ; a = 0
           ldx  EngineRpm_HB
           cpx  TargetIdleSpeedHB
           bls  LD31C          ; branch if lower or same
   LD319:  ldaa Timer_CountdownFromStartRunForAisFeedback    ; load a with memory contents
           deca                ; decrement a
   LD31C:  staa Timer_CountdownFromStartRunForAisFeedback    ; store a into memory
           bra  LD323          ; branch

   LD320:  bset *BitFlags6d, #b6d_JustStarted    ; set bits
   LD323:  brclr *BitFlags66, #b66_OffIdle, LD32B    ; branch if bit(s) clear
   LD327:  bclr *BitFlags67, #b67_FallToIdle | b67_IdleSpeedMode    ; clear bits
           rts                 ; return from subroutine

   LD32B:  ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           ldab MPHREF_SwitchPointForDecelIdleAisControl    ; load b with memory contents (data is 07)
           brset *BitFlags67, #b67_IdleSpeedMode, LD340    ; branch if bit(s) set
           brset *BitFlags67, #b67_FallToIdle, LD340    ; branch if bit(s) set
           addb #0x03          ;  -00000011-
   LD340:  cba             
           bls  LD327          ; branch if lower or same
           ldab CONFIG_ConfigurationFlags    ; load b with memory contents (data is 9f)
           bitb #cfg_ATX          ;  -00100000-
           bne  LD36F          ; branch if not equal (not zero)
           ldab AISMPH_RollingAisMaxSpeed    ; load b with memory contents (data is 10)
           brclr *BitFlags67, #b67_IdleSpeedMode, LD353    ; branch if bit(s) clear
           addb #0x03          ;  -00000011-
   LD353:  cba             
           bhi  LD36F          ; branch if higher
           ldd  TargetIdleSpeedHB    ; load d (a&b) with memory contents
           addd RPMDLT_RollingAisMinRpm    ;  (data is 07)
           cmpD EngineRpm_HB    ; compare D
           bcs  LD36F          ; branch if lower
           brset *BitFlags67, #b67_IdleSpeedMode, LD368    ; branch if bit(s) set
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           stD *TargetIdleSpeedHB    ; store D to RAM
   LD368:  bclr *BitFlags67, #b67_FallToIdle    ; clear bits
           bset *BitFlags67, #b67_IdleSpeedMode    ; set bits
           rts                 ; return from subroutine

   LD36F:  bset *BitFlags67, #b67_FallToIdle    ; set bits
           bclr *BitFlags67, #b67_IdleSpeedMode    ; clear bits
           rts                 ; return from subroutine

ControlCruiseServo0_MM:
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           staa Temp0          ; store a into memory
           ldaa TimerOverflowsBetweenDistPulses    ; load a with memory contents
           bne  LD39A          ; branch if not equal (not zero)
           ldab Temp0          ; load b with memory contents
           ldaa DistributorFallingEdgePulsewidth_HB    ; load a with memory contents
           mul                 ; multiply (d=a*b)
           xgDY                ; exchange D and Y
           ldaa #0x11          ; load a with value -00010001-
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           tsta                ; test a
           beq  LD397          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   LD397:  stab ScaledDistPWForCruiseControl    ; store b into memory
   LD39A:  bclr *Counter_Cruise_1, #$%00001111    ; clear bits
           brset *StartupSwitchMirror1, #sw1_CruiseOnOff, LD3A6    ; branch if bit(s) set
           clrb                ; b = 0
           stab CruiseSpeedSetpoint    ; store b into memory
           bra  LD3FE          ; branch

   LD3A6:  inc  Counter_Cruise_1
           ldaa Temp0          ; load a with memory contents
           cmpa CRUZ21_UknownConstForCruiseControl21    ; compare a with memory contents (data is 3c)
           bcs  DropOutOfCruise          ; branch if lower
           inc  Counter_Cruise_1
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa CRUZ22_UknownConstForCruiseControl22    ; compare a with memory contents (data is bc)
           bcc  DropOutOfCruise          ; branch if greater or equal
           inc  Counter_Cruise_1
           brset *StartupSwitchMirror1, #sw1_Brake, DropOutOfCruise    ; branch if bit(s) set
           inc  Counter_Cruise_1
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_ATX          ;  -00100000-
           beq  LD3D7          ; branch if equal (zero)
           brclr *StartupSwitchMirror1, #sw1_PNswitch, DropOutOfCruise    ; branch if bit(s) clear
           inc  Counter_Cruise_1
           inc  Counter_Cruise_1
           bra  LD432          ; branch

   LD3D7:  inc  Counter_Cruise_1
           ldaa TimerOverflowsBetweenDistPulses    ; load a with memory contents
           bne  LD3EB          ; branch if not equal (not zero)
           ldab ScaledDistPWForCruiseControl    ; load b with memory contents
           cmpb SCNVHI_CruiseControlForBrakeFlagManualTransmissionClutchDisableHi    ; compare b with memory contents (data is ff)
           bcc  DropOutOfCruise          ; branch if greater or equal
           cmpb SCNVLO_CruiseControlForBrakeFlagManualTransmissionClutchDisableLo    ; compare b with memory contents (data is 52)
           bcs  DropOutOfCruise          ; branch if lower
   LD3EB:  inc  Counter_Cruise_1
           brset *CruiseStatus_1, #$%10000000, LD432    ; branch if bit(s) set
           brclr *BitFlags6f, #b6f_BadSpeedo2, LD432    ; branch if bit(s) clear

DropOutOfCruise:
           brclr *CruiseStatus_1, #$%00011000, LD3FE    ; branch if bit(s) clear
           ldaa Temp0          ; load a with memory contents
           staa CruiseSpeedSetpoint    ; store a into memory
   LD3FE:  brset *CruiseStatus_1, #$%10000000, LD40B    ; branch if bit(s) set
           ldab Counter_Cruise_1    ; load b with memory contents
           andb #0x0f          ;  -00001111-
           ldaa #0x11          ; load a with value -00010001-
           mul                 ; multiply (d=a*b)
           stab Counter_Cruise_1    ; store b into memory
   LD40B:  clrb                ; b = 0
           stab Counter_Cruise_2    ; store b into memory
           stab Counter_Cruise_3    ; store b into memory
           stab CruiseControlVar0    ; store b into memory
           stab Counter_Cruise    ; store b into memory
           stab CruiseControlVar6    ; store b into memory
           stab CruiseControlVar2    ; store b into memory
           bclr *CruiseStatus_1, #$%00011111    ; clear bits
           bset *CruiseStatus_1, #$%10100000    ; set bits
           bclr *CruiseStatus_2, #$%00001111    ; clear bits
           brset *StartupSwitchMirror1, #sw1_CruiseOnOff, LD42C    ; branch if bit(s) set
           ldaa CRUZ7_UknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           bita #0x80          ;  -10000000-
           bne  LD42F          ; branch if not equal (not zero)
   LD42C:  bset *Counter_Cruise_2, #$%10000000    ; set bits
   LD42F:  jmp  LD60F      

   LD432:  inc  Counter_Cruise_1
           ldaa #0xc0          ; load a with value -11000000-
           ldab #0xff          ; load b with value -11111111-
           jsr  SetPIAOutputBits    ; call subroutine
           staa Temp1          ; store a into memory
           eora PIA2_Buffer
           anda #pi2_SCVent | pi2_SCVac          ; AND a with value -00000011-
           beq  LD493          ; branch if equal (zero)
           bita #0x01          ;  -00000001-
           bne  LD449          ; branch if not equal (not zero)
           lsrb                ; logical shift right b
   LD449:  ldaa #0x00          ; load a with value -00000000-
           bitb #0x01          ;  -00000001-
           bne  LD483          ; branch if not equal (not zero)
           brset *CruiseStatus_1, #$%10000000, LD479    ; branch if bit(s) set
           ldaa Temp0          ; load a with memory contents
           psha                ; push a onto stack
           ldd  #0x0f89        ; load d (a&b) with value -00001111 10001001-
           jsr  ThrowNonCriticalError    ; call subroutine
           pula                ; pull a from stack
           staa Temp0          ; store a into memory
           ldd  #0x0f08        ; load d (a&b) with value -00001111 00001000-
           ldx  #ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB    ; load index with value
           cmpa 0x00, X        ; compare a with memory at index + value
           beq  LD46E          ; branch if equal (zero)
           inx                 ; increment index (x=x+1)
           cmpa 0x00, X        ; compare a with memory at index + value
           bne  LD493          ; branch if not equal (not zero)
   LD46E:  cmpb 0x02, X    
           bne  LD493          ; branch if not equal (not zero)
           clr  0x00, X    
           clr  0x02, X    
           jmp  DropOutOfCruise

   LD479:  ldaa #0x07          ; load a with value -00000111-
           ldab Temp1          ; load b with memory contents
           bitb #0x03          ;  -00000011-
           bne  LD483          ; branch if not equal (not zero)
           ldaa #0x7f          ; load a with value -01111111-
   LD483:  bita Counter_MainLoop
           bne  LD493          ; branch if not equal (not zero)
           ldaa Temp0          ; load a with memory contents
           psha                ; push a onto stack
           ldd  #0x0f10        ; load d (a&b) with value -00001111 00010000-
           jsr  ThrowNonCriticalError    ; call subroutine
           pula                ; pull a from stack
           staa Temp0          ; store a into memory
   LD493:  inc  Counter_Cruise_1
           ldaa CRUZ7_UknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           bita #0x80          ;  -10000000-
           beq  LD4A5          ; branch if equal (zero)
           brset *CruiseStatus_1, #$%00000001, LD4A5    ; branch if bit(s) set
           brclr *StartupSwitchMirror1, #sw1_CruiseResume, LD50E    ; branch if bit(s) clear
   LD4A5:  brset *StartupSwitchMirror1, #sw1_CruiseSet, LD50E    ; branch if bit(s) set
           ldab Counter_Cruise_2    ; load b with memory contents
           incb            
           bne  LD4AF          ; branch if not equal (not zero)
           decb
   LD4AF:  stab Counter_Cruise_2    ; store b into memory
           brset *CruiseStatus_1, #$%00000001, LD4D7    ; branch if bit(s) set
           brset *Counter_Cruise_2, #$%10000000, LD4EA    ; branch if bit(s) set
           cmpb #0x04          ;  -00000100-
           bls  LD4EA          ; branch if lower or same
           bset *CruiseStatus_1, #$%00100001    ; set bits
           bclr *CruiseStatus_1, #$%00001010    ; clear bits
           bset *CruiseStatus_2, #$%00000100    ; set bits
           clra                ; a = 0
           staa Counter_Cruise_3    ; store a into memory
           staa CruiseControlVar0    ; store a into memory
           ldaa CRUZ7_UknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           bita #0x80          ;  -10000000-
           bne  LD4EA          ; branch if not equal (not zero)
           bclr *CruiseStatus_1, #$%00000100    ; clear bits
           bra  LD4EA          ; branch

   LD4D7:  brset *CruiseStatus_1, #$%10000000, LD4EA    ; branch if bit(s) set
           brset *CruiseStatus_1, #$%00010000, LD4FC    ; branch if bit(s) set
           ldaa CRUZ7_UknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           bita #0x80          ;  -10000000-
           beq  LD4ED          ; branch if equal (zero)
           cmpb #0x38          ;  -00111000-
           bhi  LD4F2          ; branch if higher
   LD4EA:  jmp  LD734      

   LD4ED:  cmpb CRUZ46_UknownConstForCruiseControl46    ; compare b with memory contents (data is 09)
           bls  LD4EA          ; branch if lower or same
   LD4F2:  bset *CruiseStatus_1, #$%00010000    ; set bits
           bclr *CruiseStatus_2, #$%00000011    ; clear bits
           ldaa Temp0          ; load a with memory contents
           staa CruiseControlVar0    ; store a into memory
   LD4FC:  ldab CruiseStatus_2    ; load b with memory contents
           cmpb #0xa0          ;  -10100000-
           bcs  LD4EA          ; branch if lower
           ldab CruiseControlVar0    ; load b with memory contents
           subb CRUZ32_UknownConstForCruiseControl32    ; subtract memory contents from b (data is 08)
           bcc  LD50A          ; branch if greater or equal
           clrb                ; b = 0
   LD50A:  stab CruiseControlVar0    ; store b into memory
           bra  LD4EA          ; branch

   LD50E:  brclr *CruiseStatus_1, #$%00000001, LD579    ; branch if bit(s) clear
           ldaa #0x7f          ; load a with value -01111111-
           brset *CruiseStatus_1, #$%10000000, LD54F    ; branch if bit(s) set
           brset *CruiseStatus_2, #$%00001000, LD526    ; branch if bit(s) set
           ldab CruiseSpeedSetpoint    ; load b with memory contents
           subb Temp0          ; b = b-memory contents
           bcc  LD526          ; branch if greater or equal
           cmpb #0xfc          ;  -11111100-
           bcs  LD54F          ; branch if lower
   LD526:  brset *CruiseStatus_1, #$%00010000, LD534    ; branch if bit(s) set
           ldaa CRUZ7_UknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           anda #0x80          ; AND a with value -10000000-
           beq  LD555          ; branch if equal (zero)
           jmp  LD5E2      

   LD534:  ldaa Counter_Cruise_3    ; load a with memory contents
           ldab CRUZ31_UknownConstForCruiseControl31    ; load b with memory contents (data is 34)
           addb #0x80          ;  -10000000-
           bmi  LD544          ; branch if minus(hi bit 1)
           mul                 ; multiply (d=a*b)
           adca Counter_Cruise_3
           bcs  LD54B          ; branch if lower
           bra  LD547          ; branch

   LD544:  mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
   LD547:  cmpa #0x7f          ; compare a with value -01111111-
           bls  LD555          ; branch if lower or same
   LD54B:  ldaa #0x7f          ; load a with value -01111111-
           bra  LD555          ; branch

   LD54F:  bset *CruiseStatus_2, #$%00000001    ; set bits
           clrb                ; b = 0
           stab CruiseControlVar6    ; store b into memory
   LD555:  ldab Temp0          ; load b with memory contents
           stab CruiseSpeedSetpoint    ; store b into memory
           staa Temp2          ; store a into memory
           jsr  LD6EE          ; call subroutine
           ldab Temp2          ; load b with memory contents
           cba             
           bhi  LD564          ; branch if higher
           tab                 ; b = a
   LD564:  bclr *CruiseStatus_1, #$%10010001    ; clear bits
           bclr *CruiseStatus_2, #$%00001000    ; clear bits
           bclr *BitFlags6f, #b6f_BadSpeedo2    ; clear bits
           clra                ; a = 0
           staa Counter_Cruise_3    ; store a into memory
           staa Counter_Cruise_2    ; store a into memory
           staa CruiseControlVar0    ; store a into memory
           staa Counter_Cruise    ; store a into memory
           jmp  LD60F      

   LD579:  clrb                ; b = 0
           stab Counter_Cruise_2    ; store b into memory
           brset *StartupSwitchMirror1, #sw1_CruiseResume, LD583    ; branch if bit(s) set
           jmp  LD67F      

   LD583:  ldab Counter_Cruise_3    ; load b with memory contents
           incb            
           bne  LD589          ; branch if not equal (not zero)
           decb            
   LD589:  stab Counter_Cruise_3    ; store b into memory
           brclr *CruiseStatus_1, #$%00000010, LD592    ; branch if bit(s) clear
           jmp  LD62B      

   LD592:  brclr *CruiseStatus_1, #$%00100000, LD599    ; branch if bit(s) clear
           jmp  LD6CF      

   LD599:  cmpb #0x04          ;  -00000100-
           bhi  LD5A0          ; branch if higher
           jmp  LD734      

   LD5A0:  bset *CruiseStatus_1, #$%00000110    ; set bits
           bset *CruiseStatus_2, #$%00000100    ; set bits
           clra                ; a = 0
           staa Counter_Cruise    ; store a into memory
           brclr *CruiseStatus_1, #$%10000000, LD5E2    ; branch if bit(s) clear
           bset *CruiseStatus_1, #$%00100000    ; set bits
           bclr *CruiseStatus_1, #$%10000000    ; clear bits
           bclr *BitFlags6f, #b6f_BadSpeedo2    ; clear bits
           jsr  LD6EE          ; call subroutine
           staa Temp2          ; store a into memory
           ldaa CruiseSpeedSetpoint    ; load a with memory contents
           suba Temp0      
           bcc  LD5C4          ; branch if greater or equal
           tab                 ; b = a
           eorb #0x80          ;  -10000000-
   LD5C4:  bpl  LD5CB          ; branch if plus (hi bit 0)
           lsla                ; logical shift left a
           ldaa #0x80          ; load a with value -10000000-
           sbca #0x00          ;  -00000000-
   LD5CB:  adda #0x80          ;  -10000000-
           ldx  #RESTBL2_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference2    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           addb #0x80          ;  -10000000-
           addb Temp2          ; b=b+memory contents
           bpl  LD626          ; branch if plus (hi bit 0)
           bvc  LD5DF          ; branch if overflow
           ldab #0x7f          ; load b with value -01111111-
           bra  LD626          ; branch

   LD5DF:  clrb                ; b = 0
           bra  LD626          ; branch

   LD5E2:  bclr *CruiseStatus_2, #$%00000011    ; clear bits
           ldaa CruiseSpeedSetpoint    ; load a with memory contents
           adda #0x04          ;  -00000100-
           staa CruiseSpeedSetpoint    ; store a into memory
           ldab CruiseControlVar3    ; load b with memory contents
           suba #0x03          ;  -00000011-
           cmpa MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; compare a with memory contents (data is aa)
           bhi  LD605          ; branch if higher
           ldab CRUZ23_UknownConstForCruiseControl23    ; load b with memory contents (data is 06)
           ldaa CruiseControlVar3    ; load a with memory contents
           bmi  LD605          ; branch if minus(hi bit 1)
           aba                 ; a=a+b
           bcs  LD602          ; branch if lower
           cmpa #0x7f          ; compare a with value -01111111-
           bls  LD604          ; branch if lower or same
   LD602:  ldaa #0x7f          ; load a with value -01111111-
   LD604:  tab                 ; b = a
   LD605:  ldaa CRUZ7_UknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           bita #0x80          ;  -10000000-
           beq  LD60F          ; branch if equal (zero)
           jmp  LD564      

   LD60F:  ldaa CruiseSpeedSetpoint    ; load a with memory contents
           cmpa MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; compare a with memory contents (data is aa)
           bls  LD61E          ; branch if lower or same
           bclr *CruiseStatus_2, #$%00000011    ; clear bits
           ldaa MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; load a with memory contents (data is aa)
           bra  LD624          ; branch

   LD61E:  cmpa MINSET_CruiseControlMinSetSpeedTimesTwo    ; compare a with memory contents (data is 46)
           bcc  LD626          ; branch if greater or equal
           clra                ; a = 0
   LD624:  staa CruiseSpeedSetpoint    ; store a into memory
   LD626:  stab CruiseControlVar3    ; store b into memory
   LD628:  jmp  LD734      

   LD62B:  brset *CruiseStatus_1, #$%00100000, LD628    ; branch if bit(s) set
           brset *CruiseStatus_1, #$%00001000, LD649    ; branch if bit(s) set
           cmpb CRUZ47_UknownConstForCruiseControl47    ; compare b with memory contents (data is 2f)
           bls  LD628          ; branch if lower or same
           bset *CruiseStatus_1, #$%00001000    ; set bits
           bset *CruiseStatus_2, #$%00001000    ; set bits
           ldaa Temp0          ; load a with memory contents
           adda CRUZ34_UknownConstForCruiseControl34    ;  (data is 20)
           bcc  LD647          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LD647:  staa CruiseControlVar0    ; store a into memory
   LD649:  ldaa Temp0          ; load a with memory contents
           cmpa MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; compare a with memory contents (data is aa)
           bcs  LD657          ; branch if lower
           bset *CruiseStatus_1, #$%00100000    ; set bits
           ldab CruiseControlVar3    ; load b with memory contents
           bra  LD6B9          ; branch

   LD657:  ldab CruiseStatus_2    ; load b with memory contents
           cmpb #0xa0          ;  -10100000-
           bcs  LD628          ; branch if lower
           ldab CruiseControlVar0    ; load b with memory contents
           subb CRUZ33_UknownConstForCruiseControl33    ; subtract memory contents from b (data is 01)
           bcc  LD665          ; branch if greater or equal
           clrb                ; b = 0
   LD665:  cmpb MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; compare b with memory contents (data is aa)
           bcc  LD67B          ; branch if greater or equal
           adda CRUZ35_UknownConstForCruiseControl35    ;  (data is 0c)
           bcs  LD678          ; branch if lower
           cba             
           bls  LD67B          ; branch if lower or same
           tab                 ; b = a
           cmpb MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; compare b with memory contents (data is aa)
           bls  LD67B          ; branch if lower or same
   LD678:  ldab MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; load b with memory contents (data is aa)
   LD67B:  stab CruiseControlVar0    ; store b into memory
           bra  LD628          ; branch

   LD67F:  bclr *CruiseStatus_1, #$%00000010    ; clear bits
           brset *CruiseStatus_1, #$%10000000, LD68D    ; branch if bit(s) set
           ldaa CRUZ7_UknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           bita #0x80          ;  -10000000-
           bne  LD6CF          ; branch if not equal (not zero)
   LD68D:  ldaa CruiseSpeedSetpoint    ; load a with memory contents
           beq  LD694          ; branch if equal (zero)
           bclr *CruiseStatus_1, #$%00100000    ; clear bits
   LD694:  brclr *CruiseStatus_1, #$%00001000, LD6CF    ; branch if bit(s) clear
           ldaa Counter_Cruise_3    ; load a with memory contents
           cmpa #0x5d          ; compare a with value -01011101-
           bhi  LD6A8          ; branch if higher
           bclr *CruiseStatus_1, #$%00001000    ; clear bits
           bclr *CruiseStatus_2, #$%00001000    ; clear bits
           stab CruiseControlVar0    ; store b into memory
           bra  LD6CF          ; branch

   LD6A8:  ldaa Temp0          ; load a with memory contents
           adda #0x04          ;  -00000100-
           suba CruiseSpeedSetpoint
           bcc  LD6B1          ; branch if greater or equal
           clra                ; a = 0
   LD6B1:  ldx  #CRUZ6_UknownTableForCruiseControl6    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           orab #0x80          ;  -10000000-
   LD6B9:  ldaa Temp0          ; load a with memory contents
           staa CruiseSpeedSetpoint    ; store a into memory
           bclr *CruiseStatus_1, #$%00001100    ; clear bits
           bclr *CruiseStatus_2, #$%00001000    ; clear bits
           clra                ; a = 0
           staa CruiseControlVar0    ; store a into memory
           staa Counter_Cruise_3    ; store a into memory
           tstb            
           bmi  LD6CC          ; branch if minus(hi bit 1)
           clrb                ; b = 0
   LD6CC:  jmp  LD60F      

   LD6CF:  clrb                ; b = 0
           stab Counter_Cruise_3    ; store b into memory
           ldaa CruiseStatus_2    ; load a with memory contents
           eora #0x04          ; XOR a with value -00000100-
           bita #0x07          ;  -00000111-
           bne  LD734          ; branch if not equal (not zero)
           ldaa Counter_MainLoop    ; load a with memory contents
           bne  LD734          ; branch if not equal (not zero)
           ldab Counter_Cruise    ; load b with memory contents
           incb            
           cmpb CRUZ26_UknownConstForCruiseControl26    ; compare b with memory contents (data is 02)
           bcs  LD6EA          ; branch if lower
           bclr *CruiseStatus_2, #$%00000100    ; clear bits
           clrb                ; b = 0
   LD6EA:  stab Counter_Cruise    ; store b into memory
           bra  LD734          ; branch

   LD6EE:  ldaa CruiseSpeedSetpoint    ; load a with memory contents
           ldx  #SETPW_CruiseControlSetupPulseForSet_FromSpeed    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           bpl  LD6FA          ; branch if plus (hi bit 0)
           ldab #0x7f          ; load b with value -01111111-
   LD6FA:  stab Temp1          ; store b into memory
           ldaa MapValue       ; load a with memory contents
           suba BaroPressure
           bcc  LD705          ; branch if greater or equal
           tab                 ; b = a
           eorb #0x80          ;  -10000000-
   LD705:  bpl  LD70C          ; branch if plus (hi bit 0)
           lsla                ; logical shift left a
           ldaa #0x80          ; load a with value -10000000-
           sbca #0x00          ;  -00000000-
   LD70C:  adda #0x80          ;  -10000000-
           ldx  #RESTBL_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldab Temp1          ; load b with memory contents
           lslb            
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           bpl  LD71E          ; branch if plus (hi bit 0)
           ldaa #0x7f          ; load a with value -01111111-
   LD71E:  ldx  #L002F        ; load index with value
           ldab CruiseSpeedSetpoint    ; load b with memory contents
           cmpb CRUZ36_UknownConstForCruiseControl36    ; compare b with memory contents (data is 8c)
           bls  LD729          ; branch if lower or same
           inx                 ; increment index (x=x+1)
   LD729:  adda 0x00, X    
           bpl  LD733          ; branch if plus (hi bit 0)
           bvs  LD731          ; branch if no overflow
           clra                ; a = 0
           rts                 ; return from subroutine

   LD731:  ldaa #0x7f          ; load a with value -01111111-
   LD733:  rts                 ; return from subroutine

   LD734:  brset *CruiseStatus_1, #$%10000000, LD749    ; branch if bit(s) set
           inc  Counter_Cruise_1
           brclr *CruiseStatus_1, #$%00011000, LD749    ; branch if bit(s) clear
           inc  Counter_Cruise_1
           brset *CruiseStatus_1, #$%00001000, LD749    ; branch if bit(s) set
           inc  Counter_Cruise_1
   LD749:  ldaa CruiseStatus_2    ; load a with memory contents
           adda #0x10          ;  -00010000-
           cmpa #0xb0          ; compare a with value -10110000-
           bcs  LD753          ; branch if lower
           anda #0x0f          ; AND a with value -00001111-
   LD753:  staa CruiseStatus_2    ; store a into memory
           anda #0xf0          ; AND a with value -11110000-
           beq  LD75C          ; branch if equal (zero)
           jmp  LD9DD      

   LD75C:  clrb                ; b = 0
           brclr *BitFlags6f, #b6f_BadSpeedo1, LD764    ; branch if bit(s) clear
           jmp  LD83A      

   LD764:  ldY #SpeedoSensorPulsewidth_HB    ; load Y index -00000000 01001010-
           ldx  #0xd000        ; load index with value
           ldd  #0x06dd        ; load d (a&b) with value -00000110 11011101-
           brclr *TimerOverflowsBetweenSpeedoPulses, #$%11111111, LD77F    ; branch if bit(s) clear
           clrb                ; b = 0
           clra                ; a = 0
           brset *TimerOverflowsBetweenSpeedoPulses, #$%01000000, LD782    ; branch if bit(s) set
           ldab #0x06          ; load b with value -00000110-
           deY                 ; decrement Y
           ldx  #0xddd0        ; load index with value
   LD77F:  jsr  CalculateVehicleSpeedOrEngineRpms    ; call subroutine
   LD782:  ldx  VehicleSpeed_HB
           stx  Temp0          ; store index into memory
           stD *VehicleSpeed_HB    ; store D to RAM
           brclr *CruiseStatus_2, #$%00000010, LD7F7    ; branch if bit(s) clear
           ldaa Counter_Cruise    ; load a with memory contents
           brclr *CruiseStatus_2, #$%00000001, LD7A2    ; branch if bit(s) clear
           cmpa CRMASK_CruiseMask    ; compare a with memory contents (data is 11)
           bcc  LD79C          ; branch if greater or equal
           inca                ; increment a
           staa Counter_Cruise    ; store a into memory
           bra  LD7F7          ; branch

   LD79C:  bclr *CruiseStatus_2, #$%00000001    ; clear bits
           clra                ; a = 0
           staa Counter_Cruise    ; store a into memory
   LD7A2:  cmpa CRSCN1_CruiseComapreConstant1    ; compare a with memory contents (data is 16)
           bcs  LD7F9          ; branch if lower
           ldab CruiseControlVar6    ; load b with memory contents
           tba                 ; a = b
           bpl  LD7AD          ; branch if plus (hi bit 0)
           negb            
   LD7AD:  cmpb CRSCN2_CruiseComapreConstant2    ; compare b with memory contents (data is 06)
           bcs  LD7F1          ; branch if lower
           ldx  #L002F        ; load index with value
           ldab CruiseSpeedSetpoint    ; load b with memory contents
           cmpb CRUZ36_UknownConstForCruiseControl36    ; compare b with memory contents (data is 8c)
           bls  LD7BD          ; branch if lower or same
           inx                 ; increment index (x=x+1)
   LD7BD:  ldab 0x00, X        ; load b with memory at index + value
           adda 0x02, X    
           bvc  LD7C8          ; branch if overflow
           lsla                ; logical shift left a
           ldaa #0x80          ; load a with value -10000000-
           sbca #0x00          ;  -00000000-
   LD7C8:  staa 0x02, X
           cmpa CRMSK2_CruiseMask2    ; compare a with memory contents (data is 07)
           bgt  LD7E1          ; branch if greater
           cmpa CRMSK3_CruiseMask3    ; compare a with memory contents (data is f6)
           bge  LD7F1          ; branch if greater or equal
           subb CRMSK4_CruiseMask4    ; subtract memory contents from b (data is 02)
           cmpb CRMSK5_CruiseMask5    ; compare b with memory contents (data is e1)
           bge  LD7EC          ; branch if greater or equal
           ldab CRMSK5_CruiseMask5    ; load b with memory contents (data is e1)
           bra  LD7EC          ; branch

   LD7E1:  addb CRMSK7_CruiseMask7    ;  (data is 01)
           cmpb CRMSK6_CruiseMask6    ; compare b with memory contents (data is 1f)
           ble  LD7EC          ; branch if less or equal
           ldab CRMSK6_CruiseMask6    ; load b with memory contents (data is 1f)
   LD7EC:  stab 0x00, X    
           clra                ; a = 0
           staa 0x02, X    
   LD7F1:  bclr *CruiseStatus_2, #$%00000010    ; clear bits
           clra                ; a = 0
           staa Counter_Cruise    ; store a into memory
   LD7F7:  bra  LD823          ; branch

   LD7F9:  inca                ; increment a
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
           bmi  LD818          ; branch if minus(hi bit 1)
           ldab CruiseControlVar6    ; load b with memory contents
           bpl  LD811          ; branch if plus (hi bit 0)
           comb            
           incb            
   LD811:  cba             
           ble  LD823          ; branch if less or equal
           staa CruiseControlVar6    ; store a into memory
           bra  LD823          ; branch

   LD818:  ldab CruiseControlVar6    ; load b with memory contents
           bmi  LD81E          ; branch if minus(hi bit 1)
           comb            
           incb            
   LD81E:  cba             
           bge  LD823          ; branch if greater or equal
           staa CruiseControlVar6    ; store a into memory
   LD823:  ldd  Temp0          ; load d (a&b) with memory contents
           subd VehicleSpeed_HB    ; d = d - memory contents
           bne  LD82C          ; branch if not equal (not zero)
           clr  CruiseControlVar1    ; zero byte at memory location
   LD82C:  stD *Temp0          ; store D to RAM
           clra                ; a = 0
           ldab CruiseControlVar1    ; load b with memory contents
           bpl  LD834          ; branch if plus (hi bit 0)
           deca                ; decrement a
   LD834:  addd Temp0          ; d = d + memory contents
           asra            
           rorb            
           bsr  LD83E          ; call subroutine
   LD83A:  stab CruiseControlVar1    ; store b into memory
           bra  LD84F          ; branch

   LD83E:  asld                ; shift left (d=d*2)
           bcs  LD847          ; branch if lower
           tsta                ; test a
           beq  LD84D          ; branch if equal (zero)
           ldab #0x7f          ; load b with value -01111111-
           rts                 ; return from subroutine

   LD847:  cmpa #0xff          ; compare a with value -11111111-
           beq  LD84C          ; branch if equal (zero)
           clrb                ; b = 0
   LD84C:  sec                 ; set carry
   LD84D:  rorb            
           rts                 ; return from subroutine

   LD84F:  brset *CruiseStatus_1, #$%10000000, LD8A3    ; branch if bit(s) set
           ldx  #VACREG_CruiseControlVacRegularGainGurve_FromDeltaSpeed    ; load index with value
           clrb                ; b = 0
           ldaa CruiseSpeedSetpoint    ; load a with memory contents
           brclr *CruiseStatus_1, #$%00011000, LD85F    ; branch if bit(s) clear
           ldaa CruiseControlVar0    ; load a with memory contents
   LD85F:  lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           subd VehicleSpeed_HB    ; d = d - memory contents
           bcc  LD8A6          ; branch if greater or equal
           bclr *CruiseStatus_1, #$%00000100    ; clear bits
           ldx  #VENTRG_CruiseControlVentRegularGainCurve_FromDeltaSpeed    ; load index with value
           coma            
           comb            
           addd #L0001         ;  -00000000 00000001-
           stab Temp0          ; store b into memory
           tsta                ; test a
           beq  LD879          ; branch if equal (zero)
           bset *Temp0, #$%11111111    ; set bits
   LD879:  lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           brclr *CruiseStatus_1, #$%00010000, LD889    ; branch if bit(s) clear
           ldx  #CRUZ1_UknownTableForCruiseControl1    ; load index with value
           tsta                ; test a
           beq  LD8BC          ; branch if equal (zero)
           ldaa #0xff          ; load a with value -11111111-
           bra  LD8BD          ; branch

   LD889:  tsta                ; test a
           bne  LD89D          ; branch if not equal (not zero)
           cmpb VNTAB1_CruiseControlLimitToAMaxVent    ; compare b with memory contents (data is 90)
           bcc  LD89D          ; branch if greater or equal
           tba                 ; a = b
           ldab Temp0          ; load b with memory contents
           cmpa VNTAB2_CruiseControlLimitToHalfMaxVent    ; compare a with memory contents (data is 60)
           bcs  LD8BC          ; branch if lower
           ldaa #0x05          ; load a with value -00000101-
           bra  LD89F          ; branch

   LD89D:  ldaa #0x0f          ; load a with value -00001111-
   LD89F:  oraa #0x80          ;  -10000000-
           staa CruiseControlVar3    ; store a into memory
   LD8A3:  jmp  LD9DD      

   LD8A6:  brclr *CruiseStatus_1, #$%00001100, LD8AF    ; branch if bit(s) clear
           ldx  #VACACC_CruiseControlVacAcceleratedGainCurve_FromDeltaSpeed    ; load index with value
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
   LD8AF:  tsta                ; test a
           beq  LD8B4          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   LD8B4:  cmpb ACLRST_CruiseControlDeltaSpeedToResetAccFlag    ; compare b with memory contents (data is 18)
           bcc  LD8BC          ; branch if greater or equal
           bclr *CruiseStatus_1, #$%00000100    ; clear bits
   LD8BC:  tba                 ; a = b
   LD8BD:  jsr  Lookup4ByteTable    ; call subroutine
           clra                ; a = 0
           tstb            
           bpl  LD8C5          ; branch if plus (hi bit 0)
           deca                ; decrement a
   LD8C5:  stD *Temp0          ; store D to RAM
           ldx  #THGAIN_CruiseControlThrottleGainFactor_FromThrottle    ; load index with value
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bcc  LD8D1          ; branch if greater or equal
           clra                ; a = 0
   LD8D1:  jsr  Lookup4ByteTable    ; call subroutine
           staa Temp3          ; store a into memory
           ldx  #SPGAIN_CruiseControlSpeedGainFactor_FromSpeed    ; load index with value
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    ; call subroutine
           adda Temp3      
           bcc  LD8E7          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LD8E7:  staa Temp3          ; store a into memory
           clra                ; a = 0
           staa Temp2          ; store a into memory
           ldab CruiseControlVar1    ; load b with memory contents
           bpl  LD8F1          ; branch if plus (hi bit 0)
           deca                ; decrement a
   LD8F1:  asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd Temp0          ; d = d + memory contents
           stD *Temp0          ; store D to RAM
           brset *CruiseStatus_2, #$%00000100, LD923    ; branch if bit(s) set
           bpl  LD902          ; branch if plus (hi bit 0)
           coma            
           comb
           addd #L0001         ;  -00000000 00000001-
   LD902:  tsta                ; test a
           beq  LD907          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   LD907:  cmpb CRUZ24_UknownConstForCruiseControl24    ; compare b with memory contents (data is 00)
           bhi  LD923          ; branch if higher
           clrb                ; b = 0
           ldaa CruiseSpeedSetpoint    ; load a with memory contents
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           subd VehicleSpeed_HB    ; d = d - memory contents
           bpl  LD91B          ; branch if plus (hi bit 0)
           coma            
           comb            
           addd #L0001         ;  -00000000 00000001-
   LD91B:  tsta                ; test a
           bne  LD923          ; branch if not equal (not zero)
           cmpb CRUZ25_UknownConstForCruiseControl25    ; compare b with memory contents (data is 30)
           bls  LD940          ; branch if lower or same
   LD923:  clra                ; a = 0
           ldab CruiseControlVar2    ; load b with memory contents
           bpl  LD929          ; branch if plus (hi bit 0)
           deca                ; decrement a
   LD929:  addd Temp0          ; d = d + memory contents
           staa Temp4          ; store a into memory
           bpl  LD934          ; branch if plus (hi bit 0)
           coma
           comb            
           addd #L0001         ;  -00000000 00000001-
   LD934:  cmpD Temp2          ; compare D
           bcc  LD943          ; branch if greater or equal
           ldaa Temp4          ; load a with memory contents
           bpl  LD93E          ; branch if plus (hi bit 0)
           negb            
   LD93E:  stab CruiseControlVar2    ; store b into memory
   LD940:  jmp  LD9DD      

   LD943:  clra                ; a = 0
           staa CruiseControlVar2    ; store a into memory
           ldaa Temp4          ; load a with memory contents
           anda #0x80          ; AND a with value -10000000-
           ldab CruiseControlVar3    ; load b with memory contents
           beq  LD955          ; branch if equal (zero)
           bpl  LD940          ; branch if plus (hi bit 0)
           tab                 ; b = a
           eorb CruiseControlVar3
           bpl  LD940          ; branch if plus (hi bit 0)
   LD955:  ldab TpsVolts       ; load b with memory contents
           subb MINTHR_LowestSessionTPS    ; b = b-memory contents
           bcc  LD95C          ; branch if greater or equal
           clrb                ; b = 0
   LD95C:  tsta                ; test a
           bpl  LD986          ; branch if plus (hi bit 0)
           oraa CRUZ28_UknownConstForCruiseControl28    ;  (data is 01)
           brclr *CruiseStatus_1, #$%00010000, LD96B    ; branch if bit(s) clear
           adda CRUZ30_UknownConstForCruiseControl30    ;  (data is 02)
           bra  LD9AD          ; branch

   LD96B:  staa Temp4          ; store a into memory
           clra                ; a = 0
           cmpb CLOTHR_CruiseControlDontVentIfThrottleBelowThis    ; compare b with memory contents (data is 01)
           bcs  LD9AD          ; branch if lower
           ldx  #CRUZ4_UknownTableForCruiseControl4    ; load index with value
           stx  Temp2          ; store index into memory
           ldx  #CRUZ5_UknownTableForCruiseControl5    ; load index with value
           bsr  LD9B1          ; call subroutine
           oraa #0x80          ;  -10000000-
           ldab Temp4          ; load b with memory contents
           cba             
           bcc  LD9AD          ; branch if greater or equal
           bra  LD9AC          ; branch

   LD986:  cmpb MAXTHR_CruiseControlDontVacIfThrottleAboveThis    ; compare b with memory contents (data is 66)
           bcc  LD9AD          ; branch if greater or equal
           oraa CRUZ27_UknownConstForCruiseControl27    ;  (data is 01)
           brclr *CruiseStatus_1, #$%00001000, LD997    ; branch if bit(s) clear
           adda CRUZ29_UknownConstForCruiseControl29    ;  (data is 01)
           bra  LD9AD          ; branch

   LD997:  brset *CruiseStatus_1, #$%00000100, LD9AD    ; branch if bit(s) set
           staa Temp4          ; store a into memory
           ldx  #CRUZ2_UknownTableForCruiseControl2    ; load index with value
           stx  Temp2          ; store index into memory
           ldx  #CRUZ3_UknownTableForCruiseControl3    ; load index with value
           bsr  LD9B1          ; call subroutine
           ldab Temp4          ; load b with memory contents
           cba             
           bcc  LD9AD          ; branch if greater or equal
   LD9AC:  tba                 ; a = b
   LD9AD:  staa CruiseControlVar3    ; store a into memory
           bra  LD9DD          ; branch

   LD9B1:  clrb                ; b = 0
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
           jsr  LD83E          ; call subroutine
           tba                 ; a = b
           adda #0x80          ;  -10000000-
           jsr  Lookup4ByteTable    ; call subroutine
           ldx  Temp2      
           staa Temp2          ; store a into memory
           ldd  Temp0          ; load d (a&b) with memory contents
           jsr  LD83E          ; call subroutine
           tba                 ; a = b
           adda #0x80          ;  -10000000-
           jsr  Lookup4ByteTable    ; call subroutine
           ldab Temp2          ; load b with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           rts                 ; return from subroutine

   LD9DD:  ldaa PIA2_Buffer    ; load a with memory contents
           anda #~(pi2_SCVent | pi2_SCVac)        ; AND a with value -11111100-
           brset *CruiseStatus_1, #$%10000000, LD9F6    ; branch if bit(s) set
           ldab CruiseControlVar3    ; load b with memory contents
           beq  LD9F8          ; branch if equal (zero)
           bpl  LD9FA          ; branch if plus (hi bit 0)
           brclr *CruiseStatus_1, #$%00010000, LD9F6    ; branch if bit(s) clear
           ldab Counter_Cruise_3    ; load b with memory contents
           incb            
           beq  LD9F6          ; branch if equal (zero)
           stab Counter_Cruise_3    ; store b into memory
   LD9F6:  oraa #pi2_SCVent | pi2_SCVac          ;  -00000011-
   LD9F8:  oraa #pi2_SCVent          ;  -00000010-
   LD9FA:  staa PIA2_Buffer    ; store a into memory
           ldab CruiseControlVar3    ; load b with memory contents
           beq  LDA0C          ; branch if equal (zero)
           asld                ; shift left (d=d*2)
           tstb            
           beq  LDA09          ; branch if equal (zero)
           subb #0x02          ;  -00000010-
           beq  LDA09          ; branch if equal (zero)
           lsrd                ; shift right (d=d/2)
   LDA09:  stab CruiseControlVar3    ; store b into memory
           rts                 ; return from subroutine

   LDA0C:  brclr *CruiseStatus_2, #$%00000001, LDA13    ; branch if bit(s) clear
           bset *CruiseStatus_2, #$%00000010    ; set bits
   LDA13:  rts                 ; return from subroutine

CalcTargetBoost_MM:
           ldaa ATMOffset      ; load a with memory contents
           cmpa #0x11          ; compare a with value -00010001-
           beq  LDA26          ; branch if equal (zero)
           cmpa #0x1b          ; compare a with value -00011011-
           beq  LDA26          ; branch if equal (zero)
           cmpa #0x20          ; compare a with value -00100000-
           beq  LDA26          ; branch if equal (zero)
           cmpa #0x14          ; compare a with value -00010100-
           bne  LDA27          ; branch if not equal (not zero)
   LDA26:  rts                 ; return from subroutine

   LDA27:  brclr *BitFlags6d, #b6d_FuelEngineNotRunning, LDA46    ; branch if bit(s) clear
           clra                ; a = 0
           staa WastegateDutyCycleIncreaseFromKnock    ; store a into memory
           staa BoostActuatorADutyCycle_VNT    ; store a into memory
           jsr  NULL_ROUTINE    ; call subroutine
           staa BoostActuatorBDutyCycle_WG    ; store a into memory
           bset *PIA2_Buffer, #pi2_PTU    ; set bits
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x1f          ;  -00011111-
           bne  LDA45          ; branch if not equal (not zero)
           ldaa Timer_BoostTimer    ; load a with memory contents
           beq  LDA45          ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_BoostTimer    ; store a into memory
   LDA45:  rts                 ; return from subroutine

   LDA46:  ldaa Counter_MainLoop    ; load a with memory contents
           ldx  #Cylinder2Retard    ; load index with value
   LDA4B:  ldab 0x00, X        ; load b with memory at index + value
           beq  Boost_LookAtCylRetards    ; branch if equal (zero)
           bita ARCMSK_AdaptiveRetardCounterMask    ;  (data is 3f)
           bne  LDA87          ; branch if not equal (not zero)
           ldaa CoolantTemp    ; load a with memory contents
           cmpa ARMINT_AdaptiveRetardMinimumTemp    ; compare a with memory contents (data is b1)
           bls  LDA84          ; branch if lower or same
           ldaa Timer_Over5PsiBoostMaxFF    ; load a with memory contents
           inca                ; increment a
           cmpa ARTM5P_AdaptiveRetardTimeOver5psiBoost    ; compare a with memory contents (data is 0c)
           bcs  LDA85          ; branch if lower
           sei                 ; disable interrupts
           ldaa AdaptiveRetardIndex    ; load a with memory contents
           adda ARINDX_AdaptiveRetardIndexBase_80    ;  (data is 80)
           bcc  LDA6D          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LDA6D:  staa AdaptiveRetardIndex    ; store a into memory
           cli                 ; enable interrupts
           bra  LDA84          ; branch

Boost_LookAtCylRetards:
           inx                 ; increment index (x=x+1)
           cpx  #Cylinder4Retard    ;  -00000000 11000110-
           bls  LDA4B          ; branch if lower or same
           bita ARCMS2_AdaptiveRetardCounterMask2_00    ;  (data is 00)
           bne  LDA87          ; branch if not equal (not zero)
           ldaa Timer_Over5PsiBoostMaxFF    ; load a with memory contents
           suba ARCMS3_AdaptiveRetardCounterMask3_FF    ;  (data is ff)
           bcc  LDA85          ; branch if greater or equal
   LDA84:  clra                ; a = 0
   LDA85:  staa Timer_Over5PsiBoostMaxFF    ; store a into memory
   LDA87:  brclr *BitFlags70, #b70_bit6, LDAA6    ; branch if bit(s) clear
           bclr *BitFlags70, #b70_bit6    ; clear bits
           ldab WastegateDutyCycleIncreaseFromKnock    ; load b with memory contents
           addb KDCINC_WastegateDutyCycleIncreaseStepWhenKnocking    ;  (data is 02)
           bcc  LDA97          ; branch if greater or equal
           ldab #0xff          ; load b with value -11111111-
   LDA97:  ldaa KDCMAX_WastegateDutyCycleIncreaseMaxWhenKnocking    ; load a with memory contents (data is 14)
           cba             
           bcs  LDAA3          ; branch if lower
           ldaa KDCMIN_WastegateDutyCycleIncreaseMinWhenKnocking    ; load a with memory contents (data is 04)
           cba             
           bcs  LDAC5          ; branch if lower
   LDAA3:  tab                 ; b = a
           bra  LDAC5          ; branch

   LDAA6:  ldab Counter_MainLoop    ; load b with memory contents
           bitb DECTIM_TimeScaleFor_DCDECK    ;  (data is 07)
           bne  LDAC7          ; branch if not equal (not zero)
           ldx  #CalculatedSparkAdvance    ; load index with value
   LDAB0:  inx                 ; increment index (x=x+1)
           cpx  #MaxRetardFromMAP    ;  -00000000 11000111-
           beq  LDAC4          ; branch if equal (zero)
           ldaa 0x00, X        ; load a with memory at index + value
           cmpa MNRTWG_MinRetardToDerateWGDC    ; compare a with memory contents (data is 07)
           bcs  LDAB0          ; branch if lower
           ldab WastegateDutyCycleIncreaseFromKnock    ; load b with memory contents
           subb DCDECK_WastegateDutyCycleDecrementWhenSparkStillDerated    ; subtract memory contents from b (data is 02)
           bcc  LDAC5          ; branch if greater or equal
   LDAC4:  clrb                ; b = 0
   LDAC5:  stab WastegateDutyCycleIncreaseFromKnock    ; store b into memory
   LDAC7:  ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_VNT          ;  -00000001-
           beq  LDAD1          ; branch if equal (zero)
           jmp  BoostControlRoutine_VNT

;    LDAD1:  ldaa OPTN2_CalCustomOptionConfigFlags2
;            bita #opt_T2BC          ;  -00000001-
;            beq  L2855          ; branch if equal (zero)
LDAD1:     jmp  BoostControlRoutine_T1
;L2855:     jmp  BoostControlRoutine_T2


Interrupt_TimerOC3_Wastegate:
           bset *BitFlags6e, #b6e_PIAKeepIntEnabled    ; set bits
           ldaa #0x64          ; load a with value -01100100-
           brset *b5c_IPL1, #$%00001000, LDAF9    ; branch if bit(s) set
           brclr *BitFlags6c, #b6c_VNTOvBst, LDAE8    ; branch if bit(s) clear
           ldab CONFIG_ConfigurationFlags    ; load b with memory contents (data is 9f)
           bitb #cfg_VNTOBFuelShut          ;  -00000100-
           bne  LDAF9          ; branch if not equal (not zero)
   LDAE8:  ldab BoostActuatorBDutyCycle_WG    ; load b with memory contents
           cmpb #0x04          ;  -00000100-
           bls  LDAF9          ; branch if lower or same
           cmpb #0xc4          ;  -11000100-
           bcc  LDB02          ; branch if greater or equal
           brset *BitFlags6e, #b6e_BoostOver5psi, LDB01    ; branch if bit(s) set
           ldaa #0xc8          ; load a with value -11001000-
           sba                 ; subtract (a=a-b)
   LDAF9:  psha                ; push a onto stack
           bset *BitFlags6e, #b6e_BoostOver5psi    ; set bits
           ldaa #0xdc          ; load a with value -11011100-
           bra  LDB08          ; branch

   LDB01:  tba                 ; a = b
   LDB02:  psha                ; push a onto stack
           bclr *BitFlags6e, #b6e_BoostOver5psi    ; clear bits
           ldaa #0xd8          ; load a with value -11011000-
   LDB08:  ldab #0x80          ; load b with value -10000000-
           jsr  SetPIAOutputBits    ; call subroutine
           ldaa #0xfc          ; load a with value -11111100-
           ldab #0x80          ; load b with value -10000000-
           jsr  SetPIAOutputBits    ; call subroutine
           ldaa #0xf8          ; load a with value -11111000-
           ldab #0x80          ; load b with value -10000000-
           jsr  SetPIAOutputBits    ; call subroutine
           pula                ; pull a from stack
           clrb                ; b = 0
           lsrd                ; shift right (d=d/2)
           addd CPU_Timer_OC3_InjectorBDriver
           std  CPU_Timer_OC3_InjectorBDriver
           ldaa #0x20          ; load a with value -00100000-
           staa CPU_TimerInterruptFlag1
           bclr *BitFlags6e, #b6e_PIAKeepIntEnabled    ; clear bits
           rti                 ; return from interrupt

Interrupt_TimerOC4_VNTActuator:
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_VNT          ;  -00000001-
           bne  LDB37          ; branch if not equal (not zero)
           jmp  Interrupt_RealTime

   LDB37:  bset *BitFlags6e, #b6e_PIAKeepIntEnabled    ; set bits
           ldaa #0x64          ; load a with value -01100100-
           ldab BoostActuatorADutyCycle_VNT    ; load b with memory contents
           cmpb #0x04          ;  -00000100-
           bls  LDB4D          ; branch if lower or same
           cmpb #0xc4          ;  -11000100-
           bcc  LDB56          ; branch if greater or equal
           brset *BitFlags6e, #b6e_WastegateDC, LDB55    ; branch if bit(s) set
           ldaa #0xc8          ; load a with value -11001000-
           sba                 ; subtract (a=a-b)
   LDB4D:  psha                ; push a onto stack
           bset *BitFlags6e, #b6e_WastegateDC    ; set bits
           ldaa #0xdc          ; load a with value -11011100-
           bra  LDB5C          ; branch

   LDB55:  tba                 ; a = b
   LDB56:  psha                ; push a onto stack
           bclr *BitFlags6e, #b6e_WastegateDC    ; clear bits
           ldaa #0xd8          ; load a with value -11011000-
   LDB5C:  ldab #0x40          ; load b with value -01000000-
           jsr  SetPIAOutputBits    ; call subroutine
           ldaa #0xfc          ; load a with value -11111100-
           ldab #0x40          ; load b with value -01000000-
           jsr  SetPIAOutputBits    ; call subroutine
           ldaa #0xf8          ; load a with value -11111000-
           ldab #0x40          ; load b with value -01000000-
           jsr  SetPIAOutputBits    ; call subroutine
           pula                ; pull a from stack
           clrb                ; b = 0
           lsrd                ; shift right (d=d/2)
           addd CPU_Timer_OC4_InjectorADriver
           std  CPU_Timer_OC4_InjectorADriver
           ldaa #0x10          ; load a with value -00010000-
           staa CPU_TimerInterruptFlag1
           bclr *BitFlags6e, #b6e_PIAKeepIntEnabled    ; clear bits
           rti                 ; return from interrupt

BoostControlRoutine_VNT:
           ldaa MapValue       ; load a with memory contents
           staa Temp2          ; Temp2 = MAP
           tab                 ; b = MAP
           suba BaroPressure   ; a = BoostOverBaro
           bcc  LDB95          ; branch if in Boost
           clra                ; a = 0 if in Vacuum
   LDB95:  staa Temp1          ; Temp1 = BoostOverBaro
           ldaa DeltaBoostSampleCounter    ; OverboostSampleCounter?
           cmpa DLTBSC_DeltaBoostSampleCounterMax    ; compare a with memory contents (data is 07)
           bcc  VNTBC_CalculateSignedDeltaBoost    ; branch if greater or equal
           inca                ; increment a
           bra  LDBBA          ; branch

VNTBC_CalculateSignedDeltaBoost:
           tba                 ; a = b
           subb PreviousBoostOverBaro    ; b = b-memory contents
           staa PreviousBoostOverBaro    ; store a into memory
           bcc  LDBB1          ; branch if greater or equal
           cmpb #0x80          ;  -10000000-
           bcc  VNTBC_SaveSignedDeltaBoost    ; branch if greater or equal
           ldab #0x80          ; load b with value -10000000-
           bra  VNTBC_SaveSignedDeltaBoost    ; branch

   LDBB1:  cmpb #0x7f          ;  -01111111-
           bls  VNTBC_SaveSignedDeltaBoost    ; branch if lower or same
           ldab #0x7f          ; load b with value -01111111-
VNTBC_SaveSignedDeltaBoost:
           stab BoostDelta_Signed    ; store b into memory
           clra                ; a = 0
   LDBBA:  staa DeltaBoostSampleCounter
           brclr *b5c_IPL1, #$%00001000, VNTBC_SampleDeltaBoost    ; branch if bit(s) clear
           jmp  VNTBC_UseLimpInBoostSetpoint

VNTBC_SampleDeltaBoost:
           ldaa MapValue       ; load a with memory contents
           suba BaroPressure
           bcc  LDBCB          ; branch if greater or equal
           clra                ; a = 0
   LDBCB:  cmpa OBSMPL_OverboostSampleThreshold    ; compare a with memory contents (data is 84)
           bcc  LDBD7          ; branch if greater or equal
           ldaa MapValue       ; load a with memory contents
           cmpa VOBMAP_VNTOverboostSampleCounterMAP    ; compare a with memory contents (data is fe)
           bcs  LDC21          ; branch if lower
   LDBD7:  ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bcc  LDBDE          ; branch if greater or equal
           clra                ; a = 0
   LDBDE:  cmpa VOBTPS_VNTOverboostSampleCounterTPS    ; compare a with memory contents (data is 10)
           bcs  LDC43          ; branch if lower
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa #0xbb          ; compare a with value -10111011-
           bcs  LDC43          ; branch if lower
           ldd  VNTOverboostSampleCounter2
           subd VOBSCD_VNTOverboostSampleCounterDecr    ;  (data is 0006)
           bcc  LDBF3          ; branch if greater or equal
           clra                ; a = 0
           clrb                ; b = 0
   LDBF3:  std  VNTOverboostSampleCounter2
   LDBF6:  ldd  VNTOverboostSampleCounter1
           addd VOBSCI2_VNTOverboostSampleCounterIncr2    ;  (data is 00)
           bcc  LDC01          ; branch if greater or equal
           ldd  #0xFFFF         ; load d (a&b) with value -11111111 11111111-
   LDC01:  std  VNTOverboostSampleCounter1
           cmpD VOBSCL2_VNTOverboostSampleCounterLimit2    ; compare D (data is 00)
           bls  LDC3B          ; branch if lower or same
           bset *BitFlags69, #b69_AcClutch    ; set bits
           pshb                ; push b onto stack
           ldab CoolantTemp    ; load b with memory contents
           cmpb VOBCT_VNTOverboostSampleCounterCoolantTemp    ; compare b with memory contents (data is 58)
           pulb                ; pull b from stack
           bcs  LDC3E          ; branch if lower
           cmpD VOBSCL3_VNTOverboostSampleCounterLimit3    ; compare D (data is 02)
           bls  LDC3E          ; branch if lower or same
           bset *BitFlags6c, #b6c_VNTOvBst    ; set bits
           bra  LDC99          ; branch

   LDC21:  ldd  VNTOverboostSampleCounter1
           subd VOBSCD2_VNTOverboostSampleCounterDecr2    ;  (data is 0001)
           bcc  LDC2B          ; branch if greater or equal
           clra                ; a = 0
           clrb                ; b = 0
   LDC2B:  std  VNTOverboostSampleCounter1
           ldd  VNTOverboostSampleCounter2
           subd VOBSCD_VNTOverboostSampleCounterDecr    ;  (data is 0006)
           bcc  LDC38          ; branch if greater or equal
           clra                ; a = 0
           clrb                ; b = 0
   LDC38:  std  VNTOverboostSampleCounter2
   LDC3B:  bclr *BitFlags69, #b69_AcClutch    ; clear bits
   LDC3E:  bclr *BitFlags6c, #b6c_VNTOvBst    ; clear bits
           bra  LDC99          ; branch

   LDC43:  ldaa CoolantTemp    ; load a with memory contents
           cmpa VOBCT_VNTOverboostSampleCounterCoolantTemp    ; compare a with memory contents (data is 58)
           bcs  LDBF6          ; branch if lower
           ldd  VNTOverboostSampleCounter2
           addd VOBSCL_VNTOverboostSampleCounterLimit    ;  (data is 00)
           bcc  LDC55          ; branch if greater or equal
           ldd  #0xFFFF         ; load d (a&b) with value -11111111 11111111-
   LDC55:  std  VNTOverboostSampleCounter2
           cmpD VOBSCI_VNTOverboostSampleCounterIncr    ; compare D (data is 02)
           bcs  LDBF6          ; branch if lower
           clra                ; a = 0
           clrb                ; b = 0
           std  VNTOverboostSampleCounter1
           bclr *BitFlags69, #b69_AcClutch    ; clear bits
           bclr *BitFlags6c, #b6c_VNTOvBst    ; clear bits
           ldd  #0x3f01        ; load d (a&b) with value -00111111 00000001-
           jsr  ThrowNonCriticalError    ; call subroutine
           bset *b5c_IPL1, #$%00001000    ; set bits
VNTBC_UseLimpInBoostSetpoint:
           brset *BitFlags66, #b66_FullThrottle, LDC96    ; branch if bit(s) set
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa VNTRMX_MaximumRPMForVNTLimpInControl    ; compare a with memory contents (data is bc)
           bhi  LDC96          ; branch if higher
           ldx  #VNTLMP_BoostFromRPMForVNTLimpInMode    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           brclr *BitFlags6b, #$%00001000, LDC8D    ; branch if bit(s) clear
           suba VLMPMN_MinimumBoostSetpointForVNTLimpinMode    ;  (data is 19)
           bcc  LDC8D          ; branch if greater or equal
           clra                ; a = 0
   LDC8D:  cmpa Temp1          ; compare a with memory contents
           bcs  LDC96          ; branch if lower
           bclr *BitFlags6b, #$%00001000    ; clear bits
           bra  LDC99          ; branch

   LDC96:  bset *BitFlags6b, #$%00001000    ; set bits
   LDC99:  bclr *PIA2_Buffer, #pi2_PTU    ; clear bits
           brset *BitFlags66, #b66_OffIdle, VNTBC_OffIdle    ; branch if bit(s) set
           ldaa CoolantTemp    ; load a with memory contents
           cmpa VNTTMP_VNTDecelEngineTempToDetermineVanePos    ; compare a with memory contents (data is a6)
           bcc  LDCAA          ; branch if greater or equal
           jmp  VNTBC_OpenVanesToMaxPos2

   LDCAA:  brclr *BitFlags67, #b67_FallToIdle, VNTBC_OpenVanesToMaxPos    ; branch if bit(s) clear
           ldaa VNT_BstCtrl_Counter1    ; load a with memory contents
           beq  LDCC0          ; branch if equal (zero)
           deca                ; decrement a
           staa VNT_BstCtrl_Counter1    ; store a into memory
           ldaa WGDCMN_MinimumWastegateDutyCycle    ; load a with memory contents (data is 00)
           staa BoostActuatorADutyCycle_VNT    ; store a into memory
           ldaa WGDCMX_MaximumWastegateDutyCycle    ; load a with memory contents (data is c8)
           jmp  VNTBC_StoreWastegateDutyCycle

   LDCC0:  ldaa EngineRpm_HB    ; load a with memory contents
           cmpa VMINRP_MinimumRPMForVNTBoostControl    ; compare a with memory contents (data is 01)
           bcc  LDCCB          ; branch if greater or equal
           ldaa #0xc8          ; load a with value -11001000-
           bra  VNTBC_SaveVNTActuatorDutyCycle    ; branch

   LDCCB:  bset *PIA2_Buffer, #pi2_PTU    ; set bits
           ldx  #VNTDCR_VNTDutyCycleFromRPM    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           bra  VNTBC_SaveVNTActuatorDutyCycle    ; branch

VNTBC_OffIdle:
           ldaa VNTCNT_VNTBoostControlCounter1Init    ; load a with memory contents (data is e3)
           staa VNT_BstCtrl_Counter1    ; store a into memory
           ldaa Temp1          ; load a with memory contents
           cmpa MAPPT2_WastegateDutyCycleMapSwitchPoint2    ; compare a with memory contents (data is 1f)
           bcs  LDCE5          ; branch if lower
           jmp  VNTBC_LoadMaxVNTDutyCycle

   LDCE5:  clrb                ; b = 0
           stab WastegateDutyCycleIncreaseFromKnock    ; store b into memory
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x1f          ;  -00011111-
           bne  LDCF5          ; branch if not equal (not zero)
           ldab Timer_BoostTimer    ; load b with memory contents
           beq  LDCF5          ; branch if equal (zero)
           decb            
           stab Timer_BoostTimer    ; store b into memory
   LDCF5:  brset *BitFlags66, #b66_FullThrottle, LDD19    ; branch if bit(s) set
           ldaa VehicleSpeed_HB    ; load a with memory contents
           bne  VNTBC_CheckBoostIsHighEnoughToControl    ; branch if not equal (not zero)
           ldaa CoolantTemp    ; load a with memory contents
   LDCFF:  cmpa VNTTMP_VNTDecelEngineTempToDetermineVanePos    ; compare a with memory contents (data is a6)
           bcs  LDD35          ; branch if lower
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa VNTRPM_RPMThresholdForVNTControl    ; compare a with memory contents (data is 32)
           bcc  VNTBC_CheckBoostIsHighEnoughToControl    ; branch if greater or equal
           ldaa VNTMIN_VNTMinActuatorDutyCycle    ; load a with memory contents (data is 00)
           bra  VNTBC_SaveVNTActuatorDutyCycle    ; branch

VNTBC_OpenVanesToMaxPos:
           bset *PIA2_Buffer, #pi2_PTU    ; set bits
           clra                ; a = 0
VNTBC_SaveVNTActuatorDutyCycle:
           staa BoostActuatorADutyCycle_VNT    ; store a into memory
           clra                ; a = 0
           bra  VNTBC_StoreWastegateDutyCycle    ; branch

   LDD19:  ldaa Temp1          ; load a with memory contents
           cmpa MAPPT2_WastegateDutyCycleMapSwitchPoint2    ; compare a with memory contents (data is 1f)
           bcc  VNTBC_LoadMaxVNTDutyCycle    ; branch if greater or equal
           ldaa VNTWOT_VNTFullThrottleDutyCycle    ; load a with memory contents (data is c8)
           staa BoostActuatorADutyCycle_VNT    ; store a into memory
           ldaa Temp1          ; load a with memory contents
           ldx  #VNTDCW_VNTFullThrottleWastegateDutyCycle    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           jsr  NULL_ROUTINE    ; call subroutine
           staa BoostActuatorBDutyCycle_WG    ; store a into memory
           jmp  VNTBC_JumpToGetBoostTargetFromTables

   LDD35:  ldaa Temp1          ; load a with memory contents
           beq  VNTBC_OpenVanesToMaxPos2    ; branch if equal (zero)
VNTBC_CheckBoostIsHighEnoughToControl:
           ldaa Temp1          ; load a with memory contents
           cmpa VNTBLM_BoostLimitForNormalVNTControl    ; compare a with memory contents (data is 0d)
           bhi  LDD6A          ; branch if higher
           ldaa BaroPressure    ; load a with memory contents
           suba VNTDCL_MAPBelowBaroForDecelDetermination    ;  (data is 25)
           suba Temp2      
           bls  LDD58          ; branch if lower or same
           ldaa CoolantTemp    ; load a with memory contents
           cmpa VNTTMP_VNTDecelEngineTempToDetermineVanePos    ; compare a with memory contents (data is a6)
           bcc  VNTBC_OpenVanesToMaxPos    ; branch if greater or equal
VNTBC_OpenVanesToMaxPos2:
           bset *PIA2_Buffer, #pi2_PTU    ; set bits
           ldaa VNTMAX_VNTMaxActuatorDutyCycle    ; load a with memory contents (data is c8)
           bra  VNTBC_SaveVNTActuatorDutyCycle    ; branch

   LDD58:  nega                ; negate a (set high bit)
           staa Temp0          ; store a into memory
           ldx  #VNTVAC_VNTActuatorDutyCycleFromVacBelowThreshold    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa BoostActuatorADutyCycle_VNT    ; store a into memory
           ldaa Temp0          ; load a with memory contents
           ldx  #WGTVAC_WastegateDutyCycleFromVacBelowThreshold    ; load index with value
           bra  LDD83          ; branch

   LDD6A:  suba VNTBLM_BoostLimitForNormalVNTControl    ;  (data is 0d)
           bcc  LDD70          ; branch if greater or equal
           clra                ; a = 0
   LDD70:  ldx  #VNTDC_VNTDutyCycleFromBoost    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa BoostActuatorADutyCycle_VNT    ; store a into memory
           ldaa Temp1          ; load a with memory contents
           suba VNTBLM_BoostLimitForNormalVNTControl    ;  (data is 0d)
           bcc  LDD80          ; branch if greater or equal
           clra                ; a = 0
   LDD80:  ldx  #WGDCVN_WGDCFromVNTDutyCycle    ; load index with value
   LDD83:  jsr  Lookup4ByteTable    ; call subroutine
VNTBC_StoreWastegateDutyCycle:
           jsr  NULL_ROUTINE    ; call subroutine
           staa BoostActuatorBDutyCycle_WG    ; store a into memory
           rts                 ; return from subroutine

VNTBC_LoadMaxVNTDutyCycle:
           ldaa #0xc8          ; load a with value -11001000-
           staa BoostActuatorADutyCycle_VNT    ; store a into memory
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x1f          ;  -00011111-
           bne  VNTBC_JumpToGetBoostTargetFromTables    ; branch if not equal (not zero)
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb RPMBST_MinimumRpmToTrackBoostCreep    ; compare b with memory contents (data is 4c)
           bcs  VNTBC_JumpToGetBoostTargetFromTables    ; branch if lower
           ldaa Timer_BoostTimer    ; load a with memory contents
           inca                ; increment a
           beq  VNTBC_JumpToGetBoostTargetFromTables    ; branch if equal (zero)
           staa Timer_BoostTimer    ; store a into memory

VNTBC_JumpToGetBoostTargetFromTables:
           jsr  GetBoostTargetFromTables

           ldaa BoostDelta_Signed    ; load a with memory contents
           bpl  LDE2F          ; branch if plus (hi bit 0)
           nega                ; negate a (set high bit)
           staa Temp0          ; store a into memory
           bra  LDE68          ; branch

   LDE2F:  staa Temp0          ; store a into memory
           cmpa DBCRNG_DeltaBoostLimitNegativeForBoostCreep    ; compare a with memory contents (data is 03)
           bcc  LDE38          ; branch if greater or equal
           bra  LDE68          ; branch

   LDE38:  ldaa BoostDelta_Signed    ; load a with memory contents
           bmi  LDE68          ; branch if minus(hi bit 1)
           ldab BPRMIN_VNTMinimumBoostForIncrRateAdjustment    ; load b with memory contents (data is ff)
           bmi  LDE47          ; branch if minus(hi bit 1)
           addb BoostTarget    ; b=b+memory contents
           bcc  LDE4B          ; branch if greater or equal
           bra  LDE56          ; branch

   LDE47:  addb BoostTarget    ; b=b+memory contents
           bcc  LDE56          ; branch if greater or equal
   LDE4B:  cmpb Temp2      
           bcc  LDE56          ; branch if greater or equal
           ldaa BoostDelta_Signed    ; load a with memory contents
           cmpa BPRMN2_VNTMinimumDeltaBoostForIncrRateAdjustment    ; compare a with memory contents (data is 06)
           bls  LDE68          ; branch if lower or same
   LDE56:  ldx  #WGDCDB_VNTWGDutyCycleDecreaseFromDeltaBoost    ; load index with value
           ldaa BoostDelta_Signed    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           cmpa DECMAX_VNTWGDutyCylceMaxDecreaseFromIncrRate    ; compare a with memory contents (data is b4)
           bls  LDE69          ; branch if lower or same
           ldaa DECMAX_VNTWGDutyCylceMaxDecreaseFromIncrRate    ; load a with memory contents (data is b4)
           bra  LDE69          ; branch

   LDE68:  clra                ; a = 0
   LDE69:  staa WastegateDutyCycleDecreaseFromIncrRate    ; store a into memory
           ldaa Temp1          ; load a with memory contents
           beq  LDE7D          ; branch if equal (zero)
           cmpa MAPPT2_WastegateDutyCycleMapSwitchPoint2    ; compare a with memory contents (data is 1f)
           bcc  LDE7E          ; branch if greater or equal
           ldaa BoostActuatorBDutyCycle_WG    ; load a with memory contents
           suba WastegateDutyCycleDecreaseFromIncrRate
           bcc  LDE7B          ; branch if greater or equal
           clra                ; a = 0
   LDE7B:  staa BoostActuatorBDutyCycle_WG    ; store a into memory
   LDE7D:  rts                 ; return from subroutine

   LDE7E:  ldaa BoostTarget    ; load a with memory contents
           suba BaroPressure
           bcc  VNTBC_LookupWGDutyCycleBase    ; branch if greater or equal
           clra                ; a = 0
VNTBC_LookupWGDutyCycleBase:
           ldx  #DCWOT_FullThrottleWastegateDutyCycle_C8is100Percent_FromMap    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp4          ; store a into memory
           ldaa EngineRpm_HB    ; load a with memory contents
           ldx  #DCWADJ_FullThrottleWastegateDutyCycleAdjustment_FromRpm    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           bmi  LDEA3          ; branch if minus(hi bit 1)
           adda Temp4      
           bcs  LDE9F          ; branch if lower
           cmpa #0xc8          ; compare a with value -11001000-
           bls  LDEA8          ; branch if lower or same
   LDE9F:  ldaa #0xc8          ; load a with value -11001000-
           bra  LDEA8          ; branch

   LDEA3:  adda Temp4      
           bcs  LDEA8          ; branch if lower
           clra                ; a = 0
   LDEA8:  suba WastegateDutyCycleDecreaseFromIncrRate
           bcc  LDEAD          ; branch if greater or equal
           clra                ; a = 0
   LDEAD:  staa Temp4          ; store a into memory
           ldaa BoostTarget    ; load a with memory contents
           ldx  #DCCOR0_AdaptiveVNTCell0    ; load index with value
           brclr *BitFlags66, #b66_FullThrottle, VNTBC_LoadAdaptiveWGCell    ; branch if bit(s) clear
           inx                 ; increment index (x=x+1)
           ldab BaroPressure    ; load b with memory contents
           addb MAPPT_WastegateDutyCycleMapSwitchPoint    ;  (data is 5c)
           bcc  VNTBC_SelectAdaptiveWGCell    ; branch if greater or equal
           ldab #0xff          ; load b with value -11111111-
VNTBC_SelectAdaptiveWGCell:
           cba             
           bcs  VNTBC_LoadAdaptiveWGCell    ; branch if lower
           inx                 ; increment index (x=x+1)
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb DCRPM1_WastegateDutyCycleRpmBoundary1    ; compare b with memory contents (data is 4b)
           bcs  VNTBC_LoadAdaptiveWGCell    ; branch if lower
           inx                 ; increment index (x=x+1)
           cmpb DCRPM2_WastegateDutyCycleRpmBoundary2    ; compare b with memory contents (data is 58)
           bcs  VNTBC_LoadAdaptiveWGCell    ; branch if lower
           inx                 ; increment index (x=x+1)
           cmpb DCRPM3_WastegateDutyCycleRpmBoundary3    ; compare b with memory contents (data is 67)
           bcs  VNTBC_LoadAdaptiveWGCell    ; branch if lower
           inx                 ; increment index (x=x+1)
           cmpb DCRPM4_WastegateDutyCycleRpmBoundary4    ; compare b with memory contents (data is 8a)
           bcs  VNTBC_LoadAdaptiveWGCell    ; branch if lower
           inx                 ; increment index (x=x+1)
           cmpb DCRPM5_WastegateDutyCycleRpmBoundary5    ; compare b with memory contents (data is a9)
           bcs  VNTBC_LoadAdaptiveWGCell    ; branch if lower
           inx                 ; increment index (x=x+1)
VNTBC_LoadAdaptiveWGCell:
           ldab 0x00, X        ; load b with memory at index + value
           suba Temp2      
           bhi  VNTBC_BoostIsBelowTarget    ; branch if higher
           nega                ; negate a (set high bit)
           staa Temp3          ; store a into memory
           brset *BitFlags68, #b68_EndOfBlade, VNTBC_ControlBoostCreep    ; branch if bit(s) set
           bset *BitFlags68, #b68_EndOfBlade    ; set bits
           jmp  VNTBC_ClearBoostErrTimer

VNTBC_ControlBoostCreep:
           ldaa BoostDelta_Signed    ; load a with memory contents
           bmi  LDF02          ; branch if minus(hi bit 1)
           cmpa DBCRPS_DeltaBoostLimitPositiveForBoostCreep    ; compare a with memory contents (data is 01)
           bcc  LDF31          ; branch if greater or equal
   LDF02:  ldaa DBCRNG_DeltaBoostLimitNegativeForBoostCreep    ; load a with memory contents (data is 03)
           cmpa Temp0          ; compare a with memory contents
           bcs  LDF50          ; branch if lower
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa DCRPMLV_NoWastegateDutyCycleCorrectionBelowThisRpmVNT    ; compare a with memory contents (data is 51)
           bcc  LDF1A          ; branch if greater or equal
           ldaa Timer_BoostErrTimer    ; load a with memory contents
           inca                ; increment a
           cmpa DECPTV_AdaptiveDecAfterThisTimeVNT    ; compare a with memory contents (data is 1f)
           bcs  LDF52          ; branch if lower
           bra  LDF22          ; branch

   LDF1A:  ldaa Timer_BoostErrTimer    ; load a with memory contents
           inca                ; increment a
           cmpa DECPT_AdaptiveDecAfterThisTime    ; compare a with memory contents (data is 14)
           bcs  LDF52          ; branch if lower
   LDF22:  ldaa Temp3          ; load a with memory contents
           cmpa MPFLOR_StopAdaptiveWGWhenDeltaMapIsLessThanThis    ; compare a with memory contents (data is 02)
           bcs  LDF50          ; branch if lower
           cmpb DECLIM_LowerLimitOnWastegateDutyCycleCorrection    ; compare b with memory contents (data is 18)
           bls  LDF50          ; branch if lower or same
           decb            
           bra  VNTBC_UpdateAdaptiveWGControlMemory    ; branch

   LDF31:  ldaa BaroPressure    ; load a with memory contents
           adda OBCTRL_OverboostControlPoint    ;  (data is 75)
           bcc  LDF3A          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LDF3A:  cmpa MapValue       ; compare a with memory contents
           bhi  LDF02          ; branch if higher
           ldaa Timer_BoostErrTimer    ; load a with memory contents
           inca                ; increment a
           cmpa INCPT_AdaptiveIncAfterThisTime    ; compare a with memory contents (data is 0f)
           bcs  VNTBC_StoreBoostErrTimer    ; branch if lower
           cmpb DECLIM_LowerLimitOnWastegateDutyCycleCorrection    ; compare b with memory contents (data is 18)
           bls  LDF50          ; branch if lower or same
           subb WGDCON_WGDCOffsetNegatve    ; subtract memory contents from b (data is 08)
           bra  VNTBC_UpdateAdaptiveWGControlMemory    ; branch

   LDF50:  bra  VNTBC_ClearBoostErrTimer    ; branch

   LDF52:  bra  VNTBC_StoreBoostErrTimer    ; branch

VNTBC_BoostIsBelowTarget:
           brclr *BitFlags68, #b68_EndOfBlade, VNTBC_IncrementWGAdaptive    ; branch if bit(s) clear
           bclr *BitFlags68, #b68_EndOfBlade    ; clear bits
           bra  VNTBC_ClearBoostErrTimer    ; branch

VNTBC_IncrementWGAdaptive:
           brset *BitFlags6b, #$%00001000, VNTBC_ClearBoostErrTimer    ; branch if bit(s) set
           cmpa MPROOF_StopAdaptiveWGWhenMapIsThisCloseToBoostTarget    ; compare a with memory contents (data is 01)
           bcs  VNTBC_ClearBoostErrTimer    ; branch if lower
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bls  VNTBC_ClearBoostErrTimer    ; branch if lower or same
           cmpa TPSLIM_UpdateAdaptiveWGTPSUpperLimit    ; compare a with memory contents (data is 66)
           bcs  VNTBC_ClearBoostErrTimer    ; branch if lower
           ldaa DBCRNG_DeltaBoostLimitNegativeForBoostCreep    ; load a with memory contents (data is 03)
           cmpa Temp0          ; compare a with memory contents
           bcs  VNTBC_ClearBoostErrTimer    ; branch if lower
           ldaa WastegateDutyCycleIncreaseFromKnock    ; load a with memory contents
           bne  VNTBC_ClearBoostErrTimer    ; branch if not equal (not zero)
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa DCRPML_NoWastegateDutyCycleCorrectionBelowThisRpm    ; compare a with memory contents (data is 3b)
           bcs  VNTBC_ClearBoostErrTimer    ; branch if lower
           cmpa DCRPMH_NoWastegateDutyCycleCorrectionAboveThisRpm    ; compare a with memory contents (data is c8)
           bhi  VNTBC_ClearBoostErrTimer    ; branch if higher
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa DCRPMLV_NoWastegateDutyCycleCorrectionBelowThisRpmVNT    ; compare a with memory contents (data is 51)
           bcc  LDF99          ; branch if greater or equal
           ldaa Timer_BoostErrTimer    ; load a with memory contents
           inca                ; increment a
           cmpa INCPTV_AdaptiveIncAfterThisTimeVNT    ; compare a with memory contents (data is 2f)
           bcs  VNTBC_StoreBoostErrTimer    ; branch if lower
           bra  LDFA1          ; branch

   LDF99:  ldaa Timer_BoostErrTimer    ; load a with memory contents
           inca                ; increment a
           cmpa DECPTX_AdaptiveDecAfterThisTimeX    ; compare a with memory contents (data is 1f)
           bcs  VNTBC_StoreBoostErrTimer    ; branch if lower
   LDFA1:  cmpb WGMXER_MaxWGDCForBoostErrorCorrection    ; compare b with memory contents (data is bc)
           bcc  VNTBC_ClearBoostErrTimer    ; branch if greater or equal
           incb            
VNTBC_UpdateAdaptiveWGControlMemory:
           stab 0x00, X    
           stab VNT_BstCtrl_Var2    ; store b into memory
VNTBC_ClearBoostErrTimer:
           clra                ; a = 0
VNTBC_StoreBoostErrTimer:
           staa Timer_BoostErrTimer    ; store a into memory
           ldaa Temp4          ; load a with memory contents
           subb #0x80          ;  -10000000-
           bmi  LDFBF          ; branch if minus(hi bit 1)
           aba                 ; a=a+b
           bcs  VNTBC_LoadMaxWGDutyCycle    ; branch if lower
           cmpa #0xc8          ; compare a with value -11001000-
           bls  VNTBC_IncludeWGDutyCycleFromKnock    ; branch if lower or same
VNTBC_LoadMaxWGDutyCycle:
           ldaa #0xc8          ; load a with value -11001000-
           bra  VNTBC_IncludeWGDutyCycleFromKnock    ; branch

   LDFBF:  negb            
           sba                 ; subtract (a=a-b)
           bcc  VNTBC_IncludeWGDutyCycleFromKnock    ; branch if greater or equal
           clra                ; a = 0
VNTBC_IncludeWGDutyCycleFromKnock:
           suba WastegateDutyCycleIncreaseFromKnock
           bcc  VNTBC_StoreWGDutyCycle    ; branch if greater or equal
           clra                ; a = 0
VNTBC_StoreWGDutyCycle:
           jsr  NULL_ROUTINE    ; call subroutine
           staa BoostActuatorBDutyCycle_WG    ; store a into memory
           rts                 ; return from subroutine

BoostControlRoutine_T1:
           ldaa MapValue       ; load a with memory contents
           staa Temp2          ; store a into memory
           tab                 ; b = a
           suba BaroPressure
           bcc  LE232          ; branch if greater or equal
           clra                ; a = 0
   LE232:  staa Temp1          ; store a into memory
           ldaa DeltaBoostSampleCounter    ; load a with memory contents
           cmpa DLTBSC_DeltaBoostSampleCounterMax    ; compare a with memory contents (data is 07)
           bcc  T1BC_CalculateSignedDeltaBoost    ; branch if greater or equal
           inca                ; increment a
           bra  T1BC_StoreDeltaBoostSampleCounter    ; branch

T1BC_CalculateSignedDeltaBoost:
           tba                 ; a = b
           subb PreviousBoostOverBaro    ; b = b-memory contents
           staa PreviousBoostOverBaro    ; store a into memory
           bcc  LE24E          ; branch if greater or equal
           cmpb #0x80          ;  -10000000-
           bcc  T1BC_SaveSignedDeltaBoost    ; branch if greater or equal
           ldab #0x80          ; load b with value -10000000-
           bra  T1BC_SaveSignedDeltaBoost    ; branch

   LE24E:  cmpb #0x7f          ;  -01111111-
           bls  T1BC_SaveSignedDeltaBoost    ; branch if lower or same
           ldab #0x7f          ; load b with value -01111111-
T1BC_SaveSignedDeltaBoost:
           stab BoostDelta_Signed    ; store b into memory
           clra                ; a = 0
T1BC_StoreDeltaBoostSampleCounter:
           staa DeltaBoostSampleCounter

           jsr  GetBoostTargetFromTables

           ldaa BaroPressure    ; load a with memory contents
           adda MAPPT2_WastegateDutyCycleMapSwitchPoint2    ;  (data is 1f)
           cmpa MapValue       ; compare a with memory contents
           bls  T1BC_CalculateWGDutyCycleVars    ; branch if lower or same
           clra                ; a = 0
           staa WastegateDutyCycleIncreaseFromKnock    ; store a into memory
           jsr  NULL_ROUTINE    ; call subroutine
           staa BoostActuatorBDutyCycle_WG    ; store a into memory
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x1f          ;  -00011111-
           bne  LE2D3          ; branch if not equal (not zero)
           ldaa Timer_BoostTimer    ; load a with memory contents
           beq  LE2D3          ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_BoostTimer    ; store a into memory
   LE2D3:  rts                 ; return from subroutine

T1BC_CalculateWGDutyCycleVars:
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x1f          ;  -00011111-
           bne  LE32D          ; branch if not equal (not zero)
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb RPMBST_MinimumRpmToTrackBoostCreep    ; compare b with memory contents (data is 4c)
           bcs  LE32D          ; branch if lower
           ldaa Timer_BoostTimer    ; load a with memory contents
           inca                ; increment a
           beq  LE32D          ; branch if equal (zero)
           staa Timer_BoostTimer    ; store a into memory
           ldaa BoostDelta_Signed    ; load a with memory contents
           bpl  LE2F1          ; branch if plus (hi bit 0)
           nega                ; negate a (set high bit)
           staa Temp0          ; store a into memory
           bra  T1BC_ClearWGDutyCycleVars    ; branch

   LE2F1:  staa Temp0          ; store a into memory
           cmpa DBCRNG_DeltaBoostLimitNegativeForBoostCreep    ; compare a with memory contents (data is 03)
           bcc  LE2FA          ; branch if greater or equal
           bra  T1BC_ClearWGDutyCycleVars    ; branch

   LE2FA:  ldaa BoostDelta_Signed    ; load a with memory contents
           bmi  T1BC_ClearWGDutyCycleVars    ; branch if minus(hi bit 1)
           ldab BPRMIN_VNTMinimumBoostForIncrRateAdjustment    ; load b with memory contents (data is ff)
           bmi  LE309          ; branch if minus(hi bit 1)
           addb BoostTarget    ; b=b+memory contents
           bcc  LE30D          ; branch if greater or equal
           bra  LE318          ; branch

   LE309:  addb BoostTarget    ; b=b+memory contents
           bcc  LE318          ; branch if greater or equal
   LE30D:  cmpb Temp2      
           bcc  LE318          ; branch if greater or equal
           ldaa BoostDelta_Signed    ; load a with memory contents
           cmpa BPRMN2_VNTMinimumDeltaBoostForIncrRateAdjustment    ; compare a with memory contents (data is 06)
           bls  T1BC_ClearWGDutyCycleVars    ; branch if lower or same
   LE318:  ldx  #WGDCDB_VNTWGDutyCycleDecreaseFromDeltaBoost    ; load index with value
           ldaa BoostDelta_Signed    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           cmpa DECMAX_VNTWGDutyCylceMaxDecreaseFromIncrRate    ; compare a with memory contents (data is b4)
           bls  T1BC_StoreWGDutyCycleFromKnock    ; branch if lower or same
           ldaa DECMAX_VNTWGDutyCylceMaxDecreaseFromIncrRate    ; load a with memory contents (data is b4)
           bra  T1BC_StoreWGDutyCycleFromKnock    ; branch

T1BC_ClearWGDutyCycleVars:
           clra                ; a = 0
T1BC_StoreWGDutyCycleFromKnock:
           staa WastegateDutyCycleDecreaseFromIncrRate    ; store a into memory
   LE32D:  ldaa BoostTarget    ; load a with memory contents
           suba BaroPressure
           bcc  T1BC_LookupWGDutyCycleBase    ; branch if greater or equal
           clra                ; a = 0
T1BC_LookupWGDutyCycleBase:
           ldx  #DCWOT_FullThrottleWastegateDutyCycle_C8is100Percent_FromMap    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp4          ; store a into memory
           ldaa EngineRpm_HB    ; load a with memory contents
           ldx  #DCWADJ_FullThrottleWastegateDutyCycleAdjustment_FromRpm    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           bmi  LE352          ; branch if minus(hi bit 1)
           adda Temp4      
           bcs  LE34E          ; branch if lower
           cmpa #0xc8          ; compare a with value -11001000-
           bls  LE357          ; branch if lower or same
   LE34E:  ldaa #0xc8          ; load a with value -11001000-
           bra  LE357          ; branch

   LE352:  adda Temp4      
           bcs  LE357          ; branch if lower
           clra                ; a = 0
   LE357:  suba WastegateDutyCycleDecreaseFromIncrRate
           bcc  LE35C          ; branch if greater or equal
           clra                ; a = 0
   LE35C:  staa Temp4          ; store a into memory
           ldaa BoostTarget    ; load a with memory contents
           ldab BaroPressure    ; load b with memory contents
           addb MAPPT_WastegateDutyCycleMapSwitchPoint    ;  (data is 5c)
           bcc  T1BC_SelectAdaptiveWGCell    ; branch if greater or equal
           ldab #0xff          ; load b with value -11111111-
T1BC_SelectAdaptiveWGCell:
           ldx  #DCCOR1_AdaptiveWastegateCellBelowMAPPT    ; load index with value
           cba             
           bcs  T1BC_LoadAdaptiveWGCell    ; branch if lower
           brclr *BitFlags66, #b66_FullThrottle, T1BC_LoadAdaptiveWGCell    ; branch if bit(s) clear
           inx                 ; increment index (x=x+1)
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb DCRPM1_WastegateDutyCycleRpmBoundary1    ; compare b with memory contents (data is 4b)
           bcs  T1BC_LoadAdaptiveWGCell    ; branch if lower
           inx                 ; increment index (x=x+1)
           cmpb DCRPM2_WastegateDutyCycleRpmBoundary2    ; compare b with memory contents (data is 58)
           bcs  T1BC_LoadAdaptiveWGCell    ; branch if lower
           inx                 ; increment index (x=x+1)
           cmpb DCRPM3_WastegateDutyCycleRpmBoundary3    ; compare b with memory contents (data is 67)
           bcs  T1BC_LoadAdaptiveWGCell    ; branch if lower
           inx                 ; increment index (x=x+1)
T1BC_LoadAdaptiveWGCell:
           ldab 0x00, X        ; load b with memory at index + value
           brclr *Turbonator_Flags, #Turbonator_FuelOff, LE3A5    ; branch if bit(s) clear
           brclr *Turbonator_Flags, #Turbonator_MainFuelOff, LE3A5    ; branch if bit(s) clear
           brclr *Turbonator_Flags, #Turbonator_SparkCut, LE3A5    ; branch if bit(s) clear
           brclr *BitFlags6a, #b6a_WGDC, LE3B3    ; branch if bit(s) clear
           bclr *BitFlags6a, #b6a_WGDC    ; clear bits
           subb WGDCOF_WastegateDutyCycleOffset    ; subtract memory contents from b (data is 00)
           bcs  LE39F          ; branch if lower
           cmpb DECLIM_LowerLimitOnWastegateDutyCycleCorrection    ; compare b with memory contents (data is 18)
           bhi  LE3A2          ; branch if higher
   LE39F:  ldab DECLIM_LowerLimitOnWastegateDutyCycleCorrection    ; load b with memory contents (data is 18)
   LE3A2:  jmp  T1BC_UpdateAdaptiveWGControlMemory

   LE3A5:  suba MapValue   
           bhi  T1BC_BoostIsBelowTarget    ; branch if higher
           nega                ; negate a (set high bit)
           staa Temp3          ; store a into memory
           brset *BitFlags68, #b68_EndOfBlade, T1BC_ControlBoostCreep    ; branch if bit(s) set
           bset *BitFlags68, #b68_EndOfBlade    ; set bits
   LE3B3:  jmp  T1BC_ClearBoostErrTimer

T1BC_ControlBoostCreep:
           ldaa BoostDelta_Signed    ; load a with memory contents
           bmi  LE3BF          ; branch if minus(hi bit 1)
           cmpa DBCRPS_DeltaBoostLimitPositiveForBoostCreep    ; compare a with memory contents (data is 01)
           bcc  LE3EE          ; branch if greater or equal
   LE3BF:  ldaa DBCRNG_DeltaBoostLimitNegativeForBoostCreep    ; load a with memory contents (data is 03)
           cmpa Temp0          ; compare a with memory contents
           bcs  LE40D          ; branch if lower
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa DCRPMLV_NoWastegateDutyCycleCorrectionBelowThisRpmVNT    ; compare a with memory contents (data is 51)
           bcc  LE3D7          ; branch if greater or equal
           ldaa Timer_BoostErrTimer    ; load a with memory contents
           inca                ; increment a
           cmpa DECPTV_AdaptiveDecAfterThisTimeVNT    ; compare a with memory contents (data is 1f)
           bcs  LE40F          ; branch if lower
           bra  LE3DF          ; branch

   LE3D7:  ldaa Timer_BoostErrTimer    ; load a with memory contents
           inca                ; increment a
           cmpa DECPT_AdaptiveDecAfterThisTime    ; compare a with memory contents (data is 14)
           bcs  LE40F          ; branch if lower
   LE3DF:  ldaa Temp3          ; load a with memory contents
           cmpa MPFLOR_StopAdaptiveWGWhenDeltaMapIsLessThanThis    ; compare a with memory contents (data is 02)
           bcs  LE40D          ; branch if lower
           cmpb DECLIM_LowerLimitOnWastegateDutyCycleCorrection    ; compare b with memory contents (data is 18)
           bls  LE40D          ; branch if lower or same
           decb            
           bra  T1BC_UpdateAdaptiveWGControlMemory    ; branch

   LE3EE:  ldaa BaroPressure    ; load a with memory contents
           adda OBCTRL_OverboostControlPoint    ;  (data is 75)
           bcc  LE3F7          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LE3F7:  cmpa MapValue       ; compare a with memory contents
           bhi  LE3BF          ; branch if higher
           ldaa Timer_BoostErrTimer    ; load a with memory contents
           inca                ; increment a
           cmpa INCPT_AdaptiveIncAfterThisTime    ; compare a with memory contents (data is 0f)
           bcs  T1BC_StoreBoostErrTimer    ; branch if lower
           cmpb DECLIM_LowerLimitOnWastegateDutyCycleCorrection    ; compare b with memory contents (data is 18)
           bls  LE40D          ; branch if lower or same
           subb WGDCON_WGDCOffsetNegatve    ; subtract memory contents from b (data is 08)
           bra  T1BC_UpdateAdaptiveWGControlMemory    ; branch

   LE40D:  bra  T1BC_ClearBoostErrTimer    ; branch

   LE40F:  bra  T1BC_StoreBoostErrTimer    ; branch

T1BC_BoostIsBelowTarget:
           brclr *BitFlags68, #b68_EndOfBlade, T1BC_IncrementWGAdaptive    ; branch if bit(s) clear
           bclr *BitFlags68, #b68_EndOfBlade    ; clear bits
           bra  T1BC_ClearBoostErrTimer    ; branch

T1BC_IncrementWGAdaptive:
           cmpa MPROOF_StopAdaptiveWGWhenMapIsThisCloseToBoostTarget    ; compare a with memory contents (data is 01)
           bcs  T1BC_ClearBoostErrTimer    ; branch if lower
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bls  T1BC_ClearBoostErrTimer    ; branch if lower or same
           cmpa TPSLIM_UpdateAdaptiveWGTPSUpperLimit    ; compare a with memory contents (data is 66)
           bcs  T1BC_ClearBoostErrTimer    ; branch if lower
           ldaa MapValue       ; load a with memory contents
           suba MapAverageValue_HB
           bcc  LE431          ; branch if greater or equal
           nega                ; negate a (set high bit)
   LE431:  cmpa MPDEL2_MinRetardToDerateWGDC2    ; compare a with memory contents (data is 03)
           bhi  T1BC_ClearBoostErrTimer    ; branch if higher
           ldaa WastegateDutyCycleIncreaseFromKnock    ; load a with memory contents
           bne  T1BC_ClearBoostErrTimer    ; branch if not equal (not zero)
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa DCRPML_NoWastegateDutyCycleCorrectionBelowThisRpm    ; compare a with memory contents (data is 3b)
           bcs  T1BC_ClearBoostErrTimer    ; branch if lower
           cmpa DCRPMH_NoWastegateDutyCycleCorrectionAboveThisRpm    ; compare a with memory contents (data is c8)
           bhi  T1BC_ClearBoostErrTimer    ; branch if higher
           ldaa CoolantTemp    ; load a with memory contents
           cmpa DCCTSL_NoWastegateDutyCycleCorrectionBelowThisCoolantTemp    ; compare a with memory contents (data is b1)
           bcs  T1BC_ClearBoostErrTimer    ; branch if lower
           ldaa Timer_BoostErrTimer    ; load a with memory contents
           inca                ; increment a
           cmpa DECPTX_AdaptiveDecAfterThisTimeX    ; compare a with memory contents (data is 1f)
           bcs  T1BC_StoreBoostErrTimer    ; branch if lower
           cmpb WGMXER_MaxWGDCForBoostErrorCorrection    ; compare b with memory contents (data is bc)
           bcc  T1BC_ClearBoostErrTimer    ; branch if greater or equal
           incb            
T1BC_UpdateAdaptiveWGControlMemory:
           stab 0x00, X    
T1BC_ClearBoostErrTimer:
           clra                ; a = 0
T1BC_StoreBoostErrTimer:
           staa Timer_BoostErrTimer    ; store a into memory
           ldaa Temp4          ; load a with memory contents
           subb #0x80          ;  -10000000-
           bmi  LE471          ; branch if minus(hi bit 1)
           aba                 ; a=a+b
           bcs  T1BC_LoadMaxWGDutyCycle    ; branch if lower
           cmpa #0xc8          ; compare a with value -11001000-
           bls  T1BC_IncludeWGDutyCycleFromKnock    ; branch if lower or same
T1BC_LoadMaxWGDutyCycle:
           ldaa #0xc8          ; load a with value -11001000-
           bra  T1BC_IncludeWGDutyCycleFromKnock    ; branch

   LE471:  negb            
           sba                 ; subtract (a=a-b)
           bcc  T1BC_IncludeWGDutyCycleFromKnock    ; branch if greater or equal
           clra                ; a = 0
T1BC_IncludeWGDutyCycleFromKnock:
           suba WastegateDutyCycleIncreaseFromKnock
           bcc  T1BC_StoreWGDutyCycle    ; branch if greater or equal
           clra                ; a = 0
T1BC_StoreWGDutyCycle:
           jsr  NULL_ROUTINE    ; call subroutine
           staa BoostActuatorBDutyCycle_WG    ; store a into memory
           rts                 ; return from subroutine

LookupAndKeepSmallerBoostGoal:
           jsr  Lookup4ByteTable    ; call subroutine
KeepSmallerBoostGoal:
           cmpa Temp4          ; compare a with memory contents
           bcc  LDB8A          ; branch if greater or equal
           staa Temp4          ; store a into memory
   LDB8A:  rts                 ; return from subroutine

GetBoostTargetFromTables:
           ldx  #WSGRPM_AllowedBoost_FromRpm    ; load index with value
           ldaa EngineRpm_HB    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp4          ; store a into memory
           brclr *AdaptiveRetardIndex, #$%11111111, BC_CalculateHiAltBaroRPMBoostLookup    ; branch if bit(s) clear
           ldab Temp2          ; load b with memory contents
           cmpb ARMPIC_AdaptiveRetard_MinMAPForAdjustment    ; compare b with memory contents (data is 79)
           bls  BC_CalculateHiAltBaroRPMBoostLookup    ; branch if lower or same
           ldx  #WSGRPA_AllowedBoostKnock_FromRpm    ; load index with value
           ldaa EngineRpm_HB    ; load a with memory contents
           jsr  LookupAndKeepSmallerBoostGoal    ; call subroutine
BC_CalculateHiAltBaroRPMBoostLookup:
; to consolidate Boost looup, add code here to check for VNT, skip to LDDE8 if not VNT

           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_VNT          ;  -00000001-
           beq  LDDE8          ; branch if equal (zero)

           ldx  #HABARO_VNTHighAltitudeBoostCalculationFromBaro    ; load index with value
           ldaa BaroPressure    ; load a with memory contents
           cmpa 0x05, X        ; compare a with memory at index + value
           bcc  LDDE8          ; branch if greater or equal
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp0          ; store a into memory
           ldx  #HARPM_VNTHighAltitudeBoostCalculationFromRPM    ; load index with value
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa 0x01, X        ; compare a with memory at index + value
           bcs  LDDE8          ; branch if lower
           jsr  Lookup4ByteTable    ; call subroutine
           ldab Temp0          ; load b with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           tab                 ; b = a
           ldaa VNTALT_VNTHighAltitudeBoostSetpointBase    ; load a with memory contents (data is 6a)
           sba                 ; subtract (a=a-b)
           jsr  KeepSmallerBoostGoal    ; call subroutine
   LDDE8:  ldx  #WSGTIM_AllowedBoost_FromTime    ; load index with value
           ldaa Timer_BoostTimer    ; load a with memory contents
           jsr  LookupAndKeepSmallerBoostGoal    ; call subroutine
           ldx  #WSGCLT_AllowedBoost_FromTemp    ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           jsr  LookupAndKeepSmallerBoostGoal    ; call subroutine
           ldx  #WSGCHG_AllowedBoost_FromChargeTemp    ; load index with value
           ldaa ChargeTemp    ; load a with memory contents
           jsr  LookupAndKeepSmallerBoostGoal    ; call subroutine
           ldx  #MXSBST_AllowedBoost_FromSpeed    ; load index with value
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           jsr  LookupAndKeepSmallerBoostGoal    ; call subroutine
           brset *BitFlags66, #b66_FullThrottle, BC_LoadStagingBoostAndLookup ;LDE1C    ; branch if bit(s) set
           ldx  #WSGPRT_AllowedBoostPartThrottle_FromThrottle    ; load index with value
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bcc  LDE19          ; branch if greater or equal
           clra                ; a = 0
   LDE19:  jsr  LookupAndKeepSmallerBoostGoal    ; call subroutine

BC_LoadStagingBoostAndLookup:
; add code to lookup specific boost target while staging
           brclr *Turbonator_Flags, #Turbonator_Staging, BC_CheckBoostSwitch 	 ; don't do anything unless we're staging, normal spark
           ldaa STGBST_AllowedBoostDuringStaging    ; staging boost constant
           jsr  KeepSmallerBoostGoal

BC_CheckBoostSwitch:
; the switchable boost code uses a constant for the "lo" boost setting
; if the boost switch is enabled (set to "hi" boost), the code ignores the "lo" constant
; the code first checks to see if the switchable boost option is even enabled...

; here, I check to see if the switchable boost is enabled or not, if not just skip to StoreBoostTarget...
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
           jsr  KeepSmallerBoostGoal

BC_FinalBoostTarget:
           ldaa Temp4          ; load a with memory contents
           adda BaroPressure
           bcc  BC_StoreBoostTarget    ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
BC_StoreBoostTarget:
           staa BoostTarget    ; store a into memory
           rts

  ;.org    0xE000
Interrupt_SerialCommunications:
           sei                 ; disable interrupts
           lds  #0x60e0        ;  -01100000 11100000-
           ldd  #0xb978        ; load d (a&b) with value -10111001 01111000-
           staa CPU_SysConfigOptionReg
           stab CPU_HighPriorityInterruptMask    ; store b into memory
           ldaa CPU_BlockProtReg    ; load a with memory contents
           anda #0xf8          ; AND a with value -11111000-
           staa CPU_BlockProtReg
           ldd  #0x0001         ; load d (a&b) with value -00000000 00000001-
           staa CPU_PortA_Control
           stab CPU_TimerInterruptMask2    ; store b into memory
           clra                ; a = 0
           staa CPU_OutputCompare1Mask
           ldd  #0x2a18        ; load d (a&b) with value -00101010 00011000-
           staa CPU_TimerControlReg1
           stab CPU_TimerControlReg2    ; store b into memory
           ldaa #0x78          ; load a with value -01111000-
           staa CPU_HardwareTimerForceCompare
           ldaa #0x01          ; load a with value -00000001-
           staa CPU_SerialBaudRate
           ldaa #0x0c          ; load a with value -00001100-
           staa CPU_SerialControlReg2
           jsr  ResetCopTimer  ; call subroutine
           ldd  CPU_SerialStatus
           ldx  #0x00c8        ; load index with value
WaitForSerialCommand:  
           ldd  CPU_SerialStatus
           bita #0x20          ;  -00100000-
           bne  CheckSerialCommand          ; branch if not equal (not zero)
           dex                 ; decrement index (x=x-1)
           bne  WaitForSerialCommand          ; branch if not equal (not zero)
StartNormalNoSerial:
           jmp  Goto_RealTimeInterrupt

CheckSerialCommand:
           stab CPU_SerialData    ; store b into memory
           subb #0xf7          ;  -11110111-
           bcs  StartNormalNoSerial          ; branch if lower
           ldx  #Reset_SubroutineTable         ; load index with value
           lslb            
           abx                 ; add b to index
           ldx  0x00, X    
           ldY #0x0600         ; load Y index -00000110 00000000-
   LE062:  ldd  CPU_SerialStatus
           deY                 ; decrement Y
           bne  LE062          ; branch if not equal (not zero)
           clr  L60E1          ; zero byte at memory location
           clr  L60E2          ; zero byte at memory location
           jmp  0x00, X        ; indexed jump

Reset_SubroutineTable:
          .word   MoveVectorsToRAM
          .word   CallHandleSerialStream
          .word   Goto_RealTimeInterrupt
          .word   MoveVectorsToRAM
          .word   Goto_RealTimeInterrupt
          .word   CallHandleSerialStream
          .word   Goto_RealTimeInterrupt
          .word   Goto_RealTimeInterrupt
          .word   Goto_RealTimeInterrupt

MoveVectorsToRAM:
           jsr  HandleSerialStreamandTiming          ; call subroutine
           ldab #0x00          ; load b with value -00000000-
           stab InterruptPointer_MainRealTimeInterrupt    ; store b into memory (data is 7e)
   LE08B:  tba                 ; a = b
           eora InterruptPointer_MainRealTimeInterrupt    ;  (data is 7e)
           anda #0x80          ; AND a with value -10000000-
           bne  LE08B          ; branch if not equal (not zero)
   LE093:  ldd  CPU_TimerCounterRegHigh
           std  CPU_TimerCounterRegHighX
   LE099:  ldd  CPU_SerialStatus
           bita #0x20          ;  -00100000-
           bne  LE0A8          ; branch if not equal (not zero)
           jsr  ResetCopTimer    ; call subroutine
           jsr  CheckCPUTimerCounterReg          ; call subroutine
           bra  LE099          ; branch

   LE0A8:  cpx  #InterruptPointer_MainRealTimeInterrupt    ;  -10010000 00000000-
           beq  LE0CB          ; branch if equal (zero)
           cpx  #0xb400        ;  -10110100 00000000-
           bne  LE0B5          ; branch if not equal (not zero)
           ldx  #0xB800    ; load index with value
   LE0B5:  stab 0x00, X    
   LE0B7:  tba                 ; a = b
           eora 0x00, X    
           anda #0x80          ; AND a with value -10000000-
           bne  LE0B7          ; branch if not equal (not zero)
           ldaa CPU_SerialStatus    ; load a with memory contents
           ldaa 0x00, X        ; load a with memory at index + value
           staa CPU_SerialData
           cba             
           beq  LE0D3          ; branch if equal (zero)
           bra  Goto_RealTimeInterrupt          ; branch

   LE0CB:  ldaa CPU_SerialStatus    ; load a with memory contents
           ldaa #0x7e          ; load a with value -01111110-
           staa CPU_SerialData
   LE0D3:  inx                 ; increment index (x=x+1)
           deY                 ; decrement Y
           bne  LE093          ; branch if not equal (not zero)
           ldab #0x7e          ; load b with value -01111110-
           stab InterruptPointer_MainRealTimeInterrupt    ; store b into memory (data is 7e)
   LE0DD:  tba                 ; a = b
           eora InterruptPointer_MainRealTimeInterrupt    ;  (data is 7e)
           anda #0x80          ; AND a with value -10000000-
           bne  LE0DD          ; branch if not equal (not zero)
           bra  Goto_RealTimeInterrupt          ; branch

CallHandleSerialStream:
           jsr  HandleSerialStreamandTiming          ; call subroutine
   LE0EA:  ldd  CPU_TimerCounterRegHigh
           std  CPU_TimerCounterRegHighX
LoopUntilDataIsReady2:
           ldd  CPU_SerialStatus
           bita #0x20          ;  -00100000-
           bne  ReadROMFromB800          ; branch if not equal (not zero)
           jsr  ResetCopTimer    ; call subroutine
           jsr  CheckCPUTimerCounterReg          ; call subroutine
           bra  LoopUntilDataIsReady2          ; branch

ReadROMFromB800:
           cpx  #0xb400        ;  -10110100 00000000-
           bne  LE107          ; branch if not equal (not zero)
           ldx  #0xB800    ; load index with value
   LE107:  ldaa 0x00, X        ; load a with memory at index + value
           staa CPU_SerialData
           inx                 ; increment index (x=x+1)
           deY                 ; decrement Y
           beq  Goto_RealTimeInterrupt          ; branch if equal (zero)
           cba             
           beq  LE0EA          ; branch if equal (zero)
   LE114:  ldd  CPU_TimerCounterRegHigh
           std  CPU_TimerCounterRegHighX
   LE11A:  jsr  ResetCopTimer    ; call subroutine
           ldd  CPU_SerialStatus
           bita #0x20          ;  -00100000-
           bne  LE129          ; branch if not equal (not zero)
           jsr  CheckCPUTimerCounterReg          ; call subroutine
           bra  LE11A          ; branch

   LE129:  cmpb #0xfd          ;  -11111101-
           bne  LE141          ; branch if not equal (not zero)
           stab CPU_SerialData    ; store b into memory
           ldab #0x02          ; load b with value -00000010-
   LE132:  clra                ; a = 0
   LE133:  deca                ; decrement a
           bne  LE133          ; branch if not equal (not zero)
           jsr  ResetCopTimer    ; call subroutine
           decb            
           bne  LE132          ; branch if not equal (not zero)
           ldd  CPU_SerialStatus
           bra  LE0EA          ; branch

   LE141:  cmpb #0x86          ;  -10000110-
           beq  LE114          ; branch if equal (zero)

Goto_RealTimeInterrupt:
           jsr  ResetCopTimer    ; call subroutine
           ldY #0x0100         ; load Y index -00000001 00000000-
   LE14C:  deY                 ; decrement Y
           bne  LE14C          ; branch if not equal (not zero)
           jsr  ResetCopTimer    ; call subroutine
           clr  L60E1          ; zero byte at memory location
           ldaa InterruptPointer_MainRealTimeInterrupt    ; load a with memory contents (data is 7e)
           cmpa #0x7e          ; compare a with value -01111110-
           bne  InterruptPointerNoMatch          ; branch if not equal (not zero)
           lds  #TopOfStack        ;  -01100000 11111111-
           jmp  InterruptPointer_MainRealTimeInterrupt

InterruptPointerNoMatch:
           jsr  ResetCopTimer    ; call subroutine
           ldd  CPU_SerialStatus
           bita #0x20          ;  -00100000-
           beq  InterruptPointerNoMatch          ; branch if equal (zero)
           jmp  CheckSerialCommand

HandleSerialStreamandTiming:
           ldd  CPU_SerialStatus
           bsr  WaitForSerialData_HandleTiming          ; call subroutine
           pshb                ; push b onto stack
           bsr  WaitForSerialData_HandleTiming          ; call subroutine
           pshb                ; push b onto stack
           bsr  WaitForSerialData_HandleTiming          ; call subroutine
           pshb                ; push b onto stack
           bsr  WaitForSerialData_HandleTiming          ; call subroutine
           pshb                ; push b onto stack
           pulx                ; pull index from stack
           cpx  #0xB800    ;  -10111000 00000000-
           bcc  LE18E          ; branch if greater or equal
           cpx  #0xb400        ;  -10110100 00000000-
           bcs  LE18E          ; branch if lower
           pulx                ; pull index from stack
           pulx                ; pull index from stack
           bra  Goto_RealTimeInterrupt          ; branch

   LE18E:  puly                ; pop Y from stack
           rts                 ; return from subroutine

WaitForSerialData_HandleTiming:
           ldd  CPU_TimerCounterRegHigh
           std  CPU_TimerCounterRegHighX
LoopUntilDataIsReady:
           ldd  CPU_SerialStatus
           bita #0x20          ;  -00100000-
           bne  ReadSerialData          ; branch if not equal (not zero)
           jsr  ResetCopTimer    ; call subroutine
           ldd  CPU_TimerCounterRegHigh
           subd CPU_TimerCounterRegHighX
           bmi  LE1B7          ; branch if minus(hi bit 1)
           bra  LoopUntilDataIsReady          ; branch

ReadSerialData:
           stab CPU_SerialData    ; store b into memory
   LE1AE:  rts                 ; return from subroutine

CheckCPUTimerCounterReg:
           ldd  CPU_TimerCounterRegHigh
           subd CPU_TimerCounterRegHighX
           bpl  LE1AE          ; branch if plus (hi bit 0)
   LE1B7:  pulx                ; pull index from stack
           bra  Goto_RealTimeInterrupt          ; branch

  ;.org    0xE200
FDRSerialIORoutine:
           stab 0x00, X    
           ldY #0x003a         ; load Y index -00000000 00111010-
   LE206:  deY                 ; decrement Y
           bne  LE20C          ; branch if not equal (not zero)
           clra                ; a = 0
           rts                 ; return from subroutine

   LE20C:  tba                 ; a = b
           eora 0x00, X    
           bmi  LE206          ; branch if minus(hi bit 1)
           ldab 0x00, X        ; load b with memory at index + value
           ldaa CPU_SerialStatus    ; load a with memory contents
           stab CPU_SerialData    ; store b into memory
           ldaa #0xfc          ; load a with value -11111100-
           rts                 ; return from subroutine

ResetCopTimer:
           psha                ; push a onto stack
           ldaa #0x55          ; load a with value -01010101-
           staa CPU_ArmResetCopTimerReg
           lsla                ; logical shift left a
           staa CPU_ArmResetCopTimerReg
           pula                ; pull a from stack
           rts                 ; return from subroutine

IncrementLoopCounters_MM:
           inc  Counter_MainLoop
           bne  LE49D          ; branch if not equal (not zero)
           ldaa #0xff          ; load a with value -11111111-
           cmpa KeyOnOrEngineRunningTime    ; compare a with memory contents
           beq  LE48F          ; branch if equal (zero)
           inc  KeyOnOrEngineRunningTime
   LE48F:  brset *BitFlags6d, #b6d_FuelEngineNotRunning, LE49D    ; branch if bit(s) set
           bclr *BitFlags_AIS, #b10_bit1 | b10_bit0    ; clear bits
           cmpa EngineRunningTimeMaxFF    ; compare a with memory contents
           beq  LE49D          ; branch if equal (zero)
           inc  EngineRunningTimeMaxFF
   LE49D:  ldaa TimerOverflowsBetweenDistPulses    ; load a with memory contents
           cmpa #0x02          ; compare a with value -00000010-
           bcs  LE4B0          ; branch if lower
           bset *BitFlags6d, #b6d_FuelEngineNotRunning | b6d_Starting | b6d_DisableNormalDwell    ; set bits
           bclr *BitFlags66, #b66_OpenLoop | b66_O2Valid    ; clear bits
           bclr *BitFlags67, #b67_bit1    ; clear bits
           ldaa EngineRunningTimeMaxFF    ; load a with memory contents
           staa EngineRunningTimeBeforeStall    ; store a into memory
   LE4B0:  ldaa Timer_AisChanges    ; load a with memory contents
           inca                ; increment a
           beq  LE4B7          ; branch if equal (zero)
           staa Timer_AisChanges    ; store a into memory
   LE4B7:  rts                 ; return from subroutine

DRB_SomethingLikeEMR_MM:
           brset *BitFlags6c, #b6c_EMR_1, LE4E6    ; branch if bit(s) set
           brclr *BitFlags6c, #b6c_bit1, LE4E6    ; branch if bit(s) clear
           brset *BitFlags6d, #b6d_FuelEngineNotRunning, LE4E6    ; branch if bit(s) set
           sei                 ; disable interrupts
           ldaa BitFlags6a     ; load a with memory contents
           bita #b6a_DRBToggle2 | b6a_DRBToggle1          ;  -00000011-
           bne  LE4E4          ; branch if not equal (not zero)
           bset *BitFlags6c, #b6c_EMR_1    ; set bits
           ldaa LB613          ; load a with memory contents (data is ff)
           inca                ; increment a
           beq  LE4E4          ; branch if equal (zero)
           cmpa #0x07          ; compare a with value -00000111-
           bcs  LE4DB          ; branch if lower
           bset *BitFlags6c, #b6c_bit3    ; set bits
   LE4DB:  staa DRBOffsetStored_LB    ; store a into memory
           ldaa #0x13          ; load a with value -00010011-
           staa DRBOffsetStored_HB    ; store a into memory
           bset *BitFlags6a, #b6a_DRBToggle1    ; set bits
   LE4E4:  cli                 ; enable interrupts
           nop                 ; no operation
   LE4E6:  sei                 ; disable interrupts
           brset *BitFlags6a, #b6a_DRBToggle1, LE540    ; branch if bit(s) set
           ldaa LB7E1          ; load a with memory contents (data is ff)
           coma            
           cmpa LB7E0          ; compare a with memory contents (data is ff)
           beq  LE4F6          ; branch if equal (zero)
           ldaa #0x08          ; load a with value -00001000-
   LE4F6:  staa CCDBatteryVoltsOutput    ; store a into memory
           brclr *BitFlags6c, #b6c_bit2, LE52B    ; branch if bit(s) clear
           ldaa #0x16          ; load a with value -00010110-
           ldab #0x4a          ; load b with value -01001010-
           brclr *BitFlags6a, #b6a_DRBToggle2, LE524    ; branch if bit(s) clear
           cmpa DRBOffsetStored_HB    ; compare a with memory contents
           beq  LE51D          ; branch if equal (zero)
           inca                ; increment a
           cmpa DRBOffsetStored_HB    ; compare a with memory contents
           bne  LE52B          ; branch if not equal (not zero)
           bset *BitFlags6a, #b6a_DRBToggle1    ; set bits
           bclr *BitFlags6a, #b6a_DRBToggle2    ; clear bits
           bclr *BitFlags6c, #b6c_bit2    ; clear bits
           ldaa #0x13          ; load a with value -00010011-
           clrb                ; b = 0
           stab Counter_ACControl1    ; store b into memory
           bra  LE527          ; branch

   LE51D:  bset *BitFlags6a, #b6a_DRBToggle1    ; set bits
           inca                ; increment a
           comb            
           bra  LE527          ; branch

   LE524:  bset *BitFlags6a, #b6a_DRBToggle2 | b6a_DRBToggle1    ; set bits
   LE527:  staa DRBOffsetStored_HB    ; store a into memory
           stab DRBOffsetStored_LB    ; store b into memory
   LE52B:  ldaa LB617          ; load a with memory contents (data is ff)
           coma            
           cmpa LB616          ; compare a with memory contents (data is ff)
           bne  LE53D          ; branch if not equal (not zero)
           cmpa #0x4a          ; compare a with value -01001010-
           bne  LE53D          ; branch if not equal (not zero)
           bset *BitFlags6c, #b6c_bit1    ; set bits
           bra  LE540          ; branch

   LE53D:  bclr *BitFlags6c, #b6c_bit1    ; clear bits
   LE540:  cli                 ; enable interrupts
           brclr *BitFlags6c, #b6c_bit3, LE56A    ; branch if bit(s) clear
           sei                 ; disable interrupts
           brset *BitFlags6a, #b6a_DRBToggle1, LE569    ; branch if bit(s) set
           ldaa #0x16          ; load a with value -00010110-
           ldab #0xee          ; load b with value -11101110-
           brclr *BitFlags6a, #b6a_DRBToggle2, LE562    ; branch if bit(s) clear
           cmpa DRBOffsetStored_HB    ; compare a with memory contents
           bne  LE569          ; branch if not equal (not zero)
           inca                ; increment a
           bset *BitFlags6a, #b6a_DRBToggle1    ; set bits
           bclr *BitFlags6a, #b6a_DRBToggle2    ; clear bits
           bclr *BitFlags6c, #b6c_bit3    ; clear bits
           bra  LE565          ; branch

   LE562:  bset *BitFlags6a, #b6a_DRBToggle2 | b6a_DRBToggle1    ; set bits
   LE565:  staa DRBOffsetStored_HB    ; store a into memory
           stab DRBOffsetStored_LB    ; store b into memory
   LE569:  cli                 ; enable interrupts
   LE56A:  rts                 ; return from subroutine

CALCULATE_RPM_SPEED_AND:
           ldaa MapValue       ; load a with memory contents
           cmpa MapAverageValue_HB    ; compare a with memory contents
           bcc  LE587          ; branch if greater or equal
           ldaa EngineRpm_HB    ; load a with memory contents
           staa Temp2          ; store a into memory
           bsr  CalculateEngineRpm_MM    ; call subroutine
           stD *EngineRpm_HB    ; store D to RAM
           suba Temp2      
           bcs  LE58B          ; branch if lower
           cmpa DLTRPM2_RPMDeltaForRPMFilter    ; compare a with memory contents (data is ff)
           bcs  LE58B          ; branch if lower
           ldaa MapValue       ; load a with memory contents
           staa MapAverageValue_HB    ; store a into memory
           rts                 ; return from subroutine

   LE587:  bsr  CalculateEngineRpm_MM    ; call subroutine
           stD *EngineRpm_HB    ; store D to RAM
   LE58B:  rts                 ; return from subroutine

CalculateEngineRpm_MM:
           ldY #DistributorFallingEdgePulsewidth_HB    ; load Y index -00000000 01100001-
           ldd  #0x0727        ; load d (a&b) with value -00000111 00100111-
           ldx  #0x0e00        ; load index with value
           tst  TimerOverflowsBetweenDistPulses
           beq  CalculateVehicleSpeedOrEngineRpms    ; branch if equal (zero)
           deY                 ; decrement Y
           ldd  #0x0007    ; load d (a&b) with value -00000000 00000111-
           ldx  #0x270e        ; load index with value
CalculateVehicleSpeedOrEngineRpms:
           pshx                ; pull index from stack
           ldX  0, Y           ; load X indexed to Y
           fdiv            
           stx  Temp0          ; store index into memory
           pula                ; pull a from stack
           pulb                ; pull b from stack  D=X
           ldX  0, Y           ; load X indexed to Y  X=Value from Y
           idiv
           xgDX                ; exchange D and X
           addd Temp0          ; d = d + memory contents
           bcc  LE5B8          ; branch if greater or equal
           ldd  #0xFFFF         ; load d (a&b) with value -11111111 11111111-
   LE5B8:  rts                 ; return from subroutine

Lookup4ByteTable:
           ldY #L0000          ; load Y index -00000000 00000000-
           ldab 0x00, X        ; load b with memory at index + value
           aby                 ; add b to y
           inx                 ; increment index (x=x+1)
           ldab #0x04          ; load b with value -00000100-
           cmpa 0x00, X        ; compare a with memory at index + value
           bhi  LE5CC          ; branch if higher
   LE5C8:  clrb                ; b = 0
           bra  LE5E7          ; branch

   LE5CB:  abx                 ; add b to index
   LE5CC:  deY                 ; decrement Y
           beq  LE5C8          ; branch if equal (zero)
           cmpa 0x04, X        ; compare a with memory at index + value
           bcc  LE5CB          ; branch if greater or equal
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
   LE5E7:  addb 0x01, X        ; add memory at index + value to b
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
           ldY 0x00, X        ; load Y indexed to X -00000000-
           bsr  ScaleYbyA      ; call subroutine
           pula                ; pull a from stack
           tsta                ; test a
           xgDY                ; exchange D and Y
           beq  LE60F          ; branch if equal (zero)
           addd 0x00, X    
           bcc  LE60F          ; branch if greater or equal
           ldd  #0xFFFF         ; load d (a&b) with value -11111111 11111111-
   LE60F:  rts                 ; return from subroutine

ProcessMapOrTpsBlockData:
           ldaa 0x03, X        ; load a with memory at index + value
           bne  LE619          ; branch if not equal (not zero)
           clrb                ; b = 0
           ldaa 0x02, X        ; load a with memory at index + value
           bra  LE62C          ; branch

   LE619:  ldY 0x00, X        ; load Y indexed to X -00000000-
           bsr  ScaleYbyA      ; call subroutine
           pshy                ; push Y onto stack
           ldd  0x02, X    
           mul                 ; multiply (d=a*b)
           tSY                 ; transfer stack to Y
           subD 0x00, Y       ; subtract from D indexed to Y -00000000-
           puly                ; pop Y from stack
           addd 0x00, X    
   LE62C:  std  0x00, X        ; store d into index plus offset
           rts                 ; return from subroutine

DetermineNumberOfOverflowsBetweenDistributorPulses_MM:
           subd LastDistributorFallingEdgeTime    ; d = d - memory contents
           staa Temp5          ; store a into memory
           ldaa Counter_TimerPastHalfwayBetweenDistPulses    ; load a with memory contents
           lsrd                ; shift right (d=d/2)
           eorb Temp5      
           bpl  LE641          ; branch if plus (hi bit 0)
           ldaa Counter_TimerPastHalfwayBetweenDistPulses    ; load a with memory contents
           inca                ; increment a
           beq  LE641          ; branch if equal (zero)
           staa Counter_TimerPastHalfwayBetweenDistPulses    ; store a into memory
   LE641:  ldaa Counter_TimerPastHalfwayBetweenDistPulses    ; load a with memory contents
           lsra            
           cmpa TimerOverflowsBetweenDistPulses    ; compare a with memory contents
           bcs  LE64A          ; branch if lower
           staa TimerOverflowsBetweenDistPulses    ; store a into memory
   LE64A:  rts                 ; return from subroutine

GetControlFeedback_DetermineIfShutdownRequired_MM:
           ldab SwitchPortAccessReg1    ; load b with memory contents
           bitb #sp1_OC1Toggle          ;  -01000000-
           bne  LE656          ; branch if not equal (not zero)
   LE652:  clr  CountdownTimerFromKeyOn    ; zero byte at memory location
           rts                 ; return from subroutine

   LE656:  ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           bne  LE664          ; branch if not equal (not zero)
           ldaa #0x17          ; load a with value -00010111-
           ldab TimerOverflowsBetweenDistPulses    ; load b with memory contents
           cmpb #0x04          ;  -00000100-
           bcs  LE664          ; branch if lower
           ldaa #0x09          ; load a with value -00001001-
   LE664:  deca                ; decrement a
           beq  LE66A          ; branch if equal (zero)
           staa CountdownTimerFromKeyOn    ; store a into memory
           rts                 ; return from subroutine

   LE66A:  sei                 ; disable interrupts
           bset *BitFlags6e, #b6e_PIAKeepIntEnabled    ; set bits
           ldaa #0x7c          ; load a with value -01111100-
           ldab #0x02          ; load b with value -00000010-
           jsr  SetPIAOutputBits    ; call subroutine
           jsr  OCToggleAndResetCopTimer    ; call subroutine
           jsr  CaculateChecksum    ; call subroutine
           bsr  OCToggleAndResetCopTimer    ; call subroutine
           jsr  CountRamValuesFrom05to38    ; call subroutine
           stD *L0003          ; store D to RAM
           ldaa #0x20          ; load a with value -00100000-
   LE684:  ldab SwitchPortAccessReg1    ; load b with memory contents
           bitb #sp1_OC1Toggle          ;  -01000000-
           beq  LE652          ; branch if equal (zero)
           deca                ; decrement a
           bne  LE684          ; branch if not equal (not zero)
           bsr  OCToggleAndResetCopTimer    ; call subroutine
           ldaa #0x10          ; load a with value -00010000-
           tap                 ; transfer a to p
           ldaa #0x70          ; load a with value -01110000-
           ldab #0x02          ; load b with value -00000010-
           jsr  SetPIAOutputBits    ; call subroutine
           ldaa #0xb0          ; load a with value -10110000-
           clrb                ; b = 0
           jsr  SetPIAOutputBits    ; call subroutine
           ldaa #0xf0          ; load a with value -11110000-
           clrb                ; b = 0
           jsr  SetPIAOutputBits    ; call subroutine
           ldd  #0x0006    ; load d (a&b) with value -00000000 00000110-
           staa PIA_Ctrl_1 
           stab PIA3_Buffer_2    ; store b into memory
           staa PIA_Ctrl_5 
           staa SwitchPortAccessReg2
           staa CPU_SerialControlReg2
           ldd  #0xf8f0        ; load d (a&b) with value -11111000 11110000-
           std  CPU_OutputCompare1Mask
           ldaa #0x80          ; load a with value -10000000-
           staa CPU_HardwareTimerForceCompare
           clra                ; a = 0
           staa CPU_OutputCompare1Mask
   LE6C7:  ldab SwitchPortAccessReg1    ; load b with memory contents
           bitb #sp1_OC1Toggle          ;  -01000000-
           beq  LE6DD          ; branch if equal (zero)
           ldd  #0x55aa        ; load d (a&b) with value -01010101 10101010-
           staa CPU_ArmResetCopTimerReg
           stab CPU_ArmResetCopTimerReg    ; store b into memory
           jmp  LE6C7

   LE6DA:  jmp  LE6C7          ; dead code?
   LE6DD:  ldaa #0x40          ; load a with value -01000000-
   LE6DF:  ldab SwitchPortAccessReg1    ; load b with memory contents
           bitb #sp1_OC1Toggle          ;  -01000000-
           bne  LE6C7          ; branch if not equal (not zero)
           deca                ; decrement a
           bne  LE6DF          ; branch if not equal (not zero)
           jmp  Interrupt_SerialCommunications

OCToggleAndResetCopTimer:
           pshx                ; pull index from stack
           ldd  #0x5802        ; load d (a&b) with value -01011000 00000010-
           jsr  SetPIAOutputBits    ; call subroutine
           ldaa #0x10          ; load a with value -00010000-
   LE6F5:  deca                ; decrement a
           bne  LE6F5          ; branch if not equal (not zero)
           ldd  #0x5c02        ; load d (a&b) with value -01011100 00000010-
           jsr  SetPIAOutputBits    ; call subroutine
           pulx                ; pull index from stack
           ldd  #0x55aa        ; load d (a&b) with value -01010101 10101010-
           staa CPU_ArmResetCopTimerReg
           stab CPU_ArmResetCopTimerReg    ; store b into memory
           rts                 ; return from subroutine

SetPIAOutputBits:
; accA contains the port bank to set bits on
; accB contains the bits to set at the specified port
           ldY #0x0004          ; load Y index -00000000 00000100-
           ldx  #CPU_PortD     ; load index with value
           sei                 ; disable interrupts
   LE711:  bclr  0, X, #$%00100000    ; bit clear - 6811 is taking control of the SPI bus
           cmpb CPU_SerialPeripheralStatus    ; this simply clears the status reg?
           staa CPU_SerialPeripheralDataIO
           pshb                ; push b onto stack
           psha                ; push a onto stack
           mul                 ; multiply (d=a*b)
           pula                ; pull a from stack
           pulb                ; pull b from stack
           brset 33, X, #$%10000000, LE72C    ; branch if bit(s) set - 102a - SPI data reg
   LE723:  bset  0, X, #$%00100000    ; bit set - 6811 is not controlling SPI bus
           deY                 ; decrement Y
           bne  LE711          ; branch if not equal (not zero)
           bra  LE746          ; branch

   LE72C:  psha                ; push a onto stack
           lsra            
           lsra            
           eora CPU_SerialPeripheralDataIO
           bita #0x3e          ;  -00111110-
           pula                ; pull a from stack
           bne  LE723          ; branch if not equal (not zero)
           stab CPU_SerialPeripheralDataIO    ; store b into memory
           pshb                ; push b onto stack
           psha                ; push a onto stack
           mul                 ; multiply (d=a*b)
           pula                ; pull a from stack
           pulb                ; pull b from stack
           brclr 33, X, #$%10000000, LE746    ; branch if bit(s) clear
           ldab CPU_SerialPeripheralDataIO    ; load b with memory contents
   LE746:  bset  0, X, #$%00100000    ; bit set - 6811 is not controlling SPI bus
           brset *BitFlags6e, #b6e_PIAKeepIntEnabled, LE74E    ; branch if bit(s) set
           cli                 ; enable interrupts
   LE74E:  tba                 ; a = b
           rts                 ; return from subroutine

EmmissionMaintenanceRemider1_MM:
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_VNT          ;  -00000001-
           bne  LE79C          ; branch if not equal (not zero)
           bset *PIA2_Buffer, #pi2_WGSol    ; set bits
           ldaa CPU_EEPROMControlReg    ; load a with memory contents
           bne  LE765          ; branch if not equal (not zero)
           ldd  LB610          ;  (data is ffff)
           subd #0x5aa5        ;  -01011010 10100101-
   LE765:  brclr *BitFlags6d, #b6d_FuelEngineNotRunning, LE76B    ; branch if bit(s) clear
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
   LE76B:  bne  LE770          ; branch if not equal (not zero)
           bclr *PIA2_Buffer, #pi2_WGSol    ; clear bits
   LE770:  sei                 ; disable interrupts
           brset *BitFlags6a, #b6a_DRBToggle1, LE79B    ; branch if bit(s) set
           brset *b5d_IPL2, #b5d_bit0, LE79D    ; branch if bit(s) set
           brclr *BitFlags6a, #b6a_EMR, LE79B    ; branch if bit(s) clear
           bset *BitFlags6a, #b6a_DRBToggle1    ; set bits
           cli                 ; enable interrupts
           ldaa #0x10          ; load a with value -00010000-
           ldab #0x5a          ; load b with value -01011010-
           brclr *BitFlags6a, #b6a_DRBToggle2, LE794    ; branch if bit(s) clear
           cmpa DRBOffsetStored_HB    ; compare a with memory contents
           bne  LE7F3          ; branch if not equal (not zero)
           inca                ; increment a
           comb            
           bclr *BitFlags6a, #b6a_EMR | b6a_DRBToggle2    ; clear bits
           bra  LE797          ; branch

   LE794:  bset *BitFlags6a, #b6a_DRBToggle2    ; set bits
   LE797:  staa DRBOffsetStored_HB    ; store a into memory
           stab DRBOffsetStored_LB    ; store b into memory
   LE79B:  cli                 ; enable interrupts
   LE79C:  rts                 ; return from subroutine

   LE79D:  bset *BitFlags6a, #b6a_DRBToggle1    ; set bits
           cli                 ; enable interrupts
           brset *BitFlags6a, #b6a_DRBToggle2, LE80B    ; branch if bit(s) set
           ldx  #ErrorBitRegisterStored3    ; load index with value
           ldab #0x30          ; load b with value -00110000-
   LE7AA:  ldaa 0x00, X        ; load a with memory at index + value
           beq  LE7B7          ; branch if equal (zero)
           cba             
           beq  LE7F0          ; branch if equal (zero)
           dex                 ; decrement index (x=x-1)
           cpx  #ErrorBitRegister0    ;  -00000000 00011111-
           bcc  LE7AA          ; branch if greater or equal
   LE7B7:  clra                ; a = 0
           clrb                ; b = 0
           stD *Temp0          ; store D to RAM
           ldx  #LB600         ; load index with value
   LE7BE:  ldd  0x02, X    
           cpx  #0xb60e        ;  -10110110 00001110-
           bne  LE7C8          ; branch if not equal (not zero)
           ldd  LB600          ;  (data is ffff)
   LE7C8:  subd 0x00, X    
           subd #L0001         ;  -00000000 00000001-
           bne  LE7DD          ; branch if not equal (not zero)
           incb            
           addd 0x00, X    
           cmpD Temp0          ; compare D
           bcs  LE7DD          ; branch if lower
           stD *Temp0          ; store D to RAM
           xgDX                ; exchange D and X
           stab DRBOffsetStored_HB    ; store b into memory
           xgDX                ; exchange D and X
   LE7DD:  inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
           cpx  #LB610         ;  -10110110 00010000-
           bne  LE7BE          ; branch if not equal (not zero)
           ldx  Temp0      
           bne  LE7F7          ; branch if not equal (not zero)
           ldd  #0x3003        ; load d (a&b) with value -00110000 00000011-
           ;error above is 62 - EMR Mileage cannot be stored.
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LE7F3          ; branch if greater or equal
   LE7F0:  bclr *b5d_IPL2, #b5d_bit0    ; clear bits
   LE7F3:  bclr *BitFlags6a, #b6a_DRBToggle1    ; clear bits
           rts                 ; return from subroutine

   LE7F7:  ldab DRBOffsetStored_HB    ; load b with memory contents
           addb #0x04          ;  -00000100-
           cmpb #0x10          ;  -00010000-
           blt  LE801          ; branch if less
           subb #0x10          ;  -00010000-
   LE801:  stab DRBOffsetStored_HB    ; store b into memory
           bsr  LE836          ; call subroutine
           staa DRBOffsetStored_LB    ; store a into memory
           bset *BitFlags6a, #b6a_DRBToggle2    ; set bits
           rts                 ; return from subroutine

   LE80B:  ldab DRBOffsetStored_HB    ; load b with memory contents
           cmpb #0x0e          ;  -00001110-
           bhi  LE7F3          ; branch if higher
           cmpb #0x00          ;  -00000000-
           bcs  LE7F3          ; branch if lower
           bsr  LE836          ; call subroutine
           stab DRBOffsetStored_LB    ; store b into memory
           inc  DRBOffsetStored_HB
           bclr *b5d_IPL2, #b5d_bit0    ; clear bits
           bclr *BitFlags6a, #b6a_DRBToggle2    ; clear bits
           xgDX                ; exchange D and X
           cpx  #0x1c9c        ;  -00011100 10011100-
           beq  LE832          ; branch if equal (zero)
           cpx  #0x2757        ;  -00100111 01010111-
           beq  LE832          ; branch if equal (zero)
           cpx  #0x3938        ;  -00111001 00111000-
           bne  LE835          ; branch if not equal (not zero)
   LE832:  bset *BitFlags6a, #b6a_EMR    ; set bits
   LE835:  rts                 ; return from subroutine

   LE836:  ldx  #LB600         ; load index with value
           subb #0x02          ;  -00000010-
           cmpb #0x00          ;  -00000000-
           bge  LE841          ; branch if greater or equal
           ldab #0x0e          ; load b with value -00001110-
   LE841:  abx                 ; add b to index
           ldx  0x00, X
           inx                 ; increment index (x=x+1)
           bne  LE848          ; branch if not equal (not zero)
           dex                 ; decrement index (x=x-1)
   LE848:  xgDX                ; exchange D and X
           rts                 ; return from subroutine

EmmissionMaintenanceRemider2_MM:
           brset *Counter_MainLoop, #$%00000001, LE8BB    ; branch if bit(s) set
           brclr *BitFlags6a, #b6a_DRBToggle1, LE8B7    ; branch if bit(s) clear
           ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           beq  LE85D          ; branch if equal (zero)
           ldab #0x03          ; load b with value -00000011-
           cba             
           bcc  LE85D          ; branch if greater or equal
           stab CountdownTimerFromKeyOn    ; store b into memory
   LE85D:  ldaa CPU_EEPROMControlReg    ; load a with memory contents
           clrb                ; b = 0
           stab CPU_EEPROMControlReg    ; store b into memory
           ldx  #LB600         ; load index with value
           ldab DRBOffsetStored_HB    ; load b with memory contents
           abx                 ; add b to index
           tab                 ; b = a
           ldaa 0x00, X        ; load a with memory at index + value
           cmpa DRBOffsetStored_LB    ; compare a with memory contents
           beq  LE8A7          ; branch if equal (zero)
           cmpb #0x03          ;  -00000011-
           beq  LE87C          ; branch if equal (zero)
           bcs  LE88D          ; branch if lower
           ldab DRBOffsetStored_LB    ; load b with memory contents
           inca                ; increment a
           beq  LE89D          ; branch if equal (zero)
   LE87C:  brset *b5d_IPL2, #b5d_EMRLight, LE8A7    ; branch if bit(s) set
           ldd  #0x318a        ; load d (a&b) with value -00110001 10001010-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LE88D          ; branch if greater or equal
           bset *b5d_IPL2, #b5d_EMRLight    ; set bits
           bra  LE8A7          ; branch

   LE88D:  ldx  #LB600         ; load index with value
           ldab DRBOffsetStored_HB    ; load b with memory contents
           abx                 ; add b to index
           ldab DRBOffsetStored_LB    ; load b with memory contents
           tba                 ; a = b
           anda 0x00, X    
           sba                 ; subtract (a=a-b)
           beq  LE89D          ; branch if equal (zero)
           ldaa #0x16          ; load a with value -00010110-
   LE89D:  oraa #0x02          ;  -00000010-
           staa CPU_EEPROMControlReg
           stab 0x00, X
           inca                ; increment a
           bra  LE8B8          ; branch

   LE8A7:  bclr *BitFlags6a, #b6a_DRBToggle1    ; clear bits
           brset *BitFlags6a, #b6a_DRBToggle2, LE8B7    ; branch if bit(s) set
           ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           suba #0x03          ;  -00000011-
           bne  LE8B7          ; branch if not equal (not zero)
           inca                ; increment a
           staa CountdownTimerFromKeyOn    ; store a into memory
   LE8B7:  clra                ; a = 0
   LE8B8:  staa CPU_EEPROMControlReg
   LE8BB:  rts                 ; return from subroutine

ExhGasRecirc_MM:
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_EGR          ;  -01000000-
           bne  LE8C6          ; branch if not equal (not zero)
           jmp  LEA0A      

   LE8C6:  brclr *BitFlags6d, #b6d_FuelEngineNotRunning, LE8D9    ; branch if bit(s) clear
           ldaa CoolantTemp    ; load a with memory contents
           cmpa EGR27_ExhGasRecircConstFromCoolantTemp    ; compare a with memory contents (data is ff)
           bcc  LE8D6          ; branch if greater or equal
           bclr *EGRVar2, #$%00100000    ; clear bits
           bra  LE8D9          ; branch

   LE8D6:  bset *EGRVar2, #$%00100000    ; set bits
   LE8D9:  ldab BitFlags66     ; load b with memory contents
           bitb #b66_PTEisMaxed | b66_FullThrottle          ;  -00000011-
           bne  LE920          ; branch if not equal (not zero)
           ldab BaroPressure    ; load b with memory contents
           brset *PIA2_Buffer, #pi2_EGRSol, LE8E8    ; branch if bit(s) set
           subb EGR26_ExhGasRecircConstFromBaro2    ; subtract memory contents from b (data is 00)
   LE8E8:  subb EGR25_ExhGasRecircConstFromBaro1    ; subtract memory contents from b (data is 00)
           cmpb MapValue   
           bcs  LE920          ; branch if lower
           brset *EGRVar2, #$%00100000, LE8FC    ; branch if bit(s) set
           brset *BitFlags67, #b67_OpenLoop, LE920    ; branch if bit(s) set
           bset *EGRVar2, #$%00100000    ; set bits
           bra  LE904          ; branch

   LE8FC:  brset *BitFlags66, #b66_O2Valid, LE904    ; branch if bit(s) set
           ldab Timer_CLTIME_ClosedLoopTimer    ; load b with memory contents
           bne  LE920          ; branch if not equal (not zero)
   LE904:  brclr *BitFlags66, #b66_OffIdle, LE920    ; branch if bit(s) clear
           ldaa EGR21_ExhGasRecircConstFromRPM1    ; load a with memory contents (data is fa)
           ldab EGR23_ExhGasRecircConstFromMAP1    ; load b with memory contents (data is fa)
           brset *PIA2_Buffer, #pi2_EGRSol, LE918    ; branch if bit(s) set
           adda EGR22_ExhGasRecircConstFromRPM2    ;  (data is 01)
           addb EGR24_ExhGasRecircConstFromMAP2    ;  (data is 03)
   LE918:  cmpa EngineRpm_HB    ; compare a with memory contents
           bls  LE926          ; branch if lower or same
           cmpb MapValue   
           bcs  LE926          ; branch if lower
   LE920:  bset *EGRVar2, #$%00010000    ; set bits
           jmp  EGR_SetEGRtoOff

   LE926:  ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa EGR9_ExhGasRecircConstFromTimeEngRunning9    ; compare a with memory contents (data is 6b)
           bcs  LE93D          ; branch if lower
           brset *EGRVar2, #$%01000000, LE93D    ; branch if bit(s) set
           brset *EGRVar2, #$%00010000, LE93D    ; branch if bit(s) set
           brclr *BitFlags66, #b66_O2Valid, LE93D    ; branch if bit(s) clear
           brclr *BitFlags67, #b67_StayOpenLoop, LE940    ; branch if bit(s) clear
   LE93D:  jmp  EGR_ResetEGRVars

   LE940:  ldd  IPLMSK_PowerLossLightMask    ;  (data is fff8)
           bita b5c_IPL1   
           bne  EGR_ResetEGRVars    ; branch if not equal (not zero)
           bitb b5d_IPL2   
           bne  EGR_ResetEGRVars    ; branch if not equal (not zero)
           brclr *PIA1_Buffer, #pi1_PurgeSol, EGR_ResetEGRVars    ; branch if bit(s) clear
           ldaa BaroPressure    ; load a with memory contents
           suba MapValue   
           bcs  EGR_ResetEGRVars    ; branch if lower
           cmpa EGR2_ExhGasRecircConstFromMAPBelowBaro    ; compare a with memory contents (data is 16)
           bcs  EGR_ResetEGRVars    ; branch if lower
           ldx  ErrorCodeBufferHB
           brset *EGRVar2, #$%10000000, LE9D3    ; branch if bit(s) set
           cpx  EGR1_ExhGasRecircConst    ;  (data is 01c6)
           bhi  LE9C5          ; branch if higher
           ldaa MapValue       ; load a with memory contents
           ldx  #EGR18_ExhGasRecircConstLoLimit    ; load index with value
           bsr  EGR_CheckHiLoLimits    ; call subroutine
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bls  EGR_ResetEGRVars    ; branch if lower or same
           ldx  #EGR14_ExhGasRecircConstFromTPSVoltsLoLimit14    ; load index with value
           bsr  EGR_CheckHiLoLimits    ; call subroutine
           ldaa EngineRpm_HB    ; load a with memory contents
           ldx  #EGR15_ExhGasRecircConstFromRPMLoLimit15    ; load index with value
           bsr  EGR_CheckHiLoLimits    ; call subroutine
           ldaa Counter_O2SensorFeedbackCount_Signed    ; load a with memory contents
           cmpa EGR3_ExhGasRecircConst3    ; compare a with memory contents (data is 28)
           bge  EGR_ResetEGRVars    ; branch if greater or equal
           ldx  ErrorCodeBufferHB
           inx                 ; increment index (x=x+1)
           stx  ErrorCodeBufferHB
           ldab EGR8_ExhGasRecircConst8    ; load b with memory contents (data is 0d)
           suba EGR_Temp_1 
           bvc  LE9A4          ; branch if overflow
           bmi  LE9A6          ; branch if minus(hi bit 1)
   LE997:  nega                ; negate a (set high bit)
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           nega                ; negate a (set high bit)
   LE99C:  adda EGR_Temp_1 
           staa EGR_Temp_1 
           bra  LE9C2          ; branch

   LE9A4:  bmi  LE997          ; branch if minus(hi bit 1)
   LE9A6:  mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           bra  LE99C          ; branch

EGR_CheckHiLoLimits:
           cmpa 0x00, X        ; compare a with memory at index + value
           bcs  LE9B4          ; branch if lower
           cmpa 0x01, X        ; compare a with memory at index + value
           bhi  LE9B4          ; branch if higher
           rts                 ; return from subroutine

   LE9B4:  pulx                ; pull index from stack
EGR_ResetEGRVars:
           clra                ; a = 0
           clrb                ; b = 0
           std  ErrorCodeBufferHB
           bclr *EGRVar2, #$%10010000    ; clear bits
           ldaa Counter_O2SensorFeedbackCount_Signed    ; load a with memory contents
           staa EGR_Temp_1 
   LE9C2:  jmp  EGR_SetEGRtoOn

   LE9C5:  ldx  #L0000         ; load index with value
           bset *EGRVar2, #$%10000000    ; set bits
           ldaa EGR_Temp_1     ; load a with memory contents
           staa EGR_Temp_2 
           bra  LE9D8          ; branch

   LE9D3:  cpx  EGR6_ExhGasRecircConst6    ;  (data is 016c)
           bcc  LEA18          ; branch if greater or equal
   LE9D8:  inx                 ; increment index (x=x+1)
           stx  ErrorCodeBufferHB
           ldaa MapValue       ; load a with memory contents
           ldx  #EGR16_ExhGasRecircConstLoLimit16    ; load index with value
           bsr  EGR_CheckHiLoLimits    ; call subroutine
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bls  EGR_ResetEGRVars    ; branch if lower or same
           ldx  #EGR19_ExhGasRecircConstLoLimit19    ; load index with value
           bsr  EGR_CheckHiLoLimits    ; call subroutine
           ldaa EngineRpm_HB    ; load a with memory contents
           ldx  #EGR17a_ExhGasRecircConstHiLimit17a    ; load index with value
           bsr  EGR_CheckHiLoLimits    ; call subroutine
           ldaa Counter_O2SensorFeedbackCount_Signed    ; load a with memory contents
           cmpa EGR_Temp_2     ; compare a with memory contents
           ble  LEA46          ; branch if less or equal
           staa EGR_Temp_2 
           suba EGR_Temp_1 
           staa EGR_Temp_3 
           cmpa EGR7_ExhGasRecircConst7    ; compare a with memory contents (data is 14)
           bcs  LEA46          ; branch if lower
   LEA0A:  clr  ErrorCodeCounter    ; zero byte at memory location
           bset *EGRVar2, #$%01000000    ; set bits
           bclr *EGRVar2, #$%10000000    ; clear bits
           bclr *b5d_IPL2, #b5d_EGRSolFault    ; clear bits
           bra  EGR_SetEGRtoOn    ; branch

   LEA18:  clra                ; a = 0
           clrb                ; b = 0
           std  ErrorCodeBufferHB
           ldaa ErrorCodeCounter    ; load a with memory contents
           inca                ; increment a
           staa ErrorCodeCounter
           cmpa EGR4_ExhGasRecircConst4    ; compare a with memory contents (data is ff)
           bcs  LEA32          ; branch if lower
           ldd  #0x2e01        ; load d (a&b) with value -00101110 00000001-
           jsr  ThrowNonCriticalError    ; call subroutine
           bset *b5d_IPL2, #b5d_EGRSolFault    ; set bits
   LEA32:  ldab EGRVar2        ; load b with memory contents
           andb #0x7f          ;  -01111111-
           tba                 ; a = b
           inca                ; increment a
           anda #0x0f          ; AND a with value -00001111-
           beq  LEA42          ; branch if equal (zero)
           incb            
           cmpa EGR5_ExhGasRecircConst5    ; compare a with memory contents (data is 00)
           bcs  LEA44          ; branch if lower
   LEA42:  orab #0x40          ;  -01000000-
   LEA44:  stab EGRVar2        ; store b into memory
   LEA46:  brclr *EGRVar2, #$%10000000, EGR_SetEGRtoOn    ; branch if bit(s) clear
EGR_SetEGRtoOff:
           bclr *PIA2_Buffer, #pi2_EGRSol    ; clear bits
           rts                 ; return from subroutine

EGR_SetEGRtoOn:
           bset *PIA2_Buffer, #pi2_EGRSol    ; set bits
           rts                 ; return from subroutine



BYTE_MODE_SERIAL_CODE_DOWNLOAD_ROUTINE:
;            brclr *DRBSerialMode, #$%01000000, LEA6C    ; branch if bit(s) clear
;            ldab CPU_SerialData    ; load b with memory contents
;            ldaa CPU_SerialStatus    ; load a with memory contents
;            bita #0x20          ;  -00100000-
;            bne  LEA6D          ; branch if not equal (not zero)
;            ldaa FDRVar0        ; load a with memory contents
;            cmpa #0xfc          ; compare a with value -11111100-
;            bne  LEA6C          ; branch if not equal (not zero)
;    LEA66:  bclr *DRBSerialMode, #$%01000000    ; clear bits
;            clr  FDRVar0        ; zero byte at memory location
;    LEA6C:  rts                 ; return from subroutine
; 
;    LEA6D:  ldaa FDRVar0        ; load a with memory contents
;            bita #0x03          ;  -00000011-
;            bne  LEAC4          ; branch if not equal (not zero)
;            cmpb #0xf8          ;  -11111000-
;            bcs  LEA66          ; branch if lower
;            ldaa FDRVar0        ; load a with memory contents
;            bne  LEA83          ; branch if not equal (not zero)
;            cmpb #0xf8          ;  -11111000-
;            bne  LEA66          ; branch if not equal (not zero)
;            ldaa #0x80          ; load a with value -10000000-
;            bra  LEA99          ; branch
; 
;    LEA83:  cmpa #0x80          ; compare a with value -10000000-
;            bne  LEA8F          ; branch if not equal (not zero)
;            cmpb #0xf9          ;  -11111001-
;            bne  LEA66          ; branch if not equal (not zero)
;            ldaa #0xc0          ; load a with value -11000000-
;            bra  LEA99          ; branch
; 
;    LEA8F:  cmpa #0xc0          ; compare a with value -11000000-
;            bne  LEAA0          ; branch if not equal (not zero)
;            cmpb #0xfb          ;  -11111011-
;            bne  LEA66          ; branch if not equal (not zero)
;            ldaa #0xe0          ; load a with value -11100000-
;    LEA99:  staa FDRVar0        ; store a into memory
;    LEA9B:  jsr  LEB99          ; call subroutine
;    LEA9E:  pulx                ; pull index from stack
;            rts                 ; return from subroutine
; 
;    LEAA0:  cmpa #0xe0          ; compare a with value -11100000-
;            bne  LEA66          ; branch if not equal (not zero)
;            ldaa #0x02          ; load a with value -00000010-
;            cmpb #0xf8          ;  -11111000-
;            beq  LEA99          ; branch if equal (zero)
;            ldaa #0x01          ; load a with value -00000001-
;            cmpb #0xf9          ;  -11111001-
;            beq  LEA99          ; branch if equal (zero)
;            cmpb #0xfb          ;  -11111011-
;            bne  LEA66          ; branch if not equal (not zero)
;            ldaa #0x05          ; load a with value -00000101-
;            pshb                ; push b onto stack
;            ldab EngineRpm_HB    ; load b with memory contents
;            pulb                ; pull b from stack
;            beq  LEA99          ; branch if equal (zero)
;    LEABC:  ldab #0x17          ; load b with value -00010111-
;            jsr  LEB99          ; call subroutine
;    LEAC1:  pulx                ; pull index from stack
;            bra  LEA66          ; branch
; 
;    LEAC4:  bita #0x01          ;  -00000001-
;            beq  LEB29          ; branch if equal (zero)
;            lsla                ; logical shift left a
;            bcs  LEB15          ; branch if lower
;            lsla                ; logical shift left a
;            bcs  LEAEA          ; branch if lower
;            lsla                ; logical shift left a
;            bcs  LEAE2          ; branch if lower
;            bmi  LEADC          ; branch if minus(hi bit 1)
;            stab FDRVar4        ; store b into memory
;            jsr  LEB89          ; call subroutine
;            ldaa #0x10          ; load a with value -00010000-
;            bra  LEB10          ; branch
; 
;    LEADC:  stab FDRVar3        ; store b into memory
;            ldaa #0x20          ; load a with value -00100000-
;            bra  LEB10          ; branch
; 
;    LEAE2:  ldx  FDRVar3    
;            ldab 0x00, X        ; load b with memory at index + value
;            ldaa #0x40          ; load a with value -01000000-
;            bra  LEB10          ; branch
; 
;    LEAEA:  cmpb #0xfe          ;  -11111110-
;            beq  LEAFA          ; branch if equal (zero)
;    LEAEE:  clr  FDRVar0        ; zero byte at memory location
;            cmpb #0x1b          ;  -00011011-
;            bne  LEA9E          ; branch if not equal (not zero)
;            bset *DRBSerialMode, #$%01000000    ; set bits
;            bra  LEA9B          ; branch
; 
;    LEAFA:  ldx  FDRVar3    
;            cpx  #0x800c        ;  -10000000 00001100-
;            beq  LEABC          ; branch if equal (zero)
;            ldaa EngineRpm_HB    ; load a with memory contents
;            cmpa #0x5e          ; compare a with value -01011110-
;            bcc  LEABC          ; branch if greater or equal
;            brclr *FDRVar0, #$%00000100, LEB0E    ; branch if bit(s) clear
;            tsta                ; test a
;            bne  LEABC          ; branch if not equal (not zero)
;    LEB0E:  ldaa #0x80          ; load a with value -10000000-
;    LEB10:  oraa FDRVar0        ; OR a with memory contents
;            jmp  LEA99      
; 
;    LEB15:  ldaa EngineRpm_HB    ; load a with memory contents
;            beq  LEB20          ; branch if equal (zero)
;            stab FDRVar2        ; store b into memory
;            bset *FDRVar0, #$%00001000    ; set bits
;            pulx                ; pull index from stack
;            rts                 ; return from subroutine
; 
;    LEB20:  sei                 ; disable interrupts
;            ldx  FDRVar3    
;            jsr  FDRSerialIORoutine    ; call subroutine
;            cli                 ; enable interrupts
;            bra  LEAC1          ; branch
; 
;    LEB29:  ldab CPU_SerialData    ; load b with memory contents
;            ldaa CPU_SerialStatus    ; load a with memory contents
;            ldaa FDRVar0        ; load a with memory contents
;            lsla                ; logical shift left a
;            bcs  LEB66          ; branch if lower
;            lsla                ; logical shift left a
;            bcs  LEB5B          ; branch if lower
;            lsla                ; logical shift left a
;            bcs  LEB55          ; branch if lower
;            lsla                ; logical shift left a
;            bcs  LEB4C          ; branch if lower
;            lsla                ; logical shift left a
;            bcs  LEB46          ; branch if lower
;            stab FDRVar2        ; store b into memory
;            ldaa #0x08          ; load a with value -00001000-
;            bra  LEB10          ; branch
; 
;    LEB46:  stab FDRVar1        ; store b into memory
;            ldaa #0x10          ; load a with value -00010000-
;            bra  LEB10          ; branch
; 
;    LEB4C:  stab FDRVar4        ; store b into memory
;            jsr  LEB89          ; call subroutine
;            ldaa #0x20          ; load a with value -00100000-
;            bra  LEB10          ; branch
; 
;    LEB55:  stab FDRVar3        ; store b into memory
;            ldaa #0xc0          ; load a with value -11000000-
;            bra  LEB10          ; branch
; 
;    LEB5B:  cmpb #0xfd          ;  -11111101-
;            beq  LEB62          ; branch if equal (zero)
;            jmp  LEAEE      
; 
;    LEB62:  ldaa #0x80          ; load a with value -10000000-
;            bra  LEB10          ; branch
; 
;    LEB66:  ldx  FDRVar3    
;            ldY FDRVar1         ; load Y index
;            ldaa 0x00, X        ; load a with memory at index + value
;            staa CPU_SerialData
;            inx                 ; increment index (x=x+1)
;            deY                 ; decrement Y
;            bne  LEB7A          ; branch if not equal (not zero)
;            ldaa #0xfc          ; load a with value -11111100-
;            staa FDRVar0        ; store a into memory
;    LEB79:  rts                 ; return from subroutine
; 
;    LEB7A:  stx  FDRVar3        ; store index into memory
;            stY FDRVar1         ; store Y index
;            cba             
;            bne  LEB84          ; branch if not equal (not zero)
;            pulx                ; pull index from stack
;            rts                 ; return from subroutine
; 
;    LEB84:  bclr *FDRVar0, #$%10000000    ; clear bits
;            pulx                ; pull index from stack
;            rts                 ; return from subroutine
; 
;    LEB89:  ldx  FDRVar3    
;            cpx  #0xb400        ;  -10110100 00000000-
;            bcs  LEB79          ; branch if lower
;            cpx  #0xb7ff        ;  -10110111 11111111-
;            bhi  LEB79          ; branch if higher
;            pulx                ; pull index from stack
;            jmp  LEAC1      
; 
;    LEB99:  ldaa CPU_SerialStatus    ; load a with memory contents
;            ldaa CPU_SerialData    ; load a with memory contents
;            stab CPU_SerialData    ; store b into memory
           rts                 ; return from subroutine

ControlPTU_MM:
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 9f)
           bita #cfg_ATX          ;  -00100000-
           beq  LEC1F          ; branch if equal (zero)
           bita #cfg_VNT          ;  -00000001-
           bne  LEC1F          ; branch if not equal (not zero)
           
PTU_Main:
           ldaa PTU_MapTemp    ; load a with memory contents
           staa Temp0          ; store a into memory
           ldaa Counter_MainLoop    ; load a with memory contents
           bita PTUCNI_PTUCounterTimerIntervalForLoop    ;  (data is 07)
           bne  PTU_CheckThrottleForLock    ; branch if not equal (not zero)
           ldaa MapValue       ; load a with memory contents
           staa PTU_MapTemp    ; store a into memory

PTU_CheckThrottleForLock:
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bls  PTU_SetPTUBits    ; branch if lower or same
           staa Temp4          ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           cmpa PTUMTP_PTUMinLockTemperature    ; compare a with memory contents (data is ff)
           bcs  PTU_SetPTUBits    ; branch if lower
           brclr *BitFlags_AIS, #b10_ATXInGear, PTU_SetPTUBits    ; branch if bit(s) clear
           brset *StartupSwitchMirror1, #sw1_Brake, PTU_SetPTUBits    ; branch if bit(s) set
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           bcs  PTU_CheckMAPThresholdsForLock          ; branch if lower
           cmpa PTUMSP_PTUMinLockSpeed    ; compare a with memory contents (data is 5b)
           bcc  PTU_CheckMAPThresholdsForLock          ; branch if greater or equal
           ldaa MapValue       ; load a with memory contents
           suba Temp0      
           bcs  PTU_CheckMAPThresholdsForLock          ; branch if lower
           cmpa PTUMP3_PTUMAPThresholdForLock3    ; compare a with memory contents (data is 78)
           bcc  PTU_SetPTUBits    ; branch if greater or equal
           bra  LEC20          ; branch

PTU_CheckMAPThresholdsForLock:
           ldaa Temp0          ; load a with memory contents
           suba MapValue   
           bcs  LEC20          ; branch if lower
           staa Temp0          ; store a into memory
           ldx  #PTUMP1_PTUMAPThresholdForLock1    ; load index with value
           brset *BitFlags6a, #b6a_PTU_A, LEC10    ; branch if bit(s) set
           brset *BitFlags6a, #b6a_PTU_B, LEC0F    ; branch if bit(s) set
           ldaa Temp4          ; load a with memory contents
           cmpa PTUDTP_PTUDeltaTPSForUnlock    ; compare a with memory contents (data is 34)
           bcs  LEC0C          ; branch if lower
           bset *BitFlags6a, #b6a_PTU_A    ; set bits
           bra  LEC10          ; branch

   LEC0C:  bset *BitFlags6a, #b6a_PTU_B    ; set bits
   LEC0F:  inx                 ; increment index (x=x+1)
   LEC10:  ldab Temp0          ; load b with memory contents
           cmpb 0x00, X    
           bcs  PTU_CheckCounter    ; branch if lower
PTU_SetPTUBits:
           bset *PIA2_Buffer, #pi2_PTU    ; set bits
           bclr *BitFlags6a, #b6a_PTU_B | b6a_PTU_A    ; clear bits
           clrb                ; b = 0
PTU_SaveCounterValue:
           stab Counter_PartThrottleUnlock    ; store b into memory
   LEC1F:  rts                 ; return from subroutine

   LEC20:  bclr *BitFlags6a, #b6a_PTU_B | b6a_PTU_A    ; clear bits
PTU_CheckCounter:
           ldab Counter_PartThrottleUnlock    ; load b with memory contents
           cmpb #0x01          ;  -00000001-
           bls  PTU_CheckThresholdsForUnlock          ; branch if lower or same
           decb            
           bra  PTU_SaveCounterValue          ; branch

PTU_CheckThresholdsForUnlock:
           ldx  #PTUUUL_UpperLimitForPTUUnlock    ; load index with value
           brclr *PIA2_Buffer, #pi2_PTU, LEC36    ; branch if bit(s) clear
           ldx  #PTULUL_UpperLimitForPTULock    ; load index with value
   LEC36:  bsr  PTU_LookupPTUParam          ; call subroutine
           bls  PTU_SetPTUBits    ; branch if lower or same
           ldx  #PTUULL_LowerLimitForPTUUnlock    ; load index with value
           brclr *PIA2_Buffer, #pi2_PTU, LEC44    ; branch if bit(s) clear
           ldx  #PTULLL_LowerLimitForPTULock    ; load index with value
   LEC44:  bsr  PTU_LookupPTUParam          ; call subroutine
           bhi  PTU_SetPTUBits    ; branch if higher
           ldaa BoostDelta_Signed    ; load a with memory contents
           beq  PTU_CheckVehicleSpeed    ; branch if equal (zero)
           bclr *PIA2_Buffer, #pi2_PTU    ; clear bits
           rts                 ; return from subroutine

PTU_CheckVehicleSpeed:
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           ldab PTUCNH_PTUCounterHiSpeed    ; load b with memory contents (data is 5b)
           bcs  PTU_SaveCounterValue          ; branch if lower
           cmpa PTUMSP_PTUMinLockSpeed    ; compare a with memory contents (data is 5b)
           bcc  PTU_SaveCounterValue          ; branch if greater or equal
           ldab PTUCNL_PTUCounterLoSpeed    ; load b with memory contents (data is 5b)
           bra  PTU_SaveCounterValue          ; branch

PTU_LookupPTUParam:
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           bcc  LEC6D          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LEC6D:  jsr  Lookup4ByteTable    ; call subroutine
           cmpa Temp4          ; compare a with memory contents
           rts                 ; return from subroutine
           
; ***********************************************************************
;   ----------------------------------------------------
;	Additional code modules
;   ----------------------------------------------------
;   ----------------------------------------------------
;	Flash Check Engine Light on Knock Routine
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
           bset	*PIA1_Buffer, #pi1_CEL
	   bra	FlashCEL_OnKnock_return
KnockDetect_LightCEL:
	   bclr	*PIA1_Buffer, #pi1_CEL
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
           bset  0, y, #bit_all ; set all bits to ensure cylidner firing
           bclr  0, x, #Turbonator_Staging         ; clear the flag indicating the staging limiter conditions are NOT met
           bra   LaunchControl_AllowFuelSpark

LaunchControl_DecideEngineOnOff:
	   brclr 0, x, #Turbonator_FuelOff | Turbonator_SparkCut, LaunchControl_CheckUpperRPM    ; branch if bit(s) clear
           jmp   LaunchControl_CheckLowerRPM

LaunchControl_CheckUpperRPM:
	   ldaa  EngineRpm_HB                      ; load a with memory contents
	   cmpa  STGROF_StageLimiterRPMOffSetpoint ; compare a with memory at index + value
	   bcs   LaunchControl_AllowFuelSpark; branch if launch control RPM is greater than current RPM

LaunchControl_ShutOffEngineForThisRotation:
           ldaa  OPTN2_CalCustomOptionConfigFlags2
           bita  #opt_FuelRevLim
           beq   LaunchControl_CheckSparkCut       ; don't turn off the fuel...
           bset  0, x, #Turbonator_FuelOff         ; set bits

LaunchControl_CheckSparkCut:
           bita  #opt_SprkRevLim
           beq   LaunchControl_Return              ; don't turn off the spark...
           bset  0, x, #Turbonator_SparkCut        ; new T-SMEC Spark rev limiter
           bra   LaunchControl_Return

; LaunchControl_UseHysteresisToDetermineWhenToTurnFuelBackOn:
;            brclr *Turbonator_Flags, #Turbonator_OverRev, LaunchControl_CheckLowerRPM    ; branch if bit(s) clear
; 	   brclr *BitFlags_50, #b50_FallToIdle, LaunchControl_AllowFuelSpark    ; branch if bit(s) clear

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
           ldab 0x00, Y ; b now contains the base value

           ;if the option for bang-bang is enabled, subtract 1 from B
           ldx  #OPTN2_CalCustomOptionConfigFlags2
           brclr 0x00, X, #opt_BangBang, StoreSparkCutCounter
           decb
        
StoreSparkCutCounter:
           stab Counter_SparkCut
           ldab SPKFRC_SparkCutFraction ; this is now an offset value -- oops, this was left off, made the pattern wrong
           ldy  #LNCPDT_PatternDataTable
           aby
           ldab 0x00, Y ; b now contains the pattern
           stab Pattern_SparkCut
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

;   -------------------------------------------------------
;	Nitrous Retard Routine
;   -------------------------------------------------------
;
; This routine will retard timing a set amount based on a switch input. 
;
; 
; CalculateNO2Retard_Routine_MM:
; 
;        clra  ; so that we can clear the NO2Retard if not used
; 
; NO2_CheckOptions:
;        ldx  #OPTN1_CalCustomOptionConfigFlags1
;        brclr 0, X, #opt_NO2Retard, NO2_SaveRetardValue
; 
; NO2_CheckSwitch:
;        ldab SwitchPortAccessReg    ; load b with memory contents
;        brclr 0, X, #opt_NO2Pol, NO2_Polarity_Lo ; check the switch polarity
; 
; NO2_Polarity_Hi:
;        bitb NO2SWS_NO2SwitchSelect
;        beq  LoadNO2Retard	    ; branch if equal (zero)
;        bra  NO2_SaveRetardValue
; 
; NO2_Polarity_Lo:
;        bitb NO2SWS_NO2SwitchSelect
;        bne  LoadNO2Retard	    ; branch if not equal (not zero)
;        bra  NO2_SaveRetardValue
; 
; LoadNO2Retard:
;        ldaa NO2RET_NO2RetardConstant
;        asra
;        asra
;        asra                         ; divide constant by 8 --> constant range is 0 to 15 deg...
; 
; NO2_SaveRetardValue:
;        staa NO2Retard               ; store the antilag retard
;        rts
; 
;   -------------------------------------------------------

    .org    0xFEA0
BoostButtonCopyrightNotice:
    .str	"Turbonator mods and brand Copr. 2013 Rob Lloyd "
    .str        "Turbonator SBEC v4.0"
    .byte 0x00, 0x00

    .org    0xFF00
ChryslerCopyrightNotice:
    .str	"COPR. 1988 CHRYSLER CORP."
    .byte 0x00, 0x00

    .org    0xffd6
vectors:
;SCI_Interrupt_vector:
    .word   Interrupt_SerialCommunications
;SPIE_Flag_Interrupt_vector:
    .word   InterruptPointer_SerialPeripheralInterface
;PAII_Flag_Interrupt_vector:
    .word   InterruptPointer_PulseAccumulatorInputEdge
;PAOVI_Flag_Interrupt_vector:
    .word   InterruptPointer_PulseAccumulatorOverflow
;TOI_Flag_Interrupt_vector:
    .word   InterruptPointer_TimerOverflow
;OC5_Flag_Interrupt_vector:
    .word   InterruptPointer_DwellTimer
;OC4_Flag_Interrupt_vector:
    .word   InterruptPointer_TimerOutputCapture4
;OC3_Flag_Interrupt_vector:
    .word   InterruptPointer_TimerOutputCapture3
;OC2_Flag_Interrupt_vector:
    .word   InterruptPointer_TimerOC2_Wastegate
;OC1_Timer_Interrupt_vector:
    .word   InterruptPointer_TimerOutputCapture1
;IC3_Timer_Interrupt_vector:
    .word   InterruptPointer_TimerInputCapture3
;IC2_Timer_Interrupt_vector:
    .word   InterruptPointer_SpeedoSignal
;IC1_Timer_Interrupt_vector:
    .word   InterruptPointer_DistributorSignal
;Realtime_Interrupt_vector:
    .word   InterruptPointer_RealTime
;IRQ_hardware_Interrupt_vector:
    .word   InterruptPointer_PIA_Signal
;XIRQ_hardware_Interrupt_vector:
    .word   InterruptPointer_XIRQ
;SWI_Software_Interrupt_vector:
    .word   InterruptPointer_Software
;Illegal_Opcode_vector:
    .word   InterruptPointer_BadOp
;COP_Watchdog_Timeout_vector:
    .word   InterruptPointer_COPFail
;Clock_Monitor_Fail_vector:
    .word   InterruptPointer_ClockMonFail
;ResetVector:
    .word   Interrupt_SerialCommunications

        .msg "Complete."


; Quick 68HC11 reference:
;   a   Accumulator A (8-bit)
;   b   Accumulator B (8-bit)
;   d   A and B combined (16-bit, A hi, B lo)
;   ccr Condition Code Register (8-bit, CCR)
;   pc  Program Counter (16-bit)
;   sp  Stack Pointer (16-bit)
;   ix  Index Register X (16-bit)
;   iy  Index Register Y (16-bit)
; 
; some RAM bytes from 0000 are kept alive by standby battery power.
; 
;   0000 to 00ff - 256 bytes of internal RAM
;   ffd6 to ffff - Interrupt vectors (TechRef Chapter 5)
;   ------------
;   ffd6 to ffd7 - SCI Interrupt vector: e000
;   ffd8 to ffd9 - SPIE Flag Interrupt vector: 9003
;   ffda to ffdb - PAII Flag Interrupt vector: 9006
;   ffdc to ffdd - PAOVI Flag Interrupt vector: 9009
;   ffde to ffdf - TOI Flag Interrupt vector: 900c
;   ffe0 to ffe1 - OC5 Flag Interrupt vector: 900f
;   ffe2 to ffe3 - OC4 Flag Interrupt vector: 9012
;   ffe4 to ffe5 - OC3 Flag Interrupt vector: 9015
;   ffe6 to ffe7 - OC2 Flag Interrupt vector: 9018
;   ffe8 to ffe9 - OC1 Timer Interrupt vector: 901b
;   ffea to ffeb - IC3 Timer Interrupt vector: 901e
;   ffec to ffed - IC2 Timer Interrupt vector: 9021
;   ffee to ffef - IC1 Timer Interrupt vector: 9024
;   fff0 to fff1 - Realtime Interrupt vector: 9027
;   fff2 to fff3 - IRQ hardware Interrupt vector: 902a
;   fff4 to fff5 - XIRQ hardware Interrupt vector: 902d
;   fff6 to fff7 - SWI Software Interrupt vector: 9030
;   fff8 to fff9 - Illegal Opcode vector: 9033
;   fffa to fffb - COP Watchdog Timeout vector: 9036
;   fffc to fffd - Clock Monitor Fail vector: 9039
;   fffe to ffff - Power on or external Reset vector: e000
;   ------------









