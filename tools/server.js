/**
 * tools/server.js
 * Lightweight zero-dependency static web server for local testing.
 * Serves output/ directory on http://localhost:8080 and automatically opens the browser.
 */

const http = require('http');
const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');

const PORT = 8080;
const ROOT_DIR = path.resolve(__dirname, '..', 'output');

const MIME_TYPES = {
    '.html': 'text/html; charset=UTF-8',
    '.css': 'text/css; charset=UTF-8',
    '.js': 'application/javascript; charset=UTF-8',
    '.json': 'application/json; charset=UTF-8',
    '.png': 'image/png',
    '.jpg': 'image/jpeg',
    '.jpeg': 'image/jpeg',
    '.gif': 'image/gif',
    '.svg': 'image/svg+xml',
    '.ico': 'image/x-icon',
    '.tpl': 'text/plain; charset=UTF-8',
    '.asm': 'text/plain; charset=UTF-8',
    '.txt': 'text/plain; charset=UTF-8',
    '.md': 'text/markdown; charset=UTF-8'
};

const server = http.createServer((req, res) => {
    // Add CORS headers so all local fetch requests succeed smoothly
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', '*');

    if (req.method === 'OPTIONS') {
        res.writeHead(204);
        res.end();
        return;
    }

    // Parse requested URL path
    let reqPath = decodeURI(req.url.split('?')[0]);
    if (reqPath === '/') {
        reqPath = '/index.html';
    }

    let filePath = path.join(ROOT_DIR, reqPath);

    // Prevent directory traversal
    if (!filePath.startsWith(ROOT_DIR)) {
        res.writeHead(403, { 'Content-Type': 'text/plain' });
        res.end('403 Forbidden');
        return;
    }

    fs.stat(filePath, (err, stats) => {
        if (err) {
            res.writeHead(404, { 'Content-Type': 'text/plain' });
            res.end(`404 Not Found: ${reqPath}`);
            return;
        }

        // If directory, look for index.html
        if (stats.isDirectory()) {
            filePath = path.join(filePath, 'index.html');
        }

        fs.readFile(filePath, (readErr, data) => {
            if (readErr) {
                res.writeHead(404, { 'Content-Type': 'text/plain' });
                res.end(`404 Not Found: ${reqPath}`);
                return;
            }

            const ext = path.extname(filePath).toLowerCase();
            const mimeType = MIME_TYPES[ext] || 'application/octet-stream';

            res.writeHead(200, {
                'Content-Type': mimeType,
                'Content-Length': data.length,
                'Cache-Control': 'no-cache'
            });
            res.end(data);
        });
    });
});

server.listen(PORT, () => {
    const url = `http://localhost:${PORT}`;
    console.log('====================================================');
    console.log('  Chrysler Turbo Calibration & Docs Web Server');
    console.log('====================================================');
    console.log(`  Serving folder: ${ROOT_DIR}`);
    console.log(`  Access URL:     ${url}`);
    console.log('  Press Ctrl+C to stop the server.');
    console.log('====================================================');

    // Automatically open default browser on Windows
    exec(`start ${url}`);
});
