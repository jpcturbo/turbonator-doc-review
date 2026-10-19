# Glossary

Terms and abbreviations used in Chrysler turbo ECU tuning.

---

## A

**Adaptive Memory**
EEPROM-stored corrections that the ECU learns over time to compensate for engine variations.

**ADC (Analog to Digital Converter)**
Hardware that converts analog sensor voltages to digital values (0-255) for ECU processing.

**AFR (Air-Fuel Ratio)**
Ratio of air mass to fuel mass in the combustion mixture. Stoichiometric for gasoline is 14.7:1.

**AIS (Automatic Idle Speed)**
Stepper motor that controls idle air bypass. Also called IAC (Idle Air Control).

**ASM**
Assembly language source code file for ECU firmware.

---

## B

**Baro (Barometric Pressure)**
Atmospheric pressure, used for altitude compensation. Read at key-on before engine starts.

**BIN**
Binary file containing ROM image. The actual data burned to memory chip.

**Bootstrap Mode**
Special CPU mode allowing code upload to RAM via serial port. Used for flash programming.

**BTDC (Before Top Dead Center)**
Timing measurement. Positive values indicate spark occurs before piston reaches top.

---

## C

**Cal / Calibration**
The tunable data portion of ECU programming (tables, constants, thresholds).

**Closed-Loop**
Operating mode where ECU adjusts fuel based on O2 sensor feedback.

**Codebase**
The executable firmware portion of ECU programming (routines, calculations).

**CTS (Coolant Temperature Sensor)**
Thermistor measuring engine coolant temperature.

---

## D

**D-Cal**
Binary editor software for Chrysler ECU calibrations.

**DRB (Diagnostic Readout Box)**
Chrysler's factory scan tool.

---

## E

**EEPROM (Electrically Erasable PROM)**
Memory that can be erased electrically without UV light.

**EPROM (Erasable PROM)**
Memory chip erased by UV light exposure.

---

## F

**F/T (Full Throttle)**
Fuel table used when WOT condition is detected.

**FCC (Flexible Chassis Controller)**
ECU used in 1994-1995 Neon. Factory flashable.

**Flash Memory**
Electrically erasable memory with sector-based erase. Modern alternative to EPROM.

**FTDI**
Manufacturer of USB-to-serial chips. FTDI-based cables work best with MPTune.

---

## G

**GUI (Graphical User Interface)**
Visual software interface with windows, buttons, tables.

---

## H

**Hall Effect**
Type of sensor using magnetic field changes. Used in distributor pickup.

**HEP (Hall Effect Pickup)**
Distributor sensor providing RPM and timing reference.

---

## I

**IAC (Idle Air Control)**
See AIS.

**Interrupt**
Hardware event that pauses normal code execution to run special handler routine.

---

## K

**Knock**
Abnormal combustion (detonation) that can damage engine. Detected by knock sensor.

**Knock Retard**
Timing reduction applied when knock is detected.

---

## L

**Limp-In Mode**
Reduced-function operating mode when critical sensor fails. Fixed timing and fuel.

**LM (Logic Module)**
1985-1987 ECU. Uses Motorola 6803 CPU.

**LST**
Listing file containing assembled machine code. Used for bootloader routines.

---

## M

**MAP (Manifold Absolute Pressure)**
Sensor measuring intake manifold pressure. Primary load input for speed-density systems.

**MPT**
MPTune project file. Used to edit existing .bin files.

**MPTune**
Primary tuning software for Chrysler turbo ECUs.

---

## N

**N/T (No Throttle)**
Fuel table used when throttle is closed (idle, decel, coast).

---

## O

**O2 Sensor (Oxygen Sensor)**
Exhaust sensor measuring oxygen content. Used for closed-loop fuel control.

**Open-Loop**
Operating mode without O2 sensor feedback. Uses calibration values directly.

**Overboost**
Condition where boost pressure exceeds safe limit. Triggers fuel cut protection.

---

## P

**P/T (Part Throttle)**
Fuel table used when throttle is partially open (cruising, light load).

**PIA (Peripheral Interface Adapter)**
I/O chip for controlling outputs (injectors, spark, etc.).

**Pump Shot / Pumpshot**
Extra fuel added during rapid throttle opening (acceleration enrichment).

**PumpEff (Pumping Efficiency)**
Table representing engine volumetric efficiency vs. RPM.

**PW (Pulsewidth)**
Duration of injector opening time, typically in milliseconds.

---

## R

**RAM (Random Access Memory)**
Volatile memory for runtime variables. Cleared at power-off.

**ROM (Read-Only Memory)**
Non-volatile memory containing code and calibration.

**RPM (Revolutions Per Minute)**
Engine speed measurement.

---

## S

**SBEC (Single Board Engine Controller)**
1990-1991 ECU. Uses 68HC11 CPU with 87C257 chip.

**SBEC II**
1992-1993 ECU. Some versions factory flashable.

**SCI (Serial Communications Interface)**
Diagnostic port on ECU. Used for scanning and flash programming.

**SMEC (Single Module Engine Controller)**
1988-1989 ECU. Uses 68HC11 CPU.

**Speed-Density**
Fuel control method estimating airflow from MAP, RPM, and air temperature.

**Stoichiometric**
Chemically ideal AFR (14.7:1 for gasoline) where all fuel and oxygen are consumed.

---

## T

**T1 (Turbo I)**
2.2L turbocharged engine (non-intercooled in early years).

**T2 (Turbo II)**
2.2L turbocharged intercooled engine.

**TBL**
Table file for D-Cal containing address and scaling information.

**TPL**
Template file for MPTune containing calibration data and metadata.

**TPS (Throttle Position Sensor)**
Potentiometer measuring throttle blade angle.

**Turbonator**
Modified firmware with enhanced features (T-SMEC, T-SBEC, etc.).

---

## U

**UV (Ultraviolet)**
Light wavelength used to erase EPROM chips.

---

## V

**VE (Volumetric Efficiency)**
Measure of how well engine breathes. Actual airflow vs. theoretical maximum.

---

## W

**Wastegate**
Valve that bypasses exhaust around turbine to control boost pressure.

**WOT (Wide Open Throttle)**
Full throttle condition. Triggers use of F/T fuel table and WOT timing.

---

## Z

**ZIF (Zero Insertion Force)**
Socket type with lever mechanism. Allows unlimited chip insertions without wear.

---

## Numeric

**68HC11**
Motorola 8-bit microcontroller used in SMEC/SBEC/FCC.

**6803**
Motorola 8-bit microcontroller used in Logic Module.

**27C256**
32KB UV-erasable EPROM.

**27SF512**
64KB flash memory chip.

**87C257**
32KB EPROM with integrated address latch. Used in SBEC.
