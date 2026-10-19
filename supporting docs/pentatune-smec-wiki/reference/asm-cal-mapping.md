# ASM-to-Calibration Mapping Reference

**Firmware**: T-SMEC_v19.asm (1989 Turbonator SMEC v19)
**Purpose**: Cross-reference of 68HC11 assembly routines to their calibration data dependencies

---

## Overview

The `T-SMEC_v19.asm` firmware contains assembly routines that operate on calibration data stored in ROM. This guide maps the major functional routines to their table, constant, and RAM variable dependencies. Use this reference when modifying calibration values to understand which routines will be affected.

Each routine entry lists:
- **ASM Line**: Approximate line number in the source file
- **Calibration Tables Used**: ROM tables/constants read by the routine
- **RAM Variables**: Runtime variables written or read

---

## Routine-to-Data Mapping Tables

### Spark Timing

| Routine | ASM Line | Calibration Tables Used | RAM Variables |
|---------|----------|------------------------|---------------|
| `CalculateSparkAdvance_MM` | ~7856 | DWELL, TMPSWP, CLDMAP, CLDLMT, WOTMAP, HOTMAP, ADVCLS, PNIDLE, PNRPM, RPMLMT, GOVNER, ARRPM, ARMAP, ARMPIC, MAPMUL, SPKLMT, ADVDFT, SPKSET | CalculatedSparkAdvance, Temp0, Temp1, DwellTime_HB |
| `HandleSparkScatter` | 8032 | SSTEMP, SSITIM, SSIPRD, SPKRET, SPKADD, FTUNPW, AISHLM | SparkScatter, Temp5, DesiredNewAisPosition, BitFlags_55 |
| `CalculateKnockRetard_MM` | 8151 | KNKRPM, KLMRPM, THRKNK, KNKLIM, RETMAX, DLTKNK, INCSRT | MaxRetardFromMAP, KnockSensorThreshold, Cylinder1Retard-Cylinder4Retard |
| `CalculateSparkCutandAntiLagRetard_Routine` | 10132 | OPTN2, ANLGRP, ANTLAG, SPKFRC, LNCBDT, LNCPDT | Turbonator_Flags, Pattern_SparkCut, Counter_SparkCut |

**Notes**:
- `CalculateSparkAdvance_MM` is the main spark timing calculation. It selects cold vs warm tables, applies 3D RPM+MAP calculation, clamps to limits, and includes adaptive retard.
- `HandleSparkScatter` only activates when engine temp > `SSTEMP` and vehicle speed < `SSIPRD`.
- `CalculateSparkCutandAntiLagRetard_Routine` runs from the distributor interrupt and can substitute anti-lag timing or implement rotating spark cut.

---

### Fuel System

| Routine | ASM Line | Calibration Tables Used | RAM Variables |
|---------|----------|------------------------|---------------|
| `CalculateInjectorPulsewidthForStarting_MM` | 5483 | SFCOLD, SFCDRY, SFCVHT, FLOODCLR | BatteryVolts, CoolantTemp, InjectorPulsewidth_HB |
| `CalculateSumOfAllFuelModifiers_MM` | 5929 | CURVEC, CURVEA, CURVEB, FCRCVB, HIGHMP/HIGHM2, HMPMUL/HMPMU2, BAROCP, AIRTMP, PEFTBL | SumOfFuelModifiers_HB, ValueFromAdaptiveMemory, Counter_PrimaryAndSecondaryRamp, Factor_ACVDCY |
| `CalculatePartThrottleEnrichmentAndSparkScatterFuel_MM` | 5777 | RPMMAP, PTENR, PTELMT, PTEADJ, PTENRD, PTENUM | Timer_OpenLoopFraction, Counter_FallingEdgeEPP_MaxFF |
| `CalculatePartThrottleTransientFuel_MM` | 6330 | LMAPTC, THRTCN, LOTIME, DCELTM, POSTIG, POSFUL | Pulsewidth_PartThrottleEnrichment_HB, Timer_O2InhibitSwitchingRichIdleToClosedLoop, Factor_DecelLeanoutWhenMAPDecreasing, Factor_DecelLeanoutWhenThrottleDecreasing |
| `TransFuel_*` helper family | 6354-6498 | MAPTRG, MAPMAX, AESLOP, DECTRG, DTRG2, DECEL, POSTRG, THRMAX, POSSLP, LOTHYS, LOTTRG, LOTRG2, LOTTHR | Temp2, Temp3, AverageMAPValue, AverageTPSVolts, Block_MAP, Block_TPS |

**Notes**:
- Part throttle enrichment uses an EPP-based (events per period) counter system to gradually transition between fuel maps.
- The `RPMMAP` table sets the RPM threshold for switching between enrichment modes.

