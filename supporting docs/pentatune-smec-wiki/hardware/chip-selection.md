# Chip Selection

## Overview

Several memory chip types can be used in Chrysler turbo ECUs. Each has different characteristics affecting ease of use, cost, and durability.

## Chip Types

### EPROM (UV Erasable)

**Examples:** 27C128, 27C256

**Characteristics:**
- Ceramic package with quartz window
- Erased by UV light exposure
- Write-once until erased
- Very durable (millions of read cycles)

**Pros:**
- Very reliable
- Long data retention
- Widely available

**Cons:**
- Requires UV eraser (~$20-100)
- Erase time: 10-20 minutes
- Must be removed to erase
- Getting more expensive

### EEPROM (Electrically Erasable)

**Examples:** 29C256 (rare), 28C256

**Characteristics:**
- Plastic DIP package
- Erased electrically
- No UV required
- Limited write cycles (10,000-100,000)

**Pros:**
- No UV eraser needed
- Can be erased in programmer
- Fast erase/write

**Cons:**
- 28-pin DIP versions are rare/expensive
- Limited lifespan with frequent writes

### Flash Memory

**Examples:** 27SF512, 29F010

**Characteristics:**
- Plastic DIP package
- Electrically erasable
- Sector-based erase
- Good write endurance (100,000+ cycles)

**Pros:**
- Cheapest option currently
- No UV required
- Fast programming
- Good availability

**Cons:**
- May need specific programmer support
- Some chips need 12V for programming

## Chip Selection by ECU

### Logic Module

| Chip | Size | Notes |
|------|------|-------|
| 27C128 | 16KB | Original spec |
| 27C256 | 32KB | Requires offset |
| 27SF512 | 64KB | Cheapest, requires offset |

### SMEC

| Chip | Size | Notes |
|------|------|-------|
| 27C128 | 16KB | For 16KB bins only |
| 27C256 | 32KB | Most common |
| 29C256 | 32KB | EEPROM, rare now |
| 27SF512 | 64KB | Cheapest option |

### SBEC / SBEC II

**Factory Chip:** 87C257 (27C256 with integrated latch)

**Options:**
| Chip | Size | Notes |
|------|------|-------|
| 87C257 | 32KB | Direct drop-in |
| 27C256 | 32KB | Requires latch board |
| 27SF512 | 64KB | Requires latch board + offset |

**Note:** SBEC requires latch functionality. Use either:
- 87C257 (has built-in latch)
- Latch board adapter with standard chips
- Flash module (includes latch)

## Size Comparison

```
27C128 (16KB):
[████████████████] 0x0000-0x3FFF

27C256 (32KB):
[████████████████████████████████] 0x0000-0x7FFF

27SF512 (64KB):
[████████████████████████████████████████████████████████████████] 0x0000-0xFFFF
```

## Common Chip Specifications

### 27C256 (32KB EPROM)

| Parameter | Value |
|-----------|-------|
| Package | 28-pin DIP |
| Size | 32,768 bytes |
| Voltage | 5V read, 12.5V program |
| Speed | 150-250ns typical |
| Erase | UV light, 15-20 min |

**Programming:**
- Supported by nearly all programmers
- Standard algorithm

### 27SF512 (64KB Flash)

| Parameter | Value |
|-----------|-------|
| Package | 28-pin DIP |
| Size | 65,536 bytes |
| Voltage | 5V read, 12V program |
| Speed | 70-150ns typical |
| Erase | Electrical, sector or chip |

**Programming:**
- May need specific programmer support
- Check Willem compatibility

### 87C257 (32KB EPROM with Latch)

| Parameter | Value |
|-----------|-------|
| Package | 28-pin DIP |
| Size | 32,768 bytes |
| Voltage | 5V read, 12.5V program |
| Special | Built-in address latch |

**Note:** This is the ONLY standard option for SBEC without modifications.

## Where to Buy

### EPROMs
- eBay (new old stock)
- Electronics surplus stores
- Mouser/Digi-Key (limited selection)

### Flash Chips
- eBay (bulk from China, verify quality)
- Mouser/Digi-Key
- Electronics distributors

### 87C257
- eBay (getting rare)
- Electronics surplus
- Expect to pay premium

## UV Erasers

If using EPROMs, you'll need a UV eraser:

**Commercial Eraser ($50-100):**
- Enclosed chamber
- Timer
- Safe operation
- 10-15 minute erase time

**Handheld UV Wand ($15-25):**
- "Germicidal" UV lamp
- No enclosure (eye protection required!)
- 15-30 minute erase time
- Works but less convenient

**Note:** Regular fluorescent lights and sunlight won't erase EPROMs effectively. You need specific UV-C wavelength.

## Chip Offset Requirements

When using larger chips than the BIN file, you must offset the data:

| BIN Size | Chip Size | Offset |
|----------|-----------|--------|
| 16KB | 16KB | 0x0000 |
| 16KB | 32KB | 0x4000 |
| 16KB | 64KB | 0xC000 |
| 32KB | 32KB | 0x0000 |
| 32KB | 64KB | 0x8000 |

The offset ensures the end of your BIN aligns with the end of the chip (where interrupt vectors must be).

## Recommendations

### For Beginners
**27SF512** - Cheapest, no UV eraser needed, widely available

### For Frequent Changes
**Flash module conversion** - No chip swapping required

### For SBEC
**Flash module** OR **87C257** if you can find them

### For Reliability
**27C256** - Proven technology, very reliable

## Chip Quality

### New vs. Used
- New chips are increasingly rare
- Used chips from eBay are common
- Test before relying on used chips

### Verification
1. Program chip
2. Read back immediately
3. Compare to original file
4. All bytes must match

### Blank Check
Before programming, verify chip is blank:
- All bytes should be 0xFF
- If not, erase again
- Dirty chip = programming errors
