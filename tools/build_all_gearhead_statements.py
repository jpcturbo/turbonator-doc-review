"""
tools/build_all_gearhead_statements.py

Comprehensive generator for gear-head operating condition statements across all
calibration descriptors in docs/t_lm_descriptors.json and docs/t_smec_descriptors.json.
"""

import json
import re
import os
import sys

def clean(s):
    if not s:
        return ""
    return re.sub(r'\s+', ' ', s).strip()

def strip_formatting(text):
    text = re.sub(r'[*_`#]', '', text)
    text = re.sub(r'\b0x[0-9A-Fa-f]+\b', '', text)
    text = re.sub(r'\$[0-9A-Fa-f]{2,4}\b', '', text)
    text = re.sub(r'\s+', ' ', text)
    return text.strip()

def extract_condition_from_text(overview, op_cond):
    ov = re.sub(r'(\d+)\.(\d+)', r'\1<DOT>\2', overview)
    sents = [clean(s.replace('<DOT>', '.')) for s in re.split(r'(?<=[.!?])\s+', ov) if s.strip()]
    
    # 1. Search for sentences starting with If / When / Whenever / Once / During / While / Under
    for s in sents[1:]:
        m = re.match(r'^(If|When|Whenever|Once|During|While|Under)\s+([^,]+),\s+(.+)', s, re.IGNORECASE)
        if m:
            lead = m.group(1).lower()
            cond = clean(m.group(2))
            act = clean(m.group(3)).rstrip('.')
            # Filter out tuning advice
            if not any(bad in cond.lower() for bad in ['you', 'tuner', 'increase', 'decrease', 'modify', 'adjust', 'set to', 'set this', 'raising', 'lowering', 'changes']):
                if len(act) > 10 and not any(bad in act.lower() for bad in ['catastrophic', 'fatal', 'destroy', 'damage the engine']):
                    return f"{lead} {cond}, {act}"
                    
    # 2. Search in sentence 1
    if sents:
        s1 = sents[0]
        s1_clean = re.sub(r'^[A-Za-z0-9_]+\s*(\([^)]*\))?\s*', '', s1).strip()
        m = re.search(r'\b(when|during|while|under|whenever|after|upon)\b\s+(.+)', s1_clean, re.IGNORECASE)
        if m:
            res = m.group(0).rstrip('.')
            if len(res) > 15:
                return res
                
    return ""

