	.title 1987 TurbonatorLMv13
	.area ROM (ABS)

; SET TABS to 4 if text appears jumbled
;  ____________________________________________________________________________
; /                                                                            \
; |   '87 T2 Turbonator LM codebase                                            |
; |   Mopar ECM                                                                |
; |   1987 Turbo II                                                            |
; |                                                                            |
; | Code and original design and data Copyright � 1985 by Chrysler Corporation |
; |                                                                            |
; | Other code modules are Copyright 2010 by Robert Lloyd		       |
; |                                                                            |
; |                                              			       |
; | 1) Replaced TRANSM with CONFIG - a full cal option flag constant similar   |
; |    to the CONFIG constant + OPTION flags used on the '89 T1. Changed all   |
; |    of the auto trans checks to look for the 'new' auto config flag. All    |
; |    of the new and previous cal options are configurable by config flags.   |
; |    This allows features to be added to the cal without the need to         |
; |    re-assemble the code.                                                   |
; |                                                                            |
; | 2) Added switchable boost. Similar in operation to the later code, but the |
; |    low setting is set by a single constant rather than a boost x rpm       |
; |    table (similar to the S60 implementation).                              |
; |                                                                            |
; | 3) Added alky injection control routine (with help from Brian Bucar on the |
; |    function of the system). The alky injection can control the pump and up |
; |    to 2 separate alky injectors, triggered by MAP constants. This uses the |
; |    Cruise, and EGR/Purge solenoids. So, cannot be used with those at the   |
; |    same time. Also cannot be used with the Speed Sensitive Aero option at  |
; |    at the same time. The code checks if both options are enabled, if they  |
; |    are, then neither will run.                                             |
; |                                                                            |
; | 4) Added Anti-lag Retard routine. This routine looks at the delta to boost |
; |    goal and pulls up to 16 deg based on this delta (could be configured    |
; |    for 32 degrees as well). It will only pull timing at WOT (and so should |
; |    no affect emmisions or driveability) except when the staging limiter is |
; |    active to help spoolup off the line for manual cars. There were some    |
; |    code changes to the staging limiter code to support this function. But  |
; |    the functionality of the staging limiter is the same as previous.       |
; |                                                                            |
; | 5) Staging Limiter Changes. Re-coded for simplicity. Added the option to   |
; |    enable the staging limiter by switch. Default is setup for the brake    |
; |    switch (useful for ATX cars).                                           |
; |                                                                            |
; | 6) Added WOT Battery volts target. This can be used to either increase or  |
; |    decrease (or turn off) the alternator output when at WOT.               |
; |                                                                            |
; \___________________________________________________________________________/


    chem2 title 87T2_Turbonator_LM_v12
    chem2 description 1987 Chrysler Turbo II Logic Module calibration Baseline
    chem2 author Rob Lloyd, Brian Bucar
    chem2 boost 12 psi
    chem2 inj 33 pph

; NOTE: the above information is strictly informative. Changing the numbers
; above will NOT change anything in the source. You must use ChEM to
; change the injectors and desired boost.
;
; ***********************************************************************
;
; Version 12
; 10/12/10 - Complete re-write of the code starting with a fresh dis-assembled
;            source. Converted naming conventions to be common with T-SMEC and
;            T_SBEC whereever possible for variables, table data and
;            subroutines.
;          - Added Battery Volts Target for WOT operation. Allows you to set a
;            different bat volts at WOT to either disable the alternator
;            (by setting the value low) or to increase the output (by setting 
;            it high).
;          - Added several stock 2.2 templates including the SL 2.2 Auto cal.
;
; Version 12.1
; 02/01/11 - Fixed the definitions for STRNTR_SparkStartRunTransferPointRpm and
;            RNSTTR_SparkRunStartTransferPointRpm that was causing a starting 
;            issue.
; 
; Version 12.2
; 02/08/11 - Added the CEFlash routine call from the main loop (omitted by mis-
;            take.
;          
; Version 12.3
; 02/10/11 - Removed the WOT Battery volts target code that was causing a
;            no-start condition.
;
; Version 12.4
; 02/23/11 - Changed the STRNTR and RNSTTR values back to 16-bit constant
;            lookups like v10 (and the same as T-SMEC).
;          - Changed the scale of the speed cutoof in the staging limiter from 
;            0-127mph to 0-255mph.
;          - Fixed the RPM references for many constant/table values.
;          - Fixed the Error Bit reference after the checksum routine.
;          - Removed the Alky code for now. Need to find more processor time to
;            re-enable it.
;
; Version 12.5
; 04/27/11 - Fixed the definition for the RTMAPE. Was not being scaled with MAP
;            correctly. Template change only.
;
; Version 13.0
; 06/06/11 - Updated .asm and template files to be MP Tuner 2 compatible.
;
;
; ***********************************************************************

version == 13

DataOrg == 0xc000 ; do not change these values
CodeOrg == 0xc900 ;C800

;
; Bit functions: (derived from Ladybug development)
; Many bytes in the RAM contain status bits. For each of these the address value
; was separated into bit numbers, for example BitFlags_7f has b7f_bit7 through b7f_bit0.
; As the function of the bits is decoded, a global replace is performed to replace
; the bit name with a meaningful name, like:
;
;       b7f_SparkEngineNotRunning   = $%10000000                 ;  -10000000-
;                                     ^ NOTE: no leading 0x
;
; When working with bits, you can add several together using the "or" operator | like this:
;
;       [b50_SparkEngineNotRunning | b50_BaroSolEnergized]      ;  -10100000-
;       ^  NOTE: Square brackets, not round              ^
;
; The inverse function ~ sets all bits except the ones specified, so:
;
;       ~b50_SparkEngineNotRunning                              ;  -01111111-
;
; You can combine the inverse ~ with the or | like this:
;
;       ~[b50_SparkEngineNotRunning | b50_BaroSolEnergized]     ;  -01011111-
;
; The intent here is to make the logical functionality of the code easier to follow.
;
; ***********************************************************************
; Calibration Template definition
; *****************************************************************************
;
; This template format will be used from T-LM v10 and later.
;
; I decided to switch to this format because it was getting clumsy
; trying to define the switches for all of the build options (MTX/ATX,
; 2.2/2.5, boost control, etc.). This way, all the calibration data can be
; kept together in 1 place.
;
; Filename format:
;
;    T-LM_[displ]_[trans]_[ID]_[version].asm
;
; For example, the 1st tempalte file I made was from the 89 T1 Auto:
;
;    T-LM_22_MTX_a171_T2.asm
;
; This way you can start your T-SMEC build with any calibration. Though,
; you may have to build a template file if you want a calibration that
; does not already have a template file.
;
;
; 
; !!! This line is now written by MP Tuner when you specify the template to build with. !!!

.define CalDataFile /F:\Thumbdrive\BoostButton\Products\Cal Data\Source Files\87T2_Master\v13\T-LM_25_MTX_CUST.tpl/

; only change the filename portion of this line; the '.asm' is not needed

; Currently supplied template files :
;
;    T-LM_21_MTX_A171_T2.v10
;
; More to be added later. Simply copy the filename above into the .define
; statement and it will assemble with those calibration values.

; *****************************************

;  ______________________
; |                      \
; |   CPU                |
; \______________________|

; Control Registers:
;
CPU_Port1_DataDirection	 == 0x0000
CPU_Port2_DataDirection	 == 0x0001
CPU_Port1_ControlRegister	 == 0x0002
; Pin   Mask    Bit Function            LM Pin
; 20    x80     7   knock kill (int)
; 19    x40     6   injector (int)
; 18    x20     5   power loss light    R4
; 17    x10     4   voltage reg
; 16    x08     3   cts bias (int)      R5
; 15    x04     2   injector 3-4        R3
; 14    x02     1   injector 1-2        R2
; 13    x01     0   speed sensor        R9

CPU_Port2_ControlRegister	 == 0x0003
; Pin   Mask    Bit Function            LM Pin
;       x80     7
;       x40     6
;       x20     5
; 12    x10     4   sci tx              R11
; 11    x08     3   sci rx              R13
; 10    x04     2   serial clock?
; 9     x02     1   anti-dwell          R6      anti-dwell on = spark, off = no spark
; 8     x01     0   dist reference      R10

CPU_PortX_DataDirection	                == 0x0004
CPU_PortY_DataDirection	                == 0x0005
CPU_PortX_ControlRegister	        == 0x0006
CPU_PortY_ControlRegister	        == 0x0007
CPU_TimerControlStatReg	                == 0x0008
CPU_Counter_HB	                        == 0x0009
CPU_Counter_LB	                        == 0x000a
CPU_OCR_HB	                        == 0x000b
CPU_OCR_LB	                        == 0x000c
CPU_ICR_HB	                        == 0x000d  ; used for distributor sync timer
CPU_ICR_LB	                        == 0x000e
CPU_PortX_ControlStatReg	        == 0x000f
CPU_SCI_ModeControlReg	                == 0x0010
CPU_SCI_TxRxCntrlReg	                == 0x0011
CPU_SCI_RxDataReg	                == 0x0012
CPU_SCI_TxDataReg	                == 0x0013
CPU_RAM_ControlReg	                == 0x0014
CPU_Count_Alt_HB	                == 0x0015
CPU_Count_Alt_LB	                == 0x0016
CPU_TimerControl1	                == 0x0017
CPU_TimerControl2	                == 0x0018
CPU_TimerStatus	                        == 0x0019
CPU_OCR2_HB	                        == 0x001a
CPU_OCR2_LB	                        == 0x001b
CPU_OCR3_HB	                        == 0x001c
CPU_OCR3_LB	                        == 0x001d
CPU_ICR2_HB	                        == 0x001e
CPU_ICR2_LB	                        == 0x001f

;  ______________________
; |                      \
; |   Memory             |
; \______________________|

; Battery-Backed RAM:

MINTHR_LowestSessionTPS	                == 0x0040
Timer_DacalCountdown	                == 0x0041
CurrentAisPosition	                == 0x0042
DCCOR1_AdaptiveWastegateCellBelowMAPPT	== 0x0043
DCCOR2_AdaptiveWastegateCellAboveMAPPT	== 0x0044
LowestHistoricalTPS	                == 0x0045
ErrorBitRegister0	                == 0x0046
    b46_errLostFJ2		= $%10000000	; 44 Loss of FJ2
    b46_errNothing		= $%01000000	; 45 Nothing (overboost)
    b46_errHighVoltage		= $%00100000	; 46 Battery Volts High
    b46_errLowVoltage		= $%00010000	; 47 Battery Volts Low
    b46_errStuckLean		= $%00001000	; 51 Lean condition
    b46_errStuckRich		= $%00000100	; 52 Rich Condition
    b46_errChecksum		= $%00000010	; 53 Prom Checksum
    b46_errDistSync		= $%00000001	; 54 Distributor Sync

ErrorBitRegister1	                == 0x0047
    b47_errAcCutoutRelay	= $%10000000	; 33 AC Cutout Relay
    b47_errSpeedCtlSolenoid	= $%01000000	; 34 Speed Ctl Solenoid
    b47_errRadFanRelay		= $%00100000	; 35 Radiator Fan Relay
    b47_errWastegateSolenoid	= $%00010000	; 36 Wastegate Solenoid
    b47_errBaroReadSolenoid	= $%00001000	; 37 Barometric Read Solenoid
    b47_errChargingSystem	= $%00000100	; 41 Charging System
    b47_errASDRelay		= $%00000010	; 42 Auto Shutdown Relay
    b47_errIgnitionCoil 	= $%00000001	; 43 Ignition Coil Control

ErrorBitRegister2	                == 0x0048
    b48_errCoolantTempSensor	= $%10000000	; 22 Coolant Temp Sensor
    b48_errChargeTempSensor	= $%01000000	; 23 Charge Temp Sensor
    b48_errTPS			= $%00100000	; 24 Throttle Position
    b48_errAIS			= $%00010000	; 25 AIS Motor
    b48_errInjectorCurrent	= $%00001000	; 26 Injector Current Limit Not Achieved
    b48_errInjectorDriver	= $%00000100	; 27 Injector Driver interface
    b48_errPurgeSolenoid	= $%00000010	; 31 Purge Solenoid
    b48_errEGR		        = $%00000001	; 32 Exh Gas Recirc Solenoid

ErrorBitRegister3	                == 0x0049
    b49_errNotCranked		= $%10000000	; 11 Engine Not Cranked Since Battery Disconnected
    b49_errMemPowerLost 	= $%01000000	; 12 Memory Standby Power Lost
    b49_errMapPneumatic 	= $%00100000	; 13 MAP Pneumatic
    b49_errMapElectrical	= $%00010000	; 14 MAP Electrical
    b49_errDistanceSensor	= $%00001000	; 15 Vehicle Distance Sensor
    b49_errBattVoltageSense	= $%00000100	; 16 Battery Voltage Sense
    b49_errEngineTooCool	= $%00000010	; 17 Engine Running Too Cool (thermostat)
    b49_errO2Sensor		= $%00000001	; 21 Oxygen Sensor

ErrorBitRegisterStored0	                == 0x004a
ErrorBitRegisterStored1	                == 0x004b
ErrorBitRegisterStored2	                == 0x004c
ErrorBitRegisterStored3	                == 0x004d
SlowCounter	                        == 0x004e
BitFlags_4f	                        == 0x004f
AutoCalCell0	                        == 0x0050
AutoCalCell1	                        == 0x0051
AutoCalCell2	                        == 0x0052
AutoCalCell3	                        == 0x0053
AutoCalCell4	                        == 0x0054
AutoCalCell5	                        == 0x0055
AutoCalCell6	                        == 0x0056
AutoCalCell7	                        == 0x0057
AutoCalCell8	                        == 0x0058
AutoCalCell9	                        == 0x0059
AutoCalCell10	                        == 0x005a
AutoCalCell11	                        == 0x005b
AutoCalCell12	                        == 0x005c
ChargeTempVolts	                        == 0x005d
Delta_MAP	                        == 0x005e
AISMotorBits	                        == 0x005f

; Volatile RAM:

BitFlags_AIS	                        == 0x0060
     b60_bit7			= $%10000000	;
     b60_bit6			= $%01000000	;
     b60_UseAIS		        = $%00100000	;
     b60_bit4			= $%00010000	;
     b60_ATXInGear		= $%00001000	;Auto in gear
     b60_ATXChngGear		= $%00000100	;Auto just changed gears
     b60_bit1			= $%00000010	;
     b60_bit0			= $%00000001	;

Z83_CPU_Port1_copy	                == 0x0061
    CPU_Port1_CruiseVent            = $%10000000    ; cruise vent         B6
    CPU_Port1_PurgeEGR              = $%01000000    ; purge / egr         B5
    CPU_Port1_CruiseVac             = $%00100000    ; cruise vac          B4
    CPU_Port1_ACclutch              = $%00010000    ; ac clutch out       B3
    CPU_Port1_FAN                   = $%00001000    ; fan                 R21
    CPU_Port1_Wastegate             = $%00000100    ; wastegate           R19
    CPU_Port1_ASD                   = $%00000010    ; asd relay           R17
    CPU_Port1_BaroRead              = $%00000001    ; baro read solenoid  R15
; NOTE: For above, 1 is OFF, 0 is ON.

CruiseStatus	                        == 0x0062
    b62_bit7                    = $%10000000    ; Cruise not enabled
    b62_bit6                    = $%01000000    ; Resuming
    b62_bit5                    = $%00100000    ;
    b62_bit4                    = $%00010000    ; Cruise Engaged
    b62_bit3                    = $%00001000    ;
    b62_bit2                    = $%00000100    ;
    b62_bit1                    = $%00000010    ;
    b62_bit0                    = $%00000001    ;

Counter_TimerRegHalfOverflowBetweenSpeedoPulses	 == 0x0063
PreviousVehicleSpeed_HB	                == 0x0064
PreviousVehicleSpeed_LB	                == 0x0065

; Inverse RPM is actually the time between pulses, so smaller numbers are higher RPMs
; 24 bit value
TimerOverflowsBetweenSpeedoPulses	== 0x0066
SpeedoSensorPulsewidth_HB	        == 0x0067
SpeedoSensorPulsewidth_LB	        == 0x0068

VehicleSpeed_HB	                        == 0x0069
VehicleSpeed_LB	                        == 0x006a
Timer_CruiseDecelerate	                == 0x006b
CruiseSpeedSetpoint	                == 0x006c
CruiseControlVar1	                == 0x006d
CruiseControlVar2	                == 0x006e
CruiseControlVar3	                == 0x006f
StackPtrTemp_HB	                        == 0x0070
StackPtrTemp_LB	                        == 0x0071
CalculatedSparkAdvance	                == 0x0072
BaroPressure	                        == 0x0073
ClearTheErrorTimer_0	                == 0x0074
ClearTheErrorTimer_1	                == 0x0075
Timer_OutOfClosedLoopMode	        == 0x0076
TimerOverflowsBetweenDistPulses	        == 0x0077
DistributorFallingEdgePulsewidth_HB	== 0x0078
DistributorFallingEdgePulsewidth_LB	== 0x0079
Counter_TimerPastHalfwayBetweenDistPulses	 == 0x007a
Timer_FuelMonitorOutputTimer_HB	        == 0x007b
Timer_FuelMonitorOutputTimer_LB	        == 0x007c
LastDistributorFallingEdgeTime_HB	== 0x007d
LastDistributorFallingEdgeTime_LB	== 0x007e
BitFlags_7f	                        == 0x007f
    b7f_bit7                    = $%10000000    ; Engine has knocked
    b7f_MapOutOfRange           = $%01000000    ; MAP error ?
    b7f_bit5                    = $%00100000    ; Staging Limiter Active
    b7f_bit4                    = $%00010000    ; Boost Above 5psi
    b7f_bit3                    = $%00001000    ; Dist Sync Error?
    b7f_bit2                    = $%00000100    ; Wastegate Control
    b7f_bit1                    = $%00000010    ; injector circuit 3-4
    b7f_bit0                    = $%00000001    ; injector circuit 1-2
; or, the bottom two bits are the current cylinder as 1-4-2-3

BitFlags_80	                        == 0x0080
    b80_BadMAP                  = $%10000000    ; Bad Map over/under Code 14/13
    b80_BadTPS                  = $%01000000    ; Bad TPS sensor Code
    b80_BadO2                    = $%00100000    ; Distributor sync Code 54?
    b80_WastegateLimpinMode     = $%00010000    ; Wastegate error Code 36
    b80_bit3                    = $%00001000    ; Battery voltage too high Code 46
    b80_bit2                    = $%00000100    ;   ?
    b80_BadCoolantTemp          = $%00000010    ; Bad coolant temp Code 22
    b80_BadChargeTemp           = $%00000001    ; Bad air temp sensor Code 23

BitFlags_81	                        == 0x0081
    b81_OffIdle                 = $%10000000    ; Throttle Pressed (off idle)
    b81_LowTpsUpdated           = $%01000000    ; LowestHistoricalTPS has been updated
    b81_bit5                    = $%00100000    ;   ? Oxygen Sensor Stuck?
    b81_bit4                    = $%00010000    ; Oxygen Sensor Has Been Outside .75V to .29V Range (Thus is returning a signal)
    b81_bit3                    = $%00001000    ; Throttle below half
    b81_O2Rich                  = $%00000100    ; Oxygen Sensor data currently not valid (just after starting)
    b81_bit1                    = $%00000010    ;   ? WHEN SET, DOESNT DO CLOSED LOOP STUFF? DOES CHECK RAM0077
    b81_FullThrottle            = $%00000001    ; Throttle Floored (full throttle)

BitFlags_82	                        == 0x0082
    b82_EngineNotRunning        = $%10000000    ; ENGINE RUNNING = 0, Engine not running = 1
    b82_bit6                    = $%01000000    ;
    b82_FuelRunMode             = $%00100000    ; Fuel Mode: 1 = Running, 0 = Starting
    b82_bit4                    = $%00010000    ; baro read processing done
    b82_DecayingFuelStartToRun  = $%00001000    ; 1 if still decaying fuel from start to run
    b82_bit2                    = $%00000100    ;   ? Currently in Open Loop mode
    b82_SparkStartMode          = $%00000010    ; Spark Mode: 1 = Starting, 0 = Running
    b82_bit0                    = $%00000001    ;   ? O2 sensor known bad

BitFlags_83	                        == 0x0083
    b83_bit7                    = $%10000000    ;
    b83_bit6                    = $%01000000    ;
    b83_bit5                    = $%00100000    ;
    b83_bit4                    = $%00010000    ;   ? ASD circuit set (code 42)
    b83_bit3                    = $%00001000    ;   ? Injector 2 circuit failure (code 27)
    b83_bit2                    = $%00000100    ;   ? Injector 1 circuit failure (code 26)
    b83_bit1                    = $%00000010    ; Cruise Control Enabled
    b83_bit0                    = $%00000001    ;

BitFlags_84	                        == 0x0084
    b84_bit7                    = $%10000000    ; Baud Rate Signal or TX Enable?
    b84_bit6                    = $%01000000    ; Car Speed Too High and Engine Speed Too Low and Idling
    b84_bit5                    = $%00100000    ; TransientEnrich1  ? Engine normal temp
    b84_bit4                    = $%00010000    ;   ? Dont Try Closed Loop
    b84_bit3                    = $%00001000    ; Fuel is shut off (overboost, overrev, StagingMod)
    b84_bit2                    = $%00000100    ; Diagnostics Mode
    b84_bit1                    = $%00000010    ; Cold Load Enrichment  ? Something with reg 74 ('89 Cal)
    b84_bit0                    = $%00000001    ;   ? Oxygen Sensor Bad, fan status?

BitFlags_85	                        == 0x0085
    b85_bit7                    = $%10000000    ;   ? Something todo with setting baro.
    b85_bit6                    = $%01000000    ;
    b85_bit5                    = $%00100000    ;
    b85_bit4                    = $%00010000    ;
    b85_bit3                    = $%00001000    ;
    b85_bit2                    = $%00000100    ;
    b85_bit1                    = $%00000010    ;
    b85_bit0                    = $%00000001    ;

PreviousMAP	                        == 0x0086
TargetIdleSpeed_HB	                == 0x0087
TargetIdleSpeed_LB	                == 0x0088
KeyOnOrEngineRunningTime	        == 0x0089
Counter_MainLoop1	                == 0x008a
SumOfFuelModifiers_HB	                == 0x008b
SumOfFuelModifiers_LB	                == 0x008c
InjectorPulsewidth_HB	                == 0x008d
InjectorPulsewidth_LB	                == 0x008e
EngineRpm_HB	                        == 0x008f
EngineRpm_LB	                        == 0x0090

MapVolts	                        == 0x0091
Block_MAP                               == 0x0092
AverageMAPValue	                        == 0x0092
MapBlockScratchValue	                == 0x0093
MapValue	                        == 0x0094
Factor_LeanoutOrEnrichTime_MAP	        == 0x0095

Block_TPS                               == 0x0096
AverageTPSVolts	                        == 0x0096
TpsBlockScratchValue	                == 0x0097
TpsVolts	                        == 0x0098
Factor_LeanoutOrEnrichTime_TPS	        == 0x0099

CoolantTemp	                        == 0x009a
AmbientAirTempVolts	                == 0x009b
O2SensorVolts	                        == 0x009c
LastChargeTempVolts	                == 0x009d
LastCoolantTempVolts	                == 0x009e
TPSVolts_11msUpdate	                == 0x009f
KnockVolts	                        == 0x00a0
BatteryVolts	                        == 0x00a1
TargetBatteryVolts	                == 0x00a2
Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached	 == 0x00a3
LeanoutFactor_HB	                == 0x00a4
LeanoutFactor_LB	                == 0x00a5
Timer_Leanout	                        == 0x00a6
BoostTarget	                        == 0x00a7
AntiLagRetard	                        == 0x00a8
Timer_BoostTimer	                == 0x00a9
CurrentWastegateDutyCycle	        == 0x00aa
Counter_PrimaryAndSecondaryRamp	== 0x00ab
PointerIntoAdaptiveMemory	        == 0x00ac
Timer_CountdownFromStartRunForAisFeedback	 == 0x00ad
MinimumTimerCountBeforeMainloopCanContinue	 == 0x00ae
Counter_SomethingWithDistributor	== 0x00af
Timer_CLTIME_ClosedLoopTimer	        == 0x00b0
Counter_AdaptiveMem_Erase	        == 0x00b1
Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop	 == 0x00b2
Timer_AisChanges	                == 0x00b3
AdaptiveCellUpdateTimer_IncrementedEveryDistRisingEdge	 == 0x00b4
SparkScatter	                        == 0x00b5
Temp0	                                == 0x00b6
Temp1	                                == 0x00b7
Temp2	                                == 0x00b8
Temp3	                                == 0x00b9
Temp4	                                == 0x00ba
Temp5	                                == 0x00bb
Temp6	                                == 0x00bc
Temp7	                                == 0x00bd
TimerControlStatReg_Mirror	        == 0x00be
FuelBaselineResult	                == 0x00bf
Counter_Port1ControlRegLoop	        == 0x00c0
DwellTime_HB	                        == 0x00c1
Counter_ErrorCodeFlasher	        == 0x00c2
Pulsewidth_PartThrottleEnrichment_HB	== 0x00c3
Pulsewidth_PartThrottleEnrichment_LB	== 0x00c4
Counter_Over5psiBoost	                == 0x00c5
Timer_Over5PSIBoost	                == 0x00c6
ADScanIndex	                        == 0x00c7
PTEPWOver32	                        == 0x00c8
BitFlags_C9	                        == 0x00c9
Timer_OpenLoopFraction	                == 0x00ca
Timer_O2ToggleDuration	                == 0x00cb
Counter_FallingEdgeEPP_MaxFF	        == 0x00cc
Timer_DelayBeforeUpdating_MINTHR	== 0x00cd
Cylinder2Retard	                        == 0x00ce
Cylinder1Retard	                        == 0x00cf
Cylinder3Retard	                        == 0x00d0
Cylinder4Retard	                        == 0x00d1
MaxRetardFromMAP	                == 0x00d2
Timer_VoltageRegSignal	                == 0x00d3
InjectorLatency	                        == 0x00d4
Counter_BaroReadTime	                == 0x00d5
Timer_RadSteamingCountdown	        == 0x00d6
Timer_NormalDwell	                == 0x00d7
Timer_NavigatorFuelPulsewidth	        == 0x00d8
Timer_FuelShutoff	                == 0x00d9
WastegateDutyCycleIncreaseFromKnock	== 0x00da
Timer_BoostErrTimer	                == 0x00db
VerySlowCounter2point6seconds	        == 0x00dc
KnockLookup	                        == 0x00dd
BaroReadTimeEngineWithinReadRange	== 0x00de
CruiseControlVar4	                == 0x00df
Timer_ThermostatDiagnostics	        == 0x00e0
FuelSubtractedFromStartToRun	        == 0x00e1
DesiredNewAisPosition	                == 0x00e2
Counter_A2DScan2	                == 0x00e3
Timer_AisOrO2Sensor	                == 0x00e4
IncrementalMAP	                        == 0x00e5
Bits_WhichInjector	                == 0x00e6
Timer_MinimumFanRun	                == 0x00e7
BankEnrichmentFactor	                == 0x00e8 ; MapCorrectionForWasteGate - this value is stored, but never used
MapCorrectionForWasteGate	        == 0x00e8
BaseFuelModifier	                == 0x00e9


;  ______________________
; |                      \
; |   Hardware           |
; \______________________|

; ***********************************************************************************
; ONLY Change here if you are remapping the hardware addresses, otherwise DON'T TOUCH
; ***********************************************************************************
Z83Mapping                  = 0x2000   ; address for Z83 I/O port mapping
Z22Mapping                  = 0x4000   ; address for Z22 Timer mapping
Z85Mapping                  = 0x8000   ; address for Z85 A/D converter mapping
Z51Mapping                  = 0xc000   ; address for ROM begin mapping


; ***********
; Z83 IO Port
; ***********
Z83_IOPortADataCA1          = Z83Mapping

Z83_PortAdata               = Z83Mapping + 2
; Pin   Mask    Bit Function            LM Pin
; 11    x80     7   cruise vent         B6
; 10    x40     6   egr                 B5
; 9     x20     5   cruise solenoid     B4
; 8     x10     4   ac clutch out       B3
; 7     x08     3   fan                 R21
; 6     x04     2   wastegate           R19
; 5     x02     1   asd relay           R17
; 4     x01     0   baro read solenoid  R15
; NOTE: for above, 1 is OFF, 0 is ON

Z83_PortBdata               = Z83Mapping + 3
; Pin   Mask    Bit Function            LM Pin
; 27    x80     7   a/d conversion  (int)
; 28    x40     6   fuel monitor        R14
; 29    x20     5   tach out            R12
; 30    x10     4   alt fault       (int)
; 31    x08     3   ais                 R22
; 32    x04     2   ais                 R16
; 33    x02     1   ais                 R18
; 34    x01     0   ais                 R20

Z83_PortCdata               = Z83Mapping + 4
; Pin   Mask    Bit Function            LM Pin
; 35    x80     7   dist sync           B17
; 36    x40     6   cruise enable       B15
; 37    x20     5                       B14
; 38    x10     4   brake               B13
; 39    x08     3   park/neutral        B12
; 1     x04     2   ac clutch in        B11
; 2     x02     1   cruise resume       B10
; 3     x01     0   cruise set          B9

Z83_PortADataDirection      = Z83Mapping + 6
Z83_PortBDataDirection      = Z83Mapping + 7
Z83_PortCDataDirection      = Z83Mapping + 8
Z83_PortAcontrol            = Z83Mapping + 9
Z83_PortBcontrol            = Z83Mapping + 0xa
Z83_PortCcontrol            = Z83Mapping + 0xb

; *********
; Z22 Timer
; *********
Z22_Timer6840               = Z22Mapping
Z22_Timer6840_1             = Z22Mapping + 1
Z22_Timer6840_4             = Z22Mapping + 4

; *****************
; Z85 A/D Converter
; *****************
; Pin   Addr    Function            LM Pin
; 26    8000    MAP                 B19
; 27    8001    batt temp           B20
; 28    8002    O2                  B18
; 1     8003    air temp            B25
; 2     8004    coolant temp        B23
; 3     8005    tps                 B21
; 4     8006    knock               B24
; 5     8007    batt voltage        B22
Z85_ADConverter1            = Z85Mapping
Z85_ADConverter2            = Z85Mapping + 1
Z85_ADConverter3            = Z85Mapping + 2
Z85_ADConverter4            = Z85Mapping + 3
Z85_ADConverter5            = Z85Mapping + 4
Z85_ADConverterCoolantTemp  = Z85Mapping + 5
Z85_ADConverter7            = Z85Mapping + 6  ; MAP
Z85_ADConverterKnockSensor  = Z85Mapping + 7


; *****************************************************************************
; load cal data
; *****************************************************************************

        .include /CalDataFile/






; *****************************************************************************
; begin code
; *****************************************************************************

        .org CodeOrg
        .msg "Assembling Code..."


ResetStartup:
           ldd  #0x83ff        ; load d (a&b) with value -10000011 11111111-
           staa BitFlags_82    ; store a into memory
           stab Z83_PortAdata    ; store b into memory
           stab Z83_CPU_Port1_copy    ; store b into memory
           ldd  #0x6963        ; load d (a&b) with value -01101001 01100011-
           stD CPU_TimerControl1    ; store D to RAM
           ldaa #0xa0          ; load a with value -10100000-
           oraa CPU_Port1_ControlRegister    ; OR a with memory contents
           anda #0xfb          ; AND a with value -11111011-
           staa CPU_Port1_ControlRegister    ; store a into memory
           ldaa CPU_TimerStatus    ; load a with memory contents
           ldd  CPU_Counter_HB    ; load d (a&b) with memory contents
           inca                ; increment a
           stD  CPU_OCR3_HB    ; store D to RAM
           cli                 ; enable interrupts
           ldd  #0x060a        ; load d (a&b) with value -00000110 00001010-
           stD  CPU_SCI_ModeControlReg    ; store D to RAM
           ldaa CPU_SCI_TxRxCntrlReg    ; load a with memory contents
           ldaa #0x88          ; load a with value -10001000-
           staa CPU_SCI_TxDataReg    ; store a into memory
           ldx  #ENDITM_ECUID    ; load index with value
           clrb                ; b = 0
ChecksumLoop:
           addb 0x00,x         ; add memory at index + value to b
           inx                 ; increment index (x=x+1)
           bne  ChecksumLoop    ; branch if not equal (not zero)
           subb ENDITM_ECUID+1    ; subtract memory contents from b (data is 71)
           beq  ChecksumFinished    ; branch if equal (zero)
           ldx  #ErrorBitRegister0    ; load index with value
           ldab #0x02          ; load b with value -00000010-
           jsr  ThrowNonCriticalError    
ChecksumFinished:
           ldd  ErrorCodeBitMask0    ;  (data is ffbf)
           anda ErrorBitRegisterStored0    ; logical and a with memory contents
           andb ErrorBitRegisterStored1
           std  ErrorBitRegisterStored0    ; store D to RAM
           ldd  ErrorCodeBitMask2    ;  (data is feff)
           anda ErrorBitRegisterStored2    ; logical and a with memory contents
           andb ErrorBitRegisterStored3
           std  ErrorBitRegisterStored2    ; store D to RAM
           ldx  #LowestHistoricalTPS    ; load index with value
           ldd  #0x5500        ; load d (a&b) with value -01010101 00000000-
           psha                ; push a onto stack
           deca                ; decrement a
           sec                 ; set carry
   LC6B5:  rolb                ; rotate b left through carry
           inx                 ; increment index (x=x+1)
           cpx  #ErrorBitRegisterStored0    ;  -00000000 01001010-
           beq  LC6CF          ; branch if equal (zero)
   LC6BC:  bitb 0x04,x     
           bne  LC6C2          ; branch if not equal (not zero)
           bra  LC6C3          ; branch

   LC6C2:  psha                ; push a onto stack
   LC6C3:  deca                ; decrement a
           bita #0x0f          ;  -00001111-
           bne  LC6CA          ; branch if not equal (not zero)
           suba #0x09          ;  -00001001-
   LC6CA:  lslb            
           bcs  LC6B5          ; branch if lower
           bra  LC6BC          ; branch

   LC6CF:  tsx                 ; transfer stack to index (x=sp+1)
           stx  Temp5          ; store index into memory
           dex                 ; decrement index (x=x-1)
   LC6D3:  inx                 ; increment index (x=x+1)
           ldaa Counter_ErrorCodeFlasher    ; load a with memory contents
           adda #0xfa          ;  -11111010-
           bsr  LC71F          
           ldaa 0x00,x         ; load a with memory at index + value
           lsra            
           lsra            
           lsra            
           lsra            
           bsr  SetOutputsforPort1
           ldaa Counter_ErrorCodeFlasher    ; load a with memory contents
           adda #0x7d          ;  -01111101-
           bsr  LC71F          
           ldaa 0x00,x         ; load a with memory at index + value
           anda #0x0f          ; AND a with value -00001111-
           bsr  SetOutputsforPort1
           ldaa 0x00,x         ; load a with memory at index + value
           cmpa #0x55          ; compare a with value -01010101-
           bne  LC6D3          ; branch if not equal (not zero)
   LC6F4:  sei                 ; disable interrupts
           ldaa BitFlags_81    ; load a with memory contents
           oraa #0x40          ;  -01000000-
           staa BitFlags_81    ; store a into memory
           cli                 ; enable interrupts
WaitForInterrupt:
           wai                 ; wait for interrupt
           bra  WaitForInterrupt    ; branch

SetOutputsforPort1:
           staa Counter_Port1ControlRegLoop    ; store a into memory
   LC701:  ldaa #0x20          ; load a with value -00100000-
           sei                 ; disable interrupts
           oraa CPU_Port1_ControlRegister    ; OR a with memory contents
           staa CPU_Port1_ControlRegister    ; store a into memory
           cli                 ; enable interrupts
           bsr  LC71B
           ldaa #0xdf          ; load a with value -11011111-
           sei                 ; disable interrupts
           anda CPU_Port1_ControlRegister    ; logical and a with memory contents
           staa CPU_Port1_ControlRegister    ; store a into memory
           cli                 ; enable interrupts
           bsr  LC71B          
           dec  Counter_Port1ControlRegLoop    ; decrement memory contents
           bne  LC701          ; branch if not equal (not zero)
           rts                 ; return from subroutine

   LC71B:  ldaa Counter_ErrorCodeFlasher    ; load a with memory contents
           adda #0x1f          ;  -00011111-
   LC71F:  cmpa Counter_ErrorCodeFlasher    ; compare a with memory contents
           beq  LC72E          ; branch if equal (zero)
           ldab BitFlags_81    ; load b with memory contents
           bitb #0x20          ;  -00100000-
           beq  LC71F          ; branch if equal (zero)
           lds  #0x00ff        ;  -00000000 11111111-
           bra  LC6F4          ; branch

   LC72E:  rts                 ; return from subroutine

        .msg "..." ; these are just messages to display during assemble to let you know what's going on...

IncrementSlowCounter_MM:
           ldaa Counter_MainLoop1    ; load a with memory contents
           bne  LC74B          ; branch if not equal (not zero)
           ldx  #ClearTheErrorTimer_0    ; load index with value
           ldd  ClearTheErrorTimer_0    ; load d (a&b) with memory contents
   LC738:  tsta                ; test a
           beq  LC744          ; branch if equal (zero)
           suba #0x20          ;  -00100000-
           bita #0xe0          ;  -11100000-
           bne  LC742          ; branch if not equal (not zero)
           clra                ; a = 0
   LC742:  staa 0x00,x     
   LC744:  inx                 ; increment index (x=x+1)
           tba                 ; a = b
           cpx  #ClearTheErrorTimer_0 + 2    ;  -00000000 01110110-
           bne  LC738          ; branch if not equal (not zero)
   LC74B:  rts                 ; return from subroutine

   LC74C:  ldab SlowCounter    ; load b with memory contents
           cmpb #0x14          ;  -00010100-
           bcs  LC764          ; branch if lower
           ldx  #ErrorBitRegister0    ; load index with value
           clrb                ; b = 0
   LC756:  ldaa 0x00,x         ; load a with memory at index + value
           anda 0x04,x     
           staa 0x04,x     
           stab 0x00,x     
           inx                 ; increment index (x=x+1)
           cpx  #ErrorBitRegisterStored0    ;  -00000000 01001010-
           bne  LC756          ; branch if not equal (not zero)
   LC764:  incb            
           stab SlowCounter    ; store b into memory
           rts                 ; return from subroutine

VerifyOperationOfThermostat_MM:
           ldaa BitFlags_82    ; load a with memory contents
           bmi  LC7A1          ; branch if minus(hi bit 1)
           ldaa BitFlags_80    ; load a with memory contents
           bita #0x02          ;  -00000010-
           bne  LC7A1          ; branch if not equal (not zero)
           ldaa Timer_ThermostatDiagnostics    ; load a with memory contents
           beq  LC7A1          ; branch if equal (zero)
           ldab Counter_MainLoop1    ; load b with memory contents
           andb #0xfc          ;  -11111100-
           bne  LC7A1          ; branch if not equal (not zero)
           ldab CoolantTemp    ; load b with memory contents
           cmpb TDAGTP_TstatDiagnosticsTemperatureGoalWithin_HOTIME    ; compare b with memory contents (data is c7)
           bcc  LC79E          ; branch if greater or equal
           ldab KeyOnOrEngineRunningTime    ; load b with memory contents
           incb            
           bne  LC7A1          ; branch if not equal (not zero)
           ldab VehicleSpeed_HB    ; load b with memory contents
           cmpb #0x07          ;  -00000111-
           bcs  LC7A1          ; branch if lower
           inca                ; increment a
           beq  LC796          ; branch if equal (zero)
           cmpa HOTIME_TstatDiagnosticsTimeToAchieveTemperatureGoal    ; compare a with memory contents (data is ae)
           bcs  LC79F          ; branch if lower
   LC796:  ldx  #ErrorBitRegister3    ; load index with value
           ldab #0x02          ; load b with value -00000010-
           jsr  ThrowNonCriticalError    
   LC79E:  clra                ; a = 0
   LC79F:  staa Timer_ThermostatDiagnostics    ; store a into memory
   LC7A1:  rts                 ; return from subroutine

SimulateMapReadingFromTps:
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb #0x3f          ;  -00111111-
           ldaa #0x00          ; load a with value -00000000-
           bcc  LC7C0          ; branch if greater or equal
           subb #0x08          ;  -00001000-
           bcc  LC7AF          ; branch if greater or equal
           clrb                ; b = 0
   LC7AF:  ldaa #0x29          ; load a with value -00101001-
           mul                 ; multiply (d=a*b)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           lslb            
           adca MINTHR_LowestSessionTPS
           tab                 ; b = a
           ldaa TpsVolts       ; load a with memory contents
           adda #0x0b          ;  -00001011-
           sba                 ; subtract (a=a-b)
           bcc  LC7C0          ; branch if greater or equal
           clra                ; a = 0
   LC7C0:  ldx  #LMPINN_LimpinTableForMapFromThrottle    ; load index with value
           jsr  Lookup5ByteTable    
           tba                 ; a = b
           adda MPLMOF_OffsetForCalcMapInMapLimpin    ;  (data is 20)
           rts                 ; return from subroutine

CheckAndFilterChargeTempSensor_MM:
           ldab DEFCHG_DefaultChargeTemp_Limpin    ; load b with memory contents (data is ad)
           ldaa BitFlags_80    ; load a with memory contents
           bita #0x01          ;  -00000001-
           bne  LC7F5          ; branch if not equal (not zero)
           ldaa Counter_MainLoop1    ; load a with memory contents
           anda #0x07          ; AND a with value -00000111-
           cmpa #0x06          ; compare a with value -00000110-
           bne  LC7F7          ; branch if not equal (not zero)
           ldaa LastChargeTempVolts    ; load a with memory contents
           ldab ChargeTempVolts    ; load b with memory contents
           cmpa CHGLOW_ChargeTempOutOfRangeLow    ; compare a with memory contents (data is 03)
           bcs  InvalidChargeTemp    ; branch if lower
           cmpa CHGHIG_ChargeTempOutOfRangeHigh    ; compare a with memory contents (data is fe)
           bcc  InvalidChargeTemp    ; branch if greater or equal
           sba                 ; subtract (a=a-b)
           bcc  LC7F0          ; branch if greater or equal
           decb            
           bra  LC7F5          ; branch

   LC7F0:  cmpa #0x03          ; compare a with value -00000011-
           bcs  LC7F7          ; branch if lower
           incb            
   LC7F5:  stab ChargeTempVolts    ; store b into memory
   LC7F7:  rts                 ; return from subroutine

InvalidChargeTemp:
           stab ChargeTempVolts    ; store b into memory
           ldaa #0x17          ; load a with value -00010111-
           jsr  ThrowCriticalError    
           bcc  LC809          ; branch if greater or equal
           ldaa #0x01          ; load a with value -00000001-
           sei                 ; disable interrupts
           oraa BitFlags_80    ; OR a with memory contents
           staa BitFlags_80    ; store a into memory
           cli                 ; enable interrupts
   LC809:  rts                 ; return from subroutine

CheckAndFilterCoolantTempSensor_MM:
           ldab DEFTMP_DefaultEngineTemp    ; load b with memory contents (data is 95)
           ldaa BitFlags_80    ; load a with memory contents
           anda #0x03          ; AND a with value -00000011-
           cmpa #0x03          ; compare a with value -00000011-
           beq  SaveCoolantTemp    ; branch if equal (zero)
           cmpa #0x02          ; compare a with value -00000010-
           bne  CoolantTempValueGood    ; branch if not equal (not zero)
           ldaa LastChargeTempVolts    ; load a with memory contents
           ldx  #CHGTL1_TempForChargeTempA2D    ; load index with value
           jsr  Lookup4ByteTable    
           bra  SaveCoolantTemp    ; branch

CoolantTempValueGood:
           ldaa Counter_MainLoop1    ; load a with memory contents
           anda #0x07          ; AND a with value -00000111-
           cmpa #0x02          ; compare a with value -00000010-
           bne  LC866          ; branch if not equal (not zero)
           ldaa LastCoolantTempVolts    ; load a with memory contents
           cmpa TMPLOW_OutOfRangeHotTooLowA2D    ; compare a with memory contents (data is 1a)
           bcs  CoolantTempInvalid    ; branch if lower
           cmpa TMPHIG_OutOfRangeColdTooHighA2D    ; compare a with memory contents (data is fd)
           bcc  CoolantTempInvalid    ; branch if greater or equal
GetCoolantTempQuick:
           ldx  #TMPTL2_TempForHotScaleA2D    ; load index with value
           ldab CPU_Port1_ControlRegister    ; load b with memory contents
           bitb #0x08          ;  -00001000-
           beq  LC850          ; branch if equal (zero)
           ldx  #TMPTL1_TempForColdScaleFromA2D    ; load index with value
           cmpa #0x40          ; compare a with value -01000000-
           bcc  LC854          ; branch if greater or equal
ToggleCTSbias:
           sei                 ; disable interrupts
           ldaa CPU_Port1_ControlRegister    ; load a with memory contents
           eora #0x08          ; XOR a with value -00001000-
           staa CPU_Port1_ControlRegister    ; store a into memory
           cli                 ; enable interrupts
           rts                 ; return from subroutine

   LC850:  cmpa #0xdc          ; compare a with value -11011100-
           bcc  ToggleCTSbias    ; branch if greater or equal
   LC854:  jsr  Lookup4ByteTable    
           ldab CoolantTemp    ; load b with memory contents
           sba                 ; subtract (a=a-b)
           bcc  LC85F          ; branch if greater or equal
           decb            
           bra  SaveCoolantTemp    ; branch

   LC85F:  cmpa #0x03          ; compare a with value -00000011-
           bcs  LC866          ; branch if lower
           incb            
SaveCoolantTemp:
           stab CoolantTemp    ; store b into memory
   LC866:  rts                 ; return from subroutine

CoolantTempInvalid:
           ldaa #0x18          ; load a with value -00011000-
           jsr  ThrowCriticalError    
           bcc  LC866          ; branch if greater or equal
           ldaa #0x02          ; load a with value -00000010-
           sei                 ; disable interrupts
           oraa BitFlags_80    ; OR a with memory contents
           staa BitFlags_80    ; store a into memory
           cli                 ; enable interrupts
           rts                 ; return from subroutine

VerifyOperationOfBatteryVoltage_MM:
           ldaa BatteryVolts    ; load a with memory contents
           cmpa #0x41          ; compare a with value -01000001-
           bcs  LC885          ; branch if lower
           cmpa #0x7c          ; compare a with value -01111100-
           bcs  LC8A6          ; branch if lower
           cmpa #0x95          ; compare a with value -10010101-
           bcc  LC8A6          ; branch if greater or equal
   LC885:  ldaa BitFlags_82    ; load a with memory contents
           bmi  LC8A6          ; branch if minus(hi bit 1)
           ldaa BitFlags_4f    ; load a with memory contents
           bita #0x20          ;  -00100000-
           bne  LC8A6          ; branch if not equal (not zero)
           ldd  KeyOnOrEngineRunningTime    ; load d (a&b) with memory contents
           cmpa #0x15          ; compare a with value -00010101-
           bcs  LC8A6          ; branch if lower
           bitb #0x7c          ;  -01111100-
           bne  LC8A6          ; branch if not equal (not zero)
           ldaa #0x1b          ; load a with value -00011011-
           jsr  ThrowCriticalError    
           bcc  LC8A6          ; branch if greater or equal
           ldaa BitFlags_4f    ; load a with memory contents
           oraa #0x20          ;  -00100000-
           staa BitFlags_4f    ; store a into memory
   LC8A6:  rts                 ; return from subroutine

VerifyOperationOfO2SensorAnd:
           ldaa Counter_MainLoop1    ; load a with memory contents
           anda #0x3f          ; AND a with value -00111111-
           cmpa #0x38          ; compare a with value -00111000-
           beq  VerifyOperationOfO2Sensor    ; branch if equal (zero)
           cmpa #0x18          ; compare a with value -00011000-
           beq  DetermineBattTemp    ; branch if equal (zero)
           cmpa #0x08          ; compare a with value -00001000-
           bne  LC8DA          ; branch if not equal (not zero)
           ldaa BitFlags_80    ; load a with memory contents
           lsla                ; logical shift left a
           oraa BitFlags_81    ; OR a with memory contents
           bmi  LC8DA          ; branch if minus(hi bit 1)
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa ERRKON_KeyOnTimeLimitforErrorCodeSetting    ; compare a with memory contents (data is 80)
           bcs  LC8DA          ; branch if lower
           ldaa TargetIdleSpeed_HB    ; load a with memory contents
           adda ERRRPM_RPMLimitforErrorCodeSetting    ;  (data is 0c)
           cmpa EngineRpm_HB    ; compare a with memory contents
           bcc  LC8DA          ; branch if greater or equal
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           cmpa ERRMPH_MPHLimitforErrorCodeSetting    ; compare a with memory contents (data is 12)
           ldaa #0x1c          ; load a with value -00011100-
           bcs  LC94E          ; branch if lower
   LC8DA:  rts                 ; return from subroutine

DetermineBattTemp:
           ldaa #0x08          ; load a with value -00001000-
           ldab AmbientAirTempVolts    ; load b with memory contents
           cmpb AMBLOW_BattTempLowWhenHot    ; compare b with memory contents (data is 02)
           bls  LC94E          ; branch if lower or same
           cmpb AMBHIG_BattTempHighWhenCold    ; compare b with memory contents (data is fd)
           bhi  LC94E          ; branch if higher
           rts                 ; return from subroutine

VerifyOperationOfO2Sensor:
           ldaa CoolantTemp    ; load a with memory contents
           cmpa CTLRPM_LowBatteryVoltageAtThisCoolantTemp    ; compare a with memory contents (data is cd)
           bcs  LC8DA          ; branch if lower
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa BTLRPM_LowBatteryVoltageAtThisRpm1500    ; compare a with memory contents (data is 17)
           bcs  LC8DA          ; branch if lower
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa O2MNRT_MiniumRunTimeForO2SensorDiag    ; compare a with memory contents (data is ff)
           bcs  LC8DA          ; branch if lower
           ldaa Counter_MainLoop1    ; load a with memory contents
           bita #0x40          ;  -01000000-
           bne  LC942          ; branch if not equal (not zero)
           ldaa BitFlags_82    ; load a with memory contents
           bita #0x08          ;  -00001000-
           bne  LC941          ; branch if not equal (not zero)
           ldaa BitFlags_81    ; load a with memory contents
           bita #0x10          ;  -00010000-
           bne  LC93E          ; branch if not equal (not zero)
           ldaa O2SensorVolts    ; load a with memory contents
           cmpa O2MIDL_LowLimitForInMiddleDetermination    ; compare a with memory contents (data is 12)
           bcs  LC93E          ; branch if lower
           cmpa O2MIDH_HighLimitForInMiddleDetermination    ; compare a with memory contents (data is 1c)
           bcc  LC93E          ; branch if greater or equal
           ldab BitFlags_80    ; load b with memory contents
           bitb #0x20          ;  -00100000-
           bne  LC93E          ; branch if not equal (not zero)
           ldaa FuelSubtractedFromStartToRun    ; load a with memory contents
           inca                ; increment a
           beq  LC93E          ; branch if equal (zero)
           staa FuelSubtractedFromStartToRun    ; store a into memory
           cmpa #0x56          ; compare a with value -01010110-
           bcs  LC941          ; branch if lower
           ldab #0x01          ; load b with value -00000001-
           ldx  #ErrorBitRegister3    ; load index with value
           jsr  ThrowNonCriticalError    
           ldaa #0x20          ; load a with value -00100000-
           sei                 ; disable interrupts
           oraa BitFlags_80    ; OR a with memory contents
           staa BitFlags_80    ; store a into memory
           cli                 ; enable interrupts
   LC93E:  clra                ; a = 0
           staa FuelSubtractedFromStartToRun    ; store a into memory
   LC941:  rts                 ; return from subroutine

   LC942:  ldaa #0x05          ; load a with value -00000101-
           ldab TargetBatteryVolts    ; load b with memory contents
           subb BatteryVolts    ; b = b-memory contents
           bcs  LC941          ; branch if lower
           cmpb #0x10          ;  -00010000-
           bcs  LC941          ; branch if lower
   LC94E:  staa Temp4          ; store a into memory
           bsr  SetErrorFlags    
           ldab 0x00,x         ; load b with memory at index + value
   LC954:  lsrb                ; logical shift right b
           deca                ; decrement a
           bne  LC954          ; branch if not equal (not zero)
           bcc  LC95E          ; branch if greater or equal
           clc                 ; clear carry
           rts                 ; return from subroutine

ThrowCriticalError:
           staa Temp4          ; store a into memory
   LC95E:  ldx  #ClearTheErrorTimer_0    ; load index with value
           ldd  0x00,x     
           anda #0x1f          ; AND a with value -00011111-
           cmpa Temp4          ; compare a with memory contents
           beq  LC977          ; branch if equal (zero)
           inx                 ; increment index (x=x+1)
           andb #0x1f          ;  -00011111-
           cmpb Temp4      
           beq  LC977          ; branch if equal (zero)
           tstb            
           beq  LC977          ; branch if equal (zero)
           dex                 ; decrement index (x=x-1)
           tsta                ; test a
           bne  LC981          ; branch if not equal (not zero)
   LC977:  ldab 0x00,x         ; load b with memory at index + value
           addb #0x20          ;  -00100000-
           bcs  LC983          ; branch if lower
           orab Temp4      
           stab 0x00,x     
   LC981:  clc                 ; clear carry
           rts                 ; return from subroutine

   LC983:  clr  0x00,x     
           bsr  SetErrorFlags    
           ldab Temp4          ; load b with memory contents
           cmpb #0x1f          ;  -00011111-
           bhi  LC99B          ; branch if higher
           clrb                ; b = 0
           sec                 ; set carry
   LC98F:  rolb                ; rotate b left through carry
           deca                ; decrement a
           bne  LC98F          ; branch if not equal (not zero)
ThrowNonCriticalError:
           orab 0x00,x     
           stab 0x00,x     
           orab 0x04,x     
           stab 0x04,x     
   LC99B:  sec                 ; set carry
           rts                 ; return from subroutine

SetErrorFlags:
           ldx  #LowestHistoricalTPS    ; load index with value
           ldaa Temp4          ; load a with memory contents
   LC9A2:  inx                 ; increment index (x=x+1)
           suba #0x08          ;  -00001000-
           bhi  LC9A2          ; branch if higher
           adda #0x08          ;  -00001000-
           rts                 ; return from subroutine

SetMapErrorCode_MM:
           ldaa BitFlags_7f    ; load a with memory contents
           bita #0x40          ;  -01000000-
           beq  LC9C5          ; branch if equal (zero)
           ldaa #0x1d          ; load a with value -00011101-
           jsr  ThrowCriticalError    
           sei                 ; disable interrupts
           ldaa BitFlags_80    ; load a with memory contents
           bcc  LC9BE          ; branch if greater or equal
           oraa #0x80          ;  -10000000-
           staa BitFlags_80    ; store a into memory
   LC9BE:  ldaa BitFlags_7f    ; load a with memory contents
           anda #0xbf          ; AND a with value -10111111-
           staa BitFlags_7f    ; store a into memory
           cli                 ; enable interrupts
   LC9C5:  rts                 ; return from subroutine

VerifyOperationOfMapSensor_MM:
           ldaa Z85_ADConverter7    ; load a with memory contents (data is 00)
           ldab MINTHR_LowestSessionTPS    ; load b with memory contents
           addb DLTTHR_MinDeltaThrottleforErrorCodeReset    ;  (data is 10)
           cmpb TpsVolts   
           bcs  LC9D7          ; branch if lower
           cmpa MAPHIG_MapSensorUpperLimit    ; compare a with memory contents (data is fc)
           bcc  MapAppearsToBeFaulty    ; branch if greater or equal
   LC9D7:  ldx  EngineRpm_HB
           cpx  #0x1770        ;  -00010111 01110000-
           bcc  ConvertMAPVoltsToValue    ; branch if greater or equal
           cmpa MAPLOW_MapSensorLowerLimit    ; compare a with memory contents (data is 01)
           bcc  ConvertMAPVoltsToValue    ; branch if greater or equal
MapAppearsToBeFaulty:
           ldab BitFlags_7f    ; load b with memory contents
           orab #0x40          ;  -01000000-
           stab BitFlags_7f    ; store b into memory
ConvertMAPVoltsToValue:
           staa Temp5          ; store a into memory
           ldab MAPMULT_ScaleMAPVoltsToPresMultiplyConst    ; load b with memory contents (data is 07)
           bpl  LC9F3          ; branch if plus (hi bit 0)
           clr  Temp5          ; zero byte at memory location
   LC9F3:  mul                 ; multiply (d=a*b)
           adda Temp5      
           bcc  LC9FA          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LC9FA:  addd MAPADD_ScaleMAPVoltsToPresAddConst    ;  (data is 03)
           bcc  LCA01          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LCA01:  rts                 ; return from subroutine

Throttle_MM:
           ldaa Counter_TimerPastHalfwayBetweenDistPulses    ; load a with memory contents
           cmpa MAXCDH_MaximumCounterDistrubtorHalfwayforErrorCodeReset    ; compare a with memory contents (data is 10)
           bcc  LCA31          ; branch if greater or equal
           ldaa BitFlags_82    ; load a with memory contents
           bmi  Throttle_EngineNotRunning    ; branch if minus(hi bit 1)
           ldx  KeyOnOrEngineRunningTime
           cpx  MAXERT_MaximumEngineRunningTimeforErrorCodeReset    ;  (data is 002d)
           bcc  LCA31          ; branch if greater or equal
Throttle_EngineNotRunning:
           ldaa MINTHR_LowestSessionTPS    ; load a with memory contents
           adda DLTTHR_MinDeltaThrottleforErrorCodeReset    ;  (data is 10)
           cmpa TpsVolts       ; compare a with memory contents
           bcs  Throttle_ClearMAPError    ; branch if lower
           ldaa StackPtrTemp_HB    ; load a with memory contents
           suba MapVolts   
           bcc  LCA24          ; branch if greater or equal
           nega                ; negate a (set high bit)
   LCA24:  cmpa MAPERR_MinMAPforErrorCodeReset    ; compare a with memory contents (data is 02)
           bcs  LCA31          ; branch if lower
Throttle_ClearMAPError:
           sei                 ; disable interrupts
           ldaa BitFlags_80    ; load a with memory contents
           anda #0x7f          ; AND a with value -01111111-
           staa BitFlags_80    ; store a into memory
           cli                 ; enable interrupts
   LCA31:  rts                 ; return from subroutine

SetFlagForPTE_MM:
           ldaa PreviousMAP    ; load a with memory contents
           ldab MapValue       ; load b with memory contents
           stab PreviousMAP    ; store b into memory
           sba                 ; subtract (a=a-b)
           ldab BitFlags_84    ; load b with memory contents
           andb #0xdf          ;  -11011111-
           bcs  LCA61          ; branch if lower
           cmpa MINDLM_MinDeltaMAPForPTE    ; compare a with memory contents (data is 05)
           bcs  LCA61          ; branch if lower
           ldaa BitFlags_82    ; load a with memory contents
           oraa BitFlags_81    ; OR a with memory contents
           bmi  LCA61          ; branch if minus(hi bit 1)
           ldaa CoolantTemp    ; load a with memory contents
           cmpa MINCTS_MinCoolantTempForPTE    ; compare a with memory contents (data is b1)
           bcs  LCA61          ; branch if lower
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa MINERT_MinTimeForPTE    ; compare a with memory contents (data is 02)
           bcs  LCA61          ; branch if lower
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa MINRPM_MinRPMforPTE    ; compare a with memory contents (data is 23)
           bcs  LCA61          ; branch if lower
           orab #0x20          ;  -00100000-
   LCA61:  stab BitFlags_84    ; store b into memory
           rts                 ; return from subroutine

AllowForHeatSoakAfterStall:
           ldaa CoolantTemp    ; load a with memory contents
           cmpa RUNLMT_MaxAllowableTempFor_RUNTMP    ; compare a with memory contents (data is 95)
           bcc  LCA7F          ; branch if greater or equal
           ldaa VerySlowCounter2point6seconds    ; load a with memory contents
           ldx  #RUNTMP_ModifierOf_ENGTMP_FromStalltime    ; load index with value
           jsr  Lookup4ByteTable    
           ldaa CoolantTemp    ; load a with memory contents
           aba                 ; a=a+b
           ldab RUNLMT_MaxAllowableTempFor_RUNTMP    ; load b with memory contents (data is 95)
           bcs  LCA7E          ; branch if lower
           cba             
           bcs  LCA7F          ; branch if lower
   LCA7E:  tba                 ; a = b
   LCA7F:  rts                 ; return from subroutine

CalculatePTEFactors_MM:
           ldaa LMAPTC_TimeConstant    ; load a with memory contents (data is 28)
           ldab MapValue       ; load b with memory contents
           cmpb AverageMAPValue
           bcs  LCA91          ; branch if lower
           ldx  #AETIME_EnrichmentTime_FromTemp    ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    
   LCA91:  staa Factor_LeanoutOrEnrichTime_MAP    ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #THRTCN_EnrichmentTime_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    
           staa Factor_LeanoutOrEnrichTime_TPS    ; store a into memory
           rts                 ; return from subroutine

        .msg "..." ; these are just messages to display during assemble to let you know what's going on...

DetermineTargetBatteryVoltage_MM:
           ldab AmbientAirTempVolts    ; load b with memory contents
           ldaa #0xe3          ; load a with value -11100011-
           cmpb AMBLOW_BattTempLowWhenHot    ; compare b with memory contents (data is 02)
           bcs  LCABD          ; branch if lower
           cmpb AMBHIG_BattTempHighWhenCold    ; compare b with memory contents (data is fd)
           bhi  LCABD          ; branch if higher

           ; Load WOT Battery Volts Target and check for WOT
;            ldaa #WOTBAT_WOTBatteryVoltsTarget
;            ldab BitFlags_81
;            lsrb ;bitb #b81_FullThrottle
;            bcs  LCABD       ; branch if WOT
;            ldab AmbientAirTempVolts

           ldaa #0x20          ; load a with value -00100000-
           mul                 ; multiply (d=a*b)
           adca #0xd1          ;  -11010001-
           cmpa #0xec          ; compare a with value -11101100-
           bcs  LCAB7          ; branch if lower
           ldaa #0xec          ; load a with value -11101100-
   LCAB7:  cmpa #0xd8          ; compare a with value -11011000-
           bcc  LCABD          ; branch if greater or equal
           ldaa #0xd8          ; load a with value -11011000-
   LCABD:  staa TargetBatteryVolts    ; store a into memory
           ldaa Timer_VoltageRegSignal    ; load a with memory contents
           cmpa #0xf0          ; compare a with value -11110000-
           bcs  LCADE          ; branch if lower
           ldab Counter_MainLoop1    ; load b with memory contents
           bitb #0x7c          ;  -01111100-
           bne  LCADE          ; branch if not equal (not zero)
           suba #0x60          ;  -01100000-
           staa Timer_VoltageRegSignal    ; store a into memory
           ldab BitFlags_82    ; load b with memory contents
           bmi  LCB0A          ; branch if minus(hi bit 1)
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa #0x10          ; compare a with value -00010000-
           bcs  LCADE          ; branch if lower
           ldaa #0x0b          ; load a with value -00001011-
           jsr  LC94E          
   LCADE:  clrb                ; b = 0
           ldaa BatteryVolts    ; load a with memory contents
           suba TargetBatteryVolts
           bcs  LCAFD          ; branch if lower
           cmpa #0x10          ; compare a with value -00010000-
           bcs  LCAFD          ; branch if lower
           ldaa BitFlags_80    ; load a with memory contents
           bita #0x08          ;  -00001000-
           bne  LCB0A          ; branch if not equal (not zero)
           ldaa Counter_MainLoop1    ; load a with memory contents
           bita #0x7c          ;  -01111100-
           bne  LCB0A          ; branch if not equal (not zero)
           ldaa #0x06          ; load a with value -00000110-
           jsr  ThrowCriticalError    
           bcc  LCB0A          ; branch if greater or equal
           rorb            
   LCAFD:  sei                 ; disable interrupts
           ldaa BitFlags_80    ; load a with memory contents
           oraa #0x08          ;  -00001000-
           tstb            
           bmi  LCB07          ; branch if minus(hi bit 1)
           anda #0xf7          ; AND a with value -11110111-
   LCB07:  staa BitFlags_80    ; store a into memory
           cli                 ; enable interrupts
   LCB0A:  rts                 ; return from subroutine

DetermineVoltage:
           cmpa #0x41          ; compare a with value -01000001-
           bcs  LCB24          ; branch if lower
           ldab BitFlags_4f    ; load b with memory contents
           cmpa #0x7c          ; compare a with value -01111100-
           bcs  LCB19          ; branch if lower
           cmpa #0x95          ; compare a with value -10010101-
           bcs  LCB1F          ; branch if lower
   LCB19:  andb #0xdf          ;  -11011111-
           stab BitFlags_4f    ; store b into memory
           bra  LCB24          ; branch

   LCB1F:  bitb #0x20          ;  -00100000-
           beq  LCB24          ; branch if equal (zero)
           clra                ; a = 0
   LCB24:  staa 0x00,x     
           ldab BitFlags_82    ; load b with memory contents
           bmi  LCB7C          ; branch if minus(hi bit 1)
           cmpa #0x41          ; compare a with value -01000001-
           bcc  LCB34          ; branch if greater or equal
           ldab Counter_MainLoop1    ; load b with memory contents
           bitb #0x06          ;  -00000110-
           bne  LCB7C          ; branch if not equal (not zero)
   LCB34:  ldab CPU_Port1_ControlRegister    ; load b with memory contents
           bitb #0x10          ;  -00010000-
           beq  LCB3E          ; branch if equal (zero)
           adda #0x01          ;  -00000001-
           bcs  LCB7C          ; branch if lower
   LCB3E:  cmpa TargetBatteryVolts    ; compare a with memory contents
           bhi  LCB7C          ; branch if higher
           ldab #0x80          ; load b with value -10000000-
           ldaa Timer_VoltageRegSignal    ; load a with memory contents
           cmpa #0xf0          ; compare a with value -11110000-
           bcc  LCB80          ; branch if greater or equal
           anda #0x0f          ; AND a with value -00001111-
           cmpa #0x01          ; compare a with value -00000001-
           bne  LCB56          ; branch if not equal (not zero)
           dec  Timer_VoltageRegSignal    ; decrement memory contents
           clrb                ; b = 0
           bra  LCB80          ; branch

   LCB56:  ldaa CPU_Port1_ControlRegister    ; load a with memory contents
           bita #0x10          ;  -00010000-
           beq  LCB80          ; branch if equal (zero)
           ldaa Z83_PortBdata    ; load a with memory contents
           bita #0x10          ;  -00010000-
           beq  LCB7D          ; branch if equal (zero)
           ldaa TargetBatteryVolts    ; load a with memory contents
           suba BatteryVolts
           cmpa #0x04          ; compare a with value -00000100-
           bcs  LCB7D          ; branch if lower
           ldaa Timer_VoltageRegSignal    ; load a with memory contents
           bita #0x0f          ;  -00001111-
           bne  LCB77          ; branch if not equal (not zero)
           adda #0x10          ;  -00010000-
           anda #0xf0          ; AND a with value -11110000-
           oraa #0x03          ;  -00000011-
   LCB77:  deca                ; decrement a
           staa Timer_VoltageRegSignal    ; store a into memory
           bra  LCB80          ; branch

   LCB7C:  clrb                ; b = 0
   LCB7D:  clra                ; a = 0
           staa Timer_VoltageRegSignal    ; store a into memory
   LCB80:  ldaa #0x10          ; load a with value -00010000-
           sei                 ; disable interrupts
           oraa CPU_Port1_ControlRegister    ; OR a with memory contents
           tstb            
           bmi  LCB8A          ; branch if minus(hi bit 1)
           anda #0xef          ; AND a with value -11101111-
   LCB8A:  staa CPU_Port1_ControlRegister    ; store a into memory
           cli                 ; enable interrupts
           rts                 ; return from subroutine

RegulateVoltage:
           ldab BitFlags_4f    ; load b with memory contents
           bitb #0x20          ;  -00100000-
           beq  LCB95          ; branch if equal (zero)
           clra                ; a = 0
   LCB95:  staa 0x00,x     
           ldab BitFlags_82    ; load b with memory contents
           bmi  VoltageRegSignalOff    ; branch if minus(hi bit 1)
           cmpa #0x41          ; compare a with value -01000001-
           bcc  LCBA5          ; branch if greater or equal
           ldab Counter_MainLoop1    ; load b with memory contents
           bitb #0x06          ;  -00000110-
           bne  VoltageRegSignalOff    ; branch if not equal (not zero)
   LCBA5:  ldab CPU_Port1_ControlRegister    ; load b with memory contents
           bitb #0x10          ;  -00010000-
           beq  LCBAF          ; branch if equal (zero)
           adda #0x01          ;  -00000001-
           bcs  VoltageRegSignalOff    ; branch if lower
   LCBAF:  cmpa TargetBatteryVolts    ; compare a with memory contents
           bls  VoltageRegSignalOn    ; branch if lower or same
VoltageRegSignalOff:
           clra                ; a = 0
           staa Timer_VoltageRegSignal    ; store a into memory
           ldaa CPU_Port1_ControlRegister    ; load a with memory contents
           anda #0xef          ; AND a with value -11101111-
           staa CPU_Port1_ControlRegister    ; store a into memory
           rts                 ; return from subroutine

VoltageRegSignalOn:
           ldaa CPU_Port1_ControlRegister    ; load a with memory contents
           oraa #0x10          ;  -00010000-
           staa CPU_Port1_ControlRegister    ; store a into memory
           rts                 ; return from subroutine

SetDelayedFaultCode:
           jsr  ThrowCriticalError    
           bcs  LCBD4          ; branch if lower
           ldaa TimerOverflowsBetweenDistPulses    ; load a with memory contents
           cmpa #0x02          ; compare a with value -00000010-
           bcs  LCBDA          ; branch if lower
           jsr  LC95E          
           bcc  LCBDA          ; branch if greater or equal
   LCBD4:  ldaa BitFlags_81    ; load a with memory contents
           oraa #0x20          ;  -00100000-
           staa BitFlags_81    ; store a into memory
   LCBDA:  rts                 ; return from subroutine

ConfirmO2GoodAndAdjustKnockRetard_MM:
           ldab BitFlags_81    ; load b with memory contents
           bitb #0x20          ;  -00100000-
           bne  LCBFB          ; branch if not equal (not zero)
           ldab BitFlags_4f    ; load b with memory contents
           bitb #0x04          ;  -00000100-
           bne  LCBFB          ; branch if not equal (not zero)
           ldab BitFlags_83    ; load b with memory contents
           bitb #0x04          ;  -00000100-
           beq  LCBF1          ; branch if equal (zero)
           ldaa #0x14          ; load a with value -00010100-
           bsr  SetDelayedFaultCode    
   LCBF1:  ldab BitFlags_83    ; load b with memory contents
           bitb #0x08          ;  -00001000-
           beq  LCBFB          ; branch if equal (zero)
           ldaa #0x13          ; load a with value -00010011-
           bsr  SetDelayedFaultCode    
   LCBFB:  ldab BitFlags_83    ; load b with memory contents
           bitb #0x10          ;  -00010000-
           beq  LCC06          ; branch if equal (zero)
           ldaa #0x09          ; load a with value -00001001-
           jsr  LC94E          
   LCC06:  ldaa BitFlags_82    ; load a with memory contents
           bita #0x04          ;  -00000100-
           bne  LCC17          ; branch if not equal (not zero)
           ldaa BitFlags_7f    ; load a with memory contents
           bita #0x08          ;  -00001000-
           beq  LCC17          ; branch if equal (zero)
           ldaa #0x01          ; load a with value -00000001-
           jsr  LC94E          
   LCC17:  ldaa #0xf7          ; load a with value -11110111-
           ldab #0xe3          ; load b with value -11100011-
           sei                 ; disable interrupts
           andb BitFlags_83
           stab BitFlags_83    ; store b into memory
           anda BitFlags_7f    ; logical and a with memory contents
           staa BitFlags_7f    ; store a into memory
           cli                 ; enable interrupts
           ldaa Counter_MainLoop1    ; load a with memory contents
           bita INCSRT_KnockRetardIncreaseRate    ;  (data is 1f)
           bne  LCC44          ; branch if not equal (not zero)
           ldx  #Cylinder2Retard    ; load index with value
   LCC2F:  sei                 ; disable interrupts
           ldaa 0x00,x         ; load a with memory at index + value
           tab                 ; b = a
           anda #0xc0          ; AND a with value -11000000-
           andb #0x3f          ;  -00111111-
           beq  LCC3A          ; branch if equal (zero)
           decb            
   LCC3A:  aba                 ; a=a+b
           staa 0x00,x     
           cli                 ; enable interrupts
           inx                 ; increment index (x=x+1)
           cpx  #Cylinder4Retard    ;  -00000000 11010001-
           bls  LCC2F          ; branch if lower or same
   LCC44:  rts                 ; return from subroutine

IRQtOut:
           ldaa CPU_TimerStatus    ; load a with memory contents
           bita #0x08          ;  -00001000-
           bne  HandleDwellTimer    ; branch if not equal (not zero)
           ldab BitFlags_82    ; load b with memory contents
           lsrb                ; logical shift right b
           bcc  LCC69          ; branch if greater or equal
           bita #0x20          ;  -00100000-
           beq  Injector34Off    ; branch if equal (zero)
           jsr  HandleOtherTimerInterrupts    
           rti                 ; return from interrupt

Injector34Off:
           ldaa CPU_Port1_ControlRegister    ; load a with memory contents
           anda #0xfb          ; AND a with value -11111011-
           staa CPU_Port1_ControlRegister    ; store a into memory
           ldaa CPU_TimerControl2    ; load a with memory contents
           anda #0xef          ; AND a with value -11101111-
           staa CPU_TimerControl2    ; store a into memory
           ldaa CPU_OCR2_HB    ; load a with memory contents
           staa CPU_OCR2_HB    ; store a into memory
           rti                 ; return from interrupt

   LCC69:  ldx  #CPU_OCR3_HB    ; load index with value
           ldab #0xfb          ; load b with value -11111011-
           bita #0x20          ;  -00100000-
           bne  LCC77          ; branch if not equal (not zero)
           ldx  #CPU_OCR2_HB    ; load index with value
           ldab #0xfd          ; load b with value -11111101-
   LCC77:  ldaa 0x01,x         ; load a with memory at index + value
           staa 0x01,x     
           cmpb #0xfd          ;  -11111101-
           beq  LCC84          ; branch if equal (zero)
           ldx  #Bits_WhichInjector    ; load index with value
           bra  LCC87          ; branch

   LCC84:  ldx  #BitFlags_7f    ; load index with value
   LCC87:  ldaa 0x00,x         ; load a with memory at index + value
           anda #0x03          ; AND a with value -00000011-
           beq  LCC9E          ; branch if equal (zero)
           deca                ; decrement a
           beq  LCC98          ; branch if equal (zero)
           ldab 0x00,x         ; load b with memory at index + value
           andb #0xfc          ;  -11111100-
           aba                 ; a=a+b
           staa 0x00,x     
           rti                 ; return from interrupt

   LCC98:  ldaa 0x00,x         ; load a with memory at index + value
           anda #0xfc          ; AND a with value -11111100-
           staa 0x00,x     
   LCC9E:  andb CPU_TimerControl1
           stab CPU_TimerControl1    ; store b into memory
           rti                 ; return from interrupt

HandleDwellTimer:
           ldaa BitFlags_82    ; load a with memory contents
           bita #0x02          ;  -00000010-
           bne  LCCCD          ; branch if not equal (not zero)
           bita #0x04          ;  -00000100-
           beq  LCCCD          ; branch if equal (zero)
           ldab TimerOverflowsBetweenDistPulses    ; load b with memory contents
           bne  LCCCD          ; branch if not equal (not zero)
           ldaa CPU_TimerControlStatReg    ; load a with memory contents
           eora #0x01          ; XOR a with value -00000001-
           staa CPU_TimerControlStatReg    ; store a into memory
           lsra            
           bcs  LCCBE          ; branch if lower
           ldd  DwellTime_HB    ; load d (a&b) with memory contents
           bra  IgnitionCoil_OnTimeLoad    ; branch

   LCCBE:  lsra            
           bcs  IgnitionCoil_OffTimeLoad    ; branch if lower
           ldaa CPU_TimerControlStatReg    ; load a with memory contents
           anda #0xfe          ; AND a with value -11111110-
           staa CPU_TimerControlStatReg    ; store a into memory
IgnitionCoil_OffTimeLoad:
           ldd  DistributorFallingEdgePulsewidth_HB    ; load d (a&b) with memory contents
           subd DwellTime_HB    ; d = d - memory contents
           bra  IgnitionCoil_OnTimeLoad    ; branch

   LCCCD:  ldd  #0x7000        ; load d (a&b) with value -01110000 00000000-
IgnitionCoil_OnTimeLoad:
           addd CPU_OCR_HB     ; d = d + memory contents
           std  CPU_OCR_HB     ; store D to RAM
           rti                 ; return from interrupt

ControlPurgeSolenoid_MM:
           ; config flag check added 11/07 RCL
           ldaa CONFIG_ConfigurationFlags
           bita #cfg_ShiftLight ; check the bits for Alky Injection and Speed Sensitive Aero
           bne  LCD0C                               ; branch if either bit is set

           ldab BitFlags_81    ; load b with memory contents
           lsrb                ; logical shift right b
           bcs  LCD06          ; branch if lower
           ldab Timer_OpenLoopFraction    ; load b with memory contents
           cmpb LMTOLF2_LimitTimerOpenLoopFraction2    ; compare b with memory contents (data is 2b)
           bcc  LCD06          ; branch if greater or equal
           ldab BaroPressure    ; load b with memory contents
           ldaa Z83_CPU_Port1_copy    ; load a with memory contents
           bita #0x40          ;  -01000000-
           bne  LCCEC          ; branch if not equal (not zero)
           subb PURHYS_CannisterPurgeBaroHysteresis    ; subtract memory contents from b (data is 02)
   LCCEC:  subb PURMAP_CannisterPurgeWhenBelowThisBaro    ; subtract memory contents from b (data is 05)
           cmpb MapValue   
           bcs  LCD06          ; branch if lower
           ldab BitFlags_81    ; load b with memory contents
           bitb #0x10          ;  -00010000-
           bne  LCD00          ; branch if not equal (not zero)
           ldab Timer_CLTIME_ClosedLoopTimer    ; load b with memory contents
           cmpb O2TIME_DelayTimeToClosedLoop    ; compare b with memory contents (data is 15)
           bcs  LCD06          ; branch if lower
   LCD00:  ldaa Z83_CPU_Port1_copy    ; load a with memory contents
           oraa #0x40          ;  -01000000-
           bra  LCD0A          ; branch

   LCD06:  ldaa Z83_CPU_Port1_copy    ; load a with memory contents
           anda #0xbf          ; AND a with value -10111111-
   LCD0A:  staa Z83_CPU_Port1_copy    ; store a into memory
   LCD0C:  rts                 ; return from subroutine

HandleBaroReadRequirement_MM:
           ldaa BitFlags_82    ; load a with memory contents
           bita #0x08          ;  -00001000-
           beq  LCD1A          ; branch if equal (zero)
           ldaa Z83_CPU_Port1_copy    ; load a with memory contents
           oraa #0x01          ;  -00000001-
           staa Z83_CPU_Port1_copy    ; store a into memory
           rts                 ; return from subroutine

   LCD1A:  ldab BitFlags_85    ; load b with memory contents
           bmi  LCD2A          ; branch if minus(hi bit 1)
           ldaa Counter_BaroReadTime    ; load a with memory contents
           tst  Counter_MainLoop1
           bne  LCD2A          ; branch if not equal (not zero)
           inca                ; increment a
           beq  LCD2A          ; branch if equal (zero)
           staa Counter_BaroReadTime    ; store a into memory
   LCD2A:  ldaa BitFlags_81    ; load a with memory contents
           bpl  LCD46          ; branch if plus (hi bit 0)
           ldaa Z83_CPU_Port1_copy    ; load a with memory contents
           oraa #0x01          ;  -00000001-
           staa Z83_CPU_Port1_copy    ; store a into memory
           clra                ; a = 0
           staa BaroReadTimeEngineWithinReadRange    ; store a into memory
           ldaa #0x3f          ; load a with value -00111111-
           anda BitFlags_85    ; logical and a with memory contents
           staa BitFlags_85    ; store a into memory
           ldaa #0xef          ; load a with value -11101111-
           sei                 ; disable interrupts
           anda BitFlags_82    ; logical and a with memory contents
           staa BitFlags_82    ; store a into memory
           cli                 ; enable interrupts
           rts                 ; return from subroutine

   LCD46:  tstb            
           bmi  LCD76          ; branch if minus(hi bit 1)
           ldx  EngineRpm_HB
           cpx  BRPMH2_BaroReadHighRPM66502    ;  (data is 3e80)
           bhi  LCDAE          ; branch if higher
           cpx  BRPML2_BaroReadLowRPM18002    ;  (data is 1c20)
           bcs  LCDAE          ; branch if lower
           ldaa BaroReadTimeEngineWithinReadRange    ; load a with memory contents
           inca                ; increment a
           beq  LCD61          ; branch if equal (zero)
           staa BaroReadTimeEngineWithinReadRange    ; store a into memory
           cmpa BRDLAY_BaroReadDelayAfterThrottleClosed2sec    ; compare a with memory contents (data is 2d)
           bcs  LCDAE          ; branch if lower
   LCD61:  ldaa Counter_BaroReadTime    ; load a with memory contents
           cmpa BARTIM_BaroReadMinTimeBetweenReadings179sec    ; compare a with memory contents (data is 40)
           bcs  LCDAE          ; branch if lower
           bitb #0x40          ;  -01000000-
           bne  LCDAE          ; branch if not equal (not zero)
           ldaa Z83_CPU_Port1_copy    ; load a with memory contents
           anda #0xfe          ; AND a with value -11111110-
           staa Z83_CPU_Port1_copy    ; store a into memory
           ldab #0x80          ; load b with value -10000000-
           bra  LCD8E          ; branch

   LCD76:  inc  Counter_BaroReadTime
           bitb #0x40          ;  -01000000-
           bne  LCD92          ; branch if not equal (not zero)
           ldaa Counter_BaroReadTime    ; load a with memory contents
           cmpa BROPTM_BaroReadDelayAfterSolenoidOpenTenthSec    ; compare a with memory contents (data is 05)
           bcs  LCDAE          ; branch if lower
           ldab #0x40          ; load b with value -01000000-
           ldaa #0x10          ; load a with value -00010000-
           sei                 ; disable interrupts
           oraa BitFlags_82    ; OR a with memory contents
           staa BitFlags_82    ; store a into memory
           cli                 ; enable interrupts
   LCD8E:  orab BitFlags_85
           bra  LCDA9          ; branch

   LCD92:  ldaa BitFlags_82    ; load a with memory contents
           bita #0x10          ;  -00010000-
           bne  LCDAB          ; branch if not equal (not zero)
           ldaa Z83_CPU_Port1_copy    ; load a with memory contents
           oraa #0x01          ;  -00000001-
           staa Z83_CPU_Port1_copy    ; store a into memory
           ldaa Counter_BaroReadTime    ; load a with memory contents
           cmpa BRCLTM_BaroReadDelayAfterSolenoidClosedTenthSec    ; compare a with memory contents (data is 05)
           bcs  LCDAE          ; branch if lower
           ldab #0x7f          ; load b with value -01111111-
           andb BitFlags_85
   LCDA9:  stab BitFlags_85    ; store b into memory
   LCDAB:  clrb                ; b = 0
           stab Counter_BaroReadTime    ; store b into memory
   LCDAE:  rts                 ; return from subroutine

        .msg "..." ; these are just messages to display during assemble to let you know what's going on...

ControlAirConditioning_MM:
           ldaa ACLRPM_DisableAcBelowThisRPM_500    ; load a with memory contents (data is a2)
           sei                 ; disable interrupts
           staa Temp5          ; store a into memory
           ldd  TargetIdleSpeed_HB    ; load d (a&b) with memory contents
           jsr  mul16bit       
           cli                 ; enable interrupts
           std  Temp0          ; store D to RAM
           ldaa Z83_CPU_Port1_copy    ; load a with memory contents
           ldab KeyOnOrEngineRunningTime    ; load b with memory contents
           cmpb ACCTIM_AcDelayFromStartRunTransfer    ; compare b with memory contents (data is 04)
           bcs  LCDEE          ; branch if lower
           ldab BitFlags_85    ; load b with memory contents
           bitb #0x08          ;  -00001000-
           bne  LCDEE          ; branch if not equal (not zero)
           ldab TpsVolts       ; load b with memory contents
           bita #0x10          ;  -00010000-
           beq  LCDD4          ; branch if equal (zero)
           addb #0x03          ;  -00000011-
   LCDD4:  anda #0xef          ; AND a with value -11101111-
           subb MINTHR_LowestSessionTPS    ; b = b-memory contents
           bcs  LCDDF          ; branch if lower
           cmpb ACOUT_DeltaAboveMinThrottleToCutOutAc    ; compare b with memory contents (data is 85)
           bcc  LCDEE          ; branch if greater or equal
   LCDDF:  ldx  EngineRpm_HB
           cpx  ACCRPM_DoNotAllowAcToEngageAboveThisRPM_4000    ;  (data is 3e80)
           bhi  LCDF2          ; branch if higher
           cpx  TargetIdleSpeed_HB
           bcc  LCDF0          ; branch if greater or equal
           cpx  Temp0      
           bcc  LCDF2          ; branch if greater or equal
   LCDEE:  oraa #0x10          ;  -00010000-
   LCDF0:  staa Z83_CPU_Port1_copy    ; store a into memory
   LCDF2:  rts                 ; return from subroutine

ControlAsdRelay_MM:
           ldaa Z83_CPU_Port1_copy    ; load a with memory contents
           ldab BitFlags_81    ; load b with memory contents
           bitb #0x20          ;  -00100000-
           bne  LCE32          ; branch if not equal (not zero)
           ldx  #0x002d        ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           cmpa #0x8f          ; compare a with value -10001111-
           bcc  LCE07          ; branch if greater or equal
           ldx  #AutoCalCell11    ; load index with value
   LCE07:  ldab #0x10          ; load b with value -00010000-
           ldaa BitFlags_81    ; load a with memory contents
           bita #0x02          ;  -00000010-
           bne  LCE1E          ; branch if not equal (not zero)
           ldaa BatteryVolts    ; load a with memory contents
           cmpa #0xb2          ; compare a with value -10110010-
           bcc  LCE26          ; branch if greater or equal
           cpx  #AutoCalCell11    ;  -00000000 01011011-
           bne  LCE26          ; branch if not equal (not zero)
           ldab #0x2e          ; load b with value -00101110-
           bra  LCE26          ; branch

   LCE1E:  ldaa BatteryVolts    ; load a with memory contents
           cmpa #0xb2          ; compare a with value -10110010-
           bcs  LCE26          ; branch if lower
           ldab #0x0a          ; load b with value -00001010-
   LCE26:  ldaa Z83_CPU_Port1_copy    ; load a with memory contents
           anda #0xfd          ; AND a with value -11111101-
           cmpb Counter_TimerPastHalfwayBetweenDistPulses
           bhi  LCE34          ; branch if higher
           cpx  KeyOnOrEngineRunningTime
           bhi  LCE34          ; branch if higher
   LCE32:  oraa #0x02          ;  -00000010-
   LCE34:  staa Z83_CPU_Port1_copy    ; store a into memory
           ldaa BitFlags_81    ; load a with memory contents
           ldab BitFlags_82    ; load b with memory contents
           bmi  LCE46          ; branch if minus(hi bit 1)
           ldab KeyOnOrEngineRunningTime    ; load b with memory contents
           cmpb #0x04          ;  -00000100-
           bcs  LCE46          ; branch if lower
           oraa #0x02          ;  -00000010-
           staa BitFlags_81    ; store a into memory
   LCE46:  rts                 ; return from subroutine

InterruptVector_SpeedometerSignal:
           ldd  CPU_ICR2_HB    ; load d (a&b) with memory contents
           std  Temp5          ; store D to RAM
           ldaa CPU_Port1_ControlRegister    ; load a with memory contents
           lsra            
           bcc  LCE5A          ; branch if greater or equal
           ldab #0x05          ; load b with value -00000101-
   LCE52:  decb            
           bne  LCE52          ; branch if not equal (not zero)
           ldaa CPU_Port1_ControlRegister    ; load a with memory contents
           lsra            
           bcs  JumpTo_ResetSpeedometerInterruptFlag    ; branch if lower
   LCE5A:  ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           subd #0x0640        ;  -00000110 01000000-
           ldaa BitFlags_83    ; load a with memory contents
           bcc  LCE81          ; branch if greater or equal
           bita #0x02          ;  -00000010-
           bne  LCE6B          ; branch if not equal (not zero)
           oraa #0x02          ;  -00000010-
           bra  LCE85          ; branch

   LCE6B:  anda #0x1f          ; AND a with value -00011111-
           oraa #0x01          ;  -00000001-
           staa BitFlags_83    ; store a into memory
           clra                ; a = 0
           staa CruiseControlVar4    ; store a into memory
           staa Counter_SomethingWithDistributor    ; store a into memory
           staa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; store a into memory
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           addd #0x0053    ;  -00000000 01010011-
           std  VehicleSpeed_HB    ; store D to RAM
           bra  JumpTo_ResetSpeedometerInterruptFlag    ; branch

   LCE81:  bita #0x02          ;  -00000010-
           bne  LCED7          ; branch if not equal (not zero)
   LCE85:  adda #0x20          ;  -00100000-
           bcs  LCE8F          ; branch if lower
           anda #0xfd          ; AND a with value -11111101-
           staa BitFlags_83    ; store a into memory
           bra  JumpTo_ResetSpeedometerInterruptFlag    ; branch

   LCE8F:  staa BitFlags_83    ; store a into memory
           ldab CruiseControlVar4    ; load b with memory contents
           beq  LCEB5          ; branch if equal (zero)
           bita #0x01          ;  -00000001-
           bne  LCEB5          ; branch if not equal (not zero)
           ldaa #0x3a          ; load a with value -00111010-
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           cmpa #0x03          ; compare a with value -00000011-
           bcc  LCEA4          ; branch if greater or equal
           ldaa #0x03          ; load a with value -00000011-
   LCEA4:  tab                 ; b = a
           ldaa Counter_SomethingWithDistributor    ; load a with memory contents
           suba CruiseControlVar4
           bcc  LCEAC          ; branch if greater or equal
           nega                ; negate a (set high bit)
   LCEAC:  sba                 ; subtract (a=a-b)
           bcs  LCEB9          ; branch if lower
           ldaa BitFlags_83    ; load a with memory contents
           oraa #0x01          ;  -00000001-
           staa BitFlags_83    ; store a into memory
   LCEB5:  ldab Counter_SomethingWithDistributor    ; load b with memory contents
           stab CruiseControlVar4    ; store b into memory
   LCEB9:  clra                ; a = 0
           staa Counter_SomethingWithDistributor    ; store a into memory
           ldd  Temp5          ; load d (a&b) with memory contents
           bsr  DetermineNumberOfOverflowsBetweenSpeedoPulses_MM    
           ldaa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; load a with memory contents
           lsra            
           staa TimerOverflowsBetweenSpeedoPulses    ; store a into memory
           clra                ; a = 0
           staa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; store a into memory
           ldd  Temp5          ; load d (a&b) with memory contents
           subd PreviousVehicleSpeed_HB    ; d = d - memory contents
           std  SpeedoSensorPulsewidth_HB    ; store D to RAM
   LCECE:  ldd  Temp5          ; load d (a&b) with memory contents
           std  PreviousVehicleSpeed_HB    ; store D to RAM
JumpTo_ResetSpeedometerInterruptFlag:
           ldaa CPU_TimerStatus    ; load a with memory contents
           ldaa CPU_ICR2_HB    ; load a with memory contents
           rti                 ; return from interrupt

   LCED7:  anda #0xfd          ; AND a with value -11111101-
           staa BitFlags_83    ; store a into memory
           clra                ; a = 0
           staa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; store a into memory
           ldaa #0x02          ; load a with value -00000010-
           staa TimerOverflowsBetweenSpeedoPulses    ; store a into memory
           ldd  #0x3280        ; load d (a&b) with value -00110010 10000000-
           std  SpeedoSensorPulsewidth_HB    ; store D to RAM
           bra  LCECE          ; branch

DetermineNumberOfOverflowsBetweenSpeedoPulses_MM:
           subd PreviousVehicleSpeed_HB    ; d = d - memory contents
           staa Temp7          ; store a into memory
           ldaa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; load a with memory contents
           lsrd                ; shift right (d=d/2)
           eorb Temp7      
           bpl  LCEFB          ; branch if plus (hi bit 0)
           ldaa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; load a with memory contents
           inca                ; increment a
           beq  LCEFB          ; branch if equal (zero)
           staa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; store a into memory
   LCEFB:  ldaa Counter_TimerRegHalfOverflowBetweenSpeedoPulses    ; load a with memory contents
           lsra            
           cmpa TimerOverflowsBetweenSpeedoPulses    ; compare a with memory contents
           bcs  LCF04          ; branch if lower
           staa TimerOverflowsBetweenSpeedoPulses    ; store a into memory
   LCF04:  rts                 ; return from subroutine

ControlCruiseServo0_MM:
           ldaa Z83_PortCdata    ; load a with memory contents
           bita #0x40          ;  -01000000-
           bne  CruiseIsSwitchedOn    ; branch if not equal (not zero)
           ldaa CruiseStatus    ; load a with memory contents
           anda #0x8b          ; AND a with value -10001011-
           clrb                ; b = 0
           stab CruiseSpeedSetpoint    ; store b into memory
           stab CruiseControlVar2    ; store b into memory
           jmp  LCF98      

CruiseIsSwitchedOn:
           ldaa CruiseStatus    ; load a with memory contents
           bita #0x80          ;  -10000000-
           beq  LCF29          ; branch if equal (zero)
           ldab Z83_PortCdata    ; load b with memory contents
           bitb #0x02          ;  -00000010-
           bne  LCF29          ; branch if not equal (not zero)
           anda #0xef          ; AND a with value -11101111-
           staa CruiseStatus    ; store a into memory
   LCF29:  ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           lslb            
           adca #0x00          ;  -00000000-
           staa Temp0          ; store a into memory
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd #0x4330        ;  -01000011 00110000-
           bcs  LCF49          ; branch if lower
           subd #0x0af0        ;  -00001010 11110000-
           bcc  DropOutOfCruise    ; branch if greater or equal
           ldaa Temp0          ; load a with memory contents
           suba CruiseSpeedSetpoint
           bcs  DropOutOfCruise    ; branch if lower
           suba #0x08          ;  -00001000-
           bcs  DropOutOfCruise    ; branch if lower
   LCF49:  ldx  VehicleSpeed_HB
           cpx  LOSPCO_CruiseControlLowSpeedCutoutSpeed    ;  (data is 0640)
           bcs  DropOutOfCruise    ; branch if lower

           ;### changed this code to look at the config flags instead of the whole byte

           ldaa CONFIG_ConfigurationFlags
           bpl  LCF5E ;branch if bit 7 is NOT set

;          ldaa Manual00_AutomaticFF    ; load a with memory contents (data is 00)
;          beq  LCF5E          ; branch if equal (zero)
           ldaa Z83_PortCdata    ; load a with memory contents
           bita #0x08          ;  -00001000-
           beq  DropOutOfCruise    ; branch if equal (zero)
           bra  LCF8C          ; branch

   LCF5E:  ldaa TimerOverflowsBetweenDistPulses    ; load a with memory contents
           bne  LCF80          ; branch if not equal (not zero)
           ldaa #0x11          ; load a with value -00010001-
           ldab Temp0          ; load b with memory contents
           sei                 ; disable interrupts
           staa Temp5          ; store a into memory
           ldaa DistributorFallingEdgePulsewidth_HB    ; load a with memory contents
           mul                 ; multiply (d=a*b)
           lsrd                ; shift right (d=d/2)
           jsr  mul16bit       
           cli                 ; enable interrupts
           tsta                ; test a
           beq  LCF76          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   LCF76:  cmpb SCNVHI_CruiseControlForBrakeFlagManualTransmissionClutchDisable    ; compare b with memory contents (data is f1)
           bcc  DropOutOfCruise    ; branch if greater or equal
           cmpb SCNVLO_CruiseControlForBrakeFlagManualTransmissionClutchDisable    ; compare b with memory contents (data is 52)
           bcs  DropOutOfCruise    ; branch if lower
   LCF80:  ldaa CruiseStatus    ; load a with memory contents
           bita #0x80          ;  -10000000-
           bne  LCF8C          ; branch if not equal (not zero)
           ldaa BitFlags_83    ; load a with memory contents
           bita #0x01          ;  -00000001-
           bne  DropOutOfCruise    ; branch if not equal (not zero)
   LCF8C:  ldaa Z83_PortCdata    ; load a with memory contents
           bita #0x10          ;  -00010000-
           beq  LCF9C          ; branch if equal (zero)
DropOutOfCruise:
           clrb                ; b = 0
           ldaa CruiseStatus    ; load a with memory contents
           anda #0x93          ; AND a with value -10010011-
   LCF98:  stab Timer_CruiseDecelerate    ; store b into memory
           bra  LD000          ; branch

   LCF9C:  ldaa Z83_CPU_Port1_copy    ; load a with memory contents
           tab                 ; b = a
           eora Z83_PortAdata
           anda #0xa0          ; AND a with value -10100000-
           beq  LCFD8          ; branch if equal (zero)
           cmpa #0x80          ; compare a with value -10000000-
           bcc  LCFAC          ; branch if greater or equal
           lslb            
           lslb            
   LCFAC:  ldaa #0x01          ; load a with value -00000001-
           tstb            
           bpl  LCFCF          ; branch if plus (hi bit 0)
           ldaa CruiseStatus    ; load a with memory contents
           bita #0x80          ;  -10000000-
           bne  LCFC4          ; branch if not equal (not zero)
           ldaa #0x0f          ; load a with value -00001111-
           jsr  ThrowCriticalError    
           cmpb #0xef          ;  -11101111-
           bne  LCFD8          ; branch if not equal (not zero)
           clr  0x00,x     
           bra  DropOutOfCruise    ; branch

   LCFC4:  ldaa #0x0f          ; load a with value -00001111-
           ldab Z83_PortAdata    ; load b with memory contents
           andb #0xa0          ;  -10100000-
           bne  LCFCF          ; branch if not equal (not zero)
           ldaa #0x7f          ; load a with value -01111111-
   LCFCF:  bita Counter_MainLoop1
           bne  LCFD8          ; branch if not equal (not zero)
           ldaa #0x0f          ; load a with value -00001111-
           jsr  LC94E          
   LCFD8:  ldaa CruiseStatus    ; load a with memory contents
           ldab Z83_PortCdata    ; load b with memory contents
           bitb #0x01          ;  -00000001-
           bne  CruiseControlSet    ; branch if not equal (not zero)
           oraa #0x20          ;  -00100000-
           ldab Timer_CruiseDecelerate    ; load b with memory contents
           incb            
           beq  LCFEA          ; branch if equal (zero)
           stab Timer_CruiseDecelerate    ; store b into memory
   LCFEA:  ldab Timer_CruiseDecelerate    ; load b with memory contents
           cmpb SETIME_CruiseControlNoSetupPulseWhenDecelTimerAboveThis    ; compare b with memory contents (data is 37)
           bcs  LD002          ; branch if lower
           cmpb SETIM1_CruiseControlNoSetupPulseWhenDecelTimerBelowThis    ; compare b with memory contents (data is 5b)
           bcc  LCFFE          ; branch if greater or equal
           bita #0x80          ;  -10000000-
           bne  LD002          ; branch if not equal (not zero)
           oraa #0x04          ;  -00000100-
           bra  LD000          ; branch

   LCFFE:  anda #0xfb          ; AND a with value -11111011-
   LD000:  oraa #0x80          ;  -10000000-
   LD002:  staa CruiseStatus    ; store a into memory
   LD004:  jmp  LD0AB      

CruiseControlSet:
           bita #0x20          ;  -00100000-
           beq  LD06F          ; branch if equal (zero)
           anda #0xdf          ; AND a with value -11011111-
           staa CruiseStatus    ; store a into memory
           ldab Timer_CruiseDecelerate    ; load b with memory contents
           clr  Timer_CruiseDecelerate    ; zero byte at memory location
           cmpb #0x03          ;  -00000011-
           bcs  LD004          ; branch if lower
           bita #0x80          ;  -10000000-
           bne  LD026          ; branch if not equal (not zero)
           ldaa Temp0          ; load a with memory contents
           suba CruiseSpeedSetpoint
           bcs  LD049          ; branch if lower
           cmpa #0x04          ; compare a with value -00000100-
           bls  LD049          ; branch if lower or same
   LD026:  ldaa #0xfe          ; load a with value -11111110-
           sei                 ; disable interrupts
           anda BitFlags_83    ; logical and a with memory contents
           staa BitFlags_83    ; store a into memory
           cli                 ; enable interrupts
           ldaa Temp0          ; load a with memory contents
           staa CruiseSpeedSetpoint    ; store a into memory
           clra                ; a = 0
           ldab CruiseStatus    ; load b with memory contents
           bitb #0x04          ;  -00000100-
           bne  LD041          ; branch if not equal (not zero)
           ldaa CruiseSpeedSetpoint    ; load a with memory contents
           ldx  #SETPW_CruiseControlSetupPulseForSet_FromSpeed    ; load index with value
           jsr  Lookup4ByteTable    
   LD041:  ldab CruiseStatus    ; load b with memory contents
           orab #0x10          ;  -00010000-
           andb #0xfb          ;  -11111011-
           bra  LD055          ; branch

   LD049:  ldaa CruiseSpeedSetpoint    ; load a with memory contents
           adda #0x04          ;  -00000100-
           staa CruiseSpeedSetpoint    ; store a into memory
           ldaa #0x02          ; load a with value -00000010-
           ldab CruiseStatus    ; load b with memory contents
           orab #0x40          ;  -01000000-
   LD055:  andb #0x7f          ;  -01111111-
           stab CruiseStatus    ; store b into memory
           ldab CruiseSpeedSetpoint    ; load b with memory contents
           cmpb MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; compare b with memory contents (data is aa)
           bcs  LD065          ; branch if lower
           ldab MAXSET_CruiseControlMaxSetSpeedTimesTwo    ; load b with memory contents (data is aa)
           bra  LD06B          ; branch

   LD065:  cmpb MINSET_CruiseControlMinSetSpeedTimesTwo    ; compare b with memory contents (data is 3c)
           bcc  LD0A3          ; branch if greater or equal
           clrb                ; b = 0
   LD06B:  stab CruiseSpeedSetpoint    ; store b into memory
           bra  LD0A3          ; branch

   LD06F:  bitb #0x02          ;  -00000010-
           beq  LD0AB          ; branch if equal (zero)
           ldab #0xfe          ; load b with value -11111110-
           sei                 ; disable interrupts
           andb BitFlags_83
           stab BitFlags_83    ; store b into memory
           cli                 ; enable interrupts
           bita #0x50          ;  -01010000-
           bne  LD0AB          ; branch if not equal (not zero)
           anda #0x7f          ; AND a with value -01111111-
           oraa #0x50          ;  -01010000-
           staa CruiseStatus    ; store a into memory
           ldx  #SETPW_CruiseControlSetupPulseForSet_FromSpeed    ; load index with value
           ldaa CruiseSpeedSetpoint    ; load a with memory contents
           jsr  Lookup4ByteTable    
           staa CruiseControlVar3    ; store a into memory
           ldaa CruiseSpeedSetpoint    ; load a with memory contents
           suba Temp0      
           bcs  LD0A5          ; branch if lower
           ldx  #RESTBL_CruiseControlAdditionalSetupPulseForResume_FromSpeedDifference    ; load index with value
           jsr  Lookup4ByteTable    
           adda CruiseControlVar3
           cmpa #0x7f          ; compare a with value -01111111-
           bls  LD0A3          ; branch if lower or same
           ldaa #0x7f          ; load a with value -01111111-
   LD0A3:  staa CruiseControlVar3    ; store a into memory
   LD0A5:  ldaa CruiseStatus    ; load a with memory contents
           oraa #0x08          ;  -00001000-
           staa CruiseStatus    ; store a into memory
   LD0AB:  ldaa Counter_MainLoop1    ; load a with memory contents
           cmpa #0xf3          ; compare a with value -11110011-
           bcc  LD0C5          ; branch if greater or equal
           suba #0x84          ;  -10000100-
           bcc  LD0B7          ; branch if greater or equal
           ldaa Counter_MainLoop1    ; load a with memory contents
   LD0B7:  tab                 ; b = a
           suba #0x42          ;  -01000010-
           bcc  LD0BD          ; branch if greater or equal
           tba                 ; a = b
   LD0BD:  suba #0x0b          ;  -00001011-
           bcc  LD0BD          ; branch if greater or equal
           adda #0x0b          ;  -00001011-
           beq  LD0C8          ; branch if equal (zero)
   LD0C5:  jmp  LD211      

   LD0C8:  clrb                ; b = 0
           ldaa BitFlags_83    ; load a with memory contents
           bita #0x02          ;  -00000010-
           bne  LD11B          ; branch if not equal (not zero)
           ldd  #0xddf2        ; load d (a&b) with value -11011101 11110010-
           std  Temp0          ; store D to RAM
           ldx  SpeedoSensorPulsewidth_HB
           ldaa #0x0d          ; load a with value -00001101-
           ldab TimerOverflowsBetweenSpeedoPulses    ; load b with memory contents
           beq  LD0E8          ; branch if equal (zero)
           cmpb #0x7f          ;  -01111111-
           bcs  LD0E4          ; branch if lower
           clra                ; a = 0
           clrb                ; b = 0
           bra  LD0EF          ; branch

   LD0E4:  ldx  TimerOverflowsBetweenSpeedoPulses
           ldaa #0x05          ; load a with value -00000101-
   LD0E8:  jsr  CalculateVehicleSpeedOrEngineRpms
           addd VehicleSpeed_HB    ; d = d + memory contents
           rora            
           rorb            
   LD0EF:  ldx  VehicleSpeed_HB
           stx  Temp0          ; store index into memory
           std  VehicleSpeed_HB    ; store D to RAM
           ldd  Temp0          ; load d (a&b) with memory contents
           subd VehicleSpeed_HB    ; d = d - memory contents
           bne  LD0FE          ; branch if not equal (not zero)
           clr  CruiseControlVar1    ; zero byte at memory location
   LD0FE:  std  Temp0          ; store D to RAM
           clra                ; a = 0
           ldab CruiseControlVar1    ; load b with memory contents
           bpl  LD106          ; branch if plus (hi bit 0)
           deca                ; decrement a
   LD106:  addd Temp0          ; d = d + memory contents
           asra            
           rorb            
           asld                ; shift left (d=d*2)
           bcs  LD114          ; branch if lower
           tsta                ; test a
           beq  LD11A          ; branch if equal (zero)
           ldab #0x7f          ; load b with value -01111111-
           bra  LD11B          ; branch

   LD114:  cmpa #0xff          ; compare a with value -11111111-
           beq  LD119          ; branch if equal (zero)
           clrb                ; b = 0
   LD119:  sec                 ; set carry
   LD11A:  rorb            
   LD11B:  stab CruiseControlVar1    ; store b into memory
           ldaa CruiseStatus    ; load a with memory contents
           bita #0x08          ;  -00001000-
           bne  LD134          ; branch if not equal (not zero)
           bita #0x80          ;  -10000000-
           bne  LD12E          ; branch if not equal (not zero)
           ldaa Timer_CruiseDecelerate    ; load a with memory contents
           cmpa SETIME_CruiseControlNoSetupPulseWhenDecelTimerAboveThis    ; compare a with memory contents (data is 37)
           bcs  LD137          ; branch if lower
   LD12E:  ldaa #0x0f          ; load a with value -00001111-
   LD130:  oraa #0x80          ;  -10000000-
           staa CruiseControlVar3    ; store a into memory
   LD134:  jmp  LD211      

   LD137:  ldx  #VACREG_CruiseControlVacRegularGainGurve_FromDeltaSpeed    ; load index with value
           clrb                ; b = 0
           ldaa CruiseSpeedSetpoint    ; load a with memory contents
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           subd VehicleSpeed_HB    ; d = d - memory contents
           bcc  LD175          ; branch if greater or equal
           ldx  #VENTRG_CruiseControlVentRegularGainCurve_FromDeltaSpeed    ; load index with value
           coma            
           comb            
           addd #CPU_Port2_DataDirection    ;  -00000000 00000001-
           stab Temp0          ; store b into memory
           ldab CruiseStatus    ; load b with memory contents
           andb #0xbf          ;  -10111111-
           stab CruiseStatus    ; store b into memory
           ldab Temp0          ; load b with memory contents
           tsta                ; test a
           beq  LD15F          ; branch if equal (zero)
           clr  Temp0          ; zero byte at memory location
           dec  Temp0          ; decrement memory contents
   LD15F:  lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           tsta                ; test a
           bne  LD12E          ; branch if not equal (not zero)
           cmpb VNTAB1_CruiseControlLimitToAMaxVent    ; compare b with memory contents (data is 70)
           bcc  LD12E          ; branch if greater or equal
           tba                 ; a = b
           ldab Temp0          ; load b with memory contents
           cmpa VNTAB2_CruiseControlLimitToHalfMaxVent    ; compare a with memory contents (data is 50)
           bcs  LD18C          ; branch if lower
           ldaa #0x05          ; load a with value -00000101-
           bra  LD130          ; branch

   LD175:  tsta                ; test a
           beq  LD17A          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   LD17A:  ldaa CruiseStatus    ; load a with memory contents
           bita #0x40          ;  -01000000-
           beq  LD18C          ; branch if equal (zero)
           ldx  #VACACC_CruiseControlVacAcceleratedGainCurve_FromDeltaSpeed    ; load index with value
           cmpb ACLRST_CruiseControlDeltaSpeedToResetAccFlag    ; compare b with memory contents (data is 05)
           bcc  LD18C          ; branch if greater or equal
           anda #0xbf          ; AND a with value -10111111-
           staa CruiseStatus    ; store a into memory
   LD18C:  tba                 ; a = b
           jsr  Lookup4ByteTable    
           clra                ; a = 0
           tstb            
           bpl  LD195          ; branch if plus (hi bit 0)
           deca                ; decrement a
   LD195:  std  Temp0          ; store D to RAM
           ldx  #THGAIN_CruiseControlThrottleGainFactor_FromThrottle    ; load index with value
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bcc  LD1A1          ; branch if greater or equal
           clra                ; a = 0
   LD1A1:  jsr  Lookup4ByteTable    
           staa Temp4          ; store a into memory
           ldx  #SPGAIN_CruiseControlSpeedGainFactor_FromSpeed    ; load index with value
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    
           adda Temp4      
           staa Temp3          ; store a into memory
           clra                ; a = 0
           staa Temp2          ; store a into memory
           ldab CruiseControlVar2    ; load b with memory contents
           bpl  LD1BD          ; branch if plus (hi bit 0)
           deca                ; decrement a
   LD1BD:  addd Temp0          ; d = d + memory contents
           std  Temp0          ; store D to RAM
           clra                ; a = 0
           ldab CruiseControlVar1    ; load b with memory contents
           bpl  LD1C7          ; branch if plus (hi bit 0)
           deca                ; decrement a
   LD1C7:  asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd Temp0          ; d = d + memory contents
           staa Temp0          ; store a into memory
           bpl  LD1D4          ; branch if plus (hi bit 0)
           coma            
           comb            
           addd #CPU_Port2_DataDirection    ;  -00000000 00000001-
   LD1D4:  subd Temp2          ; d = d - memory contents
           bcc  LD1E3          ; branch if greater or equal
           addb Temp3          ; b=b+memory contents
           ldaa Temp0          ; load a with memory contents
           bpl  LD1DF          ; branch if plus (hi bit 0)
           negb            
   LD1DF:  stab CruiseControlVar2    ; store b into memory
           bra  LD211          ; branch

   LD1E3:  clra                ; a = 0
           staa CruiseControlVar2    ; store a into memory
           ldaa Temp0          ; load a with memory contents
           anda #0x80          ; AND a with value -10000000-
           oraa #0x01          ;  -00000001-
           ldab CruiseControlVar3    ; load b with memory contents
           beq  LD1F7          ; branch if equal (zero)
           bpl  LD211          ; branch if plus (hi bit 0)
           tab                 ; b = a
           eorb CruiseControlVar3
           bpl  LD211          ; branch if plus (hi bit 0)
   LD1F7:  ldab TpsVolts       ; load b with memory contents
           subb MINTHR_LowestSessionTPS    ; b = b-memory contents
           bcc  LD1FE          ; branch if greater or equal
           clrb                ; b = 0
   LD1FE:  tsta                ; test a
           bpl  LD209          ; branch if plus (hi bit 0)
           cmpb CLOTHR_CruiseControlDontVentIfThrottleBelowThis    ; compare b with memory contents (data is 03)
           bcs  LD20E          ; branch if lower
           inca                ; increment a
           bra  LD20F          ; branch

   LD209:  cmpb MAXTHR_CruiseControlDontVacIfThrottleAboveThis    ; compare b with memory contents (data is 50)
           bcs  LD20F          ; branch if lower
   LD20E:  clra                ; a = 0
   LD20F:  staa CruiseControlVar3    ; store a into memory
   LD211:  ldaa Z83_CPU_Port1_copy    ; load a with memory contents
           anda #0x5f          ; AND a with value -01011111-
           ldab CruiseStatus    ; load b with memory contents
           andb #0xf7          ;  -11110111-
           stab CruiseStatus    ; store b into memory
           bmi  LD223          ; branch if minus(hi bit 1)
           ldab CruiseControlVar3    ; load b with memory contents
           beq  LD225          ; branch if equal (zero)
           bpl  LD227          ; branch if plus (hi bit 0)
   LD223:  oraa #0xa0          ;  -10100000-
   LD225:  oraa #0x20          ;  -00100000-
   LD227:  staa Z83_CPU_Port1_copy    ; store a into memory
           ldab CruiseControlVar3    ; load b with memory contents
           beq  LD235          ; branch if equal (zero)
           asld                ; shift left (d=d*2)
           subb #0x02          ;  -00000010-
           beq  LD233          ; branch if equal (zero)
           lsrd                ; shift right (d=d/2)
   LD233:  stab CruiseControlVar3    ; store b into memory
   LD235:  rts                 ; return from subroutine

        .msg "..." ; these are just messages to display during assemble to let you know what's going on...

ControlCruiseServo1_MM:
           ldaa BitFlags_83    ; load a with memory contents
           bita #0x02          ;  -00000010-
           beq  LD24D          ; branch if equal (zero)
           sei                 ; disable interrupts
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           std  Temp0          ; store D to RAM
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           subd Temp0          ; d = d - memory contents
           std  VehicleSpeed_HB    ; store D to RAM
           cli                 ; enable interrupts
   LD24D:  rts                 ; return from subroutine

MM_LD24E:
           ldd  #0x060a        ; load d (a&b) with value -00000110 00001010-
           tst  BitFlags_84
           bpl  LD257          ; branch if plus (hi bit 0)
           deca                ; decrement a
   LD257:  stD  CPU_SCI_ModeControlReg    ; store D to RAM
           ldd  #0xbef6        ; load d (a&b) with value -10111110 11110110-
           std  CPU_Port1_DataDirection    ; store D to RAM
           sei                 ; disable interrupts
           ldd  CPU_TimerControl1    ; load d (a&b) with memory contents
           oraa #0xe0          ;  -11100000-
           andb #0xfb          ;  -11111011-
           orab #0xc0          ;  -11000000-
           stD CPU_TimerControl1    ; store D to RAM
           cli                 ; enable interrupts
           clra                ; a = 0
           staa Z83_PortAcontrol
           staa Z83_PortBcontrol
           staa Z83_PortCDataDirection
           staa Z83_PortCcontrol
           rts                 ; return from subroutine

           ;.org 0xD278
ADConversionOutputTable:
		.word	AmbientAirTempVolts
		.word	O2SensorVolts
		.word	ChargeTempVolts
		.word	CoolantTemp
		.word	TpsVolts
		.word	KnockVolts
		.word	BatteryVolts
		.word	BaroPressure
		.word	TpsVolts
ADConversionPatternTable:
		.byte	0x00
                .byte   0x20
                .byte   0x10
                .byte   0x30
                .byte   0x40
TestASDRelay:
           sei                 ; disable interrupts
           ldaa Z83_PortAdata    ; load a with memory contents
           oraa #0x02          ;  -00000010-
           staa Z83_PortAdata
           ldab Z83_PortADataDirection    ; load b with memory contents
           stab Temp0          ; store b into memory
           orab #0x02          ;  -00000010-
           stab Z83_PortADataDirection    ; store b into memory
           bsr  TimeWaste
           bsr  TimeWaste
           andb #0xfd          ;  -11111101-
           stab Z83_PortADataDirection    ; store b into memory
           bsr  TimeWaste
           bsr  TimeWaste
           ldaa Z83_PortAdata    ; load a with memory contents
           orab #0x02          ;  -00000010-
           stab Z83_PortADataDirection    ; store b into memory
           ldab Z83_CPU_Port1_copy    ; load b with memory contents
           stab Z83_PortAdata    ; store b into memory
           bsr  TimeWaste
           bsr  TimeWaste      
           ldab Temp0          ; load b with memory contents
           stab Z83_PortADataDirection    ; store b into memory
           cli                 ; enable interrupts
           bita #0x02          ;  -00000010-
           bne  TimeWaste      ; branch if not equal (not zero)
           ldab #0x61          ; load b with value -01100001-
           ldaa BitFlags_C9    ; load a with memory contents
           cmpa #0x60          ; compare a with value -01100000-
           bls  LD2DF          ; branch if lower or same
           ldab #0x70          ; load b with value -01110000-
           cmpa #0x69          ; compare a with value -01101001-
           beq  LD2DF          ; branch if equal (zero)
           clrb                ; b = 0
           cmpa #0x72          ; compare a with value -01110010-
           bcc  LD2DF          ; branch if greater or equal
           inca                ; increment a
           tab                 ; b = a
   LD2DF:  stab BitFlags_C9    ; store b into memory
TimeWaste:
           rts                 ; return from subroutine

DRB_SendROMSerial_MM:
           ldaa BitFlags_84    ; load a with memory contents
           bpl  LD311          ; branch if plus (hi bit 0)
           ldd  CPU_SCI_TxRxCntrlReg    ; load d (a&b) with memory contents
           cmpb #0xfa          ;  -11111010-
           bne  SendRamSerial    ; branch if not equal (not zero)
           ldx  #ENDITM_ECUID    ; load index with value
           ldaa Counter_MainLoop1    ; load a with memory contents
           lsra            
           bcc  LD2F5          ; branch if greater or equal
           inx                 ; increment index (x=x+1)
   LD2F5:  ldab 0x00,x         ; load b with memory at index + value
           jmp  SendByteSerial

SendRamSerial:
           ldx  #0x0000        ; load index with value
           abx                 ; add b to index
           ldab 0x00,x         ; load b with memory at index + value
           ldaa BitFlags_84    ; load a with memory contents
           anda #0xfb          ; AND a with value -11111011-
           cpx  #0x00fe        ;  -00000000 11111110-
           bne  LD30D          ; branch if not equal (not zero)
           ldab EngineRpm_HB    ; load b with memory contents
           oraa #0x04          ;  -00000100-
   LD30D:  staa BitFlags_84    ; store a into memory
           bra  SendByteSerial    ; branch

   LD311:  ldaa Counter_MainLoop1    ; load a with memory contents
           anda #0x3f          ; AND a with value -00111111-
           cmpa #0x07          ; compare a with value -00000111-
           bne  LD31C          ; branch if not equal (not zero)
           jsr  TestASDRelay    
   LD31C:  ldaa Counter_MainLoop1    ; load a with memory contents
           bita #0x07          ;  -00000111-
           bne  LD384          ; branch if not equal (not zero)
           ldab BitFlags_C9    ; load b with memory contents
           beq  HandleSerial    ; branch if equal (zero)
           ldaa CPU_SCI_TxRxCntrlReg    ; load a with memory contents
           bpl  DiagnosticsOff    ; branch if plus (hi bit 0)
           ldaa CPU_SCI_RxDataReg    ; load a with memory contents
           cmpa #0xf0          ; compare a with value -11110000-
           bne  DiagnosticsOff    ; branch if not equal (not zero)
           cmpb #0x70          ;  -01110000-
           bne  LD385          ; branch if not equal (not zero)
           jmp  LD42C      

HandleSerial:
           ldaa BitFlags_84    ; load a with memory contents
           anda #0xfb          ; AND a with value -11111011-
           ldab CPU_SCI_TxRxCntrlReg    ; load b with memory contents
           bpl  NoByteWaiting    ; branch if plus (hi bit 0)
           ldab CPU_SCI_RxDataReg    ; load b with memory contents
           cmpb #0x12          ;  -00010010-
           bne  NotCode12      ; branch if not equal (not zero)
           ldab #0x05          ; load b with value -00000101-
           stab CPU_SCI_ModeControlReg    ; store b into memory
           oraa #0x80          ;  -10000000-
NotCode12:
           cmpb #0xf0          ;  -11110000-
           bne  NoByteWaiting    ; branch if not equal (not zero)
           oraa #0x04          ;  -00000100-
NoByteWaiting:
           staa BitFlags_84    ; store a into memory
           ldaa CPU_SCI_RxDataReg    ; load a with memory contents
           ldaa O2SensorVolts    ; load a with memory contents
           ldab #0xff          ; load b with value -11111111-
           cmpa O2MIDH_HighLimitForInMiddleDetermination    ; compare a with memory contents (data is 1c)
           bhi  LD365          ; branch if higher
           cmpa O2MIDL_LowLimitForInMiddleDetermination    ; compare a with memory contents (data is 12)
           bhi  LD367          ; branch if higher
           andb #0xa0          ;  -10100000-
   LD365:  andb #0xb1          ;  -10110001-
   LD367:  ldx  #Timer_DelayBeforeUpdating_MINTHR    ; load index with value
   LD36A:  inx                 ; increment index (x=x+1)
           cpx  #MaxRetardFromMAP    ;  -00000000 11010010-
           beq  SendByteSerial    ; branch if equal (zero)
           ldaa 0x00,x         ; load a with memory at index + value
           anda #0x3f          ; AND a with value -00111111-
           beq  LD36A          ; branch if equal (zero)
           andb #0x0f          ;  -00001111-
           orab #0x80          ;  -10000000-
           bra  SendByteSerial    ; branch

DiagnosticsOff:
           ldaa BitFlags_84    ; load a with memory contents
           anda #0xfb          ; AND a with value -11111011-
           staa BitFlags_84    ; store a into memory
SendByteSerial:
           stab CPU_SCI_TxDataReg    ; store b into memory
   LD384:  rts                 ; return from subroutine

   LD385:  ldaa BitFlags_84    ; load a with memory contents
           anda #0xfb          ; AND a with value -11111011-
           staa BitFlags_84    ; store a into memory
           ldx  #ADConversionOutputTable-2     ; load index with value
           andb #0x1f          ;  -00011111-
           lslb            
           abx                 ; add b to index
           ldx  0x00,x     
           ldaa 0x00,x         ; load a with memory at index + value
           lsrb                ; logical shift right b
           cmpb #0x09          ;  -00001001-
           bne  LD3A0          ; branch if not equal (not zero)
           suba MINTHR_LowestSessionTPS
           bcc  LD3A0          ; branch if greater or equal
           clra                ; a = 0
   LD3A0:  cmpb #0x06          ;  -00000110-
           bne  LD3D6          ; branch if not equal (not zero)
           clrb                ; b = 0
           stab Temp0          ; store b into memory
           stab Temp1          ; store b into memory
           ldx  #Cylinder2Retard    ; load index with value
   LD3AC:  ldaa 0x00,x         ; load a with memory at index + value
           anda #0x3f          ; AND a with value -00111111-
           incb            
           cmpa Temp1          ; compare a with memory contents
           bls  LD3B9          ; branch if lower or same
           staa Temp1          ; store a into memory
           stab Temp0          ; store b into memory
   LD3B9:  inx                 ; increment index (x=x+1)
           cpx  #MaxRetardFromMAP    ;  -00000000 11010010-
           bcs  LD3AC          ; branch if lower
           ldx  #ADConversionPatternTable    ; load index with value
           ldab Temp0          ; load b with memory contents
           abx                 ; add b to index
           ldab Temp1          ; load b with memory contents
           ldaa #0xb4          ; load a with value -10110100-
           mul                 ; multiply (d=a*b)
           cmpa #0x09          ; compare a with value -00001001-
           bls  LD3D0          ; branch if lower or same
           ldaa #0x09          ; load a with value -00001001-
   LD3D0:  ldab 0x00,x         ; load b with memory at index + value
           aba                 ; a=a+b
           tab                 ; b = a
           bra  SendByteSerial    ; branch

   LD3D6:  cmpb #0x04          ;  -00000100-
           bne  LD3E4          ; branch if not equal (not zero)
           ldab #0x2e          ; load b with value -00101110-
           mul                 ; multiply (d=a*b)
           adca #0xec          ;  -11101100-
           bcs  LD41A          ; branch if lower
           clra                ; a = 0
           bra  LD41A          ; branch

   LD3E4:  cmpb #0x07          ;  -00000111-
           bne  LD3F3          ; branch if not equal (not zero)
           ldab #0xfd          ; load b with value -11111101-
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           lsra            
           lsra            
           lsra
           lsra            
           bra  LD418          ; branch

   LD3F3:  cmpb #0x08          ;  -00001000-
           bne  LD40D          ; branch if not equal (not zero)
           ldab #0x3b          ; load b with value -00111011-
           suba MapValue   
           bcc  LD417          ; branch if greater or equal
           nega                ; negate a (set high bit)
           ldab #0x1d          ; load b with value -00011101-
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           cmpa #0x09          ; compare a with value -00001001-
           bhi  LD41A          ; branch if higher
           oraa #0xa0          ;  -10100000-
           tab                 ; b = a
           jmp  SendByteSerial

   LD40D:  cmpb #0x12          ;  -00010010-
           beq  LD432          ; branch if equal (zero)
           cmpb #0x11          ;  -00010001-
           beq  LD452          ; branch if equal (zero)
           ldab #0x32          ; load b with value -00110010-
   LD417:  mul                 ; multiply (d=a*b)
   LD418:  adca #0x00          ;  -00000000-
   LD41A:  sei                 ; disable interrupts
           staa Temp5          ; store a into memory
           ldd  #0x199a        ; load d (a&b) with value -00011001 10011010-
           jsr  mul16bit
           ldab #0x06          ; load b with value -00000110-
           mul                 ; multiply (d=a*b)
           addb Temp5          ; b=b+memory contents
           cli                 ; enable interrupts
           jmp  SendByteSerial

   LD42C:  ldaa BitFlags_84    ; load a with memory contents
           oraa #0x04          ;  -00000100-
           staa BitFlags_84    ; store a into memory
   LD432:  ldaa Counter_MainLoop1    ; load a with memory contents
           bita #0x7f          ;  -01111111-
           beq  LD439          ; branch if equal (zero)
   LD438:  rts                 ; return from subroutine

   LD439:  ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           bita #0xe0          ;  -11100000-
           beq  LD442          ; branch if equal (zero)
           ldd  #0xffff        ; load d (a&b) with value -11111111 11111111-
   LD442:  asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           ldab #0xcd          ; load b with value -11001101-
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
   LD44A:  cmpa #0x63          ; compare a with value -01100011-
           bcs  LD41A          ; branch if lower
           ldaa #0x63          ; load a with value -01100011-
           bra  LD41A          ; branch

   LD452:  ldaa Counter_MainLoop1    ; load a with memory contents
           bita #0x1f          ;  -00011111-
           bne  LD438          ; branch if not equal (not zero)
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           bra  LD44A          ; branch

        .msg "..." ; these are just messages to display during assemble to let you know what's going on...

KnockDetect_MM:
           clra                ; a = 0
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb KNKRPM_MinRpmforKnockRetard    ; compare b with memory contents (data is 10)
           bcs  LD48C          ; branch if lower
           ldx  #RETMAX_MaxKnockRetardFromMap    ; load index with value
           deca                ; decrement a
           ldab BitFlags_80    ; load b with memory contents
           andb #0xc0          ;  -11000000-
           bne  LD489          ; branch if not equal (not zero)
           ldaa MapValue       ; load a with memory contents
           ldab TpsVolts       ; load b with memory contents
           subb MINTHR_LowestSessionTPS    ; b = b-memory contents
           bcs  LD489          ; branch if lower
           cmpb THRKNK_DeltaAbove_MINTHR    ; compare b with memory contents (data is 53)
           bcs  LD489          ; branch if lower
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb KLMRPM_MinKnockDetectRpm    ; compare b with memory contents (data is 10)
           bcc  LD489          ; branch if greater or equal
           ldaa KNKLIM_MaxKnockRetard    ; load a with memory contents (data is 04)
           bra  LD48C          ; branch

   LD489:  jsr  Lookup4ByteTable    
   LD48C:  staa MaxRetardFromMAP    ; store a into memory
           ldaa EngineRpm_HB    ; load a with memory contents
           ldx  #DLTKNK_KnockFromRpms    ; load index with value
           jsr  Lookup4ByteTable    
           staa KnockLookup    ; store a into memory
           rts                 ; return from subroutine

WorkWithPowerLossLight_MM:
           ldaa BitFlags_82    ; load a with memory contents
           bpl  LD4A8          ; branch if plus (hi bit 0)
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           bne  LD4BF          ; branch if not equal (not zero)
   LD4A1:  ldab #0x20          ; load b with value -00100000-
           sei                 ; disable interrupts
           orab CPU_Port1_ControlRegister
           bra  LD4C4          ; branch

   LD4A8:  ldaa BitFlags_84    ; load a with memory contents
           bita #0x08          ;  -00001000-
           beq  LD4B2          ; branch if equal (zero)
           ldaa BitFlags_81    ; load a with memory contents
           bmi  LD4A1          ; branch if minus(hi bit 1)
   LD4B2:  ldaa BitFlags_80    ; load a with memory contents
           bita BF80PL_BF80PowerLossLightMask    ;  (data is db)
           bne  LD4A1          ; branch if not equal (not zero)
           ldaa BitFlags_4f    ; load a with memory contents
           bita #0x20          ;  -00100000-
           bne  LD4A1          ; branch if not equal (not zero)
   LD4BF:  ldab #0xdf          ; load b with value -11011111-
           sei                 ; disable interrupts
           andb CPU_Port1_ControlRegister
   LD4C4:  stab CPU_Port1_ControlRegister    ; store b into memory
           cli                 ; enable interrupts
           rts                 ; return from subroutine

DetermineIfWindowedBladeInSyncSensorOnDistributor_MM:
           ldaa BitFlags_85    ; load a with memory contents
           ldab BitFlags_82    ; load b with memory contents
           bpl  LD4E8          ; branch if plus (hi bit 0)
           bitb #0x04          ;  -00000100-
           bne  LD4E8          ; branch if not equal (not zero)
           ldab CPU_Port2_ControlRegister    ; load b with memory contents
           lsrb                ; logical shift right b
           bcs  LD4EA          ; branch if lower
           ldab Z83_PortCdata    ; load b with memory contents
           bmi  LD4E0          ; branch if minus(hi bit 1)
           oraa #0x01          ;  -00000001-
           bra  LD4EC          ; branch

   LD4E0:  bita #0x01          ;  -00000001-
           beq  LD4EE          ; branch if equal (zero)
           oraa #0x02          ;  -00000010-
           bra  LD4EC          ; branch

   LD4E8:  anda #0xfd          ; AND a with value -11111101-
   LD4EA:  anda #0xfe          ; AND a with value -11111110-
   LD4EC:  staa BitFlags_85    ; store a into memory
   LD4EE:  rts                 ; return from subroutine

NMIInterrupt:
           sts  StackPtrTemp_HB
           lds  #0x6000        ;  -01100000 00000000-
           ldaa MINTHR_LowestSessionTPS    ; load a with memory contents
           staa LowestHistoricalTPS    ; store a into memory
           ldaa #0x83          ; load a with value -10000011-
           staa CPU_RAM_ControlReg    ; store a into memory
           ldd  #0x060a        ; load d (a&b) with value -00000110 00001010-
           stD  CPU_SCI_ModeControlReg    ; store D to RAM
           ldd  #0xff32        ; load d (a&b) with value -11111111 00110010-
           staa Z83_PortAdata
           staa Z83_PortADataDirection
   LD50A:  decb            
           beq  LD513          ; branch if equal (zero)
           jmp  LD50A      

JustJump:
           jmp  NMIInterrupt

   LD513:  ldaa #0xc3          ; load a with value -11000011-
           staa CPU_RAM_ControlReg    ; store a into memory
           ldaa Z83_CPU_Port1_copy    ; load a with memory contents
           staa Z83_PortAdata
           lds  StackPtrTemp_HB
           tst  StackPtrTemp_HB
           bne  JumpToReset    ; branch if not equal (not zero)
           rti                 ; return from interrupt

JumpToReset:
           jmp  ResetRoutine

DealWithColdLoadEnrichment_MM:
           ldab BitFlags_82    ; load b with memory contents
           bmi  LD585          ; branch if minus(hi bit 1)
           ldab BitFlags_84    ; load b with memory contents
           bitb #0x02          ;  -00000010-
           bne  LD55C          ; branch if not equal (not zero)
           ldab BitFlags_81    ; load b with memory contents
           bitb #0x10          ;  -00010000-
           bne  LD552          ; branch if not equal (not zero)
           ldab HOTHLD_CurveAHotHoldTime    ; load b with memory contents (data is 15)
           ldaa CoolantTemp    ; load a with memory contents
           cmpa TMPHLD_TempSwitchPointForCurveAHoldDecay    ; compare a with memory contents (data is b2)
           bcs  LD544          ; branch if lower
           ldab CLDHLD_CurveAColdHoldTime    ; load b with memory contents (data is 80)
   LD544:  stab Temp0          ; store b into memory
           ldd  KeyOnOrEngineRunningTime    ; load d (a&b) with memory contents
           bita #0xc0          ;  -11000000-
           bne  LD552          ; branch if not equal (not zero)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           cmpa Temp0          ; compare a with memory contents
           bcs  LD56B          ; branch if lower
   LD552:  ldaa #0xff          ; load a with value -11111111-
           staa Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached    ; store a into memory
           ldaa BitFlags_84    ; load a with memory contents
           oraa #0x02          ;  -00000010-
           staa BitFlags_84    ; store a into memory
   LD55C:  ldab DCYTMH_CurveAHotDecayTime    ; load b with memory contents (data is 09)
           ldaa CoolantTemp    ; load a with memory contents
           cmpa TMPHLD_TempSwitchPointForCurveAHoldDecay    ; compare a with memory contents (data is b2)
           bcs  LD573          ; branch if lower
           ldab DCYTMC_CurveAColdDecayTime    ; load b with memory contents (data is 04)
           bra  LD573          ; branch

   LD56B:  cmpa CCURV_HoldTimeForCurveC    ; compare a with memory contents (data is 0a)
           bcs  LD585          ; branch if lower
           ldab DCYCC_DecayRateForCurveC    ; load b with memory contents (data is 0d)
   LD573:  ldaa TimerOverflowsBetweenDistPulses    ; load a with memory contents
           bne  LD585          ; branch if not equal (not zero)
           ldaa Counter_MainLoop1    ; load a with memory contents
           bita #0x1f          ;  -00011111-
           bne  LD585          ; branch if not equal (not zero)
           ldaa Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached    ; load a with memory contents
           sba                 ; subtract (a=a-b)
           bcc  LD583          ; branch if greater or equal
           clra                ; a = 0
   LD583:  staa Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached    ; store a into memory
   LD585:  rts                 ; return from subroutine

ToggleSerialClock_MM:
           ldaa CPU_Port2_ControlRegister    ; load a with memory contents
           eora #0x04          ; XOR a with value -00000100-
           staa CPU_Port2_ControlRegister    ; store a into memory
           rts                 ; return from subroutine

Lookup4ByteTable:
           ldab 0x00,x         ; load b with memory at index + value
           stab Temp3          ; store b into memory
           inx                 ; increment index (x=x+1)
           cmpa 0x00,x         ; compare a with memory at index + value
           bhi  KeepScanning    ; branch if higher
ReturnTableValue:
           ldaa 0x01,x         ; load a with memory at index + value
           tab                 ; b = a
           rts                 ; return from subroutine

KeepScanning:
           ldab #0x04          ; load b with value -00000100-
NextTableEntry:
           dec  Temp3          ; decrement memory contents
           beq  ReturnTableValue    ; branch if equal (zero)
           cmpa 0x04,x         ; compare a with memory at index + value
           bcs  FoundTableEntry    ; branch if lower
           abx                 ; add b to index
           bra  NextTableEntry    ; branch

FoundTableEntry:
           suba 0x00,x     
           staa Temp2          ; store a into memory
           ldd  0x02,x     
           psha                ; push a onto stack
           ldaa Temp2          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           staa Temp3          ; store a into memory
           ldaa Temp2          ; load a with memory contents
           pulb                ; pull b from stack
           mul                 ; multiply (d=a*b)
           addb Temp3          ; b=b+memory contents
           addb 0x01,x         ; add memory at index + value to b
           tba                 ; a = b
           rts                 ; return from subroutine

mul16bit:
    ; multiplies Temp5 (byte) by d, leaves result in d
           psha                ; push a onto stack
           ldaa Temp5          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           staa Temp6          ; store a into memory
           ldaa Temp5          ; load a with memory contents
           pulb                ; pull b from stack
           mul                 ; multiply (d=a*b)
           addb Temp6          ; b=b+memory contents
           bcc  donemul        ; branch if greater or equal
           inca                ; increment a
donemul:
           rts                 ; return from subroutine

Lookup5ByteTable:
           ldab #0x05          ; load b with value -00000101-
           cmpa 0x00,x         ; compare a with memory at index + value
           bhi  ChecktableEntry5    ; branch if higher
           ldd  0x01,x     
           rts                 ; return from subroutine

NextTableEntry5:
           abx                 ; add b to index
ChecktableEntry5:
           cmpa 0x05,x         ; compare a with memory at index + value
           bhi  NextTableEntry5    ; branch if higher
           suba 0x00,x     
           staa Temp5          ; store a into memory
           ldd  0x03,x     
           bsr  mul16bit       
           addd 0x01,x     
           rts                 ; return from subroutine

ScaleXbySignedB_ReturnD:
           pshb                ; push b onto stack
           lsra            
           ldd  0x00,x     
           bcs  LD5F3          ; branch if lower
           clra                ; a = 0
           clrb                ; b = 0
   LD5F3:  std  0x02,x         ; store d into index plus offset
           ldaa 0x01,x         ; load a with memory at index + value
           pulb                ; pull b from stack
           pshb                ; push b onto stack
           mul                 ; multiply (d=a*b)
           adca 0x03,x     
           bcc  LD600          ; branch if greater or equal
           inc  0x02,x     
   LD600:  staa 0x03,x     
           pulb                ; pull b from stack
           ldaa 0x00,x         ; load a with memory at index + value
           mul                 ; multiply (d=a*b)
           addd 0x02,x     
           bcc  LD60D          ; branch if greater or equal
           ldd  #0xffff        ; load d (a&b) with value -11111111 11111111-
   LD60D:  rts                 ; return from subroutine

        .msg "..." ; these are just messages to display during assemble to let you know what's going on...

DetermineNumberOfOverflowsBetweenDistributorPulses_MM:
           subd LastDistributorFallingEdgeTime_HB    ; d = d - memory contents
           staa Temp5          ; store a into memory
           ldaa Counter_TimerPastHalfwayBetweenDistPulses    ; load a with memory contents
           lsrd                ; shift right (d=d/2)
           eorb Temp5      
           bpl  LD620          ; branch if plus (hi bit 0)
           ldaa Counter_TimerPastHalfwayBetweenDistPulses    ; load a with memory contents
           inca                ; increment a
           beq  LD620          ; branch if equal (zero)
           staa Counter_TimerPastHalfwayBetweenDistPulses    ; store a into memory
   LD620:  ldaa Counter_TimerPastHalfwayBetweenDistPulses    ; load a with memory contents
           lsra            
           cmpa TimerOverflowsBetweenDistPulses    ; compare a with memory contents
           bcs  LD629          ; branch if lower
           staa TimerOverflowsBetweenDistPulses    ; store a into memory
   LD629:  rts                 ; return from subroutine

ProcessMapOrTpsBlockData:
           ldaa 0x03,x         ; load a with memory at index + value
           bne  LD633          ; branch if not equal (not zero)
           clrb                ; b = 0
           ldaa 0x02,x         ; load a with memory at index + value
           bra  LD642          ; branch

   LD633:  staa Temp5          ; store a into memory
           ldd  0x00,x     
           bsr  mul16bit       
           std  Temp7          ; store D to RAM
           ldd  0x02,x     
           mul                 ; multiply (d=a*b)
           subd Temp7          ; d = d - memory contents
           addd 0x00,x     
   LD642:  std  0x00,x         ; store d into index plus offset
           rts                 ; return from subroutine

CalculateEngineRpm_MM:
           ldx  DistributorFallingEdgePulsewidth_HB
           ldd  #0xe4e2        ; load d (a&b) with value -11100100 11100010-
           std  Temp0          ; store D to RAM
           ldaa #0x0c          ; load a with value -00001100-
           ldab TimerOverflowsBetweenDistPulses    ; load b with memory contents
           beq  CalculateVehicleSpeedOrEngineRpms          ; branch if equal (zero)
           ldx  TimerOverflowsBetweenDistPulses
           ldaa #0x04          ; load a with value -00000100-
CalculateVehicleSpeedOrEngineRpms:
           stx  Temp2          ; store index into memory
           staa Temp4          ; store a into memory
           ldx  #Temp0         ; load index with value
           ldd  0x02,x     
           bne  LD665          ; branch if not equal (not zero)
           coma            
           comb            
           bra  LD68C          ; branch

   LD665:  bmi  LD66E          ; branch if minus(hi bit 1)
   LD667:  inc  0x04,x     
           asld                ; shift left (d=d*2)
           bpl  LD667          ; branch if plus (hi bit 0)
           std  0x02,x         ; store d into index plus offset
   LD66E:  ldd  Temp0          ; load d (a&b) with memory contents
           clr  0x00,x     
           clr  0x01,x     
   LD674:  subd 0x02,x     
           bcc  LD67D          ; branch if greater or equal
           addd 0x02,x     
           clc                 ; clear carry
           bra  LD67E          ; branch

   LD67D:  sec                 ; set carry
   LD67E:  rol  0x01,x     
           rol  0x00,x     
           lsr  0x02,x     
           ror  0x03,x     
           dec  0x04,x     
           bne  LD674          ; branch if not equal (not zero)
           ldd  0x00,x     
   LD68C:  rts                 ; return from subroutine

HandleO2Processing_MM:
           ldaa BitFlags_81    ; load a with memory contents
           ldab WOTDLT_DeltaThrottleFrom_MINTHR_ToDetermineFullThrottle    ; load b with memory contents (data is 85)
           addb MINTHR_LowestSessionTPS    ; b=b+memory contents
           bcs  LD69A          ; branch if lower
           cmpb #0xd0          ;  -11010000-
           bcs  LD69C          ; branch if lower
   LD69A:  ldab #0xd0          ; load b with value -11010000-
   LD69C:  lsra            
           bcc  LD6A2          ; branch if greater or equal
           subb TPDLTF_TPSDeltaOverWOTDLTToDetermineWOT    ; subtract memory contents from b (data is 02)
   LD6A2:  cmpb TpsVolts   
           bcc  LD6A9          ; branch if greater or equal
           rola            
           bra  LD6F0          ; branch

   LD6A9:  lsla                ; logical shift left a
           staa BitFlags_81    ; store a into memory
           ldab MapValue       ; load b with memory contents
           cmpb MAPDEC_NoCellUpdateAndO2CNTRHeldBelowThisMap    ; compare b with memory contents (data is aa)
           bcc  LD6F2          ; branch if greater or equal
           ldab Timer_OpenLoopFraction    ; load b with memory contents
           cmpb LMTOLF2_LimitTimerOpenLoopFraction2    ; compare b with memory contents (data is 2b)
           bcc  LD6F2          ; branch if greater or equal
           bita #0x10          ;  -00010000-
           bne  LD6F6          ; branch if not equal (not zero)
           ldaa CoolantTemp    ; load a with memory contents
           cmpa CLTEMP_TempToStartCLTIMETimer    ; compare a with memory contents (data is 9b)
           bcs  LD6F2          ; branch if lower
           ldaa Timer_CLTIME_ClosedLoopTimer    ; load a with memory contents
           cmpa O2TIME_DelayTimeToClosedLoop    ; compare a with memory contents (data is 15)
           bcc  CheckIfO2SensorDataIsValid    ; branch if greater or equal
           ldab BitFlags_82    ; load b with memory contents
           bmi  LD6F2          ; branch if minus(hi bit 1)
           ldab Counter_MainLoop1    ; load b with memory contents
           bitb #0x1f          ;  -00011111-
           bne  LD6F2          ; branch if not equal (not zero)
           inca                ; increment a
           staa Timer_CLTIME_ClosedLoopTimer    ; store a into memory
           bra  LD6F2          ; branch

CheckIfO2SensorDataIsValid:
           ldaa O2SensorVolts    ; load a with memory contents
           cmpa O2TLMH_HighLimitForDelayedSwitchToClosedLoop    ; compare a with memory contents (data is 1f)
           bcc  LD6E7          ; branch if greater or equal
           cmpa O2TLML_LowLimitForDelayedSwitchToClosedLoop    ; compare a with memory contents (data is 0f)
           bcc  LD6F2          ; branch if greater or equal
   LD6E7:  clra                ; a = 0
           staa Counter_AdaptiveMem_Erase    ; store a into memory
           staa Timer_CLTIME_ClosedLoopTimer    ; store a into memory
           ldaa BitFlags_81    ; load a with memory contents
           oraa #0x10          ;  -00010000-
   LD6F0:  staa BitFlags_81    ; store a into memory
   LD6F2:  clra                ; a = 0
           staa Counter_PrimaryAndSecondaryRamp    ; store a into memory
           rts                 ; return from subroutine

   LD6F6:  clrb                ; b = 0
           ldaa O2SensorVolts    ; load a with memory contents
           cmpa O2MIDH_HighLimitForInMiddleDetermination    ; compare a with memory contents (data is 1c)
           bcc  LD70D          ; branch if greater or equal
           cmpa O2MIDL_LowLimitForInMiddleDetermination    ; compare a with memory contents (data is 12)
           bcs  LD70D          ; branch if lower
           ldab Timer_CLTIME_ClosedLoopTimer    ; load b with memory contents
           cmpb #0x7f          ;  -01111111-
           bls  LD70C          ; branch if lower or same
           jmp  Save_CLTIME_ToOtherTimers_O2InMiddle

   LD70C:  incb            
   LD70D:  stab Timer_CLTIME_ClosedLoopTimer    ; store b into memory
           clrb                ; b = 0
           cmpa O2HSWP_HighLimitForO2RampSwitching    ; compare a with memory contents (data is 19)
           bcc  O2Signal_AboveToggle    ; branch if greater or equal
           cmpa O2LSWP_LowLimitForO2RampSwitching    ; compare a with memory contents (data is 18)
           bcs  O2Signal_BelowToggle    ; branch if lower
           rts                 ; return from subroutine

O2Signal_AboveToggle:
           decb            
O2Signal_BelowToggle:
           ldaa BitFlags_84    ; load a with memory contents
           bita #0x10          ;  -00010000-
           bne  EraseAdaptiveMemory_possiblySetErrorBit    ; branch if not equal (not zero)
           clra                ; a = 0
           eorb BitFlags_81
           andb #0x04          ;  -00000100-
           beq  LD73E          ; branch if equal (zero)
           eorb BitFlags_81
           stab BitFlags_81    ; store b into memory
           clrb                ; b = 0
           ldaa Timer_OutOfClosedLoopMode    ; load a with memory contents
           stab Timer_OutOfClosedLoopMode    ; store b into memory
           stab Timer_O2ToggleDuration    ; store b into memory
           ldab #0x3f          ; load b with value -00111111-
           sei                 ; disable interrupts
           andb Cylinder3Retard
           stab Cylinder3Retard    ; store b into memory
           cli                 ; enable interrupts
           bra  LD742          ; branch

   LD73E:  ldab Timer_OutOfClosedLoopMode    ; load b with memory contents
           beq  EraseAdaptiveMemory_possiblySetErrorBit    ; branch if equal (zero)
   LD742:  staa Temp0          ; store a into memory
           ldx  #PRIRMP_PrimaryRamp    ; load index with value
           jsr  DetermineRampCellFromRPMandMAP    
           ldab Timer_OutOfClosedLoopMode    ; load b with memory contents
           addb 0x00,x         ; add memory at index + value to b
           sba                 ; subtract (a=a-b)
           bcc  LD75B          ; branch if greater or equal
           adda 0x00,x     
           bpl  LD756          ; branch if plus (hi bit 0)
           clra                ; a = 0
   LD756:  clrb                ; b = 0
           stab Timer_OutOfClosedLoopMode    ; store b into memory
           bra  LD762          ; branch

   LD75B:  ldaa 0x00,x         ; load a with memory at index + value
           tab                 ; b = a
           addb Timer_OutOfClosedLoopMode    ; b=b+memory contents
           stab Timer_OutOfClosedLoopMode    ; store b into memory
   LD762:  ldab Temp0          ; load b with memory contents
           beq  LD76A          ; branch if equal (zero)
           cba             
           bcs  LD76A          ; branch if lower
           tba                 ; a = b
   LD76A:  ldab BitFlags_81    ; load b with memory contents
           bitb #0x04          ;  -00000100-
           beq  LD771          ; branch if equal (zero)
           nega                ; negate a (set high bit)
   LD771:  bsr  IncrementO2SensorFeedbackCount    
           clra                ; a = 0
           staa Counter_AdaptiveMem_Erase    ; store a into memory
IncrementAdaptiveMemEraseCount:
           ldaa Counter_MainLoop1    ; load a with memory contents
           bne  LD77D          ; branch if not equal (not zero)
           inc  Counter_AdaptiveMem_Erase
   LD77D:  rts                 ; return from subroutine

EraseAdaptiveMemory_possiblySetErrorBit:
           ldaa Counter_AdaptiveMem_Erase    ; load a with memory contents
           cmpa LTHTIM_IfNoO2SwitchForThisTimeThrowFault51or52    ; compare a with memory contents (data is fe)
           bcs  IncrementAdaptiveMemEraseCount    ; branch if lower
           ldaa Cylinder3Retard    ; load a with memory contents
           anda #0xc0          ; AND a with value -11000000-
           cmpa #0xc0          ; compare a with value -11000000-
           bne  LD796          ; branch if not equal (not zero)
           ldaa #0x20          ; load a with value -00100000-
           sei                 ; disable interrupts
           oraa BitFlags_80    ; OR a with memory contents
           staa BitFlags_80    ; store a into memory
           bra  LD79D          ; branch

   LD796:  ldaa #0x40          ; load a with value -01000000-
           sei                 ; disable interrupts
           adda Cylinder3Retard
           staa Cylinder3Retard    ; store a into memory
   LD79D:  cli                 ; enable interrupts
           ldx  #ErrorBitRegister0    ; load index with value
           ldab #0x08          ; load b with value -00001000-
           ldaa BitFlags_81    ; load a with memory contents
           bita #0x04          ;  -00000100-
           beq  LD7AA          ; branch if equal (zero)
           lsrb                ; logical shift right b
   LD7AA:  jsr  ThrowNonCriticalError    
           ldx  #AutoCalCell0    ; load index with value
EraseAdaptiveMemoryLocations:
           staa 0x00,x     
           inx                 ; increment index (x=x+1)
           cpx  #ChargeTempVolts    ;  -00000000 01011101-
           bne  EraseAdaptiveMemoryLocations    ; branch if not equal (not zero)
Save_CLTIME_ToOtherTimers_O2InMiddle:
           clra                ; a = 0
           staa Counter_AdaptiveMem_Erase    ; store a into memory
           staa AdaptiveCellUpdateTimer_IncrementedEveryDistRisingEdge    ; store a into memory
           staa Timer_CLTIME_ClosedLoopTimer    ; store a into memory
           ldab BitFlags_81    ; load b with memory contents
           andb #0xef          ;  -11101111-
           stab BitFlags_81    ; store b into memory
           rts                 ; return from subroutine

        .msg "..." ; these are just messages to display during assemble to let you know what's going on...

ModifyO2FeedbackCountVarToMaintainStoich_MM:
           ldaa BitFlags_84    ; load a with memory contents
           bita #0x10          ;  -00010000-
           beq  WorkWithSecondaryRamp    ; branch if equal (zero)
   LD7CC:  clra                ; a = 0
           staa Timer_O2ToggleDuration    ; store a into memory
           rts                 ; return from subroutine

WorkWithSecondaryRamp:
           ldab BitFlags_81    ; load b with memory contents
           bitb #0x10          ;  -00010000-
           beq  LD7CC          ; branch if equal (zero)
           ldx  #SECRMP_SecondaryRamp    ; load index with value
           bsr  DetermineRampCellFromRPMandMAP    
           sei                 ; disable interrupts
           ldaa Timer_O2ToggleDuration    ; load a with memory contents
           sba                 ; subtract (a=a-b)
           bcs  DontUpdateO2FeedbackCount    ; branch if lower
           staa Timer_O2ToggleDuration    ; store a into memory
           cli                 ; enable interrupts
           ldaa 0x00,x         ; load a with memory at index + value
IncrementO2SensorFeedbackCount:
           ldab O2LIMH_O2RangeLimitHigh    ; load b with memory contents (data is 7f)
           adda Counter_PrimaryAndSecondaryRamp
           bvc  DIDNT_2SCOMPLEMENT_OVERFLOW_UNDERFLOW1    ; branch if overflow
           ldaa Counter_PrimaryAndSecondaryRamp    ; load a with memory contents
           bpl  SET_TO_MAX_OR_MIN_VALUE    ; branch if plus (hi bit 0)
           ldab O2LIML_O2RangeLimitLow    ; load b with memory contents (data is b3)
           tba                 ; a = b
DIDNT_2SCOMPLEMENT_OVERFLOW_UNDERFLOW1:
           cba             
           bge  SET_TO_MAX_OR_MIN_VALUE    ; branch if greater or equal
           ldab O2LIML_O2RangeLimitLow    ; load b with memory contents (data is b3)
           cba             
           bge  LD7FF          ; branch if greater or equal
SET_TO_MAX_OR_MIN_VALUE:
           tba                 ; a = b
   LD7FF:  ldab BitFlags_80    ; load b with memory contents
           bitb #0x20          ;  -00100000-
           beq  UpdateO2FeedbackCount    ; branch if equal (zero)
           tsta                ; test a
           bmi  DontUpdateO2FeedbackCount    ; branch if minus(hi bit 1)
UpdateO2FeedbackCount:
           staa Counter_PrimaryAndSecondaryRamp    ; store a into memory
DontUpdateO2FeedbackCount:
           cli                 ; enable interrupts
           rts                 ; return from subroutine

DetermineRampCellFromRPMandMAP:
           ldaa BitFlags_84    ; load a with memory contents
           bita #0x40          ;  -01000000-
           bne  FindCruiseCell ; branch if not equal (not zero)
           ldaa BitFlags_81    ; load a with memory contents
           bmi  FindCruiseCell ; branch if minus(hi bit 1)
           ldab #0x16          ; load b with value -00010110-
           bra  DecideRichOrLeanValue  ; branch

FindCruiseCell:
           clrb                ; b = 0
           ldaa EngineRpm_HB   ; load a with memory contents
FindRPMCell:
           cmpa 0x00,x         ; compare a with memory at index + value
           bcs  CheckRPMCell   ; branch if lower
           incb            
           inx                 ; increment index (x=x+1)
           cmpb #0x02          ;  -00000010-
           bcs  FindRPMCell    ; branch if lower
           bra  LD82E          ; branch

CheckRPMCell:
           tstb
           bne  LD82D          ; branch if not equal (not zero)
           inx                 ; increment index (x=x+1)
   LD82D:  inx                 ; increment index (x=x+1)
   LD82E:  ldaa MapValue       ; load a with memory contents
FindMAPCell:
           cmpa 0x00,x         ; compare a with memory at index + value
           bcs  LD83D          ; branch if lower
           addb #0x03          ;  -00000011-
           inx                 ; increment index (x=x+1)
           cmpb #0x06          ;  -00000110-
           bcs  FindMAPCell    ; branch if lower
           bra  LD843          ; branch

   LD83D:  cmpb #0x03          ;  -00000011-
           bcc  LD842          ; branch if greater or equal
           inx                 ; increment index (x=x+1)
   LD842:  inx                 ; increment index (x=x+1)
   LD843:  lslb            
           ldaa BitFlags_81    ; load a with memory contents
DecideRichOrLeanValue:
           bita #0x04          ;  -00000100-
           beq  LoadCellValue          ; branch if equal (zero)
           incb            
LoadCellValue:
           abx                 ; add b to index
           ldaa 0x14,x         ; load a with memory at index + value
           tab                 ; b = a
           rts                 ; return from subroutine

AdaptiveMemory_DetermineWhichCellApplies_MM:
           clra                ; a = 0
           staa Temp0          ; store a into memory
           ldab PointerIntoAdaptiveMemory    ; load b with memory contents
           ldaa BitFlags_81    ; load a with memory contents
           bmi  LD86D          ; branch if minus(hi bit 1)
           ldaa TargetIdleSpeed_HB    ; load a with memory contents
           adda HYTRPM_HysteresisFor_IDLOFS    ;  (data is 02)
           cmpb #0x0c          ;  -00001100-
           bne  LD865          ; branch if not equal (not zero)
           adda IDLOFS_DeltaForIdleRPMForClosedThrottleCell    ;  (data is 01)
   LD865:  cmpa EngineRpm_HB    ; compare a with memory contents
           bcs  LD86D          ; branch if lower
           ldab #0x0c          ; load b with value -00001100-
           bra  LD899          ; branch

   LD86D:  ldx  #MP1_AutocalMapCellBoundary1    ; load index with value
   LD870:  ldaa 0x00,x         ; load a with memory at index + value
           cmpb Temp0      
           bcc  LD879          ; branch if greater or equal
           adda DLTMAP_MapHysteresisAtMapCellBoundaries    ;  (data is 01)
   LD879:  cmpa MapValue       ; compare a with memory contents
           bcc  LD889          ; branch if greater or equal
           inx                 ; increment index (x=x+1)
           inc  Temp0      
           inc  Temp0      
           cpx  #DLTMAP_MapHysteresisAtMapCellBoundaries    ;  -11000001 10011100-
           bne  LD870          ; branch if not equal (not zero)
   LD889:  ldaa R1_RPMCellBoundaryInRPMover32    ; load a with memory contents (data is 1d)
           lsrb                ; logical shift right b
           bcs  LD892          ; branch if lower
           adda DLTRPM_DeltaRPMAtRPMBoundariesInRPMOver32    ;  (data is 01)
   LD892:  ldab Temp0          ; load b with memory contents
           cmpa EngineRpm_HB    ; compare a with memory contents
           bcc  LD899          ; branch if greater or equal
           incb            
   LD899:  cmpb PointerIntoAdaptiveMemory
           beq  LD8A2          ; branch if equal (zero)
           clra                ; a = 0
           staa AdaptiveCellUpdateTimer_IncrementedEveryDistRisingEdge    ; store a into memory
           stab PointerIntoAdaptiveMemory    ; store b into memory
   LD8A2:  rts                 ; return from subroutine

HandleAmTimer_MM:
           ldaa CoolantTemp    ; load a with memory contents
           ldab BitFlags_82    ; load b with memory contents
           bpl  LD8B7          ; branch if plus (hi bit 0)
           ldab AMTML_SelectedAMTimerInitLow    ; load b with memory contents (data is 40)
           cmpa AMTMH_SelectedAMTimerInitHi    ; compare a with memory contents (data is cd)
           bcc  LD8B4          ; branch if greater or equal
           ldab AMTPSW_TempPointToEnableSelectedAMTimer    ; load b with memory contents (data is 0c)
   LD8B4:  stab Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop    ; store b into memory
           rts                 ; return from subroutine

   LD8B7:  cmpa AMTEMP_StartTempToSelectHotOrColdAMTimer    ; compare a with memory contents (data is cd)
           bcs  LD8C7          ; branch if lower
           ldab Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop    ; load b with memory contents
           beq  UpdateAdaptive_OffIdle    ; branch if equal (zero)
           ldaa Counter_MainLoop1    ; load a with memory contents
           bne  LD8C7          ; branch if not equal (not zero)
           decb            
           stab Timer_O2CNTR_CountdownFromAbove196FtoEnableClosedLoop    ; store b into memory
   LD8C7:  rts                 ; return from subroutine

UpdateAdaptive_OffIdle:
           ldd  InjectorPulsewidth_HB    ; load d (a&b) with memory contents
           addd Pulsewidth_PartThrottleEnrichment_HB    ; d = d + memory contents
           subd PWMIN_NoCellUpdateBelow_PWMIN_Pulsewidth    ;  (data is 04b0)
           bcs  LD93F          ; branch if lower
           ldaa Timer_OpenLoopFraction    ; load a with memory contents
           cmpa LMTOLF2_LimitTimerOpenLoopFraction2    ; compare a with memory contents (data is 2b)
           bcc  LD93F          ; branch if greater or equal
           ldaa BitFlags_81    ; load a with memory contents
           bita #0x10          ;  -00010000-
           beq  LD93F          ; branch if equal (zero)
           lsra            
           bcs  LD93F          ; branch if lower
           clrb                ; b = 0
           anda #0x02          ; AND a with value -00000010-
           beq  LD8E7          ; branch if equal (zero)
           decb            
   LD8E7:  ldaa CALTHR_O2ControllerDeadbandLimitForUpdatingCells    ; load a with memory contents (data is 09)
           stab Temp0          ; store b into memory
           bmi  LD8EF          ; branch if minus(hi bit 1)
           nega                ; negate a (set high bit)
   LD8EF:  adda Counter_PrimaryAndSecondaryRamp
           bvs  LD8F7          ; branch if no overflow
           eora Temp0      
           bmi  LD93F          ; branch if minus(hi bit 1)
   LD8F7:  ldab Timer_Leanout    ; load b with memory contents
           bne  LD93F          ; branch if not equal (not zero)
           ldab MapValue       ; load b with memory contents
           cmpb MAPLIM_NoCellUpdateAboveThisMAP    ; compare b with memory contents (data is 8a)
           bhi  LD93F          ; branch if higher
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb RPMLIM_NoCellUpdateAboveThisRPMInRPMOver32    ; compare b with memory contents (data is 2b)
           bhi  LD93F          ; branch if higher
           ldab AdaptiveCellUpdateTimer_IncrementedEveryDistRisingEdge    ; load b with memory contents
           cmpb AMUPDT_EPPsBetweenCalChangeUpdateOpenThrottle    ; compare b with memory contents (data is 1a)
           bcs  LD93F          ; branch if lower
           ldab Counter_PrimaryAndSecondaryRamp    ; load b with memory contents
           beq  LD93F          ; branch if equal (zero)
           clra                ; a = 0
           staa AdaptiveCellUpdateTimer_IncrementedEveryDistRisingEdge    ; store a into memory
           ldaa CELCHG_BitsChangePerUpdateWithinACell    ; load a with memory contents (data is 01)
           tstb            
           bpl  AdaptiveMemory_UpdateCellIfRequired    ; branch if plus (hi bit 0)
           nega                ; negate a (set high bit)
AdaptiveMemory_UpdateCellIfRequired:
           ldx  #AutoCalCell0    ; load index with value
           ldab PointerIntoAdaptiveMemory    ; load b with memory contents
           abx                 ; add b to index
           ldab AMLIMH_MaxMultiplierCannotBeAbove7F    ; load b with memory contents (data is 7f)
           adda 0x00,x     
           bvc  Adaptive_Overflowed    ; branch if overflow
           ldaa 0x00,x         ; load a with memory at index + value
           bpl  Adaptive_SetCellToMaxOrMinValue    ; branch if plus (hi bit 0)
           ldab AMLIML_MinMultiplierCannotBeBelow80    ; load b with memory contents (data is b3)
           tba                 ; a = b
Adaptive_Overflowed:
           cba             
           bge  Adaptive_SetCellToMaxOrMinValue    ; branch if greater or equal
           ldab AMLIML_MinMultiplierCannotBeBelow80    ; load b with memory contents (data is b3)
           cba             
           bge  LD93D          ; branch if greater or equal
Adaptive_SetCellToMaxOrMinValue:
           tba                 ; a = b
   LD93D:  staa 0x00,x     
   LD93F:  rts                 ; return from subroutine

SetTPSFlags_MM:
           clra                ; a = 0
           ldx  EngineRpm_HB
           cpx  TargetIdleSpeed_HB
           bls  LD94C          ; branch if lower or same
           ldaa Timer_CountdownFromStartRunForAisFeedback    ; load a with memory contents
           beq  LD94E          ; branch if equal (zero)
           deca                ; decrement a
   LD94C:  staa Timer_CountdownFromStartRunForAisFeedback    ; store a into memory
   LD94E:  ldaa BitFlags_81    ; load a with memory contents
           bmi  LD96A          ; branch if minus(hi bit 1)
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           staa Temp0          ; store a into memory
           ldaa MPHREF_SwitchPointForDecelIdleAisControl    ; load a with memory contents (data is 06)
           ldab BitFlags_84    ; load b with memory contents
           bitb #0x40          ;  -01000000-
           bne  LD964          ; branch if not equal (not zero)
           adda #0x03          ;  -00000011-
   LD964:  orab #0x40          ;  -01000000-
           cmpa Temp0          ; compare a with memory contents
           bcs  LD96E          ; branch if lower
   LD96A:  ldab BitFlags_84    ; load b with memory contents
           andb #0xbf          ;  -10111111-
   LD96E:  stab BitFlags_84    ; store b into memory
           rts                 ; return from subroutine

CalculateAisPosition_MM:
           ldaa BitFlags_82    ; load a with memory contents
           oraa BitFlags_4f    ; OR a with memory contents
           oraa BitFlags_81    ; OR a with memory contents
           bmi  LD97F          ; branch if minus(hi bit 1)
           ldab TimerOverflowsBetweenDistPulses    ; load b with memory contents
           orab Timer_CountdownFromStartRunForAisFeedback
           beq  LD980          ; branch if equal (zero)
   LD97F:  rts                 ; return from subroutine

   LD980:  ldaa BitFlags_80    ; load a with memory contents
           bpl  LD988          ; branch if plus (hi bit 0)
           clra                ; a = 0
           jmp  LDA87      

   LD988:  ldaa Timer_DacalCountdown    ; load a with memory contents
           lsra            
           lsra            
           adda DANOM_Base_nominalCal    ;  (data is 10)
           bcs  LD9C1          ; branch if lower
           ldab BitFlags_84    ; load b with memory contents
           bitb #0x40          ;  -01000000-
           beq  LD9C3          ; branch if equal (zero)
           staa Temp1          ; store a into memory
           ldx  #TIMEDC_AISDecelBaseAirflowCurveOffset    ; load index with value
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           jsr  Lookup4ByteTable    
           ldaa Temp1          ; load a with memory contents
           aba                 ; a=a+b
           bcs  LD9C1          ; branch if lower
           staa Temp1          ; store a into memory
           ldx  #TEMPDC_AISDecel_FromTemp    ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    
           ldab Temp1          ; load b with memory contents
           aba                 ; a=a+b
           bcs  LD9C1          ; branch if lower
           ldab Z83_PortCdata    ; load b with memory contents
           bitb #0x04          ;  -00000100-
           bne  LD9C3          ; branch if not equal (not zero)
           adda DAACF_ACFactorDeltaFromBase    ;  (data is 09)
           bcc  LD9C3          ; branch if greater or equal
   LD9C1:  ldaa #0xff          ; load a with value -11111111-
   LD9C3:  ldab DistributorFallingEdgePulsewidth_HB    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           asld                ; shift left (d=d*2)
           bcs  LD9FD          ; branch if lower
           staa Temp0          ; store a into memory
           ldx  #MAPFLR_AISAdditionToControlMap_FromRpm    ; load index with value
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    
           staa Temp1          ; store a into memory
           ldx  #MPTEMP_TempTermForMapOffset_FromTemp    ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    
           ldab Temp1          ; load b with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           staa Temp1          ; store a into memory
           ldx  #BARFLR_OffsetCorrectionTo_MAPFLR_FromBaro    ; load index with value
           ldaa BaroPressure    ; load a with memory contents
           jsr  Lookup4ByteTable    
           ldab Temp1          ; load b with memory contents
           mul                 ; multiply (d=a*b)
           asld                ; shift left (d=d*2)
           bcs  LD9FD          ; branch if lower
           tstb            
           bpl  LD9F9          ; branch if plus (hi bit 0)
           inca                ; increment a
           beq  LD9FD          ; branch if equal (zero)
   LD9F9:  adda Temp0      
           bcc  LD9FF          ; branch if greater or equal
   LD9FD:  ldaa #0xff          ; load a with value -11111111-
   LD9FF:  ldab BitFlags_84    ; load b with memory contents
           bitb #0x40          ;  -01000000-
           bne  LDA75          ; branch if not equal (not zero)

;### changed this code to look at the config flags instead of the whole byte

           ldab CONFIG_ConfigurationFlags
           bpl  LDA11 ;branch if bit 7 is NOT set, IE manual trans

;          ldab Manual00_AutomaticFF    ; load b with memory contents (data is 00)
;          beq  LDA11          ; branch if equal (zero)

           ldab Z83_PortCdata    ; load b with memory contents
           bitb #0x08          ;  -00001000-
           beq  LDA74          ; branch if equal (zero)
   LDA11:  ldab KeyOnOrEngineRunningTime    ; load b with memory contents
           cmpb DCALTM_DacalInhibitTimeAfterStartup    ; compare b with memory contents (data is 15)
           bcs  LDA74          ; branch if lower
           ldab Z83_PortCdata    ; load b with memory contents
           andb #0x04          ;  -00000100-
           beq  LDA74          ; branch if equal (zero)
           ldab CoolantTemp    ; load b with memory contents
           cmpb DATHOT_EngineTempToStartCalibratingDacal    ; compare b with memory contents (data is cd)
           bls  LDA74          ; branch if lower or same
           ldab Counter_MainLoop1    ; load b with memory contents
           bitb DCALRT_DacalUpdateRate01_03_07_0f_1f_3f_7f_ff    ;  (data is 7e)
           bne  LDA48          ; branch if not equal (not zero)
           ldab TargetIdleSpeed_HB    ; load b with memory contents
           subb EngineRpm_HB    ; b = b-memory contents
           bcc  LDA34          ; branch if greater or equal
           negb            
   LDA34:  cmpb DADRPM_DeltaRpmFromIdleSpeedForDacalUpdate    ; compare b with memory contents (data is 02)
           bhi  LDA48          ; branch if higher
           ldab Timer_DacalCountdown    ; load b with memory contents
           cmpa MapValue       ; compare a with memory contents
           bhi  LDA42          ; branch if higher
           incb            
           bne  LDA46          ; branch if not equal (not zero)
   LDA42:  tstb            
           beq  LDA48          ; branch if equal (zero)
           decb            
   LDA46:  stab Timer_DacalCountdown    ; store b into memory
   LDA48:  ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeed_HB    ; d = d - memory contents
           bcc  LDA53          ; branch if greater or equal
           coma            
           comb            
           addd #CPU_Port2_DataDirection    ;  -00000000 00000001-
   LDA53:  asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           bcs  LDA74          ; branch if lower
           asld                ; shift left (d=d*2)
           bcs  LDA74          ; branch if lower
           cmpa #0x0a          ; compare a with value -00001010-
           bcc  LDA74          ; branch if greater or equal
           ldaa CurrentAisPosition    ; load a with memory contents
           cmpa DesiredNewAisPosition    ; compare a with memory contents
           bne  LDA74          ; branch if not equal (not zero)
           ldaa DesiredNewAisPosition    ; load a with memory contents
           cmpa CALPOS_PositionAisMotorIsAtIdle    ; compare a with memory contents (data is 1a)
           beq  LDA74          ; branch if equal (zero)
           bhi  LDA6F          ; branch if higher
           inca                ; increment a
           inca                ; increment a
   LDA6F:  deca                ; decrement a
           staa DesiredNewAisPosition    ; store a into memory
           staa CurrentAisPosition    ; store a into memory
   LDA74:  rts                 ; return from subroutine

   LDA75:  ldab CoolantTemp    ; load b with memory contents
           cmpb DATHT2_EngineTempToStartCalibratingDacal2    ; compare b with memory contents (data is cd)
           bcs  LDA87          ; branch if lower
           ldab EngineRpm_HB    ; load b with memory contents
           subb TargetIdleSpeed_HB    ; b = b-memory contents
           bcs  LDA87          ; branch if lower
           cmpb DDRPM2_AisDeltaRpmFromIdle2    ; compare b with memory contents (data is 00)
           bcs  LDAB4          ; branch if lower
   LDA87:  ldab Timer_AisChanges    ; load b with memory contents
           cmpb DCLRFQ_TimeBetweenAisPulsesForDecelAis    ; compare b with memory contents (data is 3f)
           bcs  LDAB4          ; branch if lower
           ldab BitFlags_AIS    ; load b with memory contents
           andb #0xf7          ;  -11110111-
           stab BitFlags_AIS    ; store b into memory
           cmpa DCLMIN_MinLimitOnDecelAisControlledMap    ; compare a with memory contents (data is 14)
           bcc  LDA9C          ; branch if greater or equal
           ldaa DCLMIN_MinLimitOnDecelAisControlledMap    ; load a with memory contents (data is 14)
   LDA9C:  ldx  #DAISOP_DecelAisOpenStepsFromNeg_FromDeltaMap    ; load index with value
           suba MapValue   
           bcc  LDAA7          ; branch if greater or equal
           nega                ; negate a (set high bit)
           ldx  #DAISCL_DecelAisOpenStepsFromPos_FromDeltaMap    ; load index with value
   LDAA7:  jsr  Lookup4ByteTable    
           jsr  StoreAndLimitDesiredAisPosition    
           cmpa CurrentAisPosition    ; compare a with memory contents
           beq  LDAB4          ; branch if equal (zero)
           clra                ; a = 0
           staa Timer_AisChanges    ; store a into memory
   LDAB4:  rts                 ; return from subroutine

SetAISFlags_MM:
           ldab #0x80          ; load b with value -10000000-
           ldaa DesiredNewAisPosition    ; load a with memory contents
           suba CurrentAisPosition
           bcc  LDABF          ; branch if greater or equal
           clrb                ; b = 0
           nega                ; negate a (set high bit)
   LDABF:  eorb BitFlags_AIS
           lslb            
           ldab BitFlags_AIS    ; load b with memory contents
           bcc  LDACA          ; branch if greater or equal
           eorb #0x80          ;  -10000000-
           bra  LDAD5          ; branch

   LDACA:  cmpa #0x04          ; compare a with value -00000100-
           bcs  LDAD5          ; branch if lower
           bitb #0x03          ;  -00000011-
           beq  LDADB          ; branch if equal (zero)
           decb            
           bra  LDAD7          ; branch

   LDAD5:  orab #0x03          ;  -00000011-
   LDAD7:  andb #0xdf          ;  -11011111-
           bra  LDADD          ; branch

   LDADB:  orab #0x20          ;  -00100000-
   LDADD:  stab BitFlags_AIS    ; store b into memory
           rts                 ; return from subroutine

KickUpAisBy2DuringDecel_MM:
           ldaa BitFlags_84    ; load a with memory contents
           bita #0x40          ;  -01000000-
           bne  LDB15          ; branch if not equal (not zero)
           ldaa BitFlags_80    ; load a with memory contents
           bmi  LDB15          ; branch if minus(hi bit 1)
           ldaa DesiredNewAisPosition    ; load a with memory contents
           oraa CurrentAisPosition    ; OR a with memory contents
           bne  LDB15          ; branch if not equal (not zero)
           ldab Counter_MainLoop1    ; load b with memory contents
           bitb #0x7e          ;  -01111110-
           bne  LDB15          ; branch if not equal (not zero)
           adda #0x02          ;  -00000010-
           staa DesiredNewAisPosition    ; store a into memory
           staa CurrentAisPosition    ; store a into memory
           ldaa BitFlags_AIS    ; load a with memory contents
           bita #0x10          ;  -00010000-
           bne  LDB15          ; branch if not equal (not zero)
           ldaa #0x10          ; load a with value -00010000-
           oraa BitFlags_85    ; OR a with memory contents
           staa BitFlags_85    ; store a into memory
           ldaa #0x3f          ; load a with value -00111111-
           jsr  ThrowCriticalError    
           bcc  LDB15          ; branch if greater or equal
           ldaa BitFlags_AIS    ; load a with memory contents
           oraa #0x10          ;  -00010000-
           staa BitFlags_AIS    ; store a into memory
   LDB15:  rts                 ; return from subroutine

DetermineFuelTweaks_MM:
           ldaa BaroPressure    ; load a with memory contents
           ldx  #PWADD_FuelPWModifierFromBaro    ; load index with value
           jsr  Lookup4ByteTable    
           ldaa DistributorFallingEdgePulsewidth_HB    ; load a with memory contents
           tst  TimerOverflowsBetweenDistPulses
           beq  LDB27          ; branch if equal (zero)
           ldaa #0xff          ; load a with value -11111111-
   LDB27:  mul                 ; multiply (d=a*b)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           std  Temp0          ; store D to RAM
           ldx  #FuelLeanoutFactorOnThrottle    ; load index with value
           ldaa BitFlags_81    ; load a with memory contents
           bmi  LDB39          ; branch if minus(hi bit 1)
           ldx  #FuelLeanoutFactorOffThrottle    ; load index with value
   LDB39:  ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    
           clra                ; a = 0
           tstb            
           bpl  LDB44          ; branch if plus (hi bit 0)
           deca                ; decrement a
   LDB44:  asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd Temp0          ; d = d + memory contents
           std  LeanoutFactor_HB    ; store D to RAM
           ldx  #BATOFF_FuelBatteryOffset    ; load index with value
           ldaa BatteryVolts    ; load a with memory contents
           jsr  Lookup4ByteTable    
           staa InjectorLatency    ; store a into memory

CalculateSelectiveBankEnrichment:
           ldx  #SBNRMP_BankScalingFromMAP    ; load index with value
           ldaa MapValue       ; load a with memory contents
           jsr  Lookup4ByteTable    ; call subroutine
           staa Temp0          ; store a into memory
           ldx  #SBNRRP_BankScalingFromRPM    ; load index with value
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    ; call subroutine
           ldab Temp0          ; load b with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           lsra            
           staa BankEnrichmentFactor    ; store a into memory

           ldab MapValue       ; load b with memory contents
           cmpb AverageMAPValue
           bcc  LDB69          ; branch if greater or equal
           ldab Counter_MainLoop1    ; load b with memory contents
           bitb #0x07          ;  -00000111-
           bne  LDB69          ; branch if not equal (not zero)
           ldx  #AverageMAPValue    ; load index with value
           sei                 ; disable interrupts
           jsr  ProcessMapOrTpsBlockData    
           cli                 ; enable interrupts
   LDB69:  ldd  InjectorPulsewidth_HB    ; load d (a&b) with memory contents
           addd Pulsewidth_PartThrottleEnrichment_HB    ; d = d + memory contents
           subd PWMIN_NoCellUpdateBelow_PWMIN_Pulsewidth    ;  (data is 04b0)
           ldaa BitFlags_84    ; load a with memory contents
           bcs  LDB7C          ; branch if lower
           bita #0x20          ;  -00100000-
           bne  LDB7C          ; branch if not equal (not zero)
           anda #0xef          ; AND a with value -11101111-
           bra  LDB7E          ; branch

   LDB7C:  oraa #0x10          ;  -00010000-
   LDB7E:  staa BitFlags_84    ; store a into memory
           rts                 ; return from subroutine

        .msg "..." ; these are just messages to display during assemble to let you know what's going on...

CalculateInjectorPulsewidthForStarting_MM:
           ldaa BitFlags_82    ; load a with memory contents
           bita #0x08          ;  -00001000-
           beq  LDB91          ; branch if equal (zero)
           ldx  #SFDCAY_FuelStartDecayIntoRun    ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    
           staa FuelSubtractedFromStartToRun    ; store a into memory
   LDB91:  ldaa BitFlags_82    ; load a with memory contents
           bpl  LDBF9          ; branch if plus (hi bit 0)
           ldaa BitFlags_81    ; load a with memory contents
           lsra            
           ldd  #0x0000    ; load d (a&b) with value -00000000 00000000-
           bcs  LDBE8          ; branch if lower
           jsr  AllowForHeatSoakAfterStall    
           ldx  #STRTFL_FuelStartFromCoolantTemp    ; load index with value
           ldab BitFlags_81    ; load b with memory contents
           bmi  LDBAF          ; branch if minus(hi bit 1)
           cmpa STRLMT_ColdestTempAllowedAtClosedThrottle    ; compare a with memory contents (data is 63)
           bcc  LDBAF          ; branch if greater or equal
           ldaa STRLMT_ColdestTempAllowedAtClosedThrottle    ; load a with memory contents (data is 63)
   LDBAF:  jsr  Lookup4ByteTable    
           mul                 ; multiply (d=a*b)
           std  Temp0          ; store D to RAM
           ldaa BaroPressure    ; load a with memory contents
           ldx  #STFBAR_FuelStartReductionFromBaro    ; load index with value
           jsr  Lookup4ByteTable    
           staa Temp4          ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #STFTMP_FuelStartFuelFromCoolant    ; load index with value
           jsr  Lookup4ByteTable    
           ldaa Temp4          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           beq  LDBD9          ; branch if equal (zero)
           tab                 ; b = a
           negb            
           clra                ; a = 0
           ldx  #Temp0         ; load index with value
           jsr  ScaleXbySignedB_ReturnD    
           std  Temp0          ; store D to RAM
   LDBD9:  ldaa Counter_FallingEdgeEPP_MaxFF    ; load a with memory contents
           ldx  #EPPMUL_FuelStartFuelPerEPP    ; load index with value
           jsr  Lookup4ByteTable    
           clra                ; a = 0
           ldx  #Temp0         ; load index with value
           jsr  ScaleXbySignedB_ReturnD    
   LDBE8:  std  Temp0          ; store D to RAM
           ldab InjectorLatency    ; load b with memory contents
           clra                ; a = 0
           asld                ; shift left (d=d*2)
           addd Temp0          ; d = d + memory contents
           cmpa #0xbf          ; compare a with value -10111111-
           bls  LDBF7          ; branch if lower or same
           ldd  #0xbfff        ; load d (a&b) with value -10111111 11111111-
   LDBF7:  std  InjectorPulsewidth_HB    ; store D to RAM
   LDBF9:  rts                 ; return from subroutine

CalculateSumOfAllFuelModifiers_MM:
           clra                ; a = 0
           staa Temp0          ; store a into memory
           ldab BitFlags_81    ; load b with memory contents
           lsrb                ; logical shift right b
           bcs  LDC3C          ; branch if lower
           ldab Timer_OpenLoopFraction    ; load b with memory contents
           cmpb LMTOLF2_LimitTimerOpenLoopFraction2    ; compare b with memory contents (data is 2b)
           bcc  LDC3C          ; branch if greater or equal
           jsr  AllowForHeatSoakAfterStall    
           staa Temp1          ; store a into memory
           ldab BitFlags_84    ; load b with memory contents
           bitb #0x02          ;  -00000010-
           bne  LDC21          ; branch if not equal (not zero)
           ldx  #CURVEC_FuelColdEnrichmentCurveC    ; load index with value
           jsr  Lookup4ByteTable    
           ldab Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           staa Temp0          ; store a into memory
   LDC21:  ldaa Temp1          ; load a with memory contents
           ldx  #CURVEA_FuelColdEnrichmentCurveA    ; load index with value
           jsr  Lookup4ByteTable    
           ldab BitFlags_84    ; load b with memory contents
           bitb #0x02          ;  -00000010-
           beq  LDC34          ; branch if equal (zero)
           ldab Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
   LDC34:  adda Temp0      
           bcc  LDC3A          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LDC3A:  staa Temp0          ; store a into memory
   LDC3C:  ldaa CoolantTemp    ; load a with memory contents
           ldx  #CURVEB_FuelColdEnrichmentCurveB    ; load index with value
           jsr  Lookup4ByteTable    
           clra                ; a = 0
           addb Temp0          ; b=b+memory contents
           rola            
           asld                ; shift left (d=d*2)
           std  Temp0          ; store D to RAM
           ldaa BitFlags_81    ; load a with memory contents
           lsra            
           bcs  LDC75          ; branch if lower
           ldaa Timer_OpenLoopFraction    ; load a with memory contents
           suba LMTOLF2_LimitTimerOpenLoopFraction2    ;  (data is 2b)
           bcc  LDC75          ; branch if greater or equal
           ldx  #HMPMUL_ColdLoadFromMAP    ; load index with value
           ldaa MapValue       ; load a with memory contents
           jsr  Lookup4ByteTable    
           staa Temp4          ; store a into memory
           ldx  #HIGHMP_ColdLoadFromCoolantTemp    ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    
           ldaa Temp4          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           addd Temp0          ; d = d + memory contents
           std  Temp0          ; store D to RAM
   LDC75:  ldaa BaroPressure    ; load a with memory contents
           ldx  #BAROCP_BaroCompensationOfWarmupFactor_FromBaro    ; load index with value
           jsr  Lookup4ByteTable    
           clra                ; a = 0
           ldx  #Temp0         ; load index with value
           jsr  ScaleXbySignedB_ReturnD    
           inca                ; increment a
           std  Temp0          ; store D to RAM
           deca                ; decrement a
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           stab BaseFuelModifier    ; store b into memory
           ldx  #AIRTMP_FuelEnrichmentFromChargeTemp    ; load index with value
           ldaa ChargeTempVolts    ; load a with memory contents
           jsr  Lookup4ByteTable    
           stab Temp4          ; store b into memory
           ldx  #PEFTBL_PumpingEfficiency    ; load index with value
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    
           ldx  #Temp0         ; load index with value
           clra                ; a = 0
           jsr  ScaleXbySignedB_ReturnD    
           std  Temp0          ; store D to RAM
           ldab Timer_Leanout    ; load b with memory contents
           beq  LDCB3          ; branch if equal (zero)
           clra                ; a = 0
           jsr  ScaleXbySignedB_ReturnD    
           std  Temp0          ; store D to RAM
   LDCB3:  ldab Temp4          ; load b with memory contents
           beq  LDCBE          ; branch if equal (zero)
           ldaa #0x01          ; load a with value -00000001-
           jsr  ScaleXbySignedB_ReturnD    
           std  Temp0          ; store D to RAM
   LDCBE:  ldab PointerIntoAdaptiveMemory    ; load b with memory contents
           ldx  #AutoCalCell0    ; load index with value
           abx                 ; add b to index
           ldab 0x00,x         ; load b with memory at index + value
           ldaa BitFlags_81    ; load a with memory contents
           lsra            
           bcs  LDCD2          ; branch if lower
           ldaa Timer_OpenLoopFraction    ; load a with memory contents
           cmpa LMTOLF2_LimitTimerOpenLoopFraction2    ; compare a with memory contents (data is 2b)
           bcs  LDCDA          ; branch if lower
   LDCD2:  cmpb ADMEMA_ValueFromAdaptivememoryAdder1    ; compare b with memory contents (data is 00)
           bgt  LDCDA          ; branch if greater
           ldab ADMEMA_ValueFromAdaptivememoryAdder1    ; load b with memory contents (data is 00)
   LDCDA:  clra                ; a = 0
           tstb            
           bmi  LDCDF          ; branch if minus(hi bit 1)
           inca                ; increment a
   LDCDF:  asrb            
           ldx  #Temp0         ; load index with value
           jsr  ScaleXbySignedB_ReturnD    
           std  Temp0          ; store D to RAM
           ldab BitFlags_81    ; load b with memory contents
           bmi  LDCFC          ; branch if minus(hi bit 1)
           ldab BitFlags_80    ; load b with memory contents
           bitb #0x02          ;  -00000010-
           beq  LDCFC          ; branch if equal (zero)
           clra                ; a = 0
           staa Counter_PrimaryAndSecondaryRamp    ; store a into memory
           ldab FMODDV1_StandardFuelModifierDivisor_1    ; load b with memory contents (data is 1a)
           ldaa #0x01          ; load a with value -00000001-
           bra  LDD16          ; branch

   LDCFC:  ldaa BitFlags_C9    ; load a with memory contents
           cmpa #0x70          ; compare a with value -01110000-
           bne  LDD0F          ; branch if not equal (not zero)
           ldaa BitFlags_84    ; load a with memory contents
           bita #0x04          ;  -00000100-
           beq  LDD0F          ; branch if equal (zero)
           ldab FMODDV2_StandardFuelModifierDivisor_2    ; load b with memory contents (data is 1a)
           ldaa #0x01          ; load a with value -00000001-
           bra  LDD16          ; branch

   LDD0F:  clra                ; a = 0
           ldab Counter_PrimaryAndSecondaryRamp    ; load b with memory contents
           bmi  LDD15          ; branch if minus(hi bit 1)
           inca                ; increment a
   LDD15:  asrb            
   LDD16:  jsr  ScaleXbySignedB_ReturnD    
           std  SumOfFuelModifiers_HB    ; store D to RAM
           rts                 ; return from subroutine

CalculateTransientFuelAddition_MM:
           ldaa BitFlags_82    ; load a with memory contents
           bita #0x08          ;  -00001000-
           bne  LDD8A          ; branch if not equal (not zero)
           clra                ; a = 0
           clrb                ; b = 0
           std  Temp0          ; store D to RAM
           ldaa BitFlags_81    ; load a with memory contents
           bmi  LDD32          ; branch if minus(hi bit 1)
           ldaa TpsVolts       ; load a with memory contents
           staa AverageTPSVolts    ; store a into memory
   LDD2E:  ldd  Temp0          ; load d (a&b) with memory contents
           bra  LDD7B          ; branch

   LDD32:  ldx  #POSTRG_PositiveTransientTriggerLevel    ; load index with value
           ldab TpsVolts       ; load b with memory contents
           subb AverageTPSVolts    ; b = b-memory contents
           bcs  LDD55          ; branch if lower
           subb 0x00,x     
           bcs  LDD59          ; branch if lower
           cmpb 0x01,x     
           bcs  LDD45          ; branch if lower
           ldab 0x01,x         ; load b with memory at index + value
   LDD45:  stab Temp4          ; store b into memory
           ldaa CoolantTemp    ; load a with memory contents
           inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
           jsr  Lookup4ByteTable    
           ldab Temp4          ; load b with memory contents
           mul                 ; multiply (d=a*b)
           std  Temp0          ; store D to RAM
           bra  LDD59          ; branch

   LDD55:  ldab TpsVolts       ; load b with memory contents
           stab AverageTPSVolts    ; store b into memory
   LDD59:  ldaa MapValue       ; load a with memory contents
           suba AverageMAPValue
           bls  LDD2E          ; branch if lower or same
           suba MAPTRG_DeltaMapTriggerLevel    ;  (data is 05)
           bcs  LDD2E          ; branch if lower
           cmpa MAPMAX_MaxDeltaMapAllowed    ; compare a with memory contents (data is ff)
           bcs  LDD6C          ; branch if lower
           ldaa MAPMAX_MaxDeltaMapAllowed    ; load a with memory contents (data is ff)
   LDD6C:  staa Temp4          ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #AESLOP_DeltaMAPEnrichment_FromTemp2    ; load index with value
           jsr  Lookup4ByteTable    
           ldaa Temp4          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           addd Temp0          ; d = d + memory contents
   LDD7B:  asld                ; shift left (d=d*2)
           bcs  LDD84          ; branch if lower
           asld                ; shift left (d=d*2)
           bcs  LDD84          ; branch if lower
           asld                ; shift left (d=d*2)
           bcc  LDD87          ; branch if greater or equal
   LDD84:  ldd  #0xffff        ; load d (a&b) with value -11111111 11111111-
   LDD87:  sei                 ; disable interrupts
           std  Pulsewidth_PartThrottleEnrichment_HB    ; store D to RAM
   LDD8A:  ldd  Pulsewidth_PartThrottleEnrichment_HB    ; load d (a&b) with memory contents
           cli                 ; enable interrupts
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           tsta                ; test a
           beq  LDD97          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   LDD97:  stab PTEPWOver32    ; store b into memory
           rts                 ; return from subroutine

HandleKnockRetard:
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa #0x47          ; compare a with value -01000111-
           bcs  LDDBB          ; branch if lower
           ldaa BitFlags_82    ; load a with memory contents
           bita #0x04          ;  -00000100-
           beq  LDDC1          ; branch if equal (zero)
           ldaa CPU_ICR_HB     ; load a with memory contents
           suba LastDistributorFallingEdgeTime_HB
           ldab #0x03          ; load b with value -00000011-
           mul                 ; multiply (d=a*b)
           ldaa BitFlags_82    ; load a with memory contents
           cmpb DistributorFallingEdgePulsewidth_HB
           bcc  LDDB7          ; branch if greater or equal
           oraa #0x40          ;  -01000000-
           bra  LDDEC          ; branch

   LDDB7:  anda #0xbf          ; AND a with value -10111111-
           bra  LDE2B          ; branch

   LDDBB:  ldaa BitFlags_82    ; load a with memory contents
           bita #0x04          ;  -00000100-
           bne  LDDDB          ; branch if not equal (not zero)
   LDDC1:  andb #0xfd          ;  -11111101-
           stab CPU_TimerControlStatReg    ; store b into memory
           ldab BitFlags_85    ; load b with memory contents
           bitb #0x02          ;  -00000010-
           beq  LDDDB          ; branch if equal (zero)
           oraa #0x04          ;  -00000100-
           staa BitFlags_82    ; store a into memory
           ldd  Cylinder2Retard    ; load d (a&b) with memory contents
           oraa #0xc0          ;  -11000000-
           orab #0x40          ;  -01000000-
           andb #0x7f          ;  -01111111-
           std  Cylinder2Retard    ; store D to RAM
           bra  LDE35          ; branch

   LDDDB:  ldab Temp6          ; load b with memory contents
           lsrb                ; logical shift right b
           staa Temp5          ; store a into memory
           anda #0xbf          ; AND a with value -10111111-
           aba                 ; a=a+b
           eorb Temp5      
           lslb            
           bpl  LDE1A          ; branch if plus (hi bit 0)
           ldab Temp6          ; load b with memory contents
           bpl  LDE2B          ; branch if plus (hi bit 0)
   LDDEC:  oraa #0x04          ;  -00000100-
           staa BitFlags_82    ; store a into memory
           ldd  Cylinder2Retard    ; load d (a&b) with memory contents
           anda #0x3f          ; AND a with value -00111111-
           andb #0x3f          ;  -00111111-
           orab #0x80          ;  -10000000-
           std  Cylinder2Retard    ; store D to RAM
           ldaa BitFlags_82    ; load a with memory contents
           lsra            
           bcs  LDE06          ; branch if lower
           ldab CPU_TimerControlStatReg    ; load b with memory contents
           orab #0x02          ;  -00000010-
           stab CPU_TimerControlStatReg    ; store b into memory
   LDE05:  rti                 ; return from interrupt

   LDE06:  lsla                ; logical shift left a
           staa BitFlags_82    ; store a into memory
           ldaa #0xe9          ; load a with value -11101001-
           staa CPU_TimerControl1    ; store a into memory
           ldd  CPU_Counter_HB    ; load d (a&b) with memory contents
           addd #CPU_PortX_ControlStatReg    ;  -00000000 00001111-
           stD CPU_OCR3_HB    ; store D to RAM
           lds  #0x00ff        ;  -00000000 11111111-
           jmp  LE94B      

   LDE1A:  ldab Cylinder2Retard    ; load b with memory contents
           bitb #0xc0          ;  -11000000-
           bne  LDE2B          ; branch if not equal (not zero)
           anda #0xfb          ; AND a with value -11111011-
           staa BitFlags_82    ; store a into memory
           ldaa BitFlags_7f    ; load a with memory contents
           oraa #0x08          ;  -00001000-
           staa BitFlags_7f    ; store a into memory
           rti                 ; return from interrupt

   LDE2B:  staa BitFlags_82    ; store a into memory
           ldd  Cylinder2Retard    ; load d (a&b) with memory contents
           adda #0x40          ;  -01000000-
           addb #0x40          ;  -01000000-
           std  Cylinder2Retard    ; store D to RAM
   LDE35:  ldaa BitFlags_82    ; load a with memory contents
           lsra            
           bcs  LDE06          ; branch if lower
           bita #0x02          ;  -00000010-
           beq  LDE05          ; branch if equal (zero)
           ldaa CPU_Port1_ControlRegister    ; load a with memory contents
           anda #0x7f          ; AND a with value -01111111-
           staa CPU_Port1_ControlRegister    ; store a into memory
           ldab Z85_ADConverter1    ; load b with memory contents (data is 00)
           ldab Z85_ADConverter1    ; load b with memory contents (data is 00)
           ldaa Z83_PortBdata    ; load a with memory contents
           oraa #0x20          ;  -00100000-
           staa Z83_PortBdata
           ldaa CPU_TimerControlStatReg    ; load a with memory contents
           anda #0xfd          ; AND a with value -11111101-
           staa CPU_TimerControlStatReg    ; store a into memory
           ldaa CPU_ICR_HB     ; load a with memory contents
           ldaa Counter_FallingEdgeEPP_MaxFF    ; load a with memory contents
           inca                ; increment a
           beq  LDE61          ; branch if equal (zero)
           staa Counter_FallingEdgeEPP_MaxFF    ; store a into memory
   LDE61:  ldx  #Cylinder2Retard    ; load index with value
           ldab 0x01,x         ; load b with memory at index + value
           rolb                ; rotate b left through carry
           rolb                ; rotate b left through carry
           rolb                ; rotate b left through carry
           andb #0x03          ;  -00000011-
           abx                 ; add b to index
           ldaa 0x00,x         ; load a with memory at index + value
           tab                 ; b = a
           anda #0xc0          ; AND a with value -11000000-
           andb #0x3f          ;  -00111111-
           staa FuelBaselineResult    ; store a into memory
           ldaa BitFlags_7f    ; load a with memory contents
           bmi  LDE7C          ; branch if minus(hi bit 1)
           clra                ; a = 0
           bra  LDE98          ; branch

   LDE7C:  ldaa BaroPressure    ; load a with memory contents
           adda KNKOFS_DeltaAboveBaroFor_RTRDRT_and_KNKCNT_and_KNKCOR_incremented    ;  (data is 2f)
           cmpa MapValue       ; compare a with memory contents
           ldaa RTRDRT_KnockRetardRateNoBoost    ; load a with memory contents (data is 06)
           bcc  LDE98          ; branch if greater or equal
           ldaa BitFlags_7f    ; load a with memory contents
           oraa #0x10          ;  -00010000-
           staa BitFlags_7f    ; store a into memory
           ldaa Counter_Over5psiBoost    ; load a with memory contents
           inca                ; increment a
           beq  LDE95          ; branch if equal (zero)
           staa Counter_Over5psiBoost    ; store a into memory
   LDE95:  ldaa RTRDRT2_KnockRetardRateInBoost    ; load a with memory contents (data is 03)
   LDE98:  aba                 ; a=a+b
           bcs  LDE9F          ; branch if lower
           cmpa #0x40          ; compare a with value -01000000-
           bcs  LDEA1          ; branch if lower
   LDE9F:  ldaa #0x3f          ; load a with value -00111111-
   LDEA1:  ldab MaxRetardFromMAP    ; load b with memory contents
           cba             
           bcs  LDEA7          ; branch if lower
           tba                 ; a = b
   LDEA7:  oraa FuelBaselineResult    ; OR a with memory contents
           staa 0x00,x     
           jsr  VerifyOperationOfMapSensor_MM    
           ldab BitFlags_85    ; load b with memory contents
           bmi  BaroReadIfRequired    ; branch if minus(hi bit 1)
           adda MapVolts   
           rora            
           staa MapValue       ; store a into memory
           ldaa BitFlags_82    ; load a with memory contents
           bmi  LDEE2          ; branch if minus(hi bit 1)
           ldaa BitFlags_80    ; load a with memory contents
           bpl  LDEE2          ; branch if plus (hi bit 0)
           jsr  SimulateMapReadingFromTps    
           jsr  ConvertMAPVoltsToValue    
           staa MapValue       ; store a into memory
           bra  LDEE2          ; branch

BaroReadIfRequired:
           ldab BitFlags_82    ; load b with memory contents
           bitb #0x10          ;  -00010000-
           beq  LDEE2          ; branch if equal (zero)
           andb #0xef          ;  -11101111-
           stab BitFlags_82    ; store b into memory
           cmpa BAROHI_BaroReadValidHighLimit    ; compare a with memory contents (data is 85)
           bcc  LDEDD          ; branch if greater or equal
           cmpa BAROLO_BaroReadValidLowLimit    ; compare a with memory contents (data is 45)
           bcc  LDEE0          ; branch if greater or equal
   LDEDD:  ldaa BARDFT_BaroReadDefaultValue    ; load a with memory contents (data is 7f)
   LDEE0:  staa BaroPressure    ; store a into memory
   LDEE2:  inc  Timer_O2ToggleDuration
           ldaa BitFlags_82    ; load a with memory contents
           bpl  LDEF1          ; branch if plus (hi bit 0)
           ldab ADScanIndex    ; load b with memory contents
           jsr  ADLookup       
           jmp  LDFB9      

   LDEF1:  ldaa Z85_ADConverterKnockSensor    ; load a with memory contents (data is 00)
           ldaa Cylinder2Retard    ; load a with memory contents
           bita #0x40          ;  -01000000-
           bne  CalculateInjectorPulsewidthForEngineRunning    ; branch if not equal (not zero)
           ldab #0x10          ; load b with value -00010000-
   LDEFC:  decb            
           bne  LDEFC          ; branch if not equal (not zero)
           jmp  LDFAE      

CalculateInjectorPulsewidthForEngineRunning:
           clra                ; a = 0
           clrb                ; b = 0
           std  Temp7          ; store D to RAM
           ldaa MapValue       ; load a with memory contents
           ldx  #WOTTBL_FuelFullThrottle    ; load index with value
           jsr  Lookup5ByteTable    
           std  FuelBaselineResult    ; store D to RAM
           ldaa MapValue       ; load a with memory contents
           ldx  #MAPIDL_FuelBaselineFromMap    ; load index with value
           ldab BitFlags_81    ; load b with memory contents
           bpl  LDF55          ; branch if plus (hi bit 0)
           lsrb                ; logical shift right b
           bcs  LDF2A          ; branch if lower
           ldab Timer_OpenLoopFraction    ; load b with memory contents
           cmpb LMTOLF2_LimitTimerOpenLoopFraction2    ; compare b with memory contents (data is 2b)
           bcs  LDF2F          ; branch if lower
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa RPMLMT_RPMLimitForManyThings    ; compare a with memory contents (data is 3a)
           bcs  LDF2F          ; branch if lower
   LDF2A:  clra                ; a = 0
           staa Counter_PrimaryAndSecondaryRamp    ; store a into memory
           bra  LDF62          ; branch

   LDF2F:  ldaa MapValue       ; load a with memory contents
           cmpa OBCONST_OverboostConstant1    ; compare a with memory contents (data is aa)
           bcs  LDF39          ; branch if lower
           tba                 ; a = b
           bra  LDF43          ; branch

   LDF39:  aba                 ; a=a+b
           bcc  LDF3E          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LDF3E:  suba OBCONST_OverboostConstant1    ;  (data is aa)
           bls  LDF50          ; branch if lower or same
   LDF43:  clrb                ; b = 0
           stab Counter_PrimaryAndSecondaryRamp    ; store b into memory
           staa Temp5          ; store a into memory
           ldd  FuelPulsewidthFunctionUnknown    ;  (data is 1eb2)
           jsr  mul16bit       
           std  Temp7          ; store D to RAM
   LDF50:  ldaa MapValue       ; load a with memory contents
           ldx  #MAPTBL_FuelPartThrottle    ; load index with value
   LDF55:  jsr  Lookup5ByteTable    
           addd Temp7          ; d = d + memory contents
           std  Temp7          ; store D to RAM
           subd FuelBaselineResult    ; d = d - memory contents
           ldd  Temp7          ; load d (a&b) with memory contents
           bcs  LDF64          ; branch if lower
   LDF62:  ldd  FuelBaselineResult    ; load d (a&b) with memory contents
   LDF64:  asld                ; shift left (d=d*2)
           std  Temp5          ; store D to RAM
           ldd  LeanoutFactor_HB    ; load d (a&b) with memory contents
           addd Temp5          ; d = d + memory contents
           bmi  LDF6F          ; branch if minus(hi bit 1)
           std  Temp5          ; store D to RAM
   LDF6F:  ldx  #Temp7         ; load index with value
           ldd  SumOfFuelModifiers_HB    ; load d (a&b) with memory contents
           std  Temp7          ; store D to RAM
           ldab Temp6          ; load b with memory contents
           clra                ; a = 0
           jsr  ScaleXbySignedB_ReturnD    
           std  Temp7          ; store D to RAM
           ldaa Temp5          ; load a with memory contents
           ldab SumOfFuelModifiers_LB    ; load b with memory contents
           mul                 ; multiply (d=a*b)
           addd Temp7          ; d = d + memory contents
           std  Temp7          ; store D to RAM
           ldab SumOfFuelModifiers_HB    ; load b with memory contents
           ldaa Temp5          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           tsta                ; test a
           bne  LDF93          ; branch if not equal (not zero)
           addb Temp7          ; b=b+memory contents
           bcc  LDF95          ; branch if greater or equal
   LDF93:  ldab #0xff          ; load b with value -11111111-
   LDF95:  tba                 ; a = b
           ldab TimerControlStatReg_Mirror    ; load b with memory contents
           std  Temp5          ; store D to RAM
           ldaa BitFlags_82    ; load a with memory contents
           bita #0x08          ;  -00001000-
           bne  LDFAE          ; branch if not equal (not zero)

IncludeSelectiveBankEnrichment:
           ldaa CONFIG_ConfigurationFlags
           bita #cfg_BankEnrich
           beq  SkipSelectiveEnrichment          ; branch if bit is not set

           ldaa Cylinder2Retard    ; load a with memory contents
           anda #0xc0          ; AND a with value -11000000-
           cmpa SBNRBS_BankSelect ; this must be either 0x80 (for bank 1-2) or 0x40 (for bank 3-4)
           beq  SkipSelectiveEnrichment    ; branch if equal (zero)
           ldx  #Temp5         ; load index with value
           ldaa #0x01          ; load a with value -00000001-
           ldab BankEnrichmentFactor    ; load b with memory contents
           jsr  ScaleXbySignedB_ReturnD    ; call subroutine
           stD *Temp5          ; store D to RAM

SkipSelectiveEnrichment:
           ldd  Temp5          ; load d (a&b) with memory contents
           std  InjectorPulsewidth_HB    ; store D to RAM
           addd Pulsewidth_PartThrottleEnrichment_HB    ; d = d + memory contents
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           addd Timer_FuelMonitorOutputTimer_HB    ; d = d + memory contents
           bcs  LDFAE          ; branch if lower
           std  Timer_FuelMonitorOutputTimer_HB    ; store D to RAM
   LDFAE:  ldab ADScanIndex    ; load b with memory contents
           jsr  ADLookup       
           ldx  #BatteryVolts    ; load index with value
           jsr  RegulateVoltage    
   LDFB9:  bsr  LDFE7          
           ldaa BitFlags_82    ; load a with memory contents
           bita #0x02          ;  -00000010-
           beq  LDFE6          ; branch if equal (zero)
           ldaa #0x19          ; load a with value -00011001-
           staa CPU_TimerControlStatReg    ; store a into memory
           ldd  #CPU_Counter_LB    ; load d (a&b) with value -00000000 00001010-
           addd CPU_Counter_HB    ; d = d + memory contents
           std  CPU_OCR_HB     ; store D to RAM
           mul                 ; multiply (d=a*b)
           ldab CPU_Port1_ControlRegister    ; load b with memory contents
           bitb #0x40          ;  -01000000-
           beq  LDFDD          ; branch if equal (zero)
           andb #0x06          ;  -00000110-
           bne  LDFDD          ; branch if not equal (not zero)
           ldaa BitFlags_83    ; load a with memory contents
           oraa #0x10          ;  -00010000-
           staa BitFlags_83    ; store a into memory
   LDFDD:  ldd  #0x1b58        ; load d (a&b) with value -00011011 01011000-
           addd CPU_ICR_HB     ; d = d + memory contents
           cmpa CPU_TimerControlStatReg    ; compare a with memory contents
           std  CPU_OCR_HB     ; store D to RAM
   LDFE6:  rti                 ; return from interrupt

   LDFE7:  ldaa Cylinder2Retard    ; load a with memory contents
           lsla                ; logical shift left a
           bmi  LDFED          ; branch if minus(hi bit 1)
           rts                 ; return from subroutine

   LDFED:  ldx  #CPU_OCR3_HB    ; load index with value
           ldaa #0xfb          ; load a with value -11111011-
           bcc  LE011          ; branch if greater or equal
           ldaa MapValue       ; load a with memory contents
           tab                 ; b = a
           subb IncrementalMAP    ; b = b-memory contents
           bcc  LE003          ; branch if greater or equal
           cmpb #0x80          ;  -10000000-
           bcc  LE009          ; branch if greater or equal
           ldab #0x80          ; load b with value -10000000-
           bra  LE009          ; branch

   LE003:  cmpb #0x7f          ;  -01111111-
           bcs  LE009          ; branch if lower
           ldab #0x7f          ; load b with value -01111111-
   LE009:  stab Delta_MAP      ; store b into memory
           staa IncrementalMAP    ; store a into memory
           dex                 ; decrement index (x=x-1)
           dex                 ; decrement index (x=x-1)
           ldaa #0xfd          ; load a with value -11111101-
   LE011:  staa Temp7          ; store a into memory
           anda CPU_TimerControl1    ; logical and a with memory contents
           bsr  LE02E          
           ldaa BitFlags_84    ; load a with memory contents
           bita #0x28          ;  -00101000-
           beq  LE038          ; branch if equal (zero)
           clra                ; a = 0
           clrb                ; b = 0
           std  Timer_FuelMonitorOutputTimer_HB    ; store D to RAM
           ldaa #0xf9          ; load a with value -11111001-
           anda CPU_TimerControl1    ; logical and a with memory contents
   LE025:  ldx  #CPU_OCR2_HB    ; load index with value
           bsr  LE02E          
           inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
           bra  LE030          ; branch

   LE02E:  staa CPU_TimerControl1    ; store a into memory
   LE030:  ldd  CPU_Counter_HB    ; load d (a&b) with memory contents
           addd #CPU_PortX_ControlStatReg    ;  -00000000 00001111-
           std  0x00,x         ; store d into index plus offset
           rts                 ; return from subroutine

   LE038:  ldd  CPU_OCR_HB     ; load d (a&b) with memory contents
           subd CPU_Counter_HB    ; d = d - memory contents
           cmpa #0x02          ; compare a with value -00000010-
           bcs  LE058          ; branch if lower
           ldaa CPU_Port2_ControlRegister    ; load a with memory contents
           bita #0x02          ;  -00000010-
           beq  LE058          ; branch if equal (zero)
           ldaa BitFlags_82    ; load a with memory contents
           bita #0x02          ;  -00000010-
           bne  LE058          ; branch if not equal (not zero)
           ldaa CPU_TimerControl1    ; load a with memory contents
           anda #0xdf          ; AND a with value -11011111-
           ldab CPU_Port2_ControlRegister    ; load b with memory contents
           andb #0xfd          ;  -11111101-
           staa CPU_TimerControl1    ; store a into memory
           stab CPU_Port2_ControlRegister    ; store b into memory
   LE058:  ldaa Temp7          ; load a with memory contents
           coma            
           oraa CPU_TimerControl1    ; OR a with memory contents
           bsr  LE02E          
           ldaa BatteryVolts    ; load a with memory contents
           cmpa #0x91          ; compare a with value -10010001-
           bcs  LE078          ; branch if lower
           ldaa CPU_Port1_ControlRegister    ; load a with memory contents
           bita #0x40          ;  -01000000-
           beq  LE078          ; branch if equal (zero)
           ldaa #0x04          ; load a with value -00000100-
           ldab Temp7          ; load b with memory contents
           cmpb #0xfd          ;  -11111101-
           beq  LE074          ; branch if equal (zero)
           lsla                ; logical shift left a
   LE074:  oraa BitFlags_83    ; OR a with memory contents
           staa BitFlags_83    ; store a into memory
   LE078:  ldaa BitFlags_82    ; load a with memory contents
           bita #0x02          ;  -00000010-
           bne  LE08A          ; branch if not equal (not zero)
           ldab CPU_Port2_ControlRegister    ; load b with memory contents
           orab #0x02          ;  -00000010-
           stab CPU_Port2_ControlRegister    ; store b into memory
           ldab CPU_TimerControl1    ; load b with memory contents
           orab #0x20          ;  -00100000-
           stab CPU_TimerControl1    ; store b into memory
   LE08A:  clra                ; a = 0
           ldab InjectorLatency    ; load b with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           addd Temp5          ; d = d + memory contents
           bcc  LE097          ; branch if greater or equal
           ldd  #0xffff        ; load d (a&b) with value -11111111 11111111-
   LE097:  tsta                ; test a
           bne  LE09C          ; branch if not equal (not zero)
           ldab #0xff          ; load b with value -11111111-
   LE09C:  std  Temp5          ; store D to RAM
           ldaa BitFlags_82    ; load a with memory contents
           bmi  LE0FB          ; branch if minus(hi bit 1)
           bita #0x08          ;  -00001000-
           bne  LE0CE          ; branch if not equal (not zero)
   LE0A6:  ldd  Temp5          ; load d (a&b) with memory contents
           addd Pulsewidth_PartThrottleEnrichment_HB    ; d = d + memory contents
           bcc  LE0AF          ; branch if greater or equal
           ldd  #0xffff        ; load d (a&b) with value -11111111 11111111-
   LE0AF:  tsta                ; test a
           bne  LE0B4          ; branch if not equal (not zero)
           ldab #0xff          ; load b with value -11111111-
   LE0B4:  cpx  #CPU_OCR2_HB    ;  -00000000 00011010-
           bne  LE0C3          ; branch if not equal (not zero)
           addd CPU_OCR2_HB    ; d = d + memory contents
           std  CPU_OCR2_HB    ; store D to RAM
           ldaa CPU_TimerControl1    ; load a with memory contents
           anda #0xfd          ; AND a with value -11111101-
           bra  LE0CB          ; branch

   LE0C3:  addd CPU_OCR3_HB    ; d = d + memory contents
           stD CPU_OCR3_HB    ; store D to RAM
           ldaa CPU_TimerControl1    ; load a with memory contents
           anda #0xfb          ; AND a with value -11111011-
   LE0CB:  staa CPU_TimerControl1    ; store a into memory
           rts                 ; return from subroutine

   LE0CE:  ldd  InjectorPulsewidth_HB    ; load d (a&b) with memory contents
           suba FuelSubtractedFromStartToRun
           bcc  LE0D5          ; branch if greater or equal
           clra                ; a = 0
   LE0D5:  std  InjectorPulsewidth_HB    ; store D to RAM
           ldd  Temp5          ; load d (a&b) with memory contents
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           subd InjectorPulsewidth_HB    ; d = d - memory contents
           bcs  LE0FB          ; branch if lower
           ldaa BitFlags_82    ; load a with memory contents
           anda #0xf7          ; AND a with value -11110111-
           staa BitFlags_82    ; store a into memory
           ldaa Bits_WhichInjector    ; load a with memory contents
           anda #0xfc          ; AND a with value -11111100-
           staa Bits_WhichInjector    ; store a into memory
           clra                ; a = 0
           staa FuelSubtractedFromStartToRun    ; store a into memory
           staa Counter_FallingEdgeEPP_MaxFF    ; store a into memory
           clrb                ; b = 0
           std  Pulsewidth_PartThrottleEnrichment_HB    ; store D to RAM
           ldaa CPU_TimerControl2    ; load a with memory contents
           anda #0xcf          ; AND a with value -11001111-
           staa CPU_TimerControl2    ; store a into memory
           bra  LE0A6          ; branch

   LE0FB:  ldd  InjectorPulsewidth_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           cmpa #0x02          ; compare a with value -00000010-
           bcc  LE106          ; branch if greater or equal
           ldd  #0x0200        ; load d (a&b) with value -00000010 00000000-
   LE106:  std  Pulsewidth_PartThrottleEnrichment_HB    ; store D to RAM
           stx  FuelBaselineResult    ; store index into memory
           cpx  #CPU_OCR2_HB    ;  -00000000 00011010-
           beq  LE114          ; branch if equal (zero)
           ldx  #Bits_WhichInjector    ; load index with value
           bra  LE117          ; branch

   LE114:  ldx  #BitFlags_7f    ; load index with value
   LE117:  ldab 0x00,x         ; load b with memory at index + value
           andb #0xfc          ;  -11111100-
           stab 0x00,x     
           ldaa InjectorPulsewidth_HB    ; load a with memory contents
           lsla                ; logical shift left a
           rolb                ; rotate b left through carry
           lsla                ; logical shift left a
           rolb                ; rotate b left through carry
           andb #0x03          ;  -00000011-
           orab 0x00,x     
           stab 0x00,x     
           ldaa BitFlags_82    ; load a with memory contents
           bita #0x02          ;  -00000010-
           beq  LE14D          ; branch if equal (zero)
           ldaa CPU_Port1_ControlRegister    ; load a with memory contents
           oraa #0xf9          ;  -11111001-
           coma            
           beq  LE14D          ; branch if equal (zero)
           ldab #0x05          ; load b with value -00000101-
   LE138:  ldaa CPU_Port1_ControlRegister    ; load a with memory contents
           lsla                ; logical shift left a
           bmi  LE14D          ; branch if minus(hi bit 1)
           decb            
           bne  LE138          ; branch if not equal (not zero)
           ldaa #0x04          ; load a with value -00000100-
           ldab Temp7          ; load b with memory contents
           cmpb #0xfd          ;  -11111101-
           beq  LE149          ; branch if equal (zero)
           lsla                ; logical shift left a
   LE149:  oraa BitFlags_83    ; OR a with memory contents
           staa BitFlags_83    ; store a into memory
   LE14D:  ldaa 0x00,x         ; load a with memory at index + value
           bita #0x03          ;  -00000011-
           bne  LE159          ; branch if not equal (not zero)
           ldaa Temp7          ; load a with memory contents
           anda CPU_TimerControl1    ; logical and a with memory contents
           staa CPU_TimerControl1    ; store a into memory
   LE159:  ldx  FuelBaselineResult
           ldaa CPU_TimerStatus    ; load a with memory contents
           ldd  Pulsewidth_PartThrottleEnrichment_HB    ; load d (a&b) with memory contents
           bmi  LE172          ; branch if minus(hi bit 1)
           addd 0x00,x     
           std  0x00,x         ; store d into index plus offset
           subd CPU_Counter_HB    ; d = d - memory contents
           bpl  LE176          ; branch if plus (hi bit 0)
           ldaa CPU_TimerStatus    ; load a with memory contents
           ldab Temp7          ; load b with memory contents
           jsr  LCC77          
           bra  LE176          ; branch

   LE172:  addd 0x00,x     
           std  0x00,x         ; store d into index plus offset
   LE176:  ldaa #0xfb          ; load a with value -11111011-
           staa CPU_TimerControl2    ; store a into memory
           rts                 ; return from subroutine

InterruptFromDistributorSyncAndSpeedSensor:
           ldaa CPU_TimerStatus    ; load a with memory contents
           bpl  LE182          ; branch if plus (hi bit 0)
           jmp  InterruptVector_SpeedometerSignal

   LE182:  ldab Z83_PortCdata    ; load b with memory contents
           andb #0x80          ;  -10000000-
           stab Temp6          ; store b into memory
           ldaa CPU_TimerControlStatReg    ; load a with memory contents
           ldd  CPU_ICR_HB     ; load d (a&b) with memory contents
           jsr  DetermineNumberOfOverflowsBetweenDistributorPulses_MM    
           ldaa CPU_TimerControlStatReg    ; load a with memory contents
           tab                 ; b = a
           lsra            
           eora CPU_Port2_ControlRegister
           lsra            
           bcc  LE19A          ; branch if greater or equal
           rti                 ; return from interrupt

   LE19A:  ldaa Counter_SomethingWithDistributor    ; load a with memory contents
           inca                ; increment a
           beq  LE1A1          ; branch if equal (zero)
           staa Counter_SomethingWithDistributor    ; store a into memory
   LE1A1:  clra                ; a = 0
           staa LowestHistoricalTPS    ; store a into memory
           orab #0x18          ;  -00011000-
           stab CPU_TimerControlStatReg    ; store b into memory
           ldaa ErrorBitRegisterStored3    ; load a with memory contents
           anda #0x7f          ; AND a with value -01111111-
           staa ErrorBitRegisterStored3    ; store a into memory
           bitb #0x02          ;  -00000010-
           beq  LE1B5          ; branch if equal (zero)
           jmp  HandleKnockRetard

   LE1B5:  ldab Z85_ADConverter1    ; load b with memory contents (data is 00)
           ldab Z85_ADConverter1    ; load b with memory contents (data is 00)
           ldab Z83_PortBdata    ; load b with memory contents
           andb #0xdf          ;  -11011111-
           stab Z83_PortBdata    ; store b into memory
           ldaa Counter_TimerPastHalfwayBetweenDistPulses    ; load a with memory contents
           lsra            
           staa TimerOverflowsBetweenDistPulses    ; store a into memory
           ldd  CPU_ICR_HB     ; load d (a&b) with memory contents
           subd LastDistributorFallingEdgeTime_HB    ; d = d - memory contents
           std  DistributorFallingEdgePulsewidth_HB    ; store D to RAM
           ldd  CPU_ICR_HB     ; load d (a&b) with memory contents
           std  LastDistributorFallingEdgeTime_HB    ; store D to RAM
           clra                ; a = 0
           staa Counter_TimerPastHalfwayBetweenDistPulses    ; store a into memory
           ldaa BitFlags_82    ; load a with memory contents
           bita #0x04          ;  -00000100-
           bne  LE1E2          ; branch if not equal (not zero)
           ldab CPU_TimerControlStatReg    ; load b with memory contents
           orab #0x02          ;  -00000010-
           stab CPU_TimerControlStatReg    ; store b into memory
           rti                 ; return from interrupt

   LE1E2:  ldaa #0xff          ; load a with value -11111111-
           ldx  TimerOverflowsBetweenDistPulses
           cpx  SKAPRD_SparkImmediateSwitchToRunAboveThisRpm    ;  (data is 0092)
           bcs  ENGINE_IDLING_FASTERTHAN_813RPM    ; branch if lower
           ;ldx  #STRNTR_SparkStartRunTransferPointRpm    ; load index with value
           ;ldaa CoolantTemp    ; load a with memory contents
           ;jsr  Lookup5ByteTable
           ldd  STRNTR_SparkStartRunTransferPointRpm
           subd TimerOverflowsBetweenDistPulses    ; d = d - memory contents
           bcc  ENGINE_IDLING_BETWEEN598_813RPM    ; branch if greater or equal
           ldaa BitFlags_82    ; load a with memory contents
           bita #0x02          ;  -00000010-
           beq  LE200          ; branch if equal (zero)
           clra                ; a = 0
           staa Timer_NormalDwell    ; store a into memory
   LE200:  ;ldx  #RNSTTR_SparkRunStartTransferPointRpm    ; load index with value
           ;ldaa CoolantTemp    ; load a with memory contents
           ;jsr  Lookup5ByteTable
           ldd  RNSTTR_SparkRunStartTransferPointRpm
           subd TimerOverflowsBetweenDistPulses    ; d = d - memory contents
           bcc  LE232          ; branch if greater or equal
   LE20C:  ldaa BitFlags_82    ; load a with memory contents
           oraa #0x02          ;  -00000010-
           bra  LE230          ; branch

ENGINE_IDLING_BETWEEN598_813RPM:
           ldaa Timer_NormalDwell    ; load a with memory contents
           inca                ; increment a
           beq  LE228          ; branch if equal (zero)
ENGINE_IDLING_FASTERTHAN_813RPM:
           staa Timer_NormalDwell    ; store a into memory
           ldx  #SRTIME_SparkEPPsNeededToBeAboveSR_Hot    ; load index with value
           ldab SRTMTP_SparkTempSwitchPointFor_SRTIME    ; load b with memory contents (data is b0)
           cmpb CoolantTemp
           bcs  SETTOLOOKFOR_RISINGEDGE_AND_CALCULATE_DWELL    ; branch if lower
           inx                 ; increment index (x=x+1)
SETTOLOOKFOR_RISINGEDGE_AND_CALCULATE_DWELL:
           cmpa 0x00,x         ; compare a with memory at index + value
           bcs  LE20C          ; branch if lower
   LE228:  ldaa BitFlags_82    ; load a with memory contents
           bita #0x02          ;  -00000010-
           beq  LE232          ; branch if equal (zero)
           anda #0xfd          ; AND a with value -11111101-
   LE230:  staa BitFlags_82    ; store a into memory
   LE232:  ldaa #0x1a          ; load a with value -00011010-
           staa CPU_TimerControlStatReg    ; store a into memory
           jsr  VerifyOperationOfMapSensor_MM    
           ldab BitFlags_85    ; load b with memory contents
           bmi  LE23F          ; branch if minus(hi bit 1)
           staa MapVolts       ; store a into memory
   LE23F:  ldaa BitFlags_82    ; load a with memory contents
           bita #0x02          ;  -00000010-
           beq  CalculateDwell    ; branch if equal (zero)
           ldab ADScanIndex    ; load b with memory contents
           jsr  ADLookup       
           ldd  #0x1b00        ; load d (a&b) with value -00011011 00000000-
           addd CPU_ICR_HB     ; d = d + memory contents
           std  Temp6          ; store D to RAM
           ldaa #0x1a          ; load a with value -00011010-
           jmp  LE365      

CalculateDwell:
           ldd  DistributorFallingEdgePulsewidth_HB    ; load d (a&b) with memory contents
           cmpa #0x2a          ; compare a with value -00101010-
           bcc  UseMinAntiDwell    ; branch if greater or equal
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           coma            
           comb            
           addd DistributorFallingEdgePulsewidth_HB    ; d = d + memory contents
           lsrd                ; shift right (d=d/2)
           std  DwellTime_HB    ; store D to RAM
           lsrd                ; shift right (d=d/2)
           cmpa #0x06          ; compare a with value -00000110-
           bcs  StoreDwell     ; branch if lower
           addd DwellTime_HB    ; d = d + memory contents
           suba #0x0c          ;  -00001100-
           bra  StoreDwell     ; branch

UseMinAntiDwell:
           suba #0x1c          ;  -00011100-
StoreDwell:
           std  DwellTime_HB    ; store D to RAM
           ldx  #Cylinder2Retard    ; load index with value
           ldab 0x00,x         ; load b with memory at index + value
           rolb                ; rotate b left through carry
           rolb                ; rotate b left through carry
           rolb                ; rotate b left through carry
           andb #0x03          ;  -00000011-
           abx                 ; add b to index
           ldaa 0x00,x         ; load a with memory at index + value
           anda #0x3f          ; AND a with value -00111111-
           adda CalculatedSparkAdvance
           staa Temp5          ; store a into memory
           ldab BitFlags_80    ; load b with memory contents
           bitb #0x02          ;  -00000010-
           beq  LE2A1          ; branch if equal (zero)
           ldab BitFlags_81    ; load b with memory contents
           bmi  LE2A1          ; branch if minus(hi bit 1)
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           cmpa MPHREF_SwitchPointForDecelIdleAisControl    ; compare a with memory contents (data is 06)
           bcc  LE2A1          ; branch if greater or equal
           ldaa MXSPK1_MaxSparkAdvanceUknown1    ; load a with memory contents (data is 6e)
           staa Temp5          ; store a into memory
   LE2A1:  ldaa Z85_ADConverterKnockSensor    ; load a with memory contents (data is 00)
           staa KnockVolts     ; store a into memory
           ldab BitFlags_7f    ; load b with memory contents
           andb #0x7f          ;  -01111111-
           cmpa KnockLookup    ; compare a with memory contents
           bcs  LE2B0          ; branch if lower
           orab #0x80          ;  -10000000-
   LE2B0:  stab BitFlags_7f    ; store b into memory
           ldaa BitFlags_82    ; load a with memory contents
           oraa BitFlags_81    ; OR a with memory contents
           bmi  LE32C          ; branch if minus(hi bit 1)
           ldab BitFlags_84    ; load b with memory contents
           andb #0x40          ;  -01000000-
           orab Timer_CountdownFromStartRunForAisFeedback
           bne  LE32C          ; branch if not equal (not zero)
           ldx  #Idle_word_A    ; load index with value
           ldaa #0x40          ; load a with value -01000000-
           staa Temp6          ; store a into memory
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeed_HB    ; d = d - memory contents
           bcc  LE2D7          ; branch if greater or equal
           asl  Temp6      
           ldx  #Idle_word_B    ; load index with value
           ldd  TargetIdleSpeed_HB    ; load d (a&b) with memory contents
           subd EngineRpm_HB    ; d = d - memory contents
   LE2D7:  lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           subd FWDARP_SubtractedFromRPMDuringIdleRoutine    ;  (data is 001e)
           ldaa 0x00,x         ; load a with memory at index + value
           bcc  LE2EA          ; branch if greater or equal
           addb REVARP_AddedBackToRPMDuringIdleRoutine    ;  (data is 1e)
           bmi  LE32C          ; branch if minus(hi bit 1)
           ldaa 0x01,x         ; load a with memory at index + value
           mul                 ; multiply (d=a*b)
           adca 0x02,x     
   LE2EA:  ldab Temp6          ; load b with memory contents
           bpl  LE2EF          ; branch if plus (hi bit 0)
           nega                ; negate a (set high bit)
   LE2EF:  ldab BitFlags_80    ; load b with memory contents
           bitb #0x82          ;  -10000010-
           bne  LE312          ; branch if not equal (not zero)
           ldx  TimerOverflowsBetweenDistPulses
           cpx  SSIPRD_ScatterInhibitBelowThisSpeed    ;  (data is 00d0)
           bcc  LE312          ; branch if greater or equal
           tab                 ; b = a
           addb Temp5          ; b=b+memory contents
           stab Temp5          ; store b into memory
           ldab BitFlags_84    ; load b with memory contents
           bitb #0x04          ;  -00000100-
           beq  LE312          ; branch if equal (zero)
           ldab BitFlags_C9    ; load b with memory contents
           cmpb #0x70          ;  -01110000-
           bne  LE312          ; branch if not equal (not zero)
           ldab MXSPK2_MaxSparkAdvanceUknown2    ; load b with memory contents (data is 6d)
           stab Temp5          ; store b into memory
   LE312:  adda SparkScatter
           bvc  DoUseSparkScatter    ; branch if overflow
           ldab DesiredNewAisPosition    ; load b with memory contents
           cmpb CurrentAisPosition
           bne  DontUseSparkScatter    ; branch if not equal (not zero)
           ldaa FTUNPW_FineTuneStepForAis    ; load a with memory contents (data is 01)
           beq  DontUseSparkScatter    ; branch if equal (zero)
           ldab Temp6          ; load b with memory contents
           bmi  SaveDesiredAisPosition    ; branch if minus(hi bit 1)
           nega                ; negate a (set high bit)
SaveDesiredAisPosition:
           jsr  StoreAndLimitDesiredAisPosition    
DontUseSparkScatter:
           clra                ; a = 0
DoUseSparkScatter:
           staa SparkScatter    ; store a into memory
   LE32C:  ldaa #0x76          ; load a with value -01110110-
           cmpa Temp5          ; compare a with memory contents
           bhi  LE334          ; branch if higher
           staa Temp5          ; store a into memory
   LE334:  ldd  DistributorFallingEdgePulsewidth_HB    ; load d (a&b) with memory contents
           tst  TimerOverflowsBetweenDistPulses
           beq  LE349          ; branch if equal (zero)
           lsrd                ; shift right (d=d/2)
           oraa #0x80          ;  -10000000-
           jsr  mul16bit       
           asld                ; shift left (d=d*2)
           bcc  LE34C          ; branch if greater or equal
           ldd  #0xffff        ; load d (a&b) with value -11111111 11111111-
           bra  LE34C          ; branch

   LE349:  jsr  mul16bit       
   LE34C:  addd LastDistributorFallingEdgeTime_HB    ; d = d + memory contents
           std  Temp6          ; store D to RAM
           addd DwellTime_HB    ; d = d + memory contents
           subd DistributorFallingEdgePulsewidth_HB    ; d = d - memory contents
           tst  TimerOverflowsBetweenDistPulses
           bne  LE363          ; branch if not equal (not zero)
           cmpa CPU_TimerControlStatReg    ; compare a with memory contents
           std  CPU_OCR_HB     ; store D to RAM
           ldab CPU_Counter_HB    ; load b with memory contents
           incb            
           sba                 ; subtract (a=a-b)
           bpl  LE379          ; branch if plus (hi bit 0)
   LE363:  ldaa #0x1b          ; load a with value -00011011-
   LE365:  staa TimerControlStatReg_Mirror    ; store a into memory
           ldd  #CPU_Counter_LB    ; load d (a&b) with value -00000000 00001010-
           addd CPU_Counter_HB    ; d = d + memory contents
           std  CPU_OCR_HB     ; store D to RAM
           mul                 ; multiply (d=a*b)
           ldd  Temp6          ; load d (a&b) with memory contents
           cmpa CPU_TimerControlStatReg    ; compare a with memory contents
           std  CPU_OCR_HB     ; store D to RAM
           ldaa TimerControlStatReg_Mirror    ; load a with memory contents
           staa CPU_TimerControlStatReg    ; store a into memory
   LE379:  ldaa CPU_Port1_ControlRegister    ; load a with memory contents
           oraa #0x80          ;  -10000000-
           staa CPU_Port1_ControlRegister    ; store a into memory
           ldaa BitFlags_82    ; load a with memory contents
           bita #0x02          ;  -00000010-
           bne  LE390          ; branch if not equal (not zero)
           ldab ADScanIndex    ; load b with memory contents
           jsr  ADLookup       
           ldx  #BatteryVolts    ; load index with value
           jsr  RegulateVoltage    
   LE390:  ldx  TimerOverflowsBetweenDistPulses
           cpx  RNFPRD_FuelStartRunTransferPointRpm    ;  (data is 00a7)
           bcs  LE3A4          ; branch if lower
           cpx  STFPRD_FuelRunStartTransferPointRpm    ;  (data is 0104)
           bcs  LE3DA          ; branch if lower
           ldaa BitFlags_82    ; load a with memory contents
           oraa #0x88          ;  -10001000-
           staa BitFlags_82    ; store a into memory
           bra  LE3DA          ; branch

   LE3A4:  ldaa BitFlags_82    ; load a with memory contents
           lsla                ; logical shift left a
           bcc  LE3DA          ; branch if greater or equal
           lsra            
           oraa #0x20          ;  -00100000-
           staa BitFlags_82    ; store a into memory
           ldx  KeyOnOrEngineRunningTime
           clra                ; a = 0
           clrb                ; b = 0
           std  KeyOnOrEngineRunningTime    ; store D to RAM
           cpx  #CPU_RAM_ControlReg    ;  -00000000 00010100-
           ldab BitFlags_80    ; load b with memory contents
           bcc  LE3BF          ; branch if greater or equal
           andb #0x7f          ;  -01111111-
           stab BitFlags_80    ; store b into memory
   LE3BF:  bpl  CheckBaroPressure    ; branch if plus (hi bit 0)
           ldab #0x20          ; load b with value -00100000-
           ldx  #ErrorBitRegister3    ; load index with value
           jsr  ThrowNonCriticalError    
CheckBaroPressure:
           ldaa BaroPressure    ; load a with memory contents
           cmpa BAROHI_BaroReadValidHighLimit    ; compare a with memory contents (data is 85)
           bcc  LE3D5          ; branch if greater or equal
           cmpa BAROLO_BaroReadValidLowLimit    ; compare a with memory contents (data is 45)
           bcc  LE3DA          ; branch if greater or equal
   LE3D5:  ldaa BARDFT_BaroReadDefaultValue    ; load a with memory contents (data is 7f)
           staa BaroPressure    ; store a into memory
   LE3DA:  ldaa MapValue       ; load a with memory contents
           cmpa AverageMAPValue    ; compare a with memory contents
           bcs  LE3E6          ; branch if lower
           ldx  #AverageMAPValue    ; load index with value
           jsr  ProcessMapOrTpsBlockData    
   LE3E6:  clra                ; a = 0
           ldab AverageMAPValue    ; load b with memory contents
           subb MapValue       ; b = b-memory contents
           bls  LE419          ; branch if lower or same
           stab Temp5          ; store b into memory
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb MNDCRP_MinRPMforDecelLeanout    ; compare b with memory contents (data is 14)
           bcs  LE419          ; branch if lower
           ldab KeyOnOrEngineRunningTime    ; load b with memory contents
           cmpb MNDCTM_MinTimeforDecelLeanout    ; compare b with memory contents (data is 02)
           bcs  LE419          ; branch if lower
           ldab Temp5          ; load b with memory contents
           ldaa Timer_Leanout    ; load a with memory contents
           beq  LE406          ; branch if equal (zero)
           addb DMDCIC_DeltaMAPLeanoutIncrement    ;  (data is 02)
   LE406:  clra                ; a = 0
           subb DMDCDC_DeltaMAPLeanoutDecrement    ; subtract memory contents from b (data is 03)
           bcs  LE419          ; branch if lower
           ldaa TMDCNT_TimerLeanoutInitial    ; load a with memory contents (data is ed)
           cmpb DMLMT_DeltaMAPLeanoutLimit    ; compare b with memory contents (data is 08)
           bcc  LE419          ; branch if greater or equal
           ldaa Timer_Leanout    ; load a with memory contents
           beq  LE41B          ; branch if equal (zero)
           inca                ; increment a
   LE419:  staa Timer_Leanout    ; store a into memory
   LE41B:  ldx  #AverageTPSVolts    ; load index with value
           jsr  ProcessMapOrTpsBlockData    
           ldab AdaptiveCellUpdateTimer_IncrementedEveryDistRisingEdge    ; load b with memory contents
           incb            
           beq  LE428          ; branch if equal (zero)
           stab AdaptiveCellUpdateTimer_IncrementedEveryDistRisingEdge    ; store b into memory
   LE428:  rti                 ; return from interrupt

        .msg "..." ; these are just messages to display during assemble to let you know what's going on...

CalculateTargetIdleSpeedAndAisPosition_MM:
           ldaa BitFlags_AIS    ; load a with memory contents
           bita #0x08          ;  -00001000-
           bne  LE439          ; branch if not equal (not zero)
           ldab Counter_MainLoop1    ; load b with memory contents
           andb #0x7e          ;  -01111110-
           bne  LE439          ; branch if not equal (not zero)
           anda #0xfb          ; AND a with value -11111011-
           staa BitFlags_AIS    ; store a into memory
   LE439:  ldab BitFlags_4f    ; load b with memory contents
           orab BitFlags_82
           bpl  LE45C          ; branch if plus (hi bit 0)
           ldaa DesiredNewAisPosition    ; load a with memory contents
           cmpa CurrentAisPosition    ; compare a with memory contents
           bne  LE451          ; branch if not equal (not zero)
           ldab BitFlags_AIS    ; load b with memory contents
           bitb #0x40          ;  -01000000-
           bne  LE451          ; branch if not equal (not zero)
           ldab BitFlags_4f    ; load b with memory contents
           andb #0x7f          ;  -01111111-
           stab BitFlags_4f    ; store b into memory
   LE451:  ldaa CoolantTemp    ; load a with memory contents
           ldx  #AISTRT_AisStartupPosition_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    
           jmp  LE628      

   LE45C:  ldab BitFlags_80    ; load b with memory contents
           bpl  LE46C          ; branch if plus (hi bit 0)
           ldaa DEFAIS_DefaultAISStartPosition    ; load a with memory contents (data is 0c)
           staa DesiredNewAisPosition    ; store a into memory
           ldaa BitFlags_85    ; load a with memory contents
           anda #0xf7          ; AND a with value -11110111-
           staa BitFlags_85    ; store a into memory
           rts                 ; return from subroutine

   LE46C:  clra                ; a = 0
           staa Temp1          ; store a into memory
           ldaa Z83_PortCdata    ; load a with memory contents
           anda #0x04          ; AND a with value -00000100-
           staa Temp0          ; store a into memory
           ldab BitFlags_85    ; load b with memory contents
           andb #0x04          ;  -00000100-
           eorb Temp0      
           beq  LE4D5          ; branch if equal (zero)
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           cmpa ACCTIM_AcDelayFromStartRunTransfer    ; compare a with memory contents (data is 04)
           bcs  LE4CF          ; branch if lower
           eorb BitFlags_85
           stab BitFlags_85    ; store b into memory
           bitb #0x04          ;  -00000100-
           beq  LE4B6          ; branch if equal (zero)
           ldaa BitFlags_81    ; load a with memory contents
           bpl  LE4AB          ; branch if plus (hi bit 0)
           ldx  #ACCTBL_ACOffIdleDelta_FromSpeed    ; load index with value
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    
           ldab OFFPER2_AisInstantlyClosesWhenAcDisengages2    ; load b with memory contents (data is f0)
           mul                 ; multiply (d=a*b)
           tab                 ; b = a
           ldaa DesiredNewAisPosition    ; load a with memory contents
           sba                 ; subtract (a=a-b)
           bcc  LE4A7          ; branch if greater or equal
           clra                ; a = 0
   LE4A7:  staa DesiredNewAisPosition    ; store a into memory
           bra  LE4B1          ; branch

   LE4AB:  ldaa IAISOP_IdleAISOpenStepsNegative    ; load a with memory contents (data is f8)
           jsr  LE65E          
   LE4B1:  clra                ; a = 0
           staa Timer_AisOrO2Sensor    ; store a into memory
           bra  LE4CC          ; branch

   LE4B6:  ldaa ACTIME_TimeBeforeAcEnabledAndFullDeltaUsed    ; load a with memory contents (data is 16)
           staa Timer_AisOrO2Sensor    ; store a into memory
           ldaa BitFlags_81    ; load a with memory contents
           bmi  LE4C5          ; branch if minus(hi bit 1)
           ldaa ACOFFK_ClosedThrottleAcOffKick    ; load a with memory contents (data is 12)
           jsr  LE65E          
   LE4C5:  ldaa Timer_AisOrO2Sensor    ; load a with memory contents
           beq  LE4CA          ; branch if equal (zero)
   LE4C9:  deca                ; decrement a
   LE4CA:  staa Timer_AisOrO2Sensor    ; store a into memory
   LE4CC:  clra                ; a = 0
           staa Timer_AisChanges    ; store a into memory
   LE4CF:  ldaa BitFlags_85    ; load a with memory contents
           oraa #0x08          ;  -00001000-
           bra  LE4F3          ; branch

   LE4D5:  tsta                ; test a
           bne  LE4CF          ; branch if not equal (not zero)
           ldaa Timer_AisOrO2Sensor    ; load a with memory contents
           cmpa #0x01          ; compare a with value -00000001-
           bcs  LE4EF          ; branch if lower
           bne  LE4C9          ; branch if not equal (not zero)
           ldaa BitFlags_81    ; load a with memory contents
           bmi  LE4EA          ; branch if minus(hi bit 1)
           ldaa AC2KCK_AcClutchKickOpenAfterAcEnabled    ; load a with memory contents (data is 07)
           jsr  LE685          
   LE4EA:  clra                ; a = 0
           staa Timer_AisOrO2Sensor    ; store a into memory
           staa Timer_AisChanges    ; store a into memory
   LE4EF:  ldaa BitFlags_85    ; load a with memory contents
           anda #0xf7          ; AND a with value -11110111-
   LE4F3:  staa BitFlags_85    ; store a into memory
           ldaa Temp1          ; load a with memory contents
           beq  LE4FA          ; branch if equal (zero)
   LE4F9:  rts                 ; return from subroutine

   LE4FA:  ldab BitFlags_81    ; load b with memory contents
           bpl  LE51C          ; branch if plus (hi bit 0)
           ldaa BitFlags_4f    ; load a with memory contents
           anda #0xef          ; AND a with value -11101111-
           staa BitFlags_4f    ; store a into memory
           ldab Z83_PortCdata    ; load b with memory contents
           bitb #0x10          ;  -00010000-
           beq  LE519          ; branch if equal (zero)
           ldx  #BRKRPM_BrakeOverrideForAis_FromDeltaThrottle    ; load index with value
           ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           jsr  Lookup4ByteTable    
           cmpb EngineRpm_HB
           bcs  LE51C          ; branch if lower
   LE519:  jmp  LE5A8      

   LE51C:  ldab BitFlags_85    ; load b with memory contents
           bitb #0x20          ;  -00100000-
           bne  LE519          ; branch if not equal (not zero)
           ldaa BitFlags_84    ; load a with memory contents
           anda #0x40          ; AND a with value -01000000-
           oraa Timer_CountdownFromStartRunForAisFeedback    ; OR a with memory contents
           bne  LE4F9          ; branch if not equal (not zero)
           ldaa DesiredNewAisPosition    ; load a with memory contents
           cmpa #0x04          ; compare a with value -00000100-
           bcs  LE534          ; branch if lower
           andb #0xef          ;  -11101111-
           stab BitFlags_85    ; store b into memory
   LE534:  ldaa BitFlags_4f    ; load a with memory contents
           anda #0x10          ; AND a with value -00010000-
           beq  LE565          ; branch if equal (zero)
           ldx  #DRPNK_DriveToParkNeutralKicks_FromTemp    ; load index with value
           bita #0x08          ;  -00001000-
           beq  LE54A          ; branch if equal (zero)
           ldx  #PNDRK_ParkNeutralToDriveKicks_FromTemp    ; load index with value
           ldd  TargetIdleSpeed_HB    ; load d (a&b) with memory contents
           subd EngineRpm_HB    ; d = d - memory contents
           bra  LE54E          ; branch

   LE54A:  ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeed_HB    ; d = d - memory contents
   LE54E:  bcs  LE565          ; branch if lower
           subd PNDLTN_DeltaRpmChangeToUse_DRPNK_or_PNDRK    ;  (data is 00c8)
           bcs  LE565          ; branch if lower
           ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    
           jsr  StoreAndLimitDesiredAisPosition    
           ldaa BitFlags_4f    ; load a with memory contents
           anda #0xef          ; AND a with value -11101111-
           staa BitFlags_4f    ; store a into memory
           bra  LE5A4          ; branch

   LE565:  ldab DCLRF2_TimeBetweenAisPulsesForDecelAis2    ; load b with memory contents (data is 3f)
           cmpb Timer_AisChanges
           bcc  LE5A7          ; branch if greater or equal
           ldaa BitFlags_AIS    ; load a with memory contents
           anda #0xf7          ; AND a with value -11110111-
           staa BitFlags_AIS    ; store a into memory
           ldx  #FWDAIS_ForwardAisSteps_NoSlope    ; load index with value
           ldd  TargetIdleSpeed_HB    ; load d (a&b) with memory contents
           subd EngineRpm_HB    ; d = d - memory contents
           bcc  LE582          ; branch if greater or equal
           ldx  #REVAIS_ReverseAisSteps_NoSlope    ; load index with value
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           subd TargetIdleSpeed_HB    ; d = d - memory contents
   LE582:  lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)

;### changed this code to look at the config flags instead of the whole byte

           tst  CONFIG_ConfigurationFlags
           bpl  LE591 ;branch if bit 7 is NOT set, IE manual trans

;          tst  Manual00_AutomaticFF    ;  (data is 00)
;          beq  LE591          ; branch if equal (zero)

           psha                ; push a onto stack
           ldaa BitFlags_4f    ; load a with memory contents
           bita #0x08          ;  -00001000-
           pula                ; pull a from stack
           bne  LE592          ; branch if not equal (not zero)
   LE591:  lsrd                ; shift right (d=d/2)
   LE592:  tsta                ; test a
           beq  LE597          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   LE597:  tba                 ; a = b
           cmpa 0x01,x         ; compare a with memory at index + value
           bcs  LE5A7          ; branch if lower
           jsr  Lookup4ByteTable    
           beq  LE5A7          ; branch if equal (zero)
           jsr  StoreAndLimitDesiredAisPosition    
   LE5A4:  clra                ; a = 0
           staa Timer_AisChanges    ; store a into memory
   LE5A7:  rts                 ; return from subroutine

   LE5A8:  ldaa BitFlags_AIS    ; load a with memory contents
           oraa #0x08          ;  -00001000-
           staa BitFlags_AIS    ; store a into memory
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #CLDPOS_AisColdPosition_FromTemp    ; load index with value
           jsr  Lookup4ByteTable    
           staa Temp0          ; store a into memory
           ldaa BaroPressure    ; load a with memory contents
           ldx  #BARAIS_AisBaroCompensation    ; load index with value
           jsr  Lookup4ByteTable    
           ldaa Temp0          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           asld                ; shift left (d=d*2)
           bcs  LE63E          ; branch if lower
           asld                ; shift left (d=d*2)
           bcs  LE63E          ; branch if lower
           staa Temp0          ; store a into memory
           ldaa EngineRpm_HB    ; load a with memory contents
           ldx  #RPMPOS_AisPosition_FromRpm    ; load index with value
           jsr  Lookup4ByteTable    
           cmpa Temp0          ; compare a with memory contents
           bcs  LE5D9          ; branch if lower
           staa Temp0          ; store a into memory
   LE5D9:  ldaa TpsVolts       ; load a with memory contents
           suba MINTHR_LowestSessionTPS
           bcc  LE5E0          ; branch if greater or equal
           clra                ; a = 0
   LE5E0:  ldx  #THRPOS_AisPosition_FromThrottle    ; load index with value
           jsr  Lookup4ByteTable    
           cmpa Temp0          ; compare a with memory contents
           bcs  LE5EC          ; branch if lower
           staa Temp0          ; store a into memory
   LE5EC:  clra                ; a = 0
           ldab BitFlags_85    ; load b with memory contents
           bitb #0x04          ;  -00000100-
           bne  LE618          ; branch if not equal (not zero)
           ldaa ACPOS_ACPositionWhenTempToCold    ; load a with memory contents (data is 17)
           bitb #0x20          ;  -00100000-
           bne  LE618          ; branch if not equal (not zero)
           ldab CoolantTemp    ; load b with memory contents
           cmpb ACTMP_AisTempSwap    ; compare b with memory contents (data is a6)
           bcs  LE618          ; branch if lower
           ldx  #ACCTBL_ACOffIdleDelta_FromSpeed    ; load index with value
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    
           ldab BitFlags_85    ; load b with memory contents
           bitb #0x08          ;  -00001000-
           beq  LE618          ; branch if equal (zero)
           ldab OFFPER_AisInstantlyClosesWhenAcDisengages    ; load b with memory contents (data is 80)
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
   LE618:  ldab Temp0          ; load b with memory contents
           aba                 ; a=a+b
           bcs  LE63E          ; branch if lower
           ldab BitFlags_4f    ; load b with memory contents
           bitb #0x08          ;  -00001000-
           bne  LE628          ; branch if not equal (not zero)
           adda PNPOS_ParkNeutralPosition    ;  (data is 00)
           bcs  LE63E          ; branch if lower
   LE628:  ldab BitFlags_AIS    ; load b with memory contents
           bitb #0x10          ;  -00010000-
           bne  LE639          ; branch if not equal (not zero)
           ldab BitFlags_85    ; load b with memory contents
           bitb #0x10          ;  -00010000-
           bne  LE639          ; branch if not equal (not zero)
           adda CALPOS_PositionAisMotorIsAtIdle    ;  (data is 1a)
           bcs  LE63E          ; branch if lower
   LE639:  cmpa AISHLM_AisHighLimitMaxOpenSteps    ; compare a with memory contents (data is dc)
           bcs  LE641          ; branch if lower
   LE63E:  ldaa AISHLM_AisHighLimitMaxOpenSteps    ; load a with memory contents (data is dc)
   LE641:  ldab BitFlags_85    ; load b with memory contents
           bitb #0x20          ;  -00100000-
           beq  LE64D          ; branch if equal (zero)
           andb #0xdf          ;  -11011111-
           stab BitFlags_85    ; store b into memory
           bra  LE65B          ; branch

   LE64D:  cmpa DesiredNewAisPosition    ; compare a with memory contents
           bcc  LE65B          ; branch if greater or equal
           ldab Counter_MainLoop1    ; load b with memory contents
           bitb CALRAT_AisAdjustRate    ;  (data is 0e)
           bne  LE65D          ; branch if not equal (not zero)
           ldaa DesiredNewAisPosition    ; load a with memory contents
           deca                ; decrement a
   LE65B:  staa DesiredNewAisPosition    ; store a into memory
   LE65D:  rts                 ; return from subroutine

   LE65E:  ldab BitFlags_AIS    ; load b with memory contents
           bitb #0x04          ;  -00000100-
           beq  LE681          ; branch if equal (zero)
           andb #0xfb          ;  -11111011-
           stab BitFlags_AIS    ; store b into memory
           ldaa IAISOP_IdleAISOpenStepsNegative    ; load a with memory contents (data is f8)
           ldab BitFlags_85    ; load b with memory contents
           bitb #0x04          ;  -00000100-
           beq  ClearAisTimer    ; branch if equal (zero)
           ldaa ACOFFK_ClosedThrottleAcOffKick    ; load a with memory contents (data is 12)
           ldab Timer_AisOrO2Sensor    ; load b with memory contents
           bne  ClearAisTimer    ; branch if not equal (not zero)
           adda AC2KCK_AcClutchKickOpenAfterAcEnabled    ;  (data is 07)
ClearAisTimer:
           nega                ; negate a (set high bit)
           clrb                ; b = 0
           stab Timer_AisOrO2Sensor    ; store b into memory
           bra  LE685          ; branch

   LE681:  orab #0x0c          ;  -00001100-
           stab BitFlags_AIS    ; store b into memory
   LE685:  ldab #0xff          ; load b with value -11111111-
           stab Temp1          ; store b into memory
StoreAndLimitDesiredAisPosition:
           tsta                ; test a
           bmi  LE699          ; branch if minus(hi bit 1)
           ldab AISHLM_AisHighLimitMaxOpenSteps    ; load b with memory contents (data is dc)
           adda DesiredNewAisPosition
           bcs  LE696          ; branch if lower
           cba             
           bcs  LE69E          ; branch if lower
   LE696:  tba                 ; a = b
           bra  LE69E          ; branch

   LE699:  adda DesiredNewAisPosition
           bcs  LE69E          ; branch if lower
           clra                ; a = 0
   LE69E:  staa DesiredNewAisPosition    ; store a into memory
           rts                 ; return from subroutine

DetermineTargetIdleSpeed_MM:
           ldab BitFlags_4f    ; load b with memory contents
           bitb #0x10          ;  -00010000-
           bne  LE6E7          ; branch if not equal (not zero)
           ldab BitFlags_84    ; load b with memory contents
           bitb #0x04          ;  -00000100-
           beq  LE6B9          ; branch if equal (zero)
           ldaa #0x32          ; load a with value -00110010-
           ldab BitFlags_C9    ; load b with memory contents
           cmpb #0x70          ;  -01110000-
           beq  LE6E1          ; branch if equal (zero)
           ldaa #0xbc          ; load a with value -10111100-
           bra  LE6E1          ; branch

   LE6B9:  ldaa #0x7d          ; load a with value -01111101-
           ldab BitFlags_80    ; load b with memory contents
           bitb #0x02          ;  -00000010-
           bne  LE6E1          ; branch if not equal (not zero)
           ldx  #AISCLD_IdleSpeedDrive_FromTemp    ; load index with value
           ldab Z83_PortCdata    ; load b with memory contents
           bitb #0x08          ;  -00001000-
           bne  LE6CE          ; branch if not equal (not zero)
           ldx  #AISPN_IdleSpeedParkNeutral_FromTemp    ; load index with value
   LE6CE:  ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    
           ldab STTIME_AdditionalStartupIdleTime    ; load b with memory contents (data is 0b)
           cmpb KeyOnOrEngineRunningTime
           bcs  LE6E1          ; branch if lower
           adda DRIDHT_AdditionalStartupIdle    ;  (data is 0d)
           bcc  LE6E1          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LE6E1:  clrb                ; b = 0
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           lsrd                ; shift right (d=d/2)
           std  TargetIdleSpeed_HB    ; store D to RAM
   LE6E7:  rts                 ; return from subroutine

CheckVoltageforAIS:
           ldaa BatteryVolts    ; load a with memory contents
           cmpa BTVAIS_MinVoltageForAis    ; compare a with memory contents (data is 71)
           bcs  LE730          ; branch if lower
MoveAISStepper:
           ldab CurrentAisPosition    ; load b with memory contents
           ldaa BitFlags_AIS    ; load a with memory contents
           bita #0x40          ;  -01000000-
           beq  Operate_AIS_Motor    ; branch if equal (zero)
           ldaa #0xff          ; load a with value -11111111-
           tstb            
           bne  LE711          ; branch if not equal (not zero)
           ldaa BitFlags_AIS    ; load a with memory contents
           anda #0xbf          ; AND a with value -10111111-
           staa BitFlags_AIS    ; store a into memory
           bra  LE730          ; branch

           ;.org 0xE708
Operate_AIS_Motor:
           ldaa #0x01          ; load a with value -00000001-
           cmpb DesiredNewAisPosition
           beq  LE730          ; branch if equal (zero)
           bcs  LE711          ; branch if lower
           nega                ; negate a (set high bit)
   LE711:  staa Temp0          ; store a into memory
           ldx  #AISTEP_BitPatternForAisControl    ; load index with value
           ldab AISMotorBits    ; load b with memory contents
           addb Temp0          ; b=b+memory contents
           andb #0x03          ;  -00000011-
           stab AISMotorBits    ; store b into memory
           abx                 ; add b to index
           ldab CurrentAisPosition    ; load b with memory contents
           addb Temp0          ; b=b+memory contents
           stab CurrentAisPosition    ; store b into memory
           sei                 ; disable interrupts
           ldaa Z83_PortBdata    ; load a with memory contents
           anda #0xf0          ; AND a with value -11110000-
           oraa 0x00,x     
           staa Z83_PortBdata
   LE730:  ldaa CPU_Counter_HB    ; load a with memory contents
           staa Counter_A2DScan2    ; store a into memory
           ldd  #0xff6f        ; load d (a&b) with value -11111111 01101111-
           std  Z83_PortADataDirection
           ldaa Z83_PortBdata    ; load a with memory contents
           staa Temp3          ; store a into memory
           ldaa Z83_CPU_Port1_copy    ; load a with memory contents
           ldab BitFlags_82    ; load b with memory contents
           bitb #0x01          ;  -00000001-
           bne  LE74F          ; branch if not equal (not zero)
           anda #0xfb          ; AND a with value -11111011-
           ldab Z83_PortAdata    ; load b with memory contents
           andb #0x04          ;  -00000100-
           aba                 ; a=a+b
   LE74F:  staa Z83_PortAdata
           clra                ; a = 0
           ldab BatteryVolts    ; load b with memory contents
           cmpb #0xa2          ;  -10100010-
           bhi  LE769          ; branch if higher
           cmpb #0x61          ;  -01100001-
           bcc  LE763          ; branch if greater or equal
           cmpb #0x51          ;  -01010001-
           bcs  LE769          ; branch if lower
           ldab #0x61          ; load b with value -01100001-
   LE763:  ldaa #0x2d          ; load a with value -00101101-
           mul                 ; multiply (d=a*b)
           nega                ; negate a (set high bit)
           adda #0x1d          ;  -00011101-
   LE769:  staa Temp4          ; store a into memory
           clra                ; a = 0
           ldab BatteryVolts    ; load b with memory contents
           cmpb #0xa2          ;  -10100010-
           bcc  LE773          ; branch if greater or equal
           deca                ; decrement a
   LE773:  ldab #0x60          ; load b with value -01100000-
           std  Z83_PortADataDirection
           abx                 ; add b to index
           ldab Temp4          ; load b with memory contents
           ldx  #BriefDelayTable    ; load index with value
           abx                 ; add b to index
           jmp  0x00,x         ; indexed jump

BriefDelayTable:
           nop                 ; no operation
           nop                 ; no operation
           nop                 ; no operation
           nop                 ; no operation
           nop                 ; no operation
           nop                 ; no operation
           nop                 ; no operation
           nop                 ; no operation
           nop                 ; no operation
           nop                 ; no operation
           nop                 ; no operation
           nop                 ; no operation
           ldab Temp3          ; load b with memory contents
           tba                 ; a = b
           eorb Z83_PortBdata
           andb #0x0f          ;  -00001111-
           beq  LE7B5          ; branch if equal (zero)
           cli                 ; enable interrupts
           ldaa BatteryVolts    ; load a with memory contents
           cmpa #0xba          ; compare a with value -10111010-
           bcs  LE806          ; branch if lower
           ldaa #0x15          ; load a with value -00010101-
           jsr  LC94E          
           bra  LE7BD          ; branch

RefLoc302:
           .byte	0x00,0x40,0x00,0x10,0x08,0x04,0x02,0x01
	   .byte	0x0f,0x12,0x11,0x10,0x0e,0x0d,0x0a,0x0c

   LE7B5:  anda #0x6f          ; AND a with value -01101111-
           oraa #0x60          ;  -01100000-
           staa Z83_PortBDataDirection
           cli                 ; enable interrupts
   LE7BD:  ldaa BitFlags_82    ; load a with memory contents
           lsra            
           bcs  LE806          ; branch if lower
           ldx  #RefLoc302     ; load index with value
           ldab Counter_MainLoop1    ; load b with memory contents
           andb #0x07          ;  -00000111-
           abx                 ; add b to index
           sei                 ; disable interrupts
           ldaa BitFlags_7f    ; load a with memory contents
           anda #0x04          ; AND a with value -00000100-
           ldab Z83_CPU_Port1_copy    ; load b with memory contents
           andb #0xfb          ;  -11111011-
           aba                 ; a=a+b
           eora Z83_PortAdata
           cli                 ; enable interrupts
           bita 0x00,x     
           beq  LE806          ; branch if equal (zero)
           ldaa 0x08,x         ; load a with memory at index + value
           cmpa #0x0d          ; compare a with value -00001101-
           bne  LE7F0          ; branch if not equal (not zero)
           jsr  ThrowCriticalError    
           bcc  LE806          ; branch if greater or equal
           ldab #0x10          ; load b with value -00010000-
           sei                 ; disable interrupts
           orab BitFlags_80
           stab BitFlags_80    ; store b into memory
           cli                 ; enable interrupts
           rts                 ; return from subroutine

   LE7F0:  cmpa #0x0e          ; compare a with value -00001110-
           bne  LE803          ; branch if not equal (not zero)
           ldab BitFlags_82    ; load b with memory contents
           bmi  LE806          ; branch if minus(hi bit 1)
           ldab Z83_PortCdata    ; load b with memory contents
           bitb #0x04          ;  -00000100-
           beq  LE806          ; branch if equal (zero)
           ldab KeyOnOrEngineRunningTime    ; load b with memory contents
           beq  LE806          ; branch if equal (zero)
   LE803:  jsr  LC94E          
   LE806:  rts                 ; return from subroutine

        .msg "..." ; these are just messages to display during assemble to let you know what's going on...

ResetRoutine:
           sei                 ; disable interrupts
           ldd  #0xff00        ; load d (a&b) with value -11111111 00000000-
           std  Z83_PortAdata
           ldaa Z85_ADConverter5    ; load a with memory contents (data is 00)
           lds  #0x00ff        ;  -00000000 11111111-
           ldd  #0xbe04        ; load d (a&b) with value -10111110 00000100-
           std  CPU_Port1_DataDirection    ; store D to RAM
           ldd  #0xfd6f        ; load d (a&b) with value -11111101 01101111-
           std  Z83_PortADataDirection
           ldd  #0x0814        ; load d (a&b) with value -00001000 00010100-
           staa CPU_Port1_ControlRegister    ; store a into memory
   LE824:  jsr  ToggleSerialClock_MM    
           decb            
           bne  LE824          ; branch if not equal (not zero)
           ldaa Z85_ADConverter1    ; load a with memory contents (data is 00)
           cmpa #0x0f          ; compare a with value -00001111-
           bls  LE83B          ; branch if lower or same
           cmpa #0x40          ; compare a with value -01000000-
           bcc  LE837          ; branch if greater or equal
           stab CPU_Port1_ControlRegister    ; store b into memory
   LE837:  ldaa CPU_RAM_ControlReg    ; load a with memory contents
           bmi  LE898          ; branch if minus(hi bit 1)
   LE83B:  ldd  #0x150a        ; load d (a&b) with value -00010101 00001010-
           stD  CPU_SCI_ModeControlReg    ; store D to RAM
           ldaa #0x55          ; load a with value -01010101-
           staa CPU_OCR_HB     ; store a into memory
   LE844:  ldd  CPU_SCI_TxRxCntrlReg    ; load d (a&b) with memory contents
           ldaa CPU_OCR_HB     ; load a with memory contents
           staa CPU_SCI_TxDataReg    ; store a into memory
           ldx  #0x01aa        ; load index with value
   LE84D:  cpx  #CPU_TimerControlStatReg    ;  -00000000 00001000-
           bne  LE855          ; branch if not equal (not zero)
           ldab Z85_ADConverter5    ; load b with memory contents (data is 00)
   LE855:  dex                 ; decrement index (x=x-1)
           bne  LE84D          ; branch if not equal (not zero)
           ldab Z85_ADConverter1    ; load b with memory contents (data is 00)
           cmpb #0x40          ;  -01000000-
           bcc  LE862          ; branch if greater or equal
           clr  CPU_Port1_ControlRegister    ; zero byte at memory location
   LE862:  tst  CPU_RAM_ControlReg
           bpl  LE86A          ; branch if plus (hi bit 0)
           tstb            
           bpl  LE898          ; branch if plus (hi bit 0)
   LE86A:  ldab CPU_SCI_TxRxCntrlReg    ; load b with memory contents
           bpl  LE898          ; branch if plus (hi bit 0)
           ldab CPU_SCI_RxDataReg    ; load b with memory contents
           cba             
           bne  LE844          ; branch if not equal (not zero)
           ldx  #CPU_Port1_DataDirection    ; load index with value
           ldab #0xfe          ; load b with value -11111110-
   LE878:  tba                 ; a = b
   LE879:  ldab CPU_SCI_TxRxCntrlReg    ; load b with memory contents
           bpl  LE879          ; branch if plus (hi bit 0)
           ldab CPU_SCI_RxDataReg    ; load b with memory contents
           stab CPU_SCI_TxDataReg    ; store b into memory
           cmpa #0xfe          ; compare a with value -11111110-
           bne  LE88A          ; branch if not equal (not zero)
           abx                 ; add b to index
           stx  CPU_OCR_HB     ; store index into memory
           inca                ; increment a
           tab                 ; b = a
   LE88A:  cmpa #0xff          ; compare a with value -11111111-
           beq  LE878          ; branch if equal (zero)
           stab 0x00,x     
           inx                 ; increment index (x=x+1)
           deca                ; decrement a
           bne  LE879          ; branch if not equal (not zero)
           ldx  CPU_OCR_HB 
           jmp  0x00,x         ; indexed jump

   LE898:  ldaa #0x40          ; load a with value -01000000-
           staa BitFlags_AIS    ; store a into memory
           ldx  #BitFlags_AIS    ; load index with value
           ldaa MINTHR_LowestSessionTPS    ; load a with memory contents
           cmpa LowestHistoricalTPS    ; compare a with memory contents
           bne  LE8A9          ; branch if not equal (not zero)
           ldaa CPU_RAM_ControlReg    ; load a with memory contents
           bmi  LE8BD          ; branch if minus(hi bit 1)
   LE8A9:  ldaa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load a with memory contents (data is 5c)
           ldab #0x80          ; load b with value -10000000-
           std  MINTHR_LowestSessionTPS    ; store D to RAM
           staa LowestHistoricalTPS    ; store a into memory
           stab DCCOR1_AdaptiveWastegateCellBelowMAPPT    ; store b into memory
           stab DCCOR2_AdaptiveWastegateCellAboveMAPPT    ; store b into memory
           ldaa #0xdf          ; load a with value -11011111-
           staa CurrentAisPosition    ; store a into memory
           ldx  #LowestHistoricalTPS    ; load index with value
   LE8BD:  jsr  ToggleSerialClock_MM    
           clrb                ; b = 0
   LE8C1:  inx                 ; increment index (x=x+1)
           stab 0x00,x     
           cpx  #0x00ff        ;  -00000000 11111111-
           bne  LE8C1          ; branch if not equal (not zero)
           stab Z83_PortCDataDirection    ; store b into memory
           ldaa CPU_RAM_ControlReg    ; load a with memory contents
           bmi  LE8D6          ; branch if minus(hi bit 1)
           ldaa ErrorBitRegisterStored3    ; load a with memory contents
           oraa #0xc0          ;  -11000000-
           staa ErrorBitRegisterStored3    ; store a into memory
   LE8D6:  ldaa #0xc0          ; load a with value -11000000-
           staa CPU_RAM_ControlReg    ; store a into memory
           ldaa BitFlags_AIS    ; load a with memory contents
           eora #0x40          ; XOR a with value -01000000-
           staa BitFlags_AIS    ; store a into memory
           stab Z83_PortAcontrol    ; store b into memory
           stab Z83_PortBcontrol    ; store b into memory
           stab Z83_PortCcontrol    ; store b into memory
           ldab AISMotorBits    ; load b with memory contents
           ldx  #AISTEP_BitPatternForAisControl    ; load index with value
           abx                 ; add b to index
           ldaa 0x00,x         ; load a with memory at index + value
           staa Z83_PortBdata
           ldaa BitFlags_4f    ; load a with memory contents
           oraa #0x80          ;  -10000000-
           anda #0x83          ; AND a with value -10000011-
           ldab Z83_PortAdata    ; load b with memory contents
           bitb #0x02          ;  -00000010-
           bne  LE903          ; branch if not equal (not zero)
           oraa #0x04          ;  -00000100-
   LE903:  staa BitFlags_4f    ; store a into memory
           ldab #0xff          ; load b with value -11111111-
           stab Z83_PortADataDirection    ; store b into memory
           stab Z83_CPU_Port1_copy    ; store b into memory
           jsr  ToggleSerialClock_MM    
           jsr  VerifyOperationOfMapSensor_MM    
           staa BaroPressure    ; store a into memory
           staa MapValue       ; store a into memory
           staa MapVolts       ; store a into memory
           staa AverageMAPValue    ; store a into memory
           staa StackPtrTemp_HB    ; store a into memory
           ldd  #0x408a        ; load d (a&b) with value -01000000 10001010-
           staa Cylinder2Retard    ; store a into memory
           stab BitFlags_82    ; store b into memory
           ldd  #0x10e9        ; load d (a&b) with value -00010000 11101001-
           staa BitFlags_84    ; store a into memory
           stab CPU_TimerControl1    ; store b into memory
           ldd  CPU_Counter_HB    ; load d (a&b) with memory contents
           addd #CPU_PortX_ControlStatReg    ;  -00000000 00001111-
           std  CPU_OCR_HB     ; store D to RAM
           std  CPU_OCR2_HB    ; store D to RAM
           stD CPU_OCR3_HB    ; store D to RAM
           ldd  #0xf3f6        ; load d (a&b) with value -11110011 11110110-
           staa CPU_TimerControl2    ; store a into memory
           stab CPU_Port2_DataDirection    ; store b into memory
           ldaa BitFlags_4f    ; load a with memory contents
           tab                 ; b = a
           andb #0x03          ;  -00000011-
           cmpb #0x02          ;  -00000010-
           bne  LE948          ; branch if not equal (not zero)
           jmp  ResetStartup

   LE948:  inca                ; increment a
           staa BitFlags_4f    ; store a into memory
   LE94B:  ldaa Z85_ADConverter2    ; load a with memory contents (data is 00)
           ldd  #0xe2a2        ; load d (a&b) with value -11100010 10100010-
           staa Z22_Timer6840_1
           stab Z22_Timer6840    ; store b into memory
           inca                ; increment a
           staa Z22_Timer6840_1
           stab Z22_Timer6840    ; store b into memory
           ldd  #0x04ff        ; load d (a&b) with value -00000100 11111111-
           staa BitFlags_81    ; store a into memory
           staa Timer_DelayBeforeUpdating_MINTHR    ; store a into memory
           ldaa #0x80          ; load a with value -10000000-
           staa BitFlags_80    ; store a into memory
           ldaa BitFlags_85    ; load a with memory contents
           oraa #0x04          ;  -00000100-
           staa BitFlags_85    ; store a into memory
           ldaa BitFlags_83    ; load a with memory contents
           oraa #0x02          ;  -00000010-
           staa BitFlags_83    ; store a into memory
           stab Counter_TimerPastHalfwayBetweenDistPulses    ; store b into memory
           stab TimerOverflowsBetweenDistPulses    ; store b into memory
           stab Factor_ACVDCY_CurveACurveCDecayAfterRunModeReached    ; store b into memory
           stab Timer_Over5PSIBoost    ; store b into memory
           stab BoostTarget    ; store b into memory
;           stab AntiLagRetard    ; store b into memory
   LE981:  decb            
           bne  LE981          ; branch if not equal (not zero)
           ldaa Z85_ADConverterCoolantTemp    ; load a with memory contents (data is 00)
           staa AmbientAirTempVolts    ; store a into memory
   LE989:  decb            
           bne  LE989          ; branch if not equal (not zero)
           ldaa Z85_ADConverter4    ; load a with memory contents (data is 00)
           staa TpsVolts       ; store a into memory
           staa AverageTPSVolts    ; store a into memory
           ldab MINTHR_LowestSessionTPS    ; load b with memory contents
           addb MININC_Amount_MINTHR_IsIncreasedAtKeyOnOnly    ;  (data is 03)
           cmpb MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; compare b with memory contents (data is 5c)
           bcs  LE9A6          ; branch if lower
           adda #0x06          ;  -00000110-
           ldab MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load b with memory contents (data is 5c)
           cba             
           bcc  LE9A6          ; branch if greater or equal
           tab                 ; b = a
   LE9A6:  stab MINTHR_LowestSessionTPS    ; store b into memory
           stab LowestHistoricalTPS    ; store b into memory
           clrb                ; b = 0
   LE9AB:  decb            
           bne  LE9AB          ; branch if not equal (not zero)
           ldaa Z85_ADConverter5    ; load a with memory contents (data is 00)
           staa ChargeTempVolts    ; store a into memory
           ldab #0x19          ; load b with value -00011001-
   LE9B5:  decb            
           bne  LE9B5          ; branch if not equal (not zero)
           ldaa Z85_ADConverterCoolantTemp    ; load a with memory contents (data is 00)
           staa LastCoolantTempVolts    ; store a into memory
           ldx  #TMPTL1_TempForColdScaleFromA2D    ; load index with value
           ldab CPU_Port1_ControlRegister    ; load b with memory contents
           bitb #0x08          ;  -00001000-
           bne  LE9C9          ; branch if not equal (not zero)
           ldx  #TMPTL2_TempForHotScaleA2D    ; load index with value
   LE9C9:  jsr  Lookup4ByteTable    
           staa CoolantTemp    ; store a into memory
           cmpa #0xa6          ; compare a with value -10100110-
           bcc  LE9DC          ; branch if greater or equal
           ldab AmbientAirTempVolts    ; load b with memory contents
           cmpb #0x99          ;  -10011001-
           bcs  LE9DC          ; branch if lower
           ldab #0x40          ; load b with value -01000000-
           stab Timer_RadSteamingCountdown    ; store b into memory
   LE9DC:  ldaa CoolantTemp    ; load a with memory contents
           cmpa TTEMPL_TstatDiagnosticsMinTempToArmDiagnosticsAtStartup    ; compare a with memory contents (data is 63)
           bcs  LE9EB          ; branch if lower
           cmpa TTEMPH_TstatDiagnosticsMaxTempToArmDiagnosticsAtStartup    ; compare a with memory contents (data is e4)
           bcc  LE9EB          ; branch if greater or equal
           inc  Timer_ThermostatDiagnostics
   LE9EB:  jsr  LC74C          
           ldd  #0x060a        ; load d (a&b) with value -00000110 00001010-
           stD  CPU_SCI_ModeControlReg    ; store D to RAM
           ldd  #0x13bd        ; load d (a&b) with value -00010011 10111101-
           staa CPU_TimerControlStatReg    ; store a into memory
           stab Z83_PortAdata    ; store b into memory
           stab Z83_CPU_Port1_copy    ; store b into memory
           ldaa CPU_Port1_ControlRegister    ; load a with memory contents
           oraa #0x20          ;  -00100000-
           staa CPU_Port1_ControlRegister    ; store a into memory
           jsr  ToggleSerialClock_MM    
           ldx  #0x091e        ; load index with value
   LEA09:  dex                 ; decrement index (x=x-1)
           bne  LEA09          ; branch if not equal (not zero)
           jsr  ToggleSerialClock_MM    
           ldx  #PRSHOT_KeyOnPrimePW    ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           jsr  Lookup4ByteTable    
           ldab #0xfa          ; load b with value -11111010-
           mul                 ; multiply (d=a*b)
           std  InjectorPulsewidth_HB    ; store D to RAM
           ldaa #0x06          ; load a with value -00000110-
           oraa CPU_TimerControl1    ; OR a with memory contents
           jsr  LE025          
           ldaa #0xfd          ; load a with value -11111101-
           staa Temp7          ; store a into memory
           ldx  #CPU_OCR2_HB    ; load index with value
           jsr  LE0FB          
           ldaa #0xfb          ; load a with value -11111011-
           staa Temp7          ; store a into memory
           ldx  #CPU_OCR3_HB    ; load index with value
           jsr  LE0FB          
           ldaa CPU_TimerStatus    ; load a with memory contents
           staa CPU_OCR_HB     ; store a into memory
           ldaa CPU_ICR_HB     ; load a with memory contents
           ldaa CPU_ICR2_HB    ; load a with memory contents
           ldab CPU_Counter_HB    ; load b with memory contents
           jmp  LEB66      

        .msg "..." ; these are just messages to display during assemble to let you know what's going on...

ElevenMillisecondLoop:
           jsr  DRB_SendROMSerial_MM    
           jsr  DetermineIfWindowedBladeInSyncSensorOnDistributor_MM    
           jsr  Throttle_MM    
           jsr  ControlCruiseServo1_MM    
           jsr  A2DScan_MM     
           jsr  ToggleSerialClock_MM    
           jsr  ControlCruiseServo0_MM    
           ldaa Counter_MainLoop1    ; load a with memory contents
           lsra            
           bcc  First44msLoop    ; branch if greater or equal
           jmp  TwentyTwoMillisecondLoop

First44msLoop:
           lsra            
           bcc  Second44msLoop    ; branch if greater or equal
           jsr  CheckAndFilterCoolantTempSensor_MM    
           jsr  A2DScan_MM     
           jsr  CheckAndFilterChargeTempSensor_MM    
           jsr  A2DScan_MM     
           jsr  CalculateSparkAdvance_MM    
           jsr  A2DScan_MM     
           jsr  CalculateSumOfAllFuelModifiers_MM    
           jsr  A2DScan_MM     
           jsr  ModifyO2FeedbackCountVarToMaintainStoich_MM    
           jsr  A2DScan_MM     
           jsr  DetermineTargetBatteryVoltage_MM    
           jsr  VerifyOperationOfThermostat_MM    
           jsr  A2DScan_MM     
           jsr  VerifyOperationOfBatteryVoltage_MM    
           jsr  CalculateInjectorPulsewidthForStarting_MM    
           jsr  A2DScan_MM     
           jsr  MM_L1597       
           jmp  BackTo11msLoop

Second44msLoop:
           jsr  A2DScan_MM     
           jsr  HandleBaroReadRequirement_MM    
           jsr  HandleAmTimer_MM    
           jsr  CalculatePTEFactors_MM    
           jsr  A2DScan_MM
           jsr  HandleO2Processing_MM    
           jsr  VerifyOperationOfO2SensorAnd    
           jsr  DealWithColdLoadEnrichment_MM    
           jsr  A2DScan_MM     
           jsr  IncrementSlowCounter_MM    
           jsr  DetermineFuelTweaks_MM    
           jsr  A2DScan_MM     
           jsr  DetermineTargetIdleSpeed_MM    
           jsr  ConfirmO2GoodAndAdjustKnockRetard_MM    
           jsr  KnockDetect_MM    
           jsr  CalculateAntiLagRetard_Routine_MM
           jsr  ControlFan2_MM    
           jsr  A2DScan_MM     
           jsr  ControlAsdRelay_MM
           jsr  ControlPurgeSolenoid_MM    
           jsr  ControlShiftLight_Routine_MM
           ;jsr  AlkyPump_Control_MM
           ;jsr  AlkyInjector_Control_MM
           jsr  AdaptiveMemory_DetermineWhichCellApplies_MM
           jsr  A2DScan_MM     
           jsr  SetMapErrorCode_MM    
           jsr  WorkWithPowerLossLight_MM    
           jsr  A2DScan_MM     
           jsr  UseCELForKnockIndication_MM
           jsr  CalcTargetBoost_MM
           jsr  ControlAirConditioning_MM    
           jsr  SetFlagForPTE_MM    
           jsr  LEE3A          
           bra  BackTo11msLoop    ; branch

TwentyTwoMillisecondLoop:
           jsr  KickUpAisBy2DuringDecel_MM    
           jsr  A2DScan_MM     
           jsr  CalculateTargetIdleSpeedAndAisPosition_MM    
           jsr  CalculateAisPosition_MM    
           jsr  A2DScan_MM     
           jsr  SetAISFlags_MM    
           jsr  CalculateTransientFuelAddition_MM
           jsr  A2DScan_MM     
           jsr  MM_LD24E       
           jsr  CalculateEngineRpm_MM    
           std  EngineRpm_HB    ; store D to RAM
           jsr  A2DScan_MM     
           jsr  ControlEngineCutout_MM    
           jsr  A2DScan_MM     
           jsr  CheckThrottleRoutine_MM    
           jsr  SetTPSFlags_MM    
           sei                 ; disable interrupts
           ldd  CPU_Counter_HB    ; load d (a&b) with memory contents
           jsr  DetermineNumberOfOverflowsBetweenDistributorPulses_MM    
           cli                 ; enable interrupts
           jsr  A2DScan_MM     
           jsr  CalcWGDutyCycle_MM          
           jsr  A2DScan_MM     
           sei                 ; disable interrupts
           ldd  CPU_Counter_HB    ; load d (a&b) with memory contents
           jsr  DetermineNumberOfOverflowsBetweenSpeedoPulses_MM    
           cli                 ; enable interrupts
BackTo11msLoop:
           jsr  A2DScan_MM     
           jsr  IncrementLoopCounters_MM    
           ldaa MinimumTimerCountBeforeMainloopCanContinue    ; load a with memory contents
           suba #0x15          ;  -00010101-
   LEB40:  cmpa CPU_Counter_HB    ; compare a with memory contents
           bpl  LEB40          ; branch if plus (hi bit 0)
           jsr  A2DScan_MM     
           ldaa MinimumTimerCountBeforeMainloopCanContinue    ; load a with memory contents
           suba #0x10          ;  -00010000-
   LEB4B:  cmpa CPU_Counter_HB    ; compare a with memory contents
           bpl  LEB4B          ; branch if plus (hi bit 0)
           jsr  A2DScan_MM     
           ldaa MinimumTimerCountBeforeMainloopCanContinue    ; load a with memory contents
           suba #0x08          ;  -00001000-
   LEB56:  cmpa CPU_Counter_HB    ; compare a with memory contents
           bpl  LEB56          ; branch if plus (hi bit 0)
           jsr  A2DScan_MM     
           sei                 ; disable interrupts
           ldaa MinimumTimerCountBeforeMainloopCanContinue    ; load a with memory contents
           ldab CPU_Counter_HB    ; load b with memory contents
           cba             
           bmi  LEB66          ; branch if minus(hi bit 1)
           tab                 ; b = a
   LEB66:  addb #0x2b          ;  -00101011-
           stab MinimumTimerCountBeforeMainloopCanContinue    ; store b into memory
           cli                 ; enable interrupts
   LEB6B:  cmpa CPU_Counter_HB    ; compare a with memory contents
           bpl  LEB6B          ; branch if plus (hi bit 0)
           jmp  ElevenMillisecondLoop

HandleOtherTimerInterrupts:
           ldd  #0x4268        ; load d (a&b) with value -01000010 01101000-
           addd CPU_OCR3_HB    ; d = d + memory contents
           stD CPU_OCR3_HB    ; store D to RAM
           jsr  ToggleSerialClock_MM    
           cli                 ; enable interrupts
           ldx  DwellTime_HB
           inx                 ; increment index (x=x+1)
           beq  LEB8C          ; branch if equal (zero)
           stx  DwellTime_HB    ; store index into memory
           ldaa Z83_PortBdata    ; load a with memory contents
           eora #0x60          ; XOR a with value -01100000-
           staa Z83_PortBdata
   LEB8C:  ldab #0xff          ; load b with value -11111111-
           stab Z83_CPU_Port1_copy    ; store b into memory
           ldaa Counter_ErrorCodeFlasher    ; load a with memory contents
           bmi  LEB9A          ; branch if minus(hi bit 1)
           ldaa CPU_Port1_ControlRegister    ; load a with memory contents
           anda #0xef          ; AND a with value -11101111-
           staa CPU_Port1_ControlRegister    ; store a into memory
   LEB9A:  cpx  #0x003f        ;  -00000000 00111111-
           bcs  LEC18          ; branch if lower
           cpx  #Timer_CLTIME_ClosedLoopTimer    ;  -00000000 10110000-
           bne  LEBAA          ; branch if not equal (not zero)
           ldab #0xdf          ; load b with value -11011111-
           andb CPU_Port1_ControlRegister
           stab CPU_Port1_ControlRegister    ; store b into memory
   LEBAA:  ldaa Counter_ErrorCodeFlasher    ; load a with memory contents
           cmpa #0x03          ; compare a with value -00000011-
           bne  LEBD6          ; branch if not equal (not zero)
           ldd  CPU_SCI_TxRxCntrlReg    ; load d (a&b) with memory contents
           bpl  LEBB8          ; branch if plus (hi bit 0)
           cmpb #0xf0          ;  -11110000-
           beq  LEBD5          ; branch if equal (zero)
   LEBB8:  ldaa BitFlags_81    ; load a with memory contents
           bmi  LEBD5          ; branch if minus(hi bit 1)
           ldx  Temp5      
           ldab 0x00,x         ; load b with memory at index + value
           stab CPU_SCI_TxDataReg    ; store b into memory
           cmpb #0x55          ;  -01010101-
           bne  LEBD2          ; branch if not equal (not zero)
           oraa #0x80          ;  -10000000-
           ldab Z83_PortCdata    ; load b with memory contents
           andb #0x9c          ;  -10011100-
           stab Temp2          ; store b into memory
           staa BitFlags_81    ; store a into memory
           rts                 ; return from subroutine

   LEBD2:  inx                 ; increment index (x=x+1)
           stx  Temp5          ; store index into memory
   LEBD5:  rts                 ; return from subroutine

   LEBD6:  ldab BitFlags_4f    ; load b with memory contents
           andb #0x04          ;  -00000100-
           bne  LEC18          ; branch if not equal (not zero)
           ldab BitFlags_81    ; load b with memory contents
           bpl  LEC18          ; branch if plus (hi bit 0)
           bita #0x3f          ;  -00111111-
           bne  LEC14          ; branch if not equal (not zero)
           ldab Z83_PortAdata    ; load b with memory contents
           orab #0x02          ;  -00000010-
           stab Z83_PortAdata    ; store b into memory
           ldab #0xff          ; load b with value -11111111-
           stab Z83_PortADataDirection    ; store b into memory
           ldab #0x08          ; load b with value -00001000-
   LEBF3:  decb            
           bne  LEBF3          ; branch if not equal (not zero)
           stab Z83_PortADataDirection    ; store b into memory
           ldab #0x08          ; load b with value -00001000-
   LEBFB:  decb            
           bne  LEBFB          ; branch if not equal (not zero)
           ldab Z83_PortAdata    ; load b with memory contents
           bitb #0x02          ;  -00000010-
           bne  LEC14          ; branch if not equal (not zero)
           ldaa BitFlags_C9    ; load a with memory contents
           inca                ; increment a
           cmpa #0x0c          ; compare a with value -00001100-
           bcs  LEC0E          ; branch if lower
           ldaa #0x01          ; load a with value -00000001-
   LEC0E:  staa BitFlags_C9    ; store a into memory
           ldab #0x02          ; load b with value -00000010-
           stab DwellTime_HB    ; store b into memory
   LEC14:  ldaa BitFlags_C9    ; load a with memory contents
           bne  LEC4A          ; branch if not equal (not zero)
   LEC18:  jsr  MoveAISStepper    
           ldaa BitFlags_81    ; load a with memory contents
           bpl  LEC49          ; branch if plus (hi bit 0)
           ldab Counter_ErrorCodeFlasher    ; load b with memory contents
           bitb #0x07          ;  -00000111-
           bne  LEC49          ; branch if not equal (not zero)
           ldaa Z83_PortCdata    ; load a with memory contents
           anda #0x9c          ; AND a with value -10011100-
           cmpa Temp2          ; compare a with memory contents
           beq  LEC49          ; branch if equal (zero)
           staa Temp2          ; store a into memory
           cmpa CPU_SCI_TxRxCntrlReg    ; compare a with memory contents
           clra                ; a = 0
           tst  PTEPWOver32
           bne  LEC3A          ; branch if not equal (not zero)
           ldaa #0x88          ; load a with value -10001000-
   LEC3A:  staa CPU_SCI_TxDataReg    ; store a into memory
           staa PTEPWOver32    ; store a into memory
           ldaa BitFlags_81    ; load a with memory contents
           lsla                ; logical shift left a
           bpl  LEC49          ; branch if plus (hi bit 0)
           ldaa #0x20          ; load a with value -00100000-
           eora CPU_Port1_ControlRegister
           staa CPU_Port1_ControlRegister    ; store a into memory
   LEC49:  rts                 ; return from subroutine

   LEC4A:  ldab #0xdf          ; load b with value -11011111-
           andb CPU_Port1_ControlRegister
           stab CPU_Port1_ControlRegister    ; store b into memory
           ldab BitFlags_81    ; load b with memory contents
           orab #0x20          ;  -00100000-
           stab BitFlags_81    ; store b into memory
           cpx  #0x4b00        ;  -01001011 00000000-
           bcc  LEC18          ; branch if greater or equal
           ldab CPU_SCI_TxRxCntrlReg    ; load b with memory contents
           bitb #0xc0          ;  -11000000-
           beq  LEC6A          ; branch if equal (zero)
           ldab CPU_SCI_RxDataReg    ; load b with memory contents
           cmpb #0xf0          ;  -11110000-
           bne  LEC6A          ; branch if not equal (not zero)
           jmp  LED36      

   LEC6A:  tab                 ; b = a
           cmpb #0x0a          ;  -00001010-
           bcs  LEC76          ; branch if lower
           ldaa #0x10          ; load a with value -00010000-
           cmpb #0x0b          ;  -00001011-
           bne  LEC76          ; branch if not equal (not zero)
           inca                ; increment a
   LEC76:  staa CPU_SCI_TxDataReg    ; store a into memory
           tba                 ; a = b
           ldab #0xfd          ; load b with value -11111101-
           cmpa #0x06          ; compare a with value -00000110-
           beq  LECF4          ; branch if equal (zero)
           cmpa #0x02          ; compare a with value -00000010-
           bhi  LEC87          ; branch if higher
           andb Z83_CPU_Port1_copy
           stab Z83_CPU_Port1_copy    ; store b into memory
   LEC87:  ldab Counter_ErrorCodeFlasher    ; load b with memory contents
           cmpa #0x03          ; compare a with value -00000011-
           beq  LED09          ; branch if equal (zero)
           cmpa #0x04          ; compare a with value -00000100-
           beq  LED02          ; branch if equal (zero)
           ldab #0xef          ; load b with value -11101111-
           cmpa #0x05          ; compare a with value -00000101-
           beq  LECF4          ; branch if equal (zero)
           ldab #0xbf          ; load b with value -10111111-
           cmpa #0x07          ; compare a with value -00000111-
           beq  LECF4          ; branch if equal (zero)
           ldab #0x5f          ; load b with value -01011111-
           cmpa #0x08          ; compare a with value -00001000-
           beq  LECF4          ; branch if equal (zero)
           ldab #0xfb          ; load b with value -11111011-
           cmpa #0x09          ; compare a with value -00001001-
           beq  LECF4          ; branch if equal (zero)
           ldab #0xfe          ; load b with value -11111110-
           cmpa #0x0a          ; compare a with value -00001010-
           beq  LECF4          ; branch if equal (zero)
           cmpa #0x0b          ; compare a with value -00001011-
           bne  LECC0          ; branch if not equal (not zero)
           ldaa Counter_ErrorCodeFlasher    ; load a with memory contents
           bpl  LED33          ; branch if plus (hi bit 0)
           ldaa CPU_Port1_ControlRegister    ; load a with memory contents
           oraa #0x10          ;  -00010000-
           staa CPU_Port1_ControlRegister    ; store a into memory
           jmp  MoveAISStepper

   LECC0:  ldab Counter_ErrorCodeFlasher    ; load b with memory contents
           lslb            
           bne  LED33          ; branch if not equal (not zero)
           cmpa #0x01          ; compare a with value -00000001-
           beq  LED1B          ; branch if equal (zero)
           ldaa #0x02          ; load a with value -00000010-
           oraa CPU_TimerControl1    ; OR a with memory contents
           staa CPU_TimerControl1    ; store a into memory
           ldd  CPU_Counter_HB    ; load d (a&b) with memory contents
           addd #CPU_Counter_LB    ;  -00000000 00001010-
           std  CPU_OCR2_HB    ; store D to RAM
           ldaa CPU_Port1_ControlRegister    ; load a with memory contents
           oraa #0x04          ;  -00000100-
           staa CPU_Port1_ControlRegister    ; store a into memory
           ldaa CPU_TimerStatus    ; load a with memory contents
           ldd  CPU_OCR2_HB    ; load d (a&b) with memory contents
           std  CPU_OCR2_HB    ; store D to RAM
           ldd  CPU_TimerControl1    ; load d (a&b) with memory contents
           anda #0xfd          ; AND a with value -11111101-
           orab #0x10          ;  -00010000-
           stD CPU_TimerControl1    ; store D to RAM
           ldd  DFTOC2_SomeKindOfDefaultValueForOCR2    ;  (data is 07d0)
           addd CPU_OCR2_HB    ; d = d + memory contents
           std  CPU_OCR2_HB    ; store D to RAM
           jmp  MoveAISStepper

   LECF4:  clra                ; a = 0
           staa Cylinder1Retard    ; store a into memory
           ldaa Counter_ErrorCodeFlasher    ; load a with memory contents
           bmi  LED33          ; branch if minus(hi bit 1)
   LECFB:  andb Z83_CPU_Port1_copy
           stab Z83_CPU_Port1_copy    ; store b into memory
           jmp  MoveAISStepper

   LED02:  lslb            
           bne  LED33          ; branch if not equal (not zero)
           ldab #0xf7          ; load b with value -11110111-
           bra  LECFB          ; branch

   LED09:  ldaa #0x20          ; load a with value -00100000-
           cmpb #0x20          ;  -00100000-
           beq  LED2F          ; branch if equal (zero)
           cmpb #0x45          ;  -01000101-
           beq  LED2E          ; branch if equal (zero)
           jmp  MoveAISStepper

   LED16:  addd #CPU_PortX_ControlStatReg    ;  -00000000 00001111-
           std  CPU_OCR_HB     ; store D to RAM
   LED1B:  ldaa CPU_TimerControlStatReg    ; load a with memory contents
           eora #0x01          ; XOR a with value -00000001-
           staa CPU_TimerControlStatReg    ; store a into memory
           lsra            
           ldd  CPU_Counter_HB    ; load d (a&b) with memory contents
           bcc  LED16          ; branch if greater or equal
           addd #0x1b60        ;  -00011011 01100000-
           std  CPU_OCR_HB     ; store D to RAM
           jmp  MoveAISStepper

   LED2E:  nega                ; negate a (set high bit)
   LED2F:  adda CurrentAisPosition
           staa DesiredNewAisPosition    ; store a into memory
   LED33:  jmp  MoveAISStepper

   LED36:  tab                 ; b = a
           cmpa #0x09          ; compare a with value -00001001-
           bne  LED5B          ; branch if not equal (not zero)
           ldab #0xff          ; load b with value -11111111-
           ldaa Z83_PortCdata    ; load a with memory contents
           anda #0x43          ; AND a with value -01000011-
           bita #0x40          ;  -01000000-
           beq  LED56          ; branch if equal (zero)
           clrb                ; b = 0
           cmpa #0x41          ; compare a with value -01000001-
           beq  LED56          ; branch if equal (zero)
           incb            
           cmpa #0x43          ; compare a with value -01000011-
           beq  LED56          ; branch if equal (zero)
           cmpa #0x40          ; compare a with value -01000000-
           beq  LED33          ; branch if equal (zero)
           ldab #0x10          ; load b with value -00010000-
   LED56:  stab CPU_SCI_TxDataReg    ; store b into memory
           jmp  MoveAISStepper

   LED5B:  cmpa #0x08          ; compare a with value -00001000-
           bcs  LED66          ; branch if lower
           ldab #0xff          ; load b with value -11111111-
           cmpa #0x08          ; compare a with value -00001000-
           bhi  LED56          ; branch if higher
           clrb                ; b = 0
   LED66:  ldx  #Z85_ADConverter1    ; load index with value
           abx                 ; add b to index
           ldaa 0x00,x         ; load a with memory at index + value
           cmpb #0x04          ;  -00000100-
           bne  LED80          ; branch if not equal (not zero)
           clr  CoolantTemp    ; zero byte at memory location
           jsr  GetCoolantTempQuick    
           ldab #0x2e          ; load b with value -00101110-
           mul                 ; multiply (d=a*b)
           adca #0xec          ;  -11101100-
           bcs  LEDBD          ; branch if lower
           clra                ; a = 0
           bra  LEDBD          ; branch

   LED80:  cmpb #0x07          ;  -00000111-
           bne  LED91          ; branch if not equal (not zero)
           ldab #0xfd          ; load b with value -11111101-
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           lsra            
           lsra            
           lsra            
           lsra            
           adca #0x00          ;  -00000000-
           bra  LEDBD          ; branch

   LED91:  cmpb #0x06          ;  -00000110-
           bne  LEDB5          ; branch if not equal (not zero)
           ldab Cylinder1Retard    ; load b with memory contents
           bne  LED9D          ; branch if not equal (not zero)
           incb            
           stab Cylinder1Retard    ; store b into memory
           tba                 ; a = b
   LED9D:  ldab #0x12          ; load b with value -00010010-
   LED9F:  decb            
           bne  LED9F          ; branch if not equal (not zero)
           ldab CPU_Port1_ControlRegister    ; load b with memory contents
           orab #0x80          ;  -10000000-
           stab CPU_Port1_ControlRegister    ; store b into memory
           andb #0x7f          ;  -01111111-
           stab CPU_Port1_ControlRegister    ; store b into memory
           ldab Cylinder1Retard    ; load b with memory contents
           cba             
           bcc  LEDB2          ; branch if greater or equal
           tba                 ; a = b
   LEDB2:  tab                 ; b = a
           bra  LEDB6          ; branch

   LEDB5:  clrb                ; b = 0
   LEDB6:  stab Cylinder1Retard    ; store b into memory
           ldab #0x32          ; load b with value -00110010-
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
   LEDBD:  staa Temp5          ; store a into memory
           ldd  #0x199a        ; load d (a&b) with value -00011001 10011010-
           jsr  mul16bit       
           ldab #0x06          ; load b with value -00000110-
           mul                 ; multiply (d=a*b)
           addb Temp5          ; b=b+memory contents
           bra  LED56          ; branch

ADTableOffsets83:
           .byte  0x05,0x07,0x04,0x07
           .byte  0x01,0x07,0x02,0x07
           .byte  0x03,0x07,0x07,0x07

ADLookup:
           ldx  #ADTableOffsets83    ; load index with value
           abx                 ; add b to index
           ldab 0x00,x         ; load b with memory at index + value
           ldx  #Z85_ADConverter1    ; load index with value
           abx                 ; add b to index
           tab                 ; b = a
           ldaa 0x00,x         ; load a with memory at index + value
           rts                 ; return from subroutine

        .msg "..." ; these are just messages to display during assemble to let you know what's going on...

A2DScan_MM:
           ldaa Timer_NavigatorFuelPulsewidth    ; load a with memory contents
           adda #0x08          ;  -00001000-
           cmpa CPU_Counter_HB    ; compare a with memory contents
           bpl  LEDF9          ; branch if plus (hi bit 0)
           sei                 ; disable interrupts
           ldd  Timer_FuelMonitorOutputTimer_HB    ; load d (a&b) with memory contents
           subd FUELTR_FuelMonitorConversionFactor    ;  (data is 0311)
           bcs  LEDF4          ; branch if lower
           std  Timer_FuelMonitorOutputTimer_HB    ; store D to RAM
           ldaa Z83_PortBdata    ; load a with memory contents
           eora #0x40          ; XOR a with value -01000000-
           staa Z83_PortBdata
   LEDF4:  cli                 ; enable interrupts
           ldaa CPU_Counter_HB    ; load a with memory contents
           staa Timer_NavigatorFuelPulsewidth    ; store a into memory
   LEDF9:  ldaa #0x0f          ; load a with value -00001111-
           ldab BitFlags_AIS    ; load b with memory contents
           bitb #0x40          ;  -01000000-
           bne  LEE09          ; branch if not equal (not zero)
           ldaa #0x1e          ; load a with value -00011110-
           bitb #0x20          ;  -00100000-
           beq  LEE09          ; branch if equal (zero)
           ldaa #0x1e          ; load a with value -00011110-
   LEE09:  adda Counter_A2DScan2
           cmpa CPU_Counter_HB    ; compare a with memory contents
           bpl  LEE12          ; branch if plus (hi bit 0)
           jsr  CheckVoltageforAIS    
   LEE12:  ldaa Z83_PortBdata    ; load a with memory contents
           bpl  LEE39          ; branch if plus (hi bit 0)
           sei                 ; disable interrupts
           ldab ADScanIndex    ; load b with memory contents
           tba                 ; a = b
           incb            
           cmpb #0x0b          ;  -00001011-
           bls  LEE21          ; branch if lower or same
           clrb                ; b = 0
   LEE21:  stab ADScanIndex    ; store b into memory
           bsr  ADLookup
           cli                 ; enable interrupts
           ldx  #ADTableOffsets83    ; load index with value
           abx                 ; add b to index
           ldab 0x00,x         ; load b with memory at index + value
           ldx  #CoolantTemp    ; load index with value
           abx                 ; add b to index
           cmpb #0x07          ;  -00000111-
           bne  LEE37          ; branch if not equal (not zero)
           jmp  DetermineVoltage

   LEE37:  staa 0x00,x     
   LEE39:  rts                 ; return from subroutine

   LEE3A:  ldaa BitFlags_82    ; load a with memory contents
           bmi  LEE82          ; branch if minus(hi bit 1)
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           ldx  #RPMMAP_SwitchPointForDownUp_FromRpm    ; load index with value
           jsr  Lookup4ByteTable    
           ldaa Timer_OpenLoopFraction    ; load a with memory contents
           cmpa LMTOLF2_LimitTimerOpenLoopFraction2    ; compare a with memory contents (data is 2b)
           bcs  LEE54          ; branch if lower
           subb RPMPSB_RPMMAPSubtractor    ; subtract memory contents from b (data is 03)
           bcc  LEE54          ; branch if greater or equal
           clrb                ; b = 0
   LEE54:  ldaa Counter_FallingEdgeEPP_MaxFF    ; load a with memory contents
           cmpb MapValue   
           bcs  LEE69          ; branch if lower
           cmpa PTENR_EppPerAmountForIncreasing    ; compare a with memory contents (data is 64)
           bcs  LEE82          ; branch if lower
           ldab PTENR_EppPerAmountForIncreasing    ; load b with memory contents (data is 64)
           ldaa Timer_OpenLoopFraction    ; load a with memory contents
           beq  LEE7B          ; branch if equal (zero)
           deca                ; decrement a
           bra  LEE79          ; branch

   LEE69:  cmpa LMTOLF1_LimitTimerOpenLoopFraction1    ; compare a with memory contents (data is 3c)
           bcs  LEE82          ; branch if lower
           ldab LMTOLF1_LimitTimerOpenLoopFraction1    ; load b with memory contents (data is 3c)
           ldaa Timer_OpenLoopFraction    ; load a with memory contents
           cmpa LMTOLF2_LimitTimerOpenLoopFraction2    ; compare a with memory contents (data is 2b)
           bcc  LEE7B          ; branch if greater or equal
           inca                ; increment a
   LEE79:  staa Timer_OpenLoopFraction    ; store a into memory
   LEE7B:  sei                 ; disable interrupts
           ldaa Counter_FallingEdgeEPP_MaxFF    ; load a with memory contents
           sba                 ; subtract (a=a-b)
           staa Counter_FallingEdgeEPP_MaxFF    ; store a into memory
           cli                 ; enable interrupts
   LEE82:  rts                 ; return from subroutine

ControlEngineCutout_MM:
           ldaa BitFlags_82    ; load a with memory contents
           bmi  LEED2          ; branch if minus(hi bit 1)
           ldaa BaroPressure    ; load a with memory contents
           ldab BitFlags_80    ; load b with memory contents
           bitb #0x10          ;  -00010000-
           beq  LEEA0          ; branch if equal (zero)
           adda LMPSHF_OverboostFuelShutoffDisablePointFromMap_Limp    ;  (data is 73)
           cmpa MAPHIG_MapSensorUpperLimit    ; compare a with memory contents (data is fc)
           bcs  LEE9A          ; branch if lower
           ldaa MAPHIG_MapSensorUpperLimit    ; load a with memory contents (data is fc)
   LEE9A:  cmpa MapValue       ; compare a with memory contents
           bls  LEEBF          ; branch if lower or same
           bra  LEED2          ; branch

   LEEA0:  adda MPSHFT_OverboostFuelShutoffEnablePointFromMap_Timer    ;  (data is 76)
           bcc  LEEA7          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LEEA7:  cmpa MapValue       ; compare a with memory contents
           bhi  LEECD          ; branch if higher
           adda MPSHFA_OverboostFuelShutoffEnablePointFromMap_Absolute    ;  (data is 1a)
           bcc  LEEB2          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LEEB2:  cmpa MapValue       ; compare a with memory contents
           bcs  LEEBF          ; branch if lower
           ldab Timer_FuelShutoff    ; load b with memory contents
           beq  LEEBF          ; branch if equal (zero)
           decb            
           stab Timer_FuelShutoff    ; store b into memory
           bra  LEED2          ; branch

   LEEBF:  ldab MapValue       ; load b with memory contents
           cmpb MAPHIG_MapSensorUpperLimit    ; compare b with memory contents (data is fc)
           bcc  L2668          ; branch if greater or equal
           ldaa #0x07          ; load a with value -00000111-
           jsr  LC94E          
   L2668:  bra  SetFuelShutoffFlag          ; branch

   LEECD:  ldaa TRNTM_OverboostFuelShutoffDelay    ; load a with memory contents (data is 17)
           staa Timer_FuelShutoff    ; store a into memory
   LEED2:  ldaa TimerOverflowsBetweenDistPulses    ; load a with memory contents
           bne  ClearFuelShutoffFlag          ; branch if not equal (not zero)
           ldx  #REVLMT_OverRevFuelShutoff    ; load index with value
           ldaa BitFlags_80    ; load a with memory contents
           bpl  LEEE6          ; branch if plus (hi bit 0)
           ldab THRTHR_25PctThrValueFromShutoff    ; load b with memory contents (data is 21)
           addb MINTHR_LowestSessionTPS    ; b=b+memory contents
           cmpb TpsVolts   
           bcs  Shutoff_CheckRPMAgainstLimiter          ; branch if lower
   LEEE6:  ldx  #REVLMT3_OverRevFuelShutoff    ; load index with value
           bita #0x40          ;  -01000000-
           beq  LEEF9          ; branch if equal (zero)
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           cmpa RVLSPD_CarSpeedForRevLimitWithTBOff    ; compare a with memory contents (data is 14)
           bcc  LEF07          ; branch if greater or equal
           bra  LEEFD          ; branch

   LEEF9:  ldab BitFlags_81    ; load b with memory contents
           bmi  LEF07          ; branch if minus(hi bit 1)
   LEEFD:  ldab BaroPressure    ; load b with memory contents
           lsrb                ; logical shift right b
           tba                 ; a = b
           lsrb                ; logical shift right b
           aba                 ; a=a+b
           cmpa MapValue       ; compare a with memory contents
           bcs  Shutoff_CheckRPMAgainstLimiter          ; branch if lower
   LEF07:  ldx  #REVLMT5_OverRevFuelShutoff    ; load index with value

          ; ******************************************************************
          ; new staging mod, RCL
          ; this simply decides which rev limit to use for 'normal' operation
          ; either the 'full' rev limit, or the staging limit
          ; it uses the original code to turn off the fuel...

          ; first, check that the option is enabled (RCL)
        
          ldab CONFIG_ConfigurationFlags
          bitb #cfg_StageLim
          beq  Shutoff_CheckRPMAgainstLimiter ; if not optioned, don't even run this code...

          ; here, check that the brake pedal is pushed  (RCL)
          ldaa RVLSWS_StagingLimiterSwitchSelect
          beq  checkspeed    ; no enable switch, so enabled by speed only
          anda Z83_PortCdata  ; comapre the switch state to the enable switch - if 2 switches are enabled, then they work as -OR- switches, not -AND-
          beq  clearflag     ; branch if not enabled or pedal just released

checkspeed:
           ldd  VehicleSpeed_HB ; load d (a&b) with memory contents
           asld                ; Vehicle speed reference is now 0-255mph
           asld                ;
           cmpa RVLSPS_Staging ; compare a with memory contents
           bcs  setflag       ; if the speed is below the speed limit, set the flag

clearflag:
           ldaa BitFlags_7f
           anda ~#b7f_bit5    ;using this bit to tell that the limiter is NOT active - for the anti-lag retard
           staa BitFlags_7f
           bra  Shutoff_CheckRPMAgainstLimiter

setflag:
           ldaa BitFlags_7f
           oraa #b7f_bit5      ; using this bit to tell that the limiter is active - for the anti-lag retard
           staa BitFlags_7f
           ; set the 2-step limit
           ldx #REVLMTX_StagingModFuelShutoff

        ; ******************************************************************

Shutoff_CheckRPMAgainstLimiter:
           ldd  DistributorFallingEdgePulsewidth_HB    ; load d (a&b) with memory contents
           subd 0x00,x
           bcc  ClearFuelShutoffFlag          ; branch if greater or equal
           ldd  DistributorFallingEdgePulsewidth_HB    ; load d (a&b) with memory contents
           subd 0x02,x     
           bcs  SetFuelShutoffFlag          ; branch if lower
           ldab BitFlags_84    ; load b with memory contents
           bitb #0x08          ;  -00001000-
           beq  Shutoff_Return          ; branch if equal (zero)
SetFuelShutoffFlag:
           ldab BitFlags_84    ; load b with memory contents
           orab #0x08          ;  -00001000-
           bra  StoreFuelShutoffFlag          ; branch

ClearFuelShutoffFlag:
           ldab BitFlags_84    ; load b with memory contents
           andb #0xf7          ;  -11110111-
StoreFuelShutoffFlag:
           stab BitFlags_84    ; store b into memory
Shutoff_Return:
           rts                 ; return from subroutine

IncrementLoopCounters_MM:
           ldaa Timer_AisChanges    ; load a with memory contents
           inca                ; increment a
           beq  LEF30          ; branch if equal (zero)
           staa Timer_AisChanges    ; store a into memory
   LEF30:  ldaa TimerOverflowsBetweenDistPulses    ; load a with memory contents
           cmpa #0x04          ; compare a with value -00000100-
           bcs  LEF51          ; branch if lower
           clrb                ; b = 0
           ldaa #0x8a          ; load a with value -10001010-
           sei                 ; disable interrupts
           oraa BitFlags_82    ; OR a with memory contents
           bita #0x20          ;  -00100000-
           beq  LEF44          ; branch if equal (zero)
           anda #0xdf          ; AND a with value -11011111-
           stab Counter_FallingEdgeEPP_MaxFF    ; store b into memory
   LEF44:  staa BitFlags_82    ; store a into memory
           cli                 ; enable interrupts
           ldaa BitFlags_81    ; load a with memory contents
           anda #0xef          ; AND a with value -11101111-
           staa BitFlags_81    ; store a into memory
           stab CurrentWastegateDutyCycle    ; store b into memory
           stab Timer_CLTIME_ClosedLoopTimer    ; store b into memory
   LEF51:  inc  Counter_MainLoop1
           bne  LEF70          ; branch if not equal (not zero)
           ldab BitFlags_4f    ; load b with memory contents
           andb #0xfc          ;  -11111100-
           stab BitFlags_4f    ; store b into memory
           sei                 ; disable interrupts
           ldaa KeyOnOrEngineRunningTime    ; load a with memory contents
           inca                ; increment a
           beq  LEF64          ; branch if equal (zero)
           staa KeyOnOrEngineRunningTime    ; store a into memory
   LEF64:  cli                 ; enable interrupts
           ldaa BitFlags_82    ; load a with memory contents
           bmi  LEF70          ; branch if minus(hi bit 1)
           ldaa VerySlowCounter2point6seconds    ; load a with memory contents
           inca                ; increment a
           beq  LEF70          ; branch if equal (zero)
           staa VerySlowCounter2point6seconds    ; store a into memory
   LEF70:  rts                 ; return from subroutine

MM_L1597:
           ldab BitFlags_4f    ; load b with memory contents
           andb #0x08          ;  -00001000-
           stab Temp0          ; store b into memory
           ldab Z83_PortCdata    ; load b with memory contents
           andb #0x08          ;  -00001000-
           eorb Temp0      
           beq  LEF8F          ; branch if equal (zero)
           eorb BitFlags_4f
           stab BitFlags_4f    ; store b into memory
           ldaa BitFlags_84    ; load a with memory contents
           lsla                ; logical shift left a
           oraa BitFlags_80    ; OR a with memory contents
           bmi  LEF8F          ; branch if minus(hi bit 1)
           orab #0x10          ;  -00010000-
           stab BitFlags_4f    ; store b into memory
   LEF8F:  rts                 ; return from subroutine

CalculateSparkAdvance_MM:
           clrb                ; b = 0
           clra                ; a = 0
           std  Temp0          ; store D to RAM
           ldaa MapValue       ; load a with memory contents
           ldab CoolantTemp    ; load b with memory contents
           cmpb TMPSWP_EngTempSwitchPointForSparkAdvance    ; compare b with memory contents (data is a6)
           bcc  LEFD2          ; branch if greater or equal
           ldx  #CLDMAP_AdvanceFromMAPCold    ; load index with value
           jsr  Lookup4ByteTable    
           ldab BitFlags_81    ; load b with memory contents
           bmi  LEFAF          ; branch if minus(hi bit 1)
           cmpa CLDLMT_LimitForColdMapAtClosedThrottle    ; compare a with memory contents (data is 14)
           bcs  LEFAF          ; branch if lower
           ldaa CLDLMT_LimitForColdMapAtClosedThrottle    ; load a with memory contents (data is 14)
   LEFAF:  staa Temp0          ; store a into memory
           ldab BitFlags_81    ; load b with memory contents
           bmi  LEFCF          ; branch if minus(hi bit 1)
   LEFB5:  ldaa EngineRpm_HB    ; load a with memory contents
           cmpa PNRPM_EngineSpeedBelowWhich_PNIDLE_Enabled    ; compare a with memory contents (data is 01)
           bhi  LEFCF          ; branch if higher
           ldaa Z83_PortCdata    ; load a with memory contents
           bita #0x08          ;  -00001000-
           bne  LEFCF          ; branch if not equal (not zero)
           ldaa CoolantTemp    ; load a with memory contents
           ldx  #PNIDLE_AdvanceRemovedIdleParkNeutral    ; load index with value
           jsr  Lookup4ByteTable    
           adda Temp0      
           staa Temp0          ; store a into memory
   LEFCF:  jmp  LF05A      

   LEFD2:  ldab BitFlags_81    ; load b with memory contents
           bpl  LEFB5          ; branch if plus (hi bit 0)
           ldx  #WOTMAP_AdvanceFromMAPWarmFull    ; load index with value
           jsr  Lookup4ByteTable    

           ; subtract anti-lag timing from the WOT table only
           suba AntiLagRetard
           staa Temp0

           staa Temp0          ; store a into memory
           ldab BitFlags_81    ; load b with memory contents
           lsrb                ; logical shift right b
           bcs  LF027          ; branch if lower
           ldaa Timer_OpenLoopFraction    ; load a with memory contents
           cmpa LMTOLF2_LimitTimerOpenLoopFraction2    ; compare a with memory contents (data is 2b)
           bcs  LEFF1          ; branch if lower
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb RPMLMT_RPMLimitForManyThings    ; compare b with memory contents (data is 3a)
           bcc  LF027          ; branch if greater or equal
   LEFF1:  ldab MapValue       ; load b with memory contents
           cmpb OBCONST_OverboostConstant1    ; compare b with memory contents (data is aa)
           bcc  LF002          ; branch if greater or equal
           aba                 ; a=a+b
           bcc  LEFFD          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LEFFD:  suba OBCONST_OverboostConstant1    ;  (data is aa)
           bls  LF00A          ; branch if lower or same
   LF002:  ldab ARADVR_AdaptiveRetardAdvanceRatioFromMAP    ; load b with memory contents (data is 1f)
           mul                 ; multiply (d=a*b)
           adca #0x00          ;  -00000000-
           staa Temp1          ; store a into memory
   LF00A:  ldaa MapValue       ; load a with memory contents
           ldx  #HOTMAP_AdvanceFromMAPWarmPart    ; load index with value
           jsr  Lookup4ByteTable    
           ldab FACALC_AdaptiveRetardEnable    ; load b with memory contents (data is ff)
           bmi  LF01F          ; branch if minus(hi bit 1)
           adda Temp1      
           cmpa Temp0          ; compare a with memory contents
           bge  LF027          ; branch if greater or equal
           bra  LF025          ; branch

   LF01F:  suba Temp1      
           cmpa Temp0          ; compare a with memory contents
           ble  LF027          ; branch if less or equal
   LF025:  staa Temp0          ; store a into memory
   LF027:  ldx  #ABCBAS_AdvanceBaroCompensationBaseFromRPM    ; load index with value
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    
           staa Temp1          ; store a into memory
           ldx  #ABCFBR_AdvanceBaroCompensationFactorFromBaro    ; load index with value
           ldaa BaroPressure    ; load a with memory contents
           jsr  Lookup4ByteTable    
           staa Temp4          ; store a into memory
           ldx  #ABCFRP_AdvanceBaroCompensationFactorFromRPM    ; load index with value
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    
           ldab Temp4          ; load b with memory contents
           mul                 ; multiply (d=a*b)
           tab                 ; b = a
           ldaa Temp1          ; load a with memory contents
           sba                 ; subtract (a=a-b)
           cmpa MINADV_MinimumAdvance    ; compare a with memory contents (data is 06)
           bpl  LF054          ; branch if plus (hi bit 0)
           ldaa MINADV_MinimumAdvance    ; load a with memory contents (data is 06)
   LF054:  cmpa Temp0          ; compare a with memory contents
           bgt  LF05A          ; branch if greater
           staa Temp0          ; store a into memory
   LF05A:  ldx  #GOVNER_AdvanceFromRPM    ; load index with value
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    
           addb Temp0          ; b=b+memory contents
           bpl  CheckForTPSRetard    ; branch if plus (hi bit 0)
           clrb                ; b = 0
CheckForTPSRetard:
           stab Temp0          ; store b into memory
           ldaa MapValue       ; load a with memory contents
           cmpa RTMAPE_RetardFromTPSEnableAboveThisMAP    ; compare a with memory contents (data is 93)
           bls  LF092          ; branch if lower or same
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa RTRPME_RetardFromTPSEnableAboveThisRPM    ; compare a with memory contents (data is 27)
           bls  LF092          ; branch if lower or same
           ldab AverageTPSVolts    ; load b with memory contents
           cmpb RTTPSE_RetardFromTPSEnableAboveThisTPS    ; compare b with memory contents (data is 50)
           bls  LF092          ; branch if lower or same
           ldaa TpsVolts       ; load a with memory contents
           sba                 ; subtract (a=a-b)
           bcs  LF092          ; branch if lower
           ldx  #RETTPS_RetardFromTPS    ; load index with value
           jsr  Lookup4ByteTable    
           ldaa Temp0          ; load a with memory contents
           sba                 ; subtract (a=a-b)
           bpl  LF090          ; branch if plus (hi bit 0)
           clra                ; a = 0
   LF090:  staa Temp0          ; store a into memory
   LF092:  ldx  #SPKLMT_TotalAdvanceAllowed    ; load index with value
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    
           cmpb Temp0      
           bcs  LF0A1          ; branch if lower
           ldab Temp0          ; load b with memory contents
   LF0A1:  negb            
           addb #0xa6          ;  -10100110-
           ldaa #0x5b          ; load a with value -01011011-
           mul                 ; multiply (d=a*b)
           asld                ; shift left (d=d*2)
           tstb            
           bpl  LF0AC          ; branch if plus (hi bit 0)
           inca                ; increment a
   LF0AC:  staa CalculatedSparkAdvance    ; store a into memory
           rts                 ; return from subroutine

CheckThrottleRoutine_MM:
           ldab BitFlags_80    ; load b with memory contents
           bitb #0x40          ;  -01000000-
           bne  CheckThrottle_ErrorAlreadyFlagged    ; branch if not equal (not zero)
           ldaa TPSVolts_11msUpdate    ; load a with memory contents
           cmpa THRLOW_ThrottleLowerLimit    ; compare a with memory contents (data is 08)
           bcs  CheckThrottle_BadTpsSignal    ; branch if lower
           cmpa THRHIG_ThrottleUpperLimit    ; compare a with memory contents (data is f0)
           bcs  CheckThrottle_GotTpsValue    ; branch if lower
CheckThrottle_BadTpsSignal:
           ldaa Counter_MainLoop1    ; load a with memory contents
           bita #0x06          ;  -00000110-
           bne  CheckThrottle_AtFullThrottle    ; branch if not equal (not zero)
           ldaa #0x16          ; load a with value -00010110-
           jsr  ThrowCriticalError
           bcc  CheckThrottle_AtFullThrottle    ; branch if greater or equal
           ldab #0x40          ; load b with value -01000000-
           sei                 ; disable interrupts
           orab BitFlags_80
           stab BitFlags_80    ; store b into memory
           cli                 ; enable interrupts
CheckThrottle_ErrorAlreadyFlagged:
           ldaa #0x40          ; load a with value -01000000-
           staa MINTHR_LowestSessionTPS    ; store a into memory
           ldab LowestHistoricalTPS    ; load b with memory contents
           beq  LF0E0          ; branch if equal (zero)
           staa LowestHistoricalTPS    ; store a into memory
   LF0E0:  ldab BitFlags_82    ; load b with memory contents
           bmi  CheckThrottle_GotTpsValue    ; branch if minus(hi bit 1)
           ldab MapValue       ; load b with memory contents
           cmpb MPTHR_MapSwitchPointForFullThrottleOrIdle    ; compare b with memory contents (data is 68)
           bcs  CheckThrottle_GotTpsValue    ; branch if lower
           adda WOTDLT_DeltaThrottleFrom_MINTHR_ToDetermineFullThrottle    ;  (data is 85)
CheckThrottle_GotTpsValue:
           staa TpsVolts       ; store a into memory
CheckThrottle_AtFullThrottle:
           ldab BitFlags_81    ; load b with memory contents
           bmi  LF129          ; branch if minus(hi bit 1)
           ldab Timer_CountdownFromStartRunForAisFeedback    ; load b with memory contents
           bne  LF129          ; branch if not equal (not zero)
           ldab BitFlags_82    ; load b with memory contents
           bpl  LF104          ; branch if plus (hi bit 0)
           ldab BatteryVolts    ; load b with memory contents
           cmpb #0xb2          ;  -10110010-
           bcs  LF129          ; branch if lower
           bra  LF108          ; branch

   LF104:  ldab KeyOnOrEngineRunningTime    ; load b with memory contents
           beq  LF129          ; branch if equal (zero)
   LF108:  cmpa MINTHR_LowestSessionTPS    ; compare a with memory contents
           bcc  LF129          ; branch if greater or equal
           ldaa Timer_DelayBeforeUpdating_MINTHR    ; load a with memory contents
           deca                ; decrement a
           bne  LF12C          ; branch if not equal (not zero)
           ldab MINTHR_LowestSessionTPS    ; load b with memory contents
           cmpb #0x10          ;  -00010000-
           bcc  LF11A          ; branch if greater or equal
           ldab MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load b with memory contents (data is 5c)
   LF11A:  decb            
           stab MINTHR_LowestSessionTPS    ; store b into memory
           ldaa LowestHistoricalTPS    ; load a with memory contents
           beq  LF123          ; branch if equal (zero)
           stab LowestHistoricalTPS    ; store b into memory
   LF123:  ldaa BitFlags_81    ; load a with memory contents
           anda #0xbf          ; AND a with value -10111111-
           staa BitFlags_81    ; store a into memory
   LF129:  ldaa MAXCNT_ProgramLoopsWithThrottleBelow_MINTHR_ToDecrement_MINTHR    ; load a with memory contents (data is 10)
   LF12C:  staa Timer_DelayBeforeUpdating_MINTHR    ; store a into memory
           ldaa MTHRCL_NumberOfBitsAbove_MINTHR_ToDetermineOnThrottleTransition    ; load a with memory contents (data is 03)
           ldab BitFlags_81    ; load b with memory contents
           bpl  LF138          ; branch if plus (hi bit 0)
           ldaa MTHROP_NumberOfBitsAbove_MINTHR_ToDetermineOffThrottleTransition    ; load a with memory contents (data is 01)
   LF138:  adda MINTHR_LowestSessionTPS
           cmpa TpsVolts       ; compare a with memory contents
           bcc  LF168          ; branch if greater or equal
           tstb            
           bmi  LF164          ; branch if minus(hi bit 1)
           bitb #0x40          ;  -01000000-
           bne  LF157          ; branch if not equal (not zero)
           ldaa MINTHR_LowestSessionTPS    ; load a with memory contents
           inca                ; increment a
           cmpa TpsVolts       ; compare a with memory contents
           bcc  LF157          ; branch if greater or equal
           staa MINTHR_LowestSessionTPS    ; store a into memory
           tst  LowestHistoricalTPS
           beq  LF155          ; branch if equal (zero)
           staa LowestHistoricalTPS    ; store a into memory
   LF155:  orab #0x40          ;  -01000000-
   LF157:  clra                ; a = 0
           staa Timer_Leanout    ; store a into memory
           ldaa MapValue       ; load a with memory contents
           suba TestedAgainstMAPPressureDuringTransientCalc    ;  (data is 0a)
           bcc  LF162          ; branch if greater or equal
           clra                ; a = 0
   LF162:  staa AverageMAPValue    ; store a into memory
   LF164:  orab #0x80          ;  -10000000-
           bra  LF194          ; branch

   LF168:  tstb            
           bpl  LF192          ; branch if plus (hi bit 0)
           ldaa BitFlags_85    ; load a with memory contents
           bita #0x04          ;  -00000100-
           bne  LF175          ; branch if not equal (not zero)
           oraa #0x20          ;  -00100000-
           staa BitFlags_85    ; store a into memory
   LF175:  ldx  #DLYTIM_AisDelayAfterThrottleClosesWhenMoving    ; load index with value
           stab Temp0          ; store b into memory
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           ldab Temp0          ; load b with memory contents
           cmpa MPHREF_SwitchPointForDecelIdleAisControl    ; compare a with memory contents (data is 06)
           bcc  LF18E          ; branch if greater or equal
           ldaa Z83_PortCdata    ; load a with memory contents
           bita #0x08          ;  -00001000-
           bne  LF18E          ; branch if not equal (not zero)
           inx                 ; increment index (x=x+1)
   LF18E:  ldaa 0x00,x         ; load a with memory at index + value
           staa Timer_CountdownFromStartRunForAisFeedback    ; store a into memory
   LF192:  andb #0x7f          ;  -01111111-
   LF194:  bitb #0x08          ;  -00001000-
           bne  LF1C5          ; branch if not equal (not zero)
           ldaa Z83_PortCdata    ; load a with memory contents
           anda #0x10          ; AND a with value -00010000-
           beq  LF1C5          ; branch if equal (zero)
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa RPTHCK_RPMLimitforThrottleBelowHalfChecking    ; compare a with memory contents (data is 18)
           bcs  LF1C5          ; branch if lower
           ldaa MapValue       ; load a with memory contents
           cmpa MPTHCK_MAPLimitforThrottleBelowHalfChecking    ; compare a with memory contents (data is 5e)
           bcc  LF1C5          ; branch if greater or equal
           ldaa MINTHR_LowestSessionTPS    ; load a with memory contents
           adda MININH_Amount_MINTHR_IsIncreasedAtKeyOnOnlyHalfThrottle    ;  (data is 04)
           cmpa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; compare a with memory contents (data is 5c)
           bcs  LF1BA          ; branch if lower
           ldaa MTHRMX_ValueOf_MINTHR_WhenBatteryDisconnected    ; load a with memory contents (data is 5c)
   LF1BA:  staa MINTHR_LowestSessionTPS    ; store a into memory
           tst  LowestHistoricalTPS
           beq  LF1C3          ; branch if equal (zero)
           staa LowestHistoricalTPS    ; store a into memory
   LF1C3:  orab #0x08          ;  -00001000-
   LF1C5:  ldaa MINTHR_LowestSessionTPS    ; load a with memory contents
           adda #0x30          ;  -00110000-
           cmpa TpsVolts       ; compare a with memory contents
           bcc  LF1CF          ; branch if greater or equal
           andb #0xf7          ;  -11110111-
   LF1CF:  stab BitFlags_81    ; store b into memory
           rts                 ; return from subroutine

ControlFan2_MM:
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           staa Temp0          ; store a into memory
           ldab Z83_CPU_Port1_copy    ; load b with memory contents
           ldaa BaroPressure    ; load a with memory contents
           adda FANMAP_FanTurnsOnWhenMapAboveBaroPlusThis    ;  (data is 1a)
           bcs  LF1FB          ; branch if lower
           bitb #0x08          ;  -00001000-
           beq  LF1EA          ; branch if equal (zero)
           adda #0x04          ;  -00000100-
           bcs  LF1FB          ; branch if lower
   LF1EA:  cmpa MapValue       ; compare a with memory contents
           bcc  LF1FB          ; branch if greater or equal
           ldaa AmbientAirTempVolts    ; load a with memory contents
           bitb #0x08          ;  -00001000-
           bne  LF1F6          ; branch if not equal (not zero)
           deca                ; decrement a
           deca                ; decrement a
   LF1F6:  cmpa FANBAT_FanTurnsOnWhenBatteryTempAboveThis    ; compare a with memory contents (data is 9a)
           bcs  LF254          ; branch if lower
   LF1FB:  ldaa CoolantTemp    ; load a with memory contents
           cmpa #0xd2          ; compare a with value -11010010-
           bcs  LF218          ; branch if lower
           ldaa Timer_RadSteamingCountdown    ; load a with memory contents
           beq  LF218          ; branch if equal (zero)
           tst  Counter_MainLoop1
           bne  LF20D          ; branch if not equal (not zero)
           deca                ; decrement a
           staa Timer_RadSteamingCountdown    ; store a into memory
   LF20D:  clra                ; a = 0
           bitb #0x08          ;  -00001000-
           bne  LF214          ; branch if not equal (not zero)
           ldaa #0x08          ; load a with value -00001000-
   LF214:  cmpa Temp0          ; compare a with memory contents
           bcc  LF254          ; branch if greater or equal
   LF218:  ldaa BitFlags_82    ; load a with memory contents
           bita #0x80          ;  -10000000-
           bne  LF224          ; branch if not equal (not zero)
           ldaa BitFlags_85    ; load a with memory contents
           bita #0x08          ;  -00001000-
           beq  LF254          ; branch if equal (zero)
   LF224:  ldaa BitFlags_80    ; load a with memory contents
           bita #0x02          ;  -00000010-
           bne  LF254          ; branch if not equal (not zero)
           ldx  #FANTMP_FanTurnOnTempAbove45Mph    ; load index with value
           ldaa Temp0          ; load a with memory contents
           cmpa #0x5a          ; compare a with value -01011010-
           bcc  TurnFanOn          ; branch if greater or equal
           cmpa #0x46          ; compare a with value -01000110-
           ldaa BitFlags_84    ; load a with memory contents
           bcs  LF23D          ; branch if lower
           bita #0x01          ;  -00000001-
           bne  TurnFanOn          ; branch if not equal (not zero)
   LF23D:  inx                 ; increment index (x=x+1)
           inx                 ; increment index (x=x+1)
           anda #0xfe          ; AND a with value -11111110-
           bra  LF247          ; branch

TurnFanOn:
           ldaa BitFlags_84    ; load a with memory contents
           oraa #0x01          ;  -00000001-
   LF247:  staa BitFlags_84    ; store a into memory
           bitb #0x08          ;  -00001000-
           bne  LF24E          ; branch if not equal (not zero)
           inx                 ; increment index (x=x+1)
   LF24E:  ldaa 0x00,x         ; load a with memory at index + value
           cmpa CoolantTemp    ; compare a with memory contents
           bcc  TurnFanOffByTimer          ; branch if greater or equal
   LF254:  ldaa #0x17          ; load a with value -00010111-
           staa Timer_MinimumFanRun    ; store a into memory
           andb #0xf7          ;  -11110111-
           bra  LF266          ; branch

TurnFanOffByTimer:
           ldaa Timer_MinimumFanRun    ; load a with memory contents
           beq  TurnFanOff          ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_MinimumFanRun    ; store a into memory
           rts                 ; return from subroutine

TurnFanOff:
           orab #0x08          ;  -00001000-
   LF266:  stab Z83_CPU_Port1_copy    ; store b into memory
           rts                 ; return from subroutine

                   .msg "..." ; these are just messages to display during assemble to let you know what's going on...

CalcTargetBoost_MM:
           ldx  #WSGRPM_AllowedBoost_FromRpm    ; load index with value
           ldd  EngineRpm_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           jsr  Lookup4ByteTable    
           staa Temp4          ; store a into memory
           ldx  #WSGTIM_AllowedBoost_FromTime    ; load index with value
           ldaa Timer_BoostTimer    ; load a with memory contents
           jsr  LookupAndKeepSmallerBoostGoal    
           ldx  #WSGCLT_AllowedBoost_FromTemp    ; load index with value
           ldaa CoolantTemp    ; load a with memory contents
           jsr  LookupAndKeepSmallerBoostGoal    
           ldx  #WSGCHG_AllowedBoost_FromChargeTemp    ; load index with value
           ldaa ChargeTempVolts    ; load a with memory contents
           jsr  LookupAndKeepSmallerBoostGoal    

           ; added code for switchable boost
           ; this works differently from the later code. More like the S60
           ; with a single constant for the "lo" boost setting.
           ldaa CONFIG_ConfigurationFlags
           bita #cfg_SwBoost      ; check the bit for the Switch Boost mod
           beq  NoLoBoost        ; branch if the bit is not set, ie not enabled
           ; now, look at the hi-boost switch and see if it's enabled ...

           ;Z83_PortCdata
           ;  Bit Function            LM Pin
           ;   7   dist sync           B17
           ;   6   cruise enable       B15
           ;   5                       B14
           ;   4   brake               B13
           ;   3   park/neutral        B12
           ;   2   ac clutch in        B11
           ;   1   cruise resume       B10
           ;   0   cruise set          B9

           ldab Z83_PortCdata ; load the switch state into B
           bita #cfg_BstSwPol
	   beq  Polarity_Lo

Polarity_Hi:
           andb BSTSWS_HighBoostSwitchSelect
           beq  NoLoBoost
           bra  LoadLoBoost

Polarity_Lo:
           andb BSTSWS_HighBoostSwitchSelect
           bne  NoLoBoost

LoadLoBoost:
           ldaa SWBSLO_SwitchableBoostLoSetpoint ; load the lo-boost limit constant
           jsr  StoreLowestInTemp4    ; call:

NoLoBoost:
           ; this is the stock code continued here...
           ldaa BitFlags_81    ; load a with memory contents
           lsra            
           bcs  LF297          ; branch if lower
           ldaa WSGPRT_AllowedBoostPartThrottle_FromThrottle    ; load a with memory contents (data is 3f)
           jsr  StoreLowestInTemp4    
   LF297:  ldab Z83_PortCdata    ; load b with memory contents
           andb #0x08          ;  -00001000-
           beq  LF2A9          ; branch if equal (zero)
           ldx  #MXSBST_AllowedBoost_FromSpeed    ; load index with value
           ldd  VehicleSpeed_HB    ; load d (a&b) with memory contents
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           asld                ; shift left (d=d*2)
           jsr  LookupAndKeepSmallerBoostGoal    
   LF2A9:  ldx  #WSGKNK_BoostTimeSinceLastKnock    ; load index with value
           ldaa Timer_Over5PSIBoost    ; load a with memory contents
           jsr  Lookup4ByteTable    
           ldaa Temp4          ; load a with memory contents
           sba                 ; subtract (a=a-b)
           bcc  LF2B7          ; branch if greater or equal
           clra                ; a = 0
   LF2B7:  adda BaroPressure
           bcc  StoreBoostTarget          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
StoreBoostTarget:
           staa BoostTarget    ; store a into memory
           rts                 ; return from subroutine

LookupAndKeepSmallerBoostGoal:
           jsr  Lookup4ByteTable    
StoreLowestInTemp4:
           cmpa Temp4          ; compare a with memory contents
           bcc  LF2C9          ; branch if greater or equal
           staa Temp4          ; store a into memory
   LF2C9:  rts                 ; return from subroutine

CalcWGDutyCycle_MM:
           ldab Counter_MainLoop1    ; load b with memory contents
           incb            
           ldaa BitFlags_82    ; load a with memory contents
           bmi  LF2E6          ; branch if minus(hi bit 1)
           tstb            
           bne  LF2DB          ; branch if not equal (not zero)
           ldaa Timer_Over5PSIBoost    ; load a with memory contents
           inca                ; increment a
           beq  LF2DB          ; branch if equal (zero)
           staa Timer_Over5PSIBoost    ; store a into memory
   LF2DB:  ldaa MapValue       ; load a with memory contents
           suba BaroPressure
           bcs  LF2E6          ; branch if lower
           cmpa MAPOFS_BoostMapOffsetForDCWOT    ; compare a with memory contents (data is 17)
           bcc  LF2F9          ; branch if greater or equal
   LF2E6:  clra                ; a = 0
           staa CurrentWastegateDutyCycle    ; store a into memory
           staa WastegateDutyCycleIncreaseFromKnock    ; store a into memory
           staa Counter_Over5psiBoost    ; store a into memory
           bitb #0x1f          ;  -00011111-
           bne  LF2F8          ; branch if not equal (not zero)
           ldaa Timer_BoostTimer    ; load a with memory contents
           beq  LF2F8          ; branch if equal (zero)
           deca                ; decrement a
           staa Timer_BoostTimer    ; store a into memory
   LF2F8:  rts                 ; return from subroutine

   LF2F9:  cmpa KNOKMP_BoostKNKCNTinc    ; compare a with memory contents (data is 23)
           bcc  LF301          ; branch if greater or equal
           clra                ; a = 0
           staa Counter_Over5psiBoost    ; store a into memory
   LF301:  ldaa Counter_Over5psiBoost    ; load a with memory contents
           cmpa KNKMAX_BoostMaxKNKBeforeReset    ; compare a with memory contents (data is 10)
           bcs  LF30B          ; branch if lower
           clra                ; a = 0
           staa Timer_Over5PSIBoost    ; store a into memory
   LF30B:  tstb            
           bne  LF311          ; branch if not equal (not zero)
           clra                ; a = 0
           staa Counter_Over5psiBoost    ; store a into memory
   LF311:  bitb #0x1f          ;  -00011111-
           bne  LF323          ; branch if not equal (not zero)
           ldab EngineRpm_HB    ; load b with memory contents
           cmpb RPMBST_MinimumRpmToTrackBoostCreep    ; compare b with memory contents (data is 26)
           bcs  LF323          ; branch if lower
           ldaa Timer_BoostTimer    ; load a with memory contents
           inca                ; increment a
           beq  LF323          ; branch if equal (zero)
           staa Timer_BoostTimer    ; store a into memory
   LF323:  ldaa Delta_MAP      ; load a with memory contents
           staa Temp1          ; store a into memory
           bpl  LF32A          ; branch if plus (hi bit 0)
           nega                ; negate a (set high bit)
   LF32A:  staa Temp0          ; store a into memory
           tst  Temp1      
           bmi  ControlWastegate    ; branch if minus(hi bit 1)
           ldaa EngineRpm_HB    ; load a with memory contents
           ldx  #RATLIM_BoostOverboostPrevention    ; load index with value
           jsr  Lookup4ByteTable    
           ldaa Temp0          ; load a with memory contents
           cba             
           bcs  ControlWastegate    ; branch if lower
           ldab PRTMAX_MaxDCForPartThrottleInc    ; load b with memory contents (data is c8)
           stab CurrentWastegateDutyCycle    ; store b into memory
           rts                 ; return from subroutine

ControlWastegate:
           clrb                ; b = 0
           suba MPDEL_HysteresisForBoostIncreasingCondition    ;  (data is 00)
           bls  LF371          ; branch if lower or same
           staa Temp4          ; store a into memory
           ldaa BoostTarget    ; load a with memory contents
           suba MapValue
           adda #0x80          ;  -10000000-
           ldx  #RESFAC_BoostMapCorrectionResponseFactor    ; load index with value
           jsr  Lookup4ByteTable    
           ldaa Temp4          ; load a with memory contents
           mul                 ; multiply (d=a*b)
           tsta                ; test a
           beq  LF360          ; branch if equal (zero)
           ldab #0xff          ; load b with value -11111111-
   LF360:  tst  Temp1      
           bmi  LF36A          ; branch if minus(hi bit 1)
           ldaa UPRLIM_UpperLimitOnMPCORR    ; load a with memory contents (data is 10)
           bra  LF36D          ; branch

   LF36A:  ldaa LWRLIM_LowerLimitOnMPCORR    ; load a with memory contents (data is 20)
   LF36D:  cba             
           bcc  LF371          ; branch if greater or equal
           tab                 ; b = a
   LF371:  stab MapCorrectionForWasteGate    ; store b into memory
           ldaa BoostTarget    ; load a with memory contents
           tst  Temp1      
           bpl  LF381          ; branch if plus (hi bit 0)
           aba                 ; a=a+b
           bcc  LF385          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
           bra  LF385          ; branch

   LF381:  sba                 ; subtract (a=a-b)
           bcc  LF385          ; branch if greater or equal
           clra                ; a = 0
   LF385:  suba BaroPressure
           bcc  LF38A          ; branch if greater or equal
           clra                ; a = 0
   LF38A:  ldx  #DCWOT_FullThrottleWastegateDutyCycle_C8is100Percent_FromMap    ; load index with value
           jsr  Lookup4ByteTable    
           staa Temp4          ; store a into memory
           ldaa BitFlags_81    ; load a with memory contents
           bita #0x01          ;  -00000001-
           beq  LF3B5          ; branch if equal (zero)
           ldaa EngineRpm_HB    ; load a with memory contents
           ldx  #DCWADJ_FullThrottleWastegateDutyCycleAdjustment_FromRpm    ; load index with value
           jsr  Lookup4ByteTable
           bmi  LF3AE          ; branch if minus(hi bit 1)
           adda Temp4      
           bcs  LF3AA          ; branch if lower
           cmpa #0xc8          ; compare a with value -11001000-
           bls  LF3B3          ; branch if lower or same
   LF3AA:  ldaa #0xc8          ; load a with value -11001000-
           bra  LF3B3          ; branch

   LF3AE:  adda Temp4      
           bcs  LF3B3          ; branch if lower
           clra                ; a = 0
   LF3B3:  staa Temp4          ; store a into memory
   LF3B5:  sei                 ; disable interrupts
           ldaa BitFlags_7f    ; load a with memory contents
           bita #0x10          ;  -00010000-
           beq  LF3D9          ; branch if equal (zero)
           anda #0xef          ; AND a with value -11101111-
           staa BitFlags_7f    ; store a into memory
           cli                 ; enable interrupts
           ldab WastegateDutyCycleIncreaseFromKnock    ; load b with memory contents
           addb KDCINC_WastegateDutyCycleIncreaseStepWhenKnocking    ;  (data is 04)
           bcc  LF3CA          ; branch if greater or equal
           ldab #0xff          ; load b with value -11111111-
   LF3CA:  ldaa KDCMAX_WastegateDutyCycleIncreaseMaxWhenKnocking    ; load a with memory contents (data is 50)
           cba             
           bcs  LF3D6          ; branch if lower
           ldaa KDCMIN_WastegateDutyCycleIncreaseMinWhenKnocking    ; load a with memory contents (data is 0c)
           cba             
           bcs  LF3FC          ; branch if lower
   LF3D6:  tab                 ; b = a
           bra  LF3FC          ; branch

   LF3D9:  cli                 ; enable interrupts
           ldx  #Timer_DelayBeforeUpdating_MINTHR    ; load index with value
   LF3DD:  inx                 ; increment index (x=x+1)
           cpx  #MaxRetardFromMAP    ;  -00000000 11010010-
           beq  LF3FB          ; branch if equal (zero)
           ldaa 0x00,x         ; load a with memory at index + value
           anda #0x3f          ; AND a with value -00111111-
           cmpa BSOLCO_BoostSolenoidCutout    ; compare a with memory contents (data is 07)
           bcs  LF3DD          ; branch if lower
           ldab Counter_MainLoop1    ; load b with memory contents
           lsrb                ; logical shift right b
           bitb DECTIM_TimeScaleFor_DCDECK    ;  (data is 03)
           bne  LF3FE          ; branch if not equal (not zero)
           ldab WastegateDutyCycleIncreaseFromKnock    ; load b with memory contents
           subb DCDECK_WastegateDutyCycleDecrementWhenSparkStillDerated    ; subtract memory contents from b (data is 02)
           bcc  LF3FC          ; branch if greater or equal
   LF3FB:  clrb                ; b = 0
   LF3FC:  stab WastegateDutyCycleIncreaseFromKnock    ; store b into memory
   LF3FE:  ldaa BoostTarget    ; load a with memory contents
           ldab BaroPressure    ; load b with memory contents
           addb MAPPT_WastegateDutyCycleMapSwitchPoint    ;  (data is 62)
           bcc  LF409          ; branch if greater or equal
           ldab #0xff          ; load b with value -11111111-
   LF409:  ldx  #DCCOR1_AdaptiveWastegateCellBelowMAPPT    ; load index with value
           cba             
           bcc  LF410          ; branch if greater or equal
           inx                 ; increment index (x=x+1)
   LF410:  ldab 0x00,x         ; load b with memory at index + value
           suba MapValue   
           bhi  LF441          ; branch if higher
           nega                ; negate a (set high bit)
           staa Temp1          ; store a into memory
           ldaa BitFlags_4f    ; load a with memory contents
           bita #0x40          ;  -01000000-
           bne  LF423          ; branch if not equal (not zero)
           oraa #0x40          ;  -01000000-
           bra  LF44B          ; branch

   LF423:  ldaa MPDEL1_IncCounterWhenDeltaMapBelowThis    ; load a with memory contents (data is 03)
           cmpa Temp0          ; compare a with memory contents
           bcs  WGDC_ClearBoostErrTimer    ; branch if lower
           ldaa Timer_BoostErrTimer    ; load a with memory contents
           inca                ; increment a
           cmpa INCPT_AdaptiveIncAfterThisTime    ; compare a with memory contents (data is 0a)
           bcs  WGDC_StoreBoostErrTimer    ; branch if lower
           ldaa Temp1          ; load a with memory contents
           cmpa MPROOF_StopAdaptiveWGWhenMapIsThisCloseToBoostTarget    ; compare a with memory contents (data is 02)
           bcs  WGDC_ClearBoostErrTimer    ; branch if lower
           cmpb INCLM2_UpperLimitOnWastegateDutyCycleCorrection2    ; compare b with memory contents (data is b0)
           bcc  WGDC_ClearBoostErrTimer    ; branch if greater or equal
           incb            
           bra  WGDC_UpdateAdaptiveWGControlMemory    ; branch

   LF441:  staa Temp1          ; store a into memory
           ldaa BitFlags_4f    ; load a with memory contents
           bita #0x40          ;  -01000000-
           beq  LF44F          ; branch if equal (zero)
           anda #0xbf          ; AND a with value -10111111-
   LF44B:  staa BitFlags_4f    ; store a into memory
           bra  WGDC_ClearBoostErrTimer    ; branch

   LF44F:  ldaa WastegateDutyCycleIncreaseFromKnock    ; load a with memory contents
           bne  WGDC_ClearBoostErrTimer    ; branch if not equal (not zero)
           ldaa BitFlags_81    ; load a with memory contents
           lsra            
           bcc  WGDC_ClearBoostErrTimer    ; branch if greater or equal
           ldaa EngineRpm_HB    ; load a with memory contents
           cmpa DCRPML_NoWastegateDutyCycleCorrectionBelowThisRpm    ; compare a with memory contents (data is 2f)
           bcs  WGDC_ClearBoostErrTimer    ; branch if lower
           cmpa DCRPMH_NoWastegateDutyCycleCorrectionAboveThisRpm    ; compare a with memory contents (data is 4f)
           bhi  WGDC_ClearBoostErrTimer    ; branch if higher
           ldaa MPDEL2_IncCounterWhenDeltaMapBelowThis2    ; load a with memory contents (data is 02)
           cmpa Temp0          ; compare a with memory contents
           bcs  WGDC_ClearBoostErrTimer    ; branch if lower
           ldaa Timer_BoostErrTimer    ; load a with memory contents
           inca                ; increment a
           cmpa INCPT2_AdaptiveIncAfterThisTime2    ; compare a with memory contents (data is 0a)
           bcs  WGDC_StoreBoostErrTimer    ; branch if lower
           ldaa Temp1          ; load a with memory contents
           cmpa MPDEL3_IncCounterWhenDeltaMapBelowThis3    ; compare a with memory contents (data is 00)
           bcs  WGDC_ClearBoostErrTimer    ; branch if lower
           cmpb INCLIM_UpperLimitOnWastegateDutyCycleCorrection    ; compare b with memory contents (data is 62)
           bls  WGDC_ClearBoostErrTimer    ; branch if lower or same
           decb            
WGDC_UpdateAdaptiveWGControlMemory:
           stab 0x00,x     
WGDC_ClearBoostErrTimer:
           clra                ; a = 0
WGDC_StoreBoostErrTimer:
           staa Timer_BoostErrTimer    ; store a into memory
           ldaa Temp4          ; load a with memory contents
           subb #0x80          ;  -10000000-
           bmi  LF496          ; branch if minus(hi bit 1)
           aba                 ; a=a+b
           bcs  LF492          ; branch if lower
           cmpa #0xc8          ; compare a with value -11001000-
           bls  LF49B          ; branch if lower or same
   LF492:  ldaa #0xc8          ; load a with value -11001000-
           bra  LF49B          ; branch

   LF496:  negb            
           sba                 ; subtract (a=a-b)
           bcc  LF49B          ; branch if greater or equal
           clra                ; a = 0
   LF49B:  adda WastegateDutyCycleIncreaseFromKnock
           bcc  LF4A1          ; branch if greater or equal
           ldaa #0xff          ; load a with value -11111111-
   LF4A1:  staa CurrentWastegateDutyCycle    ; store a into memory
           rts                 ; return from subroutine

IRQ1strobe3:
           ldab BitFlags_7f    ; load b with memory contents
           ldaa CurrentWastegateDutyCycle    ; load a with memory contents
           beq  LF4B2          ; branch if equal (zero)
           cmpa #0xc8          ; compare a with value -11001000-
           bcc  LF4B9          ; branch if greater or equal
           bitb #0x04          ;  -00000100-
           bne  LF4BB          ; branch if not equal (not zero)
   LF4B2:  orab #0x04          ;  -00000100-
           nega                ; negate a (set high bit)
           adda #0xc8          ;  -11001000-
           bra  LF4BD          ; branch

   LF4B9:  ldaa #0x64          ; load a with value -01100100-
   LF4BB:  andb #0xfb          ;  -11111011-
   LF4BD:  stab BitFlags_7f    ; store b into memory
           andb #0x04          ;  -00000100-
           staa Temp5          ; store a into memory
           ldaa Z83_PortAdata    ; load a with memory contents
           anda #0xfb          ; AND a with value -11111011-
           aba                 ; a=a+b
           staa Z83_PortAdata
           ldab Z83_PortADataDirection    ; load b with memory contents
           orab #0x04          ;  -00000100-
           stab Z83_PortADataDirection    ; store b into memory
           ldab #0x0b          ; load b with value -00001011-
   LF4D6:  decb            
           bne  LF4D6          ; branch if not equal (not zero)
           ldaa Temp5          ; load a with memory contents
           std  Z22_Timer6840_4
           ldab BatteryVolts    ; load b with memory contents
           cmpb #0xa2          ;  -10100010-
           bcs  LF4EC          ; branch if lower
           ldab Z83_PortADataDirection    ; load b with memory contents
           andb #0xfb          ;  -11111011-
           stab Z83_PortADataDirection    ; store b into memory
   LF4EC:  rti                 ; return from interrupt

;  ______________________
; |                      \
; |   Modifications      |
; \______________________|

UseCELForKnockIndication_MM:
        ; first, need to check that the option is enabled...
        ; added 11/07, RCL
        ; modifed to eliminate use of CHEMReserved

        ldaa CONFIG_ConfigurationFlags
        bita #cfg_FlashCE   ; check the bit for the CE Flash mod
        beq  CEReturn        ; branch if the bit is not set, ie not enabled

        ldaa BitFlags_82
        bmi  CEReturn        ; don't do this if Engine Not Running
        ldaa CoolantTemp
        cmpa KNKMIN_FlashCEMinTemp
        bcs  CEReturn        ; don't do this if cold motor (otherwise a LOT of false positives)

        ldab CPU_Port1_ControlRegister
        ldaa Cylinder4Retard
        anda #0x3f
        bne  CELightOn     ; not zero, turn on power loss light
        ldaa Cylinder2Retard
        anda #0x3f
        bne  CELightOn     ; not zero, turn on power loss light
        ldaa Cylinder1Retard
        anda #0x3f
        bne  CELightOn     ; not zero, turn on power loss light
        ldaa Cylinder3Retard
        anda #0x3f
        bne  CELightOn     ; not zero, turn on power loss light
CELightOff:
        andb ~#0x20 ; clear the CE Light bit
        bra  CEStore
CELightOn:
        orab #0x20 ; set the CE Light bit
CEStore:
        stab CPU_Port1_ControlRegister
CEReturn:
        rts

; ********************************
; Alky Injection Control Routines
; ********************************

; ********************
; pump control routine
; ********************

; AlkyPump_Control_MM:
; 
;         ldaa CONFIG_ConfigurationFlags
;         bita #cfg_AlkyInj           ; check the bit for Alky Injection
;         beq  AlkyPump_Return        ; branch if the bit is not set, ie not enabled
;         bita #cfg_ShiftLight        ; check the bit for Speed Sensitive Aero
;         bne  AlkyPump_Return        ; branch if the bit is set, can't run both of these routines
; 
;         ldaa MapValue
;         ldab Z83_CPU_Port1_copy
;         cmpa AKPMON_AlkyPumpOnSetpointFromMAP
;         bcs  AlkyPump_CheckHysteresisAndTurnOff ;if MAP is    lower than the setpoint, see if it's lower than the 'off' point
;         andb ~#CPU_Port1_PurgeEGR ;or whichever output you're going to use, this sets the bit to turn on the pump
;         jmp  AlkyPump_Return
; 
; AlkyPump_CheckHysteresisAndTurnOff:
;         cmpa AKPMOF_AlkyPumpOffSetpointFromMAP
;         bcc  AlkyPump_Return ; MAP is still higher than the 'off' setpoint
;         orab #CPU_Port1_PurgeEGR ;turn off the pump
; 
; AlkyPump_Return:
;         stab Z83_CPU_Port1_copy
;         rts

; ************************
; injector control routine
; ************************
;        .msg "..." ; these are just messages to display during assemble to let you know what's going on...

; AlkyInjector_Control_MM:
; 
; ; first, check to see if inj1 is already on, if it is, then check to see if it needs to be turned off, then maybe check inj2 turn on
;         ldaa CONFIG_ConfigurationFlags
;         bita #cfg_AlkyInj           ; check the bit for Alky Injection
;         beq  AlkyInj_Return        ; branch if the bit is not set, ie not enabled
;         bita #cfg_ShiftLight    ; check the bit for Speed Sensitive Aero
;         bne  AlkyInj_Return        ; branch if the bit is set, can't run both of these routines
; 
;         ldab Z83_CPU_Port1_copy
;         orab ~#CPU_Port1_CruiseVent ;clear all bits in AccB except for this one
;         andb ~#CPU_Port1_CruiseVent
;         bne  AlkyInj1_CheckHysteresisAndTurnOff ;branch if the bit for inj1 is set
; 
; ;inj1 is not already on, so check the MAP level
; 
;         ldaa MapValue
;         cmpa AKI1ON_AlkyInj1OnSetpointFromMAP
;         bcs  AlkyInj1_CheckHysteresisAndTurnOff ;if MAP is lower than the setpoint, see if it's lower than the 'off' point
;         andb ~#CPU_Port1_CruiseVent ;or whichever output you're going to use, this sets the bit to turn on inj 1
;         jmp  AlkyInj_Return
; 
; AlkyInj1_CheckHysteresisAndTurnOff:
;         cmpa AKI1OF_AlkyInj1OffSetpointFromMAP
;         bcc  AlkyInj_Return ; MAP is still higher than the 'off' setpoint
;         orab #CPU_Port1_CruiseVent ;turn off inj 1
;         stab Z83_CPU_Port1_copy
; 
; AlkyInj_CheckInj2:
;         ldaa MapValue
;         cmpa AKI2ON_AlkyInj2OnSetpointFromMAP
;         bcs  AlkyInj2_CheckHysteresisAndTurnOff ;if MAP is lower than the setpoint, see if it's lower than the 'off' point
;         andb ~#CPU_Port1_CruiseVac ;or whichever output you're going to use, this sets the bit to turn on inj 2
;         jmp  AlkyInj_Return
; 
; AlkyInj2_CheckHysteresisAndTurnOff:
;         cmpa AKI2OF_AlkyInj2OffSetpointFromMAP
;         bcc  AlkyInj_Return ; MAP is still higher than the 'off' setpoint
;         orab #CPU_Port1_CruiseVac ;turn off inj 1
; 
; AlkyInj_Return:
;         stab Z83_CPU_Port1_copy
;         rts

; ************************
; Anti-lag Retard Routine
; ************************

CalculateAntiLagRetard_Routine_MM:
        ldaa 0x00                   ; load 0x00 into A, default anti-lag retard
; check that the option is enabled...
        ldab CONFIG_ConfigurationFlags
        bitb #cfg_AntiLag
        beq  AntiLag_return       ;return if not enabled ; anti-lag retard = 0
; check the conditions for anti-lag - 1st check for the staging limiter, then for WOT, then for negative MAP
        ldab BitFlags_7f
        bitb #b7f_bit5            ;using this bit to tell that the limiter is active - for the anti-lag retard
        bne  L3000                ;branch if the bit is set; if set, ignore the WOT requirement, otherwise check for WOT
        ldab BitFlags_81
        lsrb ;bitb #b81_FullThrottle
        bcc  AntiLag_return       ; return if not WOT ; anti-lag retard = 0
L3000:  ldab BoostTarget            ; load the target boost
        subb MapValue             ; subtract the actual MAP value
        bcs  AntiLag_return	  ; branch if greater or equal - no need for antilag ; anti-lag retard = 0
        tba                       ; move DeltaMAP to A for the lookup
        ldx  #ANTLAG_AntiLagRetardfromBoostTargetDelta   ; load index with value
        jsr  Lookup4ByteTable          ; call:
        lsra                      ; divide result by 2
        lsra                      ; divide result by 2
        lsra                      ; divide result by 2 - total dived by 8

AntiLag_return:
        staa AntiLagRetard        ; store the antilag retard
        rts

; ************************
; Shift Light Control Routine
; ************************

ControlShiftLight_Routine_MM:
        ldaa Counter_MainLoop1          ; load a with memory contents
        bita #0x20
        bne  ShiftLight_return          ; branch if not equal (not zero)
        ldab CONFIG_ConfigurationFlags
        bitb #cfg_ShiftLight
        beq  ShiftLight_return          ; return if not enabled
        ldaa BitFlags_82                 ; load a with memory contents
        bmi  ShiftLight_return          ; branch if b82_EngineNotRunning set - Engine Not Running (hi bit 1)

ShiftLight_Run:
        ldab Z83_CPU_Port1_copy
        ldx  EngineRpm_HB
        cpx  SLRPM_ShiftLightSetpoint
        bcs  ShiftLight_OFF             ; if RPM is lower than the setpoint, clear bits to turn light off
ShiftLight_ON:
        orab #CPU_Port1_PurgeEGR            ; turn on the light
        stab Z83_CPU_Port1_copy
        jmp  ShiftLight_return

ShiftLight_OFF:
        andb ~#CPU_Port1_PurgeEGR           ; turn off the light
        stab Z83_CPU_Port1_copy

ShiftLight_return:
        rts
        
; ************************

        .org	0xff00
ShelSoftCopyrightNotice:
        .str   "Turbonator mods and brand Copr. 2011 Rob Lloyd"
        .byte  0x00, 0x00
        .str   "Turbonator LM v13"
        .byte  0x00, 0x00


        .org	0xffa0
ChryslerCopyrightNotice:
	.str   "COPR. 1985 CHRYSLER CORP."
        .byte  0x00, 0x00

        .org 0xfff0
IRQ2sioV:
	.word	ResetRoutine
IRQ2timerOverV:
	.word	ResetRoutine
IRQ2timerOutV:
	.word	IRQtOut
IRQ2timerInV:
	.word	InterruptFromDistributorSyncAndSpeedSensor
IRQ1strobe3V:
	.word	IRQ1strobe3
SWIVector:
	.word	ResetRoutine
NMIVector:
	.word	NMIInterrupt
ResetVector:
	.word	ResetRoutine

        .msg "Complete."