---

### Boost Control

| Routine | ASM Line | Calibration Tables Used | RAM Variables |
|---------|----------|------------------------|---------------|
| `CalcTargetBoost_MM` | 9347 | WSGRPM, WSGTIM, WSGCLT, WSGCHG, MXSBST, WSGPRT, STGBST, LOWBST | BoostTarget, Temp4, Timer_BoostTimer |
| `CalcWGDutyCycle_MM` | 9430 | OPTN2 | CurrentWastegateDutyCycle, BoostTarget |
| `CalcWGDutyCycleT1` | 9436 | MAPPT2, DCWOT, DCWADJ, DCWBST, KDCINC, KDCMAX, KDCMIN, DCDECK, DCRPM1-DCRPM3, MAPPT | CurrentWastegateDutyCycle, WastegateDutyCycleIncreaseFromKnock, Timer_Over5PsiBoostMaxFF, Timer_BoostErrTimer |
| `WGDC_AdjustWGDutyCycle` | 9494 | (clamping helper, no direct tables) | Temp4 |
| `WGDC_CalculateWGDutyCycleVars` | 9509 | DCWOT, DCWADJ, DCWBST, RPMBST, KDCINC, KDCMAX, KDCMIN, DECTIM, DCDECK, MAPPT, DCCOR1-DCCOR5, DCRPM1-DCRPM3 | CurrentWastegateDutyCycle, WastegateDutyCycleIncreaseFromKnock, Timer_BoostTimer |
| `WGDC_UpdateAdaptiveWGControlMemory` | 9648 | DCCOR1-DCCOR5, DECLIM, INCLIM | Timer_BoostErrTimer, CurrentWastegateDutyCycle, Temp4 |
| `CalcWGDutyCycleT2` | 9679 | T2KNOKMP, T2RPMBST, T2RATLIM, T2PRTMAX, T2MPDEL, T2RESFAC, UPRLIM, LWRLIM, T2DCWOT, T2DCWADJ, T2DCWBST, T2KDCINC, T2KDCMAX, T2KDCMIN | CurrentWastegateDutyCycle, BoostDelta_Signed, PreviousBoostOverBaro, WastegateDutyCycleIncreaseFromKnock |
| `InterruptVector_TimerOC2_Wastegate` | 9965 | (interrupt uses calculated WGDC only) | CurrentWastegateDutyCycle, Temp5, CPU_Timer_OC2_Wastegate, PIA1_B_Buffer |
| *(Boost target selection)* | ~9690+ | WSGRPM, WSGTIM, WSGCLT, WSGCHG, MXSBST, WSGPRT | BoostTarget, Temp3, Temp4 |

**Notes**:
- `WGDC_AdjustWGDutyCycle` is a utility routine that clamps duty cycle adjustments to 0-0xC8 (0-100%) range.
- The main boost control logic looks up base duty cycle from `DCWOT`, then applies RPM adjustment (`DCWADJ`) and boost target delta adjustment (`DCWBST`).
- Adaptive WGDC cells (`DCCOR1-DCCOR5`) are selected based on MAP (`MAPPT`) and RPM boundaries (`DCRPM1-3`).
- Knock events increase WGDC via `KDCINC` up to `KDCMAX`, decaying through `DCDECK`.

---

### Launch Control

| Routine | ASM Line | Calibration Tables Used | RAM Variables |
|---------|----------|------------------------|---------------|
| `LaunchControl_MM` | 10050 | OPTN2, STGRON, STGROF, STGTPS, STGSPD | Turbonator_Flags, Counter_SparkCut, Pattern_SparkCut |

**Notes**:
- Checks `OPTN2` for `opt_StageLim` enable flag.
- If enabled via switch (`STGSWS`) or speed-only mode, checks TPS > `STGTPS` and speed < `STGSPD`.
- RPM hysteresis: fuel/spark cut above `STGROF`, restore below `STGRON`.
- Can disable fuel (`opt_FuelRevLim`) and/or spark (`opt_SprkRevLim`) independently.

---

### PTU Control

| Routine | ASM Line | Calibration Tables Used | RAM Variables |
|---------|----------|------------------------|---------------|
| `PTU_LookupPTUParam` | 10414 | PTUUUL, PTULUL, PTUULL, PTULLL, PTUCNH, PTUCNL | Counter_PartThrottleUnlock, Temp4 |

**Notes**:
- PTU (Part Throttle Unlock) controls torque converter lockup based on speed lookups.
- The routine uses `Lookup4ByteTable` with speed as input, comparing against upper/lower limits for unlock/lock decisions.
- `PTUCNH`/`PTUCNL` set the countdown timer for part-throttle unlock duration.

---