def synthesize_gearhead_statement(k, d):
    short_name = d.get('short_name', k)
    full_label = d.get('full_label', '')
    long_name = d.get('long_name', '')
    overview = d.get('overview', '')
    op_cond = d.get('operating_conditions', '')
    asm_code = d.get('technical_mechanics', {}).get('assembly_code', '')
    subsystem = d.get('metadata', {}).get('subsystem', '')
    units = d.get('metadata', {}).get('units', '')
    factory = d.get('metadata', {}).get('factory_setting', '')
    table_type = d.get('metadata', {}).get('table_type', '')

    k_upper = k.upper()
    fl_lower = full_label.lower()
    ln_lower = long_name.lower()
    ov_lower = overview.lower()
    op_lower = op_cond.lower()

    # --- SPECIFIC IDENTIFIER RULES (Common across LM & SMEC) ---

    # Exact overrides for specialized identifiers
    EXACT_MAP = {
        # A/C
        'ACCRPM': "Takes effect whenever engine speed exceeds 4,000 RPM with the air conditioning on, immediately disengaging the compressor clutch to protect against high-RPM mechanical damage.",
        'ACCTIM': "Takes effect immediately after engine startup when the dashboard A/C switch is turned on, holding off compressor clutch engagement for a brief delay until the engine reaches run mode and oil pressure stabilizes.",
        'ACLRPM': "Takes effect whenever engine RPM drops dangerously low near stall speed while the air conditioning is operating, cutting compressor clutch drag so the engine can catch and revive.",
        'ACOUT': "Takes effect during heavy or wide-open throttle acceleration, immediately disengaging the A/C compressor clutch to eliminate accessory drag and maximize engine power.",
        'ACDTHR': "Takes effect during part-throttle acceleration with the A/C on, requiring throttle position increase to exceed this threshold before disengaging the compressor clutch.",
        'ACDSPD': "Takes effect during part-throttle acceleration with the A/C on, ensuring the compressor is only cut out to assist vehicle acceleration below this road speed ceiling.",
        'ACDTMP': "Takes effect during part-throttle driving with the A/C on, ensuring compressor cutout is only permitted if engine coolant temperature is above this minimum operating temperature.",
        'ACAETH': "Takes effect during and immediately following throttle tip-in acceleration enrichment, keeping the A/C compressor clutch locked out for about 2.8 seconds to avoid hesitation.",
        'AC2KCK': "Takes effect at closed throttle when the A/C compressor clutch is commanded to engage, instantly stepping open the idle air motor to catch engine idle and prevent an RPM dip.",
        'AC3KCK': "Takes effect at closed throttle immediately after the A/C clutch engages under elevated intake manifold pressure (low vacuum), trimming the idle air step adder to prevent an idle surge.",
        'AC4KCK': "Takes effect at closed throttle just before the A/C clutch engages under elevated intake manifold pressure (low vacuum), fine-tuning the pre-engagement idle air kick.",
        'ACOFFK': "Takes effect at closed throttle the instant the A/C compressor clutch disengages, closing down the idle air bypass steps to prevent engine flare.",
        'ACCTBL': "Takes effect during off-idle driving while the A/C compressor is running, adding extra bypass airflow through the idle air motor based on vehicle road speed.",
        'ACPOS': "Takes effect during cold engine idle when the A/C is turned on, defining the baseline idle stepper motor opening when coolant temperature is low.",
        'ACTIME': "Takes effect when the A/C is turned on at idle, setting the ramp-in timer before the full idle airflow compensation is applied.",
        'ACERPM': "Takes effect during part-throttle driving with the A/C on, allowing compressor re-engagement once engine RPM climbs above this threshold.",
        'ACESPD': "Takes effect during part-throttle driving with the A/C on, allowing compressor re-engagement once vehicle speed exceeds this road speed limit.",
        'ACETIM': "Takes effect during part-throttle A/C cutout, capping the maximum continuous duration the compressor clutch can remain disengaged.",
        'ACTMP': "Takes effect during cold engine idle, establishing the coolant temperature threshold that switches between cold and warm A/C idle airflow compensations.",
        'ACLOWT': "Takes effect when ambient or evaporator temperature is freezing, locking out A/C compressor clutch engagement to prevent evaporator core freeze-up.",

        # Cooling Fan
        'FANTMP': "Takes effect when engine coolant temperature rises to this threshold (or at highway cruising speeds above 45 MPH), commanding the electric radiator cooling fan ON.",
        'FANTMP1': "Takes effect when engine coolant temperature rises to this threshold (or at highway cruising speeds above 45 MPH), commanding the electric radiator cooling fan ON.",
        'FANOFF': "Takes effect while the radiator cooling fan is running, shutting the electric fan OFF once coolant temperature drops back below this lower hysteresis threshold.",
        'FANTMP2': "Takes effect while the radiator cooling fan is running, shutting the electric fan OFF once coolant temperature drops back below this lower hysteresis threshold.",
        'FANTMP3': "Takes effect when driving in slow city traffic or idling below 35 MPH, commanding the radiator cooling fan ON once coolant temperature reaches this threshold.",
        'FANTMP4': "Takes effect while the radiator cooling fan is running at speeds below 35 MPH, shutting the fan OFF once coolant temperature drops below this lower hysteresis limit.",
        'FANBAT': "Takes effect when underhood battery tray temperature rises above this threshold, turning the radiator cooling fan ON to flush stagnant hot air from the engine bay.",
        'FANMAP': "Takes effect under positive turbo boost pressure, turning the cooling fan ON when manifold pressure exceeds barometric pressure by this amount to lower charge temperatures.",
        'AISFAN': "Takes effect at closed throttle when the electric cooling fan turns on, stepping open the idle air motor to compensate for the sudden alternator electrical load.",
        'FANDEL': "Takes effect during vehicle acceleration above 45 MPH, delaying fan deactivation until vehicle speed remains steady.",
        'FANSPD': "Takes effect during vehicle speed transitions, establishing the speed boundary separating low-speed and high-speed radiator fan temperature thresholds.",

        # Fuel Startup & Warmup
        'RNFPRD': "Takes effect during engine cranking, defining the engine speed threshold where the ECU transitions from cranking fuel into normal running mode.",
        'STFPRD': "Takes effect during engine coastdown or stall, defining the engine speed threshold where the ECU drops back from running mode into startup mode.",
        'PMPWOT': "Takes effect during engine cranking at wide-open throttle, commanding flood-clear fuel cutoff to clear flooded cylinders.",
        'SFDCAY': "Takes effect immediately when the engine catches and enters run mode, smoothly decaying heavy startup fuel enrichment down toward normal running fuel levels based on coolant temperature.",
        'STRFUL': "Takes effect while cranking the engine during starter engagement, establishing the baseline cranking injector pulsewidth across coolant temperature.",
        'STPW': "Takes effect while cranking the engine during starter engagement, establishing the baseline cranking injector pulsewidth across coolant temperature.",
        'FSTTBL': "Takes effect while cranking the engine during starter engagement, establishing the baseline cranking injector pulsewidth across coolant temperature.",
        'WARMUP': "Takes effect while the engine is warming up (coolant temperature below normal operating temperature), adding a warm-up fuel enrichment multiplier across coolant temperature.",
        'FWARM': "Takes effect while the engine is warming up (coolant temperature below normal operating temperature), adding a warm-up fuel enrichment multiplier across coolant temperature.",
        'TMBBAS': "Takes effect during engine warm-up driving, providing a time-based decay of warm-up fuel enrichment as combustion chambers warm.",
        'CLDHLD': "Takes effect during cold engine warm-up, establishing the hold time before cold fuel enrichment begins decaying.",
        'CCURV': "Takes effect during warm-up driving, establishing the hold time for warm-up enrichment curve C.",
        'CHGTBL': "Takes effect continuously across all running conditions, adjusting fuel delivery based on intake air charge temperature to compensate for air density changes.",
        'AIRTMP': "Takes effect continuously across all running conditions, adjusting fuel delivery based on intake air charge temperature to compensate for air density changes.",
        'CHGINC': "Takes effect during cold starts and warm-up, scaling the rate of charge temperature fuel decay.",
        'BAROCP': "Takes effect during cold starts and warm-up driving at altitude, adjusting warm-up fuel enrichment based on ambient barometric pressure.",
        'HOTHLD': "Takes effect when restarting a warm engine, establishing the hold time before hot startup fuel enrichment begins tapering down.",

        # Fuel Base & WOT
        'PEFTBL': "Takes effect continuously across all engine operating conditions once running, scaling base fuel delivery across engine RPM to match the engine's volumetric efficiency.",
        'INJFLW': "Takes effect as a fundamental calibration constant in all fuel pulsewidth calculations, defining the injector flow rating to scale injector opening times.",
        'FSLOPE': "Takes effect across all running fuel calculations, defining the fuel delivery slope constant converting calculated airflow into injector pulsewidth.",
        'BATOFF': "Takes effect continuously on every fuel injection pulse, adding battery voltage offset (dead time) to compensate for injector mechanical opening delays.",
        'FLPT1': "Takes effect during part-throttle cruising and light acceleration, establishing the manifold pressure fuel delivery curve.",
        'FLPT2': "Takes effect during part-throttle cruising and light acceleration, establishing the manifold pressure fuel delivery curve.",
        'TPTBL': "Takes effect during part-throttle driving, looking up base fuel pulsewidth across manifold pressure and engine speed.",
        'FLFT1': "Takes effect at wide-open throttle (WOT) under boost, providing the full-power fueling curve to ensure safe air-fuel ratios.",
        'FLFT2': "Takes effect at wide-open throttle (WOT) under boost, providing the full-power fueling curve to ensure safe air-fuel ratios.",
        'FTTIME': "Takes effect the moment the driver steps to wide-open throttle (WOT), setting the delay timer before full WOT power enrichment fuel is delivered.",
        'WOTPMP': "Takes effect upon entering wide-open throttle, delivering a dedicated WOT acceleration pump shot pulse to prevent lean tip-in hesitation.",
        'WOTDLT': "Takes effect during throttle opening, defining the throttle sensor voltage delta above minimum throttle required to trigger wide-open throttle mode.",
        'SECINJ': "Takes effect during secondary injector staging, defining the pulsewidth threshold where auxiliary fuel injectors begin firing.",
        'SBNRMP': "Takes effect across running fuel calculations, scaling selective bank fuel delivery across manifold pressure.",
        'FUELLEANOUTFACTOROFFTHROTTLE': "Takes effect during closed-throttle deceleration and coastdown, reducing base fuel delivery to lower tailpipe emissions and prevent exhaust popping.",
        'FUELLEANOUTFACTORONTHROTTLE': "Takes effect when transitioning back onto the throttle from deceleration, controlling the fuel recovery multiplier to prevent lean tip-in stumble.",
        'MAPIDL': "Takes effect at closed-throttle idle, establishing the baseline manifold pressure fuel lookup curve across engine vacuum.",

        # Fuel Transients & Decel
        'POSTRG': "Takes effect during rapid throttle opening (tip-in), triggering acceleration enrichment pump shot fueling when throttle delta exceeds this threshold.",
        'POSEST': "Takes effect during throttle tip-in acceleration, establishing the decay rate of the acceleration enrichment pump shot.",
        'PUMPTB': "Takes effect during rapid throttle opening, looking up the volume of acceleration enrichment fuel to inject based on throttle delta and coolant temperature.",
        'PSHMAX': "Takes effect during aggressive throttle tip-in, capping the maximum allowable acceleration enrichment pump shot pulsewidth.",
        'NEGTRG': "Takes effect when the throttle snaps shut or closes rapidly, triggering deceleration fuel leanout to prevent rich exhaust puffing.",
        'DMDCDC': "Takes effect when stepping back onto the throttle following deceleration, stepping down deceleration fuel leanout to restore normal fueling quickly without hesitation.",
        'DCLFUE': "Takes effect during closed-throttle deceleration, reducing fuel injection pulsewidth under high manifold vacuum to improve engine braking and emissions.",
        'DECEL': "Takes effect during closed-throttle deceleration, reducing fuel injection pulsewidth under high manifold vacuum to improve engine braking and emissions.",
        'DCLTIM': "Takes effect during closed-throttle deceleration, establishing the duration timer for deceleration fuel leanout.",
        'DFRPM1': "Takes effect during closed-throttle deceleration from high engine speed, restoring fuel injection once engine RPM drops below approximately 2,050 RPM to prevent engine stalling.",
        'DFRPM2': "Takes effect during closed-throttle deceleration, setting the upper RPM threshold above which deceleration fuel shutoff is armed.",
        'DFSMPH': "Takes effect during deceleration, ensuring deceleration fuel shutoff is only active when vehicle road speed is above this speed limit.",
        'DFSTMP': "Takes effect during closed-throttle coastdown, ensuring deceleration fuel shutoff is only enabled once the engine is warmed up above this coolant temperature.",
        'DFSTMR': "Takes effect during sustained closed-throttle deceleration, limiting the maximum continuous duration of deceleration fuel shutoff.",
        'DECHYS': "Takes effect during throttle transitions near deceleration thresholds, providing manifold pressure hysteresis to prevent erratic fuel switching.",
        'DECTRG': "Takes effect during closed-throttle deceleration, establishing the rate-of-throttle-drop trigger level for deceleration leanout.",
        'LOTRG1': "Takes effect during closed-throttle deceleration, establishing the primary rate-of-throttle-drop trigger level for deceleration leanout.",
        'LOTRG2': "Takes effect during aggressive throttle drop-off, activating a secondary, stronger deceleration leanout rate.",
        'DCELTM': "Takes effect following deceleration leanout, setting the lockout time before oxygen sensor closed-loop integration is allowed to resume.",

        # O2 Closed-Loop & Adaptives
        'O2HIGH': "Takes effect during oxygen sensor signal validation, setting the upper (rich) voltage threshold that verifies the O2 sensor is active and switching.",
        'O2LOW': "Takes effect during oxygen sensor signal validation, setting the lower (lean) voltage threshold that verifies the O2 sensor is active and switching.",
        'O2MIDH': "Takes effect during oxygen sensor diagnostic checks, identifying whether the sensor is stuck in the inactive mid-voltage range.",
        'O2MIDL': "Takes effect during oxygen sensor diagnostic checks, identifying whether the sensor is stuck in the inactive mid-voltage range.",
        'O2HSWP': "Takes effect in closed-loop cruise, establishing the rich-to-lean switching threshold for air-fuel ratio control.",
        'O2LSWP': "Takes effect in closed-loop cruise, establishing the lean-to-rich switching threshold for air-fuel ratio control.",
        'PRIRMP': "Takes effect during closed-loop operation, controlling the primary fuel trim ramp rate as the oxygen sensor switches.",
        'SECRMP': "Takes effect during closed-loop operation, controlling the secondary fuel trim ramp rate as the oxygen sensor switches.",
        'SCRMP1': "Takes effect during closed-loop operation, establishing the secondary O2 ramp rate under low-speed conditions.",
        'SCRMP2': "Takes effect during closed-loop operation, establishing the secondary O2 ramp rate under high-speed conditions.",
        'MP1': "Takes effect during adaptive fuel memory operation, defining the manifold pressure load boundary separating Cell 0/1 from Cell 2/3.",
        'MP2': "Takes effect during adaptive fuel memory operation, defining the second manifold pressure load boundary in the adaptive fuel grid.",
        'MP3': "Takes effect during adaptive fuel memory operation, defining the third manifold pressure load boundary in the adaptive fuel grid.",
        'MP4': "Takes effect during adaptive fuel memory operation, defining the fourth manifold pressure load boundary in the adaptive fuel grid.",
        'MP5': "Takes effect during adaptive fuel memory operation, defining the upper manifold pressure boundary in the adaptive fuel grid.",
        'R1': "Takes effect during adaptive fuel memory operation, defining the engine RPM boundary separating low-speed and high-speed adaptive fuel cells.",
        'RPMLIM': "Takes effect during closed-loop operation, setting the maximum engine RPM ceiling above which adaptive fuel updates and O2 feedback are disabled.",
        'DLTMAP': "Takes effect when operating near adaptive cell boundaries, providing manifold pressure hysteresis deadband to prevent erratic jumping between adjacent adaptive cells.",
        'DLTRPM': "Takes effect when operating near adaptive cell boundaries, providing engine RPM hysteresis deadband to prevent erratic jumping between adjacent adaptive cells.",
        'CELCHG': "Takes effect when transitioning between adaptive fuel cells, enforcing a delay timer before the new cell's adaptive trim begins updating.",
        'AMLIMH': "Takes effect whenever adaptive fuel trims are updated during driving, capping the maximum allowable positive enrichment to prevent runaway rich conditions.",
        'AMLIML': "Takes effect whenever adaptive fuel trims are updated during driving, capping the maximum allowable negative leanout to prevent excessive leaning.",
        'AMTEMP': "Takes effect during engine startup and warm-up, establishing the coolant temperature threshold that switches between hot and cold adaptive learning timers.",
        'AMTPSW': "Takes effect during engine startup and warm-up, determining the delay before closed-loop adaptive fuel memory updates are permitted.",
        'ADMEMA': "Takes effect continuously during running fuel calculation, applying a calibration offset adder to the learned adaptive fuel memory cell value.",
        'AMUPDI': "Takes effect during closed-throttle idle, setting the update interval between learned idle adaptive fuel trim adjustments.",
        'AMUPDR': "Takes effect during off-idle driving, setting the update interval between learned driving adaptive fuel trim adjustments.",
        'CLTIME': "Takes effect after engine startup, defining the delay timer across coolant temperature before closed-loop oxygen sensor feedback is enabled.",
        'O2DLAY': "Takes effect when entering closed-loop fuel control, establishing the settling delay before fuel trim adjustments begin.",

        # Spark & Knock
        'HOTMAP': "Takes effect during warm, part-throttle driving (engine coolant above operating temperature), establishing the primary manifold vacuum ignition advance curve.",
        'WARNTB': "Takes effect during warm, part-throttle driving, establishing the baseline ignition advance curve across manifold vacuum.",
        'BASADV': "Takes effect across normal running conditions, establishing the baseline distributor ignition timing reference.",
        'CLDMAP': "Takes effect during cold, part-throttle driving while the engine is warming up, providing extra ignition advance to assist cold combustion.",
        'CLDTBL': "Takes effect during cold, part-throttle driving while the engine is warming up, providing extra ignition advance to assist cold combustion.",
        'HOTWOT': "Takes effect at wide-open throttle (WOT) on a warm engine, defining baseline full-throttle ignition advance across engine RPM.",
        'WOTADV': "Takes effect at wide-open throttle (WOT) on a warm engine, defining baseline full-throttle ignition advance across engine RPM.",
        'MAPMUL': "Takes effect under manifold boost pressure, multiplying negative manifold pressure advance to retard ignition timing progressively as boost rises.",
        'KNKLIM': "Takes effect during rapid throttle tip-in at lower engine speeds, capping the maximum allowable transient knock retard the ECU can apply.",
        'KNKRPM': "Takes effect across all engine operating conditions, establishing the minimum engine RPM threshold required to enable piezoelectric knock sensor processing.",
        'RETMAX': "Takes effect under boost when knock occurs, establishing the maximum allowable ignition knock retard ceiling across manifold pressure.",
        'IDLADV': "Takes effect at closed throttle when the engine is idling, providing closed-loop ignition timing adjustments to stabilize idle speed.",
        'IDLWA': "Takes effect during closed-throttle idle, defining the calibration limits for idle ignition advance stabilization.",
        'SPKCTR': "Takes effect at closed throttle idle, regulating spark advance dithering to maintain a rock-solid idle RPM.",
        'SPKLMT': "Takes effect continuously across all operating conditions, enforcing an absolute ceiling on total ignition advance to protect the engine.",
        'CHGSPK': "Takes effect under elevated intake air charge temperatures, retarding ignition timing to protect against heat-soak detonation.",
        'CTMSPK': "Takes effect under extreme engine coolant temperatures, pulling ignition timing to protect an overheating engine from severe detonation.",
        'REVRPM': "Takes effect at high engine speed, cutting fuel injection or ignition spark when engine RPM reaches this rev limiter threshold to protect the engine from mechanical failure.",
        'RPMREV': "Takes effect at high engine speed, cutting fuel injection or ignition spark when engine RPM reaches this rev limiter threshold to protect the engine from mechanical failure.",
        'OVRREV': "Takes effect at high engine speed, cutting fuel injection or ignition spark when engine RPM reaches this rev limiter threshold to protect the engine from mechanical failure.",
        'REVLMT': "Takes effect at high engine speed, cutting fuel injection or ignition spark when engine RPM reaches this rev limiter threshold to protect the engine from mechanical failure.",
        'REVLMT3': "Takes effect as a runaway engine safety cutout if manifold pressure exceeds 75% of baro while the throttle idle contact is closed, limiting engine speed to 2,000 RPM.",
        'REVLMT4': "Takes effect at elevated engine RPM, establishing a secondary over-rev fuel shutoff threshold.",
        'REVLMT5': "Takes effect at elevated engine RPM, establishing a secondary over-rev fuel shutoff threshold.",
        'KDCINC': "Takes effect under boost when spark knock is detected, controlling the duty cycle reduction steps applied to the wastegate solenoid to bleed off boost.",
        'KDCMAX': "Takes effect under boost when spark knock is detected, capping the maximum total duty cycle reduction that knock protection can command.",
        'KDCMIN': "Takes effect immediately upon the initial detection of spark knock under boost, commanding an instant baseline wastegate duty cycle step drop.",
        'T2KDCMIN': "Takes effect immediately upon the initial detection of detonation under boost in T2 control, applying a baseline duty cycle reduction step.",
        'KNKMIN': "Takes effect during knock detection, ensuring the check engine light only flashes for knock events once engine coolant temperature is above this minimum operating threshold.",
        'ABCBAS': "Takes effect across engine speed and atmospheric pressure, applying barometric altitude advance compensation to optimize spark timing in thin air.",
        'ABCFBR': "Takes effect across ambient atmospheric pressure, scaling barometric ignition advance compensation based on altitude.",
        'ABCFRP': "Takes effect across engine RPM, scaling barometric altitude spark advance based on engine speed.",
        'ARCMSK': "Takes effect during adaptive knock retard processing, defining the timing counter mask that paces adaptive knock retard updates.",
        'ARCMS2': "Takes effect during adaptive knock retard processing, defining the timing counter mask that paces adaptive knock retard updates.",
        'ARCMS3': "Takes effect during adaptive knock retard processing, defining the timing counter mask that paces adaptive knock retard updates.",
        'SRTIME2': "Takes effect during cold engine startup, dictating how many engine revolutions must pass before the ECU transitions ignition timing from cranking to running mode.",

        # Boost & Wastegate Control
        'WSGRPM': "Takes effect during boost control, defining the primary target boost curve across engine RPM.",
        'WSGPRT': "Takes effect during part-throttle boost operation, scaling target boost based on throttle position to provide progressive boost modulation.",
        'WSGCHG': "Takes effect under elevated intake charge temperatures, lowering the target boost ceiling to prevent detonation when intake air is hot.",
        'WSGCLT': "Takes effect while the engine is cold or warming up, restricting allowable boost pressure until the engine reaches safe operating temperatures.",
        'WSGTIM': "Takes effect during sustained wide-open throttle boost, limiting peak overboost duration before stepping boost back to continuous levels.",
        'SWBSLO': "Takes effect when the dashboard switchable boost toggle is switched to low-boost mode, clamping maximum boost to this conservative ceiling.",
        'LOWBST': "Takes effect when the dashboard switchable boost toggle is switched to low-boost mode, clamping maximum boost to this conservative ceiling.",
        'DCWOT': "Takes effect at wide-open throttle under boost, defining the baseline wastegate duty cycle curve across manifold pressure.",
        'WGDC': "Takes effect at wide-open throttle under boost, defining the baseline wastegate duty cycle curve across manifold pressure.",
        'BASEWG': "Takes effect at wide-open throttle under boost, defining the baseline wastegate duty cycle curve across manifold pressure.",
        'DCWADJ': "Takes effect during full-throttle boost control, adjusting baseline wastegate duty cycle across engine RPM to compensate for turbine flow changes.",
        'BSOLCO': "Takes effect under boost when severe spark knock occurs, immediately de-energizing the wastegate solenoid to drop boost down to mechanical actuator spring pressure.",
        'WSGKNK': "Takes effect immediately following a spark knock event under boost, subtracting boost from the target boost ceiling and decaying the reduction back to normal over time.",
        'MPCORR': "Takes effect during closed-loop adaptive wastegate control, adjusting the adaptive duty cycle trim to maintain target boost without spiking.",
        'UPRLIM': "Takes effect during adaptive wastegate control, capping the maximum allowable positive duty cycle addition to prevent overboost.",
        'LWRLIM': "Takes effect during adaptive wastegate control, setting the maximum allowable negative duty cycle reduction to prevent underboost.",
        'INCLIM': "Takes effect during adaptive wastegate control, setting the upper clamp limit on incremental duty cycle corrections.",
        'INCLM2': "Takes effect during adaptive wastegate control, setting the secondary clamp limit on incremental duty cycle corrections.",
        'INCPT': "Takes effect during part-throttle boost control, establishing the adaptive duty cycle increment time delay.",
        'INCPT2': "Takes effect during part-throttle boost control, establishing the secondary adaptive duty cycle increment time delay.",
        'LMPSHF': "Takes effect only when the ECU enters Limp-In mode due to an active sensor fault, enforcing a reduced manifold pressure ceiling for overboost fuel cutoff.",
        'BOSTSH': "Takes effect during overboost conditions, triggering overboost protection and fuel cutout if manifold boost pressure exceeds safe calibration limits.",
        'BSTSOL': "Takes effect during overboost conditions, de-energizing the wastegate solenoid to drop boost pressure to mechanical spring levels.",
        'BOSTCU': "Takes effect during overboost conditions, initiating fuel injector cutout to protect the engine from over-pressurization.",
        'RATLIM': "Takes effect during rapid boost spool-up, monitoring rate of boost increase to prevent transient overboost spikes.",
        'BSTSWS': "Takes effect during boost target calculation when switchable boost is enabled, reading the driver's dashboard toggle switch to alternate between high and low boost profiles.",
        'DCRPMH': "Takes effect during boost control, setting the high engine RPM boundary above which adaptive wastegate corrections are disabled.",
        'DCRPML': "Takes effect during boost control, setting the low engine RPM boundary below which adaptive wastegate corrections are disabled.",
        'MPDEL': "Takes effect during boost transitions, establishing the manifold pressure hysteresis threshold for detecting boost rise.",
        'MPDEL1': "Takes effect during boost control, setting the first manifold pressure delta threshold for incrementing the boost control counter.",
        'MPDEL2': "Takes effect during boost control, setting the second manifold pressure delta threshold for incrementing the boost control counter.",
        'MPDEL3': "Takes effect during boost control, setting the third manifold pressure delta threshold for incrementing the boost control counter.",
        'MPROOF': "Takes effect as manifold pressure approaches target boost, disabling adaptive wastegate increments to prevent overshooting boost.",
        'PRTMAX': "Takes effect during part-throttle boost control, establishing the maximum permissible wastegate duty cycle ceiling.",
        'RESFAC': "Takes effect during transient boost changes, applying a response factor multiplier to wastegate duty cycle error corrections.",
        'DECTIM': "Takes effect when wastegate duty cycle is decremented due to knock, setting the time scale for duty cycle step reductions.",
        'DCDECK': "Takes effect under boost when spark knock retard is active, stepping down wastegate duty cycle per time interval to bleed off boost.",
        'MXSBST': "Takes effect across vehicle road speed, scaling allowable target boost to optimize traction in lower gears.",

        # Idle & AIS Stepper Control
        'TARGETIDLESPEED': "Takes effect at closed throttle once the engine is running, establishing the target idle speed across coolant temperature.",
        'DRIDLE': "Takes effect at closed throttle once the engine is running, establishing the target idle speed across coolant temperature.",
        'IDLRPM': "Takes effect at closed throttle once the engine is running, establishing the target idle speed across coolant temperature.",
        'DRIDHT': "Takes effect immediately upon starting a warm engine, commanding an elevated startup idle flare speed before decaying to base idle.",
        'STTIME': "Takes effect immediately after the engine starts and enters run mode, dictating how many seconds the elevated startup idle flare speed is sustained.",
        'PNDRK': "Takes effect at idle when shifting an automatic transmission from Park/Neutral into Drive or Reverse, pre-emptively opening the idle air motor to catch driveline drag.",
        'NEUDRV': "Takes effect at idle when shifting from Drive back into Neutral or Park, trimming the idle air motor closed to prevent an engine flare.",
        'DLYTIM': "Takes effect when the throttle snaps shut, holding the idle air motor in a dashpot position for a calibrated delay before closed-loop idle speed control resumes.",
        'DLYTIM2': "Takes effect when the throttle snaps shut, holding the idle air motor in a dashpot position for a calibrated delay before closed-loop idle speed control resumes.",
        'DLYTM3': "Takes effect when the throttle snaps shut from elevated RPM, extending the idle air dashpot hold delay before resuming closed-loop idle control.",
        'DLYRPM': "Takes effect when the throttle snaps shut at low vehicle speed, switching between standard and extended idle dashpot hold timers based on engine RPM.",
        'AISMAX': "Takes effect whenever the idle air stepper motor is commanded to move, establishing the hard mechanical step limits for pintle travel.",
        'AISMIN': "Takes effect whenever the idle air stepper motor is commanded to move, establishing the minimum allowable closed position for the idle air pintle.",
        'AISHLM': "Takes effect whenever the idle air motor steps open, enforcing an absolute upper mechanical limit on stepper pintle travel to prevent motor jamming.",
        'AISDLY': "Takes effect immediately after the engine starts, disabling closed-loop idle speed stepper feedback for a brief delay while the startup idle flare stabilizes.",
        'AISPN': "Takes effect at closed-throttle idle when an automatic transmission is in Park or Neutral, establishing the target idle speed across coolant temperature.",
        'CLDPOS': "Takes effect during cold engine warm-up, establishing an extra off-idle bypass airflow opening based on engine coolant temperature.",
        'AISTEP': "Takes effect whenever the engine controller commands the idle air stepper motor to move, defining the 4-phase coil commutation pattern that steps the pintle in or out.",
        'AISFRQ': "Takes effect during closed-loop idle speed regulation, setting the execution frequency and update rate for idle RPM feedback.",
        'DAACF': "Takes effect during idle air calculation, applying an airflow factor delta when the air conditioning compressor is running.",
        'DANOM': "Takes effect during idle air calculation, defining the nominal baseline airflow step position for idle regulation.",
        'DECAIS': "Takes effect while coasting or rolling in neutral, setting the idle air stepper update rate to smoothly track rolling idle.",
        'DEFAIS': "Takes effect during key-on and initial ECU boot before sensor readings are validated, loading a safe baseline stepper motor position to ensure smooth engine starting.",
        'STEPDOWN': "Takes effect after dashpot delay expires, ramping the idle air stepper motor closed toward base idle position step-by-step.",

        # Cruise Control
        'VACACC': "Takes effect while cruise control is engaged with a large speed deficit or during Resume, applying accelerated vacuum servo pulses to pull vehicle speed back up rapidly.",
        'VACREG': "Takes effect during steady-state cruising, pulsing the vacuum servo to maintain vehicle road speed on minor highway grades.",
        'VENTRG': "Takes effect during cruise control when vehicle speed exceeds the target set speed, pulsing the vent solenoid to bleed vacuum and close the throttle.",
        'VNTAB1': "Takes effect when cruise control overspeeds down a highway descent, clamping the maximum allowable vent solenoid pulse duration to prevent throttle surging.",
        'VNTAB2': "Takes effect when cruise control overspeeds down a highway descent, setting an intermediate vent solenoid pulse duration clamp to prevent throttle hunting.",
        'SCNVHI': "Takes effect continuously while cruise control is armed, forming the upper threshold of the analog voltage safety window that instantly disengages cruise when the brake or clutch pedal is tapped.",
        'SCNVLO': "Takes effect continuously while cruise control is armed, forming the lower threshold of the analog voltage safety window that instantly disengages cruise when the brake or clutch pedal is tapped.",
        'CLOTHR': "Takes effect during cruise control downhill coasting, inhibiting vent solenoid pulses once the mechanical throttle linkage is fully closed against its idle stop.",
        'MAXSET': "Takes effect when the driver presses the cruise control SET button, enforcing the maximum legal road speed for cruise engagement.",
        'MINSET': "Takes effect when the driver presses the cruise control SET button, enforcing the minimum low-speed cutoff threshold for cruise engagement.",
        'MAXTHR': "Takes effect during cruise control operation, prohibiting vacuum servo pull when throttle opening exceeds this maximum angle ceiling.",
        'SETPW': "Takes effect the instant the driver presses the SET button, delivering an initial vacuum setup pulse to take the slack out of the servo bellows.",
        'RESTBL': "Takes effect the instant the driver presses RESUME, adding extra vacuum pulse duration based on the speed deficit between current and memorized cruise speed.",
        'SPGAIN': "Takes effect during cruise control operation, adjusting servo duty cycle gains based on vehicle road speed.",
        'THGAIN': "Takes effect during cruise control operation, applying a progressive servo gain correction based on throttle opening angle.",
        'ACLRST': "Takes effect during cruise control acceleration or resume, disengaging accelerated pull-up mode and returning to regular cruise gain once speed error drops below this threshold.",
        'LOSPCO': "Takes effect while cruise control is active, immediately disengaging the system if vehicle speed drops below this low-speed safety cutout limit.",
        'SETIM1': "Takes effect when using the cruise Coast/Decel button, qualifying the deceleration hold duration before applying a setup pulse.",
        'SETIME': "Takes effect when using the cruise Coast/Decel button, qualifying the deceleration hold duration before applying a setup pulse.",
        'CRMASK': "Takes effect during cruise switch reading, masking and testing digital switch inputs from the multifunction steering column lever.",
        'CRMSK2': "Takes effect during cruise switch reading, masking and testing secondary digital switch inputs from the multifunction steering column lever.",
        'CRMSK3': "Takes effect during cruise switch reading, masking and testing tertiary digital switch inputs from the multifunction steering column lever.",

        # Diagnostics, Baro, OBD & Limits
        'BARDFT': "Takes effect as a failsafe default whenever barometric pressure cannot be read or a MAP sensor fault occurs, defaulting atmospheric pressure to sea level (29.92 inHg) to keep fueling safe.",
        'BAROHI': "Takes effect during key-on and in-flight barometric pressure reads, establishing the acceptable high voltage limit for a valid atmospheric reading.",
        'BAROLO': "Takes effect during key-on and in-flight barometric pressure reads, establishing the acceptable low voltage limit for a valid atmospheric reading.",
        'BARTIM': "Takes effect while cruising at steady part-throttle, setting the minimum time interval required between in-flight barometric pressure solenoid cycles.",
        'BRCLTM': "Takes effect during in-flight baro reading cycles, setting the pneumatic settling delay after switching the baro solenoid closed.",
        'BROPTM': "Takes effect during in-flight baro reading cycles, setting the pneumatic settling delay after switching the baro solenoid open.",
        'BARAIS': "Takes effect at high elevation, applying barometric altitude compensation to idle air stepper step targets.",
        'BARFLR': "Takes effect at high elevation, applying barometric altitude compensation to baseline manifold pressure tables.",
        'BRPMLO': "Takes effect during in-flight barometric pressure reads, establishing the lower engine RPM boundary required to cycle the baro solenoid.",
        'BRPMH': "Takes effect during in-flight barometric pressure reads, establishing the upper engine RPM ceiling allowed to cycle the baro solenoid.",
        'BRPML2': "Takes effect during in-flight barometric pressure reads, establishing a secondary lower engine RPM boundary required to cycle the baro solenoid.",
        'MAPHIG': "Takes effect continuously during sensor diagnostic checks, flagging fault codes if the MAP sensor voltage shorts to 5V.",
        'MAPLOW': "Takes effect continuously during sensor diagnostic checks, flagging fault codes if the MAP sensor voltage shorts to ground.",
        'THRHIG': "Takes effect continuously during throttle sensor diagnostics, flagging fault codes if the TPS voltage reads above 5V.",
        'THRLOW': "Takes effect continuously during throttle sensor diagnostics, flagging fault codes if the TPS voltage reads below ground.",
        'TMPHIG': "Takes effect during temperature sensor diagnostics, detecting short-circuit coolant and charge temperature sensor faults.",
        'TMPLOW': "Takes effect during temperature sensor diagnostics, detecting open-circuit coolant and charge temperature sensor faults.",
        'DLTTHR': "Takes effect during automated sensor health diagnostics, specifying the throttle voltage sweep required to validate sensor health and clear fault codes.",
        'ERRRPM': "Takes effect during ECU self-diagnostics, establishing the minimum engine speed required before recording diagnostic trouble codes.",
        'ERRTMP': "Takes effect during ECU self-diagnostics, establishing the minimum engine coolant temperature required before recording diagnostic trouble codes.",
        'PURTMP': "Takes effect when the engine is warm under moderate intake manifold vacuum, energizing the evaporative canister purge solenoid to draw fuel vapors into the intake.",
        'PURMAP': "Takes effect under intake manifold vacuum, setting the manifold pressure threshold required to open the canister purge solenoid.",
        'PURHYS': "Takes effect during evaporative canister purge control, providing manifold pressure hysteresis to prevent purge solenoid chattering.",
        'MININC': "Takes effect at key-on initialization, providing a slight upward adjustment to the learned closed-throttle baseline voltage.",
        'MININH': "Takes effect at key-on initialization, providing an upward adjustment to the learned closed-throttle baseline voltage under half-throttle conditions.",
        'LMPINN': "Takes effect when a MAP sensor failure is detected, substituting a calculated manifold pressure lookup from throttle position to allow limp-in driving.",
        'MPLMOF': "Takes effect during MAP sensor limp-in operation, adding a calibration offset to the calculated limp-in manifold pressure.",
        'MPLTHR': "Takes effect during MAP sensor diagnostics, establishing the throttle opening threshold required to mature the MAP limp-in error state.",
        'MPDELT': "Takes effect during MAP sensor diagnostics, establishing the manifold pressure delta required to verify sensor health.",
        'MPDELA': "Takes effect during MAP sensor diagnostics, adding an offset to the MAP delta threshold required to mature the MAP limp-in fault.",
        'SPDLMH': "Takes effect at elevated road speeds, enforcing the high vehicle speed governor limit by cutting fuel injection when road speed crosses this threshold.",
        'SPDLML': "Takes effect following vehicle speed limiting, defining the lower speed recovery threshold where fuel injection is restored.",
        'SPDRPM': "Takes effect at elevated engine RPM as a prerequisite check, ensuring the vehicle speed limiter is only armed and evaluated when engine speed is above this threshold.",
        'PTUMSP': "Takes effect while cruising in gear, establishing the minimum vehicle road speed required before torque converter clutch lockup is permitted.",
        'CHGTL1': "Takes effect continuously whenever intake air charge temperature is sampled, converting raw sensor voltage into engineering temperature units.",
        'ENDITM': "Takes effect during diagnostic scan-tool communications (DRB-II / MPScan), reporting the firmware calibration part number and ECU identifier.",
        'ENDIT1': "Takes effect during diagnostic scan tool communications (DRB-II / MPScan), transmitting the ECU calibration part number prefix.",
        'FLTMSKX': "Takes effect during diagnostic trouble code scanning, acting as the table end-marker when the ECU loops through recorded fault bits.",
        'IPLMSK': "Takes effect during active fault condition monitoring, defining which diagnostic error codes trigger illumination of the Power Loss / Check Engine dash light.",
        'IPLMSK2': "Takes effect during active fault condition monitoring, defining which secondary diagnostic error codes trigger illumination of the Power Loss / Check Engine dash light.",
        'MDLCDE': "Takes effect at ECU power-up, identifying the vehicle body style and powertrain platform to configure internal firmware logic.",
        'MTHROP': "Takes effect as the driver presses the gas pedal, establishing the throttle voltage threshold above idle required to transition the ECU from closed-throttle idle into off-idle running mode.",
        'PIAMSK': "Takes effect during hardware initialization at key-on, configuring the input and output pin directions for peripheral interface adapter 1 Port A.",
        'PIBMSK': "Takes effect during hardware initialization at key-on, configuring the input and output pin directions for peripheral interface adapter 1 Port B.",
        'SETUP2': "Takes effect during key-on system boot, setting hardware configuration parameters and MCU control register flags.",
        'SRCID': "Takes effect during diagnostic scan tool identification, broadcasting the Turbonator assembly source code version number.",

        # Turbonator Performance Features
        'LCENAB': "Takes effect when the vehicle is stationary at the starting tree with the clutch depressed, arming the Turbonator 2-step launch control rev limiter.",
        'LCSTAG': "Takes effect when staging at the starting line, activating the Turbonator 2-step launch control rev limiter.",
        'REVLMTX': "Takes effect when 2-step staging is active, cutting and restoring fuel injection within a tight RPM hysteresis window to build boost on the starting line.",
        'REVLMTX2': "Takes effect when 2-step staging is active, establishing the secondary hysteresis recovery threshold for the staging launch limiter.",
        'STGRON': "Takes effect when launch control rev limiting is active, establishing the lower engine speed threshold where fuel injection and ignition spark are restored.",
        'RVLSPS': "Takes effect during launch control, defining the vehicle speed threshold (typically 2-3 MPH) above which 2-step launch rev limiting automatically turns off as the car launches.",
        'RVLSWS': "Takes effect during launch control setup, selecting the physical switch input or vehicle speed condition used to arm the 2-step staging limiter.",
        'STGSWS': "Takes effect when staging at the starting line, selecting the physical toggle switch or clutch input used to activate the 2-step launch rev limiter.",
        'STGTPS': "Takes effect when launch control is armed, requiring throttle position to exceed this angle before activating 2-step staging rev limiting.",
        'LNCBDT': "Takes effect when Turbonator launch control is active, providing the base data table that defines staging RPM limits and staging ignition timing offsets.",
        'LNCPDT': "Takes effect when launch control 2-step rev limiting is active, providing the ignition cut pattern data table used to hold staging RPM.",
        'SPKFRC': "Takes effect when launch control or rev limiting is active, establishing the percentage pattern of ignition sparks cut per engine cycle.",
        'NO2SWS': "Takes effect when the nitrous oxide activation switch is triggered, immediately retarding ignition timing by a fixed safety angle to prevent detonation.",
        'NO2RET': "Takes effect when the nitrous oxide system is armed and firing, retarding ignition timing across manifold pressure to protect against detonation.",
        'AKI1ON': "Takes effect under positive boost pressure, commanding the primary water/methanol injection nozzle solenoid open across manifold pressure.",
        'AKI1OF': "Takes effect as boost drops, commanding the primary water/methanol injection nozzle solenoid closed once manifold pressure falls below this threshold.",
        'AKI2ON': "Takes effect under high boost pressure, triggering the secondary high-flow water/methanol injection nozzle solenoid open.",
        'AKI2OF': "Takes effect as high boost recedes, commanding the secondary high-flow water/methanol injection nozzle solenoid closed.",
        'AKPMON': "Takes effect as manifold pressure builds under boost, energizing the water/methanol injection delivery pump.",
        'AKPMOF': "Takes effect as boost falls off, shutting down the water/methanol injection delivery pump.",
        'SLRPM': "Takes effect at high engine speed, illuminating the instrument cluster upshift arrow or external shift light when engine RPM crosses this threshold.",
        'SHFLIT': "Takes effect at high engine speed, commanding the instrument cluster shift light or external indicator ON when engine RPM exceeds this setpoint.",
        'UPSHFT': "Takes effect at high engine speed, commanding the instrument cluster upshift arrow ON when engine RPM exceeds this setpoint.",
        'AFR2NB': "Takes effect when wideband O2 tracking is enabled, converting wideband air-fuel ratio voltage into a simulated narrowband signal for the ECU feedback loop.",
        'WB2NB': "Takes effect when wideband O2 tracking is enabled, converting wideband air-fuel ratio voltage into a simulated narrowband signal for the ECU feedback loop.",
        'WBO2': "Takes effect when wideband O2 tracking is enabled, reading the 0-5V analog wideband sensor input to monitor live combustion AFR.",
        'WB2AFR': "Takes effect continuously during wideband O2 monitoring, converting 0-5V wideband sensor input voltage into real-world air-fuel ratio (AFR) values.",
        'ANTLAG': "Takes effect during launch staging or anti-lag operation, aggressively retarding spark timing to build exhaust heat and spool the turbocharger while stationary.",

        # Hardware & Communications
        'BAUDHI': "Takes effect during diagnostic serial communications with a scan tool (DRB-II or MPScan), configuring the high-speed communication baud rate.",
        'BAUDLO': "Takes effect during diagnostic serial communications with a scan tool (DRB-II or MPScan), configuring the standard communication baud rate.",
        'BAUDMD': "Takes effect during diagnostic serial communications with a scan tool (DRB-II or MPScan), configuring the serial communication baud rate.",
        'CCDCFG': "Takes effect at ECU power-up, reading the Chrysler Collision Detection (CCD) serial data bus hardware configuration flags.",
        'OPTN1': "Takes effect at ECU power-up, reading calibration option bitmask 1 that configures vehicle features, transmission type, and optional firmware functions.",
        'OPTN2': "Takes effect at ECU power-up, reading calibration option bitmask 2 that configures secondary vehicle features and optional firmware functions.",
        'OPTN3': "Takes effect at ECU power-up, reading calibration option bitmask 3 that configures tertiary vehicle features and optional firmware functions.",
        'CONFIG': "Takes effect at ECU power-up, reading calibration option bitmasks that configure vehicle features, transmission type, and optional firmware functions.",
        'CHKFIX': "Takes effect during ROM verification and EEPROM flashing, providing the checksum balance value that ensures valid ROM integrity."
    }

    if k_upper in EXACT_MAP:
        return EXACT_MAP[k_upper]

    # Check EGR
    if 'egr' in fl_lower or 'egr' in k_upper:
        return "Takes effect during warm, part-throttle cruising, modulating the exhaust gas recirculation (EGR) solenoid duty cycle to control combustion temperatures."

    # Contextual extraction from overview text
    cond_clause = extract_condition_from_text(overview, op_cond)
    if cond_clause:
        cond_clean = clean(cond_clause)
        # Fix grammatical issues
        cond_clean = re.sub(r'^(when|during|while|under|whenever|after|upon|if)\s+(when|if|once)\b', r'\1', cond_clean, flags=re.IGNORECASE)
        if re.match(r'^(when|during|while|under|whenever|after|upon|if|once)\b', cond_clean, re.IGNORECASE):
            stmt = f"Takes effect {cond_clean}."
        else:
            stmt = f"Takes effect when {cond_clean}."
            
        stmt = re.sub(r'\bTakes effect when once\b', 'Takes effect once', stmt, flags=re.IGNORECASE)
        stmt = re.sub(r'\bTakes effect when if\b', 'Takes effect if', stmt, flags=re.IGNORECASE)
        stmt = re.sub(r'\bTakes effect when when\b', 'Takes effect when', stmt, flags=re.IGNORECASE)
        stmt = re.sub(r'\bthe ECU\b', 'the ECU', stmt)
        return stmt

    # Cleaned label fallback
    cleaned_label = re.sub(r'^[A-Za-z0-9_]+_', '', full_label).replace('_', ' ')
    if 'idle' in subsystem.lower():
        return f"Takes effect at closed throttle idle to regulate {cleaned_label}."
    elif 'fuel' in subsystem.lower():
        return f"Takes effect during engine running fuel calculation to calibrate {cleaned_label}."
    elif 'spark' in subsystem.lower():
        return f"Takes effect across engine operating conditions to establish ignition advance for {cleaned_label}."
    elif 'boost' in subsystem.lower():
        return f"Takes effect under turbocharger boost operation to control {cleaned_label}."
    elif 'cruise' in subsystem.lower():
        return f"Takes effect while cruise control is active to regulate {cleaned_label}."
    elif 'fan' in subsystem.lower():
        return f"Takes effect during cooling system operation to control {cleaned_label}."
    elif 'diag' in subsystem.lower() or 'obd' in subsystem.lower():
        return f"Takes effect during diagnostic monitoring to evaluate {cleaned_label}."

    return f"Takes effect during engine operation to calibrate {cleaned_label}."

