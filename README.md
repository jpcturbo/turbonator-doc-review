# Turbonator AI Review

Analysis, calibration reference database, documentation generator, and interactive web viewer for Chrysler Turbo ECU calibrations (Logic Module, SMEC, SBEC, and related electronic control modules).

---

## Overview

This project provides a complete reference suite for Chrysler Turbo calibrations, mapping raw assembly code (`.asm`) and calibration templates (`.tpl`) into structured descriptions, tuning guides, and an interactive local web portal.

### Key Components

- **Calibration Data**: Source calibrations for Chrysler LM-87, SMEC, SBEC, SBECII, and T3 platforms in `cals/`.
- **Builder Tools**: Python scripts in `tools/` that parse calibration templates, assemble descriptions, and generate static HTML documentation in `output/T-LM-web/`.
- **Local Server**: A lightweight zero-dependency Node.js HTTP server (`tools/server.js`) to view and navigate generated calibration documentation locally.
- **Supporting Documentation**: Technical datasheets, microprocessor manuals (6803, 68HC11), and tuning theory in `supporting docs/`.

---

## Requirements

### Python Requirements
- **Python**: 3.8 or higher
- **Dependencies**:
  ```bash
  pip install -r requirements.txt
  ```
  *(Only `markdown` is required for HTML generation; standard library modules `os`, `sys`, `json`, `re`, and `shutil` are used for parsing and builds).*

### Node.js Requirements
- **Node.js**: 16.x, 18.x, 20.x, or higher
- **Dependencies**: Zero external `npm` packages required. The built-in standard modules (`http`, `fs`, `path`, `child_process`) are used by the local server.

---

## Quick Start

### 1. Build Static Web Documentation
To generate the static calibration reference site from the descriptors:
```bash
python tools/build_t_lm_web.py
```

### 2. Launch Local Documentation Server
Run the local HTTP server to preview the site at `http://localhost:8080`:

**Using Node directly:**
```bash
node tools/server.js
```

**Using the batch file (Windows):**
Double-click `start-server.bat` or run:
```cmd
start-server.bat
```

---

## Project Structure

```text
├── cals/             # Source calibration templates (.tpl), binary roms, and assembly routines (.asm)
├── output/           # Generated static HTML site (T-LM-web), JSON descriptors, and portal assets
├── supporting docs/  # Microprocessor datasheets (6803, 68HC11) and tuning reference PDFs
├── tools/            # Python build scripts and local Node.js server
├── requirements.txt  # Python package requirements
├── start-server.bat  # Windows launcher for local web server
└── README.md         # Project documentation
```

---

## Repository

- **GitHub**: [https://github.com/jpcturbo/turbonator-ai-review](https://github.com/jpcturbo/turbonator-ai-review)
- **Author**: [jpcturbo](https://github.com/jpcturbo)