### Adaptive Systems

| Routine | ASM Line | Calibration Tables Used | RAM Variables |
|---------|----------|------------------------|---------------|
| *(AutoCal cell update)* | ~6200+ | DCCOR1-DCCOR5, MAPPT, DCRPM1-3, MP1-MP5, R1, DLTMAP, DLTRPM, CELCHG, AMUPDT, AMUPDI, CALTHR, MAPLIM, MAPDEC, RPMLIM, PWMIN, AMLIMH, AMLIML | AdaptiveCell0-12, PointerIntoAdaptiveMemory |
| *(Adaptive retard)* | ~7948 | ARRPM, ARMAP, ARMPIC | AdaptiveRetardIndex |

**Notes**:
- Adaptive memory is organized into 13 cells (0-12) based on RPM and MAP boundaries.
- Cell boundaries: `MP1-MP5` for MAP, `R1` for RPM, with hysteresis (`DLTMAP`, `DLTRPM`).
- Update rate controlled by `AMUPDT` (open throttle) and `AMUPDI` (closed throttle).
- Range of authority: `AMLIMH` (max), `AMLIML` (min).
- Adaptive retard tables (`ARRPM`, `ARMAP`) are scaled by `AdaptiveRetardIndex` (RAM 0x002B factor: 0, 1/4, 1/2, 3/4, 1).

---

### Diagnostics

| Routine | ASM Line | Calibration Tables Used | RAM Variables |
|---------|----------|------------------------|---------------|
| `ProcessErrorBits_WorkWithData_MM` | 4464 | ErrorBitManipulation_Table | BitFlags_47, BitFlags_45, ErrorBitsAssociatedWithPIA1AndReg1eTo25_HB/LB |
| `CheckIfCheckEngineLightShouldBeOn_MM` | 4549 | (fault display logic, no direct tables) | DRBPointer1, Counter_MainLoop, PIA1_A_Buffer |
| `UpdateErrorTimersAndPossiblyClearErrors_MM` | 4592 | (timer-driven clear logic) | ErrorCodeUpdateKeyOnCount, ERRORCODERESETTIMERIN_UN_ERRORCODEIN_LN_VAR, Timer_ThermostatDiagnostics |
| `CheckForErrorsAndSetCodes_MM` | 4668 | ERRTMP, ERRRPM, ERRMAP | CoolantTemp, EngineRpm_HB, MapValue, b46_MajorFault |
| `ThrowMajorErrorIfRequired_MM` | 4702 | (critical error escalation, no direct tables) | b46_MajorFault, b47_AisFail, b50_BadO2 |
| `VerifyOperationOfIgnitionCoilDriver_MM` | 4720 | (battery threshold literals only) | BatteryVolts, PIA1_A_Buffer, pia2a_CoilDriverSense |
| `VerifyOperationOfFuelInjectorDrivers_MM` | 4744 | (injector on-time threshold literal) | BatteryVolts, TimerControlReg1, InjectorPulsewidth1_HB, InjectorPulsewidth2_HB, b46_InjectorFault |
| `VerifyOperationOfMapSensor_MM` | 4830 | MPVACD, BAROSW, MAPHIG, MAPLOW | BaroPressure, MapValue, RawMapVolts, b45_MapStuck, b45_MapBadSignal |
| `VerifyOperationOfThermostat_MM` | 4965 | TDAGTP, HOTIME | CoolantTemp, Timer_ThermostatDiagnostics |
| `VerifyOperationOfASDRelayAndO2Sensor_MM` | 4992 | O2MIDL, O2MIDH | Timer_O2MiddleDiagnostics, B1VoltageSwitch, b50_BadO2 |
| `VerifyOperationOfIgnitionCoilDriver2_MM` | 5087 | COILHI, COILLO | BatteryVolts, MapValue, MapVolts, BitFlags_53 |
| `DRBIISerialCommunications_MM` | 3511 | BAUDLO, DRBSerialToggles | DRBPointer1, DRBPointer2, DRBSerialMode |

**Notes**:
- Handles DRB-II scanner serial communication protocol.
- Sets baud rate from `BAUDLO` constant.
- Uses a state machine with `DRBSerialMode` and pointer variables to process test requests.
- Routes to actuator tests, sensor readouts, and memory dump functions based on `DRBPointer1`.

---

## Memory Map Quick Reference

| Region | Address Range | Contents |
|--------|--------------|----------|
| Calibration Data | 0x8000–0x8FFF | All tunable tables and constants |
| EEPROM | 0xB600–0xB7FF | Persistent adaptive memory, fault codes |
| RAM (variables) | 0x0000–0x00FF | Runtime variables, flags, counters |
| CPU Registers | 0x1000–0x103F | 68HC11 on-chip registers |
| Interrupt Vectors | 0xFFD6–0xFFFF | Must be at end of ROM |