def update_descriptor_file(filepath):
    print(f"\n=======================================================")
    print(f"UPDATING DESCRIPTORS FILE: {filepath}")
    print(f"=======================================================")
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
        
    descs = data.get('descriptors', {})
    updated_count = 0
    already_updated_count = 0
    
    for k, d in descs.items():
        current_op = d.get('operating_conditions', '')
        
        # Check if statement is already prepended or is not applicable
        if (current_op.strip().startswith('Takes effect ') or
            current_op.strip().startswith('Not applicable') or
            current_op.strip().startswith('Evaluated ') or
            'filler' in d.get('long_name', '').lower() or
            d.get('metadata', {}).get('table_type') == 'Type 9'):
            already_updated_count += 1
            continue
            
        stmt = synthesize_gearhead_statement(k, d)
        new_op = f"{stmt}\n\n{current_op}".strip()
        d['operating_conditions'] = new_op
        updated_count += 1
        
    # Write back to file with identical formatting (2-space indent, utf-8)
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write('\n')
        
    print(f"Successfully processed {filepath}:")
    print(f"  - Updated: {updated_count} descriptors")
    print(f"  - Already up-to-date: {already_updated_count} descriptors")
    print(f"  - Total descriptors: {len(descs)}")

def main():
    target_files = [
        os.path.abspath('docs/t_lm_descriptors.json'),
        os.path.abspath('docs/t_smec_descriptors.json'),
        os.path.abspath('docs/t_sbec_descriptors.json'),
        os.path.abspath('docs/t_sbecii_descriptors.json'),
        os.path.abspath('docs/t_t3_i_descriptors.json'),
        os.path.abspath('docs/t_t3_ii_descriptors.json')
    ]
    
    for f in target_files:
        if not os.path.exists(f):
            print(f"Error: {f} does not exist!")
            sys.exit(1)
        update_descriptor_file(f)
        
    print("\nAll descriptors updated successfully.")

if __name__ == '__main__':
    main()
