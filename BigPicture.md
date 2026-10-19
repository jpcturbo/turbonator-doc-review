Agents, ignore this file. Do not read or modify this file.

# Big Picture

## Products

- json data file for each ECU type.
- html site wrapping up everything
  - TPL-updater.
  - Docs for all ECM types.
- TPL-updater conversion program
  - desktop? mabye with OTA.
  - web based
  - duplication of table descriptions check.

## maybe

- update asm files with comments
- NOPE: matrix of tpl files for engine upgrades.
    108 cals for upgrades * LM/SMEC/SBEC/SBECII * 2.2/2.5/atx/mtx (not lm) = 5184 + 216 = 5400 
    3 - injectors
    3 - throttle bodies
    2 - cams
    2 - exhaust
    3 - map sensors

## Backend design

- All identifier data in the structured json file. This is our DB.
- HTML generated from this JSON via Python Script.
- TPL-Updater updates TPL files from JSON file.
  - TPL-Updater checks for previous updates and overwrites as not to completely mess up the tpl file.
