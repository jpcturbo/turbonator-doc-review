# File Format Overview

## Introduction

The Chrysler turbo ECU tuning ecosystem involves several file types that work together. Understanding how they relate is essential for creating and modifying calibrations.

## File Type Summary

| Format | Type | Purpose | Tools |
|--------|------|---------|-------|
| .asm | ASCII text | ECU firmware source code | Assembler, text editor |
| .tpl | ASCII text | Calibration template | MPTune |
| .mpt | ASCII text | Tuning project (edits existing bin) | MPTune |
| .bin | Binary | ROM image for chip | Burner, flash tools |
| .lst | ASCII text | Assembled bootloader code | MPTune (for flashing) |
| .tbl | ASCII text | Table file for D-Cal | D-Cal |
| .calx | ASCII text | Calibration file for CHeM2 | CHeM2 |
| .s19 | ASCII text | Motorola S-Record format | Bootloader |

## The Build Relationship

### Creating a New ROM

```
┌─────────────────────────────────────────────────────────┐
│                    t-smec_v19.asm                       │
│                   (ECU Firmware)                        │
│                                                         │
│  ┌─────────────────────────────────────────────────┐    │
│  │  Code Section                                   │    │
│  │  - Fuel calculation routines                    │    │
│  │  - Spark timing routines                        │    │
│  │  - Boost control                                │    │
│  │  - Idle control                                 │    │
│  │  - Diagnostics                                  │    │
│  │  ...                                            │    │
│  │  .include /CalDataFile/  ◄─── TPL inserted here │    │
│  │  ...                                            │    │
│  │  More code                                      │    │
│  └─────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
                            │
                            │  +
                            │
┌─────────────────────────────────────────────────────────┐
│                 calibration.tpl                         │
│              (Calibration Data)                         │
│                                                         │
│  - Fuel tables                                          │
│  - Timing tables                                        │
│  - Constants                                            │
│  - Thresholds                                           │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
                      ┌───────────┐
                      │ Assembler │
                      └─────┬─────┘
                            │
                            ▼
                    ┌─────────────┐
                    │   .bin      │
                    │ (32KB ROM)  │
                    └─────────────┘
```

### Editing an Existing ROM

```
┌─────────────────┐     ┌─────────────────┐
│  existing.bin   │     │   project.mpt   │
│   (ROM image)   │     │ (table layout)  │
└────────┬────────┘     └────────┬────────┘
         │                       │
         └───────────┬───────────┘
                     │
                     ▼
              ┌─────────────┐
              │   MPTune    │
              │  (Editor)   │
              └──────┬──────┘
                     │
                     ▼
              ┌─────────────┐
              │ modified.bin│
              │ (New ROM)   │
              └─────────────┘
```

## File Relationships Diagram

```
                    ┌─────────────┐
                    │   .asm      │
                    │ (firmware)  │
                    └──────┬──────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   .tpl      │    │   .lst      │    │ (defines)   │
│ (template)  │    │(bootloader) │    └─────────────┘
└──────┬──────┘    └──────┬──────┘
       │                  │
       │    ┌─────────────┤
       ▼    ▼             │
┌─────────────┐           │
│   .bin      │           │
│  (ROM)      │◄──────────┘  (used for flashing)
└──────┬──────┘
       │
       ├──────────────────┐
       ▼                  ▼
┌─────────────┐    ┌─────────────┐
│   .mpt      │    │   .tbl      │
│ (MPTune)    │    │  (D-Cal)    │
└─────────────┘    └─────────────┘
```

## When to Use Each Format

### Building from Template (.tpl + .asm)

**Use when:**
- Creating a new calibration from scratch
- Making changes that require code modifications
- Using Turbonator or modified firmware
- Want full control over calibration values

**Advantages:**
- Clean starting point
- Can modify code and calibration together
- Full MPTune feature support

### Editing Binary Directly (.bin + .mpt)

**Use when:**
- Modifying an existing known-good calibration
- Don't have original .tpl
- Quick changes to existing setup

**Advantages:**
- Preserves existing tuning work
- Faster for minor adjustments
- Don't need .asm file

### Using D-Cal (.bin + .tbl)

**Use when:**
- Prefer D-Cal interface
- Have existing .tbl files
- Simple scalar/table edits

**Limitations:**
- Cannot create new binaries from templates
- No template editing capability
- USB flash not supported

## Version Compatibility

### ASM Version Matching

The `.tpl` file header specifies which ASM version it's designed for:

```assembly
;mpassmfile t-smec_v19.asm
```

**This must match!** Using a TPL with the wrong ASM version can produce:
- Corrupt binaries
- Wrong addresses
- Missing parameters
- Non-functional ECU

### Template Versions

Templates evolve over time. Key differences may include:
- Different table layouts
- Added/removed parameters
- Changed scaling
- New features

Always verify template matches your ECU hardware and firmware version.

## File Storage Recommendations

### Organize by ECU Type
```
calibrations/
├── smec/
│   ├── templates/
│   ├── projects/
│   └── bins/
├── sbec/
│   └── ...
└── common/
    └── bootloaders/
```

### Version Control

Keep copies of:
- Original stock .bin files
- Working templates
- Known-good calibrations
- Changelog for modifications

### Naming Convention

Include key information in filenames:
```
{year}_{engine}_{injector}_{version}.{ext}
Example: 89T1_34lb_15psi_v2.bin
```