---

## Calibration Data Organization

The calibration data at 0x8000 contains:

- **Fuel tables**: WOTTBL, N/T, P/T, F/T curves
- **Timing tables**: CLDMAP, HOTMAP, WOTMAP, GOVNER, RPMLMT, SPKLMT
- **Boost tables**: DCWOT, DCWADJ, DCWBST, WSGRPM, WSGTIM, etc.
- **Adaptive tables**: PRIRMP, SECRMP (O2 ramps), DCCOR1-5 (WGDC), AutoCal cells
- **Constants**: Thresholds, timers, limits, switch points

All table addresses in this document are offsets from 0x8000. For absolute ROM addresses, add 0x8000 to the listed offset.

---

## Cross-Reference by Table

| Table | Used By Routines | System |
|-------|-----------------|--------|
| WOTTBL | Fuel calculation | Fuel |
| CLDMAP/HOTMAP/WOTMAP | CalculateSparkAdvance_MM | Spark |
| GOVNER | CalculateSparkAdvance_MM | Spark |
| RPMLMT/SPKLMT | CalculateSparkAdvance_MM | Spark |
| RETMAX/KNKLIM | CalculateKnockRetard_MM | Spark |
| SPKADD/SPKRET | HandleSparkScatter | Spark |
| DCWOT/DCWADJ/DCWBST | WGDC_CalculateWGDutyCycleVars | Boost |
| KDCINC/KDCMAX/KDCMIN | WGDC_CalculateWGDutyCycleVars | Boost |
| WSGRPM/WSGTIM/WSGCLT | Boost target selection | Boost |
| STGRON/STGROF | LaunchControl_MM | Launch |
| PTUUUL/PTULUL | PTU_LookupPTUParam | PTU |
| DCCOR1-5 | WGDC adaptive updates | Adaptive |
| ARRPM/ARMAP | CalculateSparkAdvance_MM | Adaptive |
| AISTEP/AISHLM | AisDriveRoutine, idle/AIS control | Idle |
| AISCLD/AISPN/FWDAIS/REVAIS | CalculateTargetIdleSpeedAndAisPosition_MM | Idle |
| IDLADD | DIN_ACLRDBOUT_CALCULATE_BASEDON_IDLE_ERROR_ROUTINE | Idle |
| BRPMLO/BRPMHI/BARTIM | HandleBaroReadRequirement_MM, ReadBaroIfPossible | Sensor processing |
| BAROHI/BAROLO/BARDFT | SaveBaroPressure | Sensor processing |
| THRLOW/THRHIG/WOTDLT | CheckThrottleRoutine_MM | Sensor processing |
| ERRTMP/ERRRPM/ERRMAP | CheckForErrorsAndSetCodes_MM | Diagnostics |
| MPVACD/BAROSW/MAPHIG/MAPLOW | VerifyOperationOfMapSensor_MM | Diagnostics |
| O2MIDL/O2MIDH | VerifyOperationOfASDRelayAndO2Sensor_MM | Diagnostics |
| PURTMP/PURHYS/PURMAP | ControlPurgeSolenoid_MM | Engine state and emissions |
| EGR1/EGR3-EGR9/EGR14-EGR19/EGR33 | ExhGasRecirc_MM | Engine state and emissions |
| DFRPMH/DFRPML/MPSHFT/MPSHFA | ControlEngineCutout_MM | Engine protection |
| REVLMT2/REVLMT4/REVLMT6 | ControlEngineCutout_MM | Engine protection |

---

### Idle and AIS Control

