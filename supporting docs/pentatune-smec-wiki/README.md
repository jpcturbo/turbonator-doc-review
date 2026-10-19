# Chrysler Turbo ECU Tuning Knowledge Base

A comprehensive reference for tuning 1985-1995 Chrysler turbo vehicles equipped with LM, SMEC, SBEC, and FCC engine controllers.

## Purpose

This knowledge base serves as a one-stop resource for:
- Understanding how Chrysler turbo ECUs work
- Learning ECU tuning concepts and techniques
- Reference documentation for file formats and memory maps
- Hardware modification and chip programming guides

Designed for both human readers and LLM assistants working on ECU tuning software.

## Contents

### ECU Fundamentals
- [ECU Overview](ecu-fundamentals/overview.md) - ECU types, generations, and capabilities
- [Main Program Loop](ecu-fundamentals/main-loop.md) - Complete 11ms loop call sequence and timing
- [Startup and Initialization](ecu-fundamentals/startup-initialization.md) - Reset-path register setup, RAM clearing, COP servicing, and handoff into the 11 ms loop
- [Interrupt Handlers](ecu-fundamentals/interrupt-handlers.md) - Distributor, speedometer, RTI, and PIA interrupt ownership and timing paths
- [68HC11 Architecture](ecu-fundamentals/68hc11-architecture.md) - CPU architecture and memory map
- [Memory Map Reference](ecu-fundamentals/memory-map.md) - Complete address space documentation
- [Sensors and Inputs](ecu-fundamentals/sensors.md) - MAP, TPS, CTS, O2, and other sensors
- [Sensor Processing and Derived State](ecu-fundamentals/sensor-processing.md) - Baro scheduling, temperature filtering, TPS state, and limp-in sensor substitutes

### Tuning Guide
- [Fuel System](tuning/fuel-system.md) - Speed-density calculations, fuel tables, modifiers
- [Idle and AIS Control](tuning/idle-control.md) - Idle target selection, AIS stepping, decel airflow, and special idle modes
- [Ignition Timing](tuning/ignition-timing.md) - Advance tables, knock control, spark scatter, timing calculations
- [Boost Control](tuning/boost-control.md) - Wastegate control, T1 vs T2 algorithms, overboost protection
- [Adaptive Systems](tuning/adaptive-systems.md) - O2 3-band feedback, adaptive memory, knock learning
- [Engine Protection](tuning/engine-protection.md) - Fuel cut, overboost, rev limiting, hysteresis, and shutdown gating
- [Engine State and Emissions Control](tuning/engine-state-and-emissions.md) - Park-neutral state, ASD relay logic, purge solenoid, and EGR control
- [Launch Control](tuning/launch-control.md) - Staging limiter, spark cut patterns, anti-lag, WB2NB
- [Cruise Control](tuning/cruise-control.md) - Vacuum servo speed control system
- [PTU Control](tuning/ptu-control.md) - Part Throttle Unlock torque converter management
- [Computed View Editing](tuning/computed-view-editing.md) - 3D/heatmap views, influence zones, editing workflow
- [Computed View Troubleshooting](tuning/computed-view-troubleshooting.md) - Common issues and solutions
- [Tuning FAQ](tuning/faq.md) - Common questions and answers

### File Formats
- [File Format Overview](file-formats/overview.md) - TPL, MPT, BIN, LST, ASM relationships
- [TPL/MPT Format](file-formats/tpl-mpt.md) - Template and project file specification
- [BIN Format](file-formats/bin.md) - Binary ROM image format
- [LST Format](file-formats/lst.md) - Bootloader listing files

### Hardware
- [ECU Modification](hardware/ecu-modification.md) - Socketing and chip swap procedures
- [Chip Selection](hardware/chip-selection.md) - EPROM, EEPROM, and flash chip options
- [Flash Modules](hardware/flash-modules.md) - BoostButton and other flash solutions
- [Bootstrap Protocol](hardware/bootstrap-protocol.md) - Serial communication for programming
- [Charging System](hardware/charging-system.md) - Alternator field control, target battery voltage, and charging-fault detection
- [DRB-II Diagnostics](hardware/diagnostics.md) - Actuator tests, sensor readout, fault code procedures

### Tools
- [MPTune](tools/mptune.md) - Primary tuning software
- [D-Cal](tools/dcal.md) - Binary editor 
- [Chip Burning](tools/chip-burning.md) - Programming chips with Willem burners

### Reference
- [ASM Routine Coverage Matrix](reference/asm-routine-coverage.md) - Frozen source inventory and owner-page backlog for remaining ASM documentation
- [Diagnostic Routines Reference](reference/diagnostic-routines.md) - Error processing, component verification, CEL logic, and code escalation flow
- [Table Reference](reference/table-reference.md) - Complete reference for all 521 calibration tables
- [Fault Codes](reference/fault-codes.md) - Complete fault code list (codes 11–55) with conditions
- [Fuel System Flow](reference/fuel-system-flow.md) - Fuel calculation flow diagrams
- [Spark System Flow](reference/spark-system-flow.md) - Spark timing flow diagrams
- [Boost System Flow](reference/boost-system-flow.md) - Boost control flow diagrams
- [Address Lookup](reference/address-lookup.md) - Common calibration addresses
- [Offset Calculator](reference/offset-calculator.md) - BIN to chip offset calculations
- [Glossary](reference/glossary.md) - Terms and abbreviations

## Quick Reference

### ECU Types by Vehicle Year

| Year | ECU Type | BIN Size | Notes |
|------|----------|----------|-------|
| 1985-87 | LM (Logic Module) | 16KB | Motorola 6803 CPU |
| 1988 | SMEC | 16KB | 68HC11, Turbo I/II |
| 1989 | SMEC | 16KB/32KB | T1=32k, T2=16k |
| 1990-91 | SBEC | 32KB | Uses 87C257 with latch |
| 1992-93 | SBEC II | 32KB | Some factory flashable |
| 1994-95 | FCC | 64KB | Factory flashable |

### Critical Memory Regions

| Region | Address | Action |
|--------|---------|--------|
| Calibration Data | 0x8000-0x8FFF | Edit with tuning software |
| EEPROM | 0xB600-0xB7FF | **SKIP during flash** |
| Interrupt Vectors | 0xFFD6-0xFFFF | Must be at end of ROM |

### File Relationships

```
┌─────────────┐     ┌─────────────┐
│   .asm      │     │   .tpl      │
│  (firmware) │  +  │(calibration)│
└──────┬──────┘     └──────┬──────┘
       │                   │
       └───────┬───────────┘
               │
          Assembler
               │
               ▼
        ┌─────────────┐
        │    .bin     │
        │ (ROM image) │
        └─────────────┘
```

## Contributing

This documentation is maintained as part of the PentaTune project. Sources include:
- TurboMopar forums knowledge base
- BoostButton documentation
- Community contributions from Rob Lloyd, Chad Clendening, and others

## External Resources

- [TurboDodge Forums](https://www.turbododge.com/)
- [TurboMopar Forums](https://www.turbo-mopar.com/)
- [Turbonator Wiki](https://shelbydodge.com/turbonator-wiki/)
- [MPSuite](https://sites.google.com/site/mpsuite/)
