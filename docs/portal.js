/**
 * MPTune Calibration Portal & Multi-ECM Updater Engine
 * Seamless single-page application for calibration updates across all Chrysler Turbo ECM families
 * and technical disassembly documentation navigation.
 */

(function () {
    'use strict';

    // Declarative ECM Registry: Adding a future ECM requires only an entry here!
    const ECM_CONFIGS = {
        'T3-II': {
            id: 'T3-II',
            code: 'T3-II',
            displayName: 'Turbo III (Gen 2) 16V Lotus (1992–1993)',
            jsonFile: 't_t3_ii_descriptors.json',
            signatures: {
                assmPattern: /t[-_]?t3[-_]?(ii|2)|t[-_]?t3_iiv/i,
                headerPattern: /t[-_]?t3\s*\(sbecii\)|t[-_]?t3[-_]?ii|t3ii/i,
                filenamePattern: /t[-_]?t3.*(ii|2)/i
            },
            docsUrl: 'T3-II-web/index.html'
        },
        'T3-I': {
            id: 'T3-I',
            code: 'T3-I',
            displayName: 'Turbo III (Gen 1) 16V Lotus (1991–1992)',
            jsonFile: 't_t3_i_descriptors.json',
            signatures: {
                assmPattern: /t[-_]?t3(?!ii|_ii|2)v\d*\.asm/i,
                headerPattern: /t[-_]?t3\s*\(sbec\)|t[-_]?t3v1/i,
                filenamePattern: /t[-_]?t3(?!.*(?:ii|2))/i
            },
            docsUrl: 'T3-I-web/index.html'
        },
        'SBECII': {
            id: 'SBECII',
            code: 'SBECII',
            displayName: 'Single Board Engine Controller II (1992–1993)',
            jsonFile: 't_sbecii_descriptors.json',
            signatures: {
                assmPattern: /t[-_]?(sbecii|sbec2|sbec_ii)/i,
                headerPattern: /turbonator[-_]?(sbecii|sbec2)|t[-_]?(sbecii|sbec2)/i,
                filenamePattern: /t[-_]?(sbecii|sbec2)/i
            },
            docsUrl: 'T-SBECII-web/index.html'
        },
        'SBEC': {
            id: 'SBEC',
            code: 'SBEC',
            displayName: 'Single Board Engine Controller (1990–1991)',
            jsonFile: 't_sbec_descriptors.json',
            signatures: {
                assmPattern: /t[-_]?sbec(?!ii|2|_ii)/i,
                headerPattern: /turbonator[-_]?sbec(?!ii|2|_ii)|t[-_]?sbec(?!ii|2|_ii)/i,
                filenamePattern: /t[-_]?sbec(?!ii|2|_ii)/i
            },
            docsUrl: 'T-SBEC-web/index.html'
        },
        'SMEC': {
            id: 'SMEC',
            code: 'SMEC',
            displayName: 'Single Module Engine Controller (1988–1989)',
            jsonFile: 't_smec_descriptors.json',
            signatures: {
                assmPattern: /t[-_]?smec/i,
                headerPattern: /turbonator[-_]?smec|t[-_]?smec/i,
                filenamePattern: /t[-_]?smec/i
            },
            docsUrl: 'T-SMEC-web/index.html'
        },
        'LM': {
            id: 'LM',
            code: 'LM-87',
            displayName: 'Chrysler Logic Module (1985–1987)',
            jsonFile: 't_lm_descriptors.json',
            signatures: {
                assmPattern: /t[-_]?lm/i,
                headerPattern: /turbonator[-_]?lm|t[-_]?lm/i,
                filenamePattern: /t[-_]?lm|lm[-_]?87/i
            },
            docsUrl: 'T-LM-web/index.html'
        }
    };

    // Application State
    const state = {
        descriptorCache: {}, // ecmId -> json object
        detectedEcm: null,   // Config object if auto-detected, or null
        activeEcmId: null,   // ECM ID currently applied
        originalFileName: '',
        originalText: '',
        updatedText: '',
        outputFileName: '',
        totalUpdated: 0,
        fileHandle: null
    };

    const DELIMITER = '____';
    const OVERVIEW_PREFIX = 'OVERVIEW:';
    const DELIMITED_OVERVIEW = `${DELIMITER}${OVERVIEW_PREFIX}`;
    const PLACEHOLDER_REGEX = /^(desc|descr|description|detailed[_\s]description\d*)$/i;

    // DOM Elements
    const elements = {
        themeToggle: document.getElementById('themeToggle'),
        dbStatusBadge: document.getElementById('dbStatusBadge'),
        uploadBox: document.getElementById('uploadBox'),
        fileInput: document.getElementById('fileInput'),
        browseBtn: document.getElementById('browseBtn'),
        readyBox: document.getElementById('readyBox'),
        loadedFileName: document.getElementById('loadedFileName'),
        ecmDetectedBadge: document.getElementById('ecmDetectedBadge'),
        ecmDetectedName: document.getElementById('ecmDetectedName'),
        ecmFallbackContainer: document.getElementById('ecmFallbackContainer'),
        ecmFallbackSelect: document.getElementById('ecmFallbackSelect'),
        ecmFallbackApplyBtn: document.getElementById('ecmFallbackApplyBtn'),
        ecmNoticeBox: document.getElementById('ecmNoticeBox'),
        statUpdatedSummary: document.getElementById('statUpdatedSummary'),
        statOutputFile: document.getElementById('statOutputFile'),
        savedStatusText: document.getElementById('savedStatusText'),
        downloadBtn: document.getElementById('downloadBtn'),
        resetBtn: document.getElementById('resetBtn'),
        noticeModal: document.getElementById('noticeModal'),
        modalTitle: document.getElementById('modalTitle'),
        modalDesc: document.getElementById('modalDesc'),
        modalCloseBtn: document.getElementById('modalCloseBtn')
    };

    // Update DB Status indicator badge
    function updateDbBadge(status, text) {
        if (!elements.dbStatusBadge) return;
        elements.dbStatusBadge.className = `db-badge ${status}`.trim();
        elements.dbStatusBadge.textContent = text;
    }

    /**
     * Auto-detect ECM Family from file content and name.
     * Uses a 3-tier cascade:
     *   Tier 1: ;mpassmfile directive in line 1-25 (deterministic)
     *   Tier 2: Header comments in first 100 lines (template structure)
     *   Tier 3: Filename pattern matching (fallback)
     * Returns the matching ECM config object or null if undetermined.
     */
    function detectEcmFamily(rawText, fileName) {
        if (!rawText) return null;
        const lines = rawText.split(/\r?\n/);

        // 1. Tier 1: Look for ;mpassmfile directive
        let assmFile = null;
        const scanLimit = Math.min(lines.length, 30);
        for (let i = 0; i < scanLimit; i++) {
            const m = lines[i].trim().match(/^;mpassmfile\s+(\S+)/i);
            if (m) {
                assmFile = m[1];
                break;
            }
        }

        if (assmFile) {
            for (const [id, cfg] of Object.entries(ECM_CONFIGS)) {
                if (cfg.signatures.assmPattern && cfg.signatures.assmPattern.test(assmFile)) {
                    return cfg;
                }
            }
        }

        // 2. Tier 2: Check template header comments
        const headerSlice = lines.slice(0, 100).join('\n');
        for (const [id, cfg] of Object.entries(ECM_CONFIGS)) {
            if (cfg.signatures.headerPattern && cfg.signatures.headerPattern.test(headerSlice)) {
                return cfg;
            }
        }

        // 3. Tier 3: Check filename patterns
        if (fileName) {
            for (const [id, cfg] of Object.entries(ECM_CONFIGS)) {
                if (cfg.signatures.filenamePattern && cfg.signatures.filenamePattern.test(fileName)) {
                    return cfg;
                }
            }
        }

        return null; // Undetermined
    }

    /**
     * Load descriptors database on-demand for a given ECM, with caching.
     */
    async function loadDescriptorsForEcm(ecmId) {
        if (!ecmId || !ECM_CONFIGS[ecmId]) return null;

        if (state.descriptorCache[ecmId]) {
            return state.descriptorCache[ecmId];
        }

        const config = ECM_CONFIGS[ecmId];
        const candidatePaths = [
            `./${config.jsonFile}`,
            config.jsonFile,
            `../${config.jsonFile}`
        ];

        for (const p of candidatePaths) {
            try {
                const response = await fetch(p);
                if (response.ok) {
                    const data = await response.json();
                    state.descriptorCache[ecmId] = data;
                    return data;
                }
            } catch (err) {
                // Try next path
            }
        }

        // Global fallback for pre-bundled offline distributions
        const windowKey = `${ecmId.replace(/[^A-Za-z0-9]/g, '_')}_DESCRIPTORS`;
        if (window[windowKey]) {
            state.descriptorCache[ecmId] = window[windowKey];
            return window[windowKey];
        }
        if (ecmId === 'LM' && window.TLM_DESCRIPTORS) {
            state.descriptorCache['LM'] = window.TLM_DESCRIPTORS;
            return window.TLM_DESCRIPTORS;
        }

        return null;
    }

    /**
     * Populate the fallback selector dropdown with registered ECM options.
     */
    function populateFallbackSelector() {
        if (!elements.ecmFallbackSelect) return;
        elements.ecmFallbackSelect.innerHTML = '<option value="" disabled selected>-- Select ECM Type --</option>';

        // Maintain display order: LM, SMEC, SBEC, SBECII, T3-I, T3-II
        const displayOrder = ['LM', 'SMEC', 'SBEC', 'SBECII', 'T3-I', 'T3-II'];
        for (const id of displayOrder) {
            const cfg = ECM_CONFIGS[id];
            if (!cfg) continue;
            const opt = document.createElement('option');
            opt.value = id;
            opt.textContent = `${cfg.code} — ${cfg.displayName}`;
            elements.ecmFallbackSelect.appendChild(opt);
        }
    }

    /**
     * Probe available descriptor databases on initialization.
     */
    async function checkAvailableDatabases() {
        updateDbBadge('', 'Checking DBs...');
        const available = [];

        for (const [id, cfg] of Object.entries(ECM_CONFIGS)) {
            try {
                const res = await fetch(cfg.jsonFile, { method: 'HEAD' });
                if (res.ok) {
                    available.push(cfg.code);
                }
            } catch (e) {
                // If HEAD isn't supported, attempt GET or fallback
            }
        }

        if (available.length > 0) {
            updateDbBadge('ready', `DBs: ${available.join(', ')} Ready`);
        } else {
            // Default known ready databases
            updateDbBadge('ready', 'DBs: LM & SMEC Ready');
        }
    }

    // Safe updated filename generator
    function getSafeUpdatedFilename(originalName) {
        if (!originalName) return 'calibration-updated.tpl';
        const lastDot = originalName.lastIndexOf('.');
        if (lastDot === -1) {
            return `${originalName}-updated.tpl`;
        }
        const name = originalName.substring(0, lastDot);
        const ext = originalName.substring(lastDot);
        return `${name}-updated${ext}`;
    }

    /**
     * Core update engine: parses TPL and enriches ;mptbldesc directives using provided descriptors
     */
    function processTpl(rawText, descriptors) {
        const newline = rawText.includes('\r\n') ? '\r\n' : '\n';
        const lines = rawText.split(/\r?\n/);

        const byCname = new Map();
        const byLname = new Map();
        const byLabel = new Map();

        const dict = (descriptors && descriptors.descriptors) 
            ? descriptors.descriptors 
            : (descriptors || {});

        // 1. Index primary canonical descriptors
        for (const [k, v] of Object.entries(dict)) {
            if (!v || typeof v !== 'object') continue;
            const entry = {
                cname: v.short_name || v.cname || k,
                lname: v.long_name || v.lname || '',
                label: v.full_label || v.label || '',
                mptune_desc: v.mptune_desc || ''
            };
            if (entry.cname) byCname.set(entry.cname.toLowerCase(), entry);
            if (entry.lname) byLname.set(entry.lname.toLowerCase(), entry);
            if (entry.label) byLabel.set(entry.label.toLowerCase(), entry);
        }

        // 2. Index consolidated aliases (e.g. fpwunk -> PTPWOF)
        const aliasMap = (descriptors && descriptors.aliases && descriptors.aliases.lookup_index) || {};
        for (const [aliasKey, targetKey] of Object.entries(aliasMap)) {
            const canonical = dict[targetKey];
            if (!canonical) continue;
            const entry = {
                cname: canonical.short_name || targetKey,
                lname: canonical.long_name || '',
                label: canonical.full_label || '',
                mptune_desc: canonical.mptune_desc || ''
            };
            const lk = aliasKey.toLowerCase();
            if (!byCname.has(lk)) byCname.set(lk, entry);
            if (!byLabel.has(lk)) byLabel.set(lk, entry);
            if (!byLname.has(lk)) byLname.set(lk, entry);
        }

        const updatedLines = [];
        let totalUpdated = 0;

        let i = 0;
        const n = lines.length;

        while (i < n) {
            const line = lines[i];
            const stripped = line.trim();

            const labelMatch = stripped.match(/^([A-Za-z0-9_]+):/);
            const isMetadataStart = stripped.startsWith(';mptblcname') || 
                                    stripped.startsWith(';mptbllname') || 
                                    stripped.startsWith(';mpgrp');

            if (labelMatch || isMetadataStart) {
                const blockLines = [line];
                let blockLabel = labelMatch ? labelMatch[1] : null;
                let blockCname = null;
                let blockLname = null;
                let hasDesc = false;
                let descLineIdx = -1;
                let descVal = '';
                let descIndent = '    ';
                let firstDataIdx = -1;

                if (stripped.startsWith(';mptblcname')) {
                    const parts = stripped.split(/\s+/);
                    if (parts.length > 1) blockCname = parts[1];
                } else if (stripped.startsWith(';mptbllname')) {
                    const parts = stripped.split(/\s+/);
                    if (parts.length > 1) blockLname = parts[1];
                } else if (stripped.startsWith(';mptbldesc')) {
                    hasDesc = true;
                    descLineIdx = 0;
                    const parts = stripped.split(/\s+/, 2);
                    descVal = stripped.substring(parts[0].length).trim();
                    const matchIndent = line.match(/^\s*/);
                    descIndent = matchIndent ? matchIndent[0] : '    ';
                }

                let j = i + 1;
                let sawData = false;

                while (j < n) {
                    const nextLine = lines[j];
                    const nStripped = nextLine.trim();

                    if ((/^([A-Za-z0-9_]+):/.test(nStripped) && !nStripped.startsWith(';')) && sawData) {
                        break;
                    }
                    if ((nStripped.startsWith(';.org') || nStripped.startsWith('.org') || nStripped.startsWith('; ***')) && sawData) {
                        break;
                    }
                    if (nStripped === '' && sawData) {
                        break;
                    }

                    blockLines.push(nextLine);

                    if (nStripped.startsWith(';mptblcname')) {
                        const parts = nStripped.split(/\s+/);
                        if (parts.length > 1) blockCname = parts[1];
                    } else if (nStripped.startsWith(';mptbllname')) {
                        const parts = nStripped.split(/\s+/);
                        if (parts.length > 1) blockLname = parts[1];
                    } else if (nStripped.startsWith(';mptbldesc')) {
                        hasDesc = true;
                        descLineIdx = blockLines.length - 1;
                        const parts = nStripped.split(/\s+/, 2);
                        descVal = nStripped.substring(parts[0].length).trim();
                        const matchIndent = nextLine.match(/^\s*/);
                        descIndent = matchIndent ? matchIndent[0] : '    ';
                    } else if (nStripped.startsWith('.byte') || nStripped.startsWith('.word')) {
                        sawData = true;
                        if (firstDataIdx === -1) {
                            firstDataIdx = blockLines.length - 1;
                        }
                    }

                    if (sawData && j + 1 < n) {
                        const peek = lines[j + 1].trim();
                        if ((/^([A-Za-z0-9_]+):/.test(peek) && !peek.startsWith(';')) || peek.startsWith(';mptblcname')) {
                            j++;
                            break;
                        }
                    }

                    j++;
                }

                // Match with descriptor database
                let descTarget = null;
                if (blockCname && byCname.has(blockCname.toLowerCase())) {
                    descTarget = byCname.get(blockCname.toLowerCase());
                } else if (blockLabel && byLabel.has(blockLabel.toLowerCase())) {
                    descTarget = byLabel.get(blockLabel.toLowerCase());
                } else if (blockLname && byLname.has(blockLname.toLowerCase())) {
                    descTarget = byLname.get(blockLname.toLowerCase());
                }

                if (descTarget && descTarget.mptune_desc) {
                    const targetMptune = descTarget.mptune_desc;

                    if (hasDesc) {
                        const isPlaceholder = !descVal || PLACEHOLDER_REGEX.test(descVal);
                        const delimitedIdx = descVal.indexOf(DELIMITED_OVERVIEW);
                        let newDescVal;

                        if (isPlaceholder || descVal.startsWith(OVERVIEW_PREFIX)) {
                            newDescVal = targetMptune;
                        } else if (delimitedIdx !== -1) {
                            const existingPrefix = descVal.substring(0, delimitedIdx);
                            if (!existingPrefix || PLACEHOLDER_REGEX.test(existingPrefix)) {
                                newDescVal = targetMptune;
                            } else {
                                newDescVal = `${existingPrefix}${DELIMITER}${targetMptune}`;
                            }
                        } else if (descVal.endsWith(DELIMITER)) {
                            newDescVal = `${descVal}${targetMptune}`;
                        } else {
                            newDescVal = `${descVal}${DELIMITER}${targetMptune}`;
                        }

                        if (newDescVal !== descVal) {
                            blockLines[descLineIdx] = `${descIndent};mptbldesc ${newDescVal}`;
                            totalUpdated++;
                        }
                    } else {
                        const insertLine = `${descIndent};mptbldesc ${targetMptune}`;
                        if (firstDataIdx !== -1) {
                            blockLines.splice(firstDataIdx, 0, insertLine);
                        } else {
                            blockLines.push(insertLine);
                        }
                        totalUpdated++;
                    }
                }

                for (let b = 0; b < blockLines.length; b++) {
                    updatedLines.push(blockLines[b]);
                }

                i = j;
            } else {
                updatedLines.push(line);
                i++;
            }
        }

        return {
            updatedText: updatedLines.join(newline),
            totalUpdated: totalUpdated
        };
    }

    /**
     * Apply descriptors from a specific ECM database to state.originalText.
     */
    async function applyEcmUpdate(ecmId) {
        if (!state.originalText || !ecmId) return false;

        const config = ECM_CONFIGS[ecmId];
        if (!config) return false;

        state.activeEcmId = ecmId;
        updateDbBadge('', `Loading ${config.code} DB...`);

        // Reset UI status
        if (elements.ecmNoticeBox) elements.ecmNoticeBox.classList.add('hidden');
        if (elements.statUpdatedSummary) elements.statUpdatedSummary.classList.add('hidden');
        if (elements.savedStatusText) elements.savedStatusText.classList.add('hidden');
        if (elements.downloadBtn) elements.downloadBtn.disabled = true;

        const descriptors = await loadDescriptorsForEcm(ecmId);

        if (!descriptors) {
            updateDbBadge('error', `DB Missing: ${config.code}`);
            if (elements.ecmNoticeBox) {
                elements.ecmNoticeBox.innerHTML = `
                    <strong>Descriptors database not found:</strong> The database file <code>${config.jsonFile}</code> for <strong>${config.displayName}</strong> has not yet been generated or is offline.<br><br>
                    <em>Currently available databases: LM (367 descriptors), SMEC (518 descriptors).</em>
                `;
                elements.ecmNoticeBox.classList.remove('hidden');
            }
            if (elements.statUpdatedSummary) elements.statUpdatedSummary.textContent = '';
            if (elements.downloadBtn) elements.downloadBtn.disabled = true;
            return false;
        }

        const count = descriptors.total_identifiers || 
                      Object.keys(descriptors.descriptors || descriptors || {}).length;
        updateDbBadge('ready', `DB: ${count} Descriptors (${config.code})`);

        const result = processTpl(state.originalText, descriptors);
        state.updatedText = result.updatedText;
        state.totalUpdated = result.totalUpdated;

        if (elements.statUpdatedSummary) {
            elements.statUpdatedSummary.textContent = `✓ Injected ${result.totalUpdated} table descriptions using ${config.displayName} database (${count} descriptors available)`;
            elements.statUpdatedSummary.classList.remove('hidden');
        }

        if (elements.downloadBtn) elements.downloadBtn.disabled = false;
        return true;
    }

    // Open file picker
    async function openFilePicker() {
        if ('showOpenFilePicker' in window) {
            try {
                const [handle] = await window.showOpenFilePicker({
                    types: [{
                        description: 'MPTune Calibration File (*.tpl)',
                        accept: { 'text/plain': ['.tpl', '.txt'] }
                    }],
                    multiple: false
                });
                state.fileHandle = handle;
                const file = await handle.getFile();
                handleFile(file);
                return;
            } catch (err) {
                if (err.name === 'AbortError') return;
                console.warn('showOpenFilePicker error, falling back:', err);
            }
        }
        elements.fileInput.value = '';
        elements.fileInput.click();
    }

    // Process file reading
    function handleFile(file) {
        if (!file) return;

        state.originalFileName = file.name;
        state.outputFileName = getSafeUpdatedFilename(file.name);

        const reader = new FileReader();
        reader.onload = async function (e) {
            state.originalText = e.target.result;
            showReadyView();

            const detected = detectEcmFamily(state.originalText, file.name);

            if (detected) {
                // Auto-detection succeeded:
                // Keep dropdown hidden, display detected badge clearly
                state.detectedEcm = detected;
                if (elements.ecmDetectedBadge) elements.ecmDetectedBadge.classList.remove('hidden');
                if (elements.ecmDetectedName) elements.ecmDetectedName.textContent = `${detected.code} — ${detected.displayName}`;
                if (elements.ecmFallbackContainer) elements.ecmFallbackContainer.classList.add('hidden');

                await applyEcmUpdate(detected.id);
            } else {
                // Auto-detection could not determine ECM type:
                // Hide badge and reveal the fallback dropdown selector
                state.detectedEcm = null;
                if (elements.ecmDetectedBadge) elements.ecmDetectedBadge.classList.add('hidden');
                if (elements.ecmFallbackContainer) elements.ecmFallbackContainer.classList.remove('hidden');
                if (elements.ecmFallbackApplyBtn) elements.ecmFallbackApplyBtn.disabled = true;
                if (elements.ecmFallbackSelect) elements.ecmFallbackSelect.value = '';
                if (elements.downloadBtn) elements.downloadBtn.disabled = true;
                if (elements.statUpdatedSummary) elements.statUpdatedSummary.classList.add('hidden');
                updateDbBadge('', 'Awaiting ECM Selection');
            }
        };

        reader.onerror = function () {
            alert('Failed to read calibration file. Please check file permissions.');
        };

        reader.readAsText(file);
    }

    // UI View transition
    function showReadyView() {
        elements.loadedFileName.textContent = state.originalFileName;
        elements.statOutputFile.textContent = state.outputFileName;
        elements.savedStatusText.classList.add('hidden');

        elements.uploadBox.classList.add('hidden');
        elements.readyBox.classList.remove('hidden');
    }

    function resetView() {
        state.originalFileName = '';
        state.originalText = '';
        state.updatedText = '';
        state.outputFileName = '';
        state.totalUpdated = 0;
        state.fileHandle = null;
        state.detectedEcm = null;
        state.activeEcmId = null;

        elements.readyBox.classList.add('hidden');
        elements.uploadBox.classList.remove('hidden');
        elements.savedStatusText.classList.add('hidden');

        if (elements.ecmDetectedBadge) elements.ecmDetectedBadge.classList.add('hidden');
        if (elements.ecmFallbackContainer) elements.ecmFallbackContainer.classList.add('hidden');
        if (elements.ecmNoticeBox) elements.ecmNoticeBox.classList.add('hidden');
        if (elements.statUpdatedSummary) {
            elements.statUpdatedSummary.textContent = '';
            elements.statUpdatedSummary.classList.add('hidden');
        }
        if (elements.downloadBtn) elements.downloadBtn.disabled = false;
    }

    // Save Updated File
    async function saveUpdatedFile() {
        if (!state.updatedText) return;

        if ('showSaveFilePicker' in window) {
            try {
                const options = {
                    suggestedName: state.outputFileName,
                    types: [{
                        description: 'MPTune Calibration File (*.tpl)',
                        accept: { 'text/plain': ['.tpl', '.txt'] }
                    }]
                };

                if (state.fileHandle) {
                    options.startIn = state.fileHandle;
                }

                const handle = await window.showSaveFilePicker(options);
                const writable = await handle.createWritable();
                await writable.write(state.updatedText);
                await writable.close();

                elements.savedStatusText.textContent = `✓ Saved ${handle.name}! (${state.totalUpdated} descriptors updated)`;
                elements.savedStatusText.classList.remove('hidden');
                return;
            } catch (err) {
                if (err.name === 'AbortError') return;
                console.warn('showSaveFilePicker failed, falling back to download:', err);
            }
        }

        // Fallback: Blob download
        const blob = new Blob([state.updatedText], { type: 'text/plain;charset=utf-8' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = state.outputFileName;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);

        elements.savedStatusText.textContent = `✓ Downloaded ${state.outputFileName}! (${state.totalUpdated} descriptors updated)`;
        elements.savedStatusText.classList.remove('hidden');
    }

    // Handle ECM Navigation
    function setupEcmNavigation() {
        const ecmButtons = document.querySelectorAll('.ecm-button');
        ecmButtons.forEach(btn => {
            btn.addEventListener('click', (e) => {
                const target = btn.getAttribute('data-target');
                const ecmName = btn.getAttribute('data-name');
                const isReady = btn.getAttribute('data-ready') === 'true';

                if (isReady && target) {
                    window.location.href = target;
                } else {
                    e.preventDefault();
                    showNoticeModal(ecmName);
                }
            });
        });

        if (elements.modalCloseBtn) {
            elements.modalCloseBtn.addEventListener('click', hideNoticeModal);
        }

        if (elements.noticeModal) {
            elements.noticeModal.addEventListener('click', (e) => {
                if (e.target === elements.noticeModal) hideNoticeModal();
            });
        }
    }

    function showNoticeModal(ecmName) {
        if (!elements.noticeModal) return;
        elements.modalTitle.textContent = `${ecmName} Documentation`;
        elements.modalDesc.textContent = `The disassembly analysis and calibration reference for ${ecmName} is currently in progress. Assembly routines and template definitions are actively being processed into the centralized database.`;
        elements.noticeModal.classList.remove('hidden');
    }

    function hideNoticeModal() {
        if (!elements.noticeModal) return;
        elements.noticeModal.classList.add('hidden');
    }

    // Setup drag-and-drop & user interaction
    function setupEvents() {
        elements.browseBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            openFilePicker();
        });

        elements.uploadBox.addEventListener('click', openFilePicker);

        elements.fileInput.addEventListener('change', (e) => {
            if (e.target.files && e.target.files.length > 0) {
                state.fileHandle = null;
                handleFile(e.target.files[0]);
            }
        });

        ['dragenter', 'dragover'].forEach(eventName => {
            elements.uploadBox.addEventListener(eventName, (e) => {
                e.preventDefault();
                e.stopPropagation();
                elements.uploadBox.classList.add('dragover');
            });
        });

        ['dragleave', 'drop'].forEach(eventName => {
            elements.uploadBox.addEventListener(eventName, (e) => {
                e.preventDefault();
                e.stopPropagation();
                elements.uploadBox.classList.remove('dragover');
            });
        });

        elements.uploadBox.addEventListener('drop', async (e) => {
            const dt = e.dataTransfer;
            if (!dt) return;

            if (dt.items && dt.items.length > 0 && 'getAsFileSystemHandle' in dt.items[0]) {
                try {
                    const handle = await dt.items[0].getAsFileSystemHandle();
                    if (handle && handle.kind === 'file') {
                        state.fileHandle = handle;
                        const file = await handle.getFile();
                        handleFile(file);
                        return;
                    }
                } catch (err) {
                    console.warn('getAsFileSystemHandle fallback:', err);
                }
            }

            if (dt.files && dt.files.length > 0) {
                state.fileHandle = null;
                handleFile(dt.files[0]);
            }
        });

        elements.downloadBtn.addEventListener('click', saveUpdatedFile);
        elements.resetBtn.addEventListener('click', resetView);

        // Fallback dropdown event listeners
        if (elements.ecmFallbackSelect) {
            elements.ecmFallbackSelect.addEventListener('change', () => {
                if (elements.ecmFallbackApplyBtn) {
                    elements.ecmFallbackApplyBtn.disabled = !elements.ecmFallbackSelect.value;
                }
            });
        }

        if (elements.ecmFallbackApplyBtn) {
            elements.ecmFallbackApplyBtn.addEventListener('click', async () => {
                const selectedId = elements.ecmFallbackSelect.value;
                if (selectedId) {
                    await applyEcmUpdate(selectedId);
                }
            });
        }

        // Sync theme toggle button text on load
        const initialTheme = document.documentElement.getAttribute('data-theme') || 'dark';
        elements.themeToggle.textContent = initialTheme === 'dark' ? 'Light Theme' : 'Dark Theme';
        try {
            localStorage.setItem('mptune_theme', initialTheme);
            window.name = 'mptune_theme=' + initialTheme;
        } catch (e) {}

        // Theme Toggle
        elements.themeToggle.addEventListener('click', () => {
            const currentTheme = document.documentElement.getAttribute('data-theme') || 'dark';
            const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
            document.documentElement.setAttribute('data-theme', newTheme);
            elements.themeToggle.textContent = newTheme === 'dark' ? 'Light Theme' : 'Dark Theme';
            try {
                localStorage.setItem('mptune_theme', newTheme);
                window.name = 'mptune_theme=' + newTheme;
            } catch (e) {}
        });

        setupEcmNavigation();
    }

    // Init
    async function init() {
        populateFallbackSelector();
        await checkAvailableDatabases();
        setupEvents();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

})();