| Routine | ASM Line | Calibration Tables Used | RAM Variables |
|---------|----------|------------------------|---------------|
| `AisDriveRoutine` | 1361 | AISTEP, AISHLM | CurrentAisPosition, DesiredNewAisPosition, PIA1_B_Buffer, b47_AisFail |
| `CalculateAisPosition_MM` | 1837 | DANOM, TIMEDC, TEMPDC, DAACF, MAPFLR, MPTEMP, BARFLR, DCLRFQ, DCLMIN, DCLMN2, DAISOP, DAISCL, DCALTM, DATHOT, DCALRT, DADRPM, CALRAT, CALPOS | MapValue, BaroPressure, CoolantTemp, DesiredNewAisPosition, Timer_DacalCountdown |
| `KickUpAisBy2DuringDecel_MM` | 1981 | (uses current idle state, no direct tables) | CurrentAisPosition, DesiredNewAisPosition, BitFlags_50, BitFlags_51 |
| `CalculateTargetIdleSpeedAndAisPosition_MM` | 1997 | DCLMER, DCLMCT, MPHREF, DCLRPL, DCLRPH, DCAISI, BARAIS, AISCLD, AISPN, TIMED2, IDLDEF, DECAIS, ISPDCY, RPMTHS, RPMDEF, AISTRT, ACCTIM, FWDAIS, REVAIS, AISFRQ, CLDPOS, AISLMH, AISLML, AISHLM | TargetIdleSpeed_HB, DesiredNewAisPosition, Timer_AisDelay, Timer_CountdownFromStartRunForAisFeedback, Timer_DecelFuelCut |
| `StoreAndLimitDesiredAisPosition` | 2500 | AISHLM | DesiredNewAisPosition |
| `DealWithSpecialIdle_SetBasicTiming_MM` | 5750 | RIDLST, RICHSA, O2ITIM | Counter_PrimaryAndSecondaryRamp, Counter_AdaptiveMem_Erase, Timer_O2InhibitSwitchingRichIdleToClosedLoop |
| `DIN_ACLRDBOUT_CALCULATE_BASEDON_IDLE_ERROR_ROUTINE` | 5915 | IDLADD | TargetIdleSpeed_HB, EngineRpm_HB, SparkScatterFuelStabilizationValue_HB |

**Notes**:
- These routines own idle target selection, AIS motor stepping, decel airflow control, and the fuel-side companion to spark-scatter stabilization.
- `CalculateTargetIdleSpeedAndAisPosition_MM` and `CalculateAisPosition_MM` share the idle-state and startup-feedback timers that shape when the AIS may move normally.

---

### Sensor Processing and Derived State

| Routine | ASM Line | Calibration Tables Used | RAM Variables |
|---------|----------|------------------------|---------------|
| `HandleBaroReadRequirement_MM` | 1448 | BARTIM | Timer_BaroReadInterval, Timer_BaroReadRpmConditionsSatisfied, BitFlags_2d |
| `ReadBaroIfPossible` | 1473 | BRPMLO, BRPMHI, BRDLAY, BARTIM | BitFlags_51, Timer_BaroReadInterval, Timer_BaroReadRpmConditionsSatisfied |
| `SaveBaroPressure` | 1519 | BAROHI, BAROLO, BARDFT | BaroPressure, MapVolts |
| `SimulateMapReadingFromTps` | 4506 | LMPINN, MPLMOF, THROFF | EngineRpm_HB, TpsVolts, MINTHR_LowestSessionTPS, MapValue |
| `CheckAndFilterCoolantAndChargeTempSensors_MM` | 7531 | CHGLOW, CHGHIG, DEFCHG, TMPHIG, TMPLOW, TMPTL1, TMPTL2, DEFTMP, CHGTL1 | RawChargeTempVolts, RawCoolantTempVolts, ChargeTemp, CoolantTemp, BitFlags_4f |
| `DetermineIfWindowedBladeInSyncSensorOnDistributor_MM` | 7666 | (state-tracking helper, no direct tables) | BitFlags_51, CPU_PortA_DistRef, swp_DistSync |
| `CheckThrottleRoutine_MM` | 7695 | THRLOW, THRHIG, WOTDLT | TpsVolts, MINTHR_LowestSessionTPS, AverageTPSVolts, AverageMAPValue, BitFlags_4f, BitFlags_2e |
| `DetermineNumberOfOverflowsBetweenSpeedoPulses_MM` | 8315 | (timer-overflow helper, no direct tables) | PreviousVehicleSpeed_HB, Counter_TimerRegHalfOverflowBetweenSpeedoPulses, TimerOverflowsBetweenSpeedoPulses |
| `DetermineNumberOfOverflowsBetweenDistributorPulses_MM` | 9171 | (timer-overflow helper, no direct tables) | LastDistributorFallingEdgeTime, Counter_TimerPastHalfwayBetweenDistPulses, TimerOverflowsBetweenDistPulses |

**Notes**:
- The baro, temperature, throttle, and overflow helpers feed later fuel, spark, idle, and limp-in decisions even though they do not own those subsystems directly.
- `SimulateMapReadingFromTps` is a substitute-input routine, so downstream code still consumes `MapValue` while the source data has shifted to a TPS-derived path.

---

### Engine Protection

