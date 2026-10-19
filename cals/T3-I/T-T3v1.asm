	.title TurbonatorT3v1
	.area ROM (ABS)
; SET TABS to 4 if text appears jumbled
;  ____________________________________________________________________________
; |									       \
; |									       |
; |   Mopar ECM T3 SBEC							       |
; |   Based on 1991 Turbo III Codebase				               |
; |									       |
; | Code and original design and data Copyright 1990 by Chrysler Corporation   |
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
;          - Fixed the definitions of 'AVMMAP_MinimumMAPToResetAverageMAP' and
;            'AVMRPM_MinimumRPMToResetAverageMAP'. They were swapped and 
;            'AVMMAP' was not being scaled correctly for MAP.
;          - Added 'OFSMID_OffsetForMAPOverIdle' to MAP scaling list.
;
; Version 1.2
; 08/09/11 - Updated the Density Factors and MAP-dependant transient fuel
;            tables to scale inversely with MAP.
;          - Updated the naming of the Decel Fuel Shutoff valules and added to
;            a new separate group.
;          - Updated the Staging Limiter code. Was not working due to the decel
;            fuel shutoff code.
;          - Added code to correct the fuel mileage reporting to the CCD bus.
;
; Version 1.3
; 03/07/12 - Updated the template format for improved goruping.
;            Added MP Scan data to the RAM section.
;
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
CodeOrg == 0x9600 ; moved from 9200 to 9600 to make room for added 3D table data
                  ; for 3-bar (or 4-bar) conversion...

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

.define CalDataFile /E:\Thumbdrive\BoostButton\Products\Cal Data\Source Files\91T3_Master\v1\T-T3_22_T3_MTX_A393.tpl/
        
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

    chem2 title TurbonatorT3v2
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
;
; 68HC11 Disassembly
;    Mopar ECM
;    1990 2.2 Turbo IV
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

L0000                                                      == 0x0000;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
L0001                                                      == 0x0001;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
L0002                                                      == 0x0002;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
L0003                                                      == 0x0003;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
L0004                                                      == 0x0004;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
MINTHR_LowestSessionTPS                                    == 0x0005;MPScan;MINTHR;byte;VOLT;0.00;0.00;5.00;1;.5;1.00;5.00;5.00;gauge-a
DCCOR0_AdaptiveVNTCell0                                    == 0x0006;MPScan;DCCOR0;byte;%;0;-25.00;25.00;5;1;1.00;-25.00;25.00;gauge-a
DCCOR1_AdaptiveWastegateCellBelow3psi                      == 0x0007;MPScan;DCCOR1;byte;%;0;-25.00;25.00;5;1;1.00;-25.00;25.00;gauge-a
DCCOR2_AdaptiveWastegateCellTo4000rpm                      == 0x0008;MPScan;DCCOR2;byte;%;0;-25.00;25.00;5;1;1.00;-25.00;25.00;gauge-a
DCCOR3_AdaptiveWastegateCellTo4992rpm                      == 0x0009;MPScan;DCCOR3;byte;%;0;-25.00;25.00;5;1;1.00;-25.00;25.00;gauge-a
DCCOR4_AdaptiveWastegateCellTo5504rpm                      == 0x000A;MPScan;DCCOR4;byte;%;0;-25.00;25.00;5;1;1.00;-25.00;25.00;gauge-a
DCCOR5_AdaptiveWastegateCellAbove5504rpm                   == 0x000B;MPScan;DCCOR5;byte;%;0;-25.00;25.00;5;1;1.00;-25.00;25.00;gauge-a
DCCOR6_AdaptiveVNTCell1                                    == 0x000C;MPScan;DCCOR6;byte;%;0;-25.00;25.00;5;1;1.00;-25.00;25.00;gauge-a
DCCOR7_AdaptiveVNTCell2                                    == 0x000D;MPScan;DCCOR7;byte;%;0;-25.00;25.00;5;1.00;1.00;-25.00;25.00;gauge-a
Timer_DacalCountdown                                       == 0x000E;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CurrentAisPosition                                         == 0x000F;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a

BitFlags_AIS                                               == 0x0010;MPScan;FLAGAIS;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b10_bit7			= $%10000000	;
    b10_bit6			= $%01000000	;
    b10_UseAIS		        = $%00100000	;Too much boost
    b10_bit4			= $%00010000	;
    b10_ATXInGear		= $%00001000	;Auto in gear
    b10_ATXChngGear		= $%00000100	;Auto just changed gears
    b10_bit1			= $%00000010	;
    b10_bit0			= $%00000001	;

AutoCalCell0                                               == 0x0011;MPScan;CELL0;byte;%;0;-25.00;25.00;5;1;1.00;-25.00;25.00;gauge-a
AutoCalCell1                                               == 0x0012;MPScan;CELL1;byte;%;0;-25.00;25.00;5;1;1.00;-25.00;25.00;gauge-a
AutoCalCell2                                               == 0x0013;MPScan;CELL2;byte;%;0;-25.00;25.00;5;1;1.00;-25.00;25.00;gauge-a
AutoCalCell3                                               == 0x0014;MPScan;CELL3;byte;%;0;-25.00;25.00;5;1;1.00;-25.00;25.00;gauge-a
AutoCalCell4                                               == 0x0015;MPScan;CELL4;byte;%;0;-25.00;25.00;5;1;1.00;-25.00;25.00;gauge-a
AutoCalCell5                                               == 0x0016;MPScan;CELL5;byte;%;0;-25.00;25.00;5;1;1.00;-25.00;25.00;gauge-a
AutoCalCell6                                               == 0x0017;MPScan;CELL6;byte;%;0;-25.00;25.00;5;1;1.00;-25.00;25.00;gauge-a
AutoCalCell7                                               == 0x0018;MPScan;CELL7;byte;%;0;-25.00;25.00;5;1;1.00;-25.00;25.00;gauge-a
AutoCalCell8                                               == 0x0019;MPScan;CELL8;byte;%;0;-25.00;25.00;5;1;1.00;-25.00;25.00;gauge-a
AutoCalCell9                                               == 0x001A;MPScan;CELL9;byte;%;0;-25.00;25.00;5;1;1.00;-25.00;25.00;gauge-a
AutoCalCell10                                              == 0x001B;MPScan;CELL10;byte;%;0;-25.00;25.00;5;1;1.00;-25.00;25.00;gauge-a
AutoCalCell11                                              == 0x001C;MPScan;CELL11;byte;%;0;-25.00;25.00;5;1;1.00;-25.00;25.00;gauge-a
AutoCalCell12idle                                          == 0x001D;MPScan;CELL12;byte;%;0;-25.00;25.00;5;1;1.00;-25.00;25.00;gauge-a
AutoCalCellEnd                                             == 0x001E;MPScan;None;byte;;;0.00;255.00;255;255;1.00;0.00;255.00;gauge-a

ErrorBitRegister0                                          == 0x001F;MPScan;ERR0;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b1f_errLostFJ2		= $%10000000	; 44 Loss of FJ2
    b1f_errNothing		= $%01000000	; 45 Nothing (overboost)
    b1f_errHighVoltage		= $%00100000	; 46 Battery Volts High
    b1f_errLowVoltage		= $%00010000	; 47 Battery Volts Low
    b1f_errStuckLean		= $%00001000	; 51 Lean condition
    b1f_errStuckRich		= $%00000100	; 52 Rich Condition
    b1f_errChecksum		= $%00000010	; 53 Prom Checksum
    b1f_errDistSync		= $%00000001	; 54 Distributor Sync
ErrorBitRegister1                                          == 0x0020;MPScan;ERR1;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b20_errAcCutoutRelay	= $%10000000	; 33 AC Cutout Relay
    b20_errSpeedCtlSolenoid	= $%01000000	; 34 Speed Ctl Solenoid
    b20_errRadFanRelay		= $%00100000	; 35 Radiator Fan Relay
    b20_errWastegateSolenoid	= $%00010000	; 36 Wastegate Solenoid
    b20_errBaroReadSolenoid	= $%00001000	; 37 Barometric Read Solenoid
    b20_errChargingSystem	= $%00000100	; 41 Charging System
    b20_errASDRelay		= $%00000010	; 42 Auto Shutdown Relay
    b20_errIgnitionCoil 	= $%00000001	; 43 Ignition Coil Control
ErrorBitRegister2                                          == 0x0021;MPScan;ERR2;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b21_errCoolantTempSensor	= $%10000000	; 22 Coolant Temp Sensor
    b21_errChargeTempSensor	= $%01000000	; 23 Charge Temp Sensor
    b21_errTPS			= $%00100000	; 24 Throttle Position
    b21_errAIS			= $%00010000	; 25 AIS Motor
    b21_errInjectorCurrent	= $%00001000	; 26 Injector Current Limit Not Achieved
    b21_errInjectorDriver	= $%00000100	; 27 Injector Driver interface
    b21_errPurgeSolenoid	= $%00000010	; 31 Purge Solenoid
    b21_errEGR		        = $%00000001	; 32 Exh Gas Recirc Solenoid
ErrorBitRegister3                                          == 0x0022;MPScan;ERR3;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b22_errNotCranked		= $%10000000	; 11 Engine Not Cranked Since Battery Disconnected
    b22_errMemPowerLost 	= $%01000000	; 12 Memory Standby Power Lost
    b22_errMapPneumatic 	= $%00100000	; 13 MAP Pneumatic
    b22_errMapElectrical	= $%00010000	; 14 MAP Electrical
    b22_errDistanceSensor	= $%00001000	; 15 Vehicle Distance Sensor
    b22_errBattVoltageSense	= $%00000100	; 16 Battery Voltage Sense
    b22_errEngineTooCool	= $%00000010	; 17 Engine Running Too Cool (thermostat)
    b22_errO2Sensor		= $%00000001	; 21 Oxygen Sensor
ErrorBitRegisterStored0                                    == 0x0023;MPScan;ERRST0;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b23_bit7			= $%10000000	; 44 Loss of FJ2
    b23_bit6			= $%01000000	; 45 Overboost
    b23_bit5			= $%00100000	; 46 Battery Volts High
    b23_bit4			= $%00010000	; 47 Battery Volts Low
    b23_bit3			= $%00001000	; 51 Lean condition
    b23_bit2			= $%00000100	; 52 Rich Condition
    b23_bit1			= $%00000010	; 53 Prom Checksum
    b23_bit0			= $%00000001	; 54 Distributor Sync
ErrorBitRegisterStored1                                    == 0x0024;MPScan;ERRST1;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b24_bit7			= $%10000000	; 33 AC Cutout Relay
    b24_bit6			= $%01000000	; 34 Speed Ctl Solenoid
    b24_bit5			= $%00100000	; 35 Radiator Fan Relay
    b24_bit4			= $%00010000	; 36 Wastegate Solenoid
    b24_bit3			= $%00001000	; 37 Barometric Read Solenoid
    b24_bit2			= $%00000100	; 41 Charging System
    b24_bit1			= $%00000010	; 42 Auto Shutdown Relay
    b24_bit0			= $%00000001	; 43 Ignition Coil Control
ErrorBitRegisterStored2                                    == 0x0025;MPScan;ERRST2;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b25_bit7			= $%10000000	; 22 Coolant Temp Sensor
    b25_bit6			= $%01000000	; 23 Charge Temp Sensor
    b25_bit5			= $%00100000	; 24 Throttle Position
    b25_bit4			= $%00010000	; 25 AIS Motor
    b25_bit3			= $%00001000	; 26 Injector Current Limit Not Achieved
    b25_bit2			= $%00000100	; 27 Injector Driver interface
    b25_bit1			= $%00000010	; 31 Purge Solenoid
    b25_bit0			= $%00000001	; 32 Exh Gas Recirc Solenoid
ErrorBitRegisterStored3                                    == 0x0026;MPScan;ERRST3;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b26_bit7			= $%10000000	; 11 Engine Not Cranked Since Battery Disconnected
    b26_bit6			= $%01000000	; 12 Memory Standby Power Lost
    b26_bit5			= $%00100000	; 13 MAP Pneumatic
    b26_bit4			= $%00010000	; 14 MAP Electrical
    b26_bit3			= $%00001000	; 15 Vehicle Distance Sensor
    b26_bit2			= $%00000100	; 16 Battery Voltage Sense
    b26_bit1			= $%00000010	; 17 Engine Running Too Cool
    b26_bit0			= $%00000001	; 21 Oxygen Sensor

ErrorCodeUpdateKeyOnCount                                  == 0x0027;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
ErrorCodeUpdateKeyOnCount2                                 == 0x0028;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
ErrorCodeUpdateKeyOnCount3                                 == 0x0029;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Cyl2_InjPWTrim                                             == 0x002A;MPScan;TRIM2;byte;%;0;0.00;-25;25;5;1;25;-25;gauge-a
Cyl1_InjPWTrim                                             == 0x002B;MPScan;TRIM1;byte;%;0;0.00;-25;25;5;1;25;-25;gauge-a
Cyl3_InjPWTrim                                             == 0x002C;MPScan;TRIM3;byte;%;0;0.00;-25;25;5;1;25;-25;gauge-a
Cyl4_InjPWTrim                                             == 0x002D;MPScan;TRIM4;byte;%;0;0.00;-25.00;25.00;5.00;1;25.00;-25.00;gauge-a
CylTrimFlags                                               == 0x002E;MPScan;FLAGTR;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a

; can't use these, they're for cruise control...
;---------------------------------------------------

L002f                                                      == 0x002F;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
L0030                                                      == 0x0030;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
L0031                                                      == 0x0031;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
L0032                                                      == 0x0032;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a

Counter_SpeedSensorInterrupt                               == 0x0033;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
L0034                                                      == 0x0034;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
AdaptiveRetardIndex                                        == 0x0035;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a

BitFlags_36                                                == 0x0036;MPScan;FLAG36;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b36_EGR			= $%10000000	; EGR Active
    b36_bit6			= $%01000000	;
    b36_ReadBaroRequired	= $%00100000	; Read Baro At Next Opportunity
    b36_EMR			= $%00010000	; Emission Maint Reminder
    b36_bit3			= $%00001000	; Not used
    b36_bit2			= $%00000100	; Not used
    b36_ais1			= $%00000010	; AIS Step Phase - specifies which of the bit patterns
    b36_ais0			= $%00000001	; AIS Step Phase   is being output to the stepper motor
    b36_both			= $%00000011

BodyComputerBatteryVoltsOutput                             == 0x0037;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_Dwell_14                                             == 0x0038;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_Dwell_23                                             == 0x0039;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CurrentWastegatePosition                                   == 0x003A;MPScan;WGDC;byte;%;0;0.00;100.00;25.00;10.00;5;0.00;128.00;gauge-a
WastegateDutyCycleDecreaseFromX                            == 0x003B;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_BoostErrTimer                                        == 0x003C;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a

StartupSwitchMirror1                                       == 0x003D;MPScan;SWT1;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    sw1_bit7           	        = $%10000000	;
    sw1_ACclutch       	        = $%01000000	; A/C Clutch input
    sw1_CruiseSet              	= $%00100000	; Cruise Set
    sw1_bit4                    = $%00010000	;
    sw1_CruiseOnOff         	= $%00001000	; Cruise On/Off
    sw1_Brake          		= $%00000100	; Brake Switch
    sw1_CruiseResume   		= $%00000010	; Cruise Resume
    sw1_PNswitch                = $%00000001	; Park/Neutral switch
StartupSwitchMirror2                                       == 0x003E;MPScan;SWT2;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    sw2_bit7           	        = $%10000000	;
    sw2_ACclutch       	        = $%01000000	; A/C Clutch input
    sw2_CruiseSet              	= $%00100000	; Cruise Set
    sw2_bit4                    = $%00010000	;
    sw2_CruiseOnOff         	= $%00001000	; Cruise On/Off
    sw2_Brake          		= $%00000100	; Brake Switch
    sw2_CruiseResume   		= $%00000010	; Cruise Resume
    sw2_PNswitch                = $%00000001	; Park/Neutral switch

PIA1_Buffer                                                == 0x003F;MPScan;PIA1;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    pi1_CEL                     = $%10000000    ; Check Engine Light (Pin )
    pi1_PurgeSol                = $%01000000    ; Purge Solenoid (Pin )
    pi1_Fan                     = $%00100000    ; Fan Relay (Pin )
    pi1_ASD                     = $%00010000    ; Auto Shutdown Relay (Pin )
    pi1_AISMotor3               = $%00001000    ; AISM (Pin )
    pi1_AISMotor2               = $%00000100    ; AISM (Pin )
    pi1_AISMotor1               = $%00000010    ; AISM (Pin )
    pi1_AISMotor0               = $%00000001    ; AISM (Pin )
PIA2_Buffer                                                == 0x0040;MPScan;PIA2;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    pi2_VNTSol                  = $%10000000    ; Waste Gate Solenoid VNT (Pin )
    pi2_WGSol                   = $%01000000    ; Waste Gate Solenoid (Pin )
    pi2_EGRSol                  = $%00100000    ; Part Throttle Unlock (Pin )
    pi2_Baro                    = $%00010000    ; Baro Read Solenoid (Pin )
    pi2_ACRelay                 = $%00001000    ; A/C Clutch Relay (Pin )
    pi2_PTU                     = $%00000100    ; EGR Solenoid (Pin )
    pi2_SCVent                  = $%00000010    ; Speed Ctl Vent (Pin )
    pi2_SCVac                   = $%00000001    ; Speed Ctl Vacuum (Pin )
PIA3_Buffer                                                == 0x0041;MPScan;PIA3;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    pi3_bit7                    = $%10000000    ;
    pi3_KnockCap                = $%01000000    ; Knock Voltage Storage Cap
    pi3_ChargeTemp              = $%00100000    ; 1K Pullup Resistor For Charge Temp Sensor Circuit Control
    pi3_CoolantTemp             = $%00010000    ; 1K Pullup Resistor For Coolant Sensor Circuit Control
    pi3_FuelMon                 = $%00001000    ; Fuel Monitor?  (Pin )
    pi3_CCDEnable               = $%00000100    ; CCD Enable
    pi3_Tach                    = $%00000010    ; Tach Signal? (Pin )
    pi3_bit0                    = $%00000001    ;

CruiseStatus_1                                             == 0x0042;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CruiseStatus_2                                             == 0x0043;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a

Counter_Cruise_1                                           == 0x0044;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Counter_Cruise                                             == 0x0045;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Counter_TimerRegHalfOverflowBetweenSpeedoPulses            == 0x0046;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
PreviousVehicleSpeed_HB                                    == 0x0047;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
PreviousVehicleSpeed_LB                                    == 0x0048;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
TimerOverflowsBetweenSpeedoPulses                          == 0x0049;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
InverseVehicleSpeed_HB                                     == 0x004A;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
InverseVehicleSpeed_LB                                     == 0x004B;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
VehicleSpeed_HB                                            == 0x004C;MPScan;SPEED;word;MPH;0;0.00;200;10;5;1.00;0.00;1024;gauge-a
VehicleSpeed_LB                                            == 0x004D;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Counter_Cruise_2                                           == 0x004E;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Counter_Cruise_3                                           == 0x004F;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CruiseSpeedSetpoint                                        == 0x0050;MPScan;CRUSPD;byte;MPH;0;0.00;200;10;5;1.00;0.00;1024;gauge-a
CruiseControlVar0                                          == 0x0051;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CruiseControlVar1                                          == 0x0052;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CruiseControlVar2                                          == 0x0053;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CruiseControlVar3                                          == 0x0054;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CruiseControlVar4                                          == 0x0055;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Counter_SomethingWithCamSensor                             == 0x0056;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CruiseControlVar6                                          == 0x0057;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB                 == 0x0058;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
ErrorBitsAssociatedWithPIA1AndReg1eTo25_LB                 == 0x0059;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
ClearTheErrorTimer_0                                       == 0x005A;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
ClearTheErrorTimer_1                                       == 0x005B;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a

b5c_IPL1                                                   == 0x005C;MPScan;IPL1;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b5c_MapStuck		= $%10000000	; Map Stuck
    b5c_TpsBadSignal		= $%01000000	; Throttle
    b5c_MapBadSignal		= $%00100000	; MapVolts
    b5c_Bad_BatVolts		= $%00010000	; BatVolts
    b5c_bit3			= $%00001000	;
    b5c_BattNotCharging 	= $%00000100	; BatVoltsNotNearTarget
    b5c_BadCoolantTemp		= $%00000010	; Cool Volts
    b5c_BadCTSensor		= $%00000001	; ChargeVolts
b5d_IPL2                                                   == 0x005D;MPScan;IPL2;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b5d_EGRSolFault		= $%10000000	; EGR Solenoid Fault
    b5d_MajorFault		= $%01000000	; Major Fault
    b5d_bit5			= $%00100000	;
    b5d_InjectorFault		= $%00010000	; Fuel Injector Fault
    b5d_WGSolFault		= $%00001000	; Map Wastegate
    b5d_EMRLight		= $%00000100	; EMR Light?
    b5d_bit1			= $%00000010	;
    b5d_bit0			= $%00000001	;
BitFlags5E                                                 == 0x005E;MPScan;FLAG5E;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b5e_MapOK			= $%10000000	; Map OK
    b5e_bit6			= $%01000000	;
    b5e_bit5			= $%00100000	;
    b5e_bit4			= $%00010000	;
    b5e_bit3		        = $%00001000	;
    b5e_bit2		        = $%00000100	;
    b5e_bit1			= $%00000010	;
    b5e_bit0 		        = $%00000001	;

ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR                == 0x005F;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
TimerOverflowsBetweenCamPulses                             == 0x0060;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
DistributorFallingEdgePulsewidth_HB                        == 0x0061;MPScan;DISTPW;word;mSEC;0.00;0.00;65.535;5;1;1.00;0.00;65.535;gauge-a
DistributorFallingEdgePulsewidth_LB                        == 0x0062;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Counter_TimerPastHalfwayBetweenCamPulses                   == 0x0063;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
LastCamFallingEdgeTime                                     == 0x0064;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a

BitFlags65                                                 == 0x0065;MPScan;FLAG65;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b65_bit7			= $%10000000	;
    b65_bit6			= $%01000000	;
    b65_bit5			= $%00100000	;
    b65_bit4			= $%00010000	;
    b65_bit3			= $%00001000	;
    b65_bit2			= $%00000100	;
    b65_bit1			= $%00000010	;
    b65_bit0			= $%00000001	;
BitFlags66                                                 == 0x0066;MPScan;FLAG66;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b66_OffIdle 		= $%10000000	; Throttle Pressed
    b66_UpdatedMINTHR		= $%01000000	; Minimum Throttle Value has been updated with an actual value
    b66_OpenLoop		= $%00100000	; Not In Closed Loop ;Oxygen Sensor Stuck
    b66_O2Valid 		= $%00010000	; Oxygen Sensor Has Been Outside .75V to .29V Range
    b66_PartThrottle		= $%00001000	; Throttle Lightly Pressed
    b66_O2Rich			= $%00000100	; Oxygen Sensor on the Rich Side
    b66_PTEisMaxed		= $%00000010	; Part Throttle Enrichment is maxed
    b66_FullThrottle		= $%00000001	; Throttle Floored
BitFlags67                                                 == 0x0067;MPScan;FLAG67;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b67_Purge			= $%10000000	; Canister Purge
    b67_FallToIdle		= $%01000000	; Engine Speed Too High to be Idling
    b67_InMotion		= $%00100000	; Something to do with vehicle moving
    b67_StayOpenLoop		= $%00010000	; Dont Try Closed Loop
    b67_IdleSpeedMode		= $%00001000	; Dont Control Idle Speed (if clear dont control AIS, if set dont control idle with Injectors)
    b67_OpenLoop		= $%00000100	; Currently Open Loop
    b67_bit1			= $%00000010	; Something with reg 73
    b67_BadO2			= $%00000001	; Oxygen Sensor Bad
BitFlags68                                                 == 0x0068;MPScan;FLAG68;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b68_SparkEngineNotRunning	= $%10000000	; Spark - Engine Not Running
    b68_bit6			= $%01000000	; AIS Stuff
    b68_BaroSolEnergized	= $%00100000	;
    b68_ASDon			= $%00010000	; ASD ON
    b68_SpeedOver40		= $%00001000	; SPEED GREATER THAN 40 MPH
    b68_Past12secRunning	= $%00000100	; ENGINE RUNNING MORE THAN 12 sec OR KEY ON FOR MORE THAN 12 sec
    b68_BladePassedSensor	= $%00000010	; WINDOW BLADE HAS PASSED THROUGH DISTRIBUTOR SYNC SENSOR
    b68_EndOfBlade		= $%00000001	; END OF ANY BLADE AT DISTRIBUTOR REF SENSOR
BitFlags69                                                 == 0x0069;MPScan;FLAG69;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b69_bit7        		= $%10000000	; Coolant temp filter/store?
    b69_bit6			= $%01000000	; Coolant temp filter/store?
    b69_AtIdle			= $%00100000	; Just returned to idle
    b69_AcClutch		= $%00010000	; AC clutch engaged
    b69_bit3			= $%00001000	; ?
    b69_bit2			= $%00000100	; AC?
    b69_bit1			= $%00000010	;
    b69_bit0			= $%00000001	;
    b69_BadO2Read		= $%00000011    ; Indicates a bad O2 sensor reading?
BitFlags6a                                                 == 0x006A;MPScan;FLAG6A;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b6a_Cruise4 		= $%10000000	; cruise bit
    b6a_Cruise3 		= $%01000000	; cruise bit
    b6a_Cruise2 		= $%00100000	; cruise bit
    b6a_Cruise1 		= $%00010000	; cruise bit
    b6a_OverRev 		= $%00001000	; OverRevving
    b6a_FuelOff 		= $%00000100	; Shut Off Fuel
    b6a_DRBToggle2		= $%00000010	; DRBII Toggle
    b6a_DRBToggle1		= $%00000001	; DRBII Toggle
BitFlags6b                                                 == 0x006B;MPScan;FLAG6B;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b6b_bit7			= $%10000000	;
    b6b_bit6			= $%01000000	;
    b6b_bit5			= $%00100000	; Coil Test
    b6b_bit4			= $%00010000	;
    b6b_bit3			= $%00001000	;
    b6b_bit2			= $%00000100	;
    b6b_DecelFuelCut		        = $%00000010	; DecelFuelCut
    b6b_bit0			= $%00000001	; Coil Test
BitFlags6c                                                 == 0x006C;MPScan;FLAG6C;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b6c_VNTOvBst		= $%10000000	; VNT Overboost 
    b6c_bit6			= $%01000000	;
    b6c_bit5			= $%00100000	;
    b6c_DRBModeFlag		= $%00010000	; indicates system is in DRB test mode
    b6c_bit3			= $%00001000	;
    b6c_bit2			= $%00000100	;
    b6c_bit1		        = $%00000010	;
    b6c_EMR_1			= $%00000001	; emission maint reminder
BitFlags6d                                                 == 0x006D;MPScan;FLAG6D;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b6d_FuelEngineNotRunning	= $%10000000	; Fuel - Engine Not Running
    b6d_BigMapChange		= $%01000000	; Significant MAP Change
    b6d_JustStarted		= $%00100000	; Engine Just Started
    b6d_Starting		= $%00010000	; Use Starting Injector PW Calculations (instead of Running Injector PW Calculations)
    b6d_BaroOkEngineStopped	= $%00001000	; Take Baro Reading Straight From MAP Since Engine Not Running
    b6d_Uncranked		= $%00000100	; Engine Not Cranked Since
    b6d_DisableNormalDwell	= $%00000010	; Normal Dwell Disable
    b6d_NeedSetup		= $%00000001	; System Needs To Run Setup Routine
BitFlags6e                                                 == 0x006E;MPScan;FLAG6E;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b6e_BoostOver5psi		= $%10000000	; Boost Greater than 5 PSI
    b6e_WastegateDC		= $%01000000	; Current WasteGate Duty Cycle
    b6e_DistSync		= $%00100000	; Distributor Sync Value
    b6e_UseSparkScatter 	= $%00010000	; Use Spark Scatter
    b6e_SearchBladeEndRef	= $%00001000	; Search for end of window blade on Reference Signal
    b6e_bit2		        = $%00000100	; Oxygen Sensor Enable or something with CAM position bits not in sync with distributor
    b6e_InjectorB		= $%00000010	; CAM Position Bit 1 - this bit controls InjectorB
    b6e_InjectorA		= $%00000001	; CAM Position Bit 0 - this bit controls InjectorA
    b6e_InjectorAandB		= $%00000011	; Both b6e_InjectorB and b6e_InjectorA
BitFlags6f                                                 == 0x006F;MPScan;FLAG6F;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b6f_bit7			= $%10000000
    b6f_bit6			= $%01000000
    b6f_bit5                    = $%00100000
    b6f_BadSpeedo1		= $%00010000    ; Stuck Off
    b6f_BadSpeedo2              = $%00001000    ; Stuck On
    b6f_BadASD			= $%00000100    ; ASD Test
    b6f_Alternator1	        = $%00000010    ; Alternator test
    b6f_Alternator2	        = $%00000001    ; Alternator test
    b6f_AlternatorBits		= $%00000011    ;
BitFlags70                                                 == 0x0070;MPScan;FLAG70;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    b70_bit7			= $%10000000
    b70_bit6			= $%01000000
    b70_O2Enable                = $%00100000
    b70_AlternatorField	        = $%00010000    ; AlternatorField
    b70_bit3		        = $%00001000
    b70_bit2			= $%00000100
    b70_bit1		        = $%00000010
    b70_bit0		        = $%00000001

TargetIdleSpeedHB                                          == 0x0071;MPScan;TIDL;word;RPM;0;0.00;8000;1000;100;1000;0.00;8192;gauge-a
TargetIdleSpeedLB                                          == 0x0072;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
SumOfFuelModifiers_HB                                      == 0x0073;MPScan;FULMOD;word;%;0;0.00;100;10;1;1;0.00;100;gauge-a
SumOfFuelModifiers_LB                                      == 0x0074;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
InjectorPulsewidth_HB                                      == 0x0075;MPScan;INJPW;word;mSEC;0.00;0.00;50;10.00;5;1;0.00;49.15;gauge-a
InjectorPulsewidth_LB                                      == 0x0076;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
BaseInjectorPulsewidth_HB                                  == 0x0077;MPScan;BASPW;word;mSEC;0.00;0.00;50;255.00;5;1;0.00;49.152;gauge-a
BaseInjectorPulsewidth_LB                                  == 0x0078;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
EngineRpm_HB                                               == 0x0079;MPScan;ENGRPM;word;RPM;0;0.00;8000;1000;100;1000;0.00;8192;gauge-a
EngineRpm_LB                                               == 0x007A;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
PreviousEngineRpm_HB                                       == 0x007B;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
PreviousEngineRpm_LB                                       == 0x007C;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
ChargeTempVolts                                            == 0x007D;MPScan;CHGVLT;byte;VOLTS;0.00;0.00;5;1;.5;1.00;0.00;5;gauge-a
BaroPressure                                               == 0x007E;MPScan;BARO;byte;PSI;0.0;0.00;14.7;5;1;1.00;0.00;14.7;gauge-a
MapVolts                                                   == 0x007F;MPScan;MAPVLT;byte;VOLTS;0.00;0.00;5;1;.5;1.00;0.00;5;gauge-a
MapAverageValue_HB                                         == 0x0080;MPScan;MAPAVG;byte;PSI;0.0;0.00;14.7;5;1;1.00;0.00;14.7;gauge-a
MapAverageValue_LB                                         == 0x0081;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
MapValue                                                   == 0x0082;MPScan;MAPVAL;byte;PSI;0.0;0.00;14.70;5;1;1.00;0.00;14.7;gauge-a
Factor_LeanoutOrEnrichTime_MAP                             == 0x0083;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
TpsAverageValue_HB                                         == 0x0084;MPScan;TPSAVG;byte;VOLTS;0.00;0.00;5;1;.5;1.00;0.00;5;gauge-a
TpsAverageValue_LB                                         == 0x0085;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
TpsVolts                                                   == 0x0086;MPScan;TPSVLT;byte;VOLTS;0.00;0.00;5;1;.5;1.00;0.00;5;gauge-a
Factor_LeanoutOrEnrichTime_TPS                             == 0x0087;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_DelayBeforeUpdating_MINTHR                           == 0x0088;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CoolantTemp                                                == 0x0089;MPScan;COOLT;byte;DEGF;0;-200;260;10;5;1.00;-200;260;gauge-a
BatteryVolts                                               == 0x008A;MPScan;BATVLT;byte;VOLTS;0.0;0.00;16;4;1;1.00;0.00;16.20;gauge-a
O2SensorVolts                                              == 0x008B;MPScan;O2VLT;byte;VOLTS;0.00;0.00;5;1;.5;1.00;0.00;5;gauge-a
LastTpsVolts                                               == 0x008C;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
LastCoolantTempVolts                                       == 0x008D;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
LastChargeTempVolts                                        == 0x008E;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
KnockVolts                                                 == 0x008F;MPScan;KNKVLT;byte;VOLTS;0.00;0.00;5;1;.5;1.00;0.00;5;gauge-a
AmbientAirTempVolts                                        == 0x0090;MPScan;AMBVLT;byte;VOLTS;0.00;0.00;5;1;.5;1.00;0.00;5;gauge-a
TargetBatteryVolts                                         == 0x0091;MPScan;TGTBAT;byte;VOLTS;0.0;0.00;16;4;1;1.00;0.00;16.2;gauge-a
Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached         == 0x0092;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Counter_FallingEdgeEPP_MaxFF                               == 0x0093;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Counter_EPP_MaxFF                                          == 0x0094;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Factor_StartFuelDecayIntoRunFuel                           == 0x0095;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_OpenLoopFraction                                     == 0x0096;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Factor_DecelLeanoutWhenMAPDecreasing                       == 0x0097;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_OffThrottleFuelEnrich                                == 0x0098;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_O2InhibitSwitchingRichIdleToClosedLoop               == 0x0099;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Pulsewidth_PartThrottleEnrichment_HB                       == 0x009A;MPScan;PTEPW;byte;mSEC;0.00;0.00;50;10;5;1.00;0.00;49.15;gauge-a
Pulsewidth_PartThrottleEnrichment_LB                       == 0x009B;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Pulsewidth_AISPulseEnrichment_HB                           == 0x009C;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Pulsewidth_AISPulseEnrichment_LB                           == 0x009D;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Counter_O2SensorFeedbackCount_Signed                       == 0x009E;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_CountdownFromStartRunForAisFeedback                  == 0x009F;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
KeyOnOrEngineRunningTime                                   == 0x00A0;MPScan;ENGRUN;byte;SEC;0.0;0.00;2.8;.5;.1;1.00;0.00;2.8;gauge-a
Counter_MainLoop                                           == 0x00A1;MPScan;CNTMLP;byte;#;0;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
EngineRunningTimeMaxFF                                     == 0x00A2;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
EngineRunningTimeBeforeStall                               == 0x00A3;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_AlternatorDutyCycle                                  == 0x00A4;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
MinimumTimerCountBeforeMainloopCanContinue                 == 0x00A5;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CountdownTimerFromKeyOn                                    == 0x00A6;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_CLTIME_ClosedLoopTimer                               == 0x00A7;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Counter_AdaptiveMem_Erase                                  == 0x00A8;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop      == 0x00A9;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
AdaptiveCellUpdateTimer_IncrementedEveryCamRisingEdge      == 0x00AA;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
PointerIntoAdaptiveMemory                                  == 0x00AB;MPScan;PNTMEM;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
ValueFromAdaptiveMemory                                    == 0x00AC;MPScan;VALMEM;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
SparkScatterIncrement                                      == 0x00AD;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
EngineRPM_3D                                               == 0x00AE;MPScan;RPM3D;byte;RPM;0;0.00;8000;1000;100;1000;0.00;8192;gauge-a
CurrentWGIncrement                                         == 0x00AF;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
SparkScatterFuelStabilizationValue_HB                      == 0x00B0;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
SparkScatterFuelStabilizationValue_LB                      == 0x00B1;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_FuelEnrich                                           == 0x00B2;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
InjectorLatency                                            == 0x00B3;MPScan;INJLAT;byte;mSEC;0.00;0.00;12;3;1;1.00;0.00;12.29;gauge-a
Timer_OutOfClosedLoopMode                                  == 0x00B4;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_O2ToggleDuration                                     == 0x00B5;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
DesiredNewAisPosition                                      == 0x00B6;MPScan;NEWAIS;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_AisChanges                                           == 0x00B7;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_AcClutchEngageRestrictionTimer                       == 0x00B8;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_AcCutout                                             == 0x00B9;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_AisOrO2Sensor                                        == 0x00BA;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
ACClutchToggleVar                                          == 0x00BB;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Counter_AirCond                                            == 0x00BC;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_RadSteamingCountdown                                 == 0x00BD;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_MinimumFanRun                                        == 0x00BE;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
BitFlags_BF                                                == 0x00BF;MPScan;FLAGBF;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_OverboostCountdown                                   == 0x00C0;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_Over5PsiBoostMaxFF                                   == 0x00C1;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CalculatedSparkAdvance                                     == 0x00C2;MPScan;SPKADV;byte;DEG;0.0;0.00;60;10;2;1.00;0.00;128.00;gauge-a
Cylinder2Retard                                            == 0x00C3;MPScan;RET2;byte;DEG;0.0;0.00;30;10;1.00;1.00;0.00;128.00;gauge-a
Cylinder1Retard                                            == 0x00C4;MPScan;RET1;byte;DEG;0.0;0.00;30;10;1.00;1.00;0.00;128.00;gauge-a
Cylinder3Retard                                            == 0x00C5;MPScan;RET3;byte;DEG;0.0;0.00;30;10;1.00;1.00;0.00;128.00;gauge-a
Cylinder4Retard                                            == 0x00C6;MPScan;RET4;byte;DEG;0.0;0.00;30;10;1.00;1.00;0.00;128.00;gauge-a
MaxRetardFromMAP                                           == 0x00C7;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
WastegateDutyCycleIncreaseFromKnock                        == 0x00C8;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
KnockSensorThreshold                                       == 0x00C9;MPScan;KNKTHR;byte;VOLTS;0.00;0.00;5;1;.5;1.00;0.00;5;gauge-a
Timer_BaroReadInterval                                     == 0x00CA;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_BaroReadRpmConditionsSatisfied                       == 0x00CB;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_ThermostatDiagnostics                                == 0x00CC;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Timer_O2MiddleDiagnostics                                  == 0x00CD;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
PreviousBoostOverBaro                                      == 0x00CE;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
BoostDelta_Signed                                          == 0x00CF;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
EGRVar2                                                    == 0x00D0;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
DRBOffsetStored_HB                                         == 0x00D1;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
DRBOffsetStored_LB                                         == 0x00D2;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
ATMOffset                                                  == 0x00D3;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
DRBPointer1                                                == 0x00D4;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
DRBPointer2                                                == 0x00D5;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
DRBPointer3                                                == 0x00D6;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a

DRBSerialMode                                              == 0x00D7;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
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
CCDVar0                                                    == 0x00D8;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
    ccd_ErrBit		        = $%10000000	; CCD Error
    ccd_bit6		        = $%01000000	;
    ccd_bit5		        = $%00100000	;
    ccd_bit4		        = $%00010000	;
    ccd_bit3			= $%00001000	;
    ccd_bit2			= $%00000100	;
    ccd_bit1			= $%00000010	;
    ccd_bit0			= $%00000001	;

CCDTemp_HB                                                 == 0x00D9;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CCDTemp_LB                                                 == 0x00DA;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CCDFuelOutput_HB                                           == 0x00DB;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CCDFuelOutput_LB                                           == 0x00DC;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CCDFlags1                                                  == 0x00DD;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CCDFlags2                                                  == 0x00DE;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CCDFlags3                                                  == 0x00DF;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CCDFlags4                                                  == 0x00E0;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CCDFlags5                                                  == 0x00E1;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a

      ccd_AlarmDisable          = $%00100000

CCDFlags6                                                  == 0x00E2;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
AdvanceTemporary                                           == 0x00E3;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
SparkScatter                                               == 0x00E4;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CylTrim_Adaptive_Var1                                      == 0x00E5;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CylTrim_FlagsE6                                            == 0x00E6;MPScan;FLAGE6;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
CylTrim_FlagsE7                                            == 0x00E7;MPScan;FLAGE7;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Counter_FuelEngRunning                                     == 0x00E8;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Counter_CylTrim1                                           == 0x00E9;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Counter_CylTrim2                                           == 0x00EA;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
BaseFuelScalar                                             == 0x00EB;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Counter_ACControl1                                         == 0x00EC;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
BoostTarget                                                == 0x00EE;MPScan;BSTTGT;byte;PSI;0.0;0.00;29.4;5;1;1.00;0.00;29.4;gauge-a
TempY                                                      == 0x00ED;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
TempX                                                      == 0x00EF;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
FDRVar0                                                    == 0x00F0;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
FDRVar1                                                    == 0x00F1;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
FDRVar2                                                    == 0x00F2;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
FDRVar3                                                    == 0x00F3;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
FDRVar4                                                    == 0x00F4;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
L00F5                                                      == 0x00F5;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Temp0                                                      == 0x00F7;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Temp1                                                      == 0x00F8;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Temp2                                                      == 0x00F9;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Temp3                                                      == 0x00FA;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Temp4                                                      == 0x00FB;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Temp5                                                      == 0x00FC;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Temp6                                                      == 0x00FD;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
Temp7                                                      == 0x00FE;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a
L00FF                                                      == 0x00FF;MPScan;None;byte;;;0.00;255.00;255.00;255.00;1.00;0.00;255.00;gauge-a

CPU_PortA	         == 0x1000
CPU_L1001_Reserved	 == 0x1001
CPU_PortIOControl	 == 0x1002
CPU_PortC	         == 0x1003
CPU_PortB	         == 0x1004
CPU_PortCL	         == 0x1005
CPU_L1006Reserved	 == 0x1006
CPU_PortC_DataDirection	 == 0x1007
CPU_PortD	         == 0x1008
CPU_PortD_DataDirection	 == 0x1009
CPU_PortE	         == 0x100a
CPU_HardwareTimerForceCompare	 == 0x100b
CPU_OutputCompare1Mask	 == 0x100c
CPU_OutputCompare1D	 == 0x100d
CPU_TimerCounterRegHigh	 == 0x100e
CPU_TimerInputCapture1_CamSensor	 == 0x1010
CPU_TimerInputCapture2_Speedometer	 == 0x1012
CPU_TimerInputCapture3_CrankSensor	 == 0x1014
CPU_TimerOutputCompareRegHigh1	 == 0x1016
CPU_Timer_OC2	                 == 0x1018
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
CPU_SerialBaudRate	 == 0x102b
CPU_SerialControlReg1	 == 0x102c
CPU_SerialControlReg2	 == 0x102d
CPU_SerialStatus	 == 0x102e
CPU_SerialData	         == 0x102f
CPU_A2DControlReg	 == 0x1030
CPU_A2DResults1	         == 0x1031
CPU_A2DResults2	         == 0x1032
CPU_A2DResults3	         == 0x1033
CPU_A2DResults4	         == 0x1034
CPU_BlockProtReg	 == 0x1035
CPU_SysConfigOptionReg	 == 0x1039
CPU_ArmOCToggleAndResetCopTimerReg	 == 0x103a
CPU_EEPROMControlReg	 == 0x103b
CPU_HighPriorityInterruptMask	 == 0x103c
CPU_SysInit	         == 0x103d
SystemConfigReg	         == 0x103f

SwitchPortAccessReg1	 == 0x6000
    ;sp1_     		        = $%10000000
    sp1_OC1Toggle	        = $%01000000
    sp1_B1Volt		        = $%00100000
    ;sp1_       		        = $%00010000
    ;sp1_		        = $%00001000
    ;sp1_			= $%00000100
    ;sp1_		        = $%00000010
    ;sp1_		        = $%00000001

SwitchPortAccessReg2	 == 0x6001

    sp2_CCDBus                  = $%00001000    ;

PIA_Ctrl_1	                 == 0x6002
PIA_Ctrl_2	                 == 0x6003
PIA_Ctrl_3	                 == 0x6004
PIA_Ctrl_4	                 == 0x6005
PIA_Ctrl_5	                 == 0x6006
PIA_Ctrl_6	                         == 0x6007
InjectorPulsewidth_HB_Cyl1	 == 0x6008
InjectorPulsewidth_HB_Cyl2	 == 0x600a
InjectorPulsewidth_HB_Cyl3	 == 0x600c
InjectorPulsewidth_HB_Cyl4	 == 0x600e

PIA3_Buffer_2	                 == 0x6040

ErrorCodeCounter	         == 0x6080
ErrorCodeBufferHB	         == 0x6081
ErrorCodeBufferLB	         == 0x6082
EGR_Temp_1	                 == 0x6083
EGR_Temp_2	                 == 0x6084
EGR_Temp_3	                 == 0x6085
BodyCompFlags4_X	         == 0x6086
Counter_SpeedSensorInterrupt_HB_X	 == 0x6087
BodyCompFlags3_X	         == 0x6088
MAPOffsetForCylTrim	         == 0x6089
DeltaBoostSampleCounter	         == 0x608a
MapValue_X	                 == 0x608b
MapVolts_X	                 == 0x608c
BitFlags608D	                 == 0x608d
BatVoltsDiagCounter	         == 0x608e
A2DResults2Temp	                 == 0x608f
ColdStartFuelReduxCounter	 == 0x6090
O2AdvanceIncrement	         == 0x6091
Counter_O2Diagnostics	         == 0x6092
ScaledDistPWForCruiseControl	 == 0x6093
L6094                            == 0x6094
L6095                            == 0x6095
L6096                            == 0x6096
L6097                            == 0x6097
EngineRpm_HB_X	                 == 0x6098
EngineRpm_LB_X	                 == 0x6099
Timer_BoostTimer	         == 0x609a
MAPAvgDelta	                 == 0x609b
TPSAvgDelta	                 == 0x609c
FuelLookupValue3D	         == 0x609d
KnockEnrichmentFactor	         == 0x609e
BaseFuelModifier	         == 0x609f
DRB_ProgramModeFlag	         == 0x60a0
DRB_SpecialProgramRoutine        == 0x60a2

;------------------------------------------------------------------------------

; Pretty sure this space actually exsists
; So, I'll use it for the Turbonator Mods...
Turbonator_Flags    == 0x60a3
    Turbonator_SparkOff  	= $%10000000    ; Turbonator - Spark-based rev limiter
    Turbonator_Staging	        = $%01000000    ; Turbonator - staging limiter is active
    Turbonator_DroppingRPM      = $%00100000    ; Turbonator - RPM is dropping (for 2-step control)
RevLimiterRPMOff    == 0x60a4
RevLimiterRPMOn     == 0x60a5
AntiLagRetard       == 0x60a6

;------------------------------------------------------------------------------

L60E1	 == 0x60e1
L60E2	 == 0x60e2
CPU_TimerCounterRegHigh_Temp	 == 0x60e4



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

InterruptPointer_DwellTimerB:
           jmp  Interrupt_DwellTimerB

InterruptPointer_DwellTimerA:
           jmp  Interrupt_DwellTimerA

InterruptPointer_TimerOC3_Wastegate:
           jmp  Interrupt_TimerOC3_Wastegate

InterruptPointer_TimerOC2:
           jmp  Interrupt_PulseAccumulatorInputEdge

InterruptPointer_TimerOutputCapture1:
           jmp  Interrupt_TimerOutputCapture1

InterruptPointer_TimerInputCapture3:
           jmp  Interrupt_RealTime

InterruptPointer_SpeedoSignal:
           jmp  Interrupt_SpeedometerSignal

InterruptPointer_CamSensorSignal:
           jmp  Interrupt_CamSensorSignal

InterruptPointer_RealTime:
           jmp  Interrupt_RealTime

InterruptPointer_CrankSensor_Signal:
           jmp  Interrupt_CrankSensor_Signal

TinterruptPointer_XIRQ:
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
           bpl  L9158          ; branch if plus (hi bit 0)
           ldd  CPU_TimerCounterRegHigh
           addd #0x03be        ;  -00000011 10111110-
   L9158:  addd #0x0004         ;  -00000000 00000100-
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
           jmp  L921B      

ControlAlternator:
           ldaa ATMOffset      ; load a with memory contents
           cmpa #0x0d          ; compare a with value -00001101-
           beq  L917E          ; branch if equal (zero)
           cmpa #0x14          ; compare a with value -00010100-
           bne  L9181          ; branch if not equal (not zero)
   L917E:  jmp  L9218      

   L9181:  ldx  #SwitchPortAccessReg1    ; load index with value
           brset *BitFlags6D, #b6d_FuelEngineNotRunning, TurnAlternatorOff    ; branch if bit(s) set
           ldab #0x11          ; load b with value -00010001-
           brset *BitFlags6f, #b6f_Alternator1, L9190    ; branch if bit(s) set
           ldab #0x15          ; load b with value -00010101-
   L9190:  bclr *BitFlags6f, #b6f_Alternator1    ; clear bits
           cmpb EngineRpm_HB
           bhi  TurnAlternatorOff    ; branch if higher
           bset *BitFlags6f, #b6f_Alternator1    ; set bits
           ldaa CPU_A2DResults2    ; load a with memory contents
           cmpa BatteryVolts    ; compare a with memory contents
           bcc  L91A3          ; branch if greater or equal
           staa BatteryVolts    ; store a into memory
   L91A3:  cmpa #0x41          ; compare a with value -01000001-
           bcc  L91AD          ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x06          ;  -00000110-
           bne  TurnAlternatorOff    ; branch if not equal (not zero)
   L91AD:  brclr *BitFlags70, #$%00001000, L91CE    ; branch if bit(s) clear
           ldaa A2DResults2Temp          ; load a with memory contents
           bne  L91BE          ; branch if not equal (not zero)
           ldaa CPU_A2DResults2    ; load a with memory contents
           staa A2DResults2Temp      
           bra  TurnAlternatorOff    ; branch

   L91BE:  suba CPU_A2DResults2
           bls  TurnAlternatorOff    ; branch if lower or same
           cmpa BTVHYS_BatteryVoltsHysteresisForAlternatorControl    ; compare a with memory contents (data is 04)
           bls  TurnAlternatorOff    ; branch if lower or same
           bset *BitFlags70, #$%00000100    ; set bits
           bclr *BitFlags70, #$%00001000    ; clear bits
   L91CE:  clr  A2DResults2Temp          ; zero byte at memory location
           ldaa CPU_A2DResults2    ; load a with memory contents
           suba TargetBatteryVolts
           bne  L91DE          ; branch if not equal (not zero)
           brclr  0, X, #$%00000100, TurnAlternatorOn    ; branch if bit(s) clear
           bra  TurnAlternatorOff    ; branch

   L91DE:  ldab #0x0e          ; load b with value -00001110-
           bcc  L91F1          ; branch if greater or equal
           nega                ; negate a (set high bit)
           cmpa #0x02          ; compare a with value -00000010-
           beq  L91EB          ; branch if equal (zero)
           bcc  TurnAlternatorOn    ; branch if greater or equal
           ldab #0x06          ; load b with value -00000110-
   L91EB:  andb Timer_AlternatorDutyCycle
           beq  TurnAlternatorOff    ; branch if equal (zero)
           bra  TurnAlternatorOn    ; branch

   L91F1:  cmpa #0x02          ; compare a with value -00000010-
           beq  L91F9          ; branch if equal (zero)
           bcc  TurnAlternatorOff    ; branch if greater or equal
           ldab #0x06          ; load b with value -00000110-
   L91F9:  andb Timer_AlternatorDutyCycle
           bne  TurnAlternatorOff    ; branch if not equal (not zero)
TurnAlternatorOn:
           bset  0, X, #$%00000100    ; bit set
           bset *BitFlags6f, #b6f_BadASD    ; set bits
           bra  L920B          ; branch

TurnAlternatorOff:
           bclr  0, X, #$%00000100    ; bit clear
           bclr *BitFlags6f, #b6f_BadASD    ; clear bits
   L920B:  sei                 ; disable interrupts
           bset  2, X, #$%00000100    ; bit set
           ldaa #0x12          ; load a with value -00010010-
   L9211:  deca                ; decrement a
           bne  L9211          ; branch if not equal (not zero)
           bclr  2, X, #$%00000100    ; bit clear
           cli                 ; enable interrupts
   L9218:  jmp  XmitRequestedRamLocation

   L921B:  brset *BitFlags_AIS, #b10_UseAIS, AisDriveRoutine    ; branch if bit(s) set
           lsra            
           bcs  L9218          ; branch if lower

;	.org	0x9223
AISTEP_BitPatternForAisControl:
    .byte 0x06                       ;Point 1
    .byte 0x05                       ;Point 2
    .byte 0x09                       ;Point 3
    .byte 0x0A                       ;Point 4

;           .org   0x9227
AisDriveRoutine:
           ldab BatteryVolts    ; load b with memory contents
           cmpb BTVAIS_MinVoltageForAis    ; compare b with memory contents (data is 71)
           bcs  L926D          ; branch if lower
           brset *BitFlags69, #$%00001000, L926D    ; branch if bit(s) set
           ldab CountdownTimerFromKeyOn    ; load b with memory contents
           bne  L926D          ; branch if not equal (not zero)
           ldab CurrentAisPosition    ; load b with memory contents
           brset *BitFlags_AIS, #b10_UseAIS, L9265    ; branch if bit(s) set
           lsra
           bcs  L926D          ; branch if lower
           cmpb DesiredNewAisPosition
           beq  L9289          ; branch if equal (zero)
           bcs  L9252          ; branch if lower
           brclr *CCDFlags5, #$%00000001, L926F    ; branch if bit(s) clear
           ldaa TempY          ; load a with memory contents
           bne  L928B          ; branch if not equal (not zero)
           bclr *CCDFlags5, #$%00000001    ; clear bits
           bra  L926F          ; branch

   L9252:  brset *CCDFlags5, #$%00000001, L925D    ; branch if bit(s) set
           ldaa TempY          ; load a with memory contents
           bne  L928B          ; branch if not equal (not zero)
           bset *CCDFlags5, #$%00000001    ; set bits
   L925D:  inc  CurrentAisPosition
           ldab BitFlags_36    ; load b with memory contents
           incb            
           bra  L9275          ; branch

   L9265:  bne  L926F          ; branch if not equal (not zero)
           bclr *BitFlags_AIS, #b10_UseAIS    ; clear bits
           bclr *CCDFlags5, #$%00000001    ; clear bits
   L926D:  bra  XmitRequestedRamLocation    ; branch

   L926F:  dec  CurrentAisPosition    ; decrement memory contents
           ldab BitFlags_36    ; load b with memory contents
           decb            
   L9275:  andb #0x03          ;  -00000011-
           ldx  #AISTEP_BitPatternForAisControl    ; load index with value
           abx                 ; add b to index
           sei                 ; disable interrupts
           stab Temp7          ; store b into memory
           ldab BitFlags_36    ; load b with memory contents
           andb #0xfc          ;  -11111100-
           orab Temp7      
           cli                 ; enable interrupts
           stab BitFlags_36    ; store b into memory
           bra  L92AB          ; branch

   L9289:  ldaa TempY          ; load a with memory contents
   L928B:  suba #0x01          ;  -00000001-
           bcc  L9290          ; branch if greater or equal
           clra                ; a = 0
   L9290:  staa TempY          ; store a into memory
           brset *BitFlags6C, #$%01000000, XmitRequestedRamLocation    ; branch if bit(s) set
           ldd  #0x80ff        ; load d (a&b) with value -10000000 11111111-
           jsr  SetPIAOutputBits    ; call subroutine
           ldab BitFlags_36    ; load b with memory contents
           andb #0x03          ;  -00000011-
           ldx  #AISTEP_BitPatternForAisControl    ; load index with value
           abx                 ; add b to index
           ldab 0x00, X        ; load b with memory at index + value
           anda #0x0f          ; AND a with value -00001111-
           cba             
           beq  XmitRequestedRamLocation    ; branch if equal (zero)
   L92AB:  ldab 0x00, X        ; load b with memory at index + value
           ldaa #0x90          ; load a with value -10010000-
           jsr  SetPIAOutputBits    ; call subroutine
           bset *BitFlags6E, #$%00000100    ; set bits
           ldd  #0xbc0f        ; load d (a&b) with value -10111100 00001111-
           jsr  SetPIAOutputBits    ; call subroutine
           bclr *BitFlags6E, #$%00000100    ; clear bits
           ldd  #0xb80f        ; load d (a&b) with value -10111000 00001111-
           jsr  SetPIAOutputBits    ; call subroutine
           ldaa L9222          ; load a with memory contents (data is 02)
           staa TempY          ; store a into memory
XmitRequestedRamLocation:
           brclr *DRBSerialMode, #bbe_FastSerial, L931E    ; branch if bit(s) clear
           ldaa CPU_SerialStatus    ; load a with memory contents
           bita #0x0e          ;  -00001110-
           beq  L92D9          ; branch if equal (zero)
           ldab CPU_SerialData    ; load b with memory contents
           bra  L931E          ; branch

   L92D9:  bita #0x20          ;  -00100000-
           beq  L931E          ; branch if equal (zero)
           ldab CPU_SerialData    ; load b with memory contents
           cmpb #0xf2          ;  -11110010-
           bne  L92E9          ; branch if not equal (not zero)
           bclr *BitFlags70, #$%00000001    ; clear bits
           bra  L931B          ; branch

   L92E9:  cmpb #0xf6          ;  -11110110-
           bne  L92F2          ; branch if not equal (not zero)
           bset *BitFlags70, #$%00000001    ; set bits
           bra  L931B          ; branch

   L92F2:  cmpb #0xfe          ;  -11111110-
           bne  L92FC          ; branch if not equal (not zero)
           bclr *DRBSerialMode, #bbe_FastSerial | bbe_TestType3 | bbe_TestType2    ; clear bits
           bclr *BitFlags70, #$%00000001    ; clear bits
   L92FC:  brset *BitFlags70, #$%00000001, L9308    ; branch if bit(s) set
           ldx  #0x0000         ; load index with value
           abx                 ; add b to index
           ldab 0x00, X        ; load b with memory at index + value
           bra  L931B          ; branch

   L9308:  ldaa FastDataOutputCommandByte    ; load a with memory contents (data is 10)
           cba             
           bhi  L9312          ; branch if higher
           ldab #0xff          ; load b with value -11111111-
           bra  L931B          ; branch

   L9312:  ldx  #FastDataOutputAddressTable    ; load index with value
           lslb            
           abx                 ; add b to index
           ldx  0x00, X    
           ldab 0x00, X        ; load b with memory at index + value
   L931B:  stab CPU_SerialData    ; store b into memory
   L931E:  jsr  CCDBusComs     ; call subroutine
           jsr  LB8A5          ; call subroutine
           ldaa CPU_A2DResults1    ; load a with memory contents
           brset *BitFlags6B, #$%00000100, L932F    ; branch if bit(s) set
           brclr *Counter_MainLoop, #$%00111111, L933E    ; branch if bit(s) clear
   L932F:  cmpa MapVolts_X     ; compare a with memory contents
           bcs  L9341          ; branch if lower
           cmpa MapValue_X     ; compare a with memory contents
           bls  L9344          ; branch if lower or same
           staa MapValue_X 
           bra  L9344          ; branch

   L933E:  staa MapValue_X 
   L9341:  staa MapVolts_X 
   L9344:  sei                 ; disable interrupts
           ldaa #0x80          ; load a with value -10000000-
           oraa CPU_TimerInterruptMask1
           staa CPU_TimerInterruptMask1
           rti                 ; return from interrupt

VerifyOperationOfBatteryVoltage_MM:
           brset *BitFlags70, #$%00000100, L93B9    ; branch if bit(s) set
           brset *b5D_IPL2, #$%00100000, L93B9    ; branch if bit(s) set
           brset *b5C_IPL1, #b5c_Bad_BatVolts, L93B9    ; branch if bit(s) set
           ldaa TargetBatteryVolts    ; load a with memory contents
           suba CPU_A2DResults2
           bcs  L93B9          ; branch if lower
           cmpa BTVLMT_BatteryVoltsDiagLimitOverTarget    ; compare a with memory contents (data is 10)
           bcs  L93B9          ; branch if lower
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa BTLRPM_LowBatteryVoltageAtThisRpm1500    ; compare a with memory contents (data is 2e)
           bcs  L93B9          ; branch if lower
           ldaa #0x0f          ; load a with value -00001111-
           brclr *BitFlags70, #$%00000010, L9374    ; branch if bit(s) clear
           clra                ; a = 0
   L9374:  anda Counter_MainLoop    ; logical and a with memory contents
           bne  L9390          ; branch if not equal (not zero)
           ldaa BatVoltsDiagCounter    ; load a with memory contents
           inca                ; increment a
           beq  L9381          ; branch if equal (zero)
           staa BatVoltsDiagCounter
   L9381:  brset *BitFlags70, #$%00000010, L9391    ; branch if bit(s) set
           cmpa BTVCNT_BatteryVoltsDiagCounterMax    ; compare a with memory contents (data is 8e)
           bcs  L9390          ; branch if lower
           clr  BatVoltsDiagCounter    ; zero byte at memory location
           bset *BitFlags70, #$%00000010    ; set bits
   L9390:  rts                 ; return from subroutine

   L9391:  brset *BitFlags70, #$%00001000, L93A1    ; branch if bit(s) set
           cmpa BTVCN2_BatteryVoltsDiagCounterMax2    ; compare a with memory contents (data is 7f)
           bcs  L9390          ; branch if lower
           clr  BatVoltsDiagCounter    ; zero byte at memory location
           bset *BitFlags70, #$%00001000    ; set bits
           rts                 ; return from subroutine

   L93A1:  cmpa BTVCN3_BatteryVoltsDiagCounterMin    ; compare a with memory contents (data is 06)
           bcs  L9390          ; branch if lower
           clr  BatVoltsDiagCounter    ; zero byte at memory location
           bclr *BitFlags70, #$%00001000    ; clear bits
           ldd  #0x058a        ; load d (a&b) with value -00000101 10001010-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  L9390          ; branch if greater or equal
           bset *b5D_IPL2, #$%00100000    ; set bits
           bra  L93BC          ; branch

   L93B9:  clr  BatVoltsDiagCounter    ; zero byte at memory location
   L93BC:  bclr *BitFlags70, #$%00001110    ; clear bits
           rts                 ; return from subroutine

HandleBaroReadRequirement_MM:
           brclr *BitFlags6D, #b6d_FuelEngineNotRunning, BaroRead_EngRunning    ; branch if bit(s) clear
           bset *PIA2_Buffer, #pi2_Baro    ; set bits
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
           bset *PIA2_Buffer, #pi2_Baro    ; set bits
           clra                ; a = 0
           staa Timer_BaroReadRpmConditionsSatisfied    ; store a into memory
           andb #0x5f          ;  -01011111-
           stab BitFlags68     ; store b into memory
           bclr *BitFlags6D, #b6d_BaroOkEngineStopped    ; clear bits
           rts                 ; return from subroutine

ReadBaroIfPossible:
           tstb            
           bmi  THROTTLE_HASNTCHANGED_STILLNOTPRESSED    ; branch if minus(hi bit 1)
           ldx  EngineRpm_HB
           cpx  BRPMHI_BaroReadHighRPM6650    ;  (data is cfd0)
           bhi  L9443          ; branch if higher
           cpx  BRPMLO_BaroReadLowRPM1800    ;  (data is 3840)
           bcs  L9443          ; branch if lower
           ldaa Timer_BaroReadRpmConditionsSatisfied    ; load a with memory contents
           inca                ; increment a
           beq  L9405          ; branch if equal (zero)
           staa Timer_BaroReadRpmConditionsSatisfied    ; store a into memory
           cmpa BRDLAY_BaroReadDelayAfterThrottleClosed2sec    ; compare a with memory contents (data is b5)
           bcs  L9443          ; branch if lower
   L9405:  ldaa Timer_BaroReadInterval    ; load a with memory contents
           cmpa BARTIM_BaroReadMinTimeBetweenReadings179sec    ; compare a with memory contents (data is 40)
           bcs  L9443          ; branch if lower
           bitb #0x20          ;  -00100000-
           bne  L9443          ; branch if not equal (not zero)
           bclr *PIA2_Buffer, #pi2_Baro    ; clear bits
           ldab #0x80          ; load b with value -10000000-
           bra  L942A          ; branch

THROTTLE_HASNTCHANGED_STILLNOTPRESSED:
           inc  Timer_BaroReadInterval
           bitb #0x20          ;  -00100000-
           bne  L942E          ; branch if not equal (not zero)
           ldaa Timer_BaroReadInterval    ; load a with memory contents
           cmpa BROPTM_BaroReadDelayAfterSolenoidOpenTenthSec    ; compare a with memory contents (data is 09)
           bcs  L9443          ; branch if lower
           ldab #b68_BaroSolEnergized          ; load b with value -00100000-
           bset *BitFlags6D, #b6d_BaroOkEngineStopped    ; set bits
   L942A:  orab BitFlags68 
           bra  L943E          ; branch

   L942E:  brset *BitFlags6D, #b6d_BaroOkEngineStopped, L9440    ; branch if bit(s) set
           bset *PIA2_Buffer, #pi2_Baro    ; set bits
           ldaa Timer_BaroReadInterval    ; load a with memory contents
           cmpa BRCLTM_BaroReadDelayAfterSolenoidClosedTenthSec    ; compare a with memory contents (data is 09)
           bcs  L9443          ; branch if lower
           andb #~b68_SparkEngineNotRunning          ;  -01111111-
   L943E:  stab BitFlags68     ; store b into memory
   L9440:  clra                ; a = 0
           staa Timer_BaroReadInterval    ; store a into memory
   L9443:  rts                 ; return from subroutine

SaveBaroPressure:
           jsr  ConvertMAPVoltsToValue    ; call subroutine
           tab                 ; b = a
           cmpb BAROHI_BaroReadValidHighLimit    ; compare b with memory contents (data is 85)
           bcc  L9452          ; branch if greater or equal
           cmpb BAROLO_BaroReadValidLowLimit    ; compare b with memory contents (data is 45)
           bcc  L9455          ; branch if greater or equal
   L9452:  ldab BARDFT_BaroReadDefaultValue    ; load b with memory contents (data is 7f)
   L9455:  stab BaroPressure    ; store b into memory
           rts                 ; return from subroutine

ControlAsdRelay_MM:
           ldaa DRBPointer1    ; load a with memory contents
           cmpa #0x18          ; compare a with value -00011000-
           bne  CONTROL_AUTOSHUTDOWN_RELAY_ROUTINE1    ; branch if not equal (not zero)
           ldaa DRBSerialMode    ; load a with memory contents
           bita #bbe_TestType3 | bbe_TestType2          ;  -00110000-
           bne  CONTROL_AUTOSHUTDOWN_RELAY_ROUTINE1    ; branch if not equal (not zero)
           ldaa TimerOverflowsBetweenCamPulses    ; load a with memory contents
           cmpa #0x50          ; compare a with value -01010000-
           bls  L949B          ; branch if lower or same
           brset *BitFlags70, #b70_O2Enable, L949B    ; branch if bit(s) set
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
           bne  L949E          ; branch if not equal (not zero)
           tst  Counter_MainLoop
           bne  L948E          ; branch if not equal (not zero)
           deca                ; decrement a
           beq  L94A1          ; branch if equal (zero)
           andb #0xf0          ;  -11110000-
           addb #0x10          ;  -00010000-
           aba                 ; a=a+b
           staa DRBPointer2    ; store a into memory
   L948E:  ldaa #0xe1          ; load a with value -11100001-
           jsr  SerialOutput1a    ; call subroutine
           ldx  #0xfe00        ; load index with value
           bset *BitFlags6C, #$%00000100    ; set bits
           bra  L94CB          ; branch

   L949B:  bclr *BitFlags70, #b70_O2Enable    ; clear bits
   L949E:  jsr  SerialOutput1    ; call subroutine
   L94A1:  clra                ; a = 0
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
           brset *BitFlags68, #b68_Past12secRunning, L94C7    ; branch if bit(s) set
           bcc  L94CB          ; branch if greater or equal
           cpx  #ClearTheErrorTimer_1    ;  -00000000 01011011-
           bne  L94CB          ; branch if not equal (not zero)
           ldab #0x17          ; load b with value -00010111-
           bra  L94CB          ; branch

   L94C7:  bcs  L94CB          ; branch if lower
           ldab #0x05          ; load b with value -00000101-
   L94CB:  ldaa PIA1_Buffer    ; load a with memory contents
           anda #~pi1_ASD          ; AND a with value -11101111-
           cmpb Counter_TimerPastHalfwayBetweenCamPulses
           bhi  L94D9          ; branch if higher
           cpx  KeyOnOrEngineRunningTime
           bhi  L94D9          ; branch if higher
           oraa #pi1_ASD          ;  -00010000-
   L94D9:  staa PIA1_Buffer    ; store a into memory
           brset *BitFlags6D, #b6d_FuelEngineNotRunning, L94E8    ; branch if bit(s) set
           ldab KeyOnOrEngineRunningTime    ; load b with memory contents
           cmpb #0x04          ;  -00000100-
           bcs  L94E8          ; branch if lower
           bset *BitFlags68, #b68_Past12secRunning    ; set bits
   L94E8:  rts                 ; return from subroutine

ControlAirConditioning_MM:
           clra                ; a = 0
           brset *BitFlags69, #$%00000100, L9522    ; branch if bit(s) set
           ldaa Counter_AirCond    ; load a with memory contents
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x3f          ;  -00111111-
           bne  L94FB          ; branch if not equal (not zero)
           cmpa #0x01          ; compare a with value -00000001-
           bls  L94FB          ; branch if lower or same
           deca                ; decrement a
   L94FB:  ldab TpsVolts       ; load b with memory contents
           brclr *PIA2_Buffer, #pi2_ACRelay, AIRCONDITIONING_CURRENTLY_OFF    ; branch if bit(s) clear
           addb #0x03          ;  -00000011-
AIRCONDITIONING_CURRENTLY_OFF:
           subb MINTHR_LowestSessionTPS    ; b = b-memory contents
           bls  L950C          ; branch if lower or same
           cmpb ACOUT_DeltaAboveMinThrottleToCutOutAc    ; compare b with memory contents (data is 8a)
           bhi  SHUTOFF_AIRCONDITIONING    ; branch if higher
   L950C:  ldx  EngineRpm_HB
           cpx  ACCRPM_DoNotAllowAcToEngageAboveThisRPM_4000    ;  (data is 7d00)
           bcc  L956B          ; branch if greater or equal
           cpx  TargetIdleSpeedHB
           bcc  L9548          ; branch if greater or equal
           cpx  ACLRPM_DisableAcBelowThisRPM_500    ;  (data is 0fa0)
           bhi  L9527          ; branch if higher
SHUTOFF_AIRCONDITIONING:
           tsta                ; test a
           bne  L9522          ; branch if not equal (not zero)
           ldaa ACCNTI_ACCounterInitial    ; load a with memory contents (data is 06)
   L9522:  bset *PIA2_Buffer, #pi2_ACRelay    ; set bits
           bra  L956B          ; branch

   L9527:  brclr *BitFlags6C, #$%00000010, L956B    ; branch if bit(s) clear
           brset *PIA2_Buffer, #pi2_ACRelay, L956B    ; branch if bit(s) set
           cpx  #0x1f40        ;  -00011111 01000000-
           bcc  L9522          ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x03          ;  -00000011-
           bne  L956B          ; branch if not equal (not zero)
           ldab Counter_ACControl1    ; load b with memory contents
           incb            
           stab Counter_ACControl1    ; store b into memory
           cmpb #0x5d          ;  -01011101-
           bcs  L956B          ; branch if lower
           bset *BitFlags6C, #$%00001000    ; set bits
           bra  L956B          ; branch

   L9548:  cmpa #0x01          ; compare a with value -00000001-
           bhi  L9522          ; branch if higher
           clra                ; a = 0
           brclr *BitFlags6C, #$%00000010, L9568    ; branch if bit(s) clear
           cpx  #0x1f40        ;  -00011111 01000000-
           bcc  L9522          ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x03          ;  -00000011-
           bne  L9568          ; branch if not equal (not zero)
           ldab Counter_ACControl1    ; load b with memory contents
           incb            
           stab Counter_ACControl1    ; store b into memory
           cmpb #0x5d          ;  -01011101-
           bcs  L9568          ; branch if lower
           bset *BitFlags6C, #$%00001000    ; set bits
   L9568:  bclr *PIA2_Buffer, #pi2_ACRelay    ; clear bits
   L956B:  staa Counter_AirCond    ; store a into memory
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
           bne  L95B5          ; branch if not equal (not zero)
           ldd  #0x0208        ; load d (a&b) with value -00000010 00001000-
           jsr  ThrowNonCriticalError    ; call subroutine
           ldaa #0xe3          ; load a with value -11100011-
           bra  L959B          ; branch

AmbientTempSensorValid:
           ldab #0x20          ; load b with value -00100000-
           mul                 ; multiply (d=a*b)
           adca #0xd1          ;  -11010001-
           cmpa #0xec          ; compare a with value -11101100-
           bcs  L9595          ; branch if lower
           ldaa #0xec          ; load a with value -11101100-
   L9595:  cmpa #0xd8          ; compare a with value -11011000-
           bcc  L959B          ; branch if greater or equal
           ldaa #0xd8          ; load a with value -11011000-
   L959B:  staa Temp0          ; store a into memory
           ldab BodyComputerBatteryVoltsOutput    ; load b with memory contents
           addb #0xf8          ;  -11111000-
           bcs  L95A8          ; branch if lower
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           bra  L95B3          ; branch

   L95A8:  cmpb #0x08          ;  -00001000-
           bhi  L95B3          ; branch if higher
           mul                 ; multiply (d=a*b)
           adca Temp0      
           bcc  L95B3          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   L95B3:  staa TargetBatteryVolts    ; store a into memory
   L95B5:  rts                 ; return from subroutine

ControlFan_MM:
           brclr *BitFlags6D, #b6d_FuelEngineNotRunning, PreventRadSteaming    ; branch if bit(s) clear
           jmp  TurnFanOffByTimer

PreventRadSteaming:
           ldab PIA1_Buffer    ; load b with memory contents
           ldaa Timer_RadSteamingCountdown    ; load a with memory contents
           beq  L95DC          ; branch if equal (zero)
           ldaa CoolantTemp    ; load a with memory contents
           cmpa #0xd2          ; compare a with value -11010010-
           bcs  L95DC          ; branch if lower
           ldaa Counter_MainLoop    ; load a with memory contents
           cmpa #0x09          ; compare a with value -00001001-
           bne  L95D2          ; branch if not equal (not zero)
           dec  Timer_RadSteamingCountdown    ; decrement memory contents
   L95D2:  clra                ; a = 0
           bitb #pi1_Fan          ;  -00100000-
           bne  L95D8          ; branch if not equal (not zero)
           inca                ; increment a
   L95D8:  cmpa VehicleSpeed_HB    ; compare a with memory contents
           bcc  TurnFanOn      ; branch if greater or equal
   L95DC:  brset *b5C_IPL1, #b5c_BadCoolantTemp, TurnFanOn    ; branch if bit(s) set
           ldx  #FANTMP1_FanTurnOnTempAbove45Mph    ; load index with value
           ldaa VehicleSpeed_HB    ; load a with memory contents
           cmpa #0x0b          ; compare a with value -00001011-
           bcc  Above44MPH     ; branch if greater or equal
           cmpa #0x09          ; compare a with value -00001001-
           bcs  Below36MPH     ; branch if lower
           brset *BitFlags68, #b68_SpeedOver40, L95FB    ; branch if bit(s) set
Below36MPH:
           inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
           bclr *BitFlags68, #b68_SpeedOver40    ; clear bits
           bra  L95FB          ; branch

Above44MPH:
           bset *BitFlags68, #b68_SpeedOver40    ; set bits
   L95FB:  ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 97)
           bita #0x80          ;  -10000000-
           beq  L9606          ; branch if equal (zero)
           brclr *BitFlags_AIS, #$%01000000, TurnFanOn    ; branch if bit(s) clear
   L9606:  bitb #0x20          ;  -00100000-
           bne  L960B          ; branch if not equal (not zero)
           inx                 ; increment index (x=x+1)
   L960B:  ldaa 0x00, X        ; load a with memory at index + value
           cmpa CoolantTemp    ; compare a with memory contents
           bcs  TurnFanOn      ; branch if lower
           ldaa BaroPressure    ; load a with memory contents
           adda FANMAP_FanTurnsOnWhenMapAboveBaroPlusThis    ;  (data is ff)
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
           bne  L9631          ; branch if not equal (not zero)
           deca                ; decrement a
           deca                ; decrement a
   L9631:  cmpa FANBAT_FanTurnsOnWhenBatteryTempAboveThis    ; compare a with memory contents (data is 1b)
           bcc  TurnFanOffByTimer    ; branch if greater or equal
TurnFanOn:
           brset *BitFlags68, #b68_SparkEngineNotRunning, L966E    ; branch if bit(s) set
           brclr *PIA1_Buffer, #pi1_Fan, L966E    ; branch if bit(s) clear
           andb #0xdf          ;  -11011111-
           ldaa #0x5b          ; load a with value -01011011-
           staa Timer_MinimumFanRun    ; store a into memory
           ldaa AISFAN_AisKickWhenFanTurnsOnClosedThrottle    ; load a with memory contents (data is 08)
           beq  L966C          ; branch if equal (zero)
           adda DesiredNewAisPosition
           bcs  L9652          ; branch if lower
           cmpa AISHLM_AisHighLimitMaxOpenSteps    ; compare a with memory contents (data is a0)
           bls  L9655          ; branch if lower or same
   L9652:  ldaa AISHLM_AisHighLimitMaxOpenSteps    ; load a with memory contents (data is a0)
   L9655:  staa DesiredNewAisPosition    ; store a into memory
           clra                ; a = 0
           staa Timer_AisChanges    ; store a into memory
           bra  L966C          ; branch

TurnFanOffByTimer:
           ldaa Timer_MinimumFanRun    ; load a with memory contents
           beq  TurnFanOff     ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_MinimumFanRun    ; store a into memory
           rts                 ; return from subroutine

TurnFanOff:
           ldab PIA1_Buffer    ; load b with memory contents
           orab #pi1_Fan          ;  -00100000-
           brset *BitFlags68, #b68_SparkEngineNotRunning, L966E    ; branch if bit(s) set
   L966C:  stab PIA1_Buffer    ; store b into memory
   L966E:  rts                 ; return from subroutine

CalculateAisPosition_MM:
           ldaa BitFlags6D     ; load a with memory contents
           oraa BitFlags66     ; OR a with memory contents
           bmi  L967D          ; branch if minus(hi bit 1)
           ldaa b5C_IPL1       ; load a with memory contents
           anda #b5c_MapStuck | b5c_MapBadSignal          ; AND a with value -10100000-
           oraa TimerOverflowsBetweenCamPulses    ; OR a with memory contents
           beq  L967E          ; branch if equal (zero)
   L967D:  rts                 ; return from subroutine

   L967E:  ldaa Timer_DacalCountdown    ; load a with memory contents
           lsra            
           lsra            
           adda DANOM_Base_nominalCal    ;  (data is 05)
           bcc  L9689          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-

   L9689:  ldab DistributorFallingEdgePulsewidth_HB    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           asld                ; shift left (d=d*2)
           bcs  L9692          ; branch if lower
           asld                ; shift left (d=d*2)
           bcc  L9694          ; branch if greater or equal
   L9692:  ldaa #0xff          ; load a with value -11111111-
   L9694:  staa TempX    ; store a into memory
           ldx  #TIMEDC_AISDecelBaseAirflowCurveOffset    ; load index with value
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp0          ; store a into memory
           ldx  #TEMPDC_AISDecel_FromTemp    ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           adda Temp0      
           bcs  L96B5          ; branch if lower
           brset *PIA2_Buffer, #pi2_ACRelay, L96B7    ; branch if bit(s) set
           adda DAACF_ACFactorDeltaFromBase    ;  (data is 12)
           bcc  L96B7          ; branch if greater or equal
   L96B5:  ldaa #0xff          ; load a with value -11111111-
   L96B7:  ldab DistributorFallingEdgePulsewidth_HB    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           asld                ; shift left (d=d*2)
           bcs  L96C0          ; branch if lower
           asld                ; shift left (d=d*2)
           bcc  L96C2          ; branch if greater or equal
   L96C0:  ldaa #0xff          ; load a with value -11111111-
   L96C2:  staa Temp0          ; store a into memory
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
           bcs  L96EB          ; branch if lower
           staa Temp0          ; store a into memory
           ldx  #BARFLR_OffsetCorrectionTo_MAPFLR_FromBaro    ; load index with value
           ldaa BaroPressure    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           adda Temp0      
           bcc  L96ED          ; branch if greater or equal
   L96EB:  ldaa #0xff          ; load a with value -11111111-
   L96ED:  adda TempX
           bcc  L96F3          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   L96F3:  staa MAPOffsetForCylTrim
           brclr *BitFlags67, #b67_FallToIdle, L96FC    ; branch if bit(s) clear
           staa TempX    ; store a into memory
   L96FC:  ldaa TempX    ; load a with memory contents
           ldab Timer_CountdownFromStartRunForAisFeedback    ; load b with memory contents
           bne  L977D          ; branch if not equal (not zero)
           brset *BitFlags67, #b67_IdleSpeedMode, L977D    ; branch if bit(s) set
           brset *BitFlags_AIS, #$%10000000, L977D    ; branch if bit(s) set
           brset *BitFlags67, #b67_FallToIdle, L977E    ; branch if bit(s) set
           ldab CONFIG_ConfigurationFlags    ; load b with memory contents (data is 97)
           bitb #0x20          ;  -00100000-
           beq  L9719          ; branch if equal (zero)
           brclr *StartupSwitchMirror1, #sw1_PNswitch, L977D    ; branch if bit(s) clear
   L9719:  ldab KeyOnOrEngineRunningTime    ; load b with memory contents
           cmpb DCALTM_DacalInhibitTimeAfterStartup    ; compare b with memory contents (data is 15)
           bcs  L977D          ; branch if lower
           brclr *PIA2_Buffer, #pi2_ACRelay, L977D    ; branch if bit(s) clear
           ldab CoolantTemp    ; load b with memory contents
           cmpb DATHOT_EngineTempToStartCalibratingDacal    ; compare b with memory contents (data is ca)
           bls  L977D          ; branch if lower or same
           ldab Counter_MainLoop    ; load b with memory contents
           bitb DCALRT_DacalUpdateRate01_03_07_0f_1f_3f_7f_ff    ;  (data is 3f)
           bne  L974D          ; branch if not equal (not zero)
           ldab TargetIdleSpeedHB    ; load b with memory contents
           subb EngineRpm_HB    ; b = b-memory contents
           bcc  L9739          ; branch if greater or equal
           negb            
   L9739:  cmpb DADRPM_DeltaRpmFromIdleSpeedForDacalUpdate    ; compare b with memory contents (data is 04)
           bhi  L974D          ; branch if higher
           ldab Timer_DacalCountdown    ; load b with memory contents
           cmpa MapValue       ; compare a with memory contents
           bhi  L9747          ; branch if higher
           incb            
           bne  L974B          ; branch if not equal (not zero)
   L9747:  tstb            
           beq  L974D          ; branch if equal (zero)
           decb            
   L974B:  stab Timer_DacalCountdown    ; store b into memory
   L974D:  ldab Counter_MainLoop    ; load b with memory contents
           bitb CALRAT_AisAdjustRate    ;  (data is 07)
           bne  L977D          ; branch if not equal (not zero)
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  L975F          ; branch if greater or equal
           coma            
           comb            
           addd #0x0001         ;  -00000000 00000001-
   L975F:  asld                ; shift left (d=d*2)
           bcs  L977D          ; branch if lower
           asld                ; shift left (d=d*2)
           bcs  L977D          ; branch if lower
           cmpa #0x0a          ; compare a with value -00001010-
           bcc  L977D          ; branch if greater or equal
           ldaa DesiredNewAisPosition    ; load a with memory contents
           cmpa CurrentAisPosition    ; compare a with memory contents
           bne  L977D          ; branch if not equal (not zero)
           cmpa CALPOS_PositionAisMotorIsAtIdle    ; compare a with memory contents (data is 1a)
           beq  L977D          ; branch if equal (zero)
           bhi  L9778          ; branch if higher
           inca                ; increment a
           inca                ; increment a
   L9778:  deca                ; decrement a
           staa DesiredNewAisPosition    ; store a into memory
           staa CurrentAisPosition    ; store a into memory
   L977D:  rts                 ; return from subroutine

   L977E:  ldab Timer_AisChanges    ; load b with memory contents
           cmpb DCLRFQ_TimeBetweenAisPulsesForDecelAis    ; compare b with memory contents (data is 14)
           bcs  L977D          ; branch if lower
           cmpa DCLMIN_MinLimitOnDecelAisControlledMap    ; compare a with memory contents (data is 01)
           bcc  L978D          ; branch if greater or equal
           ldaa DCLMIN_MinLimitOnDecelAisControlledMap    ; load a with memory contents (data is 01)
   L978D:  cmpa DCLMN2_NoAisControlIfMapAndControlMapBelowThis    ; compare a with memory contents (data is 15)
           bcc  L9799          ; branch if greater or equal
           ldab MapValue       ; load b with memory contents
           cmpb DCLMN2_NoAisControlIfMapAndControlMapBelowThis    ; compare b with memory contents (data is 15)
           bcs  L977D          ; branch if lower
   L9799:  ldx  #DAISOP_DecelAisOpenStepsFromNeg_FromDeltaMap    ; load index with value
           suba MapValue   
           bcc  L97A4          ; branch if greater or equal
           nega                ; negate a (set high bit)
           ldx  #DAISCL_DecelAisOpenStepsFromPos_FromDeltaMap    ; load index with value
   L97A4:  jsr  Lookup4ByteTable    ; call subroutine
           jsr  StoreAndLimitDesiredAisPosition    ; call subroutine
           cmpa CurrentAisPosition    ; compare a with memory contents
           beq  L977D          ; branch if equal (zero)
           clra                ; a = 0
           staa Timer_AisChanges    ; store a into memory
           rts                 ; return from subroutine

KickUpAisBy2DuringDecel_MM:
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x7f          ;  -01111111-
           bne  L97D3          ; branch if not equal (not zero)
           brset *BitFlags67, #b67_FallToIdle, L97D3    ; branch if bit(s) set
           brset *b5C_IPL1, #b5c_MapStuck, L97D3    ; branch if bit(s) set
           brset *b5C_IPL1, #b5c_MapBadSignal, L97D3    ; branch if bit(s) set
           ldaa DesiredNewAisPosition    ; load a with memory contents
           oraa CurrentAisPosition    ; OR a with memory contents
           bne  L97D3          ; branch if not equal (not zero)
           adda #0x02          ;  -00000010-
           staa DesiredNewAisPosition    ; store a into memory
           staa CurrentAisPosition    ; store a into memory
           bset *BitFlags68, #b68_ASDon    ; set bits
   L97D3:  rts                 ; return from subroutine

CalculateTargetIdleSpeedAndAisPosition_MM:
           brset *BitFlags_AIS, #b10_ATXInGear, L9821    ; branch if bit(s) set
           brset *BitFlags6D, #b6d_FuelEngineNotRunning, L9811    ; branch if bit(s) set
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa DCLMER_MinTimeEngineRunningForDecelFuelShutoff    ; compare a with memory contents (data is 02)
           bls  L9811          ; branch if lower or same
           ldaa CoolantTemp    ; load a with memory contents
           cmpa DCLMCT_MinCoolantTempForDecelFuelShutoff    ; compare a with memory contents (data is d2)
           bls  L9811          ; branch if lower or same
           brset *BitFlags66, #b66_OffIdle, L9811    ; branch if bit(s) set
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           cmpa MPHREF_SwitchPointForDecelIdleAisControl    ; compare a with memory contents (data is 07)
           bcc  L9811          ; branch if greater or equal
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  L9802          ; branch if greater or equal
           clra                ; a = 0
   L9802:  brclr *BitFlags6B, #b6b_DecelFuelCut, L9816    ; branch if bit(s) clear
           cmpa DCLRPL_EngineRPMLimitForDecelFuelShutoffLow    ; compare a with memory contents (data is 0f)
           bhi  L981B          ; branch if higher
           ldaa DCAISI_AISIncrementWhenUsingDecelFuelShut    ; load a with memory contents (data is 00)
           jsr  ClearAisTimer    ; call subroutine
   L9811:  bclr *BitFlags6B, #b6b_DecelFuelCut    ; clear bits
           bra  L9821          ; branch

   L9816:  cmpa DCLRPH_EngineRPMLimitForDecelFuelShutoffHigh    ; compare a with memory contents (data is 11)
           bls  L9811          ; branch if lower or same
   L981B:  bset *BitFlags6B, #b6b_DecelFuelCut    ; set bits
           clr  Timer_CountdownFromStartRunForAisFeedback    ; zero byte at memory location
   L9821:  ldaa BaroPressure    ; load a with memory contents
           ldx  #BARAIS_AISBaroCompensation    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp1          ; store a into memory
           brclr *BitFlags_AIS, #b10_ATXChngGear, L9832    ; branch if bit(s) clear
           jmp  L98BA

   L9832:  ldx  #AISCLD_IdleSpeedDrive_FromTemp    ; load index with value
           brset *BitFlags_AIS, #b10_ATXInGear, L986B    ; branch if bit(s) set
           ldaa DRBPointer1    ; load a with memory contents
           cmpa #0x19          ; compare a with value -00011001-
           beq  L984A          ; branch if equal (zero)
           brclr *TargetIdleSpeedLB, #$%00111111, L9857    ; branch if bit(s) clear
           ldd  TargetIdleSpeedHB    ; load d (a&b) with memory contents
           subd #0x0001         ;  -00000000 00000001-
           bra  L98B8          ; branch

   L984A:  brset *DRBSerialMode, #bbe_TestType3, L98BA    ; branch if bit(s) set
           clr  DRBPointer1    ; zero byte at memory location
           ldaa DRBPointer2    ; load a with memory contents
           ldab #0xfc          ; load b with value -11111100-
           bra  L98B6          ; branch

   L9857:  ldaa IDLDEF_TargetIdleSpeedDefault    ; load a with memory contents (data is 7d)
           brset *b5C_IPL1, #b5c_BadCoolantTemp, L98B5    ; branch if bit(s) set
           brset *BitFlags6C, #$%00100000, L98B5    ; branch if bit(s) set
           ldaa #0x30          ; load a with value -00110000-
           brset *BitFlags6C, #b6c_DRBModeFlag, L98B5    ; branch if bit(s) set
           ldx  #AISPN_IdleSpeedParkNeutral_FromTemp    ; load index with value
   L986B:  ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp0          ; store a into memory
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           ldx  #TIMED2_AISDecelBaseAirflowCurveOffset2    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           adda Temp0      
           bcc  L9880          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   L9880:  brclr *BitFlags67, #b67_IdleSpeedMode, L989C    ; branch if bit(s) clear
           ldab Counter_MainLoop    ; load b with memory contents
           andb DECAIS_RollingAisUpdateRate_01_03_07_0f_1f_3f_7f_ff    ;  (data is 7f)
           bne  L98BA          ; branch if not equal (not zero)
           staa Temp0          ; store a into memory
           ldd  TargetIdleSpeedHB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           suba ISPDCY_RollingAisDecay    ;  (data is 04)
           bcs  L989A          ; branch if lower
           cmpa Temp0          ; compare a with memory contents
           bcc  L989C          ; branch if greater or equal
   L989A:  ldaa Temp0          ; load a with memory contents
   L989C:  brclr *BitFlags_AIS, #$%00000010, L98B5    ; branch if bit(s) clear
           brset *BitFlags6D, #b6d_FuelEngineNotRunning, L98B5    ; branch if bit(s) set
           ldx  KeyOnOrEngineRunningTime
           cpx  #0x0744        ;  -00000111 01000100-
           bls  L98B5          ; branch if lower or same
           brset *BitFlags68, #$%01000000, L98B5    ; branch if bit(s) set
           cmpa #0x77          ; compare a with value -01110111-
           bls  L98B5          ; branch if lower or same
           ldaa #0x77          ; load a with value -01110111-
   L98B5:  clrb                ; b = 0
   L98B6:  lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
   L98B8:  stD *TargetIdleSpeedHB    ; store D to RAM
   L98BA:  ldaa DRBPointer1    ; load a with memory contents
           cmpa #0x13          ; compare a with value -00010011-
           bne  L98CB          ; branch if not equal (not zero)
           ldaa ATMOffset      ; load a with memory contents
           cmpa #0x07          ; compare a with value -00000111-
           beq  L98CA          ; branch if equal (zero)
           cmpa #0x14          ; compare a with value -00010100-
           bne  L98CB          ; branch if not equal (not zero)
   L98CA:  rts                 ; return from subroutine

   L98CB:  brset *BitFlags_AIS, #$%00010000, L98E5    ; branch if bit(s) set
           brclr *BitFlags6D, #b6d_FuelEngineNotRunning, L98E0    ; branch if bit(s) clear
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa RPMTHS_RPMThresholdForIdleControl    ; compare a with memory contents (data is 10)
           bcc  L98E0          ; branch if greater or equal
           ldaa RPMDEF_RPMDefaultForIdleControl    ; load a with memory contents (data is a0)
           jmp  L9BD5      

   L98E0:  bset *BitFlags_AIS, #$%00010000    ; set bits
           bra  L98F8          ; branch

   L98E5:  ldab BitFlags_AIS    ; load b with memory contents
           orab BitFlags6D 
           bpl  L9909          ; branch if plus (hi bit 0)
           ldaa DesiredNewAisPosition    ; load a with memory contents
           cmpa CurrentAisPosition    ; compare a with memory contents
           bne  L98F8          ; branch if not equal (not zero)
           brset *BitFlags_AIS, #b10_UseAIS, L98F8    ; branch if bit(s) set
           bclr *BitFlags_AIS, #$%10000000    ; clear bits
   L98F8:  bset *BitFlags_AIS, #$%01000000    ; set bits
           bset *BitFlags69, #$%00000100    ; set bits
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #AISTRT_AisStartupPosition_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           jmp  L9BD5      

   L9909:  brclr *b5C_IPL1, #b5c_MapStuck | b5c_MapBadSignal, HandleAcCutout    ; branch if bit(s) clear
           ldaa #0x20          ; load a with value -00100000-
           staa DesiredNewAisPosition    ; store a into memory
           brclr *BitFlags68, #$%01000000, L9919    ; branch if bit(s) clear
           bset *BitFlags69, #$%00000100    ; set bits
           rts                 ; return from subroutine

   L9919:  bclr *BitFlags69, #$%00000100    ; clear bits
           rts                 ; return from subroutine

HandleAcCutout:
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa ACCTIM_AcDelayFromStartRunTransfer    ; compare a with memory contents (data is 04)
           bcs  L9996          ; branch if lower
           ldaa Timer_AcCutout    ; load a with memory contents
           bne  L9952          ; branch if not equal (not zero)
           ldaa CoolantTemp    ; load a with memory contents
           cmpa ACDTMP_PartThrottleAcCutoutDisableTemp    ; compare a with memory contents (data is ff)
           bcs  L9978          ; branch if lower
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bcs  L9978          ; branch if lower
           cmpa ACDTHR_PartThrottleAcCutoutDisableThrottle    ; compare a with memory contents (data is ff)
           bcs  L9978          ; branch if lower
           ldx  VehicleSpeed_HB
           cpx  ACDSPD_PartThrottleAcCutoutDisableSpeed    ;  (data is 0000)
           bcc  L9978          ; branch if greater or equal
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb ACERPM_AllowAcClutchAboveThisRpm    ; compare b with memory contents (data is 44)
           bcc  L9978          ; branch if greater or equal
           inc  Timer_AcCutout
           brset *BitFlags_AIS, #$%01000000, L9996    ; branch if bit(s) set
           jmp  L9A32      

   L9952:  ldx  VehicleSpeed_HB
           cpx  ACESPD_AllowAcClutchAboveThisSpeed    ;  (data is 0500)
           bcc  L9975          ; branch if greater or equal
           ldab EngineRpm_HB    ; load b with memory contents
           subb #0x04          ;  -00000100-
           bcc  L9960          ; branch if greater or equal
           clrb                ; b = 0
   L9960:  cmpb ACERPM_AllowAcClutchAboveThisRpm    ; compare b with memory contents (data is 44)
           bcc  L9975          ; branch if greater or equal
           cmpa ACETIM_PartThrottleAcCutoutMaxTimeActive    ; compare a with memory contents (data is 08)
           bcc  L9975          ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x3f          ;  -00111111-
           bne  L9996          ; branch if not equal (not zero)
           inca                ; increment a
           staa Timer_AcCutout    ; store a into memory
           bra  L9996          ; branch

   L9975:  clra                ; a = 0
           staa Timer_AcCutout    ; store a into memory
   L9978:  ldab BitFlags_AIS    ; load b with memory contents
           eorb BitFlags68 
           andb #0x40          ;  -01000000-
           beq  L9999          ; branch if equal (zero)
           eorb BitFlags_AIS
           bitb #0x40          ;  -01000000-
           beq  L9989          ; branch if equal (zero)
           jmp  L9A32      

   L9989:  ldaa Pulsewidth_PartThrottleEnrichment_HB    ; load a with memory contents
           bne  L9991          ; branch if not equal (not zero)
           ldaa Pulsewidth_PartThrottleEnrichment_LB    ; load a with memory contents
           beq  L99FF          ; branch if equal (zero)
   L9991:  ldaa ACAETH_DisallowAcClutchEngageForThisTimeAfterAccelEnrich    ; load a with memory contents (data is d6)
           staa Timer_AcClutchEngageRestrictionTimer    ; store a into memory
   L9996:  jmp  L9A77      

   L9999:  stab Timer_AcClutchEngageRestrictionTimer    ; store b into memory
           brset *BitFlags_AIS, #$%01000000, L99BE    ; branch if bit(s) set
           ldaa Timer_AisOrO2Sensor    ; load a with memory contents
           bne  L99A6          ; branch if not equal (not zero)
   L99A3:  jmp  L9A6F      

   L99A6:  clrb                ; b = 0
           stab Timer_AisChanges    ; store b into memory
           deca                ; decrement a
           staa Timer_AisOrO2Sensor    ; store a into memory
           bne  L9996          ; branch if not equal (not zero)
           brset *BitFlags66, #b66_OffIdle, L99A3    ; branch if bit(s) set
           ldaa AC2KCK_AcClutchKickOpenAfterAcEnabled    ; load a with memory contents (data is 00)
           jsr  MultiplyTempvar1ByA_Pos    ; call subroutine
           jsr  StoreAndLimitDesiredAisPosition    ; call subroutine
           jmp  L9A6F      

   L99BE:  ldaa Timer_AisOrO2Sensor    ; load a with memory contents
           beq  L9996          ; branch if equal (zero)
           clrb                ; b = 0
           stab Timer_AisChanges    ; store b into memory
           deca                ; decrement a
           staa Timer_AisOrO2Sensor    ; store a into memory
           bne  L99A3          ; branch if not equal (not zero)
           brset *BitFlags66, #b66_OffIdle, L99E7    ; branch if bit(s) set
           ldaa MapValue       ; load a with memory contents
           cmpa DCLMN2_NoAisControlIfMapAndControlMapBelowThis    ; compare a with memory contents (data is 15)
           bls  L99DA          ; branch if lower or same
           ldaa AC3KCK_AcClutchKickOpenAfterAcEnabled2    ; load a with memory contents (data is 00)
           bra  L99DE          ; branch

   L99DA:  ldaa AC2KCK_AcClutchKickOpenAfterAcEnabled    ; load a with memory contents (data is 00)
           nega                ; negate a (set high bit)
   L99DE:  jsr  MultiplyTempvar1ByA_Neg    ; call subroutine
           jsr  StoreAndLimitDesiredAisPosition    ; call subroutine
           jmp  L9A77      

   L99E7:  ldx  #ACCTBL_ACOffIdleDelta_FromSpeed    ; load index with value
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    ; call subroutine
           ldab OFFPER2_AisInstantlyClosesWhenAcDisengages2    ; load b with memory contents (data is 80)
           mul                 ; multiply (d=a*b)
           jsr  MultiplyTempvar1ByA_Pos    ; call subroutine
           nega                ; negate a (set high bit)
           jsr  L9C47          ; call subroutine
           bra  L9A77          ; branch

   L99FF:  ldaa Timer_AcClutchEngageRestrictionTimer    ; load a with memory contents
           beq  L9A08          ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_AcClutchEngageRestrictionTimer    ; store a into memory
           bne  L9A77          ; branch if not equal (not zero)
   L9A08:  stab BitFlags_AIS    ; store b into memory
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           ldab ACTIME_TimeBeforeAcEnabledAndFullDeltaUsed    ; load b with memory contents (data is 16)
           cmpa MPHREF_SwitchPointForDecelIdleAisControl    ; compare a with memory contents (data is 07)
           bhi  L9A21          ; branch if higher
           brset *BitFlags66, #b66_OffIdle, L9A21    ; branch if bit(s) set
           ldab ACTDEF_TimeBeforeAcEnabledAndFullDeltaUsed_Default    ; load b with memory contents (data is 16)
   L9A21:  stab Timer_AisOrO2Sensor    ; store b into memory
           brset *BitFlags66, #b66_OffIdle, L9A74    ; branch if bit(s) set
           ldaa ACOFFK_ClosedThrottleAcOffKick    ; load a with memory contents (data is 10)
           jsr  MultiplyTempvar1ByA_Pos    ; call subroutine
           jsr  ClearAisTimer    ; call subroutine
           bra  L9A77          ; branch

   L9A32:  bset *BitFlags_AIS, #$%01000000    ; set bits
           ldaa ACTIM2_TimeBeforeAcEnabledAndFullDeltaUsed2    ; load a with memory contents (data is 16)
           staa Timer_AisOrO2Sensor    ; store a into memory
           brset *BitFlags66, #b66_OffIdle, L9A56    ; branch if bit(s) set
           ldaa MapValue       ; load a with memory contents
           cmpa DCLMN2_NoAisControlIfMapAndControlMapBelowThis    ; compare a with memory contents (data is 15)
           bls  L9A4A          ; branch if lower or same
           ldaa AC4KCK_AcClutchKickOpenBeforeAcEnabled2    ; load a with memory contents (data is f2)
           bra  L9A4E          ; branch

   L9A4A:  ldaa ACOFFK_ClosedThrottleAcOffKick    ; load a with memory contents (data is 10)
           nega                ; negate a (set high bit)
   L9A4E:  jsr  MultiplyTempvar1ByA_Neg    ; call subroutine
           jsr  ClearAisTimer    ; call subroutine
           bra  L9A6F          ; branch

   L9A56:  ldx  #ACCTBL_ACOffIdleDelta_FromSpeed    ; load index with value
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    ; call subroutine
           ldab OFFPER_AisInstantlyClosesWhenAcDisengages    ; load b with memory contents (data is 80)
           mul                 ; multiply (d=a*b)
           jsr  MultiplyTempvar1ByA_Pos    ; call subroutine
           nega                ; negate a (set high bit)
           jsr  L9C47          ; call subroutine
           clra                ; a = 0
           staa Timer_AisChanges    ; store a into memory
   L9A6F:  bclr *BitFlags69, #$%00000100    ; clear bits
           bra  L9A7A          ; branch

   L9A74:  clra                ; a = 0
           staa Timer_AisChanges    ; store a into memory
   L9A77:  bset *BitFlags69, #$%00000100    ; set bits
   L9A7A:  brclr *BitFlags66, #b66_OffIdle, L9A93    ; branch if bit(s) clear
           bclr *BitFlags_AIS, #b10_ATXChngGear    ; clear bits
           brclr *StartupSwitchMirror1, #sw1_Brake, L9A97    ; branch if bit(s) clear
           ldx  #BRKRPM_BrakeOverrideForAis_FromDeltaThrottle    ; load index with value
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           jsr  Lookup4ByteTable    ; call subroutine
           cmpb EngineRpm_HB
           bcc  L9A97          ; branch if greater or equal
   L9A93:  brclr *BitFlags69, #b69_AtIdle, L9A9A    ; branch if bit(s) clear
   L9A97:  jmp  L9B5C      

   L9A9A:  brclr *BitFlags67, #b67_FallToIdle, L9A9F    ; branch if bit(s) clear
           rts                 ; return from subroutine

   L9A9F:  ldaa DesiredNewAisPosition    ; load a with memory contents
           cmpa #0x04          ; compare a with value -00000100-
           bcs  L9AA8          ; branch if lower
           bclr *BitFlags68, #b68_ASDon    ; clear bits
   L9AA8:  brclr *BitFlags_AIS, #b10_ATXChngGear, L9ADD    ; branch if bit(s) clear
           brclr *BitFlags_AIS, #b10_ATXInGear, L9AB9    ; branch if bit(s) clear
           ldx  #PNDLTP_DeltaRpmChangeToUse_DRPNK_or_PNDRK    ; load index with value
           ldd  TargetIdleSpeedHB    ; load d (a&b) with memory contents
           subd EngineRpm_HB    ; d = d - memory contents
           bra  L9AC0          ; branch

   L9AB9:  ldx  #PNDLTN_DeltaRpmChangeToUse_DRPNK_or_PNDRK    ; load index with value
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
   L9AC0:  bcs  L9ADD          ; branch if lower
           subd 0x00, X    
           bcs  L9ADD          ; branch if lower
           ldaa CoolantTemp    ; load a with memory contents
           inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
           jsr  Lookup4ByteTable    ; call subroutine
           bmi  L9AD4          ; branch if minus(hi bit 1)
           jsr  MultiplyTempvar1ByA_Pos    ; call subroutine
           bra  L9AD7          ; branch

   L9AD4:  jsr  MultiplyTempvar1ByA_Neg    ; call subroutine
   L9AD7:  jsr  ClearAisTimer    ; call subroutine
           bclr *BitFlags_AIS, #b10_ATXChngGear    ; clear bits
   L9ADD:  ldaa Timer_CountdownFromStartRunForAisFeedback    ; load a with memory contents
           bne  L9B5B          ; branch if not equal (not zero)
           ldab AISFRQ_AisPeriodForRpmFeedback11ms    ; load b with memory contents (data is 82)
           cmpb Timer_AisChanges
           bcc  L9B1B          ; branch if greater or equal
           ldx  #FWDAIS_ForwardAisSteps_NoSlope    ; load index with value
           ldd  TargetIdleSpeedHB    ; load d (a&b) with memory contents
           subd EngineRpm_HB    ; d = d - memory contents
           bcc  L9AF6          ; branch if greater or equal
           ldx  #REVAIS_ReverseAisSteps_NoSlope    ; load index with value
           coma            
           comb            
   L9AF6:  lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           brset *BitFlags_AIS, #b10_ATXInGear, L9AFD    ; branch if bit(s) set
           lsrd                ; shift right (d=d/2)
   L9AFD:  tsta                ; test a
           beq  L9B02          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   L9B02:  tba                 ; a = b
           cmpa 0x01, X        ; compare a with memory at index + value
           bcs  L9B1B          ; branch if lower
           ldab 0x00, X        ; load b with memory at index + value
           beq  L9B1B          ; branch if equal (zero)
   L9B0B:  inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
           decb            
           beq  L9B14          ; branch if equal (zero)
           cmpa 0x01, X        ; compare a with memory at index + value
           bcc  L9B0B          ; branch if greater or equal
   L9B14:  ldaa 0x00, X        ; load a with memory at index + value
           beq  L9B1B          ; branch if equal (zero)
           jsr  ClearAisTimer    ; call subroutine
   L9B1B:  brclr *BitFlags67, #b67_IdleSpeedMode, L9B5B    ; branch if bit(s) clear
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #CLDPOS_AisColdPosition_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           brset *BitFlags68, #b68_ASDon, L9B30    ; branch if bit(s) set
           adda CALPOS_PositionAisMotorIsAtIdle    ;  (data is 1a)
           bcs  L9B3E          ; branch if lower
   L9B30:  brset *BitFlags_AIS, #$%01000000, L9B40    ; branch if bit(s) set
           adda ACOFFK_ClosedThrottleAcOffKick    ;  (data is 10)
           bcs  L9B3E          ; branch if lower
           adda AC2KCK_AcClutchKickOpenAfterAcEnabled    ;  (data is 00)
           bcc  L9B40          ; branch if greater or equal
   L9B3E:  ldaa #0xff          ; load a with value -11111111-
   L9B40:  staa Temp0          ; store a into memory
           adda AISLMH_RollingAisHighLimit    ;  (data is 1a)
           bcs  L9B4B          ; branch if lower
           cmpa DesiredNewAisPosition    ; compare a with memory contents
           bcs  L9B56          ; branch if lower
   L9B4B:  ldaa Temp0          ; load a with memory contents
           suba AISLML_RollingAisLowLimit    ;  (data is 06)
           bcs  L9B5B          ; branch if lower
           cmpa DesiredNewAisPosition    ; compare a with memory contents
           bcs  L9B5B          ; branch if lower
   L9B56:  jsr  MultiplyTempvar1ByA_Unsign    ; call subroutine
           staa DesiredNewAisPosition    ; store a into memory
   L9B5B:  rts                 ; return from subroutine

   L9B5C:  ldaa CoolantTemp    ; load a with memory contents
           ldx  #CLDPOS_AisColdPosition_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp0          ; store a into memory
           ldx  #RPMPOS_AisPosition_FromRpm    ; load index with value
           ldaa EngineRpm_HB    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           cmpa Temp0          ; compare a with memory contents
           bcs  L9B74          ; branch if lower
           staa Temp0          ; store a into memory
   L9B74:  ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bcc  L9B7B          ; branch if greater or equal
           clra                ; a = 0
   L9B7B:  ldx  #THRPOS_AisPosition_FromThrottle    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           cmpa Temp0          ; compare a with memory contents
           bcc  L9B87          ; branch if greater or equal
           ldaa Temp0          ; load a with memory contents
   L9B87:  brset *BitFlags_AIS, #$%01000000, L9BC6    ; branch if bit(s) set
           staa Temp4          ; store a into memory
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           ldab ACPOS_ACPositionWhenTempToCold          ; load b with memory contents (data is 16)
           cmpa MPHREF_SwitchPointForDecelIdleAisControl    ; compare a with memory contents (data is 07)
           bhi  L9BA0          ; branch if higher
           ldab ACPOS2_ACPositionWhenTempToCold2    ; load b with memory contents (data is 18)
   L9BA0:  brset *BitFlags69, #b69_AtIdle, L9BC1    ; branch if bit(s) set
           ldaa CoolantTemp    ; load a with memory contents
           cmpa ACTMP_Use_ACCTBL_WhenTempAboveThisElseUse_ACPOS    ; compare a with memory contents (data is a6)
           bcs  L9BC1          ; branch if lower
           ldx  #ACCTBL_ACOffIdleDelta_FromSpeed    ; load index with value
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    ; call subroutine
           brclr *BitFlags69, #$%00000100, L9BC1    ; branch if bit(s) clear
           ldaa PERKCK_AcClutchAisAdjustmentConstant    ; load a with memory contents (data is 80)
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           tab                 ; b = a
   L9BC1:  ldaa Temp4          ; load a with memory contents
           aba                 ; a=a+b
           bcs  L9BE5          ; branch if lower
   L9BC6:  staa Temp4          ; store a into memory
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           ldx  #ADDAIS_AISAddedFromTimeEngRunning    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp4          ; load a with memory contents
           aba                 ; a=a+b
           bcs  L9BE5          ; branch if lower
   L9BD5:  brset *BitFlags68, #b68_ASDon, L9BDE    ; branch if bit(s) set
           adda CALPOS_PositionAisMotorIsAtIdle    ;  (data is 1a)
           bcs  L9BE5          ; branch if lower
   L9BDE:  bsr  MultiplyTempvar1ByA_Unsign    ; call subroutine
           cmpa AISHLM_AisHighLimitMaxOpenSteps    ; compare a with memory contents (data is a0)
           bcs  L9BE8          ; branch if lower
   L9BE5:  ldaa AISHLM_AisHighLimitMaxOpenSteps    ; load a with memory contents (data is a0)
   L9BE8:  brset *BitFlags69, #b69_AtIdle, L9C02    ; branch if bit(s) set
           brclr *BitFlags_AIS, #$%00010000, L9C05    ; branch if bit(s) clear
           brset *BitFlags_AIS, #$%10000000, L9C05    ; branch if bit(s) set
           cmpa DesiredNewAisPosition    ; compare a with memory contents
           bcc  L9C05          ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bitb DLYOF1_UpdateRateOffIdleWhenAisClosing    ;  (data is 1f)
           bne  L9C07          ; branch if not equal (not zero)
           ldaa DesiredNewAisPosition    ; load a with memory contents
           deca                ; decrement a
   L9C02:  bclr *BitFlags69, #b69_AtIdle    ; clear bits
   L9C05:  staa DesiredNewAisPosition    ; store a into memory
   L9C07:  rts                 ; return from subroutine

MultiplyTempvar1ByA_Unsign:
           ldab Temp1          ; load b with memory contents
           beq  L9C33          ; branch if equal (zero)
           staa Temp4          ; store a into memory
           mul                 ; multiply (d=a*b)
           adca Temp4      
           bcc  L9C33          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
           rts                 ; return from subroutine

MultiplyTempvar1ByA_Pos:
           ldab Temp1          ; load b with memory contents
           beq  L9C33          ; branch if equal (zero)
           staa Temp4          ; store a into memory
           mul                 ; multiply (d=a*b)
           adca Temp4      
           bvc  L9C33          ; branch if overflow
           ldaa #0x7f          ; load a with value -01111111-
           rts                 ; return from subroutine

MultiplyTempvar1ByA_Neg:
           ldab Temp1          ; load b with memory contents
           beq  L9C33          ; branch if equal (zero)
           nega                ; negate a (set high bit)
           staa Temp4          ; store a into memory
           mul                 ; multiply (d=a*b)
           adca Temp4      
           bvc  L9C32          ; branch if overflow
           ldaa #0x7f          ; load a with value -01111111-
   L9C32:  nega                ; negate a (set high bit)
   L9C33:  rts                 ; return from subroutine

ClearAisTimer:
           clrb                ; b = 0
           stab Timer_AisChanges    ; store b into memory
StoreAndLimitDesiredAisPosition:
           tsta                ; test a
           bmi  L9C47          ; branch if minus(hi bit 1)
           adda DesiredNewAisPosition
           ldab AISHLM_AisHighLimitMaxOpenSteps    ; load b with memory contents (data is a0)
           bcs  L9C44          ; branch if lower
           cba             
           bcs  L9C4C          ; branch if lower
   L9C44:  stab DesiredNewAisPosition    ; store b into memory
           rts                 ; return from subroutine

   L9C47:  adda DesiredNewAisPosition
           bcs  L9C4C          ; branch if lower
           clra                ; a = 0
   L9C4C:  staa DesiredNewAisPosition    ; store a into memory
           rts                 ; return from subroutine

CCDBusComs:
           sei                 ; disable interrupts
           ldaa SwitchPortAccessReg2    ; load a with memory contents
           bita #0x08          ;  -00001000-
           bne  L9CD0          ; branch if not equal (not zero)
           ldaa PIA3_Buffer    ; load a with memory contents
           anda #~pi3_CCDEnable          ; AND a with value -11111011-
           staa PIA3_Buffer_2
           brset *CCDVar0, #$%10000000, CCD_Error    ; branch if bit(s) set
           ldd  CCDTemp_HB     ; load d (a&b) with memory contents
           bsr  CCD_XmitCode    ; call subroutine
           cmpD CCDTemp_HB     ; compare D
           beq  L9CAC          ; branch if equal (zero)
           cmpa CCDTemp_HB     ; compare a with memory contents
           bne  L9C77          ; branch if not equal (not zero)
           cmpa #0x84          ; compare a with value -10000100-
           beq  L9CAC          ; branch if equal (zero)
           cmpa #0xc4          ; compare a with value -11000100-
           beq  L9CAC          ; branch if equal (zero)
   L9C77:  brset *CCDFlags4, #$%10000000, L9CAA    ; branch if bit(s) set
           ldx  #SwitchPortAccessReg1    ; load index with value
           brset  1, X, #$%00001000, L9CC7    ; branch if bit(s) set
           bclr  0, X, #$%00001000    ; bit clear
           bset  2, X, #$%00001000    ; bit set
           bclr  2, X, #$%00001000    ; bit clear
           ldab CCDFlags4      ; load b with memory contents
           addb #0x20          ;  -00100000-
           bcs  L9C93          ; branch if lower
           stab CCDFlags4      ; store b into memory
   L9C93:  bra  L9C9A          ; branch

CCD_Error:
           ldd  #0xffff         ; load d (a&b) with value -11111111 11111111-
           bsr  CCD_XmitCode    ; call subroutine
   L9C9A:  cmpa #0xaa          ; compare a with value -10101010-
           bne  L9CC7          ; branch if not equal (not zero)
           bset *CCDFlags5, #$%01000000    ; set bits
           brset *CCDFlags6, #$%10000000, L9CC7    ; branch if bit(s) set
           bset *CCDFlags2, #$%00100000    ; set bits
           bra  L9CC7          ; branch

   L9CAA:  ldaa CCDTemp_HB     ; load a with memory contents
   L9CAC:  cmpa #0x84          ; compare a with value -10000100-
           bne  L9CC4          ; branch if not equal (not zero)
           ldab BodyCompFlags3_X    ; load b with memory contents
           bpl  L9CC4          ; branch if plus (hi bit 0)
           andb #0x7f          ;  -01111111-
           clra                ; a = 0
           staa BodyCompFlags3_X
           ldaa #0xc4          ; load a with value -11000100-
           stD *CCDTemp_HB     ; store D to RAM
           bclr *CCDFlags4, #$%11100000    ; clear bits
           bra  L9CC7          ; branch

   L9CC4:  bset *CCDVar0, #$%10000000    ; set bits
   L9CC7:  ldaa PIA3_Buffer    ; load a with memory contents
           oraa #pi3_CCDEnable          ;  -00000100-
           staa PIA3_Buffer    ; store a into memory
           staa PIA3_Buffer_2
   L9CD0:  rts                 ; return from subroutine

CCD_XmitCode:
           cmpb CPU_SerialPeripheralStatus    ; compare b with memory contents
           staa CPU_SerialPeripheralDataIO
           ldx  #CPU_SerialPeripheralStatus    ; load index with value
           ldY #MINTHR_LowestSessionTPS    ; load Y index -00000000 00000101-
   L9CDE:  brset  0, X, #$%10000000, CCD_XmitData    ; branch if bit(s) set
           deY                 ; decrement Y
           bne  L9CDE          ; branch if not equal (not zero)
           rts                 ; return from subroutine

CCD_XmitData:
           ldaa CPU_SerialPeripheralDataIO    ; load a with memory contents
           stab CPU_SerialPeripheralDataIO    ; store b into memory
           ldY #MINTHR_LowestSessionTPS    ; load Y index -00000000 00000101-
   L9CF1:  brset  0, X, #$%10000000, CCD_ReadResult    ; branch if bit(s) set
           deY                 ; decrement Y
           bne  L9CF1          ; branch if not equal (not zero)
           rts                 ; return from subroutine

CCD_ReadResult:
           ldab CPU_SerialPeripheralDataIO    ; load b with memory contents
           rts                 ; return from subroutine

PrepareCCDDataForXmit_MM:
           ldab Counter_MainLoop    ; load b with memory contents
           andb #0x0f          ;  -00001111-
           bne  L9D46          ; branch if not equal (not zero)
           brset *CCDFlags1, #$%00000100, L9D2A    ; branch if bit(s) set
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa #0x83          ; compare a with value -10000011-
           bcs  L9D42          ; branch if lower
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa #0x2f          ; compare a with value -00101111-
           bcs  L9D42          ; branch if lower
           ldaa BatteryVolts    ; load a with memory contents
           cmpa #0xbd          ; compare a with value -10111101-
           bcc  L9D42          ; branch if greater or equal
           ldab BodyCompFlags4_X    ; load b with memory contents
           incb            
           stab BodyCompFlags4_X    ; store b into memory
           cmpb #0x71          ;  -01110001-
           bcs  L9D46          ; branch if lower
           bset *CCDFlags1, #$%00000100    ; set bits
           bra  L9D42          ; branch

   L9D2A:  ldaa TargetBatteryVolts    ; load a with memory contents
           suba BatteryVolts
           bcs  L9D34          ; branch if lower
           cmpa #0x01          ; compare a with value -00000001-
           bhi  L9D42          ; branch if higher
   L9D34:  ldab BodyCompFlags4_X    ; load b with memory contents
           incb            
           stab BodyCompFlags4_X    ; store b into memory
           cmpb #0x22          ;  -00100010-
           bcs  L9D46          ; branch if lower
           bclr *CCDFlags1, #$%00000100    ; clear bits
   L9D42:  clra                ; a = 0
           staa BodyCompFlags4_X
   L9D46:  brset *Counter_MainLoop, #$%00000001, L9DC1    ; branch if bit(s) set
           ldab CCDVar0    ; load b with memory contents
           incb            
           andb #0x7f          ;  -01111111-
           stab Temp0          ; store b into memory
           ldx  #CCDDataStream    ; load index with value
           abx                 ; add b to index
           abx                 ; add b to index
           ldx  0x00, X    
           ldaa CCDTemp_HB     ; load a with memory contents
           sei                 ; disable interrupts
           brset *CCDVar0, #$%10000000, L9DB4    ; branch if bit(s) set
           bset *CCDVar0, #$%10000000    ; set bits
           cmpa #0x84          ; compare a with value -10000100-
           bne  L9D98          ; branch if not equal (not zero)
           cpx  #CCD_SpeedSensorCounter    ;  -10011110 11000110-
           bne  L9D82          ; branch if not equal (not zero)
           clra                ; a = 0
           ldab BodyCompFlags3_X    ; load b with memory contents
           andb #0x7f          ;  -01111111-
           addb Counter_SpeedSensorInterrupt_HB_X
           bpl  L9D78          ; branch if plus (hi bit 0)
           ldab #0x7f          ; load b with value -01111111-
   L9D78:  staa Counter_SpeedSensorInterrupt_HB_X
           orab #0x80          ;  -10000000-
           stab BodyCompFlags3_X    ; store b into memory
           bra  L9DBC          ; branch

   L9D82:  cpx  #CCD_FuelOutput    ;  -10011110 10111100-
           bne  L9DBC          ; branch if not equal (not zero)
           clra                ; a = 0
           ldab CCDTemp_LB     ; load b with memory contents
           addb CCDFuelOutput_HB    ; b=b+memory contents
           bcc  L9D92          ; branch if greater or equal
           tba                 ; a = b
           inca                ; increment a
           ldab #0xff          ; load b with value -11111111-
   L9D92:  staa CCDFuelOutput_HB    ; store a into memory
           stab CCDTemp_LB     ; store b into memory
           bra  L9DBC          ; branch

   L9D98:  cmpa #0xc4          ; compare a with value -11000100-
           bne  L9DB4          ; branch if not equal (not zero)
           cpx  #CCD_SpeedSensorCounter    ;  -10011110 11000110-
           bne  L9DBC          ; branch if not equal (not zero)
           clra                ; a = 0
           ldab CCDTemp_LB     ; load b with memory contents
           addb Counter_SpeedSensorInterrupt_HB_X
           bcc  L9DAD          ; branch if greater or equal
           tba                 ; a = b
           inca                ; increment a
           ldab #0xff          ; load b with value -11111111-
   L9DAD:  staa Counter_SpeedSensorInterrupt_HB_X
           stab CCDTemp_LB     ; store b into memory
           bra  L9DBC          ; branch

   L9DB4:  cli                 ; enable interrupts
           bclr *CCDFlags4, #$%11100000    ; clear bits
           jsr  0x00, X    
           stD *CCDTemp_HB     ; store D to RAM
   L9DBC:  ldaa Temp0          ; load a with memory contents
           staa CCDVar0    ; store a into memory
           cli                 ; enable interrupts
   L9DC1:  ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           bne  L9DCF          ; branch if not equal (not zero)
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 97)
           bita #0x04          ;  -00000100-
           beq  L9DD0          ; branch if equal (zero)
           bclr *CCDFlags5, #ccd_AlarmDisable    ; clear bits
   L9DCF:  rts                 ; return from subroutine

   L9DD0:  ldaa CPU_EEPROMControlReg    ; load a with memory contents
           bita #0x02          ;  -00000010-
           bne  L9DE4          ; branch if not equal (not zero)
           bclr *CCDFlags2, #$%10000000    ; clear bits
           ldaa LB612          ; load a with memory contents (data is ff)
           bita #0x01          ;  -00000001-
           beq  L9DE4          ; branch if equal (zero)
           bset *CCDFlags2, #$%10000000    ; set bits
   L9DE4:  ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x03          ;  -00000011-
           bne  L9E47          ; branch if not equal (not zero)
           brclr *CCDFlags5, #$%01000000, L9E0C    ; branch if bit(s) clear
           bset *CCDFlags5, #$%10000000    ; set bits
           bclr *CCDFlags5, #$%01100000    ; clear bits
           bclr *CCDFlags6, #$%01111111    ; clear bits
           brset *CCDFlags6, #$%10000000, L9E47    ; branch if bit(s) set
           ldaa BitFlags6A     ; load a with memory contents
           bita #b6a_DRBToggle2 | b6a_DRBToggle1          ;  -00000011-
           bne  L9E47          ; branch if not equal (not zero)
           ldaa LB612          ; load a with memory contents (data is ff)
           bita #0x02          ;  -00000010-
           beq  L9E47          ; branch if equal (zero)
           anda #0xfd          ; AND a with value -11111101-
           bra  L9E35          ; branch

   L9E0C:  ldaa CCDFlags6      ; load a with memory contents
           anda #0x7f          ; AND a with value -01111111-
           brclr *CCDFlags5, #$%10000000, L9E1A    ; branch if bit(s) clear
           cmpa #0x71          ; compare a with value -01110001-
           bcc  L9E23          ; branch if greater or equal
           bra  L9E1E          ; branch

   L9E1A:  cmpa #0x2d          ; compare a with value -00101101-
           bcc  L9E47          ; branch if greater or equal
   L9E1E:  inc  CCDFlags6  
           bra  L9E47          ; branch

   L9E23:  ldaa BitFlags6A     ; load a with memory contents
           bita #b6a_DRBToggle2 | b6a_DRBToggle1          ;  -00000011-
           bne  L9E47          ; branch if not equal (not zero)
           ldaa LB612          ; load a with memory contents (data is ff)
           bita #0x02          ;  -00000010-
           bne  L9E47          ; branch if not equal (not zero)
           bset *CCDFlags6, #$%10000000    ; set bits
           oraa #0x02          ;  -00000010-
   L9E35:  sei                 ; disable interrupts
           brclr *BitFlags6A, #b6a_DRBToggle1, L9E3D    ; branch if bit(s) clear
           cli                 ; enable interrupts
           bra  L9E47          ; branch

   L9E3D:  bset *BitFlags6A, #b6a_DRBToggle1    ; set bits
           cli                 ; enable interrupts
           staa DRBOffsetStored_LB    ; store a into memory
           ldaa #0x12          ; load a with value -00010010-
           staa DRBOffsetStored_HB    ; store a into memory
   L9E47:  brclr *CCDFlags5, #$%00010000, L9E5B    ; branch if bit(s) clear
           brset *CCDFlags5, #$%10000000, L9E5A    ; branch if bit(s) set
           ldaa CCDFlags6      ; load a with memory contents
           anda #0x7f          ; AND a with value -01111111-
           cmpa #0x2d          ; compare a with value -00101101-
           bcs  L9E5A          ; branch if lower
           bset *CCDFlags5, #ccd_AlarmDisable    ; set bits
   L9E5A:  rts                 ; return from subroutine

   L9E5B:  brset *CCDFlags5, #$%00010000, L9EA9    ; branch if bit(s) set
           brset *BitFlags6D, #b6d_FuelEngineNotRunning, L9EA9    ; branch if bit(s) set
           ldaa BitFlags6A     ; load a with memory contents
           bita #b6a_DRBToggle2 | b6a_DRBToggle1          ;  -00000011-
           bne  L9EA9          ; branch if not equal (not zero)
           ldaa LB612          ; load a with memory contents (data is ff)
           bita #0x01          ;  -00000001-
           bne  L9E76          ; branch if not equal (not zero)
           bita #0x02          ;  -00000010-
           bne  L9EA3          ; branch if not equal (not zero)
           bra  L9EA6          ; branch

   L9E76:  brset *CCDFlags5, #$%10000000, L9E84    ; branch if bit(s) set
           ldaa CCDFlags6      ; load a with memory contents
           anda #0x7f          ; AND a with value -01111111-
           cmpa #0x2d          ; compare a with value -00101101-
           bcs  L9EA9          ; branch if lower
           bra  L9EA0          ; branch

   L9E84:  sei                 ; disable interrupts
           brclr *BitFlags6A, #b6a_DRBToggle1, L9E8C    ; branch if bit(s) clear
           cli                 ; enable interrupts
           bra  L9EA9          ; branch

   L9E8C:  bset *BitFlags6A, #b6a_DRBToggle1    ; set bits
           cli                 ; enable interrupts
           adda #0x04          ;  -00000100-
           cmpa #0x4c          ; compare a with value -01001100-
           bcs  L9E98          ; branch if lower
           anda #0xfe          ; AND a with value -11111110-
   L9E98:  anda #0xfd          ; AND a with value -11111101-
           staa DRBOffsetStored_LB    ; store a into memory
           ldaa #0x12          ; load a with value -00010010-
           staa DRBOffsetStored_HB    ; store a into memory
   L9EA0:  bset *CCDFlags2, #$%10000000    ; set bits
   L9EA3:  bset *CCDFlags5, #$%10000000    ; set bits
   L9EA6:  bset *CCDFlags5, #$%00010000    ; set bits
   L9EA9:  rts                 ; return from subroutine

CCD_CCDBusOutputStatus:
           ldaa Temp0          ; load a with memory contents
           oraa #0x80          ;  -10000000-
           staa CCDVar0    ; store a into memory
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
           staa BodyCompFlags3_X
           ldaa #0xc4          ; load a with value -11000100-
           rts                 ; return from subroutine

CCD_ConfigConst1:
           ldaa #0xac          ; load a with value -10101100-
           ldab CCDCFG_CCDConfigConstant    ; load b with memory contents (data is 81)
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
           bsr  L9EF3          ; call subroutine
           ldaa #0xc2          ; load a with value -11000010-
           rts                 ; return from subroutine

CCD_BatVolts:
           ldaa BatteryVolts    ; load a with memory contents
           bsr  L9EF3          ; call subroutine
           ldaa #0xd4          ; load a with value -11010100-
           rts                 ; return from subroutine

   L9EF3:  ldab BodyComputerBatteryVoltsOutput    ; load b with memory contents
           cmpb #0x10          ;  -00010000-
           bhi  L9F0C          ; branch if higher
           comb            
           addb #0x09          ;  -00001001-
           bcs  L9F03          ; branch if lower
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           bra  L9F0C          ; branch

   L9F03:  staa Temp1          ; store a into memory
           mul                 ; multiply (d=a*b)
           adca Temp1      
           bcc  L9F0C          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   L9F0C:  tab                 ; b = a
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
           bcc  L9F1D          ; branch if greater or equal
           clrb                ; b = 0
   L9F1D:  ldaa #0x42          ; load a with value -01000010-
           rts                 ; return from subroutine

CCD_Baro:
           ldaa #0x54          ; load a with value -01010100-
           ldab BaroPressure    ; load b with memory contents
           rts                 ; return from subroutine

CCD_B600:
           ldaa CPU_EEPROMControlReg    ; load a with memory contents
           bita #0x02          ;  -00000010-
           bne  L9F5D          ; branch if not equal (not zero)
           ldd  LB600          ;  (data is ffff)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           tab                 ; b = a
           ldaa #0x2c          ; load a with value -00101100-
           rts                 ; return from subroutine

   L9F35:  ldaa CPU_EEPROMControlReg    ; load a with memory contents
           bita #0x02          ;  -00000010-
           bne  L9F5D          ; branch if not equal (not zero)
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
           brset  0, X, #$%11111111, L9F5D    ; branch if bit(s) set
           ldd  0x00, X    
           aba                 ; a=a+b
           cmpa 0x02, X        ; compare a with memory at index + value
           bne  L9F5D          ; branch if not equal (not zero)
           ldd  0x00, X    
           rts                 ; return from subroutine

   L9F5D:  jmp  CCD_CCDBusOutputStatus

CCD_VehicleSpeed:
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           bcc  L9F69          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   L9F69:  ldab #0x34          ; load b with value -00110100-
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
           brset *PIA1_Buffer, #pi1_CEL, L9F7C    ; branch if bit(s) set
           orab #0x01          ;  -00000001-
   L9F7C:  brset *PIA2_Buffer, #pi2_PTU, L9F82    ; branch if bit(s) set
           orab #0x40          ;  -01000000-
   L9F82:  brclr *b5C_IPL1, #b5c_BattNotCharging, L9F88    ; branch if bit(s) clear
           orab #0x08          ;  -00001000-
   L9F88:  ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bcs  L9F94          ; branch if lower
           cmpa #0x05          ; compare a with value -00000101-
           bcs  L9F94          ; branch if lower
           orab #0x02          ;  -00000010-
   L9F94:  brclr *CCDFlags1, #$%00000100, L9F9A    ; branch if bit(s) clear
           orab #0x04          ;  -00000100-
   L9F9A:  brclr *StartupSwitchMirror2, #sw2_Brake, L9FA0    ; branch if bit(s) clear
           orab #0x10          ;  -00010000-
   L9FA0:  brclr *PIA2_Buffer, #pi2_ACRelay, L9FA6    ; branch if bit(s) clear
           orab #0x20          ;  -00100000-
   L9FA6:  stab CCDFlags1      ; store b into memory
           ldaa #0xa4          ; load a with value -10100100-
           rts                 ; return from subroutine

CCD_ToggleBCFlags:
           clrb                ; b = 0
           ldaa CCDCF2_CCDConfigConstant2    ; load a with memory contents (data is 37)
           bita #0x08          ;  -00001000-
           beq  L9FB5          ; branch if equal (zero)
           orab #0x40          ;  -01000000-
   L9FB5:  brclr *b5C_IPL1, #b5c_TpsBadSignal, L9FBB    ; branch if bit(s) clear
           orab #0x02          ;  -00000010-
   L9FBB:  brclr *b5C_IPL1, #b5c_BadCoolantTemp, L9FC1    ; branch if bit(s) clear
           orab #0x01          ;  -00000001-
   L9FC1:  sei                 ; disable interrupts
           ldaa CCDFlags2      ; load a with memory contents
           anda #0xa0          ; AND a with value -10100000-
           aba                 ; a=a+b
           tab                 ; b = a
           anda #0xdf          ; AND a with value -11011111-
           staa CCDFlags2      ; store a into memory
           cli                 ; enable interrupts
           ldaa #0xec          ; load a with value -11101100-
           rts                 ; return from subroutine

CCD_ConfigConst2:
           ldab CCDCF2_CCDConfigConstant2    ; load b with memory contents (data is 37)
           andb #0xf0          ;  -11110000-
           brset *CruiseStatus_1, #$%10000000, L9FDB    ; branch if bit(s) set
           orab #0x01          ;  -00000001-
   L9FDB:  stab CCDFlags3      ; store b into memory
           ldaa #0x64          ; load a with value -01100100-
           rts                 ; return from subroutine


;	.org	0x9fe0
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
          .word	CCD_ConfigConst2         
          .word	CCD_ThrottlePos
          .word	CCD_EngineRPM            
          .word	CCD_MAP                  
          .word	CCD_FuelOutput           
          .word	CCD_SpeedSensorCounter   
          .word	CCD_EngineRPM            
          .word	CCD_MAP                  
          .word	CCD_Baro                 
          .word	CCD_B600                 
          .word	CCD_EngineRPM            
          .word	CCD_MAP                  
          .word	CCD_SwitchState          
          .word	CCD_VehicleSpeed         
          .word	CCD_EngineRPM            
          .word	CCD_MAP                  
          .word	CCD_ConfigConst2         
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
          .word	CCD_ConfigConst2         
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
          .word	CCD_ConfigConst2         
          .word	CCD_ThrottlePos          
          .word	CCD_EngineRPM            
          .word	CCD_MAP                  
          .word	CCD_FuelOutput           
          .word	CCD_SpeedSensorCounter   
          .word	CCD_EngineRPM            
          .word	CCD_MAP                  
          .word	CCD_BatVolts             
          .word	CCD_ToggleBCFlags        
          .word	CCD_EngineRPM            
          .word	CCD_MAP                  
          .word	CCD_SwitchState          
          .word	CCD_VehicleSpeed         
          .word	CCD_EngineRPM            
          .word	CCD_MAP                  
          .word	CCD_ConfigConst2         
          .word	CCD_ThrottlePos          
          .word	CCD_EngineRPM            
          .word	CCD_MAP                  
          .word	CCD_FuelOutput           
          .word	CCD_SpeedSensorCounter   
          .word	CCD_EngineRPM            
          .word	CCD_MAP                  
          .word	CCD_CCDBusOutputStatus   
          .word	L9F35                    
          .word	CCD_EngineRPM            
          .word	CCD_MAP                  
          .word	CCD_SwitchState          
          .word	CCD_VehicleSpeed         
          .word	CCD_EngineRPM            
          .word	CCD_MAP                  
          .word	CCD_ConfigConst2         
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
          .word	CCD_ConfigConst2         
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
          .word	CCD_ConfigConst2         
          .word	CCD_ThrottlePos

HandleO2Processing_MM:
           clra                ; a = 0
           brset *BitFlags66, #b66_OffIdle, LA0FE    ; branch if bit(s) set
           ldab CONFIG2_ConfigurationFlags2    ; load b with memory contents (data is c7)
           bitb #0x40          ;  -01000000-
           beq  LA0F0          ; branch if equal (zero)
           brclr *BitFlags6B, #$%00010000, LA0FE    ; branch if bit(s) clear
   LA0F0:  ldab EngineRpm_HB    ; load b with memory contents
           subb TargetIdleSpeedHB    ; b = b-memory contents
           bcs  LA0FE          ; branch if lower
           cmpb MNRPO2_MinimumRPMOverIdleForO2Feedback    ; compare b with memory contents (data is d0)
           bls  LA0FE          ; branch if lower or same
           jmp  O2_StopUsingFeedback

   LA0FE:  ldab MapValue       ; load b with memory contents
           cmpb MAPDEC_NoCellUpdateAndO2CNTRHeldBelowThisMap    ; compare b with memory contents (data is 14)
           bls  LA11A          ; branch if lower or same
           ldab Timer_O2InhibitSwitchingRichIdleToClosedLoop    ; load b with memory contents
           orab Timer_OffThrottleFuelEnrich
           orab Factor_DecelLeanoutWhenMAPDecreasing
           bne  LA11A          ; branch if not equal (not zero)
           ldab Timer_OpenLoopFraction    ; load b with memory contents
           beq  LA115          ; branch if equal (zero)
           brset *BitFlags66, #b66_OffIdle, LA11A    ; branch if bit(s) set
   LA115:  bclr *BitFlags67, #b67_StayOpenLoop    ; clear bits
           bra  LA11F          ; branch

   LA11A:  bset *BitFlags67, #b67_StayOpenLoop    ; set bits
           staa Timer_OutOfClosedLoopMode    ; store a into memory
   LA11F:  brset *BitFlags66, #b66_FullThrottle, LA12B    ; branch if bit(s) set
           brclr *BitFlags66, #b66_PTEisMaxed, LA131    ; branch if bit(s) clear
           brclr *BitFlags67, #b67_StayOpenLoop, LA131    ; branch if bit(s) clear
   LA12B:  brset *BitFlags66, #b66_O2Valid, O2_StopUsingFeedback    ; branch if bit(s) set
           bra  LA135          ; branch

   LA131:  brset *BitFlags66, #b66_O2Valid, O2_UsingFeedback    ; branch if bit(s) set
   LA135:  ldab CoolantTemp    ; load b with memory contents
           cmpb CLTEMP_TempToStartCLTIMETimer    ; compare b with memory contents (data is 92)
           bcs  O2_StopUsingFeedback    ; branch if lower
           brset *BitFlags66, #b66_OpenLoop, LA150    ; branch if bit(s) set
           ldab Counter_MainLoop    ; load b with memory contents
           bne  O2_StopUsingFeedback    ; branch if not equal (not zero)
           ldab Timer_CLTIME_ClosedLoopTimer    ; load b with memory contents
           beq  LA14D          ; branch if equal (zero)
           decb
           stab Timer_CLTIME_ClosedLoopTimer    ; store b into memory
           bne  O2_StopUsingFeedback    ; branch if not equal (not zero)
   LA14D:  bset *BitFlags66, #b66_OpenLoop    ; set bits
   LA150:  ldab O2SensorVolts    ; load b with memory contents
           cmpb O2HIGH_HighLimitForImmediateSwitchToClosedLoop    ; compare b with memory contents (data is 26)
           bcc  O2_ValidSignal_OutsideMiddleRange    ; branch if greater or equal
           cmpb O2LOW_LowLimitForImmediateSwitchToClosedLoop          ; compare b with memory contents (data is 0f)
           bcc  O2_InvalidSignal_InMiddleRange    ; branch if greater or equal
O2_ValidSignal_OutsideMiddleRange:
           brset *PIA3_Buffer, #pi3_FuelMon, O2_StopUsingFeedback    ; branch if bit(s) set
           bset *BitFlags66, #b66_O2Valid    ; set bits
           staa Counter_AdaptiveMem_Erase    ; store a into memory
           clrb                ; b = 0
           bra  LA185          ; branch

O2_InvalidSignal_InMiddleRange:
           brset *Timer_CLTIME_ClosedLoopTimer, #$%10000000, LA179    ; branch if bit(s) set
           cmpb O2TLMH_HighLimitForDelayedSwitchToClosedLoop    ; compare b with memory contents (data is 1f)
           bcc  LA176          ; branch if greater or equal
           cmpb O2TLML_LowLimitForDelayedSwitchToClosedLoop    ; compare b with memory contents (data is 0f)
           bcc  O2_StopUsingFeedback    ; branch if greater or equal
   LA176:  bset *Timer_CLTIME_ClosedLoopTimer, #$%10000000    ; set bits
   LA179:  ldab Counter_MainLoop    ; load b with memory contents
           bne  O2_StopUsingFeedback    ; branch if not equal (not zero)
           ldab Timer_CLTIME_ClosedLoopTimer    ; load b with memory contents
           cmpb O2TIME_DelayTimeToClosedLoop    ; compare b with memory contents (data is 07)
           bmi  O2_ValidSignal_OutsideMiddleRange    ; branch if minus(hi bit 1)
           incb
   LA185:  stab Timer_CLTIME_ClosedLoopTimer    ; store b into memory
O2_StopUsingFeedback:
           staa Counter_O2SensorFeedbackCount_Signed    ; store a into memory
           staa Timer_OutOfClosedLoopMode    ; store a into memory
           bset *BitFlags67, #b67_StayOpenLoop | b67_OpenLoop    ; set bits
           rts                 ; return from subroutine

O2_UsingFeedback:
           ldab O2SensorVolts    ; load b with memory contents
           cmpb O2MIDX_HighLimitForInMiddleDeterminationX    ; compare b with memory contents (data is 3e)
           bcc  O2Signal_InOuterMiddleRange    ; branch if greater or equal
           cmpb O2MIDH_HighLimitForInMiddleDetermination    ; compare b with memory contents (data is 1c)
           bcc  LA1B3          ; branch if greater or equal
           cmpb O2MIDL_LowLimitForInMiddleDetermination    ; compare b with memory contents (data is 12)
           bcs  LA1B3          ; branch if lower
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa #0x2c          ; compare a with value -00101100-
           bcs  LA1B2          ; branch if lower
O2Signal_InOuterMiddleRange:
           ldaa Timer_CLTIME_ClosedLoopTimer    ; load a with memory contents
           inca                ; increment a
           bne  LA1AE          ; branch if not equal (not zero)
           jmp  Save_CLTIME_ToOtherTimers_O2InMiddle

   LA1AE:  brset *Counter_MainLoop, #$%00000001, LA1B5    ; branch if bit(s) set
   LA1B2:  clra                ; a = 0
   LA1B3:  staa Timer_CLTIME_ClosedLoopTimer    ; store a into memory
   LA1B5:  clra                ; a = 0
           cmpb O2HSWP_HighLimitForO2RampSwitching    ; compare b with memory contents (data is 19)
           bcc  O2Signal_AboveToggle    ; branch if greater or equal
           cmpb O2LSWP_LowLimitForO2RampSwitching    ; compare b with memory contents (data is 18)
           bcs  O2Signal_BelowToggle    ; branch if lower
           rts                 ; return from subroutine

O2Signal_AboveToggle:
           deca                ; decrement a
O2Signal_BelowToggle:
           staa Temp0          ; store a into memory
           brclr *EGRVar2, #$%10000000, LA1CE    ; branch if bit(s) clear
           clr  Counter_AdaptiveMem_Erase    ; zero byte at memory location
   LA1CB:  jmp  LA23E

   LA1CE:  ldab EngineRpm_HB    ; load b with memory contents
           cmpb RPMLIM_NoCellUpdateAboveThisRPMInRPMOver32    ; compare b with memory contents (data is 60)
           bhi  LA1CB          ; branch if higher
           brset *BitFlags66, #b66_OffIdle, LA1ED    ; branch if bit(s) set
           ldaa CONFIG2_ConfigurationFlags2    ; load a with memory contents (data is c7)
           bita #0x40          ;  -01000000-
           beq  LA1E4          ; branch if equal (zero)
           brclr *BitFlags6B, #$%00010000, LA1ED    ; branch if bit(s) clear
   LA1E4:  subb TargetIdleSpeedHB    ; b = b-memory contents
           bcs  LA1ED          ; branch if lower
           cmpb MNRPO2_MinimumRPMOverIdleForO2Feedback    ; compare b with memory contents (data is d0)
           bhi  LA23E          ; branch if higher
   LA1ED:  ldab Timer_FuelEnrich    ; load b with memory contents
           orab Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop
           bne  LA23E          ; branch if not equal (not zero)
           ldab MapValue       ; load b with memory contents
           cmpb MAPLIM_NoCellUpdateAboveThisMAP    ; compare b with memory contents (data is 8a)
           bhi  LA23E          ; branch if higher
           cmpb MAPDEC_NoCellUpdateAndO2CNTRHeldBelowThisMap    ; compare b with memory contents (data is 14)
           bls  SwitchOrStayOpenLoop    ; branch if lower or same
           ldab Factor_DecelLeanoutWhenMAPDecreasing    ; load b with memory contents
           orab Timer_OffThrottleFuelEnrich
           orab Timer_OpenLoopFraction
           bne  SwitchOrStayOpenLoop    ; branch if not equal (not zero)
           ldab CylTrim_Adaptive_Var1    ; load b with memory contents
           beq  LA210          ; branch if equal (zero)
           cmpb CLTRMN_MinimumCylinderTrim    ; compare b with memory contents (data is 07)
           bcs  SwitchOrStayOpenLoop    ; branch if lower
   LA210:  ldab CALTH1_O2ControllerDeadbandLimitForUpdatingCells1          ; load b with memory contents (data is 09)
           brset *BitFlags66, #b66_OffIdle, LA229    ; branch if bit(s) set
           pshb                ; push b onto stack
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           cmpa MPHREF_SwitchPointForDecelIdleAisControl    ; compare a with memory contents (data is 07)
           pulb                ; pull b from stack
           bhi  LA229          ; branch if higher
           ldab CALTH2_O2ControllerDeadbandLimitForUpdatingCells2    ; load b with memory contents (data is 09)
   LA229:  brset *Temp0, #$%11111111, LA22E    ; branch if bit(s) set
           negb            
   LA22E:  addb Counter_O2SensorFeedbackCount_Signed    ; b=b+memory contents
           bvs  SwitchOrStayOpenLoop    ; branch if no overflow
           eorb Temp0      
           bmi  SwitchOrStayOpenLoop    ; branch if minus(hi bit 1)
           bclr *BitFlags67, #b67_OpenLoop    ; clear bits
           bclr *CylTrim_FlagsE7, #$%00100000    ; clear bits
           bra  SwitchOrStayClosedLoop    ; branch

   LA23E:  bset *CylTrim_FlagsE7, #$%00100000    ; set bits
SwitchOrStayOpenLoop:
           bset *BitFlags67, #b67_OpenLoop    ; set bits
SwitchOrStayClosedLoop:
           clra                ; a = 0
           brclr *BitFlags67, #b67_StayOpenLoop, LA24C    ; branch if bit(s) clear
           staa Counter_AdaptiveMem_Erase    ; store a into memory
           rts                 ; return from subroutine

   LA24C:  ldab Temp0          ; load b with memory contents
           eorb BitFlags66 
           andb #b66_O2Rich          ;  -00000100-
           beq  O2HasNotToggled    ; branch if equal (zero)
           eorb BitFlags66 
           stab BitFlags66     ; store b into memory
           clrb                ; b = 0
           ldaa Timer_OutOfClosedLoopMode    ; load a with memory contents
           stab Timer_OutOfClosedLoopMode    ; store b into memory
           stab Timer_O2ToggleDuration    ; store b into memory
           bclr *BitFlags69, #b69_BadO2Read    ; clear bits
           bclr *BitFlags67, #b67_BadO2    ; clear bits
           bra  WorkWithPrimaryRamp    ; branch

O2HasNotToggled:
           ldab Timer_OutOfClosedLoopMode    ; load b with memory contents
           beq  LA2A0          ; branch if equal (zero)
WorkWithPrimaryRamp:
           staa Temp0          ; store a into memory
           ldx  #PRIRMP_PrimaryRamp    ; load index with value
           jsr  DetermineRampCellFromRPMandMAP    ; call subroutine
           ldab Timer_OutOfClosedLoopMode    ; load b with memory contents
           addb 0x00, X        ; add memory at index + value to b
           sba                 ; subtract (a=a-b)
           bhi  LA284          ; branch if higher
           adda 0x00, X    
           bpl  LA27F          ; branch if plus (hi bit 0)
           clra                ; a = 0
   LA27F:  clrb                ; b = 0
           stab Timer_OutOfClosedLoopMode    ; store b into memory
           bra  LA28B          ; branch

   LA284:  ldaa 0x00, X        ; load a with memory at index + value
           tab                 ; b = a
           addb Timer_OutOfClosedLoopMode    ; b=b+memory contents
           stab Timer_OutOfClosedLoopMode    ; store b into memory
   LA28B:  ldab Temp0          ; load b with memory contents
           beq  LA293          ; branch if equal (zero)
           cba             
           bcs  LA293          ; branch if lower
           tba                 ; a = b
   LA293:  ldab BitFlags66     ; load b with memory contents
           bitb #b66_O2Rich          ;  -00000100-
           beq  LA29A          ; branch if equal (zero)
           nega                ; negate a (set high bit)
   LA29A:  jsr  IncrementO2SensorFeedbackCount    ; call subroutine
           clra                ; a = 0
           bra  LA2B0          ; branch

   LA2A0:  brset *BitFlags67, #b67_StayOpenLoop, LA2B2    ; branch if bit(s) set
           ldaa Counter_AdaptiveMem_Erase    ; load a with memory contents
           cmpa LTHTIM_IfNoO2SwitchForThisTimeThrowFault51or52    ; compare a with memory contents (data is 2b)
           bcc  EraseAdaptiveMemory_possiblySetErrorBit    ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bne  LA2B2          ; branch if not equal (not zero)
           inca                ; increment a
   LA2B0:  staa Counter_AdaptiveMem_Erase    ; store a into memory
   LA2B2:  rts                 ; return from subroutine

EraseAdaptiveMemory_possiblySetErrorBit:
           brset *BitFlags69, #b69_BadO2Read, LA2BC    ; branch if bit(s) set
           inc  BitFlags69 
           bra  EraseAdaptiveMemory1    ; branch

   LA2BC:  bset *BitFlags67, #b67_BadO2    ; set bits
           ldd  #0x0301        ; load d (a&b) with value -00000011 00000001-
           brset *BitFlags66, #b66_O2Rich, LA2C7    ; branch if bit(s) set
           inca                ; increment a
   LA2C7:  jsr  ThrowNonCriticalError    ; call subroutine
EraseAdaptiveMemory1:
           clra                ; a = 0
           staa ValueFromAdaptiveMemory    ; store a into memory
           ldx  #AutoCalCell0    ; load index with value
   LA2D0:  staa 0x00, X    
           inx                 ; increment index (x=x+1)
           cpx  #ErrorBitRegister0    ;  -00000000 00011111-
           bne  LA2D0          ; branch if not equal (not zero)
Save_CLTIME_ToOtherTimers_O2InMiddle:
           staa AdaptiveCellUpdateTimer_IncrementedEveryCamRisingEdge    ; store a into memory
           staa Counter_AdaptiveMem_Erase    ; store a into memory
           staa Timer_CLTIME_ClosedLoopTimer    ; store a into memory
           bclr *BitFlags66, #b66_O2Valid    ; clear bits
           rts                 ; return from subroutine

ModifyO2FeedbackCountVarToMaintainStoich_MM:
           brset *BitFlags67, #b67_StayOpenLoop, LA2EA    ; branch if bit(s) set
           brset *BitFlags66, #b66_O2Valid, WorkWithSecondaryRamp    ; branch if bit(s) set
   LA2EA:  clra                ; a = 0
           staa Timer_O2ToggleDuration    ; store a into memory
           rts                 ; return from subroutine

WorkWithSecondaryRamp:
           ldx  #SECRMP_SecondaryRamp    ; load index with value
           bsr  DetermineRampCellFromRPMandMAP    ; call subroutine
           sei                 ; disable interrupts
           ldaa Timer_O2ToggleDuration    ; load a with memory contents
           brclr *EGRVar2, #$%10000000, LA2FF    ; branch if bit(s) clear
           suba SCRMP1_SecondaryRampSubtractor1    ;  (data is ff)
           bra  O2_FullThrottle    ; branch

   LA2FF:  sba                 ; subtract (a=a-b)
O2_FullThrottle:
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
           bge  LA323          ; branch if greater or equal
SET_TO_MAX_OR_MIN_VALUE:
           tba                 ; a = b
   LA323:  brclr *BitFlags67, #b67_BadO2, LA32A    ; branch if bit(s) clear
           tsta                ; test a
           bmi  DontUpdateO2FeedbackCount    ; branch if minus(hi bit 1)
   LA32A:  staa Counter_O2SensorFeedbackCount_Signed    ; store a into memory
DontUpdateO2FeedbackCount:
           rts                 ; return from subroutine

DetermineRampCellFromRPMandMAP:
           brset *BitFlags67, #b67_FallToIdle, LA339    ; branch if bit(s) set
           brset *BitFlags66, #b66_OffIdle, LA339    ; branch if bit(s) set
           ldab #0x16          ; load b with value -00010110-
           bra  LA363          ; branch

   LA339:  clrb                ; b = 0
           ldaa EngineRpm_HB    ; load a with memory contents
   LA33C:  cmpa 0x00, X        ; compare a with memory at index + value
           bcs  LA348          ; branch if lower
           incb            
           inx                 ; increment index (x=x+1)
           cmpb #0x02          ;  -00000010-
           bcs  LA33C          ; branch if lower
           bra  LA34D          ; branch

   LA348:  tstb            
           bne  LA34C          ; branch if not equal (not zero)
           inx                 ; increment index (x=x+1)
   LA34C:  inx                 ; increment index (x=x+1)
   LA34D:  ldaa MapValue       ; load a with memory contents
   LA34F:  cmpa 0x00, X        ; compare a with memory at index + value
           bcs  LA35C          ; branch if lower
           addb #0x03          ;  -00000011-
           inx                 ; increment index (x=x+1)
           cmpb #0x06          ;  -00000110-
           bcs  LA34F          ; branch if lower
           bra  LA362          ; branch

   LA35C:  cmpb #0x03          ;  -00000011-
           bcc  LA361          ; branch if greater or equal
           inx                 ; increment index (x=x+1)
   LA361:  inx                 ; increment index (x=x+1)
   LA362:  lslb            
   LA363:  brclr *BitFlags66, #b66_O2Rich, LA368    ; branch if bit(s) clear
           incb            
   LA368:  abx                 ; add b to index
           ldaa 0x14, X        ; load a with memory at index + value
           tab                 ; b = a
           rts                 ; return from subroutine

AdaptiveMemory_UpdateCellIfRequired_MM:
           ldx  #AutoCalCell0    ; load index with value
           ldab PointerIntoAdaptiveMemory    ; load b with memory contents
           abx                 ; add b to index
           brset *PIA1_Buffer, #pi1_PurgeSol, LA37B    ; branch if bit(s) set
           ldaa CylTrim_Adaptive_Var1    ; load a with memory contents
           bne  LA380          ; branch if not equal (not zero)
   LA37B:  bclr *CylTrim_FlagsE7, #$%00010000    ; clear bits
           bra  LA3AB          ; branch

   LA380:  ldY #Cyl2_InjPWTrim    ; load Y index -00000000 00101010-
           cmpb CL2PTR_Cyl2AdaptiveMemoryPointer    ; compare b with memory contents (data is 0d)
           beq  LA39E          ; branch if equal (zero)
           inY                 ; increment Y
           cmpb CL1PTR_Cyl1AdaptiveMemoryPointer    ; compare b with memory contents (data is 03)
           beq  LA39E          ; branch if equal (zero)
           inY                 ; increment Y
           cmpb CL3PTR_Cyl3AdaptiveMemoryPointer    ; compare b with memory contents (data is 04)
           beq  LA39E          ; branch if equal (zero)
           inY                 ; increment Y
           cmpb CL4PTR_Cyl4AdaptiveMemoryPointer    ; compare b with memory contents (data is 05)
           bne  LA3AB          ; branch if not equal (not zero)
   LA39E:  xgDY                ; exchange D and Y
           xgDX                ; exchange D and X
           brset *CylTrim_FlagsE7, #$%00010000, LA3AB    ; branch if bit(s) set
           clr  Counter_O2SensorFeedbackCount_Signed    ; zero byte at memory location
           bset *CylTrim_FlagsE7, #$%00010000    ; set bits
   LA3AB:  ldab AMUPDT_EPPsBetweenCalChangeUpdateOpenThrottle    ; load b with memory contents (data is 14)
           brset *BitFlags66, #b66_OffIdle, UpdateAdaptive_OffIdle    ; branch if bit(s) set
           ldab AMUPDI_EPPsBetweenCalChangeUpdateClosedThrottle    ; load b with memory contents (data is 1a)
UpdateAdaptive_OffIdle:
           brset *BitFlags67, #b67_OpenLoop, DontUpdateCell_MaybeUpdateTimer    ; branch if bit(s) set
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
           bpl  LA3D7          ; branch if plus (hi bit 0)
           nega                ; negate a (set high bit)
   LA3D7:  ldab AMLIMH_MaxMultiplierCannotBeAbove7F    ; load b with memory contents (data is 7f)
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
           bge  LA3F1          ; branch if greater or equal
Adaptive_SetCellToMaxOrMinValue:
           tba                 ; a = b
   LA3F1:  staa 0x00, X    
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
           bcs  LA404          ; branch if lower
           stab AdaptiveCellUpdateTimer_IncrementedEveryCamRisingEdge    ; store b into memory
   LA404:  rts                 ; return from subroutine

AdaptiveMemory_DetermineWhichCellApplies_MM:
           clra                ; a = 0
           staa Temp0          ; store a into memory
           ldx  #MP1_AutoCalMapCellBoundary1    ; load index with value
           ldab PointerIntoAdaptiveMemory    ; load b with memory contents
           brset *BitFlags66, #b66_OffIdle, ONTHROTTLE_OR_RPMTOOHIGHFORIDLE    ; branch if bit(s) set
           ldaa TargetIdleSpeedHB    ; load a with memory contents
           adda IDLOFS_DeltaForIdleRPMForClosedThrottleCell    ;  (data is 03)
           cmpb #0x0c          ;  -00001100-
           bcs  LA41D          ; branch if lower
           adda HYTRPM_HysteresisFor_IDLOFS    ;  (data is 02)
   LA41D:  cmpa EngineRpm_HB    ; compare a with memory contents
           bcs  ONTHROTTLE_OR_RPMTOOHIGHFORIDLE    ; branch if lower
           ldab #0x0c          ; load b with value -00001100-
           brset *BitFlags_AIS, #b10_ATXInGear, LA454    ; branch if bit(s) set
           incb            
           bra  LA454          ; branch

   LA42A:  ldaa 0x00, X        ; load a with memory at index + value
           cmpb Temp0      
           bcc  LA433          ; branch if greater or equal
           adda DLTMAP_MapHysteresisAtMapCellBoundaries          ;  (data is 04)
   LA433:  cmpa MapValue       ; compare a with memory contents
           bcc  LA443          ; branch if greater or equal
           inx                 ; increment index (x=x+1)
ONTHROTTLE_OR_RPMTOOHIGHFORIDLE:
           ldaa Temp0          ; load a with memory contents
           adda #0x02          ;  -00000010-
           staa Temp0          ; store a into memory
           cpx  #MP5_AutoCalMapCellBoundary5    ;  -10001011 10101011-
           bls  LA42A          ; branch if lower or same
   LA443:  ldaa R1_RPMCellBoundaryInRPMover32    ; load a with memory contents (data is 40)
           lsrb                ; logical shift right b
           bcs  LA44C          ; branch if lower
           adda DLTRPM_DeltaRPMAtRPMBoundariesInRPMOver32    ;  (data is 03)
   LA44C:  ldab Temp0          ; load b with memory contents
           cmpa EngineRpm_HB    ; compare a with memory contents
           bcs  LA453          ; branch if lower
           decb            
   LA453:  decb            
   LA454:  cmpb PointerIntoAdaptiveMemory
           beq  LA47A          ; branch if equal (zero)
           clra                ; a = 0
           staa AdaptiveCellUpdateTimer_IncrementedEveryCamRisingEdge    ; store a into memory
           staa CylTrim_Adaptive_Var1    ; store a into memory
           ldaa #0x80          ; load a with value -10000000-
           cmpb CL2PTR_Cyl2AdaptiveMemoryPointer    ; compare b with memory contents (data is 0d)
           beq  LA476          ; branch if equal (zero)
           lsra            
           cmpb CL1PTR_Cyl1AdaptiveMemoryPointer    ; compare b with memory contents (data is 03)
           beq  LA476          ; branch if equal (zero)
           lsra            
           cmpb CL3PTR_Cyl3AdaptiveMemoryPointer    ; compare b with memory contents (data is 04)
           beq  LA476          ; branch if equal (zero)
           lsra            
           cmpb CL4PTR_Cyl4AdaptiveMemoryPointer    ; compare b with memory contents (data is 05)
           bne  LA47A          ; branch if not equal (not zero)
   LA476:  eora CylTrim_FlagsE6
           staa CylTrim_FlagsE6    ; store a into memory
   LA47A:  stab PointerIntoAdaptiveMemory    ; store b into memory
           rts                 ; return from subroutine

HandleAmTimer_MM:
           brclr *BitFlags6D, #b6d_FuelEngineNotRunning, AMTimer_EngineRunning    ; branch if bit(s) clear
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
           bne  LA4B7          ; branch if not equal (not zero)
           cmpa AMTEMP_StartTempToSelectHotOrColdAMTimer    ; compare a with memory contents (data is ca)
           bcs  LA4AB          ; branch if lower
           ldab Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop    ; load b with memory contents
           beq  LA4B7          ; branch if equal (zero)
           decb            
           stab Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop    ; store b into memory
           rts                 ; return from subroutine

   LA4AB:  bne  LA4B7          ; branch if not equal (not zero)
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #AMTPSW_TempPointToEnableSelectedAMTimer    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop    ; store a into memory
   LA4B7:  rts                 ; return from subroutine


;	.org	0xa4b8
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

;	.org	0xa4e0
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

;	.org	0xa4f1
ATMFunctionTable:
	.word	LA6B6
	.word	ATM_IgnitionCoil1
	.word	ATM_IgnitionCoil2
	.word	LA6B6
	.word	ATM_InjBank1
	.word	ATM_InjBank2
	.word	ATM_InjBank3
	.word	ATM_AISMotorOpenClose
	.word	ATM_FanRelay
	.word	ATM_ACClutchRelay
	.word	ATM_ASDRelay
	.word	ATM_PurgeSolenoid
	.word	ATM_SCServoSolenoid
	.word	LAAB6
	.word	ATM_Tachometer
	.word	ATM_PTUIndicator
	.word	LAA5C
	.word	ATM_WGSolenoid
	.word	ATM_BaroReadSolenoid
	.word	LA6B6
	.word	ATM_AllSolenoidsRelays
	.word	LA6B6
	.word	LA6B6
	.word	ATM_PTUIndicator
	.word	LA6B6
	.word	LA6B6
	.word	ATM_PTUIndicator
	.word	LA6B6
	.word	LAA11
	.word	ATM_InjBank4
	.word	LA6B6
	.word	LA6B6
	.word	ATM_WGSolenoid
;	.org	0xa533
	.word	LA6B6

DRBMemoryTable:
	.word	AmbientAirTempVolts
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
	.word	BitFlags_BF
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
	.word	BitFlags6E
	.word	Temp0
;	.org	0xa589

SwitchTestTable:
	.word	SendSwitchStateToSerial
	.word	SendOutputStatusToSerial
	.word	SendOutputStatusToSerial2

;	.org	0xa591
RealTimeDataTable:
	.word	SCI_MAPVolts
	.word	SCI_Speed
	.word	SCI_O2Volts
	.word	EndRealTimeData
	.word	LA6DE
	.word	SendBaro
	.word	SendTPS
	.word	SendAdvance

DRBIISerialCommunications_MM:
           jsr  NULL_ROUTINE    ; call subroutine
           jsr  BYTE_MODE_SERIAL_CODE_DOWNLOAD_ROUTINE    ; call subroutine
           ldab DRBSerialMode    ; load b with memory contents
           bitb #bbe_FastSerial | bbe_ByteMode          ;  -11000000-
           bne  LA618          ; branch if not equal (not zero)
           ldaa CPU_SerialBaudRate    ; load a with memory contents
           anda #0x37          ; AND a with value -00110111-
           cmpa #0x22          ; compare a with value -00100010-
           beq  LA5BC          ; branch if equal (zero)
           ldaa #0x22          ; load a with value -00100010-
           staa CPU_SerialBaudRate
           rts                 ; return from subroutine

   LA5BC:  ldaa CPU_SerialStatus    ; load a with memory contents
           bita #0x0e          ;  -00001110-
           beq  DRB_NoRxError    ; branch if equal (zero)
           ldaa CPU_SerialData    ; load a with memory contents
           rts                 ; return from subroutine

DRB_NoRxError:
           bita #0x20          ;  -00100000-
           bne  DRB_ChrRxd     ; branch if not equal (not zero)
           brset *DRBSerialMode, #bbe_bottom, DRB_Timeout    ; branch if bit(s) set
           incb            
           stab DRBSerialMode    ; store b into memory
           rts                 ; return from subroutine

DRB_Timeout:
           brclr *DRBSerialMode, #bbe_TestType3 | bbe_TestType2, LA618    ; branch if bit(s) clear
           bclr *DRBSerialMode, #bbe_TestType3 | bbe_TestType2    ; clear bits
           clr  DRBPointer1    ; zero byte at memory location
           rts                 ; return from subroutine

DRB_ChrRxd:
           ldaa CPU_SerialData    ; load a with memory contents
           staa CPU_SerialData
           andb #0xf0          ;  -11110000-
           stab DRBSerialMode    ; store b into memory
           bitb #bbe_TestType3 | bbe_TestType2          ;  -00110000-
           bne  DRB_StorePointer    ; branch if not equal (not zero)
           cmpa #0x14          ; compare a with value -00010100-
           beq  DRB_SetModeVar    ; branch if equal (zero)
           bclr *BitFlags6C, #b6c_DRBModeFlag    ; clear bits
DRB_SetModeVar:
           staa DRBPointer1    ; store a into memory
           clrb                ; b = 0
           stab DRBPointer2    ; store b into memory
           stab DRBPointer3    ; store b into memory
           cmpa #0x23          ; compare a with value -00100011-
           bhi  LA618          ; branch if higher
           suba #0x13          ;  -00010011-
           bcs  LA618          ; branch if lower
           tab                 ; b = a
           ldx  #DRBSerialToggles    ; load index with value
           abx                 ; add b to index
           ldab 0x00, X        ; load b with memory at index + value
           orab DRBSerialMode
           stab DRBSerialMode    ; store b into memory
           rts                 ; return from subroutine

DRB_StorePointer:
           bitb #0x20          ;  -00100000-
           bne  LA619          ; branch if not equal (not zero)
           staa DRBPointer3    ; store a into memory
           andb #~(bbe_TestType3 | bbe_TestType2)          ;  -11001111-
           stab DRBSerialMode    ; store b into memory
   LA618:  rts                 ; return from subroutine

   LA619:  staa DRBPointer2    ; store a into memory
           andb #~bbe_TestType3          ;  -11011111-
           stab DRBSerialMode    ; store b into memory
           rts                 ; return from subroutine

DRBIIOuput_MM:
           ldaa DRBSerialMode    ; load a with memory contents
           bita #bbe_TestType3 | bbe_TestType2          ;  -00110000-
           bne  LA618          ; branch if not equal (not zero)
           ldab DRBPointer1    ; load b with memory contents
           subb #0x10          ;  -00010000-
           bcs  LA618          ; branch if lower
           cmpb #0x13          ;  -00010011-
           bhi  LA618          ; branch if higher
           lslb            
           ldx  #DRBFunctionTable    ; load index with value
           abx                 ; add b to index
           ldx  0x00, X    
           jmp  0x00, X        ; indexed jump

OutputErrorCodes:
           ldx  #ErrorBitRegister0    ; load index with value
           ldab DRBPointer2    ; load b with memory contents
           cmpb #0x07          ;  -00000111-
           bhi  LA64F          ; branch if higher
           negb            
           addb #0x07          ;  -00000111-
           abx                 ; add b to index
           inc  DRBPointer2
           ldaa 0x00, X        ; load a with memory at index + value
           beq  LA650          ; branch if equal (zero)
           bra  LA672          ; branch

   LA64F:  dex                 ; decrement index (x=x-1)
   LA650:  clr  DRBPointer1    ; zero byte at memory location
           ldaa #0xfe          ; load a with value -11111110-
           jsr  SerialOutput1a    ; call subroutine
           adda #0x10          ;  -00010000-
   LA65A:  inx                 ; increment index (x=x+1)
           cpx  #ErrorCodeUpdateKeyOnCount    ;  -00000000 00100111-
           bcc  LA672          ; branch if greater or equal
           adda 0x00, X    
           bra  LA65A          ; branch

OutputErrorBits:
           ldaa ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB    ; load a with memory contents
           brclr *DRBPointer2, #$%11111111, LA66F    ; branch if bit(s) clear
           ldaa ErrorBitsAssociatedWithPIA1AndReg1eTo25_LB    ; load a with memory contents
           clr  DRBPointer1    ; zero byte at memory location
   LA66F:  inc  DRBPointer2
   LA672:  jmp  SerialOutput1a

SetupHiSpeedDataTransfer:
           bset *DRBSerialMode, #bbe_FastSerial    ; set bits
           clr  DRBPointer1    ; zero byte at memory location
   LA67B:  ldaa CPU_SerialStatus    ; load a with memory contents
           bita #0x40          ;  -01000000-
           beq  LA67B          ; branch if equal (zero)
           ldaa #0x01          ; load a with value -00000001-
           staa CPU_SerialBaudRate
DRB_Return:
           rts                 ; return from subroutine

SetupATM:
           clra                ; a = 0
           staa DRBPointer1    ; store a into memory
           ldab TimerOverflowsBetweenCamPulses    ; load b with memory contents
           cmpb #0x50          ;  -01010000-
           bls  LA6A1          ; branch if lower or same
           brset *BitFlags70, #b70_O2Enable, LA6A1    ; branch if bit(s) set
           ldaa DRBPointer2    ; load a with memory contents
           cmpa #0x21          ; compare a with value -00100001-
           bhi  LA6A1          ; branch if higher
           ldab #0x02          ; load b with value -00000010-
           stab KeyOnOrEngineRunningTime    ; store b into memory
           bra  LA6A5          ; branch

   LA6A1:  bclr *BitFlags70, #b70_O2Enable    ; clear bits
           clra                ; a = 0
   LA6A5:  staa ATMOffset      ; store a into memory
           tab                 ; b = a
           lslb            
           beq  LA6B6          ; branch if equal (zero)
           ldx  #ATMFunctionTable    ; load index with value
           abx                 ; add b to index
           ldx  0x00, X    
           cpx  #LA6B6         ;  -10100110 10110110-
           bne  LA672          ; branch if not equal (not zero)
   LA6B6:  clra                ; a = 0
           staa ATMOffset      ; store a into memory
           jmp  SerialOutput1

SendDiagnosticDataToSCI:
           clrb                ; b = 0
           stab Temp0          ; store b into memory
           stab DRBPointer1    ; store b into memory
           ldab DRBPointer2    ; load b with memory contents
           beq  LA6DE          ; branch if equal (zero)
           cmpb #0x40          ;  -01000000-
           bcc  LA6F6          ; branch if greater or equal
           cmpb #0x2b          ;  -00101011-
           bhi  LA6DE          ; branch if higher
           cmpb #0x10          ;  -00010000-
           bne  SendRealTImeDatatoSCI    ; branch if not equal (not zero)
           brset *BitFlags66, #b66_OffIdle, LA6DE    ; branch if bit(s) set
           brset *BitFlags_AIS, #b10_ATXInGear, LA6DE    ; branch if bit(s) set
           bset *BitFlags6C, #b6c_DRBModeFlag    ; set bits
           bra  SendRealTImeDatatoSCI    ; branch

   LA6DE:  bclr *BitFlags6C, #b6c_DRBModeFlag    ; clear bits
           clra                ; a = 0
           staa DRBPointer1    ; store a into memory
           rts                 ; return from subroutine

SendRealTImeDatatoSCI:
           ldx  #DRBMemoryTable-2    ; load index with value
           lslb            
           abx                 ; add b to index
           ldx  0x00, X    
           cpx  #Temp0         ;  -00000000 11110111-
           beq  LA6DE          ; branch if equal (zero)
           ldaa 0x00, X        ; load a with memory at index + value
           jmp  SerialOutput1a

   LA6F6:  subb #0x40          ;  -01000000-
           cmpb #0x07          ;  -00000111-
           bhi  LA6DE          ; branch if higher
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
   LA70D:  deca                ; decrement a
           bne  LA70D          ; branch if not equal (not zero)
           ldaa CPU_A2DResults1    ; load a with memory contents
           cli                 ; enable interrupts
           bra  LA71F          ; branch

SCI_Speed:
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           bcc  LA71F          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LA71F:  jmp  SerialOutput1a

SCI_O2Volts:
           ldab O2SensorVolts    ; load b with memory contents
           ldaa #0xff          ; load a with value -11111111-
           cmpb O2HIGH_HighLimitForImmediateSwitchToClosedLoop    ; compare b with memory contents (data is 26)
           bhi  LA732          ; branch if higher
           cmpb O2LOW_LowLimitForImmediateSwitchToClosedLoop          ; compare b with memory contents (data is 0f)
           bhi  LA71F          ; branch if higher
           anda #0xa0          ; AND a with value -10100000-
   LA732:  anda #0xb1          ; AND a with value -10110001-
           bra  LA71F          ; branch

EndRealTimeData:
           clra                ; a = 0
           brset *BitFlags66, #b66_OffIdle, SerialOutput1a    ; branch if bit(s) set
           brset *BitFlags6D, #b6d_FuelEngineNotRunning, SerialOutput1a    ; branch if bit(s) set
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
           bcc  LA75C          ; branch if greater or equal
           clra                ; a = 0
   LA75C:  ldab #0xfd          ; load b with value -11111101-
           staa Temp0          ; store a into memory
           mul                 ; multiply (d=a*b)
           adca Temp0      
           bcc  LA767          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LA767:  jmp  SerialOutput1a

SendAdvance:
           ldaa CalculatedSparkAdvance    ; load a with memory contents
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
           bpl  LA787          ; branch if plus (hi bit 0)
           lslb            
           lslb            
           stab DRBPointer2    ; store b into memory
   LA787:  abx                 ; add b to index
           ldaa 0x00, X        ; load a with memory at index + value
           inc  DRBPointer2
           brclr *DRBPointer2, #$%00000011, LA793    ; branch if bit(s) clear
           bra  SerialOutput1a    ; branch

   LA793:  bsr  SerialOutput1a    ; call subroutine
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

   LA7AE:  clra                ; a = 0
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
           bhi  LA7C7          ; branch if higher
           jmp  SerialOutput1

   LA7C7:  ldaa BitFlags65     ; load a with memory contents
           inca                ; increment a
           cmpa #0x18          ; compare a with value -00011000-
           bls  LA7DF          ; branch if lower or same
           ldaa CPU_EEPROMControlReg    ; load a with memory contents
           bita #0x01          ;  -00000001-
           bne  LA7E1          ; branch if not equal (not zero)
           jsr  ERASE_ERROR_CODES    ; call subroutine
           clra                ; a = 0
           staa BitFlags65     ; store a into memory
           ldaa #0xe0          ; load a with value -11100000-
           bra  SerialOutput1a    ; branch

   LA7DF:  staa BitFlags65     ; store a into memory
   LA7E1:  ldaa #0xff          ; load a with value -11111111-
           bra  SerialOutput1a    ; branch

SwitchTest:
           clr  DRBPointer1    ; zero byte at memory location
           ldab DRBPointer2    ; load b with memory contents
           beq  LA81E          ; branch if equal (zero)
           cmpb #0x03          ;  -00000011-
           bhi  LA81E          ; branch if higher
           ldx  #SwitchTestTable-2    ; load index with value
           lslb            
           abx                 ; add b to index
           ldx  0x00, X    
           jmp  0x00, X        ; indexed jump

SendSwitchStateToSerial:
           ldaa StartupSwitchMirror1    ; load a with memory contents
           anda #0x7f          ; AND a with value -01111111-
           ldab SwitchPortAccessReg1    ; load b with memory contents
           bitb #0x20          ;  -00100000-
           beq  SerialOutput1a    ; branch if equal (zero)
           oraa #0x80          ;  -10000000-
           bra  SerialOutput1a    ; branch

SendOutputStatusToSerial:
           ldaa PIA2_Buffer    ; load a with memory contents
           oraa #pi2_VNTSol          ;  -10000000-
           brclr *CurrentWastegatePosition, #$%11111111, LA812    ; branch if bit(s) clear
           anda #~pi2_VNTSol          ; AND a with value -01111111-
   LA812:  bra  SerialOutput1a    ; branch

SendOutputStatusToSerial2:
           ldaa PIA1_Buffer    ; load a with memory contents
           bra  SerialOutput1a    ; branch

InitByteModeDownload:
           bset *DRBSerialMode, #bbe_ByteMode    ; set bits
           clr  DRBPointer1    ; zero byte at memory location
   LA81E:  rts                 ; return from subroutine

DRB_ResetEMR:
           clr  DRBPointer1    ; zero byte at memory location
           sei                 ; disable interrupts
           ldab BitFlags6A     ; load b with memory contents
           bitb #b6a_DRBToggle2 | b6a_DRBToggle1          ;  -00000011-
           bne  LA837          ; branch if not equal (not zero)
           bset *BitFlags6A, #b6a_DRBToggle1    ; set bits
           cli                 ; enable interrupts
           ldaa DRBPointer3    ; load a with memory contents
           staa DRBOffsetStored_LB    ; store a into memory
           ldab DRBPointer2    ; load b with memory contents
           stab DRBOffsetStored_HB    ; store b into memory
           ldaa #0xe2          ; load a with value -11100010-
   LA837:  cli                 ; enable interrupts
           jmp  SerialOutput1a

DRB_UseRAMForSpecialProgramRoutine:
           ldx  #0x0000         ; load index with value
           bra  LA85F          ; branch

DRB_UseRAM2ForSpecialProgramRoutine:
           ldx  #0x6080    ; load index with value
           bra  LA85F          ; branch

DRB_CheckSpecialProgramSize:  
           ldaa DRBPointer2    ; load a with memory contents
           bne  LA711          ; branch if not equal (not zero)
           ldx  #DRB_ProgramModeFlag         ; load index with value
           ldab DRBPointer3    ; load b with memory contents
           abx                 ; add b to index
           cpx  #0x60c9        ;  -01100000 11001001-
           bcs  LA711    ; branch if lower
           ldaa #0xff          ; load a with value -11111111-
           staa DRB_ProgramModeFlag      
   LA859:  jmp  LA7AE      

   LA711:  ldx  #DRB_ProgramModeFlag         ; load index with value
   LA85F:  clra                ; a = 0
           staa DRBPointer1    ; store a into memory
           ldab DRBPointer2    ; load b with memory contents
           ldaa DRBPointer3    ; load a with memory contents
           abx                 ; add b to index
           staa 0x00, X    
           ldaa #0xe5          ; load a with value -11100101-
           jmp  SerialOutput1a

DRB_SpecialProgramMode:
           ldx  #DRB_ProgramModeFlag         ; load index with value
           ldab DRBPointer3    ; load b with memory contents
           cmpb 0x01, X    
           beq  LA87C          ; branch if equal (zero)
           comb            
           cmpb 0x01, X    
           bne  DRB_OutputSpecialCodes          ; branch if not equal (not zero)
   LA87C:  ldab DRBPointer2    ; load b with memory contents
           cmpb 0x00, X    
           bne  LA8AC          ; branch if not equal (not zero)
           abx                 ; add b to index
           ldaa 0x01, X        ; load a with memory at index + value
           cmpa #0x39          ; compare a with value -00111001-
           bne  LA859          ; branch if not equal (not zero)
           ldx  #DRB_ProgramModeFlag         ; load index with value
           clra                ; a = 0
   LA88D:  inx                 ; increment index (x=x+1)
           adda 0x01, X    
           decb            
           bne  LA88D          ; branch if not equal (not zero)
           cmpa DRBPointer3    ; compare a with memory contents
           beq  LA8A0          ; branch if equal (zero)
           ldab DRBPointer3    ; load b with memory contents
           comb            
           cba             
           bne  DRB_OutputSpecialCodes          ; branch if not equal (not zero)
           jmp  DRB_SpecialProgramRoutine

   LA8A0:  com  DRBPointer3
           ldaa #0xe4          ; load a with value -11100100-
           jmp  SerialOutput1a

DRB_OutputSpecialCodes:
           ldaa #0x01          ; load a with value -00000001-
           bra  LA8B2          ; branch

   LA8AC:  ldaa #0x02          ; load a with value -00000010-
           bra  LA8B2          ; branch

   LA8B0:  ldaa #0x03          ; load a with value -00000011-
   LA8B2:  clrb                ; b = 0
           stab DRBPointer1    ; store b into memory
           jmp  SerialOutput1a

DRB_Special1:
           clr  DRBPointer1    ; zero byte at memory location
           ldaa DRBPointer2    ; load a with memory contents
           bne  LA8C6          ; branch if not equal (not zero)
           clra                ; a = 0
   LA8C0:  bclr *BitFlags6C, #$%00100000    ; clear bits
           jmp  SerialOutput1a

   LA8C6:  ldaa #0x02          ; load a with value -00000010-
           brset *BitFlags66, #b66_OffIdle, LA8C0    ; branch if bit(s) set
           ldaa #0x03          ; load a with value -00000011-
           brset *BitFlags_AIS, #b10_ATXInGear, LA8C0    ; branch if bit(s) set
           bset *BitFlags6C, #$%00100000    ; set bits
           ldaa #0x01          ; load a with value -00000001-
           jmp  SerialOutput1a

DRB_Special2:
           ldaa DRBPointer3    ; load a with memory contents
           beq  LA8FF          ; branch if equal (zero)
           ldaa DRBPointer2    ; load a with memory contents
           cmpa #0x01          ; compare a with value -00000001-
           beq  LA8F7          ; branch if equal (zero)
           cmpa #0x02          ; compare a with value -00000010-
           beq  LA8FB          ; branch if equal (zero)
           cmpa #0x03          ; compare a with value -00000011-
           bne  LA903          ; branch if not equal (not zero)
           ldd  TargetIdleSpeedHB    ; load d (a&b) with memory contents
   LA8EE:  stab Temp0          ; store b into memory
           jsr  SerialOutput1a    ; call subroutine
           ldaa Temp0          ; load a with memory contents
           bra  LA8B2          ; branch

   LA8F7:  ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           bra  LA8EE          ; branch

   LA8FB:  ldd  InjectorPulsewidth_HB    ; load d (a&b) with memory contents
           bra  LA8EE          ; branch

   LA8FF:  coma            
           staa DRBPointer3    ; store a into memory
           rts                 ; return from subroutine

   LA903:  clra                ; a = 0
           staa DRBPointer1    ; store a into memory
           rts                 ; return from subroutine

DRB_ClearAdaptiveMemory:
           clra                ; a = 0
           staa DRBPointer1    ; store a into memory
           ldaa TimerOverflowsBetweenCamPulses    ; load a with memory contents
           cmpa #0x50          ; compare a with value -01010000-
           bhi  LA913          ; branch if higher
           jmp  SerialOutput1

   LA913:  ldaa DRBPointer2    ; load a with memory contents
           cmpa #0x01          ; compare a with value -00000001-
           beq  LA960          ; branch if equal (zero)
           cmpa #0x02          ; compare a with value -00000010-
           beq  LA93C          ; branch if equal (zero)
           cmpa #0x03          ; compare a with value -00000011-
           beq  LA931          ; branch if equal (zero)
           cmpa #0x04          ; compare a with value -00000100-
           beq  LA92A          ; branch if equal (zero)
           ldaa #0x01          ; load a with value -00000001-
           jmp  SerialOutput1a

   LA92A:  ldaa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load a with memory contents (data is 5c)
           staa MINTHR_LowestSessionTPS    ; store a into memory
           bra  LA969          ; branch

   LA931:  sei                 ; disable interrupts
           bset *BitFlags_AIS, #b10_UseAIS    ; set bits
           ldaa #0xdf          ; load a with value -11011111-
           staa CurrentAisPosition    ; store a into memory
           cli                 ; enable interrupts
           bra  LA969          ; branch

   LA93C:  clra                ; a = 0
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
   LA956:  staa 0x00, X    
           inx                 ; increment index (x=x+1)
           cpx  #ErrorBitRegister0    ;  -00000000 00011111-
           bcs  LA956          ; branch if lower
           bra  LA969          ; branch

   LA960:  ldaa CPU_EEPROMControlReg    ; load a with memory contents
           bita #0x01          ;  -00000001-
           bne  LA96D          ; branch if not equal (not zero)
           bsr  ERASE_ERROR_CODES    ; call subroutine
   LA969:  ldaa #0xf0          ; load a with value -11110000-
           bra  LA96F          ; branch

   LA96D:  ldaa #0x02          ; load a with value -00000010-
   LA96F:  jmp  SerialOutput1a

ERASE_ERROR_CODES:
           clra                ; a = 0
           clrb                ; b = 0
           stD *ErrorBitRegister0    ; store D to RAM
           stD *ErrorBitRegister2    ; store D to RAM
           stD *ErrorBitRegisterStored0    ; store D to RAM
           stD *ErrorBitRegisterStored2    ; store D to RAM
           staa b5C_IPL1       ; store a into memory
           staa b5D_IPL2       ; store a into memory
           staa ErrorCodeUpdateKeyOnCount    ; store a into memory
           staa ErrorCodeUpdateKeyOnCount2    ; store a into memory
           staa ErrorCodeUpdateKeyOnCount3    ; store a into memory
           staa DRBPointer1    ; store a into memory
           ldaa LB620          ; load a with memory contents (data is ff)
           inca                ; increment a
           beq  LA9BF          ; branch if equal (zero)
           ldx  #0xB620         ; load index with value
           bsr  LA9A0          ; call subroutine
           ldx  #0xb630        ; load index with value
           bsr  LA9A0          ; call subroutine
           ldx  #0xb640        ; load index with value
           bsr  LA9A0          ; call subroutine
           ldx  #0xb650        ; load index with value
   LA9A0:  brset  0, X, #$%11111111, LA9BF    ; branch if bit(s) set
           ldaa #0x0e          ; load a with value -00001110-
           staa CPU_EEPROMControlReg
           stab 0x00, X    
           inca                ; increment a
           staa CPU_EEPROMControlReg
           ldx  #0x1a0a        ; load index with value
   LA9B2:  dex                 ; decrement index (x=x-1)
           bne  LA9B2          ; branch if not equal (not zero)
           deca                ; decrement a
           staa CPU_EEPROMControlReg
           clr  CPU_EEPROMControlReg    ; zero byte at memory location
           jmp  OCToggleAndResetCopTimer

   LA9BF:  rts                 ; return from subroutine

ActuatorTestMode_MM:
           ldaa ATMOffset      ; load a with memory contents
           beq  LA9CD          ; branch if equal (zero)
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa #0x99          ; compare a with value -10011001-
           bcs  LA9CE          ; branch if lower
           clrb                ; b = 0
           stab ATMOffset      ; store b into memory
   LA9CD:  rts                 ; return from subroutine

   LA9CE:  ldaa PIA1_Buffer    ; load a with memory contents
           ldx  #ATMFunctionTable    ; load index with value
           ldab ATMOffset      ; load b with memory contents
           lslb            
           abx                 ; add b to index
           ldx  0x00, X    
           jmp  0x00, X        ; indexed jump

ATM_FanRelay:
           anda #0xdf          ; AND a with value -11011111-
           brclr *Counter_MainLoop, #$%01110000, ATM_SetOutputBits    ; branch if bit(s) clear
           oraa #0x20          ;  -00100000-
           bra  ATM_SetOutputBits    ; branch

ATM_ACClutchRelay:
           ldaa PIA2_Buffer    ; load a with memory contents
           oraa #pi2_ACRelay          ;  -00001000-
           ldab CONFIG_ConfigurationFlags    ; load b with memory contents (data is 97)
           bitb #0x80          ;  -10000000-
           beq  LA9F3          ; branch if equal (zero)
           bclr *PIA1_Buffer, #pi1_Fan    ; clear bits
   LA9F3:  brset *Counter_MainLoop, #$%10000000, LA9F9    ; branch if bit(s) set
           anda #0xf7          ; AND a with value -11110111-
   LA9F9:  jmp  LAA72      

ATM_ASDRelay:
           ldab CPU_TimerControlReg1    ; load b with memory contents
           andb #0xea          ;  -11101010-
           orab #0x2a          ;  -00101010-
           stab CPU_TimerControlReg1    ; store b into memory
           ldab #0x08          ; load b with value -00001000-
           stab CPU_HardwareTimerForceCompare    ; store b into memory
           oraa #0x10          ;  -00010000-
           brset *Counter_MainLoop, #$%10000000, ATM_SetOutputBits    ; branch if bit(s) set
   LAA11:  anda #0xef          ; AND a with value -11101111-
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
           brset *Counter_MainLoop, #$%10000000, LAA27    ; branch if bit(s) set
           ldaa #0xc8          ; load a with value -11001000-
   LAA27:  cmpb #0x22          ;  -00100010-
           beq  LAA2F          ; branch if equal (zero)
           cmpb #0x40          ;  -01000000-
           bne  LAA3B          ; branch if not equal (not zero)
   LAA2F:  staa CurrentWastegatePosition    ; store a into memory
           beq  LAA37          ; branch if equal (zero)
           bclr *PIA2_Buffer, #pi2_VNTSol    ; clear bits
           rts                 ; return from subroutine

   LAA37:  bset *PIA2_Buffer, #pi2_VNTSol    ; set bits
           rts                 ; return from subroutine

   LAA3B:  rts                 ; return from subroutine

ATM_PTUIndicator:
           ldaa PIA2_Buffer    ; load a with memory contents
           oraa #pi2_PTU          ;  -00000100-
           brset *Counter_MainLoop, #$%10000000, LAA72    ; branch if bit(s) set
           anda #~pi2_PTU          ; AND a with value -11111011-
           bra  LAA72          ; branch

ATM_SCServoSolenoid:
           ldaa PIA2_Buffer    ; load a with memory contents
           oraa #pi2_SCVent | pi2_SCVac          ;  -00000011-
           ldab Counter_MainLoop    ; load b with memory contents
           cmpb #0x55          ;  -01010101-
           bcs  LAA72          ; branch if lower
           anda #~(pi2_SCVent | pi2_SCVac)          ; AND a with value -11111100-
           cmpb #0xaa          ;  -10101010-
           bcs  LAA72          ; branch if lower
           oraa #0x02          ;  -00000010-
           bra  LAA72          ; branch

   LAA5C:  ldaa PIA2_Buffer    ; load a with memory contents
           anda #~pi2_EGRSol          ; AND a with value -11011111-
           brset *Counter_MainLoop, #$%10000000, LAA72    ; branch if bit(s) set
           oraa #pi2_EGRSol          ;  -00100000-
           bra  LAA72          ; branch

ATM_BaroReadSolenoid:
           ldaa PIA2_Buffer    ; load a with memory contents
           anda #~pi2_Baro          ; AND a with value -11101111-
           brset *Counter_MainLoop, #$%10000000, LAA72    ; branch if bit(s) set
           oraa #pi2_Baro          ;  -00010000-
   LAA72:  staa PIA2_Buffer    ; store a into memory
           rts                 ; return from subroutine

ATM_AllSolenoidsRelays:
           ldab CPU_TimerControlReg1    ; load b with memory contents
           andb #0xea          ;  -11101010-
           orab #0x2a          ;  -00101010-
           stab CPU_TimerControlReg1    ; store b into memory
           ldab #0x08          ; load b with value -00001000-
           stab CPU_HardwareTimerForceCompare    ; store b into memory
           ldaa #0x50          ; load a with value -01010000-
           ldab DRBPointer1    ; load b with memory contents
           cmpb #0x18          ;  -00011000-
           bne  LAA8E          ; branch if not equal (not zero)
           ldaa #0x40          ; load a with value -01000000-
   LAA8E:  ldab #0x70          ; load b with value -01110000-
           brclr *Counter_MainLoop, #$%10000000, LAA9B    ; branch if bit(s) clear
           coma            
           anda PIA1_Buffer    ; logical and a with memory contents
           ldab #0x10          ; load b with value -00010000-
           bra  LAA9D          ; branch

   LAA9B:  oraa PIA1_Buffer    ; OR a with memory contents
   LAA9D:  staa PIA1_Buffer    ; store a into memory
           stab DesiredNewAisPosition    ; store b into memory
           ldaa PIA2_Buffer    ; load a with memory contents
           oraa #0x37          ;  -00110111-
           anda #0x3f          ; AND a with value -00111111-
           ldab #0xc8          ; load b with value -11001000-
           brset *Counter_MainLoop, #$%10000000, LAAB2    ; branch if bit(s) set
           anda #0xc8          ; AND a with value -11001000-
           oraa #0xc0          ;  -11000000-
           clrb                ; b = 0
   LAAB2:  staa PIA2_Buffer    ; store a into memory
           stab CurrentWastegatePosition    ; store b into memory
   LAAB6:  ldx  #SwitchPortAccessReg1    ; load index with value
           sei                 ; disable interrupts
           brclr *Counter_MainLoop, #$%10000000, LAAC6    ; branch if bit(s) clear
           bset  0, X, #$%00000100    ; bit set
           bset *BitFlags6f, #b6f_BadASD    ; set bits
           bra  LAACC          ; branch

   LAAC6:  bclr  0, X, #$%00000100    ; bit clear
           bclr *BitFlags6f, #b6f_BadASD    ; clear bits
   LAACC:  bset  2, X, #$%00000100    ; bit set
           ldaa #0x08          ; load a with value -00001000-
   LAAD1:  deca                ; decrement a
           bne  LAAD1          ; branch if not equal (not zero)
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
           brset *Counter_MainLoop, #$%10000000, LAAEB    ; branch if bit(s) set
           ldaa #0x70          ; load a with value -01110000-
   LAAEB:  staa DesiredNewAisPosition    ; store a into memory
           rts                 ; return from subroutine

ATM_IgnitionCoil1:
           bclr *PIA1_Buffer, #pi1_ASD    ; clear bits
           ldab Counter_MainLoop    ; load b with memory contents
           lslb            
           bne  LAB16          ; branch if not equal (not zero)
           sei                 ; disable interrupts
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           oraa #0x03          ;  -00000011-
           staa CPU_TimerControlReg1
           ldab #0x08          ; load b with value -00001000-
           stab CPU_HardwareTimerForceCompare    ; store b into memory
           ldd  CPU_TimerCounterRegHigh
           addd #0x09c4        ;  -00001001 11000100-
           std  CPU_Timer_OC5_DwellB
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           anda #0x3e          ; AND a with value -00111110-
           staa CPU_TimerControlReg1
           cli                 ; enable interrupts
   LAB16:  rts                 ; return from subroutine

ATM_IgnitionCoil2:
           bclr *PIA1_Buffer, #pi1_ASD    ; clear bits
           ldab Counter_MainLoop    ; load b with memory contents
           lslb            
           bne  LAB3F          ; branch if not equal (not zero)
           sei                 ; disable interrupts
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           oraa #0x0c          ;  -00001100-
           staa CPU_TimerControlReg1
           ldab #0x10          ; load b with value -00010000-
           stab CPU_HardwareTimerForceCompare    ; store b into memory
           ldd  CPU_TimerCounterRegHigh
           addd #0x09c4        ;  -00001001 11000100-
           std  CPU_Timer_OC5_DwellB
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           anda #0x3b          ; AND a with value -00111011-
           staa CPU_TimerControlReg1
           cli                 ; enable interrupts
   LAB3F:  rts                 ; return from subroutine

ATM_InjBank1:
           ldx  #InjectorPulsewidth_HB_Cyl1    ; load index with value
           bra  LAB52          ; branch

ATM_InjBank2:
           ldx  #InjectorPulsewidth_HB_Cyl2    ; load index with value
           bra  LAB52          ; branch

ATM_InjBank3:
           ldx  #InjectorPulsewidth_HB_Cyl3    ; load index with value
           bra  LAB52          ; branch

ATM_InjBank4:
           ldx  #InjectorPulsewidth_HB_Cyl4    ; load index with value
   LAB52:  ldaa Counter_MainLoop    ; load a with memory contents
           lsla                ; logical shift left a
           bne  LAB5C          ; branch if not equal (not zero)
           ldd  #Temp3         ; load d (a&b) with value -00000000 11111010-
           std  0x00, X        ; store d into index plus offset
   LAB5C:  bclr *PIA1_Buffer, #pi1_ASD    ; clear bits
           rts                 ; return from subroutine

CaculateChecksum:
           ldx  #ENDIT1_PNPrefix    ; load index with value
           ldd  #0x9200        ; load d (a&b) with value -10010010 00000000-
           stD *Temp0          ; store D to RAM
           clra                ; a = 0
   LAB69:  ldab #0x08          ; load b with value -00001000-
           cpx  #LB600         ;  -10110110 00000000-
           bne  LAB79          ; branch if not equal (not zero)
           inc  Temp0      
           inc  Temp0      
           ldx  #0xb800        ; load index with value
   LAB79:  adda 0x00, X    
           adda 0x01, X    
           adda 0x02, X    
           adda 0x03, X    
           adda 0x04, X    
           adda 0x05, X    
           adda 0x06, X    
           adda 0x07, X    
           abx                 ; add b to index
           cpx  Temp0      
           bne  LAB79          ; branch if not equal (not zero)
           brclr *Temp0, #$%11111111, LAB9F    ; branch if bit(s) clear
           psha                ; push a onto stack
           jsr  OCToggleAndResetCopTimer    ; call subroutine
           ldaa #0x12          ; load a with value -00010010-
           adda Temp0      
           staa Temp0          ; store a into memory
           pula                ; pull a from stack
           bra  LAB69          ; branch

   LAB9F:  cmpa ENDITM_ECUID+1    ; compare a with memory contents (data is 93)
           beq  LABAA          ; branch if equal (zero)
           ldd  #0x0201        ; load d (a&b) with value -00000010 00000001-
           jmp  ThrowNonCriticalError

   LABAA:  rts                 ; return from subroutine

MUCK_WITH_CEL:
           ldaa Counter_MainLoop    ; load a with memory contents
           lsla                ; logical shift left a
           lsla                ; logical shift left a
           bne  LAC07          ; branch if not equal (not zero)
           ldaa LastCamFallingEdgeTime    ; load a with memory contents
           bita #0x70          ;  -01110000-
           beq  LABBD          ; branch if equal (zero)
           suba #0x10          ;  -00010000-
           bita #0x70          ;  -01110000-
           bne  LAC05          ; branch if not equal (not zero)
   LABBD:  ldab PIA1_Buffer    ; load b with memory contents
           eorb #pi1_CEL          ;  -10000000-
           stab PIA1_Buffer    ; store b into memory
           bita #0x0f          ;  -00001111-
           beq  LABD0          ; branch if equal (zero)
           deca                ; decrement a
           bita #0x0f          ;  -00001111-
           beq  LABD0          ; branch if equal (zero)
           oraa #0x10          ;  -00010000-
           bra  LAC05          ; branch

   LABD0:  tsta                ; test a
           bmi  LAC08          ; branch if minus(hi bit 1)
           ldaa #0xaa          ; load a with value -10101010-
           ldab DRBPointer2    ; load b with memory contents
           cmpb #0xfe          ;  -11111110-
           beq  LABF9          ; branch if equal (zero)
           tstb            
           bmi  LAC05          ; branch if minus(hi bit 1)
           cmpb #0x08          ;  -00001000-
           bcs  LABEC          ; branch if lower
           ldx  #0xb618        ; load index with value
           abx                 ; add b to index
           brset  0, X, #$%11111111, LAC4E    ; branch if bit(s) set
           bra  LABF3          ; branch

   LABEC:  negb            
           addb #0x07          ;  -00000111-
           ldx  #ErrorBitRegister0    ; load index with value
           abx                 ; add b to index
   LABF3:  ldab 0x00, X        ; load b with memory at index + value
           beq  LAC05          ; branch if equal (zero)
           bra  LABFA          ; branch

   LABF9:  clrb                ; b = 0
   LABFA:  ldx  #ErrorCodesToDash_Table    ; load index with value
           abx                 ; add b to index
           ldaa 0x00, X        ; load a with memory at index + value
           anda #0x0f          ; AND a with value -00001111-
           lsla                ; logical shift left a
           oraa #0xa0          ;  -10100000-
   LAC05:  staa LastCamFallingEdgeTime    ; store a into memory
   LAC07:  rts                 ; return from subroutine

   LAC08:  ldab DRBPointer2    ; load b with memory contents
           cmpb #0xff          ;  -11111111-
           bne  LAC1A          ; branch if not equal (not zero)
           ldaa ErrorCodeUpdateKeyOnCount    ; load a with memory contents
           cmpa #0x32          ; compare a with value -00110010-
           bhi  LAC1A          ; branch if higher
           decb            
           stab DRBPointer2    ; store b into memory
           clrb                ; b = 0
           bra  LAC3F          ; branch

   LAC1A:  cmpb #0xfe          ;  -11111110-
           bne  LAC1F          ; branch if not equal (not zero)
           incb            
   LAC1F:  incb            
           stab DRBPointer2    ; store b into memory
           cmpb #0x08          ;  -00001000-
           bcs  LAC34          ; branch if lower
           brset *DRBPointer2, #$%10000000, LAC55    ; branch if bit(s) set
           ldx  #0xb618        ; load index with value
           abx                 ; add b to index
           brset  0, X, #$%11111111, LAC4E    ; branch if bit(s) set
           bra  LAC3B          ; branch

   LAC34:  negb            
           addb #0x07          ;  -00000111-
           ldx  #ErrorBitRegister0    ; load index with value
           abx                 ; add b to index
   LAC3B:  ldab 0x00, X        ; load b with memory at index + value
           beq  LAC4E          ; branch if equal (zero)
   LAC3F:  ldx  #ErrorCodesToDash_Table    ; load index with value
           abx                 ; add b to index
           ldaa 0x00, X        ; load a with memory at index + value
           lsra            
           lsra            
           lsra            
           lsra            
           lsla                ; logical shift left a
           oraa #0x40          ;  -01000000-
           bra  LAC05          ; branch

   LAC4E:  bset *DRBPointer2, #$%10000000    ; set bits
           ldaa #0x4a          ; load a with value -01001010-
           bra  LAC05          ; branch

   LAC55:  clra                ; a = 0
           staa DRBPointer1    ; store a into memory
           staa DRBPointer2    ; store a into memory
           rts                 ; return from subroutine


;	.org	0xac5b
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

;	.org	0xac9e
PIA1AManipulation_Table:
	.word	0x0102
	.word	0x0408
	.word	0x1020
	.word	0x4080
	.word	0xFFFF
	.word	0xFFFF
	.word	0x0a0e
	.word	0x12ff
	.word	0xFFFF
	.word	0x0c10
	.word	0x2f11
	.word	0xFF0D
	.word	0xFFFF
	.word	0x3710
	.byte   0x2f

;	.org	0xacbb
ErrorBitManipulation_Table:
	.word	0x1138
	.word	0x0d2b
	.word	0x8908
	.word	0x0120
	.word	0x00FF
	.word	0x7F00
	.word	0x2a89
	.word	0x08ff
	.word	0x7F00
	.word	0xFF7F
	.word	0x00FF
	.word	0x7F00
	.word	0x268a
	.word	0x8001
	.word	0x0101
	.word	0x0118
	.word	0xCE00
	.word	0x0718
	.word	0x0926
	.word	0xFC39

UpdatePIA1AndCheckOuputs_MM:
           ldaa #0x50          ; load a with value -01010000-
           ldab PIA1_Buffer    ; load b with memory contents
           jsr  SetPIAOutputBits    ; call subroutine
           bset *BitFlags6E, #$%00000100    ; set bits
           ldaa #0x70          ; load a with value -01110000-
           ldab #0xff          ; load b with value -11111111-
           jsr  SetPIAOutputBits    ; call subroutine
           bclr *BitFlags6E, #$%00000100    ; clear bits
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
           bsr  LAD6B          ; call subroutine
           clrb                ; b = 0
           ldx  #CONFIG_ConfigurationFlags    ; load index with value
           brclr *PIA2_Buffer, #pi2_ACRelay, LAD25    ; branch if bit(s) clear
           ldaa StartupSwitchMirror1    ; load a with memory contents
           bita #sw1_ACclutch          ;  -01000000-
           brclr  0, X, #$%10000000, LAD21    ; branch if bit(s) clear
           ldaa PIA1_Buffer    ; load a with memory contents
           bita #pi1_Fan          ;  -00100000-
   LAD21:  beq  LAD25          ; branch if equal (zero)
           ldab #0x08          ; load b with value -00001000-
   LAD25:  stab Temp0          ; store b into memory
           ldaa #0xdc          ; load a with value -11011100-
           ldab PIA2_Buffer    ; load b with memory contents
           andb #~pi2_VNTSol          ;  -01111111-
           jsr  SetPIAOutputBits    ; call subroutine
           ldaa #0xd8          ; load a with value -11011000-
           ldab PIA2_Buffer    ; load b with memory contents
           comb            
           andb #~pi2_VNTSol          ;  -01111111-
           jsr  SetPIAOutputBits    ; call subroutine
           bset *BitFlags6E, #$%00000100    ; set bits
           ldaa #0xfc          ; load a with value -11111100-
           ldab #0x7f          ; load b with value -01111111-
           jsr  SetPIAOutputBits    ; call subroutine
           bclr *BitFlags6E, #$%00000100    ; clear bits
           ldaa #0xf0          ; load a with value -11110000-
           ldab Temp0          ; load b with memory contents
           jsr  SetPIAOutputBits    ; call subroutine
           idiv            
           idiv            
           ldd  #0xc0ff        ; load d (a&b) with value -11000000 11111111-
           bset *BitFlags6E, #$%00000100    ; set bits
           jsr  SetPIAOutputBits    ; call subroutine
           bclr *BitFlags6E, #$%00000100    ; clear bits
           staa Temp0          ; store a into memory
           ldaa #0x80          ; load a with value -10000000-
           anda BitFlags6E     ; logical and a with memory contents
           cli                 ; enable interrupts
           ldab PIA2_Buffer    ; load b with memory contents
           andb #~pi2_VNTSol          ;  -01111111-
           aba                 ; a=a+b
           eora Temp0      
           clrb                ; b = 0
   LAD6B:  stab Temp0          ; store b into memory
           ldx  #PIA1AManipulation_Table    ; load index with value
           ldab BatteryVolts    ; load b with memory contents
           cmpb #0xa2          ;  -10100010-
           bcs  LADDF          ; branch if lower
           ldab CountdownTimerFromKeyOn    ; load b with memory contents
           bne  LADDF          ; branch if not equal (not zero)
           ldab Counter_MainLoop    ; load b with memory contents
           andb #0x07          ;  -00000111-
           abx                 ; add b to index
           anda 0x00, X    
           brclr *Temp0, #$%11111111, LAD8E    ; branch if bit(s) clear
           bita PIAMSK_PIA1ADDRMask    ;  (data is 70)
           beq  LADDF          ; branch if equal (zero)
           ldaa 0x08, X        ; load a with memory at index + value
           bra  LAD9E          ; branch

   LAD8E:  bita PIBMSK_PIA1BDDRMask    ;  (data is 98)
           beq  LADDF          ; branch if equal (zero)
           ldaa 0x10, X        ; load a with memory at index + value
           ldab CONFIG2_ConfigurationFlags2    ; load b with memory contents (data is c7)
           bitb #0x08          ;  -00001000-
           beq  LAD9E          ; branch if equal (zero)
           ldaa 0x18, X        ; load a with memory at index + value
   LAD9E:  ldab #0x20          ; load b with value -00100000-
           cmpa #0x11          ; compare a with value -00010001-
           beq  LADD8          ; branch if equal (zero)
           cmpa #0x2f          ; compare a with value -00101111-
           beq  LADD8          ; branch if equal (zero)
           cmpa #0x12          ; compare a with value -00010010-
           beq  LADD8          ; branch if equal (zero)
           cmpa #0x0d          ; compare a with value -00001101-
           beq  LADE0          ; branch if equal (zero)
           cmpa #0x37          ; compare a with value -00110111-
           beq  LADE0          ; branch if equal (zero)
           cmpa #0x38          ; compare a with value -00111000-
           beq  LADE0          ; branch if equal (zero)
           cmpa #0x10          ; compare a with value -00010000-
           bne  LADD6          ; branch if not equal (not zero)
           tst  CONFIG_ConfigurationFlags    ;  (data is 97)
           bpl  LADC7          ; branch if plus (hi bit 0)
           brclr *PIA1_Buffer, #pi1_Fan, LADD6    ; branch if bit(s) clear
           bra  LADDF          ; branch

   LADC7:  brset *BitFlags6D, #b6d_DisableNormalDwell, LADDF    ; branch if bit(s) set
           ldx  KeyOnOrEngineRunningTime
           cpx  #0x0b00        ;  -00001011 00000000-
           bcs  LADDF          ; branch if lower
           brset *StartupSwitchMirror1, #sw1_ACclutch, LADDF    ; branch if bit(s) set
   LADD6:  bra  ThrowNonCriticalError    ; branch

   LADD8:  bsr  ThrowCriticalError    ; call subroutine
           bcc  LADDF          ; branch if greater or equal
           bset *b5D_IPL2, #b5d_MajorFault    ; set bits
   LADDF:  rts                 ; return from subroutine

   LADE0:  brset *b5D_IPL2, #b5d_WGSolFault, LADDF    ; branch if bit(s) set
           ldab #0xa0          ; load b with value -10100000-
           bsr  ThrowNonCriticalError    ; call subroutine
           bcc  LADDF          ; branch if greater or equal
           bset *b5D_IPL2, #b5d_WGSolFault    ; set bits
           rts                 ; return from subroutine

ThrowCriticalError:
           ldx  #CONFIG_ConfigurationFlags    ; load index with value
           brclr  0, X, #$%01000000, ThrowNonCriticalError    ; branch if bit(s) clear
           brset *b5D_IPL2, #b5d_MajorFault, ThrowNonCriticalError    ; branch if bit(s) set
           orab #0x80          ;  -10000000-
ThrowNonCriticalError:
           ldx  #FLTMSK1_ErrorBitsMask1    ; load index with value
   LADFE:  brclr  0, X, #$%11111111, LAE09    ; branch if bit(s) clear
           cmpa 0x00, X        ; compare a with memory at index + value
           beq  LAE4C          ; branch if equal (zero)
           inx                 ; increment index (x=x+1)
           bra  LADFE          ; branch

   LAE09:  tstb            
           bmi  LAE14          ; branch if minus(hi bit 1)
           cmpa ErrorBitRegisterStored3    ; compare a with memory contents
           beq  LAE49          ; branch if equal (zero)
           cmpa ErrorBitRegisterStored2    ; compare a with memory contents
           beq  LAE3F          ; branch if equal (zero)
   LAE14:  andb #0x7f          ;  -01111111-
           cmpb #0x01          ;  -00000001-
           beq  LAE53          ; branch if equal (zero)
           stab Temp0          ; store b into memory
           ldx  #ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB    ; load index with value
           cmpa 0x00, X        ; compare a with memory at index + value
           beq  LAE31          ; branch if equal (zero)
           inx                 ; increment index (x=x+1)
           cmpa 0x00, X        ; compare a with memory at index + value
           beq  LAE31          ; branch if equal (zero)
           tst  0x00, X    
           beq  LAE31          ; branch if equal (zero)
           dex                 ; decrement index (x=x-1)
           tst  0x00, X    
           bne  LAE4C          ; branch if not equal (not zero)
   LAE31:  staa 0x00, X    
           inc  0x02, X    
           beq  LAE4F          ; branch if equal (zero)
           cmpb 0x02, X    
           bcs  LAE4F          ; branch if lower
           ldab 0x02, X        ; load b with memory at index + value
           clc                 ; clear carry
           rts                 ; return from subroutine

   LAE3F:  ldd  ErrorBitRegisterStored2    ; load d (a&b) with memory contents
           staa ErrorBitRegisterStored3    ; store a into memory
           stab ErrorBitRegisterStored2    ; store b into memory
           ldaa ErrorCodeUpdateKeyOnCount    ; load a with memory contents
           staa ErrorCodeUpdateKeyOnCount2    ; store a into memory
   LAE49:  clra                ; a = 0
           staa ErrorCodeUpdateKeyOnCount    ; store a into memory
   LAE4C:  clra                ; a = 0
           clc                 ; clear carry
           rts                 ; return from subroutine

   LAE4F:  clr  0x00, X    
           clr  0x02, X    
   LAE53:  ldx  #ErrorBitRegister0    ; load index with value
   LAE56:  cmpa 0x00, X        ; compare a with memory at index + value
           bne  LAE5F          ; branch if not equal (not zero)
           clrb                ; b = 0
           stab 0x00, X    
           bra  LAE67          ; branch

   LAE5F:  inx                 ; increment index (x=x+1)
           cpx  #ErrorBitRegisterStored3    ;  -00000000 00100110-
           bls  LAE56          ; branch if lower or same
           ldab #0xff          ; load b with value -11111111-
   LAE67:  stab Temp0          ; store b into memory
           ldx  #ErrorBitRegisterStored3    ; load index with value
           ldY #ErrorCodeUpdateKeyOnCount    ; load Y index -00000000 00100111-
   LAE70:  cpx  #ErrorBitRegisterStored1    ;  -00000000 00100100-
           bcs  LAE83          ; branch if lower
           psha                ; push a onto stack
           ldaB 0x00, Y       ; load B with value indexed to Y -00000000-
           ldaa Temp0          ; load a with memory contents
           staA 0x00, Y       ; store A with value indexed to Y -00000000-
           inY                 ; increment Y
           stab Temp0          ; store b into memory
           pula                ; pull a from stack
   LAE83:  ldab 0x00, X        ; load b with memory at index + value
           staa 0x00, X    
           tba                 ; a = b
           beq  LAEBF          ; branch if equal (zero)
           dex                 ; decrement index (x=x-1)
           cpx  #ErrorBitRegister0    ;  -00000000 00011111-
           bcc  LAE70          ; branch if greater or equal
           clrb                ; b = 0
           stab ErrorCodeUpdateKeyOnCount    ; store b into memory
           sei                 ; disable interrupts
           ldab BitFlags6A     ; load b with memory contents
           bitb #b6a_DRBToggle2 | b6a_DRBToggle1          ;  -00000011-
           bne  LAEBC          ; branch if not equal (not zero)
           bset *BitFlags6A, #b6a_DRBToggle1    ; set bits
           cli                 ; enable interrupts
           staa DRBOffsetStored_LB    ; store a into memory
           ldx  #0xb61f        ; load index with value
   LAEA3:  inx                 ; increment index (x=x+1)
           cpx  #0xb660        ;  -10110110 01100000-
           beq  LAEB9          ; branch if equal (zero)
           ldab 0x00, X        ; load b with memory at index + value
           cba             
           beq  LAEB9          ; branch if equal (zero)
           incb            
           bne  LAEA3          ; branch if not equal (not zero)
           xgDX                ; exchange D and X
           subd #LB600         ;  -10110110 00000000-
           stab DRBOffsetStored_HB    ; store b into memory
           bra  LAEBC          ; branch

   LAEB9:  bclr *BitFlags6A, #b6a_DRBToggle1    ; clear bits
   LAEBC:  cli                 ; enable interrupts
           bra  LAED1          ; branch

   LAEBF:  cpY  #ErrorCodeUpdateKeyOnCount3         ; branch if bit(s) clear -10001100-
           bhi  LAECE          ; branch if higher
           ldab ErrorCodeUpdateKeyOnCount    ; load b with memory contents
           beq  LAED1          ; branch if equal (zero)
           ldab Temp0          ; load b with memory contents
           staB 0x00, Y       ; store B to location indexed to Y -00000000-
   LAECE:  clrb                ; b = 0
           stab ErrorCodeUpdateKeyOnCount    ; store b into memory
   LAED1:  sec                 ; set carry
   LAED2:  rts                 ; return from subroutine

ProcessErrorBits_WorkWithData_MM:
           brclr *BitFlags5E, #$%11111111, LAED2    ; branch if bit(s) clear
           ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           bne  LAED2          ; branch if not equal (not zero)
           clra                ; a = 0
           clrb                ; b = 0
           sec                 ; set carry
   LAEDE:  rola            
           bcs  LAED2          ; branch if lower
           addb #0x03          ;  -00000011-
           bita BitFlags5E 
           beq  LAEDE          ; branch if equal (zero)
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
           bpl  LAEFC          ; branch if plus (hi bit 0)
           bset *Temp4, #$%10000000    ; set bits

   LAEFC:  jsr  ThrowNonCriticalError    ; call subroutine
           brclr *Temp4, #$%10000000, LAF15    ; branch if bit(s) clear
           bcc  LAF15          ; branch if greater or equal
           ldx  #ErrorBitManipulation_Table    ; load index with value
           ldab Temp4          ; load b with memory contents
           andb #0x7f          ;  -01111111-
           abx                 ; add b to index
           ldaa 0x02, X        ; load a with memory at index + value
           sei                 ; disable interrupts
           oraa b5C_IPL1       ; OR a with memory contents
           staa b5C_IPL1       ; store a into memory
           cli                 ; enable interrupts
   LAF15:  ldd  Temp3          ; load d (a&b) with memory contents
           andb #0x7f          ;  -01111111-
           clc                 ; clear carry
           bra  LAEDE          ; branch

SimulateMapReadingFromTps:
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb #0x7e          ;  -01111110-
           ldaa #0x00          ; load a with value -00000000-
           bcc  LAF38          ; branch if greater or equal
           subb #0x10          ;  -00010000-
           bcc  LAF29          ; branch if greater or equal
           clrb                ; b = 0
   LAF29:  ldaa #0x52          ; load a with value -01010010-
           mul                 ; multiply (d=a*b)
           adca MINTHR_LowestSessionTPS
           tab                 ; b = a
           ldaa TpsVolts       ; load a with memory contents
           adda THROFF_OffsetAddedToCalcThrottle    ;  (data is 0b)
           sba                 ; subtract (a=a-b)
           bcc  LAF38          ; branch if greater or equal
           clra                ; a = 0
   LAF38:  ldx  #LMPINN_LimpinTableForMapFromThrottle    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           adda MPLMOF_OffsetForCalcMapInMapLimpin    ;  (data is 20)
           rts                 ; return from subroutine

DetectAlternatorFault_MM:
           ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x1f          ;  -00011111-
           bne  LAF69          ; branch if not equal (not zero)
           brset *BitFlags6D, #b6d_FuelEngineNotRunning, LAF69    ; branch if bit(s) set
           ldaa BatteryVolts    ; load a with memory contents
           suba TargetBatteryVolts
           bcs  LAF66          ; branch if lower
           cmpa #0x10          ; compare a with value -00010000-
           bcs  LAF66          ; branch if lower
           brset *b5C_IPL1, #b5c_BattNotCharging, LAF69    ; branch if bit(s) set
           ldd  #0x06a0        ; load d (a&b) with value -00000110 10100000-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LAF69          ; branch if greater or equal
           bset *b5C_IPL1, #b5c_BattNotCharging    ; set bits
           rts                 ; return from subroutine

   LAF66:  bclr *b5C_IPL1, #b5c_BattNotCharging    ; clear bits
   LAF69:  rts                 ; return from subroutine

CheckIfCheckEngineLightShouldBeOn_MM:
           ldab #0x80          ; load b with value -10000000-
           brclr *BitFlags6D, #b6d_FuelEngineNotRunning, LAF8A    ; branch if bit(s) clear
           ldaa DRBPointer1    ; load a with memory contents
           cmpa #0x0a          ; compare a with value -00001010-
           bne  LAF79          ; branch if not equal (not zero)
           jmp  MUCK_WITH_CEL

   LAF79:  cmpa #0x18          ; compare a with value -00011000-
           bne  LAF84          ; branch if not equal (not zero)
           ldaa Counter_MainLoop    ; load a with memory contents
           lsla                ; logical shift left a
           bmi  TurnCheckEngineLightOnAndOff    ; branch if minus(hi bit 1)
           bra  LAFAD          ; branch

   LAF84:  ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           bne  TurnCheckEngineLightOnAndOff    ; branch if not equal (not zero)
           bra  LAFAD          ; branch

   LAF8A:  ldd  KeyOnOrEngineRunningTime    ; load d (a&b) with memory contents
           cmpD #0x0003         ; compare D -00000000 00000011-
           bls  TurnCheckEngineLightOnAndOff    ; branch if lower or same
           brclr *PIA1_Buffer, #pi1_CEL, LAFB4    ; branch if bit(s) clear
           ldaa b5C_IPL1       ; load a with memory contents
           bita IPLMSK_PowerLossLightMask    ;  (data is ff)
           bne  LAFAD          ; branch if not equal (not zero)
           ldx  #CONFIG_ConfigurationFlags    ; load index with value
           ldaa b5D_IPL2       ; load a with memory contents
           brset  0, X, #$%01000000, LAFA8    ; branch if bit(s) set
           anda #0x3f          ; AND a with value -00111111-
   LAFA8:  bita IPLMSK2_PowerLossLightMask2    ;  (data is 38)
           beq  TurnCheckEngineLightOnAndOff    ; branch if equal (zero)
   LAFAD:  bclr *PIA1_Buffer, #pi1_CEL    ; clear bits
           rts                 ; return from subroutine

TurnCheckEngineLightOnAndOff:
           bset *PIA1_Buffer, #pi1_CEL    ; set bits
   LAFB4:  rts                 ; return from subroutine

UpdateErrorTimersAndPossiblyClearErrors_MM:
           ldaa Counter_MainLoop    ; load a with memory contents
           bne  LAFDE          ; branch if not equal (not zero)
           ldd  ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB    ; load d (a&b) with memory contents
           tsta                ; test a
           beq  LAFC6          ; branch if equal (zero)
           dec  ClearTheErrorTimer_0    ; decrement memory contents
           bne  LAFC6          ; branch if not equal (not zero)
           clr  ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB    ; zero byte at memory location
   LAFC6:  tstb            
           beq  LAFD1          ; branch if equal (zero)
           dec  ClearTheErrorTimer_1    ; decrement memory contents
           bne  LAFD1          ; branch if not equal (not zero)
           clr  ErrorBitsAssociatedWithPIA1AndReg1eTo25_LB    ; zero byte at memory location
   LAFD1:  ldaa ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; load a with memory contents
           beq  LAFDE          ; branch if equal (zero)
           suba #0x10          ;  -00010000-
           bita #0xf0          ;  -11110000-
           bne  LAFDC          ; branch if not equal (not zero)
           clra                ; a = 0
   LAFDC:  staa ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; store a into memory
   LAFDE:  ldaa BitFlags6D     ; load a with memory contents
           bita #b6d_FuelEngineNotRunning | b6d_NeedSetup          ;  -10000001-
           bne  LB018          ; branch if not equal (not zero)
           bset *BitFlags6D, #b6d_NeedSetup    ; set bits
           brclr *ErrorBitRegisterStored3, #$%11111111, LB011    ; branch if bit(s) clear
           ldaa ErrorCodeUpdateKeyOnCount    ; load a with memory contents
           cmpa #0x32          ; compare a with value -00110010-
           bcs  LAFFB          ; branch if lower
           ldaa CPU_EEPROMControlReg    ; load a with memory contents
           bita #0x01          ;  -00000001-
           bne  LB018          ; branch if not equal (not zero)
           jmp  ERASE_ERROR_CODES

   LAFFB:  ldaa ErrorBitRegisterStored1    ; load a with memory contents
           beq  LB006          ; branch if equal (zero)
           ldaa ErrorCodeUpdateKeyOnCount3    ; load a with memory contents
           inca                ; increment a
           beq  LB006          ; branch if equal (zero)
           staa ErrorCodeUpdateKeyOnCount3    ; store a into memory
   LB006:  ldaa ErrorBitRegisterStored2    ; load a with memory contents
           beq  LB011          ; branch if equal (zero)
           ldaa ErrorCodeUpdateKeyOnCount2    ; load a with memory contents
           inca                ; increment a
           beq  LB011          ; branch if equal (zero)
           staa ErrorCodeUpdateKeyOnCount2    ; store a into memory
   LB011:  ldaa ErrorCodeUpdateKeyOnCount    ; load a with memory contents
           inca                ; increment a
           beq  LB018          ; branch if equal (zero)
           staa ErrorCodeUpdateKeyOnCount    ; store a into memory
   LB018:  rts                 ; return from subroutine

DetectAlternatorFault_MM_Also:
           ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x1f          ;  -00011111-
           bne  LB055          ; branch if not equal (not zero)
           brset *BitFlags6D, #b6d_FuelEngineNotRunning, LB055    ; branch if bit(s) set
           ldaa BatteryVolts    ; load a with memory contents
           suba TargetBatteryVolts
           bcc  LB03E          ; branch if greater or equal
           bclr *b5C_IPL1, #b5c_BattNotCharging    ; clear bits
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb BTLRPM_LowBatteryVoltageAtThisRpm1500    ; compare b with memory contents (data is 2e)
           bcs  LB055          ; branch if lower
           nega                ; negate a (set high bit)
           cmpa #0x10          ; compare a with value -00010000-
           bcs  LB055          ; branch if lower
           ldd  #0x0555        ; load d (a&b) with value -00000101 01010101-
           jmp  ThrowNonCriticalError

   LB03E:  cmpa #0x10          ; compare a with value -00010000-
           bcs  LB052          ; branch if lower
           brset *b5C_IPL1, #b5c_BattNotCharging, LB055    ; branch if bit(s) set
           ldd  #0x06a0        ; load d (a&b) with value -00000110 10100000-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LB055          ; branch if greater or equal
           bset *b5C_IPL1, #b5c_BattNotCharging    ; set bits
           rts                 ; return from subroutine

   LB052:  bclr *b5C_IPL1, #b5c_BattNotCharging    ; clear bits
   LB055:  rts                 ; return from subroutine

CheckForErrorsAndSetCodes_MM:
           brset *BitFlags6D, #b6d_FuelEngineNotRunning, LB0A7    ; branch if bit(s) set
           ldaa CoolantTemp    ; load a with memory contents
           cmpa ERRTMP_CoolantTempLimitforErrorCodeSetting    ; compare a with memory contents (data is a0)
           bcs  LB0A7          ; branch if lower
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 97)
           bita #0x20          ;  -00100000-
           beq  LB06C          ; branch if equal (zero)
           brclr *BitFlags_AIS, #b10_ATXInGear, LB0A7    ; branch if bit(s) clear
   LB06C:  ldd  KeyOnOrEngineRunningTime    ; load d (a&b) with memory contents
           cmpa #0x0b          ; compare a with value -00001011-
           bcs  LB0A7          ; branch if lower
           bitb #0x1f          ;  -00011111-
           bne  LB0A7          ; branch if not equal (not zero)
           brset *StartupSwitchMirror1, #sw1_Brake, LB0A7    ; branch if bit(s) set
           brclr *BitFlags66, #b66_OffIdle, LB0A7    ; branch if bit(s) clear
           ldaa EngineRpm_HB    ; load a with memory contents
   LB080:  cmpa ERRRPM_RPMLimitforErrorCodeSetting    ; compare a with memory contents (data is 38)
           bcs  LB0A7          ; branch if lower
           ldaa BaroPressure    ; load a with memory contents
           suba MapValue   
           bcc  LB08C          ; branch if greater or equal
           clra                ; a = 0
   LB08C:  cmpa ERRMAP_MAPLimitforErrorCodeSetting    ; compare a with memory contents (data is 2b)
           bcc  LB0A7          ; branch if greater or equal
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           cmpD #Cyl2_InjPWTrim    ; compare D -00000000 00101010-
           bcc  LB0A7          ; branch if greater or equal
           ldd  #0x2320        ; load d (a&b) with value -00100011 00100000-
           jsr  ThrowCriticalError    ; call subroutine
           bcc  LB0A7          ; branch if greater or equal
           bset *b5D_IPL2, #b5d_MajorFault    ; set bits
           bset *BitFlags6B, #$%00100000    ; set bits
   LB0A7:  rts                 ; return from subroutine

ThrowMajorErrorIfRequired_MM:
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 97)
           bita #0x40          ;  -01000000-
           beq  LB0B7          ; branch if equal (zero)
           brclr *BitFlags67, #b67_BadO2, LB0BA    ; branch if bit(s) clear
           bset *b5D_IPL2, #b5d_MajorFault    ; set bits
           rts                 ; return from subroutine

   LB0B7:  bclr *b5D_IPL2, #b5d_EGRSolFault | b5d_MajorFault    ; clear bits
   LB0BA:  rts                 ; return from subroutine


	.org	0xb600
LB600:
	.chem 3 n LB600 in_desc 0 65535 in Y 0 256 out LB600 Detailed_Description
		.byte	0xff

	.org	0xb610
LB610:
	.chem 3 n LB610 in_desc 0 65535 in Y 0 256 out LB610 Detailed_Description
		.byte	0xff

	.org	0xb612
LB612:
	.chem 3 n LB612 in_desc 0 65535 in Y 0 256 out LB612 Detailed_Description
		.byte	0xff

	.org	0xb613
LB613:
	.chem 3 n LB613 in_desc 0 65535 in Y 0 256 out LB613 Detailed_Description
		.byte	0xff

        .org    0xb615
LB615:
	.chem 3 n LB615 in_desc 0 65535 in Y 0 256 out LB615 Detailed_Description
		.byte	0xff

	.org	0xb616
LB616:
	.chem 3 n LB616 in_desc 0 65535 in Y 0 256 out LB616 Detailed_Description
		.byte	0xff

	.org	0xb617
LB617:
	.chem 3 n LB617 in_desc 0 65535 in Y 0 256 out LB617 Detailed_Description
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

        .org    0xB800
LB800:
	.word 0x1513
	.word 0x3D14

VerifyOperationOfFuelInjectorDrivers_MM:
           ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           beq  LB80B          ; branch if equal (zero)
           jmp  LB8A4      

   LB80B:  ldaa SwitchPortAccessReg1    ; load a with memory contents
           bita #0x20          ;  -00100000-
           beq  LB85E          ; branch if equal (zero)
           sei                 ; disable interrupts
           ldaa SwitchPortAccessReg2    ; load a with memory contents
           anda #0xf0          ; AND a with value -11110000-
           bne  LB85E          ; branch if not equal (not zero)
           brclr *BitFlags6E, #b6e_DistSync, LB85E    ; branch if bit(s) clear
           brset *b5D_IPL2, #b5d_InjectorFault, LB855    ; branch if bit(s) set
           ldab #0x04          ; load b with value -00000100-
   LB824:  decb            
           bne  LB824          ; branch if not equal (not zero)
           ldab #0x04          ; load b with value -00000100-
           bitb PIA_Ctrl_4      
           bne  LB857          ; branch if not equal (not zero)
           ldab BitFlags6E     ; load b with memory contents
           ldx  #0xb800        ; load index with value
           brset *BitFlags70, #$%10000000, LB83B    ; branch if bit(s) set
           brset *BitFlags_BF, #$%00000100, LB83C    ; branch if bit(s) set
   LB83B:  decb            
   LB83C:  cli                 ; enable interrupts
           ldx  #LB800        ; load index with value
           andb #0x03          ;  -00000011-
           abx                 ; add b to index
           ldaa 0x00, X        ; load a with memory at index + value
           ldab #0x89          ; load b with value -10001001-
           brset *BitFlags6D, #b6d_FuelEngineNotRunning, LB84D    ; branch if bit(s) set
           ldab #0xa0          ; load b with value -10100000-
   LB84D:  jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LB855          ; branch if greater or equal
           bset *b5D_IPL2, #b5d_InjectorFault    ; set bits
   LB855:  ldab #0x04          ; load b with value -00000100-
   LB857:  cli                 ; enable interrupts
           stab PIA_Ctrl_4          ; store b into memory
           bclr *BitFlags6E, #b6e_DistSync    ; clear bits
   LB85E:  sei                 ; disable interrupts
           ldaa SwitchPortAccessReg1    ; load a with memory contents
           eora BitFlags6f
           cli                 ; enable interrupts
           bita #0x04          ;  -00000100-
           beq  LB878          ; branch if equal (zero)
           brset *b5C_IPL1, #b5c_Bad_BatVolts, LB878    ; branch if bit(s) set
           ldd  #0x0ba0        ; load d (a&b) with value -00001011 10100000-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LB878          ; branch if greater or equal
           bset *b5C_IPL1, #b5c_Bad_BatVolts    ; set bits
   LB878:  bset *BitFlags6E, #$%00000100    ; set bits
           ldd  #0x80ff        ; load d (a&b) with value -10000000 11111111-
           jsr  SetPIAOutputBits    ; call subroutine
           bclr *BitFlags6E, #$%00000100    ; clear bits
           ldx  #AISTEP_BitPatternForAisControl    ; load index with value
           tba                 ; a = b
           ldab BitFlags_36    ; load b with memory contents
           abx                 ; add b to index
           eora 0x00, X    
           cli                 ; enable interrupts
           bita #0x0f          ;  -00001111-
           beq  LB8A4          ; branch if equal (zero)
           brset *BitFlags6C, #$%01000000, LB8A4    ; branch if bit(s) set
           ldd  #0x19a0        ; load d (a&b) with value -00011001 10100000-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LB8A4          ; branch if greater or equal
           bset *BitFlags6C, #$%01000000    ; set bits
           bset *b5D_IPL2, #b5d_MajorFault    ; set bits
   LB8A4:  rts                 ; return from subroutine

   LB8A5:  ldaa TimerOverflowsBetweenCamPulses    ; load a with memory contents
           cmpa #0x50          ; compare a with value -01010000-
           bcs  LB8C2          ; branch if lower
           ldaa CPU_A2DResults1    ; load a with memory contents
           brclr *Counter_MainLoop, #$%01111111, LB8BE    ; branch if bit(s) clear
           cmpa MapVolts       ; compare a with memory contents
           bcs  LB8C0          ; branch if lower
           cmpa MapValue       ; compare a with memory contents
           bls  LB8C2          ; branch if lower or same
           staa MapValue       ; store a into memory
           bra  LB8C2          ; branch

   LB8BE:  staa MapValue       ; store a into memory
   LB8C0:  staa MapVolts       ; store a into memory
   LB8C2:  ldaa MapVolts       ; load a with memory contents
           suba CPU_A2DResults1
           bcc  LB8CA          ; branch if greater or equal
           nega                ; negate a (set high bit)
   LB8CA:  ldab MPDELT_DeltaMapThatChecksGood    ; load b with memory contents (data is 01)
           brclr *b5C_IPL1, #b5c_MapStuck, LB8D4    ; branch if bit(s) clear
           addb MPDELA_MatureMapLimpinWhenDeltaAbove_MPDELT_plus_MPDELA    ;  (data is 01)
   LB8D4:  cba             
           bcs  LB903          ; branch if lower
           bset *BitFlags6D, #b6d_BigMapChange    ; set bits
           brclr *b5C_IPL1, #b5c_MapStuck, LB903    ; branch if bit(s) clear
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x1f          ;  -00011111-
           bne  LB903          ; branch if not equal (not zero)
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           cmpD #PIA2_Buffer    ; compare D -00000000 01000000-
           bcc  LB8FE          ; branch if greater or equal
           brset *BitFlags66, #b66_OffIdle, LB8FE    ; branch if bit(s) set
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  LB8F8          ; branch if greater or equal
           coma            
           comb            
   LB8F8:  cmpD MPRMPD_CheckMapAtZeroSpeedAndThisDeltaRpm    ; compare D (data is 02)
           bcs  LB903          ; branch if lower
   LB8FE:  ldaa #0x08          ; load a with value -00001000-
           jmp  ResetErrorCodeIfTimerExpired

   LB903:  rts                 ; return from subroutine

VerifyOperationOfMapSensor_MM:
           ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x07          ;  -00000111-
           bne  LB903          ; branch if not equal (not zero)
           brset *b5C_IPL1, #b5c_MapStuck, LB94B    ; branch if bit(s) set
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           cmpD #0x0040    ; compare D -00000000 01000000-
           bcc  LB94B          ; branch if greater or equal
           brset *BitFlags66, #b66_OffIdle, LB94B    ; branch if bit(s) set
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  LB922          ; branch if greater or equal
           coma            
           comb            
   LB922:  cmpD MPRMPD_CheckMapAtZeroSpeedAndThisDeltaRpm    ; compare D (data is 02)
           bcc  LB94B          ; branch if greater or equal
           brset *BitFlags6D, #b6d_FuelEngineNotRunning, LB94B    ; branch if bit(s) set
           ldaa BaroPressure    ; load a with memory contents
           tab                 ; b = a
           suba MapValue   
           bcs  LB940          ; branch if lower
           ldx  #MPVACD_AllowMapToTestGoodThisNearBaro    ; load index with value
           cmpb BAROSW_CheckMapAtZeroSpeedAndThisBaroSwitch    ; compare b with memory contents (data is 62)
           bcc  LB93C          ; branch if greater or equal
           inx                 ; increment index (x=x+1)
   LB93C:  cmpa 0x00, X        ; compare a with memory at index + value
           bcc  LB94B          ; branch if greater or equal
   LB940:  ldd  #0x2794        ; load d (a&b) with value -00100111 10010100-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LB94B          ; branch if greater or equal
           bset *b5C_IPL1, #b5c_MapStuck    ; set bits
   LB94B:  ldx  EngineRpm_HB
           cpx  #0x2ee0        ;  -00101110 11100000-
           bcc  LB903          ; branch if greater or equal
           ldab TpsVolts       ; load b with memory contents
           subb MINTHR_LowestSessionTPS    ; b = b-memory contents
           bcs  LB95D          ; branch if lower
           cmpb MPLTHR_ThrottleLevelAbove_MINTHR_ToMatureMapLimpin    ; compare b with memory contents (data is 42)
           bcc  LB903          ; branch if greater or equal
   LB95D:  ldaa CPU_A2DResults1    ; load a with memory contents
           cmpa MAPHIG_MapSensorUpperLimit    ; compare a with memory contents (data is ee)
           bcc  LB96F          ; branch if greater or equal
           cmpa MAPLOW_MapSensorLowerLimit    ; compare a with memory contents (data is 01)
           bcc  LB97F          ; branch if greater or equal
           ldd  #0x2494        ; load d (a&b) with value -00100100 10010100-
           bra  LB972          ; branch

   LB96F:  ldd  #0x2594        ; load d (a&b) with value -00100101 10010100-
   LB972:  brset *b5C_IPL1, #b5c_MapBadSignal, LB97E    ; branch if bit(s) set
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LB97E          ; branch if greater or equal
           bset *b5C_IPL1, #b5c_MapBadSignal    ; set bits
   LB97E:  rts                 ; return from subroutine

   LB97F:  brclr *b5C_IPL1, #b5c_MapBadSignal, LB97E    ; branch if bit(s) clear
           ldaa #0x06          ; load a with value -00000110-
ResetErrorCodeIfTimerExpired:
           anda #0x0f          ; AND a with value -00001111-
           ldab ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; load b with memory contents
           beq  LB992          ; branch if equal (zero)
           andb #0x0f          ;  -00001111-
           cba             
           bne  LB998          ; branch if not equal (not zero)
           ldaa ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; load a with memory contents
   LB992:  adda #0x10          ;  -00010000-
           bcs  SELECT_ERROR_BIT_POSITION_ROUT    ; branch if lower
           staa ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; store a into memory
   LB998:  rts                 ; return from subroutine

SELECT_ERROR_BIT_POSITION_ROUT:
           ldab #0x01          ; load b with value -00000001-
   LB99B:  deca                ; decrement a
           beq  LB9A1          ; branch if equal (zero)
           lslb            
           bra  LB99B          ; branch

   LB9A1:  clr  ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR    ; zero byte at memory location
           tba                 ; a = b
           comb            
           sei                 ; disable interrupts
           andb b5C_IPL1   
           stab b5C_IPL1       ; store b into memory
           cmpa #0x80          ; compare a with value -10000000-
           beq  LB9B0          ; branch if equal (zero)
           cli                 ; enable interrupts
   LB9B0:  rts                 ; return from subroutine

CountRamValuesFrom05to3a:
           clra                ; a = 0
           clrb                ; b = 0
           ldx  #MINTHR_LowestSessionTPS    ; load index with value
   LB9B6:  addb 0x00, X        ; add memory at index + value to b
           bcc  LB9BB          ; branch if greater or equal
           inca                ; increment a
   LB9BB:  inx                 ; increment index (x=x+1)
           cpx  #CurrentWastegatePosition    ;  -00000000 00111010-
           bcs  LB9B6          ; branch if lower
           rts                 ; return from subroutine

VerifyOperationOfThermostat_MM:
           brset *BitFlags6D, #b6d_FuelEngineNotRunning, LB9F5    ; branch if bit(s) set
           brset *b5C_IPL1, #b5c_BadCoolantTemp, LB9F5    ; branch if bit(s) set
           ldaa Timer_ThermostatDiagnostics    ; load a with memory contents
           beq  LB9F5          ; branch if equal (zero)
           ldab Counter_MainLoop    ; load b with memory contents
           bne  LB9F5          ; branch if not equal (not zero)
           ldab CoolantTemp    ; load b with memory contents
           cmpb TDAGTP_TstatDiagnosticsTemperatureGoalWithin_HOTIME    ; compare b with memory contents (data is c7)
           bcc  LB9F2          ; branch if greater or equal
           ldab KeyOnOrEngineRunningTime    ; load b with memory contents
           incb            
           bne  LB9F5          ; branch if not equal (not zero)
           ldab VehicleSpeed_HB    ; load b with memory contents
           cmpb #0x07          ;  -00000111-
           bcs  LB9F5          ; branch if lower
           inca                ; increment a
           beq  LB9EC          ; branch if equal (zero)
           cmpa HOTIME_TstatDiagnosticsTimeToAchieveTemperatureGoal    ; compare a with memory contents (data is ae)
           bcs  LB9F3          ; branch if lower
   LB9EC:  ldd  #0x2101        ; load d (a&b) with value -00100001 00000001-
           jsr  ThrowNonCriticalError    ; call subroutine
   LB9F2:  clra                ; a = 0
   LB9F3:  staa Timer_ThermostatDiagnostics    ; store a into memory
   LB9F5:  rts                 ; return from subroutine

VerifyOperationOfASDRelayAndO2Sensor_MM:
           ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           bne  LB9F5          ; branch if not equal (not zero)
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x03          ;  -00000011-
           bne  LBA17          ; branch if not equal (not zero)
           ldaa TimerOverflowsBetweenCamPulses    ; load a with memory contents
           bne  LBA17          ; branch if not equal (not zero)
           ldaa BatteryVolts    ; load a with memory contents
           cmpa #0x81          ; compare a with value -10000001-
           bcs  LBA17          ; branch if lower
           ldaa SwitchPortAccessReg1    ; load a with memory contents
           bita #0x20          ;  -00100000-
           bne  LBA17          ; branch if not equal (not zero)
           ldd  #0x2c14        ; load d (a&b) with value -00101100 00010100-
           jsr  ThrowNonCriticalError    ; call subroutine
   LBA17:  brset *BitFlags6D, #b6d_FuelEngineNotRunning, LBA5D    ; branch if bit(s) set
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa #0x2c          ; compare a with value -00101100-
           bcs  LBA5D          ; branch if lower
           ldaa CoolantTemp    ; load a with memory contents
           cmpa CTLRPM_LowBatteryVoltageAtThisCoolantTemp    ; compare a with memory contents (data is cd)
           bcs  LBA5D          ; branch if lower
           brclr *BitFlags67, #b67_InMotion, LBA62    ; branch if bit(s) clear
           ldaa Counter_O2Diagnostics          ; load a with memory contents
           cmpa O2DIAG_CounterLimitForO2SensorDiag    ; compare a with memory contents (data is 13)
           bcs  LBA57          ; branch if lower
           ldaa O2SensorVolts    ; load a with memory contents
           cmpa O2MID_LimitForO2SensorBatteryDiag    ; compare a with memory contents (data is 4d)
           bcs  LBA5D          ; branch if lower
           ldaa Timer_O2MiddleDiagnostics    ; load a with memory contents
           cmpa #0x16          ; compare a with value -00010110-
           bcs  LBA4C          ; branch if lower
           ldd  #0x2001        ; load d (a&b) with value -00100000 00000001-
           jsr  ThrowNonCriticalError    ; call subroutine
           bset *BitFlags67, #b67_BadO2    ; set bits
           bra  LBAAD          ; branch

   LBA4C:  ldab Counter_MainLoop    ; load b with memory contents
           cmpb #0x50          ;  -01010000-
           bne  LBAAD          ; branch if not equal (not zero)
           inca                ; increment a
           staa Timer_O2MiddleDiagnostics    ; store a into memory
           bra  LBAAD          ; branch

   LBA57:  inca                ; increment a
           staa Counter_O2Diagnostics      
           bra  LBAAD          ; branch

   LBA5D:  bclr *BitFlags67, #b67_InMotion    ; clear bits
           bra  LBA8B          ; branch

   LBA62:  ldaa O2SensorVolts    ; load a with memory contents
           cmpa O2MIDH_HighLimitForInMiddleDetermination    ; compare a with memory contents (data is 1c)
           bhi  LBA8B          ; branch if higher
           cmpa O2MIDL_LowLimitForInMiddleDetermination    ; compare a with memory contents (data is 12)
           bcs  LBA8B          ; branch if lower
           ldaa Timer_O2MiddleDiagnostics    ; load a with memory contents
           cmpa #0x0b          ; compare a with value -00001011-
           bcs  LBA82          ; branch if lower
           bset *BitFlags67, #b67_InMotion    ; set bits
           clra                ; a = 0
           staa Timer_O2MiddleDiagnostics    ; store a into memory
           staa Counter_O2Diagnostics
           bset *PIA3_Buffer, #pi3_FuelMon    ; set bits
           bra  LBAAD          ; branch

   LBA82:  ldab Counter_MainLoop    ; load b with memory contents
           cmpb #0xa0          ;  -10100000-
           bne  LBA8E          ; branch if not equal (not zero)
           inca                ; increment a
           bra  LBA8C          ; branch

   LBA8B:  clra                ; a = 0
   LBA8C:  staa Timer_O2MiddleDiagnostics    ; store a into memory
   LBA8E:  bclr *PIA3_Buffer, #pi3_FuelMon    ; clear bits
           ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x07          ;  -00000111-
           bne  LBAAD          ; branch if not equal (not zero)
           brset *BitFlags67, #b67_BadO2, LBAAD    ; branch if bit(s) set
           ldaa O2SensorVolts    ; load a with memory contents
           cmpa O2MIDX_HighLimitForInMiddleDeterminationX    ; compare a with memory contents (data is 3e)
           bls  LBAAD          ; branch if lower or same
           ldd  #0x3e9e        ; load d (a&b) with value -00111110 10011110-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LBAAD          ; branch if greater or equal
           bset *BitFlags67, #b67_BadO2    ; set bits
   LBAAD:  rts                 ; return from subroutine

DealWithConfigurationAndPulseAccumulator_MM:
           ldx  #CPU_PortA     ; load index with value
           brset  9, X, #$%00111010, LBAB8    ; branch if bit(s) set
           bset  9, X, #$%00111010    ; bit set
   LBAB8:  brclr  9, X, #$%00000101, LBABF    ; branch if bit(s) clear
           bclr  9, X, #$%00000101    ; bit clear
   LBABF:  ldaa CPU_OutputCompare1Mask    ; load a with memory contents
           bita #0xf8          ;  -11111000-
           beq  LBAC9          ; branch if equal (zero)
           clr  CPU_OutputCompare1Mask    ; zero byte at memory location
   LBAC9:  brset 33, X, #$%00011010, LBAD0    ; branch if bit(s) set
           bset 33, X, #$%00011010    ; bit set
   LBAD0:  brclr 33, X, #$%00100101, LBAD7    ; branch if bit(s) clear
           bclr 33, X, #$%00100101    ; bit clear
   LBAD7:  brset 34, X, #$%10100110, LBADE    ; branch if bit(s) set
           bset 34, X, #$%10100110    ; bit set
   LBADE:  brclr 34, X, #$%00000001, LBAE7    ; branch if bit(s) clear
           bclr 34, X, #$%00000001    ; bit clear
           bra  LBAE7          ; branch

   LBAE7:  brclr 36, X, #$%11110000, LBAEE    ; branch if bit(s) clear
           bclr 36, X, #$%11110000    ; bit clear
   LBAEE:  brset 38, X, #$%01010000, LBAF5    ; branch if bit(s) set
           bset 38, X, #$%01010000    ; bit set
   LBAF5:  brclr 38, X, #$%10000000, LBAFC    ; branch if bit(s) clear
           bclr 38, X, #$%10000000    ; bit clear
   LBAFC:  ldaa #0x54          ; load a with value -01010100-
           cmpa CPU_SerialPeripheralControl    ; compare a with memory contents
           beq  LBB06          ; branch if equal (zero)
           staa CPU_SerialPeripheralControl
   LBB06:  ldd  #DCCOR6_AdaptiveVNTCell1    ; load d (a&b) with value -00000000 00001100-
           cmpD CPU_SerialControlReg1    ; compare D
           beq  LBB12          ; branch if equal (zero)
           std  CPU_SerialControlReg1
   LBB12:  brset 57, X, #$%10001000, LBB19    ; branch if bit(s) set
           bset 57, X, #$%10001000    ; bit set
   LBB19:  brclr 57, X, #$%01000000, LBB20    ; branch if bit(s) clear
           bclr 57, X, #$%01000000    ; bit clear
   LBB20:  brset 60, X, #$%00001000, LBB29    ; branch if bit(s) set
           sei                 ; disable interrupts
           bset 60, X, #$%00001000    ; bit set
           cli                 ; enable interrupts
   LBB29:  brclr 60, X, #$%00000111, LBB32    ; branch if bit(s) clear
           sei                 ; disable interrupts
           bclr 60, X, #$%00000111    ; bit clear
           cli                 ; enable interrupts
   LBB32:  ldx  #0x1770        ; load index with value
           sei                 ; disable interrupts
           brclr  2, X, #$%01100100, LBB3D    ; branch if bit(s) clear
           bclr  2, X, #$%01100100    ; bit clear
   LBB3D:  cli                 ; enable interrupts
           bclr 64, X, #$%00001000    ; bit clear
           ldaa #0xf8          ; load a with value -11111000-
           cmpa PIA_Ctrl_5          ; compare a with memory contents
           beq  LBB4B          ; branch if equal (zero)
           staa PIA_Ctrl_5      
   LBB4B:  rts                 ; return from subroutine

VerifyOperationOfIgnitionCoilDriver_MM:
           ldaa TimerOverflowsBetweenCamPulses    ; load a with memory contents
           cmpa #0x50          ; compare a with value -01010000-
           bcs  LBB87          ; branch if lower
           brset *BitFlags_BF, #$%10000000, LBB87    ; branch if bit(s) set
           ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           bne  LBB8A          ; branch if not equal (not zero)
           brset *BitFlags6B, #$%00000100, LBB8A    ; branch if bit(s) set
           ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x0f          ;  -00001111-
           bne  LBB8A          ; branch if not equal (not zero)
           ldaa BatteryVolts    ; load a with memory contents
           cmpa #0x41          ; compare a with value -01000001-
           bcs  LBB8A          ; branch if lower
           cmpa COILHI_HiLimitBatteryVoltsForCoilVerify    ; compare a with memory contents (data is ba)
           bcc  LBB8A          ; branch if greater or equal
           ldaa MapValue       ; load a with memory contents
           suba MapVolts
           bls  LBB8A          ; branch if lower or same
           cmpa COILLO_LoLimitBatteryVoltsForCoilVerify    ; compare a with memory contents (data is 05)
           bcs  LBB8A          ; branch if lower
           ldd  #0x2814        ; load d (a&b) with value -00101000 00010100-
           brclr *BitFlags_BF, #$%01000000, LBB84    ; branch if bit(s) clear
           ldd  #0x0114        ; load d (a&b) with value -00000001 00010100-
   LBB84:  jmp  ThrowNonCriticalError

   LBB87:  bset *BitFlags6B, #$%00000100    ; set bits
   LBB8A:  rts                 ; return from subroutine

NULL_ROUTINE:
           rts                 ; return from subroutine

CalculatePartThrottleTransientFuel_MM:
           clra                ; a = 0
           staa Temp2          ; store a into memory
           staa Temp3          ; store a into memory
           ldaa Timer_O2InhibitSwitchingRichIdleToClosedLoop    ; load a with memory contents
           beq  LBB98          ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_O2InhibitSwitchingRichIdleToClosedLoop    ; store a into memory
   LBB98:  ldaa CoolantTemp    ; load a with memory contents
           ldab MapValue       ; load b with memory contents
           subb MapAverageValue_HB    ; b = b-memory contents
           stab Temp0          ; store b into memory
           bcs  TransFuel_CalculateDecreasingMAPTransientFuel    ; branch if lower
           clrb                ; b = 0
           stab Factor_DecelLeanoutWhenMAPDecreasing    ; store b into memory
           brset *BitFlags66, #b66_FullThrottle, TransFuel_CalculateIncreasingMAPWOTPW    ; branch if bit(s) set
           brset *BitFlags66, #b66_OffIdle, TransFuel_CalculateIncreasingMAPPTPW    ; branch if bit(s) set

           ldx  #AETIME_EnrichmentTime_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Factor_LeanoutOrEnrichTime_MAP    ; store a into memory

           ldaa CONFIG2_ConfigurationFlags2    ; load a with memory contents (data is c7)
           bita #0x10          ;  -00010000-

           beq  TransFuel_CalculateIncreasingMAPSpecialPW    ; branch if equal (zero)
   LBBBC:  jmp  LBCA2      

TransFuel_CalculateIncreasingMAPSpecialPW:
           ldaa Temp0          ; deltaMAP
           suba MAPTRS_DeltaMapTriggerLevelSpecial    ;  (data is 06)
           bcs  LBBBC          ; branch if lower
           cmpa MAPMXS_MaxDeltaMapAllowedSpecial    ; compare a with memory contents (data is 22)
           bcs  LBBCE          ; branch if lower
           ldaa MAPMXS_MaxDeltaMapAllowedSpecial    ; load a with memory contents (data is 22)
   LBBCE:  staa Temp1          ; store a into memory
           ldx  #AESLPI_DeltaMAPEnrichmentIdle    ; load index with value
           bra  TransFuel_CalcMAPEnrichValueFinal          ; branch

TransFuel_CalculateIncreasingMAPWOTPW:
           ldx  #AESLPP_DeltaMAPEnrichmentPT_FromTempPart    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Factor_LeanoutOrEnrichTime_MAP    ; store a into memory
           ldaa Temp0          ; deltaMAP
           suba MAPTRP_DeltaMapTriggerLevelPartThrottle    ;  (data is 0a)
           bcs  LBBBC          ; branch if lower
           cmpa MAPMXP_MaxDeltaMapAllowedPartThrottle          ; compare a with memory contents (data is ff)
           bcs  LBBEC          ; branch if lower
           ldaa MAPMXP_MaxDeltaMapAllowedPartThrottle          ; load a with memory contents (data is ff)
   LBBEC:  staa Temp1          ; store a into memory
           ldx  #AESLPW_DeltaMAPEnrichmentWOT    ; load index with value
           bra  TransFuel_CalcMAPEnrichValueFinal          ; branch

TransFuel_CalculateIncreasingMAPPTPW:
           ldx  #AESLOW_DeltaMAPEnrichmentWOT_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Factor_LeanoutOrEnrichTime_MAP    ; store a into memory
           ldaa Temp0          ; deltaMAP
           suba MAPTRG_DeltaMapTriggerLevel          ;  (data is 0a)
           bcs  LBBBC          ; branch if lower
           cmpa MAPMAX_MaxDeltaMapAllowed    ; compare a with memory contents (data is 1c)
           bcs  LBC0A          ; branch if lower
           ldaa MAPMAX_MaxDeltaMapAllowed    ; load a with memory contents (data is 1c)
   LBC0A:  staa Temp1          ; store a into memory
           ldx  #AESLOP_DeltaMAPEnrichmentPT    ; load index with value

TransFuel_CalcMAPEnrichValueFinal:
           ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp1          ; load a with DeltaMAP value to be used in transient calc
           mul                 ; multiply (d=a*b)
           stD *Temp2          ; store D to temp2 - used later for transientPW addition
           bra  TransFuel_IncludeTPSTransients    ; branch

TransFuel_CalculateDecreasingMAPTransientFuel:
           ldx  #LMAPTC_TimeConstant    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Factor_LeanoutOrEnrichTime_MAP    ; store a into memory
           brset *BitFlags66, #b66_FullThrottle, ResetAvgMAP    ; branch if bit(s) set
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa LOTRPM_MinRpmForMapLeanout    ; compare a with memory contents (data is 27)
           bcs  ResetAvgMAP          ; branch if lower
           cmpa AVMRPM_MinimumRPMToResetAverageMAP          ; compare a with memory contents (data is d6)
           bcc  ResetAvgMAP          ; branch if greater or equal
           ldaa MapValue       ; load a with memory contents
           cmpa AVMMAP_MinimumMAPToResetAverageMAP          ; compare a with memory contents (data is 99)
           bcc  ResetAvgMAP          ; branch if greater or equal
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 97)
           bita #0x20          ;  -00100000-
           beq  LBC45          ; branch if equal (zero)
           brclr *BitFlags_AIS, #b10_ATXInGear, ResetAvgMAP    ; branch if bit(s) clear
   LBC45:  brclr *KeyOnOrEngineRunningTime, #$%11111111, ResetAvgMAP    ; branch if bit(s) clear
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           cmpD #0x0080    ; compare D -00000000 10000000-
           bcs  ResetAvgMAP          ; branch if lower
           ldaa Temp0          ; DeltaMAP value
           nega                ; negate a (set high bit)
           ldab Factor_DecelLeanoutWhenMAPDecreasing    ; load b with memory contents
           beq  LBC5B          ; branch if equal (zero)
           adda DECHYS_DeltaMapHysteresisonTriggerLevels    ;  (data is 04)
   LBC5B:  cmpa DECTRG_DeltaMapTriggerForNoIncrementalLeanout    ; compare a with memory contents (data is 0b)
           bcs  ClearDecelLOMAPFactor          ; branch if lower
           cmpa DTRG2_DeltaMapTriggerForMaxLeanout    ; compare a with memory contents (data is 0b)
           bcs  IncrementDecelLOMAPFactor          ; branch if lower
           ldaa DCELTM_O2CNTRInhibitAfterLeanoutDone    ; load a with memory contents (data is 02)
           staa Timer_O2InhibitSwitchingRichIdleToClosedLoop    ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #NEGSL2_DeltaMAPLeanout_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           bra  StoreDecelLOMAPFactor          ; branch

IncrementDecelLOMAPFactor:
           tstb
           beq  LBC81          ; branch if equal (zero)
           incb            
           bra  StoreDecelLOMAPFactor          ; branch

ResetAvgMAP:  
           ldaa MapValue       ; load a with memory contents
           staa MapAverageValue_HB    ; store a into memory
ClearDecelLOMAPFactor:  
           clrb                ; b = 0
StoreDecelLOMAPFactor:
           stab Factor_DecelLeanoutWhenMAPDecreasing    ; store b into memory
   LBC81:  ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x07          ;  -00000111-
           bne  TransFuel_IncludeTPSTransients    ; branch if not equal (not zero)
           ldx  #MapAverageValue_HB    ; load index with value
           sei                 ; disable interrupts
           jsr  ProcessMapOrTpsBlockData    ; call subroutine
           cli                 ; enable interrupts
TransFuel_IncludeTPSTransients:
           brset *BitFlags6D, #b6d_FuelEngineNotRunning, TransFuel_ClearTemp2    ; branch if bit(s) set
           ldd  KeyOnOrEngineRunningTime    ; load d (a&b) with memory contents
           cmpa #0x00          ; compare a with value -00000000-
           bne  LBCA2          ; branch if not equal (not zero)
           cmpb MLPTPS_MainLoopCountToClearTPSTRansient          ; compare b with memory contents (data is 5d)
           bhi  LBCA2          ; branch if higher
TransFuel_ClearTemp2:
           clra                ; a = 0
           clrb                ; b = 0
           stD *Temp2          ; store D to RAM
   LBCA2:  ldaa CoolantTemp    ; load a with memory contents
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
           cmpa THRMAX_MaxDeltaTHR    ; compare a with memory contents (data is 40)
           bcs  LBCC6          ; branch if lower
           ldaa THRMAX_MaxDeltaTHR    ; load a with memory contents (data is 40)
   LBCC6:  staa Temp1          ; store a into memory
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
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa ATPRPM_MinimumRPMtoResetAverageTPS          ; compare a with memory contents (data is 6e)
           bcc  LBD21          ; branch if greater or equal
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bcs  LBD21          ; branch if lower
           cmpa ATPDTP_MinimumDeltaTPStoResetAverageTPS          ; compare a with memory contents (data is 3d)
           bcc  LBD21          ; branch if greater or equal
           brclr *KeyOnOrEngineRunningTime, #$%11111111, LBD21    ; branch if bit(s) clear
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           cmpD #MapAverageValue_HB    ; compare D -00000000 10000000-
           bcs  LBD21          ; branch if lower
           ldaa Temp0          ; load a with memory contents
           nega                ; negate a (set high bit)
           ldab Timer_OffThrottleFuelEnrich    ; load b with memory contents
           beq  LBD07          ; branch if equal (zero)
           adda LOTHYS_LeanoutDeltaThrottleHysteresis    ;  (data is 02)
   LBD07:  cmpa LOTTRG_DeltaTriggerForDecelLeanout    ; compare a with memory contents (data is 0b)
           bcs  LBD25          ; branch if lower
           cmpa LOTRG2_SecondDecelLeanoutTrigger    ; compare a with memory contents (data is 0b)
           bcs  LBD1B          ; branch if lower
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #LOTTHR_DecelLeanoutFactor_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           bra  TransFuel_StoreLeanOutFactor    ; branch

   LBD1B:  tstb            
           beq  LBD28          ; branch if equal (zero)
           incb            
           bra  TransFuel_StoreLeanOutFactor    ; branch

   LBD21:  ldaa TpsVolts       ; load a with memory contents
           staa TpsAverageValue_HB    ; store a into memory
   LBD25:  clrb                ; b = 0
TransFuel_StoreLeanOutFactor:
           stab Timer_OffThrottleFuelEnrich    ; store b into memory
   LBD28:  ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x07          ;  -00000111-
           bne  TransFuel_SaveTemp2    ; branch if not equal (not zero)
           ldx  #TpsAverageValue_HB    ; load index with value
           sei                 ; disable interrupts
           jsr  ProcessMapOrTpsBlockData    ; call subroutine
           cli                 ; enable interrupts
TransFuel_SaveTemp2:
           brset *BitFlags6D, #b6d_FuelEngineNotRunning, LBD59    ; branch if bit(s) set
           ldd  Temp2          ; load d (a&b) with memory contents
TransFuel_SaveD:
           stD *Pulsewidth_PartThrottleEnrichment_HB    ; store D to RAM
           brset *BitFlags66, #b66_OffIdle, LBD59    ; branch if bit(s) set
           ldaa SwitchPortAccessReg1    ; load a with memory contents
           bita #0x40          ;  -01000000-
           bne  LBD59          ; branch if not equal (not zero)
           ldaa DesiredNewAisPosition    ; load a with memory contents
           suba CurrentAisPosition
           bcs  LBD59          ; branch if lower
           cmpa POSTIG_MinAisPulseRequireToTriggerEnrichment    ; compare a with memory contents (data is 07)
           bcs  LBD59          ; branch if lower
           ldd  POSFUL_AisEnrichmentFuelPulse    ;  (data is 00fa)
           stD *Pulsewidth_AISPulseEnrichment_HB    ; store D to RAM
   LBD59:  rts                 ; return from subroutine

CalculateInjectorPulsewidthForStarting_MM:
           brset *BitFlags6D, #b6d_FuelEngineNotRunning, ClearPTEPWForStarting    ; branch if bit(s) set
           rts                 ; return from subroutine

ClearPTEPWForStarting:
           clra                ; a = 0
           clrb                ; b = 0
           stD *Pulsewidth_PartThrottleEnrichment_HB    ; store D to RAM
           ldaa TpsVolts       ; load a with memory contents
           cmpa #0xd0          ; compare a with value -11010000-
           bcc  ThrottleFlooredWhileStarting_UnloadFuel    ; branch if greater or equal
           suba MINTHR_LowestSessionTPS
           bls  LBD72          ; branch if lower or same
           cmpa UNLOAD_DeltaThrottleFrom_MINTHR_ToUnloadCrankingFuel    ; compare a with memory contents (data is 85)
           bcc  ThrottleFlooredWhileStarting_UnloadFuel    ; branch if greater or equal
   LBD72:  jsr  AllowForHeatSoakAfterStall    ; call subroutine
           brset *BitFlags66, #b66_OffIdle, LBD81    ; branch if bit(s) set
           cmpa STRLMT_ColdestTempAllowedAtClosedThrottle    ; compare a with memory contents (data is 69)
           bcc  LBD81          ; branch if greater or equal
           ldaa STRLMT_ColdestTempAllowedAtClosedThrottle    ; load a with memory contents (data is 69)
   LBD81:  ldx  #STRTFL_FuelStartFromCoolantTemp    ; load index with value
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
           beq  LBDAE          ; branch if equal (zero)
           nega                ; negate a (set high bit)
           ldY Temp0           ; load Y index
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           stD *Temp0          ; store D to RAM
   LBDAE:  ldaa BaroPressure    ; load a with memory contents
           ldx  #STFBAR_FuelStartReductionFromBaro    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp4          ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #STFTM2_FuelStartFuelFromCoolant2    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp4          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           beq  LBDD2          ; branch if equal (zero)
           nega                ; negate a (set high bit)
           ldY Temp0           ; load Y index
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           bra  LBDD4          ; branch

   LBDD2:  ldd  Temp0          ; load d (a&b) with memory contents
   LBDD4:  asld                ; shift left (d=d*2)
           bcs  LoadMaxInjectorPW          ; branch if lower
           asld                ; shift left (d=d*2)
           bcc  SaveInjectorPW          ; branch if greater or equal

LoadMaxInjectorPW:
           ldd  #0xffff         ; load d (a&b) with value -11111111 11111111-
           bra  SaveInjectorPW          ; branch

ThrottleFlooredWhileStarting_UnloadFuel:
           clra                ; a = 0
           clrb                ; b = 0

SaveInjectorPW:
           jsr  NULL_ROUTINE    ; call subroutine
           stD *InjectorPulsewidth_HB    ; store D to RAM
           cli                 ; enable interrupts
           ldx  #SFDCAY_FuelStartDecayIntoRun    ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           staa Factor_StartFuelDecayIntoRunFuel    ; store a into memory
           rts                 ; return from subroutine

ControlEngineCutout_MM:
           brclr *TimerOverflowsBetweenCamPulses, #$%11111111, Cutout_CheckEnable    ; branch if bit(s) clear
           bclr *BitFlags6A, #b6a_OverRev | b6a_FuelOff    ; clear bits
           brset *BitFlags6B, #$%00001000, LBE00    ; branch if bit(s) set
           clr  Counter_FuelEngRunning    ; zero byte at memory location
   LBE00:  rts                 ; return from subroutine
   
Cutout_CheckEnable:
;          New code - check to see if either of the rev limiter config flags is set before running the code...
           ldaa OPTN2_CalCustomOptionConfigFlags2
           bita #opt_FuelRevLim | opt_SprkRevLim
;           beq  LBE00 ; will this work instead? --> more efficient code
           bne  Cutout_EngineRunning ; run the rev limiter code
           rts  ; don't run the rev limiter code

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
           
; original code continued here
           brclr *BitFlags6A, #b6a_FuelOff, Cutout_UseDecelFuelCut    ; branch if bit(s) clear
           jmp  Cutout_UseHysteresisToDetermineWhenToTurnFuelBackOn

Cutout_UseDecelFuelCut:
           brclr *BitFlags6B, #b6b_DecelFuelCut, Cutout_CheckForOBConditions    ; branch if bit(s) clear
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  LBE20          ; branch if greater or equal
           clra                ; a = 0
   LBE20:  cmpa DFRPMH_DecelFuelShutoffDeltaRPMOff    ; compare a with memory contents (data is 1e)
           bls  Cutout_CheckForOBConditions    ; branch if lower or same
           bset *BitFlags6A, #b6a_FuelOff    ; set bits
           rts                 ; return from subroutine

Cutout_CheckForOBConditions:
           ldaa MapValue       ; load a with memory contents
           suba BaroPressure
           bcs  Cutout_BeginOverboostTimerCountdown    ; branch if lower
           brclr *b5D_IPL2, #b5d_WGSolFault, LBE4D    ; branch if bit(s) clear
           cmpa LMPSHF_OverboostFuelShutoffDisablePointFromMap_Limp    ; compare a with memory contents (data is 73)
           bls  Cutout_CheckRevLimiters    ; branch if lower or same
   LBE38:  brset *BitFlags6A, #b6a_FuelOff, LBE42    ; branch if bit(s) set
           bset *BitFlags6A, #b6a_Cruise2    ; set bits
ShutOffEngineForThisRotation:
           bset *BitFlags6A, #b6a_FuelOff    ; set bits
   LBE42:  bclr *BitFlags6A, #b6a_OverRev    ; clear bits
           rts                 ; return from subroutine

Cutout_BeginOverboostTimerCountdown:
           ldaa TRNTIM_OverboostFuelShutoffDuration    ; load a with memory contents (data is 8a)
           staa Timer_OverboostCountdown    ; store a into memory
           bra  Cutout_CheckRevLimiters    ; branch

   LBE4D:  suba MPSHFT_OverboostFuelShutoffEnablePointFromMap_Timer    ;  (data is 7b)
           bcs  Cutout_BeginOverboostTimerCountdown    ; branch if lower
           cmpa MPSHFA_OverboostFuelShutoffEnablePointFromMap_Absolute    ; compare a with memory contents (data is 11)
           bhi  Cutout_SetOBCodeAndShutdown    ; branch if higher
           ldaa Timer_OverboostCountdown    ; load a with memory contents
           beq  Cutout_SetOBCodeAndShutdown    ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_OverboostCountdown    ; store a into memory
           bra  Cutout_CheckRevLimiters    ; branch

Cutout_SetOBCodeAndShutdown:
           ldd  #0x0708        ; load d (a&b) with value -00000111 00001000-
           jsr  ThrowNonCriticalError    ; call subroutine
           bra  LBE38          ; branch

Cutout_CheckRevLimiters:
           ldx  #REVLMT2_MapLimpinAndThrAbove25PercentUpper2000    ; load index with value
           brclr *b5C_IPL1, #b5c_MapStuck | b5c_MapBadSignal, LBE78    ; branch if bit(s) clear
           ldab THRTHR_25PctThrValueFromShutoff    ; load b with memory contents (data is 21)
           addb MINTHR_LowestSessionTPS    ; b=b+memory contents
           cmpb TpsVolts   
           bcs  Cutout_CheckRevLimitingValues    ; branch if lower
   LBE78:  ldx  #REVLMT4_MapAbove75PctAndThrLimpin2000    ; load index with value
           brclr *b5C_IPL1, #b5c_TpsBadSignal, Cutout_ThrottleSensorOK    ; branch if bit(s) clear
           ldaa Temp0          ; load a with memory contents
           cmpa RVLSPD_CarSpeedForRevLimitWithTBOff    ; compare a with memory contents (data is 14)
           bcc  LBE96          ; branch if greater or equal
           bra  LBE8C          ; branch

Cutout_ThrottleSensorOK:
           ldab BitFlags66     ; load b with memory contents
           bmi  LBE96          ; branch if minus(hi bit 1)
   LBE8C:  ldab BaroPressure    ; load b with memory contents
           lsrb                ; logical shift right b
           tba                 ; a = b
           lsrb                ; logical shift right b
           aba                 ; a=a+b
           cmpa MapValue       ; compare a with memory contents
           bcs  Cutout_CheckRevLimitingValues    ; branch if lower
   LBE96:  ldx  #RevLimiterRPMOff ;REVLMT6_RPMLimiterNormalOffRPM    ; load index with value
Cutout_CheckRevLimitingValues:
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa 0x00, X        ; compare a with memory at index + value
           bcc  ShutOffEngineForThisRotation    ; branch if greater or equal
           cmpa SPDRPM_EngineSpeedHighLimitToEnableOverspeed    ; compare a with memory contents (data is d5)
           bcs  LBEAB          ; branch if lower
           ldab Temp1          ; load b with memory contents
           cmpb SPDLMH_SpeedLimitFuelShutoff254mph    ; compare b with memory contents (data is ff)
           bcc  ShutOffEngineForThisRotation    ; branch if greater or equal
   LBEAB:  brset *BitFlags67, #b67_FallToIdle, Cutout_CheckMPHLimitingValues    ; branch if bit(s) set
           bclr *BitFlags6A, #b6a_OverRev    ; clear bits
           brset *BitFlags6B, #$%00001000, LBEB9    ; branch if bit(s) set
           clr  Counter_FuelEngRunning    ; zero byte at memory location
   LBEB9:  rts                 ; return from subroutine

Cutout_CheckMPHLimitingValues:
           cmpa DFRPM2_2560RPM_DecelFuelShutoffUpperRpmLimit    ; compare a with memory contents (data is 36)
           bcs  LBEEB          ; branch if lower
           ldaa Temp0          ; load a with memory contents
           cmpa DFS20M_20MPHDecelFuelShutoffSpeedLimitOFF    ; compare a with memory contents (data is 14)
           bcs  LBEEB          ; branch if lower
           ldaa CoolantTemp    ; load a with memory contents
           cmpa DFSTMH_60DegCDecelFuelShutoffTempLimitOff    ; compare a with memory contents (data is 92)
           bcs  LBEEB          ; branch if lower
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa DFSTMRH_3minuteDecelFuelShutoffTimeLimitOFF    ; compare a with memory contents (data is 04)
           bcs  LBEEB          ; branch if lower
           ldaa MapValue       ; load a with memory contents
           cmpa DFSMPH_MAPDecelFuelShutoffTimeLimitOFF          ; compare a with memory contents (data is 24)
           bhi  LBEEB          ; branch if higher
           ldaa b5C_IPL1       ; load a with memory contents
           bita #0xe2          ;  -11100010-
           bne  LBEEB          ; branch if not equal (not zero)
           brclr *BitFlags69, #$%00000100, LBEEB    ; branch if bit(s) clear
           bset *BitFlags6A, #b6a_OverRev | b6a_FuelOff    ; set bits
   LBEE8:  clra                ; a = 0
           staa Counter_O2SensorFeedbackCount_Signed    ; store a into memory
   LBEEB:  rts                 ; return from subroutine

Cutout_UseHysteresisToDetermineWhenToTurnFuelBackOn:
           ldx  #Turbonator_Flags
           brset 0, x, #Turbonator_Staging, LBEFD
           brclr *BitFlags6B, #b6b_DecelFuelCut, LBEFD    ; branch if bit(s) clear
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  LBEF7          ; branch if greater or equal
           clra                ; a = 0
   LBEF7:  cmpa DFRPML_DecelFuelShutoffDeltaRPMOn    ; compare a with memory contents (data is 11)
           bls  Cutout_TurnFuelBackOn    ; branch if lower or same
           rts                 ; return from subroutine

   LBEFD:  brclr *BitFlags6A, #b6a_OverRev, LBF2F    ; branch if bit(s) clear
           brclr *BitFlags67, #b67_FallToIdle, Cutout_TurnFuelBackOn    ; branch if bit(s) clear
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa DFRPM1_2050RPM_DecelFuelShutoffTurnonLimit          ; compare a with memory contents (data is 34)
           bcs  Cutout_TurnFuelBackOn    ; branch if lower
           ldaa Temp0          ; load a with memory contents
           cmpa DFS20L_20MPHDecelFuelShutoffSpeedLimitON          ; compare a with memory contents (data is 10)
           bcs  Cutout_TurnFuelBackOn    ; branch if lower
           ldaa CoolantTemp    ; load a with memory contents
           cmpa DFSTML_60DegCDecelFuelShutoffTempLimitON          ; compare a with memory contents (data is 90)
           bcs  Cutout_TurnFuelBackOn    ; branch if lower
           ldaa MapValue       ; load a with memory contents
           cmpa DFSMPL_MAPDecelFuelShutoffTimeLimitON          ; compare a with memory contents (data is 27)
           bhi  Cutout_TurnFuelBackOn    ; branch if higher
           ldaa b5C_IPL1       ; load a with memory contents
           bita #0xe2          ;  -11100010-
           bne  Cutout_TurnFuelBackOn    ; branch if not equal (not zero)
           brset *BitFlags69, #$%00000100, LBEE8    ; branch if bit(s) set
Cutout_TurnFuelBackOn:
           bclr *BitFlags6A, #b6a_OverRev | b6a_FuelOff    ; clear bits
           rts                 ; return from subroutine

   LBF2F:  ldaa MapValue       ; load a with memory contents
           suba BaroPressure
           bcs  LBF3F          ; branch if lower
           brclr *b5D_IPL2, #b5d_WGSolFault, LBF46    ; branch if bit(s) clear
           cmpa LMPSHF_OverboostFuelShutoffDisablePointFromMap_Limp    ; compare a with memory contents (data is 73)
           bls  Cutout_DetermineLimpModeCutoutRPM    ; branch if lower or same
           rts                 ; return from subroutine

   LBF3F:  ldaa TRNTIM_OverboostFuelShutoffDuration    ; load a with memory contents (data is 8a)
           staa Timer_OverboostCountdown    ; store a into memory
           bra  Cutout_DetermineLimpModeCutoutRPM    ; branch

   LBF46:  suba MPSHFT_OverboostFuelShutoffEnablePointFromMap_Timer    ;  (data is 7b)
           bcs  LBF3F          ; branch if lower
           cmpa MPSHFA_OverboostFuelShutoffEnablePointFromMap_Absolute    ; compare a with memory contents (data is 11)
           bhi  LBF59          ; branch if higher
           ldaa Timer_OverboostCountdown    ; load a with memory contents
           beq  LBF59          ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_OverboostCountdown    ; store a into memory
           bra  Cutout_DetermineLimpModeCutoutRPM    ; branch

   LBF59:  ldd  #0x0708        ; load d (a&b) with value -00000111 00001000-
           jmp  ThrowNonCriticalError

Cutout_DetermineLimpModeCutoutRPM:
           ldx  #REVLMT_MapLimpinAndThrAbove25PercentLower1850    ; load index with value
           brclr *b5C_IPL1, #b5c_MapStuck | b5c_MapBadSignal, Cutout_MAPSENSOR_OKAY_OR_LIGHTTHROTTLE2    ; branch if bit(s) clear
           ldab THRTHR_25PctThrValueFromShutoff    ; load b with memory contents (data is 21)
           addb MINTHR_LowestSessionTPS    ; b=b+memory contents
           cmpb TpsVolts   
           bcs  LBF90          ; branch if lower
Cutout_MAPSENSOR_OKAY_OR_LIGHTTHROTTLE2:
           ldx  #REVLMT3_MapAbove75PctAndIdleSwitchClosed2000    ; load index with value
           brclr *b5C_IPL1, #b5c_TpsBadSignal, Cutout_THROTTLESENSOR_OKAY2    ; branch if bit(s) clear
           ldaa Temp0          ; load a with memory contents
           cmpa RVLSPD_CarSpeedForRevLimitWithTBOff    ; compare a with memory contents (data is 14)
           bcc  LBF8D          ; branch if greater or equal
           bra  LBF83          ; branch

Cutout_THROTTLESENSOR_OKAY2:
           ldab BitFlags66     ; load b with memory contents
           bmi  LBF8D          ; branch if minus(hi bit 1)
   LBF83:  ldab BaroPressure    ; load b with memory contents
           lsrb                ; logical shift right b
           tba                 ; a = b
           lsrb                ; logical shift right b
           aba                 ; a=a+b
           cmpa MapValue       ; compare a with memory contents
           bcs  LBF90          ; branch if lower
   LBF8D:  ldx  #RevLimiterRPMOn ; REVLMT5_RPMLimiterNormalOnRPM    ; load index with value
   LBF90:  ldaa EngineRpm_HB    ; load a with memory contents
           cmpa 0x00, X        ; compare a with memory at index + value
           bcc  LBFA5          ; branch if greater or equal
           cmpa SPDRPM2_EngineSpeedLowLimitToDisableOverspeed    ; compare a with memory contents (data is d1)
           bhi  LBF9E          ; branch if higher
   LBF9B:  jmp  Cutout_TurnFuelBackOn

   LBF9E:  ldaa Temp1          ; load a with memory contents
           cmpa SPDLML_SpeedLimitFuelShutoffRestore253mph    ; compare a with memory contents (data is fd)
           bls  LBF9B          ; branch if lower or same
   LBFA5:  rts                 ; return from subroutine

CalculatePartThrottleEnrichmentAndSparkScatterFuel_MM:
           ldx  #RPMMAP_SwitchPointForDownUp_FromRpm    ; load index with value
           ldaa EngineRpm_HB    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           
           cmpa MapValue       ; What is the purpose of this? The result does nothing. This makes no sense.
           
           rora            
           ldx  #PTENR_EppPerAmountForIncreasing        ; load index with value
           anda #0x80          ; AND a with value -10000000-
           bmi  LBFBA          ; branch if minus(hi bit 1)
           inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
   LBFBA:  staa Temp0          ; store a into memory
           tab                 ; b = a
           eorb Counter_FallingEdgeEPP_MaxFF
           bpl  LBFC7          ; branch if plus (hi bit 0)
           staa Counter_FallingEdgeEPP_MaxFF    ; store a into memory
           ldab Timer_OpenLoopFraction    ; load b with memory contents
           bra  LC02C          ; branch

   LBFC7:  ldab 0x00, X        ; load b with memory at index + value
           sei                 ; disable interrupts
           eora Counter_FallingEdgeEPP_MaxFF
           cba             
           bcs  LBFD0          ; branch if lower
           sba                 ; subtract (a=a-b)
   LBFD0:  oraa Temp0          ; OR a with memory contents
           staa Counter_FallingEdgeEPP_MaxFF    ; store a into memory
           cli                 ; enable interrupts
           ldab Timer_OpenLoopFraction    ; load b with memory contents
           bcs  LC02C          ; branch if lower
           addb 0x01, X        ; add memory at index + value to b
           bpl  LBFE3          ; branch if plus (hi bit 0)
           clrb                ; b = 0
           tsta                ; test a
           bpl  LBFE3          ; branch if plus (hi bit 0)
           ldab #0x7f          ; load b with value -01111111-
   LBFE3:  stab Temp0          ; store b into memory
           ldx  #PTELMT_MultiplierMaxLimitFromRpm    ; load index with value
           ldaa EngineRpm_HB    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp4          ; store a into memory
           ldx  #PTEADJ_EnrichAdjust_FromMap    ; load index with value
           ldaa MapValue       ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp4          ; load a with memory contents
           tstb            
           beq  LBFFF          ; branch if equal (zero)
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
   LBFFF:  tab                 ; b = a
           cmpb Temp0      
           bls  LC027          ; branch if lower or same
           brclr *BitFlags66, #b66_PTEisMaxed, LC023    ; branch if bit(s) clear
           ldab Timer_OpenLoopFraction    ; load b with memory contents
           beq  LC020          ; branch if equal (zero)
           sba                 ; subtract (a=a-b)
           staa Temp1          ; store a into memory
           ldaa PTENRD_AmountForDecreasingMultiplier_Negative    ; load a with memory contents (data is fd)
           beq  LC023          ; branch if equal (zero)
           nega                ; negate a (set high bit)
           ldab PTENUM_NumberToReturnToHOTMAP    ; load b with memory contents (data is 02)
           mul                 ; multiply (d=a*b)
           tsta                ; test a
           bne  LC023          ; branch if not equal (not zero)
           cmpb Temp1      
           bcc  LC023          ; branch if greater or equal
   LC020:  bclr *BitFlags66, #b66_PTEisMaxed    ; clear bits
   LC023:  ldab Temp0          ; load b with memory contents
           bra  LC02A          ; branch

   LC027:  bset *BitFlags66, #b66_PTEisMaxed    ; set bits
   LC02A:  stab Timer_OpenLoopFraction    ; store b into memory
   LC02C:  brclr *BitFlags66, #b66_OffIdle, LC032    ; branch if bit(s) clear
           bne  LC039          ; branch if not equal (not zero)
   LC032:  ldaa MapValue       ; load a with memory contents
           cmpa BOOSTP_AdjustO2ResponseForPTEWhenMapAboveThis    ; compare a with memory contents (data is 81)
           bcs  LC040          ; branch if lower
   LC039:  ldaa Counter_O2SensorFeedbackCount_Signed    ; load a with memory contents
           bpl  LC040          ; branch if plus (hi bit 0)
           clra                ; a = 0
           staa Counter_O2SensorFeedbackCount_Signed    ; store a into memory
   LC040:  ldaa BatteryVolts    ; load a with memory contents
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
           bls  LC066          ; branch if lower or same
           brset *BitFlags67, #b67_IdleSpeedMode, LC066    ; branch if bit(s) set
           brset *BitFlags6E, #b6e_UseSparkScatter, UsingSparkScatterToControlIdle    ; branch if bit(s) set
   LC066:  ldd  Temp0          ; load d (a&b) with memory contents
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
           lsrd                ; shift right (d=d/2) /16 total
           tsta                ; test a
           beq  LC092          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   LC092:  tba                 ; a = b
           jsr  Lookup4ByteTable    ; call subroutine
           clra                ; a = 0
           rts                 ; return from subroutine

CalculateSumOfAllFuelModifiers_MM:
           brset *BitFlags6D, #b6d_FuelEngineNotRunning, ClearTemp0ForResultStorage    ; branch if bit(s) set
           ldx  #TMPHLD_TempSwitchPointForCurveAHoldDecay    ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           cmpa 0x00, X        ; compare a with memory at index + value
           bcs  LC0A6          ; branch if lower
           inx                 ; increment index (x=x+1)
   LC0A6:  brset *BitFlags67, #$%00000010, LC0C9    ; branch if bit(s) set
           brset *BitFlags66, #b66_O2Valid, LC0C3    ; branch if bit(s) set
           ldd  KeyOnOrEngineRunningTime    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           bcs  LC0C3          ; branch if lower
           asld                ; shift left (d=d*2)
           bcs  LC0C3          ; branch if lower
           cmpa 0x01, X        ; compare a with memory at index + value
           bcc  LC0C3          ; branch if greater or equal
           ldx  #DCYTMC_CurveAColdDecayTime    ; load index with value
           cmpa 0x02, X        ; compare a with memory at index + value
           bcc  LC0C9          ; branch if greater or equal
           bra  ClearTemp0ForResultStorage    ; branch

   LC0C3:  bset *Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached, #$%11111111    ; set bits
           bset *BitFlags67, #$%00000010    ; set bits
   LC0C9:  brset *Counter_MainLoop, #$%00011111, LC0CF    ; branch if bit(s) set
           bra  ClearTemp0ForResultStorage    ; branch

   LC0CF:  ldab Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached    ; load b with memory contents
           subb 0x03, X    
           bcc  LC0D6          ; branch if greater or equal
           clrb                ; b = 0
   LC0D6:  stab Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached    ; store b into memory
ClearTemp0ForResultStorage:
           clra                ; a = 0
           staa Temp0          ; store a into memory
           brset *BitFlags66, #b66_FullThrottle, INCLUDE_COOLANTTEMP_ANDIFNOTFLOORED_RPM_COMBINATION    ; branch if bit(s) set
           brset *BitFlags66, #b66_PTEisMaxed, INCLUDE_COOLANTTEMP_ANDIFNOTFLOORED_RPM_COMBINATION    ; branch if bit(s) set
           brset *BitFlags66, #b66_OffIdle, LC0EB    ; branch if bit(s) set
           brset *BitFlags6B, #$%00010000, INCLUDE_COOLANTTEMP_ANDIFNOTFLOORED_RPM_COMBINATION    ; branch if bit(s) set
   LC0EB:  jsr  AllowForHeatSoakAfterStall    ; call subroutine
           brset *BitFlags67, #$%00000010, LC103    ; branch if bit(s) set
           ldx  #CURVEC_FuelColdEnrichmentCurveC    ; load index with value
           staa Temp1          ; store a into memory
           jsr  Lookup4ByteTable    ; call subroutine
           ldab Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           staa Temp0          ; store a into memory
           ldaa Temp1          ; load a with memory contents
   LC103:  ldx  #CURVEA_FuelColdEnrichmentCurveA    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           brclr *BitFlags67, #$%00000010, LC112    ; branch if bit(s) clear
           ldab Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
   LC112:  adda Temp0      
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
           brset *BitFlags66, #b66_FullThrottle, LC187    ; branch if bit(s) set
           brset *BitFlags66, #b66_PTEisMaxed, LC187    ; branch if bit(s) set
           ldx  #HIGHM2_ColdLoadFromCoolantTemp2    ; load index with value
           brset *BitFlags66, #b66_OffIdle, LC14C    ; branch if bit(s) set
           ldx  #HIGHMP_ColdLoadFromCoolantTemp    ; load index with value
   LC14C:  ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp4          ; store a into memory
           ldx  #HMPMU2_ColdLoadFromMAP2    ; load index with value
           brset *BitFlags66, #b66_OffIdle, LC15D    ; branch if bit(s) set
           ldx  #HMPMUL_ColdLoadFromMAP    ; load index with value
   LC15D:  ldaa MapValue       ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa Temp4          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           stD *Temp2          ; store D to RAM - Temp2 is later possibly used as the PTE Value
           ldx  #PEFTBL2_PumpingEfficiency2        ; load index with value
           brset *BitFlags66, #b66_OffIdle, LC176    ; branch if bit(s) set
           ldx  #PEFTBL_PumpingEfficiency    ; load index with value
   LC176:  ldaa EngineRpm_HB    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           ldY Temp2           ; load Y index
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           addd Temp0          ; d = d + memory contents
           stD *Temp0          ; store D to RAM
   LC187:  ldd  Temp0          ; load d (a&b) with memory contents
           pshb                ; push b onto stack
           psha                ; push a onto stack
           lsrd                ; shift right (d=d/2)
           stD *Temp0          ; store D to RAM
           ldaa BaroPressure    ; load a with memory contents
           ldx  #BAROCP_BaroCompensationOfWarmupFactor_FromBaro    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           puly                ; pop Y from stack
           beq  LC1A8          ; branch if equal (zero)
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           addd Temp0          ; d = d + memory contents
           bcc  HandleOffThrottleEnrich    ; branch if greater or equal
           ldd  #0xffff         ; load d (a&b) with value -11111111 11111111-
           bra  HandleOffThrottleEnrich    ; branch

   LC1A8:  ldd  Temp0          ; load d (a&b) with memory contents
HandleOffThrottleEnrich:
           inca                ; increment a
           stD *Temp0          ; store D to RAM
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           stab BaseFuelModifier          ; store b into memory
           ldaa ChargeTempVolts    ; load a with memory contents
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
           brset *BitFlags66, #b66_FullThrottle, LC203    ; branch if bit(s) set
           clra                ; a = 0
           ldab Timer_OpenLoopFraction    ; load b with memory contents
           bne  LC1FF          ; branch if not equal (not zero)
           ldab ValueFromAdaptiveMemory    ; load b with memory contents
           bmi  LC1F7          ; branch if minus(hi bit 1)
   LC1F6:  inca                ; increment a
   LC1F7:  asrb            
           jsr  ScaleXbyB_addingA_intoD    ; call subroutine
           stD *Temp0          ; store D to RAM
           bra  LC203          ; branch

   LC1FF:  ldab ValueFromAdaptiveMemory    ; load b with memory contents
           bpl  LC1F6          ; branch if plus (hi bit 0)
   LC203:  clra                ; a = 0
           ldab Counter_O2SensorFeedbackCount_Signed    ; load b with memory contents
           brclr *EGRVar2, #$%10000000, LC211    ; branch if bit(s) clear
           addb ADMEMA_ValueFromAdaptivememoryAdder1    ;  (data is ff)
           bvc  LC211          ; branch if overflow
           ldab #0x7f          ; load b with value -01111111-
   LC211:  tstb            
           bmi  LC215          ; branch if minus(hi bit 1)
           inca                ; increment a
   LC215:  asrb            
           jsr  ScaleXbyB_addingA_intoD    ; call subroutine
           stD *Temp0          ; store D to RAM
           clrb                ; b = 0
           brset *BitFlags66, #b66_OffIdle, INCLUDE_OXYGEN_FEEDBACK_WITHRPM_COMBINATION    ; branch if bit(s) set
           ldaa CONFIG2_ConfigurationFlags2    ; load a with memory contents (data is c7)
           bita #0x40          ;  -01000000-
           beq  LC22B          ; branch if equal (zero)
           brclr *BitFlags6B, #$%00010000, INCLUDE_OXYGEN_FEEDBACK_WITHRPM_COMBINATION    ; branch if bit(s) clear
   LC22B:  ldaa EngineRpm_HB    ; load a with memory contents
           suba TargetIdleSpeedHB
           bcc  LC232          ; branch if greater or equal
           clra                ; a = 0
   LC232:  ldx  #DFBFMD_DefaultBaseFuelModifierFromRPMOverIdle        ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
INCLUDE_OXYGEN_FEEDBACK_WITHRPM_COMBINATION:
           clra                ; a = 0
           stab BaseFuelScalar    ; store b into memory
           bne  LC23E          ; branch if not equal (not zero)
           inca                ; increment a
   LC23E:  ldx  #Temp0         ; load index with value
           jsr  ScaleXbyB_addingA_intoD    ; call subroutine
           stD *SumOfFuelModifiers_HB    ; store D to RAM
           rts                 ; return from subroutine

AllowForHeatSoakAfterStall:
           ldaa CoolantTemp    ; load a with memory contents
           cmpa RUNLMT_MaxAllowableTempFor_RUNTMP    ; compare a with memory contents (data is 80)
           bcc  LC261          ; branch if greater or equal
           ldaa EngineRunningTimeBeforeStall    ; load a with memory contents
           ldx  #RUNTMP_ModifierOf_ENGTMP_FromStalltime    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           adda CoolantTemp
           ldab RUNLMT_MaxAllowableTempFor_RUNTMP    ; load b with memory contents (data is 80)
           bcs  LC260          ; branch if lower
           cba             
           bcs  LC261          ; branch if lower
   LC260:  tba                 ; a = b
   LC261:  rts                 ; return from subroutine

DealWithSpecialIdle_SetBasicTiming_MM:
           brset *BitFlags66, #b66_OffIdle, THROTTLE_PRESSED1    ; branch if bit(s) set
           ldaa RICHSA_OpenLoopEnrichFactorWhenSettingBasicTiming    ; load a with memory contents (data is 1a)
           brset *b5C_IPL1, #b5c_BadCoolantTemp, LC279    ; branch if bit(s) set
           brset *BitFlags6C, #$%00100000, LC279    ; branch if bit(s) set
           ldaa RIDLST_OpenLoopEnrichFactorWhenSettingMinThrottleOpening    ; load a with memory contents (data is 1a)
           brset *BitFlags6C, #b6c_DRBModeFlag, LC279    ; branch if bit(s) set
           clra                ; a = 0
   LC279:  brclr *Timer_FuelEnrich, #$%11111111, LOAD_FUELENRICHVAR    ; branch if bit(s) clear
           tsta                ; test a
           bne  LOAD_FUELENRICHVAR    ; branch if not equal (not zero)
           ldaa O2ITIM_TimeO2InhibitedSwitchingRichIdleToClosedLoop    ; load a with memory contents (data is ff)
           staa Timer_O2InhibitSwitchingRichIdleToClosedLoop    ; store a into memory
THROTTLE_PRESSED1:
           clra                ; a = 0
LOAD_FUELENRICHVAR:
           staa Timer_FuelEnrich    ; store a into memory
           beq  LC28F          ; branch if equal (zero)
           clra                ; a = 0
           staa Counter_O2SensorFeedbackCount_Signed    ; store a into memory
           staa Counter_AdaptiveMem_Erase    ; store a into memory
   LC28F:  rts                 ; return from subroutine


;	.org	0xc290
CrankPickupIntrAddressTable:
	.word	CrankInterrupt_FallingEdge
	.word	CrankInterrupt_HandleCamSensorRisingEdgeA
	.word	CrankInterrupt_HandleCamSensorRisingEdgeB
	.word	CrankInterrupt_CalculateFuel

;	.org	0xc298
NotSure1:
	.word	0x0401
	.word	0xFBFE
	.word	0x1008

Interrupt_CrankSensor_Signal:
           ldx  #SwitchPortAccessReg2    ; load index with value
           ldd  CPU_TimerInputCapture3_CrankSensor
           addd #0x0010    ;  -00000000 00010000-
           cmpD CPU_TimerCounterRegHigh    ; compare D
           bmi  LC2B7          ; branch if minus(hi bit 1)
   LC2AD:  brclr  0, X, #$%00000001, LC2C7    ; branch if bit(s) clear
           cmpD CPU_TimerCounterRegHigh    ; compare D
           bpl  LC2AD          ; branch if plus (hi bit 0)
   LC2B7:  ldaa PIA_Ctrl_3          ; load a with memory contents
           anda #0xfe          ; AND a with value -11111110-
           staa PIA_Ctrl_3      
           bclr *BitFlags_BF, #$%00000011    ; clear bits
           bset *BitFlags_BF, #$%11000100    ; set bits
           bra  LC2CA          ; branch

   LC2C7:  clr  PIA_Ctrl_6          ; zero byte at memory location
   LC2CA:  ldaa #0x01          ; load a with value -00000001-
           staa PIA_Ctrl_4      
           staa CPU_TimerInterruptFlag1
           rti                 ; return from interrupt

Interrupt_CamSensorSignal:
           ldaa #0x04          ; load a with value -00000100-
           staa CPU_TimerInterruptFlag1
           ldaa CPU_PortA_Control    ; load a with memory contents
           bita #0x20          ;  -00100000-
           beq  LC307          ; branch if equal (zero)
           clrb                ; b = 0
           ldaa CPU_PulseAccCounterRegister    ; load a with memory contents
           stab CPU_PulseAccCounterRegister    ; store b into memory
           ldab #0x20          ; load b with value -00100000-
           bitb CPU_TimerInterruptFlag2
           beq  LC2F2          ; branch if equal (zero)
           ldaa #0xff          ; load a with value -11111111-
           stab CPU_TimerInterruptFlag2    ; store b into memory
   LC2F2:  ldx  TimerOverflowsBetweenCamPulses
           cpx  #0x0014    ;  -00000000 00010100-
           bls  LC32A          ; branch if lower or same
           cpx  #0x0020    ;  -00000000 00100000-
           bhi  LC302          ; branch if higher
           cmpa #0x01          ; compare a with value -00000001-
           bcc  LC32A          ; branch if greater or equal
   LC302:  cmpa #0x02          ; compare a with value -00000010-
           bcc  LC32A          ; branch if greater or equal
           rti                 ; return from interrupt

   LC307:  ldab #0x20          ; load b with value -00100000-
           bitb CPU_TimerInterruptFlag2
           beq  LC314          ; branch if equal (zero)
           stab CPU_TimerInterruptFlag2    ; store b into memory
           jmp  LC395      

   LC314:  ldaa CPU_PulseAccCounterRegister    ; load a with memory contents
           ldab BitFlags_BF    ; load b with memory contents
           andb #0x07          ;  -00000111-
           cmpb #0x04          ;  -00000100-
           beq  LC32A          ; branch if equal (zero)
           deca                ; decrement a
           sba                 ; subtract (a=a-b)
           beq  LC32A          ; branch if equal (zero)
           cmpa #0x01          ; compare a with value -00000001-
           bne  LC395          ; branch if not equal (not zero)
           inc  BitFlags_BF
   LC32A:  clrb                ; b = 0
           stab ATMOffset      ; store b into memory
           ldaa DRBPointer1    ; load a with memory contents
           cmpa #0x0a          ; compare a with value -00001010-
           bne  LC335          ; branch if not equal (not zero)
           stab DRBPointer1    ; store b into memory
   LC335:  bset *BitFlags70, #b70_O2Enable    ; set bits
           brclr *BitFlags_BF, #$%10000000, LC395    ; branch if bit(s) clear
           ldaa #0x01          ; load a with value -00000001-
           bita PIA_Ctrl_5      
           beq  LC34A          ; branch if equal (zero)
           ldaa #0xf9          ; load a with value -11111001-
           staa PIA_Ctrl_5      
           bra  LC395          ; branch

   LC34A:  ldaa PIA_Ctrl_6          ; load a with memory contents
           beq  LC395          ; branch if equal (zero)
           cmpa #0x04          ; compare a with value -00000100-
           bhi  LC395          ; branch if higher
           bne  LC356          ; branch if not equal (not zero)
           clra                ; a = 0
   LC356:  brclr *BitFlags_BF, #$%00000100, LC37B    ; branch if bit(s) clear
           bclr *BitFlags_BF, #$%00000111    ; clear bits
           brset *BitFlags6E, #b6e_SearchBladeEndRef, LC36F    ; branch if bit(s) set
           bset *BitFlags6E, #b6e_SearchBladeEndRef    ; set bits
           bclr *BitFlags6E, #b6e_InjectorAandB    ; clear bits
           eora #0x02          ; XOR a with value -00000010-
           oraa BitFlags6E     ; OR a with memory contents
           staa BitFlags6E     ; store a into memory
           bra  LC384          ; branch

   LC36F:  brset *BitFlags6E, #b6e_InjectorAandB, LC378    ; branch if bit(s) set
           inc  BitFlags6E 
           bra  LC37B          ; branch

   LC378:  bclr *BitFlags6E, #b6e_InjectorAandB    ; clear bits
   LC37B:  ldab BitFlags6E     ; load b with memory contents
           andb #b6e_InjectorAandB          ;  -00000011-
           eorb #b6e_InjectorB          ;  -00000010-
           cba             
           bne  LC395          ; branch if not equal (not zero)
   LC384:  ldab BitFlags_BF    ; load b with memory contents
           incb            
           stab BitFlags_BF    ; store b into memory
           andb #0x07          ;  -00000111-
           decb            
           lslb            
           ldx  #CrankPickupIntrAddressTable    ; load index with value
           abx                 ; add b to index
           ldx  0x00, X    
           jmp  0x00, X        ; indexed jump

   LC395:  bclr *BitFlags6E, #b6e_SearchBladeEndRef | b6e_InjectorAandB    ; clear bits
           ldaa #0x40          ; load a with value -01000000-
           staa BitFlags_BF    ; store a into memory
           clr  CPU_PulseAccCounterRegister    ; zero byte at memory location
           ldaa #0x01          ; load a with value -00000001-
           staa PIA_Ctrl_4      
           staa CPU_TimerInterruptFlag1
           clr  PIA_Ctrl_6          ; zero byte at memory location
           oraa PIA_Ctrl_3      
           staa PIA_Ctrl_3      
           rti                 ; return from interrupt

CrankInterrupt_FallingEdge:
           ldaa #0x10          ; load a with value -00010000-
           staa CPU_A2DControlReg
           ldd  CPU_TimerInputCapture1_CamSensor
           jsr  DetermineNumberOfOverflowsBetweenCamSensorPulses_MM    ; call subroutine
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           oraa #0x0a          ;  -00001010-
           staa CPU_TimerControlReg1
           ldaa Counter_TimerPastHalfwayBetweenCamPulses    ; load a with memory contents
           lsra            
           staa TimerOverflowsBetweenCamPulses    ; store a into memory
           ldd  CPU_TimerInputCapture1_CamSensor
           subd LastCamFallingEdgeTime    ; d = d - memory contents
           stD *DistributorFallingEdgePulsewidth_HB    ; store D to RAM
           ldd  CPU_TimerInputCapture1_CamSensor
           stD *LastCamFallingEdgeTime    ; store D to RAM
           clra                ; a = 0
           staa Counter_TimerPastHalfwayBetweenCamPulses    ; store a into memory
           brclr *BitFlags70, #$%10000000, ReadKnockSensorAndRecalcSparkPosition    ; branch if bit(s) clear
           ldab BitFlags6E     ; load b with memory contents
           andb #b6e_InjectorAandB          ;  -00000011-
           decb            
           andb #b6e_InjectorAandB          ;  -00000011-
           ldx  #NotSure5      ; load index with value
           abx                 ; add b to index
           ldab 0x00, X        ; load b with memory at index + value
           ldx  #InjectorPulsewidth_HB_Cyl1    ; load index with value
           abx                 ; add b to index
           ldd  BaseInjectorPulsewidth_HB    ; load d (a&b) with memory contents
           std  0x00, X        ; store d into index plus offset
           cmpD #0x007D        ; compare D -00000000 01111101-
           bls  ReadKnockSensorAndRecalcSparkPosition    ; branch if lower or same
           bset *BitFlags6E, #b6e_DistSync    ; set bits
           ldaa #0x04          ; load a with value -00000100-
           staa PIA_Ctrl_4      
ReadKnockSensorAndRecalcSparkPosition:
           ldx  #Cylinder2Retard    ; load index with value
           ldab BitFlags6E     ; load b with memory contents
           andb #b6e_InjectorAandB          ;  -00000011-
           decb            
           andb #b6e_InjectorAandB          ;  -00000011-
           abx                 ; add b to index
           ldaa CalculatedSparkAdvance    ; load a with memory contents
           suba 0x00, X    
           bcc  LC411          ; branch if greater or equal
           clra                ; a = 0
   LC411:  staa AdvanceTemporary    ; store a into memory
           jsr  NULL_ROUTINE    ; call subroutine
           staa AdvanceTemporary    ; store a into memory
           ldaa #0x93          ; 73.5 degrees between rising/falling edges
           suba AdvanceTemporary
           ldab #0xb6          ; 71% again ; what does this number mean!!!!???
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           ldY DistributorFallingEdgePulsewidth_HB    ; load Y index
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           addd CPU_TimerInputCapture1_CamSensor
           subd #0x000a        ;  -00000000 00001010-
           stD *Temp5          ; store D to RAM
           ldab Timer_Dwell_14    ; load b with memory contents
           ldaa BitFlags6E     ; load a with memory contents
           anda #b6e_InjectorA          ; AND a with value -00000001-
           beq  LC43B          ; branch if equal (zero)
           ldab Timer_Dwell_23    ; load b with memory contents
   LC43B:  clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd #0x07d0        ;  -00000111 11010000-   ADWELL?
           stD *Temp7          ; store D to RAM
           ldd  Temp5          ; load d (a&b) with memory contents
           subd Temp7          ; d = d - memory contents
           stD *Temp7          ; store D to RAM
           ldab BitFlags6E     ; load b with memory contents
           andb #b6e_InjectorA          ;  -00000001-
           ldx  #CPU_Timer_OC4_DwellA    ; load index with value
           ldY #NotSure1       ; load Y index -11000010 10011000-
           aby                 ; add b to y
           lslb            
           abx                 ; add b to index
           ldaa TimerOverflowsBetweenCamPulses    ; load a with memory contents
           bne  LC46A          ; branch if not equal (not zero)
           ldab STRNTR_SparkStartRunTransferPointRpm    ; load b with memory contents (data is 62)
           brset *BitFlags6D, #b6d_DisableNormalDwell, LC466    ; branch if bit(s) set
           ldab RNSTTR_SparkRunStartTransferPointRpm    ; load b with memory contents (data is 82)
   LC466:  cmpb DistributorFallingEdgePulsewidth_HB
           bcc  LC46F          ; branch if greater or equal
   LC46A:  bset *BitFlags6D, #b6d_DisableNormalDwell    ; set bits
           bra  LC478          ; branch

   LC46F:  bclr *BitFlags6D, #b6d_DisableNormalDwell    ; clear bits
           ldab DistributorFallingEdgePulsewidth_HB    ; load b with memory contents
           cmpb #0x50          ;  -01010000-
           bcs  LC47B          ; branch if lower
   LC478:  jmp  LC522      

   LC47B:  ldd  Temp7          ; load d (a&b) with memory contents
           std  0x00, X        ; store d into index plus offset
           ldaA 0x04, Y       ; load A indexed to Y -00000100-
           tab                 ; b = a
           oraa CPU_TimerInterruptMask1
           staa CPU_TimerInterruptMask1
           stab CPU_TimerInterruptFlag1    ; store b into memory
           ldab CPU_TimerControlReg1    ; load b with memory contents
           oraB 0x00, Y       ; or B with memory at index Y + value -00000000-
           stab CPU_TimerControlReg1    ; store b into memory
           ldd  0x00, X    
           subd #0x0080    ;  -00000000 10000000- MINADW?
           subd CPU_TimerCounterRegHigh
           bpl  LC4C9          ; branch if plus (hi bit 0)
           ldaA 0x04, Y       ; load A indexed to Y -00000100-
           staa CPU_HardwareTimerForceCompare
           ldd  Temp5          ; load d (a&b) with memory contents
           std  0x00, X        ; store d into index plus offset
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           andA 0x02, Y       ; and A with memory at index Y + value -00000010-
           staa CPU_TimerControlReg1
           ldaA 0x04, Y       ; load A indexed to Y -00000100-
           coma            
           anda CPU_TimerInterruptMask1
           staa CPU_TimerInterruptMask1
           ldd  0x00, X    
           subd CPU_TimerCounterRegHigh
           bpl  LC4C9          ; branch if plus (hi bit 0)
           ldaA 0x04, Y       ; load A indexed to Y -00000100-
           staa CPU_HardwareTimerForceCompare
   LC4C9:  ldab BitFlags6E     ; load b with memory contents
           andb #b6e_InjectorA          ;  -00000001-
           eorb #b6e_InjectorA          ;  -00000001-
           tba                 ; a = b
           ldY #NotSure1       ; load Y index -11000010 10011000-
           aby                 ; add b to y
           lslb            
           ldx  #CPU_Timer_OC4_DwellA    ; load index with value
           abx                 ; add b to index
           ldab Timer_Dwell_14    ; load b with memory contents
           tsta                ; test a
           beq  LC4E2          ; branch if equal (zero)
           ldab Timer_Dwell_23    ; load b with memory contents
   LC4E2:  clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd #0x07d0        ;  -00000111 11010000-
           stD *Temp7          ; store D to RAM
           ldd  Temp5          ; load d (a&b) with memory contents
           subd Temp7          ; d = d - memory contents
           addd DistributorFallingEdgePulsewidth_HB    ; d = d + memory contents
           std  0x00, X        ; store d into index plus offset
           ldab CPU_TimerControlReg1    ; load b with memory contents
           oraB 0x00, Y       ; or B with memory at index Y + value -00000000-
           stab CPU_TimerControlReg1    ; store b into memory
           ldaB 0x04, Y       ; load B with value indexed to Y -00000100-
           tba                 ; a = b
           orab CPU_TimerInterruptMask1
           stab CPU_TimerInterruptMask1    ; store b into memory
           staa CPU_TimerInterruptFlag1
           ldd  0x00, X    
           subd #MapAverageValue_HB    ;  -00000000 10000000-
           subd CPU_TimerCounterRegHigh
           bpl  LC522          ; branch if plus (hi bit 0)
           ldaA 0x04, Y       ; load A indexed to Y -00000100-
           staa CPU_HardwareTimerForceCompare
           ldaA 0x04, Y       ; load A indexed to Y -00000100-
           coma            
           anda CPU_TimerInterruptMask1
           staa CPU_TimerInterruptMask1
   LC522:  ldaa CPU_A2DControlReg    ; load a with memory contents
           bpl  LC522          ; branch if plus (hi bit 0)
           ldaa #0x06          ; load a with value -00000110-
           ldab CPU_A2DResults1    ; load b with memory contents
           staa CPU_A2DControlReg
           brset *BitFlags68, #b68_SparkEngineNotRunning, LC59B    ; branch if bit(s) set
           stab MapVolts       ; store b into memory
           ldaa BitFlags608D          ; load a with memory contents
           anda #0x0f          ; AND a with value -00001111-
           inca                ; increment a
           cmpa MPDELX_DeltaMapThatChecksGoodX    ; compare a with memory contents (data is 02)
           bcc  LC566          ; branch if greater or equal
           inc  BitFlags608D      
           jmp  LC5F8


;	.org	0xc546
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
	.word   0x2010
	.word	0x1010
	.word   0x1010

   LC566:  ldx  #BitFlags608D         ; load index with value
           bclr  0, X, #$%00001111    ; bit clear
           ldaa MapValue_X     ; load a with memory contents
           suba MapVolts_X 
           stab MapValue_X     ; store b into memory
           stab MapVolts_X     ; store b into memory
           brset *b5C_IPL1, #b5c_MapStuck, LC59D    ; branch if bit(s) set
           cmpa MPDELT_DeltaMapThatChecksGood    ; compare a with memory contents (data is 01)
           bcc  LC5F2          ; branch if greater or equal
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           cmpD MPRPML_DisableMapCheckUnderThisRpm_600    ; compare D (data is 12)
           bcs  LC5F8          ; branch if lower
           cmpD MPRPMH_DisableMapCheckAboveThisRpm_1500    ; compare D (data is 2e)
           bcc  LC5F8          ; branch if greater or equal
           ldaa MapVolts       ; load a with memory contents
           cmpa MPDAGL_DisableMapCheckBelowThisMap    ; compare a with memory contents (data is 10)
           bcs  LC5F8          ; branch if lower
           cmpa MPDAGH_DisableMapCheckAboveThisMap    ; compare a with memory contents (data is 81)
           bcs  LC5C1          ; branch if lower
   LC59B:  bra  LC5F8          ; branch

   LC59D:  suba MPDELT_DeltaMapThatChecksGood    ;  (data is 01)
           bcs  LC5F2          ; branch if lower
           cmpa MPDELA_MatureMapLimpinWhenDeltaAbove_MPDELT_plus_MPDELA    ; compare a with memory contents (data is 01)
           bcs  LC5F2          ; branch if lower
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           cmpD #PIA2_Buffer    ; compare D -00000000 01000000-
           bcc  LC5C1          ; branch if greater or equal
           brset *BitFlags66, #b66_OffIdle, LC5C1    ; branch if bit(s) set
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  LC5BB          ; branch if greater or equal
           coma            
           comb            
   LC5BB:  cmpD MPRMPD_CheckMapAtZeroSpeedAndThisDeltaRpm    ; compare D (data is 02)
           bcs  LC5F2          ; branch if lower
   LC5C1:  ldab BitFlags608D          ; load b with memory contents
           addb #0x10          ;  -00010000-
           bcc  LC5CA          ; branch if greater or equal
           orab #0xf0          ;  -11110000-
   LC5CA:  stab BitFlags608D          ; store b into memory
           ldab MPDELX_DeltaMapThatChecksGoodX    ; load b with memory contents (data is 02)
           ldx  #NotSure2      ; load index with value
           abx                 ; add b to index
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa #0x20          ; compare a with value -00100000-
           bls  LC5DD          ; branch if lower or same
           ldab #0x10          ; load b with value -00010000-
           abx                 ; add b to index
   LC5DD:  ldaa 0x00, X        ; load a with memory at index + value
           cmpa BitFlags608D          ; compare a with memory contents
           bcc  LC5F8          ; branch if greater or equal
           brset *b5C_IPL1, #b5c_MapStuck, LC5ED    ; branch if bit(s) set
           bset *BitFlags5E, #b5e_MapOK    ; set bits
           bra  LC5F2          ; branch

   LC5ED:  ldaa #0x08          ; load a with value -00001000-
           jsr  ResetErrorCodeIfTimerExpired    ; call subroutine
   LC5F2:  ldx  #BitFlags608D         ; load index with value
           bclr  0, X, #$%11110000    ; bit clear
   LC5F8:  ldab #0x10          ; load b with value -00010000-
   LC5FA:  ldaa CPU_A2DControlReg    ; load a with memory contents
           bpl  LC5FA          ; branch if plus (hi bit 0)
           ldaa CPU_A2DResults1    ; load a with memory contents
           stab CPU_A2DControlReg    ; store b into memory
           brclr *BitFlags6D, #b6d_DisableNormalDwell, LC60A    ; branch if bit(s) clear
           clra                ; a = 0
   LC60A:  staa KnockVolts     ; store a into memory
           bset *PIA3_Buffer, #pi3_KnockCap    ; set bits
           ldaa PIA3_Buffer    ; load a with memory contents
           staa PIA3_Buffer_2
           brset *BitFlags6B, #b6b_DecelFuelCut, DontUseSparkScatter    ; branch if bit(s) set
           ldaa SparkScatter    ; load a with memory contents
           adda SparkScatterIncrement
           bvc  DoUseSparkScatter    ; branch if overflow
           ldab DesiredNewAisPosition    ; load b with memory contents
           cmpb CurrentAisPosition
           bne  DontUseSparkScatter    ; branch if not equal (not zero)
           ldab FTUNPW_FineTuneStepForAis    ; load b with memory contents (data is 01)
           beq  DontUseSparkScatter    ; branch if equal (zero)
           tsta                ; test a
           bmi  LC634          ; branch if minus(hi bit 1)
           ldaa DesiredNewAisPosition    ; load a with memory contents
           sba                 ; subtract (a=a-b)
           bcc  SaveDesiredAisPosition    ; branch if greater or equal
           clra                ; a = 0
           bra  SaveDesiredAisPosition    ; branch

   LC634:  ldaa AISHLM_AisHighLimitMaxOpenSteps    ; load a with memory contents (data is a0)
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
           beq  LC64B          ; branch if equal (zero)
           staa Counter_SomethingWithCamSensor    ; store a into memory
   LC64B:  bset *PIA3_Buffer, #pi3_Tach    ; set bits
           ldaa PIA3_Buffer    ; load a with memory contents
           staa PIA3_Buffer_2
           ldaa FDRVar0        ; load a with memory contents
           bita #0x01          ;  -00000001-
           beq  LC66A          ; branch if equal (zero)
           bita #0x08          ;  -00001000-
           beq  LC66A          ; branch if equal (zero)
           ldx  FDRVar3    
           ldab FDRVar2        ; load b with memory contents
           jsr  FDRSerialIORoutine          ; call subroutine
           cmpa #0xfc          ; compare a with value -11111100-
           bne  LC66A          ; branch if not equal (not zero)
           staa FDRVar0        ; store a into memory
   LC66A:  rti                 ; return from interrupt




NotSure4:
         .word	0x0108
         

   LC66D:  jmp  LC74B

CrankInterrupt_HandleCamSensorRisingEdgeA:
           ldd  TimerOverflowsBetweenCamPulses    ; load d (a&b) with memory contents
           cmpD #Timer_DacalCountdown    ; compare D -00000000 00001110-
           bcs  LC66D          ; branch if lower
           ldd  CPU_TimerInputCapture1_CamSensor
           stD *L00F5          ; store D to RAM
           subd LastCamFallingEdgeTime    ; d = d - memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           xgDY                ; exchange D and Y
           ldaa #0x66          ; load a with value -01100110-
           suba AdvanceTemporary
           bcs  LC66D          ; branch if lower
           ldab #0xb6          ; load b with value -10110110-
           mul                 ; multiply (d=a*b)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           addd CPU_TimerInputCapture1_CamSensor
           subd #DCCOR4_AdaptiveWastegateCellTo5504rpm    ;  -00000000 00001010-
           stD *Temp5          ; store D to RAM
           ldab BitFlags6E     ; load b with memory contents
           andb #b6e_InjectorA          ;  -00000001-
           tba                 ; a = b
           ldY #NotSure1       ; load Y index -11000010 10011000-
           aby                 ; add b to y
           lslb            
           ldx  #CPU_Timer_OC4_DwellA    ; load index with value
           abx                 ; add b to index
           ldab Timer_Dwell_14    ; load b with memory contents
           tsta                ; test a
           beq  LC6B4          ; branch if equal (zero)
           ldab Timer_Dwell_23    ; load b with memory contents
   LC6B4:  clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd #0x07d0        ;  -00000111 11010000-
           stD *Temp7          ; store D to RAM
           brset *BitFlags6D, #b6d_DisableNormalDwell, LC6C6    ; branch if bit(s) set
           ldaa DistributorFallingEdgePulsewidth_HB    ; load a with memory contents
           cmpa #0x50          ; compare a with value -01010000-
           bcs  LC6D7          ; branch if lower
   LC6C6:  ldaa CPU_TimerControlReg1    ; load a with memory contents
           oraA 0x00, Y       ; or A with memory at index Y + value -00000000-
           staa CPU_TimerControlReg1
           ldaB 0x04, Y       ; load B with value indexed to Y -00000100-
           stab CPU_TimerInterruptFlag1    ; store b into memory
           bra  LC745          ; branch

   LC6D7:  ldaa CPU_PortA      ; load a with memory contents
           bitA 0x04, Y       ; bit A with memory at index Y + value -00000100-
           bne  LC70D          ; branch if not equal (not zero)
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           bitA 0x00, Y       ; bit A with memory at index Y + value -00000000-
           beq  LC74B          ; branch if equal (zero)
           ldd  Temp5          ; load d (a&b) with memory contents
           subd Temp7          ; d = d - memory contents
           std  0x00, X        ; store d into index plus offset
           ldab CPU_TimerControlReg1    ; load b with memory contents
           oraB 0x00, Y       ; or B with memory at index Y + value -00000000-
           stab CPU_TimerControlReg1    ; store b into memory
           ldd  0x00, X    
           subd #MapAverageValue_HB    ;  -00000000 10000000-
           subd CPU_TimerCounterRegHigh
           bpl  LC74B          ; branch if plus (hi bit 0)
           ldaA 0x04, Y       ; load A indexed to Y -00000100-
           staa CPU_HardwareTimerForceCompare
           ldd  CPU_TimerCounterRegHigh
           addd Temp7          ; d = d + memory contents
           stD *Temp5          ; store D to RAM
   LC70D:  ldaA 0x04, Y       ; load A indexed to Y -00000100-
           coma            
           anda CPU_TimerInterruptMask1
           staa CPU_TimerInterruptMask1
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           bitA 0x00, Y       ; bit A with memory at index Y + value -00000000-
           beq  LC72E          ; branch if equal (zero)
           ldd  0x00, X    
           addd Temp7          ; d = d + memory contents
           std  0x00, X        ; store d into index plus offset
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           andA 0x02, Y       ; and A with memory at index Y + value -00000010-
           staa CPU_TimerControlReg1
   LC72E:  ldd  Temp5          ; load d (a&b) with memory contents
           subd 0x00, X    
           bmi  LC73E          ; branch if minus(hi bit 1)
           cmpD #ErrorBitRegister1    ; compare D -00000000 00100000-
           bcs  LC73E          ; branch if lower
           ldd  Temp5          ; load d (a&b) with memory contents
           std  0x00, X        ; store d into index plus offset
   LC73E:  ldd  0x00, X    
           subd CPU_TimerCounterRegHigh
           bpl  LC74B          ; branch if plus (hi bit 0)
   LC745:  ldaA 0x04, Y       ; load A indexed to Y -00000100-
           staa CPU_HardwareTimerForceCompare
   LC74B:  rti                 ; return from interrupt

   LC74C:  jmp  LC82F      

CrankInterrupt_HandleCamSensorRisingEdgeB:
           ldd  TimerOverflowsBetweenCamPulses    ; load d (a&b) with memory contents
           cmpD #Timer_DacalCountdown    ; compare D -00000000 00001110-
           bcs  LC74C          ; branch if lower
           ldd  CPU_TimerInputCapture1_CamSensor
           subd L00F5          ; d = d - memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           xgDY                ; exchange D and Y
           ldaa #0x39          ; load a with value -00111001-
           suba AdvanceTemporary
           bcc  LC767          ; branch if greater or equal
           clra                ; a = 0
   LC767:  ldab #0xb6          ; load b with value -10110110-
           mul                 ; multiply (d=a*b)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           addd CPU_TimerInputCapture1_CamSensor
           subd #DCCOR4_AdaptiveWastegateCellTo5504rpm    ;  -00000000 00001010-
           stD *Temp5          ; store D to RAM
           ldab BitFlags6E     ; load b with memory contents
           andb #b6e_InjectorA          ;  -00000001-
           tba                 ; a = b
           ldY #NotSure1       ; load Y index -11000010 10011000-
           aby                 ; add b to y
           lslb            
           ldx  #CPU_Timer_OC4_DwellA    ; load index with value
           abx                 ; add b to index
           ldab Timer_Dwell_14    ; load b with memory contents
           tsta                ; test a
           beq  LC792          ; branch if equal (zero)
           ldab Timer_Dwell_23    ; load b with memory contents
   LC792:  clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd #0x07d0        ;  -00000111 11010000-
           stD *Temp7          ; store D to RAM
           brset *BitFlags6D, #b6d_DisableNormalDwell, LC74C    ; branch if bit(s) set
           ldaa DistributorFallingEdgePulsewidth_HB    ; load a with memory contents
           cmpa #0x50          ; compare a with value -01010000-
           bcs  LC7B5          ; branch if lower
           ldd  Temp5          ; load d (a&b) with memory contents
           std  0x00, X        ; store d into index plus offset
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           andA 0x02, Y       ; and A with memory at index Y + value -00000010-
           staa CPU_TimerControlReg1
           ldd  Temp5          ; load d (a&b) with memory contents
           bra  LC824          ; branch

   LC7B5:  ldaa CPU_PortA      ; load a with memory contents
           bitA 0x04, Y       ; bit A with memory at index Y + value -00000100-
           bne  LC7F1          ; branch if not equal (not zero)
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           bitA 0x00, Y       ; bit A with memory at index Y + value -00000000-
           beq  LC82F          ; branch if equal (zero)
           ldd  Temp5          ; load d (a&b) with memory contents
           subd Temp7          ; d = d - memory contents
           std  0x00, X        ; store d into index plus offset
           ldab CPU_TimerControlReg1    ; load b with memory contents
           oraB 0x00, Y       ; or B with memory at index Y + value -00000000-
           stab CPU_TimerControlReg1    ; store b into memory
           ldaB 0x04, Y       ; load B with value indexed to Y -00000100-
           stab CPU_TimerInterruptFlag1    ; store b into memory
           ldd  0x00, X
           subd #MapAverageValue_HB    ;  -00000000 10000000-
           subd CPU_TimerCounterRegHigh
           bpl  LC82F          ; branch if plus (hi bit 0)
           ldaA 0x04, Y       ; load A indexed to Y -00000100-
           staa CPU_HardwareTimerForceCompare
           ldd  CPU_TimerCounterRegHigh
           addd Temp7          ; d = d + memory contents
           stD *Temp5          ; store D to RAM
   LC7F1:  ldaA 0x04, Y       ; load A indexed to Y -00000100-
           coma            
           anda CPU_TimerInterruptMask1
           staa CPU_TimerInterruptMask1
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           bitA 0x00, Y       ; bit A with memory at index Y + value -00000000-
           beq  LC812          ; branch if equal (zero)
           ldd  0x00, X    
           addd Temp7          ; d = d + memory contents
           std  0x00, X        ; store d into index plus offset
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           andA 0x02, Y       ; and A with memory at index Y + value -00000010-
           staa CPU_TimerControlReg1
   LC812:  ldd  Temp5          ; load d (a&b) with memory contents
           subd 0x00, X    
           bmi  LC822          ; branch if minus(hi bit 1)
           cmpD #ErrorBitRegister1    ; compare D -00000000 00100000-
           bcs  LC822          ; branch if lower
           ldd  Temp5          ; load d (a&b) with memory contents
           std  0x00, X        ; store d into index plus offset
   LC822:  ldd  0x00, X    
   LC824:  subd CPU_TimerCounterRegHigh
           bpl  LC82F          ; branch if plus (hi bit 0)
           ldaA 0x04, Y       ; load A indexed to Y -00000100-
           staa CPU_HardwareTimerForceCompare
   LC82F:  rti                 ; return from interrupt


NotSure5:
           .word	0x0004
           .word	0x0602

;           .org   0xc846
CrankInterrupt_CalculateFuel:
           ldaa #0x10          ; load a with value -00010000-
           staa CPU_A2DControlReg
           brclr *BitFlags6D, #b6d_DisableNormalDwell, LC86D    ; branch if bit(s) clear
           ldab BitFlags6E     ; load b with memory contents
           andb #b6e_InjectorA          ;  -00000001-
           ldx  #CPU_Timer_OC4_DwellA    ; load index with value
           ldY #NotSure1       ; load Y index -11000010 10011000-
           aby                 ; add b to y
           lslb
           abx                 ; add b to index
           ldaa CPU_TimerControlReg1    ; load a with memory contents
           andA 0x02, Y       ; and A with memory at index Y + value -00000010-
           staa CPU_TimerControlReg1
           ldaA 0x04, Y       ; load A indexed to Y -00000100-
           staa CPU_HardwareTimerForceCompare
   LC86D:  ldaa #0x20          ; load a with value -00100000-
           ldx  TimerOverflowsBetweenCamPulses
           cpx  #CurrentAisPosition    ;  -00000000 00001111-
           bhi  LC87C          ; branch if higher
           coma
           anda CPU_PortA_Control
           bra  LC884          ; branch

   LC87C:  cpx  #AutoCalCell3    ;  -00000000 00010100-
           bls  LC887          ; branch if lower or same
           oraa CPU_PortA_Control
   LC884:  staa CPU_PortA_Control
   LC887:  ldd  #0x0101         ; load d (a&b) with value -00000001 00000001-
           orab PIA_Ctrl_2
           stab PIA_Ctrl_2    ; store b into memory
           staa PIA_Ctrl_4      
           staa CPU_TimerInterruptFlag1
           clr  CPU_PulseAccCounterRegister    ; zero byte at memory location
           clr  PIA_Ctrl_6          ; zero byte at memory location
           oraa PIA_Ctrl_3      
           staa PIA_Ctrl_3      
           ldab TimerOverflowsBetweenCamPulses    ; load b with memory contents
           bne  LC8B2          ; branch if not equal (not zero)
           ldab DistributorFallingEdgePulsewidth_HB    ; load b with memory contents
           cmpb RNFPRD_FuelStartRunTransferPointRpm    ; compare b with memory contents (data is 60)
           bcs  LC8B7          ; branch if lower
           cmpb STFPRD_FuelRunStartTransferPointRpm    ; compare b with memory contents (data is 82)
           bcs  LC8D6          ; branch if lower
   LC8B2:  bset *BitFlags6D, #b6d_FuelEngineNotRunning | b6d_Starting    ; set bits
           bra  LC8D6          ; branch

   LC8B7:  brclr *BitFlags6D, #b6d_FuelEngineNotRunning, LC8D6    ; branch if bit(s) clear
           bclr *BitFlags6D, #b6d_FuelEngineNotRunning | b6d_JustStarted    ; clear bits
           ldd  #0x0000         ; load d (a&b) with value -00000000 00000000-
           stD *KeyOnOrEngineRunningTime    ; store D to RAM
           stD *Pulsewidth_PartThrottleEnrichment_HB    ; store D to RAM
           staa ATMOffset      ; store a into memory
           ldaa AISDLY_DelayFromStartRunThatAisFeedbackDisabled    ; load a with memory contents (data is 5d)
           staa Timer_CountdownFromStartRunForAisFeedback    ; store a into memory
           ldaa AdaptiveRetardIndex    ; load a with memory contents
           suba ARSUBC_AdaptiveRetardFactorSubtract    ;  (data is 40)
           bcc  LC8D4          ; branch if greater or equal
           clra                ; a = 0
   LC8D4:  staa AdaptiveRetardIndex    ; store a into memory
   LC8D6:  ldaa Counter_EPP_MaxFF    ; load a with memory contents
           inca                ; increment a
           beq  LC8DD          ; branch if equal (zero)
           staa Counter_EPP_MaxFF    ; store a into memory
   LC8DD:  ldab Counter_FallingEdgeEPP_MaxFF    ; load b with memory contents
           asld                ; shift left (d=d*2)
           addb #0x02          ;  -00000010-
           bcs  LC8E7          ; branch if lower
           lsrd                ; shift right (d=d/2)
           stab Counter_FallingEdgeEPP_MaxFF    ; store b into memory
   LC8E7:  inc  AdaptiveCellUpdateTimer_IncrementedEveryCamRisingEdge
           inc  Timer_O2ToggleDuration
           ldaa Counter_SomethingWithCamSensor    ; load a with memory contents
           inca                ; increment a
           beq  LC8F4          ; branch if equal (zero)
           staa Counter_SomethingWithCamSensor    ; store a into memory
   LC8F4:  bclr *PIA3_Buffer, #pi3_KnockCap | pi3_Tach    ; clear bits
           ldab PIA3_Buffer    ; load b with memory contents
           stab PIA3_Buffer_2    ; store b into memory
           ldaa TpsVolts       ; load a with memory contents
           cmpa TpsAverageValue_HB    ; compare a with memory contents
           bcs  LC908          ; branch if lower
           ldx  #TpsAverageValue_HB    ; load index with value
           jsr  ProcessMapOrTpsBlockData    ; call subroutine
   LC908:  ldaa CPU_A2DControlReg    ; load a with memory contents
           bpl  LC908          ; branch if plus (hi bit 0)
           ldaa CPU_A2DResults1    ; load a with memory contents
           brset *BitFlags68, #b68_SparkEngineNotRunning, MAYBE_DO_BAROREADING    ; branch if bit(s) set
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb #0x2e          ;  -00101110-
           bcc  GREATER_THAN_1472RPM    ; branch if greater or equal
           ldab TpsVolts       ; load b with memory contents
           subb MINTHR_LowestSessionTPS    ; b = b-memory contents
           bcs  LC925          ; branch if lower
           cmpb MPLTHR_ThrottleLevelAbove_MINTHR_ToMatureMapLimpin    ; compare b with memory contents (data is 42)
           bcc  GREATER_THAN_1472RPM    ; branch if greater or equal
   LC925:  cmpa MAPHIG_MapSensorUpperLimit    ; compare a with memory contents (data is ee)
           bcc  LC933          ; branch if greater or equal
           cmpa MAPLOW_MapSensorLowerLimit    ; compare a with memory contents (data is 01)
           bcs  LC933          ; branch if lower
GREATER_THAN_1472RPM:
           brclr *b5C_IPL1, #b5c_MapStuck | b5c_MapBadSignal, GET_AVERAGE_MAP_READING    ; branch if bit(s) clear
   LC933:  jsr  SimulateMapReadingFromTps    ; call subroutine
           bra  LC93B          ; branch

GET_AVERAGE_MAP_READING:
           adda MapVolts   
           rora            
   LC93B:  jsr  ConvertMAPVoltsToValue    ; call subroutine
           staa MapValue       ; store a into memory
           bra  CALC_SPARK_RETARD_BASED_ON_KNOCK_VOLT    ; branch

MAYBE_DO_BAROREADING:
           brclr *BitFlags6D, #b6d_BaroOkEngineStopped, CALC_SPARK_RETARD_BASED_ON_KNOCK_VOLT    ; branch if bit(s) clear
           bclr *BitFlags6D, #b6d_BaroOkEngineStopped    ; clear bits
           jsr  SaveBaroPressure    ; call subroutine
CALC_SPARK_RETARD_BASED_ON_KNOCK_VOLT:
           ldx  #Cylinder2Retard    ; load index with value
           ldab BitFlags6E     ; load b with memory contents
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
           ldaa RTRDRT_KnockRetardRateNoBoost    ; load a with memory contents (data is 09)
           bcc  SUM_ADDITIONAL_RETARD    ; branch if greater or equal
           bset *BitFlags70, #$%01000000    ; set bits
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
           ldab RETALL_StoreSmallestRetardToAllCylinders          ; load b with memory contents (data is 40)
           bitb #0x40          ;  -01000000-
           beq  THROTTLE_HAS_DECREASED    ; branch if equal (zero)
           staa Cylinder1Retard    ; store a into memory
           staa Cylinder2Retard    ; store a into memory
           staa Cylinder3Retard    ; store a into memory
           staa Cylinder4Retard    ; store a into memory
THROTTLE_HAS_DECREASED:
           brset *BitFlags66, #b66_FullThrottle, LC99B    ; branch if bit(s) set
           ldaa MapValue       ; load a with memory contents
           cmpa MapAverageValue_HB    ; compare a with memory contents
           bcs  MAP_HAS_DECREASED0    ; branch if lower
   LC99B:  ldx  #MapAverageValue_HB    ; load index with value
           jsr  ProcessMapOrTpsBlockData    ; call subroutine
MAP_HAS_DECREASED0:
           bclr *BitFlags_BF, #$%00001000    ; clear bits
           ldaa #0x82          ; load a with value -10000010-
           brset *BitFlags6D, #b6d_DisableNormalDwell, LC9AC    ; branch if bit(s) set
           ldaa #0xc2          ; load a with value -11000010-
   LC9AC:  cmpa BatteryVolts    ; compare a with memory contents
           bcc  LCA01          ; branch if greater or equal
           ldaa SwitchPortAccessReg1    ; load a with memory contents
           bita #0x20          ;  -00100000-
           beq  LCA01          ; branch if equal (zero)
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa #0x5d          ; compare a with value -01011101-
           bcc  LCA01          ; branch if greater or equal
           ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           bne  LCA01          ; branch if not equal (not zero)
           ldaa CPU_PortA      ; load a with memory contents
           bita #0x18          ;  -00011000-
           bne  LCA01          ; branch if not equal (not zero)
           bset *BitFlags_BF, #$%00001000    ; set bits
           ldaa PIA_Ctrl_4          ; load a with memory contents
           bita #0x02          ;  -00000010-
           bne  LC9FC          ; branch if not equal (not zero)
           ldab BitFlags6E     ; load b with memory contents
           andb #b6e_InjectorA          ;  -00000001-
           brset *BitFlags6D, #b6d_DisableNormalDwell, LC9F2    ; branch if bit(s) set
           ldx  #Timer_Dwell_14    ; load index with value
           abx                 ; add b to index
           ldaa 0x00, X        ; load a with memory at index + value
           adda #0x0c          ;  -00001100-
           bcc  LC9E6          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LC9E6:  cmpa #0xbb          ; compare a with value -10111011-
           bcc  LC9EE          ; branch if greater or equal
           staa 0x00, X    
           bra  LC9FC          ; branch

   LC9EE:  ldaa #0xbb          ; load a with value -10111011-
           staa 0x00, X    
   LC9F2:  ldx  #NotSure4      ; load index with value
           abx                 ; add b to index
           ldab 0x00, X        ; load b with memory at index + value
           orab BitFlags5E 
           stab BitFlags5E     ; store b into memory
   LC9FC:  ldab #0x02          ; load b with value -00000010-
           stab PIA_Ctrl_4          ; store b into memory
   LCA01:  brclr *CCDFlags5, #ccd_AlarmDisable, LCA08    ; branch if bit(s) clear
           jmp  ClearInjectorPW

   LCA08:  brset *BitFlags6D, #b6d_FuelEngineNotRunning, IncludeLatency    ; branch if bit(s) set
           ldaa CoolantTemp    ; load a with memory contents
           cmpa SRTMTP_SparkTempSwitchPointFor_SRTIME          ; compare a with memory contents (data is 58)
           bcs  LCA39          ; branch if lower
           brset *BitFlags66, #b66_OffIdle, LCA39    ; branch if bit(s) set
           brclr *BitFlags67, #b67_FallToIdle, LCA22    ; branch if bit(s) clear
           ldaa CONFIG2_ConfigurationFlags2    ; load a with memory contents (data is c7)
           bita #0x80          ;  -10000000-
           beq  LCA39          ; branch if equal (zero)
   LCA22:  brset *BitFlags70, #$%10000000, LCA3C    ; branch if bit(s) set
           ldd  KeyOnOrEngineRunningTime    ; load d (a&b) with memory contents
           cmpD #0x000c    ; compare D -00000000 00001100-
           bcs  LCA34          ; branch if lower
           ldaa SRTIME_SparkEPPsNeededToBeAboveSR_Hot          ; load a with memory contents (data is 04)
           staa ColdStartFuelReduxCounter      
   LCA34:  bset *BitFlags70, #$%10000000    ; set bits
           bra  LCA3C          ; branch

   LCA39:  bclr *BitFlags70, #$%10000000    ; clear bits
   LCA3C:  brset *BitFlags6A, #b6a_FuelOff, StartCalculatingFuel    ; branch if bit(s) set
           jmp  CalculateInjectorPulsewidthForEngineRunning

StartCalculatingFuel:
           brclr *BitFlags6A, #b6a_OverRev, ClearInjectorPW    ; branch if bit(s) clear
           ldaa ColdStartFuelReduxCounter          ; load a with memory contents
           bne  CalculateInjectorPulsewidthForEngineRunning    ; branch if not equal (not zero)
           ldaa Counter_FuelEngRunning    ; load a with memory contents
           bne  LCA6C          ; branch if not equal (not zero)
           ldaa EngineRpm_HB    ; load a with memory contents
           suba TargetIdleSpeedHB
           bcc  LCA57          ; branch if greater or equal
           clra                ; a = 0
   LCA57:  ldx  #CFERRP_CounterFuelEngRunning_FromRPM   ; this table format --> 1st point is number of points; then pairs follow - 1st byte is RPM, 2nd byte is fuel counter
           ldab 0x00, X        ; load b with memory at index + value
           inx                 ; increment index (x=x+1)
   LCA5D:  cmpa 0x00, X        ; compare a with memory at index + value
           bcc  LCA68          ; branch if greater or equal
           inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
           decb            
           bne  LCA5D          ; branch if not equal (not zero)
           dex                 ; decrement index (x=x-1)
           dex                 ; decrement index (x=x-1)
   LCA68:  ldaa 0x01, X        ; load a with memory at index + value
           beq  CalculateInjectorPulsewidthForEngineRunning    ; branch if equal (zero)
   LCA6C:  bita #0x0f          ;  -00001111-
           beq  LCA75          ; branch if equal (zero)
           deca                ; decrement a
           staa Counter_FuelEngRunning    ; store a into memory
           bra  ClearInjectorPW          ; branch

   LCA75:  suba #0x10          ;  -00010000-
           staa Counter_FuelEngRunning    ; store a into memory
           bra  CalculateInjectorPulsewidthForEngineRunning    ; branch

ClearInjectorPW:
           clra                ; a = 0
           clrb                ; b = 0
           stD *BaseInjectorPulsewidth_HB    ; store D to RAM
           stD *InjectorPulsewidth_HB    ; store D to RAM
           bra  StoreCylPulsewidths    ; branch

IncludeLatency:
           bclr *BitFlags70, #$%10000000    ; clear bits
           ldab InjectorLatency    ; load b with memory contents
           nop
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
           ldY DFFULL_DensityFactorFullThrottle     ; load Y with value from memory (data is 22)
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
           brset *BitFlags66, #b66_FullThrottle, IncludeSparkScatterFuel    ; branch if bit(s) set
           stD *Temp7          ; store D to RAM
           ldaa MapValue       ; load a with memory contents
           ldY DFPART_DensityFactorPartThrottle    ; load Y with value from memory (data is 23)
           jsr  ScaleYbyA      ; call subroutine
           stY Temp5           ; store Y index
           ldaa MapValue       ; load a with memory contents
           cmpa TBLBK3_3DTableBreakPointHiLo ; #0x40          ; compare a with value -01000000-
           bcc  LookupPartThrottleHiMAPFuel          ; branch if greater or equal
           ldx  #MAPLO_LoMAP3DInputModifierFromMAP    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldx  #PRTTBL_FuelPartThrottleFromLoMap    ; load index with value
           bra  LookupPartThrottle3DTable          ; branch

LookupPartThrottleHiMAPFuel:
           ldx  #MAPHI_HiMAP3DInputModifierFromMAP    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldx  #PRTTBH_FuelPartThrottleFromHiMAP    ; load index with value

LookupPartThrottle3DTable:
           ldab EngineRPM_3D    ; load b with memory contents
           jsr  Lookup3DTableRoutine    ; call subroutine
           staa FuelLookupValue3D
           ldY Temp5           ; load Y index
           jsr  ScaleYbyA      ; call subroutine
           stY Temp5           ; store Y index
           ldx  #Temp5         ; load index with value
           ldab Timer_OpenLoopFraction    ; load b with memory contents
           ldaa #0x01          ; load a with value -00000001-
           jsr  ScaleXbyB_addingA_intoD    ; call subroutine
           cmpD Temp7          ; compare D
           bls  IncludeSparkScatterFuel          ; branch if lower or same
           ldd  Temp7          ; load d (a&b) with memory contents

IncludeSparkScatterFuel:
           addd SparkScatterFuelStabilizationValue_HB    ; d = d + memory contents
           bpl  CheckBoostForKnockEnrichment          ; branch if plus (hi bit 0)
           ldd  Pulsewidth_PartThrottleEnrichment_HB    ; load d (a&b) with memory contents
           addd Pulsewidth_AISPulseEnrichment_HB    ; d = d + memory contents
           bra  HandleTransitionFromStartToRun    ; branch

CheckBoostForKnockEnrichment:
           stD *Temp7          ; store D to RAM
           ldaa EMBSLM_KnockEnrichmentBoostSetpoint    ; load a with memory contents (data is 7a)
           bmi  LCB33          ; branch if minus(hi bit 1)
           adda BaroPressure
           bcc  LCB31          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LCB31:  bra  LCB38          ; branch

   LCB33:  adda BaroPressure
           bcc  LCB38          ; branch if greater or equal
           clra                ; a = 0
   LCB38:  cmpa MapValue       ; compare a with memory contents
           bhi  ClearKnockEnrichmentFactor          ; branch if higher
           ldx  #Cylinder2Retard    ; load index with value
           ldaa 0x00, X        ; load a with memory at index + value
FindHighestKnockValueForEnrichment:
           cpx  #Cylinder4Retard    ;  -00000000 11000110-
           beq  LookupKnockEnrichmentFactor          ; branch if equal (zero)
           inx                 ; increment index (x=x+1)
           cmpa 0x00, X        ; compare a with memory at index + value
           bcc  FindHighestKnockValueForEnrichment          ; branch if greater or equal
           ldaa 0x00, X        ; load a with memory at index + value
           bra  FindHighestKnockValueForEnrichment          ; branch

LookupKnockEnrichmentFactor:
           tsta                ; test a
           beq  ClearKnockEnrichmentFactor          ; branch if equal (zero)
           ldx  #KNENRC_KnockRetardEnrichment    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           stab KnockEnrichmentFactor          ; store b into memory
           clr  Counter_O2SensorFeedbackCount_Signed    ; zero byte at memory location
           ldaa #0x01          ; load a with value -00000001-
           ldx  #Temp7         ; load index with value
           jsr  ScaleXbyB_addingA_intoD    ; call subroutine
           stD *Temp7          ; store D to RAM
           bra  INCLUDE_PW_MODIFIERS    ; branch

ClearKnockEnrichmentFactor:
           clra                ; a = 0
           staa KnockEnrichmentFactor
INCLUDE_PW_MODIFIERS:
           ldab 0xff           ; load b with memory contents
           tba                 ; a = b
           ldY SumOfFuelModifiers_HB    ; load Y index
           jsr  ScaleYbyA      ; call subroutine
           stY Temp5           ; store Y index
           ldaa Temp7          ; load a with memory contents
           ldab SumOfFuelModifiers_LB    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           addd Temp5          ; d = d + memory contents
           bcs  LOAD_MAX_INJ_PULSEWIDTH    ; branch if lower
           stD *Temp5          ; store D to RAM
           ldaa Temp7          ; load a with memory contents
           ldab SumOfFuelModifiers_HB    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           tsta                ; test a
           bne  LOAD_MAX_INJ_PULSEWIDTH    ; branch if not equal (not zero)
           addb Temp5          ; b=b+memory contents
           bcs  LOAD_MAX_INJ_PULSEWIDTH    ; branch if lower
           tba                 ; a = b
           ldab Temp6          ; load b with memory contents
           addd Pulsewidth_PartThrottleEnrichment_HB    ; d = d + memory contents
           bcs  LOAD_MAX_INJ_PULSEWIDTH    ; branch if lower
           addd Pulsewidth_AISPulseEnrichment_HB    ; d = d + memory contents
           bcc  HandleTransitionFromStartToRun    ; branch if greater or equal
LOAD_MAX_INJ_PULSEWIDTH:
           ldd  #0xffff         ; load d (a&b) with value -11111111 11111111-
HandleTransitionFromStartToRun:
           brclr *BitFlags6D, #b6d_Starting, IncludeInjectorLatency    ; branch if bit(s) clear
           stD *Temp5          ; store D to RAM
           ldd  InjectorPulsewidth_HB    ; load d (a&b) with memory contents
           suba Factor_StartFuelDecayIntoRunFuel
           bls  TransitionFromStartToRunComplete    ; branch if lower or same
           cmpa Temp5          ; compare a with memory contents
           bhi  IncludeInjectorLatency    ; branch if higher
TransitionFromStartToRunComplete:
           ldd  Temp5          ; load d (a&b) with memory contents
           bclr *BitFlags6D, #b6d_Starting    ; clear bits
IncludeInjectorLatency:
           jsr  NULL_ROUTINE    ; call subroutine
           stD *InjectorPulsewidth_HB    ; store D to RAM
           ldab InjectorLatency    ; load b with memory contents
           nop
           clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd InjectorPulsewidth_HB    ; d = d + memory contents
           bcc  LCBC5          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LCBC5:  stD *BaseInjectorPulsewidth_HB    ; store D to RAM
           clra                ; a = 0
           staa Temp5          ; store a into memory
           staa Temp6          ; store a into memory
           ldab BitFlags6E     ; load b with memory contents
           andb #b6e_InjectorAandB          ;  -00000011-
           ldx  #NotSure5      ; load index with value
           abx                 ; add b to index
           ldab 0x00, X        ; load b with memory at index + value
           ldx  #InjectorPulsewidth_HB_Cyl1    ; load index with value
           abx                 ; add b to index
           brclr *BitFlags70, #$%10000000, LCC0D    ; branch if bit(s) clear
           ldaa ColdStartFuelReduxCounter          ; load a with memory contents
           beq  LCC1F          ; branch if equal (zero)
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
           nop
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           tab                 ; b = a
           clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd Temp5          ; d = d + memory contents
           pulx                ; pull index from stack
           std  0x00, X        ; store d into index plus offset
           bra  LCC1F          ; branch

   LCC0D:  ldd  BaseInjectorPulsewidth_HB    ; load d (a&b) with memory contents
           std  0x00, X        ; store d into index plus offset
           cmpD MNPWDS_MinimumInjPWForDistSync    ; compare D -00000000 01111101-
           bls  LCC1F          ; branch if lower or same
           bset *BitFlags6E, #b6e_DistSync    ; set bits
           ldaa #0x04          ; load a with value -00000100-
           staa PIA_Ctrl_4      
   LCC1F:  ldd  InjectorPulsewidth_HB    ; load d (a&b) with memory contents
           addd Temp5          ; d = d + memory contents
           subd IPWRDX_InjectorPulsewidthReductionColdStart     ;  (data is 0000)
           bcc  LCC2A          ; branch if greater or equal
           clra                ; a = 0
           clrb                ; b = 0
   LCC2A:  lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           ; try to correct the fuel monitor output
           adca #0x00
           ldab FLMNC2_FuelMonitorCorrection2 ;temp name - base value is 0x80 for stock injectors, scaled with injectors
           mul
           lsld
           ; end correction code
           addd CCDFuelOutput_HB    ; d = d + memory contents
           bcc  LCC33          ; branch if greater or equal
           ldd  #0xffff         ; load d (a&b) with value -11111111 11111111-
   LCC33:  stD *CCDFuelOutput_HB    ; store D to RAM
           ldd  Pulsewidth_AISPulseEnrichment_HB    ; load d (a&b) with memory contents
           subd MINPAI_MinPWForAISPulseEnrich          ;  (data is 0009)
           bcc  LCC3E          ; branch if greater or equal
           clra                ; a = 0
           clrb                ; b = 0
   LCC3E:  stD *Pulsewidth_AISPulseEnrichment_HB    ; store D to RAM
           rti                 ; return from interrupt

Interrupt_RealTime:
           ldab #0x01          ; load b with value -00000001-
           bra  LCC5D          ; branch

Interrupt_XIRQ:
           ldab #0x02          ; load b with value -00000010-
           bra  LCC5D          ; branch

Interrupt_COPFail:
           ldab #0x04          ; load b with value -00000100-
           bra  LCC5D          ; branch

Interrupt_ClockMonFail:
           ldab #0x08          ; load b with value -00001000-
           bra  LCC5D          ; branch

Interrupt_BadOp:
           ldab #0x10          ; load b with value -00010000-
           bra  LCC5D          ; branch

Interrupt_Software:
           ldab #0x20          ; load b with value -00100000-
           bra  LCC5D          ; branch

Interrupt_PulseAccumulatorInputEdge:
           ldab #0x40          ; load b with value -01000000-
           bra  LCC5D          ; branch

   LCC5D:  stab Temp0          ; store b into memory
           orab L0000      
           stab L0000          ; store b into memory
           tsx                 ; transfer stack to index (x=sp+1)
           ldd  0x07, X    
           stD *L0001          ; store D to RAM
           stD *Temp1          ; store D to RAM
           sei                 ; disable interrupts
           lds  #0x60ff        ;  -01100000 11111111-
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
           beq  LCCC1          ; branch if equal (zero)
           decb
           stab Temp4          ; store b into memory
           bra  LCCC1          ; branch

Interrupt_RealTime_X:
           sei                 ; disable interrupts
           lds  #0x60ff        ;  -01100000 11111111-
           clra                ; a = 0
           clrb                ; b = 0
           staa Temp0          ; store a into memory
           stD *Temp1          ; store D to RAM
           jsr  CountRamValuesFrom05to3a    ; call subroutine
           ldx  #0xaaa5        ; load index with value
           cmpD L0003          ; compare D
           beq  LCCBF          ; branch if equal (zero)
           ldx  #0x0000        ; load index with value
   LCCBF:  stx  Temp3          ; store index into memory
   LCCC1:  ldd  #0x01f9        ; load d (a&b) with value -00000001 11111001-
           staa PIA_Ctrl_2
           stab PIA_Ctrl_5          ; store b into memory
           clra                ; a = 0
           clrb                ; b = 0
           std  InjectorPulsewidth_HB_Cyl1
           std  InjectorPulsewidth_HB_Cyl2
           std  InjectorPulsewidth_HB_Cyl3
           std  InjectorPulsewidth_HB_Cyl4
           ldaa #0x70          ; load a with value -01110000-
           staa CPU_PortA_Control
           ldaa #0x74          ; load a with value -01110100-
           staa PIA3_Buffer_2
           ldaa #0x20          ; load a with value -00100000-
           staa CPU_PortD  
           ldd  #0x3a54        ; load d (a&b) with value -00111010 01010100-
           staa CPU_PortD_DataDirection
           ldaa CPU_SerialPeripheralStatus    ; load a with memory contents
           stab CPU_SerialPeripheralControl    ; store b into memory
           bset *BitFlags6E, #$%00000100    ; set bits
           ldaa #0x70          ; load a with value -01110000-
           ldab #0xff          ; load b with value -11111111-
           jsr  SetPIAOutputBits    ; call subroutine
           ldaa #0x50          ; load a with value -01010000-
           ldab #0xff          ; load b with value -11111111-
           jsr  SetPIAOutputBits    ; call subroutine
           jsr  OCToggleAndResetCopTimer    ; call subroutine
           ldaa #0xc8          ; load a with value -11001000-
   LCD09:  deca                ; decrement a
           bne  LCD09          ; branch if not equal (not zero)
           jsr  OCToggleAndResetCopTimer    ; call subroutine
           bclr *BitFlags_AIS, #$%00111100    ; clear bits
           ldd  Temp3          ; load d (a&b) with memory contents
           stD *L0003          ; store D to RAM
           ldx  #CurrentWastegatePosition    ; load index with value
           ldd  L0003          ; load d (a&b) with memory contents
           cmpD #0xaaa5        ; compare D -10101010 10100101-
           beq  LCD4F          ; branch if equal (zero)
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
           staa DCCOR1_AdaptiveWastegateCellBelow3psi    ; store a into memory
           staa DCCOR2_AdaptiveWastegateCellTo4000rpm    ; store a into memory
           staa DCCOR3_AdaptiveWastegateCellTo4992rpm    ; store a into memory
           staa DCCOR4_AdaptiveWastegateCellTo5504rpm    ; store a into memory
           staa DCCOR5_AdaptiveWastegateCellAbove5504rpm    ; store a into memory
           staa DCCOR6_AdaptiveVNTCell1    ; store a into memory
           staa DCCOR7_AdaptiveVNTCell2    ; store a into memory
           staa DCCOR0_AdaptiveVNTCell0    ; store a into memory
           jsr  ERASE_ERROR_CODES    ; call subroutine
           ldx  #AutoCalCell0    ; load index with value
   LCD4F:  clrb                ; b = 0
           stab CPU_A2DControlReg    ; store b into memory
ZeroRamFrom0EtoFE:
           stab 0x00, X    
           inx                 ; increment index (x=x+1)
           cpx  #0x00FF         ;  -00000000 11111111-
           bls  ZeroRamFrom0EtoFE    ; branch if lower or same
           tsx                 ; transfer stack to index (x=sp+1)
   LCD5C:  dex                 ; decrement index (x=x-1)
           stab 0x00, X
           cpx  #ErrorCodeCounter    ;  -01100000 10000000-
           bhi  LCD5C          ; branch if higher
           ldaa CPU_A2DResults1    ; load a with memory contents
           ldab #0x14          ; load b with value -00010100-
           stab CPU_A2DControlReg    ; store b into memory
           staa MapVolts       ; store a into memory
           jsr  SaveBaroPressure    ; call subroutine
           staa MapValue       ; store a into memory
           staa MapAverageValue_HB    ; store a into memory
           ldaa #0xf0          ; load a with value -11110000-
           ldab #0xff          ; load b with value -11111111-
           bset *BitFlags6E, #$%00000100    ; set bits
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
           bcc  LCDB6          ; branch if greater or equal
           bclr *PIA3_Buffer, #pi3_CoolantTemp    ; clear bits
   LCDB6:  cmpb #0x40          ;  -01000000-
           bcc  LCDBD          ; branch if greater or equal
           bclr *PIA3_Buffer, #pi3_ChargeTemp    ; clear bits
   LCDBD:  ldaa PIA3_Buffer    ; load a with memory contents
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
           bset *BitFlags_AIS, #$%11000000    ; set bits
           ldd  #0xa6ff        ; load d (a&b) with value -10100110 11111111-
           staa CPU_TimerInterruptMask1
           stab CPU_TimerInterruptFlag1    ; store b into memory
           stab Counter_TimerPastHalfwayBetweenCamPulses    ; store b into memory
           stab TimerOverflowsBetweenCamPulses    ; store b into memory
           stab Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; store b into memory
           stab TimerOverflowsBetweenSpeedoPulses    ; store b into memory
           stab Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached    ; store b into memory
           bset *CruiseStatus_1, #$%10100000    ; set bits
           ldaa #0x80          ; load a with value -10000000-
           staa Counter_Cruise_1    ; store a into memory
           bset *BitFlags6C, #$%00000010    ; set bits
           ldaa LB616          ; load a with memory contents (data is ff)
           cmpa #0x4a          ; compare a with value -01001010-
           bne  LCE06          ; branch if not equal (not zero)
           coma
           cmpa LB615
           beq  LCE09
   LCE06:  bclr *BitFlags6C, #$%00000010    ; clear bits
   LCE09:  bclr *BitFlags6C, #$%00001100    ; clear bits
           ldaa L0004          ; load a with memory contents
           cmpa #0xa4          ; compare a with value -10100100-
           beq  LCE1B          ; branch if equal (zero)
           ldaa BitFlags_AIS    ; load a with memory contents
           tab                 ; b = a
           andb #0x03          ;  -00000011-
           cmpb #0x02          ;  -00000010-
           bne  SetupSystemAndGoToMainLoop    ; branch if not equal (not zero)
   LCE1B:  ldd  #0x0aff        ; load d (a&b) with value -00001010 11111111-
           staa DRBPointer1    ; store a into memory
           stab DRBPointer2    ; store b into memory
           ldd  #0xf1ff        ; load d (a&b) with value -11110001 11111111-
           staa LastCamFallingEdgeTime    ; store a into memory
           bra  LCE2E          ; branch

SetupSystemAndGoToMainLoop:
           inca                ; increment a
           staa BitFlags_AIS    ; store a into memory
           ldab #0xef          ; load b with value -11101111-
   LCE2E:  ldaa #0x50          ; load a with value -01010000-
           jsr  SetPIAOutputBits    ; call subroutine
           ldaa #0x03          ; load a with value -00000011-
           staa Timer_DelayBeforeUpdating_MINTHR    ; store a into memory
           ldd  #0x0c1a        ; load d (a&b) with value -00001100 00011010-
           staa BitFlags66     ; store a into memory
           stab CPU_TimerControlReg2    ; store b into memory
           bset *BitFlags6D, #b6d_FuelEngineNotRunning | b6d_Starting | b6d_DisableNormalDwell    ; set bits
           ldaa #0x14          ; load a with value -00010100-
           staa BitFlags67     ; store a into memory
           jsr  OCToggleAndResetCopTimer    ; call subroutine
           ldx  #0x074b        ; load index with value
   LCE4C:  ldaa SwitchPortAccessReg1    ; load a with memory contents
           bita #0x20          ;  -00100000-
           bne  LCE56          ; branch if not equal (not zero)
           dex                 ; decrement index (x=x-1)
           bne  LCE4C          ; branch if not equal (not zero)
   LCE56:  jsr  OCToggleAndResetCopTimer    ; call subroutine
           ldab #0x14          ; load b with value -00010100-
           stab CPU_A2DControlReg    ; store b into memory
   LCE5E:  ldaa CPU_A2DControlReg    ; load a with memory contents
           bpl  LCE5E          ; branch if plus (hi bit 0)
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
           ldaa LastChargeTempVolts    ; load a with memory contents
           ldx  #TMPTL2_TempForHotScaleA2D    ; load index with value
           brclr *PIA3_Buffer, #pi3_ChargeTemp, LCE8D    ; branch if bit(s) clear
           ldx  #TMPTL1_TempForColdScaleFromA2D    ; load index with value
   LCE8D:  jsr  Lookup4ByteTable    ; call subroutine
           staa ChargeTempVolts    ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           cmpa #0xa6          ; compare a with value -10100110-
           bcc  LCEA2          ; branch if greater or equal
           ldab AmbientAirTempVolts    ; load b with memory contents
           cmpb #0x99          ;  -10011001-
           bcs  LCEA2          ; branch if lower
           ldab #0x40          ; load b with value -01000000-
           stab Timer_RadSteamingCountdown    ; store b into memory
   LCEA2:  cmpa TTEMPL_TstatDiagnosticsMinTempToArmDiagnosticsAtStartup    ; compare a with memory contents (data is 63)
           bcs  LCEAF          ; branch if lower
           cmpa TTEMPH_TstatDiagnosticsMaxTempToArmDiagnosticsAtStartup    ; compare a with memory contents (data is e4)
           bcc  LCEAF          ; branch if greater or equal
           inc  Timer_ThermostatDiagnostics
   LCEAF:  ldx  #PRSHOT_KeyOnPrimePW    ; load index with value
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
           beq  LCEE3          ; branch if equal (zero)
           clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd InjectorPulsewidth_HB    ; d = d + memory contents
           bcc  LCED7          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LCED7:  std  InjectorPulsewidth_HB_Cyl1
           std  InjectorPulsewidth_HB_Cyl2
           std  InjectorPulsewidth_HB_Cyl3
           std  InjectorPulsewidth_HB_Cyl4
   LCEE3:  bset *BitFlags6E, #b6e_BoostOver5psi | b6e_WastegateDC    ; set bits
           bset *BitFlags6f, #b6f_Alternator2    ; set bits
           ldd  CPU_A2DResults3
           stD *O2SensorVolts    ; store D to RAM
           stab TpsVolts       ; store b into memory
           stab TpsAverageValue_HB    ; store b into memory
           ldaa MINTHR_LowestSessionTPS    ; load a with memory contents
           adda MININC_Amount_MINTHR_IsIncreasedAtKeyOnOnly    ;  (data is 03)
           cmpa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; compare a with memory contents (data is 5c)
           bcs  LCF05          ; branch if lower
           addb #0x06          ;  -00000110-
           ldaa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load a with memory contents (data is 5c)
           cba             
           bcs  LCF05          ; branch if lower
           tba                 ; a = b
   LCF05:  staa MINTHR_LowestSessionTPS    ; store a into memory
           jsr  IncludeCylTrimWithAdaptiveCells    ; call subroutine
           jsr  OCToggleAndResetCopTimer    ; call subroutine
           bclr *BitFlags6E, #$%00000100    ; clear bits
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
   LCF26:  cli                 ; enable interrupts
           ldd  #0x55aa        ; load d (a&b) with value -01010101 10101010-
           staa CPU_ArmOCToggleAndResetCopTimerReg
           stab CPU_ArmOCToggleAndResetCopTimerReg    ; store b into memory
           ldaa PIA1_Buffer    ; load a with memory contents
           eora #pi1_AISMotor1          ; XOR a with value -00000010-
           staa PIA1_Buffer    ; store a into memory
           sei                 ; disable interrupts
           ldaa CPU_A2DControlReg    ; load a with memory contents
           bpl  LCF26          ; branch if plus (hi bit 0)
           ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x03          ;  -00000011-
           bne  LCF47          ; branch if not equal (not zero)
           ldaa CPU_A2DResults2    ; load a with memory contents
           staa BatteryVolts    ; store a into memory
   LCF47:  ldd  CPU_A2DResults3
           cli                 ; enable interrupts
           staa O2SensorVolts    ; store a into memory
           stab LastTpsVolts    ; store b into memory
           sei                 ; disable interrupts
           ldd  CPU_TimerCounterRegHigh
           stD *Temp0          ; store D to RAM
           ldaa #0x14          ; load a with value -00010100-
           staa CPU_A2DControlReg
           ldd  Temp0          ; load d (a&b) with memory contents
           jsr  DetermineNumberOfOverflowsBetweenCamSensorPulses_MM    ; call subroutine
           ldd  Temp0          ; load d (a&b) with memory contents
           jsr  DetermineNumberOfOverflowsBetweenSpeedoPulses_MM    ; call subroutine
   LCF64:  ldaa CPU_A2DControlReg    ; load a with memory contents
           bpl  LCF64          ; branch if plus (hi bit 0)
           ldd  CPU_A2DResults1
           stD *LastCoolantTempVolts    ; store D to RAM
           ldaa CPU_A2DResults4    ; load a with memory contents
           staa AmbientAirTempVolts    ; store a into memory
           ldaa #0x10          ; load a with value -00010000-
           staa CPU_A2DControlReg
           cli                 ; enable interrupts
           jsr  EmmissionMaintenanceRemider1_MM    ; call subroutine
           jsr  DRB_SomethingLikeEMR_MM    ; call subroutine
           jsr  EmmissionMaintenanceRemider2_MM    ; call subroutine
           jsr  CycleACClutch_MM    ; call subroutine
           jsr  CheckThrottleRoutine_MM    ; call subroutine
           jsr  CheckAndFilterCoolantAndChargeTempSensors_MM    ; call subroutine
           jsr  HandleBaroReadRequirement_MM    ; call subroutine
           jsr  CalculateInjectorPulsewidthForStarting_MM    ; call subroutine
           jsr  DetectParkNeutral_MM    ; call subroutine
           jsr  CALCULATE_RPM_SPEED_AND    ; call subroutine
           jsr  RescaleRPMFor3D_MM    ; call subroutine
           jsr  ControlAsdRelay_MM    ; call subroutine
           jsr  LD594          ; call subroutine
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
           jsr  CalculatePartThrottleTransientFuel_MM    ; call subroutine

           ; these calculations must have been for development only. The Delta values are only used here, never anywhere else...
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
;turbonator
	   jsr  UseCELForKnockIndication_MM     ; call subroutine
           jsr  ControlShiftLight_MM
           jsr  CalculateAntiLagRetard_Routine_MM
;turbonator
           jsr  CalcTargetBoost_MM    ; call subroutine
           jsr  GetControlFeedback_DetermineIfShutdownRequired_MM    ; call subroutine
           jsr  DetectAlternatorFault_MM    ; call subroutine
           jsr  VerifyOperationOfBatteryVoltage_MM    ; call subroutine
           jsr  UpdateCylTrimCounters_MM    ; call subroutine
           jsr  DetectAlternatorFault_MM_Also    ; call subroutine
           jsr  CheckForErrorsAndSetCodes_MM    ; call subroutine
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
           jsr  DecrementDwellTimers_MM    ; call subroutine
           jsr  ExhGasRecirc_MM    ; call subroutine
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
           bmi  LD049          ; branch if minus(hi bit 1)
           tab                 ; b = a
   LD049:  addb #0x15          ;  -00010101-
           stab MinimumTimerCountBeforeMainloopCanContinue    ; store b into memory
           cli                 ; enable interrupts
   LD04E:  cmpa CPU_TimerCounterRegHigh    ; compare a with memory contents
           bpl  LD04E          ; branch if plus (hi bit 0)
           jmp  MainProgramLoop

ControlPurgeSolenoid_MM:
           brclr *BitFlags6D, #b6d_FuelEngineNotRunning, LD06F    ; branch if bit(s) clear
           ldaa CoolantTemp    ; load a with memory contents
           cmpa PURTMP_CanisterPurgeCoolantTemp    ; compare a with memory contents (data is b6)
           bcc  LD066          ; branch if greater or equal
           bclr *BitFlags67, #b67_Purge    ; clear bits
           bra  LD06F          ; branch

   LD066:  bset *BitFlags67, #b67_Purge    ; set bits
           bra  LD06F          ; branch

CanisterPurgeOff:
           bclr *PIA1_Buffer, #pi1_PurgeSol    ; clear bits
           rts                 ; return from subroutine

   LD06F:  ldab BaroPressure    ; load b with memory contents
           brset *PIA1_Buffer, #pi1_PurgeSol, LD078    ; branch if bit(s) set
           subb PURHYS_CannisterPurgeBaroHysteresis    ; subtract memory contents from b (data is 02)
   LD078:  tst  PURMAP_CannisterPurgeWhenBelowThisBaro    ;  (data is 7f)
           bpl  LD089          ; branch if plus (hi bit 0)
           tba                 ; a = b
           ldab PURMAP_CannisterPurgeWhenBelowThisBaro    ; load b with memory contents (data is 7f)
           negb            
           sba                 ; subtract (a=a-b)
           tab                 ; b = a
           bcc  LD090          ; branch if greater or equal
           clrb                ; b = 0
           bra  LD090          ; branch

   LD089:  addb PURMAP_CannisterPurgeWhenBelowThisBaro    ;  (data is 7f)
           bcc  LD090          ; branch if greater or equal
           ldab #0xff          ; load b with value -11111111-
   LD090:  cmpb MapValue   
           bcs  CanisterPurgeOff    ; branch if lower
           brset *BitFlags67, #b67_Purge, CanisterPurgeOn    ; branch if bit(s) set
           brset *BitFlags67, #b67_OpenLoop, CanisterPurgeOff    ; branch if bit(s) set
           bset *BitFlags67, #b67_Purge    ; set bits
           bra  LD0A9          ; branch

CanisterPurgeOn:
           brset *BitFlags66, #b66_O2Valid, LD0A9    ; branch if bit(s) set
           ldab Timer_CLTIME_ClosedLoopTimer    ; load b with memory contents
           bne  CanisterPurgeOff    ; branch if not equal (not zero)
   LD0A9:  ldab #0x08          ; load b with value -00001000-
           ldx  #CLTRP2_Cyl2TrimValueForPurgeVolume    ; load index with value
           ldaa PointerIntoAdaptiveMemory    ; load a with memory contents
           cmpa CL2PTR_Cyl2AdaptiveMemoryPointer    ; compare a with memory contents (data is 0d)
           bne  LD0BB          ; branch if not equal (not zero)
           brset *BitFlags67, #b67_FallToIdle, LD11D    ; branch if bit(s) set
           bra  LD0CE          ; branch

   LD0BB:  inx                 ; increment index (x=x+1)
           lsrb                ; logical shift right b
           cmpa CL1PTR_Cyl1AdaptiveMemoryPointer    ; compare a with memory contents (data is 03)
           beq  LD0CE          ; branch if equal (zero)
           lsrb                ; logical shift right b
           cmpa CL3PTR_Cyl3AdaptiveMemoryPointer    ; compare a with memory contents (data is 04)
           beq  LD0CE          ; branch if equal (zero)
           lsrb                ; logical shift right b
           cmpa CL4PTR_Cyl4AdaptiveMemoryPointer    ; compare a with memory contents (data is 05)
           bne  LD11D          ; branch if not equal (not zero)
   LD0CE:  brset *CylTrim_FlagsE7, #$%00100000, LD11D    ; branch if bit(s) set
           brset *BitFlags67, #b67_StayOpenLoop, LD120    ; branch if bit(s) set
           bitb CylTrim_FlagsE6
           bne  LD11D          ; branch if not equal (not zero)
           lslb            
           lslb            
           lslb            
           lslb            
           brclr *CylTrim_FlagsE7, #$%10000000, LD0EC    ; branch if bit(s) clear
           cmpb #0x80          ;  -10000000-
           bne  LD0EC          ; branch if not equal (not zero)
           bset *CylTrim_FlagsE6, #$%10000000    ; set bits
           bclr *CylTrim_FlagsE7, #$%10000000    ; clear bits
   LD0EC:  bitb CylTrim_FlagsE6
           beq  LD11D          ; branch if equal (zero)
           ldaa CylTrim_Adaptive_Var1    ; load a with memory contents
           cmpa 0x00, X        ; compare a with memory at index + value
           bcc  LD110          ; branch if greater or equal
           bitb CylTrimFlags
           bne  LD11D          ; branch if not equal (not zero)
           tsta                ; test a
           beq  LD103          ; branch if equal (zero)
           brclr *Counter_MainLoop, #$%00111111, LD103    ; branch if bit(s) clear
           bra  LD108          ; branch

   LD103:  inca                ; increment a
           beq  LD108          ; branch if equal (zero)
           staa CylTrim_Adaptive_Var1    ; store a into memory
   LD108:  cmpa #0x03          ; compare a with value -00000011-
           bcs  LD120          ; branch if lower
           bclr *PIA1_Buffer, #pi1_PurgeSol    ; clear bits
           rts                 ; return from subroutine

   LD110:  lsrb                ; logical shift right b
           lsrb                ; logical shift right b
           lsrb                ; logical shift right b
           lsrb                ; logical shift right b
           tba                 ; a = b
           orab CylTrim_FlagsE6
           stab CylTrim_FlagsE6    ; store b into memory
           oraa CylTrimFlags    ; OR a with memory contents
           staa CylTrimFlags    ; store a into memory
   LD11D:  clr  CylTrim_Adaptive_Var1    ; zero byte at memory location
   LD120:  bset *PIA1_Buffer, #pi1_PurgeSol    ; set bits
           rts                 ; return from subroutine

DetermineIndividualInjectorTrims_MM:
           brclr *CylTrim_FlagsE7, #$%01000000, LD129    ; branch if bit(s) clear
           rts                 ; return from subroutine

   LD129:  brclr *CylTrimFlags, #$%00001000, LD14B    ; branch if bit(s) clear
           ldx  #AutoCalCell0    ; load index with value
           ldab CL2PTR_Cyl2AdaptiveMemoryPointer    ; load b with memory contents (data is 0d)
           abx                 ; add b to index
           ldaa Cyl2_InjPWTrim    ; load a with memory contents
           suba 0x00, X    
           blt  LD14B          ; branch if less
           brclr *CylTrimFlags, #$%10000000, LD141    ; branch if bit(s) clear
           adda CL2INC_Cyl2TrimIncrement    ;  (data is 05)
   LD141:  cmpa CL2LMT_Cyl2TrimLimit    ; compare a with memory contents (data is 33)
           bcs  LD14B          ; branch if lower
           bset *CylTrimFlags, #$%10000000    ; set bits
           bra  LD14E          ; branch

   LD14B:  bclr *CylTrimFlags, #$%10000000    ; clear bits
   LD14E:  brclr *CylTrimFlags, #$%00000100, LD170    ; branch if bit(s) clear
           ldx  #AutoCalCell0    ; load index with value
           ldab CL1PTR_Cyl1AdaptiveMemoryPointer    ; load b with memory contents (data is 03)
           abx                 ; add b to index
           ldaa Cyl1_InjPWTrim    ; load a with memory contents
           suba 0x00, X    
           blt  LD170          ; branch if less
           brclr *CylTrimFlags, #$%01000000, LD166    ; branch if bit(s) clear
           adda CL1INC_Cyl1TrimIncrement    ;  (data is 05)
   LD166:  cmpa CL1LMT_Cyl1TrimLimit    ; compare a with memory contents (data is 33)
           bcs  LD170          ; branch if lower
           bset *CylTrimFlags, #$%01000000    ; set bits
           bra  LD173          ; branch

   LD170:  bclr *CylTrimFlags, #$%01000000    ; clear bits
   LD173:  brclr *CylTrimFlags, #$%00000010, LD195    ; branch if bit(s) clear
           ldx  #AutoCalCell0    ; load index with value
           ldab CL3PTR_Cyl3AdaptiveMemoryPointer    ; load b with memory contents (data is 04)
           abx                 ; add b to index
           ldaa Cyl3_InjPWTrim    ; load a with memory contents
           suba 0x00, X    
           blt  LD195          ; branch if less
           brclr *CylTrimFlags, #$%00100000, LD18B    ; branch if bit(s) clear
           adda CL3INC_Cyl3TrimIncrement    ;  (data is 05)
   LD18B:  cmpa CL3LMT_Cyl3TrimLimit    ; compare a with memory contents (data is 33)
           bcs  LD195          ; branch if lower
           bset *CylTrimFlags, #$%00100000    ; set bits
           bra  LD198          ; branch

   LD195:  bclr *CylTrimFlags, #$%00100000    ; clear bits
   LD198:  brclr *CylTrimFlags, #$%00000001, LD1B9    ; branch if bit(s) clear
           ldx  #AutoCalCell0    ; load index with value
           ldab CL4PTR_Cyl4AdaptiveMemoryPointer    ; load b with memory contents (data is 05)
           abx                 ; add b to index
           ldaa Cyl4_InjPWTrim    ; load a with memory contents
           suba 0x00, X    
           blt  LD1B9          ; branch if less
           brclr *CylTrimFlags, #$%00010000, LD1B0    ; branch if bit(s) clear
           adda CL4INC_Cyl4TrimIncrement    ;  (data is 05)
   LD1B0:  cmpa CL4LMT_Cyl4TrimLimit    ; compare a with memory contents (data is 33)
           bcs  LD1B9          ; branch if lower
           bset *CylTrimFlags, #$%00010000    ; set bits
           rts                 ; return from subroutine

   LD1B9:  bclr *CylTrimFlags, #$%00010000    ; clear bits
           rts                 ; return from subroutine

IncludeCylTrimWithAdaptiveCells:
           bset *CylTrim_FlagsE7, #$%00100000    ; set bits
           bset *CylTrim_FlagsE6, #$%10000000    ; set bits
           ldab #0xf0          ; load b with value -11110000-
           bitb CylTrimFlags
           beq  LD21F          ; branch if equal (zero)
           ldaa CoolantTemp    ; load a with memory contents
           cmpa CLTRP3_Cyl3TrimValueForPurgeVolume    ; compare a with memory contents (data is db)
           bhi  LD229          ; branch if higher
           ldaa Cyl1_InjPWTrim    ; load a with memory contents
           ldab Cyl3_InjPWTrim    ; load b with memory contents
           cba             
           bge  LD1D8          ; branch if greater or equal
           tba                 ; a = b
   LD1D8:  ldab Cyl4_InjPWTrim    ; load b with memory contents
           cba             
           bge  LD1DE          ; branch if greater or equal
           tba                 ; a = b
   LD1DE:  clrb                ; b = 0
   LD1DF:  cmpb CL2PTR_Cyl2AdaptiveMemoryPointer    ; compare b with memory contents (data is 0d)
           beq  LD1F7          ; branch if equal (zero)
           cmpb CL1PTR_Cyl1AdaptiveMemoryPointer    ; compare b with memory contents (data is 03)
           beq  LD1F7          ; branch if equal (zero)
           cmpb CL3PTR_Cyl3AdaptiveMemoryPointer    ; compare b with memory contents (data is 04)
           beq  LD1F7          ; branch if equal (zero)
           cmpb CL4PTR_Cyl4AdaptiveMemoryPointer    ; compare b with memory contents (data is 05)
           beq  LD1F7          ; branch if equal (zero)
           pshb                ; push b onto stack
           bsr  UpdateAdaptiveCellWithCylTrim    ; call subroutine
           pulb                ; pull b from stack
   LD1F7:  incb            
           pshb                ; push b onto stack
           addb #0x11          ;  -00010001-
           cmpb #0x1f          ;  -00011111-
           pulb                ; pull b from stack
           bcs  LD1DF          ; branch if lower
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
   LD21F:  ldaa CoolantTemp    ; load a with memory contents
           cmpa CLTRP4_Cyl4TrimValueForPurgeVolume    ; compare a with memory contents (data is 84)
           bcc  LD229          ; branch if greater or equal
           bset *CylTrim_FlagsE7, #$%01000000    ; set bits
   LD229:  ldx  #CONFIG_ConfigurationFlags    ; load index with value
           brclr  0, X, #$%00100000, LD23E    ; branch if bit(s) clear
           ldaa AutoCalCellEnd    ; load a with memory contents
           tab                 ; b = a
           suba AutoCalCell12idle
           blt  LD23E          ; branch if less
           cmpa CL2LMT_Cyl2TrimLimit    ; compare a with memory contents (data is 33)
           bcs  LD23E          ; branch if lower
           stab AutoCalCell12idle    ; store b into memory
   LD23E:  rts                 ; return from subroutine

UpdateAdaptiveCellWithCylTrim:
           ldx  #AutoCalCell0    ; load index with value
           abx                 ; add b to index
           ldab 0x00, X        ; load b with memory at index + value
           cba             
           ble  LD24A          ; branch if less or equal
           staa 0x00, X    
   LD24A:  rts                 ; return from subroutine

;           .org   0xD26C
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
           bra  LD2A2          ; branch

SparkAdvance_EngineDeccelerating:
           cmpD RPMFNG_SparkAdvanceRPMFilterLimitNeg    ; compare D (data is 01)
           bcc  SparkAdvance_EngineSpeedNotAccelOrDeccel    ; branch if greater or equal
           xgDY                ; exchange D and Y
           ldaa RPMFRT_SparkAdvanceRPMFilterRatio    ; load a with memory contents (data is 7f)
           beq  SparkAdvance_EngineSpeedNotAccelOrDeccel    ; branch if equal (zero)
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
   LD2A2:  addd PreviousEngineRpm_HB    ; d = d + memory contents
           bra  SparkAdvance_StorePreviousEngineRPM    ; branch

SparkAdvance_EngineSpeedNotAccelOrDeccel:
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
SparkAdvance_StorePreviousEngineRPM:
           stD *PreviousEngineRpm_HB    ; store D to RAM
           brset *BitFlags66, #b66_OffIdle, SparkAdvance_LookupFullThrottleTiming    ; branch if bit(s) set
           brset *BitFlags67, #b67_FallToIdle, SparkAdvance_LookupFullThrottleTiming    ; branch if bit(s) set
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #IDLADV_IdleAdvanceFromCoolantTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp0          ; store a into memory
           brclr *BitFlags66, #b66_O2Valid, LD2E9    ; branch if bit(s) clear
           ldaa Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop    ; load a with memory contents
           bne  LD2E9          ; branch if not equal (not zero)
           ldaa Counter_O2SensorFeedbackCount_Signed    ; load a with memory contents
           cmpa ADO2CL_AdvanceAddedFromO2FeedbackCounterLimitLow    ; compare a with memory contents (data is 1a)
           bge  LD2E9          ; branch if greater or equal
           cmpa ADO2CH_AdvanceAddedFromO2FeedbackCounterLimitHi    ; compare a with memory contents (data is e6)
           ble  LD2E9          ; branch if less or equal
           ldx  #ADO2C2_AdvanceAddedFromO2FeedbackCounter2    ; load index with value
           brset *BitFlags_AIS, #b10_ATXInGear, LD2DA    ; branch if bit(s) set
           ldx  #ADO2C1_AdvanceAddedFromO2FeedbackCounter1    ; load index with value
   LD2DA:  adda #0x80          ;  -10000000-
           jsr  Lookup4ByteTable    ; call subroutine
           staa O2AdvanceIncrement
           adda Temp0      
           bpl  LD2E7          ; branch if plus (hi bit 0)
           clra                ; a = 0
   LD2E7:  staa Temp0          ; store a into memory
   LD2E9:  jmp  LD383      

SparkAdvance_LookupFullThrottleTiming:
           clrb                ; b = 0
           ldaa MapValue       ; load a with memory contents
           brclr *BitFlags66, #b66_FullThrottle, SparkAdvance_LookupPartThrottleTiming_LoMAP    ; branch if bit(s) clear
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
           beq  SparkAdvance_LookupTempCompensationFrom3DTable    ; branch if equal (zero)
           ldx  #THRMOD_AdvanceModifier3DNormal    ; load index with value
SparkAdvance_LookupTempCompensationFrom3DTable:
           jsr  Lookup3DTableRoutine    ; call subroutine
           staa Temp3          ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #TMPSWP_EngTempSwitchPointForSparkAdvance    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldab Temp3          ; load b with memory contents
           bpl  LD348          ; branch if plus (hi bit 0)
           negb            
   LD348:  mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           tst  Temp3      
           bpl  LD351          ; branch if plus (hi bit 0)
           nega                ; negate a (set high bit)
   LD351:  adda Temp0      
           bvc  LD359          ; branch if overflow
           bpl  LD35C          ; branch if plus (hi bit 0)
           ldaa #0x7f          ; load a with value -01111111-
   LD359:  tsta                ; test a
           bpl  LD35D          ; branch if plus (hi bit 0)
   LD35C:  clra                ; a = 0
   LD35D:  staa Temp0          ; store a into memory
           ldaa MapValue       ; load a with memory contents
           ldx  #ARMPMD_ModifiedMAPForAdaptiveRetard3D    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldab EngineRPM_3D    ; load b with memory contents
           subb #0x80          ;  -10000000-
           bcc  LD36E          ; branch if greater or equal
           clrb                ; b = 0
   LD36E:  lslb            
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
   LD383:  ldx  #SPKLMT_TotalAdvanceAllowed    ; load index with value
           ldaa EngineRpm_HB    ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           cmpa Temp0          ; compare a with memory contents
           bcc  LD391          ; branch if greater or equal
           staa Temp0          ; store a into memory
   LD391:  bclr *BitFlags6E, #b6e_UseSparkScatter    ; clear bits
           clra                ; a = 0
           ldab BitFlags6D     ; load b with memory contents
           orab BitFlags66 
           bmi  LD411          ; branch if minus(hi bit 1)
           brset *BitFlags6B, #$%00010000, LD3AB    ; branch if bit(s) set
           ldab BitFlags_AIS    ; load b with memory contents
           andb #0x04          ;  -00000100-
           orab Timer_CountdownFromStartRunForAisFeedback
           bne  LD411          ; branch if not equal (not zero)
           brset *BitFlags67, #b67_FallToIdle, LD411    ; branch if bit(s) set
   LD3AB:  brset *b5C_IPL1, #b5c_MapStuck | b5c_MapBadSignal, LD411    ; branch if bit(s) set
           ldab SPKSET_ConstantSparkAdvanceWhenSettingBasicTiming          ; load b with memory contents (data is 18)
           brset *b5C_IPL1, #b5c_BadCoolantTemp, LD40F    ; branch if bit(s) set
           brset *BitFlags6C, #$%00100000, LD40F    ; branch if bit(s) set
           ldab IDLSET_ConstantSparkAdvanceWhenSettingMinThrottleOpening          ; load b with memory contents (data is 18)
           brset *BitFlags6C, #b6c_DRBModeFlag, LD40F    ; branch if bit(s) set
           ldab CoolantTemp    ; load b with memory contents
           cmpb SSTEMP_TempAboveWhichSparkScatterIsActive    ; compare b with memory contents (data is 58)
           bls  LD411          ; branch if lower or same
           ldx  KeyOnOrEngineRunningTime
           cpx  SSITIM_ScatterInhibitTime    ;  (data is 0088)
           bcs  LD411          ; branch if lower
           ldx  TimerOverflowsBetweenCamPulses
           cpx  SSIPRD_ScatterInhibitBelowThisSpeed    ;  (data is 0066)
           bcc  LD411          ; branch if greater or equal
           bset *BitFlags6E, #b6e_UseSparkScatter    ; set bits
           ldx  #SPKRET_SparkAdvanceRetardedWhenRpmAboveControl_FromDeltaRpm    ; load index with value
           brset *BitFlags_AIS, #b10_ATXInGear, LD3E3    ; branch if bit(s) set
           ldx  #SPKRT2_SparkAdvanceRetardedWhenRpmAboveControl2_FromDeltaRpm    ; load index with value
   LD3E3:  ldd  PreviousEngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeedHB    ; d = d - memory contents
           bcc  LD3F8          ; branch if greater or equal
           ldx  #SPKADD_SparkAdvanceAddedWhenRpmBelowControl_FromDeltaRpm    ; load index with value
           brset *BitFlags_AIS, #b10_ATXInGear, LD3F3    ; branch if bit(s) set
           ldx  #SPKAD2_SparkAdvanceAddedWhenRpmBelowControl2_FromDeltaRpm    ; load index with value
   LD3F3:  coma            
           comb            
           addd #0x0001         ;  -00000000 00000001-
   LD3F8:  lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           bcc  LD401          ; branch if greater or equal
           addd #0x0001         ;  -00000000 00000001-
   LD401:  tsta                ; test a
           beq  LD406          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   LD406:  tba                 ; a = b
           jsr  Lookup4ByteTable    ; call subroutine
           addb Temp0          ; b=b+memory contents
           bpl  LD40F          ; branch if plus (hi bit 0)
           clrb                ; b = 0
   LD40F:  stab Temp0          ; store b into memory
   LD411:  staa SparkScatter   ; store a into memory
           ldab Temp0          ; load b with memory contents
           stab CalculatedSparkAdvance    ; store b into memory
           rts                 ; return from subroutine

Lookup3DTableRoutine:

; The 3D table processing function: Input is 2 8-bit values stored in A and B.
; A = Y Axis values, B = X-Axis Values. Output is returned in A.
; 
; The table handles both signed and unsigned data by indicating the type in
; the third header byte. It really only makes a small difference to the math.
;
; Input to table address are in A and B and are values in the range 0-FF.
; These values are scaled into the width and height address range of the table
; and then used to look up the first byte. The fractional value of the table
; column address is retained and used to interpolate between this first byte
; and the next byte in the row. The last byte in a row will never be addressed
; directly, it's there strictly for the interpolation, which is why you see
; the width being DECremented in places. The last row in the table serves a
; similar purpose. The process is done a second time at the same column
; position, but in the next row down. The two column values derived are then
; interpolated between against the fractional Y address, and this value is
; returned in A.
; 
; 
; The data format is pretty simple:
; 
; BYTE 0: Height, number of rows (Y dimension)
; BYTE 1: Width, number of columns (X dimension)
; BYTE 2: 0 = unsigned data, 80 (Bit 7 set) = signed data
; 
; BYTE 3: Width bytes data
; BYTE 3+ (Width *1): Width bytes data
; BYTE 3+ (Width *2): Width bytes data
; ...
; BYTE (3 + Width * Height - 1): Last byte of data

           ; Default is unsigned data
           ldY #InterpUnsigned          ; load Y index -11010100 10011011-
           brclr  2, X, #$%11111111, LD424    ; branch if bit(s) clear
           ; Signed data interpolation
           ldY #InterpSigned          ; load Y index -11010100 10010111-
           ; Making room on the stack for local variables
   LD424:  pshy                ; push Y onto stack
           psha                ; push a onto stack
           psha                ; push a onto stack
           ; Get the number of columns in a row
           ldaa 0x01, X        ; load a with memory at index + value
           ; Decrement because last byte is for interpolation
           deca                ; decrement a
           ; Scale input X value into table X-axis (A), save the fractional part (B) for later
           mul                 ; multiply (d=a*b)
           ; A = column number, B = fractional column value for interpolation
           psha                ; push a onto stack
           pshb                ; push b onto stack
           ; Setup Y to be our frame for local variables on the stack
           tSY                 ; transfer stack to Y
           ; Get input row index A value
           ldaA 0x02, Y       ; load A indexed to Y -00000010-
           ; First table byte is number rows in table
           ldab 0x00, X        ; load b with memory at index + value
           ; Decrement because last row is for interpolation only
           decb
           mul                 ; multiply (d=a*b)
           ; A = row number, B = fractional row value for interpolation
           ; Store the fraction for later
           staB 0x03, Y       ; store B to location indexed to Y -00000011-
           ; Get number of columns in table, store for later
           ldab 0x01, X        ; load b with memory at index + value
           staB 0x02, Y       ; store B to location indexed to Y -00000010-
           ; Multiply row number by the width of a row to get byte-offset into table
           mul                 ; multiply (d=a*b)
           ; Bump up X pointer past header to start of data
           inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
           ; Add offset into table to X
           abx                 ; add b to index
           ; If offset is less than 0x100 (IE high byte = 0) then skip next bit
           tsta                ; test a
           beq  LD44B          ; branch if equal (zero)
           ; Add 100H to table offset pointer
           ; Note that this effectively limits the table to 0x1ff entries
           inx                 ; increment index (x=x+1)
           ldab #0xff          ; load b with value -11111111-
           abx                 ; add b to index
           ; Get interpolated column position
   LD44B:  ldaB 0x01, Y       ; load B with value indexed to Y -00000001-
           ; Add to table offset
           abx                 ; add b to index
           ; Get fractional portion of column address
           ldaB 0x00, Y       ; load B with value indexed to Y -00000000-
           ; We need Y for some calcs ahead, save it's value on the stack
           pshy                ; push Y onto stack
           ; Load the pointer to the interpolation entry point chosen at the beginning
           ldY 0x04, Y        ; load Y indexed to Y -00000100-
           ; Get the first data byte indexed from the table
           ldaa 0x00, X        ; load a with memory at index + value
           ; Subtract the next byte in the row
           suba 0x01, X
           ; Call the interpolator
           jsr 0x00, Y        ; jump to subroutine at index Y + value -00000000-
           ; A contains the return value
           ; Restore local variable frame
           puly                ; pop Y from stack
           ; Store interpolated table X value
           staA 0x01, Y       ; store A with value indexed to Y -00000001-
           ; Get number of columns per row
           ldaB 0x02, Y       ; load B with value indexed to Y -00000010-
           ; Advance table offset pointer to next row, same column
           abx                 ; add b to index
           ; Get fractional column address from stack
           pulb                ; pull b from stack
           ; Save local variable frame pointer
           pshy                ; push Y onto stack
           ; Get interpolation function pointer
           ldY 0x04, Y        ; load Y indexed to Y -00000100-
           ; Interpolate the value between the two points
           ldaa 0x00, X        ; load a with memory at index + value
           suba 0x01, X    
           jsr 0x00, Y        ; jump to subroutine at index Y + value -00000000-
           ; A contains the interpolated value
           ; Restore local variable frame
           puly                ; pop Y from stack
           ; X now contains the local variable frame pointer
           ; This is done because the interpolation function expects
           ; X to point to the two point values, which for this last
           ; operation are stored on the stack in our local variable area
           tsx                 ; transfer stack to index (x=sp+1)
           ; Store the row+1 interpolated value
           staa 0x01, X
           ; Get the row address fraction
           ldab 0x02, X        ; load b with memory at index + value
           ; Get the interpolation function pointer
           ldY 0x03, X        ; load Y indexed to X -00000011-
           ; Perform a final interpolation of the values from the two rows
           ldaa 0x00, X        ; load a with memory at index + value
           suba 0x01, X    
           jsr 0x00, Y        ; jump to subroutine at index Y + value -00000000-
           ; Clean up stack frame
           pulb                ; pull b from stack
           pulx                ; pull index from stack
           pulx                ; pull index from stack
           ; Return value is A
           rts                 ; return from subroutine
           
           ; Appears to be dead code? No references to it I can find
   LD489:  ldab 0x00, X        ; load b with memory at index + value
           decb            
           mul                 ; multiply (d=a*b)
           pshb                ; push b onto stack
           tab                 ; b = a
           incb            
           abx                 ; add b to index
           ldd  0x00, X    
           sba                 ; subtract (a=a-b)
           pulb                ; pull b from stack
           bra  InterpUnsigned          ; branch

; This function interpolates the absolute value of the
; difference between two points
;
; Inputs:
; A = Delta between two points
; B = Fractional value 0-FF
; X = Pointer to first point
; Carry Flag = Result of Point1 - Point2
;
; Outputs:
; A = interpolated value

           ; Interpolation function, signed math entry point
           ; Branch if first byte was less than second
   InterpSigned:  
           blt  LD4A3          ; branch if less
           bra  LD49D          ; branch
           ; Interpolation function, unsigned math entry point
           ; Branch if first byte was less than second
   InterpUnsigned:  
           bcs  LD4A3          ; branch if lower
           ; First byte was bigger than second
           ; Multiply delta x fraction
   LD49D:  mul                 ; multiply (d=a*b)
           ; Round up
           adca #0x00          ;  -00000000-
           ; Negate result so that value subtracts from first byte
           nega                ; negate a (set high bit)
           bra  LD4A7          ; branch
           ; Second byte was bigger than first
           ; Get abs value of the delta
   LD4A3:  nega                ; negate a (set high bit)
           ; Interpolate
           mul
           ; Round up
           adca #0x00          ;  -00000000-
           ; Add the base value to the interpolated delta value
   LD4A7:  adda 0x00, X
           ; A returns the interpolated value
           rts                 ; return from subroutine

Interrupt_DwellTimerA:
           ldaa #0x10          ; load a with value -00010000-
           staa CPU_TimerInterruptFlag1
           brclr *BitFlags_BF, #$%10000000, LD4EC    ; branch if bit(s) clear
           ldab TimerOverflowsBetweenCamPulses    ; load b with memory contents
           bne  LD4EC          ; branch if not equal (not zero)
           brset *BitFlags6D, #b6d_DisableNormalDwell, LD4EC    ; branch if bit(s) set
           ldab CPU_TimerControlReg1    ; load b with memory contents
           bitb #0x04          ;  -00000100-
           beq  LD4EC          ; branch if equal (zero)
           ldab #0x02          ; load b with value -00000010-
           ldaa AdvanceTemporary    ; load a with memory contents
           cmpa #0x66          ; compare a with value -01100110-
           bcc  LD4D6          ; branch if greater or equal
           cmpa #0x39          ; compare a with value -00111001-
           bcc  LD4CF          ; branch if greater or equal
           incb            
   LD4CF:  ldaa BitFlags_BF    ; load a with memory contents
           anda #0x07          ; AND a with value -00000111-
           cba             
           bcs  LD4EC          ; branch if lower
   LD4D6:  ldab CPU_TimerControlReg1    ; load b with memory contents
           andb #0xfb          ;  -11111011-
           stab CPU_TimerControlReg1    ; store b into memory
           ldab Timer_Dwell_14    ; load b with memory contents
           clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd #0x07d0        ;  -00000111 11010000-
           addd CPU_Timer_OC4_DwellA
           std  CPU_Timer_OC4_DwellA
   LD4EC:  ldaa CPU_TimerInterruptMask1    ; load a with memory contents
           anda #0xef          ; AND a with value -11101111-
           staa CPU_TimerInterruptMask1
           rti                 ; return from interrupt

Interrupt_DwellTimerB:
           ldaa #0x08          ; load a with value -00001000-
           staa CPU_TimerInterruptFlag1
           brclr *BitFlags_BF, #$%10000000, LD537    ; branch if bit(s) clear
           ldab TimerOverflowsBetweenCamPulses    ; load b with memory contents
           bne  LD537          ; branch if not equal (not zero)
           brset *BitFlags6D, #b6d_DisableNormalDwell, LD537    ; branch if bit(s) set
           ldab CPU_TimerControlReg1    ; load b with memory contents
           bitb #0x01          ;  -00000001-
           beq  LD537          ; branch if equal (zero)
           ldab #0x02          ; load b with value -00000010-
           ldaa AdvanceTemporary    ; load a with memory contents
           cmpa #0x66          ; compare a with value -01100110-
           bcc  LD521          ; branch if greater or equal
           cmpa #0x39          ; compare a with value -00111001-
           bcc  LD51A          ; branch if greater or equal
           incb            
   LD51A:  ldaa BitFlags_BF    ; load a with memory contents
           anda #0x07          ; AND a with value -00000111-
           cba             
           bcs  LD537          ; branch if lower
   LD521:  ldab CPU_TimerControlReg1    ; load b with memory contents
           andb #0xfe          ;  -11111110-
           stab CPU_TimerControlReg1    ; store b into memory
           ldab Timer_Dwell_23    ; load b with memory contents
           clra                ; a = 0
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd #0x07d0        ;  -00000111 11010000-
           addd CPU_Timer_OC5_DwellB
           std  CPU_Timer_OC5_DwellB
   LD537:  ldaa CPU_TimerInterruptMask1    ; load a with memory contents
           anda #0xf7          ; AND a with value -11110111-
           staa CPU_TimerInterruptMask1
           rti                 ; return from interrupt

CalculateKnockRetard_MM:
           clra                ; a = 0
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb KNKRPM_MinRpmforKnockRetard    ; compare b with memory contents (data is 20)
           bcs  LD56E          ; branch if lower
           deca                ; decrement a
           ldab b5C_IPL1       ; load b with memory contents
           andb #b5c_MapStuck | b5c_TpsBadSignal | b5c_MapBadSignal          ;  -11100000-
           bne  LD568          ; branch if not equal (not zero)
           ldaa MapValue       ; load a with memory contents
           ldab TpsVolts       ; load b with memory contents
           subb MINTHR_LowestSessionTPS    ; b = b-memory contents
           bcs  LD568          ; branch if lower
           cmpb THRKNK_DeltaAbove_MINTHR    ; compare b with memory contents (data is 53)
           bcs  LD568          ; branch if lower
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb KLMRPM_MinKnockDetectRpm    ; compare b with memory contents (data is 20)
           bcc  LD568          ; branch if greater or equal
           ldaa KNKLIM_MaxKnockRetard    ; load a with memory contents (data is 06)
           bra  LD56E          ; branch

   LD568:  ldx  #RETMAX_MaxKnockRetardFromMap    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
   LD56E:  staa MaxRetardFromMAP    ; store a into memory
           ldaa EngineRpm_HB    ; load a with memory contents
           ldx  #DLTKNK_KnockSensorVoltageForKnockFromRpm    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           staa KnockSensorThreshold    ; store a into memory
           ldaa Counter_MainLoop    ; load a with memory contents
           bita INCSRT_KnockRetardIncreaseRate    ;  (data is 0f)
           bne  LD593          ; branch if not equal (not zero)
           ldx  #Cylinder2Retard    ; load index with value
   LD584:  sei                 ; disable interrupts
           ldaa 0x00, X        ; load a with memory at index + value
           beq  LD58C          ; branch if equal (zero)
           deca                ; decrement a
           staa 0x00, X    
   LD58C:  cli                 ; enable interrupts
           inx                 ; increment index (x=x+1)
           cpx  #Cylinder4Retard    ;  -00000000 11000110-
           bls  LD584          ; branch if lower or same
   LD593:  rts                 ; return from subroutine

   LD594:  brclr *PIA1_Buffer, #pi1_ASD, LD5C4    ; branch if bit(s) clear
           ldaa TimerOverflowsBetweenCamPulses    ; load a with memory contents
           cmpa #0x05          ; compare a with value -00000101-
           bcs  LD5C4          ; branch if lower
           ldab #0x0a          ; load b with value -00001010-
           stab CPU_TimerControlReg1    ; store b into memory
           ldab #0x18          ; load b with value -00011000-
           stab CPU_HardwareTimerForceCompare    ; store b into memory
           cmpa #0x13          ; compare a with value -00010011-
           bne  LD5C4          ; branch if not equal (not zero)
           sei                 ; disable interrupts
           clr  BitFlags_BF    ; zero byte at memory location
           clr  PIA_Ctrl_6          ; zero byte at memory location
           ldab #0x01          ; load b with value -00000001-
           stab PIA_Ctrl_4          ; store b into memory
           stab CPU_TimerInterruptFlag1    ; store b into memory
           ldab #0xfe          ; load b with value -11111110-
           andb PIA_Ctrl_3      
           stab PIA_Ctrl_3          ; store b into memory
           cli                 ; enable interrupts
   LD5C4:  rts                 ; return from subroutine

DecrementDwellTimers_MM:
           brclr *BitFlags_BF, #$%00001000, LD5E3    ; branch if bit(s) clear
           brset *BitFlags6D, #b6d_DisableNormalDwell, LD5E3    ; branch if bit(s) set
           ldx  #Timer_Dwell_14    ; load index with value
           ldaa Counter_MainLoop    ; load a with memory contents
           anda #0x3f          ; AND a with value -00111111-
           cmpa #0x1f          ; compare a with value -00011111-
           beq  LD5DD          ; branch if equal (zero)
           inx                 ; increment index (x=x+1)
           cmpa #0x3f          ; compare a with value -00111111-
           bne  LD5E3          ; branch if not equal (not zero)
   LD5DD:  brclr  0, X, #$%11111111, LD5E3    ; branch if bit(s) clear
           dec  0x00, X    
   LD5E3:  rts                 ; return from subroutine

RescaleRPMFor3D_MM:
           ldx  #RPMHI_HiRPM3DInputModifierFromRPM    ; load index with value
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           cmpD #0x4000        ; compare D -01000000 00000000-
           bcc  LD5F4          ; branch if greater or equal
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           ldx  #RPMLO_LoRPM3DInputModifierFromRPM    ; load index with value
   LD5F4:  jsr  Lookup4ByteTable    ; call subroutine
           staa EngineRPM_3D    ; store a into memory
           rts                 ; return from subroutine

CalcTargetBoost_MM:
           ldaa ATMOffset      ; load a with memory contents
           cmpa #0x11          ; compare a with value -00010001-
           beq  LD608          ; branch if equal (zero)
           cmpa #0x20          ; compare a with value -00100000-
           beq  LD608          ; branch if equal (zero)
           cmpa #0x14          ; compare a with value -00010100-
           bne  LD609          ; branch if not equal (not zero)
   LD608:  rts                 ; return from subroutine

   LD609:  brclr *BitFlags6D, #b6d_FuelEngineNotRunning, LD628    ; branch if bit(s) clear
           clra                ; a = 0
           staa WastegateDutyCycleIncreaseFromKnock    ; store a into memory
           jsr  NULL_ROUTINE    ; call subroutine
           staa CurrentWastegatePosition    ; store a into memory
           bset *PIA2_Buffer, #pi2_PTU    ; set bits
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x1f          ;  -00011111-
           bne  LD627          ; branch if not equal (not zero)
           ldaa Timer_BoostTimer    ; load a with memory contents
           beq  LD627          ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_BoostTimer
   LD627:  rts                 ; return from subroutine

   LD628:  ldaa Counter_MainLoop    ; load a with memory contents
           ldx  #Cylinder2Retard    ; load index with value
   LD62D:  ldab 0x00, X        ; load b with memory at index + value
           beq  Boost_LookAtCylRetards    ; branch if equal (zero)
           bita ARCMSK_AdaptiveRetardCounterMask    ;  (data is 3f)
           bne  LD669          ; branch if not equal (not zero)
           ldaa CoolantTemp    ; load a with memory contents
           cmpa ARMINT_AdaptiveRetardMinimumTemp    ; compare a with memory contents (data is b1)
           bls  LD666          ; branch if lower or same
           ldaa Timer_Over5PsiBoostMaxFF    ; load a with memory contents
           inca                ; increment a
           cmpa ARTM5P_AdaptiveRetardTimeOver5psiBoost    ; compare a with memory contents (data is 09)
           bcs  LD667          ; branch if lower
           sei                 ; disable interrupts
           ldaa AdaptiveRetardIndex    ; load a with memory contents
           adda ARINDX_AdaptiveRetardIndexBase_80    ;  (data is 80)
           bcc  LD64F          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LD64F:  staa AdaptiveRetardIndex    ; store a into memory
           cli                 ; enable interrupts
           bra  LD666          ; branch

Boost_LookAtCylRetards:
           inx                 ; increment index (x=x+1)
           cpx  #Cylinder4Retard    ;  -00000000 11000110-
           bls  LD62D          ; branch if lower or same
           bita ARCMS2_AdaptiveRetardCounterMask2_00    ;  (data is 00)
           bne  LD669          ; branch if not equal (not zero)
           ldaa Timer_Over5PsiBoostMaxFF    ; load a with memory contents
           suba ARCMS3_AdaptiveRetardCounterMask3_FF    ;  (data is ff)
           bcc  LD667          ; branch if greater or equal
   LD666:  clra                ; a = 0
   LD667:  staa Timer_Over5PsiBoostMaxFF    ; store a into memory
   LD669:  brclr *BitFlags70, #$%01000000, LD688    ; branch if bit(s) clear
           bclr *BitFlags70, #$%01000000    ; clear bits
           ldab WastegateDutyCycleIncreaseFromKnock    ; load b with memory contents
           addb KDCINC_WastegateDutyCycleIncreaseStepWhenKnocking    ;  (data is 01)
           bcc  LD679          ; branch if greater or equal
           ldab #0xff          ; load b with value -11111111-
   LD679:  ldaa KDCMAX_WastegateDutyCycleIncreaseMaxWhenKnocking    ; load a with memory contents (data is 27)
           cba             
           bcs  LD685          ; branch if lower
           ldaa KDCMIN_WastegateDutyCycleIncreaseMinWhenKnocking    ; load a with memory contents (data is 02)
           cba             
           bcs  LD6A7          ; branch if lower
   LD685:  tab                 ; b = a
           bra  LD6A7          ; branch

   LD688:  ldab Counter_MainLoop    ; load b with memory contents
           bitb DECTIM_TimeScaleFor_DCDECK    ;  (data is 07)
           bne  LD6A9          ; branch if not equal (not zero)
           ldx  #CalculatedSparkAdvance    ; load index with value
   LD692:  inx                 ; increment index (x=x+1)
           cpx  #MaxRetardFromMAP    ;  -00000000 11000111-
           beq  LD6A6          ; branch if equal (zero)
           ldaa 0x00, X        ; load a with memory at index + value
           cmpa MPDEL1_IncCounterWhenDeltaMapBelowThis    ; compare a with memory contents (data is 07)
           bcs  LD692          ; branch if lower
           ldab WastegateDutyCycleIncreaseFromKnock    ; load b with memory contents
           subb DCDECK_WastegateDutyCycleDecrementWhenSparkStillDerated    ; subtract memory contents from b (data is 02)
           bcc  LD6A7          ; branch if greater or equal
   LD6A6:  clrb                ; b = 0
   LD6A7:  stab WastegateDutyCycleIncreaseFromKnock    ; store b into memory
   LD6A9:  jmp  BoostControlRoutine

Interrupt_TimerOC3_Wastegate:
           bset *BitFlags6E, #$%00000100    ; set bits
           ldaa #0x64          ; load a with value -01100100-
           ldab CurrentWastegatePosition    ; load b with memory contents
           cmpb #0x04          ;  -00000100-
           bls  LD6C2          ; branch if lower or same
           cmpb #0xc4          ;  -11000100-
           bcc  LD6CB          ; branch if greater or equal
           brset *BitFlags6E, #b6e_BoostOver5psi, LD6CA    ; branch if bit(s) set
           ldaa #0xc8          ; load a with value -11001000-
           sba                 ; subtract (a=a-b)
   LD6C2:  psha                ; push a onto stack
           bset *BitFlags6E, #b6e_BoostOver5psi    ; set bits
           ldaa #0xdc          ; load a with value -11011100-
           bra  LD6D1          ; branch

   LD6CA:  tba                 ; a = b
   LD6CB:  psha                ; push a onto stack
           bclr *BitFlags6E, #b6e_BoostOver5psi    ; clear bits
           ldaa #0xd8          ; load a with value -11011000-
   LD6D1:  ldab #0x80          ; load b with value -10000000-
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
           addd CPU_Timer_OC3_Wastegate
           std  CPU_Timer_OC3_Wastegate
           ldaa #0x20          ; load a with value -00100000-
           staa CPU_TimerInterruptFlag1
           bclr *BitFlags6E, #$%00000100    ; clear bits
           rti                 ; return from interrupt

LookupAndKeepSmallerBoostGoal:
           jsr  Lookup4ByteTable    ; call subroutine
           cmpa Temp4          ; compare a with memory contents
           bcc  LD6FF          ; branch if greater or equal
           staa Temp4          ; store a into memory
   LD6FF:  rts                 ; return from subroutine

BoostControlRoutine:
           ldaa MapValue       ; load a with memory contents
           staa Temp2          ; store a into memory
           tab                 ; b = MapValue
           suba BaroPressure
           bcc  LD70A          ; branch if greater or equal
           clra                ; a = 0
   LD70A:  staa Temp1          ; store a into memory
           ldaa DeltaBoostSampleCounter    ; load a with memory contents
           cmpa DLTBSC_DeltaBoostSampleCounterMax    ; compare a with memory contents (data is 07)
           bcc  BC_CalculateSignedDeltaBoost    ; branch if greater or equal
           inca                ; increment a
           bra  BC_GetBoostTargetFromTables    ; branch

BC_CalculateSignedDeltaBoost:
           tba                 ; a = MapValue
           subb PreviousBoostOverBaro    ; b = b-memory contents
           staa PreviousBoostOverBaro    ; store a into memory
           bcc  LD726          ; branch if greater or equal
           
           ; is this going to be a problem for boost control? Does it need to be converted to MAP reference? Or is it just checking for sign?

           cmpb #0x80          ;  -10000000-
           bcc  BC_SaveSignedDeltaBoost    ; branch if greater or equal
           ldab #0x80          ; load b with value -10000000-
           bra  BC_SaveSignedDeltaBoost    ; branch

   LD726:  cmpb #0x7f          ;  -01111111-
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
           brclr *AdaptiveRetardIndex, #$%11111111, LD748    ; branch if bit(s) clear
           ldx  #WSGRPA_AllowedBoostKnock_FromRpm    ; load index with value
           ldaa EngineRpm_HB    ; load a with memory contents
           jsr  LookupAndKeepSmallerBoostGoal    ; call subroutine
   LD748:  ldx  #WSGTIM_AllowedBoost_FromTime    ; load index with value
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
           bcc  LD776          ; branch if greater or equal
           clra                ; a = 0
   LD776:  jsr  LookupAndKeepSmallerBoostGoal    ; call subroutine

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
           jsr  LookupAndKeepSmallerBoostGoal

BC_FinalBoostTarget:

; this is original code...
           ldaa Temp4          ; load a with memory contents
           adda BaroPressure
           bcc  BC_StoreBoostTarget    ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-

BC_StoreBoostTarget:
           staa BoostTarget    ; store a into memory
           brclr *BitFlags66, #b66_OffIdle, LD78C    ; branch if bit(s) clear
           clr  CurrentWGIncrement    ; zero byte at memory location
           bra  LD799          ; branch

   LD78C:  ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x03          ;  -00000011-
           bne  LD799          ; branch if not equal (not zero)
           ldaa CurrentWGIncrement    ; load a with memory contents
           inca                ; increment a
           beq  LD799          ; branch if equal (zero)
           staa CurrentWGIncrement    ; store a into memory
   LD799:  ldaa BaroPressure    ; load a with memory contents
           adda MAPPT2_WastegateDutyCycleMapSwitchPoint2    ;  (data is 04)
           cmpa Temp2          ; compare a with memory contents
           bls  BC_CalculateWGDutyCycleVars    ; branch if lower or same
           clra                ; a = 0
           staa WastegateDutyCycleIncreaseFromKnock    ; store a into memory
           brset *BitFlags66, #b66_OffIdle, LD7B8    ; branch if bit(s) set
           ldab Timer_BoostTimer    ; load b with memory contents
           beq  LD7B8          ; branch if equal (zero)
           ldab CurrentWGIncrement    ; load b with memory contents
           cmpb DFWGD2_DefaultWastegateDutyCycle2    ; compare b with memory contents (data is 40)
           bhi  LD7B8          ; branch if higher
           ldaa WGILML_WGIncrementLimitLo    ; load a with memory contents (data is a0)
   LD7B8:  jsr  NULL_ROUTINE    ; call subroutine
           staa CurrentWastegatePosition    ; store a into memory
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x1f          ;  -00011111-
           bne  LD7CC          ; branch if not equal (not zero)
           ldaa Timer_BoostTimer    ; load a with memory contents
           beq  LD7CC          ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_BoostTimer
   LD7CC:  rts                 ; return from subroutine

BC_AdjustWGDutyCycle:
           bmi  LD7DB          ; branch if minus(hi bit 1)
           adda Temp4      
           bcs  LD7D7          ; branch if lower
           cmpa #0xc8          ; compare a with value -11001000-
           bls  LD7E0          ; branch if lower or same
   LD7D7:  ldaa #0xc8          ; load a with value -11001000-
           bra  LD7E0          ; branch

   LD7DB:  adda Temp4      
           bcs  LD7E0          ; branch if lower
           clra                ; a = 0
   LD7E0:  staa Temp4          ; store a into memory
           rts                 ; return from subroutine

BC_CalculateWGDutyCycleVars:
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x1f          ;  -00011111-
           bne  LD7F9          ; branch if not equal (not zero)
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb RPMBST_MinimumRpmToTrackBoostCreep    ; compare b with memory contents (data is 3b)
           bcs  LD7F9          ; branch if lower
           ldaa Timer_BoostTimer    ; load a with memory contents
           inca                ; increment a
           beq  LD7F9          ; branch if equal (zero)
           staa Timer_BoostTimer
   LD7F9:  ldaa BoostDelta_Signed    ; load a with memory contents
           bpl  LD802          ; branch if plus (hi bit 0)
           nega                ; negate a (set high bit)
           staa Temp0          ; store a into memory
           bra  BC_ClearWGDutyCycleVars    ; branch

   LD802:  staa Temp0          ; store a into memory
           ldab BPRMIN_VNTMinimumBoostForIncrRateAdjustment          ; load b with memory contents (data is ee)
           bmi  LD811          ; branch if minus(hi bit 1)
           addb BoostTarget    ; b=b+memory contents
           bcc  LD80F          ; branch if greater or equal
           ldab #0xff          ; load b with value -11111111-
   LD80F:  bra  LD816          ; branch

   LD811:  addb BoostTarget    ; b=b+memory contents
           bcs  LD816          ; branch if lower
           clrb                ; b = 0
   LD816:  ldaa CCDFuelOutput_LB    ; load a with memory contents
           cmpb Temp2      
           bhi  LD81F          ; branch if higher
           ldaa BPRMN2_VNTMinimumDeltaBoostForIncrRateAdjustment    ; load a with memory contents (data is 06)
   LD81F:  cmpa BoostDelta_Signed    ; compare a with memory contents
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
           bcc  LD85B          ; branch if greater or equal
           clra                ; a = 0
   LD85B:  staa Temp4          ; store a into memory
           ldaa BoostTarget    ; load a with memory contents
           ldab BaroPressure    ; load b with memory contents
           addb MAPPT_WastegateDutyCycleMapSwitchPoint    ;  (data is 46)
           bcc  BC_SelectAdaptiveWGCell    ; branch if greater or equal
           ldab #0xff          ; load b with value -11111111-
BC_SelectAdaptiveWGCell:
           ldx  #DCCOR1_AdaptiveWastegateCellBelow3psi    ; load index with value
           cba             
           bcs  BC_LoadAdaptiveWGCell    ; branch if lower
           inx                 ; increment index (x=x+1)
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb DCRPM1_WastegateDutyCycleRpmBoundary1    ; compare b with memory contents (data is 7d)
           bcs  BC_LoadAdaptiveWGCell    ; branch if lower
           inx                 ; increment index (x=x+1)
           cmpb DCRPM2_WastegateDutyCycleRpmBoundary2    ; compare b with memory contents (data is 96)
           bcs  BC_LoadAdaptiveWGCell    ; branch if lower
           inx                 ; increment index (x=x+1)
           cmpb DCRPM3_WastegateDutyCycleRpmBoundary3    ; compare b with memory contents (data is af)
           bcs  BC_LoadAdaptiveWGCell    ; branch if lower
           inx                 ; increment index (x=x+1)
           cmpb DCRPM4_WastegateDutyCycleRpmBoundary4    ; compare b with memory contents (data is fe)
           bcs  BC_LoadAdaptiveWGCell    ; branch if lower
           inx                 ; increment index (x=x+1)
           cmpb DCRPM5_WastegateDutyCycleRpmBoundary5    ; compare b with memory contents (data is ff)
           bcs  BC_LoadAdaptiveWGCell    ; branch if lower
           inx                 ; increment index (x=x+1)
BC_LoadAdaptiveWGCell:
           ldab 0x00, X        ; load b with memory at index + value
           brclr *BitFlags6A, #b6a_FuelOff, LD8AC    ; branch if bit(s) clear
           brclr *BitFlags6A, #b6a_Cruise2, LD8BA    ; branch if bit(s) clear
           bclr *BitFlags6A, #b6a_Cruise2    ; clear bits
           subb WGDCOF_WastegateDutyCycleOffset          ; subtract memory contents from b (data is 00)
           bcs  LD8A6          ; branch if lower
           cmpb DECLIM_LowerLimitOnWastegateDutyCycleCorrection    ; compare b with memory contents (data is 01)
           bhi  LD8A9          ; branch if higher
   LD8A6:  ldab DECLIM_LowerLimitOnWastegateDutyCycleCorrection    ; load b with memory contents (data is 01)
   LD8A9:  jmp  BC_UpdateAdaptiveWGControlMemory

   LD8AC:  suba Temp2      
           bhi  BC_BoostIsBelowTarget    ; branch if higher
           nega                ; negate a (set high bit)
           staa Temp3          ; store a into memory
           brset *BitFlags68, #b68_EndOfBlade, BC_ControlBoostCreep    ; branch if bit(s) set
           bset *BitFlags68, #b68_EndOfBlade    ; set bits
   LD8BA:  jmp  BC_ClearBoostErrTimer

BC_ControlBoostCreep:
           ldaa BoostDelta_Signed    ; load a with memory contents
           bmi  LD8C6          ; branch if minus(hi bit 1)
           cmpa DBCRPS_DeltaBoostLimitPositiveForBoostCreep    ; compare a with memory contents (data is 02)
           bcc  LD8F5          ; branch if greater or equal
   LD8C6:  ldaa DBCRNG_DeltaBoostLimitNegativeForBoostCreep    ; load a with memory contents (data is 03)
           cmpa Temp0          ; compare a with memory contents
           bcs  LD914          ; branch if lower
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa DCRPMLV_NoWastegateDutyCycleCorrectionBelowThisRpmBC    ; compare a with memory contents (data is 40)
           bcc  LD8DE          ; branch if greater or equal
           ldaa Timer_BoostErrTimer    ; load a with memory contents
           inca                ; increment a
           cmpa DECPTV_AdaptiveDecAfterThisTimeBC    ; compare a with memory contents (data is 20)
           bcs  LD916          ; branch if lower
           bra  LD8E6          ; branch

   LD8DE:  ldaa Timer_BoostErrTimer    ; load a with memory contents
           inca                ; increment a
           cmpa DECPT_AdaptiveDecAfterThisTime    ; compare a with memory contents (data is 20)
           bcs  LD916          ; branch if lower
   LD8E6:  ldaa Temp3          ; load a with memory contents
           cmpa MPFLOR_StopAdaptiveWGWhenDeltaMapIsLessThanThis    ; compare a with memory contents (data is 02)
           bcs  LD914          ; branch if lower
           cmpb DECLIM_LowerLimitOnWastegateDutyCycleCorrection    ; compare b with memory contents (data is 01)
           bls  LD914          ; branch if lower or same
           decb            
           bra  BC_UpdateAdaptiveWGControlMemory    ; branch

   LD8F5:  ldaa BaroPressure    ; load a with memory contents
           adda OBCTRL_OverboostControlPoint    ;  (data is 73)
           bcc  LD8FE          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LD8FE:  cmpa Temp2          ; compare a with memory contents
           bhi  LD8C6          ; branch if higher
           ldaa Timer_BoostErrTimer    ; load a with memory contents
           inca                ; increment a
           cmpa INCPT_AdaptiveIncAfterThisTime    ; compare a with memory contents (data is 0c)
           bcs  BC_StoreBoostErrTimer    ; branch if lower
           cmpb DECLIM_LowerLimitOnWastegateDutyCycleCorrection    ; compare b with memory contents (data is 01)
           bls  LD914          ; branch if lower or same
           subb WGDCON_WGDCOffsetNegatve    ; subtract memory contents from b (data is 01)
           bra  BC_UpdateAdaptiveWGControlMemory    ; branch

   LD914:  bra  BC_ClearBoostErrTimer    ; branch

   LD916:  bra  BC_StoreBoostErrTimer    ; branch

BC_BoostIsBelowTarget:
           brclr *BitFlags68, #b68_EndOfBlade, BC_IncrementWGAdaptive    ; branch if bit(s) clear
           bclr *BitFlags68, #b68_EndOfBlade    ; clear bits
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
           bcc  LD938          ; branch if greater or equal
           nega                ; negate a (set high bit)
   LD938:  cmpa MPDEL2_IncCounterWhenDeltaMapBelowThis2    ; compare a with memory contents (data is 09)
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
           bmi  LD978          ; branch if minus(hi bit 1)
           aba                 ; a=a+b
           bcs  BC_LoadMaxWGDutyCycle    ; branch if lower
           cmpa #0xc8          ; compare a with value -11001000-
           bls  BC_IncludeWGDutyCycleFromKnock    ; branch if lower or same
BC_LoadMaxWGDutyCycle:
           ldaa #0xc8          ; load a with value -11001000-
           bra  BC_IncludeWGDutyCycleFromKnock    ; branch

   LD978:  negb            
           sba                 ; subtract (a=a-b)
           bcc  BC_IncludeWGDutyCycleFromKnock    ; branch if greater or equal
           clra                ; a = 0
BC_IncludeWGDutyCycleFromKnock:
           suba WastegateDutyCycleIncreaseFromKnock
           bcc  LD982          ; branch if greater or equal
           clra                ; a = 0
   LD982:  brset *BitFlags66, #b66_OffIdle, LD995    ; branch if bit(s) set
           ldab Timer_BoostTimer    ; load b with memory contents
           beq  LD995          ; branch if equal (zero)
           ldab CurrentWGIncrement    ; load b with memory contents
           cmpb DFWGD2_DefaultWastegateDutyCycle2    ; compare b with memory contents (data is 40)
           bhi  LD995          ; branch if higher
           ldaa WGILML_WGIncrementLimitLo    ; load a with memory contents (data is a0)
   LD995:  staa Temp4          ; store a into memory
           ldaa WastegateDutyCycleIncreaseFromKnock    ; load a with memory contents
           bne  LD9BE          ; branch if not equal (not zero)
           ldaa EngineRpm_HB    ; load a with memory contents
           ldx  #BSTTSH_BoostTargetThresholdForDefaultWGDutyCycle        ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldaa BoostTarget    ; load a with memory contents
           suba BaroPressure
           bcc  LD9AA          ; branch if greater or equal
           clra                ; a = 0
   LD9AA:  cmpa BSTTH2_BoostTargetThresholdForDefaultWGDutyCycle2          ; compare a with memory contents (data is 50)
           bcs  LD9BE          ; branch if lower
           ldaa BoostTarget    ; load a with memory contents
           sba                 ; subtract (a=a-b)
           bcc  LD9B5          ; branch if greater or equal
           clra                ; a = 0
   LD9B5:  cmpa Temp2          ; compare a with memory contents
           bls  LD9BE          ; branch if lower or same
           ldaa DFWGDC_DefaultWastegateDutyCycle          ; load a with memory contents (data is 6e)
           bra  BC_StoreWGDutyCycle    ; branch

   LD9BE:  ldaa Temp4          ; load a with memory contents
BC_StoreWGDutyCycle:
           jsr  NULL_ROUTINE    ; call subroutine
           staa CurrentWastegatePosition    ; store a into memory
           rts                 ; return from subroutine

;           .org   0xe000
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
           jsr  LE21C          ; call subroutine
           ldd  CPU_SerialStatus
           ldx  #0x00c8    ; load index with value

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
           ldx  #AddressTable_SerialIntRoutine    ; load index with value
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

AddressTable_SerialIntRoutine:
	.word	MoveVectorsToRAM
	.word	LE0E7
	.word	Goto_RealTimeInterrupt
	.word	MoveVectorsToRAM
	.word	Goto_RealTimeInterrupt
	.word	LE0E7
	.word	Goto_RealTimeInterrupt
	.word	Goto_RealTimeInterrupt
	.word	Goto_RealTimeInterrupt

MoveVectorsToRAM:
           jsr  HandleSerialStreamandTiming          ; call subroutine
           ldab #0x00          ; load b with value -00000000-
           stab InterruptPointer_MainRealTimeInterrupt          ; store b into memory (data is 7e)
   LE08B:  tba                 ; a = b
           eora InterruptPointer_MainRealTimeInterrupt          ;  (data is 7e)
           anda #0x80          ; AND a with value -10000000-
           bne  LE08B          ; branch if not equal (not zero)
   LE093:  ldd  CPU_TimerCounterRegHigh
           std  CPU_TimerCounterRegHigh_Temp      
   LE099:  ldd  CPU_SerialStatus
           bita #0x20          ;  -00100000-
           bne  LE0A8          ; branch if not equal (not zero)
           jsr  LE21C          ; call subroutine
           jsr  CheckCPUTimerCounterReg          ; call subroutine
           bra  LE099          ; branch

LE0A8:
           cpx  #InterruptPointer_MainRealTimeInterrupt         ;  -10010001 00000000-
           beq  LE0CB          ; branch if equal (zero)
           cpx  #0xb400        ;  -10110100 00000000-
           bne  LE0B5          ; branch if not equal (not zero)
           ldx  #0xb800        ; load index with value
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
           stab InterruptPointer_MainRealTimeInterrupt          ; store b into memory (data is 7e)
   LE0DD:  tba                 ; a = b
           eora InterruptPointer_MainRealTimeInterrupt          ;  (data is 7e)
           anda #0x80          ; AND a with value -10000000-
           bne  LE0DD          ; branch if not equal (not zero)
           bra  Goto_RealTimeInterrupt          ; branch

   LE0E7:  jsr  HandleSerialStreamandTiming          ; call subroutine
   LE0EA:  ldd  CPU_TimerCounterRegHigh
           std  CPU_TimerCounterRegHigh_Temp      

LoopUntilDataIsReady2:
           ldd  CPU_SerialStatus
           bita #0x20          ;  -00100000-
           bne  ReadROMFromB800          ; branch if not equal (not zero)
           jsr  LE21C          ; call subroutine
           jsr  CheckCPUTimerCounterReg          ; call subroutine
           bra  LoopUntilDataIsReady2          ; branch

ReadROMFromB800:
           cpx  #0xb400        ;  -10110100 00000000-
           bne  LE107          ; branch if not equal (not zero)
           ldx  #0xb800        ; load index with value
   LE107:  ldaa 0x00, X        ; load a with memory at index + value
           staa CPU_SerialData
           inx                 ; increment index (x=x+1)
           deY                 ; decrement Y
           beq  Goto_RealTimeInterrupt          ; branch if equal (zero)
           cba             
           beq  LE0EA          ; branch if equal (zero)
   LE114:  ldd  CPU_TimerCounterRegHigh
           std  CPU_TimerCounterRegHigh_Temp      
   LE11A:  jsr  LE21C          ; call subroutine
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
           jsr  LE21C          ; call subroutine
           decb
           bne  LE132          ; branch if not equal (not zero)
           ldd  CPU_SerialStatus
           bra  LE0EA          ; branch

   LE141:  cmpb #0x86          ;  -10000110-
           beq  LE114          ; branch if equal (zero)

Goto_RealTimeInterrupt:
           jsr  LE21C          ; call subroutine
           ldY #0x0100         ; load Y index -00000001 00000000-
   LE14C:  deY                 ; decrement Y
           bne  LE14C          ; branch if not equal (not zero)
           jsr  LE21C          ; call subroutine
           clr  L60E1          ; zero byte at memory location
           ldaa InterruptPointer_MainRealTimeInterrupt          ; load a with memory contents (data is 7e)
           cmpa #0x7e          ; compare a with value -01111110-
           bne  InterruptPointerNoMatch          ; branch if not equal (not zero)
           lds  #0x60ff        ;  -01100000 11111111-
           jmp  InterruptPointer_MainRealTimeInterrupt

InterruptPointerNoMatch:
           jsr  LE21C          ; call subroutine
           ldd  CPU_SerialStatus
           bita #0x20          ;  -00100000-
           beq  InterruptPointerNoMatch          ; branch if equal (zero)
           jmp  CheckSerialCommand

HandleSerialStreamandTiming:
           ldd  CPU_SerialStatus
           bsr  LE191          ; call subroutine
           pshb                ; push b onto stack
           bsr  LE191          ; call subroutine
           pshb                ; push b onto stack
           bsr  LE191          ; call subroutine
           pshb                ; push b onto stack
           bsr  LE191          ; call subroutine
           pshb                ; push b onto stack
           pulx                ; pull index from stack
           cpx  #0xb800        ;  -10111000 00000000-
           bcc  LE18E          ; branch if greater or equal
           cpx  #0xb400        ;  -10110100 00000000-
           bcs  LE18E          ; branch if lower
           pulx                ; pull index from stack
           pulx                ; pull index from stack
           bra  Goto_RealTimeInterrupt          ; branch

   LE18E:  puly                ; pop Y from stack
           rts                 ; return from subroutine

   LE191:  ldd  CPU_TimerCounterRegHigh
           std  CPU_TimerCounterRegHigh_Temp      
LoopUntilDataIsReady:
           ldd  CPU_SerialStatus
           bita #0x20          ;  -00100000-
           bne  ReadSerialData          ; branch if not equal (not zero)
           jsr  LE21C          ; call subroutine
           ldd  CPU_TimerCounterRegHigh
           subd CPU_TimerCounterRegHigh_Temp
           bmi  LE1B7          ; branch if minus(hi bit 1)
           bra  LoopUntilDataIsReady          ; branch

ReadSerialData:
           stab CPU_SerialData    ; store b into memory
   LE1AE:  rts                 ; return from subroutine

CheckCPUTimerCounterReg:
           ldd  CPU_TimerCounterRegHigh
           subd CPU_TimerCounterRegHigh_Temp
           bpl  LE1AE          ; branch if plus (hi bit 0)
   LE1B7:  pulx                ; pull index from stack
           bra  Goto_RealTimeInterrupt          ; branch

;           .org   0xe200
FDRSerialIORoutine:
           stab 0x00, X
           ldY #CurrentWastegatePosition    ; load Y index -00000000 00111010-
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

   LE21C:  psha                ; push a onto stack
           ldaa #0x55          ; load a with value -01010101-
           staa CPU_ArmOCToggleAndResetCopTimerReg
           lsla                ; logical shift left a
           staa CPU_ArmOCToggleAndResetCopTimerReg
           pula                ; pull a from stack
           rts                 ; return from subroutine

IncrementLoopCounters_MM:
           inc  Counter_MainLoop
           bne  LE244          ; branch if not equal (not zero)
           ldaa #0xff          ; load a with value -11111111-
           cmpa KeyOnOrEngineRunningTime    ; compare a with memory contents
           beq  LE236          ; branch if equal (zero)
           inc  KeyOnOrEngineRunningTime
   LE236:  brset *BitFlags6D, #b6d_FuelEngineNotRunning, LE244    ; branch if bit(s) set
           bclr *BitFlags_AIS, #$%00000011    ; clear bits
           cmpa EngineRunningTimeMaxFF    ; compare a with memory contents
           beq  LE244          ; branch if equal (zero)
           inc  EngineRunningTimeMaxFF
   LE244:  ldaa TimerOverflowsBetweenCamPulses    ; load a with memory contents
           cmpa #0x02          ; compare a with value -00000010-
           bcs  LE257          ; branch if lower
           bset *BitFlags6D, #b6d_FuelEngineNotRunning | b6d_Starting | b6d_DisableNormalDwell    ; set bits
           bclr *BitFlags66, #b66_OpenLoop | b66_O2Valid    ; clear bits
           bclr *BitFlags67, #$%00000010    ; clear bits
           ldaa EngineRunningTimeMaxFF    ; load a with memory contents
           staa EngineRunningTimeBeforeStall    ; store a into memory
   LE257:  ldaa Timer_AisChanges    ; load a with memory contents
           inca                ; increment a
           beq  LE25E          ; branch if equal (zero)
           staa Timer_AisChanges    ; store a into memory
   LE25E:  rts                 ; return from subroutine

DRB_SomethingLikeEMR_MM:
           brset *BitFlags6C, #b6c_EMR_1, LE28D    ; branch if bit(s) set
           brclr *BitFlags6C, #$%00000010, LE28D    ; branch if bit(s) clear
           brset *BitFlags6D, #b6d_FuelEngineNotRunning, LE28D    ; branch if bit(s) set
           sei                 ; disable interrupts
           ldaa BitFlags6A     ; load a with memory contents
           bita #b6a_DRBToggle2 | b6a_DRBToggle1          ;  -00000011-
           bne  LE28B          ; branch if not equal (not zero)
           bset *BitFlags6C, #b6c_EMR_1    ; set bits
           ldaa LB613          ; load a with memory contents (data is ff)
           inca                ; increment a
           beq  LE28B          ; branch if equal (zero)
           cmpa #0x07          ; compare a with value -00000111-
           bcs  LE282          ; branch if lower
           bset *BitFlags6C, #$%00001000    ; set bits
   LE282:  staa DRBOffsetStored_LB    ; store a into memory
           ldaa #0x13          ; load a with value -00010011-
           staa DRBOffsetStored_HB    ; store a into memory
           bset *BitFlags6A, #b6a_DRBToggle1    ; set bits
   LE28B:  cli                 ; enable interrupts
           nop                 ; no operation
   LE28D:  sei                 ; disable interrupts
           brset *BitFlags6A, #b6a_DRBToggle1, LE2E7    ; branch if bit(s) set
           ldaa LB7E1          ; load a with memory contents (data is ff)
           coma            
           cmpa LB7E0          ; compare a with memory contents (data is ff)
           beq  LE29D          ; branch if equal (zero)
           ldaa #0x08          ; load a with value -00001000-
   LE29D:  staa BodyComputerBatteryVoltsOutput    ; store a into memory
           brclr *BitFlags6C, #$%00000100, LE2D2    ; branch if bit(s) clear
           ldaa #0x16          ; load a with value -00010110-
           ldab #0x4a          ; load b with value -01001010-
           brclr *BitFlags6A, #b6a_DRBToggle2, LE2CB    ; branch if bit(s) clear
           cmpa DRBOffsetStored_HB    ; compare a with memory contents
           beq  LE2C4          ; branch if equal (zero)
           inca                ; increment a
           cmpa DRBOffsetStored_HB    ; compare a with memory contents
           bne  LE2D2          ; branch if not equal (not zero)
           bset *BitFlags6A, #b6a_DRBToggle1    ; set bits
           bclr *BitFlags6A, #b6a_DRBToggle2    ; clear bits
           bclr *BitFlags6C, #$%00000100    ; clear bits
           ldaa #0x13          ; load a with value -00010011-
           clrb                ; b = 0
           stab Counter_ACControl1    ; store b into memory
           bra  LE2CE          ; branch

   LE2C4:  bset *BitFlags6A, #b6a_DRBToggle1    ; set bits
           inca                ; increment a
           comb            
           bra  LE2CE          ; branch

   LE2CB:  bset *BitFlags6A, #b6a_DRBToggle2 | b6a_DRBToggle1    ; set bits
   LE2CE:  staa DRBOffsetStored_HB    ; store a into memory
           stab DRBOffsetStored_LB    ; store b into memory
   LE2D2:  ldaa LB617          ; load a with memory contents (data is ff)
           coma            
           cmpa LB616          ; compare a with memory contents (data is ff)
           bne  LE2E4          ; branch if not equal (not zero)
           cmpa #0x4a          ; compare a with value -01001010-
           bne  LE2E4          ; branch if not equal (not zero)
           bset *BitFlags6C, #$%00000010    ; set bits
           bra  LE2E7          ; branch

   LE2E4:  bclr *BitFlags6C, #$%00000010    ; clear bits
   LE2E7:  cli                 ; enable interrupts
           brclr *BitFlags6C, #$%00001000, LE311    ; branch if bit(s) clear
           sei                 ; disable interrupts
           brset *BitFlags6A, #b6a_DRBToggle1, LE310    ; branch if bit(s) set
           ldaa #0x16          ; load a with value -00010110-
           ldab #0xee          ; load b with value -11101110-
           brclr *BitFlags6A, #b6a_DRBToggle2, LE309    ; branch if bit(s) clear
           cmpa DRBOffsetStored_HB    ; compare a with memory contents
           bne  LE310          ; branch if not equal (not zero)
           inca                ; increment a
           bset *BitFlags6A, #b6a_DRBToggle1    ; set bits
           bclr *BitFlags6A, #b6a_DRBToggle2    ; clear bits
           bclr *BitFlags6C, #$%00001000    ; clear bits
           bra  LE30C          ; branch

   LE309:  bset *BitFlags6A, #b6a_DRBToggle2 | b6a_DRBToggle1    ; set bits
   LE30C:  staa DRBOffsetStored_HB    ; store a into memory
           stab DRBOffsetStored_LB    ; store b into memory
   LE310:  cli                 ; enable interrupts
   LE311:  rts                 ; return from subroutine

CALCULATE_RPM_SPEED_AND:
           bsr  CalculateEngineRpm    ; call subroutine
           stD *EngineRpm_HB    ; store D to RAM
           brclr *Counter_MainLoop, #$%00000011, LE31B    ; branch if bit(s) clear
           rts                 ; return from subroutine

   LE31B:  ldd  EngineRpm_HB_X
           subd EngineRpm_HB    ; d = d - memory contents
           bcs  LE343          ; branch if lower
           cmpD REVTHR_EngineRPMThresholdForClearingAverageMAP          ; compare D (data is 01)
           bcs  LE343          ; branch if lower
           ldaa CurrentWGIncrement    ; load a with memory contents
           cmpa WGITHR_WGIncrementThresholdForClearingAverageMAP          ; compare a with memory contents (data is 30)
           bcs  LE343          ; branch if lower
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           cmpa SPDTHR_VehicleSpeedThresholdForClearingAverageMAP          ; compare a with memory contents (data is 07)
           bcs  LE343          ; branch if lower
           ldaa MapValue       ; load a with memory contents
           suba MPATHR_MAPThresholdForClearingAverageMAP          ;  (data is 22)
           bcc  LE341          ; branch if greater or equal
           clra                ; a = 0
   LE341:  staa MapAverageValue_HB    ; store a into memory
   LE343:  ldd  EngineRpm_HB    ; load d (a&b) with memory contents
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
           ldX  0, Y           ; load X indexed to Y
           fdiv            
           stx  Temp0          ; store index into memory
           pula                ; pull a from stack
           pulb                ; pull b from stack
           ldX  0, Y           ; load X indexed to Y
           idiv            
           xgDX                ; exchange D and X
           addd Temp0          ; d = d + memory contents
           bcc  LE375          ; branch if greater or equal
           ldd  #0xffff         ; load d (a&b) with value -11111111 11111111-
   LE375:  rts                 ; return from subroutine

; ********************************************************
; Return interpolation value from a table
;    in = b for table X position,
;         x for table location in memory
;    out = both a and b are the Y return value

Lookup4ByteTable:
           ldY #0x0000          ; load Y index -00000000 00000000-
           ldab 0x00, X        ; load b with memory at index + value
           aby                 ; add b to y
           inx                 ; increment index (x=x+1)
           ldab #0x04          ; load b with value -00000100-
           cmpa 0x00, X        ; compare a with memory at index + value
           bhi  LE389          ; branch if higher
   LE385:  clrb                ; b = 0
           bra  LE3A4          ; branch

   LE388:  abx                 ; add b to index
   LE389:  deY                 ; decrement Y
           beq  LE385          ; branch if equal (zero)
           cmpa 0x04, X        ; compare a with memory at index + value
           bcc  LE388          ; branch if greater or equal
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
   LE3A4:  addb 0x01, X        ; add memory at index + value to b
           tba                 ; a = b
           rts                 ; return from subroutine

; ********************************************************
; Scale Y by A, where a=0 = 0.0 and a=255 = 1.0
;*************************************************************
;
; Inputs: A = delta between data and next table point below
; Y = 16-bit slope of line
;
; Outputs:Y = interpolated value
;
; Pimarily used by the fueling system to calculate an
; interpolated point into one of the 5-byte tables. The base
; value of the break point will be added to the returned result
; of this routine to make the new interpolated return value.
;
;*************************************************************

ScaleYbyA:
	psha		    ; save a copy of the factor on the stack
	pshy		    ; save a copy of the slope on the stack
	pulb		    ; put the high byte of the slope into B
	mul		    ; multiply the delta by the slope high byte
	xgDY		    ; store the 16-bit result from D to Y
	pulb		    ; get the fractional byte of the slope
	pula		    ; retrieve stored copy of the delta
	mul		    ; multiply by the fraction, 16-bit result is D
	adca #0x00	    ; round off the result with the carry flag
	tab		    ; move A to B
	aby		    ; Add fraction result B to Y
	rts		    ; return from subroutine

; ********************************************************
; scales the 16-bit value at memory location X (not X itself)
; If a=1 adds 1.0 to scaling

ScaleXbyB_addingA_intoD:
           psha                ; push a onto stack
           tba                 ; a = b
           ldY 0x00, X        ; load Y indexed to X -00000000-
           bsr  ScaleYbyA      ; call subroutine
           pula                ; pull a from stack
           tsta                ; test a
           xgDY                ; exchange D and Y
           beq  LE3CC          ; branch if equal (zero)
           addd 0x00, X    
           bcc  LE3CC          ; branch if greater or equal
           ldd  #0xffff         ; load d (a&b) with value -11111111 11111111-
   LE3CC:  rts                 ; return from subroutine

; ********************************************************
; X points to either the MAP or TPS 4-byte block.
; block of 4 bytes:   x+0: MSB of average value
;                     x+1: LSB of average value (scratch, never used)
;                     x+2: actual value (or faked if limpin)
;                     x+3: scaling factor for leanout or enrichment
; flow:
;       if scaling=0, save value into first byte, zero second, and return
;   otherwise:
;       scale average value by scaling factor


ProcessMapOrTpsBlockData:
	ldaa 0x03,x	    ; load a with current averaging factor
	bne  L1829	    ; branch if not equal (not zero)
	clrb		    ; b = 0
	ldaa 0x02,x	    ; load a with actual MAP or TPS value
	bra  L1830	    ; store average MAP or TPS value, in this case = same as actual, since the averaging factor = 0

L1829:	ldY  0, X	    ; load Y with the current average MAP or TPS
	bsr  ScaleYbyA	    ; scale the average MAP or TPS by the averaging factor
	pshy		    ; push the scaled current average MAP/TPS onto the stack
	ldd  0x02,x	    ; load a with the actual MAP value, b with the averaging factor
	mul		    ; multiply the MAP/TPS by the averaging factor, product ends up in D
	tSY		    ; load Y with the address of the LB of the scaled current average MAP value
	subD  0, Y	    ; subtract scaled current average from the product, delta stays in D
	puly		    ; get scaled current average from the stack (just to clear the stack)
	addd 0x00,x         ; add the scaled current average to the delta
L1830:	std  0x00,x	    ; store the new average to memory
	rts		    ; return from subroutine

DetermineNumberOfOverflowsBetweenCamSensorPulses_MM:
           subd LastCamFallingEdgeTime    ; d = d - memory contents
           staa Temp5          ; store a into memory
           ldaa Counter_TimerPastHalfwayBetweenCamPulses    ; load a with memory contents
           lsrd                ; shift right (d=d/2)
           eorb Temp5      
           bpl  LE3FE          ; branch if plus (hi bit 0)
           ldaa Counter_TimerPastHalfwayBetweenCamPulses    ; load a with memory contents
           inca                ; increment a
           beq  LE3FE          ; branch if equal (zero)
           staa Counter_TimerPastHalfwayBetweenCamPulses    ; store a into memory
   LE3FE:  ldaa Counter_TimerPastHalfwayBetweenCamPulses    ; load a with memory contents
           lsra            
           cmpa TimerOverflowsBetweenCamPulses    ; compare a with memory contents
           bcs  LE407          ; branch if lower
           staa TimerOverflowsBetweenCamPulses    ; store a into memory
   LE407:  rts                 ; return from subroutine

GetControlFeedback_DetermineIfShutdownRequired_MM:
           ldab SwitchPortAccessReg1    ; load b with memory contents
           bitb #0x40          ;  -01000000-
           bne  LE413          ; branch if not equal (not zero)
   LE40F:  clr  CountdownTimerFromKeyOn    ; zero byte at memory location
           rts                 ; return from subroutine

   LE413:  ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           bne  LE421          ; branch if not equal (not zero)
           ldaa #0x17          ; load a with value -00010111-
           ldab TimerOverflowsBetweenCamPulses    ; load b with memory contents
           cmpb #0x04          ;  -00000100-
           bcs  LE421          ; branch if lower
           ldaa #0x09          ; load a with value -00001001-
   LE421:  deca                ; decrement a
           beq  LE427          ; branch if equal (zero)
           staa CountdownTimerFromKeyOn    ; store a into memory
           rts                 ; return from subroutine

   LE427:  sei                 ; disable interrupts
           bset *BitFlags6E, #$%00000100    ; set bits
           ldaa #0x7c          ; load a with value -01111100-
           ldab #0x02          ; load b with value -00000010-
           jsr  SetPIAOutputBits    ; call subroutine
           jsr  OCToggleAndResetCopTimer    ; call subroutine
           jsr  CaculateChecksum    ; call subroutine
           bsr  OCToggleAndResetCopTimer    ; call subroutine
           jsr  CountRamValuesFrom05to3a    ; call subroutine
           stD *L0003          ; store D to RAM
           ldaa #0x20          ; load a with value -00100000-
   LE441:  ldab SwitchPortAccessReg1    ; load b with memory contents
           bitb #0x40          ;  -01000000-
           beq  LE40F          ; branch if equal (zero)
           deca                ; decrement a
           bne  LE441          ; branch if not equal (not zero)
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
   LE484:  ldab SwitchPortAccessReg1    ; load b with memory contents
           bitb #0x40          ;  -01000000-
           beq  LE49A          ; branch if equal (zero)
           ldd  #0x55aa        ; load d (a&b) with value -01010101 10101010-
           staa CPU_ArmOCToggleAndResetCopTimerReg
           stab CPU_ArmOCToggleAndResetCopTimerReg    ; store b into memory
           jmp  LE484      

   LE497:  jmp  LE484      

   LE49A:  ldaa #0x40          ; load a with value -01000000-
   LE49C:  ldab SwitchPortAccessReg1    ; load b with memory contents
           bitb #0x40          ;  -01000000-
           bne  LE484          ; branch if not equal (not zero)
           deca                ; decrement a
           bne  LE49C          ; branch if not equal (not zero)
           jmp  Interrupt_SerialCommunications

OCToggleAndResetCopTimer:
           pshx                ; pull index from stack
           ldd  #0x5802        ; load d (a&b) with value -01011000 00000010-
           jsr  SetPIAOutputBits    ; call subroutine
           ldaa #0x10          ; load a with value -00010000-
   LE4B2:  deca                ; decrement a
           bne  LE4B2          ; branch if not equal (not zero)
           ldd  #0x5c02        ; load d (a&b) with value -01011100 00000010-
           jsr  SetPIAOutputBits    ; call subroutine
           pulx                ; pull index from stack
           ldd  #0x55aa        ; load d (a&b) with value -01010101 10101010-
           staa CPU_ArmOCToggleAndResetCopTimerReg
           stab CPU_ArmOCToggleAndResetCopTimerReg    ; store b into memory
           rts                 ; return from subroutine

SetPIAOutputBits:
           ldY #0x0004          ; load Y index -00000000 00000100-
           ldx  #CPU_PortD     ; load index with value
           sei                 ; disable interrupts
   LE4CE:  bclr  0, X, #$%00100000    ; bit clear
           cmpb CPU_SerialPeripheralStatus    ; compare b with memory contents
           staa CPU_SerialPeripheralDataIO
           pshb                ; push b onto stack
           psha                ; push a onto stack
           mul                 ; multiply (d=a*b)
           pula                ; pull a from stack
           pulb                ; pull b from stack
           brset 33, X, #$%10000000, LE4E9    ; branch if bit(s) set
   LE4E0:  bset  0, X, #$%00100000    ; bit set
           deY                 ; decrement Y
           bne  LE4CE          ; branch if not equal (not zero)
           bra  LE503          ; branch

   LE4E9:  psha                ; push a onto stack
           lsra            
           lsra            
           eora CPU_SerialPeripheralDataIO
           bita #0x3e          ;  -00111110-
           pula                ; pull a from stack
           bne  LE4E0          ; branch if not equal (not zero)
           stab CPU_SerialPeripheralDataIO    ; store b into memory
           pshb                ; push b onto stack
           psha                ; push a onto stack
           mul                 ; multiply (d=a*b)
           pula                ; pull a from stack
           pulb                ; pull b from stack
           brclr 33, X, #$%10000000, LE503    ; branch if bit(s) clear
           ldab CPU_SerialPeripheralDataIO    ; load b with memory contents
   LE503:  bset  0, X, #$%00100000    ; bit set
           brset *BitFlags6E, #$%00000100, LE50B    ; branch if bit(s) set
           cli                 ; enable interrupts
   LE50B:  tba                 ; a = b
           rts                 ; return from subroutine

EmmissionMaintenanceRemider1_MM:
           ldaa CONFIG2_ConfigurationFlags2    ; load a with memory contents (data is c7)
           bita #0x08          ;  -00001000-
           bne  LE559          ; branch if not equal (not zero)
           bset *PIA2_Buffer, #pi2_WGSol    ; set bits
           ldaa CPU_EEPROMControlReg    ; load a with memory contents
           bne  LE522          ; branch if not equal (not zero)
           ldd  LB610          ;  (data is ffff)
           subd #0x5aa5        ;  -01011010 10100101-
   LE522:  brclr *BitFlags6D, #b6d_FuelEngineNotRunning, LE528    ; branch if bit(s) clear
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
   LE528:  bne  LE52D          ; branch if not equal (not zero)
           bclr *PIA2_Buffer, #pi2_WGSol    ; clear bits
   LE52D:  sei                 ; disable interrupts
           brset *BitFlags6A, #b6a_DRBToggle1, LE558    ; branch if bit(s) set
           brset *b5D_IPL2, #$%00000001, LE55A    ; branch if bit(s) set
           brclr *BitFlags6A, #b6a_Cruise1, LE558    ; branch if bit(s) clear
           bset *BitFlags6A, #b6a_DRBToggle1    ; set bits
           cli                 ; enable interrupts
           ldaa #0x10          ; load a with value -00010000-
           ldab #0x5a          ; load b with value -01011010-
           brclr *BitFlags6A, #b6a_DRBToggle2, LE551    ; branch if bit(s) clear
           cmpa DRBOffsetStored_HB    ; compare a with memory contents
           bne  LE5B0          ; branch if not equal (not zero)
           inca                ; increment a
           comb            
           bclr *BitFlags6A, #b6a_Cruise1 | b6a_DRBToggle2    ; clear bits
           bra  LE554          ; branch

   LE551:  bset *BitFlags6A, #b6a_DRBToggle2    ; set bits
   LE554:  staa DRBOffsetStored_HB    ; store a into memory
           stab DRBOffsetStored_LB    ; store b into memory
   LE558:  cli                 ; enable interrupts
   LE559:  rts                 ; return from subroutine

   LE55A:  bset *BitFlags6A, #b6a_DRBToggle1    ; set bits
           cli                 ; enable interrupts
           brset *BitFlags6A, #b6a_DRBToggle2, LE5C8    ; branch if bit(s) set
           ldx  #ErrorBitRegisterStored3    ; load index with value
           ldab #0x30          ; load b with value -00110000-
   LE567:  ldaa 0x00, X        ; load a with memory at index + value
           beq  LE574          ; branch if equal (zero)
           cba             
           beq  LE5AD          ; branch if equal (zero)
           dex                 ; decrement index (x=x-1)
           cpx  #ErrorBitRegister0    ;  -00000000 00011111-
           bcc  LE567          ; branch if greater or equal
   LE574:  clra                ; a = 0
           clrb                ; b = 0
           stD *Temp0          ; store D to RAM
           ldx  #LB600         ; load index with value
   LE57B:  ldd  0x02, X    
           cpx  #0xb60e        ;  -10110110 00001110-
           bne  LE585          ; branch if not equal (not zero)
           ldd  LB600          ;  (data is ffff)
   LE585:  subd 0x00, X    
           subd #0x0001         ;  -00000000 00000001-
           bne  LE59A          ; branch if not equal (not zero)
           incb            
           addd 0x00, X    
           cmpD Temp0          ; compare D
           bcs  LE59A          ; branch if lower
           stD *Temp0          ; store D to RAM
           xgDX                ; exchange D and X
           stab DRBOffsetStored_HB    ; store b into memory
           xgDX                ; exchange D and X
   LE59A:  inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
           cpx  #LB610         ;  -10110110 00010000-
           bne  LE57B          ; branch if not equal (not zero)
           ldx  Temp0      
           bne  LE5B4          ; branch if not equal (not zero)
           ldd  #0x3003        ; load d (a&b) with value -00110000 00000011-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LE5B0          ; branch if greater or equal
   LE5AD:  bclr *b5D_IPL2, #$%00000001    ; clear bits
   LE5B0:  bclr *BitFlags6A, #b6a_DRBToggle1    ; clear bits
           rts                 ; return from subroutine

   LE5B4:  ldab DRBOffsetStored_HB    ; load b with memory contents
           addb #0x04          ;  -00000100-
           cmpb #0x10          ;  -00010000-
           blt  LE5BE          ; branch if less
           subb #0x10          ;  -00010000-
   LE5BE:  stab DRBOffsetStored_HB    ; store b into memory
           bsr  LE5F3          ; call subroutine
           staa DRBOffsetStored_LB    ; store a into memory
           bset *BitFlags6A, #b6a_DRBToggle2    ; set bits
           rts                 ; return from subroutine

   LE5C8:  ldab DRBOffsetStored_HB    ; load b with memory contents
           cmpb #0x0e          ;  -00001110-
           bhi  LE5B0          ; branch if higher
           cmpb #0x00          ;  -00000000-
           bcs  LE5B0          ; branch if lower
           bsr  LE5F3          ; call subroutine
           stab DRBOffsetStored_LB    ; store b into memory
           inc  DRBOffsetStored_HB
           bclr *b5D_IPL2, #$%00000001    ; clear bits
           bclr *BitFlags6A, #b6a_DRBToggle2    ; clear bits
           xgDX                ; exchange D and X
           cpx  #0x1c9c        ;  -00011100 10011100-
           beq  LE5EF          ; branch if equal (zero)
           cpx  #0x2757        ;  -00100111 01010111-
           beq  LE5EF          ; branch if equal (zero)
           cpx  #0x3938        ;  -00111001 00111000-
           bne  LE5F2          ; branch if not equal (not zero)
   LE5EF:  bset *BitFlags6A, #b6a_Cruise1    ; set bits
   LE5F2:  rts                 ; return from subroutine

   LE5F3:  ldx  #LB600         ; load index with value
           subb #0x02          ;  -00000010-
           cmpb #0x00          ;  -00000000-
           bge  LE5FE          ; branch if greater or equal
           ldab #0x0e          ; load b with value -00001110-
   LE5FE:  abx                 ; add b to index
           ldx  0x00, X    
           inx                 ; increment index (x=x+1)
           bne  LE605          ; branch if not equal (not zero)
           dex                 ; decrement index (x=x-1)
   LE605:  xgDX                ; exchange D and X
           rts                 ; return from subroutine

EmmissionMaintenanceRemider2_MM:
           brset *Counter_MainLoop, #$%00000001, LE678    ; branch if bit(s) set
           brclr *BitFlags6A, #b6a_DRBToggle1, LE674    ; branch if bit(s) clear
           ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           beq  LE61A          ; branch if equal (zero)
           ldab #0x03          ; load b with value -00000011-
           cba             
           bcc  LE61A          ; branch if greater or equal
           stab CountdownTimerFromKeyOn    ; store b into memory
   LE61A:  ldaa CPU_EEPROMControlReg    ; load a with memory contents
           clrb                ; b = 0
           stab CPU_EEPROMControlReg    ; store b into memory
           ldx  #LB600         ; load index with value
           ldab DRBOffsetStored_HB    ; load b with memory contents
           abx                 ; add b to index
           tab                 ; b = a
           ldaa 0x00, X        ; load a with memory at index + value
           cmpa DRBOffsetStored_LB    ; compare a with memory contents
           beq  LE664          ; branch if equal (zero)
           cmpb #0x03          ;  -00000011-
           beq  LE639          ; branch if equal (zero)
           bcs  LE64A          ; branch if lower
           ldab DRBOffsetStored_LB    ; load b with memory contents
           inca                ; increment a
           beq  LE65A          ; branch if equal (zero)
   LE639:  brset *b5D_IPL2, #b5d_EMRLight, LE664    ; branch if bit(s) set
           ldd  #0x318a        ; load d (a&b) with value -00110001 10001010-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LE64A          ; branch if greater or equal
           bset *b5D_IPL2, #b5d_EMRLight    ; set bits
           bra  LE664          ; branch

   LE64A:  ldx  #LB600         ; load index with value
           ldab DRBOffsetStored_HB    ; load b with memory contents
           abx                 ; add b to index
           ldab DRBOffsetStored_LB    ; load b with memory contents
           tba                 ; a = b
           anda 0x00, X    
           sba                 ; subtract (a=a-b)
           beq  LE65A          ; branch if equal (zero)
           ldaa #0x16          ; load a with value -00010110-
   LE65A:  oraa #0x02          ;  -00000010-
           staa CPU_EEPROMControlReg
           stab 0x00, X    
           inca                ; increment a
           bra  LE675          ; branch

   LE664:  bclr *BitFlags6A, #b6a_DRBToggle1    ; clear bits
           brset *BitFlags6A, #b6a_DRBToggle2, LE674    ; branch if bit(s) set
           ldaa CountdownTimerFromKeyOn    ; load a with memory contents
           suba #0x03          ;  -00000011-
           bne  LE674          ; branch if not equal (not zero)
           inca                ; increment a
           staa CountdownTimerFromKeyOn    ; store a into memory
   LE674:  clra                ; a = 0
   LE675:  staa CPU_EEPROMControlReg
   LE678:  rts                 ; return from subroutine

ExhGasRecirc_MM:
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 97)
           bita #0x40          ;  -01000000-
           bne  LE683          ; branch if not equal (not zero)
           jmp  LE7C7      

   LE683:  brclr *BitFlags6D, #b6d_FuelEngineNotRunning, LE696    ; branch if bit(s) clear
           ldaa CoolantTemp    ; load a with memory contents
           cmpa EGR27_ExhGasRecircConstFromCoolantTemp    ; compare a with memory contents (data is ff)
           bcc  LE693          ; branch if greater or equal
           bclr *EGRVar2, #$%00100000    ; clear bits
           bra  LE696          ; branch

   LE693:  bset *EGRVar2, #$%00100000    ; set bits
   LE696:  ldab BitFlags66     ; load b with memory contents
           bitb #b66_PTEisMaxed | b66_FullThrottle          ;  -00000011-
           bne  LE6DD          ; branch if not equal (not zero)
           ldab BaroPressure    ; load b with memory contents
           brset *PIA2_Buffer, #pi2_EGRSol, LE6A5    ; branch if bit(s) set
           subb EGR25_ExhGasRecircConstFromBaro1    ; subtract memory contents from b (data is 00)
   LE6A5:  subb EGR26_ExhGasRecircConstFromBaro2    ; subtract memory contents from b (data is 00)
           cmpb MapValue   
           bcs  LE6DD          ; branch if lower
           brset *EGRVar2, #$%00100000, LE6B9    ; branch if bit(s) set
           brset *BitFlags67, #b67_OpenLoop, LE6DD    ; branch if bit(s) set
           bset *EGRVar2, #$%00100000    ; set bits
           bra  LE6C1          ; branch

   LE6B9:  brset *BitFlags66, #b66_O2Valid, LE6C1    ; branch if bit(s) set
           ldab Timer_CLTIME_ClosedLoopTimer    ; load b with memory contents
           bne  LE6DD          ; branch if not equal (not zero)
   LE6C1:  brclr *BitFlags66, #b66_OffIdle, LE6DD    ; branch if bit(s) clear
           ldaa EGR21_ExhGasRecircConstFromRPM1    ; load a with memory contents (data is fa)
           ldab EGR23_ExhGasRecircConstFromMAP1    ; load b with memory contents (data is fa)
           brset *PIA2_Buffer, #pi2_EGRSol, LE6D5    ; branch if bit(s) set
           adda EGR22_ExhGasRecircConstFromRPM2    ;  (data is 01)
           addb EGR24_ExhGasRecircConstFromMAP2    ;  (data is 03)
   LE6D5:  cmpa EngineRpm_HB    ; compare a with memory contents
           bls  LE6E3          ; branch if lower or same
           cmpb MapValue   
           bcs  LE6E3          ; branch if lower
   LE6DD:  bset *EGRVar2, #$%00010000    ; set bits
           jmp  EGR_SetEGRtoOff

   LE6E3:  ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa EGR9_ExhGasRecircConstFromTimeEngRunning9    ; compare a with memory contents (data is ff)
           bcs  LE6FA          ; branch if lower
           brset *EGRVar2, #$%01000000, LE6FA    ; branch if bit(s) set
           brset *EGRVar2, #$%00010000, LE6FA    ; branch if bit(s) set
           brclr *BitFlags66, #b66_O2Valid, LE6FA    ; branch if bit(s) clear
           brclr *BitFlags67, #b67_StayOpenLoop, LE6FD    ; branch if bit(s) clear
   LE6FA:  jmp  EGR_ResetEGRVars

   LE6FD:  ldd  IPLMSK_PowerLossLightMask    ;  (data is ff38)
           bita b5C_IPL1   
           bne  EGR_ResetEGRVars    ; branch if not equal (not zero)
           bitb b5D_IPL2   
           bne  EGR_ResetEGRVars    ; branch if not equal (not zero)
           brclr *PIA1_Buffer, #pi1_PurgeSol, EGR_ResetEGRVars    ; branch if bit(s) clear
           ldaa BaroPressure    ; load a with memory contents
           suba MapValue   
           bcs  EGR_ResetEGRVars    ; branch if lower
           cmpa EGR2_ExhGasRecircConstFromMAPBelowBaro    ; compare a with memory contents (data is ff)
           bcs  EGR_ResetEGRVars    ; branch if lower
           ldx  ErrorCodeBufferHB
           brset *EGRVar2, #$%10000000, LE790    ; branch if bit(s) set
           cpx  EGR1_ExhGasRecircConst    ;  (data is ffff)
           bhi  LE782          ; branch if higher
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
           cmpa EGR3_ExhGasRecircConst3    ; compare a with memory contents (data is ff)
           bge  EGR_ResetEGRVars    ; branch if greater or equal
           ldx  ErrorCodeBufferHB
           inx                 ; increment index (x=x+1)
           stx  ErrorCodeBufferHB
           ldab EGR8_ExhGasRecircConst8    ; load b with memory contents (data is ff)
           suba EGR_Temp_1 
           bvc  LE761          ; branch if overflow
           bmi  LE763          ; branch if minus(hi bit 1)
   LE754:  nega                ; negate a (set high bit)
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           nega                ; negate a (set high bit)
   LE759:  adda EGR_Temp_1 
           staa EGR_Temp_1 
           bra  LE77F          ; branch

   LE761:  bmi  LE754          ; branch if minus(hi bit 1)
   LE763:  mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           bra  LE759          ; branch

EGR_CheckHiLoLimits:
           cmpa 0x00, X        ; compare a with memory at index + value
           bcs  LE771          ; branch if lower
           cmpa 0x01, X        ; compare a with memory at index + value
           bhi  LE771          ; branch if higher
           rts                 ; return from subroutine

   LE771:  pulx                ; pull index from stack
EGR_ResetEGRVars:
           clra                ; a = 0
           clrb                ; b = 0
           std  ErrorCodeBufferHB
           bclr *EGRVar2, #$%10010000    ; clear bits
           ldaa Counter_O2SensorFeedbackCount_Signed    ; load a with memory contents
           staa EGR_Temp_1 
   LE77F:  jmp  EGR_SetEGRtoOn

   LE782:  ldx  #0x0000         ; load index with value
           bset *EGRVar2, #$%10000000    ; set bits
           ldaa EGR_Temp_1     ; load a with memory contents
           staa EGR_Temp_2 
           bra  LE795          ; branch

   LE790:  cpx  EGR6_ExhGasRecircConst6    ;  (data is ffff)
           bcc  LE7D5          ; branch if greater or equal
   LE795:  inx                 ; increment index (x=x+1)
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
           ble  LE803          ; branch if less or equal
           staa EGR_Temp_2 
           suba EGR_Temp_1 
           staa EGR_Temp_3 
           cmpa EGR7_ExhGasRecircConst7    ; compare a with memory contents (data is ff)
           bcs  LE803          ; branch if lower
   LE7C7:  clr  ErrorCodeCounter    ; zero byte at memory location
           bset *EGRVar2, #$%01000000    ; set bits
           bclr *EGRVar2, #$%10000000    ; clear bits
           bclr *b5D_IPL2, #b5d_EGRSolFault    ; clear bits
           bra  EGR_SetEGRtoOn    ; branch

   LE7D5:  clra                ; a = 0
           clrb                ; b = 0
           std  ErrorCodeBufferHB
           ldaa ErrorCodeCounter    ; load a with memory contents
           inca                ; increment a
           staa ErrorCodeCounter
           cmpa EGR4_ExhGasRecircConst4    ; compare a with memory contents (data is ff)
           bcs  LE7EF          ; branch if lower
           ldd  #0x2e01        ; load d (a&b) with value -00101110 00000001-
           jsr  ThrowNonCriticalError    ; call subroutine
           bset *b5D_IPL2, #b5d_EGRSolFault    ; set bits
   LE7EF:  ldab EGRVar2        ; load b with memory contents
           andb #0x7f          ;  -01111111-
           tba                 ; a = b
           inca                ; increment a
           anda #0x0f          ; AND a with value -00001111-
           beq  LE7FF          ; branch if equal (zero)
           incb            
           cmpa EGR5_ExhGasRecircConst5    ; compare a with memory contents (data is ff)
           bcs  LE801          ; branch if lower
   LE7FF:  orab #0x40          ;  -01000000-
   LE801:  stab EGRVar2        ; store b into memory
   LE803:  brclr *EGRVar2, #$%10000000, EGR_SetEGRtoOn    ; branch if bit(s) clear
EGR_SetEGRtoOff:
           bclr *PIA2_Buffer, #pi2_EGRSol    ; clear bits
           rts                 ; return from subroutine

EGR_SetEGRtoOn:
           bset *PIA2_Buffer, #pi2_EGRSol    ; set bits
           rts                 ; return from subroutine

BYTE_MODE_SERIAL_CODE_DOWNLOAD_ROUTINE:
           brclr *DRBSerialMode, #bbe_ByteMode, LE829    ; branch if bit(s) clear
           ldab CPU_SerialData    ; load b with memory contents
           ldaa CPU_SerialStatus    ; load a with memory contents
           bita #0x20          ;  -00100000-
           bne  LE82A          ; branch if not equal (not zero)
           ldaa FDRVar0        ; load a with memory contents
           cmpa #0xfc          ; compare a with value -11111100-
           bne  LE829          ; branch if not equal (not zero)
   LE823:  bclr *DRBSerialMode, #bbe_ByteMode    ; clear bits
           clr  FDRVar0        ; zero byte at memory location
   LE829:  rts                 ; return from subroutine

   LE82A:  ldaa FDRVar0        ; load a with memory contents
           bita #0x03          ;  -00000011-
           bne  LE881          ; branch if not equal (not zero)
           cmpb #0xf8          ;  -11111000-
           bcs  LE823          ; branch if lower
           ldaa FDRVar0        ; load a with memory contents
           bne  LE840          ; branch if not equal (not zero)
           cmpb #0xf8          ;  -11111000-
           bne  LE823          ; branch if not equal (not zero)
           ldaa #0x80          ; load a with value -10000000-
           bra  LE856          ; branch

   LE840:  cmpa #0x80          ; compare a with value -10000000-
           bne  LE84C          ; branch if not equal (not zero)
           cmpb #0xf9          ;  -11111001-
           bne  LE823          ; branch if not equal (not zero)
           ldaa #0xc0          ; load a with value -11000000-
           bra  LE856          ; branch

   LE84C:  cmpa #0xc0          ; compare a with value -11000000-
           bne  LE85D          ; branch if not equal (not zero)
           cmpb #0xfb          ;  -11111011-
           bne  LE823          ; branch if not equal (not zero)
           ldaa #0xe0          ; load a with value -11100000-
   LE856:  staa FDRVar0        ; store a into memory
   LE858:  jsr  LE956          ; call subroutine
   LE85B:  pulx                ; pull index from stack
           rts                 ; return from subroutine

   LE85D:  cmpa #0xe0          ; compare a with value -11100000-
           bne  LE823          ; branch if not equal (not zero)
           ldaa #0x02          ; load a with value -00000010-
           cmpb #0xf8          ;  -11111000-
           beq  LE856          ; branch if equal (zero)
           ldaa #0x01          ; load a with value -00000001-
           cmpb #0xf9          ;  -11111001-
           beq  LE856          ; branch if equal (zero)
           cmpb #0xfb          ;  -11111011-
           bne  LE823          ; branch if not equal (not zero)
           ldaa #0x05          ; load a with value -00000101-
           pshb                ; push b onto stack
           ldab EngineRpm_HB    ; load b with memory contents
           pulb                ; pull b from stack
           beq  LE856          ; branch if equal (zero)
   LE879:  ldab #0x17          ; load b with value -00010111-
           jsr  LE956          ; call subroutine
   LE87E:  pulx                ; pull index from stack
           bra  LE823          ; branch

   LE881:  bita #0x01          ;  -00000001-
           beq  LE8E6          ; branch if equal (zero)
           lsla                ; logical shift left a
           bcs  LE8D2          ; branch if lower
           lsla                ; logical shift left a
           bcs  LE8A7          ; branch if lower
           lsla                ; logical shift left a
           bcs  LE89F          ; branch if lower
           bmi  LE899          ; branch if minus(hi bit 1)
           stab FDRVar4        ; store b into memory
           jsr  LE946          ; call subroutine
           ldaa #0x10          ; load a with value -00010000-
           bra  LE8CD          ; branch

   LE899:  stab FDRVar3        ; store b into memory
           ldaa #0x20          ; load a with value -00100000-
           bra  LE8CD          ; branch

   LE89F:  ldx  FDRVar3    
           ldab 0x00, X        ; load b with memory at index + value
           ldaa #0x40          ; load a with value -01000000-
           bra  LE8CD          ; branch

   LE8A7:  cmpb #0xfe          ;  -11111110-
           beq  LE8B7          ; branch if equal (zero)
   LE8AB:  clr  FDRVar0        ; zero byte at memory location
           cmpb #0x1b          ;  -00011011-
           bne  LE85B          ; branch if not equal (not zero)
           bset *DRBSerialMode, #bbe_ByteMode    ; set bits
           bra  LE858          ; branch

   LE8B7:  ldx  FDRVar3    
           cpx  #CONFIG_ConfigurationFlags    ;  -10000000 00001100-
           beq  LE879          ; branch if equal (zero)
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa #0x5e          ; compare a with value -01011110-
           bcc  LE879          ; branch if greater or equal
           brclr *FDRVar0, #$%00000100, LE8CB    ; branch if bit(s) clear
           tsta                ; test a
           bne  LE879          ; branch if not equal (not zero)
   LE8CB:  ldaa #0x80          ; load a with value -10000000-
   LE8CD:  oraa FDRVar0        ; OR a with memory contents
           jmp  LE856      

   LE8D2:  ldaa EngineRpm_HB    ; load a with memory contents
           beq  LE8DD          ; branch if equal (zero)
           stab FDRVar2        ; store b into memory
           bset *FDRVar0, #$%00001000    ; set bits
           pulx                ; pull index from stack
           rts                 ; return from subroutine

   LE8DD:  sei                 ; disable interrupts
           ldx  FDRVar3    
           jsr  FDRSerialIORoutine          ; call subroutine
           cli                 ; enable interrupts
           bra  LE87E          ; branch

   LE8E6:  ldab CPU_SerialData    ; load b with memory contents
           ldaa CPU_SerialStatus    ; load a with memory contents
           ldaa FDRVar0        ; load a with memory contents
           lsla                ; logical shift left a
           bcs  LE923          ; branch if lower
           lsla                ; logical shift left a
           bcs  LE918          ; branch if lower
           lsla                ; logical shift left a
           bcs  LE912          ; branch if lower
           lsla                ; logical shift left a
           bcs  LE909          ; branch if lower
           lsla                ; logical shift left a
           bcs  LE903          ; branch if lower
           stab FDRVar2        ; store b into memory
           ldaa #0x08          ; load a with value -00001000-
           bra  LE8CD          ; branch

   LE903:  stab FDRVar1        ; store b into memory
           ldaa #0x10          ; load a with value -00010000-
           bra  LE8CD          ; branch

   LE909:  stab FDRVar4        ; store b into memory
           jsr  LE946          ; call subroutine
           ldaa #0x20          ; load a with value -00100000-
           bra  LE8CD          ; branch

   LE912:  stab FDRVar3        ; store b into memory
           ldaa #0xc0          ; load a with value -11000000-
           bra  LE8CD          ; branch

   LE918:  cmpb #0xfd          ;  -11111101-
           beq  LE91F          ; branch if equal (zero)
           jmp  LE8AB      

   LE91F:  ldaa #0x80          ; load a with value -10000000-
           bra  LE8CD          ; branch

   LE923:  ldx  FDRVar3    
           ldY FDRVar1         ; load Y index
           ldaa 0x00, X        ; load a with memory at index + value
           staa CPU_SerialData
           inx                 ; increment index (x=x+1)
           deY                 ; decrement Y
           bne  LE937          ; branch if not equal (not zero)
           ldaa #0xfc          ; load a with value -11111100-
           staa FDRVar0        ; store a into memory
   LE936:  rts                 ; return from subroutine

   LE937:  stx  FDRVar3        ; store index into memory
           stY FDRVar1         ; store Y index
           cba             
           bne  LE941          ; branch if not equal (not zero)
           pulx                ; pull index from stack
           rts                 ; return from subroutine

   LE941:  bclr *FDRVar0, #$%10000000    ; clear bits
           pulx                ; pull index from stack
           rts                 ; return from subroutine

   LE946:  ldx  FDRVar3    
           cpx  #0xb400        ;  -10110100 00000000-
           bcs  LE936          ; branch if lower
           cpx  #0xb7ff        ;  -10110111 11111111-
           bhi  LE936          ; branch if higher
           pulx                ; pull index from stack
           jmp  LE87E      

   LE956:  ldaa CPU_SerialStatus    ; load a with memory contents
           ldaa CPU_SerialData    ; load a with memory contents
           stab CPU_SerialData    ; store b into memory
           rts                 ; return from subroutine

UpdateCylTrimCounters_MM:
           clr  Temp0          ; zero byte at memory location
           brclr *b5C_IPL1, #b5c_TpsBadSignal, LE971    ; branch if bit(s) clear
           bclr *Counter_CylTrim1, #$%11111111    ; clear bits
           bclr *Counter_CylTrim2, #$%11111111    ; clear bits
           bclr *BitFlags6B, #$%00010000    ; clear bits
   LE970:  rts                 ; return from subroutine

   LE971:  brset *BitFlags6D, #b6d_FuelEngineNotRunning, LE970    ; branch if bit(s) set
           brset *b5C_IPL1, #b5c_MapBadSignal, LE9D6    ; branch if bit(s) set
           brset *b5C_IPL1, #b5c_MapStuck, LE9D6    ; branch if bit(s) set
           brset *BitFlags66, #b66_OffIdle, LE9D6    ; branch if bit(s) set
           ldaa MAPOffsetForCylTrim    ; load a with memory contents
           beq  LE9D6          ; branch if equal (zero)
           ldaa MapValue       ; load a with memory contents
           suba MAPOffsetForCylTrim
           bcs  LE9C3          ; branch if lower
           suba OFSMID_OffsetForMAPOverIdle    ;  (data is fe)
           bcs  LE9BE          ; branch if lower
           ldaa Counter_CylTrim1    ; load a with memory contents
           cmpa #0x80          ; compare a with value -10000000-
           bcc  LE9B3          ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x0f          ;  -00001111-
           bne  LE9D9          ; branch if not equal (not zero)
           inca                ; increment a
           staa Counter_CylTrim1    ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #CTLMC1_CylinderTrimCounter1LimitFromCoolantTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           cmpa Counter_CylTrim1    ; compare a with memory contents
           bhi  LE9D9          ; branch if higher
           bset *Counter_CylTrim1, #$%10000000    ; set bits
           bset *BitFlags6B, #$%00010000    ; set bits
   LE9B3:  brclr *Counter_CylTrim1, #$%10000000, LE9D9    ; branch if bit(s) clear
           ldaa #0x41          ; load a with value -01000001-
           jsr  LEA34          ; call subroutine
           bra  LE9D9          ; branch

   LE9BE:  adda INCMID_IncrementForMAPOverIdle    ;  (data is 02)
           bpl  LE9B3          ; branch if plus (hi bit 0)
   LE9C3:  inc  Temp0      
           brclr *BitFlags67, #b67_FallToIdle, LE9D6    ; branch if bit(s) clear
           clr  Temp0          ; zero byte at memory location
           bclr *Counter_CylTrim2, #$%10000000    ; clear bits
           bclr *Counter_CylTrim1, #$%10000000    ; clear bits
           bclr *BitFlags6B, #$%00010000    ; clear bits
   LE9D6:  bclr *Counter_CylTrim1, #$%01111111    ; clear bits
   LE9D9:  brset *BitFlags6B, #$%00100000, LEA30    ; branch if bit(s) set
           brset *BitFlags66, #b66_OffIdle, LEA30    ; branch if bit(s) set
           brclr *TargetIdleSpeedHB, #$%11111111, LEA30    ; branch if bit(s) clear
           brset *BitFlags67, #b67_FallToIdle, LEA33    ; branch if bit(s) set
           ldaa EngineRpm_HB    ; load a with memory contents
           suba TargetIdleSpeedHB
           bcs  LEA23          ; branch if lower
           suba OFSRID_OffsetForRPMOverIdle    ;  (data is d0)
           bcs  LEA1E          ; branch if lower
           ldaa Counter_CylTrim2    ; load a with memory contents
           cmpa #0x80          ; compare a with value -10000000-
           bcc  LEA15          ; branch if greater or equal
           ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x0f          ;  -00001111-
           bne  LEA33          ; branch if not equal (not zero)
           inca                ; increment a
           staa Counter_CylTrim2    ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #CTLMC2_CylinderTrimCounter2LimitFromCoolantTemp    ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           cmpa Counter_CylTrim2    ; compare a with memory contents
           bhi  LEA33          ; branch if higher
           bset *Counter_CylTrim2, #$%10000000    ; set bits
           bset *BitFlags6B, #$%00010000    ; set bits
   LEA15:  brclr *Counter_CylTrim1, #$%10000000, LEA33    ; branch if bit(s) clear
           ldaa #0x42          ; load a with value -01000010-
           jmp  LEA34      

   LEA1E:  adda INCRID_IncrementForRPMOverIdle    ;  (data is 01)
           bpl  LEA33          ; branch if plus (hi bit 0)
   LEA23:  brclr *Temp0, #$%11111111, LEA30    ; branch if bit(s) clear
           bclr *Counter_CylTrim2, #$%10000000    ; clear bits
           bclr *Counter_CylTrim1, #$%10000000    ; clear bits
           bclr *BitFlags6B, #$%00010000    ; clear bits
   LEA30:  bclr *Counter_CylTrim2, #$%01111111    ; clear bits
   LEA33:  rts                 ; return from subroutine

   LEA34:  ldab Counter_MainLoop    ; load b with memory contents
           bitb #0x0f          ;  -00001111-
           bne  LEA48          ; branch if not equal (not zero)
           brset *b5D_IPL2, #$%00000010, LEA48    ; branch if bit(s) set
           ldab #0xb9          ; load b with value -10111001-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LEA48          ; branch if greater or equal
           bset *b5D_IPL2, #$%00000010    ; set bits
   LEA48:  rts                 ; return from subroutine

DetectParkNeutral_MM:
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 97)
           bita #0x20          ;  -00100000-
           beq  LEA70          ; branch if equal (zero)
           brset *StartupSwitchMirror1, #sw1_PNswitch, LEA5D    ; branch if bit(s) set
           brclr *BitFlags_AIS, #b10_ATXInGear, LEA73    ; branch if bit(s) clear
           bclr *BitFlags_AIS, #b10_ATXInGear    ; clear bits
           bra  LEA64          ; branch

   LEA5D:  brset *BitFlags_AIS, #b10_ATXInGear, LEA73    ; branch if bit(s) set
           bset *BitFlags_AIS, #b10_ATXInGear    ; set bits
   LEA64:  bclr *BitFlags67, #b67_FallToIdle    ; clear bits
           brset *BitFlags6D, #b6d_FuelEngineNotRunning, LEA73    ; branch if bit(s) set
           bset *BitFlags_AIS, #b10_ATXChngGear    ; set bits
           bra  LEA73          ; branch

   LEA70:  bclr *BitFlags_AIS, #$%00001100    ; clear bits
   LEA73:  ldab SwitchPortAccessReg2    ; load b with memory contents
           bitb #0x01          ;  -00000001-
           bne  LEA7D          ; branch if not equal (not zero)
           bset *BitFlags68, #b68_BladePassedSensor    ; set bits
   LEA7D:  rts                 ; return from subroutine

CycleACClutch_MM:
           brset *Counter_MainLoop, #$%00000001, LEAEB    ; branch if bit(s) set
           ldaa #0x30          ; load a with value -00110000-
           clrb                ; b = 0
           jsr  SetPIAOutputBits    ; call subroutine
           ldaa #0x00          ; load a with value -00000000-
           ldab #0xff          ; load b with value -11111111-
           jsr  SetPIAOutputBits    ; call subroutine
           cmpa StartupSwitchMirror2    ; compare a with memory contents
           beq  LEA9C          ; branch if equal (zero)
           pshb                ; push b onto stack
           anda StartupSwitchMirror2    ; logical and a with memory contents
           eorb StartupSwitchMirror2
           andb StartupSwitchMirror1
           aba                 ; a=a+b
           pulb                ; pull b from stack
   LEA9C:  staa StartupSwitchMirror1    ; store a into memory
           stab StartupSwitchMirror2    ; store b into memory
           ldab ACClutchToggleVar    ; load b with memory contents
           eora BitFlags68 
           bita #0x40          ;  -01000000-
           beq  LEAD6          ; branch if equal (zero)
           brclr *StartupSwitchMirror1, #sw1_ACclutch, LEAC1    ; branch if bit(s) clear
           cmpb #0x30          ;  -00110000-
           bcs  LEAB6          ; branch if lower
           bset *BitFlags68, #$%01000000    ; set bits
           bclr *ACClutchToggleVar, #$%00000111    ; clear bits
   LEAB6:  ldaa Counter_MainLoop    ; load a with memory contents
           bita #0x1f          ;  -00011111-
           bne  LEAEB          ; branch if not equal (not zero)
           addb #0x08          ;  -00001000-
           bcc  LEAE9          ; branch if greater or equal
           rts                 ; return from subroutine

   LEAC1:  brclr *ACClutchToggleVar, #$%00000111, LEACC    ; branch if bit(s) clear
           tba                 ; a = b
           anda #0x07          ; AND a with value -00000111-
           cmpa #0x05          ; compare a with value -00000101-
           bls  LEAD3          ; branch if lower or same
   LEACC:  cmpb #0xb8          ;  -10111000-
           bcs  LEAB6          ; branch if lower
           bclr *BitFlags68, #$%01000000    ; clear bits
   LEAD3:  clrb                ; b = 0
           bra  LEAE9          ; branch

   LEAD6:  brset *ACClutchToggleVar, #$%00000111, LEADD    ; branch if bit(s) set
           incb            
           stab ACClutchToggleVar    ; store b into memory
   LEADD:  brset *BitFlags68, #$%01000000, LEAB6    ; branch if bit(s) set
           cmpb #0x60          ;  -01100000-
           bcs  LEAB6          ; branch if lower
           andb #0x07          ;  -00000111-
           orab #0x60          ;  -01100000-
   LEAE9:  stab ACClutchToggleVar    ; store b into memory
   LEAEB:  rts                 ; return from subroutine

;           .org   0xeb16
CheckAndFilterCoolantAndChargeTempSensors_MM:
           brclr *Counter_MainLoop, #$%00000111, FilterAndStoreChargeTemp    ; branch if bit(s) clear
           rts                 ; return from subroutine

CheckForChargeTempOption:
           ldab #0xff
           ldaa OPTN2_CalCustomOptionConfigFlags2
           bita #opt_CTS
           bne  FilterAndStoreChargeTemp
           jmp  StoreChargeTempValue

FilterAndStoreChargeTemp:
           ldab #0x39          ; load b with value -00111001-
           ldaa LastChargeTempVolts    ; load a with memory contents
           cmpa CHGLOW_ChargeTempOutOfRangeLow    ; compare a with memory contents (data is 1a)
           bcs  ChargeTempOutOfRange          ; branch if lower
           incb            
           cmpa CHGHIG_ChargeTempOutOfRangeHigh    ; compare a with memory contents (data is fd)
           bcc  ChargeTempOutOfRange          ; branch if greater or equal
           brset *b5C_IPL1, #b5c_BadCTSensor, LEB8D    ; branch if bit(s) set
           brclr *PIA3_Buffer, #pi3_ChargeTemp, LEB55    ; branch if bit(s) clear
           ldx  #TMPTL1_TempForColdScaleFromA2D    ; load index with value
           cmpa #0x40          ; compare a with value -01000000-
           bcc  LEB5C          ; branch if greater or equal
   LEB39:  brset *BitFlags6B, #$%11000000, LEB45    ; branch if bit(s) set
           ldab BitFlags6B     ; load b with memory contents
           addb #0x40          ;  -01000000-
           stab BitFlags6B     ; store b into memory
           bra  LookupChargeTempValue    ; branch

   LEB45:  bclr *BitFlags6B, #$%11000000    ; clear bits
           ldab #pi3_ChargeTemp          ; load b with value -00100000-
           sei                 ; disable interrupts
           eorb PIA3_Buffer
           stab PIA3_Buffer_2    ; store b into memory
           stab PIA3_Buffer    ; store b into memory
           cli                 ; enable interrupts
           bra  FilterAndStoreCoolantTemp    ; branch

   LEB55:  ldx  #TMPTL2_TempForHotScaleA2D    ; load index with value
           cmpa #0xdc          ; compare a with value -11011100-
           bcc  LEB39          ; branch if greater or equal
   LEB5C:  bclr *BitFlags6B, #$%11000000    ; clear bits
LookupChargeTempValue:
           jsr  Lookup4ByteTable    ; call subroutine
           ldab ChargeTempVolts    ; load b with memory contents
           sba                 ; subtract (a=a-b)
           bcc  LEB6A          ; branch if greater or equal
           decb            
           bra  StoreChargeTempValue    ; branch

   LEB6A:  cmpa #0x03          ; compare a with value -00000011-
           bcs  FilterAndStoreCoolantTemp    ; branch if lower
           incb            
           bra  StoreChargeTempValue    ; branch

ChargeTempOutOfRange:
           brset *b5C_IPL1, #b5c_BadCTSensor, LEB92    ; branch if bit(s) set
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
           bset *b5C_IPL1, #b5c_BadCTSensor    ; set bits
           bra  FilterAndStoreCoolantTemp    ; branch

   LEB8D:  ldaa #0x01          ; load a with value -00000001-
           jsr  ResetErrorCodeIfTimerExpired    ; call subroutine
   LEB92:  brclr *b5C_IPL1, #b5c_BadCoolantTemp, SubstituteChargeTempForCoolantTemp    ; branch if bit(s) clear
           ldab DEFCHG_DefaultChargeTemp_Limpin    ; load b with memory contents (data is 95)
           bra  StoreChargeTempValue    ; branch

SubstituteChargeTempForCoolantTemp:
           ldab CoolantTemp    ; load b with memory contents
StoreChargeTempValue:
           stab ChargeTempVolts    ; store b into memory
FilterAndStoreCoolantTemp:
           ldab #0x1e          ; load b with value -00011110-
           ldaa LastCoolantTempVolts    ; load a with memory contents
           cmpa TMPLOW_OutOfRangeHotTooLowA2D    ; compare a with memory contents (data is 1a)
           bcs  CoolantTempOutOfRange          ; branch if lower
           incb            
           cmpa TMPHIG_OutOfRangeColdTooHighA2D    ; compare a with memory contents (data is fd)
           bcc  CoolantTempOutOfRange          ; branch if greater or equal
           brset *b5C_IPL1, #b5c_BadCoolantTemp, LEC17    ; branch if bit(s) set
           brclr *PIA3_Buffer, #pi3_CoolantTemp, LEBD8    ; branch if bit(s) clear
           ldx  #TMPTL1_TempForColdScaleFromA2D    ; load index with value
           cmpa #0x40          ; compare a with value -01000000-
           bcc  LEBDF          ; branch if greater or equal
   LEBBD:  brset *BitFlags69, #$%11000000, LEBC9    ; branch if bit(s) set
           ldab BitFlags69     ; load b with memory contents
           addb #0x40          ;  -01000000-
           stab BitFlags69     ; store b into memory
           bra  LookupAndFilterCoolantTempValue          ; branch

   LEBC9:  bclr *BitFlags69, #$%11000000    ; clear bits
           ldab #pi3_CoolantTemp          ; load b with value -00010000-
           sei                 ; disable interrupts
           eorb PIA3_Buffer
           stab PIA3_Buffer_2    ; store b into memory
           stab PIA3_Buffer    ; store b into memory
           cli                 ; enable interrupts
   LEBD7:  rts                 ; return from subroutine

   LEBD8:  ldx  #TMPTL2_TempForHotScaleA2D    ; load index with value
           cmpa #0xdc          ; compare a with value -11011100-
           bcc  LEBBD          ; branch if greater or equal
   LEBDF:  bclr *BitFlags69, #$%11000000    ; clear bits
LookupAndFilterCoolantTempValue:
           jsr  Lookup4ByteTable    ; call subroutine
           ldab CoolantTemp    ; load b with memory contents
           sba                 ; subtract (a=a-b)
           bcc  LEBED          ; branch if greater or equal
           decb            
           bra  StoreCoolantTemp          ; branch

   LEBED:  cmpa #0x03          ; compare a with value -00000011-
           bcs  LEBD7          ; branch if lower
           incb            
           bra  StoreCoolantTemp          ; branch

CoolantTempOutOfRange:
           brset *b5C_IPL1, #b5c_BadCoolantTemp, UseSubForCoolantTemp    ; branch if bit(s) set
           tba                 ; a = b
           ldab #0x9e          ; load b with value -10011110-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LEBD7          ; branch if greater or equal
           ldaa #~pi3_CoolantTemp          ; load a with value -11101111-
           sei                 ; disable interrupts
           anda PIA3_Buffer    ; logical and a with memory contents
           staa PIA3_Buffer_2
           staa PIA3_Buffer    ; store a into memory
           cli                 ; enable interrupts
           bset *b5C_IPL1, #b5c_BadCoolantTemp    ; set bits
           bclr *BitFlags66, #b66_O2Valid    ; clear bits
           clra                ; a = 0
           staa Timer_CLTIME_ClosedLoopTimer    ; store a into memory
           staa Timer_ThermostatDiagnostics    ; store a into memory
           rts                 ; return from subroutine

   LEC17:  ldaa #0x02          ; load a with value -00000010-
           jsr  ResetErrorCodeIfTimerExpired    ; call subroutine
UseSubForCoolantTemp:
           ldaa OPTN2_CalCustomOptionConfigFlags2
           bita #opt_CTS
           beq  UseDefCoolantTemp          ; branch if equal (zero)
           brset *b5c_IPL1, #b5c_BadCTSensor, UseDefCoolantTemp    ; branch if bit(s) set
           ldab ChargeTempVolts    ; load b with memory contents
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
           brclr *b5C_IPL1, #b5c_TpsBadSignal, CheckThrottle_GotTpsValue    ; branch if bit(s) clear
           ldaa #0x07          ; load a with value -00000111-
           bita Counter_MainLoop
           bne  CheckThrottle_ErrorAlreadyFlagged    ; branch if not equal (not zero)
           jsr  ResetErrorCodeIfTimerExpired    ; call subroutine
           bra  CheckThrottle_ErrorAlreadyFlagged    ; branch

CheckThrottle_BadTpsSignal:
           brset *b5C_IPL1, #b5c_TpsBadSignal, CheckThrottle_ErrorAlreadyFlagged    ; branch if bit(s) set
           brclr *Counter_MainLoop, #$%00000001, LEC8A    ; branch if bit(s) clear
           tba                 ; a = b
           ldab #0xa0          ; load b with value -10100000-
           jsr  ThrowNonCriticalError    ; call subroutine
           bcc  LEC8A          ; branch if greater or equal
           bset *b5C_IPL1, #b5c_TpsBadSignal    ; set bits
CheckThrottle_ErrorAlreadyFlagged:
           ldaa #0x40          ; load a with value -01000000-
           staa MINTHR_LowestSessionTPS    ; store a into memory
           brset *BitFlags6D, #b6d_FuelEngineNotRunning, CheckThrottle_GotTpsValue    ; branch if bit(s) set
           ldab MapValue       ; load b with memory contents
           cmpb MPTHR_MapSwitchPointForFullThrottleOrIdle    ; compare b with memory contents (data is 68)
           bcs  CheckThrottle_GotTpsValue    ; branch if lower
           adda WOTDLT_DeltaThrottleFrom_MINTHR_ToDetermineFullThrottle    ;  (data is 3d)
CheckThrottle_GotTpsValue:
           staa TpsVolts       ; store a into memory
           ldab WOTDLT_DeltaThrottleFrom_MINTHR_ToDetermineFullThrottle    ; load b with memory contents (data is 3d)
           addb MINTHR_LowestSessionTPS    ; b=b+memory contents
           cmpb #0xd0          ;  -11010000-
           bls  LEC79          ; branch if lower or same
           ldab #0xd0          ; load b with value -11010000-
   LEC79:  brclr *BitFlags66, #b66_FullThrottle, LEC7F    ; branch if bit(s) clear
           subb #0x03          ;  -00000011-
   LEC7F:  cba             
           bhi  CheckThrottle_AtFullThrottle    ; branch if higher
           bclr *BitFlags66, #b66_FullThrottle    ; clear bits
           bra  LEC8A          ; branch

CheckThrottle_AtFullThrottle:
           bset *BitFlags66, #b66_FullThrottle    ; set bits
   LEC8A:  ldaa TpsVolts       ; load a with memory contents
           ldab BitFlags66     ; load b with memory contents
           bmi  LECB1          ; branch if minus(hi bit 1)
           cmpa MINTHR_LowestSessionTPS    ; compare a with memory contents
           bcc  LECB1          ; branch if greater or equal
           ldaa Timer_CountdownFromStartRunForAisFeedback    ; load a with memory contents
           bne  LECB1          ; branch if not equal (not zero)
           brset *BitFlags6D, #b6d_FuelEngineNotRunning, LECB1    ; branch if bit(s) set
           brclr *KeyOnOrEngineRunningTime, #$%11111111, LECB1    ; branch if bit(s) clear
           ldaa Timer_DelayBeforeUpdating_MINTHR    ; load a with memory contents
           deca                ; decrement a
           bne  LECB4          ; branch if not equal (not zero)
           ldaa MINTHR_LowestSessionTPS    ; load a with memory contents
           deca                ; decrement a
           bge  LECAD          ; branch if greater or equal
           ldaa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load a with memory contents (data is 5c)
   LECAD:  staa MINTHR_LowestSessionTPS    ; store a into memory
           andb #0xbf          ;  -10111111-
   LECB1:  ldaa MAXCNT_ProgramLoopsWithThrottleBelow_MINTHR_ToDecrement_MINTHR    ; load a with memory contents (data is 10)
   LECB4:  staa Timer_DelayBeforeUpdating_MINTHR    ; store a into memory
           ldaa MTHRCL_NumberOfBitsAbove_MINTHR_ToDetermineOnThrottleTransition    ; load a with memory contents (data is 02)
           tstb            
           bpl  LECBF          ; branch if plus (hi bit 0)
           ldaa MTHROP_NumberOfBitsAbove_MINTHR_ToDetermineOffThrottleTransition    ; load a with memory contents (data is 01)
   LECBF:  adda MINTHR_LowestSessionTPS
           cmpa TpsVolts       ; compare a with memory contents
           bcc  CheckThrottle_AtIdle    ; branch if greater or equal
           tstb            
           bmi  LED1A          ; branch if minus(hi bit 1)
           bitb #0x40          ;  -01000000-
           bne  LECD7          ; branch if not equal (not zero)
           ldaa MINTHR_LowestSessionTPS    ; load a with memory contents
           inca                ; increment a
           cmpa TpsVolts       ; compare a with memory contents
           bcc  LECD7          ; branch if greater or equal
           staa MINTHR_LowestSessionTPS    ; store a into memory
           orab #0x40          ;  -01000000-
   LECD7:  ldaa MapValue       ; load a with memory contents
           suba OCTAE_FakeDeltaMapIncrease    ;  (data is 02)
           bcc  LECE0          ; branch if greater or equal
           ldaa MINAMP_MinimumAverageMAP          ; load a with value -00000110-
   LECE0:  staa MapAverageValue_HB    ; store a into memory
           ldaa TpsVolts       ; load a with memory contents
           staa TpsAverageValue_HB    ; store a into memory
           orab #0x80          ;  -10000000-
           bra  LED1A          ; branch

CheckThrottle_AtIdle:
           tstb            
           bpl  LED1A          ; branch if plus (hi bit 0)
           brset *BitFlags_AIS, #$%01000000, LECF4    ; branch if bit(s) set
           bset *BitFlags69, #b69_AtIdle    ; set bits
   LECF4:  ldx  #DLYTIM_AisDelayAfterThrottleClosesWhenMoving        ; load index with value
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
           bcc  LED10          ; branch if greater or equal
CheckThrottle_VehicleSpeedStillAboveDecelIdle:
           ldaa 0x00, X        ; load a with memory at index + value
   LED10:  cmpa Timer_CountdownFromStartRunForAisFeedback    ; compare a with memory contents
           bls  LED16          ; branch if lower or same
           staa Timer_CountdownFromStartRunForAisFeedback    ; store a into memory
   LED16:  ldab Temp0          ; load b with memory contents
           andb #0x7f          ;  -01111111-
   LED1A:  bitb #0x08          ;  -00001000-
           bne  LED3F          ; branch if not equal (not zero)
           brclr *StartupSwitchMirror1, #sw1_Brake, LED3F    ; branch if bit(s) clear
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa RPMTHR_ThrottleSelfCalibrationRpmThreshold    ; compare a with memory contents (data is 30)
           bcs  LED3F          ; branch if lower
           ldaa MapValue       ; load a with memory contents
           cmpa MAPTHR_ThrottleSelfCalibrationMapDeltaThreshold    ; compare a with memory contents (data is 31)
           bcc  LED3F          ; branch if greater or equal
           ldaa MINTHR_LowestSessionTPS    ; load a with memory contents
           inca                ; increment a
           cmpa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; compare a with memory contents (data is 5c)
           bcs  LED3B          ; branch if lower
           ldaa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load a with memory contents (data is 5c)
   LED3B:  staa MINTHR_LowestSessionTPS    ; store a into memory
           orab #0x08          ;  -00001000-
   LED3F:  ldaa MINTHR_LowestSessionTPS    ; load a with memory contents
           adda #0x30          ;  -00110000-
           cmpa TpsVolts       ; compare a with memory contents
           bcc  LED49          ; branch if greater or equal
           andb #~b66_PartThrottle          ;  -11110111-
   LED49:  stab BitFlags66     ; store b into memory
           rts                 ; return from subroutine

ConvertMAPVoltsToValue:
           staa Temp5          ; store a into memory
           ldab MAPMULT_ScaleMAPVoltsToPresMultiplyConst          ; load b with value -00000111-
           bpl  LED55          ; branch if plus (hi bit 0)
           clr  Temp5          ; zero byte at memory location
   LED55:  mul                 ; multiply (d=a*b)
           adda Temp5      
           bcc  LED5C          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LED5C:  addd MAPADD_ScaleMAPVoltsToPresAddConst        ;  -00000011 01100001-
           bcc  LED63          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LED63:  rts                 ; return from subroutine

   LED64:  ldaa CPU_TimerControlReg2    ; load a with memory contents
           lsra            
           eora CPU_PortA  
           bita #0x02          ;  -00000010-
           rts                 ; return from subroutine

Interrupt_SpeedometerSignal:
           ldd  CPU_TimerInputCapture2_Speedometer
           stD *Temp5          ; store D to RAM
           bsr  LED64          ; call subroutine
           beq  LED81          ; branch if equal (zero)
           fdiv            
           bsr  LED64          ; call subroutine
           beq  LED81          ; branch if equal (zero)
           fdiv            
           bsr  LED64          ; call subroutine
           bne  LEDB5          ; branch if not equal (not zero)
   LED81:  ldd  Counter_SpeedSensorInterrupt    ; load d (a&b) with memory contents
           addd #0x0001         ;  -00000000 00000001-
           stD *Counter_SpeedSensorInterrupt    ; store D to RAM
           bne  LED8D          ; branch if not equal (not zero)
           bset *b5D_IPL2, #$%00000001    ; set bits
   LED8D:  inc  Counter_SpeedSensorInterrupt_HB_X
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           subd #0x0640        ;  -00000110 01000000-
           ldaa BitFlags6f     ; load a with memory contents
           bcc  LEDB7          ; branch if greater or equal
           bita #b6f_BadSpeedo1          ;  -00010000-
           bne  LEDA1          ; branch if not equal (not zero)
           oraa #b6f_BadSpeedo1          ;  -00010000-
           bra  LEDBB          ; branch

   LEDA1:  anda #0x1f          ; AND a with value -00011111-
           oraa #b6f_BadSpeedo2          ;  -00001000-
           staa BitFlags6f     ; store a into memory
           clra                ; a = 0
           staa CruiseControlVar4    ; store a into memory
           staa Counter_SomethingWithCamSensor    ; store a into memory
           staa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; store a into memory
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           addd #CruiseControlVar2    ;  -00000000 01010011-
           stD *VehicleSpeed_HB    ; store D to RAM
   LEDB5:  bra  LEE20          ; branch

   LEDB7:  bita #0x10          ;  -00010000-
           bne  LEE26          ; branch if not equal (not zero)
   LEDBB:  adda #0x20          ;  -00100000-
           bcs  LEDC5          ; branch if lower
           anda #~b6f_BadSpeedo1          ; AND a with value -11101111-
           staa BitFlags6f     ; store a into memory
           bra  LEE20          ; branch

   LEDC5:  staa BitFlags6f     ; store a into memory
           ldab CruiseControlVar4    ; load b with memory contents
           beq  LEDE8          ; branch if equal (zero)
           bita #0x08          ;  -00001000-
           bne  LEDE8          ; branch if not equal (not zero)
           ldaa #0x3a          ; load a with value -00111010-
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           cmpa #0x03          ; compare a with value -00000011-
           bcc  LEDDA          ; branch if greater or equal
           ldaa #0x03          ; load a with value -00000011-
   LEDDA:  tab                 ; b = a
           ldaa Counter_SomethingWithCamSensor    ; load a with memory contents
           suba CruiseControlVar4
           bcc  LEDE2          ; branch if greater or equal
           nega                ; negate a (set high bit)
   LEDE2:  sba                 ; subtract (a=a-b)
           bcs  LEDEC          ; branch if lower
           bset *BitFlags6f, #b6f_BadSpeedo2    ; set bits
   LEDE8:  ldab Counter_SomethingWithCamSensor    ; load b with memory contents
           stab CruiseControlVar4    ; store b into memory
   LEDEC:  clra                ; a = 0
           staa Counter_SomethingWithCamSensor    ; store a into memory
           ldd  Temp5          ; load d (a&b) with memory contents
           bsr  DetermineNumberOfOverflowsBetweenSpeedoPulses_MM    ; call subroutine
           ldaa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; load a with memory contents
           lsra            
           tab                 ; b = a
           oraa TimerOverflowsBetweenSpeedoPulses    ; OR a with memory contents
           beq  LEE03          ; branch if equal (zero)
           stab TimerOverflowsBetweenSpeedoPulses    ; store b into memory
           ldd  Temp5          ; load d (a&b) with memory contents
           subd PreviousVehicleSpeed_HB    ; d = d - memory contents
           bra  LEE17          ; branch

   LEE03:  ldd  Temp5          ; load d (a&b) with memory contents
           subd PreviousVehicleSpeed_HB    ; d = d - memory contents
           subd InverseVehicleSpeed_HB    ; d = d - memory contents
           beq  LEE19          ; branch if equal (zero)
           asra            
           rorb            
           asra            
           rorb            
           subd #0x0000         ;  -00000000 00000000-
           bne  LEE15          ; branch if not equal (not zero)
           incb            
   LEE15:  addd InverseVehicleSpeed_HB    ; d = d + memory contents
   LEE17:  stD *InverseVehicleSpeed_HB    ; store D to RAM
   LEE19:  ldd  Temp5          ; load d (a&b) with memory contents
           stD *PreviousVehicleSpeed_HB    ; store D to RAM
           clra                ; a = 0
           staa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; store a into memory
   LEE20:  ldaa #0x02          ; load a with value -00000010-
           staa CPU_TimerInterruptFlag1
           rti                 ; return from interrupt

   LEE26:  anda #~b6f_BadSpeedo1          ; AND a with value -11101111-
           staa BitFlags6f     ; store a into memory
           ldaa #0x01          ; load a with value -00000001-
           staa TimerOverflowsBetweenSpeedoPulses    ; store a into memory
           ldd  #0x1940        ; load d (a&b) with value -00011001 01000000-
           bra  LEE17          ; branch

DetermineNumberOfOverflowsBetweenSpeedoPulses_MM:
           subd PreviousVehicleSpeed_HB    ; d = d - memory contents
           staa Temp7          ; store a into memory
           ldaa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; load a with memory contents
           lsrd                ; shift right (d=d/2)
           eorb Temp7      
           bpl  LEE4E          ; branch if plus (hi bit 0)
           ldaa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; load a with memory contents
           inca                ; increment a
           beq  LEE45          ; branch if equal (zero)
           staa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; store a into memory
   LEE45:  ldaa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; load a with memory contents
           lsra            
           cmpa TimerOverflowsBetweenSpeedoPulses    ; compare a with memory contents
           bls  LEE4E          ; branch if lower or same
           staa TimerOverflowsBetweenSpeedoPulses    ; store a into memory
   LEE4E:  rts                 ; return from subroutine

ControlCruiseServo1_MM:
           brclr *BitFlags6f, #b6f_BadSpeedo1, LEE64    ; branch if bit(s) clear
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
   LEE64:  ldaa Timer_CountdownFromStartRunForAisFeedback    ; load a with memory contents
           beq  LEE7A          ; branch if equal (zero)
           brclr *BitFlags6D, #b6d_JustStarted, LEE73    ; branch if bit(s) clear
           clra                ; a = 0
           ldx  EngineRpm_HB
           cpx  TargetIdleSpeedHB
           bls  LEE76          ; branch if lower or same
   LEE73:  ldaa Timer_CountdownFromStartRunForAisFeedback    ; load a with memory contents
           deca                ; decrement a
   LEE76:  staa Timer_CountdownFromStartRunForAisFeedback    ; store a into memory
           bra  LEE7D          ; branch

   LEE7A:  bset *BitFlags6D, #b6d_JustStarted    ; set bits
   LEE7D:  brclr *BitFlags66, #b66_OffIdle, LEE85    ; branch if bit(s) clear
   LEE81:  bclr *BitFlags67, #b67_FallToIdle | b67_IdleSpeedMode    ; clear bits
           rts                 ; return from subroutine

   LEE85:  ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           ldab MPHREF_SwitchPointForDecelIdleAisControl    ; load b with memory contents (data is 07)
           brset *BitFlags67, #b67_IdleSpeedMode, LEE9A    ; branch if bit(s) set
           brset *BitFlags67, #b67_FallToIdle, LEE9A    ; branch if bit(s) set
           addb #0x03          ;  -00000011-
   LEE9A:  cba             
           bls  LEE81          ; branch if lower or same
           ldab CONFIG_ConfigurationFlags    ; load b with memory contents (data is 97)
           bitb #0x20          ;  -00100000-
           bne  LEEC9          ; branch if not equal (not zero)
           ldab AISMPH_RollingAisMaxSpeed    ; load b with memory contents (data is 10)
           brclr *BitFlags67, #b67_IdleSpeedMode, LEEAD    ; branch if bit(s) clear
           addb #0x03          ;  -00000011-
   LEEAD:  cba             
           bhi  LEEC9          ; branch if higher
           ldd  TargetIdleSpeedHB    ; load d (a&b) with memory contents
           addd RPMDLT_RollingAisMinRpm    ;  (data is 07)
           cmpD EngineRpm_HB    ; compare D
           bcs  LEEC9          ; branch if lower
           brset *BitFlags67, #b67_IdleSpeedMode, LEEC2    ; branch if bit(s) set
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           stD *TargetIdleSpeedHB    ; store D to RAM
   LEEC2:  bclr *BitFlags67, #b67_FallToIdle    ; clear bits
           bset *BitFlags67, #b67_IdleSpeedMode    ; set bits
           rts                 ; return from subroutine

   LEEC9:  bset *BitFlags67, #b67_FallToIdle    ; set bits
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
           ldaa TimerOverflowsBetweenCamPulses    ; load a with memory contents
           bne  LEEF4          ; branch if not equal (not zero)

           ldab Temp0          ; load b with memory contents
           ldaa DistributorFallingEdgePulsewidth_HB    ; load a with memory contents
           mul                 ; multiply (d=a*b)
           xgDY                ; exchange D and Y
           ldaa #0x11          ; load a with value -00010001-
           jsr  ScaleYbyA      ; call subroutine
           xgDY                ; exchange D and Y
           tsta                ; test a
           beq  LEEF1          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   LEEF1:  stab ScaledDistPWForCruiseControl          ; store b into memory
   LEEF4:  bclr *Counter_Cruise_1, #$%00001111    ; clear bits
           brset *StartupSwitchMirror1, #sw1_CruiseOnOff, LEF00    ; branch if bit(s) set
           clrb                ; b = 0
           stab CruiseSpeedSetpoint    ; store b into memory
           bra  LEF58          ; branch

   LEF00:  inc  Counter_Cruise_1
           ldaa Temp0          ; load a with memory contents
           cmpa CRUZ21_UnknownConstForCruiseControl21    ; compare a with memory contents (data is 3c)
           bcs  LEF50          ; branch if lower
           inc  Counter_Cruise_1
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa CRUZ22_UnknownConstForCruiseControl22    ; compare a with memory contents (data is bc)
           bcc  LEF50          ; branch if greater or equal
           inc  Counter_Cruise_1
           brset *StartupSwitchMirror1, #sw1_Brake, LEF50    ; branch if bit(s) set
           inc  Counter_Cruise_1
           ldaa CONFIG_ConfigurationFlags    ; load a with memory contents (data is 97)
           bita #0x20          ;  -00100000-
           beq  LEF31          ; branch if equal (zero)
           brclr *StartupSwitchMirror1, #sw1_PNswitch, LEF50    ; branch if bit(s) clear
           inc  Counter_Cruise_1
           inc  Counter_Cruise_1
           bra  LEF8C          ; branch

   LEF31:  inc  Counter_Cruise_1
           ldaa TimerOverflowsBetweenCamPulses    ; load a with memory contents
           bne  LEF45          ; branch if not equal (not zero)
           ldab ScaledDistPWForCruiseControl          ; load b with memory contents
           cmpb SCNVHI_CruiseControlForBrakeFlagManualTransmissionClutchDisableHi    ; compare b with memory contents (data is ff)
           bcc  LEF50          ; branch if greater or equal
           cmpb SCNVLO_CruiseControlForBrakeFlagManualTransmissionClutchDisableLo    ; compare b with memory contents (data is 52)
           bcs  LEF50          ; branch if lower
   LEF45:  inc  Counter_Cruise_1
           brset *CruiseStatus_1, #$%10000000, LEF8C    ; branch if bit(s) set
           brclr *BitFlags6f, #b6f_BadSpeedo2, LEF8C    ; branch if bit(s) clear
   LEF50:  brclr *CruiseStatus_1, #$%00011000, LEF58    ; branch if bit(s) clear
           ldaa Temp0          ; load a with memory contents
           staa CruiseSpeedSetpoint    ; store a into memory
   LEF58:  brset *CruiseStatus_1, #$%10000000, LEF65    ; branch if bit(s) set
           ldab Counter_Cruise_1    ; load b with memory contents
           andb #0x0f          ;  -00001111-
           ldaa #0x11          ; load a with value -00010001-
           mul                 ; multiply (d=a*b)
           stab Counter_Cruise_1    ; store b into memory
   LEF65:  clrb                ; b = 0
           stab Counter_Cruise_2    ; store b into memory
           stab Counter_Cruise_3    ; store b into memory
           stab CruiseControlVar0    ; store b into memory
           stab Counter_Cruise    ; store b into memory
           stab CruiseControlVar6    ; store b into memory
           stab CruiseControlVar2    ; store b into memory
           bclr *CruiseStatus_1, #$%00011111    ; clear bits
           bset *CruiseStatus_1, #$%10100000    ; set bits
           bclr *CruiseStatus_2, #$%00001111    ; clear bits
           brset *StartupSwitchMirror1, #sw1_CruiseOnOff, LEF86    ; branch if bit(s) set
           ldaa CRUZ7_UnknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           bita #0x80          ;  -10000000-
           bne  LEF89          ; branch if not equal (not zero)
   LEF86:  bset *Counter_Cruise_2, #$%10000000    ; set bits
   LEF89:  jmp  LF169      

   LEF8C:  inc  Counter_Cruise_1
           ldaa #0xc0          ; load a with value -11000000-
           ldab #0xff          ; load b with value -11111111-
           jsr  SetPIAOutputBits    ; call subroutine
           staa Temp1          ; store a into memory
           eora PIA2_Buffer
           anda #pi2_SCVent | pi2_SCVac          ; AND a with value -00000011-
           beq  LEFED          ; branch if equal (zero)
           bita #0x01          ;  -00000001-
           bne  LEFA3          ; branch if not equal (not zero)
           lsrb                ; logical shift right b
   LEFA3:  ldaa #0x00          ; load a with value -00000000-
           bitb #0x01          ;  -00000001-
           bne  LEFDD          ; branch if not equal (not zero)
           brset *CruiseStatus_1, #$%10000000, LEFD3    ; branch if bit(s) set
           ldaa Temp0          ; load a with memory contents
           psha                ; push a onto stack
           ldd  #0x0f89        ; load d (a&b) with value -00001111 10001001-
           jsr  ThrowNonCriticalError    ; call subroutine
           pula                ; pull a from stack
           staa Temp0          ; store a into memory
           ldd  #0x0f08        ; load d (a&b) with value -00001111 00001000-
           ldx  #ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB    ; load index with value
           cmpa 0x00, X        ; compare a with memory at index + value
           beq  LEFC8          ; branch if equal (zero)
           inx                 ; increment index (x=x+1)
           cmpa 0x00, X        ; compare a with memory at index + value
           bne  LEFED          ; branch if not equal (not zero)
   LEFC8:  cmpb 0x02, X    
           bne  LEFED          ; branch if not equal (not zero)
           clr  0x00, X    
           clr  0x02, X    
           jmp  LEF50      

   LEFD3:  ldaa #0x07          ; load a with value -00000111-
           ldab Temp1          ; load b with memory contents
           bitb #0x03          ;  -00000011-
           bne  LEFDD          ; branch if not equal (not zero)
           ldaa #0x7f          ; load a with value -01111111-
   LEFDD:  bita Counter_MainLoop
           bne  LEFED          ; branch if not equal (not zero)
           ldaa Temp0          ; load a with memory contents
           psha                ; push a onto stack
           ldd  #0x0f10        ; load d (a&b) with value -00001111 00010000-
           jsr  ThrowNonCriticalError    ; call subroutine
           pula                ; pull a from stack
           staa Temp0          ; store a into memory
   LEFED:  inc  Counter_Cruise_1
           ldaa CRUZ7_UnknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           bita #0x80          ;  -10000000-
           beq  LEFFF          ; branch if equal (zero)
           brset *CruiseStatus_1, #$%00000001, LEFFF    ; branch if bit(s) set
           brclr *StartupSwitchMirror1, #sw1_CruiseResume, LF068    ; branch if bit(s) clear
   LEFFF:  brset *StartupSwitchMirror1, #sw1_CruiseSet, LF068    ; branch if bit(s) set
           ldab Counter_Cruise_2    ; load b with memory contents
           incb            
           bne  LF009          ; branch if not equal (not zero)
           decb            
   LF009:  stab Counter_Cruise_2    ; store b into memory
           brset *CruiseStatus_1, #$%00000001, LF031    ; branch if bit(s) set
           brset *Counter_Cruise_2, #$%10000000, LF044    ; branch if bit(s) set
           cmpb #0x04          ;  -00000100-
           bls  LF044          ; branch if lower or same
           bset *CruiseStatus_1, #$%00100001    ; set bits
           bclr *CruiseStatus_1, #$%00001010    ; clear bits
           bset *CruiseStatus_2, #$%00000100    ; set bits
           clra                ; a = 0
           staa Counter_Cruise_3    ; store a into memory
           staa CruiseControlVar0    ; store a into memory
           ldaa CRUZ7_UnknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           bita #0x80          ;  -10000000-
           bne  LF044          ; branch if not equal (not zero)
           bclr *CruiseStatus_1, #$%00000100    ; clear bits
           bra  LF044          ; branch

   LF031:  brset *CruiseStatus_1, #$%10000000, LF044    ; branch if bit(s) set
           brset *CruiseStatus_1, #$%00010000, LF056    ; branch if bit(s) set
           ldaa CRUZ7_UnknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           bita #0x80          ;  -10000000-
           beq  LF047          ; branch if equal (zero)
           cmpb #0x38          ;  -00111000-
           bhi  LF04C          ; branch if higher
   LF044:  jmp  LF28E      

   LF047:  cmpb CRUZ46_UnknownConstForCruiseControl46    ; compare b with memory contents (data is 00)
           bls  LF044          ; branch if lower or same
   LF04C:  bset *CruiseStatus_1, #$%00010000    ; set bits
           bclr *CruiseStatus_2, #$%00000011    ; clear bits
           ldaa Temp0          ; load a with memory contents
           staa CruiseControlVar0    ; store a into memory
   LF056:  ldab CruiseStatus_2   ; load b with memory contents
           cmpb #0xa0          ;  -10100000-
           bcs  LF044          ; branch if lower
           ldab CruiseControlVar0    ; load b with memory contents
           subb CRUZ32_UnknownConstForCruiseControl32    ; subtract memory contents from b (data is 08)
           bcc  LF064          ; branch if greater or equal
           clrb                ; b = 0
   LF064:  stab CruiseControlVar0    ; store b into memory
           bra  LF044          ; branch

   LF068:  brclr *CruiseStatus_1, #$%00000001, LF0D3    ; branch if bit(s) clear
           ldaa #0x7f          ; load a with value -01111111-
           brset *CruiseStatus_1, #$%10000000, LF0A9    ; branch if bit(s) set
           brset *CruiseStatus_2, #$%00001000, LF080    ; branch if bit(s) set
           ldab CruiseSpeedSetpoint    ; load b with memory contents
           subb Temp0          ; b = b-memory contents
           bcc  LF080          ; branch if greater or equal
           cmpb #0xfc          ;  -11111100-
           bcs  LF0A9          ; branch if lower
   LF080:  brset *CruiseStatus_1, #$%00010000, LF08E    ; branch if bit(s) set
           ldaa CRUZ7_UnknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           anda #0x80          ; AND a with value -10000000-
           beq  LF0AF          ; branch if equal (zero)
           jmp  LF13C      

   LF08E:  ldaa Counter_Cruise_3    ; load a with memory contents
           ldab CRUZ31_UnknownConstForCruiseControl31    ; load b with memory contents (data is 34)
           addb #0x80          ;  -10000000-
           bmi  LF09E          ; branch if minus(hi bit 1)
           mul                 ; multiply (d=a*b)
           adca Counter_Cruise_3
           bcs  LF0A5          ; branch if lower
           bra  LF0A1          ; branch

   LF09E:  mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
   LF0A1:  cmpa #0x7f          ; compare a with value -01111111-
           bls  LF0AF          ; branch if lower or same
   LF0A5:  ldaa #0x7f          ; load a with value -01111111-
           bra  LF0AF          ; branch

   LF0A9:  bset *CruiseStatus_2, #$%00000001    ; set bits
           clrb                ; b = 0
           stab CruiseControlVar6    ; store b into memory
   LF0AF:  ldab Temp0          ; load b with memory contents
           stab CruiseSpeedSetpoint    ; store b into memory
           staa Temp2          ; store a into memory
           jsr  LF248          ; call subroutine
           ldab Temp2          ; load b with memory contents
           cba             
           bhi  LF0BE          ; branch if higher
           tab                 ; b = a
   LF0BE:  bclr *CruiseStatus_1, #$%10010001    ; clear bits
           bclr *CruiseStatus_2, #$%00001000    ; clear bits
           bclr *BitFlags6f, #b6f_BadSpeedo2    ; clear bits
           clra                ; a = 0
           staa Counter_Cruise_3    ; store a into memory
           staa Counter_Cruise_2    ; store a into memory
           staa CruiseControlVar0    ; store a into memory
           staa Counter_Cruise    ; store a into memory
           jmp  LF169      

   LF0D3:  clrb                ; b = 0
           stab Counter_Cruise_2    ; store b into memory
           brset *StartupSwitchMirror1, #sw1_CruiseResume, LF0DD    ; branch if bit(s) set
           jmp  LF1D9      

   LF0DD:  ldab Counter_Cruise_3    ; load b with memory contents
           incb            
           bne  LF0E3          ; branch if not equal (not zero)
           decb            
   LF0E3:  stab Counter_Cruise_3    ; store b into memory
           brclr *CruiseStatus_1, #$%00000010, LF0EC    ; branch if bit(s) clear
           jmp  LF185      

   LF0EC:  brclr *CruiseStatus_1, #$%00100000, LF0F3    ; branch if bit(s) clear
   LF0F0:  jmp  LF229      

   LF0F3:  cmpb #0x04          ;  -00000100-
           bhi  LF0FA          ; branch if higher
           jmp  LF28E      

   LF0FA:  bset *CruiseStatus_1, #$%00000110    ; set bits
           bset *CruiseStatus_2, #$%00000100    ; set bits
           clra                ; a = 0
           staa Counter_Cruise    ; store a into memory
           brclr *CruiseStatus_1, #$%10000000, LF13C    ; branch if bit(s) clear
           bset *CruiseStatus_1, #$%00100000    ; set bits
           bclr *CruiseStatus_1, #$%10000000    ; clear bits
           bclr *BitFlags6f, #b6f_BadSpeedo2    ; clear bits
           jsr  LF248          ; call subroutine
           staa Temp2          ; store a into memory
           ldaa CruiseSpeedSetpoint    ; load a with memory contents
           suba Temp0      
           bcc  LF11E          ; branch if greater or equal
           tab                 ; b = a
           eorb #0x80          ;  -10000000-
   LF11E:  bpl  LF125          ; branch if plus (hi bit 0)
           lsla                ; logical shift left a
           ldaa #0x80          ; load a with value -10000000-
           sbca #0x00          ;  -00000000-
   LF125:  adda #0x80          ;  -10000000-
           ldx  #RESTBL2_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference2        ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           addb #0x80          ;  -10000000-
           addb Temp2          ; b=b+memory contents
           bpl  LF180          ; branch if plus (hi bit 0)
           bvc  LF139          ; branch if overflow
           ldab #0x7f          ; load b with value -01111111-
           bra  LF180          ; branch

   LF139:  clrb                ; b = 0
           bra  LF180          ; branch

   LF13C:  bclr *CruiseStatus_2, #$%00000011    ; clear bits
           ldaa CruiseSpeedSetpoint    ; load a with memory contents
           adda #0x04          ;  -00000100-
           staa CruiseSpeedSetpoint    ; store a into memory
           ldab CruiseControlVar3    ; load b with memory contents
           suba #0x03          ;  -00000011-
           cmpa MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; compare a with memory contents (data is aa)
           bhi  LF15F          ; branch if higher
           ldab CRUZ23_UnknownConstForCruiseControl23    ; load b with memory contents (data is 03)
           ldaa CruiseControlVar3    ; load a with memory contents
           bmi  LF15F          ; branch if minus(hi bit 1)
           aba                 ; a=a+b
           bcs  LF15C          ; branch if lower
           cmpa #0x7f          ; compare a with value -01111111-
           bls  LF15E          ; branch if lower or same
   LF15C:  ldaa #0x7f          ; load a with value -01111111-
   LF15E:  tab                 ; b = a
   LF15F:  ldaa CRUZ7_UnknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           bita #0x80          ;  -10000000-
           beq  LF169          ; branch if equal (zero)
           jmp  LF0BE      

   LF169:  ldaa CruiseSpeedSetpoint    ; load a with memory contents
           cmpa MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; compare a with memory contents (data is aa)
           bls  LF178          ; branch if lower or same
           bclr *CruiseStatus_2, #$%00000011    ; clear bits
           ldaa MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; load a with memory contents (data is aa)
           bra  LF17E          ; branch

   LF178:  cmpa MINSET_CruiseControlMinSetSpeedTimesTwo    ; compare a with memory contents (data is 46)
           bcc  LF180          ; branch if greater or equal
           clra                ; a = 0
   LF17E:  staa CruiseSpeedSetpoint    ; store a into memory
   LF180:  stab CruiseControlVar3    ; store b into memory
   LF182:  jmp  LF28E      

   LF185:  brset *CruiseStatus_1, #$%00100000, LF182    ; branch if bit(s) set
           brset *CruiseStatus_1, #$%00001000, LF1A3    ; branch if bit(s) set
           cmpb CRUZ47_UnknownConstForCruiseControl47    ; compare b with memory contents (data is 2f)
           bls  LF182          ; branch if lower or same
           bset *CruiseStatus_1, #$%00001000    ; set bits
           bset *CruiseStatus_2, #$%00001000    ; set bits
           ldaa Temp0          ; load a with memory contents
           adda CRUZ34_UnknownConstForCruiseControl34    ;  (data is 20)
           bcc  LF1A1          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LF1A1:  staa CruiseControlVar0    ; store a into memory
   LF1A3:  ldaa Temp0          ; load a with memory contents
           cmpa MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; compare a with memory contents (data is aa)
           bcs  LF1B1          ; branch if lower
           bset *CruiseStatus_1, #$%00100000    ; set bits
           ldab CruiseControlVar3    ; load b with memory contents
           bra  LF213          ; branch

   LF1B1:  ldab CruiseStatus_2   ; load b with memory contents
           cmpb #0xa0          ;  -10100000-
           bcs  LF182          ; branch if lower
           ldab CruiseControlVar0    ; load b with memory contents
           subb CRUZ33_UnknownConstForCruiseControl33    ; subtract memory contents from b (data is 01)
           bcc  LF1BF          ; branch if greater or equal
           clrb                ; b = 0
   LF1BF:  cmpb MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; compare b with memory contents (data is aa)
           bcc  LF1D5          ; branch if greater or equal
           adda CRUZ35_UnknownConstForCruiseControl35    ;  (data is 0c)
           bcs  LF1D2          ; branch if lower
           cba             
           bls  LF1D5          ; branch if lower or same
           tab                 ; b = a
           cmpb MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; compare b with memory contents (data is aa)
           bls  LF1D5          ; branch if lower or same
   LF1D2:  ldab MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; load b with memory contents (data is aa)
   LF1D5:  stab CruiseControlVar0    ; store b into memory
           bra  LF182          ; branch

   LF1D9:  bclr *CruiseStatus_1, #$%00000010    ; clear bits
           brset *CruiseStatus_1, #$%10000000, LF1E7    ; branch if bit(s) set
           ldaa CRUZ7_UnknownTableForCruiseControl7    ; load a with memory contents (data is 00)
           bita #0x80          ;  -10000000-
           bne  LF229          ; branch if not equal (not zero)
   LF1E7:  ldaa CruiseSpeedSetpoint    ; load a with memory contents
           beq  LF1EE          ; branch if equal (zero)
           bclr *CruiseStatus_1, #$%00100000    ; clear bits
   LF1EE:  brclr *CruiseStatus_1, #$%00001000, LF229    ; branch if bit(s) clear
           ldaa Counter_Cruise_3    ; load a with memory contents
           cmpa #0x5d          ; compare a with value -01011101-
           bhi  LF202          ; branch if higher
           bclr *CruiseStatus_1, #$%00001000    ; clear bits
           bclr *CruiseStatus_2, #$%00001000    ; clear bits
           stab CruiseControlVar0    ; store b into memory
           bra  LF229          ; branch

   LF202:  ldaa Temp0          ; load a with memory contents
           adda #0x04          ;  -00000100-
           suba CruiseSpeedSetpoint
           bcc  LF20B          ; branch if greater or equal
           clra                ; a = 0
   LF20B:  ldx  #CRUZ6_UnknownTableForCruiseControl6        ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           orab #0x80          ;  -10000000-
   LF213:  ldaa Temp0          ; load a with memory contents
           staa CruiseSpeedSetpoint    ; store a into memory
           bclr *CruiseStatus_1, #$%00001100    ; clear bits
           bclr *CruiseStatus_2, #$%00001000    ; clear bits
           clra                ; a = 0
           staa CruiseControlVar0    ; store a into memory
           staa Counter_Cruise_3    ; store a into memory
           tstb            
           bmi  LF226          ; branch if minus(hi bit 1)
           clrb                ; b = 0
   LF226:  jmp  LF169      

   LF229:  clrb                ; b = 0
           stab Counter_Cruise_3    ; store b into memory
           ldaa CruiseStatus_2   ; load a with memory contents
           eora #0x04          ; XOR a with value -00000100-
           bita #0x07          ;  -00000111-
           bne  LF28E          ; branch if not equal (not zero)
           ldaa Counter_MainLoop    ; load a with memory contents
           bne  LF28E          ; branch if not equal (not zero)
           ldab Counter_Cruise    ; load b with memory contents
           incb            
           cmpb CRUZ26_UnknownConstForCruiseControl26    ; compare b with memory contents (data is 02)
           bcs  LF244          ; branch if lower
           bclr *CruiseStatus_2, #$%00000100    ; clear bits
           clrb                ; b = 0
   LF244:  stab Counter_Cruise    ; store b into memory
           bra  LF28E          ; branch

   LF248:  ldaa CruiseSpeedSetpoint    ; load a with memory contents
           ldx  #SETPW_CruiseControlSetupPulseForSet_FromSpeed        ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           bpl  LF254          ; branch if plus (hi bit 0)
           ldab #0x7f          ; load b with value -01111111-
   LF254:  stab Temp1          ; store b into memory
           ldaa MapValue       ; load a with memory contents
           suba BaroPressure
           bcc  LF25F          ; branch if greater or equal
           tab                 ; b = a
           eorb #0x80          ;  -10000000-
   LF25F:  bpl  LF266          ; branch if plus (hi bit 0)
           lsla                ; logical shift left a
           ldaa #0x80          ; load a with value -10000000-
           sbca #0x00          ;  -00000000-
   LF266:  adda #0x80          ;  -10000000-
           ldx  #RESTBL_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference        ; load index with value
           jsr  Lookup4ByteTable    ; call subroutine
           ldab Temp1          ; load b with memory contents
           lslb            
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           bpl  LF278          ; branch if plus (hi bit 0)
           ldaa #0x7f          ; load a with value -01111111-
   LF278:  ldx  #L002F         ; load index with value
           ldab CruiseSpeedSetpoint    ; load b with memory contents
           cmpb CRUZ36_UnknownConstForCruiseControl36    ; compare b with memory contents (data is 8c)
           bls  LF283          ; branch if lower or same
           inx                 ; increment index (x=x+1)
   LF283:  adda 0x00, X    
           bpl  LF28D          ; branch if plus (hi bit 0)
           bvs  LF28B          ; branch if no overflow
           clra                ; a = 0
           rts                 ; return from subroutine

   LF28B:  ldaa #0x7f          ; load a with value -01111111-
   LF28D:  rts                 ; return from subroutine

   LF28E:  brset *CruiseStatus_1, #$%10000000, LF2A3    ; branch if bit(s) set
           inc  Counter_Cruise_1
           brclr *CruiseStatus_1, #$%00011000, LF2A3    ; branch if bit(s) clear
           inc  Counter_Cruise_1
           brset *CruiseStatus_1, #$%00001000, LF2A3    ; branch if bit(s) set
           inc  Counter_Cruise_1
   LF2A3:  ldaa CruiseStatus_2   ; load a with memory contents
           adda #0x10          ;  -00010000-
           cmpa #0xb0          ; compare a with value -10110000-
           bcs  LF2AD          ; branch if lower
           anda #0x0f          ; AND a with value -00001111-
   LF2AD:  staa CruiseStatus_2   ; store a into memory
           anda #0xf0          ; AND a with value -11110000-
           beq  LF2B6          ; branch if equal (zero)
           jmp  LF537      

   LF2B6:  clrb                ; b = 0
           brclr *BitFlags6f, #b6f_BadSpeedo1, LF2BE    ; branch if bit(s) clear
           jmp  LF394      

   LF2BE:  ldY #InverseVehicleSpeed_HB    ; load Y index -00000000 01001010-
           ldx  #0xd000        ; load index with value
           ldd  #0x06dd        ; load d (a&b) with value -00000110 11011101-
           brclr *TimerOverflowsBetweenSpeedoPulses, #$%11111111, LF2D9    ; branch if bit(s) clear
           clrb                ; b = 0
           clra                ; a = 0
           brset *TimerOverflowsBetweenSpeedoPulses, #$%01000000, LF2DC    ; branch if bit(s) set
           ldab #0x06          ; load b with value -00000110-
           deY                 ; decrement Y
           ldx  #0xddd0        ; load index with value
   LF2D9:  jsr  CalculateVehicleSpeedOrEngineRpms    ; call subroutine
   LF2DC:  ldx  VehicleSpeed_HB
           stx  Temp0          ; store index into memory
           stD *VehicleSpeed_HB    ; store D to RAM
           brclr *CruiseStatus_2, #$%00000010, LF351    ; branch if bit(s) clear
           ldaa Counter_Cruise    ; load a with memory contents
           brclr *CruiseStatus_2, #$%00000001, LF2FC    ; branch if bit(s) clear
           cmpa CRMASK_CruiseMask    ; compare a with memory contents (data is 11)
           bcc  LF2F6          ; branch if greater or equal
           inca                ; increment a
           staa Counter_Cruise    ; store a into memory
           bra  LF351          ; branch

   LF2F6:  bclr *CruiseStatus_2, #$%00000001    ; clear bits
           clra                ; a = 0
           staa Counter_Cruise    ; store a into memory
   LF2FC:  cmpa CRSCN1_CruiseComapreConstant1    ; compare a with memory contents (data is 16)
           bcs  LF353          ; branch if lower
           ldab CruiseControlVar6    ; load b with memory contents
           tba                 ; a = b
           bpl  LF307          ; branch if plus (hi bit 0)
           negb            
   LF307:  cmpb CRSCN2_CruiseComapreConstant2    ; compare b with memory contents (data is 06)
           bcs  LF34B          ; branch if lower
           ldx  #L002F         ; load index with value
           ldab CruiseSpeedSetpoint    ; load b with memory contents
           cmpb CRUZ36_UnknownConstForCruiseControl36    ; compare b with memory contents (data is 8c)
           bls  LF317          ; branch if lower or same
           inx                 ; increment index (x=x+1)
   LF317:  ldab 0x00, X        ; load b with memory at index + value
           adda 0x02, X    
           bvc  LF322          ; branch if overflow
           lsla                ; logical shift left a
           ldaa #0x80          ; load a with value -10000000-
           sbca #0x00          ;  -00000000-
   LF322:  staa 0x02, X    
           cmpa CRMSK2_CruiseMask2    ; compare a with memory contents (data is 07)
           bgt  LF33B          ; branch if greater
           cmpa CRMSK3_CruiseMask3    ; compare a with memory contents (data is f6)
           bge  LF34B          ; branch if greater or equal
           subb CRMSK4_CruiseMask4    ; subtract memory contents from b (data is 02)
           cmpb CRMSK5_CruiseMask5    ; compare b with memory contents (data is e1)
           bge  LF346          ; branch if greater or equal
           ldab CRMSK5_CruiseMask5    ; load b with memory contents (data is e1)
           bra  LF346          ; branch

   LF33B:  addb CRMSK7_CruiseMask7    ;  (data is 01)
           cmpb CRMSK6_CruiseMask6    ; compare b with memory contents (data is 1f)
           ble  LF346          ; branch if less or equal
           ldab CRMSK6_CruiseMask6    ; load b with memory contents (data is 1f)
   LF346:  stab 0x00, X    
           clra                ; a = 0
           staa 0x02, X    
   LF34B:  bclr *CruiseStatus_2, #$%00000010    ; clear bits
           clra                ; a = 0
           staa Counter_Cruise    ; store a into memory
   LF351:  bra  LF37D          ; branch

   LF353:  inca                ; increment a
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
           bmi  LF372          ; branch if minus(hi bit 1)
           ldab CruiseControlVar6    ; load b with memory contents
           bpl  LF36B          ; branch if plus (hi bit 0)
           comb            
           incb            
   LF36B:  cba             
           ble  LF37D          ; branch if less or equal
           staa CruiseControlVar6    ; store a into memory
           bra  LF37D          ; branch

   LF372:  ldab CruiseControlVar6    ; load b with memory contents
           bmi  LF378          ; branch if minus(hi bit 1)
           comb            
           incb            
   LF378:  cba             
           bge  LF37D          ; branch if greater or equal
           staa CruiseControlVar6    ; store a into memory
   LF37D:  ldd  Temp0          ; load d (a&b) with memory contents
           subd VehicleSpeed_HB    ; d = d - memory contents
           bne  LF386          ; branch if not equal (not zero)
           clr  CruiseControlVar1    ; zero byte at memory location
   LF386:  stD *Temp0          ; store D to RAM
           clra                ; a = 0
           ldab CruiseControlVar1    ; load b with memory contents
           bpl  LF38E          ; branch if plus (hi bit 0)
           deca                ; decrement a
   LF38E:  addd Temp0          ; d = d + memory contents
           asra            
           rorb            
           bsr  LF398          ; call subroutine
   LF394:  stab CruiseControlVar1    ; store b into memory
           bra  LF3A9          ; branch

   LF398:  asld                ; shift left (d=d*2)
           bcs  LF3A1          ; branch if lower
           tsta                ; test a
           beq  LF3A7          ; branch if equal (zero)
           ldab #0x7f          ; load b with value -01111111-
           rts                 ; return from subroutine

   LF3A1:  cmpa #0xff          ; compare a with value -11111111-
           beq  LF3A6          ; branch if equal (zero)
           clrb                ; b = 0
   LF3A6:  sec                 ; set carry
   LF3A7:  rorb            
           rts                 ; return from subroutine

   LF3A9:  brset *CruiseStatus_1, #$%10000000, LF3FD    ; branch if bit(s) set
           ldx  #VACREG_CruiseControlVacRegularGainGurve_FromDeltaSpeed    ; load index with value
           clrb                ; b = 0
           ldaa CruiseSpeedSetpoint    ; load a with memory contents
           brclr *CruiseStatus_1, #$%00011000, LF3B9    ; branch if bit(s) clear
           ldaa CruiseControlVar0    ; load a with memory contents
   LF3B9:  lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           subd VehicleSpeed_HB    ; d = d - memory contents
           bcc  LF400          ; branch if greater or equal
           bclr *CruiseStatus_1, #$%00000100    ; clear bits
           ldx  #VENTRG_CruiseControlVentRegularGainCurve_FromDeltaSpeed    ; load index with value
           coma            
           comb            
           addd #0x0001         ;  -00000000 00000001-
           stab Temp0          ; store b into memory
           tsta                ; test a
           beq  LF3D3          ; branch if equal (zero)
           bset *Temp0, #$%11111111    ; set bits
   LF3D3:  lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           brclr *CruiseStatus_1, #$%00010000, LF3E3    ; branch if bit(s) clear
           ldx  #CRUZ1_UnknownTableForCruiseControl1    ; load index with value
           tsta                ; test a
           beq  LF416          ; branch if equal (zero)
           ldaa #0xff          ; load a with value -11111111-
           bra  LF417          ; branch

   LF3E3:  tsta                ; test a
           bne  LF3F7          ; branch if not equal (not zero)
           cmpb VNTAB1_CruiseControlLimitToAMaxVent    ; compare b with memory contents (data is 90)
           bcc  LF3F7          ; branch if greater or equal
           tba                 ; a = b
           ldab Temp0          ; load b with memory contents
           cmpa VNTAB2_CruiseControlLimitToHalfMaxVent    ; compare a with memory contents (data is 60)
           bcs  LF416          ; branch if lower
           ldaa #0x05          ; load a with value -00000101-
           bra  LF3F9          ; branch

   LF3F7:  ldaa #0x0f          ; load a with value -00001111-
   LF3F9:  oraa #0x80          ;  -10000000-
           staa CruiseControlVar3    ; store a into memory
   LF3FD:  jmp  LF537      

   LF400:  brclr *CruiseStatus_1, #$%00001100, LF409    ; branch if bit(s) clear
           ldx  #VACACC_CruiseControlVacAcceleratedGainCurve_FromDeltaSpeed    ; load index with value
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
   LF409:  tsta                ; test a
           beq  LF40E          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   LF40E:  cmpb ACLRST_CruiseControlDeltaSpeedToResetAccFlag    ; compare b with memory contents (data is 09)
           bcc  LF416          ; branch if greater or equal
           bclr *CruiseStatus_1, #$%00000100    ; clear bits
   LF416:  tba                 ; a = b
   LF417:  jsr  Lookup4ByteTable    ; call subroutine
           clra                ; a = 0
           tstb            
           bpl  LF41F          ; branch if plus (hi bit 0)
           deca                ; decrement a
   LF41F:  stD *Temp0          ; store D to RAM
           ldx  #THGAIN_CruiseControlThrottleGainFactor_FromThrottle        ; load index with value
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bcc  LF42B          ; branch if greater or equal
           clra                ; a = 0
   LF42B:  jsr  Lookup4ByteTable    ; call subroutine
           staa Temp3          ; store a into memory
           ldx  #SPGAIN_CruiseControlSpeedGainFactor_FromSpeed        ; load index with value
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    ; call subroutine
           adda Temp3      
           bcc  LF441          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LF441:  staa Temp3          ; store a into memory
           clra                ; a = 0
           staa Temp2          ; store a into memory
           ldab CruiseControlVar1    ; load b with memory contents
           bpl  LF44B          ; branch if plus (hi bit 0)
           deca                ; decrement a
   LF44B:  asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd Temp0          ; d = d + memory contents
           stD *Temp0          ; store D to RAM
           brset *CruiseStatus_2, #$%00000100, LF47D    ; branch if bit(s) set
           bpl  LF45C          ; branch if plus (hi bit 0)
           coma            
           comb            
           addd #0x0001         ;  -00000000 00000001-
   LF45C:  tsta                ; test a
           beq  LF461          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   LF461:  cmpb CRUZ24_UnknownConstForCruiseControl24    ; compare b with memory contents (data is 00)
           bhi  LF47D          ; branch if higher
           clrb                ; b = 0
           ldaa CruiseSpeedSetpoint    ; load a with memory contents
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           subd VehicleSpeed_HB    ; d = d - memory contents
           bpl  LF475          ; branch if plus (hi bit 0)
           coma            
           comb            
           addd #0x0001         ;  -00000000 00000001-
   LF475:  tsta                ; test a
           bne  LF47D          ; branch if not equal (not zero)
           cmpb CRUZ25_UnknownConstForCruiseControl25    ; compare b with memory contents (data is 30)
           bls  LF49A          ; branch if lower or same
   LF47D:  clra                ; a = 0
           ldab CruiseControlVar2    ; load b with memory contents
           bpl  LF483          ; branch if plus (hi bit 0)
           deca                ; decrement a
   LF483:  addd Temp0          ; d = d + memory contents
           staa Temp4          ; store a into memory
           bpl  LF48E          ; branch if plus (hi bit 0)
           coma            
           comb            
           addd #0x0001         ;  -00000000 00000001-
   LF48E:  cmpD Temp2          ; compare D
           bcc  LF49D          ; branch if greater or equal
           ldaa Temp4          ; load a with memory contents
           bpl  LF498          ; branch if plus (hi bit 0)
           negb            
   LF498:  stab CruiseControlVar2    ; store b into memory
   LF49A:  jmp  LF537      

   LF49D:  clra                ; a = 0
           staa CruiseControlVar2    ; store a into memory
           ldaa Temp4          ; load a with memory contents
           anda #0x80          ; AND a with value -10000000-
           ldab CruiseControlVar3    ; load b with memory contents
           beq  LF4AF          ; branch if equal (zero)
           bpl  LF49A          ; branch if plus (hi bit 0)
           tab                 ; b = a
           eorb CruiseControlVar3
           bpl  LF49A          ; branch if plus (hi bit 0)
   LF4AF:  ldab TpsVolts       ; load b with memory contents
           subb MINTHR_LowestSessionTPS    ; b = b-memory contents
           bcc  LF4B6          ; branch if greater or equal
           clrb                ; b = 0
   LF4B6:  tsta                ; test a
           bpl  LF4E0          ; branch if plus (hi bit 0)
           oraa CRUZ28_UnknownConstForCruiseControl28    ;  (data is 01)
           brclr *CruiseStatus_1, #$%00010000, LF4C5    ; branch if bit(s) clear
           adda CRUZ30_UnknownConstForCruiseControl30    ;  (data is 01)
           bra  LF507          ; branch

   LF4C5:  staa Temp4          ; store a into memory
           clra                ; a = 0
           cmpb CLOTHR_CruiseControlDontVentIfThrottleBelowThis    ; compare b with memory contents (data is 01)
           bcs  LF507          ; branch if lower
           ldx  #CRUZ4_UnknownTableForCruiseControl4    ; load index with value
           stx  Temp2          ; store index into memory
           ldx  #CRUZ5_UnknownTableForCruiseControl5    ; load index with value
           bsr  LF50B          ; call subroutine
           oraa #0x80          ;  -10000000-
           ldab Temp4          ; load b with memory contents
           cba             
           bcc  LF507          ; branch if greater or equal
           bra  LF506          ; branch

   LF4E0:  cmpb MAXTHR_CruiseControlDontVacIfThrottleAboveThis    ; compare b with memory contents (data is 66)
           bcc  LF507          ; branch if greater or equal
           oraa CRUZ27_UnknownConstForCruiseControl27    ;  (data is 01)
           brclr *CruiseStatus_1, #$%00001000, LF4F1    ; branch if bit(s) clear
           adda CRUZ29_UnknownConstForCruiseControl29    ;  (data is 01)
           bra  LF507          ; branch

   LF4F1:  brset *CruiseStatus_1, #$%00000100, LF507    ; branch if bit(s) set
           staa Temp4          ; store a into memory
           ldx  #CRUZ2_UnknownTableForCruiseControl2    ; load index with value
           stx  Temp2          ; store index into memory
           ldx  #CRUZ3_UnknownTableForCruiseControl3    ; load index with value
           bsr  LF50B          ; call subroutine
           ldab Temp4          ; load b with memory contents
           cba             
           bcc  LF507          ; branch if greater or equal
   LF506:  tba                 ; a = b
   LF507:  staa CruiseControlVar3    ; store a into memory
           bra  LF537          ; branch

   LF50B:  clrb                ; b = 0
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
           jsr  LF398          ; call subroutine
           tba                 ; a = b
           adda #0x80          ;  -10000000-
           jsr  Lookup4ByteTable    ; call subroutine
           ldx  Temp2      
           staa Temp2          ; store a into memory
           ldd  Temp0          ; load d (a&b) with memory contents
           jsr  LF398          ; call subroutine
           tba                 ; a = b
           adda #0x80          ;  -10000000-
           jsr  Lookup4ByteTable    ; call subroutine
           ldab Temp2          ; load b with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           rts                 ; return from subroutine

   LF537:  ldaa PIA2_Buffer    ; load a with memory contents
           anda #~(pi2_SCVent | pi2_SCVac)          ; AND a with value -11111100-
           brset *CruiseStatus_1, #$%10000000, LF550    ; branch if bit(s) set
           ldab CruiseControlVar3    ; load b with memory contents
           beq  LF552          ; branch if equal (zero)
           bpl  LF554          ; branch if plus (hi bit 0)
           brclr *CruiseStatus_1, #$%00010000, LF550    ; branch if bit(s) clear
           ldab Counter_Cruise_3    ; load b with memory contents
           incb            
           beq  LF550          ; branch if equal (zero)
           stab Counter_Cruise_3    ; store b into memory
   LF550:  oraa #pi2_SCVent | pi2_SCVac          ;  -00000011-
   LF552:  oraa #pi2_SCVent          ;  -00000010-
   LF554:  staa PIA2_Buffer    ; store a into memory
           ldab CruiseControlVar3    ; load b with memory contents
           beq  LF566          ; branch if equal (zero)
           asld                ; shift left (d=d*2)
           tstb            
           beq  LF563          ; branch if equal (zero)
           subb #0x02          ;  -00000010-
           beq  LF563          ; branch if equal (zero)
           lsrd                ; shift right (d=d/2)
   LF563:  stab CruiseControlVar3    ; store b into memory
           rts                 ; return from subroutine

   LF566:  brclr *CruiseStatus_2, #$%00000001, LF56D    ; branch if bit(s) clear
           bset *CruiseStatus_2, #$%00000010    ; set bits
   LF56D:  rts                 ; return from subroutine

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
	bset	*PIA1_Buffer, #pi1_CEL
	bra	FlashCEL_OnKnock_return
KnockDetect_LightCEL:
	bclr	*PIA1_Buffer, #pi1_CEL
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
CalculateAntiLagRetard_Routine_MM:
       ldaa #0x00                                     ; load 0x00 into A, default anti-lag retard
; check that the option is enabled...
       ldx  #OPTN1_CalCustomOptionConfigFlags1
       brclr 0, X, #opt_AntiLag, AntiLag_return
; check the conditions for anti-lag - 1st check for staging limiter, then for WOT
       ldx  #Turbonator_Flags
       brset 0, x, #Turbonator_Staging, L3000           ;if the staging limiter is active, ignore WOT requirement
       brclr *BitFlags66, #b66_FullThrottle, AntiLag_return
L3000:       
       ldx  #ANTLAG_AntiLagRetardfromBoostGoalDelta   ; load index with value
       ldab 0x01,x                                    ; load minimum Delta MAP reference from the table
       addb BaroPressure                              ; check if MAP is higher than the minimum...
       cmpb MapValue
       bcc  AntiLag_return
       ldab BoostTarget                               ; load the target boost
       subb MapValue                                  ; subtract the actual MAP value
       bcs  AntiLag_return	                      ; branch if greater or equal - no need for antilag
       tba
       jsr  Lookup4ByteTable                          ; call subroutine
       lsra                                           ; divide result by 2
       lsra                                           ; divide result by 2
       lsra                                           ; divide result by 2
       lsra                                           ; divide result by 2
       lsra                                           ; divide result by 2 - total dived by 32
AntiLag_return:
       staa AntiLagRetard                             ; store the antilag retard
       rts
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
ControlShiftLight_MM:
       brclr *Counter_MainLoop, #$%00010000, ShiftLight_Return
       ldx   OPTN1_CalCustomOptionConfigFlags1
       brclr 0, X, #opt_ShiftLight, ShiftLight_Return
       brclr *BitFlags6d, #b6d_FuelEngineNotRunning, ShiftLight_Run

ShiftLight_Setup:
       ; still need to figure this out...
       ;
       ; use brake pedal to engage the setup, and the throttle to adjust?
       ; press brake pedal 3 times in 2 sec to engage setup (with engine not running, obviously)
       ; then press throttle to indicate shift rpm on tach and press brake again to set
       ; to set 2nd point, press brake 4 times in 2 sec, otherwise same procedure...
       ;
       ; need to figure out how to time the tach pulses to do this right, might be difficult to do
       ;
       ; for testing, I can do this with only constants, not variables...
       ; should run with only this line in the "setup" routine...

       bra ShiftLight_Return

ShiftLight_Run:
       ldx  EngineRpm_HB
       cpx  SLRPM_ShiftLightSetpoint
       bcc  ShiftLight_TurnLightOff

ShiftLight_TurnLightOn:
       bset *PIA2_Buffer, #pi2_PTU
       bra  ShiftLight_Return

ShiftLight_TurnLightOff:
       bclr *PIA2_Buffer, #pi2_PTU

ShiftLight_Return:
       rts
       
;
;   -------------------------------------------------------
; 	Shift Light Control Routine
;   -------------------------------------------------------
; 
; 
; This routine will control the Anti-Dwell time relative to battery volts. 
; Similar to the lookups for T-SMEC and T-SBEC.
;

; CalculateDwell_MM:
;            ldaa BatteryVolts                            ; load a with memory contents
;            ldx  #DWELL_DwellTimeFromBatteryVoltsComp        ; lookup complement of dwell period
;            jsr  Lookup5ByteTable
;            comb
;            coma                                         ; now AccD contains the dwell period
;            std  *DwellTime_HB
;            addd MINADW_MinAntiDwellPeriod
;            xgdx                                        ; X = DWELL+MINADW
;            dex
; 	   ldd  DistributorFallingEdgePulsewidth_HB    ; load d with DISTPW
;            cpx  DistributorFallingEdgePulsewidth_HB    ; X - DISTPW
; 	   bcs  UseMaxDwell                            ; branch if DWELL+MINADW < DISTPW
; 	   ldd  MINADW_MinAntiDwellPeriod              ; DWELL+MINADW > DISTPW, so use MINADW
; 	   bra  StoreAntiDwell
; UseMaxDwell:
; 	   subd DwellTime_HB
; StoreAntiDwell:
; 	   stD *AntiDwellTime_HB	    ; store D to RAM



    .org	0xFEA0
ShelSoftCopyrightNotice:
    .str	"Turbonator mods and brand Copr. 2011 Rob Lloyd "
    .str        "Turbonator T3 v1"

    .org        0xFFB0
ChryslerCopyrightNotice:
    .str	"COPR. 1990 CHRYSLER CORP. "

    .org        0xffd6
SCI_Interrupt_vector:
		.word	Interrupt_SerialCommunications
SPIE_Flag_Interrupt_vector:
		.word	InterruptPointer_SerialPeripheralInterface
PAII_Flag_Interrupt_vector:
		.word	InterruptPointer_PulseAccumulatorInputEdge
PAOVI_Flag_Interrupt_vector:
		.word	InterruptPointer_PulseAccumulatorOverflow
TOI_Flag_Interrupt_vector:
		.word	InterruptPointer_TimerOverflow
OC5_Flag_Interrupt_vector:
		.word	InterruptPointer_DwellTimerB
OC4_Flag_Interrupt_vector:
		.word	InterruptPointer_DwellTimerA
OC3_Flag_Interrupt_vector:
		.word	InterruptPointer_TimerOC3_Wastegate
OC2_Flag_Interrupt_vector:
		.word	InterruptPointer_TimerOC2
OC1_Timer_Interrupt_vector:
		.word	InterruptPointer_TimerOutputCapture1
IC3_Timer_Interrupt_vector:
		.word	InterruptPointer_TimerInputCapture3
IC2_Timer_Interrupt_vector:
		.word	InterruptPointer_SpeedoSignal
IC1_Timer_Interrupt_vector:
		.word	InterruptPointer_CamSensorSignal
Realtime_Interrupt_vector:
		.word	InterruptPointer_RealTime
IRQ_hardware_Interrupt_vector:
		.word	InterruptPointer_CrankSensor_Signal
XIRQ_hardware_Interrupt_vector:
		.word	TinterruptPointer_XIRQ
SWI_Software_Interrupt_vector:
		.word	InterruptPointer_Software
Illegal_Opcode_vector:
		.word	InterruptPointer_BadOp
COP_Watchdog_Timeout_vector:
		.word	InterruptPointer_COPFail
Clock_Monitor_Fail_vector:
		.word	InterruptPointer_ClockMonFail
ResetVector:
		.word	Interrupt_SerialCommunications

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
;   ffd8 to ffd9 - SPIE Flag Interrupt vector: 9103
;   ffda to ffdb - PAII Flag Interrupt vector: 9106
;   ffdc to ffdd - PAOVI Flag Interrupt vector: 9109
;   ffde to ffdf - TOI Flag Interrupt vector: 910c
;   ffe0 to ffe1 - OC5 Flag Interrupt vector: 910f
;   ffe2 to ffe3 - OC4 Flag Interrupt vector: 9112
;   ffe4 to ffe5 - OC3 Flag Interrupt vector: 9115
;   ffe6 to ffe7 - OC2 Flag Interrupt vector: 9118
;   ffe8 to ffe9 - OC1 Timer Interrupt vector: 911b
;   ffea to ffeb - IC3 Timer Interrupt vector: 911e
;   ffec to ffed - IC2 Timer Interrupt vector: 9121
;   ffee to ffef - IC1 Timer Interrupt vector: 9124
;   fff0 to fff1 - Realtime Interrupt vector: 9127
;   fff2 to fff3 - IRQ hardware Interrupt vector: 912a
;   fff4 to fff5 - XIRQ hardware Interrupt vector: 912d
;   fff6 to fff7 - SWI Software Interrupt vector: 9130
;   fff8 to fff9 - Illegal Opcode vector: 9133
;   fffa to fffb - COP Watchdog Timeout vector: 9136
;   fffc to fffd - Clock Monitor Fail vector: 9139
;   fffe to ffff - Power on or external Reset vector: e000
;   ------------

        .msg "Assembly Complete..." ; these are just messages to display during assemble to let you know what's going on...