| Routine | ASM Line | Calibration Tables Used | RAM Variables |
|---------|----------|------------------------|---------------|
| `ControlEngineCutout_MM` | 5544 | DFRPMH, DFRPML, LMPSHF, MPSHFT, MPSHFA, TRNTM, REVLMT2, REVLMT4, REVLMT6, SPDRPM, SPDLMH, SPDRPM2, SPDLML | Turbonator_MainFuelOff, Turbonator_DecelFuelCut, Turbonator_OverRev, Timer_OverboostCountdown, EngineRpm_HB, MapValue, BaroPressure |
| `Cutout_CheckNormalOB` | 5593 | MPSHFT, MPSHFA, TRNTM | Timer_OverboostCountdown, MapValue, BaroPressure |
| `Cutout_SetOBCodeAndShutdown` | 5604 | (fault throw path, no direct tables) | Turbonator_MainFuelOff, Turbonator_OverRev |
| `Cutout_CheckRevLimiters` | 5609 | REVLMT2, REVLMT4, REVLMT6, SPDRPM, SPDLMH | EngineRpm_HB, Temp1, Turbonator_OverRev |
| `Cutout_UseHysteresisToDetermineWhenToTurnFuelBackOn` | 5668 | DFRPML, MPSHFT, MPSHFA, REVLMT, REVLMT3, REVLMT5, SPDRPM2, SPDLML | Turbonator_MainFuelOff, Turbonator_DecelFuelCut, Turbonator_OverRev, Timer_OverboostCountdown |
| `GetControlFeedback_DetermineIfShutdownRequired_MM` | 9215 | (hardware countdown logic, no direct tables) | KeyOnOrEngineRunningTime, TimerOverflowsBetweenDistPulses, PIA2_B_Buffer |

**Notes**:
- The cutout family mixes decel fuel cut, overboost protection, rev limiting, and restore hysteresis in one owner routine family.
- `GetControlFeedback_DetermineIfShutdownRequired_MM` is included here because it gates shutdown state, even though the visible logic is hardware-feedback based rather than calibration-heavy.

---

### Engine State and Emissions

| Routine | ASM Line | Calibration Tables Used | RAM Variables |
|---------|----------|------------------------|---------------|
| `ControlAsdRelay_MM` | 1535 | (literal time and voltage thresholds only) | DRBPointer1, Counter_TimerPastHalfwayBetweenDistPulses, KeyOnOrEngineRunningTime, PIA1_A_Buffer, BitFlags_51 |
| `ControlPurgeSolenoid_MM` | 1785 | PURTMP, PURHYS, PURMAP | CoolantTemp, BaroPressure, MapValue, PIA1_A_Buffer, Counter_PrimaryAndSecondaryRamp |
| `ExhGasRecirc_MM` | 5320 | EGR1, EGR3-EGR9, EGR14-EGR19, EGR33 | EGRVar1-EGRVar7, PIA1_A_Buffer, BitFlags_2d, BitFlags_46 |
| `DetectParkNeutral_MM` | 8959 | CONFIG_ConfigurationFlags | StartupSwitchMirror2, BitFlags_0c, BitFlags_50 |

**Notes**:
- These routines establish engine state, relay gating, purge control, and EGR state that later diagnostics and fuel-cut logic depend on.
- `DetectParkNeutral_MM` is configuration and switch driven, while the purge and EGR routines depend on calibration thresholds and live engine state.

---

### Charging System

| Routine | ASM Line | Calibration Tables Used | RAM Variables |
|---------|----------|------------------------|---------------|
| `ControlAlternator` | 1277 | (literal RPM, voltage, and duty masks only) | ATMOffset, EngineRpm_HB, BatteryVolts, TargetBatteryVolts, Timer_AlternatorDutyCycle, BitFlags_47, BitFlags_54, BitFlags_56, PIA2_PortB_DataDirection |
| `TurnAlternatorOn` | 1326 | (field-output helper, no direct calibration tables) | PIA2_PortB_DataDirection, BitFlags_47, BitFlags_56 |
| `TurnAlternatorOff` | 1339 | (field-output helper, no direct calibration tables) | PIA2_PortB_DataDirection |
| `DetermineTargetBatteryVoltage_MM` | 1637 | AMBLOW, AMBHIG, CCDBTV | AmbientAirTempVolts, CPU_EEPROMControlReg, TargetBatteryVolts, Temp0 |
| `VerifyOperationOfBatteryVoltage_MM` | 4528 | (run-time and low-voltage literals only) | BatteryVolts, BitFlags_45, BitFlags_54, KeyOnOrEngineRunningTime |
| `DetectAlternatorFault_MM` | 4638 | BTLRPM | BatteryVolts, TargetBatteryVolts, BitFlags_45, BitFlags_54, Counter_MainLoop, EngineRpm_HB |

**Notes**:
- `ControlAlternator` and the `TurnAlternatorOn` or `TurnAlternatorOff` helpers are hardware-output routines, so the visible calibration dependency is limited to threshold literals and the target-voltage byte prepared elsewhere.
- `DetermineTargetBatteryVoltage_MM` is the only charging routine in this family that clearly consumes named calibration constants. The later diagnostic checks compare live voltage against that computed target.

---

### Startup and Initialization

| Routine | ASM Line | Calibration Tables Used | RAM Variables |
|---------|----------|------------------------|---------------|
| `SetupSystemRegisters` | 4914 | (register setup literals only) | CPU_SysConfigOptionReg, CPU_HighPriorityInterruptMask, CPU_PulseAccumulatorControl, CPU_TimerInterruptMask2, CPU_OutputCompare1Mask, BitFlags_2e, CPU_BlockProtReg, CPU_TimerControlReg1, CPU_TimerForceCompare |
| `ZeroRamFrom0EtoFE` | 7200 | (startup seeding path, no direct calibration tables) | INTERRUPT_COUNTER_VAR, MapVolts, MapValue, AverageMAPValue, Counter_SparkCut, CPU_A2DControlReg, CPU_SerialBaudRate, PIA1 and PIA2 setup state |
| `ResetCopTimer` | 7289 | (COP service helper, no direct calibration tables) | CPU_ArmResetCopTimerReg, PIA2_PortB_ControlRegister |
| `SetupSystemAndGoToMainLoop` | 7298 | (startup state path, no direct calibration tables) | BitFlags_AIS, PIA1_PortA_DataDirection, PIA1_A_Buffer, Timer_DelayBeforeUpdating_MINTHR, BitFlags_4f, CPU_TimerControlReg2, BitFlags_54, BitFlags_50, StartupSwitchMirror1, StartupSwitchMirror2, RawAmbientAirTempVolts, RawCoolantTempVolts, RawChargeTempVolts |

**Notes**:
- These routines prepare hardware state, RAM, and first-sample sensor bytes for the foreground loop rather than consuming the main fuel, spark, or boost calibration tables.
- `ZeroRamFrom0EtoFE` and `SetupSystemAndGoToMainLoop` still matter to calibration work because they seed the early MAP, baro, battery, TPS, and startup-flag state that later owner pages assume already exists.

---

### Interrupt Handlers

| Routine | ASM Line | Calibration Tables Used | RAM Variables |
|---------|----------|------------------------|---------------|
| `InterruptVector_DistributorSignal` | 6502 | (dispatch path, uses prepared state only) | ATMOffset, DRBPointer1, Temp6, SwitchPortAccessReg, Counter_TimerPastHalfwayBetweenDistPulses |
| `Interrupt_HandleDistributorRisingEdge` | 6558 | (consumes previously prepared fuel, spark, and boost state) | BitFlags_55, MapValue, Counter_TimerPastHalfwayBetweenDistPulses, InjectorPulsewidth_HB, CPU_TimerControlReg2 |
| `CALC_SPARK_RETARD_BASED_ON_KNOCK_VOLT` | 6714 | KnockSensorThreshold, RTRDRT, RTRDRT2, MaxRetardFromMAP | KnockVolts, Cylinder1Retard, Cylinder2Retard, Cylinder3Retard, Cylinder4Retard, BitFlags_55 |
| `SUM_ADDITIONAL_RETARD` | 6735 | RTRDRT, RTRDRT2 | Temp5, Cylinder1Retard, Cylinder2Retard, Cylinder3Retard, Cylinder4Retard |
| `MAX_RETARD` | 6740 | MaxRetardFromMAP | Temp5, Cylinder1Retard, Cylinder2Retard, Cylinder3Retard, Cylinder4Retard |
| `CalculateInjectorPulsewidthForEngineRunning` | 6773 | N/T, MAPTBL, WOTTBL, SumOfFuelModifiers_HB | InjectorPulsewidth_HB, BitFlags_54, EngineRpm_HB, MapValue, Counter_PrimaryAndSecondaryRamp |
| `Interrupt_HandleDistributorFallingEdge` | 6867 | (timing path uses prepared state only) | DistributorFallingEdgePulsewidth_HB, LastDistributorFallingEdgeTime, Counter_TimerPastHalfwayBetweenDistPulses, AntiDwellTime_HB, MapVolts, BitFlags_47 |
| `HandleFuelStartRunStartTransfer` | 6906 | (start-run threshold path, no direct calibration tables) | BitFlags_54, Timer_AisDelay, Counter_AdaptiveMem_Erase, BitFlags_55, DistributorFallingEdgePulsewidth_HB |
| `ReadKnockSensorAndRecalcSparkPosition` | 7013 | CalculatedSparkAdvance, KnockSensorThreshold, SPKRET, SPKADD | KnockVolts, CalculatedSparkAdvance, CurrentSparkAdvance, DwellTime_HB, Temp5 |
| `Interrupt_RealTime` | 7145 | (recovery path, no direct calibration tables) | L0000, BitFlags_AIS, MapVolts, MapValue, AverageMAPValue, CPU_SerialControlReg, PIA2 state |
| `InterruptVector_SpeedometerSignal` | 8204 | (speed-sensor path, no direct calibration tables) | VehicleSpeed_HB, PreviousVehicleSpeed_HB, SpeedoSensorPulsewidth_HB, TimerOverflowsBetweenSpeedoPulses, BitFlags_56 |
| `InterruptVector_PIA_Signal` | 9189 | (ignition-feed feedback path, no direct calibration tables) | CountdownTimerFromKeyOn, TimerOverflowsBetweenDistPulses, PIA2_PortB_DataDirection |

**Notes**:
- Most interrupt entries consume state the foreground loop already prepared, so the mapping emphasis here is on the handoff points where interrupt-time code reads fuel, spark, and knock-related bytes.
- `CalculateInjectorPulsewidthForEngineRunning` and the knock-retard helpers are the direct calibration-touching members of this family. The top-level vector and capture handlers mostly move timing and phase state around them.

---

### Hardware Diagnostics and DRB Helpers

| Routine | ASM Line | Calibration Tables Used | RAM Variables |
|---------|----------|------------------------|---------------|
| `SetupHiSpeedDataTransfer` | 3659 | BAUDHI | DRBSerialMode, DRBPointer1, CPU_SerialStatus, CPU_SerialBaudRate |
| `SetupATM` | 3670 | ATMFunctionTable | TimerOverflowsBetweenDistPulses, BitFlags_55, DRBPointer1, DRBPointer2, ATMOffset |
| `SendDiagnosticDataToSCI` | 3693 | DRBMemoryTable, RealTimeDataTable | DRBPointer2, BitFlags_4f |
| `SendMemoryLocToSCI` | 3707 | DRBMemoryTable | DRBPointer2 |
| `SendRealTImeDatatoSCI` | 3717 | RealTimeDataTable | DRBPointer2 |
| `SendECUIDToSCI` | 3770 | ENDIT1, DRBPointer2 | DRBPointer1, DRBPointer2 |
| `InitByteModeDownload` | 3855 | (byte-mode enable helper, no direct calibration tables) | DRBSerialMode, DRBPointer1 |
| `ActuatorTestMode_MM` | 3894 | ATMFunctionTable | ATMOffset, DRBPointer1, PIA1_A_Buffer, KeyOnOrEngineRunningTime |
| `FlashCodesOutOnCEL` | 4116 | ErrorCodesToDash_Table | Counter_MainLoop, LastDistributorFallingEdgeTime, DRBPointer2, PIA1_A_Buffer |
| `DRB_UpdatePIA1AndCheckOuputs_MM` | 4253 | PIA1AManipulation_Table | PIA1_A_Buffer, PIA1_PortA_DataDirection, StartupSwitchMirror2, BatteryVolts, Counter_MainLoop, KeyOnOrEngineRunningTime |

**Notes**:
- The DRB helper family is table-driven. `ATMFunctionTable`, `DRBMemoryTable`, `RealTimeDataTable`, `ErrorCodesToDash_Table`, and `PIA1AManipulation_Table` are the key calibration-style data blocks that control dispatch or output handling.
- `DRBIISerialCommunications_MM` remains listed in the broader Diagnostics section because it is the main-loop serial entry path, while these helper rows cover the deeper service-mode routines documented on the hardware page.

---

## See Also

- [ASM Routine Coverage Matrix](asm-routine-coverage.md) - Frozen source inventory and canonical owner-page coverage for the remaining ASM routine backlog.
- [Memory Map](../ecu-fundamentals/memory-map.md) - Complete ECU memory layout
- [Table Reference](table-reference.md) - Detailed table descriptions and formulas
- [68HC11 Architecture](../ecu-fundamentals/68hc11-architecture.md) - CPU and register reference
- [Diagnostic Routines Reference](diagnostic-routines.md) - Error-processing and component-verification owner page for the diagnostic family
- [Charging System](../hardware/charging-system.md) - Alternator field control, target-voltage calculation, and charging-fault ownership
- [Startup and Initialization](../ecu-fundamentals/startup-initialization.md) - Reset-path and watchdog-service owner page for the startup chain
- [Interrupt Handlers](../ecu-fundamentals/interrupt-handlers.md) - Distributor, speedometer, RTI, and PIA interrupt ownership
- [DRB-II Diagnostics](../hardware/diagnostics.md) - Service-mode, actuator-test, and SCI helper owner page
- [Spark System Flow](spark-system-flow.md) - Spark calculation flow diagrams
- [Fuel System Flow](fuel-system-flow.md) - Fuel calculation flow diagrams
- [Boost System Flow](boost-system-flow.md) - Boost control flow diagrams
